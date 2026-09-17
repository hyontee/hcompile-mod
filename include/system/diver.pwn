new actor_diver[2], sphere_actor[2];

new name_items_diver[5][18] = {"Колесо", "Аккумулятор", "Стиральная машина", "Ваза", "Бензопила"};
new price_items[5] = {20000, 20000, 20000, 20000, 20000};
new items_model_diver[5] = {4237, 4232, 4236, 4242, 4235};
#define MAX_DIVER 10
#define MAX_I_DIVER 50
#define I_DIVER_BOX         0    
#define I_DIVER_TIRE        1
#define I_DIVER_GOLD        2
#define I_DIVER_TV          3
#define I_DIVER_BOOT        4

new last_sell_time[MAX_PLAYERS];
#define SELL_COOLDOWN 1

#define br_z   "{FAD201}"
#define CW   "{FFFFFF}"

enum S_DIVER_ORDER
{
    Float:DV_X,
    Float:DV_Y,
    Float:DV_Z,
    DV_P_ID,
}

new Float:order_diver[MAX_DIVER][S_DIVER_ORDER] =
{
    {-1300.630249,1033.602661,-43.945053,    -1}, 
    {-2358.896484,1102.906127,-40.581607,    -1}, 
    {-1711.381713,1196.425415,-9.541759,    -1}, 
    {-547.580993,336.653411,-36.227989,    -1}, 
    {1366.407104,-824.331359,20.840627,    -1}, 
    {1152.262695,-246.503692,-27.216604,    -1}, 
    {1797.563232,128.639724,-35.809577,    -1}, 
    {1025.245483,-69.781929,-43.224620,    -1}, 
    {1394.748535,123.227615,-33.592060,    -1}, 
    {-2864.630859,232.082199,-13.864818,    -1}
};

new Float:spawn_diver_vehicle[6][5] =
{
    {659.482910,159.273727,-0.544729,178.099777, Float:0},
    {639.523742,158.625823,-0.560347,178.099777, Float:0},
    {669.388977,160.232330,-0.553551,178.099777, Float:0},
    {-2541.923828,365.270996,-0.560600,89.943420, Float:1},
    {-2539.665283,375.239318,-0.562907,89.943420, Float:1},
    {-2539.389404,389.337554,-0.544025,89.943420, Float:1}
};

enum ITEMS_DIVER
{
    I_DV_OBJECT, 
    I_DV_AREA, 
    I_DV_TYPE,
    Text3D:I_DV_3DTEXT,
    Float:I_DV_X,
    Float:I_DV_Y,
    Float:I_DV_Z,
    I_DV_ORDER
}



new Float:items_order[MAX_I_DIVER][ITEMS_DIVER] =
{
    // Заказ 0 (было 4, добавили 5-ю)
    {-1, -1, -1, Text3D:-1,     -1299.736450,1030.678466,-43.759330,    0},
    {-1, -1, -1, Text3D:-1,     -1294.773315,1030.276000,-44.383892,    0},
    {-1, -1, -1, Text3D:-1,     -1291.930664,1036.798461,-45.649955,    0},
    {-1, -1, -1, Text3D:-1,     -1298.802246,1040.027954,-45.013538,    0},
    {-1, -1, -1, Text3D:-1,     -1296.000000,1033.000000,-44.500000,    0}, // новая

    // Заказ 1
    {-1, -1, -1, Text3D:-1,     -2357.749267,1101.811523,-46.269500,    1},
    {-1, -1, -1, Text3D:-1,     -2356.711669,1105.708862,-46.339786,    1},
    {-1, -1, -1, Text3D:-1,     -2359.528808,1100.768554,-46.614593,    1},
    {-1, -1, -1, Text3D:-1,     -2358.452392,1095.123168,-46.287437,    1},
    {-1, -1, -1, Text3D:-1,     -2358.000000,1103.000000,-46.500000,    1}, // новая

    // Заказ 2
    {-1, -1, -1, Text3D:-1,     -1711.196533,1196.271362,-10.546383,    2},
    {-1, -1, -1, Text3D:-1,     -1707.007690,1198.645507,-10.935578,    2},
    {-1, -1, -1, Text3D:-1,     -1708.856811,1203.194824,-9.368476,     2},
    {-1, -1, -1, Text3D:-1,     -1717.878295,1199.776489,-11.360163,    2},
    {-1, -1, -1, Text3D:-1,     -1712.000000,1200.000000,-10.500000,    2}, // новая

    // Заказ 3
    {-1, -1, -1, Text3D:-1,     -549.584899,335.892456,-36.853237,      3},
    {-1, -1, -1, Text3D:-1,     -551.322692,340.630706,-37.462085,      3},
    {-1, -1, -1, Text3D:-1,     -547.012023,344.229461,-37.120285,      3},
    {-1, -1, -1, Text3D:-1,     -540.468627,338.334197,-35.029785,      3},
    {-1, -1, -1, Text3D:-1,     -547.000000,339.000000,-36.500000,      3}, // новая

    // Заказ 4
    {-1, -1, -1, Text3D:-1,     1366.101562,-821.534362,-57.106460,     4},
    {-1, -1, -1, Text3D:-1,     1361.368041,-823.787475,-57.070491,     4},
    {-1, -1, -1, Text3D:-1,     1362.132568,-831.688232,-57.016746,     4},
    {-1, -1, -1, Text3D:-1,     1374.770019,-832.624450,-57.107894,     4},
    {-1, -1, -1, Text3D:-1,     1366.000000,-827.000000,-57.000000,     4}, // новая

    // Заказ 5
    {-1, -1, -1, Text3D:-1,     1148.777954,-245.415893,-27.823001,     5},
    {-1, -1, -1, Text3D:-1,     1151.200317,-239.258209,-28.728399,     5},
    {-1, -1, -1, Text3D:-1,     1159.555786,-242.678314,-28.957393,     5},
    {-1, -1, -1, Text3D:-1,     1159.226562,-253.490768,-27.663639,     5},
    {-1, -1, -1, Text3D:-1,     1154.000000,-245.000000,-28.000000,     5}, // новая

    // Заказ 6
    {-1, -1, -1, Text3D:-1,     1798.336791,129.778839,-36.258960,      6},
    {-1, -1, -1, Text3D:-1,     1790.974365,130.863632,-37.187446,      6},
    {-1, -1, -1, Text3D:-1,     1787.554565,123.930686,-37.542568,      6},
    {-1, -1, -1, Text3D:-1,     1790.622924,117.896026,-34.462966,      6},
    {-1, -1, -1, Text3D:-1,     1792.000000,125.000000,-36.500000,      6}, // новая

    // Заказ 7
    {-1, -1, -1, Text3D:-1,     1028.397583,-66.931350,-43.765480,      7},
    {-1, -1, -1, Text3D:-1,     1022.649902,-62.609016,-43.370590,      7},
    {-1, -1, -1, Text3D:-1,     1017.844177,-64.907760,-43.576751,      7},
    {-1, -1, -1, Text3D:-1,     1023.193969,-74.069854,-44.410453,      7},
    {-1, -1, -1, Text3D:-1,     1023.000000,-67.000000,-43.800000,      7}, // новая

    // Заказ 8
    {-1, -1, -1, Text3D:-1,     1395.356079,122.741455,-33.808929,      8},
    {-1, -1, -1, Text3D:-1,     1392.876953,118.109024,-32.931667,      8},
    {-1, -1, -1, Text3D:-1,     1385.771972,122.580101,-31.366134,      8},
    {-1, -1, -1, Text3D:-1,     1391.865234,129.453933,-32.073204,      8},
    {-1, -1, -1, Text3D:-1,     1391.000000,123.000000,-32.500000,      8}, // новая

    // Заказ 9
    {-1, -1, -1, Text3D:-1,     -2867.856445,229.483154,-14.848545,     9},
	{-1, -1, -1, Text3D:-1,     -2864.808349,227.946517,-14.140148,     9},
    {-1, -1, -1, Text3D:-1,     -2862.172607,232.211746,-13.310132,     9},
    {-1, -1, -1, Text3D:-1,     -2863.333740,237.873138,-13.245767,     9},
    {-1, -1, -1, Text3D:-1,     -2864.000000,232.000000,-14.000000,     9}  // новая
};

enum STRUCT_DIVER
{
    DV_BOX, 
    DV_GOLD,
    DV_TIRE, 
    DV_TV, 
    DV_BOOT, 
    DV_ID, 
    DV_ID_VEH,
    bool:DIVER_JOOB, 
    bool:DIVER_ORDER,
    player_dive_gang_zone_collector
}

new player_diver[MAX_PLAYERS][STRUCT_DIVER];

#define  GetPlayerDiver(%0,%1)      player_diver[%0][%1]
#define  SetPlayerDiver(%0,%1,%2)   player_diver[%0][%1] = %2
#define  AddPlayerDiver(%0,%1,%2,%3) player_diver[%0][%1] %2= %3

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == player_diver[playerid][player_dive_gang_zone_collector])
        {
	        SendDestroyWayPoint(playerid, 5);
        }
    for(new i = 0; i < MAX_I_DIVER; i++)
    {
        if(areaid == items_order[i][I_DV_AREA])
        {
            ToggleInteractionWindow(playerid, true);
            
            if(items_order[i][I_DV_OBJECT] == -1)
                return 1;

            if(!GetPlayerDiver(playerid, DIVER_JOOB))
            {
                ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Устройтесь на работу водолаза.", "");
                return 0;
            }

            if(!GetPlayerDiver(playerid, DIVER_ORDER))
            {
                ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "У вас нет активного заказа. Возьмите заказ у капитана.", "");
                return 0;
            }

            if(items_order[i][I_DV_ORDER] != GetPlayerDiver(playerid, DV_ID))
            {
                ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Этот предмет не из вашего заказа.", "");
                return 0;
            }
            if(sphere_actor[0] <= areaid <= sphere_actor[1])
    		{
	        	SetPVarInt(playerid, "shpere_diver", areaid);
          		{
       
		        	ShowPlayerDialog(playerid, 2770, DIALOG_STYLE_LIST,
		            "{FF5252}"FAN4IIK_NAME"{ffffff} | Водолаз",
		            ""br_z"1. "CW"Взять заказ\n"\
		            ""br_z"2. "CW"Устроиться/уволиться с работы\n"\
		            ""br_z"3. "CW"Арендовать лодку\n"\
		            ""br_z"4. "CW"Продать найденные предметы",
		            "Продолжить", "Выход");
   				 }
			}
            

            return 1;
        }
    }
    #if defined dv_OnPlayerEnterDynamicArea
        return dv_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea dv_OnPlayerEnterDynamicArea
#if defined dv_OnPlayerEnterDynamicArea
    forward dv_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnGameModeInit()
{
	sphere_actor[0] = CreateDynamicSphere(676.336730,187.356491,2.778203, 2.5, 0, 0);
   sphere_actor[1] = CreateDynamicSphere(-2526.549072,357.963623,2.060437, 2.5, 0, 0);
   CreateActorEx("{FAD201}Капитан пирса", "{FFFFFF}Подойдите для взаимодействия", 5344, 676.336730,187.356491,2.778203,174.494964);
   CreateActorEx("{FAD201}Капитан пирса", "{FFFFFF}Подойдите для взаимодействия", 5344,-2526.549072,357.963623,2.060437,123.978698);
   LoadSphereDiver();
    #if defined dv_OnGameModeInit
        return dv_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit dv_OnGameModeInit
#if defined dv_OnGameModeInit
    forward dv_OnGameModeInit();
#endif

/*public OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart)
{
    if(weaponid == WEAPON_DROWN)
	{
        if(GetPlayerDiver(playerid, DIVER_JOOB))
        {
		    SetPlayerHealth(playerid, 100.0);
        }
	}
    #if defined dv_OnPlayerTakeDamage
        return dv_OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerTakeDamage
    #undef OnPlayerTakeDamage
#else
    #define _ALS_OnPlayerTakeDamage
#endif
#define OnPlayerTakeDamage dv_OnPlayerTakeDamage
#if defined dv_OnPlayerTakeDamage
    forward dv_OnPlayerTakeDamage(playerid, issuerid, Float:amount, weaponid, bodypart);
#endif*/

public OnPlayerDisconnect(playerid, reason)
{
    if(GetPlayerDiver(playerid, DIVER_ORDER))
    {
        RemoveDiverOrder(GetPlayerDiver(playerid, DV_ID));
        if(IsValidVehicle(GetPlayerDiver(playerid, DV_ID_VEH))) DestroyVehicle(GetPlayerDiver(playerid, DV_ID_VEH));
    }
    UnLoadPlayerDiver(playerid);
    #if defined dv_OnPlayerDisconnect
        return dv_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect dv_OnPlayerDisconnect
#if defined dv_OnPlayerDisconnect
    forward dv_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerSpawn(playerid)
{
    if(GetPlayerDiver(playerid, DV_ID) != -1) LoadPlayerDiver(playerid);

    #if defined dv_OnPlayerSpawn
        return dv_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn dv_OnPlayerSpawn
#if defined dv_OnPlayerSpawn
    forward dv_OnPlayerSpawn(playerid);
#endif



public: LoadPlayerDiver(playerid)
{
    new diver_sql[184];
    new Cache: diver_result;

    mysql_format(mysql, diver_sql, sizeof diver_sql, "SELECT * FROM accounts WHERE id=%d LIMIT 1", GetPlayerAccountID(playerid));
	diver_result = mysql_query(mysql, diver_sql);

    if(cache_num_rows())
    {
        SetPlayerDiver(playerid, DV_BOX, cache_get_field_content_int(0, "box"));
        SetPlayerDiver(playerid, DV_GOLD, cache_get_field_content_int(0, "gold"));
        SetPlayerDiver(playerid, DV_TIRE, cache_get_field_content_int(0, "tire"));
        SetPlayerDiver(playerid, DV_TV, cache_get_field_content_int(0, "television"));
        SetPlayerDiver(playerid, DV_BOOT, cache_get_field_content_int(0, "boot"));
        cache_delete(diver_result);
    }
    SetPlayerDiver(playerid, player_dive_gang_zone_collector, -1);

    SetPlayerDiver(playerid, DV_ID, -1);
    SetPlayerDiver(playerid, DV_ID_VEH, -1);

}
stock UnLoadPlayerDiver(playerid)
{
    UpdatePlayerDatabaseInt(playerid, "boot", GetPlayerDiver(playerid, DV_BOOT));
    UpdatePlayerDatabaseInt(playerid, "television", GetPlayerDiver(playerid, DV_TV));
    UpdatePlayerDatabaseInt(playerid, "gold", GetPlayerDiver(playerid, DV_GOLD));
    UpdatePlayerDatabaseInt(playerid, "tire", GetPlayerDiver(playerid, DV_TIRE));
    UpdatePlayerDatabaseInt(playerid, "box", GetPlayerDiver(playerid, DV_BOX));
    SetPlayerDiver(playerid, DV_BOX, 0);
    SetPlayerDiver(playerid, DV_GOLD, 0);
    SetPlayerDiver(playerid, DV_TIRE, 0);
    SetPlayerDiver(playerid, DV_TV, 0);
    SetPlayerDiver(playerid, DV_BOOT, 0);
    SetPlayerDiver(playerid, DV_ID, 0);
    SetPlayerDiver(playerid, DV_ID_VEH, 0);
    SetPlayerDiver(playerid, DIVER_JOOB, false);
    SetPlayerDiver(playerid, DIVER_ORDER, false);

    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(GetPlayerDiver(playerid, DIVER_JOOB) && GetPlayerDiver(playerid, DIVER_ORDER) || GetPlayerDiver(playerid, DV_ID_VEH) != -1)
    {
        DisablePlayerCheckpoint(playerid);
     //   SCM(playerid, 0xFFE600FF4, "Вы достигли место назначения");
    }

    #if defined dv_OnPlayerEnterCheckpoint
        return dv_OnPlayerEnterCheckpoint(playerid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerEnterCheckpoint
    #undef OnPlayerEnterCheckpoint
#else
    #define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint dv_OnPlayerEnterCheckpoint
#if defined dv_OnPlayerEnterCheckpoint
    forward dv_OnPlayerEnterCheckpoint(playerid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 2770)
    {
        if(response)
        {
            switch(listitem+1)
            {
                case 1:
                {
                    if(!GetPlayerDiver(playerid, DIVER_JOOB)) return ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Сначала возьмите смену.", "");

                    if(GetPlayerDiver(playerid, DIVER_ORDER)) return ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Сначала возьмите смену.", "");

                    new id, orders[MAX_DIVER], count;

                    for(new d;d < MAX_DIVER;d++)
                    {
                        count++;
                        if(order_diver[d][DV_P_ID] != -1) continue;

                        orders[d] = count;
                        id++;
                    }

                    new r_orders = orders[random(id)];

                    if(r_orders == -1) return ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Немного подождите...", "");
                    order_diver[r_orders][DV_P_ID] = playerid;
                    SetPlayerDiver(playerid, DV_ID, r_orders);
                    SetPlayerDiver(playerid, DIVER_ORDER, true);
                    LoadOrderDiver(r_orders);
                    printf("ID_order = %d", r_orders);
                    ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы взяли заказ", "");
                    SendCreateWayPoint(playerid, 5, order_diver[GetPlayerDiver(playerid, DV_ID)][DV_X], order_diver[GetPlayerDiver(playerid, DV_ID)][DV_Y],-0.550000, 85, 27, 5000.0, 0);
                    CreateSmallGangZoneForDiver(playerid, order_diver[GetPlayerDiver(playerid, DV_ID)][DV_X], order_diver[GetPlayerDiver(playerid, DV_ID)][DV_Y]);
                }
                case 2:
                {
                    if(GetPlayerDiver(playerid, DIVER_JOOB))
                    {
                        SetPlayerDiver(playerid, DIVER_JOOB, false);
                        SetPlayerSkinInit(playerid);

                        if(GetPlayerDiver(playerid, DIVER_ORDER))
                        {
                            RemoveDiverOrder(GetPlayerDiver(playerid, DV_ID));
                            SetPlayerDiver(playerid, DV_ID, -1);
                            SetPlayerDiver(playerid, DIVER_ORDER, false);
                        }

                        if(GetPlayerDiver(playerid, DV_ID_VEH) != -1)
                        {
                            DestroyVehicle(GetPlayerDiver(playerid, DV_ID_VEH));
                            SetPlayerDiver(playerid, DV_ID_VEH, -1);
                            ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Вы уволились с работы 'Водолаз'.", "");
                            SendDestroyWayPoint(playerid, 5);
                        }
                    }
                    else
                    {
                        ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы устроились на работу 'Водолаз' ", "");
                    	if(GetPlayerSex(playerid) == 0) SetPlayerSkin(playerid, 5344);
                        if(GetPlayerSex(playerid) == 1) SetPlayerSkin(playerid, 5348);
                       
                        SetPlayerDiver(playerid, DIVER_JOOB, true);
                    }
                }
               case 3:
                {
                    if(!GetPlayerDiver(playerid, DIVER_JOOB)) return ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Сначала начните смену.", "");


                    if(GetPlayerDiver(playerid, DV_ID_VEH) != -1)
                    {
                        DestroyVehicle(GetPlayerDiver(playerid, DV_ID_VEH));
                        SetPlayerDiver(playerid, DV_ID_VEH, -1);
                        ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы вернули лодку", "");
                    }

                    else
                    {
                        if(!(GetPlayerMoneyEx(playerid) >= 20000)) return ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вам необходимо 20.000 рублей.", "");
                        new vehicle;

                        if(GetPVarInt(playerid, "shpere_diver") == sphere_actor[0])
                        {
                            new r = random(3);
                        	ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы арендовали лодку", "");
                            vehicle = CreateVehicle(493, spawn_diver_vehicle[r][0], spawn_diver_vehicle[r][1], spawn_diver_vehicle[r][2], spawn_diver_vehicle[r][3], 1, 1, -1);
                            SetPlayerCheckpoint(playerid, spawn_diver_vehicle[r][0], spawn_diver_vehicle[r][1], spawn_diver_vehicle[r][2], 5.0);
                            ShowPlayerGPS(playerid, spawn_diver_vehicle[r][0], spawn_diver_vehicle[r][1]);
                        }
                        else
                        {
                            new r = random(3) + 3;
                            ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы арендовали лодку", "");
                            vehicle = CreateVehicle(493, spawn_diver_vehicle[r][0], spawn_diver_vehicle[r][1], spawn_diver_vehicle[r][2], spawn_diver_vehicle[r][3], 1, 1, -1);
                            SetPlayerCheckpoint(playerid, spawn_diver_vehicle[r][0], spawn_diver_vehicle[r][1], spawn_diver_vehicle[r][2], 5.0);
                            ShowPlayerGPS(playerid, spawn_diver_vehicle[r][0], spawn_diver_vehicle[r][1]);
                        }
                        SetPlayerDiver(playerid, DV_ID_VEH, vehicle);
                        GivePlayerMoneyEx(playerid, -200000);
                    }
                }
                case 4:
                {
                    new dialog_text[294];
                    for(new c, count; c < 20;c++)
                    {
                        format
                        (
                            dialog_text, sizeof dialog_text,
                            ""CW"Название\tКоличество\tСтоимость предмета\n"\
                            ""CW"Колесо\t{FFFFFF}%d\t{D7FD00}%d\n"\
                            ""CW"Аккумулятор\t{FFFFFF}%d\t{D7FD00}%d\n"\
                            ""CW"Стиральная машина\t{FFFFFF}%d\t{D7FD00}%d\n"\
                            ""CW"Ваза\t{FFFFFF}%d\t{D7FD00}%d\n"\
                            ""CW"Бензопила\t{FFFFFF}%d\t{D7FD00}%d",
                            GetPlayerDiver(playerid, DV_BOX),
                            price_items[0],
                            GetPlayerDiver(playerid, DV_TIRE),
                            price_items[1],
                            GetPlayerDiver(playerid, DV_GOLD),
                            price_items[2],
                            GetPlayerDiver(playerid, DV_TV),
                            price_items[3],
                            GetPlayerDiver(playerid, DV_BOOT),
                            price_items[4]
                        );
                    }

                    ShowPlayerDialog
                    (
                        playerid, 2771, DIALOG_STYLE_TABLIST_HEADERS,
                        "{FF5252}"FAN4IIK_NAME"{ffffff} | Водолаз",
                        dialog_text,
                        "Продать", "Назад"
                    );
                }
            }
        }
    }
if(dialogid == 2771)
{
    if(response)
    {
        switch(listitem + 1)
        {
            case 1:  // Колесо
            {
                if(GetPlayerDiver(playerid, DV_BOX) == 0)
                {
                    ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "У вас нет колёс для продажи.", "");
                    return 1;
                }

                new rand_price = GetRandomItemPrice(I_DIVER_BOX);

                AddPlayerDiver(playerid, DV_BOX, -, 1);
                UpdatePlayerDatabaseInt(playerid, "box", GetPlayerDiver(playerid, DV_BOX));
                GivePlayerMoneyEx(playerid, rand_price);

                new str[128];
                format(str, sizeof str, "Вы продали колесо за %d рублей.", rand_price);
                ShowNotificationFan4iik(playerid, 1, 6, 0, 0, str, "");
                UpdateSellDialog(playerid);
            }
            case 2:  // Аккумулятор
            {
                if(GetPlayerDiver(playerid, DV_TIRE) == 0)
                {
                    ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "У вас нет Аккумулятора для продажи.", "");
                    return 1;
                }

                new rand_price = GetRandomItemPrice(I_DIVER_TIRE);

                AddPlayerDiver(playerid, DV_TIRE, -, 1);
                UpdatePlayerDatabaseInt(playerid, "tire", GetPlayerDiver(playerid, DV_TIRE));
                GivePlayerMoneyEx(playerid, rand_price);

                new str[128];
                format(str, sizeof str, "Вы продали Аккумулятор за %d рублей.", rand_price);
                ShowNotificationFan4iik(playerid, 1, 6, 0, 0, str, "");
                UpdateSellDialog(playerid);
            }
            case 3:  // Стиральная машина
            {
                if(GetPlayerDiver(playerid, DV_GOLD) == 0)
                {
                    ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "У вас нет Стиральной машины для продажи.", "");
                    return 1;
                }

                new rand_price = GetRandomItemPrice(I_DIVER_GOLD);

                AddPlayerDiver(playerid, DV_GOLD, -, 1);
                UpdatePlayerDatabaseInt(playerid, "gold", GetPlayerDiver(playerid, DV_GOLD));
                GivePlayerMoneyEx(playerid, rand_price);

                new str[128];
                format(str, sizeof str, "Вы продали Стиральную машину за %d рублей.", rand_price);
                ShowNotificationFan4iik(playerid, 1, 6, 0, 0, str, "");
                UpdateSellDialog(playerid);
            }
            case 4:  // Ваза
            {
                if(GetPlayerDiver(playerid, DV_TV) == 0)
                {
                    ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "У вас нет Ваз для продажи.", "");
                    return 1;
                }

                new rand_price = GetRandomItemPrice(I_DIVER_TV);

                AddPlayerDiver(playerid, DV_TV, -, 1);
                UpdatePlayerDatabaseInt(playerid, "television", GetPlayerDiver(playerid, DV_TV));
                GivePlayerMoneyEx(playerid, rand_price);

                new str[128];
                format(str, sizeof str, "Вы продали Вазу за %d рублей.", rand_price);
                ShowNotificationFan4iik(playerid, 1, 6, 0, 0, str, "");
                UpdateSellDialog(playerid);
            }
            case 5:  // Бензопил
            {
                if(GetPlayerDiver(playerid, DV_BOOT) == 0)
                {
                    ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "У вас нет Бензопилы для продажи.", "");
                    return 1;
                }

                new rand_price = GetRandomItemPrice(I_DIVER_BOOT);
				AddPlayerDiver(playerid, DV_BOOT, -, 1);
                UpdatePlayerDatabaseInt(playerid, "boot", GetPlayerDiver(playerid, DV_BOOT));
                GivePlayerMoneyEx(playerid, rand_price);

                new str[128];
                format(str, sizeof str, "Вы продали Бензопилу за %d рублей.", rand_price);
                ShowNotificationFan4iik(playerid, 1, 6, 0, 0, str, "");
                UpdateSellDialog(playerid);
            }
        }
    }
    else
    {
        // Назад к главному меню
        ShowPlayerDialog(playerid, 2770, DIALOG_STYLE_LIST,
            "{FF5252}"FAN4IIK_NAME"{ffffff} | Водолаз",
            ""br_z"1. "CW"Взять заказ\n"\
            ""br_z"2. "CW"Устроиться/уволиться с работы\n"\
            ""br_z"3. "CW"Арендовать лодку\n"\
            ""br_z"4. "CW"Продать найденные предметы",
            "Продолжить", "Выход");
    }
}
    #if defined dv_OnDialogResponse
        return dv_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse dv_OnDialogResponse
#if defined dv_OnDialogResponse
forward dv_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif



stock LoadOrderDiver(id)
{
    new item_count = 0;
    for(new c = 0; c < MAX_I_DIVER; c++)
    {
        if(items_order[c][I_DV_ORDER] != id) continue;

        // Циклически назначаем типы 0,1,2,3,4 для 5 предметов
        new type = item_count % 5;
        new text[64];

        items_order[c][I_DV_TYPE] = type;

        format(text, sizeof text, "{FFEE00}%s\n{FFFFFF}Подойдите для взаимодействия", name_items_diver[type]);

        items_order[c][I_DV_OBJECT] = CreateObject(items_model_diver[type],
            items_order[c][I_DV_X], items_order[c][I_DV_Y], items_order[c][I_DV_Z] - 0.5,
            0.0, 0.0, 0.0);
        items_order[c][I_DV_3DTEXT] = Create3DTextLabel(text, -1,
            items_order[c][I_DV_X], items_order[c][I_DV_Y], items_order[c][I_DV_Z],
            5.0, 0);

        item_count++;
        if(item_count >= 5) break; // Создали 5 предметов
    }
    return 1;
}
stock LoadSphereDiver()
{
    for(new c;c < MAX_I_DIVER;c++)
    {
        items_order[c][I_DV_AREA]  = CreateDynamicSphere(items_order[c][I_DV_X], items_order[c][I_DV_Y], items_order[c][I_DV_Z] - 0.7, 3.0); 
    }
    return 1;
}
stock RemoveDiverOrder(id)
{
    // Находим игрока, выполнявшего заказ
    new playerid = -1;
    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        if(IsPlayerConnected(p) && GetPlayerDiver(p, DIVER_ORDER) && GetPlayerDiver(p, DV_ID) == id)
        {
            playerid = p;
            break;
        }
    }

    // Освобождаем слот заказа
    if(id >= 0 && id < MAX_DIVER)
    {
        order_diver[id][DV_P_ID] = -1;
    }

    // Уничтожаем ВСЕ предметы этого заказа
    for(new c = 0; c < MAX_I_DIVER; c++)
    {
        if(items_order[c][I_DV_ORDER] == id)
        {
            DestroyDiverItems(c);
        }
    }

    // Удаляем гангзону у игрока
    if(playerid != -1 && IsPlayerConnected(playerid))
    {
        if(player_diver[playerid][player_dive_gang_zone_collector] != -1)
        {
            GangZoneHideForPlayer(playerid, player_diver[playerid][player_dive_gang_zone_collector]);
            GangZoneDestroy(player_diver[playerid][player_dive_gang_zone_collector]);
            player_diver[playerid][player_dive_gang_zone_collector] = -1;
        }
        // Также отключаем чекпоинт
        DisablePlayerCheckpoint(playerid);
    }

    return 1;
}

stock IsPlayerInItemsDiver(playerid)
{
    new area = -1;
    for(new i;i < sizeof items_order;i++)
    {
        if(IsPlayerInDynamicArea(playerid, items_order[i][I_DV_AREA]))
        {
             area = i;
             break;
        }
    }
    return area;
}

CMD:takeitems(playerid)
{
    new item_id = GetPVarInt(playerid, "NearDiverItem");

    if(item_id == -1 || item_id >= MAX_I_DIVER)
        return ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Вы не находитесь рядом с предметом.", "");

    if(items_order[item_id][I_DV_OBJECT] == -1)
        return ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Этот предмет уже подобран.", "");

    if(!GetPlayerDiver(playerid, DIVER_JOOB))
        return ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Устройтесь на работу водолаза.", "");

    if(!GetPlayerDiver(playerid, DIVER_ORDER))
        return ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "У вас нет активного заказа.", "");

    if(items_order[item_id][I_DV_ORDER] != GetPlayerDiver(playerid, DV_ID))
        return ShowNotificationFan4iik(playerid, 2, 6, 0, 0, "Этот предмет не из вашего заказа.", "");

    // Добавляем предмет игроку
    switch(items_order[item_id][I_DV_TYPE])
    {
        case I_DIVER_BOX:
        {
            AddPlayerDiver(playerid, DV_BOX, +, 1);
            UpdatePlayerDatabaseInt(playerid, "box", GetPlayerDiver(playerid, DV_BOX));
            ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы подобрали 'Шкатулку'", "");
        }
        case I_DIVER_TIRE:
        {
            AddPlayerDiver(playerid, DV_TIRE, +, 1);
            UpdatePlayerDatabaseInt(playerid, "tire", GetPlayerDiver(playerid, DV_TIRE));
            ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы подобрали 'Шину'", "");
        }
        case I_DIVER_GOLD:
        {
            AddPlayerDiver(playerid, DV_GOLD, +, 1);
            UpdatePlayerDatabaseInt(playerid, "gold", GetPlayerDiver(playerid, DV_GOLD));
            ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы подобрали 'Слиток золота'", "");
        }
        case I_DIVER_TV:
        {
            AddPlayerDiver(playerid, DV_TV, +, 1);
            UpdatePlayerDatabaseInt(playerid, "television", GetPlayerDiver(playerid, DV_TV));
            ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы подобрали 'Телевизор'", "");
        }
        case I_DIVER_BOOT:
        {
            AddPlayerDiver(playerid, DV_BOOT, +, 1);
            UpdatePlayerDatabaseInt(playerid, "boot", GetPlayerDiver(playerid, DV_BOOT));
            ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы подобрали 'Сапог с кладом'", "");
        }
    }

    // Уничтожаем предмет
    DestroyDiverItems(item_id);
    DeletePVar(playerid, "NearDiverItem");

    // Проверяем остальные предметы...
    new remaining_items = 0;
    new order_id = GetPlayerDiver(playerid, DV_ID);

    for(new i = 0; i < MAX_I_DIVER; i++)
    {
        if(items_order[i][I_DV_ORDER] == order_id && items_order[i][I_DV_OBJECT] != -1)
        {
            remaining_items++;
        }
    }

    if(remaining_items == 0)
    {
        if(order_id >= 0 && order_id < MAX_DIVER)
            order_diver[order_id][DV_P_ID] = -1;

        SetPlayerDiver(playerid, DV_ID, -1);
        SetPlayerDiver(playerid, DIVER_ORDER, false);
        DisablePlayerCheckpoint(playerid);

        ShowNotificationFan4iik(playerid, 1, 6, 0, 0, "Вы собрали все предметы! Возвращайтесь на пирс.", "");
    }
    else
    {
        new str[128];
        format(str, sizeof str, "Осталось собрать предметов: %d", remaining_items);
        ShowNotificationFan4iik(playerid, 1, 6, 0, 0, str, "");
    }

    return 1;
}
stock DestroyDiverItems(id_items)
{
    if(id_items < 0 || id_items >= MAX_I_DIVER) return 0;

    if(items_order[id_items][I_DV_OBJECT] != -1 && IsValidObject(items_order[id_items][I_DV_OBJECT]))
    {
        DestroyObject(items_order[id_items][I_DV_OBJECT]);
    }

    if(items_order[id_items][I_DV_3DTEXT] != Text3D:-1)
    {
        Delete3DTextLabel(items_order[id_items][I_DV_3DTEXT]);
    }

    // Обнуляем все поля
    items_order[id_items][I_DV_OBJECT] = -1;
    items_order[id_items][I_DV_3DTEXT] = Text3D:-1;
    items_order[id_items][I_DV_TYPE] = -1;
    // НЕ обнуляем I_DV_AREA и координаты, они нужны для зоны

    return 1;
}
// Создай функцию для маленькой гангзоны (для водолаза):
stock CreateSmallGangZoneForDiver(playerid, Float:x, Float:y)
{
    // Удаляем старую гангзону если есть
    if(player_diver[playerid][player_dive_gang_zone_collector] != -1)
    {
        GangZoneHideForPlayer(playerid, player_diver[playerid][player_dive_gang_zone_collector]);
        GangZoneDestroy(player_diver[playerid][player_dive_gang_zone_collector]);
    }

    // Создаем маленькую гангзону (размер 50x50 метров - как метка)
    new Float:size = 25.0; // радиус метки (можно изменить на 15.0 или 35.0)

    player_diver[playerid][player_dive_gang_zone_collector] = GangZoneCreate(
        x - size, // минимальный X
        y - size, // минимальный Y
        x + size, // максимальный X
        y + size  // максимальный Y
    );

    // Показываем гангзону игроку (желтый цвет с прозрачностью)
    GangZoneShowForPlayer(playerid, player_diver[playerid][player_dive_gang_zone_collector], 0x00FFFFFF);
    GangZoneFlashForPlayer(playerid, player_diver[playerid][player_dive_gang_zone_collector], 0xFF00EAFF);
    //                                                                                       ^
    //                                                                                       |
    //                                                                                   ARGB цвет: 0x - начало, 00 - прозрачность (00 = прозрачная, FF = непрозрачная), D9FF88 - цвет (желто-зеленый)

    return 1;
}
stock ShowSellDialog(playerid)
{
    new dialog_text[512];
    format
    (
        dialog_text, sizeof dialog_text,
        ""CW"Название\tКоличество\tСтоимость предмета\n"\
        ""CW"Колесо\t{FFFFFF}%d\t{D7FD00}%d\n"\
        ""CW"Аккумулятор\t{FFFFFF}%d\t{D7FD00}%d\n"\
        ""CW"Стиральная машина\t{FFFFFF}%d\t{D7FD00}%d\n"\
        ""CW"Ваза\t{FFFFFF}%d\t{D7FD00}%d\n"\
        ""CW"Бензопила\t{FFFFFF}%d\t{D7FD00}%d",
        GetPlayerDiver(playerid, DV_BOX),
        price_items[0],
        GetPlayerDiver(playerid, DV_TIRE),
        price_items[1],
        GetPlayerDiver(playerid, DV_GOLD),
        price_items[2],
        GetPlayerDiver(playerid, DV_TV),
        price_items[3],
        GetPlayerDiver(playerid, DV_BOOT),
        price_items[4]
    );

    ShowPlayerDialog
    (
        playerid, 2771, DIALOG_STYLE_TABLIST_HEADERS,
        "{FF5252}"FAN4IIK_NAME"{ffffff} | Продажа предметов",
        dialog_text,
        "Продать", "Назад"
    );
}
stock UpdateSellDialog(playerid)
{
    new dialog_text[512];
    format
    (
        dialog_text, sizeof dialog_text,
        ""CW"Название\tКоличество\tСтоимость предмета\n"\
        ""CW"Колесо\t{FFFFFF}%d\t{D7FD00}%d\n"\
        ""CW"Аккумулятор\t{FFFFFF}%d\t{D7FD00}%d\n"\
        ""CW"Стиральная машина\t{FFFFFF}%d\t{D7FD00}%d\n"\
        ""CW"Ваза\t{FFFFFF}%d\t{D7FD00}%d\n"\
        ""CW"Бензопила\t{FFFFFF}%d\t{D7FD00}%d",
        GetPlayerDiver(playerid, DV_BOX),
        price_items[0],
        GetPlayerDiver(playerid, DV_TIRE),
        price_items[1],
        GetPlayerDiver(playerid, DV_GOLD),
        price_items[2],
        GetPlayerDiver(playerid, DV_TV),
        price_items[3],
        GetPlayerDiver(playerid, DV_BOOT),
        price_items[4]
    );

    // Обновляем существующий диалог (не закрывая его)
    ShowPlayerDialog(playerid, 2771, DIALOG_STYLE_TABLIST_HEADERS,
        "{FF5252}"FAN4IIK_NAME"{ffffff} | Продажа предметов",
        dialog_text,
        "Продать", "Назад");
}
stock GetRandomItemPrice(item_type)
{
    new base_price = price_items[item_type];  // 20000
    new random_bonus = random(30000);          // от 0 до 20000
    // random(20001) даёт числа 0-20000 включительно

    new total_price = base_price + random_bonus;
    return total_price;
}
