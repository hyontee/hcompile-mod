// ==============================================
// NPC С АДМИНСКИМ СКИНОМ (122)
// ==============================================

#define ADMIN_SKIN 122 // Скин администратора
#define ADMIN_NPC_TYPE 4 // Новый тип NPC - администратор

enum NPC_DATA {
    npc_id,
    npc_type,
    Float:npc_x,
    Float:npc_y,
    Float:npc_z,
    Float:npc_a,
    npc_world,
    npc_interior,
    npc_skin,
    npc_vehicle,
    npc_dialog[128],
    npc_anim_lib[32],
    npc_anim_name[32],
    npc_title[32], // Новое поле: титул/имя NPC
    bool:npc_active
};

// В enum NPC_TYPE добавляем новый тип
#define NPC_TYPE_ADMIN 4

// Добавляем создание админ NPC в функцию инициализации
stock InitializeDefaultNPCs()
{
    // Существующие NPC...
    new vendor = CreateNPC(NPC_TYPE_VENDOR, 1654.3589, -1655.7562, 22.5156, 90.0, 0, 0, 55);
    SetNPCDialog(vendor, "Продавец авто: Нажмите Y для покупки транспорта.");
    SetNPCTitle(vendor, "Продавец авто");
    
    new guard = CreateNPC(NPC_TYPE_GUARD, 2319.4339, -1668.2239, 14.2252, 0.0, 0, 0, 71);
    SetNPCDialog(guard, "Охранник: Частная территория!");
    SetNPCTitle(guard, "Охранник");
    
    // Пешеходы
    CreateNPC(NPC_TYPE_PED, 1695.7751, -1619.5430, 13.5469, 270.0, 0, 0, 12);
    CreateNPC(NPC_TYPE_PED, 1720.1234, -1632.9876, 13.5469, 45.0, 0, 0, 20);
    
    // ================ НОВЫЙ АДМИН NPC ================
    new admin_npc = CreateAdminNPC(
        1777.790527,    // X
        2527.623535,    // Y
        14.661183,      // Z
        270.0,          // Угол поворота (смотрит на запад)
        0,              // Мир
        0,              // Интерьер
        ADMIN_SKIN,     // Скин администратора (122)
        "Главный Администратор", // Титул
        "Приветствую, администратор! Нажмите Y для доступа к админ-меню." // Диалог
    );
    
    // Добавляем анимацию для админ NPC
    if(admin_npc != INVALID_NPC_ID)
    {
        SetNPCAnimation(admin_npc, "DEALER", "DEALER_IDLE", 4.1, 1, 1, 1, 0, 0);
    }
    
    printf("[NPC] Инициализировано %d NPC", Iter_Count(NPCs));
    return 1;
}

// Создание админ NPC
stock CreateAdminNPC(Float:x, Float:y, Float:z, Float:a, world = 0, interior = 0, skin = ADMIN_SKIN, const title[] = "Администратор", const dialog[] = "")
{
    new idx = Iter_Free(NPCs);
    if(idx == -1) 
    {
        printf("[NPC Ошибка] Нельзя создать больше NPC (максимум: %d)", MAX_NPCS);
        return INVALID_NPC_ID;
    }
    
    // Заполняем данные
    g_NPC[idx][npc_id] = idx;
    g_NPC[idx][npc_type] = NPC_TYPE_ADMIN;
    g_NPC[idx][npc_x] = x;
    g_NPC[idx][npc_y] = y;
    g_NPC[idx][npc_z] = z;
    g_NPC[idx][npc_a] = a;
    g_NPC[idx][npc_world] = world;
    g_NPC[idx][npc_interior] = interior;
    g_NPC[idx][npc_skin] = skin;
    g_NPC[idx][npc_vehicle] = INVALID_VEHICLE_ID;
    g_NPC[idx][npc_active] = true;
    
    // Устанавливаем диалог
    if(strlen(dialog) > 0)
    {
        strmid(g_NPC[idx][npc_dialog], dialog, 0, strlen(dialog), 128);
    }
    else
    {
        format(g_NPC[idx][npc_dialog], 128, "Администратор: Добро пожаловать на сервер!");
    }
    
    // Устанавливаем титул
    strmid(g_NPC[idx][npc_title], title, 0, strlen(title), 32);
    
    // Создаем актера
    new actorid = CreateActor(skin, x, y, z, a);
    if(actorid != INVALID_ACTOR_ID)
    {
        printf("[Админ NPC] Создан административный NPC %d (актер: %d, скин: %d) в позиции: %f, %f, %f", 
            idx, actorid, skin, x, y, z);
        
        // Сохраняем ID актера в PVar для дальнейшего использования
        SetPVarInt(actorid, "NPC_ID", idx);
        SetPVarInt(idx, "ACTOR_ID", actorid);
        
        // Применяем анимацию по умолчанию
        ApplyActorAnimation(actorid, "DEALER", "DEALER_IDLE", 4.1, true, true, true, true, 0);
        
        // Устанавливаем виртуальный мир
        SetActorVirtualWorld(actorid, world);
    }
    else
    {
        printf("[Админ NPC Ошибка] Не удалось создать актера для NPC %d", idx);
    }
    
    Iter_Add(NPCs, idx);
    return idx;
}

// Функция установки титула NPC
stock SetNPCTitle(npcid, const title[])
{
    if(!IsValidNPC(npcid)) return 0;
    
    strmid(g_NPC[npcid][npc_title], title, 0, strlen(title), 32);
    return 1;
}

// Получение титула NPC
stock GetNPCTitle(npcid, title[], size = sizeof(title))
{
    if(!IsValidNPC(npcid)) return 0;
    
    strmid(title, g_NPC[npcid][npc_title], 0, strlen(g_NPC[npcid][npc_title]), size);
    return 1;
}

// Специальная функция для взаимодействия с админ NPC
stock PlayerInteractWithAdminNPC(playerid, npcid)
{
    if(!IsValidNPC(npcid)) return 0;
    if(g_NPC[npcid][npc_type] != NPC_TYPE_ADMIN) return 0;
    
    new title[32], dialog[128];
    GetNPCTitle(npcid, title, sizeof(title));
    GetNPCDialog(npcid, dialog, sizeof(dialog));
    
    // Проверяем права игрока
    new admin_level = GetPlayerAdminEx(playerid);
    
    if(admin_level > 0)
    {
        // Игрок - администратор
        SendClientMessage(playerid, 0x33AA33FF, "=================================");
        SendClientMessage(playerid, 0xFFFF00FF, sprintf("%s: Приветствую, коллега!", title));
        SendClientMessage(playerid, -1, dialog);
        SendClientMessage(playerid, 0x999999FF, "Доступные действия:");
        SendClientMessage(playerid, 0x999999FF, "/ahelp - Админ команды");
        SendClientMessage(playerid, 0x999999FF, "/agm - Бессмертие");
        SendClientMessage(playerid, 0x999999FF, "/gethere - Телепорт к себе");
        SendClientMessage(playerid, 0x33AA33FF, "=================================");
    }
    else
    {
        // Игрок не администратор
        SendClientMessage(playerid, 0xFF3333FF, "=================================");
        SendClientMessage(playerid, 0xFFFF00FF, sprintf("%s: У вас нет доступа к административным функциям.", title));
        SendClientMessage(playerid, 0x999999FF, "Для получения админ прав обратитесь к руководству.");
        SendClientMessage(playerid, 0x999999FF, "Обычные команды: /help, /report");
        SendClientMessage(playerid, 0xFF3333FF, "=================================");
    }
    
    // Визуальный эффект
    GameTextForPlayer(playerid, "~y~Администратор", 2000, 3);
    
    return 1;
}

// Получение диалога NPC
stock GetNPCDialog(npcid, dialog[], size = sizeof(dialog))
{
    if(!IsValidNPC(npcid)) return 0;
    
    strmid(dialog, g_NPC[npcid][npc_dialog], 0, strlen(g_NPC[npcid][npc_dialog]), size);
    return 1;
}

// Обновленная функция взаимодействия с NPC
stock PlayerInteractWithNPC(playerid, npcid)
{
    if(!IsValidNPC(npcid)) return 0;
    
    new npcname[32];
    switch(g_NPC[npcid][npc_type])
    {
        case NPC_TYPE_VENDOR:
        {
            format(npcname, sizeof(npcname), "Продавец");
            if(strlen(g_NPC[npcid][npc_dialog]) > 0)
            {
                SendClientMessage(playerid, -1, g_NPC[npcid][npc_dialog]);
            }
            else
            {
                SendClientMessage(playerid, -1, "Продавец: Чем могу помочь?");
            }
        }
        
        case NPC_TYPE_GUARD:
        {
            format(npcname, sizeof(npcname), "Страж");
            SendClientMessage(playerid, -1, "Страж: Проход запрещен!");
        }
        
        case NPC_TYPE_ADMIN: // Новый тип
        {
            PlayerInteractWithAdminNPC(playerid, npcid);
            format(npcname, sizeof(npcname), "Администратор");
        }
        
        default:
        {
            format(npcname, sizeof(npcname), "Горожанин");
            SendClientMessage(playerid, -1, "Горожанин: ...");
        }
    }
    
    printf("[NPC] Игрок %d взаимодействует с NPC %d (%s)", playerid, npcid, npcname);
    return 1;
}

// Функция для получения ID актера по ID NPC
stock GetActorIDFromNPC(npcid)
{
    if(!IsValidNPC(npcid)) return INVALID_ACTOR_ID;
    
    return GetPVarInt(npcid, "ACTOR_ID");
}

// Функция для получения ID NPC по ID актера
stock GetNPCIDFromActor(actorid)
{
    return GetPVarInt(actorid, "NPC_ID");
}

// Улучшенное уничтожение NPC
stock DestroyNPC(npcid)
{
    if(!IsValidNPC(npcid)) return 0;
    
    // Получаем ID актера
    new actorid = GetActorIDFromNPC(npcid);
    if(actorid != INVALID_ACTOR_ID)
    {
        DestroyActor(actorid);
        printf("[NPC] Удален актер %d для NPC %d", actorid, npcid);
    }
    
    // Очищаем PVar
    DeletePVar(npcid, "ACTOR_ID");
    
    g_NPC[npcid][npc_active] = false;
    Iter_Remove(NPCs, npcid);
    
    printf("[NPC] Удален NPC %d", npcid);
    return 1;
}

// Команда для админов: создать админ NPC
CMD:createadminnpc(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 5) // Только главные админы
        return SendClientMessage(playerid, 0xFF0000FF, "У вас нет доступа");
    
    new Float:x, Float:y, Float:z, Float:a, skin, title[32], dialog[128];
    
    if(sscanf(params, "fffdis[32]s[128]", x, y, z, a, skin, title, dialog))
    {
        // Используем координаты по умолчанию если не указаны
        x = 1777.790527;
        y = 2527.623535;
        z = 14.661183;
        a = 270.0;
        skin = ADMIN_SKIN;
        title = "Главный Администратор";
        dialog = "Приветствую! Нажмите Y для доступа к админ-меню.";
        
        SendClientMessage(playerid, 0xFFFF00FF, "Используются значения по умолчанию");
    }
    
    new npcid = CreateAdminNPC(x, y, z, a, 0, 0, skin, title, dialog);
    
    if(npcid != INVALID_NPC_ID)
    {
        new msg[256];
        format(msg, sizeof(msg), "Вы создали админ NPC ID: %d на координатах: X:%.2f Y:%.2f Z:%.2f", 
            npcid, x, y, z);
        SendClientMessage(playerid, 0x33AA33FF, msg);
        
        // Телепортируемся к NPC для проверки
        SetPlayerPos(playerid, x + 2.0, y, z);
        SetPlayerFacingAngle(playerid, a);
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "Не удалось создать NPC (достигнут лимит)");
    }
    
    return 1;
}

// Команда для удаления NPC
CMD:destroynpc(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 5)
        return SendClientMessage(playerid, 0xFF0000FF, "У вас нет доступа");
    
    new npcid;
    if(sscanf(params, "i", npcid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /destroynpc [id npc]");
    
    if(!IsValidNPC(npcid))
        return SendClientMessage(playerid, 0xFF0000FF, "Неверный ID NPC");
    
    if(DestroyNPC(npcid))
    {
        SendClientMessage(playerid, 0x33AA33FF, sprintf("NPC %d успешно удален", npcid));
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000FF, "Ошибка при удалении NPC");
    }
    
    return 1;
}

// Команда для просмотра всех NPC
CMD:npclist(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 1)
        return SendClientMessage(playerid, 0xFF0000FF, "У вас нет доступа");
    
    SendClientMessage(playerid, 0x33AA33FF, "=== Список NPC ===");
    
    new count = 0;
    foreach(new i : NPCs)
    {
        if(IsValidNPC(i))
        {
            new type_name[32];
            switch(g_NPC[i][npc_type])
            {
                case NPC_TYPE_PED: type_name = "Пешеход";
                case NPC_TYPE_VENDOR: type_name = "Продавец";
                case NPC_TYPE_GUARD: type_name = "Страж";
                case NPC_TYPE_ADMIN: type_name = "Администратор";
                default: type_name = "Неизвестно";
            }
            
            new msg[128];
            format(msg, sizeof(msg), "ID: %d | Тип: %s | Скин: %d | Позиция: %.1f, %.1f, %.1f", 
                i, type_name, g_NPC[i][npc_skin], 
                g_NPC[i][npc_x], g_NPC[i][npc_y], g_NPC[i][npc_z]);
            
            SendClientMessage(playerid, 0x999999FF, msg);
            count++;
        }
    }
    
    if(count == 0)
    {
        SendClientMessage(playerid, 0x999999FF, "Нет активных NPC");
    }
    else
    {
        SendClientMessage(playerid, 0x33AA33FF, sprintf("Всего NPC: %d", count));
    }
    
    return 1;
}

// Автоматическое создание админ NPC при старте сервера
public OnGameModeInit()
{
    // ... ваш существующий код ...
    
    // Инициализируем NPC
    InitializeDefaultNPCs();
    
    // Отдельно создаем админ NPC если нужно
    CreateAdminNPC(
        1777.790527, 
        2527.623535, 
        14.661183, 
        270.0, 
        0, 0, 
        ADMIN_SKIN, 
        "Главный Администратор", 
        "Добро пожаловать! Используйте /ahelp для списка админ-команд."
    );
    
    return 1;
}

// Вспомогательная функция sprintf (если нет)
#if !defined sprintf
    stock sprintf(const format[], {Float,_}:...)
    {
        new output[256], argument, arg_start, arg_end;
        strcat(output, format);
        
        for(new i = 0, j = strlen(format); i < j; i++)
        {
            if(format[i] == '%')
            {
                switch(format[i + 1])
                {
                    case 'd', 'i', 'f': 
                    {
                        #emit LOAD.S.pri 16
                        #emit ADD.C     0xFFFFFFFC
                        #emit STOR.S.pri 16
                        #emit LOAD.S.pri 16
                        #emit LOAD.I
                        #emit STOR.S.pri argument
                        
                        // Преобразуем число в строку
                        new temp[12];
                        valstr(temp, argument);
                        
                        // Заменяем %d на число
                        strdel(output, i, i + 2);
                        strins(output, temp, i);
                        
                        i += strlen(temp) - 1;
                        j = strlen(output);
                    }
                    case 's':
                    {
                        #emit LOAD.S.pri 16
                        #emit ADD.C     0xFFFFFFFC
                        #emit STOR.S.pri 16
                        #emit LOAD.S.pri 16
                        #emit LOAD.I
                        #emit STOR.S.pri argument
                        
                        strdel(output, i, i + 2);
                        strins(output, argument, i);
                        
                        i += strlen(argument) - 1;
                        j = strlen(output);
                    }
                }
            }
        }
        return output;
    }
#endif