// =====================================================================
// [—ќ¬ћ≈—“»ћќ—“№] calendar.inc рассчитан на модуль "Battle Pass Reward"
// (BPR_*), которого нет в этой копии кодовой базы (в kirill.pwn найдена
// только одна закомментированна€ ссылка на BPR_LoadUserRewards).
//
// Ќиже Ч реальна€ реализаци€ через уже существующие в kirill.pwn функции:
//   - деньги (рубли)      -> GivePlayerMoneyEx (существует)
//   - донат-монеты (BC)   -> GivePlayerDonate   (существует)
//   - всЄ остальное (VIP, машина, кейсы, BP EXP, x2-бустер, аксессуар) Ч
//     готовой системы выдачи нет, поэтому игроку показываетс€ уведомление,
//     а в консоль/лог пишетс€ запись дл€ ручной выдачи администрацией.
//
// ≈сли позже подключите собственную систему кейсов/VIP/битвпасса Ч
// замените ветки default в BPR_GiveReward / BPR_GiveCase на реальные вызовы.
// =====================================================================

#if !defined _calendar_bpr_compat_included
#define _calendar_bpr_compat_included

#define BPR_TYPE_MONEY   (1)
#define BPR_TYPE_BC      (2)
#define BPR_TYPE_BP_EXP  (3)
#define BPR_TYPE_CAR     (4)
#define BPR_TYPE_EVENT   (5)
#define BPR_TYPE_VIP     (6)

stock BPR_NotifyManualReward(playerid, const description[])
{
    new msg[160];
    format(msg, sizeof msg, "{FFCD00}[ алендарь]:{FFFFFF} Ќаграда \"%s\" будет начислена администрацией вручную.", description);
    SendClientMessage(playerid, 0xFFCD00FF, msg);
    return 1;
}

// BPR_GiveCurrency(playerid, type, subtype, description[], amount, extra)
stock BPR_GiveCurrency(playerid, type, subtype, const description[], amount, extra)
{
    #pragma unused subtype, extra
    new descbuf[160];
    strcat(descbuf, description, sizeof descbuf);
    switch(type)
    {
        case BPR_TYPE_MONEY:
        {
            GivePlayerMoneyEx(playerid, amount, descbuf, true, true);
            return 1;
        }
        case BPR_TYPE_BC:
        {
            GivePlayerDonate(playerid, amount, descbuf, true);
            return 1;
        }
        default:
        {
            BPR_NotifyManualReward(playerid, description);
            printf("[CALENDAR REWARD][¬џƒј“№ ¬–”„Ќ”ё] playerid=%d type=%d amount=%d desc=%s", playerid, type, amount, description);
            return 1;
        }
    }
}

// BPR_GiveReward(playerid, type, itemid, description[], p5, p6, p7, p8, p9)
stock BPR_GiveReward(playerid, type, itemid, const description[], p5, p6, p7, p8, p9)
{
    #pragma unused p5, p6, p7, p8, p9
    BPR_NotifyManualReward(playerid, description);
    printf("[CALENDAR REWARD][¬џƒј“№ ¬–”„Ќ”ё] playerid=%d type=%d itemid=%d desc=%s", playerid, type, itemid, description);
    return 1;
}

// BPR_GiveCase(playerid, case_type, description[], count, multiplier)
stock BPR_GiveCase(playerid, case_type, const description[], count, multiplier)
{
    #pragma unused multiplier
    BPR_NotifyManualReward(playerid, description);
    printf("[CALENDAR REWARD][¬џƒј“№ ¬–”„Ќ”ё] playerid=%d case_type=%d count=%d desc=%s", playerid, case_type, count, description);
    return 1;
}

#endif
