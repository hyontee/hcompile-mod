//Автор reserve studio
/*

в ipacket 252
#define OXOTA_OFFER 13
#define OXOTA_OFFER_TAKE 14
#define OXOTA_OFFER_PRIMANKA 17
case 13:
        {
            new t, sub_id, id;
            JSON_GetInt(JSONObject, "t", t);
            JSON_GetInt(JSONObject, "s", id);
            JSON_GetInt(JSONObject, "b", sub_id);

            switch(t)
            {
                case 0:
                {
                    switch(id)
                    {
                        case 1:
                        {
                            return;
                        }
                        case OXOTA_OFFER:
                        {
                        callcmd::oxota(playerid, "");
                        }
                        case OXOTA_OFFER_TAKE:
                        {
                        callcmd::take(playerid, "");
                        }
                        case OXOTA_OFFER_PRIMANKA:
                        {
                        callcmd::djivotkoe(playerid, "");
                        }
                        }
                        }
                        }
                        }
*/
#include <a_samp>
#include <streamer>

#define MAX_ANIMALS 16
#define AREA_RADIUS 2.0
#define MAX_BAIT_SPOTS 4
#define BAIT_ANIMAL_SPAWN_DELAY 10000

#define DUCK_ALIVE_MODEL 949
#define DUCK_DEAD_MODEL 943
#define DEER_ALIVE_MODEL 936
#define DEER_DEAD_MODEL 947
#define BEAR_ALIVE_MODEL 935
#define BEAR_DEAD_MODEL 948
#define HARE_ALIVE_MODEL 938
#define HARE_DEAD_MODEL 940

#define DUCK_PRICE 3000
#define DEER_PRICE 5000
#define BEAR_PRICE 8000
#define HARE_PRICE 2000

#define TARIFF_5_MIN 100
#define TARIFF_15_MIN 250
#define TARIFF_30_MIN 450
#define TARIFF_60_MIN 800

#define TIMER_5_MIN 300
#define TIMER_15_MIN 900
#define TIMER_30_MIN 1800
#define TIMER_60_MIN 3600

#define MOVE_DISTANCE 4.0
#define MOVE_SPEED 0.8
#define MOVE_DELAY 3000
#define MOVE_RETURN_DELAY 2000

new actor_oxota;
new vz_actor_oxota;
new actor_oxota_v[MAX_PLAYERS];
enum E_ANIMAL_DATA
{
    animalObjectID,
    areaID,
    animalModel,
    animalType,
    bool:animalAlive,
    Float:animalX,
    Float:animalY,
    Float:animalZ,
    Float:animalA,
    Float:animalCurrentX,
    Float:animalCurrentY,
    Float:animalCurrentZ,
    bool:animalDead,
    bool:animalCollected,
    animalOwnerID,
    animalWorldID,
    bool:animalIsActive,
    bool:animalIsMoving,
    bool:animalMovingForward,
    animalMoveTimer,
    Float:animalTargetX,
    Float:animalTargetY,
    Float:animalStartX,
    Float:animalStartY,
    bool:animalIsBaitSpawned
};

enum E_BAIT_DATA
{
    baitObjectID,
    baitTextID,
    baitAreaID,
    Float:baitX,
    Float:baitY,
    Float:baitZ,
    bool:baitActive,
    playerUsingBaitID,
    baitTimerID,
    baitAnimalID
};

new AnimalData[MAX_PLAYERS][MAX_ANIMALS][E_ANIMAL_DATA];
new bool:PlayerInOxotaMode[MAX_PLAYERS] = {false, ...};
new PlayerOxotaTimer[MAX_PLAYERS] = {-1, ...};
new PlayerBait[MAX_PLAYERS] = {0, ...};
new bool:BaitUsed[MAX_PLAYERS] = {false, ...};
new PlayerSkinBeforeOxota[MAX_PLAYERS] = {-1, ...};

new BaitData[MAX_BAIT_SPOTS][E_BAIT_DATA];

new const Float:AnimalSpawns[MAX_ANIMALS][6] = {
    {2160.777099, 527.007141, 12.209040, 157.526473, DUCK_ALIVE_MODEL, 0},
    {2151.711181, 650.455993, 13.054414, 99.298355, DUCK_ALIVE_MODEL, 0},
    {2063.223388, 574.723571, 12.209610, 0.384573, DUCK_ALIVE_MODEL, 0},
    {2078.733154, 603.737243, 10.754443, 302.493927, DUCK_ALIVE_MODEL, 0},
    
    {2274.438476, 579.955566, 27.263095, 181.375885, DEER_ALIVE_MODEL, 1},
    {2040.582397, 725.242431, 28.448417, 81.856819, DEER_ALIVE_MODEL, 1},
    {1971.668945, 703.631713, 24.136268, 113.044036, DEER_ALIVE_MODEL, 1},
    {1910.964599, 452.277099, 14.065353, 178.425308, DEER_ALIVE_MODEL, 1},
    
    {2255.756103, 610.820129, 31.024644, 35.924217, BEAR_ALIVE_MODEL, 2},
    {2042.483764, 671.747680, 25.011447, 214.185714, BEAR_ALIVE_MODEL, 2},
    {1933.729248, 628.990539, 15.096873, 155.456863, BEAR_ALIVE_MODEL, 2},
    {1907.237670, 513.456176, 15.018990, 149.306243, BEAR_ALIVE_MODEL, 2},
    {1866.813476, 417.409027, 15.016313, 104.942649, BEAR_ALIVE_MODEL, 2},
    
    {2059.404541, 630.542602, 14.892571, 346.880889, HARE_ALIVE_MODEL, 3},
    {2060.283935, 650.647460, 16.631240, 299.006622, HARE_ALIVE_MODEL, 3},
    {2141.772460, 668.678161, 14.446237, 302.046752, HARE_ALIVE_MODEL, 3}
};

new const Float:BaitPositions[MAX_BAIT_SPOTS][4] = {
    {2311.839355, 614.716674, 25.131301, 325.617401},
    {2007.316406, 610.846984, 25.821620, 159.841140},
    {1927.908691, 515.430603, 14.247761, 142.250289},
    {2177.352539, 764.087951, 16.944290, 307.344970}
};

forward CheckAnimalMovement(playerid, animalid);
public CheckAnimalMovement(playerid, animalid)
{
    if(!PlayerInOxotaMode[playerid] || 
       !AnimalData[playerid][animalid][animalIsActive] || 
       !AnimalData[playerid][animalid][animalAlive] || 
       AnimalData[playerid][animalid][animalDead])
    {
        AnimalData[playerid][animalid][animalIsMoving] = false;
        return;
    }
    
    if(IsObjectMoving(AnimalData[playerid][animalid][animalObjectID]))
    {
        AnimalData[playerid][animalid][animalMoveTimer] = SetTimerEx("CheckAnimalMovement", 100, false, "ii", playerid, animalid);
    }
    else
    {
        AnimalData[playerid][animalid][animalIsMoving] = false;
        
        GetObjectPos(AnimalData[playerid][animalid][animalObjectID], 
            AnimalData[playerid][animalid][animalCurrentX],
            AnimalData[playerid][animalid][animalCurrentY],
            AnimalData[playerid][animalid][animalCurrentZ]);
        
        UpdateAnimalArea(playerid, animalid);
        
        AnimalData[playerid][animalid][animalMoveTimer] = SetTimerEx("StartNextAnimalMove", MOVE_DELAY, false, "ii", playerid, animalid);
    }
}

UpdateAnimalArea(playerid, animalid)
{
    if(AnimalData[playerid][animalid][areaID] != -1 && !AnimalData[playerid][animalid][animalDead])
    {
        DestroyDynamicArea(AnimalData[playerid][animalid][areaID]);
        new vw = AnimalData[playerid][animalid][animalWorldID];
        AnimalData[playerid][animalid][areaID] = CreateDynamicSphere(
            AnimalData[playerid][animalid][animalCurrentX],
            AnimalData[playerid][animalid][animalCurrentY],
            AnimalData[playerid][animalid][animalCurrentZ],
            AREA_RADIUS,
            vw, -1, playerid
        );
        Streamer_SetIntData(STREAMER_TYPE_AREA, AnimalData[playerid][animalid][areaID], E_STREAMER_EXTRA_ID, animalid);
    }
}

forward StartNextAnimalMove(playerid, animalid);
public StartNextAnimalMove(playerid, animalid)
{
    if(!PlayerInOxotaMode[playerid] || 
       !AnimalData[playerid][animalid][animalIsActive] || 
       !AnimalData[playerid][animalid][animalAlive] || 
       AnimalData[playerid][animalid][animalDead])
    {
        AnimalData[playerid][animalid][animalIsMoving] = false;
        return;
    }
    
    if(AnimalData[playerid][animalid][animalMovingForward])
    {
        MoveAnimalBack(playerid, animalid);
    }
    else
    {
        MoveAnimalForward(playerid, animalid);
    }
}

MoveAnimalForward(playerid, animalid)
{
    if(!PlayerInOxotaMode[playerid] || 
       !AnimalData[playerid][animalid][animalIsActive] || 
       !AnimalData[playerid][animalid][animalAlive] || 
       AnimalData[playerid][animalid][animalDead] ||
       AnimalData[playerid][animalid][animalIsMoving])
    {
        return;
    }
    
    GetObjectPos(AnimalData[playerid][animalid][animalObjectID], 
        AnimalData[playerid][animalid][animalCurrentX],
        AnimalData[playerid][animalid][animalCurrentY],
        AnimalData[playerid][animalid][animalCurrentZ]);
    
    new Float:angle = AnimalData[playerid][animalid][animalA];
    new Float:targetX = AnimalData[playerid][animalid][animalCurrentX] + 
        (MOVE_DISTANCE * floatsin(-angle, degrees));
    new Float:targetY = AnimalData[playerid][animalid][animalCurrentY] + 
        (MOVE_DISTANCE * floatcos(-angle, degrees));
    
    AnimalData[playerid][animalid][animalTargetX] = targetX;
    AnimalData[playerid][animalid][animalTargetY] = targetY;
    AnimalData[playerid][animalid][animalMovingForward] = true;
    AnimalData[playerid][animalid][animalIsMoving] = true;
    
    MoveObject(AnimalData[playerid][animalid][animalObjectID], 
        targetX, targetY, AnimalData[playerid][animalid][animalCurrentZ], 
        MOVE_SPEED);
    
    AnimalData[playerid][animalid][animalMoveTimer] = SetTimerEx("CheckAnimalMovement", 100, false, "ii", playerid, animalid);
}

MoveAnimalBack(playerid, animalid)
{
    if(!PlayerInOxotaMode[playerid] || 
       !AnimalData[playerid][animalid][animalIsActive] || 
       !AnimalData[playerid][animalid][animalAlive] || 
       AnimalData[playerid][animalid][animalDead] ||
       AnimalData[playerid][animalid][animalIsMoving])
    {
        return;
    }
    
    GetObjectPos(AnimalData[playerid][animalid][animalObjectID], 
        AnimalData[playerid][animalid][animalCurrentX],
        AnimalData[playerid][animalid][animalCurrentY],
        AnimalData[playerid][animalid][animalCurrentZ]);
    
    new Float:targetX = AnimalData[playerid][animalid][animalStartX];
    new Float:targetY = AnimalData[playerid][animalid][animalStartY];
    
    AnimalData[playerid][animalid][animalTargetX] = targetX;
    AnimalData[playerid][animalid][animalTargetY] = targetY;
    AnimalData[playerid][animalid][animalMovingForward] = false;
    AnimalData[playerid][animalid][animalIsMoving] = true;
    
    MoveObject(AnimalData[playerid][animalid][animalObjectID], 
        targetX, targetY, AnimalData[playerid][animalid][animalCurrentZ], 
        MOVE_SPEED);
    
    AnimalData[playerid][animalid][animalMoveTimer] = SetTimerEx("CheckAnimalMovement", 100, false, "ii", playerid, animalid);
}

forward StartAnimalMovement(playerid, animalid);
public StartAnimalMovement(playerid, animalid)
{
    if(!PlayerInOxotaMode[playerid] || 
       !AnimalData[playerid][animalid][animalIsActive] || 
       !AnimalData[playerid][animalid][animalAlive])
    {
        return;
    }
    
    MoveAnimalForward(playerid, animalid);
}

forward StopAnimalMovement(playerid, animalid);
public StopAnimalMovement(playerid, animalid)
{
    if(AnimalData[playerid][animalid][animalMoveTimer] != -1)
    {
        KillTimer(AnimalData[playerid][animalid][animalMoveTimer]);
        AnimalData[playerid][animalid][animalMoveTimer] = -1;
    }
    
    if(AnimalData[playerid][animalid][animalObjectID] != INVALID_OBJECT_ID && 
       IsObjectMoving(AnimalData[playerid][animalid][animalObjectID]))
    {
        StopObject(AnimalData[playerid][animalid][animalObjectID]);
    }
    
    AnimalData[playerid][animalid][animalIsMoving] = false;
}

InitBaitSpots()
{
    for(new i = 0; i < MAX_BAIT_SPOTS; i++)
    {
        BaitData[i][baitObjectID] = INVALID_OBJECT_ID;
        BaitData[i][baitTextID] = Text3D:INVALID_3DTEXT_ID;
        BaitData[i][baitAreaID] = -1;
        BaitData[i][baitX] = BaitPositions[i][0];
        BaitData[i][baitY] = BaitPositions[i][1];
        BaitData[i][baitZ] = BaitPositions[i][2];
        BaitData[i][baitActive] = true;
        BaitData[i][playerUsingBaitID] = INVALID_PLAYER_ID;
        BaitData[i][baitTimerID] = -1;
        BaitData[i][baitAnimalID] = -1;
        
        new label[128];
        format(label, sizeof(label), "Место для приманки животных\n");
        BaitData[i][baitTextID] = CreateDynamic3DTextLabel(label, COLOR_YELLOW, 
            BaitData[i][baitX], BaitData[i][baitY], BaitData[i][baitZ] + 1.0, 
            10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, -1, -1);
        
        BaitData[i][baitAreaID] = CreateDynamicSphere(
            BaitData[i][baitX], BaitData[i][baitY], BaitData[i][baitZ],
            3.0, -1, -1
        );
        
    }
}

FindNearestBaitSpot(playerid, &baitid = -1)
{
    new Float:minDistance = 9999.9;
    new Float:playerX, Float:playerY, Float:playerZ;
    GetPlayerPos(playerid, playerX, playerY, playerZ);
    
    for(new i = 0; i < MAX_BAIT_SPOTS; i++)
    {
        if(BaitData[i][baitActive])
        {
            new Float:distance = GetDistanceBetweenPoints(playerX, playerY, playerZ, 
                BaitData[i][baitX], BaitData[i][baitY], BaitData[i][baitZ]);
            
            if(distance < minDistance && distance <= 3.0)
            {
                minDistance = distance;
                baitid = i;
            }
        }
    }
    
    return (baitid != -1);
}

forward SpawnBaitAnimal(playerid, baitid, animaltype);
public SpawnBaitAnimal(playerid, baitid, animaltype)
{
    if(!PlayerInOxotaMode[playerid])
    {
        BaitData[baitid][playerUsingBaitID] = INVALID_PLAYER_ID;
        BaitData[baitid][baitTimerID] = -1;
        SendClientMessage(playerid, -1, "Вы вышли с охоты до появления животного!");
        return;
    }
    
    if(BaitData[baitid][playerUsingBaitID] != playerid)
    {
        SendClientMessage(playerid, -1, "Кто-то другой уже использует эту приманку!");
        return;
    }
    
    new animalModels[] = {
        949,
        936,
        935,
        938
    };
    
    new animid;
    
    if(animaltype >= 0 && animaltype < sizeof(animalModels))
    {
        animid = animalModels[animaltype];
    }
    else
    {
        animid = 938;
    }
    
    new animalName[32];
    format(animalName, sizeof(animalName), "%s", GetAnimalName(animid));
    
    new freeSlot = -1;
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        if(!AnimalData[playerid][i][animalIsActive])
        {
            freeSlot = i;
            break;
        }
    }
    
    if(freeSlot == -1)
    {
        SendClientMessage(playerid, -1, "Достигнут лимит животных! Убейте кого-то сначала.");
        BaitData[baitid][playerUsingBaitID] = INVALID_PLAYER_ID;
        BaitData[baitid][baitTimerID] = -1;
        return;
    }
    
    new Float:spawnX = BaitData[baitid][baitX] + (2.0 * floatsin(-BaitPositions[baitid][3], degrees));
    new Float:spawnY = BaitData[baitid][baitY] + (2.0 * floatcos(-BaitPositions[baitid][3], degrees));
    new Float:spawnZ = BaitData[baitid][baitZ] - 1;
    new Float:spawnA = BaitPositions[baitid][3];
    
    AnimalData[playerid][freeSlot][animalObjectID] = CreateObject(
        animid, 
        spawnX, spawnY, spawnZ, 
        0.0, 0.0, spawnA
    );
    
    if(AnimalData[playerid][freeSlot][animalObjectID] == INVALID_OBJECT_ID)
    {
        SendClientMessage(playerid, -1, "Ошибка создания животного!");
        BaitData[baitid][playerUsingBaitID] = INVALID_PLAYER_ID;
        BaitData[baitid][baitTimerID] = -1;
        return;
    }
    
    AnimalData[playerid][freeSlot][animalModel] = animid;
    AnimalData[playerid][freeSlot][animalType] = animaltype;
    AnimalData[playerid][freeSlot][animalAlive] = true;
    AnimalData[playerid][freeSlot][animalDead] = false;
    AnimalData[playerid][freeSlot][animalCollected] = false;
    AnimalData[playerid][freeSlot][animalOwnerID] = playerid;
    AnimalData[playerid][freeSlot][animalWorldID] = GetPlayerOxotaWorld(playerid);
    AnimalData[playerid][freeSlot][animalX] = spawnX;
    AnimalData[playerid][freeSlot][animalY] = spawnY;
    AnimalData[playerid][freeSlot][animalZ] = spawnZ;
    AnimalData[playerid][freeSlot][animalA] = spawnA;
    AnimalData[playerid][freeSlot][animalCurrentX] = spawnX;
    AnimalData[playerid][freeSlot][animalCurrentY] = spawnY;
    AnimalData[playerid][freeSlot][animalCurrentZ] = spawnZ;
    AnimalData[playerid][freeSlot][animalIsActive] = true;
    AnimalData[playerid][freeSlot][animalIsMoving] = false;
    AnimalData[playerid][freeSlot][animalMovingForward] = true;
    AnimalData[playerid][freeSlot][animalMoveTimer] = -1;
    AnimalData[playerid][freeSlot][animalStartX] = spawnX;
    AnimalData[playerid][freeSlot][animalStartY] = spawnY;
    AnimalData[playerid][freeSlot][animalIsBaitSpawned] = true;
    
    AnimalData[playerid][freeSlot][areaID] = CreateDynamicSphere(
        spawnX, spawnY, spawnZ,
        AREA_RADIUS,
        GetPlayerOxotaWorld(playerid), -1, playerid
    );
    
    if(AnimalData[playerid][freeSlot][areaID] != -1)
    {
        Streamer_SetIntData(STREAMER_TYPE_AREA, AnimalData[playerid][freeSlot][areaID], E_STREAMER_EXTRA_ID, freeSlot);
    }
    
    SetTimerEx("StartAnimalMovement", 1000, false, "ii", playerid, freeSlot);
    
    BaitData[baitid][baitAnimalID] = freeSlot;
    
    new msg[128];
    format(msg, sizeof(msg), "Появился %s на приманке! Можете начинать охоту.", animalName);

}

RemoveBaitAfterAnimalKill(playerid, animalid)
{
    for(new i = 0; i < MAX_BAIT_SPOTS; i++)
    {
        if(BaitData[i][playerUsingBaitID] == playerid && BaitData[i][baitAnimalID] == animalid)
        {
            if(BaitData[i][baitTimerID] != -1)
            {
                KillTimer(BaitData[i][baitTimerID]);
                BaitData[i][baitTimerID] = -1;
            }
            
            BaitData[i][playerUsingBaitID] = INVALID_PLAYER_ID;
            BaitData[i][baitAnimalID] = -1;
            
            SendClientMessage(playerid, -1, "Приманка удалена после убийства животного.");
            
            break;
        }
    }
}

CMD:djiv(playerid, params[])
{
    if(!PlayerInOxotaMode[playerid])
    {
        SendClientMessage(playerid, -1, "Вы должны быть в режиме охоты, чтобы использовать приманку!");
        return 1;
    }
    
    if(PlayerBait[playerid] <= 0)
    {
        SendClientMessage(playerid, -1, "У вас нет приманок! Купите их в меню охотника.");
        return 1;
    }
    
    new baitid = -1;
    if(!FindNearestBaitSpot(playerid, baitid))
    {
        SendClientMessage(playerid, -1, "Вы не рядом с местом для приманки!");
        return 1;
    }
    
    if(!BaitData[baitid][baitActive])
    {
        SendClientMessage(playerid, -1, "Эта приманка сейчас недоступна!");
        return 1;
    }
    
    if(BaitData[baitid][playerUsingBaitID] != INVALID_PLAYER_ID)
    {
        SendClientMessage(playerid, -1, "Эта приманка уже используется другим охотником!");
        return 1;
    }
    
    PlayerBait[playerid]--;
    BaitData[baitid][playerUsingBaitID] = playerid;
    
    new animaltype = random(4);
    
    BaitData[baitid][baitTimerID] = SetTimerEx("SpawnBaitAnimal", BAIT_ANIMAL_SPAWN_DELAY, false, "iii", playerid, baitid, animaltype);
    
    
    
    return 1;
}

GetPlayerOxotaWorld(playerid) 
{
    return playerid + 100;
}

GetDeadAnimalModel(modelid)
{
    switch(modelid)
    {
        case DUCK_ALIVE_MODEL: return DUCK_DEAD_MODEL;
        case DEER_ALIVE_MODEL: return DEER_DEAD_MODEL;
        case BEAR_ALIVE_MODEL: return BEAR_DEAD_MODEL;
        case HARE_ALIVE_MODEL: return HARE_DEAD_MODEL;
        default: return modelid;
    }
}

GetAnimalName(modelid)
{
    new name[32];
    switch(modelid)
    {
        case DUCK_ALIVE_MODEL, DUCK_DEAD_MODEL: name = "утку";
        case DEER_ALIVE_MODEL, DEER_DEAD_MODEL: name = "оленя";
        case BEAR_ALIVE_MODEL, BEAR_DEAD_MODEL: name = "медведя";
        case HARE_ALIVE_MODEL, HARE_DEAD_MODEL: name = "зайца";
        default: name = "животное";
    }
    return name;
}

GetAnimalNameNom(modelid)
{
    new name[32];
    switch(modelid)
    {
        case DUCK_ALIVE_MODEL, DUCK_DEAD_MODEL: name = "Утка";
        case DEER_ALIVE_MODEL, DEER_DEAD_MODEL: name = "Олень";
        case BEAR_ALIVE_MODEL, BEAR_DEAD_MODEL: name = "Медведь";
        case HARE_ALIVE_MODEL, HARE_DEAD_MODEL: name = "Заяц";
        default: name = "Животное";
    }
    return name;
}

InitPlayerAnimals(playerid)
{
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        AnimalData[playerid][i][animalObjectID] = INVALID_OBJECT_ID;
        AnimalData[playerid][i][areaID] = -1;
        AnimalData[playerid][i][animalModel] = 0;
        AnimalData[playerid][i][animalType] = -1;
        AnimalData[playerid][i][animalAlive] = false;
        AnimalData[playerid][i][animalDead] = false;
        AnimalData[playerid][i][animalCollected] = false;
        AnimalData[playerid][i][animalOwnerID] = INVALID_PLAYER_ID;
        AnimalData[playerid][i][animalWorldID] = 0;
        AnimalData[playerid][i][animalIsActive] = false;
        AnimalData[playerid][i][animalIsMoving] = false;
        AnimalData[playerid][i][animalMovingForward] = true;
        AnimalData[playerid][i][animalMoveTimer] = -1;
        AnimalData[playerid][i][animalTargetX] = 0.0;
        AnimalData[playerid][i][animalTargetY] = 0.0;
        AnimalData[playerid][i][animalStartX] = 0.0;
        AnimalData[playerid][i][animalStartY] = 0.0;
        AnimalData[playerid][i][animalIsBaitSpawned] = false;
    }
}

FindAnimalByObjectID(playerid, objectid, &animalid = -1)
{
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        if(AnimalData[playerid][i][animalObjectID] == objectid && AnimalData[playerid][i][animalIsActive])
        {
            animalid = i;
            return 1;
        }
    }
    return 0;
}

FindAnimalByAreaID(playerid, areaid, &animalid = -1)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) 
    {
        animalid = -1;
        return 0;
    }
    
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        if(i >= 0 && i < MAX_ANIMALS)
        {
            if(AnimalData[playerid][i][animalIsActive] && AnimalData[playerid][i][areaID] == areaid)
            {
                animalid = i;
                return 1;
            }
        }
    }
    
    animalid = -1;
    return 0;
}

CreatePlayerAnimals(playerid)
{
    new vw = GetPlayerOxotaWorld(playerid);
    
    new animalsCreated = 0;
    
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        new Float:spawnX = AnimalSpawns[i][0];
        new Float:spawnY = AnimalSpawns[i][1];
        new Float:spawnZ = AnimalSpawns[i][2];
        new Float:spawnA = AnimalSpawns[i][3];
        new modelid = AnimalSpawns[i][4];
        new animalType = AnimalSpawns[i][5];
        
        AnimalData[playerid][i][animalObjectID] = CreateObject(
            modelid, 
            spawnX, spawnY, spawnZ, 
            0.0, 0.0, spawnA
        );
        
        if(AnimalData[playerid][i][animalObjectID] == INVALID_OBJECT_ID)
        {
            continue;
        }
        
        AnimalData[playerid][i][animalModel] = modelid;
        AnimalData[playerid][i][animalType] = animalType;
        AnimalData[playerid][i][animalAlive] = true;
        AnimalData[playerid][i][animalDead] = false;
        AnimalData[playerid][i][animalCollected] = false;
        AnimalData[playerid][i][animalOwnerID] = playerid;
        AnimalData[playerid][i][animalWorldID] = vw;
        AnimalData[playerid][i][animalX] = spawnX;
        AnimalData[playerid][i][animalY] = spawnY;
        AnimalData[playerid][i][animalZ] = spawnZ;
        AnimalData[playerid][i][animalA] = spawnA;
        AnimalData[playerid][i][animalCurrentX] = spawnX;
        AnimalData[playerid][i][animalCurrentY] = spawnY;
        AnimalData[playerid][i][animalCurrentZ] = spawnZ;
        AnimalData[playerid][i][animalIsActive] = true;
        AnimalData[playerid][i][animalIsMoving] = false;
        AnimalData[playerid][i][animalMovingForward] = true;
        AnimalData[playerid][i][animalMoveTimer] = -1;
        AnimalData[playerid][i][animalStartX] = spawnX;
        AnimalData[playerid][i][animalStartY] = spawnY;
        AnimalData[playerid][i][animalIsBaitSpawned] = false;
        
        AnimalData[playerid][i][areaID] = CreateDynamicSphere(
            spawnX, spawnY, spawnZ,
            AREA_RADIUS,
            vw, -1, playerid
        );
        
        if(AnimalData[playerid][i][areaID] != -1)
        {
            Streamer_SetIntData(STREAMER_TYPE_AREA, AnimalData[playerid][i][areaID], E_STREAMER_EXTRA_ID, i);
        }
        
        SetTimerEx("StartAnimalMovement", 1000, false, "ii", playerid, i);
        
        animalsCreated++;
    }
    
    Streamer_Update(playerid);
    
    return animalsCreated;
}

DestroyPlayerAnimals(playerid)
{
    new animalsRemoved = 0;
    
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        if(AnimalData[playerid][i][animalIsActive])
        {
            StopAnimalMovement(playerid, i);
            
            if(AnimalData[playerid][i][animalObjectID] != INVALID_OBJECT_ID)
            {
                DestroyObject(AnimalData[playerid][i][animalObjectID]);
            }
            
            if(AnimalData[playerid][i][areaID] != -1)
            {
                DestroyDynamicArea(AnimalData[playerid][i][areaID]);
            }
            
            if(AnimalData[playerid][i][animalIsBaitSpawned])
            {
                for(new j = 0; j < MAX_BAIT_SPOTS; j++)
                {
                    if(BaitData[j][playerUsingBaitID] == playerid && BaitData[j][baitAnimalID] == i)
                    {
                        if(BaitData[j][baitTimerID] != -1)
                        {
                            KillTimer(BaitData[j][baitTimerID]);
                        }
                        BaitData[j][playerUsingBaitID] = INVALID_PLAYER_ID;
                        BaitData[j][baitTimerID] = -1;
                        BaitData[j][baitAnimalID] = -1;
                        break;
                    }
                }
            }
            
            AnimalData[playerid][i][animalIsActive] = false;
            animalsRemoved++;
        }
    }
}

KillAnimal(playerid, animalid)
{
    if(animalid < 0 || animalid >= MAX_ANIMALS)
    {
        return 0;
    }
        
    if(!AnimalData[playerid][animalid][animalIsActive] || !AnimalData[playerid][animalid][animalAlive] || AnimalData[playerid][animalid][animalDead])
    {
        return 0;
    }
    
    StopAnimalMovement(playerid, animalid);
    
    new Float:killX = AnimalData[playerid][animalid][animalCurrentX];
    new Float:killY = AnimalData[playerid][animalid][animalCurrentY];
    new Float:killZ = AnimalData[playerid][animalid][animalCurrentZ];
    new Float:killA = AnimalData[playerid][animalid][animalA];
    new vw = AnimalData[playerid][animalid][animalWorldID];
    new modelid = AnimalData[playerid][animalid][animalModel];
    new dead_modelid = GetDeadAnimalModel(modelid);
    
    if(AnimalData[playerid][animalid][animalObjectID] != INVALID_OBJECT_ID)
    {
        DestroyObject(AnimalData[playerid][animalid][animalObjectID]);
    }
    
    new Float:deadZ = killZ;
    
    
    AnimalData[playerid][animalid][animalObjectID] = CreateObject(
        dead_modelid, 
        killX, killY, deadZ, 
        0.0, 0.0, killA
    );
    
    if(AnimalData[playerid][animalid][animalObjectID] == INVALID_OBJECT_ID)
    {
        return 0;
    }
    
    AnimalData[playerid][animalid][animalAlive] = false;
    AnimalData[playerid][animalid][animalDead] = true;
    AnimalData[playerid][animalid][animalCollected] = false;
    AnimalData[playerid][animalid][animalModel] = dead_modelid;
    AnimalData[playerid][animalid][animalCurrentZ] = deadZ;
    
    if(AnimalData[playerid][animalid][areaID] != -1)
    {
        DestroyDynamicArea(AnimalData[playerid][animalid][areaID]);
        AnimalData[playerid][animalid][areaID] = CreateDynamicSphere(killX, killY, deadZ, AREA_RADIUS, vw, -1, playerid);
        Streamer_SetIntData(STREAMER_TYPE_AREA, AnimalData[playerid][animalid][areaID], E_STREAMER_EXTRA_ID, animalid);
    }
    
    if(AnimalData[playerid][animalid][animalIsBaitSpawned])
    {
        RemoveBaitAfterAnimalKill(playerid, animalid);
    }
    
    new animalName[32];
    animalName = GetAnimalName(modelid);
    
        
    return 1;
}

CollectAnimal(playerid, animalid)
{
    if(animalid < 0 || animalid >= MAX_ANIMALS)
    {
        SendClientMessage(playerid, -1, "Ошибка: неверный ID животного");
        return 0;
    }
        
    if(!AnimalData[playerid][animalid][animalDead] || AnimalData[playerid][animalid][animalCollected])
    {
        SendClientMessage(playerid, -1, "Это животное не может быть собрано!");
        return 0;
    }
    
    ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
    
    new animalModel_vveez = AnimalData[playerid][animalid][animalModel];
    new animalName_vveez[32];
    new animalType_vveez = -1;
    
    switch(animalModel_vveez)
    {
        case DUCK_ALIVE_MODEL, DUCK_DEAD_MODEL: 
        {
            animalName_vveez = "утку";
            animalType_vveez = 0;
        }
        case DEER_ALIVE_MODEL, DEER_DEAD_MODEL: 
        {
            animalName_vveez = "оленя";
            animalType_vveez = 1;
        }
        case BEAR_ALIVE_MODEL, BEAR_DEAD_MODEL: 
        {
            animalName_vveez = "медведя";
            animalType_vveez = 2;
        }
        case HARE_ALIVE_MODEL, HARE_DEAD_MODEL: 
        {
            animalName_vveez = "зайца";
            animalType_vveez = 3;
        }
        default:
        {
            animalName_vveez = "животное";
            animalType_vveez = -1;
        }
    }
    
    switch(animalType_vveez)
    {
        case 0: 
        {
            SetPVarInt(playerid, "P_DUCK", GetPVarInt(playerid, "P_DUCK") + 1);
        }
        case 1: 
        {
            SetPVarInt(playerid, "P_DEER", GetPVarInt(playerid, "P_DEER") + 1);
        }
        case 2: 
        {
            SetPVarInt(playerid, "P_BEAR", GetPVarInt(playerid, "P_BEAR") + 1);
        }
        case 3: 
        {
            SetPVarInt(playerid, "P_HARE", GetPVarInt(playerid, "P_HARE") + 1);
        }
    }
    
    new msg_vveez[128];
    format(msg_vveez, sizeof(msg_vveez), "Вы собрали шкуру %s! Всего: +1", animalName_vveez);
    SendClientMessage(playerid, -1, msg_vveez);
    
    AnimalData[playerid][animalid][animalCollected] = true;
    
    StopAnimalMovement(playerid, animalid);
    
    if(AnimalData[playerid][animalid][animalObjectID] != INVALID_OBJECT_ID)
    {
        DestroyObject(AnimalData[playerid][animalid][animalObjectID]);
        AnimalData[playerid][animalid][animalObjectID] = INVALID_OBJECT_ID;
    }
    
    if(AnimalData[playerid][animalid][areaID] != -1)
    {
        DestroyDynamicArea(AnimalData[playerid][animalid][areaID]);
        AnimalData[playerid][animalid][areaID] = -1;
    }
    
    AnimalData[playerid][animalid][animalIsActive] = false;
    
    return 1;
}

stock Float:GetDistanceBetweenPoints(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    return floatsqroot((x1-x2)*(x1-x2) + (y1-y2)*(y1-y2) + (z1-z2)*(z1-z2));
}

forward OxotaTimerEnd(playerid);
public OxotaTimerEnd(playerid)
{
    if(PlayerInOxotaMode[playerid])
    {
        new oldvw = GetPVarInt(playerid, "OldVW");
        new oldint = GetPVarInt(playerid, "OldInt");
        
        SetPlayerVirtualWorld(playerid, oldvw);
        SetPlayerInterior(playerid, oldint);
        
        if(PlayerSkinBeforeOxota[playerid] != -1)
        {
            SetPlayerSkin(playerid, PlayerSkinBeforeOxota[playerid]);
            PlayerSkinBeforeOxota[playerid] = -1;
        }
        
        DestroyPlayerAnimals(playerid);
        
        for(new i = 0; i < MAX_BAIT_SPOTS; i++)
        {
            if(BaitData[i][playerUsingBaitID] == playerid)
            {
                if(BaitData[i][baitTimerID] != -1)
                {
                    KillTimer(BaitData[i][baitTimerID]);
                }
                BaitData[i][playerUsingBaitID] = INVALID_PLAYER_ID;
                BaitData[i][baitTimerID] = -1;
                BaitData[i][baitAnimalID] = -1;
            }
        }
        
        PlayerInOxotaMode[playerid] = false;
        PlayerOxotaTimer[playerid] = -1;
        
        DeletePVar(playerid, "OldVW");
        DeletePVar(playerid, "OldInt");
        DestroyActorForPlayer(playerid);
        SendClientMessage(playerid, -1, "Время охоты истекло!");
        SendClientMessage(playerid, -1, "Вы были возвращены на базу лесничества.");
    }
}

StartPlayerOxotaWithTimer(playerid, minutes)
{
CreateActorForPlayer(playerid, 58, 2128.786621, 489.371185, 13.330902, 191.729736, "Михалыч", "[NPC]\nЛесничий");
    if(PlayerInOxotaMode[playerid])
    {
        SendClientMessage(playerid, -1, "Вы уже в режиме охоты!");
        return 0;
    }
    
    SetPVarInt(playerid, "OldVW", GetPlayerVirtualWorld(playerid));
    SetPVarInt(playerid, "OldInt", GetPlayerInterior(playerid));
    
    new vw = GetPlayerOxotaWorld(playerid);
    SetPlayerVirtualWorld(playerid, vw);
    SetPlayerInterior(playerid, 0);
    
    PlayerSkinBeforeOxota[playerid] = GetPlayerSkin(playerid);
    SetPlayerSkin(playerid, 58);
    
    InitPlayerAnimals(playerid);
    new created = CreatePlayerAnimals(playerid);
    
    if(created == 0)
    {
        SendClientMessage(playerid, -1, "Ошибка: не удалось создать животных!");
        return 0;
    }
    
    PlayerInOxotaMode[playerid] = true;
    
    new timerSeconds;
    switch(minutes)
    {
        case 5: timerSeconds = TIMER_5_MIN;
        case 15: timerSeconds = TIMER_15_MIN;
        case 30: timerSeconds = TIMER_30_MIN;
        case 60: timerSeconds = TIMER_60_MIN;
        default: timerSeconds = TIMER_5_MIN;
    }
    
    PlayerOxotaTimer[playerid] = SetTimerEx("OxotaTimerEnd", timerSeconds * 1000, false, "i", playerid);
    
    new msg[128];
    format(msg, sizeof(msg), "Вы начали охоту на %d минут!", minutes);
    SendClientMessage(playerid, -1, msg);
    SendClientMessage(playerid, -1, "Доступные животные: утки, олени, медведи, зайцы");
    
    return 1;
}

#define DIALOG_OXOTA_MAIN 14888
#define DIALOG_OXOTA_MENU 14889
#define DIALOG_OXOTA_TARIFFS 14900
#define DIALOG_OXOTA_SELL 14901
#define DIALOG_OXOTA_PRICES 14902
#define DIALOG_OXOTA_BAIT 14903
#define DIALOG_OXOTA_STATS 14904

Dialog_OxotaMain(playerid)
{
    new str[1024];
    format(str, sizeof(str), "Добро пожаловать в охотничье хозяйство!\n\n\
        Охота - это искусство, требующее терпения, меткости\n\
        и уважения к природе. В наших угодьях вы найдете\n\
        разнообразных животных, каждый трофей - уникален!\n\n\
        Для начала охоты вам необходимо:\n\
        1. Лицензия на оружие\n\
        2. Охотничья винтовка\n\
        3. Выбрать подходящий тариф");
    
    ShowPlayerDialog(playerid, DIALOG_OXOTA_MAIN, DIALOG_STYLE_MSGBOX,
        "Охотничье дело",
        str,
        "Далее", "Закрыть");
}

Dialog_OxotaMenu(playerid)
{
    new str[2048];
    format(str, sizeof(str), 
        "Опция\tДействие\tСтатус\n\
        1. Моя статистика охотника\tПросмотр\tНажмите для открытия\n\
        2. Доступные тарифы охоты\tВыбор\tНажмите для выбора времени\n\
        3. Мои охотничьи трофеи\tПросмотр\tНажмите для просмотра\n\
        4. Приманки для животных\tПокупка\tНажмите для покупки\n\
        5. Продать добычу\tПродажа\tНажмите для продажи\n\
        6. Стоимость животных\tСправочник\tНажмите для информации");
    
    ShowPlayerDialog(playerid, DIALOG_OXOTA_MENU, DIALOG_STYLE_TABLIST_HEADERS,
        "Меню охотника",
        str,
        "Выбрать", "Назад");
}

Dialog_OxotaTariffs(playerid)
{
    new str[1024];
    format(str, sizeof(str), 
        "Тариф\tВремя\tСтоимость\tРекомендация\n\
        1. Быстрая охота\t5 минут\t100рублей\tДля новичков\n\
        2. Стандартная\t15 минут\t250рублей\tДля любителей\n\
        3. Продвинутая\t30 минут\t450рублей\tДля опытных\n\
        4. Профессионал\t60 минут\t800рублей\tДля мастеров");
    
    ShowPlayerDialog(playerid, DIALOG_OXOTA_TARIFFS, DIALOG_STYLE_TABLIST_HEADERS,
        "Выбор тарифа охоты",
        str,
        "Купить", "Назад");
}

Dialog_OxotaSell(playerid)
{
    new duckCount = GetPVarInt(playerid, "P_DUCK");
    new deerCount = GetPVarInt(playerid, "P_DEER");
    new bearCount = GetPVarInt(playerid, "P_BEAR");
    new hareCount = GetPVarInt(playerid, "P_HARE");
    
    new totalDuck = duckCount * DUCK_PRICE;
    new totalDeer = deerCount * DEER_PRICE;
    new totalBear = bearCount * BEAR_PRICE;
    new totalHare = hareCount * HARE_PRICE;
    new totalAll = totalDuck + totalDeer + totalBear + totalHare;
    
    new str[1024];
    format(str, sizeof(str), 
        "Трофей\tКоличество\tЦена за шт.\tОбщая сумма\n\
        Утиная шкура\t%d шт.\t3000рублей\t%dрублей\n\
        Оленья шкура\t%d шт.\t5000рублей\t%dрублей\n\
        Медвежья шкура\t%d шт.\t8000рублей\t%dрублей\n\
        Заячья шкура\t%d шт.\t2000рублей\t%dрублей\n\n\
        Итого к оплате: %dрублей", 
        duckCount, totalDuck, deerCount, totalDeer, bearCount, totalBear, hareCount, totalHare, totalAll);
    
    ShowPlayerDialog(playerid, DIALOG_OXOTA_SELL, DIALOG_STYLE_MSGBOX,
        "Продажа добычи",
        str,
        "Продать всё", "Отмена");
}

Dialog_OxotaPrices(playerid)
{
    new str[1024];
    format(str, sizeof(str), 
        "Животное\tСтоимость шкуры\tСложность\n\
        Утка\t\t3000рублей\t\tНизкая\n\
        Заяц\t\t2000рублей\t\tНизкая\n\
        Олень\t\t5000рублей\t\tСредняя\n\
        Медведь\t\t8000рублей\t\tВысокая\n\n\
        Совет: медведи приносят больше прибыли, но требуют больше навыков и осторожности!");
    
    ShowPlayerDialog(playerid, DIALOG_OXOTA_PRICES, DIALOG_STYLE_MSGBOX,
        "Стоимость трофеев",
        str,
        "Закрыть", "");
}

Dialog_OxotaBait(playerid)
{
    new str[1024];
    format(str, sizeof(str), 
        "Приманка\tКоличество\tЦена\tЭффект\n\
        1. Стандартная приманка\t1 шт.\t50рублей\tПривлекает уток\n\
        2. Улучшенная приманка\t1 шт.\t100рублей\tПривлекает оленей\n\
        3. Профессиональная\t1 шт.\t200рублей\tПривлекает медведей");
    
    ShowPlayerDialog(playerid, DIALOG_OXOTA_BAIT, DIALOG_STYLE_TABLIST_HEADERS,
        "Покупка приманок",
        str,
        "Купить", "Назад");
}

Dialog_OxotaStats(playerid)
{
    new duckCount = GetPVarInt(playerid, "P_DUCK");
    new deerCount = GetPVarInt(playerid, "P_DEER");
    new bearCount = GetPVarInt(playerid, "P_BEAR");
    new hareCount = GetPVarInt(playerid, "P_HARE");
    
    new totalKills = duckCount + deerCount + bearCount + hareCount;
    new totalMoney = (duckCount * DUCK_PRICE) + (deerCount * DEER_PRICE) + (bearCount * BEAR_PRICE) + (hareCount * HARE_PRICE);
    
    new str[1024];
    format(str, sizeof(str), 
        "Статистика охотника: %s\n\n\
        Всего трофеев: %d шт.\n\
        Общая стоимость: %dрублей\n\n\
        Детализация:\n\
        Уток добыто: %d шт. (%dрублей)\n\
        Оленей добыто: %d шт. (%dрублей)\n\
        Медведей добыто: %d шт. (%dрублей)\n\
        Зайцев добыто: %d шт. (%dрублей)\n\n\
        Приманок осталось: %d шт.", 
        GetPlayerNameEx(playerid), totalKills, totalMoney, 
        duckCount, duckCount * DUCK_PRICE, 
        deerCount, deerCount * DEER_PRICE, 
        bearCount, bearCount * BEAR_PRICE, 
        hareCount, hareCount * HARE_PRICE,
        PlayerBait[playerid]);
    
    ShowPlayerDialog(playerid, DIALOG_OXOTA_STATS, DIALOG_STYLE_MSGBOX,
        "Моя статистика охотника",
        str,
        "Закрыть", "");
}

CMD:oxota(playerid, params[])
{
    Dialog_OxotaMain(playerid);
    return 1;
}

CMD:oxotaexit(playerid, params[])
{
    if(!PlayerInOxotaMode[playerid])
    {
        SendClientMessage(playerid, -1, "Вы не в режиме охоты!");
        return 1;
    }
    
    if(PlayerOxotaTimer[playerid] != -1)
    {
        KillTimer(PlayerOxotaTimer[playerid]);
        PlayerOxotaTimer[playerid] = -1;
    }
    
    new oldvw = GetPVarInt(playerid, "OldVW");
    new oldint = GetPVarInt(playerid, "OldInt");
    SetPlayerVirtualWorld(playerid, oldvw);
    SetPlayerInterior(playerid, oldint);
    DeletePVar(playerid, "OldVW");
    DeletePVar(playerid, "OldInt");
    
    if(PlayerSkinBeforeOxota[playerid] != -1)
    {
        SetPlayerSkin(playerid, PlayerSkinBeforeOxota[playerid]);
        PlayerSkinBeforeOxota[playerid] = -1;
    }
    
    DestroyPlayerAnimals(playerid);
    
    for(new i = 0; i < MAX_BAIT_SPOTS; i++)
    {
        if(BaitData[i][playerUsingBaitID] == playerid)
        {
            if(BaitData[i][baitTimerID] != -1)
            {
                KillTimer(BaitData[i][baitTimerID]);
            }
            BaitData[i][playerUsingBaitID] = INVALID_PLAYER_ID;
            BaitData[i][baitTimerID] = -1;
            BaitData[i][baitAnimalID] = -1;
        }
    }
    
    PlayerInOxotaMode[playerid] = false;
    BaitUsed[playerid] = false;
    
    SendClientMessage(playerid, -1, "Вы вышли с охоты.");
    
    return 1;
}

CMD:take(playerid, params[])
{
    if(!PlayerInOxotaMode[playerid])
    {
        SendClientMessage(playerid, -1, "Вы не в режиме охоты!");
        return 1;
    }
    
    new Float:playerX_vveez, Float:playerY_vveez, Float:playerZ_vveez;
    GetPlayerPos(playerid, playerX_vveez, playerY_vveez, playerZ_vveez);
    
    new nearestAnimal_vveez = -1;
    new Float:nearestDist_vveez = 9999.9;
    
    for(new i_vveez = 0; i_vveez < MAX_ANIMALS; i_vveez++)
    {
        if(AnimalData[playerid][i_vveez][animalIsActive] && 
           AnimalData[playerid][i_vveez][animalDead] && 
           !AnimalData[playerid][i_vveez][animalCollected])
        {
            new Float:dist_vveez = GetDistanceBetweenPoints(
                playerX_vveez, playerY_vveez, playerZ_vveez,
                AnimalData[playerid][i_vveez][animalCurrentX],
                AnimalData[playerid][i_vveez][animalCurrentY],
                AnimalData[playerid][i_vveez][animalCurrentZ]
            );
            
            if(dist_vveez < nearestDist_vveez)
            {
                nearestAnimal_vveez = i_vveez;
                nearestDist_vveez = dist_vveez;
            }
        }
    }
    
    if(nearestAnimal_vveez != -1)
    {
        if(nearestDist_vveez <= AREA_RADIUS)
        {
            CollectAnimal(playerid, nearestAnimal_vveez);
            DeletePVar(playerid, "CurrentAnimalArea");
        }
        else
        {
            SendClientMessage(playerid, -1, "Вы слишком далеко от убитого животного!");
        }
    }
    else
    {
        SendClientMessage(playerid, -1, "Нет убитых животных поблизости, которые можно собрать!");
    }
    
    return 1;
}

CMD:animalsinfo(playerid, params[])
{
    if(!PlayerInOxotaMode[playerid])
    {
        SendClientMessage(playerid, -1, "Вы не в режиме охоты!");
        return 1;
    }
    
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);
    
    new count = 0;
    new infoMsg[512];
    format(infoMsg, sizeof(infoMsg), "Животные рядом с вами (в радиусе 100м):\n");
    
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        if(AnimalData[playerid][i][animalIsActive])
        {
            new Float:distance = GetDistanceBetweenPoints(px, py, pz, AnimalData[playerid][i][animalCurrentX], AnimalData[playerid][i][animalCurrentY], AnimalData[playerid][i][animalCurrentZ]);
            
            if(distance < 100.0)
            {
                new animalTypeName[32];
                switch(AnimalData[playerid][i][animalModel])
                {
                    case DUCK_ALIVE_MODEL, DUCK_DEAD_MODEL: animalTypeName = "Утка";
                    case DEER_ALIVE_MODEL, DEER_DEAD_MODEL: animalTypeName = "Олень";
                    case BEAR_ALIVE_MODEL, BEAR_DEAD_MODEL: animalTypeName = "Медведь";
                    case HARE_ALIVE_MODEL, HARE_DEAD_MODEL: animalTypeName = "Заяц";
                    default: animalTypeName = "Неизвестно";
                }
                
                new status[16];
                if(AnimalData[playerid][i][animalAlive])
                    format(status, sizeof(status), "Живой");
                else if(AnimalData[playerid][i][animalDead] && !AnimalData[playerid][i][animalCollected])
                    format(status, sizeof(status), "Мертвый (собрать)");
                else if(AnimalData[playerid][i][animalDead] && AnimalData[playerid][i][animalCollected])
                    format(status, sizeof(status), "Мертвый (собран)");
                else
                    format(status, sizeof(status), "Отсутствует");
                
                new baitInfo[16];
                if(AnimalData[playerid][i][animalIsBaitSpawned])
                    format(baitInfo, sizeof(baitInfo), " [Приманка]");
                else
                    format(baitInfo, sizeof(baitInfo), "");
                
                new fmt_ste[128];
                format(fmt_ste, sizeof(fmt_ste), "\t%s - %s (%.1f м)%s\n", animalTypeName, status, distance, baitInfo);
                strcat(infoMsg, fmt_ste);
                count++;
            }
        }
    }
    
    if(count == 0)
    {
        strcat(infoMsg, "\tНет животных в радиусе 100 метров.");
    }
    
    ShowPlayerDialog(playerid, 9998, DIALOG_STYLE_MSGBOX,
        "Информация о животных",
        infoMsg,
        "Закрыть", "");
    
    return 1;
}

CMD:testoxota(playerid, params[])
{
    if(!PlayerInOxotaMode[playerid])
    {
        SendClientMessage(playerid, -1, "Вы не в режиме охоты!");
        return 1;
    }
    
    new activeAnimals = 0;
    new deadAnimals = 0;
    new collectedAnimals = 0;
    new baitAnimals = 0;
    new typeStats[4] = {0, 0, 0, 0};
    
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        if(AnimalData[playerid][i][animalIsActive])
        {
            activeAnimals++;
            
            if(AnimalData[playerid][i][animalDead]) deadAnimals++;
            if(AnimalData[playerid][i][animalCollected]) collectedAnimals++;
            if(AnimalData[playerid][i][animalIsBaitSpawned]) baitAnimals++;
            
            if(AnimalData[playerid][i][animalType] != -1)
            {
                typeStats[AnimalData[playerid][i][animalType]]++;
            }
        }
    }
    
    new msg[256];
    format(msg, sizeof(msg), "Статистика животных:\n\n\
        Всего животных: %d\n\
        Мертвых: %d\n\
        Собранных: %d\n\
        С приманки: %d\n\n\
        По типам:\n\
        Утки: %d\n\
        Олени: %d\n\
        Медведи: %d\n\
        Зайцы: %d",
        activeAnimals, deadAnimals, collectedAnimals, baitAnimals,
        typeStats[0], typeStats[1], typeStats[2], typeStats[3]);
    
    ShowPlayerDialog(playerid, 9997, DIALOG_STYLE_MSGBOX, "Тест системы охоты", msg, "Закрыть", "");
    
    return 1;
}

CMD:debuganimals(playerid, params[])
{
    if(!PlayerInOxotaMode[playerid])
    {
        SendClientMessage(playerid, -1, "Вы не в режиме охоты!");
        return 1;
    }
    
    new debugMsg[1024];
    format(debugMsg, sizeof(debugMsg), "Отладка животных (игрок %d):\n\n", playerid);
    
    new total = 0;
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        if(AnimalData[playerid][i][animalIsActive])
        {
            new typeName[32];
            switch(AnimalData[playerid][i][animalModel])
            {
                case DUCK_ALIVE_MODEL, DUCK_DEAD_MODEL: typeName = "Утка";
                case DEER_ALIVE_MODEL, DEER_DEAD_MODEL: typeName = "Олень";
                case BEAR_ALIVE_MODEL, BEAR_DEAD_MODEL: typeName = "Медведь";
                case HARE_ALIVE_MODEL, HARE_DEAD_MODEL: typeName = "Заяц";
                default: typeName = "Неизвестно";
            }
            
            new status[32];
            if(AnimalData[playerid][i][animalAlive]) format(status, sizeof(status), "Живой");
            else if(AnimalData[playerid][i][animalDead] && !AnimalData[playerid][i][animalCollected]) format(status, sizeof(status), "Мертвый");
            else if(AnimalData[playerid][i][animalDead] && AnimalData[playerid][i][animalCollected]) format(status, sizeof(status), "Собран");
            else format(status, sizeof(status), "Нет данных");
            
            new baitInfo[16];
            if(AnimalData[playerid][i][animalIsBaitSpawned])
                format(baitInfo, sizeof(baitInfo), " [Приманка]");
            else
                format(baitInfo, sizeof(baitInfo), "");
            
            new fmt_srt[128];
            format(fmt_srt, sizeof(fmt_srt), "Животное %d: %s - %s (Координаты: %.1f, %.1f, %.1f) модель=%d тип=%d%s\n", 
                i, typeName, status, 
                AnimalData[playerid][i][animalCurrentX],
                AnimalData[playerid][i][animalCurrentY],
                AnimalData[playerid][i][animalCurrentZ],
                AnimalData[playerid][i][animalModel],
                AnimalData[playerid][i][animalType],
                baitInfo);
            strcat(debugMsg, fmt_srt);
            total++;
        }
    }
    
    if(total == 0)
    {
        strcat(debugMsg, "У вас нет активных животных!");
    }
    else
    {
        new summary[64];
        format(summary, sizeof(summary), "\nВсего активных животных: %d", total);
        strcat(debugMsg, summary);
    }
    
    ShowPlayerDialog(playerid, 9996, DIALOG_STYLE_MSGBOX, "Отладка животных", debugMsg, "Закрыть", "");
    
    return 1;
}

CMD:killnear(playerid, params[])
{
    if(!PlayerInOxotaMode[playerid])
    {
        SendClientMessage(playerid, -1, "Вы не в режиме охоты!");
        return 1;
    }
    
    new Float:playerX, Float:playerY, Float:playerZ;
    GetPlayerPos(playerid, playerX, playerY, playerZ);
    
    new nearestAnimal = -1;
    new Float:nearestDist = 50.0;
    
    for(new i = 0; i < MAX_ANIMALS; i++)
    {
        if(AnimalData[playerid][i][animalIsActive] && AnimalData[playerid][i][animalAlive])
        {
            new Float:animalX = AnimalData[playerid][i][animalCurrentX];
            new Float:animalY = AnimalData[playerid][i][animalCurrentY];
            new Float:animalZ = AnimalData[playerid][i][animalCurrentZ];
            
            new Float:dist = GetDistanceBetweenPoints(playerX, playerY, playerZ, animalX, animalY, animalZ);
            
            if(dist < nearestDist)
            {
                nearestAnimal = i;
                nearestDist = dist;
            }
        }
    }
    
    if(nearestAnimal != -1)
    {
        KillAnimal(playerid, nearestAnimal);
        
        new msg[128];
        format(msg, sizeof(msg), "Вы убили животное! Дистанция: %.1fм", nearestDist);
        SendClientMessage(playerid, -1, msg);
    }
    else
    {
        SendClientMessage(playerid, -1, "Нет животных поблизости (в радиусе 50м)!");
    }
    
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])    
{
    if(dialogid == DIALOG_OXOTA_MAIN)
    {
        if(response)
        {
        new weapon_vveez = GetPlayerWeapon(playerid);
    
    if(weapon_vveez != 33)
    {
        SendClientMessage(playerid, -1, "Для работы нужна винтовка!");
        return 1;
    }
            Dialog_OxotaMenu(playerid);
        }
        return 1;
    }
    if(dialogid == 12888)
    {
        if(response)
        {
        OxotaTimerEnd(playerid);
        }
        
        }
    if(dialogid == DIALOG_OXOTA_MENU)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0: Dialog_OxotaStats(playerid);
                case 1: 
{
if(PlayerInOxotaMode[playerid])
    {
    Dialog(playerid, 12888, DIALOG_STYLE_MSGBOX, "Михалыч", "Вы действительно хотите прекратить охоту?","Далее","Отмена");
    }
    else
    {
Dialog_OxotaTariffs(playerid);
}
}
                case 2: 
                {
                    new duckCount = GetPVarInt(playerid, "P_DUCK");
                    new deerCount = GetPVarInt(playerid, "P_DEER");
                    new bearCount = GetPVarInt(playerid, "P_BEAR");
                    new hareCount = GetPVarInt(playerid, "P_HARE");
                    
                    new msg[256];
                    format(msg, sizeof(msg), 
                        "Ваши трофеи:\n\n\
                        Утиные шкуры: %d\n\
                        Оленьи шкуры: %d\n\
                        Медвежьи шкуры: %d\n\
                        Заячьи шкуры: %d", 
                        duckCount, deerCount, bearCount, hareCount);
                    
                    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX,
                        "Мои трофеи",
                        msg,
                        "Закрыть", "");
                }
                case 3: Dialog_OxotaBait(playerid);
                case 4: Dialog_OxotaSell(playerid);
                case 5: Dialog_OxotaPrices(playerid);
            }
        }
        return 1;
    }
    
    if(dialogid == DIALOG_OXOTA_TARIFFS)
    {
        if(response)
        {
            new playerMoney = GetPlayerMoney(playerid);
            new price = 0;
            new minutes = 0;
            
            switch(listitem)
            {
                case 0: { price = TARIFF_5_MIN; minutes = 5; }
                case 1: { price = TARIFF_15_MIN; minutes = 15; }
                case 2: { price = TARIFF_30_MIN; minutes = 30; }
                case 3: { price = TARIFF_60_MIN; minutes = 60; }
            }
            
            if(playerMoney < price)
            {
                SendClientMessage(playerid, -1, "У вас недостаточно денег для этого тарифа!");
                return 1;
            }
            
            GivePlayerMoney(playerid, -price);
            StartPlayerOxotaWithTimer(playerid, minutes);
        }
        else
        {
            Dialog_OxotaMenu(playerid);
        }
        return 1;
    }
    
    if(dialogid == DIALOG_OXOTA_SELL)
    {
        if(response)
        {
            new duckCount = GetPVarInt(playerid, "P_DUCK");
            new deerCount = GetPVarInt(playerid, "P_DEER");
            new bearCount = GetPVarInt(playerid, "P_BEAR");
            new hareCount = GetPVarInt(playerid, "P_HARE");
            
            if(duckCount == 0 && deerCount == 0 && bearCount == 0 && hareCount == 0)
            {
                SendClientMessage(playerid, -1, "У вас нет добычи для продажи!");
                return 1;
            }
            
            new total = (duckCount * DUCK_PRICE) + (deerCount * DEER_PRICE) + (bearCount * BEAR_PRICE) + (hareCount * HARE_PRICE);
            
            GivePlayerMoney(playerid, total);
            
            DeletePVar(playerid, "P_DUCK");
            DeletePVar(playerid, "P_DEER");
            DeletePVar(playerid, "P_BEAR");
            DeletePVar(playerid, "P_HARE");
            
            new msg[128];
            format(msg, sizeof(msg), "Вы продали всю добычу за %d рублей!", total);
            SendClientMessage(playerid, -1, msg);
        }
        return 1;
    }
    
    if(dialogid == DIALOG_OXOTA_BAIT)
    {
        if(response)
        {
            new playerMoney = GetPlayerMoney(playerid);
            new price = 0;
            
            switch(listitem)
            {
                case 0: price = 50;
                case 1: price = 100;
                case 2: price = 200;
            }
            
            if(playerMoney < price)
            {
                SendClientMessage(playerid, -1, "У вас недостаточно денег!");
                return 1;
            }
            
            GivePlayerMoney(playerid, -price);
            PlayerBait[playerid]++;
            
            new msg[128];
            format(msg, sizeof(msg), "Вы купили приманку за %d рублей! Теперь у вас %d приманок.", price, PlayerBait[playerid]);
            SendClientMessage(playerid, -1, msg);
            
         
        }
        else
        {
            Dialog_OxotaMenu(playerid);
        }
        return 1;
    }
    
    #if defined oxota_OnDialogResponse
        return oxota_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif

#define OnDialogResponse oxota_OnDialogResponse

#if defined oxota_OnDialogResponse
    forward oxota_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    if(PlayerInOxotaMode[playerid] && weaponid == 33)
    {
        if(hittype == BULLET_HIT_TYPE_OBJECT)
        {
            for(new i = 0; i < MAX_ANIMALS; i++)
            {
                if(AnimalData[playerid][i][animalIsActive] && AnimalData[playerid][i][animalAlive])
                {
                    if(AnimalData[playerid][i][animalObjectID] == hitid)
                    {
                        KillAnimal(playerid, i);
                        return 1;
                    }
                }
            }
            
            SendClientMessage(playerid, -1, "Промах! Вы попали не в животное.");
        }
        else if(hittype == BULLET_HIT_TYPE_NONE)
        {
            
        }
        
        return 1;
    }
    
    #if defined oxota_OnPlayerWeaponShot
        return oxota_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, fX, fY, fZ);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerWeaponShot
    #undef OnPlayerWeaponShot
#else
    #define _ALS_OnPlayerWeaponShot
#endif

#define OnPlayerWeaponShot oxota_OnPlayerWeaponShot

#if defined oxota_OnPlayerWeaponShot
    forward oxota_OnPlayerWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ);
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == vz_actor_oxota)
    {
        ShowClientNotification(playerid, 4, 6, OXOTA_OFFER, 0, "Взаимодействовать", ">>");
    }
    
    for(new i = 0; i < MAX_BAIT_SPOTS; i++)
    {
        if(BaitData[i][baitAreaID] == areaid && BaitData[i][baitActive])
        {
            ShowClientNotification(playerid, 4, 6, OXOTA_OFFER_PRIMANKA, 0, "Взаимодействовать", ">>");
            break;
        }
    }
    
    if(PlayerInOxotaMode[playerid])
    {
        new animalid = -1;
        if(FindAnimalByAreaID(playerid, areaid, animalid))
        {
            if(animalid >= 0 && animalid < MAX_ANIMALS)
            {
                if(AnimalData[playerid][animalid][animalDead] && !AnimalData[playerid][animalid][animalCollected])
                {
                    SetPVarInt(playerid, "CurrentAnimalArea", areaid);
                    
                    new animalName[32];
                    animalName = GetAnimalName(AnimalData[playerid][animalid][animalModel]);
                    
                    ShowClientNotification(playerid, 4, 6, OXOTA_OFFER_TAKE, 0, "Взаимодействовать", ">>");
                }
            }
        }
    }
    
    #if defined oxota_OnPlayerEnterDynamicArea
        return oxota_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif

#define OnPlayerEnterDynamicArea oxota_OnPlayerEnterDynamicArea

#if defined oxota_OnPlayerEnterDynamicArea
    forward oxota_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    if(GetPVarInt(playerid, "CurrentAnimalArea") == areaid)
    {
        DeletePVar(playerid, "CurrentAnimalArea");
    }
    
    #if defined oxota_OnPlayerLeaveDynamicArea
        return oxota_OnPlayerLeaveDynamicArea(playerid, areaid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerLeaveDynamicArea
    #undef OnPlayerLeaveDynamicArea
#else
    #define _ALS_OnPlayerLeaveDynamicArea
#endif

#define OnPlayerLeaveDynamicArea oxota_OnPlayerLeaveDynamicArea

#if defined oxota_OnPlayerLeaveDynamicArea
    forward oxota_OnPlayerLeaveDynamicArea(playerid, areaid);
#endif

public OnPlayerConnect(playerid)
{
    InitPlayerAnimals(playerid);
    
    SetPVarInt(playerid, "P_DUCK", 0);
    SetPVarInt(playerid, "P_DEER", 0);
    SetPVarInt(playerid, "P_BEAR", 0);
    SetPVarInt(playerid, "P_HARE", 0);
    
    PlayerInOxotaMode[playerid] = false;
    PlayerOxotaTimer[playerid] = -1;
    PlayerBait[playerid] = 0;
    BaitUsed[playerid] = false;
    PlayerSkinBeforeOxota[playerid] = -1;
    
    #if defined oxota_OnPlayerConnect
        return oxota_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif

#define OnPlayerConnect oxota_OnPlayerConnect

#if defined oxota_OnPlayerConnect
    forward oxota_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(PlayerOxotaTimer[playerid] != -1)
    {
        KillTimer(PlayerOxotaTimer[playerid]);
        PlayerOxotaTimer[playerid] = -1;
    }
    DestroyActorForPlayer(playerid);
    DestroyPlayerAnimals(playerid);
    
    for(new i = 0; i < MAX_BAIT_SPOTS; i++)
    {
        if(BaitData[i][playerUsingBaitID] == playerid)
        {
            if(BaitData[i][baitTimerID] != -1)
            {
                KillTimer(BaitData[i][baitTimerID]);
            }
            BaitData[i][playerUsingBaitID] = INVALID_PLAYER_ID;
            BaitData[i][baitTimerID] = -1;
            BaitData[i][baitAnimalID] = -1;
        }
    }
    
    DeletePVar(playerid, "P_DUCK");
    DeletePVar(playerid, "P_DEER");
    DeletePVar(playerid, "P_BEAR");
    DeletePVar(playerid, "P_HARE");
    DeletePVar(playerid, "OldVW");
    DeletePVar(playerid, "OldInt");
    DeletePVar(playerid, "CurrentAnimalArea");
    
    PlayerInOxotaMode[playerid] = false;
    PlayerBait[playerid] = 0;
    BaitUsed[playerid] = false;
    PlayerSkinBeforeOxota[playerid] = -1;
    
    #if defined oxota_OnPlayerDisconnect
        return oxota_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif

#define OnPlayerDisconnect oxota_OnPlayerDisconnect

#if defined oxota_OnPlayerDisconnect
    forward oxota_OnPlayerDisconnect(playerid, reason);
#endif

public OnGameModeInit()
{
    print("[ОХОТА by Vveez] Система охоты загружена");
    Create3DTextLabel("Михалыч", -1, 2128.786621, 489.371185, 13.330902, 5.0);
    actor_oxota = CreateActor(58, 2128.786621, 489.371185, 13.330902, 191.729736);
    vz_actor_oxota = CreateDynamicSphere(2128.786621, 489.371185, 13.330902, 2.0);
    
    InitBaitSpots();
    
    #if defined oxota_OnGameModeInit
        return oxota_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif

#define OnGameModeInit oxota_OnGameModeInit

#if defined oxota_OnGameModeInit
    forward oxota_OnGameModeInit();
#endif






stock CreateActorForPlayer(playerid, skinid, Float:posx, Float:posy, Float:posz, Float:rot, name[] = "", text[] = "")
{
    new actorid = CreateActor(skinid, posx, posy, posz, rot);
    
    if(actorid != INVALID_ACTOR_ID)
    {
        new vw = playerid + 100;
        SetActorVirtualWorld(actorid, vw);
        SetActorInvulnerable(actorid, 1);
        
        actor_oxota_v[playerid] = actorid;
        
        if(strlen(name) || strlen(text))
        {
            new string[144];
            format(string, sizeof(string), "{FFFFFF}%s\n%s", name, text);
            CreateDynamic3DTextLabel(string, 0xFFFF00AA, posx, posy, posz+1.2, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, vw, 0);
        }
        
        return actorid;
    }
    return INVALID_ACTOR_ID;
}

stock DestroyActorForPlayer(playerid)
{
    if(actor_oxota_v[playerid] != INVALID_ACTOR_ID)
    {
        DestroyActor(actor_oxota_v[playerid]);
        actor_oxota_v[playerid] = INVALID_ACTOR_ID;
    }
}