#include <a_samp>

#define MAX_PVZ 5000
#define MAX_MASTER 5000

#define PVZ_FILE "pvz_data.ini"
#define MASTER_FILE "master_data.ini"

// PVZ
new PVZPickup[MAX_PVZ];
new Text3D:PVZLabel[MAX_PVZ];
new Float:PVZEnterX[MAX_PVZ];
new Float:PVZEnterY[MAX_PVZ];
new Float:PVZEnterZ[MAX_PVZ];
new Float:PVZExitX[MAX_PVZ];
new Float:PVZExitY[MAX_PVZ];
new Float:PVZExitZ[MAX_PVZ];
new PVZExitInterior[MAX_PVZ];
new PVZCount;

// MASTER
new MasterPickup[MAX_MASTER];
new Text3D:MasterLabel[MAX_MASTER];
new Float:MasterEnterX[MAX_MASTER];
new Float:MasterEnterY[MAX_MASTER];
new Float:MasterEnterZ[MAX_MASTER];
new Float:MasterExitX[MAX_MASTER];
new Float:MasterExitY[MAX_MASTER];
new Float:MasterExitZ[MAX_MASTER];
new MasterExitInterior[MAX_MASTER];
new MasterCount;

// Общие внутренние пикапы
new PVZInsidePickup;
new MasterInsidePickup;
new Text3D:PVZInsideLabel;
new Text3D:MasterInsideLabel;

// Запоминаем, откуда игрок вошёл
new PlayerPVZID[MAX_PLAYERS];
new PlayerMasterID[MAX_PLAYERS];
new PlayerPortalType[MAX_PLAYERS]; // 0 = нет, 1 = PVZ, 2 = MASTER

stock SavePVZData();
stock SaveMasterData();
stock LoadPVZData();
stock LoadMasterData();
stock ParsePortalLine(const line[], &Float:enterx, &Float:entery, &Float:enterz, &Float:exitx, &Float:exity, &Float:exitz, &exitint);

forward PVZ_Create(playerid);
forward PVZ_SetExit(playerid, id);
forward MASTER_Create(playerid);
forward MASTER_SetExit(playerid, id);

public OnFilterScriptInit()
{
    // Общий выходной пикап внутри PVZ
    PVZInsidePickup = CreatePickup(1318, 2, 2286.0, 1837.0, 1521.0);
    PVZInsideLabel = Create3DTextLabel(
        "Выход",
        0xFFFFFFFF,
        2286.0, 1837.0, 1521.8,
        20.0,
        0,
        1
    );

    // Общий выходной пикап внутри мастерской
    MasterInsidePickup = CreatePickup(1318, 2, 2509.3, 842.06, 1246.06);
    MasterInsideLabel = Create3DTextLabel(
        "Выход",
        0xFFFFFFFF,
        2509.3, 842.06, 1246.86,
        20.0,
        0,
        1
    );

    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        PlayerPVZID[i] = -1;
        PlayerMasterID[i] = -1;
        PlayerPortalType[i] = 0;
    }

    LoadPVZData();
    LoadMasterData();
    return 1;
}

public OnFilterScriptExit()
{
    SavePVZData();
    SaveMasterData();
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    PlayerPVZID[playerid] = -1;
    PlayerMasterID[playerid] = -1;
    PlayerPortalType[playerid] = 0;
    return 1;
}

public PVZ_Create(playerid)
{
    if(PVZCount >= MAX_PVZ)
        return SendClientMessage(playerid, -1, "Лимит PVZ достигнут."), 1;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    PVZEnterX[PVZCount] = x;
    PVZEnterY[PVZCount] = y;
    PVZEnterZ[PVZCount] = z;

    // По умолчанию вход ведёт внутрь PVZ
    PVZExitX[PVZCount] = 2286.0;
    PVZExitY[PVZCount] = 1837.0;
    PVZExitZ[PVZCount] = 1521.0;
    PVZExitInterior[PVZCount] = 1;

    PVZPickup[PVZCount] = CreatePickup(1318, 2, x, y, z);

    PVZLabel[PVZCount] = Create3DTextLabel(
        "Пункт выдачи заказов",
        0xFFFFFFFF,
        x, y, z + 0.8,
        20.0,
        0,
        1
    );

    new msg[64];
    format(msg, sizeof(msg), "PVZ создан. ID: %d", PVZCount);
    SendClientMessage(playerid, -1, msg);

    PVZCount++;
    SavePVZData();
    return 1;
}

public PVZ_SetExit(playerid, id)
{
    if(id < 0 || id >= PVZCount)
        return SendClientMessage(playerid, -1, "Неверный ID PVZ."), 1;

    GetPlayerPos(playerid, PVZEnterX[id], PVZEnterY[id], PVZEnterZ[id]);
    PVZExitInterior[id] = GetPlayerInterior(playerid);

    // ВАЖНО:
    // /bsetexitpospvz задаёт НАРУЖНУЮ точку возврата из внутреннего пикапа.
    // Поэтому здесь сохраняем текущую позицию как обратный выход.
    PVZExitX[id] = PVZEnterX[id];
    PVZExitY[id] = PVZEnterY[id];
    PVZExitZ[id] = PVZEnterZ[id];

    SendClientMessage(playerid, -1, "Точка возврата PVZ сохранена.");
    SavePVZData();
    return 1;
}

public MASTER_Create(playerid)
{
    if(MasterCount >= MAX_MASTER)
        return SendClientMessage(playerid, -1, "Лимит MASTER достигнут."), 1;

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    MasterEnterX[MasterCount] = x;
    MasterEnterY[MasterCount] = y;
    MasterEnterZ[MasterCount] = z;

    // По умолчанию вход ведёт внутрь мастерской
    MasterExitX[MasterCount] = 2509.3;
    MasterExitY[MasterCount] = 842.06;
    MasterExitZ[MasterCount] = 1246.06;
    MasterExitInterior[MasterCount] = 1;

    MasterPickup[MasterCount] = CreatePickup(1318, 2, x, y, z);

    MasterLabel[MasterCount] = Create3DTextLabel(
        "Мастерская",
        0xFFFFFFFF,
        x, y, z + 0.8,
        20.0,
        0,
        1
    );

    new msg[64];
    format(msg, sizeof(msg), "MASTER создан. ID: %d", MasterCount);
    SendClientMessage(playerid, -1, msg);

    MasterCount++;
    SaveMasterData();
    return 1;
}

public MASTER_SetExit(playerid, id)
{
    if(id < 0 || id >= MasterCount)
        return SendClientMessage(playerid, -1, "Неверный ID MASTER."), 1;

    GetPlayerPos(playerid, MasterEnterX[id], MasterEnterY[id], MasterEnterZ[id]);
    MasterExitInterior[id] = GetPlayerInterior(playerid);

    // /bsetexitposmaster задаёт НАРУЖНУЮ точку возврата
    MasterExitX[id] = MasterEnterX[id];
    MasterExitY[id] = MasterEnterY[id];
    MasterExitZ[id] = MasterEnterZ[id];

    SendClientMessage(playerid, -1, "Точка возврата MASTER сохранена.");
    SaveMasterData();
    return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
    // Вход в PVZ
    for(new i = 0; i < PVZCount; i++)
    {
        if(PVZPickup[i] == pickupid)
        {
            PlayerPVZID[playerid] = i;
            PlayerPortalType[playerid] = 1;

            SetPlayerInterior(playerid, 1);
            SetPlayerPos(playerid, 2286.0, 1837.0, 1521.0);
            return 1;
        }
    }

    // Выход из PVZ обратно
    if(pickupid == PVZInsidePickup)
    {
        new id = PlayerPVZID[playerid];
        if(id >= 0 && id < PVZCount)
        {
            SetPlayerInterior(playerid, PVZExitInterior[id]);
            SetPlayerPos(playerid, PVZExitX[id], PVZExitY[id], PVZExitZ[id]);
        }
        return 1;
    }

    // Вход в мастерскую
    for(new i = 0; i < MasterCount; i++)
    {
        if(MasterPickup[i] == pickupid)
        {
            PlayerMasterID[playerid] = i;
            PlayerPortalType[playerid] = 2;

            SetPlayerInterior(playerid, 1);
            SetPlayerPos(playerid, 2509.3, 842.06, 1246.06);
            return 1;
        }
    }

    // Выход из мастерской обратно
    if(pickupid == MasterInsidePickup)
    {
        new id = PlayerMasterID[playerid];
        if(id >= 0 && id < MasterCount)
        {
            SetPlayerInterior(playerid, MasterExitInterior[id]);
            SetPlayerPos(playerid, MasterExitX[id], MasterExitY[id], MasterExitZ[id]);
        }
        return 1;
    }

    return 1;
}

stock SavePVZData()
{
    new File:f = fopen(PVZ_FILE, io_write);
    if(!f) return 0;

    new line[256];
    format(line, sizeof(line), "%d\r\n", PVZCount);
    fwrite(f, line);

    for(new i = 0; i < PVZCount; i++)
    {
        format(line, sizeof(line), "%f|%f|%f|%f|%f|%f|%d\r\n",
            PVZEnterX[i], PVZEnterY[i], PVZEnterZ[i],
            PVZExitX[i], PVZExitY[i], PVZExitZ[i],
            PVZExitInterior[i]
        );
        fwrite(f, line);
    }

    fclose(f);
    return 1;
}

stock SaveMasterData()
{
    new File:f = fopen(MASTER_FILE, io_write);
    if(!f) return 0;

    new line[256];
    format(line, sizeof(line), "%d\r\n", MasterCount);
    fwrite(f, line);

    for(new i = 0; i < MasterCount; i++)
    {
        format(line, sizeof(line), "%f|%f|%f|%f|%f|%f|%d\r\n",
            MasterEnterX[i], MasterEnterY[i], MasterEnterZ[i],
            MasterExitX[i], MasterExitY[i], MasterExitZ[i],
            MasterExitInterior[i]
        );
        fwrite(f, line);
    }

    fclose(f);
    return 1;
}

stock LoadPVZData()
{
    if(!fexist(PVZ_FILE)) return 1;

    new File:f = fopen(PVZ_FILE, io_read);
    if(!f) return 0;

    new line[256];
    new idx = 0;

    if(!fread(f, line))
    {
        fclose(f);
        return 1;
    }

    PVZCount = strval(line);

    while(fread(f, line))
    {
        if(idx >= PVZCount || idx >= MAX_PVZ) break;

        if(!ParsePortalLine(line,
            PVZEnterX[idx], PVZEnterY[idx], PVZEnterZ[idx],
            PVZExitX[idx], PVZExitY[idx], PVZExitZ[idx],
            PVZExitInterior[idx]))
        {
            continue;
        }

        PVZPickup[idx] = CreatePickup(1318, 2, PVZEnterX[idx], PVZEnterY[idx], PVZEnterZ[idx]);

        PVZLabel[idx] = Create3DTextLabel(
            "Пункт выдачи заказов",
            0xFFFFFFFF,
            PVZEnterX[idx], PVZEnterY[idx], PVZEnterZ[idx] + 0.8,
            20.0,
            0,
            1
        );

        idx++;
    }

    PVZCount = idx;
    fclose(f);
    return 1;
}

stock LoadMasterData()
{
    if(!fexist(MASTER_FILE)) return 1;

    new File:f = fopen(MASTER_FILE, io_read);
    if(!f) return 0;

    new line[256];
    new idx = 0;

    if(!fread(f, line))
    {
        fclose(f);
        return 1;
    }

    MasterCount = strval(line);

    while(fread(f, line))
    {
        if(idx >= MasterCount || idx >= MAX_MASTER) break;

        if(!ParsePortalLine(line,
            MasterEnterX[idx], MasterEnterY[idx], MasterEnterZ[idx],
            MasterExitX[idx], MasterExitY[idx], MasterExitZ[idx],
            MasterExitInterior[idx]))
        {
            continue;
        }

        MasterPickup[idx] = CreatePickup(1318, 2, MasterEnterX[idx], MasterEnterY[idx], MasterEnterZ[idx]);

        MasterLabel[idx] = Create3DTextLabel(
            "Мастерская",
            0xFFFFFFFF,
            MasterEnterX[idx], MasterEnterY[idx], MasterEnterZ[idx] + 0.8,
            20.0,
            0,
            1
        );

        idx++;
    }

    MasterCount = idx;
    fclose(f);
    return 1;
}

stock ParsePortalLine(const line[], &Float:enterx, &Float:entery, &Float:enterz, &Float:exitx, &Float:exity, &Float:exitz, &exitint)
{
    new part = 0;
    new idx = 0;
    new buffer[7][32];

    for(new i = 0; i < sizeof(buffer); i++)
    {
        buffer[i][0] = '\0';
    }

    for(new i = 0, len = strlen(line); i < len; i++)
    {
        if(line[i] == '|' || line[i] == '\r' || line[i] == '\n')
        {
            buffer[part][idx] = '\0';
            part++;
            idx = 0;
            if(part >= 7) break;
            continue;
        }

        if(part < 7 && idx < 31)
        {
            buffer[part][idx++] = line[i];
        }
    }

    if(part < 6) return 0;

    enterx = floatstr(buffer[0]);
    entery = floatstr(buffer[1]);
    enterz = floatstr(buffer[2]);
    exitx  = floatstr(buffer[3]);
    exity  = floatstr(buffer[4]);
    exitz  = floatstr(buffer[5]);
    exitint = strval(buffer[6]);
    return 1;
}
