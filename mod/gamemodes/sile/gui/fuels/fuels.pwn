CMD:fuelfill(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid), modelid = GetVehicleModel(vehicleid), fuel;
    GetVehFuelByModel(modelid, fuel);

    switch(fuel)
    {
        case 0: fuel = 92;
        case 1: fuel = 95;
        case 2: fuel = 98;
        case 3: fuel = 100;
        case 4: fuel = 67;
    }

    new fmt[64];
    if(fuel != 67)
    {
        format(fmt, sizeof(fmt), "Рекомендуется: АИ-%d", fuel);
    }
    else if(fuel == 67)
    {
        format(fmt, sizeof(fmt), "Рекомендуется: ДТ");
    }
    new prices[5] = {65, 69, 77, 98, 86}; // Цена
    ShowFuelFillGUI(playerid, 150, prices, fmt);

    SendClientMessage(playerid, -1, "GUI opened.");
    return 1;
}
stock ShowFuelFillGUI(playerid, maxFuel, prices[5], const hint[])
{
    new Node:root = JSON_Object();
    JSON_SetInt(root, "m", maxFuel); 
    new hintBuffer[128];
    format(hintBuffer, sizeof(hintBuffer), "%s", hint);
    JSON_SetString(root, "h", hintBuffer, sizeof(hintBuffer));

  
    new Node:pricesArray = JSON_Array(
        JSON_Int(prices[0]),
        JSON_Int(prices[1]),
        JSON_Int(prices[2]),
        JSON_Int(prices[3]),
        JSON_Int(prices[4])
    );
    JSON_SetArray(root, "ma", pricesArray);

    new jsonString[512];
    JSON_Stringify(root, jsonString, sizeof(jsonString));
    ShowPlayerGUI(playerid, 2, root); 

    JSON_Cleanup(root);
    JSON_Cleanup(pricesArray);
}

stock HandlePacketFuekFill(playerid, Node:JSONObject)
{
    new t, v, f;
    JSON_GetInt(JSONObject, "t", t);
    JSON_GetInt(JSONObject, "v", v);
    JSON_GetInt(JSONObject, "f", f);
    printf("t: %d, v: %d, f: %d", t, v, f);

    switch(t)
    {
        case 0:
        {
            new vehicleid = GetPlayerVehicleID(playerid), modelid = GetVehicleModel(vehicleid), fuel;
            GetVehFuelByModel(modelid, fuel);
            switch(f)
            {
                case 0:
                {
                    if(fuel != 0)
                    {
                        ShowNotificationSile(playerid, 2, 6, -1, -1, "Данный тип топлива не поддерживается на Вашес ТС!", "");
                        return 1;
                    }
                }
                case 1:
                {
                    if(fuel != 1)
                    {
                        ShowNotificationSile(playerid, 2, 6, -1, -1, "Данный тип топлива не поддерживается на Вашес ТС!", "");
                        return 1;
                    }
                }
                case 2:
                {
                    if(fuel != 2)
                    {
                        ShowNotificationSile(playerid, 2, 6, -1, -1, "Данный тип топлива не поддерживается на Вашес ТС!", "");
                        return 1;
                    }
                }
                case 3:
                {
                    if(fuel != 3)
                    {
                        ShowNotificationSile(playerid, 2, 6, -1, -1, "Данный тип топлива не поддерживается на Вашес ТС!", "");
                        return 1;
                    }
                }
                case 4:
                {
                    if(fuel != 4)
                    {
                        ShowNotificationSile(playerid, 2, 6, -1, -1, "Данный тип топлива не поддерживается на Вашес ТС!", "");
                        return 1;
                    }
                }
            }
        }
    }
}