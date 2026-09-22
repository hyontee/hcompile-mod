//>> Файл: bykranin_src/core/inventory/inventory_07.inc  (665 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: /autosalon, /addpcar, /givecar, tp_price, ShowPlayerSellCarDialog, /unsellmycar, tp_buy
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:autosalon(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 12) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	new action[8], marketid, modelid, amount;
	if(sscanf(params, "s[8]ddd", action, marketid, modelid, amount))
	{
		SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /autosalon [set/add] [market_id 0-4] [model_id, 0 - весь салон] [слоты]");
		return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} market_id: 0 мото, 1 низкий, 2 высокий, 3 средний, 4 грузовой");
	}

	if(strcmp(action, "set", true) && strcmp(action, "add", true))
		return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Действие: set или add");

	if(!(0 <= marketid <= 4))
		return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} market_id должен быть от 0 до 4");

	if(modelid < 0)
		return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} model_id не может быть меньше 0");

	if(modelid != 0 && GetCarMarketModelIndex(marketid, modelid) == -1)
		return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Этой модели нет в указанном автосалоне");

	if(!strcmp(action, "set", true))
	{
		if(amount < 0)
			return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Количество слотов не может быть меньше 0");

		if(!AutosalonSetVehicleSlots(marketid, modelid, amount))
			return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения слотов автосалона в базу данных");
	}
	else
	{
		if(!AutosalonAddVehicleSlot(marketid, modelid, amount))
			return SendClientMessage(playerid, 0xFF6600FF, "Ошибка сохранения слотов автосалона в базу данных");
	}

	RefreshAutosalonSlotsForPlayers();

	new slots = GetAutosalonVehicleSlots(marketid, modelid), fmt_text[160];
	format(fmt_text, sizeof fmt_text, "{ffff00}|{ffffff} Автосалон %d, модель %d: слотов %d", marketid, modelid, slots);
	SendClientMessage(playerid, 0xCECECEFF, fmt_text);

	format(fmt_text, sizeof fmt_text, "Изменил слоты автосалона: действие %s, салон %d, модель %d, слоты %d", action, marketid, modelid, slots);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);
	return 1;
}
CMD:addpcar(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

	extract params -> new model_id, color_1, color_2; else return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /addpcar [id модели] [цвет кузова] [цвет шин]");

	if(!(400 <= model_id <= 30000)) return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff}Используйте модель от 400 до 2591");

	new status;

	sscanf(params, "{d}{d}{d}d", status);

	if(!(0 <= status <= 1))
		return SendClientMessage(playerid, 0x999999FF, "{ffff00}|{ffffff}Доступ игроков к транспорту: 0 - Нет доступа, 1 - Доступно любому игроку");

	new Float: x,
		Float: y,
		Float: z,
		Float: a;

	GetPlayerPos(playerid, x, y, z);
	GetPlayerFacingAngle(playerid, a);

	new vehicleid = CreateVehicle(model_id, x, y, z, a, color_1, color_2, -1, 0, VEHICLE_ACTION_TYPE_GIFT_CAR, 1);
	PutPlayerInVehicle(playerid, vehicleid, 0);
    ChangeVehicleColor(vehicleid, color_1, color_2);
	SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_ON);
	new fmt_text[999];

	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал мероприятие ''Сядь - получи транспорт'' (%d, %d, %d)",
	GetPlayerNameEx(playerid), playerid, model_id, color_1, color_2);
    SendMessageToAdmins(fmt_text, 0x999999FF);

	format(fmt_text, sizeof fmt_text, "Создал мероприятие ''Сядь - получи транспорт''(%d, %d, %d)", model_id, color_1, color_2);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);
     
    format(fmt_text, sizeof fmt_text, "{ff00ff}Администратор %s[%d] Создал мероприятие ''Сядь - получи транспорт''", GetPlayerNameEx(playerid), playerid);
    SendClientMessageToAll(0xFF5533FF, fmt_text);
     
    SetTimerEx("tp_price", 500, false, "d", playerid);

	return 1;
}

CMD:givecar(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 13)
        return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");

    new to_player, model_id;
    if(sscanf(params, "dd", to_player, model_id))
        return SendClientMessage(playerid, 0xCECECEFF, "{ffff00}|{ffffff} Используйте: /givecar [id игрока] [id модели]");

    if(!IsPlayerConnected(to_player))
        return SendClientMessage(playerid, 0x999999FF, "Игрок не найден");

    if(!IsPlayerLogged(to_player))
        return SendClientMessage(playerid, 0x999999FF, "Игрок еще не авторизован");

    if(!(400 <= model_id <= 300000))
        return SendClientMessage(playerid, 0x999999FF, "ID модели должен быть от 400 до 30000");

    if((GetPlayerOwnableCars(to_player) + 1) > GetPlayerCarSlots(to_player))
        return SendClientMessage(playerid, 0x999999FF, "У игрока нет свободных слотов для транспорта");

    new idx = GetFreeOwnableCarID();
    if(idx == -1)
        return SendClientMessage(playerid, 0x999999FF, "Нет свободных слотов транспорта на сервере");

    new Float:pos_x, Float:pos_y, Float:pos_z, Float:angle;
    GetPlayerPos(to_player, pos_x, pos_y, pos_z);
    GetPlayerFacingAngle(to_player, angle);

    SetOwnableCarData(idx, OC_OWNER_ID, GetPlayerAccountID(to_player));
    SetOwnableCarData(idx, OC_MODEL_ID, model_id);
    SetOwnableCarData(idx, OC_COLOR_1, 1);
    SetOwnableCarData(idx, OC_COLOR_2, 1);
    SetOwnableCarData(idx, OC_POS_X, pos_x);
    SetOwnableCarData(idx, OC_POS_Y, pos_y);
    SetOwnableCarData(idx, OC_POS_Z, pos_z);
    SetOwnableCarData(idx, OC_ANGLE, angle);
    strmid(g_ownable_car[idx][OC_NUMBER], "------", 0, 8, 8);
    SetOwnableCarData(idx, OC_ALARM, false);
    SetOwnableCarData(idx, OC_KEY_IN, false);
    SetOwnableCarData(idx, OC_CREATE, gettime());
    format(g_ownable_car[idx][OC_OWNER_NAME], 21, GetPlayerNameEx(to_player));

    new query[256];
    mysql_format(mysql, query, sizeof(query),
        "INSERT INTO ownable_cars (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) VALUES (%d,%d,%d,%d,'%f','%f','%f','%f',%d)",
        GetPlayerAccountID(to_player), model_id, 1, 1, pos_x, pos_y, pos_z, angle, gettime());

    new Cache:result = mysql_query(mysql, query, true);
    if(mysql_errno())
    {
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
        cache_delete(result);
        return SendClientMessage(playerid, 0x999999FF, "Ошибка при записи в базу ownable_cars");
    }

    SetOwnableCarData(idx, OC_SQL_ID, cache_insert_id());
    cache_delete(result);

    new admin_msg[144], target_msg[144], log_msg[144];
    format(admin_msg, sizeof(admin_msg), "Вы выдали %s транспорт (model: %d)", GetPlayerNameEx(to_player), model_id);
    SendClientMessage(playerid, 0x66CC00FF, admin_msg);

    format(target_msg, sizeof(target_msg), "Администратор %s выдал вам транспорт (model: %d)", GetPlayerNameEx(playerid), model_id);
    SendClientMessage(to_player, 0x66CC00FF, target_msg);

    format(log_msg, sizeof(log_msg), "[A] %s[%d] выдал %s[%d] авто model:%d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, model_id);
    SendMessageToAdmins(log_msg, 0x999999FF);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, log_msg);
    return 1;
}

public tp_price(playerid) 
{
    new vehicleid = GetPlayerVehicleID(playerid);
    new Float: x, Float: y, Float: z;
    GetVehiclePos(vehicleid, x, y, z);
    CreateVehicleLabel(vehicleid, "{ff00ff}Сюрприз!\nТолько для самых быстрых! Залезай за руль этого транспорта, и он твой!", 0x2BB1FFFF, x, y, z + 9, 9.0);
}
stock ShowPlayerSellCarDialog(playerid)
{
                    ShowPlayerDialog(playerid,8968,DIALOG_STYLE_INPUT,"{00FFFF}"SERVER_NAME"{FFFFFF} | Подготовка к продаже транспорта","Вам необходимо ввести цену, за которую Вы хотите\nпродать свой транспорт в диалоговое поле ниже:","Готово","Отмена");
}

CMD:unsellmycar(playerid) 
{
if(player_sell_ownable_car[playerid] == true)
                         	{
ShowPlayerDialog(playerid,8977,DIALOG_STYLE_MSGBOX,"{00FFFF}"SERVER_NAME"{FFFFFF} | Снятие с продажи транспорта","Вы уверены что хотите снять свой транспорт с продажи","Да","Нет");
                             }
					else SendClientMessage(playerid, 0xCECECEFF, "Вы не выставили свой транспорт на продажу");
}

public tp_buy(playerid)
{
SetPlayerPos(playerid, 447.955505,985.479675,1001.039978);
		SetPlayerFacingAngle(playerid, 272.468505);
		SetCameraBehindPlayer(playerid);
		SetPlayerVirtualWorld(playerid, 101);
          SetPlayerInterior(playerid, 1);
}

CMD:buycar(playerid) 
{
if(player_sell_ownable_car[playerid] == true)
                         	{
                         SendClientMessage(playerid, 0xCECECEFF, "Сначала продайте или уберите свой транспорт с продажи");
                         return 1;
                         }
					else {
new vehicleid = GetNearestVehicleID(playerid, 5.0);

if(vehicleid != -1)	
{
	     if(ownable_car_sell_status[vehicleid] == true)
                         	{
	        new model_id = GetVehicleData(vehicleid, V_MODELID);
            new index = GetVehicleData(vehicleid, V_ACTION_ID);
            if(index < 0) return SendClientMessage(playerid, 0xCECECEFF, "Произошла ошибка определения транспорта");
            new to_player = GetOwnableCarData(index, OC_LAST_OWNER_GAME_ID);
            new price = GetOwnableCarData(index, OC_LAST_PRICE);
            
			if((GetPlayerOwnableCars(playerid) + 1) > GetPlayerCarSlots(playerid))
				return SendClientMessage(playerid, 0xCECECEFF, "У вас нет свободных слотов для транспорта");

			if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0xCECECEFF, "Вы должны выгрузить свой личный транспорт с сервера {888888}(/car > 7)");

			if(GetPlayerMoneyEx(playerid) < price)
				return SendClientMessage(playerid, 0xCECECEFF, "У вас нет денег чтобы купить этот транспорт");
                
                SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_OWNABLE_CAR2, price, vehicleid);
            }
					else  SendClientMessage(playerid, 0xCECECEFF, "Эта машина не продается");
    }
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находится рядом с транспортом который хотите купить");
}
}

stock bool:IsValidAccessorySlot(playerid, slot)
{
    return (slot >= 0 && slot < MAX_PLAYER_ATTACHED_OBJECTS && IsPlayerAttachedObjectSlotUsed(playerid, slot));
}

stock Float:GetAccessoryParamValue(playerid, slot, param_index)
{
    switch(param_index)
    {
        case 0: return gPlayerTempAccData[playerid][slot][4]; // Z
        case 1: return gPlayerTempAccData[playerid][slot][3]; // Y
        case 2: return gPlayerTempAccData[playerid][slot][2]; // X
        case 3: return gPlayerTempAccData[playerid][slot][5]; // RotX
        case 4: return gPlayerTempAccData[playerid][slot][6]; // RotY
        case 5: return gPlayerTempAccData[playerid][slot][7]; // RotZ
    }
    return 0.0;
}

stock bool:UpdateAccessoryParameter(playerid, slot, param_index, Float:new_value)
{
    if(!IsValidAccessorySlot(playerid, slot))
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: Нет аксессуара в этом слоте.");
        return false;
    }

    new Float:fX = gPlayerTempAccData[playerid][slot][2];
    new Float:fY = gPlayerTempAccData[playerid][slot][3];
    new Float:fZ = gPlayerTempAccData[playerid][slot][4];
    new Float:fRX = gPlayerTempAccData[playerid][slot][5];
    new Float:fRY = gPlayerTempAccData[playerid][slot][6];
    new Float:fRZ = gPlayerTempAccData[playerid][slot][7];

    switch(param_index)
    {
        case 0: fZ = new_value; // Z
        case 1: fY = new_value; // Y
        case 2: fX = new_value; // X
        case 3: fRX = new_value; // RotX
        case 4: fRY = new_value; // RotY
        case 5: fRZ = new_value; // RotZ
    }

    UpdatePlayerAccessory(playerid, slot, fX, fY, fZ, fRX, fRY, fRZ);
    return true;
}

stock ShowEditAccessoryDialog(playerid, slot)
{
    new dialog_text[1024];
    new Float:fX = gPlayerTempAccData[playerid][slot][2];
    new Float:fY = gPlayerTempAccData[playerid][slot][3];
    new Float:fZ = gPlayerTempAccData[playerid][slot][4];
    new Float:fRX = gPlayerTempAccData[playerid][slot][5];
    new Float:fRY = gPlayerTempAccData[playerid][slot][6];
    new Float:fRZ = gPlayerTempAccData[playerid][slot][7];

    format(dialog_text, sizeof(dialog_text),
        "Положение влево/вправо (Z)\n\
        Положение от себя/на себя (Y)\n\
        Положение вверх/вниз (X)\n\
        Поворот по X\n\
        Поворот по Y\n\
        Поворот по Z\n\
        {00FF00}Сохранить изменения",
        fZ, fY, fX, fRX, fRY, fRZ
    );

    ShowPlayerDialog(playerid, DIALOG_ID_EDITACS_EDIT, DIALOG_STYLE_LIST, "{FFD700}Редактирование аксессуара", dialog_text, "Изменить", "Назад");
}

stock bool:SaveAccessoryChanges(playerid, slot)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: Аккаунт не загружен.");
        return false;
    }

    if(!IsValidAccessorySlot(playerid, slot))
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: Неверный слот.");
        return false;
    }

    new modelid = floatround(gPlayerTempAccData[playerid][slot][0]);
    new bone = floatround(gPlayerTempAccData[playerid][slot][1]);
    new Float:pos_x = gPlayerTempAccData[playerid][slot][2];
    new Float:pos_y = gPlayerTempAccData[playerid][slot][3];
    new Float:pos_z = gPlayerTempAccData[playerid][slot][4];
    new Float:rot_x = gPlayerTempAccData[playerid][slot][5];
    new Float:rot_y = gPlayerTempAccData[playerid][slot][6];
    new Float:rot_z = gPlayerTempAccData[playerid][slot][7];
    new Float:scale_x = gPlayerTempAccData[playerid][slot][8];
    new Float:scale_y = gPlayerTempAccData[playerid][slot][9];
    new Float:scale_z = gPlayerTempAccData[playerid][slot][10];

    new query[512];
    format(query, sizeof(query),
        "REPLACE INTO accessories (account_id, slot, modelid, bone, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, scale_x, scale_y, scale_z) \
         VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f, %f, %f)",
        account_id, slot, modelid, bone, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, scale_x, scale_y, scale_z
    );
    
    #if defined DEBUG_MODE
    printf("[DEBUG] REPLACE SQL (Edit): %s", query);
    #endif
    
    return mysql_query(mysql, query);
}

stock UpdatePlayerAccessory(playerid, slot, Float:newX, Float:newY, Float:newZ, Float:newRX, Float:newRY, Float:newRZ)
{
    if(!IsValidAccessorySlot(playerid, slot))
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: Нет аксессуара в этом слоте.");
        return 1;
    }

    new modelid = floatround(gPlayerTempAccData[playerid][slot][0]);
    new boneid = floatround(gPlayerTempAccData[playerid][slot][1]);
    new Float:fSX = gPlayerTempAccData[playerid][slot][8];
    new Float:fSY = gPlayerTempAccData[playerid][slot][9];
    new Float:fSZ = gPlayerTempAccData[playerid][slot][10];

    gPlayerTempAccData[playerid][slot][2] = newX;
    gPlayerTempAccData[playerid][slot][3] = newY;
    gPlayerTempAccData[playerid][slot][4] = newZ;
    gPlayerTempAccData[playerid][slot][5] = newRX;
    gPlayerTempAccData[playerid][slot][6] = newRY;
    gPlayerTempAccData[playerid][slot][7] = newRZ;

    RemovePlayerAttachedObject(playerid, slot);
	
if (boneid >0 && modelid > 0){
    SetPlayerAttachedObject(playerid, slot, modelid, boneid, newX, newY, newZ, newRX, newRY, newRZ, fSX, fSY, fSZ);
}
    SendClientMessage(playerid, -1, "{00FF00}Аксессуар обновлен. Не забудьте сохранить!");
}

CMD:editacs(playerid)
{
    new dialog_text[512];
    new bool:has_accessory = false;

    for(new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
    {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i))
        {
            format(dialog_text, sizeof(dialog_text), "%sСлот %d (модель: %d)\n", 
                   dialog_text, i, floatround(gPlayerTempAccData[playerid][i][0]));
            has_accessory = true;
        }
    }

    if(!has_accessory)
    {
        SendClientMessage(playerid, -1, "{FF0000}Ошибка: У вас нет надетых аксессуаров для редактирования.");
        return 1;
    }

    ShowPlayerDialog(playerid, DIALOG_ID_EDITACS_SELECT, DIALOG_STYLE_LIST, 
                     "{FFD700}Редактирование аксессуаров", dialog_text, "Выбрать", "Отмена");
    return 1;
}
stock SafeGetPlayerData(playerid, field)
{
    if (field >= sizeof(g_player[]))
    {
        printf("[ERROR] SafeGetPlayerData: invalid field = %d (max = %d)", field, sizeof(g_player[]));
        return 0;
    }
    if (playerid < 0 || playerid >= MAX_PLAYERS) return 0;
    return g_player[playerid][field];
}


stock SafeSetPlayerData(playerid, field, value)
{
    if (playerid < 0 || playerid >= MAX_PLAYERS) return;
    g_player[playerid][field] = value;
}
forward UpdateOnlineTimers();
public UpdateOnlineTimers()
{
    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        SafeSetPlayerData(i, P_ONLINE_TODAY, SafeGetPlayerData(i, P_ONLINE_TODAY) + 1);
		if(GetPlayerAdminEx(i) > 0 && GetPlayerData(i, P_ADMIN_LOGGED))
		{
			new admin_online_query[256];
			mysql_format(mysql, admin_online_query, sizeof admin_online_query,
				"INSERT INTO admin_stats_online (account_id,stat_date,seconds) VALUES (%d,CURDATE(),60) ON DUPLICATE KEY UPDATE seconds=seconds+60",
				GetPlayerAccountID(i));
			mysql_tquery(mysql, admin_online_query);
		}
    }
}
forward AutoRewardTopOnline();
public AutoRewardTopOnline()
{
    new hour, minute, second;
    gettime(hour, minute, second);
    if (hour != 23 || minute != 59) return;

    new top_players[3] = {-1, -1, -1};
    new top_minutes[3] = {0, 0, 0};

    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        new minutes = SafeGetPlayerData(i, P_ONLINE_TODAY);

        if (minutes > top_minutes[0])
        {
            top_minutes[2] = top_minutes[1]; top_players[2] = top_players[1];
            top_minutes[1] = top_minutes[0]; top_players[1] = top_players[0];
            top_minutes[0] = minutes;        top_players[0] = i;
        }
					else if (minutes > top_minutes[1])
        {
            top_minutes[2] = top_minutes[1]; top_players[2] = top_players[1];
            top_minutes[1] = minutes;        top_players[1] = i;
        }
					else if (minutes > top_minutes[2])
        {
            top_minutes[2] = minutes;        top_players[2] = i;
        }
    }

	if (IsPlayerConnected(top_players[0]))
	{
		new p = top_players[0];
		GivePlayerDonateRub(p, 300, "Награда за 1 место по онлайну");
		GivePlayerMoneyEx(p, 50000000, "Награда за 1 место по онлайну");
		SendClientMessage(p, 0x00FF00FF, "[ТОП ОНЛАЙН] Вы заняли 1 место и получили 300 доната + 50.000.000$");
	}

    if (IsPlayerConnected(top_players[1]))
    {
        GivePlayerDonateRub(top_players[1], 200, "Награда за 2 место по онлайну");
        GivePlayerMoneyEx(top_players[1], 35000000, "Награда за 2 место по онлайну");
        SendClientMessage(top_players[1], -1, "[ТОП ОНЛАЙН] Вы заняли 2 место и получили 200 доната + 35.000.000$");
    }

    if (IsPlayerConnected(top_players[2]))
    {
        GivePlayerDonateRub(top_players[2], 150, "Награда за 3 место по онлайну");
        GivePlayerMoneyEx(top_players[2], 20000000, "Награда за 3 место по онлайну");
        SendClientMessage(top_players[2], -1, "[ТОП ОНЛАЙН] Вы заняли 3 место и получили 100 доната + 20.000.000$");
    }

    SendClientMessageToAll(-1, "{FFD700}[ТОП ОНЛАЙН]{FFFFFF} Награды за дневной онлайн выданы! Система сброшена.");

    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        SafeSetPlayerData(i, P_ONLINE_TODAY, 0);
        UpdatePlayerDatabaseInt(i, "online_today", 0);
    }
}
CMD:toponline(playerid, params[])
{
    new query[384];
    format(query, sizeof(query), "SELECT `name`, `online_today` FROM `accounts` ORDER BY `online_today` DESC LIMIT 10");
    
    new Cache:cache = mysql_query(mysql, query);
    
    if(cache_num_rows() == 0)
    {
        SendClientMessage(playerid, -1, "Нет данных для отображения.");
        cache_delete(cache);
        return 1;
    }

    new str[1024], pname[MAX_PLAYER_NAME];
    format(str, sizeof(str), "{00FF00}[ТОП ОНЛАЙН за сутки]\n");
    strcat(str, "{FFFFFF}-----------------------------\n");
    strcat(str, "{FFD700}#\tИгрок\t\tМинуты{FFFFFF}\n");
    strcat(str, "-----------------------------\n");

    for(new i = 0; i < cache_num_rows(); i++)
    {
        // Use field names instead of indices
        cache_get_field_content(i, "name", pname, sizeof(pname));
        new minutes = cache_get_field_content_int(i, "online_today");

        // Выравнивание
        new tab[8] = "\t";
        if(strlen(pname) <= 10) format(tab, sizeof(tab), "\t\t");

        format(str, sizeof(str), "%s{FFD700}%d.{FFFFFF}\t%s%s%d\n", str, i + 1, pname, tab, minutes);
    }

    ShowPlayerDialog(playerid, 1500, DIALOG_STYLE_MSGBOX, "ТОП ОНЛАЙН", str, "Ок", "");
    cache_delete(cache);
    return 1;
}
forward SaveOnlineTimers();
public SaveOnlineTimers()
{
    foreach (new i : Player)
    {
        if (!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        UpdatePlayerDatabaseInt(i, "online_today", GetPlayerData(i, P_ONLINE_TODAY));
    }
}
stock GetPlayerDatabaseInt(playerid, const field[])
{
    new query[128], Cache: result, value = 0;

    format(query, sizeof(query), "SELECT `%s` FROM `accounts` WHERE `id` = %d LIMIT 1", field, GetPlayerAccountID(playerid));
    result = mysql_query(mysql, query, true);

    if (cache_num_rows(result))
    {
        value = cache_get_field_content_int(0, field);
    }

    cache_delete(result);
    return value;
}

CMD:bez(playerid, params[]) 
{
    if(GetPlayerAdminEx(playerid) < 2) 
        return SendClientMessage(playerid, 0xCECECEFF, "Ошибка: У вас недостаточно прав.");

    if(isnull(params))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /bez [ник игрока]");

    // Копируем имя игрока безопасным способом
    new name[MAX_PLAYER_NAME];
    format(name, sizeof(name), "%s", params);
    
    // Обрезаем лишние пробелы в конце
    for(new i = strlen(name)-1; i >= 0 && name[i] == ' '; --i) {
        name[i] = EOS;
    }

    new Cache:result;
    new query[128];
    
    mysql_format(mysql, query, sizeof(query), "SELECT id FROM accounts WHERE name = '%e' LIMIT 1", name);
    result = mysql_query(mysql, query);

    if(!cache_num_rows(result))
        return SendClientMessage(playerid, 0x999999FF, "Игрок не найден в базе."), cache_delete(result);

    new account_id = cache_get_field_content_int(0, "id");
    cache_delete(result);

    new fmt_text[256];
    format(fmt_text, sizeof(fmt_text),
        ""SERVER_NAME" | Привязки игрока %s\n\n\
        VK - Отсутствует\n\
        TG - Отсутствует\n\
        E-MAIL - Отсутствует",
        name
    );

    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "Информация о привязках", fmt_text, "Закрыть", "");

    new adminName[MAX_PLAYER_NAME];
    GetPlayerName(playerid, adminName, sizeof(adminName));
    
    new log_msg[128];
    format(log_msg, sizeof(log_msg), "[A] Администратор %s посмотрел привязки игрока %s", adminName, name);
    SendMessageToAdmins(log_msg, 0x999999FF);

    format(log_msg, sizeof(log_msg), "Посмотрел привязки игрока %s[acc:%d]", name, account_id);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, log_msg);

    return 1;
}
stock vorotafrack()
{
    CreateDynamic3DTextLabel("{e81717}<<\t{ffffff}Шлагбаум Армии\t{e81717}>>", 0xFFFF00FF, 1910.21,1722.28,15.04 + 1.8, 10.0);
    CreateDynamic3DTextLabel("{e81717}<<\t{ffffff}Ворота Армии\t{e81717}>>", 0xFFFF00FF, 1891.1486,1722.2531,14.9780 + 1.8, 10.0);
    openvorotamo = CreateDynamicSphere(1891.1486,1722.2531,15.9780, 5.0);
    openvorotamo1 = CreateDynamicSphere(1910.21,1722.28,16.04, 5.0);
    vorotamo = CreateObject(1717,1891.1486,1721.5555,16.4444, 0, 0, 0);
    vorotamo1 = CreateObject(1718,1910.21,1725.28,15.6666, 0, 0, 0);
}
stock ShowPlayerGUI(playerid, guiid, Node:json)
{
	JSON_SetInt(json, "o", 1);
	OnPacketIncoming(playerid, guiid, json);
}
stock UpdatePlayerGUI(playerid, guiid, Node:json)
{
	OnPacketIncoming(playerid, guiid, json);
}
stock HidePlayerGUI(playerid, guiid) //, Node:json)
{
	new Node:json = JSON_Object();
	JSON_SetInt(json, "c", 1);
	OnPacketIncoming(playerid, guiid, json);
}

stock OnPacketIncoming(playerid, guiid, Node:json)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, PACKET_BLACKRRPC);

	BS_WriteValue(bitstream, PR_UINT16, guiid);

	// Large marketplace/inventory payloads were truncated at 1024 characters,
	// so the mobile client silently rejected the malformed JSON packet.
	static data[8192];
    JSON_Stringify(json, data, sizeof data);

    BS_WriteValue(bitstream, PR_UINT32, strlen(data));
    BS_WriteValue(bitstream, PR_STRING, data);

	PR_SendPacket(bitstream, playerid, PR_HIGH_PRIORITY, PR_RELIABLE);
	BS_Delete(bitstream);
}


