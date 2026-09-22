//>> Файл: bykranin_src/core/network/ipacket_252.inc  (6297 строк)
//>> Тема: обработка пакетов/RPC кастомного клиента
//>> Внутри: (данные/макросы)
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
IPacket:252(playerid, BitStream:bitstream)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 0;

    new
        header,
        rpcid,
        data[512],
        outcoming_data[512],
        JSON:json,
        JSON:json_packet_data = JSON_Object(),
        JSON:JSONObject = JSON_Object();

    BS_ReadValue(bitstream, PR_UINT8, header);
    BS_ReadValue(bitstream, PR_UINT16, rpcid);
    // Mobile client can wrap the normal SA-MP GiveTakeDamage RPC inside packet 252.
    // RPC 115 layout: bool take, uint16 player, float damage, uint32 weapon, uint32 bodypart.
    if(rpcid == 115)
    {
        new bool:take_damage;
        new targetid;
        new Float:damage;
        new weaponid;
        new bodypart;

        if(!BS_ReadBool(bitstream, take_damage)) return 1;
        if(!BS_ReadUint16(bitstream, targetid)) return 1;
        if(!BS_ReadFloat(bitstream, damage)) return 1;
        if(!BS_ReadUint32(bitstream, weaponid)) return 1;
        if(!BS_ReadUint32(bitstream, bodypart)) return 1;

        DamageRpc_Handle115(playerid, take_damage, targetid, damage, weaponid, bodypart);
        return 1;
    }
if (rpcid == 111){
	return 1;
}
    #if defined STABILITY_DEBUG_GUI
    printf("[GUI] player=%d header=%d rpc=%d", playerid, header, rpcid);
    #endif

    new length;
    new packet_unread_bits;
    BS_GetNumberOfUnreadBits(bitstream, packet_unread_bits);
    if(packet_unread_bits < 32)
    {
        JSON_Cleanup(json_packet_data);
        JSON_Cleanup(JSONObject);
        return 0;
    }
    BS_ReadValue(bitstream, PR_UINT32, length);
    new auth_unread_bits;
    if(rpcid == 38) BS_GetNumberOfUnreadBits(bitstream, auth_unread_bits);
    if(rpcid == 38 && (length < 2 || length >= sizeof data || auth_unread_bits < length * 8))
    {
        JSON_Cleanup(json_packet_data);
        JSON_Cleanup(JSONObject);
        printf("[AUTH][ERROR] player=%d invalid_packet_length=%d", playerid, length);
        return 0;
    }
    // All GUI payloads share this buffer, not only auth packets.
    BS_GetNumberOfUnreadBits(bitstream, packet_unread_bits);
    if(length < 2 || length >= sizeof data || packet_unread_bits / 8 < length)
    {
        JSON_Cleanup(json_packet_data);
        JSON_Cleanup(JSONObject);
        return 0;
    }
    BS_ReadValue(bitstream, PR_STRING, data, length);
    data[length] = EOS;

    #if defined STABILITY_DEBUG_GUI
    if(rpcid != 38) printf("[GUI] rpc=%d bytes=%d", rpcid, length);
    #endif

    JSON_Parse(data, json);

    switch(rpcid) 
    {
       case 112:
       {
            return Radio_HandlePacket(playerid, json);
       }
       case 39, 65:
       {
            return BlackPass_HandleExtraGui(playerid, rpcid, json);
       }
       case BrDialogDiner:
       {
            return Larek_HandleJsonPacket(playerid, json);
       }
       case 40:
  {
   new type;
   JSON_GetInt(json, "t", type);
   
   switch(type)
   {
    case 2:
    {
     JSON_SetInt(json, "t", 2);
     
     SetPlayerPos(playerid, 1482.54,2504.26,2501.04);
     SetPlayerFacingAngle(playerid, 182.71);
     SetPlayerInterior(playerid, 1);
    
     HidePlayerGUI(playerid, 40);
    }
   }
  }
       case 125:
       {
            return ContNewSystem_HandlePacket(playerid, json);
       }
        case 113:
{
    new type;

    // Сначала пробуем получить параметр из поля "a" (action)
    if (JSON_GetInt(json, "a", type)) {
        printf("[RPC 113] Получен параметр type = %d из поля 'a'", type);
    }
    // Если нет поля "a", пробуем поле "c" (click/close)
    else if (JSON_GetInt(json, "c", type)) {
        printf("[RPC 113] Получен параметр type = %d из поля 'c'", type);

        // Если type = 1 из поля "c" - это закрытие интерфейса
        if (type == 1) {
            printf("[RPC 113] Игрок %d закрыл интерфейс", playerid);
            return 1;
        }
    }
					else {
        printf("[RPC 113] Не найден параметр type в полях 'a' или 'c'");
        return 1;
    }

    switch (type) {
        case 2:
        {
            new JSON:root = JSON_Object();
            ShowPlayerGUI(playerid, 47, root);
            JSON_Cleanup(root);
        }
        case 3:  ShowNotificationNew(playerid, 2, 6, 0, 0, "Уведомление не найдены", "qq");
        case 4:  ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 5:  ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 100: Marketplace_OpenGUI(playerid);
        case 8:  ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 12: animsss(playerid);
        case 13: donatess(playerid);
        case 18: ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 19: ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 22: rewardsss(playerid);
        case 11: inssssv(playerid);
        case 21: ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 15: promosss(playerid);
        case 14: carssssc(playerid);
        case 7:  gpswww(playerid);
        case 17: ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 25: ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 20: ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 9:  ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 24: ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", "qq");
        case 16: sssreport(playerid);
        default: printf("[RPC 113] Неизвестный тип: %d", type);
    }

    return 1;
}

case 45: // фама
{
    return FamilyGuiHandlePacket(playerid, json);
}

	case GUIFuelFill:
	{
		if(Fuel_HandleGuiPacket(playerid, json))
		{
			return 1;
		}
		return 0;
	}

	case 9:
{
    new t;
    JSON_GetInt(json, "t", t);

    switch(t)
    {
        // Инициализация / Радио
        case 0:
        {
            new JSON:resp = JSON_Object();

            JSON_SetInt(resp, "t", 0);
            JSON_SetInt(resp, "p", 0);
            JSON_SetInt(resp, "b", 0);
            JSON_SetInt(resp, "a", 0);
            JSON_SetInt(resp, "e", 0);
            JSON_SetString(resp, "n", "Test Radio");

            JSON_SetInt(resp, "c", 3); // count

            JSON_SetString(resp, "r0", "Laird FM");
            JSON_SetString(resp, "r1", "VING RUSSIA Radio");
            JSON_SetString(resp, "r2", "Night Drive");

            OnPacketIncoming(playerid, 9, resp);
            JSON_Cleanup(resp);
        }

        // Библиотека / список треков
        case 1:
        {
            new JSON:resp = JSON_Object();

            JSON_SetInt(resp, "t", 1);
            JSON_SetInt(resp, "p", 0);
            JSON_SetInt(resp, "b", 0);
            JSON_SetInt(resp, "a", 0);
            JSON_SetInt(resp, "e", 0);
            JSON_SetBool(resp, "s", false);
            JSON_SetString(resp, "n", "Library");

            JSON_SetInt(resp, "c", 4); // count

            JSON_SetString(resp, "m0", "Midnight City");
            JSON_SetString(resp, "m1", "Neon Lights");
            JSON_SetString(resp, "m2", "Cold Street");
            JSON_SetString(resp, "m3", "Last Ride");

            JSON_SetInt(resp, "r0", 0);
            JSON_SetInt(resp, "r1", 0);
            JSON_SetInt(resp, "r2", 0);
            JSON_SetInt(resp, "r3", 0);

            OnPacketIncoming(playerid, 9, resp);
            JSON_Cleanup(resp);
        }

        // Нажатия кнопок (play / next / prev / search и т.д.)
        case 2:
        {
            new a, b;
            JSON_GetInt(json, "a", a);
            JSON_GetInt(json, "b", b);

            printf("[AUDIO] tab=%d button=%d", a, b);
        }
    }
}


	case 25:
{
    new type;
    JSON_GetInt(json, "t", type);
    
    printf("[CASE 25] Получен пакет типа %d от игрока %d", type, playerid);

    switch(type)
    {
        case 1: // запрос обновления списка игроков
        {
            printf("[CASE 25][TYPE 1] Запрос обновления списка игроков от %d", playerid);
            
            new JSON:response = JSON_Object();
            
            // Создаем массив игроков
            new JSON:playersArray = JSON_Array();
            new playerIndex = 0;
            
            foreach(new i : Player)
            {
                if(!IsPlayerConnected(i)) continue;
                
                new JSON:playerObj = JSON_Object();
                JSON_SetInt(playerObj, "id", i);
                
                new name[MAX_PLAYER_NAME];
                GetPlayerName(i, name, sizeof(name));
                JSON_SetString(playerObj, "nick", name);
                
                JSON_SetInt(playerObj, "level", GetPlayerData(i, P_LEVEL));
                JSON_SetInt(playerObj, "ping", GetPlayerPing(i));
                
                // Добавляем объект в массив
                JSON_ArrayAppend(playersArray, "", playerObj);
                
                JSON_Cleanup(playerObj);
                playerIndex++;
                
                printf("[CASE 25][TYPE 1] Добавлен игрок %d: %s", i, name);
            }
            
            printf("[CASE 25][TYPE 1] Всего добавлено игроков: %d", playerIndex);
            
            JSON_SetInt(response, "t", 1);
            JSON_SetArray(response, "data", playersArray);
            
            // Отправляем ответ
            new jsonString[4096];
            JSON_Stringify(response, jsonString, sizeof(jsonString));
            printf("[CASE 25][TYPE 1] JSON ответ (первые 200 символов): %.200s", jsonString);
            
            OnPacketIncoming(playerid, 25, response);
            
            // Очистка
            JSON_Cleanup(playersArray);
            JSON_Cleanup(response);
            
            return 1;
        }

        case 2: // закрытие окна
        {
            printf("[CASE 25][TYPE 2] Игрок %d закрыл окно", playerid);
            return 1;
        }
        
        default:
        {
            printf("[CASE 25][ERROR] Неизвестный тип пакета: %d от игрока %d", type, playerid);
            return 0;
        }
    }
}

        case 34:
        {
            new type = -1;
            JSON_GetInt(json, "t", type);            if(type == 8)
            {
                // Do not drop vehicle context here: client can send t=8 during internal GUI refresh.
                printf("[TRUNKTEST] close gui: player=%d vehicle=%d (context kept)", playerid, GetPVarInt(playerid, PVAR_TRUNKTEST_VEHICLE));
                return 1;
            }

            if(type == 3 || type == 4 || type == 5 || type == 6 || type == 7)
            {
                printf("[TRUNKTEST] menu action: player=%d type=%d", playerid, type);
                return 1;
            }

                        new vehicleid = GetPVarInt(playerid, PVAR_TRUNKTEST_VEHICLE);
            if(vehicleid == 0 || vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
            {
                new restore_vehicle = INVALID_VEHICLE_ID;
                if(TrunkTest_GetNearbyPersonalVehicle(playerid, restore_vehicle, 7.0) && TrunkTest_IsPlayerNearVehicleRear(playerid, restore_vehicle, 3.0))
                {
                    vehicleid = restore_vehicle;
                    SetPVarInt(playerid, PVAR_TRUNKTEST_VEHICLE, vehicleid);
                    printf("[TRUNKTEST] restored vehicle context: player=%d type=%d vehicle=%d", playerid, type, vehicleid);
                }
            }

            if(vehicleid == 0 || vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
            {
                printf("[TRUNKTEST][ERROR] packet without active vehicle: player=%d type=%d vehicle=%d", playerid, type, vehicleid);

                new JSON:resp_no_vehicle = JSON_Object();
                JSON_SetInt(resp_no_vehicle, "t", type);
                JSON_SetInt(resp_no_vehicle, "s", 0);
                OnPacketIncoming(playerid, 34, resp_no_vehicle);
                JSON_Cleanup(resp_no_vehicle);
                return 1;
            }

            new ga = 0, os = -1, ns = -1, value = 0;
            JSON_GetInt(json, "ga", ga);
            JSON_GetInt(json, "os", os);
            JSON_GetInt(json, "ns", ns);
            JSON_GetInt(json, "v", value);

            if(ns == -1)
            {
                JSON_GetInt(json, "s", ns);
            }

            if(type == 0 && os == 0) os = 1;
            if(type == 1 && ns == 0) ns = 1;
            if((type == 2 || type == 9) && ns == 0) ns = 1;

            new bool:ok = false;
            new JSON:resp = JSON_Object();
            JSON_SetInt(resp, "t", type);

            switch(type)
            {
                case 0:
                {
                    printf("[TRUNKTEST] type=0 request: player=%d vehicle=%d ga=%d os=%d ns=%d v=%d", playerid, vehicleid, ga, os, ns, value);
                    ok = TrunkTest_MoveInventoryToTrunk(playerid, vehicleid, ga, os, ns, value);
                    JSON_SetInt(resp, "w", Inventory11_GetCurrentWeightKg(playerid));
                    JSON_SetInt(resp, "bw", TrunkTest_GetTrunkWeightKg(vehicleid));
                }
                case 1:
                {
                    printf("[TRUNKTEST] type=1 request: player=%d vehicle=%d ga=%d os=%d ns=%d v=%d", playerid, vehicleid, ga, os, ns, value);
                    ok = TrunkTest_MoveTrunkToInventory(playerid, vehicleid, ga, os, ns, value);
                    JSON_SetInt(resp, "w", Inventory11_GetCurrentWeightKg(playerid));
                    JSON_SetInt(resp, "bw", TrunkTest_GetTrunkWeightKg(vehicleid));
                }
                case 2, 9:
                {
                    new slot_item = ga;
                    new active_slot = os;
                    new target_slot = ns;

                    ok = false;

                    if(slot_item == 134 || slot_item == 122)
                    {
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Нельзя снять одежду", " ");
                    }
					else if(!Inventory11_IsAccessoryItem(slot_item))
                    {
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Неверный аксессуар", " ");
                    }
					else
                    {
                        if(active_slot == 0)
                        {
                            active_slot = 1;
                        }

                        if(active_slot < 1 || active_slot > INVENTORY11_MAX_ACTIVE_ACCESSORIES)
                        {
                            active_slot = 1;
                        }
                            if(target_slot < 1 || target_slot > Inventory11_GetMaxSlots(playerid))
                            {
                                target_slot = TrunkTest_GetFreeInventorySlot(playerid);
                            }

                            if(target_slot == -1)
                            {
                                ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету мест в инвентаре", " ");
                            }
        					else
                            {
                                new item_weight_x10 = InventoryCfg_GetItemWeightX10(slot_item);
                                if(item_weight_x10 <= 0) item_weight_x10 = 10;

                                if(Inventory11_GetCurrentWeightX10(playerid) + item_weight_x10 > (Inventory11_GetMaxWeightKg(playerid) * 10))
                                {
                                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Нету мест в инвентаре", " ");
                                }
            					else
                                {
                                    new moved_model = 0;
                                    new used_slot = active_slot;
                                    if(Inventory11_MoveActiveAccessoryToInventorySlot(playerid, slot_item, used_slot, target_slot, moved_model))
                                    {
                                        ok = true;
                                    }
                                    else
                                    {
                                        for(new candidate_slot = 1; candidate_slot <= INVENTORY11_MAX_ACTIVE_ACCESSORIES; candidate_slot++)
                                        {
                                            if(candidate_slot == used_slot) continue;
                                            if(!Inventory11_MoveActiveAccessoryToInventorySlot(playerid, slot_item, candidate_slot, target_slot, moved_model)) continue;
                                            used_slot = candidate_slot;
                                            ok = true;
                                            break;
                                        }
                                    }

                                    if(!ok)
                                    {
                                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Аксессуар не надет", " ");
                                    }
                                    else
                                    {
                                        JSON_SetInt(resp, "w", Inventory11_GetCurrentWeightKg(playerid));
                                        JSON_SetInt(resp, "bw", TrunkTest_GetTrunkWeightKg(vehicleid));
                                    }
                                }
                            }
                        }
                    }
                default:
                {
                    printf("[TRUNKTEST][WARN] unknown action: player=%d type=%d ga=%d os=%d ns=%d v=%d", playerid, type, ga, os, ns, value);
                    ok = false;
                }
            }

            JSON_SetInt(resp, "s", ok ? 1 : 0);
            OnPacketIncoming(playerid, 34, resp);
            JSON_Cleanup(resp);

            if(ok)
            {
                TrunkTest_OpenGui(playerid, vehicleid);
            }
            return 1;
        }
        case 22:
        {
            new type;
            JSON_GetInt(json, "t", type);

            if((type == -2 || type == -1) && BlackPass_HandlePacket(playerid, json))
            {
                return 1;
            }

            printf("[DEBUG] IPacket:252 - rpcid 22, type: %d", type);

            switch(type)
            {
				case 1:
				{
					callcmd::casestest(playerid);
				}
                case 2:
                {
                    printf("[DEBUG] IPacket:252 - type 2, playerid: %d, P_SALE_TIME: %d", playerid, GetPlayerData(playerid, P_SALE_TIME));
                    if(GetPlayerData(playerid, P_SALE_TIME) != 0) return 1;

                    ShowPlayerDialog(playerid, 1912, DIALOG_STYLE_MSGBOX, "{FF0000}Подарок", "При открытии подарка, вы получили бронзовую рулетку!", "Закрыть", "");

                    SetPlayerData(playerid, P_SALE_TIME, 7200); // 2 часа в секундах
                    UpdatePlayerDatabaseInt(playerid, "sale_time", GetPlayerData(playerid, P_SALE_TIME));

                    printf("[DEBUG] IPacket:252 - Set P_SALE_TIME to 7200 for playerid: %d", playerid);

                    JSON_SetInt(json_packet_data, "t", 2);
                    JSON_SetInt(json_packet_data, "p", GetPlayerData(playerid, P_SALE_TIME));

                    OnPacketIncoming(playerid, 22, json_packet_data);

                    printf("[DEBUG] IPacket:252 - OnPacketIncoming called for playerid: %d, rpcid: 22", playerid);

                    JSON_Cleanup(json_packet_data);

                    // TODO: реализовать выдачу рулетки пользователю (для более опытеых павнеров)
                }

				case 4:
{
    new value;
    JSON_GetInt(json, "v", value); // Сколько доната обменять
    printf("[DEBUG] IPacket:252 - type 4, playerid: %d, exchange donate: %d", playerid, value);

    if(value <= 0)
    {
        JSON_SetInt(json_packet_data, "t", 4);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetString(json_packet_data, "m", "Ошибка: некорректное количество доната для обмена.");
        JSON_SetString(json_packet_data, "n", "Введите положительное число.");
        OnPacketIncoming(playerid, 22, json_packet_data);
        JSON_Cleanup(json_packet_data);
        return 1;
    }

    if(GetPlayerDonateRub(playerid) < value)
    {
        JSON_SetInt(json_packet_data, "t", 4);
        JSON_SetInt(json_packet_data, "y", 0);
        JSON_SetString(json_packet_data, "m", "Недостаточно доната для обмена.");
        JSON_SetString(json_packet_data, "n", "Пополните баланс, чтобы произвести обмен.");
        printf("[DEBUG] IPacket:252 - type 4, insufficient donate: playerid: %d, have: %d, need: %d",
            playerid, GetPlayerDonateRub(playerid), value);
        OnPacketIncoming(playerid, 22, json_packet_data);
        JSON_Cleanup(json_packet_data);
        return 1;
    }

    // Вычисляем сумму обмена
    new give_money = value * 1000;

    // Совершаем обмен
    GivePlayerDonateRub(playerid, -value);
    GivePlayerMoney(playerid, give_money);

    printf("[DEBUG] IPacket:252 - type 4, exchanged %d donate -> %d money, playerid: %d, new DonateRub: %d, Money: %d",
        value, give_money, playerid, GetPlayerDonateRub(playerid), GetPlayerMoney(playerid));

    // Подготавливаем JSON ответ
    JSON_SetInt(json_packet_data, "t", 4);
    JSON_SetInt(json_packet_data, "y", 1);
    JSON_SetInt(json_packet_data, "v", value);
    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
    JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
    JSON_SetString(json_packet_data, "m", "Обмен успешно выполнен!");
    JSON_SetString(json_packet_data, "n", "Вы обменяли донат на рубли.");

    OnPacketIncoming(playerid, 22, json_packet_data);
    JSON_Cleanup(json_packet_data);
}


                case 0:
                {
                    new price, internal_id, donate_vehicle_color = 0;

                    JSON_GetInt(json, "p", internal_id);
                    JSON_GetInt(json, "m", price);
                    // The SIM price is server-authoritative; do not accept a
                    // stale or modified value from the mobile GUI.
                    if(internal_id == 124) price = 70;
                    if(!JSON_GetInt(json, "l", donate_vehicle_color))
                    {
                        JSON_GetInt(json, "c", donate_vehicle_color);
                    }
                    if(donate_vehicle_color < 0 || donate_vehicle_color > 255) donate_vehicle_color = 0;

                    printf("[DEBUG] IPacket:252 - type 0, playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);

                    new bool:purchase_with_money = false;
                    switch(internal_id)
                    {
                        case 238, 239, 240, 243, 244, 245, 246, 254, 256, 257, 258, 263, 378, 382, 387, 388: purchase_with_money = true;
                    }

                    new result = purchase_with_money ? (GetPlayerMoneyEx(playerid) - price) : (GetPlayerDonateRub(playerid) - price);
                    printf("[DEBUG] IPacket:252 - playerid: %d, money: %d, DonateRub: %d, price: %d, result: %d, money_mode: %d", playerid, GetPlayerMoneyEx(playerid), GetPlayerDonateRub(playerid), price, result, purchase_with_money);

                    new result_json[256];
                    JSON_Stringify(json, result_json);
                    printf("[DEBUG] IPacket:252 - JSON data: %s", result_json);

                    if ((purchase_with_money && GetPlayerMoneyEx(playerid) < price) || (!purchase_with_money && GetPlayerDonateRub(playerid) < price))
                    {
                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 0);
                        JSON_SetInt(json_packet_data, "k", 1);

                        JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                        JSON_SetString(json_packet_data, "n", "Пополните счет прямо сейчас!");

                        printf("[DEBUG] IPacket:252 - Insufficient funds for playerid: %d, price: %d, money: %d, DonateRub: %d, money_mode: %d", playerid, price, GetPlayerMoneyEx(playerid), GetPlayerDonateRub(playerid), purchase_with_money);

                        OnPacketIncoming(playerid, 22, json_packet_data);

                        JSON_Cleanup(json_packet_data);

                        return 1;
                    }

                    new inv_item_id = -1;
                    new acc_modelid = -1;

                    for (new i = 0; i < sizeof(AccessoryMapping); i++)
                    {
                        if (AccessoryMapping[i][0] == internal_id)
                        {
                            inv_item_id = AccessoryMapping[i][1];
                            acc_modelid = AccessoryMapping[i][2];
                            break;
                        }
                    }

                    if (inv_item_id != -1 && acc_modelid != -1)
                    {
                        new inv_slot = Inventory11_AddItemToDatabase(playerid, inv_item_id, acc_modelid, 1, 0, 0);
                        if (inv_slot == -1)
                        {
                            printf("[ERROR] IPacket:252 - Accessory add failed, playerid: %d, internal_id: %d, inv_item_id: %d, modelid: %d", playerid, internal_id, inv_item_id, acc_modelid);

                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 0);
                            JSON_SetInt(json_packet_data, "k", 1);
                            JSON_SetString(json_packet_data, "m", "Error: failed to add accessory.");
                            JSON_SetString(json_packet_data, "n", "Try again or contact support.");

                            OnPacketIncoming(playerid, 22, json_packet_data);
                            JSON_Cleanup(json_packet_data);
                            return 1;
                        }

                        if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                        printf("[DEBUG] IPacket:252 - Buying accessory, playerid: %d, internal_id: %d, inv_item_id: %d, modelid: %d, slot: %d, price: %d, new DonateRub: %d",
                               playerid, internal_id, inv_item_id, acc_modelid, inv_slot, price, GetPlayerDonateRub(playerid));

                        JSON_SetInt(json_packet_data, "t", 0);
                        JSON_SetInt(json_packet_data, "y", 1);
                        JSON_SetInt(json_packet_data, "g", inv_item_id);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                        JSON_SetString(json_packet_data, "m", "Успешная операция");
                        JSON_SetString(json_packet_data, "n", "Вы приобрели аксессуар, он находится в /inv");

                        OnPacketIncoming(playerid, 22, json_packet_data);
                        JSON_Cleanup(json_packet_data);
                        return 1;
                    }

                    switch(internal_id)
                    {
                        case 5,6,7,8,400,9,10,552,401,402,403,11,404,12,13,14,15,16,460,211,17,18,19,20,456,465,543,21,22,471,455,23,212,213,24,214,25,405,26,406,27,407,347,28,29,215,216,551,30,546,217,500,470,474,31,32,218,33,547,34,348,35,36,37,454,451,38,505,39,545,467,40,472,468,498,553,41,42,502,43,509,503,469,453,44,45,507,46,47,48,523,49,524,50,51,450,445,52,53,54,55,56,522,504,449,57,544,58,59,60,61,62,349,327,63,328,64,219,65,506,66,67,446,473,501,68,69,70,508,71,351,72,352,73,350,74,75,329,410,220,466,444,353,221,554,222,411,447,452,448,223,224,76,77,459,78,79,80,81,82,83,84,511,512,510,484,485,461,426,427,428,429,424,366,367,86,87,88,89,90,275,276,330,331,201,408,499,202,409,195,417,416,418,413,414,415,555,556,557,558,559,560:
                        {
                            printf("[DEBUG] IPacket:252 - Buying car, playerid: %d, internal_id: %d, car slots: %d, available slots: %d", playerid, internal_id, GetPlayerOwnableCars(playerid), GetPlayerCarSlots(playerid));
                            if(GetPlayerOwnableCars(playerid) + 1 > GetPlayerCarSlots(playerid))
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", -1);

                                JSON_SetString(json_packet_data, "m", "Все слоты для покупки нового\nтранпорта заняты.");
                                JSON_SetString(json_packet_data, "n", "Вы можете увеличить их в разделе {FFFF00}услуги.");

                                printf("[DEBUG] IPacket:252 - No car slots available for playerid: %d", playerid);

                                OnPacketIncoming(playerid, 22, json_packet_data);

                                JSON_Cleanup(json_packet_data);

                                return 1;
                            }
                            new selected_color = donate_vehicle_color;
                            new body_color;

                            switch(selected_color)
                            {
                                case 0:  body_color = 0x000000;
                                case 1:  body_color = 0xF5F5F5;
                                case 2:  body_color = 0x2A77A1;
                                case 3:  body_color = 0x840410;
                                case 4:  body_color = 0x263739;
                                case 5:  body_color = 0x86446E;
                                case 6:  body_color = 0xD78E10;
                                case 7:  body_color = 0x4C75B7;
                                case 8:  body_color = 0xBDBEC6;
                                case 9:  body_color = 0x5E7072;
                                case 10: body_color = 0x46597A;
                                case 11: body_color = 0x656A79;
                                case 12: body_color = 0x5D7E8D;
                                case 13: body_color = 0x58595A;
                                case 14: body_color = 0xD6DAD6;
                                case 15: body_color = 0x9CA1A3;
                                case 16: body_color = 0x335F3F;
                                case 17: body_color = 0x730E1A;
                                case 18: body_color = 0x7B0A2A;
                                case 19: body_color = 0x9F9D94;
                                case 20: body_color = 0x3B4E78;
                                case 21: body_color = 0x732E3E;
                                case 22: body_color = 0x691E3B;
                                case 23: body_color = 0x96918C;
                                case 24: body_color = 0x515459;
                                case 25: body_color = 0x3F3E45;
                                case 26: body_color = 0xAE9B7F;
                                case 27: body_color = 0x193826;
                                default: body_color = 0xFFFFFF;
                            }

                            SetPVarInt(playerid, "BUY_CAR_COLOR", body_color);

                            new game_id = FindGameId(internal_id, car_game_ids, sizeof(car_game_ids));
                            if(BuyPlayerCar(playerid, internal_id, game_id, selected_color) == -1)
                            {
                                DeletePVar(playerid, "BUY_CAR_COLOR");
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "m", "Не удалось приобрести автомобиль.");
                                JSON_SetString(json_packet_data, "n", "Попробуйте позже или обратитесь к администрации.");
                                printf("[ERROR] IPacket:252 - BuyPlayerCar failed, playerid: %d, internal_id: %d, game_id: %d, color: %d", playerid, internal_id, game_id, selected_color);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return 1;
                            }
							
                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            printf("[DEBUG] IPacket:252 - Car purchased, playerid: %d, internal_id: %d, new DonateRub: %d", playerid, internal_id, GetPlayerDonateRub(playerid));

                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            JSON_SetInt(json_packet_data, "g", internal_id);

                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели автомобиль!");
                            JSON_SetString(json_packet_data, "n", "Для того чтобы загрузить авто,\nиспользуйте /car");

                            OnPacketIncoming(playerid, 22, json_packet_data);

                            JSON_Cleanup(json_packet_data);
                        }
                        case 548, 535, 529, 527, 528, 526, 525, 519, 513, 514, 515, 516, 517, 486, 487, 488, 489, 490, 491, 492, 497, 480, 481, 482, 483, 475, 462, 463, 457, 458, 419, 430, 431, 425, 420, 421, 399, 390, 391, 392, 393, 394, 395, 396, 397, 398, 346, 344, 345, 332, 333, 334, 335, 340, 336, 337, 338, 339, 341, 342, 343, 315, 313, 311, 322, 323, 324, 314, 312, 316, 317, 318, 319, 320, 321, 325, 326, 238, 257, 239, 240, 225, 226, 227, 228, 205, 206, 207, 208, 91, 92, 229, 93, 94, 230, 95, 96, 97, 203, 231, 232, 233, 234, 235, 98, 99, 100, 101, 236, 237, 209, 210, 561, 562, 564:
                        {
                            // Поиск modelid по internal_id
                            new modelid = -1;
                            for (new i = 0; i < sizeof(SkinMapping); i++)
                            {
                                if (SkinMapping[i][0] == internal_id)
                                {
                                    modelid = SkinMapping[i][1];
                                    break;
                                }
                            }

                            // Проверка валидности modelid
                            if (modelid == -1 || !IsValidSkinModel(modelid))
                            {
                                printf("[ERROR] IPacket:252 - Invalid or unmapped modelid for internal_id: %d, modelid: %d", internal_id, modelid);
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "m", "Ошибка: неверный ID скина.");
                                JSON_SetString(json_packet_data, "n", "Попробуйте снова или обратитесь к поддержке.");
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return 1;
                            }

                            if(!BuyPlayerSkin(playerid, internal_id, modelid))
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "m", "Инвентарь переполнен");
                                JSON_SetString(json_packet_data, "n", "Освободите место в инвентаре.");
                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return 1;
                            }

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            JSON_SetInt(json_packet_data, "g", modelid);

                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели одежду");
                            JSON_SetString(json_packet_data, "n", "Мы вам его сменили автоматически.");

                            printf("[DEBUG] IPacket:252 - Buying skin, playerid: %d, internal_id: %d, modelid: %d, price: %d, new DonateRub: %d", playerid, internal_id, modelid, price, GetPlayerDonateRub(playerid));

                            OnPacketIncoming(playerid, 22, json_packet_data);

                            JSON_Cleanup(json_packet_data);
                        }
						
                        case 179:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Сельчанин', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 12, 585, 0);
                            BuyPlayerSkin(playerid, 180, 30);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Сельчанин", price, internal_id);
                        }
                        case 181:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Бандит', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 22, 419, 0);
                            BuyPlayerSkin(playerid, 182, 60);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Бандит", price, internal_id);
                        }
                        case 183:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Молодой', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 23, 562, 0);
                            SetPlayerData(playerid, P_CAR_SLOTS, GetPlayerData(playerid, P_CAR_SLOTS) + 1);

                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 86400);

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Молодой", price, internal_id);
                        }
                        case 185:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Гангстер', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 28, 527, 0);
                            Inventory11_AddSkinToInventory(playerid, 185, internal_id);

                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Гангстер", price, internal_id);
                        }
                        case 268:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Красавчик', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 228, 258, 0);

                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Красавчик", price, internal_id);
                        }
                        case 269:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Красотка', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerSkin(playerid, 227, 232);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Красотка", price, internal_id);
                        }
                        case 187:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Гонщик', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 78, 461, 188);

                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Гонщик", price, internal_id);
                        }
                        case 189:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Депутат', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 122, 550, 190);

                            SetPlayerData(playerid, P_PREMIUM, 1);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Депутат", price, internal_id);
                        }
                        case 270:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Ведьма', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerSkin(playerid, 238, 65);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Ведьма", price, internal_id);
                        }
                        case 271:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Улыбка зла', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerSkin(playerid, 229, 231);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Улыбка зла", price, internal_id);
                        }
                        case 272:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Страшила', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerSkin(playerid, 231, 208);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Страшила", price, internal_id);
                        }
                        case 273:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Смерть с косой', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerSkin(playerid, 230, 175);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Смерть с косой", price, internal_id);
                        }
                        case 191:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Мафиози', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 52, 2547, 220);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Мафиози", price, internal_id);
                        }
                        case 193:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Мажор', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerCar(playerid, 64, 2546, 314);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Мажор", price, internal_id);
                        }
                        case 262:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'Кости', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            BuyPlayerSkin(playerid, 237, 266);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "Кости", price, internal_id);
                        }
                        case 127:
                        {
                            printf("[DEBUG] IPacket:252 - Buying pack 'TEST', playerid: %d, internal_id: %d, price: %d", playerid, internal_id, price);
                            SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + (86400 * 3));

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        					else GivePlayerDonateRub(playerid, -price);

                            ShowSuccesfullBuyPack(playerid, "TEST", price, internal_id);
                        }
                        case 176, 177, 178:
                        {
                            SendClientMessage(playerid, 0xFF6600FF, "Покупка денежных наборов отключена");
                        }                        //услуги 
                       case 102:
                        {
                            new Node:json_packet_data = JSON_Object();
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= 50)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                JSON_SetString(json_packet_data, "m", "Вы приобрели услугу: изменить имя");
                                JSON_SetString(json_packet_data, "n", "Продолжите в диалоге:");
                                ShowPlayerChangeNameDialog(playerid);
                                GivePlayerDonateRub(playerid, -50, "Смена имени", true);
                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //варн
                        case 103:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу: Снятие предупреждения");
                                
                                SetPlayerData(playerid, P_WARN, 0);
                                SetPlayerData(playerid, P_WARN_TIME, 0);

                                UpdatePlayerDatabaseInt(playerid, "warn", 0);
                                UpdatePlayerDatabaseInt(playerid, "warn_time", 0);

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 104:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            // Check if player already has the driving license
                            if(GetPlayerData(playerid, P_DRIVING_LIC) == 1)
                            {
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "m", "У вас уже есть все лицензии.");
                                JSON_SetString(json_packet_data, "n", "ЛИЦЕНЗИИ УЖЕ ПРИОБРЕТЕНЫ");
                                
                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "Вы купили услугу Все лицензии");

                                SetPlayerData(playerid, P_DRIVING_LIC, 1);
                                UpdatePlayerDatabaseInt(playerid, "driving_lic", GetPlayerData(playerid, P_DRIVING_LIC));

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //быстрое лечение
                        case 106:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Быстрое лечение");

                                SetPlayerData(playerid, P_HEALTH, 100);
                                SetPlayerHealthEx(playerid, 100);

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //изменения имя семьи
                        case 107:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Изменения имья семьи");

                                ShowChangeNameDialog(playerid);

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //передать семью
                        case 108:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу: Передать семью");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //венный билет
                        case 109:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Военный билет");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 111:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Колонку");

                                SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили колонку!");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //саббуфер
                        case 112:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу Колонку");

                                SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили Саббуфер, что бы использывать пропишите /anymusic");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //слот для дома
                        case 113:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                new current_property_slots = GetPlayerData(playerid, P_HOUSE_SLOTS);
                                // Дополнительный слот покупается как раз ПОСЛЕ первой недвижимости.
                                // Старая проверка владельца первого дома блокировала нормальную покупку.
                                if(current_property_slots < 1)
                                {
                                    new slot_query[192], Cache:slot_result;
                                    mysql_format(mysql, slot_query, sizeof slot_query,
                                        "UPDATE accounts SET house_slots=1,rub=rub-%d WHERE id=%d AND house_slots<1 AND rub>=%d LIMIT 1",
                                        price, GetPlayerAccountID(playerid), price);
                                    slot_result = mysql_query(mysql, slot_query, true);
                                    new slot_error = mysql_errno(mysql);
                                    new slot_affected = 0;
                                    if(!slot_error) slot_affected = cache_affected_rows();
                                    cache_delete(slot_result);

                                    if(!slot_error && slot_affected == 1)
                                    {
                                        SetPlayerData(playerid, P_HOUSE_SLOTS, 1);
                                        // SQL уже сохранил rub, поэтому здесь только память/HUD/лог.
                                        GivePlayerDonateRub(playerid, -price, "Покупка слота дома", false);

                                        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                                        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                        JSON_SetString(json_packet_data, "m", "ВЫ УСПЕШНО КУПИЛИ ДОПОЛНИТЕЛЬНЫЙ СЛОТ");
                                        JSON_SetString(json_packet_data, "n", "ТЕПЕРЬ ВЫ МОЖЕТЕ КУПИТЬ ЕЩЁ ОДИН ДОМ.");

                                        JSON_Stringify(json_packet_data, outcoming_data);
                                        OnPacketIncoming(playerid, 22, json_packet_data);
                                    }
                                    else
                                    {
                                        printf("[PROPERTY_SLOTS] House slot purchase failed player=%d account=%d price=%d errno=%d affected=%d", playerid, GetPlayerAccountID(playerid), price, slot_error, slot_affected);
                                        JSON_SetInt(json_packet_data, "y", 0);
                                        JSON_SetInt(json_packet_data, "k", 1);
                                        JSON_SetString(json_packet_data, "m", "НЕ УДАЛОСЬ СОХРАНИТЬ СЛОТ");
                                        JSON_SetString(json_packet_data, "n", "Донат не списан. Попробуйте ещё раз.");
                                        JSON_Stringify(json_packet_data, outcoming_data);
                                        OnPacketIncoming(playerid, 22, json_packet_data);
                                    }
                                }
                                else
                                {
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "tb", 0);
                                    JSON_SetString(json_packet_data, "m", "ВЫ МОЖЕТЕ ИМЕТЬ МАКСИМУМ 2 ДОМА.");
                                    JSON_SetString(json_packet_data, "n", "");
                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, json_packet_data);
                                }
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //слот для бизнеса
                        case 114:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                new current_business_slots = GetPlayerData(playerid, P_BUSS_SLOTS);
                                if(current_business_slots < 1)
                                {
                                    new slot_query[192], Cache:slot_result;
                                    mysql_format(mysql, slot_query, sizeof slot_query,
                                        "UPDATE accounts SET buss_slots=1,rub=rub-%d WHERE id=%d AND buss_slots<1 AND rub>=%d LIMIT 1",
                                        price, GetPlayerAccountID(playerid), price);
                                    slot_result = mysql_query(mysql, slot_query, true);
                                    new slot_error = mysql_errno(mysql);
                                    new slot_affected = 0;
                                    if(!slot_error) slot_affected = cache_affected_rows();
                                    cache_delete(slot_result);

                                    if(!slot_error && slot_affected == 1)
                                    {
                                        SetPlayerData(playerid, P_BUSS_SLOTS, 1);
                                        GivePlayerDonateRub(playerid, -price, "Покупка слота бизнеса", false);

                                        JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                                        JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                                        JSON_SetString(json_packet_data, "m", "ВЫ УСПЕШНО КУПИЛИ ДОПОЛНИТЕЛЬНЫЙ СЛОТ");
                                        JSON_SetString(json_packet_data, "n", "ТЕПЕРЬ ВЫ МОЖЕТЕ КУПИТЬ ЕЩЁ ОДИН БИЗНЕС.");
                                        SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили дополнительный слот для бизнеса");

                                        JSON_Stringify(json_packet_data, outcoming_data);
                                        OnPacketIncoming(playerid, 22, json_packet_data);
                                    }
                                    else
                                    {
                                        printf("[PROPERTY_SLOTS] Business slot purchase failed player=%d account=%d price=%d errno=%d affected=%d", playerid, GetPlayerAccountID(playerid), price, slot_error, slot_affected);
                                        JSON_SetInt(json_packet_data, "y", 0);
                                        JSON_SetInt(json_packet_data, "k", 1);
                                        JSON_SetString(json_packet_data, "m", "НЕ УДАЛОСЬ СОХРАНИТЬ СЛОТ");
                                        JSON_SetString(json_packet_data, "n", "Донат не списан. Попробуйте ещё раз.");
                                        JSON_Stringify(json_packet_data, outcoming_data);
                                        OnPacketIncoming(playerid, 22, json_packet_data);
                                    }
                                }
                                else
                                {
                                    JSON_SetInt(json_packet_data, "y", 0);
                                    JSON_SetInt(json_packet_data, "tb", 0);
                                    JSON_SetString(json_packet_data, "m", "ВЫ МОЖЕТЕ ИМЕТЬ МАКСИМУМ 2 БИЗНЕСА.");
                                    JSON_SetString(json_packet_data, "n", "");
                                    JSON_Stringify(json_packet_data, outcoming_data);
                                    OnPacketIncoming(playerid, 22, json_packet_data);
                                }
                            }
                            else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);
                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");
                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //пониженный износ
                        case 115:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили услугу: пониженный износ");

                                SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили пониженный износ для авто!");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //вечная мед карта
                        case 116:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили вечную мед. карту");

                                SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили вечную мед. карту");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //временная мед карта
                        case 117:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили мед. карту");

                                SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили мед. карту");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //уник музыка 
                        case 118:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили уник. музыку на вход");

                                SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили уникальную музыку на вход");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //законка
                        case 119:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили повышение закон-сти");

                                SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили повышение закон-сти");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //доп слот на авто в семью
                        case 120:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили доп. слот на авто в семью");

                                SendClientMessage(playerid, 0xCECECEFF, "Вы успешно купили доп. слот на авто в семью!");

                                GivePlayerDonateRub(playerid, -price, "тест", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //смена пола
                        case 121:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили смену пола");

                                SetPlayerSexEx(playerid, GetPlayerSex(playerid) ^ 1);
                                SendClientMessage(playerid, 0xCECECEFF, GetPlayerSex(playerid) ? "Вы успешно сменили пол на женский" : "Вы успешно сменили пол на мужской");

                                GivePlayerDonateRub(playerid, -price, "Смена пола", true);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //доп слот на авто
                        case 122:
                        {
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid) - price);
                                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));

                                JSON_SetString(json_packet_data, "m", "Успешная операция");
                                JSON_SetString(json_packet_data, "n", "вы купили доп. слот на авто");

                                GivePlayerDonateRub(playerid, -price, "тест", true);
                                
                                AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                                UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));
                                
                                new fmt_text[200];
                                
                                format(fmt_text, sizeof fmt_text, "Вы купили слот для транспорта. Текущее количество слотов: %d",
                                GetPlayerData(playerid, P_CAR_SLOTS));
                                SendClientMessage(playerid, 0x66CC00FF, fmt_text);

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //номерной знак
                        case 123:
                        {
                            if(GetPlayerDonateRub(playerid) >= price)
                            {
                                SetPVarInt(playerid, PVAR_PLATE_BUY_ACCESS, 1);
                                SetPVarInt(playerid, PVAR_PLATE_BC_PRICE, price);
                                ClearPlateDraftCache(playerid);
                                gPlayerCountry[playerid] = -1;
                                PlateDraft_EnsureLoaded(playerid);

                                new JSON:plate_json = JSON_Object();
                                JSON_SetInt(plate_json, "t", 1);
                                JSON_SetInt(plate_json, "m", price);
                                JSON_SetInt(plate_json, "p", internal_id);
                                JSON_SetInt(plate_json, "c", 1);
                                ShowPlayerGUI(playerid, 1, plate_json);
                                JSON_Cleanup(plate_json);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        //сим-карта
                        case 124:
                        {
                            if(GetPlayerDonateRub(playerid) >= 70)
                            {
                                callcmd::buyphonenum(playerid);
                            }
					else
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств.");
                                JSON_SetString(json_packet_data, "n", "НЕДОСТАТОЧНО СРЕДСТВ");

                                JSON_Stringify(json_packet_data, outcoming_data);
                                OnPacketIncoming(playerid, 22, json_packet_data);
                            }
                            JSON_Cleanup(json_packet_data);
                        }
                        case 128, 129, 130, 131,132,133,134,135,136,137,138,139:
                        {
                            new vip_type = 1, vip_days = 3, premium_expires_at, vip_pack_name[128];

                            switch (internal_id)
                            {
                                case 128: { price = 50; vip_type = 1; vip_days = 3; }
                                case 129: { price = 100; vip_type = 1; vip_days = 7; }
                                case 130: { price = 170; vip_type = 1; vip_days = 15; }
                                case 131: { price = 300; vip_type = 1; vip_days = 30; }
                                case 132: { price = 110; vip_type = 2; vip_days = 3; }
                                case 133: { price = 215; vip_type = 2; vip_days = 7; }
                                case 134: { price = 370; vip_type = 2; vip_days = 15; }
                                case 135: { price = 650; vip_type = 2; vip_days = 30; }
                                case 136: { price = 170; vip_type = 3; vip_days = 3; }
                                case 137: { price = 335; vip_type = 3; vip_days = 7; }
                                case 138: { price = 570; vip_type = 3; vip_days = 15; }
                                case 139: { price = 1000; vip_type = 3; vip_days = 30; }
                                default: { price = 100; vip_type = 1; vip_days = 3; }
                            }

                            if (GetPlayerDonateRub(playerid) < price)
                            {
                                JSON_SetInt(json_packet_data, "t", 0);
                                JSON_SetInt(json_packet_data, "y", 0);
                                JSON_SetInt(json_packet_data, "k", 1);

                                JSON_SetString(json_packet_data, "m", "Недостаточно средств!.");
                                JSON_SetString(json_packet_data, "n", "Пополните счет для покупки VIP-Статуса.");

                                OnPacketIncoming(playerid, 22, json_packet_data);
                                JSON_Cleanup(json_packet_data);
                                return 1;
                            }

                            premium_expires_at = GetPlayerData(playerid, P_PREMIUM_DATE);

                            if (premium_expires_at < gettime())
                            {
                                premium_expires_at = gettime();
                            }

                            if (GetPlayerPremium(playerid) < vip_type)
                            {
                                SetPlayerData(playerid, P_PREMIUM, vip_type);
                            }

                            SetPlayerData(playerid, P_PREMIUM_DATE, premium_expires_at + (86400 * vip_days));
                            SetPlayerData(playerid, P_PREMIUM_CHAT, 1);

                            if(vip_type == 1) format(vip_pack_name, sizeof vip_pack_name, "VIP Silver на %d дн.", vip_days);
                            else if(vip_type == 2) format(vip_pack_name, sizeof vip_pack_name, "VIP Gold на %d дн.", vip_days);
                            else format(vip_pack_name, sizeof vip_pack_name, "VIP Platinum на %d дн.", vip_days);

                            if(purchase_with_money) GivePlayerMoneyEx(playerid, -price, "Покупка в донат-магазине", true, true);
        							else GivePlayerDonateRub(playerid, -price);

                            UpdatePlayerDatabaseInt(playerid, "premium", GetPlayerPremium(playerid));
                            UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));

                            ShowSuccesfullBuyPack(playerid, vip_pack_name, price, internal_id);

                            // Добавляем успешный ответ для consistency
                            JSON_SetInt(json_packet_data, "t", 0);
                            JSON_SetInt(json_packet_data, "y", 1);

                            JSON_SetInt(json_packet_data, "g", internal_id);

                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));

                            JSON_SetString(json_packet_data, "m", "Вы успешно приобрели VIP!");
                            JSON_SetString(json_packet_data, "n", "Наслаждайтесь преимуществами.");

                            OnPacketIncoming(playerid, 22, json_packet_data);

                            JSON_Cleanup(json_packet_data);
                        }
                   }
                }
            }
        }
        
        case 38:
        {
            JSON_Cleanup(json_packet_data);
            JSON_Cleanup(JSONObject);
            new auth_result = PacketIncomingAuthReg(playerid, json);
            JSON_Cleanup(json);
            return auth_result;
        }

        case 50:
        {
            if(!IsPlayerLogged(playerid)) return 1;

            // V11 hospital intermittent fix: ignore any stale/late spawn-select
            // response while the account is in hospital. This is especially
            // important on reconnecting mobile clients where GUI 50 may answer
            // after the hospital spawn sequence has already started.
            if(GetPlayerData(playerid, P_HOSPITAL))
            {
                HidePlayerGUI(playerid, 50);

                if(GetPVarInt(playerid, "hospital_spawn_state") == 0)
                {
                    new hospital_token = GetPVarInt(playerid, "hospital_spawn_token") + 1;
                    if(hospital_token <= 0) hospital_token = 1;
                    SetPVarInt(playerid, "hospital_spawn_token", hospital_token);
                    DeletePVar(playerid, "hospital_spawn_room");
                    SetPlayerHospitalSpawnInit(playerid);

                    if(GetPlayerState(playerid) == PLAYER_STATE_NONE) SpawnPlayer(playerid);
                    else ApplyPlayerHospitalSpawn(playerid);
                }
                else ApplyPlayerHospitalSpawn(playerid);

                return 1;
            }

            if(GetPVarInt(playerid, "spawn_select_once") == 1)
            {
                printf("[SpawnSelect][DUPLICATE] ignored playerid=%d prev_id=%d state=%d int=%d vw=%d",
                    playerid,
                    GetPVarInt(playerid, "spawn_select_id"),
                    GetPlayerState(playerid),
                    GetPlayerInterior(playerid),
                    GetPlayerVirtualWorld(playerid));
                return 1;
            }

            new spawn_id = 1;
            JSON_GetInt(json, "t", spawn_id);

            if(spawn_id != 0 && spawn_id != 1 && spawn_id != 2 && spawn_id != 4 && spawn_id != 6)
            {
                printf("[SpawnSelect] ERROR: unsupported spawn_id=%d | playerid=%d raw=%s", spawn_id, playerid, data);
                spawn_id = 1;
            }

            printf("[SpawnSelect] Received spawn_id=%d for playerid=%d (raw=%s)", spawn_id, playerid, data);

            switch(spawn_id)
            {
                case 1:
                {
                    new Float:case_1_spawns[][4] =
                    {
                        {846.602600, 796.555847, 13.400512, 69.896881},
                        {2740.712158, -2441.565185, 21.774286, 269.248382}, // южный спавн
                        {-2429.236083, 203.175277, 26.096101, 176.712112}, // лыткарино спавн
                        {1801.694091, 2523.137695, 14.602633, 109.981643}, // батырево спавн
                        {-2667.526611, 2006.567016, 11.197804, 176.496978}, // спавн нижегородск
                        {-2159.371093, 1558.103271, 9.840852, 84.519485} // южный вокзал нижегородска
                    };
                    new spawn_index = random(sizeof(case_1_spawns));
					SetPlayerSpawnSetting(playerid, 0);
					UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                    printf("Case 1: random spawn Pos: %f, %f, %f, Angle: %f", case_1_spawns[spawn_index][0], case_1_spawns[spawn_index][1], case_1_spawns[spawn_index][2], case_1_spawns[spawn_index][3]);
                    SetPlayerInterior(playerid, 0);
                    SetPlayerVirtualWorld(playerid, 0);
                    SetSpawnInfo(
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        case_1_spawns[spawn_index][0],
                        case_1_spawns[spawn_index][1],
                        case_1_spawns[spawn_index][2],
                        case_1_spawns[spawn_index][3],
                        0, 0, 0, 0, 0, 0
                    );
                }

                case 0:
                {
					SetPlayerSpawnSetting(playerid, 0);
					UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                    new team_id = GetPlayerTeamEx(playerid);
                    new Float:spawn_x = GetTeamData(team_id, O_SPAWN)[0];
                    new Float:spawn_y = GetTeamData(team_id, O_SPAWN)[1];
                    new Float:spawn_z = GetTeamData(team_id, O_SPAWN)[2];
                    new Float:spawn_angle = GetTeamData(team_id, O_SPAWN)[3];
                    new interior = GetTeamData(team_id, O_SPAWN_INT);
                    new virtual_world = GetTeamData(team_id, O_SPAWN_VW);

                    // Проверка на валидность координат
                    if (spawn_x == 0.0 && spawn_y == 0.0 && spawn_z == 0.0)
                    {
                        printf("Warning: Invalid spawn coordinates for team %d, using default spawn (Arzamas).", team_id);
                        spawn_x = spawn_pos_data[0][0]; // Арзамас
                        spawn_y = spawn_pos_data[0][1];
                        spawn_z = spawn_pos_data[0][2];
                        spawn_angle = spawn_pos_data[0][3];
                        interior = 0;
                        virtual_world = 0;
                    }

                    printf("Case 0: Team: %d, Pos: %f, %f, %f, Angle: %f, Interior: %d, VirtualWorld: %d", 
                        team_id, spawn_x, spawn_y, spawn_z, spawn_angle, interior);
                    
                    SetSpawnInfo(
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        spawn_x,
                        spawn_y,
                        spawn_z,
                        spawn_angle,
                        0, 0, 0, 0, 0, 0
                    );
                    SetPlayerInterior(playerid, interior);
                    SetPlayerVirtualWorld(playerid, virtual_world);
                }
                case 2:
                {
                    new Float:spawn_x;
                    new Float:spawn_y;
                    new Float:spawn_z;
                    new Float:spawn_angle;
                    new spawn_interior;
                    new spawn_world;

                    if(!GetRecentSpawnState(GetPlayerAccountID(playerid), spawn_x, spawn_y, spawn_z, spawn_angle, spawn_interior, spawn_world))
                    {
                        SetPlayerSpawnSetting(playerid, 0);
                        UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                        ApplyDefaultSpawnSelection(playerid);
						SRAdmin_OpenAfterSpawnSelection(playerid);
                        return 1;
                    }

                    SetPlayerSpawnSetting(playerid, 0);
                    UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                    SetSpawnInfo(
                        playerid,
                        0,
                        GetPlayerSkinEx(playerid),
                        spawn_x,
                        spawn_y,
                        spawn_z,
                        spawn_angle,
                        0, 0, 0, 0, 0, 0
                    );
                    SetPlayerInterior(playerid, spawn_interior);
                    SetPlayerVirtualWorld(playerid, spawn_world);
                }

                                                case 4:
                {
                    new house_ids = GetHouseNewByOwner(GetPlayerAccountID(playerid), playerid);
					if (house_ids != -1){
                        new house_id = GetHouseData(gHouseType[house_ids]);
                        printf("Case 4: HouseNew: %d, Type: %d, Pos: %f, %f, %f, Angle: %f, Interior: %d, VirtualWorld: %d",
                            house_ids, house_id, HouseData[house_id][hEnterX], HouseData[house_id][hEnterY],
                            HouseData[house_id][hEnterZ], HouseData[house_id][hEnterA],
                            1, 1);
						
                        SetSpawnInfo(
                            playerid,
                            0,
                            GetPlayerSkinEx(playerid),
                            HouseData[house_id][hSpawnX],
                            HouseData[house_id][hSpawnY],
                            HouseData[house_id][hSpawnZ],
                            HouseData[house_id][hSpawnA],
                            0, 0, 0, 0, 0, 0
                        );
                        SetPlayerInterior(playerid, 1);
                        SetPlayerVirtualWorld(playerid, house_ids);
						
					}
					new flat_ids = GetFlatNewByOwner(GetPlayerAccountID(playerid), playerid);
					if (flat_ids  != -1 ){
						
						new houseidv = g_flat_real_id[flat_ids];
						
                        new house_idg = gFlatType[houseidv/1000] - 1;
						if (g_flat_new_remont[flat_ids]){
							house_idg = 4;
						}
                        printf("SPAWNNNN %d", house_idg);
                        SetSpawnInfo(
                            playerid,
                            0,
                            GetPlayerSkinEx(playerid),
                            FlatData[house_idg][hSpawnX],
                            FlatData[house_idg][hSpawnY],
                            FlatData[house_idg][hSpawnZ],
                            FlatData[house_idg][hSpawnA],
                            0, 0, 0, 0, 0, 0
                        );
                        SetPlayerInterior(playerid, 1);
                        SetPlayerVirtualWorld(playerid, g_flat_real_id[flat_ids]);
						
					}
                }
                case 6:
                {
                    new fam_id = GetPlayerIdFamily(playerid);
                    new family_house_value = -1;

                    if(fam_id == -1)
                    {
                        SetPlayerSpawnSetting(playerid, 0);
                        UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                        ApplyDefaultSpawnSelection(playerid);
						SRAdmin_OpenAfterSpawnSelection(playerid);
                        return 1;
                    }

                    family_house_value = family[fam_id][family_house];
                    if(family_house_value == -1)
                    {
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Семейный спавн не установлен.", " ");
                        SetPlayerSpawnSetting(playerid, 0);
                        UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                        ApplyDefaultSpawnSelection(playerid);
						SRAdmin_OpenAfterSpawnSelection(playerid);
                        return 1;
                    }

                    // Convert the old apartment encoding (which was indistinguishable from a new house)
                    // to the dedicated flat encoding the first time a family member spawns there.
                    if(FamilySpawnIsNewHouse(family_house_value))
                    {
                        new legacy_property_id = FamilySpawnDecodeNewHouse(family_house_value);
                        if(!(0 <= legacy_property_id < HOUSES_FOR_SALE_COUNT) || !gHouseOwned[legacy_property_id])
                        {
                            new legacy_flat_id = FamilySpawnFindFlatByRealId(legacy_property_id);
                            if(legacy_flat_id != -1)
                            {
                                family_house_value = FamilySpawnEncodeNewFlat(legacy_flat_id);
                                SetFamily(fam_id, family_house, family_house_value);
                                mysql_format(mysql, f_string144, sizeof f_string144,
                                    "UPDATE familynew SET house=%d WHERE id=%d", family_house_value, GetFamily(fam_id, family_database));
                                mysql_query(mysql, f_string144, false);
                            }
                        }
                    }

                    SetPlayerSpawnSetting(playerid, 6);
                    UpdatePlayerDatabaseInt(playerid, "setting_spawn", 6);

                    if(FamilySpawnIsNewFlat(family_house_value))
                    {
                        new family_flat_id = FamilySpawnDecodeNewFlat(family_house_value);
                        if(!(0 <= family_flat_id < 200000) || !gFlatOwned[family_flat_id])
                        {
                            ShowNotificationNew(playerid, 2, 6, 0, 0, "Квартира семейного спавна не найдена.", " ");
                            SetPlayerSpawnSetting(playerid, 0);
                            UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                            ApplyDefaultSpawnSelection(playerid);
                            SRAdmin_OpenAfterSpawnSelection(playerid);
                            return 1;
                        }

                        new real_flat_id = g_flat_real_id[family_flat_id];
                        new flat_house_id = real_flat_id / 1000;
                        new flat_type_id = gFlatType[flat_house_id] - 1;
                        if(flat_type_id < 0 || flat_type_id >= sizeof FlatData) flat_type_id = 0;
                        if(g_flat_new_remont[family_flat_id]) flat_type_id = 4;

                        SetSpawnInfo(playerid, 0, GetPlayerSkinEx(playerid),
                            FlatData[flat_type_id][hSpawnX], FlatData[flat_type_id][hSpawnY],
                            FlatData[flat_type_id][hSpawnZ], FlatData[flat_type_id][hSpawnA],
                            0, 0, 0, 0, 0, 0);
                        SetPlayerInterior(playerid, 1);
                        SetPlayerVirtualWorld(playerid, real_flat_id);
                    }
                    else if(FamilySpawnIsNewHouse(family_house_value))
                    {
                        new family_house_id = FamilySpawnDecodeNewHouse(family_house_value);
                        new house_type_id;

                        if(!(0 <= family_house_id < HOUSES_FOR_SALE_COUNT) || !gHouseOwned[family_house_id])
                        {
                            ShowNotificationNew(playerid, 2, 6, 0, 0, "Дом семейного спавна не найден.", " ");
                            SetPlayerSpawnSetting(playerid, 0);
                            UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                            ApplyDefaultSpawnSelection(playerid);
							SRAdmin_OpenAfterSpawnSelection(playerid);
                            return 1;
                        }

                        house_type_id = GetHouseData(gHouseType[family_house_id]);
                        SetSpawnInfo(
                            playerid,
                            0,
                            GetPlayerSkinEx(playerid),
                            HouseData[house_type_id][hSpawnX],
                            HouseData[house_type_id][hSpawnY],
                            HouseData[house_type_id][hSpawnZ],
                            HouseData[house_type_id][hSpawnA],
                            0, 0, 0, 0, 0, 0
                        );
                        SetPlayerInterior(playerid, 1);
                        SetPlayerVirtualWorld(playerid, family_house_id);
                    }
					else
                    {
                        new family_house_id = GetHouseIndexBySQLID(family_house_value);
                        new house_type_id;

                        if(family_house_id == -1)
                        {
                            ShowNotificationNew(playerid, 2, 6, 0, 0, "Дом семейного спавна не найден.", " ");
                            SetPlayerSpawnSetting(playerid, 0);
                            UpdatePlayerDatabaseInt(playerid, "setting_spawn", 0);
                            ApplyDefaultSpawnSelection(playerid);
							SRAdmin_OpenAfterSpawnSelection(playerid);
                            return 1;
                        }

                        house_type_id = GetHouseData(family_house_id, H_TYPE);
                        SetSpawnInfo(
                            playerid,
                            0,
                            GetPlayerSkinEx(playerid),
                            GetHouseTypeInfo(house_type_id, HT_ENTER_POS_X),
                            GetHouseTypeInfo(house_type_id, HT_ENTER_POS_Y),
                            GetHouseTypeInfo(house_type_id, HT_ENTER_POS_Z),
                            GetHouseTypeInfo(house_type_id, HT_ENTER_POS_ANGLE),
                            0, 0, 0, 0, 0, 0
                        );
                        SetPlayerInterior(playerid, GetHouseTypeInfo(house_type_id, HT_INTERIOR));
                        SetPlayerVirtualWorld(playerid, family_house_id + 2000);
                        SetPlayerInHouse(playerid, family_house_id);
                    }
                }

			}	

            DeletePVar(playerid, "spawn_case1_twice");
            DeletePVar(playerid, "spawn_hnew_once");
            SetPVarInt(playerid, "spawn_select_once", 1);
            SetPVarInt(playerid, "spawn_select_id", spawn_id);
            SetPVarInt(playerid, "spawn_select_int", GetPlayerInterior(playerid));
            SetPVarInt(playerid, "spawn_select_vw", GetPlayerVirtualWorld(playerid));

            printf("[SpawnSelect] apply once | playerid=%d spawn_id=%d int=%d vw=%d", playerid, spawn_id, GetPlayerInterior(playerid), GetPlayerVirtualWorld(playerid));
            printf("Calling SpawnPlayer for playerid: %d", playerid);
            // The duplicate-request guard is armed only after OnPlayerSpawn succeeds.
            SpawnPlayer(playerid);
            if(GetPlayerData(playerid, P_HOSPITAL)) SetPlayerHealthEx(playerid, 30.0);
            else SetPlayerHealth(playerid, 100.0); // обычный спавн

            // OnPlayerSpawn already stops the audio stream. Sending the same
            // StopAudioStream RPC again in the same spawn window is redundant.
            SetCameraBehindPlayer(playerid);
            printf("Player %d spawn state: %d", playerid, GetPlayerState(playerid));
			SRAdmin_OpenAfterSpawnSelection(playerid);

            new JSON:json_response = JSON_Object();
            JSON_SetInt(json_response, "c", 1);
            printf("Sending OnPacketIncoming with c: 1");
            OnPacketIncoming(playerid, 50, json_response);
            JSON_Cleanup(json_response);
			
            JSON_Cleanup(JSONObject);
            ~json;
            JSON_Cleanup(json_packet_data);
        }
        
         case GUIRadialMenuForCar:
        {
            new vehicleid = GetPlayerVehicleID(playerid);
            new index = GetVehicleData(vehicleid, V_ACTION_ID); // Оставляем, если нужно для других частей

            new type;
            JSON_GetInt(json, "t", type);

            // Арендованный скутер не имеет ownable V_ACTION_ID (он равен -1),
            // поэтому его radial обрабатываем отдельно и никогда не читаем vInfo[-1].
            if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_RENT_BIKE)
            {
                if(GetPlayerData(playerid, P_RENT_BIKE) != vehicleid)
                {
                    JSON_SetInt(json, "s", 0);
                }
                else
                {
                    switch(type)
                    {
                        case 6: // Двигатель
                        {
                            if(IsPlayerDriver(playerid))
                            {
                                new engine = GetVehicleParam(vehicleid, V_ENGINE) ^ VEHICLE_PARAM_ON;
                                SetVehicleParam(vehicleid, V_ENGINE, engine);
                                JSON_SetInt(json, "s", engine == VEHICLE_PARAM_ON);
                            }
                            else JSON_SetInt(json, "s", 0);
                        }
                        case 14: // Фары
                        {
                            if(IsPlayerDriver(playerid))
                            {
                                new lights_state = GetVehicleParam(vehicleid, V_LIGHTS) ^ VEHICLE_PARAM_ON;
                                SetVehicleParam(vehicleid, V_LIGHTS, lights_state);
                                JSON_SetInt(json, "s", lights_state == VEHICLE_PARAM_ON);
                            }
                            else JSON_SetInt(json, "s", 0);
                        }
                        default: JSON_SetInt(json, "s", 0);
                    }
                }

                OnPacketIncoming(playerid, GUIRadialMenuForCar, json);
                JSON_Cleanup(JSONObject);
                ~json;
                JSON_Cleanup(json_packet_data);
                return 1;
            }

            switch(type)
            {
                //case 0: //Закрытие
				

                case 1: parksss(playerid);

                case 2:
                {
                    keyssss(playerid);
                }

                case 3:
                {
                    lockkkk(playerid);
                    if(GetVehicleParam(vehicleid, V_LOCK))     JSON_SetInt(json, "s", 1);
					else      JSON_SetInt(json, "s", 0);
                }
				
                case 5:
                {
                    // The loaded ownable-car row is authoritative. A tuning-cache
                    // rebuild must not turn a newly installed launch control back off.
                    new installed_launch = GetOwnableCarData(index, OC_LAUCH);
                    if(installed_launch == 0 && vInfo[index][vLaunchControl] != 0)
                    {
                        installed_launch = vInfo[index][vLaunchControl];
                        SetOwnableCarData(index, OC_LAUCH, installed_launch);
                    }
                    if(installed_launch != 0)
                    {
						if (vInfo[index][vLaunchControls] == 0){
							SetVehicleLaunchControl(vehicleid, installed_launch, 0);
						    JSON_SetInt(json, "s", 1);
							vInfo[index][vLaunchControls] = 1;
						}
					else{
							SetVehicleLaunchControl(vehicleid, 0, 0);
						    JSON_SetInt(json, "s", 0);
							vInfo[index][vLaunchControls] = 0;
						}
                    }
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не утановлен лаунч-контроль.", "");
                }

                case 6:
                {
					engineon(playerid);
					if(GetVehicleParam(vehicleid, V_ENGINE))     JSON_SetInt(json, "s", 1);
					else                                         JSON_SetInt(json, "s", 0);
                }
				
                case 8:
                {
                    if(GetOwnableCarData(index, OC_FSTATE) == FSTATE_DRIFT)
                    {
						ResetCarModes(playerid, vehicleid);
                        return 1;
                    }
                
                    if (CheckFirmwareLine(index, FSTATE_DRIFT))
                    {
						ResetCarModes(playerid, vehicleid);
						SetVehicleDriftForPlayer(playerid, vehicleid, 1);
						new query[90];
						new i = GetVehicleData(vehicleid, V_ACTION_ID);
						new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						mysql_format(mysql, query, sizeof query,
                            "UPDATE ownable_cars SET f_state = %d WHERE id = %d",
                            1, database_id
                        );
						mysql_query(mysql, query, false);
                        vInfo[index][vFstate] = FSTATE_DRIFT;
                        vInfo[vehicleid][vFstate] = vInfo[index][vFstate];
                        SetOwnableCarData(index, OC_FSTATE, FSTATE_DRIFT);
                        TechCenter_ApplyPerformance(vehicleid);
                        JSON_SetInt(json, "s", 1);
                    }
					else
                    {
                        ShowNotificationNew(playerid, 2, 3, 99, 0,
                            "У Вас не установлена эта прошивка!", "");
                        printf("[TECHCENTER][FIRMWARE] reject player=%d car=%d line=DRIFT db=%d", playerid, index, GetOwnableCarData(index, OC_SQL_ID));
                    }
                }

              
                case 9:
                {
                    if(GetOwnableCarData(index, OC_FSTATE) == FSTATE_COMFORT)
                    {
						ResetCarModes(playerid, vehicleid);
                        return 1;
                    }
                
                    if (CheckFirmwareLine(index, FSTATE_COMFORT))
                    {
						ResetCarModes(playerid, vehicleid);
						new query[90];
						new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						new i = GetVehicleData(vehicleid, V_ACTION_ID);
						mysql_format(mysql, query, sizeof query,
                            "UPDATE ownable_cars SET f_state = %d WHERE id = %d",
                            2, database_id
                        );
						mysql_query(mysql, query, false);
						SendCarFirmware(playerid, FSTATE_COMFORT);
                        vInfo[index][vFstate] = FSTATE_COMFORT;
                        vInfo[vehicleid][vFstate] = vInfo[index][vFstate];
                        SetOwnableCarData(index, OC_FSTATE, FSTATE_COMFORT);
                        TechCenter_ApplyPerformance(vehicleid);
                        JSON_SetInt(json, "s", 1);
                    }
					else
                    {
                        ShowNotificationNew(playerid, 2, 3, 99, 0,
                            "У Вас не установлена эта прошивка!", "");
                        printf("[TECHCENTER][FIRMWARE] reject player=%d car=%d line=COMFORT db=%d", playerid, index, GetOwnableCarData(index, OC_SQL_ID));
                    }
                }

                case 10:
                {
                    if(GetOwnableCarData(index, OC_FSTATE) == FSTATE_SPORT)
                    {
						ResetCarModes(playerid, vehicleid);
                        return 1;
                    }
                
                   if (CheckFirmwareLine(index, FSTATE_SPORT))
                    {
						new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						ResetCarModes(playerid, vehicleid);
						new i = GetVehicleData(vehicleid, V_ACTION_ID);
						new query[90];
						mysql_format(mysql, query, sizeof query,
                            "UPDATE ownable_cars SET f_state = %d WHERE id = %d",
                            3, database_id
                        );
						mysql_query(mysql, query, false);
						SendCarFirmware(playerid, FSTATE_SPORT);
                        vInfo[index][vFstate] = FSTATE_SPORT;
                        vInfo[vehicleid][vFstate] = vInfo[index][vFstate];
                        SetOwnableCarData(index, OC_FSTATE, FSTATE_SPORT);
                        TechCenter_ApplyPerformance(vehicleid);
                        JSON_SetInt(json, "s", 1);
                    }
					else
                    {
                        ShowNotificationNew(playerid, 2, 3, 99, 0,
                            "У Вас не установлена эта прошивка!", "");
                        printf("[TECHCENTER][FIRMWARE] reject player=%d car=%d line=SPORT db=%d", playerid, index, GetOwnableCarData(index, OC_SQL_ID));
                    }
                }

				case 11:
                {
                    if(GetOwnableCarData(index, OC_FSTATE) == FSTATE_SPORT_PLUS)
                    {
						ResetCarModes(playerid, vehicleid);
                        return 1;
                    }
					
                    if (CheckFirmwareLine(index, FSTATE_SPORT_PLUS))
                    {
						new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						ResetCarModes(playerid, vehicleid);
						new query[90];
						new i = GetVehicleData(vehicleid, V_ACTION_ID);
						
						mysql_format(mysql, query, sizeof query,
                            "UPDATE ownable_cars SET f_state = %d WHERE id = %d",
                            4, database_id
                        );
						mysql_query(mysql, query, false);
						printf("%d", database_id);
						new JSON:frimware = JSON_Object();
						SendCarFirmware(playerid, FSTATE_SPORT_PLUS);
                        vInfo[index][vFstate] = FSTATE_SPORT_PLUS;
                        vInfo[vehicleid][vFstate] = vInfo[index][vFstate];
                        SetOwnableCarData(index, OC_FSTATE, FSTATE_SPORT_PLUS);
                        TechCenter_ApplyPerformance(vehicleid);
                        JSON_SetInt(json, "s", 1);
                    }
					else
                    {
                        ShowNotificationNew(playerid, 2, 3, 99, 0,
                            "У Вас не установлена эта прошивка!", "");
                        printf("[TECHCENTER][FIRMWARE] reject player=%d car=%d line=SPORT_PLUS db=%d", playerid, index, GetOwnableCarData(index, OC_SQL_ID));
                    }
                }

                case 12:
                {
					if(vInfo[index][underlights_color] != 0 || vInfo[index][underlights_color_lf] != 0 || vInfo[index][underlights_color_rt] != 0)
                    {               
						
						new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
                        if(GetVehicleParam(vehicleid, V_ENGINE))
                        {
                            if(!vInfo[index][vEnableNeon])
                            {
								new query[90];
                                vInfo[index][vEnableNeon] = true;
								mysql_format(mysql, query, sizeof query,
                                  "UPDATE ownable_cars SET EnableNeon = %d WHERE id = %d",
                                  1, database_id
                                );
					            mysql_query(mysql, query, false);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
									SetVehicleNeonForPlayer(streamPlayer, GetPlayerVehicleID(playerid), vInfo[index][underlights_color], vInfo[index][underlights_color_lf], vInfo[index][underlights_color_rt]);
                                }
								SetVehicleNeonForPlayer(playerid, GetPlayerVehicleID(playerid), vInfo[index][underlights_color], vInfo[index][underlights_color_lf], vInfo[index][underlights_color_rt]);
                         
                                JSON_SetInt(json, "s", 1);
                            }
					else
                            {
								new query[90];
                                vInfo[index][vEnableNeon] = false;
								mysql_format(mysql, query, sizeof query,
                                  "UPDATE ownable_cars SET EnableNeon = %d WHERE id = %d",
                                  0, database_id
                                );
					            mysql_query(mysql, query, false);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
									SetVehicleNeonForPlayer(streamPlayer, vehicleid, 0, 0, 0);
								}
                                SetVehicleNeonForPlayer(playerid, vehicleid, 0, 0, 0);
                                JSON_SetInt(json, "s", 0);
                            }
                        }
                    }
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "У Вас не установлена подсветка!", "");
                }
                case 13:
                {
                   if(vInfo[index][IsFarLightBought] != 0)
                    {
						new query[90];
                        if(vInfo[index][IsFarLightActive] == 0)
                        {
                            vInfo[index][IsFarLightActive] = 1;
							new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						    mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET is_FarLight_active = %d WHERE id = %d",
                               1, database_id
                            );
							foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    SetVehicleFarLight(streamPlayer, vehicleid, 1);
							}
								
							SetVehicleFarLight(playerid, vehicleid, 1);
					    	mysql_query(mysql, query, false);
                            JSON_SetInt(json, "s", 1);
                        }
					else
                        {
                            vInfo[index][IsFarLightActive] = 0;
							new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
							mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET is_FarLight_active = %d WHERE id = %d",
                               0, database_id
                            );
							foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    SetVehicleFarLight(streamPlayer, vehicleid, 0);
							}
							SetVehicleFarLight(playerid, vehicleid, 0);
					    	mysql_query(mysql, query, false);
                            JSON_SetInt(json, "s", 0);
                        }
                    }
					else
                    {
                        ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не установлен дальний свет фар.", "");
                    }
                }
                case 14:
                {
                    lightss(playerid);
                    if(GetVehicleParam(vehicleid, V_LIGHTS)) JSON_SetInt(json, "s", 1);
					else
                    {
                        JSON_SetInt(json, "s", 0);
                    }
                }
                case 15:
                {
                    if(vInfo[vehicleid][vStrob] != 0)
                    {
                        if(GetVehicleParam(vehicleid, V_ENGINE))
                        {
                            if(!EnableStrob[vehicleid])
                            {
                                EnableStrob[vehicleid] = true;
                                SetVehicleParam(vehicleid, V_ENGINE, true);
                                SetVehicleParam(vehicleid, V_LIGHTS, true);
                                SetVehicleStroboscope(vehicleid, vInfo[vehicleid][vStrob] - 1, 0);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleStroboscopeForPlayere(streamPlayer,vehicleid, vInfo[vehicleid][vStrob] - 1);
							}
                                JSON_SetInt(json, "s", 1);
                                OnPacketIncoming(playerid, GUIRadialMenuForCar, json);

                                JSON_SetInt(json, "t", 14);
                            }
					else
                            {
                                EnableStrob[vehicleid] = false;
                                SetVehicleStroboscope(vehicleid, 5, 0);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleStroboscopeForPlayere(streamPlayer,vehicleid, 5);
							}
                                SetVehicleParam(vehicleid, V_ENGINE, true);
                                SetVehicleParam(vehicleid, V_LIGHTS, true);

                                JSON_SetInt(json, "s", 0);
                            }
                        }
                    }
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не установлены стробоскопы.", "");
                }
                case 16:
                {
					new query[90];
                    if(vInfo[index][IsPnevmoBought] != 0)
                    {
						if (vInfo[index][SelectedPnevmo] != 1){
							static const modes[] = { 16, 17, 18};

                            new JSON:tmp = JSON_Object();
                             
                            for (new i = 0; i < sizeof(modes); i++)
                            {
                                JSON_SetInt(tmp, "t", modes[i]);
                                JSON_SetInt(tmp, "s", 0);
                                OnPacketIncoming(playerid, GUIRadialMenuForCar, tmp);
                            }
                            vInfo[index][SelectedPnevmo] = 1;
						    new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						    mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET pnevmo_selected = %d WHERE id = %d",
                               1, database_id
                            );
					        mysql_query(mysql, query, false);
                            JSON_SetInt(json, "s", 1);
							foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, 0.55);
							}
						    SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.55);
						}
					else{
							vInfo[index][SelectedPnevmo] = 0;
							if (vInfo[index][percentofclirness] > 0 && vInfo[index][SelectedPnevmo] == 0){
	                            new Float:suspension = max(vInfo[index][percentofclirness] / 50.0, 0.2);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
							     	
							         
						            SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, suspension);
							    }
                                SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, suspension);
	                        }
					else{
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
							     	
							         
						            SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, 0.99);
							    }
	                        	SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.99);
	                        }
						    new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						    mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET pnevmo_selected = %d WHERE id = %d",
                               0, database_id
                            );
					        mysql_query(mysql, query, false);
							JSON_SetInt(json, "s", 0);
							static const modes[] = { 16, 17, 18};

                            new JSON:tmp = JSON_Object();
                             
                            for (new i = 0; i < sizeof(modes); i++)
                            {
                                JSON_SetInt(tmp, "t", modes[i]);
                                JSON_SetInt(tmp, "s", 0);
                                OnPacketIncoming(playerid, GUIRadialMenuForCar, tmp);
                            }
						    
						}
                    }
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не установлена пневмоподвеска.", "");
                }
                case 17:
                {
                    if(vInfo[index][IsPnevmoBought] != 0)
                    {
						new query[90];
						if (vInfo[index][SelectedPnevmo] != 2){
							static const modes[] = { 16, 17, 18};

                            new JSON:tmp = JSON_Object();
                             
                            for (new i = 0; i < sizeof(modes); i++)
                            {
                                JSON_SetInt(tmp, "t", modes[i]);
                                JSON_SetInt(tmp, "s", 0);
                                OnPacketIncoming(playerid, GUIRadialMenuForCar, tmp);
                            }
                            vInfo[index][SelectedPnevmo] = 2;
						    new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						    mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET pnevmo_selected = %d WHERE id = %d",
                               2, database_id
                            );
					        mysql_query(mysql, query, false);
                            JSON_SetInt(json, "s", 1);
							
						    SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.35);
							foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, 0.35);
							}
						}
					else{
							vInfo[index][SelectedPnevmo] = 0;
							if (vInfo[index][percentofclirness] > 0 && vInfo[index][SelectedPnevmo] == 0){
                            	new Float:suspension = max(vInfo[index][percentofclirness] / 50.0, 0.2);
                                SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, suspension);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, suspension);
							}
                            }
					else{
                            	SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.99);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, 0.99);
							}
                            }
						    new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						    mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET pnevmo_selected = %d WHERE id = %d",
                               0, database_id
                            );
					        mysql_query(mysql, query, false);
							static const modes[] = { 16, 17, 18};

                            new JSON:tmp = JSON_Object();
                             
                            for (new i = 0; i < sizeof(modes); i++)
                            {
                                JSON_SetInt(tmp, "t", modes[i]);
                                JSON_SetInt(tmp, "s", 0);
                                OnPacketIncoming(playerid, GUIRadialMenuForCar, tmp);
                            }
							JSON_SetInt(json, "s", 0);
						}
                    }
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не установлена пневмоподвеска.", "");
                }
                case 18:
                {
                    if(vInfo[index][IsPnevmoBought] != 0)
                    {
						new query[90];
						if (vInfo[index][SelectedPnevmo] != 3){
							static const modes[] = { 16, 17, 18};

                            new JSON:tmp = JSON_Object();
                             
                            for (new i = 0; i < sizeof(modes); i++)
                            {
                                JSON_SetInt(tmp, "t", modes[i]);
                                JSON_SetInt(tmp, "s", 0);
                                OnPacketIncoming(playerid, GUIRadialMenuForCar, tmp);
                            }
                            vInfo[index][SelectedPnevmo] = 3;
							
						    new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						    mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET pnevmo_selected = %d WHERE id = %d",
                               3, database_id
                            );
					        mysql_query(mysql, query, false);
							
						    SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.2);
							foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, 0.2);
							}
                            JSON_SetInt(json, "s", 1);
						}
					else{
							vInfo[index][SelectedPnevmo] = 0;
							if (vInfo[index][percentofclirness] > 0 && vInfo[index][SelectedPnevmo] == 0){
	                        	new Float:suspension = max(vInfo[index][percentofclirness] / 50.0, 0.2);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, suspension);
							}
                                SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, suspension);
	                        }
					else{
	                        	SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.99);
								foreach(new streamPlayer : streamed_players_in_veh[vehicleid])
{
								
							    
						    SetVehicleSuspensionBiasForPlayer(streamPlayer, vehicleid, 0.99);
							}
	                        }
						    new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						    mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET pnevmo_selected = %d WHERE id = %d",
                               0, database_id
                            );
					        mysql_query(mysql, query, false);
							JSON_SetInt(json, "s", 0);
							static const modes[] = { 16, 17, 18};

                            new JSON:tmp = JSON_Object();
                             
                            for (new i = 0; i < sizeof(modes); i++)
                            {
                                JSON_SetInt(tmp, "t", modes[i]);
                                JSON_SetInt(tmp, "s", 0);
                                OnPacketIncoming(playerid, GUIRadialMenuForCar, tmp);
                            }
						}
                    }
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не установлена пневмоподвеска.", "");
                }
                case 19:
                {
                    if(vInfo[index][IsHydroBought] != 0)
                    {
						new query[90];
                        if(vInfo[index][IsHydroActive] == 0)
                        {
                            vInfo[index][IsHydroActive] = 1;
							new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
						    mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET is_hydro_active = %d WHERE id = %d",
                               1, database_id
                            );
					    	mysql_query(mysql, query, false);
                            SetVehicleHydraulics(vehicleid, 1, 0);
                            JSON_SetInt(json, "s", 1);
                        }
					else
                        {
                            vInfo[index][IsHydroActive] = 0;
							new database_id = GetOwnableCarData(GetVehicleData(vehicleid, V_ACTION_ID), OC_SQL_ID);
							mysql_format(mysql, query, sizeof query,
                               "UPDATE ownable_cars SET is_hydro_active = %d WHERE id = %d",
                               0, database_id
                            );
					    	mysql_query(mysql, query, false);
                            SetVehicleHydraulics(vehicleid, 0, 0);
                            JSON_SetInt(json, "s", 0);
                        }
                    }
					else ShowNotificationNew(playerid, 2, 3, 99, 0, "В авто не установлена гидравлика.", "");
                }
            }
            OnPacketIncoming(playerid, GUIRadialMenuForCar, json);
            
            JSON_Cleanup(JSONObject);
            ~json;
            JSON_Cleanup(json_packet_data);
            return 1;
        }



case 13:
{
    new notify_type = -1, notify_id = -1, notify_sub_id = -1;
    JSON_GetInt(json, "t", notify_type);
    JSON_GetInt(json, "s", notify_id);
    JSON_GetInt(json, "b", notify_sub_id);
    // Trade notifications reuse generic button/action values. Handle an active
    // trade invite before vehicle notifications so accepting cannot toggle engine.
    if(Inv11Trade_HandleNotifyClick(playerid, notify_id, notify_sub_id))
    {
        return 1;
    }

    if(FsinFull_OnNotificationClick(playerid,notify_id,notify_sub_id))
    {
        return 1;
    }

    if(FamilyHandleInviteNotification(playerid, notify_type, notify_id, notify_sub_id))
    {
        return 1;
    }

    if(CarPass_HandleNotifyClick(playerid, notify_type, notify_id, notify_sub_id))
    {
        return 1;
    }

    if(HRDepartment_HandleNotification(playerid, notify_type, notify_id, notify_sub_id))
    {
        return 1;
    }

    #if defined _SYSTEM_FIRESYSTEM_INCLUDED
    if(FireSystem_HandleNotifyClick(playerid, notify_type, notify_id, notify_sub_id))
    {
        return 1;
    }
    #endif

	if(notify_type == 0 && Larek_HandleNotificationClickPublic(playerid, notify_id))
	{
		return 1;
	}

	if(notify_id == 9119)
	{
		if(notify_type == 0)
		{
			ShowPlayerHouseExitPickupDialog(playerid, notify_sub_id);
		}
		return 1;
	}
	if(notify_id == 9120)
    {
		if(notify_type == 0)
		{
			ShowPlayerFlatExitPickupDialog(playerid, notify_sub_id);
		}
		return 1;
	}
	if(notify_id == 9198)
    {
		if(notify_type == 0)
		{
			HandlePlayerFlatsNewPickup(playerid, notify_sub_id);
		}
		return 1;
	}
	if(notify_id == 9201)
    {
		if(notify_type == 0)
		{
			ShowPlayerATMDialog(playerid);
		}
		return 1;
	}
    if(notify_id == 9101 || notify_sub_id == 9101)
    {
        printf("[TRUNKTEST][NOTIFY] click: player=%d t=%d s=%d b=%d", playerid, notify_type, notify_id, notify_sub_id);
        if(notify_type == 0)
        {
            TrunkTest_TryOpenNearby(playerid, true);
        }
        return 1;
    }

    if(notify_id == 9102 || notify_sub_id == 9102)
    {
        if(notify_type == 0)
        {
            new vehicleid = notify_sub_id;
            if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
            {
                vehicleid = GetPlayerOwnableCar(playerid);
            }

            if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
            {
                new Float:veh_x, Float:veh_y, Float:veh_z;
                GetVehiclePos(vehicleid, veh_x, veh_y, veh_z);

                if(IsPlayerInRangeOfPoint(playerid, 10.0, veh_x, veh_y, veh_z))
                {
                    ToggleLock(playerid, vehicleid);
                }
                else
                {
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Подойдите к личному или семейному транспорту", " ");
                }
            }
        }
        return 1;
    }

    if(notify_id == MED_BED_NOTIFY_ID)
    {
        if(notify_type == 0)
        {
            MedBed_TryOccupy(playerid, notify_sub_id - 1);
        }
        return 1;
    }

    if(notify_type == 0 && notify_id == 1)
    {
        new vehicleid = notify_sub_id;
        if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
        {
            vehicleid = GetPlayerVehicleID(playerid);
        }

        if(vehicleid != INVALID_VEHICLE_ID)
        {
            OnPlayerNotificationClick(playerid, 13, notify_id, vehicleid);
        }
        return 1;
    }

    return 1;

}

case 66:
{
    // GUI 66 используется и репортом, и слежкой. Репорт должен обрабатываться ПЕРВЫМ:
    // проверка телепорта из /sp не имеет отношения к кнопкам ответа на жалобу.
    if(GetPVarInt(playerid, "REPORT_GUI_ACTIVE"))
    {
        if(!ReportGUI_IsAdminAuthorized(playerid))
        {
            ReportGUI_RequeueActive(playerid);
            return 1;
        }

        new report_close, report_type, report_button, report_template;
        JSON_GetInt(json, "c", report_close);
        JSON_GetInt(json, "t", report_type);
        JSON_GetInt(json, "b", report_button);
        JSON_GetInt(json, "bi", report_template);

        // "Свой ответ": старый обработчик ошибочно считал b=2 закрытием и стирал
        // REPORT_GUI_ACTIVE. Поэтому последующий пакет t=5 уже не мог отправить текст.
        // Теперь b=2 лишь переводит GUI в режим собственного ответа и сохраняет цель.
        if(report_type == 3 && report_button == 2)
        {
            SetPVarInt(playerid, "REPORT_GUI_CUSTOM", 1);

            new immediate_answer[144];
            if(ReportGUI_ReadCustomAnswer(json, immediate_answer, sizeof immediate_answer))
            {
                utf8_to_cp1251(immediate_answer);
                return ReportGUI_SendAnswer(playerid, immediate_answer);
            }
            return Dialog(playerid, DIALOG_RESERVED_SUPPORT_EDIT, DIALOG_STYLE_INPUT,
                "Свой ответ на репорт", "Введите текст ответа игроку:", "Отправить", "Назад");
        }

        // Некоторые версии клиента присылают текст вместе с c=1 (закрытие окна).
        // Ответ имеет приоритет, чтобы он не потерялся при закрытии input GUI.
        if(report_type == 5 || GetPVarInt(playerid, "REPORT_GUI_CUSTOM"))
        {
            new report_answer[144];
            if(ReportGUI_ReadCustomAnswer(json, report_answer, sizeof report_answer))
            {
                utf8_to_cp1251(report_answer);
                ReportGUI_SendAnswer(playerid, report_answer);
                return 1;
            }
        }

        if(report_close == 1)
        {
            // Просто закрыли окно — не теряем жалобу, а возвращаем её в очередь.
            ReportGUI_RequeueActive(playerid);
            return 1;
        }

        switch(report_type)
        {
            case 3:
            {
                if(report_button == 1) ReportGUI_SendTemplates(playerid);
            }
            case 4:
            {
                if(report_template > 0) ReportGUI_SendTemplateAnswer(playerid, report_template);
            }
        }
        return 1;
    }

    if(!SRAdmin_TeleportAllowed(playerid)) return 1;

    new c;
    if(JSON_GetType(json, "c") == JSON_NODE_NUMBER)
    {
        JSON_GetInt(json, "c", c);
        if(c == 1)
        {
            new ignore_close_until = GetPVarInt(playerid, "sp_gui_ignore_close_until");
            if(ignore_close_until > GetTickCount())
            {
                printf("[SP][GUI] close ignored admin=%d now=%d until=%d", playerid, GetTickCount(), ignore_close_until);
                return 1;
            }

            DeletePVar(playerid, "sp_gui_ignore_close_until");
            StopSpectateGUIRefresh(playerid);
            if(GetPlayerSpectateData(playerid, S_PLAYER) != -1)
            {
                printf("[SP][GUI] close accepted admin=%d target=%d", playerid, GetPlayerSpectateData(playerid, S_PLAYER));
                StopSpectate(playerid);
                Spectate_RestoreSkin(playerid);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Слежение остановлено.", "qq");
            }
            return 1;
        }
    }

    new t;
    JSON_GetInt(json, "t", t);

    new b, bi;
    JSON_GetInt(json, "b", b);
    JSON_GetInt(json, "bi", bi);

    new target = GetPlayerSpectateData(playerid, S_PLAYER);

    switch(t)
    {
        case 1:
        {
            if(target == -1 || !IsPlayerConnected(target) || !IsPlayerLogged(target))
                return ShowNotificationNew(playerid, 2, 6, 0, 0, "Слежение не активно", "qq");

            switch(b)
            {
                case 1:
                {
                    new players[MAX_PLAYERS], count;
                    for(new i = 0; i < MAX_PLAYERS; i++)
                    {
                        if(Spectate_CanWatchPlayer(playerid, i) && i != target)
                            players[count++] = i;
                    }
                    if(!count)
                        return ShowNotificationNew(playerid, 2, 6, 0, 0, "Нет других игроков на сервере", "qq");

                    new next = players[random(count)];
                    StartSpectate(playerid, next);
                    StartSpectateGUIRefresh(playerid);
                    Spectate_HideSkin(playerid);
                    ShowSpectateGUI(playerid, next);
                }
                case 2, 9:
                {
                    new dir = (b == 9) ? 1 : -1;
                    new next = GetNextPlayer(playerid, target, dir);
                    if(next == INVALID_PLAYER_ID || next == target || !Spectate_CanWatchPlayer(playerid, next))
                        return ShowNotificationNew(playerid, 2, 6, 0, 0, "Нет других игроков на сервере", "qq");

                    StartSpectate(playerid, next);
                    StartSpectateGUIRefresh(playerid);
                    Spectate_HideSkin(playerid);
                    ShowSpectateGUI(playerid, next);
                }
                case 3, 4, 5, 6, 7, 8: SpectateGUI_SendPunishTemplates(playerid, b);
                case 10: ShowPlayerStats(playerid, target);
                case 11: SpectateGUI_ShowControlPanel(playerid);
            }
        }
        case 2:
        {
            if(target == -1 || !IsPlayerConnected(target) || !IsPlayerLogged(target))
                return ShowNotificationNew(playerid, 2, 6, 0, 0, "Слежение не активно", "qq");
            if(bi > 0) SpectateGUI_ApplyPunish(playerid, target, bi);
        }
        case 6:
        {
            if(bi == 7) SpectateGUI_ShowCategories(playerid);
        }
        case 7:
        {
            if(bi >= 3 && bi <= 8) SpectateGUI_SendPunishTemplates(playerid, bi);
        }
    }

    return 1;
}


        case 33:
{
    new JSON:response;
    new type;
    JSON_GetInt(json, "t", type);

    response = JSON_Object();

    new item_id, pos, old_pos, new_w = Inventory11_GetCurrentWeightKg(playerid);
    new refresh_inventory_after_response = 0;
    new send_response = 1;

    // SIM REMOVE REALFIX V2:
    // The equipped SIM is a dedicated client slot (7), not a regular row in
    // `inventory`. Different mobile builds report a drag from this slot using
    // slightly different packet types/fields. Catch it before the generic
    // inventory/trade handlers so the request cannot fall through to a normal
    // DB slot swap.
    new active_sim_drag_handled = 0;
    new active_sim_phone = GetPlayerPhone(playerid);
    if(active_sim_phone > 0 && type != 19)
    {
        new sim_ga = 0, sim_os = -1, sim_s = 0, sim_i = -1, sim_ns = 0;
        JSON_GetInt(json, "ga", sim_ga);
        JSON_GetInt(json, "os", sim_os);
        JSON_GetInt(json, "s", sim_s);
        JSON_GetInt(json, "i", sim_i);
        JSON_GetInt(json, "ns", sim_ns);

        new bool:sim_identity = (sim_ga == 58 || sim_ga == 997 || sim_ga == active_sim_phone);
        new bool:from_active_sim_slot = false;

        // `i=7` is the dedicated equipped-SIM slot in the client response.
        if(sim_i == 7 && sim_identity)
            from_active_sim_slot = true;

        // Some builds put the source in `os`. Slot 7 overlaps the normal
        // inventory numbering, so only accept it as equipped SIM when the
        // payload identifies a SIM, or when no physical SIM row occupies slot 7.
        if(!from_active_sim_slot && sim_os == 7)
        {
            if(sim_identity || !Inventory11_HasInventoryItemInSlot(playerid, 7, 58))
                from_active_sim_slot = true;
        }

        // The native client uses visual/model id 997 for the equipped SIM. If
        // it reports that id, it cannot be a normal inventory item (DB item id
        // is 58), so treat it as the phone slot even if the source field differs.
        if(!from_active_sim_slot && sim_ga == 997)
            from_active_sim_slot = true;

        if(from_active_sim_slot)
        {
            new target_slot = sim_s;
            if(sim_ns > 0) target_slot = sim_ns;

            new removed_sim = 0;
            new bool:sim_move_ok = Inventory11_MoveActiveSimToInventorySlot(playerid, target_slot, removed_sim);

            JSON_SetInt(response, "t", type);
            JSON_SetInt(response, "s", sim_move_ok ? 1 : 0);
            JSON_SetInt(response, "nm", sim_move_ok ? 0 : active_sim_phone);
            JSON_SetInt(response, "i", 7);
            JSON_SetInt(response, "w", Inventory11_GetCurrentWeightKg(playerid));

            if(sim_move_ok)
            {
                refresh_inventory_after_response = 1;
                new sim_notif[72];
                format(sim_notif, sizeof(sim_notif), "SIM-карта %d извлечена в инвентарь", removed_sim);
                ShowNotificationNew(playerid, 3, 6, 0, 0, sim_notif, " ");
            }

            printf("[INV11][SIM] generic active->inventory: player=%d type=%d ga=%d os=%d s=%d i=%d ns=%d phone=%d ok=%d",
                playerid, type, sim_ga, sim_os, sim_s, sim_i, sim_ns, active_sim_phone, sim_move_ok);
            active_sim_drag_handled = 1;
        }
    }

    if(active_sim_drag_handled)
    {
    }
    else if(Inv11Trade_HandlePacket(playerid, json, response, refresh_inventory_after_response, send_response))
    {
    }
					else if (type == 0)
    {
        new count;
        JSON_GetInt(json, "ga", item_id);
        JSON_GetInt(json, "s", count);
        new nt[32];
        JSON_GetString(json, "nt", nt, sizeof(nt));
        JSON_SetInt(response, "t", 0);
        JSON_SetInt(response, "s", 1);
    }
					else if (type == 1)
    {
        new count;
        JSON_GetInt(json, "ga", item_id);
        JSON_GetInt(json, "s", count);
        new nt[32];
        JSON_GetString(json, "nt", nt, sizeof(nt));
        JSON_SetInt(response, "t", 1);
        JSON_SetInt(response, "s", 1);
    }
					else if (type == 4)
    {
        JSON_GetInt(json, "ga", item_id);
        JSON_GetInt(json, "os", old_pos);
        JSON_GetInt(json, "s", pos);
        new raw_active_slot = -1, raw_new_slot = -1;
        JSON_GetInt(json, "i", raw_active_slot);
        JSON_GetInt(json, "ns", raw_new_slot);

        // SIM REMOVE REALFIX: equipped SIM can arrive as item 58, visual id 997,
        // or with equip slot 7 reported through `i` instead of `os`.
        if(old_pos <= 0 && raw_active_slot == 7) old_pos = 7;
        if(pos <= 0 && raw_new_slot > 0) pos = raw_new_slot;
        if(old_pos == 0) old_pos = 1;
        if(pos == 0) pos = 1;
        printf("[INV11] type=4 move request: player=%d ga=%d os=%d s=%d i=%d ns=%d", playerid, item_id, old_pos, pos, raw_active_slot, raw_new_slot);

        if(item_id == 134 && old_pos == 6)
        {
            ShowNotificationNew(playerid, 2, 6, 0, 0, "Нельзя снять одежду", " ");
            JSON_SetInt(response, "t", 4);
            JSON_SetInt(response, "s", 0);
            printf("[INV11] type=4 blocked: player=%d ga=%d reason=no_takeoff_active_slot", playerid, item_id);
        }
					else
        {
            new bool:db_ok = false;
            new active_model = 0;
            new current_sim_number = GetPlayerPhone(playerid);
            new bool:is_sim_identity = (item_id == 58 || item_id == 997 || (current_sim_number > 0 && item_id == current_sim_number));
            new bool:is_active_sim_move = (current_sim_number > 0 && old_pos == 7 && is_sim_identity);
            new bool:is_active_acc_move = (Inventory11_IsAccessoryItem(item_id) && (old_pos >= 1 && old_pos <= INVENTORY11_MAX_ACTIVE_ACCESSORIES) && !Inventory11_HasInventoryItemInSlot(playerid, old_pos, item_id));

            // Some client builds send ga=0 for the dedicated SIM equip slot.
            if(!is_active_sim_move && current_sim_number > 0 && old_pos == 7 && !Inventory11_HasInventoryItemInSlot(playerid, old_pos, item_id))
            {
                if(item_id <= 0 || item_id == 997 || raw_active_slot == 7)
                    is_active_sim_move = true;
            }

            if(is_active_sim_move)
            {
                new removed_sim = 0;
                db_ok = Inventory11_MoveActiveSimToInventorySlot(playerid, pos, removed_sim);
                if(db_ok)
                {
                    JSON_SetInt(response, "nm", 0);
                    JSON_SetInt(response, "i", 7);
                    refresh_inventory_after_response = 1;
                    new sim_notif[72];
                    format(sim_notif, sizeof(sim_notif), "SIM-карта %d извлечена в инвентарь", removed_sim);
                    ShowNotificationNew(playerid, 3, 6, 0, 0, sim_notif, " ");
                    printf("[INV11][SIM] type=4 active->inventory player=%d number=%d target_slot=%d", playerid, removed_sim, pos);
                }
            }
					else if(is_active_acc_move)
            {
                db_ok = Inventory11_MoveActiveAccessoryToInventorySlot(playerid, item_id, old_pos, pos, active_model);
                if(db_ok)
                {
                    Inventory11_SetAiArrayOnJson(playerid, response);
                    refresh_inventory_after_response = 1;
                    printf("[INV11] type=4 accessory moved active->inventory: player=%d item=%d active_slot=%d inv_slot=%d model=%d", playerid, item_id, old_pos, pos, active_model);
                }
            }
					else
            {
                db_ok = Inventory11_SwapSlotsInDatabase(playerid, old_pos, pos);
            }

            JSON_SetInt(response, "t", 4);
            JSON_SetInt(response, "s", db_ok ? 1 : 0);
            JSON_SetInt(response, "nw", 200);
            JSON_SetInt(response, "ns", 20);
            printf("[INV11] type=4 result: player=%d ga=%d os=%d s=%d db_ok=%d", playerid, item_id, old_pos, pos, db_ok);
        }
    }
					else if (type == 5)
    {
        JSON_GetInt(json, "ga", item_id);
        JSON_GetInt(json, "s", pos);
        if(pos == 0) pos = 1;
        new count;
        JSON_GetInt(json, "i", count);
        JSON_SetInt(response, "t", 5);
        JSON_SetInt(response, "s", 1);
        JSON_SetInt(response, "w", new_w);
    }
					else if (type == 18)
    {
        JSON_GetInt(json, "ga", item_id);
        JSON_GetInt(json, "s", pos);
        if(pos == 0) pos = 1;

        new bool:db_ok = Inventory11_DeleteSlotFromDatabase(playerid, pos);

        if(db_ok)
        {
            new_w -= GetItemWeight(item_id);
            if(new_w < 0) new_w = 0;
        }

        JSON_SetInt(response, "t", 18);
        JSON_SetInt(response, "s", db_ok ? 1 : 0);
        JSON_SetInt(response, "w", new_w);
        printf("[INV11] type=18 delete result: player=%d ga=%d slot=%d db_ok=%d", playerid, item_id, pos, db_ok);
    }
					else if (type == 19)
    {
        JSON_GetInt(json, "ga", item_id);
        JSON_GetInt(json, "s", pos);
        if(pos == 0) pos = 1;
        new req_old_slot = -1;
        JSON_GetInt(json, "os", req_old_slot);
        printf("[INV11] type=19 request raw: player=%d ga=%d os=%d s=%d", playerid, item_id, req_old_slot, pos);

        if(item_id == 134 && req_old_slot <= 0)
        {
            req_old_slot = pos;
        }

        if(item_id == 134 && req_old_slot > 0)
        {
            pos = req_old_slot;
            printf("[INV11] type=19 use os as source slot: player=%d slot=%d", playerid, pos);
        }

        new notif[64];

        if(item_id == 22)
        {
            new left_amount = 0;
            new bool:db_ok = Inventory11_ConsumeMedkitBySlot(playerid, pos, left_amount);

            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", db_ok ? 1 : 0);

            if(db_ok)
            {
                new Float:health;
                GetPlayerHealth(playerid, health);
                health += 60.0;
                if(health > 100.0) health = 100.0;

                SetPlayerHealthEx(playerid, health);
                ApplyAnimationEx(playerid, "ped", "gum_eat", 4.0, 0, 0, 0, 0, 0, 1);

                new_w -= GetItemWeight(item_id);
                if(new_w < 0) new_w = 0;

                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы использовали аптечку. Здоровье пополнено на 60 единиц", " ");
            }
        }
					else if(item_id == INV_ITEM_REPAIR_KIT)
        {
            JSON_SetInt(response, "t", 19);

            new vehicleid = GetNearestVehicleID(playerid, 4.0);
            if(vehicleid == INVALID_VEHICLE_ID)
            {
                JSON_SetInt(response, "s", 0);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Рядом нет автомобиля", " ");
            }
            else
            {
                new Float:vehicle_health;
                GetVehicleHealth(vehicleid, vehicle_health);

                if(vehicle_health >= 999.0)
                {
                    JSON_SetInt(response, "s", 0);
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Автомобиль уже полностью исправен", " ");
                }
                else if(!Inventory11_HasInventoryItemInSlot(playerid, pos, INV_ITEM_REPAIR_KIT))
                {
                    JSON_SetInt(response, "s", 0);
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Ремонтный комплект не найден в этом слоте", " ");
                }
                else if(!Inventory11_DeleteSlotFromDatabase(playerid, pos))
                {
                    JSON_SetInt(response, "s", 0);
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось использовать ремонтный комплект", " ");
                }
                else
                {
                    RepairVehicle(vehicleid);
                    SetVehicleHealth(vehicleid, 1000.0);
                    SetVehicleData(vehicleid, V_HEALTH, 1000.0);

                    JSON_SetInt(response, "s", 1);
                    refresh_inventory_after_response = 1;

                    PlayerPlaySound(playerid, 1133, 0.0, 0.0, 0.0);
                    ShowNotificationNew(playerid, 3, 6, 0, 0, "Автомобиль полностью отремонтирован", " ");
                    SetPlayerChatBubble(playerid, "починил автомобиль с помощью ремонтного комплекта", 0x3399FFFF, 10.0, 2500);
                    printf("[INV11][REPAIR_KIT] player=%d vehicle=%d slot=%d repaired_to=1000", playerid, vehicleid, pos);
                }
            }
        }
					else if(item_id == 58)
        {
            new sim_number = 0;
            new current_number = GetPlayerPhone(playerid);

            JSON_SetInt(response, "t", 19);

            if(!Inventory11_PlayerHasPhoneDevice(playerid))
            {
                JSON_SetInt(response, "s", 0);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Сначала нужно приобрести телефон", " ");
            }
					else if(!Inventory11_GetSimBySlot(playerid, pos, sim_number))
            {
                JSON_SetInt(response, "s", 0);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось прочитать SIM-карту", " ");
            }
					else
            {
                new query_check[128];
                mysql_format(mysql, query_check, sizeof(query_check), "SELECT id FROM accounts WHERE phone = %d AND id != %d LIMIT 1", sim_number, GetPlayerAccountID(playerid));
                new Cache:sim_check = mysql_query(mysql, query_check, true);
                new bool:number_busy = (!mysql_errno() && cache_num_rows() > 0);
                cache_delete(sim_check);

                if(number_busy)
                {
                    JSON_SetInt(response, "s", 0);
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Этот номер уже занят", " ");
                }
					else
                {
                    new bool:inventory_ok = false;

                    if(current_number > 0)
                        inventory_ok = Inventory11_SetSimBySlot(playerid, pos, current_number);
                    else
                        inventory_ok = Inventory11_DeleteSlotFromDatabase(playerid, pos);

                    if(!inventory_ok)
                    {
                        JSON_SetInt(response, "s", 0);
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось установить SIM-карту", " ");
                    }
                    else
                    {
                        SetPlayerData(playerid, P_PHONE, sim_number);
                        UpdatePlayerDatabaseInt(playerid, "phone", sim_number);
                        UpdatePlayerDatabaseInt(playerid, "sim", sim_number);

                        format(notif, sizeof(notif), "Вы успешно установили SIM-карту с номером: %d", sim_number);
                        ShowNotificationNew(playerid, 3, 6, 0, 0, notif, " ");
                        JSON_SetInt(response, "s", 1);
                        JSON_SetInt(response, "nm", sim_number);
                        JSON_SetInt(response, "i", 7);
                        refresh_inventory_after_response = 1;
                    }
                }
            }
        }
					else if(Inventory11_IsPlateItem(item_id))
        {
            JSON_SetInt(response, "t", 19);

            new vehicleid = GetPlayerOwnableCar(playerid);
            if(vehicleid == INVALID_VEHICLE_ID || !TrunkTest_IsPlayerNearVehicleRear(playerid, vehicleid, 3.0))
            {
                JSON_SetInt(response, "s", 0);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы должны быть возле багажника.", " ");
            }
            else
            {
                new index = GetVehicleData(vehicleid, V_ACTION_ID);
                if(index == -1)
                {
                    JSON_SetInt(response, "s", 0);
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "Ошибка: транспорт не найден", " ");
                }
                else if(OwnableCarHasInstalledPlate(index))
                {
                    JSON_SetInt(response, "s", 0);
                    ShowNotificationNew(playerid, 2, 6, 0, 0, "На вашей машине стоят номера", " ");
                }
                else
                {
                    new confirm_slot = GetPVarInt(playerid, PVAR_PLATE_CONFIRM_SLOT);
                    new confirm_item = GetPVarInt(playerid, PVAR_PLATE_CONFIRM_ITEM);

                    if(confirm_slot != pos || confirm_item != item_id)
                    {
                        SetPVarInt(playerid, PVAR_PLATE_CONFIRM_SLOT, pos);
                        SetPVarInt(playerid, PVAR_PLATE_CONFIRM_ITEM, item_id);
                        JSON_SetInt(response, "s", 0);
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Нажмите использовать еще раз для установки", " ");
                    }
					else
                    {
                        DeletePVar(playerid, PVAR_PLATE_CONFIRM_SLOT);
                        DeletePVar(playerid, PVAR_PLATE_CONFIRM_ITEM);

                        new plate_type;
                        new plate[16], region[8];
                        if(!Inventory11_GetPlateData(playerid, pos, plate_type, plate, sizeof(plate), region, sizeof(region)))
                        {
                            JSON_SetInt(response, "s", 0);
                            ShowNotificationNew(playerid, 2, 6, 0, 0, "Не удалось прочитать номер из инвентаря", " ");
                        }
    					else
                        {
                            if(!PlateTypeUsesRegion(plate_type))
                            {
                                format(region, sizeof(region), "");
                            }

                            new stored_number[32];
                            BuildStoredPlateValue(plate_type, plate, region, stored_number, sizeof(stored_number));

                            SetVehicleNumberPlateEx(vehicleid, plate_type, plate, region);
                            format(g_ownable_car[index][OC_NUMBER], 32, stored_number);

                            new db_query[320];
                            mysql_format(mysql, db_query, sizeof(db_query),
                                "UPDATE ownable_cars SET number='%e' WHERE id='%d' LIMIT 1",
                                g_ownable_car[index][OC_NUMBER],
                                GetOwnableCarData(index, OC_SQL_ID)
                            );
                            mysql_query(mysql, db_query, false);

                            if(mysql_errno())
                            {
                                printf("[PLATES][ERROR] Failed to update ownable_cars.number: player=%d car_index=%d errno=%d query=%s", playerid, index, mysql_errno(), db_query);
                            }

                            if(!Inventory11_DeleteSlotFromDatabase(playerid, pos))
                            {
                                JSON_SetInt(response, "s", 0);
                                ShowNotificationNew(playerid, 2, 6, 0, 0, "Номер установлен, но предмет не удален", " ");
                            }
        					else
                            {
                                JSON_SetInt(response, "s", 1);
                                JSON_SetInt(response, "w", Inventory11_GetCurrentWeightKg(playerid));

                                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы успешно поставили номерные знаки.", " ");
                                printf("[PLATES] Player %d installed plate=%s region=%s type=%d vehicle=%d slot=%d", playerid, plate, region, plate_type, vehicleid, pos);
                            }
                        }
                    }
                }
            }
        }
        else if(Inventory11_IsAccessoryItem(item_id))
        {
            JSON_SetInt(response, "t", 19);

            new source_slot = pos;

            // Client can send s=0 for first slot; support both legacy slot=0 and 0-based payload.
            if(source_slot < 0 || !Inventory11_HasInventoryItemInSlot(playerid, source_slot, item_id))
            {
                if(source_slot == 0 && Inventory11_HasInventoryItemInSlot(playerid, 1, item_id))
                {
                    source_slot = 1;
                }
					else
                {
                    source_slot = Inventory11_FindFirstItemSlotById(playerid, item_id);
                }
            }

            if(source_slot < 0)
            {
                JSON_SetInt(response, "s", 0);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Не найден аксессуар в инвентаре", " ");
                printf("[INV11][ERROR] type=19 accessory source slot not found: player=%d item=%d req_slot=%d", playerid, item_id, pos);
            }
					else
            {
                new active_slot = 0;
                new accessory_modelid = 0;

                if(!Inventory11_EquipAccessoryFromInventory(playerid, source_slot, item_id, active_slot, accessory_modelid))
                {
                    JSON_SetInt(response, "s", 0);
                }
					else
                {
                    new bool:db_ok = Inventory11_DeleteSlotFromDatabase(playerid, source_slot);
                    if(!db_ok)
                    {
                        JSON_SetInt(response, "s", 0);
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Аксессуар надет, но не удален из инвентаря", " ");
                        printf("[INV11][ERROR] type=19 accessory delete failed after equip: player=%d item=%d inv_slot=%d active_slot=%d model=%d", playerid, item_id, source_slot, active_slot, accessory_modelid);
                    }
					else
                    {
                        JSON_SetInt(response, "s", 1);
                        JSON_SetInt(response, "c", 1);
                        JSON_SetInt(response, "i", active_slot);
                        JSON_SetInt(response, "w", Inventory11_GetCurrentWeightKg(playerid));
                        Inventory11_SetAiArrayOnJson(playerid, response);
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы надели аксессуар", " ");

                        new acs_name[64] = "аксессуар";
                        new acs_id = AccessoryGetIndexByModel(accessory_modelid);
                        if(acs_id >= 0 && acs_id < sizeof(accessory))
                        {
                            format(acs_name, sizeof(acs_name), "%s", accessory[acs_id][NAME_ACCESSORY]);
                        }

                        new customize_msg[160];
                        format(customize_msg, sizeof(customize_msg), "{FFFFFF}Желаете ли Вы изменить расположение аксессуара %s?", acs_name);
                        SetPVarInt(playerid, "inv11_acc_edit_slot", active_slot);
                        HidePlayerGUI(playerid, 33);
                        HidePlayerGUI(playerid, GUICarsTrunkOrCloset);
                        ShowPlayerDialog(playerid, DIALOG_ID_INV11_ACC_CUSTOMIZE, DIALOG_STYLE_MSGBOX, "{FF0000}Кастомизация аксессуара", customize_msg, "Да", "Нет");

                        printf("[INV11] type=19 accessory equipped: player=%d item=%d model=%d inv_slot=%d active_slot=%d", playerid, item_id, accessory_modelid, source_slot, active_slot);
                    }
                }
            }
        }
					else if(item_id == 134 || item_id == 122) // Skin items
        {
            if(GetPVarInt(playerid, "Form"))
            {
                JSON_SetInt(response, "t", 19);
                JSON_SetInt(response, "s", 0);
                ShowNotificationNew(playerid, 2, 6, 0, 0,
                    "Сначала закончите рабочий день и снимите форму в раздевалке", "");
            }
					else
            {
            new modelid = -1;

            if(item_id == 134)
            {
                printf("[INV11] type=19 parsed payload: {\"ga\":%d,\"os\":%d,\"s\":%d,\"t\":19}", item_id, req_old_slot, pos);
                modelid = GetInventory11SkinModelByPos(playerid, pos);
            }

            if(modelid == -1)
            {
                for (new i = 0; i < sizeof(SkinMapping); i++)
                {
                    if (SkinMapping[i][0] == item_id)
                    {
                        modelid = SkinMapping[i][1];
                        break;
                    }
                }
            }

            if (modelid != -1 && IsValidSkinModel(modelid))
            {
                new old_model = GetPlayerSkin(playerid);
                SetPlayerSkin(playerid, modelid);
                SetPlayerData(playerid, P_SKIN, modelid);
                UpdatePlayerDatabaseInt(playerid, "skin", modelid);

                JSON_SetInt(response, "t", 19);
                JSON_SetInt(response, "s", 1);
                JSON_SetInt(response, "ps", modelid);

                Inventory11_SetAiArrayOnJson(playerid, response);
                JSON_SetInt(response, "i", 6);

                new_w -= GetItemWeight(item_id);
                if(new_w < 0) new_w = 0;
                JSON_SetInt(response, "w", new_w);

                if(item_id == 134)
                {
                    new bool:moved_back_ok = Inventory11_MoveSkinToInventorySlot(playerid, pos, old_model);
                    printf("[INV11] type=19 swap result: player=%d selected_slot=%d new_model=%d old_model=%d moved_back_ok=%d", playerid, pos, modelid, old_model, moved_back_ok);
                }

                Inventory11_SendSkinUpdatePacket(playerid, modelid);
                Action(playerid, "переоделся.");
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы успешно переоделись.", " ");
                printf("[INV11] type=19 success: player=%d model=%d slot=%d", playerid, modelid, pos);
            }
					else
            {
                JSON_SetInt(response, "t", 19);
                JSON_SetInt(response, "s", 0);
                format(notif, sizeof(notif), "Ошибка: Неверный ID скина %d", item_id);
                ShowNotificationNew(playerid, 2, 4, 0, 0, notif, "");
                printf("[INV11][ERROR] type=19 invalid model: player=%d ga=%d resolved_model=%d slot=%d", playerid, item_id, modelid, pos);
            }
            }
        }
					else
        {
            new_w -= GetItemWeight(item_id);
            if(new_w < 0) new_w = 0;
            JSON_SetInt(response, "t", 19);
            JSON_SetInt(response, "s", 1);
            JSON_SetInt(response, "w", new_w);
        }
    }
					else if (type == 11)
    {
        ShowPlayerStats(playerid);
        JSON_SetInt(response, "t", 11);
        JSON_SetInt(response, "s", 1);
    }
					else if (type == 12)
    {
        callcmd::donate(playerid);
        JSON_SetInt(response, "t", 12);
        JSON_SetInt(response, "s", 1);
    }
					else if (type == 13)
    {
        ShowPlayerDialog_Example(playerid);
        JSON_SetInt(response, "t", 13);
        JSON_SetInt(response, "s", 1);
    }
					else if (type == 14)
    {
        ShowNotificationNew(playerid, 2, 6, 0, 0, "В разработке", " ");
        JSON_SetInt(response, "t", 14);
        JSON_SetInt(response, "s", 1);
    }
					else if (type == 35)
    {
        callcmd::reward(playerid);
        JSON_SetInt(response, "t", 35);
        JSON_SetInt(response, "s", 1);
    }
					else if (type == 23)
    {
        JSON_GetInt(json, "ga", item_id);
        JSON_GetInt(json, "os", old_pos);
        JSON_GetInt(json, "s", pos);
        new raw_active_slot = -1, raw_new_slot = -1;
        JSON_GetInt(json, "i", raw_active_slot);
        JSON_GetInt(json, "ns", raw_new_slot);
        if(old_pos <= 0 && raw_active_slot == 7) old_pos = 7;
        if(pos <= 0 && raw_new_slot > 0) pos = raw_new_slot;
        if(old_pos == 0) old_pos = 1;
        if(pos == 0) pos = 1;

        new bool:db_ok = false;
        new active_model = 0;
        new current_sim_number = GetPlayerPhone(playerid);
        new bool:is_sim_identity = (item_id == 58 || item_id == 997 || (current_sim_number > 0 && item_id == current_sim_number));
        new bool:is_active_sim_move = (current_sim_number > 0 && old_pos == 7 && (is_sim_identity || ((raw_active_slot == 7 || item_id <= 0) && !Inventory11_HasInventoryItemInSlot(playerid, old_pos, item_id))));
        new bool:is_active_acc_move = (Inventory11_IsAccessoryItem(item_id) && (old_pos >= 1 && old_pos <= INVENTORY11_MAX_ACTIVE_ACCESSORIES) && !Inventory11_HasInventoryItemInSlot(playerid, old_pos, item_id));
        printf("[INV11][SIM] type=23 drag probe player=%d ga=%d os=%d s=%d i=%d ns=%d phone=%d active=%d", playerid, item_id, old_pos, pos, raw_active_slot, raw_new_slot, current_sim_number, is_active_sim_move);

        if(is_active_sim_move)
        {
            new removed_sim = 0;
            db_ok = Inventory11_MoveActiveSimToInventorySlot(playerid, pos, removed_sim);
            if(db_ok)
            {
                JSON_SetInt(response, "nm", 0);
                JSON_SetInt(response, "i", 7);
                refresh_inventory_after_response = 1;
                new sim_notif[72];
                format(sim_notif, sizeof(sim_notif), "SIM-карта %d извлечена в инвентарь", removed_sim);
                ShowNotificationNew(playerid, 3, 6, 0, 0, sim_notif, " ");
                printf("[INV11][SIM] type=23 active->inventory player=%d number=%d target_slot=%d", playerid, removed_sim, pos);
            }
        }
					else if(is_active_acc_move)
        {
            db_ok = Inventory11_MoveActiveAccessoryToInventorySlot(playerid, item_id, old_pos, pos, active_model);
            if(db_ok)
            {
                Inventory11_SetAiArrayOnJson(playerid, response);
                refresh_inventory_after_response = 1;
                printf("[INV11] type=23 accessory moved active->inventory: player=%d item=%d active_slot=%d inv_slot=%d model=%d", playerid, item_id, old_pos, pos, active_model);
            }
        }
					else
        {
            db_ok = Inventory11_SwapSlotsInDatabase(playerid, old_pos, pos);
        }

        JSON_SetInt(response, "t", 23);
        JSON_SetInt(response, "s", db_ok ? 1 : 0);
        JSON_SetInt(response, "i", (is_active_sim_move && db_ok) ? 7 : pos);
        printf("[INV11] type=23 result: player=%d ga=%d os=%d s=%d db_ok=%d", playerid, item_id, old_pos, pos, db_ok);
    }
					else if (type == 24)
    {
        JSON_GetInt(json, "ga", item_id);
        JSON_GetInt(json, "s", pos);
        if(pos == 0) pos = 1;

        new bool:db_ok = Inventory11_DeleteSlotFromDatabase(playerid, pos);
        JSON_SetInt(response, "t", 24);
        JSON_SetInt(response, "s", db_ok ? 1 : 0);
        JSON_SetInt(response, "w", new_w);
        printf("[INV11] type=24 result: player=%d ga=%d slot=%d db_ok=%d", playerid, item_id, pos, db_ok);
    }
					else
    {
        JSON_SetInt(response, "t", type);
        JSON_SetInt(response, "s", 0);
    }

    if(type == 19 || type == 18 || type == 23 || type == 4)
    {
        if(type == 19 || type == 18)
        {
            JSON_SetInt(response, "w", Inventory11_GetCurrentWeightKg(playerid));
        }
    }
    if(send_response)
    {
        OnPacketIncoming(playerid, 33, response);
    }
    JSON_Cleanup(response);
    response = 0;
    if(refresh_inventory_after_response)
    {
        Inventory11(playerid);
    }
}

        case 14:
        {
            new t, i;

            JSON_GetInt(JSONObject, "t", t);
            JSON_GetInt(JSONObject, "i", i);

            // Tablet tile order from the supplied GUI APK.
            switch(t)
            {
                case 0, 1, 2, 3, 5, 13, 17:
                {
                    ShowNotificationNew(playerid, 2, 5, 0, 0, "Функция находится в разработке.", " ");
                }
                case 4: callcmd::donate(playerid);
                case 6: { /* The working mining applet is handled by the client. */ }
                case 7: callcmd::inv(playerid, "");
                case 8: callcmd::market(playerid, "");
                case 9: callcmd::promo(playerid, "");
                case 10: callcmd::car(playerid, "");
                case 11: callcmd::gps(playerid, "");
                case 12: callcmd::familymenuinternal(playerid);
                case 14: callcmd::anim(playerid, "");
                case 15: callcmd::mm(playerid, "");
                case 16: callcmd::report(playerid, "");
            }
            new JSON:json_packet_data = JSON_Object();
            JSON_SetInt(json_packet_data, "i", 1);

            new outcoming_data[256];
            JSON_Stringify(json_packet_data, outcoming_data);

            OnPacketIncoming(playerid, 14, json_packet_data);

            JSON_Cleanup(json_packet_data);
        }

		case 1:
{
    new type;
    JSON_GetInt(json, "t", type);

    new bool:is_bc_mode = (GetPVarInt(playerid, PVAR_PLATE_BUY_ACCESS) == 1);
    new bc_plate_price = GetPVarInt(playerid, PVAR_PLATE_BC_PRICE);
    if(bc_plate_price < 0) bc_plate_price = 0;

    switch (type)
    {
        case 0:
        {
            new JSON:response = JSON_Object(
                "t", JSON_Int(0),
                "p", JSON_Int(is_bc_mode ? 0 : 5000),
                "pr", JSON_Int(is_bc_mode ? 0 : 2000)
            );
            OnPacketIncoming(playerid, 1, response);
            JSON_Cleanup(response);
            return 1;
        }

        case 1:
        {
            new country = 0;
            JSON_GetInt(json, "c", country);
            if(country < 0 || country > 3)
            {
                return 1;
            }

            gPlayerCountry[playerid] = country;

            new numberType = PlateCountryToType(country);
            new plate[32], region[8];
            if(!LoadPlateDraft(playerid, country, plate, sizeof(plate), region, sizeof(region)))
            {
                RandomNumberPlateByType(numberType, plate, sizeof(plate));
                RandomNumberRegion(country, region, sizeof(region));
                SavePlateDraftByMode(playerid, country, plate, region, is_bc_mode);
            }

            if(PlateTypeUsesRegion(numberType))
            {
                if(!strlen(region))
                {
                    ShowNotificationNew(playerid, 3, 6, 0, 0, "Введите регион.", "OK");
                    return 1;
                }
            }
            else
            {
                format(region, sizeof(region), "");
            }

            new JSON:response = JSON_Object();
            new display_plate[16];
            FormatPlateByTypeForDisplay(numberType, plate, display_plate, sizeof(display_plate));
            JSON_SetString(response, "p", display_plate);
            if (PlateTypeUsesRegion(numberType))
                JSON_SetString(response, "r", region);
            JSON_SetInt(response, "nt", numberType);
            JSON_SetInt(response, "t", 2);
            OnPacketIncoming(playerid, 1, response);
            JSON_Cleanup(response);

            if(is_bc_mode)
            {
                SetPVarInt(playerid, PVAR_PLATE_BC_PRICE, 0);

                new JSON:price_response = JSON_Object(
                    "t", JSON_Int(0),
                    "p", JSON_Int(0),
                    "pr", JSON_Int(0)
                );
                OnPacketIncoming(playerid, 1, price_response);
                JSON_Cleanup(price_response);
            }
            else
            {
                new JSON:price_response = JSON_Object(
                    "t", JSON_Int(0),
                    "p", JSON_Int(5000),
                    "pr", JSON_Int(2000)
                );
                OnPacketIncoming(playerid, 1, price_response);
                JSON_Cleanup(price_response);
            }

            printf("[PLATES] Player %d selected country=%d plate=%s region=%s mode=%d", playerid, country, plate, region, is_bc_mode);
            return 1;
        }

        case 2:
        {
            new country = gPlayerCountry[playerid];
            if (country == -1) return 1;

            if(!is_bc_mode)
            {
                if (GetPlayerMoneyEx(playerid) < 2000)
                {
                    ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно средств для перегенерации номера!", "");
                    return 1;
                }

                GivePlayerMoneyEx(playerid, -2000, "Перегенерация номерного знака", true, true);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы потратили 2000 рублей", " ");
            }

            new numberType = PlateCountryToType(country);
            new plate[32], region[8];
            RandomNumberPlateByType(numberType, plate, sizeof(plate));
            RandomNumberRegion(country, region, sizeof(region));
            SavePlateDraftByMode(playerid, country, plate, region, is_bc_mode);
            BlackPass_OnPlateRegenerated(playerid);

            new JSON:response = JSON_Object();
            new display_plate[16];
            FormatPlateByTypeForDisplay(numberType, plate, display_plate, sizeof(display_plate));
            JSON_SetString(response, "p", display_plate);
            if (PlateTypeUsesRegion(numberType))
                JSON_SetString(response, "r", region);
            JSON_SetInt(response, "nt", numberType);
            JSON_SetInt(response, "t", 2);
            OnPacketIncoming(playerid, 1, response);
            JSON_Cleanup(response);

            if(is_bc_mode)
            {
                SetPVarInt(playerid, PVAR_PLATE_BC_PRICE, 0);

                new JSON:price_response = JSON_Object(
                    "t", JSON_Int(0),
                    "p", JSON_Int(0),
                    "pr", JSON_Int(0)
                );
                OnPacketIncoming(playerid, 1, price_response);
                JSON_Cleanup(price_response);
            }
            else
            {
                new JSON:price_response = JSON_Object(
                    "t", JSON_Int(0),
                    "p", JSON_Int(5000),
                    "pr", JSON_Int(2000)
                );
                OnPacketIncoming(playerid, 1, price_response);
                JSON_Cleanup(price_response);
            }

            printf("[PLATES] Player %d regenerated plate=%s region=%s mode=%d", playerid, plate, region, is_bc_mode);
            return 1;
        }

        case 3:
        {
            new plate[32], region[8];
            JSON_GetString(json, "p", plate, sizeof(plate));
            JSON_GetString(json, "r", region, sizeof(region));
            printf("[PLATES][TRACE] Buy request: player=%d mode=%d country=%d raw_plate=%s raw_region=%s bc_price=%d errno_pre=%d", playerid, is_bc_mode, gPlayerCountry[playerid], plate, region, bc_plate_price, mysql_errno());

            new country = gPlayerCountry[playerid];
            if (country == -1)
            {
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Сначала выберите страну", "OK");
                return 1;
            }

            new numberType = PlateCountryToType(country);
            if(PlateTypeUsesRegion(numberType) && !strcmp(region, "tt", true))
            {
                format(region, sizeof(region), "");
            }

            if(PlateTypeUsesRegion(numberType) && !strlen(region))
            {
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Введите регион.", "OK");
                return 1;
            }

            if(!PlateTypeUsesRegion(numberType))
            {
                format(region, sizeof(region), "");
            }

            new normalized_plate[16], normalized_region[8];
            if(!NormalizeAndValidatePlateByType(numberType, plate, normalized_plate, sizeof(normalized_plate)))
            {
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы используете запрещенные символы или номер не соотвествует формату.", "OK");
                return 1;
            }

            if(!NormalizeAndValidatePlateRegion(numberType, region, normalized_region, sizeof(normalized_region)))
            {
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Некорректный регион номера", "OK");
                return 1;
            }

            format(plate, sizeof(plate), "%s", normalized_plate);
            format(region, sizeof(region), "%s", normalized_region);
            SavePlateDraftByMode(playerid, country, plate, region, is_bc_mode);
            printf("[PLATES][TRACE] Buy normalized: player=%d country=%d type=%d plate=%s region=%s mode=%d", playerid, country, numberType, plate, region, is_bc_mode);
            if(is_bc_mode)
            {
                bc_plate_price = CalculateDonatePlatePriceByText(numberType, plate, region, bc_plate_price);
                SetPVarInt(playerid, PVAR_PLATE_BC_PRICE, bc_plate_price);
            }

            if(is_bc_mode)
            {
                new stored_number[32];
                BuildStoredPlateValue(numberType, plate, region, stored_number, sizeof(stored_number));

                new check_query[196];
                mysql_format(mysql, check_query, sizeof(check_query), "SELECT id FROM ownable_cars WHERE number = '%e' LIMIT 1", stored_number);
                new Cache:occupied_result = mysql_query(mysql, check_query, true);

                new bool:plate_occupied = false;
                if(mysql_errno())
                {
                    printf("[PLATES][ERROR] Occupied check failed errno=%d player=%d query=%s", mysql_errno(), playerid, check_query);
                }
					else if(cache_num_rows() > 0)
                {
                    plate_occupied = true;
                }
                cache_delete(occupied_result);

                if(!plate_occupied)
                {
                    new check_query_inv[256];
                    mysql_format(mysql, check_query_inv, sizeof(check_query_inv), "SELECT 1 FROM inventory_plates WHERE plate_type = %d AND plate_number = '%e' AND plate_region = '%e' LIMIT 1", numberType, plate, region);
                    new Cache:occupied_inv_result = mysql_query(mysql, check_query_inv, true);

                    if(mysql_errno())
                    {
                        printf("[PLATES][ERROR] Occupied inventory_plates check failed errno=%d player=%d query=%s", mysql_errno(), playerid, check_query_inv);
                    }
					else if(cache_num_rows() > 0)
                    {
                        plate_occupied = true;
                    }
                    cache_delete(occupied_inv_result);
                }


                if(plate_occupied)
                {
                    SendPlateHint(playerid, "Данный номер занят");
                    return 1;
                }
            }



            if(is_bc_mode)
            {
                if(GetPlayerDonateRub(playerid) < bc_plate_price)
                {
                    ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно BC для покупки номера", "OK");
                    return 1;
                }
            }
					else
            {
                if (GetPlayerMoneyEx(playerid) < 5000)
                {
                    ShowNotificationNew(playerid, 2, 4, 0, 0, "Недостаточно средств для покупки номеров!", "");
                    return 1;
                }
            }

            new inv_item_id = PlateCountryToItemId(country);
            new inv_model_id = PlateItemIdToModel(inv_item_id);
            printf("[PLATES][TRACE] Add to inventory: player=%d item=%d model=%d plate=%s region=%s", playerid, inv_item_id, inv_model_id, plate, region);
            new inv_slot = Inventory11_AddItemToDatabase(playerid, inv_item_id, inv_model_id, 1, 0, 0);
            printf("[PLATES][TRACE] AddItem result: player=%d item=%d slot=%d errno=%d", playerid, inv_item_id, inv_slot, mysql_errno());
            if(inv_slot == -1)
            {
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Не удалось добавить номер в инвентарь", "OK");
                return 1;
            }

            if(!Inventory11_SavePlateData(playerid, inv_slot, numberType, plate, region))
            {
                printf("[PLATES][ERROR] SavePlateData returned false: player=%d slot=%d errno=%d", playerid, inv_slot, mysql_errno());
                Inventory11_DeleteSlotFromDatabase(playerid, inv_slot);
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Ошибка сохранения номера", "OK");
                return 1;
            }

            printf("[PLATES][TRACE] SavePlateData success: player=%d slot=%d type=%d plate=%s region=%s errno=%d", playerid, inv_slot, numberType, plate, region, mysql_errno());


            if(is_bc_mode)
            {
                GivePlayerDonateRub(playerid, -bc_plate_price, "Покупка донатного номерного знака", true, true);
            }
					else
            {
                GivePlayerMoneyEx(playerid, -5000, "Покупка номерных знаков", true, true);
                ShowNotificationNew(playerid, 2, 6, 0, 0, "Вы потратили 5000 рублей", " ");
            }



            if(is_bc_mode)
            {
                new bc_plate_text[128];
                format(bc_plate_text, sizeof(bc_plate_text), "НОМЕР - %s, ИСПОЛЬЗУЙТЕ ИНВЕНТАРЬ", plate);

                new JSON:json_packet_data = JSON_Object();
                JSON_SetInt(json_packet_data, "t", 0);
                JSON_SetInt(json_packet_data, "y", 1);
                JSON_SetInt(json_packet_data, "s", GetPlayerDonateRub(playerid));
                JSON_SetInt(json_packet_data, "r", GetPlayerMoneyEx(playerid));
                JSON_SetString(json_packet_data, "m", "ВЫ УСПЕШНО КУПИЛИ НОВЫЙ НОМЕР");
                JSON_SetString(json_packet_data, "n", bc_plate_text);
                OnPacketIncoming(playerid, 22, json_packet_data);
                JSON_Cleanup(json_packet_data);
            }
					else
            {
                SendClientMessage(playerid, 0xFFFFFFFF, "{FFFFFF}Вы купили номер для транспорта, используйте инвентарь");
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Номерные знаки куплены. Используйте предмет в инвентаре.", "qq");
            }
            printf("[PLATES] Player %d bought plate item=%d slot=%d plate=%s region=%s mode=%d", playerid, inv_item_id, inv_slot, plate, region, is_bc_mode);

            PlateDraft_RegenerateAll(playerid);
            DeletePVar(playerid, PVAR_PLATE_BUY_ACCESS);
            DeletePVar(playerid, PVAR_PLATE_BC_PRICE);
            ClearPlateDraftCache(playerid);
            gPlayerCountry[playerid] = -1;
            HidePlayerGUI(playerid, 1);
            return 1;
        }        case 4:
        {
            new country = -1;
            JSON_GetInt(json, "c", country);
            if(country >= 0 && country <= 3)
            {
                gPlayerCountry[playerid] = country;
            }
            else
            {
                country = gPlayerCountry[playerid];
            }

            if(country < 0 || country > 3)
            {
                return 1;
            }

            new raw_plate[32], raw_region[8];
            JSON_GetString(json, "p", raw_plate, sizeof(raw_plate));
            JSON_GetString(json, "r", raw_region, sizeof(raw_region));

            new numberType = PlateCountryToType(country);

            // New mobile GUI sends "tt" for an empty region field.
            if(PlateTypeUsesRegion(numberType) && !strcmp(raw_region, "tt", true))
            {
                format(raw_region, sizeof(raw_region), "");
            }

            if(PlateTextHasForbiddenSymbols(numberType, raw_plate) || (PlateTypeUsesRegion(numberType) && PlateRegionHasForbiddenSymbols(raw_region)))
            {
                SendPlateHint(playerid, "Вы используете запрещенные символы или номер не соотвествует формату.");
                return 1;
            }

            new normalized_plate[16], normalized_region[8];
            if(!NormalizeAndValidatePlateByType(numberType, raw_plate, normalized_plate, sizeof(normalized_plate)))
            {
                SendPlateHint(playerid, "Вы используете запрещенные символы или номер не соотвествует формату.");
                return 1;
            }

            if(PlateTypeUsesRegion(numberType))
            {
                if(!strlen(raw_region))
                {
                    SendPlateHint(playerid, "Введите регион.");
                    return 1;
                }

                if(!NormalizeAndValidatePlateRegion(numberType, raw_region, normalized_region, sizeof(normalized_region)))
                {
                    SendPlateHint(playerid, "Вы используете запрещенные символы или номер не соотвествует формату.");
                    return 1;
                }
            }
            else
            {
                format(normalized_region, sizeof(normalized_region), "");
            }

            SavePlateDraftByMode(playerid, country, normalized_plate, normalized_region, is_bc_mode);

            if(is_bc_mode)
            {
                bc_plate_price = CalculateDonatePlatePriceByText(numberType, normalized_plate, normalized_region, bc_plate_price);
                SetPVarInt(playerid, PVAR_PLATE_BC_PRICE, bc_plate_price);

                new JSON:response = JSON_Object(
                    "t", JSON_Int(0),
                    "p", JSON_Int(bc_plate_price),
                    "pr", JSON_Int(0)
                );
                OnPacketIncoming(playerid, 1, response);
                JSON_Cleanup(response);
            }
            else
            {
                new JSON:response = JSON_Object(
                    "t", JSON_Int(0),
                    "p", JSON_Int(5000),
                    "pr", JSON_Int(2000)
                );
                OnPacketIncoming(playerid, 1, response);
                JSON_Cleanup(response);
            }

            if(is_bc_mode) SendPlateHint(playerid, "Теперь нажмите кнопку \"Оплатить\"");
            else SendPlateHint(playerid, "Выбранный номер будет добавлен в инвентарь");
            return 1;
        }
    }

    return 1;
}


		case 28:{
    new veh = GetPlayerVehicleID(playerid);
    if((GetPlayerData(playerid, P_LAST_TUNING) == 0 || GetPlayerData(playerid, P_LAST_TUNING) == 2) &&
       !Styling_CanEdit(playerid, veh))
    {
        printf("[STYLING][REJECT] player=%d vehicle=%d reason=invalid_owner_or_driver", playerid, veh);
        return 1;
    }
    new database_id = GetOwnableCarData(GetVehicleData(veh, V_ACTION_ID), OC_SQL_ID);
    new type, selector_id, data_value, type_of_detail, status, sound_id, item_id, price, currency_type;
    new color[32], color_override[32], vinyl[32];
    new query[512], json_log[256], caption[128];

    JSON_GetInt(json, "t", type);
    JSON_GetInt(json, "m", selector_id);
    JSON_GetInt(json, "d", data_value);
    JSON_GetString(json, "d", color, sizeof(color));
    JSON_GetInt(json, "mt", type_of_detail);
    JSON_GetInt(json, "s", status);
    color_override[0] = EOS;
    JSON_GetString(json, "co", color_override, sizeof(color_override));
    if(color_override[0] != EOS)
    {
        format(color, sizeof(color), "%s", color_override);
    }
    JSON_GetString(json, "v", vinyl, sizeof(vinyl));
    JSON_GetInt(json, "h", sound_id);
    JSON_GetInt(json, "i", item_id);
    JSON_GetInt(json, "p", price);
    JSON_GetInt(json, "c", currency_type);
    if(GetPlayerData(playerid, P_LAST_TUNING) != 3 && type != 23 && type != 24 && type != 25)
        printf("[STYLING][REQUEST] player=%d car=%d action=%d selector=%d item=%d", playerid, database_id, type, selector_id, data_value);

    switch(type)
    {
		case 4:
		{
			ShowNotificationNew(playerid, 2, 6, 0, 0, "Для вашего автомобиля нет доступного тюнинга", "OK");
		}
        case 0:
        {
             TogglePlayerControllable(playerid, 1);
            SetCameraBehindPlayer(playerid);
			
			new Float:x = -422.748107, Float:y = 1030.279174, Float:z = 11.246218;
            if (g_player[playerid][P_LAST_TUNING] == 3) { x = -422.748107, y = 1030.279174, z = 11.246218; }
            if (g_player[playerid][P_LAST_TUNING] == 2) { x = 1747.741943, y = 2467.266601, z = 14.979245; }
            if (g_player[playerid][P_LAST_TUNING] == 0) { x = 2297.047607, y = -2612.994873, z = 21.829063; }
            if (g_player[playerid][P_LAST_TUNING] == 1) { x = 2131.0, y = -876.0, z = 27.947052; }
            if(IsPlayerInAnyVehicle(playerid))
            {
                new vehicleid = GetPlayerVehicleID(playerid);
				
                SetVehiclePos(vehicleid, x, y, z);
                SetVehicleZAngle(vehicleid, 0.0);
                PutPlayerInVehicle(playerid, vehicleid, 0);
			    SetVehicleVirtualWorld(vehicleid, 0);
				LinkVehicleToInterior(vehicleid, 0);
				
				for(new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleid)
                {
					new seat = GetPlayerVehicleSeat(i);
					PutPlayerInVehicle(i, vehicleid, seat);
					TogglePlayerControllable(i, 1);
                    SetCameraBehindPlayer(i);
                    SetPlayerVirtualWorld(i, 0);
                    SetPlayerInterior(i, 0);
                }
            }
            }
                    else
            {
                SetPlayerPos(playerid, x, y, z);
            }
            SetPlayerInterior(playerid, 0);
			SetPlayerVirtualWorld(playerid, 0);
			
			
            SetTimerEx("ApplyExhu", 1000, false, "dd", playerid, GetPlayerVehicleID(playerid));
            if(GetPlayerData(playerid, P_LAST_TUNING) == 0 || GetPlayerData(playerid, P_LAST_TUNING) == 2)
            {
                // Apply after closing the native preview and changing the world.
                SetTimerEx("Styling_ExitReapply", 500, false, "dddd", playerid, veh,
                    GetPlayerAccountID(playerid), database_id);
                SetTimerEx("Styling_ExitReapply", 1500, false, "dddd", playerid, veh,
                    GetPlayerAccountID(playerid), database_id);
            }
        }
        case 28:
        {
            Styling_WheelState(playerid, veh, json_packet_data);
        }
        case 12:
        {
            new bool:success = Styling_BuyWheelSetting(playerid, veh, selector_id, data_value);
            JSON_SetInt(json_packet_data, "t", 12);
            JSON_SetInt(json_packet_data, "s", success ? 1 : 0);
            JSON_SetInt(json_packet_data, "p", data_value);
            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
            JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
        }
        case 1, 2: // Styling color/tint purchase; the tech-center branches stay unchanged.
        {
            new bool:success = Styling_BuyColor(playerid, veh, selector_id, color);
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "s", success ? 1 : 0);
            JSON_SetString(json_packet_data, "d", color);
            JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
            printf("[STYLING][COLOR] player=%d car=%d selector=%d color=%s success=%d",
                playerid, database_id, selector_id, color, success);
        }
        case 3: // Vinyl: validate catalogue and balances before saving/applying.
        {
            new name[32];
            new bool:success = Styling_BuyVinyl(playerid, veh, data_value, vinyl, name, sizeof name);
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetInt(json_packet_data, "s", success ? 1 : 0);
            JSON_SetInt(json_packet_data, "p", data_value);
            JSON_SetString(json_packet_data, "v", name);
            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
            JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
            printf("[STYLING][VINYL] player=%d car=%d item=%d success=%d",
                playerid, database_id, data_value, success);
        }
        case 5: // OPERATION_SET_STOCK
        {
            if(IsPlayerInAnyVehicle(playerid))
            {
                new vehicleid = GetPlayerVehicleID(playerid);
                new i = GetVehicleData(vehicleid, V_ACTION_ID);

                if(type_of_detail == -1)
                {
                    if(ResetOwnableCarSelectorToStock(playerid, vehicleid, i, selector_id, database_id))
                    {
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "m", selector_id);
                        JSON_SetInt(json_packet_data, "mt", type_of_detail);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                    }
                    else
                    {
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Нельзя снять выбранную услугу");
                    }
                }
                else if(type_of_detail == 4)
                {
                    new detail_item_id = (data_value > 0) ? data_value : selector_id;

                    if(selector_id == 31 || detail_item_id == vInfo[i][wheel_comp])
                    {
                        new wheel_item_id = detail_item_id;
                        if(selector_id == 31 && (wheel_item_id <= 0 || wheel_item_id == 31))
                        {
                            wheel_item_id = vInfo[i][wheel_comp];
                        }

                        new wheel_componentid = GetWheelTuneComponentId(wheel_item_id);
                        if(wheel_componentid > 0)
                        {
                            // Removed below through the custom CRMP component RPC.
                            RemoveFromVehicleComponentForPlayer(playerid, vehicleid, wheel_componentid);
                        }

                        vInfo[i][wheel_comp] = 0;
                        SetOwnableCarData(i, OC_wheelcomp, 0);

                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET wheel_comp = 0 WHERE id = %d", database_id);
                        mysql_query(mysql, query, false);
                        PermanentTuning_RebuildVehicleState(vehicleid);
                    }
                    else
                    {
                        new componentid = GetTuneIdFromItem(detail_item_id);
                        if(componentid > 0)
                        {
                            // Removed below through the custom CRMP component RPC.
                            RemoveFromVehicleComponentForPlayer(playerid, vehicleid, componentid);
                        }

                        mysql_format(mysql, query, sizeof query,
                            "UPDATE vehicle_store_components SET state=0 WHERE vehicleid=%d AND componentid=%d",
                            GetOwnableCarData(i, OC_SQL_ID),
                            detail_item_id
                        );
                        mysql_query(mysql, query, false);
                        PermanentTuning_RebuildVehicleState(vehicleid);
                    }

                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", 1);
                    JSON_SetInt(json_packet_data, "m", selector_id);
                    JSON_SetInt(json_packet_data, "mt", type_of_detail);
                    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                }
                else
                {
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", 0);
                    JSON_SetString(json_packet_data, "m", "Нельзя снять выбранную деталь");
                }
            }
            else
            {
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы не в транспорте!", "OK");
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 0);
                JSON_SetString(json_packet_data, "m", "Вы не в транспорте!");
            }
        }
        case 7: // OPERATION_BUY_DETAIL
        {
		

            new componentid = 1008;
            
            new exhaust_price = (price > 0) ? price : 2000;
            new stroboscope_price = (price > 0) ? price : 3000;
            new highlight_price = (price > 0) ? price : 2500;
            new firmware_price = (price > 0) ? price : 4000;
            new launch_control_price = (price > 0) ? price : 5000;
            new brakes_price = (price > 0) ? price : 4500;
            new turbo_price = (price > 0) ? price : 6000;
            new engine_price = (price > 0) ? price : 7000;
            new supercharger_price = (price > 0) ? price : 6500;
            new nitro_price = (price > 0) ? price : 3000;
          
            printf("[DEBUG] (data_value: %d, selector_id: %d) %d", data_value, selector_id, playerid);
            if(IsPlayerInAnyVehicle(playerid))
            {
				if(!Styling_CanCompleteServicePurchase(playerid))
				{
					JSON_SetInt(json_packet_data, "t", type);
					JSON_SetInt(json_packet_data, "s", 0);
					JSON_SetString(json_packet_data, "m", "В центре закончились товары");
					OnPacketIncoming(playerid, 28, json_packet_data);
					JSON_Cleanup(json_packet_data, true);
					return 1;
				}
                new vehicleid = GetPlayerVehicleID(playerid);
                new idveh = GetPlayerVehicleID(playerid);
				new query[128];
                mysql_format(mysql, query, sizeof(query),
                    "SELECT state FROM vehicle_store_components WHERE vehicleid=%d AND componentid=%d",
                    database_id,
                    data_value
                );
				mysql_query(mysql, query); // синхронно, чтобы сразу получить результат
                new bool:has_component_state = cache_num_rows() > 0;
				new selected_componentid = (selector_id == 31)
					? GetWheelTuneComponentId(data_value)
					: GetTuneIdFromItem(data_value);
				if(has_component_state && selected_componentid <= 0)
				{
					has_component_state = false;
				}

                if(has_component_state)
                {
					new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 1.01666);
                    if(GetPlayerMoney(playerid) >= hydraulics_price)
                    {
						SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - hydraulics_price);
                        UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
						
						GivePlayerMoney(playerid, -hydraulics_price);
						Styling_RegisterServiceSale(playerid, hydraulics_price);
                        mysql_format(mysql, query, sizeof(query),
                            "UPDATE vehicle_store_components SET state=2 WHERE vehicleid=%d AND componentid=%d",
                            database_id,
                            data_value
                        );
                        mysql_query(mysql, query);
                        PermanentTuning_RebuildVehicleState(vehicleid);
						AddToVehicleComponentForPlayer(playerid, vehicleid, selected_componentid);
						JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "p", data_value);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
					    JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
					}else{
						ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
					}
				}

                if(!has_component_state && selector_id == 31)
                {
                    new bool:success = Styling_BuyDisk(playerid, vehicleid, data_value);
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", success ? 1 : 0);
                    JSON_SetInt(json_packet_data, "p", data_value);
                    JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                    JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                }
                if(data_value == 33)
                {
					new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 42.09059233449477);
                    if(GetPlayerMoney(playerid) >= hydraulics_price)
                    {
                        SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - hydraulics_price);
                        UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
						
						GivePlayerMoney(playerid, -hydraulics_price);
						Styling_RegisterServiceSale(playerid, hydraulics_price);
                        format(caption, sizeof(caption), "Успешно");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET is_hydro_bought = %d WHERE id = %d", 1, database_id);
						new i = GetVehicleData(idveh, V_ACTION_ID);
						vInfo[i][IsHydroBought]   = 1;
						vInfo[i][IsHydroActive] = 1;
						SetOwnableCarData(i, OC_isHydroBought, 1);
						SetOwnableCarData(i, OC_isHydroActive, 1);

                        SetVehicleHydraulics(vehicleid, 1, 0);
                        mysql_query(mysql, query, false);
						mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET is_hydro_active = %d WHERE id = %d", 1, database_id);
						mysql_query(mysql, query, false);
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "p", data_value);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
					    JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                    }
                   
                }

				if(data_value == 299)
                {
					new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.2393728222996516);
                    if(GetPlayerMoney(playerid) >= hydraulics_price)
                    {
                        SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - hydraulics_price);
                        UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
						
						GivePlayerMoney(playerid, -hydraulics_price);
						Styling_RegisterServiceSale(playerid, hydraulics_price);
                        format(caption, sizeof(caption), "Успешно");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET is_FarLight_bought = %d WHERE id = %d", 1, database_id);
						new i = GetVehicleData(idveh, V_ACTION_ID);
						vInfo[i][IsFarLightBought]   = 1;
						vInfo[i][IsFarLightActive] = 1;
						SetOwnableCarData(i, OC_isFarLightBought, 1);
						SetOwnableCarData(i, OC_isFarLightActive, 1);

                        SetVehicleFarLight(playerid, vehicleid, 1);
                        mysql_query(mysql, query, false);
						mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET is_FarLight_active = %d WHERE id = %d", 1, database_id);
						mysql_query(mysql, query, false);
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "p", data_value);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
					    JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                    }
                   
                }

				if(data_value == 34)
                {
					new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 32.09059233449477);
                    if(GetPlayerMoney(playerid) >= hydraulics_price)
                    {
                        SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - hydraulics_price);
                        UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                        GivePlayerMoney(playerid, -hydraulics_price);
                        Styling_RegisterServiceSale(playerid, hydraulics_price);
                        format(caption, sizeof(caption), "Успешно");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET is_pnevmo_bought = %d WHERE id = %d", 1, database_id);
						new i = GetVehicleData(idveh, V_ACTION_ID);
						vInfo[i][IsPnevmoBought]   = 1;
						vInfo[i][SelectedPnevmo] = 1;
						SetOwnableCarData(i, OC_isPnevmoBought, 1);
						SetOwnableCarData(i, OC_PnevmoSelected, 1);
						SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.55);
                        mysql_query(mysql, query, false);
						mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET pnevmo_selected = %d WHERE id = %d", 1, database_id);
						mysql_query(mysql, query, false);
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "p", data_value);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
					    JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                    }
                   
                }
					else if(data_value > 98 && data_value < 130)
                {
					new i = GetVehicleData(idveh, V_ACTION_ID);
                    sound_id = data_value;
                    new sound_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 8.393728222996516);
					new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0078048780487);
                    if(data_value > 98 && data_value < 107){
						sound_id = data_value - 85;
						
						currency_type = 0;
						
					}
					if (data_value == 105){
						sound_id = 23;
					}
					if (data_value > 105 && data_value < 112){
						sound_id = data_value - 77;
					}
					if (data_value == 112){
						sound_id = 24;
					}
					if (data_value == 113){
						sound_id = 25;
					}
					if(data_value > 113 && data_value < 118){
						sound_id = data_value - 73;
					}
					if (data_value == 118){
						sound_id = 20;
					}
					if (data_value == 119){
						sound_id = 21;
					}
					if (data_value == 120){
						sound_id = 22;
					}
					switch (data_value)
                    {
                        case 121: sound_id = 26; 
                        case 122: sound_id = 27; 
                        case 123: sound_id = 28; 
                        case 124: sound_id = 35; 
                        case 125: sound_id = 36; 
                        case 126: sound_id = 37; 
                        case 127: sound_id = 38; 
                        case 128: sound_id = 39; 
                        case 129: sound_id = 40; 
                    }
					if(data_value > 106 && data_value < 118){
						currency_type = 1;
					}
					if(data_value > 117 && data_value < 127){
						currency_type = 0;
					}
					if(data_value > 126 && data_value < 130){
						currency_type = 1;
					}
					vInfo[i][horn_current] = data_value;
					mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET horn_current = %d WHERE id = %d", vInfo[i][horn_current], database_id);
					
                    mysql_query(mysql, query, false);
                    if(currency_type == 0)
                    {
                        if(GetPlayerMoney(playerid) >= sound_price)
                        {
							SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - sound_price);
                            UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                            GivePlayerMoney(playerid, -sound_price);
                            Styling_RegisterServiceSale(playerid, sound_price);
                            vInfo[i][vHornSound] = sound_id;
                            
                            format(caption, sizeof(caption), "Успешно");
                            ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
							SetVehicleHornSound(vehicleid, sound_id, 1);
                            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET horn_id = %d WHERE id = %d", sound_id, database_id);
                            mysql_query(mysql, query, false);
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 1);
                            JSON_SetInt(json_packet_data, "h", sound_id);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
							JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
							JSON_SetInt(json_packet_data, "p", data_value);
                        }
					else
                        {
                            ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 0);
                            JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                        }
                    }
					else if(currency_type == 1)
                    {
                        if(GetPlayerDonateRub(playerid) >= sound_price)
                        {
                            GivePlayerDonateRub(playerid, -sound_price, "Покупка сигнала в техническом центре", true, true);
                            Styling_RegisterServiceSale(playerid, 0, sound_price);
                            vInfo[i][vHornSound] = sound_id;
                            SetVehicleHornSound(vehicleid, sound_id, 1);
                            format(caption, sizeof(caption), "Успешно");
                            ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET horn_id = %d WHERE id = %d", sound_id, database_id);
                            mysql_query(mysql, query, false);
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 1);
							JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "h", sound_id);
                            JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
							JSON_SetInt(json_packet_data, "p", data_value);
                        }
					else
                        {
                            ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно донат-рублей!", "OK");
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 0);
                            JSON_SetString(json_packet_data, "m", "Недостаточно донат-рублей!");
                        }
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Неверный тип валюты!", "OK");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Неверный тип валюты!");
                    }
                }
					else if(data_value >= 93 && data_value <= 98)
                {
                    new exhaust_type;
                    new exhaust_name[16];
                    switch(data_value)
                    {
                        case 93: { exhaust_type = 0; exhaust_name = "Стандарт"; }
                        case 94: { exhaust_type = 1; exhaust_name = "Спортивный"; }
                        case 95: { exhaust_type = 2; exhaust_name = "Тюнинг"; }
                        case 96: { exhaust_type = 3; exhaust_name = "Громкий"; }
                        case 97: { exhaust_type = 4; exhaust_name = "Двойной"; }
                        case 98: { exhaust_type = 5; exhaust_name = "Спортивный+"; }
                    }
                    exhaust_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 3.696864111498258);
                    if(GetPlayerMoney(playerid) >= exhaust_price)
                    {
						SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - exhaust_price);
                        UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                        GivePlayerMoney(playerid, -exhaust_price);
                        Styling_RegisterServiceSale(playerid, exhaust_price);
                        format(caption, sizeof(caption), "Успешно");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                        printf("[DEBUG] ( : %d, %s) %d %d ", exhaust_type, exhaust_name, playerid, exhaust_price);
						new i = GetVehicleData(idveh, V_ACTION_ID);
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET exhaust_type = %d WHERE id = %d", exhaust_type+1, database_id);
						vInfo[i][vExhaustSound] = exhaust_type+1;
                        SetVehicleExhaust(vehicleid, exhaust_type, 1);
                        mysql_query(mysql, query, false);
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "d", data_value);
						vInfo[i][exhsuast_current] = data_value;
						mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET exhsuast_current = %d WHERE id = %d", vInfo[i][exhsuast_current], database_id);
						
                        mysql_query(mysql, query, false);
						
                        JSON_SetInt(json_packet_data, "p", data_value);
						JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                    }
                }
					else if(data_value >= 28 && data_value <= 31)
                {
                    new stroboscope_type = data_value - 27;
                    new stroboscope_name[16];
                    switch(stroboscope_type)
                    {
                        case 1: stroboscope_name = "Тип 1";
                        case 2: stroboscope_name = "Тип 2";
                        case 3: stroboscope_name = "Тип 3";
                        case 4: stroboscope_name = "Тип 4";
                        case 5: stroboscope_name = "Тип 5";
                    }
                  stroboscope_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 1.696864111498258);
                        if(GetPlayerMoney(playerid) >= stroboscope_price)
                        {
							SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - stroboscope_price);
                            UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                            GivePlayerMoney(playerid, -stroboscope_price);
                            Styling_RegisterServiceSale(playerid, stroboscope_price);

                            new i = GetVehicleData(vehicleid, V_ACTION_ID);
                            if(i >= 0 && i < MAX_OWNABLE_CARS)
                            {
                                SetOwnableCarData(i, OC_STROBOSCOPE, stroboscope_type);
                                SetOwnableCarData(i, OC_strab_current, data_value);
                                vInfo[i][vStrob] = stroboscope_type;
                                vInfo[i][strab_current] = data_value;
                            }
                            vInfo[vehicleid][vStrob] = stroboscope_type;
                            vInfo[vehicleid][strab_current] = data_value;
                            EnableStrob[vehicleid] = true;
                            // Stored values are 1..5; RPC active modes are 0..4, while 5 means OFF.
                            SetVehicleStroboscope(vehicleid, stroboscope_type - 1, 0);

                            format(caption, sizeof(caption), "Успешно");
                            ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                            printf("[STYLING][STROBE_BUY] player=%d car=%d item=%d stored=%d rpc=%d", playerid, database_id, data_value, stroboscope_type, stroboscope_type - 1);
                            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET stroboscope_type = %d, strab_current = %d WHERE id = %d", stroboscope_type, data_value, database_id);
                            mysql_query(mysql, query, false);

							JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 1);
                            JSON_SetInt(json_packet_data, "d", data_value);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        }
					else
                        {
                            ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 0);
                            JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                        }
                    
                }
					else if(data_value == 32)
                {
                    new stroboscope_type = data_value - 27;
                    new stroboscope_name[16];
                    switch(stroboscope_type)
                    {
                        case 1: stroboscope_name = "Тип 1";
                        case 2: stroboscope_name = "Тип 2";
                        case 3: stroboscope_name = "Тип 3";
                        case 4: stroboscope_name = "Тип 4";
                        case 5: stroboscope_name = "Тип 5";
                    }
                  stroboscope_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0050871080139373);
                        if(GetPlayerDonateRub(playerid) >= stroboscope_price)
                        {
                            GivePlayerDonateRub(playerid, -stroboscope_price, "Покупка стробоскопа в техническом центре", true, true);
                            Styling_RegisterServiceSale(playerid, 0, stroboscope_price);

                            new i = GetVehicleData(vehicleid, V_ACTION_ID);
                            if(i >= 0 && i < MAX_OWNABLE_CARS)
                            {
                                SetOwnableCarData(i, OC_STROBOSCOPE, stroboscope_type);
                                SetOwnableCarData(i, OC_strab_current, data_value);
                                vInfo[i][vStrob] = stroboscope_type;
                                vInfo[i][strab_current] = data_value;
                            }
                            vInfo[vehicleid][vStrob] = stroboscope_type;
                            vInfo[vehicleid][strab_current] = data_value;
                            EnableStrob[vehicleid] = true;
                            SetVehicleStroboscope(vehicleid, stroboscope_type - 1, 0);

                            format(caption, sizeof(caption), "Успешно");
                            ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                            printf("[STYLING][STROBE_BUY] player=%d car=%d item=%d stored=%d rpc=%d", playerid, database_id, data_value, stroboscope_type, stroboscope_type - 1);
                            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET stroboscope_type = %d, strab_current = %d WHERE id = %d", stroboscope_type, data_value, database_id);
                            mysql_query(mysql, query, false);

							JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 1);
                            JSON_SetInt(json_packet_data, "d", data_value);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        }
					else
                        {
                            ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 0);
                            JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                        }
                    
                }
					else if(data_value == 299)
                {
                    new highlight_type = data_value;
                    new highlight_name[] = "Дальний свет";
                  
                    printf("[DEBUG] ( : %d, %s) %d", highlight_type, highlight_name, playerid);
                    if(currency_type == 0)
                    {
                        if(GetPlayerMoney(playerid) >= highlight_price)
                        {
							SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - highlight_price);
                            UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                            GivePlayerMoney(playerid, -highlight_price);
                            Styling_RegisterServiceSale(playerid, highlight_price);
                            vInfo[vehicleid][vHighLights] = highlight_type;
                            SetVehicleHighLight(vehicleid, highlight_type, 1);
                            format(caption, sizeof(caption), "Успешно");
                            ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                            printf("[DEBUG] ( : %d, %s) %d %d ", highlight_type, highlight_name, playerid, highlight_price);
                            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET highlight_type = %d WHERE id = %d", highlight_type, database_id);
                            mysql_query(mysql, query, false);
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 1);
							JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "d", data_value);
                            JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                        }
					else
                        {
                            ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 0);
                            JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                        }
                    }
					else if(currency_type == 1)
                    {
                        if(GetPlayerDonateRub(playerid) >= highlight_price)
                        {
                            GivePlayerDonateRub(playerid, -highlight_price, "Покупка дальнего света в техническом центре", true, true);
                            Styling_RegisterServiceSale(playerid, 0, highlight_price);
                            vInfo[vehicleid][vHighLights] = highlight_type;
                            SetVehicleHighLight(vehicleid, highlight_type, 1);
                            format(caption, sizeof(caption), "Успешно");
                            ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                            printf("[DEBUG] ( : %d, %s) %d %d - ", highlight_type, highlight_name, playerid, highlight_price);
                            mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET highlight_type = %d WHERE id = %d", highlight_type, database_id);
                            mysql_query(mysql, query, false);
                            JSON_SetInt(json_packet_data, "t", type);
							JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                            JSON_SetInt(json_packet_data, "s", 1);
                            JSON_SetInt(json_packet_data, "d", data_value);
                            JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
                        }
					else
                        {
                            ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно донат-рублей!", "OK");
                            JSON_SetInt(json_packet_data, "t", type);
                            JSON_SetInt(json_packet_data, "s", 0);
                            JSON_SetString(json_packet_data, "m", "Недостаточно донат-рублей!");
                        }
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Неверный тип валюты!", "OK");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Неверный тип валюты!");
                    }
                }
					else if(TechCenter_GetFirmwareLineByItem(data_value) != FSTATE_NONE)
                {
                    new firmware_type = data_value;
                    new firmware_name[16];
					new type_eq;
                    switch(data_value)
                    {
                        case 4: { format(firmware_name, sizeof(firmware_name), "Comfort"); type_eq = 1; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 4.25); currency_type = 0;} // 4.25
                        case 5: { format(firmware_name, sizeof(firmware_name), "Sport"); type_eq = 1; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 7.25); currency_type = 0;} // 7.25
                        case 6: { format(firmware_name, sizeof(firmware_name), "Drift"); type_eq = 1; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.25); currency_type = 0;}  // 5.25 
                        case 7: { format(firmware_name, sizeof(firmware_name), "Sport+"); type_eq = 1; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0053); currency_type = 1;} // 0.0053
						case 9: { format(firmware_name, sizeof(firmware_name), "Comfort"); type_eq = 2; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 4.25); currency_type = 0;}
                        case 10: { format(firmware_name, sizeof(firmware_name), "Sport"); type_eq = 2; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 7.25); currency_type = 0;}
                        case 11: { format(firmware_name, sizeof(firmware_name), "Drift"); type_eq = 2; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.25); currency_type = 0;}
                        case 12: { format(firmware_name, sizeof(firmware_name), "Sport+"); type_eq = 2; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0053); currency_type = 1;}
						case 14: { format(firmware_name, sizeof(firmware_name), "Comfort"); type_eq = 3; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 4.25); currency_type = 0;}
                        case 15: { format(firmware_name, sizeof(firmware_name), "Sport"); type_eq = 3; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 7.25); currency_type = 0;}
                        case 16: { format(firmware_name, sizeof(firmware_name), "Drift"); type_eq = 3; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.25); currency_type = 0;}
                        case 17: { format(firmware_name, sizeof(firmware_name), "Sport+"); type_eq = 3; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0053); currency_type = 1;}
						case 19: { format(firmware_name, sizeof(firmware_name), "Comfort"); type_eq = 4; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 4.25); currency_type = 0;}
                        case 20: { format(firmware_name, sizeof(firmware_name), "Sport"); type_eq = 4; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 7.25); currency_type = 0;}
                        case 21: { format(firmware_name, sizeof(firmware_name), "Drift"); type_eq = 4; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.25); currency_type = 0;}
                        case 22: { format(firmware_name, sizeof(firmware_name), "Sport+"); type_eq = 4; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0053); currency_type = 1;}
						case 24: { format(firmware_name, sizeof(firmware_name), "Comfort"); type_eq = 5; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 4.25); currency_type = 0;}
                        case 25: { format(firmware_name, sizeof(firmware_name), "Sport"); type_eq = 5; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 7.25); currency_type = 0;}
                        case 26: { format(firmware_name, sizeof(firmware_name), "Drift"); type_eq = 5; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.25); currency_type = 0;}
                        case 27: { format(firmware_name, sizeof(firmware_name), "Sport+"); type_eq = 5; firmware_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0053); currency_type = 1;}
                    }
                    if(currency_type == 0 && GetPlayerMoney(playerid) >= firmware_price)
                    {
						SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - firmware_price);
                        UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                        GivePlayerMoney(playerid, -firmware_price);
                        Styling_RegisterServiceSale(playerid, firmware_price);
                        
                        format(caption, sizeof(caption), "Успешно");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
						new i = GetVehicleData(idveh, V_ACTION_ID);
						
                        TechCenter_SetFirmwareItemOwned(i, data_value);
						switch (data_value)
                        {
                            case 4:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort = 1 WHERE id = %d", database_id);
                            case 5:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport = 1 WHERE id = %d", database_id);
                            case 6:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift = 1 WHERE id = %d", database_id);
                            case 7:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus = 1 WHERE id = %d", database_id);
                        
                            case 9:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort1 = 1 WHERE id = %d", database_id);
                            case 10: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport1 = 1 WHERE id = %d", database_id);
                            case 11: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift1 = 1 WHERE id = %d", database_id);
                            case 12: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus1 = 1 WHERE id = %d", database_id);
                        
                            case 14: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort2 = 1 WHERE id = %d", database_id);
                            case 15: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport2 = 1 WHERE id = %d", database_id);
                            case 16: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift2 = 1 WHERE id = %d", database_id);
                            case 17: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus2 = 1 WHERE id = %d", database_id);
                        
                            case 19: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort3 = 1 WHERE id = %d", database_id);
                            case 20: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport3 = 1 WHERE id = %d", database_id);
                            case 21: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift3 = 1 WHERE id = %d", database_id);
                            case 22: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus3 = 1 WHERE id = %d", database_id);
                        
                            case 24: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort4 = 1 WHERE id = %d", database_id);
                            case 25: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport4 = 1 WHERE id = %d", database_id);
                            case 26: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift4 = 1 WHERE id = %d", database_id);
                            case 27: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus4 = 1 WHERE id = %d", database_id);
                        }
                        
                        mysql_query(mysql, query, false);
						if(TechCenter_ActivateFirmwareIfComplete(playerid, idveh, database_id, data_value))
                            loadChanges(playerid, idveh, json_packet_data);

                        JSON_SetInt(json_packet_data, "t", type); JSON_SetInt(json_packet_data, "s", 1); JSON_SetInt(json_packet_data, "p", data_value); JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                    }
					else if(currency_type == 1 && GetPlayerDonateRub(playerid) >= firmware_price)
                    {
						new i = GetVehicleData(idveh, V_ACTION_ID);
                        GivePlayerDonateRub(playerid, -firmware_price, "Покупка прошивки в техническом центре", true, true);
                        Styling_RegisterServiceSale(playerid, 0, firmware_price);
                        
                        format(caption, sizeof(caption), "Успешно");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                        TechCenter_SetFirmwareItemOwned(i, data_value);
						switch (data_value)
                        {
                            case 4:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort = 1 WHERE id = %d", database_id);
                            case 5:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport = 1 WHERE id = %d", database_id);
                            case 6:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift = 1 WHERE id = %d", database_id);
                            case 7:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus = 1 WHERE id = %d", database_id);
                        
                            case 9:  mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort1 = 1 WHERE id = %d", database_id);
                            case 10: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport1 = 1 WHERE id = %d", database_id);
                            case 11: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift1 = 1 WHERE id = %d", database_id);
                            case 12: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus1 = 1 WHERE id = %d", database_id);
                        
                            case 14: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort2 = 1 WHERE id = %d", database_id);
                            case 15: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport2 = 1 WHERE id = %d", database_id);
                            case 16: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift2 = 1 WHERE id = %d", database_id);
                            case 17: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus2 = 1 WHERE id = %d", database_id);
                        
                            case 19: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort3 = 1 WHERE id = %d", database_id);
                            case 20: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport3 = 1 WHERE id = %d", database_id);
                            case 21: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift3 = 1 WHERE id = %d", database_id);
                            case 22: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus3 = 1 WHERE id = %d", database_id);
                        
                            case 24: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort4 = 1 WHERE id = %d", database_id);
                            case 25: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport4 = 1 WHERE id = %d", database_id);
                            case 26: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift4 = 1 WHERE id = %d", database_id);
                            case 27: mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport_plus4 = 1 WHERE id = %d", database_id);
                        }
                        
                        mysql_query(mysql, query, false);
                        if(TechCenter_ActivateFirmwareIfComplete(playerid, idveh, database_id, data_value))
                            loadChanges(playerid, idveh, json_packet_data);
						JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "t", type); JSON_SetInt(json_packet_data, "s", 1); JSON_SetInt(json_packet_data, "p", data_value); JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type); JSON_SetInt(json_packet_data, "s", 0); JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                    }
                }
					else if(data_value == 1 || data_value == 2 || data_value == 0)
                {
                    new nitro_level = data_value+1;
					switch (data_value){
						case 0:
						    nitro_price =  GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.25); // 5.25
						case 1:
					    	nitro_price =  GetFirmwarePrice(GetPlayerVehicleID(playerid), 2.25); // 2.25
						case 2:
						    nitro_price =  GetFirmwarePrice(GetPlayerVehicleID(playerid), 7.25); // 7.25
					}
                    if(currency_type == 0 && GetPlayerMoney(playerid) >= nitro_price)
                    {
						SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - nitro_price);
                            UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
						GivePlayerMoney(playerid, -nitro_price);
						Styling_RegisterServiceSale(playerid, nitro_price);
			            new i = GetVehicleData(idveh, V_ACTION_ID);
                        vInfo[i][vNitro] = nitro_level;
                        SetOwnableCarData(i, OC_NITRO, nitro_level);
                        ApplyOwnableVehicleNitro(playerid, vehicleid, nitro_level);
                        format(caption, sizeof(caption), "Успешно");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                        mysql_format(mysql, query, sizeof query,
                            "UPDATE ownable_cars SET nitro_level = %d WHERE id = %d",
                            nitro_level, database_id
                        );
                        mysql_query(mysql, query, false);
						JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "t", type); JSON_SetInt(json_packet_data, "s", 1); JSON_SetInt(json_packet_data, "p", data_value); JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type); JSON_SetInt(json_packet_data, "s", 0); JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                    }
                }
					else if (data_value == 1928 || data_value == 1929)
                {
                    new buy_flag;
                    new nitro_price;
                
                    switch (data_value)
                    {
                        case 1928:
                        {
                            nitro_price =  GetFirmwarePrice(GetPlayerVehicleID(playerid), 5); //  5
                            buy_flag = 1; // ПДВ
                        }
                        case 1929:
                        {
                            nitro_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 7.25); // 7.25
                            buy_flag = 2; // Радар
                        }
                    }
                
                    new i = GetVehicleData(idveh, V_ACTION_ID);
                    new current = vInfo[i][pdvradar];
                    if (current & buy_flag)
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Уже куплено!", "OK");
                    }
                
                    if (currency_type == 0 && GetPlayerMoney(playerid) >= nitro_price)
                    {
                        SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - nitro_price);
                        UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                        GivePlayerMoney(playerid, -nitro_price);
                        Styling_RegisterServiceSale(playerid, nitro_price);
                        vInfo[i][pdvradar] |= buy_flag;
                        mysql_format(mysql, query, sizeof query,
                            "UPDATE ownable_cars SET pdvradar = %d WHERE id = %d",
                            vInfo[i][pdvradar], database_id
                        );
                        mysql_tquery(mysql, query);
                        JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 1);
                        JSON_SetInt(json_packet_data, "p", data_value);
                        JSON_SetInt(json_packet_data, "r", GetPlayerMoney(playerid));
                
                        ShowNotificationNew(playerid, 2, 6, 0, 0, "Успешно", "OK");
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type);
                        JSON_SetInt(json_packet_data, "s", 0);
                        JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                    }
                }
				else if(data_value == 35)
                {
                    new launch_control_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.055);
                    if(GetPlayerDonateRub(playerid) >= launch_control_price) // 0.055
                    {
                        GivePlayerDonateRub(playerid, -launch_control_price, "Покупка Launch Control в техническом центре", true, true);
                        Styling_RegisterServiceSale(playerid, 0, launch_control_price);
						new i = GetVehicleData(idveh, V_ACTION_ID);
                        vInfo[i][vLaunchControl] = 1;
                        vInfo[vehicleid][vLaunchControl] = 1;
                        SetOwnableCarData(i, OC_LAUCH, 1);
                        launch[playerid] = 1;
                        format(caption, sizeof(caption), "Успешно");
                        ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
                        mysql_format(mysql, query, sizeof query,
                            "UPDATE ownable_cars SET launch = 1 WHERE id = %d",
                            database_id
                        );
                        mysql_query(mysql, query, false);
						JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
                        JSON_SetInt(json_packet_data, "t", type); JSON_SetInt(json_packet_data, "s", 1); JSON_SetInt(json_packet_data, "p", data_value); JSON_SetInt(json_packet_data, "d", GetPlayerDonateRub(playerid));
                    }
					else
                    {
                        ShowNotificationNew(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(json_packet_data, "t", type); JSON_SetInt(json_packet_data, "s", 0); JSON_SetString(json_packet_data, "m", "Недостаточно средств!");
                    }
                }
					else
                {
                    printf("[DEBUG] data_value (%d) %d", data_value, playerid);
                    JSON_SetInt(json_packet_data, "t", type);
                    JSON_SetInt(json_packet_data, "s", 1);
                }
            }
					else
            {
                ShowNotificationNew(playerid, 3, 6, 0, 0, "Вы не в транспорте!", "OK");
                JSON_SetInt(json_packet_data, "t", type);
                JSON_SetInt(json_packet_data, "s", 0);
                JSON_SetString(json_packet_data, "m", "Вы не в транспорте!");
            }
        }
        case 26:
        {
            printf(" %s ", vinyl);
            format(caption, sizeof(caption), "Успешно");
            ShowNotificationNew(playerid, 2, 6, 0, 0, caption, "OK");
			JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
            JSON_SetInt(json_packet_data, "t", type);
            JSON_SetString(json_packet_data, "v", vinyl);
        }
    }
	
	JSON_SetInt(json_packet_data, "m", GetPlayerMoney(playerid));
	
    OnPacketIncoming(playerid, 28, json_packet_data);
	if(veh != 0 && veh != INVALID_VEHICLE_ID)
	{
		switch(type)
		{
			case 1, 2, 3, 5, 7, 12: SetTimerEx("ReapplyPurchasedVehicleTuning", 350, false, "dd", playerid, veh);
		}
	}
	new json_string[512];
JSON_Stringify(json_packet_data, json_string, sizeof json_string);
printf("Sent: %s", json_string);
    JSON_Cleanup(json_packet_data, true);
    printf("mysql %s", query);
}
case 77:
{
    return Marketplace_OnPacket(playerid, json);
}
case 74:
{
    if(GetPVarInt(playerid, "reward_gui_mode") == 2)
    {
        return MPReward_OnPacket(playerid, json);
    }

    new type, closeFlag;

    if (JSON_GetInt(json, "c", closeFlag) && closeFlag == 1)
    {
        printf("[BP_REWARDS] Player %d closed rewards screen", playerid);
        SetPVarInt(playerid, "reward_gui_mode", 0);
        return 1;
    }

    JSON_GetInt(json, "t", type);

    switch(type)
    {
        case 0:
        {
            return 1;
        }

        case 1:
        {
            new filterState;
            JSON_GetInt(json, "fl", filterState);

            if (filterState >= 1 && filterState <= 7)
            {
                g_player_inventory_count[playerid] = 0;
                g_player_inv_offset[playerid] = 0;
                g_player_filter[playerid] = filterState - 1;
                SendInventoryPage(playerid, 0, filterState == 1 ? 0 : 1);
            }
            return 1;
        }

        case 2:
        {
            new nextIndex;
            if (!JSON_GetInt(json, "pz", nextIndex) || nextIndex == 0)
                nextIndex = g_player_inv_offset[playerid];

            SendInventoryPage(playerid, nextIndex, 2);
            return 1;
        }

        case 3:
        {
            ShowCase(playerid);
            return 1;
        }

        case 4:
        {
            new clickedIdx, buttonType;
            JSON_GetInt(json, "id", clickedIdx);
            JSON_GetInt(json, "s", buttonType);

            if (clickedIdx < 0 || clickedIdx >= g_player_inventory_count[playerid])
            {
                printf("[INV][ERROR] Player %d clicked invalid reward idx=%d", playerid, clickedIdx);
                return 1;
            }

            new id = g_player_inventory[playerid][clickedIdx][item_ids];
            new types = g_player_inventory[playerid][clickedIdx][item_types];
            new internal = g_player_inventory[playerid][clickedIdx][item_internals];
            new count = g_player_inventory[playerid][clickedIdx][item_counts];
            new caseIndex = g_player_inventory[playerid][clickedIdx][item_case_indexs];
            new price = g_player_inventory[playerid][clickedIdx][item_prices];

            if (buttonType == 1)
            {
                if (!GiveInventoryReward(playerid, id, types, internal, count))
                    return 1;

                RemovePlayerCaseReward(playerid, caseIndex + 1, id);

                if (types == 4 || types == 21 || types == 23)
                {
                    ShowCase(playerid);
                    return 1;
                }

                SendInventoryPage(playerid, 0, g_player_filter[playerid] == 0 ? 0 : 1);
                return 1;
            }

            if (buttonType == 3 && price > 0)
            {
                AddPlayerData(playerid, P_SKILL_MICRO_UZI, +, price);
                UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", GetPlayerData(playerid, P_SKILL_MICRO_UZI));

                new skill = GetPlayerData(playerid, P_SKILL_MICRO_UZI);
                new addCases = skill / 2000;
                new remainder = skill % 2000;

                if (addCases > 0)
                {
                    AddPlayerData(playerid, P_SKILL_SNIPER_RIFLE, +, addCases);
                    SetPlayerData(playerid, P_SKILL_MICRO_UZI, remainder);
                    UpdatePlayerDatabaseInt(playerid, "skill_micro_uzi", remainder);
                    UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
                }

                ShowNotificationNew(playerid, 2, 6, 0, 0, "Предмет распылён за спреи!", "BP REWARDS");
                RemovePlayerCaseReward(playerid, caseIndex + 1, id);
                SendInventoryPage(playerid, 0, g_player_filter[playerid] == 0 ? 0 : 1);
                return 1;
            }

            return 1;
        }

        case 5:
        {
            return 1;
        }
    }

    return 1;
}
case 73:
{
    new type;
    JSON_GetInt(json, "t", type); 
    switch (type)
    {
        case 1:
        {
            new clientCaseId;
            JSON_GetInt(json, "cs", clientCaseId);
            new cs = CaseClientIdToLogical(clientCaseId);
            if (cs == 0)
            {
                printf("[CASE][SECURITY] Player %d selected unsupported client case %d", playerid, clientCaseId);
                return 1;
            }
            SetPlayerData(playerid, P_SKILL_COMBAT_SG, cs);
        
            new JSON:response = JSON_Object();
            JSON_SetInt(response, "t", 1);
        
            if (isnull(g_player_case[playerid]))
                cache_get_field_content(0, "case", g_player_case[playerid], sizeof(g_player_case[]));
        
            if (isnull(g_player_case[playerid]))
            {
                format(g_player_case[playerid], sizeof(g_player_case[]),
                    "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0");
            }
        
            if (!IsValidCaseBonusStates(g_player_case_bonus[playerid]))
            {
                InitPlayerCaseBonusStates(g_player_case_bonus[playerid], sizeof(g_player_case_bonus[]));
                new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);
            }
        
            new caseData[512];
            format(caseData, sizeof(caseData), "%s", g_player_case[playerid]);
        
            new openedCases[MAX_CASES];
            for (new i = 0; i < MAX_CASES; i++) openedCases[i] = 0;
        
            if (strlen(caseData) > 0)
            {
                new tmp[64];
                new idx = 0, pos = 0;
        
                for (new i = 0; i <= strlen(caseData) && idx < MAX_CASES; i++)
                {
                    if (caseData[i] == ',' || caseData[i] == '\0')
                    {
                        tmp[pos] = '\0';
                        new val = strval(tmp);
                        if (val > 300) val = 300;
                        openedCases[idx++] = val;
                        pos = 0;
                    }
					else
                    {
                        if (pos < sizeof(tmp) - 1)
                            tmp[pos++] = caseData[i];
                    }
                }
            }
        
            if (cs >= 1 && cs <= MAX_CASES)
                JSON_SetInt(response, "bcc", openedCases[cs - 1]);
            else
                JSON_SetInt(response, "bcc", 0);
        
            if (cs >= 1 && cs <= MAX_CASES)
            {
                RefreshCaseBonusStatesForCase(
                    g_player_case_bonus[playerid],
                    sizeof(g_player_case_bonus[]),
                    cs,
                    openedCases[cs - 1]
                );
                new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);

            }
        
            new cbStr[512];
            BuildCaseBonusJsonForClient(cbStr, sizeof(cbStr), g_player_case_bonus[playerid], cs);
        
            new JSON:cbArray = JSON_Array();
            JSON_Parse(cbStr, cbArray);
            JSON_SetArray(response, "cb", cbArray);
        
            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
        }



        case 2:
        {
            new clientCaseId;
            JSON_GetInt(json, "cs", clientCaseId);
            new types = CaseClientIdToLogical(clientCaseId);
        
            new typess;
            JSON_GetInt(json, "type", typess);

            // Accept only active case cards. Client IDs 27-30 map to logical 12-15.
            if (typess != 1 && typess != 2)
            {
                printf("[CASE][SECURITY] Player %d sent invalid open type %d for client case %d", playerid, typess, clientCaseId);
                return 1;
            }
            if (types == 0)
            {
                printf("[CASE][SECURITY] Player %d tried to open unsupported client case %d", playerid, clientCaseId);
                return 1;
            }

        	new donateCost = 0;
			new scasecount = 0;
            switch (types)
            {
                case 2: donateCost = (typess == 1) ? 100 : 1000;
                case 3: donateCost = (typess == 1) ? 700 : 7000;
                case 4: donateCost = (typess == 1) ? 1200 : 11400;
				case 5: scasecount = (typess == 1) ? 1 : 10;
                case 6: donateCost = (typess == 1) ? 900 : 8550;
                case 7: donateCost = (typess == 1) ? 900 : 8550;
                case 8: donateCost = (typess == 1) ? 900 : 8550;
                case 9: donateCost = (typess == 1) ? 900 : 8550;
                case 10: donateCost = (typess == 1) ? 900 : 8550;
                case 11: donateCost = (typess == 1) ? 900 : 8550;
                case 12: donateCost = (typess == 1) ? 900 : 8550;
                case 13: donateCost = (typess == 1) ? 900 : 8550;
                case 14: donateCost = (typess == 1) ? 900 : 8550;
                case 15: donateCost = (typess == 1) ? 900 : 8550;
            }

			if (scasecount > 0) {
				new currentcasecount = GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE);
				if (currentcasecount < scasecount)
                {
					SendClientMessage(playerid, -1, "Недостаточно для открытия кейса!");
                    return 1;
				}
			}
        	if (donateCost > 0)
            {
                new currentDonate = GetPlayerData(playerid, P_DONATE_RUB);
        
                if (currentDonate < donateCost)
                {
                    SendClientMessage(playerid, -1, "Недостаточно доната для открытия кейса!");
        
                    return 1;
                }
        
                GivePlayerDonateRub(playerid, -donateCost, "Покупка кейса", true, false);
            }
        
            SetPlayerData(playerid, P_SKILL_COLT, types);
        
            new accid = GetPlayerAccountID(playerid);
            printf("[DBG] playerid=%d accountid=%d", playerid, accid);
            if (isnull(g_player_case[playerid])){
				cache_get_field_content(0, "case", g_player_case[playerid], sizeof(g_player_case[]));
			}
			if (isnull(g_player_case[playerid])){
				 format(g_player_case[playerid], sizeof(g_player_case[]),
        "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0");
			}

            static caseData[1024];
            caseData[0] = '\0';
            format(caseData, sizeof(caseData), "%s", g_player_case[playerid]);
			if (isnull(caseData)){
				format(caseData, sizeof(caseData), "%s",  "0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0");
			}
            printf("[DBG] raw caseData from DB: %s", caseData);
        
            new openedCases[MAX_CASES];
            for (new i = 0; i < MAX_CASES; i++) openedCases[i] = 0;
            
            if (strlen(caseData) > 0)
            {
                new tmp[64];
                new idx = 0, pos = 0;
                for (new i = 0; i < strlen(caseData) && idx < MAX_CASES; i++)
                {
                    if (caseData[i] == ',')
                    {
                        tmp[pos] = '\0';
                        new val = strval(tmp);
                        if (val > 300) val = 300;
                        openedCases[idx++] = val;
                        pos = 0;
                    }
					else if (pos < sizeof(tmp) - 1)
                    {
                        tmp[pos++] = caseData[i];
                    }
                }
                if (pos > 0 && idx < MAX_CASES)
                {
                    tmp[pos] = '\0';
                    new val = strval(tmp);
                    if (val > 300) val = 300;
                    openedCases[idx++] = val;
                }
            }
					else
            {
                return 1;
            }


            new caseIndex = types - 1;
            if (caseIndex >= 0 && caseIndex < MAX_CASES)
            {
                openedCases[caseIndex] += (typess == 1) ? 1 : 10;
				ProcessCaseBonusCycle(playerid, caseIndex + 1, openedCases[caseIndex]);
            }
        
            static updatedData[1024];
            updatedData[0] = '\0';
            for (new i = 0; i < MAX_CASES; i++)
            {
                new tmp2[32];
                format(tmp2, sizeof(tmp2), "%d%s", openedCases[i], (i < MAX_CASES - 1) ? "," : "");
                if (strlen(updatedData) + strlen(tmp2) < sizeof(updatedData))
                {
                    strcat(updatedData, tmp2, sizeof(updatedData));
                }
            }
        
            printf("[DBG] new case CSV to save: %s", updatedData);
        
            format(g_player_case[playerid], sizeof(g_player_case[]), "%s", updatedData);
            UpdatePlayerDatabaseString(playerid, "case", g_player_case[playerid]);
        	
        	
            if (typess == 1)
            {
                if (types == 5)
                {
                    SetPlayerData(playerid, P_SKILL_SNIPER_RIFLE, GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE) - 1);
                    UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
                }
                OpenCase(playerid, types);
            }
					else
            {
                if (types == 5)
                {
                    SetPlayerData(playerid, P_SKILL_SNIPER_RIFLE, GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE) - 10);
                    UpdatePlayerDatabaseInt(playerid, "skill_sniper_rifle", GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE));
                }
                OpenCase10(playerid, types);
            }
        }

        case 3:
        {
            new jsonStr[512];
            JSON_Stringify(json, jsonStr, sizeof(jsonStr));
            GiveCaseSkills(playerid, jsonStr, GetPlayerData(playerid, P_SKILL_COLT));
        
            new JSON:response = JSON_Object();
            JSON_SetInt(response, "t", 3);
            JSON_SetInt(response, "s", 1);
            JSON_SetInt(response, "pc", GetPlayerData(playerid, P_SKILL_MICRO_UZI));
			
            new caseIndex = GetPlayerData(playerid, P_SKILL_COLT);
            if (caseIndex < 1 || caseIndex > MAX_CASES)
                caseIndex = 1;
            
            // fullJsonStr уже есть из твоей логики
            new fullJsonStr[2048];
            JSON_Stringify(json, fullJsonStr, sizeof(fullJsonStr));
            
            // Вытаскиваем подстроку bt1 между "[...]" как строку
            new btStr[256];
            btStr[0] = '\0';
            new start = strfind(fullJsonStr, "\"bt1\":[", true);
            if (start != -1)
            {
                start += 7;
                new end = strfind(fullJsonStr[start], "]", true);
                if (end != -1)
                {
                    for (new i = 0; i < end && i < sizeof(btStr)-1; i++)
                        btStr[i] = fullJsonStr[start + i];
                    btStr[end] = '\0';
                }
            }
            
            // Парсим строку в массив int
            new bt1[MAX_BT_ITEMS];
            new btCount = ParseBtStr(btStr, bt1, MAX_BT_ITEMS);
            
            // Добавляем предметы игроку
            for (new i = 0; i < btCount; i++)
            {
                AddPlayerCaseReward(playerid, caseIndex, bt1[i]);
            }
            
            
            
            // Лог
            printf("[CASE REWARDS] Player %d -> кейс %d, добавлено %d предметов",
                playerid, caseIndex, btCount);
            
                        
            
			
            new caseData[512];
            format(caseData, sizeof(caseData), "%s", g_player_case[playerid]);
        
            new openedCases[MAX_CASES];
            for (new i = 0; i < MAX_CASES; i++) openedCases[i] = 0;
        
            if (strlen(caseData) > 0)
            {
                new tmp[64];
                new idx = 0, pos = 0;
        
                for (new i = 0; i <= strlen(caseData) && idx < MAX_CASES; i++)
                {
                    if (caseData[i] == ',' || caseData[i] == '\0')
                    {
                        tmp[pos] = '\0';
                        new val = strval(tmp);
                        if (val > 300) val = 300;
                        openedCases[idx++] = val;
                        pos = 0;
                    }
					else if (pos < sizeof(tmp) - 1)
                    {
                        if (pos < sizeof(tmp) - 1)
                            tmp[pos++] = caseData[i];
                    }
                }
            }
        

        
            JSON_SetInt(response, "bcc", openedCases[caseIndex - 1]);
			ProcessCaseBonusCycle(playerid, caseIndex, openedCases[caseIndex - 1]);
            if (!IsValidCaseBonusStates(g_player_case_bonus[playerid]))
            {
                InitPlayerCaseBonusStates(g_player_case_bonus[playerid], sizeof(g_player_case_bonus[]));
                new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);
            }
            
            // после открытия кейса пересчитываем бонусы текущего кейса
            RefreshCaseBonusStatesForCase(
                g_player_case_bonus[playerid],
                sizeof(g_player_case_bonus[]),
                caseIndex,
                openedCases[caseIndex - 1]
            );
            
            new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);
            
            new cbStr[512];
            BuildCaseBonusJsonForClient(cbStr, sizeof(cbStr), g_player_case_bonus[playerid], caseIndex);
            
            new JSON:cbArray = JSON_Array();
            JSON_Parse(cbStr, cbArray);
            JSON_SetArray(response, "cb", cbArray);
        
            new ccStr[1024];
            ccStr[0] = '\0';
            strcat(ccStr, "[", sizeof(ccStr));
        
            for (new i = 1; i <= ACTIVE_CASES_COUNT; i++)
            {
                new cot = 0;
                if (i == 5)
                    cot = GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE);
            
                new clientCaseId = CaseLogicalIdToClient(i);
                format(ccStr[strlen(ccStr)], sizeof(ccStr) - strlen(ccStr),
                    "{\"id\":%d,\"cot\":%d}%s", clientCaseId, cot, (i < ACTIVE_CASES_COUNT) ? "," : ""
                );
            }
        
            strcat(ccStr, "]", sizeof(ccStr));
        
            new JSON:ccArray = JSON_Array();
            JSON_Parse(ccStr, ccArray);
            JSON_SetArray(response, "cc", ccArray);
        
            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
        }
        case 6:
        {
            callcmd::reward(playerid);
        }
		case 7:
        {
            new buttonIndex;
            JSON_GetInt(json, "b", buttonIndex);
        
            new caseIndex = GetPlayerData(playerid, P_SKILL_COMBAT_SG);
            if (caseIndex < 1 || caseIndex > MAX_CASES || buttonIndex < 1 || buttonIndex > 5)
                return 1;
        
            if (!IsValidCaseBonusStates(g_player_case_bonus[playerid]))
            {
                printf("[CASE BONUS] Некорректные данные у игрока %d, сбрасываю на дефолт", playerid);
                InitPlayerCaseBonusStates(g_player_case_bonus[playerid], sizeof(g_player_case_bonus[]));
                new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);
            }
        
            new caseData[512];
            format(caseData, sizeof(caseData), "%s", g_player_case[playerid]);
        
            new openedCases[MAX_CASES];
            for (new i = 0; i < MAX_CASES; i++) openedCases[i] = 0;
        
            if (strlen(caseData) > 0)
            {
                new tmp[64];
                new idx = 0, pos = 0;
        
                for (new i = 0; i <= strlen(caseData) && idx < MAX_CASES; i++)
                {
                    if (caseData[i] == ',' || caseData[i] == '\0')
                    {
                        tmp[pos] = '\0';
                        new val = strval(tmp);
                        if (val > 300) val = 300;
                        openedCases[idx++] = val;
                        pos = 0;
                    }
					else
                    {
                        if (pos < sizeof(tmp) - 1)
                            tmp[pos++] = caseData[i];
                    }
                }
            }
        
            RefreshCaseBonusStatesForCase(
                g_player_case_bonus[playerid],
                sizeof(g_player_case_bonus[]),
                caseIndex,
                openedCases[caseIndex - 1]
            );
        
            new curState = GetCaseBonusState(g_player_case_bonus[playerid], caseIndex, buttonIndex);
            if (curState != CASE_BONUS_STATE_AVAILABLE)
            {
                printf("[CASE BONUS] Player %d tried claim unavailable bonus: case=%d button=%d state=%d",
                    playerid, caseIndex, buttonIndex, curState);
                return 1;
            }
        
            // Тут выдача бонуса игроку
            // GiveCaseBonusReward(playerid, caseIndex, buttonIndex);
			if (!SavePlayerCaseBonusReward(playerid, caseIndex, buttonIndex))
            {
                printf("[CASE BONUS] Не удалось сохранить бонус: player=%d case=%d button=%d",
                    playerid, caseIndex, buttonIndex);
                return 1;
            }
            SetCaseBonusState(
                g_player_case_bonus[playerid],
                sizeof(g_player_case_bonus[]),
                caseIndex,
                buttonIndex,
                CASE_BONUS_STATE_CLAIMED
            );
        
            new query[2048];
        
	        mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `case_bonus`='%s' WHERE `id`=%d LIMIT 1", g_player_case_bonus[playerid], GetPlayerAccountID(playerid));
	        mysql_query(mysql, query, false);
           
            printf("[CASE BONUS] Player %d -> кейс %d, кнопка %d сохранена: %s",
                playerid, caseIndex, buttonIndex, g_player_case_bonus[playerid]);
        
            new JSON:response = JSON_Object();
            JSON_SetInt(response, "t", 1);
        
            JSON_SetInt(response, "bcc", openedCases[caseIndex - 1]);
        
            new cbStr[512];
            BuildCaseBonusJsonForClient(cbStr, sizeof(cbStr), g_player_case_bonus[playerid], caseIndex);
        
            new JSON:cbArray = JSON_Array();
            JSON_Parse(cbStr, cbArray);
            JSON_SetArray(response, "cb", cbArray);
			new ccStr[512];
            ccStr[0] = '\0';
            strcat(ccStr, "[", sizeof(ccStr));
        
            for (new i = 1; i <= ACTIVE_CASES_COUNT; i++)
            {
                new cot = 0;
                if (i == 5)
                    cot = GetPlayerData(playerid, P_SKILL_SNIPER_RIFLE);
            
                new clientCaseId = CaseLogicalIdToClient(i);
                format(ccStr[strlen(ccStr)], sizeof(ccStr) - strlen(ccStr),
                    "{\"id\":%d,\"cot\":%d}%s", clientCaseId, cot, (i < ACTIVE_CASES_COUNT) ? "," : ""
                );
            }
        
            strcat(ccStr, "]", sizeof(ccStr));
        
            new JSON:ccArray = JSON_Array();
            JSON_Parse(ccStr, ccArray);
            JSON_SetArray(response, "cc", ccArray);
        
            OnPacketIncoming(playerid, 73, response);
            JSON_Cleanup(response);
        }
	}
}
case 63:
{
    new type;
    JSON_GetInt(json, "t", type);  // Подтип пакета (если есть)

    switch(type)
    {
        case 1:  // Обработка закрытия экрана (sendCloseScreen)
        {
            new closeFlag;
            JSON_GetInt(json, "c", closeFlag);

            if (closeFlag == 1)
            {
                // Симулируем ответ сервера: закрытие или новый экран
                new JSON:response = JSON_Object();
                JSON_SetInt(response, "s", 0);  // screen = 0 (закрытие)
                JSON_SetInt(response, "st", 1);  // isNeedClose = true

                OnPacketIncoming(playerid, 63, response);
                JSON_Cleanup(response);
                
                // Сообщение игроку
                SendClientMessage(playerid, -1, "NPC interaction closed.");
            }
        }
        case 2:  // Обработка клика кнопки (sendButtonClick)
        {
            new buttonKey;
            JSON_GetInt(json, "b", buttonKey);

            // В зависимости от buttonKey, строим новый диалог
            new JSON:response = JSON_Object();
            JSON_SetInt(response, "s", 1);  // screen = 1 (новый экран)
            JSON_SetString(response, "tt", "NPC Title");  // textTitle
            JSON_SetString(response, "td", "Hello, adventurer! What do you want?");  // textDesc
            JSON_SetInt(response, "ts", 50);  // typingSpeed = 50ms
            JSON_SetBool(response, "st", true);  // isSkipText = true
            JSON_SetInt(response, "r", 101);  // renderId = 101 (для NPC модели)

            // Массив кнопок (bt) как в InteractionWithNpcButtonModel
            new JSON:buttonList = JSON_Array();
            
            new JSON:btn1 = JSON_Object();
            JSON_SetInt(btn1, "k", INTERACTION_WITH_NPC_BUTTON_GREEN);  // key = 1 (green)
            JSON_SetString(btn1, "n", "Accept Quest");  // name
            JSON_SetInt(btn1, "i", 1);  // id = 1
            JSON_Append(buttonList, btn1);
            
            new JSON:btn2 = JSON_Object();
            JSON_SetInt(btn2, "k", INTERACTION_WITH_NPC_BUTTON_RED);  // key = 3 (red)
            JSON_SetString(btn2, "n", "Decline");  // name
            JSON_SetInt(btn2, "i", 2);  // id = 2
            JSON_Append(buttonList, btn2);
            
            new JSON:btn3 = JSON_Object();
            JSON_SetInt(btn3, "k", INTERACTION_WITH_NPC_BUTTON_GRAY);  // key = 2 (gray)
            JSON_SetString(btn3, "n", "More Info");  // name
            JSON_SetInt(btn3, "i", 3);  // id = 3
            JSON_Append(buttonList, btn3);
            
            JSON_SetArray(response, "bt", buttonList);  // buttonList

            OnPacketIncoming(playerid, 63, response);
            JSON_Cleanup(response);
        } 

        default:
        {
            // Обработка неизвестного типа или инициализация
            new JSON:response = JSON_Object();
            JSON_SetInt(response, "s", 1);  // Начальный экран
            JSON_SetString(response, "tt", "Welcome to NPC"); 
            JSON_SetString(response, "td", "This is a test dialog. Press a button.");
            JSON_SetInt(response, "ts", 30); 
            JSON_SetBool(response, "st", false); 
            JSON_SetInt(response, "r", 100); 

            // Массив кнопок по умолчанию
            new JSON:buttonList = JSON_Array();
            
            new JSON:btnSkip = JSON_Object();
            JSON_SetInt(btnSkip, "k", INTERACTION_WITH_NPC_BUTTON_SKIP);  // key = 0 (skip)
            JSON_SetString(btnSkip, "n", "Skip"); 
            JSON_SetInt(btnSkip, "i", 0); 
            JSON_Append(buttonList, btnSkip);
            
            JSON_SetArray(response, "bt", buttonList);

            OnPacketIncoming(playerid, 63, response);
            JSON_Cleanup(response);
            
            ~json;
        }
    }
}



        default:
        {
            // Очистка по умолчанию (как в примере), плюс логика для Case модели
            JSON_Cleanup(JSONObject);
            ~json;
            JSON_Cleanup(json_packet_data);
        }
    }
    return 1;
}

