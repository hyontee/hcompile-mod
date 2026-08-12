#if defined _businesses_inc
	#endinput
#endif
#define _businesses_inc
//ALTER TABLE `businesses` ADD `bLockedTime` INT(11) NOT NULL DEFAULT '0' AFTER `bLocked`;
#define TABLE_BUSINESS						"businesses"

#define MIN_BIZROB_PLAYERS					2

#define MAX_BUSINESSES						100
#define MAX_BUSINESS_ITEMS					20

#define BUSINESS_MIN_PRODUCTS				10
#define BUSINESS_MAX_PRODUCTS				50000
#define BUSINESS_MAX_ORDER_PROD				5000

#define BUSINESS_CUSTOMS_ELEVATOR_HEIGHT	(Float:1.711)

#define BUSINESS_SELL_DIVISION_RATIO		2.0	// (Коэффициент деления при продажи, в зависимости от гос.цены) /2.0 = 50%
#define BUSINESS_CUSTOMS_INTERIOR_ID		3 // (ID интерьера тюнинг-центра)

enum {
	PICKUP_TYPE_NONE = 0,
	PICKUP_TYPE_BUSINESS_ENTER = 1,
	PICKUP_TYPE_BUSINESS_BUY_MENU,
}

enum {
	BUSINESS_TYPE_NONE = 0, // status_int +  |  
	BUSINESS_TYPE_24_7 = 1, // status_int +  |  
	BUSINESS_TYPE_CLUCKIN_BELL, // status_int +  |  
	BUSINESS_TYPE_PIZZA, // status_int +  |  
	BUSINESS_TYPE_BURGER_SHOT, // status_int +  |  
	BUSINESS_TYPE_BAR, // status_int +  |  
	BUSINESS_TYPE_CLUB, // status_int +  |  
	BUSINESS_TYPE_AMMO, // status_int +  |  
	BUSINESS_TYPE_VICTIM, // status_int +  |  
	BUSINESS_TYPE_ZIP, // status_int +  |  
	BUSINESS_TYPE_SUB_URBAN, // status_int +  |  
	BUSINESS_TYPE_BINCO, // status_int +  |  
	BUSINESS_TYPE_PROLAPS, // status_int +  |  
	BUSINESS_TYPE_DIDIER_SACH, // status_int +  |  
	BUSINESS_TYPE_GAS, // status_int +  |  
	BUSINESS_TYPE_CUSTOMS, // status_int +  | 
	BUSINESS_TYPE_CARAVAN, // status_int +  | 
	BUSINESS_TYPE_CASINO, // status_int +  | 
	BUSINESS_TYPE_STALL,
}
enum BUSINESS_TYPE_e {
	bType,
	bTypeName[32],
	bTypeMapIcon, 
	bTypeMaxProdPrice, // (максимальная цена за товар)
	bool:bTypeEnterPrice, // (можно ли ставить цену за вход)
	bTypeOrderPrice, // (цена за 1 ед.  - заказ продуктов)
	bTypeTaxDay, // (цена налога в сутки (24 ч.))
}
static const BusinessTypeInfo[][BUSINESS_TYPE_e] = {
	// 	  { TypeName,	MapIconID,	MaxProdPrice, isEnterPrice, OrderPrice, TaxDay(24 h.) }
	{ /*00*/BUSINESS_TYPE_NONE, "_", 0/*(иконка)*/, 0/*(макс.цена товара)*/, false/*(цена за вход)*/, 200/*(цена за 1 ед. )*/, 2400/*(налог)*/ },
	{ /*01*/BUSINESS_TYPE_24_7, "24/7", 56/*(иконка)*/, 5_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 5/*(цена за 1 ед. )*/, 7200/*(налог)*/ },
	{ /*02*/BUSINESS_TYPE_CLUCKIN_BELL, "Закусочная Cluckin Bell", 14/*(иконка)*/, 5_000/*(макс.цена товара)*/, true/*(цена за вход)*/, 5/*(цена за 1 ед. )*/, 4800/*(налог)*/ },
	{ /*03*/BUSINESS_TYPE_PIZZA, "Закусочная Pizza", 29/*(иконка)*/, 5_000/*(макс.цена товара)*/, true/*(цена за вход)*/, 5/*(цена за 1 ед. )*/, 4800/*(налог)*/ },
	{ /*04*/BUSINESS_TYPE_BURGER_SHOT, "Закусочная Burger Shot", 10/*(иконка)*/, 5_000/*(макс.цена товара)*/, true/*(цена за вход)*/, 5/*(цена за 1 ед. )*/, 4800/*(налог)*/ },
	{ /*05*/BUSINESS_TYPE_BAR, "Бар", 49/*(иконка)*/, 5_000/*(макс.цена товара)*/, true/*(цена за вход)*/, 10/*(цена за 1 ед. )*/, 4800/*(налог)*/ },
	{ /*06*/BUSINESS_TYPE_CLUB, "Клуб", 48/*(иконка)*/, 5_000/*(макс.цена товара)*/, true/*(цена за вход)*/, 10/*(цена за 1 ед. )*/, 7200/*(налог)*/ },
	{ /*07*/BUSINESS_TYPE_AMMO, "Ammo", 18/*(иконка)*/, 50_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 50/*(цена за 1 ед. )*/, 14400/*(налог)*/ },
	{ /*08*/BUSINESS_TYPE_VICTIM, "Магазин одежды Victim", 45/*(иконка)*/, 100_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 50/*(цена за 1 ед. )*/, 14400/*(налог)*/ },
	{ /*09*/BUSINESS_TYPE_ZIP, "Магазин одежды Zip", 45/*(иконка)*/, 100_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 50/*(цена за 1 ед. )*/, 14400/*(налог)*/ },
	{ /*10*/BUSINESS_TYPE_SUB_URBAN, "Магазин одежды Sub Urban", 45/*(иконка)*/, 100_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 50/*(цена за 1 ед. )*/, 14400/*(налог)*/ },
	{ /*11*/BUSINESS_TYPE_BINCO, "Магазин одежды Binco", 45/*(иконка)*/, 100_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 50/*(цена за 1 ед. )*/, 14400/*(налог)*/ },
	{ /*12*/BUSINESS_TYPE_PROLAPS, "Магазин одежды Pro Laps", 45/*(иконка)*/, 100_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 50/*(цена за 1 ед. )*/, 14400/*(налог)*/ },
	{ /*13*/BUSINESS_TYPE_DIDIER_SACH, "Магазин одежды Didier Sach", 45/*(иконка)*/, 100_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 50/*(цена за 1 ед. )*/, 14400/*(налог)*/ },
	{ /*14*/BUSINESS_TYPE_GAS, "АЗС", 47/*(иконка)*/, 200/*(макс.цена товара)*/, false/*(цена за вход)*/, 5/*(цена за 1 ед. )*/, 7200/*(налог)*/ },
	{ /*15*/BUSINESS_TYPE_CUSTOMS, "СТО", 27/*(иконка)*/, 500_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 1000/*(цена за 1 ед. )*/, 14400/*(налог)*/ },
	{ /*16*/BUSINESS_TYPE_CARAVAN, "Дома на колесах", 55/*(иконка)*/, 7_000_001/*(макс.цена товара)*/, false/*(цена за вход)*/, 200/*(цена за 1 ед. )*/, 28800/*(налог)*/ }, 
	{ /*17*/BUSINESS_TYPE_CASINO, "Казино", 44/*(иконка)*/, 5_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 20/*(цена за 1 ед. )*/, 7200/*(налог)*/ },
	{ /*18*/BUSINESS_TYPE_STALL, "Ларек", 0/*(иконка)*/, 5_000/*(макс.цена товара)*/, false/*(цена за вход)*/, 5/*(цена за 1 ед. )*/, 4800/*(налог)*/ } 
	//{ 07 BUSINESS_TYPE_CLUB, "Клуб Jizzy", 48, 5_000, true, 200, 2400 },
}; 
new Text:BusinessGAS_TD[13], PlayerText:BusinessGAS_PTD[MAX_PLAYERS][3];

enum BUSINESS_INT_e {
	bIntName[32],
	bIntType,
	Float:bIntPos[4],
	bIntInterior,
	Float:bIntMenuPos[3],
	Float:bIntActorPos[4],
	bSkinActor
}
new const BusinessInteriorInfo[][BUSINESS_INT_e] = {
	{
		"Без интерьера", BUSINESS_TYPE_NONE, 
		{ 0.000, 0.000, 0.000, 0.000 }, 7, // (int pos, int id)
		{ 0.000, 0.000, 0.000 }, // (menu pos)
		{ 0.000, 0.000, 0.000, 0.000 },	// (actor pos)
		21 // (actor skin)
	}, 
	{
		"24/7 #1", BUSINESS_TYPE_24_7,
		{483.0694,-2971.9111,580.9855,188.9379}, 6,
		//setFreezePlayerForTime(playerid, 2);
		{ 487.1945,-2979.6221,580.6528 }, // (menu pos) вход
		{ 485.6321, -2980.1042, 580.6528, 271.1353 },	// (actor pos)
		56 // (actor skin)
	},
	{
		"Дом на колесах", BUSINESS_TYPE_CARAVAN,
		{ -2367.9548,-3414.2708,208.1453,91.6207 }, 13, // (int pos, int id)
		{ -2373.9924, -3414.7583, 208.1375 }, // (menu pos)
		{ -2375.4939, -3415.3677, 208.1375, 271.8950},	// (actor pos)
		81 // (actor skin)
	},
	{
		"Burger Shot", BUSINESS_TYPE_BURGER_SHOT,
		{ 460.557, -88.594, 999.555, 0.000 }, 4, // (int pos, int id)
		{ 450.445, -83.6521, 999.555 }, // (menu pos)
		{ 449.4185, -82.2312, 999.5547, 182.7248 },	// (actor pos)
		205 // (actor skin)
	},
	{
		"Cluckin Bell", BUSINESS_TYPE_CLUCKIN_BELL,
		{ 376.8, -192.935, 1000.64, 0.000 }, 17, // (int pos, int id)
		{ 379.239, -187.858, 1000.63 }, // (menu pos)
		{ 380.7900, -189.1097, 1000.6328, 176.4372 },	// (actor pos)
		167 // (actor skin)
	},
	{
		"Pizza", BUSINESS_TYPE_PIZZA,
		{ 372.36, -133.521, 1001.49, 0.000 }, 5, // (int pos, int id)
		{ 375.888, -118.817, 1001.5 }, // (menu pos)
		{ 374.7233, -117.2787, 1001.4922, 180.236 },	// (actor pos)
		155 // (actor skin)
	},
	{
		"Jizzy", BUSINESS_TYPE_CLUB,
		{ -2636.48, 1402.74, 906.461, 0.000 }, 3, // (int pos, int id)
		{ -2654.02, 1407.91, 906.277 }, // (menu pos)
		{ -2655.5071, 1409.6656, 906.2734, 268.8506 },	// (actor pos)
		296 // (actor skin)
	},
	{
		"Alhambra", BUSINESS_TYPE_CLUB,
		{ 493.356, -24.8449, 1000.68, 0.000 }, 17, // (int pos, int id)
		{ 499.97, -20.7076, 1000.68 }, // (menu pos)
		{ 501.6992, -20.5116, 1000.6797, 93.236 },	// (actor pos)
		291 // (actor skin)
	},
	{
		"Ten Green Bottles", BUSINESS_TYPE_BAR,
		{ 501.903, -67.563, 998.758, 0.000 }, 11, // (int pos, int id)
		{ 497.353, -76.0409, 998.758 }, // (menu pos)
		{ 497.7452, -77.4640, 998.7651, 359.214 },	// (actor pos)
		254 // (actor skin)
	},
	{
		"Victim", BUSINESS_TYPE_VICTIM, 
		{ 227.5184, -8.1075, 1002.2109, 93.3823 }, 5, // (int pos, int id)
		{ 206.3742, -7.2307, 1001.2109 }, // (menu pos)
		{ 204.8534, -7.3375, 1001.2109, 271.4802 },	// (actor pos)
		211 // (actor skin)
	},  
	{
		"Zip", BUSINESS_TYPE_ZIP, 
		{ 161.4643, -97.1025, 1001.8047, 356.8748 }, 18, // (int pos, int id)
		{ 161.4499, -83.2564, 1001.8047 }, // (menu pos)
		{ 161.3112, -81.1881, 1001.8047, 177.3146 },	// (actor pos)
		211 // (actor skin)
	}, 
	{
		"Sub Urban", BUSINESS_TYPE_SUB_URBAN, 
		{ 203.7290, -50.6006, 1001.8047, 0.5279 }, 1, // (int pos, int id)
		{ 203.8925, -43.2639, 1001.8047 }, // (menu pos)
		{ 203.7853, -41.6683, 1001.8047, 179.2155 },	// (actor pos)
		217 // (actor skin)
	}, 
	{
		"Binco", BUSINESS_TYPE_BINCO, 
		{ 207.6847, -111.2665, 1005.1328, 359.0681 }, 15, // (int pos, int id)
		{ 207.7738, -100.3268, 1005.2578 }, // (menu pos)
		{ 208.8548, -98.7049, 1005.2578, 175.9986 },	// (actor pos)
		217 // (actor skin)
	},
	{
		"Pro Laps", BUSINESS_TYPE_PROLAPS, 
		{ 207.0318, -140.3471, 1003.5078, 359.7992 }, 3, // (int pos, int id)
		{ 207.1459, -129.1801, 1003.5078 }, // (menu pos)
		{ 206.9604, -127.8041, 1003.5078, 179.9466 },	// (actor pos)
		217 // (actor skin)
	}, 
	{
		"Didier Sach", BUSINESS_TYPE_DIDIER_SACH, 
		{ 204.3598, -168.8207, 1000.5234, 358.773 }, 14, // (int pos, int id)
		{ 204.2722, -159.3511, 1000.5234 }, // (menu pos)
		{ 204.2697, -157.8301, 1000.5234, 178.6282 },	// (actor pos)
		211 // (actor skin)
	}, 
	{
		"Ammo #1", BUSINESS_TYPE_AMMO, 
		{ 285.8501, -86.7820, 1001.5229, 350.2947 }, 4, // (int pos, int id)
		{ 295.6393, -80.8118, 1001.5156 }, // (menu pos)
		{ 295.5821, -82.5275, 1001.5156, 359.6506 },	// (actor pos)
		121 // (actor skin)
	}, 
	{//OLD
		"Customs", BUSINESS_TYPE_CUSTOMS,  
		{ 1494.6783, 1304.0674, 1093.2891, 360.00 }, BUSINESS_CUSTOMS_INTERIOR_ID, // (int pos, int id)
		{ 0.000, 0.000, 0.000 }, // (menu pos)
		{ 1489.0138, 1305.2483, 1093.2964, 270.24980 },	// (actor pos)
		21 // (actor skin)
	},
	/*{
		"Customs", BUSINESS_TYPE_CUSTOMS,  
		{1537.6041, -1372.8738, 3159.5530, 93.2302}, NEWS_AGENCY_INT, // (int pos, int id)
		{1540.9347, -1376.9833, 3159.5530}, // (menu pos)
		{1542.5172, -1377.0154, 3159.5530, 86.9401}, 17	// (actor pos)// (actor skin) 
	},*/
	{
		"Casino #1", BUSINESS_TYPE_CASINO,
		{ 1175.1804, -25.9841, 1000.6875, 180.00 }, 9, // (int pos, int id)
		{ 1168.7222, -37.8312, 1000.6797 }, // (menu pos)
		{ 1167.0251, -37.8307, 1000.6797, 274.387 },	// (actor pos)
		189 // (actor skin)
	}
};
new TOTALBUSINESSES;

enum LIST_MENU_e {
	itemName[32], // (название товара)
	itemProds, // (затраты за 1 ед.)
	itemDefaultPrice, // (стандартная цена товара)
}
static const ListMenuBar[][LIST_MENU_e] = {//Минимальная цена 100 Максимальная 5000
	{ "Тоник", 10, 100 }, //10
	{ "Кола", 10, 100 }, //10
	{ "Кофе", 10, 100 }, //10
	{ "Джин", 10, 200 }, //10
	{ "Пиво", 10, 200 }, //10
	{ "Саке", 10, 200 }, //10
	{ "Водка", 15, 400 }, //15
	{ "Крафтовое пиво", 15, 500 } //15
};
static const ListMenuCasinoBar[][LIST_MENU_e] = {//Минимальная цена 100 Максимальная 5000
	{ "Тоник", 10, 100 }, //10
	{ "Кола", 10, 100 }, //10
	{ "Кофе", 10, 100 }, //10
	{ "Джин", 10, 200 }, //10
	{ "Пиво", 10, 200 }, //10
	{ "Саке", 10, 200 }, //10
	{ "Водка", 15, 400 }, //15
	{ "Крафтовое пиво", 15, 500 } //15
};
static const ListMenuPizza[][LIST_MENU_e] = {//Минимальная цена 100 Максимальная 5000
	{ "Кола", 10, 100 }, //10
	{ "Чай", 10, 100 }, //10
	{ "Кофе", 10, 100 }, //10
	{ "Салат", 15, 150 }, //15
	{ "Пицца Маргарита", 20, 200 }, //20
	{ "Пицца с Ветчиной", 20, 230 }, //20
	{ "Пицца Мясная", 25, 260 }, //25
 	{ "Пицца на пышном тесте", 25, 290 }, //25
	{ "Закрытая Пицца", 30, 400 } //30
};
static const ListMenuCluckinBell[][LIST_MENU_e] = {//Минимальная цена 100 Максимальная 5000
	{ "Кола", 10, 100 }, //10
	{ "Чай", 10, 100 }, //10
	{ "Кофе", 10, 100 }, //10
	{ "Салат", 15, 150 }, //15
	{ "Крылошки гриль", 20, 200 }, //20
	{ "Сочная курочка", 20, 250 }, //20
	{ "Пикантная курочка", 25, 300 }, //25
 	{ "Куринные ножки", 25, 400 }, //25
	{ "Комбо набор", 30, 500 }//30
};
static const ListMenuClub[][LIST_MENU_e] = { //Минимальная цена 100 Максимальная 5000
	{ "Тоник", 10, 100 },//10
	{ "Кола", 10, 100 },//10
	{ "Капучино", 10, 100 },//10
	{ "Джин", 10, 200 },//10
	{ "Пиво", 10, 200 },//10
	{ "Саке", 10, 200 },//10
	{ "Водка", 15, 400 },//15
	{ "Шампанское", 15, 500 },//15
	{ "Текила", 20, 800 },//20
	{ "Виски", 20, 1500 },//20
	{ "Коньяк", 20, 1500 },//20
	{ "Ликёр", 20, 1500 },//20
	{ "Ром", 20, 2000 },//20
	{ "Абсент", 20, 3000 }//20
};
static const ListMenuBurgerShot[][LIST_MENU_e] = {//Минимальная цена 100 Максимальная 5000
	{ "Кола", 10, 100 },//10
	{ "Чай", 10, 100 },//10
	{ "Кофе", 10, 100 },//10
	{ "Салат", 15, 150 },//15
	{ "Гамбургер", 20, 200 },//20
	{ "Двойной Гамбургер", 20, 250 },//20
	{ "Пицца с грибами", 25, 300 },//25
	{ "Грибной суп", 25, 400 },//25
	{ "Рыбный суп", 30, 500 }//30
};
static const ListMenuShop[][LIST_MENU_e] = {//Минимальная цена 100 Максимальная 10000
/*0*/{ "Телефон", 10, 700 },//10
/*1*/{ "Номер телефона", 20, 500 },//20
/*2*/{ "Зажигалка", 10, 500 },//10
/*3*/{ "Сигареты", 10, 500 },//10
/*4*/{ "Аптечка", 20, 500 },//20
/*5*/{ "Телефонная книга", 10, 1000 },//10
/*6*/{ "Фотоаппарат(10шт.)", 15, 1500 },//15
/*7*/{ "Цветы", 20, 1500 },//20
/*8*/{ "Удочка", 10, 2000 },//10
/*9*/{ "Снасти(10шт.)", 10, 1500 },//10
/*10*/{ "Сонар", 10, 1000 },//10
/*11*/{ "Баллончик", 25, 2000 },//25
/*12*/{ "Комплект инструментов (5шт.)", 25, 1500 }//25
};

static const ListMenuCustoms[][LIST_MENU_e] = {//Минимальная цена 1000 Максимальная 50000
	/*0*/{ "Покраска", 10, 5000 },//10
	/*1*/{ "Аэрография", 15, 10000 },//15
	/*2*/{ "Выхлоп", 20, 15000 },//20
	/*3*/{ "Усилитель бампера", 20, 10000 },//20
	/*4*/{ "Ковши", 20, 10000 },//20
	/*5*/{ "Бампера", 20, 20000 },//20
	/*6*/{ "Спойлер", 20, 20000 },//20
	/*7*/{ "Боковая юбка", 20, 5000 },//20
	/*8*/{ "Колеса", 25, 15000 },//25
	/*9*/{ "Гидравлика", 20, 20000 },//20
	/*10*/{ "Нитро", 20, 10000 },//20
	/*11*/{ "Броня", 20, 300_000},//20
	/*12*/{ "Турбина", 30, 500_000},//30
	/*13*/{ "Тормоза", 15, 100_000}//30
};
static const ListMenuAmmo[][LIST_MENU_e] = {//Минимальная цена 1000 Максимальная 50000
	{ "Desert Eagle (21 пт.)", 100, 2000 },//100
	/*1*/{ "Silenced (9 mm) (51 пт.)", 100, 1500 },//100
	{ "Country Rifle (15 пт.)", 100, 3000 },//100
	{ "Shotgun (15 пт.)", 100, 2000 },//100
	{ "SMG (90 пт.)", 100, 2000 },//100
	{ "AK47 (90 пт.)", 100, 2500 },//100
	{ "M4A1 (150 пт.)", 100, 2500 },//100
	{ "Слезоточивый газ", 100, 500 },//100
	{ "Golf Club", 100, 400 },//100
	{ "Бейсбольная бита", 100, 400 },//100
	{ "Лопата", 100, 400 },//100
	{ "Бильярдный кий", 100, 500 },//100
	{ "Катана", 100, 500 },//100
	{ "Розовый дилдо", 100, 700 }//100
};
static const ListMenuClothesMale[][2] ={ 
	{ 25, 1000 }, 
	{ 15, 1000 }, 
	{ 36, 1000 }, 
	{ 50, 1000 }, 
	{ 95, 1000 }, 
	{ 96, 1000 }, 
	{ 136, 1000 }, 
	{ 143, 1000 }, 
	{ 155, 1000 }, 
	{ 2, 50000 }, 
	{ 14, 50000 }, 
	{ 24, 50000 }, 
	{ 58, 100000 }, 
	{ 7, 300000 }, 
	{ 23, 300000 }, 
	{ 33, 300000 }, 
	{ 60, 500000 }, 
	{ 67, 500000 }, 
	{ 73, 500000 }, 
	{ 184, 500000 }, 
	{ 21, 700000 }, 
	{ 22, 700000 }, 
	{ 30, 700000 }, 
	{ 183, 700000 }, 
	{ 255, 700000 }, 
	{ 4, 700000 }, 
	{ 6, 700000 }, 
	{ 8, 700000 }, 
	{ 42, 700000 }, 
	{ 273, 700000 }, 
	{ 17, 1000000 }, 
	{ 45, 1000000 }, 
	{ 82, 1000000 }, 
	{ 83, 1000000 }, 
	{ 185, 1000000 }, 
	{ 290, 1000000 }, 
	{ 291, 1000000 }, 
	{ 28, 1200000 }, 
	{ 29, 1200000 }, 
	{ 248, 1200000 }, 
	{ 247, 1200000 }, 
	{ 254, 1200000 }, 
	{ 249, 1200000 }, 
	{ 18, 1500000 }, 
	{ 19, 1500000 }, 
	{ 47, 1500000 }, 
	{ 48, 1500000 }, 
	{ 101, 1500000 }, 
	{ 299, 1500000 }, 
	{ 289, 1500000 }, 
	{ 61, 2000000 }, 
	{ 121, 2000000 }, 
	{ 227, 2000000 }, 
	{ 228, 2000000 }, 
	{ 292, 2000000 }, 
	{ 293, 2000000 }, 
	{ 297, 2000000 }, 
	{ 122, 2500000 }, 
	{ 111, 3000000 }, 
	{ 117, 3500000 }, 
	{ 118, 3500000 }, 
	{ 126, 4000000 }, 
	{ 127, 4000000 }, 
	{ 296, 4000000 }, 
	{ 3, 4000000 }, 
	{ 119, 4000000 }, 
	{ 208, 4000000 }, 
	{ 295, 4500000 }, 
	{ 46, 5000000 }, 
	{ 294, 5000000 }
};
static const ListMenuClothesFemale[][2] ={ 
	{ 65, 1000 }, 
	{ 192, 10000 }, 
	{ 219, 1000000 }, 
	{ 93, 2000000 }, 
	{ 211, 2000000 }, 
	{ 233, 2000000 }, 
	{ 148, 3000000 }, 
	{ 169, 4000000 }, 
	{ 141, 5000000 }, 
	{ 76, 5000000 }, 
	{ 150, 5000000 }, 
	{ 214, 5000000 }
};
enum BUSINESS_e {
	bID,
	bName[32],
	bOwner[MAX_PLAYER_NAME + 1], // temp
	bBuyPrice,
	bBank,
	bBankToday,
	bUnBankToday,
	bLandTax,
	bLocked,
	bLockedTime,
	bType,
	Float:bPos[4],
	Float:bActionPos[4],
	bInteriorID,
	bItemsPrice[MAX_BUSINESS_ITEMS],
	bItemsSold[MAX_BUSINESS_ITEMS],
	bProducts,
	bMafia,
	bEnterPrice,
	bMessage[64],
	//
	bActorID,
	bActorArea,
	bEnterPickup,
	bExitPickup,
	bBuyPickup,
	
	// Text3D:bBuyPickupText,
	bActionPickup,
	bActionArea,
	bMapIcon,
	Text3D:bTextID,
	Text3D:bActionTextID,
	bWorld,

	bOrderStatus,
	bOrderProducts,
	bOrderDate[20],

	bNewRobStart,
	bool:bRobStatus,
	bRobTimer,
	Text:LoadingProgress,
	Float:TD_Draw
}
new BusinessInfo[MAX_BUSINESSES][BUSINESS_e];


enum {
	FISHING_ROU = 9,
	FISHINT_TICLE,
	FISHINT_SONAR
}
MediumCost(type, itemid)
{
	new	
		total, t_cost;
	for(new i = 0; i < sizeof(BusinessInfo); i++) {
		if (!IsValidBusiness(i)) continue;
		if (!strcmp(BusinessInfo[i][bOwner], "None", true)) continue;
		if (BusinessInfo[i][bType] != type) continue;
		total ++;
		t_cost += BusinessInfo[i][bItemsPrice][itemid];
		
	} 
	if (!total) return 500;
	else return (t_cost/total); 
	
}
stock DestroyBusinessElements(id) {
	if (BusinessInfo[id][bActorID] != -1) {
		DestroyDynamicActor(BusinessInfo[id][bActorID]);
		BusinessInfo[id][bActorID] = -1;
	}	
	if (BusinessInfo[id][bActorArea] != -1) {
		DestroyDynamicArea(BusinessInfo[id][bActorArea]);
		BusinessInfo[id][bActorArea] = -1;
	}	
	if (_:BusinessInfo[id][bTextID] != -1) {
		DestroyDynamic3DTextLabel(BusinessInfo[id][bTextID]);
		BusinessInfo[id][bTextID] = Text3D:-1;
	}	
	if (BusinessInfo[id][bActionArea] != -1) {
		DestroyDynamicArea(BusinessInfo[id][bActionArea]);
		BusinessInfo[id][bActionArea] = -1;
	}	
	if (_:BusinessInfo[id][bActionTextID] != -1) {
		DestroyDynamic3DTextLabel(BusinessInfo[id][bActionTextID]);
		BusinessInfo[id][bActionTextID] = Text3D:-1;
	}	
	if (BusinessInfo[id][bEnterPickup] != -1) {
		DestroyDynamicPickup(BusinessInfo[id][bEnterPickup]);
		BusinessInfo[id][bEnterPickup] = -1;
	}	
	if (BusinessInfo[id][bExitPickup] != -1) {
		DestroyDynamicPickup(BusinessInfo[id][bExitPickup]);
		BusinessInfo[id][bExitPickup] = -1;
	}	
	if (BusinessInfo[id][bBuyPickup] != -1) {
		DestroyDynamicPickup(BusinessInfo[id][bBuyPickup]);
		BusinessInfo[id][bBuyPickup] = -1;
	}	
	if (BusinessInfo[id][bMapIcon] != -1) {
		DestroyDynamicMapIcon(BusinessInfo[id][bMapIcon]);
		BusinessInfo[id][bMapIcon] = -1;
	}
}
stock CreateBusiness(type, price, Float:x, Float:y, Float:z, Float:angle) {
	new id = -1;
	for (new free_id = 0; free_id < sizeof (BusinessInfo); free_id++) {
		if (IsValidBusiness(free_id)) 
			continue;
		id = free_id;
		break;
	}
	if (id == -1) return id;

	BusinessInfo[id][bPos][0] = x;
	BusinessInfo[id][bPos][1] = y;
	BusinessInfo[id][bPos][2] = z;
	BusinessInfo[id][bPos][3] = angle;
	BusinessInfo[id][bType] = type;
	BusinessInfo[id][bBuyPrice] = price;

	format(BusinessInfo[id][bName], 32, "None");
	BusinessInfo[id][bBank] = 0; 
	BusinessInfo[id][bBankToday] = 0; 
	BusinessInfo[id][bUnBankToday] = 0; 
	BusinessInfo[id][bLandTax] = (BusinessTypeInfo[type][bTypeTaxDay] / 24);
	BusinessInfo[id][bLocked] = 0;
	BusinessInfo[id][bLockedTime] = 0;
	BusinessInfo[id][bProducts] = 10_000;
	BusinessInfo[id][bMessage][0] = EOS;

	new interior_id = BusinessInfo[id][bInteriorID]; // GetBusinessInteriorID(i);
	if (interior_id >= sizeof (BusinessInteriorInfo) || BusinessInteriorInfo[interior_id][bIntType] != BusinessInfo[id][bType]) {
		for (new interiorid = 0; interiorid < sizeof (BusinessInteriorInfo); interiorid++) {
			if (BusinessInteriorInfo[interiorid][bIntType] != BusinessInfo[id][bType]) continue;
			BusinessInfo[id][bInteriorID] = interiorid;
			break;
		}
	}

	format(t_string, sizeof (t_string), "INSERT INTO "TABLE_BUSINESS" \
		(`bType`, `bEntranceX`, `bEntranceY`, `bEntranceZ`, `bEntranceA`, `bBuyPrice`, `bIntID`) VALUES \
		(%i, '%.2f', '%.2f', '%.2f', '%.2f', %i, %i)",
		type, x, y, z, angle, price, BusinessInfo[id][bInteriorID]
	);
	new Cache:tempQuery = mysql_query(dbHandle, t_string), rows;

	t_string[0] = EOS;
	cache_get_row_count(rows);

	BusinessInfo[id][bID] = cache_insert_id();
	UpdateBusiness(id, .create = true);

	if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
	
	return id;
}
stock UpdateBusiness(id, create = false) {
	//printf("UpdateBusiness %d %d", id, create);
	if (!(0 <= id < MAX_BUSINESSES)) return false;
	new type = BusinessInfo[id][bType];

	format(t_string, sizeof (t_string), ""colwhi"ID: "C_PODS"%i\n", BusinessInfo[id][bID]);
	format(t_string, sizeof (t_string), "%s"colwhi"Название: "C_PODS"%s\n", t_string, BusinessInfo[id][bName]);

	if (strcmp(BusinessInfo[id][bOwner], "None", true)) {
		format(t_string, sizeof (t_string), "%s"colwhi"Владелец: "C_PODS"%s\n \n", t_string, BusinessInfo[id][bOwner]);
	} else {
		format(t_string, sizeof (t_string), "%s"colwhi"Продаётся: {9ACD32}$%i\n \n", t_string, BusinessInfo[id][bBuyPrice]);
	}
	if (BusinessTypeInfo[type][bTypeEnterPrice] && BusinessInfo[id][bEnterPrice]) {
		format(t_string, sizeof (t_string), "%s"colwhi"Цена за вход: {9ACD32}$%i", t_string, BusinessInfo[id][bEnterPrice]);
	}
	switch (type) {
		case BUSINESS_TYPE_GAS: {
			format(t_string, sizeof (t_string), "%s"colwhi"Цена за литр: {9ACD32}$%i", t_string, BusinessInfo[id][bItemsPrice][0]);
		}
	}
	if (BusinessInfo[id][bMafia]) {
		new mafiaName[16];
		switch (BusinessInfo[id][bMafia]) {
			case FRACTION_LCN: mafiaName = "LCN";
			case FRACTION_YAKUZA: mafiaName = "Yakuza";
			case FRACTION_RUSSIAN: mafiaName = "Русская Мафия";
		}
		format(t_string, sizeof (t_string), "%s"colwhi"\nПод контролем: "C_PODS"%s", t_string, mafiaName);
	}
	if (!strcmp(BusinessInfo[id][bOwner], "None", true)) {
		format(t_string, sizeof (t_string), "%s\n"colwhi"Для покупки, используйте "colserver"/buybiz", t_string, BusinessInfo[id][bBuyPrice]);
	}
	if (!create) {
		UpdateDynamic3DTextLabelText(BusinessInfo[id][bTextID], 0xFFFFFFFF, t_string), t_string[0] = EOS;
	} else {  
		BusinessInfo[id][bTextID] = Text3D:-1;
		BusinessInfo[id][bActionArea] = -1;
		BusinessInfo[id][bActionTextID] = Text3D:-1;
		BusinessInfo[id][bEnterPickup] = -1;
		BusinessInfo[id][bExitPickup] = -1;
		BusinessInfo[id][bBuyPickup] = -1;
		BusinessInfo[id][bMapIcon] = -1;
		BusinessInfo[id][bActorID] = -1;
		BusinessInfo[id][bActorArea] = -1;

		switch (type) {
			case BUSINESS_TYPE_GAS: {
				BusinessInfo[id][bActionArea] = CreateDynamicSphere(
					BusinessInfo[id][bPos][0],
					BusinessInfo[id][bPos][1],
					BusinessInfo[id][bPos][2] + 0.7, 7.5, 
					.worldid = 0, .interiorid = 0
				);
				SetDynamicAreaType(BusinessInfo[id][bActionArea], AREA_TYPE_FILLING, id);
			}
			case BUSINESS_TYPE_CUSTOMS: {
				BusinessInfo[id][bActionArea] = -1;
	
				if (BusinessInfo[id][bActionPos][0] != 0.0) {
					BusinessInfo[id][bActionTextID] = CreateDynamic3DTextLabel("Посигнальте, чтобы заехать", 0xFFFFFFFF, 
						BusinessInfo[id][bActionPos][0],
						BusinessInfo[id][bActionPos][1],
						BusinessInfo[id][bActionPos][2] + 0.7, 5.0, 
						.worldid = 0, .interiorid = 0
					);
					BusinessInfo[id][bActionPickup] = CreateDynamicPickup(3096, 23, 
						BusinessInfo[id][bActionPos][0],
						BusinessInfo[id][bActionPos][1],
						BusinessInfo[id][bActionPos][2],
						.worldid = 0, .interiorid = 0
					);
				}
			}
		}
		BusinessInfo[id][bTextID] = CreateDynamic3DTextLabel(t_string, 0xFFFFFFFF, 
			BusinessInfo[id][bPos][0],
			BusinessInfo[id][bPos][1],
			BusinessInfo[id][bPos][2] + 0.7, 5.0, 
			.worldid = 0, .interiorid = 0
		);
		t_string[0] = EOS;
	
		new interior_id = BusinessInfo[id][bInteriorID]; // GetBusinessInteriorID(id)
		if (BusinessInteriorInfo[interior_id][bIntActorPos][0] != 0.0) {
			BusinessInfo[id][bActorArea] = CreateDynamicSphere(
				BusinessInteriorInfo[interior_id][bIntActorPos][0],
				BusinessInteriorInfo[interior_id][bIntActorPos][1],
				BusinessInteriorInfo[interior_id][bIntActorPos][2],
				50.0,
				.worldid = BusinessInfo[id][bWorld], 
				.interiorid = BusinessInteriorInfo[interior_id][bIntInterior]	
			);
			BusinessInfo[id][bActorID] = CreateDynamicActor(BusinessInteriorInfo[interior_id][bSkinActor], 
				BusinessInteriorInfo[interior_id][bIntActorPos][0],
				BusinessInteriorInfo[interior_id][bIntActorPos][1],
				BusinessInteriorInfo[interior_id][bIntActorPos][2],
				BusinessInteriorInfo[interior_id][bIntActorPos][3],
				.worldid = BusinessInfo[id][bWorld], 
				.interiorid = BusinessInteriorInfo[interior_id][bIntInterior]
			);
			SetDynamicAreaType(BusinessInfo[id][bActorArea], AREA_TYPE_ACTOR_BIZ, id);
		}
		if (BusinessInteriorInfo[interior_id][bIntMenuPos][0] != 0.0) {
			BusinessInfo[id][bBuyPickup] = CreateDynamicPickup(1239, 23, 
				BusinessInteriorInfo[interior_id][bIntMenuPos][0],
				BusinessInteriorInfo[interior_id][bIntMenuPos][1],
				BusinessInteriorInfo[interior_id][bIntMenuPos][2],
				.worldid = BusinessInfo[id][bWorld], 
				.interiorid = BusinessInteriorInfo[interior_id][bIntInterior]
			); 
			/*BusinessInfo[id][bBuyPickupText] = CreateDynamic3DTextLabel("Меню покупки", 0xFFFFFFFF, 
				BusinessInteriorInfo[interior_id][bIntMenuPos][0],
				BusinessInteriorInfo[interior_id][bIntMenuPos][1],
				BusinessInteriorInfo[interior_id][bIntMenuPos][2] + 0.7, 5.0, 
				.worldid = 0, .interiorid = 0
			);*/
		}
		if (BusinessInteriorInfo[interior_id][bIntPos][0] != 0.0) {
			BusinessInfo[id][bExitPickup] = CreateDynamicPickup(1318, 23, 
				BusinessInteriorInfo[interior_id][bIntPos][0],
				BusinessInteriorInfo[interior_id][bIntPos][1],
				BusinessInteriorInfo[interior_id][bIntPos][2],
				.worldid = BusinessInfo[id][bWorld], 
				.interiorid = BusinessInteriorInfo[interior_id][bIntInterior]
			);
		}
		switch (type) {
			case BUSINESS_TYPE_GAS: { }
			case BUSINESS_TYPE_CUSTOMS: {
				BusinessInfo[id][bEnterPickup] = CreateDynamicPickup(19134, 23, 
					BusinessInfo[id][bPos][0],
					BusinessInfo[id][bPos][1],
					BusinessInfo[id][bPos][2],
					.worldid = 0, .interiorid = 0
				);
			}
			default: {
				BusinessInfo[id][bEnterPickup] = CreateDynamicPickup(19132, 23, 
					BusinessInfo[id][bPos][0],
					BusinessInfo[id][bPos][1],
					BusinessInfo[id][bPos][2],
					.worldid = 0, .interiorid = 0
				);
			}
		}
		BusinessInfo[id][bMapIcon] = CreateDynamicMapIcon(
			BusinessInfo[id][bPos][0],
			BusinessInfo[id][bPos][1],
			BusinessInfo[id][bPos][2],
			BusinessTypeInfo[type][bTypeMapIcon], 0, 0, 0, -1, 120.0
		);  
	}
	return true;
} 
stock LoadBusinesses() {
	new 
		time = GetTickCount(), rows,
		Cache:tempQuery = mysql_query(dbHandle, "SELECT * FROM "TABLE_BUSINESS"");
	
	cache_get_row_count(rows);

	if (!rows) {
		print(!"[Загрузка ...] Данные из Businesses не получены!");
		if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
		return;
	}
	for(new i = 0, itemPrice[156]; i < rows; i++) {
		if (TOTALBUSINESSES >= sizeof (BusinessInfo)) {
			printf(!"[Загрузка ...] Бизнес #%i не был загружен из-за лимита \"MAX_BUSINESSES\"!", TOTALBUSINESSES);
			break;
		}
		//printf("%d", i);
		cache_get_value_name_int(i, "id", BusinessInfo[i][bID]);

		cache_get_value_name(i, "bOwner", BusinessInfo[i][bOwner], MAX_PLAYER_NAME + 1);
		cache_get_value_name(i, "bName", BusinessInfo[i][bName], 32);
		cache_get_value_name(i, "bMessage", BusinessInfo[i][bMessage], 64);

		cache_get_value_name_int(i, "bEnterPrice", BusinessInfo[i][bEnterPrice]);

		cache_get_value_name_float(i, "bEntranceX", BusinessInfo[i][bPos][0]);
		cache_get_value_name_float(i, "bEntranceY", BusinessInfo[i][bPos][1]);
		cache_get_value_name_float(i, "bEntranceZ", BusinessInfo[i][bPos][2]);
		cache_get_value_name_float(i, "bEntranceA", BusinessInfo[i][bPos][3]);
		
		cache_get_value_name_float(i, "bActionX", BusinessInfo[i][bActionPos][0]);
		cache_get_value_name_float(i, "bActionY", BusinessInfo[i][bActionPos][1]);
		cache_get_value_name_float(i, "bActionZ", BusinessInfo[i][bActionPos][2]);
		cache_get_value_name_float(i, "bActionA", BusinessInfo[i][bActionPos][3]);

		cache_get_value_name_int(i, "bBank", BusinessInfo[i][bBank]);
		cache_get_value_name_int(i, "bLandTax", BusinessInfo[i][bLandTax]);

		cache_get_value_name_int(i, "bIntID", BusinessInfo[i][bInteriorID]);
		cache_get_value_name_int(i, "bMafia", BusinessInfo[i][bMafia]);
		cache_get_value_name_int(i, "bType", BusinessInfo[i][bType]);
		cache_get_value_name_int(i, "bBuyPrice", BusinessInfo[i][bBuyPrice]);

		cache_get_value_name_int(i, "bLocked", BusinessInfo[i][bLocked]);
		cache_get_value_name_int(i, "bLockedTime", BusinessInfo[i][bLockedTime]);
		cache_get_value_name_int(i, "bProducts", BusinessInfo[i][bProducts]);

		cache_get_value_name_int(i, "bBankToday", BusinessInfo[i][bBankToday]);
		cache_get_value_name_int(i, "bUnBankToday", BusinessInfo[i][bUnBankToday]);

		cache_get_value_name_int(i, "bOrderProducts", BusinessInfo[i][bOrderProducts]);
		cache_get_value_name(i, "bOrderDate", BusinessInfo[i][bOrderDate], 20);

		cache_get_value_name(i, "bItemsPrice", itemPrice, sizeof (itemPrice));
		sscanf(itemPrice, "p<|>a<i>["#MAX_BUSINESS_ITEMS"]", BusinessInfo[i][bItemsPrice]); // 0|0|..|0
		cache_get_value_name(i, "bItemsSold", itemPrice, sizeof (itemPrice));
		sscanf(itemPrice, "p<|>a<i>["#MAX_BUSINESS_ITEMS"]", BusinessInfo[i][bItemsSold]); // 0|0|..|0

		BusinessInfo[i][bWorld] = BusinessInfo[i][bID];
		BusinessInfo[i][bRobStatus] = false; 

		if (!strcmp(BusinessInfo[i][bOwner], "None", true)) {
			BusinessInfo[i][bProducts] = 1000000;
		}
		new interior_id = BusinessInfo[i][bInteriorID]; // GetBusinessInteriorID(i);
		if (interior_id >= sizeof (BusinessInteriorInfo) || BusinessInteriorInfo[interior_id][bIntType] != BusinessInfo[i][bType]) {
			for (new interiorid = 0; interiorid < sizeof (BusinessInteriorInfo); interiorid++) {
				if (BusinessInteriorInfo[interiorid][bIntType] != BusinessInfo[i][bType]) continue;
				BusinessInfo[i][bInteriorID] = interiorid;

				format(t_string, sizeof (t_string), 
					"UPDATE "TABLE_BUSINESS" SET bIntID = %i WHERE id = '%i'", 
					interiorid, BusinessInfo[i][bID]
				);
				mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;

				break;
			}
		}
		new bool:isPriceChanges = false;
		switch (BusinessInfo[i][bType]) {
			case BUSINESS_TYPE_GAS: {
				if (BusinessInfo[i][bItemsPrice][0] <= 0) {
					BusinessInfo[i][bItemsPrice][0] = 5;
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_CARAVAN: {
				if (BusinessInfo[i][bItemsPrice][0] <= 4000000) {
					BusinessInfo[i][bItemsPrice][0] = 7000000;
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_24_7: {
				for (new idx = 0; idx < sizeof (ListMenuShop); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuShop[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_CLUCKIN_BELL: {
				for (new idx = 0; idx < sizeof (ListMenuCluckinBell); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuCluckinBell[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_PIZZA: {
				for (new idx = 0; idx < sizeof (ListMenuPizza); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuPizza[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_BURGER_SHOT: {
				for (new idx = 0; idx < sizeof (ListMenuBurgerShot); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuBurgerShot[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_BAR: {
				for (new idx = 0; idx < sizeof (ListMenuBar); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuBar[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_CASINO: {
				for (new idx = 0; idx < sizeof (ListMenuCasinoBar); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuCasinoBar[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_CLUB: {
				for (new idx = 0; idx < sizeof (ListMenuClub); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuClub[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_AMMO: {
				for (new idx = 0; idx < sizeof (ListMenuAmmo); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuAmmo[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
			}
			case BUSINESS_TYPE_CUSTOMS: {
				for (new idx = 0; idx < sizeof (ListMenuCustoms); idx++) {
					if (BusinessInfo[i][bItemsPrice][idx] != 0) continue;
					BusinessInfo[i][bItemsPrice][idx] = ListMenuCustoms[idx][itemDefaultPrice];
					isPriceChanges = true;
				}
				/*
					[23:57:42] CUSTOMS ID: 46 LV
					[23:57:42] CUSTOMS ID: 47 SF
					[23:57:42] CUSTOMS ID: 48 LS
				*/
				//printf("CUSTOMS ID: %d",BusinessInfo[i][bID]);
				//mysql_format(dbHandle, query_, sizeof query_, "SELECT * FROM `s_vehicle_family` WHERE `vFamily` = '%d' LIMIT 5", FamilyInfo[F_IDX][fID]);
        		//mysql_tquery(dbHandle, query_, "OnLoadFamilyCarData", "");
			}


			case 
				BUSINESS_TYPE_VICTIM, BUSINESS_TYPE_ZIP, BUSINESS_TYPE_SUB_URBAN, 
				BUSINESS_TYPE_BINCO, BUSINESS_TYPE_PROLAPS, BUSINESS_TYPE_DIDIER_SACH: {
				// clothes
				isPriceChanges = false;

			}
		}
		if (isPriceChanges) {
			format(t_string, sizeof (t_string), "bItemsPrice = '%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i'",
				BusinessInfo[i][bItemsPrice][0], BusinessInfo[i][bItemsPrice][1], BusinessInfo[i][bItemsPrice][2], BusinessInfo[i][bItemsPrice][3], 
				BusinessInfo[i][bItemsPrice][4], BusinessInfo[i][bItemsPrice][5], BusinessInfo[i][bItemsPrice][6], BusinessInfo[i][bItemsPrice][7], 
				BusinessInfo[i][bItemsPrice][8], BusinessInfo[i][bItemsPrice][9], BusinessInfo[i][bItemsPrice][10], BusinessInfo[i][bItemsPrice][11], 
				BusinessInfo[i][bItemsPrice][12], BusinessInfo[i][bItemsPrice][13], BusinessInfo[i][bItemsPrice][14], BusinessInfo[i][bItemsPrice][15], 
				BusinessInfo[i][bItemsPrice][16], BusinessInfo[i][bItemsPrice][17], BusinessInfo[i][bItemsPrice][18], BusinessInfo[i][bItemsPrice][19]
			);
			SaveBusiness(i, t_string);
		}
		UpdateBusiness(i, .create = true);
		TOTALBUSINESSES++;
	}
	printf("[Загрузка ...] Данные из Businesses получены! (%d шт.) Время: %d", TOTALBUSINESSES, GetTickCount() - time);
	if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
}
stock ShowBusinessBuyMenu(playerid, id, menu_type = 0) {
	new type = BusinessInfo[id][bType];
	t_string[0] = EOS;
	if (!menu_type && (strcmp(BusinessInfo[id][bOwner], "None", true) && (!BusinessInfo[id][bProducts] || BusinessInfo[id][bLocked]))) {
		SendClientMessage(playerid, COLOR_GREY, !"В бизнесе закончились продукты, либо он закрыт!");
		return false;
	}
	switch (type) {
		case BUSINESS_TYPE_24_7: {
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO) 
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuShop); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuShop[i][itemName], ListMenuShop[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {

					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuShop[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		case BUSINESS_TYPE_CLUCKIN_BELL: {
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO) 
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuCluckinBell); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuCluckinBell[i][itemName], ListMenuCluckinBell[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {

					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuCluckinBell[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		case BUSINESS_TYPE_PIZZA: {
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO) 
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuPizza); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuPizza[i][itemName], ListMenuPizza[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {
					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuPizza[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		case BUSINESS_TYPE_BURGER_SHOT: {
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO) 
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuBurgerShot); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuBurgerShot[i][itemName], ListMenuBurgerShot[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {
					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuBurgerShot[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		
		case BUSINESS_TYPE_BAR: {
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO) 
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuBar); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuBar[i][itemName], ListMenuBar[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {
					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuBar[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		case BUSINESS_TYPE_CASINO: {
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO) 
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuCasinoBar); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuCasinoBar[i][itemName], ListMenuCasinoBar[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {
					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuCasinoBar[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		case BUSINESS_TYPE_CLUB: {
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO) 
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuClub); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuClub[i][itemName], ListMenuClub[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {
					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuClub[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		case BUSINESS_TYPE_AMMO: {
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO)
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuAmmo); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuAmmo[i][itemName], ListMenuAmmo[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {
					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuAmmo[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		case 
			BUSINESS_TYPE_VICTIM, BUSINESS_TYPE_ZIP, BUSINESS_TYPE_SUB_URBAN, 
			BUSINESS_TYPE_BINCO, BUSINESS_TYPE_PROLAPS, BUSINESS_TYPE_DIDIER_SACH: {
			ShowPlayerDialog(playerid, D_BUSINESS_BUY_LIST, DIALOG_STYLE_LIST, ""colserver"Магазин одежды", ""colwhi"\
				[0] Покупка одежды\n\
				[1] Покупка аксессуаров",
				"Выбрать", "Отмена"
			);
			return true;
		}
		case BUSINESS_TYPE_GAS: {
			// show buy fill
			if (!menu_type) {
				if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) {
					SendClientMessage(playerid, -1, "Вы должны находиться за рулем транспорта!");
					return false;
				}
				new 
					vehicleid = GetPlayerVehicleID(playerid),
					Float:avaliableAmount = GetModelMaxFuel(VehicleInfo[ vehicleid - 1 ][vModel]) - VehicleInfo[vehicleid - 1][vFuel];

				if (!floatround(avaliableAmount)) {
					SendClientMessage(playerid, COLOR_GRAD1, !"У вас уже полный бак!");
					return false;
				}
				ShowMenuGAS(playerid);
				/*format(t_string, sizeof (t_string), ""colwhi"\
					"colwhi"Введите кол-во литров топлива, которое хотите заправить:\n\n\
					"colwhi"Цена топлива: "collime"$%d / л.\n\n\
					"colwhi"У вас еще помещается "colserver"%i л.", 
					BusinessInfo[id][bItemsPrice][0],
					floatround(avaliableAmount)
				);
				ShowPlayerDialog(playerid, D_BUSINESS_BUY_MENU, DIALOG_STYLE_INPUT, ""colserver"Транспорт: "colwhi"Заправка", t_string, "Купить", "Отмена");
				*/
				t_string[0] = EOS;
				return true;
			}
			//
		}
		case BUSINESS_TYPE_CUSTOMS: {
			if (!menu_type) {
				// show TD customs
				return true;
			}
			if (menu_type == D_BUSINESS_PANEL_PROD_INFO)
				t_string = ""colserver"Название\t"colserver"Затраты / ед.\t"colserver"Продано (сегодня)\n"colwhi"";
			else t_string = ""colserver"Название\t"colserver"Стоимость\n";

			for (new i = 0; i < sizeof (ListMenuCustoms); i++) {
				if (menu_type == D_BUSINESS_PANEL_PROD_INFO) {
					format(t_string, sizeof (t_string), "%s[%i] %s\t%i прод.\t%d ед.\n", t_string,
						i, ListMenuCustoms[i][itemName], ListMenuCustoms[i][itemProds], BusinessInfo[id][bItemsSold][i]
					);
				} else {

					format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string,
						i, ListMenuCustoms[i][itemName], BusinessInfo[id][bItemsPrice][i]
					);
				}
			}
		}
		case BUSINESS_TYPE_CARAVAN: {
			new IsPlayerVehicleSpawn;
			if (Iter_Count(PlayerListVehicle[playerid]) != 0) {
				foreach(new vehicleid: PlayerListVehicle[playerid]) {
					if (!IsVehicleInterior(vehicleid)) continue;
					IsPlayerVehicleSpawn = vehicleid;
					break;
				}
			}
			if (IsPlayerVehicleSpawn && IsVehicleTypeInterior(IsPlayerVehicleSpawn) == 2)  {
				SendClientMessage(playerid, COLOR_GREY, !"У вас уже есть дом на колесах!");
				return false;
			}
			format(t_string, sizeof (t_string), ""colwhi"\
				Добрый день, Вас приветствует сотрудница магазина, {ffcc00}Kelly Ross.\n\
				"colwhi"Мы предоставляем Дома на колёсах за "collime"$%d"colwhi"\n\
				Преимущества:\n\
				\t- Спавн в вашем доме, там где Вы желаете "collime"\"/park\""colwhi"\n\
				\t- Не большой шкаф\n\n\
				Мы Вас заинтересовали?", 
				BusinessInfo[id][bItemsPrice][0]
			);
			ShowPlayerDialog(playerid, D_BUSINESS_BUY_MENU, DIALOG_STYLE_MSGBOX, ""colserver"Транспорт: "colwhi"Дом на колёсах", t_string, "Купить", "Отмена");

			t_string[0] = EOS;
			return true;
		}
		default: printf("[error] Business #%i has bad type.", id);
	}
	switch (menu_type) {
		case D_BUSINESS_PANEL_PRICE_LIST: {
			ShowPlayerDialog(playerid, D_BUSINESS_PANEL_PRICE_LIST, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Бизнес: "colwhi"Изменение цен", t_string, "Купить", "Отмена");	 
		}
		case D_BUSINESS_PANEL_PROD_INFO: {
			ShowPlayerDialog(playerid, D_BUSINESS_PANEL_PROD_INFO, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Информация о продуктах", t_string, "Назад", "");
		}
		default: {
			ShowPlayerDialog(playerid, D_BUSINESS_BUY_MENU, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Меню покупки", t_string, "Купить", "Отмена");
		}
	}
	t_string[0] = EOS;
	return true;
}
stock ShowBusinessPanel(playerid, dialogid) {
	//if(dialogid != D_BUSINESS_PANEL_SELECT && pTemp[playerid][tCurrentBusinessID] == -1) {
	new id = pTemp[playerid][tCurrentBusinessID], type = BusinessInfo[id][bType];
	//}
	
	/*if (
		(dialogid != D_BUSINESS_PANEL_SELECT && 
		dialogid != D_BUSINESS_PANEL_SELECT_BANK && 
		dialogid != D_BUSINESS_PANEL_SELECT_SELL) && 
		strcmp(BusinessInfo[id][bOwner], pInfo[playerid][pName], true)
	) {
		return false;
	}*/
	switch (dialogid) {
		case D_BUSINESS_ORDERS_MENU: {
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, ""colserver"Развозчик продуктов", ""colwhi"\
				[0] Список заказов\n\
				[1] Статистика", "Выбрать", "Отмена"
			);
		}
		case D_BUSINESS_ORDERS_LIST: {
			new idx = 0;
			format(t_string, sizeof (t_string), "\
				"colserver"Название бизнеса\t"colserver"Тип\t"colserver"Заказ\t"colserver"Цена загрузки\n");
			for (new i = 0; i < sizeof (BusinessInfo); i++) {
				if (!IsValidBusiness(i)) 
					continue;
				if (!strcmp(BusinessInfo[i][bOwner], "None", true)) 
					continue;
				if (BusinessInfo[i][bType] == BUSINESS_TYPE_GAS) 
					continue;
				if (!BusinessInfo[i][bOrderProducts]) 
					continue;
				if (BusinessInfo[i][bOrderStatus]) // (выполняется ли заказ уже | 0 - нет)
					continue;
				format(t_string, sizeof (t_string), "%s\
					"colwhi"[%i] %s\t%s\t%i ед.\t$%i\n", t_string,
					idx, BusinessInfo[i][bName],
					BusinessTypeInfo[BusinessInfo[i][bType]][bTypeName],
					BusinessInfo[i][bOrderProducts],
					(BusinessInfo[i][bOrderProducts] * BusinessTypeInfo[BusinessInfo[i][bType]][bTypeOrderPrice] * 50 / 100)
				);
				playerListItem[playerid][idx++] = i;
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Список заказов", t_string, "Принять", "Отмена");
			
			t_string[0] = EOS;
		}
		case D_BUSINESS_ORDERS_LIST_GAS: {
			new idx = 0;
			format(t_string, sizeof (t_string), "\
				"colserver"Название бизнеса\t"colserver"Тип\t"colserver"Заказ\t"colserver"Цена загрузки\n");
			for (new i = 0; i < sizeof (BusinessInfo); i++) {
				if (!IsValidBusiness(i)) 
					continue;
				if (!strcmp(BusinessInfo[i][bOwner], "None", true)) 
					continue;
				if (BusinessInfo[i][bType] != BUSINESS_TYPE_GAS) 
					continue;
				if (!BusinessInfo[i][bOrderProducts]) 
					continue;
				if (BusinessInfo[i][bOrderStatus]) // (выполняется ли заказ уже | 0 - нет)
					continue;
				format(t_string, sizeof (t_string), "%s\
					"colwhi"[%i] %s\t%s\t%i л.\t$%i\n", t_string,
					idx, BusinessInfo[i][bName],
					BusinessTypeInfo[BusinessInfo[i][bType]][bTypeName],
					BusinessInfo[i][bOrderProducts],
					(BusinessInfo[i][bOrderProducts] * BusinessTypeInfo[BusinessInfo[i][bType]][bTypeOrderPrice] * 50 / 100)
				);
				playerListItem[playerid][idx++] = i;
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Список заказов", t_string, "Принять", "Отмена");
		}
		case D_BUSINESS_PANEL_BANK: {
			format(t_string, sizeof (t_string), "\
				"colserver"[№] Операции\t"colserver"Баланс\n\
				"colwhi"[0] Пополнить счет бизнеса (Кассу)\t"collime"$%d\n\
				"colwhi"[1] Снять со счета бизнеса\t"collime"$%d\n\
				"colwhi"[2] Пополнить счет на оплату налога\t"collime"$%d", 
				BusinessInfo[id][bBank], BusinessInfo[id][bBank], BusinessInfo[id][bLandTax]
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Управление счетом бизнеса", t_string, "Принять", "Отмена");
		}
		case D_BUSINESS_PANEL_BANK_DEPOSIT: {
			format(t_string, sizeof (t_string), ""colwhi"\
				Пополнение счета бизнеса "colserver"\"%s\""colwhi":\n \n\
				Введите сумму оплаты, которую хотите произвести:\n \n\
				Сейчас на счету бизнеса: "collime"$%i.",
				BusinessInfo[id][bName], BusinessInfo[id][bBank]
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Пополнить счет бизнеса", t_string, "Принять", "Отмена");
		}
		case D_BUSINESS_PANEL_BANK_WITHDRAW: {
			format(t_string, sizeof (t_string), ""colwhi"\
				Снятие со счета вашего бизнеса "colserver"\"%s\""colwhi":\n \n\
				Введите сумму, которую хотите снять:\n \n\
				Сейчас на счету бизнеса: "collime"$%i",
				BusinessInfo[id][bName], BusinessInfo[id][bBank]
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Снятие со счета бизнеса", t_string, "Принять", "Отмена");
		}
		case D_BUSINESS_PANEL_BANK_LANDTAX: {
			type = BusinessInfo[id][bType];
			format(t_string, sizeof (t_string), ""colwhi"\
				Оплата налогов на Ваш бизнес "colserver"\"%s\""colwhi":\n \n\
				Укажите на сколько дней вы хотите оплатить Ваш бизнес:\n \n\
				Сейчас на счету бизнеса: "collime"$%i"colwhi" | Оплаченых дней: "C_PODS"%d\n\
				"colwhi"Суточная сумма налогов на Ваш тип бизнеса: "collime"$%d\n\
				"colwhi"Каждый час с счета бизнеса списываеться: "collime"$%d",
				BusinessInfo[id][bName], BusinessInfo[id][bLandTax], (BusinessInfo[id][bLandTax] / BusinessTypeInfo[type][bTypeTaxDay]),
				BusinessTypeInfo[type][bTypeTaxDay], (BusinessTypeInfo[type][bTypeTaxDay] / 24)
			);//day_count = (BusinessInfo[id][bLandTax] / BusinessTypeInfo[type][bTypeTaxDay])
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Оплата бизнеса", t_string, "Принять", "Отмена");
		}
		case D_BUSINESS_PANEL_SELECT: {
			t_string = ""colserver"Тип бизнеса\t"colserver"Название\t"colserver"Продуктов\n"colwhi"";
			new idx = 0;
			for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if (!pInfo[playerid][pBusinessID][i]) continue;
				id = pInfo[playerid][pBusinessID][i] - 1;
				type = BusinessInfo[id][bType];

				format(t_string, sizeof (t_string), "%s[%i] %s\t%s\t%d\n", t_string,
					i, BusinessTypeInfo[type][bTypeName], BusinessInfo[id][bName], BusinessInfo[id][bProducts]
				);
				playerListItem[playerid][idx++] = id;
			}
			if (idx == 0) {
				SendClientMessage(playerid, COLOR_GREY, "У вас нет ниодного бизнеса!");
				return false;
			}
			ShowPlayerDialog(playerid, D_BUSINESS_PANEL_SELECT, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Выберите бизнес", t_string, "Выбрать", "Отмена");
		}
		case D_BUSINESS_PANEL_SELECT_BANK: {
			t_string = ""colserver"Тип бизнеса\t"colserver"Название\n"colwhi"";
			new idx = 0;
			for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if (!pInfo[playerid][pBusinessID][i]) continue;
				id = pInfo[playerid][pBusinessID][i] - 1;
				type = BusinessInfo[id][bType];

				format(t_string, sizeof (t_string), "%s[%i] %s\t%s\n", t_string,
					i, BusinessTypeInfo[type][bTypeName], BusinessInfo[id][bName]
				);
				playerListItem[playerid][idx++] = id;
			}
			if (idx == 0) {
				SendClientMessage(playerid, -1, "У вас нет ниодного бизнеса!");
				return false;
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Выберите бизнес", t_string, "Выбрать", "Отмена");
		}

		case D_BUSINESS_PANEL_SELECT_BIZINFO: {
			t_string = ""colserver"Тип бизнеса\t"colserver"Название\n"colwhi"";
			new idx = 0;
			for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if (!pInfo[playerid][pBusinessID][i]) continue;
				id = pInfo[playerid][pBusinessID][i] - 1;
				type = BusinessInfo[id][bType];

				format(t_string, sizeof (t_string), "%s[%i] %s\t%s\n", t_string,
					i, BusinessTypeInfo[type][bTypeName], BusinessInfo[id][bName]
				);
				playerListItem[playerid][idx++] = id;
			}
			if (idx == 0) {
				SendClientMessage(playerid, COLOR_GREY, !"У вас нет ниодного бизнеса!");
				return false;
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Бизнес: "colwhi"Выберите", t_string, "Выбрать", "Отмена");
		}
		case D_BUSINESS_PANEL_SHOW_BIZINFO: { 
			new 
				query_[128],
				select_biz = pTemp[playerid][tCurrentBusinessID], targetid = pTemp[playerid][tBusinessShowBizTargetID];
			if (AntiCheatGetDialog(targetid) != -1) {
				SendClientMessage(playerid, COLOR_GREY, !"У игрока открыт диалог");
				pTemp[playerid][tBusinessShowBizTargetID] = INVALID_PLAYER_ID;
				return false;
			}
			format(query_, sizeof (query_), "SELECT * FROM `sh_business` WHERE `bBizID` = '%d' AND `bDate` >= DATE(NOW()) - INTERVAL 7 DAY", 
				BusinessInfo[select_biz][bID]
			);
			new rows, Cache:tempQuery = mysql_query(dbHandle, query_);
			cache_get_row_count(rows);
			if (!rows) {
				if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
				//ShowBusinessPanel(playerid, D_BUSINESS_PANEL_SHOW_BIZINFO);
				SendMes(targetid, COLOR_YELLOW, !"[Подсказка] "colwhi"История доходов бизнеса %s не найдена!", BusinessInfo[select_biz][bName]);
				SendMes(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"История доходов бизнеса %s не найдена!", BusinessInfo[select_biz][bName]);
				pTemp[playerid][tBusinessShowBizTargetID] = INVALID_PLAYER_ID;
				return false;
			} 
			t_string[0] = EOS; 
			strcat(t_string, ""colserver"[№] Дата\t"colserver"Доход\t"colserver"Расход\t"colserver"Средний чек\n"); 
			new	
				string_[200];
			for(new i = 0, bDate[16], profit_, bUnMoney; i < rows; i ++) { 
				cache_get_value_name(i, "bDate", bDate, 16);
				cache_get_value_name_int(i, "bProfit", profit_); 
				cache_get_value_name_int(i, "bUnProfit", bUnMoney);  
				format(string_, sizeof string_, ""colwhi"[%d] %s\t"collime"$%d\t"collime"$%d\t"collime"$%d\n", i, bDate, profit_, bUnMoney, (profit_/24));
				strcat(t_string, string_);
			}  
			if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
			format(string_, sizeof string_, 
				"\n"colwhi"- Доходы за сегодня: "collime"$%d\n\
				"colwhi"- Расходы за сегодня: "collime"$%d\n\
				"colwhi"- Средний чек за сегодня: "collime"$%d", 
				BusinessInfo[select_biz][bBankToday], BusinessInfo[select_biz][bUnBankToday], (BusinessInfo[select_biz][bBankToday] / 24)
			);
			strcat(t_string, string_);
			ShowPlayerDialog(targetid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Бизнес: "colwhi"Статистика доходов", t_string, "Закрыть", "Назад"); 
			SendMes(playerid, 0x6495EDFF, "Вы показали %s историю дохода бизнеса %s", pInfo[targetid][pName], BusinessInfo[select_biz][bName]);
			SendMes(targetid, 0x6495EDFF, "%s показал Вам историю доходов бизнеса %s", pInfo[playerid][pName], BusinessInfo[select_biz][bName]);
			return true;
		} 

		case D_BUSINESS_PANEL_SELECT_SELL: {
			t_string = ""colserver"Тип бизнеса\t"colserver"Название\n"colwhi"";
			new idx = 0;
			for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if (!pInfo[playerid][pBusinessID][i]) continue;
				id = pInfo[playerid][pBusinessID][i] - 1;
				type = BusinessInfo[id][bType];

				format(t_string, sizeof (t_string), "%s[%i] %s\t%s\n", t_string,
					i, BusinessTypeInfo[type][bTypeName], BusinessInfo[id][bName]
				);
				playerListItem[playerid][idx++] = id;
			}
			if (idx == 0) {
				SendClientMessage(playerid, -1, "У вас нет ниодного бизнеса!");
				return false;
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Выберите бизнес для продажи", t_string, "Выбрать", "Отмена");
		}
		case D_BUSINESS_PANEL_CONFIRM_SELL: {
			new sell_id = pTemp[playerid][tCurrentBusinessID], targetid = pTemp[playerid][tBusinessTempTargetID];
	
			format(t_string, sizeof (t_string), "\
				"colwhi"Вы выбрали бизнес %s: "colserver"%s.\n\
				"colwhi"Покупатель: "colserver"%s [%i]\n\n\
				"colwhi"Введите стоимость продажи:",
				BusinessTypeInfo[BusinessInfo[sell_id][bType]][bTypeName],
				BusinessInfo[sell_id][bName],
				pInfo[targetid][pName], targetid

			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Продажа бизнеса", t_string, "Принять", "Отмена");
		}
		case D_BUSINESS_PANEL_MAIN: {
			format(t_string, sizeof (t_string), "\
				"colwhi"[0] Информация о бизнесе\n\
				"colwhi"[1] %s "colwhi"бизнес\n\
				"colwhi"[2] Изменить сообщение при входе\n\
				"colwhi"[3] Управление ценами товаров\n\
				"colwhi"[4] Управление продуктами\n\
				"colwhi"[5] История доходов\n\
				"colwhi"[6] {B22222}Продать бизнес\n",
				(BusinessInfo[id][bLocked]) ? (""collime"Открыть") : (""colred"Закрыть")
			);
			if (BusinessTypeInfo[type][bTypeEnterPrice]) strcat(t_string, ""colwhi"[7] Изменить цену входа");
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST, 
				""colserver"Бизнесы: "colwhi"панель управления", 
				t_string, "Выбрать", "Отмена"
			);
		}
		case D_BUSINESS_PANEL_INFO: {
			new mafiaName[16];
			switch (BusinessInfo[id][bMafia]) {
				case FRACTION_LCN: mafiaName = "LCN";
				case FRACTION_YAKUZA: mafiaName = "Yakuza";
				case FRACTION_RUSSIAN: mafiaName = "Русская Мафия";
				default: mafiaName = "Нет";
			}
			format(t_string, sizeof (t_string), "\
				"colwhi"ID бизнеса: "colserver"%i\n \n\
				"colwhi"Название бизнеса: "colserver"%s\n\
				"colwhi"Государственная стоимость: "collime"$%i\n\
				"colwhi"Тип бизнеса: "colserver"%s\n \n\
				"colwhi"Владелец бизнеса: "colserver"%s\n\
				"colwhi"Под контролем (крыша): "colserver"%s\n\
				"colwhi"Налог (в час): "collime"$%i\n\n\
				"colwhi"Счет на оплату налогов: "collime"$%d\n\
				"colwhi"Банковский счет: "collime"$%i.\n\
				"colwhi"Продуктов: "colserver"%i ед\n\n\
				"colwhi"Время простоя: "colserver"%d %s",
				BusinessInfo[id][bID],
				BusinessInfo[id][bName],
				BusinessInfo[id][bBuyPrice],
				BusinessTypeInfo[type][bTypeName],
				BusinessInfo[id][bOwner],
				mafiaName,//Declension_ReturnWord(BusinessInfo[id][bLockedTime], "час", "часа", "часов"));
				(BusinessTypeInfo[type][bTypeTaxDay] / 24),
				BusinessInfo[id][bLandTax],
				BusinessInfo[id][bBank],//BusinessInfo[id][bLandTax]
				BusinessInfo[id][bProducts], BusinessInfo[id][bLockedTime], Declension_ReturnWord(BusinessInfo[id][bLockedTime], "час", "часа", "часов")
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, 
				""colserver"Бизнесы: "colwhi"Информация", 
				t_string, "Назад", ""
			);
		}
		case D_BUSINESS_PANEL_MESSAGE: {
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Бизнесы: "colwhi"Сообщение при входе", "\
				"colwhi"Введите сообщение, которое будет выдаваться при входе:", "Принять", "Назад"
			);
		}
		case D_BUSINESS_PANEL_PROD_MENU: {
			format(t_string, sizeof (t_string), ""colwhi"\
				[0] Информация о продуктах\n\
				[1] Заказать продукты\n"
			);
			if (BusinessInfo[id][bOrderProducts]) {
				format(t_string, sizeof (t_string), "%s[2] Отменить активный заказ "colserver"[%i ед.]", t_string,
					BusinessInfo[id][bOrderProducts]
				);
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, ""colserver"Бизнесы: "colwhi"Управление продуктами", t_string, "Выбрать", "Назад");
		}
		case D_BUSINESS_PANEL_PROD_INFO: {
			ShowBusinessBuyMenu(playerid, id, .menu_type = D_BUSINESS_PANEL_PROD_INFO);
		}
		case D_BUSINESS_PANEL_ENTER_PRICE: {
			format(t_string, sizeof (t_string), ""colwhi"Введите новую цену для входа:\n \n\
				Текущая цена: "collime"$%i", BusinessInfo[id][bEnterPrice]
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Цена за вход", t_string, "Принять", "Отмена");
		}
		case D_BUSINESS_PANEL_HISTORY_TRADE: { 
			new query_[128];
			format(query_, sizeof (query_), "SELECT * FROM `sh_business` WHERE `bBizID` = '%d' AND `bDate` >= DATE(NOW()) - INTERVAL 7 DAY", 
				BusinessInfo[id][bID]
			);
			new rows, Cache:tempQuery = mysql_query(dbHandle, query_);
			cache_get_row_count(rows);
			if (!rows) {
				if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"История доходов Вашего бизнеса не найдена!");
				return false;
			} 
			t_string[0] = EOS; 
			strcat(t_string, ""colserver"[№] Дата\t"colserver"Доход\t"colserver"Расход\t"colserver"Средний чек\n"); 
			new	
				string_[200];
			for(new i = 0, bDate[16], profit_, bUnMoney; i < rows; i ++) { 
				cache_get_value_name(i, "bDate", bDate, 16);
				cache_get_value_name_int(i, "bProfit", profit_); 
				cache_get_value_name_int(i, "bUnProfit", bUnMoney);  
				format(string_, sizeof string_, ""colwhi"[%d] %s\t"collime"$%d\t"collime"$%d\t"collime"$%d\n", i, bDate, profit_, bUnMoney, (profit_/24));
				strcat(t_string, string_);
			}  
			if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
			format(string_, sizeof string_, 
				"\n"colwhi"- Доходы за сегодня: "collime"$%d\n\
				"colwhi"- Расходы за сегодня: "collime"$%d\n\
				"colwhi"- Средний чек за сегодня: "collime"$%d", 
				BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday], (BusinessInfo[id][bBankToday] / 24)
			);
			strcat(t_string, string_);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Бизнес: "colwhi"Статистика Доходов", t_string, "Закрыть", "Назад"); 
		}
		case D_BUSINESS_PANEL_PROD_ORDER: {
			format(t_string, sizeof (t_string), "\
				"colwhi"Введите кол-во продуктов, которое хотите заказать ("#BUSINESS_MIN_PRODUCTS" - "#BUSINESS_MAX_ORDER_PROD"):\n\n\
				Цена за 1 ед. продуктов: "collime"$%i\n\
				"colwhi"Сейчас в бизнесе: "colserver"%d ед.",
				BusinessTypeInfo[type][bTypeOrderPrice], BusinessInfo[id][bProducts]
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Бизнесы: "colwhi"Заказ продуктов", 
				t_string, "Заказать", "Назад"
			);
			return true;
		}
		case D_BUSINESS_PANEL_PRICE_LIST: {
			ShowBusinessBuyMenu(playerid, id, .menu_type = D_BUSINESS_PANEL_PRICE_LIST);
		}
		case D_BUSINESS_PANEL_PRICE_SET: {
			new listitem = playerListItem[playerid][0];
			switch (type) {
				case BUSINESS_TYPE_CARAVAN: 
					format(t_string, sizeof (t_string), " (Дом на колёсах)");
				case BUSINESS_TYPE_GAS: 
					format(t_string, sizeof (t_string), " (за 1 л.)");
				case BUSINESS_TYPE_24_7: 
					format(t_string, sizeof (t_string), " (%s)", ListMenuShop[listitem][itemName]);
				case BUSINESS_TYPE_CLUCKIN_BELL, BUSINESS_TYPE_PIZZA, BUSINESS_TYPE_BURGER_SHOT: 
					format(t_string, sizeof (t_string), " (%s)", ListMenuBurgerShot[listitem][itemName]);
				case BUSINESS_TYPE_BAR, BUSINESS_TYPE_CLUB: 
					format(t_string, sizeof (t_string), " (%s)", ListMenuClub[listitem][itemName]);
				case BUSINESS_TYPE_AMMO: 
					format(t_string, sizeof (t_string), " (%s)", ListMenuAmmo[listitem][itemName]);
				default: t_string[0] = EOS;
			}
			format(t_string, sizeof (t_string), "\
				"colwhi"Введите новую цену товара%s:\n\
				Примечание: Цена должна быть от $1 до $%d!\n\n\
				Текущая цена: "collime"$%d",
				t_string, BusinessTypeInfo[type][bTypeMaxProdPrice], BusinessInfo[id][bItemsPrice][listitem]
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, 
				""colserver"Бизнесы: "colwhi"Цена товаров", 
				t_string, "Принять", "Отмена"
			);
		}
		case D_BUSINESS_PANEL_SELL: {
			format(t_string, sizeof (t_string), ""colwhi"\
				Вы действительно хотите продать бизнес "colserver"(%s: %s)"colwhi" государству?\n\n\
				"colwhi"Государственная стоимость: "collime"$%d\n\
				"colwhi"Стоимость продажи: "collime"$%d",
				BusinessTypeInfo[type][bTypeName], BusinessInfo[id][bName],
				BusinessInfo[id][bBuyPrice], floatround(BusinessInfo[id][bBuyPrice] / BUSINESS_SELL_DIVISION_RATIO) + (BusinessInfo[id][bBank] - BusinessInfo[id][bBank]/10)
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, 
				""colserver"Бизнесы: "colwhi"Продажа бизнеса", 
				t_string, "Продать", "Назад"
			);
		}
		case D_BUSINESS_ADD_BIZ_TYPE: {
			new idx = 0;
			t_string[0] = EOS;

			for (new i = 1; i < sizeof (BusinessTypeInfo); i++) {
				format(t_string, sizeof (t_string), "%s[%i] %s\n", t_string,
					i, BusinessTypeInfo[i][bTypeName]
				);
				playerListItem[playerid][idx++] = i;
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, ""colserver"Бизнесы: "colwhi"Выберите тип", t_string, "Принять", "Назад");
		}
		case D_BUSINESS_ADD_BIZ_PRICE: {
			format(t_string, sizeof (t_string), ""colwhi"\
				Введите стоимость для бизнеса:"
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Бизнесы: "colwhi"Стоимость", t_string, "Далее", "Отмена");
		}
		case D_BUSINESS_EDIT_MENU: {
			format(t_string, sizeof (t_string), ""colwhi"\
				"colwhi"[0] Изменить название бизнеса "colserver"[%s]\n\
				"colwhi"[1] Изменить стоимость бизнеса "colserver"[$%i]\n\
				"colwhi"[2] Изменить интерьер бизнеса "colserver"[%s]\n\
				"colwhi"[3] Изменить тип бизнеса "colserver"[%s]\n\
				"colwhi"[4] Переместить точку входа в бизнес (где стоите)\n\
				"colwhi"[5] Переместить доп.точку бизнеса (для СТО, дом на колесах и т.п.)\n\
				"colwhi"[6] "colwarn"Продать бизнес гос-ву\n\
				"colwhi"[7] "colred"Удалить бизнес",
				BusinessInfo[id][bName],
				BusinessInfo[id][bBuyPrice],
				BusinessInteriorInfo[BusinessInfo[id][bInteriorID]][bIntName],
				BusinessTypeInfo[BusinessInfo[id][bType]][bTypeName]
			);
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, ""colserver"Бизнесы: "colwhi"Редактирование", t_string, "Выбрать", "Отмена");
		}
		case D_BUSINESS_EDIT_NAME: {
			format(t_string, sizeof (t_string), ""colwhi"Введите новое название для бизнеса:");
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Бизнесы: "colwhi"Название", t_string, "Принять", "Назад");
		}
		case D_BUSINESS_EDIT_PRICE: {
			format(t_string, sizeof (t_string), ""colwhi"Введите новую стоимость для бизнеса:");
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_INPUT, ""colserver"Бизнесы: "colwhi"Стоимость", t_string, "Принять", "Назад");
		}
		case D_BUSINESS_EDIT_INTERIOR_ID: {
			new idx = 0;
			t_string[0] = EOS;

			for (new i = 0; i < sizeof (BusinessInteriorInfo); i++) {
				if (BusinessInteriorInfo[i][bIntType] != BusinessInfo[id][bType]) 
					continue; 
				format(t_string, sizeof (t_string), "%s[%i] %s\n", t_string,
					i, BusinessInteriorInfo[i][bIntName]
				);
				playerListItem[playerid][idx++] = i;
			}
			if (strlen(t_string) < 1) SendClientMessage(playerid,-1,!"У этого бизнеса нет интерьера!"); 
			else ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, ""colserver"Бизнесы: "colwhi"Выберите интерьер", t_string, "Принять", "Назад");
		}
		case D_BUSINESS_EDIT_TYPE: {
			new idx = 0;
			t_string[0] = EOS;

			for (new i = 1; i < sizeof (BusinessTypeInfo); i++) {
				format(t_string, sizeof (t_string), "%s[%i] %s\n", t_string,
					i, BusinessTypeInfo[i][bTypeName]
				);
				playerListItem[playerid][idx++] = i;
			}
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_LIST, ""colserver"Бизнесы: "colwhi"Выберите новый тип", t_string, "Принять", "Назад");
		}
		case D_BUSINESS_EDIT_DELETE: {
			format(t_string, sizeof (t_string), ""colwhi"Вы действительно хотите удалить данный бизнес?");
			ShowPlayerDialog(playerid, dialogid, DIALOG_STYLE_MSGBOX, ""colserver"Бизнесы: "colwhi"Название", t_string, "Принять", "Назад");
		}
	}
	t_string[0] = EOS;
	return true;
}
stock PayBusinessItem(playerid, id, itemid, amount, price) {
	new type = BusinessInfo[id][bType];

	format(t_string, sizeof (t_string), "pay biz%d item%i a%i", id, itemid, amount);
	kLibGivePlayerMoney(playerid, -price, t_string), t_string[0] = EOS;
	switch (type) {
		case 
			BUSINESS_TYPE_VICTIM, BUSINESS_TYPE_ZIP, BUSINESS_TYPE_SUB_URBAN, 
			BUSINESS_TYPE_BINCO, BUSINESS_TYPE_PROLAPS, BUSINESS_TYPE_DIDIER_SACH: {
				BusinessInfo[id][bBank] += price;
				BusinessInfo[id][bBankToday] += price; 
		}
		case BUSINESS_TYPE_CARAVAN: {
			new 
				balance_ = (price*5)/100; // 5 % даем бизнесу
			BusinessInfo[id][bBank] += balance_;
			BusinessInfo[id][bBankToday] += balance_;
			BusinessInfo[id][bItemsSold][itemid] += amount;
		} 
		default: {
			BusinessInfo[id][bBank] += price;
			BusinessInfo[id][bBankToday] += price;  
			BusinessInfo[id][bItemsSold][itemid] += amount;
		}
	}   
	format(t_string, sizeof (t_string), "bProducts = %i, bBank = %i, bBankToday = %i, bItemsSold = '%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i'",
		BusinessInfo[id][bProducts], BusinessInfo[id][bBank], BusinessInfo[id][bBankToday],
		BusinessInfo[id][bItemsSold][0], BusinessInfo[id][bItemsSold][1], BusinessInfo[id][bItemsSold][2], BusinessInfo[id][bItemsSold][3],
		BusinessInfo[id][bItemsSold][4], BusinessInfo[id][bItemsSold][5], BusinessInfo[id][bItemsSold][6], BusinessInfo[id][bItemsSold][7],
		BusinessInfo[id][bItemsSold][8], BusinessInfo[id][bItemsSold][9], BusinessInfo[id][bItemsSold][10], BusinessInfo[id][bItemsSold][11],
		BusinessInfo[id][bItemsSold][12], BusinessInfo[id][bItemsSold][13], BusinessInfo[id][bItemsSold][14], BusinessInfo[id][bItemsSold][15],
		BusinessInfo[id][bItemsSold][16], BusinessInfo[id][bItemsSold][17], BusinessInfo[id][bItemsSold][18], BusinessInfo[id][bItemsSold][19]
	);
	SaveBusiness(id, t_string), t_string[0] = EOS;
}
stock BuyBusinessItem(playerid, itemid, amount = 1) {
	new 
		id = pTemp[playerid][tBusinessID],
		type = BusinessInfo[id][bType];

	new price = BusinessInfo[id][bItemsPrice][itemid] * amount;
	if (!price) {
		SendClientMessage(playerid, -1, !"Владелец еще не установил цену за данный товар!");
		ShowBusinessBuyMenu(playerid, id);
		return false;
	}
	if (kLibGetPlayerMoney(playerid) < price) {
		SendClientMessage(playerid, -1, !"У вас недостаточно средств!");
		ShowBusinessBuyMenu(playerid, id);
		return false;
	}
	switch (type) {
		case BUSINESS_TYPE_GAS: {
			if (BusinessInfo[id][bProducts] < amount) {
				SendClientMessage(playerid, -1, "Недостаточно топлива в бизнесе!");
				return false;
			}
			if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
				return false;
			BusinessInfo[id][bProducts] -= amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно заправили транспорт на %i л. за "collime"$%i!",
				amount, price
			); 
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			new vehicleid = GetPlayerVehicleID(playerid);
			VehicleInfo[vehicleid - 1][vFuel] += (amount * 1.0);
			if (VehicleInfo[vehicleid - 1][vFuel] > GetModelMaxFuel(VehicleInfo[ vehicleid - 1 ][vModel])) 
				VehicleInfo[vehicleid - 1][vFuel] = GetModelMaxFuel(VehicleInfo[ vehicleid - 1 ][vModel]);

			return true;
		}
		case BUSINESS_TYPE_CARAVAN: {
			if (BusinessInfo[id][bProducts] < amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
	
		/*	if (pInfo[playerid][pHouseID] != -1 || pInfo[playerid][pRentHouse] != -1) {
				SendClientMessage(playerid, COLOR_GREY, !"У Вас уже есть кварира/дом!");
				return false;
			}*/
            if (GetPlayerVehicleCount(playerid, TYPE_CARAVAN) == 1) {
				SendClientMessage(playerid, -1, !"У Вас уже есть дом на колесах");
				return false;
			}
			BusinessInfo[id][bProducts] -= amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 

			new
				rSpawnSlot = random(7),
				SALON_SPAWN_ID = 0;
	
			if (!SALON_SPAWN_ID) SALON_SPAWN_ID = 0;
            new	new_vehicle_id = _CreateVehicle(508,
				TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][0], TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][1], TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][2],
				TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][3], 0, 0, -1);

			VehicleInfo[new_vehicle_id - 1][vModel] = GetVehicleModel(new_vehicle_id); //,
			t_string[0] = EOS;
		
			mysql_format(dbHandle, t_string, sizeof (t_string), "\
				INSERT INTO `s_vehicle_player`(`vModel`,`vOwner`,`vColor`,`vPos`,`vBuyDate`,`vTypeCar`) VALUES \
				('508','%d','0|0','%f|%f|%f|%f',NOW(),'3')",
				pInfo[playerid][pID],
				TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][0],
				TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][1],
				TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][2],
				TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][3]
			);
            mysql_tquery(dbHandle, t_string, "create_vehicle_callback", "d", new_vehicle_id), t_string[0] = EOS;

			//_DestroyVehicle(ts_vehicle);

			VehicleInfo[new_vehicle_id - 1][vType] = VEHICLE_TYPE_PLAYER;
			VehicleInfo[new_vehicle_id - 1][vVehicle] = new_vehicle_id;
			format(VehicleInfo[new_vehicle_id - 1][vNumber], 12, "None");
			VehicleInfo[new_vehicle_id - 1][vPos][0] = TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][0];
			VehicleInfo[new_vehicle_id - 1][vPos][1] = TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][1];
			VehicleInfo[new_vehicle_id - 1][vPos][2] = TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][2];
			VehicleInfo[new_vehicle_id - 1][vPos][3] = TrailerShopReSpawn[SALON_SPAWN_ID][rSpawnSlot][3];
			VehicleInfo[new_vehicle_id - 1][vColor][0] = 0;
			VehicleInfo[new_vehicle_id - 1][vColor][1] = 0;
			VehicleInfo[new_vehicle_id - 1][vFuel] = GetModelMaxFuel(VehicleInfo[ new_vehicle_id - 1 ][vModel]);
			VehicleInfo[new_vehicle_id - 1][vMillage] = 0.0;
			VehicleInfo[new_vehicle_id - 1][vFine] = 3;
            VehicleInfo[new_vehicle_id - 1][vMoney] = 0;
			VehicleInfo[new_vehicle_id - 1][vFillBag] = 0;
			VehicleInfo[new_vehicle_id - 1][vRepair] = 0;
			VehicleInfo[new_vehicle_id - 1][vDrugs] = 0;
			VehicleInfo[new_vehicle_id - 1][vMaterials] = 0;
	
			for(new t = 0; t < 6; t++) {
		        VehicleInfo[new_vehicle_id - 1][vBootGun][t] = 0;
		        VehicleInfo[new_vehicle_id - 1][vBootAmmo][t] = 0;
			}
			VehicleInfo[new_vehicle_id - 1][vLocked] = true;
			GetVehicleParamsEx(new_vehicle_id, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
			SetVehicleParamsEx(new_vehicle_id, engine1, lights2, alarm2, true, bonnet2, boot1, objective1);

			VehicleInfo[new_vehicle_id - 1][vFraction] = pInfo[playerid][pID]; 

			SetVehicleNumberPlate(VehicleInfo[new_vehicle_id - 1][vVehicle], VehicleInfo[new_vehicle_id - 1][vNumber]);
			Iter_Add(PlayerListVehicle[playerid], VehicleInfo[new_vehicle_id - 1][vVehicle]);

			format(t_string, sizeof (t_string), "Вы успешно приобрели дом на колесах за "collime"$%i!",
				price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
			SendMes(playerid, -1, "Ваш "collime"Дом на колёсах "colwhi"доставлен на парковку");
			UpdateVehiclevText(playerid, new_vehicle_id, true);
			return true;
		}


		case BUSINESS_TYPE_24_7: {
			if (BusinessInfo[id][bProducts] < ListMenuShop[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			switch (itemid) { // выдача товара
				case 0: { // (Телефон)
					SendClientMessage(playerid, COLOR_GREY, "У Вас уже есть телефон!");
					return false;
				}
				case 1: { // (Номер) 
					ShowPlayerDialog(playerid, D_BUSINESS_BUY_SIM, DIALOG_STYLE_INPUT, ""colserver"24/7: "colwhi"SIM-Card",
						"\n"colwhi"Введите номер, который хотите купить:\n\
						\t"colgrey" - Длина номера телефона должна быть 6 цифр\n\
						\t"colgrey" - Пример: XXYYZZ", "Купить", "Закрыть"
					); 
					SetPVarInt(playerid, "SelectBizIDItems", id);	 
					SetPVarInt(playerid, "SelectBizPriceItems", price);  
					return false;
				}
				case 2: { // (Зажигалка)
					if (pInfo[playerid][pLighter]) {
						SendClientMessage(playerid, COLOR_GREY, !"У Вас уже есть зажигалка!");
						return false;
					}
					pInfo[playerid][pLighter] = 1;
					SavePlayerInteger(playerid, "pLighter", pInfo[playerid][pLighter]);
				}
				case 3: { // (Сигареты)
				    if (pInfo[playerid][pCigarettes] != 0) {
						SendClientMessage(playerid, COLOR_GREY, !"У Вас уже есть пачка сигарет! (/ciga - остаток сигарет)");
						return false;
					}
					pInfo[playerid][pCigarettes] = 20;
					SavePlayerInteger(playerid, "pCigarettes", pInfo[playerid][pCigarettes]);
					SendClientMessage(playerid, COLOR_BLUE, !"(( Команда /smoke - закурить, /ciga - остаток сигарет ))");
				}
				case 4: { // (Аптечка)
				    if (pInfo[playerid][sAptechka] >= 20) {
						SendClientMessage(playerid, -1, !"Вы не можете преобрести больше аптечек.");
						return false;
					}
					pInfo[playerid][sAptechka]++;
					SavePlayerInteger(playerid, "sAptechka", pInfo[playerid][sAptechka]);
				
					SendClientMessage(playerid, COLOR_BLUE, !"(( Команда /healme - восстановить здоровье. ))");
				}
				case 5: { // (Телефонная книга)
    				if (pInfo[playerid][pDirectory]) {
						SendClientMessage(playerid, COLOR_GREY, !"У Вас уже есть телефонная книга!");
						return false;
					}
					pInfo[playerid][pDirectory] = 1;
					SavePlayerInteger(playerid, "pDirectory", pInfo[playerid][pDirectory]);
		
					SendClientMessage(playerid, COLOR_BLUE, !"(( Команда /directory - справочник, /number - узнать номер телефона игрока ))");
				}
				
				case 6: { // (Фотоаппарат(10шт.))
					GivePlayerWeapon(playerid, 43, 10);
				}
				case 7: { // (Цветы)
				    if (HaveWeapon(playerid, 41)) {
						SendClientMessage(playerid, COLOR_GREY, !"У Вас уже есть цветы.");
						return false;
					}
					GivePlayerWeapon(playerid, 14, 1);
				}

				case 8: { // (Удочка) 
					if (GetSearchItems(playerid, 102)) {
						SendClientMessage(playerid, COLOR_GREY, !"У Вас уже есть удочка!");
						return false;
					} 
					GivePlayerItem(playerid, 102, 1);
				}
				case 9: { // (Снасти(10шт.)) 
					pInfo[playerid][pFishesTicle] += 10;
					SavePlayerInteger(playerid, "pFishesTicle", pInfo[playerid][pFishesTicle]);
				}
				case 10: { // (Сонар) 
					Sonar[playerid] = RandomFIX(500, 2500); 
				}
				case 11: { // (Баллончик)
				    if (HaveWeapon(playerid, 41)) {
						SendClientMessage(playerid, COLOR_GREY, !"У Вас уже есть баллончик с краской.");
						return false;
					}
					GivePlayerWeapon(playerid, 41, 1500);
				}
				case 12: { // (Комплект инструментов (5шт.))
				    if (pInfo[playerid][sTool] >= 1) {
						err(!"У Вас уже есть инструменты.");
						return false;
					}
					pInfo[playerid][sTool] = 5;
					SendClientMessage(playerid, COLOR_BLUE, !"(( Команда /rem - починить машину. ))");
				}

			}
			BusinessInfo[id][bProducts] -= ListMenuShop[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за "collime"$%i!",
				ListMenuShop[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
	
			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
		case BUSINESS_TYPE_CLUCKIN_BELL: {
			if (BusinessInfo[id][bProducts] < ListMenuCluckinBell[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			BusinessInfo[id][bProducts] -= ListMenuCluckinBell[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за "collime"$%i!",
				ListMenuCluckinBell[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			switch (itemid) { // выдача товара
				case 0: { // (Кола)
					GivePlayerSatiety(playerid, 100);
				}
				case 1: { // (Чай)
					GivePlayerSatiety(playerid, 100);
				}
				case 2: { // (Кофе)
					GivePlayerSatiety(playerid, 100);
				}
				case 3: { // (Салат)
					GivePlayerSatiety(playerid, 200);
				}
				case 4: { // (Крылошки гриль)
					GivePlayerSatiety(playerid, 400);
				}
				case 5: { // (Сочная курочка)
					GivePlayerSatiety(playerid, 400);
				}
				case 6: { // (Пикантная курочка)
					GivePlayerSatiety(playerid, 600);
				}
				case 7: { // (Куринные ножки)
					GivePlayerSatiety(playerid, 800);
				}
				case 8: { // (Комбо набор)
					GivePlayerSatiety(playerid, 1000);
				}
			}
			ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);

			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
		case BUSINESS_TYPE_PIZZA: {
			if (BusinessInfo[id][bProducts] < ListMenuPizza[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			BusinessInfo[id][bProducts] -= ListMenuPizza[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за "collime"$%i!",
				ListMenuPizza[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			switch (itemid) { // выдача товара
				case 0: { // (Кола) 
					GivePlayerSatiety(playerid, 100);
				}
				case 1: { // (Чай) 
					GivePlayerSatiety(playerid, 100);
				}
				case 2: { // (Кофе) 
					GivePlayerSatiety(playerid, 100);
				}
				case 3: { // (Салат) 
					GivePlayerSatiety(playerid, 500);
				}
				case 4: { // (Пицца Маргарита) 
					GivePlayerSatiety(playerid, 1000);
				}
				case 5: { // (Пицца с Ветчиной) 
					//
					GivePlayerSatiety(playerid, 1000);
				}
				case 6: { // (Пицца Мясная) 
					GivePlayerSatiety(playerid, 1000);
				}
				case 7: { // (Пицца на пышном тесте) 
					GivePlayerSatiety(playerid, 1000);
				}
				case 8: { // (Закрытая Пицца) 
					GivePlayerSatiety(playerid, 1000);
				}
			}
			ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);

			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
		case BUSINESS_TYPE_BURGER_SHOT: {
			if (BusinessInfo[id][bProducts] < ListMenuBurgerShot[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			BusinessInfo[id][bProducts] -= ListMenuBurgerShot[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за "collime"$%i!",
				ListMenuBurgerShot[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			switch (itemid) { // выдача товара
				case 0: { // (Кола) 
					GivePlayerSatiety(playerid, 100);
				}
				case 1: { // (Чай) 
					GivePlayerSatiety(playerid, 100);
				}
				case 2: { // (Кофе) 
					GivePlayerSatiety(playerid, 100);
				}
				case 3: { // (Салат) 
					GivePlayerSatiety(playerid, 200);
				}
				case 4: { // (Гамбургер) 
					GivePlayerSatiety(playerid, 400);
				}
				case 5: { // (Двойной Гамбургер) 
					GivePlayerSatiety(playerid, 500);
				}
				case 6: { // (Пицца с грибами) 
					GivePlayerSatiety(playerid, 600);
				}
				case 7: { // (Грибной суп) 
					GivePlayerSatiety(playerid, 800);
				}
				case 8: { // (Рыбный суп) 
					GivePlayerSatiety(playerid, 1000);
				}
			}
			ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);

			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
		case BUSINESS_TYPE_BAR: {
			if (BusinessInfo[id][bProducts] < ListMenuBar[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			BusinessInfo[id][bProducts] -= ListMenuBar[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за "collime"$%i!",
				ListMenuBar[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
			new drunk_level = 0;
			switch (itemid) { // выдача товара
				case 0: { // (Тоник) 
					GivePlayerSatiety(playerid, 100);
					drunk_level = 2000;
				}
				case 1: { // (Кола) 
					GivePlayerSatiety(playerid, 100);
				}
				case 2: { // (Кофе) 
					GivePlayerSatiety(playerid, 100);
				}
				case 3: { // (Джин) 
					GivePlayerSatiety(playerid, 200);
					drunk_level = 2000;
				}
				case 4: { // (Пиво) 
					GivePlayerSatiety(playerid, 200);
					drunk_level = 2000;
				}
				case 5: { // (Саке) 
					GivePlayerSatiety(playerid, 400);
					drunk_level = 3000;
				}
				case 6: { // (Водка) 
					GivePlayerSatiety(playerid, 450);
					drunk_level = 5000;
				}
				case 7: { // (Крафтовое пиво) 
					GivePlayerSatiety(playerid, 300);
					drunk_level = 3000;
				}
			}
			ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
			if(GetPlayerDrunkLevel(playerid) < 20000) {
				SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid)+drunk_level);
			}
			if(GetPlayerDrunkLevel(playerid) > 20000) SetPlayerDrunkLevel(playerid, 20000);
			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
		case BUSINESS_TYPE_CASINO: {
			if (BusinessInfo[id][bProducts] < ListMenuCasinoBar[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			BusinessInfo[id][bProducts] -= ListMenuCasinoBar[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за "collime"$%i!",
				ListMenuCasinoBar[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
			new drunk_level = 0;
			switch (itemid) { // выдача товара
				case 0: { // (Тоник) 
					GivePlayerSatiety(playerid, 100);
					drunk_level = 2000;
				}
				case 1: { // (Кола) 
					GivePlayerSatiety(playerid, 100);
				}
				case 2: { // (Кофе) 
					GivePlayerSatiety(playerid, 100);
				}
				case 3: { // (Джин) 
					GivePlayerSatiety(playerid, 200);
					drunk_level = 2000;
				}
				case 4: { // (Пиво) 
					GivePlayerSatiety(playerid, 200);
					drunk_level = 2000;
				}
				case 5: { // (Саке) 
					GivePlayerSatiety(playerid, 400);
					drunk_level = 3000;
				}
				case 6: { // (Водка) 
					GivePlayerSatiety(playerid, 450);
					drunk_level = 5000;
				}
				case 7: { // (Крафтовое пиво) 
					GivePlayerSatiety(playerid, 300);
					drunk_level = 3000;
				}
			}
			ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
			if(GetPlayerDrunkLevel(playerid) < 20000) {
				SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid)+drunk_level);
			}
			if(GetPlayerDrunkLevel(playerid) > 20000) SetPlayerDrunkLevel(playerid, 20000);
			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
		case BUSINESS_TYPE_CLUB: {
			if (BusinessInfo[id][bProducts] < ListMenuClub[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			BusinessInfo[id][bProducts] -= ListMenuClub[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 

			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за "collime"$%i!",
				ListMenuClub[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
			new drunk_level = 0;
			switch (itemid) { // выдача товара
				case 0: { // (Тоник) 
					GivePlayerSatiety(playerid, 100);
					drunk_level = 2000;
				}
				case 1: { // (Кола) 
					GivePlayerSatiety(playerid, 100);
				}
				case 2: { // (Капучино) 
					GivePlayerSatiety(playerid, 100);
				}
				case 3: { // (Джин) 
					GivePlayerSatiety(playerid, 200);
				}
				case 4: { // (Пиво) 
					GivePlayerSatiety(playerid, 200);
				}
				case 5: { // (Саке) 
					GivePlayerSatiety(playerid, 400);
					drunk_level = 3000;
				}
				case 6: { // (Водка)
					GivePlayerSatiety(playerid, 450);
					drunk_level = 5000;
				}
				case 7: { // (Шампанское) 
					GivePlayerSatiety(playerid, 700);
					drunk_level = 4000;
				}
				case 8: { // (Текила) 
					GivePlayerSatiety(playerid, 1000);
					drunk_level = 5000;
				}
				case 9: { // (Виски) 
					GivePlayerSatiety(playerid, 1000);
					drunk_level = 5000;
				}
				case 10: { // (Коньяк) 
					GivePlayerSatiety(playerid, 1000);
					drunk_level = 5000;
				}
				case 11: { // (Ликёр) 
					GivePlayerSatiety(playerid, 1000);
					drunk_level = 5000;
				}
				case 12: { // (Ром) 
					GivePlayerSatiety(playerid, 1000);
					drunk_level = 5000;
				}
				case 13: { // (Абсент) 
					GivePlayerSatiety(playerid, 1000);
					drunk_level = 5000;
				}
			}
			ApplyAnimation(playerid, "BAR", "dnk_stndF_loop", 4.1, 0, 0, 0, 0, 0, 1);
			if(GetPlayerDrunkLevel(playerid) < 20000) {
				SetPlayerDrunkLevel(playerid, GetPlayerDrunkLevel(playerid)+drunk_level);
			}
			if(GetPlayerDrunkLevel(playerid) > 20000) SetPlayerDrunkLevel(playerid, 20000);
			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
		case BUSINESS_TYPE_AMMO: {
			if (BusinessInfo[id][bProducts] < ListMenuAmmo[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			BusinessInfo[id][bProducts] -= ListMenuAmmo[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за "collime"$%i!",
				ListMenuAmmo[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
			new weaponid, ammo;
			switch (itemid) { // выдача товара
				case 0: { // (Desert Eagle (21 пт.)) 
					weaponid = 24, ammo = 21;
				}
				case 1: { // (Silenced (9 mm) (51 пт.)) 
					weaponid = 23, ammo = 51;
				}
				case 2: { // (Country Rifle (15 пт.)) 
					weaponid = 33, ammo = 15;
				}
				case 3: { // (Shotgun (15 пт.)) 
					weaponid = 25, ammo = 15;
				}
				case 4: { // (SMG (90 пт.)) 
					weaponid = 29, ammo = 90;
				}
				case 5: { // (AK47 (90 пт.)) 
					weaponid = 30, ammo = 90;
				}
				case 6: { // (M4A1 (150 пт.)) 
					weaponid = 31, ammo = 150;
				}
				case 7: { // (Слезоточивый газ) 
					weaponid = 17, ammo = 1;
				}
				case 8: { // (Golf Club) 
					weaponid = 2, ammo = 1;
				}
				case 9: { // (Бейсбольная бита) 
					weaponid = 5, ammo = 1;
				}
				case 10: { // (Лопата) 
					weaponid = 6, ammo = 1;
				}
				case 11: { // (Бильярдный кий) 
					weaponid = 7, ammo = 1;
				}
				case 12: { // (Катана) 
					weaponid = 8, ammo = 1;
				}
				case 13: { // (Розовый дилдо) 
					weaponid = 10, ammo = 1;
				}
			}
			if (weaponid) GivePlayerWeapon(playerid, weaponid, ammo);
			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
		case BUSINESS_TYPE_CUSTOMS: {
			if (BusinessInfo[id][bProducts] < ListMenuCustoms[itemid][itemProds] * amount) {
				SendClientMessage(playerid, -1, "Недостаточно продуктов в бизнесе!");
				return false;
			}
			BusinessInfo[id][bProducts] -= ListMenuCustoms[itemid][itemProds] * amount;
			PayBusinessItem(playerid, id, itemid, amount, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (%i шт.) за $%i!",
				ListMenuCustoms[itemid][itemName], amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			switch (itemid) { // выдача товара
				case 0: { // (Покраска) 
					//
				}
				case 1: { // (Аэрография) 
					//
				}
				case 2: { // (Выхлоп) 
					//
				}
				case 3: { // (Усилитель бампера) 
					//
				}
				case 4: { // (Ковши) 
					//
				}
				case 5: { // (Бампера) 
					//
				}
				case 6: { // (Спойлер) 
					//
				}
				case 7: { // (Боковая юбка) 
					//
				}
				case 8: { // (Колеса) 
					//
				}
				case 9: { // (Гидравлика) 
					//
				}
				case 10: { // (Нитро) 
					//
				}
				case 11: { // Armour
					//
				}
			}
			ShowBusinessBuyMenu(playerid, id);
			return true;
		}
	}
	return false;
}

business_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
	switch (dialogid) {
		case D_BUSINESS_BUY_SIM: {
			if (!response) {
				DeletePVar(playerid, "SelectBizIDItems"); 
				DeletePVar(playerid, "SelectBizPriceItems");
				return true;
			}
			if (!isNumeric(inputtext) || strlen(inputtext) != 6 || inputtext[0] == '0') {
				ShowPlayerDialog(playerid, D_BUSINESS_BUY_SIM, DIALOG_STYLE_INPUT, ""colserver"24/7: "colwhi"SIM-Card",
					"\n"colwhi"Введите номер, который хотите купить:\n\
					\t"colgrey" - Длина номера телефона должна быть 6 цифр\n\
					\t"colgrey" - Пример: XXYYZZ","Купить","Закрыть"
				);
				return true;
			}
			new number_ = strval(inputtext),
				id = GetPVarInt(playerid, "SelectBizIDItems"), 
				price = GetPVarInt(playerid, "SelectBizPriceItems");
			if (GetPlayerSimNumberSearch(number_)) return SendClientMessage(playerid, COLOR_GREY, !"Данный номер занят, попробуйте выбрать другой!");
			pInfo[playerid][PlayerNumber] = number_;
			SavePlayerInteger(playerid, "pPnumber", pInfo[playerid][PlayerNumber]); 
			BusinessInfo[id][bProducts] -= ListMenuShop[1][itemProds];
			PayBusinessItem(playerid, id, 1, 1, price); 
	
			format(t_string, sizeof (t_string), "Вы успешно купили \"%s\" (т. %d) за "collime"$%i!",
				ListMenuShop[1][itemName], pInfo[playerid][PlayerNumber], price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
	
			ShowBusinessBuyMenu(playerid, id); 
			DeletePVar(playerid, "SelectBizIDItems"); 
			DeletePVar(playerid, "SelectBizPriceItems");
			return 1; 
		}
		case D_BUSINESS_BUY_LIST: {
			if (!response) {
				return true;
			}
			switch (listitem) {
				case 0: {
					if (pTemp[playerid][tDutyWork]) {
						SendClientMessage(playerid, COLOR_GREY, !"Сначала завершите рабочий день");
						return false;
					}  
					new skinid = 0;
					ChangeSkin[playerid] = skinid;
			
					if (pInfo[playerid][pSex] == 1) {
						format(t_string, sizeof (t_string), "~w~%d", ListMenuClothesMale[skinid][1]);
						SetPlayerSkinEx(playerid, ListMenuClothesMale[skinid][0]);
					} else {
						format(t_string, sizeof (t_string), "~w~%d", ListMenuClothesFemale[skinid][1]);
						SetPlayerSkinEx(playerid, ListMenuClothesFemale[skinid][0]);
					}
					PlayerTextDrawSetString(playerid, sk_info_text[playerid], t_string), t_string[0] = EOS;
					PlayerTextDrawShow(playerid, sk_info_text[playerid]);
					//BusinessInfo[id][bType] 
					for(new i = 0; i < sizeof (SkinShopMenu); i++) {
						TextDrawShowForPlayer(playerid, SkinShopMenu[i]);
					}
					pTemp[playerid][tSelectSkinShop] = 1;
					SelectTextDraw(playerid, 0xFF4040AA);
					new 
						id = pTemp[playerid][tBusinessID];
					if (BusinessInfo[id][bType] == BUSINESS_TYPE_VICTIM) {
						SetPlayerPosAC(playerid, 222.3489, -8.5845, 1002.2109, playerid, 5);
						SetPlayerFacingAngle(playerid, 266.7302);
						SetPlayerCameraPos(playerid, 225.3489, -8.5845, 1002.2109);
						SetPlayerCameraLookAt(playerid, 222.3489, -8.5845, 1002.2109);
					}
					else if (BusinessInfo[id][bType] == BUSINESS_TYPE_ZIP) {
						SetPlayerPosAC(playerid, 176.6238, -72.6065, 1001.8047, playerid, 18); 
						SetPlayerFacingAngle(playerid,85.0518); 
						SetPlayerCameraPos(playerid, 171.7000,-72.6568,1001.8047);
						SetPlayerCameraLookAt(playerid, 176.6238,-72.6065,1001.8047);
					} 
					else if (BusinessInfo[id][bType] == BUSINESS_TYPE_PROLAPS) {
						SetPlayerPosAC(playerid, 199.0974, -127.3947, 1003.5152, playerid, 3); 
						SetPlayerFacingAngle(playerid, 176.2323);
						SetPlayerCameraPos(playerid, 199.2118,-131.6095,1003.5152);
						SetPlayerCameraLookAt(playerid, 199.0974,-127.3947,1003.5152);  
					}
					TogglePlayerControllable(playerid, false);
				}
				case 1: ShowAccesoryBuyMenu(playerid);
			}
			return true;
		}
		case D_BUSINESS_ORDERS_MENU: {
			if (!response) {
				return true;
			}
			new V_IDX = GetPlayerVehicleID(playerid);
			if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER || VehicleInfo[ V_IDX - 1 ][vFraction] != PLAYER_JOB_DELIVERY) {
				SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться за рулем рабочего транспората!");
				return true;
			}
			switch (listitem) {
				case 0: {
					if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_DELIVERY && VehicleInfo[ V_IDX - 1 ] [vSubFraction] == DELIVERY_TYPE_1)) { 
						ShowBusinessPanel(playerid, D_BUSINESS_ORDERS_LIST_GAS);
						return 1;
					}
					else if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB && (VehicleInfo[ V_IDX - 1 ][vFraction] == PLAYER_JOB_DELIVERY && VehicleInfo[ V_IDX - 1 ] [vSubFraction] >= DELIVERY_TYPE_2)) { 
						ShowBusinessPanel(playerid, D_BUSINESS_ORDERS_LIST);
						return 1;
					}
				}
				case 1: {
					new points[1];
					points[0] = 100 - pInfo[playerid][JobDriverProdInfo][1];
					format(t_string, sizeof t_string, "{FFFFFF}\
						Уровень: %d\n\
						{2E8F1A}Опыт:\t[%s]%d%%\n\
						{FFFFFF}Макс.Груз: %d",
						pInfo[playerid][JobDriverProdInfo][0],
						ToDevelopSkills(pInfo[playerid][JobDriverProdInfo][1], points[0]),
						pInfo[playerid][JobDriverProdInfo][1],
						pInfo[playerid][JobDriverProdInfo][2]
					);
					ShowPlayerDialog(playerid, D_NULL, DIALOG_STYLE_MSGBOX, "Статистика", t_string, "Готово", "");
				}
			}
			t_string[0] = EOS;
			return true;
		}
		case D_BUSINESS_ORDERS_LIST, D_BUSINESS_ORDERS_LIST_GAS: {
			if (!response) {
				return true;
			}
			new 
				id = playerListItem[playerid][listitem], 
				amount = BusinessInfo[id][bOrderProducts],
				price = BusinessTypeInfo[BusinessInfo[id][bType]][bTypeOrderPrice]; // (развозчик покупает за 50%)
	//(BusinessInfo[i][bOrderProducts] * BusinessTypeInfo[BusinessInfo[i][bType]][bTypeOrderPrice] * 50 / 100)
			if (pTemp[playerid][pRentCar] != GetPlayerVehicleID(playerid)) {
				SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться за рулем своего рабочего транспорта!");
				return true;
			}
			if (
				!IsValidBusiness(id) || !strcmp(BusinessInfo[id][bOwner], "None", true) || 
				!BusinessInfo[id][bOrderProducts] || BusinessInfo[id][bOrderStatus]
			) {
				SendClientMessage(playerid, COLOR_GREY, !"Данный заказ уже неактивен!");
				return true;
			}
			//if (!strlen(inputtext) || strval(inputtext) < 0) return SendClientMessage(playerid, COLOR_GREY, !"Неверное количество!");
			/*if (strval(inputtext) < 0 || strval(inputtext) > pInfo[playerid][JobDriverProdInfo][2])
			{
				SendMes(playerid, COLOR_GREY, "Минимальное количество - 1,максимальное - %d", pInfo[playerid][JobDriverProdInfo][2]);
				return true;
			}*/
			if (kLibGetPlayerMoney(playerid) < (price * amount)) {
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств!");
				return true;
			}
			
			if (BusinessInfo[id][bType] == BUSINESS_TYPE_GAS) {
				if (!IsPlayerInRangeOfPoint(playerid, 5.0, -1027.4069, -593.4584, 32.0126)) {
					SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться на нефтезаводе!");
					return true;
				}
				SendMes(playerid, COLOR_BLUE, "Топливо: %i / 1000 л.", amount);
			} else {
				if (!IsPlayerInRangeOfPoint(playerid, 5.0, 2172.5198,-2237.1111,13.3451)) {//
					SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы должны находиться возле цеха по сортировки продуктов!");
					return true;
				}
				SendMes(playerid, COLOR_BLUE, "Продукты: %i / 5000 ед.", amount);
			}
			kLibGivePlayerMoney(playerid, -(price * amount), "развозчик купил продукты");


			new ownerid = GetPlayerID(BusinessInfo[id][bOwner]);
			if (ownerid != INVALID_PLAYER_ID) {
				SendMes(ownerid, COLOR_BLUE, "Внимание! Ваш заказ продуктов (%i ед.) для %s был принят %s [%i].", BusinessInfo[id][bOrderProducts], BusinessInfo[id][bName], pInfo[playerid][pName], playerid);
			}
			BusinessInfo[id][bOrderStatus] = 1; // (делаем заказ активным)
			pTemp[playerid][tBusinessOrderID] = id + 1;
			pTemp[playerid][tBusinessOrderProducts] = amount;


			SendMes(playerid, COLOR_BLUE, "Вы успешно загрузили продукты на $%i, отправляйтесь к бизнесу!", (price * amount * 50 / 100));
			SendClientMessage(playerid, COLOR_BLUE, "Внимание! Бизнес был отмечен красной меткой на радаре.");
			SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Чтобы разгрузить продукты, нажмите на \"H\".");

			SetPlayerCheckpoint(playerid, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2], 5.0);
			CP[playerid] = 777;

			return true;
		}
		case D_BUSINESS_ADD_BIZ_TYPE: {
			if (!response) {
				return true;
			}
			new type = playerListItem[playerid][listitem];
			playerListItem[playerid][0] = type;

			SendMes(playerid, COLOR_BLUE, "Вы выбрали тип бизнеса - %s.", BusinessTypeInfo[type][bTypeName]);
			ShowBusinessPanel(playerid, D_BUSINESS_ADD_BIZ_PRICE);
			return true;
		}
		case D_BUSINESS_ADD_BIZ_PRICE: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_ADD_BIZ_TYPE);
				return true;
			}
			new price = strval(inputtext), type = playerListItem[playerid][0];

			if (!(1 <= price <= 50000000)) {
				ShowBusinessPanel(playerid, D_BUSINESS_ADD_BIZ_PRICE);
				return true;
			}
			new Float:x, Float:y, Float:z, Float:angle;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, angle);
		
			new id = CreateBusiness(type, price, x, y, z, angle);
			if (id != -1) {
				PressedPickup[playerid] = BusinessInfo[id][bEnterPickup];
				SendClientMessage(playerid, COLOR_BLUE, "Бизнес успешно создан! (для редактирования /editbiz)");
			}
			else SendClientMessage(playerid, COLOR_BLUE, "Произошла ошибка создания бизнеса!");

			return true;
		}
		case D_BUSINESS_PANEL_SELECT_BIZINFO: {
			if (!response) {
				return true;
			}
			pTemp[playerid][tCurrentBusinessID] = playerListItem[playerid][listitem];
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_SHOW_BIZINFO);
			return true;
		}
		case D_BUSINESS_PANEL_SHOW_BIZINFO: {
			if (!response) {
				return true;
			}


			return true;
		}
		

		case D_BUSINESS_PANEL_SELECT_SELL: {
			if (!response) {
				return true;
			}
			pTemp[playerid][tCurrentBusinessID] = playerListItem[playerid][listitem];
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_CONFIRM_SELL);

			return true;
		}
		case D_BUSINESS_PANEL_CONFIRM_SELL: {
			if (!response) {
				return true;
			}
			new targetid = pTemp[playerid][tBusinessTempTargetID], price = strval(inputtext);
			if (!(1 <= price <= 50000000)) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_CONFIRM_SELL);
				return true;
			}
			if (!IsPlayerConnected(targetid) || !IsPlayerInRangeOfPlayer(8.0, playerid, targetid)) 
				return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом!");
			if (pTemp[playerid][tBusinessSellerTargetID] != INVALID_PLAYER_ID || pTemp[playerid][tBusinessBuyerTargetID] != INVALID_PLAYER_ID) 
				return SendClientMessage(playerid, COLOR_GREY, !"У вас уже есть активная сделка!");
			if (pTemp[targetid][tBusinessSellerTargetID] != INVALID_PLAYER_ID || pTemp[targetid][tBusinessBuyerTargetID] != INVALID_PLAYER_ID) 
				return SendClientMessage(playerid, COLOR_GREY, !"У игрока уже есть активная сделка!");
 
			pTemp[playerid][tBusinessSellID] = pTemp[playerid][tCurrentBusinessID];

			pTemp[targetid][tBusinessSellerTargetID] = playerid;
			pTemp[playerid][tBusinessBuyerTargetID] = targetid;
			pTemp[playerid][tBusinessSellPrice] = pTemp[targetid][tBusinessSellPrice] = price;
		
			SendMes(playerid, 0x6495EDFF, "Вы предложили игроку %s купить бизнес за "collime"$%i", pInfo[targetid][pName], price);
			SendMes(targetid, 0x6495EDFF, "%s предлагает покупку бизнеса. (( Нажмите: {33AA33}Y {6495ED}- для информации или "colred"N {6495ED}- отказаться))", pInfo[playerid][pName]);
		
			return true;
		}
		case D_BUSINESS_SELLBIZ_CONFIRM: {
			new targetid = pTemp[playerid][tBusinessSellerTargetID], price = pTemp[playerid][tBusinessSellPrice];
		 
			if (!response || !IsPlayerInRangeOfPlayer(8.0, playerid, targetid)) {
				pTemp[targetid][tBusinessBuyerTargetID] = INVALID_PLAYER_ID;
				pTemp[playerid][tBusinessSellerTargetID] = INVALID_PLAYER_ID;
		
				if (!response) {
					SendClientMessage(targetid, COLOR_GREY, !"Игрок отказался от покупки бизнеса");
					SendClientMessage(playerid, COLOR_GREY, !"Вы отказались от покупки бизнеса");
				} else {
					SendClientMessage(playerid, COLOR_GREY, !"Вы далеко друг от друга!");
					SendClientMessage(targetid, COLOR_GREY, !"Вы далеко друг от друга!");
				}
				return true;
			}
			if (GetPlayerBusinesses(playerid) >= GetPlayerAvailableBusiness(playerid)) {
				pTemp[targetid][tBusinessBuyerTargetID] = INVALID_PLAYER_ID;
				pTemp[playerid][tBusinessSellerTargetID] = INVALID_PLAYER_ID;

				SendClientMessage(playerid, COLOR_WHITE, !"У вас уже максимальное количество бизнесов.");
				return true;
			}
			if (kLibGetPlayerMoney(playerid) < price) {
				pTemp[targetid][tBusinessBuyerTargetID] = INVALID_PLAYER_ID;
				pTemp[playerid][tBusinessSellerTargetID] = INVALID_PLAYER_ID;
		
				SendClientMessage(targetid, COLOR_GREY, !"Игрок отказался от покупки бизнеса");
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств!");

				return true;
			}
			new id = pTemp[targetid][tBusinessSellID];
			if (strcmp(BusinessInfo[id][bOwner], pInfo[targetid][pName], true)) {
				pTemp[targetid][tBusinessBuyerTargetID] = INVALID_PLAYER_ID;
				pTemp[playerid][tBusinessSellerTargetID] = INVALID_PLAYER_ID;
				return true;
			}
			format(string_chat_, sizeof (string_chat_), "продажа бизнеса(%i)", BusinessInfo[id][bID]);
			kLibGivePlayerMoney(playerid, -price, string_chat_);
			kLibGivePlayerMoney(targetid, price, string_chat_);
			string_chat_[0] = EOS;

			SendClientMessage(playerid, COLOR_GREY, !"Вы успешно купили бизнес!");
			SendClientMessage(targetid, COLOR_GREY, !"Игрок купил у вас бизнес!");
			
			pTemp[targetid][tBusinessBuyerTargetID] = INVALID_PLAYER_ID;
			pTemp[playerid][tBusinessSellerTargetID] = INVALID_PLAYER_ID;

			for (new i = 0, isBreak = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if (!pInfo[playerid][pBusinessID][i] && !isBreak) {
					pInfo[playerid][pBusinessID][i] = id + 1;
					SavePlayerBusiness(playerid);
					isBreak = 1;
				}
				if (pInfo[targetid][pBusinessID][i] == (id + 1)) {
					pInfo[targetid][pBusinessID][i] = 0;
					SavePlayerBusiness(targetid);
				}
			}
			
			strmid(BusinessInfo[id][bOwner], pInfo[playerid][pName], 0, strlen(pInfo[playerid][pName]), MAX_PLAYER_NAME + 1);

			format(t_string, sizeof (t_string), "bOwner = '%s'",
				BusinessInfo[id][bOwner]
			);
			SaveBusiness(id, t_string);
			UpdateBusiness(id);

			return true;
		}
		case D_BUSINESS_PANEL_BANK: {
			if (!response) {
				return true;
			}
			switch (listitem) {
				case 0: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_DEPOSIT);
				case 1: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_WITHDRAW);
				case 2: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_LANDTAX);
			}
			return true;

		} 
		case D_BUSINESS_PANEL_BANK_DEPOSIT: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK);
				return true;
			}
			new amount = strval(inputtext);
			if (!(1 <= amount <= 10000000)) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_DEPOSIT);
				return true;
			}
			if (pInfo[playerid][pBank] < amount) {
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств на банковском счету!");
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_DEPOSIT);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID];
			
			BusinessInfo[id][bBank] += amount;
			pInfo[playerid][pBank] -= amount;
			SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
			format(string_chat_, sizeof (string_chat_), "касса бизнеса #%i", BusinessInfo[id][bID]);
			LogMoney(playerid, -amount, string_chat_), string_chat_[0] = EOS;
			/// kLibGivePlayerMoney(playerid, -amount);

			format(t_string, sizeof (t_string), "bBank = %i",
				BusinessInfo[id][bBank]
			);
			SaveBusiness(id, t_string);

			format(t_string, sizeof (t_string), "Вы успешно пополнили счет бизнес на "collime"$%i!", amount);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			return true;
		}
		case D_BUSINESS_PANEL_BANK_WITHDRAW: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK);
				return true;
			}
			new amount = strval(inputtext);
			if (!(1 <= amount <= 10000000)) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_WITHDRAW);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID];
			if (BusinessInfo[id][bBank] < amount) {
				SendClientMessage(playerid, COLOR_GREY, "У вас недостаточно средств на счете бизнеса!");
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_WITHDRAW);
				return true;
			}
			
			BusinessInfo[id][bBank] -= amount;
			pInfo[playerid][pBank] += amount;
			SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
			/// kLibGivePlayerMoney(playerid, -amount);
			format(string_chat_, sizeof (string_chat_), "снятие с бизнеса #%i", BusinessInfo[id][bID]);
			LogMoney(playerid, amount, string_chat_), string_chat_[0] = EOS;

			format(t_string, sizeof (t_string), "bBank = %i",
				BusinessInfo[id][bBank]
			);
			SaveBusiness(id, t_string);

			format(t_string, sizeof (t_string), "Вы успешно сняли со счета бизнеса "collime"$%i"colwhi"! (переведены на банковский счет)", amount);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			return true;
		} 
		case D_BUSINESS_PANEL_BANK_LANDTAX: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK);
				return true;
			} 
			new id = pTemp[playerid][tCurrentBusinessID];
			new
				type = BusinessInfo[id][bType],
				day_count = (BusinessInfo[id][bLandTax] / BusinessTypeInfo[type][bTypeTaxDay]);
			new amount = strval(inputtext);
			if (!(1 <= amount <= 30)) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_LANDTAX);
				SendClientMessage(playerid, COLOR_GREY, !"Оплатить бизнес можно от 1 дня до 30 дней");
				return true;
			}
			if (day_count + amount > 30) return SendClientMessage(playerid, COLOR_GREY, !"Максимальное кол-во оплаченных дней 30");
			new
				sum_ = (amount*BusinessTypeInfo[type][bTypeTaxDay]);
			if (pInfo[playerid][pBank] < sum_) {
				SendClientMessage(playerid, COLOR_GREY, !"У вас недостаточно средств на банковском счету!");
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK_LANDTAX);
				return true;
			}
			
			
			BusinessInfo[id][bLandTax] += sum_;
			pInfo[playerid][pBank] -= sum_;
			SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
			format(string_chat_, sizeof (string_chat_), "оплата бизнеса #%i", BusinessInfo[id][bID]);
			LogMoney(playerid, -sum_, string_chat_), string_chat_[0] = EOS; 
			format(t_string, sizeof (t_string), "bLandTax = %i",
				BusinessInfo[id][bLandTax]
			);
			SaveBusiness(id, t_string);

			format(t_string, sizeof (t_string), "Вы успешно оплатили бизнес на "collime"$%i!", sum_);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			return true;
		}
		case D_BUSINESS_ENTER: {
			if (!response) {
				return true;
			}
			new id = pTemp[playerid][tBusinessID];

			if (kLibGetPlayerMoney(playerid) < BusinessInfo[id][bEnterPrice]) {
				SendClientMessage(playerid, COLOR_GREY, !"У Вас недостаточно средств!");
				return true;
			}
			kLibGivePlayerMoney(playerid, -BusinessInfo[id][bEnterPrice], "цена за вход");
			BusinessInfo[id][bBank] += BusinessInfo[id][bEnterPrice];
			BusinessInfo[id][bBankToday] += BusinessInfo[id][bEnterPrice];   
			format(t_string, sizeof (t_string), "bBank = %i, bBankToday = %i",
				BusinessInfo[id][bBank], BusinessInfo[id][bBankToday]
			);
			SaveBusiness(id, t_string), t_string[0] = EOS;
			EnterPlayerBusiness(playerid, id);
			return true;
		}
		case D_BUSINESS_PANEL_SELECT: {
			if (!response) {
				return true;
			}
			pTemp[playerid][tCurrentBusinessID] = playerListItem[playerid][listitem];
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);

			return true;
		}
		case D_BUSINESS_PANEL_SELECT_BANK: {
			if (!response) {
				return true;
			}
			pTemp[playerid][tCurrentBusinessID] = playerListItem[playerid][listitem];
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_BANK);

			return true;
		}
		case D_BUSINESS_BUY_MENU: {
			if (!response) {
				return true;
			}
			new id = pTemp[playerid][tBusinessID], type = BusinessInfo[id][bType];
			switch (type) {
				case BUSINESS_TYPE_CARAVAN: {
					if (BuyBusinessItem(playerid, 0, .amount = 1)) 
						return true;
					return true;
				}
				case BUSINESS_TYPE_GAS: {
					new amount = strval(inputtext);
					if (!(1 <= amount <= 200)) {
						ShowBusinessBuyMenu(playerid, id);
						return true;
					}
					if (BuyBusinessItem(playerid, 0, amount)) 
						return true;
					return true;
				}
			}
			if (BuyBusinessItem(playerid, listitem, .amount = 1)) 
				return true;
			return false;
		}
		case D_BUSINESS_PANEL_INFO: {
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
			return true;
		}
		case D_BUSINESS_BUY_CONFIRM: {
			if (!response) {
				return true;
			}
			new 
				id = pTemp[playerid][tBusinessID],
				type = BusinessInfo[id][bType],
				price = GetVipPackPlayerValue(playerid, vSaleBizz, BusinessInfo[id][bBuyPrice]);
			if (pInfo[playerid][pBank] < price) {
				SendClientMessage(playerid, -1, !"Недостаточно денег в банке для покупки!");
				return true;
			}
			if (strcmp(BusinessInfo[id][bOwner], "None", true)) {
				SendClientMessage(playerid, -1, !"Бизнес уже имеет владельца!");
				return true;
			} 
			pInfo[playerid][pBank] -= price;
			SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
			format(string_chat_, sizeof (string_chat_), "покупка бизнеса #%i", BusinessInfo[id][bID]);
			LogMoney(playerid, -price, string_chat_), string_chat_[0] = EOS;
			
			strmid(BusinessInfo[id][bOwner], pInfo[playerid][pName], 0, strlen(pInfo[playerid][pName]), MAX_PLAYER_NAME + 1);

			BusinessInfo[id][bBank] = (BusinessInfo[id][bBuyPrice] / 20);
			BusinessInfo[id][bLandTax] = (BusinessTypeInfo[type][bTypeTaxDay]*2);
			BusinessInfo[id][bLocked] = 0;
			BusinessInfo[id][bLockedTime] = 0;
			BusinessInfo[id][bProducts] = 500;
			if (BusinessInfo[id][bType] == BUSINESS_TYPE_CUSTOMS) {
				pInfo[playerid][BusinessJob] = BusinessInfo[id][bID];
				pInfo[playerid][BusinessRank] = 3;
				pInfo[playerid][BusinessAllCash] = 0;
				pInfo[playerid][BusinessCash] = 0;
			}
			for (new i = 0; i < MAX_BUSINESS_ITEMS; i++) BusinessInfo[id][bItemsSold][i] = 0;
	
			format(t_string, sizeof (t_string), "Вы успешно приобрели бизнес "C_PODS"(%s) "colwhi"за "collime"$%i!", BusinessInfo[id][bName], price);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if (pInfo[playerid][pBusinessID][i]) continue;
				pInfo[playerid][pBusinessID][i] = id + 1;
				SavePlayerBusiness(playerid);
				break;
			}
			UpdateBusiness(id);
			
			format(t_string, sizeof (t_string), "bOwner = '%s', bLocked = %i, bLockedTime = %i, bProducts = %i, bBank = %i, bLandTax = %i",
				BusinessInfo[id][bOwner], BusinessInfo[id][bLocked], BusinessInfo[id][bLockedTime], BusinessInfo[id][bProducts], BusinessInfo[id][bBank], BusinessInfo[id][bLandTax]
			);
			SaveBusiness(id, t_string);

			return true;
		}
		case D_BUSINESS_PANEL_SELL: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID], price = floatround(BusinessInfo[id][bBuyPrice] / BUSINESS_SELL_DIVISION_RATIO) + (BusinessInfo[id][bBank] - BusinessInfo[id][bBank]/10);

			pInfo[playerid][pBank] += price;
			SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
			format(string_chat_, sizeof (string_chat_), "продажа бизнеса #%i", BusinessInfo[id][bID]);
			LogMoney(playerid, price, string_chat_), string_chat_[0] = EOS;

			ClearBusiness(id, .sell = 1);
			printf("[businesses] Бизнес #%i был продан игроком (%s)!", BusinessInfo[id][bID], pInfo[playerid][pName]);
			
			for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if ((pInfo[playerid][pBusinessID][i] - 1) != id) continue;
				pInfo[playerid][pBusinessID][i] = 0;
				break;
			}
			SavePlayerBusiness(playerid);

			format(t_string, sizeof (t_string), "Вы успешно продали бизнес государству за "collime"$%i!", price);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
			return true;
		}
		case D_BUSINESS_PANEL_MAIN: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_SELECT);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID], type = BusinessInfo[id][bType];
			switch (listitem + 1) {
				case 1: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_INFO);
				case 2: {
					BusinessInfo[id][bLocked] = !BusinessInfo[id][bLocked];
					if (!BusinessInfo[id][bLocked]) 
						SendClientMessage(playerid, COLOR_WHITE, !"Бизнес открыт.");
					else SendClientMessage(playerid, COLOR_WHITE, !"Бизнес закрыт.");
					ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				}
				case 3: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MESSAGE);
				case 4: {
					switch (type) {
						case 
							BUSINESS_TYPE_VICTIM, BUSINESS_TYPE_ZIP, BUSINESS_TYPE_SUB_URBAN, 
							BUSINESS_TYPE_BINCO, BUSINESS_TYPE_PROLAPS, BUSINESS_TYPE_DIDIER_SACH: {
							SendClientMessage(playerid, COLOR_GREY, !"Недоступно для вашего бизнеса!");
							ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
							return true;
						}
						case BUSINESS_TYPE_GAS, BUSINESS_TYPE_CARAVAN: {
							playerListItem[playerid][0] = 0;
							ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PRICE_SET);
						}
						default: {
							ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PRICE_LIST);
						}
					}

				}
				case 5: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_MENU);
				case 6: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_HISTORY_TRADE);
				case 7: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_SELL);
				case 8: {
					if (!BusinessTypeInfo[type][bTypeEnterPrice]) return true;
					ShowBusinessPanel(playerid, D_BUSINESS_PANEL_ENTER_PRICE);
				}
				
			}
			return true;
		}
		case D_BUSINESS_PANEL_PRICE_LIST: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				return true;
			}
			playerListItem[playerid][0] = listitem;
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PRICE_SET);
			return true;
		}
		case D_BUSINESS_PANEL_PRICE_SET: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				return true;
			}
			listitem = playerListItem[playerid][0];
			new id = pTemp[playerid][tCurrentBusinessID], amount = strval(inputtext), type = BusinessInfo[id][bType], min_price = 1;
			switch (type) {
				case BUSINESS_TYPE_CARAVAN: min_price = 7000000;
			}
			if (!(min_price <= amount <= BusinessTypeInfo[type][bTypeMaxProdPrice])) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PRICE_SET);
				return true;
			}
			BusinessInfo[id][bItemsPrice][listitem] = amount;

			format(t_string, sizeof (t_string), "bItemsPrice = '%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i|%i'",
				BusinessInfo[id][bItemsPrice][0], BusinessInfo[id][bItemsPrice][1], BusinessInfo[id][bItemsPrice][2], BusinessInfo[id][bItemsPrice][3], 
				BusinessInfo[id][bItemsPrice][4], BusinessInfo[id][bItemsPrice][5], BusinessInfo[id][bItemsPrice][6], BusinessInfo[id][bItemsPrice][7], 
				BusinessInfo[id][bItemsPrice][8], BusinessInfo[id][bItemsPrice][9], BusinessInfo[id][bItemsPrice][10], BusinessInfo[id][bItemsPrice][11], 
				BusinessInfo[id][bItemsPrice][12], BusinessInfo[id][bItemsPrice][13], BusinessInfo[id][bItemsPrice][14], BusinessInfo[id][bItemsPrice][15], 
				BusinessInfo[id][bItemsPrice][16], BusinessInfo[id][bItemsPrice][17], BusinessInfo[id][bItemsPrice][18], BusinessInfo[id][bItemsPrice][19]
			);
			SaveBusiness(id, t_string);
			UpdateBusiness(id);

			switch (type) {
				case BUSINESS_TYPE_GAS, BUSINESS_TYPE_CARAVAN: {
					ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				}
				default: {
					ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PRICE_LIST);
				}
			}
			
			SendClientMessage(playerid, -1, "Вы успешно изменили цену товара!");
			return true;
		}
		case D_BUSINESS_PANEL_MESSAGE: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				return true;
			}
			if (!(4 <= strlen(inputtext) < 64)) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MESSAGE);
				return true;
			}
			// check: Invalid Symbols
			new id = pTemp[playerid][tCurrentBusinessID];
			format(BusinessInfo[id][bMessage], 64, inputtext);

			format(t_string, sizeof (t_string), "bMessage = '%s'",
				BusinessInfo[id][bMessage]
			);
			SaveBusiness(id, t_string);
	
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
			SendClientMessage(playerid, -1, "Вы успешно изменили сообщение при входе!");
			
			format(t_string, sizeof (t_string), "Ваше сообщение: %s", inputtext);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
			return true;
		}
		case D_BUSINESS_PANEL_PROD_MENU: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID], type = BusinessInfo[id][bType];
			switch (listitem) {
				case 0: {
					switch (type) {
						case 
							BUSINESS_TYPE_VICTIM..BUSINESS_TYPE_DIDIER_SACH, BUSINESS_TYPE_GAS, 
							BUSINESS_TYPE_CUSTOMS, BUSINESS_TYPE_CARAVAN: {

							ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
							return true;
						}
					}
					ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_INFO);
				}
				case 1: ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_ORDER);
				case 2: {
					if (!BusinessInfo[id][bOrderProducts]) {
						SendClientMessage(playerid, COLOR_GREY, !"У вашего бизнеса нет активного заказа продукции!");
						return true;
					}
					if (BusinessInfo[id][bOrderStatus] != 0) {
						SendClientMessage(playerid, COLOR_GREY, !"Данный заказ уже выполняется!");
						return true;
					}
					new bank = BusinessTypeInfo[type][bTypeOrderPrice] * BusinessInfo[id][bOrderProducts];
					SendMes(playerid, COLOR_BLUE, "Вы отменили активный заказ от %s на %i ед. продукции и вернули $%i на счет.", BusinessInfo[id][bOrderDate], BusinessInfo[id][bOrderProducts], bank);
					BusinessInfo[id][bBank] += bank; 
					BusinessInfo[id][bUnBankToday] -= bank;
					BusinessInfo[id][bOrderProducts] = 0;
					BusinessInfo[id][bOrderStatus] = 0;
					format(BusinessInfo[id][bOrderDate], 20, "-");

					format(t_string, sizeof (t_string), "bBank = %i, bUnBankToday = %i, bOrderProducts = %i, bOrderDate = '%s'",
						BusinessInfo[id][bBank], BusinessInfo[id][bUnBankToday], BusinessInfo[id][bOrderProducts], BusinessInfo[id][bOrderDate]
					);
					SaveBusiness(id, t_string), t_string[0] = EOS; 
				}
			}
			return true;
		}
		case D_BUSINESS_PANEL_PROD_INFO: {
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_MENU);
			return true;
		}
		case D_BUSINESS_PANEL_PROD_ORDER: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_MENU);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID], type = BusinessInfo[id][bType], amount = strval(inputtext);
			if (!(BUSINESS_MIN_PRODUCTS <= amount <= BUSINESS_MAX_ORDER_PROD)) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_ORDER);
				return true;
			}
			if (BusinessInfo[id][bOrderProducts]) {
				SendMes(playerid, COLOR_GREY, "У вас бизнеса имеется активный заказ продуктов (%i ед.)!", BusinessInfo[id][bOrderProducts]);
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_ORDER);
				return true;
			}
			new price = BusinessTypeInfo[type][bTypeOrderPrice] * amount;
			if (BusinessInfo[id][bBank] < price) {
				SendClientMessage(playerid, -1, !"На счете бизнеса недостаточно средств!");
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_ORDER);
				return true;
			}
			BusinessInfo[id][bBank] -= price; 
			BusinessInfo[id][bUnBankToday] += price;
			getdate(year, month, day);
			gettime(hour, minute, second);

			format(BusinessInfo[id][bOrderDate], 20, "%02d:%02d:%02d %02d/%02d/%04d",
				hour, minute, second, day, month, year
			);
			BusinessInfo[id][bOrderProducts] = amount;

			BusinessInfo[id][bOrderStatus] = 0;

			format(t_string, sizeof (t_string), "bOrderProducts = %i, bOrderDate = '%s', bBank = %i, bUnBankToday = %i",
				BusinessInfo[id][bOrderProducts], BusinessInfo[id][bOrderDate], BusinessInfo[id][bBank], BusinessInfo[id][bUnBankToday]
			);
			SaveBusiness(id, t_string); 
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_PROD_MENU);
			format(t_string, sizeof (t_string), 
				"Вы успешно заказали продукты (%d ед.) за $%d!", amount, price
			);
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;
			return true;
		}
		case D_BUSINESS_PANEL_ENTER_PRICE: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID], amount = strval(inputtext);
			if (!(0 <= amount <= 2000)) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_ENTER_PRICE);
				return true;
			}
			BusinessInfo[id][bEnterPrice] = amount;
	
			format(t_string, sizeof (t_string), "bEnterPrice = %i",
				BusinessInfo[id][bEnterPrice]
			);
			SaveBusiness(id, t_string);

			SendClientMessage(playerid, -1, !"Вы изменили цену за вход!");
			ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);

			UpdateBusiness(id);
		
			return true;
		}
		case D_BUSINESS_PANEL_HISTORY_TRADE: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_PANEL_MAIN);
				return true;
			} 
			return 1;
		}
		case D_BUSINESS_EDIT_MENU: {
			if (!response) {
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID];
			switch (listitem) {
				case 0: ShowBusinessPanel(playerid, D_BUSINESS_EDIT_NAME);
				case 1: ShowBusinessPanel(playerid, D_BUSINESS_EDIT_PRICE);
				case 2: ShowBusinessPanel(playerid, D_BUSINESS_EDIT_INTERIOR_ID);
				case 3: ShowBusinessPanel(playerid, D_BUSINESS_EDIT_TYPE);
				case 4: { // (Переместить точку входа в бизнес (где стоите))
					if (IsPlayerInAnyVehicle(playerid)) {
						new vehicleid = GetPlayerVehicleID(playerid);
						GetVehiclePos(vehicleid, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2]);
						GetVehicleZAngle(vehicleid, BusinessInfo[id][bPos][3]);
					} else {
						GetPlayerPos(playerid, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2]);
						GetPlayerFacingAngle(playerid, BusinessInfo[id][bPos][3]);
					}
					format(t_string, sizeof (t_string), "\
						bEntranceX = '%.2f', bEntranceY = '%.2f', bEntranceZ = '%.2f', bEntranceA = '%.2f'",
						BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2], BusinessInfo[id][bPos][3]
					);
					SaveBusiness(id, t_string);
					
					DestroyBusinessElements(id);
					UpdateBusiness(id, .create = true);
					PressedPickup[playerid] = BusinessInfo[id][bEnterPickup];

					SendClientMessage(playerid, COLOR_BLUE, !"Вы успешно переместили точку входа бизнеса!");
				}
				case 5: { // (Переместить доп.точку бизнеса (для СТО, дом на колесах и т.п.))
					switch (BusinessInfo[id][bType]) {
						case BUSINESS_TYPE_GAS, BUSINESS_TYPE_CUSTOMS, BUSINESS_TYPE_CARAVAN: { }
						/*case BUSINESS_TYPE_KIOSK: {

						}*/
						default: {
							ShowBusinessPanel(playerid, D_BUSINESS_EDIT_MENU);
							return SendClientMessage(playerid, COLOR_GREY, !"Недоступно для данного типа бизнеса!");
						}
					}
					if (IsPlayerInAnyVehicle(playerid)) {
						new vehicleid = GetPlayerVehicleID(playerid);
						GetVehiclePos(vehicleid, 
							BusinessInfo[id][bActionPos][0], BusinessInfo[id][bActionPos][1], BusinessInfo[id][bActionPos][2]
						);
						GetVehicleZAngle(vehicleid, BusinessInfo[id][bActionPos][3]);
					} else {
						GetPlayerPos(playerid, 
							BusinessInfo[id][bActionPos][0], BusinessInfo[id][bActionPos][1], BusinessInfo[id][bActionPos][2]
						);
						GetPlayerFacingAngle(playerid, BusinessInfo[id][bActionPos][3]);
					}

					format(t_string, sizeof (t_string), "\
						bActionX = '%.2f', bActionY = '%.2f', bActionZ = '%.2f', bActionA = '%.2f'",
						BusinessInfo[id][bActionPos][0], BusinessInfo[id][bActionPos][1], 
						BusinessInfo[id][bActionPos][2], BusinessInfo[id][bActionPos][3]
					);
					SaveBusiness(id, t_string);
				
					DestroyBusinessElements(id);
					UpdateBusiness(id, .create = true);

					SendClientMessage(playerid, COLOR_BLUE, !"Вы успешно переместили дополнительную точку бизнеса!");
				}
				case 6: { // (Продать государству)
					ClearBusiness(id);
					printf("[businesses] Бизнес #%i был продан администратором (%s)!", BusinessInfo[id][bID], pInfo[playerid][pName]);
					SendClientMessage(playerid, COLOR_BLUE, !"Вы успешно продали бизнес государству!");
				}
				case 7: ShowBusinessPanel(playerid, D_BUSINESS_EDIT_DELETE);
			}
			return true;
		}
		case D_BUSINESS_EDIT_NAME: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_EDIT_MENU);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID];
			if (!(3 <= strlen(inputtext) < 32)) {
				ShowBusinessPanel(playerid, D_BUSINESS_EDIT_NAME);
				return true;
			}
			format(BusinessInfo[id][bName], 32, inputtext);
			UpdateBusiness(id);

			format(t_string, sizeof (t_string), "bName = '%s'",
				BusinessInfo[id][bName]
			);
			SaveBusiness(id, t_string);

			SendClientMessage(playerid, COLOR_BLUE, !"Вы успешно изменили название бизнеса!");
			return true;
		}
		case D_BUSINESS_EDIT_PRICE: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_EDIT_MENU);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID], price = strval(inputtext);
			if (!(1 <= price <= 50000000)) {
				ShowBusinessPanel(playerid, D_BUSINESS_EDIT_PRICE);
				return true;
			}
			BusinessInfo[id][bBuyPrice] = price;
			UpdateBusiness(id);
		
			format(t_string, sizeof (t_string), "bBuyPrice = %i",
				BusinessInfo[id][bBuyPrice]
			);
			SaveBusiness(id, t_string);

			SendClientMessage(playerid, COLOR_BLUE, !"Вы успешно изменили стоимость бизнеса!");

			return true;
		}
		case D_BUSINESS_EDIT_INTERIOR_ID: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_EDIT_MENU);
				return true;
			}
			new 
				id = pTemp[playerid][tCurrentBusinessID], 
				interiorid = playerListItem[playerid][listitem];

			BusinessInfo[id][bInteriorID] = interiorid;

			DestroyBusinessElements(id);
			UpdateBusiness(id, .create = true);
			PressedPickup[playerid] = BusinessInfo[id][bEnterPickup];

			format(t_string, sizeof (t_string), "bIntID = %i",
				BusinessInfo[id][bInteriorID]
			);
			SaveBusiness(id, t_string);

			SendClientMessage(playerid, COLOR_BLUE, !"Вы успешно изменили интерьер бизнеса!");

			return true;
		}
		case D_BUSINESS_EDIT_TYPE: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_EDIT_MENU);
				return true;
			}
			new 
				id = pTemp[playerid][tCurrentBusinessID], 
				type = playerListItem[playerid][listitem];

			BusinessInfo[id][bType] = type;
			new interior_id = BusinessInfo[id][bInteriorID]; // GetBusinessInteriorID(i);
			if (interior_id >= sizeof (BusinessInteriorInfo) || BusinessInteriorInfo[interior_id][bIntType] != BusinessInfo[id][bType]) {
				for (new interiorid = 0; interiorid < sizeof (BusinessInteriorInfo); interiorid++) {
					if (BusinessInteriorInfo[interiorid][bIntType] != BusinessInfo[id][bType]) continue;
					BusinessInfo[id][bInteriorID] = interiorid;
					break;
				}
			}
			DestroyBusinessElements(id);
			UpdateBusiness(id, .create = true);
			PressedPickup[playerid] = BusinessInfo[id][bEnterPickup];

			format(t_string, sizeof (t_string), "bType = %i, bIntID = %i",
				BusinessInfo[id][bType], BusinessInfo[id][bInteriorID]
			);
			SaveBusiness(id, t_string);
		
			SendClientMessage(playerid, COLOR_BLUE, !"Вы успешно изменили тип бизнеса!");

			return true;
		}
		case D_BUSINESS_EDIT_DELETE: {
			if (!response) {
				ShowBusinessPanel(playerid, D_BUSINESS_EDIT_MENU);
				return true;
			}
			new id = pTemp[playerid][tCurrentBusinessID];

			ClearBusiness(id);
			printf("[businesses] Бизнес #%i был удален администратором (%s)!", BusinessInfo[id][bID], pInfo[playerid][pName]);
			DestroyBusinessElements(id);
			
			mysql_format(dbHandle, t_string, sizeof (t_string), "\
				DELETE FROM "TABLE_BUSINESS" WHERE id = %i", BusinessInfo[id][bID]
			);
			mysql_tquery(dbHandle, t_string, "", "");

			BusinessInfo[id][bID] = 0;

			SendClientMessage(playerid, COLOR_BLUE, !"Вы успешно удалили бизнес!");
			return true;
		}
	}
	return false;
}
stock SavePlayerBusiness(playerid) {
	new business_id[MAX_PLAYER_BUSINESS];
	for (new i = 0; i < sizeof (business_id); i++) {
		if (!pInfo[playerid][pBusinessID][i]) continue;
		business_id[i] = BusinessInfo[pInfo[playerid][pBusinessID][i] - 1][bID];
	}
	format(t_string, sizeof (t_string), "UPDATE `s_users` SET pBusinessID = '%d,%d,%d' WHERE `pID` = %d LIMIT 1", 
		business_id[0], business_id[1], business_id[2],
		pInfo[playerid][pID]
	);
	// printf("[SavePlayerBusiness]: \"%s\"", t_string);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
}
stock IsValidBusiness(id) {
	if (!(0 <= id < sizeof (BusinessInfo)) || BusinessInfo[id][bID] == 0)
		return false;
	return true;
}
stock GetPlayerBusinesses(playerid) {
	new amount = 0;
	for (new i = 0, id; i < MAX_PLAYER_BUSINESS; i++) {
		if (!pInfo[playerid][pBusinessID][i]) continue;
		id = pInfo[playerid][pBusinessID][i] - 1;
		if (!strcmp(BusinessInfo[id][bOwner], pInfo[playerid][pName], true)) {
			amount++;
		} else {
			pInfo[playerid][pBusinessID][i] = 0;
		}
		
	}
	return amount;
}


stock GetPlayerAvailableBusiness(playerid) {
	new amount = GetVipPackPlayerValue(playerid, vCountBizz);
	
	if (amount > MAX_PLAYER_BUSINESS) 
		amount = MAX_PLAYER_BUSINESS;
	else if (amount < 1) amount = 1;

	return amount;
}
CMD:bpanel(playerid) {  
	if (!GetPlayerBusinesses(playerid))  return SendClientMessage(playerid, COLOR_GRAD2, !"У Вас нет ниодного бизнеса!"); 
	ShowBusinessPanel(playerid, D_BUSINESS_PANEL_SELECT);
	return true;
}
CMD:buybiz(playerid) {
	if (GetPlayerBusinesses(playerid) >= GetPlayerAvailableBusiness(playerid)) {
		SendClientMessage(playerid, COLOR_WHITE, !"У вас уже максимальное количество бизнесов.");
		return true;
	}
	for (new id = 0; id < sizeof (BusinessInfo); id++) {
		if (!IsValidBusiness(id)) continue;

		if (!IsPlayerInRangeOfPoint(playerid, 5.0, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2])) 
			continue; 
		if (strcmp(BusinessInfo[id][bOwner], "None", true)) {
			SendClientMessage(playerid, -1, !"Бизнес уже имеет владельца!");
			break;
		} 
		if (pInfo[playerid][pBank] < BusinessInfo[id][bBuyPrice]) {
			SendClientMessage(playerid, -1, !"Недостаточно денег в банке для покупки!");
			break;
		}
		new 
			type = BusinessInfo[id][bType], 
			price = GetVipPackPlayerValue(playerid, vSaleBizz, BusinessInfo[id][bBuyPrice]);
	
		pTemp[playerid][tBusinessID] = id;
	
		format(t_string, sizeof (t_string), ""colwhi"\
			Вы действительно хотите приобрести бизнес "colserver"\"%s\""colwhi"?\n\n\
			Стоимость: "collime"$%i\n\
			"colwhi"Тип бизнеса: "colserver"%s\n\
			"colwhi"Примечание: Оплата производится через банковский счет.",
			BusinessInfo[id][bName],
			price,
			BusinessTypeInfo[type][bTypeName]
		);
		ShowPlayerDialog(playerid, D_BUSINESS_BUY_CONFIRM, DIALOG_STYLE_MSGBOX, ""colserver"Покупка бизнеса", t_string, "Купить", "Отмена");

		t_string[0] = EOS;
		break;	
	}
	return 1;
}
stock SaveBusiness(id, const query_string[]) {
	mysql_format(dbHandle, t_string, sizeof (t_string), 
		"UPDATE "TABLE_BUSINESS" SET %s WHERE id = %i LIMIT 1", query_string, BusinessInfo[id][bID]
	);
	// printf("[SaveBusiness]: \"%s\"", t_string);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
}
ClearBusiness(id, sell = 0, type_sell = 0) {
	if (!sell) {
		new playerid = GetPlayerID(BusinessInfo[id][bOwner]);
		if (playerid != INVALID_PLAYER_ID) {
			if(!type_sell) {
				format(t_string, sizeof (t_string), "Ваш бизнес \"%s\" был продан государству за неуплату налогов!",
					BusinessInfo[id][bName]
				);
			} else {
				format(t_string, sizeof (t_string), "Ваш бизнес \"%s\" был продан государству так как срок Вашего VIP подожел к концу!",
					BusinessInfo[id][bName]
				);
			}
			SendClientMessage(playerid, -1, t_string), t_string[0] = EOS;

			for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if ((pInfo[playerid][pBusinessID][i] - 1) != id) continue;
				pInfo[playerid][pBusinessID][i] = 0;
				break;
			}
			pInfo[playerid][pBank] += floatround(BusinessInfo[id][bBuyPrice] / BUSINESS_SELL_DIVISION_RATIO) + (BusinessInfo[id][bBank] - BusinessInfo[id][bBank]/10);
			SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);

			SavePlayerBusiness(playerid);
		} else {
			format(t_string, sizeof (t_string), "SELECT pBusinessID FROM s_users WHERE Name = '%s' LIMIT 1", // AND (%i IN pBusinessID)
				BusinessInfo[id][bOwner]
			);
			new rows, Cache:tempQuery = mysql_query(dbHandle, t_string);
			cache_get_row_count(rows);
			t_string[0] = EOS;

			if (rows) {
				new tempBusinessID[MAX_PLAYER_BUSINESS*4 + 2];
				cache_get_value_name(0, "pBusinessID", tempBusinessID, sizeof (tempBusinessID));
				sscanf(tempBusinessID, "p<,>a<i>["#MAX_PLAYER_BUSINESS"]");
				for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
					if (tempBusinessID[i] != BusinessInfo[id][bID]) continue;
					tempBusinessID[i] = 0;
					break;
				}
				format(t_string, sizeof (t_string), 
					"UPDATE s_users SET pBank = pBank+%i, pBusinessID = '%d,%d,%d' WHERE Name = '%s' LIMIT 1", 
					(floatround(BusinessInfo[id][bBuyPrice] / BUSINESS_SELL_DIVISION_RATIO) + (BusinessInfo[id][bBank] - BusinessInfo[id][bBank]/10)),
					tempBusinessID[0], tempBusinessID[1], tempBusinessID[2], 
					BusinessInfo[id][bName]
				);
				mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
				
			}
			if (cache_is_valid(tempQuery)) cache_delete(tempQuery);
		}
	} 
	strmid(BusinessInfo[id][bOwner], "None", 0, strlen("None"), MAX_PLAYER_NAME + 1);


	BusinessInfo[id][bBank] = 0;
	BusinessInfo[id][bLandTax] = 0;
	BusinessInfo[id][bLocked] = 0;
	BusinessInfo[id][bLockedTime] = 0;
	BusinessInfo[id][bOrderProducts] = 0;
	BusinessInfo[id][bProducts] = 10_000;
	BusinessInfo[id][bMessage][0] = EOS;

	UpdateBusiness(id);

	format(t_string, sizeof (t_string), "bOwner = '%s', bMessage = '-', bLocked = %i, bLockedTime = 0, bProducts = %i, bBank = %i, bOrderProducts = 0, bLandTax = 0",
		BusinessInfo[id][bOwner], BusinessInfo[id][bLocked], 
		BusinessInfo[id][bProducts], BusinessInfo[id][bBank]
	);
	SaveBusiness(id, t_string);
}
stock EnterPlayerBusiness(playerid, id) {
	PressedPickup[playerid] = BusinessInfo[id][bExitPickup];

	new freeze = 2;
	switch (BusinessInfo[id][bType]) {
		case BUSINESS_TYPE_CUSTOMS: return false;
		case BUSINESS_TYPE_CARAVAN: freeze = 3;
		case BUSINESS_TYPE_VICTIM, BUSINESS_TYPE_ZIP, BUSINESS_TYPE_SUB_URBAN, 
		BUSINESS_TYPE_BINCO, BUSINESS_TYPE_PROLAPS, BUSINESS_TYPE_DIDIER_SACH: {
			new
				current_time = gettime();
			if (current_time > BusinessInfo[id][bNewRobStart]) { 
				BusinessInfo[id][bNewRobStart] = 0;
			}
		}
		case BUSINESS_TYPE_AMMO: {
			new
				current_time = gettime();
			if (current_time > BusinessInfo[id][bNewRobStart]) { 
				BusinessInfo[id][bNewRobStart] = 0;
			}
		}
		case BUSINESS_TYPE_24_7: {
			new
				current_time = gettime();
			if (current_time > BusinessInfo[id][bNewRobStart]) { 
				BusinessInfo[id][bNewRobStart] = 0;
			}
		}
	}
	new interior_id = BusinessInfo[id][bInteriorID]; // GetBusinessInteriorID(id);

	SetPlayerPosAC(playerid, 
		BusinessInteriorInfo[interior_id][bIntPos][0], BusinessInteriorInfo[interior_id][bIntPos][1], BusinessInteriorInfo[interior_id][bIntPos][2],
		.worldid = BusinessInfo[id][bWorld], .interiorid = BusinessInteriorInfo[interior_id][bIntInterior]
	);
	SetPlayerFacingAngle(playerid, BusinessInteriorInfo[interior_id][bIntPos][3]);

	setFreezePlayerForTime(playerid, freeze);
	SetCameraBehindPlayer(playerid);

	if (strlen(BusinessInfo[id][bMessage]) >= 4) {
		format(t_string, sizeof (t_string), "[Бизнес]: %s", BusinessInfo[id][bMessage]);
		SendClientMessage(playerid, COLOR_BLUE, t_string), t_string[0] = EOS;
	}
	PressedPickup[playerid] = BusinessInfo[id][bExitPickup];
	return true;
}
business_OnPlayerPickUpPickup(playerid, pickupid) {
	// printf("business_OnPlayerPickUpPickup %d pick = %d", playerid, pickupid);
	new bool:isReturn = false;
	for (new id = 0, type; id < sizeof (BusinessInfo); id++) {
		if (!IsValidBusiness(id)) 
			continue;
		// printf("bizz %i | type = %i | pick = %d", BusinessInfo[id][bID], BusinessInfo[id][bType], BusinessInfo[id][bEnterPickup]);

		if (pickupid == BusinessInfo[id][bEnterPickup]) {
			type = BusinessInfo[id][bType];
			pTemp[playerid][tBusinessID] = id;

			if (BusinessTypeInfo[type][bTypeEnterPrice] && BusinessInfo[id][bEnterPrice]) {
				format(t_string, sizeof (t_string), ""colwhi"Цена входа "collime"$%d\n \n\
					"colwhi"Вы желаете войти?", BusinessInfo[id][bEnterPrice]
				);
				ShowPlayerDialog(playerid, D_BUSINESS_ENTER, DIALOG_STYLE_MSGBOX, ""colserver"Вход в бизнес", t_string, "Да", "Отмена"), t_string[0] = EOS;
			} else {
				EnterPlayerBusiness(playerid, id);
			}
			isReturn = true;
			break;
		} 
		else if (pickupid == BusinessInfo[id][bExitPickup]) {
			PressedPickup[playerid] = BusinessInfo[id][bEnterPickup];
	
			SetPlayerPosAC(playerid, 
				BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2],
				.worldid = 0, .interiorid = 0
			);
			SetPlayerFacingAngle(playerid, BusinessInfo[id][bPos][3]);

			SetCameraBehindPlayer(playerid);
			isReturn = true;
			break;
		} 
		else if (pickupid == BusinessInfo[id][bBuyPickup]) {
			pTemp[playerid][tBusinessID] = id;
			ShowBusinessBuyMenu(playerid, id);
			isReturn = true;
			break;
		} 
	}
	if (isReturn) return true;
	return false;
}

CMD:mcontract(playerid, params[])
{
	new 
		R_CAR_JOB = pTemp[playerid][pRentCar];
	if (pInfo[playerid][pJob] != PLAYER_JOB_MECHANIC) return SendClientMessage(playerid, COLOR_GREY, !"Вы не работаете механиком");
    else if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть в рабочей машине");	
    else if (VehicleInfo[ R_CAR_JOB - 1 ][vType] != VEHICLE_TYPE_JOB 
			|| VehicleInfo[ R_CAR_JOB - 1 ][vFraction] != PLAYER_JOB_MECHANIC) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в рабочей машине");
	if (pTemp[playerid][gContract] != INVALID_PLAYER_ID)
	{
		if (pTemp[playerid][Mechanic3DText] != Text3D:-1) {
			DestroyDynamic3DTextLabel(pTemp[playerid][Mechanic3DText]); 
			pTemp[playerid][Mechanic3DText] = Text3D:-1;
		}
		DeletePVar(playerid, "CostBenzMeh");
		pTemp[playerid][gContract] = INVALID_PLAYER_ID; 
		SendClientMessage(playerid, COLOR_WHITE, !"Контракт с заправкой рассторгнут!");
		return 1;
	}
	if (pTemp[playerid][tFillBusinessID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть возле заправки!");
	new 
		id = pTemp[playerid][tFillBusinessID];
	if (IsPlayerInRangeOfPoint(playerid, 7.5, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2])) 
	{
		//pTemp[playerid][tBusinessID] = id;
		//ShowBusinessBuyMenu(playerid, id);//BusinessInfo[id][bItemsPrice][0] 
		pTemp[playerid][gContract] = id;
		SetPVarInt(playerid,"CostBenzMeh", (BusinessInfo[id][bItemsPrice][0]*100) / 2);
		new 
			string_[100];
		format(string_, sizeof string_, "<< 100 литров. Цена: $%i >>", GetPVarInt(playerid,"CostBenzMeh"));
		if (pTemp[playerid][Mechanic3DText] != Text3D:-1) {
			DestroyDynamic3DTextLabel(pTemp[playerid][Mechanic3DText]);
			pTemp[playerid][Mechanic3DText] = Text3D:-1;
		}
		pTemp[playerid][Mechanic3DText] = CreateDynamic3DTextLabel(string_, COLOR_REDD, 0.0, 0.0, 0.0, 15.0, INVALID_PLAYER_ID, R_CAR_JOB);
		SendClientMessage(playerid, COLOR_GREEN, !"Вы подписали контракт с заправкой");
		Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, pTemp[playerid][Mechanic3DText], E_STREAMER_ATTACH_OFFSET_Z, 2.0);
	}
	else pTemp[playerid][tFillBusinessID] = -1;
	return 1;
}
CMD:fill(playerid) {
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
		return true;
	if (pTemp[playerid][tFillBusinessID] == -1) 
		return true;
	new id = pTemp[playerid][tFillBusinessID], vehicleid = GetPlayerVehicleID(playerid);
	if (IsPlayerInRangeOfPoint(playerid, 7.5, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2])) {
		if (
			GetPlayerState(playerid) != PLAYER_STATE_DRIVER || 
			(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510)
		) {
			SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы не в автомобиле или этот транспорт нельзя заправить!");
			return true;
		}
		pTemp[playerid][tBusinessID] = id;
		ShowBusinessBuyMenu(playerid, id);
	}
	else pTemp[playerid][tFillBusinessID] = -1;

	return true;
}
business_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
		return false;
	if (newkeys & KEY_CROUCH && !(oldkeys & KEY_CROUCH)) {
		new bool:isReturn = false, vehicleid = GetPlayerVehicleID(playerid);

		if (pInfo[playerid][pJob] == 5 && pTemp[playerid][pRentCar] == vehicleid && VehicleInfo[vehicleid - 1][vType] == VEHICLE_TYPE_JOB && VehicleInfo[vehicleid - 1][vFraction] == PLAYER_JOB_DELIVERY) {
			if (!pTemp[playerid][tBusinessOrderID]) {
				return true;
			}
			new id = pTemp[playerid][tBusinessOrderID] - 1;
			if (!IsPlayerInRangeOfPoint(playerid, 20.0, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2])) {
				SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться у входа бизнеса!");
				return true;
			}
			new
				paycheck = BusinessInfo[id][bOrderProducts] * BusinessTypeInfo[BusinessInfo[id][bType]][bTypeOrderPrice],
				ownerid = GetPlayerID(BusinessInfo[id][bOwner]);

			if (ownerid != INVALID_PLAYER_ID) {
				SendMes(ownerid, COLOR_BLUE, "Внимание! Ваш заказ продуктов (%i ед.) для %s был успешно доставлен", BusinessInfo[id][bOrderProducts], BusinessInfo[id][bName]);
			}
			BusinessInfo[id][bProducts] += BusinessInfo[id][bOrderProducts];
			BusinessInfo[id][bOrderProducts] = BusinessInfo[id][bOrderStatus] = 0; 
			BusinessInfo[id][bUnBankToday] -= paycheck;
			pTemp[playerid][tBusinessOrderID] = 0; 
			format(t_string, sizeof (t_string), "bProducts = %i, bOrderProducts = %i, bUnBankToday = %i", 
				BusinessInfo[id][bProducts], BusinessInfo[id][bOrderProducts], BusinessInfo[id][bUnBankToday]
			);
			SaveBusiness(id, t_string);
	
			kLibGivePlayerMoney(playerid, paycheck, "доставил продукты");
			SendMes(playerid, COLOR_BLUE, "Вы успешно доставили продукты в бизнес! Вы получили: "collime"$%i", paycheck);
			OnPlayerAchievProgress(playerid, 22);
			OnPlayerAchievProgress(playerid, 23);
			OnPlayerAchievProgress(playerid, 24);
			
			ExpExp(playerid, GetVipBoostMaxPlayerValue(playerid, vSkillJobProd, bSkillJobProd, 1));
			t_string[0] = EOS;

			if (CP[playerid] == 777) {
				DisablePlayerCheckpoint(playerid);
				CP[playerid] = 0;
			}
			
			return true;
		}
		if (pTemp[playerid][tFillBusinessID] != -1) {
			new id = pTemp[playerid][tFillBusinessID];
			if (IsPlayerInRangeOfPoint(playerid, 7.5, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2])) {
				if (
					GetPlayerState(playerid) != PLAYER_STATE_DRIVER || 
					(GetVehicleModel(vehicleid) == 481 || GetVehicleModel(vehicleid) == 509 || GetVehicleModel(vehicleid) == 510)
				) {
					SendClientMessage(playerid,COLOR_YELLOW, "Вы не в автомобиле или этот транспорт нельзя заправить!");
					return true;
				}
				pTemp[playerid][tBusinessID] = id;
				ShowBusinessBuyMenu(playerid, id);
			}
			else pTemp[playerid][tFillBusinessID] = -1;

			return true;
		}
		for (new id = 0; id < sizeof (BusinessInfo); id++) {
			if (!IsValidBusiness(id)) 
				continue;
			if (!IsPlayerInRangeOfPoint(playerid, 5.0, BusinessInfo[id][bActionPos][0], BusinessInfo[id][bActionPos][1], BusinessInfo[id][bActionPos][2])) 
				continue;
			new interior_id = BusinessInfo[id][bInteriorID]; // GetBusinessInteriorID(id);
			switch (BusinessInfo[id][bType]) {
				case BUSINESS_TYPE_CUSTOMS: {
					/*if (VehicleInfo[vehicleid - 1][vType] != VEHICLE_TYPE_PLAYER) {
						if (VehicleInfo[ vehicleid - 1 ][vFraction] != pInfo[playerid][pID] || VehicleInfo[ vehicleid - 1 ][vType] != VEHICLE_TYPE_PLAYER) return SendClientMessage(playerid, -1, !"Вы должны находиться в Вашем личном транспорте!");
						//if (VehicleInfo[vehicleid - 1][vFraction] != pInfo[playerid][pID]) return SendClientMessage(playerid, COLOR_GREY, !"Данный ТС не Ваш!");
						SendClientMessage(playerid, COLOR_GREY, !"Доступно только для личного транспорта!");
						isReturn = true;
						break;
					}*/
					if (!CheckVehicleRevision(playerid, vehicleid))
					{	SendClientMessage(playerid, COLOR_GREY, !"Доступно только для личного транспорта!");
						isReturn = true;
						break;
					}
					if (BusinessInfo[id][bLocked]) {
						SendClientMessage(playerid, COLOR_GREY, !"Автомастерская закрыта в данный момент!");
						isReturn = true;
						break;
					}
					/*if (v_velo(vehicleid) || IsAPlane(vehicleid) || IsABoat(vehicleid) || IsANoSTO(vehicleid)) {*/
					if ( GetVehicleState(vehicleid) <  VEHICLE_STATE_BIKE || IsANoSTO(vehicleid) ){
						SendClientMessage(playerid, COLOR_GREY, !"Данный транспорт не подходит!");
						isReturn = true;
						break;
					}
					if (get_passenger_count(playerid)) {
						SendClientMessage(playerid, COLOR_GREY, !"Высадите всех пассажиров!");
						isReturn = true;
						break;
					}
					for (new i = 0; i < 7; i++) {
						if (!pTemp[playerid][tCustomsObjectID][i]) continue;
						DestroyDynamicObject(pTemp[playerid][tCustomsObjectID][i] - 1);
						pTemp[playerid][tCustomsObjectID][i] = 0;
					}
					pTemp[playerid][tCustomsObjectID][0] = CreateDynamicObject(19866, 1724.480102, 1829.027465, 1051.318603, 0.000000, 90.000038, 0.000000, playerid + 1, BUSINESS_CUSTOMS_INTERIOR_ID, -1, 100.00, 100.00); // ELEVATOR
					SetDynamicObjectMaterial(pTemp[playerid][tCustomsObjectID][0], 0, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
					pTemp[playerid][tCustomsObjectID][1] = CreateDynamicObject(19940, 1723.870727, 1829.087402, 1051.398681, 0.000037, 0.000000, 89.999885, playerid + 1, BUSINESS_CUSTOMS_INTERIOR_ID, -1, 100.00, 100.00); // ELEVATOR
					SetDynamicObjectMaterial(pTemp[playerid][tCustomsObjectID][1], 0, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
					pTemp[playerid][tCustomsObjectID][2] = CreateDynamicObject(19866, 1722.469116, 1829.027465, 1051.318603, 0.000000, 90.000038, 0.000000, playerid + 1, BUSINESS_CUSTOMS_INTERIOR_ID, -1, 100.00, 100.00); // ELEVATOR
					SetDynamicObjectMaterial(pTemp[playerid][tCustomsObjectID][2], 0, 3474, "freightcrane", "yellowcabchev_256", 0x00000000);
					pTemp[playerid][tCustomsObjectID][3] = CreateDynamicObject(19939, 1722.148925, 1830.769042, 1051.400634, 0.000037, 0.000000, 89.999885, playerid + 1, BUSINESS_CUSTOMS_INTERIOR_ID, -1, 100.00, 100.00); // ELEVATOR
					SetDynamicObjectMaterial(pTemp[playerid][tCustomsObjectID][3], 0, 7103, "vgnplantgen", "metalwheel5", 0xFFFFFFFF);
					pTemp[playerid][tCustomsObjectID][4] = CreateDynamicObject(19939, 1722.148925, 1827.277343, 1051.400634, 0.000044, 0.000000, 89.999862, playerid + 1, BUSINESS_CUSTOMS_INTERIOR_ID, -1, 100.00, 100.00); // ELEVATOR
					SetDynamicObjectMaterial(pTemp[playerid][tCustomsObjectID][4], 0, 7103, "vgnplantgen", "metalwheel5", 0xFFFFFFFF);
					pTemp[playerid][tCustomsObjectID][5] = CreateDynamicObject(19939, 1725.654663, 1827.417968, 1051.400634, -0.000037, 0.000000, -89.999855, playerid + 1, BUSINESS_CUSTOMS_INTERIOR_ID, -1, 100.00, 100.00); // ELEVATOR
					SetDynamicObjectMaterial(pTemp[playerid][tCustomsObjectID][5], 0, 7103, "vgnplantgen", "metalwheel5", 0xFFFFFFFF);
					pTemp[playerid][tCustomsObjectID][6] = CreateDynamicObject(19939, 1725.654663, 1830.909667, 1051.400634, -0.000030, 0.000000, -89.999877, playerid + 1, BUSINESS_CUSTOMS_INTERIOR_ID, -1, 100.00, 100.00); // ELEVATOR
					SetDynamicObjectMaterial(pTemp[playerid][tCustomsObjectID][6], 0, 7103, "vgnplantgen", "metalwheel5", 0xFFFFFFFF);

					TogglePlayerControllable(playerid, false);
					setFreezePlayerForTime(playerid, 3);

					SetPlayerCameraPos(playerid, 1726.886474, 1822.724731, 1055.264282) ;
					SetPlayerCameraLookAt(playerid, 1724.885498, 1827.007446, 1053.635009) ;

					for(new i = 0; i < sizeof (BizzTuning); i++) {
						TextDrawShowForPlayer(playerid, BizzTuning[i]);
					}
					SelectTextDraw(playerid, 0xFF4040AA);//

					TogglePlayerControllable(playerid, false);
					SetPVarInt(playerid, "tuning_opened", 1);
					
					SetVehiclePos(vehicleid, 1723.8934, 1828.9700, 1052.1908);
					SetVehicleZAngle(vehicleid, 180.3008);

					SetPlayerInterior(playerid, BusinessInteriorInfo[interior_id][bIntInterior]);
					SetPlayerVirtualWorld(playerid, playerid + 1);

					LinkVehicleToInterior(vehicleid, BusinessInteriorInfo[interior_id][bIntInterior]);
					SetVehicleVirtualWorld(vehicleid, playerid + 1);

					SetPlayerArmedWeapon(playerid, 0);
					ShowBusinessBuyMenu(playerid, id);
		
					Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
					
					for (new i = 0, objectid, Float:obj_b_Pos[6]; i < 7; i++) {
						objectid = pTemp[playerid][tCustomsObjectID][i] - 1;
						GetDynamicObjectPos(objectid, obj_b_Pos[0], obj_b_Pos[1], obj_b_Pos[2]);
						GetDynamicObjectRot(objectid, obj_b_Pos[3], obj_b_Pos[4], obj_b_Pos[5]);
						MoveDynamicObject(objectid, 
							obj_b_Pos[0], obj_b_Pos[1], obj_b_Pos[2] + BUSINESS_CUSTOMS_ELEVATOR_HEIGHT, 
							0.30, obj_b_Pos[3], obj_b_Pos[4], obj_b_Pos[5]
						);
					} 
					pTemp[playerid][tBusinessID] = id;
					isReturn = true;
					break;
				}
			}
		}
		if (isReturn) return true;
	}
	return false;
}
stock CreateCheckBusinessToday() { // (checking every day)
	for (new id = 0; id < sizeof (BusinessInfo); id++) {
		if (!IsValidBusiness(id)) 
			continue; 
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 1 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 2 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 3 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 4 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 5 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 6 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 7 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 8 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
	}
}
stock CheckBusinessToday() { // (checking every day)
	for (new id = 0; id < sizeof (BusinessInfo); id++) {
		if (!IsValidBusiness(id)) 
			continue; 
		format(t_string, sizeof t_string, "INSERT INTO `sh_business` (`bDate`,`bBizID`,`bProfit`,`bUnProfit`) VALUES (NOW()-INTERVAL 1 DAY,'%d','%d','%d')",
			BusinessInfo[id][bID], BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;

		BusinessInfo[id][bBankToday] = 0;
		BusinessInfo[id][bUnBankToday] = 0; 
		format(t_string, sizeof (t_string), "bBankToday = %i, bUnBankToday = %i",
			BusinessInfo[id][bBankToday], BusinessInfo[id][bUnBankToday]
		);
		SaveBusiness(id, t_string), t_string[0] = EOS; 
	}
}
stock CheckBusiness() { // (checking every NewHour)
	for (new id = 0, playerid, type; id < sizeof (BusinessInfo); id++) {
		if (!IsValidBusiness(id)) 
			continue;
		if (!strcmp(BusinessInfo[id][bOwner], "None", true)) 
			continue;

		type = BusinessInfo[id][bType];		
		playerid = GetPlayerID(BusinessInfo[id][bOwner]);
	
		if(BusinessInfo[id][bLocked] == 1 && BusinessInfo[id][bLockedTime] >= 24) {
			ClearBusiness(id);
			printf("[businesses] Бизнес #%i был продан 24 закрыт!", BusinessInfo[id][bID]);
		}
		else
		{ 
			if(BusinessInfo[id][bProducts] <= 100)
			{
				if(playerid != INVALID_PLAYER_ID)
				{ 
					if(BusinessInfo[id][bLockedTime] == 0) {
						format(t_string, sizeof (t_string), " Ваш бизнес [%s: %s] был закрыт по причине отсутствие продуктов", 
							BusinessTypeInfo[type][bTypeName], BusinessInfo[id][bName] 
						);
						SendClientMessage(playerid, COLOR_BLUE, t_string), t_string[0] = EOS;  
						SendClientMessage(playerid, COLOR_BLUE, !" Если по истечению 24 часов бизнес будет закрыт, он будет продан государству!");
					}
					BusinessInfo[id][bLocked] = 1; 
				} else {
					BusinessInfo[id][bLocked] = 1; 
				}
			}
			if(BusinessInfo[id][bLocked] == 1) {
				BusinessInfo[id][bLockedTime]++; 
			}
			if(BusinessInfo[id][bLockedTime] > 1 && BusinessInfo[id][bLockedTime] < 12) {
				if(IsPlayerConnected(playerid) && playerid != INVALID_PLAYER_ID) {
					format(t_string, sizeof (t_string), " Ваш бизнес [%s: %s] закрыт уже %d %s", 
							BusinessTypeInfo[type][bTypeName], BusinessInfo[id][bName], BusinessInfo[id][bLockedTime], Declension_ReturnWord(BusinessInfo[id][bLockedTime], "час", "часа", "часов")
					);
					SendClientMessage(playerid, COLOR_BLUE, t_string), t_string[0] = EOS; 
					SendClientMessage(playerid, COLOR_BLUE, !" Если по истечению 24 часов бизнес будет закрыт, он будет продан государству!"); 
				}
			}
			if(BusinessInfo[id][bProducts] > 100 && BusinessInfo[id][bLandTax] > 10 && BusinessInfo[id][bLockedTime] != 0)
			{
				BusinessInfo[id][bLocked] = 0; 
				BusinessInfo[id][bLockedTime] = 0; 
			}
			if (playerid != INVALID_PLAYER_ID) {
				format(t_string, sizeof (t_string), " Оплата за бизнес [%s: %s]: "collime"$%i", 
					BusinessTypeInfo[type][bTypeName],
					BusinessInfo[id][bName],
					(BusinessTypeInfo[type][bTypeTaxDay] / 24)
				);
				SendClientMessage(playerid, COLOR_BLUE, t_string), t_string[0] = EOS;
			}
			BusinessInfo[id][bLandTax] -= (BusinessTypeInfo[type][bTypeTaxDay] / 24); 
			format(t_string, sizeof (t_string), "bLandTax = %i, bLocked = %i, bLockedTime = %i",
				BusinessInfo[id][bLandTax], BusinessInfo[id][bLocked], BusinessInfo[id][bLockedTime]
			);
			SaveBusiness(id, t_string), t_string[0] = EOS;

			if (BusinessInfo[id][bLandTax] <= 0) {
				ClearBusiness(id);
				printf("[businesses] Бизнес #%i был продан за неуплату!", BusinessInfo[id][bID]);
			} else {
				if (BusinessInfo[id][bMafia] != 0) {
					FractionInfo[ BusinessInfo[id][bMafia] ][fMoney] += 500;
					GiveFractionRepute(BusinessInfo[id][bMafia], 2);
					UpdateFractionStore(FractionInfo[BusinessInfo[id][bMafia]][fID]);
					SaveFractionInfoID(FractionInfo[BusinessInfo[id][bMafia]][fID], false);
				}
			}
		} 
	}
}
stock ShowMenuGAS(playerid) {
	if (pTemp[playerid][tGasMenuShowed]) return true;

	new id = pTemp[playerid][tBusinessID];

	format(t_string, sizeof (t_string), "PRICE: ~g~$%i", BusinessInfo[id][bItemsPrice][0]);
	BusinessGAS_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 411.666412, 151.029571, t_string), t_string[0] = EOS;
	PlayerTextDrawLetterSize(playerid, BusinessGAS_PTD[playerid][1], 0.202915, 0.894814);
	PlayerTextDrawTextSize(playerid, BusinessGAS_PTD[playerid][1], 423.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, BusinessGAS_PTD[playerid][1], 3);
	PlayerTextDrawColor(playerid, BusinessGAS_PTD[playerid][1], -1);
	PlayerTextDrawSetShadow(playerid, BusinessGAS_PTD[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, BusinessGAS_PTD[playerid][1], 1);
	PlayerTextDrawBackgroundColor(playerid, BusinessGAS_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, BusinessGAS_PTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, BusinessGAS_PTD[playerid][1], 1);

	BusinessGAS_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 242.300125, 164.951919, "LD_SPAC:white");
	PlayerTextDrawTextSize(playerid, BusinessGAS_PTD[playerid][2], 0.000000, 16.000000);
	PlayerTextDrawAlignment(playerid, BusinessGAS_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, BusinessGAS_PTD[playerid][2], 255);
	PlayerTextDrawSetShadow(playerid, BusinessGAS_PTD[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, BusinessGAS_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, BusinessGAS_PTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, BusinessGAS_PTD[playerid][2], 0);

	BusinessGAS_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 319.583343, 167.298614, "_");
	PlayerTextDrawLetterSize(playerid, BusinessGAS_PTD[playerid][0], 0.195500, 1.161481);
	PlayerTextDrawAlignment(playerid, BusinessGAS_PTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, BusinessGAS_PTD[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, BusinessGAS_PTD[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, BusinessGAS_PTD[playerid][0], 1);
	PlayerTextDrawBackgroundColor(playerid, BusinessGAS_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, BusinessGAS_PTD[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, BusinessGAS_PTD[playerid][0], 1);

	for (new i = 0; i < sizeof (BusinessGAS_TD); i++) 
		TextDrawShowForPlayer(playerid, BusinessGAS_TD[i]);
	for (new i = 0; i < 3; i++) 
		PlayerTextDrawShow(playerid, BusinessGAS_PTD[playerid][i]);
	SelectTextDraw(playerid, COLOR_SERVER);

	pTemp[playerid][tGasMenuShowed] = true;
	SetGasMenuProgressBar(playerid, .fuel = 1);

	return true;
}

stock SetGasMenuProgressBar(playerid, Float:fuel) {
	if (!pTemp[playerid][tGasMenuShowed]) return false;
	new id = pTemp[playerid][tBusinessID], vehicleid = GetPlayerVehicleID(playerid);
	if (fuel <= VehicleInfo[vehicleid - 1][vFuel])  {
		fuel = VehicleInfo[vehicleid - 1][vFuel] + 1;
	} 
	else if (fuel > GetModelMaxFuel(VehicleInfo[ vehicleid - 1 ][vModel])) {
		fuel = GetModelMaxFuel(VehicleInfo[ vehicleid - 1 ][vModel]);
	}
	pTemp[playerid][tGasMenuProgress] = fuel;
	
	format(t_string, sizeof (t_string), "PRICE: ~g~$%i", 
		floatround((fuel - VehicleInfo[vehicleid - 1][vFuel]) * BusinessInfo[id][bItemsPrice][0])
	);
	PlayerTextDrawSetString(playerid, BusinessGAS_PTD[playerid][1], t_string), t_string[0] = EOS;

	format(t_string, sizeof (t_string), "%.0fL. ~y~(+%.0fL.)", 
		VehicleInfo[vehicleid - 1][vFuel], fuel - VehicleInfo[vehicleid - 1][vFuel]
	);
	PlayerTextDrawSetString(playerid, BusinessGAS_PTD[playerid][0], t_string), t_string[0] = EOS;

	//new Float:progress = fuel / 2;
	new Float:progress = VehicleInfo[vehicleid - 1][vFuel] * (100.0 / GetModelMaxFuel(VehicleInfo[ vehicleid - 1 ][vModel])) * 1.652;
	if (progress > 95.0) 
		TextDrawShowForPlayer(playerid, BusinessGAS_TD[12]);
	else TextDrawHideForPlayer(playerid, BusinessGAS_TD[12]);
	
	progress *= 1.652; // (>95%)
	if (progress > 157.0) progress = 157.0;

	PlayerTextDrawTextSize(playerid, BusinessGAS_PTD[playerid][2], progress, 16.000000);
	PlayerTextDrawShow(playerid, BusinessGAS_PTD[playerid][2]);

	return true;
}
stock HideMenuGas(playerid) {
	if (!pTemp[playerid][tGasMenuShowed]) return false;
	for (new i = 0; i < sizeof (BusinessGAS_TD); i++) 
		TextDrawHideForPlayer(playerid, BusinessGAS_TD[i]);
	for (new i = 0; i < 3; i++) 
		PlayerTextDrawDestroy(playerid, BusinessGAS_PTD[playerid][i]);
	pTemp[playerid][tGasMenuShowed] = false;
	CancelSelectTextDraw(playerid);
	return true;
}
stock SetBusinessSkinPage(playerid, type = 0) {
	new maxSkins = sizeof (ListMenuClothesMale); 
	if (pInfo[playerid][pSex] != 1) 
		maxSkins = sizeof (ListMenuClothesFemale);
	switch (type) {
		case 0: { // (+)
			if (ChangeSkin[playerid] == (maxSkins - 1))
				ChangeSkin[playerid] = 0;
			else ChangeSkin[playerid]++;
		}
		default: { // (-)
			if (ChangeSkin[playerid] == 0) 
				ChangeSkin[playerid] = (maxSkins - 1);
			else ChangeSkin[playerid]--;
		}
	}
	new skinid = ChangeSkin[playerid];
	if (pInfo[playerid][pSex] == 1) {
		format(t_string, sizeof (t_string), "~w~%d", ListMenuClothesMale[skinid][1]);
		SetPlayerSkinEx(playerid, ListMenuClothesMale[skinid][0]);
	} else {
		format(t_string, sizeof (t_string), "~w~%d", ListMenuClothesFemale[skinid][1]);
		SetPlayerSkinEx(playerid, ListMenuClothesFemale[skinid][0]);
	}
	PlayerTextDrawSetString(playerid, sk_info_text[playerid], t_string), t_string[0] = EOS;
}
stock GetBusinessSkinPrice(playerid) {
	new skinid = ChangeSkin[playerid], price;
	if (pInfo[playerid][pSex] == 1) {
		price = ListMenuClothesMale[skinid][1];
	} else {
		price = ListMenuClothesFemale[skinid][1];
	}
	price = GetVipBoostMaxPlayerValue(playerid, vSaleSkin, bSaleSkin, price);
	return price;
}


CMD:sellbiz(playerid, params[]) {
	if (!GetPlayerBusinesses(playerid)) {
		SendClientMessage(playerid, COLOR_GREY, !"У вас нет ниодного бизнеса!");
		return true;
	}
	new targetid;
	if (sscanf(params, "u", targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "Введите: /sellbiz [id]");
	if (!IsPlayerConnected(targetid) || playerid == targetid) 
		return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, targetid)) 
		return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом!");
	if (GetPlayerBusinesses(targetid) >= GetPlayerAvailableBusiness(targetid)) {
		SendClientMessage(playerid, COLOR_WHITE, !"У игрока уже максимальное количество бизнесов.");
		return true;
	}
	if (pTemp[playerid][tBusinessSellerTargetID] != INVALID_PLAYER_ID || pTemp[playerid][tBusinessBuyerTargetID] != INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, COLOR_GREY, !"У игрока вас есть активная сделка!");
	if (pTemp[targetid][tBusinessSellerTargetID] != INVALID_PLAYER_ID || pTemp[targetid][tBusinessBuyerTargetID] != INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, COLOR_GREY, !"У игрока уже есть активная сделка!");
	ShowBusinessPanel(playerid, D_BUSINESS_PANEL_SELECT_SELL);
	pTemp[playerid][tBusinessTempTargetID] = targetid;
	return true;
}
CMD:showbizinfo(playerid, params[]) {
	if (!GetPlayerBusinesses(playerid)) {
		SendClientMessage(playerid, COLOR_GREY, !"У вас нет ниодного бизнеса!");
		return true;
	}
	new targetid;
	if (sscanf(params, "u", targetid)) 
		return SendClientMessage(playerid, COLOR_GRAD2, "Введите: /showbizinfo [id]");
	 if (!IsPlayerConnected(targetid) || playerid == targetid) 
	 	return SendClientMessage(playerid, COLOR_GREY, !"Человек не найден/Вы указали свой ID!");
	if (!IsPlayerInRangeOfPlayer(8.0, playerid, targetid)) 
		return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом друг с другом!"); 

	/*if (pTemp[playerid][tBusinessSellerTargetID] != INVALID_PLAYER_ID || pTemp[playerid][tBusinessBuyerTargetID] != INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, COLOR_GREY, !"У игрока вас есть активная сделка!");
	if (pTemp[targetid][tBusinessSellerTargetID] != INVALID_PLAYER_ID || pTemp[targetid][tBusinessBuyerTargetID] != INVALID_PLAYER_ID) 
		return SendClientMessage(playerid, COLOR_GREY, !"У игрока уже есть активная сделка!");*/
	ShowBusinessPanel(playerid, D_BUSINESS_PANEL_SELECT_BIZINFO);
	pTemp[playerid][tBusinessShowBizTargetID] = targetid;

	// tBusinessTempTargetID/
	return true;
}

CMD:addbiz(playerid) {
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) 
		return true;
	ShowBusinessPanel(playerid, D_BUSINESS_ADD_BIZ_TYPE);
	return true;
}
CMD:editbiz(playerid) {
    if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) 
		return true;
	pTemp[playerid][tCurrentBusinessID] = -1;

	for (new id = 0; id < sizeof (BusinessInfo); id++) {
		if (!IsValidBusiness(id)) 
			continue;
		if (!IsPlayerInRangeOfPoint(playerid, 5.0, BusinessInfo[id][bPos][0], BusinessInfo[id][bPos][1], BusinessInfo[id][bPos][2])) 
			continue; 
		pTemp[playerid][tCurrentBusinessID] = id;
		ShowBusinessPanel(playerid, D_BUSINESS_EDIT_MENU);
		break;
	}
	if (pTemp[playerid][tCurrentBusinessID] == -1) {
		SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с бизнесом!");
	}
	return true;
}
/* ( LOAD ACCOUNT DATA ):

	#if defined _businesses_inc
		new tempBusinessID[MAX_PLAYER_BUSINESS];
		cache_get_value_name(0, "pBusinessID", kickout, sizeof (kickout));
		sscanf(kickout, "p<,>a<i>["#MAX_PLAYER_BUSINESS"]", tempBusinessID);

		for (new id = 0; id < sizeof (BusinessInfo); id++) {
			for (new i = 0; i < MAX_PLAYER_BUSINESS; i++) {
				if (tempBusinessID[i] != BusinessInfo[id][bID]) continue;
				pInfo[playerid][pBusinessID][i] = id + 1;
				tempBusinessID[i] = 0;
			}
		}
	#endif


	#if defined _businesses_inc
		if (business_OnPlayerPickUpDynPickup(playerid, pickupid)) return true;
	#endif


	#if defined _businesses_inc
		if (business_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return true;
	#endif


	#if defined _businesses_inc
		if (business_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)) return true;
	#endif


	#if defined _businesses_inc
		CheckBusiness();
	#endif
*/
/*CMD:prodlist(playerid) { // (TEST COMMAND ORDER PRODUCTS) + business_OnDialogResponse
	ShowBusinessPanel(playerid, D_BUSINESS_ORDERS_LIST);
	return true;
}*//* OnPlayerDisconnect + OnPlayerSpawn
if (pTemp[playerid][tBusinessOrderID]) {
	new business_id = pTemp[playerid][tBusinessOrderID] - 1;
	BusinessInfo[business_id][bOrderStatus] = 0;
}*/

publics: RobbingTimer()
{
    new id, type, pl[sizeof (BusinessInfo)][8], keys, updown, leftright;

	foreach(new i: PlayerInLogin) {
		id = pTemp[i][tActorBusinessID];
		if (!id) 
			continue;
		switch (GetPlayerWeapon(i)) {
			case 23, 24, 29, 30, 31, 32: { }
			default: continue;
		}
		if (GetPlayerTargetDynamicActor(i) != BusinessInfo[id][bActorID]) 
			continue;
		GetPlayerKeys(i, keys, updown, leftright);

		if (!(keys & KEY_HANDBRAKE)) continue;

		type = BusinessInfo[id][bType];
		/*if (strcmp(BusinessInfo[id][bOwner], "None", true) == 0) {
			SendClientMessage(i, COLOR_GREY, !"Бизнес на данный момент принадлежит государству - Вы не можете его ограбить!");
			break;
		}
			   */     
		if (BusinessInfo[id][bNewRobStart] - gettime() > 0) {
			SendMes(i, -1, "- Ограбить \"%s\" можно через %s.", BusinessTypeInfo[type][bTypeName], Convert(BusinessInfo[id][bNewRobStart] - gettime()));
		} else {
			if (BusinessInfo[id][bRobStatus] == false) {
				switch (pInfo[i][pMember]) {
					case 12: pl[id][0]++;
					case 13: pl[id][1]++;
					case 15: pl[id][2]++;
					case 17: pl[id][3]++;
					case 18: pl[id][4]++;
					case 5: pl[id][5]++;
					case 6: pl[id][6]++;
					case 14: pl[id][7]++;
					default: continue;
				}
				switch (type) {
					case BUSINESS_TYPE_24_7: {
						if (BusinessInfo[id][bBank] < 30_000) {
							SendClientMessage(i, COLOR_GREY, !"В кассе недостаточно денег!");
							break;
						}
						if (
							pl[id][0] >= MIN_BIZROB_PLAYERS || pl[id][1] >= MIN_BIZROB_PLAYERS || 
							pl[id][2] >= MIN_BIZROB_PLAYERS || pl[id][3] >= MIN_BIZROB_PLAYERS || 
							pl[id][4] >= MIN_BIZROB_PLAYERS
						) {
							ApplyDynamicActorAnimation(BusinessInfo[id][bActorID], "SHOP", "SHP_HandsUp_Scr",4.1,0,0,0,1,0);
							BusinessInfo[id][bRobStatus] = true;
							SetTimerEx("RobsEnabledCD", 1800_000, false, "d",id);

							new Float:robX,Float:robY,Float:robZ;
							GetPlayerPos(i,robX,robY,robZ);
							BusinessInfo[id][TD_Draw] = 264.0;
							BusinessInfo[id][bRobTimer] = SetTimerEx("RobTickTimer", 1000, true, "ddddfff", i, 2, pInfo[i][pMember], id,robX,robY,robZ);

							//RobTickRTC[i] = 30;
							//pTemp[i][PlayerTimeRobsCD] = SetTimerEx("RobTickRTSC", 1000, true, "dddd", i, 2, pInfo[i][pMember], id);
							WantedsRobFriend(pInfo[i][pMember], id);
						}
						else SendClientMessage(i, COLOR_GREY, "Для начала ограбления нужно минимум "#MIN_BIZROB_PLAYERS" напарника");
					}
					case 
						BUSINESS_TYPE_VICTIM, BUSINESS_TYPE_ZIP, BUSINESS_TYPE_SUB_URBAN, 
						BUSINESS_TYPE_BINCO, BUSINESS_TYPE_PROLAPS, BUSINESS_TYPE_DIDIER_SACH: {
						if (
							pl[id][0] >= MIN_BIZROB_PLAYERS || pl[id][1] >= MIN_BIZROB_PLAYERS || 
							pl[id][2] >= MIN_BIZROB_PLAYERS || pl[id][3] >= MIN_BIZROB_PLAYERS || 
							pl[id][4] >= MIN_BIZROB_PLAYERS
						) {
							ApplyDynamicActorAnimation(BusinessInfo[id][bActorID], "SHOP", "SHP_HandsUp_Scr",4.1,0,0,0,1,0);
							BusinessInfo[id][bRobStatus] = true;
							SetTimerEx("RobsEnabledCD", 1800_000, false, "d",id);

							new Float:robX,Float:robY,Float:robZ;
							GetPlayerPos(i,robX,robY,robZ);
							BusinessInfo[id][TD_Draw] = 264.0;
							BusinessInfo[id][bRobTimer] = SetTimerEx("RobTickTimer", 1000, true, "ddddfff", i, 0, pInfo[i][pMember], id,robX,robY,robZ);
							/*RobTickRTC[i] = 30;
							pTemp[i][PlayerTimeRobsCD] = SetTimerEx("RobTickRTSC", 1000, true, "dddd", i, 0, pInfo[i][pMember], id);*/
							WantedsRobFriend(pInfo[i][pMember], id);
						}
						else SendClientMessage(i, COLOR_GREY, !"Для начала ограбления нужно минимум "#MIN_BIZROB_PLAYERS" напарника.");
					}
					case BUSINESS_TYPE_AMMO: {
						if (
							pl[id][5] >= MIN_BIZROB_PLAYERS || 
							pl[id][6] >= MIN_BIZROB_PLAYERS || 
							pl[id][7] >= MIN_BIZROB_PLAYERS
						) {
							ApplyDynamicActorAnimation(BusinessInfo[id][bActorID], "SHOP", "SHP_HandsUp_Scr",4.1,0,0,0,1,0);
							BusinessInfo[id][bRobStatus] = true;
							SetTimerEx("RobsEnabledCD", 1800_000, false, "d",id);

							new Float:robX,Float:robY,Float:robZ;
							GetPlayerPos(i,robX,robY,robZ);
							BusinessInfo[id][TD_Draw] = 264.0;
							BusinessInfo[id][bRobTimer] = SetTimerEx("RobTickTimer", 1000, true, "ddddfff", i, 1, pInfo[i][pMember], id, robX,robY,robZ);

							//RobTickRTC[i] = 30;
							//pTemp[i][PlayerTimeRobsCD] = SetTimerEx("RobTickRTSC", 1000, true, "dddd", i, 1, pInfo[i][pMember], id);
							WantedsRobFriend(pInfo[i][pMember], id);
						}
						else SendClientMessage(i, COLOR_GREY, "Для начала ограбления нужно минимум "#MIN_BIZROB_PLAYERS" напарника");
					}
				}
			}
		}
	}
}
publics: RobsEnabledCD(id) {
    if (BusinessInfo[id][bRobStatus] != true) return 0;
    BusinessInfo[id][bRobStatus] = false;
    return 0;
}
stock WantedsRobFriend(fraks, id)
{
	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin]) 
			continue;
		if (pTemp[i][tActorBusinessID] != id) 
			continue;
		if (pInfo[i][pMember] != fraks) 
			continue;
	    if (
			IsPlayerInDynamicArea(i, BusinessInfo[id][bActorArea])
		) {
			if (pInfo[i][pWantedLevel] > 3) pInfo[i][pWantedLevel] += 1;
			else pInfo[i][pWantedLevel] += 3;
			SetPlayerWantedLevelEx(i, pInfo[i][pWantedLevel]);
			format(t_string, sizeof (t_string), "Ограбление %s", BusinessInfo[id][bName]);
			SetPlayerCriminal(i,"Неизвестный", t_string), t_string[0] = EOS;
		}
	}
	return 0;
}
stock RobSuccessFilly(pids, tip ,member, id)
{
	new CD_RobTime = 1800;
	if (tip == 0)
	{
		new maxform;
		foreach(new i: PlayerInLogin) {
			if (!pInfo[i][pLogin]) 
				continue;
			if (pTemp[i][tActorBusinessID] != id) 
				continue;
		    if (pInfo[i][pMember] != member) 
				continue;
			switch (BusinessInfo[id][bType]) {
				case
					BUSINESS_TYPE_VICTIM, BUSINESS_TYPE_ZIP, BUSINESS_TYPE_SUB_URBAN, 
					BUSINESS_TYPE_BINCO, BUSINESS_TYPE_PROLAPS, BUSINESS_TYPE_DIDIER_SACH: {
					if (pInfo[i][pSex] == 2) SetPlayerSkinEx(i, 191);
					else SetPlayerSkinEx(i, 287);
					pTemp[i][PlayerInArmyForm] = true;
					forma[i] = 1;
					SendClientMessage(i, COLOR_WHITE, !"Вы ограбили магазин одежды, в следующий раз можно ограбить через 30 минут");
					CD_RobTime = 1800;
					if (++maxform >= 4) break;
				}
			}
		}
	}//NewRobStart[Robsid] = gettime() + 1800;
	else if (tip == 1)
	{
		new fraction_ = pInfo[pids][pMember];
		FractionInfo[fraction_][fMaterials] += 20_000;
		if (FractionInfo[fraction_][fMaterials] > STORE_MAFIA_MATERIALS) FractionInfo[fraction_][fMaterials] = STORE_MAFIA_MATERIALS;
		UpdateFractionStore(FractionInfo[fraction_][fID]); 
		GiveFractionRepute(fraction_, 10);
		SendClientMessage(pids, -1, !"На склад вашей мафии добавлено 20.000 материалов");
		//SendClientMessage(pids, -1, !"+ 10 Репутации, к Вашей мафии");
		CD_RobTime = 1200;
	}
	else if (tip == 2) {
		new maxform;
		foreach(new i: PlayerInLogin) {
			if (!pInfo[i][pLogin]) continue;
			if (pTemp[i][tActorBusinessID] != id) continue;
		    if (pInfo[i][pMember] != member) continue;
			switch (BusinessInfo[id][bType]) {
				case BUSINESS_TYPE_24_7: {
					CD_RobTime = 7200;
					if (BusinessInfo[id][bBank] < 30_000) {
						SendClientMessage(i, COLOR_LI_RED, !"[Оповещение] "colwhi"В кассе бизнеса недостаточно денег!");
						BusinessInfo[id][bNewRobStart] = (gettime() + CD_RobTime);
						ClearDynamicActorAnimations(BusinessInfo[id][bActorID]); 
						break;
					}
					BusinessInfo[id][bBank] -= 10_000;
					kLibGivePlayerMoney(i, 10000, "rob 24 7");
					SendClientMessage(i, COLOR_LI_RED, !"[Оповещение] "colwhi"Вы успешно ограбили 24/7, сваливайте быстрее пока не приехали легавые!");
					
					if (++maxform >= 5) break;
				}
			}
		}
		format(t_string, sizeof (t_string), "bBank = %i",
			BusinessInfo[id][bBank]
		);
		SaveBusiness(id, t_string);
	}
	BusinessInfo[id][bNewRobStart] = (gettime() + CD_RobTime);
	ClearDynamicActorAnimations(BusinessInfo[id][bActorID]); 
	return 0;
}
/*publics: RobTickRTSC(playerid, tip ,member, id)
{
	if (RobTickRTC[playerid] != -1)
	{
        RobTickRTC[playerid]--;
        if (RobTickRTC[playerid] == -1)
        {
		    if (pTemp[playerid][PlayerTimeRobsCD] != -1)
		    {
			    KillTimer(pTemp[playerid][PlayerTimeRobsCD]);
			    pTemp[playerid][PlayerTimeRobsCD] = -1;
			    RobTickRTC[playerid] = 0;
			    
		    }
		    PlayerTextDrawHide(playerid, ShowProgressRobs[playerid]);
            RobSuccessFilly(playerid, tip, member, id);
        }
        else
        {
            PlayerTextDrawShow(playerid, ShowProgressRobs[playerid]);
            ApplyActorAnimation(BusinessInfo[id][bActorID], "INT_HOUSE", "wash_up",4.1,0,0,0,1,0);
			switch(RobTickRTC[playerid])
			{
                case 29: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIIIIIIIIIII~w~I~b~]");
                case 28: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIIIIIIIIII~w~II~b~]");
                case 27: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIIIIIIIII~w~III~b~]");
                case 26: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIIIIIIII~w~IIII~b~]");
                case 25: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIIIIIII~w~IIIII~b~]");
                case 24: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIIIIII~w~IIIIII~b~]");
                case 23: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIIIII~w~IIIIIII~b~]");
                case 22: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIIII~w~IIIIIIII~b~]");
                case 21: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIIII~w~IIIIIIIII~b~]");
                case 20: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIIII~w~IIIIIIIIII~b~]");
                case 19: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIIII~w~IIIIIIIIIII~b~]");
                case 18: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIIII~w~IIIIIIIIIIII~b~]");
                case 17: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIIII~w~IIIIIIIIIIIII~b~]");
                case 16: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIIII~w~IIIIIIIIIIIIII~b~]");
                case 15: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIIII~w~IIIIIIIIIIIIIII~b~]");
                case 14: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIIII~w~IIIIIIIIIIIIIIII~b~]");
                case 13: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIIII~w~IIIIIIIIIIIIIIIII~b~]");
                case 12: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIIII~w~IIIIIIIIIIIIIIIIII~b~]");
                case 11: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIIII~w~IIIIIIIIIIIIIIIIIII~b~]");
                case 10: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIIII~w~IIIIIIIIIIIIIIIIIIII~b~]");
                 case 9: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIIII~w~IIIIIIIIIIIIIIIIIIIII~b~]");
                 case 8: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIIII~w~IIIIIIIIIIIIIIIIIIIIII~b~]");
                 case 7: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIIII~w~IIIIIIIIIIIIIIIIIIIIIII~b~]");
                 case 6: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIIII~w~IIIIIIIIIIIIIIIIIIIIIIII~b~]");
                 case 5: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIIII~w~IIIIIIIIIIIIIIIIIIIIIIIII~b~]");
                 case 4: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[IIII~w~IIIIIIIIIIIIIIIIIIIIIIIIII~b~]");
                 case 3: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[III~w~IIIIIIIIIIIIIIIIIIIIIIIIIII~b~]");
                 case 2: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[II~w~IIIIIIIIIIIIIIIIIIIIIIIIIIII~b~]");
                 case 1: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[I~w~IIIIIIIIIIIIIIIIIIIIIIIIIIIII~b~]");
                 case 0: PlayerTextDrawSetString(playerid,ShowProgressRobs[playerid], "~b~[~w~IIIIIIIIIIIIIIIIIIIIIIIIIIIIII~b~]");
            }
        }
    }
    return 0;
}*/
stock GetPlayerSimNumberSearch(number)
{
	new _veh_count = 0,
		query_[78];
	format(query_, sizeof query_,"SELECT `pPnumber` FROM `s_users` WHERE `pPnumber` = '%i'", number);
	new Cache: result = mysql_query(dbHandle, query_);
	_veh_count = cache_num_rows( ); 
	if (cache_is_valid(result)) cache_delete(result);
	return _veh_count;
}
/*
CMD:loadbizcar(playerid) { 
	InsertCreateVehicleSTO(525,1622.4813,2197.4287,10.6974,269.1502, 5, 3, 46, 1); // lv sto
	InsertCreateVehicleSTO(525,1622.4220,2193.3306,10.6974,269.1487, 5, 3, 46, 1); // lv sto
	InsertCreateVehicleSTO(525,1622.3445,2188.0981,10.6974,269.1474, 5, 3, 46, 1); // lv sto
	InsertCreateVehicleSTO(525,1673.1422,2202.1848,10.6974,102.6368, 5, 3, 46, 1); // lv sto
	InsertCreateVehicleSTO(525,1673.5927,2196.5881,10.6974,102.6364, 5, 3, 46, 1); // lv sto 
	InsertCreateVehicleSTO(525,-1769.0240,1204.4669,25.0021,181.2719, 3,128, 47, 1); // sf sto
	InsertCreateVehicleSTO(525,-1772.5703,1204.3885,25.0021,181.2719, 3,128, 47, 1); // sf sto
	InsertCreateVehicleSTO(525,-1776.6985,1204.2966,25.0021,181.2719, 3,128, 47, 1); // sf sto
	InsertCreateVehicleSTO(525,-1752.1438,1196.0050,24.9230,90.8030,  3,128, 47, 1); // sf sto
	InsertCreateVehicleSTO(525,-1762.5677,1195.8848,24.9215,90.5203,  3,128, 47, 1); // sf sto
	InsertCreateVehicleSTO(525,866.9146,-582.0993,18.0579,179.9456, 1, 3, 48, 1); // ls sto
	InsertCreateVehicleSTO(525,862.9037,-582.0970,18.0580,179.9447, 1, 3, 48, 1); // ls sto
	InsertCreateVehicleSTO(525,858.6395,-582.0938,18.0582,179.9457, 1, 3, 48, 1); // ls sto
	InsertCreateVehicleSTO(525,854.1686,-582.0900,18.0582,179.9466, 1, 3, 48, 1); // ls sto
	InsertCreateVehicleSTO(525,866.5698,-594.5272,18.0060,89.7860,  1, 3, 48, 1); // ls sto
}

stock InsertCreateVehicleSTO(model, Float:x, Float:y, Float:z, Float:r, c, c_, fraction, subfraction)
{
	new query_[256], number_car[14];
	switch(fraction)
	{
	    case 1: format(number_car, 14, "Customs-%d", fraction);
	    case 2: format(number_car, 14, "Customs-%d", fraction);
	    case 4: format(number_car, 14, "Customs-%d", fraction);
	    case 5: format(number_car, 14, "Customs-%d", fraction);
	    case 7: format(number_car, 14, "Customs-%d", fraction);
	}
	mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO `s_vehicle_business` (`vType`,`vModel`,`vPos`,`vColor`,`vNumber`,`vBusiness`,`vRank`)VALUES ('8','%d','%f|%f|%f|%f','%d,%d','%s','%d','%d')",
	model, x, y, z, r, c, c_, number_car, fraction, subfraction);
	mysql_tquery(dbHandle, query_, "", "");
    return 1;
}*/


businesses_OnGameModeInit()
{
    for (new x = 0; x < sizeof (BusinessInfo); x++) {
        if (!IsValidBusiness(x)) 
            continue;
        BusinessInfo[x][LoadingProgress] = TextDrawCreate(267.000000, 383.000000, "_");
		TextDrawBackgroundColor(BusinessInfo[x][LoadingProgress], 255);
		TextDrawFont(BusinessInfo[x][LoadingProgress], 1);
		TextDrawLetterSize(BusinessInfo[x][LoadingProgress], 0.500000, 1.499999);
		TextDrawColor(BusinessInfo[x][LoadingProgress], -1);
		TextDrawSetOutline(BusinessInfo[x][LoadingProgress], 0);
		TextDrawSetProportional(BusinessInfo[x][LoadingProgress], 1);
		TextDrawSetShadow(BusinessInfo[x][LoadingProgress], 1);
		TextDrawUseBox(BusinessInfo[x][LoadingProgress], 1);
		TextDrawBoxColor(BusinessInfo[x][LoadingProgress], -1207828225);
		TextDrawTextSize(BusinessInfo[x][LoadingProgress], 264.000000, 126.000000);
		TextDrawSetSelectable(BusinessInfo[x][LoadingProgress], 0);
	}
}


publics: RobTickTimer(playerid, tip ,member, id,Float:robX,Float:robY,Float:robZ)
{

    if(GetPlayerTargetDynamicActor(playerid) == BusinessInfo[id][bActorID])  BusinessInfo[id][TD_Draw] += 3.25;
    else BusinessInfo[id][TD_Draw] += 2.55;

    if(BusinessInfo[id][TD_Draw] > 375.0)
	{
		foreach(new i : PlayerTeam[member])
        {
			if (pTemp[i][tPlayerStartRob] != 0)
            {
                TextDrawHideForPlayer(i,Loading[0]);
                TextDrawHideForPlayer(i,Loading[1]);
				TextDrawHideForPlayer(i,BusinessInfo[id][LoadingProgress]);
                pTemp[i][tPlayerStartRob] = 0;
            }
        }
		ApplyActorAnimation(BusinessInfo[id][bActorID], "INT_HOUSE", "wash_up",4.1,0,0,0,1,0);
        RobSuccessFilly(playerid, tip, member, id);
        KillTimer(BusinessInfo[id][bRobTimer]);
        // the end
    }
    else
    {
        new players;
		foreach(new i : PlayerTeam[member])
        {
            if(IsPlayerInRangeOfPoint(i, 30.0, robX,robY,robZ))
            {
                players++;
                TextDrawHideForPlayer(i,BusinessInfo[id][LoadingProgress]);
                TextDrawTextSize(BusinessInfo[id][LoadingProgress], BusinessInfo[id][TD_Draw], 126.000000);
                TextDrawShowForPlayer(i,BusinessInfo[id][LoadingProgress]);
				if(pTemp[i][tPlayerStartRob] == 0)
				{
					TextDrawShowForPlayer(i,Loading[0]);
					TextDrawShowForPlayer(i,Loading[1]);
					TextDrawHideForPlayer(i,BusinessInfo[id][LoadingProgress]);
				}
                pTemp[i][tPlayerStartRob] = id;
            }
            else  if (pTemp[i][tPlayerStartRob] != 0)
            {
                TextDrawHideForPlayer(i,Loading[0]);
                TextDrawHideForPlayer(i,Loading[1]);
                TextDrawHideForPlayer(i,BusinessInfo[id][LoadingProgress]);
                pTemp[i][tPlayerStartRob] = 0;
            }
        }

        if(players < MIN_BIZROB_PLAYERS)
        {
            foreach(new i : PlayerTeam[member])
            {
                if (pTemp[i][tPlayerStartRob] != 0)
                {
                    TextDrawHideForPlayer(i,Loading[0]);
                    TextDrawHideForPlayer(i,Loading[1]);
                    TextDrawHideForPlayer(i,BusinessInfo[id][LoadingProgress]);
                    pTemp[i][tPlayerStartRob] = 0;
                }
            }
			ApplyActorAnimation(BusinessInfo[id][bActorID], "INT_HOUSE", "wash_up",4.1,0,0,0,1,0);   
            SendFamilyMessage(member, CGRAY2,!"Думаете я Вас испугалась? Валите от сюда негодники я вызвала полицию!");
            KillTimer(BusinessInfo[id][bRobTimer]);
        }
    }
}
stock GetBussinessTypeName(id) {
	new type = BusinessInfo[id][bType];
	return BusinessTypeInfo[type][bTypeName];
}

/*stock TogglePlayerSettings(playerid, setting_id) {
	if (!IsPlayerConnected(playerid))
		return;
	switch (setting_id) 
    {
		case setToggleIconHouse: 
        {
			if (IsPlayerGetSettings(playerid, setToggleIconHouse)) {
				for(new h = 1; h <= TOTALHOUSE; h++) {
					Streamer_ToggleItem(playerid, STREAMER_TYPE_MAP_ICON, HouseInfo[h][hMIcon], true);
				}
			} 
            else {
				for(new h = 1; h <= TOTALHOUSE; h++) {
					Streamer_ToggleItem(playerid, STREAMER_TYPE_MAP_ICON, HouseInfo[h][hMIcon], false);
				}
			} 
			Streamer_Update(playerid, STREAMER_TYPE_MAP_ICON);
		}
	}	
}
stock OnHouseIconUpdate(houseid) {
	foreach(new i: PlayerInLogin)
	{
		if (!pInfo[i][pLogin] || AntiCheatIsKickedWithDesync(i)) continue;
		if (IsPlayerGetSettings(i, setToggleIconHouse) ) continue;  
		Streamer_ToggleItem(i, STREAMER_TYPE_MAP_ICON, HouseInfo[houseid][hMIcon], false);
	}
}*/