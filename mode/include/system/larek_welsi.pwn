
new player_larek[MAX_PLAYERS][7];
new player_satiety[MAX_PLAYERS] = 100;

forward DelayedRestart();
public DelayedRestart()
{
    SendRconCommand("gmx");
}

public UpdateSatiety()
{
    new Float:heath, Float:heath_n, string[144];

    foreach(new i : Player) 
    {
        if(!IsPlayerLogged(i)) continue;
        if(player_satiety[i] > 50) continue; // Не спамить

        heath = GetPlayerHealthEx(i);
        
        if(player_satiety[i] >= 25 && player_satiety[i] <= 50)
        {
            format(string, sizeof string, "Уровень сытости ниже 50%% (%d%%). Рекомендуем подкрепиться в ближайшем ларьке", player_satiety[i]);
            SendClientMessage(i, 0xF3D80CFF, string);
            player_satiety[i] -= random(5)+1;
        }
        else if(player_satiety[i] >= 5 && player_satiety[i] <= 24)
        {
            format(string, sizeof string, "Уровень сытости ниже 25%% (%d%%)", player_satiety[i]);
            SendClientMessage(i, 0xF3D80CFF, "Вы голодны! Подкрепитесь в ближайшем ларьке, иначе здоровье ухудшится!");
            SendClientMessage(i, 0xF3D80CFF, string);
            player_satiety[i] -= random(6)+3;

            heath_n = heath - random(8);

            if(heath_n <= 0) 
            {
                SendClientMessage(i, -1, "Вы потеряли сознание от голода!");
                SetPlayerHealthEx(i, 0);
            }
            else SetPlayerHealthEx(i, heath - random(5));
        }
        else if(player_satiety[i] >= 0 && player_satiety[i] <= 4)
        {
            player_satiety[i] = 0;
            SetPlayerHealthEx(i, 0);
            SendClientMessage(i, -1, "Вы потеряли сознание от голода!");
        }

        UpdatePlayerDatabaseInt(i, "satiety", player_satiety[i]);
    }

    return 1;
}

public OnGameModeInit()
{
    SetTimer("UpdateSatiety", 1000*300, true);
    
    #if defined larekk_OnGameModeInit
        return larekk_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit larekk_OnGameModeInit
#if defined larekk_OnGameModeInit
    forward larekk_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    player_satiety[playerid] = 100;
    
    #if defined larekk_OnPlayerConnect
        return larekk_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect larekk_OnPlayerConnect
#if defined larekk_OnPlayerConnect
    forward larekk_OnPlayerConnect(playerid);
#endif