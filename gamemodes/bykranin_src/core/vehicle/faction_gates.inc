// ============================================================================
// ФРАКЦИОННЫЕ ШЛАГБАУМЫ
// По аналогии с существующим шлагбаумом Воинской части (vorotamo1).
// Команды установки (на текущей позиции админа): /palkacb /palkamvd /palkafsb
// Команды удаления:                              /delpalkacb /delpalkamvd /delpalkafsb
// Команды настройки наклона (диалог):            /editpalkacb /editpalkamvd /editpalkafsb
// Открывается автоматически при входе в зону игроком нужной фракции,
// закрывается при выходе. Позиции и наклон сохраняются в БД (таблица
// faction_gates), переживают рестарт сервера.
// ============================================================================
#define FGATE_MODEL                 (1718)
#define FGATE_SPHERE_RADIUS         (5.0)
#define FGATE_MOVE_SPEED            (2.0)
#define FGATE_ADMIN_LEVEL           (8)
#define FGATE_TILT_STEP_SMALL       (5.0)
#define FGATE_TILT_STEP_BIG         (15.0)

#define DIALOG_FGATE_EDIT           (90310)

enum
{
    FGATE_CB = 0,
    FGATE_MVD,
    FGATE_FSB,
    FGATE_COUNT
};

new const fgate_db_key[FGATE_COUNT][8] = {"cb", "mvd", "fsb"};
new const fgate_display_name[FGATE_COUNT][40] = {"Центральная больница Арзамас", "УМВД", "ФСБ"};
new const fgate_team[FGATE_COUNT] = {TEAM_HOSPITAL, TEAM_PPS, TEAM_FBI};

new fgate_object[FGATE_COUNT] = {-1, -1, -1};
new fgate_sphere[FGATE_COUNT] = {-1, -1, -1};
new Text3D:fgate_label[FGATE_COUNT] = {Text3D:-1, Text3D:-1, Text3D:-1};
new Float:fgate_x[FGATE_COUNT];
new Float:fgate_y[FGATE_COUNT];
new Float:fgate_z[FGATE_COUNT];
new Float:fgate_a[FGATE_COUNT];
new Float:fgate_tilt[FGATE_COUNT] = {0.0, 0.0, 0.0};
new bool:fgate_exists[FGATE_COUNT] = {false, false, false};
new bool:fgate_open[FGATE_COUNT] = {false, false, false};

// Какой шлагбаум сейчас открыт у игрока в диалоге настройки (-1 = никакой)
new fgate_edit_target[MAX_PLAYERS] = {-1, ...};

stock FactionGate_Destroy(id)
{
    if(fgate_object[id] != -1) { DestroyObject(fgate_object[id]); fgate_object[id] = -1; }
    if(fgate_sphere[id] != -1) { DestroyDynamicArea(fgate_sphere[id]); fgate_sphere[id] = -1; }
    if(IsValidDynamic3DTextLabel(fgate_label[id])) { DestroyDynamic3DTextLabel(fgate_label[id]); fgate_label[id] = Text3D:-1; }
    fgate_open[id] = false;
    return 1;
}

// Удаляет старый объект и создаёт новый на актуальных x/y/z/угол/наклон.
// Используется и при первой установке, и при любой правке (позиция/наклон).
stock FactionGate_Spawn(id)
{
    FactionGate_Destroy(id);
    fgate_object[id] = CreateObject(FGATE_MODEL, fgate_x[id], fgate_y[id], fgate_z[id], fgate_tilt[id], 0.0, fgate_a[id]);
    fgate_sphere[id] = CreateDynamicSphere(fgate_x[id], fgate_y[id], fgate_z[id], FGATE_SPHERE_RADIUS);
    new label_text[80];
    format(label_text, sizeof label_text, "{e81717}<<\t{ffffff}%s\t{e81717}>>", fgate_display_name[id]);
    fgate_label[id] = CreateDynamic3DTextLabel(label_text, 0xFFFF00FF, fgate_x[id], fgate_y[id], fgate_z[id] + 1.8, 10.0);
    fgate_open[id] = false;
    fgate_exists[id] = true;
    return 1;
}

stock FactionGate_Save(id)
{
    new query[300];
    mysql_format(mysql, query, sizeof query,
        "REPLACE INTO faction_gates (faction,x,y,z,angle,tilt) VALUES ('%s',%f,%f,%f,%f,%f)",
        fgate_db_key[id], fgate_x[id], fgate_y[id], fgate_z[id], fgate_a[id], fgate_tilt[id]);
    mysql_query(mysql, query, false);
    return 1;
}

stock FactionGate_Load()
{
    new Cache:result = mysql_query(mysql, "SELECT * FROM faction_gates", true);
    if(mysql_errno() != 0) { if(result) cache_delete(result); return 0; }
    new rows = cache_num_rows();
    for(new r = 0; r < rows; r++)
    {
        new faction[8];
        cache_get_field_content(r, "faction", faction, mysql, 8);
        for(new id = 0; id < FGATE_COUNT; id++)
        {
            if(!strcmp(faction, fgate_db_key[id]))
            {
                fgate_x[id] = cache_get_field_content_float(r, "x");
                fgate_y[id] = cache_get_field_content_float(r, "y");
                fgate_z[id] = cache_get_field_content_float(r, "z");
                fgate_a[id] = cache_get_field_content_float(r, "angle");
                fgate_tilt[id] = cache_get_field_content_float(r, "tilt");
                FactionGate_Spawn(id);
                break;
            }
        }
    }
    cache_delete(result);
    printf("[FGATE] loaded");
    return 1;
}

stock FactionGate_Init()
{
    new query[400];
    format(query, sizeof query,
        "CREATE TABLE IF NOT EXISTS `faction_gates` ("\
        "`faction` VARCHAR(8) NOT NULL,"\
        "`x` FLOAT NOT NULL DEFAULT 0,`y` FLOAT NOT NULL DEFAULT 0,`z` FLOAT NOT NULL DEFAULT 0,`angle` FLOAT NOT NULL DEFAULT 0,"\
        "`tilt` FLOAT NOT NULL DEFAULT 0,"\
        "PRIMARY KEY (`faction`)) ENGINE=InnoDB DEFAULT CHARSET=utf8");
    mysql_query(mysql, query, false);
    if(mysql_errno() != 0) return printf("[FGATE][ERROR] create table errno=%d", mysql_errno()), 0;

    // На случай, если таблица уже существовала до добавления наклона.
    mysql_query(mysql, "ALTER TABLE `faction_gates` ADD COLUMN IF NOT EXISTS `tilt` FLOAT NOT NULL DEFAULT 0", false);

    FactionGate_Load();
    return 1;
}

stock FactionGate_Add(playerid, id)
{
    if(GetPlayerAdminEx(playerid) < FGATE_ADMIN_LEVEL) return SendClientMessage(playerid, 0x999999FF, "У вас нет доступа к этой команде."), 1;
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    fgate_x[id] = x; fgate_y[id] = y; fgate_z[id] = z; fgate_a[id] = a;
    fgate_tilt[id] = 0.0;
    FactionGate_Spawn(id);
    FactionGate_Save(id);
    new msg[160];
    format(msg, sizeof msg, "Шлагбаум фракции \"%s\" установлен в текущей позиции. Настроить наклон: /editpalka%s", fgate_display_name[id], fgate_db_key[id]);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

stock FactionGate_Del(playerid, id)
{
    if(GetPlayerAdminEx(playerid) < FGATE_ADMIN_LEVEL) return SendClientMessage(playerid, 0x999999FF, "У вас нет доступа к этой команде."), 1;
    if(!fgate_exists[id]) return SendClientMessage(playerid, 0xCECECEFF, "Этот шлагбаум ещё не установлен."), 1;
    FactionGate_Destroy(id);
    fgate_exists[id] = false;
    fgate_tilt[id] = 0.0;
    new query[128];
    mysql_format(mysql, query, sizeof query, "DELETE FROM faction_gates WHERE faction='%s'", fgate_db_key[id]);
    mysql_query(mysql, query, false);
    new msg[128];
    format(msg, sizeof msg, "Шлагбаум фракции \"%s\" удалён.", fgate_display_name[id]);
    SendClientMessage(playerid, 0x66CC33FF, msg);
    return 1;
}

// ----------------------------------------------------------------------
// Диалог настройки: вращение вверх/вниз, переустановка позиции, сохранение
// ----------------------------------------------------------------------
stock FactionGate_OpenEditDialog(playerid, id)
{
    if(GetPlayerAdminEx(playerid) < FGATE_ADMIN_LEVEL) return SendClientMessage(playerid, 0x999999FF, "У вас нет доступа к этой команде."), 1;
    if(!fgate_exists[id])
    {
        new err[128];
        format(err, sizeof err, "Сначала установите шлагбаум командой /palka%s", fgate_db_key[id]);
        return SendClientMessage(playerid, 0xCECECEFF, err), 1;
    }

    fgate_edit_target[playerid] = id;

    new caption[80];
    format(caption, sizeof caption, "%s - наклон %.1f", fgate_display_name[id], fgate_tilt[id]);

    new info[300];
    format(info, sizeof info,
        "Повернуть вверх (+%.0f)\n"\
        "Повернуть вниз (-%.0f)\n"\
        "Крупный шаг вверх (+%.0f)\n"\
        "Крупный шаг вниз (-%.0f)\n"\
        "Переставить в текущую позицию\n"\
        "Сохранить и выйти",
        FGATE_TILT_STEP_SMALL, FGATE_TILT_STEP_SMALL, FGATE_TILT_STEP_BIG, FGATE_TILT_STEP_BIG);

    Dialog(playerid, DIALOG_FGATE_EDIT, DIALOG_STYLE_LIST, caption, info, "Выбрать", "Закрыть");
    return 1;
}

// Меняет наклон и сразу пересоздаёт объект (удалить -> заспавнить на новом месте)
stock FactionGate_AdjustTilt(playerid, id, Float:delta)
{
    fgate_tilt[id] += delta;
    if(fgate_tilt[id] >= 360.0) fgate_tilt[id] -= 360.0;
    if(fgate_tilt[id] <= -360.0) fgate_tilt[id] += 360.0;
    FactionGate_Spawn(id);
    FactionGate_Save(id);
    new msg[64];
    format(msg, sizeof msg, "Наклон шлагбаума: %.1f", fgate_tilt[id]);
    SendClientMessage(playerid, 0xFFFF00FF, msg);
    return 1;
}

// Переносит позицию/угол на текущее место админа, наклон не трогает.
stock FactionGate_Reposition(playerid, id)
{
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    fgate_x[id] = x; fgate_y[id] = y; fgate_z[id] = z; fgate_a[id] = a;
    FactionGate_Spawn(id);
    FactionGate_Save(id);
    SendClientMessage(playerid, 0xFFFF00FF, "Шлагбаум переставлен в текущую позицию.");
    return 1;
}

stock FactionGate_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    #pragma unused inputtext
    if(dialogid != DIALOG_FGATE_EDIT) return 0;

    new id = fgate_edit_target[playerid];

    if(!response)
    {
        fgate_edit_target[playerid] = -1;
        return 1;
    }

    if(id < 0 || id >= FGATE_COUNT || !fgate_exists[id])
    {
        SendClientMessage(playerid, 0xCECECEFF, "Этот шлагбаум больше не существует.");
        fgate_edit_target[playerid] = -1;
        return 1;
    }

    switch(listitem)
    {
        case 0: FactionGate_AdjustTilt(playerid, id, FGATE_TILT_STEP_SMALL);
        case 1: FactionGate_AdjustTilt(playerid, id, -FGATE_TILT_STEP_SMALL);
        case 2: FactionGate_AdjustTilt(playerid, id, FGATE_TILT_STEP_BIG);
        case 3: FactionGate_AdjustTilt(playerid, id, -FGATE_TILT_STEP_BIG);
        case 4: FactionGate_Reposition(playerid, id);
        case 5:
        {
            fgate_edit_target[playerid] = -1;
            SendClientMessage(playerid, 0x66CC33FF, "Настройка шлагбаума сохранена.");
            return 1;
        }
    }

    // После любого действия (кроме "сохранить и выйти") снова показываем диалог,
    // чтобы можно было крутить в несколько кликов подряд.
    // Показ нового диалога делаем с небольшой задержкой через таймер: если вызвать
    // ShowPlayerDialog повторно в тот же тик, что и ответ на предыдущий диалог,
    // клиент SA-MP иногда просто не открывает новое окно (диалог "молча" не появляется).
    SetTimerEx("FactionGate_ReshowDialog", 150, false, "ii", playerid, id);
    return 1;
}

forward FactionGate_ReshowDialog(playerid, id);
public FactionGate_ReshowDialog(playerid, id)
{
    if(!IsPlayerConnected(playerid)) return 1;
    if(fgate_edit_target[playerid] != id) return 1; // игрок уже закрыл диалог/сменил цель
    FactionGate_OpenEditDialog(playerid, id);
    return 1;
}

stock bool:FactionGate_OnEnterArea(playerid, areaid)
{
    for(new id = 0; id < FGATE_COUNT; id++)
    {
        if(fgate_exists[id] && areaid == fgate_sphere[id])
        {
            if(GetPlayerTeamEx(playerid) != fgate_team[id])
                return ShowNotificationNew(playerid, 2, 5, 1, 10, "Это не ваша фракция!", ""), true;
            if(!fgate_open[id])
            {
                MoveObject(fgate_object[id], fgate_x[id], fgate_y[id], fgate_z[id], FGATE_MOVE_SPEED, fgate_tilt[id] - 90.0, 0.0, fgate_a[id]);
                fgate_open[id] = true;
            }
            return true;
        }
    }
    return false;
}

stock bool:FactionGate_OnLeaveArea(playerid, areaid)
{
    #pragma unused playerid
    for(new id = 0; id < FGATE_COUNT; id++)
    {
        if(fgate_exists[id] && areaid == fgate_sphere[id])
        {
            if(fgate_open[id])
            {
                MoveObject(fgate_object[id], fgate_x[id], fgate_y[id], fgate_z[id], FGATE_MOVE_SPEED, fgate_tilt[id], 0.0, fgate_a[id]);
                fgate_open[id] = false;
            }
            return true;
        }
    }
    return false;
}

CMD:palkacb(playerid, params[])
{
    #pragma unused params
    return FactionGate_Add(playerid, FGATE_CB);
}

CMD:palkamvd(playerid, params[])
{
    #pragma unused params
    return FactionGate_Add(playerid, FGATE_MVD);
}

CMD:palkafsb(playerid, params[])
{
    #pragma unused params
    return FactionGate_Add(playerid, FGATE_FSB);
}

CMD:delpalkacb(playerid, params[])
{
    #pragma unused params
    return FactionGate_Del(playerid, FGATE_CB);
}

CMD:delpalkamvd(playerid, params[])
{
    #pragma unused params
    return FactionGate_Del(playerid, FGATE_MVD);
}

CMD:delpalkafsb(playerid, params[])
{
    #pragma unused params
    return FactionGate_Del(playerid, FGATE_FSB);
}

CMD:editpalkacb(playerid, params[])
{
    #pragma unused params
    return FactionGate_OpenEditDialog(playerid, FGATE_CB);
}

CMD:editpalkamvd(playerid, params[])
{
    #pragma unused params
    return FactionGate_OpenEditDialog(playerid, FGATE_MVD);
}

CMD:editpalkafsb(playerid, params[])
{
    #pragma unused params
    return FactionGate_OpenEditDialog(playerid, FGATE_FSB);
}
