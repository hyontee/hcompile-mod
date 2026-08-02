#include <a_samp>

#define DIALOG_BLACKJACK 2025
#define MIN_BET 10

// Структура для хранения состояния игры игрока
new gPlayerBlackjack[MAX_PLAYERS][4]; // [деньги, ставка, очки игрока, очки дилера]

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp(cmdtext, "/blackjack", true) == 0)
    {
        new string[128];
        format(string, sizeof(string), "Ваш баланс: $%d\n\nВведите сумму ставки:", GetPlayerMoney(playerid));
        ShowPlayerDialog(playerid, DIALOG_BLACKJACK, DIALOG_STYLE_INPUT, "Blackjack - Ставка", string, "Играть", "Выход");
        return 1;
    }
    else if (strcmp(cmdtext, "/hit", true) == 0)
    {
        HitCard(playerid);
        return 1;
    }
    else if (strcmp(cmdtext, "/stand", true) == 0)
    {
        Stand(playerid);
        return 1;
    }
    return 0;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if (dialogid == DIALOG_BLACKJACK)
    {
        if (!response) return SendClientMessage(playerid, -1, "Игра отменена.");

        new bet = strval(inputtext);
        new money = GetPlayerMoney(playerid);

        // Проверка корректности ввода
        if (bet <= 0) return SendClientMessage(playerid, -1, "Введите корректную сумму ставки.");
        if (bet < MIN_BET) return SendClientMessage(playerid, -1, "Минимальная ставка: $10");
        if (bet > money) return SendClientMessage(playerid, -1, "Недостаточно денег");

        // Начало игры
        GivePlayerMoney(playerid, -bet);
        gPlayerBlackjack[playerid][0] = money - bet; // Сохраняем текущий баланс
        gPlayerBlackjack[playerid][1] = bet;     // Сохраняем ставку
        gPlayerBlackjack[playerid][2] = 0;       // Очки игрока
        gPlayerBlackjack[playerid][3] = 0;       // Очки дилера

        StartBlackjackGame(playerid);
        return 1;
    }
    return 0;
}

// Функция начала игры
StartBlackjackGame(playerid)
{
    new playerCard1 = GetRandomCard();
    new playerCard2 = GetRandomCard();
    new dealerCard1 = GetRandomCard();
    new dealerCard2 = GetRandomCard();

    // Подсчёт очков
    gPlayerBlackjack[playerid][2] = CalculatePoints(playerCard1, playerCard2);
    gPlayerBlackjack[playerid][3] = CalculatePoints(dealerCard1, dealerCard2);

    new string[256];
    format(string, sizeof(string),
        "Вы сделали ставку $%d. Игра началась!\n"
        "Ваши карты: %s и %s = %d\n"
        "Карты дилера: %s и ??\n"
        "Введите /hit - взять карту, /stand - остановиться",
        gPlayerBlackjack[playerid][1],
        CardToString(playerCard1), CardToString(playerCard2), gPlayerBlackjack[playerid][2],
        CardToString(dealerCard1)
    );
    SendClientMessage(playerid, -1, string);
}

// Получение случайной карты (1–11, где 11 — туз)
GetRandomCard()
{
    return random(10) + 1; // Упрощённый вариант
}

// Преобразование карты в строку
CardToString(card)
{
    switch (card)
    {
        case 1: return "Туз";
        case 11: return "Валет";
        case 12: return "Дама";
        case 13: return "Король";
        default: return card;
    }
}

// Подсчёт очков с учётом туза
CalculatePoints(card1, card2)
{
    new points = card1 + card2;
    // Упрощённая логика для примера
    if (points > 21 && (card1 == 11 || card2 == 11))
        points -= 10; // Туз считается за 1 вместо 11
    return points;
}

// Взятие карты
HitCard(playerid)
{
    if (gPlayerBlackjack[playerid][2] == 0) return; // Игра не начата

    new newCard = GetRandomCard();
    gPlayerBlackjack[playerid][2] += newCard;

    if (gPlayerBlackjack[playerid][2] > 21)
    {
        SendClientMessage(playerid, -1, "Перебор! Вы проиграли.");
        EndBlackjackGame(playerid, false);
    }
    else
    {
        new string[128];
        format(string, sizeof(string), "Вы взяли карту: %s. Ваши очки: %d", CardToString(newCard), gPlayerBlackjack[playerid][2]);
        SendClientMessage(playerid, -1, string);
    }
}

// Остановка
Stand(playerid)
{
    if (gPlayerBlackjack[playerid][2] == 0) return; // Игра не начата

    // Ход дилера (упрощённый)
    while (gPlayerBlackjack[playerid][3] < 17)
    {
        gPlayerBlackjack[playerid][3] += GetRandomCard();
    }

    DetermineWinner(playerid);
}

// Определение победителя
DetermineWinner(playerid)
{
    new playerPoints = gPlayerBlackjack[playerid][2];
    new dealerPoints = gPlayerBlackjack[playerid][3];
    new bet = gPlayerBlackjack[playerid][1];

    new string[256];
    if (dealerPoints > 21 || playerPoints > dealerPoints)
    {
        new winAmount = bet * 2;
        GivePlayerMoney(playerid, winAmount);
        format(string, sizeof(string), "Вы выиграли! Дилер набрал %d очков. Выигрыш: $%d", dealerPoints, winAmount);
    }
    else if (playerPoints == dealerPoints)
    {
        GivePlayerMoney(playerid, bet); // Возврат ставки
        format(string, sizeof(string), "Ничья! Дилер набрал %d очков. Ставка возвращена.", dealerPoints);
    }
    else
    {
        format(string, sizeof(string), "Вы проиграли! Дилер набрал %d очков.", dealerPoints);
    }

    SendClientMessage(playerid, -1, string);
    EndBlackjackGame(playerid, true);
}

// Завершение игры
EndBlackjackGame(playerid, bool:reset)
{
    if (reset)
    {
        gPlayerBlackjack[playerid][0] = 0;
        gPlayerBlackjack[playerid][1] = 0;
        gPlayerBlackjack[playerid][2] = 0;
        gPlayerBlackjack[playerid][3] = 0;
    }
}
