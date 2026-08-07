инклуде 
new bool:pMediaMuted[MAX_PLAYERS];
new pMediaLevel[MAX_PLAYERS];
new pMediaVehicle[MAX_PLAYERS] = {INVALID_VEHICLE_ID, ...};
new pMediaWorld[MAX_PLAYERS];


при входе например сюда куда-то 
new str[128];
format(str, sizeof(str), "{FFFFFF}Добро пожаловать на {FFD700}RACE RUSSIA{FFFFFF}, сервер — {FF0000}MOSCOW");
SendClientMessage(playerid, -1, str)

добавляеш это
 new player_media_level = GetPlayerYouTubeEx(playerid);
if(player_media_level >= 1)
{
    switch(player_media_level)
    {
        case 1: SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Вы Медиа Партнёр RACE RUSSIA!");
        case 2: SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFD700}Вы Заместитель Пиар Менеджера RACE RUSSIA!");
        case 3: SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF0000}Вы Пиар Менеджер RACE RUSSIA!");
    }
    
    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}Используйте {5DADE2}/mhelp {FFFFFF}для информации");
}


патом далше команды свои CMD:yhelp

удаляеш это вот до сюды  CMD:delyt
потом это удаляеш на это место ставиш мое команды ок вот они

CMD:setmedia(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 3 && GetPlayerAdminEx(playerid) < 10) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Только Пиар Менеджер или Админ 10+!");
    
    new targetid, level;
    if(sscanf(params, "ud", targetid, level))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/setmedia [id] [0-3]");
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн");
    
    // Проверяем кто использует команду
    new is_pr_manager = (GetPlayerYouTubeEx(playerid) == 3);
    new is_admin_10plus = (GetPlayerAdminEx(playerid) >= 10);
    
    if(is_pr_manager)
    {
        // Пиар Менеджер может выдавать 0-2 уровни
        if(level < 0 || level > 2)
            return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Уровень: 0-нет, 1-Медиа Партнёр, 2-Зам.ПР");
        
        // Нельзя управлять другим Пиар Менеджером
        if(GetPlayerYouTubeEx(targetid) == 3)
            return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Нельзя управлять другим Пиар Менеджером!");
    }
    else if(is_admin_10plus)
    {
        // Админ 10+ может выдавать 0-3 уровни
        if(level < 0 || level > 3)
            return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Уровень: 0-нет, 1-Медиа Партнёр, 2-Зам.ПР, 3-Пиар Менеджер");
    }
    
    // Сохраняем старый уровень для логов
    new old_level = GetPlayerYouTubeEx(targetid);
    
    // Устанавливаем новый уровень
    SetPlayerData(targetid, P_YOUTUBE, level);
    UpdatePlayerDatabaseInt(targetid, "youtube", level);
    
    // Отправляем сообщения
    new str[128];
    if(level == 0)
    {
        format(str, sizeof(str), "Медиа-админка: {58D68D}Вы сняли медиа-админку с игрока %s[%d]", GetPlayerNameEx(targetid), targetid);
        SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {F1948A}Ваша медиа-админка снята!");
    }
    else if(level == 1)
    {
        format(str, sizeof(str), "Медиа-админка: {58D68D}Вы выдали медиа-админку (Медиа Партнёр) игроку %s[%d]", GetPlayerNameEx(targetid), targetid);
        SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Вы Медиа Партнёр RACE RUSSIA!");
    }
    else if(level == 2)
    {
        format(str, sizeof(str), "Медиа-админка: {58D68D}Вы выдали медиа-админку (Заместитель ПР) игроку %s[%d]", GetPlayerNameEx(targetid), targetid);
        SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {FFD700}Вы Заместитель Пиар Менеджера RACE RUSSIA!");
    }
    else if(level == 3)
    {
        format(str, sizeof(str), "Медиа-админка: {58D68D}Вы выдали медиа-админку (Пиар Менеджер) игроку %s[%d]", GetPlayerNameEx(targetid), targetid);
        SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {FF0000}Вы Пиар Менеджер RACE RUSSIA!");
    }
    
    SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}Используйте {5DADE2}/mhelp {FFFFFF}для информации");
    SendClientMessage(playerid, 0xC6E2FFFF, str);
    
    // Логируем действие
    new log_text[256];
    if(is_pr_manager)
    {
        format(log_text, sizeof(log_text), "Пиар Менеджер %s[%d] изменил уровень медиа игроку %s[%d] (было: %d, стало: %d)",
            GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid, old_level, level);
    }
    else
    {
        format(log_text, sizeof(log_text), "Админ %s[%d] изменил уровень медиа игроку %s[%d] (было: %d, стало: %d)",
            GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(targetid), targetid, old_level, level);
    }
    
    SendMessageToAdmins(log_text, 0xC6E2FFFF);
    
    return 1;
}

// ================ УРОВЕНЬ 1: МЕДИА ПАРТНЁР ================
CMD:mhelp(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");
    
    new title[64];
    new media_level = GetPlayerYouTubeEx(playerid);
    
    switch(media_level)
    {
        case 1: format(title, sizeof(title), "RACE RUSSIA | Медиа Админка (Медиа Партнёр)");
        case 2: format(title, sizeof(title), "RACE RUSSIA | Медиа Админка (Заместитель ПР)");
        case 3: format(title, sizeof(title), "RACE RUSSIA | Медиа Админка (Пиар Менеджер)");
    }
    
    new info[2048];
    
    strcat(info, "{33CCFF}RACE RUSSIA | Медиа Админка\n\n");
    strcat(info, "{5DADE2}Команды 1-го уровня (Медиа Партнёр):\n");
    strcat(info, "{FFFFFF}/mchat - Чат для медиа-команды\n");
    strcat(info, "/mveh - Заспавнить транспорт\n");
    strcat(info, "/mskin - Временный скин\n");
    strcat(info, "/mgoto - Телепорт к игроку\n");
    strcat(info, "/mgethere - Телепортировать к себе\n");
    strcat(info, "/msp - Слежка за игроком\n");
    strcat(info, "/mspoff - Закончить слежку\n");
    strcat(info, "/maz - Телепорт в медиа-зону\n");
    strcat(info, "/mhp - Восстановить здоровье\n");
    strcat(info, "/mgun - Получить оружие\n");
    strcat(info, "/mytime - Изменить своё время\n");
    strcat(info, "/myvr - Изменить виртуальный мир\n");
    strcat(info, "/mcc - Очистить свой чат\n\n");
    
    if(media_level >= 2)
    {
        strcat(info, "{FFD700}Команды 2-го уровня (Заместитель ПР):\n");
        strcat(info, "{FFFFFF}/mmute - Заглушить в медиа-чате\n");
        strcat(info, "/munmute - Снять мут\n");
        strcat(info, "/minvite - Пригласить в медиа (1 уровень)\n");
        strcat(info, "/mlist - Список онлайн медиа\n");
        strcat(info, "/mfind - Поиск медиа по нику\n\n");
    }
    
    if(media_level >= 3)
    {
        strcat(info, "{FF0000}Команды 3-го уровня (Пиар Менеджер):\n");
        strcat(info, "{FFFFFF}/setmedia - Управление уровнями медиа\n");
        strcat(info, "/mdemote - Понизить уровень медиа\n");
        strcat(info, "/mpromote - Повысить до зам. ПР\n");
        strcat(info, "/mkick - Исключить из медиа-команды\n");
        strcat(info, "/mwarn - Выдать предупреждение\n");
    }
    
    ShowPlayerDialog(playerid, 15500, DIALOG_STYLE_MSGBOX, title, info, "Закрыть", "");
    return 1;
}

CMD:maz(playerid)
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");

    SetPlayerVirtualWorld(playerid, 1);
    SetPlayerInterior(playerid, 1);
    SetPlayerPos(playerid, 294.594665, 2139.808349, 1765.506347);
    SetPlayerFacingAngle(playerid, 356.398986);
    
    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Вы телепортировались в медиа-зону");
    return 1;
}

CMD:mspoff(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");

    if(GetPlayerSpectateData(playerid, S_PLAYER) != -1)
    {
        StopSpectateY(playerid);
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Вы закончили слежку за игроком");
    }

    return 1;
}

CMD:msp(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/msp [id игрока]");

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн");

    if(GetPlayerSpectateData(playerid, S_PLAYER) == -1)
    {
        new Float: x, Float: y, Float: z, Float: a, skin = GetPlayerSkin(playerid);
        GetPlayerPos(playerid, x, y, z);
        GetPlayerFacingAngle(playerid, a);

        SetPlayerSpectateData(playerid, S_START_POS_X, x);
        SetPlayerSpectateData(playerid, S_START_POS_Y, y);
        SetPlayerSpectateData(playerid, S_START_POS_Z, z);
        SetPlayerSpectateData(playerid, S_START_ANGLE, a);
        SetPlayerSpectateData(playerid, S_START_INTERIOR, GetPlayerInterior(playerid));
        SetPlayerSpectateData(playerid, S_START_VIRTUAL_WORLD, GetPlayerVirtualWorld(playerid));
        SetSpawnInfo(playerid, 0, skin, x, y, z, a, 0, 0, 0, 0, 0, 0);
    }

    StartSpectateY(playerid, targetid);

    new fmt_text[128];
    format(fmt_text, sizeof fmt_text, "Медиа-админка: {58D68D}Вы начали следить за игроком %s[%d]", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, 0xC6E2FFFF, fmt_text);

    return 1;
}

CMD:mchat(playerid, params[])
{
    new media_level = GetPlayerYouTubeEx(playerid);
    
    if(media_level < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");
    
    if(pMediaMuted[playerid])
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы заглушены в медиа-чате!");
    
    if(isnull(params)) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mchat [текст]");
    
    new msg[144], name[MAX_PLAYER_NAME];
    GetPlayerName(playerid, name, sizeof(name));
    
    // Формируем сообщение с правильным тегом
    switch(media_level)
    {
        case 1: format(msg, sizeof(msg), "[Партнёр] %s[%d]: {FFFFFF}%s", name, playerid, params);
        case 2: format(msg, sizeof(msg), "[Зам.ПР] %s[%d]: {FFFFFF}%s", name, playerid, params);
        case 3: format(msg, sizeof(msg), "[Пиар Менеджер] %s[%d]: {FFFFFF}%s", name, playerid, params);
    }
    
    foreach(new i : Player)
    {
        if(GetPlayerYouTubeEx(i) >= 1)
        {
            SendClientMessage(i, 0xA3D5FFFF, msg);
        }
    }
    
    // Логирование в консоль
    printf("[MEDIA-CHAT] %s[%d] (level %d): %s", name, playerid, media_level, params);
    
    return 1;
}

CMD:mskin(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");

    new skin_id;
    if(sscanf(params, "d", skin_id))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mskin [id скина]");

    SetPlayerSkin(playerid, skin_id);

    new fmt_text[128];
    format(fmt_text, sizeof fmt_text, "Медиа-админка: {58D68D}Вы выдали себе скин (ID: %d)", skin_id);
    SendClientMessage(playerid, 0xC6E2FFFF, fmt_text);

    return 1;
}

CMD:mhp(playerid)
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");

    SetPlayerData(playerid, P_HEALTH, 100);
    SetPlayerHealthEx(playerid, 100);

    if(GetPlayerData(playerid, P_HOSPITAL))
        SetPlayerData(playerid, P_HOSPITAL, false);

    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Вы восстановили себе хп");
    return 1;
}

CMD:mgoto(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mgoto [id игрока]");

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн");

    if(GetPlayerSecretEx(targetid) >= 1)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}У игрока есть привелегия скрытность");

    new Float: x, Float: y, Float: z;
    new interior, virtual_world;
    GetPlayerPos(targetid, x, y, z);
    interior = GetPlayerInterior(targetid);
    virtual_world = GetPlayerVirtualWorld(targetid);

    SetPlayerPosEx(playerid, x + 1.0, y + 1.0, z, 0.0, interior, virtual_world, false);

    SetPlayerInHouse(playerid, GetPlayerInHouse(targetid));
    SetPlayerInBiz(playerid, GetPlayerInBiz(targetid));

    new fmt_msg[256];
    format(fmt_msg, sizeof fmt_msg, "Медиа-админка: {58D68D}Вы успешно телепортировались к игроку %s[%d]", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, 0xC6E2FFFF, fmt_msg);

    return 1;
}

CMD:mgethere(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");

    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mgethere [id игрока]");

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн");

    new Float: x, Float: y, Float: z;
    GetPlayerPos(playerid, x, y, z);

    SetPlayerPosEx(targetid, x + 1.0, y + 1.0, z, 0.0, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid), false);

    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Игрок телепортирован к вам!");
    SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Медиа телепортировал вас к себе!");

    return 1;
}

CMD:mgun(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не МедиА Администратор!");

    new weapon_id, ammo;
    if(sscanf(params, "dd", weapon_id, ammo))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mgun [id оружия] [патроны]");

    GivePlayerWeapon(playerid, weapon_id, ammo);

    new fmt_text[128];
    format(fmt_text, sizeof fmt_text, "Медиа-админка: {58D68D}Вы получили оружие (ID: %d, Патроны: %d)", weapon_id, ammo);
    SendClientMessage(playerid, 0xC6E2FFFF, fmt_text);

    return 1;
}

CMD:mytime(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");
    
    new hour;
    if(sscanf(params, "d", hour)) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mytime [час 0-23]");
    
    if(hour < 0 || hour > 23)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Час должен быть от 0 до 23!");
    
    SetPlayerTime(playerid, hour, 0);
    
    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Ваше время изменено на {FFFFFF}%02d:00", hour);
    return 1;
}

CMD:myvr(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");
    
    new world;
    if(sscanf(params, "d", world)) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/myvr [id мира]");
    
    SetPlayerVirtualWorld(playerid, world);
    
    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Ваш мир изменен на ID: {FFFFFF}%d", world);
    return 1;
}

CMD:mcc(playerid)
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");

    for(new i; i < 100; i++)
    {
        SendClientMessage(playerid, -1, " ");
    }

    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Ваш чат очищен!");
    return 1;
}

CMD:mveh(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 1) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Вы не Медиа Администратор!");
    
    new modelid;
    
    if(sscanf(params, "d", modelid))
    {
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mveh [id модели]");
        return 1;
    }
    
    // Только проверка на танк
    if(modelid == 432)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Создание транспорта с ID 432 запрещено.");

    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    // Отходим подальше от игрока
    x += (5.0 * floatsin(-a, degrees));
    y += (5.0 * floatcos(-a, degrees));
    z += 1.0;

    // Пробуем создать
    new vehicleid = CreateVehicle(modelid, x, y, z, a, 1, 1, -1, 0);
    
    if(vehicleid != INVALID_VEHICLE_ID)
    {
        new fmt_text[128];
        format(fmt_text, sizeof fmt_text, "Медиа-админка: {58D68D}Вы создали транспорт ID: %d", modelid);
        SendClientMessage(playerid, 0xC6E2FFFF, fmt_text);
        printf("[MEDIA-VEH] %s создал транспорт ID: %d", GetPlayerNameEx(playerid), modelid);
    }
    else
    {
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Не удалось создать транспорт!");
    }
    
    return 1;
}

// ================ УРОВЕНЬ 2: ЗАМЕСТИТЕЛЬ ПИАР МЕНЕДЖЕРА ================
CMD:mmute(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 2) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Нужен 2+ уровень медиа!");
    
    new targetid, minutes, reason[64];
    if(sscanf(params, "uds[64]", targetid, minutes, reason))
    {
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mmute [id] [минуты] [причина]");
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}Пример: {5DADE2}/mmute 5 30 Флуд в чате");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн!");
    
    if(minutes < 1 || minutes > 1440)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Время: 1-1440 минут (1-24 часа)");
    
    pMediaMuted[targetid] = true;
    
    new str[256];
    format(str, sizeof(str), "Медиа-админка: {F1948A}%s[%d] заглушен в медиа-чате на %d мин. Причина: %s", GetPlayerNameEx(targetid), targetid, minutes, reason);
    
    foreach(new i : Player)
    {
        if(GetPlayerYouTubeEx(i) >= 1)
            SendClientMessage(i, 0xC6E2FFFF, str);
    }
    
    format(str, sizeof(str), "Медиа-админка: {F1948A}Вы заглушены в медиа-чате на %d мин. Причина: %s", minutes, reason);
    SendClientMessage(targetid, 0xC6E2FFFF, str);
    
    SetTimerEx("RemoveMediaMute", minutes * 60 * 1000, false, "i", targetid);
    
    return 1;
}

CMD:munmute(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 2) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Нужен 2+ уровень медиа!");
    
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/munmute [id]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн!");
    
    pMediaMuted[targetid] = false;
    
    SendClientMessage(playerid, 0xC6E2FFFF, 
        "Медиа-админка: {58D68D}%s[%d] разглушен в медиа-чате!", 
        GetPlayerNameEx(targetid), targetid
    );
    
    SendClientMessage(targetid, 0xC6E2FFFF, 
        "Медиа-админка: {58D68D}Вы разглушены в медиа-чате!"
    );
    
    return 1;
}

CMD:minvite(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 2) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Нужен 2+ уровень медиа!");
    
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/minvite [id]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн!");
    
    if(GetPlayerYouTubeEx(targetid) > 0)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}У игрока уже есть медиа-админка!");
    
    SetPlayerData(targetid, P_YOUTUBE, 1);
    UpdatePlayerDatabaseInt(targetid, "youtube", 1);
    
    SendClientMessage(playerid, 0xC6E2FFFF, 
        "Медиа-админка: {58D68D}%s[%d] разглушен в медиа-чате!", 
        GetPlayerNameEx(targetid), targetid
    );
    
    SendClientMessage(targetid, 0xC6E2FFFF, 
        "Медиа-админка: {58D68D}Вы разглушены в медиа-чате!"
    );
    
    return 1;
}

CMD:minvite(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 2) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Нужен 2+ уровень медиа!");
    
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/minvite [id]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн!");
    
    if(GetPlayerYouTubeEx(targetid) > 0)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}У игрока уже есть медиа-админка!");
    
    SetPlayerData(targetid, P_YOUTUBE, 1);
    UpdatePlayerDatabaseInt(targetid, "youtube", 1);
    
    SendClientMessage(playerid, 0xC6E2FFFF, 
    "Медиа-админка: {58D68D}%s[%d] разглушен в медиа-чате!", 
        GetPlayerNameEx(targetid), targetid
    );
    
    SendClientMessage(targetid, 0xC6E2FFFF, 
        "Медиа-админка: {58D68D}Вы разглушены в медиа-чате!"
    );
    
    return 1;
}



CMD:mlist(playerid)
{
    if(GetPlayerYouTubeEx(playerid) < 2) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Нужен 2+ уровень медиа!");
    
    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFD700}=== ОНЛАЙН МЕДИА ===");
    
    new count = 0;
    foreach(new i : Player)
    {
        if(GetPlayerYouTubeEx(i) >= 1)
        {
            new level_str[32];
            if(GetPlayerYouTubeEx(i) == 1) format(level_str, sizeof(level_str), "Медиа Партнёр");
            else if(GetPlayerYouTubeEx(i) == 2) format(level_str, sizeof(level_str), "Зам.ПР");
            else if(GetPlayerYouTubeEx(i) == 3) format(level_str, sizeof(level_str), "Пиар Менеджер");
            
            new msg[128];
            format(msg, sizeof(msg), "Медиа-админка: {FFFFFF}%s[%d] - %s", GetPlayerNameEx(i), i, level_str);
            SendClientMessage(playerid, 0xC6E2FFFF, msg);
            count++;
        }
    }
    
    if(count == 0)
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Нет медиа онлайн");
    else
    {
        new msg[64];
        format(msg, sizeof(msg), "Медиа-админка: {FFFFFF}Всего: %d", count);
        SendClientMessage(playerid, 0xC6E2FFFF, msg);
    }
    
    return 1;
}

CMD:mfind(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 2) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Нужен 2+ уровень медиа!");
    
    new search[24];
    if(sscanf(params, "s[24]", search))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mfind [ник]");
    
    SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFD700}=== ПОИСК МЕДИА ===");
    
    new found = 0;
    foreach(new i : Player)
    {
        if(GetPlayerYouTubeEx(i) >= 1)
        {
            new name[MAX_PLAYER_NAME];
            GetPlayerName(i, name, sizeof(name));
            
            if(strfind(name, search, true) != -1)
            {
                new level_str[32];
                if(GetPlayerYouTubeEx(i) == 1) format(level_str, sizeof(level_str), "Медиа Партнёр");
                else if(GetPlayerYouTubeEx(i) == 2) format(level_str, sizeof(level_str), "Зам.ПР");
                else if(GetPlayerYouTubeEx(i) == 3) format(level_str, sizeof(level_str), "Пиар Менеджер");
                
                new msg[128];
                format(msg, sizeof(msg), "Медиа-админка: {FFFFFF}%s[%d] - %s", name, i, level_str);
                SendClientMessage(playerid, 0xC6E2FFFF, msg);
                found++;
            }
        }
    }
    
    if(found == 0)
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Медиа с таким ником не найден");
    
    return 1;
}

// ================ УРОВЕНЬ 3: ПИАР МЕНЕДЖЕР ================
CMD:mdemote(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 3) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Только Пиар Менеджер!");
    
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mdemote [id]");
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн!");
    
    if(GetPlayerYouTubeEx(targetid) == 0)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок не в медиа-команде!");
    
    new new_level = GetPlayerYouTubeEx(targetid) - 1;
    SetPlayerData(targetid, P_YOUTUBE, new_level);
    UpdatePlayerDatabaseInt(targetid, "youtube", new_level);
    
    SendClientMessage(playerid, 0xC6E2FFFF, 
        "Медиа-админка: {58D68D}Вы понизили %s[%d] до уровня %d",
        GetPlayerNameEx(targetid), targetid, new_level
    );
    
    if(new_level == 0)
        SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {F1948A}Вы исключены из медиа-команды!");
    else if(new_level == 1)
        SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {F1948A}Вы понижены до Медиа Партнёра!");
    
    return 1;
}

CMD:mpromote(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 3) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Только Пиар Менеджер!");
    
    new targetid;
    if(sscanf(params, "u", targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mpromote [id]");
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн!");
    
    if(GetPlayerYouTubeEx(targetid) == 0)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок не в медиа-команде!");
    
    if(GetPlayerYouTubeEx(targetid) >= 2)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок уже имеет 2 уровень!");
    
    SetPlayerData(targetid, P_YOUTUBE, 2);
    UpdatePlayerDatabaseInt(targetid, "youtube", 2);
    
    SendClientMessage(playerid, 0xC6E2FFFF, 
        "Медиа-админка: {58D68D}Вы повысили %s[%d] до Заместителя Пиар Менеджера!",
        GetPlayerNameEx(targetid), targetid
    );
    
    SendClientMessage(targetid, 0xC6E2FFFF, "Медиа-админка: {FFD700}Вы повышены до Заместителя Пиар Менеджера RACE RUSSIA!");
    
    return 1;
}

CMD:mkick(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 3) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Только Пиар Менеджер!");
    
    new targetid, reason[64];
    if(sscanf(params, "us[64]", targetid, reason))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mkick [id] [причина]");
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн!");
    
    if(GetPlayerYouTubeEx(targetid) == 0)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок не в медиа-команде!");
    
    SetPlayerData(targetid, P_YOUTUBE, 0);
    UpdatePlayerDatabaseInt(targetid, "youtube", 0);
    
    new str[256];
    format(str, sizeof(str), "Медиа-админка: {F1948A}Пиар Менеджер исключил %s[%d] из медиа-команды. Причина: %s",
        GetPlayerNameEx(targetid), targetid, reason);
    
    foreach(new i : Player)
    {
        if(GetPlayerYouTubeEx(i) >= 2)
            SendClientMessage(i, 0xC6E2FFFF, str);
    }
    
    format(str, sizeof(str), "Медиа-админка: {F1948A}Вы исключены из медиа-команды Пиар Менеджером. Причина: %s", reason);
    SendClientMessage(targetid, 0xC6E2FFFF, str);
    
    return 1;
}

CMD:mwarn(playerid, params[])
{
    if(GetPlayerYouTubeEx(playerid) < 3) 
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Только Пиар Менеджер!");
    
    new targetid, reason[64];
    if(sscanf(params, "us[64]", targetid, reason))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FFFFFF}/mwarn [id] [причина]");
    
    if(!IsPlayerConnected(targetid))
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок оффлайн!");
    
    if(GetPlayerYouTubeEx(targetid) == 0)
        return SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {FF6B6B}Игрок не в медиа-команде!");
    
    new str[256];
    format(str, sizeof(str), "Медиа-админка: {F1948A}Пиар Менеджер выдал предупреждение %s[%d]. Причина: %s",
        GetPlayerNameEx(targetid), targetid, reason);
    
    foreach(new i : Player)
    {
        if(GetPlayerYouTubeEx(i) >= 2)
            SendClientMessage(i, 0xC6E2FFFF, str);
    }
    
    format(str, sizeof(str), "Медиа-админка: {F1948A}Вы получили предупреждение от Пиар Менеджера. Причина: %s", reason);
    SendClientMessage(targetid, 0xC6E2FFFF, str);
    
    return 1;
}

// ================ ФУНКЦИИ ================
forward RemoveMediaMute(playerid);
public RemoveMediaMute(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        pMediaMuted[playerid] = false;
        SendClientMessage(playerid, 0xC6E2FFFF, "Медиа-админка: {58D68D}Ваш мут в медиа-чате окончен!");
    }
}

stock StartSpectateY(playerid, for_player)
{
    if(GetPlayerYouTubeEx(playerid) < 1) return 1;

    SetPlayerSpectateData(playerid, S_PLAYER, for_player);
    SetPlayerInterior(playerid, GetPlayerInterior(for_player));
    SetPlayerVirtualWorld(playerid, GetPlayerVirtualWorld(for_player));
    TogglePlayerSpectating(playerid, true);

    if(IsPlayerInAnyVehicle(for_player))
        PlayerSpectateVehicle(playerid, GetPlayerVehicleID(for_player));
    else 
        PlayerSpectatePlayer(playerid, for_player);

    return 1;
}


и диалог команды /mhelp 

    if(dialogid == 15500) 
    {
        return 1;
    }
    