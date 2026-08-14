// Подключаем необходимые библиотеки
#include <vehfuncs>
#include <blackrussia>

// Объявление переменных
new g_VehicleCount = 0;

// Функция инициализации
public OnGameModeInit()
{
    // Инициализация транспортных средств
    g_VehicleCount = 0;
    return 1;
}

// Пример функции для создания автомобиля
stock CreateVehicleExample(Float:x, Float:y, Float:z, Float:rotation, vehicleid, playerid)
{
    new vehicle = CreateVehicle(vehicleid, x, y, z, rotation, playerid, -1);
    if (vehicle != 0)
    {
        // Увеличиваем счетчик автомобилей
        g_VehicleCount++;
        // Используем функции из vehfuncs
        SetVehicleHealth(vehicle, 1000.0);
        return vehicle;
    }
    return 0;
}

// Пример использования функции
public OnPlayerCommand(playerid, cmdtext[])
{
    if (strcmp(cmdtext, "/createvehicle", true) == 0)
    {
        // Создаем автомобиль для игрока
        CreateVehicleExample(0.0, 0.0, 3.0, 90.0, 411, playerid); // Пример с ID автомобиля 411 (Infernus)
        return 1;
    }
    return 0;
}

// Основная функция для управления событиями
public OnGameModeExit()
{
    // Очистка ресурсов перед выходом
    return 1;
}