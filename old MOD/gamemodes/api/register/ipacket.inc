#include "../gamemodes/api/notification.inc"

new bool:VehicleDriftActive[MAX_VEHICLES];
new bool:VehicleComfortActive[MAX_VEHICLES];
new bool:VehicleSportActive[MAX_VEHICLES];
new bool:VehicleSportPlusActive[MAX_VEHICLES];




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
    {484, 434}
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
    {210, 122}
};



// CMD:bitsteam_info(playerid)
// {
//     new string[256];
//     format(string, sizeof(string), "1. data_len: %d\n2. len_bitstream: %d\n3. min_bitstream: %d\ndata -> %d\n rpcID: %d", data_len, len_bitstream, min_bitstream, data, rpcid);
//     // strcat(string, "")
//     ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Статистика BitStream", string, "ОК", "");
//     return 1;
// }


public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{ 
    new action, bits, string[512];
    BS_ReadUint8(bs, action);

    new PACKET_NEW, PACKET_NEW2, PACKET_NEW3;
    BS_ReadValue(bs, PR_UINT8, PACKET_NEW); 
    BS_ReadValue(bs, PR_UINT8, PACKET_NEW2); 
    BS_ReadValue(bs, PR_UINT16, PACKET_NEW3); 
    printf("arg8 -> %d || arg8 -> %d arg16 -> %d ", PACKET_NEW, PACKET_NEW2, PACKET_NEW3);
   

    printf("-=-=OnIncomingRPC-=- =-=-==-=-=-=\n");
    printf("Packet Logger\n");
    printf("====> RPCid: %d", rpcid);
    printf("====> Action: %d", action);
    printf("====> PACKET_NEW: %d", PACKET_NEW);
    printf("====> PACKET_NEW2: %d", PACKET_NEW2);
    printf("====> PACKET_NEW3: %d", PACKET_NEW3);
    printf("====> PlayerID: %d", playerid);
    printf("Packet Logger\n");
    printf("-=-=OnIncomingRPC-=-=-=-==-=-=-=\n");

    new Node:json = JSON_Object();
    // JSON_Parse(string, json);
   
   


    switch(rpcid)
    {
        
       
        case 200: 
        {
            printf("rpcid: %d", rpcid); 

        }
        case 62:
        {
            switch(action) 
            {
                case 129: 
                {
                    // BS_Delete(bs); 
                    print("хуета");
                    // BS_IgnoreBits(bs, action);
                    
                }
                
                default: 
                {
                    printf("action: %d", action);
                }
            }
        }
        case 97:
        {
            switch(action) 
            {
                case 4: callcmd::radial(playerid); 
            }
        }
    }
    new bits_all;
    BS_GetNumberOfBitsUsed(bs, bits); 
    BS_GetNumberOfBitsAllocated(bs, bits_all); 

    if(bits >= bits_all)
    {
        printf("bits (%d) -> action:%d reset!", bits, bits_all);
        return 1;
    }
    printf("(action) %d -> (max_len:%d)", action, bits_all);
    printf("OnIncomingRPC -> RPC: %d action:%d tempik:%d ", rpcid, action, bits_all);
    return 1;
}

// форумула расчета количество бит мы делим на 32 и получаем количество ячеек в Pawn 

// 256:32 = 





// 256
// 32
// =
// 8
//  ячеек




public: FindGameId(internalId, array[][], array_size) {
    for (new i = 0; i < array_size; i++) {
        if (array[i][0] == internalId) {
            return array[i][1];
        }
    }
    return -1;
}

public: BuyPlayerCar(playerid, internal_id, game_id, color)
{
    if(game_id == -1)
    {
        return;
    }

    new free_car_id = GetFreeOwnableCarID();

    new Float: pos_x = 2498.205810;
    new Float: pos_y = -742.256042;
    new Float: pos_z = 12.164166;
    new Float: angle = 356.240051;

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
    
    format(database_query, sizeof database_query, "INSERT INTO ownable_cars (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')", GetPlayerAccountID(playerid), game_id, color, 0, pos_x, pos_y, pos_z, angle, gettime());
    mysql_query(mysql, database_query, true);

    for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
    {
        if(g_player_added_promotions_data[playerid][i][0] == internal_id)
        {
            g_player_added_promotions_data[playerid][i][0] = -1;
        }
    }
}

public: BuyPlayerSkin(playerid, internal_id, game_id)
{
    /*SetPlayerData(playerid, P_SKIN, game_id);
    UpdatePlayerDatabaseInt(playerid, "skin", game_id);
    SetPlayerSkin(playerid, game_id);
    SetPlayerSkinInit(playerid);*/
    GivePlayerOwnableSkin(playerid, game_id);
}

public: ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:json_packet_data = JSON_Object(), outcoming_data[250+50];

    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    JSON_SetInt(json_packet_data, "g", internal_id);

    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели набор -");
    JSON_SetString(json_packet_data, "n", pack_name);

    JSON_Stringify(json_packet_data, outcoming_data);
    OnPacketIncoming251(playerid, 22, outcoming_data);

    JSON_Cleanup(json_packet_data);
}

stock checkplayerinveh(playerid)
{
if(IsPlayerInAnyVehicle(playerid))
{
callcmd::radial(playerid, "");
}
}

stock PlayAudioStreamURL(playerid, const url[])
{
    new BitStream:bs = BS_New();
    new len = strlen(url);

    BS_WriteValue(bs, PR_UINT32, 1);
    BS_WriteValue(bs, PR_UINT8, len);
    BS_WriteValue(bs, PR_STRING, url);
    BS_WriteValue(bs, PR_UINT32, 0); //TEST
    BS_WriteValue(bs, PR_FLOAT, 1.0);
    BS_WriteValue(bs, PR_UINT8, 0);

    PR_SendRPC(bs, playerid, 41, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}


CMD:settings_game(playerid)
{
    new Node:Json = JSON_Object();
    JSON_SetInt(Json, "w", 0);  //вода
    JSON_SetInt(Json, "d", 1); //отражение
    JSON_SetInt(Json, "s", 1); //дальность прорисовки
    JSON_SetInt(Json, "a", 1); //xz
    JSON_SetInt(Json, "l", 1); //xz
    JSON_SetInt(Json, "z", 2); //zalupa
    ShowPlayerGUI(playerid, 19, Json); //# я не нуб все понял


    //0




    // ..JSONObject jSONObject = new JSONObject();
    //                 jSONObject.put("w", seekBar.getProgress());
    //                 jSONObject.put(TuningConstants.KEY_GET_OLD_INSTALL_DETAIL, seekBar2.getProgress());
    //                 jSONObject.put("d", seekBar3.getProgress());
    //                 int i = 1;
    //                 jSONObject.put("s", r7.isChecked() ? 1 : 0);
    //                 jSONObject.put("a", r12.isChecked() ? 1 : 0);
    //                 jSONObject.put("l", r13.isChecked() ? 1 : 0);
    //                 if (!r15.isChecked()) {
    //                     i = 0;
    //                 }
    //                 jSONObject.put("z", i);



    //  seekBar2.setProgress(optInt);
        // seekBar.setProgress(optInt2);
        // seekBar3.setProgress(optInt7);



    // //  int optInt = json.optInt("carrefl");
    //     int optInt2 = json.optInt("water");
    //     int optInt3 = json.optInt("sky");
    //     int optInt4 = json.optInt("aa");
    //     int optInt5 = json.optInt("lowerdd");
    //     int optInt6 = json.optInt("lowercars");
    //     int optInt7 = json.optInt("drawdist");


    //  jSONObject.put("w", seekBar.getProgress());
    //                 jSONObject.put(TuningConstants.KEY_GET_OLD_INSTALL_DETAIL, seekBar2.getProgress());
    //                 jSONObject.put("d", seekBar3.getProgress());
    //                 int i = 1;
    //                 jSONObject.put("s", r7.isChecked() ? 1 : 0);
    //                 jSONObject.put("a", r12.isChecked() ? 1 : 0);
    //                 jSONObject.put("l", r13.isChecked() ? 1 : 0);


    // final TextView textView = (TextView) this.mView.findViewById(R.id.water_text);
        // final TextView textView2 = (TextView) this.mView.findViewById(R.id.carrefl_text);
        // final TextView textView3 = (TextView) this.mView.findViewById(R.id.distance_text);
        // final SeekBar seekBar = (SeekBar) this.mView.findViewById(R.id.water_progress);
        // final SeekBar seekBar2 = (SeekBar) this.mView.findViewById(R.id.carrefl_progress);
        // final SeekBar seekBar3 = (SeekBar) this.mView.findViewById(R.id.distance_progress);



        //  final Switch r7 = (Switch) this.mView.findViewById(R.id.switch_sky);
        // r7.setChecked(optInt3 == 1);
        // final Switch r12 = (Switch) this.mView.findViewById(R.id.switch_aa);
        // r12.setChecked(optInt4 == 1);
        // final Switch r13 = (Switch) this.mView.findViewById(R.id.switch_lower_dd);
        // r13.setChecked(optInt5 == 1);
        // final Switch r15 = (Switch) this.mView.findViewById(R.id.switch_lower_cars);
        // r15.setChecked(optInt6 == 1);


        //   r7.setChecked(optInt3 == 1);
        // final Switch r12 = (Switch) this.mView.findViewById(R.id.switch_aa);
        // r12.setChecked(optInt4 == 1);
        // final Switch r13 = (Switch) this.mView.findViewById(R.id.switch_lower_dd);
        // r13.setChecked(optInt5 == 1);
        // final Switch r15 = (Switch) this.mView.findViewById(R.id.switch_lower_cars);
        // r15.setChecked(optInt6 == 1);




    
   
   
    // new hueta[60];
    // new Node:json = JSON_Object();
    // JSON_SetString(json, "s", "Тестовая хуета"); 
    // ShowPlayerGUI(playerid, 51, json);
    // // OnPacketIncoming251(playerid, 51, json);
    // JSON_Cleanup(json);

    // JSON_Stringify()


    //51


}

CMD:hueta(playerid)
{
    new Node:Json = JSON_Object();
    JSON_SetInt(Json,"t", 1);
    JSON_SetInt(Json,"nu", 1);
    JSON_SetInt(Json,"b", 1);
    JSON_SetInt(Json,"s", 1);
    JSON_SetInt(Json,"a", 1);
    JSON_SetInt(Json,"e", 1);
    JSON_SetString(Json, "n", "Test");
    ShowPlayerGUI(playerid, 9, Json);
    return 1;
    // int i5 = json.getInt("nu");
    //             int i6 = json.getInt(TuningConstants.KEY_GET_ID_DETAIL);
    //             byte b3 = (byte) json.getInt("b");
    //             boolean z3 = json.getInt("s") != 0;
    //             byte b4 = (byte) json.getInt("a");
    //             boolean z4 = json.getInt("e") != 0;
    //             String string2 = json.getString("n");

}

CMD:hueta1(playerid)
{
    new Node:Json = JSON_Object();
    JSON_SetInt(Json,"ti", 1);
    JSON_SetInt(Json,"t", 0);
    JSON_SetInt(Json, "cl", 1);
    JSON_SetInt(Json, "b", 1); //1 
    JSON_SetInt(Json, "e", 1); //1
    JSON_SetInt(Json, "ne", 1);
    JSON_SetInt(Json, "g", 1);


    // JSON_SetString(Json, "m", "Успешная операция");
    ShowPlayerGUI(playerid, 15, Json);

    return 1;
}


new type[5] = {5,10,15,20,25};


CMD:test_fuel(playerid)
{
    
    new Node:Json = JSON_Object();
    JSON_SetInt(Json, "m", 5);
    JSON_SetString(Json, "h", "Fuel 100L");
    JSON_SetInt(Json, "t", 2);

    
    JSON_SetArray(Json, "ma", JSON_Array());

    for(new i = 0; i < 5; i++)
    {
        JSON_ArrayAppend(Json, "ma", JSON_Int(type[i]));
    }
    ShowPlayerGUI(playerid, 2, Json);
    new buffer[256];
    JSON_Stringify(Json, buffer, sizeof buffer, true);
    printf("[DEBUG JSON] %s", buffer);
    JSON_Cleanup(Json);
   
    return 1;
}

/*

Integer[] numArr = this.arrayForInventory;
        numArr[0] = Integer.valueOf(this.playersId);
        numArr[1] = Integer.valueOf(this.playersLevel);
        numArr[2] = Integer.valueOf(this.typeVIP);
        numArr[3] = Integer.valueOf(this.valueDinner);
        numArr[4] = Integer.valueOf(this.thisWeight);
        numArr[5] = Integer.valueOf(this.maxWeight);
        numArr[6] = Integer.valueOf(this.activeSlotsInInventory);
        numArr[7] = Integer.valueOf(this.ifHaveSimCard);
        numArr[8] = Integer.valueOf(this.maxSlotsInInventory);
*/

// CMD:test_clone(playerid)
// {
//     new Node:Json = JSON_Object();
//     new diner = 3;
//     JSON_SetInt(Json, "tb", 2);
//     JSON_SetInt(Json, "i", GetPlayerAccountID(playerid));
//     JSON_SetString(Json, "n", GetPlayerNameEx(playerid));
//     JSON_SetInt(Json, "w", 25);
//     JSON_SetInt(Json, "s", 3);
//     JSON_SetInt(Json, "v", 1);
//     JSON_SetInt(Json, "m", diner);

//     JSON_SetArray(Json, "it", JSON_Array());
//     for(new i = 0; i < 5; i++)
//     {
//         JSON_ArrayAppend(Json, "it", JSON_Int(i+1));
//     }
//     return 1;
// }



    //.typeVIP = jSONObject.optInt("v");

//     playersId
// playersItems
// playersLevel
// playersMoney
// playersNick
// playersSkin
// simCard
// maxSlotsInInventory
// maxWeight
// thisWeight
// typeInterface
// typeVIP
// valueDinner




    // JSON_SetArray(Json, "it", JSON_Array());


    //  this.playersLevel = jSONObject.optInt(GetKeys.GET_PLAYERS_LEVEL);
    //     this.playersId = jSONObject.optInt(GetKeys.GET_PLAYERS_ID);
    //     this.thisWeight = jSONObject.optInt("w");
    //     this.maxWeight = jSONObject.optInt(GetKeys.GET_MAX_WEIGHT);
    //     this.valueDinner = jSONObject.optInt("s");
    //     this.typeVIP = jSONObject.optInt("v");

    //  String optString = jSONObject.optString("n");









// CMD:test_fuel(playerid) //умная хуйня
// {
//     //
//     new Node:arr = JSON_Array(
//         JSON_Int(5),
//         JSON_Int(10)
//     );

    
//     new Node:Json = JSON_Object(
//         "m", JSON_Int(5),
//         "ma", arr,
//         "h", JSON_String("100L"),
//         "t", JSON_Int(2)
//     );

    
//     new buffer[512];
//     JSON_Stringify(Json, buffer, sizeof buffer, true);
//     printf("[DEBUG JSON] %s", buffer);

//     // отправляем клиенту
//     ShowPlayerGUI(playerid, 2, Json);
// }



// Test:JsonArrayAppend() {
//     new Node:arr = JSON_Array(
//         JSON_Int(1),
//         JSON_Int(2)
//     );

//     new Node:a = JSON_Object(
//         "key1", arr
//     );

//     new ret = JSON_ArrayAppend(a, "key1", JSON_Int(3));
//     ASSERT_EQ(ret, 0);

//     new buf[128];
//     ret = JSON_Stringify(a, buf);
//     ASSERT_EQ(ret, 0);
//     ASSERT(!strcmp(buf, "{\"key1\":[1,2,3]}"));
//     print(buf);



// this.mMaxFuel = json.getInt("m");
//             this.mPrices = new int[json.getJSONArray("ma").length()];
//             this.mInitialHint = json.getString("h");
//             for (int i = 0; i < json.getJSONArray("ma").length(); i++) {
//                 this.mPrices[i] = json.getJSONArray("ma").getInt(i);

// his.mTime = json.getInt("ti");
//             this.mEx = json.getInt("e");
//             this.mNextEx = json.getInt("ne");
//             this.mGratuity = json.getInt("g");
//             this.mNextGratuity = json.getInt("ng");
//             this.mDrawBank = json.getInt("b");


// jSONObject.put("t", 0);
//                         jSONObject.put("cl", BrDialogDance.this.mClosedByTimer ? 1 : 0);
//                         jSONObject.put("b", BrDialogDance.this.mBank);
//                         jSONObject.put("e", BrDialogDance.this.mEx);

// // int i5 = json.getInt("nu");
//                 int i6 = json.getInt(TuningConstants.KEY_GET_ID_DETAIL);
//                 byte b3 = (byte) json.getInt("b");
//                 boolean z3 = json.getInt("s") != 0;
//                 byte b4 = (byte) json.getInt("a");
//                 boolean z4 = json.getInt("e") != 0;
//                 String string2 = json.getString("n");
//                 String[] strArr2 = new String[i5];
//                 int[] iArr = new int[i5];
//                 for (int i7 = 0; i7 < i5; i7++) {
//                     strArr2[i7] = json.getString("m" + i7);
//                 }
//                 for (int i8 = 0; i8 < i5; i8++) {
//                     iArr[i8] = json.getInt(TuningConstants.KEY_GET_OLD_INSTALL_DETAIL + i8);
//                 }


// int i5 = json.getInt("nu");
//                 int i6 = json.getInt(TuningConstants.KEY_GET_ID_DETAIL);
//                 byte b3 = (byte) json.getInt("b");
//                 boolean z3 = json.getInt("s") != 0;
//                 byte b4 = (byte) json.getInt("a");
//                 boolean z4 = json.getInt("e") != 0;
//                 String string2 = json.getString("n");

stock StopAudioStreamURL(playerid)
{
    new BitStream:bs = BS_New();

    BS_WriteValue(bs, PR_UINT32, 1);    //test
    BS_WriteValue(bs, PR_UINT8, 0);   
    BS_WriteValue(bs, PR_UINT32, 0);    
    BS_WriteValue(bs, PR_FLOAT, 0.0);  
    BS_WriteValue(bs, PR_UINT8, 1);   

    PR_SendRPC(bs, playerid, 41, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

CMD:stopaudio(playerid, params[])
{
    StopAudioStreamURL(playerid);
	SendClientMessage(playerid, 0xFF0000FF, "музыка остановлена");
}

CMD:playaudio(playerid, params[])
{
    PlayAudioStreamURL(playerid, "https://sile-files.online/music.mp3");
    SendClientMessage(playerid, 0x00FF00FF, "проигрывается музыка");
}




// какая-то станция 9 ID 
