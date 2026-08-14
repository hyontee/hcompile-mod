enum ENUM_SALON_DATA {
    sModel,
    sName[32],
    sPrice,
    sMaxSpeed,
    Float:sAcceleration
};

new p_SalonType[MAX_PLAYERS];

new LowSalonCars[][ENUM_SALON_DATA] = {
    {555, "ZAZ 968", 20000, 118, 32.0},
    {549, "VAZ 1111", 30000, 120, 24.0},
    {401, "VAZ 2101", 60000, 142, 22.0},
    {479, "GAZ Volga 2410", 80000, 170, 17.0},
    {412, "VAZ 2106", 83000, 160, 17.0},
    {496, "Volkswagen Golf GTI 2", 140000, 197, 8.3},
    {404, "VAZ 2107", 150000, 158, 17.0},
    {439, "VAZ 2108", 170000, 160, 14.0},
    {492, "VAZ 2109", 180000, 162, 14.0},
    {547, "VAZ 2110", 190000, 160, 12.5},
    {458, "VAZ 2114", 195000, 160, 13.0},
    {491, "VAZ 2112", 200000, 160, 12.3},
    {585, "VAZ 2115", 210000, 160, 13.0},
    {536, "Volvo 242DL", 250000, 176, 11.1},
    {529, "VAZ 2172", 300000, 183, 11.5},
    {534, "BMW M3 E30", 300000, 239, 6.6},
    {542, "Niva Urban", 350000, 140, 17.0},
    {2616, "UAZ Hunter", 360000, 140, 13.0},
    {2555, "Lada Granta", 370000, 176, 11.5},
    {540, "Mazda Sedan 3", 380000, 218, 8.1},
    {559, "Toyota Mark 2", 420000, 223, 9.0},
    {421, "Mercedes-Benz W124", 440000, 188, 11.0},
    {2554, "Jeep Grand Cherokee", 450000, 185, 9.6},
    {2611, "Audi 100 C4", 520000, 242, 5.6},
    {2618, "BMW M3 E36", 600000, 247, 5.0},
    {419, "Mercedes-Benz E420 W210", 700000, 250, 6.0},
    {2548, "Lada Vesta Sedan", 700000, 184, 9.3},
    {2624, "Audi A6 C5", 1000000, 248, 5.8}
};

new MediumSalonCars[][ENUM_SALON_DATA] = {
    {2610, "BMW M5 E34", 600000, 245, 5.5},
    {562, "Nissan Skyline R34", 680000, 250, 5.1},
    {2557, "Lada Vesta SW Cross", 700000, 184, 9.6},
    {2565, "Renault Logan", 715000, 173, 10.1},
    {507, "Audi A4", 750000, 238, 6.9},
    {2566, "Kia Rio", 800000, 193, 9.6},
    {426, "BMW M5 E39", 800000, 246, 5.1},
    {546, "Hyundai Solaris 2021", 830000, 200, 9.3},
    {516, "Volkswagen Polo", 850000, 238, 7.9},
    {2589, "Skoda Rapid 2020", 870000, 209, 9.0},
    {467, "Mercedes-Benz S600 W140", 900000, 250, 6.4},
    {2588, "Ford Focus 3 Sedan", 930000, 220, 8.5},
    {2580, "BMW 7-Series E38", 950000, 246, 5.5},
    {527, "BMW M3 E46", 1050000, 246, 5.1},
    {445, "Acura TSX", 1150000, 256, 6.1},
    {2560, "UAZ Patriot", 1200000, 163, 12.0},
    {2561, "UAZ Patriot Pickup", 1250000, 163, 12.0},
    {589, "Volkswagen Golf GTI", 1400000, 250, 6.5},
    {2568, "BMW X5 E53", 1500000, 215, 6.4},
    {2623, "Toyota Camry XV55", 1600000, 242, 5.5},
    {2627, "Nissan Silvia S15", 1700000, 252, 5.0},
    {587, "Ford Focus RS", 1800000, 265, 4.6},
    {436, "Mitsubishi Lancer Evo X", 2000000, 239, 5.4},
    {2567, "BMW M5 E60", 2100000, 240, 4.6},
    {560, "Subaru WRX STI", 2200000, 246, 5.5},
    {550, "Toyota Camry 3.5", 2400000, 247, 6.0},
    {2584, "Kia K5", 2500000, 249, 5.8},
    {603, "Ford Mustang GT", 2600000, 277, 3.9},
    {2552, "Toyota Supra A80", 2700000, 259, 5.4},
    {565, "Mercedes-Benz A45 AMG", 2800000, 250, 4.5},
    {2609, "Mini Cooper", 2850000, 246, 4.9},
    {2604, "Volkswagen Passat 2021", 2900000, 246, 5.5},
    {551, "Alfa Romeo Guilia", 3000000, 306, 3.9},
    {526, "Infiniti Q60S", 3200000, 266, 4.6},
    {2620, "Lexus RCF", 3400000, 263, 4.1},
    {442, "Volvo V60", 3500000, 235, 6.4},
    {2625, "Infiniti FX50S", 3700000, 252, 5.5},
    {2621, "Xpeng P7", 4000000, 235, 4.4}
};

new SalonCars[][ENUM_SALON_DATA] = {
    {489, "Volvo XC90", 4200000, 248, 5.6},
    {543, "Chevrolet Camaro ZL1", 4600000, 315, 4.0},
    {480, "BMW Z4 M40i", 4900000, 259, 4.5},
    {503, "Dodge Demon SRT", 6100000, 322, 2.5},
    {2622, "Ford Mustang Mach E", 5200000, 240, 4.1},
    {558, "BMW M4 F84", 5500000, 261, 4.0},
    {495, "Ford Raptor F-150", 5757000, 211, 6.1},
    {475, "Audi Q8", 6000000, 248, 4.5},
    {410, "Mercedes-Benz C63s AMG", 6200000, 278, 3.9},
    {402, "Mercedes-Benz GT63s", 7000000, 313, 3.2},
    {2553, "Audi Q7", 7000000, 238, 6.1},
    {505, "Cadillac Escalade IV", 7200000, 248, 6.4},
    {2603, "Mercedes-Benz E63 W212", 7500000, 278, 3.5},
    {2598, "BMW M4 G82", 7700000, 265, 3.4},
    {2547, "Toyota Land Cruiser 200", 7800000, 220, 8.6},
    {502, "Nissan GT-R R35", 7900000, 319, 2.7},
    {400, "BMW X6M F16", 8200000, 284, 4.1},
    {604, "Porsche Panamera S", 8400000, 310, 3.7},
    {405, "Audi RS6", 8500000, 306, 3.9},
    {2602, "Chevrolet Tahoe RST", 8900000, 200, 6.8},
    {506, "Porsche 911 Carrera S", 9000000, 309, 3.7},
    {2550, "Mercedes-Benz GLS 400", 9150000, 240, 6.4},
    {466, "BMW M5 F90", 9500000, 312, 3.4},
    {2545, "Audi RS7 Sport", 9500000, 252, 3.2},
    {490, "Range Rover SVR", 10000000, 262, 4.9},
    {420, "Audi RS6 C7", 10000000, 310, 3.7},
    {2582, "Mercedes-Benz CLS63 AMG", 10300000, 305, 3.5},
    {2574, "BMW X7 M50i", 10500000, 250, 4.6},
    {533, "Audi R8 V10", 11000000, 322, 3.4},
    {2575, "Lexus LX570", 11455000, 230, 6.9},
    {2559, "Cadillac Escalade", 11500000, 210, 6.4},
    {2546, "Mercedes-Benz E63S", 11500000, 314, 3.2},
    {494, "BMW I8 Roadster", 12600000, 320, 4.5},
    {429, "Mercedes-Benz GT-R", 13500000, 319, 3.5},
    {451, "McLaren 600LT", 14000000, 329, 2.9},
    {2599, "BMW 7-Series 750Li", 14300000, 260, 4.4},
    {2626, "Porsche Cayenne S", 14700000, 282, 3.9},
    {2544, "Tesla Model S", 15000000, 252, 3.2},
    {2551, "Lamborghini Urus", 15300000, 305, 3.5},
    {2549, "Lamborghini Huracan", 16500000, 330, 2.9},
    {579, "Mercedes-Benz G65 AMG", 17050000, 223, 5.3},
    {2578, "BMW M8 F92", 17200000, 312, 3.4},
    {541, "Ferrari 488 GTB", 17500000, 336, 3.0},
    {2581, "Porsche Taycan Turbo S", 18300000, 254, 3.2},
    {411, "Aston Martin DB11", 18500000, 322, 3.9},
    {2579, "BMW M8 F93 Gran Coupe", 19000000, 312, 3.2},
    {415, "Lamborghini Aventador S", 20000000, 351, 2.7},
    {2543, "Tesla Model X", 21000000, 256, 3.4},
    {2573, "Mercedes-Benz G63 AMG", 23000000, 223, 5.0},
    {2590, "Mercedes-Benz EQS580", 24000000, 270, 3.2},
    {2558, "Mercedes-Benz MB S650", 25000000, 248, 5.0},
    {2619, "Ferrari 488 Pista", 26000000, 340, 2.7},
    {2597, "Aurus Senat", 30000000, 260, 5.8},
    {2583, "Rolls-Royce Wraith", 35000000, 264, 4.9},
    {2564, "Rolls-Royce Cullinan", 40000000, 260, 5.1},
    {2563, "Rolls-Royce Phantom", 50000000, 265, 5.3},
    {2591, "Bentley Continental GT", 54000000, 333, 3.5},
    {2607, "BMW M1", 70000000, 275, 3.9},
    {2600, "Bentley Mulliner Bacalar", 125000000, 333, 3.5},
    {2601, "Bugatti Chiron", 210000000, 370, 2.5},
    {2570, "Bugatti Divo", 380000000, 380, 2.4},
    {2569, "Bugatti La Noire", 1000000000, 400, 2.2}
};

new SalonWheels[] = {0, 1025, 1073, 1074, 1075, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1096, 1097, 1098};

new p_SalonCarID[MAX_PLAYERS];
new p_SalonColor[MAX_PLAYERS][2];
new p_SalonWheelID[MAX_PLAYERS];
new p_BuyCar[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
new PlayerText:avtsln1_PTD[MAX_PLAYERS][15] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...};

stock UpdateSalonVehicle(playerid, bool:recreate = true)
{
    new id = p_SalonCarID[playerid], model, price, maxspeed, Float:accel, name[32];
    if(p_SalonType[playerid] == 0) {
        model = SalonCars[id][sModel]; price = SalonCars[id][sPrice]; maxspeed = SalonCars[id][sMaxSpeed]; accel = SalonCars[id][sAcceleration]; strmid(name, SalonCars[id][sName], 0, strlen(SalonCars[id][sName]), 32);
    } else if(p_SalonType[playerid] == 1) {
        model = MediumSalonCars[id][sModel]; price = MediumSalonCars[id][sPrice]; maxspeed = MediumSalonCars[id][sMaxSpeed]; accel = MediumSalonCars[id][sAcceleration]; strmid(name, MediumSalonCars[id][sName], 0, strlen(MediumSalonCars[id][sName]), 32);
    } else {
        model = LowSalonCars[id][sModel]; price = LowSalonCars[id][sPrice]; maxspeed = LowSalonCars[id][sMaxSpeed]; accel = LowSalonCars[id][sAcceleration]; strmid(name, LowSalonCars[id][sName], 0, strlen(LowSalonCars[id][sName]), 32);
    }
    if(recreate) {
        if(p_BuyCar[playerid] != INVALID_VEHICLE_ID) DestroyVehicle(p_BuyCar[playerid]);
        p_BuyCar[playerid] = CreateVehicle(model, 1149.8434, 226.0655, 994.7953, 20.8742, p_SalonColor[playerid][0], p_SalonColor[playerid][1], -1);
        SetVehicleVirtualWorld(p_BuyCar[playerid], playerid + 1);
        LinkVehicleToInterior(p_BuyCar[playerid], 1);
    }
    if(p_SalonWheelID[playerid] > 0) AddVehicleComponent(p_BuyCar[playerid], SalonWheels[p_SalonWheelID[playerid]]);
    new str[64];
    format(str, sizeof(str), "%d RUB", price); PlayerTextDrawSetString(playerid, avtsln1_PTD[playerid][11], str);
    format(str, sizeof(str), "%d KM/H", maxspeed); PlayerTextDrawSetString(playerid, avtsln1_PTD[playerid][12], str);
    format(str, sizeof(str), "%.1f C", accel); PlayerTextDrawSetString(playerid, avtsln1_PTD[playerid][13], str);
    PlayerTextDrawSetString(playerid, avtsln1_PTD[playerid][14], name);
    return 1;
}

stock HideAvtosalon(playerid)
{
    if(p_BuyCar[playerid] != INVALID_VEHICLE_ID) DestroyVehicle(p_BuyCar[playerid]);
    p_BuyCar[playerid] = INVALID_VEHICLE_ID;
    for(new i = 0; i < 15; i++) {
        if(avtsln1_PTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW) { PlayerTextDrawDestroy(playerid, avtsln1_PTD[playerid][i]); avtsln1_PTD[playerid][i] = PlayerText:INVALID_TEXT_DRAW; }
    }
    CancelSelectTextDraw(playerid);
    TogglePlayerControllable(playerid, true);
    SetCameraBehindPlayer(playerid);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    if(p_SalonType[playerid] == 0) { SetPlayerPos(playerid, 657.8327, 2661.4963, 13.5165); SetPlayerFacingAngle(playerid, 149.0740); } // high
    else if(p_SalonType[playerid] == 1) { SetPlayerPos(playerid, 1409.2773, 457.3852, 13.2030); SetPlayerFacingAngle(playerid, 154.0572); } // simple
    else { SetPlayerPos(playerid, 2477.1091, -721.4980, 12.3715); SetPlayerFacingAngle(playerid, 177.5868); }  // low
    return 1;
}

stock CreateAvtosalonTextDraws(playerid)
{
    avtsln1_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 194.1663, 417.3706, "txd:brsalonbuy");
    PlayerTextDrawTextSize(playerid, avtsln1_PTD[playerid][0], 98.0, 28.0);
    PlayerTextDrawSetSelectable(playerid, avtsln1_PTD[playerid][0], true);

    avtsln1_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 357.0831, 417.3703, "txd:brsalonclose");
    PlayerTextDrawTextSize(playerid, avtsln1_PTD[playerid][1], 89.0, 28.0);
    PlayerTextDrawSetSelectable(playerid, avtsln1_PTD[playerid][1], true);

    avtsln1_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 167.9167, 350.4815, "txd:brsalonmain");
    PlayerTextDrawTextSize(playerid, avtsln1_PTD[playerid][2], 305.0, 61.0);

    avtsln1_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 549.1669, 380.0369, "txd:brsalonright");
    PlayerTextDrawTextSize(playerid, avtsln1_PTD[playerid][3], 30.0, 33.0);
    PlayerTextDrawSetSelectable(playerid, avtsln1_PTD[playerid][3], true);

    avtsln1_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 65.4165, 381.0743, "txd:brsalonleft");
    PlayerTextDrawTextSize(playerid, avtsln1_PTD[playerid][4], 30.0, 33.0);
    PlayerTextDrawSetSelectable(playerid, avtsln1_PTD[playerid][4], true);

    avtsln1_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 493.7499, 135.2962, "txd:brsaloninfo");
    PlayerTextDrawTextSize(playerid, avtsln1_PTD[playerid][5], 138.0, 114.0);

    avtsln1_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 4.9998, 147.2220, "txd:brsaloncastom");
    PlayerTextDrawTextSize(playerid, avtsln1_PTD[playerid][6], 134.0, 106.0);

    avtsln1_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 116.25, 221.37, "txd:brsalonnext");
    avtsln1_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 116.25, 187.14, "txd:brsalonnext");
    avtsln1_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 5.83, 220.85, "txd:brsalonback");
    avtsln1_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 5.83, 186.62, "txd:brsalonback");
    
    for(new i = 7; i <= 10; i++) {
        PlayerTextDrawTextSize(playerid, avtsln1_PTD[playerid][i], 21.0, 29.0);
        PlayerTextDrawSetSelectable(playerid, avtsln1_PTD[playerid][i], true);
    }

    avtsln1_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 356.2502, 389.6296, "0 RUB");
    PlayerTextDrawLetterSize(playerid, avtsln1_PTD[playerid][11], 0.4, 1.6);
    PlayerTextDrawFont(playerid, avtsln1_PTD[playerid][11], 1);

    avtsln1_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 610.0, 182.0, "0 KM/H");
    PlayerTextDrawLetterSize(playerid, avtsln1_PTD[playerid][12], 0.32, 1.35);
    PlayerTextDrawAlignment(playerid, avtsln1_PTD[playerid][12], 2);

    avtsln1_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 610.0, 221.0, "0.0 SEC");
    PlayerTextDrawLetterSize(playerid, avtsln1_PTD[playerid][13], 0.32, 1.35);
    PlayerTextDrawAlignment(playerid, avtsln1_PTD[playerid][13], 2);

    avtsln1_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 254.1665, 357.4815, "None");
    PlayerTextDrawLetterSize(playerid, avtsln1_PTD[playerid][14], 0.4, 1.6);
    PlayerTextDrawFont(playerid, avtsln1_PTD[playerid][14], 1);

    for(new i = 0; i < 15; i++) {
        PlayerTextDrawColor(playerid, avtsln1_PTD[playerid][i], -1);
        PlayerTextDrawBackgroundColor(playerid, avtsln1_PTD[playerid][i], 255);
        PlayerTextDrawSetProportional(playerid, avtsln1_PTD[playerid][i], 1);
        PlayerTextDrawSetShadow(playerid, avtsln1_PTD[playerid][i], 0);
        if(i <= 10) PlayerTextDrawFont(playerid, avtsln1_PTD[playerid][i], 4);
        else if(i != 12 && i != 13) PlayerTextDrawAlignment(playerid, avtsln1_PTD[playerid][i], 1);
    }
    return 1;
}

/*CMD:lowauto(playerid, params[]) // low
{
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) if(VehicleInfo[playerid][i][vSpawned]) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] Сначала выгрузите авто!");
    p_SalonType[playerid] = 2;
    OpenAutoSalon(playerid);
    return 1;
}

CMD:highauto(playerid, params[]) // high auto
{
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) if(VehicleInfo[playerid][i][vSpawned]) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] Сначала выгрузите авто!");
    p_SalonType[playerid] = 0;
    OpenAutoSalon(playerid);
    return 1;
}

CMD:mediumauto(playerid, params[]) // simple auto
{
    for(new i = 0; i < MAX_PLAYER_VEHICLES; i++) if(VehicleInfo[playerid][i][vSpawned]) return SendClientMessage(playerid, COLOR_RED, "[Автосалон] Сначала выгрузите авто!");
    p_SalonType[playerid] = 1;
    OpenAutoSalon(playerid);
    return 1;
} */

stock OpenAutoSalon(playerid)
{
    p_SalonCarID[playerid] = 0;
    p_SalonColor[playerid][0] = 1;
    p_SalonColor[playerid][1] = 1;
    p_SalonWheelID[playerid] = 0;
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, playerid + 1);
    SetPlayerPos(playerid, 1137.5398, 234.6261, 995.1235);
    TogglePlayerControllable(playerid, false);
    SetPlayerCameraPos(playerid, 1142.746215, 231.186386, 995.992248);
    SetPlayerCameraLookAt(playerid, 1146.743041, 228.254837, 995.335449);
    CreateAvtosalonTextDraws(playerid);
    UpdateSalonVehicle(playerid, true);
    for(new i = 0; i < 15; i++) PlayerTextDrawShow(playerid, avtsln1_PTD[playerid][i]);
    SelectTextDraw(playerid, 0xFFFFFFFF);
    return 1;
}
