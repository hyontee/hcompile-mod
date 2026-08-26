#define QUEST 8
#define OFFER_ENGINE 11
// #define INKO 12

#define MAX_PLAYER_SKINS 8
new bonuska = 80000000; // bonus
new driftenable[400];
#define DOOR_HOUSE 28



// АКСЫ НАХУЙ НЕВ ДВИЖОК ГУИ ДОНАТ by vit4lka @libvit4lka //

new accessories_game_ids[][2] = {
    {549, 116},
    {534, 117},
    {533, 118},
    {530, 119},
    {531, 120},
    {532, 121},
    {518, 122},
    {493, 109},
    {494, 123},
    {495, 111},
    {496, 112},
    {476, 113},
    {477, 124},
    {478, 114},
    {479, 125},
    {542, 126},
    {464, 127},
    {432, 115},
    {433, 128},
    {434, 129},
    {436, 130},
    {437, 131},
    {438, 132},
    {439, 133},
    {440, 134},
    {441, 135},
    {442, 136},
    {443, 137},
    {435, 138},
    {422, 139},
    {423, 13 },
    {368, 140},
    {369, 141},
    {370, 142},
    {371, 143},
    {372, 144},
    {373, 145},
    {374, 146},
    {375, 147},
    {376, 148},
    {377, 149},
    {378, 150},
    {379, 151},
    {380, 152},
    {381, 153},
    {382, 154},
    {383, 155},
    {384, 156},
    {385, 157},
    {386, 158},
    {387, 159},
    {388, 160},
    {389, 161},
    {354, 162},
    {355, 163},
    {356, 164},
    {357, 165},
    {358, 166},
    {359, 167},
    {360, 168},
    {361, 169},
    {362, 170},
    {363, 171},
    {364, 172},
    {365, 173},
    {277, 174},
    {278, 175},
    {279, 176},
    {280, 177},
    {295, 178},
    {296, 179},
    {297, 180},
    {281, 181},
    {282, 182},
    {283, 183},
    {284, 184},
    {285, 185},
    {286, 186},
    {287, 187},
    {288, 188},
    {289, 189},
    {290, 190},
    {291, 191},
    {292, 54 },
    {293, 192},
    {294, 193},
    {298, 56 },
    {299, 57 },
    {300, 58 },
    {301, 59 },
    {302, 60 },
    {303, 61 },
    {304, 64 },
    {305, 67 },
    {306, 68 },
    {307, 194},
    {308, 195},
    {309, 196},
    {310, 197},
    {243, 18 },
    {244, 19 },
    {245, 20 },
    {246, 21 },
    {241, 16 },
    {242, 17 },
    {274, 198},
    {247, 22 },
    {248, 25 },
    {249, 32 },
    {250, 199},
    {251, 33 },
    {252, 200},
    {254, 23 },
    {255, 24 },
    {256, 30 },
    {253, 201},
    {258, 202},
    {259, 26 },
    {260, 27 },
    {261, 28 },
    {263, 203},
    {264, 204},
    {265, 205},
    {266, 31 },
    {267, 29 }
};

// АКСЫ БАЙ ВИТОЛЕК НЕВ ДВЕЖАК //


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
    {210, 122},
    {548, 5500001},
    {535, 6871},
    {529, 6894},
    {527, 6892},
    {528, 6895},
    {526, 6896},
    {525, 6893},
    {519, 6832},
    {513, 19262},
    {514, 19273},
    {515, 6780},
    {516, 11961},
    {517, 11962},
    {486, 11956},
    {487, 11958},
    {488, 11953},
    {489, 11948},
    {490, 11951},
    {491, 11947},
    {492, 11957},
    {497, 11959},
    {480, 11934},
    {481, 11933},
    {482, 11935},
    {483, 11944}
};

IPacket:251(playerid, BitStream:bs)
{
    new 
        header, 
        guiid,
        data_len,
        data[512],
        outcoming_data[512],
        Node:json = JSON_Object(),
        Node:json_packet_data = JSON_Object();

    BS_ReadValue(bs, PR_UINT8, header);
    BS_ReadValue(bs, PR_UINT8, guiid);

    BS_ReadValue(bs, PR_UINT16, data_len);
    BS_ReadValue(bs, PR_STRING, data, data_len);

    JSON_Parse(data, json);

    switch(guiid)
    {
        case 3:
        {
            new query[220];
            new actionType, orderMask;

            JSON_GetInt(json, "t", actionType);
            JSON_GetInt(json, "r", orderMask);

            if(actionType == 1 && orderMask > 0)
            {
                new totalCost = CalculateTotalCost(orderMask);

                if(GetPlayerMoney(playerid) >= totalCost)
                {
                    new str[128];
                    format(str, sizeof(str), "Вы потратили %dp! Приятного аппетита!", totalCost);
                    ShowNewNotification(playerid, 2, 5, 1, 1, str, "");

                    GivePlayerMoneyEx(playerid, -totalCost, "Покупка еды в ларьке", false, false);

                    golod[playerid] += 20;
                    if(golod[playerid] > 100) golod[playerid] = 100;
                    UpdatePlayerDatabaseInt(playerid, "golod", golod[playerid]);

                    new businessid = GetPlayerInBiz(playerid), take_prods = random(4) + 6;
                    if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                    {
                        format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+totalCost, GetBusinessData(businessid, B_SQL_ID));
                        mysql_query(mysql, query, false);
                    }

                    if(!mysql_errno())
                    {
                        if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                        {
                            AddBusinessData(businessid, B_PRODS, -, take_prods);
                            AddBusinessData(businessid, B_BALANCE, +, totalCost);
                        }

                        mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), totalCost, IsBusinessOwned(businessid));
                        mysql_query(mysql, query, false);
                    }
                }
                else
                {
                    ShowClientNotification(playerid, 2, 5, 1, 1, "Недостаточно денег для покупки еды!", "");
                }
            }

            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", actionType);
            JSON_SetInt(response, "r", orderMask);

            new outcoming_data[256];
            JSON_Stringify(response, outcoming_data);

            OnPacketIncoming(playerid, 3, outcoming_data);

            JSON_Cleanup(response);

            SetPlayerInBiz(playerid, -1);
        }
         case 2:
{
    new action;
    JSON_GetInt(json, "t", action);

    switch(action)
    {
        case 0:
        {
            new fuel_type, fuel_amount;
            JSON_GetInt(json, "f", fuel_type);
            JSON_GetInt(json, "v", fuel_amount);

            new vehicleid = GetPlayerVehicleID(playerid);
            new stationid = GetPVarInt(playerid, "current_fuel_station");

            if(!IsPlayerDriver(playerid) || !IsPlayerInVehicle(playerid, vehicleid))
            {
                SendClientMessage(playerid, 0xFFFFF00, "Вы должны быть водителем транспортного средства");
            }
            else if(stationid == -1)
            {
                SendClientMessage(playerid, -1, "Ошибка заправки");
            }
            else
            {
                new current_fuel = floatround(GetVehicleData(vehicleid, V_FUEL));
                new max_fuel = 150;

                if((current_fuel + fuel_amount) > max_fuel)
                {
                    SendClientMessage(playerid, -1, "Бензобак переполнен");
                }
                else if(GetFuelStationData(stationid, FS_FUELS) < fuel_amount)
                {
                    SendClientMessage(playerid, -1, "На заправке недостаточно топлива");
                }
                else
                {
                    new fuel_prices[5] = {65, 69, 77, 98, 86};
                    new price_per_liter = fuel_prices[fuel_type];
                    new total_price = price_per_liter * fuel_amount;

                    if(GetPlayerMoneyEx(playerid) < total_price)
                    {
                        SendClientMessage(playerid, -1, "Недостаточно денег для заправки");
                    }
                    else
                    {
                        SetVehicleData(vehicleid, V_FUEL, float(current_fuel + fuel_amount));
                        GivePlayerMoneyEx(playerid, -total_price, "Заправка топлива", false, false);

                        SetFuelStationData(stationid, FS_FUELS, GetFuelStationData(stationid, FS_FUELS) - fuel_amount);
                        SetFuelStationData(stationid, FS_BALANCE, GetFuelStationData(stationid, FS_BALANCE) + total_price);

                        new msg[128];
                        format(msg, sizeof(msg), ""SC"Вы потратили %d руб.", total_price);
                        SendClientMessage(playerid, -1, msg);

new Node:close_json = JSON_Object();
HidePlayerGUI(playerid, 2); // убрал close_json
JSON_Cleanup(close_json);
                        DeletePVar(playerid, "current_fuel_station");
                    }
                }
            }
        }
// АВТОРЫ: @dev_fable, @valve_develop
        case 1:
        {
            DeletePVar(playerid, "current_fuel_station");
        }
    }
}        case 38:
        {
            new t;
            new skin_id;
                    JSON_GetInt(json, "i", skin_id);

                    SetPlayerSkin(playerid, skin_id);
                   SetPlayerVirtualWorld(playerid, playerid);
                   SetPlayerInterior(playerid, playerid + 1);
            JSON_GetInt(json, "t", t);

            printf("CASE IN REGISTRATION = %d", t);

            switch(t)
            {
                case -1:
                {
                    new skin_id;
                    JSON_GetInt(json, "i", skin_id);

                    SetPlayerSkin(playerid, skin_id);
                    return;
                }

                case 1:
                {
                    new email[128], password[24];

                    JSON_GetString(json, "s", email);
                    JSON_GetString(json, "p", password);

                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);

                    if(strlen(email) != 0)
                    {
                        strmid(GetPlayerData(playerid, P_EMAIL), email, 0, strlen(email), 65);
                    }                    

                    JSON_Stringify(json_packet_data, outcoming_data);
                    OnPacketIncoming(playerid, 38, outcoming_data);
                    
                    JSON_Cleanup(json_packet_data);

                    return;
                }

                case 3:
                {
                    new gender;
                    JSON_GetInt(json, "r", gender);

                    SetPlayerData(playerid, P_SEX, gender);

                    CreatePlayerAccount(playerid);

                    if(CheckCreatePlayerAccount(playerid) > 0)
                    {
                        SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);

                        SetSpawnInfo(playerid, 0, 0, 332.2033, -174.1066, 999.6743, 1.0, 0, 0, 0, 0, 0, 0);
                        SpawnPlayer(playerid);
                        SendClientMessage(playerid, -1, "Вы успешно зарегистрировались на {FFD700}"SERVER_NAME"!");
                        SendClientMessage(playerid, -1, "На каждом спавне {FFD700}стоит местный таксист, {FFFFFF}подойдите к нему для разговора.");
                        
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 5);
			            UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS)); // фикс слотов
               
                        StopAudioStream(playerid);
                     //   SendClientMessage(playerid, -1, "{FFFF00}[Секретный Бонус] {FFFFFF}Ты стал одним из счастливчиков! Вводи промо-код {FFFF00}#START {FFFFFF}в меню {FFFF00}/promo");
                    }
                    else
                    {
                        ShowNewNotification(playerid, 2, 5, -1, -1, "Ошибка при создании аккаунта, проверьте базу данных на наличие аккаунта!");
                        Kick_fix(playerid);
                    }

                    JSON_Stringify(json_packet_data, outcoming_data);
                    OnPacketIncoming(playerid, 38, outcoming_data);
                    
                    JSON_Cleanup(json_packet_data);

                    return;
                }

case 66:
{
    new type, button, button1;
    JSON_GetInt(json, "t", type);
    JSON_GetInt(json, "b", button);
    JSON_GetInt(json, "bt", button1);
    new textpenis[64];
    format(textpenis, sizeof textpenis, "тыкнул на %d ид кнопки (или %d)", button, button1);
            

    new spectated = GetPlayerSpectateData(playerid, S_PLAYER);

    printf("ADMIN RECON: playerid=%d | type=%d | button=%d | spectated=%d", playerid, type, button, spectated);
    switch(button)
    {
     case 0..1000:
     {
     ShowNewNotification(playerid, 2, 6, 0, 0, textpenis, "");
     }
     } 
     switch(button1)
    {
     case 0..1000:
     {
     ShowNewNotification(playerid, 2, 6, 0, 0, textpenis, "");
     }
     } 
     

    

    JSON_Cleanup(json);
}
   case 4:
                {
                    new invite_nick[MAX_PLAYER_NAME];
                    JSON_GetString(json, "s", invite_nick);

                    // printf("invite_nick -> %s -> ...", invite_nick);

                    if (strlen(invite_nick) == 0)
                    {
                        JSON_Stringify(json_packet_data, outcoming_data);
                        OnPacketIncoming(playerid, 38, outcoming_data);

                        return;
                    }

                    new query[75], Cache: result;

                    mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", invite_nick);
                    result = mysql_query(mysql, query);

                    if(cache_num_rows())
                        SetPlayerData(playerid, P_REFER, cache_get_row_int(0, 0));
                    cache_delete(result);

                    if(!GetPlayerData(playerid, P_REFER))
                    {
                        ShowNewNotification(playerid, 2, 5, -1, -1, "Такого игрока не существует!");
                        return;
                    }

                    JSON_Stringify(json_packet_data, outcoming_data);
                    OnPacketIncoming(playerid, 38, outcoming_data);

                    JSON_Cleanup(json_packet_data);

                    return;
                }

                case 5:
{
    new final_skin;
    JSON_GetInt(json, "r", final_skin);

    SetPlayerData(playerid, P_SKIN, final_skin);

    HidePlayerSelectPanel(playerid);
    HidePlayerSelectPanelPrice(playerid);

    SetPlayerData(playerid, P_SELECT_SKIN, -1);
    SetPlayerSpawnInit(playerid);
    
    


    new spawn_random = random(4);
    SetPlayerPosEx(playerid, spawn_pos_data[spawn_random][0], spawn_pos_data[spawn_random][1], spawn_pos_data[spawn_random][2], spawn_pos_data[spawn_random][3], 0, 0);

    SpawnPlayer(playerid);
    SetPlayerInit(playerid);

    new query[90];
    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET skin=%d,last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
    mysql_query(mysql, query, false);
    return;
}                case 6:
                {
                    new password[24], hash[65], auto_login;

                    JSON_GetString(json, "s", password);
                    JSON_GetInt(json, "r", auto_login);
                    
                    strmid(CheckPass[playerid], password, 0, strlen(password), 65);
                    SHA256_PassHash(CheckPass[playerid], GetPlayerData(playerid, P_SALT), hash, 65);

                    if(!strcmp(hash, GetPlayerData(playerid, P_PASSWORD)))
                    {
                        SetPlayerData(playerid, P_AUTH_TIME, -1);
			            LoadPlayerData(playerid);

                        SetPlayerLogged(playerid, true);

                        JSON_SetInt(json_packet_data, "c", 1);

                        JSON_Stringify(json_packet_data, outcoming_data);
                        OnPacketIncoming(playerid, 38, outcoming_data);

                        JSON_Cleanup(json_packet_data);
                    } 
                    else
                    {
                        ShowNewNotification(playerid, 2, 5, -1, -1, "Неверный пароль!");
                    }

                    return;
                }
            }
        }
                case 14:
        {
            new t, i;

            JSON_GetInt(json, "t", t);
            JSON_GetInt(json, "i", i);

            switch(t)
            {
                case 0:
                {
                    callcmd::gps(playerid, "");
                }

                case 1:
                {
// callcmd::fm(playerid, "");
                }

                case 2:
                {
                    callcmd::mm(playerid, "");
                }

                case 3:
                {

                }

                case 4:
                {
                    callcmd::inv(playerid, "");
                }

                case 5:
                {
                    callcmd::anim(playerid, "");
                }

                case 6:
                {
                    callcmd::donate(playerid, "");
                }

                case 7:
                {
                    callcmd::car(playerid, "");
                }

                case 8:
                {
                    callcmd::promo(playerid, "");
                }

                case 9:
                {
                    callcmd::report(playerid, "");
                }
            }

            new Node:json_packet_data = JSON_Object();
            JSON_SetInt(json_packet_data, "i", 1);

            new outcoming_data[256];
            JSON_Stringify(json_packet_data, outcoming_data);

            OnPacketIncoming(playerid, 14, outcoming_data);

            JSON_Cleanup(json_packet_data);
        }
case 33:
{
    new type;
    JSON_GetInt(json, "t", type);

    new Node:response = JSON_Object();

    new item_type, pos;

    if (type == 19)
    {
        JSON_GetInt(json, "ga", item_type);
        JSON_GetInt(json, "s", pos);
        
        if(item_type == 134) 
        {
            new Node:itArray;
            JSON_GetArray(json, "it", itArray);
            
            // Получаем ID скина динамически из массива
            new skin_id = 0;
            new array_length;
            JSON_ArrayLength(itArray, array_length);
            
            // Проверяем, что позиция существует в массиве
            if(array_length > (pos * 4 + 1))
            {
                new Node:skinNode;
                if(JSON_ArrayObject(itArray, pos * 4 + 1, skinNode))
                {
                    JSON_GetNodeInt(skinNode, skin_id);
                }
            }
            
            if(skin_id != 0)
            {
                SetPlayerSkin(playerid, skin_id);
                
                new message[128];
                format(message, sizeof(message), "Скин с ID %d использован!", skin_id);
                SendClientMessage(playerid, -1, message);
                
                printf("[DEBUG] Игрок %d использовал скин ID: %d (тип: %d, поз: %d)", playerid, skin_id, item_type, pos);
                
                JSON_SetInt(response, "t", 19);
                JSON_SetInt(response, "s", 1);
                JSON_SetInt(response, "ps", skin_id);
            }
            else
            {
                JSON_SetInt(response, "t", 19);
                JSON_SetInt(response, "s", 0);
            }
        }
        else if(item_type == 22) 
        {
            new hunger = 100; // Нужно получить текущее значение голода игрока
            hunger = (hunger + 20 > 100) ? 100 : hunger + 20;
            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", 1);
            JSON_SetInt(response, "h", hunger); // Исправлено: было "s", должно быть "h" или другое поле
        } 
        else if(item_type == 58) 
        {
            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", 1);
        }
        else
        {
            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", 1);
        }
    }
new Node:JSONObject = JSON_Object();
    ShowPlayerGUI(playerid, 33, JSONObject);
    JSON_Cleanup(response);
}

        
        case 50:
        {
            new
                spawn_id;

            JSON_GetInt(json, "t", spawn_id);

            switch(spawn_id)
            {
 case 1:
{
    new spawn_random = random(sizeof(spawn_pos_data)); // случайный спавн из всех доступных
    
    // Сначала спавним игрока
    SpawnPlayer(playerid);
    
    // Потом телепортируем на позицию
    SetPlayerPosEx(playerid, spawn_pos_data[spawn_random][0], spawn_pos_data[spawn_random][1], spawn_pos_data[spawn_random][2], spawn_pos_data[spawn_random][3], 0, 0);
    
    // Устанавливаем спавн инфо на будущее
    SetSpawnInfo
    (
        playerid,
        0,
        GetPlayerSkinEx(playerid),
        spawn_pos_data[spawn_random][0],
        spawn_pos_data[spawn_random][1],
        spawn_pos_data[spawn_random][2],
        spawn_pos_data[spawn_random][3],
        0, 0, 0, 0, 0, 0
    );
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

                    EnterPlayerToHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));
                }                
            }

            SpawnPlayer(playerid);
            OnPlayerSpawn(playerid);

            JSON_SetInt(json_packet_data, "c", 1);
            JSON_Stringify(json_packet_data, outcoming_data);

            OnPacketIncoming(playerid, 50, outcoming_data);

            JSON_Cleanup(json_packet_data);
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            SendClientMessage(playerid, -1, "");
            StopAudioStream(playerid);
 
            
            LoadAccessory(playerid);

	
SendClientMessage(playerid, -1, "Добро пожаловать в {FFD700}«"SERVER_NAME"» {FFFFFF}— сервер {FFD700}RED");
SendClientMessage(playerid, -1, "На каждом спавне {FFD700}стоит местный таксист, {FFFFFF}подойдите к нему для разговора."); 

SendClientMessage(playerid, -1, ""); 

SendClientMessage(playerid, -1, "Сейчас действует {FFD700}X2 акция, {FFFFFF}пополнение счета будет {FFD700}умножаться на x2");
SendClientMessage(playerid, -1, "Пополнить {FFD700}BC {FFFFFF}можно на нашем сайте {FFD700}crmpbest.online {FFFFFF}в разделе донат");
       }

        case 37:
        {
            new t;
            JSON_GetInt(json, "t", t);

            switch(t)
            {
                case 1:
                {
                    new s;
                    JSON_GetInt(json, "s", s);

                    switch(s)
                    {
                        case 0:
                        {
                            if (GetPlayerMoney(playerid) < 1500)
                            {
                                ShowNewNotification(playerid, 2, 5, -1, -1, "Недостаточно средств!");
                            }
                            else
                            {
                                GivePlayerMoneyEx(playerid, -1500);
                                
                                JSON_SetInt(json_packet_data, "t", 1);
                                JSON_SetInt(json_packet_data, "s", 0);

                                JSON_Stringify(json_packet_data, outcoming_data);

                                OnPacketIncoming(playerid, 37, outcoming_data);
                            }
                        }
                    }
                }
            }
        }
        
        case 13:
{
  new t, sub_id, id;
  JSON_GetInt(json, "t", t);
  JSON_GetInt(json, "s", id);
  JSON_GetInt(json, "b", sub_id);

  switch(t)
  {
    case 0: // если пользоватетель нажал на кнопку уведомления (4 и 5 типы)
    {
      switch(id) // отлавливаем уведомление по id
      {
        case 1: // действие когда игрок нажал на уведомление с id - 1
        {
          return;
        }
        case OFFER_MINE:
        {
            callcmd::exchangebtc(playerid, "");
        } 
        case OFFER:
        {
         callcmd::yes(playerid, "");
        } 
        case OFFER_ENGINE:
        {
        callcmd::e(playerid, "");
        }
        case DOOR_HOUSE:
        {
        callcmd::exit(playerid, "");
        }
       
        case TAXIST:
        {
        ShowTaxiPWN(playerid);
        }
                    case BLACK_JACK:
					{
					    callcmd::blackjack(playerid);
					}

        case NARKO:
        {
        drugsdelivery(playerid);
        }
        case DOORUVED:
        {
        OpenDoorUved(playerid);
        }
        case AIR:
        {
        OpenAirDrop(playerid);
        }
        case INKOUVED:
        {
        callcmd::joincoll(playerid, "");
        }
        case OPEN_GATE:
					{
					    callcmd::opengate(playerid);
					}

        case QUEST:
        {
        callcmd::quest(playerid, "");
        }
        case BANKOMAT:
        {
        ShowPlayerATMDialog(playerid);
        }
		case ENTER_CONT:
        {
// CallLocalFunction("OnPlayerCommandText", "is", playerid, "/cont");
        }
      
}

      return;
    }

    case 1: // когда пользователь нажал на само уведомлние, чтобы его закрыть, или закончилось время воспроизвидения (duration)
    {
      switch(id) // отлавливаем уведомление по id
      {
        case 1: // действие когда игрок нажал на уведомление с id - 1
        {
          return;
        }
        case OFFER:
        {
         callcmd::no(playerid, ""); // предложение от игрока отказ
        } 
      }
      
      return;
    }
  }
}
case GUIRadialMenuForCar:
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new index = GetVehicleData(vehicleid, V_ACTION_ID);

    new type;
    JSON_GetInt(json, "t", type); // Исправлено с JSONObject на json
    
    printf("[RADIAL MENU] Игрок %s[%d] нажал кнопку: %d", GetPlayerNameEx(playerid), playerid, type);

    new Node:response_json = JSON_Object();
    new response_data[512];

    switch(type)
    {
        case 1: 
        {
            callcmd::park(playerid);
            JSON_SetInt(response_json, "t", 1);
            JSON_SetInt(response_json, "s", 1);
        }
        case 2:
        {
            callcmd::key(playerid);
            JSON_SetInt(response_json, "t", 2);
            if(GetOwnableCarData(index, OC_KEY_IN)) JSON_SetInt(response_json, "s", 1);
            else JSON_SetInt(response_json, "s", 0);
        }
        case 3:
        {
            callcmd::lock(playerid);
            JSON_SetInt(response_json, "t", 3);
            if(GetVehicleParam(vehicleid, V_LOCK)) JSON_SetInt(response_json, "s", 1);
            else JSON_SetInt(response_json, "s", 0);
        }
        case 5:
        {
            if(vInfo[vehicleid][vLaunchControl])
            {
                SetVehicleLaunchControl(vehicleid, 1);
                JSON_SetInt(response_json, "t", 5);
                JSON_SetInt(response_json, "c", 1);
                JSON_SetInt(response_json, "s", 1);
            }
            else 
            {
                ShowNewNotification(playerid, 2, 6, 0, 0, "В авто не утановлен лаунч-контроль.", "Ошибка");
                JSON_SetInt(response_json, "t", 5);
                JSON_SetInt(response_json, "s", 0);
            }
        }
        case 6:
        {
            // Сначала вызываем команду двигателя
            callcmd::e(playerid);
            
            // Затем проверяем состояние ДО нажатия (инвертируем)
            new engine_state_before = GetVehicleParam(vehicleid, V_ENGINE);
            JSON_SetInt(response_json, "t", 6);
            
            // Инвертируем состояние для отображения (после callcmd::e состояние изменится)
            if(engine_state_before) 
            {
                // Если был включен - станет выключен (красный)
                JSON_SetInt(response_json, "s", 0);
                Action(playerid, "заглушил двигатель транспортного средства", _, false);
            }
            else 
            {
                // Если был выключен - станет включен (зеленый)
                JSON_SetInt(response_json, "s", 1);
                Action(playerid, "запустил двигатель транспортного средства", _, false);
            }
        }
        case 8: // Дрифт режим
        {
            new idx = GetPVarInt(playerid, "ownablecar_id");
            if(idx != 0)
            {
                new query[128];
                mysql_format(mysql, query, sizeof query, "SELECT drift_mode FROM ownable_cars WHERE id = %d", idx);
                new Cache:result = mysql_query(mysql, query, true);

                if(cache_num_rows() > 0)
                {
                    new drift_mode_str[2];
                    cache_get_row(0, 0, drift_mode_str);
                    new drift_mode = strval(drift_mode_str);
                    

                    if(drift_mode == 1)
                    {
                        // Включаем дрифт
                        //callcmd::zdrift(playerid);
                        JSON_SetInt(response_json, "t", 8);
                        JSON_SetInt(response_json, "s", 1);
                        ShowNewNotification(playerid, 2, 6, 0, 0, "Дрифт режим включен", "Успех");
                        Action(playerid, "включил дрифт режим", _, false);
                        driftenable[vehicleid] = 1;
                       SetVehicleDriftForPlayerFix(vehicleid, 1, 1);
                    }
                    if(driftenable[vehicleid] > 0)
                    {
                        // Выключаем дрифт
                       // callcmd::zdriftoff(playerid);
                        JSON_SetInt(response_json, "t", 8);
                        JSON_SetInt(response_json, "s", 0);
                        ShowNewNotification(playerid, 2, 6, 0, 0, "Дрифт режим выключен", "Успех");
                        Action(playerid, "выключил дрифт режим", _, false);
                        driftenable[vehicleid] = 0;
                       SetVehicleDriftForPlayerFix(vehicleid, 0, 0);
                    }
                    else
                    {
                     ShowNewNotification(playerid, 2, 6, 0, 0, "У автомобиля нет данной прошивки", "");
                    } 
                }
                cache_delete(result);
            }
        }
        case 9:
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У Вас не установлена эта прошивка!", "Ошибка");
            JSON_SetInt(response_json, "t", 9);
            JSON_SetInt(response_json, "s", 0);
        }
        case 10:
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У Вас не установлена эта прошивка!", "Ошибка");
            JSON_SetInt(response_json, "t", 10);
            JSON_SetInt(response_json, "s", 0);
        }
        case 11:
        {
            ShowNewNotification(playerid, 2, 6, 0, 0, "У Вас не установлена эта прошивка!", "Ошибка");
            JSON_SetInt(response_json, "t", 11);
            JSON_SetInt(response_json, "s", 0);
        }
        case 12:
        {
            if(vInfo[vehicleid][vNeon][0] || vInfo[vehicleid][vNeon][1] || vInfo[vehicleid][vNeon][2])
            {
                if(GetVehicleParam(vehicleid, V_ENGINE))
                {
                    if(!vInfo[vehicleid][vEnableNeon])
                    {
                        vInfo[vehicleid][vEnableNeon] = true;
                        SetVehicleLightingColor(vehicleid, vInfo[vehicleid][vNeon][0], vInfo[vehicleid][vNeon][1], vInfo[vehicleid][vNeon][2]);
                        JSON_SetInt(response_json, "t", 12);
                        JSON_SetInt(response_json, "s", 1);
                        Action(playerid, "включил неоновую подсветку", _, false);
                    }
                    else
                    {
                        vInfo[vehicleid][vEnableNeon] = false;
                        SetVehicleLightingColor(vehicleid, 0x00000000, 0x00000000, 0x00000000);
                        JSON_SetInt(response_json, "t", 12);
                        JSON_SetInt(response_json, "s", 0);
                        Action(playerid, "выключил неоновую подсветку", _, false);
                    }
                }
            }
            else 
            {
                ShowNewNotification(playerid, 2, 6, 0, 0, "У Вас не установлена подсветка!", "Ошибка");
                JSON_SetInt(response_json, "t", 12);
                JSON_SetInt(response_json, "s", 0);
            }
        }
        case 13:
        {
            //callcmd::hl(playerid);
            JSON_SetInt(response_json, "t", 13);
            JSON_SetInt(response_json, "s", 1);
        }
        case 14:
        {
            callcmd::l(playerid);
            JSON_SetInt(response_json, "t", 14);
            JSON_SetInt(response_json, "s", 1);
        }
        case 15: // Страбоскопы
        {
            printf("[DEBUG] Кнопка 15 нажата. typestrabiki[playerid] = %d, vEnableStroboscope = %d", typestrabiki[playerid], vInfo[vehicleid][vEnableStroboscope]);
            
            if(typestrabiki[playerid] > 0)
            {
                printf("[DEBUG] До переключения: vEnableStroboscope = %d", vInfo[vehicleid][vEnableStroboscope]);
                
                if(!vInfo[vehicleid][vEnableStroboscope])
                {
                    vInfo[vehicleid][vEnableStroboscope] = true;
                    SetVehicleStroboscope(vehicleid, typestrabiki[playerid], 1);
                    JSON_SetInt(response_json, "t", 15);
                    JSON_SetInt(response_json, "s", 1);
                    ShowNewNotification(playerid, 2, 6, 0, 0, "Страбоскопы включены", "Успех");
                    Action(playerid, "включил стробоскопы", _, false);
                    printf("[DEBUG] Страбоскопы ВКЛЮЧЕНЫ");
                }
                else
                {
                    vInfo[vehicleid][vEnableStroboscope] = false;
                    SetVehicleStroboscope(vehicleid, typestrabiki[playerid], 0);
                    JSON_SetInt(response_json, "t", 15);
                    JSON_SetInt(response_json, "s", 0);
                    ShowNewNotification(playerid, 2, 6, 0, 0, "Страбоскопы выключены", "Успех");
                    Action(playerid, "выключил стробоскопы", _, false);
                    printf("[DEBUG] Страбоскопы ВЫКЛЮЧЕНЫ");
                }
                
                printf("[DEBUG] После переключения: vEnableStroboscope = %d", vInfo[vehicleid][vEnableStroboscope]);
            }
            else
            {
                ShowNewNotification(playerid, 2, 6, 0, 0, "У Вас не установлены страбоскопы!", "Ошибка");
                JSON_SetInt(response_json, "t", 15);
                JSON_SetInt(response_json, "s", 0);
            }
        }
        case 16:
        {
            // callcmd::cliranc(playerid, "4");
            JSON_SetInt(response_json, "t", 16);
            JSON_SetInt(response_json, "s", 1);
        }
        case 17:
        {
            // callcmd::cliranc(playerid, "3");
            JSON_SetInt(response_json, "t", 17);
            JSON_SetInt(response_json, "s", 1);
        }
        case 18:
        {
            // callcmd::cliranc(playerid, "2");
            JSON_SetInt(response_json, "t", 18);
            JSON_SetInt(response_json, "s", 1);
        }
        case 19: // Гидравлика
        {
            if(vInfo[vehicleid][vHydraulics])
            {
                if(!vInfo[vehicleid][vEnableHydraulics])
                {
                    vInfo[vehicleid][vEnableHydraulics] = true;
                    SetVehicleHydraulics(vehicleid, 1);
                    JSON_SetInt(response_json, "t", 19);
                    JSON_SetInt(response_json, "s", 1);
                    Action(playerid, "включил гидравлику", _, false);
                }
                else
                {
                    vInfo[vehicleid][vEnableHydraulics] = false;
                    RemoveVehicleComponent(vehicleid, 1087);
                    SetVehicleHydraulics(vehicleid, 0);
                    JSON_SetInt(response_json, "t", 19);
                    JSON_SetInt(response_json, "s", 0);
                    Action(playerid, "выключил гидравлику", _, false);
                }
            }
            else 
            {
                ShowNewNotification(playerid, 2, 6, 0, 0, "У Вас не установлена гидравлика!", "Ошибка");
                JSON_SetInt(response_json, "t", 19);
                JSON_SetInt(response_json, "s", 0);
            }
        }
        default:
        {
            JSON_SetInt(response_json, "t", type);
            JSON_SetInt(response_json, "s", 0);
        }
    }

    // Отправляем ответ
    JSON_Stringify(response_json, response_data);
    OnPacketIncoming(playerid, GUIRadialMenuForCar, response_data);

    printf("radial_response_data = %s", response_data);
    JSON_Cleanup(response_json);
}
        case 22:
        {
            new type;
            JSON_GetInt(json, "t", type);

            switch(type)
            {
                case 2:
                {
                    if(GetPlayerData(playerid, P_SALE_TIME) != 0) return;

                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}Подарок", "При открытии подарка, вы получили бронзовую рулетку!", "Закрыть", "");

                    SetPlayerData(playerid, P_SALE_TIME, 7200); // 2 часа в секундах
		            UpdatePlayerDatabaseInt(playerid, "sale_time", GetPlayerData(playerid, P_SALE_TIME));

                    JSON_SetInt(json_packet_data, "t", 2);
                    JSON_SetInt(json_packet_data, "p", GetPlayerData(playerid, P_SALE_TIME));

                    JSON_Stringify(json_packet_data, outcoming_data);
                    OnPacketIncoming(playerid, 22, outcoming_data);

                    JSON_Cleanup(json_packet_data);

                    // TODO: реализовать выдачу рулетки пользователю (для более опытеых павнеров)
                }

                case 0:
                {                    
                   new price, internal_id;

                   JSON_GetInt(json, "p", internal_id);
                   JSON_GetInt(json, "m", price);

                   new result = GetPlayerDonateRub(playerid) - price;
                   printf("result = %d", result);

                   new result_json[256];
                   JSON_Stringify(json, result_json);

                   printf("result (json) = %s", result_json);

                   if (GetPlayerDonateRub(playerid) < price || GetPlayerDonateRub(playerid) < GetPlayerDonateRub(playerid) - price)
                   {
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 0);
                        JSON_SetInt(json_packet_data, "k", 1);

                        JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                        JSON_SetString(json_packet_data, "n", "Пополните счет прямо сейчас!");

                        JSON_Stringify(json_packet_data, outcoming_data);
                        OnPacketIncoming(playerid, 22, outcoming_data);

                        JSON_Cleanup(json_packet_data);

                        return;
                   }

                   switch(internal_id)
                   {
                        case 349,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,201,202,195,211,212,213,214,215,216,217,218,219,220,353,221,222,223,224,275,276,327,328,329,330,331,366,367,400,401,402,403,404,405,406,407,408,409,410,411,413,414,415,416,417,418,424,426,427,428,429,444,445,446,447,448,449,450,451,452,453,454,455,456,459,460,461,465,466,467,468,469,470,471,472,473,474,484:
                        {
                            if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", -1);

                                JSON_SetString(json_packet_data, "m", "Все слоты для покупки нового\nтранпорта заняты.");
                                JSON_SetString(json_packet_data, "n", "Вы можете увеличить их в разлеле {FFFF00}услуги.");
                                
                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, outcoming_data);

                                JSON_Cleanup(json_packet_data);
                                
                                return;
                            }

                            BuyPlayerCar(playerid, internal_id, FindGameId(internal_id, car_game_ids, sizeof(car_game_ids)), 0);
                            GivePlayerDonateRub(playerid, -price);

                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            JSON_SetInt(json_packet_data, "g", internal_id);

                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
                            JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");

                            JSON_Stringify(json_packet_data, outcoming_data);
                            OnPacketIncoming(playerid, 22, outcoming_data);

                            JSON_Cleanup(json_packet_data);
                        }
                        case 475, 462, 463, 457, 458, 419, 430, 431, 425, 420, 421, 399, 390, 391, 392, 393, 394, 395, 396, 397, 398, 346, 344, 345, 332, 333, 334, 335, 340, 336, 337, 338, 339, 341, 342, 343, 315, 313, 311, 322, 323, 324, 314, 312, 316, 317, 318, 319, 320, 321, 325, 326, 238, 257, 239, 240, 225, 226, 227, 228, 205, 206, 207, 208, 91, 92, 229, 93, 94, 230, 95, 96, 97, 203, 231, 232, 233, 234, 235, 98, 99, 100, 101, 236, 237, 209, 210, 548, 535, 529, 527, 528, 526, 525, 519, 513, 514, 515, 516, 517, 486, 487, 488, 489, 490, 491, 492, 497, 480, 481, 482, 483:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            JSON_SetInt(json_packet_data, "g", internal_id);

                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);

                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели одежду");
                            JSON_SetString(json_packet_data, "n", "Для того чтобы одеть её, используйте /inv");

                            JSON_Stringify(json_packet_data, outcoming_data);
                            OnPacketIncoming(playerid, 22, outcoming_data);

                            JSON_Cleanup(json_packet_data);

                            BuyPlayerSkin(playerid, internal_id, FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids)));

                            GivePlayerDonateRub(playerid, -price);
                        }

// АКСЫ НЕВ ДИВЖОК BY VIT4LKA:
                        case 549, 534, 533, 530, 531, 532, 518, 493, 494, 495, 496, 476, 477, 478, 479, 542, 464, 432, 433, 434, 436, 437, 438, 439, 440, 441, 442, 443, 435, 422, 423, 368, 369, 370, 371, 372, 373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388, 389, 354, 355, 356, 357, 358, 359, 360, 361, 362, 363, 364, 365, 277, 278, 279, 280, 295, 296, 297, 281, 282, 283, 284, 285, 286, 287, 288, 289, 290, 291, 292, 293, 294, 298, 299, 300, 301, 302, 303, 304, 305, 306, 307, 308, 309, 310, 243, 244, 245, 246, 241, 242, 274, 247, 248, 249, 250, 251, 252, 254, 255, 256, 253, 258, 259, 260, 261, 263, 264, 265, 266, 267:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            JSON_SetInt(json_packet_data, "g", internal_id);

                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);

                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели аксессуар");
                            JSON_SetString(json_packet_data, "n", "Используйте /inv чтобы надеть"); 

                            JSON_Stringify(json_packet_data, outcoming_data);
                            OnPacketIncoming(playerid, 22, outcoming_data);

                            JSON_Cleanup(json_packet_data);

           
                            BuyPlayerAcs(playerid, internal_id, FindGameId(internal_id, accessories_game_ids, sizeof(accessories_game_ids))); 

                            GivePlayerDonateRub(playerid, -price); 

                        }
                        
                        
                        //услуги 
                        
                        /* 
                        
                            {
      "internalId": 102,
      "gameId": -20,
      "header": "СТАТЬ АДМИНОМ",
      "desc": "При приобретении услуги (донат не списывается при покупке услуги) откроется диалог с выбором админки.",
      "basePrice": 0,
      "imageId": "delete_warn",
      "count": 1,
      "type": 5
    },
    {
      "internalId": 103,
      "gameId": 1,
      "header": "Снять варн",
      "desc": "При приобретении данной услуги с Вас будут сняты предупреждения, выданные администраторами. При наличии предупреждения Вы не сможете вступать во фракции. ",
      "basePrice": 100,
      "imageId": "delete_warn",
      "count": 1,
      "type": 5
    },
    {
      "internalId": 107,
      "gameId": -20,
      "header": "Изменить имя семьи",
      "desc": "При приобретении данной услуги Вы сможете изменить название Вашей семьи.",
      "basePrice": 100,
      "imageId": "change_family_name",
      "count": 1,
      "type": 5
    },
    {
      "internalId": 108,
      "gameId": -20,
      "header": "Передать семью",
      "desc": "При приобретении данной услуги Вы сможете передать свою семью другому игроку.",
      "basePrice": 100,
      "imageId": "change_family",
      "count": 1,
      "type": 5
    },
    {
      "internalId": 117,
      "gameId": 1,
      "header": "Купить мед. карту",
      "desc": "При приобретнии данного товара Вы получите медицинскую карту.",
      "basePrice": 100,
      "imageId": "med_card",
      "count": 1,
      "type": 5,
      "isNew": 0
    },
    {
      "internalId": 118,
      "gameId": -20,
      "header": "Уник. музыка на вход",
      "desc": "При приобретении данной услуги Вы получите возможность установки персональной музыки при входе в игру.",
      "basePrice": 120,
      "imageId": "login_music",
      "count": 1,
      "type": 5,
      "isNew": 0
    },
    {
      "internalId": 120,
      "gameId": 1,
      "header": "Доп. слот авто в семью",
      "desc": "При приобретении данной услуги Вы получите дополнительный слот на транспорт в Вашу семью.",
      "basePrice": 300,
      "imageId": "family_cars",
      "count": 1,
      "type": 5,
      "isNew": 0
    },
    {
      "internalId": 121,
      "gameId": 1,
      "header": "Смена пола",
      "desc": "При приобретении данной услуги Вы автоматически смените пол на противоположный.",
      "basePrice": 100,
      "imageId": "change_sex",
      "count": 1,
      "type": 5,
      "isNew": 0
    },
    {
      "internalId": 122,
      "gameId": 1,
      "header": "Доп. слот на авто",
      "desc": "При приобретении данной услуги Вы получите дополнительный слот на транспорт.",
      "basePrice": 100,
      "imageId": "add_car_slot",
      "count": 1,
      "type": 5
    },
    {
      "internalId": 123,
      "gameId": -20,
      "header": "Номера на авто",
      "desc": "При приобретении данной услуги Вы сможете самостоятельно приобрести свободные номера на автомобиль.",
      "basePrice": 400,
      "imageId": "buy_car_number",
      "count": 1,
      "type": 5,
      "valid": 1
    },
    {
      "internalId": 124,
      "gameId": -20,
      "header": "Номер телефона",
      "desc": "При приобретении данной услуги Вы сможете выбрать 4х значный номер телефона. Пример: 7777",
      "basePrice": 70,
      "imageId": "phone_number",
      "count": 1,
      "type": 5,
      "valid": 1
    },
   
  
  */
 


                                case 102: { // Админ права
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    if(GetPlayerDonateRub(playerid) >= 0) {
        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 0);
        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
        JSON_SetString(json_packet_data, "m", "Успешная операция");
        JSON_SetString(json_packet_data, "n", "продолжите в диалоге");
        
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
        callcmd::buyadm(playerid);
    }
    else {
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", 1);
        JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
    }
}

case 104: { // Изменение имени
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    if(GetPlayerDonateRub(playerid) >= 50) {
        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 50);
        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
        JSON_SetString(json_packet_data, "m", "Успешная операция");
        JSON_SetString(json_packet_data, "n", "вы купили услугу: Изменение имени");
        GivePlayerDonateRub(playerid, -50, "изменение имени", true);
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
        ShowPlayerChangeNameDialog(playerid);
    }
    else {
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", 1);
        JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
    }
}

case 103: { // Снятие предупреждения
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    if(GetPlayerDonateRub(playerid) >= 100) {
        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 100);
        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
        JSON_SetString(json_packet_data, "m", "Успешная операция");
        JSON_SetString(json_packet_data, "n", "вы купили услугу: Снятие предупреждения");
        GivePlayerDonateRub(playerid, -100, "снятие варна", true);
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
        
        SetPlayerData(playerid, P_WARN, 0);
        SetPlayerData(playerid, P_WARN_TIME, 0);
        UpdatePlayerDatabaseInt(playerid, "warn", 0);
        UpdatePlayerDatabaseInt(playerid, "warn_time", 0);
    }
    else {
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", 1);
        JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
    }
}

case 105: { // Все лицензии
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    if(GetPlayerDonateRub(playerid) >= 150) {
        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 150);
        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
        JSON_SetString(json_packet_data, "m", "Успешная операция");
        JSON_SetString(json_packet_data, "n", "вы купили услугу: Все лицензии");
        GivePlayerDonateRub(playerid, -150, "все лицензии", true);
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
        
        SetPlayerData(playerid, P_DRIVING_LIC, GetPlayerData(playerid, P_DRIVING_LIC) ^ 1);
        UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));
    }
    else {
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", 1);
        JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
    }
}

case 108: { // передать фаму виталька
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    if(GetPlayerDonateRub(playerid) >= 0) {
        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 0);
        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
        JSON_SetString(json_packet_data, "m", "Успешная операция");
        JSON_SetString(json_packet_data, "n", "Продолжите в диалоге");
        
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
        
         obmenfam(playerid);
    }
    else {
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", 1);
        JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
    }
}


case 120: { // Доп. слот в авто семьи
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    if(GetPlayerDonateRub(playerid) >= 0) {
        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 0);
        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
        JSON_SetString(json_packet_data, "m", "Успешная операция");
        JSON_SetString(json_packet_data, "n", "Продолжите в диалоге");
        
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
        slotfam(playerid);
    }
    else {
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", 1);
        JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
    }
}


case 122: { // Доп. слот на авто
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    if(GetPlayerDonateRub(playerid) >= 100) {
        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 100);
        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
        JSON_SetString(json_packet_data, "m", "Успешная операция");
        JSON_SetString(json_packet_data, "n", "вы купили доп. слот на авто");
        GivePlayerDonateRub(playerid, -100, "доп слот авто", true);
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
        
        AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
        UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
        
        new fmt_text[200];
        format(fmt_text, sizeof fmt_text, "Вы купили слот для транспорта. Текущее количество слотов: %d",
            GetPlayerData(playerid, P_CAR_SLOTS));
        SendClientMessage(playerid, 0x66CC00FF, fmt_text);
    }
    else {
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", 1);
        JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
    }
}

case 107: { // Смена названия семьи
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    if(GetPlayerDonateRub(playerid) >= 0) {
        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 0);
        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
        JSON_SetString(json_packet_data, "m", "Успешная операция");
        JSON_SetString(json_packet_data, "n", "Продолжите в диалоге");
        
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
        buyfamname(playerid);
    }
    else {
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", 1);
        JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
        JSON_Stringify(json_packet_data, outcoming_data);
        OnPacketIncoming(playerid, 22, outcoming_data);
    }
}                        //пониженный износ
                        case 115: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 300)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу: пониженный износ");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили пониженный износ для авто!");

                                    GivePlayerDonateRub(playerid, -300, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }

                        }
                        //вечная мед карта
                        case 116: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 300)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили вечную мед. карту");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили вечную мед. карту");

                                    GivePlayerDonateRub(playerid, -300, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }

                        }
                        //временная мед карта
                        case 117: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили мед. карту");

                                    g_player[playerid][P_MEDKA] = 1;
                                    SetPlayerData(playerid, P_MEDKA, 1);
            UpdatePlayerDatabaseInt(playerid, "med", 1);
            Quest9(playerid);

                                    GivePlayerDonateRub(playerid, -100, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }

                        }
                        //уник музыка 
                        case 118: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 50)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили уник. музыку на вход");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили уникальную музыку на вход");

                                    GivePlayerDonateRub(playerid, -50, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }

                        }
                        //законка
                        case 119: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 5)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили повышение закон-сти");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили повышение закон-сти");

                                    GivePlayerDonateRub(playerid, -5, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }

                        }
                        //доп слот на авто в семью
                        case 666: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 300)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили доп. слот на авто в семью");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили доп. слот на авто в семью!");

                                    GivePlayerDonateRub(playerid, -300, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }

                        }
                        //смена пола
                        case 121: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 50)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили смену пола");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили смену пола");

                                    GivePlayerDonateRub(playerid, -50, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }

                        }
           
                        //номерной знак
                        case 123:
{
                           ShowNewNotification(playerid, 2, 6, 0, 0, "Доступно в ГИБДД", "");
				
				

}
                        case 124: {
                                if(GetPlayerDonateRub(playerid) >= 70)
                                {

							Dialog
							(
								playerid, DIALOG_DONATE_BUY_NUMBER, DIALOG_STYLE_INPUT,
								"{CA5757}BEST RUSSIA {FFFFFF}| Покупка номера формата «XXXX»",
								"{FFFFFF}Введите номер, который\n"\
								"Вы хотели бы приобрести:",
								"Далее", "Отмена"
							);

						
						}
                                else
                                {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, outcoming_data);
                                }
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

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Молодой", price, internal_id);
                        }
                        case 185:
                        {
                            BuyPlayerCar(playerid, 28, 527, 0);

                            SetPlayerData(playerid, P_PREMIUM, 1);
         		            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Гангстер", price, internal_id);
                        }
                        case 269:
                        {
                            BuyPlayerSkin(playerid, 227, 232);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Красотка", price, internal_id);
                        }
                        case 176:
                        {
                            GivePlayerMoney(playerid, 500000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Бродяга", price, internal_id);
                        }
                        case 177:
                        {
                            GivePlayerMoney(playerid, 1000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Всё впереди", price, internal_id);
                        }
                        
                        case 178:
                        {
                            GivePlayerMoney(playerid, 10000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "Зажиточный", price, internal_id);
                        }
                   }
                }
            }
        }
    }
}

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

    strmid(g_ownable_car[free_car_id][OC_NUMBER], "-----", 0, 8, 8);

    SetOwnableCarData(free_car_id, OC_ALARM, false);
    SetOwnableCarData(free_car_id, OC_KEY_IN, false);
    SetOwnableCarData(free_car_id, OC_CREATE, gettime());

    format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    new database_query[256];
    
    format(database_query, sizeof database_query, "INSERT INTO ownable_cars (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')", GetPlayerAccountID(playerid), game_id, color, 0, pos_x, pos_y, pos_z, angle, gettime());
    mysql_query(mysql, database_query, true);
    Quest6(playerid);

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
    GivePlayerOwnableSkin(playerid, game_id);
}

public: ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:json_packet_data = JSON_Object(), outcoming_data[512];

    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    JSON_SetInt(json_packet_data, "g", internal_id);

    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели набор -");
    JSON_SetString(json_packet_data, "n", pack_name);

    JSON_Stringify(json_packet_data, outcoming_data);
    OnPacketIncoming(playerid, 22, outcoming_data);

    JSON_Cleanup(json_packet_data);
}

// АКСЫ ДОНАТ НЕВ ДВИЖ

public: BuyPlayerAcs(playerid, internal_id, game_id)
{
    GiveAccessory(playerid, game_id); // аксы велсика

    return 1;
}

public OnIncomingRPC(playerid, rpcid, BitStream:bs)
{ 
    new action, bits, string[512];
    BS_ReadUint8(bs, action);



    switch(rpcid)
    {
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


    return 1;
}

