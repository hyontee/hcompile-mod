
/*
    BR Blackjack 2025 — SINGLE FILE (Pawn 3.2.3664)
    ------------------------------------------------
    • /blackjack — открыть игровое окно (или подойти к столу).
    • Минимум внешних зависимостей: только <a_samp>.
    • Полные правила: 6 колод, S17 (дилер стоит на soft 17),
      блэкджек 3:2, страховка 2:1, сдача (late surrender),
      дабл на любые 2 карты, сплит до 3 раз, тузам при сплите по 1 карте.
    • Деньги — стандартные деньги SA:MP (GivePlayerMoney).
    • GUI: диалоги (встроено) + опционально CEF (HTML/JS) — см. README.
*/

#include <a_samp>

#define BJ_VERSION              "1.0.0"
#define BJ_MAX_PLAYERS          MAX_PLAYERS
#define BJ_MAX_HANDS            (4)
#define BJ_MAX_CARDS_IN_HAND    (12)
#define BJ_NUM_DECKS            (6)
#define BJ_SHOE_SIZE            (BJ_NUM_DECKS*52)
#define BJ_MIN_BET              (100)
#define BJ_MAX_BET              (1000000)
#define BJ_SURRENDER_ALLOW      (1)
#define BJ_SOFT17_STAND         (1)     // дилер стоит на soft 17
#define BJ_ALLOW_CMD_OPEN       (1)

// Координаты стола (пример: Four Dragons Casino). Подправь под свою карту.
#define BJ_TABLE_X              (2019.210)
#define BJ_TABLE_Y              (1007.571)
#define BJ_TABLE_Z              (10.820)
#define BJ_TABLE_INT            (10)
#define BJ_TABLE_VW             (0)
#define BJ_TABLE_RADIUS         (2.8)

// --- Диалоги
#define BJ_DLG_BET              (14000)
#define BJ_DLG_ACTION           (14001)
#define BJ_DLG_CUSTOMBET        (14002)
#define BJ_DLG_INSURANCE        (14003)
#define BJ_DLG_SPLIT            (14004)

// --- Состояния
#define BJ_STATE_NONE           (0)
#define BJ_STATE_BETTING        (1)
#define BJ_STATE_PLAYER_TURN    (2)
#define BJ_STATE_DEALER_TURN    (3)
#define BJ_STATE_RESOLVE        (4)

// --- Данные игрока
new BJ_State[BJ_MAX_PLAYERS];
new BJ_Bet[BJ_MAX_PLAYERS];
new BJ_NumHands[BJ_MAX_PLAYERS];
new BJ_ActiveHand[BJ_MAX_PLAYERS];
new BJ_PlayerCards[BJ_MAX_PLAYERS][BJ_MAX_HANDS][BJ_MAX_CARDS_IN_HAND];
new BJ_PlayerCount[BJ_MAX_PLAYERS][BJ_MAX_HANDS];
new bool:BJ_PlayerDoubled[BJ_MAX_PLAYERS][BJ_MAX_HANDS];
new bool:BJ_PlayerSurrender[BJ_MAX_PLAYERS][BJ_MAX_HANDS];
new bool:BJ_PlayerBlackjack[BJ_MAX_PLAYERS][BJ_MAX_HANDS];
new BJ_DealerCards[BJ_MAX_PLAYERS][BJ_MAX_CARDS_IN_HAND];
new BJ_DealerCount[BJ_MAX_PLAYERS];
new BJ_InsuranceState[BJ_MAX_PLAYERS]; // 0 - нет, 1 - предложена, 2 - куплена
new BJ_LastActionTick[BJ_MAX_PLAYERS]; // анти-AFK

// --- Колода (shoe)
new BJ_Shoe[BJ_SHOE_SIZE];
new BJ_ShoePos;

// --- Утилиты
stock BJ_Rank(card) { return ((card-1) % 13) + 1; } // 1..13 (Ace=1, 10,J,Q,K=10)
stock BJ_Suit(card) { return ((card-1) / 13); }     // 0..3 (♠♥♦♣ неважно)
stock BJ_Value(rank)
{
    if (rank >= 10) return 10;
    if (rank == 1) return 11; // Ace как 11, потом скорректируем
    return rank;
}

stock BJ_Shuffle()
{
    // заполнить shoe повторениями 1..52
    for (new d=0; d<BJ_NUM_DECKS; d++)
        for (new c=1; c<=52; c++)
            BJ_Shoe[d*52 + (c-1)] = c;

    // Fisher-Yates
    for (new i=BJ_SHOE_SIZE-1; i>0; i--)
    {
        new j = random(i+1);
        new t = BJ_Shoe[i];
        BJ_Shoe[i] = BJ_Shoe[j];
        BJ_Shoe[j] = t;
    }
    BJ_ShoePos = 0;
}

stock BJ_DrawCard()
{
    if (BJ_ShoePos >= BJ_SHOE_SIZE - 52) BJ_Shuffle(); // перетасовать при конце
    return BJ_Shoe[BJ_ShoePos++];
}

stock BJ_ResetPlayer(playerid)
{
    BJ_State[playerid] = BJ_STATE_NONE;
    BJ_Bet[playerid] = 0;
    BJ_NumHands[playerid] = 0;
    BJ_ActiveHand[playerid] = 0;
    BJ_InsuranceState[playerid] = 0;
    for (new h=0; h<BJ_MAX_HANDS; h++)
    {
        BJ_PlayerCount[playerid][h] = 0;
        BJ_PlayerDoubled[playerid][h] = false;
        BJ_PlayerSurrender[playerid][h] = false;
        BJ_PlayerBlackjack[playerid][h] = false;
        for (new i=0; i<BJ_MAX_CARDS_IN_HAND; i++)
            BJ_PlayerCards[playerid][h][i] = 0;
    }
    BJ_DealerCount[playerid] = 0;
    for (new i=0; i<BJ_MAX_CARDS_IN_HAND; i++)
        BJ_DealerCards[playerid][i] = 0;
}

// Счёт руки (обрабатываем тузы)
stock BJ_HandScore(const cards[], count, &soft17=0, &isBlackjack=0)
{
    new total = 0;
    new aces = 0;
    for (new i=0;i<count;i++)
    {
        new rank = BJ_Rank(cards[i]);
        if (rank == 1) aces++;
        total += (rank >= 10) ? 10 : (rank==1?11:rank);
    }
    while (total > 21 && aces > 0)
    {
        total -= 10; // один туз превращаем из 11 в 1
        aces--;
    }
    soft17 = (total == 17 && aces > 0); // если есть мягкий
    isBlackjack = (count == 2 && total == 21);
    return total;
}

stock BJ_HandScoreForPlayer(playerid, hand, &soft=0, &isBJ=0)
{
    return BJ_HandScore(BJ_PlayerCards[playerid][hand], BJ_PlayerCount[playerid][hand], soft, isBJ);
}
stock BJ_DealerScoreForPlayer(playerid, &soft=0, &isBJ=0)
{
    return BJ_HandScore(BJ_DealerCards[playerid], BJ_DealerCount[playerid], soft, isBJ);
}

stock BJ_CanSplit(playerid, hand)
{
    if (BJ_PlayerCount[playerid][hand] != 2) return 0;
    new c1 = BJ_PlayerCards[playerid][hand][0];
    new c2 = BJ_PlayerCards[playerid][hand][1];
    return BJ_Rank(c1) == BJ_Rank(c2);
}

stock BJ_AddCardToHand(playerid, hand, card)
{
    new c = BJ_PlayerCount[playerid][hand];
    if (c < BJ_MAX_CARDS_IN_HAND) {
        BJ_PlayerCards[playerid][hand][c] = card;
        BJ_PlayerCount[playerid][hand]++;
    }
}

stock BJ_AddCardDealer(playerid, card)
{
    new c = BJ_DealerCount[playerid];
    if (c < BJ_MAX_CARDS_IN_HAND) {
        BJ_DealerCards[playerid][c] = card;
        BJ_DealerCount[playerid]++;
    }
}

stock BJ_StartRound(playerid)
{
    if (GetPlayerMoney(playerid) < BJ_Bet[playerid]) return 0;
    GivePlayerMoney(playerid, -BJ_Bet[playerid]);

    BJ_State[playerid] = BJ_STATE_PLAYER_TURN;
    BJ_NumHands[playerid] = 1;
    BJ_ActiveHand[playerid] = 0;
    BJ_InsuranceState[playerid] = 0;
    for (new h=0; h<BJ_MAX_HANDS; h++) { BJ_PlayerDoubled[playerid][h]=false; BJ_PlayerSurrender[playerid][h]=false; BJ_PlayerBlackjack[playerid][h]=false; }

    BJ_PlayerCount[playerid][0] = 0;
    BJ_DealerCount[playerid] = 0;

    // Раздача: игрок, дилер (скрытая), игрок, дилер (открытая)
    BJ_AddCardToHand(playerid, 0, BJ_DrawCard());
    BJ_AddCardDealer(playerid, BJ_DrawCard());
    BJ_AddCardToHand(playerid, 0, BJ_DrawCard());
    BJ_AddCardDealer(playerid, BJ_DrawCard());

    new soft, isbj;
    new score = BJ_HandScoreForPlayer(playerid, 0, soft, isbj);
    BJ_PlayerBlackjack[playerid][0] = (isbj==1);

    // Предложить страховку если у дилера туз сверху
    new dealerUp = BJ_DealerCards[playerid][1];
    if (BJ_Rank(dealerUp) == 1 && GetPlayerMoney(playerid) >= BJ_Bet[playerid]/2) {
        BJ_InsuranceState[playerid] = 1; // предложена
    }

    BJ_LastActionTick[playerid] = GetTickCount();
    return 1;
}

stock BJ_PlayerBust(playerid, hand)
{
    new s, bj;
    s = BJ_HandScoreForPlayer(playerid, hand, s, bj);
    return s > 21;
}

stock BJ_PushMoney(playerid, amount) { GivePlayerMoney(playerid, amount); }
stock BJ_PayWin(playerid, amount)    { GivePlayerMoney(playerid, amount); }
stock BJ_TakeMoney(playerid, amount) { /* уже списано в начале раунда */ }

// --- Дилер играет по правилам
stock BJ_DealerPlay(playerid)
{
    new soft, bj;
    new score = BJ_DealerScoreForPlayer(playerid, soft, bj);
    // Дилер открывает скрытую карту, затем тянет до 17 (включая S17)
    while (true)
    {
        soft = 0; bj = 0;
        score = BJ_DealerScoreForPlayer(playerid, soft, bj);
        if (score > 21) break;
        if (score > 17) break;
        if (score == 17) {
            #if BJ_SOFT17_STAND
                // при soft 17 стоим (если мягкий 17):
                new soft2;
                BJ_DealerScoreForPlayer(playerid, soft2, bj);
                if (soft2) break;
            #endif
        }
        BJ_AddCardDealer(playerid, BJ_DrawCard());
    }
}

// --- Выплаты
stock BJ_Settle(playerid)
{
    // если была страховка и у дилера блэкджек — платим 2:1
    new soft, dbj;
    new dealerBJ;
    BJ_DealerScoreForPlayer(playerid, soft, dealerBJ);
    if (dealerBJ && BJ_InsuranceState[playerid] == 2) {
        BJ_PayWin(playerid, BJ_Bet[playerid]); // страховка = половина ставки * 2 = ставка
    }

    for (new h=0; h<BJ_NumHands[playerid]; h++)
    {
        new ps_soft, ps_bj;
        new ds_soft, ds_bj;
        new pscore = BJ_HandScoreForPlayer(playerid, h, ps_soft, ps_bj);
        new dscore = BJ_DealerScoreForPlayer(playerid, ds_soft, ds_bj);

        new base = BJ_Bet[playerid];
        if (BJ_PlayerDoubled[playerid][h]) base *= 2;

        if (BJ_PlayerSurrender[playerid][h])
        {
            BJ_PushMoney(playerid, base/2); // половина возвращается при сдаче
            continue;
        }

        if (ps_bj && !ds_bj) { // чёрный джек 3:2
            BJ_PayWin(playerid, base + (base*3)/2);
            continue;
        }
        if (ds_bj && !ps_bj)
        {
            // игрок проиграл (ставка уже списана)
            continue;
        }

        if (pscore > 21) { continue; } // bust проигрыш
        if (dscore > 21) { BJ_PayWin(playerid, base*2); continue; }

        if (pscore > dscore) BJ_PayWin(playerid, base*2);
        else if (pscore == dscore) BJ_PushMoney(playerid, base);
        // иначе проигрыш
    }
}

// --- Рендер в текст диалога (ASCII "карточки")
stock BJ_CardText(card, out[], len)
{
    static const suits[4][] = { "♠", "♥", "♦", "♣" };
    new r = BJ_Rank(card), s = BJ_Suit(card);
    new sym[4];
    if (r == 1)      format(sym, sizeof sym, "A");
    else if (r == 11)format(sym, sizeof sym, "J");
    else if (r == 12)format(sym, sizeof sym, "Q");
    else if (r == 13)format(sym, sizeof sym, "K");
    else             format(sym, sizeof sym, "%d", r);
    format(out, len, "%s%s", sym, suits[s]);
}

stock BJ_RenderDialog(playerid, buffer[], buflen, bool:hideDealerHole)
{
    new line[256];
    buffer[0] = '\0';

    format(line, sizeof line, "{FFFFFF}BR Blackjack {AAAAAA}v%s\n", BJ_VERSION);
    strcat(buffer, line);

    // Дилер
    strcat(buffer, "{F6D85B}Дилер:{FFFFFF} ");
    for (new i=0;i<BJ_DealerCount[playerid];i++)
    {
        if (i==0 && hideDealerHole) { strcat(buffer, "[??] "); continue; }
        new ct[16]; BJ_CardText(BJ_DealerCards[playerid][i], ct, sizeof ct);
        format(line, sizeof line, "[%s] ", ct); strcat(buffer, line);
    }
    new ds, dsoft, dbj;
    ds = BJ_DealerScoreForPlayer(playerid, dsoft, dbj);
    if (!hideDealerHole) { format(line, sizeof line, "  = {F6D85B}%d\n", ds); strcat(buffer, line); }
    else strcat(buffer, "\n");

    // Игрок
    for (new h=0; h<BJ_NumHands[playerid]; h++)
    {
        format(line, sizeof line, "{9CD0FF}Рука %d%s:{FFFFFF} ", h+1, (h==BJ_ActiveHand[playerid])?" {88FF88}[ХОД]":"");
        strcat(buffer, line);
        for (new i=0;i<BJ_PlayerCount[playerid][h];i++)
        {
            new ct[16]; BJ_CardText(BJ_PlayerCards[playerid][h][i], ct, sizeof ct);
            format(line, sizeof line, "[%s] ", ct); strcat(buffer, line);
        }
        new ps, psoft, pbj;
        ps = BJ_HandScoreForPlayer(playerid, h, psoft, pbj);
        format(line, sizeof line, " = {9CD0FF}%d%s%s\n", ps, (psoft?" (soft)":"") , (BJ_PlayerDoubled[playerid][h]?" x2":""));
        strcat(buffer, line);
    }

    strcat(buffer, "\n");
    format(line, sizeof line, "{AAAAAA}Ставка: {FFFFFF}%d$  {AAAAAA}Баланс: {FFFFFF}%d$\n", BJ_Bet[playerid], GetPlayerMoney(playerid));
    strcat(buffer, line);

    strcat(buffer, "{DDDDDD}Кнопки:\n{FFFFFF}• Ход: Hit • Стоп: Stand • Дабл: Double • Сплит: Split • Сдаться: Surrender • Страховка: Insurance\n");
}

// --- Диалоги
stock BJ_ShowAction(playerid)
{
    new text[1024]; BJ_RenderDialog(playerid, text, sizeof text, true);
    ShowPlayerDialog(playerid, BJ_DLG_ACTION, DIALOG_STYLE_MSGBOX, "Blackjack — ваш ход",
        text, "Меню", "Выйти");
}

stock BJ_ShowBetDialog(playerid)
{
    new s[256];
    format(s, sizeof s,
        "Ставка\tСумма\n\
        Минимальная\t%d\n\
        1 000\t1000\n\
        5 000\t5000\n\
        10 000\t10000\n\
        50 000\t50000\n\
        100 000\t100000\n\
        Своя...\t-1", BJ_MIN_BET);
    ShowPlayerDialog(playerid, BJ_DLG_BET, DIALOG_STYLE_TABLIST_HEADERS, "Blackjack — ставка", s, "Выбрать", "Отмена");
}

stock BJ_ShowInsurance(playerid)
{
    new msg[256]; format(msg, sizeof msg, "У дилера {F6D85B}Туз{FFFFFF}. Взять страховку за {9CD0FF}%d${FFFFFF}? (выплачивается 2:1 при блэкджеке дилера)",
        BJ_Bet[playerid]/2);
    ShowPlayerDialog(playerid, BJ_DLG_INSURANCE, DIALOG_STYLE_MSGBOX, "Страховка", msg, "Взять", "Пропустить");
}

stock BJ_EndRoundAndSettle(playerid)
{
    BJ_DealerPlay(playerid);
    BJ_Settle(playerid);

    new text[1024]; BJ_RenderDialog(playerid, text, sizeof text, false);
    ShowPlayerDialog(playerid, BJ_DLG_ACTION, DIALOG_STYLE_MSGBOX, "Blackjack — результат", text, "Ок", "");
    BJ_ResetPlayer(playerid);
}

forward BJ_OnIdleTick(playerid);
public BJ_OnIdleTick(playerid)
{
    if (BJ_State[playerid] != BJ_STATE_PLAYER_TURN) return 1;
    if (GetTickCount() - BJ_LastActionTick[playerid] > 60000) // 60 сек бездействия
    {
        BJ_ActiveHand[playerid] = BJ_NumHands[playerid]-1;
        // стоим на всех оставшихся руках
        BJ_EndRoundAndSettle(playerid);
    }
    return 1;
}

// --- Основные действия игрока
stock BJ_DoHit(playerid)
{
    new h = BJ_ActiveHand[playerid];
    BJ_AddCardToHand(playerid, h, BJ_DrawCard());
    BJ_LastActionTick[playerid] = GetTickCount();

    if (BJ_PlayerBust(playerid, h)) {
        // если это не последняя рука — перейти к следующей
        if (h < BJ_NumHands[playerid]-1) {
            BJ_ActiveHand[playerid]++;
            BJ_ShowAction(playerid);
        } else {
            BJ_EndRoundAndSettle(playerid);
        }
        return 1;
    }
    BJ_ShowAction(playerid);
    return 1;
}

stock BJ_DoStand(playerid)
{
    if (BJ_ActiveHand[playerid] < BJ_NumHands[playerid]-1) {
        BJ_ActiveHand[playerid]++;
        BJ_ShowAction(playerid);
        return 1;
    }
    BJ_EndRoundAndSettle(playerid);
    return 1;
}

stock BJ_DoDouble(playerid)
{
    new h = BJ_ActiveHand[playerid];
    if (BJ_PlayerCount[playerid][h] != 2) { SendClientMessage(playerid, -1, "Дабл доступен только на 2 карты."); return 1; }
    if (GetPlayerMoney(playerid) < BJ_Bet[playerid]) { SendClientMessage(playerid, -1, "Недостаточно денег для удвоения."); return 1; }

    GivePlayerMoney(playerid, -BJ_Bet[playerid]);
    BJ_PlayerDoubled[playerid][h] = true;
    BJ_AddCardToHand(playerid, h, BJ_DrawCard());
    if (BJ_ActiveHand[playerid] < BJ_NumHands[playerid]-1) BJ_ActiveHand[playerid]++;
    else { BJ_EndRoundAndSettle(playerid); return 1; }
    BJ_ShowAction(playerid);
    return 1;
}

stock BJ_DoSurrender(playerid)
{
    if (!BJ_SURRENDER_ALLOW) return 1;
    new h = BJ_ActiveHand[playerid];
    if (BJ_PlayerCount[playerid][h] != 2) { SendClientMessage(playerid, -1, "Сдача доступна только на первых двух картах."); return 1; }
    BJ_PlayerSurrender[playerid][h] = true;
    if (BJ_ActiveHand[playerid] < BJ_NumHands[playerid]-1) BJ_ActiveHand[playerid]++;
    else { BJ_EndRoundAndSettle(playerid); return 1; }
    BJ_ShowAction(playerid);
    return 1;
}

stock BJ_DoSplit(playerid)
{
    new h = BJ_ActiveHand[playerid];
    if (!BJ_CanSplit(playerid, h)) { SendClientMessage(playerid, -1, "Нельзя сплитовать эту руку."); return 1; }
    if (BJ_NumHands[playerid] >= BJ_MAX_HANDS) { SendClientMessage(playerid, -1, "Максимум сплитов достигнут."); return 1; }
    if (GetPlayerMoney(playerid) < BJ_Bet[playerid]) { SendClientMessage(playerid, -1, "Недостаточно денег для сплита."); return 1; }

    GivePlayerMoney(playerid, -BJ_Bet[playerid]); // новая ставка для новой руки

    // Разделяем карты: [a,b] -> рука h = [a], рука new = [b]
    new newhand = BJ_NumHands[playerid];
    BJ_NumHands[playerid]++;

    new a = BJ_PlayerCards[playerid][h][0];
    new b = BJ_PlayerCards[playerid][h][1];
    BJ_PlayerCount[playerid][h] = 1;
    BJ_PlayerCards[playerid][h][0] = a;
    BJ_PlayerCards[playerid][h][1] = 0;

    BJ_PlayerCount[playerid][newhand] = 1;
    BJ_PlayerCards[playerid][newhand][0] = b;

    // Каждой руке добираем по карте
    BJ_AddCardToHand(playerid, h, BJ_DrawCard());
    BJ_AddCardToHand(playerid, newhand, BJ_DrawCard());

    // Спец-правило для тузов: по 1 карте и стоп
    if (BJ_Rank(a)==1) {
        // текущая рука остановлена, идем на следующую
        if (BJ_ActiveHand[playerid] < BJ_NumHands[playerid]-1) BJ_ActiveHand[playerid]++;
    }

    BJ_ShowAction(playerid);
    return 1;
}

// --- Точка входа ---
public OnFilterScriptInit()
{
    print("[Blackjack] Инициализация...");
    BJ_Shuffle();
    print("[Blackjack] Готово.");
    return 1;
}

public OnFilterScriptExit()
{
    print("[Blackjack] Выключение.");
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (!strcmp(cmdtext, "/blackjack", true))
    {
        #if BJ_ALLOW_CMD_OPEN
            BJ_ShowBetDialog(playerid);
            BJ_State[playerid] = BJ_STATE_BETTING;
        #else
            SendClientMessage(playerid, -1, "Подойдите к столу в казино.");
        #endif
        return 1;
    }
    if (!strcmp(cmdtext, "/hit", true))      { if (BJ_State[playerid]==BJ_STATE_PLAYER_TURN) BJ_DoHit(playerid); return 1; }
    if (!strcmp(cmdtext, "/stand", true))    { if (BJ_State[playerid]==BJ_STATE_PLAYER_TURN) BJ_DoStand(playerid); return 1; }
    if (!strcmp(cmdtext, "/double", true))   { if (BJ_State[playerid]==BJ_STATE_PLAYER_TURN) BJ_DoDouble(playerid); return 1; }
    if (!strcmp(cmdtext, "/split", true))    { if (BJ_State[playerid]==BJ_STATE_PLAYER_TURN) BJ_DoSplit(playerid); return 1; }
    if (!strcmp(cmdtext, "/surrender", true)){ if (BJ_State[playerid]==BJ_STATE_PLAYER_TURN) BJ_DoSurrender(playerid); return 1; }
    return 0;
}

public OnPlayerUpdate(playerid)
{
    // Авто-предложение если рядом со столом
    if (BJ_State[playerid] == BJ_STATE_NONE)
    {
        if (IsPlayerInRangeOfPoint(playerid, BJ_TABLE_RADIUS, BJ_TABLE_X, BJ_TABLE_Y, BJ_TABLE_Z))
        {
            if (GetPlayerInterior(playerid) == BJ_TABLE_INT && GetPlayerVirtualWorld(playerid) == BJ_TABLE_VW)
            {
                GameTextForPlayer(playerid, "~y~BLACKJACK~n~~w~Нажмите /blackjack", 1100, 3);
            }
        }
    }
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    // Безопасно сбросить
    BJ_ResetPlayer(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch (dialogid)
    {
        case BJ_DLG_BET:
        {
            if (!response) { BJ_ResetPlayer(playerid); return 1; }
            new bet;
            switch (listitem)
            {
                case 0: bet = BJ_MIN_BET;
                case 1: bet = 1000;
                case 2: bet = 5000;
                case 3: bet = 10000;
                case 4: bet = 50000;
                case 5: bet = 100000;
                case 6: { ShowPlayerDialog(playerid, BJ_DLG_CUSTOMBET, DIALOG_STYLE_INPUT, "Своя ставка", "Введите сумму ставки:", "OK", "Назад"); return 1; }
            }
            if (bet < BJ_MIN_BET || bet > BJ_MAX_BET) { SendClientMessage(playerid, -1, "Неверная ставка."); return 1; }
            if (GetPlayerMoney(playerid) < bet) { SendClientMessage(playerid, -1, "Недостаточно денег."); return 1; }
            BJ_Bet[playerid] = bet;
            if (!BJ_StartRound(playerid)) { SendClientMessage(playerid, -1, "Не удалось начать раунд."); return 1; }

            if (BJ_InsuranceState[playerid] == 1) BJ_ShowInsurance(playerid);
            else BJ_ShowAction(playerid);
            return 1;
        }
        case BJ_DLG_CUSTOMBET:
        {
            if (!response) { BJ_ShowBetDialog(playerid); return 1; }
            new bet = strval(inputtext);
            if (bet < BJ_MIN_BET || bet > BJ_MAX_BET) { SendClientMessage(playerid, -1, "Неверная ставка."); BJ_ShowBetDialog(playerid); return 1; }
            if (GetPlayerMoney(playerid) < bet) { SendClientMessage(playerid, -1, "Недостаточно денег."); BJ_ShowBetDialog(playerid); return 1; }
            BJ_Bet[playerid] = bet;
            if (!BJ_StartRound(playerid)) { SendClientMessage(playerid, -1, "Не удалось начать раунд."); return 1; }

            if (BJ_InsuranceState[playerid] == 1) BJ_ShowInsurance(playerid);
            else BJ_ShowAction(playerid);
            return 1;
        }
        case BJ_DLG_INSURANCE:
        {
            if (response)
            {
                // купить страховку за половину ставки
                if (GetPlayerMoney(playerid) >= BJ_Bet[playerid]/2) {
                    GivePlayerMoney(playerid, -BJ_Bet[playerid]/2);
                    BJ_InsuranceState[playerid] = 2;
                    SendClientMessage(playerid, -1, "Страховка куплена.");
                } else SendClientMessage(playerid, -1, "Недостаточно денег для страховки.");
            }
            BJ_ShowAction(playerid);
            return 1;
        }
        case BJ_DLG_ACTION:
        {
            // Нажата кнопка "Меню" — покажем список действий
            if (!response) { BJ_ResetPlayer(playerid); return 1; }

            new actions[512];
            format(actions, sizeof actions,
                "Действие\tОписание\nHit\tВзять карту\nStand\tОстановиться\nDouble\tУдвоить, взять 1 карту\nSplit\tРазделить (если пара)\nSurrender\tСдаться (половина ставки)\nInsurance\tСтраховка (если предложена)");
            ShowPlayerDialog(playerid, BJ_DLG_ACTION+100, DIALOG_STYLE_TABLIST_HEADERS, "Выберите действие", actions, "OK", "Назад");
            return 1;
        }
        case BJ_DLG_ACTION+100:
        {
            if (!response) { BJ_ShowAction(playerid); return 1; }
            switch (listitem)
            {
                case 0: BJ_DoHit(playerid);
                case 1: BJ_DoStand(playerid);
                case 2: BJ_DoDouble(playerid);
                case 3: BJ_DoSplit(playerid);
                case 4: BJ_DoSurrender(playerid);
                case 5: if (BJ_InsuranceState[playerid] == 1) ShowPlayerDialog(playerid, BJ_DLG_INSURANCE, DIALOG_STYLE_MSGBOX, "Страховка", "Взять страховку?", "Взять", "Назад"); else BJ_ShowAction(playerid);
            }
            return 1;
        }
    }
    return 0;
}
