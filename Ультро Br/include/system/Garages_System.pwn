#include <a_samp>
#include <a_mysql>

#define MAX_GARAGES             500
#define GARAGE_INTERIOR         1
#define GARAGE_WORLD_BASE       5000

// Подставь свой MySQL handle
new MySQL:g_SQL;

enum E_GARAGE
{
    gID,
    gOwner[MAX_PLAYER_NAME + 1],
    gPrice,
    Float:gX,
    Float:gY,
    Float:gZ,
    Float:gA,
    gInterior,
    gWorld,
    gVehicle[4],
    gPickup,
    gLabel
};

new Garage[MAX_GARAGES][E_GARAGE];

new PlayerGarage[MAX_PLAYERS];

forward Garage_Load();
forward Garage_LoadData();
forward Garage_Save(id);

stock Garage_Reset(id)
{
    Garage[id][gID] = 0;
    Garage[id][gOwner][0] = EOS;
    Garage[id][gPrice] = 500000;

    Garage[id][gX] = 0.0;
    Garage[id][gY] = 0.0;
    Garage[id][gZ] = 0.0;
    Garage[id][gA] = 0.0;

    Garage[id][gInterior] = 0;
    Garage[id][gWorld] = 0;

    for(new i = 0; i < 4; i++)
        Garage[id][gVehicle][i] = 0;

    Garage[id][gPickup] = -1;
    Garage[id][gLabel] = -1;

    return 1;
}

stock Garage_Create(id)
{
    if(id < 0 || id >= MAX_GARAGES)
        return 0;

    new text[256];

    if(Garage[id][gOwner][0] == EOS)
    {
        format(text, sizeof(text),
            "{FFFFFF}Гараж №%d\n{00FF00}Цена: $%d\n{FFFFFF}Свободен\n\nНажмите ALT",
            Garage[id][gID],
            Garage[id][gPrice]
        );
    }
    else
    {
        format(text, sizeof(text),
            "{FFFFFF}Гараж №%d\n{FFCC00}Владелец: %s\n\n{FFFFFF}Нажмите ALT",
            Garage[id][gID],
            Garage[id][gOwner]
        );
    }

    Garage[id][gPickup] = CreateDynamicPickup(
        1273,
        1,
        Garage[id][gX],
        Garage[id][gY],
        Garage[id][gZ],
        0,
        0
    );

    Garage[id][gLabel] = CreateDynamic3DTextLabel(
        text,
        -1,
        Garage[id][gX],
        Garage[id][gY],
        Garage[id][gZ] + 1.0,
        15.0,
        INVALID_PLAYER_ID,
        INVALID_VEHICLE_ID,
        0,
        0,
        0,
        -1,
        100.0
    );

    return 1;
}

public Garage_Load()
{
    for(new i = 0; i < MAX_GARAGES; i++)
        Garage_Reset(i);

    mysql_tquery(g_SQL,
        "SELECT * FROM `garages`",
        "Garage_LoadData"
    );

    return 1;
}

public Garage_LoadData()
{
    new rows = cache_num_rows();

    for(new i = 0; i < rows && i < MAX_GARAGES; i++)
    {
        cache_get_value_name_int(i, "id", Garage[i][gID]);
        cache_get_value_name(i, "owner", Garage[i][gOwner], MAX_PLAYER_NAME + 1);
        cache_get_value_name_int(i, "price", Garage[i][gPrice]);

        cache_get_value_name_float(i, "x", Garage[i][gX]);
        cache_get_value_name_float(i, "y", Garage[i][gY]);
        cache_get_value_name_float(i, "z", Garage[i][gZ]);
        cache_get_value_name_float(i, "a", Garage[i][gA]);

        cache_get_value_name_int(i, "interior", Garage[i][gInterior]);
        cache_get_value_name_int(i, "world", Garage[i][gWorld]);

        cache_get_value_name_int(i, "vehicle1", Garage[i][gVehicle][0]);
        cache_get_value_name_int(i, "vehicle2", Garage[i][gVehicle][1]);
        cache_get_value_name_int(i, "vehicle3", Garage[i][gVehicle][2]);
        cache_get_value_name_int(i, "vehicle4", Garage[i][gVehicle][3]);

        Garage_Create(i);
    }

    printf("[GARAGE] Загружено гаражей: %d", rows);
    return 1;
}

stock Garage_FindPlayer(playerid)
{
    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));

    for(new i = 0; i < MAX_GARAGES; i++)
    {
        if(Garage[i][gID] == 0)
            continue;

        if(!strcmp(Garage[i][gOwner], name, true))
            return i;
    }

    return -1;
}

stock Garage_Buy(playerid, garageid)
{
    if(garageid < 0 || garageid >= MAX_GARAGES)
        return 0;

    if(Garage[garageid][gOwner][0] != EOS)
    {
        SendClientMessage(playerid, -1, "Этот гараж уже занят.");
        return 0;
    }

    // ЗАМЕНИ на свою систему денег.
    if(GetPlayerMoney(playerid) < Garage[garageid][gPrice])
    {
        SendClientMessage(playerid, -1, "У вас недостаточно денег.");
        return 0;
    }

    GivePlayerMoney(playerid, -Garage[garageid][gPrice]);

    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));

    format(Garage[garageid][gOwner],
        MAX_PLAYER_NAME + 1,
        "%s",
        name
    );

    new query[256];

    mysql_format(
        g_SQL,
        query,
        sizeof(query),
        "UPDATE `garages` SET `owner`='%e' WHERE `id`=%d",
        name,
        Garage[garageid][gID]
    );

    mysql_tquery(g_SQL, query);

    SendClientMessage(playerid, 0x00FF00FF,
        "Поздравляем! Вы приобрели гараж."
    );

    return 1;
}

stock Garage_Enter(playerid, garageid)
{
    if(garageid < 0 || garageid >= MAX_GARAGES)
        return 0;

    if(Garage[garageid][gOwner][0] == EOS)
    {
        SendClientMessage(playerid, -1,
            "Этот гараж свободен. Используйте ALT для покупки."
        );
        return 0;
    }

    new name[MAX_PLAYER_NAME + 1];
    GetPlayerName(playerid, name, sizeof(name));

    if(strcmp(Garage[garageid][gOwner], name, true))
    {
        SendClientMessage(playerid, -1,
            "Этот гараж принадлежит другому игроку."
        );
        return 0;
    }

    SetPlayerInterior(playerid, GARAGE_INTERIOR);
    SetPlayerVirtualWorld(
        playerid,
        GARAGE_WORLD_BASE + Garage[garageid][gID]
    );

    // Точка внутри гаража.
    SetPlayerPos(playerid, 0.0, 0.0, 1000.0);
    SetPlayerFacingAngle(playerid, 0.0);

    PlayerGarage[playerid] = garageid;

    ShowPlayerDialog(
        playerid,
        5000,
        DIALOG_STYLE_LIST,
        "Гараж",
        "1. Мои автомобили\n2. Поставить автомобиль\n3. Забрать автомобиль\n4. Выйти из гаража",
        "Выбрать",
        "Закрыть"
    );

    return 1;
}

stock Garage_Exit(playerid)
{
    PlayerGarage[playerid] = -1;

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);

    // Здесь можно поставить координаты выхода в твоём моде.
    SetPlayerPos(playerid, 0.0, 0.0, 3.0);

    return 1;
}

public Garage_Save(id)
{
    if(id < 0 || id >= MAX_GARAGES)
        return 0;

    new query[512];

    mysql_format(
        g_SQL,
        query,
        sizeof(query),
        "UPDATE `garages` SET `owner`='%e', `vehicle1`=%d, `vehicle2`=%d, `vehicle3`=%d, `vehicle4`=%d WHERE `id`=%d",
        Garage[id][gOwner],
        Garage[id][gVehicle][0],
        Garage[id][gVehicle][1],
        Garage[id][gVehicle][2],
        Garage[id][gVehicle][3],
        Garage[id][gID]
    );

    mysql_tquery(g_SQL, query);

    return 1;
}

public OnGameModeInit()
{
    Garage_Load();
    return 1;
}

public OnPlayerConnect(playerid)
{
    PlayerGarage[playerid] = -1;
    return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
    PlayerGarage[playerid] = -1;
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_WALK)
    {
        for(new i = 0; i < MAX_GARAGES; i++)
        {
            if(Garage[i][gID] == 0)
                continue;

            if(IsPlayerInRangeOfPoint(
                playerid,
                3.0,
                Garage[i][gX],
                Garage[i][gY],
                Garage[i][gZ]
            ))
            {
                if(Garage[i][gOwner][0] == EOS)
                {
                    Garage_Buy(playerid, i);
                }
                else
                {
                    Garage_Enter(playerid, i);
                }

                break;
            }
        }
    }

    return 1;
}

public OnDialogResponse(
    playerid,
    dialogid,
    response,
    listitem,
    inputtext[]
)
{
    if(dialogid != 5000)
        return 0;

    if(!response)
        return 1;

    switch(listitem)
    {
        case 0:
        {
            SendClientMessage(playerid, -1,
                "Ваши автомобили находятся в гараже."
            );
        }

        case 1:
        {
            SendClientMessage(playerid, -1,
                "Поставьте автомобиль в гараж."
            );
        }

        case 2:
        {
            SendClientMessage(playerid, -1,
                "Выберите автомобиль для выдачи."
            );
        }

        case 3:
        {
            Garage_Exit(playerid);
        }
    }

    return 1;
}