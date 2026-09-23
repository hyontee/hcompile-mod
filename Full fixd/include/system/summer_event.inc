#if defined _workk_summer_event_included
    #endinput
#endif
#define _workk_summer_event_included

#include <a_samp>

#define DIALOG_SUMMER_MAIN      9000
#define DIALOG_SUMMER_DAILY     9001
#define DIALOG_SUMMER_MINIGAMES 9002
#define DIALOG_DUEL_WIN         9003
#define DIALOG_FFA_WIN          9004

#define MAX_DUEL_SLOTS          10
#define MAX_FFA_SLOTS           3
#define MAX_FFA_PLAYERS         5
#define FFA_DURATION            300
#define SUMMER_NPC_COUNT        6
#define FFA_SPAWN_COUNT         9
#define COUNTDOWN_STEPS         5
#define DUEL_REWARD             1000000
#define FFA_REWARD_1ST          2000000
#define FFA_REWARD_2ND          1000000
#define FFA_REWARD_3RD          500000
#define FFA_REWARD_4TH          50000
#define FFA_WAIT_TIME           15
#define DAILY_COOLDOWN          86400

static SummerNPC_Actors[SUMMER_NPC_COUNT];
static Text3D:SummerNPC_Labels[SUMMER_NPC_COUNT][2];
static bool:SummerNPC_IsNear[MAX_PLAYERS];

// Координаты точек ивента - перенесены с точек осеннего ивента (autumn_event.inc -> g_SemenSpawns)
static Float:SummerNPC_Spawns[SUMMER_NPC_COUNT][4] = {
    {-2165.647705, 1564.864379, 9.876050,  224.971862},
    {-2655.623535, 1997.030883, 9.979868,  6.456680},
    {1791.581054,  2529.907714, 14.555471, 223.129547},
    {-2430.060791, 187.469757,  26.135101, 359.582702},
    {2753.797607,  -2439.395019,21.813438, 108.323303},
    {831.837097,   800.696899,  13.167908, 245.903869}
};

static Float:DuelSpawn[2][4] = {
    {-2.19, 2510.98, 1541.00, 149.60},
    {-5.19, 2515.98, 1541.00, 329.60}
};

static Float:FFASpawns[FFA_SPAWN_COUNT][4] = {
    {789.8530,  1748.5814, 1191.3985, 4.7061},
    {829.9674,  1752.0754, 1191.3985, 89.2912},
    {805.5263,  1738.3447, 1191.3985, 10.6135},
    {770.0422,  1737.2796, 1191.3985, 354.3682},
    {761.7080,  1757.1647, 1191.4296, 91.2242},
    {689.6682,  1766.7355, 1191.3984, 181.1164},
    {689.2411,  1751.9442, 1191.3985, 262.8588},
    {721.7790,  1726.1748, 1196.6796, 270.5798},
    {714.8858,  1737.2519, 1191.3985, 10.0987}
};

static DailyRewards[7] = {3000, 5000, 7000, 10000, 13000, 15000, 1000000};

enum E_SUMMER_PLAYER {
    pSummerDay,
    pRewardTime,
    pDuelSlot,
    pFFASlot,
    pFFAScore,
    bool:pSummerFrozen,
    bool:pMenuOpen
};
static PlayerData[MAX_PLAYERS][E_SUMMER_PLAYER];

enum E_DUEL_SLOT {
    dActive,
    dPlayer[2],
    dVW,
    dCountdownTimer,
    bool:dStarted
};
static DuelSlots[MAX_DUEL_SLOTS][E_DUEL_SLOT];

enum E_FFA_SLOT {
    fActive,
    fPlayers[MAX_FFA_PLAYERS],
    fPlayerCount,
    fVW,
    fCountdownTimer,
    fGameTimer,
    fStatusTimer,
    bool:fStarted,
    fWaitTimer,
    bool:fWaiting
};
static FFASlots[MAX_FFA_SLOTS][E_FFA_SLOT];

static ffaTimeLeft[MAX_FFA_SLOTS];
static duelStep[MAX_DUEL_SLOTS];
static ffaStep[MAX_FFA_SLOTS];

forward DuelCountdown(slotid);
forward FFACountdown(slotid);
forward FFAGameTick(slotid);
forward FFAStatusUpdate(slotid);
forward FFAWaitTimeout(slotid);
forward FFARespawn(playerid, slotid);

// Выдача награды ивента - интегрировано с экономикой Workk RP (GivePlayerMoneyEx уже
// синхронизирует gPlayerData[pMoney] и сохраняет аккаунт в БД).
stock GivePlayerVirts(playerid, amount) {
    GivePlayerMoneyEx(playerid, amount);
    return 1;
}

static GetRandomNPCIndex() {
    return random(SUMMER_NPC_COUNT);
}

static IsPlayerNearAnyNPC(playerid) {
    for (new i = 0; i < SUMMER_NPC_COUNT; i++) {
        if (IsPlayerInRangeOfPoint(playerid, 3.0, SummerNPC_Spawns[i][0], SummerNPC_Spawns[i][1], SummerNPC_Spawns[i][2])) {
            return 1;
        }
    }
    return 0;
}

static SummerFreezePlayer(playerid) {
    TogglePlayerControllable(playerid, 0);
    PlayerData[playerid][pSummerFrozen] = true;
}

static SummerUnfreezePlayer(playerid) {
    TogglePlayerControllable(playerid, 1);
    PlayerData[playerid][pSummerFrozen] = false;
}

static TeleportToRandomNPC(playerid) {
    new idx = GetRandomNPCIndex();
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, SummerNPC_Spawns[idx][0] + 1.5, SummerNPC_Spawns[idx][1] + 1.5, SummerNPC_Spawns[idx][2]);
    SetPlayerFacingAngle(playerid, SummerNPC_Spawns[idx][3]);
}

static OpenSummerMain(playerid) {
    PlayerData[playerid][pMenuOpen] = true;
    ShowPlayerDialog(playerid, DIALOG_SUMMER_MAIN, DIALOG_STYLE_LIST, "Летний Ивент",
        "Ежедневные награды\nМини-игры", "Выбрать", "Закрыть");
}

static OpenSummerDaily(playerid) {
    new buf[2048];
    new now = gettime();
    buf[0] = '\0';
    for (new i = 0; i < 7; i++) {
        new line[128];
        if (i < PlayerData[playerid][pSummerDay]) {
            format(line, sizeof(line), "День %d - %d руб. (уже получено)\n", i + 1, DailyRewards[i]);
        } else if (i == PlayerData[playerid][pSummerDay]) {
            if (i == 0) {
                format(line, sizeof(line), "День %d - %d руб. [ЗАБРАТЬ]\n", i + 1, DailyRewards[i]);
            } else {
                new diff = PlayerData[playerid][pRewardTime] + DAILY_COOLDOWN - now;
                if (diff <= 0) {
                    format(line, sizeof(line), "День %d - %d руб. [ЗАБРАТЬ]\n", i + 1, DailyRewards[i]);
                } else {
                    new hh = diff / 3600;
                    new mm = (diff % 3600) / 60;
                    format(line, sizeof(line), "День %d - %d руб. (ожидайте %dч %dм)\n", i + 1, DailyRewards[i], hh, mm);
                }
            }
        } else {
            format(line, sizeof(line), "День %d - %d руб. [ЗАКРЫТО]\n", i + 1, DailyRewards[i]);
        }
        strcat(buf, line, sizeof(buf));
    }
    PlayerData[playerid][pMenuOpen] = true;
    ShowPlayerDialog(playerid, DIALOG_SUMMER_DAILY, DIALOG_STYLE_LIST, "Ежедневные награды", buf, "Выбрать", "Назад");
}

static OpenSummerMinigames(playerid) {
    PlayerData[playerid][pMenuOpen] = true;
    ShowPlayerDialog(playerid, DIALOG_SUMMER_MINIGAMES, DIALOG_STYLE_LIST, "Мини-игры",
        "Дуэль\nПротив всех", "Выбрать", "Назад");
}

static GetFreeDuelSlot() {
    for (new i = 0; i < MAX_DUEL_SLOTS; i++) {
        if (!DuelSlots[i][dActive]) return i;
    }
    return -1;
}

static GetFreeFFASlot() {
    for (new i = 0; i < MAX_FFA_SLOTS; i++) {
        if (!FFASlots[i][fActive]) return i;
    }
    return -1;
}

static GetWaitingFFASlot() {
    for (new i = 0; i < MAX_FFA_SLOTS; i++) {
        if (FFASlots[i][fActive] && !FFASlots[i][fStarted] && FFASlots[i][fPlayerCount] < MAX_FFA_PLAYERS) return i;
    }
    return -1;
}

static IsPlayerInDuel(playerid) {
    return PlayerData[playerid][pDuelSlot] != -1;
}

static IsPlayerInFFA(playerid) {
    return PlayerData[playerid][pFFASlot] != -1;
}

static GetFreeDuelVW() {
    for (new vw = 5000; vw <= 5009; vw++) {
        new found = 0;
        for (new i = 0; i < MAX_DUEL_SLOTS; i++) {
            if (DuelSlots[i][dActive] && DuelSlots[i][dVW] == vw) { found = 1; break; }
        }
        if (!found) return vw;
    }
    return -1;
}

static GetFreeFFAVW() {
    for (new vw = 6000; vw <= 6002; vw++) {
        new found = 0;
        for (new i = 0; i < MAX_FFA_SLOTS; i++) {
            if (FFASlots[i][fActive] && FFASlots[i][fVW] == vw) { found = 1; break; }
        }
        if (!found) return vw;
    }
    return -1;
}

static SpawnDuelPlayer(playerid, slotid, spawnIdx) {
    SetPlayerVirtualWorld(playerid, DuelSlots[slotid][dVW]);
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, DuelSpawn[spawnIdx][0], DuelSpawn[spawnIdx][1], DuelSpawn[spawnIdx][2]);
    SetPlayerFacingAngle(playerid, DuelSpawn[spawnIdx][3]);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 100.0);
    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid, 24, 50);
    SummerFreezePlayer(playerid);
    GameTextForPlayer(playerid, "~y~Ожидание игроков...", 99999000, 3);
}

static SpawnFFAPlayer(playerid, slotid) {
    new idx = random(FFA_SPAWN_COUNT);
    SetPlayerVirtualWorld(playerid, FFASlots[slotid][fVW]);
    SetPlayerInterior(playerid, 0);
    SetPlayerPos(playerid, FFASpawns[idx][0], FFASpawns[idx][1], FFASpawns[idx][2]);
    SetPlayerFacingAngle(playerid, FFASpawns[idx][3]);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 100.0);
    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid, 24, 50);
}

static StartDuelCountdown(slotid) {
    duelStep[slotid] = 0;
    DuelSlots[slotid][dCountdownTimer] = SetTimerEx("DuelCountdown", 1000, false, "i", slotid);
}

static StartFFACountdown(slotid) {
    FFASlots[slotid][fStarted] = true;
    if (FFASlots[slotid][fWaitTimer] != 0) {
        KillTimer(FFASlots[slotid][fWaitTimer]);
        FFASlots[slotid][fWaitTimer] = 0;
    }
    for (new i = 0; i < FFASlots[slotid][fPlayerCount]; i++) {
        new pid = FFASlots[slotid][fPlayers][i];
        if (IsPlayerConnected(pid)) {
            SummerFreezePlayer(pid);
        }
    }
    ffaStep[slotid] = 0;
    FFASlots[slotid][fCountdownTimer] = SetTimerEx("FFACountdown", 1000, false, "i", slotid);
}

public DuelCountdown(slotid) {
    duelStep[slotid]++;
    new step = COUNTDOWN_STEPS - duelStep[slotid] + 1;
    if (step > 0) {
        new gtext[32];
        format(gtext, sizeof(gtext), "~r~%d", step);
        for (new i = 0; i < 2; i++) {
            new pid = DuelSlots[slotid][dPlayer][i];
            if (IsPlayerConnected(pid)) GameTextForPlayer(pid, gtext, 900, 3);
        }
        DuelSlots[slotid][dCountdownTimer] = SetTimerEx("DuelCountdown", 1000, false, "i", slotid);
    } else {
        duelStep[slotid] = 0;
        DuelSlots[slotid][dStarted] = true;
        for (new i = 0; i < 2; i++) {
            new pid = DuelSlots[slotid][dPlayer][i];
            if (IsPlayerConnected(pid)) {
                GameTextForPlayer(pid, "~g~БОЙ!", 1500, 3);
                SummerUnfreezePlayer(pid);
            }
        }
    }
}

public FFACountdown(slotid) {
    ffaStep[slotid]++;
    new step = COUNTDOWN_STEPS - ffaStep[slotid] + 1;
    if (step > 0) {
        new gtext[32];
        format(gtext, sizeof(gtext), "~r~%d", step);
        for (new i = 0; i < FFASlots[slotid][fPlayerCount]; i++) {
            new pid = FFASlots[slotid][fPlayers][i];
            if (IsPlayerConnected(pid)) GameTextForPlayer(pid, gtext, 900, 3);
        }
        FFASlots[slotid][fCountdownTimer] = SetTimerEx("FFACountdown", 1000, false, "i", slotid);
    } else {
        ffaStep[slotid] = 0;
        for (new i = 0; i < FFASlots[slotid][fPlayerCount]; i++) {
            new pid = FFASlots[slotid][fPlayers][i];
            if (IsPlayerConnected(pid)) {
                GameTextForPlayer(pid, "~g~В БОЙ!", 1500, 3);
                SummerUnfreezePlayer(pid);
            }
        }
        FFASlots[slotid][fGameTimer]   = SetTimerEx("FFAGameTick",     1000, true,  "i", slotid);
        FFASlots[slotid][fStatusTimer] = SetTimerEx("FFAStatusUpdate", 1000, true,  "i", slotid);
    }
}

public FFAWaitTimeout(slotid) {
    FFASlots[slotid][fWaitTimer] = 0;
    if (FFASlots[slotid][fActive] && !FFASlots[slotid][fStarted] && FFASlots[slotid][fPlayerCount] >= 2) {
        StartFFACountdown(slotid);
    }
}

public FFAGameTick(slotid) {
    ffaTimeLeft[slotid]--;
    if (ffaTimeLeft[slotid] <= 0) {
        EndFFA(slotid);
    }
}

public FFAStatusUpdate(slotid) {
    for (new i = 0; i < FFASlots[slotid][fPlayerCount]; i++) {
        new pid = FFASlots[slotid][fPlayers][i];
        if (!IsPlayerConnected(pid)) continue;
        new mins = ffaTimeLeft[slotid] / 60;
        new secs = ffaTimeLeft[slotid] % 60;
        new gtext[64];
        format(gtext, sizeof(gtext), "~y~Ваши очки: %d~n~~w~Время: %d:%02d", PlayerData[pid][pFFAScore], mins, secs);
        GameTextForPlayer(pid, gtext, 1100, 5);
    }
}

static EndFFA(slotid) {
    if (!FFASlots[slotid][fActive]) return;

    if (FFASlots[slotid][fGameTimer] != 0) KillTimer(FFASlots[slotid][fGameTimer]);
    if (FFASlots[slotid][fStatusTimer] != 0) KillTimer(FFASlots[slotid][fStatusTimer]);
    if (FFASlots[slotid][fCountdownTimer] != 0) KillTimer(FFASlots[slotid][fCountdownTimer]);
    FFASlots[slotid][fGameTimer] = 0;
    FFASlots[slotid][fStatusTimer] = 0;
    FFASlots[slotid][fCountdownTimer] = 0;

    new ranking[MAX_FFA_PLAYERS];
    new count = FFASlots[slotid][fPlayerCount];
    for (new i = 0; i < count; i++) ranking[i] = i;
    for (new i = 0; i < count - 1; i++) {
        for (new j = i + 1; j < count; j++) {
            new pa = FFASlots[slotid][fPlayers][ranking[i]];
            new pb = FFASlots[slotid][fPlayers][ranking[j]];
            new sa = IsPlayerConnected(pa) ? PlayerData[pa][pFFAScore] : -1;
            new sb = IsPlayerConnected(pb) ? PlayerData[pb][pFFAScore] : -1;
            if (sb > sa) {
                new tmp = ranking[i];
                ranking[i] = ranking[j];
                ranking[j] = tmp;
            }
        }
    }

    new rewards[5] = {FFA_REWARD_1ST, FFA_REWARD_2ND, FFA_REWARD_3RD, FFA_REWARD_4TH, FFA_REWARD_4TH};

    for (new r = 0; r < count; r++) {
        new pid = FFASlots[slotid][fPlayers][ranking[r]];
        if (!IsPlayerConnected(pid)) continue;
        new reward = (r < 5) ? rewards[r] : FFA_REWARD_4TH;
        GivePlayerVirts(pid, reward);

        new dlgMsg[200];
        format(dlgMsg, sizeof(dlgMsg), "Поздравляем!\nВы заняли %d место!\nВаш приз: %d руб.", r + 1, reward);
        ShowPlayerDialog(pid, DIALOG_FFA_WIN, DIALOG_STYLE_MSGBOX, "FFA - Результаты!", dlgMsg, "Принять", "");

        SetPlayerHealth(pid, 100.0);
        SetPlayerArmour(pid, 0.0);
        ResetPlayerWeapons(pid);
        SummerUnfreezePlayer(pid);
        TeleportToRandomNPC(pid);
        PlayerData[pid][pFFASlot] = -1;
        PlayerData[pid][pFFAScore] = 0;
    }

    FFASlots[slotid][fActive] = 0;
    FFASlots[slotid][fPlayerCount] = 0;
    FFASlots[slotid][fStarted] = false;
    FFASlots[slotid][fWaiting] = false;
    FFASlots[slotid][fVW] = -1;
    ffaTimeLeft[slotid] = 0;
}

static EndDuelForWinner(winner, loser) {
    new slot = PlayerData[winner][pDuelSlot];
    if (slot == -1) return;

    if (DuelSlots[slot][dCountdownTimer] != 0) {
        KillTimer(DuelSlots[slot][dCountdownTimer]);
        DuelSlots[slot][dCountdownTimer] = 0;
    }

    GivePlayerVirts(winner, DUEL_REWARD);

    new wname[MAX_PLAYER_NAME];
    GetPlayerName(winner, wname, sizeof(wname));
    new annmsg[128];
    format(annmsg, sizeof(annmsg), "{FFD700}Игрок {FFFFFF}%s {FFD700}выиграл дуэль и получил 1.000.000 руб.!", wname);
    SendClientMessageToAll(0xFFD700FF, annmsg);

    ShowPlayerDialog(winner, DIALOG_DUEL_WIN, DIALOG_STYLE_MSGBOX, "Дуэль",
        "Поздравляем! Вы выиграли дуэль!\nВаш приз: 1.000.000 руб.", "ОК", "");

    SetPlayerHealth(winner, 100.0);
    SetPlayerArmour(winner, 0.0);
    ResetPlayerWeapons(winner);
    SummerUnfreezePlayer(winner);
    TeleportToRandomNPC(winner);
    PlayerData[winner][pDuelSlot] = -1;

    if (IsPlayerConnected(loser)) {
        SendClientMessage(loser, 0xFF4444FF, "Вы проиграли дуэль.");
        SetPlayerHealth(loser, 100.0);
        SetPlayerArmour(loser, 0.0);
        ResetPlayerWeapons(loser);
        SummerUnfreezePlayer(loser);
        TeleportToRandomNPC(loser);
        PlayerData[loser][pDuelSlot] = -1;
    }

    DuelSlots[slot][dActive] = 0;
    DuelSlots[slot][dStarted] = false;
    DuelSlots[slot][dPlayer][0] = -1;
    DuelSlots[slot][dPlayer][1] = -1;
    DuelSlots[slot][dVW] = -1;
}

static JoinDuel(playerid) {
    for (new i = 0; i < MAX_DUEL_SLOTS; i++) {
        if (DuelSlots[i][dActive] && !DuelSlots[i][dStarted] && DuelSlots[i][dPlayer][1] == -1) {
            DuelSlots[i][dPlayer][1] = playerid;
            PlayerData[playerid][pDuelSlot] = i;
            SpawnDuelPlayer(playerid, i, 1);
            StartDuelCountdown(i);
            return;
        }
    }
    new slot = GetFreeDuelSlot();
    if (slot == -1) {
        SendClientMessage(playerid, 0xFF0000FF, "Нет свободных слотов для дуэли.");
        return;
    }
    new vw = GetFreeDuelVW();
    if (vw == -1) {
        SendClientMessage(playerid, 0xFF0000FF, "Нет свободных виртуальных миров.");
        return;
    }
    DuelSlots[slot][dActive] = 1;
    DuelSlots[slot][dPlayer][0] = playerid;
    DuelSlots[slot][dPlayer][1] = -1;
    DuelSlots[slot][dVW] = vw;
    DuelSlots[slot][dStarted] = false;
    PlayerData[playerid][pDuelSlot] = slot;
    SpawnDuelPlayer(playerid, slot, 0);
}

static JoinFFA(playerid) {
    new slot = GetWaitingFFASlot();
    if (slot == -1) {
        slot = GetFreeFFASlot();
        if (slot == -1) {
            SendClientMessage(playerid, 0xFF0000FF, "Нет свободных слотов FFA.");
            return;
        }
        new vw = GetFreeFFAVW();
        if (vw == -1) {
            SendClientMessage(playerid, 0xFF0000FF, "Нет свободных виртуальных миров.");
            return;
        }
        FFASlots[slot][fActive] = 1;
        FFASlots[slot][fPlayerCount] = 0;
        FFASlots[slot][fVW] = vw;
        FFASlots[slot][fStarted] = false;
        FFASlots[slot][fWaiting] = false;
        ffaTimeLeft[slot] = FFA_DURATION;
    }

    new idx = FFASlots[slot][fPlayerCount];
    FFASlots[slot][fPlayers][idx] = playerid;
    FFASlots[slot][fPlayerCount]++;
    PlayerData[playerid][pFFASlot] = slot;
    PlayerData[playerid][pFFAScore] = 0;

    SpawnFFAPlayer(playerid, slot);
    SummerFreezePlayer(playerid);

    new gtext[64];
    format(gtext, sizeof(gtext), "~y~Ожидание игроков... (%d/5)", FFASlots[slot][fPlayerCount]);
    for (new i = 0; i < FFASlots[slot][fPlayerCount]; i++) {
        new pid = FFASlots[slot][fPlayers][i];
        if (IsPlayerConnected(pid)) GameTextForPlayer(pid, gtext, 99999000, 3);
    }

    if (FFASlots[slot][fPlayerCount] >= MAX_FFA_PLAYERS) {
        StartFFACountdown(slot);
    } else if (FFASlots[slot][fPlayerCount] == 2 && !FFASlots[slot][fWaiting]) {
        FFASlots[slot][fWaiting] = true;
        FFASlots[slot][fWaitTimer] = SetTimerEx("FFAWaitTimeout", FFA_WAIT_TIME * 1000, false, "i", slot);
    }
}

stock SummerEvent_Init() {
    for (new i = 0; i < MAX_DUEL_SLOTS; i++) {
        DuelSlots[i][dActive] = 0;
        DuelSlots[i][dPlayer][0] = -1;
        DuelSlots[i][dPlayer][1] = -1;
        DuelSlots[i][dVW] = -1;
        DuelSlots[i][dCountdownTimer] = 0;
        DuelSlots[i][dStarted] = false;
    }
    for (new i = 0; i < MAX_FFA_SLOTS; i++) {
        FFASlots[i][fActive] = 0;
        FFASlots[i][fPlayerCount] = 0;
        FFASlots[i][fVW] = -1;
        FFASlots[i][fStarted] = false;
        FFASlots[i][fWaiting] = false;
        FFASlots[i][fWaitTimer] = 0;
        FFASlots[i][fGameTimer] = 0;
        FFASlots[i][fStatusTimer] = 0;
        FFASlots[i][fCountdownTimer] = 0;
    }

    for (new i = 0; i < SUMMER_NPC_COUNT; i++) {
        SummerNPC_Actors[i] = CreateActor(2,
            SummerNPC_Spawns[i][0],
            SummerNPC_Spawns[i][1],
            SummerNPC_Spawns[i][2],
            SummerNPC_Spawns[i][3]);
        SetActorVirtualWorld(SummerNPC_Actors[i], 0);
        SetActorInvulnerable(SummerNPC_Actors[i], true);

        new Float:lz = SummerNPC_Spawns[i][2] - 0.4;
        SummerNPC_Labels[i][0] = Create3DTextLabel(
            "{FF0000}Летний Ивент",
            0xFFFFFFFF,
            SummerNPC_Spawns[i][0],
            SummerNPC_Spawns[i][1],
            lz + 0.3,
            15.0, 0, 1);
        SummerNPC_Labels[i][1] = Create3DTextLabel(
            "{FFFF00}Подойдите ближе для взаимодействия",
            0xFFFFFFFF,
            SummerNPC_Spawns[i][0],
            SummerNPC_Spawns[i][1],
            lz,
            15.0, 0, 1);
    }

    print("[SummerEvent] Инклуд загружен.");
}

stock SummerEvent_Exit() {
    for (new i = 0; i < SUMMER_NPC_COUNT; i++) {
        DestroyActor(SummerNPC_Actors[i]);
        Delete3DTextLabel(SummerNPC_Labels[i][0]);
        Delete3DTextLabel(SummerNPC_Labels[i][1]);
    }
}

stock SummerEvent_OnPlayerConnect(playerid) {
    PlayerData[playerid][pSummerDay]  = 0;
    PlayerData[playerid][pRewardTime] = 0;
    PlayerData[playerid][pDuelSlot]   = -1;
    PlayerData[playerid][pFFASlot]    = -1;
    PlayerData[playerid][pFFAScore]   = 0;
    PlayerData[playerid][pSummerFrozen]     = false;
    PlayerData[playerid][pMenuOpen]   = false;
    SummerNPC_IsNear[playerid]        = false;
}

stock SummerEvent_OnPlayerDisconnect(playerid, reason) {
    #pragma unused reason
    new ds = PlayerData[playerid][pDuelSlot];
    if (ds != -1 && DuelSlots[ds][dActive]) {
        new opp = -1;
        if (DuelSlots[ds][dPlayer][0] == playerid) opp = DuelSlots[ds][dPlayer][1];
        else if (DuelSlots[ds][dPlayer][1] == playerid) opp = DuelSlots[ds][dPlayer][0];
        if (opp != -1 && IsPlayerConnected(opp)) {
            EndDuelForWinner(opp, playerid);
        } else {
            if (DuelSlots[ds][dCountdownTimer] != 0) KillTimer(DuelSlots[ds][dCountdownTimer]);
            DuelSlots[ds][dActive] = 0;
            DuelSlots[ds][dPlayer][0] = -1;
            DuelSlots[ds][dPlayer][1] = -1;
            DuelSlots[ds][dStarted] = false;
            DuelSlots[ds][dVW] = -1;
        }
    }

    new fs = PlayerData[playerid][pFFASlot];
    if (fs != -1 && FFASlots[fs][fActive]) {
        for (new i = 0; i < FFASlots[fs][fPlayerCount]; i++) {
            if (FFASlots[fs][fPlayers][i] == playerid) {
                FFASlots[fs][fPlayers][i] = FFASlots[fs][fPlayers][FFASlots[fs][fPlayerCount] - 1];
                FFASlots[fs][fPlayerCount]--;
                break;
            }
        }
        if (FFASlots[fs][fPlayerCount] <= 0) {
            if (FFASlots[fs][fGameTimer] != 0) KillTimer(FFASlots[fs][fGameTimer]);
            if (FFASlots[fs][fStatusTimer] != 0) KillTimer(FFASlots[fs][fStatusTimer]);
            if (FFASlots[fs][fCountdownTimer] != 0) KillTimer(FFASlots[fs][fCountdownTimer]);
            if (FFASlots[fs][fWaitTimer] != 0) KillTimer(FFASlots[fs][fWaitTimer]);
            FFASlots[fs][fActive] = 0;
            FFASlots[fs][fStarted] = false;
            FFASlots[fs][fWaiting] = false;
            FFASlots[fs][fVW] = -1;
            ffaTimeLeft[fs] = 0;
        }
    }
}

stock SummerEvent_OnPlayerDeath(playerid, killerid, reason) {
    #pragma unused reason
    new ds = PlayerData[playerid][pDuelSlot];
    if (ds != -1 && DuelSlots[ds][dActive] && DuelSlots[ds][dStarted]) {
        new opp = -1;
        if (DuelSlots[ds][dPlayer][0] == playerid) opp = DuelSlots[ds][dPlayer][1];
        else opp = DuelSlots[ds][dPlayer][0];
        if (opp != -1 && IsPlayerConnected(opp)) EndDuelForWinner(opp, playerid);
        return 1;
    }

    new fs = PlayerData[playerid][pFFASlot];
    if (fs != -1 && FFASlots[fs][fActive] && FFASlots[fs][fStarted]) {
        if (killerid != INVALID_PLAYER_ID && PlayerData[killerid][pFFASlot] == fs) {
            new pts = 2 + random(4);
            PlayerData[killerid][pFFAScore] += pts;
        }
        SetTimerEx("FFARespawn", 500, false, "ii", playerid, fs);
        return 1;
    }
    return 0;
}

public FFARespawn(playerid, slotid) {
    if (!IsPlayerConnected(playerid)) return 0;
    if (PlayerData[playerid][pFFASlot] != slotid) return 0;
    if (!FFASlots[slotid][fActive]) return 0;
    SpawnFFAPlayer(playerid, slotid);
    return 1;
}

stock SummerEvent_OnPlayerUpdate(playerid) {
    if (PlayerData[playerid][pMenuOpen]) return 1;

    new near = IsPlayerNearAnyNPC(playerid);

    if (near && !SummerNPC_IsNear[playerid]) {
        SummerNPC_IsNear[playerid] = true;
        OpenSummerMain(playerid);
    }

    if (!near && SummerNPC_IsNear[playerid]) {
        SummerNPC_IsNear[playerid] = false;
    }

    return 1;
}

stock SummerEvent_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    switch (dialogid) {
        case DIALOG_SUMMER_MAIN: {
            if (!response) {
                PlayerData[playerid][pMenuOpen] = false;
                return 0;
            }
            if (listitem == 0) OpenSummerDaily(playerid);
            else if (listitem == 1) OpenSummerMinigames(playerid);
            return 1;
        }
        case DIALOG_SUMMER_DAILY: {
            if (!response) {
                PlayerData[playerid][pMenuOpen] = false;
                OpenSummerMain(playerid);
                return 1;
            }
            new day = listitem;
            new now = gettime();
            if (day < PlayerData[playerid][pSummerDay]) {
                SendClientMessage(playerid, 0xFFFF00FF, "Эта награда уже получена.");
                OpenSummerDaily(playerid);
                return 1;
            }
            if (day > PlayerData[playerid][pSummerDay]) {
                SendClientMessage(playerid, 0xFF0000FF, "Эта награда ещё недоступна.");
                OpenSummerDaily(playerid);
                return 1;
            }
            if (day > 0) {
                new diff = PlayerData[playerid][pRewardTime] + DAILY_COOLDOWN - now;
                if (diff > 0) {
                    new hh = diff / 3600;
                    new mm = (diff % 3600) / 60;
                    new msg[128];
                    format(msg, sizeof(msg), "Ожидайте ещё %dч %dм.", hh, mm);
                    SendClientMessage(playerid, 0xFFFF00FF, msg);
                    OpenSummerDaily(playerid);
                    return 1;
                }
            }
            new reward = DailyRewards[day];
            GivePlayerVirts(playerid, reward);
            PlayerData[playerid][pSummerDay]  = day + 1;
            PlayerData[playerid][pRewardTime] = now;

            new pname[MAX_PLAYER_NAME];
            GetPlayerName(playerid, pname, sizeof(pname));
            new annmsg[256];
            format(annmsg, sizeof(annmsg),
                "{FFD700}Игрок {FFFFFF}%s {FFD700}получил награду дня %d - %d руб. в Летнем Ивенте!",
                pname, day + 1, reward);
            SendClientMessageToAll(0xFFD700FF, annmsg);

            OpenSummerDaily(playerid);
            return 1;
        }
        case DIALOG_SUMMER_MINIGAMES: {
            if (!response) {
                PlayerData[playerid][pMenuOpen] = false;
                OpenSummerMain(playerid);
                return 1;
            }
            if (listitem == 0) {
                if (IsPlayerInDuel(playerid)) {
                    SendClientMessage(playerid, 0xFF0000FF, "Вы уже участвуете в дуэли.");
                    return 1;
                }
                if (IsPlayerInFFA(playerid)) {
                    SendClientMessage(playerid, 0xFF0000FF, "Вы уже участвуете в FFA.");
                    return 1;
                }
                JoinDuel(playerid);
            } else if (listitem == 1) {
                if (IsPlayerInFFA(playerid)) {
                    SendClientMessage(playerid, 0xFF0000FF, "Вы уже участвуете в FFA.");
                    return 1;
                }
                if (IsPlayerInDuel(playerid)) {
                    SendClientMessage(playerid, 0xFF0000FF, "Вы уже участвуете в дуэли.");
                    return 1;
                }
                JoinFFA(playerid);
            }
            return 1;
        }
        case DIALOG_DUEL_WIN: {
            PlayerData[playerid][pMenuOpen] = false;
            return 1;
        }
        case DIALOG_FFA_WIN: {
            PlayerData[playerid][pMenuOpen] = false;
            return 1;
        }
    }
    return 0;
}
