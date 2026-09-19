#include <a_samp>

public OnFilterScriptInit()
{
    print("======================================");
    print("  LORDEBET SYSTEM LOADED!");
    print("  Author: @FuckLordovs");
    print("  TG: https://t.me/bioxlagnokrovnogo");
    print("======================================");
    return 1;
}

public OnFilterScriptExit()
{
    return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if(strcmp(cmdtext, "/lordebet", true) == 0)
    {
        SendClientMessage(playerid, 0xFFFF00FF, "╔══════════════════════════════════════╗");
        SendClientMessage(playerid, 0xFFFF00FF, "║     ★ LORDEBET SYSTEM ★            ║");
        SendClientMessage(playerid, 0xFFFF00FF, "╠══════════════════════════════════════╣");
        SendClientMessage(playerid, 0x00FF00FF, "║  Сделай ставку и выиграй!           ║");
        SendClientMessage(playerid, 0xFFFF00FF, "╚══════════════════════════════════════╝");
        SendClientMessage(playerid, 0x808080FF, "Автор: @FuckLordovs");
        SendClientMessage(playerid, 0x808080FF, "Подпишись: https://t.me/bioxlagnokrovnogo");
        return 1;
    }
    return 0;
}