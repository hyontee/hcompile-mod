#include <a_samp>
#include <a_mysql>
#include <sscanf2>
#include "family_wars.inc"

main()
{
    print("\n----------------------------------");
    print(" Show1y Mod Pwn 2.0 + Family Wars");
    print("----------------------------------\n");
}

public OnGameModeInit()
{
    SetGameModeText("Show1y Mod Pwn 2.0");
    AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);

    // ВАЖНО: g_SQL должен быть подключён вашим кодом до FW_Init().
    // Пример: g_SQL = mysql_connect(host, user, password, database);
    FW_Init();
    return 1;
}

public OnGameModeExit()
{
    return 1;
}

public OnPlayerConnect(playerid)
{
    FW_InitPlayer(playerid);
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    #pragma unused reason
    FW_OnPlayerDisconnect(playerid);
    return 1;
}

public OnPlayerSpawn(playerid)
{
    if(FWPlayer[playerid][fwInWar])
        FW_OnPlayerSpawn(playerid);
    return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
    #pragma unused reason
    if(FW_OnPlayerDeath(playerid, killerid))
        return 1;
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    return FW_HandleCommand(playerid, cmdtext);
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(FW_OnDialogResponse(playerid, dialogid, response, listitem, inputtext))
        return 1;
    return 0;
}
