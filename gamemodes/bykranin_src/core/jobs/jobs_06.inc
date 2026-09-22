//>> Файл: bykranin_src/core/jobs/jobs_06.inc  (424 строк)
//>> Тема: работы и заработок
//>> Внутри: SpawnCont, TimerSecondUpdateCont, ResetContInfo, CorrectTimerMinute, /cont, StartCont, StopCont
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock SpawnCont(contid)
{
    if(contid < 1 || contid > MAX_CONT) return printf("ERROR: Invalid container ID in SpawnCont: %d", contid);
    if(ContNewSystem_SpawnContainer(contid)) return 1;
    new prize_region, prize_id, prize_price;
    new prize_name[64];
    new random_prize_index;
    
    new random_prize_type = random(2) + 1;
    if (random_prize_type == 1)
    {
        random_prize_index = random(sizeof(cSkin_Info));
        prize_region = cSkin_Info[random_prize_index][PRIZE_REGION];
        prize_id = cSkin_Info[random_prize_index][PRIZE_ID];
        format(prize_name, sizeof(prize_name), "%s", cSkin_Info[random_prize_index][PRIZE_NAME]);
        prize_price = cSkin_Info[random_prize_index][PRIZE_PRICE];
    }
					else
    {
        random_prize_index = random(sizeof(cCar_Info));
        prize_region = cCar_Info[random_prize_index][PRIZE_REGION];
        prize_id = cCar_Info[random_prize_index][PRIZE_ID];
        format(prize_name, sizeof(prize_name), "%s", cCar_Info[random_prize_index][PRIZE_NAME]);
        prize_price = cCar_Info[random_prize_index][PRIZE_PRICE];
    }
    
    cInfo[contid][ContRegion] = prize_region;
    cInfo[contid][ItemType] = random_prize_type;
    cInfo[contid][Item] = prize_id;
    cInfo[contid][ItemPrice] = prize_price;
    
    new initial_price = 0;
    if (cInfo[contid][ItemType] == 1)
    {
        initial_price = g_RegionData[cInfo[contid][ContRegion]][ClothesPrice];
    }
					else
    {
        initial_price = g_RegionData[cInfo[contid][ContRegion]][VehiclePrice];
    }
    
    cInfo[contid][ContPrice] = initial_price;
    cInfo[contid][BetPrice] = initial_price;
    
    new Float:x, Float:y, Float:z, Float:rot;
    new Float:door1X, Float:door1Y, Float:door1Z, Float:door1A;
    new Float:door2X, Float:door2Y, Float:door2Z, Float:door2A;
    
    x = cContsPos[contid-1][0];
    y = cContsPos[contid-1][1];
    z = cContsPos[contid-1][2];
    rot = cContsPos[contid-1][3];
    
    door1X = cContsPos[contid-1][4];
    door1Y = cContsPos[contid-1][5];
    door1Z = cContsPos[contid-1][6];
    door1A = cContsPos[contid-1][7];
    
    door2X = cContsPos[contid-1][8];
    door2Y = cContsPos[contid-1][9];
    door2Z = cContsPos[contid-1][10];
    door2A = cContsPos[contid-1][11];
    
    new object_model = g_RegionData[cInfo[contid][ContRegion]][ContModelId];
    new vorota_model = g_RegionData[cInfo[contid][ContRegion]][VorotaModelId];

    cInfo[contid][ContObjectId] = CreateObject(object_model, x, y, z, 0.0, 0.0, rot);
    cInfo[contid][ContObjectDoorLId] = CreateObject(vorota_model, door1X, door1Y, door1Z, 0.0, 0.0, door1A);
    cInfo[contid][ContObjectDoorRId] = CreateObject(vorota_model, door2X, door2Y, door2Z, 0.0, 0.0, door2A);

    new moneystr[15];
    ConvertMoney(cInfo[contid][ContPrice], moneystr);

    TextDrawSetString(cont_name[contid], prize_name);
    
    cInfo[contid][Saled] = true;
    cInfo[contid][BetedId] = INVALID_PLAYER_ID;

    new strwerton[256];
    format(strwerton, sizeof strwerton, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги за контейнер открыты\n{993333}Начальная ставка: {FFFFFF}%s рублей", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr);
    
    if (ContsText[contid] == Dynamic3DTextLabel:INVALID_3DTEXT_ID)
    {
        ContsText[contid] = CreateDynamic3DTextLabel(strwerton, -1, x, y, z+1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, false, contid);
    }
					else
    {
        UpdateDynamic3DTextLabelText(ContsText[contid], CLR_RED, strwerton);
    }

	if(ContArea[contid] != 0)
	{
    ContNewSystem_RefreshViewers(contid);
		DestroyDynamicArea(ContArea[contid]);
	}
	ContArea[contid] = CreateDynamicSphere(ContBuyTextPos[contid-1][0], ContBuyTextPos[contid-1][1], ContBuyTextPos[contid-1][2], ContNewSystem_GetInteractRange());

    printf("Создан контейнер %d ||| тип %d ||| регион %d", contid, cInfo[contid][ItemType], cInfo[contid][ContRegion]);

    return 1;
}

public TimerSecondUpdateCont(contid, moneystart[])
{
    if(ContNewSystem_TimerSecondUpdate(contid, moneystart)) return 1;
    if(cInfo[contid][SaleTime] > 0)
    {
        cInfo[contid][SaleTime]--;

        cInfo[contid][Saled] = true;
        
        new moneystr[15], betstr[15];
        ConvertMoney(cInfo[contid][ContPrice], moneystr);
        ConvertMoney(cInfo[contid][BetPrice], betstr);
        
    new strwerton[650];
    if (cInfo[contid][BetedId] != INVALID_PLAYER_ID)
    {
        format(strwerton, sizeof strwerton,
            "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n\
{993333}Статус: {FFFFFF}идут активные торги\n{993333}Последняя ставка: {FFFFFF}%s рублей\n\
{993333}Начальная ставка: {FFFFFF}%s рублей\n{993333}Ставка сделана от: {FFFFFF}%s\n\
{993333}До конца торгов осталось: {FFFFFF}%d секунд",
            contid,
            g_RegionData[cInfo[contid][ContRegion]][RegionName],
            (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"),
            betstr, moneystr, cInfo[contid][BetedName], cInfo[contid][SaleTime]);
    }
					else
    {
        format(strwerton, sizeof strwerton,
            "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n\
{993333}Статус: {FFFFFF}торги за контейнер открыты\n{993333}Начальная ставка: {FFFFFF}%s рублей",
            contid,
            g_RegionData[cInfo[contid][ContRegion]][RegionName],
            (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"),
            moneystr);
    }

        UpdateDynamic3DTextLabelText(ContsText[contid], CLR_RED, strwerton);
    }
					else // Торги окончены
    {
        KillTimer(ContsTimer[contid]);
        ContsTimer[contid] = 0;
        cInfo[contid][Saled] = false;
        
        if (cInfo[contid][BetedId] != INVALID_PLAYER_ID)
        {
            new winnerid = cInfo[contid][BetedId];
            new winner_name[MAX_PLAYER_NAME];
            GetPlayerName(winnerid, winner_name, sizeof(winner_name));

            new Float:door1X = cContsPos[contid-1][4];
            new Float:door1Y = cContsPos[contid-1][5];
            new Float:door1Z = cContsPos[contid-1][6];
            new Float:door1A = cContsPos[contid-1][7];
            
            new Float:door2X = cContsPos[contid-1][8];
            new Float:door2Y = cContsPos[contid-1][9];
            new Float:door2Z = cContsPos[contid-1][10];
            new Float:door2A = cContsPos[contid-1][11];
            
            if(cInfo[contid][ItemType] == 2)
            {
                new colors[] = {1, 10, 22, 53, 50}; // 0-черный, 1-белый, 10-красный, 22-розовый, 53-желтый, 50-зеленый
                cInfo[contid][ContVehicleColor] = colors[random(sizeof(colors))];
                TextDrawSetPreviewVehCol(cont_model[contid], cInfo[contid][ContVehicleColor], 1);
                new Float:vehicle_spawn_z = cContsPos[contid-1][2] + 0.60;
                new Float:vehicle_spawn_x = cContsPos[contid-1][0];
                new Float:vehicle_spawn_y = cContsPos[contid-1][1];
                new Float:vehicle_spawn_a = cContsPos[contid-1][3] + 90.0;
                cInfo[contid][ContVehicleId] = CreateVehicle(cInfo[contid][Item], vehicle_spawn_x, vehicle_spawn_y, vehicle_spawn_z, vehicle_spawn_a, cInfo[contid][ContVehicleColor], 1, 0);
                SetVehicleParamsEx(cInfo[contid][ContVehicleId], false, false, false, true, false, false, false);
                ChangeVehicleColor(cInfo[contid][ContVehicleId], cInfo[contid][ContVehicleColor], 0);
            }
					else // Если приз не автомобиль (то есть одежда)
            {
                new Float:contX = cContsPos[contid-1][0];
                new Float:contY = cContsPos[contid-1][1];
                new Float:contZ = cContsPos[contid-1][2];
                new Float:contRot = cContsPos[contid-1][3];
                cInfo[contid][ContObjectOdejdaId] = CreateObject(959, contX, contY, contZ, 0.0, 0.0, contRot);
            }
            // ==========================================
            
            new str_win[270];
            new balansestr[15];
            ConvertMoney(cInfo[contid][BetPrice], balansestr);
            format(str_win, sizeof(str_win), " {ffffff}Вы успешно выиграли контейнер{FF5252} #%d{ffffff}! С вашего счета списано {FF5252}%s {ffffff}рублей.", contid, balansestr);
            SendClientMessage(winnerid, CLR_YELLOW, str_win);
            
            new moneystr[15];
            ConvertMoney(cInfo[contid][BetPrice], moneystr);
            new strwerton[300];
            format(strwerton, sizeof(strwerton), "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги окончены\n{993333}Последняя попедная ставка: {FFFFFF}%s рублей\n{993333}Победитель торгов: {FFFFFF}%s\n{993333}Введите: {FFFFFF}/cont", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr, winner_name);
            UpdateDynamic3DTextLabelText(ContsText[contid], CLR_GREEN, strwerton);

            MoveObject(cInfo[contid][ContObjectDoorLId], door1X, door1Y, door1Z, 8.5, 0, 0, door1A + 128.0);
            MoveObject(cInfo[contid][ContObjectDoorRId], door2X, door2Y, door2Z, 8.5, 0, 0, door2A - 128.0);

            if(ContsRespawnTimer[contid] != 0) KillTimer(ContsRespawnTimer[contid]);
            ContsRespawnTimer[contid] = SetTimerEx("SpawnNewCont", 60000, false, "i", contid);
        }
					else
        {
            new moneystr[15];
            ConvertMoney(cInfo[contid][ContPrice], moneystr);
            new strwerton[256];
            format(strwerton, sizeof strwerton, "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n{993333}Статус: {FFFFFF}торги не состоялись\n{993333}Начальная ставка: {FFFFFF}%s рублей", contid, g_RegionData[cInfo[contid][ContRegion]][RegionName], (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"), moneystr);
            UpdateDynamic3DTextLabelText(ContsText[contid], CLR_YELLOW, strwerton);

            SpawnNewCont(contid);
        }
    }
    ContNewSystem_RefreshViewers(contid);
    return 1;
}

stock ResetContInfo(contid)
{
    ContNewSystem_ResetContainerRuntime(contid);
    DestroyObject(cInfo[contid][ContObjectId]);
    DestroyObject(cInfo[contid][ContObjectDoorLId]);
    DestroyObject(cInfo[contid][ContObjectDoorRId]);
    DestroyObject(cInfo[contid][ContObjectOdejdaId]);
    DestroyObject(cInfo[contid][ContObjectDoorLId]);
    DestroyObject(cInfo[contid][ContObjectDoorRId]);
    DestroyObject(cInfo[contid][ContObjectOdejdaId]);
    DestroyVehicle(cInfo[contid][ContVehicleId]);
    if(ContsRespawnTimer[contid] != 0) KillTimer(ContsRespawnTimer[contid]);
    ContsRespawnTimer[contid] = 0;
    KillTimer(ContsTimer[contid]);
    ContsTimer[contid] = 0;
    UpdateDynamic3DTextLabelText(ContsText[contid], CLR_RED, "");
    
    for(new i = 0; i < 17; i++) 
    {
        cInfo[contid][i] = 0;
    }
    cInfo[contid][BetedId] = INVALID_PLAYER_ID;
    cInfo[contid][Saled] = false;
    return 1;
}

public CorrectTimerMinute()
{
    for(new cont = 1; cont <= MAX_CONT; cont++)
    {
        // Резервное восстановление: поднимаем контейнер только если слот реально пуст
        if(cInfo[cont][Saled] == false
            && cInfo[cont][BetedId] == INVALID_PLAYER_ID
            && cInfo[cont][ContObjectId] == 0
            && cInfo[cont][ContObjectDoorLId] == 0
            && cInfo[cont][ContObjectDoorRId] == 0
            && cInfo[cont][ContObjectOdejdaId] == 0
            && cInfo[cont][ContVehicleId] == 0
            && ContsTimer[cont] == 0
            && ContsRespawnTimer[cont] == 0)
        {
            SpawnCont(cont);
        }
    }
    return 1;
}

CMD:cont(playerid)
{
    new contid = ContNewSystem_GetNearestContainer(playerid);
    if(contid) return ContNewSystem_OpenNative(playerid, contid);

    SendClientMessage(playerid, CLR_RED, "Подойдите ближе к контейнеру.");
    return 1;
}

stock StartCont()
{
    print("=== Доставка контейнеров в порт | VING RUSSIA ===");
    StopCont();
    for(new cont=1; cont <= MAX_CONT; cont++)
    {
        SpawnCont(cont);
    }
    
    /*foreach(new i:Player)
    {
        CancelSelectTextDraw(i);
        TogglePlayerHudElement(i, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
        TogglePlayerHudElement(i, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
    }*/
}

stock StopCont()
{
    for(new cont=1; cont <= MAX_CONT; cont++)
    {
        DestroyObject(cInfo[cont][ContObjectId]);
        DestroyObject(cInfo[cont][ContObjectDoorLId]);
        DestroyObject(cInfo[cont][ContObjectDoorRId]);
        DestroyObject(cInfo[cont][ContObjectOdejdaId]);
        DestroyVehicle(cInfo[cont][ContVehicleId]);
        KillTimer(ContsTimer[cont]);
        ResetContInfo(cont);

        TextDrawHideForAll(cont_name[cont]);
        TextDrawHideForAll(cont_price[cont]);
        TextDrawHideForAll(cont_model[cont]);
    }
    TextDrawHideForAll(cont_fon);
    TextDrawHideForAll(cont_take);
    TextDrawHideForAll(cont_sell);
    TextDrawHideForAll(cont_close);
    /*foreach(new i:Player)
    {
        CancelSelectTextDraw(i);
        TogglePlayerHudElement(i, HUD_ELEMENT_CHAT, HUD_ELEMENT_SHOW);
        TogglePlayerHudElement(i, HUD_ELEMENT_MAP, HUD_ELEMENT_SHOW);
    }*/
}

stock StartContBidding(contid)
{
    if(ContNewSystem_StartBidding(contid)) return 1;
    cInfo[contid][SaleTime] = 30;
    KillTimer(ContsTimer[contid]);

    new moneystr[32], betstr[32];
    ConvertMoney(cInfo[contid][ContPrice], moneystr);
    ConvertMoney(cInfo[contid][BetPrice], betstr);

    new strwerton[650];
    if (cInfo[contid][BetedId] != INVALID_PLAYER_ID)
    {
        format(strwerton, sizeof strwerton,
            "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n\
{993333}Статус: {FFFFFF}идут активные торги\n{993333}Последняя ставка: {FFFFFF}%s рублей\n\
{993333}Начальная ставка: {FFFFFF}%s рублей\n{993333}Ставка сделана от: {FFFFFF}%s\n\
{993333}До конца торгов осталось: {FFFFFF}%d секунд",
            contid,
            g_RegionData[cInfo[contid][ContRegion]][RegionName],
            (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"),
            betstr, moneystr, cInfo[contid][BetedName], cInfo[contid][SaleTime]);
    }
					else
    {
        format(strwerton, sizeof strwerton,
            "{993333}Контейнер #%d\n\nСтрана отправитель: {FFFFFF}%s\n{993333}Содержимое контейнера: {FFFFFF}%s\n\
{993333}Статус: {FFFFFF}торги за контейнер открыты\n{993333}Начальная ставка: {FFFFFF}%s рублей",
            contid,
            g_RegionData[cInfo[contid][ContRegion]][RegionName],
            (cInfo[contid][ItemType] == 1) ? ("Одежда") : ("Транспортное средство"),
            moneystr);
    }

    UpdateDynamic3DTextLabelText(ContsText[contid], CLR_RED, strwerton);

    ContsTimer[contid] = SetTimerEx("TimerSecondUpdateCont", 1000, true, "ds", contid, moneystr);
    ContNewSystem_RefreshViewers(contid);
    return 1;
}

stock GivePlayerOwnableSkinEx(playerid, skinid)
{
    new query[256], accountid = GetPlayerAccountID(playerid);
    mysql_format(mysql, query, sizeof(query), "INSERT INTO invskins (account_id, internal_id, modelid) VALUES (%d, %d, %d) ON DUPLICATE KEY UPDATE modelid = VALUES(modelid), purchased_at = CURRENT_TIMESTAMP", accountid, skinid, skinid);
    mysql_tquery(mysql, query);

    SetPlayerData(playerid, P_SKIN, skinid);
    UpdatePlayerDatabaseInt(playerid, "skin", skinid);
    SetPlayerSkinInit(playerid);

    SendClientMessage(playerid, 0x90EE90FF, "Скин автоматически надет.");
    return 1;
}
stock ContNewSystem_GiveVehicleReward(playerid, contid)
{
    new car_modelid = cInfo[contid][Item];
    new car_color = cInfo[contid][ContVehicleColor];
    new Float:pos_x, Float:pos_y, Float:pos_z, Float:angle;
    new query[256], Cache:result;

    GetContainerRewardParkPosition(pos_x, pos_y, pos_z, angle);

    format(query, sizeof query, "INSERT INTO ownable_cars (owner_id, model_id, color_1, color_2, pos_x, pos_y, pos_z, angle, create_time) VALUES ('%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%d')",
        GetPlayerAccountID(playerid), car_modelid, car_color, car_color, pos_x, pos_y, pos_z, angle, gettime());

    result = mysql_query(mysql, query, true);
    cache_delete(result);
    return 1;
}

public SpawnNewCont(contid)
{
    if(contid < 1 || contid > MAX_CONT) return 1;
    ContsRespawnTimer[contid] = 0;
    ResetContInfo(contid);
    SpawnCont(contid);
    ContNewSystem_RefreshViewers(contid);
    return 1;
}

CMD:startcont(playerid)
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;
    StartCont();
    ShowNotificationNew(playerid, 4, 6, 0, 0, "Успешно Запущены Контейнера", ">>");
    return 1;
}

CMD:stopcont(playerid)
{
    if(GetPlayerAdminEx(playerid) < 8) return 1;
    StopCont();
    ShowNotificationNew(playerid, 4, 6, 0, 0, "Успешно Остановлены Контейнера", ">>");
    return 1;
}
stock IsPlayerNearContainer(playerid)
{
    // V11 container realfix: do not depend only on Streamer area state.
    // The mobile interaction RPC can arrive on the same tick as area enter,
    // so use the same nearest-point check as /cont as a reliable fallback.
    return ContNewSystem_GetNearestContainer(playerid) != 0;
}
