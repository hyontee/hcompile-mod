
enum Wheel_Properties
{
	Radius,
	Width[2],
	Alignment[2],
	Departure[2],
}

enum NumberPlate_Info
{
	Type,
	Number[8],
	Region[3],
}

enum Veh_Info 
{
	Float:vFuel,
	Float:vMileage,
	
	vLightColor,
	vHighLights, 

	vNeon[3], 

	vColorBody,
	vColorWheels,
	vWheel[Wheel_Properties],
	
	vClearance,
	vSeparate,
	
	vHydraulics, 

	vNumber[NumberPlate_Info],
	
	vTonerFront,
	vTonerRear,
	vTonerFrontSide,
	vTonerRearSide,

	//---------------------------------
	vNitro,
	vLaunchControl,
	vHornSound,
	vExhaustSound,
	//---------------------------------
	vVinyl,
	vVinylTexture[16],
	
	vSiren,
	vTurnSiren,
};
new vInfo[MAX_VEHICLES][Veh_Info];






stock UpdateVehicleVisualForPlayer(playerid, vehicleid)
{  
	if(vInfo[vehicleid][vNumber][Type] == 0) vInfo[vehicleid][vNumber][Type] = 6;
	SetVehicleNumberPlateForPlayer	(playerid, vehicleid, vInfo[vehicleid][vNumber][Type], vInfo[vehicleid][vNumber][Number], vInfo[vehicleid][vNumber][Region]);
	SetVehicleTonerForPlayer		(playerid, vehicleid, vInfo[vehicleid][vTonerFront], vInfo[vehicleid][vTonerRear], vInfo[vehicleid][vTonerFrontSide], vInfo[vehicleid][vTonerRearSide]); 
	SetVehicleLightColorForPlayer	(playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vLightColor]));
	SetVehicleLightingForPlayer		(playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vNeon][0]), RGBA_to_ARGB(vInfo[vehicleid][vNeon][1]), RGBA_to_ARGB(vInfo[vehicleid][vNeon][2]));
	SetVehicleVinylForPlayer		(playerid, vehicleid, vInfo[vehicleid][vVinylTexture]);
	SetVehicleColorForPlayer		(playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vColorBody]), RGBA_to_ARGB(vInfo[vehicleid][vColorWheels]));
	SetVehicleStroboscopeForPlayer	(playerid, vehicleid, vInfo[vehicleid][vStrob]-1);
	SetVehicleHighLightForPlayer	(playerid, vehicleid, 1);
	SetVehicleEnableSirenForPlayer	(playerid, vehicleid, 1); 
	SetVehicleSirenForPlayer		(playerid, vehicleid, vInfo[vehicleid][vSiren]);
}



stock ResetVehicleInfo(vehicleid)
{
	//оставьте желаемые значения стокового тюнинга
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleNumberPlateEx(vehicleid, type, number[], region[])
{
	vInfo[vehicleid][vNumber][Type] = type;
	format(vInfo[vehicleid][vNumber][Number], 9, number);
	format(vInfo[vehicleid][vNumber][Region], 4, region); 
	foreach(new playerid: Player)
	{	
		SetVehicleNumberPlateForPlayer(playerid, vehicleid, type, number, region); 
	}
} 

stock SetVehicleNumberPlateForPlayer(playerid, vehicleid, type, number[], region[])
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 7);

	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	
	BS_WriteValue(bitstream, PR_UINT8, type); 
	
	BS_WriteValue(bitstream, PR_UINT8, strlen(number));
	BS_WriteValue(bitstream, PR_STRING, number);
	
	BS_WriteValue(bitstream, PR_UINT8, strlen(region));
	BS_WriteValue(bitstream, PR_STRING, region); 

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}
 
 



//by KBAS's  t.me/kbasstudio 
//ARGB
stock SetVehicleToner(vehicleid, front, rear, front_side, back_side, setvalue=0)
{
	if(setvalue)
	{
		vInfo[vehicleid][vTonerFront] 		= front;
		vInfo[vehicleid][vTonerRear] 		= rear;
		vInfo[vehicleid][vTonerFrontSide] 	= front_side;
		vInfo[vehicleid][vTonerRearSide] 	= back_side;
	}
	foreach(new playerid : streamed_players_in_veh[vehicleid]) 
	{	
		if(playerclient(playerid) == 1) SetVehicleTonerForPlayer(playerid, vehicleid, front, rear, front_side, back_side);
		else continue;
	}
} 

stock SetVehicleTonerForPlayer(playerid, vehicleid, front, rear, front_side, back_side)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 0);

	BS_WriteValue(bitstream, PR_UINT32, front);
	BS_WriteValue(bitstream, PR_UINT32, rear);
	BS_WriteValue(bitstream, PR_UINT32, front_side);
	BS_WriteValue(bitstream, PR_UINT32, back_side); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleClearance(vehicleid, clearance, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vClearance] = clearance;
	foreach(new playerid : streamed_players_in_veh[vehicleid])  SetVehicleClearanceForPlayer(playerid, vehicleid, clearance); 
} 

stock SetVehicleClearanceForPlayer(playerid, vehicleid, clearance)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 1);

	new Float:change = clearance / 50.0;
	BS_WriteValue(bitstream, PR_FLOAT, change);  

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleSeparateClearance(vehicleid, clearance, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vSeparate] = clearance;
	foreach(new playerid : streamed_players_in_veh[vehicleid])  SetVehicleSeparateClearanceFP(playerid, vehicleid, clearance); 
} 

stock SetVehicleSeparateClearanceFP(playerid, vehicleid, clearance)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 2);

	new Float:change = clearance / 100.0;
	BS_WriteValue(bitstream, PR_FLOAT, change);  

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleWheelRadius(vehicleid, radius, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vWheel][Radius] = radius; 
	foreach(new playerid : streamed_players_in_veh[vehicleid]) SetVehicleWheelRadiusFP(playerid, vehicleid, radius); 
} 

stock SetVehicleWheelRadiusFP(playerid, vehicleid, radius)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 3);

	new Float:change = (radius / 250.0) + 0.7;
	BS_WriteValue(bitstream, PR_FLOAT, change);   

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleLightColor(vehicleid, color, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vLightColor] = color; 
	foreach(new playerid : streamed_players_in_veh[vehicleid])  SetVehicleLightColorForPlayer(playerid, vehicleid, RGBA_to_ARGB(color)); 
} 

stock SetVehicleLightColorForPlayer(playerid, vehicleid, color)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 8);

	BS_WriteValue(bitstream, PR_UINT32, color);  

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleLightingColor(vehicleid, center, right, left, setvalue=0)
{
	if(setvalue)
	{
		vInfo[vehicleid][vNeon][0] = center;
		vInfo[vehicleid][vNeon][1] = right;
		vInfo[vehicleid][vNeon][2] = left;
	}
	
	foreach(new playerid : streamed_players_in_veh[vehicleid]) SetVehicleLightingForPlayer(playerid, vehicleid, RGBA_to_ARGB(center), RGBA_to_ARGB(right), RGBA_to_ARGB(left)); 
} 

stock SetVehicleLightingForPlayer(playerid, vehicleid, center, right, left)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 9);

	BS_WriteValue(bitstream, PR_UINT32, center);  
	BS_WriteValue(bitstream, PR_UINT32, right);
	BS_WriteValue(bitstream, PR_UINT32, left);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleWheelAlignment(vehicleid, front, rear, setvalue=0)
{
	if(setvalue)
	{
		vInfo[vehicleid][vWheel][Alignment][0] = front; 
		vInfo[vehicleid][vWheel][Alignment][1] = rear; 
	}
	foreach(new playerid : streamed_players_in_veh[vehicleid]) SetVehicleWheelAlignmentFP(playerid, vehicleid, front, rear); 
} 

stock SetVehicleWheelAlignmentFP(playerid, vehicleid, front, rear)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 10);

	new Float:change;
	change = front / -200.0; 
	BS_WriteValue(bitstream, PR_FLOAT, change);  
	change = rear / -200.0; 
	BS_WriteValue(bitstream, PR_FLOAT, change); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
} 



//by KBAS's  t.me/kbasstudio 
stock SetVehicleVinyl(vehicleid, texture[], setvalue=0)
{
	if(setvalue) format(vInfo[vehicleid][vVinylTexture], 16, texture); 
	foreach(new playerid : streamed_players_in_veh[vehicleid]) SetVehicleVinylForPlayer(playerid, vehicleid, texture);
} 

stock SetVehicleVinylForPlayer(playerid, vehicleid, texture[])
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 12);

	BS_WriteValue(bitstream, PR_UINT8, strlen(texture));
	BS_WriteValue(bitstream, PR_STRING, texture); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleSpeedometerInfo(vehicleid, Float:fuel = 0.0, Float:mileage = 0.0)
{
	vInfo[vehicleid][vFuel] = fuel;
	vInfo[vehicleid][vMileage] = mileage;

	foreach(new playerid: Player)
	{	
		if(GetPlayerVehicleID(playerid) == vehicleid && GetPlayerState(playerid) == PLAYER_STATE_DRIVER) SetVehicleSpeedometerInfoFP(playerid, vehicleid, fuel, mileage); 
		else continue;
	}
} 

stock SetVehicleSpeedometerInfoFP(playerid, vehicleid, Float:fuel = 0.0, Float:mileage = 0.0)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 14);

	BS_WriteValue(bitstream, PR_UINT32, fuel);
	BS_WriteValue(bitstream, PR_UINT32, mileage); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleHornSound(vehicleid, horn_id, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vHornSound] = horn_id;
	foreach(new playerid: Player) SetVehicleHornSoundForPlayer(playerid, vehicleid, horn_id); 
} 

stock SetVehicleHornSoundForPlayer(playerid, vehicleid, horn_id)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 15);

	BS_WriteValue(bitstream, PR_UINT8, horn_id); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleWheelDeparture(vehicleid, front, rear, setvalue=0)
{
	if(setvalue)
	{
		vInfo[vehicleid][vWheel][Departure][0] = front; 
		vInfo[vehicleid][vWheel][Departure][1] = rear; 
	}
	foreach(new playerid: Player) SetVehicleWheelDepartureFP(playerid, vehicleid, front, rear);
} 

stock SetVehicleWheelDepartureFP(playerid, vehicleid, front, rear)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 16);

	new Float:change;
	change = (front / 400.0) + -0.125;
	BS_WriteValue(bitstream, PR_FLOAT, change);
	change = (rear / 400.0) + -0.125;
	BS_WriteValue(bitstream, PR_FLOAT, change); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleWheelWidth(vehicleid, front, rear, setvalue=0)
{
	if(setvalue)
	{
		vInfo[vehicleid][vWheel][Width][0] = front; 
		vInfo[vehicleid][vWheel][Width][1] = rear; 
	}
	foreach(new playerid: Player) SetVehicleWheelWidthFP(playerid, vehicleid, front, rear); 
} 

stock SetVehicleWheelWidthFP(playerid, vehicleid, front, rear)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 17);

	new Float:change;
	change = (front / 80.0) + 0.5;
	BS_WriteValue(bitstream, PR_FLOAT, change);
	change = (rear / 80.0) + 0.5;
	BS_WriteValue(bitstream, PR_FLOAT, change); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleColor(vehicleid, body, wheel, setvalue=0)
{
	if(setvalue)
	{
		vInfo[vehicleid][vColorBody] = body;
		vInfo[vehicleid][vColorWheels] = wheel;
	}
	foreach(new playerid: Player) SetVehicleColorForPlayer(playerid, vehicleid, RGBA_to_ARGB(body), RGBA_to_ARGB(wheel)); 
} 

stock SetVehicleColorForPlayer(playerid, vehicleid, body, wheel)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 18);

	BS_WriteValue(bitstream, PR_UINT32, body);
	BS_WriteValue(bitstream, PR_UINT32, wheel);
	BS_WriteValue(bitstream, PR_UINT32, wheel);
	BS_WriteValue(bitstream, PR_UINT32, body); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleStroboscope(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vStrob] = type;
	foreach(new playerid: Player) SetVehicleStroboscopeForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleStroboscopeForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 19);

	BS_WriteValue(bitstream, PR_UINT32, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleChipTune(vehicleid, type)
{   
	foreach(new playerid: Player) SetVehicleChipTuneForPlayer(playerid, vehicleid, type); 
} 
//прошивки оставляю на доработку
stock SetVehicleChipTuneForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 20);

	BS_WriteValue(bitstream, PR_UINT32, type); //PR_UINT32 
	//0x3DCCCCCD - дефолт
	//0x3F666666 - комфорт
	//0x3F800000 - дрифт
	//0x3F4CCCCD - спорт
	//0x3F7AE148 - спорт+

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleHydraulics(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vHydraulics] = type;
	foreach(new playerid: Player) SetVehicleHydraulicsForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleHydraulicsForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 21);

	BS_WriteValue(bitstream, PR_UINT8, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleHighLight(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vHighLights] = type;
	foreach(new playerid: Player) SetVehicleHighLightForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleHighLightForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 22);

	BS_WriteValue(bitstream, PR_UINT8, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleLaunchControl(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vLaunchControl] = type;
	foreach(new playerid: Player) SetVehicleLaunchControlFP(playerid, vehicleid, type); 
} 

stock SetVehicleLaunchControlFP(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 23);

	BS_WriteValue(bitstream, PR_UINT8, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleExhaust(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vExhaustSound] = type;
	foreach(new playerid: Player) SetVehicleExhaustForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleExhaustForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 24);

	BS_WriteValue(bitstream, PR_UINT16, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleSiren(vehicleid, type, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vSiren] = type;
	foreach(new playerid: Player) SetVehicleSirenForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleSirenForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 26);

	BS_WriteValue(bitstream, PR_UINT8, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}





//by KBAS's  t.me/kbasstudio 
stock SetVehicleEnableSiren(vehicleid, type) //синхронизация включенной сирены
{
	//vInfo[vehicleid][vEnableSiren] = type;
	foreach(new playerid: Player) SetVehicleEnableSirenForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleEnableSirenForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 27);

	BS_WriteValue(bitstream, PR_UINT8, type); 

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}