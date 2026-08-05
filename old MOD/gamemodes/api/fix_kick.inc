/*
    by: Werton
*/

stock Kick_fix(playerid)
{
    SendClientMessage(playerid, 0xFF5533FF, "Вас отключили от сервера, можете выйти");
    SendClientMessage(playerid, 0x999999FF, "Вы были отключены от сервера.");
    SendClientMessage(playerid, 0x999999FF, "Вы были отключены от голосового чата.");
    return SetTimerEx("OnPlayerKicked", 2000, false, "i", playerid);
}

forward OnPlayerKicked(playerid);
public OnPlayerKicked(playerid) return Kick(playerid);