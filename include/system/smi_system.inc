
/*
    Система объявлений / СМИ для текущей обновы.
    Команды: /smiad, /smi, /setsmi, /medianews, /smilive, /endlive, /smiu
*/
#if !defined SMI_SYSTEM_INCLUDED
#define SMI_SYSTEM_INCLUDED

#define SMI_AD_PRICE 5000
#define SMI_AD_DELAY 120

// GUI-пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ GUI (id пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ ipacket пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅ case GUISmiEditor).
// пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ (пїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ), пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ #include.
#if !defined GUISmiEditor
    #define GUISmiEditor 24
#endif

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

// Достаёт из очереди /ad ближайшее необработанное объявление
// и открывает сотруднику СМИ диалог редактирования/публикации (текст объявления - сверху).
// Возвращает true, если объявление найдено и диалог показан.
stock bool:Smi_TryOpenNextAdvert(playerid)
{
    if(!g_advert_created) return false;

    for(new idx; idx < g_advert_created; idx ++)
    {
        if(GetAdvertData(idx, A_EDIT) || GetAdvertData(idx, A_CREATOR) == INVALID_PLAYER_ID) continue;

        new fmt_text[400];
        format
        (
            fmt_text, sizeof fmt_text,
            "{FFCD00}Текст объявления:\n{FFFFFF}%s\n\n"\
            "{AAAAAA}Отправитель: %s\n\n"\
            "{FFFFFF}Для редактирования объявления введите новый текст и нажмите 'Отправить'.\n"\
            "Если редактирование не нужно, оставьте поле пустым - объявление уйдёт в эфир как есть.",
            GetAdvertData(idx, A_TEXT), GetPlayerNameEx(GetAdvertData(idx, A_CREATOR))
        );

        Dialog(playerid, DIALOG_ADVERT_EDIT, DIALOG_STYLE_INPUT, "{00CC00}Публикация объявления (СМИ)", fmt_text, "Отправить", "Отклонить");

        SetAdvertData(idx, A_EDIT, true);
        SetPVarInt(playerid, "advert_id", idx);

        return true;
    }

    return false;
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

    if(!Smi_IsStaff(playerid))
    {
        SendClientMessage(playerid, 0xFF6666FF, "Эта команда доступна только сотрудникам СМИ.");
        return 1;
    }

    // Сначала отдаём на модерацию объявления, поданные игроками через /ad.
    if(Smi_TryOpenNextAdvert(playerid)) return 1;

    // Если очередь объявлений пуста - открываем обычную панель СМИ.
    return GuiSmi_OpenEditor(playerid);
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

/*
    GUI-редактор СМИ (id GUISmiEditor, см. #define в основном файле мода).
    Открывается командой /smi для сотрудников СМИ и админов (CMD:smi выше).
    Клиент присылает JSON с полем "action":
        0 - подать объявление ("text")           -> /smiad
        1 - опубликовать новость СМИ ("text")     -> /medianews
        2 - начать прямой эфир ("id" - собеседник) -> /smilive
        3 - завершить прямой эфир                  -> /endlive
        4 - (админ 5+) выставить уровень СМИ ("id", "level") -> /setsmi
    Логика полностью переиспользует уже существующие команды через callcmd::,
    чтобы не дублировать проверки/лимиты.
*/
stock GuiSmi_OpenEditor(playerid)
{
    new Node:json = JSON_Object();

    new now = gettime();
    new ad_wait = (SmiAdTime[playerid] > now) ? (SmiAdTime[playerid] - now) : 0;

    JSON_SetInt(json, "level", SmiLevel[playerid]);
    JSON_SetInt(json, "is_admin", (GetPlayerData(playerid, P_ADMIN) >= 5) ? 1 : 0);
    JSON_SetInt(json, "ad_price", SMI_AD_PRICE);
    JSON_SetInt(json, "ad_delay", SMI_AD_DELAY);
    JSON_SetInt(json, "ad_wait", ad_wait);

    new bool:live_active = (SmiLiveMate[playerid] != -1);
    JSON_SetInt(json, "live_active", live_active ? 1 : 0);

    new mate_name[MAX_PLAYER_NAME + 8];
    mate_name[0] = EOS;
    if(live_active) format(mate_name, sizeof(mate_name), "%s", GetPlayerNameEx(SmiLiveMate[playerid]));
    JSON_SetString(json, "live_mate", mate_name);

    ShowPlayerGUI(playerid, GUISmiEditor, json);
    JSON_Cleanup(json);
    return 1;
}

stock GuiSmi_HandlePacket(playerid, Node:json)
{
    if(!Smi_IsStaff(playerid))
    {
        SendClientMessage(playerid, 0xFF6666FF, "Вы не сотрудник СМИ.");
        return 0;
    }

    new action = -1;
    JSON_GetInt(json, "action", action);

    switch(action)
    {
        case 0: // /smiad
        {
            new text[128];
            text[0] = EOS;
            JSON_GetString(json, "text", text, sizeof(text));
            callcmd::smiad(playerid, text);
        }
        case 1: // /medianews
        {
            new text[128];
            text[0] = EOS;
            JSON_GetString(json, "text", text, sizeof(text));
            callcmd::medianews(playerid, text);
        }
        case 2: // /smilive [id]
        {
            new targetid = -1, params[16];
            JSON_GetInt(json, "id", targetid);
            format(params, sizeof(params), "%d", targetid);
            callcmd::smilive(playerid, params);
        }
        case 3: // /endlive
        {
            callcmd::endlive(playerid, "");
        }
        case 4: // /setsmi [id] [level] - только админ 5+, проверка внутри самой команды
        {
            new targetid = -1, level = 0, params[32];
            JSON_GetInt(json, "id", targetid);
            JSON_GetInt(json, "level", level);
            format(params, sizeof(params), "%d %d", targetid, level);
            callcmd::setsmi(playerid, params);
        }
        default:
        {
            printf("[SMI GUI] Неизвестное action=%d от игрока %d", action, playerid);
        }
    }

    GuiSmi_OpenEditor(playerid); // обновляем состояние гуи после действия
    return 1;
}

#endif
