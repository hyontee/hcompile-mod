//>> Файл: bykranin_src/core/server/server_09.inc  (460 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: /rewardd, OnSkinSaved, LoadPlayerSkin, OnPlayerSkinLoaded, GetPlayerKills, GetPlayerDeaths, Spectate_CanWatchPlayer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:rewardd(playerid)
{
    new playername[MAX_PLAYER_NAME], debugstr[512];

    // Получаем никнейм игрока для логирования
    GetPlayerName(playerid, playername, sizeof(playername));

    // Создаем JSON-объект
    new JSON:root = JSON_Object();
    JSON_SetInt(root, "t", 0); // type = 0 для инициализации экрана
    
    // Создаем массив предметов "pr" аналогично вашему инвентарю
    new JSON:items = JSON_Array(
        JSON_Object(
            "id", JSON_Int(100),
            "n", JSON_String("Тестовый скин Дракона"),
            "td", JSON_Int(2),
            "st", JSON_Int(0),
            "el", JSON_Int(134),
            "c", JSON_Int(123),
            "ds", JSON_Int(0),
            "sp", JSON_Int(500),
            "r", JSON_Int(3),
            "ct", JSON_Int(1),
            "els", JSON_Array()
        ),
        JSON_Object(
            "id", JSON_Int(26),
            "n", JSON_String("LEXUS IS500F PERFOMANCE"),
            "td", JSON_Int(5),
            "st", JSON_Int(0),
            "el", JSON_Int(28697),
            "c", JSON_Int(0),
            "ds", JSON_Int(0),
            "sp", JSON_Int(450),
            "r", JSON_Int(4),
            "ct", JSON_Int(1),
            "els", JSON_Array()
        ),
        JSON_Object(
            "id", JSON_Int(101),
            "n", JSON_String("Редкий автомобиль"),
            "td", JSON_Int(5),
            "st", JSON_Int(30),
            "el", JSON_Int(9212),
            "c", JSON_Int(0),
            "ds", JSON_Int(7),
            "sp", JSON_Int(1000),
            "r", JSON_Int(4),
            "ct", JSON_Int(1),
            "els", JSON_Array()
        ),
        JSON_Object(
            "id", JSON_Int(102),
            "n", JSON_String("VIP статус"),
            "td", JSON_Int(9),
            "st", JSON_Int(0),
            "el", JSON_Int(0),
            "c", JSON_Int(0),
            "ds", JSON_Int(30),
            "sp", JSON_Int(200),
            "r", JSON_Int(2),
            "ct", JSON_Int(1),
            "els", JSON_Array()
        ),
        JSON_Object(
            "id", JSON_Int(9),
            "n", JSON_String("Вика Отличница"),
            "td", JSON_Int(11), // type = 11 (INVENTORY_ITEMS_PRIZE_TYPE)
            "st", JSON_Int(0),
            "el", JSON_Int(134), // internalId = 134
            "c", JSON_Int(5500044), // count = 5500044
            "ds", JSON_Int(0),
            "sp", JSON_Int(160), // priceSprayed = 160
            "r", JSON_Int(3), // rarity = 3
            "ct", JSON_Int(1),
            "els", JSON_Array()
        )
    );
    JSON_SetArray(root, "pr", items);

    // Добавляем список фильтров
    new JSON:alarms = JSON_Array(
        JSON_Int(1), // ALL
        JSON_Int(2), // SKINS  
        JSON_Int(3), // VIP
        JSON_Int(4), // ACCESSORIES
        JSON_Int(5), // CARS
        JSON_Int(6), // CURRENCIES
        JSON_Int(7), // OTHER
        JSON_Int(11) // INVENTORY_ITEMS
    );
    JSON_SetArray(root, "fl", alarms);

    // Логирование JSON для отладки
    JSON_Stringify(root, debugstr, sizeof(debugstr));
    format(debugstr, sizeof(debugstr), "[LOG] Игрок %s (ID: %d) вызвал /rewardd с JSON: %s", playername, playerid, debugstr);
    print(debugstr);

    // Получение статистики игрока
    new kills = GetPlayerScore(playerid);
    new deaths = 0;
    new score = GetPlayerScore(playerid);
    new money = GetPlayerMoney(playerid);

    // Отображаем статистику и информацию о тестовых предметах
    format(debugstr, sizeof(debugstr), "Ник: %s | Убийства: %d | Смерти: %d | Счет: %d | Деньги: %d", playername, kills, deaths, score, money);
    SendClientMessage(playerid, -1, debugstr);
    SendClientMessage(playerid, -1, "Тестовые предметы: Скин Дракона, Lexus IS500F, Автомобиль, VIP статус, Вика Отличница");

    // Вызов ShowPlayerGUI
    ShowPlayerGUI(playerid, BpRewardsGuiFragment, root);
    SendClientMessage(playerid, -1, "BP Rewards: Меню наград открыто с 5 тестовыми предметами");

    // Очистка JSON
    JSON_Cleanup(root);
    return 1;
}
// Колбэк после сохранения скина
forward OnSkinSaved(playerid);
public OnSkinSaved(playerid)
{
    printf("[DB] Скин успешно сохранен для игрока ID: %d", playerid);
    return 1;
}

// Функция для загрузки скина игрока при входе (добавь в OnPlayerConnect)
stock LoadPlayerSkin(playerid)
{
    new query[128];
    mysql_format(mysql, query, sizeof(query),
        "SELECT skin_model, skin_name FROM player_skins WHERE player_id = %d ORDER BY obtained_date DESC LIMIT 1",
        playerid
    );
    mysql_tquery(mysql, query, "OnPlayerSkinLoaded", "i", playerid);
}

// Колбэк после загрузки скина (исправленная версия)
forward OnPlayerSkinLoaded(playerid);
public OnPlayerSkinLoaded(playerid)
{
    if(cache_num_rows() > 0)
    {
        new skinModel, skinName[128];
        
        // Используем правильные функции для получения данных
        cache_get_field_content(0, "skin_model", skinName, mysql, sizeof(skinName));
        skinModel = strval(skinName);
        
        cache_get_field_content(0, "skin_name", skinName, mysql, sizeof(skinName));
        
        SetPlayerSkin(playerid, skinModel);
        
        new msg[128];
        format(msg, sizeof(msg), "Ваш скин восстановлен: %s (модель: %d)", skinName, skinModel);
        SendClientMessage(playerid, -1, msg);
        
        printf("[DB] Загружен скин %d (%s) для игрока ID: %d", skinModel, skinName, playerid);
    }
    return 1;
}


stock GetPlayerKills(playerid)
{
    // Заглушка - замените на вашу систему убийств
    return GetPlayerScore(playerid) + random(50);
}

stock GetPlayerDeaths(playerid)
{
    // Заглушка - замените на вашу систему смертей
    return random(30);
}
stock bool:Spectate_CanWatchPlayer(adminid, targetid)
{
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return false;
    if(GetPlayerSecretEx(targetid) >= 1) return false;

    if(adminid != INVALID_PLAYER_ID && GetPlayerAdminEx(targetid) >= 13 && GetPlayerAdminEx(adminid) < 13)
    {
        return false;
    }

    return true;
}
stock GetNextPlayer(adminid, current, dir)
{
    if(dir > 0) // next
    {
        for(new i = current + 1; i < MAX_PLAYERS; i++)
        {
            if(Spectate_CanWatchPlayer(adminid, i)) 
                return i;
        }
        for(new i = 0; i < current; i++)
        {
            if(Spectate_CanWatchPlayer(adminid, i)) 
                return i;
        }
    }
					else if(dir < 0) // previous
    {
        for(new i = current - 1; i >= 0; i--)
        {
            if(Spectate_CanWatchPlayer(adminid, i)) 
                return i;
        }
        for(new i = MAX_PLAYERS - 1; i > current; i--)
        {
            if(Spectate_CanWatchPlayer(adminid, i)) 
                return i;
        }
    }
    return INVALID_PLAYER_ID;
}

CMD:sp(playerid, params[])
{
    if(!SRAdmin_TeleportAllowed(playerid)) return 1;

    extract params -> new targetid; else return SendClientMessage(playerid, 0xCECECEFF, ""SC"Используйте: /sp [id игрока]");

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return ShowNotificationNew(playerid, 2, 4, 0, 0, "Такого игрока нет", "");

    if(!Spectate_CanWatchPlayer(playerid, targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы не можете следить за этим игроком");

    if(GetPlayerState(playerid) != PLAYER_STATE_SPECTATING && GetPlayerSpectateData(playerid, S_PLAYER) != -1)
    {
        printf("[SP][CMD] stale spectate reset /sp admin=%d old_target=%d state=%d", playerid, GetPlayerSpectateData(playerid, S_PLAYER), GetPlayerState(playerid));
        SetPlayerSpectateData(playerid, S_PLAYER, -1);
    }

    printf("[SP][CMD] /sp admin=%d target=%d state=%d", playerid, targetid, GetPlayerState(playerid));
    if(!StartSpectate(playerid, targetid)) return 1;
    StartSpectateGUIRefresh(playerid);
    ShowSpectateGUI(playerid, targetid);
    
    new fmt_text[128];
    format(fmt_text, sizeof fmt_text, "[A] %s[%d] следит за %s[%d]", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid);
    SendMessageToAdmins(fmt_text, 0x999999FF);
    
    SendClientMessage(playerid, 0x999999FF, "[A] Используйте кнопки в GUI для переключения между игроками.");
    
    format(fmt_text, sizeof fmt_text, "Следит за %s[acc:%d]", GetPlayerNameEx(targetid), GetPlayerAccountID(targetid));
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);
    
    return 1;
}

stock ShowSpectateGUI(playerid, targetid, bool:refresh_only = false)
{
    if(!SRAdmin_ViewerAuthorized(playerid)) return 0;
    if(GetPlayerSpectateData(playerid, S_PLAYER) != targetid) return 0;
    if(GetPVarInt(playerid, "SRSpecTargetSession") != SRAdmin_Session(targetid)) return 0;
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid)) return 0;

    new target_name[MAX_PLAYER_NAME];
    new Float:hp, Float:armor, Float:speed, ping, money, vehicleid, level;
    
    GetPlayerName(targetid, target_name, sizeof(target_name));
    GetPlayerHealth(targetid, hp);
    GetPlayerArmour(targetid, armor);
    ping = GetPlayerPing(targetid);
    money = GetPlayerMoney(targetid);
    vehicleid = GetPlayerVehicleID(targetid);
    speed = GetPlayerSpeed(targetid);
    level = GetPlayerLevel(targetid);

    new JSON:info1 = JSON_Object("p", JSON_Int(5), "n", JSON_String("Пинг"), "v", JSON_Int(ping));
    new JSON:info2 = JSON_Object("p", JSON_Int(4), "n", JSON_String("Скорость"), "v", JSON_Int(floatround(speed)));
    new JSON:info3 = JSON_Object("p", JSON_Int(2), "n", JSON_String("Здоровье"), "v", JSON_Int(floatround(hp)));
    new JSON:info4 = JSON_Object("p", JSON_Int(3), "n", JSON_String("Броня"), "v", JSON_Int(floatround(armor)));
    new JSON:info5 = JSON_Object("p", JSON_Int(6), "n", JSON_String("Деньги"), "v", JSON_Int(money));
    new JSON:info6 = JSON_Object("p", JSON_Int(1), "n", JSON_String("Уровень"), "v", JSON_Int(level));
    new JSON:info7 = JSON_Object("p", JSON_Int(7), "n", JSON_String("Транспорт"), "v", JSON_Int(vehicleid));
    
    new JSON:pi_array = JSON_Array(info1, info2, info3, info4, info5, info6, info7);
    
    new JSON:json = JSON_Object();
    JSON_SetInt(json, "t", 1);
    JSON_SetInt(json, "id", targetid);
    JSON_SetString(json, "pn", target_name);
    JSON_SetArray(json, "pi", pi_array);
    
    JSON_SetString(json, "tableTitle", "Информация об игроке");
    JSON_SetBool(json, "isShowTable", true);
    JSON_SetString(json, "categoryTitle", "Режим слежения");
    JSON_SetBool(json, "isInterfaceVisible", true);
    
    if(refresh_only)
    {
        UpdatePlayerGUI(playerid, 66, json);
    }
    else
    {
        ShowPlayerGUI(playerid, 66, json);
    }
    
    ~json;
    
    return 1;
}
CMD:tungui1(playerid, params[])
{
    new JSON:tuning_json = JSON_Object();

    JSON_SetInt(tuning_json, "o", 2);
    JSON_SetInt(tuning_json, "w", 2);
    JSON_SetInt(tuning_json, "t", 2);
    JSON_SetInt(tuning_json, "j", 1000);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", "BMW M5 F90");
	
    JSON_SetInt(tuning_json, "m", GetPlayerMoney(playerid));

    new Float:x = 998.23653, Float:y = 1499.67341, Float:z = 1499.66617;
    SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.0); // Поворот машины к камере

    // Установка интерьера — укажи нужный номер интерьера
    new interior = 1; // например, 1 — номер интерьера тюнинг-зала, замени на свой если другой
    SetPlayerInterior(playerid, interior);

    // Камера как на скрине — немного слева-сверху
    SetPlayerCameraPos(playerid, x - 4.0, y + 4.0, z + 1.0);
    SetPlayerCameraLookAt(playerid, x, y, z + 1.0);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}
CMD:tungui2(playerid, params[])
{
    new JSON:tuning_json = JSON_Object();

    JSON_SetInt(tuning_json, "o", 2);
    JSON_SetInt(tuning_json, "w", 1);
    JSON_SetInt(tuning_json, "t", 2);
    JSON_SetInt(tuning_json, "j", 1000);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetString(tuning_json, "n", "BMW M5 F90");
    JSON_SetInt(tuning_json, "m", GetPlayerMoney(playerid));

    new Float:x = 998.23653, Float:y = 1499.67341, Float:z = 1499.66617;
    SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.0); // Поворот машины к камере

    // Установка интерьера — укажи нужный номер интерьера
    new interior = 1; // например, 1 — номер интерьера тюнинг-зала, замени на свой если другой
    SetPlayerInterior(playerid, interior);

    // Камера как на скрине — немного слева-сверху
    SetPlayerCameraPos(playerid, x - 4.0, y + 4.0, z + 1.0);
    SetPlayerCameraLookAt(playerid, x, y, z + 1.0);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}
stock Float:GetVehicleModelInfoFloat(modelid, type)
{
    new Float:x, Float:y, Float:z;
    GetVehicleModelInfo(modelid, type, x, y, z);
    return x;
}

stock SetVehicleMaxSpeedd(vehicleid, Float:max_speed)
{
    new Float:vx, Float:vy, Float:vz;
    GetVehicleVelocity(vehicleid, vx, vy, vz);
    new Float:current_speed = floatsqroot(vx*vx + vy*vy + vz*vz) * 180.0; // м/с ? км/ч

    if(current_speed > max_speed)
    {
        new Float:ratio = max_speed / current_speed;
        SetVehicleVelocity(vehicleid, vx * ratio, vy * ratio, vz * ratio);
    }

    vInfo[vehicleid][vMaxSpeed] = max_speed;
}
stock ApplyBrakePower(vehicleid, Float:power)
{
    vInfo[vehicleid][vBrakePower] = power;
}

new Float:g_RestrictedAreas[][4] = {
    {846.602600, 796.555847, 13.400512, 50.0}, // арзамас спавн + радиус 50м
    {2740.712158, -2441.565185, 21.774286, 50.0}, // южный спавн + радиус 50м
    {-2429.236083, 203.175277, 26.096101, 50.0}, // лыткарино спавн + радиус 50м
    {1801.694091, 2523.137695, 14.602633, 50.0}, // батырево спавн + радиус 50м
    {-2667.526611, 2006.567016, 11.197804, 50.0}, // спавн нижегородск + радиус 50м
    {-2159.371093, 1558.103271, 9.840852, 50.0} // южный вокзал нижегородска + радиус 50м
};

#define MAX_RESTRICTED_AREAS 6

IsPlayerInRestrictedArea(Float:x, Float:y, Float:z)
{
    for(new i = 0; i < MAX_RESTRICTED_AREAS; i++)
    {
        if(IsPointInSphere(x, y, z, g_RestrictedAreas[i][0], g_RestrictedAreas[i][1], g_RestrictedAreas[i][2], g_RestrictedAreas[i][3]))
        {
            return 1;
        }
    }
    return 0;
}

stock IsPointInSphere(Float:x, Float:y, Float:z, Float:sphere_x, Float:sphere_y, Float:sphere_z, Float:radius)
{
    new Float:distance = VectorSize(x-sphere_x, y-sphere_y, z-sphere_z);
    return (distance <= radius);
}
CMD:testnpc(playerid, params[])
{
    new JSON:json = JSON_Object(
        "id", JSON_Int(1), // ID
        "n", JSON_String("NPC"), // Title
        "d", JSON_String("Впереди еще столько мистических загадок и ужасных секретов! Не боишься вернуться к прохождению события <font color='#ffc700'>Тайна Шкатулки</font>?"), // Description
        "m", JSON_Int(5500056), // Skin ID from speaker.skin
        "ts", JSON_Int(30), // Typing speed (default value, as not specified in JSON)
        "st", JSON_Int(30), // Allow skipping text (default value, as not specified)
        "s", JSON_String("Event/demonhunter_int-001.ogg") // Sound
    );
    
    // Create buttons array
    new JSON:buttons_array = JSON_Array();
    
    // First button - "Начать" (Green)
    new JSON:button1 = JSON_Object(
        "n", JSON_String("Начать"),
        "bk", JSON_Int(1), // Button key (assuming sequential keys starting from 1)
        "t", JSON_Int(1) // Green button (color: 1)
    );
    JSON_Append(buttons_array, button1);
    
    // Second button - "Закрыть" (Red)
    new JSON:button2 = JSON_Object(
        "n", JSON_String("Закрыть"),
        "bk", JSON_Int(2), // Button key
        "t", JSON_Int(3) // Red button (color: 3)
    );
    JSON_Append(buttons_array, button2);
    
    JSON_SetArray(json, "b", buttons_array);
    
    // Show GUI
    ShowPlayerGUI(playerid, 63, json);
    
    ~json;
    
    SendClientMessage(playerid, -1, "GUI взаимодействия с NPC открыто!");
    return 1;
}

