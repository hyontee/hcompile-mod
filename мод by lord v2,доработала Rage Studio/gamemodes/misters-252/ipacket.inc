
// --- пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅ пїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ
#define ENTER_CONT      3
#define OFFER_YES       4
#define OFFER_ENGINE 	5
#define OFFER_UNLOCK_CAR 8 // ID для открытия дверей
#define OFFER_OPEN_DOOR 9
#define OFFER_KPP_VZLOM 10
#define OFFER_KPP 11
#define EXIT_HOME 6
#define GUI_LOCK 7
#include "../include/json.inc"
#define pc_cmd_buyslotfam(%0) 1
#define pc_cmd_buynamefam(%0) 1
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
    {524, 622}
};

new clothes_game_ids[][2] = {
    {210, 122},
    {209, 270},
    {344, 302},
    {345, 301},
    {338, 89},
    {339, 88},
    {341, 10},
    {342, 92},
    {343, 99},
    {231, 208},
    {535, 6871},
    {536, 6872},
    {529, 6894},
    {337, 243},
    {527, 6892},
    {425, 5362},
    {346, 2},
    {333, 129},
    {334, 130},
    {335, 24},
    {340, 197},
    {336, 245},
    {316, 165},
    {317, 166},
    {318, 174},
    {319, 5},
    {320, 267},
    {321, 283},
    {325, 162},
    {326, 210},
    {390, 310},
    {395, 18624},
    {396, 18625},
    {398, 18628},
    {397, 18626},
    {232, 199},
    {233, 264},
    {234, 262},
    {235, 62},
    {391, 18621},
    {392, 311},
    {393, 18620},
    {394, 18623},
    {98, 200},
    {99, 234},
    {100, 249},
    {101, 235},
    {332, 196},
    {322, 49},
    {323, 53},
    {324, 160},
    {207, 48},
    {236, 298},
    {237, 266},
    {399, 18606},
    {312, 106},
    {230, 175},
    {95, 202},
    {314, 109},
    {528, 6895},
    {526, 6896},
    {525, 6893},
    {519, 6832},
    {513, 19262},
    {419, 5323},
    {430, 5326},
    {431, 5325},
    {96, 204},
    {97, 229},
    {203, 57},
    {480, 11934},
    {481, 11933},
    {482, 11935},
    {483, 11944},
    {488, 11953},
    {489, 11948},
    {490, 11951},
    {491, 11947},
    {492, 11957},
    {497, 11959},
    {313, 108},
    {311, 95},
    {206, 236},
    {93, 220},
    {94, 225},
    {229, 231},
    {516, 11961},
    {517, 11962},
    {486, 11956},
    {487, 11958},
    {208, 63},
    {91, 23},
    {92, 22},
    {420, 5367},
    {421, 5365},
    {514, 19273},
    {515, 6780},
    {475, 11917},
    {205, 252},
    {462, 12293},
    {463, 12291},
    {457, 14386},
    {458, 14388},
    {228, 269},
    {315, 110},
    {225, 86},
    {226, 224},
    {227, 232}
};
new accessories_game_ids[][2] = {
    {531, 2656},   // internalId, modelId - Надувной жилет
    {534, 677},    // Советская шапка
    {533, 676},    // Очки люкс
    {530, 2655},   // Шлем велосипедиста
    {532, 2657},   // Очки звездочки
    {518, 16055},  // Лапка анимированная
    {493, 9824},   // Веселая тыква
    {494, 9826},   // Маска зомби
    {495, 9827},   // Кукла вуду
    {496, 9828},   // Призрачный портал
    {476, 11919},  // Акула на голову
    {478, 11923},  // Мопс на спину
    {422, 13883},  // Корона демона
    {423, 14575},  // Крылья ангела
    {368, 18509},  // Кейс
    {361, 18504},  // Тролль с париком
    {362, 18505},  // Инопланетянин с париком
    {308, 18411},  // Голубой посох
    {369, 18510},  // Кейс черный
    {370, 18511},  // Кейс серый
    {371, 18512},  // Золотая корона
    {372, 18513},  // Корона короля
    {277, 18233},  // Деревянный посох
    {279, 18243},  // Карамельная конфета
    {285, 18285},  // Посох-зонт
    {287, 18346},  // Синий посох со льдом
    {288, 18347},  // Синий посох со снежинкой
    {289, 18348},  // Голубой посох со льдом
    {290, 18369},  // Новогодний топорик
    {291, 18375},  // Новогодняя палочка
    {292, 18377},  // Очки-сердечки
    {293, 18378},  // Рюкзак 'Котик'
    {294, 18379},  // Рюкзак 'Санта-Клауса'
    {298, 18389},  // Новогодняя шапка
    {299, 18390},  // Очки моргающие глаза
    {300, 18391},  // Очки Пламя
    {301, 18392},  // Прямые очки с огнем
    {302, 18396},  // Шапка гнома
    {303, 18397},  // Зеленая маска
    {304, 18401},  // Очки с салютом
    {305, 18404},  // Прямые очки матрица
    {306, 18409},  // Очки падающие снежинки
    {307, 18410},  // Очки веселый Сквиди
    {309, 18412},  // Очки санрайз у воды
    {310, 18414},  // Прямые очки WARNING
    {274, 15158},  // Кепка
    {253, 15157},  // Рюкзак
    {266, 15151},  // Маска ведущего
    {373, 18514},  // Серебряная корона
    {374, 18515},  // Лавровый венец
    {375, 18516},  // Диадема
    {357, 18500},  // Маска клоуна
    {358, 18501},  // Маска клоуна
    {359, 18502},  // Лицо тролля
    {360, 18503},  // Инопланетянин
    {363, 18506},  // Очки с носом
    {278, 18232},  // Берет
    {280, 18250},  // Белая панама с сигарой
    {295, 18383},  // Черная панама с сигарой
    {296, 18384},  // Серая панама с сигарой
    {297, 18385},  // Темная панама с сигарой
    {281, 18263},  // Белая панама от
    {282, 18264},  // Черная панама от
    {283, 18273},  // Высокая панама от
    {284, 18279},  // Черная шапка
    {286, 18286},  // Кандибобер
    {247, 15141},  // Шляпа
    {248, 15144},  // Неоновая маска (красная)
    {249, 15152},  // Неоновая маска синяя
    {250, 15154},  // Неоновая маска зеленая
    {251, 15153},  // Неоновая маска фиолетовая
    {252, 15155},  // Неоновая маска оранжевая
    {477, 11922},  // ГеймБой
    {479, 11925},  // Летняя доска
    {463, 13801},  // Катюша
    {464, 13803},  // Рюкзак солдатик
    {432, 14589},  // Маска оленя
    {433, 14591},  // Белые рога
    {434, 14592},  // Уши эльфа
    {436, 14596},  // Маска елочки
    {437, 14597},  // Рождественские рога
    {438, 14598},  // Маска Деда Мороза
    {439, 14603},  // Шапка-Ушанка
    {440, 4160},   // Новогодний кекс
    {441, 4161},   // Новогодний мишка
    {442, 4162},   // Маска Снегурочка
    {443, 4163},   // Маска Снеговика
    {435, 4165},   // Сумка Снеговика
    {376, 18517},  // Очки Доллар
    {377, 18518},  // Очки День рождения
    {379, 18520},  // Неоновые очки
    {380, 18521},  // Неоновые очки
    {381, 18522},  // Неоновые очки
    {383, 18524},  // Неоновые очки
    {384, 18525},  // Неоновые очки
    {385, 18526},  // Очки пиксели
    {386, 18527},  // Шар сердце
    {389, 18530},  // Шар сердце 2
    {354, 18497},  // Шарик красный
    {365, 18508},  // Парик клоуна красный
    {241, 15135},  // Шляпа ведьмы (светящаяся)
    {242, 15136},  // Шляпа ведьмы (светящаяся)
    {255, 15143},  // Красная коса
    {265, 15159},  // Маска квадрата
    {355, 18498},  // Очки 'Выпуклые глаза'
    {356, 18499},  // Очки 'Обычные глаза'
    {364, 18507},  // Нос клоуна
    {264, 15161},  // Маска треугольника
    {267, 15149},  // Метла
    {259, 15145},  // Маска Джейсона
    {260, 15146},  // Маска Ведьмы
    {261, 15147}   // Маска Пилы
};
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
	
case 34:
        {
            Trunk_HandlePacket(playerid, JSONObject);
JSON_Cleanup(JSONObject);
return 1;
        }
 
        case 33:
        {
            new inv_type = -1;
            JSON_GetInt(JSONObject, "t", inv_type);

            if(g_TrunkVehicleDB[playerid] > 0)
            {
                switch(inv_type)
                {
                    case 0, 1, 2, 8, 23, 24:
                    {
                        if(Trunk_HandlePacket(playerid, JSONObject))
                        {
                            JSON_Cleanup(JSONObject);
                            return 1;
                        }
                    }
                }
            }

            Inventory_HandlePacket(playerid, JSONObject);
JSON_Cleanup(JSONObject);
return 1;
        }
        case 27:
     {
			new vehid = GetFreeOwnableCarID(playerid);
			new vehicleid = GetPlayerVehicleID(playerid);
			new index = GetVehicleData(vehicleid, V_ACTION_ID);

	        new type;
	        JSON_GetInt(JSONObject, "t", type);
	        switch(type)
	        {
			    case 1: callcmd::park(playerid);
			    case 2:
			    {
			     	callcmd::key(playerid);
			     	if(GetOwnableCarData(index, OC_KEY_IN)) 	JSON_SetInt(JSONObject, "s", 1);
					else 										JSON_SetInt(JSONObject, "s", 0);
			    }
			    case 3:
			    {
			     	callcmd::lock(playerid);
			     	if(GetVehicleParam(vehicleid, V_LOCK)) 	JSON_SetInt(JSONObject, "s", 1);
			     	else 									JSON_SetInt(JSONObject, "s", 0);
			    }
			    case 5:
			    {
					//ShowNotificationMisters(playerid, 2, 3, 99, 0, "? ???? ?? ????????? ?????-????????.", "");
			    }
			    case 6:
			    {
			     	callcmd::e(playerid);

			     	if(GetVehicleParam(vehicleid, V_ENGINE)) 	JSON_SetInt(JSONObject, "s", 1);
			     	else 										JSON_SetInt(JSONObject, "s", 0);
					OnPacketIncoming(playerid, GUIRadialMenuForCar, JSONObject);

					if(!GetVehicleParam(vehicleid, V_ENGINE))
					{
						JSON_SetInt(JSONObject, "s", 0);

						JSON_SetInt(JSONObject, "t", 12);
						OnPacketIncoming(playerid, GUIRadialMenuForCar, JSONObject);

						JSON_SetInt(JSONObject, "t", 13);
						OnPacketIncoming(playerid, GUIRadialMenuForCar, JSONObject);


						JSON_SetInt(JSONObject, "t", 15);
     				}
			 	}
			    case 8: //Дрифт
			    {
			     	ShowNotificationMisters(playerid, 2, 6, 0, 0, "У Вас не установлена эта прошивка", "");
			    }
			    case 9: //Комфорт
			    {
			     	ShowNotificationMisters(playerid, 2, 6, 0, 0, "У Вас не установлена эта прошивка", "");
			    }
			    case 10: //Спорт
			    {
			     	ShowNotificationMisters(playerid, 2, 6, 0, 0, "У Вас не установлена эта прошивка", "");
			    }
			    case 11: //Спорт+
			    {
			     	ShowNotificationMisters(playerid, 2, 6, 0, 0, "У Вас не установлена эта прошивка", "");
			    }
			    case 12:
			    {
			      ShowNotificationMisters(playerid, 2, 6, 0, 0, "У Вас не установлена подсветка", "");
			    }
			    case 13:
			    {
					ShowNotificationMisters(playerid, 2, 6, 0, 0, "В автомобиле не установлен дальний свет фар", "");
			    }
			    case 14:
			    {
			     	callcmd::l(playerid);
			     	if(GetVehicleParam(vehicleid, V_LIGHTS)) JSON_SetInt(JSONObject, "s", 1);
			     	else
				 	{
					 	JSON_SetInt(JSONObject, "s", 0);
						OnPacketIncoming(playerid, GUIRadialMenuForCar, JSONObject);

						JSON_SetInt(JSONObject, "t", 13);
						OnPacketIncoming(playerid, GUIRadialMenuForCar, JSONObject);

						JSON_SetInt(JSONObject, "t", 14);
						OnPacketIncoming(playerid, GUIRadialMenuForCar, JSONObject);

						JSON_SetInt(JSONObject, "t", 15);
					}
			    }
			    case 15:
				{
					ShowNotificationMisters(playerid, 2, 6, 0, 0, "В автомобиле не установлены страбоскопы", "");
			    }
			    case 16:
			    {
			     	SCM(playerid, COLOR_WHITE, "Система (Пневмо1) находиться в разработке!");
			    }
			    case 17:
			    {
			     	SCM(playerid, COLOR_WHITE, "Система (Пневмо2) находиться в разработке!");
			    }
			    case 18:
			    {
			     	SCM(playerid, COLOR_WHITE, "Система (Пневмо3) находиться в разработке!");
			    }
			    case 19:
			    {
                    if(vInfo[vehicleid][vHydraulics])
                    {
                       if(!vInfo[vehicleid][vEnableHydraulics])
                       {
                          vInfo[vehicleid][vEnableHydraulics] = true;
                          SetVehicleHydraulics(vehicleid, 1);
                          JSON_SetInt(JSONObject, "s", 1);
                       }
                       else
                      {
                          vInfo[vehicleid][vEnableHydraulics] = false;
                          RemoveVehicleComponent(vehicleid, 1087);
                          SetVehicleHydraulics(vehicleid, 0);
                          JSON_SetInt(JSONObject, "s", 0);
                      }
			    }
                else
                    ShowNotificationMisters(playerid, 2, 3, 99, 0, "У Вас не установлена гидравлика!", "");
                }
	        }
	
		OnPacketIncoming(playerid, GUIRadialMenuForCar, JSONObject);
     }
        case 14:
        {
            new t, i;

            JSON_GetInt(JSONObject, "t", t);
            JSON_GetInt(JSONObject, "i", i);

            switch(t)
            {
                case 0:
                {
                    callcmd::gps(playerid, "");
                }

                case 1:
                {
                    ShowNotificationMisters(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }

                case 2:
                {
                    callcmd::mm(playerid, "");
                }

                case 3:
                {
                    //SendClientMessage(playerid, 0xFFFFFFFF, "communication");
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

                case 10:
                {
                    ShowNotificationMisters(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }

                case 11:
                {
                    ShowNotificationMisters(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }

                case 12:
                {
                    ShowNotificationMisters(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }
				
				case 13:
				{
				    Cases_ShowGUI(playerid);
				}
            }

            new Node:json_packet_data = JSON_Object();
            JSON_SetInt(json_packet_data, "i", 1);

            new outcoming_data[256];
            JSON_Stringify(json_packet_data, outcoming_data);

            OnPacketIncoming(playerid, 14, json_packet_data);

            JSON_Cleanup(json_packet_data);
        }
        case 3:
        {
            new type, playerMoney, orderMask;
            new totalPrice = 0;
            new plusgolod = 0;
            new itemsPurchased[6];

            JSON_GetInt(JSONObject, "t", type);
            JSON_GetInt(JSONObject, "m", playerMoney);

            if(type == 0)
            {
                return 1;
            }
            else if(type == 1)
            {
                JSON_GetInt(JSONObject, "r", orderMask);

                for(new i = 0; i < 6; i++)
                {
                    if(orderMask & (1 << i))
                    {
                        switch(i + 1)
                        {
                            case 1:
                            {
                                totalPrice += 120;
                                plusgolod += 5;
                                itemsPurchased[i] = 1;
                            }
                            case 2:
                            {
                                totalPrice += 230;
                                plusgolod += 10;
                                itemsPurchased[i] = 1;
                            }
                            case 3:
                            {
                                totalPrice += 320;
                                plusgolod += 15;
                                itemsPurchased[i] = 1;
                            }
                            case 4:
                            {
                                totalPrice += 580;
                                plusgolod += 20;
                                itemsPurchased[i] = 1;
                            }
                            case 5:
                            {
                                totalPrice += 80;
                                plusgolod += 3;
                                itemsPurchased[i] = 1;
                            }
                            case 6:
                            {
                                totalPrice += 30;
                                plusgolod += 2;
                                itemsPurchased[i] = 1;
                            }
                        }
                    }
                }
            }

            if(g_player[playerid][P_GOLOD] >= 100) return ShowNotificationMisters(playerid, 2, 4, 0, 0, "сасеш", "");

            if(GetPlayerMoney(playerid) >= totalPrice)
            {
                GivePlayerMoneyEx(playerid, -totalPrice);

                for(new i = 0; i < 6; i++)
                {
                    if(itemsPurchased[i])
                    {
                        switch(i + 1)
                        {
                            case 1:
                            {
                                g_player[playerid][P_GOLOD] += 5;
                            }
                            case 2:
                            {
                                g_player[playerid][P_GOLOD] += 10;
                            }
                            case 3:
                            {
                                g_player[playerid][P_GOLOD] += 15;
                            }
                            case 4:
                            {
                                g_player[playerid][P_GOLOD] += 20;
                            }
                            case 5:
                            {
                                g_player[playerid][P_GOLOD] += 3;
                            }
                            case 6:
                            {
                                g_player[playerid][P_GOLOD] += 2;
                            }
                        }
                    }
                }

                new message[128];
                format(message, sizeof(message), "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅ {FFFF00}%d {FFFFFF}пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ {FFFF00}%d {FFFFFF}пїЅпїЅпїЅпїЅпїЅпїЅ.", totalPrice, plusgolod);
               // SendClientMessage(playerid, -1, message);
            }
            else
            {
                // ShowNotificationMisters(playerid, 2, 5, 1, 1, "сасеш тест пїЅпїЅпїЅпїЅпїЅпїЅпїЅ.", "");
            }

            new Node:json_packet_data = JSON_Object();
            JSON_Stringify(json_packet_data, json_data);
            OnPacketIncoming(playerid, 3, json_packet_data);
            JSON_Cleanup(json_packet_data);
        }
        case 45:
        {
       	PacketIncomingFamily(playerid, JSONObject);
       JSON_Cleanup(JSONObject);
        } 

case 28:
    {
   	  PacketIncomingTuning(playerid, JSONObject);
  	  JSON_Cleanup(JSONObject);
    }
case 73:
        {
            Cases_SendPacketToClient(playerid, json_data);
            JSON_Cleanup(JSONObject);
        }
case 74:
    {
        Rewards_OnPacket(playerid, JSONObject);
        JSON_Cleanup(JSONObject);
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
                        ShowNotificationMisters(playerid, 2, 5, -1, -1, "вова тест пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ!", "");
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
                        ShowNotificationMisters(playerid, 2, 5, -1, -1, "тест вааава пїЅпїЅпїЅпїЅпїЅ пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ!", "");
                        return 1;
                    }

                    new Node:json_packet_data = JSON_Object();
                    JSON_Stringify(json_packet_data, json_data);
                    OnPacketIncoming(playerid, 38, json_packet_data);
                    JSON_Cleanup(json_packet_data);
                    return 1;
                }
                
        case 66:

{

    new buttonId, screenType, closeFlag;

    

    JSON_GetInt(JSONObject, "b", buttonId);

    JSON_GetInt(JSONObject, "t", screenType);

    JSON_GetInt(JSONObject, "c", closeFlag);

    

    if(closeFlag == 1)

    {

        StopSpectate(playerid);

        return 1;

    }

    

    new targetid = GetPlayerSpectateData(playerid, S_PLAYER);

    

    if(targetid == -1 || !IsPlayerConnected(targetid))

    {

        ShowNotificationMisters(playerid, 2, 6, 0, 0, "Такого игрока нет", "");

        return 1;

    }

    

    switch(buttonId)

    {

        case 1:

        {

            if(GetPlayerSpectateData(playerid, S_PLAYER) != -1)

            {

                SetPlayerInterior(playerid, GetPlayerInterior(targetid));

                SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(targetid));

                

                PlayerSpectatePlayer(playerid, targetid);

                

                ShowSpectateGUI(playerid, targetid);

            }

        }

        

        case 2:

        {

            new prevPlayer = FindPreviousPlayer(targetid);

            if(prevPlayer != -1)

            {

                StartSpectate(playerid, prevPlayer);

                ShowSpectateGUI(playerid, prevPlayer);

            }

            else

            {

                ShowNotificationMisters(playerid, 2, 6, 0, 0, "Больше игроков нет", "");

            }

        }

        

        case 3:

        {

            ShowPlayerDialog(playerid, DIALOG_ADMIN_KICK, DIALOG_STYLE_LIST,

                "Кик игрока",

                "Кик с причиной\nКик без причины",

                "Далее", "Закрыть");

        }

        

        case 4:

        {

            ShowPlayerDialog(playerid, DIALOG_ADMIN_MUTE, DIALOG_STYLE_LIST,

                "Выдать/снять мут игроку", 

                "Выдать мут с причиной\nСнять мут",

                "Далее", "Закрыть");

        }

        

        case 5:

        {

            ShowPlayerDialog(playerid, DIALOG_ADMIN_JAIL, DIALOG_STYLE_LIST,

                "Посадить игрока в тюрьму либо выпустить",

                "Посадить\nВыпустить",

                "Далее", "Закрыть");

        }

        

        case 6:

        {

            ShowPlayerDialog(playerid, DIALOG_ADMIN_WARN, DIALOG_STYLE_LIST,

                "Выдать/снять предупреждение игроку",

                "Выдать предупреждение\nСнять предупреждения",

                "Далее", "Закрыть");

        }

        

        case 7:

        {

            ShowPlayerDialog(playerid, DIALOG_ADMIN_SLAP, DIALOG_STYLE_LIST,

                "Подбросить вверх/вниз игрока",

                "Подбросить вверх\nПодбросить вниз",

                "Далее", "Закрыть");

        }

        

        case 8:

        {

            ShowPlayerDialog(playerid, DIALOG_ADMIN_BAN, DIALOG_STYLE_LIST,

                "Выдать бан аккаунта игроку",

                "Временный бан\nПерманентный бан",

                "Далее", "Закрыть");

        }

        

        case 9:

        {

            new nextPlayer = FindNextPlayer(targetid);

            if(nextPlayer != -1)

            {

                StartSpectate(playerid, nextPlayer);

                ShowSpectateGUI(playerid, nextPlayer);

            }

            else

            {

                ShowNotificationMisters(playerid, 2, 6, 0, 0, "Больше игроков нет", "");

            }

        }

        

        case 10:

        {

            new params[128];

		    format(params, sizeof(params), "%d", targetid);

		    callcmd::stats(playerid, params);

        }

        

        case 11:

        {

            callcmd::af(playerid, "");

        }

        

        default:

        {

            printf("[IPacket:66] Unknown button: %d", buttonId);

        }

    }

    

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

    GiveDefaultLicenses(playerid);

    new reason[144];

	// бонус донат
	SetPlayerData(playerid, P_DONATE_RUB, bonus_donate);
	UpdatePlayerDatabaseInt(playerid, "rub", bonus_donate);

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

    new query[90];
    mysql_format(mysql, query, sizeof(query), "UPDATE accounts SET skin=%d, last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
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
                        ShowNotificationMisters(playerid, 2, 5, -1, -1, "Неверный пароль!", "");
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
            SetPlayerPosEx
            (
                playerid,
                spawn_pos_data[0][0], // Замени на координаты вокзала
                spawn_pos_data[0][1],
                spawn_pos_data[0][2],
                spawn_pos_data[0][3],
                0, 0
            );
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
                        case OFFER_ENGINE:
                        {
                            callcmd::e(playerid, "");
                        }
                        case OFFER_UNLOCK_CAR: // ID для открытия дверей:
                        {
                            callcmd::lock(playerid, "");
                        }
                        case OFFER_OPEN_DOOR:
                        {
                            callcmd::opendoor(playerid, "");
                        }
                        case OFFER_KPP_VZLOM:
                        {
                            callcmd::vzlom(playerid, "");
                        }
                        case OFFER_KPP:
                        {
                            callcmd::kpp(playerid, "");
                        }
                        case OFFER_YES_CHANGE:
                        {
                            callcmd::yeschange(playerid, "");
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
                        JSON_SetString(json_packet_data, "m", "НЕДОСТАТОЧНО СРЕДСТВ.");
                        JSON_SetString(json_packet_data, "n", "ПОПОЛНИТЕ СЧЕТ ПРЯМО СЕЙЧАС!");
                        JSON_Stringify(json_packet_data, json_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return 1;
                    }

                    switch(internal_id)
                    {
                        case 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90,195,201,202,211,212,213,214,215,216,217,218,219,220,221,222,223,224,275,276,327,328,329,330,331,347,348,349,350,351,352,353,366,367,400,401,402,403,404,405,406,407,408,409,410,411,413,414,415,416,417,418,424,426,427,428,429,444,445,446,447,448,449,450,451,452,453,454,455,456,459,460,461,465,466,467,468,469,470,471,472,473,474,484,485,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,522,523,524:                        {
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

                            BuyPlayerCar(playerid, internal_id, FindGameId(internal_id, car_game_ids, sizeof(car_game_ids)), 0);
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
                        }
                        case 210,209,344,345,338,339,341,342,343,231,535,536,529,337,527,425,346,333,334,335,340,336,316,317,318,319,320,321,325,326,390,395,396,398,397,232,233,234,235,391,392,393,394,98,99,100,101,332,322,323,324,207,236,237,399,312,230,95,314,528,526,525,519,513,419,430,431,96,97,203,480,481,482,483,488,489,490,491,492,497,313,311,206,93,94,229,516,517,486,487,208,91,92,420,421,514,515,475,205,462,463,457,458,228,315,225,226,227:
                        {
                        new game_id = FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids));
                        
                        // printf("[DEBUG] Покупка: internal_id=%d, game_id=%d", internal_id, game_id);
                        
                        if(game_id == -1)
                        {
                            SendClientMessage(playerid, -1, "Ошибка: не найден game_id для этого скина");
                            return 1;
                        }
                        
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

                        GivePlayerOwnableSkin(playerid, game_id); // Передаем game_id, а не internal_id
                        GivePlayerDonateRub(playerid, -price);
                    }
                    case 531,534,533,530,532,518,493,494,495,496,476,478,422,423,368,361,362,308,369,370,371,372,277,279,285,287,288,289,290,291,292,293,294,298,299,300,301,302,303,304,305,306,307,309,310,274,253,266,373,374,375,357,358,359,360,363,278,280,295,296,297,281,282,283,284,286,247,248,249,250,251,252,477,479,464,432,433,434,436,437,438,439,440,441,442,443,435,376,377,379,380,381,383,384,385,386,389,354,365,241,242,255,265,355,356,364,264,267,259,260,261:
                    {
                        new modelid = GetModelIdByInternalId(internal_id);
                        
                        if(modelid == -1)
                        {
                            SendClientMessage(playerid, -1, "{FAD201}Ошибка:{FFFFFF} Неверный аксессуар.");
                            return 1;
                        }
                        
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
                    
                    }
                        case 102:
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
                                GivePlayerDonateRub(playerid, -50, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
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
                        case 103:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                             if(GetPlayerData(playerid, P_VB) == 1)
                             {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", -1);
                                JSON_SetString(json_packet_data, "m", "Ошибка");
                                JSON_SetString(json_packet_data, "n", "У вас уже есть военный билет");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return;
                            }

                            if(GetPlayerDonateRub(playerid) >= 150)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Вы купили услугу Военный Билет");
                                GivePlayerDonateRub(playerid, -130, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                
                                new voen_num = GetNextMilitaryID();
	
                                new query[600];
	
                                new currentDateTime[30];

                                new year, month, day, hour, minute, second;
                                getdate(year, month, day);
                                gettime(hour, minute, second);
                                format(currentDateTime, sizeof(currentDateTime), "%02d.%02d.%d",
                                   day, month, year);
        
                                SetPlayerData(playerid, P_VB_NUM, voen_num);
                                UpdatePlayerDatabaseInt(playerid, "vb_number", voen_num);        
        
                                format(GetPlayerData(playerid, P_VB_ZVANIE), 35, "Рядовой");
                                UpdatePlayerDatabaseString(playerid, "zvanievb", "Рядовой");        
        
                                if(GetPlayerTeamEx(playerid) == TEAM_ARMY)
                                {
                                   new zvanie[32];
                                   format(zvanie, sizeof(zvanie), "%s", GetPlayerJobAndRankName(playerid));        
                                   UpdatePlayerDatabaseString(playerid, "zvanievb", zvanie);
                                }
        
                                format(g_VbDate[playerid], sizeof(g_VbDate[]), currentDateTime);
    
                                AddPlayerData(playerid, P_VB, +, 1);
                                UpdatePlayerDatabaseInt(playerid, "vb", GetPlayerData(playerid, P_VB));
        
                                new donateText[] = "Донат";
        
                                mysql_format(mysql, query, sizeof query, 
                                    "UPDATE accounts SET vbdata = '%s', nameputvb = '%e', vb_number = %d WHERE id = %d",
                                    currentDateTime, donateText, g_LastVbNumber, GetPlayerAccountID(playerid));
                                mysql_query(mysql, query, false);                                
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
                                JSON_SetString(json_packet_data, "n", "вы купили услугу: снятие предупреждения");
                                SetPlayerData(playerid, P_WARN, 0);
                                SetPlayerData(playerid, P_WARN_TIME, 0);
                                UpdatePlayerDatabaseInt(playerid, "warn", 0);
                                UpdatePlayerDatabaseInt(playerid, "warn_time", 0);
                                GivePlayerDonateRub(playerid, -100, "тест", true);
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
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Все лицензии");
                                SetPlayerData(playerid, P_DRIVING_LIC, GetPlayerData(playerid, P_DRIVING_LIC) ^ 1);
                                UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));
                                GivePlayerDonateRub(playerid, -150, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅ", true);
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
                                JSON_SetString(json_packet_data, "n", "вы купили услугу: вылечиться");
                                SetPlayerData(playerid, P_HEALTH, 100);
                                SetPlayerHealthEx(playerid, 100);
                                GivePlayerDonateRub(playerid, -75, "пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
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

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                //JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Не успешная операция");
                                JSON_SetString(json_packet_data, "n", "донат не будет списан");
                                // GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                               // obmenfam(playerid);
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
                                //JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "донат будет списан после покупки в диалоге");
                                // GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                               callcmd::buyslotfam(playerid, "");
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

                            if(GetPlayerDonateRub(playerid) >= 500)
                            {
                                //JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "ДАННАЯ УСЛУГА НЕДОСТУПНА");
                             //   SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ-пїЅпїЅпїЅпїЅпїЅпїЅпїЅ!");
                                GivePlayerDonateRub(playerid, 0, "", true);
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

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу: +1 слот под личный транспорт");
						    	AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
				    			UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));                                
                                GivePlayerDonateRub(playerid, -100, "Покупка слота для личного транспорта", true);
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

                            if(GetPlayerDonateRub(playerid) >= 75)
                            {
                                //JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "донат будет списан после покупки в диалоге");
                                // GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                               callcmd::buyphonenum(playerid, "");
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
                                //JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "донат будет списан после покупки в диалоге");
                                // GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                               callcmd::buynamefam(playerid, "");
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
                                //JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
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
                                //JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
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

                             if(GetPlayerData(playerid, P_MEDCART) == 1)
                             {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", -1);
                                JSON_SetString(json_packet_data, "m", "Ошибка");
                                JSON_SetString(json_packet_data, "n", "У вас уже есть мед. карта");
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return;
                            }

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешно");
                                JSON_SetString(json_packet_data, "n", "Вы приобрели мед. карту");
                             //   SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ");
                        //        GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ", true);
                                JSON_Stringify(json_packet_data, json_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                
                                new query[600];
                                new currentDateTime[30];                                
                                
                                new year, month, day, hour, minute, second;
                                getdate(year, month, day);
                                gettime(hour, minute, second);
                                format(currentDateTime, sizeof(currentDateTime), "%02d.%02d.%d",
                                   day, month, year);
        
                                AddPlayerData(playerid, P_MEDCART, +, 1);
                                UpdatePlayerDatabaseInt(playerid, "medcarta", 1);
        
                                SetPVarString(playerid, "MedCartDate", currentDateTime);
                                format(g_MedCartDate[playerid], sizeof(g_MedCartDate[]), currentDateTime);
        
                                format(query, sizeof(query), "UPDATE accounts SET meddata = '%s' WHERE id = %d",
                                    currentDateTime, GetPlayerAccountID(playerid));
                                mysql_query(mysql, query);                                
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
                                Dialog
                                (
                                    playerid, 9501, DIALOG_STYLE_INPUT,
                                    "{FF4500}Кастомные номера {FFFFFF}- Шаг 1/2",
                                    "{FFFFFF}Введите желаемый номер для вашего транспорта:\n\n"\
                                    "{FF4500}Формат номера:{FFFFFF} с065мк (от 1 до 6 символов)\n"\
                                    "{FF4500}Разрешённые символы:{FFFFFF} a b c e h k m o p t x y {AAAAAA}(английские)\n\n"\
                                    "{FFFFFF}Примеры:\n"\
                                    "• {FF5252}boss {AAAAAA}(будет: босс)\n"\
                                    "• {FF5252}777 {AAAAAA}(будет: 777)\n"\
                                    "• {FF5252}a777aa {AAAAAA}(будет: а777аа)\n"\
                                    "• {FF5252}vip {AAAAAA}(будет: вип)\n\n"\
                                    "{FFFFFF}Стоимость: {FF6B35}150 донат-рублей",
                                    "Далее", "Назад"
                                );
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
    return;
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
//  ShowNotificationMisters(playerid, OFFER_ENGINE, 6, 0, 0, "Взаимодействие", "");
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
    return 1;
}

stock HidePlayerGUI(playerid, guiid, Node:json)
{
    JSON_SetInt(json, "c", 1);
    OnPacketIncoming(playerid, guiid, json);
    return 1;
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, 252);
    BS_WriteValue(bitstream, PR_UINT16, guiid);
    new data[1024];
    JSON_Stringify(json, data);
    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);
    PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
    BS_Delete(bitstream);
    return 1;
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