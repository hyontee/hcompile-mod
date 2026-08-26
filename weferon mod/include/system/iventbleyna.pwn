// ивентик для привата))
// by waktes t.me//waktesstud


#include <a_samp>

#define COLOR_SPRING_GREEN 0x66FF66AA
#define FLORAL_PICKUP_MODEL 1271
#define EVENT_DURATION 3600
#define EVENT_BONUS_TIME 1800
#define MAX_FLOWER_LOCATIONS 10
#define QUEST_COUNT 3
#define QUEST_OBJECT_MODEL 19370
#define QUEST_DELIVERY_LOCATION {1000.0, 1000.0, 10.0}

#define VAKTES_MODEL 280
#define VAKTES_INTERACTION_DISTANCE 5.0

enum E_PLAYER_DATA
{
    pFlowersCollected,
    bool:pBonusClaimed,
    pQuestStage[QUEST_COUNT],
    pQuestObject[QUEST_COUNT],
    pQuestLocation[QUEST_COUNT][3],
    pQuestDeliveryPickup[QUEST_COUNT],
    pQuestItemModel[QUEST_COUNT]
};
new PlayerData[MAX_PLAYERS][E_PLAYER_DATA];

enum E_VAKTES_DATA
{
  Float:vX,
  Float:vY,
  Float:vZ,
  Float:vAngle,
  vWorld,
  vInterior
};

new VaktesData[E_VAKTES_DATA] =
{
  1000.0,
  1000.0,
  3.0,
  0.0,
  0,
  0
};

new bool:g_bIsEventActive = false;
new g_iEventStartTime = 0;
new g_iFlowerLocations[MAX_FLOWER_LOCATIONS][3];
new g_iPickupIDs[MAX_FLOWER_LOCATIONS];
new g_iNumFlowerLocations = 0;
new g_iEventTimer;
new g_iVaktes;

stock AddFlowerLocation(Float:x, Float:y, Float:z)
{
    if (g_iNumFlowerLocations < MAX_FLOWER_LOCATIONS)
    {
        g_iFlowerLocations[g_iNumFlowerLocations][0] = floatround(x);
        g_iFlowerLocations[g_iNumFlowerLocations][1] = floatround(y);
        g_iFlowerLocations[g_iNumFlowerLocations][2] = floatround(z);
        g_iNumFlowerLocations++;
        return true;
    }
    return false;
}

stock StartSpringEvent()
{
    if (g_bIsEventActive) return print("Весенний ивент уже активен!"), 1;

    g_bIsEventActive = true;
    g_iEventStartTime = gettime();
    g_iEventTimer = SetTimer("CreateFlowerPickups", 900000, true);
    SendClientMessageToAll(COLOR_SPRING_GREEN, "[ИВЕНТ] Весенний ивент начался! Соберите цветы и выполните задания!");

    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        PlayerData[i][pFlowersCollected] = 0;
        PlayerData[i][pBonusClaimed] = false;
    }

    CreateFlowerPickups();
    return 1;
}

stock EndSpringEvent()
{
    if (!g_bIsEventActive) return print("Весенний ивент не активен!"), 1;

    g_bIsEventActive = false;
    KillTimer(g_iEventTimer);
    DestroyFlowerPickups();
    StopPlayerQuests();
    SendClientMessageToAll(COLOR_SPRING_GREEN, "[ИВЕНТ] Весенний ивент закончился!");
    return 1;
}

stock CreateFlowerPickups()
{
    DestroyFlowerPickups();
    for (new i = 0; i < g_iNumFlowerLocations; i++)
    {

        g_iPickupIDs[i] = CreatePickup(FLORAL_PICKUP_MODEL, 2, float(g_iFlowerLocations[i][0]), float(g_iFlowerLocations[i][1]), float(g_iFlowerLocations[i][2]), -1);
    }
    print("Пикапы цветов созданы!");
    return 1;
}

stock DestroyFlowerPickups()
{
    for (new i = 0; i < g_iNumFlowerLocations; i++)
    {
        if (IsValidPickup(g_iPickupIDs[i])) DestroyPickup(g_iPickupIDs[i]);
        g_iPickupIDs[i] = INVALID_PICKUP_ID;
    }
    return 1;
}

stock GetEventTimeRemaining()
{
    if (!g_bIsEventActive) return 0;
    new iTimeElapsed = gettime() - g_iEventStartTime;
    return EVENT_DURATION - iTimeElapsed;
}

CMD:startevent(playerid, params[])
{
    if (!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_RED, "У вас нет прав на эту команду.");
    StartSpringEvent();
    return 1;
}

CMD:endevent(playerid, params[])
{
    if (!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_RED, "У вас нет прав на эту команду.");
    EndSpringEvent();
    return 1;
}

CMD:eventinfo(playerid, params[])
{
    if (!g_bIsEventActive) return SendClientMessage(playerid, COLOR_WHITE, "Весенний ивент не активен."), 1;

    new iTimeRemaining = GetEventTimeRemaining();
    new iMinutes = iTimeRemaining / 60;
    new iSeconds = iTimeRemaining % 60;

    format(string, sizeof(string), "Весенний ивент активен! Осталось: %d минут %d секунд. Собрано цветов: %d.", iMinutes, iSeconds, PlayerData[playerid][pFlowersCollected]);
    SendClientMessage(playerid, COLOR_SPRING_GREEN, string);
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if (!g_bIsEventActive) return 0;

    for (new i = 0; i < g_iNumFlowerLocations; i++)
    {
        if (pickupid == g_iPickupIDs[i])
        {
            PlayerData[playerid][pFlowersCollected]++;
            format(string, sizeof(string), "[ИВЕНТ] Вы собрали цветок! Всего собрано: %d.", PlayerData[playerid][pFlowersCollected]);
            SendClientMessage(playerid, COLOR_SPRING_GREEN, string);

            DestroyPickup(pickupid);
            g_iPickupIDs[i] = CreatePickup(FLORAL_PICKUP_MODEL, 2, float(g_iFlowerLocations[i][0]), float(g_iFlowerLocations[i][1]), float(g_iFlowerLocations[i][2]), -1);

            if (PlayerData[playerid][pFlowersCollected] >= 20)
            {
                SendClientMessage(playerid, COLOR_SPRING_GREEN, "[ИВЕНТ] Поздравляем! Вы собрали много цветов. Держите награду!");
                GivePlayerMoney(playerid, 15000);
                GivePlayerWeapon(playerid, 24, 50);
                PlayerData[playerid][pFlowersCollected] = 0;
            }

            return 1;
        }
    }

    for(new quest = 0; quest < QUEST_COUNT; quest++)
    {
       if(pickupid == PlayerData[playerid][pQuestDeliveryPickup][quest])
       {
          if(PlayerData[playerid][pQuestStage][quest] == 1)
          {
            CompleteQuestStage(playerid,quest);
          }
       }
    }

    return 0;
}

public OnPlayerConnect(playerid)
{
    PlayerData[playerid][pFlowersCollected] = 0;
    PlayerData[playerid][pBonusClaimed] = false;
    InitializePlayerQuests(playerid);
    return 1;
}

forward CheckBonusTime();
public CheckBonusTime()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i) && !PlayerData[i][pBonusClaimed])
        {
           new playTime = GetPlayerPlayTime(i);
           if(playTime >= EVENT_BONUS_TIME)
           {
              SendClientMessage(i, COLOR_SPRING_GREEN, "[ИВЕНТ] Вы отыграли нужное время! Получите бонус.");
              GivePlayerMoney(i, 7500);
              PlayerData[i][pBonusClaimed] = true;
           }
        }
    }
    return 1;
}

stock GetPlayerPlayTime(playerid)
{
   return random(EVENT

        g_iPickupIDs[i] = CreatePickup(FLORAL_PICKUP_MODEL, 2, float(g_iFlowerLocations[i][0]), float(g_iFlowerLocations[i][1]), float(g_iFlowerLocations[i][2]), -1);
    }
    print("Пикапы цветов созданы!");
    return 1;
}

stock DestroyFlowerPickups()
{
    for (new i = 0; i < g_iNumFlowerLocations; i++)
    {
        if (IsValidPickup(g_iPickupIDs[i])) DestroyPickup(g_iPickupIDs[i]);
        g_iPickupIDs[i] = INVALID_PICKUP_ID;
    }
    return 1;
}

stock GetEventTimeRemaining()
{
    if (!g_bIsEventActive) return 0;
    new iTimeElapsed = gettime() - g_iEventStartTime;
    return EVENT_DURATION - iTimeElapsed;
}

CMD:startevent(playerid, params[])
{
    if (!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_RED, "У вас нет прав на эту команду.");
    StartSpringEvent();
    return 1;
}

CMD:endevent(playerid, params[])
{
    if (!IsPlayerAdmin(playerid)) return SendClientMessage(playerid, COLOR_RED, "У вас нет прав на эту команду.");
    EndSpringEvent();
    return 1;
}

CMD:eventinfo(playerid, params[])
{
    if (!g_bIsEventActive) return SendClientMessage(playerid, COLOR_WHITE, "Весенний ивент не активен."), 1;

    new iTimeRemaining = GetEventTimeRemaining();
    new iMinutes = iTimeRemaining / 60;
    new iSeconds = iTimeRemaining % 60;

    format(string, sizeof(string), "Весенний ивент активен! Осталось: %d минут %d секунд. Собрано цветов: %d.", iMinutes, iSeconds, PlayerData[playerid][pFlowersCollected]);
    SendClientMessage(playerid, COLOR_SPRING_GREEN, string);
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    if (!g_bIsEventActive) return 0;

    for (new i = 0; i < g_iNumFlowerLocations; i++)
    {
        if (pickupid == g_iPickupIDs[i])
        {
            PlayerData[playerid][pFlowersCollected]++;
            format(string, sizeof(string), "[ИВЕНТ] Вы собрали цветок! Всего собрано: %d.", PlayerData[playerid][pFlowersCollected]);
            SendClientMessage(playerid, COLOR_SPRING_GREEN, string);

            DestroyPickup(pickupid);
            g_iPickupIDs[i] = CreatePickup(FLORAL_PICKUP_MODEL, 2, float(g_iFlowerLocations[i][0]), float(g_iFlowerLocations[i][1]), float(g_iFlowerLocations[i][2]), -1);

            if (PlayerData[playerid][pFlowersCollected] >= 20)
            {
                SendClientMessage(playerid, COLOR_SPRING_GREEN, "[ИВЕНТ] Поздравляем! Вы собрали много цветов. Держите награду!");
                GivePlayerMoney(playerid, 15000);
                GivePlayerWeapon(playerid, 24, 50);
                PlayerData[playerid][pFlowersCollected] = 0;
            }

            return 1;
        }
    }

    for(new quest = 0; quest < QUEST_COUNT; quest++)
    {
       if(pickupid == PlayerData[playerid][pQuestDeliveryPickup][quest])
       {
          if(PlayerData[playerid][pQuestStage][quest] == 1)
          {
            CompleteQuestStage(playerid,quest);
          }
       }
    }

    return 0;
}

public OnPlayerConnect(playerid)
{
    PlayerData[playerid][pFlowersCollected] = 0;
    PlayerData[playerid][pBonusClaimed] = false;
    InitializePlayerQuests(playerid);
    return 1;
}

forward CheckBonusTime();
public CheckBonusTime()
{
    for (new i = 0; i < MAX_PLAYERS; i++)
    {
        if (IsPlayerConnected(i) && !PlayerData[i][pBonusClaimed])
        {
           new playTime = GetPlayerPlayTime(i);
           if(playTime >= EVENT_BONUS_TIME)
           {
              SendClientMessage(i, COLOR_SPRING_GREEN, "[ИВЕНТ] Вы отыграли нужное время! Получите бонус.");
              GivePlayerMoney(i, 7500);
              PlayerData[i][pBonusClaimed] = true;
           }
        }
    }
    return 1;
}

stock GetPlayerPlayTime(playerid)
{
   return random(EVENT_BONUS_TIM

E + 600);
}

stock InitializePlayerQuests(playerid)
{
    for (new quest = 0; quest < QUEST_COUNT; quest++) PlayerData[playerid][pQuestStage][quest] = 0;
    return 1;
}

stock StopPlayerQuests()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        for (new quest = 0; quest < QUEST_COUNT; quest++)
        {
          if(IsValidObject(PlayerData[i][pQuestObject][quest])) DestroyObject(PlayerData[i][pQuestObject][quest]);
          if(IsValidPickup(PlayerData[i][pQuestDeliveryPickup][quest])) DestroyPickup(PlayerData[i][pQuestDeliveryPickup][quest]);
        }
    }
    return 1;
}

stock AssignQuests(playerid)
{
    PlayerData[playerid][pQuestStage][0] = 1;
    SendClientMessage(playerid,COLOR_SPRING_GREEN,"[QUEST] Доставьте посылку по назначению!");
    PlayerData[playerid][pQuestItemModel][0] = QUEST_OBJECT_MODEL;

    new Float:pos[3] = {float(g_iFlowerLocations[random(g_iNumFlowerLocations)][0]),float(g_iFlowerLocations[random(g_iNumFlowerLocations)][1]),float(g_iFlowerLocations[random(g_iNumFlowerLocations)][2])};
    PlayerData[playerid][pQuestObject][0] = CreateObject(QUEST_OBJECT_MODEL,pos[0],pos[1],pos[2],0.0,0.0,0.0,200.0);
    AttachObjectToPlayer(PlayerData[playerid][pQuestObject][0],playerid,0.0,0.0,0.0,0.0,0.0,0.0);

    PlayerData[playerid][pQuestLocation][0][0] = QUEST_DELIVERY_LOCATION[0];
    PlayerData[playerid][pQuestLocation][0][1] = QUEST_DELIVERY_LOCATION[1];
    PlayerData[playerid][pQuestLocation][0][2] = QUEST_DELIVERY_LOCATION[2];

    PlayerData[playerid][pQuestDeliveryPickup][0] = CreatePickup(357,2,PlayerData[playerid][pQuestLocation][0][0],PlayerData[playerid][pQuestLocation][0][1],PlayerData[playerid][pQuestLocation][0][2],-1);
    SetTimerEx("UpdateDeliveryDistance",1000,true,"d",playerid);

    format(string,sizeof(string),"[QUEST] Отправляйтесь по координатам ~r~X: %d, Y: %d, Z: %d~w~!",PlayerData[playerid][pQuestLocation][0][0],PlayerData[playerid][pQuestLocation][0][1],PlayerData[playerid][pQuestLocation][0][2]);
    SendClientMessage(playerid,COLOR_SPRING_GREEN,string);
    return 1;
}

forward UpdateDeliveryDistance(playerid);
public UpdateDeliveryDistance(playerid)
{
   if(!IsPlayerConnected(playerid)) return KillTimer(timerid);

   new Float:playerPos[3];
   GetPlayerPos(playerid,playerPos[0],playerPos[1],playerPos[2]);

   new Float:distance = getDistance(playerPos[0],playerPos[1],playerPos[2],float(PlayerData[playerid][pQuestLocation][0][0]),float(PlayerData[playerid][pQuestLocation][0][1]),float(PlayerData[playerid][pQuestLocation][0][2]));
   format(string,sizeof(string),"[QUEST] Расстояние до точки назначения: %.1f метров.",distance);
   SendClientMessage(playerid,COLOR_SPRING_GREEN,string);
   return 1;
}

stock CompleteQuestStage(playerid, questid)
{
    PlayerData[playerid][pQuestStage][questid] = 2;
    SendClientMessage(playerid, COLOR_SPRING_GREEN, "[QUEST] Вы выполнили задание! Получите награду!");
    GivePlayerMoney(playerid, 10000);

    if(IsValidObject(PlayerData[playerid][pQuestObject][questid])) DestroyObject(PlayerData[playerid][pQuestObject][questid]);
    if(IsValidPickup(PlayerData[playerid][pQuestDeliveryPickup][questid])) DestroyPickup(PlayerData[playerid][pQuestDeliveryPickup][questid]);
    return 1;
}

stock Float:getDistance(Float:X1, Float:Y1, Float:Z1, Float:X2, Float:Y2, Float:Z2)
{
 return floatSqrt(floatPower(X2-X1, 2.0) + floatPower(Y2-Y1, 2.0) + floatPower(Z2-Z1, 2.0));
}

stock CreateVaktes()
{
    g_iVaktes = CreateNPC("Vaktes_Pizdukovich");

    SetNPCSkin(g_iVaktes, VAKTES_MODEL);
    SetNPCPos(g_iVaktes,VaktesData[vX], VaktesData[vY],VaktesData[vZ]);
    SetNPCAngle(g_iVaktes, Vakt

esData[vAngle]);
    SetNPCInterior(g_iVaktes,VaktesData[vInterior]);
    SetNPCWorld(g_iVaktes,VaktesData[vWorld]);
    return 1;
}


forward VaktesInteractionCheck();
public VaktesInteractionCheck()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
       if(!IsPlayerConnected(i)) continue;

       new Float:playerPos[3];
       GetPlayerPos(i,playerPos[0],playerPos[1],playerPos[2]);

       new Float:distance = getDistance(playerPos[0],playerPos[1],playerPos[2],VaktesData[vX],VaktesData[vY],VaktesData[vZ]);

       if(distance <= VAKTES_INTERACTION_DISTANCE)
       {
          if(!IsPlayerInAnyDialog(i))
          {
            ShowPlayerDialog(i, 1, DIALOG_STYLE_MSGBOX, "Вактес Пиздюкович",
                              "Приветствую! Я Вактес Пиздюкович, и я здесь, чтобы предложить тебе участие в весеннем ивенте.\n\n"
                              "Собери цветы, чтобы получить призы, или прими квест и получи еще больше наград!\n\n"
                              "Ты готов принять квест?", "Да, дай мне квест!", "Нет, спасибо.");
          }

       }
    }
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem)
{
    if (dialogid == 1)
    {
        if (response)
        {
            AssignQuests(playerid);
            SendClientMessage(playerid, COLOR_SPRING_GREEN, "[Вактес] Отлично! Вот твой квест. Удачи, сынок!");
        }
        else
        {
            SendClientMessage(playerid, COLOR_SPRING_GREEN, "[Вактес] Ну ладно, приходи, когда передумаешь. Цветочки сами себя не соберут.");
        }
        return 1;
    }
    return 0;
}

public OnGameModeInit()
{
    SetTimer("CheckBonusTime", 300000, true);

    AddFlowerLocation(1000.0, 1000.0, 10.0);
    AddFlowerLocation(1500.0, 1500.0, 15.0);
    AddFlowerLocation(2000.0, 2000.0, 20.0);
    AddFlowerLocation(2500.0, 2500.0, 25.0);
    AddFlowerLocation(3000.0, 3000.0, 30.0);
    AddFlowerLocation(3500.0, 3500.0, 35.0);
    AddFlowerLocation(4000.0, 4000.0, 40.0);
    AddFlowerLocation(4500.0, 4500.0, 45.0);
    AddFlowerLocation(5000.0, 5000.0, 50.0);
    AddFlowerLocation(5500.0, 5500.0, 55.0);

    CreateVaktes();
    SetTimer("VaktesInteractionCheck",1000,true);
    return 1;
}

public OnGameModeExit()
{
    KillTimer("CheckBonusTime");
    KillTimer("VaktesInteractionCheck");
    DestroyFlowerPickups();
    StopPlayerQuests();
    if(IsValidNPC(g_iVaktes)) DestroyNPC(g_iVaktes);
    return 1;
}