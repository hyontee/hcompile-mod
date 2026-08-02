#if defined _car_manager_included
    #endinput
#endif
#define _car_manager_included

// === НАСТРОЙКИ ===
#if !defined MAX_PLAYER_CARS
    #define MAX_PLAYER_CARS     (10)  // Максимум машин на игрока
#endif

#if !defined CAR_DIALOG_ID
    #define CAR_DIALOG_ID       (5000)
#endif

// === ПЕРЕМЕННЫЕ ===
static PlayerCars[MAX_PLAYERS][MAX_PLAYER_CARS];
static PlayerCarModel[MAX_PLAYERS][MAX_PLAYER_CARS];
static PlayerCarCount[MAX_PLAYERS];
static PlayerCarID[MAX_PLAYERS][MAX_PLAYER_CARS];
static bool:CarOwned[MAX_VEHICLES];

// === ФУНКЦИИ ДЛЯ РАБОТЫ С НАЗВАНИЯМИ ===
static stock GetVehicleName(modelid, name[], len)
{
    static const vehicleNames[][] = {
        "Landstalker", "Bravura", "Buffalo", "Linerunner", "Perrenial", "Sentinel",
        "Dumper", "Firetruck", "Trashmaster", "Stretch", "Manana", "Infernus",
        "Voodoo", "Pony", "Mule", "Cheetah", "Ambulance", "Leviathan", "Moonbeam",
        "Esperanto", "Taxi", "Washington", "Bobcat", "Mr Whoopee", "BF Injection",
        "Hunter", "Premier", "Enforcer", "Securicar", "Banshee", "Predator", "Bus",
        "Rhino", "Barracks", "Hotknife", "Trailer", "Previon", "Coach", "Cabbie",
        "Stallion", "Rumpo", "RC Bandit", "Romero", "Packer", "Monster", "Admiral",
        "Squalo", "Seasparrow", "Pizzaboy", "Tram", "Trailer", "Turismo", "Speeder",
        "Reefer", "Tropic", "Flatbed", "Yankee", "Caddy", "Solair", "Berkley's RC",
        "Skimmer", "PCJ-600", "Faggio", "Freeway", "RC Baron", "RC Raider", "Glendale",
        "Oceanic", "Sanchez", "Sparrow", "Patriot", "Quad", "Coastguard", "Dinghy",
        "Hermes", "Sabre", "Rustler", "ZR-350", "Walton", "Regina", "Comet", "BMX",
        "Burrito", "Camper", "Marquis", "Baggage", "Dozer", "Maverick", "News Chopper",
        "Rancher", "FBI Rancher", "Virgo", "Greenwood", "Jetmax", "Hotring", "Sandking",
        "Blista Compact", "Police Maverick", "Boxville", "Benson", "Mesa", "RC Goblin",
        "Hotring Racer A", "Hotring Racer B", "Bloodring Banger", "Rancher", "Super GT",
        "Elegant", "Journey", "Bike", "Mountain Bike", "Beagle", "Cropdust", "Stunt",
        "Tanker", "Roadtrain", "Nebula", "Majestic", "Buccaneer", "Shamal", "Hydra",
        "FCR-900", "NRG-500", "HPV1000", "Cement Truck", "Tow Truck", "Fortune",
        "Cadrona", "FBI Truck", "Willard", "Forklift", "Tractor", "Combine", "Feltzer",
        "Remington", "Slamvan", "Blade", "Freight", "Streak", "Vortex", "Vincent",
        "Bullet", "Clover", "Sadler", "Firetruck LA", "Hustler", "Intruder", "Primo",
        "Cargobob", "Tampa", "Sunrise", "Merit", "Utility", "Nevada", "Yosemite",
        "Windsor", "Monster A", "Monster B", "Uranus", "Jester", "Sultan", "Stratum",
        "Elegy", "Raindance", "RC Tiger", "Flash", "Tahoma", "Savanna", "Bandito",
        "Freight Flat", "Streak Carriage", "Kart", "Mower", "Dune", "Sweeper",
        "Broadway", "Tornado", "AT-400", "DFT-30", "Huntley", "Stafford", "BF-400",
        "Newsvan", "Tug", "Trailer", "Emperor", "Wayfarer", "Euros", "Hotdog", "Club",
        "Freight Box", "Trailer 3", "Andromada", "Camper", "Trailer 4", "Trailer 5"
    };
    
    if(modelid >= 400 && modelid <= 611)
        format(name, len, vehicleNames[modelid - 400]);
    else
        format(name, len, "Unknown");
    
    return 1;
}

// === ОСНОВНЫЕ ФУНКЦИИ INCLUDE ===

// Создание машины для игрока
stock CarManager_CreateCar(playerid, modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2)
{
    if(PlayerCarCount[playerid] >= MAX_PLAYER_CARS)
        return -1;
    
    new vehicleid = CreateVehicle(modelid, x, y, z, angle, color1, color2, -1);
    
    if(vehicleid == INVALID_VEHICLE_ID)
        return -1;
    
    PlayerCarModel[playerid][PlayerCarCount[playerid]] = modelid;
    PlayerCars[playerid][PlayerCarCount[playerid]] = vehicleid;
    PlayerCarID[playerid][PlayerCarCount[playerid]] = vehicleid;
    CarOwned[vehicleid] = true;
    PlayerCarCount[playerid]++;
    
    return vehicleid;
}

// Удаление конкретной машины
stock CarManager_DeleteCar(playerid, slot)
{
    if(slot < 0 || slot >= PlayerCarCount[playerid])
        return 0;
    
    new vehicleid = PlayerCars[playerid][slot];
    
    if(IsValidVehicle(vehicleid))
        DestroyVehicle(vehicleid);
    
    CarOwned[vehicleid] = false;
    
    // Сдвиг массива
    for(new i = slot; i < PlayerCarCount[playerid] - 1; i++)
    {
        PlayerCarModel[playerid][i] = PlayerCarModel[playerid][i+1];
        PlayerCars[playerid][i] = PlayerCars[playerid][i+1];
        PlayerCarID[playerid][i] = PlayerCarID[playerid][i+1];
    }
    
    PlayerCarCount[playerid]--;
    return 1;
}

// Удаление всех машин игрока
stock CarManager_DeleteAllCars(playerid)
{
    for(new i = 0; i < PlayerCarCount[playerid]; i++)
    {
        new vehicleid = PlayerCars[playerid][i];
        if(IsValidVehicle(vehicleid))
            DestroyVehicle(vehicleid);
        CarOwned[vehicleid] = false;
    }
    
    PlayerCarCount[playerid] = 0;
    return 1;
}

// Получение количества машин
stock CarManager_GetCarCount(playerid)
{
    return PlayerCarCount[playerid];
}

// Получение ID машины по слоту
stock CarManager_GetCarID(playerid, slot)
{
    if(slot < 0 || slot >= PlayerCarCount[playerid])
        return INVALID_VEHICLE_ID;
    
    return PlayerCars[playerid][slot];
}

// Получение модели по слоту
stock CarManager_GetCarModel(playerid, slot)
{
    if(slot < 0 || slot >= PlayerCarCount[playerid])
        return 0;
    
    return PlayerCarModel[playerid][slot];
}

// Показать диалог удаления
stock CarManager_ShowDeleteDialog(playerid)
{
    if(PlayerCarCount[playerid] == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[CAR] You don't have any cars to delete!");
        return 0;
    }
    
    new dialog[1024], title[64];
    format(title, sizeof(title), "Delete Car (%d/%d)", PlayerCarCount[playerid], MAX_PLAYER_CARS);
    
    strcat(dialog, "ID\tModel\tVehicle ID\n", sizeof(dialog));
    
    for(new i = 0; i < PlayerCarCount[playerid]; i++)
    {
        new carname[32], line[128];
        GetVehicleName(PlayerCarModel[playerid][i], carname, sizeof(carname));
        format(line, sizeof(line), "%d\t%s\t%d\n", i+1, carname, PlayerCars[playerid][i]);
        strcat(dialog, line, sizeof(dialog));
    }
    
    ShowPlayerDialog(playerid, CAR_DIALOG_ID, DIALOG_STYLE_TABLIST_HEADERS, title, dialog, "Delete", "Cancel");
    return 1;
}

// Проверка, принадлежит ли машина игроку
stock CarManager_IsOwnedByPlayer(playerid, vehicleid)
{
    if(vehicleid < 0 || vehicleid >= MAX_VEHICLES)
        return false;
    
    if(!CarOwned[vehicleid])
        return false;
    
    for(new i = 0; i < PlayerCarCount[playerid]; i++)
    {
        if(PlayerCars[playerid][i] == vehicleid)
            return true;
    }
    
    return false;
}

// === ХУКИ ДЛЯ АВТОМАТИЧЕСКОЙ РАБОТЫ ===

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse CarManager_OnDialogResponse
#if defined CAR_MANAGER_DIALOG_HOOK
    forward OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == CAR_DIALOG_ID)
    {
        if(!response)
        {
            SendClientMessage(playerid, 0xFFFFFFFF, "[CAR] Deletion cancelled.");
            return 1;
        }
        
        if(listitem < 0 || listitem >= PlayerCarCount[playerid])
        {
            SendClientMessage(playerid, 0xFF0000FF, "[CAR] Invalid selection!");
            return 1;
        }
        
        new modelid = PlayerCarModel[playerid][listitem];
        new carname[32];
        GetVehicleName(modelid, carname, sizeof(carname));
        
        CarManager_DeleteCar(playerid, listitem);
        
        new message[128];
        format(message, sizeof(message), "[CAR] %s successfully deleted!", carname);
        SendClientMessage(playerid, 0x00FF00FF, message);
        
        return 1;
    }
    
    #if defined CAR_MANAGER_DIALOG_HOOK
        return CallLocalFunction("CarManager_OnDialogResponse", "iiids", playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect CarManager_OnPlayerDisconnect
#if defined CAR_MANAGER_DISCONNECT_HOOK
    forward OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    CarManager_DeleteAllCars(playerid);
    
    #if defined CAR_MANAGER_DISCONNECT_HOOK
        return CallLocalFunction("CarManager_OnPlayerDisconnect", "ii", playerid, reason);
    #else
        return 1;
    #endif
}

// === КОМАНДА ДЛЯ УДАЛЕНИЯ ===
#if defined _ALS_CMD_car_gmx
    #undef CMD:car_gmx
#else
    #define _ALS_CMD_car_gmx
#endif

CMD:car_gmx(playerid, params[])
{
    CarManager_ShowDeleteDialog(playerid);
    return 1;
}

// === ПРИМЕР КОМАНДЫ /CAR ===
/*
CMD:car(playerid, params[])
{
    new modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2;
    
    if(sscanf(params, "dffffdd", modelid, x, y, z, angle, color1, color2))
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "Usage: /car [model] [x] [y] [z] [angle] [color1] [color2]");
        return 1;
    }
    
    if(modelid < 400 || modelid > 611)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Invalid model ID! (400-611)");
        return 1;
    }
    
    new vehicleid = CarManager_CreateCar(playerid, modelid, x, y, z, angle, color1, color2);
    
    if(vehicleid == -1)
        SendClientMessage(playerid, 0xFF0000FF, "Failed to create car!");
    else
        SendClientMessage(playerid, 0x00FF00FF, "Car created! Use /car_gmx to delete it.");
    
    return 1;
}
*/

// === ИНИЦИАЛИЗАЦИЯ ===
#if defined FILTERSCRIPT
public OnFilterScriptInit()
{
    print("========================");
    print("  Car Manager Include");
    print("  Version 1.0");
    print("========================");
    
    #if defined CAR_MANAGER_FILTERSCRIPT_INIT
        return CallLocalFunction("CarManager_OnFilterScriptInit", "");
    #else
        return 1;
    #endif
}

public OnFilterScriptExit()
{
    #if defined CAR_MANAGER_FILTERSCRIPT_EXIT
        return CallLocalFunction("CarManager_OnFilterScriptExit", "");
    #else
        return 1;
    #endif
}
#endif