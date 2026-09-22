// Account bans use both existing tables. No registration/account loader replacement.
#if defined _sr_admin_bans_included
    #endinput
#endif
#define _sr_admin_bans_included

stock SRAdmin_DBChange(query[], const phase[], &affected)
{
    new Cache:result = mysql_query(mysql, query);
    new error = mysql_errno(mysql);
    affected = error ? 0 : cache_affected_rows(mysql);
    if(result != Cache:0) cache_delete(result, mysql);
    if(!error) return 1;
    printf("[ADMIN] SQL_FAILED phase=%s errno=%d", phase, error);
    return 0;
}

stock SRAdmin_DBExec(query[], const phase[])
{
    new affected;
    return SRAdmin_DBChange(query, phase, affected);
}

stock SRAdmin_BanTransaction()
{
    new Cache:result = mysql_query(mysql,
        "SELECT TABLE_NAME FROM information_schema.TABLES WHERE TABLE_SCHEMA=DATABASE() AND TABLE_NAME IN ('accounts','ban_list','listban') AND ENGINE='InnoDB'");
    new error = mysql_errno(mysql);
    new rows = error ? 0 : cache_get_row_count(mysql);
    if(result != Cache:0) cache_delete(result, mysql);
    if(error || rows != 3)
    {
        printf("[ADMIN] BAN_STORAGE_UNSAFE errno=%d innodb_tables=%d expected=3", error, rows);
        return 0;
    }
    return SRAdmin_DBExec("START TRANSACTION", "ban_begin");
}

stock SRAdmin_LockBanAccounts(playerid, account, minimum)
{
    new query[256], actor_found, target_found, actor_level, target_level, invalid_level;
    mysql_format(mysql, query, sizeof query,
        "SELECT id,admin FROM accounts WHERE id IN (%d,%d) ORDER BY id FOR UPDATE", GetPlayerAccountID(playerid), account);
    new Cache:result = mysql_query(mysql, query);
    new error = mysql_errno(mysql);
    new rows = error ? 0 : cache_get_row_count(mysql);
    for(new i; i < rows; i++)
    {
        new id = cache_get_field_content_int(i, "id", mysql);
        new level = cache_get_field_content_int(i, "admin", mysql);
        if(level == 14) level = 13;
        if(level < 0 || level > 13) invalid_level = 1;
        if(id == GetPlayerAccountID(playerid)) { actor_found = 1; actor_level = level; }
        if(id == account) { target_found = 1; target_level = level; }
    }
    if(result != Cache:0) cache_delete(result, mysql);
    return !error && !invalid_level && actor_found && target_found && actor_level >= minimum && target_level <= actor_level && actor_level == SRAdmin_Level(playerid);
}

stock SRAdmin_BanAccount(playerid, account, days, ip[], reason[])
{
    if(!SRAdmin_Require(playerid, 3) || account <= 0 || days < 1 || days > 90) return 0;
    if(!SRAdmin_BanTransaction()) return 0;
    if(!SRAdmin_LockBanAccounts(playerid, account, 3))
    {
        SRAdmin_DBExec("ROLLBACK", "ban_rights_rollback");
        return 0;
    }
    new result = SRAdmin_WriteBanLocked(playerid, account, days, ip, reason);
    if(result != 1)
    {
        SRAdmin_DBExec("ROLLBACK", "ban_write_rollback");
        return result;
    }
    if(!SRAdmin_DBExec("COMMIT", "ban_commit_check_required")) return 0;
    printf("[ADMIN] BAN_APPLIED actor=%d account=%d target_account=%d days=%d", playerid, GetPlayerAccountID(playerid), account, days);
    return 1;
}

// Internal transaction participant. Call only after the caller has locked and checked both accounts.
// Also used for the donor's automatic ten-day ban on a third warning, available at level 2.
stock SRAdmin_WriteBanLocked(playerid, account, days, ip[], reason[])
{
    new query[768], now = gettime();
    mysql_format(mysql, query, sizeof query,
        "SELECT (SELECT COUNT(*) FROM listban WHERE acc_id=%d AND (unban_time=0 OR unban_time>%d)) + (SELECT COUNT(*) FROM ban_list WHERE user_id=%d AND (ban_time=0 OR ban_time>%d)) AS active_bans",
        account, now, account, now);
    new Cache:result = mysql_query(mysql, query);
    new error = mysql_errno(mysql);
    new existing = error ? 0 : cache_get_field_content_int(0, "active_bans", mysql);
    if(result != Cache:0) cache_delete(result, mysql);
    if(error || existing)
    {
        return existing ? -1 : 0;
    }
    // Donor counts expiry from the beginning of the current day.
    new begin = now - (now % 86400), end = begin + days * 86400;
    new short_reason[33];
    format(short_reason, sizeof short_reason, "%s", reason);
    mysql_format(mysql, query, sizeof query, "DELETE FROM ban_list WHERE user_id=%d", account);
    new ok = SRAdmin_DBExec(query, "ban_remove_expired_legacy");
    if(ok)
    {
        mysql_format(mysql, query, sizeof query, "DELETE FROM listban WHERE acc_id=%d", account);
        ok = SRAdmin_DBExec(query, "ban_remove_expired_primary");
    }
    if(ok)
    {
        mysql_format(mysql, query, sizeof query,
            "INSERT INTO ban_list (user_id,time,ban_time,ip,description,admin) VALUES (%d,%d,%d,'%e','%e','%e')",
            account, begin, end, ip, short_reason, GetPlayerNameEx(playerid));
        ok = SRAdmin_DBExec(query, "ban_insert_legacy");
    }
    if(ok)
    {
        mysql_format(mysql, query, sizeof query,
            "INSERT INTO listban (acc_id,player_name,admin_name,reason,ban_time,unban_time) SELECT id,name,'%e','%e',%d,%d FROM accounts WHERE id=%d",
            GetPlayerNameEx(playerid), reason, begin, end, account);
        new affected;
        ok = SRAdmin_DBChange(query, "ban_insert_primary", affected) && affected == 1;
    }
    return ok;
}

// Диагностика: если аккаунт не нашёлся - пишем в консоль, что вообще лежит в БД, к которой подключён сервер.
stock SRAdmin_LogLookupMiss(name[])
{
    new Cache:result = mysql_query(mysql,
        "SELECT (SELECT COUNT(*) FROM accounts) AS acc_cnt,(SELECT COUNT(*) FROM listban) AS lb_cnt,(SELECT COUNT(*) FROM ban_list) AS bl_cnt,DATABASE() AS db_name");
    if(result == Cache:0)
    {
        printf("[ADMIN] ACCOUNT_LOOKUP_MISS name=%s diag_query_failed errno=%d", name, mysql_errno(mysql));
        return 0;
    }
    new db_name[48];
    cache_get_field_content(0, "db_name", db_name, mysql, sizeof db_name);
    printf("[ADMIN] ACCOUNT_LOOKUP_MISS name=%s len=%d db=%s accounts=%d listban=%d ban_list=%d",
        name, strlen(name), db_name,
        cache_get_field_content_int(0, "acc_cnt", mysql),
        cache_get_field_content_int(0, "lb_cnt", mysql),
        cache_get_field_content_int(0, "bl_cnt", mysql));
    cache_delete(result, mysql);
    return 1;
}

// Возвращает: 1 - аккаунт найден, 0 - такого аккаунта нет, -1 - ошибка БД.
// name может быть ником ИЛИ номером аккаунта (только цифры). Регистр ника не важен.
// banned_only = 1: ищем именно заблокированный аккаунт - по нику в accounts, по нику в listban.player_name
// (если ник в accounts отличается/аккаунт переименован) или по номеру аккаунта. accounts.name не UNIQUE,
// поэтому из одноимённых берётся тот, у которого есть запись о бане.
// Успех запроса определяется по валидному кэшу, а не по mysql_errno().
stock SRAdmin_FindAccount(name[], &account, &level, ip[], ip_size, banned_only = 0)
{
    account = 0;
    level = 0;
    ip[0] = EOS;
    if(!name[0]) return 0;

    new numeric_id = -1, len = strlen(name);
    if(len > 0 && len <= 9)
    {
        numeric_id = strval(name);
        for(new i; i < len; i++) if(name[i] < '0' || name[i] > '9') { numeric_id = -1; break; }
        if(numeric_id == 0) numeric_id = -1;
    }

    new query[1024];
    if(banned_only)
    {
        mysql_format(mysql, query, sizeof query,
            "SELECT a.id,a.admin,a.last_ip FROM accounts a WHERE (LOWER(a.name)=LOWER('%e') OR a.id=%d OR a.id IN (SELECT acc_id FROM listban WHERE LOWER(player_name)=LOWER('%e'))) AND (EXISTS(SELECT 1 FROM listban b WHERE b.acc_id=a.id) OR EXISTS(SELECT 1 FROM ban_list l WHERE l.user_id=a.id)) ORDER BY a.id DESC LIMIT 1",
            name, numeric_id, name);
    }
    else
    {
        mysql_format(mysql, query, sizeof query,
            "SELECT id,admin,last_ip FROM accounts WHERE LOWER(name)=LOWER('%e') OR id=%d ORDER BY (name='%e') DESC, id DESC LIMIT 1",
            name, numeric_id, name);
    }

    new Cache:result = mysql_query(mysql, query);
    new error = mysql_errno(mysql);
    if(result == Cache:0)
    {
        printf("[ADMIN] ACCOUNT_LOOKUP_FAILED name=%s errno=%d", name, error);
        return -1;
    }

    new rows = cache_get_row_count(mysql);
    if(rows > 0)
    {
        account = cache_get_field_content_int(0, "id", mysql);
        level = cache_get_field_content_int(0, "admin", mysql);
        cache_get_field_content(0, "last_ip", ip, mysql, ip_size);
    }
    cache_delete(result, mysql);
    printf("[ADMIN] ACCOUNT_LOOKUP name=%s banned_only=%d rows=%d account=%d errno=%d", name, banned_only, rows, account, error);
    if(rows > 0 && account > 0) return 1;
    if(!banned_only) SRAdmin_LogLookupMiss(name);
    return 0;
}

stock SRAdmin_UnbanAccount(playerid, account)
{
    if(!SRAdmin_Require(playerid, 3) || account <= 0) return 0;
    if(!SRAdmin_BanTransaction()) return 0;
    if(!SRAdmin_LockBanAccounts(playerid, account, 3))
    {
        SRAdmin_DBExec("ROLLBACK", "unban_rights_rollback");
        return 0;
    }
    new query[160], affected, changed;
    mysql_format(mysql, query, sizeof query, "DELETE FROM listban WHERE acc_id=%d", account);
    new ok = SRAdmin_DBChange(query, "unban_delete_primary", changed);
    if(ok) affected += changed;
    if(ok)
    {
        mysql_format(mysql, query, sizeof query, "DELETE FROM ban_list WHERE user_id=%d", account);
        ok = SRAdmin_DBChange(query, "unban_delete_legacy", changed);
        if(ok) affected += changed;
    }
    if(!ok || affected == 0)
    {
        SRAdmin_DBExec("ROLLBACK", "unban_rollback");
        return ok ? -1 : 0;
    }
    if(!SRAdmin_DBExec("COMMIT", "unban_commit_check_required")) return 0;
    printf("[ADMIN] UNBAN_APPLIED actor=%d account=%d target_account=%d", playerid, GetPlayerAccountID(playerid), account);
    return 1;
}

stock SRAdmin_Target(playerid, targetid, level)
{
    if(!SRAdmin_Require(playerid, level)) return 0;
    if(targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
    {
        SendClientMessage(playerid, -1, "Игрок не найден.");
        return 0;
    }
    if((GetPlayerAdminEx(targetid) > 0 && SRAdmin_Level(targetid) == 0) || SRAdmin_Level(targetid) > SRAdmin_Level(playerid))
    {
        SendClientMessage(playerid, -1, "У цели административный уровень выше вашего.");
        return 0;
    }
    return 1;
}

stock SRAdmin_SafeKick(playerid)
{
    // No delayed playerid-only callback: a later occupant of the slot cannot be kicked.
    return Kick(playerid);
}

stock SRAdmin_SaveTimer(playerid, targetid, value, sr_is_jail)
{
    if(!SRAdmin_Target(playerid, targetid, 1)) return 0;
    if(value < 0 || value > 360 * 60) return 0;
    new field[8], query[192];
    if(sr_is_jail) format(field, sizeof field, "jail");
    else format(field, sizeof field, "mute");
    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET `%s`=%d WHERE id=%d AND admin=%d LIMIT 1",
        field, value, GetPlayerAccountID(targetid), GetPlayerAdminEx(targetid));
    new affected;
    if(!SRAdmin_DBChange(query, "punishment_save", affected)) return 0;
    if(affected == 1) return 1;
    // MySQL can report zero changed rows when the desired value is already stored.
    mysql_format(mysql, query, sizeof query,
        "SELECT id FROM accounts WHERE id=%d AND admin=%d AND `%s`=%d LIMIT 1",
        GetPlayerAccountID(targetid), GetPlayerAdminEx(targetid), field, value);
    new Cache:result = mysql_query(mysql, query);
    new error = mysql_errno(mysql);
    new rows = error ? 0 : cache_get_row_count(mysql);
    if(result != Cache:0) cache_delete(result, mysql);
    return !error && rows == 1;
}

stock SRAdmin_SaveWarning(playerid, targetid, remove, &warn_count)
{
    if(!SRAdmin_Target(playerid, targetid, 2)) return 0;
    if(!SRAdmin_BanTransaction()) return 0;
    new account = GetPlayerAccountID(targetid);
    if(!SRAdmin_LockBanAccounts(playerid, account, 2))
    {
        SRAdmin_DBExec("ROLLBACK", "warn_rights_rollback");
        return 0;
    }
    new query[256], count, expiry;
    mysql_format(mysql, query, sizeof query, "SELECT warn,warn_time FROM accounts WHERE id=%d", account);
    new Cache:result = mysql_query(mysql, query);
    new error = mysql_errno(mysql);
    new rows = error ? 0 : cache_get_row_count(mysql);
    if(rows == 1)
    {
        count = cache_get_field_content_int(0, "warn", mysql);
        expiry = cache_get_field_content_int(0, "warn_time", mysql);
    }
    if(result != Cache:0) cache_delete(result, mysql);
    if(error || rows != 1 || count < 0)
    {
        SRAdmin_DBExec("ROLLBACK", "warn_read_rollback");
        return 0;
    }
    // Expired warnings must not unexpectedly become an automatic ban.
    if(expiry > 0 && expiry <= gettime()) count = 0;
    if(remove) count = 0;
    else if(count < 3) count++;
    warn_count = count;
    new automatic_ban = !remove && count >= 3;
    if(automatic_ban && SRAdmin_WriteBanLocked(playerid, account, 10, GetPlayerIpEx(targetid), "получено 3 варна") != 1)
    {
        SRAdmin_DBExec("ROLLBACK", "warn_ban_rollback");
        return 0;
    }
    if(automatic_ban) count = 0;
    expiry = count > 0 ? gettime() + 86400 * 10 : 0;
    if(remove)
        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET warn=0,warn_time=0 WHERE id=%d LIMIT 1", account);
    else
        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET warn=%d,warn_time=%d,team=0,org_skin=0,job=0 WHERE id=%d LIMIT 1", count, expiry, account);
    if(!SRAdmin_DBExec(query, "warn_save"))
    {
        SRAdmin_DBExec("ROLLBACK", "warn_save_rollback");
        return 0;
    }
    if(!SRAdmin_DBExec("COMMIT", "warn_commit_check_required")) return 0;
    SetPlayerData(targetid, P_WARN, count);
    SetPlayerData(targetid, P_WARN_TIME, expiry);
    if(!remove)
    {
        // Persisted above together with the warning; reuse the local organisation runtime API.
        InvitePlayer(targetid, 0, 0, false);
        SetPlayerData(targetid, P_OSKIN, 0);
        ResetSkin(targetid);
    }
    printf("[ADMIN] WARN_SAVED actor=%d account=%d target_account=%d count=%d cleared=%d automatic_ban=%d", playerid, GetPlayerAccountID(playerid), account, warn_count, remove, automatic_ban);
    return 1;
}
