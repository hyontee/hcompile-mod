#define FRACTION_DOOR 62
//#define TEAM_FSIN 11 // если у Вас есть система фракции ФСИН от ромчика, то это убираем

// если заменка ОЛД или НЕВ то нужно добавить в IPacket:ВАШ АЙДИ ПАКЕТА(playerid, BitStream:bs) 
// в case 13: (чаще всего он) добавить ко всем пхожим
/*
                    case FRACTION_DOOR:
					{
					    callcmd::door(playerid);
					}
*/
// Чтобы работал Фсин, нужно отдельное дополнение на эту фракцию

// Структуры для ворот
enum GateFractionInfo
{
    DynamicObject: GateObject,
    bool:IsOpened,
    GateModel,
    Team,
    MinRank,
    Float:OpenX, Float:OpenY, Float:OpenZ, Float:OpenRX, Float:OpenRY, Float:OpenRZ, Float:OpenSpeed,
    Float:CloseX, Float:CloseY, Float:CloseZ, Float:CloseRX, Float:CloseRY, Float:CloseRZ, Float:CloseSpeed,
    Float:TriggerX, Float:TriggerY, Float:TriggerZ, Float:TriggerRadius,
    Dynamic3DTextLabel: Label,
    LabelText[128]
};

new Float:GateFractionData[7][GateFractionInfo] =
{
    { // Ворота армии
        -1, // Объект ворот
        false, // Открыты ли ворота
        1717, // Модель ворот
        TEAM_ARMY, // Фракция
        3, // Минимальный ранг
        1891.1486, 1714.2531, 16.4444, 0.0, 0.0, 0.0, 1.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        1891.1486, 1721.5555, 16.4444, 0.0, 0.0, 0.0, 1.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        1891.1486, 1722.2531, 15.9780, 10.0, // Координаты и радиус триггера (X, Y, Z, Radius)
        -1, // Текстовая метка (Label)
        "{ffff00}«\t{ffffff}Ворота Армии\t{ffff00}»\n{ffffff}Используйте {ffff00}гудок{ffffff} для открытия" // Текст метки
    },
    { // Шлагбаум армии
        -1, // Объект шлагбаума
        false, // Открыт ли шлагбаум
        1718, // Модель шлагбаума
        TEAM_ARMY, // Фракция
        3, // Минимальный ранг
        1910.21, 1725.28, 15.6666, -90.0, 0.0, 0.0, 2.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        1910.21, 1725.28, 15.6666, 0.0, 0.0, 0.0, 2.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        1910.21, 1725.28, 15.6666, 10.0, // Координаты и радиус триггера (X, Y, Z, Radius)
        -1, // Текстовая метка (Label)
        "{ffff00}«\t{ffffff}Шлагбаум Армии\t{ffff00}»\n{ffffff}Используйте {ffff00}гудок{ffffff} для открытия" // Текст метки
    },
    { // Шлагбаум ФСБ
        -1, // Объект шлагбаума
        false, // Открыт ли шлагбаум
        1718, // Модель шлагбаума
        TEAM_FBI, // Фракция
        3, // Минимальный ранг
        -2345.66, -380.88, 29.11, -90.0, 0.0, -90.0, 2.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -2345.66, -380.88, 29.11, 0.0, 0.0, -90.0, 2.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -2345.66, -380.88, 29.11, 10.0, // Координаты и радиус триггера (X, Y, Z, Radius)
        -1, // Текстовая метка (Label)
        "{ffff00}«\t{ffffff}Шлагбаум ФСБ\t{ffff00}»\n{ffffff}Используйте {ffff00}гудок{ffffff} для открытия" // Текст метки
    },
    { // Шлагбаум УМВД
        -1, // Объект шлагбаума
        false, // Открыт ли шлагбаум
        12696, // Модель шлагбаума
        TEAM_PPS, // Фракция
        3, // Минимальный ранг
        2580.09, -2434.11, 21.79, -90.0, 0.0, 0.0, 2.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        2580.09, -2434.11, 21.79, 0.0, 0.0, 0.0, 2.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        2580.09, -2436.33, 21.79, 10.0, // Координаты и радиус триггера (X, Y, Z, Radius)
        -1, // Текстовая метка (Label)
        "{ffff00}«\t{ffffff}Шлагбаум УМВД\t{ffff00}»\n{ffffff}Используйте {ffff00}гудок{ffffff} для открытия" // Текст метки
    },
    // Двойные ворота всин
    { // Дверь ворот 1 ФСИН
        -1, // Объект ворот
        false, // Открыты ли ворота
        11612, // Модель ворот
        TEAM_FSIN, // Фракция
        1, // Минимальный ранг
        -1820.11, -2632.95, 8.58, 0.0, 0.0, 15.0, 3.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1820.11, -2632.95, 8.58, 0.0, 0.0, -80.5, 3.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        0, 0, 0, 1.0, // Координаты и радиус триггера находятся в открытии ворот
        -1, // Текстовая метка (Label)
        "" // Текст метки находится в создании ворот
    },
    { // Дверь ворот 2 ФСИН
        -1, // Объект ворот
        false, // Открыты ли ворота
        11611, // Модель ворот
        TEAM_FSIN, // Фракция
        1, // Минимальный ранг
        -1827.21, -2634.129, 8.58, 0.0, 0.0, 15.0, 3.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1827.21, -2634.129, 8.58, 0.0, 0.0, 99.4, 3.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        0, 0, 0, 1.0, // Координаты и радиус триггера находятся в открытии ворот
        -1, // Текстовая метка (Label)
        "" // Текст метки находится в создании ворот
    },
    { // Ворота доп. защита ФСИН
        -1, // Объект ворот
        false, // Открыты ли ворота
        11615, // Модель ворот
        TEAM_FSIN, // Фракция
        1, // Минимальный ранг
        -1828.0, -2652.7, 10.9, 0.0, 0.0, 99.5, 5.0,// Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1820.49, -2651.36, 10.9, 0.0, 0.0, 99.5, 5.0,// Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1820.49, -2651.36, 10.9, 7.0, // Координаты и радиус триггера (X, Y, Z, Radius)
        -1, // Текстовая метка (Label)
        "{ffff00}«\t{ffffff}Ворота ФСИН\t{ffff00}»\n{ffffff}Используйте {ffff00}гудок{ffffff} для открытия{ffff00}" // Текст метки
    }
};

//--------------------------------------------------------------------------------------------------
// Структуры для дверей
enum DoorInfo
{
    DynamicObject: DoorObject,
    bool:IsOpened,
    DoorModel,
    Team,
    Float:OpenX, Float:OpenY, Float:OpenZ, Float:OpenRX, Float:OpenRY, Float:OpenRZ, Float:OpenSpeed,
    Float:CloseX, Float:CloseY, Float:CloseZ, Float:CloseRX, Float:CloseRY, Float:CloseRZ, Float:CloseSpeed,
    DynamicArea: Area
};

new Float:DoorData[11][DoorInfo] =
{
    { // Военная дверь
        -1, // Объект двери
        false, // Открыта ли дверь
        13460, // Модель двери
        TEAM_ARMY, // Фракция
        1796.04, 1732.31, 1493.24, 0.0, 0.0, 128.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        1796.04, 1732.31, 1493.24, 0.0, 0.0, 0.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    { // Дверь УМВД 1
        -1, // Объект двери
        false, // Открыта ли дверь
        13460, // Модель двери
        TEAM_PPS, // Фракция
        -1101.11, 1518.66, 1500.15, 0.0, 0.0, -38.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1101.11, 1518.66, 1500.15, 0.0, 0.0, 90.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    { // Дверь УМВД 2
        -1, // Объект двери
        false, // Открыта ли дверь
        13460, // Модель двери
        TEAM_PPS, // Фракция
        -1098.70, 1493.35, 1500.14, 0.0, 0.0, 128.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1098.70, 1493.35, 1500.14, 0.0, 0.0, 0.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    { // Дверь УМВД 3
        -1, // Объект двери
        false, // Открыта ли дверь
        13459, // Модель двери
        TEAM_PPS, // Фракция
        -1104.93, 1501.24, 1500.15, 0.0, 0.0, 128.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1104.93, 1501.24, 1500.15, 0.0, 0.0, 1.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    { // Дверь УМВД 4
        -1, // Объект двери
        false, // Открыта ли дверь
        13459, // Модель двери
        TEAM_PPS, // Фракция
        -1110.83, 1503.10, 1500.15, 0.0, 0.0, 128.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1110.83, 1503.10, 1500.15, 0.0, 0.0, 0.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    { // Дверь УМВД 5
        -1, // Объект двери
        false, // Открыта ли дверь
        13460, // Модель двери
        TEAM_PPS, // Фракция
        -1115.47, 1507.76, 1500.15, 0.0, 0.0, 0.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1115.47, 1507.76, 1500.15, 0.0, 0.0, -88.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    { // Дверь УМВД 6
        -1, // Объект двери
        false, // Открыта ли дверь
        13460, // Модель двери
        TEAM_PPS, // Фракция
        -1105.18, 1515.19, 1500.15, 0.0, 0.0, 128.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        -1105.18, 1515.19, 1500.15, 0.0, 0.0, 0.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    // Первые двойные двери
    { // Болларды 1
        -1, // Объект болларда
        false, // Открыт ли боллард
        13320, // Модель болларда
        TEAM_HOSPITAL, // Фракция
        1500.70, 2509.14, 2501.10, 0.0, 0.0, 218.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        1500.70, 2509.14, 2501.10, 0.0, 0.0, 90.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    { // Болларды 2
        -1, // Объект болларда
        false, // Открыт ли боллард
        13321, // Модель болларда
        TEAM_HOSPITAL, // Фракция
        1502.44, 2509.14, 2501.10, 0.0, 0.0, -38.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        1502.44, 2509.14, 2501.10, 0.0, 0.0, 90.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    // Вторые двойные двери
    { // Болларды 3
        -1, // Объект болларда
        false, // Открыт ли боллард
        13320, // Модель болларда
        TEAM_HOSPITAL, // Фракция
        1514.19, 2500.52, 2501.10, 0.0, 0.0, 128.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        1514.19, 2500.52, 2501.10, 0.0, 0.0, 0.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    },
    { // Болларды 4
        -1, // Объект болларда
        false, // Открыт ли боллард
        13321, // Модель болларда
        TEAM_HOSPITAL, // Фракция
        1514.22, 2499.52, 2501.10, 0.0, 0.0, -128.0, 5.0, // Координаты и скорость открытия (X, Y, Z, RX, RY, RZ, Speed)
        1514.22, 2499.52, 2501.10, 0.0, 0.0, 0.0, 5.0, // Координаты и скорость закрытия (X, Y, Z, RX, RY, RZ, Speed)
        -1, // Динамическая зона
    }
};

stock bool:IsPlayerCanOpenDoor(playerid, team, minrank)
{
    new playerTeam = GetPlayerTeamEx(playerid);
    if (playerTeam == team)
    {
        if (GetPlayerJob(playerid) < minrank)
        {
            ShowNewNotification(playerid, 2, 5, 1, 10, "Недостаточный ранг!", "");
            return false;
        }
        return true;
    }
    else if (team == TEAM_PPS && playerTeam == TEAM_DPS)
    {
        if (GetPlayerJob(playerid) < minrank)
        {
            ShowNewNotification(playerid, 2, 5, 1, 10, "Недостаточный ранг!", "");
            return false;
        }
        return true;
    }

    ShowNewNotification(playerid, 2, 5, 1, 10, "Вы не состоите в данной фракции!", "");
    return false;
}

stock ToggleGate(playerid, gateid)
{
    if (gateid < 0 || gateid >= sizeof GateFractionData) return;
    if (!IsPlayerCanOpenDoor(playerid, GateFractionData[gateid][Team], GateFractionData[gateid][MinRank]))
        return;

    if (!GateFractionData[gateid][IsOpened])
    {
        MoveDynamicObject(GateFractionData[gateid][GateObject],
            GateFractionData[gateid][OpenX], GateFractionData[gateid][OpenY], GateFractionData[gateid][OpenZ], GateFractionData[gateid][OpenSpeed],
            GateFractionData[gateid][OpenRX], GateFractionData[gateid][OpenRY], GateFractionData[gateid][OpenRZ]
        );
        GateFractionData[gateid][IsOpened] = true;
    }
    else
    {
        MoveDynamicObject(GateFractionData[gateid][GateObject],
            GateFractionData[gateid][CloseX], GateFractionData[gateid][CloseY], GateFractionData[gateid][CloseZ], GateFractionData[gateid][CloseSpeed],
            GateFractionData[gateid][CloseRX], GateFractionData[gateid][CloseRY], GateFractionData[gateid][CloseRZ]
        );
        GateFractionData[gateid][IsOpened] = false;
    }
}

stock ToggleDoor(playerid, doorid)
{
    if (doorid < 0 || doorid >= sizeof DoorData) return;

    if (!IsPlayerCanOpenDoor(playerid, DoorData[doorid][Team], 1))
        return;

    if (!DoorData[doorid][IsOpened])
    {
        MoveDynamicObject(DoorData[doorid][DoorObject],
            DoorData[doorid][OpenX], DoorData[doorid][OpenY], DoorData[doorid][OpenZ], DoorData[doorid][OpenSpeed],
            DoorData[doorid][OpenRX], DoorData[doorid][OpenRY], DoorData[doorid][OpenRZ]
        );
        DoorData[doorid][IsOpened] = true;
        SetTimerEx("CloseDoorLater", 5000, false, "i", doorid);
    }
    else
    {
        MoveDynamicObject(DoorData[doorid][DoorObject],
            DoorData[doorid][CloseX], DoorData[doorid][CloseY], DoorData[doorid][CloseZ], DoorData[doorid][CloseSpeed],
            DoorData[doorid][CloseRX], DoorData[doorid][CloseRY], DoorData[doorid][CloseRZ]
        );
        DoorData[doorid][IsOpened] = false;
    }
}

forward CloseDoorLater(doorid);
public CloseDoorLater(doorid)
{
    if (doorid < 0 || doorid >= sizeof DoorData) return 1;
    if (DoorData[doorid][IsOpened])
    {
        MoveDynamicObject(DoorData[doorid][DoorObject],
            DoorData[doorid][CloseX], DoorData[doorid][CloseY], DoorData[doorid][CloseZ], DoorData[doorid][CloseSpeed],
            DoorData[doorid][CloseRX], DoorData[doorid][CloseRY], DoorData[doorid][CloseRZ]
        );
        DoorData[doorid][IsOpened] = false;
    }
    return 1;
}

public OnGameModeInit()
{
    CreateDynamic3DTextLabel("{ffff00}«\t{ffffff}Ворота ФСИН\t{ffff00}»\n{ffffff}Используйте {ffff00}гудок{ffffff} для открытия{e81717}", 0xFFFF00FF, -1823.55,-2633.54,6.58 + 1.8, 15.0);
    // Создание объектов и текста для ворот в цикле
    for (new i = 0; i < sizeof GateFractionData; i++)
    {
        GateFractionData[i][GateObject] = CreateDynamicObject(
            GateFractionData[i][GateModel],
            GateFractionData[i][CloseX],
            GateFractionData[i][CloseY],
            GateFractionData[i][CloseZ],
            GateFractionData[i][CloseRX],
            GateFractionData[i][CloseRY],
            GateFractionData[i][CloseRZ]
        );
        GateFractionData[i][Label] = CreateDynamic3DTextLabel(
            GateFractionData[i][LabelText],
            0xFFFF00FF,
            GateFractionData[i][TriggerX],
            GateFractionData[i][TriggerY],
            GateFractionData[i][TriggerZ] + 1.8,
            10.0
        );
    }
    for (new i = 0; i < sizeof DoorData; i++)
    {
        DoorData[i][DoorObject] = CreateDynamicObject(
            DoorData[i][DoorModel],
            DoorData[i][CloseX],
            DoorData[i][CloseY],
            DoorData[i][CloseZ],
            DoorData[i][CloseRX],
            DoorData[i][CloseRY],
            DoorData[i][CloseRZ]
        );
        DoorData[i][Area] = CreateDynamicSphere(
            DoorData[i][CloseX],
            DoorData[i][CloseY],
            DoorData[i][CloseZ],
            3.0
        );
    }
    #if defined gatess_OnGameModeInit
        return gatess_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit gatess_OnGameModeInit
#if defined gatess_OnGameModeInit
    forward gatess_OnGameModeInit();
#endif

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if (newkeys & KEY_CROUCH)
    {
        for (new i = 0; i < sizeof GateFractionData; i++)
        {
            if (IsPlayerInRangeOfPoint(playerid, GateFractionData[i][TriggerRadius], GateFractionData[i][TriggerX], GateFractionData[i][TriggerY], GateFractionData[i][TriggerZ]))
            {
                ToggleGate(playerid, i);
                return 1;
            }
        }
        if(IsPlayerInRangeOfPoint(playerid, 7.0, -1823.496093,-2633.551513,7.584485)) 
        {
            ToggleGate(playerid, 4); 
            ToggleGate(playerid, 5);
            return 1;
        }
    }
    #if defined gatess_OnPlayerKeyStateChange
        return gatess_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 1;
    #endif
}
#if defined gatess_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange gatess_OnPlayerKeyStateChange
#if defined gatess_OnPlayerKeyStateChange
    forward gatess_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if (areaid == DoorData[7][Area] || areaid == DoorData[9][Area])
    {
        ShowNewNotification(playerid, 5, 5, FRACTION_DOOR, 1, "Открыть двери", ">>");
        return 1;
    }
    if (areaid == DoorData[8][Area] || areaid == DoorData[10][Area]) return 1;
    for (new i = 0; i < sizeof DoorData; i++)
    {
        if (areaid == DoorData[i][Area])
        {
            ShowNewNotification(playerid, 5, 5, FRACTION_DOOR, 1, "Открыть дверь,", ">>");
            return 1;
        }
    }
    #if defined gatess_OnPlayerEnterDynamicArea
        return gatess_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 1;
    #endif
}
#if defined gatess_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea gatess_OnPlayerEnterDynamicArea
#if defined gatess_OnPlayerEnterDynamicArea
    forward gatess_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

CMD:door(playerid)
{
    if (IsPlayerInDynamicArea(playerid, DoorData[7][Area]) || IsPlayerInDynamicArea(playerid, DoorData[8][Area]))
    {
        ToggleDoor(playerid, 7);
        ToggleDoor(playerid, 8);
        return 1;
    }
    for (new i = 0; i < sizeof DoorData; i++)
    {
        if (IsPlayerInDynamicArea(playerid, DoorData[i][Area]))
        {
            ToggleDoor(playerid, i);
            return 1;
        }
    }
    SendClientMessage(playerid, 0xFF0000FF, "Вы не находитесь рядом с дверью.");
    return 1;
}