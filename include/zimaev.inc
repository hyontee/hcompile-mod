// zima_event.inc
// Зимний ивент для SA-MP (PAWN)
// Команда: /ZimaInvent
// Открывает меню с 3 играми. По выбору игроку выдается бонус: донат, игровые рубли, аксессуар.

#ifndef __ZIMA_EVENT_INC
#define __ZIMA_EVENT_INC

#define DIALOG_ZIMA_MAIN 4000
#define DIALOG_ZIMA_INFO 4001

new const g_ZimaGameNames[3][64] = {
    "1. Беги не оглядываясь",
    "2. Зимний перепалол",
    "3. Зимние гонки"
};

new const g_ZimaGameDesc[3][256] = {
    "Правила: Беги, не оглядываясь. Уклоняйся от препятствий.\nБонус: Донат: 10, Рубли: 500, Аксессуар: Шарф",
    "Правила: Командная мини-игра с снежками.\nБонус: Донат: 15, Рубли: 750, Аксессуар: Шапка",
    "Правила: Гонки на санях/машинах по снегу.\nБонус: Донат: 12, Рубли: 600, Аксессуар: Коньки"
};

// Бонусные значения (можно менять)
new const g_ZimaDonat[3] = {10, 15, 12};
new const g_ZimaRubles[3] = {500, 750, 600};
new const g_ZimaAccessory[3][32] = {"Шарф", "Шапка", "Коньки"};

// Хранилище, чтобы не выдать бонус дважды (по желанию)
new bool:g_ZimaBonusGiven[MAX_PLAYERS+1][3];

// Открывает главное меню
stock OpenZimaMenu(playerid)
{
    new menu[1024];
    format(menu, sizeof(menu), "== Зимний Ивент ==\nВыберите игру:\n\n1) %s\n2) %s\n3) %s\n\nВыберите пункт и нажмите 'Выбрать'",
        g_ZimaGameNames[0], g_ZimaGameNames[1], g_ZimaGameNames[2]);
    ShowPlayerDialog(playerid, DIALOG_ZIMA_MAIN, DIALOG_STYLE_LIST, "Зимний Ивент", menu, "Выбрать", "Закрыть");
    return 1;
}

// Показываем подробности выбранной игры
stock ShowZimaInfo(playerid, gameid)
{
    if (gameid < 0 || gameid > 2) return 0;
    new info[1024];
    format(info, sizeof(info), "%s\n\n%s\n\nНажмите 'Получить бонус' чтобы получить вознаграждение.", g_ZimaGameNames[gameid], g_ZimaGameDesc[gameid]);
    ShowPlayerDialog(playerid, DIALOG_ZIMA_INFO, DIALOG_STYLE_MSGBOX, g_ZimaGameNames[gameid], info, "Получить бонус", "Отмена");
    // Передадим выбранную игру через PlayerData (в данном include - через глобальную переменную)
    // Сохраняем временно индекс выбранной игры в g_NpcDialogSelection[playerid]
    g_ZimaSelected[playerid] = gameid;
    return 1;
}

// Временное хранение выбора игрока
new g_ZimaSelected[MAX_PLAYERS+1];

// Выдать бонус игроку
stock GiveZimaBonus(playerid, gameid)
{
    if (gameid < 0 || gameid > 2) return 0;
    if (g_ZimaBonusGiven[playerid][gameid]) {
        SendClientMessage(playerid, 0xFFFF66FF, "Вы уже получили бонус для этой игры.");
        return 0;
    }

    // Донат — вызовите вашу реальную функцию тут
    GiveDonat(playerid, g_ZimaDonat[gameid]);

    // Рубли — используем GivePlayerMoney как пример
    GivePlayerMoney(playerid, g_ZimaRubles[gameid]);

    // Аксессуар — вызовите реальную реализацию (инвентарь/вещь)
    GiveAccessory(playerid, g_ZimaAccessory[gameid]);

    format(new buf[128], sizeof(buf), "Вы получили бонус: Донат %d, Рубли %d, Аксессуар: %s",
        g_ZimaDonat[gameid], g_ZimaRubles[gameid], g_ZimaAccessory[gameid]);
    SendClientMessage(playerid, 0x00FF00FF, buf);

    g_ZimaBonusGiven[playerid][gameid] = true;
    return 1;
}

// Заглушки. Подключите свои реализации выдачи доната/аксессуаров
stock GiveDonat(playerid, amount)
{
    // Пример: если у вас есть функция AddDonatorPoints(playerid, amount) — вызовите её.
    // Здесь просто сообщение.
    new msg[64]; format(msg, sizeof(msg), "Добавлено доната: %d", amount);
    SendClientMessage(playerid, 0xFFFFAA00, msg);
    return 1;
}

stock GiveAccessory(playerid, const accessory[])
{
    // Реализуйте добавление аксессуара в инвентарь игрока.
    new msg[96]; format(msg, sizeof(msg), "Вы получили аксессуар: %s", accessory);
    SendClientMessage(playerid, 0xFFEEDD00, msg);
    return 1;
}

// Hook: команды игроков
public OnPlayerCommandText(playerid, const cmdtext[])
{
    if (cmdtext[0] != '/') return 0;
    new cmd[64];
    gettok(cmdtext, cmd, sizeof(cmd), 0, " "); // получаем токен с '/'
    if (cmd[0] == '/') {
        if (!stricmp(cmd+1, "zimainvent") || !stricmp(cmd+1, "ZimaInvent")) {
            OpenZimaMenu(playerid);
            return 1;
        }
    }
    return 0;
}

// Обработка ответов диалога
public OnPlayerDialogResponse(playerid, dialogid, response, listitem, const inputtext[])
{
    if (dialogid == DIALOG_ZIMA_MAIN) {
        if (response == 1) { // Выбрал пункт
            // listitem - выбранный элемент (1..n)
            new sel = listitem - 1; // сделать 0-based
            if (sel >=0 && sel <=2) ShowZimaInfo(playerid, sel);
        }
        return 1;
    }
    else if (dialogid == DIALOG_ZIMA_INFO) {
        if (response == 1) { // Получить бонус
            GiveZimaBonus(playerid, g_ZimaSelected[playerid]);
        }
        return 1;
    }
    return 0;
}

#endif // __ZIMA_EVENT_INC
