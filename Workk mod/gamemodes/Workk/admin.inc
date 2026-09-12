#if defined _workk_admin_included
    #endinput
#endif
#define _workk_admin_included

#define ADMIN_MIN_LEVEL        (1)
#define ADMIN_MAX_LEVEL        (14)

#define ADMIN_LEVEL_MOD        (2)
#define ADMIN_LEVEL_SRMOD      (3)
#define ADMIN_LEVEL_ADMIN      (4)
#define ADMIN_LEVEL_SENIOR     (5)
#define ADMIN_LEVEL_CURATOR    (7)
#define ADMIN_LEVEL_TECH       (8)
#define ADMIN_LEVEL_DEPUTY     (9)
#define ADMIN_LEVEL_MAIN       (10)
#define ADMIN_LEVEL_PROJECT    (11)
#define ADMIN_LEVEL_FOUNDERDEP (12)
#define ADMIN_LEVEL_DEVELOPER  (13)
#define ADMIN_LEVEL_FOUNDER    (14)

#define ADMIN_COLOR             (0xFF6600FF)
#define ADMIN_NOTICE             (0xFF5533FF)

stock Admin_GetRawLevel(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;
    return gPlayerData[playerid][pAdmin];
}

stock Admin_GetLevel(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 0;

    if(!gPlayerData[playerid][pAdminAuth])
        return 0;

    return gPlayerData[playerid][pAdmin];
}

stock GetPlayerAdminEx(playerid)
{
    return Admin_GetLevel(playerid);
}

stock GetPlayerAdminRaw(playerid)
{
    return Admin_GetRawLevel(playerid);
}

stock bool:Admin_HasAccess(playerid, level)
{
    return Admin_GetLevel(playerid) >= level;
}

stock bool:Admin_IsNumeric(const text[])
{
    if(!strlen(text))
        return false;

    for(new i; text[i] != EOS; i++)
    {
        if(text[i] < '0' || text[i] > '9')
            return false;
    }
    return true;
}

stock Admin_GetPlayerID(const player_name[])
{
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i))
            continue;

        new name[MAX_PLAYER_NAME];
        GetPlayerName(i, name, sizeof(name));

        if(!strcmp(name, player_name, true))
            return i;
    }
    return INVALID_PLAYER_ID;
}

stock Admin_SendToAll(const color, const text[])
{
    SendClientMessageToAll(color, text);
    return 1;
}

stock Admin_SendToAdmins(const color, const text[])
{
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i))
            continue;

        if(Admin_GetLevel(i) > 0)
            SendClientMessage(i, color, text);
    }
    return 1;
}

stock Admin_Log(playerid, action[])
{
    new query[512], admin_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));

    mysql_format(
        g_SQLHandle,
        query,
        sizeof(query),
        "INSERT INTO `admin_logs` (`admin_id`,`admin_name`,`action`,`created_at`) VALUES (%d,'%e','%e',%d)",
        gPlayerData[playerid][pID],
        admin_name,
        action,
        gettime()
    );
    mysql_tquery(g_SQLHandle, query);
    return 1;
}

stock Admin_SaveLevel(playerid, level)
{
    if(level < 0) level = 0;
    if(level > MAX_ADMIN_LEVEL) level = MAX_ADMIN_LEVEL;

    gPlayerData[playerid][pAdmin] = level;

    new query[160];
    mysql_format(
        g_SQLHandle,
        query,
        sizeof(query),
        "UPDATE `users` SET `admin` = %d WHERE `id` = %d LIMIT 1",
        level,
        gPlayerData[playerid][pID]
    );
    mysql_tquery(g_SQLHandle, query);
    return 1;
}

stock Admin_AuthorizationComplete(playerid)
{
    if(!Admin_GetRawLevel(playerid))
        return 0;

    gPlayerData[playerid][pAdminAuth] = true;
    gPlayerData[playerid][pAdminDuty] = true;

    new text[192];
    format(
        text,
        sizeof(text),
        "{32CD32}[A-LOGIN] {FFFFFF}Вы авторизовались как: {FFFF00}%s {FFFFFF}(%d уровень).",
        g_AdminLevelNames[gPlayerData[playerid][pAdmin]],
        gPlayerData[playerid][pAdmin]
    );
    SendClientMessage(playerid, COLOR_GREEN, text);

    SendClientMessage(playerid, COLOR_GREEN, "{32CD32}[A-INFO] {FFFFFF}Для справки используйте /ahelp.");

    format(
        text,
        sizeof(text),
        "{32CD32}[A-LOGIN] {FFFFFF}%s[%d] вошёл в админ-панель: %s",
        GetPlayerNameEx(playerid),
        playerid,
        g_AdminLevelNames[gPlayerData[playerid][pAdmin]]
    );
    Admin_SendToAdmins(0xCCFF00FF, text);

    Admin_Log(playerid, "Авторизация в админ-панели");
    return 1;
}

stock AdminAuthorization(playerid)
{
    if(!Admin_GetRawLevel(playerid))
        return 0;

    if(gPlayerData[playerid][pAdminAuth])
    {
        SendClientMessage(playerid, COLOR_GREEN, "Вы уже авторизованы в админ-панели.");
        return 1;
    }

    if(gPlayerData[playerid][pAdminPass] < 1000 || gPlayerData[playerid][pAdminPass] > 9999)
    {
        ShowPlayerDialog(
            playerid,
            DIALOG_ADMIN_REG,
            DIALOG_STYLE_PASSWORD,
            "Workk RP | Пароль администратора",
            "{FFFFFF}Создайте четырёхзначный пароль для админ-панели.\n\nПароль должен содержать ровно 4 цифры от 1000 до 9999.",
            "Сохранить",
            "Отмена"
        );
        return 1;
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_ADMIN_LOGIN,
        DIALOG_STYLE_PASSWORD,
        "Workk RP | Авторизация администратора",
        "{FFFFFF}Введите четырёхзначный пароль от админ-панели:",
        "Войти",
        "Отмена"
    );
    return 1;
}

stock ShowAdminHelpDialog(playerid)
{
    new text[2600];

    strcat(text, "{E0584B}Основные команды администрации:\n");
    strcat(text, "{FFFFFF}/alogin - авторизация в админ-панели\n");
    strcat(text, "/alogout - выйти из админ-панели\n");
    strcat(text, "/ahelp - список команд\n");
    strcat(text, "/admins - администрация онлайн\n");
    strcat(text, "/admlist - список администраторов\n");
    strcat(text, "/a [текст] - админ-чат\n");
    strcat(text, "/aduty - включить/выключить дежурство\n");
    strcat(text, "/cc - очистить чат\n\n");

    strcat(text, "{E0584B}Модерация:\n");
    strcat(text, "{FFFFFF}/kick [id] [причина]\n");
    strcat(text, "/skick [id]\n");
    strcat(text, "/mute [id] [мин] [причина]\n");
    strcat(text, "/unmute [id] [причина]\n");
    strcat(text, "/jail [id] [мин] [причина]\n");
    strcat(text, "/unjail [id] [причина]\n");
    strcat(text, "/freeze [id]\n");
    strcat(text, "/unfreeze [id]\n");
    strcat(text, "/ban [id/ник] [дни] [причина]\n");
    strcat(text, "/unban [ник]\n");
    strcat(text, "/awarn [id] [причина]\n");
    strcat(text, "/unawarn [id] [причина]\n\n");

    strcat(text, "{E0584B}Телепортация и наблюдение:\n");
    strcat(text, "{FFFFFF}/tp [id]\n");
    strcat(text, "/get [id]\n");
    strcat(text, "/goto [id]\n");
    strcat(text, "/gethere [id]\n");
    strcat(text, "/spectate [id]\n");
    strcat(text, "/unspectate\n");
    strcat(text, "/vw [id] [world]\n");
    strcat(text, "/inter [id] [interior]\n");
    strcat(text, "/getcam\n\n");

    strcat(text, "{E0584B}Игрок:\n");
    strcat(text, "{FFFFFF}/setskin [id] [skin]\n");
    strcat(text, "/myskin [skin]\n");
    strcat(text, "/sethp [id] [hp]\n");
    strcat(text, "/hp [id]\n");
    strcat(text, "/armour [id]\n");
    strcat(text, "/slap [id]\n");
    strcat(text, "/givecash [id] [сумма]\n");
    strcat(text, "/money [id]\n");
    strcat(text, "/getip [id]\n\n");

    strcat(text, "{E0584B}Сервер:\n");
    strcat(text, "{FFFFFF}/settime [0-23]\n");
    strcat(text, "/setweather [id]\n");
    strcat(text, "/agm\n\n");

    strcat(text, "{E0584B}Управление администрацией:\n");
    strcat(text, "{FFFFFF}/setadmin [ник] [уровень]\n");
    strcat(text, "/deladmin [ник]\n");
    strcat(text, "/sethelper [id] - совместимо с Workk как уровень 1\n");
    strcat(text, "/delhelper [id]\n");

    ShowPlayerDialog(
        playerid,
        DIALOG_ADMIN_HELP,
        DIALOG_STYLE_MSGBOX,
        "Workk RP | Команды администрации",
        text,
        "Закрыть",
        ""
    );
    return 1;
}

stock ShowAdminsOnlineDialog(playerid)
{
    new list[4096], line[192];
    list[0] = EOS;

    strcat(list, "{E0584B}Никнейм\tДолжность\tСтатус\n");

    new count;
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !gPlayerData[i][pLogged])
            continue;

        if(Admin_GetLevel(i) <= 0)
            continue;

        new status[48];
        if(gPlayerData[i][pAdminDuty])
            format(status, sizeof(status), "{32CD32}Дежурство");
        else
            format(status, sizeof(status), "{FF9900}Не дежурит");

        format(
            line,
            sizeof(line),
            "{FFFFFF}%s[%d]\t%s\t%s\n",
            GetPlayerNameEx(i),
            i,
            g_AdminLevelNames[gPlayerData[i][pAdmin]],
            status
        );

        if(strlen(list) + strlen(line) >= sizeof(list) - 1)
            break;

        strcat(list, line);
        count++;
    }

    if(!count)
        strcat(list, "{AAAAAA}Администрация не найдена");

    ShowPlayerDialog(
        playerid,
        DIALOG_ADMINS_LIST,
        DIALOG_STYLE_TABLIST_HEADERS,
        "Workk RP | Администрация онлайн",
        list,
        "Закрыть",
        ""
    );
    return 1;
}

stock Admin_GetTarget(params[], &targetid)
{
    if(sscanf(params, "u", targetid))
        return 0;

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return 0;

    return 1;
}

stock bool:Admin_CanTarget(playerid, targetid)
{
    if(targetid == playerid)
        return false;

    if(Admin_GetRawLevel(targetid) >= Admin_GetLevel(playerid))
        return false;

    return true;
}

/* ================================================================
   Dialogs
   ================================================================ */

stock Admin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem

    switch(dialogid)
    {
        case DIALOG_ADMIN_LOGIN:
        {
            if(!response)
            {
                SendClientMessage(playerid, ADMIN_NOTICE, "Авторизация администратора отменена.");
                return 1;
            }

            if(!Admin_IsNumeric(inputtext) || strval(inputtext) != gPlayerData[playerid][pAdminPass])
            {
                gPlayerData[playerid][pAdminLoginAttempts]++;

                if(gPlayerData[playerid][pAdminLoginAttempts] >= 3)
                {
                    new msg[192];
                    format(
                        msg,
                        sizeof(msg),
                        "[A-SECURITY] %s[%d] отключён: три неверные попытки админ-пароля.",
                        GetPlayerNameEx(playerid),
                        playerid
                    );
                    Admin_SendToAdmins(ADMIN_NOTICE, msg);
                    Admin_Log(playerid, "Трижды ввёл неверный админ-пароль");
                    Kick(playerid);
                    return 1;
                }

                new msg[160];
                format(
                    msg,
                    sizeof(msg),
                    "{FF5533}Неверный пароль. Осталось попыток: %d.\n\n{FFFFFF}Введите пароль ещё раз:",
                    3 - gPlayerData[playerid][pAdminLoginAttempts]
                );

                ShowPlayerDialog(
                    playerid,
                    DIALOG_ADMIN_LOGIN,
                    DIALOG_STYLE_PASSWORD,
                    "Workk RP | Авторизация",
                    msg,
                    "Войти",
                    "Отмена"
                );
                return 1;
            }

            gPlayerData[playerid][pAdminLoginAttempts] = 0;
            Admin_AuthorizationComplete(playerid);
            return 1;
        }

        case DIALOG_ADMIN_REG:
        {
            if(!response)
            {
                SendClientMessage(playerid, ADMIN_NOTICE, "Создание админ-пароля отменено.");
                return 1;
            }

            if(!Admin_IsNumeric(inputtext) || strlen(inputtext) != 4 || strval(inputtext) < 1000 || strval(inputtext) > 9999)
            {
                ShowPlayerDialog(
                    playerid,
                    DIALOG_ADMIN_REG,
                    DIALOG_STYLE_PASSWORD,
                    "Workk RP | Пароль администратора",
                    "{FF5533}Некорректный пароль.\n\n{FFFFFF}Введите ровно четыре цифры от 1000 до 9999:",
                    "Сохранить",
                    "Отмена"
                );
                return 1;
            }

            gPlayerData[playerid][pAdminPass] = strval(inputtext);

            new query[160];
            mysql_format(
                g_SQLHandle,
                query,
                sizeof(query),
                "UPDATE `users` SET `admin_pass` = %d WHERE `id` = %d LIMIT 1",
                gPlayerData[playerid][pAdminPass],
                gPlayerData[playerid][pID]
            );
            mysql_tquery(g_SQLHandle, query);

            SendClientMessage(playerid, COLOR_GREEN, "Пароль администратора сохранён.");
            Admin_AuthorizationComplete(playerid);
            return 1;
        }

        case DIALOG_ADMIN_HELP, DIALOG_ADMINS_LIST:
            return 1;
    }

    return 0;
}

/* ================================================================
   Authentication / chat / lists
   ================================================================ */

CMD:alogin(playerid, params[])
{
    #pragma unused params

    if(!Admin_GetRawLevel(playerid))
        return SendClientMessage(playerid, ADMIN_NOTICE, "У вас нет уровня администратора.");

    return AdminAuthorization(playerid);
}

CMD:alogout(playerid, params[])
{
    #pragma unused params

    if(!Admin_GetRawLevel(playerid))
        return 1;

    if(!gPlayerData[playerid][pAdminAuth])
        return SendClientMessage(playerid, ADMIN_NOTICE, "Вы не авторизованы в админ-панели.");

    gPlayerData[playerid][pAdminAuth] = false;
    gPlayerData[playerid][pAdminDuty] = false;

    SendClientMessage(playerid, 0xFFCC00FF, "Вы вышли из админ-панели. Для входа используйте /alogin.");
    Admin_Log(playerid, "Выход из админ-панели");
    return 1;
}

CMD:ahelp(playerid, params[])
{
    #pragma unused params

    if(!Admin_HasAccess(playerid, 1))
        return SendClientMessage(playerid, ADMIN_NOTICE, "У вас нет доступа к админ-панели.");

    return ShowAdminHelpDialog(playerid);
}

CMD:aduty(playerid, params[])
{
    #pragma unused params

    if(!Admin_HasAccess(playerid, 1))
        return SendClientMessage(playerid, ADMIN_NOTICE, "У вас нет доступа к админ-панели.");

    gPlayerData[playerid][pAdminDuty] = !gPlayerData[playerid][pAdminDuty];

    if(gPlayerData[playerid][pAdminDuty])
        SendClientMessage(playerid, COLOR_GREEN, "Вы заступили на дежурство.");
    else
        SendClientMessage(playerid, 0xFFCC00FF, "Вы снялись с дежурства.");

    return 1;
}

CMD:a(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return SendClientMessage(playerid, ADMIN_NOTICE, "У вас нет доступа к админ-чату.");

    if(!strlen(params))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /a [текст]");

    new msg[256];
    format(
        msg,
        sizeof(msg),
        "[A] %s[%d] (%s): %s",
        GetPlayerNameEx(playerid),
        playerid,
        g_AdminLevelNames[gPlayerData[playerid][pAdmin]],
        params
    );

    Admin_SendToAdmins(ADMIN_COLOR, msg);
    return 1;
}

CMD:admins(playerid, params[])
{
    #pragma unused params
    return ShowAdminsOnlineDialog(playerid);
}

CMD:admlist(playerid, params[])
{
    #pragma unused params

    if(!Admin_HasAccess(playerid, 6))
        return SendClientMessage(playerid, ADMIN_NOTICE, "Требуется 6 уровень администрации.");

    new list[4096], line[192];
    list[0] = EOS;
    strcat(list, "Имя\tУровень\tСтатус\n");

    new count;
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !gPlayerData[i][pLogged])
            continue;

        if(Admin_GetRawLevel(i) <= 0)
            continue;

        format(
            line,
            sizeof(line),
            "%s\t%d\t%s\n",
            GetPlayerNameEx(i),
            Admin_GetRawLevel(i),
            g_AdminLevelNames[Admin_GetRawLevel(i)]
        );
        strcat(list, line);
        count++;
    }

    if(!count)
        strcat(list, "Нет администраторов онлайн.");

    ShowPlayerDialog(
        playerid,
        DIALOG_ADMINS_LIST,
        DIALOG_STYLE_TABLIST_HEADERS,
        "Workk RP | Администраторы",
        list,
        "Закрыть",
        ""
    );
    return 1;
}

CMD:cc(playerid, params[])
{
    #pragma unused params

    if(!Admin_HasAccess(playerid, 10))
        return SendClientMessage(playerid, ADMIN_NOTICE, "Требуется 10 уровень администрации.");

    for(new i; i < 20; i++)
        SendClientMessageToAll(-1, " ");

    new msg[144];
    format(msg, sizeof(msg), "{00A2A4}Чат был очищен администратором: %s", GetPlayerNameEx(playerid));
    SendClientMessageToAll(0xFFCD00FF, msg);

    Admin_Log(playerid, "Очистил чат");
    return 1;
}

/* ================================================================
   Moderation
   ================================================================ */

CMD:kick(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return SendClientMessage(playerid, ADMIN_NOTICE, "У вас нет доступа к этой команде.");

    new targetid, reason[96];
    if(sscanf(params, "us[96]", targetid, reason))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /kick [id] [причина]");

    if(!Admin_GetTarget(params, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет.");

    if(!Admin_CanTarget(playerid, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя применить действие к администратору равного или выше уровня.");

    new msg[256];
    format(msg, sizeof(msg), "Администратор %s кикнул %s. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), reason);
    Admin_SendToAll(ADMIN_NOTICE, msg);
    Admin_Log(playerid, msg);

    SendClientMessage(targetid, COLOR_RED, "Вы были кикнуты с сервера.");
    Kick(targetid);
    return 1;
}

CMD:skick(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 14))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /skick [id]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(Admin_GetRawLevel(targetid) >= Admin_GetLevel(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя кикнуть администратора равного или выше уровня.");

    Admin_Log(playerid, "SKICK игрока");
    Kick(targetid);
    return 1;
}

CMD:freeze(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 2))
        return SendClientMessage(playerid, ADMIN_NOTICE, "Требуется 2 уровень администрации.");

    new targetid;
    if(!Admin_GetTarget(params, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /freeze [id]");

    if(!Admin_CanTarget(playerid, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя заморозить администратора равного или выше уровня.");

    SetPlayerFrozenEx(targetid, true);
    SendClientMessage(targetid, ADMIN_NOTICE, "Администратор заморозил вас.");
    SendClientMessage(playerid, COLOR_GREEN, "Игрок заморожен.");
    Admin_Log(playerid, "Заморозил игрока");
    return 1;
}

CMD:unfreeze(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 2))
        return SendClientMessage(playerid, ADMIN_NOTICE, "Требуется 2 уровень администрации.");

    new targetid;
    if(!Admin_GetTarget(params, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /unfreeze [id]");

    SetPlayerFrozenEx(targetid, false);
    SendClientMessage(targetid, COLOR_GREEN, "Администратор разморозил вас.");
    SendClientMessage(playerid, COLOR_GREEN, "Игрок разморожен.");
    Admin_Log(playerid, "Разморозил игрока");
    return 1;
}

CMD:mute(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid, minutes, reason[64];
    if(sscanf(params, "uds[64]", targetid, minutes, reason))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /mute [id] [минуты] [причина]");

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(minutes < 1 || minutes > 360)
        return SendClientMessage(playerid, 0xCECECEFF, "Время мута: от 1 до 360 минут.");

    if(!Admin_CanTarget(playerid, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать мут администратору равного или выше уровня.");

    if(gPlayerData[targetid][pMuted])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок уже находится в муте.");

    SetPlayerMuted(targetid, minutes * 60, reason);

    new msg[256];
    format(msg, sizeof(msg), "Администратор %s выдал мут %s на %d мин. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), minutes, reason);
    Admin_SendToAll(ADMIN_NOTICE, msg);
    Admin_Log(playerid, msg);
    return 1;
}

CMD:unmute(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /unmute [id]");

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    SetPlayerUnmuted(targetid);
    SendClientMessage(targetid, COLOR_GREEN, "С вас сняли мут.");
    Admin_Log(playerid, "Снял мут");
    return 1;
}

CMD:jail(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid, minutes, reason[64];
    if(sscanf(params, "uds[64]", targetid, minutes, reason))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /jail [id] [минуты] [причина]");

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(minutes < 1 || minutes > 360)
        return SendClientMessage(playerid, 0xCECECEFF, "Время тюрьмы: от 1 до 360 минут.");

    if(!Admin_CanTarget(playerid, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя посадить администратора равного или выше уровня.");

    SetPlayerJailedEx(targetid, minutes * 60);

    new msg[256];
    format(msg, sizeof(msg), "Администратор %s посадил %s в тюрьму на %d мин. Причина: %s", GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), minutes, reason);
    Admin_SendToAll(ADMIN_NOTICE, msg);
    Admin_Log(playerid, msg);
    return 1;
}

CMD:unjail(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /unjail [id]");

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    SetPlayerUnjailedEx(targetid);
    SendClientMessage(targetid, COLOR_GREEN, "Вы были освобождены из тюрьмы.");
    Admin_Log(playerid, "Освободил игрока из тюрьмы");
    return 1;
}

CMD:awarn(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 9))
        return 1;

    new targetid, reason[96];
    if(sscanf(params, "us[96]", targetid, reason))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /awarn [id] [причина]");

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(!Admin_GetRawLevel(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не является администратором.");

    if(!Admin_CanTarget(playerid, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Нельзя выдать предупреждение админу равного или выше уровня.");

    gPlayerData[targetid][pAdminWarn]++;

    new query[192];
    mysql_format(g_SQLHandle, query, sizeof(query),
        "UPDATE `users` SET `admin_warn` = %d WHERE `id` = %d LIMIT 1",
        gPlayerData[targetid][pAdminWarn], gPlayerData[targetid][pID]);
    mysql_tquery(g_SQLHandle, query);

    new msg[256];
    format(msg, sizeof(msg),
        "[A] %s выдал предупреждение администратору %s [%d/3]. Причина: %s",
        GetPlayerNameEx(playerid), GetPlayerNameEx(targetid),
        gPlayerData[targetid][pAdminWarn], reason);
    Admin_SendToAdmins(ADMIN_NOTICE, msg);
    Admin_Log(playerid, msg);

    if(gPlayerData[targetid][pAdminWarn] >= 3)
    {
        Admin_SaveLevel(targetid, 0);
        gPlayerData[targetid][pAdminAuth] = false;
        gPlayerData[targetid][pAdminDuty] = false;
        gPlayerData[targetid][pAdminWarn] = 0;

        SendClientMessage(targetid, COLOR_RED, "Вы сняты с должности администратора за 3 предупреждения.");
    }
    return 1;
}

CMD:unawarn(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 9))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /unawarn [id]");

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    gPlayerData[targetid][pAdminWarn] = 0;

    new query[192];
    mysql_format(g_SQLHandle, query, sizeof(query),
        "UPDATE `users` SET `admin_warn` = 0 WHERE `id` = %d LIMIT 1",
        gPlayerData[targetid][pID]);
    mysql_tquery(g_SQLHandle, query);

    SendClientMessage(targetid, COLOR_GREEN, "Все ваши административные предупреждения сняты.");
    Admin_Log(playerid, "Снял предупреждения администратора");
    return 1;
}

CMD:ban(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 3))
        return 1;

    new targetName[MAX_PLAYER_NAME], days, reason[128];
    if(sscanf(params, "s[24]ds[128]", targetName, days, reason))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ban [id/ник] [дни] [причина]");

    if(days < 1 || days > 3650)
        return SendClientMessage(playerid, 0xCECECEFF, "Срок бана: от 1 до 3650 дней.");

    if(!strlen(reason))
        return SendClientMessage(playerid, 0xCECECEFF, "Укажите причину.");

    new targetid = INVALID_PLAYER_ID;
    if(Admin_IsNumeric(targetName))
        targetid = strval(targetName);
    else
        targetid = Admin_GetPlayerID(targetName);

    new expire = gettime() + days * 86400;
    new query[512], msg[256];

    if(targetid != INVALID_PLAYER_ID && IsPlayerConnected(targetid) && gPlayerData[targetid][pLogged])
    {
        if(!Admin_CanTarget(playerid, targetid))
            return SendClientMessage(playerid, 0xCECECEFF, "Нельзя забанить администратора равного или выше уровня.");

        mysql_format(
            g_SQLHandle,
            query,
            sizeof(query),
            "UPDATE `users` SET `banned` = 1, `ban_reason` = '%e', `ban_expire` = %d WHERE `id` = %d LIMIT 1",
            reason,
            expire,
            gPlayerData[targetid][pID]
        );
        mysql_tquery(g_SQLHandle, query);

        format(msg, sizeof(msg),
            "Администратор %s заблокировал %s на %d дней. Причина: %s",
            GetPlayerNameEx(playerid), GetPlayerNameEx(targetid), days, reason);
        Admin_SendToAll(ADMIN_NOTICE, msg);

        SendClientMessage(targetid, COLOR_RED, "Вы заблокированы.");
        SendClientMessage(targetid, COLOR_RED, reason);

        Admin_Log(playerid, msg);
        SetTimerEx("KickPlayerDelayed", 500, false, "i", targetid);
        return 1;
    }

    mysql_format(
        g_SQLHandle,
        query,
        sizeof(query),
        "UPDATE `users` SET `banned` = 1, `ban_reason` = '%e', `ban_expire` = %d WHERE `name` = '%e' LIMIT 1",
        reason,
        expire,
        targetName
    );
    mysql_tquery(g_SQLHandle, query);

    format(msg, sizeof(msg), "OFFBAN: %s -> %s на %d дней. Причина: %s",
        GetPlayerNameEx(playerid), targetName, days, reason);
    SendClientMessage(playerid, COLOR_GREEN, "Запрос на блокировку отправлен.");
    Admin_Log(playerid, msg);
    return 1;
}

CMD:unban(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 3))
        return 1;

    new name[MAX_PLAYER_NAME];
    if(sscanf(params, "s[24]", name))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /unban [ник]");

    new query[256];
    mysql_format(
        g_SQLHandle,
        query,
        sizeof(query),
        "UPDATE `users` SET `banned` = 0, `ban_reason` = '', `ban_expire` = 0 WHERE `name` = '%e' LIMIT 1",
        name
    );
    mysql_tquery(g_SQLHandle, query);

    SendClientMessage(playerid, COLOR_GREEN, "Запрос на разблокировку отправлен.");
    Admin_Log(playerid, "Разбан аккаунта");
    return 1;
}

/* ================================================================
   Player utilities
   ================================================================ */

CMD:slap(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid;
    if(!Admin_GetTarget(params, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /slap [id]");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);
    SetPlayerPos(targetid, x, y, z + 8.0);
    Admin_Log(playerid, "Slap игрока");
    return 1;
}

CMD:sethp(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid, Float:hp;
    if(sscanf(params, "uf", targetid, hp))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sethp [id] [hp]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(hp < 0.0 || hp > 100.0)
        return SendClientMessage(playerid, 0xCECECEFF, "HP должно быть от 0 до 100.");

    SetPlayerHealth(targetid, hp);
    return 1;
}

CMD:hp(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        targetid = playerid;

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    SetPlayerHealth(targetid, 100.0);
    SendClientMessage(targetid, COLOR_GREEN, "Здоровье восстановлено.");
    return 1;
}
alias:hp("heal")

CMD:armour(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        targetid = playerid;

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    SetPlayerArmour(targetid, 100.0);
    SendClientMessage(targetid, COLOR_GREEN, "Броня восстановлена.");
    return 1;
}
alias:armour("armor")

CMD:setskin(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid, skinid;
    if(sscanf(params, "ud", targetid, skinid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setskin [id] [skin]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(skinid < 0 || skinid > 311)
        return SendClientMessage(playerid, 0xCECECEFF, "Некорректный ID скина.");

    SetPlayerSkin(targetid, skinid);
    gPlayerData[targetid][pSkin] = skinid;
    SaveAccount(targetid);
    return 1;
}

CMD:myskin(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new skinid;
    if(sscanf(params, "d", skinid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /myskin [skin]");

    if(skinid < 0 || skinid > 311)
        return SendClientMessage(playerid, 0xCECECEFF, "Некорректный ID скина.");

    SetPlayerSkin(playerid, skinid);
    gPlayerData[playerid][pSkin] = skinid;
    SaveAccount(playerid);
    return 1;
}

CMD:givecash(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 11))
        return 1;

    new targetid, amount;
    if(sscanf(params, "ud", targetid, amount))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givecash [id] [сумма]");

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(amount < 1 || amount > 100000000)
        return SendClientMessage(playerid, 0xCECECEFF, "Сумма: от 1 до 100000000.");

    GivePlayerMoneyEx(targetid, amount);

    new msg[160];
    format(msg, sizeof(msg), "Администратор выдал вам $%d.", amount);
    SendClientMessage(targetid, COLOR_GREEN, msg);

    Admin_Log(playerid, "Выдал игроку деньги");
    return 1;
}

CMD:money(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 3))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /money [id]");

    if(!IsPlayerConnected(targetid) || !gPlayerData[targetid][pLogged])
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    new msg[192];
    format(
        msg,
        sizeof(msg),
        "Игрок: %s[%d] | ID аккаунта: %d | Деньги: %d | Админ: %d | Мут: %s | Jail: %s",
        GetPlayerNameEx(targetid),
        targetid,
        gPlayerData[targetid][pID],
        GetPlayerMoneyEx(targetid),
        Admin_GetRawLevel(targetid),
        gPlayerData[targetid][pMuted] ? "Да" : "Нет",
        gPlayerData[targetid][pJailed] ? "Да" : "Нет"
    );
    SendClientMessage(playerid, COLOR_WHITE, msg);
    return 1;
}

CMD:getip(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 8))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /getip [id]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    new ip[16], msg[96];
    GetPlayerIp(targetid, ip, sizeof(ip));
    format(msg, sizeof(msg), "IP игрока %s[%d]: %s", GetPlayerNameEx(targetid), targetid, ip);
    SendClientMessage(playerid, COLOR_YELLOW, msg);
    Admin_Log(playerid, "Получил IP игрока");
    return 1;
}

CMD:goto(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid;
    if(!Admin_GetTarget(params, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /goto [id]");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(targetid, x, y, z);

    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));
    SetPlayerPos(playerid, x, y, z);
    return 1;
}
alias:goto("tp")

CMD:gethere(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid;
    if(!Admin_GetTarget(params, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /gethere [id]");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    SetPlayerInterior(targetid, GetPlayerInterior(playerid));
    SetPlayerVirtualWorld(targetid, GetPlayerVirtualWorld(playerid));
    SetPlayerPos(targetid, x, y, z);

    SendClientMessage(targetid, ADMIN_NOTICE, "Администратор телепортировал вас к себе.");
    return 1;
}

CMD:vw(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 2))
        return 1;

    new targetid, world;
    if(sscanf(params, "ud", targetid, world))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /vw [id] [world]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    SetPlayerVirtualWorld(targetid, world);
    return 1;
}
alias:vw("setvw")

CMD:inter(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 2))
        return 1;

    new targetid, interior;
    if(sscanf(params, "ud", targetid, interior))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /inter [id] [interior]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    SetPlayerInterior(targetid, interior);
    return 1;
}
alias:inter("interior")

CMD:settime(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 2))
        return 1;

    new hour;
    if(sscanf(params, "d", hour))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /settime [0-23]");

    if(hour < 0 || hour > 23)
        return SendClientMessage(playerid, 0xCECECEFF, "Час должен быть от 0 до 23.");

    SetWorldTime(hour);
    Admin_Log(playerid, "Изменил время");
    return 1;
}

CMD:setweather(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 2))
        return 1;

    new weather;
    if(sscanf(params, "d", weather))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setweather [id]");

    if(weather < 0 || weather > 45)
        return SendClientMessage(playerid, 0xCECECEFF, "Некорректный ID погоды.");

    SetWeather(weather);
    Admin_Log(playerid, "Изменил погоду");
    return 1;
}

CMD:getcam(playerid, params[])
{
    #pragma unused params

    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new
        Float:px, Float:py, Float:pz,
        Float:vx, Float:vy, Float:vz,
        Float:lx, Float:ly, Float:lz,
        text[192];

    GetPlayerCameraPos(playerid, px, py, pz);
    GetPlayerCameraFrontVector(playerid, vx, vy, vz);

    lx = px + floatmul(vx, 5.0);
    ly = py + floatmul(vy, 5.0);
    lz = pz + floatmul(vz, 5.0);

    format(
        text,
        sizeof(text),
        "CameraPos: %f,%f,%f | LookAt: %f,%f,%f",
        px, py, pz, lx, ly, lz
    );
    SendClientMessage(playerid, COLOR_WHITE, text);
    return 1;
}

CMD:spectate(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 1))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /spectate [id]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    TogglePlayerSpectating(playerid, true);
    PlayerSpectatePlayer(playerid, targetid);
    return 1;
}

CMD:unspectate(playerid, params[])
{
    #pragma unused params

    if(!Admin_HasAccess(playerid, 1))
        return 1;

    TogglePlayerSpectating(playerid, false);
    SpawnPlayerAtRandomPoint(playerid);
    return 1;
}

CMD:agm(playerid, params[])
{
    #pragma unused params

    if(!Admin_HasAccess(playerid, 1))
        return 1;

    if(GetPVarInt(playerid, "agm") == 0)
    {
        SetPVarInt(playerid, "agm", 1);
        SetPlayerHealth(playerid, 99999.0);
        SendClientMessage(playerid, COLOR_GREEN, "Админ-режим бессмертия включён.");
        Admin_Log(playerid, "Включил бессмертие");
    }
    else
    {
        SetPVarInt(playerid, "agm", 0);
        SetPlayerHealth(playerid, 100.0);
        SendClientMessage(playerid, 0xFFCC00FF, "Админ-режим бессмертия выключен.");
        Admin_Log(playerid, "Выключил бессмертие");
    }
    return 1;
}

/* ================================================================
   Administration management
   ================================================================ */

CMD:setadmin(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 13))
        return 1;

    new name[MAX_PLAYER_NAME], level;
    if(sscanf(params, "s[24]d", name, level))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setadmin [ник] [уровень 0-14]");

    if(level < 0 || level > MAX_ADMIN_LEVEL)
        return SendClientMessage(playerid, 0xCECECEFF, "Уровень должен быть от 0 до 14.");

    new targetid = Admin_GetPlayerID(name);

    if(targetid != INVALID_PLAYER_ID && IsPlayerConnected(targetid))
    {
        if(targetid == playerid)
            return SendClientMessage(playerid, 0xCECECEFF, "Нельзя изменить свой уровень этой командой.");

        if(Admin_GetRawLevel(targetid) >= Admin_GetLevel(playerid))
            return SendClientMessage(playerid, 0xCECECEFF, "Нельзя изменить уровень равного или выше себя.");

        Admin_SaveLevel(targetid, level);
        gPlayerData[targetid][pAdminAuth] = false;
        gPlayerData[targetid][pAdminDuty] = false;

        new msg[192];
        format(msg, sizeof(msg), "Вам установлен уровень администрации: %d (%s).", level, g_AdminLevelNames[level]);
        SendClientMessage(targetid, COLOR_GREEN, msg);
    }
    else
    {
        new query[256];
        mysql_format(
            g_SQLHandle,
            query,
            sizeof(query),
            "UPDATE `users` SET `admin` = %d WHERE `name` = '%e' LIMIT 1",
            level,
            name
        );
        mysql_tquery(g_SQLHandle, query);
    }

    new logmsg[192];
    format(logmsg, sizeof(logmsg), "Установил %s уровень администрации %d", name, level);
    Admin_Log(playerid, logmsg);

    SendClientMessage(playerid, COLOR_GREEN, "Уровень администрации установлен.");
    return 1;
}

CMD:deladmin(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 13))
        return 1;

    new name[MAX_PLAYER_NAME];
    if(sscanf(params, "s[24]", name))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /deladmin [ник]");

    new targetid = Admin_GetPlayerID(name);

    if(targetid != INVALID_PLAYER_ID && IsPlayerConnected(targetid))
    {
        if(Admin_GetRawLevel(targetid) >= Admin_GetLevel(playerid))
            return SendClientMessage(playerid, 0xCECECEFF, "Нельзя снять равного или выше себя.");

        Admin_SaveLevel(targetid, 0);
        gPlayerData[targetid][pAdminAuth] = false;
        gPlayerData[targetid][pAdminDuty] = false;
        gPlayerData[targetid][pAdminWarn] = 0;

        SendClientMessage(targetid, COLOR_RED, "Вы были сняты с должности администратора.");
    }
    else
    {
        new query[256];
        mysql_format(
            g_SQLHandle,
            query,
            sizeof(query),
            "UPDATE `users` SET `admin` = 0, `admin_warn` = 0 WHERE `name` = '%e' LIMIT 1",
            name
        );
        mysql_tquery(g_SQLHandle, query);
    }

    Admin_Log(playerid, "Снял администратора");
    SendClientMessage(playerid, COLOR_GREEN, "Администратор снят.");
    return 1;
}

/* Compatible aliases from the supplied administration */
CMD:sethelper(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 5))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sethelper [id]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(Admin_GetRawLevel(targetid) > 0)
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок уже является администратором.");

    Admin_SaveLevel(targetid, 1);
    SendClientMessage(targetid, COLOR_GREEN, "Вы назначены помощником (1 уровень администрации).");
    Admin_Log(playerid, "Назначил помощника");
    return 1;
}

CMD:delhelper(playerid, params[])
{
    if(!Admin_HasAccess(playerid, 5))
        return 1;

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /delhelper [id]");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден.");

    if(Admin_GetRawLevel(targetid) != 1)
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не является помощником.");

    Admin_SaveLevel(targetid, 0);
    gPlayerData[targetid][pAdminAuth] = false;
    gPlayerData[targetid][pAdminDuty] = false;

    SendClientMessage(targetid, COLOR_RED, "Вы сняты с должности помощника.");
    Admin_Log(playerid, "Снял помощника");
    return 1;
}
