#define MAX_NEW_GREEN_ZONES 28

enum E_STRUCT_GREEN_ZONES
{
    Float:x1,
    Float:y1,
    Float:x2,
    Float:y2,
    world,
    interrior
}

new Float:green_zones[MAX_NEW_GREEN_ZONES][E_STRUCT_GREEN_ZONES] =
{
    // nin X        min Y          max X       max Y     world    interrior
    {1671.092285,2550.629150,   1875.311767,2418.691894,   0,        0}, // вокзал бат + шинка
    {-2485.494140,154.302719,   -2366.231445,239.639541,   0,        0}, // вокзал лыткарино
    {949.917663,660.967590,     741.638366,889.832824,     0,        0}, // вокзал арзамас
    {2808.594726,-2499.215087,  2663.281738,-2397.998046,  0,        0}, // вокзал южный
    {1866.808471,-2222.226318,  1933.026489,-2247.429687,  0,        0}, // ГИБДД
    {-174.994934,587.772766,    -88.648986,669.413146,     0,        0}, // правительство
    {2367.830566,-1863.680419,  2452.864257,-1817.632202,  0,        0}, // СМИ
    {2263.744628,1985.547119,   2386.191894,2104.017578,   0,        0}, // ТК бат
    {1950.916992,2061.955810,   1894.389892,2108.898925,   0,        0}, // магазин 24/7 бат возле банка
    {-2350.552490,-15.638792,   -2307.610839,-62.218833,   0,        0}, // банк лыткарино
    {1872.724243,2050.830810,   1817.684204,2004.175170,   0,        0}, // банк батырево
    {371.322082,738.103942,     439.404266,796.616271,     0,        0}, // банк арзамас
    {-2542.091308,-72.682868,   -2703.296630,104.943061,   0,        0}, // автошкола
    {1798.943115,-89.082519,    1902.174194,-168.562728,   0,        0}, // СТО
    {-391.101196,983.072875,    -474.789794,1040.102294,   0,        0}, // технический центр
    {2287.807861,-2652.880126,  2357.666503,-2594.603515,  0,        0}, // стайлинг центр
    {2435.937255,-783.585998,   2535.176025,-642.719909,   0,        0}, // автосалон низкого класса
    {1297.665527,406.414154,    1488.526855,507.252014,    0,        0}, // автосалон среднего класса
    {52.985706,2530.589111,     -54.625167,2661.052246,    0,        0}, // автосал высокого класса
    {-856.131652,1110.942871,   -969.932922,1258.087158,   0,        0}, // мотосалон
    {-783.021240,1899.607421,   -717.282165,2003.548828,   0,        0}, // автосалон грузовых авто
    {1914.053222,-624.190856,   2026.645019,-469.847869,   0,        0}, // авторынок
    {1264.849487,2288.956542,   1396.073364,2430.695068,   0,        0}, // казино
    {-1034.935302,2159.171875,  -1124.056762,2230.977050,  0,        0}, // завод
    {2423.455566,1713.539550,   2254.791259,1862.427612,   0,        0}, // шахта
    {529.368835,1593.303588,    696.513366,1775.188964,    0,        0}, // конты
    {-192.552978,578.706359,    -299.068969,539.403198,    0,        0}, // больница арзамас
    {-2285.737304,-114.393127,  -2394.319335,-223.865844,  0,        0}  // больница лыткарино
};

enum E_STORED_WEAPON_DATA
{
    StoredWeaponID,
    StoredWeaponAmmo
}

new StoredWeaponData[MAX_PLAYERS][E_STORED_WEAPON_DATA];

new Text:greenzone_TD[1];

new GREENZONE_FLAGS[MAX_NEW_GREEN_ZONES];
new bool:PlayerInGreenZone[MAX_PLAYERS];

public OnGameModeInit()
{
    GreenZoneTD();
    SetTimer("GreenZoneCreate", 30000, false);

    #if defined greenzone_OnGameModeInit
        return greenzone_OnGameModeInit();
    #else
        return 1;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit greenzone_OnGameModeInit
#if defined greenzone_OnGameModeInit
    forward greenzone_OnGameModeInit();
#endif

forward GreenZoneCreate();
public GreenZoneCreate()
{
    for(new i = 0; i < MAX_NEW_GREEN_ZONES; i++)
    {
        GREENZONE_FLAGS[i] = CreateDynamicRectangle(green_zones[i][0], green_zones[i][1], green_zones[i][2], green_zones[i][3], green_zones[i][4], green_zones[i][5]);
    }
}

stock GreenZoneTD()
{
    greenzone_TD[0] = TextDrawCreate(8.3000, 245.0000, "txd:greenzonatd");
    TextDrawTextSize(greenzone_TD[0], 70.0000, 38.0000);
    TextDrawAlignment(greenzone_TD[0], 1);
    TextDrawColor(greenzone_TD[0], -1);
    TextDrawBackgroundColor(greenzone_TD[0], 255);
    TextDrawFont(greenzone_TD[0], 4);
    TextDrawSetProportional(greenzone_TD[0], 0);
    TextDrawSetShadow(greenzone_TD[0], 0);
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    for(new i = 0; i < MAX_NEW_GREEN_ZONES; i++)
    {
        if(areaid == GREENZONE_FLAGS[i])
        {
            PlayerInGreenZone[playerid] = true;
            TextDrawShowForPlayer(playerid, greenzone_TD[0]);
             SetPlayerGreenZone(playerid, 1);
            break; 
        }
    }
    #if defined greenzone_OnPlayerEnterDynamicArea
        return greenzone_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea greenzone_OnPlayerEnterDynamicArea
#if defined greenzone_OnPlayerEnterDynamicArea
    forward greenzone_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnPlayerLeaveDynamicArea(playerid, areaid)
{
    for(new i = 0; i < MAX_NEW_GREEN_ZONES; i++)
    {
        if(areaid == GREENZONE_FLAGS[i])
        {
            PlayerInGreenZone[playerid] = false;
             SetPlayerGreenZone(playerid, 0);
            TextDrawHideForPlayer(playerid, greenzone_TD[0]);
             
            if(StoredWeaponData[playerid][StoredWeaponID] != 0)
            {
                new weaponID = StoredWeaponData[playerid][StoredWeaponID];
                new weaponAmmo = StoredWeaponData[playerid][StoredWeaponAmmo];
                GivePlayerWeapon(playerid, weaponID, weaponAmmo);
                
                StoredWeaponData[playerid][StoredWeaponID] = 0;
                StoredWeaponData[playerid][StoredWeaponAmmo] = 0;
            }

            break; 
        }
    }
    #if defined greenzone_OnPlayerLeaveDynamicArea
        return greenzone_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerLeaveDynamicArea
    #undef OnPlayerLeaveDynamicArea
#else
    #define _ALS_OnPlayerLeaveDynamicArea
#endif
#define OnPlayerLeaveDynamicArea greenzone_OnPlayerLeaveDynamicArea
#if defined greenzone_OnPlayerLeaveDynamicArea
    forward greenzone_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

forward UnfreezePlayerGreenZone(playerid);
public UnfreezePlayerGreenZone(playerid)
{
    TogglePlayerControllable(playerid, 1);
}

stock IsPlayerInGreenZone(playerid)
{
    return PlayerInGreenZone[playerid];
}

#if defined _ALS_SetPlayerInterior
    #undef SetPlayerInterior
#else
    #define _ALS_SetPlayerInterior
#endif
#define SetPlayerInterior __ALS_SetPlayerInterior
forward __ALS_SetPlayerInterior(playerid, interiorid);

public __ALS_SetPlayerInterior(playerid, interiorid)
{
    if(interiorid >= 1)
    {
        TextDrawShowForPlayer(playerid, greenzone_TD[0]);
        PlayerInGreenZone[playerid] = true;
    }
    else 
    {
        TextDrawHideForPlayer(playerid, greenzone_TD[0]);
        PlayerInGreenZone[playerid] = false;
    }
    
    #undef SetPlayerInterior
    SetPlayerInterior(playerid, interiorid);
    #define SetPlayerInterior __ALS_SetPlayerInterior
    return 1;
}