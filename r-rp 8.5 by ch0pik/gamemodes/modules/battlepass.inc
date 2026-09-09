#if defined _battlepass_included
    #endinput
#endif
#define _battlepass_included

#define PRICE_BATTLEPASS 1200
#define MAX_BATTLEPASS_PRIZES 135
#define PRICE_BATTLEPASS_LVL1 2000
#define PRICE_BATTLEPASS_LVL2 5700
#define PRICE_BATTLEPASS_LVL3 12600
#define MAX_BP_TASKS 12
#define MAX_BP_STORE 3
#define Update t_CefUpdate
#define SUCCESS 1

new PlayerBP_KD[MAX_PLAYERS][MAX_BATTLEPASS_PRIZES];
new kd_bp[] = {6,34,49,68,79,84,99,110,127};
new store_flag_bp[MAX_PLAYERS][MAX_BP_STORE];

enum S_BATTLEPASS_TASKS_STRUCT
{
	BP_TYPE_TASKS,
    BP_NAME_TASKS[32],
    BP_TASKS[124],
    BP_POINT,
    BP_PRIZE,
    BP_DONATE_PRICE,
	BP_PRIZE_GOLDS,
}
new g_battlepass_tasks[87][S_BATTLEPASS_TASKS_STRUCT] =
{
    {0, "Пора новых ощущений", "Купите транспорт в любом автосалоне 1 раз(а)", 1, 20, 170, 2},
	{1, "Дело мастера боится", "Соберите 54 шт. изделий, работая на заводе по производству продуктов", 54, 30, 170, 3},
	{2, "Игромания", "Выиграть в рулетке поставив на любой сектор 20 раз(а)", 20, 20, 170, 3},
	{3, "Удача на нашей стороне", "Открыть 30 кейсов любого вида", 30, 20, 170, 4},
	{4, "Чувство азарта", "Поучавствуйте в лотерее 20 раз(а)", 20, 20, 170, 2},
	{5, "Филантроп", "Пожертвуйте 110.300.000 руб. в благотворительность", 110300000, 20, 170, 4},
	{6, "Всего лишь пару царапин", "Почините транспорт с помощью рем. комплекта 5 раз", 5, 10, 170, 2},
	{7, "День стиля", "Купите новый аксессуар в магазине аксессуаров 1 раз(а)", 1, 30, 170, 2},
	{8, "Самое время для зарплат", "Получите PayDay 2 раз(а)", 2, 20, 170, 2},
	{9, "Аукцион удачи", "Выиграйте в аукционе контейнеров 15 раз(а)", 15, 20, 170, 3},
	{10, "Нужно делиться", "Передайте любую сумму другому игроку (/pay) 5 раз(а)", 5, 20, 170, 2},
	{11, "Полный бак, пожалуйста", "Заправьте транспорт на АЗС на 32 л. топлива", 32, 20, 170, 2}, 
	{12, "Я каменщик работаю три дня", "Добудьте 117 кг. руды, работая на шахте", 117, 20, 170, 2},
	{13, "Время администрации", "Задайте вопрос администрации 1 раз(а)", 1, 10, 170, 2},
	{14, "Пора бы приодеться", "Купите новую одежду в одном из магазинов одежды", 1, 10, 170, 2},
	{15, "Мастер на все руки", "Соберите рецепт для крафта 1 раз(а)", 1, 20, 170, 4},
	{16, "Ликвидация", "Победите в аукционе на свалке 5 раз(а)", 5, 20, 170, 3},
	{17, "Водитель со стажем", "Отвезите продукты работая Дальнобойщиком 5 раз(а)", 5, 20, 170, 3},
	{18, "Это наш день", "Сыграйте в кости и выиграйте 10 раз(а)", 10, 30, 170, 2},
	{19, "Детектив", "Найдите кейсы разбросаные по всей обл. 5 раз(а)", 5, 40, 170, 2},
	{20, "Не опущена а занижена", "Воспользуйте /spanel 5 раз(а)", 5, 10, 170, 2},
	{21, "Бункер", "Установите тонировку на свой автомобиль 1 раз(а)", 1, 20, 170, 2},
	{22, "Самый быстрый", "Поучаствуйте в драг рейсинге 5 раз(а)", 5, 20, 170, 4},
	{23, "Законопослушный гражданин", "Оплатите штраф в любом банкомате 5 раз(а)", 5, 20, 170, 2},
	{24, "Сезон огородов начался", "Соберите 58 ед. урожая с огорода", 58, 10, 170, 2},
	{25, "Удача любит рисковых", "Откройте кейс `Темные дела` 20 раз(а)", 20, 30, 170, 4},
	{26, "Удача любит рисковых", "Откройте кейс `Велесова ночь` 20 раз(а)", 20, 30, 170, 4},
	{27, "Где моя тачька?", "Заберите автомобиль со штрафстоянки 1 раз", 1, 15, 170, 1},
	{28, "Хай", "Поздоровайтесь с игроками 5 раз(а)", 5, 10, 170, 1},
	{0, "Пора новых ощущений", "Купите транспорт в любом автосалоне 2 раз(а)", 2, 20, 170, 2},
	{1, "Дело мастера боится", "Соберите 78 шт. изделий, работая на заводе по производству продуктов", 78, 35, 170, 3},
	{2, "Игромания", "Выиграть в рулетке поставив на любой сектор 10 раз(а)", 10, 20, 170, 2},
	{3, "Удача на нашей стороне", "Открыть 50 кейсов любого вида", 50, 30, 170, 4},
	{4, "Чувство азарта", "Поучавствуйте в лотерее 30 раз(а)", 30, 20, 170, 3},
	{5, "Филантроп", "Пожертвуйте 160.900.000 руб. в благотворительность", 160900000, 20, 170, 3},
	{6, "Всего лишь пару царапин", "Почините транспорт с помощью рем. комплекта 10 раз", 10, 20, 170, 3},
	{7, "День стиля", "Купите новый аксессуар в магазине аксессуаров 2 раз(а)", 2, 30, 170, 2},
	{8, "Самое время для зарплат", "Получите PayDay 4 раз(а)", 4, 30, 170, 3},
	{9, "Аукцион удачи", "Выиграйте в аукционе контейнеров 30 раз(а)", 30, 30, 170, 4},
	{10, "Нужно делиться", "Передайте любую сумму другому игроку (/pay) 10 раз(а)", 10, 30, 170, 3},
	{11, "Полный бак, пожалуйста", "Заправьте транспорт на АЗС на 64 л. топлива", 64, 30, 170, 2}, 
	{12, "Я каменщик работаю три дня", "Добудьте 145 кг. руды, работая на шахте", 145, 20, 170, 2},
	{13, "Время администрации", "Задайте вопрос администрации 2 раз(а)", 2, 10, 170, 1},
	{14, "Пора бы приодеться", "Купите новую одежду в одном из магазинов одежды", 1, 10, 170, 2},
	{15, "Мастер на все руки", "Соберите рецепт для крафта 2 раз(а)", 2, 20, 170, 4},
	{16, "Ликвидация", "Победите в аукционе на свалке 10 раз(а)", 10, 20, 170, 2},
	{17, "Водитель со стажем", "Отвезите продукты работая Дальнобойщиком 10 раз(а)", 10, 30, 170, 2},
	{18, "Это наш день", "Сыграйте в кости и выиграйте 20 раз(а)", 20, 30, 170, 2},
	{19, "Детектив", "Найдите кейсы разбросаные по всей обл. 10 раз(а)", 10, 40, 170, 3},
	{20, "Не опущена а занижена", "Воспользуйте /spanel 10 раз(а)", 10, 10, 170, 2},
	{21, "Бункер", "Установите тонировку на свой автомобиль 2 раз(а)", 2, 20, 170, 2},
	{22, "Самый быстрый", "Поучаствуйте в драг рейсинге 15 раз(а)", 15, 20, 170, 3},
	{23, "Законопослушный гражданин", "Оплатите штраф в любом банкомате 10 раз(а)", 10, 30, 170, 2},
	{24, "Сезон огородов начался", "Соберите 76 ед. урожая с огорода", 76, 20, 170, 2},
	{25, "Удача любит рисковых", "Откройте кейс `Темные дела` 30 раз(а)", 30, 30, 170, 3},
	{26, "Удача любит рисковых", "Откройте кейс `Велесова ночь` 30 раз(а)", 30, 30, 170, 3},
	{27, "Где моя тачька?", "Заберите автомобиль со штрафстоянки 2 раз(а)", 2, 30, 170, 2},
	{28, "Хай", "Поздоровайтесь с игроками 15 раз(а)", 15, 20, 170, 2},
	{0, "Пора новых ощущений", "Купите транспорт в любом автосалоне 3 раз(а)", 3, 30, 170, 3},
	{1, "Дело мастера боится", "Соберите 114 шт. изделий, работая на заводе по производству продуктов", 114, 40, 170, 3},
	{2, "Игромания", "Выиграть в рулетке поставив на любой сектор 45 раз(а)", 45, 30, 170, 3},
	{3, "Удача на нашей стороне", "Открыть 90 кейсов любого вида", 90, 40, 170, 4},
	{4, "Чувство азарта", "Поучавствуйте в лотерее 40 раз(а)", 40, 40, 170, 3},
	{5, "Филантроп", "Пожертвуйте 209.100.000 руб. в благотворительность", 209100000, 40, 170, 4},
	{6, "Всего лишь пару царапин", "Почините транспорт с помощью рем. комплекта 15 раз", 15, 30, 170, 3},
	{7, "День стиля", "Купите новый аксессуар в магазине аксессуаров 3 раз(а)", 3, 30, 170, 3},
	{8, "Самое время для зарплат", "Получите PayDay 6 раз(а)", 6, 60, 170, 3},
	{9, "Аукцион удачи", "Выиграйте в аукционе контейнеров 50 раз(а)", 50, 40, 170, 3},
	{10, "Нужно делиться", "Передайте любую сумму другому игроку (/pay) 15 раз(а)", 15, 40, 170, 2},
	{11, "Полный бак, пожалуйста", "Заправьте транспорт на АЗС на 128 л. топлива", 128, 40, 170, 2}, 
	{12, "Я каменщик работаю три дня", "Добудьте 210 кг. руды, работая на шахте", 210, 20, 170, 2},
	{13, "Время администрации", "Задайте вопрос администрации 3 раз(а)", 3, 10, 170, 2},
	{14, "Пора бы приодеться", "Купите новую одежду в одном из магазинов одежды", 1, 10, 170, 2},
	{15, "Мастер на все руки", "Соберите рецепт для крафта 3 раз(а)", 3, 30, 170, 3},
	{16, "Ликвидация", "Победите в аукционе на свалке 15 раз(а)", 15, 30, 170, 4},
	{17, "Водитель со стажем", "Отвезите продукты работая Дальнобойщиком 15 раз(а)", 15, 30, 170, 4},
	{18, "Это наш день", "Сыграйте в кости и выиграйте 30 раз(а)", 30, 30, 170, 4},
	{19, "Детектив", "Найдите кейсы разбросаные по всей обл. 15 раз(а)", 15, 40, 170, 4},
	{20, "Не опущена а занижена", "Воспользуйте /spanel 15 раз(а)", 15, 10, 170, 2},
	{21, "Бункер", "Установите тонировку на свой автомобиль 3 раз(а)", 3, 20, 170, 3},
	{22, "Самый быстрый", "Поучаствуйте в драг рейсинге 25 раз(а)", 25, 20, 170, 4},
	{23, "Законопослушный гражданин", "Оплатите штраф в любом банкомате 20 раз(а)", 20, 30, 170, 2},
	{24, "Сезон огородов начался", "Соберите 94 ед. урожая с огорода", 94, 30, 170, 3},
	{25, "Удача любит рисковых", "Откройте кейс `Темные дела` 40 раз(а)", 40, 30, 170, 4},
	{26, "Удача любит рисковых", "Откройте кейс `Велесова ночь` 40 раз(а)", 40, 30, 170, 4},
	{27, "Где моя тачька?", "Заберите автомобиль со штрафстоянки 3 раз(а)", 3, 45, 170, 3},
	{28, "Хай", "Поздоровайтесь с игроками 17 раз(а)", 17, 30, 170, 3}
};

enum S_BATTLEPASS_PRIZE_STRUCT
{
    BP_PRIZE_ID,
    BP_PRIZE_NAME[48],
    BP_PRIZE_PREMIUM,
    BP_PRIZE_TYPE,
    BP_PRIZE_ITEM_ID,
    BP_PRIZE_COUNT,
    BP_PRIZE_INDX,
	BP_PRIZE_EXP
}
enum E_BP_STORE
{
    store_type, 
    store_model,
    store_param1,
    store_param2,
    store_name[64],
    store_price,
    store_amount
};

new g_battlepass_store[MAX_BP_STORE][E_BP_STORE] =
{
    {4, 284,    0,  0,  "Борат стиль 2",     1400, 1},
    {4, 15324,  0,  0,  "Мистер Бизнес",     2800, 1},
    {3, 17426,  0, -1,  "Porsche 911/993 RWB", 4500, 1}
};

enum
{
	BATTLEPASS_PRIZE_ITEM, //0
	BATTLEPASS_PRIZE_SKIN, //1
	BATTLEPASS_PRIZE_DONATE, //2
	BATTLEPASS_PRIZE_EXP, //3
	BATTLEPASS_PRIZE_ACS, //4
	BATTLEPASS_PRIZE_VIP, //5
	BATTLEPASS_PRIZE_CAR, //6
	BATTLEPASS_PRIZE_MONEY, //7 
	BATTLEPASS_PRIZE_CASE, //8
	BATTLEPASS_PRIZE_GOLD, //9
	BATTLEPASS_PRIZE_ANIM, //10
	BATTLEPASS_PRIZE_VB, //11
	BATTLEPASS_PRIZE_MEDCARTA, // Мед карта
	BATTLEPASS_PRIZE_PACKN4,
	BATTLEPASS_PRIZE_PACK1,
	BATTLEPASS_PRIZE_PACK2,
	BATTLEPASS_PRIZE_PACK3,
	BATTLEPASS_PRIZE_PACK4,
	BATTLEPASS_PRIZE_PACK5,
	BATTLEPASS_PRIZE_PACK6,
	BATTLEPASS_PRIZE_PACK7,
	BATTLEPASS_PRIZE_PACK8,
	BATTLEPASS_PRIZE_PACK_FERMA,
}

enum {
	BP_FREE,
  	BP_PREMIUM,
}
new g_battlepass_prize[MAX_BATTLEPASS_PRIZES][S_BATTLEPASS_PRIZE_STRUCT] ={
	{0, "Деньги 25.000", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 25000, 0, 5},
	{1, "", BP_PREMIUM, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{2, "", BP_PREMIUM, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{3, "", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 0, 0, 5},
	{4, "Пак №1", BP_PREMIUM, BATTLEPASS_PRIZE_PACKN4, 0, 1, 0, 50}, // пак
	{5, "Лотерейный билет", BP_FREE, BATTLEPASS_PRIZE_ITEM, 257, 1, 0, 5},
	{6, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 1000000, 0, 10},
	{7, "Ремонтный комплект", BP_FREE, BATTLEPASS_PRIZE_ITEM, 44, 1, 0, 3},
	{8, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 100, 0, 15},
	{9, "Тряпка", BP_FREE, BATTLEPASS_PRIZE_ITEM, 138, 1, 0, 3},
	{10, "15 донат-монет", BP_PREMIUM, BATTLEPASS_PRIZE_DONATE, 0, 15, 0, 3},
	{11, "Игральные фишки 50 шт", BP_FREE, BATTLEPASS_PRIZE_ITEM, 293, 50, 0, 3},
	{12, "Открытия кейса Египетская сила", BP_PREMIUM, BATTLEPASS_PRIZE_CASE, 8, 1, 0, 35},
	{13, "Аптечка", BP_FREE, BATTLEPASS_PRIZE_ITEM, 2, 1, 0, 3},
	{14, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 500000, 0, 10},
	{15, "Сварка", BP_FREE, BATTLEPASS_PRIZE_ITEM, 154, 1, 0, 3},
	{16, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 25, 0, 15},
	{17, "Чертеж для Болгарки", BP_FREE, BATTLEPASS_PRIZE_ITEM, 370, 1, 0, 5},
	{18, "25 донат-монет", BP_PREMIUM, BATTLEPASS_PRIZE_DONATE, 0, 25, 0, 3},
	{19, "Домкрат", BP_FREE, BATTLEPASS_PRIZE_ITEM, 361, 1, 0, 5},
	{20, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 20, 0, 15},
	{21, "Игральные фишки 35 шт", BP_FREE, BATTLEPASS_PRIZE_ITEM, 293, 35, 0, 3},
	{22, "Анимация Глубокий дэб", BP_PREMIUM, BATTLEPASS_PRIZE_ANIM, 1523, 1, 0, 25},
	{23, "Прицел", BP_FREE, BATTLEPASS_PRIZE_ITEM, 146, 1, 0, 3},
	{24, "25 донат-монет", BP_PREMIUM, BATTLEPASS_PRIZE_DONATE, 0, 25, 0, 3},
	{25, "", BP_FREE, BATTLEPASS_PRIZE_PACK1, 0, 0, 0, 5},
	{26, "Пак №2", BP_FREE, BATTLEPASS_PRIZE_PACK1, 0, 1, 0, 50},
	{27, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 550000, 0, 10},
	{28, "Лотерейный билет", BP_FREE, BATTLEPASS_PRIZE_ITEM, 257, 1, 0, 5},
	{29, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 25, 0, 15},
	{30, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{31, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{32, "Пак №3", BP_FREE, BATTLEPASS_PRIZE_PACK_FERMA, 0, 0, 0, 25},
	{33, "Открытия кейса Путь воина", BP_PREMIUM, BATTLEPASS_PRIZE_CASE, 11, 1, 0, 35},
	{34, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 300000, 0, 10},
	{35, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 50, 0, 15},
	{36, "Сертификат на спил пружин", BP_FREE, BATTLEPASS_PRIZE_ITEM, 373, 1, 3, 3},
	{37, "Аксессуар Клюв", BP_PREMIUM, BATTLEPASS_PRIZE_ACS, 18183, 1, 183, 20},
	{38, "Лотерейный билет", BP_FREE, BATTLEPASS_PRIZE_ITEM, 257, 1, 0, 5},
	{39, "Запчасти к рулю амг", BP_PREMIUM, BATTLEPASS_PRIZE_ITEM, 190, 1, 0, 5},
	{40, "Броне пластина", BP_FREE, BATTLEPASS_PRIZE_ITEM, 323, 1, 0, 5},
	{41, "Аксессуар Острый козырек", BP_PREMIUM, BATTLEPASS_PRIZE_ACS, 18202, 1, 184, 20},
	{42, "Игральные фишки", BP_FREE, BATTLEPASS_PRIZE_ITEM, 293, 40, 0, 3},
	{43, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 50, 0, 15},
	{44, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 350000, 0, 10},
	{45, "Открытия кейса Бандитский", BP_PREMIUM, BATTLEPASS_PRIZE_CASE, 15, 1, 0, 35},
	{46, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{47, "Пак №4", BP_FREE, BATTLEPASS_PRIZE_PACK2, 0, 0, 0, 25},
	{48, "Daewoo Damas", BP_PREMIUM, BATTLEPASS_PRIZE_CAR, 15198, 0, 0, 25},
	{49, "Еликсир точности", BP_FREE, BATTLEPASS_PRIZE_ITEM, 273, 1, 0, 3},
	{50, "20 донат-монет", BP_PREMIUM, BATTLEPASS_PRIZE_DONATE, 0, 20, 0, 3},
	{51, "Аккумулятор", BP_FREE, BATTLEPASS_PRIZE_ITEM, 156, 40, 0, 3},
	{52, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 50, 0, 15},
	{53, "Ремонтный комплект", BP_FREE, BATTLEPASS_PRIZE_ITEM, 44, 1, 0, 3},
	{54, "Аксессуар на транспорт Багажник", BP_PREMIUM, BATTLEPASS_PRIZE_ACS, 18201, 1, 285, 20},
	{55, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 400000, 0, 10},
	{56, "Внешность Мужика из 90-х", BP_PREMIUM, BATTLEPASS_PRIZE_SKIN, 9219, 1, 0, 10},
	{57, "Сертификат на стейдж -50%", BP_FREE, BATTLEPASS_PRIZE_ITEM, 373, 1, 2, 3},
	{58, "30 донат-монет", BP_PREMIUM, BATTLEPASS_PRIZE_DONATE, 0, 30, 0, 3},
	{59, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 450000, 0, 10},
	{60, "Аксессуар Мусорный пакет LV", BP_PREMIUM, BATTLEPASS_PRIZE_ACS, 18204, 1, 222, 20},
	{61, "Лотерейный билет", BP_FREE, BATTLEPASS_PRIZE_ITEM, 257, 1, 0, 5},
	{62, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 75, 0, 15},
	{63, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 4000000, 0, 10},
	{64, "Игральные фишки", BP_PREMIUM, BATTLEPASS_PRIZE_ITEM, 293, 50, 0, 3},
	{65, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{66, "Пак №5", BP_FREE, BATTLEPASS_PRIZE_PACK3, 0, 0, 0, 25},
	{67, "Открытия кейса Охотничий", BP_PREMIUM, BATTLEPASS_PRIZE_CASE, 7, 1, 0, 35},
	{68, "Автосигнализация", BP_FREE, BATTLEPASS_PRIZE_ITEM, 256, 1, 0, 5},
	{69, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 75, 0, 15},
	{70, "Броне пластина", BP_FREE, BATTLEPASS_PRIZE_ITEM, 323, 1, 0, 5},
	{71, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 4500000, 0, 10},// тут енот для дома
	{72, "Ремонтный комплект", BP_FREE, BATTLEPASS_PRIZE_ITEM, 44, 1, 0, 3},
	{73, "Сертификат на колесо фортуны", BP_PREMIUM, BATTLEPASS_PRIZE_ITEM, 373, 1, 1, 3},
	{74, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{75, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{76, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{77, "Пак №6", BP_FREE, BATTLEPASS_PRIZE_PACK4, 0, 0, 0, 25},
	{78, "Открытия кейса Темные дела", BP_PREMIUM, BATTLEPASS_PRIZE_CASE, 2, 1, 0, 35},
	{79, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 5500000, 0, 10},// тут сертификат на равито
	{80, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 75, 0, 15},
	{81, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{82, "Пак №7", BP_FREE, BATTLEPASS_PRIZE_PACK5, 0, 0, 0, 25},
	{83, "Внешность Баскетболист", BP_PREMIUM, BATTLEPASS_PRIZE_SKIN, 15503, 1, 0, 10},
	{84, "Игральные фишки 50 шт", BP_FREE, BATTLEPASS_PRIZE_ITEM, 293, 50, 0, 3},
	{85, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 500000, 0, 10},
	{86, "Глушилка для сигнализации", BP_FREE, BATTLEPASS_PRIZE_ITEM, 377, 1, 0, 3},
	{87, "Аксессуар Котик на плечо", BP_PREMIUM, BATTLEPASS_PRIZE_ACS, 18203, 1, 246, 20},
	{88, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 1000000, 0, 10}, // Вместо личного х2
	{89, "30 донат-монет", BP_PREMIUM, BATTLEPASS_PRIZE_DONATE, 0, 30, 0, 3},
	{90, "Еликсир точности", BP_FREE, BATTLEPASS_PRIZE_ITEM, 273, 1, 0, 3},
	{91, "Открытия кейса Форсаж", BP_PREMIUM, BATTLEPASS_PRIZE_CASE, 1, 1, 0, 35},
	{92, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 5500000, 0, 10},
	{93, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 100, 0, 15},
	{94, "Тряпка", BP_FREE, BATTLEPASS_PRIZE_ITEM, 138, 1, 0, 3},
	{95, "Бронижилет Спасательный", BP_PREMIUM, BATTLEPASS_PRIZE_ACS, 18205, 1, 277, 20},
	{96, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{97, "Пак №8", BP_FREE, BATTLEPASS_PRIZE_PACK6, 0, 0, 0, 25},
	{98, "Рецепт для пошива", BP_PREMIUM, BATTLEPASS_PRIZE_ITEM, 332, 1, 0, 3},
	{99, "Мед карта", BP_FREE, BATTLEPASS_PRIZE_MEDCARTA, 0, 1, 0, 5},
	{100, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 1500000, 0, 10}, // Вместо личного х3
	{101, "Сертификат на -50% для установки пневмы", BP_FREE, BATTLEPASS_PRIZE_ITEM, 373, 1, 4, 3},
	{102, "BMW M6 F12", BP_PREMIUM, BATTLEPASS_PRIZE_CAR, 15197, 0, 0, 25},
	{103, "15 донат-монет", BP_FREE, BATTLEPASS_PRIZE_DONATE, 0, 15, 0, 3},
	{104, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 6000000, 0, 10},
	{105, "Ремонтный комплект", BP_FREE, BATTLEPASS_PRIZE_ITEM, 44, 1, 0, 3},
	{106, "30 донат-монет", BP_PREMIUM, BATTLEPASS_PRIZE_DONATE, 0, 30, 0, 3},
	{107, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{108, "Пак №9", BP_FREE, BATTLEPASS_PRIZE_PACK7, 0, 0, 0, 25},
	{109, "Внешность Грибы", BP_PREMIUM, BATTLEPASS_PRIZE_SKIN, 9217, 1, 0, 10},
	{110, "Лотерейный билет", BP_FREE, BATTLEPASS_PRIZE_ITEM, 257, 1, 0, 5},
	{111, "VIP GOLD (7 дней)", BP_PREMIUM, BATTLEPASS_PRIZE_VIP, 2, 1, 7, 5},
	{112, "Деньги", BP_FREE, BATTLEPASS_PRIZE_MONEY, 0, 6500000, 0, 10},
	{113, "Открытия кейса Черное золото", BP_PREMIUM, BATTLEPASS_PRIZE_CASE, 6, 1, 0, 35},
	{114, "Сабвуфер", BP_FREE, BATTLEPASS_PRIZE_ITEM, 180, 1, 0, 5},
	{115, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 100, 0, 15},
	{116, "Игральные фишки 50 шт", BP_FREE, BATTLEPASS_PRIZE_ITEM, 293, 50, 0, 3},
	{117, "Анимация Мощное сальто", BP_PREMIUM, BATTLEPASS_PRIZE_ANIM, 1597, 1, 0, 25},
	{118, "Двигатель", BP_FREE, BATTLEPASS_PRIZE_ITEM, 188, 1, 0, 5},
	{119, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 5500000, 0, 10},// тут сертификат на дзвонок информатора
	{120, "Лотерейный билет", BP_FREE, BATTLEPASS_PRIZE_ITEM, 257, 1, 0, 5},
	{121, "Внешность Билли Айлиш", BP_PREMIUM, BATTLEPASS_PRIZE_SKIN, 9218, 1, 0, 10},
	{122, "Броне пластина", BP_FREE, BATTLEPASS_PRIZE_ITEM, 323, 1, 0, 5},
	{123, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 700000, 0, 10},
	{124, "", BP_FREE, BATTLEPASS_PRIZE_ITEM, 0, 1, 0, 5},
	{125, "Пак №10", BP_FREE, BATTLEPASS_PRIZE_PACK8, 0, 0, 0, 25},
	{126, "Золотой слиток", BP_PREMIUM, BATTLEPASS_PRIZE_GOLD, 0, 100, 0, 15},
	{127, "Игральные фишки 50 шт", BP_FREE, BATTLEPASS_PRIZE_ITEM, 293, 50, 0, 3},
	{128, "Военый билет", BP_PREMIUM, BATTLEPASS_PRIZE_VB, 0, 1, 0, 25},
	{129, "Ремонтный комплект", BP_FREE, BATTLEPASS_PRIZE_ITEM, 44, 1, 0, 3},
	{130, "35 донат-монет", BP_PREMIUM, BATTLEPASS_PRIZE_DONATE, 0, 35, 0, 3},
	{131, "Еликсир точности", BP_FREE, BATTLEPASS_PRIZE_ITEM, 273, 1, 0, 3},
	{132, "Деньги", BP_PREMIUM, BATTLEPASS_PRIZE_MONEY, 0, 1000000, 0, 15},
	{133, "Сертификат на контейнера", BP_FREE, BATTLEPASS_PRIZE_ITEM, 373, 1, 0, 3},
	{134, "Porse 718 Spyder RP", BP_PREMIUM, BATTLEPASS_PRIZE_CAR, 15196, 0, 0, 25}
};	

new g_battlepass_level[59] = {0,1,3,5,7,9,11,13,15,17,19,21,23,25,27,29,31,33,35,37,39,41,43,45,47,49,51,53,55,57,59,61,63,65,67,69,71,73,75,77,79,81,83,85,87,89,91,93,95,97,99,101,103,105,107,109,111,113,115};

new g_battlepass_time_bonus[MAX_PLAYERS];

new g_battlepass_id_tasks[MAX_PLAYERS][MAX_BP_TASKS];
new g_battlepass_id_point[MAX_PLAYERS][MAX_BP_TASKS];

enum S_BATTLEPASS_LEVEL
{
	L_ID,
	L_COUNT,
	L_PRICE,
}

new g_battlepass_buylevel[3][S_BATTLEPASS_LEVEL] =
{
	{0, 5, PRICE_BATTLEPASS_LVL1},
	{1, 15, PRICE_BATTLEPASS_LVL2},
	{2, 35, PRICE_BATTLEPASS_LVL3}
};

public: BPd_OnPlayerBuyItem(playerid, event)
{
    new player_golds = GetPlayerData(playerid, P_BP_GOLDS);

    new price = g_battlepass_store[event][store_price];
    new model = g_battlepass_store[event][store_model];

    if(player_golds < price) return SendClientEvent(playerid, Update, "interface(\"MainMenu\").onServerModalResponse([1, \"Недостаточно коинов\"])");
    
    AddPlayerData(playerid, P_BP_GOLDS, -, price);

    store_flag_bp[playerid][event] = 1;

    SendClientEvent(playerid, Update, "interface(\"MainMenu\").onServerModalResponse([0, \"0\"])");

    static query[128];
    mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET bp_store_%d=1 WHERE id=%d LIMIT 1", event+1, GetPlayerAccountID(playerid));
    mysql_pquery(mysql, query);

    switch(g_battlepass_store[event][store_type]){
        case 3: GivePlayerMyPrizes(playerid, g_battlepass_store[event][store_name], 3, model, 0, 1, -1);
        case 4: GivePlayerMyPrizes(playerid, g_battlepass_store[event][store_name], 4, model, 0, 1, 0);
    }
    GameText(playerid, "~g~Успешно", 2000, 1);
    InterfaceBattlepass(playerid);
    return SUCCESS;
}

public: BPd_OnPlayerBuyPremium(playerid){
    if(GetPlayerCurrentDonate(playerid) < PRICE_BATTLEPASS) {
		SendClientMessage(playerid, -1, "{eec702}У вас недостаточно донат валюты для покупки");
		return GameText(playerid, "~r~У вас недостаточно~n~~w~донат валюты для покупки", 4000, 3);
	}

    GivePlayerDonate(playerid, -PRICE_BATTLEPASS, "Покупка battlepass");

    SetPlayerData(playerid, P_BP_PREMIUM, 1);

	AddPlayerAchiv(playerid, 23);

	SendClientEvent(playerid, Update, "interface('MainMenu').openCelebrationModal([1, [[]]])");

    UpdatePlayerDatabaseInt(playerid, "bp_premium", GetPlayerData(playerid, P_BP_PREMIUM));
    UpdatePlayerDatabaseInt(playerid, "bp_exp", GetPlayerData(playerid, P_BP_EXP));
    UpdatePlayerDatabaseInt(playerid, "bp_level", GetPlayerData(playerid, P_BP_LEVEL));
	LoadMainMenu(playerid, MAIN_MENU_BATTLEPASS);
    return true;
}

public: BPd_OnPlayerSkipTask(playerid, type)
{
    if(GetPlayerCurrentDonate(playerid) < g_battlepass_tasks[g_battlepass_id_tasks[playerid][type]][BP_DONATE_PRICE])
	{
		SendClientMessage(playerid, -1, "{eec702}У вас недостаточно донат валюты для пропуска задания");
		return GameText(playerid, "~r~У вас недостаточно~n~~w~донат валюты", 4000, 3);
	}

    GivePlayerDonate(playerid, -g_battlepass_tasks[g_battlepass_id_tasks[playerid][type]][BP_DONATE_PRICE], "Пропуск задания в battlepass");

    AddPlayerData(playerid, P_BP_EXP, +, OnBattlePass_GetPrizeExp(playerid, g_battlepass_id_tasks[playerid][type]));
	g_battlepass_id_tasks[playerid][type] = random(sizeof g_battlepass_tasks);

    if(type == 0) UpdatePlayerDatabaseInt(playerid, "bp_task_1", g_battlepass_id_tasks[playerid][0]);
    if(type == 1) UpdatePlayerDatabaseInt(playerid, "bp_task_2", g_battlepass_id_tasks[playerid][1]);
    if(type == 2) UpdatePlayerDatabaseInt(playerid, "bp_task_3", g_battlepass_id_tasks[playerid][2]);
    if(type == 3) UpdatePlayerDatabaseInt(playerid, "bp_task_4", g_battlepass_id_tasks[playerid][3]);
    if(type == 4) UpdatePlayerDatabaseInt(playerid, "bp_task_5", g_battlepass_id_tasks[playerid][4]);
    if(type == 5) UpdatePlayerDatabaseInt(playerid, "bp_task_6", g_battlepass_id_tasks[playerid][5]);
	if(type == 6) UpdatePlayerDatabaseInt(playerid, "bp_task_7", g_battlepass_id_tasks[playerid][6]);
	if(type == 7) UpdatePlayerDatabaseInt(playerid, "bp_task_8", g_battlepass_id_tasks[playerid][7]);
	if(type == 8) UpdatePlayerDatabaseInt(playerid, "bp_task_9", g_battlepass_id_tasks[playerid][8]);
	if(type == 9) UpdatePlayerDatabaseInt(playerid, "bp_task_10", g_battlepass_id_tasks[playerid][9]);
	if(type == 10) UpdatePlayerDatabaseInt(playerid, "bp_task_11", g_battlepass_id_tasks[playerid][10]);
	if(type == 11) UpdatePlayerDatabaseInt(playerid, "bp_task_12", g_battlepass_id_tasks[playerid][11]);

    UpdatePlayerDatabaseInt(playerid, "bp_exp", GetPlayerData(playerid, P_BP_EXP));
	
    OnBattlePass_StatusLevel(playerid);
    
    return true;
}
public: BPd_OnPlayerBuyLevel(playerid, event)
{
	for(new i; i < sizeof(g_battlepass_buylevel); i++)
	{
		if(g_battlepass_buylevel[i][L_ID] != event) continue;
		if(GetPlayerCurrentDonate(playerid) < g_battlepass_buylevel[i][L_PRICE])
		{
			SendClientMessage(playerid, -1, "{eec702}Недостаточно средств для покупки");
			return GameText(playerid, "~r~Недостаточно Средств", 4000, 3);
		} 

		GivePlayerDonate(playerid, -g_battlepass_buylevel[i][L_PRICE], "Пропуск задания в battlepass"); 
		GameText(playerid, "~g~Успешно", 4000, 3);
		AddPlayerData(playerid, P_BP_LEVEL, +, g_battlepass_buylevel[i][L_COUNT]);
		OnBattlePass_StatusLevel(playerid);
		UpdatePlayerDatabaseInt(playerid, "bp_level", GetPlayerData(playerid, P_BP_LEVEL));
    	LoadMainMenu(playerid, MAIN_MENU_BATTLEPASS);

	}
	return true;
}
public: BPd_OnPlayerTakeReward(playerid, type, event)
{
    if(GetPlayerData(playerid, P_BP_LEVEL) == 0) return true;

    for(new i; i < sizeof g_battlepass_prize; i++)
    {
        if(g_battlepass_prize[i][BP_PRIZE_ID] != type) continue;
        new bool:has_kd = false;
        for(new k = 0; k < sizeof(kd_bp); k++)
        {
            if(kd_bp[k] == type)
            {
                has_kd = true;
                break;
            }
        }

        if(has_kd)
        {
            new currentTime = gettime();
            new expireTime = PlayerBP_KD[playerid][i] + 60; 

            if(currentTime < expireTime)
            {
                new seconds_kd = expireTime - currentTime;
                new str[64];
                format(str, sizeof(str), "~r~Ошибка! Повторите через %d сек", seconds_kd);
                GameText(playerid, str, 5000, 1);
                
                LoadMainMenu(playerid, MAIN_MENU_BATTLEPASS);
                return true;
            }
        }
        if(g_battlepass_prize[i][BP_PRIZE_PREMIUM] == BP_FREE) 
        {
				if(type == 26)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 2);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else if(type == 32)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 3);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else if(type == 47)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 2);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else if(type == 66)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 2);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else if(type == 77)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 4);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else if(type == 82)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 2);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else if(type == 97)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 2);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else if(type == 108)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 2);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else if(type == 125)
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 2);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
				else
				{
					AddPlayerData(playerid, P_BP_PRIZE_1, +, 1);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));
				}
        }
        if(g_battlepass_prize[i][BP_PRIZE_PREMIUM] == BP_PREMIUM) 
        {
				if(g_battlepass_prize[i][BP_PRIZE_ID] == 4)
				{
					AddPlayerData(playerid, P_BP_PRIZE_2, +, 4);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_2", GetPlayerData(playerid, P_BP_PRIZE_2));
				}
				else
				{
					AddPlayerData(playerid, P_BP_PRIZE_2, +, 1);
					UpdatePlayerDatabaseInt(playerid, "bp_prize_2", GetPlayerData(playerid, P_BP_PRIZE_2));
				}
        }
        if(event == 0)
        {
            GiveBPdPrize(playerid, i);
            SCMF(playerid, 0xff7627FF, "Приз {FFFFFF}%s {ff7627}успешно был зачислен на ваш аккаунт. Забрать его можно в главном меню -> Награды -> Мои награды", g_battlepass_prize[i][BP_PRIZE_NAME]);
        }
        else
        {
            AddPlayerData(playerid, P_BP_EXP, +, g_battlepass_prize[i][BP_PRIZE_EXP]);
            UpdatePlayerDatabaseInt(playerid, "bp_exp", GetPlayerData(playerid, P_BP_EXP));
            SCMF(playerid, 0xff7627FF, "Приз {FFFFFF}%s {ff7627}успешно был распылен", g_battlepass_prize[i][BP_PRIZE_NAME]);
            OnBattlePass_StatusLevel(playerid);
        }
        if(has_kd)
        {
            PlayerBP_KD[playerid][i] = gettime();
        }
        break;
    }
    LoadMainMenu(playerid, MAIN_MENU_BATTLEPASS);
    return true;
}
stock GiveBPdPrize(playerid, prizeIndex){
	if(prizeIndex < 0 || prizeIndex >= MAX_BATTLEPASS_PRIZES)
		return printf("[BATTLEPASS] InvalidPrizeIndex: %d", prizeIndex);

	new prizeType = g_battlepass_prize[prizeIndex][BP_PRIZE_TYPE];
	new item_id = g_battlepass_prize[prizeIndex][BP_PRIZE_ITEM_ID];
	new count = g_battlepass_prize[prizeIndex][BP_PRIZE_COUNT];
	new index = g_battlepass_prize[prizeIndex][BP_PRIZE_INDX];
 	switch(prizeType){
	case BATTLEPASS_PRIZE_ITEM:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 8, item_id, 0, count, 0);

    case BATTLEPASS_PRIZE_SKIN:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 4, item_id, 0, 1, 0);
    
    case BATTLEPASS_PRIZE_DONATE:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 10, 0, 0, count, 0);

    case BATTLEPASS_PRIZE_EXP:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 2, 0, 0, count, 0);
    
    case BATTLEPASS_PRIZE_ACS:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 6, item_id, 0, 1, index);
    
    case BATTLEPASS_PRIZE_VIP:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 7, item_id, 0, 0, index);

    case BATTLEPASS_PRIZE_CAR:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 3, item_id, 0, -1, 0);

    case BATTLEPASS_PRIZE_MONEY:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 5, 0, 0, count, 0);

    case BATTLEPASS_PRIZE_CASE:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 21, item_id, 0, -1, 0);
    
	case BATTLEPASS_PRIZE_PACK_FERMA:{
		GivePlayerMyPrizes(playerid, "Известь", 8, 333, 0, 20, 0);
		GivePlayerMyPrizes(playerid, "Гербицид", 8, 334, 0, 20, 0);
		GivePlayerMyPrizes(playerid, "Лопата", 8, 125, 0, 1, 0);
		return 1;
	}

	case BATTLEPASS_PRIZE_PACK1:{
		GivePlayerMyPrizes(playerid, "Desert Eagle", 8, 19, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Патроны .44 Magnum", 8, 363, 0, 24, 0);
		return 1;
	}
	case BATTLEPASS_PRIZE_PACK2:{
		GivePlayerMyPrizes(playerid, "АКСУ", 8, 18, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Патроны 5.45х39", 8, 366, 0, 50, 0);
		return 1;
	}
	case BATTLEPASS_PRIZE_PACK3:{
		GivePlayerMyPrizes(playerid, "АКМ", 8, 21, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Патроны 7.62х39", 8, 368, 0, 50, 0);
		return 1;
	}

	case BATTLEPASS_PRIZE_PACK4:{
		GivePlayerMyPrizes(playerid, "Домкрат", 8, 361, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Аппарат для диагностики", 8, 254, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Воздушный фильтр", 8, 166, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Масляной фильтр", 8, 167, 0, 1, 0);
		return 1;
	}
	case BATTLEPASS_PRIZE_PACK5:{
		GivePlayerMyPrizes(playerid, "Сайга-12", 8, 16, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Патроны 12х70", 8, 365, 0, 21, 0);
		return 1;
	}

	case BATTLEPASS_PRIZE_PACK6:{
		GivePlayerMyPrizes(playerid, "HK416", 8, 20, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Патроны 5.56x45", 8, 367, 0, 60, 0);
		return 1;
	}

	case BATTLEPASS_PRIZE_PACK7:{
		GivePlayerMyPrizes(playerid, "MSR", 8, 42, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Патроны .338 Magnum", 8, 364, 0, 24, 0);
		return 1;
	}

	case BATTLEPASS_PRIZE_PACK8:{
		GivePlayerMyPrizes(playerid, "AWM", 8, 22, 0, 1, 0);
		GivePlayerMyPrizes(playerid, "Патроны .338 Magnum", 8, 364, 0, 24, 0);
		return 1;
	}

	case BATTLEPASS_PRIZE_PACKN4:{
		GivePlayerMyPrizes(playerid, "EXP", 2, 0, 0, 10, 0); // exp
		GivePlayerMyPrizes(playerid, "Донат", 10, 0, 0, 25, 0); // donate
		GivePlayerMyPrizes(playerid, "VIP GOLD", 7, 2, 0, 0, 7); // vip
		GivePlayerMyPrizes(playerid, "Манера", 14, 1518, 0, 1, 0); // Аним манера
		return 1; 
	}

    case BATTLEPASS_PRIZE_GOLD: {
		AddPlayerData(playerid, P_BP_GOLDS, +, count);
	    UpdatePlayerDatabaseInt(playerid, "bp_golds", GetPlayerData(playerid, P_BP_GOLDS));
	}
    
    case BATTLEPASS_PRIZE_ANIM:
      return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 14, item_id, 0, 1, 0);
    
    case BATTLEPASS_PRIZE_VB:
        return GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 17, item_id, 0, count, index);

	case BATTLEPASS_PRIZE_MEDCARTA: 
		GivePlayerMyPrizes(playerid, g_battlepass_prize[prizeIndex][BP_PRIZE_NAME], 24, 0, 0, count, 0);
    
    default:
      return printf("[BATTLEPASS] Неизвестный тип приза (type: %d)", prizeType);
  	}
  	return 1;
}   
stock OnBattlePass_Perfomance(playerid, type, count)
{
    new bool:changed = false;

    new current_time = gettime();
    if(bp_timer <= current_time) return 0;

    for(new i; i < MAX_BP_TASKS; i++)
    {
        if(g_battlepass_tasks[g_battlepass_id_tasks[playerid][i]][BP_TYPE_TASKS] != type) continue;
        if(OnBattlePass_TaskStatus(playerid, i) == 1) continue;

        g_battlepass_id_point[playerid][i] += count;
        changed = true;

        if(OnBattlePass_TaskStatus(playerid, i) == 1)
        {
            new prize = OnBattlePass_GetPrizeExp(playerid, g_battlepass_id_tasks[playerid][i]);
            AddPlayerData(playerid, P_BP_EXP, +, prize);
            UpdatePlayerDatabaseInt(playerid, "bp_exp", GetPlayerData(playerid, P_BP_EXP));

            static msg[148];
            format(msg, sizeof msg, "Вы выполнили {FFFFFF}`%s` {ff7627}и получили {FFFFFF}%d оч. {ff7627}У вас теперь {FFFFFF}%d очков.", g_battlepass_tasks[g_battlepass_id_tasks[playerid][i]][BP_NAME_TASKS], prize, GetPlayerData(playerid, P_BP_EXP));
            SCM(playerid, 0xff7627FF, msg);
            GameText(playerid, "~r~Новые очки~n~боевого пропуска", 3000, 2);
        }
    }

    if(changed)
    {
        static query[248];
		mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET bp_point_1=%d,bp_point_2=%d,bp_point_3=%d,bp_point_4=%d,bp_point_5=%d,bp_point_6=%d,bp_point_7=%d,\
			bp_point_8=%d,bp_point_9=%d,bp_point_10=%d,bp_point_11=%d,bp_point_12=%d WHERE id=%d LIMIT 1", 
			g_battlepass_id_point[playerid][0], 
            g_battlepass_id_point[playerid][1], 
            g_battlepass_id_point[playerid][2], 
            g_battlepass_id_point[playerid][3], 
            g_battlepass_id_point[playerid][4], 
            g_battlepass_id_point[playerid][5],
			g_battlepass_id_point[playerid][6],
			g_battlepass_id_point[playerid][7],
			g_battlepass_id_point[playerid][8],
			g_battlepass_id_point[playerid][9],
			g_battlepass_id_point[playerid][10], 
			g_battlepass_id_point[playerid][11],
            GetPlayerAccountID(playerid)
		);
	    mysql_pquery(mysql, query);
    }

    OnBattlePass_StatusLevel(playerid);
    return 1;
}

stock OnBattlePass_TaskStatus(playerid, type)
{
    new status;
    if(g_battlepass_id_point[playerid][type] >= g_battlepass_tasks[g_battlepass_id_tasks[playerid][type]][BP_POINT]) status = 1;

    return status;
}
stock OnBattlePass_StatusLevel(playerid)
{
    if(GetPlayerData(playerid, P_BP_EXP) >= 100)
    {
        AddPlayerData(playerid, P_BP_EXP, -, 100);
        AddPlayerData(playerid, P_BP_LEVEL, +, 1);

        UpdatePlayerDatabaseInt(playerid, "bp_exp", GetPlayerData(playerid, P_BP_EXP));
        UpdatePlayerDatabaseInt(playerid, "bp_level", GetPlayerData(playerid, P_BP_LEVEL));
    }
    return true;
}

stock OnBattlePass_GetLevel(playerid)
{
    if(GetPlayerData(playerid, P_BP_PREMIUM) == 0) 
    {
        return g_battlepass_level[GetPlayerData(playerid, P_BP_LEVEL)];
    }
    else 
    {
        return GetPlayerData(playerid, P_BP_LEVEL);
    }
}

stock OnBattlePass_GetPrizeExp(playerid, type)
{
    if(GetPlayerData(playerid, P_BP_PREMIUM) == 0) 
    {
        return g_battlepass_tasks[type][BP_PRIZE];
    }
    else 
    {
        return g_battlepass_tasks[type][BP_PRIZE] * 2;
    }
}

stock OnBattlePass_GetPrizeGolds(playerid, type)
{
    if(GetPlayerData(playerid, P_BP_PREMIUM) == 0) 
    {
        return g_battlepass_tasks[type][BP_PRIZE_GOLDS];
    }
    else 
    {
        return g_battlepass_tasks[type][BP_PRIZE_GOLDS] * 2;
    }
}

stock OnBattlePass_TimeTasks(playerid)
{
	new current_time = gettime();
    if(bp_timer <= current_time) return 0;

	if(GetPlayerData(playerid, P_BP_TIME_TASKS) < gettime())
	{
		for(new i = 0; i < MAX_BP_TASKS; i++)
    	{
			g_battlepass_id_tasks[playerid][i] = random(sizeof g_battlepass_tasks);
			g_battlepass_id_point[playerid][i] = 0;

			static query[148];
			format(query, sizeof query, "Вы получили новое задание {FFFFFF}`%s` {ff7627}для боевого пропуска. Подробнее в главном меню.", g_battlepass_tasks[g_battlepass_id_tasks[playerid][i]][BP_NAME_TASKS]);
			SCM(playerid, 0xff7627FF, query); 
		}

		GameText(playerid, "~w~Новое задание~n~~r~боевого пропуска", 3000, 3);

		SetPlayerData(playerid, P_BP_TIME_TASKS, gettime() + 86400);

		static query[540];
		mysql_format(mysql, query, sizeof query, "UPDATE PlayersMorallwens SET bp_point_1=%d, bp_point_2=%d, bp_point_3=%d, bp_point_4=%d, bp_point_5=%d, bp_point_6=%d, \
		bp_point_7=%d, bp_point_8=%d, bp_point_9=%d, bp_point_10=%d, bp_point_11=%d, bp_point_12=%d, \
		bp_task_1=%d, bp_task_2=%d, bp_task_3=%d, bp_task_4=%d, bp_task_5=%d, bp_task_6=%d, bp_task_7=%d, bp_task_8=%d, bp_task_9=%d, bp_task_10=%d, bp_task_11=%d, bp_task_12=%d, \
		bp_time_tasks=%d WHERE id=%d LIMIT 1", 
		g_battlepass_id_point[playerid][0], 
		g_battlepass_id_point[playerid][1], 
		g_battlepass_id_point[playerid][2], 
		g_battlepass_id_point[playerid][3], 
		g_battlepass_id_point[playerid][4], 
		g_battlepass_id_point[playerid][5],
		g_battlepass_id_point[playerid][6],
		g_battlepass_id_point[playerid][7],
		g_battlepass_id_point[playerid][8],
		g_battlepass_id_point[playerid][9],
		g_battlepass_id_point[playerid][10],
		g_battlepass_id_point[playerid][11],
		g_battlepass_id_tasks[playerid][0], 
		g_battlepass_id_tasks[playerid][1], 
		g_battlepass_id_tasks[playerid][2], 
		g_battlepass_id_tasks[playerid][3], 
		g_battlepass_id_tasks[playerid][4], 
		g_battlepass_id_tasks[playerid][5],
		g_battlepass_id_tasks[playerid][6],
		g_battlepass_id_tasks[playerid][7],
		g_battlepass_id_tasks[playerid][8],
		g_battlepass_id_tasks[playerid][9],
		g_battlepass_id_tasks[playerid][10],
		g_battlepass_id_tasks[playerid][11],
		GetPlayerData(playerid, P_BP_TIME_TASKS),
		GetPlayerAccountID(playerid));
		mysql_pquery(mysql, query);
	}
	return 1;
}
stock InterfaceBattlepass(playerid){
    STRING_GLOBAL[0] = EOS; 
    new id_1 = g_battlepass_id_tasks[playerid][0];
    new id_2 = g_battlepass_id_tasks[playerid][1];
    new id_3 = g_battlepass_id_tasks[playerid][2];
    new id_4 = g_battlepass_id_tasks[playerid][3];
    new id_5 = g_battlepass_id_tasks[playerid][4];
    new id_6 = g_battlepass_id_tasks[playerid][5];
    new id_7 = g_battlepass_id_tasks[playerid][6];
    new id_8 = g_battlepass_id_tasks[playerid][7];
    new id_9 = g_battlepass_id_tasks[playerid][8];
    new id_10 = g_battlepass_id_tasks[playerid][9];
    new id_11 = g_battlepass_id_tasks[playerid][10];
    new id_12 = g_battlepass_id_tasks[playerid][11];

    new remaining_time = GetBattlePassRemainingTime();

    format(STRING_GLOBAL, sizeof STRING_GLOBAL, "interface('MainMenu').onServerResponse(4, '[[%d,4,%d,%d,%d,%d,%d,100,%d,[%d,1749427200],0,20,%d,1691614800,1200,1749564027,[[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0],[\"%s\",\"%s\",%d,%d,[[0,%d],[1,%d]],%d,0,%d,0]],[[5,2000,2000],[15,6000,5700],[35,14000,12600]],%d,9024570,[[4,284,0,0,\"Борат стиль 2\",1400,1,0],[4,15324,0,0,\"Мистер Бизнес\",2800,1,0],[3,17426,0,-1,\"Porsche 911/993 RWB\",4500,1,0]]]]')",
    OnBattlePass_GetLevel(playerid), GetPlayerData(playerid, P_BP_PREMIUM), GetPlayerData(playerid, P_BP_PRIZE_1), GetPlayerData(playerid, P_BP_PRIZE_2), PRICE_BATTLEPASS, remaining_time, GetPlayerData(playerid, P_BP_EXP), GetPlayerData(playerid, P_BP_TIME_TASKS), g_battlepass_time_bonus[playerid],
    g_battlepass_tasks[id_1][BP_NAME_TASKS], g_battlepass_tasks[id_1][BP_TASKS], g_battlepass_id_point[playerid][0], g_battlepass_tasks[id_1][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_1), OnBattlePass_GetPrizeGolds(playerid, id_1), g_battlepass_tasks[id_1][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 0),
    g_battlepass_tasks[id_2][BP_NAME_TASKS], g_battlepass_tasks[id_2][BP_TASKS], g_battlepass_id_point[playerid][1], g_battlepass_tasks[id_2][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_2), OnBattlePass_GetPrizeGolds(playerid, id_2), g_battlepass_tasks[id_2][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 1),
    g_battlepass_tasks[id_3][BP_NAME_TASKS], g_battlepass_tasks[id_3][BP_TASKS], g_battlepass_id_point[playerid][2], g_battlepass_tasks[id_3][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_3), OnBattlePass_GetPrizeGolds(playerid, id_3), g_battlepass_tasks[id_3][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 2),
    g_battlepass_tasks[id_4][BP_NAME_TASKS], g_battlepass_tasks[id_4][BP_TASKS], g_battlepass_id_point[playerid][3], g_battlepass_tasks[id_4][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_4), OnBattlePass_GetPrizeGolds(playerid, id_4), g_battlepass_tasks[id_4][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 3),
    g_battlepass_tasks[id_5][BP_NAME_TASKS], g_battlepass_tasks[id_5][BP_TASKS], g_battlepass_id_point[playerid][4], g_battlepass_tasks[id_5][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_5), OnBattlePass_GetPrizeGolds(playerid, id_5), g_battlepass_tasks[id_5][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 4),
    g_battlepass_tasks[id_6][BP_NAME_TASKS], g_battlepass_tasks[id_6][BP_TASKS], g_battlepass_id_point[playerid][5], g_battlepass_tasks[id_6][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_6), OnBattlePass_GetPrizeGolds(playerid, id_6), g_battlepass_tasks[id_6][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 5),
    g_battlepass_tasks[id_7][BP_NAME_TASKS], g_battlepass_tasks[id_7][BP_TASKS], g_battlepass_id_point[playerid][6], g_battlepass_tasks[id_7][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_7), OnBattlePass_GetPrizeGolds(playerid, id_7), g_battlepass_tasks[id_7][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 6),
    g_battlepass_tasks[id_8][BP_NAME_TASKS], g_battlepass_tasks[id_8][BP_TASKS], g_battlepass_id_point[playerid][7], g_battlepass_tasks[id_8][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_8), OnBattlePass_GetPrizeGolds(playerid, id_8), g_battlepass_tasks[id_8][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 7),
    g_battlepass_tasks[id_9][BP_NAME_TASKS], g_battlepass_tasks[id_9][BP_TASKS], g_battlepass_id_point[playerid][8], g_battlepass_tasks[id_9][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_9), OnBattlePass_GetPrizeGolds(playerid, id_9), g_battlepass_tasks[id_9][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 8),
    g_battlepass_tasks[id_10][BP_NAME_TASKS], g_battlepass_tasks[id_10][BP_TASKS], g_battlepass_id_point[playerid][9], g_battlepass_tasks[id_10][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_10), OnBattlePass_GetPrizeGolds(playerid, id_10), g_battlepass_tasks[id_10][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 9),
    g_battlepass_tasks[id_11][BP_NAME_TASKS], g_battlepass_tasks[id_11][BP_TASKS], g_battlepass_id_point[playerid][10], g_battlepass_tasks[id_11][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_11), OnBattlePass_GetPrizeGolds(playerid, id_11), g_battlepass_tasks[id_11][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 10),
    g_battlepass_tasks[id_12][BP_NAME_TASKS], g_battlepass_tasks[id_12][BP_TASKS], g_battlepass_id_point[playerid][11], g_battlepass_tasks[id_12][BP_POINT], OnBattlePass_GetPrizeExp(playerid, id_12), OnBattlePass_GetPrizeGolds(playerid, id_12), g_battlepass_tasks[id_12][BP_DONATE_PRICE],OnBattlePass_TaskStatus(playerid, 11),
    GetPlayerData(playerid, P_BP_GOLDS), GetPlayerData(playerid, P_BP_GOLDS));

    SendClientEvent(playerid, Update, STRING_GLOBAL); 
    return 1;
}

cmd:setbp(playerid, params[])
{
	extract params -> new prize1, prize2; else
		return SCM(playerid, -1, "/setbp - [prize1] [prize2]");

	SetPlayerData(playerid, P_BP_PRIZE_1, prize1);
	UpdatePlayerDatabaseInt(playerid, "bp_prize_1", GetPlayerData(playerid, P_BP_PRIZE_1));

	SCMF(playerid, -1, "Успешно: bp_prize_1 = %d", prize1);

	SetPlayerData(playerid, P_BP_PRIZE_2, prize2);
	UpdatePlayerDatabaseInt(playerid, "bp_prize_2", GetPlayerData(playerid, P_BP_PRIZE_2));

	SCMF(playerid, -1, "Успешно: bp_prize_2 = %d", prize2);

	LoadMainMenu(playerid, MAIN_MENU_BATTLEPASS);

	return 1;
}
cmd:checkbp(playerid, params[])
{
	SCMF(playerid, -1, "P_BP_PRIZE_1 = [%d], P_BP_PRIZE_2 = [%d]", GetPlayerData(playerid, P_BP_PRIZE_1), GetPlayerData(playerid, P_BP_PRIZE_2));
}