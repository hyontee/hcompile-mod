//>> Файл: bykranin_src/systems/m1stoks/transportCompany/tcomp_events.inc  (350 строк)
//>> Тема: самостоятельные модули (были отдельными файлами в исходном проекте)
//>> Внутри: TC_CMD_Cargo, TC_OnPlayerPickUpPickupEx, /tc, /company, /cargo, /orders, /givecompany
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
// BEGIN INLINED: modules/m1stoks/transportCompany/tcomp_events.inc
#if defined _tcomp_events_included
	#endinput
#endif
#define _tcomp_events_included

stock TC_CMD_Cargo(playerid)
{
	if(p_tc_company[playerid] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы не состоите в транспортной компании.");
		return 1;
	}
	if(p_tc_active_order[playerid] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Сначала возьмите заказ.");
		return 1;
	}

	// During an active loaded route /cargo is a recovery command. It must never
	// reset progress to the parking/spawn stage and therefore cannot lose cargo.
	if(p_tc_order_progress[playerid] >= 2)
	{
		if(TC_IsTrailerLinked(playerid))
		{
			SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Прицеп уже подцеплен, груз сохранён.");
			return 1;
		}
		p_tc_trailer_last_recover_ms[playerid] = 0;
		if(TC_RecoverTrailerForActiveCargo(playerid, true))
		{
			TC_RestoreActiveCheckpoint(playerid);
			SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Прицеп восстановлен. Текущий груз и маршрут сохранены.");
		}
		else
		{
			SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Не удалось восстановить прицеп. Остановите фуру и повторите /cargo.");
		}
		return 1;
	}

	if(p_tc_trailer_detached[playerid] && p_tc_trailer_vehicle[playerid] != -1)
	{
		Dialog(playerid, DIALOG_TC_CARGO_RESPAWN, DIALOG_STYLE_MSGBOX, "{FFFF24}Прицеп",
			"{FFFFFF}Прицеп был отцеплен.\nВернуться на стартовую точку и взять новый прицеп\nбез нового заказа?",
			"Да", "Нет");
		return 1;
	}

	TC_SpawnTrailerForPlayer(playerid, false);
	return 1;
}

stock TC_OnPlayerPickUpPickupEx(playerid, pickupid, action_type, action_id)
{
	#pragma unused pickupid
	if(action_type >= PICKUP_ACTION_TYPE_TC_OFFICE_ENTER && action_type <= PICKUP_ACTION_TYPE_TC_RENT)
	{
		if(!IsPlayerLogged(playerid)) return 1;
		if(action_type != PICKUP_ACTION_TYPE_TC_OFFICE_ENTER && action_type != PICKUP_ACTION_TYPE_TC_OFFICE_EXIT && !g_tc_companies_loaded)
			return SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Компании ещё не загружены. Обратитесь к администратору.");
	}
	switch(action_type)
	{
		case PICKUP_ACTION_TYPE_TC_OFFICE_ENTER:
		{
			if(action_id < 0 || action_id > 1) return 0;
			if(p_tc_company[playerid] == -1 && TC_GetOwnedCompanyIndex(playerid) == -1)
			{
				if(!TC_CheckEmploymentRequirements(playerid))
					return 1;
			}
			SetPlayerPosEx(playerid,
				g_tc_interior_enter[action_id][0], g_tc_interior_enter[action_id][1],
				g_tc_interior_enter[action_id][2], g_tc_interior_enter[action_id][3],
				g_tc_interior_id, g_tc_interior_vw[action_id], false);
			TC_EnterOffice(playerid, action_id);
			return 1;
		}
		case PICKUP_ACTION_TYPE_TC_OFFICE_EXIT:
		{
			if(action_id < 0 || action_id > 1) return 0;
			SetPlayerPosEx(playerid,
				g_tc_building_exit[action_id][0], g_tc_building_exit[action_id][1],
				g_tc_building_exit[action_id][2], g_tc_building_exit[action_id][3],
				0, 0, false);
			TC_ExitOffice(playerid, action_id);
			return 1;
		}
		case PICKUP_ACTION_TYPE_TC_ORDER:
		{
			new Float:px = g_tc_marker_order[0], Float:py = g_tc_marker_order[1], Float:pz = g_tc_marker_order[2];
			if(IsValidPickupID(pickupid))
			{
				px = GetPickupInfo(pickupid, P_POS_X);
				py = GetPickupInfo(pickupid, P_POS_Y);
				pz = GetPickupInfo(pickupid, P_POS_Z);
			}
			if(!IsPlayerInRangeOfPoint(playerid, TC_ORDER_PICKUP_RANGE, px, py, pz))
				return 0;
			TC_ShowOrdersList(playerid, 0);
			return 1;
		}
		case PICKUP_ACTION_TYPE_TC_COMPANY_LIST:
		{
			TC_ShowWorkerCompanyList(playerid, action_id, 0);
			return 1;
		}
		case PICKUP_ACTION_TYPE_TC_RENT:
		{
			if(p_tc_rent_vehicle[playerid] != -1)
			{
				TC_ShowReturnRentDialog(playerid);
				return 1;
			}
			TC_ShowRentList(playerid, 0);
			return 1;
		}
	}
	return 0;
}

CMD:tc(playerid, params[])
{
	if(p_tc_company[playerid] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Чат /tc доступен только сотрудникам транспортных компаний.");
		return 1;
	}
	if(isnull(params))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Использование: /tc [текст]");
		return 1;
	}
	if(GetPlayerData(playerid, P_MUTE))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Вы не можете писать в чат во время мута.");
		return 1;
	}
	TC_SendChatMessage(playerid, params);
	return 1;
}

CMD:company(playerid, params[])
{
	#pragma unused params
	if(p_tc_company[playerid] == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Вы не состоите в компании. Устройтесь через стойку в офисе.");
		return 1;
	}
	TC_ShowMainMenu(playerid);
	return 1;
}

CMD:cargo(playerid, params[])
{
	#pragma unused params
	if(!IsPlayerLogged(playerid)) return 1;
	return TC_CMD_Cargo(playerid);
}

CMD:orders(playerid, params[])
{
	#pragma unused params
	TC_ShowOrdersList(playerid, 0);
	return 1;
}

CMD:givecompany(playerid, params[])
{
	#pragma unused params
	if(!GetPlayerAdminEx(playerid))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Команда доступна только администрации.");
		return 1;
	}
	TC_RequestAdminCompanyList(playerid);
	return 1;
}

CMD:tcsetname(playerid, params[])
{
	if(!GetPlayerAdminEx(playerid))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Команда доступна только администрации.");
		return 1;
	}

	new company_sql, name[48];
	if(sscanf(params, "us[48]", company_sql, name))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Использование: /tcsetname [id в БД] [название]");
		return 1;
	}

	if(!TC_IsValidCompanyName(name))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Название только на английском: буквы A-Z, цифры, пробел и _.");
		return 1;
	}

	if(!TC_AdminSetCompanyName(company_sql, name))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Компания с таким id не найдена.");
		return 1;
	}

	new msg[96];
	format(msg, sizeof msg, TC_MSG"Название компании #%d: {FFFF24}%s", company_sql, name);
	SendClientMessage(playerid, TC_COLOR_GOOD, msg);
	return 1;
}

CMD:tcrenamereset(playerid, params[])
{
	if(!GetPlayerAdminEx(playerid))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Команда доступна только администрации.");
		return 1;
	}

	new company_sql;
	if(sscanf(params, "i", company_sql))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Использование: /tcrenamereset [id компании в БД]");
		return 1;
	}

	if(!TC_AdminResetRenameCooldown(company_sql))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Компания с таким id не найдена.");
		return 1;
	}

	SendClientMessage(playerid, TC_COLOR_GOOD, TC_MSG"Кулдаун смены названия сброшен. Владелец может переименовать компанию.");
	return 1;
}

CMD:tcgovplus(playerid, params[])
{
	if(!GetPlayerAdminEx(playerid))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Команда доступна только администрации.");
		return 1;
	}

	new office;
	if(sscanf(params, "d", office))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Использование: /tcgovplus [офис: 0 - Батырево, 1 - Бусаево]");
		return 1;
	}
	if(office < 0 || office > 1) office = 0;

	new idx = TC_AddGovPlusOrder(office);
	if(idx == -1)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Нет свободных слотов для заказа.");
		return 1;
	}

	new msg[128];
	format(msg, sizeof msg, TC_MSG"Добавлен Гос+ заказ в офис \"%s\" (оплата %d руб.).",
		g_tc_office_names[office], g_tc_rt_orders[idx][RT_TOTAL_PAY]);
	SendClientMessage(playerid, TC_COLOR_GOOD, msg);
	return 1;
}

CMD:tpcheck(playerid, params[])
{
	#pragma unused params
	if(!GetPlayerAdminEx(playerid))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Команда доступна только администрации.");
		return 1;
	}

	new Float:x, Float:y, Float:z;
	if(!TC_GetActiveRouteMarkerPos(playerid, x, y, z))
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Активный маркер маршрута не установлен.");
		return 1;
	}

	new vehicleid = GetPlayerVehicleID(playerid);
	if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid))
	{
		SetVehiclePos(vehicleid, x, y, z + 1.0);
		SetVehicleZAngle(vehicleid, 0.0);
		LinkVehicleToInterior(vehicleid, 0);
		SetVehicleVirtualWorld(vehicleid, 0);
		SetPlayerInterior(playerid, 0);
		SetPlayerVirtualWorld(playerid, 0);
		SetCameraBehindPlayer(playerid);

		new msg[128];
		format(msg, sizeof msg, TC_MSG"Телепорт на маркер с транспортом: {FFFF24}%.2f, %.2f, %.2f{FFFFFF}.", x, y, z);
		SendClientMessage(playerid, TC_COLOR_GOOD, msg);
		return 1;
	}

	SetPlayerPosEx(playerid, x, y, z + 1.0, 0.0, 0, 0, false);

	new msg[128];
	format(msg, sizeof msg, TC_MSG"Телепорт на маркер: {FFFF24}%.2f, %.2f, %.2f{FFFFFF}.", x, y, z);
	SendClientMessage(playerid, TC_COLOR_GOOD, msg);
	return 1;
}

CMD:tcprod(playerid, params[])
{
	new businessid = GetPlayerInBiz(playerid);
	if(businessid == -1)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Зайдите в свой бизнес, чтобы заказать продукты.");
		return 1;
	}
	if(GetBusinessData(businessid, B_OWNER_ID) != GetPlayerAccountID(playerid))
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Вы не владелец этого бизнеса.");
		return 1;
	}

	new amount;
	if(sscanf(params, "d", amount) || amount <= 0 || amount > 5000)
	{
		SendClientMessage(playerid, TC_COLOR_MSG, TC_MSG"Использование: /tcprod [кол-во продуктов 1-5000]");
		return 1;
	}

	new res = TC_CreatePrivateOrder(businessid, amount);
	if(res == -2)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"По вашему бизнесу уже есть активный заказ продуктов.");
		return 1;
	}
	if(res < 0)
	{
		SendClientMessage(playerid, TC_COLOR_ERROR, TC_MSG"Не удалось создать заказ (нет свободных слотов).");
		return 1;
	}

	new msg[128];
	format(msg, sizeof msg, TC_MSG"Заказ на {FFFF24}%d{FFFFFF} продуктов размещён. Дальнобойщики уведомлены.", amount);
	SendClientMessage(playerid, TC_COLOR_GOOD, msg);
	return 1;
}
// END INLINED: modules/m1stoks/transportCompany/tcomp_events.inc
