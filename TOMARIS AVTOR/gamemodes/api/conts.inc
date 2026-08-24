#define MAX_CONT 12

// Константы для цветов
#define CLR_RED 0xFF0000FF
#define CLR_GREEN 0x00FF00FF
#define CLR_YELLOW 0xFFFF00FF
#define CLR_WHITE 0xFFFFFFFF

#define DIALOG_CONT_BET 19996

// структура для информации о призах
enum PrizeInfo
{
    PRIZE_REGION,        // Регион приза
    PRIZE_ID,            // ID скина или модели ТС
    PRIZE_NAME[64],      // Имя приза
    PRIZE_PRICE,         // Цена приза
};

// для информации о контейнере
enum Cont_Info
{
    ContObjectId,
    ContObjectDoorLId,
    ContObjectDoorRId,
    ContObjectOdejdaId,
    ContVehicleId,
    ContVehicleColor,

    ContRegion,
    ItemType,
    Item,
    ContPrice,
    ItemPrice,
    
    bool:Saled,
    SaleTime,

    BetPrice,
    BetedId,
    BetedName[MAX_PLAYER_NAME],
};
new cInfo[MAX_CONT + 1][Cont_Info]; // +1, так как индексы используются с 1 до MAX_CONT

enum P_Info
{
    BetUseCont,
    BuyUseCont,
}
new pInfo[MAX_PLAYERS][P_Info];
new Text3D:ContsText[MAX_CONT + 1];
new ContsZone[MAX_CONT + 1];
new ContsTimer[MAX_CONT + 1];

new Text:cont_fon;
new Text:cont_take;
new Text:cont_sell;
new Text:cont_close;
new Text:cont_name[MAX_CONT + 1];
new Text:cont_price[MAX_CONT + 1];
new Text:cont_model[MAX_CONT + 1];

enum RegionPrizes {
    REGION_RUSSIA = 1,
    REGION_CHINA,
    REGION_DUBAI,
    REGION_GERMANY
};
new const cSkin_Info[][PrizeInfo] = {
    // Россия
    {REGION_RUSSIA, 152, "Одежда", 236000},
    {REGION_RUSSIA, 240, "Одежда", 90000},
    {REGION_RUSSIA, 182, "Одежда", 175000},
    {REGION_RUSSIA, 85, "Одежда", 36000},
    {REGION_RUSSIA, 7, "Одежда", 45000},
    {REGION_RUSSIA, 91, "Одежда", 38610},
    {REGION_RUSSIA, 56, "Одежда", 105300},
    {REGION_RUSSIA, 122, "Одежда", 1000000},
    {REGION_RUSSIA, 75, "Одежда", 500000},
    {REGION_RUSSIA, 66, "Одежда", 133333},
    {REGION_RUSSIA, 45, "Одежда", 80000},
    {REGION_RUSSIA, 78, "Одежда", 50000},

    // Дубай
    {REGION_DUBAI, 300, "Одежда", 1000000},
    {REGION_DUBAI, 211, "Одежда", 5000000},
    {REGION_DUBAI, 99, "Одежда", 3500000},
    {REGION_DUBAI, 102, "Одежда", 600000},
    {REGION_DUBAI, 125, "Одежда", 1000000},
    {REGION_DUBAI, 101, "Одежда", 3850000}
};
new const cCar_Info[][PrizeInfo] = {
    // Россия
    {REGION_RUSSIA, 404, "VAZ 2107", 50000},
    {REGION_RUSSIA, 555, "ZAZ 968", 20000},
    {REGION_RUSSIA, 401, "VAZ 2101", 42000},
    {REGION_RUSSIA, 401, "Lada Granta", 320000},
    {REGION_RUSSIA, 413, "Gazelle 3221", 1500000},

    // Китай
    {REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {REGION_CHINA, 523, "Yamaha FZ-10", 3905000},
    {REGION_CHINA, 522, "Kawasaki Ninja H2R", 3500000},
    {REGION_CHINA, 526, "Infiniti Q60S", 1700000},
    {REGION_CHINA, 603, "Ford Mustang GT", 1500000},
    {REGION_CHINA, 562, "Nissan Skyline R34", 500000},
    {REGION_CHINA, 502, "Nissan GT-R R35", 7110000},
    {REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {REGION_CHINA, 461, "Ducati SuperSport S", 1647000},
    {REGION_CHINA, 445, "Acura TSX", 1035000},
    {REGION_CHINA, 527, "BMW M3 E46", 945000},

    // Дубай
    {REGION_DUBAI, 494, "BMW I8 EDrive", 11850000},
    {REGION_DUBAI, 2549, "Lamborghini Huracan", 14850000},
    {REGION_DUBAI, 2551, "Lamborghini Urus", 13770000},
    {REGION_DUBAI, 400, "BMW X6M F16", 7740000},
    {REGION_DUBAI, 505, "Cadillac Escalade", 6480000},
    {REGION_DUBAI, 475, "Audi Q7", 5400000},
    {REGION_DUBAI, 466, "BMW M5 F90", 8910000},
    {REGION_DUBAI, 502, "Nissan GT-R R35", 7110000},
    {REGION_DUBAI, 604, "Porsche Panamera S", 8100000},
    {REGION_DUBAI, 480, "BMW Z4 M40i", 4410000},
    {REGION_DUBAI, 470, "ГАЗ Тигр", 30000000},
    {REGION_DUBAI, 500, "ГАЗ 69", 30000000},
    {REGION_DUBAI, 596, "BMW M5 F90 (ППС)", 30000000},
    {REGION_DUBAI, 490, "Range Rover SVR", 0},
    {REGION_DUBAI, 429, "Mercedes-Benz GT-R", 12150000},

    // Германия
    {REGION_GERMANY, 461, "Ducati SuperSport S", 1647000},
    {REGION_GERMANY, 445, "Acura TSX", 1035000},
    {REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {REGION_GERMANY, 523, "Yamaha FZ-10", 3905000},
    {REGION_GERMANY, 400, "BMW X6M F16", 7740000},
    {REGION_GERMANY, 402, "Mercedes Benz GT63s", 6320000},
    {REGION_GERMANY, 480, "BMW Z4 M40i", 4410000},
    {REGION_GERMANY, 445, "Acura TSX", 1035000},
    {REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {REGION_GERMANY, 565, "Mercedes-Benz A45 AMG", 2200000},
    {REGION_GERMANY, 445, "Acura TSX", 1035000},
    {REGION_GERMANY, 527, "BMW M3 E46", 945000},
    {REGION_GERMANY, 415, "Lamborghini Aventador S", 10000000}
};
// структура для хранения информации о регионах
enum RegionInfo
{
    RegionName[15],
    ClothesPrice,
    VehiclePrice,
    ContModelId,
    VorotaModelId,
};
// Новый массив с данными о регионах и ценах
new const g_RegionData[5][RegionInfo] =
{   // {Name, Price skin, Price car, Model, Model vor}
    {"", 0, 0},
    {"Россия", 100000, 200000, 934, 933},
    {"Китай", 900000, 2000000, 954, 953},
    {"Дубай", 4350000, 9000000, 956, 955},
    {"Германия", 900000, 2000000, 958, 957}
};
// правая + 128, левая - 128
new Float: cContsPos[12][12] =
{   //{X,       Y,         Z,      Angel,     X Vor1,Y Vor1,Z Vor1, A,      X Vor2, Y Vor2, Z Vor2,  A}
    {690.51898,1738.27002,13.2000,0.00000,   685.03,1736.35,12.60,0.0,      685.16,1740.18,12.60,-181.0},
    {690.51898,1731.78003,13.2000,0.00000,   685.02,1729.86,12.60,0.0,      685.13,1733.69,12.60,-180.0},
    {665.81897,1726.96997,13.2000,270.00000, 663.90,1732.45,12.60,-90.0,    667.73,1732.33,12.60,90.0}, // замена 2
    {680.23999,1694.77002,13.2000,270.00000, 678.42,1700.18,12.60957,-89.0, 682.15,1700.08,12.60,89.0},
    {672.75598,1694.77002,13.2000,270.00000, 670.84,1700.21,12.60,-90.0,    674.67,1700.11,12.60,90.0},
    {665.81897,1694.77002,13.2000,270.00000, 663.90,1700.18,12.60,-89.0,    667.72,1700.10,12.60,90.0},
    {655.51898,1676.51001,13.2000,0.00000,   650.07,1674.59,12.60,0.0,      650.17,1678.42,12.60,180.0},
    {655.51898,1669.80005,13.2000,0.00000,   650.07,1667.88,12.60,0.0,      650.16,1671.71,12.60,180.0},
    {655.51898,1663.40002,13.2000,0.00000,   650.05,1661.48,12.60,0.0,      650.20,1665.31,12.60,180.0},
    {631.91901,1709.30005,13.2000,180.00000, 637.38,1711.21,12.60,180.0,    637.34,1707.45,12.60,0.0},
    {631.91901,1702.55005,13.2000,180.00000, 637.39,1704.46,12.60,-180.0,   637.25,1700.63,12.60,0.0},
    {631.91901,1695.93994,13.2000,180.00000, 637.43,1697.85,12.60,181.0,    637.35,1694.02,12.60,0.0}
};
new Float: ContBuyTextPos[12][3] =
{
    {683.51898, 1738.27002, 13.8000},
    {683.51898, 1731.78003, 13.8000},
    {665.81897, 1733.96997, 13.8000},
    {680.23999, 1701.77002, 13.8000},
    {672.75598, 1701.77002, 13.8000},
    {665.81897, 1701.77002, 13.8000},
    {648.51898, 1676.51001, 13.8000},
    {648.51898, 1669.80005, 13.8000},
    {648.51898, 1663.40002, 13.8000},
    {638.91901, 1709.30005, 13.8000},
    {638.91901, 1702.55005, 13.8000},
    {638.91901, 1695.93994, 13.8000}
};
forward TimerSecondUpdateCont(contid, moneystart[]);
forward SpawnNewCont(contid);
forward CorrectTimerMinute();
stock SpawnCont(contid);
stock ResetContInfo(contid);

stock ConvertMoney(money, string[], length = sizeof string)
{
    format(string, length, "%d", money < 0 ? -money : money);
    for(new i = strlen(string); (i -= 3) > 0;)
    {
        if(string[i] != '\0' && '0' <= string[i] <= '9')
        {
            strins(string, ".", i, length);
        }
        else
        {
            return;
        }
    }
    if(money < 0)
    {
        strins(string, "-", 0, length);
    }
}
// ------------------------------------------------
// можете юзать если надо, а так на олд заменке и без него все ворк
stock RusText(string[])
{
	new result[256];
	new len = strlen(string);
	for (new i = 0; i < len; i++)
	{
		switch(string[i])
		{
			case 'а': result[i] = 'a';
			case 'А': result[i] = 'A';
			case 'б': result[i] = '—';
			case 'Б': result[i] = 'Ђ';
			case 'в': result[i] = 'ў';
			case 'В': result[i] = '‹';
			case 'г': result[i] = '™';
			case 'Г': result[i] = '‚';
			case 'д': result[i] = 'љ';
			case 'Д': result[i] = 'ѓ';
			case 'е': result[i] = 'e';
			case 'Е': result[i] = 'E';
			case 'ё': result[i] = 'e';
			case 'Ё': result[i] = 'E';
			case 'ж': result[i] = '›';
			case 'Ж': result[i] = '„';
			case 'з': result[i] = 'џ';
			case 'З': result[i] = '€';
			case 'и': result[i] = 'њ';
			case 'И': result[i] = '…';
			case 'й': result[i] = 'ќ';
			case 'Й': result[i] = '…';
			case 'к': result[i] = 'k';
			case 'К': result[i] = 'K';
			case 'л': result[i] = 'ћ';
			case 'Л': result[i] = '‡';
			case 'м': result[i] = 'Ї';
			case 'М': result[i] = 'M';
			case 'н': result[i] = '®';
			case 'Н': result[i] = 'H';
			case 'о': result[i] = 'o';
			case 'О': result[i] = 'O';
			case 'п': result[i] = 'Ј';
			case 'П': result[i] = 'Њ';
			case 'р': result[i] = 'p';
			case 'Р': result[i] = 'P';
			case 'с': result[i] = 'c';
			case 'С': result[i] = 'C';
			case 'т': result[i] = '¦';
			case 'Т': result[i] = 'Џ';
			case 'у': result[i] = 'y';
			case 'У': result[i] = 'Y';
			case 'ф': result[i] = 'Ѓ';
			case 'Ф': result[i] = 'Ѓ';
			case 'х': result[i] = 'x';
			case 'Х': result[i] = 'X';
			case 'ц': result[i] = '‰';
			case 'Ц': result[i] = '‰';
			case 'ч': result[i] = '¤';
			case 'Ч': result[i] = 'Ќ';
			case 'ш': result[i] = 'Ґ';
			case 'Ш': result[i] = 'Ћ';
			case 'щ': result[i] = 'Ў';
			case 'Щ': result[i] = 'Љ';
			case 'ь': result[i] = '©';
			case 'Ь': result[i] = '’';
			case 'ъ': result[i] = 'ђ';
			case 'Ъ': result[i] = '§';
			case 'ы': result[i] = 'Ё';
			case 'Ы': result[i] = '‘';
			case 'э': result[i] = 'Є';
			case 'Э': result[i] = '“';
			case 'ю': result[i] = '«';
			case 'Ю': result[i] = '”';
			case 'я': result[i] = '¬';
			case 'Я': result[i] = '•';
			default: result[i] = string[i];
		}
	}
	result[len] = '\0';
	return result;
}

public OnGameModeInit()
{
    LoadTextDraw();
    for(new cont = 1; cont <= MAX_CONT; cont++)
    {
        cInfo[cont][BetedId] = INVALID_PLAYER_ID;
        ContsText[cont] = CreateDynamic3DTextLabel("", CLR_WHITE, ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], ContBuyTextPos[cont-1][2], 4.0);
        ContsZone[cont] = CreateDynamicCircle(ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], 3.0, 0, 0, -1);
    }
    SetTimer("CorrectTimerMinute", 60000, true);
    #if defined conti_OnGameModeInit
        return conti_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit conti_OnGameModeInit
#if defined conti_OnGameModeInit
    forward conti_OnGameModeInit();
#endif

stock LoadTextDraw()
{
    cont_fon = TextDrawCreate(190.000198, 109.013328, "txd:brcontosnova");
    TextDrawLetterSize(cont_fon, 0.000000, 0.000000);
    TextDrawTextSize(cont_fon, 237.999938, 237.937759);
    TextDrawAlignment(cont_fon, 1);
    TextDrawColor(cont_fon, -1);
    TextDrawSetShadow(cont_fon, 0);
    TextDrawSetOutline(cont_fon, 0);
    TextDrawFont(cont_fon, 4);

    cont_take = TextDrawCreate(190.800003, 349.937774, "txd:brconttake");
    TextDrawLetterSize(cont_take, 0.000000, 0.000000);
    TextDrawTextSize(cont_take, 132.400009, 36.835563);
    TextDrawAlignment(cont_take, 1);
    TextDrawColor(cont_take, -1);
    TextDrawFont(cont_take, 4);
    TextDrawSetSelectable(cont_take, true);

    cont_sell = TextDrawCreate(324.800170, 349.937957, "txd:brcontsell");
    TextDrawLetterSize(cont_sell, 0.000000, 0.000000);
    TextDrawTextSize(cont_sell, 103.600006, 36.337799);
    TextDrawAlignment(cont_sell, 1);
    TextDrawColor(cont_sell, -1);
    TextDrawFont(cont_sell, 4);
    TextDrawSetSelectable(cont_sell, true);

    cont_close = TextDrawCreate(395.600006, 108.515548, "txd:brcontclose");
    TextDrawLetterSize(cont_close, 0.000000, 0.000000);
    TextDrawTextSize(cont_close, 31.199993, 37.333328);
    TextDrawAlignment(cont_close, 1);
    TextDrawColor(cont_close, -1);
    TextDrawFont(cont_close, 4);
    TextDrawSetSelectable(cont_close, true);
    
    for(new cont = 1; cont <= MAX_CONT; cont++) // Цикл для создания текстдравов для каждого контейнера
    {
        cont_name[cont] = TextDrawCreate(294.799987, 121.457778, "by werton");
        TextDrawLetterSize(cont_name[cont], 0.327599, 1.321245);
        TextDrawAlignment(cont_name[cont], 2);
        TextDrawColor(cont_name[cont], -1);
        TextDrawSetOutline(cont_name[cont], 1);
        TextDrawBackgroundColor(cont_name[cont], 51);
        TextDrawFont(cont_name[cont], 1);
        TextDrawSetProportional(cont_name[cont], 1);
        cont_price[cont] = TextDrawCreate(374.399963, 323.057739, "9.999.999 РУБ");
        TextDrawLetterSize(cont_price[cont], 0.307599, 1.236622);
        TextDrawAlignment(cont_price[cont], 2);
        TextDrawColor(cont_price[cont], -1);
        TextDrawSetShadow(cont_price[cont], 0);
        TextDrawSetOutline(cont_price[cont], 1);
        TextDrawBackgroundColor(cont_price[cont], 51);
        TextDrawFont(cont_price[cont], 1);
        TextDrawSetProportional(cont_price[cont], 1);
        
        cont_model[cont] = TextDrawCreate(226.399902, 149.333343, "by werton");
        TextDrawTextSize(cont_model[cont], 175.599990, 165.804412);
        TextDrawColor(cont_model[cont], -1);
        TextDrawUseBox(cont_model[cont], true);
        TextDrawFont(cont_model[cont], 5);
        TextDrawSetPreviewModel(cont_model[cont], 18639);
        TextDrawBackgroundColor(cont_model[cont], 0x00000000);
        TextDrawSetPreviewRot(cont_model[cont], 0.000000, 0.000000, -30.000000, 1.000000);
    }
    return 1;
}

stock SpawnCont(contid)
{
    if(contid < 1 || contid > MAX_CONT) return printf("ERROR: Invalid container ID in SpawnCont: %d", contid);
    new prize_region, prize_id, prize_price;
    new prize_name[64];
    new random_prize_index;
    
    new random_prize_type = random(2) + 1;
    if (random_prize_type == 1)
    {
        random_prize_index = random(sizeof(cSkin_Info));
        prize_region = cSkin_Info[random_prize_index][PRIZE_REGION];
        prize_id = cSkin_Info[random_prize_index][PRIZE_ID];
        format(prize_name, sizeof(prize_name), "%s", cSkin_Info[random_prize_index][PRIZE_NAME]);
        prize_price = cSkin_Info[random_prize_index][PRIZE_PRICE];
    }
    else
    {
        random_prize_index = random(sizeof(cCar_Info));
        prize_region = cCar_Info[random_prize_index][PRIZE_REGION];
        prize_id = cCar_Info[random_prize_index][PRIZE_ID];
        format(prize_name, sizeof(prize_name), "%s", cCar_Info[random_prize_index][PRIZE_NAME]);
        prize_price = cCar_Info[random_prize_index][PRIZE_PRICE];
    }
    
    cInfo[contid][ContRegion] = prize_region;
    cInfo[contid][ItemType] = random_prize_type;
    cInfo[contid][Item] = prize_id;
    cInfo[contid][ItemPrice] = prize_price;
    
    new initial_price = 0;
    if (cInfo[contid][ItemType] == 1)
    {
        initial_price = g_RegionData[cInfo[contid][ContRegion]][ClothesPrice];
    }
    else
    {
        initial_price = g_RegionData[cInfo[contid][ContRegion]][VehiclePrice];
    }
    
    cInfo[contid][ContPrice] = initial_price;
    cInfo[contid][BetPrice] = initial_price;
    
    new Float:x, Float:y, Float:z, Float:rot;
    new Float:door1X, Float:door1Y, Float:door1Z, Float:door1A;
    new Float:door2X, Float:door2Y, Float:door2Z, Float:door2A;
    
    x = cContsPos[contid-1][0];
    y = cContsPos[contid-1][1];
    z = cContsPos[contid-1][2];
    rot = cContsPos[contid-1][3];
    
    door1X = cContsPos[contid-1][4];
    door1Y = cContsPos[contid-1][5];
    door1Z = cContsPos[contid-1][6];
    door1A = cContsPos[contid-1][7];
    
    door2X = cContsPos[contid-1][8];
    door2Y = cContsPos[contid-1][9];
    door2Z = cContsPos[contid-1][10];
    door2A = cContsPos[contid-1][11];
    
    new object_model = g_RegionData[cInfo[contid][ContRegion]][ContModelId];
    new vorota_model = g_RegionData[cInfo[contid][ContRegion]][VorotaModelId];

    cInfo[contid][ContObjectId] = CreateObject(object_model, x, y, z, 0.0, 0.0, rot);
    cInfo[contid][ContObjectDoorLId] = CreateObject(vorota_model, door1X, door1Y, door1Z, 0.0, 0.0, door1A);
    cInfo[contid][ContObjectDoorRId] = CreateObject(vorota_model, door2X, door2Y, door2Z, 0.0, 0.0, door2A);

    new moneystr[15];
    ConvertMoney(cInfo[contid][ContPrice], moneystr);

    TextDrawSetString(cont_name[contid], prize_name);
    
    cInfo[contid][Saled] = true;
    cInfo[contid][BetedId] = INVALID_PLAYER_ID;

    new strwerton[256];
    format(strwerton, sizeof strwerton, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги за контейнер открыты\n{993333}Начальная ставка: {FFFFFF}%s рублей", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr);
    
    if (ContsText[contid] == Dynamic3DTextLabel:INVALID_3DTEXT_ID)
    {
        ContsText[contid] = CreateDynamic3DTextLabel(strwerton, -1, x, y, z+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, false, contid);
    }
    else
    {
        UpdateDynamic3DTextLabelText(ContsText[contid], CLR_RED, strwerton);
    }

    printf("Создан контейнер %d ||| тип %d ||| регион %d", contid, cInfo[contid][ItemType], cInfo[contid][ContRegion]);

    return 1;
}

public TimerSecondUpdateCont(contid, moneystart[])
{
    if(cInfo[contid][SaleTime] > 0)
    {
        cInfo[contid][SaleTime]--;

        cInfo[contid][Saled] = true;
        
        new moneystr[15], betstr[15];
        ConvertMoney(cInfo[contid][ContPrice], moneystr);
        ConvertMoney(cInfo[contid][BetPrice], betstr);
        
        new strwerton[366];
        if (cInfo[contid][BetedId] != INVALID_PLAYER_ID) {
            format(strwerton, sizeof strwerton, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}идут активные торги\n{993333}Последняя ставка: {FFFFFF}%s рублей\n{993333}Начальная ставка: {FFFFFF}%s рублей\n{993333}Ставка сделана от: {FFFFFF}%s\n{993333}До конца торгов осталось: {FFFFFF}%d секунд", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), betstr, moneystart, cInfo[contid][BetedName], cInfo[contid][SaleTime]);
        }
        else
        {
            format(strwerton, sizeof strwerton, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги за контейнер открыты\n{993333}Начальная ставка: {FFFFFF}%s рублей", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr);
        }
        UpdateDynamic3DTextLabelText(ContsText[contid], CLR_RED, strwerton);
    }
    else // Торги окончены
    {
        KillTimer(ContsTimer[contid]);
        ContsTimer[contid] = 0;
        cInfo[contid][Saled] = false;
        
        if (cInfo[contid][BetedId] != INVALID_PLAYER_ID)
        {
            new winnerid = cInfo[contid][BetedId];
            new winner_name[MAX_PLAYER_NAME];
            GetPlayerName(winnerid, winner_name, sizeof(winner_name));

            new Float:door1X = cContsPos[contid-1][4];
            new Float:door1Y = cContsPos[contid-1][5];
            new Float:door1Z = cContsPos[contid-1][6];
            new Float:door1A = cContsPos[contid-1][7];
            
            new Float:door2X = cContsPos[contid-1][8];
            new Float:door2Y = cContsPos[contid-1][9];
            new Float:door2Z = cContsPos[contid-1][10];
            new Float:door2A = cContsPos[contid-1][11];
            
            GivePlayerMoneyEx(winnerid, -cInfo[contid][BetPrice]);
            
            if(cInfo[contid][ItemType] == 2)
            {
                new colors[] = {1, 10, 22, 53, 50}; // 0-черный, 1-белый, 10-красный, 22-розовый, 53-желтый, 50-зеленый
                cInfo[contid][ContVehicleColor] = colors[random(sizeof(colors))];
                TextDrawSetPreviewVehCol(cont_model[contid], cInfo[contid][ContVehicleColor], 1);
                switch(contid)
                {
                    case 1: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 690.51898, 1738.27002, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 2: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 690.51898, 1731.78003, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 3: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 665.81897, 1726.96997, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
                    case 4: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 680.23999, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
                    case 5: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 672.75598, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
                    case 6: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 665.81897, 1694.77002, 14.73000, 0, cInfo[contid][ContVehicleColor], 1, 0);
                    case 7: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 655.51898, 1676.51001, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 8: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 655.51898, 1669.80005, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 9: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 655.51898, 1663.40002, 14.73000, 90, cInfo[contid][ContVehicleColor], 1, 0);
                    case 10: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 631.91901, 1709.30005, 14.73000, 270, cInfo[contid][ContVehicleColor], 1, 0);
                    case 11: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 631.91901, 1702.55005, 14.73000, 270, cInfo[contid][ContVehicleColor], 1, 0);
                    case 12: cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], 631.91901, 1695.93994, 14.73000, 270, cInfo[contid][ContVehicleColor], 1, 0);
                }
                SetVehicleParamsEx(cInfo[contid][ContVehicleId], false, false, false, true, false, false, false);
                ChangeVehicleColor(cInfo[contid][ContVehicleId], cInfo[contid][ContVehicleColor], 0);
            }
            else // Если приз не автомобиль (то есть одежда)
            {
                new Float:contX = cContsPos[contid-1][0];
                new Float:contY = cContsPos[contid-1][1];
                new Float:contZ = cContsPos[contid-1][2];
                new Float:contRot = cContsPos[contid-1][3];
                cInfo[contid][ContObjectOdejdaId] = CreateObject(959, contX, contY, contZ, 0.0, 0.0, contRot);
            }
            // ==========================================
            
            new str_win[270];
            new balansestr[15];
            ConvertMoney(cInfo[contid][BetPrice], balansestr);
            format(str_win, sizeof(str_win), "| {ffffff}Вы успешно выиграли контейнер{ffff00} #%d{ffffff}! С вашего счета списано {ffff00}%s {ffffff}рублей.", contid, balansestr);
            SendClientMessage(winnerid, CLR_YELLOW, str_win);
            
            new moneystr[15];
            ConvertMoney(cInfo[contid][BetPrice], moneystr);
            new strwerton[300];
            format(strwerton, sizeof(strwerton), "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги окончены\n{993333}Последняя попедная ставка: {FFFFFF}%s рублей\n{993333}Победитель торгов: {FFFFFF}%s\n{993333}Для открытия введите: {FFFFFF}/cont", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr, winner_name);
            UpdateDynamic3DTextLabelText(ContsText[contid], CLR_GREEN, strwerton);

            MoveObject(cInfo[contid][ContObjectDoorLId], door1X, door1Y, door1Z, 8.5, 0, 0, door1A + 128.0);
            MoveObject(cInfo[contid][ContObjectDoorRId], door2X, door2Y, door2Z, 8.5, 0, 0, door2A - 128.0);
        }
        else
        {
            new moneystr[15];
            ConvertMoney(cInfo[contid][ContPrice], moneystr);
            new strwerton[256];
            format(strwerton, sizeof strwerton, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги не состоялись\n{993333}Начальная ставка: {FFFFFF}%s рублей", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr);
            UpdateDynamic3DTextLabelText(ContsText[contid], CLR_YELLOW, strwerton);

            DestroyObject(cInfo[contid][ContObjectId]);
            DestroyObject(cInfo[contid][ContObjectDoorLId]);
            DestroyObject(cInfo[contid][ContObjectDoorRId]);
            DestroyObject(cInfo[contid][ContObjectOdejdaId]);
            DestroyVehicle(cInfo[contid][ContVehicleId]);
            
            SpawnCont(contid);
        }
    }
    return 1;
}

stock ResetContInfo(contid)
{
    DestroyObject(cInfo[contid][ContObjectId]);
    DestroyObject(cInfo[contid][ContObjectDoorLId]);
    DestroyObject(cInfo[contid][ContObjectDoorRId]);
    DestroyObject(cInfo[contid][ContObjectOdejdaId]);
    DestroyObject(cInfo[contid][ContObjectDoorLId]);
    DestroyObject(cInfo[contid][ContObjectDoorRId]);
    DestroyObject(cInfo[contid][ContObjectOdejdaId]);
    DestroyVehicle(cInfo[contid][ContVehicleId]);
    KillTimer(ContsTimer[contid]);
    UpdateDynamic3DTextLabelText(ContsText[contid], CLR_RED, "");
    
    for(new i = 0; i < 17; i++) 
    {
        cInfo[contid][i] = 0;
    }
    cInfo[contid][BetedId] = INVALID_PLAYER_ID;
    cInfo[contid][Saled] = false;
    return 1;
}

public CorrectTimerMinute()
{
    new hour, minute, second;
    gettime(hour, minute, second);
    if(hour >= 8 && hour < 23 && minute == 25)
    { 
        SendClientMessageToAll(0xFF5533FF, "{ffff00}[Контейнера] {ffffff}Через {ffff00}10{ffffff} минут начнутся торги за контейнеры!");
        SendClientMessageToAll(0xFF5533FF, "{ffff00}[Контейнера] {ffffff}Местоположение: {ffff00}/gps - Развлечения > Битва за контейнеры");
        return 1;
    }
    else if(hour >= 8 && hour < 23 && minute == 30)
    {
        for(new cont = 1; cont <= MAX_CONT; cont++)
        {
            if(cInfo[cont][Saled] == false)
            {
                SpawnCont(cont);
            }
        }
    }
    else if(hour >= 8 && hour < 23 && minute == 40)
    {
        SendClientMessageToAll(0xFF5533FF, "{ffff00}[Контейнера] {ffffff}Торги за контейнеры закончились");
        StopCont();
    }
    return 1;
}

CMD:cont(playerid)
{
    new bool:sell_limit;
    for(new cont=1; cont < MAX_CONT+1; cont++)
    {
        if(sell_limit == true) continue;
        if(IsPlayerInRangeOfPoint(playerid, 3.0, ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], ContBuyTextPos[cont-1][2]))
        {
            sell_limit = true;
            
            // Если контейнер выставлен на продажу (торги идут)
            if(cInfo[cont][Saled] == true)
            {
                if(cInfo[cont][BetedId] == playerid) return SendClientMessage(playerid, CLR_RED, "| {ffffff}Ставка на контейнер уже ваша, вы не можете перебить свою ставку");
                
                if(pInfo[playerid][BetUseCont] != 0) 
                {
                    new str_error[128];
                    format(str_error, sizeof(str_error), "| {ffffff}Вы уже сделали ставку на контейнер #%d. Вы не можете делать ставку на другой контейнер.", pInfo[playerid][BetUseCont]);
                    return SendClientMessage(playerid, CLR_RED, str_error);
                }

                pInfo[playerid][BetUseCont] = cont;

                new strwerton[140], betstr[15];
                ConvertMoney(cInfo[cont][BetPrice], betstr);
                format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, "{FF6347}"SERVER_NAME" {ffffff}| Битва за контейнер", strwerton, "Готово", "Отмена");
            }
            // Если торги окончены и игрок - победитель
            else
            {
                if(cInfo[cont][BetedId] == playerid)
                {
                    pInfo[playerid][BuyUseCont] = cont;

                    new prize_name[64];
                    new prize_price_string[32];
                    new prize_modelid = cInfo[cont][Item];
                    
                    if (cInfo[cont][ItemType] == 1) // Скин
                    {
                        for(new i = 0; i < sizeof(cSkin_Info); i++)
                        {
                            if (cSkin_Info[i][PRIZE_ID] == prize_modelid)
                            {
                                format(prize_name, sizeof(prize_name), "%s", cSkin_Info[i][PRIZE_NAME]);
                                break;
                            }
                        }
                        TextDrawSetPreviewModel(cont_model[cont], prize_modelid);
                    }
                    else if (cInfo[cont][ItemType] == 2) // Автомобиль
                    {
                        for(new i = 0; i < sizeof(cCar_Info); i++)
                        {
                            if (cCar_Info[i][PRIZE_ID] == prize_modelid)
                            {
                                format(prize_name, sizeof(prize_name), "%s", cCar_Info[i][PRIZE_NAME]);
                                break;
                            }
                        }
                        TextDrawSetPreviewModel(cont_model[cont], prize_modelid, cInfo[cont][ContVehicleColor], 1);
                    }
                    
                    ConvertMoney(cInfo[cont][ItemPrice], prize_price_string);
                    format(prize_price_string, sizeof(prize_price_string), "%s РУБ", prize_price_string);
                    
                    TextDrawSetString(cont_name[cont], prize_name);
                    TextDrawSetString(cont_price[cont], prize_price_string);

                    TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
                    TextDrawShowForPlayer(playerid, cont_fon);
                    TextDrawShowForPlayer(playerid, cont_take);
                    TextDrawShowForPlayer(playerid, cont_sell);
                    TextDrawShowForPlayer(playerid, cont_close);
                    TextDrawShowForPlayer(playerid, cont_name[cont]);
                    TextDrawShowForPlayer(playerid, cont_price[cont]);
                    TextDrawShowForPlayer(playerid, cont_model[cont]);
                    
                    // да да, взял с тутора от Димаса с группы по павно
                    for(new a;a < 12;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");
                    // не ну а хули самому писать
                    
                    SelectTextDraw(playerid, CLR_WHITE);
                }
            }
        }
    }
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == cont_sell)
    {
        new cont = pInfo[playerid][BuyUseCont];
        if(IsPlayerInRangeOfPoint(playerid, 4.0, ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], ContBuyTextPos[cont-1][2]) && cInfo[cont][Saled] == false)
        {
            if(cInfo[cont][BetedId] == playerid)
            {
                new sell_price_string[120];
                new sell_price = cInfo[cont][ItemPrice];
                GivePlayerMoneyEx(playerid, sell_price);
                format(sell_price_string, sizeof(sell_price_string), "| {ffffff}Вы успешно продали содержимое контейнера {ffff00}#%d {ffffff}за {ffff00}%d {ffff00}рублей!", cont, sell_price);
                SendClientMessage(playerid, CLR_GREEN, sell_price_string);

                TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

                TextDrawHideForPlayer(playerid, cont_fon);
                TextDrawHideForPlayer(playerid, cont_take);
                TextDrawHideForPlayer(playerid, cont_sell);
                TextDrawHideForPlayer(playerid, cont_close);

                TextDrawHideForPlayer(playerid, cont_name[cont]);
                TextDrawHideForPlayer(playerid, cont_price[cont]);
                TextDrawHideForPlayer(playerid, cont_model[cont]);
                CancelSelectTextDraw(playerid);


                DestroyObject(cInfo[cont][ContObjectId]);
                DestroyObject(cInfo[cont][ContObjectOdejdaId]);
                DestroyVehicle(cInfo[cont][ContVehicleId]);
                KillTimer(ContsTimer[cont]);
                ResetContInfo(cont);
                pInfo[playerid][BuyUseCont] = 0;
                pInfo[playerid][BetUseCont] = 0;

                SetTimerEx("SpawnNewCont", 5000, false, "i", cont);
            }
        }
    }
    if(clickedid == cont_take)
    {
        new cont = pInfo[playerid][BuyUseCont];
        if(IsPlayerInRangeOfPoint(playerid, 4.0, ContBuyTextPos[cont-1][0], ContBuyTextPos[cont-1][1], ContBuyTextPos[cont-1][2]) && cInfo[cont][Saled] == false)
        {
            if(cInfo[cont][BetedId] == playerid)
            {
                if (cInfo[cont][ItemType] == 1) // Скин
                {
                    /*SetPlayerSkin(playerid, cInfo[cont][Item]);
                    SetPlayerData(playerid, P_SKIN, cInfo[cont][Item]);
                    UpdatePlayerDatabaseInt(playerid, "skin", cInfo[cont][Item]);
                    SetPlayerSkinInit(playerid);*/
                    GivePlayerOwnableSkinEx(playerid, cInfo[cont][Item]);
                    SendClientMessage(playerid, CLR_GREEN, "| {ffffff}Вы получили новый скин из контейнера!");
                }
                else if (cInfo[cont][ItemType] == 2) // Автомобиль
                {
                    new car_modelid = cInfo[cont][Item];
                    new car_color = cInfo[cont][ContVehicleColor];
                    new Float: pos_x = 13.035842;
                    new Float: pos_y = 2549.344482;
                    new Float: pos_z = 10.876162;
                    new Float: angle = 358.785644;
                    new query[256], Cache: result;
                    
                    format(query, sizeof query, "INSERT INTO ownable_cars (owner_id, model_id, color_1, color_2, pos_x, pos_y, pos_z, angle, create_time) VALUES ('%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%d')",
                        GetPlayerAccountID(playerid), car_modelid, car_color, car_color, pos_x, pos_y, pos_z, angle, gettime());
                    
                    result = mysql_query(mysql, query, true);
                    cache_delete(result);
                    SendClientMessage(playerid, CLR_GREEN, "| {ffffff}Поздравляем! Вы получили новый автомобиль из контейнера!");
                }

                TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

                TextDrawHideForPlayer(playerid, cont_fon);
                TextDrawHideForPlayer(playerid, cont_take);
                TextDrawHideForPlayer(playerid, cont_sell);
                TextDrawHideForPlayer(playerid, cont_close);

                TextDrawHideForPlayer(playerid, cont_name[cont]);
                TextDrawHideForPlayer(playerid, cont_price[cont]);
                TextDrawHideForPlayer(playerid, cont_model[cont]);
                CancelSelectTextDraw(playerid);


                DestroyObject(cInfo[cont][ContObjectId]);
                DestroyObject(cInfo[cont][ContObjectOdejdaId]);
                DestroyVehicle(cInfo[cont][ContVehicleId]);
                KillTimer(ContsTimer[cont]);
                ResetContInfo(cont);
                pInfo[playerid][BuyUseCont] = 0;
                pInfo[playerid][BetUseCont] = 0;

                SetTimerEx("SpawnNewCont", 5000, false, "i", cont);
            }
        }
    }
    if(clickedid == cont_close)
    {
        TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);

        TextDrawHideForPlayer(playerid, cont_fon);
        TextDrawHideForPlayer(playerid, cont_take);
        TextDrawHideForPlayer(playerid, cont_sell);
        TextDrawHideForPlayer(playerid, cont_close);
        CancelSelectTextDraw(playerid);

        for(new cont=1; cont <= MAX_CONT; cont++)
        {
            TextDrawHideForPlayer(playerid, cont_name[cont]);
            TextDrawHideForPlayer(playerid, cont_price[cont]);
            TextDrawHideForPlayer(playerid, cont_model[cont]);
        }
    }
    #if defined conti_OnPlayerClickTextDraw
        return conti_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw conti_OnPlayerClickTextDraw
#if defined conti_OnPlayerClickTextDraw
    forward conti_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_CONT_BET)
    {
        if(response)
        {
            new cont = pInfo[playerid][BetUseCont];
            if(cont == 0) return printf("ERROR PLAYERID: %d (contuse == 0)");
            if(cInfo[cont][Saled] == true)
            {
                if(cInfo[cont][BetedId] == playerid) return SendClientMessage(playerid, CLR_RED, "| {ffffff}Ставка на контейнер уже ваша, вы не можете перебить свою ставку");
                if(0 < strval(inputtext) < 100000000)
                {
                    if(GetPlayerMoneyEx(playerid) >= strval(inputtext))
                    {
                        if(strval(inputtext)-99999 > cInfo[cont][BetPrice])
                        {
                            if(strval(inputtext) > cInfo[cont][ContPrice] && strval(inputtext) > cInfo[cont][BetPrice])
                            {
                                new strwerton[111];
                                new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME);
                                if(cInfo[cont][BetedId] != INVALID_PLAYER_ID)
                                {
                                    format(strwerton, sizeof strwerton, "| {ffffff}Ваша ставка была отменена в связи с тем, что игрок {FF6347}%s {ffffff}поставил больше!", name);
                                    SendClientMessage(cInfo[cont][BetedId], CLR_RED, strwerton);
                                }

                                cInfo[cont][BetPrice] = strval(inputtext);
                                cInfo[cont][BetedId] = playerid;
                                format(cInfo[cont][BetedName], MAX_PLAYER_NAME, "%s", name);

                                new betstr[15];
                                ConvertMoney(cInfo[cont][BetPrice], betstr);
                                format(strwerton, sizeof strwerton, "| {ffffff}Вы успешно сделали ставку в размере {FFFF00}%s {ffffff}рублей за контейнер {FFFF00}#%d", betstr, cont);
                                SendClientMessage(playerid, CLR_YELLOW, strwerton);

                                StartContBidding(cont);
                            }
                            else
                            {
                                new strwerton[140], betstr[15];
                                ConvertMoney(cInfo[cont][BetPrice], betstr);
                                format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                                SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, "{FF6347}"SERVER_NAME" {ffffff}| Битва за контейнер", strwerton,  "Готово", "Отмена");
                                SendClientMessage(playerid, CLR_RED, "| {ffffff}Ваша ставка должна быть выше последней!");
                                pInfo[playerid][BetUseCont] = 0;
                            }
                        }
                        else
                        {
                            new strwerton[140], betstr[15];
                            ConvertMoney(cInfo[cont][BetPrice], betstr);
                            format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                            SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, "{FF6347}"SERVER_NAME" {ffffff}| Битва за контейнер", strwerton,  "Готово", "Отмена");
                            SendClientMessage(playerid, CLR_RED, "| {ffffff}Минимальный подьем ставки 100.000 рублей!");
                            pInfo[playerid][BetUseCont] = 0;
                        }
                    }
                    else
                    {
                        new strwerton[140], betstr[15];
                        ConvertMoney(cInfo[cont][BetPrice], betstr);
                        format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                        SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, "{FF6347}"SERVER_NAME" {ffffff}| Битва за контейнер", strwerton,  "Готово", "Отмена");
                        SendClientMessage(playerid, CLR_RED, "| {ffffff}У вас недостаточно средств для такой ставки!");
                        pInfo[playerid][BetUseCont] = 0;
                    }
                }
                else
                {
                    new strwerton[140], betstr[15];
                    ConvertMoney(cInfo[cont][BetPrice], betstr);
                    format(strwerton, sizeof strwerton, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                    SPD(playerid, DIALOG_CONT_BET, DIALOG_STYLE_INPUT, "{FF6347}"SERVER_NAME" {ffffff}| Битва за контейнер", strwerton,  "Готово", "Отмена");
                    SendClientMessage(playerid, CLR_RED, "| {ffffff}Введите корректную ставку!");
                    pInfo[playerid][BetUseCont] = 0;
                }
            }
        }
    }
    #if defined conti_OnDialogResponse
        return conti_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #endif
    return 1;
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse conti_OnDialogResponse
#if defined conti_OnDialogResponse
    forward conti_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

stock StartCont()
{
    print("=== Доставка контейнеров в порт | SILE RUSSIA ===");
    StopCont();
    for(new cont=1; cont <= MAX_CONT; cont++)
    {
        SpawnCont(cont);
    }
    
    /*foreach(new i:Player)
    {
        CancelSelectTextDraw(i);
        TogglePlayerHudElement(i, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
        TogglePlayerHudElement(i, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
    }*/
}

stock StopCont()
{
    for(new cont=1; cont <= MAX_CONT; cont++)
    {
        DestroyObject(cInfo[cont][ContObjectId]);
        DestroyObject(cInfo[cont][ContObjectDoorLId]);
        DestroyObject(cInfo[cont][ContObjectDoorRId]);
        DestroyObject(cInfo[cont][ContObjectOdejdaId]);
        DestroyVehicle(cInfo[cont][ContVehicleId]);
        KillTimer(ContsTimer[cont]);
        ResetContInfo(cont);

        TextDrawHideForAll(cont_name[cont]);
        TextDrawHideForAll(cont_price[cont]);
        TextDrawHideForAll(cont_model[cont]);
    }
    TextDrawHideForAll(cont_fon);
    TextDrawHideForAll(cont_take);
    TextDrawHideForAll(cont_sell);
    TextDrawHideForAll(cont_close);
    /*foreach(new i:Player)
    {
        CancelSelectTextDraw(i);
        TogglePlayerHudElement(i, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
        TogglePlayerHudElement(i, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
    }*/
}

stock StartContBidding(contid)
{
    cInfo[contid][SaleTime] = 30;
    KillTimer(ContsTimer[contid]);

    new moneystr[15], betstr[15];
    ConvertMoney(cInfo[contid][ContPrice], moneystr);
    ConvertMoney(cInfo[contid][BetPrice], betstr);
    
    new strwerton[366];
    format(strwerton, sizeof strwerton, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}идут активные торги\n{993333}Последняя ставка: {FFFFFF}%s рублей\n{993333}Начальная ставка: {FFFFFF}%s рублей\n{993333}Ставка сделана от: {FFFFFF}%s\n{993333}Время проведения торгов: {FFFFFF}%d секунд", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), betstr, moneystr, cInfo[contid][BetedName], cInfo[contid][SaleTime]);
    UpdateDynamic3DTextLabelText(ContsText[contid], CLR_RED, strwerton);
    
    ContsTimer[contid] = SetTimerEx("TimerSecondUpdateCont", 1000, true, "ds", contid, moneystr);
    return 1;
}

stock GivePlayerOwnableSkinEx(playerid, skinid)
{
	new query[144], Cache:result;
	mysql_format(mysql, query, sizeof query, "SELECT * FROM inventory_skins WHERE owner_skin = %d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();
	cache_delete(result);

		mysql_format(mysql, query, sizeof query, "INSERT INTO inventory_skins (owner_skin,skin_id,use_skin) VALUES (%d,%d,0)", GetPlayerAccountID(playerid), skinid);
		mysql_query(mysql, query, false);
		if(mysql_errno()) return SCM(playerid, -1, "CheckSkinPlayer | SQL ERROR 1");
		SendClientMessage(playerid, -1, ""SC"Добавлена новая одежда в инвентарь, {ffff00}/myskins");
		return 1;
}

public SpawnNewCont(contid)
{
    SpawnCont(contid);
}

CMD:startcont(playerid)
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;
    StartCont();
    return 1;
}

CMD:stopcont(playerid)
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;
    StopCont();
    return 1;
}