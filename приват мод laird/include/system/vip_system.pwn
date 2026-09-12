/*
    ===========================================================
     VIP SYSTEM 2.0 — SA-MP / CRMP (Pawn)
    ===========================================================

    /vips     — магазин VIP (3 уровня x 4 срока)
    /vc текст — VIP-чат с префиксом и цветом уровня
    /viplist  — список онлайн-VIP (сортировка по уровню)
    /viptop   — топ поддержки сервера по донату, потраченному на VIP (из БД, не только онлайн)
    /setvip   — админ-выдача/снятие VIP

    a_samp / a_mysql / sscanf2 / zcmd / streamer у тебя уже подключены
    в lonexs.pwn раньше по списку — повторно не подключаю.
    Требуется MySQL-хендл `mysql` (тот же, что подключен в остальном гейммоде).

    Оплата — донат-очки: GetPlayerData(playerid, P_DONATE_MONEY) / SetPlayerData(...)

    !!! ВАЖНО — 2 РУЧНЫЕ ВСТАВКИ !!!
    1) Vip_Load(playerid) — вызвать один раз за сессию сразу после логина.
       Смотри блок "ПОДКЛЮЧЕНИЕ К GAMEMODE" внизу.
    2) VipExpireTicker уже сам шлёт предупреждение за 3 дня — ничего
       руками добавлять не надо, просто не забудь SetTimer его в OnGameModeInit.
    3) Vip_OnDialogResponse — это ОБЫЧНАЯ функция, не колбэк. Она НЕ вызовется
       сама. Её нужно вызвать вручную из твоего существующего OnDialogResponse.
       Смотри блок "ПОДКЛЮЧЕНИЕ К GAMEMODE" внизу — без этого /vips
       не будет работать (кнопки будут "не реагировать").
    ===========================================================
*/

// ---------------------------------------------------------
//  НАСТРОЙКИ
// ---------------------------------------------------------
#define VIP_ADMIN_SET_LEVEL   13     // уровень админа для /setvip

#define VIP_NONE    0
#define VIP_BRONZE  1
#define VIP_SILVER  2
#define VIP_GOLD    3

#define VIP_EXPIRE_FOREVER   (-1)    // спец-значение pVipExpire — VIP навсегда

// Индексы срока в UI: 0=7 дней, 1=30 дней, 2=90 дней, 3=навсегда
new const VipDurationDays[3] = {7, 30, 90}; // навсегда (индекс 3) обрабатывается отдельно

// Цена в донат-очках: VipPrice[уровень][индекс_срока]
new const VipPrice[4][4] =
{
    {0,    0,    0,     0},      // не используется (VIP_NONE)
    {700,  2000, 5000,  9000},   // Bronze:  7д / 30д / 90д / навсегда
    {1500, 4000, 8000,  15000},  // Silver
    {3000, 7000, 15000, 25000}   // Gold
};

// Цвета и оформление уровня
new const VipColor[4]        = {0xFFFFFFFF, 0xCD7F32FF, 0x1E90FFFF, 0xFFD700FF}; // белый / бронза / синий / золото
new const VipColorHex[4][8]  = {"FFFFFF",   "CD7F32",   "1E90FF",   "FFD700"};
new const VipName[4][10]     = {"NONE",     "BRONZE",   "SILVER",   "GOLD"};
new const VipNameRu[4][24]   = {"Нет VIP",  "Бронза",   "Серебро",  "Золото"};
// Эмодзи убраны — шрифт SA-MP/CRMP клиента их не поддерживает (ломает и текст рядом)

#define VIP_LABEL_TEXT   "RUSSIA VIP"
#define VIP_WARN_DAYS    3           // за сколько дней предупреждать об окончании

#define DIALOG_VIPS_MAIN    20501    // TODO: проверь, что номера не заняты в твоём enum диалогов
#define DIALOG_VIPS_LEVEL   20502

// ---------------------------------------------------------
//  ДАННЫЕ ИГРОКА (кэш, грузится из БД через Vip_Load)
// ---------------------------------------------------------
new pVipLevel[MAX_PLAYERS];
new pVipExpire[MAX_PLAYERS];        // unix timestamp окончания, -1 = навсегда, 0 = нет VIP
new pVipTotalSpent[MAX_PLAYERS];    // всего донат-очков потрачено на VIP (для /viptop)
new pVipWarned3[MAX_PLAYERS];       // 1 если уже предупреждён об истечении через 3 дня
new Text3D:pVipLabel[MAX_PLAYERS];
new pVipSelectedLevel[MAX_PLAYERS]; // временное хранилище между DIALOG_VIPS_MAIN и DIALOG_VIPS_LEVEL

// ===========================================================
//   БАЗА ДАННЫХ
// ===========================================================
stock Vip_CreateTable()
{
    mysql_tquery(mysql,
        "CREATE TABLE IF NOT EXISTS `player_vip` (\
        `id` INT NOT NULL AUTO_INCREMENT,\
        `account_id` INT NOT NULL,\
        `level` TINYINT NOT NULL DEFAULT 0,\
        `expire` INT NOT NULL DEFAULT 0,\
        `total_spent` INT NOT NULL DEFAULT 0,\
        `warned3` TINYINT NOT NULL DEFAULT 0,\
        PRIMARY KEY(`id`), UNIQUE KEY `account_id` (`account_id`)\
        ) ENGINE=InnoDB;");
    return 1;
}

stock Vip_Load(playerid)
{
    new query[128];
    mysql_format(mysql, query, sizeof(query),
        "SELECT `level`, `expire`, `total_spent`, `warned3` FROM `player_vip` WHERE `account_id` = %d LIMIT 1",
        GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "OnVipLoaded", "d", playerid);
    return 1;
}

forward OnVipLoaded(playerid);
public OnVipLoaded(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(cache_num_rows() > 0)
    {
        new str[16];
        cache_get_row(0, 0, str, sizeof(str)); pVipLevel[playerid]      = strval(str);
        cache_get_row(0, 1, str, sizeof(str)); pVipExpire[playerid]     = strval(str);
        cache_get_row(0, 2, str, sizeof(str)); pVipTotalSpent[playerid] = strval(str);
        cache_get_row(0, 3, str, sizeof(str)); pVipWarned3[playerid]    = strval(str);
    }
    else
    {
        pVipLevel[playerid] = 0;
        pVipExpire[playerid] = 0;
        pVipTotalSpent[playerid] = 0;
        pVipWarned3[playerid] = 0;

        new query[128];
        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO `player_vip` (`account_id`, `level`, `expire`, `total_spent`, `warned3`) VALUES (%d, 0, 0, 0, 0)",
            GetPlayerAccountID(playerid));
        mysql_tquery(mysql, query);
    }

    Vip_CheckExpire(playerid);
    Vip_UpdateLabel(playerid);
    return 1;
}

stock Vip_Save(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;
    new query[224];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE `player_vip` SET `level` = %d, `expire` = %d, `total_spent` = %d, `warned3` = %d WHERE `account_id` = %d",
        pVipLevel[playerid], pVipExpire[playerid], pVipTotalSpent[playerid], pVipWarned3[playerid], GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query);
    return 1;
}

// ===========================================================
//   ХЕЛПЕРЫ
// ===========================================================
stock bool:HasVip(playerid)
{
    return (pVipLevel[playerid] > VIP_NONE);
}

stock bool:IsVipForever(playerid)
{
    return (pVipExpire[playerid] == VIP_EXPIRE_FOREVER);
}

// Выдать/продлить VIP. durIndex: 0=7д, 1=30д, 2=90д, 3=навсегда
stock GivePlayerVip(playerid, level, durIndex)
{
    new spent = VipPrice[level][durIndex];
    pVipTotalSpent[playerid] += spent;
    pVipWarned3[playerid] = 0; // сбрасываем флаг предупреждения при любой покупке/продлении

    if(durIndex == 3) // навсегда
    {
        pVipLevel[playerid] = level;
        pVipExpire[playerid] = VIP_EXPIRE_FOREVER;
        Vip_Save(playerid);
        Vip_UpdateLabel(playerid);
        return 1;
    }

    new days = VipDurationDays[durIndex];
    new now = gettime();

    if(level > pVipLevel[playerid] || pVipExpire[playerid] == 0)
    {
        // новый более высокий уровень (или VIP отсутствовал) — срок считается заново
        pVipLevel[playerid] = level;
        pVipExpire[playerid] = now + (days * 86400);
    }
    else if(IsVipForever(playerid))
    {
        // уже навсегда — покупка того же/меньшего уровня ничего не меняет по сроку
    }
    else
    {
        // тот же уровень — продлеваем: было N дней -> +купленные дни
        new base = (pVipExpire[playerid] > now) ? pVipExpire[playerid] : now;
        pVipExpire[playerid] = base + (days * 86400);
    }

    Vip_Save(playerid);
    Vip_UpdateLabel(playerid);
    return 1;
}

stock RemovePlayerVip(playerid)
{
    pVipLevel[playerid] = 0;
    pVipExpire[playerid] = 0;
    pVipWarned3[playerid] = 0;
    Vip_Save(playerid);
    Vip_UpdateLabel(playerid);
    return 1;
}

stock Vip_UpdateLabel(playerid)
{
    if(IsValidDynamic3DTextLabel(pVipLabel[playerid]))
    {
        DestroyDynamic3DTextLabel(pVipLabel[playerid]);
        pVipLabel[playerid] = Text3D:INVALID_3DTEXT_ID;
    }

    if(pVipLevel[playerid] > 0 && IsPlayerConnected(playerid))
    {
        pVipLabel[playerid] = CreateDynamic3DTextLabel(VIP_LABEL_TEXT, VipColor[pVipLevel[playerid]], 0.0, 0.0, 0.55, 10.0, playerid);
        Attach3DTextLabelToPlayer(pVipLabel[playerid], playerid, 0.0, 0.0, 0.55);
    }
    return 1;
}

// Проверка истечения + предупреждение за VIP_WARN_DAYS дней
stock Vip_CheckExpire(playerid)
{
    if(pVipLevel[playerid] == 0) return 1;
    if(IsVipForever(playerid)) return 1; // навсегда — не проверяем

    new left = pVipExpire[playerid] - gettime();

    if(left <= 0)
    {
        new msg[96];
        format(msg, sizeof(msg), "Твой VIP-статус (%s) истёк.", VipNameRu[pVipLevel[playerid]]);
        SendClientMessage(playerid, 0xFF3333FF, msg);
        RemovePlayerVip(playerid);
        return 1;
    }

    if(left <= (VIP_WARN_DAYS * 86400) && !pVipWarned3[playerid])
    {
        pVipWarned3[playerid] = 1;
        new msg[128];
        format(msg, sizeof(msg), "[!] Ваш VIP %s закончится через %d дн.!", VipName[pVipLevel[playerid]], (left / 86400) + 1);
        SendClientMessage(playerid, 0xFFCC00FF, msg);
        SendClientMessage(playerid, 0xFFCC00FF, "Продлите его через /vips");
        Vip_Save(playerid);
    }
    return 1;
}

forward VipExpireTicker();
public VipExpireTicker()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        Vip_CheckExpire(i);
    }
    return 1;
}

// Глобальный анонс покупки
stock Vip_AnnouncePurchase(playerid, level, durIndex)
{
    new msg[144];
    SendClientMessageToAll(0xFFD700FF, "=== VIP НОВОСТИ ===");
    SendClientMessageToAll(0xFFFFFFFF, " ");
    format(msg, sizeof(msg), "Игрок %s приобрёл", GetPlayerNameEx(playerid));
    SendClientMessageToAll(0xFFFFFFFF, msg);
    format(msg, sizeof(msg), "VIP %s", VipName[level]);
    SendClientMessageToAll(VipColor[level], msg);
    SendClientMessageToAll(0xFFFFFFFF, " ");
    if(durIndex == 3)
        SendClientMessageToAll(0xFFFFFFFF, "Срок: Навсегда");
    else
    {
        format(msg, sizeof(msg), "Срок: %d дней", VipDurationDays[durIndex]);
        SendClientMessageToAll(0xFFFFFFFF, msg);
    }
    SendClientMessageToAll(0xFFFFFFFF, " ");
    SendClientMessageToAll(0x00FF00FF, "Спасибо за поддержку сервера!");
    return 1;
}

// ===========================================================
//   /vips — ГЛАВНОЕ МЕНЮ
// ===========================================================
CMD:vips(playerid, params[])
{
    new list[256];
    format(list, sizeof(list), "Bronze VIP\nSilver VIP\nGold VIP");

    ShowPlayerDialog(playerid, DIALOG_VIPS_MAIN, DIALOG_STYLE_LIST, "VIP СИСТЕМА", list, "Выбрать", "Закрыть");
    return 1;
}

// Это НЕ public-колбэк — обычная функция. Вызови её из своего существующего
// OnDialogResponse (см. инструкцию в самом низу файла), иначе диалоги VIP работать не будут.
stock Vip_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_VIPS_MAIN)
    {
        if(!response) return 1;

        new level = listitem + 1; // 0->BRONZE, 1->SILVER, 2->GOLD
        if(level < VIP_BRONZE || level > VIP_GOLD) return 1;

        pVipSelectedLevel[playerid] = level;

        // Показываем возможности уровня текстом в чат, затем открываем выбор срока
        new capMsg[220];
        format(capMsg, sizeof(capMsg), "VIP %s | Возможности: VIP-чат /vc, свой цвет сообщений, префикс перед ником, анонс покупки всем.",
            VipName[level]);
        SendClientMessage(playerid, VipColor[level], capMsg);

        new exMsg[144];
        format(exMsg, sizeof(exMsg), "Пример в чате: [%s] %s: Всем привет!", VipName[level], GetPlayerNameEx(playerid));
        SendClientMessage(playerid, VipColor[level], exMsg);

        new list[300];
        format(list, sizeof(list),
            "Срок\tЦена\n7 дней\t%d доната\n30 дней\t%d доната\n90 дней\t%d доната\nНавсегда\t%d доната",
            VipPrice[level][0], VipPrice[level][1], VipPrice[level][2], VipPrice[level][3]);

        new title[48];
        format(title, sizeof(title), "VIP %s", VipName[level]);
        ShowPlayerDialog(playerid, DIALOG_VIPS_LEVEL, DIALOG_STYLE_TABLIST_HEADERS, title, list, "Купить", "Назад");
        return 1;
    }

    if(dialogid == DIALOG_VIPS_LEVEL)
    {
        if(!response) return 1;

        new level = pVipSelectedLevel[playerid];
        if(level < VIP_BRONZE || level > VIP_GOLD) return 1;

        new durIndex = listitem; // 0=7д,1=30д,2=90д,3=навсегда
        if(durIndex < 0 || durIndex > 3) return 1;

        if(pVipLevel[playerid] > level)
        {
            SendClientMessage(playerid, 0xFF3333FF, "У тебя уже более высокий уровень VIP.");
            return 1;
        }

        new price = VipPrice[level][durIndex];
        if(GetPlayerData(playerid, P_DONATE_MONEY) < price)
        {
            SendClientMessage(playerid, 0xFF3333FF, "Недостаточно донат-очков.");
            return 1;
        }

        SetPlayerData(playerid, P_DONATE_MONEY, GetPlayerData(playerid, P_DONATE_MONEY) - price);
        GivePlayerVip(playerid, level, durIndex);

        new msg[144];
        if(durIndex == 3)
            format(msg, sizeof(msg), "Ты приобрёл VIP \"%s\" НАВСЕГДА! Списано %d донат-очков.", VipName[level], price);
        else
            format(msg, sizeof(msg), "Ты приобрёл VIP \"%s\" на %d дней! Списано %d донат-очков.", VipName[level], VipDurationDays[durIndex], price);
        SendClientMessage(playerid, 0x00FF00FF, msg);

        Vip_AnnouncePurchase(playerid, level, durIndex);

        format(msg, sizeof(msg), "Игрок %s[acc:%d] купил VIP \"%s\" (%s) за %d донат-очков",
            GetPlayerNameEx(playerid), GetPlayerAccountID(playerid),
            VipName[level], (durIndex == 3) ? ("навсегда") : ("временно"), price);
        SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, msg); // TODO: замени на подходящий тип лога для покупок, если есть отдельный

        return 1;
    }
    return 0;
}

// ===========================================================
//   /vc — VIP-ЧАТ
// ===========================================================
CMD:vc(playerid, params[])
{
    if(!HasVip(playerid))
        return SendClientMessage(playerid, 0xFF3333FF, "Команда доступна только владельцам VIP. Используй /vips.");

    if(isnull(params))
        return SendClientMessage(playerid, 0xCECECEFF, "Использование: /vc [текст]");

    new msg[196];
    format(msg, sizeof(msg), "{%s}[%s] {FFFFFF}%s: %s",
        VipColorHex[pVipLevel[playerid]], VipName[pVipLevel[playerid]],
        GetPlayerNameEx(playerid), params);
    SendClientMessageToAll(0xFFFFFFFF, msg);
    return 1;
}

// ===========================================================
//   /viplist — онлайн VIP, отсортированы по уровню
// ===========================================================
CMD:viplist(playerid, params[])
{
    new ids[MAX_PLAYERS], count = 0;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && IsPlayerLogged(i) && HasVip(i))
        {
            ids[count++] = i;
        }
    }

    if(count == 0)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Сейчас нет игроков с VIP-статусом онлайн.");
        return 1;
    }

    // сортировка по убыванию уровня, затем по убыванию оставшегося времени
    for(new i = 0; i < count - 1; i++)
    {
        for(new j = 0; j < count - i - 1; j++)
        {
            new lvlA = pVipLevel[ids[j]], lvlB = pVipLevel[ids[j+1]];
            new bool:swap = false;

            if(lvlA < lvlB) swap = true;
            else if(lvlA == lvlB)
            {
                new leftA = IsVipForever(ids[j])   ? 999999999 : (pVipExpire[ids[j]]   - gettime());
                new leftB = IsVipForever(ids[j+1]) ? 999999999 : (pVipExpire[ids[j+1]] - gettime());
                if(leftA < leftB) swap = true;
            }

            if(swap)
            {
                new tmp = ids[j];
                ids[j] = ids[j+1];
                ids[j+1] = tmp;
            }
        }
    }

    SendClientMessage(playerid, 0xFFD700FF, "VIP Игроки:");
    SendClientMessage(playerid, 0xFFFFFFFF, " ");

    new msg[128];
    for(new i = 0; i < count; i++)
    {
        new pid = ids[i];
        if(IsVipForever(pid))
        {
            format(msg, sizeof(msg), "%s - %s (навсегда)", GetPlayerNameEx(pid), VipName[pVipLevel[pid]]);
        }
        else
        {
            new days = (pVipExpire[pid] - gettime()) / 86400;
            format(msg, sizeof(msg), "%s - %s (%d дней)", GetPlayerNameEx(pid), VipName[pVipLevel[pid]], days);
        }
        SendClientMessage(playerid, VipColor[pVipLevel[pid]], msg);
    }
    return 1;
}

// ===========================================================
//   /viptop — топ поддержки сервера (по донату, потраченному на VIP; из БД, не только онлайн)
// ===========================================================
CMD:viptop(playerid, params[])
{
    mysql_tquery(mysql,
        "SELECT `account_id`, `level`, `total_spent` FROM `player_vip` WHERE `total_spent` > 0 ORDER BY `total_spent` DESC LIMIT 10",
        "OnVipTopLoaded", "d", playerid);
    return 1;
}

forward OnVipTopLoaded(playerid);
public OnVipTopLoaded(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    new rows = cache_num_rows();
    if(rows == 0)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Пока никто не поддержал сервер покупкой VIP.");
        return 1;
    }

    SendClientMessage(playerid, 0xFFD700FF, "VIP рейтинг:");
    SendClientMessage(playerid, 0xFFFFFFFF, "Топ VIP поддержки:");
    SendClientMessage(playerid, 0xFFFFFFFF, " ");

    new str[16], accid, level, spent, msg[128];
    for(new i = 0; i < rows; i++)
    {
        cache_get_row(i, 0, str, sizeof(str)); accid = strval(str);
        cache_get_row(i, 1, str, sizeof(str)); level = strval(str);
        cache_get_row(i, 2, str, sizeof(str)); spent = strval(str);

        // TODO: если хочешь показывать ник, а не account_id — подключи функцию
        // получения ника по account_id из своей системы аккаунтов (что-то вроде
        // GetAccountNameByID(accid)). Пока выводим ID аккаунта.
        format(msg, sizeof(msg), "%d. [acc:%d] - %s (потрачено: %d доната)", i + 1, accid, VipName[level], spent);
        SendClientMessage(playerid, VipColor[level], msg);
    }
    return 1;
}

// ===========================================================
//   /setvip — АДМИН
// ===========================================================
CMD:setvip(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < VIP_ADMIN_SET_LEVEL)
        return SendClientMessage(playerid, 0xFF3333FF, "У тебя недостаточно прав.");

    new targetid, level, days;
    if(sscanf(params, "udd", targetid, level, days))
        return SendClientMessage(playerid, 0xCECECEFF, "Использование: /setvip [ID] [1-3] [дней] (0 дней = снять VIP, -1 = навсегда)");

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return SendClientMessage(playerid, 0xFF3333FF, "Такого игрока нет.");

    if(level < 0 || level > VIP_GOLD)
        return SendClientMessage(playerid, 0xFF3333FF, "Уровень должен быть от 0 до 3.");

    new msg[144];

    // 0 (или любое отрицательное, кроме -1) в поле "дней" — всегда значит "снять VIP",
    // независимо от того, какой уровень указан. -1 — отдельный случай, "навсегда".
    if(level == 0 || days == 0)
    {
        RemovePlayerVip(targetid);
        format(msg, sizeof(msg), "Администратор %s снял с тебя VIP-статус.", GetPlayerNameEx(playerid));
        SendClientMessage(targetid, 0xFF3333FF, msg);
    }
    else
    {
        pVipLevel[targetid] = level;
        pVipExpire[targetid] = (days == -1) ? VIP_EXPIRE_FOREVER : (gettime() + (days * 86400));
        pVipWarned3[targetid] = 0;
        Vip_Save(targetid);
        Vip_UpdateLabel(targetid);

        if(days == -1)
            format(msg, sizeof(msg), "Администратор %s выдал тебе VIP \"%s\" НАВСЕГДА.", GetPlayerNameEx(playerid), VipName[level]);
        else
            format(msg, sizeof(msg), "Администратор %s выдал тебе VIP \"%s\" на %d дней.", GetPlayerNameEx(playerid), VipName[level], days);
        SendClientMessage(targetid, 0x00FF00FF, msg);
    }

    format(msg, sizeof(msg), "[A] %s выдал VIP уровня %d (%d дн.) игроку %s",
        GetPlayerNameEx(playerid), level, days, GetPlayerNameEx(targetid));
    SendLog(playerid, LOG_TYPE_SUPERADMIN_ACTION, msg); // TODO: замени на подходящий тип лога, если есть отдельный для VIP-действий админов

    return 1;
}

/*
    ===========================================================
     ПОДКЛЮЧЕНИЕ К GAMEMODE — 3 ШАГА
    ===========================================================

    1) В OnGameModeInit() добавь:

        Vip_CreateTable();
        SetTimer("VipExpireTicker", 3600000, true); // проверка раз в час

    2) В свой существующий колбэк входа/логина (там, где у тебя обычно
       грузятся деньги, фракция, дом и т.д. — часто называется что-то
       вроде OnPlayerLogin / OnPlayerEnterGame после успешного логина)
       добавь один вызов:

        Vip_Load(playerid);

    3) В свой существующий колбэк OnDialogResponse — САМОЕ ВАЖНОЕ,
       без этого шага диалоги /vips работать не будут:

        public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
        {
            if(Vip_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]))
                return 1;

            // ... весь остальной твой существующий код с другими
            //     диалогами (дома, работы, админка и т.д.) остаётся
            //     ниже без изменений
        }

    Готово. Если у тебя в OnDialogResponse уже используется какой-то
    паттерн вроде switch(dialogid) — просто добавь этот if в самое
    начало функции, до switch.
    ===========================================================
*/
