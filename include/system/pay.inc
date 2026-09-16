#if defined _SYSTEM_PAY_INC
    #endinput
#endif
#define _SYSTEM_PAY_INC

#define DIALOG_PAY_ID         33000
#define DIALOG_PAY_AMOUNT     33001
#define DIALOG_PAY_CONFIRM    33002
#define DIALOG_PAY_ERROR      33003

static Pay_Target[MAX_PLAYERS];
static Pay_Amount[MAX_PLAYERS];

stock Pay_ShowIdDialog(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_PAY_ID, DIALOG_STYLE_INPUT,
        "Передача денег",
        "Введите ID игрока, которому хотите передать деньги:",
        "Далее", "Отмена");
    return 1;
}

stock Pay_ShowAmountDialog(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_PAY_AMOUNT, DIALOG_STYLE_INPUT,
        "Передача денег",
        "Введите сумму для передачи:\n\nМинимум: 1 руб.\nМаксимум: 25 000 руб.",
        "Далее", "Назад");
    return 1;
}

stock Pay_ShowError(playerid, text[])
{
    ShowPlayerDialog(playerid, DIALOG_PAY_ERROR, DIALOG_STYLE_MSGBOX,
        "Передача денег",
        text,
        "OK", "");
    return 1;
}

stock Pay_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused listitem

    if (dialogid == DIALOG_PAY_ID)
    {
        if (!response) return 1;

        if (!strlen(inputtext))
            return Pay_ShowError(playerid, "Введите ID игрока.");

        new target = strval(inputtext);

        if (target < 0 || target >= MAX_PLAYERS || !IsPlayerConnected(target) || !IsPlayerLogged(target))
            return Pay_ShowError(playerid, "Игрок с таким ID сейчас не в сети или не авторизован.");

        if (target == playerid)
            return Pay_ShowError(playerid, "Нельзя передать деньги самому себе.");

        if (!IsPlayerInRangeOfPlayer(playerid, target, 6.0))
            return Pay_ShowError(playerid, "Игрок должен находиться рядом с вами.");

        Pay_Target[playerid] = target;
        Pay_Amount[playerid] = 0;
        return Pay_ShowAmountDialog(playerid);
    }

    if (dialogid == DIALOG_PAY_AMOUNT)
    {
        if (!response)
            return Pay_ShowIdDialog(playerid);

        if (!strlen(inputtext))
            return Pay_ShowAmountDialog(playerid);

        new cash = strval(inputtext);
        new target = Pay_Target[playerid];

        if (cash < 1 || cash > 25000)
            return Pay_ShowError(playerid, "Сумма должна быть от 1 до 25 000 руб.");

        if (target < 0 || target >= MAX_PLAYERS || !IsPlayerConnected(target) || !IsPlayerLogged(target))
            return Pay_ShowError(playerid, "Игрок больше не в сети или не авторизован.");

        if (!IsPlayerInRangeOfPlayer(playerid, target, 6.0))
            return Pay_ShowError(playerid, "Игрок должен находиться рядом с вами.");

        if (GetPlayerMoneyEx(playerid) < cash)
            return Pay_ShowError(playerid, "У вас недостаточно денег.");

        Pay_Amount[playerid] = cash;

        new msg[192];
        new targetName[MAX_PLAYER_NAME];
        GetPlayerName(target, targetName, sizeof(targetName));
        format(msg, sizeof(msg), "Передать %d руб. игроку %s (ID: %d)?", cash, targetName, target);

        ShowPlayerDialog(playerid, DIALOG_PAY_CONFIRM, DIALOG_STYLE_MSGBOX,
            "Подтверждение перевода", msg, "Да", "Нет");
        return 1;
    }

    if (dialogid == DIALOG_PAY_CONFIRM)
    {
        if (!response)
            return Pay_ShowAmountDialog(playerid);

        new target = Pay_Target[playerid];
        new cash = Pay_Amount[playerid];

        if (target < 0 || target >= MAX_PLAYERS || !IsPlayerConnected(target) || !IsPlayerLogged(target))
            return Pay_ShowError(playerid, "Игрок больше не в сети или не авторизован.");

        if (!IsPlayerInRangeOfPlayer(playerid, target, 6.0))
            return Pay_ShowError(playerid, "Игрок должен находиться рядом с вами.");

        if (cash < 1 || cash > 25000 || GetPlayerMoneyEx(playerid) < cash)
            return Pay_ShowError(playerid, "Перевод невозможен: проверьте сумму и баланс.");

        new fmt_text[128];

        format(fmt_text, sizeof(fmt_text), "+%d руб.", cash);
        SetPlayerChatBubble(target, fmt_text, 0x00CC00FF, 10.0, 5000);

        format(fmt_text, sizeof(fmt_text), "-%d руб.", cash);
        SetPlayerChatBubble(playerid, fmt_text, 0xFF6600FF, 10.0, 5000);

        format(fmt_text, sizeof(fmt_text), "Передача денег игроку %s", GetPlayerNameEx(playerid));
        GivePlayerMoneyEx(playerid, -cash, fmt_text, true, true);

        format(fmt_text, sizeof(fmt_text), "Получение денег от игрока %s", GetPlayerNameEx(target));
        GivePlayerMoneyEx(target, cash, fmt_text, true, true);

        format(fmt_text, sizeof(fmt_text), "Вам передали %d руб. от игрока %s.", cash, GetPlayerNameEx(playerid));
        SendClientMessage(target, 0x3399FFFF, fmt_text);

        format(fmt_text, sizeof(fmt_text), "Вы передали %d руб. игроку %s.", cash, GetPlayerNameEx(target));
        SendClientMessage(playerid, 0x3399FFFF, fmt_text);


        Pay_Target[playerid] = -1;
        Pay_Amount[playerid] = 0;
        return 1;
    }

    if (dialogid == DIALOG_PAY_ERROR)
    {
        return Pay_ShowIdDialog(playerid);
    }

    return 0;
}

CMD:pay(playerid, params[])
{
    #pragma unused params

    if (!IsPlayerLogged(playerid))
        return SendClientMessage(playerid, 0x999999FF, "Сначала авторизуйтесь.");

    return Pay_ShowIdDialog(playerid);
}

