// Read-only help for the commands present in this staged version. Does not grant rights.
#if defined _sr_admin_help_included
    #endinput
#endif
#define _sr_admin_help_included

enum E_SR_HELP { SRH_LEVEL, SRH_COMMAND[24], SRH_DESCRIPTION[120] };
new const g_SRHelp[][E_SR_HELP] =
{
    {1, "ahelp", "Открыть справку по уровням администрации"},
    {1, "a", "Написать в административный чат"},
    {1, "admins", "Список администрации онлайн; дополнительно требуется VIP 1-3"},
    {1, "astats", "Посмотреть административную статистику"},
    {1, "ans", "Взять жалобу из очереди и ответить игроку"},
    {1, "rep", "Открыть ответ на жалобу, аналог /ans"},
    {1, "sp", "Начать наблюдение за игроком"},
    {1, "spoff", "Завершить наблюдение и вернуться обратно"},
    {1, "tp", "Открыть список мест для телепортации"},
    {1, "tplist", "Открыть меню телепортов, аналог /tp"},
    {1, "goto", "Отправить игроку запрос на телепорт к нему; подтверждение /y; сокращение /g"},
    {1, "gethere", "Запросить телепорт игрока к себе; подтверждение /y; сокращение /gh"},
    {12, "kick", "Отключить игрока от сервера с причиной"},
    {12, "skick", "Отключить игрока без публичного объявления"},
    {12, "mute", "Заблокировать чат на 1-360 минут"},
    {12, "unmute", "Снять блокировку чата"},
    {12, "jail", "Отправить игрока в административную тюрьму на 1-360 минут"},
    {12, "unjail", "Освободить игрока из административной тюрьмы"},
    {1, "slap", "Поднять или опустить игрока по высоте"},
    {1, "agm", "Включить или выключить административное бессмертие"},
    {1, "askin", "Выбрать административную внешность или вернуть прежнюю"},
    {1, "inter", "Изменить интерьер игрока"},
    {1, "world", "Изменить виртуальный мир игрока"},
    {1, "vw", "Изменить виртуальный мир, аналог /world"},
    {1, "setvw", "Изменить виртуальный мир, аналог /world"},
    {1, "flip", "Поставить перевёрнутый автомобиль на колёса"},
    {1, "hp", "Восстановить здоровье; на первом уровне только себе"},
    {12, "ndrive", "Выдать предусмотренное наказание за NonRP-вождение"},
    {12, "dm", "Выдать предусмотренное наказание за DM"},
    {12, "db", "Выдать предусмотренное наказание за DB"},
    {12, "mg", "Выдать мут за Metagaming"},
    {12, "goss", "Выдать мут за нарушение правил гос. чата"},
    {12, "osk", "Выдать мут за оскорбление"},
    {12, "oskadm", "Выдать мут за оскорбление администрации"},
    {12, "caps", "Выдать мут за CAPS"},
    {12, "sk", "Выдать наказание за Spawn Kill"},
    {2, "weap", "Посмотреть оружие и боезапас игрока"},
    {2, "sethp", "Установить здоровье игрока"},
    {2, "settime", "Установить игровое время"},
    {2, "setweather", "Установить погоду"},
    {2, "event", "Открыть управление мероприятием"},
    {2, "freeze", "Заморозить управление игрока"},
    {2, "unfreeze", "Разморозить управление игрока"},
    {2, "namelist", "Одобрить заявку игрока на смену никнейма"},
    {2, "vtp", "Телепортироваться к транспорту по его ID"},
    {2, "fixcar", "Отремонтировать автомобиль"},
    {12, "warn", "Выдать предупреждение; третье блокирует аккаунт на 10 дней"},
    {12, "unwarn", "Снять все предупреждения игрока"},
    {2, "aspawn", "Открыть административный выбор спавна"},
    {3, "ears", "Включить или выключить административный просмотр SMS"},
    {12, "ban", "Заблокировать аккаунт: до 30 дней, с уровня 5 до 90 дней"},
    {12, "offban", "Заблокировать офлайн-аккаунт по нику на 1-90 дней"},
    {12, "unban", "Снять блокировку аккаунта по нику"},
    {3, "setfuel", "Установить количество топлива в автомобиле"},
    {3, "givegun", "Выдать игровое оружие игроку"},
    {3, "money", "Посмотреть финансовые данные аккаунта"},
    {3, "mp", "Отправить объявление о мероприятии"},
    {12, "pg", "Выдать предусмотренное наказание за Powergaming"},
    {12, "flood", "Выдать мут за флуд"},
    {4, "veh", "Создать административный автомобиль"},
    {4, "delveh", "Удалить административный автомобиль"},
    {4, "house", "Телепортироваться к дому по его номеру"},
    {4, "biz", "Телепортироваться к бизнесу по его номеру"},
    {4, "fuelstation", "Телепортироваться к АЗС по её номеру"},
    {4, "setskin", "Установить внешность игроку"},
    {4, "prefix", "Установить административный префикс"},
    {12, "mat", "Выдать мут за ненормативную лексику"},
    {5, "setleader", "Назначить лидера организации"},
    {5, "setspeed", "Изменить скорость транспорта"},
    {6, "admlist", "Открыть список администрации"},
    {6, "agivelic", "Выдать игроку лицензию"},
    {6, "setskills", "Установить игровые навыки игрока"},
    {6, "createytpromo", "Создать промокод для YouTube-партнёра"},
    {6, "debug", "Посмотреть свой virtual world и interior"},
    {12, "permban", "Выдать предусмотренную командой постоянную блокировку"},
    {12, "offpermban", "Постоянно заблокировать офлайн-аккаунт"},
    {6, "setplayerhouse", "Назначить игроку дом"},
    {6, "setplayerbiz", "Назначить игроку бизнес"},
    {6, "givecoins", "Выдать игровые монеты игроку"},
    {6, "cheat", "Выдать предусмотренное наказание за читы"},
    {6, "ppv", "Выдать наказание за передачу или продажу аккаунта"},
    {6, "bot", "Выдать предусмотренное наказание за использование бота"},
    {7, "templeader", "Назначить временного лидера"},
    {7, "skin", "Установить собственную внешность по ID"},
    {8, "get", "Посмотреть аккаунт и его транспорт по никнейму"},
    {8, "getacc", "Посмотреть аккаунт и его транспорт по ID аккаунта"},
    {8, "lip", "Найти аккаунты по IP-адресу"},
    {8, "techinfo", "Посмотреть технические данные аккаунта по никнейму"},
    {8, "arecovery", "Открыть административное восстановление"},
    {9, "setadmin", "Назначить административный уровень через меню, не выше своего"},
    {9, "deladmin", "Снять нижестоящего администратора"},
    {9, "avig", "Выдать административный выговор"},
    {9, "unavig", "Снять административный выговор"},
    {12, "delacc", "Удалить аккаунт; необратимая административная операция"},
    {9, "sliv", "Выдать предусмотренное наказание за вред серверу"},
    {10, "cc", "Очистить общий чат"},
    {11, "giverub", "Выдать донат-валюту игроку"},
    {12, "getlog", "Посмотреть журнал действий аккаунта"},
    {12, "setstats", "Изменить параметр игрока по коду параметра"},
    {12, "uval", "Уволить игрока из организации"},
    {12, "autosalon", "Изменить наличие и слоты автомобилей в автосалоне"},
    {11, "givecash", "Выдать игровые деньги игроку"},
    {11, "givedonate", "Выдать донат-валюту игроку"},
    {13, "setadm", "Установить административный уровень 0-6 по ID игрока"},
    {13, "restart", "Запустить перезапуск сервера"},
    {13, "msg", "Отправить общее административное сообщение"},
    {13, "reklama", "Отправить серверное рекламное уведомление"},
    {13, "inforestart", "Предупредить игроков о перезапуске"},
    {13, "delvehall", "Удалить административные автомобили"},
    {11, "givevip", "Выдать VIP-статус игроку"},
    {13, "reset_cash", "Обнулить игровые деньги игрока"},
    {13, "reset_donate", "Обнулить донат-валюту игрока"},
    {13, "sendcmd", "Выполнить административно заданную команду"},
    {11, "givecar", "Выдать игроку личный автомобиль"},
    {13, "addhouse", "Создать дом"},
    {13, "addbiz", "Создать бизнес"},
    {13, "addfuelst", "Создать АЗС"},
    {13, "payday", "Запустить расчётный час сервера"},
    {13, "addzone", "Создать территорию"},
    {12, "banip", "Заблокировать IP игрока"},
    {12, "banipoff", "Заблокировать указанный IP-адрес"},
    {12, "unbanip", "Снять блокировку IP-адреса"},
    {13, "getname", "Узнать никнейм по номеру аккаунта в БД"},
    {13, "gzcolor", "Команда управления цветом территории; реализация ещё переносится"},
    {13, "sellproperty", "Сбросить владение имуществом по параметрам команды"},
    {13, "setprods", "Установить запас продукции бизнеса"},
    {13, "fullprods", "Пополнить продукцию всех бизнесов"},
    {13, "setfuels", "Установить запас топлива АЗС"},
    {13, "fullfuels", "Пополнить топливо всех АЗС"}
};

// TEST 2.4 level 11 is a safe test-observer role.
new const g_SRTest11Allowed[][24] =
{
    "ahelp", "a", "admins", "astats", "ans", "rep",
    "sp", "ssp", "spoff", "tp", "tplist", "goto", "g", "gethere", "gh", "y",
    "weap", "money", "debug", "getcam", "getlog", "getname", "getacc", "getacc", "getv",
    "agm", "askin", "skin", "fixcar", "flip", "hp", "inter", "world", "vw", "setvw",
    "house", "biz", "fuelstation", "vtp", "updatevisual", "templeader"
};

new const g_SRTest11ExtraBlocked[][24] =
{
    "kick", "skick", "akick", "mute", "unmute", "amute", "offmute",
    "jail", "unjail", "ajail", "offjail", "warn", "unwarn", "awarn", "offwarn",
    "ban", "b", "sban", "aban", "offban", "oban", "unban", "uban",
    "permban", "pban", "offpermban", "opban", "banip", "banipoff", "unbanip",
    "ndrive", "dm", "db", "mg", "goss", "osk", "oskadm", "caps", "sk", "pg", "flood", "mat",
    "cheat", "ppv", "bot", "sliv", "avig",
    "delacc", "deleteacc", "removeacc", "setadmin", "makeadmin", "deladmin", "setadm", "setleader",
    "get", "getacc", "lip", "techinfo", "getlog", "getname", "arecovery"
};

stock SRAdmin_TestLevel11Guard(playerid, const raw_cmd[])
{
    if(SRAdmin_Level(playerid) != 11) return 1;
    new command[32], start;
    if(raw_cmd[0] == '/') start = 1;
    strmid(command, raw_cmd, start, strlen(raw_cmd), sizeof command);

    for(new i; i < sizeof g_SRTest11ExtraBlocked; i++)
    {
        if(!strcmp(command, g_SRTest11ExtraBlocked[i], true))
        {
            SendClientMessage(playerid, 0xFF5533FF, "TEST 2.4: эта команда недоступна безопасному администратору 11 уровня.");
            return 0;
        }
    }
    return 1;
}stock SRAdmin_ShowHelp(playerid, level = 0, page = 0)
{
    if(!SRAdmin_Require(playerid, 1)) return 1;
    if(level < 0 || level > 13 || page < 0 || page > sizeof(g_SRHelp) / 12) return 1;
    if(level > SRAdmin_Level(playerid)) return SendClientMessage(playerid, -1, "Этот уровень выше вашего. Откройте доступный раздел.");
    new text[3072], row[160], title[80], more;
    if(level == 0)
    {
        for(new i = 1; i <= 13; i++)
        {
            format(row, sizeof row, "%d. %s%s\n", i, g_SRAdminRank[i], i > SRAdmin_Level(playerid) ? " (недоступно)" : "");
            strcat(text, row, sizeof text);
        }
        format(title, sizeof title, "Команды администрации: уровни");
    }
    else
    {
        new total;
        for(new i; i < sizeof(g_SRHelp); i++) if(g_SRHelp[i][SRH_LEVEL] == level) total++;
        if(page > (total > 0 ? (total - 1) / 12 : 0)) return 1;
        format(text, sizeof text, "Команды, добавляемые на этом уровне. Нижние уровни доступны отдельно.\n\n");
        new position, shown;
        for(new i; i < sizeof(g_SRHelp); i++)
        {
            if(g_SRHelp[i][SRH_LEVEL] != level) continue;
            if(position++ < page * 12) continue;
            if(shown == 12) { more = 1; break; }
            format(row, sizeof row, "/%s - %s\n", g_SRHelp[i][SRH_COMMAND], g_SRHelp[i][SRH_DESCRIPTION]);
            strcat(text, row, sizeof text);
            shown++;
        }
        if(!total) strcat(text, "Новых команд нет. Используйте разделы предыдущих уровней.", sizeof text);
        format(title, sizeof title, "%d. %s | %d", level, g_SRAdminRank[level], page + 1);
    }
    SetPVarInt(playerid, "SRHelpPending", 1);
    SetPVarInt(playerid, "SRHelpLevel", level);
    SetPVarInt(playerid, "SRHelpPage", page);
    SetPVarInt(playerid, "SRHelpMore", more);
    if(!level) return Dialog(playerid, 1098, DIALOG_STYLE_LIST, title, text, "Открыть", "Закрыть");
    return Dialog(playerid, 1098, DIALOG_STYLE_MSGBOX, title, text, more ? "Далее" : "К началу", "Уровни");
}

stock SRAdmin_HelpResponse(playerid, response, listitem)
{
    if(!GetPVarInt(playerid, "SRHelpPending")) return 1;
    DeletePVar(playerid, "SRHelpPending");
    if(!SRAdmin_Require(playerid, 1)) return 1;
    new level = GetPVarInt(playerid, "SRHelpLevel");
    if(!level)
    {
        if(response && listitem >= 0 && listitem < 13) return SRAdmin_ShowHelp(playerid, listitem + 1);
        return 1;
    }
    if(!response) return SRAdmin_ShowHelp(playerid);
    return SRAdmin_ShowHelp(playerid, level, GetPVarInt(playerid, "SRHelpMore") ? GetPVarInt(playerid, "SRHelpPage") + 1 : 0);
}
