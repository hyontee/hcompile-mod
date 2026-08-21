#include <a_samp>
#include <sscanf2>
#include <Pawn.CMD>
#include <a_mysql>

#if !defined cache_get_value_name
    #define cache_get_value_name(%0,%1,%2,%3) cache_get_field_content(%0,%1,%2,g_SQLHandle,%3)
#endif

#if !defined cache_get_value_name_int
    #define cache_get_value_name_int(%0,%1,%2) %2 = _:cache_get_field_content_int(%0,%1)
#endif

#define MYSQL_HOST "127.0.0.1"
#define MYSQL_USER "user42123"
#define MYSQL_PASS "2yVw08AHKQFo"
#define MYSQL_DB   "user42123"

#define COLOR_WHITE     0xFFFFFFFF
#define COLOR_YELLOW    0xFFFF00FF
#define COLOR_RED       0xFF0000FF
#define COLOR_GREEN     0x33CC33FF
#define COLOR_ADMIN     0xFF6600FF
#define MAX_ADMIN_LEVEL (14)

new const g_AdminLevelNames[MAX_ADMIN_LEVEL + 1][64] =
{
    "Игрок",
    "Младший модератор",
    "Модератор",
    "Старший модератор",
    "Администратор",
    "Старший администратор",
    "ГС/ЗГС",
    "Куратор администрации",
    "Технический специалист",
    "Зам. главного администратора",
    "Главный администратор",
    "Команда проекта",
    "Заместитель основателя",
    "Разработчик",
    "Основатель"
};

enum
{
    DIALOG_REGISTER = 1,
    DIALOG_LOGIN,
    DIALOG_GENDER,
    DIALOG_SPAWN,
    DIALOG_ADMIN_HELP,
    DIALOG_ADMINS_LIST,
    DIALOG_PLAYER_MENU,
    DIALOG_ADMIN_LOGIN,
    DIALOG_ADMIN_REG
}

new Float:g_Spawns[][4] =
{
    {846.602600, 796.555847, 13.400512, 50.0},
    {2740.712158, -2441.565185, 21.774286, 50.0},
    {-2429.236083, 203.175277, 26.096101, 50.0},
    {1801.694091, 2523.137695, 14.602633, 50.0},
    {-2667.526611, 2006.567016, 11.197804, 50.0},
    {-2159.371093, 1558.103271, 9.840852, 50.0}
};


enum E_PLAYER_DATA
{
    pID,
    bool:pLogged,
    pPassword[64],
    pSkin,
    pGender,
    pColor,
    pColorStr[7],

    pMoney,
    pAdmin,
    pAdminPass,
    pAdminWarn,
    pAdminLoginAttempts,
    bool:pAdminAuth,
    bool:pAdminDuty,
    bool:pMuted,
    pMuteExpire,
    bool:pFrozen,
    bool:pJailed,
    pJailExpire,
    bool:pBanned,
    pBanReason[128],
    pIP[16]
}

new gPlayerData[MAX_PLAYERS][E_PLAYER_DATA];
new g_SQLHandle;

forward ResetPlayerData(playerid);
forward SendWelcomeMessages(playerid);
forward SaveAccount(playerid);
forward OnAccountCheck(playerid);
forward OnAccountRegister(playerid);
forward OnAccountLogin(playerid);
forward UnfreezePlayer(playerid);
forward SpawnPlayerAtRandomPoint(playerid);
forward MoneySyncTick();
forward JailTick(playerid);
forward MuteTick(playerid);

main()
{
    print("\n----------------------------------");
    print(" Мод с 0 By whist ураааа");
    print("----------------------------------\n");
}

public OnGameModeInit()
{
    SetGameModeText("whist RP MySQL");
    ShowNameTags(1);
    ShowPlayerMarkers(PLAYER_MARKERS_MODE_GLOBAL);

    DisableInteriorEnterExits();
    EnableStuntBonusForAll(0);

    g_SQLHandle = _:mysql_connect(MYSQL_HOST, MYSQL_USER, MYSQL_DB, MYSQL_PASS);
    if(mysql_errno(g_SQLHandle) != 0)
    {
        printf("[MySQL] Connection Error!");
    }
    else
    {
        printf("[MySQL] Connected successfully to %s", MYSQL_DB);
    }

    AddPlayerClass(0, g_Spawns[0][0], g_Spawns[0][1], g_Spawns[0][2], g_Spawns[0][3], 0, 0, 0, 0, 0, 0);

    SetTimer("MoneySyncTick", 30000, true);

    AutumnEvent_OnGameModeInit();
    return 1;
}

public OnGameModeExit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged])
        {
            SaveAccount(i);
        }
    }
    mysql_close(g_SQLHandle);
    return 1;
}

public OnPlayerConnect(playerid)
{
    ResetPlayerData(playerid);
    GetPlayerIp(playerid, gPlayerData[playerid][pIP], 16);

    AutumnEvent_OnPlayerConnect(playerid);
    TogglePlayerSpectating(playerid, 1);

    if(mysql_errno(g_SQLHandle) != 0)
    {
        SendClientMessage(playerid, COLOR_RED, "Ошибка базы данных. Попробуйте зайти позже.");
        Kick(playerid);
        return 1;
    }

    new name[MAX_PLAYER_NAME], query[128];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_format(g_SQLHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `name` = '%e' LIMIT 1", name);
    mysql_tquery(g_SQLHandle, query, "OnAccountCheck", "i", playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    if(gPlayerData[playerid][pLogged])
    {
        SaveAccount(playerid);
    }
    ResetPlayerData(playerid);
    AutumnEvent_OnPlayerDisconnect(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(!gPlayerData[playerid][pLogged])
    {
        Kick(playerid);
        return 1;
    }

    SetPlayerColor(playerid, gPlayerData[playerid][pColor]);
    SetPlayerVelocity(playerid, 0.0, 0.0, 0.0);
    ClearAnimations(playerid);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetPlayerHealth(playerid, 100.0);

    if(gPlayerData[playerid][pFrozen])
    {
        TogglePlayerControllable(playerid, false);
    }

    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    // SummerEvent_OnPlayerDeath - removed, no equivalent in autumn_event.inc
    return 1;
}

public OnPlayerUpdate(playerid)
{
    // SummerEvent_OnPlayerUpdate - removed, no equivalent in autumn_event.inc
    return 1;
}

public OnPlayerText(playerid, text[])
{
    if(!gPlayerData[playerid][pLogged]) return 0;

    if(gPlayerData[playerid][pMuted])
    {
        SendClientMessage(playerid, COLOR_ADMIN, "Вы не можете писать в чат: вы в муте.");
        return 0;
    }

    new name[MAX_PLAYER_NAME], chatStr[256];
    GetPlayerName(playerid, name, sizeof(name));

    if(gPlayerData[playerid][pAdmin] > 0 && gPlayerData[playerid][pAdminDuty])
    {
        format(chatStr, sizeof(chatStr), "- %s ({FF6600}%s{FFFFFF} [%s]) [{%s}%d{FFFFFF}]",
            text, name, g_AdminLevelNames[gPlayerData[playerid][pAdmin]], gPlayerData[playerid][pColorStr], playerid);
    }
    else
    {
        format(chatStr, sizeof(chatStr), "- %s ({%s}%s{FFFFFF}) [{%s}%d{FFFFFF}]", text, gPlayerData[playerid][pColorStr], name, gPlayerData[playerid][pColorStr], playerid);
    }
    SendClientMessageToAll(COLOR_WHITE, chatStr);

    return 0;
}

public OnAccountCheck(playerid)
{
    new rows = cache_num_rows();
    if(rows > 0)
    {
        cache_get_value_name(0, "password", gPlayerData[playerid][pPassword], 64);
        cache_get_value_name_int(0, "id", gPlayerData[playerid][pID]);

        new banned, banExpire;
        cache_get_value_name_int(0, "banned", banned);
        cache_get_value_name_int(0, "ban_expire", banExpire);

        if(banned)
        {
            if(banExpire > 0 && gettime() >= banExpire)
            {
                new unbanQuery[192];
                mysql_format(g_SQLHandle, unbanQuery, sizeof(unbanQuery),
                    "UPDATE `users` SET `banned` = 0, `ban_reason` = '', `ban_expire` = 0 WHERE `id` = %d LIMIT 1",
                    gPlayerData[playerid][pID]);
                mysql_tquery(g_SQLHandle, unbanQuery);
            }
            else
            {
                new reason[128], kickMsg[192];
                cache_get_value_name(0, "ban_reason", reason, 128);
                if(banExpire > 0)
                    format(kickMsg, sizeof(kickMsg), "Вы забанены. Причина: %s | До: %s", reason, "срок действия активен");
                else
                    format(kickMsg, sizeof(kickMsg), "Вы забанены. Причина: %s", reason);

                SendClientMessage(playerid, COLOR_RED, kickMsg);
                SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid);
                return 1;
            }
        }

        ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Авторизация", "{FFFFFF}Ваш аккаунт зарегистрирован!\nВведите ваш пароль:", "Войти", "Выход");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Регистрация", "{FFFFFF}Добро пожаловать на whist RP!\nПридумайте пароль для регистрации:", "Далее", "Выход");
    }
    return 1;
}

forward KickPlayerDelayed(playerid);
public KickPlayerDelayed(playerid)
{
    if(IsPlayerConnected(playerid)) Kick(playerid);
    return 1;
}

public OnAccountRegister(playerid)
{
    gPlayerData[playerid][pID] = cache_insert_id();
    gPlayerData[playerid][pLogged] = true;

    ShowPlayerDialog(playerid, DIALOG_GENDER, DIALOG_STYLE_LIST,
        "whist RP | Выбор пола",
        "{FFFFFF}Вы завершили регистрацию, теперь выберите пол вашего персонажа.\n\nМужской\nЖенский",
        "Выбрать", "Выход");
    return 1;
}

public OnAccountLogin(playerid)
{
    cache_get_value_name_int(0, "skin", gPlayerData[playerid][pSkin]);
    cache_get_value_name_int(0, "gender", gPlayerData[playerid][pGender]);
    cache_get_value_name_int(0, "money", gPlayerData[playerid][pMoney]);
    cache_get_value_name_int(0, "admin", gPlayerData[playerid][pAdmin]);
    cache_get_value_name_int(0, "admin_pass", gPlayerData[playerid][pAdminPass]);
    cache_get_value_name_int(0, "admin_warn", gPlayerData[playerid][pAdminWarn]);

    gPlayerData[playerid][pAdminAuth] = false;
    gPlayerData[playerid][pAdminDuty] = false;
    gPlayerData[playerid][pAdminLoginAttempts] = 0;

    new muteExpire, jailExpire;
    cache_get_value_name_int(0, "mute_expire", muteExpire);
    cache_get_value_name_int(0, "jail_expire", jailExpire);

    if(gettime() < muteExpire)
    {
        gPlayerData[playerid][pMuted] = true;
        gPlayerData[playerid][pMuteExpire] = muteExpire;
        SetTimerEx("MuteTick", (muteExpire - gettime()) * 1000, false, "i", playerid);
    }

    if(gettime() < jailExpire)
    {
        gPlayerData[playerid][pJailed] = true;
        gPlayerData[playerid][pJailExpire] = jailExpire;
        SetTimerEx("JailTick", (jailExpire - gettime()) * 1000, false, "i", playerid);
    }

    if(gPlayerData[playerid][pAdmin] > MAX_ADMIN_LEVEL) gPlayerData[playerid][pAdmin] = MAX_ADMIN_LEVEL;

    gPlayerData[playerid][pLogged] = true;
    SpawnPlayerAtRandomPoint(playerid);
    SendWelcomeMessages(playerid);

    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, gPlayerData[playerid][pMoney]);

    if(gPlayerData[playerid][pJailed])
    {
        SendClientMessage(playerid, COLOR_ADMIN, "Вы находитесь в тюрьме.");
    }

    if(gPlayerData[playerid][pAdmin] > 0)
    {
        Admin_AuthorizationComplete(playerid);
    }

    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(AutumnEvent_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))
        return 1;

    if(Admin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))
        return 1;

    if(dialogid == DIALOG_REGISTER)
    {
        if(!response)
        {
            Kick(playerid);
            return 1;
        }

        if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
        {
            ShowPlayerDialog(playerid, DIALOG_REGISTER, DIALOG_STYLE_PASSWORD, "Регистрация", "{FFFFFF}Пароль должен быть от 4 до 32 символов!\nВведите пароль снова:", "Далее", "Выход");
            return 1;
        }

        new name[MAX_PLAYER_NAME], query[256];
        GetPlayerName(playerid, name, sizeof(name));
        format(gPlayerData[playerid][pPassword], 64, "%s", inputtext);

        gPlayerData[playerid][pSkin] = 78;
        gPlayerData[playerid][pGender] = 0;

        mysql_format(g_SQLHandle, query, sizeof(query), "INSERT INTO `users` (`name`, `password`, `skin`, `gender`, `money`, `admin`) VALUES ('%e', '%e', %d, %d, %d, %d)", name, inputtext, 78, 0, 5000, 0);
        mysql_tquery(g_SQLHandle, query, "OnAccountRegister", "i", playerid);
        return 1;
    }

    if(dialogid == DIALOG_LOGIN)
    {
        if(!response)
        {
            Kick(playerid);
            return 1;
        }

        if(!strcmp(inputtext, gPlayerData[playerid][pPassword], false))
        {
            new name[MAX_PLAYER_NAME], query[128];
            GetPlayerName(playerid, name, sizeof(name));
            mysql_format(g_SQLHandle, query, sizeof(query), "SELECT * FROM `users` WHERE `name` = '%e' LIMIT 1", name);
            mysql_tquery(g_SQLHandle, query, "OnAccountLogin", "i", playerid);
        }
        else
        {
            ShowPlayerDialog(playerid, DIALOG_LOGIN, DIALOG_STYLE_PASSWORD, "Авторизация", "{FF0000}Неверный пароль!\n{FFFFFF}Введите пароль снова:", "Войти", "Выход");
        }
        return 1;
    }

    if(dialogid == DIALOG_GENDER)
    {
        if(!response)
        {
            Kick(playerid);
            return 1;
        }

        if(listitem == 0)
        {
            gPlayerData[playerid][pSkin] = 78;
            gPlayerData[playerid][pGender] = 0;
        }
        else
        {
            gPlayerData[playerid][pSkin] = 135;
            gPlayerData[playerid][pGender] = 1;
        }

        new query[128];
        mysql_format(g_SQLHandle, query, sizeof(query), "UPDATE `users` SET `skin` = %d, `gender` = %d WHERE `id` = %d",
            gPlayerData[playerid][pSkin], gPlayerData[playerid][pGender], gPlayerData[playerid][pID]);
        mysql_tquery(g_SQLHandle, query);

        gPlayerData[playerid][pMoney] = 5000;
        SpawnPlayerAtRandomPoint(playerid);
        SendWelcomeMessages(playerid);
        ResetPlayerMoney(playerid);
        GivePlayerMoney(playerid, gPlayerData[playerid][pMoney]);
        return 1;
    }

    if(dialogid == DIALOG_SPAWN)
    {
        if(!response) return 1;

        SetPlayerPos(playerid, g_Spawns[listitem][0], g_Spawns[listitem][1], g_Spawns[listitem][2]);
        SetPlayerFacingAngle(playerid, g_Spawns[listitem][3]);
        SetPlayerVirtualWorld(playerid, 0);
        SetPlayerInterior(playerid, 0);
        SetPlayerHealth(playerid, 100.0);
        SetCameraBehindPlayer(playerid);

        SendClientMessage(playerid, COLOR_WHITE, "Вы телепортированы на выбранный спавн.");
        return 1;
    }

    return 1;
}

CMD:spawn(playerid, params[])
{
    ShowSpawnDialog(playerid);
    return 1;
}

ShowSpawnDialog(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_SPAWN, DIALOG_STYLE_LIST,
        "Выбор точки спавна",
        "Спавн 1\nСпавн 2\nСпавн 3\nСпавн 4\nСпавн 5\nСпавн 6",
        "Выбрать", "Закрыть");
    return 1;
}

public UnfreezePlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    ClearAnimations(playerid);
    if(!gPlayerData[playerid][pFrozen])
        TogglePlayerControllable(playerid, true);
    return 1;
}

public SpawnPlayerAtRandomPoint(playerid)
{
    new rand = random(sizeof(g_Spawns));

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    SetSpawnInfo(playerid, 0, gPlayerData[playerid][pSkin],
        g_Spawns[rand][0], g_Spawns[rand][1], g_Spawns[rand][2], g_Spawns[rand][3],
        0, 0, 0, 0, 0, 0);

    TogglePlayerSpectating(playerid, 0);
    TogglePlayerControllable(playerid, false);

    SpawnPlayer(playerid);

    SetPlayerSkin(playerid, gPlayerData[playerid][pSkin]);
    SetPlayerColor(playerid, gPlayerData[playerid][pColor]);
    SetCameraBehindPlayer(playerid);

    SetTimerEx("UnfreezePlayer", 500, false, "i", playerid);
    return 1;
}

public ResetPlayerData(playerid)
{
    gPlayerData[playerid][pID] = 0;
    gPlayerData[playerid][pLogged] = false;
    gPlayerData[playerid][pPassword][0] = '\0';
    gPlayerData[playerid][pSkin] = 78;
    gPlayerData[playerid][pGender] = 0;
    gPlayerData[playerid][pColor] = COLOR_WHITE;
    format(gPlayerData[playerid][pColorStr], 7, "FFFFFF");

    gPlayerData[playerid][pMoney] = 0;
    gPlayerData[playerid][pAdmin] = 0;
    gPlayerData[playerid][pAdminPass] = 0;
    gPlayerData[playerid][pAdminWarn] = 0;
    gPlayerData[playerid][pAdminLoginAttempts] = 0;
    gPlayerData[playerid][pAdminAuth] = false;
    gPlayerData[playerid][pAdminDuty] = false;
    gPlayerData[playerid][pMuted] = false;
    gPlayerData[playerid][pMuteExpire] = 0;
    gPlayerData[playerid][pFrozen] = false;
    gPlayerData[playerid][pJailed] = false;
    gPlayerData[playerid][pJailExpire] = 0;
    gPlayerData[playerid][pBanned] = false;
    gPlayerData[playerid][pBanReason][0] = '\0';
    return 1;
}

public SendWelcomeMessages(playerid)
{
    SendClientMessage(playerid, COLOR_WHITE, "Добро пожаловать на {FFFF00}whist RP");
    SendClientMessage(playerid, COLOR_WHITE, "Телеграм канал разработки: {FFFF00}t.me/white_studioya");
    SendClientMessage(playerid, COLOR_WHITE, "Телеграм канал whist'а: {FFFF00}t.me/white_studioya");
    return 1;
}

public SaveAccount(playerid)
{
    if(!gPlayerData[playerid][pLogged]) return 0;

    new query[400];
    mysql_format(g_SQLHandle, query, sizeof(query),
        "UPDATE `users` SET `skin` = %d, `gender` = %d, `money` = %d, `admin` = %d, `admin_pass` = %d, `admin_warn` = %d, `mute_expire` = %d, `jail_expire` = %d WHERE `id` = %d",
        gPlayerData[playerid][pSkin],
        gPlayerData[playerid][pGender],
        gPlayerData[playerid][pMoney],
        gPlayerData[playerid][pAdmin],
        gPlayerData[playerid][pAdminPass],
        gPlayerData[playerid][pAdminWarn],
        gPlayerData[playerid][pMuteExpire],
        gPlayerData[playerid][pJailExpire],
        gPlayerData[playerid][pID]
    );
    mysql_tquery(g_SQLHandle, query);
    return 1;
}

// Каждые 30 секунд подтягиваем реальные деньги игрока (GivePlayerMoney и т.п.
// из любых систем/ивентов) в pMoney и сохраняем в базу.
public MoneySyncTick()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && gPlayerData[i][pLogged])
        {
            gPlayerData[i][pMoney] = GetPlayerMoney(i);
            SaveAccount(i);
        }
    }
    return 1;
}

public MuteTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    gPlayerData[playerid][pMuted] = false;
    gPlayerData[playerid][pMuteExpire] = 0;
    SendClientMessage(playerid, COLOR_GREEN, "Ваш мут истёк, вы снова можете писать в чат.");
    return 1;
}

public JailTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    gPlayerData[playerid][pJailed] = false;
    gPlayerData[playerid][pJailExpire] = 0;
    SpawnPlayerAtRandomPoint(playerid);
    SendClientMessage(playerid, COLOR_GREEN, "Вы освобождены из тюрьмы.");
    return 1;
}

stock IsPlayerLoggedIn(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    return gPlayerData[playerid][pLogged];
}

stock GetPlayerLevel(playerid)
{
    if(!gPlayerData[playerid][pAdminAuth])
        return 0;

    return gPlayerData[playerid][pAdmin];
}

stock SetPlayerLevel(playerid, level)
{
    if(level < 0) level = 0;
    if(level > MAX_ADMIN_LEVEL) level = MAX_ADMIN_LEVEL;
    gPlayerData[playerid][pAdmin] = level;
    SaveAccount(playerid);
    return 1;
}

stock GetPlayerLevelName(playerid)
{
    return g_AdminLevelNames[gPlayerData[playerid][pAdmin]];
}

stock bool:IsPlayerOnDuty(playerid)
{
    return gPlayerData[playerid][pAdminDuty];
}

stock SetPlayerDuty(playerid, bool:toggle)
{
    gPlayerData[playerid][pAdminDuty] = toggle;
    return 1;
}

stock GetPlayerMoneyEx(playerid)
{
    return gPlayerData[playerid][pMoney];
}

stock GivePlayerMoneyEx(playerid, amount)
{
    GivePlayerMoney(playerid, amount);
    gPlayerData[playerid][pMoney] = GetPlayerMoney(playerid);
    SaveAccount(playerid);
    return 1;
}

stock SetPlayerMoneyEx(playerid, amount)
{
    if(amount < 0) amount = 0;
    ResetPlayerMoney(playerid);
    GivePlayerMoney(playerid, amount);
    gPlayerData[playerid][pMoney] = amount;
    SaveAccount(playerid);
    return 1;
}

stock bool:IsPlayerMuted(playerid)
{
    return gPlayerData[playerid][pMuted];
}

stock SetPlayerMuted(playerid, seconds, reason[])
{
    #pragma unused reason
    gPlayerData[playerid][pMuted] = true;
    gPlayerData[playerid][pMuteExpire] = gettime() + seconds;
    SetTimerEx("MuteTick", seconds * 1000, false, "i", playerid);
    return 1;
}

stock SetPlayerUnmuted(playerid)
{
    gPlayerData[playerid][pMuted] = false;
    gPlayerData[playerid][pMuteExpire] = 0;
    return 1;
}

stock bool:IsPlayerFrozenEx(playerid)
{
    return gPlayerData[playerid][pFrozen];
}

stock SetPlayerFrozenEx(playerid, bool:toggle)
{
    gPlayerData[playerid][pFrozen] = toggle;
    TogglePlayerControllable(playerid, !toggle);
    return 1;
}

stock SetPlayerJailedEx(playerid, seconds)
{
    gPlayerData[playerid][pJailed] = true;
    gPlayerData[playerid][pJailExpire] = gettime() + seconds;
    SetTimerEx("JailTick", seconds * 1000, false, "i", playerid);
    return 1;
}

stock SetPlayerUnjailedEx(playerid)
{
    gPlayerData[playerid][pJailed] = false;
    gPlayerData[playerid][pJailExpire] = 0;
    SpawnPlayerAtRandomPoint(playerid);
    return 1;
}

stock GetPlayerNameEx(playerid)
{
    new name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    return name;
}

stock BanPlayerEx(playerid, reason[])
{
    new query[256], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_format(g_SQLHandle, query, sizeof(query), "UPDATE `users` SET `banned` = 1, `ban_reason` = '%e' WHERE `id` = %d", reason, gPlayerData[playerid][pID]);
    mysql_tquery(g_SQLHandle, query);

    new kickMsg[160];
    format(kickMsg, sizeof(kickMsg), "Вы забанены. Причина: %s", reason);
    SendClientMessage(playerid, COLOR_RED, kickMsg);
    SetTimerEx("KickPlayerDelayed", 500, false, "i", playerid);
    return 1;
}

stock UnbanPlayerEx(name[])
{
    new query[256];
    mysql_format(g_SQLHandle, query, sizeof(query), "UPDATE `users` SET `banned` = 0, `ban_reason` = '' WHERE `name` = '%e'", name);
    mysql_tquery(g_SQLHandle, query);
    return 1;
}
// Системки 
#include "whist/autumn_event.inc"
#include "whist/admin.inc"
#include "whist/chat.inc"

public OnRconCommand(cmd[])
{
    new pos = strfind(cmd, " ", true);
    if(pos == -1) return 0;

    new cmdname[32];
    strmid(cmdname, cmd, 0, pos, 32);

    if(!strcmp(cmdname, "setlevel", true))
    {
        new name[MAX_PLAYER_NAME], level, query[128];
        if(sscanf(cmd[pos + 1], "s[24]d", name, level)) return 1;

        mysql_format(g_SQLHandle, query, sizeof(query), "UPDATE `users` SET `admin` = %d WHERE `name` = '%e'", level, name);
        mysql_tquery(g_SQLHandle, query);

        printf("[RCON] Игроку %s выставлен уровень админки %d (вступит в силу при следующем входе).", name, level);
        return 1;
    }
    return 0;
}
