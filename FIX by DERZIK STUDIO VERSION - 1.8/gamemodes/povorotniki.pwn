/* FS Поворотники
   Сайт: pawno-crmp */
//==============================================================================
#include a_samp
//==============================================================================
new povorotniki[MAX_VEHICLES][6];
//[Объекты поворотников]========================================================
stock SetVehicleIndicator(vehicleid, levyipovorotnik=0, pravyipovorotnik=0)
{
	if(!levyipovorotnik & !pravyipovorotnik) return false;
	new Float:_vX[2], Float:_vY[2], Float:_vZ[2];
	if(pravyipovorotnik)
	{
		if(IsTrailerAttachedToVehicle(vehicleid))
		{
			new helpgtacrmp = GetVehicleModel(GetVehicleTrailer(vehicleid));
			GetVehicleModelInfo(helpgtacrmp, VEHICLE_MODEL_INFO_SIZE, _vX[0], _vY[0], _vZ[0]);
			povorotniki[vehicleid][4] = CreateObject(19294, 0, 0, 0,0,0,0);
			AttachObjectToVehicle(povorotniki[vehicleid][4], GetVehicleTrailer(vehicleid),  _vX[0]/2.4, -_vY[0]/3.35, -1.0 ,0,0,0);
		}
		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, _vX[0], _vY[0], _vZ[0]);
		AttachObjectToVehicle(povorotniki[vehicleid][0], vehicleid,  _vX[0]/2.23, _vY[0]/2.23, 0.1 ,0,0,0);
		PlayerPlaySound(vehicleid, 1055, 0.0, 0.0, 0.0);
		povorotniki[vehicleid][1] = CreateObject(19294, 0, 0, 0,0,0,0);
		AttachObjectToVehicle(povorotniki[vehicleid][1], vehicleid,  _vX[0]/2.23, -_vY[0]/2.23, 0.1 ,0,0,0);
	}
	if(levyipovorotnik)
	{
		if(IsTrailerAttachedToVehicle(vehicleid))
		{
			new helpgtacrmp = GetVehicleModel(GetVehicleTrailer(vehicleid));
			GetVehicleModelInfo(helpgtacrmp, VEHICLE_MODEL_INFO_SIZE, _vX[0], _vY[0], _vZ[0]);
			povorotniki[vehicleid][5] = CreateObject(19294, 0, 0, 0,0,0,0);
			AttachObjectToVehicle(povorotniki[vehicleid][5], GetVehicleTrailer(vehicleid),  -_vX[0]/2.4, -_vY[0]/3.35, -1.0 ,0,0,0);
		}
		GetVehicleModelInfo(GetVehicleModel(vehicleid), VEHICLE_MODEL_INFO_SIZE, _vX[0], _vY[0], _vZ[0]);
		PlayerPlaySound(vehicleid, 1055, 0.0, 0.0, 0.0);
		povorotniki[vehicleid][2] = CreateObject(19294, 0, 0, 0,0,0,0);
		AttachObjectToVehicle(povorotniki[vehicleid][2], vehicleid,  -_vX[0]/2.23, _vY[0]/2.23, 0.1 ,0,0,0);
		povorotniki[vehicleid][3] = CreateObject(19294, 0, 0, 0,0,0,0);
		AttachObjectToVehicle(povorotniki[vehicleid][3], vehicleid,  -_vX[0]/2.23, -_vY[0]/2.23, 0.1 ,0,0,0);
	}
	return true;
}
//[Клавиши]=====================================================================
public OnPlayerKeyStateChange(playerid,newkeys, oldkeys)
{
	if(IsPlayerInAnyVehicle(playerid) && GetPlayerState(playerid) == 2)
	{
		if(!IsASamoletAndVertolet(GetPlayerVehicleID(playerid)) && !IsALodka(GetPlayerVehicleID(playerid)) && !IsAPoezd(GetPlayerVehicleID(playerid)) && !IsAVelik(GetPlayerVehicleID(playerid)) && !IsAIgrushka(GetPlayerVehicleID(playerid)))//Делаем исключения, на них поворотники работать не будут (см. конец скрипта)
		{
			new vid = GetPlayerVehicleID(playerid);
			if(newkeys & (KEY_LOOK_LEFT) && newkeys & (KEY_LOOK_RIGHT))//Одновременно клавиши Q и E
			{
				if(povorotniki[vid][2]) DestroyObject(povorotniki[vid][5]),DestroyObject(povorotniki[vid][2]), DestroyObject(povorotniki[vid][3]),povorotniki[vid][2]=0;
				else if(povorotniki[vid][0]) DestroyObject(povorotniki[vid][4]),DestroyObject(povorotniki[vid][0]), DestroyObject(povorotniki[vid][1]),povorotniki[vid][0]=0;
				else SetVehicleIndicator(vid,1,1);
				return true;
			}
			if(newkeys & KEY_LOOK_RIGHT)//Клавиша E
			{
				if(povorotniki[vid][0]) DestroyObject(povorotniki[vid][4]), DestroyObject(povorotniki[vid][0]), DestroyObject(povorotniki[vid][1]),povorotniki[vid][0]=0;
				else if(povorotniki[vid][2]) DestroyObject(povorotniki[vid][5]), DestroyObject(povorotniki[vid][2]), DestroyObject(povorotniki[vid][3]),povorotniki[vid][2]=0;
				else SetVehicleIndicator(vid,0,1);
			}
			if(newkeys & KEY_LOOK_LEFT)//Клавиша Q
			{
				if(povorotniki[vid][2]) DestroyObject(povorotniki[vid][5]),DestroyObject(povorotniki[vid][2]), DestroyObject(povorotniki[vid][3]),povorotniki[vid][2]=0;
				else if(povorotniki[vid][0]) DestroyObject(povorotniki[vid][4]),DestroyObject(povorotniki[vid][0]), DestroyObject(povorotniki[vid][1]),povorotniki[vid][0]=0;
				else SetVehicleIndicator(vid,1,0);
			}
		}
	}
	return true;
}
//[Если авто взрывается]========================================================
public OnVehicleDeath(vehicleid)
{
	if(povorotniki[vehicleid][2]) DestroyObject(povorotniki[vehicleid][2]), DestroyObject(povorotniki[vehicleid][3]),DestroyObject(povorotniki[vehicleid][5]),povorotniki[vehicleid][2]=0;
	if(povorotniki[vehicleid][0]) DestroyObject(povorotniki[vehicleid][0]), DestroyObject(povorotniki[vehicleid][1]),DestroyObject(povorotniki[vehicleid][4]),povorotniki[vehicleid][0]=0;
	return true;
}
//[Поворотники не будут работать на RC машинках]================================
stock IsAIgrushka(carid5)
{
	new carid = GetVehicleModel(carid5);
	if(carid == 464 || carid == 565 || carid == 501 || carid == 441 || carid == 564 || carid == 594) return 1;
	return false;
}
//[Поворотники не будут работать на велосипедах]================================
stock IsAVelik(carid4)
{
	new carid = GetVehicleModel(carid4);
	if(carid == 481 || carid == 509 || carid == 510) return 1;
	return false;
}
//[Поворотники не будут работать на поездах]====================================
stock IsAPoezd(carid3)
{
	new carid = GetVehicleModel(carid3);
	if(carid == 449 || carid == 537 || carid == 538 || carid == 590 || carid == 612 || carid == 613 || carid == 614 || carid == 793 || carid == 794 || carid == 795 || carid == 796 || carid == 797) return 1;
	return false;
}
//[Поворотники не будут работать на самолётах, вертолётах]======================
stock IsASamoletAndVertolet(carid2)
{
	new carid = GetVehicleModel(carid2);
	if(carid == 592 || carid == 577 || carid == 511 || carid == 512 || carid == 593 || carid == 520 || carid == 553 || carid == 476 || carid == 519 || carid == 460 || carid == 513) return 1;
	return false;
}
//[Поворотники не будут работать на лодках]=====================================
stock IsALodka(carid)
{
	new modelid = GetVehicleModel(carid);
	if(modelid == 430 || modelid == 446 || modelid == 452 || modelid == 453 || modelid == 454 || modelid == 472 || modelid == 473 || modelid == 484 || modelid == 493 || modelid == 595)
	{
		return true;
	}
	return false;
}
//[Конец]=======================================================================
