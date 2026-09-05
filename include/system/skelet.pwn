// =====================================================================
//  Модуль "/skelet" — ПРИВАТНАЯ версия (видно только тому, кто включил)
//  SA-MP 0.3.7
//
//  Отличие от публичной версии: вместо SetPlayerAttachedObject (который
//  виден ВСЕМ игрокам) используются CreatePlayerObject +
//  AttachPlayerObjectToPlayer — такие объекты видит только тот игрок,
//  для которого они созданы.
//
//  ВАЖНО: приватные объекты крепятся к базовой точке/повороту игрока
//  со смещением, а не к конкретной кости скелета (SA-MP этого не умеет
//  для приватных объектов). Поэтому точки — это ПРИБЛИЗИТЕЛЬНОЕ
//  положение головы/плеч/рук/ног, а не точный skeletal-риг. При
//  приседе/плавании/руле и т.п. точки будут немного "плыть".
//  Трасса пули на это не влияет — она считается по реальным
//  координатам выстрела и всегда точная.
// =====================================================================

#define SKLT_ADMIN_LEVEL            2      // минимальный уровень админа для команды
#define SKLT_POINT_MARKER_MODEL     1241   // модель маркера точки скелета
#define SKLT_BULLET_MARKER_MODEL    1241   // модель маркера точки трассы пули
#define SKLT_POINT_COUNT            8      // количество приблизительных точек тела
#define SKLT_TRACE_POINTS           8      // точек на линии выстрела
#define SKLT_TRACE_LIFETIME         2000   // мс жизни точки трассы
#define SKLT_MAX_TRACE_OBJECTS      100    // запас одновременных точек трассы (на всех вьюеров)

// Приблизительные смещения точек тела относительно базовой позиции
// игрока (X - вперёд, Y - вбок, Z - вверх). Подбирались "на глаз" под
// стандартный рост CJ-скина, при желании подкорректируй под свой сервер.
new Float:Sklt_OffX[SKLT_POINT_COUNT] = { 0.00,  0.00,  0.00, -0.22,  0.22, -0.30,  0.30,  0.00 };
new Float:Sklt_OffY[SKLT_POINT_COUNT] = { 0.00,  0.00,  0.00,  0.00,  0.00,  0.10,  0.10,  0.00 };
new Float:Sklt_OffZ[SKLT_POINT_COUNT] = { 1.55,  1.15,  0.60,  1.35,  1.35,  0.95,  0.95,  0.05 };
// точки:  голова грудь  пояс  плечоЛ плечоП кистьЛ кистьП стопы(средняя)

new Sklt_Watching[MAX_PLAYERS];         // кого смотрит этот игрок (viewer -> target), INVALID_PLAYER_ID если никого
new Sklt_Viewer[MAX_PLAYERS];           // кто смотрит на этого игрока (target -> viewer), INVALID_PLAYER_ID если никто
new Sklt_MarkerObj[MAX_PLAYERS][SKLT_POINT_COUNT]; // player-object'ы, принадлежат VIEWER'у

new Sklt_TraceOwner[SKLT_MAX_TRACE_OBJECTS];       // кому принадлежит объект трассы (viewerid)
new Sklt_TraceObjectID[SKLT_MAX_TRACE_OBJECTS];
new Sklt_TraceExpireTime[SKLT_MAX_TRACE_OBJECTS];
new Sklt_TraceCount = 0;

// ---------------------------------------------------------------------
//  КОМАНДА /skelet [id]
// ---------------------------------------------------------------------
CMD:skelet(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < SKLT_ADMIN_LEVEL)
        return ShowNotification(playerid, 2, "У вас нет доступа к этой команде", 4, "", "");

    new targetid;
    if(sscanf(params, "u", targetid))
        targetid = playerid; // без аргумента — показать себя

    if(targetid == INVALID_PLAYER_ID || !IsPlayerConnected(targetid))
        return ShowNotification(playerid, 2, "Игрок не найден", 4, "", "");

    if(Sklt_Watching[playerid] == targetid)
    {
        // уже смотрим именно на этого — выключаем
        Sklt_RemoveSkeleton(playerid);
        ShowNotification(playerid, 3, "Отображение скелета выключено", 3, "", "");
    }
    else
    {
        if(Sklt_Watching[playerid] != INVALID_PLAYER_ID)
        {
            // смотрели на другого — сначала снимаем старые маркеры
            Sklt_RemoveSkeleton(playerid);
        }
        Sklt_ShowSkeleton(playerid, targetid);
        ShowNotification(playerid, 1, "Отображение скелета включено (видно только вам)", 4, "", "");
    }
    return 1;
}

// ---------------------------------------------------------------------
//  viewerid — кто увидит маркеры, targetid — за кем наблюдаем
// ---------------------------------------------------------------------
Sklt_ShowSkeleton(viewerid, targetid)
{
    for(new i = 0; i < SKLT_POINT_COUNT; i++)
    {
        new objectid = CreatePlayerObject(viewerid, SKLT_POINT_MARKER_MODEL, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        AttachPlayerObjectToPlayer(viewerid, objectid, targetid, Sklt_OffX[i], Sklt_OffY[i], Sklt_OffZ[i], 0.0, 0.0, 0.0);
        Sklt_MarkerObj[viewerid][i] = objectid;
    }
    Sklt_Watching[viewerid] = targetid;
    Sklt_Viewer[targetid] = viewerid;
    return 1;
}

Sklt_RemoveSkeleton(viewerid)
{
    for(new i = 0; i < SKLT_POINT_COUNT; i++)
    {
        DestroyPlayerObject(viewerid, Sklt_MarkerObj[viewerid][i]);
        Sklt_MarkerObj[viewerid][i] = -1;
    }

    new targetid = Sklt_Watching[viewerid];
    if(targetid != INVALID_PLAYER_ID)
        Sklt_Viewer[targetid] = INVALID_PLAYER_ID;

    Sklt_Watching[viewerid] = INVALID_PLAYER_ID;
    return 1;
}

// Вызывается из существующего OnPlayerDisconnect(playerid, reason)
Sklt_OnPlayerDisconnect(playerid)
{
    // если этот игрок сам за кем-то смотрел — снимаем его маркеры
    if(Sklt_Watching[playerid] != INVALID_PLAYER_ID)
        Sklt_RemoveSkeleton(playerid);

    // если за ЭТИМ игроком кто-то смотрел (он был целью) — выключаем у наблюдателя
    if(Sklt_Viewer[playerid] != INVALID_PLAYER_ID)
    {
        new viewerid = Sklt_Viewer[playerid];
        Sklt_RemoveSkeleton(viewerid);
    }

    // чистим "зависшие" объекты трассы, принадлежавшие отключившемуся
    new i = 0;
    while(i < Sklt_TraceCount)
    {
        if(Sklt_TraceOwner[i] == playerid)
        {
            Sklt_TraceCount--;
            Sklt_TraceOwner[i] = Sklt_TraceOwner[Sklt_TraceCount];
            Sklt_TraceObjectID[i] = Sklt_TraceObjectID[Sklt_TraceCount];
            Sklt_TraceExpireTime[i] = Sklt_TraceExpireTime[Sklt_TraceCount];
        }
        else
        {
            i++;
        }
    }
    return 1;
}

// ---------------------------------------------------------------------
//  ТРАЕКТОРИЯ ПУЛЬ (приватная — видна только наблюдателю за стрелком)
// ---------------------------------------------------------------------
// Вызывается из существующего OnPlayerWeaponShot(...) ДО любых ранних return
Sklt_OnWeaponShot(playerid, weaponid, hittype, hitid, Float:fX, Float:fY, Float:fZ)
{
    #pragma unused weaponid, hittype, hitid

    new viewerid = Sklt_Viewer[playerid];
    if(viewerid == INVALID_PLAYER_ID) return 1; // за стрелком никто не наблюдает — трассу не рисуем

    new Float:oX, Float:oY, Float:oZ;
    if(GetPlayerLastShotVectors(playerid, oX, oY, oZ, fX, fY, fZ))
    {
        Sklt_ShowBulletTrajectory(viewerid, oX, oY, oZ, fX, fY, fZ);
    }
    return 1;
}

Sklt_ShowBulletTrajectory(viewerid, Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    new Float:stepX = (x2 - x1) / SKLT_TRACE_POINTS;
    new Float:stepY = (y2 - y1) / SKLT_TRACE_POINTS;
    new Float:stepZ = (z2 - z1) / SKLT_TRACE_POINTS;

    for(new i = 1; i < SKLT_TRACE_POINTS; i++)
    {
        new Float:px = x1 + stepX * i;
        new Float:py = y1 + stepY * i;
        new Float:pz = z1 + stepZ * i;

        new objectid = CreatePlayerObject(viewerid, SKLT_BULLET_MARKER_MODEL, px, py, pz, 0.0, 0.0, 0.0);
        SetPlayerObjectMaterial(viewerid, objectid, 0, -1, "none", "none", 0xFFFF0000);

        if(Sklt_TraceCount < SKLT_MAX_TRACE_OBJECTS)
        {
            Sklt_TraceOwner[Sklt_TraceCount] = viewerid;
            Sklt_TraceObjectID[Sklt_TraceCount] = objectid;
            Sklt_TraceExpireTime[Sklt_TraceCount] = GetTickCount() + SKLT_TRACE_LIFETIME;
            Sklt_TraceCount++;
        }
        else
        {
            DestroyPlayerObject(viewerid, objectid); // лимит превышен, чистим сразу
        }
    }
    return 1;
}

// Вызывается один раз из существующего OnGameModeInit()
Sklt_OnGameModeInit()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        Sklt_Watching[i] = INVALID_PLAYER_ID;
        Sklt_Viewer[i] = INVALID_PLAYER_ID;
    }
    SetTimer("Sklt_CleanupTrace", 250, true);
    return 1;
}

forward Sklt_CleanupTrace();
public Sklt_CleanupTrace()
{
    new now = GetTickCount();
    new i = 0;
    while(i < Sklt_TraceCount)
    {
        if(now >= Sklt_TraceExpireTime[i])
        {
            DestroyPlayerObject(Sklt_TraceOwner[i], Sklt_TraceObjectID[i]);
            Sklt_TraceCount--;
            Sklt_TraceOwner[i] = Sklt_TraceOwner[Sklt_TraceCount];
            Sklt_TraceObjectID[i] = Sklt_TraceObjectID[Sklt_TraceCount];
            Sklt_TraceExpireTime[i] = Sklt_TraceExpireTime[Sklt_TraceCount];
        }
        else
        {
            i++;
        }
    }
    return 1;
}
