#define TYPE_RU 1
#define TYPE_UA 2
#define TYPE_BY 3
#define TYPE_KZ 4

new PlayerPlates[MAX_PLAYERS][5][32];
new PlayerRegs[MAX_PLAYERS][5][8];
new gPlayerCountry[MAX_PLAYERS];

stock RandomNumberPlateByType(numberType, plate[], size)
{
    switch(numberType)
    {
        case TYPE_RU:
        {
            static const letters[12] = {'a','b','c','e','h','k','m','o','p','t','x','y'};
            format(plate, size, "%c%d%d%d%c%c",
                letters[random(sizeof(letters))],
                random(10), random(10), random(10),
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))]);
        }

        case TYPE_UA:
        {
            static const letters[12] = {'A','B','C','E','H','K','M','O','P','T','X','Y'};
            format(plate, size, "%c%c %d%d%d%d %c%c",
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))],
                random(10), random(10), random(10), random(10),
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))]);
        }

        case TYPE_BY:
        {
            static const letters[12] = {'A','B','C','E','H','K','M','O','P','T','X','Y'};
            format(plate, size, "%d%d%d%d %c%c-%d",
                random(10), random(10), random(10), random(10),
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))],
                random(10));
        }

        case TYPE_KZ:
        {
            static const letters[12] = {'a','b','c','e','h','k','m','o','p','t','x','y'};
            format(plate, size, "%d%d%d%c%c%c",
                random(10), random(10), random(10),
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))]);
        }

        default:
        {
            format(plate, size, "UNKNOWN");
        }
    }
}

stock RandomNumberRegionByType(country, region[], size)
{
    switch(country)
    {
        case 0:
        {
            format(region, size, "%02d", random(94)+1);
        }
        case 3:
        {
            format(region, size, "%02d", random(17)+1);
        }
        default:
        {
            format(region, size, "00");
        }
    }
}

stock IsValidNumberPlate(const plate[], const region[], numberType)
{
    new len = strlen(plate);
    
    switch (numberType)
    {
        case TYPE_RU:
        {
            static const letters[12] = {'a','b','c','e','h','k','m','o','p','t','x','y'};
            
            if (len != 6) return 0;
            
            new bool:valid = false;
            for (new i = 0; i < sizeof(letters); i++)
            {
                if (plate[0] == letters[i])
                {
                    valid = true;
                    break;
                }
            }
            if (!valid) return 0;
            
            for (new i = 1; i <= 3; i++)
            {
                if (plate[i] < '0' || plate[i] > '9') return 0;
            }
            
            for (new i = 4; i <= 5; i++)
            {
                valid = false;
                for (new j = 0; j < sizeof(letters); j++)
                {
                    if (plate[i] == letters[j])
                    {
                        valid = true;
                        break;
                    }
                }
                if (!valid) return 0;
            }
            
            new regionNum = strval(region);
            if (regionNum < 1 || regionNum > 999) return 0;
            
            return 1;
        }
        
        case TYPE_UA:
        {
            static const letters[12] = {'A','B','C','E','H','K','M','O','P','T','X','Y'};
            
            if (len != 10) return 0;
            
            for (new i = 0; i < 2; i++)
            {
                new bool:valid = false;
                for (new j = 0; j < sizeof(letters); j++)
                {
                    if (plate[i] == letters[j])
                    {
                        valid = true;
                        break;
                    }
                }
                if (!valid) return 0;
            }
            
            if (plate[2] != ' ') return 0;
            
            for (new i = 3; i <= 6; i++)
            {
                if (plate[i] < '0' || plate[i] > '9') return 0;
            }
            
            if (plate[7] != ' ') return 0;
            
            for (new i = 8; i <= 9; i++)
            {
                new bool:valid = false;
                for (new j = 0; j < sizeof(letters); j++)
                {
                    if (plate[i] == letters[j])
                    {
                        valid = true;
                        break;
                    }
                }
                if (!valid) return 0;
            }
            
            return 1;
        }

        case TYPE_BY:
        {
            static const letters[12] = {'A','B','C','E','H','K','M','O','P','T','X','Y'};
            
            if (len != 9) return 0;
            
            for (new i = 0; i <= 3; i++)
            {
                if (plate[i] < '0' || plate[i] > '9') return 0;
            }
            
            if (plate[4] != ' ') return 0;
            
            for (new i = 5; i <= 6; i++)
            {
                new bool:valid = false;
                for (new j = 0; j < sizeof(letters); j++)
                {
                    if (plate[i] == letters[j])
                    {
                        valid = true;
                        break;
                    }
                }
                if (!valid) return 0;
            }
            
            if (plate[7] != '-') return 0;
            
            if (plate[8] < '0' || plate[8] > '9') return 0;
            
            return 1;
        }
        
        case TYPE_KZ:
        {
            static const letters[12] = {'a','b','c','e','h','k','m','o','p','t','x','y'};
            
            if (len != 6) return 0;
            
            for (new i = 0; i <= 2; i++)
            {
                if (plate[i] < '0' || plate[i] > '9') return 0;
            }
            
            for (new i = 3; i <= 5; i++)
            {
                new bool:valid = false;
                for (new j = 0; j < sizeof(letters); j++)
                {
                    if (plate[i] == letters[j])
                    {
                        valid = true;
                        break;
                    }
                }
                if (!valid) return 0;
            }
            
            new regionNum = strval(region);
            if (regionNum < 1 || regionNum > 99) return 0;
            
            return 1;
        }
    }
    
    return 0;
}

stock PacketIncomingPlates(playerid, Node:JSONObject)
{
    new type;
    JSON_GetInt(JSONObject, "t", type);

    switch(type)
    {
        case 1:
        {
            new country = 0;
            JSON_GetInt(JSONObject, "c", country);
            gPlayerCountry[playerid] = country;

            new numberType;
            switch (country)
            {
                case 0: numberType = TYPE_RU;
                case 1: numberType = TYPE_UA;
                case 2: numberType = TYPE_BY;
                case 3: numberType = TYPE_KZ;
                default: numberType = TYPE_RU;
            }

            new plate[32] = "";
            new region[8] = "";
            RandomNumberPlateByType(numberType, plate, sizeof(plate));
            RandomNumberRegionByType(country, region, sizeof(region));

            new Node:response = JSON_Object();
            JSON_SetString(response, "p", plate);
            if (country == 0 || country == 3) JSON_SetString(response, "r", region);
            JSON_SetInt(response, "nt", numberType);
            JSON_SetInt(response, "t", 2);
            SendPacketToClient(playerid, 1, response);
            ~response;

            printf("[PLATES] Player %d selected country=%d generated plate=%s region=%s type=%d",
                   playerid, country, plate, region, numberType);
            
            if(openguiplates[playerid] == 0)
            {
                UpdatePriceGibddPlatesGUI(playerid);
            }
            else if(openguiplates[playerid] == 1)
            {
                UpdatePriceDonatePlatesGUI(playerid);
            }
            return 1;
        }

        case 2:
        {
            if (GetPlayerMoney(playerid) < 20000)
            {
                new Node:response = JSON_Object();
                JSON_SetInt(response, "t", 2);
                ShowNotificationSile(playerid, 2, 4, 1, 1, "Недостаточно денег", "");
                SendPacketToClient(playerid, 1, response);
                ~response;
                return 0;
            }

            GivePlayerMoneyEx(playerid, -20000);
            
            new plate[32] = "";
            new region[8] = "";
            new country = gPlayerCountry[playerid];
            new numberType;
            new bool:unique = false;
            new attempts = 0;
            new maxAttempts = 10;
            new inventoryItemId;
            
            switch (country)
            {
                case 0:
                {
                    numberType = TYPE_RU;
                    inventoryItemId = 59;
                }
                case 1:
                {
                    numberType = TYPE_UA;
                    inventoryItemId = 81;
                }
                case 2:
                {
                    numberType = TYPE_BY;
                    inventoryItemId = 82;
                }
                case 3:
                {
                    numberType = TYPE_KZ;
                    inventoryItemId = 83;
                }
                default:
                {
                    numberType = TYPE_RU;
                    inventoryItemId = 59;
                }
            }

            while (!unique && attempts < maxAttempts)
            {
                RandomNumberPlateByType(numberType, plate, sizeof(plate));
                RandomNumberRegionByType(country, region, sizeof(region));
                
                new query[512];
                new Cache:result;
                new rows;
                new bool:exists = false;
               
                // Проверка в ownable_cars
                if (country == 0 || country == 3)
                {
                    mysql_format(mysql, query, sizeof(query),
                        "SELECT id FROM ownable_cars WHERE number = '%s' AND region = '%s' AND number_type = %d LIMIT 1",
                        plate, region, numberType);
                }
                else
                {
                    mysql_format(mysql, query, sizeof(query),
                        "SELECT id FROM ownable_cars WHERE number = '%s' AND number_type = %d LIMIT 1",
                        plate, numberType);
                }
                
                result = mysql_query(mysql, query);
                rows = cache_num_rows();
                cache_delete(result);
                
                if (rows > 0)
                {
                    exists = true;
                }
                
                // Проверка в family_cars
                if (!exists)
                {
                    if (country == 0 || country == 3)
                    {
                        mysql_format(mysql, query, sizeof(query),
                            "SELECT id FROM family_cars WHERE number = '%s' AND region = '%s' AND number_type = %d LIMIT 1",
                            plate, region, numberType);
                    }
                    else
                    {
                        mysql_format(mysql, query, sizeof(query),
                            "SELECT id FROM family_cars WHERE number = '%s' AND number_type = %d LIMIT 1",
                            plate, numberType);
                    }
                    
                    result = mysql_query(mysql, query);
                    rows = cache_num_rows();
                    cache_delete(result);
                    
                    if (rows > 0)
                    {
                        exists = true;
                    }
                }
                
                if (!exists)
                {
                    if(country == 0)
                    {
                        new joinpl[256];
                        JoinPlate(plate, region, joinpl, sizeof(joinpl));
                        mysql_format(mysql, query, sizeof query,
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 59 AND `item_plate` = '%e' AND `is_active` = 0 LIMIT 1",
                            joinpl);
                    }
                    else if(country == 3)
                    {
                        new joinpl[256];
                        JoinPlate(plate, region, joinpl, sizeof(joinpl));
                        mysql_format(mysql, query, sizeof query,
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 83 AND `item_plate` = '%e' AND `is_active` = 0 LIMIT 1",
                            joinpl);
                    }
                    else if(country == 1)
                    {
                        mysql_format(mysql, query, sizeof query,
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 81 AND `item_plate` = '%e' AND `is_active` = 0 LIMIT 1",
                            plate);
                    }
                    else if(country == 2)
                    {
                        mysql_format(mysql, query, sizeof query,
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 82 AND `item_plate` = '%e' AND `is_active` = 0 LIMIT 1",
                            plate);
                    }
                    
                    result = mysql_query(mysql, query);
                    rows = cache_num_rows();
                    cache_delete(result);
                    
                    if (rows > 0)
                    {
                        exists = true;
                    }
                }
                
                if (!exists)
                {
                    unique = true;
                }
                
                attempts++;
                
                if (!unique && attempts >= maxAttempts)
                {
                    printf("[ERROR] Failed to generate unique plate for player %d after %d attempts", 
                           playerid, maxAttempts);
                    
                    new Node:errorResponse = JSON_Object();
                    JSON_SetInt(errorResponse, "t", 2);
                    ShowNotificationSile(playerid, 2, 4, 1, 1, "Ошибка генерации номера, попробуйте позже", "");
                    SendPacketToClient(playerid, 1, errorResponse);
                    ~errorResponse;
                    
                    GivePlayerMoneyEx(playerid, 20000);
                    return 0;
                }
            }

            new Node:response = JSON_Object();
            JSON_SetString(response, "p", plate);
            if (country == 0 || country == 3) JSON_SetString(response, "r", region);
            JSON_SetInt(response, "nt", numberType);
            JSON_SetInt(response, "t", 2);
            SendPacketToClient(playerid, 1, response);
            ~response;

            printf("[PLATES] Player %d regenerated unique plate=%s region=%s type=%d for %d$ (attempts: %d)",
                   playerid, plate, region, numberType, 20000, attempts);
            return 1;
        }
        
        case 3:
        {
            new Node:response = JSON_Object();
            if (GetPlayerMoney(playerid) < 200000 && openguiplates[playerid] == 0)
            {
                SendSooPlatesGUI(playerid, "Недостаточно средств!");
                return 0;
            }
            
            if (openguiplates[playerid] == 1 && GetPlayerDonateRub(playerid) < 150)
            {
                SendSooPlatesGUI(playerid, "Недостаточно средств!");
                return 0;
            }

            new plate[32], region[8], numberType;
            JSON_GetString(JSONObject, "p", plate, sizeof plate);
            JSON_GetString(JSONObject, "r", region, sizeof region);
            JSON_GetInt(JSONObject, "nt", numberType);

            if (numberType <= 0)
            {
                new country = gPlayerCountry[playerid];
                switch (country)
                {
                    case 0: numberType = TYPE_RU;
                    case 1: numberType = TYPE_UA;
                    case 2: numberType = TYPE_BY;
                    case 3: numberType = TYPE_KZ;
                    default: numberType = TYPE_RU;
                }
            }
            
            if (!IsValidNumberPlate(plate, region, numberType))
            {
                SendSooPlatesGUI(playerid, "Неверный формат номера!");
                ~response;
                return 1;
            }
            
            new bool:plateExists = false;
            new query[512];
            new Cache:result;
            new rows;

            // Проверка в ownable_cars
            if (numberType == TYPE_RU || numberType == TYPE_KZ)
            {
                mysql_format(mysql, query, sizeof(query),
                    "SELECT id FROM `ownable_cars` WHERE `number` = '%s' AND `region` = '%s' AND `number_type` = %d LIMIT 1",
                    plate, region, numberType);
            }
            else
            {
                mysql_format(mysql, query, sizeof(query),
                    "SELECT id FROM `ownable_cars` WHERE `number` = '%s' AND `number_type` = %d LIMIT 1",
                    plate, numberType);
            }
            result = mysql_query(mysql, query);
            rows = cache_num_rows();
            cache_delete(result);

            if (rows > 0)
            {
                plateExists = true;
                printf("[DEBUG] Plate found in ownable_cars");
            }

            // Проверка в family_cars
            if (!plateExists)
            {
                if (numberType == TYPE_RU || numberType == TYPE_KZ)
                {
                    mysql_format(mysql, query, sizeof(query),
                        "SELECT id FROM `family_cars` WHERE `number` = '%s' AND `region` = '%s' AND `number_type` = %d LIMIT 1",
                        plate, region, numberType);
                }
                else
                {
                    mysql_format(mysql, query, sizeof(query),
                        "SELECT id FROM `family_cars` WHERE `number` = '%s' AND `number_type` = %d LIMIT 1",
                        plate, numberType);
                }
                result = mysql_query(mysql, query);
                rows = cache_num_rows();
                cache_delete(result);
                
                if (rows > 0)
                {
                    plateExists = true;
                    printf("[DEBUG] Plate found in family_cars");
                }
            }

            if (!plateExists)
            {
                switch (numberType)
                {
                    case TYPE_RU:
                    {
                        new joinpl[256];
                        JoinPlate(plate, region, joinpl, sizeof(joinpl));
                        mysql_format(mysql, query, sizeof(query),
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 59 AND `item_plate` = '%s' AND `is_active` = 0 LIMIT 1",
                            joinpl);
                        printf("[DEBUG] Checking inventory RU: item_id=59, item_count='%s'", joinpl);
                    }
                    case TYPE_UA:
                    {
                        mysql_format(mysql, query, sizeof(query),
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 81 AND `item_plate` = '%s' AND `is_active` = 0 LIMIT 1",
                            plate);
                        printf("[DEBUG] Checking inventory UA: item_id=81, item_count='%s'", plate);
                    }
                    case TYPE_BY:
                    {
                        mysql_format(mysql, query, sizeof(query),
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 82 AND `item_plate` = '%s' AND `is_active` = 0 LIMIT 1",
                            plate);
                        printf("[DEBUG] Checking inventory BY: item_id=82, item_count='%s'", plate);
                    }
                    case TYPE_KZ:
                    {
                        new joinpl[256];
                        JoinPlate(plate, region, joinpl, sizeof(joinpl));
                        mysql_format(mysql, query, sizeof(query),
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 83 AND `item_plate` = '%s' AND `is_active` = 0 LIMIT 1",
                            joinpl);
                        printf("[DEBUG] Checking inventory KZ: item_id=83, item_count='%s'", joinpl);
                    }
                    default:
                    {
                        new joinpl[256];
                        JoinPlate(plate, region, joinpl, sizeof(joinpl));
                        mysql_format(mysql, query, sizeof(query),
                            "SELECT id FROM `player_inventory` WHERE `item_id` = 59 AND `item_plate` = '%s' AND `is_active` = 0 LIMIT 1",
                            joinpl);
                    }
                }
                
                result = mysql_query(mysql, query);
                rows = cache_num_rows();
                printf("[DEBUG] Query: %s", query);
                printf("[DEBUG] Rows found: %d", rows);
                cache_delete(result);
                
                if (rows > 0)
                {
                    plateExists = true;
                    printf("[DEBUG] Plate found in player_inventory (any player)");
                }
            }

            if (plateExists)
            {
                SendSooPlatesGUI(playerid, "Номер уже занят!");
                ~response;
                return 1;
            }
            
            new freeSlot = Inventory_GetFreeSlot(playerid);
            if(freeSlot == -1)
            {
                ShowNotificationSile(playerid, 2, 7, -1, -1, "Нет свободного места в инвентаре!", "");
                ~response;
                return 0;
            }
            
            switch (numberType)
            {
                case TYPE_RU:
                {
                    new joinpl[256];
                    JoinPlate(plate, region, joinpl, sizeof(joinpl));
                    Inventory_AddItem(playerid, 59, freeSlot, 1, joinpl);
                }
                case TYPE_UA:
                {
                    Inventory_AddItem(playerid, 81, freeSlot, 1, plate);
                }
                case TYPE_BY:
                {
                    Inventory_AddItem(playerid, 82, freeSlot, 1, plate);
                }
                case TYPE_KZ:
                {
                    new joinpl[256];
                    JoinPlate(plate, region, joinpl, sizeof(joinpl));
                    Inventory_AddItem(playerid, 83, freeSlot, 1, joinpl);
                }
                default:
                {
                    new joinpl[256];
                    JoinPlate(plate, region, joinpl, sizeof(joinpl));
                    Inventory_AddItem(playerid, 59, freeSlot, 1, joinpl);
                }
            }
            
            SaveInventoryItem(playerid, freeSlot);
            
            if(openguiplates[playerid] == 0)
            {
                GivePlayerMoneyEx(playerid, -200000, "Покупка н/з", 1, 0);
            }
            else if(openguiplates[playerid] == 1)
            {
                GivePlayerDonateRub(playerid, -150, "Покупка н/з", 1, 0);
                HidePlayerGUI(playerid, 1);
                new fmtt[512];
                if(numberType == 1 || numberType == 4)
                {
                    format(fmtt, sizeof(fmtt), "Номер {0099FF}%s[%s]{FFFFFF}, используйте инвентарь", plate, region);
                }
                else if(numberType == 2 || numberType == 3)
                {
                    format(fmtt, sizeof(fmtt), "Номер {0099FF}%s{FFFFFF}, используйте инвентарь", plate);
                } 
                
                new Node:responseDonate = JSON_Object();
                JSON_SetInt(responseDonate, "t", 0);
                JSON_SetInt(responseDonate, "y", 1);
                JSON_SetString(responseDonate, "n", fmtt);
                JSON_SetString(responseDonate, "m", "Вы успешно купили новый номер");
                JSON_SetInt(responseDonate, "r", GetPlayerMoney(playerid));
                JSON_SetInt(responseDonate, "s", GetPlayerDonateRub(playerid) - 50);
                SendPacketToClient(playerid, 22, responseDonate);
            }
            
            JSON_SetInt(response, "t", 3);
            JSON_SetString(response, "p", plate);
            if (numberType == TYPE_RU || numberType == TYPE_KZ)
                JSON_SetString(response, "r", region);
            JSON_SetInt(response, "nt", numberType);
            JSON_SetString(response, "h", "Номер добавлен в инвентарь.");
            SendPacketToClient(playerid, 1, response);
            ~response;
            
            SendSooPlatesGUI(playerid, "Номер добавлен в инвентарь.");
            
            printf("[PLATES] Player %d bought plate='%s' region='%s' type=%d for %s",
                   playerid, plate, region, numberType, 
                   openguiplates[playerid] == 0 ? "200000$" : "150 donaterub");
            
            return 1;
        }
        
        case 4:
        {
            new country, plate[32], region[8];
            JSON_GetInt(JSONObject, "c", country);
            JSON_GetString(JSONObject, "p", plate, sizeof(plate));
            JSON_GetString(JSONObject, "r", region, sizeof(region));

            SendPlatesTextGUI(playerid, plate, region);

            printf("[PLATES] Player %d manual entry: %s [%s]",
                   playerid, plate, region);
        }
    }

    return 1;
}

stock IsPlateOnVehicle(playerid)
{
    printf("[PLATES DEBUG] IsPlateOnVehicle called for player %d", playerid);
    
    new vehicleid = GetPlayerOwnableCar(playerid);
    printf("[PLATES DEBUG] IsPlateOnVehicle - vehicleid: %d", vehicleid);
    
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        printf("[PLATES DEBUG] IsPlateOnVehicle - no ownable vehicle");
        return 0;
    }
    
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    printf("[PLATES DEBUG] IsPlateOnVehicle - vehicle data index: %d", index);
    
    if(index == -1)
    {
        printf("[PLATES DEBUG] IsPlateOnVehicle - invalid vehicle data index");
        return 0;
    }
    
    printf("[PLATES DEBUG] IsPlateOnVehicle - OC_NUMBER_TYPE: %d, OC_NUMBER: '%s'", 
           g_ownable_car[index][OC_NUMBER_TYPE], g_ownable_car[index][OC_NUMBER]);
    
    if(g_ownable_car[index][OC_NUMBER_TYPE] != 0)
    {
        printf("[PLATES DEBUG] IsPlateOnVehicle - TRUE (has plates)");
        return 1;
    }
    
    printf("[PLATES DEBUG] IsPlateOnVehicle - FALSE (no plates)");
    return 0;
}

stock RemovePlateFromVehicle(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        SendClientMessage(playerid, 0x999999FF, "Ошибка");
        return 0;
    }
    
    new Float: x, Float: y, Float: z;
    GetVehiclePos(vehicleid, x, y, z);

    if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
    {
        SendClientMessage(playerid, 0x999999FF, "Вы не находитесь рядом с автомобилем");
        return 0;
    }
    
    if(!IsPlateOnVehicle(playerid))
    {
        SendClientMessage(playerid, -1, "На машине нет номеров.");
        return 0;
    }
    
    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    
    if(index == -1)
    {
        SendClientMessage(playerid, 0x999999FF, "Ошибка получения данных автомобиля");
        return 0;
    }
    
    new plate_text_value[16], region_value[4];
    new current_type = g_ownable_car[index][OC_NUMBER_TYPE];
    new inventory_type = current_type;
    
    if(current_type == 4)
        inventory_type = 83;
    else if(current_type == 3)
        inventory_type = 82;
    else if(current_type == 2)
        inventory_type = 81;
    else if(current_type == 1)
        inventory_type = 59;
    
    strcpy(plate_text_value, g_ownable_car[index][OC_NUMBER], 16);
    strcpy(region_value, g_ownable_car[index][OC_REGION], 4);
    
    printf("[PLATES DEBUG] RemovePlateFromVehicle - plate: '%s' [%s], current_type: %d -> inventory_type: %d", 
           plate_text_value, region_value, current_type, inventory_type);
           
    new joinpl[256];
    JoinPlate(plate_text_value, region_value, joinpl, sizeof(joinpl));
    
    new freeSlot = Inventory_GetFreeSlot(playerid);
    if(freeSlot == -1)
    {
        ShowNotificationSile(playerid, 2, 7, -1, -1, "Нет свободного места в инвентаре!", "");
        return 0;
    }
    Inventory_AddItem(playerid, inventory_type, freeSlot, 1, joinpl);
    SaveInventoryItem(playerid, freeSlot);
    
    SetVehicleNumberPlateEx(vehicleid, 0, "------", "000");
    
    format(g_ownable_car[index][OC_NUMBER], 32, "none");
    format(g_ownable_car[index][OC_REGION], 4, "--");
    g_ownable_car[index][OC_NUMBER_TYPE] = 0;
    
    new query[512];
    mysql_format(mysql, query, sizeof query, 
        "UPDATE ownable_cars SET number='none', region='--', number_type='0' WHERE id='%d' LIMIT 1", 
        GetOwnableCarData(index, OC_SQL_ID));
    
    printf("[PLATES DEBUG] Update car SQL: %s", query);
    mysql_query(mysql, query, false);
    
    if(mysql_errno(mysql) != 0)
    {
        printf("[PLATES ERROR] MySQL error %d when updating car", mysql_errno(mysql));
    }
    
    ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0, 1);
    
    SendClientMessage(playerid, -1, "Вы сняли старые номера, они положены вам в инвентарь.");
    
    return 1;
}

stock ShowPlayerPlatesGUI(playerid, type)
{
    if(type == 0)
    {
        new Node:plate_response = JSON_Object(
            "o", JSON_Int(1),
            "t", JSON_Int(0)
        );
        SendPacketToClient(playerid, 1, plate_response);
        UpdatePriceGibddPlatesGUI(playerid);
        openguiplates[playerid] = 0;
    }
    else if(type == 1)
    {
        new Node:plate_response = JSON_Object(
            "o", JSON_Int(1),
            "t", JSON_Int(1)
        );
        SendPacketToClient(playerid, 1, plate_response);
        UpdatePriceDonatePlatesGUI(playerid);
        openguiplates[playerid] = 1;
    }
    return 1;
}

stock UpdatePriceGibddPlatesGUI(playerid)
{
    new Node:prices_response = JSON_Object(
        "t", JSON_Int(0),
        "p", JSON_Int(200000),
        "pr", JSON_Int(20000)
    );
    SendPacketToClient(playerid, 1, prices_response);
}

stock UpdatePriceDonatePlatesGUI(playerid)
{
    new Node:prices_response = JSON_Object(
        "t", JSON_Int(0),
        "p", JSON_Int(150),
        "pr", JSON_Int(5)
    );
    SendPacketToClient(playerid, 1, prices_response);
}

stock SendSooPlatesGUI(playerid, soo[])
{
    new Node:soo_response = JSON_Object(
        "t", JSON_Int(1),
        "h", JSON_String(soo, strlen(soo) + 1)
    );
    SendPacketToClient(playerid, 1, soo_response);
}

stock SendPlatesTextGUI(playerid, plate[], region[])
{
    new Node:plates_response = JSON_Object(
        "t", JSON_Int(2),
        "p", JSON_String(plate, strlen(plate) + 1),
        "r", JSON_String(region, strlen(region) + 1)
    );
    SendPacketToClient(playerid, 1, plates_response);
}