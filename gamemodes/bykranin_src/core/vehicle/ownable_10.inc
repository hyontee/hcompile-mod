//>> Файл: bykranin_src/core/vehicle/ownable_10.inc  (1381 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: /exit, /lift, /lockdd, /keydd, /getmycardd, /sellcar, /sellmycar
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
CMD:exit(playerid, params[])
{
	if(GetPlayerInHouse(playerid) != -1)
	{
		new houseid = GetPlayerInHouse(playerid);
		if(GetHouseData(houseid, H_IMPROVEMENTS) > 5)
		{
			Dialog
			(
				playerid, DIALOG_ACTION_EXIT_HOUSE, DIALOG_STYLE_LIST,
				"{FFCC00}Выход",
				"1. Улица\n\
				2. Гараж",
				"Далее", "Закрыть"
			);
		}
					else
			ExitPlayerFromHouse(playerid, 3.0);
	}
					else if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) != -1)
	{
		ExitPlayerFromHotelRoom(playerid);
	}
					else if(GetPlayerInBiz(playerid) != -1)
    {
        new in_biz = GetPlayerInBiz(playerid);
        if(GetBusinessData(in_biz, B_TYPE) == BUSINESS_TYPE_CASINO)
        {
            new interior_id = GetBusinessData(in_biz, B_INTERIOR);
            if(!IsPlayerInRangeOfPoint(playerid, 3.0,
                GetBusinessInteriorInfo(interior_id, BT_EXIT_POS_X),
                GetBusinessInteriorInfo(interior_id, BT_EXIT_POS_Y),
                GetBusinessInteriorInfo(interior_id, BT_EXIT_POS_Z)))
            {
                return SendClientMessage(playerid, 0xCECECEFF, "Подойдите к пикапу выхода, чтобы выйти");
            }

            if(pInfo[playerid][CasinoDiceUiOpen])
            {
                HideCasinoDiceUi(playerid);
            }

            SetPlayerPosEx
            (
                playerid,
                1333.572998,
                2367.979980,
                17.712001,
                174.427230,
                0,
                0
            );
            SetPlayerInBiz(playerid, -1);
        }
    }
					else if(!GetPlayerInterior(playerid))
	{
		SendClientMessage(playerid, 0xCECECEFF, "Вы не в помещении");
	}

	return 1;
}

CMD:lift(playerid, params[])
{
	new entranceid = GetPlayerInEntrance(playerid);
	if(entranceid != -1)
	{
		new floor = GetPlayerInEntranceFloor(playerid);
		if(floor != -1)
		{
			if(!floor)
			{
				if(!IsPlayerInRangeOfPoint(playerid, 1.5, 30.5405, 1403.6593, 1508.4163))
					return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться около лифта");
			}
					else
			{
				if(!IsPlayerInRangeOfPoint(playerid, 1.5, 11.1776, 1377.5216, 1508.4163))
					return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться около лифта");
			}
			ShowPlayerEntranceFloorsLift(playerid, entranceid, floor);
		}
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы не в подъезде");

	return 1;
}
alias:locdk("lkd")
/*CMD:lockdd(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "Используйте: /lock [тип] (1-Личный транспорт 2-Арендованная машина 3-Рабочий транспорт 4-Доверенный транспорт)");

	new type;

	new Float: radius = 20.0;
	new vehicleid = INVALID_VEHICLE_ID;

	switch(type)
	{
		case 1:
		{
			vehicleid = GetPlayerOwnableCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
			{
				if(GetPlayerOwnableCars(playerid) == 0)
					return SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
				else
					return SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
			}
		}
		case 2:
		{
			vehicleid = GetPlayerRentCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "У Вас нет арендованной машины");
		}
		case 3:
		{
			vehicleid = GetPlayerJobCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "Вы не можете использовать эту функцию");
		}
		case 4:
		{
			vehicleid = GetPlayerAllowedCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "У Вас нет доверенного транспорта");
		}
		default:
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /lock [тип] (1-Личный транспорт 2-Арендованная машина 3-Рабочий транспорт 4-Доверенный транспорт)");
	}

	new Float: x, Float: y, Float: z;
	GetVehiclePos(vehicleid, x, y, z);

	if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z))
	{
		new status = GetVehicleParam(vehicleid, V_LOCK);
		if(status)
		{
			if(type == 1)
			{
				Action(playerid, "открыл(-a) личный транспорт", _, true);
			}
			GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~ЏPAмCЊOPЏ~g~ OЏKP‘Џ", 3000, 3);
		}
					else
		{
			if(type == 1)
			{
				Action(playerid, "закрыл(-a) личный транспорт", _, true);
			}
			GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~ЏPAмCЊOPЏ~r~ €AKP‘Џ", 3000, 3);
		}
		SetVehicleParam(vehicleid, V_LOCK, status ^ VEHICLE_PARAM_ON);
	}
					else SendClientMessage(playerid, 0x999999FF, "Вы должны стоять рядом с транспортом");

	return 1;
}*/
CMD:lockdd(playerid, params[])
{
    if(GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID)
    {
        if(GetPlayerOwnableCars(playerid) == 0)
        return SendClientMessage(playerid, 0x999999FF, ""USC"У Вас нет личного транспорта");
        else
        return SendClientMessage(playerid, 0x999999FF, ""USC"Ваш личный транспорт не загружен на сервер");
    }
    new Float: x, Float: y, Float: z;
    GetVehiclePos(GetPlayerOwnableCar(playerid), x, y, z);

    if(IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
    {
        ToggleLock(playerid, GetPlayerOwnableCar(playerid));
    }
					else SendClientMessage(playerid, 0x999999FF, ""USC"Вы должны стоять рядом с транспортом");
    return true;
}

CMD:keydd(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID || GetPlayerAllowedCar(playerid) != INVALID_VEHICLE_ID)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			
				if(vehicleid == GetPlayerOwnableCar(playerid) || vehicleid == GetPlayerAllowedCar(playerid))
				{
					new index = GetVehicleData(vehicleid, V_ACTION_ID);
					new bool: status = GetOwnableCarData(index, OC_KEY_IN);

					if(status)
					{
						if(GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON)
						{
							SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
						}
						// removed ignition key chat action
					}
                    // Chat action suppressed by request.

					SetOwnableCarData(index, OC_KEY_IN, status ^ true);
				//	SpeedometrKeyStatusInit(playerid, vehicleid);
				}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в личном/доверенном транспорте");
			
		}
					else
		{
			if(GetPlayerOwnableCars(playerid) == 0)
				SendClientMessage(playerid, 0x999999FF, "У Вас нет личного/доверенного транспорта");
			else
				SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
		}
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");

	return 1;
}

CMD:getmycardd(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCar(playerid);
                    if(vehicleid != INVALID_VEHICLE_ID && !IsValidVehicle(vehicleid))
                    {
                        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не найден на сервере, откройте /car заново");
                    }
                    if(vehicleid != INVALID_VEHICLE_ID)
                    {
		new price = 150;
		new i_have_home = (GetPlayerHouse(playerid, HOUSE_TYPE_HOME) != -1 || GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) != -1);

		if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
		{
			if(GetPlayerMoneyEx(playerid) >= price || i_have_home)
			{
				if(!i_have_home)
					GivePlayerMoneyEx(playerid, -price, "Метка ТС на GPS", true, true);

				new Float: x, Float: y, Float: z;
				GetVehiclePos(vehicleid, x, y, z);

				EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение Вашего транспорта отмечено на GPS");
				return 1;
			}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
		}
					else SendClientMessage(playerid, 0xCECECEFF, "На Вашем GPS уже отмечено место");
	}
					else
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
		else
			SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
	}

	return 0;
}

/*CMD:sellfcar(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

	if(g_family_car[action_id][F_OWNER_ID] != GetPlayerData(playerid, P_FAMILY) + 1)
	{
		if(GetPlayerData(playerid, P_FAMILY_RANK) != 10)
			return SendClientMessage(playerid, 0x999999FF, "Вы не лидер семьи");

		new model_id = GetVehicleData(vehicleid, V_MODELID);
		if(model_id)
		{
			new fmt_str[256];

			new price = GetVehicleInfo(model_id-400, VI_PRICE);
			new percent = price * 20 / 100;

			format
			(
				fmt_str, sizeof fmt_str,
				"{FFFFFF}Модель:\t%s (№%d)\n"\
				"Стоимость:\t%d руб\n\n"\
				"Вы уверены что хотите продать транспорт?\n"\
				"На Ваш банковский счет семьи будет начислено %d руб",
				GetVehicleName(vehicleid),
				model_id,
				price,
				price - percent
			);
			Dialog(playerid, DIALOG_FAMILY_CAR_SELL, DIALOG_STYLE_MSGBOX, "{FFCD00}Продажа семейного транспорта", fmt_str, "Да", "Нет");
		}
	}
					else
	{
		SendClientMessage(playerid, 0x999999FF, "Это не транспорт вашей семьи.");
	}

	return 1;
}*/

CMD:sellcar(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCar(playerid);

	if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
	{
		if(vehicleid != INVALID_VEHICLE_ID)
			SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

		if(GetPlayerOwnableCars(playerid) == 0)
			ShowNotificationNew(playerid, 2, 3, 0, 0, "У Вас нет личного транспорта", "");
		else
			ShowNotificationNew(playerid, 2, 3, 0, 0, "Ваш личный транспорт не загружен на сервере", "");

		return 1;
	}

	new model_id = GetVehicleData(vehicleid, V_MODELID);
	if(model_id)
	{
		new fmt_str[999];
		new model_name[32];

		new price = GetSellCarPriceByModel(model_id);
		new tax = price * 20 / 100;
		new sell_price = price - tax;

		GetVehicleModelName(model_id, model_name, sizeof model_name);

		format
		(
			fmt_str, sizeof fmt_str,
			""SC"Транспортное средство:\t{ffff00}%s (№%d)\n"\
			""SC"Стоимость продажи:\t{ffff00}%d\n\n"\
			"{FFFFFF}Вы можете продать свое транспортное средство другим\n"\
			"игрокам с помощью команды: {ffff00}\"/sellmycar\".\n\n"\
			"{FFFFFF}Вы уверены, что хотите моментально продать свое\n"\
			"транспортное средство?",
			model_name,
			model_id,
			sell_price
		);
		Dialog(playerid, DIALOG_OWNABLE_CAR_SELL, DIALOG_STYLE_MSGBOX, "{00FFFF}"SERVER_NAME" -> {ffffff}Продажа транспорта", fmt_str, "Да", "Отмена");
	}

	return 1;
}

CMD:sellmycar(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCar(playerid);
                    if(vehicleid != INVALID_VEHICLE_ID && !IsValidVehicle(vehicleid))
                    {
                        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не найден на сервере, откройте /car заново");
                    }
                    if(vehicleid != INVALID_VEHICLE_ID)
                    {
		if(!strlen(params))
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /sellmycar [id игрока] [стоимость]");

		extract params -> new to_player, price;

		new model_id = GetVehicleData(vehicleid, V_MODELID);
		if(model_id)
		{
			new car_price = GetVehicleInfo(model_id-400, VI_PRICE);

			if(!IsPlayerConnected(to_player) || to_player == playerid)
				return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

			if((GetPlayerOwnableCars(to_player) + 1) > GetPlayerCarSlots(to_player))
				return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока нет свободных слотов для транспорта");

			if(GetPlayerOwnableCar(to_player) != INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0xCECECEFF, "Этот игрок должен выгрузить его личный транспорт с сервера {888888}(/car > 7)");

			if(!(3000 <= price <= (car_price * 2)))
				return SendClientMessage(playerid, 0xCECECEFF, "Стоимость должа быть от 3000 рублей и не дороже в 2 раза гос. стоимости ТС");

			if(GetPlayerMoneyEx(to_player) < price)
				return SendClientMessage(playerid, 0xCECECEFF, "У этого игрока нет такой суммы");

			new  Float: car_x, Float: car_y, Float: car_z;
			GetVehiclePos(vehicleid, car_x, car_y, car_z);

			if(IsPlayerInRangeOfPoint(playerid, 15.0, car_x, car_y, car_z) && IsPlayerInRangeOfPoint(to_player, 15.0, car_x, car_y, car_z))
			{
				SendPlayerOffer(playerid, to_player, OFFER_TYPE_SELL_OWNABLE_CAR, price, vehicleid);
			}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы и покупатель должны находиться около ТС");
		}
	}
					else
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
		else
			SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
	}

	return 1;
}

alias:lock("lk")
/*CMD:lock(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0x999999FF, "Используйте: /lock [тип] (1-Личный транспорт 2-Арендованная машина 3-Рабочий транспорт 4-Доверенный транспорт)");

	new type;

	new Float: radius = 20.0;
	new vehicleid = INVALID_VEHICLE_ID;

	switch(type)
	{
		case 1:
		{
			vehicleid = GetPlayerOwnableCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
			{
				if(GetPlayerOwnableCars(playerid) == 0)
					return SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
				else
					return SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
			}
		}
		case 2:
		{
			vehicleid = GetPlayerRentCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "У Вас нет арендованной машины");
		}
		case 3:
		{
			vehicleid = GetPlayerJobCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "Вы не можете использовать эту функцию");
		}
		case 4:
		{
			vehicleid = GetPlayerAllowedCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
				return SendClientMessage(playerid, 0x999999FF, "У Вас нет доверенного транспорта");
		}
		default:
			return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /lock [тип] (1-Личный транспорт 2-Арендованная машина 3-Рабочий транспорт 4-Доверенный транспорт)");
	}

	new Float: x, Float: y, Float: z;
	GetVehiclePos(vehicleid, x, y, z);

	if(IsPlayerInRangeOfPoint(playerid, radius, x, y, z))
	{
		new status = GetVehicleParam(vehicleid, V_LOCK);
		if(status)
		{
			if(type == 1)
			{
				Action(playerid, "открыл(-a) личный транспорт", _, true);
			}
			GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~ЏPAмCЊOPЏ~g~ OЏKP‘Џ", 3000, 3);
		}
					else
		{
			if(type == 1)
			{
				Action(playerid, "закрыл(-a) личный транспорт", _, true);
			}
			GameTextForPlayer(playerid,"~w~~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~ЏPAмCЊOPЏ~r~ €AKP‘Џ", 3000, 3);
		}
		SetVehicleParam(vehicleid, V_LOCK, status ^ VEHICLE_PARAM_ON);
	}
					else SendClientMessage(playerid, 0x999999FF, "Вы должны стоять рядом с транспортом");

	return 1;
}*/
CMD:lock(playerid, params[])
{
    new vehicleid = INVALID_VEHICLE_ID;

    if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
    {
        new Float:x, Float:y, Float:z;
        GetVehiclePos(GetPlayerOwnableCar(playerid), x, y, z);

        if(IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
        {
            vehicleid = GetPlayerOwnableCar(playerid);
        }
    }

    if(vehicleid == INVALID_VEHICLE_ID)
    {
        vehicleid = GetNearestVehicleID(playerid, 10.0);

        if(vehicleid != INVALID_VEHICLE_ID && IsValidVehicle(vehicleid) && GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_FAMILY_CAR)
        {
            new family_car_id = GetVehicleData(vehicleid, V_ACTION_ID);

            if(GetPlayerIdFamily(playerid) == -1 || GetPlayerIdFamily(playerid) != GetCarFamily(family_car_id, OW_F_server))
                return SendClientMessage(playerid, -1, ""c_f_r"Это семейная машина не вашей семьи.");

            if(GetPlayerRangFamily(playerid) < GetCarFamily(family_car_id, V_F_RANG))
                return SendClientMessage(playerid, -1, ""c_f_r"Ваш ранг меньше доступного ранга для этого транспорта.");
        }
        else
        {
            vehicleid = INVALID_VEHICLE_ID;
        }
    }

    if(vehicleid == INVALID_VEHICLE_ID)
    {
        if(GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID && GetPlayerOwnableCars(playerid) == 0 && GetPlayerIdFamily(playerid) == -1)
            return SendClientMessage(playerid, 0x999999FF, ""USC"У Вас нет личного транспорта и семьи");

        return SendClientMessage(playerid, 0x999999FF, ""USC"Вы должны стоять рядом с личным или семейным транспортом");
    }

    ToggleLock(playerid, vehicleid);
    return true;
}
stock lockkkk(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);

    if(vehicleid == INVALID_VEHICLE_ID)
    {
        if(GetPlayerOwnableCars(playerid) == 0)
            return SendClientMessage(playerid, 0x999999FF, ""USC"У Вас нет личного транспорта");
        else
            return SendClientMessage(playerid, 0x999999FF, ""USC"Ваш личный транспорт не загружен на сервер");
    }

    if(vehicleid == 0) return 1; // защита от вылета

    new Float:x, Float:y, Float:z;
    GetVehiclePos(vehicleid, x, y, z);

    if(!IsPlayerInRangeOfPoint(playerid, 10.0, x, y, z))
        return SendClientMessage(playerid, 0x999999FF, ""USC"Вы должны стоять рядом с транспортом");

    ToggleLock(playerid, vehicleid);
    return 1;
}

CMD:key(playerid, params[])
{
	if(IsPlayerInAnyVehicle(playerid))
	{
		if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID || GetPlayerAllowedCar(playerid) != INVALID_VEHICLE_ID)
		{
			new vehicleid = GetPlayerVehicleID(playerid);
			
				if(vehicleid == GetPlayerOwnableCar(playerid) || vehicleid == GetPlayerAllowedCar(playerid))
				{
					new index = GetVehicleData(vehicleid, V_ACTION_ID);
					new bool: status = GetOwnableCarData(index, OC_KEY_IN);

					if(status)
					{
						if(GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON)
						{
							SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
						}
						// removed ignition key chat action
					}
                    // Chat action suppressed by request.

					SetOwnableCarData(index, OC_KEY_IN, status ^ true);
				//	SpeedometrKeyStatusInit(playerid, vehicleid);
				}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в личном/доверенном транспорте");
			
		}
					else
		{
			if(GetPlayerOwnableCars(playerid) == 0)
				SendClientMessage(playerid, 0x999999FF, "У Вас нет личного/доверенного транспорта");
			else
				SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
		}
	}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");

	return 1;
}
stock keyssss(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");

    new ownCar = GetPlayerOwnableCar(playerid);
    new allowCar = GetPlayerAllowedCar(playerid);

    if(ownCar == INVALID_VEHICLE_ID && allowCar == INVALID_VEHICLE_ID)
    {
        if(GetPlayerOwnableCars(playerid) == 0)
            return SendClientMessage(playerid, 0x999999FF, "У Вас нет личного/доверенного транспорта");
        else
            return SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
    }

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == 0)
        return 1;

    if(vehicleid != ownCar && vehicleid != allowCar)
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в личном/доверенном транспорте");

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 1; // защита от краша

    new bool:status = GetOwnableCarData(index, OC_KEY_IN);

    if(status)
    {
        if(GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON)
            SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);

        // Chat action suppressed by request.
    }
					else
    {
        // Chat action suppressed by request.
    }

    SetOwnableCarData(index, OC_KEY_IN, !status);
    //SpeedometrKeyStatusInit(playerid, vehicleid);

    return 1;
}

CMD:getmycar(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCar(playerid);
                    if(vehicleid != INVALID_VEHICLE_ID && !IsValidVehicle(vehicleid))
                    {
                        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
                        return SendClientMessage(playerid, 0xCECECEFF, "Транспорт не найден на сервере, откройте /car заново");
                    }
                    if(vehicleid != INVALID_VEHICLE_ID)
                    {
		new price = 150;
		new i_have_home = (GetPlayerHouse(playerid, HOUSE_TYPE_HOME) != -1 || GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) != -1);

		if(GetPlayerGPSInfo(playerid, G_ENABLED) == GPS_STATUS_OFF)
		{
			if(GetPlayerMoneyEx(playerid) >= price || i_have_home)
			{
				if(!i_have_home)
					GivePlayerMoneyEx(playerid, -price, "Метка ТС на GPS", true, true);

				new Float: x, Float: y, Float: z;
				GetVehiclePos(vehicleid, x, y, z);

				EnablePlayerGPS(playerid, 55, x, y, z, "Местоположение Вашего транспорта отмечено на GPS");
				return 1;
			}
					else SendClientMessage(playerid, 0x999999FF, "Недостаточно денег");
		}
					else SendClientMessage(playerid, 0xCECECEFF, "На Вашем GPS уже отмечено место");
	}
					else
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
		else
			SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
	}

	return 0;
}

stock ShowOwnableCarLoadDialog(playerid, id, bool: show_menu = false, bool: rent_car = false)
{
    SetPVarInt(playerid, "ownablecar_id", id);

    if(show_menu)
        SetPVarInt(playerid, "show_menu", 1);

    if(rent_car)
    {
        SetPVarInt(playerid, "rent_true", 1);

        new Cache:result, price, price_auto, query[64], model_id;
        mysql_format(mysql, query, sizeof query, "SELECT model_id FROM ownable_cars WHERE id='%d'", id);
        result = mysql_query(mysql, query, true);
        model_id = cache_get_row_int(0, 0);
        cache_delete(result);

        if(model_id < 400 || model_id > 611)
            price_auto = 0;
        else
        {
            price = GetVehicleInfo(model_id - 400, VI_PRICE);
            price_auto = price * 1 / 100;
        }

        SetPVarInt(playerid, "price_rent", price_auto);
    }
					else
    {
        DeletePVar(playerid, "rent_true");
                DeletePVar(playerid, "rent_zone_id");
        DeletePVar(playerid, "price_rent");
    }

    new w_str[256];

    if(rent_car)
    {
        format(w_str, sizeof w_str,
            "{FFFFFF}1. Отметить транспорт на GPS ({E0584B}300 рублей{FFFFFF})\n\
{FFFFFF}2. Загрузить транспорт на этой парковке");
    }
					else
    {
        format(w_str, sizeof w_str,
            "{FFFFFF}1. Отметить транспорт на GPS ({E0584B}300 руб{FFFFFF})\n\
{FFFFFF}2. Загрузить транспорт на месте {E0584B}выгрузки{FFFFFF}\n\
{FFFFFF}3. Загрузить транспорт на месте {E0584B}парковки{FFFFFF}\n\
{FFFFFF}4. Сбросить парковку автомобиля");
    }

    Dialog(playerid, DIALOG_OWNABLE_CAR_LOAD, DIALOG_STYLE_LIST,
        "{FFCD00}Система управления транспортом",
        w_str,
        "Выбрать", "Закрыть");
}

CMD:allow(playerid, params[])
{
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid == INVALID_VEHICLE_ID)
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			return SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
		else
			return SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
	}

	extract params -> new to_player; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /allow [id игрока]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player) || to_player == playerid)
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	new fmt_text[71];

	if(GetPlayerAllowedCar(to_player) == vehicleid)
	{
		format(fmt_text, sizeof fmt_text, "Вы забрали у %s ключи от Вашего личного транспорта", GetPlayerNameEx(to_player));
		SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

		format(fmt_text, sizeof fmt_text, "%s забрал у Вас ключи от своего личного транспорта", GetPlayerNameEx(playerid));
		SendClientMessage(to_player, 0xFF5533FF, fmt_text);

		SetPlayerData(to_player, P_ALLOWED_CAR, INVALID_VEHICLE_ID);
	}
					else
	{
		if(!IsPlayerInRangeOfPlayer(playerid, to_player, 10.0)) return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");

		SendPlayerOffer(playerid, to_player, OFFER_TYPE_GIVE_CAR_KEY);
	}

	return 1;
}

CMD:park(playerid, params[])
{
	if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");

	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid == INVALID_VEHICLE_ID)
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			return SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
		else
			return SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
	}


	new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;

	if(green_zone_id != -1)
	{
		if(!g_green_zones[green_zone_id][GZ_ALLOW_PARK])
		{
			new fmt_text[144];

			format(fmt_text, sizeof fmt_text, "{FFFF00}{FFFFFF} На этой территории парковка личного транспорта запрещена. Выберите другое место для парковки");
			SendClientMessage(playerid, 0xFFFF00FF, fmt_text);

			return 1;
		}
	}

	new index = GetVehicleData(vehicleid, V_ACTION_ID);

	GetVehiclePos(vehicleid, GetOwnableCarData(index, OC_POS_X), GetOwnableCarData(index, OC_POS_Y), GetOwnableCarData(index, OC_POS_Z));
	GetVehicleZAngle(vehicleid, GetOwnableCarData(index, OC_ANGLE));

	SaveOwnableCar(vehicleid);
	ShowNotificationNew(playerid, 3, 5, 0, 0, "Транспорт припаркован", " ");
    return 1;
}

stock parksss(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");

    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        if(GetPlayerOwnableCars(playerid) == 0)
            return SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
        else
            return SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
    }

    if(vehicleid == 0) return 1; // защита от вылета

    // Проверка green zone
    new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;
    if(green_zone_id >= 0)
    {
        if(!g_green_zones[green_zone_id][GZ_ALLOW_PARK])
        {
            new fmt_text[144];
            format(fmt_text, sizeof fmt_text,
                "{FFFF00}{FFFFFF} На этой территории парковка личного транспорта запрещена. Выберите другое место для парковки");


            SendClientMessage(playerid, 0xFFFF00FF, fmt_text);
            return 1;
        }
    }

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 1; // защита от краша

    new Float:x, Float:y, Float:z, Float:a;

    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, a);

    SetOwnableCarData(index, OC_POS_X, x);
    SetOwnableCarData(index, OC_POS_Y, y);
    SetOwnableCarData(index, OC_POS_Z, z);
    SetOwnableCarData(index, OC_ANGLE, a);

    SaveOwnableCar(vehicleid);

    ShowNotificationNew(playerid, 3, 5, 0, 0, "Транспорт припаркован", " ");
    return 1;
}
stock carssssc(playerid)
{
    new ownableCar = GetPlayerOwnableCar(playerid);

    if(ownableCar != INVALID_VEHICLE_ID && !IsValidVehicle(ownableCar))
    {
        SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);
        ownableCar = INVALID_VEHICLE_ID;
    }

    if(ownableCar != INVALID_VEHICLE_ID)
    {
        Dialog(playerid, DIALOG_OWNABLE_CAR, DIALOG_STYLE_LIST,
            "{FFCD00}Система управления транспортом",
            // header removed
            "{FFFFFF}1.\t{669900}Открыть {FFFFFF}или {FF3300}закрыть {FFFFFF}транспорт\n"\
            "{FFFFFF}2.\tОтметить транспорт на GPS {FF6600}(300 руб)\n"\
            "{FFFFFF}3.\tСодержимое багажника\n"\
            "{FFFFFF}4.\tДокументы на транспорт\n"\
            "{FFFFFF}5.\tСнять номерные знаки\n"\
            "{FFFFFF}6.\tПрипарковать транспорт\n"\
            "{888888}7.\tВыгрузить транспорт с сервера\n"\
            "{FFFFFF}8.\tУстановить сабвуфер в авто\n"\
            "{FFFFFF}9.\tСнять сабвуфер с авто\n"\
            "{FFFFFF}10.\tДобавить авто в семью\n"\
            "{FFFFFF}11.\tНастройки автомобиля",
            "Выбрать", "Закрыть"
        );
        return 1;
    }

    new fmt_text[1024];
    new Cache:result;
    new rows;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM ownable_cars WHERE owner_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);
    rows = cache_num_rows(result);

    if (rows == 0)
    {
        SendClientMessage(playerid, 0x00FF00FF, ""SC"У Вас {FFFF00}нет {FFFFFF}личного {FFFF00}транспорта.");
        cache_delete(result);
        return 1;
    }

    // Выделяем память динамически для всех машин
    new dialog_text[4096] = ""; // Увеличиваем размер буфера для текста диалога
    new query[128];
    new model_id;
    new car_number[32], plate[16], region[8], plate_view[40];
    new plate_type;
    new model_name[24];
    new listed = 0;

    for (new i = 0; i < rows; i++)
    {
        new id = cache_get_field_content_int(i, "id");
        model_id = cache_get_field_content_int(i, "model_id");
        cache_get_field_content(i, "number", car_number);

        plate_type = TYPE_RU;
        if(ParseStoredPlateValue(car_number, plate_type, plate, sizeof(plate), region, sizeof(region)) && strlen(plate))
        {
            if(plate_type == TYPE_RU)
            {
                for(new p = 0; p < strlen(plate); p++)
                {
                    if(plate[p] >= 'a' && plate[p] <= 'z')
                    {
                        plate[p] -= ('a' - 'A');
                    }
                }
            }

            if(strlen(region)) format(plate_view, sizeof(plate_view), "%s | %s", plate, region);
            else format(plate_view, sizeof(plate_view), "%s", plate);
        }
        else
        {
            format(plate_view, sizeof(plate_view), "------");
        }

        GetVehicleDisplayNameByModel(model_id, model_name, sizeof model_name);
        format(query, sizeof query, "{FFFFFF}%d. %s {888888}[%s]\n", listed + 1, model_name, plate_view);
        strcat(dialog_text, query);

        SetPlayerListitemValue(playerid, listed, id);
        listed++;
    }

    if (listed == 0)
    {
        SendClientMessage(playerid, 0x00FF00FF, ""SC"Нет {FFFF00}доступных {FFFFFF}автомобилей.");
        cache_delete(result);
        return 1;
    }

    Dialog(playerid, DIALOG_OWNABLE_CAR_LIST, DIALOG_STYLE_LIST,
        "{FFCD00}Выберите транспорт",
        dialog_text,
        "Выбрать", "Закрыть"
    );

    cache_delete(result);
    return 1;
}

stock ShowRentBikeDialog(playerid, page = 0)
{
    new fmt_text[1024], Cache:result;

    mysql_format(mysql, fmt_text, sizeof fmt_text,
        "SELECT id, model_id, number FROM ownable_cars WHERE owner_id = %d",
        GetPlayerAccountID(playerid)
    );
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows(result);

    const items_per_page = 14;
    new max_page = (rows > 0) ? ((rows - 1) / items_per_page) : 0;

    if(page < 0) page = 0;
    if(page > max_page) page = max_page;

    gRentBikeDialogPage[playerid] = page;
    ClearPlayerListitemValues(playerid);

    new dialog_text[4096];
    dialog_text[0] = '\0';

    strcat(dialog_text, "{E0584B}##\t{E0584B}Название\t{E0584B}Номер\t{E0584B}Действие\n");

    new listed = 0;
    if(page == 0)
    {
        strcat(dialog_text, "{E0584B}1.\t{FFFFFF}Скутер\t{888888}[Аренда]\t{6FCF5F}Арендовать за 50 руб\n");
        SetPlayerListitemValue(playerid, listed, RENT_BIKE_ITEM_SCOOTER);
        listed++;
    }

    new start = page * items_per_page;
    new end = start + items_per_page;
    if(end > rows) end = rows;

    new line_text[256], model_id, model_name[24];

    for(new row = start; row < end; row++)
    {
        new vehicle_sql_id = cache_get_row_int(row, 0);
        model_id = cache_get_row_int(row, 1);

        new plate_raw[32], plate[16], region[8], plate_view[40];
        new plate_type = TYPE_RU;
        cache_get_field_content(row, "number", plate_raw, mysql, sizeof(plate_raw));

        if(ParseStoredPlateValue(plate_raw, plate_type, plate, sizeof(plate), region, sizeof(region)) && strlen(plate))
        {
            if(plate_type == TYPE_RU)
            {
                for(new p = 0; p < strlen(plate); p++)
                {
                    if(plate[p] >= 'a' && plate[p] <= 'z')
                    {
                        plate[p] -= ('a' - 'A');
                    }
                }
            }

            if(strlen(region)) format(plate_view, sizeof(plate_view), "%s | %s", plate, region);
            else format(plate_view, sizeof(plate_view), "%s", plate);
        }
        else
        {
            format(plate_view, sizeof(plate_view), "------");
        }

        GetVehicleDisplayNameByModel(model_id, model_name, sizeof model_name);

        format(line_text, sizeof line_text, "{E0584B}%d.\t{FFFFFF}%s\t{888888}[%s]\t{FFFFFF}Доставить ТС\n", row + 2, model_name, plate_view);
        strcat(dialog_text, line_text);

        SetPlayerListitemValue(playerid, listed, vehicle_sql_id);
        listed++;
    }

    if(page > 0)
    {
        strcat(dialog_text, "{AAAAAA}<< Назад\n");
        SetPlayerListitemValue(playerid, listed, RENT_BIKE_ITEM_PREV);
        listed++;
    }

    if(page < max_page)
    {
        strcat(dialog_text, "{AAAAAA}Далее >>\n");
        SetPlayerListitemValue(playerid, listed, RENT_BIKE_ITEM_NEXT);
        listed++;
    }

    Dialog(
        playerid, DIALOG_RENT_BIKE, DIALOG_STYLE_TABLIST_HEADERS,
        "{E0584B}{SERVER_NAME} | {FFFFFF}Управление транспортом",
        dialog_text,
        "Выбрать", "Закрыть"
    );

    cache_delete(result);
    return 1;
}
stock ShowOwnableCarListDialog(playerid, page = 0)
{
    new fmt_text[1024];
    new Cache:result;
    new rows;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT id, model_id, number FROM ownable_cars WHERE owner_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);
    rows = cache_num_rows(result);

    if(rows == 0)
    {
        SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
        cache_delete(result);
        return 1;
    }

    const items_per_page = 15;
    new max_page = (rows - 1) / items_per_page;

    if(page < 0) page = 0;
    if(page > max_page) page = max_page;

    gOwnableCarDialogPage[playerid] = page;
    ClearPlayerListitemValues(playerid);

    new dialog_text[4096];
    dialog_text[0] = '\0';

    strcat(dialog_text, "{FFFFFF}Авто\t{FFFFFF}Номер\n");

    new start = page * items_per_page;
    new end = start + items_per_page;
    if(end > rows) end = rows;

    new line_text[256], model_id, model_name[24], listed = 0;

    for(new i = start; i < end; i++)
    {
        new sql_id = cache_get_row_int(i, 0);
        model_id = cache_get_row_int(i, 1);

        new plate_raw[32], plate[16], region[8], plate_view[40];
        new plate_type = TYPE_RU;
        cache_get_field_content(i, "number", plate_raw, mysql, sizeof(plate_raw));

        if(ParseStoredPlateValue(plate_raw, plate_type, plate, sizeof(plate), region, sizeof(region)) && strlen(plate))
        {
            if(plate_type == TYPE_RU)
            {
                for(new p = 0; p < strlen(plate); p++)
                {
                    if(plate[p] >= 'a' && plate[p] <= 'z')
                    {
                        plate[p] -= ('a' - 'A');
                    }
                }
            }

            if(strlen(region)) format(plate_view, sizeof(plate_view), "%s | %s", plate, region);
            else format(plate_view, sizeof(plate_view), "%s", plate);
        }
        else
        {
            format(plate_view, sizeof(plate_view), "------");
        }

        GetVehicleDisplayNameByModel(model_id, model_name, sizeof model_name);

        format(line_text, sizeof line_text, "{FFFFFF}%d. %s\t{888888}[%s]\n", i + 1, model_name, plate_view);
        strcat(dialog_text, line_text);
        SetPlayerListitemValue(playerid, listed, sql_id);
        listed++;
    }

    if(page > 0)
    {
        strcat(dialog_text, "{FFFFFF}<< Назад\n");
        SetPlayerListitemValue(playerid, listed, -1);
        listed++;
    }

    if(page < max_page)
    {
        strcat(dialog_text, "{FFFFFF}Следующая страница\n");
        SetPlayerListitemValue(playerid, listed, -2);
        listed++;
    }

    Dialog(playerid, DIALOG_OWNABLE_CAR_LIST, DIALOG_STYLE_TABLIST_HEADERS,
        "{FF0000}Выберите транспорт",
        dialog_text,
        "Выбрать", "Закрыть"
    );

    cache_delete(result);
    return 1;
}
CMD:car(playerid, params[])
{
    if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
    {
        return carssssc(playerid);
    }

    return ShowOwnableCarListDialog(playerid, 0);
}

CMD:carpass(playerid, params[])
{
    new targetid = playerid;
    if(strlen(params) && sscanf(params, "i", targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /carpass [id игрока]");

    new vehicleid = GetPlayerOwnableCar(playerid);
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid))
    {
        vehicleid = GetPlayerVehicleID(playerid);
    }
    if(vehicleid == INVALID_VEHICLE_ID || vehicleid == 0 || !IsValidVehicle(vehicleid))
        return SendClientMessage(playerid, 0xCECECEFF, "У Вас нет личного транспорта");

    if(targetid == playerid)
    {
        new dialog_text[2048];
        if(!BuildCarPassDialogText(playerid, dialog_text, sizeof dialog_text))
            return SendClientMessage(playerid, 0xCECECEFF, "Не удалось загрузить тех.паспорт");

        ShowPlayerDialog(playerid, DIALOG_CARPASS_VIEW, DIALOG_STYLE_TABLIST_HEADERS, "{FF8C00}Тех. паспорт", dialog_text, "Закрыть", "");
        return 1;
    }

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

    if(!IsPlayerInRangeOfPlayer(playerid, targetid, CARPASS_INVITE_RANGE))
        return SendClientMessage(playerid, 0xCECECEFF, "Игрок находится слишком далеко");

    g_carpass_invite_from[targetid] = playerid;
    g_carpass_invite_time[targetid] = gettime();

    new fmt_text[128];
    format(fmt_text, sizeof fmt_text, "Вы предложили %s показать тех.паспорт на машину", GetPlayerNameEx(targetid));
    SendClientMessage(playerid, COLOR_CARPASS, fmt_text);

    format(fmt_text, sizeof fmt_text, "Игрок %s предлагает показать тех.паспорт на машину", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, COLOR_CARPASS, fmt_text);

    format(fmt_text, sizeof fmt_text, "Предложение от %s", GetPlayerNameEx(playerid));
    ShowNotificationNew(targetid, 4, 6, playerid, 0, fmt_text, ">>");
    return 1;
}



CMD:trunk(playerid, params[])
{
    TrunkTest_TryOpenNearby(playerid, true);
    return 1;
}
/*CMD:ta(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /ta [vehicleid] [item] [amount]");

	extract params -> new vehicleid, item, amount;

	if(AddTrunkItem(vehicleid, item, amount))
	{
		new fmt_str[128];

		format(fmt_str, sizeof fmt_str, "Вы положили \"%s\" в багажник, кол-во: %d %s", GetItemInfo(item, I_NAME), amount, GetItemInfo(item, I_NAME_COUNT));
		SendClientMessage(playerid, 0x3399FFFF, fmt_str);
	}
					else SendClientMessage(playerid, 0x999999FF, "Неверный тип предмета");

	return 1;
}*/


/*CMD:finit(playerid, params[])
{
	new query[128];

	new floor, flat;
	for(new idx; idx < 46; idx ++)
	{
		for(floor = 0; floor < GetEntranceData(idx, E_FLOORS); floor ++)
		{
			for(flat = 0; flat < 4; flat ++)
			{
				format(query, sizeof query, "INSERT INTO houses (price,rent_price,type,entrance) VALUES (%d,%d,%d,%d)", 400000 + (!random(3) ? 50000 : 100000), 500, 0, idx);
				mysql_query(mysql, query, false);
			}
		}
	}
	return 1;
}*/
/*
CMD:money(playerid, params[])
{
	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /money [кол-во]");

	extract params -> new money;

	if(!(1 <= money <= 100_000))
		return SendClientMessage(playerid, 0xCECECEFF, "За раз можно взять от 1 до 100.000");

	return GivePlayerMoneyEx(playerid, money, "test", true, true);
}*/
/*
CMD:test(playerid, params[])
{
	new vehicleid = GetPlayerVehicleID(playerid);
	if(IsAOwnableCar(vehicleid))
	{
		new index = GetVehicleData(vehicleid, V_ACTION_ID);
		new bool: param = GetOwnableCarData(index, OC_KEY_IN);

		SetOwnableCarData(index, OC_KEY_IN, param ^ true);
	}
	//SetRandomWeather();

	//new fmt_str[32];

	//format(fmt_str, sizeof fmt_str, "in_biz: %d", GetPlayerInBiz(playerid));
	//SendClientMessage(playerid, 0xCECECEFF, fmt_str);

	//new param = GetPVarInt(playerid, "test");
	//SetPVarInt(playerid, "test", param ^ 1);

	//extract params-> new itemid;
	//GivePlayerDrinkItem(playerid, itemid);


	if(!strlen(params))
		return SendClientMessage(playerid, 0xCECECEFF, "Используй: /test [action id]");

	extract params -> new action_id;
	SetPlayerSpecialAction(playerid, action_id);


	return 1;
}
*/

/*CMD:8372(playerid, params[])
{
    if(!GetPlayerAdminCMDAllow(playerid, CMD_VEH))
	{
		SendClientMessage(playerid, -1, "У вас не куплена данная команда /adonate -> покупка платных команд");
		return 1;
	}

    extract params -> new model_id, color_1, color_2; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /veh [id модели] [цвет 1] [цвет 2] [доступ игроков (не обязательно)]");

    if(!(400 <= model_id <= 2629)) return SendClientMessage(playerid, 0xCECECEFF, "Используйте модель от 400 до 2629");

    new status;

    sscanf(params, "{d}{d}{d}d", status);

    if(!(0 <= status <= 1))
        return SendClientMessage(playerid, 0x999999FF, "Доступ игроков к транспорту: 0 - Нет доступа, 1 - Доступно любому игроку");

    new Float: x,
        Float: y,
        Float: z,
        Float: a;

    GetPlayerPos(playerid, x, y, z);
    GetPlayerFacingAngle(playerid, a);

    new vehicleid = CreateVehicle(model_id, x, y, z, a, color_1, color_2, -1, 0, VEHICLE_ACTION_TYPE_ADMIN_CAR, status);
    PutPlayerInVehicle(playerid, vehicleid, 0);

    new fmt_text[100];

    if(GetPlayerAdminEx(playerid) <= 5)
    {
        format(fmt_text, sizeof fmt_text, "[A] Администратор %s[%d] создал транспорт (%d, %d, %d)",
        GetPlayerNameEx(playerid), playerid, model_id, color_1, color_2);

        SendMessageToAdmins(fmt_text, 0x999999FF);
    }

    format(fmt_text, sizeof fmt_text, "Создал транспорт (%d, %d, %d)", model_id, color_1, color_2);
    SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_text);

    return 1;
}
*/

