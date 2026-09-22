//>> Файл: bykranin_src/core/admin/admin_02.inc  (294 строк)
//>> Тема: админ-команды и модерация
//>> Внутри: TeleportFreeze, TeleportUnfreeze, PlacePlayerInJail, JailPlayer, UnjailPlayer, UpdatePlayerDatabaseInt, UpdatePlayerDatabaseFloat
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock TeleportFreeze(playerid, ms)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(ms < 350) ms = 350;
    if(ms > 2000) ms = 2000;
    if(g_teleport_freeze_timer[playerid]) KillTimer(g_teleport_freeze_timer[playerid]);
    new epoch = ++g_teleport_freeze_epoch[playerid];
    TogglePlayerControllable(playerid, false);
    g_teleport_freeze_timer[playerid] = SetTimerEx("TeleportUnfreeze", ms, false, "dd", playerid, epoch);
    return 1;
}

public: TeleportUnfreeze(playerid, epoch)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;
    if(epoch != g_teleport_freeze_epoch[playerid]) return 0;
    g_teleport_freeze_timer[playerid] = 0;
    TogglePlayerControllable(playerid, true);
    return 1;
}

stock PlacePlayerInJail(playerid)
{
	new jail_pos = random(sizeof g_jail_positions);
	RemovePlayerFromVehicle(playerid);
	return SetPlayerPosEx
	(
		playerid,
		g_jail_positions[jail_pos][0],
		g_jail_positions[jail_pos][1],
		g_jail_positions[jail_pos][2] + 0.15,
		g_jail_positions[jail_pos][3],
		1, 6
	);
}

stock JailPlayer(playerid, jail_time)
{
	SetPlayerData(playerid, P_JAIL, jail_time * 60);
	PlacePlayerInJail(playerid);
	UpdatePlayerDatabaseInt(playerid, "jail", jail_time * 60);
	return 1;
}

stock UnjailPlayer(playerid)
{
	new spawn_id = random(5);

    SetPlayerPosEx
    (
        playerid,
        spawn_pos_data[spawn_id][0]  + random(3),
        spawn_pos_data[spawn_id][1]  + random(3),
        spawn_pos_data[spawn_id][2],
        spawn_pos_data[spawn_id][3],
        0, 0
    );

	SetPlayerData(playerid, P_JAIL, 0);
	UpdatePlayerDatabaseInt(playerid, "jail", 0);
}

stock UpdatePlayerDatabaseInt(playerid, field[], value)
{
	if(!IsPlayerConnected(playerid)) return 1;

	new query[256];

	mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `%s`=%d WHERE `id`=%d LIMIT 1", field, value, GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);
	return 1;
}

stock UpdatePlayerDatabaseFloat(playerid, field[], Float:value)
{
	if(!IsPlayerConnected(playerid)) return 1;

	new query[256];

	mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `%s`='%f' WHERE `id`=%d LIMIT 1", field, value, GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);
	return 1;
}

stock UpdatePlayerDatabaseString(playerid, field[], value[])
{
	if(!IsPlayerConnected(playerid)) return 1;

	new query[256];

	mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `%s`='%s' WHERE `id`=%d LIMIT 1", field, value, GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);
	return 1;
}

stock DestroyAdminBadge(playerid)
{
    if(IsValidDynamic3DTextLabel(g_admin_badge[playerid]))
        DestroyDynamic3DTextLabel(g_admin_badge[playerid]);
    g_admin_badge[playerid] = Text3D:INVALID_3DTEXT_ID;
    return 1;
}

stock RefreshAdminBadge(playerid)
{
    // Бейдж "[ ADMIN ]" над головой отключен по просьбе администрации.
    // Вместо него используется выбираемый/RGB цвет ника: см. AdminNickRainbowApply,
    // AdminNickRainbowTick и команду /nickcolor ниже.
    DestroyAdminBadge(playerid);
    return 1;
}

// ===================== Цвет ника администратора (замена бейджа "[ ADMIN ]") =====================

new const g_admin_nick_colors[8] =
{
    0xFF2020FF, // Красный
    0x20FF20FF, // Зелёный
    0x2060FFFF, // Синий
    0xFFFF20FF, // Жёлтый
    0xFFFFFFFF, // Белый
    0x20FFFFFF, // Голубой
    0xFF20C0FF, // Розовый
    0xFF9900FF  // Оранжевый
};

stock GetAdminRainbowColor(deg)
{
    new Float:r = (floatsin(float(deg), degrees) + 1.0) * 127.5;
    new Float:g = (floatsin(float(deg) + 120.0, degrees) + 1.0) * 127.5;
    new Float:b = (floatsin(float(deg) + 240.0, degrees) + 1.0) * 127.5;
    return (floatround(r) << 24) | (floatround(g) << 16) | (floatround(b) << 8) | 0xFF;
}

stock AdminNickRainbowApply(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    // Цвет может быть выдан и не-админу через /setnickcolor, поэтому проверки админки здесь нет.

    if(GetPlayerData(playerid, P_ADMIN_NICK_RAINBOW))
        return 1; // цвет далее обновляет общий таймер AdminNickRainbowTick

    new color = GetPlayerData(playerid, P_ADMIN_NICK_COLOR);
    if(color != 0)
        SetPlayerColorEx(playerid, color);

    return 1;
}

forward AdminNickRainbowTick();
public AdminNickRainbowTick()
{
    static rainbow_deg;
    rainbow_deg = (rainbow_deg + 4) % 360;

    new color = GetAdminRainbowColor(rainbow_deg);

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(IsPlayerConnected(i) && GetPlayerData(i, P_ADMIN_NICK_RAINBOW))
        {
            // 0x00000000 = игрок скрыт (маска, /dis) - не перебиваем невидимость
            if(GetPlayerData(i, P_COLOR) == 0) continue;

            // SetPlayerColorEx обновляет и P_COLOR: именно его берёт чат (ChatMessageInit) для цвета ника.
            // Раньше вызывался голый SetPlayerColor, поэтому в чате ник оставался прежнего цвета.
            SetPlayerColorEx(i, color);
        }
    }
    return 1;
}

stock ShowAdminNickColorMenu(playerid)
{
    new fmt_str[400];
    format(fmt_str, sizeof fmt_str,
        "{FF2020}Красный\n"\
        "{20FF20}Зелёный\n"\
        "{2060FF}Синий\n"\
        "{FFFF20}Жёлтый\n"\
        "{FFFFFF}Белый\n"\
        "{20FFFF}Голубой\n"\
        "{FF20C0}Розовый\n"\
        "{FF9900}Оранжевый\n"\
        "{FFFFFF}RGB (переливающийся)\n"\
        "{999999}Сбросить цвет (по умолчанию)"
    );
    ShowPlayerDialog(playerid, DIALOG_ADMIN_NICK_COLOR, DIALOG_STYLE_LIST, "{FFFFFF}Цвет ника администратора", fmt_str, "Выбрать", "Закрыть");
    return 1;
}

// CMD:nickcolor и CMD:setnickcolor теперь в systems/admin_nick_color.pwn (без аргументов /nickcolor открывает это же меню).

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_ADMIN_NICK_COLOR)
    {
        if(!response) return 1;
        if(GetPlayerAdminEx(playerid) <= 0 || !GetPlayerData(playerid, P_ADMIN_LOGGED)) return 1;

        if(listitem >= 0 && listitem < sizeof g_admin_nick_colors)
        {
            SetPlayerData(playerid, P_ADMIN_NICK_RAINBOW, 0);
            SetPlayerData(playerid, P_ADMIN_NICK_COLOR, g_admin_nick_colors[listitem]);
            SetPlayerColorEx(playerid, g_admin_nick_colors[listitem]);
            SendClientMessage(playerid, 0x66CC00FF, "Цвет ника изменён.");
        }
        else if(listitem == sizeof g_admin_nick_colors)
        {
            SetPlayerData(playerid, P_ADMIN_NICK_RAINBOW, 1);
            SendClientMessage(playerid, 0x66CC00FF, "Включен переливающийся RGB ник.");
        }
        else
        {
            SetPlayerData(playerid, P_ADMIN_NICK_RAINBOW, 0);
            SetPlayerData(playerid, P_ADMIN_NICK_COLOR, 0);
            SetPlayerColorInit(playerid);
            SendClientMessage(playerid, 0x66CC00FF, "Цвет ника сброшен.");
        }
        UpdatePlayerDatabaseInt(playerid, "nick_color", GetPlayerData(playerid, P_ADMIN_NICK_COLOR));
        UpdatePlayerDatabaseInt(playerid, "nick_rainbow", GetPlayerData(playerid, P_ADMIN_NICK_RAINBOW));
        return 1;
    }
    #if defined adminnick_OnDialogResponse
        return adminnick_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse adminnick_OnDialogResponse
#if defined adminnick_OnDialogResponse
    forward adminnick_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif
stock FixKick(playerid, const message[] = "Введите /q (/quit) чтобы выйти", time_ms = 0)
{
	if(strlen(message) > 1)
		SendClientMessage(playerid, 0xFF6600FF, message);

	SetTimerEx("FixedKick", time_ms, false, "i", playerid);
	return 1;
}

stock ClearPlayerInfo(playerid)
{
	BRAuth_Reset(playerid);
	g_player[playerid] = g_player_default_values;
	g_player_gps[playerid] = g_gps_default_values;
	g_player_setting[playerid] = g_settings_default_values;
	g_player_driving_exam[playerid] = g_driving_exam_default_values;

	g_pickup_flood[playerid] = 0;
	g_speed_line_update[playerid] = -1;
//	g_teleport_object[playerid] = {-1, -1};

	price_select_TD[playerid] = PlayerText: {-1};

	SetPlayerPhoneBookInitStatus(playerid, false);
	SetPlayerPhoneBookContacts(playerid, 0);

	ClearPlayerOffer(playerid);
	ClearPlayerListitemValues(playerid);
	ClearPlayerPhoneCall(playerid);

	AntiFloodPlayerInit(playerid);
	// ClearBankAccountsData(playerid);

//	DestroyTeleportObjects(playerid);

	StopSpectateGUIRefresh(playerid);
	DeletePVar(playerid, "sp_gui_ignore_close_until");
	SetPlayerSpectateData(playerid, S_PLAYER, -1);

	#if defined _SYSTEM_CP
	ClearPlayerCPInfo(playerid);
	#endif

	#if defined _SYSTEM_RACE_CP
	ClearPlayerRCPInfo(playerid);
	#endif

	SetPlayerPinCodeState(playerid, PIN_CODE_STATE_NONE);

	mysql_race[playerid] ++;
}

stock CreatePlayerAccount(playerid)
{
    return BRAuth_InsertAccount(playerid);
}

