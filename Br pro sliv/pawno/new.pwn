// This is a comment
// uncomment the line below if you want to write a filterscript
//#define FILTERSCRIPT

#include <a_samp>

#if defined FILTERSCRIPT

public OnFilterScriptInit()
{
	print("\n--------------------------------------");
	print(" Blank Filterscript by your name here");
	print("--------------------------------------\n");
	return 1;
}

public OnFilterScriptExit()
{
	return 1;
}

#else

main()
{
	print("\n----------------------------------");
	print(" Blank Gamemode by your name here");
	print("----------------------------------\n");
}

#endif

public OnGameModeInit()
{
	// Don't use these lines if it's a filterscript
	SetGameModeText("Blank Script");
	AddPlayerClass(0, 1958.3783, 1343.1572, 15.3746, 269.1425, 0, 0, 0, 0, 0, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}

public OnPlayerRequestClass(playerid, classid)
{
	SetPlayerPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraPos(playerid, 1958.3783, 1343.1572, 15.3746);
	SetPlayerCameraLookAt(playerid, 1958.3783, 1343.1572, 15.3746);
	return 1;
}

public OnPlayerConnect(playerid)
{
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	return 1;
}

public OnPlayerSpawn(playerid)
{
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	return 1;
}

public OnVehicleSpawn(vehicleid)
{
	return 1;
}

public OnVehicleDeath(vehicleid, killerid)
{
	return 1;
}

public OnPlayerText(playerid, text[])
{
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
	if (strcmp("/mycommand", cmdtext, true, 10) == 0)
	{
		// Do something here
		return 1;
	}
	return 0;
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
	return 1;
}

public OnPlayerExitVehicle(playerid, vehicleid)
{
	return 1;
}

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveCheckpoint(playerid)
{
	return 1;
}

public OnPlayerEnterRaceCheckpoint(playerid)
{
	return 1;
}

public OnPlayerLeaveRaceCheckpoint(playerid)
{
	return 1;
}

public OnRconCommand(cmd[])
{
	return 1;
}

public OnPlayerRequestSpawn(playerid)
{
	return 1;
}

public OnObjectMoved(objectid)
{
	return 1;
}

public OnPlayerObjectMoved(playerid, objectid)
{
	return 1;
}

public OnPlayerPickUpPickup(playerid, pickupid)
{
	return 1;
}

public OnVehicleMod(playerid, vehicleid, componentid)
{
	return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid)
{
	return 1;
}

public OnVehicleRespray(playerid, vehicleid, color1, color2)
{
	return 1;
}

public OnPlayerSelectedMenuRow(playerid, row)
{
	return 1;
}

public OnPlayerExitedMenu(playerid)
{
	return 1;
}

public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	return 1;
}

public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	return 1;
}

public OnRconLoginAttempt(ip[], password[], success)
{
	return 1;
}

public OnPlayerUpdate(playerid)
{
	return 1;
}

public OnPlayerStreamIn(playerid, forplayerid)
{
	return 1;
}

public OnPlayerStreamOut(playerid, forplayerid)
{
	return 1;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	return 1;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	return 1;
}

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
	return 1;
}

public OnPlayerClickPlayer(playerid, clickedplayerid, source)
{
	return 1;
}

CMD:astart(playerid)
{
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		new Float:veh_hp = GetVehicleData(vehicleid, V_HEALTH);
    	if(veh_hp <= 270.0) 
		{
        	ShowNotificationSile(playerid, 2, 5, 0, 0, "Двигатель в транспорте неисправен.", " ");
        	return 1;
    	}
    	if(GetVehicleData(vehicleid, V_FUEL) <= 0.0)
        	return ShowNotificationSile(playerid, 2, 5, -1, -1, "В Вашем транспорте нет бензина.", "");

		new Float:x, Float:y, Float:z;
		GetVehiclePos(vehicleid, x, y, z);
		if(!IsPlayerInRangeOfPoint(playerid, 50.0, x, y, z))
		{
			ShowNotificationSile(playerid, 2, 5, 0, 0, "Вы находитесь слишком далеко от своего транспорта!", " ");
			return 1;
		}

    	new engine = GetVehicleParam(vehicleid, V_ENGINE) ^ 1;
    	SetVehicleParam(vehicleid, V_ENGINE, engine);

		new lights = (GetVehicleParam(vehicleid, V_LIGHTS) ^ VEHICLE_PARAM_ON);
		SetVehicleParam(vehicleid, V_LIGHTS, lights);
		
		if(engine == VEHICLE_PARAM_OFF && lights == VEHICLE_PARAM_OFF)
		{
			ShowNotificationSile(playerid, 1, 5, -1, -1, "Вы заглушили транспорт", "");
			SendClientMessage(playerid, -1, "Для включения двигателя используйте команду /astart");
			
			if(astartactive[playerid])
			{
				KillTimer(astarttimer[playerid]);
				astartactive[playerid] = false;
			}
		}
		else
		{
			ShowNotificationSile(playerid, 1, 5, -1, -1, "Вы успешно запустили транспорт", "");
			SendClientMessage(playerid, -1, "Для выключения двигателя используйте команду /astart");
			
			if(astartactive[playerid])
			{
				KillTimer(astarttimer[playerid]);
			}
			astarttimer[playerid] = SetTimerEx("AutoTurnOffEngine", 600000, false, "i", playerid);
			astartactive[playerid] = true;
			
			SendClientMessage(playerid, 0xFF9900FF, "Если вы не сядете в транспорт в течение 10 минут, двигатель автоматически заглушится!");
		}
	}
	else
	{
		if(GetPlayerOwnableCars(playerid) == 0)
			SendClientMessage(playerid, 0x999999FF, "У Вас нет личного транспорта");
		else
			SendClientMessage(playerid, 0x999999FF, "Ваш личный транспорт не загружен на сервер");
	}
}

forward AutoOffEngine(playerid);
public AutoOffEngine(playerid)
{
	if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
		return 1;
	
	new vehicleid = GetPlayerOwnableCar(playerid);
	if(vehicleid == INVALID_VEHICLE_ID)
		return 1;
	
	if(IsPlayerInVehicle(playerid, vehicleid))
	{
		astartactive[playerid] = false;
		SendClientMessage(playerid, -1, "Вы сели в транспорт, автоматическое глушение отменено!");
		return 1;
	}
	
	new Float:x, Float:y, Float:z;
	GetVehiclePos(vehicleid, x, y, z);
	
	if(!IsPlayerInRangeOfPoint(playerid, 150.0, x, y, z))
	{
		SetVehicleParam(vehicleid, V_ENGINE, VEHICLE_PARAM_OFF);
		SetVehicleParam(vehicleid, V_LIGHTS, VEHICLE_PARAM_OFF);
		astartactive[playerid] = false;
		
		ShowNotificationSile(playerid, 2, 5, -1, -1, "Транспорт заглушен из-за длительного бездействия!", "");
		SendClientMessage(playerid, -1, "Вы отошли от транспорта. Двигатель автоматически заглушен.");
		
		return 1;
	}
	
	SendClientMessage(playerid, -1, "Транспорт будет заглушен через 10 минут, если вы не сядете в него!");
	astarttimer[playerid] = SetTimerEx("AutoOffEngine", 600000, false, "i", playerid);
	
	return 1;
}