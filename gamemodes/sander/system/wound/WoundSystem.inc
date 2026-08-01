#if defined _SANDER_WOUND_SYSTEM_INC
    #endinput
#endif
#define _SANDER_WOUND_SYSTEM_INC

#define WOUND_GUI_ID                    (40)
#define WOUND_AUTO_RESPAWN_SECONDS      (60)
#define WOUND_WAIT_SECONDS              (30)

new const Float:g_wound_hospital_pos[][] =
{
    {1802.542968, 2517.302490, 14.498353, 128.900222},      // Арзамасская больница
    {-2430.725341, 204.739364, 26.095102, 171.770828},      // Лыткаринская больница
    {844.824829, 794.637268, 13.381684, 69.833580}          // Нижегородская больница
};

new const g_wound_hospital_int[] = {0, 0, 0};
new const g_wound_hospital_vw[] = {0, 0, 0};

new const g_wound_hospital_name[][] =
{
    "Арзамасская больница",
    "Лыткаринская больница",
    "Нижегородская больница"
};

forward Wound_ShowDelayed(playerid);
forward Wound_AutoRespawn(playerid);

stock Wound_SetSpawnInfo(playerid)
{
    new hospital_index = random(sizeof(g_wound_hospital_pos));

    SetSpawnInfo
    (
        playerid,
        0,
        GetPlayerSkinEx(playerid),
        g_wound_hospital_pos[hospital_index][0],
        g_wound_hospital_pos[hospital_index][1],
        g_wound_hospital_pos[hospital_index][2],
        g_wound_hospital_pos[hospital_index][3],
        0, 0, 0, 0, 0, 0
    );
    return 1;
}

stock Wound_Start(playerid, killerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(!IsPlayerLogged(playerid)) return 0;

    SetPVarInt(playerid, "WoundActive", 1);
    SetPVarInt(playerid, "WoundHospital", 0);
    SetPVarInt(playerid, "WoundKiller", killerid);
    SetPVarInt(playerid, "WoundTimer", gettime() + WOUND_AUTO_RESPAWN_SECONDS);

    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    TogglePlayerControllable(playerid, false);

    SetTimerEx("Wound_ShowDelayed", 800, false, "i", playerid);
    SetTimerEx("Wound_AutoRespawn", WOUND_AUTO_RESPAWN_SECONDS * 1000, false, "i", playerid);
    return 1;
}

public Wound_ShowDelayed(playerid)
{
    return Wound_ShowGUI(playerid);
}

stock Wound_ShowGUI(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(GetPVarInt(playerid, "WoundActive") != 1) return 0;

    new remaining = GetPVarInt(playerid, "WoundTimer") - gettime();
    if(remaining < 0) remaining = 0;

    TogglePlayerControllable(playerid, false);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);

    new Node:json = JSON_Object();
    JSON_SetInt(json, "id", GetPlayerAccountID(playerid));
    JSON_SetString(json, "p", GetPlayerNameEx(playerid));
    JSON_SetInt(json, "h", 0);
    JSON_SetInt(json, "time", remaining);
    JSON_SetInt(json, "random", 1);
    JSON_SetInt(json, "count", 0);
    JSON_SetString(json, "info", "Вы можете отправиться в случайную больницу или подождать помощь");
    JSON_SetString(json, "btn_hospital", "Отправиться в больницу");
    JSON_SetString(json, "btn_wait", "Подождать");

    ShowPlayerGUI(playerid, WOUND_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

public Wound_AutoRespawn(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(GetPVarInt(playerid, "WoundActive") != 1) return 0;

    new timer = GetPVarInt(playerid, "WoundTimer");
    new remaining = timer - gettime();

    if(remaining > 0)
    {
        SetTimerEx("Wound_AutoRespawn", remaining * 1000, false, "i", playerid);
        return 1;
    }

    return Wound_RespawnToHospital(playerid, 0); // 0 - Арзамас
}

public WoundSystem_OnPacket(playerid, Node:json)
{
    if(json == Node:0) return 1;
    if(!IsPlayerConnected(playerid)) return 1;

    new action_type;
    JSON_GetInt(json, "t", action_type);

    printf("[WOUND] Player %d, action: %d", playerid, action_type);

    switch(action_type)
    {
        case 1:
        {
            // Подождать помощь: игрок остаётся в состоянии ранения, больница не выбирается.
            return Wound_Wait(playerid);
        }
        case 2, 4:
        {
            // Отправиться в больницу: больница выбирается случайно из списка.
            return Wound_RespawnToRandomHospital(playerid);
        }
        case 3:
        {
            // Зарезервировано под будущие действия GUI. Сейчас просто обновляем окно.
            return Wound_ShowGUI(playerid);
        }
    }

    // Если GUI прислал неизвестное действие или закрытие окна — игрок остаётся ждать.
    return 1;
}

stock Wound_Wait(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(GetPVarInt(playerid, "WoundActive") != 1) return 0;

    SetPVarInt(playerid, "WoundTimer", gettime() + WOUND_WAIT_SECONDS);
    TogglePlayerControllable(playerid, false);
    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);

    SendClientMessage(playerid, 0xDAA520FF, "Вы решили подождать помощь. Если помощь не придёт, вас отправит в случайную больницу.");
    SetTimerEx("Wound_ShowDelayed", 500, false, "i", playerid);
    SetTimerEx("Wound_AutoRespawn", WOUND_WAIT_SECONDS * 1000, false, "i", playerid);
    return 1;
}

stock Wound_RespawnToRandomHospital(playerid)
{
    new hospital_index = random(sizeof(g_wound_hospital_pos));
    return Wound_RespawnToHospital(playerid, hospital_index);
}

stock Wound_RespawnToHospital(playerid, hospital_index)
{
    if(!IsPlayerConnected(playerid)) return 0;
    if(hospital_index < 0 || hospital_index >= sizeof(g_wound_hospital_pos)) hospital_index = random(sizeof(g_wound_hospital_pos));

    Wound_HideGUI(playerid);

    SetPVarInt(playerid, "WoundActive", 0);
    SetPVarInt(playerid, "WoundHospital", 1);
    SetPlayerData(playerid, P_HOSPITAL, true);
    SetPlayerData(playerid, P_HEALTH, 100.0);
    UpdatePlayerDatabaseInt(playerid, "hospital", 1);

    SetPlayerInterior(playerid, g_wound_hospital_int[hospital_index]);
    SetPlayerVirtualWorld(playerid, g_wound_hospital_vw[hospital_index]);
    SetPlayerPosEx
    (
        playerid,
        g_wound_hospital_pos[hospital_index][0],
        g_wound_hospital_pos[hospital_index][1],
        g_wound_hospital_pos[hospital_index][2],
        g_wound_hospital_pos[hospital_index][3],
        g_wound_hospital_int[hospital_index],
        g_wound_hospital_vw[hospital_index]
    );

    SetSpawnInfo
    (
        playerid,
        0,
        GetPlayerSkinEx(playerid),
        g_wound_hospital_pos[hospital_index][0],
        g_wound_hospital_pos[hospital_index][1],
        g_wound_hospital_pos[hospital_index][2],
        g_wound_hospital_pos[hospital_index][3],
        0, 0, 0, 0, 0, 0
    );

    SetPlayerHealth(playerid, 100.0);
    SetPlayerArmour(playerid, 0.0);
    TogglePlayerControllable(playerid, true);
    SetCameraBehindPlayer(playerid);
    ClearAnimations(playerid);

    new msg[144];
    format(msg, sizeof msg, "Вы были доставлены в больницу: %s", g_wound_hospital_name[hospital_index]);
    SendClientMessage(playerid, 0xDAA520FF, msg);
    return 1;
}

stock Wound_HideGUI(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "c", 1);
    SendPacketToClient(playerid, WOUND_GUI_ID, json);
    JSON_Cleanup(json);
    return 1;
}

CMD:wound(playerid, params[])
{
    Wound_Start(playerid, INVALID_PLAYER_ID);
    return 1;
}
