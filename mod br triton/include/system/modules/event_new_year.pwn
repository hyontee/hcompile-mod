//   https://t.me/welsistudio (Welsi Studio)


enum STRUCT_PLAYER_NEWYEAR
{
    SNOW_COINS,
    NEW_QUEST_1,
    NEW_QUEST_2,
    NEW_QUEST_3,
    NEW_QUEST_4,
    NEW_QUEST_5,
    NEW_QUEST_6,
    NEW_QUEST_7,
    MINI_GAME_GIFT,
    LEFT_ACTOR_1,
    VEH_QUEST
}

new q_1_new[MAX_PLAYERS][5][2];


new player_newyear[MAX_PLAYERS][STRUCT_PLAYER_NEWYEAR];

#define  GetPlayerNewYear(%0,%1)      player_newyear[%0][%1]
#define  SetPlayerNewYear(%0,%1,%2)   player_newyear[%0][%1] = %2
#define  AddPlayerNewYear(%0,%1,%2,%3) player_newyear[%0][%1] %2= %3

#define MAX_BOX_GIFT        30

new shpere_ded_moroz = -1, Float:ded_coord[4] = {-1368.908081,-293.392639,256.228637,223.291610}; // 

new Float:obmen_npc[4] = {-1415.527343,-321.201171,253.228469,326.760772}, shpere_obmen_npc = -1; //

new sphere_mini_game = -1; //mini game
new Text:time_mini_game_TD[3];
new PlayerText:time_mini_game_PTD[MAX_PLAYERS][1];
new m_g_player_gift[MAX_PLAYERS][10][2];

new Float:spawn_mini_game_gift[10][3] =
{
    {310.750427,2150.852050,1765.466308}, 
    {310.386962,2141.088134,1765.466308}, 
    {295.047637,2149.026855,1765.466308}, 
    {298.486175,2162.554931,1765.466308}, 
    {288.946319,2165.655761,1765.466308}, 
    {280.359069,2149.125976,1769.517700}, 
    {289.962005,2148.287353,1769.517700}, 
    {300.852783,2148.245117,1769.517700}, 
    {310.420196,2141.305908,1769.517700}, 
    {312.300781,2157.848144,1769.517700}
};

new m_g_2_player_gift[MAX_PLAYERS][15][2];

new Float:spawn_mini_game_2_gift[15][3] =
{
    {-142.610641,523.442321,12.363361}, 
    {-165.010238,525.383300,12.358304}, 
    {-160.981506,512.740844,12.351570}, 
    {-151.478271,503.945159,12.354825}, 
    {-160.351257,490.668182,12.355174}, 
    {-180.913345,491.733337,12.361758}, 
    {-197.693923,478.224304,12.358208}, 
    {-189.773208,470.285644,12.352597}, 
    {-173.178039,463.344085,12.355031}, 
    {-160.302200,454.453002,12.354372},
    {-154.707305,436.964874,12.354114},
    {-169.246109,428.617492,12.354379},
    {-192.773620,427.349151,12.354078},
    {-202.743530,409.680908,12.356074},
    {-181.308334,397.024200,12.351105}
};
//   https://t.me/welsistudio (Welsi Studio)

new skin_prize[5][2][22] =
{
    {"", 89}, 
    {"", 94}, 
    {"  ", 99}, 
    {"", 122},
    {"  ", 92}
};

enum str_gift_box 
{
    G_ID_pickup,
    Text3D:G_ID_3DText,
    G_ID_SPHERE, 
    bool:GIFT_SPAWN
};

new gift_box[MAX_BOX_GIFT][str_gift_box];

new Float:spawn_gift[MAX_BOX_GIFT][3] =
{
    {-871.683715,476.836334,9.508576},
    {-140.419036,741.287963,12.004516},
    {183.940689,928.399841,12.203125},
    {528.990478,1094.297729,12.667952},
    {238.959350,1273.448730,12.539353},
    {50.015140,1455.999755,10.048901},
    {240.524200,1666.516967,12.000000},
    {2157.804443,-1719.961181,21.358802},
    {2168.470458,-2022.293701,18.812500},
    {1975.177490,-2275.990478,11.265458},
    {2693.166748,-2325.045898,17.908702},
    {-1625.309082,-1762.215087,40.730300},
    {-2209.740966,-1254.475585,48.060493},
    {-2556.830078,-1019.047607,40.822967},
    {-2702.950683,-326.346984,21.766366},
    {-2349.518554,7.998691,25.690904},
    {-2218.739501,49.559570,26.488925},
    {-2031.853881,771.378967,19.263761},
    {-2070.673095,907.811645,16.762613},
    {1850.938354,2235.657714,15.261662},
    {1834.427734,2246.752929,15.271785},
    {1794.559204,2092.842529,15.856098},
    {1725.27890,2409.606445,15.641354},
    {-2389.645507,2760.722167,38.408885},
    {-2407.599121,2781.432617,39.064537},
    {-2445.798339,2771.218505,37.632251},
    {-2457.902587,2798.419433,37.631126},
    {-2452.57887,2831.193115,37.791961},
    {-2507.807128,2891.474365,37.715225},
    {-217.894317,1032.958984,11.997497}
};

enum sctr_quest_1 
{
    SKIN_QUEST_ONE,
    Float:X_QUEST_ONE,
    Float:Y_QUEST_ONE,
    Float:Z_QUEST_ONE,
    Float:A_QUEST_ONE,
    SHPERE_QUEST_ONE
}


new quest_1_ACTOR[5][sctr_quest_1] =
{
    {100, -1645.604370, 717.071594, 32.857723,  274.405487, 0},
    {101, -1394.904418, 409.179290, 31.957427,  324.766296, 0},
    {102, -1304.868408, 697.373046, 16.815217,  302.032531, 0},
    {103, -2298.038330, 157.624710, 27.579511,  209.464248, 0},
    {104, -1988.216064, 621.665222, 28.914386,  288.746643, 0}
};
//   https://t.me/welsistudio (Welsi Studio)
new player_gang_zone[MAX_PLAYERS];

new q_1_player_used[MAX_PLAYERS][5];
new q_2_player_used[MAX_PLAYERS][4];

enum sctr_quest_2
{
    Q_2_SPHERE,
    Text3D:Q_2_3DTEXT
}
new q_2_player[MAX_PLAYERS][4][sctr_quest_2];


new Float:spawn_staff_q_2[4][3] = 
{
    {-2034.014404,-1353.431396,48.192638}, 
    {-2057.868408,-1347.168457,48.192638}, 
    {-2066.864990,-1372.158569,48.192638}, 
    {-2034.391235,-1406.982421,48.622913}
};
//   https://t.me/welsistudio (Welsi Studio)
new q_3_new[MAX_PLAYERS][2];

enum str_dialog_3
{
    Q_3_DIALOG_TITLE[37],
    Q_3_DIALOG[277], 
    Q_3_ANSWER,
    Q_3_BUTTON_1[15], 
    Q_3_BUTTON_2[15]
}

new q_3_dialog[7][str_dialog_3] =
{
    {
        ": {FFFF00}",
        "{FFFF00}:{FFFFFF}  ,    ?\n"\
        "    .       \n"\
        ".        \n"\
        "{858585}[      ]",
        1, 
        "", ""
    }, 

    {
        ": {FFFF00}",
        "{FFFF00}:{FFFFFF}   \n"\
        "   ?      90  \n"\
        "   \n"\
        "{858585}[      ]",
        0,
        "", "BMW F90"
    },

    {
        ": {FFFF00}",
        "{FFFF00}:{FFFFFF}  !\n"\
        "     \n"\
        "{858585}[      ]",
        0,
        "", " "
    },

    {
        ": {FFFF00} (Welsi)",
        "{FFFF00}:{FFFFFF}   !\n"\
        "  ?    ?\n"\
        "   -   \n"\
        " !     \n"\
        "{858585}[      ]",
        1,
        "", ""
    },

    {
        ": {FFFF00}",
        "{FFFF00}:{FFFFFF}   .\n"\
        "     \n"\
        "  !    \n"\
        "{858585}[      ]",
        1,
        "", ""
    },

    {
        ": {FFFF00}",
        "{FFFF00}:{FFFFFF}  ,    ?\n"\
        "    .       \n"\
        "  .        \n"\
        "{858585}[      ]",
        0,
        "", ""
    }, 

    {//   https://t.me/welsistudio (Welsi Studio)
        ": {FFFF00}",
        "{FFFF00}:{FFFFFF}   !\n"\
        "      ! \n"\
        "  .        \n"\
        "{858585}[      ]",
        0,
        "", ""
    }
};

new q_4_new[MAX_PLAYERS][2];

#define DOWN_TYPE 1
#define UP_TYPE 2

enum str_5_actor 
{
    Q_5_SKIN,
    Float:Q_5_X,
    Float:Q_5_Y,
    Float:Q_5_Z,
    Float:Q_5_A,
    TYPE_ANIMATION
}
new q_5_new[MAX_PLAYERS][11];
new q_5_sphere[MAX_PLAYERS][3];

new spawn_actor_5[11][str_5_actor] =
{
    {24, -10.500555,1508.271728,1381.106933,5.466476, DOWN_TYPE}, // ded moroz
    {75, 10.421929,1508.132812,1381.106933,359.76928, DOWN_TYPE},//   https://t.me/welsistudio (Welsi Studio)
    {98, 11.560626,1508.720214,1381.106933,100.51076, DOWN_TYPE},
    {85, -12.051240,1508.915161,1381.106933,278.7384, DOWN_TYPE},
    {62, -8.482763,1516.830688,1381.106933,130.50473, DOWN_TYPE}, 
    {30, -15.935025,1514.664062,1380.997558,273.759552, UP_TYPE}, //up
    {89, -17.341913,1524.273925,1380.997558,357.583129, UP_TYPE},
    {101, -16.856485,1505.129516,1380.997558,11.449227, UP_TYPE},
    {89, 19.169391,1512.351196,1380.997558,278.616210, UP_TYPE},
    {245, 9.629007,1499.574584,1380.997558,277.546264, UP_TYPE}, // sneguroshka quest 1
    {39, 18.135103,1516.698852,1380.997558,0.96914, UP_TYPE} // osen quest 1
};

new Float:end_actor[11][4] =
{
    {0.375752,1512.299804,1380.997558,175.108032},
    {1.689315,1515.609497,1380.997558,178.299804},
    {-0.205984,1514.786254,1380.997558,191.92041},
    {-2.431180,1515.563232,1380.997558,213.68240},
    {-3.878937,1514.416748,1380.997558,225.08537},
    {-4.729636,1515.711303,1381.106933,230.77725},
    {3.437696,1515.154174,1380.997558,129.113174},
    {2.789716,1516.851196,1380.997558,162.876068},
    {3.346609,1512.780151,1381.004882,136.285934},
    {1.310970,1512.209838,1380.997558,138.737945},//   https://t.me/welsistudio (Welsi Studio)
    {-2.154932,1512.037109,1381.004882,213.81146}
};
public SYS_EVENT_NEW_YEAR_OnPlayerSpawn(playerid)
{
    SetTimerEx("NotifSnow", 2000, false, "i", playerid);
    #if defined snow_OnPlayerSpawn
        return snow_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_EVENT_NEW_YEAR_OnPlayerSpawn
    #undef SYS_EVENT_NEW_YEAR_OnPlayerSpawn
#else
    #define _ALS_SYS_EVENT_NEW_YEAR_OnPlayerSpawn
#endif
#define SYS_EVENT_NEW_YEAR_OnPlayerSpawn snow_OnPlayerSpawn
#if defined snow_OnPlayerSpawn
    forward snow_OnPlayerSpawn(playerid);
#endif

public:NotifSnow(playerid)
{
    SendClientMessage(playerid, -1, "   {FFFF00}   -");
    SendClientMessage(playerid, -1, "    - {FFFF00}/newyear");
    return 1;
}

public SYS_EVENT_NEW_YEAR_OnPlayerDisconnect(playerid, reason)
{
    UnLoadPlayerData_NewYear(playerid);
    #if defined snow_OnPlayerDisconnect
        return snow_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_EVENT_NEW_YEAR_OnPlayerDisconnect
    #undef SYS_EVENT_NEW_YEAR_OnPlayerDisconnect
#else
    #define _ALS_SYS_EVENT_NEW_YEAR_OnPlayerDisconnect
#endif
#define SYS_EVENT_NEW_YEAR_OnPlayerDisconnect snow_OnPlayerDisconnect
#if defined snow_OnPlayerDisconnect
    forward snow_OnPlayerDisconnect(playerid, reason);
#endif

public SYS_EVENT_NEW_YEAR_OnPlayerConnect(playerid)
{
    SetTimerEx("LoadPlayerData_NewYear", 10000, false, "i", playerid);
    #if defined snow_OnPlayerConnect
        return snow_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_EVENT_NEW_YEAR_OnPlayerConnect
    #undef SYS_EVENT_NEW_YEAR_OnPlayerConnect
#else
    #define _ALS_SYS_EVENT_NEW_YEAR_OnPlayerConnect
#endif
#define SYS_EVENT_NEW_YEAR_OnPlayerConnect snow_OnPlayerConnect
#if defined snow_OnPlayerConnect
    forward snow_OnPlayerConnect(playerid);
#endif
//   https://t.me/welsistudio (Welsi Studio)
public SYS_EVENT_NEW_YEAR_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 4430)
    {
        if(response)
        {
            new Float:pos_player[3];
            GetPlayerPos(playerid, pos_player[0], pos_player[1], pos_player[2]);

            InterpolateCameraPos(playerid, pos_player[0], pos_player[1], pos_player[2], -1413.925292,-318.783538,253.228469, 1500, CAMERA_MOVE);
            InterpolateCameraLookAt(playerid, ded_coord[0], ded_coord[1], ded_coord[2], obmen_npc[0], obmen_npc[1], obmen_npc[2], 1500, CAMERA_MOVE);
            

            Dialog
            (
                playerid, 4433, DIALOG_STYLE_MSGBOX,
                " ",
                "      \n"\
                "  ,     ",
                "", ""
            );
        }//   https://t.me/welsistudio (Welsi Studio)
        else ShowDialogQuestNewYear(playerid);
    }
    if(dialogid == 4433)
    {

        InterpolateCameraPos(playerid, -1413.925292,-318.783538,253.228469, -1375.116943,-277.131561,256.216766, 1500, CAMERA_MOVE);
        InterpolateCameraLookAt(playerid, obmen_npc[0], obmen_npc[1], obmen_npc[2], -1376.658691,-277.933319,256.216766, 1500, CAMERA_MOVE);

        Dialog
        (
            playerid, 4434, DIALOG_STYLE_MSGBOX,
            "-",
            "{FFFF00}-{FFFFFF}: , , \n"\
            "    \n"\
            "   : {FFFF00}\" \"  {FFFF00}\"  \"",
            "", ""
        );       
    }
    if(dialogid == 4434)
    {
        SetCameraBehindPlayer(playerid);

        Dialog
        (
            playerid, 4435, DIALOG_STYLE_MSGBOX,
            " ",
            "   ,      -,  \n"\
            "      {0E0E04}  {FFFFFFF}. ?",
            "", ""
        );       
    }//   https://t.me/welsistudio (Welsi Studio)
    if(dialogid == 4435) ShowDialogQuestNewYear(playerid);

    if(dialogid == 4431)
    {
        if(response)
        {
            switch(listitem + 1)
            {
                case 1:
                {
                    if(GetPlayerNewYear(playerid, NEW_QUEST_1) == 0)
                    {
                        Dialog
                        (
                            playerid, 4432, DIALOG_STYLE_MSGBOX,
                            "  |   ",
                            "   5    \n"\
                            "  : {FFFF00}150 ",
                            "", ""
                        );
                    }
                    else
                    {
                        if(GetPlayerNewYear(playerid, NEW_QUEST_1) == 1)
                        {
                            quest_get_prize(playerid, 1);
                            SendClientMessage(playerid, -1, ""SC" !      ");
                            SendClientMessage(playerid, -1, ""SC" : 150 ");
                        }
                    }
                }
                case 2:
                {
                    if(GetPlayerNewYear(playerid, NEW_QUEST_2) == 0)
                    {
                        Dialog
                        (
                            playerid, 4446, DIALOG_STYLE_MSGBOX,
                            "  |  ",
                            "       \n"\
                            "   \n"\
                            "  : {FFFF00}300 ",
                            "", ""
                        );
                    }
                    else
                    {
                        if(GetPlayerNewYear(playerid, NEW_QUEST_2) == 1)
                        {
                            quest_get_prize(playerid, 2);
                            SendClientMessage(playerid, -1, ""SC" !      ");
                            SendClientMessage(playerid, -1, ""SC" : 300 ");
                        }
                    }            
                }
                case 3:
                {
                    if(GetPlayerNewYear(playerid, NEW_QUEST_3) == 0)
                    {
                        Dialog
                        (
                            playerid, 4447, DIALOG_STYLE_MSGBOX,
                            "  |  ",
                            "     \n"\
                            "  : {FFFF00}500 ",
                            "", ""
                        );
                    }
                    else
                    {
                        if(GetPlayerNewYear(playerid, NEW_QUEST_3) == 1)
                        {
                            quest_get_prize(playerid, 3);
                            SendClientMessage(playerid, -1, ""SC" !      ");
                            SendClientMessage(playerid, -1, ""SC" : 500 ");
                        }
                    }            
                }
                case 4:
                {
                    if(GetPlayerNewYear(playerid, NEW_QUEST_4) == 0)
                    {
                        Dialog
                        (
                            playerid, 4448, DIALOG_STYLE_MSGBOX,
                            "  |  ",
                            "-   .       \n"\
                            " ,  .\n"\
                            "         !\n"\
                            "  : {FFFF00}1000 ",
                            "", ""
                        );
                    }
                    else
                    {
                        if(GetPlayerNewYear(playerid, NEW_QUEST_4) == 1)
                        {
                            quest_get_prize(playerid, 4);
                            SendClientMessage(playerid, -1, ""SC" !      ");
                            SendClientMessage(playerid, -1, ""SC" : 1000 ");
                        }
                    }            
                }
                case 5:
                {
                    if(GetPlayerNewYear(playerid, NEW_QUEST_5) == 0)
                    {
                        Dialog
                        (
                            playerid, 4449, DIALOG_STYLE_MSGBOX,
                            "  |   !",
                            "    \n"\
                            "  {FFFF00}\n"\
                            "{FFFFFF}    \n"\
                            "  : {FFFF00}2025 ",
                            "", ""
                        );
                    }
                    else
                    {
                        if(GetPlayerNewYear(playerid, NEW_QUEST_5) == 1)
                        {
                            quest_get_prize(playerid, 5);
                            SendClientMessage(playerid, -1, ""SC" !      ");
                            SendClientMessage(playerid, -1, ""SC" : 2025 ");
                        }
                    }            
                }
                case 6:
                {
                    if(GetPlayerNewYear(playerid, NEW_QUEST_6) == 0)
                    {
                        Dialog
                        (
                            playerid, -1, DIALOG_STYLE_MSGBOX,
                            "  |   \" \"",
                            "      \" \"\n"\
                            "  : {FFFF00}500 ",
                            "", ""
                        );
                    }
                    else
                    {
                        if(GetPlayerNewYear(playerid, NEW_QUEST_6) == 1)
                        {
                            quest_get_prize(playerid, 6);
                            SendClientMessage(playerid, -1, ""SC" !      ");
                            SendClientMessage(playerid, -1, ""SC" : 500 ");
                        }
                    } 
                }
                case 7:
                {
                    if(GetPlayerNewYear(playerid, NEW_QUEST_7) == 0)
                    {
                        Dialog
                        (
                            playerid, -1, DIALOG_STYLE_MSGBOX,
                            "  |   \"  \"",
                            "      \"  \"\n"\
                            "  : {FFFF00}500 ",
                            "", ""
                        );
                    }
                    else
                    {
                        if(GetPlayerNewYear(playerid, NEW_QUEST_7) == 1)
                        {
                            quest_get_prize(playerid, 7);
                            SendClientMessage(playerid, -1, ""SC" !      ");
                            SendClientMessage(playerid, -1, ""SC" : 500 ");
                        }
                    } 
                }
            }
        }
    }
    if(dialogid == 4432)
    {
        if(response)
        {
            new vehicle; //   https://t.me/welsistudio (Welsi Studio)

            SetPlayerVirtualWorld(playerid, playerid + 100);

            vehicle = CreateVehicle(411, -1797.217041,777.892517,34.518367,53.681762, 1, 1, -1);
            SetVehicleVirtualWorld(vehicle, GetPlayerVirtualWorld(playerid));
            PutPlayerInVehicle(playerid, vehicle, 0);

            SetPlayerNewYear(playerid, VEH_QUEST, vehicle);

            SendClientMessage(playerid, -1, ""SC"    {FFFF00}\"  \"");
            SendClientMessage(playerid, -1, ""SC"     -");
            SendClientMessage(playerid, -1, ""SC"     {FFFF00} /exitsnowquest");

            SetPlayerCheckpoint(playerid, quest_1_ACTOR[4][X_QUEST_ONE], quest_1_ACTOR[4][Y_QUEST_ONE], quest_1_ACTOR[4][Z_QUEST_ONE], 8.0);
            SetPVarInt(playerid, "quest_1_new_year", 1);
            SetPlayerNewYear(playerid, LEFT_ACTOR_1, 5);
            LoadQuestNewYear(playerid, 1);
        }
        else ShowDialogQuestNewYear(playerid);

    }
    if(dialogid == 4446)
    {
        if(response)
        {
            if(GetPlayerNewYear(playerid, NEW_QUEST_1) == 0) return SendClientMessage(playerid, -1, ""USC"    ");

            new vehicle;

            SetPlayerVirtualWorld(playerid, playerid + 100);

            vehicle = CreateVehicle(411, -1797.217041,777.892517,34.518367,53.681762, 1, 1, -1);
            SetVehicleVirtualWorld(vehicle, GetPlayerVirtualWorld(playerid));
            PutPlayerInVehicle(playerid, vehicle, 0);

            SetPlayerNewYear(playerid, VEH_QUEST, vehicle);

            SendClientMessage(playerid, -1, ""SC"    {FFFF00}\" \"");
            SendClientMessage(playerid, -1, ""SC"    {FF0000} ");
            SendClientMessage(playerid, -1, ""SC"     {FFFF00} /exitsnowquest");
            SetPVarInt(playerid, "quest_2_new_year", 1);
            LoadQuestNewYear(playerid, 2);               
        }
        else ShowDialogQuestNewYear(playerid);
    }
    if(dialogid == 4447)
    {
        if(response)
        {
            if(GetPlayerNewYear(playerid, NEW_QUEST_2) == 0) return SendClientMessage(playerid, -1, ""USC"    ");

            new vehicle;

            SetPlayerVirtualWorld(playerid, playerid + 100);

            vehicle = CreateVehicle(411, -1797.217041,777.892517,34.518367,53.681762, 1, 1, -1);
            SetVehicleVirtualWorld(vehicle, GetPlayerVirtualWorld(playerid));
            PutPlayerInVehicle(playerid, vehicle, 0);

            SetPlayerNewYear(playerid, VEH_QUEST, vehicle);

            SendClientMessage(playerid, -1, ""SC"    {FFFF00}\" \"");
            SendClientMessage(playerid, -1, ""SC"     {FFFF00} /exitsnowquest");
            SetPVarInt(playerid, "quest_3_new_year", 1);
            LoadQuestNewYear(playerid, 3);        
       }
       else ShowDialogQuestNewYear(playerid);
    }
    if(dialogid == 4448)
    {
        if(response)
        {
            if(GetPlayerNewYear(playerid, NEW_QUEST_3) == 0) return SendClientMessage(playerid, -1, ""USC"    ");

            new vehicle;

            SetPlayerVirtualWorld(playerid, playerid + 100);

            vehicle = CreateVehicle(411, -1797.217041,777.892517,34.518367,53.681762, 1, 1, -1);
            SetVehicleVirtualWorld(vehicle, GetPlayerVirtualWorld(playerid));
            PutPlayerInVehicle(playerid, vehicle, 0);

            SetPlayerNewYear(playerid, VEH_QUEST, vehicle);

            SendClientMessage(playerid, -1, ""SC"    {FFFF00}\" \"");
            SendClientMessage(playerid, -1, ""SC"     {FFFF00} /exitsnowquest");
            SetPVarInt(playerid, "quest_4_new_year", 1);
            LoadQuestNewYear(playerid, 4);        
       }
       else ShowDialogQuestNewYear(playerid);
    }
    if(dialogid == 4449)
    {
        if(response)
        {
            if(GetPlayerNewYear(playerid, NEW_QUEST_4) == 0) return SendClientMessage(playerid, -1, ""USC"    ");

            new vehicle;

            SetPlayerVirtualWorld(playerid, playerid + 10000);

            SendClientMessage(playerid, -1, ""SC"    {FFFF00}\"  !\"");
            SendClientMessage(playerid, -1, ""SC"     {FFFF00} /exitsnowquest");
            SetPVarInt(playerid, "quest_5_new_year", 1);
            LoadQuestNewYear(playerid, 5);        
       }
       else ShowDialogQuestNewYear(playerid);        
    }
    if(dialogid == 4451)
    {
        if(!(GetPVarInt(playerid, "count_letter")))
        {
            if(response)
            {
                SendClientMessage(playerid, -1, ""SC"    ");
                SetPVarInt(playerid, "count_letter", 1);
                SetPVarInt(playerid, "count_letter_wrong", 0);

                ShowDialogQuest3(playerid, 0);
            } 
        }
        else
        {
            switch(GetPVarInt(playerid, "count_letter") - 1)
            {
                case 0: if(q_3_dialog[0][Q_3_ANSWER] != response) SetPVarInt(playerid, "count_letter_wrong", GetPVarInt(playerid, "count_letter_wrong") + 1);
                case 1: if(q_3_dialog[1][Q_3_ANSWER] != response) SetPVarInt(playerid, "count_letter_wrong", GetPVarInt(playerid, "count_letter_wrong") + 1);
                case 2: if(q_3_dialog[2][Q_3_ANSWER] != response) SetPVarInt(playerid, "count_letter_wrong", GetPVarInt(playerid, "count_letter_wrong") + 1);
                case 3: if(q_3_dialog[3][Q_3_ANSWER] != response) SetPVarInt(playerid, "count_letter_wrong", GetPVarInt(playerid, "count_letter_wrong") + 1);
                case 4: if(q_3_dialog[4][Q_3_ANSWER] != response) SetPVarInt(playerid, "count_letter_wrong", GetPVarInt(playerid, "count_letter_wrong") + 1);
                case 5: if(q_3_dialog[5][Q_3_ANSWER] != response) SetPVarInt(playerid, "count_letter_wrong", GetPVarInt(playerid, "count_letter_wrong") + 1);
                case 6: if(q_3_dialog[6][Q_3_ANSWER] != response) SetPVarInt(playerid, "count_letter_wrong", GetPVarInt(playerid, "count_letter_wrong") + 1);
            }

            new letter = GetPVarInt(playerid, "count_letter") + 1;

            SetPVarInt(playerid, "count_letter", GetPVarInt(playerid, "count_letter") + 1);

            ShowDialogQuest3(playerid, letter - 1);
        }

    }
    if(dialogid == 4452)
    {
        if(!(GetPVarInt(playerid, "dialog_progress")))
        {
            if(!response) return SendClientMessage(playerid, -1, "{FF3535}      ???");

            Dialog(playerid, 4452, DIALOG_STYLE_MSGBOX, "", "...     ", "", "");

            SetPVarInt(playerid, "dialog_progress", 2);
        }
        else
        {
            switch(GetPVarInt(playerid, "dialog_progress"))
            {
                case 2:
                {
                    if(!response) RemoveQuestNewYear(playerid, 4);
                    else{
                    Dialog(playerid, 4452, DIALOG_STYLE_MSGBOX, "", "   {FFFF00} ...{FFFFFF}\n,    ?", "", "");
                    SetPVarInt(playerid, "dialog_progress", GetPVarInt(playerid, "dialog_progress") + 1);  
                    }                  
                }
                case 3:
                {
                    if(!response)
                    {
                        SendClientMessage(playerid, -1, "{FF7300}:{FFFFFF}  ...   ");
                        RemoveQuestNewYear(playerid, 4);
                    }
                    else
                    {
                        new text[106];

                        format(text, sizeof text, "{FFFF00}%s {FFFFFF}  !\n   {FFFF00}", GetPlayerNameEx(playerid));
                        
                        Dialog(playerid, 4452, DIALOG_STYLE_MSGBOX, "", text, "", "");
                        SetPVarInt(playerid, "dialog_progress", GetPVarInt(playerid, "dialog_progress") + 1);     
                    }
                }
                case 4:
                {
                    if(!response) RemoveQuestNewYear(playerid, 4);
                    else{

                        Dialog
                        (
                            playerid, 4452, DIALOG_STYLE_MSGBOX, 
                            "", 
                            "    ?\n"\
                            "{FFFF00} {FFFFFF}    ?\n"\
                            "{BBBBBB}[1 ]:   \n"\
                            "[2 ]: ", 
                            "1", "2"
                        );

                        SetPVarInt(playerid, "dialog_progress", GetPVarInt(playerid, "dialog_progress") + 1);         
                    }
                }
                case 5:
                {
                    if(!response)
                    {
                        Dialog(playerid, 4452, DIALOG_STYLE_MSGBOX, "", "!       \n  ...", "?", "");
                        SetPVarInt(playerid, "dialog_progress", 111); 
                    }
                    else
                    {
                        Dialog(playerid, 4452, DIALOG_STYLE_MSGBOX, "", "    ...\n (a)  - ?", "", "");
                        SetPVarInt(playerid, "dialog_progress", GetPVarInt(playerid, "dialog_progress") + 1);                         
                    }
                }
                case 6:
                {
                    if(response)
                    {
                        Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, "", "{FF0000}  \n   ,   !!!", "...", "...");
                        RemoveQuestNewYear(playerid, 4);
                    }
                    else
                    {
                        Dialog
                        (
                            playerid, 4452, DIALOG_STYLE_MSGBOX, 
                            "", 
                            "  !\n"\
                            "      ...\n"\
                            "    \n"\
                            "{BBBBBB}[1 ]:   \n"\
                            "[2 ]: {FF9292}   ", 
                            "1", "2"
                        );
                        SetPVarInt(playerid, "dialog_progress", GetPVarInt(playerid, "dialog_progress") + 1);                         
                    }
                }
                case 7:
                {
                    if(!response)
                    {
                        RemoveQuestNewYear(playerid, 4);

                        Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, ";?*(?;*", "u nD X H LN!", "", "");
                    }
                    else
                    {
                        Dialog
                        (
                            playerid, -1, DIALOG_STYLE_MSGBOX, 
                            "", 
                            "...  {FFFF00} {FFFFFF} !\n"\
                            "   .   .\n"\
                            ",   ", 
                            "", ""
                        );

                        RemoveQuestNewYear(playerid, 4);
                        quest_complete(playerid, 4);
                    }
                }
                case 111:
                {
                    if(!response) RemoveQuestNewYear(playerid, 4);
                    else{
                        Dialog
                        (
                            playerid, 4452, DIALOG_STYLE_MSGBOX, 
                            "", 
                            "...    \n"\
                            "  ,   \n"\
                            "   \n"\
                            " .    \n"\
                            "   \n"\
                            "{BBBBBB}[]:   ", 
                            "", ""
                        );

                        SetPVarInt(playerid, "dialog_progress", 7);
                    }
                }
            }
        }
    }
    if(dialogid == 4453)
    {
        for(new p; p < 11;p++)
        {
            SetActorPos(q_5_new[playerid][p], end_actor[p][0], end_actor[p][1], end_actor[p][2]);
            SetActorFacingAngle(q_5_new[playerid][p], end_actor[p][3]);
        }

        for(new p; p < 11;p++)
        {
            ClearActorAnimations(q_5_new[playerid][p]);
        }


        SetPlayerCameraPos(playerid, 0.517406,1506.577148,1381.00);
        SetPlayerCameraLookAt(playerid, 0.375752,1512.299804,1380.397558);

        Dialog
        (
            playerid, 4437, DIALOG_STYLE_MSGBOX, 
            " ",
            " ,    \n"\
            "        \" \"\n"\
            ""SC"     \"\" \n"\
            ""USC"    \"\"      ",
            "", ""
        );
    }
    if(dialogid == 4437) //gift prize (end)
    {
        if(!(GetPVarInt(playerid, "prize_count")))
        {
            if(response)
            {
                SetPlayerData(playerid, P_SKIN, 24);
                UpdatePlayerDatabaseInt(playerid, "skin", 24);
                SetPlayerSkinInit(playerid);
                SendClientMessage(playerid, -1, ""SC"    ");
            }

            Dialog
            (
                playerid, 4437, DIALOG_STYLE_MSGBOX,
                " ",
                "   ...    : {FFFF00}\n"\
                ""SC"     \"\" \n"\
                ""USC"    \"\"      ",
                "", ""
            );

            SetPVarInt(playerid, "prize_count", 1);
        }
        else
        {
            if(response)
            {
                if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
                {
                    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                	UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                }
                GivePlayerWinterCar(playerid, 471);
                
                SendClientMessage(playerid, -1, ""SC"    ");
            }

            Dialog
            (
                playerid, 4450, DIALOG_STYLE_MSGBOX, 
                " ",
                "   \n"\
                "    ...\n"\
                "{FFFF00} !",
                "", ""
            );

            SendClientMessage(playerid, -1, "{B9B9B9}:{FFFF00}  ");
            SendClientMessage(playerid, -1, "{B9B9B9}:{FFFF00}  ");
            SendClientMessage(playerid, -1, "{B9B9B9}:{FFFF00}  ");

            DeletePVar(playerid, "prize_count");
        }
    }
    if(dialogid == 4450)
    {
        SetCameraBehindPlayer(playerid);

        Dialog
        (
            playerid, -1, DIALOG_STYLE_MSGBOX, 
            "{FFFF00}   !",
            "     \n"\
            "  .     \n"\
            " , , .\n"\
            "      !\n\n\n\n"\
            ":https://t.me/welsistudio (Welsi Studio)",
            "", ""
        );

        RemoveQuestNewYear(playerid, 5);
        quest_complete(playerid, 5);
    }
    if(dialogid == 4438) //box open
    {
        if(response)
        {
            if(GetPVarInt(playerid, "gift_skin"))
            {
                SetPlayerData(playerid, P_SKIN, skin_prize[GetPVarInt(playerid, "gift_skin")][1][sizeof skin_prize]);
                UpdatePlayerDatabaseInt(playerid, "skin", skin_prize[GetPVarInt(playerid, "gift_skin")][1][sizeof skin_prize]);
                SetPlayerSkinInit(playerid);
                SendClientMessage(playerid, -1, ""SC" !   ");
            }
            else{

                new money = GetPVarInt(playerid, "gift_money"), donate = GetPVarInt(playerid, "gift_donate"), exp = GetPVarInt(playerid, "gift_exp"), text[114];
                GivePlayerMoneyEx(playerid, money);
                GivePlayerDonateRub(playerid, donate);
                AddPlayerData(playerid, P_EXP, +, exp);
                UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));

                format(text, sizeof text, "  {FFFF00}%d {FFFFFF}, {FFFF00}%d{FFFFFF} -, {FFFF00}%d{FFFFFF} ", money, donate, exp);
                SendClientMessage(playerid, -1, text);
            }
  
        }
    }
    if(dialogid == 4439)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {    
                    new virtual  = playerid + 10000;

                    SetPlayerVirtualWorld(playerid, virtual);

                    LoadMiniGame(playerid, 1);
                    SendClientMessage(playerid, -1, "   - {FFFF00}\" \"");
                }
                case 1:
                {    
                    new virtual  = playerid + 10000;

                    SetPlayerVirtualWorld(playerid, virtual);

                    LoadMiniGame(playerid, 2);
                    SendClientMessage(playerid, -1, "   - {FFFF00}\"  \"");
                }
            }
        }
    }
    if(dialogid == 4440)
    {
        if(response)
        {
            new text[234];
            switch(listitem)
            {
                case 0:
                {
                        format(
                            text, sizeof text, 
                            "      \n"\
                            "     : 1  - 500 . \n"\
                            "    : {FFFF00}%d{FFFFFF}  \n"\
                            "     ",
                            GetPlayerNewYear(playerid, SNOW_COINS) 
                        );

                        Dialog
                        (
                            playerid, 4441, DIALOG_STYLE_INPUT, 
                            " ", 
                            text, 
                            "", ""
                        );
                }
                case 1:
                {
                        format(
                            text, sizeof text, 
                            "     \n"\
                            "     : 1 - - 10 \n"\
                            "    : {FFFF00}%d{FFFFFF} - \n"\
                            "     ",
                            GetPlayerDonateRub(playerid)
                        );

                        Dialog
                        (
                            playerid, 4443, DIALOG_STYLE_INPUT, 
                            " ", 
                            text, 
                            "", ""
                        );
                }
                case 2:
                {
                    format(text, sizeof text, "    | : %d", GetPlayerNewYear(playerid, SNOW_COINS));

                    Dialog
                    (
                        playerid, 4442, DIALOG_STYLE_LIST, 
                        text,
                        "1.  \t\t\t {FFFF00}1000{FFFFFF} \n"\
                        "2.  \t\t\t {FFFF00}3000{FFFFFF} \n"\
                        "3.    \t\t\t {FFFF00}10000{FFFFFF} \n"\
                        "4.  \t\t\t {FFFF00}30000{FFFFFF} \n"\
                        "5.    \t\t\t {FFFF00}10000{FFFFFF} ",
                        "", ""
                    );
                }    
                case 3:
                {
                    format(text, sizeof text, "    | : %d", GetPlayerNewYear(playerid, SNOW_COINS));

                    Dialog
                    (
                        playerid, 4445, DIALOG_STYLE_LIST, 
                        text,
                        "1. BMW M3 E30\t\t\t {FFFF00}10000{FFFFFF} \n"\
                        "2. \t\t\t {FFFF00}25000{FFFFFF} \n"\
                        "3. Mitsubishi Lancer Evo X\t\t\t {FFFF00}30000{FFFFFF} \n"\
                        "4. \t\t\t {FFFF00}50000{FFFFFF} \n"\
                        "5. BMW M5 F90\t\t\t {FFFF00}100000{FFFFFF} ",
                        "", ""
                    );
                }   
                case 4:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 1000)
                    {
						AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
						UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

                        AddPlayerNewYear(playerid, SNOW_COINS, -, 1000);
                        UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));
                        
						SendClientMessage(playerid, -1, ""SC"      ");

                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");

                    SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea(playerid, shpere_obmen_npc);
                } 
                case 5:
                {
                        format(
                            text, sizeof text, 
                            "     \n"\
                            "     : 100  - 1 \n"\
                            "    : {FFFF00}%d{FFFFFF}  \n"\
                            "     ",
                            GetPlayerNewYear(playerid, SNOW_COINS) 
                        );

                        Dialog
                        (
                            playerid, 4444, DIALOG_STYLE_INPUT, 
                            " ", 
                            text, 
                            "", ""
                        );
                }
            }
        }
        
    }

    if(dialogid == 4441)
    {
        if(response)
        {
            new count = strval(inputtext), give = count * 500, text[144];

            if(!count) return 1;

            if(GetPlayerNewYear(playerid, SNOW_COINS) >= count)
            {
                AddPlayerNewYear(playerid, SNOW_COINS, -, count);
                UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                GivePlayerMoneyEx(playerid, give);

                format(text, sizeof text, "   %d   %d  ", count, give);
                SendClientMessage(playerid, -1, text);
            }
        }
        else SendClientMessage(playerid, -1, ""USC"    ");

        SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea(playerid, shpere_obmen_npc);
    }
    if(dialogid == 4443)
    {
        if(response)
        {
            new count = strval(inputtext), give = count * 10, text[144];

            if(!count) return 1;

            if(GetPlayerDonateRub(playerid) >= count)
            {
                AddPlayerNewYear(playerid, SNOW_COINS, +, give);
                UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));
    
                GivePlayerDonateRub(playerid, - count);
    
                format(text, sizeof text, "   %d -  %d ", count, give);
                SendClientMessage(playerid, -1, text);                
            }
            else SendClientMessage(playerid, -1, ""USC"    -");
        }

        SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea(playerid, shpere_obmen_npc);
    }
    if(dialogid == 4444)
    {
        if(response)
        {
            new give = strval(inputtext), count = give * 100, text[144];

            if(!count) return 1;

            if(GetPlayerNewYear(playerid, SNOW_COINS) >= count)
            {
                AddPlayerNewYear(playerid, SNOW_COINS, -, count);
                UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));
    
                AddPlayerData(playerid, P_EXP, +, give);
				UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));

                if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
		        {
		        	SetPlayerData(playerid, P_EXP, 0);
		        	AddPlayerData(playerid, P_LEVEL, +, 1);

		        	SetPlayerLevelInit(playerid);
		        	SendClientMessage(playerid, -1, "!   ");
		        }
    
                format(text, sizeof text, "   %d   %d ", count, give);
                SendClientMessage(playerid, -1, text);                
            }
            else SendClientMessage(playerid, -1, ""USC"    ");
        }

        SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea(playerid, shpere_obmen_npc);
    }
    if(dialogid == 4442)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 1000)
                    {
                        AddPlayerNewYear(playerid, SNOW_COINS, -, 1000);
                        UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                        SendClientMessage(playerid, -1, ""USC"    {FFFF00}\"\"");
                        SetPlayerData(playerid, P_SKIN, 89);
	                    UpdatePlayerDatabaseInt(playerid, "skin", 89);
	                    SetPlayerSkinInit(playerid);
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
                case 1:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 3000)
                    {
                        AddPlayerNewYear(playerid, SNOW_COINS, -, 3000);
                        UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                        SendClientMessage(playerid, -1, ""USC"    {FFFF00}\"\"");
                        SetPlayerData(playerid, P_SKIN, 94);
	                    UpdatePlayerDatabaseInt(playerid, "skin", 94);
	                    SetPlayerSkinInit(playerid);
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
                case 2:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 10000)
                    {
                        AddPlayerNewYear(playerid, SNOW_COINS, -, 10000);
                        UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                        SendClientMessage(playerid, -1, ""USC"    {FFFF00}\"  \"");
                        SetPlayerData(playerid, P_SKIN, 99);
	                    UpdatePlayerDatabaseInt(playerid, "skin", 99);
	                    SetPlayerSkinInit(playerid);
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
                case 3:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 30000)
                    {
                        AddPlayerNewYear(playerid, SNOW_COINS, -, 30000);
                        UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                        SendClientMessage(playerid, -1, ""USC"    {FFFF00}\"\"");
                        SetPlayerData(playerid, P_SKIN, 122);
	                    UpdatePlayerDatabaseInt(playerid, "skin", 122);
	                    SetPlayerSkinInit(playerid);
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
                case 4:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 10000)
                    {
                        AddPlayerNewYear(playerid, SNOW_COINS, -, 10000);
                        UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                        SendClientMessage(playerid, -1, ""USC"    {FFFF00}\"  \"");
                        SetPlayerData(playerid, P_SKIN, 92);
	                    UpdatePlayerDatabaseInt(playerid, "skin", 92);
	                    SetPlayerSkinInit(playerid);
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
            }
            SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea(playerid, shpere_obmen_npc);
        }
    }
    if(dialogid == 4445)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 10000)
                    {
                        if((GetPlayerOwnableCars(playerid) + 1) < GetPlayerCarSlots(playerid))
                        {
                             AddPlayerNewYear(playerid, SNOW_COINS, -, 10000);
                             UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                             SendClientMessage(playerid, -1, ""SC" !    {FFFF00}\"BMW M3 E30\"");
                             GivePlayerWinterCar(playerid, 534);
                        }
                        else SendClientMessage(playerid, 0x3399FFFF, ""USC"    .    : {FFFF00}/donate");
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
                case 1:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 25000)
                    {
                        if((GetPlayerOwnableCars(playerid) + 1) < GetPlayerCarSlots(playerid))
                        {
                             AddPlayerNewYear(playerid, SNOW_COINS, -, 25000);
                             UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                             SendClientMessage(playerid, -1, ""SC" !    {FFFF00}\"\"");
                             GivePlayerWinterCar(playerid, 471);
                        }
                        else SendClientMessage(playerid, 0x3399FFFF, ""USC"    .    : {FFFF00}/donate");
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
                case 2:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 30000)
                    {
                        if((GetPlayerOwnableCars(playerid) + 1) <= GetPlayerCarSlots(playerid))
                        {
                             AddPlayerNewYear(playerid, SNOW_COINS, -, 30000);
                             UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                             SendClientMessage(playerid, -1, ""SC" !    {FFFF00}\"Mitsubishi Lancer Evo X\"");
                             GivePlayerWinterCar(playerid, 436);
                        }
                        else SendClientMessage(playerid, 0x3399FFFF, ""USC"    .    : {FFFF00}/donate");
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
                case 3:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 50000)
                    {
                        if((GetPlayerOwnableCars(playerid) + 1) < GetPlayerCarSlots(playerid))
                        {
                             AddPlayerNewYear(playerid, SNOW_COINS, -, 50000);
                             UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                             SendClientMessage(playerid, -1, ""SC" !    {FFFF00}\"\"");
                             GivePlayerWinterCar(playerid, 571);
                        }
                        else SendClientMessage(playerid, 0x3399FFFF, ""USC"    .    : {FFFF00}/donate");
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
                case 4:
                {
                    if(GetPlayerNewYear(playerid, SNOW_COINS) >= 100000)
                    {
                        if((GetPlayerOwnableCars(playerid) + 1) < GetPlayerCarSlots(playerid))
                        {
                             AddPlayerNewYear(playerid, SNOW_COINS, -, 10000);
                             UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS));

                             SendClientMessage(playerid, -1, ""SC" !    {FFFF00}\"BMW M5 F90\"");
                             GivePlayerWinterCar(playerid, 466);
                        }
                        else SendClientMessage(playerid, 0x3399FFFF, ""USC"    .    : {FFFF00}/donate");
                    }
                    else SendClientMessage(playerid, -1, ""USC"    ");
                }
            }
        }
    }
    #if defined snow_OnDialogResponse
return snow_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_SYS_EVENT_NEW_YEAR_OnDialogResponse
#undef SYS_EVENT_NEW_YEAR_OnDialogResponse
#else
#define _ALS_SYS_EVENT_NEW_YEAR_OnDialogResponse //   https://t.me/welsistudio (Welsi Studio)
#endif
#define SYS_EVENT_NEW_YEAR_OnDialogResponse snow_OnDialogResponse
#if defined snow_OnDialogResponse
forward snow_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif


public SYS_EVENT_NEW_YEAR_OnPlayerExitVehicle(playerid, vehicleid)
{
    if(GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        if(GetPlayerNewYear(playerid, MINI_GAME_GIFT) != 0)
        {
            if(GetPlayerNewYear(playerid, VEH_QUEST))
            {
                LoseMiniGame(playerid, 2);

                SendClientMessage(playerid, -1, ""USC"    ");

                //if(IsValidDynamicArea(GetPVarInt(playerid, "mini_game_sphere"))) SetTimerEx("LoseMiniGame", 3000, false, "ii", playerid, 2);

            }
        }
    }
    #if defined sn_OnPlayerExitVehicle
        return sn_OnPlayerExitVehicle(playerid, vehicleid);
    #else
        return 1;
    #endif
} //   https://t.me/welsistudio (Welsi Studio)
   #if defined _ALS_SYS_EVENT_NEW_YEAR_OnPlayerExitVehicle
    #undef SYS_EVENT_NEW_YEAR_OnPlayerExitVehicle
#else
    #define _ALS_SYS_EVENT_NEW_YEAR_OnPlayerExitVehicle
#endif
#define SYS_EVENT_NEW_YEAR_OnPlayerExitVehicle sn_OnPlayerExitVehicle
#if defined sn_OnPlayerExitVehicle
    forward sn_OnPlayerExitVehicle(playerid, vehicleid);
#endif

public SYS_EVENT_NEW_YEAR_OnPlayerEnterCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "quest_1_new_year"))
    {
        DisablePlayerCheckpoint(playerid);
        SendClientMessage(playerid, -1, ""SC"         ");
    }
    #if defined snow_OnPlayerEnterCheckpoint
        return snow_OnPlayerEnterCheckpoint(playerid);
    #else
        return 1;
    #endif
} //   https://t.me/welsistudio (Welsi Studio)
   #if defined _ALS_SYS_EVENT_NEW_YEAR_OnPlayerEnterCheckpoint
    #undef SYS_EVENT_NEW_YEAR_OnPlayerEnterCheckpoint
#else
    #define _ALS_SYS_EVENT_NEW_YEAR_OnPlayerEnterCheckpoint
#endif
#define SYS_EVENT_NEW_YEAR_OnPlayerEnterCheckpoint snow_OnPlayerEnterCheckpoint
#if defined snow_OnPlayerEnterCheckpoint
    forward snow_OnPlayerEnterCheckpoint(playerid);
#endif


public SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == sphere_mini_game)
    {
        Dialog
        (
            playerid, 4439, DIALOG_STYLE_LIST, 
            "{FFFF00} -",
            ""SC"  \n"\
            ""SC"   ",
            "", ""
        );
        //exit -1375.116943,-277.131561,256.216766,301.570983
    }
    if(areaid == shpere_obmen_npc)
    {
        new text[35];

        format(text, sizeof text, "  | : %d", GetPlayerNewYear(playerid, SNOW_COINS));

        Dialog
        (
            playerid, 4440, DIALOG_STYLE_LIST, 
            text,
            "{FFFF00}1. {FFFFFF}  \n"\
            "{FFFF00}2. {FFFFFF}  \n"\
            "{FFFF00}3. {FFFFFF} \n"\
            "{FFFF00}4. {FFFFFF} \n"\
            "{FFFF00}5. {FFFFFF}    \t\t\t {FFFF00}1000 \n"\
            "{FFFF00}6. {FFFFFF} ",
            "", ""
        );
    }
    if(areaid == shpere_ded_moroz)
    {
        if(GetPlayerNewYear(playerid, NEW_QUEST_1) == 0)
        {
            Dialog
            (
                playerid, 4430, DIALOG_STYLE_MSGBOX, 
                " ",
                ",      ?    -   \n"\
                "   .       \n"\
                "   ?       \n"\
                "           ",
                "", ""
            );
        }
        else
        {
            ShowDialogQuestNewYear(playerid);
        }
    }
    if(areaid == q_3_new[playerid][1])
    {
        if(!(GetPVarInt(playerid, "quest_3_new_year"))) return 0;//   https://t.me/welsistudio (Welsi Studio)

        Dialog
        (
            playerid, 4451,DIALOG_STYLE_MSGBOX,
            "{FFFF00}",
            "! -  .   \n"\
            "    .    \n"\
            " ",
            "", ""
        );
    }
    if(areaid == q_4_new[playerid][1])
    {
        if(!(GetPVarInt(playerid, "quest_4_new_year"))) return 0;//   https://t.me/welsistudio (Welsi Studio)

        Dialog
        (
            playerid, 4452, DIALOG_STYLE_MSGBOX,
            "{FF0000}",
            "  ?...",
            "", ""
        );
    }
    if(q_1_new[playerid][0][1] <= areaid <= q_1_new[playerid][4][1])
    {
        if(!(GetPVarInt(playerid, "quest_1_new_year"))) return 0;

        if(GetPlayerVehicleID(playerid)) return SendClientMessage(playerid, -1, ""USC"    ");

        for(new c;c < 4;c++)
        {
            if(q_1_player_used[playerid][c] == areaid) return 0;
            
            if(q_1_player_used[playerid][c] == -1)
            {
                q_1_player_used[playerid][c] = areaid;
                break;
            }   
        }
        

        if(GetPlayerNewYear(playerid, LEFT_ACTOR_1) == 1)
        {
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 1.0, 1, 0, 0, 0, 5000);

            SendClientMessage(playerid, -1, ""SC"     ");     
            
            RemoveQuestNewYear(playerid, 1);

            quest_complete(playerid, 1);
        }
        else
        {
            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 1.0, 1, 0, 0, 0, 5000);

            SendClientMessage(playerid, -1, ""SC"     ");        
            AddPlayerNewYear(playerid, LEFT_ACTOR_1, -, 1);

            SetPlayerCheckpoint(playerid, quest_1_ACTOR[GetPlayerNewYear(playerid, LEFT_ACTOR_1) - 1][X_QUEST_ONE], quest_1_ACTOR[GetPlayerNewYear(playerid, LEFT_ACTOR_1) - 1][Y_QUEST_ONE], quest_1_ACTOR[GetPlayerNewYear(playerid, LEFT_ACTOR_1) - 1][Z_QUEST_ONE], 8.0);
        }
    }//   https://t.me/welsistudio (Welsi Studio)
    if(gift_box[0][G_ID_SPHERE] <= areaid <= gift_box[sizeof gift_box - 1][G_ID_SPHERE])
    {
        new id = IsPlayerInRangeOfAnyGiftBox(playerid);

        if(!gift_box[id][GIFT_SPAWN]) return 0;

        ApplyAnimation(playerid, "BASEBALL", "Bat_4", 3.1, 1, 1, 1, 0, 5000, 0);
        SetTimerEx("OpenGiftBox", 5000, false, "ii", playerid, id);
        gift_box[id][GIFT_SPAWN] = false;
    }

    if(m_g_player_gift[playerid][0][1] <= areaid <= m_g_player_gift[playerid][9][1])
    {
        new id = InPlayerGameGift(playerid, 1);

        if(GetPlayerNewYear(playerid, MINI_GAME_GIFT) == 1)
        {
            AddPlayerNewYear(playerid, MINI_GAME_GIFT, -, 1);

            SendClientMessage(playerid, -1, ""SC"!    .");
            WinMiniGame(playerid, 1);
        }
        else{
            DestroyPickup(m_g_player_gift[playerid][id][0]);
            DestroyDynamicArea(m_g_player_gift[playerid][id][1]);

            new text[65];
            format(text, sizeof text, "  .  :{FFFF00} %d", GetPlayerNewYear(playerid, MINI_GAME_GIFT) - 1);
            SendClientMessage(playerid, -1, text);

            AddPlayerNewYear(playerid, MINI_GAME_GIFT, -, 1);

        }
    }
    if(q_5_sphere[playerid][0] <= areaid <= q_5_sphere[playerid][2])
    {
        if(!(GetPVarInt(playerid, "persona_count")))
        {
            if(!(areaid == q_5_sphere[playerid][0])) return 1;
            Dialog
            (
                playerid, -1, DIALOG_STYLE_MSGBOX, 
                " ",
                "  {FFFF00} .\n"\
                "{FFFFFF}   , \n"\
                "       \n"\
                "   .    \n"\
                "{FFFF00}   ",
                "", ""
            );

            SetPVarInt(playerid, "persona_count", 1);
            EnablePlayerGPS(playerid, 55, spawn_actor_5[9][Q_5_X], spawn_actor_5[9][Q_5_Y], spawn_actor_5[9][Q_5_Z], "  ");
        }
        else if(GetPVarInt(playerid, "persona_count") == 1)
        {
            if(!(areaid == q_5_sphere[playerid][1])) return 1;

            Dialog
            (
                playerid, -1, DIALOG_STYLE_MSGBOX, 
                "",
                "...    \n"\
                "   .   \n"\
                "{FFFF00}   ",
                "", ""
            );

            SetPVarInt(playerid, "persona_count", 2);
            EnablePlayerGPS(playerid, 55, spawn_actor_5[10][Q_5_X], spawn_actor_5[10][Q_5_Y], spawn_actor_5[10][Q_5_Z], "  O");
        }
        else if(GetPVarInt(playerid, "persona_count") == 2)
        {
            if(!(areaid == q_5_sphere[playerid][2])) return 1;

            Dialog
            (
                playerid, 4453, DIALOG_STYLE_MSGBOX, 
                "",
                "!   -\n"\
                "    .  \n"\
                ". {FFFF00}   ",
                "", ""
            );

            DeletePVar(playerid, "persona_count");        
        }//   https://t.me/welsistudio (Welsi Studio)
    }
    if(m_g_2_player_gift[playerid][0][1] <= areaid <= m_g_2_player_gift[playerid][14][1])
    {
        new id = InPlayerGameGift(playerid, 2);

        if(GetPlayerNewYear(playerid, MINI_GAME_GIFT) == 1)
        {
            SendClientMessage(playerid, -1, ""SC" !    .");
            WinMiniGame(playerid, 2);
        }
        else{
            
            DestroyPickup(m_g_2_player_gift[playerid][id][0]);
            DestroyDynamicArea(m_g_2_player_gift[playerid][id][1]);

            new text[65];
            format(text, sizeof text, "  .  :{FFFF00} %d", GetPlayerNewYear(playerid, MINI_GAME_GIFT) - 1);
            SendClientMessage(playerid, -1, text);

            AddPlayerNewYear(playerid, MINI_GAME_GIFT, -, 1);

        }
    }
    if(q_2_player[playerid][0][Q_2_SPHERE] <= areaid <= q_2_player[playerid][3][Q_2_SPHERE])
    {
        if(!GetPVarInt(playerid, "quest_2_new_year")) return 0;

        if(GetPlayerVehicleID(playerid)) return SendClientMessage(playerid, -1, ""USC"    ");

        for(new c;c < 4;c++)
        {
            if(q_2_player_used[playerid][c] == areaid) return 0;
            
            if(q_2_player_used[playerid][c] == -1)
            {
                q_2_player_used[playerid][c] = areaid;
                break;
            }   
        }
//   https://t.me/welsistudio (Welsi Studio)
        if(GetPVarInt(playerid, "staff_count") == 1)
        {
            ApplyAnimation(playerid, "BASEBALL", "Bat_4", 3.1, 1, 1, 1, 0, 2000, 0);

            SendClientMessage(playerid, -1, ""SC" !   !");     
            
            RemoveQuestNewYear(playerid, 2);

            quest_complete(playerid, 2);
        }
        else
        {
            ApplyAnimation(playerid, "BASEBALL", "Bat_4", 3.1, 1, 1, 1, 0, 2000, 0);

            SetPVarInt(playerid, "staff_count", GetPVarInt(playerid, "staff_count") - 1);
            SendClientMessage(playerid, -1, ""USC"  ...   ");
        }
    }
    #if defined snow_OnPlayerEnterDynamicArea
        return snow_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea
    #undef SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea
#else
    #define _ALS_SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea
#endif
#define SYS_EVENT_NEW_YEAR_OnPlayerEnterDynamicArea snow_OnPlayerEnterDynamicArea
#if defined snow_OnPlayerEnterDynamicArea
    forward snow_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public SYS_EVENT_NEW_YEAR_OnPlayerLeaveDynamicArea(playerid, areaid)
{
    if(areaid == GetPVarInt(playerid, "mini_game_sphere"))
    {

        if(GetPlayerNewYear(playerid, MINI_GAME_GIFT))
        {
            new game_world = playerid + 10000;

            DestroyDynamicArea(areaid);

            if(GetPlayerVirtualWorld(playerid) == game_world)
            {
                if(!(IsValidDynamicArea(GetPVarInt(playerid, "mini_game_sphere")))) DeletePVar(playerid, "mini_game_sphere");
                else DestroyDynamicArea(areaid);

                LoseMiniGame(playerid, 2);
                SendClientMessage(playerid, -1, ""USC"    ");
            }
        }
    }
    
    #if defined snow_OnPlayerLeaveDynamicArea
        return snow_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_SYS_EVENT_NEW_YEAR_OnPlayerLeaveDynamicArea
    #undef SYS_EVENT_NEW_YEAR_OnPlayerLeaveDynamicArea
#else
    #define _ALS_SYS_EVENT_NEW_YEAR_OnPlayerLeaveDynamicArea
#endif
#define SYS_EVENT_NEW_YEAR_OnPlayerLeaveDynamicArea snow_OnPlayerLeaveDynamicArea
#if defined snow_OnPlayerLeaveDynamicArea
    forward snow_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public SYS_EVENT_NEW_YEAR_OnGameModeInit()
{
    print("[LAIRD_SYSTEM]   \n: https://t.me/welsistudio");

    CreateActorEx(" ", "{C0C0C0}[ ]", 24, ded_coord[0], ded_coord[1], ded_coord[2], ded_coord[3]);
    shpere_ded_moroz = CreateDynamicSphere(ded_coord[0], ded_coord[1], ded_coord[2], 2.0);
    CreateActorEx(" ", "{C0C0C0}[ ]", 80, obmen_npc[0], obmen_npc[1], obmen_npc[2], obmen_npc[3]);
    shpere_obmen_npc = CreateDynamicSphere(obmen_npc[0], obmen_npc[1], obmen_npc[2], 3.0);
    Create3DTextLabel("{FFFF00} -\n{C0C0C0}[  ]", -1, -1376.658691,-277.933319,256.216766, 7.0, 0);

    sphere_mini_game = CreateDynamicSphere(-1376.658691,-277.933319,256.216766, 4.0);
    LoadQuestsNewYear();
    SetTimer("SpawnPrizeGift", 1000*60*60, true);

    TextDrawMiniGame();
    #if defined snow_OnGameModeInit
        return snow_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_SYS_EVENT_NEW_YEAR_OnGameModeInit
    #undef SYS_EVENT_NEW_YEAR_OnGameModeInit
#else
    #define _ALS_SYS_EVENT_NEW_YEAR_OnGameModeInit
#endif
#define SYS_EVENT_NEW_YEAR_OnGameModeInit snow_OnGameModeInit
#if defined snow_OnGameModeInit
    forward snow_OnGameModeInit();
#endif

CMD:spawn_gift(playerid)
{
    SpawnPrizeGift();
    SendClientMessage(playerid, -1, "spawn gift box, okey? :>");
    return 1;
}
public:SpawnPrizeGift()
{
    new pickup, Text3D:Text, count_spawn;

    for(new g;g < MAX_BOX_GIFT;g++)
    { 
        if(gift_box[g][GIFT_SPAWN]) count_spawn++;
        else
        {
            if(count_spawn >= 10) 
            {
                print("gift box > 10 for server");
                break; 
            }
            else{
                count_spawn++;
                pickup = CreatePickup(19055, 23, spawn_gift[g][0], spawn_gift[g][1], spawn_gift[g][2], 0);
                Text = Create3DTextLabel("{FFFF00} \n{C0C0C0}[  ]", -1, spawn_gift[g][0], spawn_gift[g][1], spawn_gift[g][2], 7.0, 0);

                gift_box[g][G_ID_3DText] = Text;
                gift_box[g][G_ID_pickup] = pickup;
                gift_box[g][GIFT_SPAWN] = true;                
            }

        }
    }
    return 1;

}

stock ShowDialogQuestNewYear(playerid)
{
    new text_quest[535], quest_progress[7][25];

    for(new c;c < 7;c++)
    {
        switch(c)
        {
            case 0:
            {
                switch(GetPlayerNewYear(playerid, NEW_QUEST_1))
                {
                    case 0: quest_progress[c] = "{FF0000} ";
                    case 1: quest_progress[c] = "{FF8A1C} ";
                    default: quest_progress[c] = "{48FF00}";
                }

                //if(GetPlayerNewYear(playerid, NEW_QUEST_1) == 0) quest_progress[c] = "{FF0000} ";
                //else if(GetPlayerNewYear(playerid, NEW_QUEST_1) == 1) quest_progress[c] = "{FF8A1C} ";
                //else if(GetPlayerNewYear(playerid, NEW_QUEST_1) > 1) quest_progress[c] = "{48FF00}";
            }
            case 1:
            {
                switch(GetPlayerNewYear(playerid, NEW_QUEST_2))
                {
                    case 0: quest_progress[c] = "{FF0000} ";
                    case 1: quest_progress[c] = "{FF8A1C} ";
                    default: quest_progress[c] = "{48FF00}";
                }
            }
            case 2:
            {
                switch(GetPlayerNewYear(playerid, NEW_QUEST_3))
                {
                    case 0: quest_progress[c] = "{FF0000} ";
                    case 1: quest_progress[c] = "{FF8A1C} ";
                    default: quest_progress[c] = "{48FF00}";
                }
            }
            case 3:
            {
                switch(GetPlayerNewYear(playerid, NEW_QUEST_4))
                {
                    case 0: quest_progress[c] = "{FF0000} ";
                    case 1: quest_progress[c] = "{FF8A1C} ";
                    default: quest_progress[c] = "{48FF00}";
                }
            }
            case 4:
            {
                switch(GetPlayerNewYear(playerid, NEW_QUEST_5))
                {
                    case 0: quest_progress[c] = "{FF0000} ";
                    case 1: quest_progress[c] = "{FF8A1C} ";
                    default: quest_progress[c] = "{48FF00}";
                }
            }
            case 5:
            {
                switch(GetPlayerNewYear(playerid, NEW_QUEST_6))
                {
                    case 0: quest_progress[c] = "{FF0000} ";
                    case 1: quest_progress[c] = "{FF8A1C} ";
                    default: quest_progress[c] = "{48FF00}";
                }
            }
            case 6:
            {
                switch(GetPlayerNewYear(playerid, NEW_QUEST_7))
                {
                    case 0: quest_progress[c] = "{FF0000} ";
                    case 1: quest_progress[c] = "{FF8A1C} ";
                    default: quest_progress[c] = "{48FF00}";
                }
            }
        }
    }
    
    format
    (
        text_quest, sizeof text_quest,
        "\t\n"\
        "{FF0000}1. {FFFFFF}  \t%s\n"\
        "{FF0000}2. {FFFFFF} \t%s\n"\
        "{FF0000}3. {FFFFFF} \t%s\n"\
        "{FF0000}4. {FFFFFF} \t%s\n"\
        "{FF0000}5. {FFFFFF}  !\t%s\n"\
        "{FF0000}C {FFFFFF}   \t%s\n"\
        "{FF0000}C {FFFFFF}    \t%s",
        quest_progress[0],
        quest_progress[1],
        quest_progress[2],
        quest_progress[3],
        quest_progress[4],
        quest_progress[5],
        quest_progress[6]
    );

    DialogNewYear
    (
        playerid, 4431, DIALOG_STYLE_TABLIST_HEADERS,
        "  |  ",
        text_quest,
        "", ""
    );
}

stock DialogNewYear(playerid, dialogid, style, title[], text[], button[], button2[])
{
  if(style == 5)
  {
     ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "...", "...", "...", ""); 
  }
  ShowPlayerDialog(playerid, dialogid, style, title, text, button, button2);
  return 1;
}

public: LoadPlayerData_NewYear(playerid)
{
    new newyear_sql[184];
    new Cache: welsi_result;

	mysql_format(mysql, newyear_sql, sizeof newyear_sql, "SELECT * FROM accounts WHERE id=%d LIMIT 1", GetPlayerAccountID(playerid));
	welsi_result = mysql_query(mysql, newyear_sql);

    if(cache_num_rows())
    {
        SetPlayerNewYear(playerid, SNOW_COINS, cache_get_field_content_int(0, "snowcoins"));
        SetPlayerNewYear(playerid, NEW_QUEST_1, cache_get_field_content_int(0, "snowquest1"));
        SetPlayerNewYear(playerid, NEW_QUEST_2, cache_get_field_content_int(0, "snowquest2"));
        SetPlayerNewYear(playerid, NEW_QUEST_3, cache_get_field_content_int(0, "snowquest3"));
        SetPlayerNewYear(playerid, NEW_QUEST_4, cache_get_field_content_int(0, "snowquest4"));
        SetPlayerNewYear(playerid, NEW_QUEST_5, cache_get_field_content_int(0, "snowquest5"));
        SetPlayerNewYear(playerid, NEW_QUEST_6, cache_get_field_content_int(0, "snowquest6"));
        SetPlayerNewYear(playerid, NEW_QUEST_7, cache_get_field_content_int(0, "snowquest7"));
        cache_delete(welsi_result);
    }
//   https://t.me/welsistudio (Welsi Studio)
    for(new a;a < sizeof spawn_mini_game_gift;a++)
    {
        m_g_player_gift[playerid][a][1] = -1;
    }
    for(new m;m < sizeof spawn_mini_game_gift;m++)
    {
       m_g_player_gift[playerid][m][1] = -1;
    }

    for(new c;c < 4;c++)
    {
        q_2_player_used[playerid][c] = -1;
    }

    for(new c;c < 5;c++)
    {
        q_1_player_used[playerid][c] = -1;
    }
//   https://t.me/welsistudio (Welsi Studio)
    for(new c;c < 2;c++)
    {
        q_3_new[playerid][c] = -1;
        q_3_new[playerid][c] = -1;

        q_4_new[playerid][c] = -1;
        q_4_new[playerid][c] = -1;
    }

    SetPlayerNewYear(playerid, MINI_GAME_GIFT, 0);   
    SetPlayerNewYear(playerid, VEH_QUEST, -1);
    
    return 1;
}

stock UnLoadPlayerData_NewYear(playerid)
{
 //   https://t.me/welsistudio (Welsi Studio)

    SetPlayerNewYear(playerid, SNOW_COINS, 0);  //struct
    SetPlayerNewYear(playerid, NEW_QUEST_1, 0);
    SetPlayerNewYear(playerid, NEW_QUEST_2, 0);
    SetPlayerNewYear(playerid, NEW_QUEST_3, 0);
    SetPlayerNewYear(playerid, NEW_QUEST_4, 0);
    SetPlayerNewYear(playerid, NEW_QUEST_5, 0);

    if(GetPlayerNewYear(playerid, MINI_GAME_GIFT))
    {
        for(new idx; idx < 10; idx ++)
	    {
	    	if(!IsPlayerInDynamicArea(playerid, m_g_player_gift[playerid][idx][1])) continue;//   https://t.me/welsistudio (Welsi Studio)
            LoseMiniGame(playerid, 1);
	    }

        for(new idx; idx < 15; idx ++)
	    {
	    	if(!IsPlayerInDynamicArea(playerid, m_g_2_player_gift[playerid][idx][1])) continue;
            LoseMiniGame(playerid, 2);
	    }
    }

    for(new c;c < 4;c++)
    {
        q_2_player_used[playerid][c] = -1;
    }

    for(new c;c < 5;c++)
    {
        q_1_player_used[playerid][c] = -1;
    }

    if(GetPVarInt(playerid, "quest_1_new_year"))    RemoveQuestNewYear(playerid, 1);
    if(GetPVarInt(playerid, "quest_2_new_year"))    RemoveQuestNewYear(playerid, 2);
    if(GetPVarInt(playerid, "quest_3_new_year"))    RemoveQuestNewYear(playerid, 3);
    if(GetPVarInt(playerid, "quest_4_new_year"))    RemoveQuestNewYear(playerid, 4);
    if(GetPVarInt(playerid, "quest_5_new_year"))    RemoveQuestNewYear(playerid, 5);//   https://t.me/welsistudio (LAIRD_SYSTEM)

    return 1;
}

stock quest_complete(playerid, id_q)
{
    new quest_sql[7][11] = {"snowquest1","snowquest2","snowquest3","snowquest4","snowquest5","snowquest6","snowquest7"};
    
    switch(id_q)
    {
        case 1: SetPlayerNewYear(playerid, NEW_QUEST_1, 1);
        case 2: SetPlayerNewYear(playerid, NEW_QUEST_2, 1);
        case 3: SetPlayerNewYear(playerid, NEW_QUEST_3, 1);
        case 4: SetPlayerNewYear(playerid, NEW_QUEST_4, 1);
        case 5: SetPlayerNewYear(playerid, NEW_QUEST_5, 1);
        case 6: SetPlayerNewYear(playerid, NEW_QUEST_6, 1);
        case 7: SetPlayerNewYear(playerid, NEW_QUEST_7, 1);
    }

    UpdatePlayerDatabaseInt(playerid, quest_sql[id_q - 1], 1);//   https://t.me/welsistudio (Welsi Studio)

    SendClientMessage(playerid, -1, ""SC"    .    ");
    SendClientMessage(playerid, -1, "  ");

    EnablePlayerGPS(playerid, 55, ded_coord[0], ded_coord[1], ded_coord[2], "");
    
    return 1;
}

stock quest_get_prize(playerid, id_q)
{
    new quest_sql[7][11] = {"snowquest1","snowquest2","snowquest3","snowquest4","snowquest5","snowquest6","snowquest7"};//   https://t.me/welsistudio (Welsi Studio)

    switch(id_q - 1)
    {
        case 0:
        {
            UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + 150);
            SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + 150);
            GameTextForPlayer(playerid, " ~s~+150 ~b~", 2000, 3);
        }
        case 1:
        {
            UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + 500);
            SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + 500);
            GameTextForPlayer(playerid, " ~s~+500 ~b~", 2000, 3);
        }
        case 2:
        {
            UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + 500);
            SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + 500);
            GameTextForPlayer(playerid, " ~s~+500 ~b~", 2000, 3);
        }
        case 3:
        {
            UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + 1000);
            SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + 1000);
            GameTextForPlayer(playerid, " ~s~+1000 ~b~", 2000, 3);
        }
        case 4:
        {
            UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + 2025);
            SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + 2025);
            GameTextForPlayer(playerid, " ~s~+2025 ~b~", 2000, 3);
        }
        case 5:
        {
            UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + 500);
            SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + 500);
            GameTextForPlayer(playerid, " ~s~+500 ~b~", 2000, 3);
        }
        case 6:
        {
            UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + 500);
            SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + 300);
            GameTextForPlayer(playerid, " ~s~+500 ~b~", 2000, 3);
        }
    }

    UpdatePlayerDatabaseInt(playerid, quest_sql[id_q - 1], gettime());

    switch(id_q)//   https://t.me/welsistudio (Welsi Studio)
    {
        case 1:SetPlayerNewYear(playerid, NEW_QUEST_1, gettime());
        case 2:SetPlayerNewYear(playerid, NEW_QUEST_2, gettime());
        case 3:SetPlayerNewYear(playerid, NEW_QUEST_3, gettime());
        case 4:SetPlayerNewYear(playerid, NEW_QUEST_4, gettime());
        case 5:SetPlayerNewYear(playerid, NEW_QUEST_5, gettime());
        case 6:SetPlayerNewYear(playerid, NEW_QUEST_6, gettime());
        case 7:SetPlayerNewYear(playerid, NEW_QUEST_7, gettime());
    }

    return 1;
}

stock LoadQuestsNewYear()//   https://t.me/welsistudio (Welsi Studio)
{
    new sphere;

    for(new g;g < MAX_BOX_GIFT;g++)
    {
        sphere = CreateDynamicSphere(spawn_gift[g][0], spawn_gift[g][1], spawn_gift[g][2], 3.0, 0);
        gift_box[g][G_ID_SPHERE] = sphere;
    }
    return 1;
}


stock LoadQuestNewYear(playerid, number_quest)
{
    new virtual = GetPlayerVirtualWorld(playerid);

    switch(number_quest)
    {
        case 1:
        {

            for(new a;a < 5;a++)
            {
                q_1_new[playerid][a][0] = CreateActorEx("", "{727272}  ...", quest_1_ACTOR[a][SKIN_QUEST_ONE], quest_1_ACTOR[a][X_QUEST_ONE], quest_1_ACTOR[a][Y_QUEST_ONE], quest_1_ACTOR[a][Z_QUEST_ONE], quest_1_ACTOR[a][A_QUEST_ONE], virtual);
                q_1_new[playerid][a][1] = CreateDynamicSphere(quest_1_ACTOR[a][X_QUEST_ONE], quest_1_ACTOR[a][Y_QUEST_ONE], quest_1_ACTOR[a][Z_QUEST_ONE], 2.0,  virtual, -1, playerid);
            }
        }
        case 2:
        { 
            SetPVarInt(playerid, "staff_count", 4);

            for(new a;a < 4;a++)
            {
                q_2_player[playerid][a][Q_2_SPHERE] = CreateDynamicSphere(spawn_staff_q_2[a][0], spawn_staff_q_2[a][1], spawn_staff_q_2[a][2], 3.0, virtual, -1, playerid);
                q_2_player[playerid][a][Q_2_3DTEXT] = Create3DTextLabel("-   \n{C0C0C0}[  ]", -1, spawn_staff_q_2[a][0], spawn_staff_q_2[a][1], spawn_staff_q_2[a][2], 17.0, virtual);
            }

            player_gang_zone[playerid] = GangZoneCreate(-2009.189331,-1425.330444, -2076.646972,-1343.253417);
            GangZoneShowForPlayer(playerid, player_gang_zone[playerid], 0xFF0000FF);
            GangZoneFlashForPlayer(playerid, player_gang_zone[playerid], 0xFFFFFFFF);
            
            for(new a;a < 4;a++)
            {
                if(IsValidDynamicArea(q_2_player[playerid][a][Q_2_SPHERE])) continue;

                q_2_player[playerid][a][Q_2_SPHERE] = CreateDynamicSphere(spawn_staff_q_2[a][0], spawn_staff_q_2[a][1], spawn_staff_q_2[a][2], 3.0, virtual, -1, playerid);
            
            }

            
        }
        case 3:
        {

            EnablePlayerGPS(playerid, 55, -540.210021,-1601.124511,41.343948, "");

            SendClientMessage(playerid, -1, ""SC"  -  {FFFF00}\"\"");
            SendClientMessage(playerid, -1, ""SC"     ");

            q_3_new[playerid][0] = CreateActorEx("{FFFF00}", "{C0C0C0}[  ]", 245, -540.210021,-1601.124511,41.343948,324.716491, virtual);
            q_3_new[playerid][1] = CreateDynamicSphere(-540.210021,-1601.124511,41.343948, 2.0, virtual, -1, playerid);
        }
        case 4:
        {
            player_gang_zone[playerid] = GangZoneCreate(-2304.928222, 941.580627, -1966.392578, 1007.842834);
            GangZoneShowForPlayer(playerid, player_gang_zone[playerid], 0xFF0000FF);
            GangZoneFlashForPlayer(playerid, player_gang_zone[playerid], 0xFFFFFFFF);

            SendClientMessage(playerid, -1, ""SC"  -  {FF0000} ");
            SendClientMessage(playerid, -1, ""SC"       ");

            q_4_new[playerid][0] = CreateActorEx("{FF0000} ", "{C0C0C0}[  ]", 39, -2156.958007,998.339843,2.630023,197.331619, virtual);
            q_4_new[playerid][1] = CreateDynamicSphere(-2156.958007,998.339843,2.630023, 2.0, virtual, -1, playerid);
        }
        case 5:
        {

            SetPlayerPosEx(playerid, 0.029099,1494.326293,1380.997558,5.106338, 1, virtual);
            TeleportFreeze(playerid, 1000);

            //SetTimerEx("LoadEndIvent", 2000, false, "ii", playerid, virtual);

            for(new e;e < sizeof spawn_actor_5;e++)
            {
                switch(spawn_actor_5[e][Q_5_SKIN])
                {
                    case 24: q_5_sphere[playerid][0] = CreateDynamicSphere(spawn_actor_5[e][Q_5_X], spawn_actor_5[e][Q_5_Y], spawn_actor_5[e][Q_5_Z], 2.0, virtual, 1);
                    case 245:  q_5_sphere[playerid][1] = CreateDynamicSphere(spawn_actor_5[e][Q_5_X], spawn_actor_5[e][Q_5_Y], spawn_actor_5[e][Q_5_Z], 2.0, virtual, 1);
                    case 39:  q_5_sphere[playerid][2] = CreateDynamicSphere(spawn_actor_5[e][Q_5_X], spawn_actor_5[e][Q_5_Y], spawn_actor_5[e][Q_5_Z], 2.0, virtual, 1);
                }

                q_5_new[playerid][e] = CreateActor(spawn_actor_5[e][Q_5_SKIN], spawn_actor_5[e][Q_5_X], spawn_actor_5[e][Q_5_Y], spawn_actor_5[e][Q_5_Z], spawn_actor_5[e][Q_5_A]);
                SetActorVirtualWorld(q_5_new[playerid][e], virtual);
            }
            //   https://t.me/welsistudio (Welsi Studio)

            EnablePlayerGPS(playerid, 55, spawn_actor_5[0][Q_5_X], spawn_actor_5[0][Q_5_Y], spawn_actor_5[0][Q_5_Z]);
        }
    }
}

stock RemoveQuestNewYear(playerid, number_quest)//   https://t.me/welsistudio (Welsi Studio)
{
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerPos(playerid, -1346.735473,-324.091400,256.228637);
    SetPlayerFacingAngle(playerid, 61.128845);

    if(IsValidVehicle(GetPlayerNewYear(playerid, VEH_QUEST))) DestroyVehicle(GetPlayerNewYear(playerid, VEH_QUEST));
    if(GetPlayerNewYear(playerid, VEH_QUEST) != -1)SetPlayerNewYear(playerid, VEH_QUEST, -1);

    switch(number_quest)
    {
        case 1:
        {
            DeletePVar(playerid, "quest_1_new_year");
            SetPlayerNewYear(playerid, LEFT_ACTOR_1, 0);

            for(new c;c < 5;c++)
            {
                q_1_player_used[playerid][c] = -1;
            }

            for(new a; a<5;a++)
            {
                DestroyActor(q_1_new[playerid][a][0]);
                DestroyDynamicArea(q_1_new[playerid][a][1]);
                q_1_new[playerid][a][0] = -1; 
                q_1_new[playerid][a][1] = -1;
            }
        }
        case 2:
        {
            DeletePVar(playerid, "quest_2_new_year");//   https://t.me/welsistudio (Welsi Studio)
            DeletePVar(playerid, "staff_count");

            GangZoneDestroy(player_gang_zone[playerid]);
            GangZoneHideForPlayer(playerid, player_gang_zone[playerid]);
            GangZoneStopFlashForPlayer(playerid, player_gang_zone[playerid]);

            player_gang_zone[playerid] = -1;

            for(new a;a < 4;a++)
            {
                Delete3DTextLabel(q_2_player[playerid][a][Q_2_3DTEXT]);
                DestroyDynamicArea(q_2_player[playerid][a][Q_2_SPHERE]);
                q_2_player[playerid][a][Q_2_3DTEXT] = Text3D:-1; 
                q_2_player[playerid][a][Q_2_SPHERE] = -1;
            }
        }
        case 3:
        {
            DeletePVar(playerid, "quest_3_new_year");
            DeletePVar(playerid, "count_letter");
            DeletePVar(playerid, "count_letter_wrong");
            DestroyActor(q_3_new[playerid][0]);
            DestroyDynamicArea(q_3_new[playerid][1]);
            q_3_new[playerid][1] = -1;
            q_3_new[playerid][0] = -1;
        }
        case 4:
        {
            DeletePVar(playerid, "quest_4_new_year");
            DeletePVar(playerid, "dialog_progress");//   https://t.me/welsistudio (Welsi Studio)

            DestroyActor(q_4_new[playerid][0]);
            DestroyDynamicArea(q_4_new[playerid][1]);

            q_4_new[playerid][1] = -1;
            q_4_new[playerid][0] = -1;

            GangZoneDestroy(player_gang_zone[playerid]);
            GangZoneHideForPlayer(playerid, player_gang_zone[playerid]);
            GangZoneStopFlashForPlayer(playerid, player_gang_zone[playerid]);

            player_gang_zone[playerid] = -1;
        }
        case 5:
        {
            DeletePVar(playerid, "quest_5_new_year");
            SetPlayerInterior(playerid, 0);
            for(new end;end < 11;end++)
            {
                DestroyActor(q_5_new[playerid][end]);
                q_5_new[playerid][end] = -1;
            }
            for(new end;end < 3;end++)
            {
                DestroyDynamicArea(q_5_sphere[playerid][end]);
                q_5_sphere[playerid][end] = -1;
            }
        }
    }
}

stock IsPlayerInRangeOfAnyGiftBox(playerid)
{
    new area = -1;

	for(new idx; idx < MAX_BOX_GIFT; idx ++)
	{
		if(!IsPlayerInDynamicArea(playerid, gift_box[idx][G_ID_SPHERE])) continue;
        area = idx;
	}
	return area;
}

public: OpenGiftBox(playerid, gift)//   https://t.me/welsistudio (Welsi Studio)
{
   DestroyPickup(gift_box[gift][G_ID_pickup]);
   Delete3DTextLabel(gift_box[gift][G_ID_3DText]);

   new text[284];

   new r = random(100) + 1;

   if(r >= 90)
   {    
        new rand = random(5);

        SetPVarInt(playerid, "gift_skin", rand);

        format(text, sizeof text, "    {FFFF00}\"%s\" {FFFFFF}\n   ?\n   {15FF00}\"\"", skin_prize[rand][0]);

        Dialog
        (
            playerid, 4438, DIALOG_STYLE_MSGBOX, //   https://t.me/welsistudio (Welsi Studio)
            "  ",
            text, 
            "", ""
        );
   }
   else{

       new money = random(50000) + 5000, donate = random(25) + 1,exp = random(5) + 5; //   https://t.me/welsistudio (Welsi Studio)
       
       format(text, sizeof text,\
       "{FFFF00}!{FFFFFF}    [%d]\n\
         {FFFF00}%d{FFFFFF} , {FFFF00}%d {FFFFFF}-, {FFFF00}%d {FFFFFF} \n\
            {15FF00}\"\"",
       gift, money, donate, exp
       );
       
       SetPVarInt(playerid, "gift_money", money);
       SetPVarInt(playerid, "gift_donate", donate);
       SetPVarInt(playerid, "gift_exp", exp); //   https://t.me/welsistudio (Welsi Studio)
       
       Dialog(playerid, 4438, DIALOG_STYLE_MSGBOX, "  ", text, "", "");
   }

   
   return 1;
}

stock TextDrawMiniGame()
{
    time_mini_game_TD[0] = TextDrawCreate(97.0000, 226.9186, "_"); //   https://t.me/welsistudio (Welsi Studio)
    TextDrawLetterSize(time_mini_game_TD[0], -0.0446, 1.8944);
    TextDrawTextSize(time_mini_game_TD[0], 144.0000, 0.0000);
    TextDrawAlignment(time_mini_game_TD[0], 1);
    TextDrawColor(time_mini_game_TD[0], 41215);
    TextDrawUseBox(time_mini_game_TD[0], 1);
    TextDrawBoxColor(time_mini_game_TD[0], 255);
    TextDrawBackgroundColor(time_mini_game_TD[0], -1);
    TextDrawFont(time_mini_game_TD[0], 0);
    TextDrawSetProportional(time_mini_game_TD[0], 0);
    TextDrawSetShadow(time_mini_game_TD[0], 0);

    time_mini_game_TD[1] = TextDrawCreate(99.6667, 229.4075, "_"); //   https://t.me/welsistudio (Welsi Studio)
    TextDrawLetterSize(time_mini_game_TD[1], -0.0353, 1.3510);
    TextDrawTextSize(time_mini_game_TD[1], 141.0000, 0.0000);
    TextDrawAlignment(time_mini_game_TD[1], 1);
    TextDrawColor(time_mini_game_TD[1], 41215);
    TextDrawUseBox(time_mini_game_TD[1], 1);
    TextDrawBoxColor(time_mini_game_TD[1], -1378294017);
    TextDrawBackgroundColor(time_mini_game_TD[1], -1);
    TextDrawFont(time_mini_game_TD[1], 0);
    TextDrawSetProportional(time_mini_game_TD[1], 0);
    TextDrawSetShadow(time_mini_game_TD[1], 0);

    time_mini_game_TD[2] = TextDrawCreate(103.3332, 227.7482, "OCAOC_PEMEH:"); //   https://t.me/welsistudio (Welsi Studio)
    TextDrawLetterSize(time_mini_game_TD[2], 0.1075, 0.8532);
    TextDrawTextSize(time_mini_game_TD[2], 23.0000, 0.0000);
    TextDrawAlignment(time_mini_game_TD[2], 1);
    TextDrawColor(time_mini_game_TD[2], 255);
    TextDrawBackgroundColor(time_mini_game_TD[2], 255);
    TextDrawFont(time_mini_game_TD[2], 1);
    TextDrawSetProportional(time_mini_game_TD[2], 1);
    TextDrawSetShadow(time_mini_game_TD[2], 0);



    return 1;
}

stock TextDrawMiniGamePlayer(playerid)//   https://t.me/welsistudio (Welsi Studio)
{
    time_mini_game_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 109.3333, 236.0444, "50_ceky"); //   https://t.me/welsistudio (Welsi Studio)
    PlayerTextDrawLetterSize(playerid, time_mini_game_PTD[playerid][0], 0.1275, 0.7371);
    PlayerTextDrawTextSize(playerid, time_mini_game_PTD[playerid][0], -1.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, time_mini_game_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, time_mini_game_PTD[playerid][0], 255);
    PlayerTextDrawBackgroundColor(playerid, time_mini_game_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, time_mini_game_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, time_mini_game_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, time_mini_game_PTD[playerid][0], 0);
    
    return 1;
}

public:ChangeTimerMiniGame(playerid, game)
{
    if(game == 1)
    {
        if(GetPVarInt(playerid, "second_to_player") != 0)
        {
            new	second = GetPVarInt(playerid, "second_to_player") - 1;
            new fmt_str[20];

            format(fmt_str, sizeof fmt_str,"%d_ceky", GetPVarInt(playerid, "second_to_player"));

            PlayerTextDrawSetString(playerid, time_mini_game_PTD[playerid][0], fmt_str);
            PlayerTextDrawShow(playerid, time_mini_game_PTD[playerid][0]);

            SetPVarInt(playerid, "second_to_player", second);
        }
        else
        {
            KillTimer(GetPVarInt(playerid, "id_timer_mini_game"));
            LoseMiniGame(playerid, 1);
        }
    }
    else if(game == 2)
    {
        if(GetPVarInt(playerid, "second_to_player") != 0)
        {
            new	second = GetPVarInt(playerid, "second_to_player") - 1;
            new fmt_str[20];

            format(fmt_str, sizeof fmt_str,"%d_ceky", GetPVarInt(playerid, "second_to_player"));

            PlayerTextDrawSetString(playerid, time_mini_game_PTD[playerid][0], fmt_str);
            PlayerTextDrawShow(playerid, time_mini_game_PTD[playerid][0]);

            SetPVarInt(playerid, "second_to_player", second);
        }
        else
        {
            KillTimer(GetPVarInt(playerid, "id_timer_mini_game"));
            LoseMiniGame(playerid, 2);
        }
    }
    return 1;
}

public: LoseMiniGame(playerid, game)
{
    PlayerTextDrawHide(playerid, time_mini_game_PTD[playerid][0]);
    
    for(new i;i < sizeof time_mini_game_TD ;i++)
    {
        TextDrawHideForPlayer(playerid, time_mini_game_TD[i]);
    }

    SetPlayerNewYear(playerid, MINI_GAME_GIFT, 0);  

    SetPlayerPosEx(playerid, -1375.116943,-277.131561,256.216766,301.570983, 0, 0);

    SendClientMessage(playerid, -1, ""USC"  ...         ");
    
    KillTimer(GetPVarInt(playerid, "id_timer_mini_game"));

    if(game == 1)
    {
        for(new a;a < sizeof spawn_mini_game_gift;a++)
        {
            DestroyPickup(m_g_player_gift[playerid][a][0]);
            m_g_player_gift[playerid][a][1] = -1;
        }
        for(new m;m < sizeof spawn_mini_game_gift;m++)
        {
            DestroyDynamicArea(m_g_player_gift[playerid][m][1]);
            m_g_player_gift[playerid][m][1] = -1;
        }
    }
    else if(game == 2)
    {
        if(GetPVarInt(playerid, "mini_game_sphere")) DestroyDynamicArea(GetPVarInt(playerid, "mini_game_sphere"));

        DeletePVar(playerid, "mini_game_sphere");

        for(new a;a < sizeof spawn_mini_game_2_gift;a++)
        {
            DestroyPickup(m_g_2_player_gift[playerid][a][0]);
            m_g_2_player_gift[playerid][a][1] = -1;
        }
        for(new m;m < sizeof spawn_mini_game_2_gift;m++)
        {
            DestroyDynamicArea(m_g_2_player_gift[playerid][m][1]);
            m_g_2_player_gift[playerid][m][1] = -1;
        }
        //SetPlayerNewYear(playerid, MINI_GAME_GIFT, 0);

        if(GetPlayerNewYear(playerid, VEH_QUEST)) DestroyVehicle(GetPlayerNewYear(playerid, VEH_QUEST));
        SetPlayerNewYear(playerid, VEH_QUEST, -1);
    }
    return 1;
}

stock WinMiniGame(playerid, game)
{
    PlayerTextDrawHide(playerid, time_mini_game_PTD[playerid][0]);
 
    for(new i;i < sizeof time_mini_game_TD;i++)
    {
        TextDrawHideForPlayer(playerid, time_mini_game_TD[i]);
    }

    SetPlayerPosEx(playerid, -1375.116943,-277.131561,256.216766,301.570983, 0, 0);

    SetPlayerNewYear(playerid, MINI_GAME_GIFT, 0); 
    KillTimer(GetPVarInt(playerid, "id_timer_mini_game"));

    new text[35];
    if(game == 1)
    {
        for(new a;a < sizeof spawn_mini_game_gift;a++)
        {
            DestroyPickup(m_g_player_gift[playerid][a][0]);
            m_g_player_gift[playerid][a][1] = -1;
        }
        for(new m;m < sizeof spawn_mini_game_gift;m++)
        {
            DestroyDynamicArea(m_g_player_gift[playerid][m][1]);
            m_g_player_gift[playerid][m][1] = -1;
        }

        new gift = random(20) + 20 - random(10);

        SendClientMessage(playerid, -1, ""SC"     - {FFFF00}\" \"");
        format(text, sizeof text, "  %d ", gift);

        UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + gift);
        SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + gift);

        format(text, sizeof text, "~s~+%d ~b~", gift);

        GameTextForPlayer(playerid, text, 2000, 3);

        if(GetPlayerNewYear(playerid, NEW_QUEST_6) == 0) quest_complete(playerid, 6);
    }
    else if(game == 2)
    {
        if(GetPVarInt(playerid, "mini_game_sphere")) DestroyDynamicArea(GetPVarInt(playerid, "mini_game_sphere"));
        DeletePVar(playerid, "mini_game_sphere");

        for(new a;a < sizeof spawn_mini_game_2_gift;a++)
        {
            DestroyPickup(m_g_2_player_gift[playerid][a][0]);
            m_g_2_player_gift[playerid][a][1] = -1;
        }
        for(new m;m < sizeof spawn_mini_game_2_gift;m++)
        {
            DestroyDynamicArea(m_g_2_player_gift[playerid][m][1]);
            m_g_2_player_gift[playerid][m][1] = -1;
        }

        new gift = random(30) + 30 - random(10);

        SendClientMessage(playerid, -1, ""SC"     - {FFFF00}\"  \"");
        format(text, sizeof text, "  %d ", gift);

        UpdatePlayerDatabaseInt(playerid, "snowcoins", GetPlayerNewYear(playerid, SNOW_COINS) + gift);
        SetPlayerNewYear(playerid, SNOW_COINS, GetPlayerNewYear(playerid, SNOW_COINS) + gift);

        format(text, sizeof text, "~s~+%d ~b~", gift);

        GameTextForPlayer(playerid, text, 2000, 3);

        if(GetPlayerNewYear(playerid, NEW_QUEST_7) == 0) quest_complete(playerid, 7);

        if(GetPlayerNewYear(playerid, VEH_QUEST)) DestroyVehicle(GetPlayerNewYear(playerid, VEH_QUEST));
        SetPlayerNewYear(playerid, VEH_QUEST, -1);
    }

    return 1;
}

stock LoadMiniGame(playerid, game)
{
    new const virtual = GetPlayerVirtualWorld(playerid);

    if(game == 1)
    {
        SetPVarInt(playerid, "second_to_player", 30);

        switch (random(3))
        {
            case 0:SetPlayerPosEx(playerid, 270.130920, 2145.645263, 1769.511840, 320.859802, 1, virtual, false);
            case 1:SetPlayerPosEx(playerid, 310.014099, 2159.303955, 1769.517700, 181.308807, 1, virtual, false);
            case 2:SetPlayerPosEx(playerid, 311.304016, 2157.034179, 1765.466308, 172.350769, 1, virtual, false);
        }

        TeleportFreeze(playerid, 3500);

        SendClientMessage(playerid, -1, ""SC" .   ");

        SetTimerEx("StartMiniGame", 3000, false, "ii", playerid, 1);

        for(new a;a < sizeof spawn_mini_game_gift;a++)
        {
            m_g_player_gift[playerid][a][0] = CreatePickup(19055, 23, spawn_mini_game_gift[a][0], spawn_mini_game_gift[a][1], spawn_mini_game_gift[a][2], virtual);
        }

        for(new m;m < sizeof spawn_mini_game_gift;m++)
        {
            m_g_player_gift[playerid][m][1] = CreateDynamicSphere(spawn_mini_game_gift[m][0], spawn_mini_game_gift[m][1], spawn_mini_game_gift[m][2], 2.0, virtual, 1);
        }

        SetPlayerNewYear(playerid, MINI_GAME_GIFT, 10);
    }
    else if(game == 2)
    {
        SetPVarInt(playerid, "second_to_player", 50);

        SetPlayerPos(playerid, -170.671447,452.541137,12.360505);

        SetPVarInt(playerid, "mini_game_sphere", CreateDynamicRectangle(-263.672546, 373.074157, -94.233909, 551.940795, virtual, -1, playerid));
    
        new vehicle = CreateVehicle(471, -170.671447,452.541137,12.360505, 0.0, 1, 1, -1);

        SetVehicleVirtualWorld(vehicle, virtual);

        SetPlayerNewYear(playerid, VEH_QUEST, vehicle);
        PutPlayerInVehicle(playerid, vehicle, 0);

        TeleportFreeze(playerid, 3500);

        SendClientMessage(playerid, -1, ""SC" .   ");

        SetTimerEx("StartMiniGame", 3000, false, "ii", playerid, 2);

        for(new a;a < sizeof spawn_mini_game_2_gift;a++)
        {
            m_g_2_player_gift[playerid][a][0] = CreatePickup(19055, 23, spawn_mini_game_2_gift[a][0], spawn_mini_game_2_gift[a][1], spawn_mini_game_2_gift[a][2] + 1.0, virtual);
        }

        for(new m;m < sizeof spawn_mini_game_2_gift;m++)
        {
            m_g_2_player_gift[playerid][m][1] = CreateDynamicSphere(spawn_mini_game_2_gift[m][0], spawn_mini_game_2_gift[m][1], spawn_mini_game_2_gift[m][2] + 1.0, 2.0, virtual, -1, playerid);
        }

        SetPlayerNewYear(playerid, MINI_GAME_GIFT, 15);

        switch(random(4))
        {
            case 0:
            {
                SetVehiclePos(vehicle, -162.783950,382.375000,12.363014);
                SetVehicleZAngle(vehicle, 18.222908);
            }
            case 1:
            {
                SetVehiclePos(vehicle, -221.507476,404.091156,12.365059);
                SetVehicleZAngle(vehicle, 298.902282);                 
            }
            case 2:
            {
                SetVehiclePos(vehicle, -183.687118,543.433898,12.361413);
                SetVehicleZAngle(vehicle, 200.229232);                 
            }
            case 3:
            {
                SetVehiclePos(vehicle, -122.908905,527.693237,12.360453);
                SetVehicleZAngle(vehicle, 137.543060);                 
            }
        }
    }

    for(new i;i < 2;i++)
    {
        TextDrawShowForPlayer(playerid, time_mini_game_TD[i]);
    }

    TextDrawMiniGamePlayer(playerid);
    PlayerTextDrawShow(playerid, time_mini_game_PTD[playerid][0]);
    
    TextDrawShowForPlayer(playerid, time_mini_game_TD[2]);

    return 1;
}

public:StartMiniGame(playerid, game)
{
    if(game == 1)
    {    
        SendClientMessage(playerid, -1, ""SC"  .     30 ");

        SetPVarInt(playerid, "id_timer_mini_game", SetTimerEx("ChangeTimerMiniGame", 1000, true, "ii", playerid, game));
    }
    else if(game == 2)
    {
        SendClientMessage(playerid, -1, ""SC"  .     50 ");

        SetPVarInt(playerid, "id_timer_mini_game", SetTimerEx("ChangeTimerMiniGame", 1000, true, "ii", playerid, game));
    }
    return 1;
}

stock InPlayerGameGift(playerid, game)
{
    new area = -1;

	if(game == 1)
    {
        for(new idx; idx < 10; idx ++)
	    {
	    	if(!IsPlayerInDynamicArea(playerid, m_g_player_gift[playerid][idx][1])) continue;
            area = idx;
	    }
    }
    else if(game == 2)
    {
        for(new idx; idx < 15; idx ++)
	    {
	    	if(!IsPlayerInDynamicArea(playerid, m_g_2_player_gift[playerid][idx][1])) continue;
            area = idx;
	    }
    }

	return area;
}

stock GetFreeWinterOwnableCarID()
{
	for(new idx; idx < sizeof g_ownable_car; idx ++)
	{
		if(GetOwnableCarData(idx, OC_CREATE)) continue;

		return idx;
	}

	return -1;
}

stock GivePlayerWinterCar(playerid, vehicle)
{
		new to_player = playerid;
	    new Float: pos_x = -335.7250;
	    new Float: pos_y = 424.3185;
	    new Float: pos_z = 12.2686;
	    new Float: angle = 356.7986;
		new query[220],
			Cache: result,
			idx;

		format
		(
			query, sizeof query,
			"INSERT INTO ownable_cars \
			(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
			VALUES \
			('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
			GetPlayerAccountID(to_player),
			vehicle,
			1,
			1,
			pos_x,
			pos_y,
			pos_z,
			angle,
			gettime()
		);
		result = mysql_query(mysql, query, true);
		cache_delete(result);

        return 1;
}

CMD:givesnow(playerid, params[])
{
    if(!(GetPlayerAdminEx(playerid) >= 7)) return 1;

    new reason[144];

	extract params -> new to_player, snow; else return SendClientMessage(playerid, 0xCECECEFF, ": /givesnow [id ] [c]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "  ");

	if(!(-1_000 <= snow <= 1_000)) return SendClientMessage(playerid, 0xCECECEFF, "   1  1000    ");

	format(reason, sizeof reason, " %s   %d ", GetPlayerNameEx(playerid), snow);
	SendClientMessage(to_player, 0xFFFFFFFF, reason);

	format(reason, sizeof reason, "[A] %s[%d]   %s[%d]  - %d ,     %d ",
	GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, snow, GetPlayerNewYear(playerid, SNOW_COINS));

	SendMessageToAdmins(reason, 0xFFFF00FF);

    UpdatePlayerDatabaseInt(to_player, "snowcoins", GetPlayerNewYear(to_player, SNOW_COINS) + snow);
    SetPlayerNewYear(to_player, SNOW_COINS, GetPlayerNewYear(to_player, SNOW_COINS) + snow);

	return 1;
}

CMD:exitsnowquest(playerid)
{
    if(GetPVarInt(playerid, "quest_1_new_year"))  RemoveQuestNewYear(playerid, 1);
    else if(GetPVarInt(playerid, "quest_2_new_year"))  RemoveQuestNewYear(playerid, 2);
    else if(GetPVarInt(playerid, "quest_3_new_year"))  RemoveQuestNewYear(playerid, 3);
    else if(GetPVarInt(playerid, "quest_4_new_year"))  RemoveQuestNewYear(playerid, 4);
    else if(GetPVarInt(playerid, "quest_5_new_year"))  RemoveQuestNewYear(playerid, 5);
    else SendClientMessage(playerid, -1, ""USC"    ");

    return 1;
}

CMD:newyear(playerid)
{
    EnablePlayerGPS(playerid, 55, ded_coord[0], ded_coord[1], ded_coord[2], "    ");

    return 1;
}

stock ShowDialogQuest3(playerid, count)
{
    if(0 <= count <= sizeof q_3_dialog)
    {
        if(count == 7)
        {
            if(GetPVarInt(playerid, "count_letter") == 8) 
            {
                if(!(GetPVarInt(playerid, "count_letter_wrong") >= 2)) 
                {
                    quest_complete(playerid, 3);
                }
                else SendClientMessage(playerid, -1, ""USC"     .  ");

                RemoveQuestNewYear(playerid, 3);

                return 1;
            }
        }

        Dialog
        (
            playerid, 4451, DIALOG_STYLE_MSGBOX, 
            q_3_dialog[count][Q_3_DIALOG_TITLE], 
            q_3_dialog[count][Q_3_DIALOG], 
            q_3_dialog[count][Q_3_BUTTON_1], q_3_dialog[count][Q_3_BUTTON_2]
        );   
   }
   return 1;
}

//   https://t.me/welsistudio (Welsi Studio)


//   https://t.me/welsistudio (Welsi Studio)


//   https://t.me/welsistudio (Welsi Studio)

