
/*
    Система объявлений / СМИ для текущей обновы.
    Команды: /smiad, /smi, /setsmi, /medianews, /smilive, /endlive, /smiu
*/
#if !defined SMI_SYSTEM_INCLUDED
#define SMI_SYSTEM_INCLUDED

#define SMI_AD_PRICE 5000
#define SMI_AD_DELAY 120

new SmiLevel[MAX_PLAYERS];
new SmiAdTime[MAX_PLAYERS];
new SmiLiveMate[MAX_PLAYERS];

stock Smi_ResetPlayer(playerid)
{
    SmiLevel[playerid] = 0;
    SmiAdTime[playerid] = 0;
    SmiLiveMate[playerid] = -1;
    return 1;
}

stock Smi_Init()
{
    mysql_tquery(mysql,
        "CREATE TABLE IF NOT EXISTS `smi_staff` (`account_id` INT NOT NULL, `level` INT NOT NULL DEFAULT 0, PRIMARY KEY (`account_id`)) ENGINE=InnoDB DEFAULT CHARSET=cp1251",
        "",
        ""
    );
    print("[SMI] Система СМИ/объявлений загружена.");
    return 1;
}

forward Smi_OnLoad(playerid);
stock Smi_LoadPlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[128];
    mysql_format(mysql, query, sizeof(query),
        "SELECT `level` FROM `smi_staff` WHERE `account_id`=%d LIMIT 1",
        GetPlayerAccountID(playerid)
    );
    mysql_tquery(mysql, query, "Smi_OnLoad", "i", playerid);
    return 1;
}

public Smi_OnLoad(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(cache_num_rows()) SmiLevel[playerid] = cache_get_field_content_int(0, "level", mysql);
    else SmiLevel[playerid] = 0;
    return 1;
}

stock Smi_SavePlayer(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[192];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO `smi_staff` (`account_id`, `level`) VALUES (%d, %d) ON DUPLICATE KEY UPDATE `level`=%d",
        GetPlayerAccountID(playerid), SmiLevel[playerid], SmiLevel[playerid]
    );
    mysql_tquery(mysql, query, "", "");
    return 1;
}

stock Smi_IsStaff(playerid)
{
    if(GetPlayerData(playerid, P_ADMIN) >= 1) return 1;
    return SmiLevel[playerid] > 0;
}

stock Smi_EndLive(playerid, bool:notify = true)
{
    new mate = SmiLiveMate[playerid];
    if(mate == -1) return 0;

    SmiLiveMate[playerid] = -1;
    if(IsPlayerConnected(mate) && SmiLiveMate[mate] == playerid)
    {
        SmiLiveMate[mate] = -1;
        if(notify) SendClientMessage(mate, 0xFFCC00FF, "Радиоэфир завершен.");
    }

    if(notify) SendClientMessage(playerid, 0xFFCC00FF, "Радиоэфир завершен.");
    return 1;
}

CMD:smi(playerid, params[])
{
    #pragma unused params
    if(Smi_IsStaff(playerid)) return GuiSmi_OpenEditor(playerid);
    SendClientMessage(playerid, 0x66CCFFFF, "Команды СМИ: /smiad [текст], /smieditor, /smiu [текст]");
    if(GetPlayerData(playerid, P_ADMIN) >= 5) SendClientMessage(playerid, 0x66CCFFFF, "Админ: /setsmi [id] [уровень 0-2]");
    return 1;
}

CMD:smiad(playerid, params[])
{
    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ad [текст объявления]");
    if(strlen(params) > 100) return SendClientMessage(playerid, 0xFF6666FF, "Слишком длинное объявление. Максимум 100 символов.");

    new now = gettime();
    if(SmiAdTime[playerid] > now)
    {
        new wait = SmiAdTime[playerid] - now;
        new msg_wait[96];
        format(msg_wait, sizeof(msg_wait), "Следующее объявление можно подать через %d сек.", wait);
        return SendClientMessage(playerid, 0xFFCC00FF, msg_wait);
    }

    if(GetPlayerMoneyEx(playerid) < SMI_AD_PRICE)
    {
        new need_msg[96];
        format(need_msg, sizeof(need_msg), "Подача объявления стоит %d руб.", SMI_AD_PRICE);
        return SendClientMessage(playerid, 0xFF6666FF, need_msg);
    }

    GivePlayerMoneyEx(playerid, -SMI_AD_PRICE);
    SmiAdTime[playerid] = now + SMI_AD_DELAY;

    new msg[180];
    format(msg, sizeof(msg), "[Объявление] %s[%d]: %s", GetPlayerData(playerid, P_NAME), playerid, params);
    SendClientMessageToAll(0xFFCC00FF, msg);
    // BlackPass_OnAdvertSent(playerid); // TODO: функция отсутствует в текущем коде базы, добавьте при наличии
    // FactionGUI_AddTaskProgress(playerid, 1, 1); // TODO: функция отсутствует в текущем коде базы, добавьте при наличии
    ShowNotificationKirill(playerid, 3, 5, 0, 1, "Объявление отправлено в эфир.", "");
    return 1;
}

CMD:medianews(playerid, params[])
{
    if(!Smi_IsStaff(playerid)) return SendClientMessage(playerid, 0xFF6666FF, "Вы не сотрудник СМИ.");
    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /medianews [текст]");
    if(strlen(params) > 120) return SendClientMessage(playerid, 0xFF6666FF, "Слишком длинная новость. Максимум 120 символов.");

    new msg[190];
    format(msg, sizeof(msg), "[СМИ] %s[%d]: %s", GetPlayerData(playerid, P_NAME), playerid, params);
    SendClientMessageToAll(0x66CCFFFF, msg);
    // FactionGUI_AddTaskProgress(playerid, 3, 1); // TODO: функция отсутствует в текущем коде базы, добавьте при наличии
    return 1;
}

CMD:setsmi(playerid, params[])
{
    if(GetPlayerData(playerid, P_ADMIN) < 5) return 1;

    new targetid, level;
    if(sscanf(params, "dd", targetid, level)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setsmi [id игрока] [уровень 0-2]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, 0xFF6666FF, "Игрок не найден.");
    if(level < 0 || level > 2) return SendClientMessage(playerid, 0xFF6666FF, "Уровень СМИ: 0-2.");

    SmiLevel[targetid] = level;
    Smi_SavePlayer(targetid);

    new msg[144];
    format(msg, sizeof(msg), "Вы установили уровень СМИ %d игроку %s[%d].", level, GetPlayerData(targetid, P_NAME), targetid);
    SendClientMessage(playerid, 0x66CC66FF, msg);

    format(msg, sizeof(msg), "Ваш уровень СМИ изменен на %d.", level);
    SendClientMessage(targetid, 0x66CCFFFF, msg);
    return 1;
}

CMD:smilive(playerid, params[])
{
    if(!Smi_IsStaff(playerid)) return SendClientMessage(playerid, 0xFF6666FF, "Вы не сотрудник СМИ.");

    new targetid;
    if(sscanf(params, "d", targetid)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /smilive [id игрока]");
    if(!IsPlayerConnected(targetid) || targetid == playerid) return SendClientMessage(playerid, 0xFF6666FF, "Игрок не найден.");
    if(SmiLiveMate[playerid] != -1) return SendClientMessage(playerid, 0xFF6666FF, "Вы уже в эфире. Используйте /endlive.");
    if(SmiLiveMate[targetid] != -1) return SendClientMessage(playerid, 0xFF6666FF, "Этот игрок уже участвует в эфире.");

    SmiLiveMate[playerid] = targetid;
    SmiLiveMate[targetid] = playerid;

    new msg[180];
    format(msg, sizeof(msg), "[СМИ] Начался прямой эфир. Ведущий: %s, гость: %s. Писать в эфир: /smiu [текст]", GetPlayerData(playerid, P_NAME), GetPlayerData(targetid, P_NAME));
    SendClientMessageToAll(0x66CCFFFF, msg);
    // FactionGUI_AddTaskProgress(playerid, 2, 1); // TODO: функция отсутствует в текущем коде базы, добавьте при наличии
    return 1;
}

CMD:endlive(playerid, params[])
{
    #pragma unused params
    if(SmiLiveMate[playerid] == -1) return SendClientMessage(playerid, 0xFF6666FF, "Вы сейчас не в радиоэфире.");
    Smi_EndLive(playerid, true);
    return 1;
}

CMD:smiliveout(playerid, params[])
{
    #pragma unused params
    if(SmiLiveMate[playerid] == -1) return SendClientMessage(playerid, 0xFF6666FF, "Вы сейчас не в радиоэфире.");
    Smi_EndLive(playerid, true);
    return 1;
}

CMD:smiu(playerid, params[])
{
    if(SmiLiveMate[playerid] == -1) return SendClientMessage(playerid, 0xFF6666FF, "Вы не участвуете в радиоэфире.");
    if(!strlen(params)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /smiu [текст]");
    if(strlen(params) > 120) return SendClientMessage(playerid, 0xFF6666FF, "Слишком длинный текст. Максимум 120 символов.");

    new msg[190];
    format(msg, sizeof(msg), "[Радиоэфир] %s[%d]: %s", GetPlayerData(playerid, P_NAME), playerid, params);
    SendClientMessageToAll(0x66CCFFFF, msg);
    return 1;
}

#endif
