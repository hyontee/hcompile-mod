#if defined _NYE_EVENT_INCLUDED
    #endinput
#endif
#define _NYE_EVENT_INCLUDED

/*
    ================================================================
        NYE_Event.inc
        New Year Event for nurisovgei.pwn

        This module intentionally does not declare SA:MP callbacks.
        The main gamemode calls NYE_On* hooks from its existing callbacks.

        Required existing gamemode functions/data:
        - mysql / mysql_format / cache_* / mysql_query
        - GetPlayerData / SetPlayerData / GetPlayerAccountID
        - GetPlayerNameEx / GetPlayerSkinEx
        - GivePlayerMoneyEx / GivePlayerDonate
        - EnablePlayerGPS / DisablePlayerGPS
        - GetPlayerAdminEx
        - Pawn.CMD
        - CreateVehicle extended vehicle.pwn API
    ================================================================
*/

#define NYE_MAX_STATIONS             (6)
#define NYE_MAX_DELIVERIES           (30)
#define NYE_GIFT_REWARD              (700000)
#define NYE_FIRST_REWARD             (15000000)
#define NYE_FIRST_DONATE             (200)
#define NYE_REPEAT_REWARD            (5000000)
#define NYE_COOLDOWN_SECONDS         (21600)
#define NYE_GIFT_SKIN                (122)
#define NYE_NPC_SKIN                 (138)
#define NYE_KEVIN_SKIN               (89)
#define NYE_VEHICLE_MODEL            (466)

#define NYE_TASK_NONE                (0)
#define NYE_TASK_GIFTS               (1)
#define NYE_TASK_LETTER              (2)
#define NYE_TASK_FINISH              (3)

#define NYE_UI_NONE                  (0)
#define NYE_UI_STATION               (1)
#define NYE_UI_KEVIN                 (2)
#define NYE_UI_LETTER                (3)
#define NYE_UI_REWARD                (4)
#define NYE_UI_TOP                   (5)

#define NYE_DB_TABLE                 "nye_event_players"
#define NYE_DB_POINTS_TABLE          "nye_event_deliveries"

new bool:NYE_EventStarted = false;
new NYE_PlayerTask[MAX_PLAYERS];
new NYE_PlayerGifts[MAX_PLAYERS];
new NYE_PlayerMaxGifts[MAX_PLAYERS];
new NYE_PlayerOldSkin[MAX_PLAYERS];
new NYE_PlayerVehicle[MAX_PLAYERS];
new NYE_PlayerCooldown[MAX_PLAYERS];
new NYE_PlayerFirstCompleted[MAX_PLAYERS];
new bool:NYE_PlayerLoaded[MAX_PLAYERS];
new NYE_PlayerUID[MAX_PLAYERS];

new Float:NYE_DeliveryX[MAX_PLAYERS][NYE_MAX_DELIVERIES];
new Float:NYE_DeliveryY[MAX_PLAYERS][NYE_MAX_DELIVERIES];
new Float:NYE_DeliveryZ[MAX_PLAYERS][NYE_MAX_DELIVERIES];

new NYE_StationActor[NYE_MAX_STATIONS];
new NYE_KevinActor = INVALID_ACTOR_ID;
new NYE_LetterActor = INVALID_ACTOR_ID;

new PlayerText:NYE_UIBg[MAX_PLAYERS];
new PlayerText:NYE_UITitle[MAX_PLAYERS];
new PlayerText:NYE_UIBody[MAX_PLAYERS];
new PlayerText:NYE_UIButton1[MAX_PLAYERS];
new PlayerText:NYE_UIButton2[MAX_PLAYERS];
new PlayerText:NYE_UIButton3[MAX_PLAYERS];
new PlayerText:NYE_UINotification[MAX_PLAYERS];
new NYE_PlayerUI[MAX_PLAYERS];
new NYE_RewardTimer[MAX_PLAYERS];

static const Float:NYE_StationPos[NYE_MAX_STATIONS][4] =
{
    {-2647.480712, 1982.734252, 9.980341, 8.738994},
    {830.975952, 799.027770, 13.163070, 246.598968},
    {2753.754150, -2439.541748, 21.813438, 103.678894},
    {-2438.963623, 188.383438, 26.135101, 314.915985},
    {1786.717529, 2533.205566, 14.600519, 209.293609},
    {-2170.725830, 1564.408691, 9.882423, 278.167327}
};

#define NYE_KEVIN_X       (-1364.688964)
#define NYE_KEVIN_Y       (-312.992523)
#define NYE_KEVIN_Z       (257.768646)
#define NYE_KEVIN_A       (71.472312)

#define NYE_LETTER_X      (-442.119506)
#define NYE_LETTER_Y      (-151.455337)
#define NYE_LETTER_Z      (26.171566)
#define NYE_LETTER_A      (318.125244)

stock NYE_OnGameModeInit()
{
    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS nye_event_players (account_id INT UNSIGNED NOT NULL PRIMARY KEY, task TINYINT NOT NULL DEFAULT 0, gifts TINYINT NOT NULL DEFAULT 0, old_skin SMALLINT NOT NULL DEFAULT 0, first_completed TINYINT NOT NULL DEFAULT 0, cooldown INT NOT NULL DEFAULT 0, total_gifts INT NOT NULL DEFAULT 0) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        false
    );
    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS nye_event_deliveries (id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, account_id INT UNSIGNED NOT NULL, x DOUBLE NOT NULL, y DOUBLE NOT NULL, z DOUBLE NOT NULL, INDEX(account_id)) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4",
        false
    );

    for(new i = 0; i < NYE_MAX_STATIONS; i++)
    {
        NYE_StationActor[i] = CreateActor(
            NYE_NPC_SKIN,
            NYE_StationPos[i][0], NYE_StationPos[i][1], NYE_StationPos[i][2], NYE_StationPos[i][3]
        );
        CreateDynamic3DTextLabel(
            "{00FF66}Новогодний Ивент\n{FFFFFF}Нажмите Y для разговора",
            0xFFFFFFFF,
            NYE_StationPos[i][0], NYE_StationPos[i][1], NYE_StationPos[i][2] + 1.0,
            12.0
        );
    }

    NYE_KevinActor = CreateActor(NYE_KEVIN_SKIN, NYE_KEVIN_X, NYE_KEVIN_Y, NYE_KEVIN_Z, NYE_KEVIN_A);
    CreateDynamic3DTextLabel(
        "{00FF66}Кевин\n{FFFFFF}Новогодний ивент",
        0xFFFFFFFF,
        NYE_KEVIN_X, NYE_KEVIN_Y, NYE_KEVIN_Z + 1.0,
        15.0
    );

    NYE_LetterActor = CreateActor(NYE_NPC_SKIN, NYE_LETTER_X, NYE_LETTER_Y, NYE_LETTER_Z, NYE_LETTER_A);
    CreateDynamic3DTextLabel(
        "{00FF66}Новогодний Ивент\n{FFFFFF}Передача письма",
        0xFFFFFFFF,
        NYE_LETTER_X, NYE_LETTER_Y, NYE_LETTER_Z + 1.0,
        12.0
    );
    return 1;
}

stock NYE_OnPlayerConnect(playerid)
{
    NYE_PlayerTask[playerid] = NYE_TASK_NONE;
    NYE_PlayerGifts[playerid] = 0;
    NYE_PlayerMaxGifts[playerid] = 0;
    NYE_PlayerOldSkin[playerid] = 0;
    NYE_PlayerVehicle[playerid] = INVALID_VEHICLE_ID;
    NYE_PlayerCooldown[playerid] = 0;
    NYE_PlayerFirstCompleted[playerid] = 0;
    NYE_PlayerLoaded[playerid] = false;
    NYE_PlayerUID[playerid] = 0;
    NYE_PlayerUI[playerid] = NYE_UI_NONE;
    NYE_RewardTimer[playerid] = 0;

    for(new i = 0; i < NYE_MAX_DELIVERIES; i++)
    {
        NYE_DeliveryX[playerid][i] = 0.0;
        NYE_DeliveryY[playerid][i] = 0.0;
        NYE_DeliveryZ[playerid][i] = 0.0;
    }

    NYE_CreatePlayerUI(playerid);
    return 1;
}

stock NYE_OnPlayerDisconnect(playerid)
{
    if(NYE_RewardTimer[playerid] != 0)
    {
        KillTimer(NYE_RewardTimer[playerid]);
        NYE_RewardTimer[playerid] = 0;
    }

    NYE_HideUI(playerid);

    if(NYE_PlayerVehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(NYE_PlayerVehicle[playerid]))
        DestroyVehicle(NYE_PlayerVehicle[playerid]);

    NYE_PlayerVehicle[playerid] = INVALID_VEHICLE_ID;
    NYE_PlayerLoaded[playerid] = false;
    return 1;
}

stock NYE_LoadPlayer(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(NYE_PlayerLoaded[playerid] && NYE_PlayerUID[playerid] == GetPlayerAccountID(playerid)) return 1;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    NYE_PlayerUID[playerid] = account_id;
    NYE_PlayerLoaded[playerid] = true;

    new query[512];
    mysql_format(mysql, query, sizeof query,
        "SELECT task,gifts,old_skin,first_completed,cooldown,total_gifts FROM nye_event_players WHERE account_id=%d LIMIT 1",
        account_id
    );

    new Cache:result = mysql_query(mysql, query, true);
    if(!mysql_errno() && cache_num_rows() > 0)
    {
        NYE_PlayerTask[playerid] = cache_get_field_content_int(0, "task");
        NYE_PlayerGifts[playerid] = cache_get_field_content_int(0, "gifts");
        NYE_PlayerOldSkin[playerid] = cache_get_field_content_int(0, "old_skin");
        NYE_PlayerFirstCompleted[playerid] = cache_get_field_content_int(0, "first_completed");
        NYE_PlayerCooldown[playerid] = cache_get_field_content_int(0, "cooldown");
    }
    else
    {
        NYE_PlayerTask[playerid] = NYE_TASK_NONE;
        NYE_PlayerGifts[playerid] = 0;
        NYE_PlayerOldSkin[playerid] = 0;
        NYE_PlayerFirstCompleted[playerid] = 0;
        NYE_PlayerCooldown[playerid] = 0;

        mysql_format(mysql, query, sizeof query,
            "INSERT IGNORE INTO nye_event_players (account_id) VALUES (%d)", account_id
        );
        mysql_query(mysql, query, false);
    }
    cache_delete(result);

    for(new i = 0; i < NYE_MAX_DELIVERIES; i++)
    {
        NYE_DeliveryX[playerid][i] = 0.0;
        NYE_DeliveryY[playerid][i] = 0.0;
        NYE_DeliveryZ[playerid][i] = 0.0;
    }

    mysql_format(mysql, query, sizeof query,
        "SELECT x,y,z FROM nye_event_deliveries WHERE account_id=%d ORDER BY id ASC LIMIT %d",
        account_id, NYE_MAX_DELIVERIES
    );
    result = mysql_query(mysql, query, true);
    if(!mysql_errno())
    {
        new rows = cache_num_rows();
        if(rows > NYE_MAX_DELIVERIES) rows = NYE_MAX_DELIVERIES;
        for(new i = 0; i < rows; i++)
        {
            NYE_DeliveryX[playerid][i] = cache_get_field_content_float(i, "x");
            NYE_DeliveryY[playerid][i] = cache_get_field_content_float(i, "y");
            NYE_DeliveryZ[playerid][i] = cache_get_field_content_float(i, "z");
        }
    }
    cache_delete(result);

    NYE_PlayerMaxGifts[playerid] = NYE_PlayerFirstCompleted[playerid] ? 25 : 30;
    return 1;
}

stock NYE_SavePlayer(playerid)
{
    if(!NYE_PlayerLoaded[playerid] || NYE_PlayerUID[playerid] <= 0) return 0;

    new query[768];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO nye_event_players (account_id,task,gifts,old_skin,first_completed,cooldown,total_gifts) VALUES (%d,%d,%d,%d,%d,%d,%d) ON DUPLICATE KEY UPDATE task=VALUES(task),gifts=VALUES(gifts),old_skin=VALUES(old_skin),first_completed=VALUES(first_completed),cooldown=VALUES(cooldown),total_gifts=VALUES(total_gifts)",
        NYE_PlayerUID[playerid], NYE_PlayerTask[playerid], NYE_PlayerGifts[playerid], NYE_PlayerOldSkin[playerid],
        NYE_PlayerFirstCompleted[playerid], NYE_PlayerCooldown[playerid], NYE_GetTotalGifts(playerid)
    );
    mysql_query(mysql, query, false);
    return 1;
}

stock NYE_GetTotalGifts(playerid)
{
    if(!NYE_PlayerLoaded[playerid] || NYE_PlayerUID[playerid] <= 0) return 0;

    new query[192];
    mysql_format(mysql, query, sizeof query,
        "SELECT total_gifts FROM nye_event_players WHERE account_id=%d LIMIT 1",
        NYE_PlayerUID[playerid]
    );
    new Cache:result = mysql_query(mysql, query, true);
    new value = 0;
    if(!mysql_errno() && cache_num_rows() > 0)
        value = cache_get_field_content_int(0, "total_gifts");
    cache_delete(result);
    return value;
}

stock NYE_SetTotalGifts(playerid, value)
{
    if(!NYE_PlayerLoaded[playerid] || NYE_PlayerUID[playerid] <= 0) return 0;

    new query[256];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO nye_event_players (account_id,total_gifts) VALUES (%d,%d) ON DUPLICATE KEY UPDATE total_gifts=%d",
        NYE_PlayerUID[playerid], value, value
    );
    mysql_query(mysql, query, false);
    return 1;
}

stock NYE_GetCooldownLeft(playerid)
{
    new left = NYE_PlayerCooldown[playerid] - gettime();
    return left > 0 ? left : 0;
}

stock NYE_CreatePlayerUI(playerid)
{
    NYE_UIBg[playerid] = CreatePlayerTextDraw(playerid, 145.0, 145.0, "_");
    PlayerTextDrawLetterSize(playerid, NYE_UIBg[playerid], 0.0, 0.0);
    PlayerTextDrawTextSize(playerid, NYE_UIBg[playerid], 495.0, 370.0);
    PlayerTextDrawUseBox(playerid, NYE_UIBg[playerid], 1);
    PlayerTextDrawBoxColor(playerid, NYE_UIBg[playerid], 0x101820EE);
    PlayerTextDrawFont(playerid, NYE_UIBg[playerid], 1);
    PlayerTextDrawSetProportional(playerid, NYE_UIBg[playerid], 1);

    NYE_UITitle[playerid] = CreatePlayerTextDraw(playerid, 170.0, 160.0, "НОВОГОДНИЙ ИВЕНТ");
    PlayerTextDrawLetterSize(playerid, NYE_UITitle[playerid], 0.32, 1.55);
    PlayerTextDrawColor(playerid, NYE_UITitle[playerid], 0x00FF66FF);
    PlayerTextDrawFont(playerid, NYE_UITitle[playerid], 2);
    PlayerTextDrawSetProportional(playerid, NYE_UITitle[playerid], 1);

    NYE_UIBody[playerid] = CreatePlayerTextDraw(playerid, 170.0, 195.0, "");
    PlayerTextDrawLetterSize(playerid, NYE_UIBody[playerid], 0.24, 1.20);
    PlayerTextDrawColor(playerid, NYE_UIBody[playerid], 0xFFFFFFFF);
    PlayerTextDrawFont(playerid, NYE_UIBody[playerid], 1);
    PlayerTextDrawSetProportional(playerid, NYE_UIBody[playerid], 1);
    PlayerTextDrawTextSize(playerid, NYE_UIBody[playerid], 470.0, 0.0);

    NYE_UIButton1[playerid] = CreatePlayerTextDraw(playerid, 170.0, 315.0, "");
    NYE_UIButton2[playerid] = CreatePlayerTextDraw(playerid, 330.0, 315.0, "");
    NYE_UIButton3[playerid] = CreatePlayerTextDraw(playerid, 400.0, 345.0, "ЗАКРЫТЬ");

    NYE_UINotification[playerid] = CreatePlayerTextDraw(playerid, 170.0, 385.0, "");
    PlayerTextDrawLetterSize(playerid, NYE_UINotification[playerid], 0.22, 1.10);
    PlayerTextDrawColor(playerid, NYE_UINotification[playerid], 0x66FF99FF);
    PlayerTextDrawFont(playerid, NYE_UINotification[playerid], 2);
    PlayerTextDrawSetProportional(playerid, NYE_UINotification[playerid], 1);

    NYE_SetButton(playerid, NYE_UIButton1[playerid]);
    NYE_SetButton(playerid, NYE_UIButton2[playerid]);
    NYE_SetButton(playerid, NYE_UIButton3[playerid]);
    return 1;
}

stock NYE_SetButton(playerid, PlayerText:td)
{
    PlayerTextDrawLetterSize(playerid, td, 0.22, 1.10);
    PlayerTextDrawTextSize(playerid, td, 110.0, 25.0);
    PlayerTextDrawColor(playerid, td, 0xFFFFFFFF);
    PlayerTextDrawFont(playerid, td, 2);
    PlayerTextDrawSetProportional(playerid, td, 1);
    PlayerTextDrawUseBox(playerid, td, 1);
    PlayerTextDrawBoxColor(playerid, td, 0x24412FFF);
    PlayerTextDrawSetSelectable(playerid, td, true);
    return 1;
}

stock NYE_ShowUI(playerid, ui_type, const title[], const body[], const button1[], const button2[] = "", const close_button[] = "ЗАКРЫТЬ")
{
    NYE_HideUI(playerid);

    NYE_PlayerUI[playerid] = ui_type;
    PlayerTextDrawSetString(playerid, NYE_UITitle[playerid], title);
    PlayerTextDrawSetString(playerid, NYE_UIBody[playerid], body);
    PlayerTextDrawSetString(playerid, NYE_UIButton1[playerid], button1);
    PlayerTextDrawSetString(playerid, NYE_UIButton2[playerid], button2);
    PlayerTextDrawSetString(playerid, NYE_UIButton3[playerid], close_button);

    PlayerTextDrawShow(playerid, NYE_UIBg[playerid]);
    PlayerTextDrawShow(playerid, NYE_UITitle[playerid]);
    PlayerTextDrawShow(playerid, NYE_UIBody[playerid]);

    if(strlen(button1)) PlayerTextDrawShow(playerid, NYE_UIButton1[playerid]);
    if(strlen(button2)) PlayerTextDrawShow(playerid, NYE_UIButton2[playerid]);
    PlayerTextDrawShow(playerid, NYE_UIButton3[playerid]);

    SelectTextDraw(playerid, 0x00FF66FF);
    return 1;
}

stock NYE_HideUI(playerid)
{
    if(NYE_PlayerUI[playerid] == NYE_UI_NONE) return 0;

    PlayerTextDrawHide(playerid, NYE_UIBg[playerid]);
    PlayerTextDrawHide(playerid, NYE_UITitle[playerid]);
    PlayerTextDrawHide(playerid, NYE_UIBody[playerid]);
    PlayerTextDrawHide(playerid, NYE_UIButton1[playerid]);
    PlayerTextDrawHide(playerid, NYE_UIButton2[playerid]);
    PlayerTextDrawHide(playerid, NYE_UIButton3[playerid]);
    CancelSelectTextDraw(playerid);
    NYE_PlayerUI[playerid] = NYE_UI_NONE;
    return 1;
}

stock NYE_ShowStationDialog(playerid)
{
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    NYE_LoadPlayer(playerid);

    new body[700];
    format(body, sizeof body,
        "Привет! Похоже, ты как раз тот человек, который сможет помочь нам с новогодней доставкой.\n\nДед Мороз потерял помощников, а подарки уже нужно развозить.\nХочешь принять участие в новогоднем ивенте?");
    return NYE_ShowUI(playerid, NYE_UI_STATION, "НОВОГОДНИЙ ИВЕНТ", body, "ДА, ХОЧУ!", "НЕТ, НЕ ХОЧУ!");
}

stock NYE_StationAccept(playerid)
{
    NYE_HideUI(playerid);
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    if(!NYE_LoadPlayer(playerid)) return 1;

    if(NYE_PlayerTask[playerid] != NYE_TASK_NONE)
    {
        return SendClientMessage(playerid, 0xFFCC33FF, "У вас уже есть активное задание новогоднего ивента. Отправляйтесь к Кевину.");
    }

    new cooldown = NYE_GetCooldownLeft(playerid);
    if(cooldown > 0)
    {
        new msg[144];
        format(msg, sizeof msg, "Повторное задание будет доступно через %d ч. %d мин.", cooldown / 3600, (cooldown % 3600) / 60);
        return SendClientMessage(playerid, 0xFFCC33FF, msg);
    }

    EnablePlayerGPS(playerid, 55, NYE_KEVIN_X, NYE_KEVIN_Y, NYE_KEVIN_Z, "Отправляйтесь к Деду Морозу, он расскажет вам о задании.");
    return 1;
}

stock NYE_ShowKevinDialog(playerid)
{
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    if(!NYE_LoadPlayer(playerid)) return 1;

    if(NYE_PlayerTask[playerid] == NYE_TASK_FINISH)
        return NYE_FinishEvent(playerid);

    if(NYE_PlayerTask[playerid] == NYE_TASK_LETTER)
        return SendClientMessage(playerid, 0xFFCC33FF, "Вы уже получили письмо. Отвезите его на гору.");

    if(NYE_PlayerTask[playerid] == NYE_TASK_GIFTS && NYE_PlayerGifts[playerid] >= NYE_PlayerMaxGifts[playerid])
    {
        new body[500];
        format(body, sizeof body,
            "Отличная работа!\n\nНо это ещё не всё.\nМне нужно передать важные документы.\nОтвези этот лист бумаги на гору.");
        return NYE_ShowUI(playerid, NYE_UI_KEVIN, "КЕВИН", body, "ВЗЯТЬ ПИСЬМО", "ПОЗЖЕ");
    }

    if(NYE_PlayerTask[playerid] == NYE_TASK_GIFTS)
    {
        new body[500];
        format(body, sizeof body,
            "Ты уже выполняешь задание.\n\nДоставлено подарков: %d/%d\n\nПродолжай развозить подарки и используй /epoint в новых местах.",
            NYE_PlayerGifts[playerid], NYE_PlayerMaxGifts[playerid]);
        return NYE_ShowUI(playerid, NYE_UI_KEVIN, "КЕВИН", body, "ПРОДОЛЖИТЬ", "ПОЗЖЕ");
    }

    new cooldown = NYE_GetCooldownLeft(playerid);
    if(cooldown > 0)
    {
        new body[300];
        format(body, sizeof body, "Спасибо за прошлую помощь!\n\nНовое задание будет доступно через %d ч. %d мин.", cooldown / 3600, (cooldown % 3600) / 60);
        return NYE_ShowUI(playerid, NYE_UI_KEVIN, "КЕВИН", body, "", "ПОЗЖЕ");
    }

    new body[700];
    format(body, sizeof body,
        "Привет! Я Кевин, помощник Деда Мороза.\n\nНам срочно нужна помощь с доставкой подарков.\nЕсли согласишься, я дам тебе костюм Деда Мороза и праздничную машину.\nТебе нужно будет развозить подарки по городу.");
    return NYE_ShowUI(playerid, NYE_UI_KEVIN, "КЕВИН", body, "ВЗЯТЬ ЗАДАНИЕ", "ПОЗЖЕ");
}

stock NYE_TakeTask(playerid)
{
    NYE_HideUI(playerid);
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    if(!NYE_LoadPlayer(playerid)) return 1;
    if(NYE_PlayerTask[playerid] != NYE_TASK_NONE) return 1;

    if(NYE_GetCooldownLeft(playerid) > 0)
        return SendClientMessage(playerid, 0xFFCC33FF, "Повторное задание пока недоступно.");

    NYE_PlayerOldSkin[playerid] = GetPlayerSkin(playerid);
    NYE_PlayerFirstCompleted[playerid] = NYE_PlayerFirstCompleted[playerid] ? 1 : 0;
    NYE_PlayerMaxGifts[playerid] = NYE_PlayerFirstCompleted[playerid] ? 25 : 30;
    NYE_PlayerGifts[playerid] = 0;
    NYE_PlayerTask[playerid] = NYE_TASK_GIFTS;

    SetPlayerSkin(playerid, NYE_GIFT_SKIN);

    for(new i = 0; i < NYE_MAX_DELIVERIES; i++)
    {
        NYE_DeliveryX[playerid][i] = 0.0;
        NYE_DeliveryY[playerid][i] = 0.0;
        NYE_DeliveryZ[playerid][i] = 0.0;
    }

    new query[256];
    mysql_format(mysql, query, sizeof query, "DELETE FROM nye_event_deliveries WHERE account_id=%d", NYE_PlayerUID[playerid]);
    mysql_query(mysql, query, false);

    NYE_CreateEventVehicle(playerid);
    NYE_SavePlayer(playerid);

    new msg[180];
    format(msg, sizeof msg, "Задание начато! Доставьте подарки: 0/%d. Используйте /epoint в новом месте.", NYE_PlayerMaxGifts[playerid]);
    SendClientMessage(playerid, 0x66FF99FF, msg);
    return 1;
}

stock NYE_CreateEventVehicle(playerid)
{
    if(NYE_PlayerVehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(NYE_PlayerVehicle[playerid]))
        DestroyVehicle(NYE_PlayerVehicle[playerid]);

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    x += floatsin(-a, degrees) * 5.0;
    y += floatcos(-a, degrees) * 5.0;

    NYE_PlayerVehicle[playerid] = CreateVehicle(
        NYE_VEHICLE_MODEL, x, y, z, a,
        0, 1, -1, 0,
        VEHICLE_ACTION_TYPE_GIFT_CAR, playerid
    );

    if(NYE_PlayerVehicle[playerid] != INVALID_VEHICLE_ID)
    {
        SetVehicleVirtualWorld(NYE_PlayerVehicle[playerid], GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(NYE_PlayerVehicle[playerid], GetPlayerInterior(playerid));
        SetVehicleParam(NYE_PlayerVehicle[playerid], V_ENGINE, VEHICLE_PARAM_ON);
        PutPlayerInVehicle(playerid, NYE_PlayerVehicle[playerid], 0);
    }
    return NYE_PlayerVehicle[playerid];
}

stock NYE_IsValidDeliveryVehicle(playerid)
{
    if(NYE_PlayerVehicle[playerid] == INVALID_VEHICLE_ID) return 0;
    if(!IsValidVehicle(NYE_PlayerVehicle[playerid])) return 0;
    if(GetPlayerVehicleID(playerid) != NYE_PlayerVehicle[playerid]) return 0;
    if(GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return 0;
    return 1;
}

stock NYE_IsDeliveryPointUsed(playerid, Float:x, Float:y, Float:z)
{
    new max = NYE_PlayerGifts[playerid];
    if(max > NYE_MAX_DELIVERIES) max = NYE_MAX_DELIVERIES;

    for(new i = 0; i < max; i++)
    {
        if(NYE_DeliveryX[playerid][i] == 0.0 && NYE_DeliveryY[playerid][i] == 0.0) continue;
        if(NYE_Distance(NYE_DeliveryX[playerid][i], NYE_DeliveryY[playerid][i], NYE_DeliveryZ[playerid][i], x, y, z) < 8.0)
            return 1;
    }
    return 0;
}

stock Float:NYE_Distance(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return floatsqroot((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2));
}

stock NYE_ProcessDelivery(playerid)
{
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    if(!NYE_LoadPlayer(playerid)) return 1;
    if(NYE_PlayerTask[playerid] != NYE_TASK_GIFTS) return SendClientMessage(playerid, 0xFFCC33FF, "У вас нет активного задания.");
    if(NYE_PlayerGifts[playerid] >= NYE_PlayerMaxGifts[playerid]) return SendClientMessage(playerid, 0xFFCC33FF, "Вы уже доставили все подарки.");
    if(!NYE_IsValidDeliveryVehicle(playerid)) return SendClientMessage(playerid, 0xFFCC33FF, "Для доставки нужно находиться за рулём праздничной машины.");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    if(NYE_IsDeliveryPointUsed(playerid, x, y, z))
        return SendClientMessage(playerid, 0xFF5533FF, "Вы уже доставляли подарок в этом месте.");

    new slot = NYE_PlayerGifts[playerid];
    if(slot >= NYE_MAX_DELIVERIES) return 1;

    NYE_DeliveryX[playerid][slot] = x;
    NYE_DeliveryY[playerid][slot] = y;
    NYE_DeliveryZ[playerid][slot] = z;
    NYE_PlayerGifts[playerid]++;

    new query[384];
    mysql_format(mysql, query, sizeof query,
        "INSERT INTO nye_event_deliveries (account_id,x,y,z) VALUES (%d,%f,%f,%f)",
        NYE_PlayerUID[playerid], x, y, z
    );
    mysql_query(mysql, query, false);

    new total = NYE_GetTotalGifts(playerid) + 1;
    NYE_SetTotalGifts(playerid, total);

    GivePlayerMoneyEx(playerid, NYE_GIFT_REWARD, "Новогодний ивент: доставка подарка", true, false);

    new msg[160];
    format(msg, sizeof msg, "Доставлено подарков: %d/%d", NYE_PlayerGifts[playerid], NYE_PlayerMaxGifts[playerid]);
    SendClientMessage(playerid, 0x66FF99FF, msg);

    NYE_ShowRewardNotification(playerid);
    NYE_SavePlayer(playerid);

    if(NYE_PlayerGifts[playerid] >= NYE_PlayerMaxGifts[playerid])
    {
        SendClientMessage(playerid, 0x00FF66FF, "Вы отвезли все подарки! Отправляйтесь к Кевину.");
        EnablePlayerGPS(playerid, 55, NYE_KEVIN_X, NYE_KEVIN_Y, NYE_KEVIN_Z, "Все подарки доставлены. Возвращайтесь к Кевину.");
    }
    return 1;
}

stock NYE_ShowRewardNotification(playerid)
{
    PlayerTextDrawSetString(playerid, NYE_UINotification[playerid], "Вы получили 700.000");
    PlayerTextDrawShow(playerid, NYE_UINotification[playerid]);

    if(NYE_RewardTimer[playerid] != 0) KillTimer(NYE_RewardTimer[playerid]);
    NYE_RewardTimer[playerid] = SetTimerEx("NYE_HideRewardNotification", 3500, false, "d", playerid);
    return 1;
}

forward NYE_HideRewardNotification(playerid);
public NYE_HideRewardNotification(playerid)
{
    NYE_RewardTimer[playerid] = 0;
    PlayerTextDrawHide(playerid, NYE_UINotification[playerid]);
    return 1;
}

stock NYE_TakeLetter(playerid)
{
    NYE_HideUI(playerid);
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    if(!NYE_LoadPlayer(playerid)) return 1;
    if(NYE_PlayerTask[playerid] != NYE_TASK_GIFTS || NYE_PlayerGifts[playerid] < NYE_PlayerMaxGifts[playerid])
        return SendClientMessage(playerid, 0xFFCC33FF, "Сначала нужно доставить все подарки.");

    NYE_PlayerTask[playerid] = NYE_TASK_LETTER;
    NYE_SavePlayer(playerid);
    EnablePlayerGPS(playerid, 55, NYE_LETTER_X, NYE_LETTER_Y, NYE_LETTER_Z, "Отвезите письмо на гору.");
    SendClientMessage(playerid, 0x66FF99FF, "Письмо получено. Отвезите его на гору.");
    return 1;
}

stock NYE_ShowLetterDialog(playerid)
{
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    if(!NYE_LoadPlayer(playerid)) return 1;
    if(NYE_PlayerTask[playerid] != NYE_TASK_LETTER)
        return SendClientMessage(playerid, 0xFFCC33FF, "У вас нет активного задания по передаче письма.");

    new body[400];
    format(body, sizeof body,
        "Спасибо, что помог нам подготовить праздник!\n\nВот твоё вознаграждение за выполненную работу.");
    return NYE_ShowUI(playerid, NYE_UI_LETTER, "НОВОГОДНИЙ ИВЕНТ", body, "ПОЛУЧИТЬ НАГРАДУ", "", "ЗАКРЫТЬ");
}

stock NYE_ProcessLetter(playerid)
{
    NYE_HideUI(playerid);
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    if(!NYE_LoadPlayer(playerid)) return 1;
    if(NYE_PlayerTask[playerid] != NYE_TASK_LETTER) return SendClientMessage(playerid, 0xFFCC33FF, "Письмо уже передано или задание не активно.");

    NYE_PlayerTask[playerid] = NYE_TASK_FINISH;

    if(!NYE_PlayerFirstCompleted[playerid])
    {
        NYE_PlayerFirstCompleted[playerid] = 1;
        GivePlayerMoneyEx(playerid, NYE_FIRST_REWARD, "Новогодний ивент: первое прохождение", true, false);
        GivePlayerDonate(playerid, NYE_FIRST_DONATE, "Новогодний ивент: первое прохождение", true);
        NYE_SavePlayer(playerid);
        NYE_ShowFirstReward(playerid);
    }
    else
    {
        GivePlayerMoneyEx(playerid, NYE_REPEAT_REWARD, "Новогодний ивент: повторное прохождение", true, false);
        NYE_SavePlayer(playerid);
        NYE_ShowRepeatReward(playerid);
    }

    return 1;
}

stock NYE_ShowFirstReward(playerid)
{
    new body[650];
    format(body, sizeof body,
        "Вы выполнили все задания!\n\nВы получили:\n\n15.000.000 $\n200 DONATE\n\nСпасибо за участие!");
    return NYE_ShowUI(playerid, NYE_UI_REWARD, "НОВОГОДНИЙ ИВЕНТ", body, "", "", "ЗАКРЫТЬ");
}

stock NYE_ShowRepeatReward(playerid)
{
    new body[600];
    format(body, sizeof body,
        "Вы выполнили все задания!\n\nВы получили:\n\n5.000.000 $\n\nСпасибо за помощь!");
    return NYE_ShowUI(playerid, NYE_UI_REWARD, "НОВОГОДНИЙ ИВЕНТ", body, "", "", "ЗАКРЫТЬ");
}

stock NYE_FinishEvent(playerid)
{
    NYE_HideUI(playerid);
    if(!NYE_EventStarted) return SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
    if(!NYE_LoadPlayer(playerid)) return 1;
    if(NYE_PlayerTask[playerid] != NYE_TASK_FINISH) return 0;

    if(NYE_PlayerVehicle[playerid] != INVALID_VEHICLE_ID && IsValidVehicle(NYE_PlayerVehicle[playerid]))
        DestroyVehicle(NYE_PlayerVehicle[playerid]);
    NYE_PlayerVehicle[playerid] = INVALID_VEHICLE_ID;

    if(NYE_PlayerOldSkin[playerid] > 0)
        SetPlayerSkin(playerid, NYE_PlayerOldSkin[playerid]);

    DisablePlayerGPS(playerid);

    new query[256];
    mysql_format(mysql, query, sizeof query, "DELETE FROM nye_event_deliveries WHERE account_id=%d", NYE_PlayerUID[playerid]);
    mysql_query(mysql, query, false);

    NYE_PlayerTask[playerid] = NYE_TASK_NONE;
    NYE_PlayerGifts[playerid] = 0;
    NYE_PlayerMaxGifts[playerid] = 0;
    NYE_PlayerOldSkin[playerid] = 0;
    NYE_PlayerCooldown[playerid] = gettime() + NYE_COOLDOWN_SECONDS;

    NYE_SavePlayer(playerid);

    SendClientMessage(playerid, 0x66FF99FF, "Новогоднее задание завершено! Следующее прохождение будет доступно через 6 часов.");
    return 1;
}

stock NYE_ShowTop(playerid)
{
    if(!NYE_LoadPlayer(playerid)) return 1;

    new body[1700];
    body[0] = 0;
    strcat(body, "ТОП-10 ИГРОКОВ ПО ДОСТАВЛЕННЫМ ПОДАРКАМ\n\n");

    new query[512];
    format(query, sizeof query,
        "SELECT a.name,p.total_gifts FROM nye_event_players p LEFT JOIN accounts a ON a.id=p.account_id WHERE p.total_gifts>0 ORDER BY p.total_gifts DESC, a.name ASC LIMIT 10");
    new Cache:result = mysql_query(mysql, query, true);

    if(!mysql_errno())
    {
        new rows = cache_num_rows();
        if(rows > 10) rows = 10;
        if(rows == 0)
        {
            strcat(body, "Пока нет игроков с доставленными подарками.");
        }
        else
        {
            new name[MAX_PLAYER_NAME + 1];
            new line[128];
            for(new i = 0; i < rows; i++)
            {
                cache_get_field_content(i, "name", name, mysql, sizeof name);
                format(line, sizeof line, "%d# %s — %d подарков\n", i + 1, name, cache_get_field_content_int(i, "total_gifts"));
                strcat(body, line);
            }
        }
    }
    cache_delete(result);

    return NYE_ShowUI(playerid, NYE_UI_TOP, "ТОП НОВОГОДНЕГО ИВЕНТА", body, "", "", "ЗАКРЫТЬ");
}

stock NYE_StartEvent()
{
    NYE_EventStarted = true;
    return 1;
}

stock NYE_StopEvent()
{
    NYE_EventStarted = false;
    return 1;
}

stock NYE_OnKeyStateChange(playerid, newkeys, oldkeys)
{
    if(!(newkeys & KEY_YES) || (oldkeys & KEY_YES)) return 0;
    if(!IsPlayerConnected(playerid)) return 0;

    if(!NYE_EventStarted)
    {
        for(new i = 0; i < NYE_MAX_STATIONS; i++)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, NYE_StationPos[i][0], NYE_StationPos[i][1], NYE_StationPos[i][2]))
            {
                SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
                return 1;
            }
        }
        if(IsPlayerInRangeOfPoint(playerid, 4.0, NYE_KEVIN_X, NYE_KEVIN_Y, NYE_KEVIN_Z) ||
           IsPlayerInRangeOfPoint(playerid, 4.0, NYE_LETTER_X, NYE_LETTER_Y, NYE_LETTER_Z))
        {
            SendClientMessage(playerid, 0xFF5533FF, "Новогодний ивент сейчас не начался.");
            return 1;
        }
        return 0;
    }

    for(new i = 0; i < NYE_MAX_STATIONS; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 3.0, NYE_StationPos[i][0], NYE_StationPos[i][1], NYE_StationPos[i][2]))
            return NYE_ShowStationDialog(playerid);
    }

    if(IsPlayerInRangeOfPoint(playerid, 4.0, NYE_KEVIN_X, NYE_KEVIN_Y, NYE_KEVIN_Z))
        return NYE_ShowKevinDialog(playerid);

    if(IsPlayerInRangeOfPoint(playerid, 4.0, NYE_LETTER_X, NYE_LETTER_Y, NYE_LETTER_Z))
        return NYE_ShowLetterDialog(playerid);

    return 0;
}

stock NYE_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    if(NYE_PlayerUI[playerid] == NYE_UI_NONE) return 0;

    if(playertextid == NYE_UIButton3[playerid])
    {
        new ui = NYE_PlayerUI[playerid];
        NYE_HideUI(playerid);
        if(ui == NYE_UI_REWARD)
            SendClientMessage(playerid, 0x66FF99FF, "Вернитесь к Кевину, чтобы завершить задание.");
        return 1;
    }

    if(playertextid == NYE_UIButton1[playerid])
    {
        switch(NYE_PlayerUI[playerid])
        {
            case NYE_UI_STATION: return NYE_StationAccept(playerid);
            case NYE_UI_KEVIN:
            {
                if(NYE_PlayerTask[playerid] == NYE_TASK_GIFTS && NYE_PlayerGifts[playerid] >= NYE_PlayerMaxGifts[playerid])
                    return NYE_TakeLetter(playerid);
                if(NYE_PlayerTask[playerid] == NYE_TASK_NONE)
                    return NYE_TakeTask(playerid);
                NYE_HideUI(playerid);
                return 1;
            }
            case NYE_UI_LETTER: return NYE_ProcessLetter(playerid);
        }
    }

    if(playertextid == NYE_UIButton2[playerid])
    {
        NYE_HideUI(playerid);
        return 1;
    }
    return 0;
}

CMD:epoint(playerid, params[])
{
    #pragma unused params
    return NYE_ProcessDelivery(playerid);
}

CMD:topevent(playerid, params[])
{
    #pragma unused params
    return NYE_ShowTop(playerid);
}

CMD:startevent(playerid, params[])
{
    #pragma unused params
    if(GetPlayerAdminEx(playerid) < 1)
        return SendClientMessage(playerid, 0xFF5533FF, "Недостаточно прав.");

    if(NYE_EventStarted)
        return SendClientMessage(playerid, 0xFFCC33FF, "Новогодний ивент уже запущен.");

    NYE_StartEvent();
    SendClientMessageToAll(0x00FF66FF, "Новогодний ивент запущен! Все новогодние NPC снова доступны.");
    return 1;
}

CMD:stopevent(playerid, params[])
{
    #pragma unused params
    if(GetPlayerAdminEx(playerid) < 1)
        return SendClientMessage(playerid, 0xFF5533FF, "Недостаточно прав.");

    if(!NYE_EventStarted)
        return SendClientMessage(playerid, 0xFFCC33FF, "Новогодний ивент уже выключен.");

    NYE_StopEvent();
    SendClientMessageToAll(0xFF5533FF, "Новогодний ивент отключён. Новые действия временно недоступны.");
    return 1;
}

