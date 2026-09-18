#define REWARD_TYPE_EXP         1
#define REWARD_TYPE_MONEY       2
#define REWARD_TYPE_BC          3
#define REWARD_TYPE_CASE        4
#define REWARD_TYPE_VEHICLE     5
#define REWARD_TYPE_VIP         9
#define REWARD_TYPE_BP_EXP      10
#define REWARD_TYPE_ITEM        11
#define REWARD_TYPE_DUST        21
#define REWARD_TYPE_EVENT_RES   23

#define MAX_CASES               19
#define MAX_AWARDS_PER_CASE     40
#define MAX_BONUS_PER_CASE      5

enum E_CASE_AWARD {
    aId,
    aRarity,
    aType,
    aInternalId,
    aCount,
    aPriceSprayed,
    aSubcount
};

enum E_CASE_BONUS {
    bId,
    bNumberOpen,
    bRarity,
    bType,
    bInternalId,
    bCount,
    bPriceSprayed
};

enum E_CASE_DATA {
    cId,
    cPriceOne,
    cPriceTen,
    cDiscountOne,
    cDiscountTen,
    cAwardsCount,
    cBonusCount
};

new CaseAwardNames[30][60][64] = {
	// Case 0 names
	{
		"Рем.комплект",
		"Аптечка",
		"200 BP EXP",
		"Канистра с бензином",
		"2000 Р",
		"5 BC",
		"3000 Р",
		"10 BC",
		"VIP SILVER 2Ч.",
		"300 BP EXP",
		"4 EXP",
		"RACER SPORT",
		"500 BP EXP",
		"20000 Р",
		"15 BC",
		"VIP GOLD 2Ч.",
		"500 BP EXP",
		"30000 Р",
		"6 EXP",
		"ВАЗ 1111",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 1 names
	{
		"Aprilla MXV 450",
		"VOLKSWAGEN GOLF GTI 2",
		"75000 Р",
		"ВАЗ 21099",
		"8 EXP",
		"ВАЗ 2108",
		"90000 Р",
		"ВАЗ 2109",
		"ВАЗ 2110",
		"ВАЗ 2114",
		"VIP SILVER 7 ДН.",
		"ВАЗ 2112",
		"ВАЗ 2115",
		"12 EXP",
		"120000 Р",
		"VIP GOLD 3 ДН.",
		"VOLVO 242DL",
		"ВАЗ 2170",
		"VIP PLATINUM 3 ДН.",
		"NIVA URBAN",
		"Mercedes-Benz W124",
		"BMW M3 E36",
		"Mercedes-Benz E420 W210",
		"РЮКЗАК СИФОНА",
		"HYUNDAI SOLARIS 2021",
		"ПОБИТЫЕ ОЧКИ",
		"КОРОЛЬ БОМЖЕЙ",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 2 names
	{
		"КОРОНА КОРОЛЯ",
		"VIP GOLD 21 ДН.",
		"600000 Р",
		"КЕЙС ЧЕРНЫЙ",
		"BMW M3 E46",
		"600 BC",
		"VIP PLATINUM 15 Д.",
		"ACURA TSX",
		"МОПС НА СПИНУ",
		"БАРХАТНЫЕ ТЯГИ СПОРТИВНЫЕ",
		"КОРОНА ДЕМОНА",
		"ХОУМИ С РАЙОНА",
		"VOLKSWAGEN GOLF GTI",
		"BMW X5 E53",
		"РЫБАЧКА",
		"NISSAN QASHQAI",
		"NISSAN TEANA J32",
		"NISSAN SILVIA S15",
		"DUCATI SUPERSPORT S",
		"1000000 Р",
		"VIP PLATINUM 30 Д.",
		"БАРЫГА ПРЕСТУПНИК",
		"BMW M5 E60",
		"МЕНТ ИЗ КЛИПА",
		"SUBARU WRX STI",
		"ОПАСНЫЙ МУЖЧИНА",
		"KIA K5",
		"BMW X5M E70",
		"CHEVROLET CAMARO ZL1",
		"BMW Z4 M40i ",
		"МАСКА СВИНА",
		"MERCEDES-BENZ GT63S",
		"BMW M4 G82",
		"BMW X6M F16",
		"PORSCHE 911 CARRERA S",
		"LAMBORGHINI AVENTADOR S",
		"TESLA MODEL X",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 3 names
	{
		"MITSUBISHI LANCER EVO X",
		"BMW M5 E60",
		"SUBARU WRX STI",
		"TOYOTA CAMRY 3.5",
		"HAVAL F7X",
		"FORD MUSTANG GT",
		"TOYOTA SUPRA A80",
		"MERCEDES-BENZ A45 AMG",
		"MINI COUNTRYMAN",
		"VOLKSWAGEN PASSAT",
		"ALFA ROMEO GUILIA",
		"BMW X5M E70",
		"INFINITI Q60S",
		"LEXUS RCF",
		"SUBARU BRZ",
		"XPENG P7",
		"BMW 3-SERIES G20",
		"BMW Z4 M40I",
		"DODGE CHARGER SRT",
		"BMW M4 F84",
		"ZEERK 001",
		"LEXUS IS500F PERFOMANCE",
		"MERCEDES-BENZ GT63S",
		"CADILLAC ESCALADE IV",
		"BMW M4 G82",
		"BMW X6M F16",
		"TOYOTA LAND CRUISER 200",
		"PORSCHE 911 CARRERA",
		"Volkswagen Touareg 2022",
		"AUDI E-TRON GT",
		"LAMBORGHINI AVENTADOR S",
		"TESLA MODEL X",
		"MERCEDES-BENZ G63 AMG",
		"MERCEDES-BENZ MAYBACH S650",
		"AURUS SENAT",
		"MERCEDES-BENZ MB S650",
		"MERCEDES-BENZ G63 AMG BRABUS",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 4 names
	{
		"Mercedes-Benz C63s",
		"Porsche Panamera S",
		"BMW M6 F12",
		"BMW X7 M50i",
		"McLaren 600 LT",
		"Porsche Cayenne S",
		"Lamborghini Urus",
		"Lamborghini Huracan",
		"Chevrolet Corvette C8",
		"Mercedes-Benz G65 AMG",
		"Ferrari 488 Pista",
		"Pagani Zonda 2002",
		"Tesla CyberTruck",
		"Rolls-Royce Cullinan",
		"Mercedes-Benz G63 AMG 6x6",
		"BENTLEY Continental GT",
		"BMW M1",
		"BUGATTI CHIRON",
		"Koenigsegg Regera",
		"Bugatti Divo",
		"Bugatti Veyron",
		"BMW M5 F90 (ППС)",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 5 names
	{
		"Емеля",
		"Корона демона",
		"Крылья ангела",
		"6000 BP EXP",
		"Маска дайвера",
		"Кейс черный",
		"700 BC",
		"Хоуми с района",
		"7000 BP EXP",
		"BMW X5 E53",
		"750000 Р",
		"Рюкзак Боксера",
		"9000 BP EXP",
		"Барыга преступник",
		"Водяной пистолет",
		"Модница Ребекка",
		"Качок Джонс",
		"FORD Mustang GT",
		"Nissan 240SX",
		"INFINITI FX50S",
		"DODGE DEMON SRT",
		"BMW M4 G82",
		"Nissan GT-R R35",
		"McLaren 600 LT",
		"Pagani Zonda 2002",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 6 names
	{
		"Емеля",
		"Кейс черный",
		"Живая Росянка",
		"Крылья ангела",
		"Шлем Bunny",
		"700 BC",
		"7000 BP EXP",
		"Хоуми с района",
		"Багровые кристаллы Х3000",
		"BMW X5 E53",
		"Книга Тайн",
		"Токсичная",
		"Барыга преступник",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"INFINITI FX50S",
		"Багровые кристаллы Х5000",
		"Ванко Одержимый",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"BMW M4 G82",
		"Nissan GT-R R35",
		"McLaren 600 LT",
		"Mitsubishi Ecliplse",
		"SCG 003",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 7 names
	{
		"Бархатные тяги спортивные",
		"Кейс черный",
		"Маска Fresh'а",
		"Крылья ангела",
		"Рюкзак Energy",
		"700 BC",
		"7000 BP EXP",
		"Хоуми с района",
		"Багровые кристаллы Х3000",
		"BMW X5 E53",
		"Сумка SpeedPack",
		"Искра",
		"Снеговик не растает",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Петр Шторм",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Mercedes-Benz E63 W212",
		"Nissan GT-R R35",
		"BMW 7-Series 750Li",
		"Renault R5 Turbo 3E",
		"Ferrari 812 Superfast",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 8 names
	{
		"Рыбак",
		"Кейс черный",
		"Очки Санрайз у воды",
		"Крылья ангела",
		"700 BC",
		"900000 Р",
		"Хоуми с района",
		"Золотая корона",
		"BMW X5 E53",
		"Маска Чилл",
		"Леха",
		"Маньяк с мешком",
		"FORD Mustang GT",
		"1200000 Р",
		"INFINITI FX50S",
		"1500000 Р",
		"Серый",
		"Toyota GT86",
		"Сумка мажора",
		"DODGE DEMON SRT",
		"3000000 Р",
		"Audi Q7",
		"Nissan GT-R R35",
		"Mercedes-Benz GT-R",
		"Porsche 918 Spyder",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 9 names
	{
		"Солдатка Красавица",
		"Кейс черный",
		"Вездеход Монстр",
		"МОПС НА СПИНУ",
		"Игла преступник",
		"700 BC",
		"900000 Р",
		"Хоуми с района",
		"6000 BP EXP",
		"BMW X5 E53",
		"Рюкзак Танкиста",
		"Бархатные тяги особые",
		"Сотрудник Фирмы",
		"FORD MUSTANG GT",
		"7000 BP EXP",
		"NIVA 4x4 Storm",
		"1200000 Р",
		"Танковый Ас",
		"DODGE DEMON SRT",
		"10000 BP EXP",
		"Hummer Humvee",
		"Nissan GT-R R35",
		"Mercedes-Benz GT-R",
		"ГАЗ ТИГР",
		"Урал ИМЗ 8 Блиц",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 10 names
	{
		"Бархатные тяги особые",
		"Кейс черный",
		"Черная панама с сигарой",
		"Анимированная Лапка",
		"Кепка-платок Браток",
		"800 BC",
		"900000 Р",
		"Игла преступник",
		"Багровые кристаллы X3000",
		"BMW X5 E53",
		"Электрическая дубинка",
		"Дядя Жора",
		"Опасный мужчина",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Громов",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Cadillac Escalade IV",
		"Nissan GT-R R35",
		"Range Rover SVR",
		"Toyota Supra A90",
		"BMW M5 CS",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 11 names
	{
		"Рыбачка",
		"Кейс черный",
		"Надувной жилет",
		"Очки звездочки",
		"Кулон Драконий камень",
		"800 BC",
		"900000 Р",
		"Игла преступник",
		"Багровые кристаллы X3000",
		"BMW X5 E53",
		"Рюкзак Олигарха",
		"Менеджер клуба",
		"Горячий мужчина",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Варя",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi S5 Coupe 2020",
		"Nissan GT-R R35",
		"Mercedes-Benz CLS63 AMG",
		"BMW X5M F85",
		"Ferrari SF90 Stradale Spider",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 12 names
	{
		"Хоуми с района",
		"Шлем MVP",
		"Очки люкс",
		"Маска ведущего",
		"Рюкзак ускорение",
		"800 BC",
		"900000 Р",
		"Игла преступник",
		"Багровые кристаллы X3000",
		"BMW X5 E53",
		"Голова ОКАК",
		"Сумка Мастера",
		"Шторм Похудевший",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Луна Гонщица",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi S5 Coupe 2020",
		"Nissan GT-R R35",
		"Mercedes-Benz CLS63 AMG",
		"BMW Z4 M40i",
		"Ferrari 308 GTB",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 13 names
	{
		"Бархатные тяги особые",
		"Рюкзак Fuel",
		"Прямые очки 'Огонь'",
		"Маска ведущего",
		"Маска Metal Dragon",
		"800 BC",
		"900000 Р",
		"Барыга преступник",
		"Багровые кристаллы X3000",
		"BMW X5 E53",
		"Рюкзак Дрифтера",
		"Санек Брат",
		"Мент из клипа",
		"FORD MUSTANG GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"Руслан Дрифтер",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi Q7",
		"Nissan GT-R R35",
		"Range Rover SVR",
		"BMW M5 F10",
		"Lamborghini Countach 2022",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 14 names
	{
		"Хоуми с района",
		"Золотая корона",
		"Очки 'Пламя'",
		"Берет 'Gucci'",
		"800 BC",
		"900000 Р",
		"BMW X5 E53",
		"Барыга преступник",
		"Вика Отличница",
		"Сотрудник Фирмы",
		"FORD MUSTANG GT",
		"1200000 Р",
		"Volvo V60",
		"1500000 Р",
		"BMW M5 F10",
		"Кепка Школьника",
		"Сумка Чемпиона",
		"Рюкзак для вечеринок",
		"Тяжелый Форвард",
		"DODGE DEMON SRT",
		"3000000 Р",
		"Audi Q7",
		"Nissan GT-R R35",
		"Range Rover SVR",
		"Bugatti Centodieci",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 15 names
	{
		"Игла преступник",
		"Красная коса",
		"Шапка ведьмы",
		"Кукла Вуду",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки 'Пламя'",
		"Барыга преступник",
		"Охотник на нечисть",
		"Сотрудник Фирмы",
		"FORD Mustang GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"BMW M5 F10",
		"Мистический Амулет",
		"Цилиндр Доп. Интеллект",
		"Полина Ученая",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"BMW M4 CSL",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 16 names
	{
		"Игла преступник",
		"Железная коса",
		"Шапка с привидением",
		"Кукла Вуду",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки 'Пламя'",
		"Пчелка убийца",
		"Анна Нокс",
		"Рюкзак Монстр",
		"FORD Mustang GT",
		"Багровые кристаллы Х7500",
		"Volvo V60",
		"Багровые кристаллы Х5000",
		"BMW M5 F10",
		"Рюкзак Гробик",
		"Сумка Котел с зельем",
		"Антиквар Фогг",
		"DODGE DEMON SRT",
		"Багровые кристаллы Х15000",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"Lamborghini Veneno 2013",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 17 names
	{
		"Бархатные тяги особые",
		"Маска Снегурочка",
		"Новогодний топорик",
		"Новогодняя шапка с рогами",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки салют",
		"Новогодний пингвин",
		"Алина Зимина",
		"Сотрудник Фирмы",
		"FORD Mustang GT",
		"Праздничные звезды Х7500",
		"Volvo V60",
		"Праздничные звезды Х5000",
		"BMW M5 F10",
		"Сноуборд за спину",
		"Рюкзак Снежный шар",
		"Тима Зимин",
		"DODGE DEMON SRT",
		"Праздничные звезды Х15000",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"McLaren P1",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 18 names
	{
		"Бархатные тяги спортивные",
		"Маска Деда Мороза",
		"Новогодняя палочка с кристаллом",
		"Гринч",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки Анимированный салют",
		"Снеговик не растает",
		"Голова Коня",
		"FORD Mustang GT",
		"Праздничные звезды Х7500",
		"Volvo V60",
		"Праздничные звезды Х5000",
		"BMW M5 F10",
		"Руслан Джерси",
		"Ford Mustang GT3",
		"Виктор Гонщик",
		"Шлем Мороз",
		"Рюкзак Медведь",
		"Зимняя Луна",
		"Праздничные звезды Х15000",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Porsche Mission R",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 19 names
	{
		"Игла преступник",
		"Очки люкс",
		"Очки звездочки",
		"Советская шапка",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Прямые очки 'Огонь'",
		"Бархатные тяги спортивные",
		"Барыга преступник",
		"Опасный мужчина",
		"FORD Mustang GT",
		"Мент из клипа",
		"NIVA 4x4 Storm",
		"Косплей Майора",
		"Кейс черный",
		"Олег Рубцов",
		"Грабитель в маске",
		"Маска Чумного доктора",
		"DODGE DEMON SRT",
		"Маска Призрака",
		"Mercedes-Benz GT-R",
		"Toyota Land Cruiser 200",
		"Audi A8 Police",
		"Lamborghini Aventador SV 2017",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 20 names
	{
		"Хоуми с района",
		"Очки Доллар",
		"Кейс серый",
		"Советская шапка",
		"700 BC",
		"900000 Р",
		"BMW X5 E53",
		"Очки Санрайз у воды",
		"Бархатные тяги спортивные",
		"Барыга преступник",
		"1200000 Р",
		"FORD Mustang GT",
		"Мент из клипа",
		"1500000 Р",
		"BMW M5 F10",
		"Артур Игоревич",
		"Кейс Рентген",
		"Рино",
		"Балаклава Криминал",
		"DODGE DEMON SRT",
		"3000000 Р",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"Rolls Royce Spectre",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 21 names
	{
		"Очки пиксели",
		"Лавровый венец",
		"Прямые очки 'Огонь'",
		"Шлем велосипедиста",
		"Бархатные тяги особые",
		"Хоуми с района",
		"700 BC",
		"BMW X5 E53",
		"900000 Р",
		"Барыга преступник",
		"Мент из клипа",
		"1200000 Р",
		"FORD Mustang GT",
		"1500000 Р",
		"Ночная Орхидея",
		"BMW M5 F10",
		"Жетон на шею",
		"Анна Организатор",
		"Рюкзак Уличный",
		"3000000 Р",
		"DODGE DEMON SRT",
		"Audi Q7",
		"Toyota Land Cruiser 200",
		"Range Rover SVR",
		"Lamborghini Centenario",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 22 names
	{
		"Очки День рождения",
		"Золотая корона",
		"Очки 'Пламя'",
		"Очки люкс",
		"Бархатные тяги особые",
		"Хоуми с района",
		"700 BC",
		"BMW X5 E53",
		"900000 Р",
		"Барыга преступник",
		"Мент из клипа",
		"1200000 Р",
		"FORD Mustang GT",
		"1500000 Р",
		"BMW M5 F10",
		"Доминик",
		"Очки Горение",
		"Городской Хищник",
		"Мопс на плечо",
		"3000000 Р",
		"Mitsubishi Galant 8",
		"DODGE DEMON SRT",
		"Audi Q7",
		"Range Rover SVR",
		"Toyota Custom BodyKit",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	{
    "Очки Доллар",
    "Белая панама с сигарой",
    "Прямые очки 'WARNING'",
    "Солдатка Красавица",
    "Бархатные тяги особые",
    "Анимированная Лапка",
    "700 BC",
    "BMW X5 E53",
    "900000 Р",
    "Барыга преступник",
    "Мент из клипа",
    "1200000 Р",
    "FORD Mustang GT",
    "1500000 Р",
    "BMW M5 F10",
    "Рюкзак Верный друг",
    "Маша Оперативница",
    "Маска Крысы",
    "Полицейский щит",
    "3000000 Р",
    "DODGE DEMON SRT",
    "Audi Q7",
    "Таинственный Незнакомец",
    "Range Rover SVR",
    "BMW X7 Police 6x6",

   "",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
},

	// Case 24 names
	{
		"MITSUBISHI LANCER EVO X",
		"BMW M5 E60",
		"SUBARU WRX STI",
		"Mercedes-Benz A45 AMG",
		"Zeekr 001",
		"Mercedes-Benz GT63s",
		"Cadillac Escalade IV",
		"BMW M4 G82",
		"Toyota Land Cruiser 200",
		"Lexus IS500F Performance",
		"BMW X6M F16",
		"Porsche 911 Carrera",
		"Volkswagen Touareg 2022",
		"Audi e-tron GT",
		"LAMBORGHINI AVENTADOR S",
		"TESLA MODEL X",
		"MERCEDES-BENZ G63 AMG",
		"MERCEDES-BENZ MAYBACH S650",
		"Mercedes-Benz MB S650",
		"Koenigsegg Sadair's Spear",
		"Mercedes-Benz G 63 AMG Brabus",
		"Aston Martin DB11",
		"Ferrari 488 GTB",
		"BMW M8 F93 Gran Coupe",
		"Aurus Senat",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 25 names
	{
		"Билет гонщика х1",
		"Билет гонщика  х3",
		"Билет гонщика  х5",
		"Билет гонщика  х10",
		"Билет гонщика  х20",
		"Билет гонщика х30",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 26 names
	{
		"Каракал (24 ч)",
		"Слейпнир (24 ч)",
		"Койот (24 ч)",
		"VAZ 2170 (24 ч)",
		"Mazda Sedan 3 (24 ч)",
		"Toyota Mark II (24 ч)",
		"Nissan Skyline R34 (24 ч)",
		"VAZ-2105 Street 1996 (24 ч)",
		"VAZ 2106 (Hoonicorn style) (24 ч)",
		"Audi Quattro 80 B2 (24 ч)",
		"Dodge Charger R/T 1969 (24 ч)",
		"Buick GSX 1970 (24 ч)",
		"BMW E28 Alpina (24 ч)",
		"ГАЗ-21 Coupe (24 ч)",
		"Volvo 240 GL (24 ч)",
		"Dodge Demon SRT Off-Road (24 ч)",
		"Mazda RX-7 (24 ч)",
		"Cadillac Miller-Meteor 1959 Ecto-1 (24 ч)",
		"Honda RD1 CR-V 5 (24 ч)",
		"Chevrolet Camaro Z28 (24 ч)",
		"Honda Civic VIII (24 ч)",
		"Mitsubishi Lancer EVO 7 (24 ч)",
		"Lincoln Town Car (24 ч)",
		"BMW Alpina B12 E32 (24 ч)",
		"Mercedes-Benz w211 (24 ч)",
		"Jeep Cherokee 1993 (24 ч)",
		"Lamborghini LM002 (24 ч)",
		"Jeep Wrangler Rubicon (24 ч)",
		"Mercedes-Benz X-Class (24 ч)",
		"Mercedes-Benz 500 SL R107 (24 ч)",
		"Dodge Charger Police (24 ч)",
		"Toyota Chaser Tourer v 100 (24 ч)",
		"Mercedes Benz g500 Police (24 ч)",
		"Mazda RX7 Veilside (24 ч)",
		"Subaru Levorg (24 ч)",
		"Subaru Impreza II WRX STi (24 ч)",
		"Land Rover Range Rover III (24 ч)",
		"Hummer H2 (24 ч)",
		"Tank 500 (24 ч)",
		"Toyota Altezza (24 ч)",
		"Zeekr 001 (24 ч)",
		"Hummer H3T Alpha (24 ч)",
		"Toyota Land Cruiser 200 (24 ч)",
		"Mercedes-Benz GLS 400 (24 ч)",
		"Volkswagen Touareg 2022 (24 ч)",
		"Hyundai Grandeur (24 ч)",
		"Audi RS Q e-tron Dacar (24 ч)",
		"Ford Explorer (24 ч)",
		"Ford Mondeo (24 ч)",
		"Mercedes-Benz G63 AMG (24 ч)",
		"Xiaomi su7 (24 ч)",
		"Ferrari 308 GTB (24 ч)",
		"Mercedes-Benz G63 AMG 6x6 (24 ч)",
		"",
		"",
		"",
		"",
		"",
		"",
		""
	},

	// Case 27 names
	{
		"Dodge Demon SRT (24 ч)",
		"Dodge Viper GTC (24 ч)",
		"Mercedes-AMG E63 S Wagon (24 ч)",
		"Mercedes-Benz SL65 AMG (24 ч)",
		"BMW M8 Competition Coupe (24 ч)",
		"Mercedes AMG GT (24 ч)",
		"Lamborghini Reventon (24 ч)",
		"Ferrari F50 (24 ч)",
		"Alfa Romeo Guilia (24 ч)",
		"Ford Mustang GT3 (24 ч)",
		"Nissan GT-R R35 (24 ч)",
		"Audi R8 V10 (24 ч)",
		"Chevrolet Corvette C8 (24 ч)",
		"Audi R8 LMS GT2 (24 ч)",
		"SCG 003 (24 ч)",
		"Lamborghini Aventador S (24 ч)",
		"Ferrari 812 Superfast (24 ч)",
		"Lincoln Phaeton HOT-ROD 1932 (24 ч)",
		"BMW M4 CSL (24 ч)",
		"Lamborghini Aventador SV 2017 (24 ч)",
		"Porsche 918 Spyder (24 ч)",
		"Koenigsegg CCXR (24 ч)",
		"Ferrari SF90 Stradale Spider (24 ч)",
		"Lamborghini Countach (2022) (24 ч)",
		"BMW M5 F90 (24 ч)",
		"McLaren P1 (24 ч)",
		"Toyota Custom BodyKit (24 ч)",
		"Bugatti Centodieci (24 ч)",
		"Lamborghini Centenario (24 ч)",
		"Lamborghini Veneno 2013 (24 ч)",
		"Porsche Mission R (24 ч)",
		"Bugatti Divo (24 ч)",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		"",
		""
},
// Case 28 names
{
"Неоновые очки",
"Темная панама с сигарой",
"Очки 'Санрайз у воды'",
"Хоуми с района",
"Бархатные тяги особые",
"Крылья ангела",
"700 BC",
"BMW X5 E53",
"900000 Р",
"Тропиксы Х5000",
"Мент из клипа",
"Тропиксы Х7500",
"FORD Mustang GT",
"Volvo V60",
"BMW M5 F10",
"Солнечная тусовщица",
"Infiniti Q60S",
"Пляжное полотенце",
"Пляжный заводила",
"Сумка Божья коровка",
"Тропиксы Х15000",
"Audi Q7",
"DODGE DEMON SRT",
"Range Rover SVR",
"BMW M5 G90",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
""
},
// Case 29 names
{
"Неоновые очки",
"Белая панама с сигарой",
"Очки 'Санрайз у воды'",
"Хоуми с района",
"Бархатные тяги особые",
"Надувной жилет",
"700 BC",
"BMW X5 E53",
"900000 Р",
"Тропиксы Х5000",
"Мент из клипа",
"Тропиксы Х7500",
"FORD Mustang GT",
"Volvo V60",
"BMW M5 F10",
"Infiniti Q60S",
"Азамат Весельчак",
"Летняя милаха",
"Сумка Аквариум",
"Маска Тики",
"Тропиксы Х15000",
"Audi Q7",
"DODGE DEMON SRT",
"Range Rover SVR",
"McLaren Senna",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
"",
""
}

};

new pCasesDust[MAX_PLAYERS];
new pCasesOpened[MAX_PLAYERS];
new pCasesSelected[MAX_PLAYERS];
new pCasesTutorial[MAX_PLAYERS];
new pCasesCounts[MAX_PLAYERS][MAX_CASES];
new pCasesOpenedByCase[MAX_PLAYERS][MAX_CASES];
new pCasesBonusStatus[MAX_PLAYERS][MAX_CASES][MAX_BONUS_PER_CASE];
new pCasesGUIOpen[MAX_PLAYERS];
new pCasesLastAction[MAX_PLAYERS];
new pCasesLastOpenedIdx[MAX_PLAYERS];
new pCasesPendingRewards[MAX_PLAYERS][10];
new pCasesPendingCount[MAX_PLAYERS];

new CaseData[MAX_CASES][E_CASE_DATA];
new CaseAwards[MAX_CASES][MAX_AWARDS_PER_CASE][E_CASE_AWARD];
new CaseBonus[MAX_CASES][MAX_BONUS_PER_CASE][E_CASE_BONUS];

forward Cases_OnPlayerLoad(playerid);

stock Cases_GiveDust(playerid, amount)
{
    if(amount <= 0) return 0;
    SetPlayerData(playerid, P_DUST, GetPlayerData(playerid, P_DUST) + amount);
    UpdatePlayerDatabaseInt(playerid, "dust", GetPlayerData(playerid, P_DUST));
    return 1;
}

stock Cases_AddToPlayer(playerid, caseIdx, amount)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(caseIdx < 0 || caseIdx >= MAX_CASES) return 0;
    if(amount <= 0) return 0;
    SetPlayerCaseCountByType(playerid, caseIdx, amount);
    return 1;
}

// Функция для получения имени награды по ID кейса и ID награды
stock Cases_GetAwardName(caseIdx, awardId, dest[], len)
{
    if(caseIdx < 0 || caseIdx >= 30) return 0;
    
    for(new i = 0; i < CaseData[caseIdx][cAwardsCount]; i++)
    {
        if(CaseAwards[caseIdx][i][aId] == awardId)
        {
            if(strlen(CaseAwardNames[caseIdx][i]) > 0)
            {
                strcpy(dest, CaseAwardNames[caseIdx][i], len);
                return 1;
            }
        }
    }
    return 0;
}

// Функция для получения имени награды по ID (поиск по всем кейсам)
stock Cases_GetAwardNameForId(awardId, dest[], len)
{
    for(new c = 0; c < 30; c++)
    {
        for(new i = 0; i < CaseData[c][cAwardsCount]; i++)
        {
            if(CaseAwards[c][i][aId] == awardId)
            {
                if(strlen(CaseAwardNames[c][i]) > 0)
                {
                    strcpy(dest, CaseAwardNames[c][i], len);
                    return 1;
                }
            }
        }
    }
    format(dest, len, "Награда #%d", awardId);
    return 0;
}

// Функция для получения имени бонуса
stock Cases_GetBonusName(caseIdx, bonusIdx, dest[], len)
{
    if(caseIdx < 0 || caseIdx >= 30) return 0;
    if(bonusIdx < 0 || bonusIdx >= MAX_BONUS_PER_CASE) return 0;
    
    // Можно создать отдельный массив для имен бонусов или формировать имя
    format(dest, len, "Бонус #%d", CaseBonus[caseIdx][bonusIdx][bId]);
    return 1;
}

stock Cases_GivePlayerCaseById(playerid, caseId, amount)
{
    new idx = Cases_GetIndex(caseId);
    if(idx == -1) return 0;
    Cases_AddToPlayer(playerid, idx, amount);
    Cases_SavePlayer(playerid);
    if(pCasesGUIOpen[playerid]) Cases_UpdateGUI(playerid);
    return 1;
}

stock Cases_FindAwardById(playerid, rewardId, &rewardType, &rewardValue, &rewardCount, &rewardRarity)
{
    new lastIdx = pCasesLastOpenedIdx[playerid];
    if(lastIdx >= 0 && lastIdx < MAX_CASES)
    {
        for(new i = 0; i < CaseData[lastIdx][cAwardsCount]; i++)
        {
            if(CaseAwards[lastIdx][i][aId] == rewardId)
            {
                rewardType = CaseAwards[lastIdx][i][aType];
                rewardValue = CaseAwards[lastIdx][i][aInternalId];
                rewardCount = CaseAwards[lastIdx][i][aCount];
                rewardRarity = CaseAwards[lastIdx][i][aRarity];
                return 1;
            }
        }
    }

    for(new c = 0; c < MAX_CASES; c++)
    {
        for(new i = 0; i < CaseData[c][cAwardsCount]; i++)
        {
            if(CaseAwards[c][i][aId] == rewardId)
            {
                rewardType = CaseAwards[c][i][aType];
                rewardValue = CaseAwards[c][i][aInternalId];
                rewardCount = CaseAwards[c][i][aCount];
                rewardRarity = CaseAwards[c][i][aRarity];
                return 1;
            }
        }
    }
    return 0;
}

stock Cases_EmitReward(playerid, rewardType, rewardValue, rewardCount, rewardRarity, isBonus, const rewardName[] = "")
{
    // Если имя не передано, формируем стандартное
    new name[64];
    if(strlen(rewardName) == 0)
    {
        switch(rewardType)
        {
            case REWARD_TYPE_MONEY: format(name, sizeof(name), "Деньги из кейса");
            case REWARD_TYPE_BC: format(name, sizeof(name), "Black-Coins из кейса");
            case REWARD_TYPE_EXP: format(name, sizeof(name), "Опыт из кейса");
            case REWARD_TYPE_BP_EXP: format(name, sizeof(name), "BP опыт из кейса");
            case REWARD_TYPE_DUST: format(name, sizeof(name), "Пыль из кейса");
            case REWARD_TYPE_VEHICLE: format(name, sizeof(name), "Автомобиль из кейса");
            case REWARD_TYPE_VIP: format(name, sizeof(name), "VIP из кейса");
            case REWARD_TYPE_ITEM: format(name, sizeof(name), "Предмет из кейса");
            case REWARD_TYPE_CASE: format(name, sizeof(name), "Кейс из кейса");
            default: format(name, sizeof(name), "Награда из кейса");
        }
    }
    else
    {
        strcpy(name, rewardName, sizeof(name));
    }
    
    // Выдаём через BPR систему с именем
    Cases_GiveRewardViaBPR(playerid, rewardType, rewardValue, rewardCount, rewardRarity, name);
    
    // Для отладки
    printf("[Cases] Reward given: type=%d, value=%d, count=%d, rarity=%d, name=%s", 
        rewardType, rewardValue, rewardCount, rewardRarity, name);
    
    return 1;
}

stock Cases_GiveRewardViaBPR(playerid, rewardType, rewardValue, rewardCount, rewardRarity, const rewardName[] = "")
{
    // Определяем название награды для отображения
    new name[64];
    if(strlen(rewardName) == 0)
    {
        switch(rewardType)
        {
            case REWARD_TYPE_MONEY: format(name, sizeof(name), "Деньги из кейса");
            case REWARD_TYPE_BC: format(name, sizeof(name), "Black-Coins из кейса");
            case REWARD_TYPE_EXP: format(name, sizeof(name), "Опыт из кейса");
            case REWARD_TYPE_BP_EXP: format(name, sizeof(name), "BP опыт из кейса");
            case REWARD_TYPE_DUST: format(name, sizeof(name), "Пыль из кейса");
            case REWARD_TYPE_VEHICLE: format(name, sizeof(name), "Автомобиль из кейса");
            case REWARD_TYPE_VIP: format(name, sizeof(name), "VIP из кейса");
            case REWARD_TYPE_ITEM: format(name, sizeof(name), "Предмет из кейса");
            case REWARD_TYPE_CASE: format(name, sizeof(name), "Кейс из кейса");
            default: format(name, sizeof(name), "Награда из кейса");
        }
    }
    else
    {
        strcpy(name, rewardName, sizeof(name));
    }
    
    // Определяем срок действия для предметов
    new days = 30;
    
    switch(rewardType)
    {
        case REWARD_TYPE_EXP:  // Опыт
        {
            BPR_GiveReward(playerid, 1, 1, name, rewardRarity, rewardCount, -1, 0, -1);
            printf("[Cases] Player %d received %d EXP via BPR (name: %s)", playerid, rewardCount, name);
            return 1;
        }
        
        case REWARD_TYPE_MONEY:  // Деньги
        {
            BPR_GiveReward(playerid, 2, 1, name, rewardRarity, rewardCount, -1, 0, -1);
            printf("[Cases] Player %d received $%d via BPR (name: %s)", playerid, rewardCount, name);
            return 1;
        }
        
        case REWARD_TYPE_BC:  // Black Coins
        {
            BPR_GiveReward(playerid, 3, 1, name, rewardRarity, rewardCount, -1, 0, -1);
            printf("[Cases] Player %d received %d BC via BPR (name: %s)", playerid, rewardCount, name);
            return 1;
        }
        
        case REWARD_TYPE_CASE:  // Кейс
        {
            BPR_GiveReward(playerid, 4, rewardValue, name, rewardRarity, rewardCount, -1, 0, -1);
            printf("[Cases] Player %d received case ID %d via BPR (name: %s)", playerid, rewardValue, name);
            return 1;
        }
        
        case REWARD_TYPE_VEHICLE:  // Машина
        {
            BPR_GiveCar(playerid, rewardValue, name, rewardRarity, -1, -1);
            printf("[Cases] Player %d received car model %d via BPR (name: %s)", playerid, rewardValue, name);
            return 1;
        }
        
        case REWARD_TYPE_VIP:  // VIP
        {
            BPR_GiveReward(playerid, 9, rewardValue, name, rewardRarity, rewardCount, -1, 0, -1);
            printf("[Cases] Player %d received VIP type %d for %d days via BPR (name: %s)", playerid, rewardValue, rewardCount, name);
            return 1;
        }
        
        case REWARD_TYPE_BP_EXP:  // BP Опыт
        {
            BPR_GiveReward(playerid, 10, 1, name, rewardRarity, rewardCount, -1, 0, -1);
            printf("[Cases] Player %d received %d BP EXP via BPR (name: %s)", playerid, rewardCount, name);
            return 1;
        }
        
        case REWARD_TYPE_ITEM:  // Предмет в инвентарь
        {
            // Проверяем, является ли предмет скином (internalId == 134)
            if(rewardValue == 134)
            {
                // Это скин - rewardCount содержит ID скина
                BPR_GiveSkin(playerid, rewardCount, name, rewardRarity, -1, 0);
                printf("[Cases] Player %d received skin ID %d via BPR (name: %s)", playerid, rewardCount, name);
            }
            else
            {
                // Это аксессуар
                BPR_GiveAccessory(playerid, rewardValue, rewardValue, name, rewardRarity, -1, 0);
                printf("[Cases] Player %d received item ID %d via BPR (name: %s)", playerid, rewardValue, name);
            }
            return 1;
        }
        
        case REWARD_TYPE_DUST:  // Пыль
        {
            Cases_GiveDust(playerid, rewardCount);
            printf("[Cases] Player %d received %d dust via Cases_GiveDust (name: %s)", playerid, rewardCount, name);
            return 1;
        }
        
        default:
        {
            // Для неизвестных типов - пробуем выдать через старую систему
            BPR_GiveReward(playerid, rewardType, rewardValue, name, rewardRarity, rewardCount, days, 0, -1);
            printf("[Cases] Player %d received unknown type %d via BPR (name: %s)", playerid, rewardType, name);
            return 1;
        }
    }
}


stock Cases_Init()
{
    // ОБНУЛЯЕМ ВСЕ КЕЙСЫ ПЕРЕД ИНИЦИАЛИЗАЦИЕЙ
    for(new i = 0; i < MAX_CASES; i++) {
        CaseData[i][cId] = 0;
    }
    
    // КЕЙС 1: Ежедневный
    CaseData[0][cId] = 1;
    CaseData[0][cPriceOne] = 15;
    CaseData[0][cPriceTen] = 150;
    CaseData[0][cDiscountOne] = 0;
    CaseData[0][cDiscountTen] = 0;
    CaseData[0][cAwardsCount] = 20;
    CaseData[0][cBonusCount] = 5;
    Cases_InitCase1Awards();
    Cases_InitCase1Bonus();
    
    // КЕЙС 2: Бомжа
    CaseData[1][cId] = 2;
    CaseData[1][cPriceOne] = 100;
    CaseData[1][cPriceTen] = 1000;
    CaseData[1][cDiscountOne] = 0;
    CaseData[1][cDiscountTen] = 0;
    CaseData[1][cAwardsCount] = 27;
    CaseData[1][cBonusCount] = 5;
    Cases_InitCase2Awards();
    Cases_InitCase2Bonus();
    
    // КЕЙС 3: Стандартный
    CaseData[2][cId] = 3;
    CaseData[2][cPriceOne] = 700;
    CaseData[2][cPriceTen] = 7000;
    CaseData[2][cDiscountOne] = 0;
    CaseData[2][cDiscountTen] = 0;
    CaseData[2][cAwardsCount] = 37;
    CaseData[2][cBonusCount] = 5;
    Cases_InitCase3Awards();
    Cases_InitCase3Bonus();
    
    // КЕЙС 4: Авто-кейс
    CaseData[3][cId] = 4;
    CaseData[3][cPriceOne] = 1200;
    CaseData[3][cPriceTen] = 12000;
    CaseData[3][cDiscountOne] = 0;
    CaseData[3][cDiscountTen] = 5;
    CaseData[3][cAwardsCount] = 37;
    CaseData[3][cBonusCount] = 5;
    Cases_InitCase4Awards();
    Cases_InitCase4Bonus();
    
    // КЕЙС 5: Особый
    CaseData[4][cId] = 5;
    CaseData[4][cPriceOne] = 10000;
    CaseData[4][cPriceTen] = 100000;
    CaseData[4][cDiscountOne] = 0;
    CaseData[4][cDiscountTen] = 0;
    CaseData[4][cAwardsCount] = 22;
    CaseData[4][cBonusCount] = 5;
    Cases_InitCase5Awards();
    Cases_InitCase5Bonus();

    // КЕЙС 6: Драйв
    CaseData[5][cId] = 6;
    CaseData[5][cPriceOne] = 900;
    CaseData[5][cPriceTen] = 9000;
    CaseData[5][cDiscountOne] = 0;
    CaseData[5][cDiscountTen] = 5;
    CaseData[5][cAwardsCount] = 25;
    CaseData[5][cBonusCount] = 5;
    Cases_InitCase6();
    
    // КЕЙСЫ 7-19: Инициализируем все подряд
    for(new c = 6; c < MAX_CASES; c++) {
        CaseData[c][cId] = c + 1;  // 7, 8, 9... 19
        CaseData[c][cPriceOne] = 900;
        CaseData[c][cPriceTen] = 9000;
        CaseData[c][cDiscountOne] = 0;
        CaseData[c][cDiscountTen] = 5;
        CaseData[c][cAwardsCount] = 25;
        CaseData[c][cBonusCount] = 5;
        
        for(new i = 0; i < 25; i++) {
            CaseAwards[c][i][aId] = i + 1;
            CaseAwards[c][i][aRarity] = (i < 10) ? 2 : ((i < 18) ? 3 : ((i < 23) ? 4 : 5));
            CaseAwards[c][i][aType] = (i % 3 == 0) ? 5 : ((i % 3 == 1) ? 11 : 2);
            CaseAwards[c][i][aInternalId] = 500 + i;
            CaseAwards[c][i][aCount] = (CaseAwards[c][i][aType] == 2) ? 100000 * (i + 1) : 1;
            CaseAwards[c][i][aPriceSprayed] = 100 + (i * 10);
        }
        
        CaseBonus[c][0][bId] = (c+1)*100+1; 
        CaseBonus[c][0][bNumberOpen] = 40; 
        CaseBonus[c][0][bRarity] = 5; 
        CaseBonus[c][0][bType] = 5; 
        CaseBonus[c][0][bInternalId] = 600+c; 
        CaseBonus[c][0][bCount] = 0; 
        CaseBonus[c][0][bPriceSprayed] = 300;
        
        CaseBonus[c][1][bId] = (c+1)*100+2; 
        CaseBonus[c][1][bNumberOpen] = 30; 
        CaseBonus[c][1][bRarity] = 4; 
        CaseBonus[c][1][bType] = 21; 
        CaseBonus[c][1][bInternalId] = 1; 
        CaseBonus[c][1][bCount] = 350; 
        CaseBonus[c][1][bPriceSprayed] = 0;
        
        CaseBonus[c][2][bId] = (c+1)*100+3; 
        CaseBonus[c][2][bNumberOpen] = 20; 
        CaseBonus[c][2][bRarity] = 4; 
        CaseBonus[c][2][bType] = 4; 
        CaseBonus[c][2][bInternalId] = c+1; 
        CaseBonus[c][2][bCount] = 2; 
        CaseBonus[c][2][bPriceSprayed] = 0;
        
        CaseBonus[c][3][bId] = (c+1)*100+4; 
        CaseBonus[c][3][bNumberOpen] = 10; 
        CaseBonus[c][3][bRarity] = 4; 
        CaseBonus[c][3][bType] = 21; 
        CaseBonus[c][3][bInternalId] = 1; 
        CaseBonus[c][3][bCount] = 200; 
        CaseBonus[c][3][bPriceSprayed] = 0;
        
        CaseBonus[c][4][bId] = (c+1)*100+5; 
        CaseBonus[c][4][bNumberOpen] = 5; 
        CaseBonus[c][4][bRarity] = 4; 
        CaseBonus[c][4][bType] = 4; 
        CaseBonus[c][4][bInternalId] = c+1; 
        CaseBonus[c][4][bCount] = 1; 
        CaseBonus[c][4][bPriceSprayed] = 0;
    }
    
    // ВЫВОДИМ СПИСОК ИНИЦИАЛИЗИРОВАННЫХ КЕЙСОВ
    printf("[Cases] ===== INITIALIZED CASES =====");
    for(new i = 0; i < MAX_CASES; i++) {
        if(CaseData[i][cId] != 0) {
            printf("[Cases] Index %d: Case ID = %d, Awards = %d, Bonus = %d", 
                i, CaseData[i][cId], CaseData[i][cAwardsCount], CaseData[i][cBonusCount]);
        }
    }
    printf("[Cases] =============================");
    printf("[Cases] System initialized with %d cases", MAX_CASES);
    return 1;
}


stock Cases_GetIndex(caseId)
{
    for(new i = 0; i < MAX_CASES; i++) {
        if(CaseData[i][cId] == caseId) return i;
    }
    return -1;
}

stock GetPlayerCaseCountByType(playerid, case_type)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    new idx = Cases_GetIndex(case_type);
    if(idx == -1) return 0;
    return pCasesCounts[playerid][idx];
}

stock SetPlayerCaseCountByType(playerid, case_type, value)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    if(value < 0) value = 0;

    new idx = Cases_GetIndex(case_type);
    if(idx == -1) return 0;
    pCasesCounts[playerid][idx] = value;
    if(case_type == 0) {
        SetPlayerData(playerid, P_COUNT_TODAY_CASE, value);
        UpdatePlayerDatabaseInt(playerid, "counttodaycases", value);
    } else if(case_type == 1) {
        SetPlayerData(playerid, P_COUNT_BOMJ_CASE, value);
        UpdatePlayerDatabaseInt(playerid, "countbomjcases", value);
    } else if(case_type == 2) {
        SetPlayerData(playerid, P_COUNT_STANDART_CASE, value);
        UpdatePlayerDatabaseInt(playerid, "countstancases", value);
    } else if(case_type == 3) {
        SetPlayerData(playerid, P_COUNT_CAR_CASE, value);
        UpdatePlayerDatabaseInt(playerid, "countcarcases", value);
    } else if(case_type == 4) {
        SetPlayerData(playerid, P_COUNT_OSOBIY_CASE, value);
        UpdatePlayerDatabaseInt(playerid, "countosobcases", value);
    } else if(case_type == 5) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE1, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases1", value);
    } else if(case_type == 6) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE2, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases2", value);
    } else if(case_type == 7) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE3, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases3", value);
    } else if(case_type == 8) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE4, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases4", value);
    } else if(case_type == 9) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE5, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases5", value);
    } else if(case_type == 10) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE6, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases6", value);
    } else if(case_type == 11) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE7, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases7", value);
    } else if(case_type == 12) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE8, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases8", value);
    } else if(case_type == 13) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE9, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases9", value);
    } else if(case_type == 14) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE10, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases10", value);
    } else if(case_type == 15) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE11, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases11", value);
    } else if(case_type == 16) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE12, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases12", value);
    } else if(case_type == 17) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE13, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases13", value);
    } else if(case_type == 18) {
        SetPlayerData(playerid, P_COUNT_DOP_CASE14, value);
        UpdatePlayerDatabaseInt(playerid, "countdopcases14", value);
    }
    return 1;
}

stock AddPlayerCaseCountByType(playerid, case_type, amount)
{
    return SetPlayerCaseCountByType(playerid, case_type, GetPlayerCaseCountByType(playerid, case_type) + amount);
}

stock Cases_OnPlayerConnect(playerid)
{
	GetPlayerData(playerid, P_DUST) = 0;
	pCasesOpened[playerid] = 0;
	pCasesSelected[playerid] = 1;
	pCasesTutorial[playerid] = 0;
	pCasesGUIOpen[playerid] = 0;
	pCasesLastAction[playerid] = 0;
	pCasesPendingCount[playerid] = 0;
	pCasesLastOpenedIdx[playerid] = 0;
	
	for(new i = 0; i < MAX_CASES; i++) {
        pCasesCounts[playerid][i] = 0;
		for(new j = 0; j < MAX_BONUS_PER_CASE; j++) {
			pCasesBonusStatus[playerid][i][j] = 1;
		}
	}
	
	for(new i = 0; i < 10; i++) {
		pCasesPendingRewards[playerid][i] = 0;
	}
	
	return 1;
}

stock GetCaseOpenedCount(playerid, caseIdx)  // caseIdx от 0 до 18
{
    switch(caseIdx)
    {
        case 0: return GetPlayerData(playerid, P_OPENED_CASES_1);
        case 1: return GetPlayerData(playerid, P_OPENED_CASES_2);
        case 2: return GetPlayerData(playerid, P_OPENED_CASES_3);
        case 3: return GetPlayerData(playerid, P_OPENED_CASES_4);
        case 4: return GetPlayerData(playerid, P_OPENED_CASES_5);
        case 5: return GetPlayerData(playerid, P_OPENED_CASES_6);
        case 6: return GetPlayerData(playerid, P_OPENED_CASES_7);
        case 7: return GetPlayerData(playerid, P_OPENED_CASES_8);
        case 8: return GetPlayerData(playerid, P_OPENED_CASES_9);
        case 9: return GetPlayerData(playerid, P_OPENED_CASES_10);
        case 10: return GetPlayerData(playerid, P_OPENED_CASES_11);
        case 11: return GetPlayerData(playerid, P_OPENED_CASES_12);
        case 12: return GetPlayerData(playerid, P_OPENED_CASES_13);
        case 13: return GetPlayerData(playerid, P_OPENED_CASES_14);
        case 14: return GetPlayerData(playerid, P_OPENED_CASES_15);
        case 15: return GetPlayerData(playerid, P_OPENED_CASES_16);
        case 16: return GetPlayerData(playerid, P_OPENED_CASES_17);
        case 17: return GetPlayerData(playerid, P_OPENED_CASES_18);
        case 18: return GetPlayerData(playerid, P_OPENED_CASES_19);
    }
    return 0;
}

stock SetCaseOpenedCount(playerid, caseIdx, value)
{
    switch(caseIdx)
    {
        case 0: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_1, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_1", value);
        }
        case 1: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_2, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_2", value);
        }
        case 2: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_3, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_3", value);
        }
        case 3: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_4, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_4", value);
        }
        case 4: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_5, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_5", value);
        }
        case 5: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_6, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_6", value);
        }
        case 6: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_7, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_7", value);
        }
        case 7: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_8, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_8", value);
        }
        case 8: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_9, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_9", value);
        }
        case 9: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_10, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_10", value);
        }
        case 10: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_11, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_11", value);
        }
        case 11: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_12, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_12", value);
        }
        case 12: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_13, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_13", value);
        }
        case 13: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_14, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_14", value);
        }
        case 14: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_15, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_15", value);
        }
        case 15: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_16, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_16", value);
        }
        case 16: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_17, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_17", value);
        }
        case 17: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_18, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_18", value);
        }
        case 18: 
        {
            SetPlayerData(playerid, P_OPENED_CASES_19, value);
            UpdatePlayerDatabaseInt(playerid, "opened_cases_19", value);
        }
    }
    return 1;
}

stock AddCaseOpenedCount(playerid, caseIdx, amount)
{
    return SetCaseOpenedCount(playerid, caseIdx, GetCaseOpenedCount(playerid, caseIdx) + amount);
}


stock Cases_GetBonusState(playerid, caseIdx, bonusIdx)
{
    if(pCasesBonusStatus[playerid][caseIdx][bonusIdx] == 3) {
        return 3;
    }
    
    new requiredOpens = CaseBonus[caseIdx][bonusIdx][bNumberOpen];
    if(pCasesOpenedByCase[playerid][caseIdx] >= requiredOpens) {
        if(pCasesBonusStatus[playerid][caseIdx][bonusIdx] != 3) {
            return 2;
        }
    }
    
    return 1;
}

stock Cases_UpdateBonusStates(playerid, caseIdx)
{
    for(new b = 0; b < CaseData[caseIdx][cBonusCount]; b++) {
        if(pCasesBonusStatus[playerid][caseIdx][b] != 3) {
            new requiredOpens = CaseBonus[caseIdx][b][bNumberOpen];
            if(pCasesOpenedByCase[playerid][caseIdx] >= requiredOpens) {
                pCasesBonusStatus[playerid][caseIdx][b] = 2;
            } else {
                pCasesBonusStatus[playerid][caseIdx][b] = 1;
            }
        }
    }
}


stock Cases_BuildCbArray(playerid, Node:cbArray)
{
	for(new c = 0; c < MAX_CASES; c++) {
		for(new b = 0; b < CaseData[c][cBonusCount]; b++) {
			new bonusId = CaseBonus[c][b][bId];
			new bonusState = Cases_GetBonusState(playerid, c, b);
			if(bonusState != 0) {
				new Node:bonusObj = JSON_Object();
				JSON_SetInt(bonusObj, "b", bonusId);
				JSON_SetInt(bonusObj, "state", bonusState);
				new Node:tempArray = JSON_Array(bonusObj);
				cbArray = JSON_Append(cbArray, tempArray);
			}
		}
	}
	return 1;
}

stock Cases_ShowGUI(playerid)
{
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = 0;
    
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerData(playerid, P_DUST));
    JSON_SetInt(json, "bcc", GetCaseOpenedCount(playerid, selectedIdx));
    JSON_SetInt(json, "cs", 2);
    JSON_SetInt(json, "i", 0);
    
    new Node:ccArray = JSON_Array();
    for(new c = 0; c < MAX_CASES; c++) 
	{
		new caseId = CaseData[c][cId];
        if(caseId == 0) continue;
        
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", caseId);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, caseId));
        new Node:tempArray = JSON_Array(cc_obj);
        ccArray = JSON_Append(ccArray, tempArray);
    }
    JSON_SetArray(json, "cc", ccArray);
    
    new Node:cbArray = JSON_Array();
    Cases_BuildCbArray(playerid, cbArray);
    JSON_SetArray(json, "cb", cbArray);
    
    new dbgstr[2054];
    JSON_Stringify(json, dbgstr, sizeof(dbgstr));
    printf("[CASES] ShowGUI response: %s", dbgstr);
    
    ShowPlayerGUI(playerid, 73, json);
    pCasesGUIOpen[playerid] = 1;
    JSON_Cleanup(json);
    return 1;
}

stock Cases_UpdateGUI(playerid)
{
    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = 0;
    
    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(json, "pc", GetPlayerData(playerid, P_DUST));
    JSON_SetInt(json, "bcc", GetCaseOpenedCount(playerid, selectedIdx));
    JSON_SetInt(json, "cs", pCasesSelected[playerid]);
    JSON_SetInt(json, "i", pCasesTutorial[playerid]);
    
    new Node:ccArray = JSON_Array();
    for(new c = 0; c < MAX_CASES; c++) 
	{
		new caseId = CaseData[c][cId];
        if(caseId == 0) continue;
        
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", caseId);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, caseId));
        new Node:tempArray = JSON_Array(cc_obj);
        ccArray = JSON_Append(ccArray, tempArray);
    }
    JSON_SetArray(json, "cc", ccArray);
    
    new Node:cbArray = JSON_Array();
    Cases_BuildCbArray(playerid, cbArray);
    JSON_SetArray(json, "cb", cbArray);
    new dbgstr[2054];
	JSON_Stringify(json, dbgstr, sizeof(dbgstr));
	printf("[CASES] debug otvet: %s", dbgstr);
    SendPacketToClient(playerid, 73, json);
    JSON_Cleanup(json);
    return 1;
}

stock Cases_HideGUI(playerid)
{
	if(!pCasesGUIOpen[playerid]) return 0;
	HidePlayerGUI(playerid, 73);
	pCasesGUIOpen[playerid] = 0;
	return 1;
}


stock Cases_ShowBanner(playerid, bannerId)
{
	new Node:json = JSON_Object(
		"t", JSON_Int(2),
		"s", JSON_Int(0),
		"bid", JSON_Int(bannerId)
	);
	
	ShowPlayerGUI(playerid, 73, json);
	JSON_Cleanup(json);
	return 1;
}


stock Cases_SendPacketToClient(playerid, const jsonData[])
{
	new Node:json;
	if(JSON_Parse(jsonData, json) != 0) return 0;
	
	new closeVal = 0;
	JSON_GetInt(json, "c", closeVal);
	if(closeVal == 1) {
		pCasesGUIOpen[playerid] = 0;
		JSON_Cleanup(json);
		return 1;
	}
	
	new actionType = 0;
	JSON_GetInt(json, "t", actionType);
    new fmtgfd[512];
    format(fmtgfd, sizeof(fmtgfd), "Cases_SendPacketToClient: player %d, actionType %d", playerid, actionType);
   // SendClientMessage(playerid, 0xFFFFFF00, fmtgfd);
  //  ShowNotificationSile(playerid, 2, 7, -1, -1, fmtgfd, "");

	new currentTime = gettime();
	if(actionType == 2 || actionType == 5 || actionType == 1)
	{
		if(currentTime - pCasesLastAction[playerid] < 1)
		{
			JSON_Cleanup(json);
			return 0;
		}
		pCasesLastAction[playerid] = currentTime;
	}
	
	switch(actionType) {
		case 1: {
			new caseId = 0;
			JSON_GetInt(json, "cs", caseId);
			Cases_SelectCase(playerid, caseId);
		}
		case 2: {
			new caseId = 0, openType = 0;
			JSON_GetInt(json, "cs", caseId);
			JSON_GetInt(json, "type", openType);
			Cases_OpenCase(playerid, caseId, openType);
		}
		case 3: {
			Cases_TakeRewards(playerid, jsonData);
		}
		case 4: 
        {
			new donateType = 0;
			JSON_GetInt(json, "d", donateType);
			if(donateType == 2) {
				ShowPlayerDonateDeposit(playerid);
			}
		}
		case 5: {
			//AddPlayerCaseCountByType(playerid, 5, 1);
		}
        case 6: 
        {
            callcmd::reward(playerid);
        }
		case 7: {
			new bonusId = 0;
			JSON_GetInt(json, "b", bonusId);
			Cases_GetBonus(playerid, bonusId);
		}
		case 8: {
			Cases_UpdateGUI(playerid);
		}
	}
	
	JSON_Cleanup(json);
	return 1;
}


stock Cases_SelectCase(playerid, caseId)
{
	new idx = Cases_GetIndex(caseId);
	if(idx == -1) return 0;

	
	pCasesSelected[playerid] = caseId;
	Cases_UpdateGUI(playerid);
	return 1;
}


stock Cases_OpenCase(playerid, caseId, openType)
{
    new idx = Cases_GetIndex(caseId);
    if(idx == -1) return 0;

    if(openType != 1 && openType != 2) {
        openType = 1;
    }
    
    new openCount = (openType == 1) ? 1 : 10;
    new rewardIds[10];
    new useOwnedCases = 0;
   
    new ownedCount = GetPlayerCaseCountByType(playerid, caseId);
    
    printf("[DEBUG] Cases_OpenCase: player %d, caseId %d, owned %d, need %d", playerid, caseId, ownedCount, openCount);
    
    if(ownedCount > 0) {
        if(ownedCount < openCount) {
            new Node:json = JSON_Object();
            JSON_SetInt(json, "t", 2);
            JSON_SetInt(json, "s", -1);
            JSON_SetInt(json, "d", 1);
            SendPacketToClient(playerid, 73, json);
            JSON_Cleanup(json);
            return 0;
        }
        useOwnedCases = 1;
    }
    
    if(useOwnedCases) {
        AddPlayerCaseCountByType(playerid, caseId, -openCount);
        printf("[DEBUG] Used owned cases, new count: %d", GetPlayerCaseCountByType(playerid, caseId));
    } else {
        new price = (openType == 1) ? CaseData[idx][cPriceOne] : CaseData[idx][cPriceTen];
        new discount = (openType == 1) ? CaseData[idx][cDiscountOne] : CaseData[idx][cDiscountTen];
        price = price - (price * discount / 100);
        
        if(GetPlayerDonateRub(playerid) < price) {
            new Node:json = JSON_Object();
            JSON_SetInt(json, "t", 2);
            JSON_SetInt(json, "s", -1);
            JSON_SetInt(json, "d", 1);
            SendPacketToClient(playerid, 73, json);
            JSON_Cleanup(json);
            return 0;
        }
        
        GivePlayerDonateRub(playerid, -price, "Cases: open", true, true);
    }
    
    for(new r = 0; r < openCount; r++) {
        rewardIds[r] = Cases_GetRandomReward(idx);
        pCasesPendingRewards[playerid][r] = rewardIds[r];
    }
    pCasesPendingCount[playerid] = openCount;
    
    pCasesOpened[playerid] += openCount;
    AddCaseOpenedCount(playerid, idx, openCount);
    pCasesLastOpenedIdx[playerid] = idx;
    
    Cases_UpdateBonusStates(playerid, idx);
   
    // Формируем строки для JSON
    new prStr[256], rarStr[256];
    prStr[0] = rarStr[0] = '\0';
    
    for(new r = 0; r < openCount; r++) {
        new tmp[16];
        if(r > 0) {
            strcat(prStr, ",");
            strcat(rarStr, ",");
        }
        format(tmp, sizeof(tmp), "%d", rewardIds[r]);
        strcat(prStr, tmp);
        
        // Находим редкость
        new rarity = 1;
        for(new i = 0; i < CaseData[idx][cAwardsCount]; i++) {
            if(CaseAwards[idx][i][aId] == rewardIds[r]) {
                rarity = CaseAwards[idx][i][aRarity];
                break;
            }
        }
        format(tmp, sizeof(tmp), "%d", rarity);
        strcat(rarStr, tmp);
    }
    
    // Формируем JSON строку
    new jsonStr[1024];
    format(jsonStr, sizeof(jsonStr), 
        "{\"t\":%d,\"s\":1,\"bc\":%d,\"pc\":%d,\"bcc\":%d,\"cs\":%d,\"type\":%d,\"pr\":[%s]}",
        2, GetPlayerDonateRub(playerid), GetPlayerData(playerid, P_DUST),
        pCasesOpenedByCase[playerid][idx], pCasesSelected[playerid], openType, prStr);
    
    printf("[CASES] Sending JSON: %s", jsonStr);
    
    new Node:json;
    if(JSON_Parse(jsonStr, json) != 0) {
        printf("[CASES] ERROR: Failed to parse JSON");
        return 0;
    }

    SendPacketToClient(playerid, 73, json);
    JSON_Cleanup(json);

    BlackPass_OnCaseOpen(playerid);
    
    printf("[Cases] Player %d opened case %d, %d rewards", playerid, caseId, openCount);
    Cases_SavePlayer(playerid);
    return 1;
}

stock Cases_GetRandomReward(caseIdx)
{
	new totalWeight = 0;
	new awardsCount = CaseData[caseIdx][cAwardsCount];
	
	for(new i = 0; i < awardsCount; i++) {
		new rarity = CaseAwards[caseIdx][i][aRarity];
		new weight = 100 - (rarity * 15);
		if(weight < 5) weight = 5;
		totalWeight += weight;
	}
	
	new roll = random(totalWeight);
	new cumulative = 0;
	
	for(new i = 0; i < awardsCount; i++) {
		new rarity = CaseAwards[caseIdx][i][aRarity];
		new weight = 100 - (rarity * 15);
		if(weight < 5) weight = 5;
		cumulative += weight;
		
		if(roll < cumulative) {
			return CaseAwards[caseIdx][i][aId];
		}
	}
	
	return CaseAwards[caseIdx][0][aId];
}


stock Cases_CheckDustReward(playerid)
{
    new rewarded = 0;
    new specialIdx = Cases_GetIndex(5);
    if(specialIdx == -1) return 0;

    while(GetPlayerData(playerid, P_DUST) >= 2000)
    {
        SetPlayerData(playerid, P_DUST, GetPlayerData(playerid, P_DUST) - 2000);
        UpdatePlayerDatabaseInt(playerid, "dust", GetPlayerData(playerid, P_DUST));
        AddPlayerCaseCountByType(playerid, 5, 1);
        rewarded++;
    }

    if(rewarded > 0)
    {
        new str[96];
        format(str, sizeof(str), "Special cases received: %d", rewarded);
        SendClientMessage(playerid, 0xFFFF00FF, str);
        new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
        if(selectedIdx == -1) selectedIdx = specialIdx;
        new Node:json = JSON_Object(
            "t", JSON_Int(5),
            "s", JSON_Int(0),
            "bc", JSON_Int(GetPlayerDonateRub(playerid)),
            "pc", JSON_Int(GetPlayerData(playerid, P_DUST)),
            "bcc", JSON_Int(GetCaseOpenedCount(playerid, selectedIdx))
        );
        SendPacketToClient(playerid, 73, json);
        JSON_Cleanup(json);
        if(pCasesGUIOpen[playerid]) Cases_UpdateGUI(playerid);
        Cases_SavePlayer(playerid);
        return 1;
    }
    return 0;
}


stock Cases_ExtractIntArray(const source[], const key[], dest[], maxCount)
{
    new needle[32];
    format(needle, sizeof(needle), "\"%s\":[", key);
    new start = strfind(source, needle, true);
    if(start == -1) return 0;
    start += strlen(needle);

    new count = 0;
    new len = strlen(source);
    new token[24];
    new tokenLen = 0;

    for(new i = start; i < len && count < maxCount; i++)
    {
        new ch = source[i];
        if(ch == ']')
        {
            if(tokenLen > 0)
            {
                token[tokenLen] = EOS;
                dest[count++] = strval(token);
            }
            break;
        }
        if((ch >= '0' && ch <= '9') || ch == '-')
        {
            if(tokenLen < sizeof(token) - 1) token[tokenLen++] = ch;
        }
        else
        {
            if(tokenLen > 0)
            {
                token[tokenLen] = EOS;
                dest[count++] = strval(token);
                tokenLen = 0;
            }
        }
    }
    return count;
}


stock Cases_SprayReward(playerid, rewardId)
{
    new rewardType, rewardValue, rewardCount, rewardRarity;
    if(!Cases_FindAwardById(playerid, rewardId, rewardType, rewardValue, rewardCount, rewardRarity)) return 0;

    new lastIdx = pCasesLastOpenedIdx[playerid];
    if(lastIdx >= 0 && lastIdx < MAX_CASES)
    {
        for(new i = 0; i < CaseData[lastIdx][cAwardsCount]; i++)
        {
            if(CaseAwards[lastIdx][i][aId] == rewardId)
            {
                SetPlayerData(playerid, P_DUST, GetPlayerData(playerid, P_DUST) + CaseAwards[lastIdx][i][aPriceSprayed]);
                UpdatePlayerDatabaseInt(playerid, "dust", GetPlayerData(playerid, P_DUST));
                return CaseAwards[lastIdx][i][aPriceSprayed];
            }
        }
    }

    for(new c = 0; c < MAX_CASES; c++)
    {
        for(new i = 0; i < CaseData[c][cAwardsCount]; i++)
        {
            if(CaseAwards[c][i][aId] == rewardId)
            {
                SetPlayerData(playerid, P_DUST, GetPlayerData(playerid, P_DUST) + CaseAwards[c][i][aPriceSprayed]);
                UpdatePlayerDatabaseInt(playerid, "dust", GetPlayerData(playerid, P_DUST));
                return CaseAwards[c][i][aPriceSprayed];
            }
        }
    }
    return 0;
}

stock Cases_TakeRewards(playerid, const jsonData[])
{
    new takeRewards[10], sprayRewards[10];
    new takeCount = Cases_ExtractIntArray(jsonData, "bt1", takeRewards, 10);
    new sprayCount = Cases_ExtractIntArray(jsonData, "bt2", sprayRewards, 10);
    new totalDustGained = 0;

    if(takeCount == 0 && sprayCount == 0 && pCasesPendingCount[playerid] > 0)
    {
        for(new i = 0; i < pCasesPendingCount[playerid] && i < 10; i++)
        {
            takeRewards[takeCount++] = pCasesPendingRewards[playerid][i];
        }
    }

    for(new i = 0; i < takeCount; i++)
    {
        if(takeRewards[i] <= 0) continue;

        new rewardType, rewardValue, rewardCount, rewardRarity;
        new awardName[64] = "";
        
        // Ищем награду и получаем её имя
        if(Cases_FindAwardById(playerid, takeRewards[i], rewardType, rewardValue, rewardCount, rewardRarity))
        {
            // Получаем имя награды из массива CaseAwardNames
            new lastIdx = pCasesLastOpenedIdx[playerid];
            if(lastIdx >= 0 && lastIdx < MAX_CASES)
            {
                Cases_GetAwardName(lastIdx, takeRewards[i], awardName, sizeof(awardName));
            }
            
            // Если имя не найдено в текущем кейсе, ищем во всех
            if(strlen(awardName) == 0)
            {
                Cases_GetAwardNameForId(takeRewards[i], awardName, sizeof(awardName));
            }
            
            Cases_EmitReward(playerid, rewardType, rewardValue, rewardCount, rewardRarity, 0, awardName);
        }
    }

    for(new i = 0; i < sprayCount; i++)
    {
        if(sprayRewards[i] > 0) totalDustGained += Cases_SprayReward(playerid, sprayRewards[i]);
    }

    Cases_CheckDustReward(playerid);

    pCasesPendingCount[playerid] = 0;
    for(new i = 0; i < 10; i++) pCasesPendingRewards[playerid][i] = 0;

    Cases_SavePlayer(playerid);

    new selectedIdx = Cases_GetIndex(pCasesSelected[playerid]);
    if(selectedIdx == -1) selectedIdx = 0;

    new Node:response = JSON_Object();
    JSON_SetInt(response, "t", 3);
    JSON_SetInt(response, "s", 1);
    JSON_SetInt(response, "bc", GetPlayerDonateRub(playerid));
    JSON_SetInt(response, "pc", GetPlayerData(playerid, P_DUST));
    JSON_SetInt(response, "bcc", GetCaseOpenedCount(playerid, selectedIdx));

    new Node:ccArray = JSON_Array();
    for(new c = 0; c < MAX_CASES; c++) 
    {
        new caseId = CaseData[c][cId];
        if(caseId == 0) continue;
        
        new Node:cc_obj = JSON_Object();
        JSON_SetInt(cc_obj, "id", caseId);
        JSON_SetInt(cc_obj, "cot", GetPlayerCaseCountByType(playerid, caseId));
        new Node:tempArray = JSON_Array(cc_obj);
        ccArray = JSON_Append(ccArray, tempArray);
    }
    JSON_SetArray(response, "cc", ccArray);
    
    SendPacketToClient(playerid, 73, response);
    JSON_Cleanup(response);

    if(totalDustGained > 0)
    {
        new str[64];
        format(str, sizeof(str), "Dust received: %d", totalDustGained);
        SendClientMessage(playerid, 0xFFFF00FF, str);
    }
    return 1;
}

stock Cases_GetBonus(playerid, bonusId)
{
    new caseIdx = Cases_GetIndex(pCasesSelected[playerid]), bonusIdx = -1;
    if(caseIdx == -1) caseIdx = 0;

    for(new b = 0; b < CaseData[caseIdx][cBonusCount]; b++)
    {
        if(CaseBonus[caseIdx][b][bId] == bonusId)
        {
            bonusIdx = b;
            break;
        }
    }

    if(bonusIdx == -1)
    {
        for(new c = 0; c < MAX_CASES; c++)
        {
            for(new b = 0; b < CaseData[c][cBonusCount]; b++)
            {
                if(CaseBonus[c][b][bId] == bonusId)
                {
                    caseIdx = c;
                    bonusIdx = b;
                    break;
                }
            }
            if(bonusIdx != -1) break;
        }
    }

    if(caseIdx == -1 || bonusIdx == -1)
    {
        new Node:json = JSON_Object("t", JSON_Int(7), "s", JSON_Int(0));
        SendPacketToClient(playerid, 73, json);
        JSON_Cleanup(json);
        return 0;
    }

    if(pCasesBonusStatus[playerid][caseIdx][bonusIdx] == 3)
    {
        new Node:json = JSON_Object("t", JSON_Int(7), "s", JSON_Int(0));
        SendPacketToClient(playerid, 73, json);
        JSON_Cleanup(json);
        return 0;
    }

    new requiredOpens = CaseBonus[caseIdx][bonusIdx][bNumberOpen];
    if(pCasesOpenedByCase[playerid][caseIdx] < requiredOpens)
    {
        new Node:json = JSON_Object("t", JSON_Int(7), "s", JSON_Int(0));
        SendPacketToClient(playerid, 73, json);
        JSON_Cleanup(json);
        return 0;
    }

    pCasesBonusStatus[playerid][caseIdx][bonusIdx] = 3;
    
    // Получаем имя бонуса (если есть в массиве)
    new bonusName[64];
    // Для бонусов можно использовать отдельный массив или формировать имя
    format(bonusName, sizeof(bonusName), "Бонус #%d", bonusId);
    
    // Если есть отдельный массив для бонусов, используйте его
    // Cases_GetBonusName(caseIdx, bonusIdx, bonusName, sizeof(bonusName));
    
    Cases_EmitReward(
        playerid,
        CaseBonus[caseIdx][bonusIdx][bType],
        CaseBonus[caseIdx][bonusIdx][bInternalId],
        CaseBonus[caseIdx][bonusIdx][bCount],
        CaseBonus[caseIdx][bonusIdx][bRarity],
        1,
        bonusName
    );

    new Node:json = JSON_Object(
        "t", JSON_Int(7),
        "s", JSON_Int(1),
        "bc", JSON_Int(GetPlayerDonateRub(playerid)),
        "pc", JSON_Int(GetPlayerData(playerid, P_DUST)),
        "bcc", JSON_Int(GetCaseOpenedCount(playerid, caseIdx))
    );
    SendPacketToClient(playerid, 73, json);
    JSON_Cleanup(json);

    Cases_SavePlayer(playerid);
    return 1;
}


stock Cases_InitCase1Awards()
{
	CaseAwards[0][0][aId]=1; CaseAwards[0][0][aRarity]=1; CaseAwards[0][0][aType]=11; CaseAwards[0][0][aInternalId]=23; CaseAwards[0][0][aCount]=1; CaseAwards[0][0][aPriceSprayed]=10;
	CaseAwards[0][1][aId]=2; CaseAwards[0][1][aRarity]=1; CaseAwards[0][1][aType]=11; CaseAwards[0][1][aInternalId]=22; CaseAwards[0][1][aCount]=1; CaseAwards[0][1][aPriceSprayed]=10;
	CaseAwards[0][2][aId]=3; CaseAwards[0][2][aRarity]=1; CaseAwards[0][2][aType]=10; CaseAwards[0][2][aInternalId]=1; CaseAwards[0][2][aCount]=200; CaseAwards[0][2][aPriceSprayed]=0;
	CaseAwards[0][3][aId]=4; CaseAwards[0][3][aRarity]=1; CaseAwards[0][3][aType]=11; CaseAwards[0][3][aInternalId]=21; CaseAwards[0][3][aCount]=1; CaseAwards[0][3][aPriceSprayed]=10;
	CaseAwards[0][4][aId]=5; CaseAwards[0][4][aRarity]=1; CaseAwards[0][4][aType]=2; CaseAwards[0][4][aInternalId]=1; CaseAwards[0][4][aCount]=2000; CaseAwards[0][4][aPriceSprayed]=0;
	CaseAwards[0][5][aId]=6; CaseAwards[0][5][aRarity]=1; CaseAwards[0][5][aType]=3; CaseAwards[0][5][aInternalId]=1; CaseAwards[0][5][aCount]=5; CaseAwards[0][5][aPriceSprayed]=0;
	CaseAwards[0][6][aId]=7; CaseAwards[0][6][aRarity]=1; CaseAwards[0][6][aType]=2; CaseAwards[0][6][aInternalId]=1; CaseAwards[0][6][aCount]=3000; CaseAwards[0][6][aPriceSprayed]=0;
	CaseAwards[0][7][aId]=8; CaseAwards[0][7][aRarity]=1; CaseAwards[0][7][aType]=3; CaseAwards[0][7][aInternalId]=1; CaseAwards[0][7][aCount]=10; CaseAwards[0][7][aPriceSprayed]=0;
	CaseAwards[0][8][aId]=9; CaseAwards[0][8][aRarity]=1; CaseAwards[0][8][aType]=9; CaseAwards[0][8][aInternalId]=1; CaseAwards[0][8][aCount]=2; CaseAwards[0][8][aPriceSprayed]=10;
	CaseAwards[0][9][aId]=10; CaseAwards[0][9][aRarity]=1; CaseAwards[0][9][aType]=10; CaseAwards[0][9][aInternalId]=1; CaseAwards[0][9][aCount]=300; CaseAwards[0][9][aPriceSprayed]=0;
	CaseAwards[0][10][aId]=11; CaseAwards[0][10][aRarity]=1; CaseAwards[0][10][aType]=1; CaseAwards[0][10][aInternalId]=1; CaseAwards[0][10][aCount]=4; CaseAwards[0][10][aPriceSprayed]=0;
	CaseAwards[0][11][aId]=12; CaseAwards[0][11][aRarity]=1; CaseAwards[0][11][aType]=5; CaseAwards[0][11][aInternalId]=462; CaseAwards[0][11][aCount]=0; CaseAwards[0][11][aPriceSprayed]=20;
	CaseAwards[0][12][aId]=13; CaseAwards[0][12][aRarity]=1; CaseAwards[0][12][aType]=10; CaseAwards[0][12][aInternalId]=1; CaseAwards[0][12][aCount]=500; CaseAwards[0][12][aPriceSprayed]=0;
	CaseAwards[0][13][aId]=14; CaseAwards[0][13][aRarity]=1; CaseAwards[0][13][aType]=2; CaseAwards[0][13][aInternalId]=1; CaseAwards[0][13][aCount]=20000; CaseAwards[0][13][aPriceSprayed]=0;
	CaseAwards[0][14][aId]=15; CaseAwards[0][14][aRarity]=1; CaseAwards[0][14][aType]=3; CaseAwards[0][14][aInternalId]=1; CaseAwards[0][14][aCount]=15; CaseAwards[0][14][aPriceSprayed]=0;
	CaseAwards[0][15][aId]=16; CaseAwards[0][15][aRarity]=1; CaseAwards[0][15][aType]=9; CaseAwards[0][15][aInternalId]=2; CaseAwards[0][15][aCount]=2; CaseAwards[0][15][aPriceSprayed]=10;
	CaseAwards[0][16][aId]=17; CaseAwards[0][16][aRarity]=1; CaseAwards[0][16][aType]=10; CaseAwards[0][16][aInternalId]=1; CaseAwards[0][16][aCount]=500; CaseAwards[0][16][aPriceSprayed]=0;
	CaseAwards[0][17][aId]=18; CaseAwards[0][17][aRarity]=1; CaseAwards[0][17][aType]=2; CaseAwards[0][17][aInternalId]=1; CaseAwards[0][17][aCount]=30000; CaseAwards[0][17][aPriceSprayed]=0;
	CaseAwards[0][18][aId]=19; CaseAwards[0][18][aRarity]=1; CaseAwards[0][18][aType]=1; CaseAwards[0][18][aInternalId]=1; CaseAwards[0][18][aCount]=6; CaseAwards[0][18][aPriceSprayed]=0;
	CaseAwards[0][19][aId]=20; CaseAwards[0][19][aRarity]=1; CaseAwards[0][19][aType]=5; CaseAwards[0][19][aInternalId]=549; CaseAwards[0][19][aCount]=0; CaseAwards[0][19][aPriceSprayed]=20;
}

stock Cases_InitCase1Bonus()
{
	CaseBonus[0][0][bId]=101; CaseBonus[0][0][bNumberOpen]=40; CaseBonus[0][0][bRarity]=4; CaseBonus[0][0][bType]=4; CaseBonus[0][0][bInternalId]=3; CaseBonus[0][0][bCount]=1; CaseBonus[0][0][bPriceSprayed]=0;
	CaseBonus[0][1][bId]=102; CaseBonus[0][1][bNumberOpen]=30; CaseBonus[0][1][bRarity]=3; CaseBonus[0][1][bType]=21; CaseBonus[0][1][bInternalId]=1; CaseBonus[0][1][bCount]=50; CaseBonus[0][1][bPriceSprayed]=0;
	CaseBonus[0][2][bId]=103; CaseBonus[0][2][bNumberOpen]=20; CaseBonus[0][2][bRarity]=2; CaseBonus[0][2][bType]=4; CaseBonus[0][2][bInternalId]=2; CaseBonus[0][2][bCount]=1; CaseBonus[0][2][bPriceSprayed]=0;
	CaseBonus[0][3][bId]=104; CaseBonus[0][3][bNumberOpen]=10; CaseBonus[0][3][bRarity]=1; CaseBonus[0][3][bType]=4; CaseBonus[0][3][bInternalId]=1; CaseBonus[0][3][bCount]=2; CaseBonus[0][3][bPriceSprayed]=0;
	CaseBonus[0][4][bId]=105; CaseBonus[0][4][bNumberOpen]=5; CaseBonus[0][4][bRarity]=1; CaseBonus[0][4][bType]=4; CaseBonus[0][4][bInternalId]=1; CaseBonus[0][4][bCount]=1; CaseBonus[0][4][bPriceSprayed]=0;
}

stock Cases_InitCase2Awards()
{
	CaseAwards[1][0][aId]=1; CaseAwards[1][0][aRarity]=1; CaseAwards[1][0][aType]=5; CaseAwards[1][0][aInternalId]=468; CaseAwards[1][0][aCount]=0; CaseAwards[1][0][aPriceSprayed]=20;
	CaseAwards[1][1][aId]=2; CaseAwards[1][1][aRarity]=1; CaseAwards[1][1][aType]=5; CaseAwards[1][1][aInternalId]=496; CaseAwards[1][1][aCount]=0; CaseAwards[1][1][aPriceSprayed]=20;
	CaseAwards[1][2][aId]=3; CaseAwards[1][2][aRarity]=1; CaseAwards[1][2][aType]=2; CaseAwards[1][2][aInternalId]=1; CaseAwards[1][2][aCount]=75000; CaseAwards[1][2][aPriceSprayed]=0;
	CaseAwards[1][3][aId]=4; CaseAwards[1][3][aRarity]=1; CaseAwards[1][3][aType]=5; CaseAwards[1][3][aInternalId]=28670; CaseAwards[1][3][aCount]=0; CaseAwards[1][3][aPriceSprayed]=20;
	CaseAwards[1][4][aId]=5; CaseAwards[1][4][aRarity]=1; CaseAwards[1][4][aType]=1; CaseAwards[1][4][aInternalId]=1; CaseAwards[1][4][aCount]=8; CaseAwards[1][4][aPriceSprayed]=0;
	CaseAwards[1][5][aId]=6; CaseAwards[1][5][aRarity]=1; CaseAwards[1][5][aType]=5; CaseAwards[1][5][aInternalId]=439; CaseAwards[1][5][aCount]=0; CaseAwards[1][5][aPriceSprayed]=20;
	CaseAwards[1][6][aId]=7; CaseAwards[1][6][aRarity]=1; CaseAwards[1][6][aType]=2; CaseAwards[1][6][aInternalId]=1; CaseAwards[1][6][aCount]=90000; CaseAwards[1][6][aPriceSprayed]=0;
	CaseAwards[1][7][aId]=8; CaseAwards[1][7][aRarity]=1; CaseAwards[1][7][aType]=5; CaseAwards[1][7][aInternalId]=492; CaseAwards[1][7][aCount]=0; CaseAwards[1][7][aPriceSprayed]=20;
	CaseAwards[1][8][aId]=9; CaseAwards[1][8][aRarity]=1; CaseAwards[1][8][aType]=5; CaseAwards[1][8][aInternalId]=547; CaseAwards[1][8][aCount]=0; CaseAwards[1][8][aPriceSprayed]=20;
	CaseAwards[1][9][aId]=10; CaseAwards[1][9][aRarity]=1; CaseAwards[1][9][aType]=5; CaseAwards[1][9][aInternalId]=458; CaseAwards[1][9][aCount]=0; CaseAwards[1][9][aPriceSprayed]=20;
	CaseAwards[1][10][aId]=11; CaseAwards[1][10][aRarity]=1; CaseAwards[1][10][aType]=9; CaseAwards[1][10][aInternalId]=1; CaseAwards[1][10][aCount]=168; CaseAwards[1][10][aPriceSprayed]=20;
	CaseAwards[1][11][aId]=12; CaseAwards[1][11][aRarity]=1; CaseAwards[1][11][aType]=5; CaseAwards[1][11][aInternalId]=491; CaseAwards[1][11][aCount]=0; CaseAwards[1][11][aPriceSprayed]=20;
	CaseAwards[1][12][aId]=13; CaseAwards[1][12][aRarity]=1; CaseAwards[1][12][aType]=5; CaseAwards[1][12][aInternalId]=585; CaseAwards[1][12][aCount]=0; CaseAwards[1][12][aPriceSprayed]=20;
	CaseAwards[1][13][aId]=14; CaseAwards[1][13][aRarity]=1; CaseAwards[1][13][aType]=1; CaseAwards[1][13][aInternalId]=1; CaseAwards[1][13][aCount]=12; CaseAwards[1][13][aPriceSprayed]=0;
	CaseAwards[1][14][aId]=15; CaseAwards[1][14][aRarity]=1; CaseAwards[1][14][aType]=2; CaseAwards[1][14][aInternalId]=1; CaseAwards[1][14][aCount]=120000; CaseAwards[1][14][aPriceSprayed]=0;
	CaseAwards[1][15][aId]=16; CaseAwards[1][15][aRarity]=1; CaseAwards[1][15][aType]=9; CaseAwards[1][15][aInternalId]=2; CaseAwards[1][15][aCount]=72; CaseAwards[1][15][aPriceSprayed]=20;
	CaseAwards[1][16][aId]=17; CaseAwards[1][16][aRarity]=1; CaseAwards[1][16][aType]=5; CaseAwards[1][16][aInternalId]=536; CaseAwards[1][16][aCount]=0; CaseAwards[1][16][aPriceSprayed]=20;
	CaseAwards[1][17][aId]=18; CaseAwards[1][17][aRarity]=1; CaseAwards[1][17][aType]=5; CaseAwards[1][17][aInternalId]=529; CaseAwards[1][17][aCount]=0; CaseAwards[1][17][aPriceSprayed]=20;
	CaseAwards[1][18][aId]=19; CaseAwards[1][18][aRarity]=1; CaseAwards[1][18][aType]=9; CaseAwards[1][18][aInternalId]=3; CaseAwards[1][18][aCount]=72; CaseAwards[1][18][aPriceSprayed]=20;
	CaseAwards[1][19][aId]=20; CaseAwards[1][19][aRarity]=1; CaseAwards[1][19][aType]=5; CaseAwards[1][19][aInternalId]=542; CaseAwards[1][19][aCount]=0; CaseAwards[1][19][aPriceSprayed]=20;
	CaseAwards[1][20][aId]=21; CaseAwards[1][20][aRarity]=1; CaseAwards[1][20][aType]=5; CaseAwards[1][20][aInternalId]=421; CaseAwards[1][20][aCount]=0; CaseAwards[1][20][aPriceSprayed]=20;
	CaseAwards[1][21][aId]=22; CaseAwards[1][21][aRarity]=2; CaseAwards[1][21][aType]=5; CaseAwards[1][21][aInternalId]=2618; CaseAwards[1][21][aCount]=0; CaseAwards[1][21][aPriceSprayed]=30;
	CaseAwards[1][22][aId]=23; CaseAwards[1][22][aRarity]=2; CaseAwards[1][22][aType]=5; CaseAwards[1][22][aInternalId]=419; CaseAwards[1][22][aCount]=0; CaseAwards[1][22][aPriceSprayed]=30;
	CaseAwards[1][23][aId]=24; CaseAwards[1][23][aRarity]=3; CaseAwards[1][23][aType]=11; CaseAwards[1][23][aInternalId]=705; CaseAwards[1][23][aCount]=1; CaseAwards[1][23][aPriceSprayed]=30;
	CaseAwards[1][24][aId]=25; CaseAwards[1][24][aRarity]=2; CaseAwards[1][24][aType]=5; CaseAwards[1][24][aInternalId]=546; CaseAwards[1][24][aCount]=0; CaseAwards[1][24][aPriceSprayed]=30;
	CaseAwards[1][25][aId]=26; CaseAwards[1][25][aRarity]=3; CaseAwards[1][25][aType]=11; CaseAwards[1][25][aInternalId]=706; CaseAwards[1][25][aCount]=1; CaseAwards[1][25][aPriceSprayed]=30;
	CaseAwards[1][26][aId]=27; CaseAwards[1][26][aRarity]=3; CaseAwards[1][26][aType]=11; CaseAwards[1][26][aInternalId]=134; CaseAwards[1][26][aCount]=6810; CaseAwards[1][26][aPriceSprayed]=40;
}

stock Cases_InitCase2Bonus()
{
	CaseBonus[1][0][bId]=201; CaseBonus[1][0][bNumberOpen]=40; CaseBonus[1][0][bRarity]=5; CaseBonus[1][0][bType]=5; CaseBonus[1][0][bInternalId]=467; CaseBonus[1][0][bCount]=0; CaseBonus[1][0][bPriceSprayed]=100;
	CaseBonus[1][1][bId]=202; CaseBonus[1][1][bNumberOpen]=30; CaseBonus[1][1][bRarity]=3; CaseBonus[1][1][bType]=21; CaseBonus[1][1][bInternalId]=1; CaseBonus[1][1][bCount]=100; CaseBonus[1][1][bPriceSprayed]=0;
	CaseBonus[1][2][bId]=203; CaseBonus[1][2][bNumberOpen]=20; CaseBonus[1][2][bRarity]=3; CaseBonus[1][2][bType]=4; CaseBonus[1][2][bInternalId]=2; CaseBonus[1][2][bCount]=2; CaseBonus[1][2][bPriceSprayed]=0;
	CaseBonus[1][3][bId]=204; CaseBonus[1][3][bNumberOpen]=10; CaseBonus[1][3][bRarity]=3; CaseBonus[1][3][bType]=21; CaseBonus[1][3][bInternalId]=1; CaseBonus[1][3][bCount]=50; CaseBonus[1][3][bPriceSprayed]=0;
	CaseBonus[1][4][bId]=205; CaseBonus[1][4][bNumberOpen]=5; CaseBonus[1][4][bRarity]=3; CaseBonus[1][4][bType]=4; CaseBonus[1][4][bInternalId]=2; CaseBonus[1][4][bCount]=1; CaseBonus[1][4][bPriceSprayed]=0;
}

stock Cases_InitCase3Awards()
{
	CaseAwards[2][0][aId]=1; CaseAwards[2][0][aRarity]=2; CaseAwards[2][0][aType]=11; CaseAwards[2][0][aInternalId]=363; CaseAwards[2][0][aCount]=1; CaseAwards[2][0][aPriceSprayed]=90;
	CaseAwards[2][1][aId]=2; CaseAwards[2][1][aRarity]=2; CaseAwards[2][1][aType]=9; CaseAwards[2][1][aInternalId]=2; CaseAwards[2][1][aCount]=504; CaseAwards[2][1][aPriceSprayed]=90;
	CaseAwards[2][2][aId]=3; CaseAwards[2][2][aRarity]=2; CaseAwards[2][2][aType]=2; CaseAwards[2][2][aInternalId]=1; CaseAwards[2][2][aCount]=600000; CaseAwards[2][2][aPriceSprayed]=0;
	CaseAwards[2][3][aId]=4; CaseAwards[2][3][aRarity]=2; CaseAwards[2][3][aType]=11; CaseAwards[2][3][aInternalId]=360; CaseAwards[2][3][aCount]=1; CaseAwards[2][3][aPriceSprayed]=90;
	CaseAwards[2][4][aId]=5; CaseAwards[2][4][aRarity]=2; CaseAwards[2][4][aType]=5; CaseAwards[2][4][aInternalId]=527; CaseAwards[2][4][aCount]=0; CaseAwards[2][4][aPriceSprayed]=100;
	CaseAwards[2][5][aId]=6; CaseAwards[2][5][aRarity]=2; CaseAwards[2][5][aType]=3; CaseAwards[2][5][aInternalId]=1; CaseAwards[2][5][aCount]=600; CaseAwards[2][5][aPriceSprayed]=0;
	CaseAwards[2][6][aId]=7; CaseAwards[2][6][aRarity]=2; CaseAwards[2][6][aType]=9; CaseAwards[2][6][aInternalId]=3; CaseAwards[2][6][aCount]=360; CaseAwards[2][6][aPriceSprayed]=100;
	CaseAwards[2][7][aId]=8; CaseAwards[2][7][aRarity]=2; CaseAwards[2][7][aType]=5; CaseAwards[2][7][aInternalId]=445; CaseAwards[2][7][aCount]=0; CaseAwards[2][7][aPriceSprayed]=100;
	CaseAwards[2][8][aId]=9; CaseAwards[2][8][aRarity]=2; CaseAwards[2][8][aType]=11; CaseAwards[2][8][aInternalId]=583; CaseAwards[2][8][aCount]=1; CaseAwards[2][8][aPriceSprayed]=100;
	CaseAwards[2][9][aId]=10; CaseAwards[2][9][aRarity]=2; CaseAwards[2][9][aType]=11; CaseAwards[2][9][aInternalId]=134; CaseAwards[2][9][aCount]=14386; CaseAwards[2][9][aPriceSprayed]=100;
	CaseAwards[2][10][aId]=11; CaseAwards[2][10][aRarity]=2; CaseAwards[2][10][aType]=11; CaseAwards[2][10][aInternalId]=508; CaseAwards[2][10][aCount]=1; CaseAwards[2][10][aPriceSprayed]=100;
	CaseAwards[2][11][aId]=12; CaseAwards[2][11][aRarity]=2; CaseAwards[2][11][aType]=11; CaseAwards[2][11][aInternalId]=134; CaseAwards[2][11][aCount]=11917; CaseAwards[2][11][aPriceSprayed]=110;
	CaseAwards[2][12][aId]=13; CaseAwards[2][12][aRarity]=2; CaseAwards[2][12][aType]=5; CaseAwards[2][12][aInternalId]=589; CaseAwards[2][12][aCount]=0; CaseAwards[2][12][aPriceSprayed]=110;
	CaseAwards[2][13][aId]=14; CaseAwards[2][13][aRarity]=2; CaseAwards[2][13][aType]=5; CaseAwards[2][13][aInternalId]=2568; CaseAwards[2][13][aCount]=0; CaseAwards[2][13][aPriceSprayed]=110;
	CaseAwards[2][14][aId]=15; CaseAwards[2][14][aRarity]=2; CaseAwards[2][14][aType]=11; CaseAwards[2][14][aInternalId]=134; CaseAwards[2][14][aCount]=11961; CaseAwards[2][14][aPriceSprayed]=140;
	CaseAwards[2][15][aId]=16; CaseAwards[2][15][aRarity]=2; CaseAwards[2][15][aType]=5; CaseAwards[2][15][aInternalId]=2385; CaseAwards[2][15][aCount]=0; CaseAwards[2][15][aPriceSprayed]=120;
	CaseAwards[2][16][aId]=17; CaseAwards[2][16][aRarity]=2; CaseAwards[2][16][aType]=5; CaseAwards[2][16][aInternalId]=28695; CaseAwards[2][16][aCount]=0; CaseAwards[2][16][aPriceSprayed]=120;
	CaseAwards[2][17][aId]=18; CaseAwards[2][17][aRarity]=2; CaseAwards[2][17][aType]=5; CaseAwards[2][17][aInternalId]=2627; CaseAwards[2][17][aCount]=0; CaseAwards[2][17][aPriceSprayed]=120;
	CaseAwards[2][18][aId]=19; CaseAwards[2][18][aRarity]=2; CaseAwards[2][18][aType]=5; CaseAwards[2][18][aInternalId]=461; CaseAwards[2][18][aCount]=0; CaseAwards[2][18][aPriceSprayed]=130;
	CaseAwards[2][19][aId]=20; CaseAwards[2][19][aRarity]=2; CaseAwards[2][19][aType]=2; CaseAwards[2][19][aInternalId]=1; CaseAwards[2][19][aCount]=1000000; CaseAwards[2][19][aPriceSprayed]=0;
	CaseAwards[2][20][aId]=21; CaseAwards[2][20][aRarity]=3; CaseAwards[2][20][aType]=9; CaseAwards[2][20][aInternalId]=3; CaseAwards[2][20][aCount]=720; CaseAwards[2][20][aPriceSprayed]=130;
	CaseAwards[2][21][aId]=22; CaseAwards[2][21][aRarity]=3; CaseAwards[2][21][aType]=11; CaseAwards[2][21][aInternalId]=134; CaseAwards[2][21][aCount]=236; CaseAwards[2][21][aPriceSprayed]=130;
	CaseAwards[2][22][aId]=23; CaseAwards[2][22][aRarity]=3; CaseAwards[2][22][aType]=5; CaseAwards[2][22][aInternalId]=2567; CaseAwards[2][22][aCount]=0; CaseAwards[2][22][aPriceSprayed]=130;
	CaseAwards[2][23][aId]=24; CaseAwards[2][23][aRarity]=3; CaseAwards[2][23][aType]=11; CaseAwards[2][23][aInternalId]=134; CaseAwards[2][23][aCount]=11935; CaseAwards[2][23][aPriceSprayed]=140;
	CaseAwards[2][24][aId]=25; CaseAwards[2][24][aRarity]=3; CaseAwards[2][24][aType]=5; CaseAwards[2][24][aInternalId]=560; CaseAwards[2][24][aCount]=0; CaseAwards[2][24][aPriceSprayed]=140;
	CaseAwards[2][25][aId]=26; CaseAwards[2][25][aRarity]=3; CaseAwards[2][25][aType]=11; CaseAwards[2][25][aInternalId]=134; CaseAwards[2][25][aCount]=19262; CaseAwards[2][25][aPriceSprayed]=140;
	CaseAwards[2][26][aId]=27; CaseAwards[2][26][aRarity]=3; CaseAwards[2][26][aType]=5; CaseAwards[2][26][aInternalId]=2584; CaseAwards[2][26][aCount]=0; CaseAwards[2][26][aPriceSprayed]=150;
	CaseAwards[2][27][aId]=28; CaseAwards[2][27][aRarity]=3; CaseAwards[2][27][aType]=5; CaseAwards[2][27][aInternalId]=2390; CaseAwards[2][27][aCount]=0; CaseAwards[2][27][aPriceSprayed]=160;
	CaseAwards[2][28][aId]=29; CaseAwards[2][28][aRarity]=3; CaseAwards[2][28][aType]=5; CaseAwards[2][28][aInternalId]=543; CaseAwards[2][28][aCount]=0; CaseAwards[2][28][aPriceSprayed]=200;
	CaseAwards[2][29][aId]=30; CaseAwards[2][29][aRarity]=3; CaseAwards[2][29][aType]=5; CaseAwards[2][29][aInternalId]=480; CaseAwards[2][29][aCount]=0; CaseAwards[2][29][aPriceSprayed]=200;
	CaseAwards[2][30][aId]=31; CaseAwards[2][30][aRarity]=4; CaseAwards[2][30][aType]=11; CaseAwards[2][30][aInternalId]=707; CaseAwards[2][30][aCount]=1; CaseAwards[2][30][aPriceSprayed]=220;
	CaseAwards[2][31][aId]=32; CaseAwards[2][31][aRarity]=4; CaseAwards[2][31][aType]=5; CaseAwards[2][31][aInternalId]=402; CaseAwards[2][31][aCount]=0; CaseAwards[2][31][aPriceSprayed]=240;
	CaseAwards[2][32][aId]=33; CaseAwards[2][32][aRarity]=4; CaseAwards[2][32][aType]=5; CaseAwards[2][32][aInternalId]=2598; CaseAwards[2][32][aCount]=0; CaseAwards[2][32][aPriceSprayed]=250;
	CaseAwards[2][33][aId]=34; CaseAwards[2][33][aRarity]=4; CaseAwards[2][33][aType]=5; CaseAwards[2][33][aInternalId]=400; CaseAwards[2][33][aCount]=0; CaseAwards[2][33][aPriceSprayed]=260;
	CaseAwards[2][34][aId]=35; CaseAwards[2][34][aRarity]=4; CaseAwards[2][34][aType]=5; CaseAwards[2][34][aInternalId]=506; CaseAwards[2][34][aCount]=0; CaseAwards[2][34][aPriceSprayed]=270;
	CaseAwards[2][35][aId]=36; CaseAwards[2][35][aRarity]=5; CaseAwards[2][35][aType]=5; CaseAwards[2][35][aInternalId]=415; CaseAwards[2][35][aCount]=0; CaseAwards[2][35][aPriceSprayed]=400;
	CaseAwards[2][36][aId]=37; CaseAwards[2][36][aRarity]=5; CaseAwards[2][36][aType]=5; CaseAwards[2][36][aInternalId]=2543; CaseAwards[2][36][aCount]=0; CaseAwards[2][36][aPriceSprayed]=400;
}

stock Cases_InitCase3Bonus()
{
	CaseBonus[2][0][bId]=301; CaseBonus[2][0][bNumberOpen]=40; CaseBonus[2][0][bRarity]=5; CaseBonus[2][0][bType]=5; CaseBonus[2][0][bInternalId]=2581; CaseBonus[2][0][bCount]=0; CaseBonus[2][0][bPriceSprayed]=400;
	CaseBonus[2][1][bId]=302; CaseBonus[2][1][bNumberOpen]=30; CaseBonus[2][1][bRarity]=4; CaseBonus[2][1][bType]=21; CaseBonus[2][1][bInternalId]=1; CaseBonus[2][1][bCount]=250; CaseBonus[2][1][bPriceSprayed]=0;
	CaseBonus[2][2][bId]=303; CaseBonus[2][2][bNumberOpen]=20; CaseBonus[2][2][bRarity]=4; CaseBonus[2][2][bType]=4; CaseBonus[2][2][bInternalId]=3; CaseBonus[2][2][bCount]=2; CaseBonus[2][2][bPriceSprayed]=0;
	CaseBonus[2][3][bId]=304; CaseBonus[2][3][bNumberOpen]=10; CaseBonus[2][3][bRarity]=3; CaseBonus[2][3][bType]=21; CaseBonus[2][3][bInternalId]=1; CaseBonus[2][3][bCount]=150; CaseBonus[2][3][bPriceSprayed]=0;
	CaseBonus[2][4][bId]=305; CaseBonus[2][4][bNumberOpen]=5; CaseBonus[2][4][bRarity]=4; CaseBonus[2][4][bType]=4; CaseBonus[2][4][bInternalId]=3; CaseBonus[2][4][bCount]=1; CaseBonus[2][4][bPriceSprayed]=0;
}

stock Cases_InitCase4Awards()
{
	CaseAwards[3][0][aId]=1; CaseAwards[3][0][aRarity]=3; CaseAwards[3][0][aType]=5; CaseAwards[3][0][aInternalId]=436; CaseAwards[3][0][aCount]=0; CaseAwards[3][0][aPriceSprayed]=130;
	CaseAwards[3][1][aId]=2; CaseAwards[3][1][aRarity]=3; CaseAwards[3][1][aType]=5; CaseAwards[3][1][aInternalId]=2567; CaseAwards[3][1][aCount]=0; CaseAwards[3][1][aPriceSprayed]=130;
	CaseAwards[3][2][aId]=3; CaseAwards[3][2][aRarity]=3; CaseAwards[3][2][aType]=5; CaseAwards[3][2][aInternalId]=560; CaseAwards[3][2][aCount]=0; CaseAwards[3][2][aPriceSprayed]=140;
	CaseAwards[3][3][aId]=4; CaseAwards[3][3][aRarity]=3; CaseAwards[3][3][aType]=5; CaseAwards[3][3][aInternalId]=550; CaseAwards[3][3][aCount]=0; CaseAwards[3][3][aPriceSprayed]=140;
	CaseAwards[3][4][aId]=5; CaseAwards[3][4][aRarity]=3; CaseAwards[3][4][aType]=5; CaseAwards[3][4][aInternalId]=28671; CaseAwards[3][4][aCount]=0; CaseAwards[3][4][aPriceSprayed]=150;
	CaseAwards[3][5][aId]=6; CaseAwards[3][5][aRarity]=3; CaseAwards[3][5][aType]=5; CaseAwards[3][5][aInternalId]=603; CaseAwards[3][5][aCount]=0; CaseAwards[3][5][aPriceSprayed]=150;
	CaseAwards[3][6][aId]=7; CaseAwards[3][6][aRarity]=3; CaseAwards[3][6][aType]=5; CaseAwards[3][6][aInternalId]=2552; CaseAwards[3][6][aCount]=0; CaseAwards[3][6][aPriceSprayed]=150;
	CaseAwards[3][7][aId]=8; CaseAwards[3][7][aRarity]=3; CaseAwards[3][7][aType]=5; CaseAwards[3][7][aInternalId]=565; CaseAwards[3][7][aCount]=0; CaseAwards[3][7][aPriceSprayed]=150;
	CaseAwards[3][8][aId]=9; CaseAwards[3][8][aRarity]=3; CaseAwards[3][8][aType]=5; CaseAwards[3][8][aInternalId]=2609; CaseAwards[3][8][aCount]=0; CaseAwards[3][8][aPriceSprayed]=160;
	CaseAwards[3][9][aId]=10; CaseAwards[3][9][aRarity]=3; CaseAwards[3][9][aType]=5; CaseAwards[3][9][aInternalId]=2604; CaseAwards[3][9][aCount]=0; CaseAwards[3][9][aPriceSprayed]=160;
	CaseAwards[3][10][aId]=11; CaseAwards[3][10][aRarity]=3; CaseAwards[3][10][aType]=5; CaseAwards[3][10][aInternalId]=551; CaseAwards[3][10][aCount]=0; CaseAwards[3][10][aPriceSprayed]=160;
	CaseAwards[3][11][aId]=12; CaseAwards[3][11][aRarity]=3; CaseAwards[3][11][aType]=5; CaseAwards[3][11][aInternalId]=2390; CaseAwards[3][11][aCount]=0; CaseAwards[3][11][aPriceSprayed]=160;
	CaseAwards[3][12][aId]=13; CaseAwards[3][12][aRarity]=3; CaseAwards[3][12][aType]=5; CaseAwards[3][12][aInternalId]=526; CaseAwards[3][12][aCount]=0; CaseAwards[3][12][aPriceSprayed]=160;
	CaseAwards[3][13][aId]=14; CaseAwards[3][13][aRarity]=3; CaseAwards[3][13][aType]=5; CaseAwards[3][13][aInternalId]=2620; CaseAwards[3][13][aCount]=0; CaseAwards[3][13][aPriceSprayed]=170;
	CaseAwards[3][14][aId]=15; CaseAwards[3][14][aRarity]=3; CaseAwards[3][14][aType]=5; CaseAwards[3][14][aInternalId]=2594; CaseAwards[3][14][aCount]=0; CaseAwards[3][14][aPriceSprayed]=180;
	CaseAwards[3][15][aId]=16; CaseAwards[3][15][aRarity]=3; CaseAwards[3][15][aType]=5; CaseAwards[3][15][aInternalId]=2621; CaseAwards[3][15][aCount]=0; CaseAwards[3][15][aPriceSprayed]=180;
	CaseAwards[3][16][aId]=17; CaseAwards[3][16][aRarity]=3; CaseAwards[3][16][aType]=5; CaseAwards[3][16][aInternalId]=2387; CaseAwards[3][16][aCount]=0; CaseAwards[3][16][aPriceSprayed]=200;
	CaseAwards[3][17][aId]=18; CaseAwards[3][17][aRarity]=3; CaseAwards[3][17][aType]=5; CaseAwards[3][17][aInternalId]=480; CaseAwards[3][17][aCount]=0; CaseAwards[3][17][aPriceSprayed]=200;
	CaseAwards[3][18][aId]=19; CaseAwards[3][18][aRarity]=3; CaseAwards[3][18][aType]=5; CaseAwards[3][18][aInternalId]=2394; CaseAwards[3][18][aCount]=0; CaseAwards[3][18][aPriceSprayed]=200;
	CaseAwards[3][19][aId]=20; CaseAwards[3][19][aRarity]=3; CaseAwards[3][19][aType]=5; CaseAwards[3][19][aInternalId]=558; CaseAwards[3][19][aCount]=0; CaseAwards[3][19][aPriceSprayed]=210;
	CaseAwards[3][20][aId]=21; CaseAwards[3][20][aRarity]=4; CaseAwards[3][20][aType]=5; CaseAwards[3][20][aInternalId]=28694; CaseAwards[3][20][aCount]=0; CaseAwards[3][20][aPriceSprayed]=450;
	CaseAwards[3][21][aId]=22; CaseAwards[3][21][aRarity]=4; CaseAwards[3][21][aType]=5; CaseAwards[3][21][aInternalId]=28697; CaseAwards[3][21][aCount]=0; CaseAwards[3][21][aPriceSprayed]=450;
	CaseAwards[3][22][aId]=23; CaseAwards[3][22][aRarity]=4; CaseAwards[3][22][aType]=5; CaseAwards[3][22][aInternalId]=402; CaseAwards[3][22][aCount]=0; CaseAwards[3][22][aPriceSprayed]=240;
	CaseAwards[3][23][aId]=24; CaseAwards[3][23][aRarity]=4; CaseAwards[3][23][aType]=5; CaseAwards[3][23][aInternalId]=505; CaseAwards[3][23][aCount]=0; CaseAwards[3][23][aPriceSprayed]=240;
	CaseAwards[3][24][aId]=25; CaseAwards[3][24][aRarity]=4; CaseAwards[3][24][aType]=5; CaseAwards[3][24][aInternalId]=2598; CaseAwards[3][24][aCount]=0; CaseAwards[3][24][aPriceSprayed]=250;
	CaseAwards[3][25][aId]=26; CaseAwards[3][25][aRarity]=4; CaseAwards[3][25][aType]=5; CaseAwards[3][25][aInternalId]=400; CaseAwards[3][25][aCount]=0; CaseAwards[3][25][aPriceSprayed]=260;
	CaseAwards[3][26][aId]=27; CaseAwards[3][26][aRarity]=4; CaseAwards[3][26][aType]=5; CaseAwards[3][26][aInternalId]=2547; CaseAwards[3][26][aCount]=0; CaseAwards[3][26][aPriceSprayed]=250;
	CaseAwards[3][27][aId]=28; CaseAwards[3][27][aRarity]=4; CaseAwards[3][27][aType]=5; CaseAwards[3][27][aInternalId]=506; CaseAwards[3][27][aCount]=0; CaseAwards[3][27][aPriceSprayed]=270;
	CaseAwards[3][28][aId]=29; CaseAwards[3][28][aRarity]=4; CaseAwards[3][28][aType]=5; CaseAwards[3][28][aInternalId]=763; CaseAwards[3][28][aCount]=0; CaseAwards[3][28][aPriceSprayed]=280;
	CaseAwards[3][29][aId]=30; CaseAwards[3][29][aRarity]=4; CaseAwards[3][29][aType]=5; CaseAwards[3][29][aInternalId]=28693; CaseAwards[3][29][aCount]=0; CaseAwards[3][29][aPriceSprayed]=450;
	CaseAwards[3][30][aId]=31; CaseAwards[3][30][aRarity]=5; CaseAwards[3][30][aType]=5; CaseAwards[3][30][aInternalId]=415; CaseAwards[3][30][aCount]=0; CaseAwards[3][30][aPriceSprayed]=400;
	CaseAwards[3][31][aId]=32; CaseAwards[3][31][aRarity]=5; CaseAwards[3][31][aType]=5; CaseAwards[3][31][aInternalId]=2543; CaseAwards[3][31][aCount]=0; CaseAwards[3][31][aPriceSprayed]=400;
	CaseAwards[3][32][aId]=33; CaseAwards[3][32][aRarity]=5; CaseAwards[3][32][aType]=5; CaseAwards[3][32][aInternalId]=2573; CaseAwards[3][32][aCount]=0; CaseAwards[3][32][aPriceSprayed]=430;
	CaseAwards[3][33][aId]=34; CaseAwards[3][33][aRarity]=5; CaseAwards[3][33][aType]=5; CaseAwards[3][33][aInternalId]=2558; CaseAwards[3][33][aCount]=0; CaseAwards[3][33][aPriceSprayed]=450;
	CaseAwards[3][34][aId]=35; CaseAwards[3][34][aRarity]=5; CaseAwards[3][34][aType]=5; CaseAwards[3][34][aInternalId]=2597; CaseAwards[3][34][aCount]=0; CaseAwards[3][34][aPriceSprayed]=450;
	CaseAwards[3][35][aId]=36; CaseAwards[3][35][aRarity]=5; CaseAwards[3][35][aType]=5; CaseAwards[3][35][aInternalId]=2558; CaseAwards[3][35][aCount]=0; CaseAwards[3][35][aPriceSprayed]=450;
	CaseAwards[3][36][aId]=37; CaseAwards[3][36][aRarity]=5; CaseAwards[3][36][aType]=5; CaseAwards[3][36][aInternalId]=28672; CaseAwards[3][36][aCount]=0; CaseAwards[3][36][aPriceSprayed]=450;
}

stock Cases_InitCase4Bonus()
{
	CaseBonus[3][0][bId]=401; CaseBonus[3][0][bNumberOpen]=40; CaseBonus[3][0][bRarity]=5; CaseBonus[3][0][bType]=5; CaseBonus[3][0][bInternalId]=668; CaseBonus[3][0][bCount]=0; CaseBonus[3][0][bPriceSprayed]=500;
	CaseBonus[3][1][bId]=402; CaseBonus[3][1][bNumberOpen]=30; CaseBonus[3][1][bRarity]=4; CaseBonus[3][1][bType]=21; CaseBonus[3][1][bInternalId]=1; CaseBonus[3][1][bCount]=500; CaseBonus[3][1][bPriceSprayed]=0;
	CaseBonus[3][2][bId]=403; CaseBonus[3][2][bNumberOpen]=20; CaseBonus[3][2][bRarity]=4; CaseBonus[3][2][bType]=4; CaseBonus[3][2][bInternalId]=4; CaseBonus[3][2][bCount]=2; CaseBonus[3][2][bPriceSprayed]=0;
	CaseBonus[3][3][bId]=404; CaseBonus[3][3][bNumberOpen]=10; CaseBonus[3][3][bRarity]=4; CaseBonus[3][3][bType]=21; CaseBonus[3][3][bInternalId]=1; CaseBonus[3][3][bCount]=300; CaseBonus[3][3][bPriceSprayed]=0;
	CaseBonus[3][4][bId]=405; CaseBonus[3][4][bNumberOpen]=5; CaseBonus[3][4][bRarity]=4; CaseBonus[3][4][bType]=4; CaseBonus[3][4][bInternalId]=4; CaseBonus[3][4][bCount]=1; CaseBonus[3][4][bPriceSprayed]=0;
}

stock Cases_InitCase5Awards()
{
	CaseAwards[4][0][aId]=1; CaseAwards[4][0][aRarity]=4; CaseAwards[4][0][aType]=5; CaseAwards[4][0][aInternalId]=410; CaseAwards[4][0][aCount]=0; CaseAwards[4][0][aPriceSprayed]=230;
	CaseAwards[4][1][aId]=2; CaseAwards[4][1][aRarity]=4; CaseAwards[4][1][aType]=5; CaseAwards[4][1][aInternalId]=604; CaseAwards[4][1][aCount]=0; CaseAwards[4][1][aPriceSprayed]=260;
	CaseAwards[4][2][aId]=3; CaseAwards[4][2][aRarity]=4; CaseAwards[4][2][aType]=5; CaseAwards[4][2][aInternalId]=2389; CaseAwards[4][2][aCount]=0; CaseAwards[4][2][aPriceSprayed]=270;
	CaseAwards[4][3][aId]=4; CaseAwards[4][3][aRarity]=4; CaseAwards[4][3][aType]=5; CaseAwards[4][3][aInternalId]=2574; CaseAwards[4][3][aCount]=0; CaseAwards[4][3][aPriceSprayed]=290;
	CaseAwards[4][4][aId]=5; CaseAwards[4][4][aRarity]=4; CaseAwards[4][4][aType]=5; CaseAwards[4][4][aInternalId]=451; CaseAwards[4][4][aCount]=0; CaseAwards[4][4][aPriceSprayed]=340;
	CaseAwards[4][5][aId]=6; CaseAwards[4][5][aRarity]=4; CaseAwards[4][5][aType]=5; CaseAwards[4][5][aInternalId]=2626; CaseAwards[4][5][aCount]=0; CaseAwards[4][5][aPriceSprayed]=350;
	CaseAwards[4][6][aId]=7; CaseAwards[4][6][aRarity]=4; CaseAwards[4][6][aType]=5; CaseAwards[4][6][aInternalId]=2551; CaseAwards[4][6][aCount]=0; CaseAwards[4][6][aPriceSprayed]=350;
	CaseAwards[4][7][aId]=8; CaseAwards[4][7][aRarity]=4; CaseAwards[4][7][aType]=5; CaseAwards[4][7][aInternalId]=2549; CaseAwards[4][7][aCount]=0; CaseAwards[4][7][aPriceSprayed]=370;
	CaseAwards[4][8][aId]=9; CaseAwards[4][8][aRarity]=4; CaseAwards[4][8][aType]=5; CaseAwards[4][8][aInternalId]=2393; CaseAwards[4][8][aCount]=0; CaseAwards[4][8][aPriceSprayed]=370;
	CaseAwards[4][9][aId]=10; CaseAwards[4][9][aRarity]=4; CaseAwards[4][9][aType]=5; CaseAwards[4][9][aInternalId]=579; CaseAwards[4][9][aCount]=0; CaseAwards[4][9][aPriceSprayed]=370;
	CaseAwards[4][10][aId]=11; CaseAwards[4][10][aRarity]=5; CaseAwards[4][10][aType]=5; CaseAwards[4][10][aInternalId]=2619; CaseAwards[4][10][aCount]=0; CaseAwards[4][10][aPriceSprayed]=460;
	CaseAwards[4][11][aId]=12; CaseAwards[4][11][aRarity]=5; CaseAwards[4][11][aType]=5; CaseAwards[4][11][aInternalId]=657; CaseAwards[4][11][aCount]=0; CaseAwards[4][11][aPriceSprayed]=490;
	CaseAwards[4][12][aId]=13; CaseAwards[4][12][aRarity]=5; CaseAwards[4][12][aType]=5; CaseAwards[4][12][aInternalId]=669; CaseAwards[4][12][aCount]=0; CaseAwards[4][12][aPriceSprayed]=570;
	CaseAwards[4][13][aId]=14; CaseAwards[4][13][aRarity]=5; CaseAwards[4][13][aType]=5; CaseAwards[4][13][aInternalId]=2564; CaseAwards[4][13][aCount]=0; CaseAwards[4][13][aPriceSprayed]=570;
	CaseAwards[4][14][aId]=15; CaseAwards[4][14][aRarity]=5; CaseAwards[4][14][aType]=5; CaseAwards[4][14][aInternalId]=765; CaseAwards[4][14][aCount]=0; CaseAwards[4][14][aPriceSprayed]=600;
	CaseAwards[4][15][aId]=16; CaseAwards[4][15][aRarity]=5; CaseAwards[4][15][aType]=5; CaseAwards[4][15][aInternalId]=2591; CaseAwards[4][15][aCount]=0; CaseAwards[4][15][aPriceSprayed]=670;
	CaseAwards[4][16][aId]=17; CaseAwards[4][16][aRarity]=5; CaseAwards[4][16][aType]=5; CaseAwards[4][16][aInternalId]=2607; CaseAwards[4][16][aCount]=0; CaseAwards[4][16][aPriceSprayed]=750;
	CaseAwards[4][17][aId]=18; CaseAwards[4][17][aRarity]=5; CaseAwards[4][17][aType]=5; CaseAwards[4][17][aInternalId]=2601; CaseAwards[4][17][aCount]=0; CaseAwards[4][17][aPriceSprayed]=800;
	CaseAwards[4][18][aId]=19; CaseAwards[4][18][aRarity]=5; CaseAwards[4][18][aType]=5; CaseAwards[4][18][aInternalId]=667; CaseAwards[4][18][aCount]=0; CaseAwards[4][18][aPriceSprayed]=850;
	CaseAwards[4][19][aId]=20; CaseAwards[4][19][aRarity]=5; CaseAwards[4][19][aType]=5; CaseAwards[4][19][aInternalId]=2570; CaseAwards[4][19][aCount]=0; CaseAwards[4][19][aPriceSprayed]=900;
	CaseAwards[4][20][aId]=21; CaseAwards[4][20][aRarity]=5; CaseAwards[4][20][aType]=5; CaseAwards[4][20][aInternalId]=666; CaseAwards[4][20][aCount]=0; CaseAwards[4][20][aPriceSprayed]=900;
	CaseAwards[4][21][aId]=22; CaseAwards[4][21][aRarity]=5; CaseAwards[4][21][aType]=5; CaseAwards[4][21][aInternalId]=466; CaseAwards[4][21][aCount]=0; CaseAwards[4][21][aPriceSprayed]=900;
}

stock Cases_InitCase5Bonus()
{
	CaseBonus[4][0][bId]=501; CaseBonus[4][0][bNumberOpen]=25; CaseBonus[4][0][bRarity]=5; CaseBonus[4][0][bType]=5; CaseBonus[4][0][bInternalId]=665; CaseBonus[4][0][bCount]=0; CaseBonus[4][0][bPriceSprayed]=500;
	CaseBonus[4][1][bId]=502; CaseBonus[4][1][bNumberOpen]=20; CaseBonus[4][1][bRarity]=5; CaseBonus[4][1][bType]=21; CaseBonus[4][1][bInternalId]=1; CaseBonus[4][1][bCount]=1500; CaseBonus[4][1][bPriceSprayed]=0;
	CaseBonus[4][2][bId]=503; CaseBonus[4][2][bNumberOpen]=15; CaseBonus[4][2][bRarity]=5; CaseBonus[4][2][bType]=4; CaseBonus[4][2][bInternalId]=5; CaseBonus[4][2][bCount]=2; CaseBonus[4][2][bPriceSprayed]=0;
	CaseBonus[4][3][bId]=504; CaseBonus[4][3][bNumberOpen]=10; CaseBonus[4][3][bRarity]=5; CaseBonus[4][3][bType]=21; CaseBonus[4][3][bInternalId]=1; CaseBonus[4][3][bCount]=1000; CaseBonus[4][3][bPriceSprayed]=0;
	CaseBonus[4][4][bId]=505; CaseBonus[4][4][bNumberOpen]=5; CaseBonus[4][4][bRarity]=5; CaseBonus[4][4][bType]=4; CaseBonus[4][4][bInternalId]=5; CaseBonus[4][4][bCount]=1; CaseBonus[4][4][bPriceSprayed]=0;
}

stock Cases_InitCase6()
{
	CaseAwards[5][0][aId]=1; CaseAwards[5][0][aRarity]=2; CaseAwards[5][0][aType]=11; CaseAwards[5][0][aInternalId]=134; CaseAwards[5][0][aCount]=12293; CaseAwards[5][0][aPriceSprayed]=100;
	CaseAwards[5][1][aId]=2; CaseAwards[5][1][aRarity]=2; CaseAwards[5][1][aType]=11; CaseAwards[5][1][aInternalId]=508; CaseAwards[5][1][aCount]=1; CaseAwards[5][1][aPriceSprayed]=100;
	CaseAwards[5][2][aId]=3; CaseAwards[5][2][aRarity]=2; CaseAwards[5][2][aType]=11; CaseAwards[5][2][aInternalId]=511; CaseAwards[5][2][aCount]=1; CaseAwards[5][2][aPriceSprayed]=100;
	CaseAwards[5][3][aId]=4; CaseAwards[5][3][aRarity]=2; CaseAwards[5][3][aType]=10; CaseAwards[5][3][aInternalId]=1; CaseAwards[5][3][aCount]=6000; CaseAwards[5][3][aPriceSprayed]=0;
	CaseAwards[5][4][aId]=5; CaseAwards[5][4][aRarity]=2; CaseAwards[5][4][aType]=3; CaseAwards[5][4][aInternalId]=1; CaseAwards[5][4][aCount]=700; CaseAwards[5][4][aPriceSprayed]=0;
	for(new i = 5; i < 25; i++) {
		CaseAwards[5][i][aId] = i + 1;
		CaseAwards[5][i][aRarity] = (i < 15) ? 2 : ((i < 20) ? 3 : 4);
		CaseAwards[5][i][aType] = 5;
		CaseAwards[5][i][aInternalId] = 500 + i;
		CaseAwards[5][i][aCount] = 0;
		CaseAwards[5][i][aPriceSprayed] = 100 + (i * 10);
	}
	
	CaseBonus[5][0][bId]=601; CaseBonus[5][0][bNumberOpen]=40; CaseBonus[5][0][bRarity]=5; CaseBonus[5][0][bType]=5; CaseBonus[5][0][bInternalId]=658; CaseBonus[5][0][bCount]=0; CaseBonus[5][0][bPriceSprayed]=100;
	CaseBonus[5][1][bId]=602; CaseBonus[5][1][bNumberOpen]=30; CaseBonus[5][1][bRarity]=4; CaseBonus[5][1][bType]=21; CaseBonus[5][1][bInternalId]=1; CaseBonus[5][1][bCount]=350; CaseBonus[5][1][bPriceSprayed]=0;
	CaseBonus[5][2][bId]=603; CaseBonus[5][2][bNumberOpen]=20; CaseBonus[5][2][bRarity]=4; CaseBonus[5][2][bType]=4; CaseBonus[5][2][bInternalId]=6; CaseBonus[5][2][bCount]=2; CaseBonus[5][2][bPriceSprayed]=0;
	CaseBonus[5][3][bId]=604; CaseBonus[5][3][bNumberOpen]=10; CaseBonus[5][3][bRarity]=4; CaseBonus[5][3][bType]=21; CaseBonus[5][3][bInternalId]=1; CaseBonus[5][3][bCount]=200; CaseBonus[5][3][bPriceSprayed]=0;
	CaseBonus[5][4][bId]=605; CaseBonus[5][4][bNumberOpen]=5; CaseBonus[5][4][bRarity]=4; CaseBonus[5][4][bType]=4; CaseBonus[5][4][bInternalId]=6; CaseBonus[5][4][bCount]=1; CaseBonus[5][4][bPriceSprayed]=0;
}

stock Cases_InitEventCases()
{
    for(new c = 6; c < MAX_CASES; c++) 
	{
        if(CaseData[c][cId] != 0 && CaseData[c][cId] != c+1) 
		{
            
            continue;
        }
     
        CaseData[c][cId] = c + 1;
        CaseData[c][cPriceOne] = 900;
        CaseData[c][cPriceTen] = 9000;
        CaseData[c][cDiscountOne] = 0;
        CaseData[c][cDiscountTen] = 5;
        CaseData[c][cAwardsCount] = 25;
        CaseData[c][cBonusCount] = 5;
        
        for(new i = 0; i < 25; i++) {
            CaseAwards[c][i][aId] = i + 1;
            CaseAwards[c][i][aRarity] = (i < 10) ? 2 : ((i < 18) ? 3 : ((i < 23) ? 4 : 5));
            CaseAwards[c][i][aType] = (i % 3 == 0) ? 5 : ((i % 3 == 1) ? 11 : 2);
            CaseAwards[c][i][aInternalId] = 500 + i;
            CaseAwards[c][i][aCount] = (CaseAwards[c][i][aType] == 2) ? 100000 * (i + 1) : 1;
            CaseAwards[c][i][aPriceSprayed] = 100 + (i * 10);
        }
        
        CaseBonus[c][0][bId] = (c+1)*100+1; 
        CaseBonus[c][0][bNumberOpen] = 40; 
        CaseBonus[c][0][bRarity] = 5; 
        CaseBonus[c][0][bType] = 5; 
        CaseBonus[c][0][bInternalId] = 600+c; 
        CaseBonus[c][0][bCount] = 0; 
        CaseBonus[c][0][bPriceSprayed] = 300;
        
        CaseBonus[c][1][bId] = (c+1)*100+2; 
        CaseBonus[c][1][bNumberOpen] = 30; 
        CaseBonus[c][1][bRarity] = 4; 
        CaseBonus[c][1][bType] = 21; 
        CaseBonus[c][1][bInternalId] = 1; 
        CaseBonus[c][1][bCount] = 350; 
        CaseBonus[c][1][bPriceSprayed] = 0;
        
        CaseBonus[c][2][bId] = (c+1)*100+3; 
        CaseBonus[c][2][bNumberOpen] = 20; 
        CaseBonus[c][2][bRarity] = 4; 
        CaseBonus[c][2][bType] = 4; 
        CaseBonus[c][2][bInternalId] = c+1; 
        CaseBonus[c][2][bCount] = 2; 
        CaseBonus[c][2][bPriceSprayed] = 0;
        
        CaseBonus[c][3][bId] = (c+1)*100+4; 
        CaseBonus[c][3][bNumberOpen] = 10; 
        CaseBonus[c][3][bRarity] = 4; 
        CaseBonus[c][3][bType] = 21; 
        CaseBonus[c][3][bInternalId] = 1; 
        CaseBonus[c][3][bCount] = 200; 
        CaseBonus[c][3][bPriceSprayed] = 0;
        
        CaseBonus[c][4][bId] = (c+1)*100+5; 
        CaseBonus[c][4][bNumberOpen] = 5; 
        CaseBonus[c][4][bRarity] = 4; 
        CaseBonus[c][4][bType] = 4; 
        CaseBonus[c][4][bInternalId] = c+1; 
        CaseBonus[c][4][bCount] = 1; 
        CaseBonus[c][4][bPriceSprayed] = 0;
    }
}

stock Cases_SavePlayer(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new ccStr[256];
    ccStr[0] = EOS;
    for(new i = 0; i < MAX_CASES; i++)
    {
        if(i > 0) strcat(ccStr, ",");
        new tmp[16];
        format(tmp, sizeof(tmp), "%d", GetPlayerCaseCountByType(playerid, CaseData[i][cId]));
        strcat(ccStr, tmp);
    }

    new ocStr[256];
    ocStr[0] = EOS;
    for(new i = 0; i < MAX_CASES; i++)
    {
        if(i > 0) strcat(ocStr, ",");
        new tmp[16];
        format(tmp, sizeof(tmp), "%d", pCasesOpenedByCase[playerid][i]);
        strcat(ocStr, tmp);
    }

    new cbStr[512];
    cbStr[0] = EOS;
    for(new c = 0; c < MAX_CASES; c++)
    {
        for(new b = 0; b < MAX_BONUS_PER_CASE; b++)
        {
            if(c > 0 || b > 0) strcat(cbStr, ",");
            new tmp[8];
            format(tmp, sizeof(tmp), "%d", pCasesBonusStatus[playerid][c][b]);
            strcat(cbStr, tmp);
        }
    }

    new query[1600];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO player_cases (user_id, dust, opened_count, selected_case, tutorial, case_counts, opened_by_case, bonus_status) \
        VALUES (%d, %d, %d, %d, %d, '%e', '%e', '%e') \
        ON DUPLICATE KEY UPDATE dust=%d, opened_count=%d, selected_case=%d, tutorial=%d, case_counts='%e', opened_by_case='%e', bonus_status='%e'",
        GetPlayerAccountID(playerid),
        GetPlayerData(playerid, P_DUST),
        pCasesOpened[playerid],
        pCasesSelected[playerid],
        pCasesTutorial[playerid],
        ccStr,
        ocStr,
        cbStr,
        GetPlayerData(playerid, P_DUST),
        pCasesOpened[playerid],
        pCasesSelected[playerid],
        pCasesTutorial[playerid],
        ccStr,
        ocStr,
        cbStr
    );
    mysql_tquery(mysql, query);
    return 1;
}

public Cases_OnPlayerLoad(playerid)
{
    if(cache_num_rows())
    {
        pCasesSelected[playerid] = cache_get_field_content_int(0, "selected_case");
        pCasesTutorial[playerid] = cache_get_field_content_int(0, "tutorial");

        new ccStr[256];
        cache_get_field_content(0, "case_counts", ccStr, mysql, sizeof(ccStr));
        if(strlen(ccStr) > 0)
        {
            new idx = 0, pos = 0, len = strlen(ccStr), tmp[16];
            while(pos < len && idx < MAX_CASES)
            {
                new end = pos;
                while(end < len && ccStr[end] != ',') end++;
                strmid(tmp, ccStr, pos, end, sizeof(tmp));
                SetPlayerCaseCountByType(playerid, CaseData[idx][cId], strval(tmp));
                idx++;
                pos = end + 1;
            }
        }

        new ocStr[256];
        cache_get_field_content(0, "opened_by_case", ocStr, mysql, sizeof(ocStr));
        if(strlen(ocStr) > 0)
        {
            new idx = 0, pos = 0, len = strlen(ocStr), tmp[16];
            while(pos < len && idx < MAX_CASES)
            {
                new end = pos;
                while(end < len && ocStr[end] != ',') end++;
                strmid(tmp, ocStr, pos, end, sizeof(tmp));
                pCasesOpenedByCase[playerid][idx++] = strval(tmp);
                pos = end + 1;
            }
        }

        new cbStr[512];
        cache_get_field_content(0, "bonus_status", cbStr, mysql, sizeof(cbStr));
        if(strlen(cbStr) > 0)
        {
            new idx = 0, pos = 0, len = strlen(cbStr), tmp[8];
            while(pos < len && idx < MAX_CASES * MAX_BONUS_PER_CASE)
            {
                new end = pos;
                while(end < len && cbStr[end] != ',') end++;
                strmid(tmp, cbStr, pos, end, sizeof(tmp));
                pCasesBonusStatus[playerid][idx / MAX_BONUS_PER_CASE][idx % MAX_BONUS_PER_CASE] = strval(tmp);
                idx++;
                pos = end + 1;
            }
        }
    }
    return 1;
}

stock Cases_LoadPlayer(playerid)
{
    if(GetPlayerAccountID(playerid) <= 0) return 0;

    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM player_cases WHERE user_id = %d LIMIT 1", GetPlayerAccountID(playerid));
    mysql_tquery(mysql, query, "Cases_OnPlayerLoad", "d", playerid);
    return 1;
}

CMD:givecases(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13) return 1;

    new to_player, type_case, count;
    if(sscanf(params, "udd", to_player, type_case, count))
        return SendClientMessage(playerid, COLOR_GREY, "Используйте: /givecases [id] [type_case:1-19] [count]");

    if(!IsPlayerConnected(to_player)) return SendClientMessage(playerid, COLOR_RED, "Игрок не найден.");
    if(type_case < 1 || type_case > 19) return SendClientMessage(playerid, COLOR_RED, "type_case должен быть от 1 до 19.");
    if(count <= 0) return SendClientMessage(playerid, COLOR_RED, "count должен быть больше 0.");

    AddPlayerCaseCountByType(to_player, type_case, count);
    SavePlayerAccount(to_player);

    new str[128];
    format(str, sizeof(str), "Вы выдали %d кейс(ов) типа %d игроку %s.", count, type_case, GetPlayerNameEx(to_player));
    SendClientMessage(playerid, COLOR_WHITE, str);

    format(str, sizeof(str), "Администратор выдал вам %d кейс(ов) типа %d.", count, type_case);
    SendClientMessage(to_player, COLOR_WHITE, str);
    
    if(pCasesGUIOpen[to_player]) Cases_UpdateGUI(to_player);
    
    return 1;
}