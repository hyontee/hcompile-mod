// =============================================
// СИСТЕМА ПОГОНИ v1.0
// Для SA-MP / Open.MP
// ВСТАВЛЯТЬ КАК FILTERSCRIPT ИЛИ В GM
// =============================================

#include <a_samp>
#include <zcmd>
#include <sscanf2>

// =============================================
// НАСТРОЙКИ (меняйте под себя)
// =============================================

#define DIALOG_PURSUIT 5000   // ID диалога (смените если занят)
#define PURSUIT_COLOR 0xFFFF00AA

// Скины полиции (ФСБ, УМВД)
#define SKIN_FSB 285
#define SKIN_UMVD 286

// =============================================
// ПЕРЕМЕННЫЕ
// =============================================

new bool: g_PursuitActive[MAX_PLAYERS];
new g_PursuitTarget[MAX_PLAYERS];
new g_EMITimer[MAX_PLAYERS];
new bool: g_EMIActive[MAX_PLAYERS];

// =============================================
// ФУНКЦИИ
// =============================================

stock IsCop(playerid)
{
    new skin = GetPlayerSkin(playerid);
    if(skin == SKIN_FSB || skin == SKIN_UMVD) return 1;
    return 0;
}

stock StopPursuit(playerid)
{
    if(g_PursuitActive[playerid])
    {
        new target = g_PursuitTarget[playerid];
        if(IsPlayerConnected(target))
        {
            SetPlayerWantedLevel(target, 0);
        }
        g_PursuitActive[playerid] = false;
        g_PursuitTarget[playerid] = -1;
        SendClientMessage(playerid, 0xFFFFFFFF, "Погоня завершена.");
    }
}

forward DisableEMI(playerid);
public DisableEMI(playerid)
{
    if(IsPlayerConnected(playerid))
    {
        g_EMIActive[playerid] = false;
        new veh = GetPlayerVehicleID(playerid);
        if(veh)
        {
            SetVehicleParamsEx(veh, 1, 0, 0, 0, 0, 0, 0);
            SendClientMessage(playerid, 0xFFFF00AA, "Двигатель восстановлен после ЭМИ!");
        }
    }
    return 1;
}

// =============================================
// КОМАНДЫ
// =============================================

CMD:pt(playerid, params[])
{
    new targetid;
    if(sscanf(params, "u", targetid))
    {
        SendClientMessage(playerid, 0xFFFFFFFF, "Использование: /pt [ID игрока]");
        return 1;
    }
    
    if(!IsPlayerConnected(targetid))
    {
        SendClientMessage(playerid, 0xFF0000AA, "Игрок не найден!");
        return 1;
    }
    
    if(playerid == targetid)
    {
        SendClientMessage(playerid, 0xFF0000AA, "Нельзя начать погоню на себя!");
        return 1;
    }
    
    if(!IsCop(playerid))
    {
        SendClientMessage(playerid, 0xFF0000AA, "Доступно только для ФСБ и УМВД!");
        return 1;
    }
    
    if(!IsPlayerInAnyVehicle(playerid))
    {
        SendClientMessage(playerid, 0xFF0000AA, "Вы должны быть в транспорте!");
        return 1;
    }
    
    if(!IsPlayerInAnyVehicle(targetid))
    {
        SendClientMessage(playerid, 0xFF0000AA, "Преступник не в машине!");
        return 1;
    }
    
    if(g_PursuitActive[playerid])
    {
        SendClientMessage(playerid, 0xFF0000AA, "У вас уже активна погоня!");
        return 1;
    }
    
    // Запускаем погоню
    g_PursuitActive[playerid] = true;
    g_PursuitTarget[playerid] = targetid;
    
    new pName[24], tName[24];
    GetPlayerName(playerid, pName, 24);
    GetPlayerName(targetid, tName, 24);
    
    new string[128];
    format(string, 128, "[ПОГОНЯ] %s начал погоню за %s!", pName, tName);
    SendClientMessageToAll(PURSUIT_COLOR, string);
    
    SetPlayerWantedLevel(targetid, GetPlayerWantedLevel(targetid) + 1);
    return 1;
}

CMD:ptlist(playerid, params[])
{
    if(!g_PursuitActive[playerid])
    {
        SendClientMessage(playerid, 0xFF0000AA, "У вас нет активной погони!");
        return 1;
    }
    
    ShowPlayerDialog(playerid, DIALOG_PURSUIT, 1,
        "Спецсредства погони",
        "Шипы\nЭМИ-глушилка\nЗавершить погоню",
        "Выбрать", "Закрыть");
    return 1;
}

// =============================================
// ОБРАБОТЧИК ДИАЛОГА
// =============================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == DIALOG_PURSUIT && response)
    {
        if(!g_PursuitActive[playerid])
        {
            SendClientMessage(playerid, 0xFF0000AA, "Погоня уже завершена!");
            return 1;
        }
        
        new target = g_PursuitTarget[playerid];
        if(!IsPlayerConnected(target))
        {
            StopPursuit(playerid);
            SendClientMessage(playerid, 0xFF0000AA, "Преступник вышел из игры!");
            return 1;
        }
        
        new Float:x, Float:y, Float:z;
        GetPlayerPos(target, x, y, z);
        new veh = GetPlayerVehicleID(target);
        
        switch(listitem)
        {
            case 0: // Шипы
            {
                // Создаём шипы под машиной преступника
                CreateObject(2899, x, y, z-0.5, 0, 0, 0);
                
                // Пробиваем 4 колеса
                for(new i=0; i<4; i++)
                {
                    UpdateVehicleDamageStatus(veh, 0, 0, 0, (1<<i));
                }
                
                SendClientMessage(playerid, 0x33FF33AA, "Шипы успешно разложены!");
                SendClientMessage(target, 0xFF0000AA, "Ваши колёса пробиты!");
                return 1;
            }
            case 1: // ЭМИ
            {
                if(g_EMIActive[target])
                {
                    SendClientMessage(playerid, 0xFF0000AA, "ЭМИ уже активно на этой машине!");
                    return 1;
                }
                
                g_EMIActive[target] = true;
                SetVehicleParamsEx(veh, 0, 0, 0, 0, 0, 0, 0); // Глушим двигатель
                g_EMITimer[target] = SetTimerEx("DisableEMI", 60000, false, "i", target);
                
                SendClientMessage(playerid, 0x33FF33AA, "ЭМИ-импульс активирован!");
                SendClientMessage(target, 0xFF0000AA, "Двигатель заглушён на 60 секунд!");
                return 1;
            }
            case 2: // Завершить погоню
            {
                StopPursuit(playerid);
                SendClientMessage(playerid, 0xFFFFFFFF, "Вы завершили погоню.");
                return 1;
            }
        }
        return 1;
    }
    return 0; // Возвращаем 0 для других диалогов
}

// =============================================
// ОТМЕНА ПОГОНИ ПРИ ВЫХОДЕ ИЗ МАШИНЫ
// =============================================

public OnPlayerStateChange(playerid, newstate, oldstate)
{
    if(newstate == 1 && g_PursuitActive[playerid]) // 1 = PLAYER_STATE_ONFOOT
    {
        StopPursuit(playerid);
        SendClientMessage(playerid, 0xFF0000AA, "Погоня отменена (вы вышли из машины).");
        return 1;
    }
    return 1;
}

// =============================================
// ТОЧКА ВХОДА ДЛЯ FILTERSCRIPT
// =============================================

public OnFilterScriptInit()
{
    print("======================================");
    print("  Система погони загружена!           ");
    print("  Команды: /pt и /ptlist              ");
    print("======================================");
    return 1;
}

public OnFilterScriptExit()
{
    print("Система погони выгружена.");
    return 1;
}

// =============================================
// КОНЕЦ ФАЙЛА
// =============================================