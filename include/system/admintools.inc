#define AT_DIALOG_MM_MAIN         (6100)
#define AT_DIALOG_MM_SETTINGS     (6101)
#define AT_DIALOG_MM_PASS_NEW     (6102)
#define AT_DIALOG_STATS           (6103)

#define AT_DIALOG_AFTER_REPORT   (6104)

#define AT_REPORT_QUEUE_MAX       (128)
#define AT_MAX_TEMPLATES          (256)
#define AT_LOG_COLOR              (0xB47A45FF)

new ReportQueuePlayer[AT_REPORT_QUEUE_MAX];
new ReportQueueText[AT_REPORT_QUEUE_MAX][144];
new ReportQHead = 0;
new ReportQTail = 0;
new ReportQCount = 0;

static AT_ReportStatusTimer;

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
    AT_StartReportStatusTimer();
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

    mysql_tquery(mysql, "SELECT id, category, title, description, time_value FROM admin_templates ORDER BY id ASC", "OnAdminTemplatesLoaded", "");
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
        AT_Templates[idx][atId] = cache_get_field_content_int(i, "id");
        AT_Templates[idx][atCategory] = cache_get_field_content_int(i, "category");
        AT_Templates[idx][atTime] = cache_get_field_content_int(i, "time_value");
        cache_get_field_content(i, "title", AT_Templates[idx][atTitle], mysql, 64);
        cache_get_field_content(i, "description", AT_Templates[idx][atDesc], mysql, 256);
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
            case 0: AT_ShowStatsDialog(playerid, playerid);
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

        if(!IsNumeric(inputtext) || strlen(inputtext) != 4 || strval(inputtext) < 1000 || strval(inputtext) > 9999)
        {
            ShowPlayerDialog(playerid, AT_DIALOG_MM_PASS_NEW, DIALOG_STYLE_INPUT,
                "{E0584B}BAZE RUSSIA {FFFFFF}| Смена пароля админ-панели",
                "Некорректный пароль. Введите ровно четыре цифры от 1000 до 9999:",
                "Продолжить", "Выход");
            return true;
        }

        SetPlayerData(playerid, P_APASS, strval(inputtext));
        UpdatePlayerDatabaseInt(playerid, "AdminPass", GetPlayerData(playerid, P_APASS));

        SendClientMessage(playerid, COLOR_WHITE, "{E0584B}BAZE RUSSIA {FFFFFF}| Пароль админ-панели успешно изменен.");
        return true;
    }

     if(dialogid == AT_DIALOG_AFTER_REPORT)
    {
        new targetid = GetPVarInt(playerid, "AfterReportTarget");
        new admin_name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, admin_name, sizeof(admin_name));

        if(!response)
        {
            if(IsPlayerConnected(targetid))
            {
                new target_name[MAX_PLAYER_NAME];
                GetPlayerName(targetid, target_name, sizeof(target_name));
                new msg[128];
                format(msg, sizeof(msg), "{CCCCCC}[A] Администратор %s[%d] пропустил репорт игрока %s[%d]",
                    admin_name, playerid, target_name, targetid);
                SendMessageToAdmins(msg, -1);
            }
            else
            {
                new msg[128];
                format(msg, sizeof(msg), "{CCCCCC}[A] Администратор %s[%d] пропустил репорт игрока который вышел",
                    admin_name, playerid);
                SendMessageToAdmins(msg, -1);
            }
            DeletePVar(playerid, "AfterReportTarget");
            return true;
        }


        if(!IsPlayerConnected(targetid))
        {
            SendClientMessage(playerid, COLOR_RED, "Игрок больше не в сети.");
            DeletePVar(playerid, "AfterReportTarget");
            return true;
        }


        switch(listitem)
        {
            case 0:
            {
                new cmd[32];
                format(cmd, sizeof(cmd), "%d", targetid);
                callcmd::goto(playerid, cmd);
            }
            case 1:
            {
                new cmd[32];
                format(cmd, sizeof(cmd), "%d", targetid);
                callcmd::sp(playerid, cmd);
            }
            case 2:
            {
                callcmd::ans(playerid, "");
            }
        }
        DeletePVar(playerid, "AfterReportTarget");
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
    money = GetPlayerData(targetid, P_MONEY);
    level = GetPlayerData(targetid, P_LEVEL);
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
    new required_level = 0;
    switch(category)
    {
        case 3: required_level = 3;
        case 4: required_level = 2;
        case 5: required_level = 2;
        case 6: required_level = 3;
        case 7: required_level = 1;
        case 8: required_level = 4;
        default: required_level = 5;
    }
    if(GetPlayerAdminEx(playerid) < required_level)
    {
        ShowNotificationLaird(playerid, 3, 5, 0, 1, "У вас недостаточно прав для выдачи данного наказания!", "");
        return 0;
    }

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
        ShowNotificationLaird(playerid, 0, 4, 0, 0, "Шаблоны отсутствуют или не загружены", "");
    }
    return 1;
}

stock AT_ShowStatsDialog(playerid, targetid)
{
    if(!IsPlayerConnected(targetid)) return 0;

    new stats[1000];
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
        GetPlayerData(targetid, P_NAME),
        GetPlayerData(targetid, P_LEVEL),
        GetPlayerPing(targetid),
        GetPlayerData(targetid, P_MONEY),
        GetPlayerData(targetid, P_DONATE_MONEY),
        GetPlayerData(targetid, P_MUTE),
        GetPlayerData(targetid, P_JAIL),
        GetPlayerData(targetid, P_WARN),
        GetPlayerAdminEx(targetid)
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
    format(log, sizeof(log), "{704214}[A] Администратор %s[%d] ответил игроку %s[%d]:{FFAE42} %s", admin_name, playerid, target_name, targetid, msg);
    SendMessageToAdmins(log, -1);

    new Node:close_json = JSON_Object();
    JSON_SetInt(close_json, "c", 1);
    OnPacketIncoming(playerid, 66, close_json);
    JSON_Cleanup(close_json);

    DeletePVar(playerid, "ANS_TARGET");
    DeletePVar(playerid, "ANS_TEXT");


    AT_ShowAfterReportMenu(playerid, targetid);
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
    SendMessageToAdmins(out_msg, -1);

    new Node:close_json = JSON_Object();
    JSON_SetInt(close_json, "c", 1);
    OnPacketIncoming(playerid, 66, close_json);
    JSON_Cleanup(close_json);

    DeletePVar(playerid, "ANS_TARGET");
    DeletePVar(playerid, "ANS_TEXT");


    AT_ShowAfterReportMenu(playerid, targetid);
    return 1;
}

stock AT_ApplyPunishTemplate(playerid, targetid, templateId)
{
    if(!IsPlayerConnected(targetid)) return 0;

    new params[160];

    switch(templateId)
    {
        case 1: format(params, sizeof(params), "%d Афк без искейпа", targetid), callcmd::kick(playerid, params);
        case 2: format(params, sizeof(params), "%d Помеха", targetid), callcmd::kick(playerid, params);
        case 3: format(params, sizeof(params), "%d Баг", targetid), callcmd::kick(playerid, params);

        case 4: format(params, sizeof(params), "%d 30 Оскорбление игроков", targetid), callcmd::mute(playerid, params);
        case 5: format(params, sizeof(params), "%d 90 Упоминание родни", targetid), callcmd::mute(playerid, params);
        case 6: format(params, sizeof(params), "%d 90 Неуважение к администрации", targetid), callcmd::mute(playerid, params);
        case 7: format(params, sizeof(params), "%d 30 Капс", targetid), callcmd::mute(playerid, params);

        case 8: format(params, sizeof(params), "%d 60 Убийство игрока без причины", targetid), callcmd::jail(playerid, params);
        case 9: format(params, sizeof(params), "%d 30 Дб убийство машиной", targetid), callcmd::jail(playerid, params);
        case 10: format(params, sizeof(params), "%d 60 Тим килл", targetid), callcmd::jail(playerid, params);
        case 11: format(params, sizeof(params), "%d 30 Провокация ГОСС", targetid), callcmd::jail(playerid, params);

        case 12: format(params, sizeof(params), "%d Нон РП КОП", targetid), callcmd::warn(playerid, params);
        case 13: format(params, sizeof(params), "%d Нон РП ВЧ", targetid), callcmd::warn(playerid, params);
        case 14: format(params, sizeof(params), "%d ОРП", targetid), callcmd::warn(playerid, params);
        case 15: format(params, sizeof(params), "%d Снятие лидера", targetid), callcmd::warn(playerid, params);

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

        case 18: format(params, sizeof(params), "%d 7 Масовое убийство", targetid), callcmd::ban(playerid, params);
        case 19: format(params, sizeof(params), "%d 30 ППВ", targetid), callcmd::ban(playerid, params);
        case 20: format(params, sizeof(params), "%d 15 Оскорбление родных", targetid), callcmd::ban(playerid, params);
        case 21: format(params, sizeof(params), "%d 365 Читы", targetid), callcmd::ban(playerid, params);

        default: return 0;
    }
    return 1;
}








CMD:atoolsshram(playerid, params[])
{
    return AT_ShowMainMenu(playerid);
}





CMD:stats(playerid, params[])
{
    new targetid;
    if(GetPlayerAdminEx(playerid) < 1)
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
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /qreport [текст жалобы]");

    if(!AT_EnqueueReport(playerid, params))
        return SendClientMessage(playerid, COLOR_RED, "Очередь жалоб переполнена. Попробуйте позже.");

    SetPVarInt(playerid, "REPORT_NEXT_TIME", now + 60);

    SendClientMessage(playerid, -1, "{FFFF00}| {FFFFFF}Вы{FFFF00} отправили жалобу{FFFFFF}. Ваша жалоба в {FFFF00}очереди{FFFFFF}, ожидайте ответа.");

    new msg[220];
    format(msg, sizeof(msg), "{704214}[A] Игрок %s[%d] подал жалобу:{FFAE42} %s", GetPlayerData(playerid, P_NAME), playerid, params);
    SendMessageToAdmins(msg, -1);
    return 1;
}


alias:ans("reps", "pm")
CMD:ans(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) return 1;

    new targetid, repText[144];
    if(!AT_DequeueReport(targetid, repText, sizeof(repText)))
        return SendClientMessage(playerid, COLOR_GREY, "Очередь жалоб пуста.");

    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, COLOR_GREY, "Игрок уже вышел, берем следующую жалобу.");

    ShowReportsGUI(playerid, targetid, repText);
    return 1;
}

CMD:warn(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 2) return ShowNotificationLaird(playerid, 2, 3, 0, 0, "У вас нет доступа к этой команде.", "");

    new targetid, reason[128];
    if(sscanf(params, "us[128]", targetid, reason)) return SendClientMessage(playerid, COLOR_WHITE, "Использование: /warn [id] [причина]");
    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "Игрок не в сети.");

    AddPlayerData(targetid, P_WARN, +, 1);
    UpdatePlayerDatabaseInt(targetid, "warn", GetPlayerData(targetid, P_WARN));

    new admin_name[MAX_PLAYER_NAME], target_name[MAX_PLAYER_NAME], msg[192];
    GetPlayerName(playerid, admin_name, sizeof(admin_name));
    GetPlayerName(targetid, target_name, sizeof(target_name));

    format(msg, sizeof(msg), "{FFCC00}[Предупреждение] Администратор %s выдал вам предупреждение [%d/3]. Причина: %s", admin_name, GetPlayerData(targetid, P_WARN), reason);
    SendClientMessage(targetid, -1, msg);
    ShowNotificationLaird(targetid, 3, 6, 0, 0, "Вам выдано предупреждение администрацией.", "Ок");

    format(msg, sizeof(msg), "[A] %s выдал предупреждение игроку %s[%d] (всего: %d/3). Причина: %s", admin_name, target_name, targetid, GetPlayerData(targetid, P_WARN), reason);
    SendMessageToAdmins(msg, AT_LOG_COLOR);

    if(GetPlayerData(targetid, P_WARN) >= 3)
    {
        SetPlayerData(targetid, P_WARN, 0);
        UpdatePlayerDatabaseInt(targetid, "warn", 0);
        format(msg, sizeof(msg), "%d 3 Накопилось 3 предупреждения", targetid);
        callcmd::jail(playerid, msg);
    }
    return 1;
}

CMD:showtoolsshram(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) return 1;

    new screenType;
    if(sscanf(params, "d", screenType))
        return SendClientMessage(playerid, 0xFFFFFFAA, "Используйте: /showtools [1=spectate,2=reports,3=control]");

    switch(screenType)
    {
        case 1: ShowSpectateGUI(playerid, playerid);
        case 2: ShowReportsGUI(playerid, playerid, "Тест");
        case 3: ShowControlPanelGUI(playerid);
        default: ShowNotificationLaird(playerid, 0, 3, 0, 0, "Неверный тип", "");
    }
    return 1;
}

CMD:sp(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1) return 1;
    if(!GetPlayerData(playerid, P_ADMIN_LOGGED)) return callcmd::alogin(playerid, "");

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
    format(str, sizeof(str), "[A] %s[%d] начал слежку за %s[%d]", GetPlayerData(playerid, P_NAME), playerid, GetPlayerData(targetid, P_NAME), targetid);
    SendMessageToAdmins(str, COLOR_GREY);
    return 1;
}
alias:sp("re")

CMD:spoff(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1 || !GetPVarInt(playerid, "IsSpectating")) return 1;

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



stock AT_ShowAfterReportMenu(playerid, targetid)
{
    new menu[512];
    format(menu, sizeof(menu),
        "{E0584B}1{FFFFFF} Телепортироватся к игроку\n\
        {E0584B}2{FFFFFF} Войти в слежку за игроком\n\
        {E0584B}3{FFFFFF} Перейти на новый репорт"
    );
    ShowPlayerDialog(playerid, AT_DIALOG_AFTER_REPORT, DIALOG_STYLE_LIST,
        "{DD5757}BAZE RUSSIA | {808080}Выбор действий репорта",
        menu, "Выбрать", "Закрыть"
    );
    SetPVarInt(playerid, "AfterReportTarget", targetid);
    return 1;
}

stock AT_StartReportStatusTimer()
{
    AT_StopReportStatusTimer();
    AT_ReportStatusTimer = SetTimer("AT_SendReportQueueStatus", 120000, 1);
    return 1;
}

stock AT_StopReportStatusTimer()
{
    if(AT_ReportStatusTimer) KillTimer(AT_ReportStatusTimer);
    AT_ReportStatusTimer = 0;
    return 1;
}

forward AT_SendReportQueueStatus();
public AT_SendReportQueueStatus()
{
    new msg[128];
    format(msg, sizeof(msg), "{CCCCCC}[Rep-log] На данный момент уровень репорта составляет: {DD5757}%d", ReportQCount);
    SendMessageToAdmins(msg, -1);
    return 1;
}