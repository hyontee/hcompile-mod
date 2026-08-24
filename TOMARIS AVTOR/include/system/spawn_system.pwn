// ==============================================
//              SPAWN SYSTEM (GUI 50)
// ==============================================

// ============ ПЕРЕМЕННЫЕ ============
new PlayerSpawnChosen[MAX_PLAYERS];
new PlayerSpawnLocation[MAX_PLAYERS];

// ============ ФОРВАРД ============
forward ShowSpawnGUI(playerid);
public ShowSpawnGUI(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(PlayerSpawnChosen[playerid] == 1) return 1;
    
    ShowPlayerGUI(playerid, 50, JSON_Object());
    return 1;
}

// ============ ФУНКЦИЯ ИНИЦИАЛИЗАЦИИ ============
stock InitSpawnSystem()
{
    print("[SpawnSystem] Система спавна загружена!");
    return 1;
}