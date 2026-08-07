#define GROM_ACTOR_ID 5500061
#define DIALOG_EVENT_GROM  1376

public OnPlayerSpawn(playerid)
{
   
  #if defined grom_OnPlayerSpawn
        return grom_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn grom_OnPlayerSpawn
#if defined grom_OnPlayerSpawn
    forward grom_OnPlayerSpawn(playerid);
#endif

public OnGameModeInit()
{   
     CreateGActors();   
    CreateFoodTruck();
    #if defined grom_OnGameModeInit
        return grom_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit grom_OnGameModeInit
#if defined grom_OnGameModeInit
    forward grom_OnGameModeInit();
#endif

stock ShowStartGQuest(playerid)
{
    new string[512];
    
        format(string, sizeof(string),
        "{FFFFFF}Привет, {FFFF00}%s{FFFFFF},\n\
        тебя ждет новое событие - {FFFF00}Гром{FFFFFF}.\n\
        {FFFF00}Тебе доступно:\n\
        - Мини игра: {FFFFFF}''Преступная Погоня''.\n\
        {FFFF00}- Кейс События: {FFFFFF}Гром.\n\
        {ffff00}| {ffffff}Нажми {ffff00}''К Заданиям'', {ffffff}чтобы запустить прохождение сюжетного задания.",
        GetPlayerNameEx(playerid)
    );
    
    ShowPlayerDialog(playerid, DIALOG_EVENT_GROM, DIALOG_STYLE_MSGBOX, "{FF6347}Событие{ffffff} | Гром", string, "К Заданиям", "Закрыть");
    return 1;
}

stock CreateFoodTruck()
{
    new foodtruck[6];
    
    foodtruck[0] = CreateObject(33700, 2740.332031, -2420.396484, 20.77127, 0.0, 0.0, 0.0); // южный 
    foodtruck[1] = CreateObject(33700, -2440.33447, 199.63631, 25.09461, 0.0, 0.0, 0.0);
    foodtruck[2] = CreateObject(33700, 1770.197753, 2519.578857, 14.298284, 0.0, 0.0, 0.0); // батырево 
    foodtruck[3] = CreateObject(33700, 837.32611, 810.28900, 12.14947, 0.0, 0.0, 0.0);
    foodtruck[4] = CreateObject(33700, -2168.99194, 1569.55603, 8.83214, 0.0, 0.0, 0.0); 
    foodtruck[5] = CreateObject(33700, -2683.143066, 1981.281127, 3.476892, 0.0, 0.0, 0.0); // нижегородск
    
    return 1;
}

stock CreateGActors()
{
   new GROM_ACTOR;
   GROM_ACTOR = CreateActor(GROM_ACTOR_ID, 827.973327,788.347839,13.142774,276.134521);
   ApplyActorAnimation(GROM_ACTOR, "CAMERA", "camstnd_cmon", 4.0, 1, 1, 1, 1, 0);
   
   Create3DTextLabel("Событие {ffff00}Гром\n{ffffff}Подойди для {ffff00}взаимодействия", -1, 827.973327,788.347839,13.142774, 15.0, 0);
   return 1;
}