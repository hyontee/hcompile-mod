#include <a_samp>

new PlayerVehicle[MAX_PLAYERS];
new bool:VehicleLocked[MAX_VEHICLES];

#define DIALOG_CIVILIAN 9000
#define DIALOG_FACTION 9001
#define DIALOG_SPECIAL 9002
#define DIALOG_WATER 9003
#define DIALOG_AIR 9004
#define DIALOG_BIKES 9005
#define DIALOG_BUSES 9006
#define DIALOG_LARGE 9007
#define DIALOG_CATEGORIES 9008
#define DIALOG_COLORS 9009

stock ShowVehicleMenu(playerid)
{
    ShowPlayerDialog(playerid, DIALOG_CATEGORIES, DIALOG_STYLE_LIST,
    "{FF0000}"PROJECT_NAME" {FFFFFF} | Категории транспорта",
    "Гражданский\n\
    Фракционный\n\
    Специальный\n\
    Водный\n\
    Воздушный\n\
    Мотоциклы\n\
    Автобусы и микроавтобусы\n\
    Габаритные авто",
    "Выбрать", "Выйти");
    return 1;
}

CMD:bc(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) return 1;
    ShowVehicleMenu(playerid);
    return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
switch(dialogid)
{
    case DIALOG_CIVILIAN:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        
        if(PlayerVehicle[playerid] != 0)
        {
            DestroyVehicle(PlayerVehicle[playerid]);
            PlayerVehicle[playerid] = 0;
        }
        
        new modelid;
        switch(listitem)
        {
            case 0: modelid = 400; // BMW X6M F16
            case 1: modelid = 401; // VAZ 2101
            case 2: modelid = 402; // Mercedes-Benz GT63s (Акула)
            case 3: modelid = 404; // ВАЗ 2107
            case 4: modelid = 405; // Audi RS6
            case 5: modelid = 410; // Mercedes-Benz C63s AMG
            case 6: modelid = 411; // Aston Martin DB11
            case 7: modelid = 415; // Lamborghini Aventador S
            case 8: modelid = 419; // Mercedes-Benz E420 W210
            case 9: modelid = 421; // Mercedes-Benz W124
            case 10: modelid = 426; // BMW M5 E39
            case 11: modelid = 429; // Mercedes-Benz GT-R
            case 12: modelid = 436; // Mitsubishi Lancer Evo X
            case 13: modelid = 442; // Volvo V60
            case 14: modelid = 445; // Acura TSX
            case 15: modelid = 451; // MacLaren 600LT
            case 16: modelid = 458; // VAZ 2114
            case 17: modelid = 466; // BMW M5 F90
            case 18: modelid = 467; // Mercedes-Benz S600 W140
            case 19: modelid = 475; // Audi Q8
            case 20: modelid = 477; // Mazda RX-7
            case 21: modelid = 480; // BMW Z4 M40i
            case 22: modelid = 489; // Volvo XC90
            case 23: modelid = 490; // Range Rover SVR
            case 24: modelid = 494; // BMW I8 Edrive
            case 25: modelid = 495; // Ford Raptor F-150
            case 26: modelid = 496; // Volkswagen Golf GTI2
            case 27: modelid = 502; // Nissan GT-R R35
            case 28: modelid = 503; // Dodge Demon SRT
            case 29: modelid = 505; // Cadillac Escalade
            case 30: modelid = 506; // Porsche 911 Carrera S
            case 31: modelid = 507; // Audi A4
            case 32: modelid = 516; // Volkswagen Polo
            case 33: modelid = 526; // Infiniti Q60S
            case 34: modelid = 527; // BMW M3 E46
            case 35: modelid = 529; // Vaz 2170
            case 36: modelid = 533; // Audi R8 V10
            case 37: modelid = 534; // BMW M3 E30
            case 38: modelid = 536; // Volvo 242DL
            case 39: modelid = 540; // Mazda Sedan 3
            case 40: modelid = 541; // Ferrari 488 GTB
            case 41: modelid = 542; // Niva Urban
            case 42: modelid = 543; // Chevrolet Camaro ZL1
            case 43: modelid = 549; // VAZ 1111
            case 44: modelid = 550; // Toyota Camry 3.5
            case 45: modelid = 551; // Alfa Romeo Giulia
            case 46: modelid = 555; // ZAZ 968
            case 47: modelid = 558; // BMW M4 F84
            case 48: modelid = 559; // Toyota Mark 2
            case 49: modelid = 560; // SUBARU WRX STI
            case 50: modelid = 562; // Nissan Skyline R34
            case 51: modelid = 565; // Mercedes-Benz a65 AMG
            case 52: modelid = 579; // Mercedes-Benz G65 AMG
            case 53: modelid = 585; // VAZ 2115
            case 54: modelid = 587; // Ford Focus RS
            case 55: modelid = 589; // Volkswagen Golf GTI
            case 56: modelid = 603; // Ford Mustang GT
            case 57: modelid = 604; // Porsche Panamera S
            case 58: modelid = 2545; // Audi RS-7 Sport
            case 59: modelid = 2546; // Mercedes-Benz E46S
            case 60: modelid = 2548; // Lada Vesta Sedan
            case 61: modelid = 2549; // Lamborghini Huracan
            case 62: modelid = 2550; // Mercedes-Benz GLS 400
            case 63: modelid = 2551; // Lamborghini Urus
            case 64: modelid = 2552; // Toyota Supra A80
            case 65: modelid = 2553; // Audi Q7
            case 66: modelid = 2554; // Jeep Grand Cherokee
            case 67: modelid = 2555; // Lada Granta
            case 68: modelid = 2557; // Lada Vesta SW Cross
            case 69: modelid = 2558; // Mercedes-Benz Maybach S650
            case 70: modelid = 2559; // Cadillac Escalade (новый)
            case 71: modelid = 2565; // Renault Logan
            case 72: modelid = 2566; // Kia Rio 2020
            case 73: modelid = 2567; // BMW M5 E60
            case 74: modelid = 2568; // BMW X5 E53
            case 75: modelid = 2569; // Bugatti La Noire
            case 76: modelid = 2570; // Bugatti Divo
            case 77: modelid = 2572; // Reasr Tachyon 2019
            case 78: modelid = 2573; // Mercedes-Benz G63 AMG
            case 79: modelid = 2574; // BMW X7 M50i
            case 80: modelid = 2575; // Lexus LX570
            case 81: modelid = 2578; // BMW M8 F92
            case 82: modelid = 2579; // BMW M8 F93 Gran Coupe
            case 83: modelid = 2580; // BMW 7-Series E38
            case 84: modelid = 2581; // Porsche Taycan Turbo S
            case 85: modelid = 2582; // Mercedes-Benz CLS63 AMG
            case 86: modelid = 2583; // Rolls-Royce Wraith
            case 87: modelid = 2584; // KIA K5
            case 88: modelid = 2585; // Mercedes-Benz 300SL Coupe
            case 89: modelid = 2586; // Jaguar XK120 Roadster
            case 90: modelid = 2543; // Tesla model X
            case 91: modelid = 2544; // Tesla model S
            case 92: modelid = 2560; // UAZ Patriot
            case 93: modelid = 2561; // UAZ Patriot Pickup
            case 94: modelid = 2563; // Rolls-Royce Phantom
            case 95: modelid = 2564; // Rolls-Royce Cullinan
            case 96: modelid = 643; // BMW M3 G81
            case 97: modelid = 666; // Ferrari LaFerrari
            case 98: modelid = 626; // Chevrolet 3100 Tow Truck
            case 99: modelid = 628; // Lamborghini Murcielago
            case 100: modelid = 629; // Dodge Ice Charger
            case 101: modelid = 630; // FORD FALCON XB
            case 102: modelid = 634; // Smart Fortwo 2
            case 103: modelid = 635; // Chevrolet Bel Air
            case 104: modelid = 744; // Toyota Tundra Nascar
            case 105: modelid = 769; // Lamborghini LM002
            case 106: modelid = 762; // ЛуАЗ-969
            case 107: modelid = 763; // Volkswagen Touareg
            case 108: modelid = 2388; // BMW M5 F10
            case 109: modelid = 2394; // Dodge Charger SRT
            case 110: modelid = 2396; // Mazda RX-8
            case 111: modelid = 2398; // Flanker F
            case 112: modelid = 2406; // Ferrari Enzo
            default: return 1;
        }
        
        pos[0] += 2.0 * floatsin(-pos[3], degrees);
        pos[1] += 2.0 * floatcos(-pos[3], degrees);
        
        new vehicleid = CreateVehicle(modelid, pos[0], pos[1], pos[2], pos[3], 0, 0, 300, 0);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Не удалось создать транспортное средство!");
            return 1;
        }
        
        PlayerVehicle[playerid] = vehicleid;
        VehicleLocked[vehicleid] = true;
        
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST,
            "Выбор цвета",
            "Черный\nБелый\nКрасный\nЗеленый\nСиний\nСиний металлик\nКрасный металлик\nСеребристый\nЗолотой",
            "Выбрать", "Назад");
        return 1;
    }

    case DIALOG_FACTION:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        
        if(PlayerVehicle[playerid] != 0)
        {
            DestroyVehicle(PlayerVehicle[playerid]);
            PlayerVehicle[playerid] = 0;
        }
        
        new modelid;
        switch(listitem)
        {
            case 0: modelid = 596; // BMW M5 F90 (Полиция)
            case 1: modelid = 597; // Vaz 2170 (Полиция)
            case 2: modelid = 598; // Volkswagen Jetta (Полиция)
            case 3: modelid = 582; // Mercedes-Benz Sprinter (ГТРК)
            case 4: modelid = 585; // VAZ 2115
            case 5: modelid = 498; // Mercedes-Benz Sprinter (Дальнобой)
            case 6: modelid = 427; // Gazelle 3221 (ФСИН)
            case 7: modelid = 433; // Gazon Next (Армия)
            case 8: modelid = 599; // УАЗ мил (Полиция)
            case 9: modelid = 416; // Mercedes-Benz Sprinter (ЦБ)
            case 10: modelid = 420; // BMW M5 F90 (Такси)
            case 11: modelid = 438; // Volkswagen Jetta (Такси)
            case 12: modelid = 456; // Gazelle 3310 (ФСИН)
            case 13: modelid = 2562; // UAZ Patriot (ФСИН)
            case 14: modelid = 482; // Mercedes-Benz V-Class (Инкассация)
            case 15: modelid = 428; // Volkswagen Multivan T6 (Инкассация)
            case 16: modelid = 459; // Gazelle 3221 (Инкассация)
            case 17: modelid = 544; // Пожарка
            default: return 1;
        }
        
        pos[0] += 2.0 * floatsin(-pos[3], degrees);
        pos[1] += 2.0 * floatcos(-pos[3], degrees);
        
        new vehicleid = CreateVehicle(modelid, pos[0], pos[1], pos[2], pos[3], 0, 0, 300, 0);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Не удалось создать транспортное средство!");
            return 1;
        }
        
        PlayerVehicle[playerid] = vehicleid;
        VehicleLocked[vehicleid] = true;
        
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST,
            "Выбор цвета",
            "Черный\nБелый\nКрасный\nЗеленый\nСиний\nСиний (полиция)\nКрасный (пожарная)\nКамуфляж (армия)",
            "Выбрать", "Назад");
        return 1;
    }

    case DIALOG_SPECIAL:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        
        if(PlayerVehicle[playerid] != 0)
        {
            DestroyVehicle(PlayerVehicle[playerid]);
            PlayerVehicle[playerid] = 0;
        }
        
        new modelid;
        switch(listitem)
        {
            case 0: modelid = 424; // СМЗ
            case 1: modelid = 441; // RCcar
            case 2: modelid = 448; // Pizzaboy
            case 3: modelid = 457; // Гольф кар
            case 4: modelid = 465; // RCheli
            case 5: modelid = 464; // RCplane
            case 6: modelid = 470; // Gaz Tigr
            case 7: modelid = 471; // Квадроцикл
            case 8: modelid = 486; // Бульдозер
            case 9: modelid = 501; // RCgobl
            case 10: modelid = 528; // Труповоз
            case 11: modelid = 556; // Монстр
            case 12: modelid = 564; // RCtank (Танк)
            case 13: modelid = 568; // Багги
            case 14: modelid = 571; // Карт
            case 15: modelid = 594; // RCcam
            case 16: modelid = 601; // БРДМ
            default: return 1;
        }
        
        pos[0] += 2.0 * floatsin(-pos[3], degrees);
        pos[1] += 2.0 * floatcos(-pos[3], degrees);
        
        new vehicleid = CreateVehicle(modelid, pos[0], pos[1], pos[2], pos[3], 0, 0, 300, 0);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Не удалось создать транспортное средство!");
            return 1;
        }
        
        PlayerVehicle[playerid] = vehicleid;
        VehicleLocked[vehicleid] = true;
        
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST,
            "Выбор цвета",
            "Черный\nБелый\nКрасный\nЗеленый\nСиний\nЖелтый\nОранжевый",
            "Выбрать", "Назад");
        return 1;
    }

    case DIALOG_WATER:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        
        if(PlayerVehicle[playerid] != 0)
        {
            DestroyVehicle(PlayerVehicle[playerid]);
            PlayerVehicle[playerid] = 0;
        }
        
        new modelid;
        switch(listitem)
        {
            case 0: modelid = 473; // Dinghy
            case 1: modelid = 453; // Reefer
            case 2: modelid = 454; // Яхта
            case 3: modelid = 460; // Водный самолёт
            case 4: modelid = 484; // Теплоход
            case 5: modelid = 493; // Jetmax
            case 6: modelid = 430; // Predator
            case 7: modelid = 446; // Squalo
            case 8: modelid = 452; // Speeder
            case 9: modelid = 472; // Coastguard
            case 10: modelid = 539; // Воздушная Подушка
            case 11: modelid = 595; // Launch
            default: return 1;
        }
        
        pos[0] += 2.0 * floatsin(-pos[3], degrees);
        pos[1] += 2.0 * floatcos(-pos[3], degrees);
        
        new vehicleid = CreateVehicle(modelid, pos[0], pos[1], pos[2], pos[3], 0, 0, 300, 0);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Не удалось создать транспортное средство!");
            return 1;
        }
        
        PlayerVehicle[playerid] = vehicleid;
        VehicleLocked[vehicleid] = true;
        
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST,
            "Выбор цвета",
            "Белый\nСиний\nКрасный\nЧерный\nЗеленый",
            "Выбрать", "Назад");
        return 1;
    }

    case DIALOG_AIR:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        
        if(PlayerVehicle[playerid] != 0)
        {
            DestroyVehicle(PlayerVehicle[playerid]);
            PlayerVehicle[playerid] = 0;
        }
        
        new modelid;
        switch(listitem)
        {
            case 0: modelid = 417; // Leviathan
            case 1: modelid = 425; // Hunter
            case 2: modelid = 447; // Водный вертолет
            case 3: modelid = 460; // Водный самолёт
            case 4: modelid = 466; // Истребитель (ВОВ)
            case 5: modelid = 469; // Sparrow
            case 6: modelid = 487; // Вертолёт
            case 7: modelid = 488; // News Вертолёт
            case 8: modelid = 497; // Полицейский вертолёт
            case 9: modelid = 511; // Beagle
            case 10: modelid = 512; // Cropduster
            case 11: modelid = 513; // Stunt
            case 12: modelid = 519; // Shamal
            case 13: modelid = 520; // Истребитель
            case 14: modelid = 548; // Военный вертолёт
            case 15: modelid = 553; // Кукурузник
            case 16: modelid = 563; // Спасательный вертолёт
            case 17: modelid = 577; // AT 400
            case 18: modelid = 592; // Androm
            case 19: modelid = 593; // Dodo
            default: return 1;
        }
        
        pos[0] += 2.0 * floatsin(-pos[3], degrees);
        pos[1] += 2.0 * floatcos(-pos[3], degrees);
        pos[2] += 5.0; // Поднимаем воздушный транспорт выше
        
        new vehicleid = CreateVehicle(modelid, pos[0], pos[1], pos[2], pos[3], 0, 0, 300, 0);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Не удалось создать транспортное средство!");
            return 1;
        }
        
        PlayerVehicle[playerid] = vehicleid;
        VehicleLocked[vehicleid] = true;
        
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST,
            "Выбор цвета",
            "Белый\nСерый\nСиний\nКрасный\nЗеленый\nКамуфляж",
            "Выбрать", "Назад");
        return 1;
    }

    case DIALOG_BIKES:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        
        if(PlayerVehicle[playerid] != 0)
        {
            DestroyVehicle(PlayerVehicle[playerid]);
            PlayerVehicle[playerid] = 0;
        }
        
        new modelid;
        switch(listitem)
        {
            case 0: modelid = 448; // Pizzaboy
            case 1: modelid = 461; // Ducati SuperSport S
            case 2: modelid = 462; // Racer Sport
            case 3: modelid = 463; // Ducati XDiavel S
            case 4: modelid = 468; // Aprilia MXV 450
            case 5: modelid = 521; // BMW S 1000 RR
            case 6: modelid = 522; // Kawasaki Ninja H2R
            case 7: modelid = 523; // Yamaha FZ-10
            case 8: modelid = 581; // Suzuki GSX-R750
            case 9: modelid = 586; // Yamaha FZ-R6
            case 10: modelid = 481; // Велосипед Аист (Вело)
            default: return 1;
        }
        
        pos[0] += 2.0 * floatsin(-pos[3], degrees);
        pos[1] += 2.0 * floatcos(-pos[3], degrees);
        
        new vehicleid = CreateVehicle(modelid, pos[0], pos[1], pos[2], pos[3], 0, 0, 300, 0);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Не удалось создать транспортное средство!");
            return 1;
        }
        
        PlayerVehicle[playerid] = vehicleid;
        VehicleLocked[vehicleid] = true;
        
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST,
            "Выбор цвета",
            "Черный\nБелый\nКрасный\nСиний\nЖелтый\nЗеленый\nОранжевый",
            "Выбрать", "Назад");
        return 1;
    }

    case DIALOG_BUSES:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        
        if(PlayerVehicle[playerid] != 0)
        {
            DestroyVehicle(PlayerVehicle[playerid]);
            PlayerVehicle[playerid] = 0;
        }
        
        new modelid;
        switch(listitem)
        {
            case 0: modelid = 413; // Gazelle 3221
            case 1: modelid = 414; // Gaz Vector Next
            case 2: modelid = 418; // Volkswagen Multivan T6
            case 3: modelid = 431; // Лиаз 677
            case 4: modelid = 437; // Икарус
            case 5: modelid = 440; // Mercedes-Benz V-Class W447
            case 6: modelid = 456; // Gazelle 3310
            default: return 1;
        }
        
        pos[0] += 4.0 * floatsin(-pos[3], degrees);
        pos[1] += 4.0 * floatcos(-pos[3], degrees);
        
        new vehicleid = CreateVehicle(modelid, pos[0], pos[1], pos[2], pos[3], 0, 0, 300, 0);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Не удалось создать транспортное средство!");
            return 1;
        }
        
        PlayerVehicle[playerid] = vehicleid;
        VehicleLocked[vehicleid] = true;
        
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST,
            "Выбор цвета",
            "Белый\nСиний\nКрасный\nЖелтый\nЗеленый\nСерый",
            "Выбрать", "Назад");
        return 1;
    }

    case DIALOG_CATEGORIES:
    {
        if(!response) return 1;
        
        switch(listitem)
        {
            case 0: // Гражданские авто
            {
                ShowPlayerDialog(playerid, DIALOG_CIVILIAN, DIALOG_STYLE_LIST,
                    "Гражданский транспорт",
                    "BMW X6M F16\nVAZ 2101\nMercedes-Benz GT63s (Акула)\nВАЗ 2107\nAudi RS6\nMercedes-Benz C63s AMG\nAston Martin DB11\nLamborghini Aventador S\nMercedes-Benz E420 W210\nMercedes-Benz W124\nBMW M5 E39\nMercedes-Benz GT-R\nMitsubishi Lancer Evo X\nVolvo V60\nAcura TSX\nMcLaren 600LT\nVAZ 2114\nBMW M5 F90\nMercedes-Benz S600 W140\nAudi Q8\nMazda RX-7\nBMW Z4 M40i\nVolvo XC90\nRange Rover SVR\nBMW I8 Edrive\nFord Raptor F-150\nVolkswagen Golf GTI2\nNissan GT-R R35\nDodge Demon SRT\nCadillac Escalade\nPorsche 911 Carrera S\nAudi A4\nVolkswagen Polo\nInfiniti Q60S\nBMW M3 E46\nVAZ 2170\nAudi R8 V10\nBMW M3 E30\nVolvo 242DL\nMazda Sedan 3\nFerrari 488 GTB\nNiva Urban\nChevrolet Camaro ZL1\nVAZ 1111\nToyota Camry 3.5\nAlfa Romeo Giulia\nZAZ 968\nBMW M4 F84\nToyota Mark II\nSubaru WRX STI\nNissan Skyline R34\nMercedes-Benz A45 AMG\nMercedes-Benz G65 AMG\nVAZ 2115\nFord Focus RS\nVolkswagen Golf GTI\nFord Mustang GT\nPorsche Panamera S\nAudi RS-7 Sport\nMercedes-Benz E46S\nLada Vesta Sedan\nLamborghini Huracan\nMercedes-Benz GLS 400\nLamborghini Urus\nToyota Supra A80\nAudi Q7\nJeep Grand Cherokee\nLada Granta\nLada Vesta SW Cross\nMercedes-Benz Maybach S650\nCadillac Escalade (новый)\nRenault Logan\nKia Rio 2020\nBMW M5 E60\nBMW X5 E53\nBugatti La Noire\nBugatti Divo\nReasr Tachyon 2019\nMercedes-Benz G63 AMG\nBMW X7 M50i\nLexus LX570\nBMW M8 F92\nBMW M8 F93 Gran Coupe\nBMW 7-Series E38\nPorsche Taycan Turbo S\nMercedes-Benz CLS63 AMG\nRolls-Royce Wraith\nKIA K5\nMercedes-Benz 300SL Coupe\nJaguar XK120 Roadster\nTesla model X\nTesla model S\nUAZ Patriot\nUAZ Patriot Pickup\nRolls-Royce Phantom\nRolls-Royce Cullinan\nBMW M3 G81\nFerrari LaFerrari\nChevrolet 3100 Tow Truck\nLamborghini Murcielago\nDodge Ice Charger\nFORD FALCON XB\nSmart Fortwo 2\nChevrolet Bel Air\nToyota Tundra Nascar\nLamborghini LM002\nЛуАЗ-969\nVolkswagen Touareg\nBMW M5 F10\nDodge Charger SRT\nMazda RX-8\nFlanker F\nFerrari Enzo",
                    "Выбрать", "Назад");
            }
            case 1: // Фракционный транспорт
            {
                ShowPlayerDialog(playerid, DIALOG_FACTION, DIALOG_STYLE_LIST,
                    "Фракционный транспорт",
                    "BMW M5 F90 ППС\nВАЗ 2170 ППС\nVolkswagen Jetta ППС\nMercedes-Benz Sprinter ППС\nVAZ 2115\nMercedes-Benz Sprinter Дальнобой\nGazelle 3221 (ФСИН)\nGazon Next (Армия)\nУАЗ мил (Полиция)\nMercedes-Benz Sprinter (ЦБ)\nBMW M5 F90 (Такси)\nVolkswagen Jetta (Такси)\nGazelle 3310 (ФСИН)\nUAZ Patriot (ФСИН)\nMercedes-Benz V-Class (Инкассация)\nVolkswagen Multivan T6 (Инкассация)\nGazelle 3221 (Инкассация)\nПожарка",
                    "Выбрать", "Назад");
            }
            case 2: // Спецтранспорт
            {
                ShowPlayerDialog(playerid, DIALOG_SPECIAL, DIALOG_STYLE_LIST,
                    "Специальный транспорт",
                    "СМЗ\nRCcar\nPizzaboy\nГольф кар\nRCheli\nRCplane\nGaz Tigr\nКвадроцикл\nБульдозер\nRCgobl\nТруповоз\nМонстр\nRCtank (Танк)\nБагги\nКарт\nRCcam\nБРДМ",
                    "Выбрать", "Назад");
            }
            case 3: // Водный транспорт
            {
                ShowPlayerDialog(playerid, DIALOG_WATER, DIALOG_STYLE_LIST,
                    "Водный транспорт",
                    "Dinghy\nReefer\nЯхта\nВодный самолёт\nТеплоход\nJetmax\nPredator\nSqualo\nSpeeder\nCoastguard\nВоздушная Подушка\nLaunch",
                    "Выбрать", "Назад");
            }
            case 4: // Воздушный транспорт
            {
                ShowPlayerDialog(playerid, DIALOG_AIR, DIALOG_STYLE_LIST,
                    "Воздушный транспорт",
                    "Leviathan\nHunter\nВодный вертолет\nВодный самолёт\nИстребитель (ВОВ)\nSparrow\nВертолёт\nNews Вертолёт\nПолицейский вертолёт\nBeagle\nCropduster\nStunt\nShamal\nИстребитель\nВоенный вертолёт\nКукурузник\nСпасательный вертолёт\nAT 400\nAndrom\nDodo",
                    "Выбрать", "Назад");
            }
            case 5: // Мотоциклы
            {
                ShowPlayerDialog(playerid, DIALOG_BIKES, DIALOG_STYLE_LIST,
                    "Мотоциклы",
                    "Pizzaboy\nDucati SuperSport S\nRacer Sport\nDucati XDiavel S\nAprilia MXV 450\nBMW S 1000 RR\nKawasaki Ninja H2R\nYamaha FZ-10\nSuzuki GSX-R750\nYamaha FZ-R6\nВелосипед Аист",
                    "Выбрать", "Назад");
            }
            case 6: // Автобусы
            {
                ShowPlayerDialog(playerid, DIALOG_BUSES, DIALOG_STYLE_LIST,
                    "Автобусы и микроавтобусы",
                    "Gazelle 3221\nGaz Vector Next\nVolkswagen Multivan T6\nЛиаз 677\nИкарус\nMercedes-Benz V-Class W447\nGazelle 3310",
                    "Выбрать", "Назад");
            }
            case 7: // Габаритные авто
            {
                ShowPlayerDialog(playerid, DIALOG_LARGE, DIALOG_STYLE_LIST,
                    "Габаритные авто",
                    "ЗИЛ 131 Самосвал\nТанк\nМонстр\nКомбайн",
                    "Выбрать", "Назад");
            }
        }
        return 1;
    }

    case DIALOG_COLORS:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new vehicleid = PlayerVehicle[playerid];
        if(vehicleid != 0)
        {
            switch(listitem)
            {
                case 0: ChangeVehicleColor(vehicleid, 0, 0); // Черный
                case 1: ChangeVehicleColor(vehicleid, 1, 1); // Белый
                case 2: ChangeVehicleColor(vehicleid, 3, 3); // Красный
                case 3: ChangeVehicleColor(vehicleid, 16, 16); // Зеленый
                case 4: ChangeVehicleColor(vehicleid, 2, 2); // Синий
                case 5: ChangeVehicleColor(vehicleid, 84, 84); // Синий металлик
                case 6: ChangeVehicleColor(vehicleid, 76, 76); // Красный металлик
                case 7: ChangeVehicleColor(vehicleid, 4, 4); // Серебристый
                case 8: ChangeVehicleColor(vehicleid, 123, 123); // Золотой
                case 9: ChangeVehicleColor(vehicleid, 79, 79); // Синий (полиция)
                case 10: ChangeVehicleColor(vehicleid, 77, 77); // Красный (пожарная)
                case 11: ChangeVehicleColor(vehicleid, 43, 43); // Камуфляж
                case 12: ChangeVehicleColor(vehicleid, 6, 6); // Желтый
                case 13: ChangeVehicleColor(vehicleid, 36, 36); // Оранжевый
                case 14: ChangeVehicleColor(vehicleid, 53, 53); // Серый
            }
        }
        return 1;
    }

    case DIALOG_LARGE:
    {
        if(!response) return ShowVehicleMenu(playerid);
        
        new Float:pos[4];
        GetPlayerPos(playerid, pos[0], pos[1], pos[2]);
        GetPlayerFacingAngle(playerid, pos[3]);
        
        if(PlayerVehicle[playerid] != 0)
        {
            DestroyVehicle(PlayerVehicle[playerid]);
            PlayerVehicle[playerid] = 0;
        }
        
        new modelid;
        switch(listitem)
        {
            case 0: modelid = 406; // ЗИЛ 131 Самосвал
            case 1: modelid = 432; // Танк
            case 2: modelid = 444; // Монстр
            case 3: modelid = 532; // Комбайн
            default: return 1;
        }  
        
        pos[0] += 5.0 * floatsin(-pos[3], degrees);
        pos[1] += 5.0 * floatcos(-pos[3], degrees);
        
        new vehicleid = CreateVehicle(modelid, pos[0], pos[1], pos[2], pos[3], 0, 0, 300, 0);
        if(vehicleid == INVALID_VEHICLE_ID)
        {
            SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Не удалось создать транспортное средство!");
            return 1;
        }
        
        PlayerVehicle[playerid] = vehicleid;
        VehicleLocked[vehicleid] = true;
        
        SetVehicleVirtualWorld(vehicleid, GetPlayerVirtualWorld(playerid));
        LinkVehicleToInterior(vehicleid, GetPlayerInterior(playerid));
        
        PutPlayerInVehicle(playerid, vehicleid, 0);
        
        ShowPlayerDialog(playerid, DIALOG_COLORS, DIALOG_STYLE_LIST,
            "Выбор цвета",
            "Желтый\nОранжевый\nКрасный\nЗеленый\nСерый\nКамуфляж",
            "Выбрать", "Назад");
        return 1;
        }
    }
        #if defined include_OnDialogResponse
        return include_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse include_OnDialogResponse
#if defined include_OnDialogResponse
forward include_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif