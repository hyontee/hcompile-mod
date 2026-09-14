#define  PROJECT_NAME_FOR_CONT  SERVER_NAME
#define MAX_CONT 12
enum PrizeInfo
{
    PRIZE_REGION,       
    PRIZE_ID,          
    PRIZE_NAME[64],      
    PRIZE_PRICE,        
};

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
new cInfo[MAX_CONT + 1][Cont_Info];

enum cP_Info
{
    BetUseCont,
    BuyUseCont,
}
new c_pInfo[MAX_PLAYERS][cP_Info];
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
    
    {REGION_DUBAI, 300, "Одежда", 1000000},
    {REGION_DUBAI, 211, "Одежда", 5000000},
    {REGION_DUBAI, 99, "Одежда", 3500000},
    {REGION_DUBAI, 102, "Одежда", 600000},
    {REGION_DUBAI, 125, "Одежда", 1000000},
    {REGION_DUBAI, 101, "Одежда", 3850000}
};
new const cCar_Info[][PrizeInfo] = {
    {REGION_RUSSIA, 404, "VAZ 2107", 50000},
    {REGION_RUSSIA, 555, "ZAZ 968", 20000},
    {REGION_RUSSIA, 401, "VAZ 2101", 42000},
    {REGION_RUSSIA, 401, "Lada Granta", 320000},
    {REGION_RUSSIA, 413, "Gazelle 3221", 1500000},

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
enum RegionInfo
{
    RegionName[15],
    ClothesPrice,
    VehiclePrice,
    ContModelId,
    VorotaModelId,
};

new const g_RegionData[5][RegionInfo] =
{   // {Name, Price skin, Price car, Model, Model vor}
    {"", 0, 0},
    {"Россия", 100000, 200000, 934, 933},
    {"Китай", 900000, 2000000, 954, 953},
    {"Дубай", 4350000, 9000000, 956, 955},
    {"Германия", 900000, 2000000, 958, 957}
};

// === НОВЫЕ КООРДИНАТЫ ИЗ КОДА 2 (для ContBuyTextPos и спавна контейнеров) ===
new Float: ContBuyTextPos[13][3] = // Размер 13, т.к. в коде 2 индексация с 1 до 12, добавим пустую 0
{
    {0.0,0.0,0.0},
    {683.51898, 1738.27002, 14.73000},
    {683.51898, 1731.78003, 14.73000},
    {665.81897, 1733.96997, 14.73000},
    {680.23999, 1701.77002, 14.73000},
    {672.75598, 1701.77002, 14.73000},
    {665.81897, 1701.77002, 14.73000},
    {648.51898, 1676.51001, 14.73000},
    {648.51898, 1669.80005, 14.73000},
    {648.51898, 1663.40002, 14.73000},
    {638.91901, 1709.30005, 14.73000},
    {638.91901, 1702.55005, 14.73000},
    {638.91901, 1695.93994, 14.73000}
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

stock CreateContainers()
{
    for(new cont = 1; cont <= MAX_CONT; cont++)
    {
        cInfo[cont][BetedId] = INVALID_PLAYER_ID;
        ContsText[cont] = CreateDynamic3DTextLabel("", 0xFFFFFFFF, ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], ContBuyTextPos[cont][2], 4.0);
        ContsZone[cont] = CreateDynamicCircle(ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], 3.0, 0, 0, -1);
    }
}

stock CreateContTextDraw()
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
    
    for(new cont = 1; cont <= MAX_CONT; cont++)
    {
        cont_name[cont] = TextDrawCreate(294.799987, 121.457778, "Контейнер");
        TextDrawLetterSize(cont_name[cont], 0.327599, 1.321245);
        TextDrawAlignment(cont_name[cont], 2);
        TextDrawColor(cont_name[cont], -1);
        TextDrawSetOutline(cont_name[cont], 1);
        TextDrawBackgroundColor(cont_name[cont], 51);
        TextDrawFont(cont_name[cont], 1);
        TextDrawSetProportional(cont_name[cont], 1);
        cont_price[cont] = TextDrawCreate(374.399963, 323.057739, "0 РУБ");
        TextDrawLetterSize(cont_price[cont], 0.307599, 1.236622);
        TextDrawAlignment(cont_price[cont], 2);
        TextDrawColor(cont_price[cont], -1);
        TextDrawSetShadow(cont_price[cont], 0);
        TextDrawSetOutline(cont_price[cont], 1);
        TextDrawBackgroundColor(cont_price[cont], 51);
        TextDrawFont(cont_price[cont], 1);
        TextDrawSetProportional(cont_price[cont], 1);
        
        cont_model[cont] = TextDrawCreate(226.399902, 149.333343, "");
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
    if(contid < 1 || contid > MAX_CONT) return printf("Ошибка контейнера %d", contid);
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
    
    // Координаты из Кода 2
    new Float:x, Float:y, Float:z, Float:rot;
    switch(contid)
    {
        case 1:  { x = 690.51898; y = 1738.27002; z = 14.73000; rot =   0.00000; }
        case 2:  { x = 690.51898; y = 1731.78003; z = 14.73000; rot =   0.00000; }
        case 3:  { x = 665.81897; y = 1726.96997; z = 14.73000; rot = 270.00000; }
        case 4:  { x = 680.23999; y = 1694.77002; z = 14.73000; rot = 270.00000; }
        case 5:  { x = 672.75598; y = 1694.77002; z = 14.73000; rot = 270.00000; }
        case 6:  { x = 665.81897; y = 1694.77002; z = 14.73000; rot = 270.00000; }
        case 7:  { x = 655.51898; y = 1676.51001; z = 14.73000; rot =   0.00000; }
        case 8:  { x = 655.51898; y = 1669.80005; z = 14.73000; rot =   0.00000; }
        case 9:  { x = 655.51898; y = 1663.40002; z = 14.73000; rot =   0.00000; }
        case 10: { x = 631.91901; y = 1709.30005; z = 14.73000; rot = 180.00000; }
        case 11: { x = 631.91901; y = 1702.55005; z = 14.73000; rot = 180.00000; }
        case 12: { x = 631.91901; y = 1695.93994; z = 14.73000; rot = 180.00000; }
    }
    
    // Ворота (примерные координаты из Кода 2, для простоты оставлю базовые, т.к. в коде 2 они жестко зашиты в switch)
    new Float:door1X, Float:door1Y, Float:door1Z, Float:door1A;
    new Float:door2X, Float:door2Y, Float:door2Z, Float:door2A;
    switch(contid)
    {
        case 1:  { door1X = 684.96442; door1Y = 1738.25000; door1Z = 13.00000; door1A = 0.00000; door2X = 684.96442; door2Y = 1736.30005; door2Z = 13.00000; door2A = 0.00000; }
        case 2:  { door1X = 684.96442; door1Y = 1731.75000; door1Z = 13.00000; door1A = 0.00000; door2X = 684.96442; door2Y = 1729.80005; door2Z = 13.00000; door2A = 0.00000; }
        case 3:  { door1X = 665.79999; door1Y = 1732.50000; door1Z = 13.00000; door1A = -90.00000; door2X = 663.84998; door2Y = 1732.50000; door2Z = 13.00000; door2A = -90.00000; }
        case 4:  { door1X = 680.22101; door1Y = 1700.30005; door1Z = 13.00000; door1A = -90.00000; door2X = 678.27100; door2Y = 1700.30005; door2Z = 13.00000; door2A = -90.00000; }
        case 5:  { door1X = 672.73700; door1Y = 1700.30005; door1Z = 13.00000; door1A = -90.00000; door2X = 670.78699; door2Y = 1700.30005; door2Z = 13.00000; door2A = -90.00000; }
        case 6:  { door1X = 665.79999; door1Y = 1700.30005; door1Z = 13.00000; door1A = -90.00000; door2X = 663.84998; door2Y = 1700.30005; door2Z = 13.00000; door2A = -90.00000; }
        case 7:  { door1X = 649.96973; door1Y = 1676.48999; door1Z = 13.00000; door1A = 0.00000; door2X = 649.96973; door2Y = 1674.54004; door2Z = 13.00000; door2A = 0.00000; }
        case 8:  { door1X = 649.96973; door1Y = 1669.78003; door1Z = 13.00000; door1A = 0.00000; door2X = 649.96973; door2Y = 1667.82996; door2Z = 13.00000; door2A = 0.00000; }
        case 9:  { door1X = 649.96973; door1Y = 1663.38000; door1Z = 13.00000; door1A = 0.00000; door2X = 649.96973; door2Y = 1661.43005; door2Z = 13.00000; door2A = 0.00000; }
        case 10: { door1X = 637.36829; door1Y = 1707.35986; door1Z = 13.00000; door1A = 0.00000; door2X = 637.36829; door2Y = 1709.30994; door2Z = 13.00000; door2A = 0.00000; }
        case 11: { door1X = 637.36829; door1Y = 1700.58984; door1Z = 13.00000; door1A = 0.00000; door2X = 637.36829; door2Y = 1702.53979; door2Z = 13.00000; door2A = 0.00000; }
        case 12: { door1X = 637.36829; door1Y = 1693.96985; door1Z = 13.00000; door1A = 0.00000; door2X = 637.36829; door2Y = 1695.91992; door2Z = 13.00000; door2A = 0.00000; }
    }

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

    new str[256];
    format(str, sizeof str, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги за контейнер открыты\n{993333}Начальная ставка: {FFFFFF}%s рублей", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr);
    
    if (ContsText[contid] == Dynamic3DTextLabel:INVALID_3DTEXT_ID)
    {
        ContsText[contid] = CreateDynamic3DTextLabel(str, -1, x, y, z+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, false, contid);
    }
    else
    {
        UpdateDynamic3DTextLabelText(ContsText[contid], 0xFF0000FF, str);
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
        
        new str[650];
        if (cInfo[contid][BetedId] != INVALID_PLAYER_ID) {
            format(str, sizeof str, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}идут активные торги\n{993333}Последняя ставка: {FFFFFF}%s рублей\n{993333}Начальная ставка: {FFFFFF}%s рублей\n{993333}Ставка сделана от: {FFFFFF}%s\n{993333}До конца торгов осталось: {FFFFFF}%d секунд", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), betstr, moneystart, cInfo[contid][BetedName], cInfo[contid][SaleTime]);
        }
        else
        {
            format(str, sizeof str, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги за контейнер открыты\n{993333}Начальная ставка: {FFFFFF}%s рублей", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr);
        }
        UpdateDynamic3DTextLabelText(ContsText[contid], 0xFF0000FF, str);
    }
    else 
    {
        KillTimer(ContsTimer[contid]);
        ContsTimer[contid] = 0;
        cInfo[contid][Saled] = false;
        
        if (cInfo[contid][BetedId] != INVALID_PLAYER_ID)
        {
            new winnerid = cInfo[contid][BetedId];
            new winner_name[MAX_PLAYER_NAME];
            GetPlayerName(winnerid, winner_name, sizeof(winner_name));

            // Двери для открытия
            new Float:door1X, Float:door1Y, Float:door1Z, Float:door1A;
            new Float:door2X, Float:door2Y, Float:door2Z, Float:door2A;
            switch(contid)
            {
                case 1:  { door1X = 684.96442; door1Y = 1738.25000; door1Z = 13.00000; door1A = 0.00000; door2X = 684.96442; door2Y = 1736.30005; door2Z = 13.00000; door2A = 0.00000; }
                case 2:  { door1X = 684.96442; door1Y = 1731.75000; door1Z = 13.00000; door1A = 0.00000; door2X = 684.96442; door2Y = 1729.80005; door2Z = 13.00000; door2A = 0.00000; }
                case 3:  { door1X = 665.79999; door1Y = 1732.50000; door1Z = 13.00000; door1A = -90.00000; door2X = 663.84998; door2Y = 1732.50000; door2Z = 13.00000; door2A = -90.00000; }
                case 4:  { door1X = 680.22101; door1Y = 1700.30005; door1Z = 13.00000; door1A = -90.00000; door2X = 678.27100; door2Y = 1700.30005; door2Z = 13.00000; door2A = -90.00000; }
                case 5:  { door1X = 672.73700; door1Y = 1700.30005; door1Z = 13.00000; door1A = -90.00000; door2X = 670.78699; door2Y = 1700.30005; door2Z = 13.00000; door2A = -90.00000; }
                case 6:  { door1X = 665.79999; door1Y = 1700.30005; door1Z = 13.00000; door1A = -90.00000; door2X = 663.84998; door2Y = 1700.30005; door2Z = 13.00000; door2A = -90.00000; }
                case 7:  { door1X = 649.96973; door1Y = 1676.48999; door1Z = 13.00000; door1A = 0.00000; door2X = 649.96973; door2Y = 1674.54004; door2Z = 13.00000; door2A = 0.00000; }
                case 8:  { door1X = 649.96973; door1Y = 1669.78003; door1Z = 13.00000; door1A = 0.00000; door2X = 649.96973; door2Y = 1667.82996; door2Z = 13.00000; door2A = 0.00000; }
                case 9:  { door1X = 649.96973; door1Y = 1663.38000; door1Z = 13.00000; door1A = 0.00000; door2X = 649.96973; door2Y = 1661.43005; door2Z = 13.00000; door2A = 0.00000; }
                case 10: { door1X = 637.36829; door1Y = 1707.35986; door1Z = 13.00000; door1A = 0.00000; door2X = 637.36829; door2Y = 1709.30994; door2Z = 13.00000; door2A = 0.00000; }
                case 11: { door1X = 637.36829; door1Y = 1700.58984; door1Z = 13.00000; door1A = 0.00000; door2X = 637.36829; door2Y = 1702.53979; door2Z = 13.00000; door2A = 0.00000; }
                case 12: { door1X = 637.36829; door1Y = 1693.96985; door1Z = 13.00000; door1A = 0.00000; door2X = 637.36829; door2Y = 1695.91992; door2Z = 13.00000; door2A = 0.00000; }
            }
            
            GivePlayerMoneyEx(winnerid, -cInfo[contid][BetPrice]);
            
            if(cInfo[contid][ItemType] == 2)
            {
                new colors[] = {1, 10, 22, 53, 50};
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
            else
            {
                new Float:contX, Float:contY, Float:contZ, Float:contRot;
                switch(contid)
                {
                    case 1:  { contX = 690.51898; contY = 1738.27002; contZ = 14.73000; contRot =   0.00000; }
                    case 2:  { contX = 690.51898; contY = 1731.78003; contZ = 14.73000; contRot =   0.00000; }
                    case 3:  { contX = 665.81897; contY = 1726.96997; contZ = 14.73000; contRot = 270.00000; }
                    case 4:  { contX = 680.23999; contY = 1694.77002; contZ = 14.73000; contRot = 270.00000; }
                    case 5:  { contX = 672.75598; contY = 1694.77002; contZ = 14.73000; contRot = 270.00000; }
                    case 6:  { contX = 665.81897; contY = 1694.77002; contZ = 14.73000; contRot = 270.00000; }
                    case 7:  { contX = 655.51898; contY = 1676.51001; contZ = 14.73000; contRot =   0.00000; }
                    case 8:  { contX = 655.51898; contY = 1669.80005; contZ = 14.73000; contRot =   0.00000; }
                    case 9:  { contX = 655.51898; contY = 1663.40002; contZ = 14.73000; contRot =   0.00000; }
                    case 10: { contX = 631.91901; contY = 1709.30005; contZ = 14.73000; contRot = 180.00000; }
                    case 11: { contX = 631.91901; contY = 1702.55005; contZ = 14.73000; contRot = 180.00000; }
                    case 12: { contX = 631.91901; contY = 1695.93994; contZ = 14.73000; contRot = 180.00000; }
                }
                cInfo[contid][ContObjectOdejdaId] = CreateObject(959, contX, contY, contZ, 0.0, 0.0, contRot);
            }
            
            new str_win[270];
            new balansestr[15];
            ConvertMoney(cInfo[contid][BetPrice], balansestr);
            format(str_win, sizeof(str_win), "| {ffffff}Вы успешно выиграли контейнер{ffff00} #%d{ffffff}! С вашего счета списано {ffff00}%s {ffffff}рублей.", contid, balansestr);
            SendClientMessage(winnerid, 0xFFFF00FF, str_win);
            
            new moneystr[15];
            ConvertMoney(cInfo[contid][BetPrice], moneystr);
            new str[300];
            format(str, sizeof(str), "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги окончены\n{993333}Последняя попедная ставка: {FFFFFF}%s рублей\n{993333}Победитель торгов: {FFFFFF}%s\n{993333}Для открытия введите: {FFFFFF}/cont", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr, winner_name);
            UpdateDynamic3DTextLabelText(ContsText[contid], 0x00FF00FF, str);

            MoveObject(cInfo[contid][ContObjectDoorLId], door1X, door1Y, door1Z, 8.5, 0, 0, door1A + 128.0);
            MoveObject(cInfo[contid][ContObjectDoorRId], door2X, door2Y, door2Z, 8.5, 0, 0, door2A - 128.0);
        }
        else
        {
            new moneystr[15];
            ConvertMoney(cInfo[contid][ContPrice], moneystr);
            new str[256];
            format(str, sizeof str, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги не состоялись\n{993333}Начальная ставка: {FFFFFF}%s рублей", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr);
            UpdateDynamic3DTextLabelText(ContsText[contid], 0xFFFF00FF, str);

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
    UpdateDynamic3DTextLabelText(ContsText[contid], 0xFF0000FF, "");
    
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
    else if(hour >= 8 && hour < 23 && minute == 1)
    {
        for(new cont = 1; cont <= MAX_CONT; cont++)
        {
            if(cInfo[cont][Saled] == false)
            {
                SpawnCont(cont);
            }
        }
    }
    else if(hour >= 8 && hour < 23 && minute == 15)
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
        if(IsPlayerInRangeOfPoint(playerid, 3.0, ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], ContBuyTextPos[cont][2]))
        {
            sell_limit = true;
            
            if(cInfo[cont][Saled] == true)
            {
                if(cInfo[cont][BetedId] == playerid) return SendClientMessage(playerid, 0xFF0000FF, "| {ffffff}Ставка на контейнер уже ваша, вы не можете перебить свою ставку");
                
                c_pInfo[playerid][BetUseCont] = cont;

                new str[140], betstr[15];
                ConvertMoney(cInfo[cont][BetPrice], betstr);
                format(str, sizeof str, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                ShowPlayerDialog(playerid, 2854, DIALOG_STYLE_INPUT, "{FF0000}"SERVER_NAME" {ffffff}| Битва за контейнер", str, "Готово", "Отмена");
            }
            else
            {
                if(cInfo[cont][BetedId] == playerid)
                {
                    c_pInfo[playerid][BuyUseCont] = cont;

                    new prize_name[64];
                    new prize_price_string[32];
                    new prize_modelid = cInfo[cont][Item];
                    
                    if (cInfo[cont][ItemType] == 1) 
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
                    else if (cInfo[cont][ItemType] == 2) 
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

                    TextDrawShowForPlayer(playerid, cont_fon);
                    TextDrawShowForPlayer(playerid, cont_take);
                    TextDrawShowForPlayer(playerid, cont_sell);
                    TextDrawShowForPlayer(playerid, cont_close);
                    TextDrawShowForPlayer(playerid, cont_name[cont]);
                    TextDrawShowForPlayer(playerid, cont_price[cont]);
                    TextDrawShowForPlayer(playerid, cont_model[cont]);
                    
                    for(new a;a < 15;a++)  SendClientMessage(playerid, 0xFFFFFFFF, "");          
                    SelectTextDraw(playerid, 0xFFFFFFFF);
                }
            }
        }
    }
    return 1;
}

stock StartCont()
{
    print("Доставка контейнеров в старый порт");
    StopCont();
    for(new cont=1; cont <= MAX_CONT; cont++)
    {
        SpawnCont(cont);
    }
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
}

stock StartContBidding(contid)
{
    cInfo[contid][SaleTime] = 30;
    KillTimer(ContsTimer[contid]);

    new moneystr[15], betstr[15];
    ConvertMoney(cInfo[contid][ContPrice], moneystr);
    ConvertMoney(cInfo[contid][BetPrice], betstr);
    
    new str[366];
    format(str, sizeof str, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}идут активные торги\n{993333}Последняя ставка: {FFFFFF}%s рублей\n{993333}Начальная ставка: {FFFFFF}%s рублей\n{993333}Ставка сделана от: {FFFFFF}%s\n{993333}Время проведения торгов: {FFFFFF}%d секунд", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), betstr, moneystr, cInfo[contid][BetedName], cInfo[contid][SaleTime]);
    UpdateDynamic3DTextLabelText(ContsText[contid], 0xFF0000FF, str);
    
    ContsTimer[contid] = SetTimerEx("TimerSecondUpdateCont", 1000, true, "ds", contid, moneystr);
    return 1;
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
  if(clickedid == cont_sell)
    {
        new cont = c_pInfo[playerid][BuyUseCont];
        if(IsPlayerInRangeOfPoint(playerid, 4.0, ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], ContBuyTextPos[cont][2]) && cInfo[cont][Saled] == false)
        {
            if(cInfo[cont][BetedId] == playerid)
            {
                new sell_price_string[120];
                new sell_price = cInfo[cont][ItemPrice];
                GivePlayerMoneyEx(playerid, sell_price);
                format(sell_price_string, sizeof(sell_price_string), "| {ffffff}Вы успешно продали содержимое контейнера {ffff00}#%d {ffffff}за {ffff00}%d {ffff00}рублей!", cont, sell_price);
                SendClientMessage(playerid, 0x00FF00FF, sell_price_string);

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
                c_pInfo[playerid][BuyUseCont] = 0;
                c_pInfo[playerid][BetUseCont] = 0;

                SetTimerEx("SpawnNewCont", 5000, false, "i", cont);
            }
        }
    }
    if(clickedid == cont_take)
    {
        new cont = c_pInfo[playerid][BuyUseCont];
        if(IsPlayerInRangeOfPoint(playerid, 4.0, ContBuyTextPos[cont][0], ContBuyTextPos[cont][1], ContBuyTextPos[cont][2]) && cInfo[cont][Saled] == false)
        {
            if(cInfo[cont][BetedId] == playerid)
            {
                if (cInfo[cont][ItemType] == 1) 
                {                  
                    cont_GivePlayerOwnableSkinEx(playerid, cInfo[cont][Item]);
                    SendClientMessage(playerid, 0x00FF00FF, "| {ffffff}Вы получили одежду которую выиграли в контейнере!");
                }
                else if (cInfo[cont][ItemType] == 2) 
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
                    SendClientMessage(playerid, 0x00FF00FF, "| {ffffff}Поздравляем! Вы получили новый автомобиль, используй /car для подробностей");
                }

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
                c_pInfo[playerid][BuyUseCont] = 0;
                c_pInfo[playerid][BetUseCont] = 0;

                SetTimerEx("SpawnNewCont", 5000, false, "i", cont);
            }
        }
    }
    if(clickedid == cont_close)
    {
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
        #if defined cont_OnPlayerClickTextDraw
        return cont_OnPlayerClickTextDraw(playerid, Text:clickedid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw cont_OnPlayerClickTextDraw
#if defined cont_OnPlayerClickTextDraw
    forward cont_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

stock cont_GivePlayerOwnableSkinEx(playerid, skinid)
{
  SetPlayerSkin(playerid, skinid);
  SetPlayerData(playerid, P_SKIN, skinid);
  UpdatePlayerDatabaseInt(playerid, "skin", skinid);
  SetPlayerSkinInit(playerid);
  if(mysql_errno()) return SendClientMessage(playerid, -1, "Проблема с базой данных, проверь её!");	
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    	if(dialogid == 2854)
    {
        if(response)
        {
            new cont = c_pInfo[playerid][BetUseCont];
            if(cont == 0) return printf("ERROR PLAYERID: %d (contuse == 0)");
            if(cInfo[cont][Saled] == true)
            {
                if(cInfo[cont][BetedId] == playerid) return SendClientMessage(playerid, 0xFF0000FF, "| {ffffff}Ставка на контейнер уже ваша, вы не можете перебить свою ставку");
                if(0 < strval(inputtext) < 100000000)
                {
                    if(GetPlayerMoneyEx(playerid) >= strval(inputtext))
                    {
                        if(strval(inputtext)-99999 > cInfo[cont][BetPrice])
                        {
                            if(strval(inputtext) > cInfo[cont][ContPrice] && strval(inputtext) > cInfo[cont][BetPrice])
                            {
                                new str[111];
                                new name[MAX_PLAYER_NAME]; GetPlayerName(playerid, name, MAX_PLAYER_NAME);
                                if(cInfo[cont][BetedId] != INVALID_PLAYER_ID)
                                {
                                    format(str, sizeof str, "| {ffffff}Ваша ставка была отменена в связи с тем, что игрок {FF6347}%s {ffffff}поставил больше!", name);
                                    SendClientMessage(cInfo[cont][BetedId], 0xFF0000FF, str);
                                }

                                cInfo[cont][BetPrice] = strval(inputtext);
                                cInfo[cont][BetedId] = playerid;
                                format(cInfo[cont][BetedName], MAX_PLAYER_NAME, "%s", name);

                                new betstr[15];
                                ConvertMoney(cInfo[cont][BetPrice], betstr);
                                format(str, sizeof str, "| {ffffff}Вы успешно сделали ставку в размере {FFFF00}%s {ffffff}рублей за контейнер {FFFF00}#%d", betstr, cont);
                                SendClientMessage(playerid, 0xFFFF00FF, str);

                                StartContBidding(cont);
                            }
                            else
                            {
                                new str[140], betstr[15];
                                ConvertMoney(cInfo[cont][BetPrice], betstr);
                                format(str, sizeof str, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                                ShowPlayerDialog(playerid, 2854, DIALOG_STYLE_INPUT, "{FF6347}"PROJECT_NAME_FOR_CONT" {ffffff}| Битва за контейнер", str,  "Готово", "Отмена");
                                SendClientMessage(playerid, 0xFF0000FF, "| {ffffff}Ваша ставка должна быть выше последней!");
                                c_pInfo[playerid][BetUseCont] = 0;
                            }
                        }
                        else
                        {
                            new str[140], betstr[15];
                            ConvertMoney(cInfo[cont][BetPrice], betstr);
                            format(str, sizeof str, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                            ShowPlayerDialog(playerid, 2854, DIALOG_STYLE_INPUT, "{FF6347}"PROJECT_NAME_FOR_CONT" {ffffff}| Битва за контейнер", str,  "Готово", "Отмена");
                            SendClientMessage(playerid, 0xFF0000FF, "| {ffffff}Минимальный подьем ставки 100.000 рублей!");
                            c_pInfo[playerid][BetUseCont] = 0;
                        }
                    }
                    else
                    {
                        new str[140], betstr[15];
                        ConvertMoney(cInfo[cont][BetPrice], betstr);
                        format(str, sizeof str, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                        ShowPlayerDialog(playerid, 2854, DIALOG_STYLE_INPUT, "{FF6347}"PROJECT_NAME_FOR_CONT" {ffffff}| Битва за контейнер", str,  "Готово", "Отмена");
                        SendClientMessage(playerid, 0xFF0000FF, "| {ffffff}У вас недостаточно средств для такой ставки!");
                        c_pInfo[playerid][BetUseCont] = 0;
                    }
                }
                else
                {
                    new str[140], betstr[15];
                    ConvertMoney(cInfo[cont][BetPrice], betstr);
                    format(str, sizeof str, "Последняя сделанная ставка: %s рублей\n\nДля того, чтобы сделать свою ставку Вам необходимо\nбудет ввести ее в диалоговом поле ниже:", betstr);
                    ShowPlayerDialog(playerid, 2854, DIALOG_STYLE_INPUT, "{FF6347}"PROJECT_NAME_FOR_CONT" {ffffff}| Битва за контейнер", str,  "Готово", "Отмена");
                    SendClientMessage(playerid, 0xFF0000FF, "{ffffff}Введите корректную ставку!");
                    c_pInfo[playerid][BetUseCont] = 0;
                }
            }
        }
    }
        #if defined cont_OnDialogResponse
        return cont_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse cont_OnDialogResponse
#if defined cont_OnDialogResponse
forward cont_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public SpawnNewCont(contid)
{
    SpawnCont(contid);
}

public OnGameModeInit()
{
    CreateContTextDraw(); 
     CreateContainers();   
    #if defined cont_OnGameModeInit
        return cont_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit cont_OnGameModeInit
#if defined cont_OnGameModeInit
    forward cont_OnGameModeInit();
#endif

CMD:startcont(playerid)
{
    if(GetPlayerAdminEx(playerid) < 11) return 1;
    StartCont();  
    ShowNewNotification(playerid, 1, 3, 0, 0, "Вы самостоятельно запустили торги за контейнера", ">>");
     return 1;
}

CMD:stopcont(playerid)
{
    if(GetPlayerAdminEx(playerid) < 11) return 1;
    StopCont();
    ShowNewNotification(playerid, 1, 3, 0, 0, "Вы остановили торги за контейнера", ">>");
    return 1;
}