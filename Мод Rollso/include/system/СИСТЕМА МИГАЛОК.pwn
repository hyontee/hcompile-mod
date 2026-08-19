// -- АВТОР СЛИВА BO SINN STUDIO - https://t.me/+dcHO8WNL0X42M2Ji

StartMigalkaSiren(playerid)
{
    PlayerPlaySound(playerid, MIGALKA_SIREN_SOUND, 0.0, 0.0, 0.0);
    ShowClientNotification(playerid, 2, 10, 1, 1, "Мигалки ВКЛЮЧЕНЫ", ""); // Зеленый нотиф
}

StopMigalkaSiren(playerid)
{
    PlayerPlaySound(playerid, MIGALKA_SIREN_SOUND, 0.0, 0.0, 0.0);
    ShowClientNotification(playerid, 1, 10, 1, 1, "Мигалки ВЫКЛЮЧЕНЫ", ""); // Красный нотиф
}

CMD:migalkafronz(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
    {
        ShowClientNotification(playerid, 1, 10, 1, 1, "Садись в транспорт!", "");
        return 1;
    }

    PlayerHasMigalka[playerid] = !PlayerHasMigalka[playerid];

    if(PlayerHasMigalka[playerid])
    {
        CreateMigalkaForPlayer(playerid);
        StartMigalkaSiren(playerid);
        PlayerMigalkaTimer[playerid] = SetTimerEx("UpdateMigalka", MIGALKA_UPDATE_MS, true, "i", playerid);
    }
    else
    {
        StopMigalkaSiren(playerid);
        DestroyMigalka(playerid);
        KillTimer(PlayerMigalkaTimer[playerid]);
    }
    return 1;
}