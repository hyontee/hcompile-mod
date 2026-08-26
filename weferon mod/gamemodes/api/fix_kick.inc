/*
    by: Werton
*/

stock Kick_fix(playerid)
{
    /*SendClientMessage(playerid, 0xFF5533FF, "Вас отключили от сервера, можете выйти");
    SendClientMessage(playerid, 0x999999FF, "Вы были отключены от сервера.");
    SendClientMessage(playerid, 0x999999FF, "Вы были отключены от голосового чата.");
    SetTimerEx("OnPlayerKicked", 2000, false, "i", playerid);*/
    for(new hide_wer; hide_wer < 45; hide_wer ++) HidePlayerGUI(playerid, hide_wer);
    Kick(playerid);
    return 1;
}

forward OnPlayerKicked(playerid);
public OnPlayerKicked(playerid)
{
    for(new hide_wer; hide_wer < 45; hide_wer ++) HidePlayerGUI(playerid, hide_wer);
    Kick(playerid);
}