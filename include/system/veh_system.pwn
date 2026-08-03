/*
    include/system/vveh_embedlist.pwn
    /vveh (админ 3+)

    ВАЖНО: без ALS-хуков, чтобы 100% не конфликтовать с другими системами.
    Нужно добавить ОДНУ строку в твой OnDialogResponse (см. ниже).

    - Список авто ВШИТ в инклуд (файл vehicles.txt не нужен)
    - Клик по машине -> сразу спавнит
    - Клик по "Следующая/Предыдущая" внизу -> листает
    - Лог в админ-чат:
      [A] Администратор Nick заспавнил авто Name.

    Кодировка: Windows-1251
*/

#if defined _INC_VVEH_EMBEDLIST
    #endinput
#endif
#define _INC_VVEH_EMBEDLIST

#include <a_samp>

#if !defined SCM
    #define SCM SendClientMessage
#endif
#if !defined SC
    #define SC "{FFFFFF}"
#endif

#define VVEH_DLG_LIST   (61340)
#define VVEH_PER_PAGE   (25)
#define VVEH_MAX        (482)

static const gVvehIds[VVEH_MAX] = { 400, 401, 402, 403, 404, 405, 406, 407, 408, 409, 410, 411, 412, 413, 414, 415, 416, 417, 418, 419, 420, 421, 422, 423, 424, 425, 426, 427, 428, 429, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 454, 455, 456, 457, 458, 459, 460, 461, 462, 463, 464, 465, 466, 467, 468, 469, 470, 471, 472, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483, 484, 485, 486, 487, 488, 489, 490, 491, 492, 493, 494, 495, 496, 497, 498, 499, 500, 501, 502, 503, 504, 505, 506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 520, 521, 522, 523, 524, 525, 526, 527, 528, 529, 530, 531, 532, 533, 534, 535, 536, 537, 538, 539, 540, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550, 551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 562, 563, 564, 565, 566, 567, 568, 569, 570, 571, 572, 573, 574, 575, 576, 577, 578, 579, 580, 581, 582, 583, 584, 585, 586, 587, 588, 589, 590, 591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606, 607, 608, 609, 610, 611, 2543, 2544, 2545, 2546, 2547, 2548, 2549, 2550, 2551, 2552, 2553, 2554, 2555, 2556, 2557, 2558, 2559, 2560, 2561, 2562, 2563, 2564, 2565, 2566, 2567, 2568, 2569, 2570, 2571, 2572, 2573, 2574, 2575, 2576, 2577, 2578, 2579, 2580, 2581, 2582, 2583, 2584, 2585, 2586, 2587, 2588, 2589, 2590, 2591, 2592, 2593, 2594, 2595, 2596, 2597, 2598, 2599, 2600, 2601, 2602, 2603, 2604, 2605, 2606, 2607, 2608, 2609, 2610, 2611, 2612, 2613, 2614, 2615, 2616, 2617, 2618, 2619, 2620, 2621, 2622, 2623, 2624, 2625, 2626, 2627, 2628, 2629, 2630, 2631, 2632, 2633, 2371, 2372, 2373, 2374, 2375, 2376, 2377, 2378, 2379, 2380, 2381, 2382, 2383, 2384, 2385, 2386, 2387, 2388, 2389, 2390, 2391, 2392, 2393, 2394, 2395, 2396, 2397, 2398, 2399, 2400, 2401, 2402, 2403, 2404, 2405, 2406, 2407, 2408, 2409, 665, 666, 667, 668, 669, 670, 671, 672, 673, 674, 675, 678, 679, 680, 681, 682, 638, 639, 640, 641, 642, 643, 644, 645, 646, 647, 648, 649, 650, 651, 652, 653, 654, 655, 656, 657, 658, 612, 613, 614, 615, 616, 617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632, 633, 634, 635, 636, 659, 660, 661, 739, 740, 741, 742, 743, 744, 745, 746, 747, 637, 748, 749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 2392, 28654, 28655, 28656, 28657, 28658, 28659, 28660, 28661, 28662, 28663, 28667, 28673, 28674, 28675, 28676, 28677, 28678, 28679, 28680, 28681, 28682, 28683, 28669, 28670, 28671, 28672, 28664, 28665, 28666, 28668, 28684, 28685, 28686, 28687, 28688, 28689, 28690, 28691, 28692 };

static const gVvehNames[VVEH_MAX][64] = {
    "BMW X6M F16",
    "VAZ 2101",
    "Mercedes-Benz GT63s",
    "Renault Premium",
    "VAZ 2107",
    "Audi RS6",
    "Zil 131",
    "AMAZING",
    "Musorovoz",
    "Limuzin",
    "Mercedes-Benz C63s AMG",
    "Aston Martin DB11",
    "VAZ 2106",
    "Gazelle 3221",
    "Gaz Vector Next",
    "Lamborghini Aventador S",
    "Mercedes-Benz Sprinter",
    "Leviathn",
    "Volkswagen Multivan T6",
    "Mercedes-Benz E420 W210",
    "Audi RS6 C7 Restayling",
    "Mercedes-Benz W124",
    "UAZ Bukhanka",
    "MrWhoop",
    "CMZ",
    "Hunter",
    "BMW M5 E39",
    "Gazelle 3221",
    "Inkasator",
    "Mercedes-Benz GT-R",
    "Lodka Vikhr",
    "Liaz 677",
    "Tank",
    "KAMAZ 54115",
    "Ford 1933 HotRod",
    "Pritsep",
    "Mitsubishi Lancer Evo X",
    "Ikarus",
    "Gaz 2402 Halloween",
    "VAZ 2108",
    "Mercedes-Benz V-Class W447",
    "RCcar",
    "Volvo V60",
    "Avtovoz",
    "Monstr",
    "Acura TSX",
    "Lodka Okhotnik",
    "Vodnyy vert",
    "Minsk 125",
    "Tsistenra",
    "Pritsep",
    "McLaren 600LT",
    "Marine Yacht",
    "Sea Yacht",
    "Ocean Yacht",
    "Greyder",
    "Gazelle 3310 (Avtozak)",
    "Golf kar",
    "VAZ 2114",
    "Topfun",
    "Vodn samolet",
    "Ducati SuperSport S",
    "Racer Sport",
    "Ducati XDiavel S",
    "RCplane",
    "RCheli",
    "BMW M5 F90",
    "Mercedes-Benz S600 W140",
    "Aprilla MXV 450",
    "Sparrow",
    "Gaz Tigr",
    "Kvadrotsikl",
    "Motornaya lodka",
    "Gidrotsikl",
    "GAZ 21",
    "Audi Q8",
    "Istrebitel",
    "Mazda RX-7",
    "IZh 27151",
    "GAZ Volga 2410",
    "BMW Z4 M40i",
    "Velosiped Aist",
    "Mercedes-Benz V-Class",
    "Mercedes-Benz Sprinter 319CDI",
    "Teplokhod",
    "Gaz Aero",
    "Buldozer",
    "Vertolet",
    "News Vert",
    "Volvo XC90",
    "Range Rover SVR",
    "VAZ 2112",
    "VAZ 2109",
    "Speedy Yacht",
    "BMW I8 Roadster",
    "Ford Raptor F-150",
    "Volkswagen Golf GTI 2",
    "Pol Vert",
    "Mercedes-Benz Sprinter",
    "GAZ 53",
    "GAZ 69",
    "RCgobl",
    "Nissan GT-R R35",
    "Dodge Demon SRT",
    "Bloodra",
    "Cadillac Escalade IV",
    "Porsche 911 Carrera S",
    "Audi A4",
    "UAZ Bukhanka",
    "Velosiped Ural",
    "Gornyy Velosiped",
    "Beagle",
    "Cropdast",
    "Stunt",
    "DAF XF16 Euro 6",
    "Peterbilt Model 579",
    "Volkswagen Polo",
    "RAF Latviya",
    "ERAZ 977",
    "Shamal",
    "Istribitel",
    "BMW S 1000 RR",
    "Kawasaki Ninja H2R",
    "Yamaha FZ-10",
    "Tsementovoz",
    "Evakuator",
    "Infiniti Q60S",
    "BMW M3 E46",
    "Trupovoz",
    "VAZ 2170",
    "Pogruzschik",
    "Traktor",
    "Kombayn",
    "Audi R8 V10",
    "BMW M3 E30",
    "Slamvan",
    "Volvo 242DL",
    "Poezd",
    "Poezd",
    "Vozd Podushka",
    "Mazda Sedan 3",
    "Ferrari 488 GTB",
    "Niva Urban",
    "Chevrolet Camaro ZL1",
    "Pozharka",
    "Daewoo Matiz Sport",
    "Hyundai Solaris 2021",
    "VAZ 2110",
    "Voen Vert",
    "VAZ 1111",
    "Toyota Camry 3.5",
    "Alfa Romeo Guilia",
    "Furgon uborsch",
    "Kukuruznik",
    "UAZ 3303",
    "ZAZ 968",
    "Monstr",
    "Monstr",
    "BMW M4 F84",
    "Toyota Mark II",
    "Subaru WRX STI",
    "Moskvich 427",
    "Nissan Skyline R34",
    "Spas vert",
    "RCtank",
    "Mercedes-Benz A45 AMG",
    "VAZ 2104",
    "Chevrolet Impala 1967",
    "Bandito",
    "Vagon",
    "Vagon",
    "Kart",
    "Gazonokosilka",
    "Puch Pinzgauer 710K",
    "Uborsh ulits",
    "GAZ 20",
    "Marussia B2",
    "AT 400",
    "ZIL Bort",
    "Mercedes-Benz G65 AMG",
    "GAZ 13",
    "Suzuki GSX-R750",
    "Ford Transit",
    "Tug",
    "Tsisterna",
    "VAZ 2115",
    "Yamaha YZF-R6",
    "Ford Focus RS",
    "Liaz Kafe",
    "Volkswagen Golf GTI",
    "Vagon",
    "Pritsep",
    "Androm",
    "Dodo",
    "RCcam",
    "Launch",
    "BMW M5 F90",
    "VAZ 2170",
    "Volkswagen Jetta",
    "UAZ mil",
    "AZLK 2335",
    "BDRM",
    "Brawn GP F1",
    "Ford Mustang GT",
    "Porsche Panamera S",
    "Kosmoa vto",
    "Pritsep",
    "Pritsep",
    "Lestnitsa",
    "Avia",
    "Plug",
    "Pritsep uborsch",
    "Tesla Model X",
    "Tesla Model S",
    "Audi RS7 Sport",
    "Mercedes-Benz E63S",
    "Toyota Land Cruiser 200",
    "Lada Vesta Sedan",
    "Lamborghini Huracan",
    "Mercedes-Benz GLS 400",
    "Lamborghini Urus",
    "Toyota Supra A80",
    "Audi Q7",
    "Jeep Grand Cherokee",
    "Lada Granta",
    "Lada Granta",
    "Lada Vesta SW Cross",
    "Mercedes-Benz MB S650",
    "Cadillac Escalade",
    "UAZ Patriot",
    "UAZ Patriot Pickup",
    "UAZ Patriot",
    "Rolls-Royce Phantom",
    "Rolls-Royce Cullinan",
    "Renault Logan",
    "Kia Rio",
    "BMW M5 E60",
    "BMW X5 E53",
    "Bugatti La Noire",
    "Bugatti Divo",
    "Volkswagen Station Delux",
    "Raesr Tachyon 2019",
    "Mercedes-Benz G63 AMG",
    "BMW X7 M50i",
    "Lexus LX570",
    "Mercury Coupe",
    "Morris Minor",
    "BMW M8 F92",
    "BMW M8 F93 Gran Coupe",
    "BMW 7-Series E38",
    "Porsche Taycan Turbo S",
    "Mercedes-Benz CLS63 AMG",
    "Rolls-Royce Wraith",
    "KIA K5",
    "Mercedes-Benz 300SL Coupe",
    "Jaguar XK120 Roadster",
    "Ford Transit 2020",
    "Ford Focus 3 Sedan",
    "Skoda Rapid 2020",
    "Mercedes-Benz EQS580",
    "Bentley Continental GT",
    "Lotus Exige Halloween",
    "Lamborghini Gallardo",
    "Subaru BRZ",
    "Porsche 911 Singer",
    "Dodge RAM TRX",
    "Aurus Senat",
    "BMW M4 G82",
    "BMW 7-Series 750Li",
    "Bentley Mulliner Bacalar",
    "Bugatti Chiron",
    "Chevrolet Tahoe RST",
    "Mercedes-Benz E63 W212",
    "Volkswagen Passat 2021",
    "Ferrari California T",
    "AC Shelby Cobra",
    "BMW M1",
    "Jeep Wrangler",
    "Mini Cooper",
    "BMW M5 E34",
    "Audi 100 C4",
    "Ford Mustang Hoonigan",
    "Hummer H2 6X6",
    "Ferrari 250GT California",
    "IZh Yupiter 5",
    "UAZ Hunter",
    "Hummer Humvee",
    "BMW M3 E36",
    "Ferrari 488 Pista",
    "Lexus RCF",
    "Xpeng P7",
    "Ford Mustang Mach E",
    "Toyota Camry XV55",
    "Audi A6 C5",
    "Infiniti FX50S",
    "Porsche Cayenne S",
    "Nissan Silvia S15",
    "BRF Outlander 6x6",
    "Ural IMZ 8.103",
    "Moskvich 412 Rally",
    "Subaru WRX STI Rally",
    "Toyota Hilux Dakar",
    "Ford GT Sport",
    "Chevrolet Corvette C6",
    "Mercedes-Benz SLR McLaren",
    "Lamborghini Diablo SV",
    "Ford Mustang Eleanor",
    "Bugatti Type 57SC Atlantic",
    "DarkFire",
    "Lykan HyperSport",
    "UAZ 452 Buhanka",
    "GAZ 3307",
    "Nissan Pathfinder 2022",
    "Opel Vivaro 2022",
    "Niva 4x4 Storm",
    "UAZ 452 Braviy",
    "Vezdekhod Monstr",
    "Nissan Qashqai",
    "Audi RS6 C8",
    "BMW 3-Series G20",
    "BMW M5 F10",
    "BMW M6 F12",
    "BMW X5M E70",
    "BMW X5M G05",
    "Toyota Supra A90",
    "Chevrolet Corvette C8",
    "Dodge Charger SRT",
    "Mitsubishi Lancer Evo 8",
    "Mazda RX-8",
    "Nissan 370Z",
    "Flanker F",
    "Lamborghini Sesto Elemento",
    "Saleen S7",
    "Ferrari F40",
    "Hennessey Venom GT",
    "Mercedes-Benz SLS AMG",
    "Ferrari Testarossa",
    "Honda NSX",
    "Ferrari Enzo",
    "DeLorean DMC",
    "Peugeot 406",
    "Honda S2000",
    "Bugatti W16 Mistral",
    "Bugatti Veyron",
    "Koenigsegg Regera",
    "Ferrari LaFerrari",
    "Tesla CyberTruck",
    "Acura NSX 2023",
    "Lotus Emira",
    "Mazda MX-5 Miata",
    "Toyota AE86",
    "Nissan Skyline R32",
    "Kawasaki JetSki STX",
    "Subaru Levorg",
    "Audi A8 2022",
    "Range Rover Velar",
    "Skoda Octavia A7",
    "Toyota Prius 2018",
    "Mercedes 280SL Pagoda",
    "Chevrolet Camaro SS",
    "Honda CB 650R",
    "Ford Bronco VI",
    "BMW M3 G81",
    "Porsche 911 Dakar",
    "Anakonda",
    "Punker",
    "Bekas",
    "Medved",
    "Volkolak",
    "Karakal",
    "Koyot",
    "Larga",
    "Krayt",
    "Lakhtak",
    "Sleypnir",
    "Akiba",
    "Nissan 240SX",
    "Pagani Zonda",
    "KIA Carnival",
    "Ford Crown Victoria",
    "Lincoln Navigator",
    "ZIL 4104",
    "Mercedes-Benz CLK-GTR",
    "Chevrolet Silverado 6x6",
    "BMW M4 GT3",
    "Ford Torino",
    "Lada Kalina Sport",
    "Opel Astra H OPC",
    "Honda Civic IIX",
    "AUDI S5 Coupe 2020",
    "PAZ 3205",
    "Mercedes-Benz AMG Project One",
    "Hudson Hornet",
    "Chevrolet 3100 Tow Truck",
    "Ferrari Daytona",
    "Lamborghini Murcielago",
    "Dodge Ice Charger",
    "FORD FALCON XB",
    "Hot-Road F132",
    "SCG 003",
    "Mitsubishi Eclipse",
    "Smart Fortwo 2",
    "Chevrolet Bel Air",
    "Kombayn",
    "Renault R5 Turbo 3E 2022",
    "Boss 302 Mustang",
    "Ferrari 812 Superfast",
    "Toyota Celica",
    "Audi R8 LMS GT2",
    "Suzuki gsxr1100",
    "Porsche GT3 RS 992",
    "Mercedes-Benz 190E Evo II",
    "Toyota Tundra Nascar",
    "Dodge Viper GTC",
    "Lamborghini Countach",
    "BMW 3.5 CSL 1974",
    "Ferrari 330 p4",
    "Lancia Stratos",
    "Dodge Demon SRT Off-Road",
    "Honda TRX 420 FM",
    "Hummer H2",
    "Mercedes-AMG E63 S Wagon",
    "Izh-2715",
    "Yamaha YZF-R25",
    "Porsche 918 Spyder",
    "Toyota GT86",
    "Marussia B2",
    "URAL IMZ 8 Blits",
    "Toyota Chaser Tourer v 100",
    "Land Rover Range Rover III",
    "Geely Emgrand 7",
    "LuAZ 969",
    "Volkswagen Touareg 2022",
    "BMW Alpina B12 E32",
    "Mercedes-Benz G63 AMG 6x6",
    "Marussia B1",
    "Lincoln Town Car",
    "Mercedes Benz g500 Police",
    "Lamborghini LM002",
    "Mercedes-Benz S-Class w221",
    "GAZ-21 Coupe",
    "BMW M5 CS",
    "Toyota Supra A90",
    "Lamborghini Miura Roadster",
    "Volkswagen Beetle Baja Bug",
    "Jeep Wrangler Rubicon",
    "BMW M4 Convertible",
    "Buick GSX 1970",
    "Yamaha SR400",
    "Audi RS Q e-tron Dacar",
    "Ferrari SF90 Stradale Spider",
    "BMW X5M F85",
    "Mercedes-Benz R230",
    "Tank 500",
    "Porsche 930",
    "Mitsubishi Lancer EVO 7",
    "Dodge Charger Police",
    "Mazda RX7 Veilside",
    "VAZ 2106 (Hoonicorn style)",
    "Volvo 240 GL",
    "Lenco BearCat G2",
    "Ferrari 308 GTB",
    "Toyota Supra A70 mk3",
    "Lamborghini Countach (2022)",
    "Subaru Impreza II WRX STi",
    "Mercede s-Benz w211",
    "Vaz 21099",
    "Haval F7X",
    "Mercedes-Benz G 63 AMG Brabus",
    "Hyundai Grandeur",
    "Ford Explorer",
    "Xiaomi su7",
    "Ford Mondeo",
    "Bentley Azure mk2",
    "Chevrolet Camaro Z28",
    "Jeep Grand Cherokee SRT8",
    "Mercedes-Benz CLS 55 AMG",
    "BMW E28 Alpina",
    "Bugatti Centodieci",
    "International S 1700 School bus",
    "Chevrolet Niva",
    "BMW M3 E92"
};

static gVvehPage[MAX_PLAYERS];
static gVvehShown[MAX_PLAYERS];

stock bool:Vveh_IsAdmin3(playerid)
{
    #if defined GetPlayerAdminEx
        return (GetPlayerAdminEx(playerid) >= 3);
    #else
        return false;
    #endif
}

stock Vveh_AdminLogSpawn(playerid, vehname[])
{
    #if defined SendMessageToAdmins && defined GetPlayerNameEx
        new fmt_msg[144];
        format(fmt_msg, sizeof fmt_msg, "[A] Администратор %s заспавнил авто %s.", GetPlayerNameEx(playerid), vehname);
        SendMessageToAdmins(fmt_msg, 0xFF5533FF);
    #else
        #pragma unused playerid, vehname
    #endif
    return 1;
}

stock Vveh_SpawnVehicleForPlayer(playerid, modelid, vehname[])
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new Float:fx = x + floatsin(-a, degrees) * 3.0;
    new Float:fy = y + floatcos(-a, degrees) * 3.0;

    new veh = CreateVehicle(modelid, fx, fy, z, a, 1, 1, 0);
    if (veh == INVALID_VEHICLE_ID)
    {
        SCM(playerid, 0xFF6B6BFF, ""SC"Не удалось создать транспорт (возможно неверный ID).");
        return 0;
    }

    SetVehicleVirtualWorld(veh, GetPlayerVirtualWorld(playerid));
    LinkVehicleToInterior(veh, GetPlayerInterior(playerid));
    PutPlayerInVehicle(playerid, veh, 0);

    new msg[160];
    format(msg, sizeof msg, ""SC"Транспорт %s (%d) создан (временно).", vehname, modelid);
    SCM(playerid, 0x00FF99FF, msg);

    Vveh_AdminLogSpawn(playerid, vehname);
    return 1;
}

stock Vveh_ShowList(playerid)
{
    new total = VVEH_MAX;
    new pages = (total + VVEH_PER_PAGE - 1) / VVEH_PER_PAGE;
    if (pages < 1) pages = 1;

    if (gVvehPage[playerid] < 0) gVvehPage[playerid] = 0;
    if (gVvehPage[playerid] >= pages) gVvehPage[playerid] = pages - 1;

    new start = gVvehPage[playerid] * VVEH_PER_PAGE;
    new end = start + VVEH_PER_PAGE;
    if (end > total) end = total;

    new body[4096];
    format(body, sizeof body, "#\tАйди транспорта\tНазвание авто\n");

    new row[240];
    new shown = 0;

    for (new i = start, n = 1; i < end; i++, n++)
    {
        format(row, sizeof row, "{FF0000}%d{FFFFFF}\t{CECECE}%d{FFFFFF}\t%s\n",
            (start + n),
            gVvehIds[i],
            gVvehNames[i]
        );
        strcat(body, row);
        shown++;
    }
    gVvehShown[playerid] = shown;

    if (pages > 1)
    {
        if (gVvehPage[playerid] < pages - 1)
            strcat(body, "{3399FF}>>\t\tСледующая страница{FFFFFF}\n");
        if (gVvehPage[playerid] > 0)
            strcat(body, "{3399FF}<<\t\tПредыдущая страница{FFFFFF}\n");
    }

    new caption[96];
    format(caption, sizeof caption, "{FFCD00}Создание автомобиля{FFFFFF}  |  Стр. %d/%d", gVvehPage[playerid] + 1, pages);

    ShowPlayerDialog(playerid, VVEH_DLG_LIST, DIALOG_STYLE_TABLIST_HEADERS, caption, body, "Выбрать", "Отмена");
    return 1;
}

CMD:veh(playerid, params[])
{
    #pragma unused params
    if (!Vveh_IsAdmin3(playerid))
        return SCM(playerid, 0xCECECEFF, ""SC"Доступно только с 3 уровня админки.");

    gVvehPage[playerid] = 0;
    Vveh_ShowList(playerid);
    return 1;
}

// ВСТАВЬ В ТВОЙ OnDialogResponse ОДНУ СТРОКУ:
// if (Vveh_OnDialogResponse(playerid, dialogid, response, listitem, inputtext)) return 1;

stock bool:Vveh_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext
    if (dialogid != VVEH_DLG_LIST) return false;

    if (!response) return true;

    new total = VVEH_MAX;
    new pages = (total + VVEH_PER_PAGE - 1) / VVEH_PER_PAGE;
    if (pages < 1) pages = 1;

    new shown = gVvehShown[playerid];

    // клики по строкам навигации
    if (listitem >= shown)
    {
        new navIndex = listitem - shown;

        // порядок: next, потом prev
        if (pages > 1)
        {
            if (gVvehPage[playerid] < pages - 1)
            {
                if (navIndex == 0) { gVvehPage[playerid]++; Vveh_ShowList(playerid); return true; }
                navIndex--;
            }
            if (gVvehPage[playerid] > 0)
            {
                if (navIndex == 0) { gVvehPage[playerid]--; Vveh_ShowList(playerid); return true; }
            }
        }
        return true;
    }

    // клик по авто -> сразу спавним
    new idx = gVvehPage[playerid] * VVEH_PER_PAGE + listitem;
    if (idx < 0 || idx >= total) return true;

    Vveh_SpawnVehicleForPlayer(playerid, gVvehIds[idx], gVvehNames[idx]);
    return true;
}
