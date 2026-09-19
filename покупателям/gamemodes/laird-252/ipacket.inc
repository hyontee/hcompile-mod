
// --- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
#define ENTER_ENGINE	2
#define ENTER_CONT      3
#define OFFER_YES       4
#define OFFER_ENGINE 	5
#define OFFER_UNLOCK_CAR 8 // ID для открытия дверей
#define EXIT_HOME 6
#define GUI_LOCK 7
#include "../include/json.inc"
//------------------------------------------------------------

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
    {90, 466},
    {195, 440},
    {201, 413},
    {202, 418},
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
    {347, 2580},
    {348, 2584},
    {349, 2582},
    {350, 2579},
    {351, 2578},
    {352, 2581},
    {353, 2583},
    {366, 2586},
    {367, 2585},
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
    {547, 761}
};

new clothes_game_ids[][2] = {
    {91, 23},
    {92, 22},
    {93, 220},
    {94, 225},
    {95, 202},
    {96, 204},
    {97, 229},
    {98, 200},
    {99, 234},
    {100, 249},
    {101, 235},
    {203, 57},
    {205, 252},
    {206, 236},
    {207, 48},
    {208, 63},
    {210, 122},
    {225, 86},
    {226, 224},
    {227, 232},
    {228, 269},
    {229, 231},
    {230, 175},
    {231, 208},
    {232, 199},
    {233, 264},
    {234, 262},
    {235, 62},
    {236, 298},
    {237, 266},
    {238, 65},
    {239, 39},
    {240, 207},
    {257, 209},
    {311, 95},
    {312, 106},
    {313, 108},
    {314, 109},
    {315, 110},
    {316, 165},
    {317, 166},
    {318, 174},
    {319, 5},
    {320, 267},
    {321, 283},
    {322, 49},
    {323, 53},
    {324, 160},
    {325, 162},
    {326, 210},
    {332, 196},
    {333, 129},
    {334, 130},
    {335, 24},
    {336, 245},
    {337, 243},
    {338, 89},
    {339, 88},
    {340, 197},
    {341, 10},
    {342, 92},
    {343, 99},
    {344, 302},
    {345, 301},
    {346, 2},
    {390, 310},
    {391, 18621},
    {392, 311},
    {393, 18620},
    {394, 18623},
    {395, 18624},
    {396, 18625},
    {397, 18626},
    {398, 18628},
    {399, 18606},
    {419, 5323},
    {420, 5367},
    {421, 5365},
    {425, 5362},
    {430, 5326},
    {431, 5325},
    {457, 14386},
    {458, 14388},
    {462, 12293},
    {463, 12291},
    {475, 11917},
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
    {536, 5896},
    {537, 5897},
    {538, 6872},
    {539, 6881},
    {540, 6837},
    {548, 5500001},
    {555, 6900},
    {556, 11936},
    {557, 5360},
    {558, 7770},
    {559, 11943}
};

new accessories_game_ids[][2] = {
    {241, 136},
    {242, 137},
    {243, 138},
    {244, 139},
    {245, 140},
    {246, 141},
    {247, 142},
    {248, 145},
    {249, 151},
    {250, 153},
    {251, 152},
    {252, 154},
    {253, 160},
    {254, 143},
    {255, 144},
    {256, 155},
    {258, 149},
    {259, 146},
    {260, 147},
    {261, 148},
    {263, 156},
    {264, 157},
    {265, 158},
    {266, 159},
    {267, 150},
    {274, 161},
    {277, 170},
    {278, 169},
    {279, 180},
    {280, 187},
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
    {295, 295},
    {296, 296},
    {297, 297},
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
    {422, 508},
    {423, 511},
    {432, 513},
    {433, 515},
    {434, 516},
    {435, 536},
    {436, 520},
    {437, 521},
    {438, 522},
    {439, 527},
    {440, 531},
    {441, 532},
    {442, 533},
    {443, 534},
    {464, 578},
    {476, 579},
    {477, 582},
    {478, 583},
    {479, 585},
    {493, 660},
    {494, 662},
    {495, 663},
    {496, 664},
    {518, 709},
    {530, 914},
    {531, 915},
    {532, 916},
    {533, 917},
    {534, 918},
    {542, 576},
    {549, 983},
    {550, 517},
    {551, 357},
    {552, 492},
    {553, 491},
    {554, 657},
    {560, 493}
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
IPacket:252(playerid, BitStream:bitstream)
{

        new data[512];
    new outcoming_data[512];
    new Node:json = JSON_Object();
    new Node:json_packet_data = JSON_Object();
    new Node:response = 0; // 0 == not created
    new header, guiid;
    BS_ReadValue(bitstream, PR_UINT8, header);
    BS_ReadValue(bitstream, PR_UINT16, guiid);

    new length, json_data[256];
    BS_ReadValue(bitstream, PR_UINT32, length);
    BS_ReadValue(bitstream, PR_STRING, json_data, length);

    new Node:JSONObject = JSON_Object();
    JSON_Parse(json_data, JSONObject);

	switch(guiid)
	{
case 27:
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new type;
    JSON_GetInt(JSONObject, "t", type);

    switch(type)
    {
        case 1:
        {
            callcmd::park(playerid, "");
            JSON_SetInt(JSONObject, "t", type);
            JSON_SetInt(JSONObject, "s", 1);
        }

        case 3:
        {
            callcmd::lock(playerid, "");
            JSON_SetInt(JSONObject, "t", type);
            JSON_SetInt(JSONObject, "s", GetVehicleParam(vehicleid, V_LOCK) ? 1 : 0);
        }

        case 6:
        {
            engineon(playerid);
            JSON_SetInt(JSONObject, "t", type);
            JSON_SetInt(JSONObject, "s", GetVehicleParam(vehicleid, V_ENGINE) ? 1 : 0);
        }

        case 14:
        {
            lightss(playerid);
            JSON_SetInt(JSONObject, "t", type);
            JSON_SetInt(JSONObject, "s", GetVehicleParam(vehicleid, V_LIGHTS) ? 1 : 0);
        }
    }

    OnPacketIncoming(playerid, 27, JSONObject);

    JSON_Cleanup(JSONObject);
    JSON_Cleanup(json);
    JSON_Cleanup(json_packet_data);
}
        case 14:
        {
            new t, i;

            JSON_GetInt(JSONObject, "t", t);
            JSON_GetInt(JSONObject, "i", i);

            switch(t)
            {
                case 0: callcmd::gps(playerid, "");
                case 1: ShowNotificationLaird(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                case 2: callcmd::mm(playerid, "");
                case 4: callcmd::inv(playerid, "");
                case 5: callcmd::anim(playerid, "");
                case 6: callcmd::donate(playerid, "");
                case 7: callcmd::car(playerid, "");
                case 8: callcmd::promo(playerid, "");
                case 9: callcmd::report(playerid, "");
                case 10, 11, 12: ShowNotificationLaird(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
            }

            new Node:json_packet_data = JSON_Object();
            JSON_SetInt(json_packet_data, "i", 1);
            OnPacketIncoming(playerid, 14, json_packet_data);
            JSON_Cleanup(json_packet_data);
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
        case 45:
        {
            new type;
            JSON_GetInt(json, "t", type);

            switch(type)
            {
                case 4, 6, 7:
                {
                    new Node:response = JSON_Object();
                    JSON_SetInt(response, "t", type);
                    JSON_SetInt(response, "s", 3);
                    JSON_SetInt(response, "g", 1);
                    OnPacketIncoming(playerid, 45, response);
                    JSON_Cleanup(response);
                }
            }
        }
        case 66:
{
    new Node:response = JSON_Object();
    new type = 0, targetid = INVALID_PLAYER_ID;

    JSON_GetInt(json, "t", type);
    JSON_GetInt(json, "id", targetid);

    switch (type)
    {
        case 2: // пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ
        {
            if (!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
            {
                JSON_SetInt(response, "error", 1);
//                break;
            }

            JSON_SetInt(response, "t", 1); // пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅ t=1
            JSON_SetString(response, "pn", GetPlayerNameEx(targetid));
            JSON_SetInt(response, "id", targetid);

            new Node:piArray = JSON_Array();

            // ---------- 1. пїЅпїЅпїЅпїЅпїЅпїЅпїЅ ----------
            new Node:levelObj = JSON_Object(
                "p", JSON_Int(1),
                "n", JSON_String("пїЅпїЅпїЅпїЅпїЅпїЅпїЅ"),
                "v", JSON_Int(GetPlayerScore(targetid))
            );
            JSON_ArrayAppend(piArray, "", levelObj);
            JSON_Cleanup(levelObj);

            // ---------- 2. пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ----------
            new Float:hp;
            GetPlayerHealth(targetid, hp);
            new Node:hpObj = JSON_Object(
                "p", JSON_Int(2),
                "n", JSON_String("пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ"),
                "v", JSON_Int(floatround(hp))
            );
            JSON_ArrayAppend(piArray, "", hpObj);
            JSON_Cleanup(hpObj);

            // ---------- 3. пїЅпїЅпїЅпїЅпїЅ ----------
            new Float:armor;
            GetPlayerArmour(targetid, armor);
            new Node:armorObj = JSON_Object(
                "p", JSON_Int(3),
                "n", JSON_String("пїЅпїЅпїЅпїЅпїЅ"),
                "v", JSON_Int(floatround(armor))
            );
            JSON_ArrayAppend(piArray, "", armorObj);
            JSON_Cleanup(armorObj);

            // ---------- 4. пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ----------
            new Float:vx, Float:vy, Float:vz;
            GetPlayerVelocity(targetid, vx, vy, vz);
            new Float:speed = floatsqroot(vx * vx + vy * vy + vz * vz) * 180.0;
            new Node:speedObj = JSON_Object(
                "p", JSON_Int(4),
                "n", JSON_String("пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ"),
                "v", JSON_Int(floatround(speed))
            );
            JSON_ArrayAppend(piArray, "", speedObj);
            JSON_Cleanup(speedObj);

            // ---------- 5. пїЅпїЅпїЅпїЅ ----------
            new Node:pingObj = JSON_Object(
                "p", JSON_Int(5),
                "n", JSON_String("пїЅпїЅпїЅпїЅ"),
                "v", JSON_Int(GetPlayerPing(targetid))
            );
            JSON_ArrayAppend(piArray, "", pingObj);
            JSON_Cleanup(pingObj);

            // ---------- 6. пїЅпїЅпїЅпїЅпїЅпїЅ ----------
            new Node:moneyObj = JSON_Object(
                "p", JSON_Int(6),
                "n", JSON_String("пїЅпїЅпїЅпїЅпїЅпїЅ"),
                "v", JSON_Int(GetPlayerMoney(targetid))
            );
            JSON_ArrayAppend(piArray, "", moneyObj);
            JSON_Cleanup(moneyObj);

            // ---------- 7. пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ----------
            new vehid = GetPlayerVehicleID(targetid);
            new Node:transportObj = JSON_Object(
                "p", JSON_Int(7),
                "n", JSON_String("пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ"),
                "v", JSON_Int((vehid > 0) ? GetVehicleModel(vehid) : 0)
            );
            JSON_ArrayAppend(piArray, "", transportObj);
            JSON_Cleanup(transportObj);

            // ---------- 8. пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ ----------
            new Float:vehhp;
            if (vehid > 0) GetVehicleHealth(vehid, vehhp);
            else vehhp = 0.0;
            new Node:tstrengthObj = JSON_Object(
                "p", JSON_Int(8),
                "n", JSON_String("пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ"),
                "v", JSON_Int(floatround(vehhp))
            );
            JSON_ArrayAppend(piArray, "", tstrengthObj);
            JSON_Cleanup(tstrengthObj);

            // пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅ
            JSON_SetArray(response, "pi", piArray);
            JSON_Cleanup(piArray);
        }
    }

    OnPacketIncoming(playerid, 66, response);
    JSON_Cleanup(response);
}        
case 28: // Где у вас обработка GUI
{
    new Node:json_packet_data = JSON_Object();
    new outcoming_data[512];

    new type, selector_id, data_value, type_of_detail, status, sound_id;
    new color[32], vinyl[32];

    JSON_GetInt(JSONObject, "t", type);
    JSON_GetInt(JSONObject, "m", selector_id);
    JSON_GetInt(JSONObject, "d", data_value);
    JSON_GetInt(JSONObject, "mt", type_of_detail);
    JSON_GetInt(JSONObject, "s", status);
    JSON_GetString(JSONObject, "co", color, sizeof(color));
    JSON_GetString(JSONObject, "v", vinyl, sizeof(vinyl));
    JSON_GetInt(JSONObject, "h", sound_id);

    printf("GUI 28: t=%d, m=%d, d=%d, mt=%d, s=%d, co=%s, v=%s, h=%d",
           type, selector_id, data_value, type_of_detail, status, color, vinyl, sound_id);

    switch (type)
    {
        case 0: // Выход
        {
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);

            switch(g_TuningType[playerid])
            {
                case 0:
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 2296.146240, -2613.668457, 21.829063);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 90.0);
                }
                case 1:
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 1742.453979, 2465.383544, 14.454860);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 285.0);
                }
            }
            
            SetPlayerInterior(playerid, 0);
            g_TuningType[playerid] = 0;

            JSON_SetInt(json_packet_data, "t", 0);
            JSON_SetInt(json_packet_data, "s", 1);
        }
        
        case 1, 2: // Цвет
        {
            new price = 10100;
            if (GetPlayerMoney(playerid) >= price)
            {
                GivePlayerMoney(playerid, -price);
                ShowNotificationLaird(playerid, 0, 6, 0, 0, "Вы потратили 10100 рублей", " ");

                new vehicleid = GetPlayerVehicleID(playerid);
                if(vehicleid != INVALID_VEHICLE_ID)
                {
                    new color1 = HexToInt(color);
                    new color2 = 0;
                    
                    ChangeVehicleColor(vehicleid, color1, color2);
                    
                    // Сохраняем в БД
                    new query[256];
                    new index = GetVehicleData(vehicleid, V_ACTION_ID);
                    new sql_id = GetOwnableCarData(index, OC_SQL_ID);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET color_1=%d, color_2=%d WHERE id=%d LIMIT 1", 
                        color1, color2, sql_id);
                    mysql_tquery(mysql, query);
                    
                    SetVehicleData(vehicleid, V_COLOR_1, color1);
                    SetVehicleData(vehicleid, V_COLOR_2, color2);
                }

                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 1);
                JSON_SetInt(json_packet_data, "m", selector_id);
                JSON_SetString(json_packet_data, "co", color);
                JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
            }
            else
            {
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 0);
                JSON_SetString(json_packet_data, "m", "Недостаточно денег!");
                JSON_SetString(json_packet_data, "n", "Ошибка покупки!");
            }
        }
        
        case 3: // Винил
        {
            new price = 50010;
            if (GetPlayerMoney(playerid) >= price)
            {
                GivePlayerMoney(playerid, -price);
                ShowNotificationLaird(playerid, 0, 6, 0, 0, "Вы потратили 50010 рублей", " ");
                
                new vehicleid = GetPlayerVehicleID(playerid);
                
                // ? ВЫЗЫВАЕМ ФУНКЦИЮ УСТАНОВКИ ВИНИЛА
                SetVehicleVinyl(vehicleid, data_value, 1);
                
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 1);
                JSON_SetInt(json_packet_data, "d", data_value);
                JSON_SetString(json_packet_data, "v", vinyl);
                JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
            }
            else
            {
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 0);
                JSON_SetString(json_packet_data, "m", "Недостаточно денег!");
                JSON_SetString(json_packet_data, "n", "Ошибка покупки!");
            }
        }
        
        case 5: // Выбор детали
        {
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "s", 1);
            JSON_SetInt(json_packet_data, "m", selector_id);
            JSON_SetInt(json_packet_data, "mt", type_of_detail);
        }
        
        case 6: // Предпросмотр детали
        {
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "s", 1);
            JSON_SetInt(json_packet_data, "p", data_value);
        }
        
        case 7, 10: // Диски
        {
            new price = 800;
            if (GetPlayerDonateRub(playerid) >= price)
            {
                GivePlayerDonateRub(playerid, -price);
                
                new vehicleid = GetPlayerVehicleID(playerid);
                
                // Устанавливаем диск
                AddVehicleComponent(vehicleid, data_value);
                
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 1);
                JSON_SetInt(json_packet_data, "d", data_value);
                JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
            }
            else
            {
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 0);
                JSON_SetString(json_packet_data, "m", "Недостаточно рублей!");
                JSON_SetString(json_packet_data, "n", "Ошибка покупки!");
            }
        }
        
        case 8: // Неон (если это неон)
        {
            new price = 600;
            if (GetPlayerDonateRub(playerid) >= price)
            {
                GivePlayerDonateRub(playerid, -price);
                
                new vehicleid = GetPlayerVehicleID(playerid);
                
                // ? ВЫЗЫВАЕМ ФУНКЦИЮ УСТАНОВКИ НЕОНА
                new neon_color = HexToInt(color);
                SetVehicleNeon(vehicleid, neon_color, neon_color, neon_color, 1);
                
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 1);
                JSON_SetInt(json_packet_data, "p", data_value);
                JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
            }
            else
            {
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 0);
                JSON_SetString(json_packet_data, "m", "Недостаточно рублей!");
                JSON_SetString(json_packet_data, "n", "Ошибка покупки!");
            }
        }
        
        case 9: // Сброс тюнинга
        {
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "s", 1);
        }
        
        case 11: // Предпросмотр компонента
        {
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "s", 1);
            JSON_SetInt(json_packet_data, "d", data_value);
        }
        
        case 12: // Тонировка
        {
            new price = 1200;
            if (GetPlayerDonateRub(playerid) >= price)
            {
                GivePlayerDonateRub(playerid, -price);
                
                new vehicleid = GetPlayerVehicleID(playerid);
                
                // ? ВЫЗЫВАЕМ ФУНКЦИЮ УСТАНОВКИ ТОНИРОВКИ
                SetVehicleTint(vehicleid, data_value, 1);
                
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 1);
                JSON_SetInt(json_packet_data, "d", data_value);
                JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
            }
            else
            {
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 0);
                JSON_SetString(json_packet_data, "m", "Недостаточно рублей!");
                JSON_SetString(json_packet_data, "n", "Ошибка покупки!");
            }
        }
        
        case 20: // Предпросмотр цвета
        {
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "m", selector_id);
            JSON_SetString(json_packet_data, "co", color);
        }
        
        case 26: // Предпросмотр винила
        {
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetString(json_packet_data, "v", vinyl);
        }
        
        case 28: // Предпросмотр компонента
        {
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "d", data_value);
        }
        
        default:
        {
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "s", 0);
            JSON_SetString(json_packet_data, "m", "Неизвестная операция!");
        }
    }

    JSON_Stringify(json_packet_data, outcoming_data);
    OnPacketIncoming(playerid, 28, json_packet_data);
    JSON_Cleanup(json_packet_data);
}
        case 38:
        {
            new t;
            JSON_GetInt(JSONObject, "t", t);

            switch(t)
            {
                case -1:
                {
                    new skin_id;
                    JSON_GetInt(JSONObject, "i", skin_id);

                    SetPlayerSkin(playerid, skin_id);
                    return 1;
                }
                case 1:
                {
                    new email[128], password[24];
                    JSON_GetString(JSONObject, "s", email);
                    JSON_GetString(JSONObject, "p", password);

                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);

                    if(strlen(email) != 0)
                    {
                        strmid(GetPlayerData(playerid, P_EMAIL), email, 0, strlen(email), 65);
                    }

                    new Node:json_packet_data = JSON_Object();
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 38, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                    return 1;
                }
                case 3:
                {
                    new gender;
                    JSON_GetInt(JSONObject, "r", gender);

                    SetPlayerData(playerid, P_SEX, gender);

                    if(CreatePlayerAccount(playerid))
                    {
                        SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);

                        SetSpawnInfo(playerid, 0, 0, 332.2033, -174.1066, 999.6743, 1.0, 0, 0, 0, 0, 0, 0);
                        //SpawnPlayer(playerid);
                    }
                    else
                    {
                        ShowNotificationLaird(playerid, 2, 5, -1, -1, "вова тест пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ!", "");
                        Kick(playerid);
                    }

                    new Node:json_packet_data = JSON_Object();
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 38, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                    return 1;
                }
                case 4:
                {
                    new invite_nick[MAX_PLAYER_NAME];
                    JSON_GetString(JSONObject, "s", invite_nick);

                    if(strlen(invite_nick) == 0)
                    {
                        new Node:json_packet_data = JSON_Object();
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 38, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return 1;
                    }

                    new query[75], Cache:result;
                    mysql_format(mysql, query, sizeof(query), "SELECT id FROM accounts WHERE name='%e' LIMIT 1", invite_nick);
                    result = mysql_query(mysql, query);

                    if(cache_num_rows())
                        SetPlayerData(playerid, P_REFER, cache_get_row_int(0, 0));
                    cache_delete(result);

                    if(!GetPlayerData(playerid, P_REFER))
                    {
                        ShowNotificationLaird(playerid, 2, 5, -1, -1, "тест вааава пїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ!", "");
                        return 1;
                    }

                    new Node:json_packet_data = JSON_Object();
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 38, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                    return 1;
                }
case 5:
{
    new final_skin;
    JSON_GetInt(JSONObject, "r", final_skin);

    SetPlayerData(playerid, P_SKIN, final_skin);

    HidePlayerSelectPanel(playerid);
    HidePlayerSelectPanelPrice(playerid);

    // бонусные деньги
    SetPlayerData(playerid, P_MONEY, bonus_money);
    UpdatePlayerDatabaseInt(playerid, "money", bonus_money);

    SetPlayerData(playerid, P_SELECT_SKIN, -1);

    // Жесткий сброс стартовых данных нового аккаунта
    SetPlayerData(playerid, P_HOUSE_TYPE, HOUSE_TYPE_NONE);
    SetPlayerData(playerid, P_HOUSE_ROOM, -1);
    SetPlayerData(playerid, P_HOUSE, -1);
    SetPlayerData(playerid, P_BUSINESS, -1);
    SetPlayerData(playerid, P_FUEL_ST, -1);
    SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
    SetPlayerData(playerid, P_RENT_BIKE, INVALID_VEHICLE_ID);

    SetPlayerData(playerid, P_QUEST_1, 0);
    SetPlayerData(playerid, P_QUEST_2, 0);
    SetPlayerData(playerid, P_QUEST_3, 0);
    SetPlayerData(playerid, P_QUEST_4, 0);
    SetPlayerData(playerid, P_QUEST_5, 0);
    SetPlayerData(playerid, P_QUEST_6, 0);
    SetPlayerData(playerid, P_QUEST_7, 0);
    SetPlayerData(playerid, P_QUEST_8, 0);

    SetPlayerData(playerid, P_QUEST_EXP_1, 0);
    SetPlayerData(playerid, P_QUEST_EXP_2, 0);
    SetPlayerData(playerid, P_QUEST_EXP_3, 0);
    SetPlayerData(playerid, P_QUEST_EXP_4, 0);
    SetPlayerData(playerid, P_QUEST_EXP_5, 0);
    SetPlayerData(playerid, P_QUEST_EXP_6, 0);
    SetPlayerData(playerid, P_QUEST_EXP_7, 0);
    SetPlayerData(playerid, P_QUEST_EXP_8, 0);

    GiveDefaultLicenses(playerid);

    // бонус донат
    new reason[144];
    format(reason, sizeof(reason), "Бонус при регистрации");
    GivePlayerDonateRub(playerid, bonus_donate, reason, true, true);

    // бонус уровень
    SetPlayerData(playerid, P_LEVEL, bonus_lvl);
    UpdatePlayerDatabaseInt(playerid, "level", bonus_lvl);

    // VIP
    SetPlayerData(playerid, P_PREMIUM, vip_type);
    SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 30 * 86400);
    UpdatePlayerDatabaseInt(playerid, "premium", vip_type);
    UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

    // сообщение о VIP
    new prem_year, prem_month, prem_day;
    timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);
    format(reason, sizeof(reason), "Вы получили VIP Gold до %02d.%02d.%d при регистрации!", prem_day, prem_month, prem_year);
    SendClientMessage(playerid, 0xFFD700FF, reason);

    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

    // Устанавливаем VW/Interior и спавним
    new spawn_random = random(4);
    SetPlayerSpawnInit(playerid);
    SpawnPlayer(playerid);
    SetPlayerPosEx(playerid, spawn_pos_data[spawn_random][0], spawn_pos_data[spawn_random][1], spawn_pos_data[spawn_random][2], spawn_pos_data[spawn_random][3], 0, 0);

    SetPlayerInit(playerid);

    SetTimerEx("UnfreezePlayerAfterRent", 5000, false, "i", playerid);

    new query[512];
    mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET skin=%d, last_login=%d, house_type=-1, house_room=-1, house=-1, business=-1, fuel_st=-1, quest_1=0, quest_2=0, quest_3=0, quest_4=0, quest_5=0, quest_6=0, quest_7=0, quest_8=0, quest_exp_1=0, quest_exp_2=0, quest_exp_3=0, quest_exp_4=0, quest_exp_5=0, quest_exp_6=0, quest_exp_7=0, quest_exp_8=0 WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);
    return 1;
}
                case 6: // Авторизация
                {
                    new password[24], hash[65], auto_login;
                    JSON_GetString(JSONObject, "s", password);
                    JSON_GetInt(JSONObject, "r", auto_login);

                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);
                    SHA256_PassHash(CheckPass[playerid], GetPlayerData(playerid, P_SALT), hash, 65);

                    printf("[DEBUG] Попытка авторизации игрока %d", playerid);

                    if(!strcmp(hash, GetPlayerData(playerid, P_PASSWORD)))
                    {
                        SetPlayerData(playerid, P_AUTH_TIME, -1); // ОБЯЗАТЕЛЬНО!
                        printf("[DEBUG] Авторизация успешна для ID:%d", playerid);
                        
                        LoadPlayerData(playerid);
                        SetPlayerLogged(playerid, true);

                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "c", 1);
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 38, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        
                        // ДОБАВЬТЕ ЭТИ СТРОКИ:
                        SetTimerEx("LoadAccessoriesAfterLogin", 2500, false, "d", playerid);
                       // printf("[DEBUG] Запланирована загрузка аксессуаров после авторизации для ID:%d", playerid);
                    }
                    else
                    {
                        printf("[ERROR] Неверный пароль для игрока %d", playerid);
                        ShowNotificationLaird(playerid, 2, 5, -1, -1, "Неверный пароль!", "");
                    }
                    return 1;
                }
            }
        }

case 50:
{
    new json = JSON_Object();
    new spawn_id;

    JSON_GetInt(json, "t", spawn_id);
    new Node:json_packet_data = JSON_Object();

    switch(spawn_id)
    {
        case 0: // ? Спавн в вокзале
        {
            SetPlayerPosEx(playerid, spawn_pos_data[0][0], spawn_pos_data[0][1], spawn_pos_data[0][2], spawn_pos_data[0][3], 0, 0);
        }

       /* case 2: // ? Спавн в фракции
        {
            new team_id = GetPlayerTeamEx(playerid);

            if(!team_id)
            {
                JSON_Cleanup(json_packet_data);
                return 1;
            }

            SetPlayerPosEx
            (
                playerid,
                GetTeamData(team_id, O_SPAWN)[0],
                GetTeamData(team_id, O_SPAWN)[1],
                GetTeamData(team_id, O_SPAWN)[2],
                GetTeamData(team_id, O_SPAWN)[3],
                GetTeamData(team_id, O_SPAWN_INT),
                GetTeamData(team_id, O_SPAWN_VW)
            );
        }

        case 4: // ? Спавн в доме
        {
            if(GetPlayerHouse(playerid, HOUSE_TYPE_HOME) == -1)
            {
                JSON_Cleanup(json_packet_data);
                return 1;
            }

            // ? Спавн в доме
            new type = GetHouseData(GetPlayerHouse(playerid, HOUSE_TYPE_HOME), H_TYPE);

            SetPlayerPosEx
            (
                playerid,
                GetHouseTypeInfo(type, HT_ENTER_POS_X),
                GetHouseTypeInfo(type, HT_ENTER_POS_Y),
                GetHouseTypeInfo(type, HT_ENTER_POS_Z),
                GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE),
                GetHouseTypeInfo(type, HT_INTERIOR),
                GetPlayerHouse(playerid, HOUSE_TYPE_HOME) + 2000
            );
        }

        case 7: // ? Спавн в семейном доме
        {
            new fam_id = GetPlayerIdFamily(playerid);

            if(fam_id == -1 || family[fam_id][family_house] == -1)
            {
                JSON_Cleanup(json_packet_data);
                return 1;
            }

            new house = GetHouseIndexBySQLID(family[fam_id][family_house]);

            if(house != -1)
            {
                // ? Спавн в семейном доме
                new type = GetHouseData(house, H_TYPE);

                SetPlayerPosEx
                (
                    playerid,
                    GetHouseTypeInfo(type, HT_ENTER_POS_X),
                    GetHouseTypeInfo(type, HT_ENTER_POS_Y),
                    GetHouseTypeInfo(type, HT_ENTER_POS_Z),
                    GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE),
                    GetHouseTypeInfo(type, HT_INTERIOR),
                    house + 2000
                );
            }

            SendClientMessage(playerid, -1, ""c_f_g"Вы появились в доме семьи");
        }*/
    }

    // ? Убираем SpawnPlayer(playerid) — он вызывает SetPlayerSpawnPos
    // SpawnPlayer(playerid);

    JSON_SetInt(json_packet_data, "c", 1);
    JSON_Stringify(json_packet_data, json_data);

    OnPacketIncoming(playerid, 50, json_packet_data);

    JSON_Cleanup(json_packet_data);
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
                        case ENTER_CONT:
                        {
                            callcmd::donate(playerid, "");
                        }
                        case OFFER_YES:
                        {
                          //  printf("DEBUG: OFFER_YES case triggered for playerid: %d", playerid);
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
                        case OFFER_UNLOCK_CAR: // ID для открытия дверей:
                        {
                            callcmd::lock(playerid, "");
                        }
                        case EXIT_HOME:
                        {
                            callcmd::exit(playerid, "");
                        }
                        case GUI_LOCK:
                        {
                            callcmd::exit(playerid, "");
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
        case 22:
        {
            new type;
            JSON_GetInt(JSONObject, "t", type);

            switch(type)
            {
                case 2:
                {
                    if(GetPlayerData(playerid, P_SALE_TIME) != 0) return 1;

                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}В разработке", "Данная система в разработке.", "Закрыть", "");

                    SetPlayerData(playerid, P_SALE_TIME, 7200);
                    UpdatePlayerDatabaseInt(playerid, "sale_time", GetPlayerData(playerid, P_SALE_TIME));

                    new Node:json_packet_data = JSON_Object();
                    JSON_SetInt(json_packet_data, "t", 2);
                    JSON_SetInt(json_packet_data, "p", GetPlayerData(playerid, P_SALE_TIME));
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 22, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                }
                case 0:
                {
                    new price, internal_id;
                    JSON_GetInt(JSONObject, "p", internal_id);
                    JSON_GetInt(JSONObject, "m", price);

                    new result = GetPlayerDonateRub(playerid) - price;

                    if(GetPlayerDonateRub(playerid) < price || result < 0)
                    {
                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 0);
                        JSON_SetInt(json_packet_data, "k", 1);
                        JSON_SetString(json_packet_data, "m", "Недостаточно DONATE для\nпокупки транспорта.");
                        JSON_SetString(json_packet_data, "n", "Пополните баланс DONATE в разделе\n{FFFF00}услуги.");
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return 1;
                    }

                    new game_id = FindGameId(internal_id, car_game_ids, sizeof(car_game_ids));
                    if(game_id != -1)
                    {
                        if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 0);
                            JSON_SetInt(json_packet_data, "k", -1);
                            JSON_SetString(json_packet_data, "m", "Ошибка");
                            JSON_SetString(json_packet_data, "n", "У вас недостаточно слотов для транспорта");
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                            return 1;
                        }

                        BuyPlayerCar(playerid, internal_id, game_id, 0);
                        GivePlayerDonateRub(playerid, -price);

                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 1);
                        JSON_SetInt(json_packet_data, "g", internal_id);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                        JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
                        JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return 1;
                    }

                    game_id = FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids));
                    if(game_id != -1)
                    {
                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 1);
                        JSON_SetInt(json_packet_data, "g", internal_id);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                        JSON_SetString(json_packet_data, "m", "Вы успешно приобрели одежду");
                        JSON_SetString(json_packet_data, "n", "Для того чтобы одеть её, используйте инвентарь (/inv)");
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);

                        GivePlayerOwnableSkin(playerid, game_id);
                        GivePlayerDonateRub(playerid, -price);
                        return 1;
                    }

                    new modelid = GetModelIdByInternalId(internal_id);
                    if(modelid != -1)
                    {
                        if(GivePlayerOwnableAccessory(playerid, modelid))
                        {
                            GivePlayerDonateRub(playerid, -price);

                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);
                            JSON_SetInt(json_packet_data, "g", internal_id);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели аксессуар!");
                            JSON_SetString(json_packet_data, "n", "Для того чтобы одеть её, используйте инвентарь (/inv)");
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                        }
                        else
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 0);
                            JSON_SetInt(json_packet_data, "k", -1);
                            JSON_SetString(json_packet_data, "m", "Ошибка");
                            JSON_SetString(json_packet_data, "n", "У вас уже есть этот аксессуар");
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                        }

                        return 1;
                    }

                    switch(internal_id)
                    {
                        case 102:
                        {
                            new Node:json_packet_data = JSON_Object();

                            if(GetPlayerDonateRub(playerid) >= 1500)
                            {
                                if(GetPlayerAdminEx(playerid) > 0)
                                {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", -1);
                                    JSON_SetString(json_packet_data, "m", "Ошибка");
                                    JSON_SetString(json_packet_data, "n", "У вас уже есть админ-права");
                                }
                                else
                                {
                                    SetPlayerData(playerid, P_ADMIN, 1);
                                    UpdatePlayerDatabaseInt(playerid, "admin", 1);
                                    AdminAuthorization(playerid);
                                    GivePlayerDonateRub(playerid, -1500, "Покупка услуги: админ-права", true);

                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 1);
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "Вы получили админ-права");
                                }
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                            }

                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                        }
                        case 103:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Вы приобрели услугу: изменить имя");
                                JSON_SetString(json_packet_data, "n", "Продолжите в диалоге:");
                                ShowPlayerChangeNameDialog(playerid);
                                GivePlayerDonateRub(playerid, -50, "Покупка услуги: смена имени", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 104:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Вы сняли предупреждения");
                                SetPlayerData(playerid, P_WARN, 0);
                                SetPlayerData(playerid, P_WARN_TIME, 0);
                                UpdatePlayerDatabaseInt(playerid, "warn", 0);
                                UpdatePlayerDatabaseInt(playerid, "warn_time", 0);
                                GivePlayerDonateRub(playerid, -100, "Покупка услуги: снятие варна", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 106:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 150)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Вы купили услугу: все лицензии");
                                SetPlayerData(playerid, P_DRIVING_LIC, 1);
                                SetPlayerData(playerid, P_WEAPON_LIC, 1);
                                UpdatePlayerDatabaseInt(playerid, "driving_lic", 1);
                                UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);
                                GivePlayerDonateRub(playerid, -150, "Покупка услуги: все лицензии", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 107:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 75)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Вы купили услугу: быстрое лечение");
                                SetPlayerData(playerid, P_HEALTH, 100);
                                SetPlayerHealthEx(playerid, 100);
                                GivePlayerDonateRub(playerid, -75, "Покупка услуги: быстрое лечение", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 108:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 5)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Вы получили +10 законопослушности");
                                AddPlayerData(playerid, P_LAW_ABIDING, +, 10);
                                UpdatePlayerDatabaseInt(playerid, "law_abiding", GetPlayerData(playerid, P_LAW_ABIDING));
                                GivePlayerDonateRub(playerid, -5, "Покупка услуги: законопослушность", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 109:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Услуга недоступна");
                                JSON_SetString(json_packet_data, "n", "Доп. слот авто в семью временно недоступен");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 111:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Вы сменили пол на противоположный");
                                SetPlayerData(playerid, P_SEX, GetPlayerData(playerid, P_SEX) ^ 1);
                                UpdatePlayerDatabaseInt(playerid, "sex", GetPlayerData(playerid, P_SEX));
                                GivePlayerDonateRub(playerid, -100, "Покупка услуги: смена пола", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 112:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 1000)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "Данная услуга недоступна!");
                                GivePlayerDonateRub(playerid, 0, "1", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 113:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Прибавлен +1 слот на транспорт");
                                AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                                UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                                GivePlayerDonateRub(playerid, -300, "Покупка услуги: слот на авто", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 114:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Услуга недоступна");
                                JSON_SetString(json_packet_data, "n", "Смена названия семьи временно недоступна");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 115:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА НЕДОСТУПНА");
                       //         SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ!");
                      //          GivePlayerDonateRub(playerid, -300, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 116:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "ДОНАТ НЕ СПИСАН");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА В РАЗРАБОТКЕ");
                       //         SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅпїЅпїЅ");
                           //     GivePlayerDonateRub(playerid, -300, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 117:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Недоступно");
                                JSON_SetString(json_packet_data, "n", "Приобретите в ЦБ");
                             //   SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ");
                        //        GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 118:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "ВЫБЕРИТЕ МУЗЫКУ НА ВХОД:");
                            //     SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
                                GivePlayerDonateRub(playerid, -50, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 119:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 5)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА НЕДОСТУПНА");
                         //       SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ-пїЅпїЅпїЅ");
                              //  GivePlayerDonateRub(playerid, -5, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅ-пїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 120:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 300)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Услуга недоступна");
                                JSON_SetString(json_packet_data, "n", "Донат не списан");
                     //           SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅ!");
                            //    GivePlayerDonateRub(playerid, -300, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 121:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТУПНО");
                      //          SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ");
                                //GivePlayerDonateRub(playerid, -50, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 122:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Прибавлен +1 слот на транспорт");
                                AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                                UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                           //     new fmt_text[200];
                            //    format(fmt_text, sizeof(fmt_text), "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ. пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ: %d", GetPlayerData(playerid, P_CAR_SLOTS));
                     //           SendClientMessage(playerid, 0x66CC00FF, fmt_text);
                                GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 123:
                        {
                            if(GetPlayerDonateRub(playerid) >= 85)
                            {
                                //callcmd::number(playerid, "");
                            }
                            else
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                            }
                        }
                        case 124:
                        {
                            if(GetPlayerDonateRub(playerid) >= 70)
                            {
                                callcmd::buyphonenum(playerid, "");
                            }
                            else
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                            }
                        }
                                                case 125, 126, 127, 128, 129, 130, 131, 132, 133, 134, 135, 136, 137, 138, 139, 184, 186, 188, 190, 192, 194:
                        {
                            new vip_type = 0, vip_days = 0;

                            switch(internal_id)
                            {
                                case 125: { vip_type = 1; vip_days = 3; }
                                case 126: { vip_type = 2; vip_days = 3; }
                                case 127: { vip_type = 3; vip_days = 3; }
                                case 128: { vip_type = 1; vip_days = 3; }
                                case 129: { vip_type = 1; vip_days = 7; }
                                case 130: { vip_type = 1; vip_days = 15; }
                                case 131: { vip_type = 1; vip_days = 30; }
                                case 132: { vip_type = 2; vip_days = 3; }
                                case 133: { vip_type = 2; vip_days = 7; }
                                case 134: { vip_type = 2; vip_days = 15; }
                                case 135: { vip_type = 2; vip_days = 30; }
                                case 136: { vip_type = 3; vip_days = 3; }
                                case 137: { vip_type = 3; vip_days = 7; }
                                case 138: { vip_type = 3; vip_days = 15; }
                                case 139: { vip_type = 3; vip_days = 30; }
                                case 184: { vip_type = 1; vip_days = 1; }
                                case 186: { vip_type = 1; vip_days = 2; }
                                case 188: { vip_type = 1; vip_days = 3; }
                                case 190: { vip_type = 2; vip_days = 3; }
                                case 192: { vip_type = 3; vip_days = 3; }
                                case 194: { vip_type = 3; vip_days = 5; }
                            }
                            if(!vip_type || !vip_days)
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", -1);
                                JSON_SetString(json_packet_data, "m", "Ошибка");
                                JSON_SetString(json_packet_data, "n", "Неизвестный тип VIP");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return 1;
                            }
                            if(GetPlayerData(playerid, P_PREMIUM) < vip_type)
                                SetPlayerData(playerid, P_PREMIUM, vip_type);

                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + vip_days * 86400);
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, vip_days * 86400);

                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

                            if(price > 0)
                                GivePlayerDonateRub(playerid, -price, "Покупка VIP статуса", true);

                            new prem_year, prem_month, prem_day;
                            new vip_name[16];
                            switch(vip_type)
                            {
                                case 1: format(vip_name, sizeof(vip_name), "Silver");
                                case 2: format(vip_name, sizeof(vip_name), "Gold");
                                case 3: format(vip_name, sizeof(vip_name), "Platinum");
                                default: format(vip_name, sizeof(vip_name), "VIP");
                            }

                            timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);

                            new info_text[128];
                            format(info_text, sizeof(info_text), "VIP %s активирован до %02d.%02d.%d", vip_name, prem_day, prem_month, prem_year);

                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);
                            JSON_SetInt(json_packet_data, "g", internal_id);
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                            JSON_SetString(json_packet_data, "m", "Успешная операция");
                            JSON_SetString(json_packet_data, "n", info_text);
                            JSON_Stringify(json_packet_data, json_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                        }
                        case 179:
                        {
                            BuyPlayerCar(playerid, 12, 585, 0);
                            BuyPlayerSkin(playerid, 180, 30);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Сельчанин", price, internal_id);
                        }
                        case 181:
                        {
                            BuyPlayerCar(playerid, 22, 419, 0);
                            BuyPlayerSkin(playerid, 182, 60);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Бандит", price, internal_id);
                        }
                        case 183:
                        {
                            BuyPlayerCar(playerid, 23, 562, 0);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);
                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 86400);
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Молодой", price, internal_id);
                        }
                        case 185:
                        {
                            BuyPlayerCar(playerid, 28, 527, 0);
                            AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                            UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                            SetPlayerData(playerid, P_PREMIUM, 1);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 2));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 2));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Гангстер", price, internal_id);
                        }
                        case 187:
                        {
                            BuyPlayerCar(playerid, 78, 461, 0);
                            AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                            UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                            if(GetPlayerData(playerid, P_PREMIUM) < 1)
                                SetPlayerData(playerid, P_PREMIUM, 1);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Гонщик", price, internal_id);
                        }
                        case 189:
                        {
                            BuyPlayerCar(playerid, 34, 560, 0);
                            AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                            UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                            if(GetPlayerData(playerid, P_PREMIUM) < 2)
                                SetPlayerData(playerid, P_PREMIUM, 2);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Депутат", price, internal_id);
                        }
                        case 191:
                        {
                            BuyPlayerCar(playerid, 52, 2547, 0);
                            AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                            UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                            if(GetPlayerData(playerid, P_PREMIUM) < 3)
                                SetPlayerData(playerid, P_PREMIUM, 3);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Мафиози", price, internal_id);
                        }
                        case 193:
                        {
                            BuyPlayerCar(playerid, 64, 2546, 0);
                            AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                            UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                            if(GetPlayerData(playerid, P_PREMIUM) < 3)
                                SetPlayerData(playerid, P_PREMIUM, 3);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 5));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 5));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Мажор", price, internal_id);
                        }
                        case 262:
                        {
                            BuyPlayerSkin(playerid, 237, 266);
                            GivePlayerOwnableAccessory(playerid, 136);
                            if(GetPlayerData(playerid, P_PREMIUM) < 2)
                                SetPlayerData(playerid, P_PREMIUM, 2);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Кости", price, internal_id);
                        }
                        case 268:
                        {
                            BuyPlayerSkin(playerid, 228, 269);
                            GivePlayerOwnableAccessory(playerid, 149);
                            if(GetPlayerData(playerid, P_PREMIUM) < 2)
                                SetPlayerData(playerid, P_PREMIUM, 2);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Красавчик", price, internal_id);
                        }
                        case 270:
                        {
                            BuyPlayerSkin(playerid, 229, 231);
                            GivePlayerOwnableAccessory(playerid, 150);
                            if(GetPlayerData(playerid, P_PREMIUM) < 2)
                                SetPlayerData(playerid, P_PREMIUM, 2);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Ведьма", price, internal_id);
                        }
                        case 271:
                        {
                            BuyPlayerSkin(playerid, 229, 231);
                            GivePlayerOwnableAccessory(playerid, 145);
                            if(GetPlayerData(playerid, P_PREMIUM) < 2)
                                SetPlayerData(playerid, P_PREMIUM, 2);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Улыбка зла", price, internal_id);
                        }
                        case 272:
                        {
                            BuyPlayerSkin(playerid, 231, 208);
                            GivePlayerOwnableAccessory(playerid, 145);
                            if(GetPlayerData(playerid, P_PREMIUM) < 2)
                                SetPlayerData(playerid, P_PREMIUM, 2);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Страшила", price, internal_id);
                        }
                        case 273:
                        {
                            BuyPlayerSkin(playerid, 230, 175);
                            GivePlayerOwnableAccessory(playerid, 144);
                            if(GetPlayerData(playerid, P_PREMIUM) < 2)
                                SetPlayerData(playerid, P_PREMIUM, 2);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Смерть с косой", price, internal_id);
                        }
                        case 541:
                        {
                            BuyPlayerSkin(playerid, 508, 2393);
                            BuyPlayerSkin(playerid, 539, 6881);
                            BuyPlayerSkin(playerid, 540, 6837);
                            if(GetPlayerData(playerid, P_PREMIUM) < 3)
                                SetPlayerData(playerid, P_PREMIUM, 3);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                            UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "BLACK RUSSIAN", price, internal_id);
                        }
                        case 269:
                        {
                            BuyPlayerSkin(playerid, 227, 232);
                            GivePlayerOwnableAccessory(playerid, 136);
                            if(GetPlayerData(playerid, P_PREMIUM) < 2)
                                SetPlayerData(playerid, P_PREMIUM, 2);
                            if(GetPlayerData(playerid, P_PREMIUM_DATE) < gettime())
                                SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));
                            else
                                AddPlayerData(playerid, P_PREMIUM_DATE, +, (86400 * 3));
                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerData(playerid, P_PREMIUM));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Красотка", price, internal_id);
                        }
                        case 176:
                        {
                            GivePlayerMoneyEx(playerid, 500000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Бродяга", price, internal_id);
                        }
                        case 177:
                        {
                            GivePlayerMoneyEx(playerid, 1000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Всё впереди", price, internal_id);
                        }
                        case 178:
                        {
                            GivePlayerMoneyEx(playerid, 10000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Зажиточный", price, internal_id);
                        }
                    }
                }
            }
        }
    }
    JSON_Cleanup(JSONObject);
    return 1;
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
    SetOwnableCarData(free_car_id, OC_COLOR_2, 0);
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
        GetPlayerAccountID(playerid), game_id, color, 0, pos_x, pos_y, pos_z, angle, gettime());
    mysql_query(mysql, database_query, true);

    for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
    {
        if(g_player_added_promotions_data[playerid][i][0] == internal_id)
        {
            g_player_added_promotions_data[playerid][i][0] = -1;
        }
    }
}

// public BuyPlayerSkin(playerid, internal_id, game_id)
// {
//     //SetPlayerData(playerid, P_SKIN, game_id); // Сохраняем в данные игрока
//     SetPlayerSkin(playerid, game_id); // Надеваем скин на клиента

//     // Сохраняем скин в базу данных
//     new query[256];
//     format(query, sizeof query, "UPDATE accounts SET skin = %d WHERE id = %d", game_id, GetPlayerAccountID(playerid));
//     mysql_query(mysql, query, false);
// }

public ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:json_packet_data = JSON_Object(), json_data[512];
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Покупка набора");
    JSON_SetString(json_packet_data, "n", pack_name);
    JSON_Stringify(json_packet_data, json_data);
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
}

// CMD:testuved(playerid)
// {
//  ShowNotificationLaird(playerid, OFFER_ENGINE, 6, 0, 0, "Взаимодействие", "");
//  return 1;
// } 
// public BuyPlayerSkin(playerid, internal_id, game_id)
// {
//     GivePlayerOwnableSkin(playerid, game_id);
// }
public BuyPlayerSkin(playerid, internal_id, game_id)
{
    GivePlayerOwnableSkin(playerid, game_id);
}
// public: ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
// {
//     new Node:json_packet_data = JSON_Object(), json_data[512];

//     JSON_SetInt(json_packet_data, "t", 0);
//     JSON_SetInt(json_packet_data, "y", 1);

//     JSON_SetInt(json_packet_data, "g", internal_id);

//     JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
//     JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

//     JSON_SetString(json_packet_data, "m", "Вы успешно приобрели набор -");
//     JSON_SetString(json_packet_data, "n", pack_name);

//     JSON_Stringify(json_packet_data, json_data);
//     OnPacketIncoming(playerid, 22, json_packet_data);

//     JSON_Cleanup(json_packet_data);
// }
stock ShowPlayerGUI(playerid, guiid, Node:json)
{
	JSON_SetInt(json, "o", 1);
	OnPacketIncoming(playerid, guiid, json);
}

stock OnPacketIncoming(playerid, guiid, Node:json) // LAIRDDDDDDDDDDDDDDDDDDDDDD
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 252);

	BS_WriteValue(bitstream, PR_UINT16, guiid);

	new data[1024]; //4294967295
    JSON_Stringify(json, data);

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
            return accessories_game_ids[i][1]; // Возвращаем modelId
        }
    }
    return -1;
}




