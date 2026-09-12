/*
    ===============================================
    Простая система маппинга для SA-MP / CRMP
    Команды: /map /editmap /delmap /savemap
    Версия для подключения через #include в гейммод
    ===============================================
*/

#define MAX_MAP_OBJECTS     1000
#define MAP_EDIT_DISTANCE   15.0

enum e_MapObjectData
{
    mapObjectID,
    mapObjectModel,
    Float:mapObjectX,
    Float:mapObjectY,
    Float:mapObjectZ,
    Float:mapObjectRX,
    Float:mapObjectRY,
    Float:mapObjectRZ
}

new MapObjects[MAX_MAP_OBJECTS][e_MapObjectData];
new MapObjectCount = 0;

new bool:PlayerEditingMap[MAX_PLAYERS];
new PlayerEditIndex[MAX_PLAYERS];

forward LoadMapObjects();
forward FindNearestMapObject(playerid, &Float:outDist);

public OnPlayerConnect(playerid)
{
    PlayerEditingMap[playerid] = false;
    PlayerEditIndex[playerid] = -1;

    #if defined m_OnPlayerConnect
        return m_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect m_OnPlayerConnect
#if defined m_OnPlayerConnect
    forward m_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    PlayerEditingMap[playerid] = false;
    PlayerEditIndex[playerid] = -1;

    #if defined m_OnPlayerDisconnect
        return m_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect m_OnPlayerDisconnect
#if defined m_OnPlayerDisconnect
    forward m_OnPlayerDisconnect(playerid, reason);
#endif

public OnGameModeInit()
{
    print("[MAP SYSTEM] Загрузка системы маппинга...");
    LoadMapObjects();

    #if defined m_OnGameModeInit
        return m_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit m_OnGameModeInit
#if defined m_OnGameModeInit
    forward m_OnGameModeInit();
#endif

public OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    if(PlayerEditingMap[playerid])
    {
        new index = PlayerEditIndex[playerid];

        if(response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_UPDATE)
        {
            MapObjects[index][mapObjectX] = x;
            MapObjects[index][mapObjectY] = y;
            MapObjects[index][mapObjectZ] = z;
            MapObjects[index][mapObjectRX] = rx;
            MapObjects[index][mapObjectRY] = ry;
            MapObjects[index][mapObjectRZ] = rz;
        }

        if(response == EDIT_RESPONSE_FINAL)
        {
            PlayerEditingMap[playerid] = false;
            PlayerEditIndex[playerid] = -1;
            SendClientMessage(playerid, -1, "{00FF00}Редактирование завершено. Не забудьте {FFFF00}/savemap");
        }

        if(response == EDIT_RESPONSE_CANCEL)
        {
            PlayerEditingMap[playerid] = false;
            PlayerEditIndex[playerid] = -1;
            SendClientMessage(playerid, -1, "{FFFF00}Редактирование отменено.");
        }
    }

    #if defined m_OnPlayerEditDynamicObject
        return m_OnPlayerEditDynamicObject(playerid, objectid, response, x, y, z, rx, ry, rz);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerEditDynamicObject
    #undef OnPlayerEditDynamicObject
#else
    #define _ALS_OnPlayerEditDynamicObject
#endif
#define OnPlayerEditDynamicObject m_OnPlayerEditDynamicObject
#if defined m_OnPlayerEditDynamicObject
    forward m_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
#endif


CMD:map(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}у вас нет доступа к этой команде.");
        return 1;
    }

    new modelid;

    if(sscanf(params, "d", modelid))
    {
        SendClientMessage(playerid, -1, "{FFFF00}Использование: {FFFFFF}/map [ID модели]");
        return 1;
    }

    if(MapObjectCount >= MAX_MAP_OBJECTS)
    {
        SendClientMessage(playerid, -1, "{FF0000}Достигнут лимит объектов карты (1000).");
        return 1;
    }

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    new index = MapObjectCount;

    MapObjects[index][mapObjectModel] = modelid;
    MapObjects[index][mapObjectX] = x;
    MapObjects[index][mapObjectY] = y;
    MapObjects[index][mapObjectZ] = z;
    MapObjects[index][mapObjectRX] = 0.0;
    MapObjects[index][mapObjectRY] = 0.0;
    MapObjects[index][mapObjectRZ] = 0.0;
    MapObjects[index][mapObjectID] = CreateDynamicObject(modelid, x, y, z, 0.0, 0.0, 0.0, -1, -1, -1, 300.0, 300.0);

    MapObjectCount++;

    new text[96];
    format(text, sizeof text, "{00FF00}Объект создан. {FFFFFF}ID модели: {FFFF00}%d {FFFFFF}| Всего объектов: {FFFF00}%d", modelid, MapObjectCount);
    SendClientMessage(playerid, -1, text);

    return 1;
}

CMD:editmap(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}у вас нет доступа к этой команде.");
        return 1;
    }

    new Float:dist;
    new index = FindNearestMapObject(playerid, dist);

    if(index == -1 || dist > MAP_EDIT_DISTANCE)
    {
        SendClientMessage(playerid, -1, "{FF0000}Рядом нет объектов карты для редактирования.");
        return 1;
    }

    PlayerEditingMap[playerid] = true;
    PlayerEditIndex[playerid] = index;

    EditDynamicObject(playerid, MapObjects[index][mapObjectID]);

    SendClientMessage(playerid, -1, "{00FF00}Редактирование объекта начато.");

    return 1;
}

CMD:delmap(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}у вас нет доступа к этой команде.");
        return 1;
    }

    new Float:dist;
    new index = FindNearestMapObject(playerid, dist);

    if(index == -1 || dist > MAP_EDIT_DISTANCE)
    {
        SendClientMessage(playerid, -1, "{FF0000}Рядом нет объектов карты для удаления.");
        return 1;
    }

    DestroyDynamicObject(MapObjects[index][mapObjectID]);

    for(new i = index; i < MapObjectCount - 1; i++)
    {
        MapObjects[i] = MapObjects[i + 1];
    }

    MapObjectCount--;

    SendClientMessage(playerid, -1, "{00FF00}Объект удалён.");

    return 1;
}

CMD:savemap(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}у вас нет доступа к этой команде.");
        return 1;
    }

    new File:file = fopen("maps.txt", io_write);

    if(!file)
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: {FFFFFF}не удалось открыть файл для записи.");
        return 1;
    }

    new mapFileLine[128];

    for(new i = 0; i < MapObjectCount; i++)
    {
        format(mapFileLine, sizeof mapFileLine, "%d %f %f %f %f %f %f\r\n",
            MapObjects[i][mapObjectModel],
            MapObjects[i][mapObjectX],
            MapObjects[i][mapObjectY],
            MapObjects[i][mapObjectZ],
            MapObjects[i][mapObjectRX],
            MapObjects[i][mapObjectRY],
            MapObjects[i][mapObjectRZ]
        );
        fwrite(file, mapFileLine);
    }

    fclose(file);

    new text[64];
    format(text, sizeof text, "{00FF00}Сохранено объектов: {FFFF00}%d {FFFFFF}(scriptfiles/maps.txt)", MapObjectCount);
    SendClientMessage(playerid, -1, text);

    return 1;
}

stock FindNearestMapObject(playerid, &Float:outDist)
{
    new Float:px, Float:py, Float:pz;
    GetPlayerPos(playerid, px, py, pz);

    new nearest = -1;
    new Float:nearestDist = 999999.0;

    for(new i = 0; i < MapObjectCount; i++)
    {
        new Float:d = VectorSize(MapObjects[i][mapObjectX] - px, MapObjects[i][mapObjectY] - py, MapObjects[i][mapObjectZ] - pz);

        if(d < nearestDist)
        {
            nearestDist = d;
            nearest = i;
        }
    }

    outDist = nearestDist;

    return nearest;
}

stock LoadMapObjects()
{
    new File:file = fopen("maps.txt", io_read);

    if(!file)
    {
        print("[MAP SYSTEM] Файл maps.txt не найден, загрузка объектов пропущена.");
        return 0;
    }

    new mapFileLine[128];
    new modelid;
    new Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz;

    while(fread(file, mapFileLine))
    {
        if(sscanf(mapFileLine, "dffffff", modelid, x, y, z, rx, ry, rz)) continue;

        if(MapObjectCount >= MAX_MAP_OBJECTS) break;

        new index = MapObjectCount;

        MapObjects[index][mapObjectModel] = modelid;
        MapObjects[index][mapObjectX] = x;
        MapObjects[index][mapObjectY] = y;
        MapObjects[index][mapObjectZ] = z;
        MapObjects[index][mapObjectRX] = rx;
        MapObjects[index][mapObjectRY] = ry;
        MapObjects[index][mapObjectRZ] = rz;
        MapObjects[index][mapObjectID] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, -1, -1, -1, 300.0, 300.0);

        MapObjectCount++;
    }

    fclose(file);

    new text[64];
    format(text, sizeof text, "[MAP SYSTEM] Загружено объектов: %d", MapObjectCount);
    print(text);

    return 1;
}
