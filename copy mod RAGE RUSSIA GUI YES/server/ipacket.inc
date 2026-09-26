//#include "../gamemodes/api/notification.inc"

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

IPacket:251(playerid, BitStream:bs)
{
    new 
        header, 
        rpcid,
        data_len,
        data[512],
        outcoming_data[512],
        Node:json = JSON_Object(),
        Node:json_packet_data = JSON_Object();

    BS_ReadValue(bs, PR_UINT8, header);
    BS_ReadValue(bs, PR_UINT8, rpcid);

    BS_ReadValue(bs, PR_UINT16, data_len);
    BS_ReadValue(bs, PR_STRING, data, data_len);

    JSON_Parse(data, json);

    switch(rpcid)
    {
        case 38:
        {
            new t;
            JSON_GetInt(json, "t", t);

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

                    if(CreatePlayerAccount(playerid))
                    {
                        SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);

                        SetSpawnInfo(playerid, 0, 0, 332.2033, -174.1066, 999.6743, 1.0, 0, 0, 0, 0, 0, 0);
                        SpawnPlayer(playerid);
                    }
                    else
                    {
                        ShowClientNotification(playerid, 2, 5, -1, -1, "                            ,                 !");
                        Kick:(playerid);
                    }

                    JSON_Stringify(json_packet_data, outcoming_data);
                    OnPacketIncoming(playerid, 38, outcoming_data);
                    
                    JSON_Cleanup(json_packet_data);

                    return;
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
                        ShowClientNotification(playerid, 2, 5, -1, -1, "                           !");
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
                    
                    SetPlayerData(playerid, P_MONEY, 200);
					UpdatePlayerDatabaseInt(playerid, "money", 200);

                    SpawnPlayer(playerid);
                    SetPlayerInit(playerid);

                    new query[90];
                    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET skin=%d,last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
                    mysql_query(mysql, query, false);
                    return;
                }

                case 6:
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
                        ShowClientNotification(playerid, 2, 5, -1, -1, "               !");
                    }

                    return;
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
    case 0: //                                                 (4   5     )
    {
      switch(id) //                            id
      {
        case 1: callcmd::oslik(playerid);
        case 2: callcmd::osel(playerid);
        case 3: callcmd::usahds(playerid);
        case 4: callcmd::e(playerid);
        case 5: ShowVodolazArzamas(playerid);
        case 6: ShowVodolazLitkarino(playerid);
        case 7: ShowVodolazYuzhka(playerid); 
        case 8: ShowVodolazGarel(playerid);
        case 9: Predmet1VodoArz(playerid);
        case 10: Predmet2VodoArz(playerid);
        case 11: Predmet3VodoArz(playerid);
         case 12: Predmet4VodoArz(playerid);
        case 13: Predmet5VodoArz(playerid);
        case 14: Predmet6VodoArz(playerid);
        case 15: BuyTypeBizShop(playerid);
      }

      return;
    }

    case 1: //                                            ,                  ,                                       (duration)
    {
      switch(id) //                            id
      {
        case 1: //                                             id - 1
        {
          return;
        }
      }
      
      return;
    }
  }
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
                    new spawn_id_int = random(10);
	
                    SetSpawnInfo
	(
		playerid,
		0,
		GetPlayerSkinEx(playerid),
		spawn_pos_data[spawn_id][0], // + random(5),
		spawn_pos_data[spawn_id][1], // + random(5),
		spawn_pos_data[spawn_id][2],
		spawn_pos_data[spawn_id][3],
		spawn_pos_data[spawn_id][4],
		spawn_pos_data[spawn_id][5],
		spawn_pos_data[spawn_id][6],
		spawn_pos_data[spawn_id][7],
		spawn_pos_data[spawn_id][8],
		spawn_pos_data[spawn_id][9],
		spawn_pos_data[spawn_id][10],
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

                    // EnterPlayerToHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));
                }                
            }

            SpawnPlayer(playerid);

            JSON_SetInt(json_packet_data, "c", 1);
            JSON_Stringify(json_packet_data, outcoming_data);

            OnPacketIncoming(playerid, 50, outcoming_data);

            JSON_Cleanup(json_packet_data);
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
                                ShowClientNotification(playerid, 2, 5, -1, -1, "                    !");
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

        case 22:
        {
            new type;
            JSON_GetInt(json, "t", type);

            switch(type)
            {
                case 2:
                {
                    if(GetPlayerData(playerid, P_SALE_TIME) != 0) return;

                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}       ", "                    ,                              !", "       ", "");

                    SetPlayerData(playerid, P_SALE_TIME, 7200); // 2                
		            UpdatePlayerDatabaseInt(playerid, "sale_time", GetPlayerData(playerid, P_SALE_TIME));

                    JSON_SetInt(json_packet_data, "t", 2);
                    JSON_SetInt(json_packet_data, "p", GetPlayerData(playerid, P_SALE_TIME));

                    JSON_Stringify(json_packet_data, outcoming_data);
                    OnPacketIncoming(playerid, 22, outcoming_data);

                    JSON_Cleanup(json_packet_data);

                    // TODO:                                         (                          )
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

                        JSON_SetString(json_packet_data, "m", "                    .");
                        JSON_SetString(json_packet_data, "n", "                           !");

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

                                JSON_SetString(json_packet_data, "m", "                            \n                .");
                                JSON_SetString(json_packet_data, "n", "                                 {FFFF00}      .");
                                
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

                            JSON_SetString(json_packet_data, "m", "                               !");
                            JSON_SetString(json_packet_data, "n", "                             ,\n            /car");

                            JSON_Stringify(json_packet_data, outcoming_data);
                            OnPacketIncoming(playerid, 22, outcoming_data);

                            JSON_Cleanup(json_packet_data);
                        }
                        case 475, 462, 463, 457, 458, 419, 430, 431, 425, 420, 421, 399, 390, 391, 392, 393, 394, 395, 396, 397, 398, 346, 344, 345, 332, 333, 334, 335, 340, 336, 337, 338, 339, 341, 342, 343, 315, 313, 311, 322, 323, 324, 314, 312, 316, 317, 318, 319, 320, 321, 325, 326, 238, 257, 239, 240, 225, 226, 227, 228, 205, 206, 207, 208, 91, 92, 229, 93, 94, 230, 95, 96, 97, 203, 231, 232, 233, 234, 235, 98, 99, 100, 101, 236, 237, 209, 210:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            JSON_SetInt(json_packet_data, "g", internal_id);

                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - 50);

                            JSON_SetString(json_packet_data, "m", "                           ");
                            JSON_SetString(json_packet_data, "n", "                      ,                      ");

                            JSON_Stringify(json_packet_data, outcoming_data);
                            OnPacketIncoming(playerid, 22, outcoming_data);

                            JSON_Cleanup(json_packet_data);

                            BuyPlayerSkin(playerid, internal_id, FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids)));

                            GivePlayerDonateRub(playerid, -price);
                        }
                        case 179:
                        {
                            BuyPlayerCar(playerid, 12, 585, 0);
                            BuyPlayerSkin(playerid, 180, 30);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "         ", price, internal_id);
                        }
                        case 181:
                        {
                            BuyPlayerCar(playerid, 22, 419, 0);
                            BuyPlayerSkin(playerid, 182, 60);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "      ", price, internal_id);
                        }
                        case 183:
                        {
                            BuyPlayerCar(playerid, 23, 562, 0);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            SetPlayerData(playerid, P_PREMIUM, 1);
         		            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 86400);

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "       ", price, internal_id);
                        }
                        case 185:
                        {
                            BuyPlayerCar(playerid, 28, 527, 0);

                            SetPlayerData(playerid, P_PREMIUM, 1);
         		            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "        ", price, internal_id);
                        }
                        case 269:
                        {
                            BuyPlayerSkin(playerid, 227, 232);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "        ", price, internal_id);
                        }
                        case 176:
                        {
                            GivePlayerMoney(playerid, 500000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "       ", price, internal_id);
                        }
                        case 177:
                        {
                            GivePlayerMoney(playerid, 1000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "          ", price, internal_id);
                        }
                        case 178:
                        {
                            GivePlayerMoney(playerid, 10000000);
                            GivePlayerDonateRub(playerid, -price);
                            ShowSuccesfullBuyPack(playerid, "          ", price, internal_id);
                        }
                       case 102:
                       {
                       
					    if(GetPlayerDonateRub(playerid) >= 50)
						{
							Dialog
							(
								playerid, DIALOG_DONATE_CHANGE_NAME, DIALOG_STYLE_INPUT,
								"{FFCD00}               ",
								"{FFFFFF}                             :",
								"        ", "       "
							);
						}
						else JSON_SetString(json_packet_data, "m", "                    .");
                               JSON_SetString(json_packet_data, "n", "                           !");
                               
                               JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
					
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
    SetPlayerData(playerid, P_SKIN, game_id);
    UpdatePlayerDatabaseInt(playerid, "skin", game_id);
    SetPlayerSkin(playerid, game_id);
    SetPlayerSkinInit(playerid);
}

public: ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:json_packet_data = JSON_Object(), outcoming_data[512];

    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);

    JSON_SetInt(json_packet_data, "g", internal_id);

    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

    JSON_SetString(json_packet_data, "m", "                           -");
    JSON_SetString(json_packet_data, "n", pack_name);

    JSON_Stringify(json_packet_data, outcoming_data);
    OnPacketIncoming(playerid, 22, outcoming_data);

    JSON_Cleanup(json_packet_data);
}