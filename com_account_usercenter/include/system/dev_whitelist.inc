// SAME RUSSIA | Developer whitelist transferred from SAME_RUSSIA_MAIN
#if defined _dev_whitelist_included
    #endinput
#endif
#define _dev_whitelist_included

#define DIALOG_DEV_WHITELIST_MENU          (34780)
#define DIALOG_DEV_WHITELIST_PASSWORD      (34781)
#define DIALOG_DEV_WHITELIST_ACCESS        (34782)

new bool:g_dev_whitelist_enabled = false;
new g_dev_whitelist_password[65] = "dev2026";
new g_dev_whitelist_attempts[MAX_PLAYERS];
new bool:g_dev_whitelist_passed[MAX_PLAYERS];

forward DevWhitelist_ResumeConnect(playerid);
forward DevWhitelist_Kick(playerid);

stock DevWhitelist_Save()
{
    new query[256];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO `server_whitelist` (`id`,`enabled`,`password`) VALUES (1,%d,'%e') ВКЛ DUPLICATE KEY UPDATE `enabled`=VALUES(`enabled`),`password`=VALUES(`password`)",
        _:g_dev_whitelist_enabled, g_dev_whitelist_password);
    mysql_query(mysql, query, false);
    return 1;
}

stock DevWhitelist_Init()
{
    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `server_whitelist` (`id` TINYINT UNSIGNED NOT NULL DEFAULT 1, `enabled` TINYINT(1) NOT NULL DEFAULT 0, `password` VARCHAR(64) NOT NULL DEFAULT 'dev2026', PRIMARY KEY (`id`)) ENGINE=MyISAM DEFAULT CHARSET=cp1251",
        false);

    new Cache:result = mysql_query(mysql, "SELECT `enabled`,`password` FROM `server_whitelist` WHERE `id`=1 LIMIT 1", true);
    if(mysql_errno(mysql) == 0 && cache_num_rows() > 0)
    {
        g_dev_whitelist_enabled = bool:cache_get_field_content_int(0, "enabled");
        cache_get_field_content(0, "password", g_dev_whitelist_password, mysql, sizeof g_dev_whitelist_password);
        if(!strlen(g_dev_whitelist_password)) format(g_dev_whitelist_password, sizeof g_dev_whitelist_password, "dev2026");
    }
    else
    {
        format(g_dev_whitelist_password, sizeof g_dev_whitelist_password, "dev2026");
        g_dev_whitelist_enabled = false;
        DevWhitelist_Save();
    }
    cache_delete(result);
    printf("[WHITELIST] loaded: enabled=%d", _:g_dev_whitelist_enabled);
    return 1;
}

stock DevWhitelist_ShowAccess(playerid, const extra[] = "")
{
    new text[512];
    if(strlen(extra))
        format(text, sizeof text, "{FF4444}%s\n\n{FFFFFF}Доступ к серверу разрешён только разработчикам.\nВведите пароль от whitelist для продолжения.\n\n{AAAAAA}После 3 неудачных попыток соединение будет закрыто.", extra);
    else
        format(text, sizeof text, "{FFFFFF}Доступ к серверу разрешён только разработчикам.\nВведите пароль от whitelist для продолжения.\n\n{AAAAAA}После 3 неудачных попыток соединение будет закрыто.");

    ShowPlayerDialog(playerid, DIALOG_DEV_WHITELIST_ACCESS, DIALOG_STYLE_PASSWORD,
        "{FF3B30}Доступ разработчика", text, "Войти", "Выйти");
    return 1;
}

stock DevWhitelist_ShowMenu(playerid)
{
    new title[96], text[256];
    format(title, sizeof title, "{FFFFFF}Whitelist разработчиков | %s", g_dev_whitelist_enabled ? "{33CC66}ВКЛ" : "{FF5555}ВЫКЛ");
    format(text, sizeof text, "%s whitelist\nИзменить пароль\nПоказать статус", g_dev_whitelist_enabled ? "Отключить" : "Включить");
    ShowPlayerDialog(playerid, DIALOG_DEV_WHITELIST_MENU, DIALOG_STYLE_LIST, title, text, "Выбрать", "Закрыть");
    return 1;
}

public DevWhitelist_ResumeConnect(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    return OnPlayerConnect(playerid);
}

public DevWhitelist_Kick(playerid)
{
    if(IsPlayerConnected(playerid)) Kick(playerid);
    return 1;
}

stock DevWhitelist_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_DEV_WHITELIST_ACCESS)
    {
        if(!response)
        {
            SetTimerEx("DevWhitelist_Kick", 300, false, "i", playerid);
            return 1;
        }
        if(!strcmp(inputtext, g_dev_whitelist_password, false))
        {
            g_dev_whitelist_passed[playerid] = true;
            g_dev_whitelist_attempts[playerid] = 0;
            SendClientMessage(playerid, 0x55DD77FF, "Пароль whitelist принят.");
            SetTimerEx("DevWhitelist_ResumeConnect", 100, false, "i", playerid);
            return 1;
        }
        g_dev_whitelist_attempts[playerid]++;
        if(g_dev_whitelist_attempts[playerid] >= 3)
        {
            SendClientMessage(playerid, 0xFF4444FF, "Неверный пароль whitelist. Все 3 попытки использованы.");
            SetTimerEx("DevWhitelist_Kick", 500, false, "i", playerid);
            return 1;
        }
        new extra[128];
        format(extra, sizeof extra, "Неверный пароль. Осталось попыток: %d", 3 - g_dev_whitelist_attempts[playerid]);
        DevWhitelist_ShowAccess(playerid, extra);
        return 1;
    }

    if(dialogid == DIALOG_DEV_WHITELIST_MENU)
    {
        if(!response) return 1;
        if(GetPlayerAdminEx(playerid) < 14 || !GetPlayerData(playerid, P_ADMIN_LOGGED)) return 1;
        switch(listitem)
        {
            case 0:
            {
                g_dev_whitelist_enabled = !g_dev_whitelist_enabled;
                DevWhitelist_Save();
                SendClientMessage(playerid, 0x55DD77FF, g_dev_whitelist_enabled ? "Whitelist включён." : "Whitelist отключён.");
                return DevWhitelist_ShowMenu(playerid);
            }
            case 1:
            {
                ShowPlayerDialog(playerid, DIALOG_DEV_WHITELIST_PASSWORD, DIALOG_STYLE_INPUT,
                    "Whitelist разработчиков | Новый пароль", "Введите новый пароль whitelist (от 4 до 32 символов).", "Сохранить", "Назад");
                return 1;
            }
            case 2:
            {
                new msg[192];
                format(msg, sizeof msg, "Whitelist: %s | Длина пароля: %d", g_dev_whitelist_enabled ? "ВКЛ" : "ВЫКЛ", strlen(g_dev_whitelist_password));
                SendClientMessage(playerid, 0xFFFFFFFF, msg);
                return DevWhitelist_ShowMenu(playerid);
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_DEV_WHITELIST_PASSWORD)
    {
        if(!response) return DevWhitelist_ShowMenu(playerid);
        if(GetPlayerAdminEx(playerid) < 14 || !GetPlayerData(playerid, P_ADMIN_LOGGED)) return 1;
        if(strlen(inputtext) < 4 || strlen(inputtext) > 32)
        {
            ShowPlayerDialog(playerid, DIALOG_DEV_WHITELIST_PASSWORD, DIALOG_STYLE_INPUT,
                "Whitelist разработчиков | Ошибка", "Пароль должен содержать от 4 до 32 символов.", "Сохранить", "Назад");
            return 1;
        }
        format(g_dev_whitelist_password, sizeof g_dev_whitelist_password, "%s", inputtext);
        DevWhitelist_Save();
        SendClientMessage(playerid, 0x55DD77FF, "Новый пароль whitelist сохранён в базу данных.");
        return DevWhitelist_ShowMenu(playerid);
    }
    return 0;
}

CMD:whitelist(playerid, params[])
{
    #pragma unused params
    if(GetPlayerAdminEx(playerid) < 14 || !GetPlayerData(playerid, P_ADMIN_LOGGED))
        return SendClientMessage(playerid, 0xFF5555FF, "Команда доступна только авторизованным администраторам 14+ уровня.");
    return DevWhitelist_ShowMenu(playerid);
}
