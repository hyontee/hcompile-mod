//>> Файл: bykranin_src/core/vehicle/ownable_06.inc  (229 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: GetCoordVehicle, GetVehicleTurnSignalPos, SetVehicleToHotelRespawn, GetHotelFreePark, GetVehicleDisplayNameByModel, SetPlayerSexEx, ShowOwnableCarPass
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetCoordVehicle(vehicleid, type, &Float:x, &Float:y, &Float:z, &Float:angle, &Float:distance) // by Essle (багажник / капот)
{
    GetVehicleModelInfo(GetVehicleData(vehicleid, V_MODELID), 1, x, distance, z); // узнаем длину машины
    distance = distance / 2 + 0.1; // полученную длину делим на два

    GetVehiclePos(vehicleid, x, y, z); // узнаем координаты авто
    GetVehicleZAngle(vehicleid, angle); // узнаем угол поворота авто

	switch(type)
	{
		case VEHICLE_COORD_TYPE_BOOT: // багажник
		{
			x += (distance * floatsin(-angle+180, degrees)); // вычитаем координату x бaгажника
			y += (distance * floatcos(-angle+180, degrees)); // вычитаем координату y бaгажника
		}
		case VEHICLE_COORD_TYPE_BONNET: // капот
		{
			x -= (distance * floatsin(-angle+180, degrees)); // вычитаем координату x капота
			y -= (distance * floatcos(-angle+180, degrees)); // вычитаем координату y капота
		}
		default:
		{
			return 0;
		}
	}
	return 1;
}

stock GetVehicleTurnSignalPos(vehicleid, type, &Float:x, &Float:y)
{
	/*

		Типы:
		1 - левый передний
		2 - левый задний
		3 - правый передний
		4 - правый задний

	*/

	new Float: size_x,
		Float: size_y,
		Float: size_z;

	GetVehicleModelInfo(GetVehicleData(vehicleid, V_MODELID), 1, size_x, size_y, size_z);

	switch(type)
	{
		case 1:
		{
			x = -(size_x / 2) + 0.3;
			y = size_y / 2 - 0.5;
		}
		case 2:
		{
			x = -(size_x / 2) + 0.3;
			y = -(size_y / 2) + 0.4;
		}
		case 3:
		{
			x = size_x / 2 - 0.3;
			y = size_y / 2 - 0.5;
		}
		case 4:
		{
			x = size_x / 2 - 0.3;
			y = -(size_y / 2) + 0.4;
		}
	}

	return 1;
}

stock SetVehicleToHotelRespawn(hotelid, vehicleid)
{
	if(IsValidVehicle(vehicleid))
	{
		new free_slot = GetHotelFreePark(hotelid);
		if(free_slot != -1)
		{
			g_hotel_car_park_pos[hotelid][free_slot][HC_VEHICLE_ID] = vehicleid;

			SetVehiclePos(vehicleid, g_hotel_car_park_pos[hotelid][free_slot][HC_POS_X], g_hotel_car_park_pos[hotelid][free_slot][HC_POS_Y], g_hotel_car_park_pos[hotelid][free_slot][HC_POS_Z]);
			SetVehicleZAngle(vehicleid, g_hotel_car_park_pos[hotelid][free_slot][HC_ANGLE]);

			return 1;
		}
	}
	return 0;
}

stock GetHotelFreePark(hotelid)
{
	new vehicleid, slot = -1;

	for(new idx; idx < sizeof(g_hotel_car_park_pos[]); idx ++)
	{
		vehicleid = g_hotel_car_park_pos[hotelid][idx][HC_VEHICLE_ID];
		if(GetVehicleDistanceFromPoint(vehicleid, g_hotel_car_park_pos[hotelid][idx][HC_POS_X], g_hotel_car_park_pos[hotelid][idx][HC_POS_Y], g_hotel_car_park_pos[hotelid][idx][HC_POS_Z]) >= 8.0) continue;

		slot = idx;
		break;
	}
	return slot;
}

stock GetVehicleDisplayNameByModel(modelid, dest[], size = sizeof dest)
{
	for(new marketid; marketid < sizeof(car_market_data); marketid ++)
	{
		for(new idx; idx < sizeof(car_market_data[]); idx ++)
		{
			if(car_market_data[marketid][idx][CM_MODELID] != modelid) continue;
			if(!car_market_data[marketid][idx][CM_NAME][0]) continue;

			format(dest, size, "%s", car_market_data[marketid][idx][CM_NAME]);
			return 1;
		}
	}

	GetVehicleModelName(modelid, dest);
	return 1;
}

stock SetPlayerSexEx(playerid, sex, bool:save = true)
{
	sex = sex ? 1 : 0;
	SetPlayerData(playerid, P_SEX, sex);
	if(save) UpdatePlayerDatabaseInt(playerid, "sex", sex);
	return 1;
}

stock ShowOwnableCarPass(playerid, vehicleid)
{
	new model_id = GetVehicleData(vehicleid, V_MODELID);

	if(model_id && IsAOwnableCar(vehicleid))
	{
		new fmt_str[300];
		new Float: health;
		new index = GetVehicleData(vehicleid, V_ACTION_ID);

		new description[32], model_name[32];
		GetVehicleDisplayNameByModel(model_id, model_name, sizeof model_name);

		format(description, sizeof description, "{0099FF}Документы на ТС №%d", GetOwnableCarData(index, OC_SQL_ID));

		GetVehicleHealth(vehicleid, health);

		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Название:\t\t{3399FF}%s\n\n"\
			"{FFFFFF}Модель:\t\t{3399FF}%d\n"\
			"{FFFFFF}Состояние:\t\t{3399FF}%d\n"\
			"{FFFFFF}Пробег:\t\t{3399FF}%07i\n"\
			"{FFFFFF}Цвет:\t\t\t{3399FF}ID %d, %d\n"\
			"{FFFFFF}Гос. стоимость:\t{3399FF}%d руб\n"\
			"{FFFFFF}Номерные знаки:\t{3399FF}%s",
			model_name,
			model_id,
			floatround(health),
			floatround(GetVehicleData(vehicleid, V_MILEAGE), floatround_ceil),
			GetOwnableCarData(index, OC_COLOR_1),
			GetOwnableCarData(index, OC_COLOR_2),
			GetVehicleInfo(model_id-400, VI_PRICE),
			GetOwnableCarData(index, OC_NUMBER)
		);
		Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, description, fmt_str, "Закрыть", "");

		return 1;
	}
	return 0;
}

stock IsAOwnableCar(vehicleid)
{
	if(IsValidVehicleID(vehicleid))
	{
		if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
		{
			return 1;
		}
	}
	return 0;
}

stock IsVehicleSeatOccupied(vehicleid, seatid)
{
	foreach(new i : Player)
	{
		if(!IsPlayerConnected(i)) continue;
		else if(!IsPlayerLogged(i)) continue;
		else if(!IsPlayerInVehicle(i, vehicleid)) continue;
		else if(GetPlayerVehicleSeat(i) != seatid) continue;

		return 1;
	}

	return 0;
}

stock IsVehicleOccupied(vehicleid)
{
	foreach(new i : Player)
	{
		if(!IsPlayerInAnyVehicle(i)) continue;

		if(GetPlayerVehicleID(i) == vehicleid)
			return 1;
	}

	return 0;
}

stock IsTrailerAttachedToAnyVehicle(trailerid)
{
	for(new i = 1; i < MAX_VEHICLES; i ++)
	{
		if(!IsValidVehicle(i)) continue;

		if(GetVehicleTrailer(i) == trailerid)
			return 1;
	}

	return 0;
}

