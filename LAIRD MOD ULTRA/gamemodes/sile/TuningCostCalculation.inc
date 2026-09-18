// ============================================================================
//  TuningCostCalculation.inc
//  Расчет цен для тюнинг-модуля (адаптировано из Java-версии)
// ============================================================================

#if defined _tuning_cost_calc_included
    #endinput
#endif
#define _tuning_cost_calc_included

// ----------------------------------------------------------------------------
//  Статусы деталей
// ----------------------------------------------------------------------------
#define DETAIL_STATUS_CAN_BUY       (0)   // Можно купить
#define DETAIL_STATUS_BOUGHT        (1)   // Куплено
#define DETAIL_STATUS_ESTABLISHED   (2)   // Установлено

// ----------------------------------------------------------------------------
//  Базовые стоимости деталей (tuningCostTypes)
// ----------------------------------------------------------------------------
static const g_TuningCostTypes[29] = {
    1000,   // 0
    1000,   // 1
    500,    // 2
    600,    // 3
    1000,   // 4
    5000,   // 5
    400,    // 6
    1000,   // 7
    1000,   // 8
    10000,  // 9
    450,    // 10
    450,    // 11
    1000,   // 12
    1000,   // 13
    700,    // 14
    15000,  // 15
    15000,  // 16
    15000,  // 17
    15000,  // 18
    15000,  // 19
    50000,  // 20
    150000, // 21
    300,    // 22
    150000, // 23
    10000,  // 24
    15000,  // 25
    10000,  // 26
    0,      // 27
    50000   // 28
};

// ----------------------------------------------------------------------------
//  getFinalCost - расчет финальной стоимости
// ----------------------------------------------------------------------------
stock Float:getFinalCost(gosCost, Float:percent, addedValue)
{
    return floatround(((gosCost * percent) / 100.0) + addedValue, floatround_floor);
}

// ----------------------------------------------------------------------------
//  getDetailPrice - расчет цены детали
// ----------------------------------------------------------------------------
stock getDetailPrice(typeId, gosCost, tuneId)
{
    // Если тип -1 (коробка/рандом)
    if(typeId == -1)
        return floatround(getFinalCost(gosCost, 8.0, 15000), floatround_floor);
    
    // Базовая защита от выхода за массив
    if(typeId < 0 || typeId >= sizeof(g_TuningCostTypes))
        return 0;
    
    new baseCost = g_TuningCostTypes[typeId];
    
    switch(typeId)
    {
        // Детали двигателя (15-19)
        case 15, 16, 17, 18, 19:
        {
            switch(tuneId)
            {
                case 0: return floatround(getFinalCost(gosCost, 4.0, baseCost), floatround_floor);
                case 1: return floatround(getFinalCost(gosCost, 7.0, baseCost), floatround_floor);
                case 2: return floatround(getFinalCost(gosCost, 5.0, baseCost), floatround_floor);
                case 3: return floatround(getFinalCost(gosCost, 0.005, 20), floatround_floor);
                default: return 0;
            }
        }
        
        // Тип 20 (выхлопы)
        case 20:
        {
            switch(tuneId)
            {
                case 0, 1, 2, 3:
                    return floatround(getFinalCost(gosCost, 1.0, baseCost), floatround_floor);
                case 4:
                    return floatround(getFinalCost(gosCost, 0.003, 150), floatround_floor);
                default:
                    return 0;
            }
        }
        
        // Тип 21 (дальний свет)
        case 21:
        {
            return floatround(getFinalCost(gosCost, 40.0, baseCost), floatround_floor);
        }
        
        // Клиренс (тип 22)
        case 22:
        {
            new cost = floatround(getFinalCost(gosCost, 0.05, baseCost), floatround_floor);
            if(cost >= 10000)
                return 10000;
            return cost;
        }
        
        // Тип 23
        case 23:
        {
            return floatround(getFinalCost(gosCost, 30.0, baseCost), floatround_floor);
        }
        
        // Тип 24
        case 24:
        {
            return floatround(getFinalCost(gosCost, 1.0, baseCost), floatround_floor);
        }
        
        // Тип 25
        case 25:
        {
            switch(tuneId)
            {
                case 1008: return floatround(getFinalCost(gosCost, 5.0, baseCost), floatround_floor);
                case 1009: return floatround(getFinalCost(gosCost, 2.0, baseCost), floatround_floor);
                case 1010: return floatround(getFinalCost(gosCost, 7.0, baseCost), floatround_floor);
                default: return 0;
            }
        }
        
        // Тип 26
        case 26:
        {
            return floatround(getFinalCost(gosCost, 0.1, baseCost), floatround_floor);
        }
        
        // Тип 27 (спойлеры, обвесы, стробоскопы и т.д.)
        case 27:
        {
            switch(tuneId)
            {
                // Стробоскопы (28-31)
                case 28, 29, 30, 31:
                    return floatround(getFinalCost(gosCost, 1.7, 0), floatround_floor);
                // Стробоскоп 32 (за донат)
                case 32:
                    return floatround(getFinalCost(gosCost, 0.005, 0), floatround_floor);
                // Гидравлика (33)
                case 33:
                    return floatround(getFinalCost(gosCost, 42.1, 0), floatround_floor);
                // Пневматика (34)
                case 34:
                    return floatround(getFinalCost(gosCost, 32.1, 0), floatround_floor);
                // Обвесы (14-29)
                case 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 26, 27:
                    return floatround(getFinalCost(gosCost, 7.0, 100000), floatround_floor);
                // Спойлеры и т.д.
                case 24, 25, 35, 38, 39:
                    return floatround(getFinalCost(gosCost, 0.003, 350), floatround_floor);
                // Диски (36-92)
                case 36, 37, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50,
                     51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 65,
                     66, 67, 68, 69, 70, 71, 72, 73, 74, 75, 76, 77, 78, 79, 80,
                     81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91, 92:
                    return floatround(getFinalCost(gosCost, 1.14, 0), floatround_floor);
                // Дальний свет (130)
                case 130:
                    return floatround(getFinalCost(gosCost, 0.24, 0), floatround_floor);
                // Гудки (99-129)
                case 99, 100, 101, 102, 103, 104, 105, 106, 113, 118, 119, 120, 121, 122, 123, 125, 126:
                    return floatround(getFinalCost(gosCost, 8.4, 0), floatround_floor);
                case 107, 108, 109, 110, 111, 112, 114, 115, 116, 117, 124, 127, 128, 129:
                    return floatround(getFinalCost(gosCost, 0.008, 0), floatround_floor); // Донат
                default:
                    return 0;
            }
        }
        
        // Тип 28
        case 28:
        {
            return floatround(getFinalCost(gosCost, 3.0, baseCost), floatround_floor);
        }
    }
    
    // Для всех остальных типов - стандартная формула: 1% + базовая стоимость
    return floatround(getFinalCost(gosCost, 1.0, baseCost), floatround_floor);
}

// ----------------------------------------------------------------------------
//  setCost - расчет цены для цветов и простых опций
// ----------------------------------------------------------------------------
stock setCost(selectorId, gosCost)
{
    switch(selectorId)
    {
        // Цвет кузова и диски
        case 0, 1, 31:
        {
            return floatround(getFinalCost(gosCost, 1.0, 10000), floatround_floor);
        }
        
        // Винилы
        case 2:
        {
            return floatround(getFinalCost(gosCost, 1.0, 50000), floatround_floor);
        }
        
        // Тонировка
        case 3, 4:
        {
            return floatround(getFinalCost(gosCost, 1.0, 20000), floatround_floor);
        }
        
        // Гудок
        case 7:
        {
            return floatround(getFinalCost(gosCost, 1.0, 20000), floatround_floor);
        }
        
        // Звук выхлопа
        case 9:
        {
            return floatround(getFinalCost(gosCost, 1.0, 30000), floatround_floor);
        }
        
        // Цвет фар
        case 10:
        {
            return floatround(getFinalCost(gosCost, 2.0, 20000), floatround_floor);
        }
        
        // Неон
        case 11, 12, 13:
        {
            return floatround(getFinalCost(gosCost, 1.0, 20000), floatround_floor);
        }
        
        // Обвесы
        case 16, 17, 18, 19, 20, 21:
        {
            return floatround(getFinalCost(gosCost, 1.0, 30000), floatround_floor);
        }
        
        // Клиренс
        case 22:
        {
            return floatround(getFinalCost(gosCost, 10.0, 40000), floatround_floor);
        }
        case 23:
        {
            return floatround(getFinalCost(gosCost, 7.0, 30000), floatround_floor);
        }
        
        // Колесные арки
        case 24, 25:
        {
            return floatround(getFinalCost(gosCost, 3.0, 40000), floatround_floor);
        }
        
        // Коллапс
        case 26, 27:
        {
            return floatround(getFinalCost(gosCost, 5.0, 40000), floatround_floor);
        }
        
        // Ширина колес
        case 28, 29:
        {
            return floatround(getFinalCost(gosCost, 5.0, 50000), floatround_floor);
        }
        
        // Радиус колес
        case 30:
        {
            return floatround(getFinalCost(gosCost, 7.0, 100000), floatround_floor);
        }
        
        // Диски
        case 32, 33:
        {
            return floatround(getFinalCost(gosCost, 1.0, 50000), floatround_floor);
        }
        
        // Детали ходовой
        case 36, 37, 38, 39, 40:
        {
            return floatround(getFinalCost(gosCost, 1.0, 50000), floatround_floor);
        }
        
        // Кузовные детали
        case 43, 44, 45, 46, 47:
        {
            return floatround(getFinalCost(gosCost, 1.0, 30000), floatround_floor);
        }
        
        default:
        {
            return 0;
        }
    }
}

// ----------------------------------------------------------------------------
//  GetTuningPrice - универсальная функция расчета цены
// ----------------------------------------------------------------------------
stock GetTuningPrice(selectorId, gosCost, tuneId = 0)
{
    // Для деталей (двигатель, трансмиссия и т.д.)
    if(selectorId >= 15 && selectorId <= 28)
    {
        return getDetailPrice(selectorId, gosCost, tuneId);
    }
    // Для цветов и простых опций
    else
    {
        return setCost(selectorId, gosCost);
    }
}