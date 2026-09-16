#include "../gamemodes/api/notification.inc"

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
                    OnPacketIncomingg(playerid, 38, outcoming_data);
                    
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
                        ShowNewNotification(playerid, 2, 5, -1, -1, "Ошибка при создании аккаунта, попробуйте снова!");
                        Kick:(playerid);
                    }

                    JSON_Stringify(json_packet_data, outcoming_data);
                    OnPacketIncomingg(playerid, 38, outcoming_data);
                    
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
                        OnPacketIncomingg(playerid, 38, outcoming_data);

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
                    OnPacketIncomingg(playerid, 38, outcoming_data);

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
                        OnPacketIncomingg(playerid, 38, outcoming_data);

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
        
        case 50:
        {
            new
                spawn_id;

            JSON_GetInt(json, "t", spawn_id);

            switch(spawn_id)
            {
                case 1:
                {
                    new spawn_id_int = random(3);
	
                    SetSpawnInfo
                    (
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        spawn_pos_data[spawn_id_int][0],
                        spawn_pos_data[spawn_id_int][1],
                        spawn_pos_data[spawn_id_int][2],
                        spawn_pos_data[spawn_id_int][3],
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

            OnPacketIncomingg(playerid, 50, outcoming_data);

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
                                ShowNewNotification(playerid, 2, 5, -1, -1, "Недостаточно средств!");
                            }
                            else
                            {
                                GivePlayerMoneyEx(playerid, -1500);
                                
                                JSON_SetInt(json_packet_data, "t", 1);
                                JSON_SetInt(json_packet_data, "s", 0);

                                JSON_Stringify(json_packet_data, outcoming_data);

                                OnPacketIncomingg(playerid, 37, outcoming_data);
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
					case ENTER_ENGINE:
					{
					callcmd::e(playerid, "");
					}
					case ENTER_CONT:
					{
					callcmd::cont(playerid);
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
                 SendClientMessage(playerid, 0xFFFFFFFF, "{FFFF00}| {FFFFFF}РўР°РєСЃРё: РќРµ РїРѕРґРґРµСЂР¶РёРІР°РµС‚СЃСЏ");
                }

                case 2:
                {
                 callcmd::mm(playerid, "");
                }

                case 3:
                {
                 SendClientMessage(playerid, 0xFFFFFFFF, "communication");
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

            JSON_SetInt(json_packet_data, "i", 1);
            JSON_Stringify(json_packet_data, outcoming_data);

            OnPacketIncomingg(playerid, 14, outcoming_data);

            JSON_Cleanup(json_packet_data);
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
                    OnPacketIncomingg(playerid, 22, outcoming_data);

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
                        OnPacketIncomingg(playerid, 22, outcoming_data);

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
                                OnPacketIncomingg(playerid, 22, outcoming_data);

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
                            OnPacketIncomingg(playerid, 22, outcoming_data);

                            JSON_Cleanup(json_packet_data);
                        }
                        case 475, 462, 463, 457, 458, 419, 430, 431, 425, 420, 421, 399, 390, 391, 392, 393, 394, 395, 396, 397, 398, 346, 344, 345, 332, 333, 334, 335, 340, 336, 337, 338, 339, 341, 342, 343, 315, 313, 311, 322, 323, 324, 314, 312, 316, 317, 318, 319, 320, 321, 325, 326, 238, 257, 239, 240, 225, 226, 227, 228, 205, 206, 207, 208, 91, 92, 229, 93, 94, 230, 95, 96, 97, 203, 231, 232, 233, 234, 235, 98, 99, 100, 101, 236, 237, 209, 210:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            JSON_SetInt(json_packet_data, "g", internal_id);

                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);

                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели одежду");
                            JSON_SetString(json_packet_data, "n", "Для того чтобы одеть её, используйте инвентерь");

                            JSON_Stringify(json_packet_data, outcoming_data);
                            OnPacketIncomingg(playerid, 22, outcoming_data);

                            JSON_Cleanup(json_packet_data);

                            BuyPlayerSkin(playerid, internal_id, FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids)));

                            GivePlayerDonateRub(playerid, -price);
                        }
                        
                        
                        //услуги 
                                case 102: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 50)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу: Изменение имени");
                                    
                                    ShowPlayerChangeNameDialog(playerid);

                                    GivePlayerDonateRub(playerid, -50, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //варн
                                case 103: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу: Снятие предупреждения");
                                    
                                    SetPlayerData(playerid, P_WARN, 		0);
                                    SetPlayerData(playerid, P_WARN_TIME, 	0);

                                    UpdatePlayerDatabaseInt(playerid, "warn", 		0);
                                    UpdatePlayerDatabaseInt(playerid, "warn_time", 	0);

                                    GivePlayerDonateRub(playerid, -100, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //лицензии
                                case 104: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 150)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу Все лицензии");

                                    SetPlayerData(playerid, P_DRIVING_LIC, GetPlayerData(playerid, P_DRIVING_LIC) ^ 1);
                                    UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));

                                    GivePlayerDonateRub(playerid, -150, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //быстрое лечение
                                case 106: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 75)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу Быстрое лечение");

                                    SetPlayerData(playerid, P_HEALTH, 100);
	                                SetPlayerHealthEx(playerid, 100);

                                    GivePlayerDonateRub(playerid, -75, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //изменения имя семьи
                                case 107: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу Изменения имья семьи");

                                    ShowChangeNameDialog(playerid);

                                    GivePlayerDonateRub(playerid, -100, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //передать семью
                                case 108: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу: Передать семью");


                                    GivePlayerDonateRub(playerid, -100, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //венный билет
                                case 109: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 130)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу Военный билет");


                                    GivePlayerDonateRub(playerid, -130, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                                case 111: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 500)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу Колонку");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили колонку!");

                                    GivePlayerDonateRub(playerid, -500, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //саббуфер
                                case 112: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 1000)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу Колонку");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили Саббуфер, что бы использывать пропишите /anymusic");

                                    GivePlayerDonateRub(playerid, -1000, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //слот для дома
                                case 113: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 2500)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу: Доп. Слот для дома");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили доп слот для дома");

                                    GivePlayerDonateRub(playerid, -2500, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //слот для бизнеса
                        
                        case 114: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 5000)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили услугу: Доп. Слот для бизнеса");

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили доп слот на бизнес");

                                    GivePlayerDonateRub(playerid, -5000, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //пониженный износ
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
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
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
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
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

                                    SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили мед. карту");

                                    GivePlayerDonateRub(playerid, -100, "тест", true);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
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
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
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
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //доп слот на авто в семью
                        case 120: {
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
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
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
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //доп слот на авто
                        case 122: {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 1);

                                if(GetPlayerDonateRub(playerid) >= 100)
                                {
                                    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                    JSON_SetString(json_packet_data, "m", "Успешная операция");
                                    JSON_SetString(json_packet_data, "n", "вы купили доп. слот на авто");

                                    GivePlayerDonateRub(playerid, -100, "тест", true);
                                    
                                    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
			UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
			
			new fmt_text[200];
			
			format(fmt_text, sizeof fmt_text, "Вы купили слот для транспорта. Текущее количество слотов: %d",
			GetPlayerData(playerid, P_CAR_SLOTS));
			SendClientMessage(playerid, 0x66CC00FF, fmt_text);

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }

                        }
                        //номерной знак
                        case 123: {
                                if(GetPlayerDonateRub(playerid) >= 85)
                                {
                                    callcmd::buynomber(playerid, "");
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
                                }
                        }
                        
                        case 124: {
                                if(GetPlayerDonateRub(playerid) >= 70)
                                {
                                    callcmd::buyphonenum(playerid, "");
                                }
                                else {
                                    JSON_SetInt(json_packet_data, "t", 0);
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "k", 1);

                                    JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncomingg(playerid, 22, outcoming_data);
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
			
	    case GUIRadialMenuForCar:
    	{
			new vehicleid = GetPlayerVehicleID(playerid);
			new index = GetVehicleData(vehicleid, V_ACTION_ID);

	        new type;
	        JSON_GetInt(json, "t", type);
	        switch(type)
	        {
	        	//case 0: //Закрытие
			    case 1: callcmd::park(playerid);
			    case 2:
			    {
			     	callcmd::key(playerid);
			     	if(GetOwnableCarData(index, OC_KEY_IN)) 	JSON_SetInt(json, "s", 1);
					else 										JSON_SetInt(json, "s", 0);
			    }
			    case 3:
			    {
			     	callcmd::lock(playerid);
			     	if(GetVehicleParam(vehicleid, V_LOCK)) 	JSON_SetInt(json, "s", 1);
			     	else 									JSON_SetInt(json, "s", 0);
			    }
			    case 5:
			    {
					if(vInfo[vehicleid][vLaunchControl])
					{
						SetVehicleLaunchControl(vehicleid, 1);
						JSON_SetInt(json, "c", 1);
					}
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не утановлен лаунч-контроль.", "");
			    }
			    case 6:
			    {
			     	callcmd::e(playerid);

			     	if(GetVehicleParam(vehicleid, V_ENGINE)) 	JSON_SetInt(json, "s", 1);
			     	else 										JSON_SetInt(json, "s", 0);
					OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

					if(!GetVehicleParam(vehicleid, V_ENGINE))
					{
						JSON_SetInt(json, "s", 0);

						JSON_SetInt(json, "t", 12);
						OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

						JSON_SetInt(json, "t", 13);
						OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

						JSON_SetInt(json, "t", 14);
						OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

						JSON_SetInt(json, "t", 15);
     				}
			 	}
			    case 8: //Дрифт
			    {
			     	ShowNotificationNew(playerid, 2, 3, 99, 0, "У Вас не установлена эта прошивка!", "");
			    }
			    case 9: //Комфорт
			    {
			     	ShowNotificationNew(playerid, 2, 3, 99, 0, "У Вас не установлена эта прошивка!", "");
			    }
			    case 10: //Спорт
			    {
			     	ShowNotificationNew(playerid, 2, 3, 99, 0, "У Вас не установлена эта прошивка!", "");
			    }
			    case 11: //Спорт+
			    {
			     	ShowNotificationNew(playerid, 2, 3, 99, 0, "У Вас не установлена эта прошивка!", "");
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
								JSON_SetInt(json, "s", 1);
							}
							else
							{
							    vInfo[vehicleid][vEnableNeon] = false;
						 		SetVehicleLightingColor(vehicleid, 0x00000000, 0x00000000, 0x00000000);
								JSON_SetInt(json, "s", 0);
							}
						}
					}
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "У Вас не установлена подсветка!", "");
			    }
			    case 13:
			    {
					if(vInfo[vehicleid][vHighLights])
					{
						if(GetVehicleParam(vehicleid, V_ENGINE))
						{
						    if(!vInfo[vehicleid][vEnableHighLights])
							{
							    vInfo[vehicleid][vEnableHighLights] = true;
				     			SetVehicleHighLight(vehicleid, 1);
								SetVehicleParam(vehicleid, V_ENGINE, true);
								SetVehicleParam(vehicleid, V_LIGHTS, true);

								JSON_SetInt(json, "s", 1);
								OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

								JSON_SetInt(json, "t", 14);
							}
							else
							{
							    vInfo[vehicleid][vEnableHighLights] = false;
				     			SetVehicleHighLight(vehicleid, 0);
							    //SetVehicleProperties(vehicleid);
								JSON_SetInt(json, "s", 0);
							}
						}
					}
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не установлен дальний свет фар.", "");
			    }
			    case 14:
			    {
			     	callcmd::l(playerid);
			     	if(GetVehicleParam(vehicleid, V_LIGHTS)) JSON_SetInt(json, "s", 1);
			     	else
				 	{
					 	JSON_SetInt(json, "s", 0);
						OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

						JSON_SetInt(json, "t", 13);
						OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

						JSON_SetInt(json, "t", 14);
						OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

						JSON_SetInt(json, "t", 15);
					}
			    }
			    case 15:
				{
					if(vInfo[vehicleid][vStrob])
					{
						if(GetVehicleParam(vehicleid, V_ENGINE))
						{
						    if(!vInfo[vehicleid][vEnableStrob])
							{
							    vInfo[vehicleid][vEnableStrob] = true;
								SetVehicleParam(vehicleid, V_ENGINE, true);
								SetVehicleParam(vehicleid, V_LIGHTS, true);
				     			SetVehicleStroboscope(vehicleid, vInfo[vehicleid][vStrob]-1);

								SetVehicleLightProperties(vehicleid, GetVehicleParam(vehicleid, V_LIGHTS), vInfo[vehicleid][vStrob]);

								JSON_SetInt(json, "s", 1);
								OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);

								JSON_SetInt(json, "t", 14);
							}
							else
							{
							    vInfo[vehicleid][vEnableStrob] = false;
				     			SetVehicleStroboscope(vehicleid, 5);
								SetVehicleParam(vehicleid, V_ENGINE, true);
								SetVehicleParam(vehicleid, V_LIGHTS, true);
								SetVehicleLightProperties(vehicleid, GetVehicleParam(vehicleid, V_LIGHTS), vInfo[vehicleid][vStrob]);
								JSON_SetInt(json, "s", 0);
							}
						}
					}
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не установлены стробоскопы.", "");
			    }
			    case 16:
			    {
			     	SCM(playerid, CWHITE, "Система (Пневмо1) находиться в разработке!");
			    }
			    case 17:
			    {
			     	SCM(playerid, CWHITE, "Система (Пневмо2) находиться в разработке!");
			    }
			    case 18:
			    {
			     	SCM(playerid, CWHITE, "Система (Пневмо3) находиться в разработке!");
			    }
			    case 19:
			    {
			     	//callcmd::gidra(playerid);
					if(vInfo[vehicleid][vHydraulics])
					{
					    if(!vInfo[vehicleid][vEnableHydraulics])
						{
						    vInfo[vehicleid][vEnableHydraulics] = true;
							//AddVehicleComponent(vehicleid, 1087);
							SetVehicleHydraulics(vehicleid, 1);
							JSON_SetInt(json, "s", 1);
						}
				 		else
				 		{
				 		    vInfo[vehicleid][vEnableHydraulics] = false;
				 		    RemoveVehicleComponent(vehicleid, 1087);
							SetVehicleHydraulics(vehicleid, 0);
							JSON_SetInt(json, "s", 0);
				 		}
					}
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "У Вас не установлена гидравлика!", "");
			    }
	        }
			OnPacketIncomingNew(playerid, GUIRadialMenuForCar, json);
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

    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели набор -");
    JSON_SetString(json_packet_data, "n", pack_name);

    JSON_Stringify(json_packet_data, outcoming_data);
    OnPacketIncomingg(playerid, 22, outcoming_data);

    JSON_Cleanup(json_packet_data);
}