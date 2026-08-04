new VehicleModels[212][64]; // Массив для хранения имен моделей (максимум 212 моделей)

public LoadVehicleModels()
{
    new query[128];
    format(query, sizeof(query), "SELECT * FROM `vehicle_models`");
    mysql_tquery(dbHandle, query, "OnVehicleModelsLoaded");
}

stock GetVehicleNameByModel(modelid)
{
    // Проверяем допустимость ID модели
    if (modelid < 400 || modelid > 611) return "Unknown";

    // Проверяем, есть ли имя в массиве
    if (VehicleModels[modelid - 400][0] == '\0') return "Unknown";

    // Возвращаем имя модели
    return VehicleModels[modelid - 400];
}

forward OnVehicleModelsLoaded();
public OnVehicleModelsLoaded()
{
    new rows = cache_get_row_count(); // Получаем количество строк
    if (rows > 0)
    {
        for (new i = 0; i < rows; i++)
        {
            new modelID, modelName[64];

            // Получаем model_id (целое число)
            cache_get_field_content_int(i, "model_id", modelID);

            // Получаем model_name (строка)
            cache_get_field_content(i, "model_name", modelName, sizeof(modelName));

            // Сохраняем имя модели в массиве
            if (400 <= modelID <= 611) // Проверяем допустимость ID модели
            {
                format(VehicleModels[modelID - 400], 64, "%s", modelName);
                printf("Модель ID %d: %s", modelID, modelName); // Отладочное сообщение
            }
        }
        printf("[Vehicle Models] Загружено %d моделей транспорта.", rows);
    }
    else
    {
        print("[Vehicle Models] В базе данных нет моделей транспорта.");
    }
    return 1;
}