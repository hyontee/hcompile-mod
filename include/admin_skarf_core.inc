// Administrative identity and PIN flow adapted from skarf/ryzen.
// This is a staging module, not the completed administrative-system replacement.
#if defined _sr_admin_core_included
    #endinput
#endif
#define _sr_admin_core_included

#define SR_ADMIN_MAX_LEVEL (11)

new g_SRAdminSession[MAX_PLAYERS];
new const g_SRAdminRank[][32] =
{
    "Игрок",
    "Агент Поддержки",
    "Стажер",
    "Мл.Модератор",
    "Модератор",
    "Ст.Модератор",
    "Мл.Администратор",
    "Администратор",
    "Администратор 2 разряда",
    "Администратор 3 разряда",
    "Опытный администратор",
    "Администратор 11 уровня"
};

// Должности, начиная с "Куратора администрации" и выше (см. g_admin_ranks_ga
// в bless.pwn) — при входе в админ-панель для них в чат администрации уходит
// короткая строка без звания/IP, см. SRAdmin_PinResponse ниже. Чтобы добавить
// сюда ещё одну должность — допишите её точное название (как в prefix) в этот список.
static const g_SRAdminSeniorPrefixes[][40] =
{
    "Куратор администрации",
    "Заместитель ГА",
    "Основной заместитель ГА",
    "Главный администратор",
    "Зам. спец администратора",
    "Спец. администратор",
    "Разработчик игры",
    "Руководитель проекта",
    "Владелец игры"
};

stock bool: SRAdmin_IsSeniorPosition(playerid)
{
    new prefix[40];
    format(prefix, sizeof prefix, "%s", GetPlayerData(playerid, P_PREFIX));
    for(new i; i < sizeof(g_SRAdminSeniorPrefixes); i++)
        if(!strcmp(prefix, g_SRAdminSeniorPrefixes[i])) return true;
    return false;
}

stock SRAdmin_Level(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    new level = GetPlayerAdminEx(playerid);
    // Founder role at raw level 14 still maps to the top named rank (now 11 levels).
    if(level == 14) return SR_ADMIN_MAX_LEVEL;
    if(level < 0 || level > SR_ADMIN_MAX_LEVEL) return 0;
    return level;
}

stock SRAdmin_Session(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return -1;
    return g_SRAdminSession[playerid];
}

stock SRAdmin_ClearTarget(playerid)
{
    DeletePVar(playerid, "SRAdmTarget");
    DeletePVar(playerid, "SRAdmTargetAccount");
    DeletePVar(playerid, "SRAdmTargetSession");
    DeletePVar(playerid, "SRAdmTargetPending");
    return 1;
}

stock SRAdmin_Reset(playerid)
{
    g_SRAdminSession[playerid]++;
    SRAdmin_ClearTarget(playerid);
    DeletePVar(playerid, "SRAdmPinStep");
    DeletePVar(playerid, "SRAdmPinAttempts");
    DeletePVar(playerid, "SRAdmPinBlocked");
    DeletePVar(playerid, "AdminLoginAttempts");
    DeletePVar(playerid, "AdminPass");
    DeletePVar(playerid, "SRTeleportPending");
    DeletePVar(playerid, "SRAdminsPending");
    DeletePVar(playerid, "SRAdminsPage");
    DeletePVar(playerid, "SRAdminsPrevious");
    DeletePVar(playerid, "SRAdminsNext");
    DeletePVar(playerid, "SRSpecTargetSession");
    DeletePVar(playerid, "SRSpecStartHouse");
    DeletePVar(playerid, "SRSpecStartBiz");
    DeletePVar(playerid, "SRHelpPending");
    DeletePVar(playerid, "SRHelpLevel");
    DeletePVar(playerid, "SRHelpPage");
    DeletePVar(playerid, "SRHelpMore");
    SetPlayerData(playerid, P_ADMIN_LOGGED, 0);
    return 1;
}

stock SRAdmin_ShowLogin(playerid)
{
    if(!IsPlayerLogged(playerid) || !SRAdmin_Level(playerid)) return 0;
    if(GetPlayerData(playerid, P_ADMIN_LOGGED)) return 1;
    if(GetPVarInt(playerid, "SRAdmPinBlocked")) return 0;
    new registration = GetPlayerData(playerid, P_APASS) == 0;
    SetPVarInt(playerid, "SRAdmPinStep", registration ? 1 : 2);
    if(registration)
        return Dialog(playerid, DIALOG_ADMIN_REG, DIALOG_STYLE_PASSWORD,
            "Регистрация админ-панели", "Придумайте отдельный пароль администратора: 4 цифры, от 1000 до 9999.", "Готово", "Отмена");
    return Dialog(playerid, DIALOG_ADMIN_LOGIN, DIALOG_STYLE_PASSWORD,
        "Вход в админ-панель", "Введите свой административный пароль.", "Войти", "Отмена");
}

stock SRAdmin_Require(playerid, min_level)
{
    if(!IsPlayerLogged(playerid) || SRAdmin_Level(playerid) < min_level)
    {
        SendClientMessage(playerid, 0xFF5533FF, "Недостаточно административных прав.");
        return 0;
    }
    if(!GetPlayerData(playerid, P_ADMIN_LOGGED))
    {
        SRAdmin_ShowLogin(playerid);
        return 0;
    }
    return 1;
}

stock SRAdmin_PinResponse(playerid, dialogid, response, const inputtext[])
{
    if(!IsPlayerLogged(playerid) || !SRAdmin_Level(playerid)) return 1;
    if(GetPlayerData(playerid, P_ADMIN_LOGGED) || GetPVarInt(playerid, "SRAdmPinBlocked")) return 1;
    new expected = (dialogid == DIALOG_ADMIN_REG) ? 1 : 2;
    if(GetPVarInt(playerid, "SRAdmPinStep") != expected) return 1;
    DeletePVar(playerid, "SRAdmPinStep");
    if(!response) return 1;
    new length = strlen(inputtext), numeric = length == 4;
    for(new i; i < length; i++)
        if(inputtext[i] < '0' || inputtext[i] > '9') numeric = 0;

    if(expected == 1)
    {
        if(GetPlayerData(playerid, P_APASS) != 0) return 1;
        if(!numeric || length != 4 || strval(inputtext) < 1000)
        {
            SendClientMessage(playerid, 0xFF5533FF, "Пароль должен состоять из четырёх цифр, от 1000 до 9999.");
            return SRAdmin_ShowLogin(playerid);
        }
        new query[192];
        mysql_format(mysql, query, sizeof query,
            "UPDATE accounts SET AdminPass=%d WHERE id=%d AND AdminPass=0 AND admin=%d LIMIT 1",
            strval(inputtext), GetPlayerAccountID(playerid), GetPlayerAdminEx(playerid));
        new Cache:result = mysql_query(mysql, query);
        new error = mysql_errno(mysql);
        new affected = error ? 0 : cache_affected_rows(mysql);
        if(result != Cache:0) cache_delete(result, mysql);
        if(error || affected != 1)
        {
            printf("[ADMIN] PIN_SAVE_FAILED player=%d account=%d errno=%d affected=%d", playerid, GetPlayerAccountID(playerid), error, affected);
            SendClientMessage(playerid, 0xFF5533FF, "Не удалось сохранить административный пароль. Повторите вход позже.");
            return 1;
        }
        SetPlayerData(playerid, P_APASS, strval(inputtext));
        return SRAdmin_ShowLogin(playerid);
    }

    if(!numeric || GetPlayerData(playerid, P_APASS) == 0 || strval(inputtext) != GetPlayerData(playerid, P_APASS))
    {
        new attempts = GetPVarInt(playerid, "SRAdmPinAttempts") + 1;
        SetPVarInt(playerid, "SRAdmPinAttempts", attempts);
        printf("[ADMIN] LOGIN_FAILED player=%d account=%d attempt=%d", playerid, GetPlayerAccountID(playerid), attempts);
        if(attempts >= 3)
        {
            SetPVarInt(playerid, "SRAdmPinBlocked", 1);
            return FixKick(playerid);
        }
        SendClientMessage(playerid, 0xFF5533FF, "Неверный административный пароль.");
        return SRAdmin_ShowLogin(playerid);
    }

    DeletePVar(playerid, "SRAdmPinAttempts");
    SetPlayerData(playerid, P_ADMIN_LOGGED, 1);
    RefreshAdminBadge(playerid);
    new level = SRAdmin_Level(playerid);
    new rank_display[40];
    if(GetPlayerData(playerid, P_BUYADMIN)) format(rank_display, sizeof rank_display, "Покупной администратор");
    else format(rank_display, sizeof rank_display, "%s", g_SRAdminRank[level]);
    if(SRAdmin_IsSeniorPosition(playerid))
    {
        // Руководящие должности (от Куратора администрации и выше): в чат
        // администрации уходит только короткая строка, без звания и IP,
        // тёмно-красным цветом.
        new short_message[80];
        format(short_message, sizeof short_message, "%s авторизовался в админ-панели", GetPlayerNameEx(playerid));
        SendMessageToAdmins(short_message, 0x8B0000FF);
    }
    else
    {
        // Формат как в harti.pwn (callback::AloginReg/OnPlayerCheckAdmin):
        // "<Звание> <Ник>[<id>] авторизовался [IP: ... | R-IP ...]"
        new message[192];
        format(message, sizeof message, "%s %s[%d] авторизовался [IP: %s | R-IP %s]",
            rank_display, GetPlayerNameEx(playerid), playerid, GetPlayerIpEx(playerid), GetPlayerData(playerid, P_REG_IP));
        SendMessageToAdmins(message, 0x33CC33FF);
    }
    new personal_message[80];
    format(personal_message, sizeof personal_message, "Вы авторизовались как %s.", rank_display);
    SendClientMessage(playerid, 0x33CC33FF, personal_message);
    printf("[ADMIN] LOGIN_SUCCESS player=%d account=%d level=%d", playerid, GetPlayerAccountID(playerid), level);
    return 1;
}

// =========================================================
// /setadmin — по нику, работает и для офлайн-игроков (как callback::SetAdmin в harti.pwn).
// level == 0 снимает админку. type: 0 — обычный, 1 — покупной (P_BUYADMIN).
// =========================================================
stock SRAdmin_SetAdminByName(playerid, name[], level, type)
{
    new account, old_level, ip[16];
    if(!SRAdmin_FindAccount(name, account, old_level, ip, sizeof ip))
        return SendClientMessage(playerid, -1, "Аккаунт не найден либо БД недоступна.");
    if(old_level == 14) old_level = SR_ADMIN_MAX_LEVEL;
    if(old_level > SRAdmin_Level(playerid))
        return SendClientMessage(playerid, -1, "У цели административный уровень выше вашего.");
    if(old_level == level) return SendClientMessage(playerid, -1, "У игрока уже установлен этот уровень.");

    new targetid = GetPlayerID(name);
    new query[320], message[192];

    if(level == 0)
    {
        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET admin=0,buy_admin=0,prefix='' WHERE id=%d LIMIT 1", account);
        if(!SRAdmin_DBExec(query, "setadmin_remove")) return SendClientMessage(playerid, -1, "Не удалось сохранить снятие. Проверьте серверный журнал.");
        if(targetid != INVALID_PLAYER_ID)
        {
            if(GetPlayerSpectateData(targetid, S_PLAYER) != -1) StopSpectate(targetid);
            SetPlayerData(targetid, P_ADMIN, 0);
            SetPlayerData(targetid, P_BUYADMIN, 0);
            SetPlayerData(targetid, P_ADMIN_LOGGED, 0);
            format(GetPlayerData(targetid, P_PREFIX), 32, "");
            SRAdmin_ClearTarget(targetid);
            DeletePVar(targetid, "SRAdmPinStep");
        }
        format(message, sizeof message, "Вы сняли %s с должности администратора", name);
        SendClientMessage(playerid, 0x66CC33FF, message);
        format(message, sizeof message, "[A] %s снял %s с должности администратора", GetPlayerNameEx(playerid), name);
        SendMessageToAdmins(message, 0x999999FF);
    }
    else
    {
        if(level < 0 || level > SR_ADMIN_MAX_LEVEL || level > SRAdmin_Level(playerid))
            return SendClientMessage(playerid, -1, "Недопустимый уровень.");
        new rank_name[32];
        format(rank_name, sizeof rank_name, "%s", g_SRAdminRank[level]);
        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET admin=%d,buy_admin=%d,prefix='%e' WHERE id=%d LIMIT 1", level, type ? 1 : 0, rank_name, account);
        if(!SRAdmin_DBExec(query, "setadmin_apply")) return SendClientMessage(playerid, -1, "Не удалось сохранить уровень. Проверьте серверный журнал.");
        if(targetid != INVALID_PLAYER_ID)
        {
            SetPlayerData(targetid, P_ADMIN, level);
            SetPlayerData(targetid, P_BUYADMIN, type ? 1 : 0);
            SetPlayerData(targetid, P_ADMIN_LOGGED, 0);
            format(GetPlayerData(targetid, P_PREFIX), 32, "%s", rank_name);
            SRAdmin_ClearTarget(targetid);
            DeletePVar(targetid, "SRAdmPinStep");
            if(old_level == 0)
            {
                format(message, sizeof message, "%s назначил Вас администратором", GetPlayerNameEx(playerid));
                SendClientMessage(targetid, 0x66CC33FF, message);
            }
            else
            {
                format(message, sizeof message, "Ваш административный уровень изменён: %d -> %d", old_level, level);
                SendClientMessage(targetid, 0xFF5533FF, message);
            }
        }
        format(message, sizeof message, "Вы установили уровень администратора %s на %d", name, level);
        SendClientMessage(playerid, 0x66CC33FF, message);
        format(message, sizeof message, "[A] %s установил уровень администратора %s на %d", GetPlayerNameEx(playerid), name, level);
        SendMessageToAdmins(message, 0x999999FF);
    }

    new log_desc[192];
    format(log_desc, sizeof log_desc, "/setadmin %s -> level=%d type=%d (был %d)", name, level, type, old_level);
    SRAdmin_WriteLog(playerid, LOG_TYPE_SET_ADMIN, log_desc);
    printf("[ADMIN] SETADMIN actor=%d name=%s account=%d old_level=%d new_level=%d type=%d", playerid, name, account, old_level, level, type);
    return 1;
}

stock SRAdmin_ApplyLevel(playerid, targetid, level, min_level, strict_hierarchy = 0)
{
    if(!SRAdmin_Require(playerid, min_level)) return 1;
    if(targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid) || targetid == playerid)
        return SendClientMessage(playerid, 0xFF5533FF, "Недопустимый игрок.");
    new actor_level = SRAdmin_Level(playerid), target_level = SRAdmin_Level(targetid);
    if(level < 0 || level > SR_ADMIN_MAX_LEVEL || level > actor_level || target_level > actor_level || (strict_hierarchy && target_level >= actor_level))
        return SendClientMessage(playerid, 0xFF5533FF, "Недопустимый уровень или нарушение иерархии администрации.");
    if(GetPlayerAdminEx(targetid) != 0 && target_level == 0)
        return SendClientMessage(playerid, 0xFF5533FF, "Неизвестный текущий уровень цели. Требуется проверка владельцем.");
    new old_level = GetPlayerAdminEx(targetid);
    if(old_level == level) return SendClientMessage(playerid, -1, "У игрока уже установлен этот уровень.");
    new query[320], rank_name[32];
    if(level > 0) format(rank_name, sizeof rank_name, "%s", g_SRAdminRank[level]);
    mysql_format(mysql, query, sizeof query,
        "UPDATE accounts SET admin=%d,prefix='%e' WHERE id=%d AND admin=%d LIMIT 1",
        level, rank_name, GetPlayerAccountID(targetid), old_level);
    new Cache:result = mysql_query(mysql, query);
    new error = mysql_errno(mysql);
    new affected = error ? 0 : cache_affected_rows(mysql);
    if(result != Cache:0) cache_delete(result, mysql);
    if(error || affected != 1)
    {
        printf("[ADMIN] LEVEL_SAVE_FAILED actor=%d target=%d account=%d errno=%d affected=%d", playerid, targetid, GetPlayerAccountID(targetid), error, affected);
        return SendClientMessage(playerid, 0xFF5533FF, "Не удалось сохранить уровень. Изменение в игре не применено.");
    }
    // End observation while the old permission is still available to its cleanup function.
    if(GetPlayerSpectateData(targetid, S_PLAYER) != -1) StopSpectate(targetid);
    SetPlayerData(targetid, P_ADMIN, level);
    SetPlayerData(targetid, P_ADMIN_LOGGED, 0);
    format(GetPlayerData(targetid, P_PREFIX), 32, "%s", rank_name);
    SRAdmin_ClearTarget(targetid);
    DeletePVar(targetid, "SRAdmPinStep");
    new message[192];
    format(message, sizeof message, "[A] %s[%d] изменил уровень %s[%d]: %d -> %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid, old_level, level);
    SendMessageToAdmins(message, 0xFF5533FF);
    SendClientMessage(targetid, 0xFF5533FF, message);
    printf("[ADMIN] LEVEL_CHANGED actor=%d actor_account=%d target=%d target_account=%d old=%d new=%d", playerid, GetPlayerAccountID(playerid), targetid, GetPlayerAccountID(targetid), old_level, level);
    new description[144], log_query[512];
    format(description, sizeof description, "Admin level: target=%s account=%d old=%d new=%d", GetPlayerNameEx(targetid), GetPlayerAccountID(targetid), old_level, level);
    mysql_format(mysql, log_query, sizeof log_query,
        "INSERT INTO action_log (acc_id,uip,type,description,time) VALUES (%d,'%e',%d,'%e',%d)",
        GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), LOG_TYPE_SET_ADMIN, description, gettime());
    mysql_query(mysql, log_query, false);
    if(mysql_errno(mysql)) printf("[ADMIN] LEVEL_LOG_FAILED actor_account=%d target_account=%d errno=%d", GetPlayerAccountID(playerid), GetPlayerAccountID(targetid), mysql_errno(mysql));
    if(level > 0) SRAdmin_ShowLogin(targetid);
    return 1;
}

stock SRAdmin_OpenAssignment(playerid, targetid)
{
    SRAdmin_ClearTarget(playerid);
    if(!SRAdmin_Require(playerid, 9)) return 1;
    if(targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid) || targetid == playerid)
        return SendClientMessage(playerid, 0xFF5533FF, "Недопустимый игрок.");
    if(SRAdmin_Level(targetid) > SRAdmin_Level(playerid)) return SendClientMessage(playerid, 0xFF5533FF, "У цели уровень выше вашего.");
    SetPVarInt(playerid, "SRAdmTargetPending", 1);
    SetPVarInt(playerid, "SRAdmTarget", targetid);
    SetPVarInt(playerid, "SRAdmTargetAccount", GetPlayerAccountID(targetid));
    SetPVarInt(playerid, "SRAdmTargetSession", g_SRAdminSession[targetid]);
    new list[640];
    for(new level = 1; level <= SR_ADMIN_MAX_LEVEL; level++)
    {
        strcat(list, g_SRAdminRank[level], sizeof list);
        if(level != SR_ADMIN_MAX_LEVEL) strcat(list, "\n", sizeof list);
    }
    return Dialog(playerid, DIALOG_SETADMINS, DIALOG_STYLE_LIST, "Назначение администратора", list, "Выбрать", "Отмена");
}

stock SRAdmin_AssignmentResponse(playerid, response, listitem)
{
    if(!GetPVarInt(playerid, "SRAdmTargetPending")) return 1;
    new targetid = GetPVarInt(playerid, "SRAdmTarget");
    new account = GetPVarInt(playerid, "SRAdmTargetAccount");
    new session = GetPVarInt(playerid, "SRAdmTargetSession");
    SRAdmin_ClearTarget(playerid);
    if(!response) return 1;
    if(!SRAdmin_Require(playerid, 9)) return 1;
    if(listitem < 0 || listitem >= SR_ADMIN_MAX_LEVEL) return 1;
    if(targetid < 0 || targetid >= MAX_PLAYERS || !IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return 1;
    if(GetPlayerAccountID(targetid) != account || g_SRAdminSession[targetid] != session)
        return SendClientMessage(playerid, 0xFF5533FF, "Игрок переподключился. Выберите его заново.");
    return SRAdmin_ApplyLevel(playerid, targetid, listitem + 1, 9);
}
