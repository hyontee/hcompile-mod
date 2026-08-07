//===================[Логирование подключения и отключения от сервера]===================
stock LogsPlayerConnect(playerid) {
    new query[128];
    format(query, sizeof(query), "INSERT INTO player_logs (player_name, action) VALUES ('%s', 'connect')", pInfo[playerid][pName]);
    mysql_tquery(dbHandle, query);
    return true;
}

stock LogsPlayerDisconnect(playerid, reason) {
    new reasonText[32];
    switch (reason)
    {
        case 0: reasonText = "Timeout";
        case 1: reasonText = "Quit";
        case 2: reasonText = "Kicked/Banned";
    }

    new query[256];
    format(query, sizeof(query), "INSERT INTO player_logs (player_name, action, reason) VALUES ('%s', 'disconnect', '%s')", pInfo[playerid][pName], reasonText);
    mysql_tquery(dbHandle, query);
    return true;
}

stock LogsPlayerText(playerid, text[]) {

    new escapedText[128];
    mysql_escape_string(text, escapedText);

    new query[256];
    format(query, sizeof(query), "INSERT INTO chat_logs (player_name, message) VALUES ('%s', '%s')", pInfo[playerid][pName], escapedText);
    mysql_tquery(dbHandle, query);
}

// Функция для логирования создания транспорта
stock LogsPlayerSpawnVehicle(playerid)
{
    new playerName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, playerName, sizeof(playerName)); // Получаем имя игрока

    new vehicleID = GetPVarInt(playerid, !"created_veh"); // Получаем ID созданного транспорта
    new vehicleModel = GetVehicleModel(vehicleID); // Получаем модель транспорта

    // Получаем позицию транспорта
    new Float:posX, Float:posY, Float:posZ;
    GetVehiclePos(vehicleID, posX, posY, posZ);

    // Формируем запрос для логирования
    new query[256];
    format(query, sizeof(query), "INSERT INTO vehicle_logs (player_name, vehicle_model, pos_x, pos_y, pos_z) VALUES ('%s', %d, %f, %f, %f)",
        playerName, vehicleModel, posX, posY, posZ);
    mysql_tquery(dbHandle, query); // Отправляем запрос

    return 1;
}

/*
stock LogsPlayerSpawnVehicle(playerid) {

    new vehicleID = GetPVarInt(playerid, !"created_veh");
    new vehicleModel = GetVehicleModel(vehicleID);

   
    new Float:posX, Float:posY, Float:posZ;
    GetVehiclePos(vehicleID, posX, posY, posZ);

    
    new query[256];
    format(query, sizeof(query), "INSERT INTO vehicle_logs (player_name, vehicle_model, pos_x, pos_y, pos_z) VALUES ('%s', %d, %f, %f, %f)",
        pInfo[playerid][pName], vehicleModel, posX, posY, posZ);
    mysql_tquery(dbHandle, query);

}*/