#include "../include/json.inc"
// <----- уведы ----->
#define ENTER_ENGINE	2
#define ENTER_CONT      3
#define OFFER_YES       4
#define OFFER_ENGINE 	5
#define  NOTIF_ARMY_GATE    6
#define NOTIF_ARMY_BARR  7

// <------- GUI ------->
new dust_limit = 2000;

#define radial      27
#define  tunegui      28
#define fama  45
#define spawngui    50
#define eventgui    30
#define CasesGUI     73
#define  ActionClick    65
#define  notify     13
#define   larekgui    3
#define  provodaGui   7
#define DELUXE_REWARDS_COUNT (sizeof(RewardsDeluxe))
//------------------------------------------------------------

static const CaseAwardsCount[] = {
    0,  // id 0 (не используется)
    20, // id 1 - ЕЖЕДНЕВНЫЙ КЕЙС
    28, // id 2 - КЕЙС БОМЖА
    37, // id 3 - СТАНДАРТНЫЙ КЕЙС
    31, // id 4 - АВТО-КЕЙС 2.0
    20, // id 5 - ОСОБЫЙ КЕЙС
    25, // id 6 - КЕЙС: К ВЕРШИНАМ
    25, // id 7 - КЕЙС: ОБЛАСТЬ ТЬМЫ
    25, // id 8 - КЕЙС: ДРАЙВ
    25, // id 9 - КЕЙС: ВЕСЕННИЙ
    25, // id 10 - КЕЙС: БЛИЦ
    25  // id 11 - КЕЙС: ДЕЛО №5
};

// l- цвет в Донате, p - прибавление BC к цене
new accessories_game_ids[][2] = {
    // айди предмета в json,  айди обьекта в игре
    {531, 2656},       // Надувной жилет
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

new car_game_ids[][2] = {
    // айди предмета в json (internalId),  айди машины в игре (gameId)
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
    {86, 597},
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
// айди предмета в json (internalId),  айди скина в игре (gameId)
  {561, 5500046},
  {562, 5500047},
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
   {483, 11944},
   {563, 11943},
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

IPacket:252(playerid, BitStream:bitstream)
{
    new header, guiid;
    BS_ReadValue(bitstream, PR_UINT8, header);
    BS_ReadValue(bitstream, PR_UINT16, guiid);

    new length, json_data[256];
    BS_ReadValue(bitstream, PR_UINT32, length);
    BS_ReadValue(bitstream, PR_STRING, json_data, length);

    new Node:JSONObject = JSON_Object();
    new Node:json = JSON_Object();
    new outcoming_data[512];
    printf("[DEBUG] Incoming json for gui %d: (%s)", guiid, json_data);
    JSON_Parse(json_data, json);

    switch (guiid)
    {         
    case 25:
    {
    new t;
    JSON_GetInt(json, "t", t);
format(str, sizeof(str), "Вы %d!", t);
        ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
        
     OnPacketIncoming(playerid, 25, json);                
       JSON_Cleanup(json);
    }
    case 34:
{
trunk_HandlePacket(playerid, json);
}
case 33:
{
    if(GetPVarInt(playerid, "InTrade") == 3)
    {
       trade_HandlePacket(playerid, json);
    }
    else if(GetPVarInt(playerid, "InTrade") == 2)
    {
    Inventory_HandlePacket(playerid, json);    
    }
}
       case notify:
		{
		  new t, sub_id, id;
		  JSON_GetInt(json, "t", t);
		  JSON_GetInt(json, "s", id);
		  JSON_GetInt(json, "b", sub_id);

			switch(t)
			{
				case 0: // если пользоватетель нажал на кнопку уведомления (4 и 5 типы)
				{
				  switch(id) 
				  {
					case 1: 
					{
					  return;
					}
					case 9:
					{
	                Dialog
                          	(
                         		playerid, DIALOG_ATM, DIALOG_STYLE_LIST,
	                        	"{FFCD00}Банкомат",
	                         	"1. Снять с банковского счета\n"\
	                         	"2. Положить на банковский счет\n"\
                        		"3. Баланс банковского счета\n"\
                        		"4. Снять со счета предприятия\n"\
	                        	"5. Положить на счет предприятия\n"\
	                        	"6. Пополнить мобильный телефон\n"\
	                        	"7. Безналичный перевод\n"\
                       		"8. Оплата штрафа\n"\
	                       	"9. Благотворительность",
                      		"Выбрать", "Выйти"
                       	);
					}
					case 8:
             {
                  new target = GetPVarInt(playerid, "tradePartner2");
                  ShowInventoryGUIForExchange(playerid, target);
                  ShowInventoryGUIForExchange(target, playerid);
                  DeletePVar(playerid, "tradePartner2");
             }                   
					case ENTER_ENGINE:
					{
					callcmd::e(playerid, "");
					}
					case ENTER_CONT:
					{
					callcmd::cont(playerid);
					}
				    case NOTIF_ARMY_GATE:
                {
                    MoveObject(ArmyGate, 1891.1486, 1714.2531, 16.4444, 1.0);
                    ShowNotification(playerid, 3, 3, 0, 0, "Ворота открываются", "");
                }
                case NOTIF_ARMY_BARR:
                {
                    MoveObject(ArmyBarrier, 1910.21, 1725.28, 15.6666, 2.0, -90.0, 0.0, 0.0);
                    ShowNotification(playerid, 3, 4, 0, 0, "Шлагбаум открывается", "");
                }                   
                case OFFER_ENGINE:
                {
                    callcmd::e(playerid, "");
                }                     
	 	}
		return;
	}
       case 1:
       {
		switch(id) // отлавливаем уведомление по id
	  	{
	case 8:
			     {
			        ShowNotification(playerid, 3, 5, 0, 0, "Вы отказались от предложения трейда", "");  	
			        DeletePVar(playerid, "tradePartner");
	        		ShowNotification(GetPVarInt(playerid, "tradePartner2"), 2, 5, 0, 0, "Игрок отказался от вашего предложения", "");  	
	                DeletePVar(playerid, "tradePartner2");
			    }
		   	case 1: // действие когда игрок нажал на уведомление с id - 1
				{
					return;
					}
			}			  
			return;
			}
		}
	}
        
    case 22:
   {
     new type;
     JSON_GetInt(json, "t", type);    
      
     switch(type)
    {         
       case -1:
{   
    new latype, ty, a, p;
    JSON_GetInt(json, "id", a);
    JSON_GetInt(json, "p", p);
    JSON_GetInt(json, "la", latype);
    JSON_GetInt(json, "ty", ty);
    
    switch(latype) 
    {
        case 0: // основное меню
        {
            JSON_SetInt(json, "t", -1);
            JSON_SetInt(json, "ty", -1);
            JSON_SetInt(json, "la", 0);                                
            JSON_SetInt(json, "lv", GetPlayerData(playerid, P_BP_LEVEL));           // уровен      
            JSON_SetInt(json, "td", 2572661);  // время         
            JSON_SetInt(json, "ec", GetPlayerData(playerid, P_BP_EXP));        
            JSON_SetInt(json, "a", GetPlayerData(playerid, P_BP_PREMIUM));                       // премка
            JSON_SetInt(json, "sp", 0);                    
            JSON_SetInt(json, "is", GetPlayerData(playerid, P_BP_CLAIMED));                     // можно ли собрать наgраду
            OnPacketIncoming(playerid, 22, json);                
            JSON_Cleanup(json);
        }        
        case 1:  // задания
{
       // s 1 - получить s 3 - активное s 0 - недоступно s 4 - доступно s - 2 не выполнено
    new jsonStr[1280];
    
    format(jsonStr, sizeof(jsonStr),
    "{\
        \"la\":1,\
        \"t\":-1,\
        \"tk\":[\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":2},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":2},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":1},\
            {\"id\":%d,\"p\":0,\"s\":4},\
            {\"id\":%d,\"p\":0,\"s\":2},\
            {\"id\":%d,\"p\":0,\"s\":2}\
          ],\
          \"ty\":0\
         }",
         g_PlayerTaskNumber1,
         g_PlayerTaskNumber2,
         g_PlayerTaskNumber3,
         g_PlayerTaskNumber4,
         g_PlayerTaskNumber5,
         g_PlayerTaskNumber6,
        g_PlayerTaskNumber7,
        g_PlayerTaskNumber8,
        g_PlayerTaskNumber9,
        g_PlayerTaskNumber10,
        g_PlayerTaskNumber11,
        g_PlayerTaskNumber12,
        g_PlayerTaskNumber13,
        g_PlayerTaskNumber14,
        g_PlayerTaskNumber15,
       g_PlayerTaskNumber16,
       g_PlayerTaskNumber17    
       );
          JSON_Parse(jsonStr, json);
          OnPacketIncoming(playerid, 22, json);        
          JSON_Cleanup(json);
        }        
        case 4: // покупка БП
        {
            JSON_SetInt(json, "t", -1);
            JSON_SetInt(json, "ty", 0);
            JSON_SetInt(json, "la", 4);
            JSON_SetInt(json, "p", price_bp);    // цена за премиум
            JSON_SetInt(json, "pp", price_bp_deluxe);  // цена за премиум +
            JSON_SetInt(json, "a", GetPlayerData(playerid, P_BP_PREMIUM));
            OnPacketIncoming(playerid, 22, json);            
            JSON_Cleanup(json);
        }
        case 3: // рейтинг
        {
            new jsonStr[512];
            format(jsonStr, sizeof(jsonStr),
            "{\
                \"j\":[\
                    {\"n\":\"Maksimka_Derixton\",\"och\":1488},\
                    {\"n\":\"Debil\",\"och\":16},\
                    {\"n\":\"Skamer\",\"och\":15},\
                    {\"n\":\"Sanya\",\"och\":14},\
                    {\"n\":\"Egor\",\"och\":13},\
                    {\"n\":\"Vitya\",\"och\":12},\
                    {\"n\":\"Nikita\",\"och\":11},\
                    {\"n\":\"Valera\",\"och\":10},\
                    {\"n\":\"Derix\",\"och\":9},\
                    {\"n\":\"Zomenko\",\"och\":8}\
                ],\
                \"la\":3,\
                \"m\":1,\
                \"t\":-1,\
                \"ty\":0\
            }");
            JSON_Parse(jsonStr, json);
            OnPacketIncoming(playerid, 22, json);       
            JSON_Cleanup(json);
        }        
    }
    if(ty == 1)
{
    if(latype == 0)
    {        
        new current_level = GetPlayerData(playerid, P_BP_LEVEL);
        new new_level = current_level + p;
        
        for(new i = current_level + 1; i <= new_level; i++)
        {
            GiveRewardsFromGUI(playerid, i, 69); 
        }
        
        UpdatePlayerDatabaseInt(playerid, "bp_level", new_level);
        AddPlayerData(playerid, P_BP_LEVEL, +, p);
        
        new str[128];
        format(str, sizeof(str), "Вы успешно приобрели: +{ff0000}%d{FFFFFF} уровней BP за BC!", p);
        ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
        SetPlayerData(playerid, P_BP_CLAIMED, 1);
        UpdatePlayerDatabaseInt(playerid, "bp_claimed", 1);
       }
   }
   if(ty == 1)
   {
     if(latype == 4)
     {
        if(a == 1)
        {
          SetPlayerData(playerid, P_BP_PREMIUM, 2);
      	UpdatePlayerDatabaseInt(playerid, "bp_premium", 2); 
          GivePlayerDonateRub(playerid, -price_bp, "Покупка БП", true, true);    
      	new str[128];
          format(str, sizeof(str), "Вы успешно приобрели: {ff0000}PREMIUM BP{FFFFFF} за %d BC!", price_bp);
          ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
         }
         if(a == 0)
        {
          SetPlayerData(playerid, P_BP_PREMIUM, 1);
      	UpdatePlayerDatabaseInt(playerid, "bp_premium", 1);    
          GivePlayerDonateRub(playerid, -price_bp_deluxe, "Покупка БП", true, true); 
      	new str[128];
          format(str, sizeof(str), "Вы успешно приобрели: {ff0000}DELUXE BP{FFFFFF} за %d BC!", price_bp_deluxe);
          ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
          GiveDeluxeRevards(playerid);
         }
      }
   }
    if(ty == 2)
   {
     if(latype == 0)
     {
       new level_id = GetPlayerData(playerid, P_BP_LEVEL);

     GiveRewardsFromGUI(playerid, level_id, 69);
     
     SetPlayerData(playerid, P_BP_CLAIMED, 0);
 	UpdatePlayerDatabaseInt(playerid, "bp_claimed", 0);
     JSON_SetInt(json, "t", -1);
     JSON_SetInt(json, "is", 0);
     OnPacketIncoming(playerid, 22, json);         
     JSON_Cleanup(json);
     }    
   }
}
        case 1:
        { 
           ShowCasesGUI(playerid);
           JSON_SetInt(json, "t", 1);                   
           OnPacketIncoming(playerid, 22, json);
           JSON_Cleanup(json);
        }
        case 2:
{
    new remaining = GetPlayerData(playerid, P_SALE_TIME);
    
    if(remaining > 0)
    {
        ShowNotification(playerid, 3, 4, 0, 0, "Таймер уже активен", "");
        return;
    }
    
    // 24 часа = 86400 секунд
    new current_time = gettime();
    SetPlayerData(playerid, P_SALE_TIME, 86400);
    SetPlayerData(playerid, P_SALE_LAST_UPDATE, current_time);
    
    UpdatePlayerDatabaseInt(playerid, "sale_time", 86400);
    UpdatePlayerDatabaseInt(playerid, "sale_last_update", current_time);    
    GivePlayerDailyGift(playerid);
    
    new Node:json_packet_data = JSON_Object();
    JSON_SetInt(json_packet_data, "t", 2);
    JSON_SetInt(json_packet_data, "p", 86400);
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
}
                case 0:
                {
                    new price, internal_id;
                    JSON_GetInt(json, "p", internal_id);
                    JSON_GetInt(json, "m", price);

                    new result = GetPlayerDonateRub(playerid) - price;

                    if(GetPlayerDonateRub(playerid) < price || result < 0)
                    {
                        new Node:json_packet_data = JSON_Object();
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 0);
                        JSON_SetInt(json_packet_data, "k", 1);
                        JSON_SetString(json_packet_data, "m", "Ошибка");
                        JSON_SetString(json_packet_data, "n", "У вас недостаточно BLACK COIN для покупки данного товара.");
                        // JSON_Stringify(json_packet_data);
                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return;
                    }

                    switch(internal_id)
                    {
  case 89:
{
       if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
    {                              
        new Node:json_packet_data = JSON_Object();
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", -1);
        JSON_SetString(json_packet_data, "m", "Все слоты для покупки нового\nтранпорта заняты.");
        JSON_SetString(json_packet_data, "n", "Вы можете увеличить их в разлеле {FFFF00}услуги.");
        OnPacketIncoming(playerid, 22, json_packet_data);
        JSON_Cleanup(json_packet_data);
        return;
    }
    
       GiveRewardCar(playerid, 516, 1, 1, "remapfbody9");
        GivePlayerDonateRub(playerid, -35000);
            new Node:json_packet_data = JSON_Object();
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
    JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
}
case 91:
{
       if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
    {                              
        new Node:json_packet_data = JSON_Object();
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", -1);
        JSON_SetString(json_packet_data, "m", "Все слоты для покупки нового\nтранпорта заняты.");
        JSON_SetString(json_packet_data, "n", "Вы можете увеличить их в разлеле {FFFF00}услуги.");
        OnPacketIncoming(playerid, 22, json_packet_data);
        JSON_Cleanup(json_packet_data);
        return;
    }
    
       GiveRewardCar(playerid, 550, 1, 1, "remapfbody27");
    GivePlayerDonateRub(playerid, -40000);

    new Node:json_packet_data = JSON_Object();
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
    JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
}                  
 case 5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37,38,39,40,41,42,43,44,45,46,47,48,49,50,51,52,53,54,55,56,57,58,59,60,61,62,63,64,65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,90,201,202,195,211,212,213,214,215,216,217,218,219,220,353,221,222,223,224,275,276,327,328,329,330,331,366,367,349,400,401,402,403,404,405,406,407,408,409,410,411,413,414,415,416,417,418,424,426,427,428,429,444,445,446,447,448,449,450,451,452,453,454,455,456,459,460,461,465,466,467,468,469,470,471,472,473,474,484,485,498,499,500,501,502,503,504,505,506,507,508,509,510,511,512,522,523,524,543,544,545,546,547,551,552,553,554,555,556,557,558,559,560:
{ 
    new color;
    JSON_GetInt(json, "l", color);
    
    new model_id = FindGameId(internal_id, car_game_ids, sizeof(car_game_ids));
   
       if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
    {                              
        new Node:json_packet_data = JSON_Object();
        JSON_SetInt(json_packet_data, "t", 0);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetInt(json_packet_data, "k", -1);
        JSON_SetString(json_packet_data, "m", "Все слоты для покупки нового\nтранпорта заняты.");
        JSON_SetString(json_packet_data, "n", "Вы можете увеличить их в разлеле {FFFF00}услуги.");
        OnPacketIncoming(playerid, 22, json_packet_data);
        JSON_Cleanup(json_packet_data);
        return;
    }
    
    if(model_id == 596)
    {
       GiveRewardCar(playerid, 596, 1, 1, "remapbppsbody");
        GivePlayerDonateRub(playerid, -50000);
        new Node:json_packet_data = JSON_Object();
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
    JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
        return; 
    }
       else if(model_id == 597)
    {
       GiveRewardCar(playerid, 596, 1, 1, "remapfbody8");
        GivePlayerDonateRub(playerid, -20000);
        new Node:json_packet_data = JSON_Object();
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
    JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
        return; 
    }
    else
    {    
    BuyPlayerCar(playerid, internal_id, model_id, color);
    GivePlayerDonateRub(playerid, -price);

    new Node:json_packet_data = JSON_Object();
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
    JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
    }
}
                        case 561, 562, 535, 529, 527, 528, 526, 525, 519, 513, 514, 515, 516, 517, 486, 487, 488, 489, 490, 491, 492, 497, 480, 481, 482, 483, 563, 475, 462, 463, 457, 458, 419, 430, 431, 425, 420, 421, 399, 390, 391, 392, 393, 394, 395, 396, 397, 398, 346, 344, 345, 332, 333, 334, 335, 340, 336, 337, 338, 339, 341, 342, 343, 315, 313, 311, 322, 323, 324, 314, 312, 316, 317, 318, 319, 320, 321, 325, 326, 238, 257, 239, 240, 225, 226, 227, 228, 205, 206, 207, 208, 229, 93, 94, 230, 95, 96, 97, 203, 231, 232, 233, 234, 235, 98, 99, 100, 101, 236, 237, 209, 210:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);
                            JSON_SetInt(json_packet_data, "g", internal_id);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели одежду");
                            JSON_SetString(json_packet_data, "n", "Для того чтобы одеть её, используйте инвентарь (/inv)");
                            // JSON_Stringify(json_packet_data);
                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);

                            BuyPlayerSkin(playerid, internal_id, FindGameId(internal_id, clothes_game_ids, sizeof(clothes_game_ids)));
                            GivePlayerDonateRub(playerid, -price);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 103:
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 104:
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 106:
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 107:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 100)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Измините имя семьи в диалоге:");
                                GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "донат будет списан после передачи");
                                // GivePlayerDonateRub(playerid, -100, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 109:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 130)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Военный билет");
                                GivePlayerDonateRub(playerid, -130, "пїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "ДАННАЯ УСЛУГА НЕДОСТУПНА");
                             //   SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ-пїЅпїЅпїЅпїЅпїЅпїЅпїЅ!");
                                GivePlayerDonateRub(playerid, 0, "", true);
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅ-пїЅпїЅпїЅпїЅпїЅпїЅ, пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ /anymusic");
                                GivePlayerDonateRub(playerid, 0, "1", true);
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 113:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 2500)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА НЕДОСТУПНА");
                           //     SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅ");
                                GivePlayerDonateRub(playerid, 0, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅ", true);
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 114:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 5000)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Донат не списан");
                                JSON_SetString(json_packet_data, "n", "УСЛУГА НЕДОСТУПНА");
                       //         SendClientMessage(playerid, 0xCECECEFF, "пїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ");
                                GivePlayerDonateRub(playerid, 0, "пїЅпїЅпїЅ. пїЅпїЅпїЅпїЅ пїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅпїЅ", true);
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 123:
                        {
                            if(GetPlayerDonateRub(playerid) >= 85)
                            {
                                ShowNotification(playerid, 2, 4, 0, 0, "ТЕСТ Н/З?", "");
                            }
                            else
                            {
                                new Node:json_packet_data = JSON_Object();
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                // JSON_Stringify(json_packet_data);
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
                                // JSON_Stringify(json_packet_data);
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
         case radial:
    	{
			new vehicleid = GetPlayerVehicleID(playerid);
			new index = GetVehicleData(vehicleid, V_ACTION_ID);

	        new type;
	        JSON_GetInt(json, "t", type);
	        switch(type)
	        {
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
					   if(!vInfo[vehicleid][vEnableLaunchControl])
					{
					     vInfo[vehicleid][vEnableLaunchControl] = false;
						SetVehicleLaunchControl(vehicleid, 1);
						JSON_SetInt(json, "c", 1);
		  			}
		         }
	       		else ShowNotification(playerid, 2, 3, 99, 0, "В авто не установлен лаунч-контроль.", "");
			    }			
			    case 6:
			    {
			     	callcmd::e(playerid);

			     	if(GetVehicleParam(vehicleid, V_ENGINE)) 	JSON_SetInt(json, "s", 1);
			     	else 										JSON_SetInt(json, "s", 0);
					OnPacketIncoming(playerid, 27, json);
					JSON_Cleanup(json);

					if(!GetVehicleParam(vehicleid, V_ENGINE))
					{
						JSON_SetInt(json, "s", 0);
						JSON_SetInt(json, "t", 12);
						JSON_SetInt(json, "t", 13);
						JSON_SetInt(json, "t", 14);
						JSON_SetInt(json, "t", 15);
     				}
			 	}
			    case 8: // drift
			    {
			     	ShowNotification(playerid, 2, 3, 99, 0, "У Вас не установлена эта прошивка!", "");
			    }
			    case 9: // comfort
			    {
			     	ShowNotification(playerid, 2, 3, 99, 0, "У Вас не установлена эта прошивка!", "");
			    }
			    case 10: // sport
			    {
			     	ShowNotification(playerid, 2, 3, 99, 0, "У Вас не установлена эта прошивка!", "");
			    }
			    case 11: // sport+
			    {
			         if(vInfo[vehicleid][vSportP1] == 1 && vInfo[vehicleid][vSportP2] == 1 && vInfo[vehicleid][vSportP3] == 1 && vInfo[vehicleid][vSportP4] == 1 && vInfo[vehicleid][vSportP5] == 1)
                   {
                    if(vInfo[vehicleid][vEnableDrift] == true || vInfo[vehicleid][vEnableSport] == true || vInfo[vehicleid][vEnableComfort] == true)
                    {
                       ShowNotification(playerid, 2, 3, 99, 0, "Нельзя включить более одной активной прошивки!", "");
                     }
                         if(!vInfo[vehicleid][vEnableSportPlus])
			  		{
							    vInfo[vehicleid][vEnableSportPlus] = true;
				     			SetVehicleAcceleration(vehicleid, 28, 1);
                                 GameTextForPlayer(playerid, "~g~~h~~h~Спорт+ активирован!", 3000, 4);
								JSON_SetInt(json, "s", 1);
								OnPacketIncoming(playerid, 27, json);
								JSON_Cleanup(json);
							}
							else
							{
							    vInfo[vehicleid][vEnableSportPlus] = false;
				     			SetVehicleAcceleration(vehicleid, 15, 1);
								JSON_SetInt(json, "s", 0);
							}						
		  	  		}
                      else ShowNotification(playerid, 2, 3, 99, 0, "У Вас не установлена прошивка {00Ff00}Sport+", "");			  	                    
			    }
			    case 12:
			    {
					if(vInfo[vehicleid][vNeon1] || vInfo[vehicleid][vNeon2] || vInfo[vehicleid][vNeonMain] > 0)
					{
						    if(!vInfo[vehicleid][vEnableNeon])
							{
	    					     StreamingNeon(playerid, vehicleid);
							    vInfo[vehicleid][vEnableNeon] = true;						 		
								JSON_SetInt(json, "s", 1);
							}
							else
							{
							    vInfo[vehicleid][vEnableNeon] = false;
						 		SetVehicleLightingColor(vehicleid, 0x00000000, 0x00000000, 0x00000000);
								JSON_SetInt(json, "s", 0);
							}						
			  		}
		  			else ShowNotification(playerid, 2, 3, 99, 0, "У Вас не установлена подсветка", "");
			    }
			    case 13:
			    {
					if(vInfo[vehicleid][vHighLights] == 1)
					{					
						    if(!vInfo[vehicleid][vEnableHighLights])
							{
							    vInfo[vehicleid][vEnableHighLights] = true;
				     			SetVehicleHighLight(vehicleid, 1);				
								SetVehicleParam(vehicleid, V_LIGHTS, true);

								JSON_SetInt(json, "s", 1);
								JSON_SetInt(json, "t", 14);
							}
							else
							{
							    vInfo[vehicleid][vEnableHighLights] = false;
				     			SetVehicleHighLight(vehicleid, 0);
								JSON_SetInt(json, "s", 0);
							}						
			  		}
		 			else ShowNotification(playerid, 2, 3, 99, 0, "У вас не установлен дальний свет фар", "");
			    }
			    case 14:
			    {
			     	callcmd::l(playerid);
			     	if(GetVehicleParam(vehicleid, V_LIGHTS)) JSON_SetInt(json, "s", 1);
			     	else
				 	{
					 	JSON_SetInt(json, "s", 0);
						JSON_SetInt(json, "t", 13);
						JSON_SetInt(json, "t", 14);
						JSON_SetInt(json, "t", 15);
					}
			    }
			    case 15:
				{
					if(vInfo[vehicleid][vStrob])
					{
						    if(!vInfo[vehicleid][vEnableStrob])
							{
							    vInfo[vehicleid][vEnableStrob] = true;
								SetVehicleParam(vehicleid, V_ENGINE, true);
								SetVehicleParam(vehicleid, V_LIGHTS, true);
				     			SetVehicleStroboscope(vehicleid, vInfo[vehicleid][vStrob]-1);

					//			SetVehicleLightProperties(vehicleid, GetVehicleParam(vehicleid, V_LIGHTS), vInfo[vehicleid][vStrob]);

								JSON_SetInt(json, "s", 1);

								JSON_SetInt(json, "t", 14);
							}
							else
							{
							    vInfo[vehicleid][vEnableStrob] = false;
				     			SetVehicleStroboscope(vehicleid, 5);
								SetVehicleParam(vehicleid, V_ENGINE, true);
								SetVehicleParam(vehicleid, V_LIGHTS, true);
				//				SetVehicleLightProperties(vehicleid, GetVehicleParam(vehicleid, V_LIGHTS), vInfo[vehicleid][vStrob]);
								JSON_SetInt(json, "s", 0);
					         }
			 		 }
					else ShowNotification(playerid, 2, 3, 99, 0, "В авто не установлены стробоскопы.", "");
			    }
			    case 16:
			    {
			     	ShowNotification(playerid, 2, 3, 99, 0, "Система (Пневмо1) находиться в разработке", "");
			    }
			    case 17:
			    {
			     	ShowNotification(playerid, 2, 3, 99, 0, "Система (Пневмо2) находиться в разработке", "");
			    }
			    case 18:
			    {
			       ShowNotification(playerid, 2, 3, 99, 0, "Система (Пневмо3) находиться в разработке", "");
			    }
                case 19:
             {              
                            if(vInfo[vehicleid][vHydraulics])
		          			{
				       	    if(!vInfo[vehicleid][vEnableHydraulics])
			     			{
			    			    vInfo[vehicleid][vEnableHydraulics] = true;
			    				SetVehicleHydraulics(vehicleid, 1);
		    					JSON_SetInt(json, "s", 1);
		                       ShowNotification(playerid, 1, 3, 99, 0, "Гидравлика включена!", "");
		  				}
				 		else
				 		{
				 		    vInfo[vehicleid][vEnableHydraulics] = false;
				 		    RemoveVehicleComponent(vehicleid, 1087);
							SetVehicleHydraulics(vehicleid, 0);
							JSON_SetInt(json, "s", 0);
							ShowNotification(playerid, 1, 3, 99, 0, "Гидравлика отключена!", "");
	  			 		}
				       }
                   else ShowNotification(playerid, 2, 3, 99, 0, "У вас не установлена гидравлика!", "");
	           	}	                 
              }                     
             OnPacketIncoming(playerid, 27, json);
             JSON_Cleanup(json);
          }
          
      case 112:
{
    new action_type;
    JSON_GetInt(json, "t", action_type);
    
    switch(action_type)
    {
        case 1: // включение радио
        {
            new radio_type[32];
            JSON_GetString(json, "r", radio_type, sizeof(radio_type));
            
            if(strcmp(radio_type, "gangster_music") == 0)
            {
                JSON_SetInt(json, "t", 1);
                JSON_SetString(json, "r", "gangster_music");                
                ShowNotification(playerid, 3, 6, 0, 0, "Включена радиостанция - GANGSTER MUSIC");
                PlayAudioStreamURL(playerid, "http://radio.blackrussia.online/listen/gangster_music_[uncensored]/radio");
                OnPacketIncoming(playerid, 112, json);
                JSON_Cleanup(json);
            }
            else if(strcmp(radio_type, "dnb_nation") == 0)
            {
               JSON_SetInt(json, "t", 1);
               JSON_SetString(json, "r", "dnb_nation");
                PlayAudioStreamURL(playerid, "http://radio.blackrussia.online/listen/dnb_nation_[uncensored]/radio");
                ShowNotification(playerid, 3, 6, 0, 0, "Включена радиостанция - DNB NATION");
                OnPacketIncoming(playerid, 112, json);
                JSON_Cleanup(json);
            }
            else if(strcmp(radio_type, "high_head") == 0)
            {
                JSON_SetInt(json, "t", 1);
                JSON_SetString(json, "r", "high_head");
                PlayAudioStreamURL(playerid, "http://radio.blackrussia.online/listen/high_head_radio_[uncensored]/radio");
                ShowNotification(playerid, 3, 6, 0, 0, "Включена радиостанция - HIGH HEAD");
                OnPacketIncoming(playerid, 112, json);
                JSON_Cleanup(json);
            }
            else if(strcmp(radio_type, "phonk_city_radio") == 0)
            {
                JSON_SetInt(json, "t", 1);
                JSON_SetString(json, "r", "phonk_city_radio");
                PlayAudioStreamURL(playerid, "http://radio.blackrussia.online/listen/phonk_city_radio_[uncensored]/radio");
                ShowNotification(playerid, 3, 6, 0, 0, "Включена радиостанция - PHONK CITY RADIO");
                OnPacketIncoming(playerid, 112, json);
                JSON_Cleanup(json);
            }
            else if(strcmp(radio_type, "alt_fm") == 0)
            {
                JSON_SetInt(json, "t", 1);
                 JSON_SetString(json, "r", "alt_fm");
                PlayAudioStreamURL(playerid, "https://radio.blackrussia.online/listen/alt_fm_[uncensored]/radio");
                ShowNotification(playerid, 3, 6, 0, 0, "Включена радиостанция - ALT FM");
                OnPacketIncoming(playerid, 112, json);
                JSON_Cleanup(json);
            }
            else if(strcmp(radio_type, "radio_drive") == 0)
            {
                JSON_SetInt(json, "t", 1);
                 JSON_SetString(json, "r", "radio_drive");
                PlayAudioStreamURL(playerid, "https://radio.blackrussia.online/listen/radio_drive_[uncensored]/radio");
                ShowNotification(playerid, 3, 6, 0, 0, "Включена радиостанция - DRIVE");
                OnPacketIncoming(playerid, 112, json);
                JSON_Cleanup(json);
            }
            else if(strcmp(radio_type, "off") == 0)
            {
                StopAudioStream(playerid);
                JSON_SetInt(json, "t", 1);
                JSON_SetString(json, "r", "off");
                ShowNotification(playerid, 3, 6, 0, 0, "Музыка отключена");
                OnPacketIncoming(playerid, 112, json);
                JSON_Cleanup(json);
            }
        }                      
    }
}
     case 40:
{
              new action;
             JSON_GetInt(json, "t", action);

                switch(action)
             {  
              case 1:
             {
             ShowNotification(playerid, 4, 6, 0, 0, "Временно не доступно, отправляю в больницу..", ">>"); // ждать
             }
            case 2:
           {
               HidePlayerGUI(playerid, 40);
              TeleportToHospital(playerid);
           }
       }
   }					
  case 66:
{
    new ActionId, button;
    JSON_GetInt(json, "t", ActionId);
    JSON_GetInt(json, "b", button);
    
    switch(button)
    {     
        case 1:
        {
            new targetid = GetPVarInt(playerid, "SpeckID");
            StartSpectate(playerid, targetid);
            ShowSpectateGUI(playerid, targetid);
        }

        case 2:
        {
            SendClientMessage(playerid, -1, "предыдущий ");
            new targetid = GetPVarInt(playerid, "SpeckID");
            ShowSpectateGUI(playerid, targetid);
        }

        case 3:
        {
            SendClientMessage(playerid, -1, "кик ");
            new targetid = GetPVarInt(playerid, "SpeckID");
            ShowSpectateGUI(playerid, targetid);
        }

        case 4:
        {
            ShowSpeckDialogMute(playerid);
            new targetid = GetPVarInt(playerid, "SpeckID");
            ShowSpectateGUI(playerid, targetid);
        }

        case 5:
        {
            SendClientMessage(playerid, -1, "тюрьма ");
            new targetid = GetPVarInt(playerid, "SpeckID");
            ShowSpectateGUI(playerid, targetid);
        }

        case 6:
        {
            SendClientMessage(playerid, -1, "варн ");
            new targetid = GetPVarInt(playerid, "SpeckID");
            ShowSpectateGUI(playerid, targetid);
        }

        case 7:
        {
            SendClientMessage(playerid, -1, "slap ");
            new targetid = GetPVarInt(playerid, "SpeckID");
            ShowSpectateGUI(playerid, targetid);
        }

        case 8:
        {
            SendClientMessage(playerid, -1, "бан ");
            new targetid = GetPVarInt(playerid, "SpeckID");         
            ShowSpectateGUI(playerid, targetid);
        }

        case 9:
        {
            SendClientMessage(playerid, -1, "следующий ");
            new targetid = GetPVarInt(playerid, "SpeckID");
            ShowSpectateGUI(playerid, targetid);
        }

        case 10:
        {
            new targetid = GetPVarInt(playerid, "SpeckID");       
            ShowSpectateGUI(playerid, targetid);
            ShowPlayerStats(targetid, playerid);
        }

        case 11:
        {
            new targetid = GetPVarInt(playerid, "SpeckID");           
            ShowSpectateGUI(playerid, targetid);
            SendClientMessage(playerid, -1, "af ");
        } 
     }      
    switch(ActionId) 
    {
        case 0:
        {
           callcmd::spoff(playerid, "");
        }       
      }
      OnPacketIncoming(playerid, 66, json);
      JSON_Cleanup(json);
  }
  
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

            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 3);            
            OnPacketIncoming(playerid, 38, response);
            JSON_Cleanup(response);
        }

        case 3:
        {
            new gender;
            JSON_GetInt(json, "r", gender);
            SetPlayerData(playerid, P_SEX, gender);

            if(CreatePlayerAccount(playerid))
            {
                SetPlayerData(playerid, P_ACCOUNT_STATE, ACCOUNT_STATE_REG_SKIN);    
                new Node:response = JSON_Object();               
                OnPacketIncoming(playerid, 38, response);
                JSON_Cleanup(response);
            }
            else
            {
                ShowNotification(playerid, 1, 5, 0, 0, "Произошла ошибка, обратитесь на форум",">");
                Kick(playerid);
            }
        }

        case 4:
        {
            new invite_nick[MAX_PLAYER_NAME];
            JSON_GetString(json, "s", invite_nick);

            if (strlen(invite_nick) == 0)
            {
                new Node:response = JSON_Object();
                JSON_SetInt(response, "t", 3);
                OnPacketIncoming(playerid, 38, response);
                JSON_Cleanup(response);
            }

            new query[75], Cache: result;
            mysql_format(mysql, query, sizeof query, "SELECT id FROM accounts WHERE name='%e' LIMIT 1", invite_nick);
            result = mysql_query(mysql, query);

            if(cache_num_rows())
                SetPlayerData(playerid, P_REFER, cache_get_row_int(0, 0));
            cache_delete(result);

            if(!GetPlayerData(playerid, P_REFER))
            {
                ShowNotification(playerid, 1, 5, 0, 0, "Данный игрок не зарегистрирован на сервере",">");
                new Node:response = JSON_Object();       
                JSON_SetInt(response, "t", 0);
                OnPacketIncoming(playerid, 38, response);
                JSON_Cleanup(response);
            }                       
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
            SetCameraBehindPlayer(playerid);
            StopAudioStream(playerid);
            
            new query[90];
            mysql_format(mysql, query, sizeof query, "UPDATE accounts SET skin=%d,last_login=%d WHERE id=%d LIMIT 1", GetPlayerSkinEx(playerid), gettime(), GetPlayerAccountID(playerid));
            mysql_query(mysql, query, false);
            
            SetPlayerData(playerid, P_LEVEL, 1);
		     ShowVideo(playerid, "Cin_FTUE-1");
  		format(query, sizeof query, "UPDATE accounts SET level=1 WHERE id=%d LIMIT 1", GetPlayerAccountID(playerid));
  		mysql_query(mysql, query, false);
	  	UpdatePlayerDatabaseInt(playerid, "level", 1);
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", -1);
            OnPacketIncoming(playerid, 38, response);
            JSON_Cleanup(response);
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

                new Node:response = JSON_Object();
                JSON_SetInt(response, "c", 1); 
                OnPacketIncoming(playerid, 38, response);
                JSON_Cleanup(response);
            } 
            else
            {
                ShowNotification(playerid, 2, 5, 0, 0, "Не верный пароль",">");
            }
        }
    }
}

case 113:
{
    new appid;
    JSON_GetInt(json, "a", appid);
    
    switch(appid) 
    {       
        case 1:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "taix", "ок");
        }
        case 13:
        {
            ShowNotification(playerid, 4, 6, 1, 0, "DONATE", "ок");
        }
        case 18:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "Calendar", "ок");
        }
        case 4:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 4)", "ок");
        }
        case 5:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "anim", "ок");
        }
        case 6:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 6)", "ок");
        }
        case 7:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "car", "ок");
        }
        case 8:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "promo", "ок");
        }
        case 9:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 9)", "ок");
        }
        case 10:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 10)", "ок");
        }
        case 11:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 11)", "ок");
        }
        case 12:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 12)", "ок");
        }        
        case 14:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "reward", "ок");
        }
        case 15:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "token", "ок");
        }
        case 16:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "market", "ок");
        }
        case 17:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 17)", "ок");
        }      
        case 19:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 19)", "ок");
        }
        case 20:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 20)", "ок");
        }
        case 21:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 21)", "ок");
        }
        case 22:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 22)", "ок");
        }
        case 23:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 23)", "ок");
        }
        case 24:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 24)", "ок");
        }
          case 25:
      {
         HidePlayerGUI(playerid, 113);
         ClearAnimations(playerid);
	     TogglePlayerControllable(playerid, true);
	     ShowNewsGUI(playerid);
       }
        case 26:
        {
        HidePlayerGUI(playerid, 113);
         ClearAnimations(playerid);
	     TogglePlayerControllable(playerid, true);
	 //    ShowStormEventGUI(playerid);
        }
        case 27:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 27)", "ок");
        }
        case 28:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 28)", "ок");
        }
        case 29:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 29)", "ок");
        }
        case 30:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 30)", "ок");
          }
      }
      OnPacketIncoming(playerid, 113, json);
      JSON_Cleanup(json);
  }
  
  case ActionClick:
{
    new ActionId;
    JSON_GetInt(json, "t", ActionId);
    
    switch(ActionId) 
    {
        case 0:
        {
           // закрытие
        }
        case 1:
        {
            // для типа если истек таймер
            ShowNotification(playerid, 4, 6, 0, 0, "Время истекло", "ок");
            JSON_SetInt(json, "t", 1);
            JSON_SetInt(json, "c", 1);
            OnPacketIncoming(playerid, 65, json);
            JSON_Cleanup(json);
        }
        case 2:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "Клик", "ок");  // для обычного типа, обработка нажатия
          }
      }
      OnPacketIncoming(playerid, 65, json);
      JSON_Cleanup(json);
  }

case provodaGui:
{
    new ActionId;
    JSON_GetInt(json, "t", ActionId);
    
    switch(ActionId) 
    {
        case 0:
        {
          ShowNotification(playerid, 4, 6, 0, 0, "!lox!!", "ок");
        }
        case 1:
        {
            // для типа если истек таймер
            ShowNotification(playerid, 4, 6, 0, 0, "!!!!", "ок");
            JSON_SetInt(json, "t", 1);
            
            OnPacketIncoming(playerid, 7, json);
            JSON_Cleanup(json);
        }
        case 2:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "Клик", "ок");  // для обычного типа, обработка нажатия
          }
          case 3:
          {
            ShowNotification(playerid, 4, 6, 0, 0, "niSnisniS!", "ок");
           }
      }
      OnPacketIncoming(playerid, provodaGui, json);
      JSON_Cleanup(json);
  }
  case larekgui:
        {
            new query[220];
            new actionType, orderMask;

            JSON_GetInt(json, "t", actionType);
            JSON_GetInt(json, "r", orderMask);
            
            if(actionType == 1 && orderMask > 0)
            {
                new businessid = GetPlayerInBiz(playerid);
                new totalCost = CalculateTotalCost(orderMask);
                new take_prods = random(4) + 6;
               
                if(GetBusinessData(businessid, B_PRODS) < take_prods)
                {
                    ShowNotification(playerid, 2, 5, 1, 1, "В бизнесе недостаточно еды для покупки!", "");
                    JSON_SetInt(json, "t", actionType);
                    ShowPlayerGUI(playerid, 3, json);
                    SetPlayerInBiz(playerid, -1); 
                    SetPVarInt(playerid, "BlockBuy", 1);
                    SetTimerEx("ResetBlockBuyFP", 5000, true, "i", playerid);
                }
                
                if(GetPlayerMoney(playerid) >= totalCost)
                {
                     new block = GetPVarInt(playerid, "BlockBuy");
                     if(block == 1) {
                      }
                      else
                      {
                       GivePlayerMoneyEx(playerid, -totalCost, "Покупка еды в ларьке", false, false);
                       DeletePVar(playerid, "BlockBuy");
                      }
                                 
                    if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                    {
                     new block = GetPVarInt(playerid, "BlockBuy");
                     if(block == 1) {
                      }
                      else
                      {
                        format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+totalCost, GetBusinessData(businessid, B_SQL_ID));
                        mysql_query(mysql, query, false);
                        DeletePVar(playerid, "BlockBuy");
                        }
                    }

                    if(!mysql_errno())
                    {
                        if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                        {
                           new block = GetPVarInt(playerid, "BlockBuy");
                            if(block == 1) {
                            }
                             else
                           {
                             AddBusinessData(businessid, B_PRODS, -, take_prods);
                             AddBusinessData(businessid, B_BALANCE, +, totalCost);
                             DeletePVar(playerid, "BlockBuy");
                           }
                       }
                      new block = GetPVarInt(playerid, "BlockBuy");
                     if(block == 1) {
                      }
                      else
                      {
                        mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), totalCost, IsBusinessOwned(businessid));
                        mysql_query(mysql, query, false);
                        DeletePVar(playerid, "BlockBuy");
                        }
                    }
                    
                    JSON_SetInt(json, "t", actionType);
                    JSON_SetInt(json, "m", orderMask);
                    ShowPlayerGUI(playerid, larekgui, json);
                }
                else
                {
                    ShowNotification(playerid, 2, 5, 1, 1, "Недостаточно денег для покупки еды!", "");
                    JSON_SetInt(json, "t", 1);
                    ShowPlayerGUI(playerid, 3, json);
                }
            }            
            JSON_Cleanup(json);
            SetPlayerInBiz(playerid, -1);
        }
        case 74:
{
    new type;
    JSON_GetInt(json, "t", type);
    printf("[DEBUG] Case 74 | Player: %d | Type: %d", playerid, type);

    switch (type)
    {
        case 3:
        {
            JSON_SetInt(json, "c", 1);
            ShowCasesGUI(playerid);
        }
        case 1:
        {
            JSON_SetInt(json, "t", 1);
            SetPVarInt(playerid, "reward_offset", 0);
            new query[128];
            mysql_format(mysql, query, sizeof(query), "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT 0, 15", GetPlayerAccountID(playerid));
            mysql_tquery(mysql, query, "OnPlayerRewardsLoad", "i", playerid);
        }
        case 2:
        {
            new offset = GetPVarInt(playerid, "reward_offset");
            offset += 14;
            SetPVarInt(playerid, "reward_offset", offset);

            new query[128];
            mysql_format(mysql, query, sizeof(query), "SELECT `id`, `award_id`, `case_id` FROM `rewards` WHERE `uid` = %d LIMIT %d, 15", GetPlayerAccountID(playerid), offset);
            mysql_tquery(mysql, query, "OnPlayerRewardsLoad", "i", playerid);
        }
        case 4:
        {
            new reward_db_id, reward_action;
            JSON_GetInt(json, "id", reward_db_id);
            JSON_GetInt(json, "s", reward_action);
            if(reward_action != 1 && reward_action != 3) reward_action = 1;

            new query[128];
            mysql_format(mysql, query, sizeof(query), "SELECT `award_id`, `case_id` FROM `rewards` WHERE `id` = %d AND `uid` = %d LIMIT 1", reward_db_id, GetPlayerAccountID(playerid));
            mysql_tquery(mysql, query, "OnRewardDebug", "iii", playerid, reward_db_id, reward_action);
        }
        default:
        {
            printf("[DEBUG] Unknown Type %d in Case 74 for Player %d", type, playerid);
        }
    }
    OnPacketIncoming(playerid, 74, json);
    JSON_Cleanup(json);
}
        case 73:
{
    new type;
    JSON_GetInt(json, "t", type);
    switch (type)
    {
        case 3:
        {
            new Node:response = JSON_Object();

            JSON_SetInt(response, "t", 3);

            JSON_SetInt(response, "s", 1);

            new cs_val = GetPVarInt(playerid, "case_open_cs");
            if(cs_val <= 0) JSON_GetInt(json, "cs", cs_val);
            if(JSON_GetType(json, "bt1") == JSON_NODE_ARRAY)
            {
                new Node:bt1_array, bt1_len;

                JSON_GetArray(json, "bt1", bt1_array);
                JSON_ArrayLength(bt1_array, bt1_len);
                new log_msg[256];
                format(log_msg, sizeof(log_msg), "[Cases] Player %d collected %d rewards. IDs: ", playerid, bt1_len);
                for(new i = 0; i < bt1_len; i++)
                {
                    new Node:elem, reward_ui_id;

                    JSON_ArrayObject(bt1_array, i, elem);

                    JSON_GetNodeInt(elem, reward_ui_id);
                    // if(!ConsumeOpenedCaseReward(playerid, reward_ui_id)) continue;
                    new temp[16];
                    format(temp, sizeof(temp), "%d, ", reward_ui_id);
                    strcat(log_msg, temp);
                    if(cs_val > 0)
                    {
                     GiveRewardsFromGUI(playerid, reward_ui_id, cs_val);                     
                    }
                }
                printf("%s", log_msg);

                JSON_SetArray(response, "bt1", bt1_array);
            }
            if(JSON_GetType(json, "bt2") == JSON_NODE_ARRAY)
            {
                new Node:bt2_array, bt2_len;

                JSON_GetArray(json, "bt2", bt2_array);

                JSON_ArrayLength(bt2_array, bt2_len);
                new log_msg[256];

                format(log_msg, sizeof(log_msg), "[cases] Player %d sprayed rewards IDs: ", playerid);
                new total_spray = 0;

                for(new i = 0; i < bt2_len; i++)
                {
                    new Node:elem, reward_ui_id;

                    JSON_ArrayObject(bt2_array, i, elem);

                    JSON_GetNodeInt(elem, reward_ui_id);

                    // if(!ConsumeOpenedCaseReward(playerid, reward_ui_id)) continue;

                    new temp[16];

                    format(temp, sizeof(temp), "%d, ", reward_ui_id);

                    strcat(log_msg, temp);

                    total_spray += GetCaseAwardSprayDustByIndex(cs_val, reward_ui_id);
                }
                if(total_spray > 0)
                {
                    AddPlayerDustValue(playerid, total_spray);
                    SavePlayerAccount(playerid);
                }
                printf("%s", log_msg);

                JSON_SetArray(response, "bt2", bt2_array);
            }
            if(GetPVarInt(playerid, "case_open_total") <= 0)
            {
                // ResetOpenedCaseRewards(playerid);
            }
            
new player_dust = GetPVarInt(playerid, "player_dust");
new total_super_cases = 0;
if(player_dust > dust_limit)
{
    new remaining_dust = player_dust;
    new message[128];
    new total_deducted = 0;
    
    while(remaining_dust > dust_limit)
    {
        new deduct_amount = remaining_dust - dust_limit;
        if(deduct_amount > dust_limit) deduct_amount = dust_limit;
       
        total_deducted += deduct_amount;
        remaining_dust -= deduct_amount;
        total_super_cases++;
    }
    
    // ЕСЛИ ОСТАЛОСЬ РОВНО 2000 - ОБНУЛЯЕМ
    if(remaining_dust == dust_limit)
    {
        remaining_dust = 0;
        AddPlayerCaseCountByType(playerid, 5, 1);
        SavePlayerAccount(playerid);
    }
    
    if(remaining_dust < 0) remaining_dust = 0;
if(total_super_cases > 0)
{
    AddPlayerCaseCountByType(playerid, 5, total_super_cases);
    SavePlayerAccount(playerid);
}

    printf("[Пыль] Игрок %d: списано %d, остаток %d", playerid, total_deducted, remaining_dust);
    
    JSON_SetInt(json, "t", 5);
    SetPVarInt(playerid, "player_dust", remaining_dust);
    JSON_SetInt(json, "pc", remaining_dust);
    JSON_SetInt(json, "s", 0);
    OnPacketIncoming(playerid, 73, json);
     JSON_Cleanup(json);
}
else
{
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));
    OnPacketIncoming(playerid, 73, json);
     JSON_Cleanup(json);
}

                JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
              JSON_SetInt(response, "pc", GetPlayerDustValue(playerid));
               new Node:cc_array = JSON_Array(); 
             for (new i = 1; i <= 11; i++)
             {
              new Node:cc_obj = JSON_Object();
               JSON_SetInt(cc_obj, "id", i);
               JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, i));
               new Node:tempArray = JSON_Array(cc_obj);
                cc_array = JSON_Append(cc_array, tempArray);
               }
           JSON_SetArray(response, "cc", cc_array);

             OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
        }
        case 1:
        {
           new Node:response = JSON_Object();

            JSON_SetInt(response, "t", 1);

            JSON_SetInt(response, "s", 1);

            JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));

            JSON_SetInt(response, "pc", GetPlayerDustValue(playerid));
            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
        }
       case 6:
        {
            callcmd::reward(playerid, "");
        }
        case 2:
{
    new type_val = 1, cs_val = -1;

    JSON_GetInt(json, "type", type_val);

    JSON_GetInt(json, "cs", cs_val);
    SetPVarInt(playerid, "case_open_cs", cs_val);

    // ResetOpenedCaseRewards(playerid);
    new Node:response = JSON_Object();

    JSON_SetInt(response, "t", 2);

    JSON_SetInt(response, "s", 1);
    new open_count = (type_val == 2) ? 10 : 1;

    new price = 0;
    switch(cs_val)
    {
        case 1: price = 0;
        case 2: price = (open_count == 10) ? 1000 : 100;      
        case 3: price = (open_count == 10) ? 7000 : 700;
        case 4: price = (open_count == 10) ? 11400: 1200;
        case 5: price = (open_count == 10) ? 100000 : 10000;        
        case 6: price = (open_count == 10) ? 9000: 900;
        case 7: price = (open_count == 10) ? 9000: 900;
        case 8: price = (open_count == 10) ? 9000: 900;
        case 9: price = (open_count == 10) ? 9000: 900;
        case 10: price = (open_count == 10) ? 9000: 900;
        case 11: price = (open_count == 10) ? 9000: 900;
        
        default:
        {
            JSON_SetInt(response, "s", 0);
            JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));

            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
        }
    }
    if(cs_val < 1 || cs_val > 11) {
    }
    new have_cases = GetPlayerCaseCountByType(playerid, cs_val);

    new bool:use_bc = false;
    if(have_cases < open_count)
    {
        if(GetPlayerDonateRub(playerid) < price)
        {
            JSON_SetInt(response, "s", 0);

            JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));

            OnPacketIncoming(playerid, 73, response);

            JSON_Cleanup(response);
            ShowNotification(playerid, 2, 4, 1, 1, "Недостаточно BC для открытия данного кейса", "");
        }
        use_bc = true;
    }
    if(use_bc) 
    {
        if(price > 0) GivePlayerDonateRub(playerid, -price);
    }
    else 
    {
       AddPlayerCaseCountByType(playerid, cs_val, -open_count);
    }
    SavePlayerAccount(playerid);
if(cs_val > 0)
{
    new max_range = GetCaseAwardsCount(cs_val);
    
    if(max_range <= 0)
    {
        JSON_SetInt(response, "s", 0);
        return;
    }
    
    if(open_count == 1)
    {
        new randOne = random(max_range) + 1;  // рандом из ВСЕХ наград кейса
        JSON_SetArray(response, "pr", JSON_Array(JSON_Int(randOne)));
    }
    else
    {
        new Node:prArray = JSON_Array();
        for(new i = 0; i < open_count; i++)
        {
            new r = random(max_range) + 1; 
            prArray = JSON_Append(prArray, JSON_Array(JSON_Int(r)));
        }
        JSON_SetArray(response, "pr", prArray);
    }
}
else
{
    JSON_SetInt(response, "s", 0);
}
    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
    JSON_SetArray(response, "cc", BuildPlayerCasesArray(playerid));

    OnPacketIncoming(playerid, 73, response);
    JSON_Cleanup(response);
}
        default:

        {
        }
    }
}
  case eventgui:
{
    new ActionId;
    JSON_GetInt(json, "t", ActionId); 
    
    switch(ActionId) 
    {
        case 0:
        {
            ShowNotification(playerid, 4, 6, 1, 0, "окок (окок case 0)", "ок");
        }
        case 1:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 1)", "ок");
        }
        case 2:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 2);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 2", "ок");
            OnPacketIncoming(playerid, 30, response);
            JSON_Cleanup(response);
        }
        case 3:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 3)", "ок");
        }
        case 4:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 4)", "ок");
        }
        case 5:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 5);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 5", "ок");
            JSON_SetInt(response, "m", 1);
            
            new Node:ratingArray = JSON_Array(
        JSON_String("Lox_Lox"), JSON_String("Derixton_Top")
         );
        
          new Node:tasksArray = JSON_Array(
        JSON_Int(1), JSON_Int(6), JSON_Int(2)
         );
         
         JSON_SetArray(JSONObject, "j", ratingArray);
         JSON_SetArray(JSONObject, "tk", tasksArray);
         OnPacketIncoming(playerid, 30, response);
         JSON_Cleanup(response);
        }
        case 6:
        {
            JSON_SetInt(json, "t", 6);
            EventGUITest(playerid);  
            ShowNotification(playerid, 4, 6, 0, 0, "Забрать награду", "ок");           
        }
        case 7:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 7)", "ок");
        }
        case 8:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 8)", "ок");
        }
        case 9:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 9)", "ок");
        }
        case 10:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 10)", "ок");
        }
        case 11:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 11)", "ок");
        }
        case 12:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 12)", "ок");
        }
        case 13:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 13)", "ок");
        }
        case 14:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 14)", "ок");
        }
        case 15:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 15)", "ок");
        }
        case 16:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 16)", "ок");
        }
        case 17:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 17)", "ок");
        }
        case 18:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 18)", "ок");
        }
        case 19:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 19)", "ок");
        }
        case 20:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 20)", "ок");
        }
        case 21:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 21)", "ок");
        }
        case 22:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 22)", "ок");
        }
        case 23:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 23)", "ок");
        }
        case 24:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 24)", "ок");
        }
        case 25:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 25)", "ок");
        }
        case 26:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 26)", "ок");
        }
        case 27:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 27)", "ок");
        }
        case 28:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 28)", "ок");
        }
        case 29:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 29)", "ок");
        }
        case 30:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 30)", "ок");
          }
      }
      // JSON_Stringify(json, outcoming_data);
      OnPacketIncoming(playerid, 30, json);
      JSON_Cleanup(json);
  }
  
   case fama:
{
    new ActionId;
    JSON_GetInt(json, "t", ActionId);
    
    switch(ActionId) 
    {
        case 0:
        {
             new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 0);
            ShowNotification(playerid, 4, 6, 0, 0, "Click", "ок");
            OnPacketIncoming(playerid, 45, response);
            JSON_Cleanup(response);
        }
        case 1:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 1);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 1", "ок");
            OnPacketIncoming(playerid, 45, response);
            JSON_Cleanup(response);
        }
        case 2:
        {
             new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 2);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 2", "ок");
            OnPacketIncoming(playerid, 45, response);
            JSON_Cleanup(response);
        }
        case 3:
        {
             new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 3);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 3", "ок");
            OnPacketIncoming(playerid, 45, response);
            JSON_Cleanup(response);
        }
        case 4:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 4);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 4", "ок");
            OnPacketIncoming(playerid, 45, response);
            JSON_Cleanup(response);
        }
        case 5:
        {
             new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 5);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 5", "ок");
            OnPacketIncoming(playerid, 45, response);
            JSON_Cleanup(response);
        }
        case 6:
        {
             new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 6);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 6", "ок");
            OnPacketIncoming(playerid, 45, response);
            JSON_Cleanup(response);
        }
        case 7:
        {
            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", 7);
            ShowNotification(playerid, 4, 6, 0, 0, "Click 7", "ок");
            OnPacketIncoming(playerid, 45, response);
            JSON_Cleanup(response);
        }
        case 8:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "Close", "ок");
        }
        case 9:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 9)", "ок");
        }
        case 10:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 10)", "ок");
        }
        case 11:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 11)", "ок");
        }
        case 12:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 12)", "ок");
        }
        case 13:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 13)", "ок");
        }
        case 14:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 14)", "ок");
        }
        case 15:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 15)", "ок");
        }
        case 16:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 16)", "ок");
        }
        case 17:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 17)", "ок");
        }
        case 18:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 18)", "ок");
        }
        case 19:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 19)", "ок");
        }
        case 20:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 20)", "ок");
        }
        case 21:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 21)", "ок");
        }
        case 22:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 22)", "ок");
        }
        case 23:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 23)", "ок");
        }
        case 24:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 24)", "ок");
        }
        case 25:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 25)", "ок");
        }
        case 26:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 26)", "ок");
        }
        case 27:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 27)", "ок");
        }
        case 28:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 28)", "ок");
        }
        case 29:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 29)", "ок");
        }
        case 30:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 30)", "ок");
          }
      }
      OnPacketIncoming(playerid, 30, json);
      JSON_Cleanup(json);
  }
      case spawngui:
{
    new json = JSON_Object();
    new spawn_id;

    JSON_GetInt(json, "t", spawn_id);

    switch(spawn_id)
    {
        case 1:
        {
           SpawnVogzal(playerid);
        }        
        case 0:
        {
            new team_id = GetPlayerTeamEx(playerid);
            SetSpawnInfo(
                playerid,
                0,
                GetPlayerSkinEx(playerid),
                GetTeamData(team_id, O_SPAWN)[0],
                GetTeamData(team_id, O_SPAWN)[1],
                GetTeamData(team_id, O_SPAWN)[2],
                GetTeamData(team_id, O_SPAWN)[3],
                0,0,0,0,0,0
            );
            
            SetCameraBehindPlayer(playerid);
   		TogglePlayerControllable(playerid, true);
            SetPlayerInterior(playerid, GetTeamData(team_id, O_SPAWN_INT));
            SetPlayerVirtualWorld(playerid, GetTeamData(team_id, O_SPAWN_VW));
        }
        case 2:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "последнее место", "ок");
         }
         case 3:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "гараж", "ок");
         }
         case 5:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "семейный гараж", "ок");
         }
         case 6:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "Семейный дом", "ок");
         }
         case 7:
         {
            ShowNotification(playerid, 4, 6, 0, 0, "яхта", "ок");        
         }
         
        case 4:
        {
            new type = GetHouseData(GetPlayerHouse(playerid, HOUSE_TYPE_HOME), H_TYPE);

            SetSpawnInfo(
                playerid,
                0,
                GetPlayerSkinEx(playerid),
                GetHouseTypeInfo(type, HT_ENTER_POS_X),
                GetHouseTypeInfo(type, HT_ENTER_POS_Y),
                GetHouseTypeInfo(type, HT_ENTER_POS_Z),
                GetHouseTypeInfo(type, HT_ENTER_POS_ANGLE),
                0,0,0,0,0,0
            );
             
            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME) + 2000);
            SetCameraBehindPlayer(playerid);
    		TogglePlayerControllable(playerid, true);
            SetPlayerInHouse(playerid, GetPlayerHouse(playerid, HOUSE_TYPE_HOME));
        }
    }

    SpawnPlayer(playerid);
    SetPlayerSpawnInit(playerid);
    
    new json_data[256];
    new Node:json_packet_data = JSON_Object();
    JSON_SetInt(json_packet_data, "c", 1);

    OnPacketIncoming(playerid, 50, json_packet_data);
    JSON_Cleanup(json_packet_data);
}     

 case 14:
{
    new MenuBID;
    JSON_GetInt(json, "t", MenuBID);
    
    switch(MenuBID) 
    {
        case 0:
        {
            callcmd::gps(playerid, "");
        }
        case 1:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "taix", "ок");
         //   callcmd::taix(playerid, "");
        }
        case 2:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "статистика игрока", "ок");
            callcmd::mm(playerid, "");
        }
        case 3:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 3)", "ок");
        }
        case 4:
        {
            callcmd::inv(playerid, "");
        }
        case 5:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 5)", "ок");
        }
        case 6:
        {
            callcmd::donate(playerid, "");
        }
        case 7:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "транспорт", "ок");
            callcmd::car(playerid, "");
        }
        case 8:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 8)", "ок");
        }
        case 9:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "Жалобы открыт", "ок");
            callcmd::report(playerid, "");
        }
        case 10:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 10)", "ок");
        }
        case 11:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 11)", "ок");
        }
        case 12:
        {
            CalendarGUI(playerid);
        }
        case 13:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 13)", "ок");
        }
        case 14:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 14)", "ок");
        }
        case 15:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 15)", "ок");
        }
        case 16:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 16)", "ок");
        }
        case 17:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 17)", "ок");
        }
        case 18:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 18)", "ок");
        }
        case 19:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 19)", "ок");
        }
        case 20:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 20)", "ок");
        }
        case 21:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 21)", "ок");
        }
        case 22:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 22)", "ок");
        }
        case 23:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 23)", "ок");
        }
        case 24:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 24)", "ок");
        }
        case 25:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 25)", "ок");
        }
        case 26:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 26)", "ок");
        }
        case 27:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 27)", "ок");
        }
        case 28:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 28)", "ок");
        }
        case 29:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 29)", "ок");
        }
        case 30:
        {
            ShowNotification(playerid, 4, 6, 0, 0, "окок (окок case 30)", "ок");
          }
      }
      OnPacketIncoming(playerid, 14, json);
      JSON_Cleanup(json);
  }
case tunegui:
 {
            new Node:json_packet_data = JSON_Object();
            new outcoming_data[512];

            new type, selector_id, data_value, type_of_detail, status, sound_id, color_type;
            new vinyl[32], color[16];     
            
            JSON_GetInt(json, "m", color_type);      
            JSON_GetString(json, "d", color);
            JSON_GetInt(json, "p", data_value);
            
            JSON_GetInt(json, "t", type);
            JSON_GetInt(json, "m", selector_id);
            JSON_GetInt(json, "d", data_value);
            JSON_GetInt(json, "mt", type_of_detail);
            JSON_GetInt(json, "s", status);
            JSON_GetString(json, "co", color, sizeof(color)); 
            JSON_GetString(json, "v", vinyl, sizeof(vinyl));
            JSON_GetInt(json, "h", sound_id);
             
             new str[256];
        format(str, sizeof(str), "GUI 28: t=%d, m=%d, d=%d, mt=%d, s=%d, co=%s, v=%s, h=%d", type, selector_id, data_value, type_of_detail, status, color, vinyl, sound_id);
           ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");         

            switch (type)
            {
                case 0:
                {   
                 new vehicleid = GetPlayerVehicleID(playerid);
                 SetCameraBehindPlayer(playerid);
                 TogglePlayerControllable(playerid, 1);
   
                 TeleportToExit(playerid); 
                 JSON_SetInt(json_packet_data, "t", 0);
                 JSON_SetInt(json_packet_data, "s", 1);      
                 StreamingVehicleColors(playerid, vehicleid);
                 StreamingToner(playerid, vehicleid);
                 StreamingNeon(playerid, vehicleid);
                 StreamingLighColor(playerid, vehicleid);
                }               
                case 1:    
{
    printf("[DEBUG] StyllingCenter: Type: %d, ColorType: %d, Color: %s", type, color_type, color);
    new color_val, vehid = GetPlayerVehicleID(playerid);
    sscanf(color, "h", color_val); 

            if(color_type == 0) // кузов
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new price = GetBodyPaintCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));

                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);                    
                    new fmt_text[256],
                    idx = GetPVarInt(playerid, "ownablecar_id");
                	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET `body_color`=%d, `color_1`=%d WHERE id='%d' LIMIT 1", color_val, color_val, idx);
                	mysql_query(mysql, fmt_text, false);                    
                    JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(json_packet_data, "s", 1);
                    vInfo[vehicleid][vBodyColor] = color_val;
                    StreamingVehicleColors(playerid, vehicleid);
                }
                else
                {
                    JSON_SetInt(json_packet_data, "s", 0);
                }
            } 
            if(color_type == 1) // диски
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new price = GetBodyPaintCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));

                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);                    
                    new fmt_text[256],
                    idx = GetPVarInt(playerid, "ownablecar_id");
                	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET `disk_color`=%d, `color_2`=%d WHERE id='%d' LIMIT 1", color_val, color_val, idx);
                	mysql_query(mysql, fmt_text, false);                    
                    JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(json_packet_data, "s", 1);
                    vInfo[vehicleid][vDiskColor] = color_val;
                    StreamingVehicleColors(playerid, vehicleid);
                }
                else
                {
                    JSON_SetInt(json_packet_data, "s", 0);
                }
            }           
            if(color_type == 3) // передняя тонировка
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new price = GetExtraCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));
            
                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);                    
                    new fmt_text[256],
                    idx = GetPVarInt(playerid, "ownablecar_id");
                	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET `pered_windcolor`=%d WHERE id='%d' LIMIT 1", color_val, idx);
                	mysql_query(mysql, fmt_text, false);                    
                    JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(json_packet_data, "s", 1);
                    vInfo[vehicleid][vWindFront] = color_val;
                    StreamingToner(playerid, vehicleid);
                }
                else
                {
                    JSON_SetInt(json_packet_data, "s", 0);
                }
            }           
            if(color_type == 4) // задний тонер
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new price = GetExtraCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));
                
                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);                    
                    new fmt_text[256],
                    idx = GetPVarInt(playerid, "ownablecar_id");
                	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET `zadni_windcolor`=%d WHERE id='%d' LIMIT 1", color_val, idx);
                	mysql_query(mysql, fmt_text, false);                    
                    JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(json_packet_data, "s", 1);
                    vInfo[vehicleid][vWindRear] = color_val;
                    StreamingToner(playerid, vehicleid);
                }
                else
                {
                    JSON_SetInt(json_packet_data, "s", 0);
                }
            }           
            else if(color_type == 10 || color_type == 11 || color_type == 12 || color_type == 13)
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new price = GetUnivCost(GetVehiclePriceByModel(GetVehicleModel(vehicleid)));          
                             
                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);      

                     if(color_type == 10)
                    {
                       vInfo[vehicleid][vLightColor] = color_val;
                       new fmt_text[256],
                       idx = GetPVarInt(playerid, "ownablecar_id");
                   	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET `l_color`=%d WHERE id='%d' LIMIT 1", color_val, idx);
                   	mysql_query(mysql, fmt_text, false);                    
                    }                                        
                    else if(color_type == 11)
                    {                  
                       vInfo[vehicleid][vNeonMain] = color_val;
                       new fmt_text[256],
                       idx = GetPVarInt(playerid, "ownablecar_id");
                   	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET `neon_main`=%d WHERE id='%d' LIMIT 1", color_val, idx);
                   	mysql_query(mysql, fmt_text, false);                  
                    }
                    else if(color_type == 12)
                    {
                        vInfo[vehicleid][vNeon1] = color_val;
                        new fmt_text[256],            
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET `neon1`=%d WHERE id='%d' LIMIT 1", color_val, idx);
                    	mysql_query(mysql, fmt_text, false);
                        GivePlayerMoneyEx(playerid, -price);                    
                    }
                    else if(color_type == 13)
                    {
                        GivePlayerMoneyEx(playerid, -price);
                        vInfo[vehicleid][vNeon2] = color_val;
                        new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET `neon2`=%d WHERE id='%d' LIMIT 1", color_val, idx);
                    	mysql_query(mysql, fmt_text, false);                    
                    }                
                }
            }
            JSON_SetString(json_packet_data, "co", color, sizeof(color));        
       }
                    case 2:
                    {                    
                    new price = 1;
                    if (GetPlayerDonateRub(playerid) >= price)
                    {
                        GivePlayerDonateRub(playerid, -price);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "2", ">>");

                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "m", selector_id);
        //                JSON_SetString(json_packet_data, "co", _color);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        
                    }
                    else
                    {
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
                    }
                }
                case 3:
                {
                    new price = 10;
                    if (GetPlayerDonateRub(playerid) >= price)
                    {
                        GivePlayerDonateRub(playerid, -price);
                        new str[128];
                        format(str, sizeof(str), "Винил %s (ID: %d)", vinyl, data_value);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Ты купил винил", ">>");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "d", data_value);
                        JSON_SetString(json_packet_data, "v", vinyl);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        
                    }
                    else
                    {
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
                    }
                }
                case 5:
                {
                    new str[128];
                format(str, sizeof(str), "Деталь %d", type_of_detail);
               ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                     ShowNotificationNew(playerid, 1, 6, 0, 0, "5", ">>");
                    JSON_SetInt(json_packet_data, "s", 1);
                    JSON_SetInt(json_packet_data, "m", selector_id);
                    JSON_SetInt(json_packet_data, "mt", type_of_detail);
                }              
                case 6:
                {
                    new str[128];
                format(str, sizeof(str), "Заглушка: Деталь ID %d установлена", data_value);
               ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", 1);
                    JSON_SetInt(json_packet_data, "p", data_value);
                    ShowNotificationNew(playerid, 1, 6, 0, 0, "6", ">>");
                }               
                case 7:
                {
                    new vehicleid = GetPlayerVehicleID(playerid);
                        JSON_GetInt(json, "mt", type_of_detail);
                        JSON_SetInt(json_packet_data, "mt", type_of_detail);
                         
                        new str[128];                      
                       format(str, sizeof(str), "Деталь ID %d установлена", data_value);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
         
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "d", data_value);
                        JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "7", ">>");
                        JSON_SetInt(json_packet_data, "p", data_value);
                        
                        if (data_value == 2534)
                        {
                              SaveTuningPart(playerid, vSpoiler, 2345);
                              JSON_SetInt(json_packet_data, "s", 1);
                              JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                              ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы приобрели обвес", ">>");
                        }
                        if (data_value == 2533)
                        {
                              SaveTuningPart(playerid, vKapot, 2344);
                              JSON_SetInt(json_packet_data, "s", 1);
                              JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                              ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы приобрели обвес", ">>");
                        }
                        if (data_value == 2532)
                        {
                              SaveTuningPart(playerid, vBumpZad, 2343);
                              JSON_SetInt(json_packet_data, "s", 1);
                              JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                              ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы приобрели обвес", ">>");
                        }
                        if (data_value == 2531)
                        {
                              SaveTuningPart(playerid, vBumpPered, 2342);
                              JSON_SetInt(json_packet_data, "s", 1);
                              JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                              ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы приобрели обвес", ">>");
                        }
                        
                        if (data_value == 2535)
                        {
                              SaveTuningPart(playerid, vPorogi, 2346);
                              JSON_SetInt(json_packet_data, "s", 1);
                              JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                              ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы приобрели обвес", ">>");
                        }
                        
                        if (data_value == 129)
                        {
                         new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET horn='40'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);  
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы приобрели клаксон {ff0000}человек года", ">>");
                        }
                         // 5 & 10 & 15 & 20 & 25 детали спорт
                         if (data_value == 7)
                        {
                         new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET spp1='1'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);  
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы 1", ">>");
                        vInfo[vehicleid][vSportP1] = 1;
                        }
                        if (data_value == 12)
                        {
                         new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET spp2='1'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);  
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы 2", ">>");
                        vInfo[vehicleid][vSportP2] = 1;
                        }
                        if (data_value == 17)
                        {
                         new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET spp3='1'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);  
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы 3", ">>");
                        vInfo[vehicleid][vSportP3] = 1;
                        }
                        if (data_value == 22)
                        {
                         new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET spp4='1'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);  
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы 4", ">>");
                        vInfo[vehicleid][vSportP4] = 1;
                        }
                        if (data_value == 27)
                        {
                         new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET spp5='1'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);  
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы 5", ">>");
                        vInfo[vehicleid][vSportP5] = 1;
                        }                       
                        if (data_value >= 36 && data_value <= 92)
                      {
                      if (GetPlayerMoneyEx(playerid) >= 80000)
                  {                    
                      GivePlayerMoneyEx(playerid, -80000);
                       new fmt_text[256],
                       idx = GetPVarInt(playerid, "ownablecar_id");  
                       new disk_model = 1908 + (data_value - 36); 
                       vInfo[vehicleid][vDiskModel] = disk_model;
                       mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET diski='%d' WHERE id='%d' LIMIT 1", disk_model, idx);
                       mysql_query(mysql, fmt_text, false);  
                       JSON_SetInt(json_packet_data, "s", 1);
                       JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));                        
                       }
                          else
                          {
                              ShowNotification(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
                           }
                        }
                        if (data_value == 299)
                        {
                          new vehicle = GetPlayerVehicleID(playerid);
                          new price = GetDalniyCost(GetVehiclePriceByModel(GetVehicleModel(vehicle)));      

                        if(GetPlayerMoneyEx(playerid) >= price)
                        {
                           GivePlayerMoneyEx(playerid, -price);
                           new fmt_text[256],                         
                           idx = GetPVarInt(playerid, "ownablecar_id");
                       	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET h_light='1'  WHERE id='%d' LIMIT 1", idx);
                       	mysql_query(mysql, fmt_text, false);  
                           JSON_SetInt(json_packet_data, "s", 1);
                           JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                           ShowNotificationNew(playerid, 1, 6, 0, 0, "Вы успешно купили дальний свет!", ">>");
                           vInfo[vehicleid][vHighLights] = 1;
                         }
                      }
                       if (data_value == 33)
                     {
                         vInfo[vehicleid][vHydraulics] = true;
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Гидравлика куплена", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                        
                        new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET hydra='1'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);                         
                      } 
                      if (data_value == 0)
                     {
                         AddVehicleComponent(GetPlayerVehicleID(playerid), 1008);
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Нитро {ff0000}x2{ffffff} куплено", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                        
                        new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET nitro='1'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);                         
                      } 
                       if (data_value == 1)
                     {
                         AddVehicleComponent(GetPlayerVehicleID(playerid), 1009);
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Нитро {ff0000}x5{ffffff} куплено", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                        
                        new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET nitro='2'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);                         
                      } 
                       if (data_value == 2)
                     {
                         AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Нитро {ff0000}x10{ffffff} куплено", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                        
                        new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET nitro='3'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);                         
                      } 
                      if (data_value == 28)
                     {
                         vInfo[vehicleid][vStrob] = 1;
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Страбоскопы куплены", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                      }  
                      if (data_value == 29)
                     {
                         vInfo[vehicleid][vStrob] = 2;
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Страбоскопы куплены, тип 1", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                      }                    
                      if (data_value == 30)
                     {
                         vInfo[vehicleid][vStrob] = 3;
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Страбоскопы куплены, тип 2", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                      }        
                      if (data_value == 31)
                     {
                         vInfo[vehicleid][vStrob] = 4;
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Страбоскопы куплены, тип 3", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                      }     
                      if (data_value == 32)
                     {
                         vInfo[vehicleid][vStrob] = 5;
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Страбоскопы куплены, тип донатный", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                      }                                                                                                                                                                                                             
                    if (data_value == 35)
                     {
                         vInfo[vehicleid][vLaunchControl] = true;
                         ShowNotificationNew(playerid, 1, 6, 0, 0, "Лаунч контроль куплен", ">>");
                         JSON_SetInt(json_packet_data, "t", 7);
                        JSON_SetInt(json_packet_data, "s", 1);
                        new fmt_text[256],
                        idx = GetPVarInt(playerid, "ownablecar_id");
                    	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET launch='1'  WHERE id='%d' LIMIT 1", idx);
                    	mysql_query(mysql, fmt_text, false);            
                       }                                            
                }
                    case 10:
                {
                    new price = 80;
                    if (GetPlayerDonateRub(playerid) >= price)
                    {
                        GivePlayerDonateRub(playerid, -price);
                        new str[128];
                       format(str, sizeof(str), "Заглушка: Деталь ID %d установлена", data_value);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "d", data_value);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "10", ">>");
                    }
                    else
                    {
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
                    }
                }
                case 8:
                {
                    new price = 60;
                    if (GetPlayerDonateRub(playerid) >= price)
                    {
                        GivePlayerDonateRub(playerid, -price);
                       new str[128];
                       format(str, sizeof(str), "Заглушка: Деталь ID %d установлена", data_value);
                       ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "p", data_value);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "8", ">>");
                    }
                    else
                    {
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
                    }
                }
                case 9:
                {
                    ShowNotificationNew(playerid, 1, 6, 0, 0, "9", ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", 1);
                }
                case 11:
                {
                         new str[128];
                       format(str, sizeof(str), "Заглушка: Деталь ID %d установлена", data_value);
                       ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", 1);
                    JSON_SetInt(json_packet_data, "d", data_value);
                    ShowNotificationNew(playerid, 1, 6, 0, 0, "11", ">>");
                }
                case 12:
{                    
    new str[128];
    format(str, sizeof(str), "Детал %d", data_value);
    ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
    JSON_SetInt(json_packet_data, "t", type);
    JSON_SetInt(json_packet_data, "s", 1);
    JSON_SetInt(json_packet_data, "d", data_value);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));                
    JSON_SetInt(json_packet_data, "m", selector_id);
   new vehicleid = GetPlayerVehicleID(playerid);
   
    if (selector_id == 22)
    {
        if (GetPlayerMoneyEx(playerid) >= 740000)
        {
            vInfo[vehicleid][vClearance] = data_value;
            GivePlayerMoneyEx(playerid, -740000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET clearance='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);
        }                    
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }
    else if (selector_id == 23)
    {
        if (GetPlayerMoneyEx(playerid) >= 520000)
        {
            vInfo[vehicleid][vSeparate] = data_value;
            GivePlayerMoneyEx(playerid, -520000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET pclearance='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);            
        }        
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }
    else if (selector_id == 24)
    {
        if (GetPlayerMoneyEx(playerid) >= 250000)
        {
            vInfo[vehicleid][vDepartureP] = data_value;
            GivePlayerMoneyEx(playerid, -250000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET pered_departure='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);            
        }
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }
    else if (selector_id == 25)
    {
        if (GetPlayerMoneyEx(playerid) >= 250000)
        {
            vInfo[vehicleid][vDepartureZ] = data_value;
            GivePlayerMoneyEx(playerid, -250000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET zad_departure='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);            
        }
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }
    else if (selector_id == 26)
    {
        if (GetPlayerMoneyEx(playerid) >= 390000)
        {
            vInfo[vehicleid][vAlignmentP] = data_value;
            GivePlayerMoneyEx(playerid, -390000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET pered_razval='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);            
        }
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }
    else if (selector_id == 27)
    {
        if (GetPlayerMoneyEx(playerid) >= 390000)
        {
            vInfo[vehicleid][vAlignmentZ] = data_value;
            GivePlayerMoneyEx(playerid, -390000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET zad_razval='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);            
        }
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }
    else if (selector_id == 28)
    {
        if (GetPlayerMoneyEx(playerid) >= 400000)
        {
            vInfo[vehicleid][vWidthP] = data_value;
            GivePlayerMoneyEx(playerid, -400000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET pered_shirina='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);            
        }
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }
    else if (selector_id == 29)
    {
        if (GetPlayerMoneyEx(playerid) >= 400000)
        {
            vInfo[vehicleid][vWidthZ] = data_value;
            GivePlayerMoneyEx(playerid, -400000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET zad_shirina='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);            
        }
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }                                
    else if (selector_id == 30)
    {
        if (GetPlayerMoneyEx(playerid) >= 590000)
        {
            vInfo[vehicleid][vRadius] = data_value;
            GivePlayerMoneyEx(playerid, -590000);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoneyEx(playerid));    
            new fmt_text[256],
            idx = GetPVarInt(playerid, "ownablecar_id");
            mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET radius='%d' WHERE id='%d' LIMIT 1", data_value, idx);
            mysql_query(mysql, fmt_text, false);            
        }
        else
        {
            ShowNotificationNew(playerid, 1, 6, 0, 0, "Недостаточно денег для покупки", ">>");
        }
    }
}
                case 21:
                {
                    new str[128];
                       format(str, sizeof(str), "Color %s (ID: %d)", color, data_value);
                        ShowNotificationNew(playerid, 4, 6, 0, 0, str, ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "m", selector_id);
                    JSON_SetString(json_packet_data, "co", color);
                    ShowNotificationNew(playerid, 1, 6, 0, 0, "21", ">>");
                }
                case 20:
                {
                          
                }
                case 19:
                {
                    new str[128];
                       format(str, sizeof(str), "Col19or %s (ID: %d)", color, data_value);
                        ShowNotificationNew(playerid, 4, 6, 0, 0, str, ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "m", selector_id);
                    JSON_SetString(json_packet_data, "co", color);
                    
                }
                
                case 23:
                {
                    new str[128];
                       format(str, sizeof(str), "Col23or %s (ID: %d)", color, data_value);
                        ShowNotificationNew(playerid, 4, 6, 0, 0, str, ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "m", selector_id);
                    JSON_SetString(json_packet_data, "co", color);
                    
                }
                case 26:
                {
                    new str[128];
                       format(str, sizeof(str), "Винил (26 case eto) %s", vinyl);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetString(json_packet_data, "v", vinyl);
                }
                case 28:
                {
                    new str[128];
                       format(str, sizeof(str), "DATA ID %d", data_value);
                        ShowNotificationNew(playerid, 1, 6, 0, 0, str, ">>");
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "d", data_value);
                    ShowNotificationNew(playerid, 1, 6, 0, 0, "28", ">>");
                }
                default:
                {              
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", 0);
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Для вашего транспорта нету доступных обвесов!", ">>");
                }
            }

            // JSON_Stringify(json_packet_data, outcoming_data);
            OnPacketIncoming(playerid, 28, json_packet_data);
            JSON_Cleanup(json_packet_data);
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
        return;
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

    strmid(g_ownable_car[free_car_id][OC_NUMBER], "", 0, 8, 8);

    SetOwnableCarData(free_car_id, OC_ALARM, false);
    SetOwnableCarData(free_car_id, OC_KEY_IN, false);
    SetOwnableCarData(free_car_id, OC_CREATE, gettime());

    format(g_ownable_car[free_car_id][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    new database_query[256];
    format(database_query, sizeof(database_query), "INSERT INTO ownable_cars (owner_id, model_id, color_1, color_2, pos_x, pos_y, pos_z, angle, create_time) VALUES ('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
        GetPlayerAccountID(playerid), game_id, color, color, pos_x, pos_y, pos_z, angle, gettime());
    mysql_query(mysql, database_query, true);

    for(new i = 0; i < g_player_donate_data[playerid][ADDED_PROMOTIONS]; i++)
    {
        if(g_player_added_promotions_data[playerid][i][0] == internal_id)
        {
            g_player_added_promotions_data[playerid][i][0] = -1;
        }
    }
}

public BuyPlayerSkin(playerid, internal_id, game_id)
{
    SetPlayerData(playerid, P_SKIN, game_id);
    UpdatePlayerDatabaseInt(playerid, "skin", game_id);
    SetPlayerSkin(playerid, game_id);
    SetPlayerSkinInit(playerid);
}

public ShowSuccesfullBuyPack(playerid, pack_name[128], price, internal_id)
{
    new Node:json_packet_data = JSON_Object(), json_data[512];
    JSON_SetInt(json_packet_data, "t", 0);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "g", internal_id);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Вы успешно приобрели набор -");
    JSON_SetString(json_packet_data, "n", pack_name);
    // JSON_Stringify(json_packet_data, json_data);
    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
}

stock GetPlayerDustValue(playerid)
{
    return GetPVarInt(playerid, "player_dust");
}

stock AddPlayerDustValue(playerid, amount)
{
    new dust = GetPVarInt(playerid, "player_dust");
    dust += amount;
    if(dust < 0) dust = 0;
    SetPVarInt(playerid, "player_dust", dust);
    return dust;
}

stock GetPlayerCaseCountByType(playerid, case_type)
{
    switch(case_type)
    {
        case 1: return g_player_cases[playerid][pCountTodayCases];
        case 2: return g_player_cases[playerid][pCountBomjCases];
        case 3: return g_player_cases[playerid][pCountStandartCases];
        case 4: return g_player_cases[playerid][pCountCarCases];
        case 5: return g_player_cases[playerid][pCountOsobiyCases];
        case 6: return g_player_cases[playerid][pCountVershinaCases];
        case 7: return g_player_cases[playerid][pCountHall2024Cases];
        case 8: return g_player_cases[playerid][pCountDriveCases];
        case 9: return g_player_cases[playerid][pCountVesnaCases];
        case 10: return g_player_cases[playerid][pCountBlicCases];
        case 11: return g_player_cases[playerid][pCountDelo5Cases];
    }
    return 0;
}

stock SetPlayerCaseCountByType(playerid, case_type, value)
{
    if(value < 0) value = 0;

    switch(case_type)
    {
        case 1: g_player_cases[playerid][pCountTodayCases] = value;
        case 2: g_player_cases[playerid][pCountBomjCases] = value;
        case 3: g_player_cases[playerid][pCountStandartCases] = value;
        case 4: g_player_cases[playerid][pCountCarCases] = value;
        case 5: g_player_cases[playerid][pCountOsobiyCases] = value;
        case 6: g_player_cases[playerid][pCountVershinaCases] = value;
        case 7: g_player_cases[playerid][pCountHall2024Cases] = value;
        case 8: g_player_cases[playerid][pCountDriveCases] = value;
        case 9: g_player_cases[playerid][pCountVesnaCases] = value;
        case 10: g_player_cases[playerid][pCountBlicCases] = value;
        case 11: g_player_cases[playerid][pCountDelo5Cases] = value;
        default: return 0;
    }
    return 1;
}

stock AddPlayerCaseCountByType(playerid, case_type, amount)
{
    return SetPlayerCaseCountByType(playerid, case_type, GetPlayerCaseCountByType(playerid, case_type) + amount);
}

stock Node:BuildPlayerCasesArray(playerid)
{
    new Node:cc_array = JSON_Array();

    for(new i = 1; i <= 11; i++)
    {
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", i);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, i));
        
        new Node:inner_array = JSON_Array(cc_obj);

        new Node:wrapper_array = JSON_Array(inner_array);

        cc_array = JSON_Append(cc_array, wrapper_array);
    }
    return cc_array;
}

stock ShowCasesGUI(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "o", 1);
    JSON_SetBool(json, "s", false);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerDustValue(playerid));

    new Node:cc_array = JSON_Array();
    
    for (new i = 1; i <= 30; i++)
    {
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", i);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, i));

        new Node:tempArray = JSON_Array(cc_obj);

        cc_array = JSON_Append(cc_array, tempArray);
    }
    JSON_SetArray(json, "cc", cc_array);

    OnPacketIncoming(playerid, 73, json);
    JSON_Cleanup(json);
    return 1;
}

stock GetCaseAwardsCount(case_id)
{
    if(case_id < 1 || case_id >= sizeof(CaseAwardsCount))
        return 0;
    return CaseAwardsCount[case_id];
}

stock GetCaseAwardSprayDustByIndex(cs_val, reward_index)
{
    new dust = 0;
    
    switch(cs_val)
    {
        case 1: // ЕЖЕДНЕВНЫЙ КЕЙС
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseDailyAwards))
                dust = CaseDailyAwards[reward_index][4];
            else
                dust = 0;
        }
        case 2: // КЕЙС БОМЖА
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseBomjAwards))
                dust = CaseBomjAwards[reward_index][4];
            else
                dust = 0;
        }
        case 3: // СТАНДАРТНЫЙ КЕЙС
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseStandartAwards))
                dust = CaseStandartAwards[reward_index][4];
            else
                dust = 0;
        }
        case 4: // АВТО-КЕЙС 2.0
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseAutoAwards))
                dust = CaseAutoAwards[reward_index][4];
            else
                dust = 0;
        }
        case 5: // ОСОБЫЙ КЕЙС
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseSpecialAwards))
                dust = CaseSpecialAwards[reward_index][4];
            else
                dust = 0;
        }
        case 6: // КЕЙС: К ВЕРШИНАМ
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseVershina_Awards))
                dust = CaseVershina_Awards[reward_index][4];
            else
                dust = 0;
        }
        case 7: // КЕЙС: ОБЛАСТЬ ТЬМЫ
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseHalloween2024_Awards))
                dust = CaseHalloween2024_Awards[reward_index][4];
            else
                dust = 0;
        }
        case 8: // КЕЙС: ДРАЙВ
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseDriveAwards))
                dust = CaseDriveAwards[reward_index][4];
            else
                dust = 0;
        }
        case 9: // КЕЙС: ВЕСЕННИЙ
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseVesenniy_Awards))
                dust = CaseVesenniy_Awards[reward_index][4];
            else
                dust = 0;
        }
        case 10: // КЕЙС: БЛИЦ
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseBlic_Awards))
                dust = CaseBlic_Awards[reward_index][4];
            else
                dust = 0;
        }
        case 11: // КЕЙС: ДЕЛО №5
        {
            if(reward_index >= 0 && reward_index < sizeof(CaseDelo5_Awards))
                dust = CaseDelo5_Awards[reward_index][4];
            else
                dust = 0;
        }
        default: dust = 0;
    }
    return dust;
}

stock GivePlayerDailyGift(playerid)
{
    new rand = random(3) +1; 
    
    if(rand == 1)
    {
        new dialog_str[256];
        format(dialog_str, sizeof(dialog_str), 
            "{FFFFFF}Поздравляем! Вы получили подарок:\n\n\
            {FFFFFF}Предмет: {FFCC00}Кейс Бомжа (1 шт.)\n\
            {CECECE}Для открытия нажмите на кнопку ''Кейсы'' в интерфейсе доната");
        
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{E0584B}PRIDE RUSSIA {FFFFFF}| Ежедневный подарок", dialog_str, "Закрыть", "");
        AddPlayerCaseCountByType(playerid, 2, 1);
        SavePlayerAccount(playerid);
        return 1; // Подарок выдан
    }
    else if(rand == 2)
    {
        new dialog_str[256];
        format(dialog_str, sizeof(dialog_str), 
            "{FFFFFF}Поздравляем! Вы получили подарок:\n\n\
            {FFFFFF}Предмет: {FFCC00}Ежедневный кейс (5 шт.)\n\
            {CECECE}Для открытия нажмите на кнопку ''Кейсы'' в интерфейсе доната");
        
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{E0584B}PRIDE RUSSIA {FFFFFF}| Ежедневный подарок", dialog_str, "Закрыть", "");
        AddPlayerCaseCountByType(playerid, 1, 5);
        SavePlayerAccount(playerid);
        return 1; 
    }
    else if(rand == 3)
    {
      new dialog_str[256];
        format(dialog_str, sizeof(dialog_str), 
            "{FFFFFF}Поздравляем! Вы получили подарок:\n\n\
            {FFFFFF}Предмет: {FF0000}Стандартный кейс (1 шт.)\n\
            {CECECE}Для открытия нажмите на кнопку ''Кейсы'' в интерфейсе доната");
        
        ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "{E0584B}PRIDE RUSSIA {FFFFFF}| Ежедневный подарок", dialog_str, "Закрыть", "");
        AddPlayerCaseCountByType(playerid, 4, 1);
        SavePlayerAccount(playerid);
        return 1; 
    }
}

CMD:givecases(playerid, params[])
{
   if(GetPlayerAdminEx(playerid) < 13) return 1;
   
    new targetid, type_case, count;
    if(sscanf(params, "udd", targetid, type_case, count))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [type_case:1-11] [count]");

    if(!IsPlayerConnected(targetid)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");
    if(type_case < 1 || type_case > 11) return SendClientMessage(playerid, COLOR_RED, "type_case должен быть от 1 до 11.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");

    AddPlayerCaseCountByType(targetid, type_case, count);
    SavePlayerAccount(targetid);

    format(str, sizeof(str), "Администратор выдал вам %d кейс(ов) типа %d.", count, type_case);
    SendClientMessage(targetid, COLOR_WHITE, str);
    return 1;
}