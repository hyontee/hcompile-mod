#if defined _SYSTEM_VEHICLE
	#endinput
#endif
#define _SYSTEM_VEHICLE

// ------------------------------------
#define GetVehicleInfo(%0,%1)		g_vehicle_info[%0][%1]
#define GetVehicleName(%0)			GetVehicleInfo(GetVehicleData(%0, V_MODELID)-400, VI_NAME)

// ------------------------------------
#define GetVehicleData(%0,%1)		g_vehicle_data[%0][%1]
#define SetVehicleData(%0,%1,%2)	g_vehicle_data[%0][%1] = %2
#define ClearVehicleData(%0)		g_vehicle_data[%0] = g_vehicle_default_values
#define IsValidVehicleID(%0)		(1 <= %0 < MAX_VEHICLES)

// ------------------------------------
#define GetVehicleParamEx(%0,%1) g_vehicle_params[%0][%1]

// ------------------------------------
#define VEHICLE_ACTION_TYPE_NONE 	-1
#define VEHICLE_ACTION_ID_NONE 		-1

// ------------------------------------
#define VEHICLE_PARAM_ON	(1)
#define VEHICLE_PARAM_OFF	(0)

// ------------------------------------
native IsValidVehicle(vehicleid);

// ------------------------------------
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
	// -------------
	V_ACTION_TYPE,
	V_ACTION_ID,
	// -------------
	V_DRIVER_ID,
	// -------------
	V_LIMIT,
	V_ALARM,
	Float: V_FUEL,
	Float: V_MILEAGE,
	// -------------
	Text3D: V_LABEL,
	// -------------
	Float: V_HEALTH,
	V_LAST_LOAD_TIME
};

// ------------------------------------
enum E_VEHICLE_PARAMS_STRUCT
{
	V_ENGINE, 	// двигатель
	V_LIGHTS, 	// фары
	V_ALARM,	// сигнализация
	V_LOCK, 	// закрыто ли
	V_BONNET, 	// капот
	V_BOOT, 	// багажник
	V_OBJECTIVE // отображене стрелки над автоqa
};

// ------------------------------------
enum E_VEHICE_INFO_STRUCT
{
	VI_NAME[36],	// название
	VI_PRICE,		// гос. стоимость
	VT_RENT_PRICE,	// стоимость аренды
	VI_TYPE			// тип
};

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
	g_vehicle_info[213][E_VEHICE_INFO_STRUCT] =
{
	{"Porsche Cayenne",	7000000,		8500,	2},		// 400q
	{"ИЖ 2712",				50000,		500,	0},		// 401
	{"Mercedes-Benz E63 AMG",		4100000,		20000,	1},		// 402
	{"ЗИЛ Тягач", 			0, 			0,		0},		// 403
	{"Volvo 940",		165000	,		800,	2},		// 404
	{"Audi RS-6 Avant",	6000000,		8000,	1},		// 405
	{"Mercedes-Benz 300SL", 	3000, 			20000,		0},		// 406
	{"Пожарка", 			0,			0,		0},		// 407
	{"Мусоровоз", 			0,			0,		0},		// 408
	{"Rolls-Royce Phantom",				13000000,	200000,	2},		// 409
	{"Mercedes-Benz C63S",	6000000,		7800,	0},		// 410
	{"MMC Lancer EVO",			620000,		3800,	2},		// 411
	{"Mercedes-Benz W123",			230000,		600,	0},		// 412
	{"BMW I8 Roadster",				11500000,			4000,		0},		// 413
	{"Лиаз 5256", 			0,			0,		0},		// 414
	{"Lamborghini Aventador",				20000000,	15000,	2},		// 415
	{"Скорая", 				0,			0,		0},		// 416
	{"Bugatti Chiron",			30000000,			15000,		0},		// 417
	{"Автобус", 		0,		6400,	0},		// 418
	{"Esperanto",			0,		    0,	    0},		// 419
	{"Такси", 				0,			0,		0},		// 420
	{"Peugeot 406",		220000,		8000,	1},		// 421
	{"Jeep Grand Cherokee",			320000,		1000,	0},		// 422
	{"Cadillac Escalade", 			113000000,			0,		0},		// 423
	{"Jeep Grand Cherokee",					550000,		100,	0},		// 424
	{"Hunter", 				0,			0,		0},		// 425
	{"Rolls-Royce",			0,	38000,	2},		// 426
	{"Enforcer", 			0,			0,		0},		// 427
	{"Инкасатор", 			0,			0,		0},		// 428
	{"Mercedes-Benz Maybach X222", 				13000000,	18000,	0},		// 429
	{"Lexus LX570", 			7800000,			0,		0},		// 430
	{"Лиаз 677", 			0,			0,		0},		// 431
	{"Танк", 				0,			0,		0},		// 432
	{"ЗИЛ 131 Борт", 		0,			0,		0},		// 433
	{"BMW 540 F02",			2900000,		    0,	    0},		// 434
	{"Прицеп", 				0,			0,		0},		// 435
	{"Kia Stinger GT",	5800000,	16500,	1},		// 436
	{"Икарус", 				0,			0,		0},		// 437
	{"Такси", 				0,			0,		0},		// 438
	{"ВАЗ 2101",			100000,		350,	0},		// 439
	{"Гидроцикл", 				0,		0,		0},		// 440
	{"RCcar", 				0,			0,		0},		// 441
	{"BMW M5 F90", 				13000000,		3000,	0},		// 442
	{"Автовоз", 			0,			0,		0},		// 443
	{"Rolls-Royce Cullinan", 				30000000,			0,		0},		// 444
	{"Skoda Octavia RS",			330000,		2400,	0},		// 445
	{"Squalo", 				0,			0,		0},		// 446
	{"Водный верт", 		0,			0,		0},		// 447
	{"BMW R2000RR", 			1400000,			0,		0},		// 448
	{"Цистенра", 			0,			0,		0},		// 449
	{"Прицеп", 				0,			0,		0},		// 450
	{"Ferrari F12",	11000000,	22000,	2},		// 451
	{"Speeder", 			0,			0,		0},		// 452
	{"Reefer", 				0,			0,		0},		// 453
	{"Яхта", 				0,			0,		0},		// 454
	{"Грейдер", 			0,			0,		0},		// 455
	{"ГАЗ 3309", 			0,			0,		0},		// 456
	{"Mercedes-Maybach Pullman", 			25000000,			0,		0},		// 457
	{"Audi A4",			1100000,		2400,	0},		// 458
	{"Mercedes-Benz Vito", 				650000,			0,		0},		// 459
	{"Водн самолет", 		0,			0,		0},		// 460
	{"Honda CB 750",			300000,		700,	0},		// 461
	{"Scooter",			30000,		200,	0},		// 462
	{"Kawasaki Ninja H2R",				3500000,		1200,	1},		// 463
	{"RCplane", 			0,			0,		0},		// 464
	{"RCheli", 				0,			0,		0},		// 465
	{"BMW G30",			6000000,	28000,	2},		// 466
	{"ВАЗ 2107",				115000,		350,	0},		// 467
	{"MotoCross",				30000,		400,	0},		// 468
	{"Sparrow", 			0,			0,		0},		// 469
	{"Тигр", 				3000,			0,		0},		// 470
	{"Снегоход",			0,		1200,	1},		// 471
	{"Coastg", 				0,			0,		0},		// 472
	{"Dinghy",				0,			0,		0},		// 473
	{"Mercedes-Benz C63 AMG W204",				6000000,		600,	0},		// 474
	{"BMW X5",	1300000,	14500,	1},		// 475
	{"Volkswagen Touareg", 		2000000,			0,		0},		// 476
	{"Mazda RX-7",			460000,		9000,	1},		// 477
	{"ИЖ 27151",			50000,		450,	0},		// 478
	{"Renault Logan",			450000,		2400,	0},		// 479
	{"Audi R8",	8000000,	28000,	2},		// 480
	{"BMX",		6000,		100,	0},		// 481
	{"Газель Бизнес", 			225000,		520000,	1},		// 482
	{"ПАЗ 3205", 			0,			0,		0},		// 483
	{"Теплоход", 			0,			0,		0},		// 484
	{"Mercedes-Benz 4x4*2", 			12000000,			0,		0},		// 485
	{"Бульдозер", 			0,			0,		0},		// 486
	{"Robinzon R44", 				20000000,			8000,		0},		// 487
	{"News Верт", 			0,			0,		0},		// 488
	{"Toyota Land Cruiser 200",		7000000,	19000,	2},		// 489
	{"Range Rover Vogue", 	8000000,	59000,	2},		// 490
	{"Honda Civic",		970000,		8000,	1},		// 491
	{"ВАЗ 2109",			190000,		1800,	0},		// 492
	{"Jetmax", 				0,			0,		0},		// 493
	{"Dodge Challenger", 			    4300000,	56000,	0},		// 494
	{"Ford Raptor", 2800000,	15000,	2},		// 495
	{"Opel Ascona",				130000,		700,	0},		// 496
	{"Пол Верт", 			0,			0,		0},		// 497
	{"Tesla Cybertruck", 			3000,			6000,		0},		// 498
	{"ГАЗ 53", 				0,			0,		0},		// 499
	{"UAZ Hunter",			180000,		400,	0},		// 500
	{"RCgobl", 				0,			0,		0}, 	// 501
	{"Rolls-Royce Wraith", 			13500000,	56000,	0}, 	// 502
	{"Nissan GT-R 35", 6800000,	56000,	2}, 	// 503
	{"Lamborghini Urus", 			11500000,			0,		0}, 	// 504
	{"Bentley Bentyaga",	12000000,	42000,	2},		// 505
	{"Porsche 911",		12400000,	29000,	1},		// 506
	{"BMW E34",			530000,		2400,	0}, 	// 507
	{"Ford Raptor",			490000,		1000,	0}, 	// 508
	{"Сноуборд'",	3000,		150,	0}, 	// 509
	{"BTBike",	5000,		300,	0}, 	// 510
	{"Mercedes-Benz C63S AMG", 				12000000,			0,		0}, 	// 511
	{"Mercedes-Benz GT63 AMG", 			13000000,			0,		0}, 	// 512
	{"Lada Vesta", 				700000,			0,		0}, 	// 513
	{"Камаз 54115",			0,			0,		0}, 	// 514
	{"КАЗ", 				0,			0,		0}, 	// 515
	{"Ford Focus 3",			900000,		1800,	1}, 	// 516
	{"РАФ Латвия",			0,		1500,	0}, 	// 517
	{"ЕРАЗ 977",			59300,		1000,	0}, 	// 518
	{"Shamal", 				0,			0,		0}, 	// 519
	{"Истрибитель", 		0,			0,		0}, 	// 520
	{"ИЖ",		40000,		350,	0}, 	// 521
	{"Ducati Desmosed. RR",				2100000,		6000,	2}, 	// 522
	{"Юпитер 5",			0,		    320,	0}, 	// 523
	{"Цементовоз", 			0,			0,		0}, 	// 524
	{"Эвакуатор", 			0,			0,		0}, 	// 525
	{"Ford Sierra",			210000,		1600,	0}, 	// 526
	{"Volkswagen Golf",				175000,		    2400,	0}, 	// 527
	{"Труповоз", 			0,			0,		0},		// 528
	{"Mercedes-Benz 560 SEL",			3000,		2500,	1},		// 529
	{"Погрузщик", 			0,			0,		0}, 	// 530
	{"Трактор", 			0,			0,		0}, 	// 531
	{"Комбайн", 			0,			0,		0}, 	// 532
	{"Porsche Boxster",		3800000,	15000,	2}, 	// 533
	{"BMW E30",			490000,		    4000,	1}, 	// 534
	{"Subaru Impreza WRX",			3000,		4000,	0}, 	// 535
	{"Volvo 240",				210000,		    3500,	1}, 	// 536
	{"Поезд", 				0,			0,		0}, 	// 537
	{"Поезд", 				0,			0,		0}, 	// 538
	{"Возд Подушка", 		0,			0,		0}, 	// 539
	{"Mercedes-Benz E55",			780000,		1800,	0}, 	// 540
	{"Ferrari LaFerrari",		12000000,	42000,	2}, 	// 541
	{"ЛУАЗ 969",			80000,		1300,	0}, 	// 542
	{"Tesla Model S", 				6000000,	        48000,	0}, 	// 543
	{"Пожарка", 			0,			0,		0}, 	// 544
	{"Tesla Model X", 		6000000, 		    2000,	0}, 	// 545
	{"ИЖ 2125 Комби",			90000,		600,	0}, 	// 546
	{"Audi 80",			150000,		600,	0}, 	// 547
	{"Военный Вертолет", 			0, 			0,		0},		// 548
	{"ОКА",				30000,		35,		0},		// 549
	{"ВАЗ 2170",	300000,		1400,	0}, 	// 550
	{"BMW E39",			1300000,		110,	0}, 	// 551
	{"Фургон уборщ", 		0,		    2100,	0}, 	// 552
	{"Кукурузник", 			0,			0,		0}, 	// 553
	{"УАЗ Patriot", 			360000,			0,		0}, 	// 554
	{"ЗАЗ 968М",				25000,		50,		0}, 	// 555
	{"Монстр", 				0,			0,		0}, 	// 556
	{"Mercedes-Benz GLE63 Coupe", 				7100000,			80000,		0}, 	// 557
	{"BMW M4",				4000000,		    4500,	1}, 	// 558
	{"Toyota Supra",		1230000,	16000,	1}, 	// 559
	{"Subaru WRX STI",				1800000,	26500,	1}, 	// 560
	{"ВАЗ 2115",			210000,		600,	0},		// 561
	{"Nissan Skyline",		730000,	25000,	2}, 	// 562
	{"Спас верт", 			0,			0,		0}, 	// 563
	{"RCtank", 				0,			0,		0}, 	// 564
	{"ВАЗ 2108",			145000,		1700,	0}, 	// 565
	{"Daewoo Lanos",			280000,		1000,	0}, 	// 566
	{"ВАЗ 2106",				120000,		2000,	0}, 	// 567
	{"Багги",				3000,		500,	0},		// 568
	{"Вагон", 				0,			0,		0}, 	// 569
	{"Вагон",    			0,			0,		0}, 	// 570
	{"Карт", 				3000,			100,		0}, 	// 571
	{"Toyota Prado", 		 2200000,			0,		0}, 	// 572
	{"Mercedes-Benz G65 6x6", 		18000000,	20000,	0}, 	// 573
	{"Toyota Camry v6", 			570000,			0,		0},		// 574
	{"ГАЗ 20",				3000,		600,	0}, 	// 575
	{"АЗЛК-408",			50000,		600,	0}, 	// 576
	{"AT 400", 				0,			0,		0}, 	// 577
	{"ЗИЛ Борт", 			0,			0,		0}, 	// 578
	{"Mercedes-Benz G65",	5500000,	48000,	0},		// 579
	{"Чайка",				3000,	15000,	0}, 	// 580
	{"Suzuki Hayabusa",				1400000,		700,	0}, 	// 581
	{"Новос Фург",			0,			0,		0}, 	// 582
	{"Tug", 				0,			0,		0}, 	// 583
	{"Цистерна", 			0,			0,		0}, 	// 584
	{"Mercedes-Benz S600",		1800000,		2800,	0}, 	// 585
	{"Harley Fat Boy'",	820000,		400,	0}, 	// 586
	{"Audi Quattro",			2000000,	24000,	0}, 	// 587
	{"Лиаз Кафе", 			0,			0,		0}, 	// 588
	{"Volkswagen Golf",		490000,	12400,	0}, 	// 589
	{"Вагон", 				0,			0,		0}, 	// 590
	{"Прицеп", 				0,			0,		0}, 	// 591
	{"Androm", 	     		0,			0,		0}, 	// 592
	{"Audi S3", 				2100000,			0,		0}, 	// 593
	{"RCcam", 				0,			0,		0}, 	// 594
	{"Fenyr Supersport", 				30000000,			0,		0}, 	// 595
	{"ГАЗ Мил", 			0,			0,		0}, 	// 596
	{"ВАЗ мил", 			0,			0,		0}, 	// 597
	{"ВАЗ мил", 			0,			0,		0}, 	// 598
	{"BMW X5M E70", 			2500000,			0,		0}, 	// 599
	{"ИЖ 2717",			50000,		800,	0}, 	// 600
	{"БДРМ", 				0,			0,		0}, 	// 601
	{"Jaguar F-Type",			4100000,	34000,	0}, 	// 602
	{"Dodge Charger", 		3000,	17000,	0}, 	// 603
	{"Porsche Panamera Turbo", 			84000000,			0,		0}, 	// 604
	{"Lamborghini Huracan", 			14100000,			0,		0},		// 605
	{"Mercedes-Benz W221 S63", 			3200000,			0,		0},		// 606
	{"Ford Mustang GT 5.0", 			5500000,			0,		0},		// 607
	{"Mercedes-Benz G-Class W464", 			10000000,			0,		0},		// 608
	{"Audi Q7", 				5700000,			0,		0},		// 609
	{"BMW X6M E71", 				2600000,			0,		0},		// 610
	{"BMW M5 E60", 		2000000,			0,		0}		// 611
};
// ------------------------------------

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
