/*
=====================================================
      TUNING WHEELS SYSTEM BY WELSI - FIXED VERSION
=====================================================
Инструкция по установке:

1. В паблик LoadOwnableCar после строки:
   if(vehicleid != INVALID_VEHICLE_ID)
   {
   
   Добавьте:
   SetVehicleWheels(GetOwnableCarData(idx, OC_SQL_ID), vehicleid);

2. Добавьте текстуры в кеш игры

=====================================================
*/

// ============== НАСТРОЙКИ СИСТЕМЫ ==============
#define WHEELS_TUNING_PRICE_MULTIPLIER 1000 // Множитель цены (цена = уровень * множитель)
#define WHEELS_TUNING_MAX_LEVEL 10 // Максимальный уровень настройки
#define WHEELS_TUNING_DEFAULT_SIZE 0.75 // Размер колёс по умолчанию
#define WHEELS_TUNING_DEFAULT_BIAS 0.5 // Отдельный клиренс по умолчанию
#define WHEELS_TUNING_DEFAULT_LOWER -0.1 // Общий клиренс по умолчанию
#define WHEELS_TUNING_DEFAULT_CAMBER 0 // Развал по умолчанию

// Позиция шиномонтажа
#define WHEELS_TUNING_POS_X 259.4374
#define WHEELS_TUNING_POS_Y 703.6487
#define WHEELS_TUNING_POS_Z 11.9801

// Позиция внутри интерьера
#define WHEELS_TUNING_INT_X 995.7352
#define WHEELS_TUNING_INT_Y 1001.6589
#define WHEELS_TUNING_INT_Z 1500.1557
#define WHEELS_TUNING_INT_ANGLE 177.4436
// ===============================================

// ============== ГЛОБАЛЬНЫЕ ПЕРЕМЕННЫЕ ==============
static Text:gWheelsTD[5];
static PlayerText:gWheelsPTD[MAX_PLAYERS][11];

enum E_WHEELS_TUNING_DATA
{
    Float:wtCurrentValue,
    wtSelectedPanel,
    wtSelectedLevel,
    wtPrice
}

static gWheelsData[MAX_PLAYERS][E_WHEELS_TUNING_DATA];

// Значения по умолчанию для разных панелей
static const Float:gDefaultValues[4] = 
{
    -0.1,   // Общий клиренс
    0.5,    // Отдельный клиренс
    0.75,   // Размер колёс
    0.0     // Развал
};

// Шаги изменения для разных панелей
static const Float:gStepValues[4] = 
{
    0.03,   // Общий клиренс
    0.07,   // Отдельный клиренс
    0.05,   // Размер колёс
    2.0     // Развал
};

// Текстурные ID для разных типов настроек
static const gPanelTextures[4][2][] = 
{
    {"txd:brtuning3m11", "txd:brtuning3m14"},
    {"txd:brtuning3m12", "txd:brtuning3m15"},
    {"txd:brtuning3m13", "txd:brtuning3m16"},
    {"txd:brtuning3m19", "txd:brtuning3m20"}
};

static const gPanelInfoTextures[4][] = 
{
    "txd:brtuning3oklirens",
    "txd:brtuning3otklirens",
    "txd:brtuning3razval",
    "txd:brtuning3sizewheel"
};

static const gPanelDescTextures[4][] = 
{
    "txd:brtuning3noklirens",
    "txd:brtuning3notklirens",
    "txd:brtuning3nrazval",
    "txd:brtuning3nsizewheel"
};

static const gPanelNames[4][] = 
{
    "общий клиренс",
    "отдельный клиренс",
    "размер колёс",
    "развал"
};

// Хранение настроек для каждого транспорта
new Float:gWheelsSize[MAX_VEHICLES];
new Float:gWheelsBias[MAX_VEHICLES];
new Float:gWheelsLower[MAX_VEHICLES];
new gWheelsCamber[MAX_VEHICLES];

// ============== ФУНКЦИИ ТЕКСТДРАВОВ ==============
static stock CreateWheelsTextDraws()
{
    gWheelsTD[1] = TextDrawCreate(484.6665, 150.4369, "txd:brtuning2service");
    TextDrawTextSize(gWheelsTD[1], 146.0000, 172.0000);
    TextDrawAlignment(gWheelsTD[1], 1);
    TextDrawColor(gWheelsTD[1], -1);
    TextDrawBackgroundColor(gWheelsTD[1], 255);
    TextDrawFont(gWheelsTD[1], 4);
    TextDrawSetProportional(gWheelsTD[1], 0);
    TextDrawSetShadow(gWheelsTD[1], 0);

    gWheelsTD[2] = TextDrawCreate(186.3332, 389.7853, "txd:brtuning3cost");
    TextDrawTextSize(gWheelsTD[2], 265.0000, 24.0000);
    TextDrawAlignment(gWheelsTD[2], 1);
    TextDrawColor(gWheelsTD[2], -1);
    TextDrawBackgroundColor(gWheelsTD[2], 255);
    TextDrawFont(gWheelsTD[2], 4);
    TextDrawSetProportional(gWheelsTD[2], 0);
    TextDrawSetShadow(gWheelsTD[2], 0);
    
    gWheelsTD[0] = TextDrawCreate(580.9998, 2.0888, "");
    TextDrawLetterSize(gWheelsTD[0], 0.1480, 0.8740);
    TextDrawTextSize(gWheelsTD[0], -101.0000, 0.0000);
    TextDrawAlignment(gWheelsTD[0], 1);
    TextDrawColor(gWheelsTD[0], -81);
    TextDrawBackgroundColor(gWheelsTD[0], 255);
    TextDrawFont(gWheelsTD[0], 1);
    TextDrawSetProportional(gWheelsTD[0], 1);
    TextDrawSetShadow(gWheelsTD[0], 0);
    
    gWheelsTD[3] = TextDrawCreate(186.9998, 419.6520, "txd:brtuning2buy");
    TextDrawTextSize(gWheelsTD[3], 116.0000, 24.0000);
    TextDrawAlignment(gWheelsTD[3], 1);
    TextDrawColor(gWheelsTD[3], -1);
    TextDrawBackgroundColor(gWheelsTD[3], 255);
    TextDrawFont(gWheelsTD[3], 4);
    TextDrawSetProportional(gWheelsTD[3], 0);
    TextDrawSetShadow(gWheelsTD[3], 0);
    TextDrawSetSelectable(gWheelsTD[3], true);

    gWheelsTD[4] = TextDrawCreate(334.6665, 419.6520, "txd:brtuning2exit");
    TextDrawTextSize(gWheelsTD[4], 116.0000, 24.0000);
    TextDrawAlignment(gWheelsTD[4], 1);
    TextDrawColor(gWheelsTD[4], -1);
    TextDrawBackgroundColor(gWheelsTD[4], 255);
    TextDrawFont(gWheelsTD[4], 4);
    TextDrawSetProportional(gWheelsTD[4], 0);
    TextDrawSetShadow(gWheelsTD[4], 0);
    TextDrawSetSelectable(gWheelsTD[4], true);
    
    return 1;
}

static stock CreatePlayerWheelsTextDraws(playerid)
{
    gWheelsPTD[playerid][0] = CreatePlayerTextDraw(playerid, 503.0000, 165.1257, "txd:brtuning3m11");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][0], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][0], 0);
    PlayerTextDrawSetSelectable(playerid, gWheelsPTD[playerid][0], true);

    gWheelsPTD[playerid][1] = CreatePlayerTextDraw(playerid, 503.0000, 203.2888, "txd:brtuning3m12");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][1], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][1], 0);
    PlayerTextDrawSetSelectable(playerid, gWheelsPTD[playerid][1], true);

    gWheelsPTD[playerid][2] = CreatePlayerTextDraw(playerid, 503.0000, 241.0368, "txd:brtuning3m13");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][2], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][2], 0);
    PlayerTextDrawSetSelectable(playerid, gWheelsPTD[playerid][2], true);

    gWheelsPTD[playerid][3] = CreatePlayerTextDraw(playerid, 503.0000, 278.7850, "txd:brtuning3m19");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][3], 116.0000, 28.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][3], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][3], 0);
    PlayerTextDrawSetSelectable(playerid, gWheelsPTD[playerid][3], true);

    gWheelsPTD[playerid][4] = CreatePlayerTextDraw(playerid, 186.3332, 357.8445, "txd:brtuning3noklirens");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][4], 265.0000, 24.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][4], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][4], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][4], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][4], 0);
    PlayerTextDrawSetSelectable(playerid, gWheelsPTD[playerid][4], false);

    gWheelsPTD[playerid][5] = CreatePlayerTextDraw(playerid, 3.0000, 181.1333, "txd:brtuning3oklirens");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][5], 164.0000, 115.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][5], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][5], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][5], 0);
    PlayerTextDrawSetSelectable(playerid, gWheelsPTD[playerid][5], false);

    gWheelsPTD[playerid][6] = CreatePlayerTextDraw(playerid, 18.3332, 240.8666, "txd:brtuning2stage5");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][6], 131.0000, 9.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][6], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][6], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][6], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][6], 0);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][6], 0);

    gWheelsPTD[playerid][7] = CreatePlayerTextDraw(playerid, 80.0000, 241.1925, "0.75");
    PlayerTextDrawLetterSize(playerid, gWheelsPTD[playerid][7], 0.1712, 0.9404);
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][7], -37.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][7], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][7], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][7], 2);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][7], 0);

    gWheelsPTD[playerid][8] = CreatePlayerTextDraw(playerid, 385.6666, 395.3333, "0 РУБ");
    PlayerTextDrawLetterSize(playerid, gWheelsPTD[playerid][8], 0.2479, 1.1684);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][8], 3);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][8], 8388863);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][8], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][8], 1);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, gWheelsPTD[playerid][8], 0);

    gWheelsPTD[playerid][9] = CreatePlayerTextDraw(playerid, 87.6666, 258.7034, "txd:brtuning2plus");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][9], 62.0000, 19.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][9], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][9], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][9], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][9], 0);
    PlayerTextDrawSetSelectable(playerid, gWheelsPTD[playerid][9], true);

    gWheelsPTD[playerid][10] = CreatePlayerTextDraw(playerid, 18.3332, 259.1184, "txd:brtuning2minus");
    PlayerTextDrawTextSize(playerid, gWheelsPTD[playerid][10], 62.0000, 19.0000);
    PlayerTextDrawAlignment(playerid, gWheelsPTD[playerid][10], 1);
    PlayerTextDrawColor(playerid, gWheelsPTD[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, gWheelsPTD[playerid][10], 255);
    PlayerTextDrawFont(playerid, gWheelsPTD[playerid][10], 4);
    PlayerTextDrawSetProportional(playerid, gWheelsPTD[playerid][10], 0);
    PlayerTextDrawSetSelectable(playerid, gWheelsPTD[playerid][10], true);

    return 1;
}

// ============== ОСНОВНЫЕ ФУНКЦИИ ==============
static stock ResetWheelsTuningData(playerid)
{
    gWheelsData[playerid][wtCurrentValue] = 0.0;
    gWheelsData[playerid][wtSelectedPanel] = 0;
    gWheelsData[playerid][wtSelectedLevel] = 0;
    gWheelsData[playerid][wtPrice] = 0;
    return 1;
}

static stock HideWheelsPanel(playerid)
{
    for(new i; i < 5; i++) 
        TextDrawHideForPlayer(playerid, gWheelsTD[i]);

    for(new i; i < 11; i++) 
        PlayerTextDrawHide(playerid, gWheelsPTD[playerid][i]);

    ResetWheelsTuningData(playerid);
    return 1;
}

static stock ShowWheelsPanel(playerid, panel)
{
    if(panel < 0 || panel >= 4) return 0;
    
    new oldPanel = gWheelsData[playerid][wtSelectedPanel] - 1;
    
    // Сбрасываем предыдущую выбранную панель
    if(gWheelsData[playerid][wtSelectedPanel] != 0 && oldPanel >= 0) 
    {
        PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][oldPanel], gPanelTextures[oldPanel][0]);
    }

    // Устанавливаем новую панель
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][panel], gPanelTextures[panel][1]);
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][5], gPanelInfoTextures[panel]);
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][4], gPanelDescTextures[panel]);
    
    // Получаем текущее значение для этого типа тюнинга
    new vehicleid = GetPlayerOwnableCar(playerid);
    new Float:currentValue;
    
    switch(panel)
    {
        case 0: currentValue = gWheelsLower[vehicleid];
        case 1: currentValue = gWheelsBias[vehicleid];
        case 2: currentValue = gWheelsSize[vehicleid];
        case 3: currentValue = float(gWheelsCamber[vehicleid]);
    }
    
    // Если значение по умолчанию, используем стандартное
    if(currentValue == 0.0)
    {
        currentValue = gDefaultValues[panel];
    }
    
    // Определяем уровень на основе значения (приблизительно)
    new level = 5;
    if(panel != 3)
    {
        // Для не-развала вычисляем уровень приблизительно
        if(panel == 0) level = floatround((currentValue - (-0.25)) / 0.03) + 1;
        else if(panel == 1) level = floatround(currentValue / 0.07) + 1;
        else if(panel == 2) level = floatround(currentValue / 0.05) + 1;
        
        if(level < 1) level = 1;
        if(level > WHEELS_TUNING_MAX_LEVEL) level = WHEELS_TUNING_MAX_LEVEL;
    }
    
    // Устанавливаем уровень
    new levelStr[32];
    format(levelStr, sizeof(levelStr), "txd:brtuning2stage%d", level);
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][6], levelStr);
    
    // Устанавливаем значение
    new valueStr[16];
    if(panel == 3)
        format(valueStr, sizeof(valueStr), "%d", floatround(currentValue));
    else
        format(valueStr, sizeof(valueStr), "%.2f", currentValue);
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][7], valueStr);

    // Показываем все текстдравы
    for(new i = 0; i < 11; i++) 
        PlayerTextDrawShow(playerid, gWheelsPTD[playerid][i]);
    
    // Сохраняем данные
    gWheelsData[playerid][wtCurrentValue] = currentValue;
    gWheelsData[playerid][wtSelectedPanel] = panel + 1;
    gWheelsData[playerid][wtSelectedLevel] = level;
    gWheelsData[playerid][wtPrice] = level * WHEELS_TUNING_PRICE_MULTIPLIER;
    
    // Обновляем цену
    new priceStr[32];
    format(priceStr, sizeof(priceStr), "%d РУБ", gWheelsData[playerid][wtPrice]);
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][8], priceStr);
    
    return 1;
}

static stock UpdateWheelsValue(playerid, bool:increase)
{
    if(!gWheelsData[playerid][wtSelectedPanel]) return 0;
    
    new panel = gWheelsData[playerid][wtSelectedPanel] - 1;
    new level = gWheelsData[playerid][wtSelectedLevel];
    
    if(increase)
    {
        if(level + 1 > WHEELS_TUNING_MAX_LEVEL) return 0;
        level++;
        gWheelsData[playerid][wtCurrentValue] += gStepValues[panel];
    }
    else
    {
        if(level - 1 < 1) return 0;
        level--;
        gWheelsData[playerid][wtCurrentValue] -= gStepValues[panel];
    }
    
    gWheelsData[playerid][wtSelectedLevel] = level;
    gWheelsData[playerid][wtPrice] = level * WHEELS_TUNING_PRICE_MULTIPLIER;
    
    // Обновляем текст
    new string[32];
    format(string, sizeof(string), "txd:brtuning2stage%d", level);
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][6], string);
    
    if(panel == 3) // Для развала отображаем целое число
        format(string, sizeof(string), "%d", floatround(gWheelsData[playerid][wtCurrentValue]));
    else
        format(string, sizeof(string), "%.2f", gWheelsData[playerid][wtCurrentValue]);
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][7], string);
    
    format(string, sizeof(string), "%d РУБ", gWheelsData[playerid][wtPrice]);
    PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][8], string);
    
    // Применяем изменения к машине
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid != GetPlayerOwnableCar(playerid)) return 0;
    
    switch(panel)
    {
        case 0: SetVehicleSuspensionLower(vehicleid, gWheelsData[playerid][wtCurrentValue]);
        case 1: SetVehicleSuspensionBias(vehicleid, gWheelsData[playerid][wtCurrentValue]);
        case 2: SetVehicleWheelSize(vehicleid, gWheelsData[playerid][wtCurrentValue]);
        case 3: 
        {
            new camber = floatround(gWheelsData[playerid][wtCurrentValue]);
            SetVehicleWheelAngle(vehicleid, 0, camber);
            SetVehicleWheelAngle(vehicleid, 1, camber);
        }
    }
    
    return 1;
}

// ============== БАЗА ДАННЫХ ==============
static stock UpdateWheelsInDatabase(sqlID, vehicleid)
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), 
        "UPDATE ownable_cars SET wheels_kl = %f, wheels_otkl = %f, wheels_size = %f, wheels_raz = %d WHERE id = %d",
        gWheelsLower[vehicleid], 
        gWheelsBias[vehicleid], 
        gWheelsSize[vehicleid],
        gWheelsCamber[vehicleid], 
        sqlID
    );
    mysql_query(mysql, query, false);
    return 1;
}

// ============== ПУБЛИЧНЫЕ ФУНКЦИИ ==============
stock SetVehicleWheels(sqlID, vehicleid)
{
    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM ownable_cars WHERE id = %d", sqlID);
    new Cache:cache = mysql_query(mysql, query, true);

    if(cache_num_rows())
    {
        new Float:size = cache_get_field_content_float(0, "wheels_size");
        new Float:bias = cache_get_field_content_float(0, "wheels_otkl");
        new Float:lower = cache_get_field_content_float(0, "wheels_kl");
        new camber = cache_get_field_content_int(0, "wheels_raz");

        // Устанавливаем значения по умолчанию если нужно
        if(size == 0.0) size = WHEELS_TUNING_DEFAULT_SIZE;
        if(bias == 0.0) bias = WHEELS_TUNING_DEFAULT_BIAS;
        if(lower == 0.0) lower = WHEELS_TUNING_DEFAULT_LOWER;
        
        // Сохраняем в массив
        gWheelsSize[vehicleid] = size;
        gWheelsBias[vehicleid] = bias;
        gWheelsLower[vehicleid] = lower;
        gWheelsCamber[vehicleid] = camber;

        // Применяем настройки (если есть соответствующие функции)
        #if defined SetVehicleSuspensionLower
            SetVehicleSuspensionLower(vehicleid, lower);
        #endif
        
        #if defined SetVehicleSuspensionBias
            SetVehicleSuspensionBias(vehicleid, bias);
        #endif
        
        #if defined SetVehicleWheelSize
            SetVehicleWheelSize(vehicleid, size);
        #endif
        
        #if defined SetVehicleWheelAngle
            SetVehicleWheelAngle(vehicleid, 0, camber);
            SetVehicleWheelAngle(vehicleid, 1, camber);
        #endif
    }

    cache_delete(cache);
    return 1;
}

// ============== КОЛЛБЭКИ ==============
public OnGameModeInit()
{
    print("[WHEELS_TUNING] Система тюнинга колёс загружена");
    
    // Создаём 3D метку
    Create3DTextLabel("{FFFF00}Шиномонтаж\n{FFFFFF}Нажмите 'Гудок' для входа", 
        -1, WHEELS_TUNING_POS_X, WHEELS_TUNING_POS_Y, WHEELS_TUNING_POS_Z + 2.0, 20.0, 0);
    
    CreateWheelsTextDraws();
    
    // Инициализируем массивы
    for(new i; i < MAX_VEHICLES; i++)
    {
        gWheelsSize[i] = WHEELS_TUNING_DEFAULT_SIZE;
        gWheelsBias[i] = WHEELS_TUNING_DEFAULT_BIAS;
        gWheelsLower[i] = WHEELS_TUNING_DEFAULT_LOWER;
        gWheelsCamber[i] = WHEELS_TUNING_DEFAULT_CAMBER;
    }
    
    // Проверяем и добавляем поля в БД
    SetTimer("CheckWheelsDatabaseFields", 5000, false);
    
    #if defined wt_OnGameModeInit
        return wt_OnGameModeInit();
    #else
        return 1;
    #endif
}

forward CheckWheelsDatabaseFields();
public CheckWheelsDatabaseFields()
{
    new query[256];
    mysql_format(mysql, query, sizeof(query), "SHOW COLUMNS FROM ownable_cars LIKE 'wheels_kl'");
    new Cache:cache = mysql_query(mysql, query, true);
    
    if(!cache_num_rows())
    {
        cache_delete(cache);
        mysql_query(mysql, "ALTER TABLE `ownable_cars` ADD `wheels_kl` FLOAT NOT NULL DEFAULT '-0.1' AFTER `model_id`", false);
        mysql_query(mysql, "ALTER TABLE `ownable_cars` ADD `wheels_size` FLOAT NOT NULL DEFAULT '0.75' AFTER `wheels_kl`", false);
        mysql_query(mysql, "ALTER TABLE `ownable_cars` ADD `wheels_raz` INT NOT NULL DEFAULT '0' AFTER `wheels_size`", false);
        mysql_query(mysql, "ALTER TABLE `ownable_cars` ADD `wheels_otkl` FLOAT NOT NULL DEFAULT '0.5' AFTER `wheels_raz`", false);
        print("[WHEELS_TUNING] Поля в БД успешно добавлены");
    }
    else cache_delete(cache);
    
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == PLAYER_STATE_DRIVER)
    {
        new vehicleid = GetPlayerVehicleID(playerid);
        
        if(GetPlayerOwnableCar(playerid) == vehicleid && PRESSED(KEY_CROUCH))
        {
            if(IsPlayerInRangeOfPoint(playerid, 5.0, WHEELS_TUNING_POS_X, WHEELS_TUNING_POS_Y, WHEELS_TUNING_POS_Z))
            {
                new world = playerid + 1000;
                
                // Телепортируем в интерьер
                SetPlayerVirtualWorld(playerid, world);
                SetVehicleVirtualWorld(vehicleid, world);
                SetVehiclePos(vehicleid, WHEELS_TUNING_INT_X, WHEELS_TUNING_INT_Y, WHEELS_TUNING_INT_Z);
                SetVehicleZAngle(vehicleid, WHEELS_TUNING_INT_ANGLE);
                LinkVehicleToInterior(vehicleid, 1);
                SetPlayerInterior(playerid, 1);
                
                // Настраиваем камеру
                SetPlayerCameraPos(playerid, 999.656250, 998.227416, 1501.000000);
                SetPlayerCameraLookAt(playerid, WHEELS_TUNING_INT_X, WHEELS_TUNING_INT_Y, WHEELS_TUNING_INT_Z);
                
                // Создаём текстдравы
                CreatePlayerWheelsTextDraws(playerid);
                ResetWheelsTuningData(playerid);
                
                // Показываем интерфейс
                TextDrawShowForPlayer(playerid, gWheelsTD[1]);
                for(new i = 0; i < 4; i++) 
                    PlayerTextDrawShow(playerid, gWheelsPTD[playerid][i]);
                    
                for(new i = 0; i < 5; i++) 
                    TextDrawShowForPlayer(playerid, gWheelsTD[i]);
                    
                PlayerTextDrawShow(playerid, gWheelsPTD[playerid][4]);
                PlayerTextDrawShow(playerid, gWheelsPTD[playerid][8]);
                
                // Скрываем HUD и блокируем управление
                #if defined HideHud
                    HideHud(playerid);
                #endif
                
                TogglePlayerControllable(playerid, false);
                SelectTextDraw(playerid, -1);
                
                // Сажаем обратно в машину
                PutPlayerInVehicle(playerid, vehicleid, 0);
                return 1;
            }
        }
    }
    
    #if defined wt_OnPlayerKeyStateChange
        return wt_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
}

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{
    if(clickedid == gWheelsTD[3]) // Кнопка покупки
    {
        if(!gWheelsData[playerid][wtSelectedPanel]) 
            return 1;
            
        new price = gWheelsData[playerid][wtPrice];
        
        if(GetPlayerMoneyEx(playerid) >= price)
        {
            GivePlayerMoneyEx(playerid, -price);
            
            new panel = gWheelsData[playerid][wtSelectedPanel] - 1;
            
            new msg[128];
            format(msg, sizeof(msg), "Вы успешно купили настройку на %s", gPanelNames[panel]);
            SendClientMessage(playerid, -1, msg);
            
            // Сохраняем настройки в массив
            new vehicleid = GetPlayerOwnableCar(playerid);
            switch(panel)
            {
                case 0: gWheelsLower[vehicleid] = gWheelsData[playerid][wtCurrentValue];
                case 1: gWheelsBias[vehicleid] = gWheelsData[playerid][wtCurrentValue];
                case 2: gWheelsSize[vehicleid] = gWheelsData[playerid][wtCurrentValue];
                case 3: gWheelsCamber[vehicleid] = floatround(gWheelsData[playerid][wtCurrentValue]);
            }
            
            new index = GetVehicleData(vehicleid, V_ACTION_ID);
            UpdateWheelsInDatabase(GetOwnableCarData(index, OC_SQL_ID), vehicleid);
            
            // Сбрасываем выделение
            new oldPanel = gWheelsData[playerid][wtSelectedPanel] - 1;
            PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][oldPanel], gPanelTextures[oldPanel][0]);
            
            // Скрываем элементы
            for(new i = 5; i < 11; i++) 
                PlayerTextDrawHide(playerid, gWheelsPTD[playerid][i]);
            
            // Сбрасываем данные
            gWheelsData[playerid][wtSelectedPanel] = 0;
            gWheelsData[playerid][wtCurrentValue] = 0.0;
            gWheelsData[playerid][wtPrice] = 0;
            
            format(msg, sizeof(msg), "%d РУБ", 0);
            PlayerTextDrawSetString(playerid, gWheelsPTD[playerid][8], msg);
        }
        else
        {
            SendClientMessage(playerid, -1, "У вас недостаточно средств!");
        }
        return 1;
    }
    
    if(clickedid == gWheelsTD[4]) // Кнопка выхода
    {
        new vehicleid = GetPlayerOwnableCar(playerid);
        new index = GetVehicleData(vehicleid, V_ACTION_ID);
        
        // Возвращаем в обычный мир
        SetPlayerVirtualWorld(playerid, 0);
        SetVehicleVirtualWorld(vehicleid, 0);
        SetVehiclePos(vehicleid, WHEELS_TUNING_POS_X, WHEELS_TUNING_POS_Y, WHEELS_TUNING_POS_Z);
        SetVehicleZAngle(vehicleid, 249.617706);
        LinkVehicleToInterior(vehicleid, 0);
        SetPlayerInterior(playerid, 0);
        
        #if defined ShowHud
            ShowHud(playerid);
        #endif
        
        TogglePlayerControllable(playerid, true);
        SetCameraBehindPlayer(playerid);
        
        HideWheelsPanel(playerid);
        SetVehicleWheels(GetOwnableCarData(index, OC_SQL_ID), vehicleid);
        PutPlayerInVehicle(playerid, vehicleid, 0);
        CancelSelectTextDraw(playerid);
        return 1;
    }
    
    #if defined wt_OnPlayerClickTextDraw
        return wt_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 0;
    #endif
}

public OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid)
{
    // Кнопки выбора панелей
    for(new i = 0; i < 4; i++)
    {
        if(playertextid == gWheelsPTD[playerid][i])
        {
            ShowWheelsPanel(playerid, i);
            return 1;
        }
    }
    
    // Кнопка "+"
    if(playertextid == gWheelsPTD[playerid][9])
    {
        UpdateWheelsValue(playerid, true);
        return 1;
    }
    
    // Кнопка "-"
    if(playertextid == gWheelsPTD[playerid][10])
    {
        UpdateWheelsValue(playerid, false);
        return 1;
    }
    
    #if defined wt_OnPlayerClickPlayerTextDraw
        return wt_OnPlayerClickPlayerTextDraw(playerid, playertextid);
    #else
        return 0;
    #endif
}

public OnPlayerDisconnect(playerid, reason)
{
    // Очищаем данные при выходе
    for(new i = 0; i < 11; i++)
    {
        if(gWheelsPTD[playerid][i] != PlayerText:INVALID_TEXT_DRAW)
        {
            PlayerTextDrawDestroy(playerid, gWheelsPTD[playerid][i]);
            gWheelsPTD[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
        }
    }
    
    ResetWheelsTuningData(playerid);
    
    #if defined wt_OnPlayerDisconnect
        return wt_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

public OnVehicleSpawn(vehicleid)
{
    // При респавне машины применяем сохранённые настройки
    SetVehicleWheels(0, vehicleid); // 0 - заглушка, нужно передавать реальный SQL ID
    
    #if defined wt_OnVehicleSpawn
        return wt_OnVehicleSpawn(vehicleid);
    #else
        return 1;
    #endif
}

// ============== ХУКИ ДЛЯ ДРУГИХ МОДОВ ==============
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit wt_OnGameModeInit
#if defined wt_OnGameModeInit
    forward wt_OnGameModeInit();
#endif

#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange wt_OnPlayerKeyStateChange
#if defined wt_OnPlayerKeyStateChange
    forward wt_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw wt_OnPlayerClickTextDraw
#if defined wt_OnPlayerClickTextDraw
    forward wt_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif

#if defined _ALS_OnPlayerClickPlayerTextDraw
    #undef OnPlayerClickPlayerTextDraw
#else
    #define _ALS_OnPlayerClickPlayerTextDraw
#endif
#define OnPlayerClickPlayerTextDraw wt_OnPlayerClickPlayerTextDraw
#if defined wt_OnPlayerClickPlayerTextDraw
    forward wt_OnPlayerClickPlayerTextDraw(playerid, PlayerText:playertextid);
#endif

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect wt_OnPlayerDisconnect
#if defined wt_OnPlayerDisconnect
    forward wt_OnPlayerDisconnect(playerid, reason);
#endif

#if defined _ALS_OnVehicleSpawn
    #undef OnVehicleSpawn
#else
    #define _ALS_OnVehicleSpawn
#endif
#define OnVehicleSpawn wt_OnVehicleSpawn
#if defined wt_OnVehicleSpawn
    forward wt_OnVehicleSpawn(vehicleid);
#endif