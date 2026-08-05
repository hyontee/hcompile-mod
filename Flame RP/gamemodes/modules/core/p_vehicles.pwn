public OnVehicleStreamIn(vehicleid, forplayerid) {
	if(!IsValidVehicle(vehicleid)) return 1;
	GetVehiclePos(vehicleid, VehicleInfo[vehicleid][veX], VehicleInfo[vehicleid][veY], VehicleInfo[vehicleid][veZ]);
	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][veA]);
	return 1;
}
public OnVehicleStreamOut(vehicleid, forplayerid) {
    return 1;
}
public OnVehicleDeath(vehicleid, killerid) {
	if(killerid != INVALID_PLAYER_ID && !TI[killerid][tLogin]) return false;
	if(GetArendCarID(vehicleid) != -1) {
	    new playerid = ArendInfo[GetArendCarID(vehicleid)][aPlayerID];
	    ArendInfo[GetArendCarID(vehicleid)][aPlayerID] = INVALID_PLAYER_ID;
		VehicleInfo[vehicleid][vFuel] = gTransport[GetVehicleModel(vehicleid)-400][trTank];
	    if(IsPlayerConnected(playerid) && TI[playerid][tArendKey] == GetArendCarID(vehicleid)) {
	        SendClientMessage(playerid, COLOR_LIGHTRED, "Транспорт, который вы арендовали, был уничтожен. Контракт расторгнут");
	        TI[playerid][tArendKey] = -1;
	    }
	}
	if(VehicleInfo[vehicleid][vBizz] > 0) {
		for(new i; i < 20; i ++) {
			if(FuncBizz[VehicleInfo[vehicleid][vBizz]][funcbCars][i] != vehicleid) continue;
			update_bfunc(3,VehicleInfo[vehicleid][vBizz],VehicleInfo[vehicleid][vColor],i);
		}
	}
	foreach(new i:Player) {
		if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
	 	if(vehicleid == house_car[i][0]) VehicleInfo[house_car[i][0]][vFuel] = gPlayerCars[i][carFuel][0],SetVehicleParamsEx(vehicleid,false,false,false,true,false,false,false), LoadTuning(i,house_car[i][0],0);
		if(vehicleid == house_car[i][1]) VehicleInfo[house_car[i][1]][vFuel] = gPlayerCars[i][carFuel][1],SetVehicleParamsEx(vehicleid,false,false,false,true,false,false,false), LoadTuning(i,house_car[i][1],1);
		if(vehicleid == PlayerTrailer[i]) {
			A_DestroyVehicle(PlayerTrailer[i]);
			PlayerTrailer[i] = INVALID_VEHICLE_ID;
			if(gPlayerProdText[i] != Text3D:-1) {
				DestroyDynamic3DTextLabel(gPlayerProdText[i]);
				gPlayerProdText[i] = Text3D:-1;
			}
			if(gPlayerProdCP[i] != -1) DestroyDynamicCP(gPlayerProdCP[i]);
			DeletePVar(i,"count_prod2");
			DeletePVar(i,"count_prod");
			DeletePVar(i,"attach_trailer");
		}
		if(vehicleid == rob_veh[i]) {
			leave_robhouse(i);
		}
		if(vehicleid == TK_Trailer[i]) {
			A_DestroyVehicle(TK_Trailer[i]);
			TK_Trailer[i] = INVALID_VEHICLE_ID;
			TI[i][tTrucker][3] = 0;
			TI[i][tTrucker][2] = 0;
			TI[i][tTrucker][1] = 0;
			TI[i][tTrucker][0] = 0;
			SendOk(i,"Груз удален");
		}
		else if(vehicleid == car_autoschool[i]) {
			A_DestroyVehicle(car_autoschool[i]);
			car_autoschool[i] = INVALID_VEHICLE_ID;
			DisablePlayerRaceCheckpoint(i);
			ErrorMessage(i,"Экзамен завален");
			TI[i][tAutoSchool] = 0;
			DeletePVar(i,"LessonSlotMav");
			DeletePVar(i,"LessonSlotBoat");
			SetPlayerPosAC(i,GetPVarFloat(i,"pos_x_autos"),GetPVarFloat(i,"pos_y_autos"),GetPVarFloat(i,"pos_z_autos"),45,3);
		}
		if(theftIDveh[i][0] == vehicleid && thefttime[i] !=0){ //угон
			SendOk(i,"Вы провалили задание, ваш навык угона понижен.");
			DestroyDynamicArea(theftarea[i][0]);
			DisablePlayerCheckpoint(i);
			DestroyDynamicCP(theftCheck[i][0]);
			A_DestroyVehicle(theftIDveh[i][0]);
			theftIDveh[i][0] = INVALID_VEHICLE_ID;
			if(theftveh[i][0] != INVALID_VEHICLE_ID) {
				A_DestroyVehicle(theftveh[i][0]);
				theftveh[i][0] = INVALID_VEHICLE_ID;
			}
			if(theftplayer[theftIDveh[i][1]][0] != 1010) theftplayer[theftIDveh[i][1]][0] = 1010;
			theftplayer[i][1] = 0;
			theftCheck[i][1] = 0;
			PlayerTextDrawHide(i, theft_PTD[i][0]);
			thefttime[i] = 0;
			if(PI[i][ptheftExp] == 0) {
				if(PI[i][ptheftSkill] != 0) PI[i][ptheftSkill]--, UpdatePlayerData(i,"theftSkill",PI[i][ptheftSkill]);
				PI[i][ptheftExp] = TheftSkillMax[PI[i][ptheftSkill]]-1, UpdatePlayerData(i,"theftExp",PI[i][ptheftExp]);
			}
			else {
				if(PI[i][ptheftExp] != 0) PI[i][ptheftExp]--, UpdatePlayerData(i,"theftExp",PI[i][ptheftExp]);
			}
		}
	}
	SetVehicleToRespawn(vehicleid);
	return true;
}
public OnVehicleSpawn(vehicleid) {
	VehicleInfo[vehicleid][vPlayer] = -1;
	SetVehicleParamsEx(vehicleid,false,false,false,false,false,false,false);

	if(VehicleInfo[vehicleid][vTeam] == fFBI || VehicleInfo[vehicleid][vTeam] == fWHITEHOUSE) SetVehicleHealth(vehicleid,3000.0);
	if(GetArendCarID(vehicleid) != -1) {
	    new playerid = ArendInfo[GetArendCarID(vehicleid)][aPlayerID];
		VehicleInfo[vehicleid][vFuel] = gTransport[GetVehicleModel(vehicleid)-400][trTank];
	    ArendInfo[GetArendCarID(vehicleid)][aPlayerID] = INVALID_PLAYER_ID;
	    if(IsPlayerConnected(playerid) && TI[playerid][tArendKey] == GetArendCarID(vehicleid)) {
	        SendClientMessage(playerid, COLOR_LIGHTRED, "Транспорт, который вы арендовали, был заспавнен. Контракт расторгнут");
			TI[playerid][tArendKey] = -1;
	    }
	}
	if(VehicleInfo[vehicleid][vType] == VEHICLE_TYPE_ADMIN) {
		A_DestroyVehicle(vehicleid);
	}
	if(VehicleInfo[vehicleid][vJob] > 0 || VehicleInfo[vehicleid][vTeam] > 0) {
		VehicleInfo[vehicleid][vFuel] = gTransport[GetVehicleModel(vehicleid)-400][trTank];
		VehicleInfo[vehicleid][vPlayer] = -1;
	}
	if(VehicleInfo[vehicleid][vBizz] > 0) {
		for(new i; i < 20; i ++) {
			if(FuncBizz[VehicleInfo[vehicleid][vBizz]][funcbCars][i] != vehicleid) continue;
			update_bfunc(3,VehicleInfo[vehicleid][vBizz],VehicleInfo[vehicleid][vColor],i);
		}
	}
	foreach(new i:Player) {
		if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
	 	if(vehicleid == house_car[i][0]) VehicleInfo[house_car[i][0]][vFuel] = gPlayerCars[i][carFuel][0],SetVehicleParamsEx(vehicleid,false,false,false,true,false,false,false), LoadTuning(i,house_car[i][0],0);
		if(vehicleid == house_car[i][1]) VehicleInfo[house_car[i][1]][vFuel] = gPlayerCars[i][carFuel][1],SetVehicleParamsEx(vehicleid,false,false,false,true,false,false,false), LoadTuning(i,house_car[i][1],1);
		if(vehicleid == PlayerTrailer[i]) {
			A_DestroyVehicle(PlayerTrailer[i]);
			PlayerTrailer[i] = INVALID_VEHICLE_ID;
			if(gPlayerProdText[i] != Text3D:-1) {
				DestroyDynamic3DTextLabel(gPlayerProdText[i]);
				gPlayerProdText[i] = Text3D:-1;
			}
			if(gPlayerProdCP[i] != -1) DestroyDynamicCP(gPlayerProdCP[i]);
			DeletePVar(i,"count_prod2");
			DeletePVar(i,"count_prod");
			DeletePVar(i,"attach_trailer");
		}
		if(vehicleid == rob_veh[i]) {
			leave_robhouse(i);
		}
		if(vehicleid == TK_Trailer[i]) {
			A_DestroyVehicle(TK_Trailer[i]);
			TK_Trailer[i] = INVALID_VEHICLE_ID;
			TI[i][tTrucker][3] = 0;
			TI[i][tTrucker][2] = 0;
			TI[i][tTrucker][1] = 0;
			TI[i][tTrucker][0] = 0;
			SendOk(i,"Груз удален");
		}
		else if(vehicleid == car_autoschool[i]) {
			A_DestroyVehicle(car_autoschool[i]);
			car_autoschool[i] = INVALID_VEHICLE_ID;
			DisablePlayerRaceCheckpoint(i);
			ErrorMessage(i,"Экзамен завален");
			TI[i][tAutoSchool] = 0;
			DeletePVar(i,"LessonSlotMav");
			DeletePVar(i,"LessonSlotBoat");
			SetPlayerPosAC(i,GetPVarFloat(i,"pos_x_autos"),GetPVarFloat(i,"pos_y_autos"),GetPVarFloat(i,"pos_z_autos"),45,3);
		}
	}
	if(VG[vehicleid][vgLoading] || VG[vehicleid][vgUnloading] || VG[vehicleid][vgRobHouse]) {
		VG[vehicleid][vgLoading] = false;
		VG[vehicleid][vgUnloading] = false;
		VG[vehicleid][vgRobHouse] = false;

		if(IsValid3DTextLabel(VG[vehicleid][vgText])) DestroyDynamic3DTextLabelEx(VG[vehicleid][vgText]);

		DestroyDynamicPickup(VG[vehicleid][vgPickup]);
	    VG[vehicleid][vgPickup] = 0;
	    DestroyDynamicArea(VG[vehicleid][vgArea]);
	    VG[vehicleid][vgArea] = 0;

		if(vehicleid == 482) VG[vehicleid][vgAmount][0] = 0;
	}
 	if(VehicleInfo[vehicleid][vJob] > 0) {
		foreach(new i:Player) {
			if(!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
		    if(TI[i][tArendaCar] == vehicleid) {
				TI[i][tArendaCar] = -1;
				DisablePlayerRaceCheckpoint(i);
				if(GetPVarInt(i,"veh_id_cleaner") == vehicleid) EndGazon(i);
				if(GetPVarInt(i,"clear_id") == vehicleid) EndClear(i);
				if(GetPVarInt(i,"bus_id") == vehicleid) EndBus(i);
				if(GetPVarInt(i,"track_id") == vehicleid) EndTrack(i);
				if(GetPVarInt(i,"prod_vehicle_id") == vehicleid) EndProd(i);
				if(GetPVarInt(i,"mehjob") == vehicleid) EndMeh(i);
				if(GetPVarInt(i,"eatjob") == vehicleid) EndEat(i);
		    	break;
			}
		}
	}
	if(LightsObject[vehicleid][0]!=-1 || LightsObject[vehicleid][1]!=-1) {
		if(LightsObject[vehicleid][0] != -1) DestroyDynamicObject(LightsObject[vehicleid][0]);
		if(LightsObject[vehicleid][1] != -1) DestroyDynamicObject(LightsObject[vehicleid][1]);
		LightsObject[vehicleid][0] = -1;
		LightsObject[vehicleid][1] = -1;
		SignalTick[vehicleid][0] = 0;
		SignalTick[vehicleid][1] = -1;
		Signal[vehicleid] = 0;
	}
	GetVehiclePos(vehicleid, VehicleInfo[vehicleid][veX], VehicleInfo[vehicleid][veY], VehicleInfo[vehicleid][veZ]);
	GetVehicleZAngle(vehicleid, VehicleInfo[vehicleid][veA]);
	return true;
}
public OnVehicleDamageStatusUpdate(vehicleid, playerid) {
	new Float:vehicleHealth;
	GetVehicleHealth(vehicleid, vehicleHealth);
	if(VehicleInfo[vehicleid][vJob] == 1) {
		if(GetPVarInt(playerid,"bus_id") == vehicleid) SetPVarFloat(playerid,"bus_damage", vehicleHealth);
	}
	return true;
}
public OnVehicleRespray(playerid, vehicleid, color1, color2) {
    return 1;
}

public OnVehiclePaintjob(playerid, vehicleid, paintjobid) {
	return 1;
}
public OnVehicleMod(playerid, vehicleid, componentid) {
	new vehicleide = GetVehicleModel(vehicleid);
	new modok = IsLegalCarMod(vehicleide, componentid);
	if (!modok) {
		RemoveVehicleComponent(vehicleid,componentid);
		return 0;
	}
	if(IsAtTunning(playerid)) {
	    if(GetPlayerInterior(playerid) == 0 && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
	        RemoveVehicleComponent(vehicleid,componentid);
	        return 0;
	    }
		else {
		    RemoveVehicleComponent(vehicleid, componentid);
		    ErrorMessage(playerid, "Этот транспорт нельзя тюнинговать");
			return 0;
		}
	}
	else {
	    if(GetPlayerState(playerid) == 2) {
			RemoveVehicleComponent(vehicleid, componentid);
			return 0;
		}
	}
	return true;
}