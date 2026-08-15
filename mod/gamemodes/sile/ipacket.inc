enum
{
    ENTER_ENGINE = 2,
    ENTER_CONT = 3,
    OFFER_YES = 4,
    OFFER_ENGINE = 5,
    EXIT_HOME = 6,
    GUI_LOCK = 7,
    OFFER_UNLOCK_CAR = 8,
    OFFER_TRUNK = 10,
    OFFER_TRADE = 11,
    OFFER_TRADE_NO = 12,
}

new car_game_ids[][2] = {
    {5, 555},
    {6, 549},
    {7, 401},
    {8, 479},
    {9, 496},
    {10, 404},
    {11, 458},
    {12, 585},
    {13, 536},
    {14, 529},
    {15, 534},
    {16, 542},
    {17, 540},
    {18, 559},
    {19, 421},
    {20, 2554},
    {21, 2548},
    {22, 419},
    {23, 562},
    {24, 507},
    {25, 426},
    {26, 516},
    {27, 467},
    {28, 527},
    {29, 445},
    {30, 589},
    {31, 587},
    {32, 436},
    {33, 560},
    {34, 550},
    {35, 603},
    {36, 2552},
    {37, 565},
    {38, 551},
    {39, 526},
    {40, 442},
    {41, 489},
    {42, 543},
    {43, 480},
    {44, 558},
    {45, 495},
    {46, 475},
    {47, 503},
    {48, 410},
    {49, 402},
    {50, 2553},
    {51, 505},
    {52, 2547},
    {53, 502},
    {54, 400},
    {55, 604},
    {56, 405},
    {57, 506},
    {58, 2550},
    {59, 466},
    {60, 2545},
    {61, 490},
    {62, 420},
    {63, 533},
    {64, 2546},
    {65, 494},
    {66, 429},
    {67, 451},
    {68, 2544},
    {69, 2551},
    {70, 2549},
    {71, 579},
    {72, 541},
    {73, 411},
    {74, 415},
    {75, 2543},
    {76, 462},
    {77, 468},
    {78, 461},
    {79, 463},
    {80, 523},
    {81, 586},
    {82, 521},
    {83, 581},
    {84, 522},
    {85, 582},
    {86, 529},
    {87, 470},
    {88, 416},
    {89, 516},
    {90, 596},
    {201, 413},
    {202, 418},
    {195, 440},
    {211, 2555},
    {212, 2557},
    {213, 2565},
    {214, 2566},
    {215, 2560},
    {216, 2561},
    {217, 2568},
    {218, 2567},
    {219, 2559},
    {220, 2558},
    {353, 2583},
    {221, 2564},
    {222, 2563},
    {223, 2570},
    {224, 2569},
    {275, 2571},
    {276, 2572},
    {327, 2574},
    {328, 2575},
    {329, 2573},
    {330, 2577},
    {331, 2576},
    {366, 2586},
    {367, 2585},
    {349, 2582},
    {400, 412},
    {401, 439},
    {402, 492},
    {403, 547},
    {404, 491},
    {405, 546},
    {406, 2589},
    {407, 2588},
    {408, 2587},
    {409, 483},
    {410, 2590},
    {411, 2591},
    {413, 452},
    {414, 453},
    {415, 454},
    {416, 472},
    {417, 473},
    {418, 493},
    {424, 2592},
    {426, 2594},
    {427, 2596},
    {428, 2595},
    {429, 2593},
    {444, 2597},
    {445, 2598},
    {446, 2599},
    {447, 2600},
    {448, 2601},
    {449, 2602},
    {450, 2603},
    {451, 2604},
    {452, 2607},
    {453, 2608},
    {454, 2609},
    {455, 2610},
    {456, 2611},
    {459, 448},
    {460, 2616},
    {461, 2617},
    {465, 2618},
    {466, 2619},
    {467, 2620},
    {468, 2621},
    {469, 2622},
    {470, 2623},
    {471, 2624},
    {472, 2625},
    {473, 2626},
    {474, 2627},
    {484, 434},
    {485, 2377},
    {498, 2380},
    {499, 2381},
    {500, 2385},
    {501, 2386},
    {502, 2387},
    {503, 2388},
    {504, 2389},
    {505, 2390},
    {506, 2391},
    {507, 2392},
    {508, 2393},
    {509, 2394},
    {510, 2382},
    {511, 2383},
    {512, 2384},
    {522, 614},
    {523, 613},
    {524, 622},
    {543, 762},
    {544, 763},
    {545, 760},
    {546, 759},
    {547, 761},
    {551, 28669},
    {552, 28670},
    {553, 28671},
    {554, 28672},
    {555, 28689},
    {556, 28693},
    {557, 28694},
    {558, 28695},
    {559, 28696},
    {560, 28697}
};

new clothes_game_ids[][2] = {
    {475, 11917},
    {462, 12293},
    {463, 12291},
    {457, 14386},
    {458, 14388},
    {419, 5323},
    {430, 5326},
    {431, 5325},
    {425, 5362},
    {420, 5367},
    {421, 5365},
    {399, 18606},
    {390, 310},
    {391, 18621},
    {392, 311},
    {393, 18620},
    {394, 18623},
    {395, 18624},
    {396, 18625},
    {397, 18626},
    {398, 18628},
    {346, 2},
    {344, 302},
    {345, 301},
    {332, 196},
    {333, 129},
    {334, 130},
    {335, 24},
    {340, 197},
    {336, 245},
    {337, 243},
    {338, 89},
    {339, 88},
    {341, 10},
    {342, 92},
    {343, 99},
    {315, 110},
    {313, 108},
    {311, 95},
    {322, 49},
    {323, 53},
    {324, 160},
    {314, 109},
    {312, 106},
    {316, 165},
    {317, 166},
    {318, 174},
    {319, 5},
    {320, 267},
    {321, 283},
    {325, 162},
    {326, 210},
    {238, 65},
    {257, 209},
    {239, 39},
    {240, 207},
    {225, 86},
    {226, 224},
    {227, 232},
    {228, 269},
    {205, 252},
    {206, 236},
    {207, 48},
    {208, 63},
    {91, 23},
    {92, 22},
    {229, 231},
    {93, 220},
    {94, 225},
    {230, 175},
    {95, 202},
    {96, 204},
    {97, 229},
    {203, 57},
    {231, 208},
    {232, 199},
    {233, 264},
    {234, 262},
    {235, 62},
    {98, 200},
    {99, 234},
    {100, 249},
    {101, 235},
    {236, 298},
    {237, 266},
    {209, 270},
    {210, 122},
    {480, 11934},
    {481, 11933},
    {482, 11935},
    {483, 11944},
    {486, 11956},
    {487, 11958},
    {488, 11953},
    {489, 11948},
    {490, 11951},
    {491, 11947},
    {492, 11957},
    {497, 11959},
    {513, 19262},
    {514, 19273},
    {515, 6780},
    {516, 11961},
    {517, 11962},
    {519, 6832},
    {525, 6893},
    {526, 6896},
    {527, 6892},
    {528, 6895},
    {529, 6894},
    {535, 6871},
    {536, 6872},
    {561, 5500046},
    {562, 5500047},
    {564, 5500075},
    {563, 11943}
};

new accessories_game_ids[][2] = {
    {534, 917},
    {533, 916},
    {530, 914},
    {531, 915},
    {532, 916},
    {518, 709},
    {493, 660},
    {494, 662},
    {495, 663},
    {496, 664},
    {476, 579},
    {477, 582},
    {478, 583},
    {479, 585},
    {463, 576},
    {464, 578},
    {432, 513},
    {433, 515},
    {434, 516},
    {436, 520},
    {437, 521},
    {438, 522},
    {439, 527},
    {440, 531},
    {441, 532},
    {442, 533},
    {443, 534},
    {435, 536},
    {422, 508},
    {423, 511},
    {368, 359},
    {369, 360},
    {370, 361},
    {371, 362},
    {372, 363},
    {373, 364},
    {374, 365},
    {375, 366},
    {376, 367},
    {377, 368},
    {378, 369},
    {379, 370},
    {380, 371},
    {381, 372},
    {382, 373},
    {383, 374},
    {384, 375},
    {385, 376},
    {386, 377},
    {387, 378},
    {388, 379},
    {389, 380},
    {354, 347},
    {355, 348},
    {356, 349},
    {357, 350},
    {358, 351},
    {359, 352},
    {360, 353},
    {361, 354},
    {362, 355},
    {363, 356},
    {364, 357},
    {365, 358},
    {277, 170},
    {278, 169},
    {279, 180},
    {280, 187},
    {295, 295},
    {296, 296},
    {297, 297},
    {281, 200},
    {282, 201},
    {283, 210},
    {284, 216},
    {285, 220},
    {286, 221},
    {287, 263},
    {288, 264},
    {289, 265},
    {290, 281},
    {291, 287},
    {292, 289},
    {293, 290},
    {294, 291},
    {298, 301},
    {299, 302},
    {300, 303},
    {301, 304},
    {302, 308},
    {303, 309},
    {304, 313},
    {305, 316},
    {306, 321},
    {307, 322},
    {308, 323},
    {309, 324},
    {310, 326},
    {243, 138},
    {244, 139},
    {245, 140},
    {246, 141},
    {241, 136},
    {242, 137},
    {274, 161},
    {247, 142},
    {248, 145},
    {249, 151},
    {250, 153},
    {251, 152},
    {252, 154},
    {254, 143},
    {255, 144},
    {256, 155},
    {253, 160},
    {258, 149},
    {259, 146},
    {260, 147},
    {261, 148},
    {263, 156},
    {264, 157},
    {265, 158},
    {266, 159},
    {267, 150},
    {549, 576},
    {542, 578}, 
    {549, 983}
};

stock engineon(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) return 1;

    if(!IsABike(vehicleid))
    {
        if(!IsPlayerDriver(playerid))
            return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

        new engine = GetVehicleParam(vehicleid, V_ENGINE) ^ VEHICLE_PARAM_ON;
        SetVehicleParam(vehicleid, V_ENGINE, engine);

        new idx = GetVehicleData(vehicleid, V_ACTION_ID);
        if(idx != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        {
            if(g_ownable_car[idx][OC_HORN_ID] != 0)
            {
                SetVehicleHornSound(vehicleid, g_ownable_car[idx][OC_HORN_ID], 1);
            }
            if(g_ownable_car[idx][OC_EXHAUST] != 0)
            {
                SetVehicleExhaust(vehicleid, g_ownable_car[idx][OC_EXHAUST], 1);
            }
            if(g_ownable_car[idx][OC_OBCLEARANCE] != -1)
            {
                    new suspension = max(g_ownable_car[idx][OC_OBCLEARANCE] / 50.0, 0.2);
                    SetVehicleSuspensionForce(vehicleid, suspension, 0);
            }
            if(g_ownable_car[idx][OC_NITRO] != -1)
            {
                switch(g_ownable_car[idx][OC_NITRO])
                {
                    case 0: AddVehicleComponent(vehicleid, 1008);
                    case 1: AddVehicleComponent(vehicleid, 1009);
                    case 2: AddVehicleComponent(vehicleid, 1010);
                }
            }
            if(g_ownable_car[idx][OC_ENABLE_HAND] != 0)
            {
                switch(g_ownable_car[idx][OC_ENABLE_HAND])
                {
                    case 0: SetVehicleStockFP(playerid, vehicleid);
                    case 1: SetVehicleComfortFP(playerid, vehicleid);
                    case 2: SetVehicleDriftFP(playerid, vehicleid);
                    case 3: SetVehicleSportFP(playerid, vehicleid);
                    case 4: SetVehicleSportPlusFP(playerid, vehicleid);
                    default: SetVehicleStockFP(playerid, vehicleid);
                }
            }
	    }
    }

    return 1;
}

stock lightss(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0) return 1;

    if(IsABike(vehicleid)) return 1;

    if(!IsPlayerDriver(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не за рулем");

    new lights = GetVehicleParam(vehicleid, V_LIGHTS) ^ VEHICLE_PARAM_ON;
    SetVehicleParam(vehicleid, V_LIGHTS, lights);

    return 1;
}

stock IsValidSkinModel(modelid)
{
    if (modelid < 0 || modelid > 10000000) return 0;
    if (modelid == 3 || modelid == 4 || modelid == 5 || modelid == 6 || modelid == 8) return 0;
    return 1;
}

IPacket:252(playerid, BitStream:bitstream)
{
    new header, guiid, Node:json = JSON_Object(), outcoming_data[256];

    BS_ReadValue(bitstream, PR_UINT8, header);
    BS_ReadValue(bitstream, PR_UINT16, guiid);

    new length;
    BS_ReadValue(bitstream, PR_UINT32, length);

    if(length <= 0 || length >= 256) {
        printf("[IPacket:252] - Invalid JSON length: %d from player %d", length, playerid);
        return 0;
    }

    new json_data[256];
    BS_ReadValue(bitstream, PR_STRING, json_data, length);

    new Node:JSONObject = JSON_Object();

    JSON_Parse(json_data, JSONObject);

    if(JSON_NodeType(JSONObject) == JSON_NODE_NULL) {
        printf("[IPacket:252] - Failed to parse JSON from player %d: %s", playerid, json_data);
        JSON_Cleanup(JSONObject);
        return 0;
    }

    switch(guiid)
    {
        case 77:
        {
            Marketplace_HandlePacket(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        case 31:
        {
            new type;
            JSON_GetInt(JSONObject, "t", type);

            if(type == 0)
            {
                new success;
                JSON_GetInt(JSONObject, "s", success);

                if(success == 1)
                {
                    if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_MINER_LOAD)
                    {
                        return 0;
                    }
                    SetPlayerTempJobState(playerid, TEMP_JOB_STATE_NONE);
                    ShowTutorialHintGUI(playerid, "Сдайте руду на ленту,\nдля переплава");
                    ClearAnimations(playerid);
                    SetPlayerMinerJobUnLoadCP(playerid);
                    SendCreateWayPoint(playerid, 1, 557.1261, 515.9763, 999.7144, 85, 1, 30000.0, 1);
                    if(MiningTimer[playerid] != -1)
                    {
                        KillTimer(MiningTimer[playerid]);
                        MiningTimer[playerid] = -1;
                    }
                }
                else
                {
                    if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_MINER_LOAD)
                    {
                        return 0;
                    }
                    ShowPlayerFingerGUI(playerid, 1);
                }
            }
        }
        case 28:
        {
            PacketIncomingTuning(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        case 37:
        {
            HandlePacketDV(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        /*case 50:
        {
            new spawn_id, Float:XposSpawn, Float:YposSpawn, Float:ZposSpawn,
                Float:AposSpawn, WorldSpawn, IntSpawn, DomSpawn[MAX_PLAYERS] = 4;

            printf("[DEBUG] Case 50 triggered for player %d", playerid);
            JSON_GetInt(JSONObject, "t", spawn_id);
            printf("[DEBUG] Player %d spawn_id = %d", playerid, spawn_id);

            switch(spawn_id)
            {
                case 1:
                {
                    new spawn_id_int = random(5);
                    printf("[DEBUG] Case 1 (Вокзал) for player %d, random index = %d", playerid, spawn_id_int);

                    XposSpawn = spawn_pos_data[spawn_id_int][0];
                    YposSpawn = spawn_pos_data[spawn_id_int][1];
                    ZposSpawn = spawn_pos_data[spawn_id_int][2];
                    AposSpawn = spawn_pos_data[spawn_id_int][3];
                    WorldSpawn = 0;
                    IntSpawn = 0;

                    printf("[DEBUG] Spawn position: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f",
                           XposSpawn, YposSpawn, ZposSpawn, AposSpawn);
                }
                case 0:
                {
                    new team_id = GetPlayerTeamEx(playerid);
                    printf("[DEBUG] Case 0 (Организация) for player %d, team_id = %d", playerid, team_id);

                    XposSpawn = GetTeamData(team_id, O_SPAWN)[0];
                    YposSpawn = GetTeamData(team_id, O_SPAWN)[1];
                    ZposSpawn = GetTeamData(team_id, O_SPAWN)[2];
                    AposSpawn = GetTeamData(team_id, O_SPAWN)[3];
                    IntSpawn = GetTeamData(team_id, O_SPAWN_INT);
                    WorldSpawn = GetTeamData(team_id, O_SPAWN_VW);

                    printf("[DEBUG] Team spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f, Int=%d, VW=%d",
                           XposSpawn, YposSpawn, ZposSpawn, AposSpawn, IntSpawn, WorldSpawn);
                }
                case 2:
                {
                    printf("[DEBUG] Case 2 (Последняя позиция) for player %d", playerid);

                    XposSpawn = GetPlayerData(playerid, P_LAST_POS_X);
                    YposSpawn = GetPlayerData(playerid, P_LAST_POS_Y);
                    ZposSpawn = GetPlayerData(playerid, P_LAST_POS_Z);
                    AposSpawn = GetPlayerData(playerid, P_LAST_POS_A);
                    WorldSpawn = 0;
                    IntSpawn = 0;

                    printf("[DEBUG] Last position: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f",
                           XposSpawn, YposSpawn, ZposSpawn, AposSpawn);
                }
                case 4:
                {
                    new house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
                    printf("[DEBUG] Case 4 (Дом) for player %d, house_id = %d", playerid, house_id);

                    if(house_id == -1)
                    {
                        printf("[DEBUG] Player %d has no house, using random spawn", playerid);
                        new spawn_id_int = random(5);
                        XposSpawn = spawn_pos_data[spawn_id_int][0];
                        YposSpawn = spawn_pos_data[spawn_id_int][1];
                        ZposSpawn = spawn_pos_data[spawn_id_int][2];
                        AposSpawn = spawn_pos_data[spawn_id_int][3];
                        WorldSpawn = 0;
                        IntSpawn = 0;

                        printf("[DEBUG] Random spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f",
                               XposSpawn, YposSpawn, ZposSpawn, AposSpawn);
                        return 1;
                    }

                    new type = GetHouseData(house_id, H_TYPE);
                    printf("[DEBUG] House ID %d, type = %d", house_id, type);

                    XposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_X);
                    YposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_Y);
                    ZposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_Z);
                    AposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE);
                    IntSpawn = GetHouseTypeInfo(type, HT_INTERIOR);
                    WorldSpawn = house_id + 2000;
                    DomSpawn[playerid] = 4;
                    SetPlayerData(playerid, P_IN_HOUSE, house_id);
                    printf("[DEBUG] House spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f, Int=%d, VW=%d (house_id=%d+2000)",
                           XposSpawn, YposSpawn, ZposSpawn, AposSpawn, IntSpawn, WorldSpawn, house_id);
                }
                case 6:
                {
                    new fam_id = GetPlayerIdFamily(playerid);
                    printf("[DEBUG] Case 6 (Дом семьи) for player %d, fam_id = %d", playerid, fam_id);

                    if(fam_id == -1 || family[fam_id][family_house] == -1)
                    {
                        printf("[DEBUG] Player %d no family (fam_id=%d) or family has no house (family_house=%d)",
                               playerid, fam_id, (fam_id != -1) ? family[fam_id][family_house] : -1);

                        new spawn_id_int = random(5);
                        XposSpawn = spawn_pos_data[spawn_id_int][0];
                        YposSpawn = spawn_pos_data[spawn_id_int][1];
                        ZposSpawn = spawn_pos_data[spawn_id_int][2];
                        AposSpawn = spawn_pos_data[spawn_id_int][3];
                        WorldSpawn = 0;
                        IntSpawn = 0;

                        printf("[DEBUG] Random spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f",
                               XposSpawn, YposSpawn, ZposSpawn, AposSpawn);
                        return 1;
                    }

                    new house_id = GetHouseIndexBySQLID(family[fam_id][family_house]);
                    printf("[DEBUG] Family %d, house SQL ID = %d, house index = %d",
                           fam_id, family[fam_id][family_house], house_id);

                    new type = GetHouseData(house_id, H_TYPE);
                    printf("[DEBUG] Family house ID %d, type = %d", house_id, type);

                    XposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_X);
                    YposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_Y);
                    ZposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_Z);
                    AposSpawn = GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE);
                    IntSpawn = GetHouseTypeInfo(type, HT_INTERIOR);
                    WorldSpawn = house_id + 2000;
                    DomSpawn[playerid] = 6;
                    SetPlayerData(playerid, P_IN_HOUSE, house_id);
                    printf("[DEBUG] Family house spawn: X=%.2f, Y=%.2f, Z=%.2f, A=%.2f, Int=%d, VW=%d (house_id=%d+2000)",
                           XposSpawn, YposSpawn, ZposSpawn, AposSpawn, IntSpawn, WorldSpawn, house_id);
                }
                default:
                {
                    printf("[DEBUG] Unknown spawn_id %d for player %d", spawn_id, playerid);
                }
            }

            printf("[DEBUG] Final spawn setup for player %d: Pos(%.2f, %.2f, %.2f, %.2f), Int=%d, VW=%d, DomSpawn=%d",
                   playerid, XposSpawn, YposSpawn, ZposSpawn, AposSpawn, IntSpawn, WorldSpawn, DomSpawn[playerid]);

            SetSpawnInfo(playerid, 0, GetPlayerSkinEx(playerid),
                         XposSpawn, YposSpawn, ZposSpawn, AposSpawn,
                         0, 0, 0, 0, 0, 0);

            SetPlayerInterior(playerid, IntSpawn);
            SetPlayerVirtualWorld(playerid, WorldSpawn);

            SetPlayerPosEx(playerid, XposSpawn, YposSpawn, ZposSpawn,
                           AposSpawn, IntSpawn, WorldSpawn);

            if(DomSpawn[playerid] == 4)
            {
                new house_id = GetPlayerHouse(playerid, HOUSE_TYPE_HOME);
                printf("[DEBUG] Setting player %d in house (type 4), house_id = %d", playerid, house_id);
                SetPlayerData(playerid, P_IN_HOUSE, house_id);
            }
            else if(DomSpawn[playerid] == 6)
            {
                new fam_id = GetPlayerIdFamily(playerid);
                new house_id = GetHouseIndexBySQLID(family[fam_id][family_house]);
                printf("[DEBUG] Setting player %d in family house (type 6), fam_id=%d, house_id=%d",
                       playerid, fam_id, house_id);
                SetPlayerData(playerid, P_IN_HOUSE, house_id);
            }

            if(GetPlayerAdminEx(playerid))
            {
                AdminAuthorization(playerid);
                SetPlayerColorEx(playerid, 0xFF0000FF);
            }

            if(GetPlayerData(playerid, P_WORK_DAY) == 1 && GetPlayerData(playerid, P_OSKIN) > 0)
            {
                SetPlayerSkin(playerid, GetPlayerData(playerid, P_OSKIN));
                SetPlayerColorInit(playerid);
            }
            BlackPass_OnPlayerLogin(playerid);

            printf("[DEBUG] Sending response packet to player %d", playerid);
            new Node:json_response = JSON_Object();
            JSON_SetInt(json_response, "c", 1);
            SendPacketToClient(playerid, 50, json_response);
            JSON_Cleanup(json_response);

            printf("[DEBUG] Case 50 completed for player %d", playerid);
        }*/
        case 50:
        {
            new
                spawn_id;

            JSON_GetInt(JSONObject, "t", spawn_id);

            switch(spawn_id)
            {
                case 1:
                {
                    new spawn_id_int = random(5);
	
                    SetSpawnInfo
                    (
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        spawn_pos_data[spawn_id][0], // + random(5),
                        spawn_pos_data[spawn_id][1], // + random(5),
                        spawn_pos_data[spawn_id][2],
                        spawn_pos_data[spawn_id][3],
                        0, 0, 0, 0, 0, 0
                    );
                    SetPlayerInterior(playerid, 0);
                    SetPlayerVirtualWorld(playerid, 0);
                }

                case 2:
                {
                    SetSpawnInfo
                    (
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        GetPlayerData(playerid, P_LAST_POS_X),
                        GetPlayerData(playerid, P_LAST_POS_Y),
                        GetPlayerData(playerid, P_LAST_POS_Z),
                        GetPlayerData(playerid, P_LAST_POS_A),
                        0, 0, 0, 0, 0, 0
                    );
                    SetPlayerInterior(playerid, 0);
                    SetPlayerVirtualWorld(playerid, 0);
                }

                case 0:
                {
                    new team_id = GetPlayerTeamEx(playerid);

                    SetSpawnInfo
                    (
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        GetTeamData(team_id, O_SPAWN)[0],
                        GetTeamData(team_id, O_SPAWN)[1],
                        GetTeamData(team_id, O_SPAWN)[2],
                        GetTeamData(team_id, O_SPAWN)[3],
                        0, 0, 0, 0, 0, 0
                    );

                    SetPlayerInterior(playerid, GetTeamData(team_id, O_SPAWN_INT));
                    SetPlayerVirtualWorld(playerid, GetTeamData(team_id, O_SPAWN_VW));
                }
                
                case 4:
                {
                    new type = GetHouseData(GetPlayerHouse(playerid, HOUSE_TYPE_HOME), H_TYPE);

                    SetSpawnInfo
                    (
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        GetHouseTypeInfo(type, HT_ENTER_POS_X),
                        GetHouseTypeInfo(type, HT_ENTER_POS_Y),
                        GetHouseTypeInfo(type, HT_ENTER_POS_Z),
                        GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE),
                        0, 0, 0, 0, 0, 0
                    );

                    SetPlayerInterior(playerid, GetHouseTypeInfo(type, HT_INTERIOR));
                    SetPlayerVirtualWorld(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME) + 2000);
                    
                    SetPlayerInHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));

                    // EnterPlayerToHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));
                }
                       case 6:
                {
                    new fam_id = GetPlayerIdFamily(playerid);
                    printf("[DEBUG] Case 6 (Дом семьи) for player %d, fam_id = %d", playerid, fam_id);

                    new house_id = GetHouseIndexBySQLID(family[fam_id][family_house]);
                    printf("[DEBUG] Family %d, house SQL ID = %d, house index = %d",
                           fam_id, family[fam_id][family_house], house_id);

                    new type = GetHouseData(house_id, H_TYPE);
                    printf("[DEBUG] Family house ID %d, type = %d", house_id, type);

                    SetSpawnInfo
                    (
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        GetHouseTypeInfo(type, HT_ENTER_POS_X),
                        GetHouseTypeInfo(type, HT_ENTER_POS_Y),
                        GetHouseTypeInfo(type, HT_ENTER_POS_Z),
                        GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE),
                        0, 0, 0, 0, 0, 0
                    );

                    SetPlayerInterior(playerid, GetHouseTypeInfo(type, HT_INTERIOR));
                    SetPlayerVirtualWorld(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME) + 2000);
                    
                    SetPlayerInHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));
                }         
            }

            SpawnPlayer(playerid);

            if(GetPlayerAdminEx(playerid))
            {
                AdminAuthorization(playerid);
                SetPlayerColorEx(playerid, 0xFF0000FF);
            }

            if(GetPlayerData(playerid, P_WORK_DAY) == 1 && GetPlayerData(playerid, P_OSKIN) > 0)
            {
                SetPlayerSkin(playerid, GetPlayerData(playerid, P_OSKIN));
                SetPlayerColorInit(playerid);
            }
            BlackPass_OnPlayerLogin(playerid);

            JSON_SetInt(json, "c", 1);
            JSON_Stringify(json, outcoming_data);

            SendPacketToClient(playerid, 50, json);

            JSON_Cleanup(json);
        }
        case 45:
        {
            PacketIncomingFamily(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        case 1:
        {
            PacketIncomingPlates(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        case 27:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            new type, Node:jsons = JSON_Object();
            JSON_GetInt(JSONObject, "t", type);
            
            printf("[DEBUG] Case 27 triggered for player %d, vehicle %d, type %d", playerid, vehicleid, type);

            switch(type)
            {
                case 1:
                {
                    printf("[DEBUG] Type 1: Executing park command");
                    callcmd::park(playerid, "");
                    JSON_SetInt(JSONObject, "t", type);
                    JSON_SetInt(JSONObject, "s", 1);
                    printf("[DEBUG] Type 1: Park executed successfully");
                }

                case 3:
                {
                    printf("[DEBUG] Type 3: Executing lock command");
                    callcmd::lock(playerid, "");
                    JSON_SetInt(JSONObject, "t", type);
                    JSON_SetInt(JSONObject, "s", GetVehicleParam(vehicleid, V_LOCK) ? 1 : 0);
                    printf("[DEBUG] Type 3: Lock executed, lock status = %d", GetVehicleParam(vehicleid, V_LOCK));
                }

                case 5:
                {
                    new i = GetVehicleData(vehicleid, V_ACTION_ID);
                    
                    if(i != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[i][OC_LAUNCHCONT] != 0)
                        {
                            new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;
                            
                            if(green_zone_id == -1)
                            {
                                JSON_SetInt(JSONObject, "s", 1);
                                SetVehicleLaunchControlFP(playerid, vehicleid, 1);
                            }
                            else
                            {
                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 0);
                                SendPacketToClient(playerid, 27, JSONObject);
                                ShowNotificationSile(playerid, 2, 5, -1, -1, "Лаунч-контроль нельзя использовать в зеленой зоне.", "");
                            }
                        }
                        else 
                        {
                            JSON_SetInt(JSONObject, "t", type);
                            JSON_SetInt(JSONObject, "s", 0);
                            SendPacketToClient(playerid, 27, JSONObject);
                            ShowNotificationSile(playerid, 2, 5, -1, -1, "В авто не установлен лаунч-контроль.", "");
                        }
                    }
                    else 
                    {
                        JSON_SetInt(JSONObject, "t", type);
                        JSON_SetInt(JSONObject, "s", 0);
                        SendPacketToClient(playerid, 27, JSONObject);
                        ShowNotificationSile(playerid, 2, 5, -1, -1, "В авто не установлен лаунч-контроль.", "");
                    }
                }

                case 6:
                {
                    printf("[DEBUG] Type 6: Executing engineon");
                    engineon(playerid);
                    JSON_SetInt(JSONObject, "t", type);
                    JSON_SetInt(JSONObject, "s", GetVehicleParam(vehicleid, V_ENGINE) ? 1 : 0);
                    printf("[DEBUG] Type 6: Engine executed, engine status = %d", GetVehicleParam(vehicleid, V_ENGINE));
                }

                case 8:
                {
                    new i = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);

                    if(i != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[i][OC_DRIFT] == 1 
                        && g_ownable_car[i][OC_DRIFT1] == 1 
                        && g_ownable_car[i][OC_DRIFT2] == 1 
                        && g_ownable_car[i][OC_DRIFT3] == 1 
                        && g_ownable_car[i][OC_DRIFT4] == 1)
                        {
                            if(g_ownable_car[i][OC_ENABLE_HAND] != 2)
                            {
                                if(g_ownable_car[i][OC_ENABLE_HAND] == 1)
                                {
                                    JSON_SetInt(JSONObject, "t", 9);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[i][OC_ENABLE_HAND] == 3)
                                {
                                    JSON_SetInt(JSONObject, "t", 10);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[i][OC_ENABLE_HAND] == 4)
                                {
                                    JSON_SetInt(JSONObject, "t", 11);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                SetVehicleDriftFP(playerid, vehicleid);
                                g_ownable_car[i][OC_ENABLE_HAND] = 2;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                                mysql_query(mysql, query, false);

                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 1);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                            else 
                            {
                                SetVehicleStockFP(playerid, vehicleid);
                                g_ownable_car[i][OC_ENABLE_HAND] = 0;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                                mysql_query(mysql, query, false);

                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 0);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                        }
                        else ShowNotificationSile(playerid, 2, 5, -1, -1, "У Вас не установлена эта прошивка!", "");
                    }
                    else ShowNotificationSile(playerid, 2, 5, -1, -1, "У Вас не установлена эта прошивка!", "");
                }

                case 9:
                {
                    new i = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);

                    if(i != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[i][OC_COMFORT] == 1 
                        && g_ownable_car[i][OC_COMFORT1] == 1 
                        && g_ownable_car[i][OC_COMFORT2] == 1 
                        && g_ownable_car[i][OC_COMFORT3] == 1 
                        && g_ownable_car[i][OC_COMFORT4] == 1)
                        {
                            if(g_ownable_car[i][OC_ENABLE_HAND] != 1)
                            {
                                if(g_ownable_car[i][OC_ENABLE_HAND] == 2)
                                {
                                    JSON_SetInt(JSONObject, "t", 8);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[i][OC_ENABLE_HAND] == 3)
                                {
                                    JSON_SetInt(JSONObject, "t", 10);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[i][OC_ENABLE_HAND] == 4)
                                {
                                    JSON_SetInt(JSONObject, "t", 11);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                SetVehicleComfortFP(playerid, vehicleid);
                                g_ownable_car[i][OC_ENABLE_HAND] = 1;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                                mysql_query(mysql, query, false);

                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 1);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                            else 
                            {
                                SetVehicleStockFP(playerid, vehicleid);
                                g_ownable_car[i][OC_ENABLE_HAND] = 0;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                                mysql_query(mysql, query, false);

                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 0);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                        }
                        else ShowNotificationSile(playerid, 2, 5, -1, -1, "У Вас не установлена эта прошивка!", "");
                    }
                    else ShowNotificationSile(playerid, 2, 5, -1, -1, "У Вас не установлена эта прошивка!", "");
                }

                case 10:
                {
                    new i = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);

                    if(i != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[i][OC_SPORT] == 1 
                        && g_ownable_car[i][OC_SPORT1] == 1 
                        && g_ownable_car[i][OC_SPORT2] == 1 
                        && g_ownable_car[i][OC_SPORT3] == 1 
                        && g_ownable_car[i][OC_SPORT4] == 1)
                        {
                            if(g_ownable_car[i][OC_ENABLE_HAND] != 3)
                            {
                                if(g_ownable_car[i][OC_ENABLE_HAND] == 1)
                                {
                                    JSON_SetInt(JSONObject, "t", 9);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[i][OC_ENABLE_HAND] == 2)
                                {
                                    JSON_SetInt(JSONObject, "t", 8);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[i][OC_ENABLE_HAND] == 4)
                                {
                                    JSON_SetInt(JSONObject, "t", 11);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                SetVehicleSportFP(playerid, vehicleid);
                                g_ownable_car[i][OC_ENABLE_HAND] = 3;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                                mysql_query(mysql, query, false);

                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 1);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                            else 
                            {
                                SetVehicleStockFP(playerid, vehicleid);
                                g_ownable_car[i][OC_ENABLE_HAND] = 0;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                                mysql_query(mysql, query, false);

                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 0);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                        }
                        else ShowNotificationSile(playerid, 2, 5, -1, -1, "У Вас не установлена эта прошивка!", "");
                    }
                    else ShowNotificationSile(playerid, 2, 5, -1, -1, "У Вас не установлена эта прошивка!", "");
                }

                case 11:
                {
                    new i = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);

                    if(i != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[i][OC_SPORTPLUS] == 1 
                        && g_ownable_car[i][OC_SPORTPLUS1] == 1 
                        && g_ownable_car[i][OC_SPORTPLUS2] == 1 
                        && g_ownable_car[i][OC_SPORTPLUS3] == 1 
                        && g_ownable_car[i][OC_SPORTPLUS4] == 1)
                        {
                            if(g_ownable_car[i][OC_ENABLE_HAND] != 4)
                            {
                                if(g_ownable_car[i][OC_ENABLE_HAND] == 1)
                                {
                                    JSON_SetInt(JSONObject, "t", 9);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[i][OC_ENABLE_HAND] == 3)
                                {
                                    JSON_SetInt(JSONObject, "t", 10);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[i][OC_ENABLE_HAND] == 2)
                                {
                                    JSON_SetInt(JSONObject, "t", 8);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                SetVehicleSportPlusFP(playerid, vehicleid);
                                g_ownable_car[i][OC_ENABLE_HAND] = 4;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                                mysql_query(mysql, query, false);

                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 1);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                            else 
                            {
                                SetVehicleStockFP(playerid, vehicleid);
                                g_ownable_car[i][OC_ENABLE_HAND] = 0;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                                mysql_query(mysql, query, false);

                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 0);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                        }
                        else ShowNotificationSile(playerid, 2, 5, -1, -1, "У Вас не установлена эта прошивка!", "");
                    }
                    else ShowNotificationSile(playerid, 2, 5, -1, -1, "У Вас не установлена эта прошивка!", "");
                }

                case 12: 
                {
                    printf("[DEBUG] Type 12: Toggling neon");
                    new index = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
                    if(index != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[index][OC_UNDERLIGHTS] != -1 || g_ownable_car[index][OC_UNDERLIGHTS_LT] != -1 || g_ownable_car[index][OC_UNDERLIGHTS_RT] != -1)
                        {
                            g_ownable_car[index][OC_ENABLE_NEON] = !g_ownable_car[index][OC_ENABLE_NEON];
                            
                            JSON_SetInt(JSONObject, "t", type);
                            JSON_SetInt(JSONObject, "s", g_ownable_car[index][OC_ENABLE_NEON] ? 1 : 0);
                            SendPacketToClient(playerid, 27, JSONObject);

                            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_neon = %d WHERE id = %d", g_ownable_car[index][OC_ENABLE_NEON] ? 1 : 0, database_id);
                                mysql_query(mysql, query, false);
                            
                            printf("[DEBUG] Type 12: Sending response - t=12, s=%d", g_ownable_car[index][OC_ENABLE_NEON]);
                            
                            if(g_ownable_car[index][OC_ENABLE_NEON])
                            {
                                SetVehicleNeonForPlayer(playerid, vehicleid,
                                        g_ownable_car[index][OC_UNDERLIGHTS],
                                        g_ownable_car[index][OC_UNDERLIGHTS_LT],
                                        g_ownable_car[index][OC_UNDERLIGHTS_RT]
                                    );
                            }
                            else
                            {
                                SetVehicleNeonForPlayer(playerid, vehicleid, 0, 0, 0);
                            }
                        }
                        else
                        {
                            printf("[DEBUG] Type 12: No neon installed");
                            ShowNotificationSile(playerid, 2, 5, -1, -1, "В авто не установлен неон.", "");
                            return 1;
                        }
                    }
                    else
                    {
                        printf("[DEBUG] Type 12: Vehicle not ownable");
                        ShowNotificationSile(playerid, 2, 5, -1, -1, "Ошибка", "");
                        return 1;
                    }
                }

                case 13: 
                {
                    printf("[DEBUG] Type 13: Toggling high light");
                    new index = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);

                    if(index != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[index][OC_HIGHLIGHT] != -1)
                        {
                            g_ownable_car[index][OC_ENABLE_HIGHLIGHT] = !g_ownable_car[index][OC_ENABLE_HIGHLIGHT];
                            
                            JSON_SetInt(JSONObject, "t", type);
                            JSON_SetInt(JSONObject, "s", g_ownable_car[index][OC_ENABLE_HIGHLIGHT] ? 1 : 0);
                            
                            printf("[DEBUG] Type 13: Sending response - t=13, s=%d", g_ownable_car[index][OC_ENABLE_HIGHLIGHT]);
                            SendPacketToClient(playerid, 27, JSONObject);
                            
                            if(g_ownable_car[index][OC_ENABLE_HIGHLIGHT])
                            {
                                SetVehicleHighLight(vehicleid, 1, 1);
                                
                                foreach(new playerid : Player)
                                {
                                    SetVehicleHighLightForPlayer(playerid, vehicleid, 1);
                                }
                                printf("[DEBUG] Type 13: High light ENABLED");
                            }
                            else
                            {
                                SetVehicleHighLight(vehicleid, 0, 1);
                                
                                foreach(new playerid : Player)
                                {
                                    SetVehicleHighLightForPlayer(playerid, vehicleid, 0);
                                }
                                printf("[DEBUG] Type 13: High light DISABLED");
                            }
                        }
                        else
                        {
                            printf("[DEBUG] Type 13: No high light installed");
                            ShowNotificationSile(playerid, 2, 5, -1, -1, "В авто не установлен дальний свет.", "");
                        }
                    }
                    else
                    {
                        printf("[DEBUG] Type 13: Vehicle not ownable");
                        ShowNotificationSile(playerid, 2, 5, -1, -1, "Ошибка", "");
                    }
                }
                case 14:
                {
                    printf("[DEBUG] Type 14: Executing lightss");
                    lightss(playerid);
                    JSON_SetInt(JSONObject, "t", type);
                    JSON_SetInt(JSONObject, "s", GetVehicleParam(vehicleid, V_LIGHTS) ? 1 : 0);
                    printf("[DEBUG] Type 14: Lights executed, lights status = %d", GetVehicleParam(vehicleid, V_LIGHTS));
                }

                case 15:
                {
                    printf("[DEBUG] Type 15: Toggling stroboscope");
                    new index = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
                    
                    if(index != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[index][OC_STROB] != -1)
                        {
                            g_ownable_car[index][OC_ENABLE_STROB] = !g_ownable_car[index][OC_ENABLE_STROB];
                            
                            JSON_SetInt(JSONObject, "t", type);
                            JSON_SetInt(JSONObject, "s", g_ownable_car[index][OC_ENABLE_STROB] ? 1 : 0);
                            SendPacketToClient(playerid, 27, JSONObject);
                            
                            printf("[DEBUG] Type 15: Sending response - t=15, s=%d", g_ownable_car[index][OC_ENABLE_STROB]);
                            
                            if(g_ownable_car[index][OC_ENABLE_STROB])
                            {
                                SetVehicleStroboscope(vehicleid, g_ownable_car[index][OC_STROB], 1);
                                
                                foreach(new playerid : Player)
                                {
                                    SetVehicleStroboscopeForPlayer(playerid, vehicleid, g_ownable_car[index][OC_STROB]);
                                }
                                printf("[DEBUG] Type 15: Stroboscope ENABLED");
                            }
                            else
                            {
                                SetVehicleStroboscope(vehicleid, 5, 1);
                                
                                foreach(new playerid : Player)
                                {
                                    SetVehicleStroboscopeForPlayer(playerid, vehicleid, 5);
                                }
                                printf("[DEBUG] Type 15: Stroboscope DISABLED");
                            }
                        }
                        else
                        {
                            printf("[DEBUG] Type 15: No stroboscope installed");
                            ShowNotificationSile(playerid, 2, 5, -1, -1, "В авто не установлен стробоскоп.", "");
                        }
                    }
                    else
                    {
                        printf("[DEBUG] Type 15: Vehicle not ownable");
                        ShowNotificationSile(playerid, 2, 5, -1, -1, "Ошибка", "");
                    }
                }

                case 16:
                {
                    new index = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
                    
                    if(index != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[index][OC_PNEVMO] != 0)
                        {
                            if(g_ownable_car[index][OC_ENABLE_PNEVMO] != 1)
                            {
                                if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 2)
                                {
                                    JSON_SetInt(JSONObject, "t", 17);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 3)
                                {
                                    JSON_SetInt(JSONObject, "t", 18);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                g_ownable_car[index][OC_ENABLE_PNEVMO] = 1;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_pnevmo = %d WHERE id = %d", 1, database_id);
                                mysql_query(mysql, query, false);

                                foreach(new playerid : Player)
                                {
                                    SetVehicleSuspensionForceForPlayer(playerid, vehicleid, 0.55);
                                }
                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 1);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                            else 
                            {
                                if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 2)
                                {
                                    JSON_SetInt(JSONObject, "t", 17);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 3)
                                {
                                    JSON_SetInt(JSONObject, "t", 18);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                g_ownable_car[index][OC_ENABLE_PNEVMO] = 0;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_pnevmo = %d WHERE id = %d", 0, database_id);
                                mysql_query(mysql, query, false);

                                foreach(new playerid : Player)
                                {
                                    if(g_ownable_car[index][OC_OBCLEARANCE] != -1 && g_ownable_car[index][OC_ENABLE_PNEVMO] == 0)
                                    {
                                        new suspension = max(g_ownable_car[index][OC_OBCLEARANCE] / 50.0, 0.2);
                                        SetVehicleSuspensionForceForPlayer(playerid, vehicleid, suspension);
                                    }
                                }
                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 0);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                        }
                        else ShowNotificationSile(playerid, 2, 6, -1, -1, "В авто не установлена пневмоподвеска.", "");
                    }
                    else ShowNotificationSile(playerid, 2, 6, -1, -1, "В авто не установлена пневмоподвеска.", "");
                }
                
                case 17:
                {
                    new index = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
                    
                    if(index != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[index][OC_PNEVMO] != 0)
                        {
                            if(g_ownable_car[index][OC_ENABLE_PNEVMO] != 2)
                            {
                                if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 1)
                                {
                                    JSON_SetInt(JSONObject, "t", 16);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 3)
                                {
                                    JSON_SetInt(JSONObject, "t", 18);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                g_ownable_car[index][OC_ENABLE_PNEVMO] = 2;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_pnevmo = %d WHERE id = %d", 2, database_id);
                                mysql_query(mysql, query, false);

                                foreach(new playerid : Player)
                                {
                                    SetVehicleSuspensionForceForPlayer(playerid, vehicleid, 0.35);
                                }
                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 1);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                            else 
                            {
                                if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 1)
                                {
                                    JSON_SetInt(JSONObject, "t", 16);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 3)
                                {
                                    JSON_SetInt(JSONObject, "t", 18);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                g_ownable_car[index][OC_ENABLE_PNEVMO] = 0;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_pnevmo = %d WHERE id = %d", 0, database_id);
                                mysql_query(mysql, query, false);

                                foreach(new playerid : Player)
                                {
                                    if(g_ownable_car[index][OC_OBCLEARANCE] != -1 && g_ownable_car[index][OC_ENABLE_PNEVMO] == 0)
                                    {
                                        new suspension = max(g_ownable_car[index][OC_OBCLEARANCE] / 50.0, 0.2);
                                        SetVehicleSuspensionForceForPlayer(playerid, vehicleid, suspension);
                                    }
                                }
                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 0);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                        }
                        else ShowNotificationSile(playerid, 2, 6, -1, -1, "В авто не установлена пневмоподвеска.", "");
                    }
                    else ShowNotificationSile(playerid, 2, 6, -1, -1, "В авто не установлена пневмоподвеска.", "");
                }

                case 18:
                {
                    new index = GetVehicleData(vehicleid, V_ACTION_ID), query[256], database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
                    
                    if(index != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[index][OC_PNEVMO] != 0)
                        {
                            if(g_ownable_car[index][OC_ENABLE_PNEVMO] != 3)
                            {
                                if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 2)
                                {
                                    JSON_SetInt(JSONObject, "t", 17);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 1)
                                {
                                    JSON_SetInt(JSONObject, "t", 16);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                g_ownable_car[index][OC_ENABLE_PNEVMO] = 3;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_pnevmo = %d WHERE id = %d", 3, database_id);
                                mysql_query(mysql, query, false);

                                foreach(new playerid : Player)
                                {
                                    SetVehicleSuspensionForceForPlayer(playerid, vehicleid, 0.2);
                                }
                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 1);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                            else 
                            {
                                if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 2)
                                {
                                    JSON_SetInt(JSONObject, "t", 17);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }
                                else if(g_ownable_car[index][OC_ENABLE_PNEVMO] == 1)
                                {
                                    JSON_SetInt(JSONObject, "t", 16);
                                    JSON_SetInt(JSONObject, "s", 0);
                                    SendPacketToClient(playerid, 27, JSONObject);
                                }

                                g_ownable_car[index][OC_ENABLE_PNEVMO] = 0;
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_pnevmo = %d WHERE id = %d", 0, database_id);
                                mysql_query(mysql, query, false);

                                foreach(new playerid : Player)
                                {
                                    if(g_ownable_car[index][OC_OBCLEARANCE] != -1 && g_ownable_car[index][OC_ENABLE_PNEVMO] == 0)
                                    {
                                        new suspension = max(g_ownable_car[index][OC_OBCLEARANCE] / 50.0, 0.2);
                                        SetVehicleSuspensionForceForPlayer(playerid, vehicleid, suspension);
                                    }
                                }
                                JSON_SetInt(JSONObject, "t", type);
                                JSON_SetInt(JSONObject, "s", 0);
                                SendPacketToClient(playerid, 27, JSONObject);
                            }
                        }
                        else ShowNotificationSile(playerid, 2, 6, -1, -1, "В авто не установлена пневмоподвеска.", "");
                    }
                    else ShowNotificationSile(playerid, 2, 6, -1, -1, "В авто не установлена пневмоподвеска.", "");
                }

                case 19:
                {
                    printf("[DEBUG] Type 19: Toggling hydraulic");
                    
                    new index = GetVehicleData(vehicleid, V_ACTION_ID);
                    
                    if(index != -1 && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
                    {
                        if(g_ownable_car[index][OC_GIDRA] != -1)
                        {
                            g_ownable_car[index][OC_ENABLE_GIDRA] = !g_ownable_car[index][OC_ENABLE_GIDRA];
                            
                            JSON_SetInt(JSONObject, "t", type);
                            JSON_SetInt(JSONObject, "s", g_ownable_car[index][OC_ENABLE_GIDRA] ? 1 : 0);
                            SendPacketToClient(playerid, 27, JSONObject);
                            
                            printf("[DEBUG] Type 19: Sending response - t=19, s=%d", g_ownable_car[index][OC_ENABLE_GIDRA]);
                            
                            if(g_ownable_car[index][OC_ENABLE_GIDRA])
                            {
                                SetVehicleHydraulics(vehicleid, 1, 0);
                                foreach(new playerid : Player)
                                {
                                    SetVehicleHydraulicsForPlayer(playerid, vehicleid, 1, 0);
                                }
                                printf("[DEBUG] Type 19: Hydraulic ENABLED");
                            }
                            else
                            {
                                SetVehicleHydraulics(vehicleid, 0, 0);
                                foreach(new playerid : Player)
                                {
                                    SetVehicleHydraulicsForPlayer(playerid, vehicleid, 0, 0);
                                }
                                printf("[DEBUG] Type 19: Hydraulic DISABLED");
                            }
                        }
                        else
                        {
                            ShowNotificationSile(playerid, 2, 5, -1, -1, "В авто не установлены гидравлика.", "");
                        }
                    }
                    else
                    {
                        printf("[DEBUG] Type 19: Vehicle not ownable");
                        ShowNotificationSile(playerid, 2, 5, -1, -1, "В авто не установлены гидравлика.", "");
                    }
                }

                
                default:
                {
                    printf("[DEBUG] Case 27: Unknown type %d received", type);
                }
            }

            SendPacketToClient(playerid, 27, JSONObject);
            printf("[DEBUG] Case 27: Packet sent to client %d", playerid);
        }
        case 14:
        {
            new t, i;

            JSON_GetInt(JSONObject, "t", t);
            JSON_GetInt(JSONObject, "i", i);

            switch(t)
            {
                case 0:  callcmd::gps(playerid, "");
                case 1:  ShowNotificationSile(playerid, 2, 5, 0, 0, "Данный раздел находится в разработке.", " ");
                case 2:  callcmd::mm(playerid, "");
                case 4:  callcmd::inv(playerid, "");
                case 5:  callcmd::anim(playerid, "");
                case 6:  callcmd::donate(playerid, "");
                case 7:  callcmd::car(playerid, "");
                case 8:  callcmd::promo(playerid, "");
                case 9:  callcmd::report(playerid, "");
                case 13: BPR_Open(playerid);
            }

            JSON_SetInt(JSONObject, "i", 1);
            SendPacketToClient(playerid, 14, JSONObject);
            JSON_Cleanup(JSONObject);
        }

        case 3:
        {
            new t;
            JSON_GetInt(JSONObject, "t", t);

            if(t == 1)
            {
                new order_mask;
                JSON_GetInt(JSONObject, "r", order_mask);
                ProcessLarekPurchase(playerid, order_mask, false);
            }
        }
        case 66:
        {
            PacketIncomingAtools(playerid, JSONObject);

        }
        case 38:
        {
            PacketIncomingAuthReg(playerid, JSONObject);
        }
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
                            return 1;
                        }
                        case ENTER_ENGINE:
                        {
                            callcmd::e(playerid, "");
                        }
                        case OFFER_TRADE_NO:
                        {
                            new senderid = GetPVarInt(playerid, "Trade_Target");
                            new msg[128];
                            format(msg, sizeof(msg), "Игрок %s отказался от трейда.", GetPlayerNameEx(playerid));
                            SendClientMessage(senderid, -1, msg);

                            DeletePVar(playerid, "Trade_Target");
                        }
                        case OFFER_TRADE:
                        {
                            new senderid = GetPVarInt(playerid, "Trade_Target");

                            if(!IsPlayerConnected(senderid))
                            {
                                SendClientMessage(playerid, -1, "Игрок, предложивший трейд, отключился.");
                                DeletePVar(playerid, "Trade_Target");
                                return 1;
                            }

                            if(IsPlayerInTrade(playerid))
                            {
                                ShowNotificationSile(playerid, 2, 5, 0, 0, "Вы уже находитесь в трейде.", " ");
                                DeletePVar(playerid, "Trade_Target");
                                return 1;
                            }

                            if(IsPlayerInTrade(senderid))
                            {
                                ShowNotificationSile(playerid, 2, 5, 0, 0, "Игрок уже в трейде.", " ");
                                DeletePVar(playerid, "Trade_Target");
                                return 1;
                            }

                            new tradeId = -1;
                            for(new i = 0; i < MAX_PLAYER_TRADES; i++)
                            {
                                if(!g_TradeData[i][trade_active])
                                {
                                    tradeId = i;
                                    break;
                                }
                            }

                            if(tradeId == -1)
                            {
                                SendClientMessage(playerid, -1, "Сервер перегружен. Попробуйте позже.");
                                DeletePVar(playerid, "Trade_Target");
                                return 1;
                            }

                            g_TradeData[tradeId][trade_player1] = senderid;
                            g_TradeData[tradeId][trade_player2] = playerid;
                            g_TradeData[tradeId][trade_status1] = 1;
                            g_TradeData[tradeId][trade_status2] = 1;
                            g_TradeData[tradeId][trade_money1] = 0;
                            g_TradeData[tradeId][trade_money2] = 0;
                            g_TradeData[tradeId][trade_time] = gettime();
                            g_TradeData[tradeId][trade_active] = true;
                            g_TradeData[tradeId][trade_both_ready] = false;

                            g_PlayerTradeID[senderid] = tradeId;
                            g_PlayerTradeID[playerid] = tradeId;

                            ResetPlayerTradeItems(senderid);
                            ResetPlayerTradeItems(playerid);
                            g_PlayerTradeMoney[senderid] = 0;
                            g_PlayerTradeMoney[playerid] = 0;

                            ShowPlayerTradeGUI(senderid, playerid);
                            ShowPlayerTradeGUI(playerid, senderid);

                            new msg[128];
                            format(msg, sizeof(msg), "Игрок %s согласился на трейд.", GetPlayerNameEx(playerid));
                            ShowNotificationSile(senderid, 1, 5, 0, 0, msg, " ");
                            ShowNotificationSile(playerid, 1, 5, 0, 0, "Вы согласились на трейд.", " ");

                            DeletePVar(playerid, "Trade_Target");
                        }
                        case ENTER_CONT:
                        {
                            callcmd::donate(playerid, "");
                        }
                        case OFFER_YES:
                        {
                            callcmd::yes(playerid, "");
                        }
                        case OFFER_TYPE_HANDSHAKE, OFFER_TYPE_CASINO_DICE:
                        {
                            callcmd::yes(playerid, "");
                        }
                        case OFFER_ENGINE:
                        {
                            callcmd::e(playerid, "");
                        }
                        case OFFER_UNLOCK_CAR:
                        {
                            callcmd::lock(playerid, "");
                        }
                        case EXIT_HOME:
                        {
                            ExitPlayerFromHouse(playerid, 3.0, 0);
                        }
                        case GUI_LOCK:
                        {
                            callcmd::exit(playerid, "");
                        }
                        case OFFER_TRUNK:
                        {
                        }
                        case DOOR_OPEN:
                        {
                            if(IsPlayerInDynamicArea(playerid, DoorData[7][Area]) || IsPlayerInDynamicArea(playerid, DoorData[8][Area]))
                            {
                                ToggleDoor(playerid, 7);
                                ToggleDoor(playerid, 8);
                                return 1;
                            }

                            for(new i = 0; i < sizeof DoorData; i++)
                            {
                                if(IsPlayerInDynamicArea(playerid, DoorData[i][Area]))
                                {
                                    ToggleDoor(playerid, i);
                                    return 1;
                                }
                            }
                        }
                    }
                    return 1;
                }
                case 1:
                {
                    switch(id)
                    {
                        case 1:
                        {
                            return 1;
                        }
                    }
                    return 1;
                }
            }
        }
        case 2:
        {
            HandlePacketFuekFill(playerid, JSONObject);
            JSON_Cleanup(playerid, JSONObject);
            return 1;
        }

        case 9:
        {
            BRMusic_HandleGuiPacket(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
            return 1;
        }

        case 39, 65:
        {
            return BlackPass_HandleExtraGui(playerid, guiid, JSONObject);
        }

        case 22:
        {
            new type, ty, la;
            JSON_GetInt(JSONObject, "t", type);
            JSON_GetInt(JSONObject, "ty", ty);
            JSON_GetInt(JSONObject, "la", la);
            new fmt[256];
            format(fmt, sizeof(fmt), "донатик type=%d", type);
            printf("%s", fmt);
            if(type == -2 || type == -1)
            {
                BlackPass_HandlePacket(playerid, JSONObject);
                return 1;
            }

            switch(type)
            {
                case 1:
                {
                    Cases_ShowGUI(playerid);
                    return 1;
                }
                case 4:
                {
                    new value;
                    JSON_GetInt(JSONObject, "v", value);
                    printf("[DEBUG] IPacket:252 - type 4, playerid: %d, exchange donate: %d", playerid, value);

                    if(value <= 0)
                    {
                        JSON_SetInt(JSONObject, "t", 4);
                        JSON_SetInt(JSONObject, "y", 0);
                        JSON_SetString(JSONObject, "m", "Ошибка: некорректное количество доната для обмена.");
                        JSON_SetString(JSONObject, "n", "Введите положительное число.");
                        SendPacketToClient(playerid, 22, JSONObject);
                        JSON_Cleanup(JSONObject);
                        return 1;
                    }

                    if(GetPlayerDonateRub(playerid) < value)
                    {
                        JSON_SetInt(JSONObject, "t", 4);
                        JSON_SetInt(JSONObject, "y", 0);
                        JSON_SetString(JSONObject, "m", "Недостаточно доната для обмена.");
                        JSON_SetString(JSONObject, "n", "Пополните баланс, чтобы произвести обмен.");
                        printf("[DEBUG] IPacket:252 - type 4, insufficient donate: playerid: %d, have: %d, need: %d",
                            playerid, GetPlayerDonateRub(playerid), value);
                        SendPacketToClient(playerid, 22, JSONObject);
                        JSON_Cleanup(JSONObject);
                        return 1;
                    }

                    new give_money = value * 1000;

                    GivePlayerDonateRub(playerid, -value);
                    GivePlayerMoneyEx(playerid, give_money);

                    printf("[DEBUG] IPacket:252 - type 4, exchanged %d donate -> %d money, playerid: %d, new DonateRub: %d, Money: %d",
                        value, give_money, playerid, GetPlayerDonateRub(playerid), GetPlayerMoneyEx(playerid));

                    JSON_SetInt(JSONObject, "t", 4);
                    JSON_SetInt(JSONObject, "y", 1);
                    JSON_SetInt(JSONObject, "v", value);
                    JSON_SetInt(JSONObject, "r", GetPlayerMoney(playerid));
                    JSON_SetInt(JSONObject, "s", GetPlayerDonateRub(playerid));
                    JSON_SetString(JSONObject, "m", "Обмен успешно выполнен!");
                    JSON_SetString(JSONObject, "n", "Вы обменяли донат на рубли.");

                    SendPacketToClient(playerid, 22, JSONObject);
                    JSON_Cleanup(JSONObject);
                }
                case 2:
                {
                    if(GetPlayerData(playerid, P_SALE_TIME) != 0) return;

                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}Внимание", "Данная функция не доступна!", "Закрыть", "");

                    SetPlayerData(playerid, P_SALE_TIME, 7200);
                    UpdatePlayerDatabaseInt(playerid, "sale_time", GetPlayerData(playerid, P_SALE_TIME));

                    JSON_SetInt(JSONObject, "t", 2);
                    JSON_SetInt(JSONObject, "p", GetPlayerData(playerid, P_SALE_TIME));

                    JSON_Stringify(JSONObject, outcoming_data);
                    SendPacketToClient(playerid, 22, JSONObject);

                    JSON_Cleanup(JSONObject);
                }
                case 13:
                {
                    new Node:response = JSON_Object();
                    JSON_SetInt(response, "t", type);

                    SendPacketToClient(playerid, 22, response);
                    JSON_Cleanup(response);
                }
                case 0:
                {
                    new price, internal_id;
                    new vip_level, vip_days, vip_name[32];

                    JSON_GetInt(JSONObject, "p", internal_id);
                    JSON_GetInt(JSONObject, "m", price);

                    if (GetPlayerDonateRub(playerid) < price || GetPlayerDonateRub(playerid) < GetPlayerDonateRub(playerid) - price)
                    {
                        JSON_SetInt(JSONObject, "t", 0);
                        JSON_SetInt(JSONObject, "y", 0);
                        JSON_SetInt(JSONObject, "k", 1);

                        JSON_SetString(JSONObject, "m", "Недостаточно средств.");
                        JSON_SetString(JSONObject, "n", "Пополните счет чтобы купить!");

                        JSON_Stringify(JSONObject, outcoming_data);
                        SendPacketToClient(playerid, 22, JSONObject);

                        JSON_Cleanup(JSONObject);

                        return;
                    }

                    if(GetDonateVipByInternalId(internal_id, vip_level, vip_days, vip_name, sizeof(vip_name)))
                    {
                        GivePlayerDonateRub(playerid, -price, "Покупка VIP статуса", true, true);
                        GivePlayerDonateVip(playerid, vip_level, vip_days);
                        ShowSuccesfullBuyVip(playerid, internal_id, vip_name, vip_days);
                        return;
                    }

                    switch(internal_id)
                    {
                        case 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65, 66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 195, 201, 202, 211, 212, 213, 214, 215, 216, 217, 218, 219, 220, 221, 222, 223, 224, 275, 276, 327, 328, 329, 330, 331, 347, 348, 349, 350, 351, 352, 353, 366, 367, 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 413, 414, 415, 416, 417, 418, 424, 426, 427, 428, 429, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 459, 460, 461, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 484, 485, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 522, 523, 524, 543, 544, 545, 546, 547, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560:
                        {
                            if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
                            {
                                JSON_SetInt(JSONObject, "t", 0);
                                JSON_SetInt(JSONObject, "y", 0);
                                JSON_SetInt(JSONObject, "k", -1);

                                JSON_SetString(JSONObject, "m", "У вас нет свободных слотов\nПриобретите слот.");
                                JSON_SetString(JSONObject, "n", "Вы можете приобрести их в разделе {FFFF00}Магазин.");

                                JSON_Stringify(JSONObject, outcoming_data);
                                SendPacketToClient(playerid, 22, JSONObject);

                                JSON_Cleanup(JSONObject);

                                return;
                            }

                            GivePlayerDonateRub(playerid, -price);

                            new Node:response = JSON_Object(), color;

                            JSON_SetInt(JSONObject, "t", 0);
                            JSON_SetInt(JSONObject, "y", 1);

                            JSON_SetInt(JSONObject, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(JSONObject, "s", GetPlayerDonateRub(playerid));

                            JSON_SetString(JSONObject, "m", "Вы успешно приобрели транспорт!");
                            JSON_SetString(JSONObject, "n", "Теперь вы можете найти его, используя /car");


                            JSON_SetInt(JSONObject, "g", internal_id);
                            JSON_GetInt(JSONObject, "l", color);
                            BuyPlayerCar(playerid, internal_id, FindGameId(internal_id, car_game_ids, sizeof(car_game_ids)), color);

                            JSON_Stringify(JSONObject, outcoming_data);
                            SendPacketToClient(playerid, 22, JSONObject);
                            JSON_Cleanup(JSONObject);
                        }
                        case 91, 92, 93, 94, 95, 96, 97, 98, 99, 100, 101, 203, 205, 206, 207, 208, 209, 210, 225, 226, 227, 228, 229, 230, 231, 232, 233, 234, 235, 236, 237, 238, 239, 240, 257, 311, 312, 313, 314, 315, 316, 317, 318, 319, 320, 321, 322, 323, 324, 325, 326, 332, 333, 334, 335, 336, 337, 338, 339, 340, 341, 342, 343, 344, 345, 346, 390, 391, 392, 393, 394, 395, 396, 397, 398, 399, 419, 420, 421, 425, 430, 431, 457, 458, 462, 463, 475, 480, 481, 482, 483, 486, 487, 488, 489, 490, 491, 492, 497, 513, 514, 515, 516, 517, 519, 525, 526, 527, 528, 529, 535, 536, 561, 562, 563, 564:
                        {
                            new Node:response = JSON_Object();

                            GivePlayerDonateRub(playerid, -price);

                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            JSON_SetInt(response, "g", internal_id);

                            JSON_SetInt(response, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(response, "s", GetPlayerDonateRub(playerid) - price);

                            JSON_SetString(response, "m", "Вы успешно приобрели одежду");
                            JSON_SetString(response, "n", "Теперь вы можете надеть его, используя /inv");

                            SendPacketToClient(playerid, 22, response);

                            JSON_Cleanup(response);

                            BuyPlayerSkin(playerid, internal_id, FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids)));


                        }
                        case 549, 534, 533, 530, 531, 532, 518, 493, 494, 495, 496, 476, 477, 478, 479, 542, 464, 432, 433, 434, 436, 437, 438, 439, 440, 441, 442, 443, 435, 422, 423, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 277, 278, 279, 280, 295, 296, 297, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 243, 244, 245, 246, 241, 242, 274, 247, 248, 249, 250, 251, 252, 254, 255, 256, 253, 258, 259, 260, 261, 263, 264, 265, 266, 267:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            JSON_SetInt(response, "g", internal_id);

                            JSON_SetInt(response, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(response, "s", GetPlayerDonateRub(playerid) - price);

                            JSON_SetString(response, "m", "Вы успешно приобрели аксессуар");
                            JSON_SetString(response, "n", "Используй /inv чтобы надеть");

                            SendPacketToClient(playerid, 22, response);

                            JSON_Cleanup(response);

                            BuyPlayerAcs(playerid, internal_id, FindGameId(internal_id, accessories_game_ids, sizeof(accessories_game_ids)));

                            GivePlayerDonateRub(playerid, -price);
                        }
                        case 102:
                        {

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                Dialog
                                (
                                    playerid, DIALOG_DONATE_CHANGE_NAME, DIALOG_STYLE_INPUT,
                                    "{FFCD00}Изменение имени",
                                    "{FFFFFF}Введите новое имя в поле ниже:",
                                    "Изменить", "Закрыть"
                                );
                            }
                            else {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Недостаточно средств");
                                JSON_Stringify(response, outcoming_data);
                                SendPacketToClient(playerid, 22, response);
                            }

                        }
                        case 103:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100) {
                                JSON_SetInt(response, "s", GetPlayerDonateRub(playerid) - 100);
                                JSON_SetInt(response, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(response, "m", "Покупка совершена");
                                JSON_SetString(response, "n", "Вы приобрели: Снятие предупреждений");
                                GivePlayerDonateRub(playerid, -100, "Снятие варнов", true);

                                SendPacketToClient(playerid, 22, response);

                                SetPlayerData(playerid, P_WARN, 0);
                                SetPlayerData(playerid, P_WARN_TIME, 0);
                                UpdatePlayerDatabaseInt(playerid, "warn", 0);
                                UpdatePlayerDatabaseInt(playerid, "warn_time", 0);
                            }
                            else {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Недостаточно средств");
                                JSON_Stringify(response, outcoming_data);
                                SendPacketToClient(playerid, 22, response);
                            }
                        }
                        case 104:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 150) {
                                JSON_SetInt(response, "s", GetPlayerDonateRub(playerid) - 150);
                                JSON_SetInt(response, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(response, "m", "Покупка совершена");
                                JSON_SetString(response, "n", "Вы приобрели пакет всех лицензий");
                                GivePlayerDonateRub(playerid, -150, "Все лицензии", true);

                                SendPacketToClient(playerid, 22, response);

                                SetPlayerData(playerid, P_DRIVING_LIC, GetPlayerData(playerid, P_DRIVING_LIC) ^ 1);
                                UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));
                                SetPlayerData(playerid, P_WEAPON_LIC, GetPlayerData(playerid, P_WEAPON_LIC) ^ 1);
                                UpdatePlayerDatabaseInt(playerid, "weapon_lic", GetPlayerData(playerid, P_WEAPON_LIC));
                            }
                            else {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Недостаточно средств");
                                SendPacketToClient(playerid, 22, response);
                            }
                        }
                        case 106:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 0);
                            JSON_SetInt(response, "k", 1);
                            JSON_SetString(response, "m", "Покупка временно не доступна.");
                            JSON_SetString(response, "n", "Услуга временно не доступна.");
                            SendPacketToClient(playerid, 22, response);
                        }
                        case 107:
                        {
                            if(GetPlayerRangFamily(playerid) != 5 || GetPlayerIdFamily(playerid) == -1)
                            {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Вы не лидер семьи или у вас нет семьи.");
                                SendPacketToClient(playerid, 22, response);
                                return;
                            }
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100) {
                                Dialog
                                (
                                    playerid, DIALOG_SMENA_NAZVANIA_FAM, DIALOG_STYLE_INPUT,
                                    "{FF0000}Изменение название семьи",
                                    "Напишите название вашей семьи ниже.",
                                    "Далее", "Выйти"
                                );
                            }
                            else {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response , "k", 1);
                                JSON_SetString(response, "n", "Недостаточно средств");
                                SendPacketToClient(playerid, 22, response);
                            }
                        }
                        case 108:
                        {
                            if(GetPlayerRangFamily(playerid) != 5 || GetPlayerIdFamily(playerid) == -1)
                            {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Вы не лидер семьи или у вас нет семьи.");
                                SendPacketToClient(playerid, 22, response);
                                return;
                            }
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100) {
                                Dialog
                                (
                                    playerid, DIALOG_PEREDACHA_FAM, DIALOG_STYLE_INPUT,
                                    "{FF0000}Изменить владельца семьи",
                                    "Введите ID-игрока которому Вы хотите передать полномочие своей семьи:",
                                    "Далее", "Выйти"
                                );
                            }
                            else {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response , "k", 1);
                                JSON_SetString(response, "n", "Недостаточно средств");
                                SendPacketToClient(playerid, 22, response);
                            }
                        }
                        case 109:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 130) {
                                JSON_SetInt(response, "s", GetPlayerDonateRub(playerid) - 130);
                                JSON_SetInt(response, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(response, "m", "Спасибо за покупку!");
                                JSON_SetString(response, "n", "Вы успешно приобрели военный билет.");
                                GivePlayerDonateRub(playerid, -130, "Военный билет донат", true);
                                SendPacketToClient(playerid, 22, response);

                            }
                            else {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Недостаточно средств");
                                SendPacketToClient(playerid, 22, response);
                            }
                        }
                        case 111:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 0);
                            JSON_SetInt(response, "k", 1);

                            JSON_SetString(response, "n", "Услуга временно не доступна.");
                            SendPacketToClient(playerid, 22, response);
                        }
                        case 113:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 0);
                            JSON_SetInt(response, "k", 1);

                            JSON_SetString(response, "n", "Услуга временно не доступна.");
                            SendPacketToClient(playerid, 22, response);
                        }
                        case 114:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 0);
                            JSON_SetInt(response, "k", 1);

                            JSON_SetString(response, "n", "Услуга временно не доступна.");
                            SendPacketToClient(playerid, 22, response);
                        }
                        case 115:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 0);
                            JSON_SetInt(response, "k", 1);

                            JSON_SetString(response, "n", "Услуга временно не доступна.");
                            SendPacketToClient(playerid, 22, response);
                        }
                        case 116:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 0);
                            JSON_SetInt(response, "k", 1);

                            JSON_SetString(response, "n", "Услуга временно не доступна.");
                            SendPacketToClient(playerid, 22, response);
                        }


                        case 117:
                        {
                            new Node:response = JSON_Object();
                            if(GetPlayerData(playerid, P_MEDKA) == 0)
                            {
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(response, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(response, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(response, "m", "Спасибо за покупку!");
                                    JSON_SetString(response, "n", "Вы приобрели мед.карту");
                                    SetPlayerData(playerid, P_MEDKA, 1);
                                    UpdatePlayerDatabaseInt(playerid, "med", 1);

                                    GivePlayerDonateRub(playerid, -100, "медка", true);

                                    SendPacketToClient(playerid, 22, response);
                                }
                                else {
                                    JSON_SetInt(response, "t", 0);
                                    JSON_SetInt(response, "y", 0);
                                    JSON_SetInt(response, "k", 1);

                                    JSON_SetString(response, "n", "Недостаточно средств");
                                    SendPacketToClient(playerid, 22, response);
                                }
                            }
                            else
                            {
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);

                                JSON_SetString(response, "n", "У вас уже есть мед.карта.");
                                SendPacketToClient(playerid, 22, response);
                            }

                        }
                        case 118:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            JSON_SetString(response, "n", "Услуга временно не доступна.");
                            SendPacketToClient(playerid, 22, response);
                        }
                        case 119:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 0);
                            JSON_SetInt(response, "k", 1);

                            JSON_SetString(response, "n", "Услуга временно не доступна.");
                            SendPacketToClient(playerid, 22, response);
                        }
                        case 120:
                        {
                            if(GetPlayerIdFamily(playerid) == -1)
                            {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Вы не состоите в семье.");
                                SendPacketToClient(playerid, 22, response);
                                return;
                            }
                            new Node:response = JSON_Object();
                            new f = GetPlayerIdFamily(playerid);
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300) {
                                GivePlayerDonateRub(playerid, -300, "доп. слот на авто в семью", true);

                                AddFamily(f, family_slot_veh, +, 1);
                                UpdateColumnFamilyInt(GetFamily(f, family_database), "slot_veh", GetFamily(f, family_slot_veh));
                                new fmtslot[512], fmtslot2[512];
                                format(fmtslot, sizeof(fmtslot), "Теперь в семье слотов: %d", GetFamily(f, family_slot_veh));

                                format(fmtslot2, sizeof fmtslot2, "%s[%d] купил слот для транспорта в семью. Всего: %d",
                                       GetPlayerNameEx(playerid), playerid, GetFamily(f, family_slot_veh));
                                SendFamilyMessage(f, fmtslot2);

                                JSON_SetInt(response, "s", GetPlayerDonateRub(playerid) - 100);
                                JSON_SetInt(response, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(response, "m", "Вы успешно приобрели доп. слот на авто в семью");
                                JSON_SetString(response, "n", fmtslot);
                                SendPacketToClient(playerid, 22, response);
                            }
                            else {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Недостаточно средств");
                                JSON_Stringify(response, outcoming_data);
                                SendPacketToClient(playerid, 22, response);
                            }
                        }
                        case 121:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                GivePlayerDonateRub(playerid, -100, "Смена пола", true);
                                JSON_SetInt(response, "s", GetPlayerDonateRub(playerid));
                                JSON_SetInt(response, "r", GetPlayerMoneyEx(playerid));

                                SetPlayerData(playerid, P_SEX, GetPlayerData(playerid, P_SEX) ^ 1);
                                UpdatePlayerDatabaseInt(playerid, "sex", GetPlayerData(playerid, P_SEX));
                                new fmtsex[512];
                                if(GetPlayerData(playerid, P_SEX) == 0)
                                {
                                    fmtsex = "Мужской";
                                }
                                else
                                {
                                    fmtsex = "Женский";
                                }
                                new fmt[512];
                                format(fmt, sizeof(fmt), "Ваш текущий пол: %s", fmtsex);

                                JSON_SetString(response, "m", "Вы успешно сменили пол!");
                                JSON_SetString(response, "n", fmt);

                                SendPacketToClient(playerid, 22, response);
                            }
                            else {
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);

                                JSON_SetString(response, "n", "Недостаточно средств");

                                SendPacketToClient(playerid, 22, response );
                            }
                        }
                        case 122:
                        {
                            new Node:response = JSON_Object();
                            JSON_SetInt(response, "t", 0);
                            JSON_SetInt(response, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100) {
                                GivePlayerDonateRub(playerid, -100, "доп. слот авто", true);

                                AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                                UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                                new fmtslot[512];
                                format(fmtslot, sizeof(fmtslot), "Теперь у Вас %d слотов", GetPlayerData(playerid, P_CAR_SLOTS));
                                JSON_SetInt(response, "s", GetPlayerDonateRub(playerid) - 100);
                                JSON_SetInt(response, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(response, "m", "Вы успешно приобрели доп. слот на авто");
                                JSON_SetString(response, "n", fmtslot);
                                SendPacketToClient(playerid, 22, response);
                            }
                            else {
                                new Node:response = JSON_Object();
                                JSON_SetInt(response, "t", 0);
                                JSON_SetInt(response, "y", 0);
                                JSON_SetInt(response, "k", 1);
                                JSON_SetString(response, "n", "Недостаточно средств");
                                JSON_Stringify(response, outcoming_data);
                                SendPacketToClient(playerid, 22, response);
                            }
                        }
                        case 123:
                        {
                            if(GetPlayerDonateRub(playerid) >= 85)
                            {
                                ShowPlayerPlatesGUI(playerid, 1);
                            }
                            else {
                                JSON_SetInt(JSONObject, "t", 0);
                                JSON_SetInt(JSONObject, "y", 0);
                                JSON_SetInt(JSONObject, "k", 1);

                                JSON_SetString(JSONObject, "m", "Недостаточно средств.");
                                JSON_SetString(JSONObject, "n", "Пополните счет чтобы купить!");

                                JSON_Stringify(JSONObject, outcoming_data);
                                SendPacketToClient(playerid, 22, JSONObject);
                            }
                        }
                        case 124:
                        {
                            if(GetPlayerDonateRub(playerid) >= 70)
                            {
                                ShowDonateBuySimCard(playerid);
                            }
                            else {
                                JSON_SetInt(JSONObject, "t", 0);
                                JSON_SetInt(JSONObject, "y", 0);
                                JSON_SetInt(JSONObject, "k", 1);

                                JSON_SetString(JSONObject, "n", "Недостаточно средств");

                                JSON_Stringify(JSONObject, outcoming_data);
                                SendPacketToClient(playerid, 22, JSONObject);
                            }
                        }
                        case 179: // Сельчанин
                    {
                        BuyPlayerCar(playerid, 12, 585, 0);           // Автомобиль
                        BuyPlayerSkin(playerid, 180, 30);             // Одежда
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 1);   // Слот
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        ShowSuccesfullBuyPack(playerid, "Сельчанин", price, internal_id);
                    }
                    case 181: // Бандит
                    {
                        BuyPlayerCar(playerid, 22, 419, 0);
                        BuyPlayerSkin(playerid, 182, 60);
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        ShowSuccesfullBuyPack(playerid, "Бандит", price, internal_id);
                    }
                    case 183: // Молодой
                    {
                        BuyPlayerCar(playerid, 23, 562, 0);
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 1);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 86400);
                        ShowSuccesfullBuyPack(playerid, "Молодой", price, internal_id);
                    }
                    case 185: // Гангстер
                    {
                        BuyPlayerCar(playerid, 28, 527, 0);
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 1);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Гангстер", price, internal_id);
                    }
                    case 187: // Гонщик
                    {
                        BuyPlayerCar(playerid, 78, 461, 0);           // Мотоцикл Ducati SuperSport S
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 1);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Гонщик", price, internal_id);
                    }
                    case 189: // Депутат
                    {
                        BuyPlayerCar(playerid, 34, 550, 0);           // Toyota Camry 2019
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Депутат", price, internal_id);
                    }
                    case 191: // Мафиози
                    {
                        BuyPlayerCar(playerid, 52, 2547, 0);          // Toyota Land Cruiser 200
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Мафиози", price, internal_id);
                    }
                    case 193: // Мажор
                    {
                        BuyPlayerCar(playerid, 64, 2546, 0);          // Mercedes-Benz E63s
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 3);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 5));
                        ShowSuccesfullBuyPack(playerid, "Мажор", price, internal_id);
                    }
                    case 262: // Кости
                    {
                        BuyPlayerSkin(playerid, 237, 266);            // Скелетон
                        BuyPlayerSkin(playerid, 241, 136);            // Шляпа ведьмы (светящаяся)
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Кости", price, internal_id);
                    }
                    case 268: // Красавчик
                    {
                        BuyPlayerSkin(playerid, 228, 269);            // Красавчик
                        BuyPlayerSkin(playerid, 258, 149);            // Маска Дали
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Красавчик", price, internal_id);
                    }
                    case 269: // Красотка
                    {
                        BuyPlayerSkin(playerid, 227, 232);            // Красавица
                        BuyPlayerSkin(playerid, 241, 136);            // Шляпа ведьмы
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Красотка", price, internal_id);
                    }
                    case 270: // Ведьма
                    {
                        BuyPlayerSkin(playerid, 229, 231);            // Ведьма милашка Ди
                        BuyPlayerSkin(playerid, 267, 150);            // Метла
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Ведьма", price, internal_id);
                    }
                    case 271: // Улыбка зла
                    {
                        BuyPlayerSkin(playerid, 229, 231);            // Ведьма милашка Ди
                        BuyPlayerSkin(playerid, 248, 145);            // Неоновая маска красная
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Улыбка зла", price, internal_id);
                    }
                    case 272: // Страшила
                    {
                        BuyPlayerSkin(playerid, 231, 208);            // Страшный
                        BuyPlayerSkin(playerid, 248, 145);            // Неоновая маска красная
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Страшила", price, internal_id);
                    }
                    case 273: // Смерть с косой
                    {
                        BuyPlayerSkin(playerid, 230, 175);            // Крик
                        BuyPlayerSkin(playerid, 255, 144);            // Красная коса
                        GivePlayerDonateRub(playerid, -price, "Покупка набора", true, true);
                        SetPlayerData(playerid, P_PREMIUM, 2);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                        ShowSuccesfullBuyPack(playerid, "Смерть с косой", price, internal_id);
                    }
                    }
                }
            }
        }
        case 34:
        {
            if(GetPVarInt(playerid, "typeinv") == 1)
            {
                PacketIncomingTrunkOrCloset(playerid, JSONObject);
            }
            else if(GetPVarInt(playerid, "typeinv") == 2)
            {
            }
            JSON_Cleanup(JSONObject);
        }
        case 33:
        {
            new Node:response = JSON_Object();
            new type;

            JSON_GetInt(JSONObject, "t", type);

            new item_id, pos, old_pos, count, money;
            new nt[64] = "";
            new fmttest[128];
            format(fmttest, sizeof(fmttest), "case 33, type: %d", type);

            switch(type)
            {
                case 0:
                {
                    JSON_GetInt(JSONObject, "ga", item_id);
                    JSON_GetInt(JSONObject, "s", count);
                    JSON_GetInt(JSONObject, "s", pos);
                    JSON_GetString(JSONObject, "nt", nt, sizeof(nt));

                    Inventory_AddItem(playerid, item_id, pos, count, nt);

                    JSON_SetInt(response, "t", 0);
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "w", GetPlayerWeight(playerid));
                }
                case 1:
                {
                    JSON_GetInt(JSONObject, "ga", item_id);
                    JSON_GetInt(JSONObject, "s", count);
                    JSON_GetInt(JSONObject, "s", pos);

                    Inventory_RemoveItem(playerid, pos, count);

                    JSON_SetInt(response, "t", 1);
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "w", GetPlayerWeight(playerid));
                }
                case 4:
                {
                    JSON_GetInt(JSONObject, "ga", item_id);
                    JSON_GetInt(JSONObject, "os", old_pos);
                    JSON_GetInt(JSONObject, "s", pos);

                    printf("[INV] Перемещение: item_id=%d, из активного слота %d в слот инвентаря %d",
                        item_id, old_pos, pos);

                    if(item_id == 134 && old_pos == 6)
                    {
                        JSON_SetInt(response, "t", 4);
                        JSON_SetInt(response, "s", 0);
                        ShowNotificationSile(playerid, 2, 6, -1, -1, "Нельзя снять одежду.", "");
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }


                    new model_id = Accessory_GetModelIdByItemId(item_id);
                    if(model_id != -1)
                    {
                        if(Inventory_UnequipAccessory(playerid, old_pos, pos))
                        {
                            JSON_SetInt(response, "t", 4);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "w", GetPlayerWeight(playerid));

                            new itemName[64];
                            GetItemName(item_id, itemName);
                            ShowNotificationSile(playerid, 2, 5, -1, -1, "Аксессуар снят", itemName);
                        }
                        else
                        {
                            JSON_SetInt(response, "t", 4);
                            JSON_SetInt(response, "s", 0);
                            JSON_SetString(response, "m", "Не удалось снять аксессуар");
                        }
                    }
                    else
                    {
                        if(Inventory_MoveFromSlotToInv(playerid, item_id, old_pos, pos))
                        {
                            JSON_SetInt(response, "t", 4);
                            JSON_SetInt(response, "s", 1);
                        }
                        else
                        {
                            JSON_SetInt(response, "t", 4);
                            JSON_SetInt(response, "s", 0);
                        }
                    }

                    printf("[INV] Результат перемещения: itemId(%d), oldpos(%d), pos(%d)",
                        item_id, old_pos, pos);

                    SendPacketToClient(playerid, 33, response);
                    JSON_Cleanup(response);
                }
                case 5:
{
    JSON_GetInt(JSONObject, "ga", item_id);
    JSON_GetInt(JSONObject, "s", count);
    JSON_GetInt(JSONObject, "os", pos);
    
    new tradeId = g_PlayerTradeID[playerid];
    if(tradeId == -1)
    {
        JSON_SetInt(response, "t", 5);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    if(g_TradeData[tradeId][trade_both_ready])
    {
        JSON_SetInt(response, "t", 5);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    if(pos < 0 || pos >= MAX_INVENTORY_SLOTS || g_PlayerInventory[playerid][pos][inv_itemId] == 0)
    {
        JSON_SetInt(response, "t", 5);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    new itemId = g_PlayerInventory[playerid][pos][inv_itemId];
    new maxCount = g_PlayerInventory[playerid][pos][inv_itemCount];
    if(count <= 0 || count > maxCount) count = maxCount;
    
    if(itemId == 58 && g_PlayerActiveSlots[playerid][0][inv_itemId] == 58)
    {
        JSON_SetInt(response, "t", 5);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    if(itemId == 134)
    {
        new skinModel = g_PlayerInventory[playerid][pos][inv_itemCount];
        if(skinModel == GetPlayerSkin(playerid))
        {
            JSON_SetInt(response, "t", 5);
            JSON_SetInt(response, "s", 0);
            SendPacketToClient(playerid, 33, response);
            JSON_Cleanup(response);
            return;
        }
    }
    
    new tradeSlot = -1;
    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
    {
        if(g_PlayerTradeItems[playerid][i][tr_itemId] == 0)
        {
            tradeSlot = i;
            break;
        }
    }
    
    if(tradeSlot == -1)
    {
        JSON_SetInt(response, "t", 5);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    // Копируем в трейд
    g_PlayerTradeItems[playerid][tradeSlot][tr_itemId] = itemId;
    g_PlayerTradeItems[playerid][tradeSlot][tr_itemCount] = count;
    g_PlayerTradeItems[playerid][tradeSlot][tr_itemSlot] = tradeSlot;
    strcpy(g_PlayerTradeItems[playerid][tradeSlot][tr_itemPlate],
           g_PlayerInventory[playerid][pos][inv_itemPlate], 32);
    g_PlayerTradeItems[playerid][tradeSlot][tr_fromSlot] = pos;
    
    // Удаляем из инвентаря
    Inventory_RemoveItem(playerid, pos, count);
    
    JSON_SetInt(response, "t", 1);

    new to_player = GetTradePartner(playerid);
    TradeSendPartnerItem(to_player, 0, itemId, count, g_PlayerInventory[playerid][pos][inv_itemPlate]);
    TradeSendStatus(playerid, 2);
    TradeSendStatus(to_player, 2);

    JSON_SetInt(response, "t", 5);
    JSON_SetInt(response, "s", 1);
    JSON_SetInt(response, "sl", tradeSlot);
    JSON_SetInt(response, "w", GetPlayerWeight(playerid));
    SendPacketToClient(playerid, 33, response);
    JSON_Cleanup(response);
}
                case 6:
{
    JSON_GetInt(JSONObject, "em", money);
    
    new tradeId = g_PlayerTradeID[playerid];
    if(tradeId == -1)
    {
        JSON_SetInt(response, "t", 6);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    if(g_TradeData[tradeId][trade_both_ready])
    {
        JSON_SetInt(response, "t", 6);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    if(money < 0 || money > 20000000)
    {
        JSON_SetInt(response, "t", 6);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    if(money > GetPlayerMoney(playerid))
    {
        JSON_SetInt(response, "t", 6);
        JSON_SetInt(response, "s", 0);
        SendPacketToClient(playerid, 33, response);
        JSON_Cleanup(response);
        return;
    }
    
    g_PlayerTradeMoney[playerid] = money;
    
    new to_player = GetTradePartner(playerid);

    new Node:updateMy = JSON_Object();
    JSON_SetInt(updateMy, "t", 6);
    JSON_SetInt(updateMy, "s", 1);
    JSON_SetInt(updateMy, "em", money);
    SendPacketToClient(playerid, 33, updateMy);
    JSON_Cleanup(updateMy);

    if(to_player != -1 && IsPlayerConnected(to_player))
    {
        new Node:updateOther = JSON_Object();
        JSON_SetInt(updateOther, "t", 3); 
        JSON_SetInt(updateOther, "s", 1);
        JSON_SetInt(updateOther, "gm", money); 
        SendPacketToClient(to_player, 33, updateOther);
        JSON_Cleanup(updateOther);
        
        new Node:updateOtherMoney = JSON_Object();
        JSON_SetInt(updateOtherMoney, "t", 6);
        JSON_SetInt(updateOtherMoney, "s", 1);
        JSON_SetInt(updateOtherMoney, "em", money);
        SendPacketToClient(to_player, 33, updateOtherMoney);
        JSON_Cleanup(updateOtherMoney);
    }
    
    JSON_SetInt(response, "t", 6);
    JSON_SetInt(response, "s", 1);
    JSON_SetInt(response, "em", money);
    SendPacketToClient(playerid, 33, response);
    JSON_Cleanup(response);
}
                case 7:
                {
                    new tradeId = g_PlayerTradeID[playerid];
                    if(tradeId == -1)
                    {
                        JSON_SetInt(response, "t", 7);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    new player1 = g_TradeData[tradeId][trade_player1];
                    new player2 = g_TradeData[tradeId][trade_player2];

                    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
                    {
                        if(g_PlayerTradeItems[player1][i][tr_itemId] > 0)
                        {
                            new fromSlot = g_PlayerTradeItems[player1][i][tr_fromSlot];
                            new itemId = g_PlayerTradeItems[player1][i][tr_itemId];
                            new cnt = g_PlayerTradeItems[player1][i][tr_itemCount];
                            new plate[32];
                            strcpy(plate, g_PlayerTradeItems[player1][i][tr_itemPlate], 32);
                            Inventory_AddItem(player1, itemId, fromSlot, cnt, plate);
                        }

                        if(g_PlayerTradeItems[player2][i][tr_itemId] > 0)
                        {
                            new fromSlot = g_PlayerTradeItems[player2][i][tr_fromSlot];
                            new itemId = g_PlayerTradeItems[player2][i][tr_itemId];
                            new cnt = g_PlayerTradeItems[player2][i][tr_itemCount];
                            new plate[32];
                            strcpy(plate, g_PlayerTradeItems[player2][i][tr_itemPlate], 32);
                            Inventory_AddItem(player2, itemId, fromSlot, cnt, plate);
                        }
                    }

                    new msg[128];
                    format(msg, sizeof(msg), "Игрок %s отменил обмен.", GetPlayerNameEx(playerid));

                    if(player1 == playerid)
                    {
                        if(IsPlayerConnected(player2))
                        {
                            ShowNotificationSile(player2, 2, 5, -1, -1, msg, "");
                            HidePlayerGUI(player2, 33);
                        }
                    }
                    else
                    {
                        if(IsPlayerConnected(player1))
                        {
                            ShowNotificationSile(player1, 2, 5, -1, -1, msg, "");
                            HidePlayerGUI(player1, 33);
                        }
                    }

                    ShowNotificationSile(playerid, 2, 5, -1, -1, "Вы отменили обмен.", "");
                    HidePlayerGUI(playerid, 33);

                    g_TradeData[tradeId][trade_active] = false;
                    g_PlayerTradeID[player1] = -1;
                    g_PlayerTradeID[player2] = -1;
                    ResetPlayerTradeItems(player1);
                    ResetPlayerTradeItems(player2);

                    JSON_SetInt(response, "t", 7);
                    JSON_SetInt(response, "s", 1);
                    SendPacketToClient(playerid, 33, response);
                    JSON_Cleanup(response);
                }
                case 8:
                {
                    new tradeId = g_PlayerTradeID[playerid];
                    if(tradeId == -1)
                    {
                        JSON_SetInt(response, "t", 8);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(g_TradeData[tradeId][trade_player1] == playerid)
                        g_TradeData[tradeId][trade_status1] = 2;
                    else
                        g_TradeData[tradeId][trade_status2] = 2;

                    new status1 = g_TradeData[tradeId][trade_status1];
                    new status2 = g_TradeData[tradeId][trade_status2];
                    new player1 = g_TradeData[tradeId][trade_player1];
                    new player2 = g_TradeData[tradeId][trade_player2];

                    if(status1 == 2 && status2 == 2)
                    {
                        g_TradeData[tradeId][trade_both_ready] = true;

                        new Node:status8 = JSON_Object();
                        JSON_SetInt(status8, "t", 8);
                        JSON_SetInt(status8, "s", 1);
                        JSON_SetInt(status8, "b", 1);
                        SendPacketToClient(player1, 33, status8);
                        SendPacketToClient(player2, 33, status8);
                        JSON_Cleanup(status8);

                        new Node:status26 = JSON_Object();
                        JSON_SetInt(status26, "t", 26);
                        JSON_SetInt(status26, "s", 1);
                        SendPacketToClient(player1, 33, status26);
                        SendPacketToClient(player2, 33, status26);
                        JSON_Cleanup(status26);

                        ShowNotificationSile(player1, 2, 5, -1, -1, "Оба игрока приняли обмен. Подтвердите!", "");
                        ShowNotificationSile(player2, 2, 5, -1, -1, "Оба игрока приняли обмен. Подтвердите!", "");
                    }
                    else
                    {
                        JSON_SetInt(response, "t", 8);
                        JSON_SetInt(response, "s", 1);
                        SendPacketToClient(playerid, 33, response);
                        ShowNotificationSile(playerid, 2, 5, -1, -1, "Вы приняли обмен. Ожидаем другого.", "");
                    }

                    JSON_Cleanup(response);
                }
                case 9:
                {
                    new tradeId = g_PlayerTradeID[playerid];
                    if(tradeId == -1)
                    {
                        JSON_SetInt(response, "t", 9);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(!g_TradeData[tradeId][trade_both_ready])
                    {
                        JSON_SetInt(response, "t", 9);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(g_TradeData[tradeId][trade_player1] == playerid)
                        g_TradeData[tradeId][trade_status1] = 3;
                    else
                        g_TradeData[tradeId][trade_status2] = 3;

                    new status1 = g_TradeData[tradeId][trade_status1];
                    new status2 = g_TradeData[tradeId][trade_status2];
                    new player1 = g_TradeData[tradeId][trade_player1];
                    new player2 = g_TradeData[tradeId][trade_player2];

                    if(status1 == 3 && status2 == 3)
                    {
                        new money1 = g_PlayerTradeMoney[player1];
                        new money2 = g_PlayerTradeMoney[player2];

                        if(money1 > 0)
                        {
                            GivePlayerMoneyEx(player1, -money1, "Обмен");
                            GivePlayerMoneyEx(player2, money1, "Обмен");
                        }
                        if(money2 > 0)
                        {
                            GivePlayerMoneyEx(player2, -money2, "Обмен");
                            GivePlayerMoneyEx(player1, money2, "Обмен");
                        }

                        for(new i = 0; i < MAX_TRADE_SLOTS; i++)
                        {
                            if(g_PlayerTradeItems[player1][i][tr_itemId] > 0)
                            {
                                new itemId = g_PlayerTradeItems[player1][i][tr_itemId];
                                new cnt = g_PlayerTradeItems[player1][i][tr_itemCount];
                                new plate[32];
                                strcpy(plate, g_PlayerTradeItems[player1][i][tr_itemPlate], 32);

                                new toSlot = Inventory_GetFreeSlot(player2);
                                if(toSlot != -1)
                                    Inventory_AddItem(player2, itemId, toSlot, cnt, plate);
                            }
                        }

                        for(new i = 0; i < MAX_TRADE_SLOTS; i++)
                        {
                            if(g_PlayerTradeItems[player2][i][tr_itemId] > 0)
                            {
                                new itemId = g_PlayerTradeItems[player2][i][tr_itemId];
                                new cnt = g_PlayerTradeItems[player2][i][tr_itemCount];
                                new plate[32];
                                strcpy(plate, g_PlayerTradeItems[player2][i][tr_itemPlate], 32);

                                new toSlot = Inventory_GetFreeSlot(player1);
                                if(toSlot != -1)
                                    Inventory_AddItem(player1, itemId, toSlot, cnt, plate);
                            }
                        }

                        new Node:complete = JSON_Object();
                        JSON_SetInt(complete, "t", 9);
                        JSON_SetInt(complete, "s", 1);
                        SendPacketToClient(player1, 33, complete);
                        SendPacketToClient(player2, 33, complete);
                        JSON_Cleanup(complete);

                        ShowNotificationSile(player1, 3, 5, -1, -1, "Обмен успешно завершен!", "");
                        ShowNotificationSile(player2, 3, 5, -1, -1, "Обмен успешно завершен!", "");

                        HidePlayerGUI(player1, 33);
                        HidePlayerGUI(player2, 33);

                        g_TradeData[tradeId][trade_active] = false;
                        g_PlayerTradeID[player1] = -1;
                        g_PlayerTradeID[player2] = -1;
                        ResetPlayerTradeItems(player1);
                        ResetPlayerTradeItems(player2);
                    }
                    else
                    {
                        JSON_SetInt(response, "t", 9);
                        JSON_SetInt(response, "s", 2);
                        SendPacketToClient(playerid, 33, response);
                        ShowNotificationSile(playerid, 2, 5, -1, -1, "Вы подтвердили. Ожидаем другого.", "");
                    }

                    JSON_Cleanup(response);
                }
                case 16:
                {
                    new tradeId = g_PlayerTradeID[playerid];
                    if(tradeId != -1)
                    {
                        new player1 = g_TradeData[tradeId][trade_player1];
                        new player2 = g_TradeData[tradeId][trade_player2];

                        for(new i = 0; i < MAX_TRADE_SLOTS; i++)
                        {
                            if(g_PlayerTradeItems[player1][i][tr_itemId] > 0)
                            {
                                new fromSlot = g_PlayerTradeItems[player1][i][tr_fromSlot];
                                new itemId = g_PlayerTradeItems[player1][i][tr_itemId];
                                new cnt = g_PlayerTradeItems[player1][i][tr_itemCount];
                                new plate[32];
                                strcpy(plate, g_PlayerTradeItems[player1][i][tr_itemPlate], 32);
                                Inventory_AddItem(player1, itemId, fromSlot, cnt, plate);
                            }

                            if(g_PlayerTradeItems[player2][i][tr_itemId] > 0)
                            {
                                new fromSlot = g_PlayerTradeItems[player2][i][tr_fromSlot];
                                new itemId = g_PlayerTradeItems[player2][i][tr_itemId];
                                new cnt = g_PlayerTradeItems[player2][i][tr_itemCount];
                                new plate[32];
                                strcpy(plate, g_PlayerTradeItems[player2][i][tr_itemPlate], 32);
                                Inventory_AddItem(player2, itemId, fromSlot, cnt, plate);
                            }
                        }

                        new msg[128];
                        format(msg, sizeof(msg), "Игрок %s закрыл окно обмена. Обмен отменен.", GetPlayerNameEx(playerid));

                        if(player1 == playerid)
                        {
                            if(IsPlayerConnected(player2))
                            {
                                ShowNotificationSile(player2, 2, 5, -1, -1, msg, "");
                                HidePlayerGUI(player2, 33);
                            }
                        }
                        else
                        {
                            if(IsPlayerConnected(player1))
                            {
                                ShowNotificationSile(player1, 2, 5, -1, -1, msg, "");
                                HidePlayerGUI(player1, 33);
                            }
                        }

                        HidePlayerGUI(playerid, 33);

                        g_TradeData[tradeId][trade_active] = false;
                        g_PlayerTradeID[player1] = -1;
                        g_PlayerTradeID[player2] = -1;
                        ResetPlayerTradeItems(player1);
                        ResetPlayerTradeItems(player2);
                    }

                    JSON_SetInt(response, "t", 16);
                    JSON_SetInt(response, "s", 1);
                    SendPacketToClient(playerid, 33, response);
                    JSON_Cleanup(response);
                }
                case 18:
                {
                    new delete_slot = -1;
                    new delete_item_id = 0;

                    JSON_GetInt(JSONObject, "s", delete_slot);
                    if(delete_slot == -1) JSON_GetInt(JSONObject, "s", delete_slot);

                    JSON_GetInt(JSONObject, "ga", delete_item_id);

                    if(delete_slot == -1)
                    {
                        for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
                        {
                            if(g_PlayerInventory[playerid][i][inv_itemId] == delete_item_id)
                            {
                                delete_slot = i;
                            }
                        }
                    }

                    if(delete_slot < 0 || delete_slot >= MAX_INVENTORY_SLOTS)
                    {
                        JSON_SetInt(response, "t", 18);
                        JSON_SetInt(response, "s", 0);
                    }

                    new actual_item_id = g_PlayerInventory[playerid][delete_slot][inv_itemId];

                    if(actual_item_id == 0)
                    {
                        JSON_SetInt(response, "t", 18);
                        JSON_SetInt(response, "s", 0);
                    }

                    new item_name[64];
                    GetItemName(actual_item_id, item_name);

                    if(actual_item_id == 134 || actual_item_id == 58)
                    {
                        if(Inventory_DeleteItemCompletely(playerid, delete_slot))
                        {
                            JSON_SetInt(response, "t", 18);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "w", GetPlayerWeight(playerid));
                        }
                        else
                        {
                            JSON_SetInt(response, "t", 18);
                            JSON_SetInt(response, "s", 0);
                        }
                    }
                    else
                    {
                        if(Inventory_RemoveOneItem(playerid, delete_slot))
                        {
                            JSON_SetInt(response, "t", 18);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "w", GetPlayerWeight(playerid));

                            new notif[128];
                            if(g_PlayerInventory[playerid][delete_slot][inv_itemCount] > 0)
                            {
                                format(notif, sizeof(notif), "Предмет удален.");
                            }
                            else
                            {
                                format(notif, sizeof(notif), "Предмет удален.");
                            }

                            ShowNotificationSile(playerid, 2, 4, 0, 0, notif, "");
                        }
                        else
                        {
                            JSON_SetInt(response, "t", 18);
                            JSON_SetInt(response, "s", 0);
                        }
                    }
                }
                case 19:
                {
                    JSON_GetInt(JSONObject, "ga", item_id);
                    JSON_GetInt(JSONObject, "s", pos);

                    new model_id = Accessory_GetModelIdByItemId(item_id);
                    if(model_id != -1)
                    {
                        printf("[ACCESSORY] Это аксессуар, model_id=%d", model_id);

                        new can_equip = CanEquipAccessory(playerid, item_id);

                        if(can_equip == -1)
                        {
                            ShowNotificationSile(playerid, 2, 5, -1, -1, "Нельзя одеть два акксесуара одного типа.", "");

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 0);
                            SendPacketToClient(playerid, 33, response);
                            JSON_Cleanup(response);
                            return;
                        }
                        else if(can_equip > 0)
                        {
                            new required_bone = can_equip;
                            printf("[ACCESSORY] Кость %d свободна, можно надевать", required_bone);

                            new free_active_slot = Inventory_GetFreeAccessorySlot(playerid);

                            if(free_active_slot == -1)
                            {
                                ShowNotificationSile(playerid, 2, 5, -1, -1, "Все слоты заняты.", "");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            printf("[ACCESSORY] Найден свободный активный слот инвентаря: %d", free_active_slot);

                            SetPVarInt(playerid, "inv_slot", pos);
                            SetPVarInt(playerid, "item_id", item_id);
                            SetPVarInt(playerid, "model_id", model_id);
                            SetPVarInt(playerid, "target_slot", free_active_slot);
                            SetPVarInt(playerid, "target_bone", required_bone);

                            HidePlayerGUI(playerid, 33);

                            CreateAcsTextDraw(playerid);

                            SetPVarInt(playerid, "slot", free_active_slot);
                            SetPVarInt(playerid, "modelid", model_id);
                            SetPVarInt(playerid, "bone", required_bone);
                            SetPVarFloat(playerid, "num_1", 0.0);
                            SetPVarFloat(playerid, "num_2", 0.0);
                            SetPVarFloat(playerid, "num_3", 0.0);
                            SetPVarFloat(playerid, "num_4", 0.0);
                            SetPVarFloat(playerid, "num_5", 0.0);
                            SetPVarFloat(playerid, "num_6", 0.0);
                            SetPVarFloat(playerid, "num_7", 1.0);

                            SetPlayerAttachedObject(
                                playerid,
                                free_active_slot,
                                model_id,
                                required_bone,
                                0.0, 0.0, 0.0,
                                0.0, 0.0, 0.0,
                                1.0, 1.0, 1.0,
                                0
                            );

                            SetPVarInt(playerid, "acs_use", 1);
                            SetPVarInt(playerid, "updateacs", 0);

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", GetPlayerWeight(playerid));

                            SendPacketToClient(playerid, 33, response);
                            JSON_Cleanup(response);
                            return;
                        }
                    }
                    switch(item_id)
                    {
                        case 21:
                        {
                            new use_slot = -1;

                            JSON_GetInt(JSONObject, "s", use_slot);


                            new current_count = g_PlayerInventory[playerid][use_slot][inv_itemCount];

                            if(current_count <= 0)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                return;
                            }

                            new vehicleid = INVALID_VEHICLE_ID;
                            new Float: x, Float: y, Float: z;

                            GetPlayerPos(playerid, x, y, z);

                            for(new v = 1; v <= MAX_VEHICLES; v++)
                            {
                                if(!IsValidVehicle(v)) continue;

                                new Float: vx, Float: vy, Float: vz;
                                GetVehiclePos(v, vx, vy, vz);

                                if(GetPlayerDistanceFromPoint(playerid, vx, vy, vz) <= 4.5)
                                {
                                    vehicleid = v;
                                    break;
                                }
                            }

                            if(vehicleid == INVALID_VEHICLE_ID)
                            {
                                ShowNotificationSile(playerid, 2, 5, -1, -1, "Рядом нет транспортного средства.", "");
                                return;
                            }

                            if(GetVehicleData(vehicleid, V_FUEL) >= 150.0)
                            {
                                ShowNotificationSile(playerid, 2, 5, -1, -1, "Бензобак этого авто уже полон.", "");
                                return;
                            }

                            new Float: current_fuel = GetVehicleData(vehicleid, V_FUEL);
                            new Float: new_fuel = current_fuel + 15.0;
                            if(new_fuel > 150.0) new_fuel = 150.0;

                            SetVehicleData(vehicleid, V_FUEL, new_fuel);

                            if(current_count > 1)
                            {
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = current_count - 1;

                                new query[256];
                                mysql_format(mysql, query, sizeof(query),
                                    "UPDATE `player_inventory` SET `item_count` = %d WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
                                    current_count - 1, GetPlayerAccountID(playerid), use_slot);
                                mysql_tquery(mysql, query);
                            }
                            else
                            {
                                g_PlayerInventory[playerid][use_slot][inv_itemId] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemSlot] = use_slot;
                                g_PlayerInventory[playerid][use_slot][inv_itemPlate][0] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemType] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemWeight] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemName][0] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemActive] = false;

                                new query[256];
                                mysql_format(mysql, query, sizeof(query),
                                    "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
                                    GetPlayerAccountID(playerid), use_slot);
                                mysql_tquery(mysql, query);
                            }

                            new newWeight = GetPlayerWeight(playerid) - GetItemWeight(24);
                            SetPlayerWeight(playerid, newWeight);

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", 1);

                            ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы заправили транспортное средство канистрой.", "");
                        }
                        case 22:
                        {
                            new use_slot = -1;

                            JSON_GetInt(JSONObject, "s", use_slot);


                            new current_count = g_PlayerInventory[playerid][use_slot][inv_itemCount];

                            if(current_count <= 0)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                return;
                            }

                            if(!CanUseMedkit(playerid))
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                ShowNotificationSile(playerid, 2, 5, -1, -1, "Подождите, вы не можете использовать аптечку так часто", "");
                                return;
                            }

                            new Float:health;
                            GetPlayerHealth(playerid, health);

                            new Float:newHealth = health + 60.0;
                            if(newHealth > 100.0) newHealth = 100.0;

                            SetPlayerHealthEx(playerid, newHealth, true);

                            SetPlayerMedkitUsed(playerid, true);
                            SetTimerEx("ResetMedkitCooldown", 5000, false, "i", playerid);

                            if(current_count > 1)
                            {
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = current_count - 1;

                                new query[256];
                                mysql_format(mysql, query, sizeof(query),
                                    "UPDATE `player_inventory` SET `item_count` = %d WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
                                    current_count - 1, GetPlayerAccountID(playerid), use_slot);
                                mysql_tquery(mysql, query);

                                new newWeight = GetPlayerWeight(playerid) - GetItemWeight(22);
                                SetPlayerWeight(playerid, newWeight);
                            }
                            else
                            {
                                new newWeight = GetPlayerWeight(playerid) - GetItemWeight(22);
                                SetPlayerWeight(playerid, newWeight);

                                g_PlayerInventory[playerid][use_slot][inv_itemId] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemSlot] = use_slot;
                                g_PlayerInventory[playerid][use_slot][inv_itemPlate][0] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemType] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemWeight] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemName][0] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemActive] = false;

                                new query[256];
                                mysql_format(mysql, query, sizeof(query),
                                    "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
                                    GetPlayerAccountID(playerid), use_slot);
                                mysql_tquery(mysql, query);
                            }

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", 1);

                            ApplyAnimationEx(playerid, "ped", "gum_eat", 4.0, 0, 0, 0, 0, 0, 1);
                            ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы использовали аптечку. Ваше здоровье восстановлено на 60 единиц", "");
                        }
                        case 23:
                        {
                            new use_slot = -1;

                            JSON_GetInt(JSONObject, "s", use_slot);
                            if(use_slot == -1) JSON_GetInt(JSONObject, "s", use_slot);

                            if(use_slot < 0 || use_slot >= MAX_INVENTORY_SLOTS)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                return;
                            }

                            if(g_PlayerInventory[playerid][use_slot][inv_itemId] != 23)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                return;
                            }

                            new current_count = g_PlayerInventory[playerid][use_slot][inv_itemCount];

                            if(current_count <= 0)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                return;
                            }

                            new vehicleid = INVALID_VEHICLE_ID;
                            new Float: x, Float: y, Float: z;

                            GetPlayerPos(playerid, x, y, z);

                            for(new v = 1; v <= MAX_VEHICLES; v++)
                            {
                                if(!IsValidVehicle(v)) continue;

                                new Float: vx, Float: vy, Float: vz;
                                GetVehiclePos(v, vx, vy, vz);

                                if(GetPlayerDistanceFromPoint(playerid, vx, vy, vz) <= 4.50)
                                {
                                    vehicleid = v;
                                    break;
                                }
                            }

                            if(vehicleid == INVALID_VEHICLE_ID)
                            {
                                ShowNotificationSile(playerid, 2, 5, -1, -1, "Рядом нет машины.");
                                return;
                            }

                            new Float: vehicle_health;
                            GetVehicleHealth(vehicleid, vehicle_health);
                            SetVehicleData(vehicleid, V_HEALTH, 1000.0);

                            if(vehicle_health >= 990.0)
                            {
                                ShowNotificationSile(playerid, 2, 5, -1, -1, "Ваше авто в хорошем состоянии.");
                                return;
                            }

                            RepairVehicle(vehicleid);

                            if(current_count > 1)
                            {
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = current_count - 1;

                                new query[256];
                                mysql_format(mysql, query, sizeof(query),
                                    "UPDATE `player_inventory` SET `item_count` = %d WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
                                    current_count - 1, GetPlayerAccountID(playerid), use_slot);
                                mysql_tquery(mysql, query);

                            }
                            else
                            {
                                g_PlayerInventory[playerid][use_slot][inv_itemId] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemSlot] = use_slot;
                                g_PlayerInventory[playerid][use_slot][inv_itemPlate][0] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemType] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemWeight] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemName][0] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemActive] = false;

                                new query[256];
                                mysql_format(mysql, query, sizeof(query),
                                    "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
                                    GetPlayerAccountID(playerid), use_slot);
                                mysql_tquery(mysql, query);
                            }

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", 1);


                            ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы успешно починили машину.", "");
                        }
                        case 58:
                        {
                            new use_slot = -1;

                            JSON_GetInt(JSONObject, "s", use_slot);
                            if(use_slot == -1) JSON_GetInt(JSONObject, "s", use_slot);

                            if(use_slot < 0 || use_slot >= MAX_INVENTORY_SLOTS)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(g_PlayerInventory[playerid][use_slot][inv_itemId] != 58)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new newPhone = g_PlayerInventory[playerid][use_slot][inv_itemCount];
                            new oldPhone = GetPlayerPhone(playerid);

                            if(oldPhone != 0)
                            {
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = oldPhone;
                                SaveInventoryItem(playerid, use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "ga", 58);
                                JSON_SetInt(response, "os", old_pos);
                                JSON_SetInt(response, "s", pos);
                            }
                            else
                            {
                                Inventory_DeleteItemCompletely(playerid, use_slot);
                            }

                            SetPlayerData(playerid, P_PHONE, newPhone);
                            UpdatePlayerDatabaseInt(playerid, "phone", newPhone);

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", 255);
                            JSON_SetInt(response, "w", 1);

                            new notif[128];
                            if(oldPhone != 0)
                            {
                                format(notif, sizeof(notif), "Ваш номер телефона изменен на новый номер: %d", newPhone);
                                ShowNotificationSile(playerid, 3, 4, -1, -1, "Номер телефона изменен в инвентаре.", "");
                            }
                            else
                            {
                                format(notif, sizeof(notif), "Ваш номер телефона активирован: %d", newPhone);
                            }
                            ShowNotificationSile(playerid, 3, 4, -1, -1, notif, "");

                            SendPacketToClient(playerid, 33, response);
                            JSON_Cleanup(response);
                        }
                        case 59:
                        {
                            new Node:response = JSON_Object();
                            new use_slot = -1;

                            JSON_GetInt(JSONObject, "s", use_slot);

                            if(use_slot < 0 || use_slot >= MAX_INVENTORY_SLOTS)
                            {
                                printf("[PLATES DEBUG] Invalid use_slot: %d", use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(strlen(g_PlayerInventory[playerid][use_slot][inv_itemPlate]) == 0)
                            {
                                printf("[PLATES DEBUG] No plate item in slot %d", use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new vehicleid = GetPlayerOwnableCar(playerid);
                            printf("[PLATES DEBUG] vehicleid from GetPlayerOwnableCar: %d", vehicleid);

                            if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0)
                            {
                                printf("[PLATES DEBUG] No ownable vehicle nearby");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(!IsValidVehicle(vehicleid))
                            {
                                printf("[PLATES DEBUG] Invalid vehicleid: %d", vehicleid);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new Float: x, Float: y, Float: z;
                            GetVehiclePos(vehicleid, x, y, z);

                            if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            printf("[PLATES DEBUG] Checking IsPlateOnVehicle...");
                            if(IsPlateOnVehicle(playerid))
                            {
                                printf("[PLATES DEBUG] IsPlateOnVehicle returned TRUE - vehicle already has plates");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                ShowNotificationSile(playerid, 2, 7, -1, -1, "На вашей машине стоят номера.", "");
                                return;
                            }

                            printf("[PLATES DEBUG] IsPlateOnVehicle returned FALSE - vehicle has no plates");

                            new plate_from_db[32];
                            strcpy(plate_from_db, g_PlayerInventory[playerid][use_slot][inv_itemPlate], 32);
                            printf("[PLATES DEBUG] plate_from_db: '%s'", plate_from_db);

                            if(strlen(plate_from_db) == 0)
                            {
                                printf("[PLATES DEBUG] Empty plate_from_db!");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new plate_text[32];
                            new plate_number[32];

                            SplitPlate(plate_from_db, plate_text, sizeof(plate_text), plate_number, sizeof(plate_number));

                            printf("[PLATES DEBUG] After SplitPlate - plate_text: '%s', plate_number: '%s'", plate_text, plate_number);
                            printf("[PLATES DEBUG] plate_text len: %d, plate_number len: %d", strlen(plate_text), strlen(plate_number));

                            if(strlen(plate_text) == 0 || strlen(plate_number) == 0)
                            {
                                printf("[PLATES DEBUG] ERROR: Empty plate text or number after split!");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(strlen(plate_text) > 8 || strlen(plate_number) > 8)
                            {
                                printf("[PLATES DEBUG] Plate text too long: text_len=%d, number_len=%d", strlen(plate_text), strlen(plate_number));
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            printf("[PLATES DEBUG] About to call SetVehicleNumberPlateEx");
                            printf("[PLATES DEBUG] Params: vehicleid=%d, type=1, text='%s', number='%s'", vehicleid, plate_text, plate_number);

                            SetVehicleNumberPlateEx(vehicleid, 1, plate_text, plate_number);

                            printf("[PLATES DEBUG] SetVehicleNumberPlateEx called successfully");

                            new index = GetVehicleData(vehicleid, V_ACTION_ID);
                            printf("[PLATES DEBUG] Vehicle data index: %d", index);

                            if(index < 0 || index >= MAX_OWNABLE_CARS)
                            {
                                printf("[PLATES DEBUG] ERROR: Invalid vehicle data index: %d", index);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }


                            strcpy(g_ownable_car[index][OC_NUMBER], plate_text);
                            strcpy(g_ownable_car[index][OC_REGION], plate_number);
                            g_ownable_car[index][OC_NUMBER_TYPE] = 1;

                            new query[512];
                            mysql_format(mysql, query, sizeof query,
                                "UPDATE ownable_cars SET number='%s', region='%s', number_type='1' WHERE id=%d LIMIT 1",
                                plate_text, plate_number, GetOwnableCarData(index, OC_SQL_ID));

                            g_PlayerInventory[playerid][use_slot][inv_itemId] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemCount] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemSlot] = use_slot;
                            g_PlayerInventory[playerid][use_slot][inv_itemPlate][0] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemType] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemWeight] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemName][0] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemActive] = false;

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", 0);

                            SendPacketToClient(playerid, 33, response);

                            printf("[PLATES DEBUG] Update car SQL: %s", query);
                            mysql_query(mysql, query, false);

                            ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
                            ShowNotificationSile(playerid, 3, 7, -1, -1, "Вы успешно поставили номерные знаки.");

                            JSON_Cleanup(response);
                        }
                        case 81:
                        {
                            new Node:response = JSON_Object();
                            new use_slot = -1;
                            JSON_GetInt(JSONObject, "s", use_slot);

                            if(use_slot < 0 || use_slot >= MAX_INVENTORY_SLOTS) {
                                printf("[PLATES DEBUG] Invalid use_slot: %d", use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(strlen(g_PlayerInventory[playerid][use_slot][inv_itemPlate]) == 0) {
                                printf("[PLATES DEBUG] No plate item in slot %d", use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new vehicleid = GetPlayerOwnableCar(playerid);
                            printf("[PLATES DEBUG] vehicleid from GetPlayerOwnableCar: %d", vehicleid);

                            if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) {
                                printf("[PLATES DEBUG] No ownable vehicle nearby");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(!IsValidVehicle(vehicleid)) {
                                printf("[PLATES DEBUG] Invalid vehicleid: %d", vehicleid);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new Float: x, Float: y, Float: z;
                            GetVehiclePos(vehicleid, x, y, z);

                            if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(IsPlateOnVehicle(playerid)) {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                ShowNotificationSile(playerid, 2, 7, -1, -1, "На вашей машине стоят номера.", "");
                                return;
                            }

                            new plate_full[32];
                            strcpy(plate_full, g_PlayerInventory[playerid][use_slot][inv_itemPlate], 32);

                            if(strlen(plate_full) == 0 || strlen(plate_full) > 16) {
                                printf("[PLATES DEBUG] Invalid plate length: %d", strlen(plate_full));
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new index = GetVehicleData(vehicleid, V_ACTION_ID);
                            printf("[PLATES DEBUG] Vehicle data index: %d", index);

                            if(index < 0 || index >= MAX_OWNABLE_CARS) {
                                printf("[PLATES DEBUG] ERROR: Invalid vehicle data index: %d", index);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            SetVehicleNumberPlateEx(vehicleid, 2, plate_full, "");
                            printf("[PLATES DEBUG] SetVehicleNumberPlateEx called");

                            strcpy(g_ownable_car[index][OC_NUMBER], plate_full);
                            g_ownable_car[index][OC_NUMBER_TYPE] = 2;

                            new query[512];
                            mysql_format(mysql, query, sizeof query,
                                "UPDATE ownable_cars SET number='%s', number_type='2' WHERE id=%d LIMIT 1",
                                plate_full, GetOwnableCarData(index, OC_SQL_ID));

                            printf("[PLATES DEBUG] SQL Query: %s", query);
                            mysql_query(mysql, query, false);

                            g_PlayerInventory[playerid][use_slot][inv_itemId] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemCount] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemSlot] = use_slot;
                            g_PlayerInventory[playerid][use_slot][inv_itemPlate][0] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemType] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemWeight] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemName][0] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemActive] = false;

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", 0);
                            JSON_SetString(response, "m", "Номерные знаки успешно установлены!");

                            SendPacketToClient(playerid, 33, response);

                            ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
                            ShowNotificationSile(playerid, 3, 7, -1, -1, "Вы успешно поставили номерные знаки.");

                            JSON_Cleanup(response);
                        }
                        case 82:
                        {
                            new Node:response = JSON_Object();
                            new use_slot = -1;
                            JSON_GetInt(JSONObject, "s", use_slot);

                            if(use_slot < 0 || use_slot >= MAX_INVENTORY_SLOTS) {
                                printf("[PLATES DEBUG] Invalid use_slot: %d", use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(strlen(g_PlayerInventory[playerid][use_slot][inv_itemPlate]) == 0) {
                                printf("[PLATES DEBUG] No plate item in slot %d", use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new vehicleid = GetPlayerOwnableCar(playerid);
                            printf("[PLATES DEBUG] vehicleid from GetPlayerOwnableCar: %d", vehicleid);

                            if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) {
                                printf("[PLATES DEBUG] No ownable vehicle nearby");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(!IsValidVehicle(vehicleid)) {
                                printf("[PLATES DEBUG] Invalid vehicleid: %d", vehicleid);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new Float: x, Float: y, Float: z;
                            GetVehiclePos(vehicleid, x, y, z);

                            if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(IsPlateOnVehicle(playerid)) {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                ShowNotificationSile(playerid, 2, 7, -1, -1, "На вашей машине стоят номера.", "");
                                return;
                            }

                            new plate_full[32];
                            strcpy(plate_full, g_PlayerInventory[playerid][use_slot][inv_itemPlate], 32);

                            if(strlen(plate_full) == 0 || strlen(plate_full) > 16) {
                                printf("[PLATES DEBUG] Invalid plate length: %d", strlen(plate_full));
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new index = GetVehicleData(vehicleid, V_ACTION_ID);
                            printf("[PLATES DEBUG] Vehicle data index: %d", index);

                            if(index < 0 || index >= MAX_OWNABLE_CARS) {
                                printf("[PLATES DEBUG] ERROR: Invalid vehicle data index: %d", index);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            SetVehicleNumberPlateEx(vehicleid, 3, plate_full, "");
                            printf("[PLATES DEBUG] SetVehicleNumberPlateEx called");

                            strcpy(g_ownable_car[index][OC_NUMBER], plate_full);
                            g_ownable_car[index][OC_NUMBER_TYPE] = 3;

                            new query[512];
                            mysql_format(mysql, query, sizeof query,
                                "UPDATE ownable_cars SET number='%s', number_type='3' WHERE id=%d LIMIT 1",
                                plate_full, GetOwnableCarData(index, OC_SQL_ID));

                            printf("[PLATES DEBUG] SQL Query: %s", query);
                            mysql_query(mysql, query, false);

                            g_PlayerInventory[playerid][use_slot][inv_itemId] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemCount] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemSlot] = use_slot;
                            g_PlayerInventory[playerid][use_slot][inv_itemPlate][0] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemType] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemWeight] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemName][0] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemActive] = false;

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", 0);
                            JSON_SetString(response, "m", "Номерные знаки успешно установлены!");

                            SendPacketToClient(playerid, 33, response);

                            ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
                            ShowNotificationSile(playerid, 3, 7, -1, -1, "Вы успешно поставили номерные знаки.");

                            JSON_Cleanup(response);
                        }
                        case 83:
                        {
                            new Node:response = JSON_Object();
                            new use_slot = -1;

                            JSON_GetInt(JSONObject, "s", use_slot);

                            if(use_slot < 0 || use_slot >= MAX_INVENTORY_SLOTS) {
                                printf("[PLATES DEBUG] Invalid use_slot: %d", use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(strlen(g_PlayerInventory[playerid][use_slot][inv_itemPlate]) == 0) {
                                printf("[PLATES DEBUG] No plate item in slot %d", use_slot);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new vehicleid = GetPlayerOwnableCar(playerid);
                            printf("[PLATES DEBUG] vehicleid from GetPlayerOwnableCar: %d", vehicleid);

                            if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0) {
                                printf("[PLATES DEBUG] No ownable vehicle nearby");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(!IsValidVehicle(vehicleid)) {
                                printf("[PLATES DEBUG] Invalid vehicleid: %d", vehicleid);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new Float: x, Float: y, Float: z;
                            GetVehiclePos(vehicleid, x, y, z);

                            if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            printf("[PLATES DEBUG] Checking IsPlateOnVehicle...");
                            if(IsPlateOnVehicle(playerid)) {
                                printf("[PLATES DEBUG] IsPlateOnVehicle returned TRUE - vehicle already has plates");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                ShowNotificationSile(playerid, 2, 7, -1, -1, "На вашей машине стоят номера.", "");
                                return;
                            }

                            printf("[PLATES DEBUG] IsPlateOnVehicle returned FALSE - vehicle has no plates");

                            new plate_from_db[32];
                            strcpy(plate_from_db, g_PlayerInventory[playerid][use_slot][inv_itemPlate], 32);
                            printf("[PLATES DEBUG] plate_from_db: '%s'", plate_from_db);

                            if(strlen(plate_from_db) == 0) {
                                printf("[PLATES DEBUG] Empty plate_from_db!");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            new plate_text[32];
                            new plate_number[32];

                            SplitPlate(plate_from_db, plate_text, sizeof(plate_text), plate_number, sizeof(plate_number));

                            printf("[PLATES DEBUG] After SplitPlate - plate_text: '%s', plate_number: '%s'", plate_text, plate_number);
                            printf("[PLATES DEBUG] plate_text len: %d, plate_number len: %d", strlen(plate_text), strlen(plate_number));

                            if(strlen(plate_text) == 0 || strlen(plate_number) == 0) {
                                printf("[PLATES DEBUG] ERROR: Empty plate text or number after split!");
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            if(strlen(plate_text) > 8 || strlen(plate_number) > 8) {
                                printf("[PLATES DEBUG] Plate text too long: text_len=%d, number_len=%d", strlen(plate_text), strlen(plate_number));
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            printf("[PLATES DEBUG] About to call SetVehicleNumberPlateEx");
                            printf("[PLATES DEBUG] Params: vehicleid=%d, type=4, text='%s', number='%s'", vehicleid, plate_text, plate_number);

                            SetVehicleNumberPlateEx(vehicleid, 4, plate_text, plate_number);

                            printf("[PLATES DEBUG] SetVehicleNumberPlateEx called successfully");

                            new index = GetVehicleData(vehicleid, V_ACTION_ID);
                            printf("[PLATES DEBUG] Vehicle data index: %d", index);

                            if(index < 0 || index >= MAX_OWNABLE_CARS) {
                                printf("[PLATES DEBUG] ERROR: Invalid vehicle data index: %d", index);
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                SendPacketToClient(playerid, 33, response);
                                JSON_Cleanup(response);
                                return;
                            }

                            strcpy(g_ownable_car[index][OC_NUMBER], plate_text);
                            strcpy(g_ownable_car[index][OC_REGION], plate_number);
                            g_ownable_car[index][OC_NUMBER_TYPE] = 4;

                            new query[512];
                            mysql_format(mysql, query, sizeof query,
                                "UPDATE ownable_cars SET number='%s', region='%s', number_type='4' WHERE id=%d LIMIT 1",
                                plate_text, plate_number, GetOwnableCarData(index, OC_SQL_ID));

                            g_PlayerInventory[playerid][use_slot][inv_itemId] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemCount] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemSlot] = use_slot;
                            g_PlayerInventory[playerid][use_slot][inv_itemPlate][0] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemType] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemWeight] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemName][0] = 0;
                            g_PlayerInventory[playerid][use_slot][inv_itemActive] = false;

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", 0);

                            SendPacketToClient(playerid, 33, response);

                            printf("[PLATES DEBUG] Update car SQL: %s", query);
                            mysql_query(mysql, query, false);

                            ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
                            ShowNotificationSile(playerid, 3, 7, -1, -1, "Вы успешно поставили номерные знаки.");

                            JSON_Cleanup(response);
                        }
                        case 116:
                        {
                            new use_slot = -1;

                            JSON_GetInt(JSONObject, "s", use_slot);

                            if(use_slot < 0 || use_slot >= MAX_INVENTORY_SLOTS)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                return;
                            }

                            if(g_PlayerInventory[playerid][use_slot][inv_itemId] != 116)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                return;
                            }

                            new current_count = g_PlayerInventory[playerid][use_slot][inv_itemCount];

                            if(current_count <= 0)
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);
                                return;
                            }
                            if(SetPlayerAttachedObject(playerid, 8, 2641, 2, 0.029, 0.059, 0.000, 180.000, 90.000, 0.000, 1.100, 1.100, 1.100))
                            {
                                SendClientMessage(playerid, 0x3399FFFF, "Маска успешно надета, скрывающая вашу личность на 10 минут");
                                SetPlayerColorEx(playerid, 0x00000000);

                                ApplyAnimation(playerid, "SHOP", "ROB_Shifty", 4.0, 0, 0, 0, 0, 0, 0);
                                SetPlayerChatBubble(playerid, "Надевает маску", 0xFF9900FF, 15.0, 5000);
                                SetTimerEx("RemovePlayerMask", 600000, false, "i", playerid);
                            }

                            if(current_count > 1)
                            {
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = current_count - 1;

                                new query[256];
                                mysql_format(mysql, query, sizeof(query),
                                    "UPDATE `player_inventory` SET `item_count` = %d WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
                                    current_count - 1, GetPlayerAccountID(playerid), use_slot);
                                mysql_tquery(mysql, query);

                                new newWeight = GetPlayerWeight(playerid) - GetItemWeight(116);
                                SetPlayerWeight(playerid, newWeight);
                            }
                            else
                            {
                                new newWeight = GetPlayerWeight(playerid) - GetItemWeight(116);
                                SetPlayerWeight(playerid, newWeight);

                                g_PlayerInventory[playerid][use_slot][inv_itemId] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemCount] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemSlot] = use_slot;
                                g_PlayerInventory[playerid][use_slot][inv_itemPlate][0] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemType] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemWeight] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemName][0] = 0;
                                g_PlayerInventory[playerid][use_slot][inv_itemActive] = false;

                                new query[256];
                                mysql_format(mysql, query, sizeof(query),
                                    "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `slot` = %d AND `is_active` = 0",
                                    GetPlayerAccountID(playerid), use_slot);
                                mysql_tquery(mysql, query);
                            }

                            JSON_SetInt(response, "t", 19);
                            JSON_SetInt(response, "s", 1);
                            JSON_SetInt(response, "i", -1);
                            JSON_SetInt(response, "w", 0);
                        }
                        case 134:
                        {
                            new target_slot = -1;

                            JSON_GetInt(JSONObject, "s", target_slot);
                            JSON_GetInt(JSONObject, "ga", item_id);

                            if(target_slot >= 0 && target_slot < MAX_INVENTORY_SLOTS)
                            {
                                if(g_PlayerInventory[playerid][target_slot][inv_itemId] == 134)
                                {
                                    new skin_in_slot = g_PlayerInventory[playerid][target_slot][inv_itemCount];
                                    if(GetPlayerData(playerid, P_WORK_DAY) == 1 || GetPlayerData(playerid, P_WORK_DAY_DELIVERY))
                                    {
                                        JSON_SetInt(response, "t", 19);
                                        JSON_SetInt(response, "s", 0);

                                        ShowNotificationSile(playerid, 2, 4, 0, 0, "Вы не можете сменить форму организации.", "");
                                        return;
                                    }
                                    if(Inventory_SwapSkin(playerid, target_slot))
                                    {
                                        JSON_SetInt(response, "t", 19);
                                        JSON_SetInt(response, "s", 1);
                                        JSON_SetInt(response, "ps", skin_in_slot);
                                        JSON_SetInt(response, "w", GetPlayerWeight(playerid));

                                        new Node:aiResponse = JSON_Array(
                                            JSON_Int(134),
                                            JSON_Int(GetPlayerSkin(playerid)),
                                            JSON_Int(6),
                                            JSON_Int(0)
                                        );
                                        JSON_SetArray(response, "ai", aiResponse);
                                        JSON_SetInt(response, "i", 6);

                                        Inventory_SendSkinUpdatePacket(playerid, GetPlayerSkin(playerid));
                                        ShowNotificationSile(playerid, 3, 6, 0, 0, "Вы успешно сменили одежду.", "");
                                    }
                                    else
                                    {
                                        JSON_SetInt(response, "t", 19);
                                        JSON_SetInt(response, "s", 0);
                                    }
                                }
                                else
                                {
                                    JSON_SetInt(response, "t", 19);
                                    JSON_SetInt(response, "s", 0);
                                }
                            }
                            else
                            {
                                JSON_SetInt(response, "t", 19);
                                JSON_SetInt(response, "s", 0);

                                new notif[128];
                                format(notif, sizeof(notif), "Ошибка: неверный слот");
                                ShowNotificationSile(playerid, 2, 4, 0, 0, notif, "");
                            }
                        }
                    }
                }
                case 23:
                {
                    JSON_GetInt(JSONObject, "ga", item_id);
                    JSON_GetInt(JSONObject, "os", old_pos);
                    JSON_GetInt(JSONObject, "s", pos);

                    if(Inventory_MoveItem(playerid, old_pos, pos))
                    {
                        JSON_SetInt(response, "t", 23);
                        JSON_SetInt(response, "s", 1);
                    }
                    else
                    {
                        JSON_SetInt(response, "t", 23);
                        JSON_SetInt(response, "s", 0);
                    }
                }
                case 24:
                {
                    JSON_GetInt(JSONObject, "ga", item_id);
                    JSON_GetInt(JSONObject, "s", count);
                    JSON_GetInt(JSONObject, "sl", pos);

                    new tradeId = g_PlayerTradeID[playerid];
                    if(tradeId == -1)
                    {
                        JSON_SetInt(response, "t", 24);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(g_TradeData[tradeId][trade_both_ready])
                    {
                        JSON_SetInt(response, "t", 24);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(pos < 0 || pos >= MAX_TRADE_SLOTS || g_PlayerTradeItems[playerid][pos][tr_itemId] == 0)
                    {
                        JSON_SetInt(response, "t", 24);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    new itemId = g_PlayerTradeItems[playerid][pos][tr_itemId];
                    new cnt = g_PlayerTradeItems[playerid][pos][tr_itemCount];
                    new plate[32];
                    strcpy(plate, g_PlayerTradeItems[playerid][pos][tr_itemPlate], 32);

                    new freeSlot = Inventory_GetFreeSlot(playerid);
                    if(freeSlot == -1)
                    {
                        JSON_SetInt(response, "t", 24);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(Inventory_AddItem(playerid, itemId, freeSlot, cnt, plate))
                    {
                        g_PlayerTradeItems[playerid][pos][tr_itemId] = 0;
                        g_PlayerTradeItems[playerid][pos][tr_itemCount] = 0;
                        g_PlayerTradeItems[playerid][pos][tr_itemSlot] = pos;
                        g_PlayerTradeItems[playerid][pos][tr_itemPlate][0] = 0;
                        g_PlayerTradeItems[playerid][pos][tr_fromSlot] = -1;

                        new Node:updateInv = JSON_Object();
                        JSON_SetInt(updateInv, "t", 0);
                        JSON_SetInt(updateInv, "s", 1);
                        JSON_SetInt(updateInv, "ga", itemId);
                        JSON_SetInt(updateInv, "sl", freeSlot);
                        JSON_SetInt(updateInv, "c", cnt);
                        JSON_SetInt(updateInv, "w", GetPlayerWeight(playerid));
                        if(strlen(plate) > 0)
                            JSON_SetString(updateInv, "nt", plate);
                        SendPacketToClient(playerid, 33, updateInv);
                        JSON_Cleanup(updateInv);

                        new Node:updateMy = JSON_Object();
                        JSON_SetInt(updateMy, "t", 24);
                        JSON_SetInt(updateMy, "s", 1);
                        JSON_SetInt(updateMy, "sl", pos);
                        SendPacketToClient(playerid, 33, updateMy);
                        JSON_Cleanup(updateMy);

                        new to_player = GetTradePartner(playerid);
                        if(to_player != -1 && IsPlayerConnected(to_player))
                        {
                            new Node:updateOther = JSON_Object();
                            JSON_SetInt(updateOther, "t", 24);
                            JSON_SetInt(updateOther, "s", 1);
                            JSON_SetInt(updateOther, "sl", pos);
                            SendPacketToClient(to_player, 33, updateOther);
                            JSON_Cleanup(updateOther);
                        }

                        JSON_SetInt(response, "t", 24);
                        JSON_SetInt(response, "s", 1);
                        JSON_SetInt(response, "sl", pos);
                        JSON_SetInt(response, "w", GetPlayerWeight(playerid));
                        SendPacketToClient(playerid, 33, response);
                    }
                    else
                    {
                        JSON_SetInt(response, "t", 24);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                    }

                    JSON_Cleanup(response);
                }
                case 25:
                {
                    new Float:posX, Float:posY, Float:posZ;
                    GetPlayerPos(playerid, posX, posY, posZ);

                    new string[1024];
                    new count = 0;

                    for(new i = 0; i < MAX_PLAYERS; i++)
                    {
                        if(!IsPlayerConnected(i)) continue;
                        if(i == playerid) continue;
                        if(IsPlayerInTrade(i)) continue;

                        new Float:distance = GetPlayerDistanceFromPoint(i, posX, posY, posZ);
                        if(distance > 20.0) continue;

                        new name[32];
                        GetPlayerName(i, name, sizeof(name));

                        format(string, sizeof(string), "%s%d. %s (%.1f м)\n",
                            string,
                            count + 1,
                            name,
                            distance
                        );
                        count++;
                    }

                    if(count == 0)
                    {
                        ShowNotificationSile(playerid, 2, 4, 0, 0, "Рядом нет игроков для обмена", "");
                        return;
                    }

                    ShowPlayerDialog(
                        playerid,
                        DIALOG_TRADE_SELECT,
                        DIALOG_STYLE_LIST,
                        "Выберите игрока для трейда",
                        string,
                        "Трейд",
                        "Отмена"
                    );
                }
                case 26:
                {
                    JSON_SetInt(response, "t", 26);
                    JSON_SetInt(response, "s", 0);
                    SendPacketToClient(playerid, 33, response);
                    JSON_Cleanup(response);
                }

                case 27:
                {
                    JSON_GetInt(JSONObject, "ga", item_id);
                    JSON_GetInt(JSONObject, "os", old_pos);
                    JSON_GetInt(JSONObject, "s", pos);

                    new tradeId = g_PlayerTradeID[playerid];
                    if(tradeId == -1)
                    {
                        JSON_SetInt(response, "t", 27);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(g_TradeData[tradeId][trade_both_ready])
                    {
                        JSON_SetInt(response, "t", 27);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(old_pos < 0 || old_pos >= MAX_ACTIVE_SLOTS || g_PlayerActiveSlots[playerid][old_pos][inv_itemId] == 0)
                    {
                        JSON_SetInt(response, "t", 27);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(old_pos == 0 && g_PlayerActiveSlots[playerid][0][inv_itemId] == 58)
                    {
                        JSON_SetInt(response, "t", 27);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    if(old_pos == 6 && g_PlayerActiveSlots[playerid][6][inv_itemId] == 134)
                    {
                        JSON_SetInt(response, "t", 27);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    new itemId = g_PlayerActiveSlots[playerid][old_pos][inv_itemId];
                    new cnt = g_PlayerActiveSlots[playerid][old_pos][inv_itemCount];
                    new plate[32];
                    strcpy(plate, g_PlayerActiveSlots[playerid][old_pos][inv_itemPlate], 32);

                    new tradeSlot = -1;
                    for(new i = 0; i < MAX_TRADE_SLOTS; i++)
                    {
                        if(g_PlayerTradeItems[playerid][i][tr_itemId] == 0)
                        {
                            tradeSlot = i;
                            break;
                        }
                    }

                    if(tradeSlot == -1)
                    {
                        JSON_SetInt(response, "t", 27);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    g_PlayerTradeItems[playerid][tradeSlot][tr_itemId] = itemId;
                    g_PlayerTradeItems[playerid][tradeSlot][tr_itemCount] = cnt;
                    g_PlayerTradeItems[playerid][tradeSlot][tr_itemSlot] = tradeSlot;
                    strcpy(g_PlayerTradeItems[playerid][tradeSlot][tr_itemPlate], plate, 32);
                    g_PlayerTradeItems[playerid][tradeSlot][tr_fromSlot] = -1;

                    g_PlayerActiveSlots[playerid][old_pos][inv_itemId] = 0;
                    g_PlayerActiveSlots[playerid][old_pos][inv_itemCount] = 0;
                    g_PlayerActiveSlots[playerid][old_pos][inv_itemPlate][0] = 0;

                    new Node:updateMy = JSON_Object();
                    JSON_SetInt(updateMy, "t", 27);
                    JSON_SetInt(updateMy, "s", 1);
                    JSON_SetInt(updateMy, "sl", tradeSlot);
                    JSON_SetInt(updateMy, "ga", itemId);
                    JSON_SetInt(updateMy, "c", cnt);
                    if(strlen(plate) > 0)
                        JSON_SetString(updateMy, "nt", plate);
                    SendPacketToClient(playerid, 33, updateMy);
                    JSON_Cleanup(updateMy);

                    new to_player = GetTradePartner(playerid);
                    if(to_player != -1 && IsPlayerConnected(to_player))
                    {
                        new Node:updateOther = JSON_Object();
                        JSON_SetInt(updateOther, "t", 27);
                        JSON_SetInt(updateOther, "s", 1);
                        JSON_SetInt(updateOther, "sl", tradeSlot);
                        JSON_SetInt(updateOther, "ga", itemId);
                        JSON_SetInt(updateOther, "c", cnt);
                        if(strlen(plate) > 0)
                            JSON_SetString(updateOther, "nt", plate);
                        SendPacketToClient(to_player, 33, updateOther);
                        JSON_Cleanup(updateOther);
                    }

                    JSON_SetInt(response, "t", 27);
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "sl", tradeSlot);
                    JSON_SetInt(response, "w", GetPlayerWeight(playerid));
                    SendPacketToClient(playerid, 33, response);
                    JSON_Cleanup(response);
                }
                case 31:
                {
                    new message[128];
                    JSON_GetString(JSONObject, "tx", message, sizeof(message));

                    new tradeId = g_PlayerTradeID[playerid];
                    if(tradeId == -1)
                    {
                        JSON_SetInt(response, "t", 31);
                        JSON_SetInt(response, "s", 0);
                        SendPacketToClient(playerid, 33, response);
                        JSON_Cleanup(response);
                        return;
                    }

                    new player1 = g_TradeData[tradeId][trade_player1];
                    new player2 = g_TradeData[tradeId][trade_player2];

                    new Node:msgPacket = JSON_Object();
                    JSON_SetInt(msgPacket, "t", 31);
                    JSON_SetInt(msgPacket, "s", 1);
                    JSON_SetString(msgPacket, "tx", message);
                    JSON_SetInt(msgPacket, "p", playerid);

                    SendPacketToClient(player1, 33, msgPacket);
                    SendPacketToClient(player2, 33, msgPacket);
                    JSON_Cleanup(msgPacket);

                    JSON_SetInt(response, "t", 31);
                    JSON_SetInt(response, "s", 1);
                    SendPacketToClient(playerid, 33, response);
                    JSON_Cleanup(response);
                }
                case 32:
                {
                    new item_id;
                    new target_slot;

                    JSON_GetInt(JSONObject, "ga", item_id);
                    JSON_GetInt(JSONObject, "s", target_slot);

                    new phone_number = GetPlayerData(playerid, P_PHONE);

                    g_PlayerInventory[playerid][target_slot][inv_itemId] = 58;
                    g_PlayerInventory[playerid][target_slot][inv_itemCount] = phone_number;
                    g_PlayerInventory[playerid][target_slot][inv_itemSlot] = target_slot;
                    g_PlayerInventory[playerid][target_slot][inv_itemPlate][0] = 0;
                    g_PlayerInventory[playerid][target_slot][inv_itemType] = GetItemType(58);
                    g_PlayerInventory[playerid][target_slot][inv_itemWeight] = GetItemWeight(58);
                    GetItemName(58, g_PlayerInventory[playerid][target_slot][inv_itemName]);
                    g_PlayerInventory[playerid][target_slot][inv_itemActive] = false;

                    SaveInventoryItem(playerid, target_slot);

                    SetPlayerData(playerid, P_PHONE, 0);
                    UpdatePlayerDatabaseInt(playerid, "phone", 0);

                    JSON_SetInt(response, "t", 32);
                    JSON_SetInt(response, "s", 1);
                    JSON_SetInt(response, "sl", target_slot);
                    JSON_SetInt(response, "w", GetPlayerWeight(playerid));
                    JSON_SetInt(response, "nm", 0);

                    ShowNotificationSile(playerid, 2, 4, 0, 0, "SIM-карта извлечена в инвентарь", "");

                    SendPacketToClient(playerid, 33, response);
                    JSON_Cleanup(response);
                }
                default:
                {
                    JSON_SetInt(response, "t", type);
                    JSON_SetInt(response, "s", 0);
                }
            }

            if(response != 0)
            {
                SendPacketToClient(playerid, 33, response);
                JSON_Cleanup(response);
            }
        }
        case 73:
        {
            new Node:response = JSONObject;
            new json_data[512];
            JSON_Stringify(response, json_data);
            Cases_SendPacketToClient(playerid, json_data);
        }
        case 74:
        {
            BPR_OnPacket(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        case 63:
        {
            HandleInteractionNPCButton(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
        }
        case 113:
        {
            TabletHandlePacket(playerid, JSONObject);
            JSON_Cleanup(JSONObject);
        }

    }
}

public FindGameId(internalId, array[][], array_size)
{
    for(new i = 0; i < array_size; i++)
    {
        if(array[i][0] == internalId)
        {
            return array[i][1];
        }
    }
    return -1;
}

public BuyPlayerCar(playerid, internal_id, game_id, color)
{
    if(game_id == -1)
    {
        return 1;
    }

    new free_car_id = GetFreeOwnableCarID();
    new Float:pos_x = 2498.205810;
    new Float:pos_y = -742.256042;
    new Float:pos_z = 12.164166;
    new Float:angle = 356.240051;

    SetOwnableCarData(free_car_id, OC_OWNER_ID, GetPlayerAccountID(playerid));
    SetOwnableCarData(free_car_id, OC_MODEL_ID, game_id);
    SetOwnableCarData(free_car_id, OC_COLOR_1, color);
    SetOwnableCarData(free_car_id, OC_COLOR_2, color);
    SetOwnableCarData(free_car_id, OC_POS_X, pos_x);
    SetOwnableCarData(free_car_id, OC_POS_Y, pos_y);
    SetOwnableCarData(free_car_id, OC_POS_Z, pos_z);
    SetOwnableCarData(free_car_id, OC_ANGLE, angle);

    strmid(g_ownable_car[free_car_id][OC_NUMBER], "regerds_test_number", 0, 8, 8);

    SetOwnableCarData(free_car_id, OC_ALARM, false);
    SetOwnableCarData(free_car_id, OC_KEY_IN, false);
    SetOwnableCarData(free_car_id, OC_CREATE, gettime());

    format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    new database_query[256];
    format(database_query, sizeof(database_query), "INSERT INTO ownable_cars (owner_id, model_id, color_1, color_2, pos_x, pos_y, pos_z, angle, create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
        GetPlayerAccountID(playerid), game_id, color, color, pos_x, pos_y, pos_z, angle, gettime());
    mysql_query(mysql, database_query, true);

    if(GetPlayerData(playerid, P_QUEST_8) == 0)
    {
        SetPlayerData(playerid, P_QUEST_8, 1);
        UpdatePlayerDatabaseInt(playerid, "quest_8", 1);
        SendClientMessage(playerid, COR_SERVER, "{ffffff}Вы выполнили задание {009900}'Приобрести автомобиль'. {ffffff}Награда: {009900}10000 руб");
        SendClientMessage(playerid, COR_SERVER, "{ffffff}Команда {009900}/quest{ffffff},чтобы посмотреть остальные задания");
        GivePlayerMoneyEx(playerid, 10000, "За выполнение задания");
    }

    for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
    {
        if(g_player_added_promotions_data[playerid][i][0] == internal_id)
        {
            g_player_added_promotions_data[playerid][i][0] = -1;
        }
    }
}

public ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:JSONObject = JSON_Object(), json_data[512];
    JSON_SetInt(JSONObject, "t", 0);
    JSON_SetInt(JSONObject, "y", 1);
    JSON_SetInt(JSONObject, "g", internal_id);
    JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(JSONObject, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(JSONObject, "m", "Покупка совершена");
    JSON_SetString(JSONObject, "n", pack_name);
    JSON_Stringify(JSONObject, json_data);
    SendPacketToClient(playerid, 22, JSONObject);
    JSON_Cleanup(JSONObject);
}

stock bool:GetDonateVipByInternalId(internal_id, &vip_level, &vip_days, vip_name[], vip_name_size = 32)
{
    vip_level = 0;
    vip_days = 0;
    vip_name[0] = '\0';

    switch(internal_id)
    {
        case 128, 184: vip_level = 1, vip_days = 3;
        case 129: vip_level = 1, vip_days = 7;
        case 130: vip_level = 1, vip_days = 15;
        case 131: vip_level = 1, vip_days = 30;
        case 132, 190: vip_level = 2, vip_days = 3;
        case 133: vip_level = 2, vip_days = 7;
        case 134: vip_level = 2, vip_days = 15;
        case 135: vip_level = 2, vip_days = 30;
        case 136, 192: vip_level = 3, vip_days = 3;
        case 137: vip_level = 3, vip_days = 7;
        case 138: vip_level = 3, vip_days = 15;
        case 139: vip_level = 3, vip_days = 30;
        case 186: vip_level = 1, vip_days = 2;
        case 188: vip_level = 1, vip_days = 3;
        default: return false;
    }

    switch(vip_level)
    {
        case 1: format(vip_name, vip_name_size, "VIP Silver");
        case 2: format(vip_name, vip_name_size, "VIP Gold");
        case 3: format(vip_name, vip_name_size, "VIP Platinum");
        default: format(vip_name, vip_name_size, "VIP");
    }

    return true;
}

stock GivePlayerDonateVip(playerid, vip_level, vip_days)
{
    new current_time = gettime();
    new old_premium_date = GetPlayerData(playerid, P_PREMIUM_DATE);
    new premium_date = old_premium_date;
    new premium_level = GetPlayerPremium(playerid);
    new final_level = vip_level;

    if(old_premium_date > current_time && premium_level > final_level)
    {
        final_level = premium_level;
    }

    if(premium_date < current_time)
    {
        premium_date = current_time;
    }

    premium_date += vip_days * 86400;

    SetPlayerData(playerid, P_PREMIUM, final_level);
    SetPlayerData(playerid, P_VIP_STATUS, final_level);
    SetPlayerData(playerid, P_PREMIUM_DATE, premium_date);

    UpdatePlayerDatabaseInt(playerid, "premium", final_level);
    UpdatePlayerDatabaseInt(playerid, "premium_date", premium_date);
}

stock ShowSuccesfullBuyVip(playerid, internal_id, vip_name[], vip_days)
{
    new Node:JSONObject = JSON_Object(), json_data[512];
    new premium_day, premium_month, premium_year;
    new message[128];

    timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), premium_year, premium_month, premium_day);

    format(message, sizeof(message), "%s на %d дн. до %02d.%02d.%d", vip_name, vip_days, premium_day, premium_month, premium_year);

    JSON_SetInt(JSONObject, "t", 0);
    JSON_SetInt(JSONObject, "y", 1);
    JSON_SetInt(JSONObject, "g", internal_id);
    JSON_SetInt(JSONObject, "r", GetPlayerMoneyEx(playerid));
    JSON_SetInt(JSONObject, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(JSONObject, "m", "Покупка совершена");
    JSON_SetString(JSONObject, "n", message);
    JSON_Stringify(JSONObject, json_data);
    SendPacketToClient(playerid, 22, JSONObject);
    JSON_Cleanup(JSONObject);
}

public: BuyPlayerSkin(playerid, internal_id, game_id)
{
    new freeSlot = Inventory_GetFreeSlot(playerid);
    if(freeSlot == -1)
    {
        ShowNotificationSile(playerid, 2, 7, -1, -1, "Нет свободного места в инвентаре", "");
        return 1;
    }

    Inventory_AddItem(playerid, 134, freeSlot, game_id, "");

    SaveInventoryItem(playerid, freeSlot);
    return 1;
}

public: BuyPlayerAcs(playerid, internal_id, game_id)
{
    new freeSlot = Inventory_GetFreeSlot(playerid);
    if(freeSlot == -1)
    {
        ShowNotificationSile(playerid, 2, 7, -1, -1, "Нет свободного места в инвентаре!", "");
        return 0;
    }

    new inv_item_id = internal_id;
    Inventory_AddItem(playerid, FindGameId(internal_id, accessories_game_ids, sizeof(accessories_game_ids)), freeSlot, 1, "");

    SaveInventoryItem(playerid, freeSlot);

    return 1;
}

stock ShowPlayerGUI(playerid, guiid, Node:json)
{
    JSON_SetInt(json, "o", 1);
    SendPacketToClient(playerid, guiid, json);
}


stock SendPacketToClient(playerid, guiid, Node:json)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 252);
    BS_WriteValue(bitstream, PR_UINT16, guiid);

    new data[2048];
    JSON_Stringify(json, data, sizeof(data));

    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock SendPacketToClientString(playerid, guiid, const data[])
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 252);
    BS_WriteValue(bitstream, PR_UINT16, guiid);
    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
}

stock FindAccsIndexByModelId(modelid)
{
    for(new i = 0; i < sizeof(AccsData); i++)
    {
        if(AccsData[i][accModel] == modelid)
        {
            return i;
        }
    }
    return -1;
}

stock GetModelIdByInternalId(internal_id)
{
    for(new i = 0; i < sizeof(accessories_game_ids); i++)
    {
        if(accessories_game_ids[i][0] == internal_id)
        {
            return accessories_game_ids[i][1];
        }
    }
    return -1;
}

stock Accessory_GetItemIdByModel(modelid)
{

    switch(modelid)
    {
        case 907: return 1;
        case 908: return 2;
        case 909: return 3;
        case 910: return 8;
        case 911: return 18;
        case 912: return 4;
        case 913: return 19;
        case 914: return 9;
        case 915: return 13;
        case 916: return 5;
        case 917: return 14;
        case 918: return 7;
        case 919: return 10;
        case 920: return 20;
        case 921: return 11;
        case 922: return 15;
        case 923: return 12;
        case 924: return 16;
        case 925: return 17;
        case 926: return 6;
        case 939: return 25;
        case 944: return 24;
        case 945: return 26;
        case 946: return 27;
        case 967: return 35;
        case 968: return 36;
        case 969: return 37;
        case 970: return 48;
        case 971: return 49;
        case 972: return 50;
        case 973: return 51;
        case 974: return 52;
        case 975: return 53;
        case 976: return 54;
        case 977: return 55;
        case 978: return 56;
        case 979: return 38;
        case 980: return 39;
        case 981: return 40;
        case 982: return 41;
        case 983: return 57;
        case 984: return 42;
        case 985: return 30;
        case 986: return 31;
        case 987: return 43;
        case 988: return 44;
        case 989: return 45;
        case 990: return 32;
        case 992: return 46;
        case 993: return 47;
        case 994: return 33;
        case 995: return 34;
        case 997: return 58;
        case 1194: return 60;
        case 1195: return 61;
        case 1196: return 62;
        case 1197: return 63;
        case 1198: return 64;
        case 1199: return 65;
        case 1210: return 346;
        case 1212: return 162;
        case 1230: return 704;
        case 1231: return 703;
        case 1328: return 724;
        case 1329: return 725;
        case 1330: return 726;
        case 1377: return 586;
        case 1378: return 587;
        case 1379: return 588;
        case 1380: return 589;
        case 1381: return 590;
        case 1382: return 591;
        case 1383: return 592;
        case 1384: return 593;
        case 1385: return 594;
        case 1386: return 595;
        case 1387: return 596;
        case 1388: return 597;
        case 1389: return 598;
        case 1390: return 599;
        case 1650: return 21;
        case 1651: return 891;
        case 1652: return 890;
        case 1653: return 892;
        case 1654: return 80;
        case 1699: return 68;
        case 1701: return 69;
        case 1702: return 70;
        case 1703: return 71;
        case 1704: return 72;
        case 1705: return 73;
        case 1706: return 74;
        case 1707: return 75;
        case 1708: return 76;
        case 1709: return 77;
        case 1710: return 78;
        case 1711: return 79;
        case 1716: return 67;
        case 1720: return 84;
        case 1721: return 85;
        case 1722: return 86;
        case 1723: return 87;
        case 1724: return 88;
        case 1725: return 89;
        case 1726: return 90;
        case 1727: return 96;
        case 1728: return 97;
        case 1729: return 98;
        case 1730: return 99;
        case 1731: return 100;
        case 1732: return 101;
        case 1733: return 106;
        case 1734: return 107;
        case 1735: return 108;
        case 1736: return 109;
        case 1737: return 110;
        case 1743: return 102;
        case 1744: return 103;
        case 1745: return 104;
        case 1746: return 105;
        case 1747: return 91;
        case 1748: return 92;
        case 1749: return 93;
        case 1750: return 94;
        case 1751: return 95;
        case 1754: return 59;
        case 1755: return 81;
        case 1756: return 82;
        case 1757: return 83;
        case 1776: return 115;
        case 1777: return 114;
        case 1778: return 113;
        case 1779: return 112;
        case 1783: return 111;
        case 1789: return 119;
        case 1790: return 118;
        case 1791: return 120;
        case 1795: return 117;
        case 1975: return 921;
        case 1978: return 749;
        case 1979: return 745;
        case 1980: return 742;
        case 1981: return 750;
        case 1982: return 737;
        case 1983: return 752;
        case 1984: return 732;
        case 1985: return 747;
        case 1986: return 735;
        case 1987: return 739;
        case 1988: return 757;
        case 1989: return 759;
        case 1990: return 746;
        case 1991: return 730;
        case 1992: return 733;
        case 1993: return 751;
        case 1995: return 743;
        case 1996: return 744;
        case 1997: return 729;
        case 1998: return 738;
        case 1999: return 741;
        case 2001: return 731;
        case 2002: return 753;
        case 2003: return 740;
        case 2004: return 758;
        case 2005: return 734;
        case 2006: return 736;
        case 2007: return 748;
        case 2008: return 754;
        case 2646: return 66;
        case 2649: return 780;
        case 2655: return 914;
        case 2656: return 915;
        case 2657: return 916;
        case 3153: return 728;
        case 3154: return 727;
        case 4084: return 632;
        case 4085: return 631;
        case 4086: return 635;
        case 4087: return 633;
        case 4088: return 636;
        case 4089: return 634;
        case 4090: return 638;
        case 4091: return 640;
        case 4092: return 639;
        case 4093: return 641;
        case 4094: return 637;
        case 4096: return 621;
        case 4097: return 619;
        case 4098: return 618;
        case 4099: return 627;
        case 4100: return 623;
        case 4101: return 624;
        case 4102: return 620;
        case 4103: return 613;
        case 4104: return 628;
        case 4105: return 615;
        case 4106: return 629;
        case 4107: return 625;
        case 4108: return 626;
        case 4109: return 616;
        case 4110: return 617;
        case 4111: return 630;
        case 4112: return 614;
        case 4113: return 645;
        case 4114: return 644;
        case 4115: return 646;
        case 4116: return 643;
        case 4117: return 642;
        case 4119: return 622;
        case 4158: return 529;
        case 4159: return 530;
        case 4160: return 531;
        case 4161: return 532;
        case 4162: return 533;
        case 4163: return 534;
        case 4164: return 535;
        case 4165: return 536;
        case 4166: return 537;
        case 4196: return 490;
        case 4197: return 491;
        case 4198: return 492;
        case 4199: return 493;
        case 4200: return 494;
        case 4201: return 495;
        case 4202: return 496;
        case 4203: return 497;
        case 4204: return 498;
        case 4205: return 499;
        case 4206: return 500;
        case 4207: return 501;
        case 4208: return 502;
        case 4231: return 477;
        case 4232: return 485;
        case 4233: return 488;
        case 4234: return 487;
        case 4235: return 489;
        case 4236: return 486;
        case 4237: return 484;
        case 4238: return 483;
        case 4239: return 482;
        case 4240: return 481;
        case 4241: return 480;
        case 4242: return 478;
        case 4243: return 479;
        case 4359: return 705;
        case 4360: return 706;
        case 4361: return 707;
        case 4372: return 927;
        case 4542: return 928;
        case 4543: return 929;
        case 4544: return 933;
        case 4545: return 935;
        case 4546: return 938;
        case 4547: return 940;
        case 4548: return 934;
        case 4549: return 941;
        case 4550: return 926;
        case 4699: return 953;
        case 4700: return 954;
        case 4701: return 957;
        case 4702: return 946;
        case 4859: return 919;
        case 4860: return 925;
        case 4861: return 922;
        case 4862: return 920;
        case 4863: return 923;
        case 4864: return 924;
        case 5270: return 797;
        case 5271: return 802;
        case 5272: return 798;
        case 5273: return 788;
        case 5274: return 796;
        case 5275: return 764;
        case 5278: return 800;
        case 5280: return 781;
        case 5281: return 787;
        case 5283: return 761;
        case 5284: return 765;
        case 5285: return 774;
        case 5286: return 762;
        case 5287: return 766;
        case 5288: return 801;
        case 5289: return 769;
        case 5291: return 767;
        case 5292: return 799;
        case 5371: return 463;
        case 5372: return 464;
        case 5373: return 465;
        case 5374: return 466;
        case 5375: return 467;
        case 5376: return 468;
        case 5377: return 469;
        case 5378: return 470;
        case 5379: return 471;
        case 5380: return 472;
        case 5381: return 473;
        case 5382: return 474;
        case 5383: return 475;
        case 5384: return 476;
        case 5431: return 462;
        case 5822: return 778;
        case 5826: return 771;
        case 5828: return 772;
        case 5830: return 791;
        case 6101: return 887;
        case 6102: return 888;
        case 6103: return 889;
        case 6169: return 668;
        case 6170: return 669;
        case 6171: return 670;
        case 6172: return 671;
        case 6173: return 672;
        case 6174: return 673;
        case 6175: return 674;
        case 6176: return 675;
        case 6177: return 676;
        case 6178: return 677;
        case 6179: return 678;
        case 6180: return 679;
        case 6181: return 680;
        case 662: return 686;
        case 663: return 687;
        case 676: return 917;
        case 677: return 918;
        case 7327: return 391;
        case 7328: return 392;
        case 7329: return 393;
        case 7330: return 394;
        case 7331: return 395;
        case 7332: return 396;
        case 7333: return 397;
        case 7334: return 398;
        case 7335: return 399;
        case 7336: return 400;
        case 7337: return 401;
        case 7338: return 402;
        case 7339: return 403;
        case 7340: return 404;
        case 7341: return 405;
        case 7342: return 406;
        case 7343: return 407;
        case 7344: return 408;
        case 7345: return 409;
        case 7346: return 410;
        case 7347: return 411;
        case 7348: return 412;
        case 7349: return 413;
        case 7350: return 414;
        case 7351: return 415;
        case 7352: return 416;
        case 7353: return 417;
        case 7354: return 418;
        case 7355: return 419;
        case 7356: return 420;
        case 7357: return 421;
        case 7358: return 422;
        case 7359: return 423;
        case 7360: return 424;
        case 7361: return 425;
        case 7362: return 426;
        case 7363: return 427;
        case 7364: return 428;
        case 7365: return 429;
        case 7366: return 430;
        case 7367: return 431;
        case 7368: return 432;
        case 7369: return 433;
        case 7370: return 434;
        case 7371: return 435;
        case 7372: return 436;
        case 7373: return 437;
        case 7374: return 438;
        case 7375: return 439;
        case 7376: return 440;
        case 7377: return 441;
        case 7378: return 442;
        case 7379: return 443;
        case 7380: return 444;
        case 7381: return 445;
        case 7382: return 446;
        case 7383: return 447;
        case 7384: return 448;
        case 7385: return 449;
        case 7386: return 450;
        case 7387: return 451;
        case 7388: return 452;
        case 7389: return 453;
        case 7390: return 454;
        case 7391: return 455;
        case 7392: return 456;
        case 7393: return 457;
        case 7394: return 458;
        case 7395: return 459;
        case 7396: return 460;
        case 7397: return 461;
        case 7712: return 932;
        case 7727: return 936;
        case 7729: return 937;
        case 780: return 702;
        case 781: return 701;
        case 786: return 681;
        case 787: return 682;
        case 788: return 683;
        case 789: return 684;
        case 790: return 685;
        case 791: return 912;
        case 792: return 913;
        case 9376: return 647;
        case 9377: return 648;
        case 9378: return 649;
        case 9379: return 650;
        case 9380: return 651;
        case 9381: return 652;
        case 9382: return 653;
        case 9383: return 654;
        case 9384: return 655;
        case 9385: return 656;
        case 9386: return 657;
        case 9387: return 658;
        case 9388: return 659;
        case 9406: return 688;
        case 9407: return 689;
        case 9408: return 690;
        case 9409: return 691;
        case 9410: return 692;
        case 9794: return 600;
        case 9795: return 601;
        case 9796: return 602;
        case 9797: return 603;
        case 9798: return 604;
        case 9799: return 605;
        case 9800: return 606;
        case 9801: return 607;
        case 9802: return 608;
        case 9803: return 609;
        case 9804: return 610;
        case 9805: return 611;
        case 9806: return 612;
        case 9824: return 660;
        case 9825: return 661;
        case 9826: return 662;
        case 9827: return 663;
        case 9828: return 664;
        case 9960: return 760;
        case 9964: return 793;
        case 9966: return 763;
        case 9969: return 790;
        case 9972: return 770;
        case 9973: return 804;
        case 9974: return 794;
        case 9975: return 776;
        case 9980: return 803;
        case 9984: return 777;
        case 9990: return 775;
        case 9992: return 789;
        case 9993: return 784;
        case 9994: return 782;
        case 9997: return 795;
        case 9998: return 783;
        case 9999: return 773;
        case 10000: return 792;
        case 10001: return 768;
        case 10002: return 785;
        case 100001: return 116;
        case 100006: return 1009;
        case 100007: return 1010;
        case 100034: return 1022;
        case 100035: return 1021;
        case 100065: return 1023;
        case 100066: return 1024;
        case 100067: return 1025;
        case 100068: return 1026;
        case 100069: return 1027;
        case 100070: return 1028;
        case 100071: return 1029;
        case 100072: return 1030;
        case 100073: return 1031;
        case 100074: return 1032;
        case 100075: return 1033;
        case 100076: return 1034;
        case 100077: return 1043;
        case 100078: return 1044;
        case 100079: return 1045;
        case 100101: return 1046;
        case 100102: return 1047;
        case 100103: return 1048;
        case 100104: return 1049;
        case 100105: return 1050;
        case 100106: return 1051;
        case 100107: return 1052;
        case 100108: return 1053;
        case 100109: return 1054;
        case 100110: return 1055;
        case 100111: return 1056;
        case 100112: return 1057;
        case 100113: return 1058;
        case 100162: return 1062;
        case 100163: return 1063;
        case 100164: return 1064;
        case 100165: return 1065;
        case 100166: return 1066;
        case 100167: return 1067;
        case 100169: return 1073;
        case 100170: return 1068;
        case 100171: return 1069;
        case 100189: return 1075;
        case 10488: return 943;
        case 10492: return 939;
        case 10493: return 930;
        case 10494: return 931;
        case 10836: return 122;
        case 10916: return 964;
        case 10952: return 121;
        case 11292: return 958;
        case 11304: return 965;
        case 11328: return 962;
        case 11919: return 579;
        case 11920: return 580;
        case 11921: return 581;
        case 11922: return 582;
        case 11923: return 583;
        case 11924: return 584;
        case 11925: return 585;
        case 12222: return 125;
        case 12223: return 126;
        case 12224: return 127;
        case 12225: return 129;
        case 12226: return 128;
        case 12227: return 131;
        case 12228: return 132;
        case 12229: return 123;
        case 12231: return 130;
        case 12233: return 124;
        case 12301: return 910;
        case 12302: return 905;
        case 12303: return 909;
        case 12304: return 907;
        case 12306: return 908;
        case 12307: return 911;
        case 12308: return 906;
        case 12635: return 133;
        case 13266: return 561;
        case 13628: return 345;
        case 13735: return 550;
        case 13736: return 551;
        case 13737: return 552;
        case 13738: return 553;
        case 13739: return 554;
        case 13740: return 555;
        case 13741: return 556;
        case 13742: return 557;
        case 13743: return 558;
        case 13744: return 559;
        case 13745: return 560;
        case 13746: return 540;
        case 13747: return 541;
        case 13748: return 542;
        case 13749: return 543;
        case 13750: return 544;
        case 13751: return 545;
        case 13752: return 546;
        case 13753: return 547;
        case 13754: return 548;
        case 13755: return 549;
        case 13761: return 538;
        case 13762: return 539;
        case 13801: return 576;
        case 13802: return 577;
        case 13803: return 578;
        case 13804: return 563;
        case 13805: return 564;
        case 13806: return 565;
        case 13807: return 566;
        case 13808: return 567;
        case 13809: return 568;
        case 13810: return 569;
        case 13811: return 570;
        case 13812: return 571;
        case 13813: return 572;
        case 13814: return 573;
        case 13815: return 574;
        case 13816: return 575;
        case 13879: return 504;
        case 13880: return 505;
        case 13881: return 506;
        case 13882: return 507;
        case 13883: return 508;
        case 13884: return 510;
        case 13885: return 512;
        case 13897: return 562;
        case 13908: return 503;
        case 14265: return 961;
        case 14266: return 960;
        case 14574: return 509;
        case 14575: return 511;
        case 14589: return 513;
        case 14590: return 514;
        case 14591: return 515;
        case 14592: return 516;
        case 14593: return 517;
        case 14594: return 518;
        case 14595: return 519;
        case 14596: return 520;
        case 14597: return 521;
        case 14598: return 522;
        case 14599: return 523;
        case 14600: return 524;
        case 14601: return 525;
        case 14602: return 526;
        case 14603: return 527;
        case 14604: return 528;
        case 14630: return 955;
        case 14641: return 942;
        case 14642: return 956;
        case 14643: return 945;
        case 14644: return 951;
        case 14645: return 947;
        case 14646: return 952;
        case 14647: return 944;
        case 14648: return 950;
        case 14671: return 723;
        case 14672: return 722;
        case 14790: return 948;
        case 14791: return 949;
        case 15055: return 966;
        case 15056: return 959;
        case 15057: return 963;
        case 15058: return 967;
        case 15134: return 135;
        case 15135: return 136;
        case 15136: return 137;
        case 15137: return 138;
        case 15138: return 139;
        case 15139: return 140;
        case 15140: return 141;
        case 15141: return 142;
        case 15142: return 143;
        case 15143: return 144;
        case 15144: return 145;
        case 15145: return 146;
        case 15146: return 147;
        case 15147: return 148;
        case 15148: return 149;
        case 15149: return 150;
        case 15150: return 155;
        case 15151: return 159;
        case 15152: return 151;
        case 15153: return 152;
        case 15154: return 153;
        case 15155: return 154;
        case 15157: return 160;
        case 15158: return 161;
        case 15159: return 158;
        case 15160: return 156;
        case 15161: return 157;
        case 15446: return 693;
        case 15447: return 694;
        case 15448: return 695;
        case 15449: return 696;
        case 15626: return 976;
        case 15627: return 977;
        case 15628: return 981;
        case 15629: return 982;
        case 15630: return 971;
        case 15631: return 972;
        case 15632: return 973;
        case 15633: return 974;
        case 15634: return 975;
        case 15635: return 978;
        case 15636: return 979;
        case 15638: return 980;
        case 16026: return 877;
        case 16027: return 878;
        case 16028: return 879;
        case 16029: return 880;
        case 16030: return 881;
        case 16031: return 882;
        case 16032: return 883;
        case 16033: return 884;
        case 16034: return 885;
        case 16035: return 886;
        case 16045: return 708;
        case 16055: return 709;
        case 16699: return 970;
        case 17509: return 969;
        case 17510: return 968;
        case 17983: return 328;
        case 17984: return 329;
        case 17985: return 330;
        case 17986: return 331;
        case 17987: return 332;
        case 17988: return 333;
        case 17989: return 334;
        case 17990: return 335;
        case 17991: return 336;
        case 17992: return 337;
        case 17993: return 338;
        case 17994: return 339;
        case 17995: return 340;
        case 17996: return 341;
        case 17997: return 342;
        case 17998: return 343;
        case 17999: return 344;
        case 18226: return 163;
        case 18227: return 164;
        case 18228: return 165;
        case 18229: return 166;
        case 18230: return 167;
        case 18231: return 168;
        case 18232: return 169;
        case 18233: return 170;
        case 18234: return 171;
        case 18235: return 172;
        case 18236: return 173;
        case 18237: return 174;
        case 18238: return 175;
        case 18239: return 176;
        case 18240: return 177;
        case 18241: return 178;
        case 18242: return 179;
        case 18243: return 180;
        case 18244: return 181;
        case 18245: return 182;
        case 18246: return 183;
        case 18247: return 184;
        case 18248: return 185;
        case 18249: return 186;
        case 18250: return 187;
        case 18251: return 188;
        case 18252: return 189;
        case 18253: return 190;
        case 18254: return 191;
        case 18255: return 192;
        case 18256: return 193;
        case 18257: return 194;
        case 18258: return 195;
        case 18259: return 196;
        case 18260: return 197;
        case 18261: return 198;
        case 18262: return 199;
        case 18263: return 200;
        case 18264: return 201;
        case 18265: return 202;
        case 18266: return 203;
        case 18267: return 204;
        case 18268: return 205;
        case 18269: return 206;
        case 18270: return 207;
        case 18271: return 208;
        case 18272: return 209;
        case 18273: return 210;
        case 18274: return 211;
        case 18275: return 212;
        case 18276: return 213;
        case 18277: return 214;
        case 18278: return 215;
        case 18279: return 216;
        case 18282: return 217;
        case 18283: return 218;
        case 18284: return 219;
        case 18285: return 220;
        case 18286: return 221;
        case 18287: return 222;
        case 18288: return 223;
        case 18289: return 224;
        case 18290: return 225;
        case 18291: return 226;
        case 18292: return 227;
        case 18293: return 228;
        case 18294: return 229;
        case 18295: return 230;
        case 18296: return 231;
        case 18298: return 232;
        case 18300: return 233;
        case 18301: return 234;
        case 18302: return 235;
        case 18306: return 236;
        case 18307: return 237;
        case 18310: return 238;
        case 18312: return 239;
        case 18313: return 240;
        case 18315: return 242;
        case 18318: return 241;
        case 18319: return 243;
        case 18322: return 244;
        case 18328: return 245;
        case 18329: return 246;
        case 18330: return 247;
        case 18331: return 248;
        case 18332: return 249;
        case 18333: return 250;
        case 18334: return 251;
        case 18335: return 252;
        case 18336: return 253;
        case 18337: return 254;
        case 18338: return 255;
        case 18339: return 256;
        case 18340: return 257;
        case 18341: return 258;
        case 18342: return 259;
        case 18343: return 260;
        case 18344: return 261;
        case 18345: return 262;
        case 18346: return 263;
        case 18347: return 264;
        case 18348: return 265;
        case 18349: return 266;
        case 18350: return 267;
        case 18351: return 268;
        case 18352: return 269;
        case 18353: return 270;
        case 18354: return 271;
        case 18355: return 272;
        case 18356: return 273;
        case 18357: return 274;
        case 18358: return 275;
        case 18364: return 277;
        case 18365: return 278;
        case 18366: return 276;
        case 18367: return 279;
        case 18368: return 280;
        case 18369: return 281;
        case 18370: return 282;
        case 18371: return 283;
        case 18372: return 284;
        case 18373: return 285;
        case 18374: return 286;
        case 18375: return 287;
        case 18376: return 288;
        case 18377: return 289;
        case 18378: return 290;
        case 18379: return 291;
        case 18380: return 292;
        case 18381: return 293;
        case 18382: return 294;
        case 18383: return 295;
        case 18384: return 296;
        case 18385: return 297;
        case 18386: return 298;
        case 18387: return 299;
        case 18388: return 300;
        case 18389: return 301;
        case 18390: return 302;
        case 18391: return 303;
        case 18392: return 304;
        case 18393: return 305;
        case 18394: return 306;
        case 18395: return 307;
        case 18396: return 308;
        case 18397: return 309;
        case 18398: return 310;
        case 18399: return 311;
        case 18400: return 312;
        case 18401: return 313;
        case 18402: return 314;
        case 18403: return 315;
        case 18404: return 316;
        case 18405: return 317;
        case 18406: return 318;
        case 18407: return 319;
        case 18408: return 320;
        case 18409: return 321;
        case 18410: return 322;
        case 18411: return 323;
        case 18412: return 324;
        case 18413: return 325;
        case 18414: return 326;
        case 18415: return 327;
        case 18497: return 347;
        case 18498: return 348;
        case 18499: return 349;
        case 18500: return 350;
        case 18501: return 351;
        case 18502: return 352;
        case 18503: return 353;
        case 18504: return 354;
        case 18505: return 355;
        case 18506: return 356;
        case 18507: return 357;
        case 18508: return 358;
        case 18509: return 359;
        case 18510: return 360;
        case 18511: return 361;
        case 18512: return 362;
        case 18513: return 363;
        case 18514: return 364;
        case 18515: return 365;
        case 18516: return 366;
        case 18517: return 367;
        case 18518: return 368;
        case 18519: return 369;
        case 18520: return 370;
        case 18521: return 371;
        case 18522: return 372;
        case 18523: return 373;
        case 18524: return 374;
        case 18525: return 375;
        case 18526: return 376;
        case 18527: return 377;
        case 18528: return 378;
        case 18529: return 379;
        case 18530: return 380;
        case 18567: return 381;
        case 18568: return 382;
        case 18569: return 383;
        case 18570: return 384;
        case 18571: return 385;
        case 18572: return 386;
        case 18573: return 387;
        case 18574: return 388;
        case 18575: return 389;
        case 18576: return 390;
        case 19211: return 665;
        case 19212: return 666;
        case 19213: return 667;
        case 19632: return 29;
        case 19882: return 28;
        case 31949: return 983;
        case 31961: return 991;
        case 31962: return 985;
        case 31963: return 984;
        case 31964: return 992;
        case 31965: return 990;
        case 31966: return 989;
        case 31967: return 986;
        case 31969: return 988;
        case 31970: return 987;
        case 32129: return 999;
        case 32130: return 1001;
        case 32131: return 994;
        case 32132: return 995;
        case 32133: return 996;
        case 32134: return 997;
        case 32135: return 998;
        case 32136: return 1000;
        case 32137: return 1002;
        case 32138: return 1003;
        case 32139: return 1004;
        case 32144: return 1005;
        case 32154: return 993;
        case 32171: return 1008;
        case 32404: return 1007;
        case 32405: return 756;
        case 32414: return 1013;
        case 32415: return 1014;
        case 32416: return 1015;
        case 32417: return 1016;
        case 32418: return 1017;
        case 32419: return 1018;
        case 32420: return 1019;
        case 32421: return 1020;
        case 32423: return 755;
    }

    printf("[ACCESSORY] No item ID found for model: %d", modelid);
    return -1;
}

stock Accessory_GetModelIdByItemId(itemId)
{

    switch(itemId)
    {
        case 1: return 907;
        case 2: return 908;
        case 3: return 909;
        case 4: return 912;
        case 5: return 916;
        case 6: return 926;
        case 7: return 918;
        case 8: return 910;
        case 9: return 914;
        case 10: return 919;
        case 11: return 921;
        case 12: return 923;
        case 13: return 915;
        case 14: return 917;
        case 15: return 922;
        case 16: return 924;
        case 17: return 925;
        case 18: return 911;
        case 19: return 913;
        case 20: return 920;
        case 30: return 985;
        case 31: return 986;
        case 32: return 990;
        case 33: return 994;
        case 34: return 995;
        case 35: return 967;
        case 36: return 968;
        case 37: return 969;
        case 38: return 979;
        case 39: return 980;
        case 40: return 981;
        case 41: return 982;
        case 42: return 984;
        case 43: return 987;
        case 44: return 988;
        case 45: return 989;
        case 46: return 992;
        case 47: return 993;
        case 48: return 970;
        case 49: return 971;
        case 50: return 972;
        case 51: return 973;
        case 52: return 974;
        case 53: return 975;
        case 54: return 976;
        case 55: return 977;
        case 56: return 978;
        case 57: return 983;
        case 60: return 1194;
        case 61: return 1195;
        case 62: return 1196;
        case 63: return 1197;
        case 64: return 1198;
        case 65: return 1199;
        case 66: return 2646;
        case 67: return 1716;
        case 68: return 1699;
        case 69: return 1701;
        case 70: return 1702;
        case 71: return 1703;
        case 72: return 1704;
        case 73: return 1705;
        case 74: return 1706;
        case 75: return 1707;
        case 76: return 1708;
        case 77: return 1709;
        case 78: return 1710;
        case 79: return 1711;
        case 84: return 1720;
        case 85: return 1721;
        case 86: return 1722;
        case 87: return 1723;
        case 88: return 1724;
        case 89: return 1725;
        case 90: return 1726;
        case 91: return 1747;
        case 92: return 1748;
        case 93: return 1749;
        case 94: return 1750;
        case 95: return 1751;
        case 96: return 1727;
        case 97: return 1728;
        case 98: return 1729;
        case 99: return 1730;
        case 100: return 1731;
        case 101: return 1732;
        case 102: return 1743;
        case 103: return 1744;
        case 104: return 1745;
        case 105: return 1746;
        case 106: return 1733;
        case 107: return 1734;
        case 108: return 1735;
        case 109: return 1736;
        case 110: return 1737;
        case 111: return 1783;
        case 112: return 1779;
        case 113: return 1778;
        case 114: return 1777;
        case 115: return 1776;
        case 135: return 15134;
        case 136: return 15135;
        case 137: return 15136;
        case 138: return 15137;
        case 139: return 15138;
        case 140: return 15139;
        case 141: return 15140;
        case 142: return 15141;
        case 143: return 15142;
        case 144: return 15143;
        case 145: return 15144;
        case 146: return 15145;
        case 147: return 15146;
        case 148: return 15147;
        case 149: return 15148;
        case 150: return 15149;
        case 151: return 15152;
        case 152: return 15153;
        case 153: return 15154;
        case 154: return 15155;
        case 155: return 15150;
        case 156: return 15160;
        case 157: return 15161;
        case 158: return 15159;
        case 159: return 15151;
        case 160: return 15157;
        case 161: return 15158;
        case 162: return 1212;
        case 163: return 18226;
        case 164: return 18227;
        case 165: return 18228;
        case 166: return 18229;
        case 167: return 18230;
        case 168: return 18231;
        case 169: return 18232;
        case 170: return 18233;
        case 171: return 18234;
        case 172: return 18235;
        case 173: return 18236;
        case 174: return 18237;
        case 175: return 18238;
        case 176: return 18239;
        case 177: return 18240;
        case 178: return 18241;
        case 179: return 18242;
        case 180: return 18243;
        case 181: return 18244;
        case 182: return 18245;
        case 183: return 18246;
        case 184: return 18247;
        case 185: return 18248;
        case 186: return 18249;
        case 187: return 18250;
        case 188: return 18251;
        case 189: return 18252;
        case 190: return 18253;
        case 191: return 18254;
        case 192: return 18255;
        case 193: return 18256;
        case 194: return 18257;
        case 195: return 18258;
        case 196: return 18259;
        case 197: return 18260;
        case 198: return 18261;
        case 199: return 18262;
        case 200: return 18263;
        case 201: return 18264;
        case 202: return 18265;
        case 203: return 18266;
        case 204: return 18267;
        case 205: return 18268;
        case 206: return 18269;
        case 207: return 18270;
        case 208: return 18271;
        case 209: return 18272;
        case 210: return 18273;
        case 211: return 18274;
        case 212: return 18275;
        case 213: return 18276;
        case 214: return 18277;
        case 215: return 18278;
        case 216: return 18279;
        case 217: return 18282;
        case 218: return 18283;
        case 219: return 18284;
        case 220: return 18285;
        case 221: return 18286;
        case 222: return 18287;
        case 223: return 18288;
        case 224: return 18289;
        case 225: return 18290;
        case 226: return 18291;
        case 227: return 18292;
        case 228: return 18293;
        case 229: return 18294;
        case 230: return 18295;
        case 231: return 18296;
        case 232: return 18298;
        case 233: return 18300;
        case 234: return 18301;
        case 235: return 18302;
        case 236: return 18306;
        case 237: return 18307;
        case 238: return 18310;
        case 239: return 18312;
        case 240: return 18313;
        case 241: return 18318;
        case 242: return 18315;
        case 243: return 18319;
        case 244: return 18322;
        case 245: return 18328;
        case 246: return 18329;
        case 247: return 18330;
        case 248: return 18331;
        case 249: return 18332;
        case 250: return 18333;
        case 251: return 18334;
        case 252: return 18335;
        case 253: return 18336;
        case 254: return 18337;
        case 255: return 18338;
        case 256: return 18339;
        case 257: return 18340;
        case 258: return 18341;
        case 259: return 18342;
        case 260: return 18343;
        case 261: return 18344;
        case 262: return 18345;
        case 263: return 18346;
        case 264: return 18347;
        case 265: return 18348;
        case 266: return 18349;
        case 267: return 18350;
        case 268: return 18351;
        case 269: return 18352;
        case 270: return 18353;
        case 271: return 18354;
        case 272: return 18355;
        case 273: return 18356;
        case 274: return 18357;
        case 275: return 18358;
        case 276: return 18366;
        case 277: return 18364;
        case 278: return 18365;
        case 279: return 18367;
        case 280: return 18368;
        case 281: return 18369;
        case 282: return 18370;
        case 283: return 18371;
        case 284: return 18372;
        case 285: return 18373;
        case 286: return 18374;
        case 287: return 18375;
        case 288: return 18376;
        case 289: return 18377;
        case 290: return 18378;
        case 291: return 18379;
        case 292: return 18380;
        case 293: return 18381;
        case 294: return 18382;
        case 295: return 18383;
        case 296: return 18384;
        case 297: return 18385;
        case 298: return 18386;
        case 299: return 18387;
        case 300: return 18388;
        case 301: return 18389;
        case 302: return 18390;
        case 303: return 18391;
        case 304: return 18392;
        case 305: return 18393;
        case 306: return 18394;
        case 307: return 18395;
        case 308: return 18396;
        case 309: return 18397;
        case 310: return 18398;
        case 311: return 18399;
        case 312: return 18400;
        case 313: return 18401;
        case 314: return 18402;
        case 315: return 18403;
        case 316: return 18404;
        case 317: return 18405;
        case 318: return 18406;
        case 319: return 18407;
        case 320: return 18408;
        case 321: return 18409;
        case 322: return 18410;
        case 323: return 18411;
        case 324: return 18412;
        case 325: return 18413;
        case 326: return 18414;
        case 327: return 18415;
        case 328: return 17983;
        case 329: return 17984;
        case 330: return 17985;
        case 331: return 17986;
        case 332: return 17987;
        case 333: return 17988;
        case 334: return 17989;
        case 335: return 17990;
        case 336: return 17991;
        case 337: return 17992;
        case 338: return 17993;
        case 339: return 17994;
        case 340: return 17995;
        case 341: return 17996;
        case 342: return 17997;
        case 343: return 17998;
        case 344: return 17999;
        case 345: return 13628;
        case 346: return 1210;
        case 347: return 18497;
        case 348: return 18498;
        case 349: return 18499;
        case 350: return 18500;
        case 351: return 18501;
        case 352: return 18502;
        case 353: return 18503;
        case 354: return 18504;
        case 355: return 18505;
        case 356: return 18506;
        case 357: return 18507;
        case 358: return 18508;
        case 359: return 18509;
        case 360: return 18510;
        case 361: return 18511;
        case 362: return 18512;
        case 363: return 18513;
        case 364: return 18514;
        case 365: return 18515;
        case 366: return 18516;
        case 367: return 18517;
        case 368: return 18518;
        case 369: return 18519;
        case 370: return 18520;
        case 371: return 18521;
        case 372: return 18522;
        case 373: return 18523;
        case 374: return 18524;
        case 375: return 18525;
        case 376: return 18526;
        case 377: return 18527;
        case 378: return 18528;
        case 379: return 18529;
        case 380: return 18530;
        case 381: return 18567;
        case 382: return 18568;
        case 383: return 18569;
        case 384: return 18570;
        case 385: return 18571;
        case 386: return 18572;
        case 387: return 18573;
        case 388: return 18574;
        case 389: return 18575;
        case 390: return 18576;
        case 391: return 7327;
        case 392: return 7328;
        case 393: return 7329;
        case 394: return 7330;
        case 395: return 7331;
        case 396: return 7332;
        case 397: return 7333;
        case 398: return 7334;
        case 399: return 7335;
        case 400: return 7336;
        case 401: return 7337;
        case 402: return 7338;
        case 403: return 7339;
        case 404: return 7340;
        case 405: return 7341;
        case 406: return 7342;
        case 407: return 7343;
        case 408: return 7344;
        case 409: return 7345;
        case 410: return 7346;
        case 411: return 7347;
        case 412: return 7348;
        case 413: return 7349;
        case 414: return 7350;
        case 415: return 7351;
        case 416: return 7352;
        case 417: return 7353;
        case 418: return 7354;
        case 419: return 7355;
        case 420: return 7356;
        case 421: return 7357;
        case 422: return 7358;
        case 423: return 7359;
        case 424: return 7360;
        case 425: return 7361;
        case 426: return 7362;
        case 427: return 7363;
        case 428: return 7364;
        case 429: return 7365;
        case 430: return 7366;
        case 431: return 7367;
        case 432: return 7368;
        case 433: return 7369;
        case 434: return 7370;
        case 435: return 7371;
        case 436: return 7372;
        case 437: return 7373;
        case 438: return 7374;
        case 439: return 7375;
        case 440: return 7376;
        case 441: return 7377;
        case 442: return 7378;
        case 443: return 7379;
        case 444: return 7380;
        case 445: return 7381;
        case 446: return 7382;
        case 447: return 7383;
        case 448: return 7384;
        case 449: return 7385;
        case 450: return 7386;
        case 451: return 7387;
        case 452: return 7388;
        case 453: return 7389;
        case 454: return 7390;
        case 455: return 7391;
        case 456: return 7392;
        case 457: return 7393;
        case 458: return 7394;
        case 459: return 7395;
        case 460: return 7396;
        case 461: return 7397;
        case 463: return 5371;
        case 464: return 5372;
        case 465: return 5373;
        case 466: return 5374;
        case 467: return 5375;
        case 468: return 5376;
        case 469: return 5377;
        case 470: return 5378;
        case 471: return 5379;
        case 472: return 5380;
        case 473: return 5381;
        case 474: return 5382;
        case 475: return 5383;
        case 476: return 5384;
        case 477: return 4231;
        case 478: return 4242;
        case 479: return 4243;
        case 480: return 4241;
        case 481: return 4240;
        case 482: return 4239;
        case 483: return 4238;
        case 484: return 4237;
        case 485: return 4232;
        case 486: return 4236;
        case 487: return 4234;
        case 488: return 4233;
        case 489: return 4235;
        case 490: return 4196;
        case 491: return 4197;
        case 492: return 4198;
        case 493: return 4199;
        case 494: return 4200;
        case 495: return 4201;
        case 496: return 4202;
        case 497: return 4203;
        case 498: return 4204;
        case 499: return 4205;
        case 500: return 4206;
        case 501: return 4207;
        case 502: return 4208;
        case 503: return 13908;
        case 504: return 13879;
        case 505: return 13880;
        case 506: return 13881;
        case 507: return 13882;
        case 508: return 13883;
        case 509: return 14574;
        case 510: return 13884;
        case 511: return 14575;
        case 512: return 13885;
        case 513: return 14589;
        case 514: return 14590;
        case 515: return 14591;
        case 516: return 14592;
        case 517: return 14593;
        case 518: return 14594;
        case 519: return 14595;
        case 520: return 14596;
        case 521: return 14597;
        case 522: return 14598;
        case 523: return 14599;
        case 524: return 14600;
        case 525: return 14601;
        case 526: return 14602;
        case 527: return 14603;
        case 528: return 14604;
        case 529: return 4158;
        case 530: return 4159;
        case 531: return 4160;
        case 532: return 4161;
        case 533: return 4162;
        case 534: return 4163;
        case 535: return 4164;
        case 536: return 4165;
        case 537: return 4166;
        case 538: return 13761;
        case 539: return 13762;
        case 540: return 13746;
        case 541: return 13747;
        case 542: return 13748;
        case 543: return 13749;
        case 544: return 13750;
        case 545: return 13751;
        case 546: return 13752;
        case 547: return 13753;
        case 548: return 13754;
        case 549: return 13755;
        case 550: return 13735;
        case 551: return 13736;
        case 552: return 13737;
        case 553: return 13738;
        case 554: return 13739;
        case 555: return 13740;
        case 556: return 13741;
        case 557: return 13742;
        case 558: return 13743;
        case 559: return 13744;
        case 560: return 13745;
        case 561: return 13266;
        case 562: return 13897;
        case 563: return 13804;
        case 564: return 13805;
        case 565: return 13806;
        case 566: return 13807;
        case 567: return 13808;
        case 568: return 13809;
        case 569: return 13810;
        case 570: return 13811;
        case 571: return 13812;
        case 572: return 13813;
        case 573: return 13814;
        case 574: return 13815;
        case 575: return 13816;
        case 576: return 13801;
        case 577: return 13802;
        case 578: return 13803;
        case 579: return 11919;
        case 580: return 11920;
        case 581: return 11921;
        case 582: return 11922;
        case 583: return 11923;
        case 584: return 11924;
        case 585: return 11925;
        case 586: return 1377;
        case 587: return 1378;
        case 588: return 1379;
        case 589: return 1380;
        case 590: return 1381;
        case 591: return 1382;
        case 592: return 1383;
        case 593: return 1384;
        case 594: return 1385;
        case 595: return 1386;
        case 596: return 1387;
        case 597: return 1388;
        case 598: return 1389;
        case 599: return 1390;
        case 600: return 9794;
        case 601: return 9795;
        case 602: return 9796;
        case 603: return 9797;
        case 604: return 9798;
        case 605: return 9799;
        case 606: return 9800;
        case 607: return 9801;
        case 608: return 9802;
        case 609: return 9803;
        case 610: return 9804;
        case 611: return 9805;
        case 612: return 9806;
        case 613: return 4103;
        case 614: return 4112;
        case 615: return 4105;
        case 616: return 4109;
        case 617: return 4110;
        case 618: return 4098;
        case 619: return 4097;
        case 620: return 4102;
        case 621: return 4096;
        case 622: return 4119;
        case 623: return 4100;
        case 624: return 4101;
        case 625: return 4107;
        case 626: return 4108;
        case 627: return 4099;
        case 628: return 4104;
        case 629: return 4106;
        case 630: return 4111;
        case 631: return 4085;
        case 632: return 4084;
        case 633: return 4087;
        case 634: return 4089;
        case 635: return 4086;
        case 636: return 4088;
        case 637: return 4094;
        case 638: return 4090;
        case 639: return 4092;
        case 640: return 4091;
        case 641: return 4093;
        case 642: return 4117;
        case 643: return 4116;
        case 644: return 4114;
        case 645: return 4113;
        case 646: return 4115;
        case 647: return 9376;
        case 648: return 9377;
        case 649: return 9378;
        case 650: return 9379;
        case 651: return 9380;
        case 652: return 9381;
        case 653: return 9382;
        case 654: return 9383;
        case 655: return 9384;
        case 656: return 9385;
        case 657: return 9386;
        case 658: return 9387;
        case 659: return 9388;
        case 660: return 9824;
        case 661: return 9825;
        case 662: return 9826;
        case 663: return 9827;
        case 664: return 9828;
        case 665: return 19211;
        case 666: return 19212;
        case 667: return 19213;
        case 668: return 6169;
        case 669: return 6170;
        case 670: return 6171;
        case 671: return 6172;
        case 672: return 6173;
        case 673: return 6174;
        case 674: return 6175;
        case 675: return 6176;
        case 676: return 6177;
        case 677: return 6178;
        case 678: return 6179;
        case 679: return 6180;
        case 680: return 6181;
        case 681: return 786;
        case 682: return 787;
        case 683: return 788;
        case 684: return 789;
        case 685: return 790;
        case 686: return 662;
        case 687: return 663;
        case 688: return 9406;
        case 689: return 9407;
        case 690: return 9408;
        case 691: return 9409;
        case 692: return 9410;
        case 693: return 15446;
        case 694: return 15447;
        case 695: return 15448;
        case 696: return 15449;
        case 697: return 1094;
        case 698: return 1095;
        case 699: return 1205;
        case 700: return 1206;
        case 701: return 781;
        case 702: return 780;
        case 703: return 1231;
        case 704: return 1230;
        case 705: return 4359;
        case 706: return 4360;
        case 707: return 4361;
        case 708: return 16045;
        case 709: return 16055;
        case 710: return 4784;
        case 711: return 4785;
        case 712: return 4786;
        case 713: return 4787;
        case 714: return 4788;
        case 715: return 4789;
        case 716: return 4790;
        case 717: return 4791;
        case 718: return 4792;
        case 719: return 4793;
        case 720: return 4794;
        case 721: return 4795;
        case 722: return 14672;
        case 723: return 14671;
        case 724: return 1328;
        case 725: return 1329;
        case 726: return 1330;
        case 727: return 3154;
        case 728: return 3153;
        case 729: return 1997;
        case 730: return 1991;
        case 731: return 2001;
        case 732: return 1984;
        case 733: return 1992;
        case 734: return 2005;
        case 735: return 1986;
        case 736: return 2006;
        case 737: return 1982;
        case 738: return 1998;
        case 739: return 1987;
        case 740: return 2003;
        case 741: return 1999;
        case 742: return 1980;
        case 743: return 1995;
        case 744: return 1996;
        case 745: return 1979;
        case 746: return 1990;
        case 747: return 1985;
        case 748: return 2007;
        case 749: return 1978;
        case 750: return 1981;
        case 751: return 1993;
        case 752: return 1983;
        case 753: return 2002;
        case 754: return 2008;
        case 755: return 32423;
        case 756: return 32405;
        case 757: return 1988;
        case 758: return 2004;
        case 759: return 1989;
        case 760: return 9960;
        case 761: return 5283;
        case 762: return 5286;
        case 763: return 9966;
        case 764: return 5275;
        case 765: return 5284;
        case 766: return 5287;
        case 767: return 5291;
        case 768: return 10001;
        case 769: return 5289;
        case 770: return 9972;
        case 771: return 5826;
        case 772: return 5828;
        case 773: return 9999;
        case 774: return 5285;
        case 775: return 9990;
        case 776: return 9975;
        case 777: return 9984;
        case 778: return 5822;
        case 779: return 5283;
        case 780: return 2649;
        case 781: return 5280;
        case 782: return 9994;
        case 783: return 9998;
        case 784: return 9993;
        case 785: return 10002;
        case 786: return 5828;
        case 787: return 5281;
        case 788: return 5273;
        case 789: return 9992;
        case 790: return 9969;
        case 791: return 5830;
        case 792: return 10000;
        case 793: return 9964;
        case 794: return 9974;
        case 795: return 9997;
        case 796: return 5274;
        case 797: return 5270;
        case 798: return 5272;
        case 799: return 5292;
        case 800: return 5278;
        case 801: return 5288;
        case 802: return 5271;
        case 803: return 9980;
        case 804: return 9973;
        case 805: return 9973;
        case 806: return 9973;
        case 807: return 9973;
        case 808: return 9973;
        case 809: return 9973;
        case 810: return 9973;
        case 811: return 9973;
        case 812: return 9973;
        case 813: return 9973;
        case 814: return 9973;
        case 815: return 9973;
        case 816: return 9973;
        case 817: return 9973;
        case 818: return 9973;
        case 819: return 9973;
        case 820: return 9973;
        case 821: return 9973;
        case 822: return 9973;
        case 823: return 9973;
        case 824: return 9973;
        case 825: return 9973;
        case 826: return 9973;
        case 827: return 9973;
        case 828: return 9973;
        case 829: return 9973;
        case 830: return 9973;
        case 831: return 9973;
        case 832: return 9973;
        case 833: return 9973;
        case 834: return 9973;
        case 835: return 9973;
        case 836: return 9973;
        case 837: return 9973;
        case 838: return 9973;
        case 839: return 9973;
        case 840: return 9973;
        case 841: return 9973;
        case 842: return 9973;
        case 843: return 9973;
        case 844: return 9973;
        case 845: return 9973;
        case 846: return 9973;
        case 847: return 9973;
        case 848: return 9973;
        case 849: return 9973;
        case 850: return 9973;
        case 851: return 9973;
        case 852: return 9973;
        case 853: return 9973;
        case 854: return 9973;
        case 855: return 9973;
        case 856: return 9973;
        case 857: return 9973;
        case 858: return 9973;
        case 859: return 9973;
        case 860: return 9973;
        case 861: return 9973;
        case 862: return 9973;
        case 863: return 9973;
        case 864: return 9973;
        case 865: return 9973;
        case 866: return 9973;
        case 867: return 9973;
        case 868: return 9973;
        case 869: return 9973;
        case 870: return 9973;
        case 871: return 9973;
        case 872: return 9973;
        case 873: return 9973;
        case 874: return 9973;
        case 875: return 9973;
        case 876: return 9973;
        case 877: return 16026;
        case 878: return 16027;
        case 879: return 16028;
        case 880: return 16029;
        case 881: return 16030;
        case 882: return 16031;
        case 883: return 16032;
        case 884: return 16033;
        case 885: return 16034;
        case 886: return 16035;
        case 887: return 6101;
        case 888: return 6102;
        case 889: return 6103;
        case 890: return 1652;
        case 891: return 1651;
        case 892: return 1653;
        case 893: return 9973;
        case 894: return 9973;
        case 895: return 9973;
        case 896: return 9973;
        case 897: return 9973;
        case 898: return 9973;
        case 899: return 9973;
        case 900: return 9973;
        case 901: return 9973;
        case 902: return 9973;
        case 903: return 9973;
        case 904: return 9973;
        case 905: return 12302;
        case 906: return 12308;
        case 907: return 12304;
        case 908: return 12306;
        case 909: return 12303;
        case 910: return 12301;
        case 911: return 12307;
        case 912: return 791;
        case 913: return 792;
        case 914: return 2655;
        case 915: return 2656;
        case 916: return 2657;
        case 917: return 676;
        case 918: return 677;
        case 919: return 4859;
        case 920: return 4862;
        case 921: return 1975;
        case 922: return 4861;
        case 923: return 4863;
        case 924: return 4864;
        case 925: return 4860;
        case 926: return 4550;
        case 927: return 4372;
        case 928: return 4542;
        case 929: return 4543;
        case 930: return 10493;
        case 931: return 10494;
        case 932: return 7712;
        case 933: return 4544;
        case 934: return 4548;
        case 935: return 4545;
        case 936: return 7727;
        case 937: return 7729;
        case 938: return 4546;
        case 939: return 10492;
        case 940: return 4547;
        case 941: return 4549;
        case 942: return 14641;
        case 943: return 10488;
        case 944: return 14647;
        case 945: return 14643;
        case 946: return 4702;
        case 947: return 14645;
        case 948: return 14790;
        case 949: return 14791;
        case 950: return 14648;
        case 951: return 14644;
        case 952: return 14646;
        case 953: return 4699;
        case 954: return 4700;
        case 955: return 14630;
        case 956: return 14642;
        case 957: return 4701;
        case 958: return 11292;
        case 959: return 15056;
        case 960: return 14266;
        case 961: return 14265;
        case 962: return 11328;
        case 963: return 15057;
        case 964: return 10916;
        case 965: return 11304;
        case 966: return 15055;
        case 967: return 15058;
        case 968: return 17510;
        case 969: return 17509;
        case 970: return 16699;
        case 971: return 15630;
        case 972: return 15631;
        case 973: return 15632;
        case 974: return 15633;
        case 975: return 15634;
        case 976: return 15626;
        case 977: return 15627;
        case 978: return 15635;
        case 979: return 15636;
        case 980: return 15638;
        case 981: return 15628;
        case 982: return 15629;
        case 983: return 31949;
        case 984: return 31963;
        case 985: return 31962;
        case 986: return 31967;
        case 987: return 31970;
        case 988: return 31969;
        case 989: return 31966;
        case 990: return 31965;
        case 991: return 31961;
        case 992: return 31964;
        case 993: return 32154;
        case 994: return 32131;
        case 995: return 32132;
        case 996: return 32133;
        case 997: return 32134;
        case 998: return 32135;
        case 999: return 32129;
        case 1000: return 32136;
        case 1001: return 32130;
        case 1002: return 32137;
        case 1003: return 32138;
        case 1004: return 32139;
        case 1005: return 32144;
        case 1006: return 32154;
        case 1007: return 32404;
        case 1008: return 32171;
        case 1009: return 100006;
        case 1010: return 100007;
        case 1011: return 9973;
        case 1012: return 9973;
        case 1013: return 32414;
        case 1014: return 32415;
        case 1015: return 32416;
        case 1016: return 32417;
        case 1017: return 32418;
        case 1018: return 32419;
        case 1019: return 32420;
        case 1020: return 32421;
        case 1021: return 100035;
        case 1022: return 100034;
        case 1023: return 100065;
        case 1024: return 100066;
        case 1025: return 100067;
        case 1026: return 100068;
        case 1027: return 100069;
        case 1028: return 100070;
        case 1029: return 100071;
        case 1030: return 100072;
        case 1031: return 100073;
        case 1032: return 100074;
        case 1033: return 100075;
        case 1034: return 100076;
        case 1035: return 9973;
        case 1036: return 9973;
        case 1037: return 9973;
        case 1038: return 9974;
        case 1039: return 0;
        case 1040: return 0;
        case 1041: return 0;
        case 1042: return 0;
        case 1043: return 100077;
        case 1044: return 100078;
        case 1045: return 100079;
        case 1046: return 100101;
        case 1047: return 100102;
        case 1048: return 100103;
        case 1049: return 100104;
        case 1050: return 100105;
        case 1051: return 100106;
        case 1052: return 100107;
        case 1053: return 100108;
        case 1054: return 100109;
        case 1055: return 100110;
        case 1056: return 100111;
        case 1057: return 100112;
        case 1058: return 100113;
        case 1059: return 9973;
        case 1060: return 9973;
        case 1061: return 9974;
        case 1062: return 100162;
        case 1063: return 100163;
        case 1064: return 100164;
        case 1065: return 100165;
        case 1066: return 100166;
        case 1067: return 100167;
        case 1068: return 100170;
        case 1069: return 100171;
        case 1070: return 9973;
        case 1071: return 9973;
        case 1072: return 9974;
        case 1073: return 100169;
        case 1074: return 9974;
        case 1075: return 100189;
        case 1076: return 9973;
        case 1085: return 9974;
    }

    printf("[ACCESSORY] No model found for item ID: %d", itemId);
    return -1;
}