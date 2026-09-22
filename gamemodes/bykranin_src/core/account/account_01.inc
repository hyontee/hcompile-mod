//>> Файл: bykranin_src/core/account/account_01.inc  (60 строк)
//>> Тема: аккаунт: вход, регистрация, пин-код, спавн
//>> Внутри: CheckPlayerAccount, FixedKick
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: CheckPlayerAccount(playerid, race)
{
    if(!IsPlayerConnected(playerid) || race != mysql_race[playerid] || g_BRAuthStage[playerid] != BR_AUTH_CHECK) return 0;
    printf("[AUTH][CHECK] player=%d session=%d", playerid, race);
    if(!strcmp(GetPlayerNameEx(playerid), "Nick_Name"))
    {
        g_BRAuthStage[playerid] = BR_AUTH_BLOCKED;
        ShowNotificationNew(playerid, 2, 8, -1, -1, "Укажите свой ник в настройках лаунчера.", "");
        return Kick:(playerid);
    }
    SetPlayerCameraPos(playerid, AUTH_CAMERA_POS);
    SetPlayerCameraLookAt(playerid, AUTH_CAMERA_LOOK);
    new query[160];
    mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE name='%e' LIMIT 1", GetPlayerNameEx(playerid));
    new Cache:result = mysql_query(mysql, query);
    if(mysql_errno(mysql))
    {
        if(result) cache_delete(result);
        g_BRAuthStage[playerid] = BR_AUTH_BLOCKED;
        BRAuth_Error(playerid, "CHECK", "Не удалось проверить аккаунт. Переподключитесь позже.");
        return Kick:(playerid);
    }
    new bool:exists = (cache_num_rows(result) != 0);
    SetPlayerData(playerid, P_AUTH_TIME, 0);
    SetPlayerData(playerid, P_PASS_ATTEMPS, 3);
    if(exists)
    {
        SetPlayerData(playerid, P_ACCOUNT_ID, cache_get_field_content_int(0, "id"));
        cache_get_field_content(0, "salt", g_player[playerid][P_SALT], mysql, 11);
        cache_get_field_content(0, "password", g_player[playerid][P_PASSWORD], mysql, 65);
        cache_get_field_content(0, "email", g_player[playerid][P_EMAIL], mysql, 61);
        cache_get_field_content(0, "last_ip", g_player[playerid][P_LAST_IP], mysql, 16);
        cache_get_field_content(0, "setting_phone", g_player[playerid][P_SETTING_PHONE], mysql, 13);
        cache_get_field_content(0, "setting_pin_code", g_player[playerid][P_SETTING_PIN], mysql, 5);
        SetPlayerData(playerid, P_REQUEST_PHONE, cache_get_field_content_int(0, "request_phone"));
        SetPlayerData(playerid, P_REQUEST_PIN, cache_get_field_content_int(0, "request_pin"));
        SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_LOGIN);
        g_BRAuthStage[playerid] = BR_AUTH_LOGIN;
    }
    else
    {
        SetPlayerData(playerid, P_ACCOUNT_ID, 0);
        SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REGISTER);
        g_BRAuthStage[playerid] = BR_AUTH_PASSWORD;
    }
    cache_delete(result);
    printf("[AUTH][CHECK_RESULT] player=%d account=%d exists=%d", playerid, GetPlayerAccountID(playerid), exists);
    BRAuth_Open(playerid, exists);
    #if defined _MAP_INCLUDED
    RemoveBuildings(playerid);
    #endif
    return 1;
}

public: FixedKick(playerid)
{
	Kick(playerid);
}

