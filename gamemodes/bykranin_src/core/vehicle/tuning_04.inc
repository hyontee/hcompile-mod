//>> Файл: bykranin_src/core/vehicle/tuning_04.inc  (928 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: /tuning, SetVehicleDifferential, SetVehicleDifferentialFP, /sport, SetVehicleTint, SetVehicleTintForPlayer, /tint
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:tuning(playerid, params[])
{
    new str[512];
    format(str, sizeof(str),
        "Тонировка\n\
        SPORT+ ON\n\
        SPORT+ OFF\n\
        Гидравлика\n\
        Музыка (вкл)\n\
        Музыка (выкл)\n\
        Номера\n\
        Launch Control\n\
        Подсветка\n\
        Спидометр\n\
        Неон\n\
        Drift ON\n\
        Drift OFF\n"
    );

    ShowPlayerDialog(playerid, DIALOG_TUNING, DIALOG_STYLE_LIST, 
        "Меню тюнинга", str, "Выбрать", "Закрыть");
    return 1;
}

stock SetVehicleDifferential(vehicleid, type, setvalue=0)
{
    if(setvalue) vInfo[vehicleid][vDifferential] = type;
    foreach(new playerid: Player) SetVehicleDifferentialFP(playerid, vehicleid, type);
}

stock SetVehicleDifferentialFP(playerid, vehicleid, type)
{
    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 15); // type = дифференциал

    BS_WriteValue(bitstream, PR_UINT8, type); // 0 = COMFORT, 1 = SPORT

    PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}

// Команда для применения SPORT
CMD:sport(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid != INVALID_VEHICLE_ID) SetVehicleDifferential(vehicleid, 2, 1);
    return 1;
}

stock SetVehicleTint(vehicleid, level, setvalue=0)
{
    if(setvalue)
    {
        vInfo[vehicleid][vTint] = level;
    }
    foreach(new playerid: Player) SetVehicleTintForPlayer(playerid, vehicleid, level);
}

stock SetVehicleTintForPlayer(playerid, vehicleid, level)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 10);   // тип тюна (тонировка)

    BS_WriteValue(bs, PR_UINT8, level); // уровень тонировки

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}

CMD:tint(playerid, params[])
{
    new level;
    if(sscanf(params, "i", level)) 
        return SendClientMessage(playerid, -1, !"Используй: /tint [уровень 0-3]");

    if(level < 0 || level > 3) 
        return SendClientMessage(playerid, -1, !"Уровень может быть от 0 (без) до 3 (макс)");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid) return SendClientMessage(playerid, -1, !"Ты не в машине!");

    SetVehicleTint(vehicleid, level, 1);
    new msg[64];
    format(msg, sizeof(msg), !"Тонировка установлена на уровень %d", level);
    SendClientMessage(playerid, -1, msg);
    return 1;
}

stock SetVehicleVinyl(vehicleid, newvinylid, setvalue=0)
{
    if(setvalue)
    {
        vInfo[vehicleid][vVinyl] = newvinylid;
    }
}

stock SetVehicleVinylForPlayer(playerid, vehicleid, const vinyl[])
{
    if(!IsPlayerConnected(playerid) || !IsValidVehicle(vehicleid)) return 0;
    new bounded_vinyl[32];
    format(bounded_vinyl, sizeof bounded_vinyl, "%s", vinyl);
    new BitStream:bs = BS_New();

    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT8, 12); // тип тюна (винил)

    new len = strlen(bounded_vinyl);
    if (len > 31) len = 31; // клиентская защита

    BS_WriteValue(bs, PR_UINT8, len);      // длина строки
    BS_WriteValue(bs, PR_STRING, bounded_vinyl);  // Payload length matches the advertised length.

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}



CMD:vinyl(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid) return SendClientMessage(playerid, -1, !"Ты не в машине!");

    new vinylname[32];
    if(sscanf(params, "s[32]", vinylname))
        return SendClientMessage(playerid, -1, !"Использование: /vinyl [название_винила]");

    SetVehicleVinylForPlayer(playerid, vehicleid, vinylname);
    
    new message[128];
    format(message, sizeof(message), !"Винил '%s' установлен!", vinylname);
    SendClientMessage(playerid, -1, message);
    return 1;
}
stock SetVehicleStroboscopee(vehicleid, type, setvalue=0)
{
  if(setvalue) vInfo[vehicleid][vStrob] = type;
  foreach(new playerid: Player) SetVehicleStroboscopeForPlayer(playerid, vehicleid, type);
}

stock SetVehicleStroboscopeForPlayere(playerid, vehicleid, type)
{
  new BitStream:bitstream = BS_New();
  BS_WriteValue(bitstream, PR_UINT16, vehicleid);
  BS_WriteValue(bitstream, PR_UINT8, 19);

  BS_WriteValue(bitstream, PR_UINT32, type);

  PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
  BS_Delete(bitstream);
}


stock SetVehicleStroboscope(vehicleid, type, setvalue=0)
{
  if(setvalue) vInfo[vehicleid][vStrob] = type;
  foreach(new playerid: Player) SetVehicleStroboscopeForPlayer(playerid, vehicleid, type);
}

stock SetVehicleStroboscopeForPlayer(playerid, vehicleid, type)
{
  new BitStream:bitstream = BS_New();
  BS_WriteValue(bitstream, PR_UINT16, vehicleid);
  BS_WriteValue(bitstream, PR_UINT8, 19);

  BS_WriteValue(bitstream, PR_UINT32, type);

  PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
  BS_Delete(bitstream);
}

CMD:strab(playerid)
{
  new vehicleid = GetPlayerVehicleID(playerid);
  
  SetVehicleStroboscope(vehicleid, 2, 1);
  
  return 1;
}


CMD:strab1(playerid)
{
  new vehicleid = GetPlayerVehicleID(playerid);
  
  SetVehicleStroboscope(vehicleid, 4, 1);
  
  return 1;
}

stock SetVehicleExhaust(vehicleid, type, setvalue=0)
{
	foreach(new playerid: Player) SetVehicleExhaustForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleExhaustForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 24);

	BS_WriteValue(bitstream, PR_UINT16, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

CMD:vihlop(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new type;
    sscanf(params, "i", type);
    SetVehicleExhaustForPlayer(playerid, vehicleid, type);
    return 1;
}



CMD:vihlop2(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleExhaustForPlayer(playerid, vehicleid, 2);
}

CMD:vihlop3(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleExhaustForPlayer(playerid, vehicleid, 3);
}

CMD:vihlop4(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleExhaustForPlayer(playerid, vehicleid, 4);
}
stock SetPlayerIntera7(playerid, rpcid, value)
{
    if(IsPlayerConnected(playerid))
    {
        new fmt_text[128];
    }

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT8, rpcid);

    BS_WriteValue(bitstream, PR_UINT8, value);

    PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
}
CMD:rpcidd(playerid, params[])
{
 extract params -> new rpcid; else return Send(playerid, -1, "Используйте: /rpcidd [rpc айди]");
 
 SetPlayerIntera7(playerid, rpcid, 1);
 
 return 1;
}


// ===== Хендлинг-предустановки =====
new Float:PresetMaxSpeed[4]       = {220.0, 250.0, 200.0, 180.0};
new Float:PresetAcceleration[4]   = {1.0, 1.2, 0.9, 0.7};
new Float:PresetBrake[4]          = {0.8, 0.9, 0.7, 0.9};
new Float:PresetSuspension[4]     = {0.8, 0.85, 0.7, 0.6};
new Float:PresetSuspensionBias[4] = {0.5, 0.55, 0.6, 0.5};
new Float:PresetSteering[4]       = {35.0, 38.0, 45.0, 30.0};

// ===== Стоки для отправки хендлинга =====
stock ApplyVehicleHandlingForPlayer(playerid, vehicleid, presetid)
{
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT16, vehicleid);

    // RPC ID 167
    BS_WriteValue(bs, PR_UINT8, 1); // Suspension Force
    BS_WriteValue(bs, PR_FLOAT, PresetSuspension[presetid]);

    BS_WriteValue(bs, PR_UINT8, 2); // Suspension Bias
    BS_WriteValue(bs, PR_FLOAT, PresetSuspensionBias[presetid]);

    BS_WriteValue(bs, PR_UINT8, 4); // Max Speed
    BS_WriteValue(bs, PR_FLOAT, PresetMaxSpeed[presetid]);

    BS_WriteValue(bs, PR_UINT8, 5); // Engine Acceleration
    BS_WriteValue(bs, PR_FLOAT, PresetAcceleration[presetid]);

    BS_WriteValue(bs, PR_UINT8, 6); // Brake
    BS_WriteValue(bs, PR_FLOAT, PresetBrake[presetid]);

    BS_WriteValue(bs, PR_UINT8, 7); // Steering Lock
    BS_WriteValue(bs, PR_FLOAT, PresetSteering[presetid]);

    PR_SendRPC(bs, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
}


stock ApplyVehicleHandling(vehicleid, presetid)
{
    new playerid;
    for(playerid = 0; playerid < MAX_PLAYERS; playerid++)
    {
        if(IsPlayerConnected(playerid) && IsPlayerInVehicle(playerid, vehicleid))
            ApplyVehicleHandlingForPlayer(playerid, vehicleid, presetid);
    }
}
CMD:sportplus(playerid, params[])
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "You are not in a vehicle!");
    ApplyVehicleHandling(GetPlayerVehicleID(playerid), 1);
    SendClientMessage(playerid, 0x00FF00AA, "Sport+ handling applied.");
    return 1;
}
public CheckPlayerInVehicle(playerid, vehicleid, idx)
{
    if(IsPlayerInVehicle(playerid, vehicleid))
    {
        if(PlayerVehicleTimer[playerid] != -1)
        {
            KillTimer(PlayerVehicleTimer[playerid]);
            PlayerVehicleTimer[playerid] = -1;
        }
        return 1;
    }

    if(IsValidVehicle(vehicleid))
    {
        DestroyVehicle(vehicleid);
    }

    new null_string[8] = "------";
    strmid(g_ownable_car[idx][OC_NUMBER], null_string, 0, 8, 8);
    SetOwnableCarData(idx, OC_OWNER_ID, 0);
    SetOwnableCarData(idx, OC_MODEL_ID, 0);
    SetOwnableCarData(idx, OC_COLOR_1, 0);
    SetOwnableCarData(idx, OC_COLOR_2, 0);
    SetOwnableCarData(idx, OC_POS_X, 0.0);
    SetOwnableCarData(idx, OC_POS_Y, 0.0);
    SetOwnableCarData(idx, OC_POS_Z, 0.0);
    SetOwnableCarData(idx, OC_ANGLE, 0.0);
    SetOwnableCarData(idx, OC_ALARM, false);
    SetOwnableCarData(idx, OC_KEY_IN, false);
    SetOwnableCarData(idx, OC_CREATE, 0);
    format(g_ownable_car[idx][OC_OWNER_NAME], 21, "");

    SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
    PlayerVehicleTimer[playerid] = -1;

    return 1;
}

public GiveTestCar(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 1;

    new modelid = 411; // Тестовая машина (Infernus)
    new color_1 = 15, color_2 = 15;

    new Float:pos_x = 670.876708;
    new Float:pos_y = 2641.707763;
    new Float:pos_z = 13.399374;
    new Float:angle = 41.468193;

    new old_vehicleid = GetPlayerData(playerid, P_OWNABLE_CAR);
    if(old_vehicleid != INVALID_VEHICLE_ID)
    {
        DestroyVehicle(old_vehicleid);
        new old_idx = GetVehicleData(old_vehicleid, V_ACTION_ID);
        if(old_idx != -1)
        {
            new null_string[8] = "------";
            strmid(g_ownable_car[old_idx][OC_NUMBER], null_string, 0, 8, 8);
            SetOwnableCarData(old_idx, OC_OWNER_ID, 0);
            SetOwnableCarData(old_idx, OC_MODEL_ID, 0);
            SetOwnableCarData(old_idx, OC_COLOR_1, 0);
            SetOwnableCarData(old_idx, OC_COLOR_2, 0);
            SetOwnableCarData(old_idx, OC_POS_X, 0.0);
            SetOwnableCarData(old_idx, OC_POS_Y, 0.0);
            SetOwnableCarData(old_idx, OC_POS_Z, 0.0);
            SetOwnableCarData(old_idx, OC_ANGLE, 0.0);
            SetOwnableCarData(old_idx, OC_ALARM, false);
            SetOwnableCarData(old_idx, OC_KEY_IN, false);
            SetOwnableCarData(old_idx, OC_CREATE, 0);
            format(g_ownable_car[old_idx][OC_OWNER_NAME], 21, "");
        }
    }

    new idx = GetFreeOwnableCarID();
    if(idx == -1)
    {
        return 1;
    }

    SetOwnableCarData(idx, OC_OWNER_ID, GetPlayerAccountID(playerid));
    SetOwnableCarData(idx, OC_MODEL_ID, modelid);
    SetOwnableCarData(idx, OC_COLOR_1, color_1);
    SetOwnableCarData(idx, OC_COLOR_2, color_2);
    SetOwnableCarData(idx, OC_POS_X, pos_x);
    SetOwnableCarData(idx, OC_POS_Y, pos_y);
    SetOwnableCarData(idx, OC_POS_Z, pos_z);
    SetOwnableCarData(idx, OC_ANGLE, angle);

    new null_string[8] = "------";
    strmid(g_ownable_car[idx][OC_NUMBER], null_string, 0, 8, 8);

    SetOwnableCarData(idx, OC_ALARM, false);
    SetOwnableCarData(idx, OC_KEY_IN, false);
    SetOwnableCarData(idx, OC_CREATE, gettime());

    format(g_ownable_car[idx][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    new vehicleid = CreateVehicle
    (
        GetOwnableCarData(idx, OC_MODEL_ID),
        GetOwnableCarData(idx, OC_POS_X),
        GetOwnableCarData(idx, OC_POS_Y),
        GetOwnableCarData(idx, OC_POS_Z),
        GetOwnableCarData(idx, OC_ANGLE),
        GetOwnableCarData(idx, OC_COLOR_1),
        GetOwnableCarData(idx, OC_COLOR_2),
        -1,
        0,
        VEHICLE_ACTION_TYPE_OWNABLE_CAR,
        idx
    );

    if(vehicleid != INVALID_VEHICLE_ID)
    {
        format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
        SetVehicleColor(vehicleid, GetVehicleRGBAColorById(color_1), GetVehicleRGBAColorById(color_2), 1);
        ApplyOwnableCarStoredPlate(vehicleid, idx);
        SetVehicleParam(vehicleid, V_LOCK, false);
        SetVehicleData(vehicleid, V_MILEAGE, 0.0);
							SetVehicleData(vehicleid, V_FUEL, 40.0);
        SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);

        PlayerVehicleTimer[playerid] = SetTimerEx("CheckPlayerInVehicle", 60000, false, "iii", playerid, vehicleid, idx);
    }

    return 1;
}


CMD:zz(playerid)
{

   SendClientMessage(playerid, -1, "SPORT+ вкл");

   new vehicleid = GetPlayerVehicleID(playerid);
}
CMD:zzoff(playerid)
{

   SendClientMessage(playerid, -1, "SPORT+ выкл");

   new vehicleid = GetPlayerVehicleID(playerid);
}
CMD:testgui(playerid, params[])
{
    if(isnull(params))
    {
        SendClientMessage(playerid, -1, "Использование: /testgui [guiid]");
        SendClientMessage(playerid, -1, "Пример: /testgui 1 - вызов интерфейса с ID 1");
        return 1;
    }
    
    new guiid = strval(params);
    
    new JSON:json = JSON_Object();
    JSON_SetInt(json, "o", 1); // 
    ShowPlayerGUI(playerid, guiid, json);
    
    new msg[64];
    format(msg, sizeof(msg), "Вызван интерфейс с ID %d", guiid);
    SendClientMessage(playerid, -1, msg);
    
    return 1;
}

stock IsValidSkinModel(modelid)
{
    if (modelid < 0 || modelid > 10000000) return 0;
    if (modelid == 3 || modelid == 4 || modelid == 5 || modelid == 6 || modelid == 8) return 0;
    return 1;
}

CMD:cases(playerid, params[])
{
    new type, status, caseId;
    
    // Проверка параметров: type, status, [caseId]
    if (sscanf(params, "iiI(0)", type, status, caseId))
    {
        SendClientMessage(playerid, -1, "Usage: /cases [type] [status] [caseId]");
        SendClientMessage(playerid, -1, "Example: /cases 5 0 1");
        return 1;
    }

    // Создание JSON-ответа
    new JSON:response = JSON_Object();
    
    // Установка основных полей
    JSON_SetInt(response, "t", type); // Тип кейса (например, 5, как в примере)
    JSON_SetInt(response, "s", status); // Статус (0, 2, как в примере)
    JSON_SetInt(response, "pi", playerid); // ID игрока
    JSON_SetString(response, "pn", GetPlayerNameEx(playerid)); // Имя игрока
    JSON_SetInt(response, "id", caseId); // ID кейса (из Case.id)
    JSON_SetString(response, "n", "Test Case"); // Название кейса (Case.name)
    
    // Дополнительные поля из модели Case
    JSON_SetInt(response, "count", 1); // Case.count
    JSON_SetInt(response, "isSale", 0); // Case.isSale (0 = false)
    JSON_SetInt(response, "discountType", 1); // Case.discountType
    
    // Массив цен (Case.price)
    new JSON:priceList = JSON_Array();
    JSON_Append(priceList, JSON_Int(100)); // Цена за 1 кейс
    JSON_Append(priceList, JSON_Int(1000)); // Цена за 10 кейсов
    JSON_SetObject(response, "price", priceList);
    
    // Массив скидок (Case.discount)
    new JSON:discountList = JSON_Array();
    JSON_Append(discountList, JSON_Int(10)); // Скидка для 1 кейса
    JSON_Append(discountList, JSON_Int(100)); // Скидка для 10 кейсов
    JSON_SetObject(response, "discount", discountList);
    
    // Массив наград (CaseReward)
    new JSON:rewardList = JSON_Array();
    new JSON:reward1 = JSON_Object();
    JSON_SetInt(reward1, "rewardId", 101); // CaseReward.rewardId
    JSON_SetString(reward1, "name", "Rare Item");
    JSON_SetInt(reward1, "rarity", 3); // CommonRarityEnum.RARE
    JSON_Append(rewardList, reward1);
    
    new JSON:reward2 = JSON_Object();
    JSON_SetInt(reward2, "rewardId", 102);
    JSON_SetString(reward2, "name", "Epic Item");
    JSON_SetInt(reward2, "rarity", 2); // CommonRarityEnum.EPIC
    JSON_Append(rewardList, reward2);
    
    JSON_SetObject(response, "caseRewardList", rewardList);
    
    // Массив бонусов (CaseBonus)
    new JSON:bonusList = JSON_Array();
    new JSON:bonus1 = JSON_Object();
    JSON_SetInt(bonus1, "id", 201); // CaseBonus.id
    JSON_SetString(bonus1, "name", "Bonus Item 1");
    JSON_SetInt(bonus1, "rarity", 1); // CommonRarityEnum.LEGENDARY
    JSON_SetInt(bonus1, "state", status); // CaseBonus.state (синхронизировано с параметром)
    JSON_Append(bonusList, bonus1);
    
    new JSON:bonus2 = JSON_Object();
    JSON_SetInt(bonus2, "id", 202);
    JSON_SetString(bonus2, "name", "Bonus Item 2");
    JSON_SetInt(bonus2, "rarity", 2); // CommonRarityEnum.EPIC
    JSON_SetInt(bonus2, "state", status);
    JSON_Append(bonusList, bonus2);
    
    JSON_SetObject(response, "caseBonusList", bonusList);
    
    // Массив бонусных наград со статусом (BonusRewardWithStatus)
    new JSON:bonusRewardList = JSON_Array();
    new JSON:bonusReward1 = JSON_Object();
    JSON_SetInt(bonusReward1, "id", 301); // BonusRewardWithStatus.idReward
    JSON_SetInt(bonusReward1, "state", status); // BonusRewardWithStatus.stateReward
    JSON_Append(bonusRewardList, bonusReward1);
    
    JSON_SetObject(response, "bonusRewards", bonusRewardList);
    
    // Отображение GUI
    ShowPlayerGUI(playerid, 73, response);
    
    // Очистка памяти
    JSON_Cleanup(response);
    
    // Сообщение игроку
    SendClientMessage(playerid, -1, "Case GUI opened! Check the interface.");
    
    return 1;
}
CMD:npc(playerid, params[])
{
    // Создание JSON-пакета для NPC взаимодействия
    new JSON:json = JSON_Object();
    
    // Основные поля для интерфейса
    JSON_SetInt(json, "t", 0);  // Тип диалога (0 для начального экрана)
    JSON_SetInt(json, "s", 1);  // screen = 1 (открытие диалога)
    JSON_SetString(json, "pn", GetPlayerNameEx(playerid));  // Имя игрока
    JSON_SetInt(json, "pi", playerid);  // ID игрока
    JSON_SetString(json, "tt", "NPC Interaction");  // textTitle
    JSON_SetString(json, "td", "Welcome to the NPC interface! Choose an option.");  // textDesc
    JSON_SetInt(json, "ts", 30);  // typingSpeed = 30ms
    JSON_SetBool(json, "st", false);  // isSkipText = false
    JSON_SetInt(json, "r", 122);  // renderId = 122 (ID скина NPC)

    // Массив тестовых кнопок (bt)
    new JSON:buttonList = JSON_Array();
    
    // Кнопка 1: Тестовая "Accept" (зеленая)
    new JSON:btn1 = JSON_Object();
    JSON_SetInt(btn1, "k", INTERACTION_WITH_NPC_BUTTON_GREEN);  // key = 1 (green)
    JSON_SetString(btn1, "n", "Accept");  // name
    JSON_SetInt(btn1, "i", 1);  // id = 1
    JSON_Append(buttonList, btn1);
    
    // Кнопка 2: Тестовая "Decline" (красная)
    new JSON:btn2 = JSON_Object();
    JSON_SetInt(btn2, "k", INTERACTION_WITH_NPC_BUTTON_RED);  // key = 3 (red)
    JSON_SetString(btn2, "n", "Decline");  // name
    JSON_SetInt(btn2, "i", 2);  // id = 2
    JSON_Append(buttonList, btn2);
    
    // Кнопка 3: Тестовая "Info" (серая)
    new JSON:btn3 = JSON_Object();
    JSON_SetInt(btn3, "k", INTERACTION_WITH_NPC_BUTTON_GRAY);  // key = 2 (gray)
    JSON_SetString(btn3, "n", "Info");  // name
    JSON_SetInt(btn3, "i", 3);  // id = 3
    JSON_Append(buttonList, btn3);
    
    // Кнопка 4: Тестовая "Skip" (пропуск)
    new JSON:btn4 = JSON_Object();
    JSON_SetInt(btn4, "k", INTERACTION_WITH_NPC_BUTTON_SKIP);  // key = 0 (skip)
    JSON_SetString(btn4, "n", "Skip");  // name
    JSON_SetInt(btn4, "i", 4);  // id = 4
    JSON_Append(buttonList, btn4);
    
    JSON_SetArray(json, "bt", buttonList);

    // Отправка в GUI
    ShowPlayerGUI(playerid, 63, json);
    
    // Очистка памяти
    ~json;
    
    // Сообщение игроку
    SendClientMessage(playerid, -1, "NPC interaction GUI opened with skin ID 122!");
    
    return 1;
}
CMD:tuning3(playerid)
{
    if (!IsPlayerInAnyVehicle(playerid)) {
        SendClientMessage(playerid, 0xFF0000FF, "Вы должны находиться в транспорте!");
        return 1;
    }

    new JSON:json = JSON_Object(), data[512];
    JSON_SetInt(json, "t", 0);
    JSON_SetInt(json, "s", 1);
    JSON_SetString(json, "nt", "Интерфейс тюнинга открыт!");
    JSON_SetInt(json, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json, "d", GetPlayerDonateRub(playerid));

    ShowPlayerGUI(playerid, 28, json);
    ~json;
    return 1;
}

CMD:tuning2(playerid, params[])
{
    new JSON:tuning_json = JSON_Object();

    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "t", 0);
    JSON_SetInt(tuning_json, "j", 1000);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    // JSON_SetString(tuning_json, "n", GetVehicleName(GetVehicleModel(GetPlayerVehicleID(playerid))));
    JSON_SetString(tuning_json, "n", ""); // убран GetVehicleNameByModel
    JSON_SetInt(tuning_json, "m", GetPlayerMoney(playerid));

    // Координаты интерьера тюнинг-зала
    new Float:x = 998.23653, Float:y = 1499.67341, Float:z = 1499.66617;
    SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.0); // Поворот машины к камере

    // Установка интерьера
    new interior = 1;
    SetPlayerInterior(playerid, interior);

    // Камера
    SetPlayerCameraPos(playerid, x - 3.0, y + 3.0, z + 1.0);
    SetPlayerCameraLookAt(playerid, x, y, z + 1.0);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}
stock Inventory(playerid)
{
    new JSON:JSONObject = JSON_Object();
    
    JSON_SetInt(JSONObject, "id", 1);
    JSON_SetInt(JSONObject, "s", 1);
    JSON_SetInt(JSONObject, "ga", 1000 + playerid);
    
    ShowPlayerGUI(playerid, GUIUsersInventory, JSONObject);
}

CMD:invbvv(playerid, params[])
{
    Inventory(playerid);
    return 1;
}

cmd:tuning6(playerid, params[])
{
    new vehicleID = GetPlayerVehicleID(playerid);

    if (vehicleID == 0) {
        SendClientMessage(playerid, COLOR_RED, "Вы должны находиться в машине!");
        return 1;
    }
    new price;
    new JSON:tuning_jsonn = JSON_Object();

    JSON_SetInt(tuning_jsonn, "o", 0);
    JSON_SetInt(tuning_jsonn, "w", 3);
    JSON_SetInt(tuning_jsonn, "t", 0);
    JSON_SetInt(tuning_jsonn, "j", 1000);
    JSON_SetString(tuning_jsonn, "nm", GetPlayerNameEx(playerid));
    JSON_SetInt(tuning_jsonn, "m", GetPlayerMoney(playerid));
    JSON_SetInt(tuning_jsonn, "engine", 1);
    JSON_SetInt(tuning_jsonn, "brakes", 2);
    JSON_SetInt(tuning_jsonn, "suspension", 3);
    JSON_SetInt(tuning_jsonn, "wheels", 1);

    new Float:x = 998.23653, Float:y = 1499.67341, Float:z = 1499.66617;
    SetVehiclePos(GetPlayerVehicleID(playerid), x, y, z);
    SetVehicleZAngle(GetPlayerVehicleID(playerid), 270.0);

    new interior = 1;

    SetPlayerInterior(playerid, interior);
    SetPlayerInterior(playerid, interior);

    new carid = GetPlayerVehicleID(playerid);

    if (carid != 0)
    {
        SetVehiclePos(carid, 2508.3931, 1504.2278, 1497.5);
        SendClientMessage(playerid, COLOR_RED, "Ваш автомобиль был перемещен!");
    }
					else
    {
        SendClientMessage(playerid, COLOR_RED, "Вы не находитесь в автомобиле!");
    }

    SetVehiclePos(carid, 1000.0, 1500.0, 1498.0);
    SetVehicleZAngle(carid, 180.0);
    SetPlayerCameraPos(playerid, 1003.9196, 1493.9724, 1499.7500);
    SetPlayerCameraLookAt(playerid, 1003.3480, 1494.7935, 1499.5002);

    if (GetPlayerMoneyEx(playerid) < price)
    {
        SendClientMessage(playerid, COLOR_RED, "Вы успешно пошли нахуй by kmonarchh!");
        return 1;
    }

    GivePlayerMoneyEx(playerid, -price, "Tuning", true, true);
    ShowPlayerGUI(playerid, 28, tuning_jsonn);
    JSON_Cleanup(tuning_jsonn);
    return 1;
}

cmd:tuning5(playerid, params[])
{
    new vehicleID = GetPlayerVehicleID(playerid);

    if (vehicleID == 0) {
        SendClientMessage(playerid, COLOR_RED, "Вы должны находиться в машине!");
        return 1;
    }
    new price;
    new JSON:tuning_jsonn = JSON_Object();

    JSON_SetInt(tuning_jsonn, "o", 0);
    JSON_SetInt(tuning_jsonn, "w", 0);
    JSON_SetInt(tuning_jsonn, "t", 0);
    JSON_SetInt(tuning_jsonn, "j", 1000);
    JSON_SetString(tuning_jsonn, "nm", GetPlayerNameEx(playerid));
    JSON_SetInt(tuning_jsonn, "m", GetPlayerMoney(playerid));
    JSON_SetInt(tuning_jsonn, "engine", 1);
    JSON_SetInt(tuning_jsonn, "brakes", 2);
    JSON_SetInt(tuning_jsonn, "suspension", 3);
    JSON_SetInt(tuning_jsonn, "wheels", 1);

    new carid = GetPlayerVehicleID(playerid);

    if (carid != 0)
    {
        SetVehiclePos(carid, 1000.0, 1500.0, 1498.0);
        SetVehicleZAngle(carid, 180.0);
        SendClientMessage(playerid, COLOR_RED, "Ваш автомобиль был перемещен!");
    }
					else
    {
        SendClientMessage(playerid, COLOR_RED, "Вы не находитесь в автомобиле!");
        return 1;
    }

    new interior = 1;
    SetPlayerInterior(playerid, interior);

    SetPlayerCameraPos(playerid, 1003.9196, 1493.9724, 1499.7500);
    SetPlayerCameraLookAt(playerid, 1003.3480, 1494.7935, 1499.5002);

    if (GetPlayerMoneyEx(playerid) < price)
    {
        SendClientMessage(playerid, COLOR_RED, "Вы успешно пошли нахуй by kmonarchh!");
        return 1;
    }

    GivePlayerMoneyEx(playerid, -price, "Tuning", true, true);
    ShowPlayerGUI(playerid, 28, tuning_jsonn);
    JSON_Cleanup(tuning_jsonn);
    return 1;
}


stock SyncVehicleHornForPlayer(playerid, vehicleid)
{
    if(!IsPlayerConnected(playerid) || vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(GetPlayerVehicleID(playerid) != vehicleid) return 0;

    new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
    new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
    if(action_type != VEHICLE_ACTION_TYPE_OWNABLE_CAR || action_id < 0 || action_id >= MAX_OWNABLE_CARS)
        return 0;

    new horn_id = vInfo[action_id][vHornSound];
    if(horn_id < 0 || horn_id > 40) horn_id = 0;
    SetVehicleHornSoundForPlayer(playerid, vehicleid, horn_id);
    return 1;
}
stock SetVehicleHornSound(vehicleid, horn_id, setvalue=0)
{
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(horn_id < 0 || horn_id > 40) return 0;

    new action_type = GetVehicleData(vehicleid, V_ACTION_TYPE);
    new action_id = GetVehicleData(vehicleid, V_ACTION_ID);
    if(setvalue && action_type == VEHICLE_ACTION_TYPE_OWNABLE_CAR && action_id >= 0 && action_id < MAX_OWNABLE_CARS)
        vInfo[action_id][vHornSound] = horn_id;

    foreach(new playerid : Player)
    {
        if(IsVehicleStreamedIn(vehicleid, playerid) || GetPlayerVehicleID(playerid) == vehicleid)
            SetVehicleHornSoundForPlayer(playerid, vehicleid, horn_id);
    }
    return 1;
}

stock SetVehicleHornSoundForPlayer(playerid, vehicleid, horn_id)
{
    if(!IsPlayerConnected(playerid) || vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(horn_id < 0 || horn_id > 40) return 0;

    new BitStream:bitstream = BS_New();
    BS_WriteValue(bitstream, PR_UINT16, vehicleid);
    BS_WriteValue(bitstream, PR_UINT8, 15);
    BS_WriteValue(bitstream, PR_UINT8, horn_id);
    PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bitstream);
    return 1;
}
CMD:hsound(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleHornSoundForPlayer(playerid, vehicleid, 1);
}
CMD:hsound2(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleHornSoundForPlayer(playerid, vehicleid, 2);
}

CMD:hsound3(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleHornSoundForPlayer(playerid, vehicleid, 3);
}
stock SetVehicleLightColor(vehicleid, color, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vLightColor] = color; 
	foreach(new playerid : streamed_players_in_veh[vehicleid])  SetVehicleLightColorForPlayer(playerid, vehicleid, RGBA_to_ARGB(color)); 
} 

stock SetVehicleLightColorForPlayer(playerid, vehicleid, color)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 8);

	BS_WriteValue(bitstream, PR_UINT32, color);  

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

CMD:strab2(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleStroboscopeForPlayer(playerid, vehicleid, 2);
}

CMD:strab3(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleStroboscopeForPlayer(playerid, vehicleid, 3);
}   
CMD:strab4(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleStroboscopeForPlayer(playerid, vehicleid, 4);
}   
CMD:strab5(playerid)
{
   new vehicleid = GetPlayerVehicleID(playerid);
   SetVehicleStroboscopeForPlayer(playerid, vehicleid, 5);
}   

