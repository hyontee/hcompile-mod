//>> Файл: bykranin_src/systems/blogger_system.pwn
//>> Подключается из bykranin.pwn сразу после systems/coords_hud.pwn (до core/callbacks).
//>> Хуки: Blogger_OnPlayerLogin (LoadPlayerData, load_player_data.inc), Blogger_OnPlayerDisconnect (OnPlayerDisconnect, callbacks_01.inc),
//>> Blogger_OnDialogResponse (начало OnDialogResponse, on_dialog_response.inc). Таблица blogger_profiles создаётся в OnGameModeInit.
/*
    ============================================================
     СИСТЕМА ДЛЯ БЛОГЕРОВ (fake-nick / fake-mileage)
    ============================================================
    Команда:  /blogger [id]   (алиас /streamersys)
    Доступ:   GetPlayerAdminEx(playerid) >= BLOGGER_ADMIN_LVL и авторизация админа

    1. Меняет игроку игровой ник (SetPlayerName + P_NAME): над головой, в чате, в Tab.
    2. Ставит пробег текущему авто игрока через SetVehicleSpeedometerInfo()
       (для личных авто сохраняется штатным SaveOwnableCarMileage).
    3. Ник сохраняется в БД (blogger_profiles) и восстанавливается при входе,
       пока админ не нажмёт "Сбросить оформление".
*/
#if defined _BLOGGER_SYSTEM_INC
    #endinput
#endif
#define _BLOGGER_SYSTEM_INC

// определена позже (core/world/world_01.inc)
forward SaveOwnableCarMileage(vehicleid);

#define BLOGGER_ADMIN_LVL       1       // минимальный уровень админки для /blogger

#define DLG_BLG_MAIN            9050
#define DLG_BLG_NICK            9051
#define DLG_BLG_MILEAGE         9053
#define DLG_BLG_RESET_CONFIRM   9054

enum E_BLOGGER_DATA
{
    bool:bd_Enabled
};
new BloggerData[MAX_PLAYERS][E_BLOGGER_DATA];

// Подмена ID убрана из системы блогера: игрокам всегда показывается
// настоящий playerid. Функция оставлена для совместимости.
stock Blogger_GetDisplayID(playerid)
{
    return playerid;
}

new BloggerTemp[MAX_PLAYERS];        // playerid админа -> playerid цели, на которую открыто меню
new BloggerMenuOffset[MAX_PLAYERS];  // сколько первых строк меню - инфо-шапка

// считает количество строк (\n) - чтобы знать, сколько первых пунктов списка занимает инфо-шапка
stock Blogger_CountLines(const text[])
{
    new count = 0;
    for(new i = 0; text[i] != 0; i++)
    {
        if(text[i] == '\n') count++;
    }
    return count;
}

// ================= ВСПОМОГАТЕЛЬНОЕ =================

stock bool:Blogger_IsValidNick(const nick[])
{
    new len = strlen(nick);
    if(len < 3 || len > 20) return false;

    for(new i; i < len; i++)
    {
        new c = nick[i];
        if(!((c >= 'a' && c <= 'z') || (c >= 'A' && c <= 'Z') || (c >= '0' && c <= '9') || c == '_'))
            return false;
    }
    return true;
}

// сохраняет текущее состояние (ник берём из GetPlayerNameEx, т.к. он уже подменён SetPlayerName)
stock Blogger_Persist(playerid)
{
    new query[256];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO blogger_profiles (account_id, enabled, fake_nick) VALUES (%d, 1, '%e') "\
        "ON DUPLICATE KEY UPDATE enabled=1, fake_nick='%e'",
        GetPlayerAccountID(playerid), GetPlayerNameEx(playerid),
        GetPlayerNameEx(playerid));
    mysql_tquery(mysql, query);
    return 1;
}

// ================= ЗАГРУЗКА ПРИ ВХОДЕ =================

stock Blogger_OnPlayerLogin(playerid)
{
    BloggerData[playerid][bd_Enabled] = false;

    new query[128];
    mysql_format(mysql, query, sizeof query,
        "SELECT enabled, fake_nick FROM blogger_profiles WHERE account_id=%d LIMIT 1",
        GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "OnBloggerProfileLoaded", "ii", playerid, GetPlayerAccountID(playerid));
    return 1;
}

forward OnBloggerProfileLoaded(playerid, account_id);
public OnBloggerProfileLoaded(playerid, account_id)
{
    if(!IsPlayerConnected(playerid) || GetPlayerAccountID(playerid) != account_id) return 1;
    if(cache_num_rows() > 0 && cache_get_field_content_int(0, "enabled") == 1)
    {
        new fake_nick[24], namebuf[21];
        cache_get_field_content(0, "fake_nick", fake_nick);

        if(strlen(fake_nick) > 0 && SetPlayerName(playerid, fake_nick) == 1)
        {
            format(namebuf, sizeof namebuf, "%s", fake_nick);
            SetPlayerData(playerid, P_NAME, namebuf);
            BloggerData[playerid][bd_Enabled] = true;
        }
    }
    return 1;
}

stock Blogger_OnPlayerDisconnect(playerid, reason)
{
    #pragma unused reason
    BloggerData[playerid][bd_Enabled] = false;
    return 1;
}

// ================= МЕНЮ =================

stock ShowBloggerMenu(playerid)
{
    new target = BloggerTemp[playerid], str[400];

    new status_str[24];
    if(BloggerData[target][bd_Enabled])
        format(status_str, sizeof status_str, "{33FF33}включено");
    else
        format(status_str, sizeof status_str, "{FF3333}выключено");

    // Число строк инфо-шапки считается автоматически и вычитается из listitem в обработчике.
    new header[200];
    format(header, sizeof header,
        "{ADD8E6}Игрок:{FFFFFF} %s (ID: %d)\n{ADD8E6}Оформление блогера:%s\n",
        GetPlayerNameEx(target), target, status_str);
    BloggerMenuOffset[playerid] = Blogger_CountLines(header);

    format(str, sizeof str,
        "%s{FFFFFF}Изменить ник\n"\
        "{FFFFFF}Установить пробег текущего авто\n"\
        "{FF9999}Сбросить оформление (вернуть настоящее)", header);

    ShowPlayerDialog(playerid, DLG_BLG_MAIN, DIALOG_STYLE_LIST,
        "Система для блогеров", str, "Выбрать", "Закрыть");
    return 1;
}

// ================= КОМАНДА =================

CMD:blogger(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < BLOGGER_ADMIN_LVL || !GetPlayerData(playerid, P_ADMIN_LOGGED))
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет доступа к этой команде.");

    new target;
    if(sscanf(params, "u", target))
        target = playerid;

    if(!IsPlayerConnected(target) || !IsPlayerLogged(target))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок не в сети.");

    BloggerTemp[playerid] = target;
    ShowBloggerMenu(playerid);
    return 1;
}
alias:blogger("streamersys")

// ================= ОБРАБОТКА ДИАЛОГОВ =================

stock Blogger_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid < DLG_BLG_MAIN || dialogid > DLG_BLG_RESET_CONFIRM) return 0;
    if(GetPlayerAdminEx(playerid) < BLOGGER_ADMIN_LVL || !GetPlayerData(playerid, P_ADMIN_LOGGED)) return 0;

    switch(dialogid)
    {
        case DLG_BLG_MAIN:
        {
            if(!response) return 1;
            new target = BloggerTemp[playerid];
            new realitem = listitem - BloggerMenuOffset[playerid];

            switch(realitem)
            {
                case 0:
                {
                    ShowPlayerDialog(playerid, DLG_BLG_NICK, DIALOG_STYLE_INPUT,
                        "Новый ник", "Введите новый ник игроку (3-20 симв., латиница/цифры/_):\nПример: Max_Payne", "Далее", "Назад");
                }

                case 1:
                {
                    if(!IsPlayerConnected(target) || GetPlayerVehicleID(target) == 0)
                    {
                        SendClientMessage(playerid, 0xFF3333AA, "Игрок должен находиться в автомобиле.");
                        return ShowBloggerMenu(playerid);
                    }
                    ShowPlayerDialog(playerid, DLG_BLG_MILEAGE, DIALOG_STYLE_INPUT,
                        "Пробег", "Введите новый пробег авто (км), например 158420.5:", "Установить", "Назад");
                }

                case 2:
                {
                    ShowPlayerDialog(playerid, DLG_BLG_RESET_CONFIRM, DIALOG_STYLE_MSGBOX,
                        "Подтверждение", "Вернуть игроку настоящий ник?", "Сбросить", "Отмена");
                }
            }
            return 1;
        }

        case DLG_BLG_NICK:
        {
            if(!response) return ShowBloggerMenu(playerid);
            new target = BloggerTemp[playerid];

            if(!Blogger_IsValidNick(inputtext))
            {
                SendClientMessage(playerid, 0xFF3333AA, "Неверный формат. 3-20 символов: латиница, цифры, _");
                return ShowPlayerDialog(playerid, DLG_BLG_NICK, DIALOG_STYLE_INPUT,
                    "Новый ник", "Введите новый ник игроку (3-20 симв., латиница/цифры/_):\nПример: Max_Payne", "Далее", "Назад");
            }

            if(!IsPlayerConnected(target))
            {
                SendClientMessage(playerid, 0xFF3333AA, "Игрок вышел из игры.");
                return ShowBloggerMenu(playerid);
            }

            if(SetPlayerName(target, inputtext) != 1)
            {
                SendClientMessage(playerid, 0xFF3333AA, "Не удалось изменить ник (возможно, уже занят).");
                return ShowBloggerMenu(playerid);
            }

            new namebuf[21];
            format(namebuf, sizeof namebuf, "%s", inputtext);
            SetPlayerData(target, P_NAME, namebuf);
            BloggerData[target][bd_Enabled] = true;
            Blogger_Persist(target);

            SendClientMessage(playerid, 0x33FF33AA, "Ник игрока изменён и сохранён.");
            SendClientMessage(target, 0x33FF33AA, "Ваш игровой ник был изменён администратором.");
            return ShowBloggerMenu(playerid);
        }

        case DLG_BLG_MILEAGE:
        {
            if(!response) return ShowBloggerMenu(playerid);
            new target = BloggerTemp[playerid];
            new Float:mileage_value;

            if(sscanf(inputtext, "f", mileage_value) || mileage_value < 0.0 || mileage_value > 9999999.0)
            {
                SendClientMessage(playerid, 0xFF3333AA, "Введите корректное число (0 - 9999999).");
                return ShowPlayerDialog(playerid, DLG_BLG_MILEAGE, DIALOG_STYLE_INPUT,
                    "Пробег", "Введите новый пробег авто (км), например 158420.5:", "Установить", "Назад");
            }

            if(!IsPlayerConnected(target) || GetPlayerVehicleID(target) == 0)
            {
                SendClientMessage(playerid, 0xFF3333AA, "Игрок больше не в автомобиле.");
                return ShowBloggerMenu(playerid);
            }

            new vehicleid = GetPlayerVehicleID(target);
            SetVehicleSpeedometerInfo(vehicleid, GetVehicleData(vehicleid, V_FUEL), mileage_value);

            // штатное сохранение пробега личного авто (для остальных вернёт 0)
            if(SaveOwnableCarMileage(vehicleid))
            {
                SendClientMessage(playerid, 0x33FF33AA, "Пробег установлен и сохранён в базе (личный авто).");
            }
            else
            {
                SendClientMessage(playerid, 0x33FF33AA, "Пробег установлен визуально.");
                SendClientMessage(playerid, 0xCECECEFF, "Это авто не является личным/сохраняемым - значение сбросится при переспавне машины.");
            }
            return ShowBloggerMenu(playerid);
        }

        case DLG_BLG_RESET_CONFIRM:
        {
            new target = BloggerTemp[playerid];
            if(!response) return ShowBloggerMenu(playerid);

            if(!IsPlayerConnected(target))
            {
                SendClientMessage(playerid, 0xFF3333AA, "Игрок вышел из игры.");
                return 1;
            }

            new query[128];
            mysql_format(mysql, query, sizeof query,
                "UPDATE blogger_profiles SET enabled=0 WHERE account_id=%d",
                GetPlayerAccountID(target));
            mysql_tquery(mysql, query);

            mysql_format(mysql, query, sizeof query,
                "SELECT name FROM accounts WHERE id=%d LIMIT 1",
                GetPlayerAccountID(target));
            mysql_tquery(mysql, query, "OnBloggerResetName", "i", target);

            BloggerData[target][bd_Enabled] = false;

            SendClientMessage(playerid, 0x33FF33AA, "Оформление сброшено.");
            return 1;
        }
    }
    return 0;
}

forward OnBloggerResetName(playerid);
public OnBloggerResetName(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(cache_num_rows() > 0)
    {
        new real_name[24], namebuf[21];
        cache_get_field_content(0, "name", real_name);
        format(namebuf, sizeof namebuf, "%s", real_name);
        SetPlayerName(playerid, namebuf);
        SetPlayerData(playerid, P_NAME, namebuf);
        SendClientMessage(playerid, 0x33FF33AA, "Администратор вернул ваш настоящий игровой ник.");
    }
    return 1;
}
