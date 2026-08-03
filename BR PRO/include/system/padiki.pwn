#if defined _padiki_included
    #endinput
#endif
#define _padiki_included

#if !defined MAX_ENTRANCES
    #define MAX_ENTRANCES 100
#endif

#if !defined MAX_ZONES_NAME
    #define MAX_ZONES_NAME 32
#endif




//new g_entrance[MAX_ENTRANCES][E_ENTRANCE_STRUCT];
//new g_entrance_loaded = 0;
//new g_StaticExitPickup = -1;
//new g_StaticLiftPickup = -1;

forward LoadEntrances();
public LoadEntrances()
{
    printf("[PADIKI] Загрузка подъездов...");

    new Cache:result = mysql_query(mysql, "SELECT * FROM entrances ORDER BY id", true);
    new rows = cache_num_rows();

    if(rows == 0)
    {
        printf("[PADIKI] Подъезды не найдены.");
        cache_delete(result);
        CreateStaticEntrancePickups();
        return 1;
    }

    if(rows > MAX_ENTRANCES)
    {
        printf("[PADIKI] Внимание: подъездов в БД (%d) больше чем MAX_ENTRANCES (%d)!", rows, MAX_ENTRANCES);
        rows = MAX_ENTRANCES;
    }

    for(new idx = 0; idx < rows; idx++)
    {
        g_entrance[idx][E_SQL_ID] = cache_get_field_content_int(idx, "id");
        g_entrance[idx][E_FLOORS] = cache_get_field_content_int(idx, "floors");

        g_entrance[idx][E_POS_X] = cache_get_field_content_float(idx, "pos_x");
        g_entrance[idx][E_POS_Y] = cache_get_field_content_float(idx, "pos_y");
        g_entrance[idx][E_POS_Z] = cache_get_field_content_float(idx, "pos_z");

        g_entrance[idx][E_EXIT_POS_X] = cache_get_field_content_float(idx, "exit_x");
        g_entrance[idx][E_EXIT_POS_Y] = cache_get_field_content_float(idx, "exit_y");
        g_entrance[idx][E_EXIT_POS_Z] = cache_get_field_content_float(idx, "exit_z");
        g_entrance[idx][E_EXIT_ANGLE] = cache_get_field_content_float(idx, "exit_angle");

        g_entrance[idx][E_STATUS] = -1;
        g_entrance[idx][E_EXIT_PICKUP_ID] = -1;
        
        CreateEntrancePickup(idx);
        
        printf("[PADIKI] Загружен подъезд #%d (SQL ID: %d)", idx, g_entrance[idx][E_SQL_ID]);
    }

    g_entrance_loaded = rows;
    cache_delete(result);

    CreateStaticEntrancePickups();

    printf("[PADIKI] Загружено %d подъездов.", g_entrance_loaded);
    return 1;
}

stock CreateStaticEntrancePickups()
{
    // Пикап выхода из подъезда (общий)
    g_StaticExitPickup = CreateDynamicPickup(
        1318,
        1,
        558.4183, 22.0849, 1049.2656,
        .worldid = -1,
        .interiorid = 1,
        .streamdistance = 50.0
    );
    
    CreateDynamic3DTextLabel(
        "{FF0000}Выход",
        0xFFFFFFFF,
        558.4183, 22.0849, 1049.2656 + 0.5,
        10.0,
        .worldid = -1,
        .interiorid = 1,
        .streamdistance = 10.0
    );

    // Пикап лифта
    g_StaticLiftPickup = CreateDynamicPickup(
        1318,
        1,
        560.7483, 23.6653, 1049.2731,
        .worldid = -1,
        .interiorid = 1,
        .streamdistance = 50.0
    );
    
    CreateDynamic3DTextLabel(
        "{3399FF}Лифт",
        0xFFFFFFFF,
        560.7483, 23.6653, 1049.2731 + 0.5,
        10.0,
        .worldid = -1,
        .interiorid = 1,
        .streamdistance = 10.0
    );
    
    return 1;
}

stock CreateEntrancePickup(entranceid)
{
    if(entranceid < 0 || entranceid >= MAX_ENTRANCES) return 0;

    new Float:x = g_entrance[entranceid][E_POS_X];
    new Float:y = g_entrance[entranceid][E_POS_Y];
    new Float:z = g_entrance[entranceid][E_POS_Z];

    g_entrance[entranceid][E_PICKUP_ID] = CreateDynamicPickup(
        1273,
        23,
        x, y, z,
        .worldid = 0,
        .interiorid = 0,
        .streamdistance = 100.0
    );

    new label_text[64];
    format(label_text, sizeof(label_text), "{3399FF}Подъезд #%d\n{FFFFFF}Этажей: %d",
        entranceid + 1, g_entrance[entranceid][E_FLOORS]);

    g_entrance[entranceid][E_LABEL] = CreateDynamic3DTextLabel(
        label_text,
        0xFFFFFFFF,
        x, y, z + 0.5,
        15.0,
        .worldid = 0,
        .interiorid = 0,
        .streamdistance = 15.0
    );
    
    return 1;
}

stock CreateEntranceExitPickup(entranceid)
{
    if(entranceid < 0 || entranceid >= MAX_ENTRANCES) return -1;

    if(g_entrance[entranceid][E_EXIT_PICKUP_ID] != -1)
    {
        if(IsValidDynamicPickup(g_entrance[entranceid][E_EXIT_PICKUP_ID]))
            DestroyDynamicPickup(g_entrance[entranceid][E_EXIT_PICKUP_ID]);

        if(IsValidDynamic3DTextLabel(g_entrance[entranceid][E_EXIT_LABEL]))
            DestroyDynamic3DTextLabel(g_entrance[entranceid][E_EXIT_LABEL]);
    }

    g_entrance[entranceid][E_EXIT_PICKUP_ID] = CreateDynamicPickup(
        1318,
        23,
        558.4183, 22.0849, 1049.2656,
        .worldid = 0,
        .interiorid = 1,
        .streamdistance = 50.0
    );

    g_entrance[entranceid][E_EXIT_LABEL] = CreateDynamic3DTextLabel(
        "{FF0000}Выход",
        0xFFFFFFFF,
        558.4183, 22.0849, 1049.2656 + 0.5,
        10.0,
        .worldid = 0,
        .interiorid = 1,
        .streamdistance = 10.0
    );

    return g_entrance[entranceid][E_EXIT_PICKUP_ID];
}

stock EnterPlayerToEntrance(playerid, entranceid)
{
    if(entranceid < 0 || entranceid >= g_entrance_loaded)
    {
        printf("[PADIKI] Ошибка: неверный ID подъезда %d", entranceid);
        return 0;
    }

    if(g_entrance[entranceid][E_EXIT_PICKUP_ID] == -1)
        CreateEntranceExitPickup(entranceid);

    SetPlayerPos(playerid, 558.4183, 22.0849, 1049.2656);
    SetPlayerFacingAngle(playerid, 357.8067);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, 0);
    SetPVarInt(playerid, "in_entrance", entranceid);

    return 1;
}

stock ExitPlayerFromEntrance(playerid)
{
    new entranceid = GetPVarInt(playerid, "in_entrance");
    if(entranceid == -1) return 0;

    new Float:x = g_entrance[entranceid][E_EXIT_POS_X];
    new Float:y = g_entrance[entranceid][E_EXIT_POS_Y];
    new Float:z = g_entrance[entranceid][E_EXIT_POS_Z];
    new Float:angle = g_entrance[entranceid][E_EXIT_ANGLE];

    SetPlayerPos(playerid, x, y, z);
    SetPlayerFacingAngle(playerid, angle);
    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    DeletePVar(playerid, "in_entrance");

    return 1;
}

stock ExitPlayerFromHouseToEntrance(playerid)
{
    new houseid = GetPlayerInHouse(playerid);
    if(houseid == -1) return 0;

    new entranceid = g_house[houseid][H_ENTRACE];
    new flat_id = g_house[houseid][H_FLAT_ID];
    new floor = (flat_id - 1) / 4;
    
    new Float:entrance_x = 558.4183;
    new Float:entrance_y = 22.0849;
    new Float:entrance_z = 1049.2656;

    if(floor > 0)
        entrance_z = 1049.2656 + (floor * 3.0);

    SetPlayerPos(playerid, entrance_x, entrance_y, entrance_z);
    SetPlayerFacingAngle(playerid, 357.8067);
    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInHouse(playerid, -1);
    SetPVarInt(playerid, "in_entrance", entranceid);
    SetPVarInt(playerid, "entrance_floor", floor);

    if(g_entrance[entranceid][E_EXIT_PICKUP_ID] == -1)
        CreateEntranceExitPickup(entranceid);

    return 1;
}


stock Padiki_OnPickup(playerid, pickupid)
{
    // Проверяем входы в подъезды
    for(new i = 0; i < g_entrance_loaded; i++)
    {
        if(pickupid == g_entrance[i][E_PICKUP_ID])
        {
            EnterPlayerToEntrance(playerid, i);
            return 1;
        }
    }

    // Проверяем выход из подъезда
    if(GetPVarInt(playerid, "in_entrance") != -1)
    {
        if(pickupid == g_StaticExitPickup)
        {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, 558.4183, 22.0849, 1049.2656) && GetPlayerInterior(playerid) == 1)
            {
                ExitPlayerFromEntrance(playerid);
                return 1;
            }
        }
    }

    return 0;
}

CMD:addpadik(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, COLOR_RED, "Недостаточно прав.");

    if(g_entrance_loaded >= MAX_ENTRANCES)
        return SendClientMessage(playerid, COLOR_RED, "Достигнут лимит подъездов.");

    new idx = g_entrance_loaded;
    new Float:x, Float:y, Float:z, Float:angle;
    new query[512], message[144];

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);

    new Float:exit_x = x + 2.0 * floatsin(-angle, degrees);
    new Float:exit_y = y + 2.0 * floatcos(-angle, degrees);
    new Float:exit_z = z;

    g_entrance[idx][E_POS_X] = x;
    g_entrance[idx][E_POS_Y] = y;
    g_entrance[idx][E_POS_Z] = z;
    g_entrance[idx][E_FLOORS] = 2;
    g_entrance[idx][E_EXIT_POS_X] = exit_x;
    g_entrance[idx][E_EXIT_POS_Y] = exit_y;
    g_entrance[idx][E_EXIT_POS_Z] = exit_z;
    g_entrance[idx][E_EXIT_ANGLE] = angle;
    g_entrance[idx][E_STATUS] = -1;
    g_entrance[idx][E_EXIT_PICKUP_ID] = -1;

    format(query, sizeof(query),
        "INSERT INTO entrances (floors, pos_x, pos_y, pos_z, exit_x, exit_y, exit_z, exit_angle) VALUES (%d, %f, %f, %f, %f, %f, %f, %f)",
        g_entrance[idx][E_FLOORS], x, y, z, exit_x, exit_y, exit_z, angle);

    new Cache:result = mysql_query(mysql, query, true);
    if(!result || cache_affected_rows() == 0)
    {
        SendClientMessage(playerid, COLOR_RED, "Ошибка при добавлении в БД.");
        if(result) cache_delete(result);
        return 1;
    }

    g_entrance[idx][E_SQL_ID] = cache_insert_id();
    cache_delete(result);

    CreateEntrancePickup(idx);
    g_entrance_loaded++;

    format(message, sizeof(message), "Подъезд #%d создан (SQL ID: %d)", idx + 1, g_entrance[idx][E_SQL_ID]);
    SendClientMessage(playerid, 0x3399FFFF, message);
    SendClientMessage(playerid, 0xFFFF00FF, "Используйте /esetexitpos для изменения позиции выхода.");

    return 1;
}
CMD:addkvart(playerid, params[])
{
    if (GetPlayerAdminEx(playerid) < 9) return 1;

    new Cache: result;
    new fmt_text[300];
    new type = 2;       // Тип дома
    new price = 450000; // Стоимость дома
    new rent_price = 1000; // Цена аренды
    
/*
new house_coords[4][3] = {
    {567.2014, 25.2727, 1049.2656},
    {565.1951, 26.6265, 1049.2656},
    {554.5970, 26.6261, 1049.2656},
    {553.0098, 25.2907, 1049.2656}
};
*/

    for (new worldId = 0; worldId < 300; worldId++)
    {

            new house_idx = g_house_loaded; // Индекс нового дома

            // Установка позиции дома
            g_house[house_idx][H_POS_X] = 567.2014;
            g_house[house_idx][H_POS_Y] = 25.2727;
            g_house[house_idx][H_POS_Z] = 1049.2656;

            // Установка данных о доме
            SetHouseData(house_idx, H_VIRTUALWORLD, worldId);
            SetHouseData(house_idx, H_PRICE, price);
            SetHouseData(house_idx, H_RENT_PRICE, rent_price);
            SetHouseData(house_idx, H_TYPE, type);

            // Вставка данных в бд
            format(fmt_text, sizeof(fmt_text),
                "INSERT INTO houses (type, price, rent_price, x, y, z, hvortm) \
                 VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%d')",
                type, price, rent_price,
                g_house[house_idx][H_POS_X],
                g_house[house_idx][H_POS_Y],
                g_house[house_idx][H_POS_Z],
                worldId
            );

            result = mysql_query(mysql, fmt_text, true);
            SetHouseData(house_idx, H_SQL_ID, cache_insert_id());
            cache_delete(result);

            g_house_loaded++; // Увеличение счетчика домов

            // Обновляем координаты выхода
            g_house[house_idx][H_EXIT_POS_X] = 567.2014;
            g_house[house_idx][H_EXIT_POS_Y] = 25.2727;
            g_house[house_idx][H_EXIT_POS_Z] = 1049.2656;
            g_house[house_idx][H_EXIT_ANGLE] = 360;

            // Обновляем данные о выходе в базе данных
            format(fmt_text, sizeof(fmt_text),
                "UPDATE houses SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
                g_house[house_idx][H_EXIT_POS_X],
                g_house[house_idx][H_EXIT_POS_Y],
                g_house[house_idx][H_EXIT_POS_Z],
                g_house[house_idx][H_EXIT_ANGLE],
                g_house[house_idx][H_SQL_ID]
            );
            mysql_query(mysql, fmt_text, true);
        //{565.1951, 26.6265, 1049.2656},
        house_idx = g_house_loaded; // Индекс нового дома

            // Установка позиции дома
            g_house[house_idx][H_POS_X] = 565.1951;
            g_house[house_idx][H_POS_Y] = 26.6265;
            g_house[house_idx][H_POS_Z] = 1049.2656;

            // Установка данных о доме
            SetHouseData(house_idx, H_VIRTUALWORLD, worldId);
            SetHouseData(house_idx, H_PRICE, price);
            SetHouseData(house_idx, H_RENT_PRICE, rent_price);
            SetHouseData(house_idx, H_TYPE, type);

            // Вставка данных в бд
            format(fmt_text, sizeof(fmt_text),
                "INSERT INTO houses (type, price, rent_price, x, y, z, hvortm) \
                 VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%d')",
                type, price, rent_price,
                g_house[house_idx][H_POS_X],
                g_house[house_idx][H_POS_Y],
                g_house[house_idx][H_POS_Z],
                worldId
            );

            result = mysql_query(mysql, fmt_text, true);
            SetHouseData(house_idx, H_SQL_ID, cache_insert_id());
            cache_delete(result);

            g_house_loaded++; // Увеличение счетчика домов

            // Обновляем координаты выхода
            g_house[house_idx][H_EXIT_POS_X] = 565.1951;
            g_house[house_idx][H_EXIT_POS_Y] = 26.6265;
            g_house[house_idx][H_EXIT_POS_Z] = 1049.2656;
            g_house[house_idx][H_EXIT_ANGLE] = 360;

            // Обновляем данные о выходе в базе данных
            format(fmt_text, sizeof(fmt_text),
                "UPDATE houses SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
                g_house[house_idx][H_EXIT_POS_X],
                g_house[house_idx][H_EXIT_POS_Y],
                g_house[house_idx][H_EXIT_POS_Z],
                g_house[house_idx][H_EXIT_ANGLE],
                g_house[house_idx][H_SQL_ID]
            );
            mysql_query(mysql, fmt_text, true);
            //{554.5970, 26.6261, 1049.2656},
             house_idx = g_house_loaded; // Индекс нового дома

            // Установка позиции дома
            g_house[house_idx][H_POS_X] = 554.5970;
            g_house[house_idx][H_POS_Y] = 26.6261;
            g_house[house_idx][H_POS_Z] = 1049.2656;

            // Установка данных о доме
            SetHouseData(house_idx, H_VIRTUALWORLD, worldId);
            SetHouseData(house_idx, H_PRICE, price);
            SetHouseData(house_idx, H_RENT_PRICE, rent_price);
            SetHouseData(house_idx, H_TYPE, type);

            // Вставка данных в бд
            format(fmt_text, sizeof(fmt_text),
                "INSERT INTO houses (type, price, rent_price, x, y, z, hvortm) \
                 VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%d')",
                type, price, rent_price,
                g_house[house_idx][H_POS_X],
                g_house[house_idx][H_POS_Y],
                g_house[house_idx][H_POS_Z],
                worldId
            );

            result = mysql_query(mysql, fmt_text, true);
            SetHouseData(house_idx, H_SQL_ID, cache_insert_id());
            cache_delete(result);

            g_house_loaded++; // Увеличение счетчика домов

            // Обновляем координаты выхода
            g_house[house_idx][H_EXIT_POS_X] = 554.5970;
            g_house[house_idx][H_EXIT_POS_Y] = 26.6261;
            g_house[house_idx][H_EXIT_POS_Z] = 1049.2656;
            g_house[house_idx][H_EXIT_ANGLE] = 360;

            // Обновляем данные о выходе в базе данных
            format(fmt_text, sizeof(fmt_text),
                "UPDATE houses SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
                g_house[house_idx][H_EXIT_POS_X],
                g_house[house_idx][H_EXIT_POS_Y],
                g_house[house_idx][H_EXIT_POS_Z],
                g_house[house_idx][H_EXIT_ANGLE],
                g_house[house_idx][H_SQL_ID]
            );
            mysql_query(mysql, fmt_text, true);
         //   {553.0098, 25.2907, 1049.2656}
         house_idx = g_house_loaded; // Индекс нового дома

            // Установка позиции дома
            g_house[house_idx][H_POS_X] = 553.0098;
            g_house[house_idx][H_POS_Y] = 25.2907;
            g_house[house_idx][H_POS_Z] = 1049.2656;

            // Установка данных о доме
            SetHouseData(house_idx, H_VIRTUALWORLD, worldId);
            SetHouseData(house_idx, H_PRICE, price);
            SetHouseData(house_idx, H_RENT_PRICE, rent_price);
            SetHouseData(house_idx, H_TYPE, type);

            // Вставка данных в бд
            format(fmt_text, sizeof(fmt_text),
                "INSERT INTO houses (type, price, rent_price, x, y, z, hvortm) \
                 VALUES ('%d', '%d', '%d', '%f', '%f', '%f', '%d')",
                type, price, rent_price,
                g_house[house_idx][H_POS_X],
                g_house[house_idx][H_POS_Y],
                g_house[house_idx][H_POS_Z],
                worldId
            );

            result = mysql_query(mysql, fmt_text, true);
            SetHouseData(house_idx, H_SQL_ID, cache_insert_id());
            cache_delete(result);

            g_house_loaded++; // Увеличение счетчика домов

            // Обновляем координаты выхода
            g_house[house_idx][H_EXIT_POS_X] = 553.0098;
            g_house[house_idx][H_EXIT_POS_Y] = 25.2907;
            g_house[house_idx][H_EXIT_POS_Z] = 1049.2656;
            g_house[house_idx][H_EXIT_ANGLE] = 360;

            // Обновляем данные о выходе в базе данных
            format(fmt_text, sizeof(fmt_text),
                "UPDATE houses SET exit_x='%f', exit_y='%f', exit_z='%f', exit_angle='%f' WHERE id=%d",
                g_house[house_idx][H_EXIT_POS_X],
                g_house[house_idx][H_EXIT_POS_Y],
                g_house[house_idx][H_EXIT_POS_Z],
                g_house[house_idx][H_EXIT_ANGLE],
                g_house[house_idx][H_SQL_ID]
            );
            mysql_query(mysql, fmt_text, true);
    }
    return 1;
}

CMD:exitpadik(playerid, params[])
{
    if(GetPVarInt(playerid, "in_entrance") != -1)
    {
        ExitPlayerFromEntrance(playerid);
        return 1;
    }
    SendClientMessage(playerid, COLOR_RED, "Вы не в подъезде.");
    return 1;
}

CMD:exithome(playerid, params[])
{
    if(GetPlayerInHouse(playerid) != -1)
    {
        ExitPlayerFromHouseToEntrance(playerid);
        return 1;
    }
    
    if(GetPVarInt(playerid, "in_entrance") != -1)
    {
        ExitPlayerFromEntrance(playerid);
        return 1;
    }
    
    if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) != -1)
    {
        ExitPlayerFromHotelRoom(playerid);
        return 1;
    }
    
    SendClientMessage(playerid, 0xCECECEFF, "Вы не в помещении.");
    return 1;
}

CMD:esetexitpos(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8)
        return SendClientMessage(playerid, COLOR_RED, "Недостаточно прав.");

    new entranceid;
    if(sscanf(params, "d", entranceid))
        return SendClientMessage(playerid, COLOR_WHITE, "Использование: /esetexitpos [ID подъезда]");

    entranceid--; // Преобразуем в индекс массива

    if(entranceid < 0 || entranceid >= g_entrance_loaded)
        return SendClientMessage(playerid, COLOR_RED, "Неверный ID подъезда.");

    new Float:x, Float:y, Float:z, Float:angle;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, angle);

    g_entrance[entranceid][E_EXIT_POS_X] = x;
    g_entrance[entranceid][E_EXIT_POS_Y] = y;
    g_entrance[entranceid][E_EXIT_POS_Z] = z;
    g_entrance[entranceid][E_EXIT_ANGLE] = angle;

    new query[256];
    format(query, sizeof(query),
        "UPDATE entrances SET exit_x=%f, exit_y=%f, exit_z=%f, exit_angle=%f WHERE id=%d",
        x, y, z, angle, g_entrance[entranceid][E_SQL_ID]);
    mysql_tquery(mysql, query);

    new message[128];
    format(message, sizeof(message), "Позиция выхода подъезда #%d обновлена.", entranceid + 1);
    SendClientMessage(playerid, 0x3399FFFF, message);

    return 1;
}

CMD:deletepadik(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 9)
        return SendClientMessage(playerid, COLOR_RED, "Недостаточно прав.");

    new entranceid;
    if(sscanf(params, "d", entranceid))
        return SendClientMessage(playerid, COLOR_WHITE, "Использование: /deletepadik [ID подъезда]");

    entranceid--;

    if(entranceid < 0 || entranceid >= g_entrance_loaded)
        return SendClientMessage(playerid, COLOR_RED, "Неверный ID подъезда.");

    // Удаляем пикапы и лейблы
    if(IsValidDynamicPickup(g_entrance[entranceid][E_PICKUP_ID]))
        DestroyDynamicPickup(g_entrance[entranceid][E_PICKUP_ID]);

    if(IsValidDynamic3DTextLabel(g_entrance[entranceid][E_LABEL]))
        DestroyDynamic3DTextLabel(g_entrance[entranceid][E_LABEL]);

    if(g_entrance[entranceid][E_EXIT_PICKUP_ID] != -1)
    {
        if(IsValidDynamicPickup(g_entrance[entranceid][E_EXIT_PICKUP_ID]))
            DestroyDynamicPickup(g_entrance[entranceid][E_EXIT_PICKUP_ID]);

        if(IsValidDynamic3DTextLabel(g_entrance[entranceid][E_EXIT_LABEL]))
            DestroyDynamic3DTextLabel(g_entrance[entranceid][E_EXIT_LABEL]);
    }

    // Удаляем из БД
    new query[128];
    format(query, sizeof(query), "DELETE FROM entrances WHERE id=%d", g_entrance[entranceid][E_SQL_ID]);
    mysql_tquery(mysql, query);

    new message[64];
    format(message, sizeof(message), "Подъезд #%d удалён.", entranceid + 1);
    SendClientMessage(playerid, 0x3399FFFF, message);

    return 1;
}

/*
SQL для создания таблицы:

CREATE TABLE IF NOT EXISTS `entrances` (
    `id` INT AUTO_INCREMENT PRIMARY KEY,
    `floors` INT DEFAULT 2,
    `pos_x` FLOAT DEFAULT 0,
    `pos_y` FLOAT DEFAULT 0,
    `pos_z` FLOAT DEFAULT 0,
    `exit_x` FLOAT DEFAULT 0,
    `exit_y` FLOAT DEFAULT 0,
    `exit_z` FLOAT DEFAULT 0,
    `exit_angle` FLOAT DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
*/
