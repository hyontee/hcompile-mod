#if defined _a_bot_included
    #endinput
#endif
#define _a_bot_included

#include <a_samp>

#define MAX_BOTS 10
#define BOT_UPDATE_TIME 5000

new BotNames[MAX_BOTS][MAX_PLAYER_NAME] =
{
    "Andre_Mik",
    "Make_Mik",
    "Roma_Mik",
    "Sanya_Mik",
    "Kirill_Mik",
    "Artem_Mik",
    "Nikita_Mik",
    "Vlad_Mik",
    "Egor_Mik",
    "Denis_Mik"
};

new BotSkins[MAX_BOTS] =
{
    105,
    102,
    98,
    292,
    170,
    73,
    19,
    44,
    15,
    250
};

new Float:BotSpawn[MAX_BOTS][3] =
{
    {1550.0, -1675.0, 16.0},
    {1552.0, -1672.0, 16.0},
    {1548.0, -1670.0, 16.0},
    {1544.0, -1668.0, 16.0},
    {1557.0, -1665.0, 16.0},
    {1560.0, -1662.0, 16.0},
    {1541.0, -1679.0, 16.0},
    {1539.0, -1674.0, 16.0},
    {1555.0, -1681.0, 16.0},
    {1563.0, -1669.0, 16.0}
};

forward Bot_Update();

public OnGameModeInit()
{
    print("=================================");
    print("        A_BOT LOADED");
    print("          VERSION 1.0");
    print("          BY RESPESHKA");
    print("=================================");

    for(new i; i < MAX_BOTS; i++)
    {
        ConnectNPC(BotNames[i], "blankbot");
    }

    SetTimer("Bot_Update", BOT_UPDATE_TIME, true);

    #if defined bot_OnGameModeInit
        bot_OnGameModeInit();
    #endif

    return 1;
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit bot_OnGameModeInit

#if defined bot_OnGameModeInit
    forward bot_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    if(IsPlayerNPC(playerid))
    {
        new name[MAX_PLAYER_NAME];

        GetPlayerName(playerid, name, sizeof(name));

        for(new i; i < MAX_BOTS; i++)
        {
            if(!strcmp(name, BotNames[i], true))
            {
                SetSpawnInfo
                (
                    playerid,
                    0,
                    BotSkins[i],
                    BotSpawn[i][0],
                    BotSpawn[i][1],
                    BotSpawn[i][2],
                    0.0,
                    0,0,0,0,0,0
                );

                SpawnPlayer(playerid);

                SetPlayerSkin(playerid, BotSkins[i]);

                break;
            }
        }
    }

    #if defined bot_OnPlayerConnect
        bot_OnPlayerConnect(playerid);
    #endif

    return 1;
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect bot_OnPlayerConnect

#if defined bot_OnPlayerConnect
    forward bot_OnPlayerConnect(playerid);
#endif

public Bot_Update()
{
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i))
            continue;

        if(!IsPlayerNPC(i))
            continue;

        new Float:x;
        new Float:y;
        new Float:z;

        GetPlayerPos(i, x, y, z);

        x += float(random(8) - 4);
        y += float(random(8) - 4);

        SetPlayerPos(i, x, y, z);

        ApplyAnimation(i, "PED", "WALK_player", 4.1, 1, 1, 1, 1, 0);
    }

    return 1;
}