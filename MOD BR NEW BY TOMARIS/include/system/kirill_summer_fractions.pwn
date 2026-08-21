

#if defined _KIRILL_SUMMER_FRACTIONS_INCLUDED
    #endinput
#endif
#define _KIRILL_SUMMER_FRACTIONS_INCLUDED

#define KSM_DIALOG_MAIN             (29100)
#define KSM_DIALOG_INFO             (29101)
#define KSM_DIALOG_TOP              (29102)
#define KSM_DIALOG_ADMIN            (29103)

#define KFRAC_DIALOG_MAIN           (29200)
#define KFRAC_DIALOG_INFO           (29201)
#define KFRAC_DIALOG_ONLINE         (29202)
#define KFRAC_DIALOG_HELP           (29203)
#define KFRAC_DIALOG_INVITE         (29204)
#define KFRAC_DIALOG_UNINVITE       (29205)
#define KFRAC_DIALOG_RANK           (29206)
#define KFRAC_DIALOG_SKIN           (29207)
#define KFRAC_DIALOG_LEADERS        (29208)

#define KSM_MAX_ITEMS               (5)
#define KSM_REWARD_MIN              (15000)
#define KSM_REWARD_RANDOM           (20000)
#define KSM_REWARD_EXP              (5)

new bool:KSM_EventActive = true;
new KSM_PlayerStage[MAX_PLAYERS];
new bool:KSM_PlayerStarted[MAX_PLAYERS];
new KSM_PlayerCollected[MAX_PLAYERS];
new KSM_PlayerDone[MAX_PLAYERS];
new KSM_PlayerCP[MAX_PLAYERS] = {-1, ...};
new KSM_PlayerVehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};

#define KSM_QUEST_VEHICLE_ID        (522)   // NRG-500

new KSM_StartPickup = -1;
new Text3D:KSM_StartLabel = Text3D:INVALID_3DTEXT_ID;
new Text3D:KSM_ItemLabel[KSM_MAX_ITEMS] = {Text3D:INVALID_3DTEXT_ID, ...};

new const Float:KSM_StartPos[4] = {-1874.910522, 1123.925048, 3.857832, 353.861053};
new const Float:KSM_ItemPos[KSM_MAX_ITEMS][3] =
{
    {-1856.530029, 1120.341918, 4.097004},
    {-1831.740478, 1077.455688, 5.839086},
    {-1908.747192, 918.066040, 22.393499},
    {-1731.325805, 925.653259, 16.998367},
    {-1634.259887, 958.615173, 9.369895}
};

new const KSM_ItemName[KSM_MAX_ITEMS][32] =
{
    "пляжный мяч",
    "ящик лимонада",
    "надувной круг",
    "ракушки",
    "морской сувенир"
};

stock KSummer_Init()
{
    KSummer_CreateWorld();
    printf("[Kirill Summer] summer event loaded");
    return 1;
}

stock KSummer_CreateWorld()
{
    if(KSM_StartPickup != -1)
    {
        DestroyDynamicPickup(KSM_StartPickup);
        KSM_StartPickup = -1;
    }
    if(IsValidDynamic3DTextLabel(KSM_StartLabel))
    {
        DestroyDynamic3DTextLabel(KSM_StartLabel);
        KSM_StartLabel = Text3D:INVALID_3DTEXT_ID;
    }
    for(new i = 0; i < KSM_MAX_ITEMS; i++)
    {
        if(IsValidDynamic3DTextLabel(KSM_ItemLabel[i]))
        {
            DestroyDynamic3DTextLabel(KSM_ItemLabel[i]);
            KSM_ItemLabel[i] = Text3D:INVALID_3DTEXT_ID;
        }
    }

    KSM_StartPickup = CreateDynamicPickup(1239, 23, KSM_StartPos[0], KSM_StartPos[1], KSM_StartPos[2], -1, -1, -1, 100.0);

    new label[256];
    format(label, sizeof(label), "{FFCC33}Летний ивент: Солнечный берег\n{FFFFFF}Команды: {66CCFF}/summer {FFFFFF}и {66CCFF}/gosummer\n{BDBDBD}Соберите 5 летних предметов и получите награду");
    KSM_StartLabel = CreateDynamic3DTextLabel(label, 0xFFFFFFFF, KSM_StartPos[0], KSM_StartPos[1], KSM_StartPos[2] + 1.0, 20.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);

    for(new i = 0; i < KSM_MAX_ITEMS; i++)
    {
        format(label, sizeof(label), "{FFCC33}Летний предмет\n{FFFFFF}%s", KSM_ItemName[i]);
        KSM_ItemLabel[i] = CreateDynamic3DTextLabel(label, 0xFFFFFFFF, KSM_ItemPos[i][0], KSM_ItemPos[i][1], KSM_ItemPos[i][2] + 0.8, 12.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1, -1, 100.0);
    }
    return 1;
}

stock KSummer_OnPlayerConnect(playerid)
{
    KSM_PlayerStage[playerid] = 0;
    KSM_PlayerStarted[playerid] = false;
    KSM_PlayerCollected[playerid] = 0;
    KSM_PlayerDone[playerid] = 0;
    KSM_PlayerCP[playerid] = -1;
    KSM_PlayerVehicle[playerid] = INVALID_VEHICLE_ID;
    return 1;
}

stock KSummer_ResetPlayer(playerid)
{
    if(KSM_PlayerCP[playerid] != -1)
    {
        DestroyDynamicCP(KSM_PlayerCP[playerid]);
        KSM_PlayerCP[playerid] = -1;
    }
    KSM_PlayerStage[playerid] = 0;
    KSM_PlayerStarted[playerid] = false;
    KSummer_DestroyVehicle(playerid);
    return 1;
}

// fix: gives the player a fresh event motorcycle (ID 522 / NRG-500) right where
// they're standing when they start the quest, and puts them straight in the driver seat.
// Destroys any leftover event vehicle first so players can never end up with two of them.
stock KSummer_GiveVehicle(playerid)
{
    KSummer_DestroyVehicle(playerid);

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    KSM_PlayerVehicle[playerid] = CreateVehicle(KSM_QUEST_VEHICLE_ID, x, y, z, a, -1, -1, 60000, 0);
    PutPlayerInVehicle(playerid, KSM_PlayerVehicle[playerid], 0);
    return 1;
}

stock KSummer_DestroyVehicle(playerid)
{
    if(KSM_PlayerVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(KSM_PlayerVehicle[playerid]);
        KSM_PlayerVehicle[playerid] = INVALID_VEHICLE_ID;
    }
    return 1;
}

stock KSummer_ShowMenu(playerid)
{
    new text[512];
    format(text, sizeof(text),
        "Начать летний квест\nТелепортироваться на пляж\nИнформация\nТоп участников\nСтатус: %s",
        KSM_EventActive ? ("активен") : ("выключен"));
    ShowPlayerDialog(playerid, KSM_DIALOG_MAIN, DIALOG_STYLE_LIST, "Летний ивент", text, "Выбрать", "Закрыть");
    return 1;
}

stock KSummer_ShowInfo(playerid)
{
    new text[900], ksf_line[160];
    text[0] = EOS;
    strcat(text, "{FFCC33}Солнечный берег{FFFFFF}\n\n", sizeof(text));
    strcat(text, "1. Приезжаете на пляж командой {66CCFF}/gosummer{FFFFFF}.\n", sizeof(text));
    strcat(text, "2. Берете задание у летнего промоутера через {66CCFF}/summer{FFFFFF}.\n", sizeof(text));
    strcat(text, "3. Собираете 5 предметов: мяч, лимонад, круг, ракушки и сувенир.\n", sizeof(text));
    strcat(text, "4. Получаете деньги и опыт.\n\n", sizeof(text));
    format(ksf_line, sizeof(ksf_line), "Награда: от %d до %d рублей и +%d EXP.\n", KSM_REWARD_MIN, KSM_REWARD_MIN + KSM_REWARD_RANDOM, KSM_REWARD_EXP);
    strcat(text, ksf_line, sizeof(text));
    strcat(text, "Повторное прохождение доступно после перезахода/рестарта, если админ не выключил ивент.", sizeof(text));
    ShowPlayerDialog(playerid, KSM_DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Информация об ивенте", text, "Назад", "Закрыть");
    return 1;
}

stock KSummer_Teleport(playerid)
{
    if(!KSM_EventActive)
        return SendClientMessage(playerid, 0xCECECEFF, "Летний ивент сейчас выключен администрацией.");

    if(IsPlayerInAnyVehicle(playerid))
        RemovePlayerFromVehicle(playerid);

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, KSM_StartPos[0], KSM_StartPos[1], KSM_StartPos[2]);
    SetPlayerFacingAngle(playerid, KSM_StartPos[3]);
    SendClientMessage(playerid, 0xFFCC33FF, "Вы прибыли на летний пляж. Используйте /summer, чтобы начать квест.");
    return 1;
}

stock KSummer_StartQuest(playerid)
{
    if(!KSM_EventActive)
        return SendClientMessage(playerid, 0xCECECEFF, "Летний ивент сейчас выключен администрацией.");

    if(KSM_PlayerStarted[playerid])
        return SendClientMessage(playerid, 0xCECECEFF, "Вы уже проходите летний квест. Следуйте к чекпоинту.");

    if(!IsPlayerInRangeOfPoint(playerid, 35.0, KSM_StartPos[0], KSM_StartPos[1], KSM_StartPos[2]))
        return SendClientMessage(playerid, 0xCECECEFF, "Сначала приезжайте на пляж командой /gosummer.");

    KSM_PlayerStarted[playerid] = true;
    KSM_PlayerStage[playerid] = 0;
    KSummer_GiveVehicle(playerid);
    KSummer_CreateNextCP(playerid);
    SendClientMessage(playerid, 0xFFCC33FF, "Летний квест начат! Соберите все предметы по чекпоинтам.");
    SendClientMessage(playerid, 0xFFCC33FF, "Вам выдан мотоцикл для летнего ивента.");
    return 1;
}

stock KSummer_CreateNextCP(playerid)
{
    if(KSM_PlayerCP[playerid] != -1)
    {
        DestroyDynamicCP(KSM_PlayerCP[playerid]);
        KSM_PlayerCP[playerid] = -1;
    }

    new stage = KSM_PlayerStage[playerid];
    if(stage < 0 || stage >= KSM_MAX_ITEMS) return 0;

    KSM_PlayerCP[playerid] = CreateDynamicCP(KSM_ItemPos[stage][0], KSM_ItemPos[stage][1], KSM_ItemPos[stage][2], 2.0, 0, 0, playerid, 100.0);

    new msg[128];
    format(msg, sizeof(msg), "Летний квест: найдите %s [%d/%d].", KSM_ItemName[stage], stage + 1, KSM_MAX_ITEMS);
    SendClientMessage(playerid, 0x66CCFFFF, msg);
    return 1;
}

stock KSummer_OnPlayerEnterDynamicCP(playerid, checkpointid)
{
    if(!KSM_PlayerStarted[playerid]) return 0;
    if(checkpointid != KSM_PlayerCP[playerid]) return 0;

    new stage = KSM_PlayerStage[playerid];
    if(stage < 0 || stage >= KSM_MAX_ITEMS) return 1;

    new msg[144];
    format(msg, sizeof(msg), "Вы нашли %s. Осталось предметов: %d.", KSM_ItemName[stage], KSM_MAX_ITEMS - stage - 1);
    SendClientMessage(playerid, 0xFFCC33FF, msg);

    DestroyDynamicCP(KSM_PlayerCP[playerid]);
    KSM_PlayerCP[playerid] = -1;

    KSM_PlayerStage[playerid]++;
    KSM_PlayerCollected[playerid]++;

    if(KSM_PlayerStage[playerid] >= KSM_MAX_ITEMS)
    {
        KSummer_FinishQuest(playerid);
    }
    else
    {
        KSummer_CreateNextCP(playerid);
    }
    return 1;
}

stock KSummer_FinishQuest(playerid)
{
    new reward = KSM_REWARD_MIN + random(KSM_REWARD_RANDOM + 1);
    GivePlayerMoneyEx(playerid, reward, "Summer event", true, true);
    AddPlayerData(playerid, P_EXP, +, KSM_REWARD_EXP);
    UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));

    KSM_PlayerDone[playerid]++;
    KSM_PlayerStarted[playerid] = false;
    KSM_PlayerStage[playerid] = 0;
    KSummer_DestroyVehicle(playerid);

    new msg[160];
    format(msg, sizeof(msg), "Поздравляем! Вы прошли летний ивент и получили %d рублей и +%d EXP.", reward, KSM_REWARD_EXP);
    SendClientMessage(playerid, 0x33CC66FF, msg);
    GameTextForPlayer(playerid, "~y~SUMMER EVENT~n~~w~QUEST COMPLETE", 4000, 1);
    return 1;
}

stock KSummer_ShowTop(playerid)
{
    new text[768], ksf_line[96], count;
    format(text, sizeof(text), "Игрок\tПредметы\tФиниши\n");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(KSM_PlayerCollected[i] <= 0 && KSM_PlayerDone[i] <= 0) continue;

        format(ksf_line, sizeof(ksf_line), "%s[%d]\t%d\t%d\n", GetPlayerNameEx(i), i, KSM_PlayerCollected[i], KSM_PlayerDone[i]);
        strcat(text, ksf_line, sizeof(text));
        count++;
        if(count >= 20) break;
    }

    if(!count) strcat(text, "Пока никто не участвовал\t0\t0\n", sizeof(text));
    ShowPlayerDialog(playerid, KSM_DIALOG_TOP, DIALOG_STYLE_TABLIST_HEADERS, "Топ летнего ивента", text, "Ок", "");
    return 1;
}

stock KSummer_SetActive(playerid, bool:status)
{
    KSM_EventActive = status;
    new msg[128];
    format(msg, sizeof(msg), "[Summer] Администратор %s[%d] %s летний ивент.", GetPlayerNameEx(playerid), playerid, status ? ("запустил") : ("остановил"));
    SendClientMessageToAll(0xFFCC33FF, msg);

    if(!status)
    {
        for(new i = 0; i < MAX_PLAYERS; i++)
        {
            if(IsPlayerConnected(i)) KSummer_ResetPlayer(i);
        }
    }
    return 1;
}

stock KSummer_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case KSM_DIALOG_MAIN:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0: KSummer_StartQuest(playerid);
                case 1: KSummer_Teleport(playerid);
                case 2: KSummer_ShowInfo(playerid);
                case 3: KSummer_ShowTop(playerid);
                case 4: KSummer_ShowInfo(playerid);
            }
            return 1;
        }
        case KSM_DIALOG_INFO, KSM_DIALOG_TOP:
        {
            if(response) KSummer_ShowMenu(playerid);
            return 1;
        }
    }
    return 0;
}

CMD:summer(playerid, params[])
{
    KSummer_ShowMenu(playerid);
    return 1;
}

CMD:gosummer(playerid, params[])
{
    KSummer_Teleport(playerid);
    return 1;
}

CMD:sumtop(playerid, params[])
{
    KSummer_ShowTop(playerid);
    return 1;
}

CMD:summerstart(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна администраторам 6+ уровня.");
    KSummer_SetActive(playerid, true);
    return 1;
}

CMD:summerstop(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна администраторам 6+ уровня.");
    KSummer_SetActive(playerid, false);
    return 1;
}

// ============================================================================
// Universal fraction system
// ============================================================================

stock KFrac_Init()
{
    printf("[Kirill Fraction] universal fraction panel loaded");
    return 1;
}

stock KFrac_IsValidTeam(teamid)
{
    return (teamid >= 1 && teamid < MAX_ORG);
}

stock KFrac_IsLeader(playerid)
{
    return (KFrac_IsValidTeam(GetPlayerTeamEx(playerid)) && GetPlayerJob(playerid) >= 9);
}

stock KFrac_CanManageRank(playerid, rank)
{
    if(!KFrac_IsLeader(playerid)) return 0;
    if(rank < 1 || rank > 9) return 0;
    if(rank >= GetPlayerJob(playerid)) return 0;
    return 1;
}

stock KFrac_ShowMenu(playerid)
{
    if(!KFrac_IsValidTeam(GetPlayerTeamEx(playerid)))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции.");

    new text[512];
    format(text, sizeof(text),
        "Информация о фракции\nОнлайн состав\nКоманды фракции\nНачать/закончить рабочий день\nСменить рабочий скин\nПригласить игрока\nУволить игрока\nИзменить ранг\nЛидеры всех фракций\nТелепорт на спавн фракции");
    ShowPlayerDialog(playerid, KFRAC_DIALOG_MAIN, DIALOG_STYLE_LIST, "Панель фракции", text, "Выбрать", "Закрыть");
    return 1;
}

stock KFrac_ShowInfo(playerid)
{
    new teamid = GetPlayerTeamEx(playerid);
    if(!KFrac_IsValidTeam(teamid)) return 0;

    new text[512], ksf_leader[64];
    if(strlen(g_organization[teamid][O_LEADER]))
    {
        format(ksf_leader, sizeof(ksf_leader), "%s", g_organization[teamid][O_LEADER]);
    }
    else
    {
        format(ksf_leader, sizeof(ksf_leader), "не назначен");
    }

    format(text, sizeof(text),
        "Фракция: {66CCFF}%s{FFFFFF}\nВаш ранг: {FFCC33}%d{FFFFFF} (%s)\nРабочий день: {FFCC33}%s{FFFFFF}\nЛидер: {FFCC33}%s{FFFFFF}\n\nКоманды: /fmenu, /fmembers, /fhelp, /fduty, /fspawn, /fskin.",
        g_organization[teamid][O_NAME], GetPlayerJob(playerid), GetPlayerJobAndRankName(playerid),
        GetPlayerData(playerid, P_WORK_DAY) ? ("начат") : ("не начат"),
        ksf_leader);
    ShowPlayerDialog(playerid, KFRAC_DIALOG_INFO, DIALOG_STYLE_MSGBOX, "Информация о фракции", text, "Назад", "Закрыть");
    return 1;
}

stock KFrac_ShowOnline(playerid)
{
    new teamid = GetPlayerTeamEx(playerid);
    if(!KFrac_IsValidTeam(teamid)) return 0;

    new text[2048], ksf_line[96], count;
    format(text, sizeof(text), "Игрок\tРанг\tСтатус\n");

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        if(GetPlayerTeamEx(i) != teamid) continue;

        format(ksf_line, sizeof(ksf_line), "%s[%d]\t%d\t%s\n", GetPlayerNameEx(i), i, GetPlayerJob(i), GetPlayerData(i, P_WORK_DAY) ? ("на смене") : ("не на смене"));
        strcat(text, ksf_line, sizeof(text));
        count++;
        if(count >= 20) break;
    }
    if(!count) strcat(text, "Нет сотрудников онлайн\t-\t-\n", sizeof(text));

    ShowPlayerDialog(playerid, KFRAC_DIALOG_ONLINE, DIALOG_STYLE_TABLIST_HEADERS, "Онлайн состав", text, "Назад", "Закрыть");
    return 1;
}

stock KFrac_ShowHelp(playerid)
{
    new text[1000];
    text[0] = EOS;
    strcat(text, "{FFCC33}/fmenu{FFFFFF} - панель фракции\n", sizeof(text));
    strcat(text, "{FFCC33}/fmembers{FFFFFF} - онлайн состав\n", sizeof(text));
    strcat(text, "{FFCC33}/fduty{FFFFFF} - начать/закончить рабочий день\n", sizeof(text));
    strcat(text, "{FFCC33}/fspawn{FFFFFF} - телепорт на спавн фракции\n", sizeof(text));
    strcat(text, "{FFCC33}/fskin [слот 1-10]{FFFFFF} - сменить рабочий скин\n", sizeof(text));
    strcat(text, "{FFCC33}/finvite [id] [ранг 1-9]{FFFFFF} - принять игрока во фракцию\n", sizeof(text));
    strcat(text, "{FFCC33}/funinvite [id] [причина]{FFFFFF} - уволить игрока\n", sizeof(text));
    strcat(text, "{FFCC33}/fsetrank [id] [ранг 1-9]{FFFFFF} - изменить ранг\n", sizeof(text));
    strcat(text, "{FFCC33}/r, /rn, /d{FFFFFF} - рация/департамент, если доступны в моде\n\n", sizeof(text));
    strcat(text, "Панель работает для всех организаций из MAX_ORG: правительство, армия, больница, СМИ, полиция, ФСБ, ФСИН и ОПГ.", sizeof(text));
    ShowPlayerDialog(playerid, KFRAC_DIALOG_HELP, DIALOG_STYLE_MSGBOX, "Команды фракции", text, "Назад", "Закрыть");
    return 1;
}

stock KFrac_ToggleDuty(playerid)
{
    if(!KFrac_IsValidTeam(GetPlayerTeamEx(playerid)))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции.");

    if(GetPlayerData(playerid, P_WORK_DAY))
    {
        SetPlayerData(playerid, P_WORK_DAY, 0);
        UpdatePlayerDatabaseInt(playerid, "work_day", 0);
        ResetSkin(playerid);
        SendClientMessage(playerid, 0xFFCC33FF, "Вы закончили рабочий день фракции.");
    }
    else
    {
        if(GetPlayerData(playerid, P_OSKIN) == 0) KFrac_ApplyRankSkin(playerid, GetPlayerTeamEx(playerid), GetPlayerJob(playerid));
        SetPlayerData(playerid, P_WORK_DAY, 1);
        UpdatePlayerDatabaseInt(playerid, "work_day", 1);
        ResetSkin(playerid);
        SendClientMessage(playerid, 0x33CC66FF, "Вы начали рабочий день фракции.");
    }
    return 1;
}

stock KFrac_ApplyRankSkin(playerid, teamid, rank)
{
    if(!KFrac_IsValidTeam(teamid)) return 0;

    new skinid = 0;
    if(GetPlayerSex(playerid))
    {
        skinid = g_organization[teamid][O_WOMEN_SKIN];
    }
    else
    {
        new slot = 0;
        if(rank >= 1 && rank <= 3) slot = 0;
        else if(rank >= 4 && rank <= 7) slot = 1;
        else if(rank >= 8 && rank <= 9) slot = 2;
        else if(rank >= 10) slot = 3;

        skinid = g_organization[teamid][O_SKINS][slot];
        if(skinid == 0) skinid = g_organization[teamid][O_SKINS][0];
    }

    if(skinid == 0) return 0;

    SetPlayerData(playerid, P_OSKIN, skinid);
    UpdatePlayerDatabaseInt(playerid, "org_skin", skinid);
    if(GetPlayerData(playerid, P_WORK_DAY)) SetPlayerSkin(playerid, skinid);
    return 1;
}

stock KFrac_SetSkinBySlot(playerid, slot)
{
    new teamid = GetPlayerTeamEx(playerid);
    if(!KFrac_IsValidTeam(teamid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции.");
    if(slot < 1 || slot > 10) return SendClientMessage(playerid, 0xCECECEFF, "Слот скина должен быть от 1 до 10.");

    new skinid;
    if(GetPlayerSex(playerid)) skinid = g_organization[teamid][O_WOMEN_SKIN];
    else skinid = g_organization[teamid][O_SKINS][slot - 1];

    if(skinid == 0) return SendClientMessage(playerid, 0xCECECEFF, "В этом слоте нет рабочего скина.");

    SetPlayerData(playerid, P_OSKIN, skinid);
    UpdatePlayerDatabaseInt(playerid, "org_skin", skinid);
    if(GetPlayerData(playerid, P_WORK_DAY)) SetPlayerSkin(playerid, skinid);

    new msg[96];
    format(msg, sizeof(msg), "Вы выбрали рабочий скин ID %d.", skinid);
    SendClientMessage(playerid, 0x33CC66FF, msg);
    return 1;
}

stock KFrac_ShowSkinDialog(playerid)
{
    new teamid = GetPlayerTeamEx(playerid);
    if(!KFrac_IsValidTeam(teamid)) return 0;

    new text[512], ksf_line[64], count;
    text[0] = EOS;

    if(GetPlayerSex(playerid))
    {
        format(text, sizeof(text), "Женский скин\tID %d\n", g_organization[teamid][O_WOMEN_SKIN]);
        ShowPlayerDialog(playerid, KFRAC_DIALOG_SKIN, DIALOG_STYLE_TABLIST, "Скины фракции", text, "Выбрать", "Назад");
        return 1;
    }

    for(new i = 0; i < 10; i++)
    {
        if(g_organization[teamid][O_SKINS][i] == 0) continue;
        format(ksf_line, sizeof(ksf_line), "Слот %d\tID %d\n", i + 1, g_organization[teamid][O_SKINS][i]);
        strcat(text, ksf_line, sizeof(text));
        SetPlayerListitemValue(playerid, count, i + 1);
        count++;
    }
    if(!count) strcat(text, "Нет доступных скинов\t-\n", sizeof(text));

    ShowPlayerDialog(playerid, KFRAC_DIALOG_SKIN, DIALOG_STYLE_TABLIST, "Скины фракции", text, "Выбрать", "Назад");
    return 1;
}

stock KFrac_TeleportSpawn(playerid)
{
    new teamid = GetPlayerTeamEx(playerid);
    if(!KFrac_IsValidTeam(teamid)) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции.");
    if(IsPlayerInAnyVehicle(playerid)) RemovePlayerFromVehicle(playerid);

    SetPlayerInterior(playerid, g_organization[teamid][O_SPAWN_INT]);
    SetPlayerVirtualWorld(playerid, g_organization[teamid][O_SPAWN_VW]);
    SetPlayerPos(playerid, g_organization[teamid][O_SPAWN][0], g_organization[teamid][O_SPAWN][1], g_organization[teamid][O_SPAWN][2]);
    SetPlayerFacingAngle(playerid, g_organization[teamid][O_SPAWN][3]);
    SendClientMessage(playerid, 0x33CC66FF, "Вы телепортированы на спавн своей фракции.");
    return 1;
}

stock KFrac_Invite(playerid, to_player, rank)
{
    if(!KFrac_IsValidTeam(GetPlayerTeamEx(playerid))) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции.");
    if(!KFrac_CanManageRank(playerid, rank)) return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно прав или неверный ранг. Можно выдавать только ранг ниже своего.");
    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");
    if(KFrac_IsValidTeam(GetPlayerTeamEx(to_player))) return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок уже состоит во фракции.");

    InvitePlayer(to_player, GetPlayerTeamEx(playerid), rank, true);

    new msg[160];
    format(msg, sizeof(msg), "Вы приняли %s[%d] во фракцию %s на %d ранг.", GetPlayerNameEx(to_player), to_player, g_organization[GetPlayerTeamEx(playerid)][O_NAME], rank);
    SendClientMessage(playerid, 0x33CC66FF, msg);
    format(msg, sizeof(msg), "%s[%d] принял Вас во фракцию %s на %d ранг.", GetPlayerNameEx(playerid), playerid, g_organization[GetPlayerTeamEx(playerid)][O_NAME], rank);
    SendClientMessage(to_player, 0x33CC66FF, msg);
    return 1;
}

stock KFrac_Uninvite(playerid, to_player, reason[])
{
    if(!KFrac_IsLeader(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Команда доступна лидеру/заместителю фракции.");
    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");
    if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не состоит в вашей фракции.");
    if(GetPlayerJob(to_player) >= GetPlayerJob(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя уволить сотрудника с равным или более высоким рангом.");

    UnInvite(playerid, to_player, reason);
    return 1;
}

stock KFrac_SetRank(playerid, to_player, rank)
{
    if(!KFrac_IsValidTeam(GetPlayerTeamEx(playerid))) return SendClientMessage(playerid, 0xCECECEFF, "Вы не состоите во фракции.");
    if(!KFrac_CanManageRank(playerid, rank)) return SendClientMessage(playerid, 0xCECECEFF, "Недостаточно прав или неверный ранг. Можно выдавать только ранг ниже своего.");
    if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не найден или не авторизован.");
    if(GetPlayerTeamEx(to_player) != GetPlayerTeamEx(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок не состоит в вашей фракции.");
    if(GetPlayerJob(to_player) >= GetPlayerJob(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Нельзя менять ранг сотруднику с равным или более высоким рангом.");

    InvitePlayer(to_player, GetPlayerTeamEx(playerid), rank, true);
    KFrac_ApplyRankSkin(to_player, GetPlayerTeamEx(playerid), rank);

    new msg[160];
    format(msg, sizeof(msg), "Вы изменили ранг %s[%d] на %d.", GetPlayerNameEx(to_player), to_player, rank);
    SendClientMessage(playerid, 0x33CC66FF, msg);
    format(msg, sizeof(msg), "%s[%d] изменил Ваш ранг во фракции на %d.", GetPlayerNameEx(playerid), playerid, rank);
    SendClientMessage(to_player, 0x33CC66FF, msg);
    return 1;
}

stock KFrac_ShowLeaders(playerid)
{
    new text[2048], ksf_line[96];
    format(text, sizeof(text), "Фракция\tЛидер\n");
    for(new i = 1; i < MAX_ORG; i++)
    {
        new ksf_leader[64];
        if(strlen(g_organization[i][O_LEADER]))
        {
            format(ksf_leader, sizeof(ksf_leader), "%s", g_organization[i][O_LEADER]);
        }
        else
        {
            format(ksf_leader, sizeof(ksf_leader), "нет");
        }
        format(ksf_line, sizeof(ksf_line), "%s\t%s\n", g_organization[i][O_NAME], ksf_leader);
        strcat(text, ksf_line, sizeof(text));
    }
    ShowPlayerDialog(playerid, KFRAC_DIALOG_LEADERS, DIALOG_STYLE_TABLIST_HEADERS, "Лидеры фракций", text, "Назад", "Закрыть");
    return 1;
}

stock KFrac_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case KFRAC_DIALOG_MAIN:
        {
            if(!response) return 1;
            switch(listitem)
            {
                case 0: KFrac_ShowInfo(playerid);
                case 1: KFrac_ShowOnline(playerid);
                case 2: KFrac_ShowHelp(playerid);
                case 3: KFrac_ToggleDuty(playerid);
                case 4: KFrac_ShowSkinDialog(playerid);
                case 5:
                {
                    if(!KFrac_IsLeader(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Доступно только лидеру/заместителю.");
                    ShowPlayerDialog(playerid, KFRAC_DIALOG_INVITE, DIALOG_STYLE_INPUT, "Принять во фракцию", "Введите: ID игрока и ранг 1-9\nПример: 12 1", "Принять", "Назад");
                }
                case 6:
                {
                    if(!KFrac_IsLeader(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Доступно только лидеру/заместителю.");
                    ShowPlayerDialog(playerid, KFRAC_DIALOG_UNINVITE, DIALOG_STYLE_INPUT, "Уволить из фракции", "Введите: ID игрока и причина\nПример: 12 прогул", "Уволить", "Назад");
                }
                case 7:
                {
                    if(!KFrac_IsLeader(playerid)) return SendClientMessage(playerid, 0xCECECEFF, "Доступно только лидеру/заместителю.");
                    ShowPlayerDialog(playerid, KFRAC_DIALOG_RANK, DIALOG_STYLE_INPUT, "Изменить ранг", "Введите: ID игрока и новый ранг 1-9\nПример: 12 5", "Изменить", "Назад");
                }
                case 8: KFrac_ShowLeaders(playerid);
                case 9: KFrac_TeleportSpawn(playerid);
            }
            return 1;
        }
        case KFRAC_DIALOG_INFO, KFRAC_DIALOG_ONLINE, KFRAC_DIALOG_HELP, KFRAC_DIALOG_LEADERS:
        {
            if(response) KFrac_ShowMenu(playerid);
            return 1;
        }
        case KFRAC_DIALOG_SKIN:
        {
            if(!response) return KFrac_ShowMenu(playerid);
            if(GetPlayerSex(playerid)) KFrac_SetSkinBySlot(playerid, 1);
            else KFrac_SetSkinBySlot(playerid, GetPlayerListitemValue(playerid, listitem));
            return 1;
        }
        case KFRAC_DIALOG_INVITE:
        {
            if(!response) return KFrac_ShowMenu(playerid);
            new to_player, rank;
            if(sscanf(inputtext, "ui", to_player, rank)) return SendClientMessage(playerid, 0xCECECEFF, "Введите ID игрока и ранг. Пример: 12 1");
            KFrac_Invite(playerid, to_player, rank);
            return 1;
        }
        case KFRAC_DIALOG_UNINVITE:
        {
            if(!response) return KFrac_ShowMenu(playerid);
            new to_player, reason[64];
            if(sscanf(inputtext, "us[64]", to_player, reason)) return SendClientMessage(playerid, 0xCECECEFF, "Введите ID игрока и причину. Пример: 12 прогул");
            KFrac_Uninvite(playerid, to_player, reason);
            return 1;
        }
        case KFRAC_DIALOG_RANK:
        {
            if(!response) return KFrac_ShowMenu(playerid);
            new to_player, rank;
            if(sscanf(inputtext, "ui", to_player, rank)) return SendClientMessage(playerid, 0xCECECEFF, "Введите ID игрока и ранг. Пример: 12 5");
            KFrac_SetRank(playerid, to_player, rank);
            return 1;
        }
    }
    return 0;
}

CMD:fmenu(playerid, params[])
{
    KFrac_ShowMenu(playerid);
    return 1;
}

CMD:fpanel(playerid, params[])
{
    KFrac_ShowMenu(playerid);
    return 1;
}

CMD:fmembers(playerid, params[])
{
    KFrac_ShowOnline(playerid);
    return 1;
}

CMD:kfhelp(playerid, params[])
{
    KFrac_ShowHelp(playerid);
    return 1;
}

CMD:fduty(playerid, params[])
{
    KFrac_ToggleDuty(playerid);
    return 1;
}

CMD:fspawn(playerid, params[])
{
    KFrac_TeleportSpawn(playerid);
    return 1;
}

CMD:fskin(playerid, params[])
{
    new slot;
    if(sscanf(params, "i", slot)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fskin [слот 1-10]");
    KFrac_SetSkinBySlot(playerid, slot);
    return 1;
}

CMD:finvite(playerid, params[])
{
    new to_player, rank;
    if(sscanf(params, "ui", to_player, rank)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /finvite [id] [ранг 1-9]");
    KFrac_Invite(playerid, to_player, rank);
    return 1;
}

CMD:funinvite(playerid, params[])
{
    new to_player, reason[64];
    if(sscanf(params, "us[64]", to_player, reason)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /funinvite [id] [причина]");
    KFrac_Uninvite(playerid, to_player, reason);
    return 1;
}

CMD:fsetrank(playerid, params[])
{
    new to_player, rank;
    if(sscanf(params, "ui", to_player, rank)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /fsetrank [id] [ранг 1-9]");
    KFrac_SetRank(playerid, to_player, rank);
    return 1;
}
