#if defined _ANTICHEAT_INCLUDED
    #endinput
#endif
#define _ANTICHEAT_INCLUDED

#define MAX_KILLS_TIME 4
#define KILL_TIME_WINDOW 20
#define DIALOG_ACLOG 2000

new playerKills[MAX_PLAYERS];
new playerFirstKillTime[MAX_PLAYERS];
new PlayerText:AC_Text[MAX_PLAYERS];

stock AC_ResetPlayer(playerid)
{
    playerKills[playerid] = 0;
    playerFirstKillTime[playerid] = 0;
}

stock AC_CreateTextDraw(playerid)
{
    AC_Text[playerid] = CreatePlayerTextDraw(playerid, 500.0, 150.0, "_");
    PlayerTextDrawFont(playerid, AC_Text[playerid], 1);
    PlayerTextDrawLetterSize(playerid, AC_Text[playerid], 0.25, 1.0);
    PlayerTextDrawColor(playerid, AC_Text[playerid], 0xFFFFFFFF);
    PlayerTextDrawSetOutline(playerid, AC_Text[playerid], 1);
    PlayerTextDrawSetProportional(playerid, AC_Text[playerid], 1);
}

stock AC_AddLog(playerid, const reason[])
{
    new name[MAX_PLAYER_NAME], esc_name[64], query[256];
    GetPlayerName(playerid, name, sizeof(name));
    mysql_real_escape_string(name, esc_name);

    format(query, sizeof(query),
        "INSERT INTO AntiCheat_Log (name, date, reason) VALUES ('%s', NOW(), '%s')",
        esc_name, reason);

    mysql_tquery(dbHandle, query);
}

stock AC_SendAdminNotify(playerid)
{
    new name[MAX_PLAYER_NAME], string[144];
    GetPlayerName(playerid, name, sizeof(name));

    format(string, sizeof(string),
    "~w~%s~n~~w~был кикнут из-за~n~Подозрение ПО", name);

    foreach(new i : Player)
    {
        if(IsPlayerConnected(i) && IsPlayerAdminEx(i))
        {
            PlayerTextDrawSetString(i, AC_Text[i], string);
            PlayerTextDrawShow(i, AC_Text[i]);
            SetTimerEx("AC_HideText", 5000, false, "d", i);
        }
    }
}

forward AC_HideText(playerid);
public AC_HideText(playerid)
{
    PlayerTextDrawHide(playerid, AC_Text[playerid]);
    return 1;
}

stock AC_Punish(playerid)
{
    ShowPlayerDialog(playerid, 1337, DIALOG_STYLE_MSGBOX,
    "Anti-Cheat",
    "Вы были кикнуты в подозрении\nПостороннего ПО",
    "Ок", "");

    AC_SendAdminNotify(playerid);
    AC_AddLog(playerid, "Подозрение ПО (Mass Kill)");

    SetTimerEx("AC_KickPlayer", 2000, false, "d", playerid);
}

forward AC_KickPlayer(playerid);
public AC_KickPlayer(playerid)
{
    Kick(playerid);
    return 1;
}

stock AC_OnPlayerKill(playerid)
{
    new currentTime = gettime();

    if(playerFirstKillTime[playerid] == 0)
    {
        playerFirstKillTime[playerid] = currentTime;
        playerKills[playerid] = 1;
        return 1;
    }

    if(currentTime - playerFirstKillTime[playerid] <= KILL_TIME_WINDOW)
    {
        playerKills[playerid]++;
    }
    else
    {
        playerFirstKillTime[playerid] = currentTime;
        playerKills[playerid] = 1;
    }

    if(playerKills[playerid] >= MAX_KILLS_TIME)
    {
        AC_Punish(playerid);
    }

    return 1;
}

CMD:aclog(playerid)
{
    if(!IsPlayerAdminEx(playerid))
        return SendClientMessage(playerid, -1, "Вы не админ");

    mysql_tquery(dbHandle,
    "SELECT name, date, reason FROM AntiCheat_Log ORDER BY id DESC LIMIT 20",
    "AC_LoadLogs", "d", playerid);

    return 1;
}

forward AC_LoadLogs(playerid);
public AC_LoadLogs(playerid)
{
    new rows;
    cache_get_row_count(rows);

    if(!rows)
    {
        ShowPlayerDialog(playerid, DIALOG_ACLOG, DIALOG_STYLE_MSGBOX,
        "AC Logs", "Логи отсутствуют", "Ок", "");
        return 1;
    }

    new string[1024], name[24], date[32], reason[64];

    for(new i = 0; i < rows; i++)
    {
        cache_get_field_content(i, "name", name);
        cache_get_field_content(i, "date", date);
        cache_get_field_content(i, "reason", reason);

        format(string, sizeof(string),
        "%s[%s] %s\n%s\n\n",
        string, date, name, reason);
    }

    ShowPlayerDialog(playerid, DIALOG_ACLOG, DIALOG_STYLE_LIST,
    "AntiCheat Logs", string, "Закрыть", "");

    return 1;
}