#if defined _CRAFT_SYSTEM_INCLUDED
    #endinput
#endif
#define _CRAFT_SYSTEM_INCLUDED

// Generated from scriptfiles/craft.json. Do not edit recipe rows manually.
#define CRAFT_RECIPE_COUNT          194
#define CRAFT_MAX_COMPONENTS        5
#define CRAFT_PERSONAL_COST_PERCENT 50
#define CRAFT_NATIVE_GUI            49
#define CRAFT_LEVEL_2_EXP           500
#define CRAFT_LEVEL_3_EXP           2500
#define CRAFT_LEVEL_4_EXP           12500
#define CRAFT_LEVEL_5_EXP           62500

enum E_CRAFT_RECIPE
{
    CR_INTERNAL_ID,
    CR_GAME_ID,
    CR_MODEL_ID,
    CR_CATEGORY,
    CR_CLASS_ID,
    CR_CHANCE_BP,
    CR_COST,
    CR_EXP,
    CR_TIME,
    CR_STACK,
    CR_VISIBLE,
    CR_COLOR_1,
    CR_COLOR_2,
    CR_COMP_COUNT,
    CR_NAME[64]
};

new const gCraftRecipe[CRAFT_RECIPE_COUNT][E_CRAFT_RECIPE] =
{
    {1,729,1997,2,1,6000,5000,100,600,1,1,0,0,4,"Балалайка"},
    {2,730,1991,2,1,6000,5000,100,600,1,1,0,0,4,"Боксерский шлем старшего брата"},
    {3,731,2001,2,1,6000,5000,100,600,1,1,0,0,3,"Деревянная корона"},
    {4,732,1984,2,1,6000,5000,100,600,1,1,0,0,4,"Деревянный шлем"},
    {5,733,1992,2,1,6000,5000,100,600,1,1,0,0,4,"Детский спасательный жилет"},
    {6,734,2005,2,1,6000,5000,100,600,1,1,0,0,4,"Камера от тракторного колеса"},
    {7,735,1986,2,1,6000,5000,100,600,1,1,0,0,4,"Кепка Таксист"},
    {8,736,2006,2,1,6000,5000,100,600,1,1,0,0,3,"Маска пакет"},
    {9,737,1982,2,1,6000,5000,100,600,1,1,0,0,4,"Правая боксерская перчатка"},
    {10,738,1998,2,1,6000,5000,100,600,1,1,0,0,4,"Рога оленя"},
    {11,739,1987,2,1,6000,5000,100,600,1,1,0,0,4,"Шапка ушанка"},
    {12,740,2003,2,2,4500,15000,500,900,1,1,0,0,5,"Банная шапка BLACK RUSSIA"},
    {13,741,1999,2,2,4500,15000,500,900,1,1,0,0,4,"Банный веник"},
    {14,742,1980,2,2,4500,15000,500,900,1,1,0,0,4,"Баян"},
    {15,644,644,4,2,4500,15000,500,900,1,1,62,8,5,"Анаконда"},
    {16,743,1995,2,2,4500,15000,500,900,1,1,0,0,3,"Военная пилотка"},
    {17,744,1996,2,2,4500,15000,500,900,1,1,0,0,5,"Деревянный автомат AK-47"},
    {18,745,1979,2,2,4500,15000,500,900,1,1,0,0,4,"Деревянный меч"},
    {19,6885,6885,3,2,4500,15000,500,900,1,1,0,0,5,"Егерь"},
    {20,746,1990,2,2,4500,15000,500,900,1,1,0,0,3,"Маска Ведро"},
    {21,747,1985,2,2,4500,15000,500,900,1,1,0,0,4,"Маска из мешковины"},
    {22,748,2007,2,2,4500,15000,500,900,1,1,0,0,4,"Маска кабана"},
    {23,749,1978,2,2,4500,15000,500,900,1,1,0,0,4,"Мягкая игрушка Голубь"},
    {24,750,1981,2,2,4500,15000,500,900,1,1,0,0,3,"Солдатская каска"},
    {25,751,1993,2,2,4500,15000,500,900,1,1,0,0,3,"Шляпа рыбака"},
    {26,6887,6887,3,3,3500,50000,2500,1500,1,1,0,0,5,"Местный Шериф"},
    {27,752,1983,2,3,3500,50000,2500,1500,1,1,0,0,5,"Кухонная сковорода"},
    {28,753,2002,2,3,3500,50000,2500,1500,1,1,0,0,5,"Маска Пугало огородное"},
    {29,754,2008,2,3,3500,50000,2500,1500,1,1,0,0,5,"Мексиканская гитара"},
    {30,646,646,4,3,3500,50000,2500,1500,1,1,0,13,5,"Бекас"},
    {31,647,647,4,4,2500,160000,12500,2400,1,1,95,13,5,"Медведь"},
    {32,6886,6886,3,4,2500,160000,12500,2400,1,1,0,0,5,"Щёголь"},
    {33,755,2000,2,4,2500,160000,12500,2400,1,1,0,0,5,"Мягкая игрушка Дух дома"},
    {34,756,1994,2,4,2500,160000,12500,2400,1,1,0,0,5,"Рюкзак Импортный"},
    {35,757,1988,2,5,2000,500000,62500,3600,1,1,0,0,5,"Шлем Череп"},
    {36,648,648,4,5,2000,500000,62500,3600,1,1,8,13,5,"Волколак"},
    {37,758,2004,2,5,2000,500000,62500,3600,1,1,0,0,5,"Маска Ленин"},
    {38,759,1989,2,5,2000,500000,62500,3600,1,1,0,0,5,"Маска Сталин"},
    {39,760,9960,1,1,7000,1000,10,120,99,1,0,0,2,"Краска"},
    {40,761,5283,1,1,7000,1000,10,120,99,1,0,0,3,"Алюминий"},
    {41,762,5286,1,1,7000,1000,10,120,99,1,0,0,2,"ВВ-40"},
    {42,763,9966,1,1,7000,1000,10,120,99,1,0,0,2,"Железо"},
    {43,764,5275,1,1,7000,1000,10,120,99,1,0,0,2,"Клей"},
    {44,765,5284,1,1,7000,1000,10,120,99,1,0,0,2,"Кожа"},
    {45,766,5287,1,1,7000,1000,10,120,99,1,0,0,2,"Крепеж"},
    {46,767,5291,1,1,7000,1000,10,120,99,1,0,0,2,"Нити"},
    {47,768,10001,1,1,7000,1000,10,120,99,1,0,0,2,"Пиломатериалы"},
    {48,769,5289,1,1,7000,1000,10,120,99,1,0,0,2,"Пластик"},
    {49,770,9972,1,1,7000,1000,10,120,99,1,0,0,2,"Резина"},
    {50,771,5826,1,2,5500,3000,50,180,99,1,0,0,4,"Блок управления"},
    {51,772,5828,1,2,5500,3000,50,180,99,1,0,0,4,"Ботинки"},
    {52,773,9999,1,2,5500,3000,50,180,99,1,0,0,4,"Двигатель Мотоцикла"},
    {53,774,5285,1,2,5500,3000,50,180,99,1,0,0,3,"Качественная кожа"},
    {54,775,9990,1,2,5500,3000,50,180,99,1,0,0,4,"Колесо Мотоцикла"},
    {55,776,9975,1,2,5500,3000,50,180,99,1,0,0,3,"Маскировочная сеть"},
    {56,777,9984,1,2,5500,3000,50,180,99,1,0,0,3,"Рама Внедорожный мотоцикл"},
    {57,778,5822,1,2,5500,3000,50,180,99,1,0,0,4,"Руль Мотоцикла"},
    {58,779,5283,1,2,5500,3000,50,180,99,1,0,0,3,"Сталь"},
    {59,780,2649,1,2,5500,3000,50,180,99,1,0,0,2,"Ткань"},
    {60,781,5280,1,2,5500,3000,50,180,99,1,0,0,3,"Шестерни"},
    {61,782,9994,1,3,4500,10000,250,300,99,1,0,0,5,"Двигатель Автомобиля"},
    {62,783,9998,1,3,4500,10000,250,300,99,1,0,0,4,"Колесо Автомобиля"},
    {63,784,9993,1,3,4500,10000,250,300,99,1,0,0,4,"Колесо Внедорожника"},
    {64,785,10002,1,3,4500,10000,250,300,99,1,0,0,4,"Руль Автомобиля"},
    {65,786,5828,1,3,4500,10000,250,300,99,1,0,0,4,"Туфли"},
    {66,787,5281,1,3,4500,10000,250,300,99,1,0,0,4,"Сварочный аппарат"},
    {67,788,5273,1,3,4500,10000,250,300,99,1,0,0,4,"Углепластик"},
    {68,789,9992,1,4,3500,32000,1250,450,99,1,0,0,4,"Колесо Спортивного Автомобиля"},
    {69,790,9969,1,4,3500,32000,1250,450,99,1,0,0,4,"Кузов Внедорожника"},
    {70,791,5830,1,4,3500,32000,1250,450,99,1,0,0,4,"Улучшенный блок управления"},
    {71,792,10000,1,5,3000,100000,6250,720,99,1,0,0,5,"Двигатель Спортивного Автомобиля"},
    {72,793,9964,1,5,3000,100000,6250,720,99,1,0,0,5,"Кузов Спортивного Автомобиля"},
    {73,794,9974,1,1,0,0,0,0,99,0,0,0,0,"Бокситы"},
    {74,795,9997,1,1,0,0,0,0,99,0,0,0,0,"Древесина"},
    {75,796,5274,1,1,0,0,0,0,99,0,0,0,0,"Железная руда"},
    {76,797,5270,1,1,0,0,0,0,99,0,0,0,0,"Металлолом"},
    {77,798,5272,1,1,0,0,0,0,99,0,0,0,0,"Обрезки резины"},
    {78,799,5292,1,1,0,0,0,0,99,0,0,0,0,"Пластиковая бутылка"},
    {79,800,5278,1,1,0,0,0,0,99,0,0,0,0,"Радиодетали"},
    {80,801,5288,1,1,0,0,0,0,99,0,0,0,0,"Реагенты"},
    {81,802,5271,1,1,0,0,0,0,99,0,0,0,0,"Текстильное волокно"},
    {82,803,9980,1,1,0,0,0,0,99,0,0,0,0,"Шкура животного"},
    {83,804,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Алюминий"},
    {84,805,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Балалайка"},
    {85,806,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Боксерский шлем старшего брата"},
    {86,807,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция ВВ-40"},
    {87,808,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Деревянная корона"},
    {88,809,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Деревянный шлем"},
    {89,810,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Детский спасательный жилет"},
    {90,811,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Железо"},
    {91,812,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Камера от тракторного колеса"},
    {92,813,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Кепка Таксист"},
    {93,814,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Клей"},
    {94,815,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Кожа"},
    {95,816,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Краска"},
    {96,817,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Крепеж"},
    {97,818,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Маска пакет"},
    {98,819,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Нити"},
    {99,820,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Пиломатериалы"},
    {100,821,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Пластик"},
    {101,822,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Правая боксерская перчатка"},
    {102,823,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Резина"},
    {103,824,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Рога оленя"},
    {104,825,9973,1,1,0,0,0,0,99,0,0,0,0,"Инструкция Шапка ушанка"},
    {105,826,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Банная шапка BLACK RUSSIA"},
    {106,827,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Банный веник"},
    {107,828,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Баян"},
    {108,829,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Блок управления"},
    {109,830,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Ботинки"},
    {110,831,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Анаконда"},
    {111,832,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Военная пилотка"},
    {112,833,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Двигатель Мотоцикла"},
    {113,834,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Деревянный автомат AK-47"},
    {114,835,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Деревянный меч"},
    {115,836,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Качественная кожа"},
    {116,837,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Колесо Мотоцикла"},
    {117,838,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Образ Егерь"},
    {118,839,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Маска"},
    {119,840,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Маска Ведро"},
    {120,841,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Маска из мешковины"},
    {121,842,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Маска кабана"},
    {122,843,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Маскировочная сеть"},
    {123,844,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Мягкая игрушка Голубь"},
    {124,845,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Рама Внедорожного мотоцикла"},
    {125,846,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Руль Мотоцикла"},
    {126,847,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Солдатская каска"},
    {127,848,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Сталь"},
    {128,849,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Ткань"},
    {129,850,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Шестерни"},
    {130,851,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Шляпа рыбака"},
    {131,852,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Двигатель Автомобиля"},
    {132,853,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Колесо Автомобиля"},
    {133,854,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Колесо Внедорожникаа"},
    {134,855,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Образ Местный Шериф"},
    {135,856,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Кухонная сковорода"},
    {136,857,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Маска Пугало огородное"},
    {137,858,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Мексиканская гитара"},
    {138,859,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Руль Автомобиля"},
    {139,860,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Бекас"},
    {140,861,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Туфли"},
    {141,862,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Сварочный аппарат"},
    {142,863,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Углепластик"},
    {143,864,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Медведь"},
    {144,865,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Колесо Спортивного автомобиля"},
    {145,866,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Образ Щёголь"},
    {146,867,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Кузов Внедорожникаа"},
    {147,868,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Мягкая игрушка Дух дома"},
    {148,869,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Улучшенный блок управления"},
    {149,870,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Рюкзак Импортный"},
    {150,871,9973,1,5,0,0,0,0,99,0,0,0,0,"Инструкция Шлем Череп"},
    {151,872,9973,1,5,0,0,0,0,99,0,0,0,0,"Инструкция Двигатель Спортивного автомобиля"},
    {152,873,9973,1,5,0,0,0,0,99,0,0,0,0,"Инструкция Кузов Спортивного автомобиля"},
    {153,874,9973,1,5,0,0,0,0,99,0,0,0,0,"Инструкция Маска Ленин"},
    {154,875,9973,1,5,0,0,0,0,99,0,0,0,0,"Инструкция Маска Сталин"},
    {155,876,9973,1,5,0,0,0,0,99,0,0,0,0,"Инструкция Волколак"},
    {156,893,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Двигатель Моторной лодки"},
    {157,894,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Корпус Деревянной лодки"},
    {158,895,9973,1,2,0,0,0,0,99,0,0,0,0,"Инструкция Лахтак"},
    {159,896,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Водостойкая ткань"},
    {160,897,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Рама Багги"},
    {161,898,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Рама Мотоцикла"},
    {162,899,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Кузов Автомобиля"},
    {163,900,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Корпус Металлической лодки"},
    {164,901,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Каракал"},
    {165,902,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Крайт"},
    {166,903,9973,1,3,0,0,0,0,99,0,0,0,0,"Инструкция Ларга"},
    {167,904,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Акиба"},
    {168,905,12302,1,2,5500,3000,50,180,99,1,0,0,4,"Двигатель Моторной лодки"},
    {169,906,12308,1,2,5500,3000,50,180,99,1,0,0,5,"Корпус Деревянной лодки"},
    {170,907,12304,1,3,4500,10000,250,300,99,1,0,0,4,"Водостойкая ткань"},
    {171,908,12306,1,3,4500,10000,250,300,99,1,0,0,4,"Рама Багги"},
    {172,909,12303,1,3,4500,10000,250,300,99,1,0,0,4,"Рама Мотоцикла"},
    {173,910,12301,1,3,4500,10000,250,300,99,1,0,0,5,"Кузов Автомобиля"},
    {174,911,12307,1,4,3500,32000,1250,450,99,1,0,0,5,"Корпус Металлической лодки"},
    {175,653,653,4,2,4500,15000,500,900,1,1,0,0,5,"Лахтак"},
    {176,649,649,4,3,3500,50000,2500,1500,1,1,3,13,5,"Каракал"},
    {177,652,652,4,3,3500,50000,2500,1500,1,1,20,13,5,"Крайт"},
    {178,651,651,4,3,3500,50000,2500,1500,1,1,0,0,5,"Ларга"},
    {179,655,655,4,4,2500,160000,12500,2400,1,1,28,28,5,"Акиба"},
    {180,650,650,4,4,2500,160000,12500,2400,1,1,1,13,5,"Койот"},
    {181,654,654,4,4,2500,160000,12500,2400,1,1,37,36,5,"Слейпнир"},
    {182,1011,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Койот"},
    {183,1012,9973,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Слейпнир"},
    {184,116,100001,2,1,7000,1000,15,120,3,1,0,0,2,"Маска"},
    {185,6864,6864,3,2,9000,160000,12500,2400,1,1,0,0,3,"Хиш-Миш"},
    {186,1028,100070,2,2,9000,160000,12500,2400,1,1,0,0,3,"Страх детства"},
    {187,1036,6864,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Хиш-Миш "},
    {188,1037,100070,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Страх детства"},
    {189,1038,25,1,4,0,0,0,0,99,0,0,0,0,"Осколки Тьмы"},
    {190,5500069,5500069,3,2,9000,160000,5000,2400,1,1,0,0,3,"Полярник Клаус"},
    {191,1052,100107,2,2,9000,160000,5000,2400,1,1,0,0,3,"Конек Защитника"},
    {192,1059,5500069,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Полярник Клаус"},
    {193,1060,100107,1,4,0,0,0,0,99,0,0,0,0,"Инструкция Конек Защитника"},
    {194,1061,25,1,4,0,0,0,0,99,0,0,0,0,"Праздничная энергия"}
};

new const gCraftCompId[CRAFT_RECIPE_COUNT][CRAFT_MAX_COMPONENTS] =
{
    {84,47,45,40,0},
    {85,44,48,46,0},
    {87,47,43,0,0},
    {88,47,42,45,0},
    {89,49,43,39,0},
    {91,49,43,41,0},
    {92,44,46,43,0},
    {97,74,43,0,0},
    {101,44,43,46,0},
    {103,47,43,45,0},
    {104,44,46,43,0},
    {105,53,46,39,43},
    {106,74,59,46,0},
    {107,48,58,39,0},
    {110,56,52,54,57},
    {111,59,46,0,0},
    {113,47,58,45,43},
    {114,47,53,43,0},
    {117,44,59,55,51},
    {119,58,45,0,0},
    {120,59,46,43,0},
    {121,46,82,59,0},
    {123,59,81,46,0},
    {126,58,59,0,0},
    {130,59,46,0,0},
    {134,53,59,39,65},
    {135,42,66,45,39},
    {136,59,46,43,53},
    {137,47,45,39,43},
    {139,173,61,62,64},
    {143,69,61,63,64},
    {145,53,59,39,65},
    {147,59,46,43,81},
    {149,53,49,39,43},
    {150,58,66,45,39},
    {155,72,71,68,64},
    {153,53,43,46,49},
    {154,53,43,46,49},
    {95,80,0,0,0},
    {83,73,80,0,0},
    {86,80,0,0,0},
    {90,75,0,0,0},
    {93,80,0,0,0},
    {94,82,0,0,0},
    {96,76,0,0,0},
    {98,81,0,0,0},
    {99,74,0,0,0},
    {100,78,0,0,0},
    {102,77,0,0,0},
    {108,79,40,48,0},
    {109,44,43,46,0},
    {112,42,45,41,0},
    {115,44,39,0,0},
    {116,42,49,45,0},
    {122,46,81,0,0},
    {124,42,45,0,0},
    {125,40,45,48,0},
    {127,42,73,0,0},
    {128,46,0,0,0},
    {129,42,40,0,0},
    {131,60,45,50,41},
    {132,58,49,45,0},
    {133,58,49,45,0},
    {138,58,45,48,0},
    {140,53,43,46,0},
    {141,58,50,45,0},
    {142,48,59,80,0},
    {144,67,49,45,0},
    {146,58,45,66,0},
    {148,50,79,67,0},
    {151,60,45,70,41},
    {152,67,58,45,66},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {156,40,45,41,0},
    {157,47,45,43,39},
    {159,59,49,43,0},
    {160,58,45,39,0},
    {161,58,45,39,0},
    {162,58,40,45,39},
    {163,58,40,45,66},
    {158,169,168,58,45},
    {164,171,61,63,64},
    {165,172,52,54,57},
    {166,170,67,43,168},
    {167,174,168,66,64},
    {182,173,61,62,64},
    {183,69,61,63,173},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {118,81,0,0,0},
    {187,53,189,0,0},
    {188,44,189,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {192,44,194,0,0},
    {193,42,194,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0}
};

new const gCraftCompQty[CRAFT_RECIPE_COUNT][CRAFT_MAX_COMPONENTS] =
{
    {1,3,2,1,0},
    {1,2,2,2,0},
    {1,3,3,0,0},
    {1,4,1,1,0},
    {1,3,2,1,0},
    {1,4,2,1,0},
    {1,3,2,2,0},
    {1,5,3,0,0},
    {1,3,1,3,0},
    {1,5,2,1,0},
    {1,4,2,2,0},
    {1,2,4,2,2},
    {1,10,2,4,0},
    {1,4,2,2,0},
    {1,1,1,2,1},
    {1,4,3,0,0},
    {1,5,3,3,2},
    {1,5,4,3,0},
    {1,5,5,2,1},
    {1,5,2,0,0},
    {1,6,4,2,0},
    {1,5,10,5,0},
    {1,5,10,4,0},
    {1,5,1,0,0},
    {1,5,4,0,0},
    {1,10,5,2,1},
    {1,5,1,2,1},
    {1,10,6,3,4},
    {1,15,3,2,5},
    {1,1,1,4,1},
    {1,1,1,4,1},
    {1,15,10,5,1},
    {1,15,10,4,40},
    {1,10,6,3,5},
    {1,10,1,3,2},
    {1,1,1,4,1},
    {1,5,10,5,4},
    {1,5,10,5,5},
    {1,11,0,0,0},
    {1,7,5,0,0},
    {1,10,0,0,0},
    {1,9,0,0,0},
    {1,12,0,0,0},
    {1,10,0,0,0},
    {1,12,0,0,0},
    {1,8,0,0,0},
    {1,12,0,0,0},
    {1,11,0,0,0},
    {1,10,0,0,0},
    {1,15,3,5,0},
    {1,4,2,4,0},
    {1,4,3,3,0},
    {1,6,3,0,0},
    {1,2,3,3,0},
    {1,8,20,0,0},
    {1,6,8,0,0},
    {1,4,2,3,0},
    {1,6,6,0,0},
    {1,6,0,0,0},
    {1,4,3,0,0},
    {1,5,5,2,6},
    {1,5,5,5,0},
    {1,5,7,5,0},
    {1,5,2,2,0},
    {1,5,4,4,0},
    {1,5,1,5,0},
    {1,4,2,7,0},
    {1,1,7,4,0},
    {1,5,7,1,0},
    {1,3,35,1,0},
    {1,5,6,1,9},
    {1,2,3,6,1},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {1,6,3,3,0},
    {1,10,10,10,4},
    {1,2,5,10,0},
    {1,7,5,8,0},
    {1,5,5,4,0},
    {1,7,10,10,10},
    {1,5,10,10,1},
    {1,1,1,2,5},
    {1,1,1,4,1},
    {1,1,1,2,1},
    {1,10,2,20,1},
    {1,1,2,2,1},
    {1,1,1,4,1},
    {1,1,1,8,1},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {1,2,0,0,0},
    {1,2,50,0,0},
    {1,2,20,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {1,2,40,0,0},
    {1,2,20,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0},
    {0,0,0,0,0}
};

new bool:gCraftTablesReady;

stock Craft_EnsureTables()
{
    if(gCraftTablesReady) return 1;

    new Cache:ddl = mysql_query(mysql, "CREATE TABLE IF NOT EXISTS craft_jobs (account_id INT NOT NULL PRIMARY KEY, recipe_index SMALLINT NOT NULL, finish_time INT NOT NULL, success TINYINT NOT NULL, created_at INT NOT NULL)", true);
    if(mysql_errno())
    {
        cache_delete(ddl);
        return 0;
    }
    cache_delete(ddl);

    ddl = mysql_query(mysql, "CREATE TABLE IF NOT EXISTS craft_profiles (account_id INT NOT NULL PRIMARY KEY, level TINYINT NOT NULL DEFAULT 1, exp INT NOT NULL DEFAULT 0)", true);
    if(mysql_errno())
    {
        cache_delete(ddl);
        return 0;
    }
    cache_delete(ddl);

    new Cache:column_check = mysql_query(mysql, "SHOW COLUMNS FROM craft_profiles LIKE 'level'", true);
    if(mysql_errno())
    {
        cache_delete(column_check);
        return 0;
    }
    if(cache_num_rows() == 0)
    {
        cache_delete(column_check);
        ddl = mysql_query(mysql, "ALTER TABLE craft_profiles ADD COLUMN level TINYINT NOT NULL DEFAULT 1 AFTER account_id", true);
        if(mysql_errno())
        {
            cache_delete(ddl);
            return 0;
        }
        cache_delete(ddl);
    }
    else cache_delete(column_check);

    ddl = mysql_query(mysql, "UPDATE craft_profiles SET level=1 WHERE level < 1", true);
    if(mysql_errno())
    {
        cache_delete(ddl);
        return 0;
    }
    cache_delete(ddl);

    gCraftTablesReady = true;
    return 1;
}

stock Craft_CategoryName(category, dest[], size)
{
    switch(category)
    {
        case 1: format(dest, size, "Материалы и детали");
        case 2: format(dest, size, "Аксессуары");
        case 3: format(dest, size, "Одежда и скины");
        case 4: format(dest, size, "Транспорт");
        default: format(dest, size, "Неизвестно");
    }
    return 1;
}

stock Craft_FormatTime(seconds, dest[], size)
{
    if(seconds < 0) seconds = 0;
    new hours = seconds / 3600;
    new minutes = (seconds % 3600) / 60;
    new secs = seconds % 60;
    if(hours > 0) format(dest, size, "%d ч. %d мин.", hours, minutes);
    else if(minutes > 0) format(dest, size, "%d мин. %d сек.", minutes, secs);
    else format(dest, size, "%d сек.", secs);
    return 1;
}

stock Craft_GetCost(recipe)
{
    if(recipe < 0 || recipe >= CRAFT_RECIPE_COUNT) return 0;
    return (gCraftRecipe[recipe][CR_COST] * CRAFT_PERSONAL_COST_PERCENT) / 100;
}

stock Craft_GetItemIndex(internal_id)
{
    if(internal_id < 1 || internal_id > CRAFT_RECIPE_COUNT) return -1;
    return internal_id - 1;
}

stock Craft_FindRecipeIndex(value)
{
    new by_internal = Craft_GetItemIndex(value);
    if(by_internal >= 0 && by_internal < CRAFT_RECIPE_COUNT && gCraftRecipe[by_internal][CR_VISIBLE])
        return by_internal;

    // Compatibility fallback for client builds that send game_id instead of internal_id.
    for(new i = 0; i < CRAFT_RECIPE_COUNT; i++)
    {
        if(gCraftRecipe[i][CR_VISIBLE] && gCraftRecipe[i][CR_GAME_ID] == value) return i;
    }
    return -1;
}

stock Craft_LevelForExp(exp)
{
    if(exp >= CRAFT_LEVEL_5_EXP) return 5;
    if(exp >= CRAFT_LEVEL_4_EXP) return 4;
    if(exp >= CRAFT_LEVEL_3_EXP) return 3;
    if(exp >= CRAFT_LEVEL_2_EXP) return 2;
    return 1;
}

stock Craft_GetAccModel(item_id)
{
    for(new i = 0; i < CRAFT_RECIPE_COUNT; i++)
    {
        if(gCraftRecipe[i][CR_CATEGORY] == 2 && gCraftRecipe[i][CR_GAME_ID] == item_id)
            return gCraftRecipe[i][CR_MODEL_ID];
    }
    return -1;
}

stock Craft_CountRecipeItem(playerid, recipe_index)
{
    if(recipe_index < 0 || recipe_index >= CRAFT_RECIPE_COUNT) return 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new game_id = gCraftRecipe[recipe_index][CR_GAME_ID];
    new internal_id = gCraftRecipe[recipe_index][CR_INTERNAL_ID];
    new query[320];
    mysql_format(mysql, query, sizeof(query),
        "SELECT IFNULL(SUM(amount),0) AS total FROM inventory WHERE account_id=%d AND (item_id=%d OR source_internal_id=%d OR item_id=%d)",
        account_id, game_id, internal_id, internal_id);

    new Cache:result = mysql_query(mysql, query, true);
    new total = 0;
    if(!mysql_errno() && cache_num_rows() > 0)
        total = cache_get_field_content_int(0, "total");
    cache_delete(result);

    if(total < 0) total = 0;
    return total;
}

stock bool:Craft_RemoveRecipeItem(playerid, recipe_index, amount)
{
    if(amount <= 0) return true;
    if(recipe_index < 0 || recipe_index >= CRAFT_RECIPE_COUNT) return false;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return false;

    new game_id = gCraftRecipe[recipe_index][CR_GAME_ID];
    new internal_id = gCraftRecipe[recipe_index][CR_INTERNAL_ID];
    new query[384];
    new slots[INVENTORY11_MAX_SLOTS], amounts[INVENTORY11_MAX_SLOTS];

    mysql_format(mysql, query, sizeof(query),
        "SELECT slot,amount FROM inventory WHERE account_id=%d AND (item_id=%d OR source_internal_id=%d OR item_id=%d) ORDER BY slot ASC",
        account_id, game_id, internal_id, internal_id);
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        cache_delete(result);
        return false;
    }

    new rows = cache_num_rows();
    if(rows > INVENTORY11_MAX_SLOTS) rows = INVENTORY11_MAX_SLOTS;
    new total = 0;
    for(new i = 0; i < rows; i++)
    {
        slots[i] = cache_get_field_content_int(i, "slot");
        amounts[i] = cache_get_field_content_int(i, "amount");
        if(amounts[i] <= 0) amounts[i] = 1;
        total += amounts[i];
    }
    cache_delete(result);
    if(total < amount) return false;

    new left = amount;
    new removed = 0;
    for(new i = 0; i < rows && left > 0; i++)
    {
        new take = amounts[i];
        if(take > left) take = left;

        if(take >= amounts[i])
            mysql_format(mysql, query, sizeof(query),
                "DELETE FROM inventory WHERE account_id=%d AND slot=%d LIMIT 1",
                account_id, slots[i]);
        else
            mysql_format(mysql, query, sizeof(query),
                "UPDATE inventory SET amount=amount-%d WHERE account_id=%d AND slot=%d LIMIT 1",
                take, account_id, slots[i]);

        new Cache:write_result = mysql_query(mysql, query, true);
        new write_errno = mysql_errno();
        cache_delete(write_result);
        if(write_errno)
        {
            if(removed > 0) Craft_AddRecipeItem(playerid, recipe_index, removed);
            return false;
        }
        left -= take;
        removed += take;
    }

    if(left != 0)
    {
        if(removed > 0) Craft_AddRecipeItem(playerid, recipe_index, removed);
        return false;
    }
    return true;
}

stock Craft_GetJob(playerid, &recipe, &finish_time, &success)
{
    Craft_EnsureTables();
    recipe = -1; finish_time = 0; success = 0;
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;
    new query[160];
    mysql_format(mysql, query, sizeof(query), "SELECT recipe_index,finish_time,success FROM craft_jobs WHERE account_id=%d LIMIT 1", account_id);
    new Cache:result = mysql_query(mysql, query, true);
    if(!mysql_errno() && cache_num_rows() > 0)
    {
        recipe = cache_get_field_content_int(0, "recipe_index");
        finish_time = cache_get_field_content_int(0, "finish_time");
        success = cache_get_field_content_int(0, "success");
        cache_delete(result);
        return 1;
    }
    cache_delete(result);
    return 0;
}

stock Craft_DeleteJob(playerid)
{
    new query[128];
    mysql_format(mysql, query, sizeof(query), "DELETE FROM craft_jobs WHERE account_id=%d LIMIT 1", GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);
    new bool:ok = (mysql_errno() == 0 && cache_affected_rows() == 1);
    cache_delete(result);
    return ok;
}

stock Craft_RestoreJob(playerid, recipe, finish_time, success)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0 || recipe < 0 || recipe >= CRAFT_RECIPE_COUNT) return 0;

    new query[320];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO craft_jobs (account_id,recipe_index,finish_time,success,created_at) VALUES (%d,%d,%d,%d,%d) ON DUPLICATE KEY UPDATE recipe_index=VALUES(recipe_index),finish_time=VALUES(finish_time),success=VALUES(success)",
        account_id, recipe, finish_time, success, gettime());
    new Cache:result = mysql_query(mysql, query, true);
    new bool:ok = (mysql_errno() == 0);
    cache_delete(result);
    return ok;
}

stock Craft_EnsureProfile(playerid)
{
    if(!Craft_EnsureTables()) return 0;
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new query[192];
    mysql_format(mysql, query, sizeof(query),
        "INSERT IGNORE INTO craft_profiles (account_id,level,exp) VALUES (%d,1,0)", account_id);
    new Cache:result = mysql_query(mysql, query, true);
    new bool:ok = (mysql_errno() == 0);
    cache_delete(result);
    return ok;
}

stock Craft_GetLevel(playerid)
{
    if(!Craft_EnsureProfile(playerid)) return 1;

    new query[192];
    mysql_format(mysql, query, sizeof(query),
        "SELECT level,exp FROM craft_profiles WHERE account_id=%d LIMIT 1", GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);
    new level = 1, exp = 0;
    if(!mysql_errno() && cache_num_rows() > 0)
    {
        level = cache_get_field_content_int(0, "level");
        exp = cache_get_field_content_int(0, "exp");
    }
    cache_delete(result);

    new resolved_level = Craft_LevelForExp(exp);
    if(level != resolved_level)
    {
        mysql_format(mysql, query, sizeof(query),
            "UPDATE craft_profiles SET level=%d WHERE account_id=%d", resolved_level, GetPlayerAccountID(playerid));
        result = mysql_query(mysql, query, true);
        cache_delete(result);
    }
    return resolved_level;
}

stock Craft_AddExp(playerid, amount)
{
    if(amount <= 0) return 1;
    if(!Craft_EnsureProfile(playerid)) return 0;

    new query[320];
    mysql_format(mysql, query, sizeof(query),
        "UPDATE craft_profiles SET exp=exp+%d WHERE account_id=%d", amount, GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        cache_delete(result);
        return 0;
    }
    cache_delete(result);

    mysql_format(mysql, query, sizeof(query),
        "UPDATE craft_profiles SET level=CASE WHEN exp>=%d THEN 5 WHEN exp>=%d THEN 4 WHEN exp>=%d THEN 3 WHEN exp>=%d THEN 2 ELSE 1 END WHERE account_id=%d",
        CRAFT_LEVEL_5_EXP, CRAFT_LEVEL_4_EXP, CRAFT_LEVEL_3_EXP, CRAFT_LEVEL_2_EXP, GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);
    new bool:ok = (mysql_errno() == 0);
    cache_delete(result);
    return ok;
}

stock Craft_GetExp(playerid)
{
    Craft_EnsureProfile(playerid);
    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT exp FROM craft_profiles WHERE account_id=%d LIMIT 1", GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, query, true);
    new value = 0;
    if(!mysql_errno() && cache_num_rows() > 0) value = cache_get_field_content_int(0, "exp");
    cache_delete(result);
    return value;
}

stock bool:Craft_IsComponentIndex(recipe_index)
{
    if(recipe_index < 0 || recipe_index >= CRAFT_RECIPE_COUNT) return false;
    new internal_id = gCraftRecipe[recipe_index][CR_INTERNAL_ID];
    for(new recipe = 0; recipe < CRAFT_RECIPE_COUNT; recipe++)
    {
        for(new c = 0; c < gCraftRecipe[recipe][CR_COMP_COUNT]; c++)
        {
            if(gCraftCompId[recipe][c] == internal_id) return true;
        }
    }
    return false;
}

stock Craft_FindComponentIndex(value)
{
    if(value >= 1 && value <= CRAFT_RECIPE_COUNT)
    {
        new by_internal = Craft_GetItemIndex(value);
        if(Craft_IsComponentIndex(by_internal)) return by_internal;
    }

    for(new i = 0; i < CRAFT_RECIPE_COUNT; i++)
    {
        if(gCraftRecipe[i][CR_GAME_ID] == value && Craft_IsComponentIndex(i)) return i;
    }
    return -1;
}

stock Craft_AddRecipeItem(playerid, recipe_index, amount)
{
    if(recipe_index < 0 || recipe_index >= CRAFT_RECIPE_COUNT || amount <= 0) return 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new item_id = gCraftRecipe[recipe_index][CR_GAME_ID];
    new model_id = gCraftRecipe[recipe_index][CR_MODEL_ID];
    new internal_id = gCraftRecipe[recipe_index][CR_INTERNAL_ID];
    new max_stack = gCraftRecipe[recipe_index][CR_STACK];
    if(max_stack < 1) max_stack = 99;
    if(max_stack > 9999) max_stack = 9999;

    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "SELECT slot,amount FROM inventory WHERE account_id=%d AND item_id=%d ORDER BY slot ASC",
        account_id, item_id);
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows();
    new slots[INVENTORY11_MAX_SLOTS];
    new amounts[INVENTORY11_MAX_SLOTS];
    if(rows > INVENTORY11_MAX_SLOTS) rows = INVENTORY11_MAX_SLOTS;
    for(new i = 0; i < rows; i++)
    {
        slots[i] = cache_get_field_content_int(i, "slot");
        amounts[i] = cache_get_field_content_int(i, "amount");
        if(amounts[i] < 0) amounts[i] = 0;
    }
    cache_delete(result);

    new left = amount;
    new added = 0;
    for(new i = 0; i < rows && left > 0; i++)
    {
        if(amounts[i] >= max_stack) continue;
        new add = max_stack - amounts[i];
        if(add > left) add = left;
        mysql_format(mysql, query, sizeof(query),
            "UPDATE inventory SET amount=amount+%d,model_id=%d,source_internal_id=%d WHERE account_id=%d AND slot=%d AND item_id=%d LIMIT 1",
            add, model_id, internal_id, account_id, slots[i], item_id);
        new Cache:update_result = mysql_query(mysql, query, true);
        new update_errno = mysql_errno();
        cache_delete(update_result);
        if(update_errno) break;
        left -= add;
        added += add;
    }

    while(left > 0)
    {
        new chunk = left;
        if(chunk > max_stack) chunk = max_stack;
        new inv_slot = Inventory11_AddItemToDatabase(playerid, item_id, model_id, chunk, internal_id, 0);
        if(inv_slot == -1) break;
        mysql_format(mysql, query, sizeof(query),
            "UPDATE inventory SET source_internal_id=%d WHERE account_id=%d AND slot=%d LIMIT 1",
            internal_id, account_id, inv_slot);
        new Cache:source_result = mysql_query(mysql, query, true);
        new source_errno = mysql_errno();
        cache_delete(source_result);
        if(source_errno) break;
        left -= chunk;
        added += chunk;
    }

    return added;
}

stock Craft_GrantOutput(playerid, recipe)
{
    if(recipe < 0 || recipe >= CRAFT_RECIPE_COUNT) return 0;
    new category = gCraftRecipe[recipe][CR_CATEGORY];
    new game_id = gCraftRecipe[recipe][CR_GAME_ID];
    new model_id = gCraftRecipe[recipe][CR_MODEL_ID];
    switch(category)
    {
        case 1: return (Craft_AddRecipeItem(playerid, recipe, 1) == 1);
        case 2: return (Inventory11_AddItemToDatabase(playerid, game_id, model_id, 1, model_id, 0) != -1);
        case 3: return Inventory11_AddSkinToInventory(playerid, game_id, gCraftRecipe[recipe][CR_INTERNAL_ID]);
        case 4:
        {
            if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid)) return 0;
            SetPVarInt(playerid, "BUY_CAR_COLOR", gCraftRecipe[recipe][CR_COLOR_2]);
            return (BuyPlayerCar(playerid, gCraftRecipe[recipe][CR_INTERNAL_ID], game_id, gCraftRecipe[recipe][CR_COLOR_1]) != -1);
        }
    }
    return 0;
}

stock Craft_LoadCounts(playerid, counts[CRAFT_RECIPE_COUNT])
{
    for(new i = 0; i < CRAFT_RECIPE_COUNT; i++) counts[i] = 0;

    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0) return 0;

    new query[224];
    mysql_format(mysql, query, sizeof(query),
        "SELECT item_id,source_internal_id,amount FROM inventory WHERE account_id=%d",
        account_id);
    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
        cache_delete(result);
        return 0;
    }

    new rows = cache_num_rows();
    for(new row = 0; row < rows; row++)
    {
        new item_id = cache_get_field_content_int(row, "item_id");
        new source_internal_id = cache_get_field_content_int(row, "source_internal_id");
        new amount = cache_get_field_content_int(row, "amount");
        if(amount <= 0) amount = 1;

        for(new i = 0; i < CRAFT_RECIPE_COUNT; i++)
        {
            new recipe_game_id = gCraftRecipe[i][CR_GAME_ID];
            new recipe_internal_id = gCraftRecipe[i][CR_INTERNAL_ID];
            if(item_id == recipe_game_id ||
               source_internal_id == recipe_internal_id ||
               item_id == recipe_internal_id)
            {
                counts[i] += amount;
                break;
            }
        }
    }
    cache_delete(result);
    return 1;
}

stock Craft_AddCompArray(playerid, Node:root)
{
    // JSON_Append returns a new node and invalidates both input nodes. Always assign its result.
    new counts[CRAFT_RECIPE_COUNT];
    Craft_LoadCounts(playerid, counts);

    new nonzero_components = 0;
    for(new dbg_i = 0; dbg_i < CRAFT_RECIPE_COUNT; dbg_i++)
    {
        if(counts[dbg_i] > 0 && Craft_IsComponentIndex(dbg_i)) nonzero_components++;
    }
    printf("[CRAFT][SYNC] player=%d nonzero_components=%d id_mode=internal_id quantity_key=cc", playerid, nonzero_components);

    new Node:items = JSON_Array();
    for(new i = 0; i < CRAFT_RECIPE_COUNT; i++)
    {
        new Node:item = JSON_Object();
        // APK protocol: CraftComponentServerItem.id matches CraftJsonItem.internal_id.
        // Quantity is serialized by the client model under the short key "cc".
        JSON_SetInt(item, "id", gCraftRecipe[i][CR_INTERNAL_ID]);
        JSON_SetInt(item, "cc", counts[i]);
        items = JSON_Append(items, item);

        if(counts[i] > 0 && Craft_IsComponentIndex(i))
        {
            printf("[CRAFT][ITEM] player=%d internal_id=%d game_id=%d count=%d", playerid,
                gCraftRecipe[i][CR_INTERNAL_ID], gCraftRecipe[i][CR_GAME_ID], counts[i]);
        }
    }
    JSON_SetArray(root, "ci", items);
    return 1;
}

stock Craft_AddJobArrays(playerid, Node:root, bool:mark_new = false)
{
    new Node:production = JSON_Array();
    new Node:storage = JSON_Array();
    new recipe, finish_time, success;
    new queue_count = 0;
    new storage_count = 0;

    if(Craft_GetJob(playerid, recipe, finish_time, success))
    {
        if(recipe < 0 || recipe >= CRAFT_RECIPE_COUNT)
        {
            Craft_DeleteJob(playerid);
        }
        else if(finish_time > gettime())
        {
            new Node:item = JSON_Object();
            JSON_SetInt(item, "id", gCraftRecipe[recipe][CR_INTERNAL_ID]);
            JSON_SetInt(item, "serverId", GetPlayerAccountID(playerid));
            JSON_SetInt(item, "timeUntilItemPreparation", finish_time - gettime());
            JSON_SetInt(item, "isSomeoneElseProduction", 0);
            production = JSON_Append(production, item);
            queue_count = 1;
        }
        else if(success)
        {
            new Node:item = JSON_Object();
            JSON_SetInt(item, "id", gCraftRecipe[recipe][CR_INTERNAL_ID]);
            JSON_SetInt(item, "serverId", GetPlayerAccountID(playerid));
            JSON_SetInt(item, "timeUntilItemDestruction", 604800);
            JSON_SetInt(item, "isItemNew", mark_new ? 1 : 0);
            storage = JSON_Append(storage, item);
            storage_count = 1;
        }
        else
        {
            Craft_AddExp(playerid, gCraftRecipe[recipe][CR_EXP]);
            Craft_DeleteJob(playerid);
            SendClientMessage(playerid, 0xE0584BFF, "Крафт не удался. Компоненты были потрачены.");
        }
    }

    JSON_SetInt(root, "pc", queue_count);
    JSON_SetInt(root, "mpc", 1);
    JSON_SetInt(root, "ps", storage_count);
    JSON_SetInt(root, "mps", 1);
    JSON_SetInt(root, "pns", (storage_count && mark_new) ? 1 : 0);
    JSON_SetArray(root, "cp", production);
    JSON_SetArray(root, "cs", storage);

    new Node:new_items = JSON_Array();
    JSON_SetArray(root, "cn", new_items);
    return 1;
}

stock Craft_FillGuiState(playerid, Node:root, bool:mark_new = false)
{
    new craft_level = Craft_GetLevel(playerid);
    JSON_SetInt(root, "lm", craft_level);
    JSON_SetInt(root, "pm", Craft_GetExp(playerid));
    JSON_SetInt(root, "wb", craft_level);
    JSON_SetInt(root, "vm", GetPlayerMoneyEx(playerid));
    JSON_SetInt(root, "h", 1);
    JSON_SetInt(root, "vp", GetPlayerPremium(playerid) > 0 ? 1 : 0);
    JSON_SetInt(root, "i", 0);
    Craft_AddCompArray(playerid, root);
    Craft_AddJobArrays(playerid, root, mark_new);
    return 1;
}

stock Craft_OpenGui(playerid)
{
    if(!IsPlayerLogged(playerid))
    {
        SendClientMessage(playerid, 0xE0584BFF, "Сначала авторизуйтесь на сервере.");
        return 0;
    }

    Craft_EnsureTables();

    // Reset a stale client-side screen state left by an interrupted/failed opening.
    // "not":1 forces GUIManager to clear isOpenScreen even when the Fragment is absent.
    new Node:reset_packet = JSON_Object();
    JSON_SetInt(reset_packet, "c", 1);
    JSON_SetInt(reset_packet, "not", 1);
    OnPacketIncoming(playerid, CRAFT_NATIVE_GUI, reset_packet);
    JSON_Cleanup(reset_packet);

    printf("[CRAFT GUI] reset request: player=%d gui=%d", playerid, CRAFT_NATIVE_GUI);
    SetTimerEx("Craft_OpenNativeGui", 120, false, "i", playerid);
    return 1;
}

forward Craft_OpenNativeGui(playerid);
public Craft_OpenNativeGui(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;

    // First create the native CraftGuiFragment (screen 49) with a small packet.
    new Node:open_packet = JSON_Object();
    JSON_SetInt(open_packet, "t", 5);
    JSON_SetInt(open_packet, "lm", Craft_GetLevel(playerid));
    JSON_SetInt(open_packet, "pm", 0);
    JSON_SetInt(open_packet, "pc", 0);
    JSON_SetInt(open_packet, "mpc", 1);
    JSON_SetInt(open_packet, "ps", 0);
    JSON_SetInt(open_packet, "mps", 1);
    JSON_SetInt(open_packet, "wb", Craft_GetLevel(playerid));
    JSON_SetInt(open_packet, "vm", GetPlayerMoneyEx(playerid));
    JSON_SetInt(open_packet, "h", 1);
    JSON_SetInt(open_packet, "vp", GetPlayerPremium(playerid) > 0 ? 1 : 0);
    JSON_SetInt(open_packet, "i", 0);
    JSON_SetInt(open_packet, "pns", 0);

    new Node:empty_components = JSON_Array();
    new Node:empty_production = JSON_Array();
    new Node:empty_storage = JSON_Array();
    new Node:empty_notifications = JSON_Array();
    JSON_SetArray(open_packet, "ci", empty_components);
    JSON_SetArray(open_packet, "cp", empty_production);
    JSON_SetArray(open_packet, "cs", empty_storage);
    JSON_SetArray(open_packet, "cn", empty_notifications);

    printf("[CRAFT GUI] open request: player=%d gui=%d", playerid, CRAFT_NATIVE_GUI);
    ShowPlayerGUI(playerid, CRAFT_NATIVE_GUI, open_packet);
    JSON_Cleanup(open_packet);

    // The Fragment is asynchronous; send actual inventory/job state after attach.
    SetTimerEx("Craft_SendInitialGuiState", 450, false, "i", playerid);
    return 1;
}

forward Craft_SendInitialGuiState(playerid);
public Craft_SendInitialGuiState(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;

    new Node:gui_state = JSON_Object();
    JSON_SetInt(gui_state, "t", 5);
    Craft_FillGuiState(playerid, gui_state, false);
    printf("[CRAFT GUI] state update: player=%d gui=%d", playerid, CRAFT_NATIVE_GUI);
    OnPacketIncoming(playerid, CRAFT_NATIVE_GUI, gui_state);
    JSON_Cleanup(gui_state);
    return 1;
}

stock Craft_SendGuiState(playerid, bool:mark_new = false)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    new Node:root = JSON_Object();
    JSON_SetInt(root, "t", 5);
    Craft_FillGuiState(playerid, root, mark_new);
    OnPacketIncoming(playerid, CRAFT_NATIVE_GUI, root);
    JSON_Cleanup(root);
    return 1;
}

stock Craft_AddProdArray(playerid, Node:root)
{
    new Node:production = JSON_Array();
    new recipe, finish_time, success;
    if(Craft_GetJob(playerid, recipe, finish_time, success) && recipe >= 0 && recipe < CRAFT_RECIPE_COUNT && finish_time > gettime())
    {
        new Node:item = JSON_Object();
        JSON_SetInt(item, "id", gCraftRecipe[recipe][CR_INTERNAL_ID]);
        JSON_SetInt(item, "serverId", GetPlayerAccountID(playerid));
        JSON_SetInt(item, "timeUntilItemPreparation", finish_time - gettime());
        JSON_SetInt(item, "isSomeoneElseProduction", 0);
        production = JSON_Append(production, item);
    }
    JSON_SetArray(root, "cp", production);
    return 1;
}

stock Craft_StartGui(playerid, requested_id, quantity)
{
    new recipe = Craft_FindRecipeIndex(requested_id);
    new internal_id = (recipe >= 0) ? gCraftRecipe[recipe][CR_INTERNAL_ID] : requested_id;
    if(recipe < 0 || recipe >= CRAFT_RECIPE_COUNT || !gCraftRecipe[recipe][CR_VISIBLE])
    {
        SendClientMessage(playerid, 0xE0584BFF, "Этот предмет недоступен для крафта.");
        return 0;
    }

    new craft_level = Craft_GetLevel(playerid);
    if(gCraftRecipe[recipe][CR_CLASS_ID] > craft_level)
    {
        new level_message[112];
        format(level_message, sizeof(level_message),
            "Для этого рецепта нужен уровень крафта %d. Ваш уровень: %d.",
            gCraftRecipe[recipe][CR_CLASS_ID], craft_level);
        SendClientMessage(playerid, 0xE0584BFF, level_message);
        return 0;
    }

    if(quantity != 1) quantity = 1;

    new job_recipe, finish_time, job_success;
    if(Craft_GetJob(playerid, job_recipe, finish_time, job_success))
    {
        SendClientMessage(playerid, 0xE0584BFF, "Сначала завершите или заберите текущий крафт.");
        return 0;
    }

    new cost = Craft_GetCost(recipe);
    if(GetPlayerMoneyEx(playerid) < cost)
    {
        SendClientMessage(playerid, 0xE0584BFF, "Недостаточно денег для изготовления.");
        return 0;
    }

    for(new c = 0; c < gCraftRecipe[recipe][CR_COMP_COUNT]; c++)
    {
        new comp = Craft_GetItemIndex(gCraftCompId[recipe][c]);
        if(comp < 0 || Craft_CountRecipeItem(playerid, comp) < gCraftCompQty[recipe][c])
        {
            SendClientMessage(playerid, 0xE0584BFF, "Недостаточно компонентов для изготовления.");
            return 0;
        }
    }

    for(new c = 0; c < gCraftRecipe[recipe][CR_COMP_COUNT]; c++)
    {
        new comp = Craft_GetItemIndex(gCraftCompId[recipe][c]);
        if(!Craft_RemoveRecipeItem(playerid, comp, gCraftCompQty[recipe][c]))
        {
            // Restore components already removed in this attempt.
            for(new restore = 0; restore < c; restore++)
            {
                new restore_comp = Craft_GetItemIndex(gCraftCompId[recipe][restore]);
                if(restore_comp >= 0)
                    Craft_AddRecipeItem(playerid, restore_comp, gCraftCompQty[recipe][restore]);
            }
            SendClientMessage(playerid, 0xE0584BFF, "Ошибка списания компонентов. Уже списанные предметы возвращены.");
            return 0;
        }
    }

    GivePlayerMoneyEx(playerid, -cost, "Крафт", true, true);

    new chance = gCraftRecipe[recipe][CR_CHANCE_BP];
    if(GetPlayerPremium(playerid) > 0) chance += 1000;
    if(chance > 10000) chance = 10000;
    new success = (random(10000) < chance);
    finish_time = gettime() + gCraftRecipe[recipe][CR_TIME];

    new query[240];
    mysql_format(mysql, query, sizeof(query), "INSERT INTO craft_jobs (account_id,recipe_index,finish_time,success,created_at) VALUES (%d,%d,%d,%d,%d)", GetPlayerAccountID(playerid), recipe, finish_time, success, gettime());
    new Cache:job_insert = mysql_query(mysql, query, true);
    new job_errno = mysql_errno();
    cache_delete(job_insert);
    if(job_errno)
    {
        Craft_RefundJob(playerid, recipe);
        SendClientMessage(playerid, 0xE0584BFF, "Не удалось запустить крафт: деньги и компоненты возвращены.");
        return 0;
    }

    SetTimerEx("Craft_TimerFinish", gCraftRecipe[recipe][CR_TIME] * 1000, false, "i", playerid);

    new Node:answer = JSON_Object();
    JSON_SetInt(answer, "t", 1);
    JSON_SetInt(answer, "s", 1);
    JSON_SetInt(answer, "vm", GetPlayerMoneyEx(playerid));
    JSON_SetInt(answer, "id", internal_id);
    JSON_SetInt(answer, "ct", quantity);
    Craft_AddProdArray(playerid, answer);
    OnPacketIncoming(playerid, CRAFT_NATIVE_GUI, answer);
    JSON_Cleanup(answer);

    new msg[160];
    format(msg, sizeof(msg), "Крафт запущен: %s.", gCraftRecipe[recipe][CR_NAME]);
    SendClientMessage(playerid, 0x63D471FF, msg);
    return 1;
}

stock Craft_RefundJob(playerid, recipe)
{
    if(recipe < 0 || recipe >= CRAFT_RECIPE_COUNT) return 0;

    GivePlayerMoneyEx(playerid, Craft_GetCost(recipe), "Отмена крафта", true, true);
    for(new c = 0; c < gCraftRecipe[recipe][CR_COMP_COUNT]; c++)
    {
        new comp = Craft_GetItemIndex(gCraftCompId[recipe][c]);
        if(comp < 0) continue;
        Craft_AddRecipeItem(playerid, comp, gCraftCompQty[recipe][c]);
    }
    return 1;
}

stock Craft_CancelGui(playerid, server_id)
{
    #pragma unused server_id
    new recipe, finish_time, success;
    if(!Craft_GetJob(playerid, recipe, finish_time, success)) return 0;
    if(finish_time <= gettime())
    {
        SendClientMessage(playerid, 0xE0584BFF, "Готовый предмет нельзя отменить. Заберите его из хранилища.");
        return 0;
    }

    if(!Craft_DeleteJob(playerid))
    {
        SendClientMessage(playerid, 0xE0584BFF, "Не удалось отменить крафт из-за ошибки базы данных. Предметы не списаны повторно.");
        return 0;
    }
    Craft_RefundJob(playerid, recipe);

    new Node:answer = JSON_Object();
    JSON_SetInt(answer, "t", 4);
    JSON_SetInt(answer, "vm", GetPlayerMoneyEx(playerid));
    Craft_AddCompArray(playerid, answer);
    new Node:production = JSON_Array();
    JSON_SetArray(answer, "cp", production);
    OnPacketIncoming(playerid, CRAFT_NATIVE_GUI, answer);
    JSON_Cleanup(answer);

    SendClientMessage(playerid, 0x63D471FF, "Крафт отменён. Деньги и компоненты возвращены.");
    return 1;
}

stock Craft_CollectGui(playerid, server_id)
{
    #pragma unused server_id
    new recipe, finish_time, success;
    if(!Craft_GetJob(playerid, recipe, finish_time, success)) return 0;
    if(recipe < 0 || recipe >= CRAFT_RECIPE_COUNT)
    {
        Craft_DeleteJob(playerid);
        return 0;
    }
    if(finish_time > gettime()) return 0;

    if(!success)
    {
        if(!Craft_DeleteJob(playerid))
        {
            SendClientMessage(playerid, 0xE0584BFF, "Не удалось завершить крафт из-за ошибки базы данных.");
            return 0;
        }
        Craft_AddExp(playerid, gCraftRecipe[recipe][CR_EXP]);
        Craft_SendGuiState(playerid, false);
        SendClientMessage(playerid, 0xE0584BFF, "Крафт не удался. Компоненты были потрачены.");
        return 0;
    }

    // Delete first to make collection idempotent. Restore the job if output delivery fails.
    if(!Craft_DeleteJob(playerid))
    {
        SendClientMessage(playerid, 0xE0584BFF, "Не удалось выдать предмет из-за ошибки базы данных.");
        return 0;
    }

    if(!Craft_GrantOutput(playerid, recipe))
    {
        Craft_RestoreJob(playerid, recipe, finish_time, success);
        SendClientMessage(playerid, 0xE0584BFF, "Освободите место в инвентаре или гараже.");
        return 0;
    }

    Craft_AddExp(playerid, gCraftRecipe[recipe][CR_EXP]);

    new Node:answer = JSON_Object();
    JSON_SetInt(answer, "t", 3);
    JSON_SetInt(answer, "id", GetPlayerAccountID(playerid));
    OnPacketIncoming(playerid, CRAFT_NATIVE_GUI, answer);
    JSON_Cleanup(answer);

    new msg[160];
    format(msg, sizeof(msg), "Получено: %s.", gCraftRecipe[recipe][CR_NAME]);
    SendClientMessage(playerid, 0x63D471FF, msg);
    return 1;
}

public Craft_HandleGuiPacket(playerid, Node:json)
{
    new close_screen;
    if(JSON_GetInt(json, "c", close_screen) && close_screen == 1) return 1;

    new action;
    if(!JSON_GetInt(json, "t", action)) return 1;

    switch(action)
    {
        case 1:
        {
            new internal_id, quantity;
            JSON_GetInt(json, "id", internal_id);
            JSON_GetInt(json, "ct", quantity);
            if(!Craft_StartGui(playerid, internal_id, quantity))
            {
                new Node:answer = JSON_Object();
                JSON_SetInt(answer, "t", 1);
                JSON_SetInt(answer, "s", 0);
                OnPacketIncoming(playerid, CRAFT_NATIVE_GUI, answer);
                JSON_Cleanup(answer);
            }
        }
        case 2: return 1;
        case 3:
        {
            new server_id = -1;
            JSON_GetInt(json, "id", server_id);
            Craft_CollectGui(playerid, server_id);
        }
        case 4:
        {
            new server_id;
            JSON_GetInt(json, "id", server_id);
            Craft_CancelGui(playerid, server_id);
        }
        case 6:
        {
            SendClientMessage(playerid, 0xF2C94CFF, "VIP можно приобрести в донат-меню.");
        }
        case 7: return 1;
    }
    return 1;
}

public Craft_TimerFinish(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;

    new recipe, finish_time, success;
    if(!Craft_GetJob(playerid, recipe, finish_time, success)) return 1;
    if(recipe < 0 || recipe >= CRAFT_RECIPE_COUNT)
    {
        Craft_DeleteJob(playerid);
        return 1;
    }
    if(finish_time > gettime()) return 1;

    if(!success)
    {
        if(!Craft_DeleteJob(playerid))
        {
            SendClientMessage(playerid, 0xE0584BFF, "Не удалось завершить крафт из-за ошибки базы данных.");
            return 1;
        }
        Craft_AddExp(playerid, gCraftRecipe[recipe][CR_EXP]);
        SendClientMessage(playerid, 0xE0584BFF, "Крафт не удался. Компоненты были потрачены.");
        Craft_SendGuiState(playerid, false);
        return 1;
    }

    SendClientMessage(playerid, 0x63D471FF, "Предмет готов. Заберите его во вкладке хранилища крафта.");
    Craft_SendGuiState(playerid, true);
    return 1;
}

CMD:craft(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid))
    {
        SendClientMessage(playerid, 0xE0584BFF, "Сначала авторизуйтесь на сервере.");
        return 1;
    }

    Craft_OpenGui(playerid);
    return 1;
}
alias:craft("craftmenu", "workbench", "verstat")

CMD:craftjob(playerid, params[])
{
    #pragma unused params
    if(!IsPlayerLogged(playerid))
    {
        SendClientMessage(playerid, 0xE0584BFF, "Сначала авторизуйтесь на сервере.");
        return 1;
    }

    Craft_OpenGui(playerid);
    return 1;
}
alias:craftjob("craftstatus")

CMD:givecraftcomp(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new value, amount;
    if(sscanf(params, "ii", value, amount))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givecraftcomp [component/internal ID или game ID] [количество]");

    if(amount < 1 || amount > 9999)
        return SendClientMessage(playerid, 0xCECECEFF, "Количество должно быть от 1 до 9999.");

    new component_index = Craft_FindComponentIndex(value);
    if(component_index < 0)
        return SendClientMessage(playerid, 0xE0584BFF, "Компонент с таким ID не найден. Используйте /craftcomplist.");

    new added = Craft_AddRecipeItem(playerid, component_index, amount);
    if(added <= 0)
        return SendClientMessage(playerid, 0xE0584BFF, "Не удалось выдать компонент: проверьте свободные слоты инвентаря.");

    new message[180];
    format(message, sizeof(message),
        "Выдано в инвентарь: %s x%d (component ID %d, game ID %d).",
        gCraftRecipe[component_index][CR_NAME], added,
        gCraftRecipe[component_index][CR_INTERNAL_ID], gCraftRecipe[component_index][CR_GAME_ID]);
    SendClientMessage(playerid, 0x63D471FF, message);
    Craft_SendGuiState(playerid, false);
    return 1;
}
alias:givecraftcomp("givecomp", "craftgive")

CMD:craftcheck(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new value;
    if(sscanf(params, "i", value))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /craftcheck [component/internal ID или game ID]");

    new component_index = Craft_FindComponentIndex(value);
    if(component_index < 0)
        return SendClientMessage(playerid, 0xE0584BFF, "Компонент с таким ID не найден.");

    new amount = Craft_CountRecipeItem(playerid, component_index);
    new message[192];
    format(message, sizeof(message),
        "Крафт видит: %s x%d (component ID %d, game ID %d).",
        gCraftRecipe[component_index][CR_NAME], amount,
        gCraftRecipe[component_index][CR_INTERNAL_ID],
        gCraftRecipe[component_index][CR_GAME_ID]);
    SendClientMessage(playerid, 0x63D471FF, message);
    Craft_SendGuiState(playerid, false);
    return 1;
}
alias:craftcheck("checkcomp", "craftsync")

CMD:craftcomplist(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new page = 1;
    if(strlen(params) > 0 && sscanf(params, "i", page)) page = 1;
    if(page < 1) page = 1;

    new total_components = 0;
    for(new i = 0; i < CRAFT_RECIPE_COUNT; i++)
        if(Craft_IsComponentIndex(i)) total_components++;

    new per_page = 12;
    new total_pages = (total_components + per_page - 1) / per_page;
    if(page > total_pages) page = total_pages;

    new header[96];
    format(header, sizeof(header), "Компоненты крафта — страница %d/%d. Формат: component ID | game ID | название", page, total_pages);
    SendClientMessage(playerid, 0xF2C94CFF, header);

    new first = (page - 1) * per_page;
    new last = first + per_page;
    new ordinal = 0;
    new row[160];
    for(new i = 0; i < CRAFT_RECIPE_COUNT; i++)
    {
        if(!Craft_IsComponentIndex(i)) continue;
        if(ordinal >= first && ordinal < last)
        {
            format(row, sizeof(row), "%d | %d | %s",
                gCraftRecipe[i][CR_INTERNAL_ID], gCraftRecipe[i][CR_GAME_ID], gCraftRecipe[i][CR_NAME]);
            SendClientMessage(playerid, 0xFFFFFFFF, row);
        }
        ordinal++;
        if(ordinal >= last) break;
    }
    return 1;
}
alias:craftcomplist("complist", "craftcomponents")

CMD:givecraftkit(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new recipe_internal, multiplier = 1;
    if(sscanf(params, "iI(1)", recipe_internal, multiplier))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /givecraftkit [ID рецепта] [множитель, по умолчанию 1]");

    new recipe = Craft_GetItemIndex(recipe_internal);
    if(recipe < 0 || recipe >= CRAFT_RECIPE_COUNT || !gCraftRecipe[recipe][CR_VISIBLE])
        return SendClientMessage(playerid, 0xE0584BFF, "Рецепт с таким ID не найден.");
    if(multiplier < 1 || multiplier > 100)
        return SendClientMessage(playerid, 0xCECECEFF, "Множитель должен быть от 1 до 100.");

    new issued = 0;
    for(new c = 0; c < gCraftRecipe[recipe][CR_COMP_COUNT]; c++)
    {
        new component_index = Craft_GetItemIndex(gCraftCompId[recipe][c]);
        if(component_index < 0) continue;
        issued += Craft_AddRecipeItem(playerid, component_index, gCraftCompQty[recipe][c] * multiplier);
    }

    new message[176];
    format(message, sizeof(message), "Набор для крафта «%s» выдан. Всего компонентов: %d.", gCraftRecipe[recipe][CR_NAME], issued);
    SendClientMessage(playerid, 0x63D471FF, message);
    Craft_SendGuiState(playerid, false);
    return 1;
}
alias:givecraftkit("craftkit", "givekit")

// End generated craft system.
