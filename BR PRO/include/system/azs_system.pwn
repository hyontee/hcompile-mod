#if defined _AZS_GUI_SYSTEM_
    #endinput
#endif
#define _AZS_GUI_SYSTEM_

// -----------------------------------------------------
// Макросы / константы
// -----------------------------------------------------

#if !defined SCM
    #define SCM SendClientMessage
#endif

// Диалоги (берём заведомо свободные ID выше 15000)
#define DIALOG_AZS_FUELTYPE   (15000)
#define DIALOG_AZS_LITERS     (15001)

// Радиус, в котором гудок ловит АЗС
#if !defined AZS_HORN_RADIUS
    #define AZS_HORN_RADIUS       (15.0)
#endif

// Максимальный объём бака (в FuelStationFillCar используется 150.0)
#if !defined AZS_MAX_TANK_FUEL
    #define AZS_MAX_TANK_FUEL     (150.0)
#endif

// Шаг заправки (FuelStationFillCar льёт по 10л)
#if !defined AZS_FUEL_STEP
    #define AZS_FUEL_STEP         (10)
#endif

// Стартовое значение при вводе литров
#if !defined AZS_DEFAULT_LITERS
    #define AZS_DEFAULT_LITERS    (120)
#endif

// Цвет успешного сообщения
#if !defined AZS_MSG_COLOR
    #define AZS_MSG_COLOR         0x00FF00FF
#endif

// Интервал таймера "анимации" заправки (мс)
#if !defined AZS_REFUEL_TICK
    #define AZS_REFUEL_TICK       (700)
#endif

// -----------------------------------------------------
// Типы топлива — визуально (для текста)
// -----------------------------------------------------

enum E_AZS_FUEL_TYPE
{
    AZS_FUEL_AI92,
    AZS_FUEL_AI95,
    AZS_FUEL_AI98,
    AZS_FUEL_AI100,
    AZS_FUEL_DIESEL,
    AZS_FUEL_TYPE_MAX
};

static const g_AzsFuelTypeName[AZS_FUEL_TYPE_MAX][] =
{
    "АИ-92",
    "АИ-95",
    "АИ-98",
    "АИ-100",
    "ДТ"
};

// -----------------------------------------------------
// Данные игрока (меню АЗС)
// -----------------------------------------------------

enum E_AZS_PLAYER_DATA
{
    azs_active,         // 1 – меню АЗС открыто
    azs_station_id,     // id заправки
    azs_vehicleid,      // id машины
    azs_fuel_type,      // выбранный тип топлива (0..4)
    azs_max_liters      // максимум литров, которые влезут
};

static g_AzsPlayer[MAX_PLAYERS][E_AZS_PLAYER_DATA];

// -----------------------------------------------------
// Данные игрока (процесс заправки)
// -----------------------------------------------------

enum E_AZS_REFUEL_INT
{
    azsr_active,        // 1 – сейчас идёт заправка
    azsr_timer,         // id таймера
    azsr_station,       // id заправки
    azsr_vehicle,       // id автомобиля
    azsr_type,          // тип топлива (0..4)
    azsr_total,         // сколько литров игрок заказал (кратно 10)
    azsr_visual,        // сколько литров показываем в GameText
    azsr_start_count,   // buy_fuel_count на старте
    azsr_last_count     // buy_fuel_count на последнем тике
};

static g_AzsRefuel[MAX_PLAYERS][E_AZS_REFUEL_INT];

// -----------------------------------------------------
// Сброс данных
// -----------------------------------------------------

stock Azs_ResetPlayer(playerid)
{
    // меню
    g_AzsPlayer[playerid][azs_active]      = 0;
    g_AzsPlayer[playerid][azs_station_id]  = -1;
    g_AzsPlayer[playerid][azs_vehicleid]   = INVALID_VEHICLE_ID;
    g_AzsPlayer[playerid][azs_fuel_type]   = AZS_FUEL_AI95;
    g_AzsPlayer[playerid][azs_max_liters]  = 0;

    // заправка
    g_AzsRefuel[playerid][azsr_active]       = 0;
    g_AzsRefuel[playerid][azsr_station]      = -1;
    g_AzsRefuel[playerid][azsr_vehicle]      = INVALID_VEHICLE_ID;
    g_AzsRefuel[playerid][azsr_type]         = AZS_FUEL_AI95;
    g_AzsRefuel[playerid][azsr_total]        = 0;
    g_AzsRefuel[playerid][azsr_visual]       = 0;
    g_AzsRefuel[playerid][azsr_start_count]  = 0;
    g_AzsRefuel[playerid][azsr_last_count]   = 0;

    if(g_AzsRefuel[playerid][azsr_timer] != 0)
    {
        KillTimer(g_AzsRefuel[playerid][azsr_timer]);
        g_AzsRefuel[playerid][azsr_timer] = 0;
    }

    return 1;
}

// -----------------------------------------------------
// Вспомогательные функции
// -----------------------------------------------------

// В моде уже есть stock GetNearestFuelStation(playerid, Float:dist);
// здесь просто обёртка.
stock Azs_GetNearestStation(playerid, Float:radius = AZS_HORN_RADIUS)
{
    return GetNearestFuelStation(playerid, radius);
}

// Посчитать максимум литров, которые ещё влезут в бак
stock Azs_CalcMaxLitersForVehicle(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return 0;

    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsABike(vehicleid))
        return 0;

    new Float:curFuel = GetVehicleData(vehicleid, V_FUEL);
    new Float:space   = AZS_MAX_TANK_FUEL - curFuel;

    if(space <= 0.1)
        return 0;

    new max_liters = floatround(space, floatround_floor);

    // до кратности шага
    max_liters -= (max_liters % AZS_FUEL_STEP);
    if(max_liters < AZS_FUEL_STEP)
        return 0;

    return max_liters;
}

// Показать прогресс заправки (GameText)
stock Azs_ShowProgressText(playerid, litresNow)
{
    new msg[32];
    format(msg, sizeof msg, "~r~Заправка: %dл", litresNow);
    GameTextForPlayer(playerid, msg, AZS_REFUEL_TICK + 500, 4);
    return 1;
}

// -----------------------------------------------------
// Старт / остановка заправки
// -----------------------------------------------------

forward Azs_RefuelTimer(playerid);

stock Azs_StopRefuel(playerid, bool:showResult)
{
    if(g_AzsRefuel[playerid][azsr_timer] != 0)
    {
        KillTimer(g_AzsRefuel[playerid][azsr_timer]);
        g_AzsRefuel[playerid][azsr_timer] = 0;
    }

    if(!g_AzsRefuel[playerid][azsr_active])
        return 1;

    new startCount = g_AzsRefuel[playerid][azsr_start_count];
    new lastCount  = GetPVarInt(playerid, "buy_fuel_count");
    new bought     = lastCount - startCount;
    if(bought < 0) bought = 0;

    new fuel_type  = g_AzsRefuel[playerid][azsr_type];

    g_AzsRefuel[playerid][azsr_active] = 0;

    if(!showResult)
        return 1;

    if(bought <= 0)
    {
        SCM(playerid, 0xFF6600FF, "Заправка была прервана.");
        GameTextForPlayer(playerid, "~r~Заправка остановлена", 2000, 4);
        return 1;
    }

    // финальный GameText — ровно купленные литры
    Azs_ShowProgressText(playerid, bought);

    // сообщение и GUI 13
    new msg[144];
    format(msg, sizeof msg,
        "Вы успешно заправили автомобиль. Тип топлива: %s, количество: %d л.",
        (fuel_type >= 0 && fuel_type < AZS_FUEL_TYPE_MAX) ? g_AzsFuelTypeName[fuel_type] : "Неизвестно",
        bought);

    SCM(playerid, AZS_MSG_COLOR, msg);
    ShowClientNotification(playerid, 3, 5, 1, 1, msg, "");

    return 1;
}

stock Azs_StartRefuel(playerid, litres, fuel_type)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SCM(playerid, 0xCECECEFF, "Вы должны находиться в транспортном средстве.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsABike(vehicleid))
        return SCM(playerid, 0xCECECEFF, "Этот транспорт нельзя заправить.");

    if(!IsPlayerDriver(playerid))
        return SCM(playerid, 0xCECECEFF, "Вы не за рулём.");

    new stationid = g_AzsPlayer[playerid][azs_station_id];
    if(stationid < 0)
        stationid = Azs_GetNearestStation(playerid);

    if(stationid < 0)
        return SCM(playerid, 0xCECECEFF, "Поблизости нет заправочной станции.");

    // ограничиваем литры по баку
    new max_liters = Azs_CalcMaxLitersForVehicle(playerid);
    if(max_liters <= 0)
        return SCM(playerid, 0xCECECEFF, "Бак уже заполнен.");

    if(litres > max_liters)
        litres = max_liters;

    if(litres < AZS_FUEL_STEP)
        litres = AZS_FUEL_STEP;

    // кратность шагу
    if(litres % AZS_FUEL_STEP != 0)
        litres -= (litres % AZS_FUEL_STEP);

    if(litres < AZS_FUEL_STEP)
        litres = AZS_FUEL_STEP;

    // если уже заправляем — останавливаем старую заправку без вывода результата
    if(g_AzsRefuel[playerid][azsr_active])
    {
        Azs_StopRefuel(playerid, false);
    }

    g_AzsRefuel[playerid][azsr_active]      = 1;
    g_AzsRefuel[playerid][azsr_station]     = stationid;
    g_AzsRefuel[playerid][azsr_vehicle]     = vehicleid;
    g_AzsRefuel[playerid][azsr_type]        = fuel_type;
    g_AzsRefuel[playerid][azsr_total]       = litres;
    g_AzsRefuel[playerid][azsr_visual]      = 0;

    new startCount = GetPVarInt(playerid, "buy_fuel_count");
    g_AzsRefuel[playerid][azsr_start_count] = startCount;
    g_AzsRefuel[playerid][azsr_last_count]  = startCount;

    g_AzsRefuel[playerid][azsr_timer] = SetTimerEx("Azs_RefuelTimer", AZS_REFUEL_TICK, true, "i", playerid);

    SCM(playerid, 0xFF9900FF, "Заправка начата. Не покидайте транспортное средство.");
    Azs_ShowProgressText(playerid, 0);

    return 1;
}

// -----------------------------------------------------
// Таймер заправки
// -----------------------------------------------------

public Azs_RefuelTimer(playerid)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS)
        return 0;

    if(!g_AzsRefuel[playerid][azsr_active])
        return 0;

    new vehicleid = g_AzsRefuel[playerid][azsr_vehicle];
    new stationid = g_AzsRefuel[playerid][azsr_station];

    if(!IsPlayerInAnyVehicle(playerid) || GetPlayerVehicleID(playerid) != vehicleid || !IsPlayerDriver(playerid))
    {
        Azs_StopRefuel(playerid, true);
        return 1;
    }

    new startCount = g_AzsRefuel[playerid][azsr_start_count];
    new requested  = g_AzsRefuel[playerid][azsr_total];
    new visual     = g_AzsRefuel[playerid][azsr_visual];

    new curCount   = GetPVarInt(playerid, "buy_fuel_count");
    new actual     = curCount - startCount;
    if(actual < 0) actual = 0;

    // если уже достигли или превысили нужное количество — догоняем визуал и завершаем
    if(actual >= requested)
    {
        if(visual < actual)
        {
            new remaining = actual - visual;
            new add = (remaining > 15) ? (random(11) + 5) : remaining; // 5-15 или остаток
            if(add > remaining) add = remaining;
            visual += add;
            g_AzsRefuel[playerid][azsr_visual] = visual;
            Azs_ShowProgressText(playerid, visual);
            return 1;
        }

        Azs_StopRefuel(playerid, true);
        return 1;
    }

    // Пытаемся залить ещё 10л, если ещё не набрали нужное количество
    new beforeCount = curCount;
    FuelStationFillCar(playerid, vehicleid, stationid);
    new afterCount  = GetPVarInt(playerid, "buy_fuel_count");

    if(afterCount <= beforeCount)
    {
        // топлива больше не льётся (нет денег / лимиты) — завершаем по фактическому количеству
        curCount = afterCount;
        actual   = curCount - startCount;
        if(actual < 0) actual = 0;

        if(visual < actual)
        {
            new remaining = actual - visual;
            new add = (remaining > 15) ? (random(11) + 5) : remaining;
            if(add > remaining) add = remaining;
            visual += add;
            g_AzsRefuel[playerid][azsr_visual] = visual;
            Azs_ShowProgressText(playerid, visual);
            return 1;
        }

        Azs_StopRefuel(playerid, true);
        return 1;
    }

    // есть новые литры
    g_AzsRefuel[playerid][azsr_last_count] = afterCount;
    curCount = afterCount;
    actual   = curCount - startCount;
    if(actual < 0) actual = 0;
    if(actual > requested) actual = requested;

    // Обновляем визуальный прогресс (рандомными шагами, но не превышая actual)
    if(visual < actual)
    {
        new remaining = actual - visual;
        new add = (remaining > 15) ? (random(11) + 5) : remaining;
        if(add > remaining) add = remaining;
        visual += add;
        g_AzsRefuel[playerid][azsr_visual] = visual;
        Azs_ShowProgressText(playerid, visual);
    }

    return 1;
}

// -----------------------------------------------------
// Диалоги
// -----------------------------------------------------

stock Azs_ShowFuelTypeDialog(playerid)
{
    new list[64];
    format(list, sizeof list, "АИ-92\nАИ-95\nАИ-98\nАИ-100\nДТ");
    ShowPlayerDialog(playerid, DIALOG_AZS_FUELTYPE, DIALOG_STYLE_LIST,
        "АЗС — выбор топлива",
        list,
        "Далее", "Отмена");
    return 1;
}

stock Azs_ShowLitersDialog(playerid)
{
    new max_liters = g_AzsPlayer[playerid][azs_max_liters];

    if(max_liters <= 0)
    {
        SCM(playerid, 0xCECECEFF, "Бак уже заполнен.");
        g_AzsPlayer[playerid][azs_active] = 0;
        return 1;
    }

    new msg[144];
    format(msg, sizeof msg,
        "Доступно к заправке: %d л.\nВведите количество литров (от %d до %d, кратно %d):",
        max_liters,
        AZS_FUEL_STEP,
        max_liters,
        AZS_FUEL_STEP);

    ShowPlayerDialog(playerid, DIALOG_AZS_LITERS, DIALOG_STYLE_INPUT,
        "АЗС — количество топлива",
        msg,
        "Заправить", "Назад");

    return 1;
}

// Обработчик наших диалогов. Возвращает 1, если диалог обработан.
stock Azs_HandleDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case DIALOG_AZS_FUELTYPE:
        {
            if(!g_AzsPlayer[playerid][azs_active])
                return 0;

            if(!response)
            {
                g_AzsPlayer[playerid][azs_active] = 0;
                return 1;
            }

            if(listitem < 0 || listitem >= AZS_FUEL_TYPE_MAX)
                listitem = AZS_FUEL_AI95;

            g_AzsPlayer[playerid][azs_fuel_type] = listitem;

            Azs_ShowLitersDialog(playerid);
            return 1;
        }

        case DIALOG_AZS_LITERS:
        {
            if(!g_AzsPlayer[playerid][azs_active])
                return 0;

            if(!response)
            {
                // "Назад" — возвращаемся к выбору топлива
                Azs_ShowFuelTypeDialog(playerid);
                return 1;
            }

            if(!strlen(inputtext) || !IsNumeric(inputtext))
            {
                SCM(playerid, 0xCECECEFF, "Введите корректное количество литров цифрами.");
                Azs_ShowLitersDialog(playerid);
                return 1;
            }

            new litres = strval(inputtext);

           /* if (litres < AZS_FUEL_STEP)
{
    // Создаём буфер для сообщения
    new warn[96];

    // Форматируем сообщение
    format(warn, sizeof(warn), "Минимальное количество литров: %d.", RoundFloat(AZS_FUEL_STEP));

    // Отправляем сообщение игроку
    SCM(playerid, 0xCECECEFF, warn);

    // Показываем диалог ввода литров
    Azs_ShowLitersDialog(playerid);

    return 1;
}*/

            new max_liters = g_AzsPlayer[playerid][azs_max_liters];
            if(max_liters <= 0)
            {
                SCM(playerid, 0xCECECEFF, "Бак уже заполнен.");
                g_AzsPlayer[playerid][azs_active] = 0;
                return 1;
            }

            if(litres > max_liters)
                litres = max_liters;

            // кратность шагу
            if(litres % AZS_FUEL_STEP != 0)
                litres -= (litres % AZS_FUEL_STEP);

            if(litres < AZS_FUEL_STEP)
                litres = AZS_FUEL_STEP;

            new fuel_type = g_AzsPlayer[playerid][azs_fuel_type];
            if(fuel_type < 0 || fuel_type >= AZS_FUEL_TYPE_MAX)
                fuel_type = AZS_FUEL_AI95;

            Azs_StartRefuel(playerid, litres, fuel_type);
            g_AzsPlayer[playerid][azs_active] = 0;
            return 1;
        }
    }
    return 0;
}

// -----------------------------------------------------
// Меню АЗС (запуск с гудка или из /azs)
// -----------------------------------------------------

stock Azs_OpenMenu(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SCM(playerid, 0xCECECEFF, "Вы должны находиться в транспортном средстве.");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(IsABike(vehicleid))
        return SCM(playerid, 0xCECECEFF, "Этот транспорт нельзя заправить.");

    if(!IsPlayerDriver(playerid))
        return SCM(playerid, 0xCECECEFF, "Вы не за рулём.");

    new stationid = Azs_GetNearestStation(playerid);
    if(stationid == -1)
        return SCM(playerid, 0xCECECEFF, "Поблизости нет заправочной станции.");

    new max_liters = Azs_CalcMaxLitersForVehicle(playerid);
    if(max_liters <= 0)
        return SCM(playerid, 0xCECECEFF, "Бак уже заполнен.");

    g_AzsPlayer[playerid][azs_active]      = 1;
    g_AzsPlayer[playerid][azs_station_id]  = stationid;
    g_AzsPlayer[playerid][azs_vehicleid]   = vehicleid;
    g_AzsPlayer[playerid][azs_max_liters]  = max_liters;

    Azs_ShowFuelTypeDialog(playerid);
    return 1;
}

// -----------------------------------------------------
// Обработчик клавиш (гудок)
// -----------------------------------------------------

stock Azs_InternalKeyHandler(playerid, newkeys, oldkeys)
{
    if(newkeys & KEY_CROUCH) // гудок
    {
        if(IsPlayerInAnyVehicle(playerid) && IsPlayerDriver(playerid))
        {
            new stationid = Azs_GetNearestStation(playerid);
            if(stationid != -1)
            {
                Azs_OpenMenu(playerid);
                return 1;
            }
        }
    }
    return 1;
}

// -----------------------------------------------------
// Команда /azs — для теста
// -----------------------------------------------------

CMD:azs(playerid, params[])
{
    Azs_OpenMenu(playerid);
    return 1;
}

// -----------------------------------------------------
// Хуки колбэков (ALS, как в dispatcher.pwn)
// -----------------------------------------------------

// ---------- OnPlayerConnect ----------

public OnPlayerConnect(playerid)
{
    Azs_ResetPlayer(playerid);

    #if defined azs_OnPlayerConnect
        return azs_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect azs_OnPlayerConnect
#if defined azs_OnPlayerConnect
    forward azs_OnPlayerConnect(playerid);
#endif

// ---------- OnPlayerDisconnect ----------

public OnPlayerDisconnect(playerid, reason)
{
    Azs_StopRefuel(playerid, false);
    Azs_ResetPlayer(playerid);

    #if defined azs_OnPlayerDisconnect
        return azs_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect azs_OnPlayerDisconnect
#if defined azs_OnPlayerDisconnect
    forward azs_OnPlayerDisconnect(playerid, reason);
#endif

// ---------- OnPlayerKeyStateChange ----------

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    Azs_InternalKeyHandler(playerid, newkeys, oldkeys);

    #if defined azs_OnPlayerKeyStateChange
        return azs_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange azs_OnPlayerKeyStateChange
#if defined azs_OnPlayerKeyStateChange
    forward azs_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

// ---------- OnDialogResponse ----------

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(Azs_HandleDialogResponse(playerid, dialogid, response, listitem, inputtext))
        return 1;

    #if defined azs_OnDialogResponse
        return azs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse azs_OnDialogResponse
#if defined azs_OnDialogResponse
    forward azs_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// ========================= EOF azs_gui.pwn =========================