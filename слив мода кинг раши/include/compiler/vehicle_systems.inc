stock DisconnectPlayerVehicle(playerid)
{
	for(new i; i < MAX_LOAD_VEHICLE; i++)
	{
		if(PlayerVehicle[playerid][i] != INVALID_PLAYER_VEHICLE)
		{
			VehicleOwner[PlayerVehicle[playerid][i]] = INVALID_PLAYER_ID;
			DestroyPlayerVehicle(playerid, i);
		}
	}
	return true;
}

stock DestroyPlayerVehicle(playerid, i)
{
	new 
		id = PlayerVehicle[playerid][i];

	if(id == INVALID_VEHICLE_ID)
		return true;
	
	PlayerVehicle[playerid][i] = INVALID_PLAYER_VEHICLE;
	PlayerVehicleSQL[playerid][i] = INVALID_PLAYER_VEHICLE;

	format(stringer1, 128, "UPDATE `ownable_cars` SET c_status = '0', c_mileage = '%f', c_fuel = '%i' WHERE c_owner = '%s' AND id = '%d'", vehicle_mileage[id], Fuel[id], GetName(playerid), car_id[playerid]);
	mysql_tquery(db_prod, stringer1, "", "");

	DestroyVehicle(id);
	return true;
}

stock SpawnPlayerVehicle(playerid, vehicleid)
{
	for(new i; i < MAX_LOAD_VEHICLE; i++)
	{
		if(PlayerVehicle[playerid][i] == vehicleid)
		{
			if(!IsVehicleOccupiedAC(vehicleid))
			{
				VehicleOwner[PlayerVehicle[playerid][i]] = INVALID_PLAYER_ID;
				DestroyPlayerVehicle(playerid, i);
				SendClientMessage(i, COLOR_GREEN,"Ваш автомобиль был отбуксирован на парковочное место");
				SendClientMessage(i, COLOR_GREEN,"Используйте /fixcar для его появления, /findcar для поиска");
				break;
			}
		}
	}
	return true;
}

stock GetPlayerVehicle(playerid)
{
	new 
		vehid = GetPlayerVehicleID(playerid);

	if(!IsPlayerInAnyVehicle(playerid))
		return false;
	
	for(new i; i < MAX_LOAD_VEHICLE; i++)
	{
		if(PlayerVehicle[playerid][i] == vehid)
			return true;
	}
	return false;
}

stock GetPlayerVehicleSqlID(playerid)
{
	new 
		vehid = GetPlayerVehicleID(playerid);

	for(new i; i < MAX_LOAD_VEHICLE; i++)
	{
		if(PlayerVehicle[playerid][i]  == vehid)
			return PlayerVehicleSQL[playerid][i];
	}
	return -1;
}

stock GetPlayerSlotVehicle(playerid)
{
	for(new i; i < MAX_LOAD_VEHICLE; i++)
	{
		if(PlayerVehicle[playerid][i] == INVALID_PLAYER_VEHICLE)
			return i;
	}
	return -1;
}

stock GetPlayerVehicleStatus(playerid, id)
{
	for(new i; i < MAX_LOAD_VEHICLE; i++)
	{
		if(PlayerVehicleSQL[playerid][i] == id)
			return true;
	}

	return false;
}

stock GetActivePlayerVehicleCount(playerid)
{
	new 
		count;
	for(new i; i < MAX_LOAD_VEHICLE; i++)
	{
		if(PlayerVehicleSQL[playerid][i] != INVALID_PLAYER_VEHICLE)
			count++;
	}

	return count;
}