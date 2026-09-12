#if defined _FAMILY_WARS_INCLUDED
    #endinput
#endif
#define _FAMILY_WARS_INCLUDED

#include <a_samp>
#include <pawncmd>
#include <sscanf2>
#include <a_mysql>

// =====================================================
// FAMILY WARS / CAPT SYSTEM
// Pawn + MySQL R41 + Pawn.CMD + sscanf
// =====================================================
//
// Возможности:
// - расписание войн
// - регистрация состава
// - отдельный Virtual World на каждую войну
// - счёт убийств
// - MVP
// - сезонный рейтинг семей
// - история войн
// - семейные награды
// - личные награды
// - семейные контейнеры
//
// ВАЖНО:
// Ниже есть адаптеры FW_GetFamilyID, FW_GetAccountID,
// FW_IsFamilyLeader, FW_AddMoney, FW_AddFamilyBalance.
// Подставь туда поля своей сборки Black Russia.
// =====================================================

#define FW_DB                    g_SQL

#define FW_COLOR                 0xE7B548FF
#define FW_GREEN                 0x2ECC71FF
#define FW_RED                   0xE74C3CFF
#define FW_WHITE                 0xFFFFFFFF
#define FW_GRAY                  0xBFC0C2FF

#define FW_WORLD_BASE            12000
#define FW_MAX_SCORE             50
#define FW_DEFAULT_DURATION      900     // 15 минут
#define FW_MIN_PLAYERS           2       // минимум от семьи для старта
#define FW_MAX_ROSTER            20

#define FW_WIN_FAMILY_REWARD     500000
#define FW_WIN_PLAYER_REWARD     75000
#define FW_LOSE_PLAYER_REWARD    20000
#define FW_MVP_REWARD            150000

#define FW_POINTS_WIN            3
#define FW_POINTS_DRAW           1

#define FW_CONTAINER_BRONZE      1
#define FW_CONTAINER_SILVER      2
#define FW_CONTAINER_GOLD        3

#define DIALOG_FW_LIST           9300
#define DIALOG_FW_STATS          9301
#define DIALOG_FW_HISTORY        9302
#define DIALOG_FW_ROSTER         9303
#define DIALOG_FW_CONTAINER      9304

enum E_FW_STATE
{
    FW_STATE_NONE = 0,
    FW_STATE_SCHEDULED,
    FW_STATE_RUNNING,
    FW_STATE_FINISHED,
    FW_STATE_CANCELLED
};

enum E_FW_PLAYER
{
    bool:fwInWar,
    fwWarID,
    fwTeam,
    fwKills,
    fwDeaths,
    bool:fwRegistered,
    fwRegisteredWarID,
    Float:fwOldX,
    Float:fwOldY,
    Float:fwOldZ,
    Float:fwOldA,
    Float:fwOldHP,
    Float:fwOldArmour,
    fwOldVW,
    fwOldInterior
};

new FWPlayer[MAX_PLAYERS][E_FW_PLAYER];

new FWOldWeapon[MAX_PLAYERS][13];
new FWOldAmmo[MAX_PLAYERS][13];

new gFWCurrentWarID = 0;
new gFWFamily1 = 0;
new gFWFamily2 = 0;
new gFWScore1 = 0;
new gFWScore2 = 0;
new gFWWorld = 0;
new gFWEndTime = 0;
new gFWStartTime = 0;
new gFWTargetScore = FW_MAX_SCORE;
new gFWDuration = FW_DEFAULT_DURATION;
new gFWSeasonID = 1;
new gFWTimer = -1;

new Float:gFWSpawn1[4] = {2200.0, -1140.0, 1029.8, 90.0};
new Float:gFWSpawn2[4] = {2230.0, -1140.0, 1029.8, 270.0};
new gFWInterior = 15;


// =====================================================
// АДАПТЕРЫ ПОД ТВОЙ BLACK RUSSIA
// =====================================================

stock FW_GetAccountID(playerid)
{
    // ПРИМЕР:
    // return PlayerInfo[playerid][pID];
    return GetPVarInt(playerid, "AccountID");
}

stock FW_GetFamilyID(playerid)
{
    // ПРИМЕР:
    // return PlayerInfo[playerid][pFamily];
    return GetPVarInt(playerid, "FamilyID");
}

stock bool:FW_IsFamilyLeader(playerid)
{
    // ПРИМЕР:
    // return (PlayerInfo[playerid][pFamilyRank] >= 10);
    return (GetPVarInt(playerid, "FamilyLeader") == 1);
}

stock bool:FW_IsAdmin(playerid)
{
    // ПРИМЕР:
    // return (PlayerInfo[playerid][pAdmin] >= 5);
    return IsPlayerAdmin(playerid);
}

stock FW_AddMoney(playerid, amount)
{
    // ПРИМЕР:
    // PlayerInfo[playerid][pMoney] += amount;
    // UpdatePlayerMoney(playerid);
    GivePlayerMoney(playerid, amount);
    return 1;
}

stock FW_AddFamilyBalance(familyid, amount)
{
    // ОБЯЗАТЕЛЬНО ПОДСТАВЬ СВОЮ СИСТЕМУ КАЗНЫ.
    //
    // ПРИМЕР:
    // FamilyInfo[familyid][fBank] += amount;
    // SaveFamily(familyid);
    //
    printf("[FAMILY WARS] Family %d treasury +%d", familyid, amount);
    return 1;
}

stock FW_GetFamilyName(familyid, output[], size)
{
    // ПРИМЕР:
    // format(output, size, "%s", FamilyInfo[familyid][fName]);
    format(output, size, "Family #%d", familyid);
    return 1;
}


// =====================================================
// ИНИЦИАЛИЗАЦИЯ
// =====================================================

stock FW_Init()
{
    if(gFWTimer != -1)
        KillTimer(gFWTimer);

    gFWTimer = SetTimer("FW_GlobalTick", 5000, true);
    FW_LoadSeason();
    FW_CheckScheduledWar();
    return 1;
}

stock FW_InitPlayer(playerid)
{
    FWPlayer[playerid][fwInWar] = false;
    FWPlayer[playerid][fwWarID] = 0;
    FWPlayer[playerid][fwTeam] = 0;
    FWPlayer[playerid][fwKills] = 0;
    FWPlayer[playerid][fwDeaths] = 0;
    FWPlayer[playerid][fwRegistered] = false;
    FWPlayer[playerid][fwRegisteredWarID] = 0;
    return 1;
}


// =====================================================
// SEASON
// =====================================================

stock FW_LoadSeason()
{
    mysql_tquery(
        FW_DB,
        "SELECT id FROM family_war_seasons WHERE active=1 ORDER BY id DESC LIMIT 1",
        "FW_OnSeasonLoaded"
    );
    return 1;
}

forward FW_OnSeasonLoaded();
public FW_OnSeasonLoaded()
{
    if(cache_num_rows())
    {
        cache_get_value_name_int(0, "id", gFWSeasonID);
    }
    else
    {
        mysql_tquery(
            FW_DB,
            "INSERT INTO family_war_seasons (name, active) VALUES ('Season 1', 1)"
        );
        gFWSeasonID = 1;
    }
    return 1;
}


// =====================================================
// SCHEDULE
// =====================================================

forward FW_GlobalTick();
public FW_GlobalTick()
{
    if(gFWCurrentWarID == 0)
    {
        FW_CheckScheduledWar();
    }
    else
    {
        if(gettime() >= gFWEndTime)
        {
            FW_FinishWar(0);
        }
    }
    return 1;
}

stock FW_CheckScheduledWar()
{
    if(gFWCurrentWarID != 0)
        return 0;

    new query[512];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "SELECT id,family1_id,family2_id,start_time,duration,target_score \
         FROM family_wars \
         WHERE status=%d AND start_time<=UNIX_TIMESTAMP() \
         ORDER BY start_time ASC LIMIT 1",
        FW_STATE_SCHEDULED
    );

    mysql_tquery(FW_DB, query, "FW_OnScheduledWarFound");
    return 1;
}

forward FW_OnScheduledWarFound();
public FW_OnScheduledWarFound()
{
    if(gFWCurrentWarID != 0 || !cache_num_rows())
        return 1;

    new warid, fam1, fam2, starttime, duration, target;

    cache_get_value_name_int(0, "id", warid);
    cache_get_value_name_int(0, "family1_id", fam1);
    cache_get_value_name_int(0, "family2_id", fam2);
    cache_get_value_name_int(0, "start_time", starttime);
    cache_get_value_name_int(0, "duration", duration);
    cache_get_value_name_int(0, "target_score", target);

    FW_StartWar(warid, fam1, fam2, starttime, duration, target);
    return 1;
}


// =====================================================
// CREATE WAR
// =====================================================

stock FW_CreateWar(family1, family2, startUnix, duration = FW_DEFAULT_DURATION, targetScore = FW_MAX_SCORE)
{
    if(family1 <= 0 || family2 <= 0 || family1 == family2)
        return 0;

    new query[700];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "INSERT INTO family_wars \
        (season_id,family1_id,family2_id,start_time,duration,target_score,status) \
        VALUES (%d,%d,%d,%d,%d,%d,%d)",
        gFWSeasonID,
        family1,
        family2,
        startUnix,
        duration,
        targetScore,
        FW_STATE_SCHEDULED
    );

    mysql_tquery(FW_DB, query);
    return 1;
}

CMD:fwcreate(playerid, params[])
{
    if(!FW_IsAdmin(playerid))
        return SendClientMessage(playerid, FW_RED, "Недостаточно прав.");

    new family1, family2, minutes, duration, target;

    if(sscanf(params, "iiiii", family1, family2, minutes, duration, target))
    {
        return SendClientMessage(
            playerid,
            FW_WHITE,
            "Используйте: /fwcreate [family1] [family2] [через минут] [длительность сек] [цель киллов]"
        );
    }

    if(minutes < 1 || duration < 60 || target < 1)
        return SendClientMessage(playerid, FW_RED, "Некорректные параметры.");

    FW_CreateWar(family1, family2, gettime() + minutes * 60, duration, target);

    SendClientMessage(playerid, FW_GREEN, "Семейная война добавлена в расписание.");
    return 1;
}


// =====================================================
// REGISTRATION
// =====================================================

CMD:fwarreg(playerid, params[])
{
    new warid;
    if(sscanf(params, "i", warid))
        return SendClientMessage(playerid, FW_WHITE, "Используйте: /fwarreg [ID войны]");

    new familyid = FW_GetFamilyID(playerid);
    if(familyid <= 0)
        return SendClientMessage(playerid, FW_RED, "Вы не состоите в семье.");

    if(FWPlayer[playerid][fwInWar])
        return SendClientMessage(playerid, FW_RED, "Вы уже участвуете в войне.");

    new query[700];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "SELECT id,family1_id,family2_id,start_time,status FROM family_wars \
         WHERE id=%d LIMIT 1",
        warid
    );

    mysql_tquery(FW_DB, query, "FW_OnRegisterCheck", "dd", playerid, warid);
    return 1;
}

forward FW_OnRegisterCheck(playerid, warid);
public FW_OnRegisterCheck(playerid, warid)
{
    if(!IsPlayerConnected(playerid))
        return 1;

    if(!cache_num_rows())
        return SendClientMessage(playerid, FW_RED, "Война не найдена.");

    new fam1, fam2, starttime, status;
    cache_get_value_name_int(0, "family1_id", fam1);
    cache_get_value_name_int(0, "family2_id", fam2);
    cache_get_value_name_int(0, "start_time", starttime);
    cache_get_value_name_int(0, "status", status);

    if(status != FW_STATE_SCHEDULED)
        return SendClientMessage(playerid, FW_RED, "Регистрация на эту войну закрыта.");

    if(gettime() >= starttime)
        return SendClientMessage(playerid, FW_RED, "Война уже должна была начаться.");

    new familyid = FW_GetFamilyID(playerid);
    if(familyid != fam1 && familyid != fam2)
        return SendClientMessage(playerid, FW_RED, "Ваша семья не участвует в этой войне.");

    new query[800];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "SELECT COUNT(*) AS cnt FROM family_war_roster \
         WHERE war_id=%d AND family_id=%d",
        warid,
        familyid
    );

    mysql_tquery(FW_DB, query, "FW_OnRosterCount", "ddd", playerid, warid, familyid);
    return 1;
}

forward FW_OnRosterCount(playerid, warid, familyid);
public FW_OnRosterCount(playerid, warid, familyid)
{
    if(!IsPlayerConnected(playerid))
        return 1;

    new count;
    cache_get_value_name_int(0, "cnt", count);

    if(count >= FW_MAX_ROSTER)
        return SendClientMessage(playerid, FW_RED, "Состав семьи на эту войну уже заполнен.");

    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));

    new query[900];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "INSERT INTO family_war_roster \
        (war_id,family_id,account_id,player_name) \
        VALUES (%d,%d,%d,'%e') \
        ON DUPLICATE KEY UPDATE family_id=VALUES(family_id),player_name=VALUES(player_name)",
        warid,
        familyid,
        FW_GetAccountID(playerid),
        name
    );

    mysql_tquery(FW_DB, query);

    FWPlayer[playerid][fwRegistered] = true;
    FWPlayer[playerid][fwRegisteredWarID] = warid;

    SendClientMessage(playerid, FW_GREEN, "Вы зарегистрированы в составе на семейную войну.");
    return 1;
}

CMD:fwarunreg(playerid, params[])
{
    new warid;
    if(sscanf(params, "i", warid))
        return SendClientMessage(playerid, FW_WHITE, "Используйте: /fwarunreg [ID войны]");

    new query[500];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "DELETE FROM family_war_roster WHERE war_id=%d AND account_id=%d",
        warid,
        FW_GetAccountID(playerid)
    );
    mysql_tquery(FW_DB, query);

    if(FWPlayer[playerid][fwRegisteredWarID] == warid)
    {
        FWPlayer[playerid][fwRegistered] = false;
        FWPlayer[playerid][fwRegisteredWarID] = 0;
    }

    SendClientMessage(playerid, FW_GRAY, "Регистрация отменена.");
    return 1;
}


// =====================================================
// LIST WARS
// =====================================================

CMD:fwars(playerid, params[])
{
    new query[700];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "SELECT id,family1_id,family2_id,start_time,status,target_score \
         FROM family_wars \
         WHERE season_id=%d \
         ORDER BY id DESC LIMIT 20",
        gFWSeasonID
    );

    mysql_tquery(FW_DB, query, "FW_OnWarsList", "d", playerid);
    return 1;
}

forward FW_OnWarsList(playerid);
public FW_OnWarsList(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 1;

    new rows = cache_num_rows();
    if(!rows)
    {
        return ShowPlayerDialog(
            playerid,
            DIALOG_FW_LIST,
            DIALOG_STYLE_MSGBOX,
            "Семейные войны",
            "В этом сезоне войн пока нет.",
            "Закрыть",
            ""
        );
    }

    new text[3500];
    strcat(text, "ID\tСемья 1\tСемья 2\tСтатус\tЦель\n");

    for(new i = 0; i < rows; i++)
    {
        new id, f1, f2, status, target;
        cache_get_value_name_int(i, "id", id);
        cache_get_value_name_int(i, "family1_id", f1);
        cache_get_value_name_int(i, "family2_id", f2);
        cache_get_value_name_int(i, "status", status);
        cache_get_value_name_int(i, "target_score", target);

        new n1[32], n2[32], statusName[24], line[220];
        FW_GetFamilyName(f1, n1, sizeof(n1));
        FW_GetFamilyName(f2, n2, sizeof(n2));

        switch(status)
        {
            case FW_STATE_SCHEDULED: format(statusName, sizeof(statusName), "Ожидается");
            case FW_STATE_RUNNING: format(statusName, sizeof(statusName), "Идёт");
            case FW_STATE_FINISHED: format(statusName, sizeof(statusName), "Завершена");
            case FW_STATE_CANCELLED: format(statusName, sizeof(statusName), "Отменена");
            default: format(statusName, sizeof(statusName), "-");
        }

        format(
            line,
            sizeof(line),
            "%d\t%s\t%s\t%s\t%d\n",
            id,
            n1,
            n2,
            statusName,
            target
        );
        strcat(text, line, sizeof(text));
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_FW_LIST,
        DIALOG_STYLE_TABLIST_HEADERS,
        "Семейные войны | Сезон",
        text,
        "Закрыть",
        ""
    );

    return 1;
}


// =====================================================
// START WAR
// =====================================================

stock FW_StartWar(warid, fam1, fam2, starttime, duration, targetScore)
{
    if(gFWCurrentWarID != 0)
        return 0;

    gFWCurrentWarID = warid;
    gFWFamily1 = fam1;
    gFWFamily2 = fam2;
    gFWScore1 = 0;
    gFWScore2 = 0;
    gFWWorld = FW_WORLD_BASE + warid;
    gFWStartTime = starttime;
    gFWDuration = duration;
    gFWTargetScore = targetScore;
    gFWEndTime = gettime() + duration;

    new query[500];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "UPDATE family_wars SET status=%d,actual_start=UNIX_TIMESTAMP() WHERE id=%d",
        FW_STATE_RUNNING,
        warid
    );
    mysql_tquery(FW_DB, query);

    new count1 = 0, count2 = 0;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i))
            continue;

        if(FWPlayer[i][fwRegisteredWarID] != warid)
            continue;

        new fam = FW_GetFamilyID(i);

        if(fam == fam1)
        {
            count1++;
            FW_EnterWar(i, 1);
        }
        else if(fam == fam2)
        {
            count2++;
            FW_EnterWar(i, 2);
        }
    }

    if(count1 < FW_MIN_PLAYERS || count2 < FW_MIN_PLAYERS)
    {
        FW_CancelWarForLowPlayers(count1, count2);
        return 0;
    }

    new msg[256];
    format(
        msg,
        sizeof(msg),
        "FAMILY WAR: война #%d началась! Счёт %d:%d, цель %d убийств.",
        warid,
        gFWScore1,
        gFWScore2,
        gFWTargetScore
    );
    SendClientMessageToAll(FW_COLOR, msg);
    return 1;
}

stock FW_CancelWarForLowPlayers(count1, count2)
{
    new warid = gFWCurrentWarID;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && FWPlayer[i][fwInWar] && FWPlayer[i][fwWarID] == warid)
        {
            FW_LeaveWar(i);
            SendClientMessage(i, FW_RED, "Война отменена: недостаточно участников.");
        }
    }

    new query[500];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "UPDATE family_wars SET status=%d,score1=%d,score2=%d,actual_end=UNIX_TIMESTAMP() WHERE id=%d",
        FW_STATE_CANCELLED,
        count1,
        count2,
        warid
    );
    mysql_tquery(FW_DB, query);

    FW_ResetCurrentWar();
    return 1;
}


// =====================================================
// PLAYER ENTER/LEAVE WAR
// =====================================================

stock FW_SavePlayerState(playerid)
{
    GetPlayerPos(
        playerid,
        FWPlayer[playerid][fwOldX],
        FWPlayer[playerid][fwOldY],
        FWPlayer[playerid][fwOldZ]
    );
    GetPlayerFacingAngle(playerid, FWPlayer[playerid][fwOldA]);
    GetPlayerHealth(playerid, FWPlayer[playerid][fwOldHP]);
    GetPlayerArmour(playerid, FWPlayer[playerid][fwOldArmour]);

    FWPlayer[playerid][fwOldVW] = GetPlayerVirtualWorld(playerid);
    FWPlayer[playerid][fwOldInterior] = GetPlayerInterior(playerid);

    for(new slot = 0; slot < 13; slot++)
    {
        GetPlayerWeaponData(
            playerid,
            slot,
            FWOldWeapon[playerid][slot],
            FWOldAmmo[playerid][slot]
        );
    }

    return 1;
}

stock FW_EnterWar(playerid, team)
{
    FW_SavePlayerState(playerid);

    FWPlayer[playerid][fwInWar] = true;
    FWPlayer[playerid][fwWarID] = gFWCurrentWarID;
    FWPlayer[playerid][fwTeam] = team;
    FWPlayer[playerid][fwKills] = 0;
    FWPlayer[playerid][fwDeaths] = 0;

    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid, 24, 150);
    GivePlayerWeapon(playerid, 31, 500);
    GivePlayerWeapon(playerid, 34, 30);

    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 100.0);

    FW_SetWarSpawn(playerid);
    return 1;
}

stock FW_SetWarSpawn(playerid)
{
    if(!FWPlayer[playerid][fwInWar])
        return 0;

    SetPlayerVirtualWorld(playerid, gFWWorld);
    SetPlayerInterior(playerid, gFWInterior);

    if(FWPlayer[playerid][fwTeam] == 1)
    {
        SetPlayerPos(playerid, gFWSpawn1[0], gFWSpawn1[1], gFWSpawn1[2]);
        SetPlayerFacingAngle(playerid, gFWSpawn1[3]);
    }
    else
    {
        SetPlayerPos(playerid, gFWSpawn2[0], gFWSpawn2[1], gFWSpawn2[2]);
        SetPlayerFacingAngle(playerid, gFWSpawn2[3]);
    }

    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 100.0);
    return 1;
}

stock FW_LeaveWar(playerid)
{
    FWPlayer[playerid][fwInWar] = false;
    FWPlayer[playerid][fwWarID] = 0;
    FWPlayer[playerid][fwTeam] = 0;

    SetPlayerVirtualWorld(playerid, FWPlayer[playerid][fwOldVW]);
    SetPlayerInterior(playerid, FWPlayer[playerid][fwOldInterior]);

    SetPlayerPos(
        playerid,
        FWPlayer[playerid][fwOldX],
        FWPlayer[playerid][fwOldY],
        FWPlayer[playerid][fwOldZ]
    );
    SetPlayerFacingAngle(playerid, FWPlayer[playerid][fwOldA]);

    SetPlayerHealth(playerid, FWPlayer[playerid][fwOldHP]);
    SetPlayerArmour(playerid, FWPlayer[playerid][fwOldArmour]);

    ResetPlayerWeapons(playerid);

    for(new slot = 0; slot < 13; slot++)
    {
        if(FWOldWeapon[playerid][slot] != 0)
        {
            GivePlayerWeapon(
                playerid,
                FWOldWeapon[playerid][slot],
                FWOldAmmo[playerid][slot]
            );
        }
    }

    return 1;
}


// =====================================================
// KILLS / DEATH
// =====================================================

stock FW_OnPlayerDeath(playerid, killerid)
{
    if(!FWPlayer[playerid][fwInWar])
        return 0;

    if(FWPlayer[playerid][fwWarID] != gFWCurrentWarID)
        return 0;

    FWPlayer[playerid][fwDeaths]++;

    if(
        killerid != INVALID_PLAYER_ID &&
        IsPlayerConnected(killerid) &&
        FWPlayer[killerid][fwInWar] &&
        FWPlayer[killerid][fwWarID] == gFWCurrentWarID &&
        FWPlayer[killerid][fwTeam] != FWPlayer[playerid][fwTeam]
    )
    {
        FWPlayer[killerid][fwKills]++;

        if(FWPlayer[killerid][fwTeam] == 1)
            gFWScore1++;
        else
            gFWScore2++;

        FW_SaveKill(killerid, playerid);

        new msg[160];
        format(
            msg,
            sizeof(msg),
            "FAMILY WAR | Счёт: %d : %d | Ваши убийства: %d",
            gFWScore1,
            gFWScore2,
            FWPlayer[killerid][fwKills]
        );
        SendClientMessage(killerid, FW_COLOR, msg);

        if(gFWScore1 >= gFWTargetScore || gFWScore2 >= gFWTargetScore)
        {
            FW_FinishWar((gFWScore1 > gFWScore2) ? 1 : 2);
        }
    }

    return 1;
}

stock FW_SaveKill(killerid, victimid)
{
    new query[900];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "INSERT INTO family_war_kills \
        (war_id,killer_account_id,victim_account_id,killer_family_id,victim_family_id,weapon_id,created_at) \
        VALUES (%d,%d,%d,%d,%d,%d,UNIX_TIMESTAMP())",
        gFWCurrentWarID,
        FW_GetAccountID(killerid),
        FW_GetAccountID(victimid),
        FW_GetFamilyID(killerid),
        FW_GetFamilyID(victimid),
        GetPlayerWeapon(killerid)
    );

    mysql_tquery(FW_DB, query);
    return 1;
}

stock FW_OnPlayerSpawn(playerid)
{
    if(!FWPlayer[playerid][fwInWar])
        return 0;

    SetTimerEx("FW_RespawnWarPlayer", 500, false, "d", playerid);
    return 1;
}

forward FW_RespawnWarPlayer(playerid);
public FW_RespawnWarPlayer(playerid)
{
    if(!IsPlayerConnected(playerid) || !FWPlayer[playerid][fwInWar])
        return 1;

    ResetPlayerWeapons(playerid);
    GivePlayerWeapon(playerid, 24, 150);
    GivePlayerWeapon(playerid, 31, 500);
    GivePlayerWeapon(playerid, 34, 30);

    FW_SetWarSpawn(playerid);
    return 1;
}


// =====================================================
// DISCONNECT
// =====================================================

stock FW_OnPlayerDisconnect(playerid)
{
    if(FWPlayer[playerid][fwInWar])
    {
        FW_SavePlayerResult(playerid);
    }

    FW_InitPlayer(playerid);
    return 1;
}


// =====================================================
// FINISH WAR
// winnerTeam: 0 = определить по счёту
// =====================================================

stock FW_FinishWar(winnerTeam = 0)
{
    if(gFWCurrentWarID == 0)
        return 0;

    if(winnerTeam == 0)
    {
        if(gFWScore1 > gFWScore2)
            winnerTeam = 1;
        else if(gFWScore2 > gFWScore1)
            winnerTeam = 2;
        else
            winnerTeam = 0;
    }

    new winnerFamily = 0;
    new loserFamily = 0;

    if(winnerTeam == 1)
    {
        winnerFamily = gFWFamily1;
        loserFamily = gFWFamily2;
    }
    else if(winnerTeam == 2)
    {
        winnerFamily = gFWFamily2;
        loserFamily = gFWFamily1;
    }

    new mvpPlayer = INVALID_PLAYER_ID;
    new mvpKills = -1;

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i))
            continue;

        if(!FWPlayer[i][fwInWar] || FWPlayer[i][fwWarID] != gFWCurrentWarID)
            continue;

        FW_SavePlayerResult(i);

        if(FWPlayer[i][fwKills] > mvpKills)
        {
            mvpKills = FWPlayer[i][fwKills];
            mvpPlayer = i;
        }
    }

    if(winnerFamily > 0)
    {
        FW_AddFamilyBalance(winnerFamily, FW_WIN_FAMILY_REWARD);
        FW_AddContainer(winnerFamily, FW_CONTAINER_GOLD, 1);
        FW_UpdateFamilySeason(winnerFamily, 1, gFWScore1, gFWScore2);
        FW_UpdateFamilySeason(loserFamily, 0, gFWScore1, gFWScore2);
    }
    else
    {
        FW_UpdateFamilySeason(gFWFamily1, 2, gFWScore1, gFWScore2);
        FW_UpdateFamilySeason(gFWFamily2, 2, gFWScore1, gFWScore2);
        FW_AddContainer(gFWFamily1, FW_CONTAINER_SILVER, 1);
        FW_AddContainer(gFWFamily2, FW_CONTAINER_SILVER, 1);
    }

    if(mvpPlayer != INVALID_PLAYER_ID && IsPlayerConnected(mvpPlayer))
    {
        FW_AddMoney(mvpPlayer, FW_MVP_REWARD);

        new mvpMsg[200];
        format(
            mvpMsg,
            sizeof(mvpMsg),
            "Вы MVP семейной войны! Убийств: %d | Награда: %d руб.",
            mvpKills,
            FW_MVP_REWARD
        );
        SendClientMessage(mvpPlayer, FW_GREEN, mvpMsg);
    }

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i))
            continue;

        if(!FWPlayer[i][fwInWar] || FWPlayer[i][fwWarID] != gFWCurrentWarID)
            continue;

        new fam = FW_GetFamilyID(i);

        if(winnerFamily > 0 && fam == winnerFamily)
            FW_AddMoney(i, FW_WIN_PLAYER_REWARD);
        else if(winnerFamily > 0)
            FW_AddMoney(i, FW_LOSE_PLAYER_REWARD);

        FW_LeaveWar(i);
    }

    new query[800];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "UPDATE family_wars \
        SET status=%d,score1=%d,score2=%d,winner_family_id=%d,actual_end=UNIX_TIMESTAMP(),mvp_account_id=%d \
        WHERE id=%d",
        FW_STATE_FINISHED,
        gFWScore1,
        gFWScore2,
        winnerFamily,
        (mvpPlayer == INVALID_PLAYER_ID ? 0 : FW_GetAccountID(mvpPlayer)),
        gFWCurrentWarID
    );
    mysql_tquery(FW_DB, query);

    new n1[32], n2[32], msg[256];
    FW_GetFamilyName(gFWFamily1, n1, sizeof(n1));
    FW_GetFamilyName(gFWFamily2, n2, sizeof(n2));

    format(
        msg,
        sizeof(msg),
        "FAMILY WAR завершена: %s %d : %d %s.",
        n1,
        gFWScore1,
        gFWScore2,
        n2
    );
    SendClientMessageToAll(FW_COLOR, msg);

    FW_ResetCurrentWar();
    return 1;
}

stock FW_SavePlayerResult(playerid)
{
    new query[1000];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "INSERT INTO family_war_player_results \
        (war_id,season_id,family_id,account_id,kills,deaths) \
        VALUES (%d,%d,%d,%d,%d,%d) \
        ON DUPLICATE KEY UPDATE kills=VALUES(kills),deaths=VALUES(deaths)",
        gFWCurrentWarID,
        gFWSeasonID,
        FW_GetFamilyID(playerid),
        FW_GetAccountID(playerid),
        FWPlayer[playerid][fwKills],
        FWPlayer[playerid][fwDeaths]
    );

    mysql_tquery(FW_DB, query);

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "INSERT INTO family_war_player_stats \
        (season_id,account_id,family_id,kills,deaths,wars) \
        VALUES (%d,%d,%d,%d,%d,1) \
        ON DUPLICATE KEY UPDATE \
        kills=kills+VALUES(kills),deaths=deaths+VALUES(deaths),wars=wars+1,family_id=VALUES(family_id)",
        gFWSeasonID,
        FW_GetAccountID(playerid),
        FW_GetFamilyID(playerid),
        FWPlayer[playerid][fwKills],
        FWPlayer[playerid][fwDeaths]
    );

    mysql_tquery(FW_DB, query);
    return 1;
}

stock FW_UpdateFamilySeason(familyid, result, score1, score2)
{
    new points = 0, wins = 0, losses = 0, draws = 0;

    switch(result)
    {
        case 1:
        {
            points = FW_POINTS_WIN;
            wins = 1;
        }
        case 0:
        {
            losses = 1;
        }
        case 2:
        {
            points = FW_POINTS_DRAW;
            draws = 1;
        }
    }

    new kills = (familyid == gFWFamily1) ? score1 : score2;
    new deaths = (familyid == gFWFamily1) ? score2 : score1;

    new query[1100];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "INSERT INTO family_war_family_stats \
        (season_id,family_id,points,wins,losses,draws,kills,deaths,wars) \
        VALUES (%d,%d,%d,%d,%d,%d,%d,%d,1) \
        ON DUPLICATE KEY UPDATE \
        points=points+VALUES(points),wins=wins+VALUES(wins),losses=losses+VALUES(losses), \
        draws=draws+VALUES(draws),kills=kills+VALUES(kills),deaths=deaths+VALUES(deaths),wars=wars+1",
        gFWSeasonID,
        familyid,
        points,
        wins,
        losses,
        draws,
        kills,
        deaths
    );

    mysql_tquery(FW_DB, query);
    return 1;
}

stock FW_ResetCurrentWar()
{
    gFWCurrentWarID = 0;
    gFWFamily1 = 0;
    gFWFamily2 = 0;
    gFWScore1 = 0;
    gFWScore2 = 0;
    gFWWorld = 0;
    gFWStartTime = 0;
    gFWEndTime = 0;
    gFWTargetScore = FW_MAX_SCORE;
    gFWDuration = FW_DEFAULT_DURATION;
    return 1;
}


// =====================================================
// FAMILY SEASON RATING
// =====================================================

CMD:fwrating(playerid, params[])
{
    new query[900];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "SELECT family_id,points,wins,losses,draws,kills,deaths,wars \
        FROM family_war_family_stats \
        WHERE season_id=%d \
        ORDER BY points DESC,wins DESC,kills DESC LIMIT 20",
        gFWSeasonID
    );

    mysql_tquery(FW_DB, query, "FW_OnRatingLoaded", "d", playerid);
    return 1;
}

forward FW_OnRatingLoaded(playerid);
public FW_OnRatingLoaded(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 1;

    new rows = cache_num_rows();

    if(!rows)
        return SendClientMessage(playerid, FW_GRAY, "Рейтинг семей пока пуст.");

    new text[4000];
    strcat(text, "#\tСемья\tОчки\tВ\tП\tK/D\n");

    for(new i = 0; i < rows; i++)
    {
        new familyid, points, wins, losses, kills, deaths;
        cache_get_value_name_int(i, "family_id", familyid);
        cache_get_value_name_int(i, "points", points);
        cache_get_value_name_int(i, "wins", wins);
        cache_get_value_name_int(i, "losses", losses);
        cache_get_value_name_int(i, "kills", kills);
        cache_get_value_name_int(i, "deaths", deaths);

        new name[40], line[220];
        FW_GetFamilyName(familyid, name, sizeof(name));

        format(
            line,
            sizeof(line),
            "%d\t%s\t%d\t%d\t%d\t%d/%d\n",
            i + 1,
            name,
            points,
            wins,
            losses,
            kills,
            deaths
        );
        strcat(text, line, sizeof(text));
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_FW_STATS,
        DIALOG_STYLE_TABLIST_HEADERS,
        "Сезонный рейтинг семей",
        text,
        "Закрыть",
        ""
    );

    return 1;
}


// =====================================================
// HISTORY
// =====================================================

CMD:fwarhistory(playerid, params[])
{
    new familyid = FW_GetFamilyID(playerid);

    if(familyid <= 0)
        return SendClientMessage(playerid, FW_RED, "Вы не состоите в семье.");

    new query[1000];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "SELECT id,family1_id,family2_id,score1,score2,winner_family_id,actual_end \
        FROM family_wars \
        WHERE status=%d AND (family1_id=%d OR family2_id=%d) \
        ORDER BY id DESC LIMIT 20",
        FW_STATE_FINISHED,
        familyid,
        familyid
    );

    mysql_tquery(FW_DB, query, "FW_OnHistoryLoaded", "dd", playerid, familyid);
    return 1;
}

forward FW_OnHistoryLoaded(playerid, familyid);
public FW_OnHistoryLoaded(playerid, familyid)
{
    if(!IsPlayerConnected(playerid))
        return 1;

    new rows = cache_num_rows();

    if(!rows)
        return SendClientMessage(playerid, FW_GRAY, "История войн семьи пока пустая.");

    new text[3500];
    strcat(text, "ID\tСоперник\tСчёт\tРезультат\n");

    for(new i = 0; i < rows; i++)
    {
        new id, f1, f2, s1, s2, winner;
        cache_get_value_name_int(i, "id", id);
        cache_get_value_name_int(i, "family1_id", f1);
        cache_get_value_name_int(i, "family2_id", f2);
        cache_get_value_name_int(i, "score1", s1);
        cache_get_value_name_int(i, "score2", s2);
        cache_get_value_name_int(i, "winner_family_id", winner);

        new opponent = (f1 == familyid) ? f2 : f1;
        new ownScore = (f1 == familyid) ? s1 : s2;
        new enemyScore = (f1 == familyid) ? s2 : s1;

        new name[40], result[24], line[220];
        FW_GetFamilyName(opponent, name, sizeof(name));

        if(winner == 0)
            format(result, sizeof(result), "DRAW");
        else if(winner == familyid)
            format(result, sizeof(result), "WIN");
        else
            format(result, sizeof(result), "LOSE");

        format(
            line,
            sizeof(line),
            "%d\t%s\t%d:%d\t%s\n",
            id,
            name,
            ownScore,
            enemyScore,
            result
        );

        strcat(text, line, sizeof(text));
    }

    ShowPlayerDialog(
        playerid,
        DIALOG_FW_HISTORY,
        DIALOG_STYLE_TABLIST_HEADERS,
        "История семейных войн",
        text,
        "Закрыть",
        ""
    );

    return 1;
}


// =====================================================
// CONTAINERS
// =====================================================

stock FW_AddContainer(familyid, type, amount = 1)
{
    new query[700];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "INSERT INTO family_containers (family_id,container_type,amount) \
        VALUES (%d,%d,%d) \
        ON DUPLICATE KEY UPDATE amount=amount+VALUES(amount)",
        familyid,
        type,
        amount
    );

    mysql_tquery(FW_DB, query);
    return 1;
}

CMD:fcontainers(playerid, params[])
{
    new familyid = FW_GetFamilyID(playerid);

    if(familyid <= 0)
        return SendClientMessage(playerid, FW_RED, "Вы не состоите в семье.");

    new query[600];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "SELECT container_type,amount FROM family_containers WHERE family_id=%d ORDER BY container_type",
        familyid
    );

    mysql_tquery(FW_DB, query, "FW_OnContainersLoaded", "d", playerid);
    return 1;
}

forward FW_OnContainersLoaded(playerid);
public FW_OnContainersLoaded(playerid)
{
    if(!IsPlayerConnected(playerid))
        return 1;

    new bronze = 0, silver = 0, gold = 0;

    for(new i = 0; i < cache_num_rows(); i++)
    {
        new type, amount;
        cache_get_value_name_int(i, "container_type", type);
        cache_get_value_name_int(i, "amount", amount);

        switch(type)
        {
            case FW_CONTAINER_BRONZE: bronze = amount;
            case FW_CONTAINER_SILVER: silver = amount;
            case FW_CONTAINER_GOLD: gold = amount;
        }
    }

    new text[600];
    format(
        text,
        sizeof(text),
        "{CD7F32}Bronze\t{FFFFFF}%d\n{C0C0C0}Silver\t{FFFFFF}%d\n{FFD700}Gold\t{FFFFFF}%d\n\n\
        {AAAAAA}Открыть: /fcontaineropen [1-3]\n\
        1 - Bronze, 2 - Silver, 3 - Gold",
        bronze,
        silver,
        gold
    );

    ShowPlayerDialog(
        playerid,
        DIALOG_FW_CONTAINER,
        DIALOG_STYLE_MSGBOX,
        "Семейные контейнеры",
        text,
        "Закрыть",
        ""
    );

    return 1;
}

CMD:fcontaineropen(playerid, params[])
{
    if(!FW_IsFamilyLeader(playerid))
        return SendClientMessage(playerid, FW_RED, "Открывать семейные контейнеры может только лидер.");

    new type;
    if(sscanf(params, "i", type))
        return SendClientMessage(playerid, FW_WHITE, "Используйте: /fcontaineropen [1-3]");

    if(type < FW_CONTAINER_BRONZE || type > FW_CONTAINER_GOLD)
        return SendClientMessage(playerid, FW_RED, "Тип контейнера: 1 Bronze, 2 Silver, 3 Gold.");

    new familyid = FW_GetFamilyID(playerid);

    new query[600];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "SELECT amount FROM family_containers \
        WHERE family_id=%d AND container_type=%d LIMIT 1",
        familyid,
        type
    );

    mysql_tquery(FW_DB, query, "FW_OnContainerOpenCheck", "ddd", playerid, familyid, type);
    return 1;
}

forward FW_OnContainerOpenCheck(playerid, familyid, type);
public FW_OnContainerOpenCheck(playerid, familyid, type)
{
    if(!IsPlayerConnected(playerid))
        return 1;

    if(!cache_num_rows())
        return SendClientMessage(playerid, FW_RED, "У семьи нет такого контейнера.");

    new amount;
    cache_get_value_name_int(0, "amount", amount);

    if(amount <= 0)
        return SendClientMessage(playerid, FW_RED, "У семьи нет такого контейнера.");

    new minReward, maxReward;

    switch(type)
    {
        case FW_CONTAINER_BRONZE:
        {
            minReward = 100000;
            maxReward = 250000;
        }
        case FW_CONTAINER_SILVER:
        {
            minReward = 300000;
            maxReward = 600000;
        }
        case FW_CONTAINER_GOLD:
        {
            minReward = 700000;
            maxReward = 1500000;
        }
    }

    new reward = minReward + random(maxReward - minReward + 1);

    new query[600];
    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "UPDATE family_containers SET amount=amount-1 \
        WHERE family_id=%d AND container_type=%d AND amount>0",
        familyid,
        type
    );
    mysql_tquery(FW_DB, query);

    FW_AddFamilyBalance(familyid, reward);

    new msg[220];
    format(
        msg,
        sizeof(msg),
        "Семейный контейнер открыт. В казну семьи начислено %d руб.",
        reward
    );
    SendClientMessage(playerid, FW_GREEN, msg);
    return 1;
}


// =====================================================
// SEASON CLOSE
// =====================================================

stock FW_CloseSeason(newSeasonName[])
{
    new query[1000];

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "UPDATE family_war_seasons SET active=0,end_time=UNIX_TIMESTAMP() WHERE id=%d",
        gFWSeasonID
    );
    mysql_tquery(FW_DB, query);

    mysql_format(
        FW_DB,
        query,
        sizeof(query),
        "INSERT INTO family_war_seasons (name,active,start_time) VALUES ('%e',1,UNIX_TIMESTAMP())",
        newSeasonName
    );
    mysql_tquery(FW_DB, query, "FW_OnNewSeasonCreated");

    return 1;
}

forward FW_OnNewSeasonCreated();
public FW_OnNewSeasonCreated()
{
    gFWSeasonID = cache_insert_id();
    return 1;
}


// =====================================================
// OPTIONAL DIALOG HANDLER
// =====================================================

stock FW_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused playerid
    #pragma unused response
    #pragma unused listitem
    #pragma unused inputtext

    switch(dialogid)
    {
        case DIALOG_FW_LIST,
             DIALOG_FW_STATS,
             DIALOG_FW_HISTORY,
             DIALOG_FW_ROSTER,
             DIALOG_FW_CONTAINER:
        {
            return 1;
        }
    }

    return 0;
}
