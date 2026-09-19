/АВТОР  @pawnokoder
/АВТОР  @pawnokoder
/АВТОР  @pawnokoder
#define MAX_GARAGES 20
#define MAX_GARAGE_SLOTS 3
#define GARAGE_PRICE 50000

enum GarageInfo {
    gID,
    gOwner[24],
    gOwnerID,
    Float:gEnterX,
    Float:gEnterY,
    Float:gEnterZ,
    Float:gExitX,
    Float:gExitY,
    Float:gExitZ,
    gVehicle1,
    gVehicle2,
    gVehicle3,
    gLocked,
    gPrice,
    gForSale
};

new Garages[MAX_GARAGES][GarageInfo];
new PlayerGarage[MAX_PLAYERS] = {-1, ...};

// Координаты как на BR
new Float:GaragePositions[][9] = {
    // {enterX, enterY, enterZ, exitX, exitY, exitZ, цена, для продажи}
    {1968.67, -1190.93, 19.59, 1970.37, -1196.32, 20.10, 50000, 0},
    {1981.83, -1190.89, 19.59, 1980.13, -1196.35, 20.10, 50000, 0},
    {1995.06, -1190.95, 19.59, 1993.36, -1196.41, 20.10, 50000, 0},
    {2008.29, -1190.89, 19.59, 2006.59, -1196.35, 20.10, 50000, 0},
    {2021.52, -1190.95, 19.59, 2019.82, -1196.41, 20.10, 50000, 0},
    {2034.75, -1190.89, 19.59, 2033.05, -1196.35, 20.10, 50000, 0},
    {2047.98, -1190.95, 19.59, 2046.28, -1196.41, 20.10, 50000, 0},
    {2061.21, -1190.89, 19.59, 2059.51, -1196.35, 20.10, 50000, 0},
    
    // Доп гаражей
    {2156.85, -1190.93, 23.98, 2158.55, -1196.32, 24.49, 75000, 1},
    {2169.99, -1190.89, 23.98, 2168.29, -1196.35, 24.49, 75000, 1},
    {2183.22, -1190.95, 23.98, 2181.52, -1196.41, 24.49, 75000, 1},
    
    // Премиум гаражи
    {2232.11, -1261.78, 23.98, 2230.41, -1267.24, 24.49, 150000, 1},
    {2245.34, -1261.84, 23.98, 2243.64, -1267.30, 24.49, 150000, 1}
};

public OnGameModeInit() {
    // Создаем пикапы гаражей
    for(new i = 0; i < sizeof(GaragePositions); i++) {
        // Вход в гараж
        CreateDynamicPickup(1318, 1, 
            GaragePositions[i][0], 
            GaragePositions[i][1], 
            GaragePositions[i][2]
        );
        
        CreateDynamic3DTextLabel(
            Garages[i][gForSale] ? 
                "{FFFF00}Гараж на продажу\n{FFFFFF}/buygarage" : 
                "{00FF00}Гараж\n{FFFFFF}/garage",
            0xFFFFFFFF,
            GaragePositions[i][0],
            GaragePositions[i][1],
            GaragePositions[i][2] + 0.5,
            15.0
        );
        
        // Выход из гаража (внутри)
        CreateDynamicPickup(1314, 1,
            GaragePositions[i][3],
            GaragePositions[i][4],
            GaragePositions[i][5]
        );
        
        CreateDynamic3DTextLabel(
            "{FFFF00}Выход\n{FFFFFF}/exitgarage",
            0xFFFFFFFF,
            GaragePositions[i][3],
            GaragePositions[i][4],
            GaragePositions[i][5] + 0.5,
            5.0
        );
        
        // Инициализируем гараж
        Garages[i][gID] = i;
        Garages[i][gPrice] = floatround(GaragePositions[i][6]);
        Garages[i][gForSale] = floatround(GaragePositions[i][7]);
        Garages[i][gEnterX] = GaragePositions[i][0];
        Garages[i][gEnterY] = GaragePositions[i][1];
        Garages[i][gEnterZ] = GaragePositions[i][2];
        Garages[i][gExitX] = GaragePositions[i][3];
        Garages[i][gExitY] = GaragePositions[i][4];
        Garages[i][gExitZ] = GaragePositions[i][5];
        Garages[i][gVehicle1] = INVALID_VEHICLE_ID;
        Garages[i][gVehicle2] = INVALID_VEHICLE_ID;
        Garages[i][gVehicle3] = INVALID_VEHICLE_ID;
        Garages[i][gLocked] = 0;
    }
    
    printf("[GARAGES] Загружено %d гаражей", sizeof(GaragePositions));
    return 1;
}

CMD:garage(playerid) {
    new garageid = GetPlayerGarageID(playerid);
    
    if(garageid == -1) {
        SendClientMessage(playerid, 0xFF0000FF, "У вас нет гаража!");
        SendClientMessage(playerid, 0xFFFF00FF, "Используйте /buygarage чтобы купить свободный гараж");
        return 1;
    }
    
    ShowGarageMenu(playerid, garageid);
    return 1;
}

ShowGarageMenu(playerid, garageid) {
    new str[512];
    
    format(str, sizeof(str),
        "{FFD700}Гараж №%d{FFFFFF}\n\n"
        "Владелец: {00FF00}%s{FFFFFF}\n"
        "Состояние: %s\n\n"
        "Слот 1: %s\n"
        "Слот 2: %s\n"
        "Слот 3: %s\n\n"
        "{FFFF00}Выберите действие:",
        garageid + 1,
        Garages[garageid][gOwner],
        Garages[garageid][gLocked] ? "{FF0000}Закрыт" : "{00FF00}Открыт",
        GetVehicleInSlotInfo(garageid, 0),
        GetVehicleInSlotInfo(garageid, 1),
        GetVehicleInSlotInfo(garageid, 2)
    );
    
    ShowPlayerDialog(playerid, 1300, DIALOG_STYLE_LIST,
        "Управление гаражом",
        str,
        "Выбрать", "Закрыть"
    );
    
    SetPVarInt(playerid, "GarageID", garageid);
}

GetVehicleInSlotInfo(garageid, slot) {
    new vehicleid;
    switch(slot) {
        case 0: vehicleid = Garages[garageid][gVehicle1];
        case 1: vehicleid = Garages[garageid][gVehicle2];
        case 2: vehicleid = Garages[garageid][gVehicle3];
    }
    
    if(vehicleid == INVALID_VEHICLE_ID) {
        return "{AAAAAA}[Пусто]";
    }
    
    new model = GetVehicleModel(vehicleid);
    new name[32];
    GetVehicleName(model, name, sizeof(name));
    
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    
    new str[64];
    format(str, sizeof(str), "{00FF00}%s{FFFFFF} (HP: %.0f)", name, health);
    return str;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    new garageid = GetPVarInt(playerid, "GarageID");
    
    if(dialogid == 1300 && response) {
        switch(listitem) {
            case 0: { // Открыть/закрыть гараж
                Garages[garageid][gLocked] = !Garages[garageid][gLocked];
                
                if(Garages[garageid][gLocked]) {
                    SendClientMessage(playerid, 0xFF0000FF, "Гараж закрыт!");
                } else {
                    SendClientMessage(playerid, 0x00FF00FF, "Гараж открыт!");
                }
                
                SaveGarage(garageid);
                ShowGarageMenu(playerid, garageid);
            }
            
            case 1: { // Поставить машину
                if(!IsPlayerInAnyVehicle(playerid)) {
                    SendClientMessage(playerid, 0xFF0000FF, "Вы должны быть в машине!");
                    ShowGarageMenu(playerid, garageid);
                    return 1;
                }
                
                new vehicleid = GetPlayerVehicleID(playerid);
                PutVehicleToGarage(playerid, garageid, vehicleid);
                ShowGarageMenu(playerid, garageid);
            }
            
            case 2: { // Взять машину
                ShowGarageVehicles(playerid, garageid);
            }
            
            case 3: { // Продать гараж
                ShowSellGarageDialog(playerid, garageid);
            }
            
            case 4: { // Информация
                ShowGarageInfo(playerid, garageid);
            }
        }
        return 1;
    }
    
    if(dialogid == 1301 && response) {
        TakeVehicleFromGarage(playerid, garageid, listitem);
        return 1;
    }
    
    if(dialogid == 1302 && response) {
        if(GetPlayerMoney(playerid) < Garages[garageid][gPrice]) {
            SendClientMessage(playerid, 0xFF0000FF, "Недостаточно денег!");
            return 1;
        }
        
        GivePlayerMoney(playerid, -Garages[garageid][gPrice]);
        
        new name[MAX_PLAYER_NAME];
        GetPlayerName(playerid, name, sizeof(name));
        
        format(Garages[garageid][gOwner], 24, name);
        Garages[garageid][gOwnerID] = GetPlayerAccountID(playerid);
        Garages[garageid][gForSale] = 0;
        
        PlayerGarage[playerid] = garageid;
        
        new str[128];
        format(str, sizeof(str), "Вы купили гараж №%d за $%d!", garageid + 1, Garages[garageid][gPrice]);
        SendClientMessage(playerid, 0x00FF00FF, str);
        
        SaveGarage(garageid);
        return 1;
    }
    
    if(dialogid == 1303 && response) {
        SellGarage(playerid, garageid);
        return 1;
    }
    return 0;
}

PutVehicleToGarage(playerid, garageid, vehicleid) {
    new freeSlot = -1;
    
    if(Garages[garageid][gVehicle1] == INVALID_VEHICLE_ID) freeSlot = 0;
    else if(Garages[garageid][gVehicle2] == INVALID_VEHICLE_ID) freeSlot = 1;
    else if(Garages[garageid][gVehicle3] == INVALID_VEHICLE_ID) freeSlot = 2;
    
    if(freeSlot == -1) {
        SendClientMessage(playerid, 0xFF0000FF, "Гараж полон!");
        return 0;
    }
    
    // Сохраняем данные машины
    new Float:x, Float:y, Float:z, Float:a;
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);
    
    new color1, color2;
    GetVehicleColor(vehicleid, color1, color2);
    
    new panels, doors, lights, tires;
    GetVehicleDamageStatus(vehicleid, panels, doors, lights, tires);
    
    new Float:health;
    GetVehicleHealth(vehicleid, health);
    
    // Удаляем машину из мира
    DestroyVehicle(vehicleid);
    
    // Создаем новую машину внутри гаража
    new newVehicle = CreateVehicle(
        GetVehicleModel(vehicleid),
        Garages[garageid][gExitX] + (freeSlot * 4),
        Garages[garageid][gExitY],
        Garages[garageid][gExitZ],
        0.0,
        color1, color2, -1
    );
    
    // Восстанавливаем состояние
    SetVehicleHealth(newVehicle, health);
    UpdateVehicleDamageStatus(newVehicle, panels, doors, lights, tires);
    
    // Сохраняем в слот
    switch(freeSlot) {
        case 0: Garages[garageid][gVehicle1] = newVehicle;
        case 1: Garages[garageid][gVehicle2] = newVehicle;
        case 2: Garages[garageid][gVehicle3] = newVehicle;
    }
    
    new model = GetVehicleModel(newVehicle);
    new vehName[32];
    GetVehicleName(model, vehName, sizeof(vehName));
    
    new str[128];
    format(str, sizeof(str), "Машина %s поставлена в гараж (слот %d)", vehName, freeSlot + 1);
    SendClientMessage(playerid, 0x00FF00FF, str);
    
    SaveGarage(garageid);
    return 1;
}

TakeVehicleFromGarage(playerid, garageid, slot) {
    new vehicleid;
    switch(slot) {
        case 0: vehicleid = Garages[garageid][gVehicle1];
        case 1: vehicleid = Garages[garageid][gVehicle2];
        case 2: vehicleid = Garages[garageid][gVehicle3];
    }
    
    if(vehicleid == INVALID_VEHICLE_ID) {
        SendClientMessage(playerid, 0xFF0000FF, "Этот слот пуст!");
        return 0;
    }
    
    // Телепортируем машину к игроку
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    SetVehiclePos(vehicleid, x + 3, y, z);
    SetVehicleZAngle(vehicleid, a);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    
    // Очищаем слот
    switch(slot) {
        case 0: Garages[garageid][gVehicle1] = INVALID_VEHICLE_ID;
        case 1: Garages[garageid][gVehicle2] = INVALID_VEHICLE_ID;
        case 2: Garages[garageid][gVehicle3] = INVALID_VEHICLE_ID;
    }
    
    new model = GetVehicleModel(vehicleid);
    new vehName[32];
    GetVehicleName(model, vehName, sizeof(vehName));
    
    new str[64];
    format(str, sizeof(str), "Вы взяли машину: %s", vehName);
    SendClientMessage(playerid, 0x00FF00FF, str);
    
    SaveGarage(garageid);
    return 1;
}

ShowGarageVehicles(playerid, garageid) {
    new str[256];
    format(str, sizeof(str),
        "Выберите машину:\n\n"
        "1. %s\n"
        "2. %s\n"
        "3. %s",
        GetVehicleInSlotInfo(garageid, 0),
        GetVehicleInSlotInfo(garageid, 1),
        GetVehicleInSlotInfo(garageid, 2)
    );
    
    ShowPlayerDialog(playerid, 1301, DIALOG_STYLE_LIST,
        "Машины в гараже",
        str,
        "Взять", "Назад"
    );
    
    SetPVarInt(playerid, "GarageID", garageid);
}

CMD:buygarage(playerid) {
    for(new i = 0; i < sizeof(GaragePositions); i++) {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, 
            GaragePositions[i][0], 
            GaragePositions[i][1], 
            GaragePositions[i][2])) {
            
            if(!Garages[i][gForSale]) {
                SendClientMessage(playerid, 0xFF0000FF, "Этот гараж не продается!");
                return 1;
            }
            
            if(Garages[i][gOwnerID] != 0) {
                SendClientMessage(playerid, 0xFF0000FF, "Этот гараж уже куплен!");
                return 1;
            }
            
            ShowBuyGarageDialog(playerid, i);
            return 1;
        }
    }
    
    SendClientMessage(playerid, 0xFF0000FF, "Подойдите к гаражу на продажу!");
    return 1;
}

ShowBuyGarageDialog(playerid, garageid) {
    new str[256];
    format(str, sizeof(str),
        "{FFD700}Покупка гаража №%d{FFFFFF}\n\n"
        "Цена: {00FF00}$%d{FFFFFF}\n"
        "Слотов для машин: {FFFF00}3{FFFFFF}\n"
        "Расположение: {AAAAAA}Лос-Сантос{FFFFFF}\n\n"
        "Купить этот гараж?",
        garageid + 1,
        Garages[garageid][gPrice]
    );
    
    ShowPlayerDialog(playerid, 1302, DIALOG_STYLE_MSGBOX,
        "Покупка гаража",
        str,
        "Купить", "Отмена"
    );
    
    SetPVarInt(playerid, "GarageID", garageid);
}

ShowSellGarageDialog(playerid, garageid) {
    new str[256];
    format(str, sizeof(str),
        "{FFD700}Продажа гаража №%d{FFFFFF}\n\n"
        "Цена покупки: {00FF00}$%d{FFFFFF}\n"
        "Возврат при продаже: {FFFF00}$%d{FFFFFF}\n"
        "Машин в гараже: %d/3\n\n"
        "Продать гараж?",
        garageid + 1,
        Garages[garageid][gPrice],
        Garages[garageid][gPrice] / 2,
        CountVehiclesInGarage(garageid)
    );
    
    ShowPlayerDialog(playerid, 1303, DIALOG_STYLE_MSGBOX,
        "Продажа гаража",
        str,
        "Продать", "Отмена"
    );
    
    SetPVarInt(playerid, "GarageID", garageid);
}

SellGarage(playerid, garageid) {
    // Возвращаем деньги (50% от цены)
    new refund = Garages[garageid][gPrice] / 2;
    GivePlayerMoney(playerid, refund);
    
    // Удаляем машины из гаража
    if(Garages[garageid][gVehicle1] != INVALID_VEHICLE_ID) {
        DestroyVehicle(Garages[garageid][gVehicle1]);
        Garages[garageid][gVehicle1] = INVALID_VEHICLE_ID;
    }
    if(Garages[garageid][gVehicle2] != INVALID_VEHICLE_ID) {
        DestroyVehicle(Garages[garageid][gVehicle2]);
        Garages[garageid][gVehicle2] = INVALID_VEHICLE_ID;
    }
    if(Garages[garageid][gVehicle3] != INVALID_VEHICLE_ID) {
        DestroyVehicle(Garages[garageid][gVehicle3]);
        Garages[garageid][gVehicle3] = INVALID_VEHICLE_ID;
    }
    
    // Сбрасываем владельца
    Garages[garageid][gOwner][0] = EOS;
    Garages[garageid][gOwnerID] = 0;
    Garages[garageid][gForSale] = 1;
    Garages[garageid][gLocked] = 0;
    
    PlayerGarage[playerid] = -1;
    
    new str[128];
    format(str, sizeof(str), "Вы продали гараж за $%d!", refund);
    SendClientMessage(playerid, 0x00FF00FF, str);
    
    SaveGarage(garageid);
    return 1;
}

CountVehiclesInGarage(garageid) {
    new count = 0;
    if(Garages[garageid][gVehicle1] != INVALID_VEHICLE_ID) count++;
    if(Garages[garageid][gVehicle2] != INVALID_VEHICLE_ID) count++;
    if(Garages[garageid][gVehicle3] != INVALID_VEHICLE_ID) count++;
    return count;
}

ShowGarageInfo(playerid, garageid) {
    new str[256];
    format(str, sizeof(str),
        "{FFD700}Информация о гараже №%d{FFFFFF}\n\n"
        "Владелец: {00FF00}%s{FFFFFF}\n"
        "Статус: %s\n"
        "Цена: {FFFF00}$%d{FFFFFF}\n"
        "Слотов занято: {00FF00}%d/3{FFFFFF}\n"
        "Координаты: {AAAAAA}%.1f, %.1f, %.1f{FFFFFF}",
        garageid + 1,
        strlen(Garages[garageid][gOwner]) > 0 ? Garages[garageid][gOwner] : "Не продано",
        Garages[garageid][gLocked] ? "{FF0000}Закрыт" : "{00FF00}Открыт",
        Garages[garageid][gPrice],
        CountVehiclesInGarage(garageid),
        Garages[garageid][gEnterX],
        Garages[garageid][gEnterY],
        Garages[garageid][gEnterZ]
    );
    
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX,
        "Информация о гараже",
        str,
        "OK", ""
    );
}

GetPlayerGarageID(playerid) {
    for(new i = 0; i < sizeof(GaragePositions); i++) {
        if(Garages[i][gOwnerID] == GetPlayerAccountID(playerid)) {
            return i;
        }
    }
    return -1;
}

CMD:exitgarage(playerid) {
    for(new i = 0; i < sizeof(GaragePositions); i++) {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, 
            Garages[i][gExitX], 
            Garages[i][gExitY], 
            Garages[i][gExitZ])) {
            
            if(Garages[i][gLocked]) {
                SendClientMessage(playerid, 0xFF0000FF, "Гараж закрыт!");
                return 1;
            }
            
            SetPlayerPos(playerid, 
                Garages[i][gEnterX], 
                Garages[i][gEnterY] + 2, 
                Garages[i][gEnterZ]
            );
            return 1;
        }
    }
    return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
    if(newkeys & KEY_SECONDARY_ATTACK) {
        for(new i = 0; i < sizeof(GaragePositions); i++) {
            if(IsPlayerInRangeOfPoint(playerid, 3.0, 
                GaragePositions[i][0], 
                GaragePositions[i][1], 
                GaragePositions[i][2])) {
                
                if(Garages[i][gForSale] && Garages[i][gOwnerID] == 0) {
                    cmd_buygarage(playerid);
                } else if(Garages[i][gOwnerID] == GetPlayerAccountID(playerid)) {
                    cmd_garage(playerid);
                } else {
                    SendClientMessage(playerid, 0xFF0000FF, "Это не ваш гараж!");
                }
                break;
            }
        }
    }
    return 1;
}

SaveGarage(garageid) {
    new query[512];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO garages (id, owner, owner_id, vehicle1, vehicle2, vehicle3, locked, for_sale) \
        VALUES (%d, '%s', %d, %d, %d, %d, %d, %d) \
        ON DUPLICATE KEY UPDATE \
        owner='%s', owner_id=%d, vehicle1=%d, vehicle2=%d, vehicle3=%d, locked=%d, for_sale=%d",
        garageid,
        Garages[garageid][gOwner],
        Garages[garageid][gOwnerID],
        Garages[garageid][gVehicle1],
        Garages[garageid][gVehicle2],
        Garages[garageid][gVehicle3],
        Garages[garageid][gLocked],
        Garages[garageid][gForSale],
        Garages[garageid][gOwner],
        Garages[garageid][gOwnerID],
        Garages[garageid][gVehicle1],
        Garages[garageid][gVehicle2],
        Garages[garageid][gVehicle3],
        Garages[garageid][gLocked],
        Garages[garageid][gForSale]
    );
    mysql_query(mysql, query, false);
}

LoadGarages() {
    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM garages");
    
    new Cache:result = mysql_query(mysql, query, true);
    new rows = cache_num_rows();
    
    for(new i = 0; i < rows; i++) {
        new id = cache_get_field_content_int(i, "id");
        
        if(id < 0 || id >= sizeof(GaragePositions)) continue;
        
        cache_get_field_content(i, "owner", Garages[id][gOwner], 24);
        Garages[id][gOwnerID] = cache_get_field_content_int(i, "owner_id");
        Garages[id][gVehicle1] = cache_get_field_content_int(i, "vehicle1");
        Garages[id][gVehicle2] = cache_get_field_content_int(i, "vehicle2");
        Garages[id][gVehicle3] = cache_get_field_content_int(i, "vehicle3");
        Garages[id][gLocked] = cache_get_field_content_int(i, "locked");
        Garages[id][gForSale] = cache_get_field_content_int(i, "for_sale");
        
        // Восстанавливаем машины если они есть
        if(Garages[id][gVehicle1] != INVALID_VEHICLE_ID) {
            // Здесь нужно восстанавливать машину с сохраненными параметрами
        }
        if(Garages[id][gVehicle2] != INVALID_VEHICLE_ID) {
            // Аналогично
        }
        if(Garages[id][gVehicle3] != INVALID_VEHICLE_ID) {
            // Аналогично
        }
    }
    
    cache_delete(result);
    printf("[GARAGES] Загружено %d гаражей из БД", rows);
}

CMD:mygarage(playerid) {
    new garageid = GetPlayerGarageID(playerid);
    
    if(garageid == -1) {
        SendCl
  /АВТОР  @pawnokoder
  /АВТОР  @pawnokoder
 /АВТОР  @pawnokoder
