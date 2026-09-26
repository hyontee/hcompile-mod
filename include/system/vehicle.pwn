#include <a_samp>
#if defined _SYSTEM_VEHICLE
	#endinput
#endif
#define _SYSTEM_VEHICLE

#define GetVehicleInfo(%0,%1)		g_vehicle_info[%0][%1]
#define GetVehicleName(%0)			GetVehicleInfo(GetVehicleData(%0, V_MODELID)-400, VI_NAME)
#define GetVehicleInfoByModel(%0,%1) g_vehicle_info[((%0) - 400)][%1]

#define GetVehicleData(%0,%1)		g_vehicle_data[%0][%1]
#define SetVehicleData(%0,%1,%2)	g_vehicle_data[%0][%1] = %2
#define ClearVehicleData(%0)		g_vehicle_data[%0] = g_vehicle_default_values
#define IsValidVehicleID(%0)		(1 <= %0 < MAX_VEHICLES)

#define GetVehicleParamEx(%0,%1) g_vehicle_params[%0][%1]

#define VEHICLE_ACTION_TYPE_NONE 	-1
#define VEHICLE_ACTION_ID_NONE 		-1

#define VEHICLE_PARAM_ON	(1)
#define VEHICLE_PARAM_OFF	(0)

native IsValidVehicle(vehicleid);

enum E_VEHICLE_STRUCT
{
	V_MODELID,
	Float: V_SPAWN_X,
	Float: V_SPAWN_Y,
	Float: V_SPAWN_Z,
	Float: V_SPAWN_ANGLE,
	V_COLOR_1,
	V_COLOR_2,
	V_RESPAWN_DELAY,
	V_ADDSIREN,
	V_ACTION_TYPE,
	V_ACTION_ID,
	V_DRIVER_ID,
	V_LIMIT,
	V_ALARM,
	Float: V_FUEL,
	Float: V_MILEAGE,
	Text3D: V_LABEL,
	Float: V_HEALTH,
	V_LAST_LOAD_TIME,
	V_ACTION_OWNER,
};

// ------------------------------------
enum E_VEHICLE_PARAMS_STRUCT
{
	V_ENGINE, 	// двигатель
	V_LIGHTS, 	// фары
	V_ALARM,	// сигнализация
	V_LOCK, 	// двери
	V_BONNET, 	// капот
	V_BOOT, 	// багажник
	V_OBJECTIVE // отображене стрелки
};

// ------------------------------------
enum E_VEHICE_INFO_STRUCT
{
    VI_NAME[64],
    VI_PRICE,
    VT_RENT_PRICE,
    VI_TYPE,
    Float:VI_MAXSP,
    Float:VI_USCOR
}

// ------------------------------------
new g_vehicle_data[MAX_VEHICLES][E_VEHICLE_STRUCT];
new 
	g_vehicle_default_values[E_VEHICLE_STRUCT] = 
{
	0,
	0.0,
	0.0,
	0.0,
	0.0,
	0,
	0,
	0,
	0,
	VEHICLE_ACTION_TYPE_NONE,
	VEHICLE_ACTION_ID_NONE,
	INVALID_PLAYER_ID,
	false,
	false,
	40.0,
	0.0,
	Text3D:-1,
	1000.0,
	0
};
new g_vehicle_params[MAX_VEHICLES][E_VEHICLE_PARAMS_STRUCT];

new const
    g_vehicle_info[][E_VEHICE_INFO_STRUCT] = 
{
    {"BMW X6M F16",              8200000,     8500,   2, 284.00, 4.00},
    {"VAZ 2101",                 60000,       500,    0, 142.00, 22.00},
    {"MERCEDES-BENZ GT63s",      7000000,     6000,   2, 313.00, 3.00},
    {"Renault Premium",          1500000,     0,      0, 150.00, 15.00},
    {"VAZ 2107",                 75000,       800,    0, 158.00, 17.00},
    {"Audi RS6 C7",              10000000,    8000,   1, 310.00, 4.00},
    {"ЗИЛ 131 Самосвал",         0,           0,      0, 0.00, 0.00},
    {"Пожарка",                  0,           0,      0, 0.00, 0.00},
    {"Мусоровоз",                0,           0,      0, 0.00, 0.00},
    {"Лимузин",                  0,           50000,  2, 0.00, 0.00},
    {"MERCEDES-BENZ C63s AMG",   6200000,     7800,   1, 305.00, 4.00},
    {"Aston Martin DB11",        18500000,    3800,   0, 322.00, 4.00},
    {"VAZ 2106",                 83000,       600,    0, 160.00, 17.00},
    {"Gazelle 3221",             1500000,     0,      0, 130.00, 11.00},
    {"Автобус",                  0,           0,      0, 0.00, 0.00},
    {"Lamborghini Aventador S",  20000000,    15000,  2, 351.00, 3.00},
    {"Скорая",                   0,           0,      0, 0.00, 0.00},
    {"Leviathn",                 0,           0,      0, 0.00, 0.00},
    {"Volkswagen Multivan T6",   4000000,     6400,   0, 183.00, 9.00},
    {"Mercedes-Benz E420 W210",  700000,      5000,   1, 250.00, 6.00},
    {"AUDI RS6 C7 рестайлинг",   10000000,    5300,   2, 520.00, 4.00},
    {"Mercedes-Benz S600 W140",  900000,      8000,   2, 250.00, 6.00},
    {"Chevrole. t",              0,           1000,   0, 0.00, 0.00},
    {"MrWhoop",                  0,           0,      0, 0.00, 0.00},
    {"CM3",                      0,           100,    0, 0.00, 0.00},
    {"Hunter",                   0,           0,      0, 0.00, 0.00},
    {"BMW M5 E39",               800000,      38000,  2, 246.00, 5.00},
    {"Инкасатор",                0,           0,      0, 0.00, 0.00},
    {"Инкасатор",                0,           0,      0, 0.00, 0.00},
    {"Mercedes-Benz GT-R",       13500000,    18000,  0, 319.00, 4.00},
    {"Predator",                 0,           0,      0, 0.00, 0.00},
    {"Лиаз 677",                 0,           0,      0, 0.00, 0.00},
    {"Танк",                     0,           0,      0, 0.00, 0.00},
    {"Маты военка",              0,           0,      0, 0.00, 0.00},
    {"Hotknife",                 0,           7000,   1, 0.00, 0.00},
    {"Прицеп",                   0,           0,      0, 0.00, 0.00},
    {"Mitsubishi Lancer Evo X",  2000000,     16500,  1, 239.00, 5.00},
    {"Икарус",                   0,           0,      0, 0.00, 0.00},
    {"Такси",                    0,           0,      0, 0.00, 0.00},
    {"VAZ 2108",                 170000,      350,    0, 160.00, 14.00},
    {"Mercedes-Benz V-Class W447", 6300000,   0,      0, 205.00, 9.00},
    {"RCcar",                    0,           0,      0, 0.00, 0.00},
    {"Volvo V60",                3500000,     100,    0, 235.00, 6.00},
    {"Автовоз",                  0,           0,      0, 0.00, 0.00},
    {"Монстр",                   0,           0,      0, 0.00, 0.00},
    {"Acura TSX",                1150000,     2400,   0, 256.00, 6.00},
    {"Squalo",                   0,           0,      0, 0.00, 0.00},
    {"Водный верт",              0,           0,      0, 0.00, 0.00},
    {"Pizzaboy",                 0,           0,      0, 0.00, 0.00},
    {"Прицеп",                   0,           0,      0, 0.00, 0.00},
    {"краш",                     0,           0,      0, 0.00, 0.00},
    {"McLaren 600LT",            14000000,    22000,  2, 329.00, 3.00},
    {"Speeder",                  0,           0,      0, 0.00, 0.00},
    {"Reefer",                   0,           0,      0, 0.00, 0.00},
    {"Яхта",                     0,           0,      0, 0.00, 0.00},
    {"Грейдер",                  0,           0,      0, 0.00, 0.00},
    {"фсин",                     0,           0,      0, 0.00, 0.00},
    {"Гольф кар",                0,           0,      0, 0.00, 0.00},
    {"VAZ 2114",                 195000,      2400,   0, 160.00, 13.00},
    {"инко",                     0,           0,      0, 0.00, 0.00},
    {"Водн самолет",             0,           0,      0, 0.00, 0.00},
    {"Ducati SuperSport S",      1830000,     700,    0, 240.00, 4.00},
    {"Racer Sport",              20000,       200,    0, 130.00, 10.00},
    {"Ducati XDiavel S",         3000000,     1200,   1, 260.00, 3.00},
    {"RCplane",                  0,           0,      0, 0.00, 0.00},
    {"RCheli",                   0,           0,      0, 0.00, 0.00},
    {"BMW M5 F90",               9500000,     28000,  2, 312.00, 3.00},
    {"Mercedes-Benz S600 W140",  900000,      350,    0, 250.00, 6.00},
    {"Aprilla MXV 450",          90000,       400,    0, 200.00, 4.00},
    {"Sparrow",                  0,           0,      0, 0.00, 0.00},
    {"тигр",                     0,           0,      0, 0.00, 0.00},
    {"Квадроцикл",               0,           1200,   1, 0.00, 0.00},
    {"Coastg",                   0,           0,      0, 0.00, 0.00},
    {"Dinghy",                   0,           0,      0, 0.00, 0.00},
    {"самповкая",                0,           600,    0, 0.00, 0.00},
    {"Audi Q7",                  7000000,     14500,  1, 238.00, 6.00},
    {"Истребитель",              0,           0,      0, 0.00, 0.00},
    {"Mazda RX-7",               1000000,     9000,   2, 249.00, 5.00},
    {"самп",                     0,           450,    0, 0.00, 0.00},
    {"GAZ Volga 2410",           80000,       2400,   0, 170.00, 17.00},
    {"BMW Z4 M40i",              4900000,     28000,  2, 259.00, 5.00},
    {"Велосипед Аист",           0,           100,    0, 0.00, 0.00},
    {"инко",                     0,           520000, 0, 0.00, 0.00},
    {"Mercedes-Benz Sprinter 319CDL", 5000000, 0,    0, 182.00, 10.00},
    {"Теплоход",                 0,           0,      0, 0.00, 0.00},
    {"Газ Аэро",                 0,           0,      0, 0.00, 0.00},
    {"Бульдозер",                0,           0,      0, 0.00, 0.00},
    {"Верт",                     0,           0,      0, 0.00, 0.00},
    {"News Верт",                0,           0,      0, 0.00, 0.00},
    {"Volvo XC90",               4200000,     19000,  1, 248.00, 6.00},
    {"Range Rover SVR",          10000000,    59000,  0, 262.00, 5.00},
    {"VAZ 2110",                 190000,      8000,   1, 160.00, 13.00},
    {"VAZ 2109",                 180000,      1800,   0, 162.00, 14.00},
    {"Jetmax",                   0,           0,      0, 0.00, 0.00},
    {"BMW I8 ROADSTER",          12600000,    6600,   2, 650.00, 4.00},
    {"Ford Raptor F-150",        5757000,     15000,  1, 211.00, 6.00},
    {"Volkswagen Golf GTI2",     140000,      700,    0, 197.00, 8.00},
    {"Пол Верт",                 0,           0,      0, 0.00, 0.00},
    {"Mercedes-Benz Sprinter",   300000,      0,      0, 137.00, 12.00},
    {"ГАЗ 53",                   0,           0,      0, 0.00, 0.00},
    {"ГАЗ 69",                   0,           400,    0, 0.00, 0.00},
    {"RCgobl",                   0,           0,      0, 0.00, 0.00},
    {"Nissan GT-R R35",          7900000,     56000,  0, 319.00, 3.00},
    {"Dodge Demon SRT",          6100000,     56000,  0, 322.00, 3.00},
    {"Bloodra",                  0,           0,      0, 0.00, 0.00},
    {"Cadillac Escalade",        7200000,     42000,  2, 248.00, 6.00},
    {"Porsche 911 Carrera S",    9000000,     29000,  2, 309.00, 4.00},
    {"Audi A4",                  750000,      2400,   0, 238.00, 7.00},
    {"УАЗ Буханка",              0,           1000,   0, 0.00, 0.00},
    {"Велосипед 'Урал'",         0,           150,    0, 0.00, 0.00},
    {"Горный Велосипед",         0,           300,    0, 0.00, 0.00},
    {"Beagle",                   0,           0,      0, 0.00, 0.00},
    {"Cropdast",                 0,           0,      0, 0.00, 0.00},
    {"Stunt",                    0,           0,      0, 0.00, 0.00},
    {"Камаз 54115",              0,           0,      0, 0.00, 0.00},
    {"КАЗ",                      0,           0,      0, 0.00, 0.00},
    {"Volkswagen Polo",          850000,      1800,   0, 238.00, 8.00},
    {"РАФ Латвия",               0,           1500,   0, 0.00, 0.00},
    {"ЕРАЗ 977",                 0,           1000,   0, 0.00, 0.00},
    {"Shamal",                   0,           0,      0, 0.00, 0.00},
    {"Истребитель",              0,           0,      0, 0.00, 0.00},
    {"BMW S 1000 RR",            7000000,     350,    0, 295.00, 3.00},
    {"Kawasaki Ninja H2R",       10000000,    6000,   2, 340.00, 3.00},
    {"Yamaha FZ-10",             4500000,     320,    0, 257.00, 3.00},
    {"Цементовоз",               0,           0,      0, 0.00, 0.00},
    {"Эвакуатор",                0,           0,      0, 0.00, 0.00},
    {"Infiniti Q60S",            3200000,     1600,   0, 266.00, 5.00},
    {"BMW M3 E46",               1050000,     2400,   0, 246.00, 5.00},
    {"Труповоз",                 0,           0,      0, 0.00, 0.00},
    {"VAZ 2172",                 300000,      2500,   0, 183.00, 11.00},
    {"Погрузщик",                0,           0,      0, 0.00, 0.00},
    {"Трактор",                  0,           0,      0, 0.00, 0.00},
    {"Комбайн",                  0,           0,      0, 0.00, 0.00},
    {"Audi R8 V10",              11000000,    15000,  1, 322.00, 3.00},
    {"BMW M3 E30",               300000,      4000,   1, 239.00, 7.00},
    {"Slamvan",                  0,           4000,   1, 0.00, 0.00},
    {"Volvo 242DL",              250000,      3500,   1, 176.00, 11.00},
    {"Поезд",                    0,           0,      0, 0.00, 0.00},
    {"Поезд",                    0,           0,      0, 0.00, 0.00},
    {"Возд Подушка",             0,           0,      0, 0.00, 0.00},
    {"Mazda Sedan 3",            380000,      1800,   0, 218.00, 8.00},
    {"Ferrari 488 GTB",          17500000,    42000,  2, 336.00, 3.00},
    {"Niva Urban",               350000,      1300,   0, 140.00, 17.00},
    {"Chevrolette Camaro ZL1",   4600000,     48000,  0, 315.00, 4.00},
    {"Пожарка",                  0,           0,      0, 0.00, 0.00},
    {"Москвич 400",              0,           100,    0, 0.00, 0.00},
    {"Hyundai Solaris 2021",     830000,      600,    0, 200.00, 9.00},
    {"Toyota Mark II",           420000,      600,    0, 223.00, 9.00},
    {"Воен Верт",                0,           0,      0, 0.00, 0.00},
    {"VAZ 1111",                 30000,       35,     0, 120.00, 24.00},
    {"Toyota Camry 3.5",         2400000,     1400,   0, 247.00, 6.00},
    {"Alfa Romeo Gullia",        3000000,     110,    0, 306.00, 4.00},
    {"Фургон уборщ",             0,           2100,   0, 0.00, 0.00},
    {"Кукурузник",               0,           0,      0, 0.00, 0.00},
    {"УАЗ 3303",                 0,           0,      0, 0.00, 0.00},
    {"ZAZ 968",                  20000,       50,     0, 118.00, 32.00},
    {"Монстр",                   0,           0,      0, 0.00, 0.00},
    {"Монстр",                   0,           0,      0, 0.00, 0.00},
    {"BMW M4 F84",               5500000,     4500,   1, 261.00, 4.00},
    {"то же, что и 547",         0,           16000,  1, 0.00, 0.00},
    {"Subaru WRX STI",           2200000,     26500,  1, 246.00, 6.00},
    {"Москвич 427",              0,           600,    0, 0.00, 0.00},
    {"Nissan Skyline R34",       680000,      25000,  2, 250.00, 5.00},
    {"Спас верт",                0,           0,      0, 0.00, 0.00},
    {"RCtank",                   0,           0,      0, 0.00, 0.00},
    {"Mercedes-Benz A45 AMG",    2800000,     1700,   0, 250.00, 5.00},
    {"ВАЗ 2104",                 0,           1000,   0, 0.00, 0.00},
    {"Savana",                   0,           2000,   0, 0.00, 0.00},
    {"Bandito",                  0,           500,    0, 0.00, 0.00},
    {"Вагон",                    0,           0,      0, 0.00, 0.00},
    {"Вагон",                    0,           0,      0, 0.00, 0.00},
    {"Карт",                     0,           0,      0, 0.00, 0.00},
    {"Газонокосилка",            0,           0,      0, 0.00, 0.00},
    {"Ралли Грузовки",           0,           20000,  0, 0.00, 0.00},
    {"Уборш улиц",               0,           0,      0, 0.00, 0.00},
    {"ГАЗ 20",                   0,           600,    0, 0.00, 0.00},
    {"АЗЛК 408",                 0,           600,    0, 0.00, 0.00},
    {"AT 400",                   0,           0,      0, 0.00, 0.00},
    {"ЗИЛ Борт",                 0,           0,      0, 0.00, 0.00},
    {"Mercedes-Benz G65 AMG",    17050000,    48000,  0, 223.00, 5.00},
    {"ГАЗ 13",                   0,           15000,  0, 0.00, 0.00},
    {"Suzuki GSX-R750",          8000000,     700,    0, 276.00, 3.00},
    {"СМИ Фург",                 0,           0,      0, 0.00, 0.00},
    {"Tug",                      0,           0,      0, 0.00, 0.00},
    {"Цистерна",                 0,           0,      0, 0.00, 0.00},
    {"VAZ 2115",                 210000,      2800,   0, 160.00, 13.00},
    {"Yamaha YZF-R6",            5000000,     400,    0, 260.00, 3.00},
    {"Ford Focus RS",            1800000,     24000,  0, 265.00, 5.00},
    {"Лиаз Кафе",                0,           0,      0, 0.00, 0.00},
    {"Volkswagen Golf GTI",      1400000,     12400,  0, 250.00, 7.00},
    {"Вагон",                    0,           0,      0, 0.00, 0.00},
    {"Прицеп",                   0,           0,      0, 0.00, 0.00},
    {"Androm",                   0,           0,      0, 0.00, 0.00},
    {"Dodo",                     0,           0,      0, 0.00, 0.00},
    {"RCcam",                    0,           0,      0, 0.00, 0.00},
    {"Launch",                   0,           0,      0, 0.00, 0.00},
    {"BMW Мил",                  0,           0,      0, 0.00, 0.00},
    {"PRIORA мил",               0,           0,      0, 0.00, 0.00},
    {"GETTA мил",                0,           0,      0, 0.00, 0.00},
    {"samp мил",                 0,           0,      0, 0.00, 0.00},
    {"АЗЛК 2335",                0,           800,    0, 0.00, 0.00},
    {"БДРМ",                     0,           0,      0, 0.00, 0.00},
    {"Аlpha",                    0,           34000,  0, 0.00, 0.00},
    {"Ford Mustang GT",          2600000,     17000,  0, 277.00, 4.00},
    {"Porsche Panamera S",       8400000,     0,      0, 310.00, 4.00},
    {"Космоа вто",               0,           0,      0, 0.00, 0.00},
    {"Прицеп",                   0,           0,      0, 0.00, 0.00},
    {"Прицеп",                   0,           0,      0, 0.00, 0.00},
    {"Лестница",                 0,           0,      0, 0.00, 0.00},
    {"Авиа",                     0,           0,      0, 0.00, 0.00},
    {"Плуг",                     0,           0,      0, 0.00, 0.00},
    {"Прицеп уборщ",             0,           0,      0, 0.00, 0.00},
    {"AUDI RS6 C8",              14800000,    7700,   2, 760.00, 4.00},
    {"BMW 3-Series G20",         4700000,     2650,   2, 255.00, 4.00},
    {"BMW M5 F10",               5100000,     2850,   2, 275.00, 4.00},
    {"BMW M6 F12",               8700000,     4650,   2, 455.00, 4.00},
    {"BMW X5M G05",              13000000,    6800,   2, 670.00, 4.00},
    {"TOYOTA SUPRA A90",         5900000,     3250,   2, 315.00, 4.00},
    {"CHEVROLET CORVETTE C8",    17000000,    8800,   2, 870.00, 4.00},
    {"DODGE CHARGER SRT",        5000000,     56000,  0, 320.00, 4.00},
    {"TESLA MODEL X",            21000000,    10000,  2, 1070.00, 4.00},
    {"TESLA MODEL S",            15000000,    7800,   2, 770.00, 4.00},
    {"AUDI RS7 SPORT",           9500000,     5050,   2, 495.00, 4.00},
    {"MERCEDES-BENZ E63S",       11500000,    6050,   2, 595.00, 4.00},
    {"TOYOTA LAND CRUISER 200",  7800000,     4200,   2, 410.00, 4.00},
    {"LAMBORGHINI HURACAN",      16500000,    8550,   2, 845.00, 4.00},
    {"MERCEDES-BENZ GLS 400",    9150000,     4875,   2, 478.00, 4.00},
    {"LAMBORDGHINI URUS",        15300000,    7950,   2, 785.00, 4.00},
    {"MERCEDES-BENZ MB S650",    25000000,    10000,  2, 1270.00, 4.00},
    {"CADILLAC ESCALADE",        11500000,    6050,   2, 595.00, 4.00},
    {"Rolls-Royce Phantom",      50000000,    10000,  2, 2520.00, 4.00},
    {"Rolls-Royce Cullinan",     40000000,    10000,  2, 2020.00, 4.00},
    {"BUGATTI LA NOIRE",         1000000000,  10000,  2, 50020.00, 4.00},
    {"BUGATTI DIVO",             380000000,   10000,  2, 19020.00, 4.00},
    {"MERCEDES-BENZ G63 AMG",    23000000,    10000,  2, 1170.00, 4.00},
    {"BMW X7 M50I",              10500000,    5550,   2, 545.00, 4.00},
    {"Lexus LX570",              11455000,    6028,   2, 593.00, 4.00},
    {"BMW M8 F92",               17200000,    8900,   2, 880.00, 4.00},
    {"BMW M8 F93 GRAN COUPE",    19000000,    9800,   2, 970.00, 4.00},
    {"PORSCHE TAYCAN TURBO S",   18300000,    9450,   2, 935.00, 4.00},
    {"Mercedes-Benz CLS63 AMG",  10300000,    5450,   2, 535.00, 4.00},
    {"Rolls-Royce Wraith",       35000000,    10000,  2, 1770.00, 4.00},
    {"MERCEDES-BENZ EQS580",     24000000,    10000,  2, 1220.00, 4.00},
    {"BENTLEY CONTINENTAL GT",   54000000,    10000,  2, 2720.00, 4.00},
    {"AURUS SENAT",              30000000,    10000,  2, 1520.00, 4.00},
    {"BMW M4 G82",               7700000,     10000,  2, 0.00, 0.00},
    {"BMW 7-SERIES 750LI",       14300000,    7450,   2, 735.00, 4.00},
    {"BENTLEY MULLINER BECALAR", 125000000,   10000,  2, 6270.00, 4.00},
    {"BUGATTI CHIRON",           210000000,   10000,  2, 10520.00, 4.00},
    {"CHEVROLET TAHOE RST",      8900000,     4750,   2, 465.00, 4.00},
    {"MERSEDES-BENZ E63 W212",   7500000,     4050,   2, 395.00, 4.00},
    {"BMW M1",                   70000000,    10000,  2, 3520.00, 4.00},
    {"JEEP WRANGLER JL",         5300000,     2950,   2, 285.00, 4.00},
    {"FERRARI 488 PISTA",        26000000,    10000,  2, 1320.00, 4.00},
    {"FORD MUSTANG MATCH E",     5200000,     2900,   2, 280.00, 4.00},
    {"PORSCHE CAYENNE S",        14700000,    7650,   2, 755.00, 4.00},
    {"Bugatti Divo",             380000000,   16500,  1, 239.00, 5.00},
    {"Bugatti La Noire",         1000000000,  0,      0, 0.00, 0.00},
    {"LAIRDAA",                  195000,      2400,   0, 160.00, 13.00}
};

stock SetVehicleDataAll(vehicleid, modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type, action_id)
{
	if(IsValidVehicleID(vehicleid))
	{
		SetVehicleData(vehicleid, V_MODELID, modelid);
		
		SetVehicleData(vehicleid, V_SPAWN_X, 		x);
		SetVehicleData(vehicleid, V_SPAWN_Y, 		y);
		SetVehicleData(vehicleid, V_SPAWN_Z, 		z);
		SetVehicleData(vehicleid, V_SPAWN_ANGLE, 	angle);
		
		SetVehicleData(vehicleid, V_COLOR_1, 	color1);
		SetVehicleData(vehicleid, V_COLOR_2, 	color2);
		
		SetVehicleData(vehicleid, V_RESPAWN_DELAY, 	respawn_delay);
		SetVehicleData(vehicleid, V_ADDSIREN, 		addsiren);
		
		SetVehicleData(vehicleid, V_ACTION_TYPE, 	action_type);
		SetVehicleData(vehicleid, V_ACTION_ID, 		action_id);
		SetVehicleData(vehicleid, V_DRIVER_ID, 		INVALID_PLAYER_ID);
		
		SetVehicleData(vehicleid, V_FUEL, 40.0);
		SetVehicleData(vehicleid, V_MILEAGE, 0.0);
		SetVehicleData(vehicleid, V_LIMIT, true);

		SetVehicleData(vehicleid, V_HEALTH, 1000.0);
	
		SetVehicleParamsEx(vehicleid, IsABike(vehicleid) ? VEHICLE_PARAM_ON : VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF, VEHICLE_PARAM_OFF);
	}
}

stock n_veh_AddStaticVehicleEx(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = AddStaticVehicleEx(modelid, x, y, z, angle, color1, color2, respawn_delay);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, respawn_delay, addsiren, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_AddStaticVehicleEx
    #undef AddStaticVehicleEx
#else
    #define _ALS_AddStaticVehicleEx
#endif
#define AddStaticVehicleEx n_veh_AddStaticVehicleEx

stock n_veh_AddStaticVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = AddStaticVehicle(modelid, x, y, z, angle, color1, color2);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, 0, 0, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_AddStaticVehicle
    #undef AddStaticVehicle
#else
    #define _ALS_AddStaticVehicle
#endif
#define AddStaticVehicle n_veh_AddStaticVehicle

stock n_veh_CreateVehicle(modelid, Float:x, Float:y, Float:z, Float:angle, color1, color2, respawn_delay, addsiren=0, action_type=VEHICLE_ACTION_TYPE_NONE, action_id=VEHICLE_ACTION_ID_NONE)
{
	static n_veh_vehicleid = INVALID_VEHICLE_ID;
	
	n_veh_vehicleid = CreateVehicle(modelid, x, y, z, angle, color1, color2, respawn_delay);
	SetVehicleDataAll(n_veh_vehicleid, modelid, x, y, z, angle, color1, color2, respawn_delay, addsiren, action_type, action_id);

	return n_veh_vehicleid;
	
	// The vehicle ID of the vehicle created (1 - MAX_VEHICLES).
	// INVALID_VEHICLE_ID (65535) if vehicle was not created (vehicle limit reached or invalid vehicle model ID passed).
}
#if defined _ALS_CreateVehicle
    #undef CreateVehicle
#else
    #define _ALS_CreateVehicle
#endif
#define CreateVehicle n_veh_CreateVehicle

stock n_veh_DestroyVehicle(vehicleid)
{
	if(IsValidVehicleID(vehicleid))
	{
		ClearVehicleData(vehicleid);
		DestroyVehicleLabel(vehicleid);
	}
	return DestroyVehicle(vehicleid);
}
#if defined _ALS_DestroyVehicle
    #undef DestroyVehicle
#else
    #define _ALS_DestroyVehicle
#endif
#define DestroyVehicle n_veh_DestroyVehicle

public OnGameModeInit()
{
    for(new idx = 0; idx < MAX_VEHICLES; idx ++)
	{
		ClearVehicleData(idx);
	}
	
#if defined n_veh_OnGameModeInit
    n_veh_OnGameModeInit();
#endif
    return 1;
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit n_veh_OnGameModeInit
#if defined n_veh_OnGameModeInit
forward n_veh_OnGameModeInit();
#endif  

// ---------------------------------------------------
stock SetVehicleParamsInit(vehicleid)
{	
	GetVehicleParamsEx
	(
		vehicleid, 
		g_vehicle_params[vehicleid][V_ENGINE],
		g_vehicle_params[vehicleid][V_LIGHTS],
		g_vehicle_params[vehicleid][V_ALARM],
		g_vehicle_params[vehicleid][V_LOCK],
		g_vehicle_params[vehicleid][V_BONNET],
		g_vehicle_params[vehicleid][V_BOOT],
		g_vehicle_params[vehicleid][V_OBJECTIVE]
	);
}

stock GetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid)
{
	SetVehicleParamsInit(vehicleid);
	return g_vehicle_params[vehicleid][paramid];
}

stock SetVehicleParam(vehicleid, E_VEHICLE_PARAMS_STRUCT:paramid, set_value)
{
	SetVehicleParamsInit(vehicleid);
	g_vehicle_params[vehicleid][paramid] = bool: set_value;
	
	SetVehicleParamsEx
	(
		vehicleid,
		g_vehicle_params[vehicleid][V_ENGINE],
		g_vehicle_params[vehicleid][V_LIGHTS],
		g_vehicle_params[vehicleid][V_ALARM],
		g_vehicle_params[vehicleid][V_LOCK],
		g_vehicle_params[vehicleid][V_BONNET],
		g_vehicle_params[vehicleid][V_BOOT],
		g_vehicle_params[vehicleid][V_OBJECTIVE]
	);
}

stock CreateVehicleLabel(vehicleid, text[], color, Float:x, Float:y, Float:z, Float:drawdistance, testlos = 0, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = STREAMER_3D_TEXT_LABEL_SD)
{
	if(IsValidVehicle(vehicleid))
	{
		SetVehicleData(vehicleid, V_LABEL, CreateDynamic3DTextLabel(text, color, x, y, z, drawdistance, INVALID_PLAYER_ID, vehicleid, testlos, worldid, interiorid, playerid, streamdistance));
	}
	return 1;
}

stock UpdateVehicleLabel(vehicleid, color, text[])
{
	if(IsValidVehicleID(vehicleid))
	{
		if(IsValidDynamic3DTextLabel(GetVehicleData(vehicleid, V_LABEL)))
		{
			UpdateDynamic3DTextLabelText(GetVehicleData(vehicleid, V_LABEL), color, text);
		}
	}
	return 1;
}

stock DestroyVehicleLabel(vehicleid)
{
	if(IsValidVehicleID(vehicleid))
	{
		if(IsValidDynamic3DTextLabel(GetVehicleData(vehicleid, V_LABEL)))
		{
			DestroyDynamic3DTextLabel(GetVehicleData(vehicleid, V_LABEL));
			SetVehicleData(vehicleid, V_LABEL, Text3D: -1);
		}
	}
	return 1;
}
