#if defined _arenda_inc
    #endinput
#endif
#define _arenda_inc

#define MAX_RENT_PLACES 50
#define DIALOG_RENT_MENU 5001

new TotalRentPlaces = 0;

enum eRentPlace
{
    Float:rX,
    Float:rY,
    Float:rZ,
    rPickup,
    rText
}
new RentPlaces[MAX_RENT_PLACES][eRentPlace];

static const Float:g_RentLocations[][3] = {
    {-2878.2856, 2288.6948, 9.5567},
    {2746.3400, -2420.7482, 21.7118},
    {853.3813, 829.3994, 13.3411},
    {-2453.8735, 193.5862, 26.0844},
    {-2171.7636, 1580.1262, 9.7821},
    {-2601.0280, 2011.7322, 9.5422}
};

stock LoadRentLocations()
{
    new count = 0;
    for(new i = 0; i < sizeof(g_RentLocations); i++)
    {
        if(TotalRentPlaces >= MAX_RENT_PLACES) break;
        new id = TotalRentPlaces;
        RentPlaces[id][rX] = g_RentLocations[i][0];
        RentPlaces[id][rY] = g_RentLocations[i][1];
        RentPlaces[id][rZ] = g_RentLocations[i][2];
        RentPlaces[id][rPickup] = CreateDynamicPickup(19131, 23,
            g_RentLocations[i][0], g_RentLocations[i][1], g_RentLocations[i][2],
            0, 0, -1, 100.0);
        RentPlaces[id][rText] = CreateDynamic3DTextLabel(
            "{FFFF00}Управление транспортного средства\n[Подойдите для взаимодействия]",
            -1,
            g_RentLocations[i][0], g_RentLocations[i][1], g_RentLocations[i][2] + 0.5,
            200.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0, -1, -1, 100.0);
        TotalRentPlaces++;
        count++;
    }
    printf("[ARENDA] Создано точек аренды: %d", count);
    return count;
}

public OnPlayerPickUpDynamicPickup(playerid, pickupid)
{
    for(new i = 0; i < TotalRentPlaces; i++)
    {
        if(pickupid == RentPlaces[i][rPickup])
        {
            if(GetPVarInt(playerid, "PickupDelay") > gettime()) return 1;
            SetPVarInt(playerid, "PickupDelay", gettime() + 5);
            ShowPlayerRentMenu(playerid);
            return 1;
        }
    }
    return 1;
}

stock ShowPlayerRentMenu(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_RENT_MENU, DIALOG_STYLE_LIST,
        "{87CEEB}Управление транспортом",
        "1. Арендовать скутер (бесплатно)\n2. Вызвать личный автомобиль",
        "Выбрать", "Закрыть");
}

stock HandleRentDialog(playerid, dialogid, response, listitem)
{
    if(dialogid != DIALOG_RENT_MENU || !response) return 0;
    new Float:x, Float:y, Float:z, vehicleid;
    GetPlayerPos(playerid, x, y, z);
    switch(listitem)
    {
        case 0:
        {
            vehicleid = CreateVehicle(462, x + 2, y + 2, z, 0.0, -1, -1, -1);
            if(vehicleid)
            {
                PutPlayerInVehicle(playerid, vehicleid, 0);
                SendClientMessage(playerid, -1, "{00FF00}Вы арендовали скутер!");
            }
        }
        case 1:
        {
            vehicleid = CreateVehicle(560, x + 3, y + 3, z, 0.0, -1, -1, -1);
            if(vehicleid)
            {
                PutPlayerInVehicle(playerid, vehicleid, 0);
                SendClientMessage(playerid, -1, "{00FF00}Ваш личный автомобиль вызван!");
            }
        }
    }
    return 1;
}

///изи код by nova