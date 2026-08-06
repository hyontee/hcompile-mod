#if defined _visual_editor_included
    #endinput
#endif
#define _visual_editor_included

#define MAX_VISUAL_OBJECTS 500

enum e_VisualObject
{
    obj_modelid,
    Float:obj_x,
    Float:obj_y,
    Float:obj_z,
    Float:obj_rx,
    Float:obj_ry,
    Float:obj_rz,
    obj_world,
    obj_interior,
    obj_streamid
}

static VisualObjects[MAX_VISUAL_OBJECTS][e_VisualObject];
static bool:obj_used[MAX_VISUAL_OBJECTS];
static PlayerTempObject[MAX_PLAYERS] = {-1, ...};
static PlayerSelectedObject[MAX_PLAYERS] = {-1, ...};
static PlayerTempEditObject[MAX_PLAYERS] = {INVALID_OBJECT_ID, ...};

stock CreateVisualObject(playerid, modelid, Float:x, Float:y, Float:z, 
                         Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0,
                         world = -1, interior = -1)
{
    new freeid = -1;
    
    for(new i = 0; i < MAX_VISUAL_OBJECTS; i++)
    {
        if(!obj_used[i])
        {
            freeid = i;
            break;
        }
    }
    
    if(freeid == -1) return -1;
    
    VisualObjects[freeid][obj_modelid] = modelid;
    VisualObjects[freeid][obj_x] = x;
    VisualObjects[freeid][obj_y] = y;
    VisualObjects[freeid][obj_z] = z;
    VisualObjects[freeid][obj_rx] = rx;
    VisualObjects[freeid][obj_ry] = ry;
    VisualObjects[freeid][obj_rz] = rz;
    VisualObjects[freeid][obj_world] = world;
    VisualObjects[freeid][obj_interior] = interior;
    
    VisualObjects[freeid][obj_streamid] = CreateDynamicObject(modelid, x, y, z, rx, ry, rz, world, interior, playerid, 300.0);
    obj_used[freeid] = true;
    
    return freeid;
}

// Удаление объекта
stock DeleteVisualObject(objectid)
{
    if(objectid < 0 || objectid >= MAX_VISUAL_OBJECTS || !obj_used[objectid]) return 0;
    
    DestroyDynamicObject(VisualObjects[objectid][obj_streamid]);
    obj_used[objectid] = false;
    
    return 1;
}

// Редактирование позиции
stock EditVisualObjectPosition(playerid, objectid)
{
    if(objectid < 0 || objectid >= MAX_VISUAL_OBJECTS || !obj_used[objectid]) return 0;
    
    PlayerTempObject[playerid] = objectid;
    
    new Float:x, Float:y, Float:z;
    GetDynamicObjectPos(VisualObjects[objectid][obj_streamid], x, y, z);
    
    // Создаем временный объект для редактирования
    new tmpobj = CreateObject(VisualObjects[objectid][obj_modelid], x, y, z, 0.0, 0.0, 0.0);
    PlayerTempEditObject[playerid] = tmpobj;
    EditObject(playerid, tmpobj);
    
    return 1;
}

// Редактирование поворота
stock EditVisualObjectRotation(playerid, objectid)
{
    if(objectid < 0 || objectid >= MAX_VISUAL_OBJECTS || !obj_used[objectid]) return 0;
    
    PlayerTempObject[playerid] = objectid;
    
    new Float:x, Float:y, Float:z;
    GetDynamicObjectPos(VisualObjects[objectid][obj_streamid], x, y, z);
    
    // Создаем временный объект для редактирования с текущим поворотом
    new tmpobj = CreateObject(VisualObjects[objectid][obj_modelid], x, y, z, 
                              VisualObjects[objectid][obj_rx],
                              VisualObjects[objectid][obj_ry],
                              VisualObjects[objectid][obj_rz]);
    PlayerTempEditObject[playerid] = tmpobj;
    EditObject(playerid, tmpobj);
    
    return 1;
}

// Диалог выбора объекта для редактирования
stock ShowEditObjectDialog(playerid)
{
    new dialog[1024], objlist[500], count;
    
    for(new i = 0; i < MAX_VISUAL_OBJECTS; i++)
    {
        if(obj_used[i])
        {
            format(objlist, sizeof(objlist), "%d - Model: %d (Pos: %.1f, %.1f, %.1f)\n", 
                   i, VisualObjects[i][obj_modelid],
                   VisualObjects[i][obj_x], VisualObjects[i][obj_y], VisualObjects[i][obj_z]);
            strcat(dialog, objlist);
            count++;
        }
    }
    
    if(count == 0)
    {
        SendClientMessage(playerid, 0xFF0000FF, "[ERROR] Нет объектов для редактирования!");
        return 0;
    }
    
    ShowPlayerDialog(playerid, 5001, DIALOG_STYLE_LIST, "Выберите объект для редактирования", dialog, "Выбрать", "Отмена");
    return 1;
}

// Команды
CMD:createobj(playerid, params[])
{
    new modelid, Float:x, Float:y, Float:z;
    
    if(sscanf(params, "dfff", modelid, x, y, z))
    {
        SendClientMessage(playerid, 0xFFFF00AA, "Использование: /createobj [modelid] [x] [y] [z]");
        return 1;
    }
    
    new objid = CreateVisualObject(playerid, modelid, x, y, z);
    
    if(objid != -1)
    {
        new msg[128];
        format(msg, sizeof(msg), "[INFO] Объект ID %d создан! Model: %d", objid, modelid);
        SendClientMessage(playerid, 0x00FF00AA, msg);
    }
    else
    {
        SendClientMessage(playerid, 0xFF0000AA, "[ERROR] Не удалось создать объект (лимит)");
    }
    
    return 1;
}

CMD:editobj(playerid, params[])
{
    new objectid;
    
    if(sscanf(params, "d", objectid))
    {
        ShowEditObjectDialog(playerid);
        return 1;
    }
    
    if(objectid < 0 || objectid >= MAX_VISUAL_OBJECTS || !obj_used[objectid])
    {
        SendClientMessage(playerid, 0xFF0000AA, "[ERROR] Неверный ID объекта!");
        return 1;
    }
    
    PlayerSelectedObject[playerid] = objectid;
    ShowPlayerDialog(playerid, 5002, DIALOG_STYLE_MSGBOX, "Редактирование объекта", 
                     "Что вы хотите редактировать?", "Позицию", "Поворот");
    
    return 1;
}

CMD:delobj(playerid, params[])
{
    new objectid;
    
    if(sscanf(params, "d", objectid))
    {
        SendClientMessage(playerid, 0xFFFF00AA, "Использование: /delobj [objectid]");
        return 1;
    }
    
    if(objectid < 0 || objectid >= MAX_VISUAL_OBJECTS || !obj_used[objectid])
    {
        SendClientMessage(playerid, 0xFF0000AA, "[ERROR] Неверный ID объекта!");
        return 1;
    }
    
    DeleteVisualObject(objectid);
    
    new msg[128];
    format(msg, sizeof(msg), "[INFO] Объект ID %d удалён", objectid);
    SendClientMessage(playerid, 0x00FF00AA, msg);
    
    return 1;
}

CMD:objlist(playerid, params[])
{
    new msg[256], count;
    
    SendClientMessage(playerid, 0x00FFFFAA, "=== Список объектов ===");
    
    for(new i = 0; i < MAX_VISUAL_OBJECTS; i++)
    {
        if(obj_used[i])
        {
            format(msg, sizeof(msg), "ID: %d | Model: %d | Pos: %.1f, %.1f, %.1f", 
                   i, VisualObjects[i][obj_modelid],
                   VisualObjects[i][obj_x], VisualObjects[i][obj_y], VisualObjects[i][obj_z]);
            SendClientMessage(playerid, 0xFFFFFFFF, msg);
            count++;
        }
    }
    
    format(msg, sizeof(msg), "Всего объектов: %d", count);
    SendClientMessage(playerid, 0x00FFFFAA, msg);
    
    return 1;
}

// Обработка диалогов
public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    switch(dialogid)
    {
        case 5001: // Выбор объекта
        {
            if(response)
            {
                new objectid, count;
                
                for(new i = 0; i < MAX_VISUAL_OBJECTS; i++)
                {
                    if(obj_used[i])
                    {
                        if(count == listitem)
                        {
                            objectid = i;
                            break;
                        }
                        count++;
                    }
                }
                
                PlayerSelectedObject[playerid] = objectid;
                ShowPlayerDialog(playerid, 5002, DIALOG_STYLE_MSGBOX, "Редактирование объекта", 
                                 "Что вы хотите редактировать?", "Позицию", "Поворот");
            }
            return 1;
        }
        
        case 5002: // Выбор типа редактирования
        {
            if(response)
            {
                new objectid = PlayerSelectedObject[playerid];
                
                if(listitem == 0)
                {
                    EditVisualObjectPosition(playerid, objectid);
                    SendClientMessage(playerid, 0xFFFF00AA, "[INFO] Редактируйте позицию. Нажмите ESC для сохранения.");
                }
                else
                {
                    EditVisualObjectRotation(playerid, objectid);
                    SendClientMessage(playerid, 0xFFFF00AA, "[INFO] Редактируйте поворот. Нажмите ESC для сохранения.");
                }
            }
            return 1;
        }
    }
    
    #if defined vis_OnDialogResponse
        return vis_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 0;
    #endif
}

// Исправленный обработчик окончания редактирования
public OnPlayerEditObjectt(playerid, playerobject, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz)
{
    new visualid = PlayerTempObject[playerid];
    
    if(visualid != -1 && obj_used[visualid])
    {
        if(response == EDIT_RESPONSE_FINAL)
        {
            // Сохраняем изменения
            DestroyDynamicObject(VisualObjects[visualid][obj_streamid]);
            
            VisualObjects[visualid][obj_x] = x;
            VisualObjects[visualid][obj_y] = y;
            VisualObjects[visualid][obj_z] = z;
            VisualObjects[visualid][obj_rx] = rx;
            VisualObjects[visualid][obj_ry] = ry;
            VisualObjects[visualid][obj_rz] = rz;
            
            VisualObjects[visualid][obj_streamid] = CreateDynamicObject(
                VisualObjects[visualid][obj_modelid], x, y, z, rx, ry, rz,
                VisualObjects[visualid][obj_world],
                VisualObjects[visualid][obj_interior],
                playerid, 300.0);
            
            SendClientMessage(playerid, 0x00FF00AA, "[INFO] Объект сохранён!");
        }
        else if(response == EDIT_RESPONSE_CANCEL)
        {
            SendClientMessage(playerid, 0xFF0000AA, "[INFO] Редактирование отменено");
        }
        
        // Удаляем временный объект
        if(PlayerTempEditObject[playerid] != INVALID_OBJECT_ID)
        {
            DestroyObject(PlayerTempEditObject[playerid]);
            PlayerTempEditObject[playerid] = INVALID_OBJECT_ID;
        }
        
        PlayerTempObject[playerid] = -1;
    }
    
    #if defined vis_OnPlayerEditObjectt
        return vis_OnPlayerEditObjectt(playerid, playerobject, objectid, response, x, y, z, rx, ry, rz);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse vis_OnDialogResponse

#if defined _ALS_OnPlayerEditObjectt
    #undef OnPlayerEditObjectt
#else
    #define _ALS_OnPlayerEditObjectt
#endif
#define OnPlayerEditObjectt vis_OnPlayerEditObjectt

#if defined vis_OnDialogResponse
    forward vis_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif
#if defined vis_OnPlayerEditObjectt
    forward vis_OnPlayerEditObjectt(playerid, playerobject, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz);
#endif