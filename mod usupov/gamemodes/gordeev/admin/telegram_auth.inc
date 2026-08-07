// telegram_auth.inc
// Система авторизации через Telegram бота

#define TELEGRAM_AUTH_CODE_LENGTH 8
#define TELEGRAM_AUTH_CODE_EXPIRE 300 // 5 минут в секундах

enum E_TELEGRAM_AUTH
{
    TA_CODE[9],
    TA_EXPIRE_TIME,
    TA_PLAYER_ID,
    bool:TA_ACTIVE
}

new g_TelegramAuthCodes[100][E_TELEGRAM_AUTH];
new g_TelegramAuthCodeCount;

// Инициализация
stock TelegramAuth_Init()
{
    g_TelegramAuthCodeCount = 0;
    for(new i = 0; i < sizeof(g_TelegramAuthCodes); i++)
    {
        g_TelegramAuthCodes[i][TA_ACTIVE] = false;
        g_TelegramAuthCodes[i][TA_CODE][0] = EOS;
    }
    print("[TelegramAuth] Система авторизации инициализирована");
    return 1;
}

// Генерация случайного 8-значного кода
stock TelegramAuth_GenerateCode()
{
    new code[9];
    for(new i = 0; i < TELEGRAM_AUTH_CODE_LENGTH; i++)
    {
        code[i] = '0' + random(10);
    }
    code[TELEGRAM_AUTH_CODE_LENGTH] = EOS;
    return code;
}

// Сохранение кода
stock TelegramAuth_SaveCode(playerid, code[])
{
    for(new i = 0; i < sizeof(g_TelegramAuthCodes); i++)
    {
        if(!g_TelegramAuthCodes[i][TA_ACTIVE])
        {
            format(g_TelegramAuthCodes[i][TA_CODE], 9, "%s", code);
            g_TelegramAuthCodes[i][TA_EXPIRE_TIME] = gettime() + TELEGRAM_AUTH_CODE_EXPIRE;
            g_TelegramAuthCodes[i][TA_PLAYER_ID] = playerid;
            g_TelegramAuthCodes[i][TA_ACTIVE] = true;
            g_TelegramAuthCodeCount++;
            return i;
        }
    }
    return -1;
}

// Проверка кода
stock TelegramAuth_CheckCode(playerid, input_code[])
{
    new current_time = gettime();
    
    for(new i = 0; i < sizeof(g_TelegramAuthCodes); i++)
    {
        if(!g_TelegramAuthCodes[i][TA_ACTIVE]) continue;
        if(g_TelegramAuthCodes[i][TA_PLAYER_ID] != playerid) continue;
        if(g_TelegramAuthCodes[i][TA_EXPIRE_TIME] < current_time)
        {
            g_TelegramAuthCodes[i][TA_ACTIVE] = false;
            continue;
        }
        if(strcmp(g_TelegramAuthCodes[i][TA_CODE], input_code) == 0)
        {
            g_TelegramAuthCodes[i][TA_ACTIVE] = false;
            return 1;
        }
    }
    return 0;
}

// Проверка привязан ли аккаунт
stock bool:TelegramAuth_IsLinked(playerid)
{
    new query[128], Cache:result, bool:linked = false;
    mysql_format(mysql, query, sizeof(query),
        "SELECT telegram_verified FROM accounts WHERE id=%d LIMIT 1",
        GetPlayerAccountID(playerid)
    );
    result = mysql_query(mysql, query, true);
    
    if(cache_num_rows())
    {
        linked = bool:cache_get_field_content_int(0, "telegram_verified");
    }
    cache_delete(result);
    return linked;
}

// Получение telegram_id
stock TelegramAuth_GetTelegramId(playerid)
{
    new query[128], Cache:result, telegram_id = 0;
    mysql_format(mysql, query, sizeof(query),
        "SELECT telegram_id FROM accounts WHERE id=%d LIMIT 1",
        GetPlayerAccountID(playerid)
    );
    result = mysql_query(mysql, query, true);
    
    if(cache_num_rows())
    {
        telegram_id = cache_get_field_content_int(0, "telegram_id");
    }
    cache_delete(result);
    return telegram_id;
}

// Обновление кода в БД для бота
stock TelegramAuth_UpdateCode(playerid, code[])
{
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE accounts SET auth_code='%s', auth_code_expire=%d WHERE id=%d LIMIT 1",
        code, gettime() + TELEGRAM_AUTH_CODE_EXPIRE, GetPlayerAccountID(playerid)
    );
    mysql_query(mysql, query, false);
    return !mysql_errno();
}

// Привязка аккаунта
stock TelegramAuth_LinkAccount(playerid, telegram_id)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE accounts SET telegram_id=%d, telegram_verified=1 WHERE id=%d LIMIT 1",
        telegram_id, GetPlayerAccountID(playerid)
    );
    mysql_query(mysql, query, false);
    return !mysql_errno();
}

// Команда /admconnect
CMD:admconnect(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
    {
        SendClientMessage(playerid, 0x999999FF, "У вас нет прав для использования этой команды");
        return 1;
    }
    
    if(TelegramAuth_IsLinked(playerid))
    {
        SendClientMessage(playerid, 0x3399FFFF, "Ваш аккаунт уже привязан к Telegram боту.");
        SendClientMessage(playerid, 0x3399FFFF, "Для авторизации используйте /testauth");
        return 1;
    }
    
    new code[9];
    format(code, sizeof(code), "%s", TelegramAuth_GenerateCode());
    
    new slot = TelegramAuth_SaveCode(playerid, code);
    if(slot == -1)
    {
        SendClientMessage(playerid, 0xFF6600FF, "Ошибка генерации кода. Попробуйте позже.");
        return 1;
    }
    
    // Сохраняем код в БД для бота
    TelegramAuth_UpdateCode(playerid, code);
    
    new msg[256];
    format(msg, sizeof(msg),
        "{66CCFF}[Telegram Auth]\n\
        {FFFFFF}Код для привязки аккаунта к Telegram боту:\n\
        {FFFF00}%s\n\n\
        {FFFFFF}Отправьте этот код в Telegram боте командой\n\
        {FFFF00}/adminconnect %s\n\n\
        {FFFFFF}Код действителен {FF6600}5 минут",
        code, code
    );
    ShowPlayerDialog(playerid, DIALOG_TELEGRAM_AUTH_SHOW, DIALOG_STYLE_MSGBOX, 
        "{66CCFF}Привязка к Telegram", msg, "Закрыть", "");
    
    new log_msg[128];
    format(log_msg, sizeof(log_msg), "[TelegramAuth] %s[%d] запросил код для привязки: %s",
        GetPlayerNameEx(playerid), playerid, code);
    SendMessageToAdmins(log_msg, 0x999999FF);
    
    return 1;
}

// Команда /testauth
CMD:testauth(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
    {
        SendClientMessage(playerid, 0x999999FF, "У вас нет прав для использования этой команды");
        return 1;
    }
    
    if(!TelegramAuth_IsLinked(playerid))
    {
        new msg[256];
        format(msg, sizeof(msg),
            "{FFFFFF}Ваш аккаунт не привязан к Telegram боту.\n\n\
            Для привязки используйте команду:\n\
            {FFFF00}/admconnect\n\n\
            {FFFFFF}После получения кода в боте, введите его ниже для привязки.\n\n\
            {FF6600}ИЛИ\n\n\
            {FFFFFF}Если вы уже получили код в Telegram боте,\n\
            введите его в поле ниже для авторизации."
        );
        Dialog(playerid, DIALOG_TELEGRAM_AUTH_INPUT, DIALOG_STYLE_INPUT,
            "{66CCFF}Авторизация в админ-панели",
            msg,
            "Авторизоваться", "Отмена"
        );
        return 1;
    }
    
    // Привязан - генерируем код для авторизации
    new code[9];
    format(code, sizeof(code), "%s", TelegramAuth_GenerateCode());
    
    new slot = TelegramAuth_SaveCode(playerid, code);
    if(slot == -1)
    {
        SendClientMessage(playerid, 0xFF6600FF, "Ошибка генерации кода. Попробуйте позже.");
        return 1;
    }
    
    // Сохраняем код в БД для бота
    TelegramAuth_UpdateCode(playerid, code);
    
    new msg[256];
    format(msg, sizeof(msg),
        "{FFFFFF}Ваш аккаунт привязан к Telegram боту.\n\n\
        {FFFFFF}Код для авторизации: {FFFF00}%s\n\
        {FFFFFF}Получите этот код в Telegram боте командой\n\
        {FFFF00}/adminauth\n\n\
        {FFFFFF}Введите код в поле ниже для авторизации.\n\n\
        {FFFFFF}Код действителен {FF6600}5 минут.",
        code
    );
    Dialog(playerid, DIALOG_TELEGRAM_AUTH_INPUT, DIALOG_STYLE_INPUT,
        "{66CCFF}Авторизация в админ-панели",
        msg,
        "Авторизоваться", "Отмена"
    );
    
    return 1;
}

// Обработка диалога
#define DIALOG_TELEGRAM_AUTH_INPUT (10001)
#define DIALOG_TELEGRAM_AUTH_SHOW (10002)

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_TELEGRAM_AUTH_INPUT)
    {
        if(!response)
        {
            SendClientMessage(playerid, 0x999999FF, "Авторизация отменена.");
            return 1;
        }
        
        if(strlen(inputtext) != TELEGRAM_AUTH_CODE_LENGTH || !IsNumeric(inputtext))
        {
            SendClientMessage(playerid, 0xFF6600FF, "Код должен состоять из 8 цифр.");
            Dialog(playerid, DIALOG_TELEGRAM_AUTH_INPUT, DIALOG_STYLE_INPUT,
                "{66CCFF}Авторизация в админ-панели",
                "{FFFFFF}Введите код полученный в Telegram боте:\n\
                {FF6600}Код должен состоять из 8 цифр.",
                "Авторизоваться", "Отмена"
            );
            return 1;
        }
        
        if(TelegramAuth_CheckCode(playerid, inputtext))
        {
            SendClientMessage(playerid, 0x66CC33FF, "Авторизация успешна! Добро пожаловать в админ-панель.");
            
            if(!TelegramAuth_IsLinked(playerid))
            {
                // Бот привяжет аккаунт через запрос к БД
                SendClientMessage(playerid, 0x3399FFFF, "Ожидайте привязки аккаунта через Telegram бота.");
                SendClientMessage(playerid, 0x3399FFFF, "Если привязка не произошла - используйте /admconnect");
            }
            
            AdminAuthorization(playerid);
            return 1;
        }
        else
        {
            SendClientMessage(playerid, 0xFF6600FF, "Код недействителен или истек. Попробуйте снова.");
            
            Dialog(playerid, DIALOG_TELEGRAM_AUTH_INPUT, DIALOG_STYLE_INPUT,
                "{66CCFF}Авторизация в админ-панели",
                "{FFFFFF}Введите код полученный в Telegram боте:\n\
                {FF6600}Код действителен 5 минут.",
                "Авторизоваться", "Отмена"
            );
            return 1;
        }
    }
    return 1;
}