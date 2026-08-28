#include <a_samp>

#define MAX_FISHING_SPOTS 10

new Float:FishingSpots[MAX_FISHING_SPOTS][3] = {
    { 1500.0, -1500.0, 13.0 },
    { 1520.0, -1490.0, 13.0 },
    { 1480.0, -1510.0, 13.0 },
    // Добавьте больше координат точек рыбалки
};

new FishCaught[MAX_PLAYERS];

public OnGameModeInit()
{
    // Инициализация рыболовных мест
    for (new i = 0; i < MAX_FISHING_SPOTS; i++)
    {
        CreateDynamicPickup(1274, 1, FishingSpots[i][0], FishingSpots[i][1], FishingSpots[i][2], -1);
    }
    print("Система рыбалки инициализирована.");
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    // Проверка, попал ли игрок в рыболовную точку
    for (new i = 0; i < MAX_FISHING_SPOTS; i++)
    {
        if (IsPlayerInRangeOfPoint(playerid, 2.0, FishingSpots[i][0], FishingSpots[i][1], FishingSpots[i][2]))
        {
            StartFishing(playerid);
            return 1;
        }
    }
    return 1;
}

stock StartFishing(playerid)
{
    SendClientMessage(playerid, COLOR_YELLOW, "Вы начали рыбалку. Пожалуйста, подождите...");
    SetTimerEx("FinishFishing", 5000, false, "i", playerid); // Таймер на 5 секунд для завершения рыбалки
}

public FinishFishing(playerid)
{
    if (!IsPlayerConnected(playerid)) return;
    new fishType = GetRandomFish();
    FishCaught[playerid]++;
    new message[64];
    format(message, sizeof(message), "Вы поймали %s! Общее количество пойманной рыбы: %d", fishType, FishCaught[playerid]);
    SendClientMessage(playerid, COLOR_GREEN, message);
}

stock GetRandomFish()
{
    new rand = random(5);
    switch (rand)
    {
        case 0: return "окунь";
        case 1: return "форель";
        case 2: return "щука";
        case 3: return "карп";
        case 4: return "сом";
    }
    return "неизвестная рыба";
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    if (strcmp("/stats", cmdtext, true, 6) == 0)
    {
        new message[64];
        format(message, sizeof(message), "Вы поймали %d рыб(ы).", FishCaught[playerid]);
        SendClientMessage(playerid, COLOR_YELLOW, message);
        return 1;
    }
    return 0;
}