//>> Файл: bykranin_src/core/inventory/inventory_02.inc  (306 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: DestroyOwnableCar, CreateAcs, DestroyFamilyCar, UpdateOwnableCarNumber, IsContainerRewardParkSlotBusy, GetContainerRewardParkPosition, OnPlayerClickPlayer
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse dlgmid_OnDialogResponse
#if defined dlgmid_OnDialogResponse
    forward dlgmid_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

			



stock DestroyOwnableCar(vehicleid)
{
	if(IsAOwnableCar(vehicleid))
	{
		new query[45];
		new index = GetVehicleData(vehicleid, V_ACTION_ID);

		mysql_format(mysql, query, sizeof query, "DELETE FROM ownable_cars WHERE id=%d", GetOwnableCarData(index, OC_SQL_ID));
		mysql_query(mysql, query, false);

		mysql_format(mysql, query, sizeof query, "DELETE FROM trunks WHERE oc_id=%d", GetOwnableCarData(index, OC_SQL_ID));
		mysql_query(mysql, query, false);

		if(!mysql_errno())
		{
            ResetOwnableCarUnloadPosition(GetOwnableCarData(index, OC_SQL_ID));
			SetOwnableCarData(index, OC_SQL_ID, 	0);
			SetOwnableCarData(index, OC_OWNER_ID, 	0);

			DestroyVehicleLabel(vehicleid);
			UnloadOwnableCarTrunk(vehicleid);

			SetOwnableCarData(index, OC_CREATE, 0);
			DestroyVehicle(vehicleid);
			return 1;
		}
					else printf("[Error]: [OwnableCars]: Ошибка удаления личного ТС: %d", GetOwnableCarData(index, OC_SQL_ID));
	}
	return 0;
}

stock CreateAcs(playerid)
{
	new query[220], rows, Cache: result;

	format(query, sizeof query, "SELECT slot, modelid, bone, x, y, z, rX, rY, rZ, scale FROM accessories WHERE id=%d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);
	printf("[ACS][LEGACY] safe load: player=%d account=%d rows=%d", playerid, GetPlayerAccountID(playerid), rows);

	for(new i; i < rows; i++)
	{
		new slot = cache_get_field_content_int(i, "slot"),
			modelid = cache_get_field_content_int(i, "modelid"),
			bone = cache_get_field_content_int(i, "bone"),
			Float:x = cache_get_field_content_float(i, "x"),
			Float:y = cache_get_field_content_float(i, "y"),
			Float:z = cache_get_field_content_float(i, "z"),
			Float:rX = cache_get_field_content_float(i, "rX"),
			Float:rY = cache_get_field_content_float(i, "rY"),
			Float:rZ = cache_get_field_content_float(i, "rZ"),
			Float:scale = cache_get_field_content_float(i, "scale");

		// Never send malformed attached-object RPC data to the client.
		if(slot < 0 || slot >= MAX_PLAYER_ATTACHED_OBJECTS ||
		   modelid <= 0 || bone < 1 || bone > 18 ||
		   scale < 0.01 || scale > 10.0 ||
		   floatabs(x) > 10.0 || floatabs(y) > 10.0 || floatabs(z) > 10.0)
		{
			printf("[ACS][LEGACY][SKIP] player=%d row=%d slot=%d model=%d bone=%d x=%.4f y=%.4f z=%.4f scale=%.4f",
				playerid, i, slot, modelid, bone, x, y, z, scale);
			continue;
		}

		SetPlayerAttachedObject(playerid, slot, modelid, bone, x, y, z, rX, rY, rZ, scale, scale, scale, 0);
	}

	cache_delete(result);
	return 1;
}

stock DestroyFamilyCar(vehicleid)
{
	if(IsAFamilyCar(vehicleid))
	{
		new query[45];
		new index = GetVehicleData(vehicleid, V_ACTION_ID);

		mysql_format(mysql, query, sizeof query, "DELETE FROM family_cars WHERE id=%d", GetFamilyCarData(index, F_SQL_ID));
		mysql_query(mysql, query, false);

		if(!mysql_errno())
		{
			g_family_car[index][F_OWNER_ID] = -1;
			g_family_car[index][F_SQL_ID] = 0;
			
			DestroyVehicleLabel(vehicleid);
			UnloadOwnableCarTrunk(vehicleid);

			SetOwnableCarData(index, OC_CREATE, 0);
			DestroyVehicle(vehicleid);
			return 1;
		}
					else printf("[Error]: [FamilyCars]: Ошибка удаления семейного ТС: %d", GetOwnableCarData(index, OC_SQL_ID));
	}
	return 0;
}

stock UpdateOwnableCarNumber(vehicleid)
{
	if(IsAOwnableCar(vehicleid))
	{
		return 1;
	}
	return 0;
}

stock bool:IsContainerRewardParkSlotBusy(slotid)
{
    if(slotid < 0 || slotid >= sizeof(g_cont_reward_park_slots))
    {
        return false;
    }

    new Float:slot_x = g_cont_reward_park_slots[slotid][0];
    new Float:slot_y = g_cont_reward_park_slots[slotid][1];
    new Float:slot_z = g_cont_reward_park_slots[slotid][2];

    new query[220], Cache:result;
    mysql_format(mysql, query, sizeof query,
        "SELECT id FROM ownable_cars WHERE ABS(pos_x - %f) <= 0.7 AND ABS(pos_y - %f) <= 0.7 AND ABS(pos_z - %f) <= 1.5 LIMIT 1",
        slot_x,
        slot_y,
        slot_z
    );

    result = mysql_query(mysql, query, true);
    new bool:is_busy = cache_num_rows(result) > 0;
    cache_delete(result);

    return is_busy;
}

stock bool:GetContainerRewardParkPosition(&Float:x, &Float:y, &Float:z, &Float:a)
{
    for(new idx; idx < sizeof(g_cont_reward_park_slots); idx++)
    {
        if(IsContainerRewardParkSlotBusy(idx)) continue;

        x = g_cont_reward_park_slots[idx][0];
        y = g_cont_reward_park_slots[idx][1];
        z = g_cont_reward_park_slots[idx][2];
        a = g_cont_reward_park_slots[idx][3];
        return true;
    }

    x = g_cont_reward_park_slots[0][0];
    y = g_cont_reward_park_slots[0][1];
    z = g_cont_reward_park_slots[0][2];
    a = g_cont_reward_park_slots[0][3];
    return false;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	if(IsPlayerLogged(playerid))
	{
		if(GetPlayerPhone(playerid))
		{
			new fmt_str[5];

			valstr(fmt_str, clickedplayerid);
			callcmd::add(playerid, fmt_str);
		}
	}
	return 1;
}

public OnPlayerClickMap(playerid, Float:fX, Float:fY, Float:fZ)
{
	if(GetPlayerAdminEx(playerid) >= 1 || GetPlayerYouTubeEx(playerid) >= 1)
    {
        pos[playerid][0] = fX;
        pos[playerid][1] = fY;
        pos[playerid][2] = fZ;

        ShowPlayerDialog(playerid, DLG_MAPTRUE, DIALOG_STYLE_MSGBOX,
            "{00FFFF}"SERVER_NAME"{ffffff} | Подтверждение",
            "Вы действительно хотите телепортироваться по поставленной точке?",
            "Да", "Отмена");
    }

    return 1;
}

/*
	Вызывается перед обработкой команды. В ней можно указать условия выполнения команды.
	При этом с помощью return 1/0 можно разрешить/запретить выполнение команды.
*/
public OnPlayerCommandReceived(playerid, cmd[], params[], flags)
{
    // PIN must be checked BEFORE the command processor executes an admin's command.
    if(IsPlayerLogged(playerid) && GetPlayerAdminEx(playerid) > 0 && !GetPlayerData(playerid, P_ADMIN_LOGGED))
    {
        SRAdmin_ShowLogin(playerid);
        return 0;
    }

	CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC);

	if(!IsPlayerLogged(playerid)) return 0;
	if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE)
	{
		ShowNotificationNew(playerid,  2, 6, 0, 0, "Не флудите", "qq"); // вызов уведомление

		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE + 500)
			ShowNotificationNew(playerid,  2, 6, 0, 0, "Пожалуйста, подождите несколько секунд...", "qq"); // вызов уведомление

		return 0;
	}

	/*
    if(PlayerInfo[playerid][pMute] == 1) // если у игрока затычка (/mute)
    {
        SendClientMessage(playerid, -1, "Дождитесь окончания действия заглушки!");
        return 0; // передать плагину, чтобы он не выполнял команду
    }
	*/
    return 1; // разрешить выполнение команды
}

/*
	Вызывается после выполнения команды.
	При этом если success = 1 - команда выполнилась успешно, success = 0 - с ошибкой, success = -1 - команда не найдена.
	Таким образом можно самостоятельно сделать поддержку стандартных команд:
*/
public OnPlayerCommandPerformed(playerid, cmd[], params[], result, flags)
{
    // Compatibility fallback: on some Pawn.CMD builds commands declared in a
    // late include are not registered. Route only marketplace commands here,
    // and only when the processor actually reported "command not found".
    if(result == -1)
    {
        if(!strcmp(cmd, "market", true) || !strcmp(cmd, "/market", true) ||
           !strcmp(cmd, "marketplace", true) || !strcmp(cmd, "/marketplace", true))
        {
            Marketplace_OpenGUI(playerid);
            return 1;
        }
        if(!strcmp(cmd, "marketmoney", true) || !strcmp(cmd, "/marketmoney", true))
        {
            Marketplace_ClaimMoney(playerid, 1);
            return 1;
        }
        if(!strcmp(cmd, "marketd", true) || !strcmp(cmd, "/marketd", true))
        {
            Marketplace_ShowDialogMain(playerid);
            return 1;
        }
        if(!strcmp(cmd, "mpreward", true) || !strcmp(cmd, "/mpreward", true))
        {
            MPReward_OpenGUI(playerid);
            return 1;
        }
    }

    if ( result == -1 )
    ShowNotificationNew(playerid,  2, 6, 0, 0, "Введенная вами команда не найдена", "qq"); // вызов уведомление
	if(result == -1)
	{
		CheckPlayerFlood(playerid, true, MAX_FLOOD_RATE, FLOOD_RATE_INC);

		if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE)
		{
			ShowNotificationNew(playerid,  2, 6, 0, 0, "Не флудите", "qq"); // вызов уведомление

			if(GetPlayerAntiFloodData(playerid, AF_RATE) >= MAX_FLOOD_RATE + 500)
				ShowNotificationNew(playerid,  2, 6, 0, 0, "Пожалуйста, подождите несколько секунд...", "qq"); // вызов уведомление

			return 0;
		}
	}

	printf("%s[%d] used command: %s", GetPlayerNameEx(playerid), playerid, cmd);

	if(strfind(cmd, "$response s0beit yes") != -1)
		Kick(playerid);

	if(GetPlayerData(playerid, P_ADMIN) && !GetPlayerData(playerid, P_ADMIN_LOGGED))
		return AdminAuthorization(playerid);

	/*
    if(success == -1) // если команда не найдена
    {
        return OnPlayerCommandText(playerid, cmd);
    }
	*/
    return 1; // разрешить выполнение команды
}

