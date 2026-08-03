#include "../include/system/inventory.inc"

#if defined _BETA_ACCESSORY_SYSTEM_INC
    #endinput
#endif
#define _BETA_ACCESSORY_SYSTEM_INC

#if !defined mysql
    #define mysql mysql
#endif

#if !defined MAX_PLAYER_ATTACHED_OBJECTS
    #define MAX_PLAYER_ATTACHED_OBJECTS 10
#endif

#define ACCESSORY_DIALOG_LIST        (11900)
#define ACCESSORY_DIALOG_ACTION      (11910)

#define ITEM_TYPE_ACCESSORY (201)

#if !defined MIN_ACCESSORY_SLOT
    #define MIN_ACCESSORY_SLOT 2
#endif
#if !defined MAX_ACCESSORY_SLOT
    #define MAX_ACCESSORY_SLOT 9
#endif

#define INVENTORY_ACCESSORY_ITEM_BASE 1000

new g_AccessoryEditorSlot[MAX_PLAYERS] = {-1, ...};
new bool: g_HasAccessoryLoaded[MAX_PLAYERS] = {false, ...};

new Text: acss_fix_TD[26];
new PlayerText: acss_coords_fix_PTD[MAX_PLAYERS][1];

enum ACCESSORY_M_STRCT
{
    ID_ACCESSORY,
    BONE_ACCESSORY,
    NAME_ACCESSORY[32],
    PRICE_ACCESSORY,
    
};

new accessory[][ACCESSORY_M_STRCT] =
{
    {4196 , 1,"Крылья бабочки"                        ,15000000},
    {4197 , 2,"Маска пчелы"                           ,10000000},
    {4198 , 2,"Кленовая корона"                       ,7000000},
    {4199 , 1,"Рюкзак - реактивный ранец"             ,5000000},
    {4200 , 1,"Кленовая сумка"                        ,5000000},
    {4201 , 1,"Метла"                                 ,1000000},
    {4203 , 1,"Рюкзак с овощами"                      ,3000000},
    {4204 , 1,"Школьный рюкзак"                       ,3000000},
    {4205 , 2,"Шапка - подсолнух"                     ,2500000},
    {4206 , 1,"Черный зонт"                           ,1500000},
    {4207 , 1,"Зонт с листьями"                       ,1000000},
    {4208 , 1,"Розовый зонт"                          ,900000},
    {14574, 1,"Крылья демона"                         ,15000000},
    {14575, 1,"Крылья ангела"                         ,15000000},
    {14593, 1,"Карамельные крылья"                    ,15000000},
    {15134, 1,"Рюкзак инопланетянин"                  ,12000000},
    {15135, 2,"Шляпа ведьмы"                          ,2000000},
    {15136, 2,"Шляпа ведьмы"                          ,2000000},
    {15137, 2,"Шляпа ведьмы"                          ,2000000},
    {15138, 2,"Шляпа ведьмы"                          ,2000000},
    {15139, 2,"Красная шляпа ведьмы"                  ,2500000}, 
    {15140, 2,"Шляпа ведьмы"                          ,2000000},
    {15141, 2,"Шляпа ведьмы"                          ,2000000},
    {15142, 1,"Железная коса"                         ,2000000},
    {15143, 1,"Металлическая коса"                    ,1500000},
    {15144, 2,"Светящиеся красная маска"              ,500000},
    {15145, 2,"Маска маньяка"                         ,500000},
    {15146, 2,"Плачущая маска"                        ,500000},
    {15147, 2,"Страшная маска"                        ,700000},
    {15149, 1,"Метла"                                 ,1000000},
    {15150, 1,"Рюкзак FnaF"                           ,1500000},
    {15151, 2,"Маска ведущего"                        ,3000000},
    {15152, 2,"Светящиеся синяя маска"                ,500000},
    {15153, 2,"Светящиеся фиолетовая маска"           ,500000},
    {7329 , 2,"Красная повязка"                       ,300000},
    {7330 , 2,"Красная повязка"                       ,300000},
    {7331 , 2,"Военная каска 2"                       ,500000},
    {7332 , 2,"Черная шапка"                          ,300000},
    {7333 , 2,"Белая шапка"                           ,300000},
    {7334 , 2,"Синяя шапка"                           ,300000},
    {7336 , 2,"Синяя кепка 2"                         ,300000},
    {7337 , 2,"Синяя кепка 3"                         ,300000},
    {7338 , 2,"Разноцветная кепка"                    ,300000},
    {7339 , 2,"Черная кепка"                          ,300000},
    {7341 , 2,"Кепка (NY)"                            ,400000},
    {7342 , 2,"Шапка (Шерлок)"                        ,400000},
    {7343 , 2,"Панама №1 супе"                        ,300000},
    {7344 , 2,"Панама №2 (StoneIS)"                   ,300000},
    {7345 , 2,"Панама №3"                             ,300000},
    {7346 , 2,"Панана №4"                             ,300000},
    {7347 , 2,"Панама №5"                             ,300000},
    {7348 , 2,"Панама №6"                             ,300000},
    {7349 , 2,"Панама №7"                             ,300000},
    {7350 , 2,"Панама №8 (БП)"                        ,300000},
    {18377, 2,"Очки сердечки"                         ,7000000},
    {18386, 2,"Очки глаза"                            ,7000000},
    {18389, 2,"Шапочка с оленьями рожками"            ,300000},
    {18390, 2,"Очки матрица"                          ,6000000},
    {18391, 2,"Очки огонь"                            ,7000000},
    {18392, 2,"Очки огонь прямые"                     ,8000000},
    {18396, 2,"Маска гнома"                           ,2500000},
    {18397, 2,"Маска гринча"                          ,2000000},
    {18399, 2,"Рожки"                                 ,1000000},
    {18400, 2,"Рожки 2"                               ,100000},
    {18401, 2,"Очки салют"                            ,7000000},
    {18402, 2,"Маска котика"                          ,3000000},
    {18403, 2,"Маска тигра"                           ,3000000},
    {18404, 2,"Очки глюки"                            ,7000000},
    {18409, 2,"Очки снежинки"                         ,7000000},
    {7351 , 2,"Кепка"                                 ,300000},
    {7352 , 2,"Кепка 2"                               ,300000},
    {7353 , 2,"Кепка"                                 ,300000},
    {7354 , 2,"Кепка"                                 ,300000},
    {7355 , 2,"Шляпа №1"                              ,400000},
    {7356 , 2,"Шляпа №2"                              ,450000},
    {7357 , 2,"Шляпа №3 (New)"                        ,450000},
    {7358 , 2,"Шляпа №4"                              ,500000},
    {7359 , 2,"Шляпа №5"                              ,500000},
    {7360 , 2,"Шляпа №6"                              ,500000},
    {7362 , 2,"Синяя шапка"                           ,350000},
    {7364 , 1,"Зонт (Разноцветный)"                   ,8000000},
    {7367 , 6,"Кожаный кейс"                          ,5000000},
    {7368 , 6,"Кейс (2)"                              ,10000000},
    {7369 , 6,"Черный кейс"                           ,12000000},
    {7370 , 2,"Маска петуха"                          ,5000000},
    {7371 , 2,"Маска голубя"                          ,5000000},
    {7372 , 2,"Маска зелёная"                         ,3000000},
    {7374 , 2,"Маска медведя"                         ,4000000},
    {7375 , 2,"Маска самурай"                         ,5000000},
    {7376 , 2,"Маска самурай"                         ,5000000},
    {7377 , 1,"Катана"                                ,1000000},
    {7378 , 1,"Катана"                                ,1000000},
    {7379 , 2,"Шляпа самурая №1"                      ,1500000},
    {7380 , 2,"Шляпа самурая №2"                      ,1500000},
    {7381 , 2,"Шляпа самурая №3"                      ,1500000},
    {7382 , 2,"Шляпа индейца"                         ,1500000},
    {7383 , 1,"Доска для серфинга №1"                 ,500000},
    {7384 , 1,"Доска для серфинга №2"                 ,500000},
    {7385 , 1,"Доска для серфинга №3"                 ,500000},
    {7386 , 1,"Доска для серфинга №4"                 ,500000},
    {7387 , 1,"Акула"                                 ,750000},
    {7390 , 1,"Гитара №1"                             ,700000},
    {7391 , 1,"Гитара №2"                             ,700000},
    {7392 , 1,"Гитара №3"                             ,700000},
    {7393 , 1,"Гитара №4"                             ,700000},
    {7394 , 1,"Скейт №1"                              ,750000},
    {7395 , 1,"Скейт №2"                              ,750000},
    {790 ,  1,"Новогодний Дракон"                     ,4000000},
    {787 ,  2,"Маска Дракона"                         ,7000000},
    {9824 , 1,"Весёлая тыква"                         ,5000000},
    {9825 , 1,"Хеллоуинские ночи"                     ,3000000},
    {9827 , 1,"Кукла Вуду"                            ,5000000},
    {9828 , 1,"Призрачный портал"                     ,4000000},
    {11919, 2,"Акула на голову"                       ,6000000},
    {11923, 1,"Рюкзак Мопс на спину"                  ,5000000},
    {14589, 1,"Маска Оленя"                           ,6000000},
    {31949, 6,"Берет 80"                              ,13800000},
    {677  , 1,"Советская"                             ,100000},
    {676  , 2,"Очки"                                  ,13000000},
    {2655 , 1,"Шлем"                                  ,200000},
    {2656 , 1,"Надувной"                              ,11400000},
    {2657 , 2,"Очки"                                  ,6200000},
    {16055, 2,"Лапка"                                 ,700000},
    {9826 , 2,"Маска"                                 ,6600000},
    {11922, 1,"ГеймБой"                               ,7200000},
    {11925, 6,"Летняя доска"                          ,2800000},
    {13801, 6,"Катюша"                                ,4200000},
    {13803, 1,"Рюкзак"                                ,5200000},
    {14591, 2,"Белые рога"                            ,200000},
    {14592, 6,"Уши эльфа"                             ,1300000},
    {14596, 2,"Маска елочки"                          ,800000},
    {14597, 2,"Рождественские рога"                   ,2900000},
    {14598, 2,"Маска Деда Мороза"                     ,600000},
    {14603, 6,"Шапка-Ушанка"                          ,2900000},
    {4160 , 6,"Новогодний кекс"                       ,3100000},
    {4161 , 6,"Новогодний мишка"                      ,1100000},
    {4162 , 2,"Маска Снегурочка"                      ,6500000},
    {4163 , 2,"Маска Снеговика"                       ,200000},
    {4165 , 1,"Сумка Снеговика"                       ,12900000},
    {13883, 2,"Корона демона"                         ,100000},
    {18509, 6,"Кейс"                                  ,100000},
    {18510, 6,"Кейс черный"                           ,800000},
    {18511, 6,"Кейс серый"                            ,600000},
    {18512, 2,"Золотая корона"                        ,12300000},
    {18513, 2,"Корона короля"                         ,300000},
    {18514, 2,"Серебряная корона"                     ,4600000},
    {18515, 6,"Лавровый венец"                        ,800000},
    {18516, 2,"Диадема"                               ,500000},
    {18517, 2,"Очки Доллар"                           ,600000},
    {18518, 2,"Очки День рождения"                    ,300000},
    {18519, 2,"Праздничный колпак"                    ,600000},
    {18520, 2,"Неоновые очки"                         ,11200000},
    {18521, 2,"Неоновые очки"                         ,1500000},
    {18522, 2,"Неоновые очки"                         ,12300000},
    {18523, 2,"Неоновые очки"                         ,12100000},
    {18524, 2,"Неоновые очки"                         ,2200000},
    {18525, 2,"Неоновые очки"                         ,1300000},
    {18526, 2,"Очки пиксели"                          ,4900000},
    {18527, 2,"Шар"                                   ,3300000},
    {18528, 1,"Шар"                                   ,2900000},
    {18529, 1,"Шар"                                   ,8500000},
    {18530, 2,"Шар"                                   ,6200000},
    {18497, 2,"Шарик"                                 ,800000},
    {18498, 2,"Очки 'Выпуклые глаза'"                 ,600000},
    {18499, 2,"Очки 'Обычные глаза'"                  ,100000},
    {18500, 2,"Маска клоуна"                          ,1600000},
    {18501, 2,"Маска клоуна"                          ,3300000},
    {18502, 2,"Лицо тролля"                           ,2400000},
    {18503, 6,"Инопланетянин"                         ,4500000},
    {18504, 2,"Тролль с париком"                      ,14300000},
    {18505, 6,"Инопланетянин с париком"               ,14500000},
    {18506, 2,"Очки с носом"                          ,100000},
    {18507, 1,"Нос клоуна"                            ,10700000},
    {18508, 1,"Парик клоуна"                          ,100000},
    {18233, 1,"Деревянный"                            ,1600000},
    {18232, 6,"Берет"                                 ,900000},
    {18243, 2,"Карамельная конфета"                   ,600000},
    {18250, 1,"Белая панама"                          ,6900000},
    {18383, 6,"Черная панама"                         ,6900000},
    {18384, 6,"Серая панама"                          ,2500000},
    {18385, 2,"Темная панама"                         ,3000000},
    {18263, 6,"Белая панама"                          ,5500000},
    {18264, 6,"Черная панама"                         ,13000000},
    {18273, 2,"Высокая панама"                        ,600000},
    {18279, 2,"Черная шапка"                          ,100000},
    {18285, 6,"Посох-зонт"                            ,1800000},
    {18286, 2,"Кандибобер"                            ,1600000},
    {18346, 6,"Синий посох"                           ,10400000},
    {18347, 6,"Синий посох"                           ,2300000},
    {18348, 6,"Голубой посох"                         ,7100000},
    {18369, 2,"Новогодний топорик"                    ,1300000},
    {18375, 6,"Новогодняя палочка"                    ,2100000},
    {18378, 1,"Рюкзак 'Котик'"                        ,5300000},
    {18379, 1,"Рюкзак 'Санта-Клауса'"                 ,11800000},
    {18410, 2,"Очки"                                  ,1500000},
    {18411, 6,"Голубой посох"                         ,100000},
    {18412, 2,"Очки"                                  ,1000000},
    {18414, 2,"Прямые очки"                           ,4200000},
    {15158, 6,"Кепка"                                 ,2800000},
    {15154, 2,"Неоновая маска"                        ,9900000},
    {15155, 2,"Неоновая маска"                        ,2200000},
    {15157, 1,"Рюкзак"                                ,6500000},
    {15148, 2,"Маска Дали"                            ,900000},
    {15160, 2,"Маска круга"                           ,9300000},
    {15161, 2,"Маска треугольника"                    ,200000},
    {15159, 2,"Маска квадрата"                        ,8400000}
};

stock CreateEditAccessoryTD()
{
    	acss_fix_TD[0] = TextDrawCreate(35.0000, 18.0000, "txd:bracstext");
	TextDrawTextSize(acss_fix_TD[0], 127.0000, 45.0000);
	TextDrawAlignment(acss_fix_TD[0], 1);
	TextDrawColor(acss_fix_TD[0], -1);
	TextDrawBackgroundColor(acss_fix_TD[0], 255);
	TextDrawFont(acss_fix_TD[0], 4);

	acss_fix_TD[1] = TextDrawCreate(600.0000, 0.1, "txd:bracsbtnexit");
	TextDrawTextSize(acss_fix_TD[1], 45.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[1], 1);
	TextDrawColor(acss_fix_TD[1], -1);
	TextDrawBackgroundColor(acss_fix_TD[1], 255);
	TextDrawFont(acss_fix_TD[1], 4);
	TextDrawSetSelectable(acss_fix_TD[1], true);

	acss_fix_TD[2] = TextDrawCreate(453.0000, 355.0000, "txd:bracssave");
	TextDrawTextSize(acss_fix_TD[2], 130.0000, 40.0000);
	TextDrawAlignment(acss_fix_TD[2], 1);
	TextDrawColor(acss_fix_TD[2], -1);
	TextDrawBackgroundColor(acss_fix_TD[2], 255);
	TextDrawFont(acss_fix_TD[2], 4);
	TextDrawSetSelectable(acss_fix_TD[2], true);

   	acss_fix_TD[3] = TextDrawCreate(35.0000, 65.0000, "txd:bracsn1");
	TextDrawTextSize(acss_fix_TD[3], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[3], 1);
	TextDrawColor(acss_fix_TD[3], -1);
	TextDrawBackgroundColor(acss_fix_TD[3], 255);
	TextDrawFont(acss_fix_TD[3], 4);
	TextDrawSetSelectable(acss_fix_TD[3], true);

	acss_fix_TD[4] = TextDrawCreate(35.0000, 110.0000, "txd:bracsn2");
	TextDrawTextSize(acss_fix_TD[4], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[4], 1);
	TextDrawColor(acss_fix_TD[4], -1);
	TextDrawBackgroundColor(acss_fix_TD[4], 255);
	TextDrawFont(acss_fix_TD[4], 4);
	TextDrawSetSelectable(acss_fix_TD[4], true);

	acss_fix_TD[5] = TextDrawCreate(35.0000, 155.0000, "txd:bracsn3");
	TextDrawTextSize(acss_fix_TD[5], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[5], 1);
	TextDrawColor(acss_fix_TD[5], -1);
	TextDrawBackgroundColor(acss_fix_TD[5], 255);
	TextDrawFont(acss_fix_TD[5], 4);
	TextDrawSetSelectable(acss_fix_TD[5], true);

	acss_fix_TD[6] = TextDrawCreate(35.0000, 200.0000, "txd:bracsn4");
	TextDrawTextSize(acss_fix_TD[6], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[6], 1);
	TextDrawColor(acss_fix_TD[6], -1);
	TextDrawBackgroundColor(acss_fix_TD[6], 255);
	TextDrawFont(acss_fix_TD[6], 4);
	TextDrawSetSelectable(acss_fix_TD[6], true);

	acss_fix_TD[7] = TextDrawCreate(35.0000, 245.0000, "txd:bracsn5");
	TextDrawTextSize(acss_fix_TD[7], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[7], 1);
	TextDrawColor(acss_fix_TD[7], -1);
	TextDrawBackgroundColor(acss_fix_TD[7], 255);
	TextDrawFont(acss_fix_TD[7], 4);
	TextDrawSetSelectable(acss_fix_TD[7], true);

	acss_fix_TD[8] = TextDrawCreate(35.0000, 290.0000, "txd:bracsn6");
	TextDrawTextSize(acss_fix_TD[8], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[8], 1);
	TextDrawColor(acss_fix_TD[8], -1);
	TextDrawBackgroundColor(acss_fix_TD[8], 255);
	TextDrawFont(acss_fix_TD[8], 4);
	TextDrawSetSelectable(acss_fix_TD[8], true);

	acss_fix_TD[9] = TextDrawCreate(35.0000, 335.0000, "txd:bracsn7");
	TextDrawTextSize(acss_fix_TD[9], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[9], 1);
	TextDrawColor(acss_fix_TD[9], -1);
	TextDrawBackgroundColor(acss_fix_TD[9], 255);
	TextDrawFont(acss_fix_TD[9], 4);
	TextDrawSetSelectable(acss_fix_TD[9], true);

	acss_fix_TD[10] = TextDrawCreate(35.0000, 65.0000, "txd:bracsa1");
	TextDrawTextSize(acss_fix_TD[10], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[10], 1);
	TextDrawColor(acss_fix_TD[10], -1);
	TextDrawBackgroundColor(acss_fix_TD[10], 255);
	TextDrawFont(acss_fix_TD[10], 4);

	acss_fix_TD[11] = TextDrawCreate(35.0000, 110.0000, "txd:bracsa2");
	TextDrawTextSize(acss_fix_TD[11], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[11], 1);
	TextDrawColor(acss_fix_TD[11], -1);
	TextDrawBackgroundColor(acss_fix_TD[11], 255);
	TextDrawFont(acss_fix_TD[11], 4);

	acss_fix_TD[12] = TextDrawCreate(35.0000, 155.0000, "txd:bracsa3");
	TextDrawTextSize(acss_fix_TD[12], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[12], 1);
	TextDrawColor(acss_fix_TD[12], -1);
	TextDrawBackgroundColor(acss_fix_TD[12], 255);
	TextDrawFont(acss_fix_TD[12], 4);

	acss_fix_TD[13] = TextDrawCreate(35.0000, 200.0000, "txd:bracsa4");
	TextDrawTextSize(acss_fix_TD[13], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[13], 1);
	TextDrawColor(acss_fix_TD[13], -1);
	TextDrawBackgroundColor(acss_fix_TD[13], 255);
	TextDrawFont(acss_fix_TD[13], 4);

	acss_fix_TD[14] = TextDrawCreate(35.0000, 245.0000, "txd:bracsa5");
	TextDrawTextSize(acss_fix_TD[14], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[14], 1);
	TextDrawColor(acss_fix_TD[14], -1);
	TextDrawBackgroundColor(acss_fix_TD[14], 255);
	TextDrawFont(acss_fix_TD[14], 4);

	acss_fix_TD[15] = TextDrawCreate(35.0000, 290.0000, "txd:bracsa6");
	TextDrawTextSize(acss_fix_TD[15], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[15], 1);
	TextDrawColor(acss_fix_TD[15], -1);
	TextDrawBackgroundColor(acss_fix_TD[15], 255);
	TextDrawFont(acss_fix_TD[15], 4);

	acss_fix_TD[16] = TextDrawCreate(35.0000, 335.0000, "txd:bracsa7");
	TextDrawTextSize(acss_fix_TD[16], 117.0000, 42.0000);
	TextDrawAlignment(acss_fix_TD[16], 1);
	TextDrawColor(acss_fix_TD[16], -1);
	TextDrawBackgroundColor(acss_fix_TD[16], 255);
	TextDrawFont(acss_fix_TD[16], 4);

	acss_fix_TD[17] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm1");
	TextDrawTextSize(acss_fix_TD[17], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[17], 1);
	TextDrawColor(acss_fix_TD[17], -1);
	TextDrawBackgroundColor(acss_fix_TD[17], 255);
	TextDrawFont(acss_fix_TD[17], 4);
	TextDrawSetProportional(acss_fix_TD[17], 0);
	TextDrawSetShadow(acss_fix_TD[17], 0);

	acss_fix_TD[18] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm2");
	TextDrawTextSize(acss_fix_TD[18], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[18], 1);
	TextDrawColor(acss_fix_TD[18], -1);
	TextDrawBackgroundColor(acss_fix_TD[18], 255);
	TextDrawFont(acss_fix_TD[18], 4);
	TextDrawSetProportional(acss_fix_TD[18], 0);
	TextDrawSetShadow(acss_fix_TD[18], 0);

	acss_fix_TD[19] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm3");
	TextDrawTextSize(acss_fix_TD[19], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[19], 1);
	TextDrawColor(acss_fix_TD[19], -1);
	TextDrawBackgroundColor(acss_fix_TD[19], 255);
	TextDrawFont(acss_fix_TD[19], 4);
	TextDrawSetProportional(acss_fix_TD[19], 0);
	TextDrawSetShadow(acss_fix_TD[19], 0);

	acss_fix_TD[20] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm4");
	TextDrawTextSize(acss_fix_TD[20], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[20], 1);
	TextDrawColor(acss_fix_TD[20], -1);
	TextDrawBackgroundColor(acss_fix_TD[20], 255);
	TextDrawFont(acss_fix_TD[20], 4);
	TextDrawSetProportional(acss_fix_TD[20], 0);
	TextDrawSetShadow(acss_fix_TD[20], 0);

	acss_fix_TD[21] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm5");
	TextDrawTextSize(acss_fix_TD[21], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[21], 1);
	TextDrawColor(acss_fix_TD[21], -1);
	TextDrawBackgroundColor(acss_fix_TD[21], 255);
	TextDrawFont(acss_fix_TD[21], 4);
	TextDrawSetProportional(acss_fix_TD[21], 0);
	TextDrawSetShadow(acss_fix_TD[21], 0);

	acss_fix_TD[22] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm6");
	TextDrawTextSize(acss_fix_TD[22], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[22], 1);
	TextDrawColor(acss_fix_TD[22], -1);
	TextDrawBackgroundColor(acss_fix_TD[22], 255);
	TextDrawFont(acss_fix_TD[22], 4);
	TextDrawSetProportional(acss_fix_TD[22], 0);
	TextDrawSetShadow(acss_fix_TD[22], 0);

	acss_fix_TD[23] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm7");
	TextDrawTextSize(acss_fix_TD[23], 180.0000, 230.0000);
	TextDrawAlignment(acss_fix_TD[23], 1);
	TextDrawColor(acss_fix_TD[23], -1);
	TextDrawBackgroundColor(acss_fix_TD[23], 255);
	TextDrawFont(acss_fix_TD[23], 4);
	TextDrawSetProportional(acss_fix_TD[23], 0);
	TextDrawSetShadow(acss_fix_TD[23], 0);

	acss_fix_TD[24] = TextDrawCreate(460.0000, 205.0000, "txd:transparent");
	TextDrawTextSize(acss_fix_TD[24], 50.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[24], 1);
	TextDrawColor(acss_fix_TD[24], 0x00000000);
	TextDrawBackgroundColor(acss_fix_TD[24], 255);
	TextDrawFont(acss_fix_TD[24], 4);
	TextDrawSetProportional(acss_fix_TD[24], 0);
	TextDrawSetShadow(acss_fix_TD[24], 0);
	TextDrawSetSelectable(acss_fix_TD[24], true);

	acss_fix_TD[25] = TextDrawCreate(530.0000, 205.0000, "txd:transparent");
	TextDrawTextSize(acss_fix_TD[25], 50.0000, 50.0000);
	TextDrawAlignment(acss_fix_TD[25], 1);
	TextDrawColor(acss_fix_TD[25], 0x00000000);
	TextDrawBackgroundColor(acss_fix_TD[23], 255);
	TextDrawFont(acss_fix_TD[25], 4);
	TextDrawSetProportional(acss_fix_TD[25], 0);
	TextDrawSetShadow(acss_fix_TD[25], 0);
	TextDrawSetSelectable(acss_fix_TD[25], true);
}

stock Accessory_SaveEditedSlot(playerid)
{
    new slot = g_AccessoryEditorSlot[playerid];
    if(slot < MIN_ACCESSORY_SLOT || slot > MAX_ACCESSORY_SLOT) return 0;
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new acs = GetPVarInt(playerid, "acs_id");
    new bone = GetPVarInt(playerid, "bone");

    new q[512];
    mysql_format(mysql, q, sizeof(q),
        "REPLACE INTO `player_accessories` (`account_id`,`active_slot`,`accessory_id`,`bone`,`x`,`y`,`z`,`rx`,`ry`,`rz`,`scale`) VALUES (%d,%d,%d,%d,%f,%f,%f,%f,%f,%f,%f)",
        GetPlayerAccountID(playerid),
        slot,
        acs,
        bone,
        GetPVarFloat(playerid, "edit_x"),
        GetPVarFloat(playerid, "edit_y"),
        GetPVarFloat(playerid, "edit_z"),
        GetPVarFloat(playerid, "edit_rX"),
        GetPVarFloat(playerid, "edit_rY"),
        GetPVarFloat(playerid, "edit_rZ"),
        GetPVarFloat(playerid, "edit_scale"));
    mysql_query(mysql, q, false);
    return 1;
}

stock Accessory_LoadAndApplySlot(playerid, activeSlot, accessoryId)
{
    if(activeSlot < MIN_ACCESSORY_SLOT || activeSlot > MAX_ACCESSORY_SLOT) return 0;
    if(accessoryId < 0 || accessoryId >= sizeof(accessory)) return 0;

    new bone = accessory[accessoryId][BONE_ACCESSORY];
    new Float:x = 0.0, Float:y = 0.0, Float:z = 0.0;
    new Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0, Float:scale = 1.0;

    if(GetPlayerAccountID(playerid) > 0)
    {
        new q[256];
        mysql_format(mysql, q, sizeof(q),
            "SELECT `bone`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `scale` FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d LIMIT 1",
            GetPlayerAccountID(playerid), activeSlot);
        new Cache:result = mysql_query(mysql, q, true);
        
        if(cache_num_rows() > 0)
        {
            bone = cache_get_field_content_int(0, "bone");
            x = cache_get_field_content_float(0, "x");
            y = cache_get_field_content_float(0, "y");
            z = cache_get_field_content_float(0, "z");
            rx = cache_get_field_content_float(0, "rx");
            ry = cache_get_field_content_float(0, "ry");
            rz = cache_get_field_content_float(0, "rz");
            scale = cache_get_field_content_float(0, "scale");
        }
        cache_delete(result);
    }

    SetPlayerAttachedObject(playerid, activeSlot, accessory[accessoryId][ID_ACCESSORY], bone, x, y, z, rx, ry, rz, scale, scale, scale);
    return 1;
}

stock bool:Accessory_CanEquip(playerid, accessoryId)
{
    if(accessoryId < 0 || accessoryId >= sizeof(accessory))
        return true;

    new bone = accessory[accessoryId][BONE_ACCESSORY];
    if(bone <= 0)
        return true;

    printf("[ACCESSORY] CanEquip: checking bone %d for accessory %d", bone, accessoryId);

    for(new s = MIN_ACCESSORY_SLOT; s <= MAX_ACCESSORY_SLOT; s++)
    {
        if(g_PlayerActiveSlots[playerid][s][inv_itemId] > 0)
        {
            if(g_PlayerActiveSlots[playerid][s][inv_itemId] == 134)
            {
                printf("[ACCESSORY] CanEquip: slot %d contains skin, skipping", s);
                continue;
            }
            
            new equippedId = -1;
            
            if(g_PlayerActiveSlots[playerid][s][inv_itemPlate][0] != 0)
            {
                equippedId = strval(g_PlayerActiveSlots[playerid][s][inv_itemPlate]);
                printf("[ACCESSORY] CanEquip: got equippedId %d from plate", equippedId);
            }
            
            if(equippedId < 0 || equippedId >= sizeof(accessory))
            {
                equippedId = Accessory_GetAccessoryIdByInventoryId(g_PlayerActiveSlots[playerid][s][inv_itemId]);
                printf("[ACCESSORY] CanEquip: got equippedId %d from inventory ID %d", 
                    equippedId, g_PlayerActiveSlots[playerid][s][inv_itemId]);
            }
            
            if(equippedId >= 0 && equippedId < sizeof(accessory))
            {
                if(accessory[equippedId][BONE_ACCESSORY] == bone)
                {
                    printf("[ACCESSORY] CanEquip: conflict with slot %d, bone %d", s, bone);
                    SendClientMessage(playerid, 0xFF9900FF, "У вас уже есть аксессуар на этой кости.");
                    return false;
                }
            }
        }
    }

    printf("[ACCESSORY] CanEquip: no conflicts, can equip");
    return true;
}

stock Accessory_OnEquipped(playerid, activeSlot, accessoryId)
{
    return Accessory_LoadAndApplySlot(playerid, activeSlot, accessoryId);
}

stock Accessory_OnUnequipped(playerid, activeSlot)
{
    if(activeSlot < MIN_ACCESSORY_SLOT || activeSlot > MAX_ACCESSORY_SLOT) return 0;
    
    if(IsPlayerAttachedObjectSlotUsed(playerid, activeSlot)) 
        RemovePlayerAttachedObject(playerid, activeSlot);

    DeletePVar(playerid, "acs_id_in_slot");

    if(GetPlayerAccountID(playerid) > 0)
    {
        new q[160];
        mysql_format(mysql, q, sizeof(q),
            "DELETE FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d",
            GetPlayerAccountID(playerid), activeSlot);
        mysql_query(mysql, q, false);
    }
    return 1;
}

stock Accessory_OnPlayerSpawn(playerid)
{
    if(!IsPlayerLogged(playerid) || GetPlayerAccountID(playerid) <= 0) return 0;

    new q[256];
    mysql_format(mysql, q, sizeof(q),
        "SELECT `active_slot`, `accessory_id`, `bone`, `x`, `y`, `z`, `rx`, `ry`, `rz`, `scale` FROM `player_accessories` WHERE `account_id` = %d",
        GetPlayerAccountID(playerid));
    new Cache:result = mysql_query(mysql, q, true);

    new rows = cache_num_rows();
    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "active_slot");
        new acs = cache_get_field_content_int(i, "accessory_id");
        new bone = cache_get_field_content_int(i, "bone");
        new Float:x = cache_get_field_content_float(i, "x");
        new Float:y = cache_get_field_content_float(i, "y");
        new Float:z = cache_get_field_content_float(i, "z");
        new Float:rx = cache_get_field_content_float(i, "rx");
        new Float:ry = cache_get_field_content_float(i, "ry");
        new Float:rz = cache_get_field_content_float(i, "rz");
        new Float:scale = cache_get_field_content_float(i, "scale");

        if(slot >= MIN_ACCESSORY_SLOT && slot <= MAX_ACCESSORY_SLOT && acs >= 0 && acs < sizeof(accessory))
        {
            SetPlayerAttachedObject(playerid, slot, accessory[acs][ID_ACCESSORY], bone, x, y, z, rx, ry, rz, scale, scale, scale);
            
            SetPVarInt(playerid, "acs_id_in_slot", acs);
            
            new inventoryItemId = Accessory_GetInventoryItemId(acs);
            for(new j = 0; j < MAX_INVENTORY_SLOTS; j++)
            {
                if(g_PlayerInventory[playerid][j][inv_itemId] == inventoryItemId && 
                   !g_PlayerInventory[playerid][j][inv_itemActive])
                {
                    new plateStr[16];
                    format(plateStr, sizeof(plateStr), "%d", acs);
                    
                    g_PlayerInventory[playerid][j][inv_itemActive] = true;
                    g_PlayerInventory[playerid][j][inv_activeSlot] = slot;
                    format(g_PlayerInventory[playerid][j][inv_itemPlate], 32, "%s", plateStr);
                    SaveInventoryItem(playerid, j);
                    break;
                }
            }
        }
    }
    cache_delete(result);
    
    g_HasAccessoryLoaded[playerid] = true;
    return 1;
}

stock Accessory_StartEditor(playerid, activeSlot)
{
    printf("[EDITOR] Starting editor for player %d, slot %d", playerid, activeSlot);
    
    if(activeSlot < 2 || activeSlot > 9) 
    {
        printf("[EDITOR] Invalid slot");
        return 0;
    }
    
    if(!IsPlayerAttachedObjectSlotUsed(playerid, activeSlot)) 
    {
        printf("[EDITOR] Slot %d not used", activeSlot);
        return 0;
    }

    new acs = GetPVarInt(playerid, "acs_id_in_slot");
    printf("[EDITOR] acs_id_in_slot: %d", acs);
    
    if(acs < 0 || acs >= sizeof(accessory))
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ошибка: не удалось определить аксессуар.");
        return 0;
    }

    new bone = accessory[acs][BONE_ACCESSORY];
    
    g_AccessoryEditorSlot[playerid] = activeSlot;
    SetPVarInt(playerid, "acs_id", acs);
    SetPVarInt(playerid, "bone", bone);
    SetPVarFloat(playerid, "edit_x", 0.0);
    SetPVarFloat(playerid, "edit_y", 0.0);
    SetPVarFloat(playerid, "edit_z", 0.0);
    SetPVarFloat(playerid, "edit_rX", 0.0);
    SetPVarFloat(playerid, "edit_rY", 0.0);
    SetPVarFloat(playerid, "edit_rZ", 0.0);
    SetPVarFloat(playerid, "edit_scale", 1.0);
    SetPVarInt(playerid, "acss_fix_TD_use", 1);

    SelectTextDraw(playerid, 0x66CC33FF);
    
    for(new i = 0; i < 11; i++) 
    {
        if(acss_fix_TD[i] != Text:INVALID_TEXT_DRAW)
            TextDrawShowForPlayer(playerid, acss_fix_TD[i]);
    }
    
    if(acss_fix_TD[17] != Text:INVALID_TEXT_DRAW)
        TextDrawShowForPlayer(playerid, acss_fix_TD[17]);
        
    if(acss_fix_TD[24] != Text:INVALID_TEXT_DRAW)
        TextDrawShowForPlayer(playerid, acss_fix_TD[24]);
        
    if(acss_fix_TD[25] != Text:INVALID_TEXT_DRAW)
        TextDrawShowForPlayer(playerid, acss_fix_TD[25]);

    new acs_coords[32];
    format(acs_coords, sizeof(acs_coords), "X: 0.00");

    if(acss_coords_fix_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawDestroy(playerid, acss_coords_fix_PTD[playerid][0]);
    }

    acss_coords_fix_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);
    
    if(acss_coords_fix_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawLetterSize(playerid, acss_coords_fix_PTD[playerid][0], 0.3000, 1.6000);
        PlayerTextDrawAlignment(playerid, acss_coords_fix_PTD[playerid][0], 2);
        PlayerTextDrawColor(playerid, acss_coords_fix_PTD[playerid][0], 0xFFFFFFFF);
        PlayerTextDrawBackgroundColor(playerid, acss_coords_fix_PTD[playerid][0], 255);
        PlayerTextDrawFont(playerid, acss_coords_fix_PTD[playerid][0], 1);
        PlayerTextDrawSetProportional(playerid, acss_coords_fix_PTD[playerid][0], 1);
        PlayerTextDrawSetShadow(playerid, acss_coords_fix_PTD[playerid][0], 0);
        PlayerTextDrawShow(playerid, acss_coords_fix_PTD[playerid][0]);
    }
   
    printf("[EDITOR] Editor started successfully for slot %d, accessory %d", activeSlot, acs);
    
    return 1;
}

stock Accessory_StopEditor(playerid, bool:save)
{
    if(g_AccessoryEditorSlot[playerid] < MIN_ACCESSORY_SLOT) 
        return 0;

    if(save)
    {
        Accessory_SaveEditedSlot(playerid);
        new slot = g_AccessoryEditorSlot[playerid];
        new acs = GetPVarInt(playerid, "acs_id");
        if(acs > 0 && acs < sizeof(accessory))
        {
            Accessory_LoadAndApplySlot(playerid, slot, acs);
        }
        SendClientMessage(playerid, 0x66CC33FF, "Позиция аксессуара сохранена.");
    }

    for(new i = 0; i < sizeof(acss_fix_TD); i++)
    {
        if(acss_fix_TD[i] != Text:INVALID_TEXT_DRAW)
            TextDrawHideForPlayer(playerid, acss_fix_TD[i]);
    }

    if(acss_coords_fix_PTD[playerid][0] != PlayerText:INVALID_TEXT_DRAW)
    {
        PlayerTextDrawHide(playerid, acss_coords_fix_PTD[playerid][0]);
        PlayerTextDrawDestroy(playerid, acss_coords_fix_PTD[playerid][0]);
        acss_coords_fix_PTD[playerid][0] = PlayerText:INVALID_TEXT_DRAW;
    }

    CancelSelectTextDraw(playerid);

    g_AccessoryEditorSlot[playerid] = -1;

    DeletePVar(playerid, "acs_id");
    DeletePVar(playerid, "bone");
    DeletePVar(playerid, "edit_x");
    DeletePVar(playerid, "edit_y");
    DeletePVar(playerid, "edit_z");
    DeletePVar(playerid, "edit_rX");
    DeletePVar(playerid, "edit_rY");
    DeletePVar(playerid, "edit_rZ");
    DeletePVar(playerid, "edit_scale");
    DeletePVar(playerid, "acss_fix_TD_use");

        
    return 1;
}

stock bool:Accessory_HandleDialog(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext

    if(dialogid == ACCESSORY_DIALOG_LIST)
    {
        if(!response) return true;

        new count = 0;
        for(new s = MIN_ACCESSORY_SLOT; s <= MAX_ACCESSORY_SLOT; s++)
        {
            if(IsPlayerAttachedObjectSlotUsed(playerid, s))
            {
                if(count == listitem)
                {
                    SetPVarInt(playerid, "acc_sel_slot", s);
                    ShowPlayerDialog(playerid, ACCESSORY_DIALOG_ACTION, DIALOG_STYLE_TABLIST_HEADERS,
                        "Управление аксессуаром", "#\tДействие\n1\tРедактировать\n2\tСнять", "Выбрать", "Закрыть");
                    return true;
                }
                count++;
            }
        }
        return true;
    }

if(dialogid == ACCESSORY_DIALOG_ACTION)
{
    if(!response) return true;

    new slot = GetPVarInt(playerid, "acc_sel_slot");
    if(slot < MIN_ACCESSORY_SLOT || slot > MAX_ACCESSORY_SLOT) return true;

    if(listitem == 0)
    {
        Accessory_StartEditor(playerid, slot);
    }
    else if(listitem == 1)
    {
        Accessory_UnequipToInventory(playerid, slot);
    }

    return true;
}

    return false;
}

stock bool:Accessory_HandleTextDraw(playerid, Text:clickedid)
{
    if(g_AccessoryEditorSlot[playerid] < MIN_ACCESSORY_SLOT) return false;

    if(clickedid == acss_fix_TD[1]) return Accessory_StopEditor(playerid, false), true;
    if(clickedid == acss_fix_TD[2]) return Accessory_StopEditor(playerid, true), true;

    if(acss_fix_TD[3] <= clickedid <= acss_fix_TD[9])
    {
        new TD;
        for(new i = 3; i < 10; i++) if(clickedid == acss_fix_TD[i]) TD = i;
        new td_use = GetPVarInt(playerid, "acss_fix_TD_use"), count_TD = TD - 3, Float:float_count;

        TextDrawHideForPlayer(playerid, acss_fix_TD[9 + td_use]);
        TextDrawShowForPlayer(playerid, acss_fix_TD[2 + td_use]);
        TextDrawHideForPlayer(playerid, acss_fix_TD[16 + td_use]);
        TextDrawHideForPlayer(playerid, acss_fix_TD[3 + count_TD]);
        TextDrawShowForPlayer(playerid, acss_fix_TD[10 + count_TD]);
        TextDrawShowForPlayer(playerid, acss_fix_TD[17 + count_TD]);
        SetPVarInt(playerid, "acss_fix_TD_use", count_TD + 1);

        switch(TD)
        {
            case 3: float_count = GetPVarFloat(playerid, "edit_x");
            case 4: float_count = GetPVarFloat(playerid, "edit_y");
            case 5: float_count = GetPVarFloat(playerid, "edit_z");
            case 6: float_count = GetPVarFloat(playerid, "edit_scale");
            case 7: float_count = GetPVarFloat(playerid, "edit_rX");
            case 8: float_count = GetPVarFloat(playerid, "edit_rY");
            case 9: float_count = GetPVarFloat(playerid, "edit_rZ");
        }

        new acs_coords[18];
        format(acs_coords, sizeof acs_coords, "%.3f", float_count);
        PlayerTextDrawSetString(playerid, acss_coords_fix_PTD[playerid][0], acs_coords);
        return true;
    }

    if(clickedid == acss_fix_TD[24] || clickedid == acss_fix_TD[25])
    {
        new Float:x, Float:y, Float:z, Float:scale, Float:Rx, Float:Ry, Float:Rz, acs_coords[18];

        switch(GetPVarInt(playerid, "acss_fix_TD_use"))
        {
            case 1:
            {
                if(clickedid == acss_fix_TD[24]) { x += 0.01; } else { x -= 0.01; }
                format(acs_coords, sizeof acs_coords, "%.3f", GetPVarFloat(playerid, "edit_x") + x);
            }
            case 2:
            {
                if(clickedid == acss_fix_TD[24]) { y += 0.01; } else { y -= 0.01; }
                format(acs_coords, sizeof acs_coords, "%.3f", GetPVarFloat(playerid, "edit_y") + y);
            }
            case 3:
            {
                if(clickedid == acss_fix_TD[24]) { z += 0.01; } else { z -= 0.01; }
                format(acs_coords, sizeof acs_coords, "%.3f", GetPVarFloat(playerid, "edit_z") + z);
            }
            case 4:
            {
                if(clickedid == acss_fix_TD[24]) { scale += 0.05; } else { scale -= 0.05; }
                format(acs_coords, sizeof acs_coords, "%.2f", GetPVarFloat(playerid, "edit_scale") + scale);
            }
            case 5:
            {
                if(clickedid == acss_fix_TD[24]) { Rx += 5.0; } else { Rx -= 5.0; }
                format(acs_coords, sizeof acs_coords, "%.0f", GetPVarFloat(playerid, "edit_rX") + Rx);
            }
            case 6:
            {
                if(clickedid == acss_fix_TD[24]) { Ry += 5.0; } else { Ry -= 5.0; }
                format(acs_coords, sizeof acs_coords, "%.0f", GetPVarFloat(playerid, "edit_rY") + Ry);
            }
            case 7:
            {
                if(clickedid == acss_fix_TD[24]) { Rz += 5.0; } else { Rz -= 5.0; }
                format(acs_coords, sizeof acs_coords, "%.0f", GetPVarFloat(playerid, "edit_rZ") + Rz);
            }
        }

        PlayerTextDrawSetString(playerid, acss_coords_fix_PTD[playerid][0], acs_coords);

        SetPVarFloat(playerid, "edit_x", GetPVarFloat(playerid, "edit_x") + x);
        SetPVarFloat(playerid, "edit_y", GetPVarFloat(playerid, "edit_y") + y);
        SetPVarFloat(playerid, "edit_z", GetPVarFloat(playerid, "edit_z") + z);
        SetPVarFloat(playerid, "edit_rX", GetPVarFloat(playerid, "edit_rX") + Rx);
        SetPVarFloat(playerid, "edit_rY", GetPVarFloat(playerid, "edit_rY") + Ry);
        SetPVarFloat(playerid, "edit_rZ", GetPVarFloat(playerid, "edit_rZ") + Rz);
        SetPVarFloat(playerid, "edit_scale", GetPVarFloat(playerid, "edit_scale") + scale);

        SetPlayerAttachedObject(playerid, g_AccessoryEditorSlot[playerid], accessory[GetPVarInt(playerid, "acs_id")][ID_ACCESSORY], GetPVarInt(playerid, "bone"),
            GetPVarFloat(playerid, "edit_x"), GetPVarFloat(playerid, "edit_y"), GetPVarFloat(playerid, "edit_z"),
            GetPVarFloat(playerid, "edit_rX"), GetPVarFloat(playerid, "edit_rY"), GetPVarFloat(playerid, "edit_rZ"),
            GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"));

        return true;
    }

    return false;
}

stock Accessory_Init()
{
    for(new p = 0; p < MAX_PLAYERS; p++)
    {
        g_AccessoryEditorSlot[p] = -1;
        g_HasAccessoryLoaded[p] = false;
        
        for(new i = 0; i < 1; i++)
        {
            acss_coords_fix_PTD[p][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }

    CreateEditAccessoryTD();

    mysql_query(mysql,
        "CREATE TABLE IF NOT EXISTS `player_accessories` (\
        `account_id` INT NOT NULL, \
        `active_slot` INT NOT NULL, \
        `accessory_id` INT NOT NULL, \
        `bone` INT NOT NULL, \
        `x` FLOAT NOT NULL DEFAULT 0.0, \
        `y` FLOAT NOT NULL DEFAULT 0.0, \
        `z` FLOAT NOT NULL DEFAULT 0.0, \
        `rx` FLOAT NOT NULL DEFAULT 0.0, \
        `ry` FLOAT NOT NULL DEFAULT 0.0, \
        `rz` FLOAT NOT NULL DEFAULT 0.0, \
        `scale` FLOAT NOT NULL DEFAULT 1.0, \
        PRIMARY KEY (`account_id`,`active_slot`))");

    print("[ACCESSORY] system initialized");
    return 1;
}

stock Accessory_GetInventoryItemId(accessoryId)
{
    if(accessoryId < 0 || accessoryId >= sizeof(accessory)) return 0;

    new modelid = accessory[accessoryId][ID_ACCESSORY];
    switch(modelid)
    {
        case 676: return 917;
        case 677: return 918;
        case 787: return 682;
        case 790: return 685;
        case 2655: return 914;
        case 2656: return 915;
        case 2657: return 916;
        case 4160: return 531;
        case 4161: return 532;
        case 4162: return 533;
        case 4163: return 534;
        case 4165: return 536;
        case 4196: return 490;
        case 4197: return 491;
        case 4198: return 492;
        case 4199: return 493;
        case 4200: return 494;
        case 4201: return 495;
        case 4203: return 497;
        case 4204: return 498;
        case 4205: return 499;
        case 4206: return 500;
        case 4207: return 501;
        case 4208: return 502;
        case 7329: return 393;
        case 7330: return 394;
        case 7331: return 395;
        case 7332: return 396;
        case 7333: return 397;
        case 7334: return 398;
        case 7336: return 400;
        case 7337: return 401;
        case 7338: return 402;
        case 7339: return 403;
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
        case 7362: return 426;
        case 7364: return 428;
        case 7367: return 431;
        case 7368: return 432;
        case 7369: return 433;
        case 7370: return 434;
        case 7371: return 435;
        case 7372: return 436;
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
        case 7390: return 454;
        case 7391: return 455;
        case 7392: return 456;
        case 7393: return 457;
        case 7394: return 458;
        case 7395: return 459;
        case 9824: return 660;
        case 9825: return 661;
        case 9826: return 662;
        case 9827: return 663;
        case 9828: return 664;
        case 11919: return 579;
        case 11922: return 582;
        case 11923: return 583;
        case 11925: return 585;
        case 13801: return 576;
        case 13803: return 578;
        case 13883: return 508;
        case 14574: return 509;
        case 14575: return 511;
        case 14589: return 513;
        case 14591: return 515;
        case 14592: return 516;
        case 14593: return 517;
        case 14596: return 520;
        case 14597: return 521;
        case 14598: return 522;
        case 14603: return 527;
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
        case 16055: return 709;
        case 18232: return 169;
        case 18233: return 170;
        case 18243: return 180;
        case 18250: return 187;
        case 18263: return 200;
        case 18264: return 201;
        case 18273: return 210;
        case 18279: return 216;
        case 18285: return 220;
        case 18286: return 221;
        case 18346: return 263;
        case 18347: return 264;
        case 18348: return 265;
        case 18369: return 281;
        case 18375: return 287;
        case 18377: return 289;
        case 18378: return 290;
        case 18379: return 291;
        case 18383: return 295;
        case 18384: return 296;
        case 18385: return 297;
        case 18386: return 298;
        case 18389: return 301;
        case 18390: return 302;
        case 18391: return 303;
        case 18392: return 304;
        case 18396: return 308;
        case 18397: return 309;
        case 18399: return 311;
        case 18400: return 312;
        case 18401: return 313;
        case 18402: return 314;
        case 18403: return 315;
        case 18404: return 316;
        case 18409: return 321;
        case 18410: return 322;
        case 18411: return 323;
        case 18412: return 324;
        case 18414: return 326;
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
    }

    return INVENTORY_ACCESSORY_ITEM_BASE + accessoryId;
}

stock Accessory_GetAccessoryIdByModelia(modelid)
{
    printf("[ACCESSORY] Looking for accessory with model ID: %d", modelid);
    
    
    switch(modelid)
    {
        case 917: return 676;
        case 918: return 677;
        case 682: return 787;
        case 685: return 790;
        case 914: return 2655;
        case 915: return 2656;
        case 916: return 2657;
        case 531: return 4160;
        case 532: return 4161;
        case 533: return 4162;
        case 534: return 4163;
        case 536: return 4165;
        case 490: return 4196;
        case 491: return 4197;
        case 492: return 4198;
        case 493: return 4199;
        case 494: return 4200;
        case 495: return 4201;
        case 497: return 4203;
        case 498: return 4204;
        case 499: return 4205;
        case 500: return 4206;
        case 501: return 4207;
        case 502: return 4208;
        case 393: return 7329;
        case 394: return 7330;
        case 395: return 7331;
        case 396: return 7332;
        case 397: return 7333;
        case 398: return 7334;
        case 400: return 7336;
        case 401: return 7337;
        case 402: return 7338;
        case 403: return 7339;
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
        case 426: return 7362;
        case 428: return 7364;
        case 431: return 7367;
        case 432: return 7368;
        case 433: return 7369;
        case 434: return 7370;
        case 435: return 7371;
        case 436: return 7372;
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
        case 454: return 7390;
        case 455: return 7391;
        case 456: return 7392;
        case 457: return 7393;
        case 458: return 7394;
        case 459: return 7395;
        case 660: return 9824;
        case 661: return 9825;
        case 662: return 9826;
        case 663: return 9827;
        case 664: return 9828;
        case 579: return 11919;
        case 582: return 11922;
        case 583: return 11923;
        case 585: return 11925;
        case 576: return 13801;
        case 578: return 13803;
        case 508: return 13883;
        case 509: return 14574;
        case 511: return 14575;
        case 513: return 14589;
        case 515: return 14591;
        case 516: return 14592;
        case 517: return 14593;
        case 520: return 14596;
        case 521: return 14597;
        case 522: return 14598;
        case 527: return 14603;
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
        case 155: return 15150;
        case 159: return 15151;
        case 151: return 15152;
        case 152: return 15153;
        case 153: return 15154;
        case 154: return 15155;
        case 160: return 15157;
        case 161: return 15158;
        case 158: return 15159;
        case 156: return 15160;
        case 157: return 15161;
        case 709: return 16055;
        case 169: return 18232;
        case 170: return 18233;
        case 180: return 18243;
        case 187: return 18250;
        case 200: return 18263;
        case 201: return 18264;
        case 210: return 18273;
        case 216: return 18279;
        case 220: return 18285;
        case 221: return 18286;
        case 263: return 18346;
        case 264: return 18347;
        case 265: return 18348;
        case 281: return 18369;
        case 287: return 18375;
        case 289: return 18377;
        case 290: return 18378;
        case 291: return 18379;
        case 295: return 18383;
        case 296: return 18384;
        case 297: return 18385;
        case 298: return 18386;
        case 301: return 18389;
        case 302: return 18390;
        case 303: return 18391;
        case 304: return 18392;
        case 308: return 18396;
        case 309: return 18397;
        case 311: return 18399;
        case 312: return 18400;
        case 313: return 18401;
        case 314: return 18402;
        case 315: return 18403;
        case 316: return 18404;
        case 321: return 18409;
        case 322: return 18410;
        case 323: return 18411;
        case 324: return 18412;
        case 326: return 18414;
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
    }
    
    printf("[ACCESSORY] No accessory found for model ID: %d", modelid);
    return -1;
}

stock Accessory_GetAccessoryIdByInventoryId(item_id)
{
    printf("[ACCESSORY] GetAccessoryIdByInventoryId: looking for item_id %d", item_id);
    
    for(new i = 0; i < sizeof(accessory); i++)
    {
        new invId = Accessory_GetInventoryItemId(i);
        if(invId == item_id)
        {
            printf("[ACCESSORY] Found match: accessory index %d (model %d) -> inventory ID %d", 
                i, accessory[i][ID_ACCESSORY], invId);
            return i;
        }
    }
    
    printf("[ACCESSORY] No accessory found for inventory ID %d", item_id);
    return -1;
}

stock bool:Accessory_UseFromInventory(playerid, invSlot)
{
    printf("[ACCESSORY] UseFromInventory: player %d, slot %d", playerid, invSlot);
    
    if(invSlot < 0 || invSlot >= MAX_INVENTORY_SLOTS) 
    {
        printf("[ACCESSORY] Invalid slot");
        return 0;
    }
    
    new itemId = g_PlayerInventory[playerid][invSlot][inv_itemId];
    printf("[ACCESSORY] Item in slot %d: ID %d", invSlot, itemId);
    
    if(itemId == 0) 
    {
        printf("[ACCESSORY] No item in slot");
        return 0;
    }
    
    new accessoryId = -1;
    for(new i = 0; i < sizeof(accessory); i++)
    {
        if(Accessory_GetInventoryItemId(i) == itemId)
        {
            accessoryId = i;
            break;
        }
    }
    
    if(accessoryId == -1)
    {
        printf("[ACCESSORY] No accessory found for inventory ID %d", itemId);
        SendClientMessage(playerid, 0xFF0000FF, "Этот предмет не является аксессуаром.");
        return 0;
    }
    
    printf("[ACCESSORY] accessoryId: %d", accessoryId);
    
    new activeSlot = -1;
    for(new s = 2; s <= 9; s++)
    {
        if(!IsPlayerAttachedObjectSlotUsed(playerid, s))
        {
            activeSlot = s;
            printf("[ACCESSORY] Found free active slot: %d", s);
            break;
        }
    }
    
    if(activeSlot == -1) 
    {
        SendClientMessage(playerid, 0xFF0000FF, "Нет свободных активных слотов для аксессуара.");
        return 0;
    }
    
    new bone = accessory[accessoryId][BONE_ACCESSORY];
    new modelid = accessory[accessoryId][ID_ACCESSORY];
    printf("[ACCESSORY] Bone: %d, Model: %d", bone, modelid);
    
    new plateStr[16];
    format(plateStr, sizeof(plateStr), "%d", accessoryId);
    
    if(!SetPlayerAttachedObject(playerid, activeSlot, modelid, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0))
    {
        printf("[ACCESSORY] Failed to attach object");
        SendClientMessage(playerid, 0xFF0000FF, "Ошибка при надевании аксессуара.");
        return 0;
    }
    printf("[ACCESSORY] SetPlayerAttachedObject successful");
    
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = itemId;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = 1;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemSlot] = activeSlot;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemActive] = true;
    g_PlayerActiveSlots[playerid][activeSlot][inv_activeSlot] = activeSlot;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemType] = GetItemType(itemId);
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemWeight] = GetItemWeight(itemId);
    GetItemName(itemId, g_PlayerActiveSlots[playerid][activeSlot][inv_itemName], 64);
    format(g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate], 32, "%s", plateStr);
    
    printf("[ACCESSORY] Active slot data saved");
    
    Inventory_DeleteSlot(playerid, invSlot);
    printf("[ACCESSORY] Item deleted from inventory");
    
    SetPVarInt(playerid, "acs_id_in_slot", accessoryId);
    printf("[ACCESSORY] PVar set: acs_id_in_slot = %d", accessoryId);
    
    HidePlayerGUI(playerid, 33);
    printf("[ACCESSORY] Inventory hidden");
    
    printf("[ACCESSORY] Calling Accessory_StartEditor for slot %d", activeSlot);
    Accessory_StartEditor(playerid, activeSlot);
    
    SendClientMessage(playerid, 0x66CC33FF, "Аксессуар надет. Используйте кнопки для редактирования.");
    
    return 1;
}

forward DelayedStartEditor(playerid, activeSlot);
public DelayedStartEditor(playerid, activeSlot)
{
    if(!IsPlayerConnected(playerid)) return 0;
    printf("[ACCESSORY] DelayedStartEditor: starting for slot %d", activeSlot);
    Accessory_StartEditor(playerid, activeSlot);
    return 1;
}

stock Accessory_UnequipToInventory(playerid, activeSlot)
{
    if(activeSlot < MIN_ACCESSORY_SLOT || activeSlot > MAX_ACCESSORY_SLOT) 
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ошибка: неверный слот");
        return 0;
    }
    
    if(g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] == 0) 
    {
        SendClientMessage(playerid, 0xFF0000FF, "В этом активном слоте нет предмета");
        return 0;
    }
    
    new itemId = g_PlayerActiveSlots[playerid][activeSlot][inv_itemId];
    new count = g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount];
    new plate[32];
    format(plate, sizeof(plate), "%s", g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate]);
    
    new accessoryId = -1;
    if(plate[0] != 0)
    {
        accessoryId = strval(plate);
    }
    
    new freeSlot = Inventory_GetFreeSlot(playerid);
    if(freeSlot == -1)
    {
        SendClientMessage(playerid, 0xFF0000FF, "Нет свободных слотов в инвентаре!");
        return 0;
    }
    
    Inventory_AddItem(playerid, itemId, freeSlot, count, "");
    
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemId] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemCount] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemPlate][0] = 0;
    g_PlayerActiveSlots[playerid][activeSlot][inv_itemActive] = false;
    g_PlayerActiveSlots[playerid][activeSlot][inv_activeSlot] = -1;
    
    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "DELETE FROM `player_inventory` WHERE `player_id` = %d AND `active_slot` = %d AND `is_active` = 1",
        GetPlayerAccountID(playerid), activeSlot);
    mysql_query(mysql, query, false);
    
    if(IsPlayerAttachedObjectSlotUsed(playerid, activeSlot))
    {
        RemovePlayerAttachedObject(playerid, activeSlot);
    }
    
    if(GetPlayerAccountID(playerid) > 0 && accessoryId != -1)
    {
        new q[160];
        mysql_format(mysql, q, sizeof(q),
            "DELETE FROM `player_accessories` WHERE `account_id` = %d AND `active_slot` = %d",
            GetPlayerAccountID(playerid), activeSlot);
        mysql_query(mysql, q, false);
    }
    
    DeletePVar(playerid, "acs_id_in_slot");
    
    ShowPlayerInventory(playerid);
    
    SendClientMessage(playerid, 0x66CC33FF, "Аксессуар снят и перемещен в инвентарь.");
    
    return 1;
}
stock Accessory_OnInventoryLoaded(playerid)
{
    for(new s = 2; s < MAX_ACTIVE_SLOTS; s++)
    {
        if(GetItemType(g_PlayerActiveSlots[playerid][s][inv_itemId]) == ITEM_TYPE_ACCESSORY)
        {
            new acs = -1;
    if(g_PlayerActiveSlots[playerid][s][inv_itemPlate][0] != 0) acs = strval(g_PlayerActiveSlots[playerid][s][inv_itemPlate]);
    if(acs < 0 || acs >= sizeof(accessory)) acs = Inv_GetAccIdByItem(g_PlayerActiveSlots[playerid][s][inv_itemId]);
    if(acs < 0 || acs >= sizeof(accessory)) acs = g_PlayerActiveSlots[playerid][s][inv_itemCount];
            if(acs >= 0 && acs < sizeof(accessory))
                Accessory_LoadAndApplySlot(playerid, s, acs);
        }
        else
        {
            if(IsPlayerAttachedObjectSlotUsed(playerid, s))
                RemovePlayerAttachedObject(playerid, s);
        }
    }
    return 1;
}
