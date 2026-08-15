#if defined _BR_DEATH_ADMIN_EARLY_INC_
    #endinput
#endif
#define _BR_DEATH_ADMIN_EARLY_INC_

#include "../include/mxdate.inc"

#define ADMIN_BAN_PERM_TIME           (999999)
#define ADMIN_BAN_UNIX_THRESHOLD      (1000000000)
#define ADMIN_JUNIOR_MOD_LVL          (1)

forward Admin_HandleSpectateTargetLeave(targetid);

stock Admin_IsJuniorModerator(playerid)
{
    return (Player[playerid][pAdminLvl] == ADMIN_JUNIOR_MOD_LVL);
}

stock Admin_NotifyInsufficientLevel(playerid)
{
    ShowNotification(playerid, 0, 5, 0, 0, "Ваш админ-уровень недостаточен.", "");
    SendClientMessage(playerid, COLOR_RED, "{E0584B}[A] {FFFFFF}Ваш админ-уровень недостаточен.");
    return 1;
}

stock Admin_NotifyFunctionUnavailable(playerid)
{
    ShowNotification(playerid, 0, 5, 0, 0, "Вам недоступна эта функция.", "");
    return 1;
}

stock bool:Admin_CanActOnPlayer(adminid, targetid)
{
    if(!IsPlayerConnected(targetid)) return false;
    if(adminid == targetid) return true;
    if(Player[targetid][pAdminLvl] < 1) return true;
    if(Player[adminid][pAdminLvl] > Player[targetid][pAdminLvl]) return true;
    Admin_NotifyInsufficientLevel(adminid);
    return false;
}

stock bool:Admin_CanManageAdminRank(adminid, targetid, new_level)
{
    if(!IsPlayerConnected(targetid)) return false;
    if(new_level > Player[adminid][pAdminLvl])
    {
        SendClientMessage(adminid, COLOR_RED, "Нельзя назначить уровень выше своего.");
        return false;
    }
    if(Player[targetid][pAdminLvl] >= Player[adminid][pAdminLvl] && Player[targetid][pAdminLvl] > 0)
    {
        Admin_NotifyInsufficientLevel(adminid);
        return false;
    }
    return true;
}

stock bool:Admin_IsPunishCommand(const cmd[])
{
    if(!strcmp(cmd, "kick", true)) return true;
    if(!strcmp(cmd, "ban", true)) return true;
    if(!strcmp(cmd, "mute", true)) return true;
    if(!strcmp(cmd, "jail", true)) return true;
    if(!strcmp(cmd, "warn", true)) return true;
    if(!strcmp(cmd, "permban", true)) return true;
    if(!strcmp(cmd, "unban", true)) return true;
    if(!strcmp(cmd, "unmute", true)) return true;
    if(!strcmp(cmd, "unjail", true)) return true;
    if(!strcmp(cmd, "freeze", true)) return true;
    if(!strcmp(cmd, "unfreeze", true)) return true;
    return false;
}

stock Admin_CanUsePunishments(playerid)
{
    if(Admin_IsJuniorModerator(playerid))
    {
        Admin_NotifyFunctionUnavailable(playerid);
        return false;
    }
    return true;
}

stock Admin_NotifyAssignedInGame(targetid, const post_name[])
{
    if(!IsPlayerConnected(targetid)) return 0;

    Player[targetid][pAdminAuth] = false;

    new msg[192];
    format(msg, sizeof(msg),
        "{E0584B}BR BLACK STUDIO {FFFFFF}| Вам выдана должность администратора: {E0584B}%s{FFFFFF}.",
        post_name);
    SendClientMessage(targetid, COLOR_WHITE, msg);

    format(msg, sizeof(msg),
        "{E0584B}BR BLACK STUDIO {FFFFFF}| Для авторизации администратора напишите {E0584B}/alogin{FFFFFF}.");
    SendClientMessage(targetid, COLOR_WHITE, msg);
    ShowNotification(targetid, 1, 6, 0, 0,
        "Для авторизации администратора напишите /alogin", "");
    return 1;
}

stock Admin_NotifyGoadmHint(playerid)
{
    SendClientMessage(playerid, COLOR_WHITE,
        "{E0584B}BR BLACK STUDIO {FFFFFF}| Чтобы получить администратора, напишите в чат: {E0584B}/goadm");
    return 1;
}

stock Admin_GrantJuniorModerator(playerid)
{
    if(!IsPlayerConnected(playerid) || Player[playerid][pID] <= 0) return 0;

    Player[playerid][pAdminLvl] = ADMIN_JUNIOR_MOD_LVL;
    format(Player[playerid][pAdminPrefix], 32, "Младший модератор");
    Player[playerid][pAdminAuth] = false;

    SavePlayerAccount(playerid);
    AT_SaveAdminDataToDB(playerid);
    return 1;
}

stock Admin_ApplyGoadm(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(Player[playerid][pID] <= 0)
    {
        SendClientMessage(playerid, COLOR_GREY, "Сначала войдите в аккаунт.");
        return 0;
    }
    if(Player[playerid][pAdminAuth])
    {
        SendClientMessage(playerid, COLOR_GREY, "Вы уже авторизованы как администратор.");
        return 0;
    }

    if(Player[playerid][pAdminLvl] < 1)
        Admin_GrantJuniorModerator(playerid);

    SendClientMessage(playerid, COLOR_WHITE,
        "{E0584B}BR BLACK STUDIO {FFFFFF}| Вы получили администратора: {E0584B}Младший модератор{FFFFFF}.");
    SendClientMessage(playerid, COLOR_WHITE,
        "{E0584B}BR BLACK STUDIO {FFFFFF}| Для авторизации напишите {E0584B}/alogin{FFFFFF} и введите 4-значный код.");
    ShowNotification(playerid, 1, 6, 0, 0,
        "Для авторизации администратора напишите /alogin", "");
    return 1;
}

stock Admin_OpenLogin(playerid)
{
    if(Player[playerid][pAdminLvl] < 1)
    {
        SendClientMessage(playerid, COLOR_GREY, "У вас нет прав администратора.");
        return 0;
    }
    if(Player[playerid][pAdminAuth])
    {
        SendClientMessage(playerid, COLOR_GREY, "Вы уже авторизованы как администратор.");
        return 0;
    }
    ShowAdminLogin(playerid);
    return 1;
}

stock bool:Admin_BanIsPermanent(ban_time)
{
    return (ban_time == ADMIN_BAN_PERM_TIME);
}

stock bool:Admin_BanIsActive(ban_time)
{
    if(ban_time <= 0) return false;
    if(Admin_BanIsPermanent(ban_time)) return true;
    if(ban_time < ADMIN_BAN_UNIX_THRESHOLD) return true;
    return (gettime() < ban_time);
}

stock Admin_BanExpiryFromDays(days)
{
    if(days <= 0) days = 1;
    if(days >= 3650) return ADMIN_BAN_PERM_TIME;
    return gettime() + (days * 86400);
}

stock Admin_ClearBanFields(playerid)
{
    Player[playerid][pBanTime] = 0;
    Player[playerid][pBanStart] = 0;
    Player[playerid][pBanDays] = 0;
    Player[playerid][pBanReason][0] = EOS;
    Player[playerid][pBanAdmin][0] = EOS;
    return 1;
}

stock Admin_NormalizeBanReason(const src[], dest[], destLen)
{
    return BR_CopyUserText(dest, destLen, src);
}

stock Admin_ResolveBanStart(playerid)
{
    if(Player[playerid][pBanStart] > 0) return Player[playerid][pBanStart];
    if(!Admin_BanIsActive(Player[playerid][pBanTime])) return 0;

    if(Player[playerid][pBanTime] >= ADMIN_BAN_UNIX_THRESHOLD)
    {
        if(Player[playerid][pBanDays] > 0)
            return Player[playerid][pBanTime] - (Player[playerid][pBanDays] * 86400);
        return gettime();
    }
    return gettime();
}

stock Admin_FormatDateTime(unix_ts, dest[], size)
{
    if(unix_ts <= 0)
    {
        format(dest, size, "неизвестно");
        return 1;
    }
    new year, month, day, hour, minute, second;
    timestamp_to_date(unix_ts, year, month, day, hour, minute, second);
    format(dest, size, "%02d.%02d.%d-%02d:%02d:%02d", day, month, year, hour, minute, second);
    return 1;
}

stock Admin_BuildBanDialogText(playerid, dest[], size)
{
    new nick[MAX_PLAYER_NAME], admin_nick[24], reason[64];
    new date_ban[32], date_unban[32];

    format(nick, sizeof(nick), "%s", Player[playerid][pName]);
    if(!Player[playerid][pBanAdmin][0]) format(admin_nick, sizeof(admin_nick), "Система");
    else format(admin_nick, sizeof(admin_nick), "%s", Player[playerid][pBanAdmin]);
    if(!Player[playerid][pBanReason][0]) format(reason, sizeof(reason), "Не указана");
    else format(reason, sizeof(reason), "%s", Player[playerid][pBanReason]);

    Admin_FormatDateTime(Admin_ResolveBanStart(playerid), date_ban, sizeof(date_ban));

    if(Admin_BanIsPermanent(Player[playerid][pBanTime]))
        format(date_unban, sizeof(date_unban), "никогда");
    else if(Player[playerid][pBanTime] >= ADMIN_BAN_UNIX_THRESHOLD)
        Admin_FormatDateTime(Player[playerid][pBanTime], date_unban, sizeof(date_unban));
    else
        format(date_unban, sizeof(date_unban), "по решению администрации");

    format(dest, size,
        "{FFFFFF}Ваш игровой аккаунт был заблокирован администрацией за нарушение\n\
        правил сервера. Вы не можете играть на своём аккаунте во время действия блокировки.\n\n\
        {66CC00}| {FFFFFF}Ваш никнейм: {E0584B}%s\n\
        {66CC00}| {FFFFFF}Никнейм администратора: {E0584B}%s\n\
        {66CC00}| {FFFFFF}Дата выданной блокировки: {E0584B}%s\n\
        {66CC00}| {FFFFFF}Дата разблокировки аккаунта: {E0584B}%s\n\
        {66CC00}| {FFFFFF}Причина блокировки: {E0584B}%s\n\n\
        {FFFFFF}Вы не согласны с решением администратора и считаете, что наказание было\n\
        выдано несправедливо или ошибочно? В таком случае обратитесь в официальный раздел\n\
        с жалобой на форуме проекта: {E0584B}forum.blackrussia.online\n\
        {FFFFFF}Не забудьте прикрепить скриншот данного окна в жалобу.",
        nick, admin_nick, date_ban, date_unban, reason);
    return 1;
}

stock Admin_ShowBanDialog(playerid)
{
    new body[1024];
    Admin_BuildBanDialogText(playerid, body, sizeof(body));
    ShowPlayerDialog(playerid, DIALOG_ACCOUNT_BAN, DIALOG_STYLE_MSGBOX,
        "{E0584B}BR BLACK STUDIO {FFFFFF}| Аккаунт заблокирован",
        body, "Закрыть", "");
    return 1;
}

stock Admin_SaveBanToDatabase(playerid)
{
    if(Player[playerid][pID] <= 0) return 0;

    new query[384];
    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `players` SET `ban_time`=%d, `ban_start`=%d, `ban_days`=%d, `ban_reason`='%e', `ban_admin`='%e' WHERE `id`=%d LIMIT 1",
        Player[playerid][pBanTime], Player[playerid][pBanStart], Player[playerid][pBanDays],
        Player[playerid][pBanReason], Player[playerid][pBanAdmin],
        Player[playerid][pID]);
    mysql_query(db_handle, query, false);
    return 1;
}

stock Admin_EnsureBanListTable()
{
    mysql_tquery(db_handle,
        "CREATE TABLE IF NOT EXISTS `ban_list` (\
        `id` INT NOT NULL AUTO_INCREMENT,\
        `account_id` INT NOT NULL DEFAULT 0,\
        `name` VARCHAR(24) NOT NULL DEFAULT '',\
        `ban_start` INT NOT NULL DEFAULT 0,\
        `ban_end` INT NOT NULL DEFAULT 0,\
        `reason` VARCHAR(64) NOT NULL DEFAULT '',\
        `admin_name` VARCHAR(24) NOT NULL DEFAULT '',\
        PRIMARY KEY (`id`),\
        KEY `idx_ban_list_name` (`name`),\
        KEY `idx_ban_list_account` (`account_id`)\
        ) ENGINE=InnoDB DEFAULT CHARSET=cp1251 COLLATE=cp1251_general_ci", "", "");
    return 1;
}

stock Admin_InsertBanList(playerid)
{
    if(Player[playerid][pID] <= 0) return 0;
    if(!Admin_BanIsActive(Player[playerid][pBanTime])) return 0;

    new query[512];
    new ban_start = Player[playerid][pBanStart];
    if(ban_start <= 0) ban_start = gettime();

    mysql_format(db_handle, query, sizeof(query),
        "INSERT INTO `ban_list` (`account_id`,`name`,`ban_start`,`ban_end`,`reason`,`admin_name`) \
        VALUES (%d,'%e',%d,%d,'%e','%e')",
        Player[playerid][pID], Player[playerid][pName], ban_start, Player[playerid][pBanTime],
        Player[playerid][pBanReason], Player[playerid][pBanAdmin]);
    mysql_tquery(db_handle, query, "", "");
    return 1;
}

stock Admin_TrimNick(nick[])
{
    new len = strlen(nick);
    while(len > 0 && (nick[len - 1] == ' ' || nick[len - 1] == '\t')) nick[--len] = EOS;
    new start = 0;
    while(nick[start] == ' ' || nick[start] == '\t') start++;
    if(start > 0) strdel(nick, 0, start);
    return 1;
}

stock Admin_FindPlayerByExactNick(const nick[])
{
    if(!nick[0]) return INVALID_PLAYER_ID;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(!Player[i][pName][0]) continue;
        if(!strcmp(Player[i][pName], nick, true)) return i;
    }
    return INVALID_PLAYER_ID;
}

stock Admin_FormatBanStatus(targetid, dest[], size)
{
    if(!IsPlayerConnected(targetid))
    {
        format(dest, size, "Нет");
        return 1;
    }

    new ban_time = Player[targetid][pBanTime];
    if(!Admin_BanIsActive(ban_time))
    {
        format(dest, size, "Нет");
        return 1;
    }

    if(Admin_BanIsPermanent(ban_time))
    {
        format(dest, size, "Навсегда");
        return 1;
    }

    if(ban_time < ADMIN_BAN_UNIX_THRESHOLD)
    {
        format(dest, size, "Да (старый формат)");
        return 1;
    }

    new left_sec = ban_time - gettime();
    if(left_sec <= 0)
    {
        format(dest, size, "Нет");
        return 1;
    }

    new left_days = (left_sec + 86399) / 86400;
    if(left_days < 1) left_days = 1;
    format(dest, size, "%d дн.", left_days);
    return 1;
}

stock bool:Admin_SyncBanOnLogin(playerid)
{
    new ban_time = Player[playerid][pBanTime];
    if(!Admin_BanIsActive(ban_time))
    {
        if(ban_time > 0)
        {
            Admin_ClearBanFields(playerid);
            if(Player[playerid][pID] > 0)
            {
                new query[160];
                mysql_format(db_handle, query, sizeof(query),
                    "UPDATE `players` SET `ban_time`=0, `ban_start`=0, `ban_days`=0, `ban_reason`='', `ban_admin`='' WHERE `id`=%d LIMIT 1",
                    Player[playerid][pID]);
                mysql_tquery(db_handle, query, "", "");
            }
        }
        return false;
    }
    return true;
}

stock JailSystem(playerid)
{
    SetPlayerPos(playerid, 1000.0, 1000.0, 1000.0);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, playerid + 1);
    SendClientMessage(playerid, COLOR_RED, "Вы отбываете наказание в деморгане. Используйте /time для просмотра срока.");
    return 1;
}

stock ShowAdminLogin(playerid)
{
    if(Player[playerid][pAdminPass] == 0)
    {
        ShowPlayerDialog(playerid, DIALOG_ADMIN_REG, DIALOG_STYLE_INPUT,
            "{E0584B}BR BLACK STUDIO | Регистрация",
            "{FFFFFF}Вы были назначены администратором проекта.\n"\
            "Придумайте секретный пароль, состоящий из {E0584B}4-х цифр{FFFFFF}, и введите его ниже:",
            "Далее", "Отмена");
    }
    else
    {
        ShowPlayerDialog(playerid, DIALOG_ADMIN_LOGIN, DIALOG_STYLE_PASSWORD,
            "{E0584B}BR BLACK STUDIO | Авторизация",
            "{FFFFFF}Введите Ваш административный пароль, указанный при регистрации.\n"\
            "Пароль должен состоять из {E0584B}4-х цифр{FFFFFF}:",
            "Далее", "Отмена");
    }
    return 1;
}

stock Admin_DoKick(adminid, targetid, const reason[])
{
    if(!Player[adminid][pAdminAuth] || Player[adminid][pAdminLvl] < 1) return 0;
    if(!Admin_CanUsePunishments(adminid)) return 0;
    if(!Admin_CanActOnPlayer(adminid, targetid)) return 0;
    if(!IsPlayerConnected(targetid)) return 0;
    new reason_cp[64];
    BR_CopyUserText(reason_cp, sizeof(reason_cp), reason);
    new str[128];
    format(str, sizeof(str), "[A] Администратор %s кикнул %s. Причина: %s",
        Player[adminid][pName], Player[targetid][pName], reason_cp);
    SendClientMessageToAll(0xFF4B4BFF, str);
    Admin_HandleSpectateTargetLeave(targetid);
    Kick(targetid);
    return 1;
}

stock Admin_DoBan(adminid, targetid, days, const reason[])
{
    if(!Player[adminid][pAdminAuth] || Player[adminid][pAdminLvl] < 2) return 0;
    if(!Admin_CanUsePunishments(adminid)) return 0;
    if(!Admin_CanActOnPlayer(adminid, targetid)) return 0;
    if(!IsPlayerConnected(targetid)) return 0;
    if(targetid == adminid)
    {
        SendClientMessage(adminid, COLOR_RED, "[A] Нельзя забанить самого себя.");
        return 0;
    }
    if(Player[targetid][pID] <= 0)
    {
        SendClientMessage(adminid, COLOR_RED, "[A] Игрок ещё не авторизован — бан только по аккаунту после входа.");
        return 0;
    }

    new reason_cp[64];
    Admin_NormalizeBanReason(reason, reason_cp, sizeof(reason_cp));

    Player[targetid][pBanTime] = Admin_BanExpiryFromDays(days);
    Player[targetid][pBanStart] = gettime();
    Player[targetid][pBanDays] = days;
    format(Player[targetid][pBanReason], 64, "%s", reason_cp);
    format(Player[targetid][pBanAdmin], 24, "%s", Player[adminid][pName]);
    Admin_SaveBanToDatabase(targetid);
    Admin_InsertBanList(targetid);

    new str[144];
    if(Admin_BanIsPermanent(Player[targetid][pBanTime]))
    {
        format(str, sizeof(str), "[A] %s забанил аккаунт %s навсегда. Причина: %s",
            Player[adminid][pName], Player[targetid][pName], reason_cp);
    }
    else
    {
        format(str, sizeof(str), "[A] %s забанил аккаунт %s на %d дн. Причина: %s",
            Player[adminid][pName], Player[targetid][pName], days, reason_cp);
    }
    SendClientMessageToAll(0xFF4B4BFF, str);
    Admin_HandleSpectateTargetLeave(targetid);
    Kick(targetid);
    return 1;
}

stock Admin_DoPermBan(adminid, targetid, const reason[])
{
    return Admin_DoBan(adminid, targetid, 3650, reason);
}

stock Admin_DoUnban(adminid, const input_nick[])
{
    if(!Player[adminid][pAdminAuth] || Player[adminid][pAdminLvl] < 2) return 0;

    new nick[MAX_PLAYER_NAME];
    format(nick, sizeof(nick), "%s", input_nick);
    Admin_TrimNick(nick);
    if(!nick[0])
    {
        SendClientMessage(adminid, COLOR_GREY, "{999999}Используйте: /unban [ник]");
        return 0;
    }

    new query[220], db_name[MAX_PLAYER_NAME];
    new account_id = 0, ban_time = 0, rows = 0;

    mysql_format(db_handle, query, sizeof(query),
        "SELECT `id`, `name`, `ban_time` FROM `players` WHERE `name`='%e' LIMIT 1", nick);
    new Cache:result = mysql_query(db_handle, query, true);
    rows = cache_num_rows();
    if(rows > 0)
    {
        account_id = cache_get_field_content_int(0, "id", db_handle);
        ban_time = cache_get_field_content_int(0, "ban_time", db_handle);
        cache_get_field_content(0, "name", db_name, db_handle, MAX_PLAYER_NAME);
    }
    cache_delete(result);

    if(!rows)
    {
        mysql_format(db_handle, query, sizeof(query),
            "SELECT `id`, `name`, `ban_time` FROM `players` WHERE LOWER(`name`)=LOWER('%e') LIMIT 1", nick);
        result = mysql_query(db_handle, query, true);
        rows = cache_num_rows();
        if(rows > 0)
        {
            account_id = cache_get_field_content_int(0, "id", db_handle);
            ban_time = cache_get_field_content_int(0, "ban_time", db_handle);
            cache_get_field_content(0, "name", db_name, db_handle, MAX_PLAYER_NAME);
        }
        cache_delete(result);
    }

    if(!rows || account_id <= 0)
    {
        SendClientMessage(adminid, COLOR_GREY, "[A] Аккаунт с таким ником не найден.");
        return 0;
    }

    if(!Admin_BanIsActive(ban_time))
    {
        new msg[96];
        format(msg, sizeof(msg), "[A] Аккаунт %s не заблокирован.", db_name);
        SendClientMessage(adminid, COLOR_GREY, msg);
        return 0;
    }

    mysql_format(db_handle, query, sizeof(query),
        "UPDATE `players` SET `ban_time`=0, `ban_start`=0, `ban_days`=0, `ban_reason`='', `ban_admin`='' WHERE `id`=%d LIMIT 1",
        account_id);
    mysql_query(db_handle, query, false);

    if(cache_affected_rows() <= 0)
    {
        SendClientMessage(adminid, COLOR_GREY, "[A] Не удалось снять бан (ошибка базы данных).");
        return 0;
    }

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(Player[i][pID] != account_id) continue;
        Admin_ClearBanFields(i);
        break;
    }

    new msg[128];
    format(msg, sizeof(msg), "[A] %s снял бан с аккаунта %s.", Player[adminid][pName], db_name);
    SendClientMessageToAll(0xFF4B4BFF, msg);
    return 1;
}

stock Admin_DoMute(adminid, targetid, minutes, const reason[])
{
    if(!Player[adminid][pAdminAuth] || Player[adminid][pAdminLvl] < 1) return 0;
    if(!Admin_CanUsePunishments(adminid)) return 0;
    if(!Admin_CanActOnPlayer(adminid, targetid)) return 0;
    if(!IsPlayerConnected(targetid)) return 0;
    new reason_cp[64];
    BR_CopyUserText(reason_cp, sizeof(reason_cp), reason);
    Player[targetid][pMuteTime] = minutes;
    new str[128];
    format(str, sizeof(str), "[A] %s выдал мут %s на %d мин. Причина: %s",
        Player[adminid][pName], Player[targetid][pName], minutes, reason_cp);
    SendClientMessageToAll(0xFF4B4BFF, str);
    SavePlayerAccount(targetid);
    return 1;
}

stock Admin_DoJail(adminid, targetid, minutes, const reason[])
{
    if(!Player[adminid][pAdminAuth] || Player[adminid][pAdminLvl] < 1) return 0;
    if(!Admin_CanUsePunishments(adminid)) return 0;
    if(!Admin_CanActOnPlayer(adminid, targetid)) return 0;
    if(!IsPlayerConnected(targetid)) return 0;
    new reason_cp[64];
    BR_CopyUserText(reason_cp, sizeof(reason_cp), reason);
    Player[targetid][pJailTime] = minutes;
    JailSystem(targetid);
    new str[128];
    format(str, sizeof(str), "[A] %s посадил %s в деморган на %d мин. Причина: %s",
        Player[adminid][pName], Player[targetid][pName], minutes, reason_cp);
    SendClientMessageToAll(0xFF4B4BFF, str);
    SavePlayerAccount(targetid);
    return 1;
}

stock Admin_DoWarn(adminid, targetid, const reason[])
{
    if(!Player[adminid][pAdminAuth] || Player[adminid][pAdminLvl] < 2) return 0;
    if(!Admin_CanUsePunishments(adminid)) return 0;
    if(!Admin_CanActOnPlayer(adminid, targetid)) return 0;
    if(!IsPlayerConnected(targetid)) return 0;
    new reason_cp[64];
    BR_CopyUserText(reason_cp, sizeof(reason_cp), reason);
    Player[targetid][pWarns]++;
    new str[128];
    format(str, sizeof(str), "[A] %s выдал варн %s. Причина: %s (%d/3)",
        Player[adminid][pName], Player[targetid][pName], reason_cp, Player[targetid][pWarns]);
    SendClientMessageToAll(0xFF4B4BFF, str);
    if(Player[targetid][pWarns] >= 3)
    {
        Player[targetid][pWarns] = 0;
        Player[targetid][pBanTime] = Admin_BanExpiryFromDays(10);
        Player[targetid][pBanStart] = gettime();
        Player[targetid][pBanDays] = 10;
        format(Player[targetid][pBanReason], 64, "3/3 Warns");
        format(Player[targetid][pBanAdmin], 24, "Система");
        Admin_SaveBanToDatabase(targetid);
        Admin_InsertBanList(targetid);
        Admin_HandleSpectateTargetLeave(targetid);
        Kick(targetid);
    }
    else SavePlayerAccount(targetid);
    return 1;
}
