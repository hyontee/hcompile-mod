#define AT_DIALOG_MM_MAIN         (6100)
#define AT_DIALOG_MM_SETTINGS     (6101)
#define AT_DIALOG_MM_PASS_NEW     (6102)
#define AT_DIALOG_STATS           (6103)

#define AT_REPORT_QUEUE_MAX       (128)
#define AT_MAX_TEMPLATES          (256)
#define AT_LOG_COLOR              (0xB47A45FF)

new ReportQueuePlayer[AT_REPORT_QUEUE_MAX];
new ReportQueueText[AT_REPORT_QUEUE_MAX][144];
new ReportQHead = 0;
new ReportQTail = 0;
new ReportQCount = 0;

enum E_AT_TEMPLATE
{
    atUsed,
    atId,
    atCategory,
    atTime,
    atTitle[64],
    atDesc[256]
}
new AT_Templates[AT_MAX_TEMPLATES][E_AT_TEMPLATE];

stock AdminToolsInit()
{
    AT_LoadTemplates();
    return 1;
}

stock AT_LoadTemplates()
{
    for(new i = 0; i < AT_MAX_TEMPLATES; i++)
    {
        AT_Templates[i][atUsed] = 0;
        AT_Templates[i][atId] = 0;
        AT_Templates[i][atCategory] = 0;
        AT_Templates[i][atTime] = 0;
        format(AT_Templates[i][atTitle], 64, "");
        format(AT_Templates[i][atDesc], 256, "");
    }

    mysql_tquery(db_handle, "SELECT id, category, title, description, time_value FROM admin_templates ORDER BY id ASC", "OnAdminTemplatesLoaded", "");
    return 1;
}

forward OnAdminTemplatesLoaded();
public OnAdminTemplatesLoaded()
{
    new rows = cache_num_rows();
    new idx = 0;

    for(new i = 0; i < rows && idx < AT_MAX_TEMPLATES; i++)
    {
        AT_Templates[idx][atUsed] = 1;
        AT_Templates[idx][atId] = cache_get_field_content_int(i, "id", db_handle);
        AT_Templates[idx][atCategory] = cache_get_field_content_int(i, "category", db_handle);
        AT_Templates[idx][atTime] = cache_get_field_content_int(i, "time_value", db_handle);
        cache_get_field_content(i, "title", AT_Templates[idx][atTitle], db_handle, 64);
        cache_get_field_content(i, "description", AT_Templates[idx][atDesc], db_handle, 256);
        idx++;
    }
    return 1;
}

stock AT_FindTemplateById(templateId)
{
    for(new i = 0; i < AT_MAX_TEMPLATES; i++)
    {
        if(AT_Templates[i][atUsed] && AT_Templates[i][atId] == templateId) return i;
    }
    return -1;
}

stock AT_EnqueueReport(playerid, const text[])
{
    if(ReportQCount >= AT_REPORT_QUEUE_MAX) return 0;

    ReportQueuePlayer[ReportQTail] = playerid;
    format(ReportQueueText[ReportQTail], 144, "%s", text);

    ReportQTail = (ReportQTail + 1) % AT_REPORT_QUEUE_MAX;
    ReportQCount++;
    return 1;
}

stock AT_DequeueReport(&targetid, text[], len = sizeof(text))
{
    if(ReportQCount <= 0) return 0;

    targetid = ReportQueuePlayer[ReportQHead];
    format(text, len, "%s", ReportQueueText[ReportQHead]);

    ReportQHead = (ReportQHead + 1) % AT_REPORT_QUEUE_MAX;
    ReportQCount--;
    return 1;
}

stock AT_ShowMainMenu(playerid)
{
    new menu[256];
    format(menu, sizeof(menu), "Пункт\tОписание\nСтатистика\tПросмотр статистики\nНастройки\tНастройки аккаунта");
    ShowPlayerDialog(playerid, AT_DIALOG_MM_MAIN, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BAZE RUSSIA {FFFFFF}| Меню", menu, "Выбрать", "Закрыть");
    return 1;
}

stock bool:HandleAdminToolsDialog(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == AT_DIALOG_MM_MAIN)
    {
        if(!response) return true;
        switch(listitem)
        {
            case 0: AT_ShowStatsDialog(playerid, playerid); // Теперь точно откроется
            case 1:
            {
                new str[256];
                format(str, sizeof(str), "Пункт\tОписание\nСменить пароль\tИзменение пароля аккаунта\n");
                ShowPlayerDialog(playerid, AT_DIALOG_MM_SETTINGS, DIALOG_STYLE_TABLIST_HEADERS, "{E0584B}BAZE RUSSIA {FFFFFF}| Настройки", str, "Выбрать", "Назад");
            }
        }
        return true;
    }

    if(dialogid == AT_DIALOG_MM_SETTINGS)
    {
        if(!response) return AT_ShowMainMenu(playerid);
        if(listitem == 0)
        {
            ShowPlayerDialog(playerid, AT_DIALOG_MM_PASS_NEW, DIALOG_STYLE_INPUT,
                "{E0584B}BAZE RUSSIA {FFFFFF}| Смена пароля",
                "Введите новый пароль (минимум 4 символа):",
                "Сохранить", "Назад");
        }
        return true;
    }

    if(dialogid == AT_DIALOG_MM_PASS_NEW)
    {
        if(!response)
        {
            AT_ShowMainMenu(playerid);
            return true;
        }

        if(strlen(inputtext) < 4)
        {
            ShowPlayerDialog(playerid, AT_DIALOG_MM_PASS_NEW, DIALOG_STYLE_INPUT,
                "{E0584B}BAZE RUSSIA {FFFFFF}| Смена пароля",
                "Пароль слишком короткий. Минимум 4 символа.",
                "Сохранить", "Назад");
            return true;
        }

        format(Player[playerid][pPassword], 65, "%s", inputtext);

        new query[192];
        mysql_format(db_handle, query, sizeof(query), "UPDATE `players` SET `password` = '%e' WHERE `id` = %d", Player[playerid][pPassword], Player[playerid][pID]);
        mysql_tquery(db_handle, query, "", "");

        SendClientMessage(playerid, COLOR_WHITE, "{E0584B}BAZE RUSSIA {FFFFFF}| Пароль успешно изменен.");
        return true;
    }

    return false;
}

stock ShowSpectateGUI(playerid, targetid)
{
    if(!IsPlayerConnected(targetid)) return 0;

    new target_name[MAX_PLAYER_NAME];
    new Float:hp, Float:armor, Float:speed, ping, money, vehicleid, level;

    GetPlayerName(targetid, target_name, sizeof(target_name));
    GetPlayerHealth(targetid, hp);
    GetPlayerArmour(targetid, armor);

    ping = GetPlayerPing(targetid);
    money = Player[targetid][pMoney];
    level = Player[targetid][pLevel];
    vehicleid = GetPlayerVehicleID(targetid);

    new Float:vx, Float:vy, Float:vz;
    GetPlayerVelocity(targetid, vx, vy, vz);
    speed = floatsqroot(vx*vx + vy*vy + vz*vz) * 181.3;

    new Node:info1 = JSON_Object("p", JSON_Int(5), "n", JSON_String("Пинг"), "v", JSON_Int(ping));
    new Node:info2 = JSON_Object("p", JSON_Int(4), "n", JSON_String("Скорость"), "v", JSON_Int(floatround(speed)));
    new Node:info3 = JSON_Object("p", JSON_Int(2), "n", JSON_String("Здоровье"), "v", JSON_Int(floatround(hp)));
    new Node:info4 = JSON_Object("p", JSON_Int(3), "n", JSON_String("Броня"), "v", JSON_Int(floatround(armor)));
    new Node:info5 = JSON_Object("p", JSON_Int(6), "n", JSON_String("Деньги"), "v", JSON_Int(money));
    new Node:info6 = JSON_Object("p", JSON_Int(1), "n", JSON_String("Уровень"), "v", JSON_Int(level));
    new Node:info7 = JSON_Object("p", JSON_Int(7), "n", JSON_String("Транспорт"), "v", JSON_Int(vehicleid));

    new Node:pi_array = JSON_Array(info1, info2, info3, info4, info5, info6, info7);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "id", targetid);
    JSON_SetString(json, "pn", target_name);
    JSON_SetArray(json, "pi", pi_array);

    OnPacketIncoming(playerid, 66, json);

    JSON_Cleanup(json);
    return 1;
}

stock ShowReportsGUI(playerid, targetid = INVALID_PLAYER_ID, const repText[] = "")
{
    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
    {
        targetid = GetPVarInt(playerid, "SpectatingID");
        if(!IsPlayerConnected(targetid)) targetid = playerid;
    }

    new pname[MAX_PLAYER_NAME];
    GetPlayerName(targetid, pname, sizeof(pname));

    new text[144];
    if(isnull(repText)) format(text, sizeof(text), "Текст жалобы отсутствует");
    else format(text, sizeof(text), "%s", repText);

    SetPVarInt(playerid, "ANS_TARGET", targetid);
    SetPVarString(playerid, "ANS_TEXT", text);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 3);
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "id", targetid);
    JSON_SetString(json, "pn", pname);
    JSON_SetString(json, "tr", text);
    OnPacketIncoming(playerid, 66, json);
    JSON_Cleanup(json);
    return 1;
}

stock ShowControlPanelGUI(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 6);

    new Node:btn0 = JSON_Object("bi", JSON_Int(0), "bn", JSON_String("Мои шаблоны"), "be", JSON_String("Просмотр шаблонов"));
    new Node:btn1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("Создать шаблон"), "be", JSON_String("Новый шаблон"));
    new Node:btn7 = JSON_Object("bi", JSON_Int(7), "bn", JSON_String("Категории"), "be", JSON_String("Наказания"));
    new Node:arr = JSON_Array(btn0, btn1, btn7);
    JSON_SetArray(json, "bt", arr);

    OnPacketIncoming(playerid, 66, json);
    JSON_Cleanup(json);
    return 1;
}

stock AT_SendPunishTemplates(playerid, category)
{
    new Node:json_response = JSON_Object();
    JSON_SetInt(json_response, "t", 2);

    switch(category)
    {
        case 3:
        {
            JSON_SetString(json_response, "bn", "Кик");
            JSON_SetInt(json_response, "tf", 0);
            new Node:t1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("Afk no esc"), "be", JSON_String("Afk no esc"));
            new Node:t2 = JSON_Object("bi", JSON_Int(2), "bn", JSON_String("Помеха"), "be", JSON_String("Помеха"));
            new Node:t3 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("Баг"), "be", JSON_String("Баг"));
            JSON_SetArray(json_response, "bt", JSON_Array(t1, t2, t3));
        }
        case 4:
        {
            JSON_SetString(json_response, "bn", "Мут");
            JSON_SetInt(json_response, "tf", 1);
            new Node:t1 = JSON_Object("bi", JSON_Int(4), "bn", JSON_String("Оскорбление"), "be", JSON_String("Оскорбление игроков"), "br", JSON_Int(15));
            new Node:t2 = JSON_Object("bi", JSON_Int(5), "bn", JSON_String("Упоминание родни"), "be", JSON_String("Упоминание родни"), "br", JSON_Int(30));
            new Node:t3 = JSON_Object("bi", JSON_Int(6), "bn", JSON_String("Неуважение к администрации"), "be", JSON_String("Неуважение к администрации"), "br", JSON_Int(60));
            new Node:t4 = JSON_Object("bi", JSON_Int(7), "bn", JSON_String("CAPS"), "be", JSON_String("Капс в чате"), "br", JSON_Int(10));
            JSON_SetArray(json_response, "bt", JSON_Array(t1, t2, t3, t4));
        }
        case 5:
        {
            JSON_SetString(json_response, "bn", "Тюрьма");
            JSON_SetInt(json_response, "tf", 1);
            new Node:t1 = JSON_Object("bi", JSON_Int(8), "bn", JSON_String("DM"), "be", JSON_String("DM без причины"), "br", JSON_Int(10));
            new Node:t2 = JSON_Object("bi", JSON_Int(9), "bn", JSON_String("DB"), "be", JSON_String("DriveBy"), "br", JSON_Int(15));
            new Node:t3 = JSON_Object("bi", JSON_Int(10), "bn", JSON_String("TK"), "be", JSON_String("TeamKill"), "br", JSON_Int(20));
            new Node:t4 = JSON_Object("bi", JSON_Int(11), "bn", JSON_String("Провокация ГОС"), "be", JSON_String("Провокация гос. организаций"), "br", JSON_Int(25));
            JSON_SetArray(json_response, "bt", JSON_Array(t1, t2, t3, t4));
        }
        case 6:
        {
            JSON_SetString(json_response, "bn", "Предупреждение");
            JSON_SetInt(json_response, "tf", 0);
            new Node:t1 = JSON_Object("bi", JSON_Int(12), "bn", JSON_String("НонРП COP"), "be", JSON_String("НонРП коп"));
            new Node:t2 = JSON_Object("bi", JSON_Int(13), "bn", JSON_String("НонРП В/Ч"), "be", JSON_String("НонРП в/ч"));
            new Node:t3 = JSON_Object("bi", JSON_Int(14), "bn", JSON_String("ОРП"), "be", JSON_String("ОРП"));
            new Node:t4 = JSON_Object("bi", JSON_Int(15), "bn", JSON_String("Снят ЛД"), "be", JSON_String("Снятие ЛД"));
            JSON_SetArray(json_response, "bt", JSON_Array(t1, t2, t3, t4));
        }
        case 7:
        {
            JSON_SetString(json_response, "bn", "Шлепок");
            JSON_SetInt(json_response, "tf", 0);
            new Node:t1 = JSON_Object("bi", JSON_Int(16), "bn", JSON_String("Подбросить вверх"), "be", JSON_String("Подбросить вверх"));
            new Node:t2 = JSON_Object("bi", JSON_Int(17), "bn", JSON_String("Подбросить вниз"), "be", JSON_String("Подбросить вниз"));
            JSON_SetArray(json_response, "bt", JSON_Array(t1, t2));
        }
        case 8:
        {
            JSON_SetString(json_response, "bn", "Бан");
            JSON_SetInt(json_response, "tf", 1);
            new Node:t1 = JSON_Object("bi", JSON_Int(18), "bn", JSON_String("Mass DM"), "be", JSON_String("Массовый DM"), "br", JSON_Int(7));
            new Node:t2 = JSON_Object("bi", JSON_Int(19), "bn", JSON_String("П/П/В"), "be", JSON_String("П/П/В"), "br", JSON_Int(30));
            new Node:t3 = JSON_Object("bi", JSON_Int(20), "bn", JSON_String("Оск. Родни"), "be", JSON_String("Оскорбление родни"), "br", JSON_Int(14));
            new Node:t4 = JSON_Object("bi", JSON_Int(21), "bn", JSON_String("Читы"), "be", JSON_String("Использование читов"), "br", JSON_Int(365));
            JSON_SetArray(json_response, "bt", JSON_Array(t1, t2, t3, t4));
        }
    }

    OnPacketIncoming(playerid, 66, json_response);
    JSON_Cleanup(json_response);
    return 1;
}

stock AT_SendCategories(playerid)
{
    new Node:json_response = JSON_Object();
    JSON_SetInt(json_response, "t", 7);

    new Node:cat1 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("Кик"), "be", JSON_String("Категория"));
    new Node:cat2 = JSON_Object("bi", JSON_Int(4), "bn", JSON_String("Мут"), "be", JSON_String("Категория"));
    new Node:cat3 = JSON_Object("bi", JSON_Int(5), "bn", JSON_String("Тюрьма"), "be", JSON_String("Категория"));
    new Node:cat4 = JSON_Object("bi", JSON_Int(6), "bn", JSON_String("Предупреждение"), "be", JSON_String("Категория"));
    new Node:cat5 = JSON_Object("bi", JSON_Int(7), "bn", JSON_String("Шлепок"), "be", JSON_String("Категория"));
    new Node:cat6 = JSON_Object("bi", JSON_Int(8), "bn", JSON_String("Бан"), "be", JSON_String("Категория"));
    JSON_SetArray(json_response, "bt", JSON_Array(cat1, cat2, cat3, cat4, cat5, cat6));

    OnPacketIncoming(playerid, 66, json_response);
    JSON_Cleanup(json_response);
    return 1;
}

stock AT_SendMyTemplates(playerid)
{
    new Node:json_response = JSON_Object();
    JSON_SetInt(json_response, "t", 8);
    JSON_SetString(json_response, "bn", "Мои шаблоны");

    new Node:arr = JSON_Array();
    new count = 0;

    for(new i = 0; i < AT_MAX_TEMPLATES; i++)
    {
        if(!AT_Templates[i][atUsed]) continue;

        new Node:item = JSON_Object(
            "bi", JSON_Int(AT_Templates[i][atId]),
            "bn", JSON_String(AT_Templates[i][atTitle]),
            "be", JSON_String(AT_Templates[i][atDesc])
        );

        if(AT_Templates[i][atTime] > 0)
        {
            JSON_SetInt(item, "br", AT_Templates[i][atTime]);
        }

        JSON_ArrayAppend(arr, "", item);
        count++;
    }

    JSON_SetArray(json_response, "bt", arr);
    OnPacketIncoming(playerid, 66, json_response);
    JSON_Cleanup(json_response);

    if(count == 0)
    {
        ShowNotification(playerid, 0, 4, 0, 0, "Шаблоны отсутствуют или не загружены", "");
    }
    return 1;
}

stock AT_ShowStatsDialog(playerid, targetid)
{
    if(!IsPlayerConnected(targetid)) return 0;

    new stats[1000]; // 1400 многовато для такого текста
    format(stats, sizeof(stats),
        "{FFFFFF}Параметр\t{FFFFFF}Значение\n\
        ID игрока:\t{E0584B}%d\n\
        Ник:\t{E0584B}%s\n\
        Уровень:\t{E0584B}%d\n\
        Пинг:\t{E0584B}%d\n\
        Деньги:\t{E0584B}%d\n\
        BlackCoin:\t{E0584B}%d\n\
        Мут:\t{E0584B}%d мин\n\
        Деморган:\t{E0584B}%d мин\n\
        Варны:\t{E0584B}%d\n\
        Админ-уровень:\t{E0584B}%d",
        targetid,
        Player[targetid][pName],
        Player[targetid][pLevel],
        GetPlayerPing(targetid),
        Player[targetid][pMoney],
        Player[targetid][pBC],
        Player[targetid][pMuteTime],
        Player[targetid][pJailTime],
        Player[targetid][pWarns],
        Player[targetid][pAdminLvl]
    );

    ShowPlayerDialog(playerid, AT_DIALOG_STATS, DIALOG_STYLE_TABLIST_HEADERS, 
        "{E0584B}BAZE RUSSIA {FFFFFF}| Статистика", stats, "Закрыть", "");
    return 1;
}

stock AT_SendReportAnswerTemplates(playerid)
{
    new Node:json_response = JSON_Object();
    JSON_SetInt(json_response, "t", 4);

    new Node:t1 = JSON_Object("bi", JSON_Int(1), "bn", JSON_String("Работа по жалобе"), "be", JSON_String("Здравствуйте, работаю по вашей жалобе. // Приятной игры"));
    new Node:t2 = JSON_Object("bi", JSON_Int(2), "bn", JSON_String("Не по теме"), "be", JSON_String("Здравствуйте, Ваша жалоба не по теме. // Приятной игры"));
    new Node:t3 = JSON_Object("bi", JSON_Int(3), "bn", JSON_String("RolePlay путем"), "be", JSON_String("Здравствуйте, решите ситуацию RolePlay путем. // Приятной игры"));
    JSON_SetArray(json_response, "bt", JSON_Array(t1, t2, t3));

    OnPacketIncoming(playerid, 66, json_response);
    JSON_Cleanup(json_response);
    return 1;
}
stock AT_HandleReportTemplateReply(playerid, templateId)
{
    new targetid = GetPVarInt(playerid, "ANS_TARGET");
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Игрок для ответа не найден.");
        return 0;
    }

    new msg[128], out_msg[256], admin_name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));

    switch(templateId)
    {
        case 1: msg = "Здравствуйте, работаю по вашей жалобе. // Приятной игры";
        case 2: msg = "Здравствуйте, Ваша жалоба не по теме. // Приятной игры";
        case 3: msg = "Здравствуйте, решите ситуацию RolePlay путем. // Приятной игры";
        default: return 0;
    }

    format(out_msg, sizeof(out_msg), "{704214}Администратор %s ответил вам: {FFAE42}%s", admin_name, msg);
    SendClientMessage(targetid, -1, out_msg);

    new target_name[MAX_PLAYER_NAME];
    GetPlayerName(targetid, target_name, sizeof(target_name));
    
    new log[256];
    format(log, sizeof(log), "{704214}[A] %s[%d] ответил %s[%d]:{FFAE42} %s", admin_name, playerid, target_name, targetid, msg);
    SendAdminMessage(-1, log);

    new Node:close_json = JSON_Object();
    JSON_SetInt(close_json, "c", 1);
    OnPacketIncoming(playerid, 66, close_json);
    JSON_Cleanup(close_json);

    DeletePVar(playerid, "ANS_TARGET");
    DeletePVar(playerid, "ANS_TEXT");
    return 1;
}

stock AT_HandleReportCustomReply(playerid, const rep[])
{
    new targetid = GetPVarInt(playerid, "ANS_TARGET");
    if(!IsPlayerConnected(targetid)) return 0;

    new a_name[MAX_PLAYER_NAME], t_name[MAX_PLAYER_NAME], out_msg[256];
    GetPlayerName(playerid, a_name, sizeof(a_name));
    GetPlayerName(targetid, t_name, sizeof(t_name));

    format(out_msg, sizeof(out_msg), "{33CCFF}Администратор %s ответил вам: {FFFFFF}%s", a_name, rep);
    SendClientMessage(targetid, -1, out_msg);

    format(out_msg, sizeof(out_msg), "{704214}[A] %s[%d] ответил %s[%d]:{FFAE42} %s", a_name, playerid, t_name, targetid, rep);
    SendAdminMessage(-1, out_msg);

    new Node:close_json = JSON_Object();
    JSON_SetInt(close_json, "c", 1);
    OnPacketIncoming(playerid, 66, close_json);
    JSON_Cleanup(close_json);

    DeletePVar(playerid, "ANS_TARGET");
    DeletePVar(playerid, "ANS_TEXT");
    return 1;
}

stock AT_ApplyPunishTemplate(playerid, targetid, templateId)
{
    if(!IsPlayerConnected(targetid)) return 0;

    new params[160];

    switch(templateId)
    {
        case 1: format(params, sizeof(params), "%d Afk_no_esc", targetid), callcmd::kick(playerid, params);
        case 2: format(params, sizeof(params), "%d Помеха", targetid), callcmd::kick(playerid, params);
        case 3: format(params, sizeof(params), "%d Баг", targetid), callcmd::kick(playerid, params);

        case 4: format(params, sizeof(params), "%d 15 Оскорбление_игроков", targetid), callcmd::mute(playerid, params);
        case 5: format(params, sizeof(params), "%d 30 Упоминание_родни", targetid), callcmd::mute(playerid, params);
        case 6: format(params, sizeof(params), "%d 60 Неуважение_к_администрации", targetid), callcmd::mute(playerid, params);
        case 7: format(params, sizeof(params), "%d 10 CAPS", targetid), callcmd::mute(playerid, params);

        case 8: format(params, sizeof(params), "%d 10 DM_без_причины", targetid), callcmd::jail(playerid, params);
        case 9: format(params, sizeof(params), "%d 15 DB", targetid), callcmd::jail(playerid, params);
        case 10: format(params, sizeof(params), "%d 20 TeamKill", targetid), callcmd::jail(playerid, params);
        case 11: format(params, sizeof(params), "%d 25 Провокация_ГОС", targetid), callcmd::jail(playerid, params);

        case 12: format(params, sizeof(params), "%d НонРП_COP", targetid), callcmd::warn(playerid, params);
        case 13: format(params, sizeof(params), "%d НонРП_ВЧ", targetid), callcmd::warn(playerid, params);
        case 14: format(params, sizeof(params), "%d ОРП", targetid), callcmd::warn(playerid, params);
        case 15: format(params, sizeof(params), "%d Снят_ЛД", targetid), callcmd::warn(playerid, params);

        case 16:
        {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(targetid, x, y, z);
            SetPlayerPos(targetid, x, y, z + 10.0);
        }
        case 17:
        {
            new Float:x, Float:y, Float:z;
            GetPlayerPos(targetid, x, y, z);
            SetPlayerPos(targetid, x, y, z - 5.0);
        }

        case 18: format(params, sizeof(params), "%d 7 Mass_DM", targetid), callcmd::ban(playerid, params);
        case 19: format(params, sizeof(params), "%d 30 ППВ", targetid), callcmd::ban(playerid, params);
        case 20: format(params, sizeof(params), "%d 14 Оскорбление_родни", targetid), callcmd::ban(playerid, params);
        case 21: format(params, sizeof(params), "%d 365 Читы", targetid), callcmd::ban(playerid, params);

        default: return 0;
    }
    return 1;
}








CMD:mm(playerid, params[])
{
    return AT_ShowMainMenu(playerid);
}





CMD:stats(playerid, params[])
{
    new targetid;
    if(Player[playerid][pAdminLvl] < 1 || !Player[playerid][pAdminAuth])
        return SendClientMessage(playerid, COLOR_GREY, "Команда доступна только администраторам.");
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /stats [id игрока]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден");

    return AT_ShowStatsDialog(playerid, targetid);
}



CMD:report(playerid, params[])
{
    new now = gettime();
    new nextTime = GetPVarInt(playerid, "REPORT_NEXT_TIME");
    if(nextTime > now)
    {
        new left = nextTime - now;
        new msg_cd[96];
        format(msg_cd, sizeof(msg_cd), "Следующую жалобу можно подать через %d сек.", left);
        return SendClientMessage(playerid, COLOR_GREY, msg_cd);
    }

    if(isnull(params))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /report [текст жалобы]");

    if(!AT_EnqueueReport(playerid, params))
        return SendClientMessage(playerid, COLOR_RED, "Очередь жалоб переполнена. Попробуйте позже.");

    SetPVarInt(playerid, "REPORT_NEXT_TIME", now + 60);

    SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы{FFFF00} отправили жалобу{FFFFFF}. Ваша жалоба в {FFFF00}очереди{FFFFFF}, ожидайте ответа.");

    new msg[220];
    format(msg, sizeof(msg), "{704214}[A] Игрок %s[%d] подал жалобу:{FFAE42} %s", Player[playerid][pName], playerid, params);
    SendAdminMessage(-1, msg);
    return 1;
}



CMD:ans(playerid, params[])
{
    if(!Player[playerid][pAdminAuth] || Player[playerid][pAdminLvl] < 1) return 1;

    new targetid, repText[144];
    if(!AT_DequeueReport(targetid, repText, sizeof(repText)))
        return SendClientMessage(playerid, COLOR_GREY, "Очередь жалоб пуста.");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_GREY, "Игрок уже вышел, берем следующую жалобу.");

    ShowReportsGUI(playerid, targetid, repText);
    return 1;
}

CMD:showtools(playerid, params[])
{
    if(Player[playerid][pAdminLvl] < 1) return 1;

    new screenType;
    if(sscanf(params, "d", screenType))
        return SendClientMessage(playerid, 0xFFFFFFAA, "Используйте: /showtools [1=spectate,2=reports,3=control]");

    switch(screenType)
    {
        case 1: ShowSpectateGUI(playerid, playerid);
        case 2: ShowReportsGUI(playerid, playerid, "Тест");
        case 3: ShowControlPanelGUI(playerid);
        default: ShowNotification(playerid, 0, 3, 0, 0, "Неверный тип", "");
    }
    return 1;
}

CMD:sp(playerid, params[])
{
    if(Player[playerid][pAdminLvl] < 1) return 1;
    if(!Player[playerid][pAdminAuth]) return ShowAdminLogin(playerid);

    new targetid;
    if(sscanf(params, "u", targetid)) return SendClientMessage(playerid, COLOR_GREY, "Используйте: /sp [ид игрока]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден!");
    if(targetid == playerid) return SendClientMessage(playerid, COLOR_RED, "Вы не можете следить за собой!");

    if(GetPVarInt(targetid, "IsSpectating")) return SendClientMessage(playerid, COLOR_RED, "Этот администратор уже следит за кем-то.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    SetPVarFloat(playerid, "AdminPosX", x);
    SetPVarFloat(playerid, "AdminPosY", y);
    SetPVarFloat(playerid, "AdminPosZ", z);
    SetPVarInt(playerid, "IsSpectating", 1);
    SetPVarInt(playerid, "SpectatingID", targetid);

    TogglePlayerSpectating(playerid, true);
    SetPlayerInterior(playerid, GetPlayerInterior(targetid));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

    if(IsPlayerInAnyVehicle(targetid)) PlayerSpectateVehicle(playerid, GetPlayerVehicleID(targetid));
    else PlayerSpectatePlayer(playerid, targetid);

    ShowSpectateGUI(playerid, targetid);

    new str[128];
    format(str, sizeof(str), "[A] %s[%d] начал слежку за %s[%d]", Player[playerid][pName], playerid, Player[targetid][pName], targetid);
    SendAdminMessage(COLOR_GREY, str);
    return 1;
}
alias:sp("re")

CMD:spoff(playerid, params[])
{
    if(Player[playerid][pAdminLvl] < 1 || !GetPVarInt(playerid, "IsSpectating")) return 1;

    TogglePlayerSpectating(playerid, false);
    SetPlayerPos(playerid, GetPVarFloat(playerid, "AdminPosX"), GetPVarFloat(playerid, "AdminPosY"), GetPVarFloat(playerid, "AdminPosZ"));

    new Node:close_json = JSON_Object();
    JSON_SetInt(close_json, "c", 1);
    OnPacketIncoming(playerid, 66, close_json);
    JSON_Cleanup(close_json);

    DeletePVar(playerid, "IsSpectating");
    DeletePVar(playerid, "SpectatingID");
    return 1;
}
alias:spoff("reoff")


