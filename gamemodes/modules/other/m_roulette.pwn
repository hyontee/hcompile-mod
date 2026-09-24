enum
{
	ROU_ITEM_COMMON = 0,
	ROU_ITEM_RARE,
	ROU_ITEM_EPIC,
	ROU_ITEM_LEGENDARY
} ;

enum
{
	ROULETTE_NO_RENDER = -1,
	ROULETTE_RENDER_OBJECT = 0,
	ROULETTE_RENDER_CAR = 1,
	ROULETTE_RENDER_SKIN = 2
} ;

enum _rou_item
{
	rou_type,
	rou_rare,
	rou_model,
	rou_name [ 24 ],
	Float: rou_rotX,
	Float: rou_rotY,
	Float: rou_rotZ,
	Float: rou_angle
} ;

#define MAX_BRONZE_PRISE 42
new rou_item_bronze [ MAX_BRONZE_PRISE ] [ _rou_item ] =
{
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1212, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 1274, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 },
	
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 19319, "Аксессуар", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 19318, "Аксессуар", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 19317, "Аксессуар", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 19142, "Аксессуар", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 19142, "Аксессуар", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 19079, "Аксессуар", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 18637, "Аксессуар", 20.0, 180.0, 45.0, 0.78 },

	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 83, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 86, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 107, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 164, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 294, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 68, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 104, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 32, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 35, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 43, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 302, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 304, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 404, "Mitsubishi Lancer 9", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 436, "Volkswagen Golf", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 438, "VAZ 2114", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 439, "Kia Stinger", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 445, "Mercedes-Benz CLS63", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 451, "Porsche 911", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 458, "BMW X5M", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3237, "Nissan Skyline R33", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3246, "Bentley Bentayga", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3244, "Nissan Titan", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3249, "Kia Rio", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3253, "Jaguar XE", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3257, "Infiniti Q60s", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 3259, "Toyota Supra", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 3260, "Toyota Supra GR", 20.0, 180.0, 45.0, 0.78 }
} ;

#define MAX_SILVER_PRISE 58
new rou_item_silver [ MAX_SILVER_PRISE ] [ _rou_item ] =
{
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1212, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 1274, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 },
	
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12670, "Маска лягушки", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12671, "Маска помидор", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12672, "Маска коня", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12666, "Маска зомби", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12655, "Маска Steve", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12658, "Маска ламы", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12661, "Маска свинки", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 11761, "Anonymus", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 11763, "Hello-Kitty (блест.)", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 11764, "Kaneki", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 8201, "Дрон сборщик", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 8202, "Красный дрон", 20.0, 180.0, 45.0, 0.78 },

	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 83, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 86, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 107, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 164, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 294, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 68, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 104, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 32, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 35, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 43, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 302, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 304, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 84, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 105, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 106, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 109, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 110, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 64, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 33, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 45, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 47, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 77, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 4729, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 404, "Mitsubishi Lancer 9", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 436, "Volkswagen Golf", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 438, "VAZ 2114", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 439, "Kia Stinger", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 445, "Mercedes-Benz CLS63", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 451, "Porsche 911", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 458, "BMW X5M", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3276, "Chrysler 300C", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3247, "McLaren600", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3248, "Mercedes-Benz AMG GTR", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3242, "Renault Megan", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3233, "Dodge Challenger SRT", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3234, "Chevrolet Camaro", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 579, "Lamborghini Urus", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 603, "BMW M8", 20.0, 180.0, 45.0, 0.78 }
} ;

#define MAX_GOLD_PRISE 68
new rou_item_gold [ MAX_GOLD_PRISE ] [ _rou_item ] =
{
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1212, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 1274, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 },
	
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12670, "Маска лягушки", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12671, "Маска помидор", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12672, "Маска коня", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12666, "Маска зомби", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12655, "Маска Steve", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12658, "Маска ламы", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 12661, "Маска свинки", 20.0, 180.0, 45.0, 0.78 },
	
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 8327, "Воздушный Шар #15", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 8328, "DJ Mask", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 8329, "Case #1", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 8330, "Case #2", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 8204, "Зелёная сфера", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 8205, "Голубая сфера", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 8206, "Красная сфера", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_LEGENDARY, 8207, "Белая сфера", 20.0, 180.0, 45.0, 0.78 },

	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 83, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 86, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 107, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 164, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 294, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 68, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 104, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 32, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 35, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 43, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 302, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_COMMON, 304, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 84, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 105, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 106, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 109, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 110, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 64, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 33, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 45, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 47, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 77, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 178, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 180, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 300, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_EPIC, 303, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 269, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 293, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 4720, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_LEGENDARY, 4721, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 404, "Mitsubishi Lancer 9", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 436, "Volkswagen Golf", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 438, "VAZ 2114", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 439, "Kia Stinger", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 445, "Mercedes-Benz CLS63", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 451, "Porsche 911", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_COMMON, 458, "BMW X5M", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3276, "Chrysler 300C", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3280, "Mercedes Benz S65", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_RARE, 3283, "Audi A8", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3290, "Dodge Viper", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3300, "FERRARI 488", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_EPIC, 3303, "Kia K5", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 3374, "Aurus Senat", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 3375, "Lexus RC", 20.0, 180.0, 45.0, 0.78 }
} ;

#define MAX_TRUCKER_ITEM 15
new rou_trucker_item [ MAX_TRUCKER_ITEM ] [ _rou_item ] =
{
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1212, "Деньги", -25.0000, 0.0000, 35.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_RARE, 1274, ""donate_title"", 0.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1582, "Сытость", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 348, "Навыки оружия", -10.0000, 0.0000, 0.0000, 1.2999 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2684, "Лицензии", 0.0000, 0.0000, -30.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 11738, "Аптечки", -15.0000, 0.0000, 180.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 1575, "Материалы", -30.0000, 0.0000, 45.0000, 1.0000 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_COMMON, 2061, "Боеприпасы", -30.0000, 0.0000, -30.0000, 1.0000 },
	
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 5030, "Шлем PUBG #1", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 5036, "Custom Броня #1", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_OBJECT, ROU_ITEM_EPIC, 5037, "Custom Броня #2", 20.0, 180.0, 45.0, 0.78 },

	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 4561, "Одежда", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_SKIN, ROU_ITEM_RARE, 4562, "Одежда", 20.0, 180.0, 45.0, 0.78 },

	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 403, "MAZ 5440", 20.0, 180.0, 45.0, 0.78 },
	{ ROULETTE_RENDER_CAR, ROU_ITEM_LEGENDARY, 514, "DAF XT", 20.0, 180.0, 45.0, 0.78 }
} ;

#define MAX_INCASS_ITEM 15
#define MAX_COURIER_ITEM 15
#define MAX_ZAVOD_ITEM 15
#define MAX_DELIVERY_ITEM 15
#define MAX_SAWMILL_ITEM 15
#define MAX_MINER_ITEM 15

#include <custom/roulettes>

CMD:testr ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	SetRouletteJobPage ( playerid, 0, true, MAX_BRONZE_PRISE ) ;
	SetRouletteJobItem ( playerid, 0 ) ;

	set_player_use_listitem ( playerid, 0 ) ;
	return 1 ;
}

stock show_packet_player_roulette ( playerid, _param1, _param2, _param3 )
{
	if ( _param1 == 0 )
	{
		SetCRouletteHide ( playerid ) ;
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	else if ( _param1 == 1 )
	{
		if ( _param2 == 0 ) SetCRoulettePage ( playerid, _param2, ( get_player_item_prise ( playerid, 45 ) > 0 ) ? ( true ) : ( false ), MAX_BRONZE_PRISE ) ;
		else if ( _param2 == 1 ) SetCRoulettePage ( playerid, _param2, ( get_player_item_prise ( playerid, 55 ) > 0 ) ? ( true ) : ( false ), MAX_SILVER_PRISE ) ;
		else if ( _param2 == 2 ) SetCRoulettePage ( playerid, _param2, ( get_player_item_prise ( playerid, 125 ) > 0 ) ? ( true ) : ( false ), MAX_GOLD_PRISE ) ;
		SetCRouletteItem ( playerid, _param2 ) ;
		
		new _str [ 24 ], _str2 [ 24 ], _str3 [ 24 ] ;
		format ( _str, sizeof _str, "Бронзовая: %d шт.", get_player_item_prise ( playerid, 45 ) ) ;
		format ( _str2, sizeof _str2, "Серебряная: %d шт.", get_player_item_prise ( playerid, 55 ) ) ;
		format ( _str3, sizeof _str3, "Золотая: %d шт.", get_player_item_prise ( playerid, 125 ) ) ;
		SetCRouletteUpdate ( playerid, _param2, _str, _str2, _str3 ) ;
		
		set_player_use_listitem ( playerid, _param2 ) ;
	}
	else if ( _param1 == 6 )
	{
		if ( _param2 == 1 )
		{
			new _rou_id = get_player_use_listitem ( playerid ) ;
			switch ( _rou_id )
			{
			    case 0:
			    {
					if ( get_player_item_prise ( playerid, 45 ) < 1 ) return 1 ;
					clear_player_item_prise ( playerid, 45, 1 ) ;
			
					new _str [ 24 ], _str2 [ 24 ], _str3 [ 24 ] ;
					format ( _str, sizeof _str, "Бронзовая: %d шт.", get_player_item_prise ( playerid, 45 ) ) ;
					format ( _str2, sizeof _str2, "Серебряная: %d шт.", get_player_item_prise ( playerid, 55 ) ) ;
					format ( _str3, sizeof _str3, "Золотая: %d шт.", get_player_item_prise ( playerid, 125 ) ) ;
					SetCRouletteUpdate ( playerid, 0, _str, _str2, _str3 ) ;
						
					SetPlayerRoulettePrise ( playerid, 0 ) ;
				}
			    case 1:
			    {
					if ( get_player_item_prise ( playerid, 55 ) < 1 ) return 1 ;
					clear_player_item_prise ( playerid, 55, 1 ) ;
			
					new _str [ 24 ], _str2 [ 24 ], _str3 [ 24 ] ;
					format ( _str, sizeof _str, "Бронзовая: %d шт.", get_player_item_prise ( playerid, 45 ) ) ;
					format ( _str2, sizeof _str2, "Серебряная: %d шт.", get_player_item_prise ( playerid, 55 ) ) ;
					format ( _str3, sizeof _str3, "Золотая: %d шт.", get_player_item_prise ( playerid, 125 ) ) ;
					SetCRouletteUpdate ( playerid, 1, _str, _str2, _str3 ) ;
						
					SetPlayerRoulettePrise ( playerid, 1 ) ;
			    }
			    case 2:
			    {
					if ( get_player_item_prise ( playerid, 125 ) < 1 ) return 1 ;
					clear_player_item_prise ( playerid, 125, 1 ) ;
			
					new _str [ 24 ], _str2 [ 24 ], _str3 [ 24 ] ;
					format ( _str, sizeof _str, "Бронзовая: %d шт.", get_player_item_prise ( playerid, 45 ) ) ;
					format ( _str2, sizeof _str2, "Серебряная: %d шт.", get_player_item_prise ( playerid, 55 ) ) ;
					format ( _str3, sizeof _str3, "Золотая: %d шт.", get_player_item_prise ( playerid, 125 ) ) ;
					SetCRouletteUpdate ( playerid, 2, _str, _str2, _str3 ) ;
						
					SetPlayerRoulettePrise ( playerid, 2 ) ;
			    }
			}
		}
		else if ( _param2 == 2 && _param3 == 0 )
		{
			_param2 = get_player_use_listitem ( playerid ) ;

			new _str [ 24 ], _str2 [ 24 ], _str3 [ 24 ] ;
			format ( _str, sizeof _str, "Бронзовая: %d шт.", get_player_item_prise ( playerid, 45 ) ) ;
			format ( _str2, sizeof _str2, "Серебряная: %d шт.", get_player_item_prise ( playerid, 55 ) ) ;
			format ( _str3, sizeof _str3, "Золотая: %d шт.", get_player_item_prise ( playerid, 125 ) ) ;
			SetCRouletteUpdate ( playerid, _param2, _str, _str2, _str3 ) ;
		}
	}
	
	else if ( _param1 == 10 )
	{
		SetRouletteJobHide ( playerid ) ;
		
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		TogglePlayerHudElement ( playerid, HUD_ELEMENT_TEXTLABELS, true ) ;
	}
	else if ( _param1 == 16 )
	{
		if ( _param2 == 1 )
		{
			new _rou_id = get_player_use_listitem ( playerid ) ;
			
			if ( get_player_item_prise ( playerid, _rou_id ) < 1 ) return 1 ;
			clear_player_item_prise ( playerid, _rou_id, 1 ) ;
			
			if ( _rou_id == 138 ) SetJobRoulettePrise ( playerid, 1 ) ;
			else if ( _rou_id == 139 ) SetJobRoulettePrise ( playerid, 2 ) ;
			else if ( _rou_id == 140 ) SetJobRoulettePrise ( playerid, 3 ) ;
			else if ( _rou_id == 141 ) SetJobRoulettePrise ( playerid, 4 ) ;
			else if ( _rou_id == 142 ) SetJobRoulettePrise ( playerid, 5 ) ;
			else if ( _rou_id == 143 ) SetJobRoulettePrise ( playerid, 6 ) ;
			else if ( _rou_id == 144 ) SetJobRoulettePrise ( playerid, 7 ) ;
			
			give_global_quest ( playerid, 0, 1 ) ;
		}
	}
	return 1 ;
}

stock SetPlayerRoulettePrise ( playerid, _roulette_id )
{
	new time = GetTickCount ( ) ;
	printf ( "[SetPlayerRoulettePrise] started..." ) ;
	
	new _prise_id = -1, _render, donate_count = random ( 50000 ), random_item, _count = 0 ;
	if ( donate_count >= 0 && donate_count <= 30000 )random_item = 0 ;
	else if ( donate_count >= 30001 && donate_count <= 42000 )random_item = 1 ;
	else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
	else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
		
	_retry_player_roulette:
	if ( random_item == 0 )
	{
		if ( _roulette_id == 0 )
		{
			for ( new i = 0 ; i < MAX_BRONZE_PRISE ; i ++ )
			{
				if ( rou_item_bronze [ i ] [ rou_rare ] != BP_ITEM_COMMON ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = rou_item_bronze [ i ] [ rou_model ] ;
					_render = rou_item_bronze [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_bronze [ 0 ] [ rou_model ] ;
				_render = rou_item_bronze [ 0 ] [ rou_type ] ;
			}
		}
		else if ( _roulette_id == 1 )
		{
			for ( new i = 0 ; i < MAX_SILVER_PRISE ; i ++ )
			{
				if ( rou_item_silver [ i ] [ rou_rare ] != BP_ITEM_COMMON ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = rou_item_silver [ i ] [ rou_model ] ;
					_render = rou_item_silver [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_silver [ 0 ] [ rou_model ] ;
				_render = rou_item_silver [ 0 ] [ rou_type ] ;
			}
		}
		else if ( _roulette_id == 2 )
		{
			for ( new i = 0 ; i < MAX_GOLD_PRISE ; i ++ )
			{
				if ( rou_item_gold [ i ] [ rou_rare ] != BP_ITEM_COMMON ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = rou_item_gold [ i ] [ rou_model ] ;
					_render = rou_item_gold [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_gold [ 0 ] [ rou_model ] ;
				_render = rou_item_gold [ 0 ] [ rou_type ] ;
			}
		}
				
		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_roulette;
		}
	}
	else if ( random_item == 1 )
	{
		if ( _roulette_id == 0 )
		{
			for ( new i = 0 ; i < MAX_BRONZE_PRISE ; i ++ )
			{
				if ( rou_item_bronze [ i ] [ rou_rare ] != BP_ITEM_RARE ) continue ;
			
				if ( random ( 4 ) == 1 )
				{
					_prise_id = rou_item_bronze [ i ] [ rou_model ] ;
					_render = rou_item_bronze [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_bronze [ 0 ] [ rou_model ] ;
				_render = rou_item_bronze [ 0 ] [ rou_type ] ;
			}
		}
		else if ( _roulette_id == 1 )
		{
			for ( new i = 0 ; i < MAX_SILVER_PRISE ; i ++ )
			{
				if ( rou_item_silver [ i ] [ rou_rare ] != BP_ITEM_RARE ) continue ;
			
				if ( random ( 4 ) == 1 )
				{
					_prise_id = rou_item_silver [ i ] [ rou_model ] ;
					_render = rou_item_silver [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_silver [ 0 ] [ rou_model ] ;
				_render = rou_item_silver [ 0 ] [ rou_type ] ;
			}
		}
		else if ( _roulette_id == 2 )
		{
			for ( new i = 0 ; i < MAX_GOLD_PRISE ; i ++ )
			{
				if ( rou_item_gold [ i ] [ rou_rare ] != BP_ITEM_RARE ) continue ;
			
				if ( random ( 4 ) == 1 )
				{
					_prise_id = rou_item_gold [ i ] [ rou_model ] ;
					_render = rou_item_gold [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_gold [ 0 ] [ rou_model ] ;
				_render = rou_item_gold [ 0 ] [ rou_type ] ;
			}
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_roulette;
		}
	}
	else if ( random_item == 2 )
	{
		if ( _roulette_id == 0 )
		{
			for ( new i = 0 ; i < MAX_BRONZE_PRISE ; i ++ )
			{
				if ( rou_item_bronze [ i ] [ rou_rare ] != BP_ITEM_EPIC ) continue ;
			
				if ( random ( 3 ) == 1 )
				{
					_prise_id = rou_item_bronze [ i ] [ rou_model ] ;
					_render = rou_item_bronze [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_bronze [ 0 ] [ rou_model ] ;
				_render = rou_item_bronze [ 0 ] [ rou_type ] ;
			}
		}
		else if ( _roulette_id == 1 )
		{
			for ( new i = 0 ; i < MAX_SILVER_PRISE ; i ++ )
			{
				if ( rou_item_silver [ i ] [ rou_rare ] != BP_ITEM_EPIC ) continue ;
			
				if ( random ( 3 ) == 1 )
				{
					_prise_id = rou_item_silver [ i ] [ rou_model ] ;
					_render = rou_item_silver [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_silver [ 0 ] [ rou_model ] ;
				_render = rou_item_silver [ 0 ] [ rou_type ] ;
			}
		}
		else if ( _roulette_id == 2 )
		{
			for ( new i = 0 ; i < MAX_GOLD_PRISE ; i ++ )
			{
				if ( rou_item_gold [ i ] [ rou_rare ] != BP_ITEM_EPIC ) continue ;
			
				if ( random ( 3 ) == 1 )
				{
					_prise_id = rou_item_gold [ i ] [ rou_model ] ;
					_render = rou_item_gold [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_gold [ 0 ] [ rou_model ] ;
				_render = rou_item_gold [ 0 ] [ rou_type ] ;
			}
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_roulette;
		}
	}
	else if ( random_item == 3 )
	{
		if ( _roulette_id == 0 )
		{
			for ( new i = 0 ; i < MAX_BRONZE_PRISE ; i ++ )
			{
				if ( rou_item_bronze [ i ] [ rou_rare ] != BP_ITEM_LEGENDARY ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = rou_item_bronze [ i ] [ rou_model ] ;
					_render = rou_item_bronze [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_bronze [ 0 ] [ rou_model ] ;
				_render = rou_item_bronze [ 0 ] [ rou_type ] ;
			}
		}
		else if ( _roulette_id == 1 )
		{
			for ( new i = 0 ; i < MAX_SILVER_PRISE ; i ++ )
			{
				if ( rou_item_silver [ i ] [ rou_rare ] != BP_ITEM_LEGENDARY ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = rou_item_silver [ i ] [ rou_model ] ;
					_render = rou_item_silver [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_silver [ 0 ] [ rou_model ] ;
				_render = rou_item_silver [ 0 ] [ rou_type ] ;
			}
		}
		else if ( _roulette_id == 2 )
		{
			for ( new i = 0 ; i < MAX_GOLD_PRISE ; i ++ )
			{
				if ( rou_item_gold [ i ] [ rou_rare ] != BP_ITEM_LEGENDARY ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = rou_item_gold [ i ] [ rou_model ] ;
					_render = rou_item_gold [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_item_gold [ 0 ] [ rou_model ] ;
				_render = rou_item_gold [ 0 ] [ rou_type ] ;
			}
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_roulette;
		}
	}

	new _str_name [ 32 ] ;
	if ( _prise_id == 1212 )
	{
		new money_count = 0 ;
		switch ( random ( 5 ) )
		{
			case 0,1,3,4: money_count = RandomEx ( 4, 9 ) ;
			case 2: money_count = RandomEx ( 50, 55 ) ;
		}
		format ( _str_name, sizeof _str_name, "%s", item_name ( money_count ) ) ;
		give_player_item_prise ( playerid, money_count, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 1274 )
	{
		new money_count = RandomEx ( 15, 23 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( money_count ) ) ;
		give_player_item_prise ( playerid, money_count, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 1582 )
	{
		new result_random = RandomEx ( 40, 44 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( result_random ) ) ;
		give_player_item_prise ( playerid, result_random, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 348 )
	{
		new prize_type ;
		if ( random ( 15 ) == 1 ) prize_type = 36 ;
		else prize_type = RandomEx ( 88, 94 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( prize_type ) ) ;
		give_player_item_prise ( playerid, prize_type, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 2684 )
	{
	    new prize_type ;
		if ( random ( 15 ) == 1 ) prize_type = 35 ;
		else prize_type = RandomEx ( 84, 87 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( prize_type ) ) ;
		give_player_item_prise ( playerid, prize_type, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 11738 )
	{
		new aidkit_count = RandomEx ( 1, 3 ) ;
		give_player_item_prise ( playerid, 145, aidkit_count ) ;
		format ( _str_name, sizeof _str_name, "Аптечка (%d шт.)", aidkit_count ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/healme\"{"#cGRInfo"}, чтобы полечиться." ) ;
	}
	else if ( _prise_id == 1575 )
	{
		new drugs_count = RandomEx ( 5, 100 ) ;
		give_player_item_prise ( playerid, 153, drugs_count ) ;
		give_player_item_prise ( playerid, 154, drugs_count ) ;
		format ( _str_name, sizeof _str_name, "Боеприпасы (%d шт.)", drugs_count ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/makegun\"{"#cGRInfo"}, чтобы собрать оружие." ) ;
	}
	else if ( _prise_id == 2061 )
	{
		new drugs_count = RandomEx ( 5, 100 ) ;
		give_player_item_prise ( playerid, 153, drugs_count ) ;
		give_player_item_prise ( playerid, 153, drugs_count ) ;
		format ( _str_name, sizeof _str_name, "Боеприпасы (%d шт.)", drugs_count ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/makegun\"{"#cGRInfo"}, чтобы собрать оружие." ) ;
	}
	else
	{
		if ( _render == ROULETTE_RENDER_OBJECT )
		{
			format ( _str_name, sizeof _str_name, "%s", get_accessorie_name ( _prise_id ) ) ;
			give_player_item ( playerid, _prise_id ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
		else if ( _render == ROULETTE_RENDER_SKIN )
		{
			format ( _str_name, sizeof _str_name, "%s", get_skin_name ( _prise_id ) ) ;
			give_player_item_prise ( playerid, _prise_id + skin_cross, 1 ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
		else if ( _render == ROULETTE_RENDER_CAR )
		{
			format ( _str_name, sizeof _str_name, "%s", GetVehicleNameEx ( -1, _prise_id ) ) ;
			give_player_item_prise ( playerid, _prise_id, 1 ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
	}
		
	new scm_string [ 110 ] ;
	format ( scm_string, sizeof scm_string, "%s (PLAYER CASE #%d) %s", p_info [ playerid ] [ name ], _roulette_id, _str_name ) ;
	WriteLog ( playerid, TYPE_LOG_PLAYER_CASE, scm_string ) ;

	SetCRoulette ( playerid, _render, _prise_id, _str_name ) ;
		
	printf ( "[SetPlayerRoulettePrise] end. (%d ms)", GetTickCount ( ) - time ) ;
	return 1 ;
}

stock SetJobRoulettePrise ( playerid, _roulette_id )
{
	new time = GetTickCount ( ) ;
	printf ( "[SetJobRoulettePrise] started..." ) ;
	
	new _prise_id = -1, _render, donate_count = random ( 50000 ), random_item, _count = 0 ;
	if ( donate_count >= 0 && donate_count <= 30000 )random_item = 0 ;
	else if ( donate_count >= 30001 && donate_count <= 42000 )random_item = 1 ;
	else if ( donate_count >= 42001 && donate_count <= 46000 )random_item = 2 ;
	else if ( donate_count >= 46001 && donate_count <= 50000 )random_item = 3 ;
		
	_retry_player_roulette:
	if ( random_item == 0 )
	{
		if ( _roulette_id == 1 )
		{
			for ( new i = 0 ; i < MAX_TRUCKER_ITEM ; i ++ )
			{
				if ( rou_trucker_item [ i ] [ rou_rare ] != BP_ITEM_COMMON ) continue ;
			
				if ( random ( 5 ) == 1 )
				{
					_prise_id = rou_trucker_item [ i ] [ rou_model ] ;
					_render = rou_trucker_item [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_trucker_item [ 0 ] [ rou_model ] ;
				_render = rou_trucker_item [ 0 ] [ rou_type ] ;
			}
		}
				
		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_roulette;
		}
	}
	else if ( random_item == 1 )
	{
		if ( _roulette_id == 1 )
		{
			for ( new i = 0 ; i < MAX_TRUCKER_ITEM ; i ++ )
			{
				if ( rou_trucker_item [ i ] [ rou_rare ] != BP_ITEM_RARE ) continue ;
			
				if ( random ( 4 ) == 1 )
				{
					_prise_id = rou_trucker_item [ i ] [ rou_model ] ;
					_render = rou_trucker_item [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_trucker_item [ 0 ] [ rou_model ] ;
				_render = rou_trucker_item [ 0 ] [ rou_type ] ;
			}
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_roulette;
		}
	}
	else if ( random_item == 2 )
	{
		if ( _roulette_id == 1 )
		{
			for ( new i = 0 ; i < MAX_TRUCKER_ITEM ; i ++ )
			{
				if ( rou_trucker_item [ i ] [ rou_rare ] != BP_ITEM_EPIC ) continue ;
			
				if ( random ( 3 ) == 1 )
				{
					_prise_id = rou_trucker_item [ i ] [ rou_model ] ;
					_render = rou_trucker_item [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_trucker_item [ 0 ] [ rou_model ] ;
				_render = rou_trucker_item [ 0 ] [ rou_type ] ;
			}
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_roulette;
		}
	}
	else if ( random_item == 3 )
	{
		if ( _roulette_id == 1 )
		{
			for ( new i = 0 ; i < MAX_TRUCKER_ITEM ; i ++ )
			{
				if ( rou_trucker_item [ i ] [ rou_rare ] != BP_ITEM_LEGENDARY ) continue ;
			
				if ( random ( 2 ) == 1 )
				{
					_prise_id = rou_trucker_item [ i ] [ rou_model ] ;
					_render = rou_trucker_item [ i ] [ rou_type ] ;
				}
			}
			
			if ( _count >= 10 )
			{
				_prise_id = rou_trucker_item [ 0 ] [ rou_model ] ;
				_render = rou_trucker_item [ 0 ] [ rou_type ] ;
			}
		}

		if ( _prise_id == -1 && _count < 10 )
		{
			_count ++ ;
			goto _retry_player_roulette;
		}
	}

	new _str_name [ 32 ] ;
	if ( _prise_id == 1212 )
	{
		new money_count = 0 ;
		switch ( random ( 5 ) )
		{
			case 0,1,3,4: money_count = RandomEx ( 4, 9 ) ;
			case 2: money_count = RandomEx ( 50, 55 ) ;
		}
		format ( _str_name, sizeof _str_name, "%s", item_name ( money_count ) ) ;
		give_player_item_prise ( playerid, money_count, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 1274 )
	{
		new money_count = RandomEx ( 15, 23 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( money_count ) ) ;
		give_player_item_prise ( playerid, money_count, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 1582 )
	{
		new result_random = RandomEx ( 40, 44 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( result_random ) ) ;
		give_player_item_prise ( playerid, result_random, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 348 )
	{
		new prize_type ;
		if ( random ( 15 ) == 1 ) prize_type = 36 ;
		else prize_type = RandomEx ( 88, 94 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( prize_type ) ) ;
		give_player_item_prise ( playerid, prize_type, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 2684 )
	{
	    new prize_type ;
		if ( random ( 15 ) == 1 ) prize_type = 35 ;
		else prize_type = RandomEx ( 84, 87 ) ;
		format ( _str_name, sizeof _str_name, "%s", item_name ( prize_type ) ) ;
		give_player_item_prise ( playerid, prize_type, 1 ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
	}
	else if ( _prise_id == 11738 )
	{
		new aidkit_count = RandomEx ( 1, 3 ) ;
		give_player_item_prise ( playerid, 145, aidkit_count ) ;
		format ( _str_name, sizeof _str_name, "Аптечка (%d шт.)", aidkit_count ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/healme\"{"#cGRInfo"}, чтобы полечиться." ) ;
	}
	else if ( _prise_id == 1575 )
	{
		new drugs_count = RandomEx ( 5, 100 ) ;
		give_player_item_prise ( playerid, 153, drugs_count ) ;
		give_player_item_prise ( playerid, 154, drugs_count ) ;
		format ( _str_name, sizeof _str_name, "Боеприпасы (%d шт.)", drugs_count ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/makegun\"{"#cGRInfo"}, чтобы собрать оружие." ) ;
	}
	else if ( _prise_id == 2061 )
	{
		new drugs_count = RandomEx ( 5, 100 ) ;
		give_player_item_prise ( playerid, 153, drugs_count ) ;
		give_player_item_prise ( playerid, 154, drugs_count ) ;
		format ( _str_name, sizeof _str_name, "Боеприпасы (%d шт.)", drugs_count ) ;
		
		SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Используйте {"#cBL"}\"/makegun\"{"#cGRInfo"}, чтобы собрать оружие." ) ;
	}
	else
	{
		if ( _render == ROULETTE_RENDER_OBJECT )
		{
			format ( _str_name, sizeof _str_name, "%s", get_accessorie_name ( _prise_id ) ) ;
			give_player_item ( playerid, _prise_id ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
		else if ( _render == ROULETTE_RENDER_SKIN )
		{
			format ( _str_name, sizeof _str_name, "%s", get_skin_name ( _prise_id ) ) ;
			give_player_item_prise ( playerid, _prise_id + skin_cross, 1 ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
		else if ( _render == ROULETTE_RENDER_CAR )
		{
			format ( _str_name, sizeof _str_name, "%s", GetVehicleNameEx ( -1, _prise_id ) ) ;
			give_player_item_prise ( playerid, _prise_id, 1 ) ;
		
			SendClientMessage ( playerid, col_gray, !"{"#cGInfo"}* {"#cGRInfo"}Предмет помещён в инвентарь! Используйте {"#cBL"}\"/mm - Инвентарь - Подарочный инвентарь\"{"#cGRInfo"}." ) ;
		}
	}
		
	new scm_string [ 110 ] ;
	format ( scm_string, sizeof scm_string, "%s (JOB CASE #%d) %s", p_info [ playerid ] [ name ], _roulette_id, _str_name ) ;
	WriteLog ( playerid, TYPE_LOG_PLAYER_CASE, scm_string ) ;

	SetRouletteJob ( playerid, _prise_id, _str_name ) ;
		
	printf ( "[SetJobRoulettePrise] end. (%d ms)", GetTickCount ( ) - time ) ;
	return 1 ;
}