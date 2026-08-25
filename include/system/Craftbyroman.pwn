/АВТОР  @pawnokoder
/АВТОР  @pawnokoder
/АВТОР  @pawnokoder

new CraftingRecipes[][8] = {
    // Формат: {материал1, количество1, материал2, результат, шанс%, цена, тип (0-оружие,1-аксессуар,2-машина)}
    
    // === ОРУЖИЕ ===
    {1, 10, 0, 11, 10, 0, 0, 0},        // Лом x10 → Нож (10%)
    {2, 5, 772, 22, 20, 100, 0, 0},     // Пист.части x5 + Основа → Пистолет (20%) $100
    {3, 20, 772, 30, 15, 500, 0, 0},    // AK детали x20 + Основа → AK-47 (15%) $500
    {4, 100, 772, 34, 5, 1000, 0, 0},   // Снайп.части x100 + Основа → Снайперка (5%) $1000
    {5, 50, 772, 29, 25, 300, 0, 0},    // SMG детали x50 + Основа → MP5 (25%) $300
    {6, 200, 772, 31, 10, 800, 0, 0},   // M4 детали x200 + Основа → M4 (10%) $800
    {7, 300, 772, 25, 8, 600, 0, 0},    // Дробовик части x300 + Основа → Дробовик (8%) $600
    {8, 150, 772, 24, 15, 700, 0, 0},   // Deagle части x150 + Основа → Deagle (15%) $700
    {9, 500, 772, 35, 3, 1500, 0, 0},   // РПГ детали x500 + Основа → РПГ (3%) $1500
    {10, 1000, 772, 16, 2, 2000, 0, 0}, // Гранаты детали x1000 + Основа → Граната (2%) $2000
    
    // === АКСЕССУАРЫ === (ID моделей: 19000-19999)
    {11, 5, 772, 19078, 40, 250, 1, 1},   // Золото x5 + Основа → Кольцо (40%) $250
    {12, 10, 772, 19036, 35, 400, 1, 2},  // Стекло x10 + Основа → Очки (35%) $400
    {13, 15, 772, 19039, 30, 600, 1, 3},  // Кожа x15 + Основа → Часы (30%) $600
    {14, 20, 772, 19067, 25, 800, 1, 4},  // Цепь x20 + Основа → Цепочка (25%) $800
    {15, 25, 772, 19094, 20, 1000, 1, 5}, // Драгоценности x25 + Основа → Браслет (20%) $1000
    {16, 30, 772, 19161, 15, 1500, 1, 6}, // Платина x30 + Основа → Кулон (15%) $1500
    {17, 50, 772, 19140, 10, 2000, 1, 7}, // Кристаллы x50 + Основа → Тиара (10%) $2000
    
    // === МАШИНЫ === (ID 400-611)
    {18, 100, 772, 411, 5, 5000, 2, 8},   // Двигатель x100 + Основа → Infernus (5%) $5000
    {19, 80, 772, 415, 8, 4000, 2, 9},    // Кузов x80 + Основа → Cheetah (8%) $4000
    {20, 70, 772, 451, 10, 3500, 2, 10},  // Детали x70 + Основа → Turismo (10%) $3500
    {21, 60, 772, 522, 12, 3000, 2, 11},  // Запчасти x60 + Основа → NRG-500 (12%) $3000
    {22, 90, 772, 560, 7, 4500, 2, 12},   // Тюнинг x90 + Основа → Sultan (7%) $4500
    {23, 120, 772, 541, 4, 6000, 2, 13},  // Люкс детали x120 + Основа → Bullet (4%) $6000
    {24, 150, 772, 429, 3, 8000, 2, 14}   // Спорт детали x150 + Основа → Banshee (3%) $8000
};

new PlayerMaterials[MAX_PLAYERS][30];
new CraftingStations[][3] = {
    {1368.93, -1279.68, 13.54},
    {2232.11, -1261.78, 23.98},
    {663.84, -573.32, 16.33}
};

new AccObjects[MAX_PLAYERS][10];
new AccSlots[MAX_PLAYERS];

public OnGameModeInit() {
    for(new i = 0; i < sizeof(CraftingStations); i++) {
        CreateDynamicPickup(1272, 1, CraftingStations[i][0], CraftingStations[i][1], CraftingStations[i][2]);
    }
    return 1;
}

CMD:craft(playerid) {
    new found = 0;
    for(new i = 0; i < sizeof(CraftingStations); i++) {
        if(IsPlayerInRangeOfPoint(playerid, 5.0, CraftingStations[i][0], CraftingStations[i][1], CraftingStations[i][2])) {
            found = 1;
            break;
        }
    }
    if(!found) return SendClientMessage(playerid, 0xFF0000FF, "Подойдите к станции крафта");
    
    ShowCraftMenu(playerid);
    return 1;
}

ShowCraftMenu(playerid) {
    new str[2048];
    format(str, sizeof(str), "Крафт предметов:\n\n{FFD700}=== ОРУЖИЕ ==={FFFFFF}\n");
    
    for(new i = 0; i < 10; i++) {
        new hasMat1 = (PlayerMaterials[playerid][CraftingRecipes[i][0]-1] >= CraftingRecipes[i][1]);
        new hasMat2 = (CraftingRecipes[i][2] == 0 || PlayerMaterials[playerid][CraftingRecipes[i][2]-1] >= 1);
        new hasMoney = (GetPlayerMoney(playerid) >= CraftingRecipes[i][5]);
        
        new itemName[32], resultName[32];
        GetMaterialName(CraftingRecipes[i][0], itemName);
        GetResultName(CraftingRecipes[i][3], CraftingRecipes[i][6], resultName);
        
        if(hasMat1 && hasMat2 && hasMoney) {
            if(CraftingRecipes[i][2] == 0) {
                format(str, sizeof(str), "%s{00FF00}%d. %s x%d → %s (%d%%) - $%d\n", 
                    str, i+1, itemName, CraftingRecipes[i][1], resultName, CraftingRecipes[i][4], CraftingRecipes[i][5]);
            } else {
                format(str, sizeof(str), "%s{00FF00}%d. %s x%d + Основа → %s (%d%%) - $%d\n", 
                    str, i+1, itemName, CraftingRecipes[i][1], resultName, CraftingRecipes[i][4], CraftingRecipes[i][5]);
            }
        } else {
            if(CraftingRecipes[i][2] == 0) {
                format(str, sizeof(str), "%s{FF0000}%d. %s x%d → %s (%d%%) - $%d\n", 
                    str, i+1, itemName, CraftingRecipes[i][1], resultName, CraftingRecipes[i][4], CraftingRecipes[i][5]);
            } else {
                format(str, sizeof(str), "%s{FF0000}%d. %s x%d + Основа → %s (%d%%) - $%d\n", 
                    str, i+1, itemName, CraftingRecipes[i][1], resultName, CraftingRecipes[i][4], CraftingRecipes[i][5]);
            }
        }
    }
    
    format(str, sizeof(str), "%s\n{FFD700}=== АКСЕССУАРЫ ==={FFFFFF}\n", str);
    for(new i = 10; i < 17; i++) {
        new hasMat1 = (PlayerMaterials[playerid][CraftingRecipes[i][0]-1] >= CraftingRecipes[i][1]);
        new hasMat2 = (CraftingRecipes[i][2] == 0 || PlayerMaterials[playerid][CraftingRecipes[i][2]-1] >= 1);
        new hasMoney = (GetPlayerMoney(playerid) >= CraftingRecipes[i][5]);
        
        new itemName[32], resultName[32];
        GetMaterialName(CraftingRecipes[i][0], itemName);
        GetResultName(CraftingRecipes[i][3], CraftingRecipes[i][6], resultName);
        
        if(hasMat1 && hasMat2 && hasMoney) {
            format(str, sizeof(str), "%s{00FF00}%d. %s x%d + Основа → %s (%d%%) - $%d\n", 
                str, i+1, itemName, CraftingRecipes[i][1], resultName, CraftingRecipes[i][4], CraftingRecipes[i][5]);
        } else {
            format(str, sizeof(str), "%s{FF0000}%d. %s x%d + Основа → %s (%d%%) - $%d\n", 
                str, i+1, itemName, CraftingRecipes[i][1], resultName, CraftingRecipes[i][4], CraftingRecipes[i][5]);
        }
    }
    
    format(str, sizeof(str), "%s\n{FFD700}=== МАШИНЫ ==={FFFFFF}\n", str);
    for(new i = 17; i < sizeof(CraftingRecipes); i++) {
        new hasMat1 = (PlayerMaterials[playerid][CraftingRecipes[i][0]-1] >= CraftingRecipes[i][1]);
        new hasMat2 = (CraftingRecipes[i][2] == 0 || PlayerMaterials[playerid][CraftingRecipes[i][2]-1] >= 1);
        new hasMoney = (GetPlayerMoney(playerid) >= CraftingRecipes[i][5]);
        
        new itemName[32], resultName[32];
        GetMaterialName(CraftingRecipes[i][0], itemName);
        GetResultName(CraftingRecipes[i][3], CraftingRecipes[i][6], resultName);
        
        if(hasMat1 && hasMat2 && hasMoney) {
            format(str, sizeof(str), "%s{00FF00}%d. %s x%d + Основа → %s (%d%%) - $%d\n", 
                str, i+1, itemName, CraftingRecipes[i][1], resultName, CraftingRecipes[i][4], CraftingRecipes[i][5]);
        } else {
            format(str, sizeof(str), "%s{FF0000}%d. %s x%d + Основа → %s (%d%%) - $%d\n", 
                str, i+1, itemName, CraftingRecipes[i][1], resultName, CraftingRecipes[i][4], CraftingRecipes[i][5]);
        }
    }
    
    ShowPlayerDialog(playerid, 1100, DIALOG_STYLE_LIST, "Крафт", str, "Крафтить", "Отмена");
}

CraftItem(playerid, recipeid) {
    if(recipeid < 0 || recipeid >= sizeof(CraftingRecipes)) return 0;
    
    new item1 = CraftingRecipes[recipeid][0];
    new amount1 = CraftingRecipes[recipeid][1];
    new item2 = CraftingRecipes[recipeid][2];
    new result = CraftingRecipes[recipeid][3];
    new chance = CraftingRecipes[recipeid][4];
    new price = CraftingRecipes[recipeid][5];
    new type = CraftingRecipes[recipeid][6];
    
    if(PlayerMaterials[playerid][item1-1] < amount1) {
        SendClientMessage(playerid, 0xFF0000FF, "Недостаточно основного материала");
        return 0;
    }
    
    if(item2 != 0 && PlayerMaterials[playerid][item2-1] < 1) {
        SendClientMessage(playerid, 0xFF0000FF, "Нужна основа (ID: 772) для крафта");
        return 0;
    }
    
    if(GetPlayerMoney(playerid) < price) {
        new str[64];
        format(str, sizeof(str), "Нужно $%d для крафта", price);
        SendClientMessage(playerid, 0xFF0000FF, str);
        return 0;
    }
    
    GivePlayerMoney(playerid, -price);
    PlayerMaterials[playerid][item1-1] -= amount1;
    if(item2 != 0) {
        PlayerMaterials[playerid][item2-1]--;
    }
    
    new rand = random(100);
    if(rand < chance) {
        // Успешный крафт
        switch(type) {
            case 0: { // Оружие
                GivePlayerWeapon(playerid, result, GetWeaponAmmo(result));
                ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 4.1, 0, 0, 0, 0, 0);
            }
            case 1: { // Аксессуар
                GivePlayerAccessory(playerid, result, recipeid-9);
                ApplyAnimation(playerid, "CASINO", "dealone", 4.1, 0, 0, 0, 0, 0);
            }
            case 2: { // Машина
                CreatePlayerVehicle(playerid, result);
                ApplyAnimation(playerid, "CASINO", "manwinb", 4.1, 0, 0, 0, 0, 0);
            }
        }
        
        new resultName[64];
        GetResultName(result, type, resultName);
        
        new str[128];
        format(str, sizeof(str), "Успешно скрафчено: %s!", resultName);
        SendClientMessage(playerid, 0x00FF00FF, str);
    } else {
        SendClientMessage(playerid, 0xFF0000FF, "Крафт не удался! Материалы и деньги потрачены");
        ApplyAnimation(playerid, "RIOT", "RIOT_ANGRY", 4.1, 0, 0, 0, 0, 0);
    }
    
    return 1;
}

GivePlayerAccessory(playerid, modelid, slot) {
    if(AccSlots[playerid] >= 10) {
        SendClientMessage(playerid, 0xFF0000FF, "Достигнут лимит аксессуаров (10)");
        return 0;
    }
    
    AccObjects[playerid][AccSlots[playerid]] = CreateDynamicObject(modelid, 0,0,0,0,0,0);
    AttachDynamicObjectToPlayer(AccObjects[playerid][AccSlots[playerid]], playerid, 
        0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
    
    AccSlots[playerid]++;
    
    new accName[32];
    GetAccessoryName(modelid, accName);
    
    new str[64];
    format(str, sizeof(str), "Аксессуар получен: %s", accName);
    SendClientMessage(playerid, 0x00FF00FF, str);
    return 1;
}

CreatePlayerVehicle(playerid, modelid) {
    new Float:x, Float:y, Float:z, Float:a;
    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);
    
    new vehicleid = CreateVehicle(modelid, x+5, y, z, a, -1, -1, -1);
    PutPlayerInVehicle(playerid, vehicleid, 0);
    
    new vehName[32];
    GetVehicleName(modelid, vehName, sizeof(vehName));
    
    new str[64];
    format(str, sizeof(str), "Машина создана: %s", vehName);
    SendClientMessage(playerid, 0x00FF00FF, str);
    return vehicleid;
}

GetResultName(resultid, type, name[]) {
    switch(type) {
        case 0: GetWeaponName(resultid, name, 64);
        case 1: GetAccessoryName(resultid, name);
        case 2: GetVehicleName(resultid, name, 64);
        default: format(name, 64, "Предмет %d", resultid);
    }
}

GetAccessoryName(modelid, name[]) {
    switch(modelid) {
        case 19078: format(name, 32, "Кольцо");
        case 19036: format(name, 32, "Очки");
        case 19039: format(name, 32, "Часы");
        case 19067: format(name, 32, "Цепочка");
        case 19094: format(name, 32, "Браслет");
        case 19161: format(name, 32, "Кулон");
        case 19140: format(name, 32, "Тиара");
        default: format(name, 32, "Аксессуар %d", modelid);
    }
}

GetMaterialName(matid, name[]) {
    switch(matid) {
        case 1: format(name, 32, "Лом");
        case 2: format(name, 32, "Пист.части");
        case 3: format(name, 32, "AK детали");
        case 4: format(name, 32, "Снайп.части");
        case 5: format(name, 32, "SMG детали");
        case 6: format(name, 32, "M4 детали");
        case 7: format(name, 32, "Дробовик части");
        case 8: format(name, 32, "Deagle части");
        case 9: format(name, 32, "РПГ детали");
        case 10: format(name, 32, "Гранаты детали");
        case 11: format(name, 32, "Золото");
        case 12: format(name, 32, "Стекло");
        case 13: format(name, 32, "Кожа");
        case 14: format(name, 32, "Цепь");
        case 15: format(name, 32, "Драгоценности");
        case 16: format(name, 32, "Платина");
        case 17: format(name, 32, "Кристаллы");
        case 18: format(name, 32, "Двигатель");
        case 19: format(name, 32, "Кузов");
        case 20: format(name, 32, "Детали");
        case 21: format(name, 32, "Запчасти");
        case 22: format(name, 32, "Тюнинг");
        case 23: format(name, 32, "Люкс детали");
        case 24: format(name, 32, "Спорт детали");
        case 772: format(name, 32, "Основа");
        default: format(name, 32, "Материал %d", matid);
    }
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]) {
    if(dialogid == 1100 && response) {
        CraftItem(playerid, listitem);
        return 1;
    }
    return 0;
}

CMD:materials(playerid) {
    new str[512];
    format(str, sizeof(str), "Ваши материалы:\n\n");
    
    for(new i = 0; i < 30; i++) {
        if(PlayerMaterials[playerid][i] > 0) {
            new matName[32];
            GetMaterialName(i+1, matName);
            format(str, sizeof(str), "%s%s: %d\n", str, matName, PlayerMaterials[playerid][i]);
        }
    }
    
    if(strlen(str) < 30) {
        SendClientMessage(playerid, 0xFFFF00FF, "У вас нет материалов");
        return 1;
    }
    
    ShowPlayerDialog(playerid, 0, DIALOG_STYLE_MSGBOX, "Материалы", str, "OK", "");
    return 1;
}

CMD:accessories(playerid) {
    new str[256];
    format(str, sizeof(str), "Ваши аксессуары:\n\n");
    
    for(new i = 0; i < AccSlots[playerid]; i++) {
        if(AccObjects[playerid][i]) {
            new accName[32];
            GetAccessoryName(Streamer_GetIntData(STREAMER_TYPE_OBJECT, AccObjects[playerid][i], E_STREAMER_MODEL_ID), accName);
            format(str, sizeof(str), "%s%d. %s\n", str, i+1, accName);
        }
    }
    
    if(AccSlots[playerid] == 0) {
        SendClientMessage(playerid, 0xFFFF00FF, "У вас нет аксессуаров");
        return 1;
    }
    
    ShowPlayerDialog(playerid, 1200, DIALOG_STYLE_LIST, "Аксессуары", str, "Снять", "Закрыть");
    return 1;
}

public OnPlayerDisconnect(playerid, reason) {
    for(new i = 0; i < AccSlots[playerid]; i++) {
        if(AccObjects[playerid][i]) {
            DestroyDynamicObject(AccObjects[playerid][i]);
        }
    }
    AccSlots[playerid] = 0;
    return 1;
}