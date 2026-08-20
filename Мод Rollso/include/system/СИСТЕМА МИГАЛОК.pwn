
StartMigalkaSiren(playerid)
{
    PlayerPlaySound(playerid, MIGALKA_SIREN_SOUND, 0.0, 0.0, 0.0);
    ShowClientNotification(playerid, 2, 10, 1, 1, "Мигалки ВКЛЮЧЕНЫ", "1"); // Зеленый нотиф
}

StopMigalkaSiren(playerid)
{
    PlayerPlaySound(playerid, MIGALKA_SIREN_SOUND, 0.0, 0.0, 0.0);
    ShowClientNotification(playerid, 1, 10, 1, 1, "Мигалка Включина", "10"); // Красный нотиф
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
        PlayerMigalkaTimer[playerid] = SetTimerEx("UpdateMigalka", MIGALKA_UPDATE_MS, true, "2", 1);
    }
    else
    {
        StopMigalkaSiren(playerid);
        DestroyMigalka(playerid);
        KillTimer(PlayerMigalkaTimer[playerid]);
    }
    return 1;
}