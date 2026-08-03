/*


                --- --- --- КОДЫ КИКОВ --- --- ---

    1. KICK_CODE: 21 - Превышение максимальной скорости на автомобиле

               --- --- --- НА ЭТОМ ВСЕ --- --- ---


*/

static ac_PreviousPos[MAX_PLAYERS][3];
//#define COLOR_ADMIN_DEBUG 0xFF9900FF олд цвет + сделал так что-бы легко менять
#define COLOR_ADMIN_DEBUG 0x006400FF // темно зелёный

new ac_PlayerConnectTime[MAX_PLAYERS];
new ac_PlayerSpawnTime[MAX_PLAYERS];

#if defined _ALS_SetPlayerPos
    #undef SetPlayerPos
#else
    #define _ALS_SetPlayerPos
#endif
#define SetPlayerPos __ALS_SetPlayerPos
forward __ALS_SetPlayerPos(playerid, Float:x, Float:y, Float:z);

public __ALS_SetPlayerPos(playerid, Float:x, Float:y, Float:z)
{
    ac_PreviousPos[playerid][0] = floatround(x);
    ac_PreviousPos[playerid][1] = floatround(y);
    ac_PreviousPos[playerid][2] = floatround(z);

    SetPVarInt(playerid, "IsTeleporting", 1);
    
    #undef SetPlayerPos
    SetPlayerPos(playerid, x, y, z);
    #define SetPlayerPos __ALS_SetPlayerPos
    return 1;
}

// --- решил убрать, и вшил SetPlayerPosEx

public OnPlayerConnect(playerid)
{
    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);

    SetPVarInt(playerid, "IsTeleporting", 0);

    ac_PreviousPos[playerid][0] = floatround(x);
    ac_PreviousPos[playerid][1] = floatround(y);
    ac_PreviousPos[playerid][2] = floatround(z);

    ac_PlayerConnectTime[playerid] = gettime();

    SetTimerEx("CheckPlayer", 1000, true, "i", playerid);

    #if defined anticheat_OnPlayerConnect
        return anticheat_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect anticheat_OnPlayerConnect
#if defined anticheat_OnPlayerConnect
    forward anticheat_OnPlayerConnect(playerid);
#endif

public OnPlayerSpawn(playerid)
{
    SetPVarInt(playerid, "IsTeleporting", 0);

    new Float:x, Float:y, Float:z;
    GetPlayerPos(playerid, x, y, z);
    ac_PreviousPos[playerid][0] = floatround(x);
    ac_PreviousPos[playerid][1] = floatround(y);
    ac_PreviousPos[playerid][2] = floatround(z);

    ac_PlayerSpawnTime[playerid] = gettime();

    #if defined anticheat_OnPlayerSpawn
        return anticheat_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerSpawn
    #undef OnPlayerSpawn
#else
    #define _ALS_OnPlayerSpawn
#endif
#define OnPlayerSpawn anticheat_OnPlayerSpawn
#if defined anticheat_OnPlayerSpawn
    forward anticheat_OnPlayerSpawn(playerid);
#endif

forward CheckPlayer(playerid);
public CheckPlayer(playerid)
{
    if(GetPlayerAdminEx(playerid) <= 0)
    {
        if(!IsPlayerInAnyVehicle(playerid)) return 1;//CheckAirBrake(playerid);
        else CheckVehicleSpeed(playerid);
    }
    else return 1;
}

stock CheckAirBrake(playerid)
{
    new current_time = gettime();
    if(current_time - ac_PlayerConnectTime[playerid] < 20 || current_time - ac_PlayerSpawnTime[playerid] < 5)
    {
        new Float:currentX, Float:currentY, Float:currentZ;
        GetPlayerPos(playerid, currentX, currentY, currentZ);
        ac_PreviousPos[playerid][0] = floatround(currentX);
        ac_PreviousPos[playerid][1] = floatround(currentY);
        ac_PreviousPos[playerid][2] = floatround(currentZ);
        return 1;
    }

    new Float:currentX, Float:currentY, Float:currentZ;
    GetPlayerPos(playerid, currentX, currentY, currentZ);

    new Float:previousX = float(ac_PreviousPos[playerid][0]);
    new Float:previousY = float(ac_PreviousPos[playerid][1]);
    new Float:previousZ = float(ac_PreviousPos[playerid][2]);

    new Float:distance = floatsqroot(floatpower(currentX - previousX, 2.0) + floatpower(currentY - previousY, 2.0) + floatpower(currentZ - previousZ, 2.0));

    new isTeleporting = GetPVarInt(playerid, "IsTeleporting");
    if(isTeleporting == 1) return SetPVarInt(playerid, "IsTeleporting", 0);

    if(distance > 12.0)
    {
        new message[128];
        format(message, sizeof(message), "SAVA-CORE{ffffff}: Игрок: [%d] %s {ffffff}Подозрение на AirBrake", playerid, GetPlayerNameEx(playerid));
        SendMessageToAdmins(message, COLOR_ADMIN_DEBUG);
    }
    ac_PreviousPos[playerid][0] = floatround(currentX);
    ac_PreviousPos[playerid][1] = floatround(currentY);
    ac_PreviousPos[playerid][2] = floatround(currentZ);
    return 1;
}

stock CheckVehicleSpeed(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    new modelid = GetVehicleData(vehicleid, V_MODELID);
    new max_speed_kph = GetVehicleMaxSpeed(modelid);
    //new vehicle_name = GetVehicleInfo(modelid - 400, VI_NAME);

    if(max_speed_kph <= 0) max_speed_kph = 225;

    new current_speed_kph = GetSpeedKMH(playerid); // работает и на игрока и на машины

    new message_suffix[64];
    
    // Если макс скорость авто 300, то это кастомная модель у которой нету установленной скорости
    if(max_speed_kph == 225)
    {
        format(message_suffix, sizeof(message_suffix), "(примерная макс: %d)", max_speed_kph);
    }
    else
    {
        format(message_suffix, sizeof(message_suffix), "(максимально: %d)", max_speed_kph);
    }

    new player_name[MAX_PLAYER_NAME]; GetPlayerName(playerid, player_name, sizeof(player_name));

    // больше 400 ехать нельзя (нету авто которое может так разогнаться)
    if(current_speed_kph >= 400)
    {
        new message[356];
        format(message, sizeof(message), "SAVA-CORE{ffffff}: Игрок: {ff0000}[%d] %s {ffffff}Едет со скоростью: {ff0000}%d км/ч (более допустимого максимума!) на автомобиле: %s %s", playerid, player_name, current_speed_kph, GetVehicleInfo(modelid - 400, VI_NAME), message_suffix);
        SendMessageToAdmins(message, COLOR_ADMIN_DEBUG);
        
        Kick_cheat(playerid, 21);

        new kick_message[256]; 
        format(kick_message, sizeof(kick_message), "SAVA-CORE{ffffff}: Игрок: [%d] %s {ffffff}был кикнут из-за большого превышения скорости (Подозрение на чит)", playerid, player_name);
        SendMessageToAdmins(kick_message, COLOR_ADMIN_DEBUG);
        
        SendMessageToAdmins("KICK_CODE{ffffff}: 21", COLOR_ADMIN_DEBUG);
    }
    else if(current_speed_kph > max_speed_kph + 30)
    {
        new message[356];
        format(message, sizeof(message), "SAVA-CORE{ffffff}: Игрок: [%d] %s {ffffff}Едет со скоростью: %d км/ч (более 30 км/ч от максимума) на автомобиле: %s %s", playerid, player_name, current_speed_kph, GetVehicleInfo(modelid - 400, VI_NAME), message_suffix);
        SendMessageToAdmins(message, COLOR_ADMIN_DEBUG);
        
        Kick_cheat(playerid, 21);

        new kick_message[256]; 
        format(kick_message, sizeof(kick_message), "SAVA-CORE{ffffff}: Игрок: [%d] %s {ffffff}был кикнут из-за большого превышения скорости (Подозрение на чит)", playerid, player_name);
        SendMessageToAdmins(kick_message, COLOR_ADMIN_DEBUG);
        
        SendMessageToAdmins("KICK_CODE{ffffff}: 21", COLOR_ADMIN_DEBUG);
    }
    else if(current_speed_kph > max_speed_kph + 15)
    {
        new exceed_speed = current_speed_kph - max_speed_kph;

        new message[456];
        format(message, sizeof(message), "SAVA-CORE{ffffff}: Игрок: [%d] %s {ffffff}Превысил скорость автомобиля: %s приблизительно на %d км/ч %s", playerid, player_name, GetVehicleInfo(modelid - 400, VI_NAME), exceed_speed, message_suffix);

        SendMessageToAdmins(message, COLOR_ADMIN_DEBUG);
    }

    return 1;
}

stock GetSpeedKMH(playerid)
{
    new Float:ST[4];
    if(IsPlayerInAnyVehicle(playerid))
    {
        GetVehicleVelocity(GetPlayerVehicleID(playerid),ST[0],ST[1],ST[2]);
    }
    else 
    {
        GetPlayerVelocity(playerid,ST[0],ST[1],ST[2]);
    }

    ST[3] = floatsqroot(floatpower(floatabs(ST[0]), 2.0) + floatpower(floatabs(ST[1]), 2.0) + floatpower(floatabs(ST[2]), 2.0)) * 100.3;

    if(IsPlayerInAnyVehicle(playerid))
    {
        new current_speed_kph = floatround(ST[3]);
        if(current_speed_kph >= 50 && current_speed_kph <= 99) return current_speed_kph + 20;
        else if(current_speed_kph >= 100 && current_speed_kph <= 199) return current_speed_kph + 50;
        else if(current_speed_kph >= 200 && current_speed_kph <= 299) return current_speed_kph + 116;
        else if(current_speed_kph >= 300 && current_speed_kph <= 399) return current_speed_kph + 132;
    }
    return floatround(ST[3]);
}
/*stock GetSpeedKMH(playerid)
{
    new Float:vx, Float:vy, Float:vz;
    new vehicleid = GetPlayerVehicleID(playerid);

    if(IsPlayerInAnyVehicle(playerid) && IsValidVehicle(vehicleid))
    {
        GetVehicleVelocity(vehicleid, vx, vy, vz);
    }
    else if(IsPlayerConnected(playerid))
    {
        GetPlayerVelocity(playerid, vx, vy, vz);
    }
    else return 0;
    
    new Float:speed = floatsqroot(vx*vx + vy*vy + vz*vz) * 181.0;

    if(speed < 0.0) speed = 0.0;
    
    return floatround(speed);
}*/

stock GetVehicleMaxSpeed(modelid)
{
    switch(modelid)
    {
        // ID 400 - 450
        case 400: return 284;  // BMW X6M F16
        case 401: return 142;  // VAZ 2101
        case 402: return 313;  // Mercedes-Benz GT63s
        case 403: return 150;  // Renault Premium
        case 404: return 158;  // VAZ 2107
        case 405: return 310;  // Audi RS6 C7
        case 406: return 0;    // ЗИЛ 131 Самосвал
        case 407: return 0;    // Пожарка
        case 408: return 0;    // Мусоровоз
        case 409: return 0;    // Лимузин
        case 410: return 305;  // Mercedes-Benz C63s
        case 411: return 322;  // Bugatti Chiron
        case 412: return 160;  // VAZ 2106
        case 413: return 130;  // Gazelle 3221
        case 414: return 0;    // Автобус
        case 415: return 351;  // Lamborghini Aventador S
        case 416: return 0;    // Скорая
        case 417: return 0;    // Leviathn
        case 418: return 183;  // Volkswagen Multivan T6
        case 419: return 250;  // Mercedes-Benz E420 W210
        case 420: return 0;    // BMW M5 E60
        case 421: return 250;  // Mercedes-Benz S600 W140
        case 422: return 0;    // Копия
        case 423: return 0;    // MrWhoop
        case 424: return 0;    // CMЗ
        case 425: return 0;    // Hunter
        case 426: return 246;  // BMW M5 E39
        case 427: return 0;    // Инкасатор
        case 428: return 0;    // Инкасатор
        case 429: return 319;  // Mercedes-Benz GT-R
        case 430: return 0;    // Predator
        case 431: return 0;    // Лиаз 677
        case 432: return 0;    // Танк
        case 433: return 0;    // Военный автобус
        case 434: return 0;    // Hotknife
        case 435: return 0;    // Прицеп
        case 436: return 239;  // Mitsubishi Lancer Evo X
        case 437: return 0;    // Икарус
        case 438: return 0;    // Такси
        case 439: return 160;  // VAZ 2108
        case 440: return 205;  // Mercedes-Benz V-Class W447
        case 441: return 0;    // RCcar
        case 442: return 235;  // Volvo V60
        case 443: return 0;    // Автовоз
        case 444: return 0;    // Монстр
        case 445: return 256;  // Acura TSX
        case 446: return 0;    // Squalo
        case 447: return 0;    // Водный верт
        case 448: return 0;    // Pizzaboy
        case 449: return 0;    // Прицеп
        case 450: return 0;    // краш
        
        // ID 451 - 500
        case 451: return 329;  // McLaren 600LT
        case 452: return 0;    // Speeder
        case 453: return 0;    // Reefer
        case 454: return 0;    // Яхта
        case 455: return 0;    // Грейдер
        case 456: return 0;    // фсин
        case 457: return 0;    // Гольф кар
        case 458: return 160;  // VAZ 2114
        case 459: return 0;    // инко
        case 460: return 0;    // Водн самолет
        case 461: return 240;  // Ducati SuperSport S
        case 462: return 130;  // Racer Sport
        case 463: return 260;  // Ducati XDiavel S
        case 464: return 0;    // RCplane
        case 465: return 0;    // RCheli
        case 466: return 312;  // BMW M5 F90
        case 467: return 250;  // Mercedes-Benz S600 W140
        case 468: return 200;  // Aprilla MXV 450
        case 469: return 0;    // Sparrow
        case 470: return 0;    // ГАЗ Тигр
        case 471: return 0;    // Квадроцикл
        case 472: return 0;    // Coastg
        case 473: return 0;    // Dinghy
        case 474: return 0;    // Toyota Camry 2016
        case 475: return 238;  // Audi Q7
        case 476: return 0;    // Истребитель
        case 477: return 249;  // Mazda RX-7
        case 478: return 0;    // Lexus Lx500
        case 479: return 170;  // GAZ Volga 2410
        case 480: return 259;  // BMW Z4 M40i
        case 481: return 0;    // Велосипед Аист
        case 482: return 0;    // инко
        case 483: return 182;  // Mercedes-Benz Sprinter 319CDL
        case 484: return 0;    // Теплоход
        case 485: return 0;    // Газ Аэро
        case 486: return 0;    // Бульдозер
        case 487: return 0;    // Верт
        case 488: return 0;    // News Верт
        case 489: return 248;  // Volvo XC90
        case 490: return 262;  // Range Rover SVR
        case 491: return 160;  // VAZ 2110
        case 492: return 162;  // VAZ 2109
        case 493: return 0;    // Jetmax
        case 494: return 320;  // BMW I8 EDrive
        case 495: return 211;  // Ford Raptor F-150
        case 496: return 197;  // Volkswagen Golf GTI2
        case 497: return 0;    // Пол Верт
        case 498: return 137;  // Mercedes-Benz Sprinter
        case 499: return 0;    // ГАЗ 53
        case 500: return 0;    // ГАЗ 69

        // ID 501 - 550
        case 501: return 0;    // RCgobl
        case 502: return 319;  // Nissan GT-R R35
        case 503: return 322;  // Dodge Demon SRT
        case 504: return 0;    // Bloodra
        case 505: return 248;  // Cadillac Escalade
        case 506: return 309;  // Porsche 911 Carrera S
        case 507: return 238;  // Audi A4
        case 508: return 0;    // УАЗ Буханка
        case 509: return 0;    // Велосипед 'Урал'
        case 510: return 0;    // Горный Велосипед
        case 511: return 0;    // Beagle
        case 512: return 0;    // Cropdast
        case 513: return 0;    // Stunt
        case 514: return 0;    // Камаз 54115
        case 515: return 0;    // КАЗ
        case 516: return 238;  // Volkswagen Polo
        case 517: return 261;  // BMW M5 Competition Asco
        case 518: return 351;  // Bugatti La Noire
        case 519: return 0;    // Shamal
        case 520: return 0;    // Истребитель
        case 521: return 295;  // BMW S 1000 RR
        case 522: return 340;  // Kawasaki Ninja H2R
        case 523: return 257;  // Yamaha FZ-10
        case 524: return 0;    // Цементовоз
        case 525: return 0;    // Эвакуатор
        case 526: return 266;  // Infiniti Q60S
        case 527: return 246;  // BMW M3 E46
        case 528: return 0;    // Труповоз
        case 529: return 183;  // VAZ 2172
        case 530: return 0;    // Погрузщик
        case 531: return 0;    // Трактор
        case 532: return 0;    // Комбайн
        case 533: return 322;  // Audi R8 V10
        case 534: return 239;  // BMW M3 E30
        case 535: return 0;    // Bugatti Divo
        case 536: return 176;  // Volvo 242DL
        case 537: return 0;    // Поезд
        case 538: return 0;    // Поезд
        case 539: return 0;    // Возд Подушка
        case 540: return 218;  // Mazda Sedan 3
        case 541: return 336;  // Ferrari 488 GTB
        case 542: return 140;  // Niva Urban
        case 543: return 315;  // Chevrolette Camaro ZL1
        case 544: return 0;    // Пожарка
        case 545: return 261;  // Rolls-Royce Wraith
        case 546: return 200;  // Hyundai Solaris 2021
        case 547: return 223;  // VAZ 2112
        case 548: return 0;    // Воен Верт
        case 549: return 120;  // VAZ 1111
        case 550: return 247;  // Toyota Camry 3.5

        // ID 551 - 600
        case 551: return 306;  // Alfa Romeo Gullia
        case 552: return 223;  // Mercedes-Benz G63 AMG
        case 553: return 0;    // Кукурузник
        case 554: return 238;  // BMW M8 F92
        case 555: return 118;  // ZAZ 968
        case 556: return 0;    // Монстр
        case 557: return 0;    // Монстр
        case 558: return 261;  // BMW M4 F84
        case 559: return 0;    // то же, что и 547
        case 560: return 246;  // Subaru WRX STI
        case 561: return 0;    // Москвич 427
        case 562: return 250;  // Nissan Skyline R34
        case 563: return 260;  // Mercedes-Benz 300SL Coupe
        case 564: return 0;    // RCtank
        case 565: return 250;  // Mercedes-Benz A45 AMG
        case 566: return 250;  // BMW M5 E60
        case 567: return 0;    // Savana
        case 568: return 0;    // Bandito
        case 569: return 0;    // Вагон
        case 570: return 0;    // Вагон
        case 571: return 0;    // Карт
        case 572: return 0;    // Газонокосилка
        case 573: return 0;    // Ралли Грузовик
        case 574: return 0;    // Уборщ улиц
        case 575: return 0;    // BMW (Лупарик)
        case 576: return 0;    // BMW M5 F10
        case 577: return 0;    // AT 400
        case 578: return 305;  // Raesr Tachyon 2019
        case 579: return 223;  // Mercedes-Benz G65 AMG
        case 580: return 351;  // Bugatti Divo
        case 581: return 276;  // Suzuki GSX-R750
        case 582: return 0;    // СМИ Фург
        case 583: return 250;  // Hummer Humvee
        case 584: return 0;    // Цистерна
        case 585: return 160;  // VAZ 2115
        case 586: return 260;  // Yamaha YZF-R6
        case 587: return 265;  // Ford Focus RS
        case 588: return 140;  // Daewoo Matiz
        case 589: return 250;  // Volkswagen Golf GTI
        case 590: return 0;    // Вагон
        case 591: return 0;    // Прицеп
        case 592: return 0;    // Androm
        case 593: return 0;    // Dodo
        case 594: return 0;    // RCcam
        case 595: return 0;    // Launch
        case 596: return 305;  // BMW M5 F90 (ППС)
        case 597: return 305;  // VAZ 2172 (ППС)
        case 598: return 305;  // Volkswagen Polo (ППС)
        case 599: return 200;  // ИЖ Юпитер
        case 600: return 261;  // Rolls-Royce Cullinan
        
        // ID 601 - 611
        case 601: return 0;    // БДРМ
        case 602: return 238;  // Rolls-Royce Phantom
        case 603: return 277;  // Ford Mustang GT
        case 604: return 310;  // Porsche Panamera S
        case 605: return 262;  // Mercedes-Benz Maybach S650
        case 606: return 0;    // Прицеп
        case 607: return 0;    // Прицеп
        case 608: return 0;    // Лестница
        case 609: return 0;    // Авиа
        case 610: return 0;    // Плуг
        case 611: return 0;    // Прицеп уборщ
         
        // new vehicle
        case 2551: return 303;   // Lamborghini Urus
        // --- --- --- ---
        case 2563: return 263;   // Rolls-Royce Phantom
        case 2564: return 260;   // Rolls-Royce Cullinan
        // --- --- --- ---
        case 2569: return 378;   // Bugatti La Noire
        //case 2569: return 100; это было для теста чита
        case 2570: return 380;   // Bugatti Divo
    }
    if(modelid > 611) return 225; // это если айди модели больше 611 и не = new vehicle
}

stock Kick_cheat(playerid, code)
{
    SendClientMessage(playerid, 0xFF5533FF, "Вы были кикнуты по подозрению использования стороннего ПО");
    SendClientMessage(playerid, 0x999999FF, "Вы были отключены от сервера.");
    SendClientMessage(playerid, 0x999999FF, "Вы были отключены от голосового чата.");

    new message[256];
 
    format(message, sizeof(message), "{ffffff}Вы были кикнуты по подозрению использования стороннего ПО\n"\
        "Если Вы были кикнуты - без причины, пожалуйста обратитесь на форум в технический раздел.\n\n"\
        "{ffffff}Код: {ffff00}%d \n"\
        "{ffffff}Ping: {ffff00}%d", code, GetPlayerPing(playerid));

    ShowPlayerDialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{ff0000}Anti-Cheat", message, "Закрыть", "");
    SetTimerEx("OnPlayerKickedCheat", 2000, false, "i", playerid);
    return 1;
}

forward OnPlayerKickedCheat(playerid);
public OnPlayerKickedCheat(playerid) return Kick(playerid);