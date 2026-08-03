#include <a_samp>

new FreezeTimer;

forward AntiFreezeCheck();

public OnFilterScriptInit()
{
    FreezeTimer = SetTimer("AntiFreezeCheck", 2000, true);
    print("[AntiFreeze] Загружен.");
    return 1;
}

public OnFilterScriptExit()
{
    KillTimer(FreezeTimer);
    return 1;
}

public AntiFreezeCheck()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;

        // Если игрок зафризился — снимаем
        TogglePlayerControllable(i, true);
    }
    return 1;
}
