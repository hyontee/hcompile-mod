#if defined _SANDER_HOSPITAL_BEDS_INC
    #endinput
#endif
#define _SANDER_HOSPITAL_BEDS_INC

#define SANDER_HOSPITAL_BEDS_COUNT      (4)
#define SANDER_HOSPITAL_BED_HEAL_STEP   (1.0)
#define SANDER_HOSPITAL_BED_HEAL_TIME   (2000)

new PlayerText:g_hospital_bed_heal_td[MAX_PLAYERS] = {PlayerText:INVALID_TEXT_DRAW, ...};
new bool:g_hospital_bed_healing[MAX_PLAYERS];
new g_hospital_bed_timer[MAX_PLAYERS];
new g_hospital_bed_current[MAX_PLAYERS] = {-1, ...};
new g_hospital_bed_player[SANDER_HOSPITAL_BEDS_COUNT] = {INVALID_PLAYER_ID, ...};
new Text3D:g_hospital_bed_label[SANDER_HOSPITAL_BEDS_COUNT];

new const Float:g_hospital_bed_pos[SANDER_HOSPITAL_BEDS_COUNT][3] =
{
    {1487.048095, 2496.719238, 2501.641113},
    {1486.824340, 2492.791992, 2501.641113},
    {1482.889892, 2492.481445, 2501.641113},
    {1482.538940, 2496.288574, 2501.641113}
};

forward HospitalBeds_CheckPlayersNearBeds();
forward HospitalBeds_HealPlayerTimer(playerid);
forward HospitalBeds_HideHealingText(playerid);

stock HospitalBeds_OnGameModeInit()
{
    SetTimer("HospitalBeds_CheckPlayersNearBeds", 1000, true);

    for(new i = 0; i < SANDER_HOSPITAL_BEDS_COUNT; i++)
    {
        g_hospital_bed_player[i] = INVALID_PLAYER_ID;
        HospitalBeds_CreateOrUpdateLabel(i);
    }

    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        g_hospital_bed_heal_td[playerid] = PlayerText:INVALID_TEXT_DRAW;
        g_hospital_bed_current[playerid] = -1;
        g_hospital_bed_healing[playerid] = false;
        g_hospital_bed_timer[playerid] = 0;
    }
    return 1;
}

stock HospitalBeds_OnPlayerSpawn(playerid)
{
    HospitalBeds_StopHealing(playerid, true);
    return 1;
}

stock HospitalBeds_OnPlayerDisconnect(playerid)
{
    HospitalBeds_StopHealing(playerid, true);

    if(g_hospital_bed_heal_td[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, g_hospital_bed_heal_td[playerid]);
        g_hospital_bed_heal_td[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    return 1;
}

stock HospitalBeds_CreateOrUpdateLabel(bedid)
{
    if(!(0 <= bedid < SANDER_HOSPITAL_BEDS_COUNT)) return 0;

    new text[512];

    if(g_hospital_bed_player[bedid] != INVALID_PLAYER_ID && IsPlayerConnected(g_hospital_bed_player[bedid]))
    {
        format(text, sizeof text,
            "{FFFF00}« Занятая больничная койка »\n\n\
{00FF00}| {FFFFFF}Номер койки: {FFFF00}%d\n\
{00FF00}| {FFFFFF}Пациент: {FFFF00}%s\n\n\
{AAAAAA}Подойдите ближе для взаимодействия\nс больничной койкой",
            bedid + 1,
            GetPlayerNameEx(g_hospital_bed_player[bedid])
        );
    }
    else
    {
        g_hospital_bed_player[bedid] = INVALID_PLAYER_ID;
        format(text, sizeof text,
            "{FFFF00}« Свободная больничная койка »\n\n\
{00FF00}| {FFFFFF}Номер койки: {FFFF00}%d\n\
{00FF00}| {FFFFFF}Пациент: {FFFF00}отсутствует\n\n\
{AAAAAA}Подойдите ближе для взаимодействия\nс больничной койкой",
            bedid + 1
        );
    }

    if(g_hospital_bed_label[bedid])
    {
        UpdateDynamic3DTextLabelText(g_hospital_bed_label[bedid], 0xFFFFFFFF, text);
    }
    else
    {
        g_hospital_bed_label[bedid] = CreateDynamic3DTextLabel(
            text,
            0xFFFFFFFF,
            g_hospital_bed_pos[bedid][0],
            g_hospital_bed_pos[bedid][1],
            g_hospital_bed_pos[bedid][2],
            3.0,
            INVALID_PLAYER_ID,
            INVALID_VEHICLE_ID,
            1,
            -1,
            -1,
            -1,
            5.0
        );
    }
    return 1;
}

stock HospitalBeds_GetNearBed(playerid)
{
    for(new i = 0; i < SANDER_HOSPITAL_BEDS_COUNT; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, g_hospital_bed_pos[i][0], g_hospital_bed_pos[i][1], g_hospital_bed_pos[i][2]))
        {
            return i;
        }
    }
    return -1;
}

stock HospitalBeds_IsBedBusy(bedid)
{
    if(!(0 <= bedid < SANDER_HOSPITAL_BEDS_COUNT)) return true;

    new patient = g_hospital_bed_player[bedid];
    if(patient == INVALID_PLAYER_ID) return false;
    if(!IsPlayerConnected(patient))
    {
        g_hospital_bed_player[bedid] = INVALID_PLAYER_ID;
        HospitalBeds_CreateOrUpdateLabel(bedid);
        return false;
    }
    return true;
}

stock HospitalBeds_TakeBed(bedid, playerid)
{
    if(!(0 <= bedid < SANDER_HOSPITAL_BEDS_COUNT)) return 0;

    g_hospital_bed_player[bedid] = playerid;
    g_hospital_bed_current[playerid] = bedid;
    HospitalBeds_CreateOrUpdateLabel(bedid);
    return 1;
}

stock HospitalBeds_FreeBed(bedid)
{
    if(!(0 <= bedid < SANDER_HOSPITAL_BEDS_COUNT)) return 0;

    g_hospital_bed_player[bedid] = INVALID_PLAYER_ID;
    HospitalBeds_CreateOrUpdateLabel(bedid);
    return 1;
}

stock HospitalBeds_StopHealing(playerid, bool:free_bed)
{
    if(g_hospital_bed_timer[playerid] != 0)
    {
        KillTimer(g_hospital_bed_timer[playerid]);
        g_hospital_bed_timer[playerid] = 0;
    }

    g_hospital_bed_healing[playerid] = false;

    if(g_hospital_bed_heal_td[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawHide(playerid, g_hospital_bed_heal_td[playerid]);
    }

    if(free_bed)
    {
        new bedid = g_hospital_bed_current[playerid];
        if(0 <= bedid < SANDER_HOSPITAL_BEDS_COUNT)
        {
            if(g_hospital_bed_player[bedid] == playerid) HospitalBeds_FreeBed(bedid);
        }
        g_hospital_bed_current[playerid] = -1;
    }
    return 1;
}

stock HospitalBeds_ShowHealingEffect(playerid)
{
    if(g_hospital_bed_heal_td[playerid] == PlayerText:INVALID_TEXT_DRAW)
    {
        g_hospital_bed_heal_td[playerid] = CreatePlayerTextDraw(playerid, 320.0, 300.0, "+1 HP");
        PlayerTextDrawFont(playerid, g_hospital_bed_heal_td[playerid], 3);
        PlayerTextDrawLetterSize(playerid, g_hospital_bed_heal_td[playerid], 0.6, 2.0);
        PlayerTextDrawColor(playerid, g_hospital_bed_heal_td[playerid], 0x33FF33FF);
        PlayerTextDrawAlignment(playerid, g_hospital_bed_heal_td[playerid], 2);
        PlayerTextDrawBackgroundColor(playerid, g_hospital_bed_heal_td[playerid], 0x00000000);
        PlayerTextDrawSetOutline(playerid, g_hospital_bed_heal_td[playerid], 1);
        PlayerTextDrawSetProportional(playerid, g_hospital_bed_heal_td[playerid], 1);
    }

    PlayerTextDrawShow(playerid, g_hospital_bed_heal_td[playerid]);
    SetTimerEx("HospitalBeds_HideHealingText", 500, false, "i", playerid);
    return 1;
}

public HospitalBeds_HideHealingText(playerid)
{
    if(IsPlayerConnected(playerid) && g_hospital_bed_heal_td[playerid] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawHide(playerid, g_hospital_bed_heal_td[playerid]);
    }
    return 1;
}

public HospitalBeds_HealPlayerTimer(playerid)
{
    if(!IsPlayerConnected(playerid) || !g_hospital_bed_healing[playerid])
    {
        HospitalBeds_StopHealing(playerid, true);
        return 1;
    }

    new bedid = g_hospital_bed_current[playerid];
    if(!(0 <= bedid < SANDER_HOSPITAL_BEDS_COUNT) || g_hospital_bed_player[bedid] != playerid)
    {
        HospitalBeds_StopHealing(playerid, true);
        return 1;
    }

    if(!IsPlayerInRangeOfPoint(playerid, 2.5, g_hospital_bed_pos[bedid][0], g_hospital_bed_pos[bedid][1], g_hospital_bed_pos[bedid][2]))
    {
        HospitalBeds_StopHealing(playerid, true);
        ShowNotificationSander(playerid, 2, 4, 0, 0, "Вы отошли от больничной койки. Лечение прервано.", "");
        return 1;
    }

    new Float:health;
    GetPlayerHealth(playerid, health);

    if(health >= 100.0)
    {
        HospitalBeds_StopHealing(playerid, true);
        SetPlayerData(playerid, P_HOSPITAL, false);
        UpdatePlayerDatabaseInt(playerid, "hospital", 0);
        ShowNotificationSander(playerid, 3, 4, 0, 0, "Вы полностью вылечились!", "");
        SendClientMessage(playerid, 0xFFFFFFFF, "Вы здоровы и можете покинуть больницу!");
        return 1;
    }

    new Float:new_health = health + SANDER_HOSPITAL_BED_HEAL_STEP;
    if(new_health > 100.0) new_health = 100.0;

    SetPlayerHealthEx(playerid, new_health);
    HospitalBeds_ShowHealingEffect(playerid);
    return 1;
}

stock HospitalBeds_StartHealing(playerid)
{
    new bedid = HospitalBeds_GetNearBed(playerid);

    if(bedid == -1)
    {
        ShowNotificationSander(playerid, 2, 4, 0, 0, "Вы не находитесь у больничной койки!", "");
        return 1;
    }

    if(HospitalBeds_IsBedBusy(bedid))
    {
        ShowNotificationSander(playerid, 2, 4, 0, 0, "Эта койка уже занята!", "");
        return 1;
    }

    new Float:health;
    GetPlayerHealth(playerid, health);

    if(health >= 100.0)
    {
        ShowNotificationSander(playerid, 2, 4, 0, 0, "Вы уже полностью здоровы!", "");
        return 1;
    }

    if(g_hospital_bed_healing[playerid])
    {
        ShowNotificationSander(playerid, 2, 4, 0, 0, "Вы уже проходите лечение!", "");
        return 1;
    }

    HospitalBeds_TakeBed(bedid, playerid);
    g_hospital_bed_healing[playerid] = true;
    g_hospital_bed_timer[playerid] = SetTimerEx("HospitalBeds_HealPlayerTimer", SANDER_HOSPITAL_BED_HEAL_TIME, true, "i", playerid);
    ShowNotificationSander(playerid, 3, 4, 0, 0, "Вы начали лечение!", "");
    return 1;
}

public HospitalBeds_CheckPlayersNearBeds()
{
    for(new playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) continue;

        new bedid = HospitalBeds_GetNearBed(playerid);
        new last_bed = GetPVarInt(playerid, "SanderHospitalBedLast") - 1;

        if(bedid != -1 && last_bed != bedid)
        {
            SetPVarInt(playerid, "SanderHospitalBedLast", bedid + 1);

            if(!HospitalBeds_IsBedBusy(bedid) && !g_hospital_bed_healing[playerid])
            {
                ShowNotificationSander(playerid, 4, 6, 11, 0, "Вы хотите начать лечение?", "Да");
            }
        }
        else if(bedid == -1 && last_bed != -1)
        {
            DeletePVar(playerid, "SanderHospitalBedLast");
        }
    }
    return 1;
}

CMD:mheal(playerid, params[])
{
    return HospitalBeds_StartHealing(playerid);
}

CMD:stopheal(playerid, params[])
{
    if(!g_hospital_bed_healing[playerid])
    {
        ShowNotificationSander(playerid, 2, 4, 0, 0, "Вы не проходите лечение!", "");
        return 1;
    }

    HospitalBeds_StopHealing(playerid, true);
    ShowNotificationSander(playerid, 2, 4, 0, 0, "Вы прервали лечение!", "");
    return 1;
}
