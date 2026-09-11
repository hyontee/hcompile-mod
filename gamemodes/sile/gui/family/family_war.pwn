// =====================================================================
//                       СИСТЕМА "ВОЙНА СЕМЕЙ"
// =====================================================================
// Подключается в kirill.pwn через:
//   #include "../gamemodes/kirill/gui/family/family_war.pwn"
// (сразу после family_addition.pwn)
//
// Требует уже существующих в проекте функций семейной системы:
// GetPlayerIdFamily, GetFamily, SetFamily, AddFamily, SendFamilyMessage,
// UpdateColumnFamilyInt, MAX_FAM — все они уже используются в
// family_addition.pwn, поэтому доступны и здесь.
// =====================================================================

// ---------- Координаты НПС ----------
#define FAMWAR_NPC_X        (-40.773406)
#define FAMWAR_NPC_Y        (1361.222900)
#define FAMWAR_NPC_Z        (12.919919)
#define FAMWAR_NPC_A        (254.003387)
#define FAMWAR_NPC_SKIN     (62)

// ---------- Точки телепорта команд ----------
new Float:FamWar_TeamPos[2][4] =
{
    {-105.191932, 1449.559692, 10.707960, 168.953796},
    {-110.483802, 1302.867431, 13.611247, 12.645094}
};

// ---------- Настройки ----------
#define FAMWAR_WEAPON_ID            24      // Desert Eagle
#define FAMWAR_WEAPON_AMMO          2500
#define FAMWAR_ARMOR                0.0     // СѓР±СЂР°Р»Рё Р±СЂРѕРЅСЋ (РґРёР°РіРЅРѕСЃС‚РёРєР° РЅРµСѓР±РёРІР°РµРјРѕСЃС‚Рё)
#define FAMWAR_MAX_MEMBERS          10
#define FAMWAR_COUNTDOWN            3       // was 15, now 3 sec
#define FAMWAR_DURATION             120     // 2 минуты боя
// fix: the weapon was never actually sticking for war participants - players
// ended up stuck on fists (confirmed via server_log.txt: GetPlayerWeapon() kept
// reading back 0 after dozens of retries). Root cause was ResetPlayerWeapons()
// immediately followed by SetPlayerArmedWeapon() around the GivePlayerWeapon()
// call - that combo doesn't work reliably on this server build. Every other
// weapon-giving spot in the gamemode (armory, /givegun, jobs) just calls plain
// GivePlayerWeapon() with no reset/arm dance, and that's what we do now too.
// We still keep a short repeating re-arm timer as a safety net in case a
// single GivePlayerWeapon() call is lost to lag/teleport/dialog timing.
#define FAMWAR_REARM_INTERVAL       300     // ms between re-arm checks
#define FAMWAR_REARM_MAX_TRIES      10      // ~3 sec of retries total

#define FAMWAR_CHALLENGE_TIMEOUT    60      // сек. на ответ /yesvoina

#define FAMWAR_STAKE_MONEY          1
#define FAMWAR_STAKE_REP            2
#define FAMWAR_STAKE_NONE           3

// ---------- ID диалогов (высокий диапазон, чтобы не пересечься с чужими) ----------
#define DIALOG_FAMWAR_MAIN          32101
#define DIALOG_FAMWAR_TOP           32102
#define DIALOG_FAMWAR_MYFAM         32103
#define DIALOG_FAMWAR_ENTERID       32104
#define DIALOG_FAMWAR_STAKE         32105
#define DIALOG_FAMWAR_AMOUNT        32106
#define DIALOG_FAMWAR_MEMBERS       32107

// ---------- Объекты НПС ----------
forward FamWar_ReArm(playerid);
forward FamWar_StartRearmWatch(playerid);

new FamWarNPC = -1;
new FamWarNPCPickup = -1;
new Text3D:FamWarNPCLabel = Text3D:-1;

// ---------- Временные данные диалогового флоу вызова ----------
new FamWar_TempTargetID[MAX_PLAYERS];
new FamWar_TempStakeType[MAX_PLAYERS];
new FamWar_TempStakeAmount[MAX_PLAYERS];

// ---------- Ожидающий подтверждения вызов (один активный вызов на сервер) ----------
new bool:FamWar_ChallengePending = false;
new FamWar_ChallengerPlayer = -1;
new FamWar_TargetPlayer = -1;
new FamWar_ChallengerFam = -1;
new FamWar_TargetFam = -1;
new FamWar_StakeType = 0;
new FamWar_StakeAmount = 0;
new FamWar_MembersCount = 0;
new FamWar_ChallengeTimer = -1;

// ---------- Активная война ----------
new bool:FamWar_Active = false;
new FamWar_Participants[2][FAMWAR_MAX_MEMBERS];
new FamWar_ParticipantsCount[2];
new FamWar_Score[2];
new FamWar_Phase = 0; // 0 - нет, 1 - отсчёт до начала, 2 - бой идёт
new FamWar_TimeLeft = 0;
new FamWar_MainTimer = -1;
new Text:FamWar_TD_BG = Text: -1;
new Text:FamWar_TD_TXT = Text: -1;

// ---------- Топ семей (очки побед за текущую сессию сервера) ----------
new FamWar_Wins[MAX_FAM];

// =====================================================================
//                          ИНИЦИАЛИЗАЦИЯ
// =====================================================================
stock FamWar_Init()
{
    FamWarNPC = CreateActor(FAMWAR_NPC_SKIN, FAMWAR_NPC_X, FAMWAR_NPC_Y, FAMWAR_NPC_Z, FAMWAR_NPC_A);
    SetActorInvulnerable(FamWarNPC, true);

    FamWarNPCLabel = Create3DTextLabel("{FFD700}Битва Семей\n{FF5252}[ Подойдите для взаимодействия ]", 0xFF5252FF,
        FAMWAR_NPC_X, FAMWAR_NPC_Y, FAMWAR_NPC_Z + 1.1, 10.0, 0);

    FamWarNPCPickup = CreatePickup(1239, 23, FAMWAR_NPC_X, FAMWAR_NPC_Y, FAMWAR_NPC_Z, 0, PICKUP_ACTION_TYPE_FAMWAR);

    for(new i; i < MAX_FAM; i++) FamWar_Wins[i] = 0;

    FamWar_TD_BG = TextDrawCreate(500.0, 100.0, "_");
    TextDrawTextSize(FamWar_TD_BG, 640.0, 45.0);
    TextDrawUseBox(FamWar_TD_BG, true);
    TextDrawBoxColor(FamWar_TD_BG, 0x00000090);
    TextDrawAlignment(FamWar_TD_BG, 2);

    FamWar_TD_TXT = TextDrawCreate(500.0, 105.0, "Битва семей");
    TextDrawAlignment(FamWar_TD_TXT, 2);
    TextDrawFont(FamWar_TD_TXT, 2);
    TextDrawLetterSize(FamWar_TD_TXT, 0.28, 1.2);
    TextDrawColor(FamWar_TD_TXT, 0xFFFFFFFF);
    TextDrawSetOutline(FamWar_TD_TXT, 1);
    TextDrawSetProportional(FamWar_TD_TXT, 1);

    return 1;
}

// =====================================================================
//                    ВЗАИМОДЕЙСТВИЕ С НПС (пикап)
// =====================================================================
stock FamWar_OnPlayerPickUpPickup(playerid, pickupid, action_type, action_id)
{
    #pragma unused pickupid, action_id
    if(action_type != PICKUP_ACTION_TYPE_FAMWAR) return 0;

    Dialog(playerid, DIALOG_FAMWAR_MAIN, DIALOG_STYLE_LIST, "{FFD700}Битва Семей",
        "Позвать семью на битву семей\nТоп битвы семей\nМоя семья", "Выбрать", "Закрыть");

    return 1;
}

// =====================================================================
//                       ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// =====================================================================
stock FamWar_GetTeam(playerid)
{
    if(!FamWar_Active) return -1;
    for(new t; t < 2; t++)
    {
        for(new i; i < FamWar_ParticipantsCount[t]; i++)
            if(FamWar_Participants[t][i] == playerid) return t;
    }
    return -1;
}

// fix: respawn war participants back on their team spot instead of the
// normal server spawn. Call this at the very start of OnPlayerSpawn.
// Returns 1 if the player was handled (still an active war participant),
// 0 if the caller should proceed with normal spawn logic.
stock FamWar_OnPlayerSpawn(playerid)
{
    if(!FamWar_Active || FamWar_Phase != 2) return 0;

    new t = FamWar_GetTeam(playerid);
    if(t == -1) return 0;

    SetPlayerPos(playerid, FamWar_TeamPos[t][0], FamWar_TeamPos[t][1], FamWar_TeamPos[t][2]);
    SetPlayerFacingAngle(playerid, FamWar_TeamPos[t][3]);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);

    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, FAMWAR_ARMOR);
    ResetPlayerWeapons(playerid);
    // fix: do NOT GivePlayerWeapon in the same tick as SetPlayerPos/ResetPlayerWeapons -
    // that's exactly the combo that was losing the race with the client (weapon looked
    // "given" server-side but the client kept fists). FamWar_StartRearmWatch's first
    // pass runs a moment later, decoupled from the teleport, which is what actually
    // makes it stick (same as when it's given manually via a separate command).
    FamWar_StartRearmWatch(playerid);

    SetPVarInt(playerid, "player_in_green_zone", 0);

    TogglePlayerControllable(playerid, true);

    TextDrawShowForPlayer(playerid, FamWar_TD_BG);
    TextDrawShowForPlayer(playerid, FamWar_TD_TXT);

    return 1;
}

// fix: forces PvP damage between war participants regardless of any
// other system in the gamemode that might block it (stale green-zone
// flags, safe-zone checks, etc). Call this FIRST in OnPlayerTakeDamage.
stock FamWar_ForceAllowDamage(playerid, issuerid)
{
    if(!FamWar_Active || FamWar_Phase != 2) return 0;
    if(issuerid == INVALID_PLAYER_ID) return 0;

    new vt = FamWar_GetTeam(playerid);
    new it = FamWar_GetTeam(issuerid);

    if(vt == -1 || it == -1 || vt == it) return 0;

    return 1;
}

stock FamWar_CancelChallenge(reason[])
{
    if(FamWar_ChallengeTimer != -1) { KillTimer(FamWar_ChallengeTimer); FamWar_ChallengeTimer = -1; }

    if(IsPlayerConnected(FamWar_ChallengerPlayer))
    {
        new msg[160];
        if(strlen(reason) > 0) format(msg, sizeof msg, ""c_f_r"Вызов на битву семей отменён: %s", reason);
        else format(msg, sizeof msg, ""c_f_r"Вызов на битву семей отменён.");
        SendClientMessage(FamWar_ChallengerPlayer, -1, msg);
    }

    FamWar_ChallengePending = false;
    FamWar_ChallengerPlayer = -1;
    FamWar_TargetPlayer = -1;
    FamWar_ChallengerFam = -1;
    FamWar_TargetFam = -1;
    FamWar_StakeType = 0;
    FamWar_StakeAmount = 0;
    FamWar_MembersCount = 0;
    return 1;
}

public:FamWar_ChallengeExpire()
{
    FamWar_ChallengeTimer = -1;

    if(IsPlayerConnected(FamWar_ChallengerPlayer))
        SendClientMessage(FamWar_ChallengerPlayer, -1, ""c_f_r"Лидер вражеской семьи не ответил на вызов, битва отменена.");

    if(IsPlayerConnected(FamWar_TargetPlayer))
        SendClientMessage(FamWar_TargetPlayer, -1, ""c_f_r"Время на ответ по вызову битвы семей истекло.");

    FamWar_ChallengePending = false;
    FamWar_ChallengerPlayer = -1;
    FamWar_TargetPlayer = -1;
    FamWar_ChallengerFam = -1;
    FamWar_TargetFam = -1;
    FamWar_StakeType = 0;
    FamWar_StakeAmount = 0;
    FamWar_MembersCount = 0;
    return 1;
}

// =====================================================================
//                          ГЛАВНЫЙ ДИАЛОГ
// =====================================================================
stock FamWar_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_FAMWAR_MAIN)
    {
        if(!response) return 1;

        new f = GetPlayerIdFamily(playerid);

        switch(listitem)
        {
            case 0: // Позвать семью на битву семей
            {
                if(f == -1) return SendClientMessage(playerid, -1, ""c_f_r"Вы не состоите в семье.");

                if(FamWar_ChallengePending)
                    return SendClientMessage(playerid, -1, ""c_f_r"Уже ожидается ответ по другому вызову на битву семей.");

                if(FamWar_Active)
                    return SendClientMessage(playerid, -1, ""c_f_r"Битва семей уже идёт на сервере, дождитесь окончания.");

                Dialog(playerid, DIALOG_FAMWAR_ENTERID, DIALOG_STYLE_INPUT, "{FFD700}Вызов на битву семей",
                    "{FFFFFF}Введите ID лидера вражеской семьи (игрок должен быть в сети):", "Далее", "Отмена");
            }
            case 1: // Топ битвы семей
            {
                new string[600], count = 0;
                new order[MAX_FAM], wins_c[MAX_FAM];

                for(new i; i < MAX_FAM; i++)
                {
                    if(GetFamily(i, family_database) == -1) continue;
                    order[count] = i;
                    wins_c[count] = FamWar_Wins[i];
                    count++;
                }

                for(new i; i < count - 1; i++)
                {
                    for(new j; j < count - i - 1; j++)
                    {
                        if(wins_c[j] < wins_c[j+1])
                        {
                            new tmp1 = wins_c[j]; wins_c[j] = wins_c[j+1]; wins_c[j+1] = tmp1;
                            new tmp2 = order[j]; order[j] = order[j+1]; order[j+1] = tmp2;
                        }
                    }
                }

                strcat(string, "{FFD700}#\t{FFD700}Семья\t{FFD700}Побед\n");

                if(count == 0) strcat(string, "{FFFFFF}Пока нет данных о битвах семей.");
                else
                {
                    new wline[128];
                    for(new i; i < count && i < 20; i++)
                    {
                        format(wline, sizeof wline, "{FFFFFF}%d\t%s\t%d\n", i+1, GetFamily(order[i], family_name), wins_c[i]);
                        strcat(string, wline);
                    }
                }

                Dialog(playerid, DIALOG_FAMWAR_TOP, DIALOG_STYLE_TABLIST_HEADERS, "{FFD700}Топ битвы семей", string, "Закрыть", "");
            }
            case 2: // Моя семья
            {
                if(f == -1) return SendClientMessage(playerid, -1, ""c_f_r"Вы не состоите в семье.");

                new online = 0;
                foreach(new i : Player) if(GetPlayerIdFamily(i) == f) online++;

                new string[400];
                format(string, sizeof string,
                    "{FFD700}Семья: {FFFFFF}%s\n{FFD700}Деньги семьи: {FFFFFF}%d$\n{FFD700}Репутация: {FFFFFF}%d\n{FFD700}Побед в войнах семей: {FFFFFF}%d\n{FFD700}Онлайн участников: {FFFFFF}%d",
                    GetFamily(f, family_name), GetFamily(f, family_money), GetFamily(f, family_reputation), FamWar_Wins[f], online);

                Dialog(playerid, DIALOG_FAMWAR_MYFAM, DIALOG_STYLE_MSGBOX, "{FFD700}Моя семья", string, "Закрыть", "");
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_FAMWAR_ENTERID)
    {
        if(!response) return 1;

        new targetid = strval(inputtext);
        new f = GetPlayerIdFamily(playerid);

        if(!IsPlayerConnected(targetid))
            return SendClientMessage(playerid, -1, ""c_f_r"Игрок с таким ID не в сети.");

        if(targetid == playerid)
            return SendClientMessage(playerid, -1, ""c_f_r"Нельзя вызвать самого себя.");

        if(GetPlayerIdFamily(targetid) == -1)
            return SendClientMessage(playerid, -1, ""c_f_r"Указанный игрок не состоит ни в одной семье.");

        if(GetPlayerIdFamily(targetid) == f)
            return SendClientMessage(playerid, -1, ""c_f_r"Нельзя вызвать на битву свою же семью.");

        // fix: warcall only to family leader
        new target_fam = GetPlayerIdFamily(targetid);
        if(GetPlayerAccountID(targetid) != GetFamily(target_fam, family_owner))
            return SendClientMessage(playerid, -1, ""c_f_r"Можно вызвать на войну только лидера семьи (владельца).");

        FamWar_TempTargetID[playerid] = targetid;

        Dialog(playerid, DIALOG_FAMWAR_STAKE, DIALOG_STYLE_LIST, "{FFD700}Ставка",
            "На деньги\nРепутацию\nПросто так", "Выбрать", "Отмена");

        return 1;
    }

    if(dialogid == DIALOG_FAMWAR_STAKE)
    {
        if(!response) return 1;

        switch(listitem)
        {
            case 0:
            {
                FamWar_TempStakeType[playerid] = FAMWAR_STAKE_MONEY;
                Dialog(playerid, DIALOG_FAMWAR_AMOUNT, DIALOG_STYLE_INPUT, "{FFD700}Ставка на деньги",
                    "{FFFFFF}Введите сумму ставки (деньги семьи):", "Далее", "Отмена");
            }
            case 1:
            {
                FamWar_TempStakeType[playerid] = FAMWAR_STAKE_REP;
                Dialog(playerid, DIALOG_FAMWAR_AMOUNT, DIALOG_STYLE_INPUT, "{FFD700}Ставка на репутацию",
                    "{FFFFFF}Введите сумму ставки (репутация семьи):", "Далее", "Отмена");
            }
            case 2:
            {
                FamWar_TempStakeType[playerid] = FAMWAR_STAKE_NONE;
                FamWar_TempStakeAmount[playerid] = 0;
                Dialog(playerid, DIALOG_FAMWAR_MEMBERS, DIALOG_STYLE_INPUT, "{FFD700}Участники",
                    "{FFFFFF}Введите количество участников с каждой стороны (от 1 до 10):", "Вызвать", "Отмена");
            }
        }
        return 1;
    }

    if(dialogid == DIALOG_FAMWAR_AMOUNT)
    {
        if(!response) return 1;

        new amount = strval(inputtext);
        new f = GetPlayerIdFamily(playerid);

        if(amount <= 0)
            return SendClientMessage(playerid, -1, ""c_f_r"Введите корректную сумму ставки.");

        if(FamWar_TempStakeType[playerid] == FAMWAR_STAKE_MONEY && GetFamily(f, family_money) < amount)
            return SendClientMessage(playerid, -1, ""c_f_r"У вашей семьи недостаточно денег для такой ставки.");

        if(FamWar_TempStakeType[playerid] == FAMWAR_STAKE_REP && GetFamily(f, family_reputation) < amount)
            return SendClientMessage(playerid, -1, ""c_f_r"У вашей семьи недостаточно репутации для такой ставки.");

        FamWar_TempStakeAmount[playerid] = amount;

        Dialog(playerid, DIALOG_FAMWAR_MEMBERS, DIALOG_STYLE_INPUT, "{FFD700}Участники",
            "{FFFFFF}Введите количество участников с каждой стороны (от 1 до 10):", "Вызвать", "Отмена");

        return 1;
    }

    if(dialogid == DIALOG_FAMWAR_MEMBERS)
    {
        if(!response) return 1;

        new members = strval(inputtext);

        if(members < 1 || members > FAMWAR_MAX_MEMBERS)
        {
            SendClientMessage(playerid, -1, ""c_f_r"Количество участников должно быть от 1 до 10.");
            return 1;
        }

        new f = GetPlayerIdFamily(playerid);
        new targetid = FamWar_TempTargetID[playerid];

        if(f == -1 || !IsPlayerConnected(targetid) || GetPlayerIdFamily(targetid) == -1)
        {
            SendClientMessage(playerid, -1, ""c_f_r"Не удалось отправить вызов, попробуйте снова.");
            return 1;
        }

        if(FamWar_ChallengePending || FamWar_Active)
        {
            SendClientMessage(playerid, -1, ""c_f_r"На сервере уже есть активная битва семей или ожидание ответа.");
            return 1;
        }

        FamWar_ChallengePending  = true;
        FamWar_ChallengerPlayer  = playerid;
        FamWar_TargetPlayer      = targetid;
        FamWar_ChallengerFam     = f;
        FamWar_TargetFam         = GetPlayerIdFamily(targetid);
        FamWar_StakeType         = FamWar_TempStakeType[playerid];
        FamWar_StakeAmount       = FamWar_TempStakeAmount[playerid];
        FamWar_MembersCount      = members;

        new stake_str[64];
        switch(FamWar_StakeType)
        {
            case FAMWAR_STAKE_MONEY: format(stake_str, sizeof stake_str, "на деньги (%d$)", FamWar_StakeAmount);
            case FAMWAR_STAKE_REP:   format(stake_str, sizeof stake_str, "на репутацию (%d)", FamWar_StakeAmount);
            default:                 format(stake_str, sizeof stake_str, "просто так");
        }

        new string[400];
        format(string, sizeof string,
            "{FFD700}Вас вызвала семья {FFFFFF}%s {FFD700}на битву семей %s, участников: %d.\n{FFFFFF}Чтобы отклонить вызов напишите {FF5252}/novoina{FFFFFF}, чтобы принять напишите {00CC00}/yesvoina",
            GetFamily(f, family_name), stake_str, members);
        SendClientMessage(targetid, -1, string);

        format(string, sizeof string, ""c_f_g"Вызов отправлен лидеру семьи, ожидаем ответа (%d сек)...", FAMWAR_CHALLENGE_TIMEOUT);
        SendClientMessage(playerid, -1, string);

        FamWar_ChallengeTimer = SetTimer("FamWar_ChallengeExpire", FAMWAR_CHALLENGE_TIMEOUT * 1000, false);

        return 1;
    }

    return 0;
}

// =====================================================================
//                        КОМАНДЫ /yesvoina /novoina
// =====================================================================
cmd:yesvoina(playerid)
{
    if(!FamWar_ChallengePending || playerid != FamWar_TargetPlayer)
        return SendClientMessage(playerid, -1, ""c_f_r"У вас нет активных вызовов на битву семей.");

    if(!IsPlayerConnected(FamWar_ChallengerPlayer))
    {
        FamWar_CancelChallenge("вызывающий игрок покинул сервер.");
        return SendClientMessage(playerid, -1, ""c_f_r"Вызывающий игрок уже не в сети, битва отменена.");
    }

    if(FamWar_StakeType == FAMWAR_STAKE_MONEY)
    {
        if(GetFamily(FamWar_ChallengerFam, family_money) < FamWar_StakeAmount || GetFamily(FamWar_TargetFam, family_money) < FamWar_StakeAmount)
        {
            SendClientMessage(playerid, -1, ""c_f_r"У одной из семей недостаточно денег для ставки, битва отменена.");
            return FamWar_CancelChallenge("недостаточно денег для ставки.");
        }
    }
    else if(FamWar_StakeType == FAMWAR_STAKE_REP)
    {
        if(GetFamily(FamWar_ChallengerFam, family_reputation) < FamWar_StakeAmount || GetFamily(FamWar_TargetFam, family_reputation) < FamWar_StakeAmount)
        {
            SendClientMessage(playerid, -1, ""c_f_r"У одной из семей недостаточно репутации для ставки, битва отменена.");
            return FamWar_CancelChallenge("недостаточно репутации для ставки.");
        }
    }

    if(FamWar_ChallengeTimer != -1) { KillTimer(FamWar_ChallengeTimer); FamWar_ChallengeTimer = -1; }

    // ---- набор участников ----
    FamWar_ParticipantsCount[0] = 0;
    FamWar_ParticipantsCount[1] = 0;

    foreach(new i : Player)
    {
        if(FamWar_ParticipantsCount[0] < FamWar_MembersCount && GetPlayerIdFamily(i) == FamWar_ChallengerFam)
            FamWar_Participants[0][FamWar_ParticipantsCount[0]++] = i;
        else if(FamWar_ParticipantsCount[1] < FamWar_MembersCount && GetPlayerIdFamily(i) == FamWar_TargetFam)
            FamWar_Participants[1][FamWar_ParticipantsCount[1]++] = i;
    }

    if(FamWar_ParticipantsCount[0] == 0 || FamWar_ParticipantsCount[1] == 0)
    {
        SendClientMessage(playerid, -1, ""c_f_r"У одной из семей нет игроков онлайн, битва отменена.");
        return FamWar_CancelChallenge("нет участников онлайн.");
    }

    FamWar_Active = true;
    FamWar_Phase = 1;
    FamWar_TimeLeft = FAMWAR_COUNTDOWN;
    FamWar_Score[0] = 0;
    FamWar_Score[1] = 0;

    for(new t; t < 2; t++)
    {
        for(new i; i < FamWar_ParticipantsCount[t]; i++)
        {
            new id = FamWar_Participants[t][i];

            SetPlayerPos(id, FamWar_TeamPos[t][0], FamWar_TeamPos[t][1], FamWar_TeamPos[t][2]);
            SetPlayerFacingAngle(id, FamWar_TeamPos[t][3]);
            SetPlayerVirtualWorld(id, 0);
            SetPlayerInterior(id, 0);

            SetPlayerHealth(id, 100.0);
            SetPlayerArmour(id, FAMWAR_ARMOR);
            // fix: ResetPlayerWeapons() immediately followed by SetPlayerArmedWeapon()
            // never actually stuck on this server build - GetPlayerWeapon() kept reading
            // back 0 (fists) no matter how many times it was retried (see server_log.txt,
            // hundreds of "rearm retry" lines, weapon_was always 0). Every OTHER place in
            // the gamemode that hands out a weapon (armory, /givegun, inkassator job, etc.)
            // just calls GivePlayerWeapon() alone and it works fine - so we now match that
            // exact proven pattern instead of the Reset+SetArmed combo that was breaking it.
            GivePlayerWeapon(id, FAMWAR_WEAPON_ID, FAMWAR_WEAPON_AMMO);

            // fix: clear any stale "in green zone" flag that could block PvP damage
            SetPVarInt(id, "player_in_green_zone", 0);

            TogglePlayerControllable(id, false);

            TextDrawShowForPlayer(id, FamWar_TD_BG);
            TextDrawShowForPlayer(id, FamWar_TD_TXT);
        }
    }

    new string[400];
    format(string, sizeof string,
        ""c_f_g"Семья %s приняла вызов! Битва семей начнётся через %d сек, участников: %d на %d.",
        GetFamily(FamWar_TargetFam, family_name), FAMWAR_COUNTDOWN, FamWar_ParticipantsCount[0], FamWar_ParticipantsCount[1]);
    SendFamilyMessage(FamWar_ChallengerFam, string);
    SendFamilyMessage(FamWar_TargetFam, string);

    FamWar_MainTimer = SetTimer("FamWar_Tick", 1000, true);
    FamWar_UpdateTD();

    FamWar_ChallengePending = false;
    FamWar_ChallengerPlayer = -1;
    FamWar_TargetPlayer = -1;

    return 1;
}

cmd:novoina(playerid)
{
    if(!FamWar_ChallengePending || playerid != FamWar_TargetPlayer)
        return SendClientMessage(playerid, -1, ""c_f_r"У вас нет активных вызовов на битву семей.");

    new string[200];
    format(string, sizeof string, ""c_f_r"Семья %s отклонила вызов на битву семей.", GetFamily(FamWar_TargetFam, family_name));
    SendFamilyMessage(FamWar_ChallengerFam, string);
    SendClientMessage(playerid, -1, ""c_f_g"Вы отклонили вызов на битву семей.");

    FamWar_CancelChallenge("");
    return 1;
}

// =====================================================================
stock FamWar_StartRearmWatch(playerid)
{
    SetPVarInt(playerid, "famwar_rearm_tries", 0);
    SetTimerEx("FamWar_ReArm", FAMWAR_REARM_INTERVAL, false, "i", playerid);
    return 1;
}

public FamWar_ReArm(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(FamWar_GetTeam(playerid) == -1) return 0;

    new tries = GetPVarInt(playerid, "famwar_rearm_tries");

    // only re-issue if the client hasn't actually confirmed the weapon yet -
    // avoids spamming GivePlayerWeapon once it's already fine.
    // fix: same as the initial arm in cmd:yesvoina - ResetPlayerWeapons()+SetPlayerArmedWeapon()
    // never stuck on this server build, so retries were looping forever and doing nothing.
    // Plain GivePlayerWeapon() (the pattern used everywhere else in the gamemode) is enough.
    if(GetPlayerWeapon(playerid) != FAMWAR_WEAPON_ID)
    {
        GivePlayerWeapon(playerid, FAMWAR_WEAPON_ID, FAMWAR_WEAPON_AMMO);
        printf("[FAMWAR DEBUG] rearm retry #%d for player=%d, weapon_was=%d", tries + 1, playerid, GetPlayerWeapon(playerid));
    }

    tries++;
    SetPVarInt(playerid, "famwar_rearm_tries", tries);

    if(tries < FAMWAR_REARM_MAX_TRIES)
        SetTimerEx("FamWar_ReArm", FAMWAR_REARM_INTERVAL, false, "i", playerid);

    return 1;
}

//                       FIGHT TICKER (every second)
// =====================================================================
public:FamWar_Tick()
{
    if(!FamWar_Active) return 1;

    FamWar_TimeLeft--;

    if(FamWar_Phase == 1) // отсчёт до начала
    {
        if(FamWar_TimeLeft <= 0)
        {
            FamWar_Phase = 2;
            FamWar_TimeLeft = FAMWAR_DURATION;

            for(new t; t < 2; t++)
                for(new i; i < FamWar_ParticipantsCount[t]; i++)
                {
                    new id = FamWar_Participants[t][i];
                    if(!IsPlayerConnected(id)) continue;

                    TogglePlayerControllable(id, true);
                    // fix: don't GivePlayerWeapon bundled in the same tick as the phase
                    // switch/controllable toggle - isolate it via the rearm watch instead,
                    // same as how a manually-run give-weapon command reliably sticks.
                    FamWar_StartRearmWatch(id);

                    printf("[FAMWAR DEBUG] player=%d weapon_now=%d team=%d", id, GetPlayerWeapon(id), t);
                }
        }
    }
    else if(FamWar_Phase == 2) // бой идёт
    {
        if(FamWar_TimeLeft <= 0)
        {
            FamWar_End();
            return 1;
        }

        // fix: dublicate remaining time in chat every 30 sec
        if(FamWar_TimeLeft == 90 || FamWar_TimeLeft == 60 || FamWar_TimeLeft == 30 || FamWar_TimeLeft == 10)
        {
            new famwar_time_msg[150];
            format(famwar_time_msg, sizeof famwar_time_msg, ""c_f"До конца войны семей осталось: %d сек. Счёт: %d:%d.",
                FamWar_TimeLeft, FamWar_Score[0], FamWar_Score[1]);

            for(new t3; t3 < 2; t3++)
                for(new i3; i3 < FamWar_ParticipantsCount[t3]; i3++)
                    if(IsPlayerConnected(FamWar_Participants[t3][i3]))
                        SendClientMessage(FamWar_Participants[t3][i3], -1, famwar_time_msg);
        }
    }

    FamWar_UpdateTD();
    return 1;
}

stock FamWar_UpdateTD()
{
    new string[256];

    if(FamWar_Phase == 1)
    {
        format(string, sizeof string, "~y~Битва семей~n~~w~%s ~r~VS~w~ %s~n~До начала: ~r~%d сек",
            GetFamily(FamWar_ChallengerFam, family_name), GetFamily(FamWar_TargetFam, family_name), FamWar_TimeLeft);
    }
    else
    {
        format(string, sizeof string, "~y~Битва семей~n~~w~%s ~g~%d~w~ - ~r~%d ~w~%s~n~До конца: ~r~%d сек",
            GetFamily(FamWar_ChallengerFam, family_name), FamWar_Score[0], FamWar_Score[1],
            GetFamily(FamWar_TargetFam, family_name), FamWar_TimeLeft);
    }

    TextDrawSetString(FamWar_TD_TXT, string);

    for(new t; t < 2; t++)
        for(new i; i < FamWar_ParticipantsCount[t]; i++)
            if(IsPlayerConnected(FamWar_Participants[t][i]))
                TextDrawSetString(FamWar_TD_TXT, string), TextDrawShowForPlayer(FamWar_Participants[t][i], FamWar_TD_TXT);

    return 1;
}

// =====================================================================
//                        УЧЁТ УБИЙСТВ
// =====================================================================
stock FamWar_OnPlayerDeath(playerid, killerid, reason)
{
    #pragma unused reason
    if(!FamWar_Active || FamWar_Phase != 2) return 0;
    if(killerid == INVALID_PLAYER_ID) return 0;

    new ct = FamWar_GetTeam(killerid);
    new vt = FamWar_GetTeam(playerid);

    if(ct == -1 || vt == -1 || ct == vt) return 0;

    FamWar_Score[ct]++;
    FamWar_UpdateTD();

    // fix: dublicate score in chat, not only on HUD textdraw
    new famwar_kill_msg[200];
    format(famwar_kill_msg, sizeof famwar_kill_msg, ""c_f_g"Убийство! Счёт: %d:%d (%s против %s).",
        FamWar_Score[0], FamWar_Score[1],
        GetFamily(FamWar_ChallengerFam, family_name), GetFamily(FamWar_TargetFam, family_name));

    for(new t2; t2 < 2; t2++)
        for(new i2; i2 < FamWar_ParticipantsCount[t2]; i2++)
            if(IsPlayerConnected(FamWar_Participants[t2][i2]))
                SendClientMessage(FamWar_Participants[t2][i2], -1, famwar_kill_msg);

    return 0;
}

// =====================================================================
//                          ЗАВЕРШЕНИЕ БОЯ
// =====================================================================
stock FamWar_End()
{
    if(FamWar_MainTimer != -1) { KillTimer(FamWar_MainTimer); FamWar_MainTimer = -1; }

    new winner = -1;
    if(FamWar_Score[0] > FamWar_Score[1]) winner = 0;
    else if(FamWar_Score[1] > FamWar_Score[0]) winner = 1;

    new winnerFam = -1, loserFam = -1;
    if(winner == 0) { winnerFam = FamWar_ChallengerFam; loserFam = FamWar_TargetFam; }
    else if(winner == 1) { winnerFam = FamWar_TargetFam; loserFam = FamWar_ChallengerFam; }

    new string[400];

    if(winnerFam != -1)
    {
        FamWar_Wins[winnerFam]++;

        if(FamWar_StakeType == FAMWAR_STAKE_MONEY)
        {
            AddFamily(winnerFam, family_money, +, FamWar_StakeAmount);
            AddFamily(loserFam, family_money, -, FamWar_StakeAmount);
            UpdateColumnFamilyInt(GetFamily(winnerFam, family_database), "money", GetFamily(winnerFam, family_money));
            UpdateColumnFamilyInt(GetFamily(loserFam, family_database), "money", GetFamily(loserFam, family_money));
        }
        else if(FamWar_StakeType == FAMWAR_STAKE_REP)
        {
            AddFamily(winnerFam, family_reputation, +, FamWar_StakeAmount);
            AddFamily(loserFam, family_reputation, -, FamWar_StakeAmount);
            UpdateColumnFamilyInt(GetFamily(winnerFam, family_database), "reputation", GetFamily(winnerFam, family_reputation));
            UpdateColumnFamilyInt(GetFamily(loserFam, family_database), "reputation", GetFamily(loserFam, family_reputation));
        }

        format(string, sizeof string,
            ""c_f_g"Битва семей окончена! Победила семья %s со счётом %d:%d.",
            GetFamily(winnerFam, family_name), FamWar_Score[winner], FamWar_Score[winner == 0 ? 1 : 0]);
    }
    else
    {
        format(string, sizeof string, ""c_f"Битва семей окончена! Ничья со счётом %d:%d, ставки возвращены.", FamWar_Score[0], FamWar_Score[1]);
    }

    SendFamilyMessage(FamWar_ChallengerFam, string);
    SendFamilyMessage(FamWar_TargetFam, string);

    for(new t; t < 2; t++)
    {
        for(new i; i < FamWar_ParticipantsCount[t]; i++)
        {
            new id = FamWar_Participants[t][i];
            if(!IsPlayerConnected(id)) continue;

            SendClientMessage(id, -1, string);
            TextDrawHideForPlayer(id, FamWar_TD_BG);
            TextDrawHideForPlayer(id, FamWar_TD_TXT);
            TogglePlayerControllable(id, true);
        }
    }

    FamWar_Active = false;
    FamWar_Phase = 0;
    FamWar_TimeLeft = 0;
    FamWar_ParticipantsCount[0] = 0;
    FamWar_ParticipantsCount[1] = 0;
    FamWar_ChallengerFam = -1;
    FamWar_TargetFam = -1;
    FamWar_StakeType = 0;
    FamWar_StakeAmount = 0;

    return 1;
}
