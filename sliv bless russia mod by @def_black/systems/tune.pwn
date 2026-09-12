
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
	vStrob,

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

	vDrift,
	vDriftActive,

	// статистика: вкл/выкл

	vEnableNeon,
	vEnableStroboscope,
	vEnableSiren,
	vEnableHydraulics,
	vEnableHighLights,
	vEnableStrob,
};
new vInfo[MAX_VEHICLES][Veh_Info];

stock ResetVehicleInfo(vehicleid)
{
	
}

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
 
stock SetVehicleTonerFix(vehicleid, front, rear, front_side, back_side, setvalue)
{
	if(setvalue > 0)
	{
		vInfo[vehicleid][vTonerFront] 		= front;
		vInfo[vehicleid][vTonerRear] 		= rear;
		vInfo[vehicleid][vTonerFrontSide] 	= front_side;
		vInfo[vehicleid][vTonerRearSide] 	= back_side;
	}
	foreach(new playerid : streamed_players_in_veh[vehicleid]) SetVehicleTonerFixForPlayer(playerid, vehicleid, front, rear, front_side, back_side);
} 

stock SetVehicleTonerFixForPlayer(playerid, vehicleid, front, rear, front_side, back_side)
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

stock SetVehicleChipTune(vehicleid, type)
{   
	foreach(new playerid: Player) SetVehicleChipTuneForPlayer(playerid, vehicleid, type); 
} 

stock SetVehicleChipTuneForPlayer(playerid, vehicleid, type)
{
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);
	BS_WriteValue(bitstream, PR_UINT8, 20);

	BS_WriteValue(bitstream, PR_UINT32, type);

	PR_SendRPC(bitstream, playerid, 167, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream);
}

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

stock SetVehicleEnableSiren(vehicleid, type)
{
	vInfo[vehicleid][vEnableSiren] = type;
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

stock SetVehicleDriftForPlayerFix(playerid, vehicleid, value)
{
    vInfo[vehicleid][vDriftActive] = value;
	new BitStream:bitstream = BS_New();
	BS_WriteValue(bitstream, PR_UINT8, 5); 
	
	BS_WriteValue(bitstream, PR_UINT16, vehicleid);  
	BS_WriteValue(bitstream, PR_UINT8, value);   

	PR_SendRPC(bitstream, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
	BS_Delete(bitstream); 
}

stock RGBA_to_ARGB(color)
{
    return ((color & 0xFFD700 ) >> 24) | (color & 0xffffff);
}

stock LoadTunTest(vehicleid)
{
    new idx = GetOwnableCarData(vehicleid, OC_SQL_ID);
    
    //if(idx <= 0) return SendClientMessage(playerid, -1, "Ошибка. Сообщите разработчикам");

    new query[256];
    mysql_format(mysql, query, sizeof query, "SELECT strabiki, drift_mode, launch_tex, strabiki_type, tonirovka, hydra, wheels_kl, wheels_otkl, wheels_size, wheels_raz, nitro FROM ownable_cars WHERE id = %d", idx);

    new Cache:result = mysql_query(mysql, query, true);

    if(cache_num_rows() > 0)
    {
        new strabiki = cache_get_field_content_int(0, "strabiki");
		new drift_mode = cache_get_field_content_int(0, "drift_mode");
		new launch_tex = cache_get_field_content_int(0, "launch_tex");
        new strabiki_type = cache_get_field_content_int(0, "strabiki_type");
        new hydra = cache_get_field_content_int(0, "hydra");
        new wheels_kl = cache_get_field_content_int(0, "wheels_kl");
        new wheels_otkl = cache_get_field_content_int(0, "wheels_otkl");
        new wheels_size = cache_get_field_content_int(0, "wheels_size");
        new wheels_raz = cache_get_field_content_int(0, "wheels_raz");
        new nitro = cache_get_field_content_int(0, "nitro");
        new tonirovka = cache_get_field_content_int(0, "tonirovka");

        if(vehicleid != 0)
        {
			new index = GetVehicleData(vehicleid, V_ACTION_ID);
			ChangeVehicleColor(vehicleid, GetOwnableCarData(index, OC_COLOR_1), GetOwnableCarData(index, OC_COLOR_2));
			if(strcmp(g_ownable_car[index][OC_NUMBER], "------"))	SetVehicleNumberPlateEx(vehicleid, 1, GetOwnableCarData(index, OC_NUMBER), "29");

            // Launch control
            // vInfo[vehicleid][vLaunchControl] = (cache_get_field_content_int(0, "launch") == 1) ? true : false;
            
            // Нитро
            if(nitro > 0)
            {
                vInfo[vehicleid][vNitro] = nitro;
                new nitro_type = nitro - 1;
                if(nitro_type >= 0 && nitro_type < sizeof(Nitro))
                {
                    AddVehicleComponent(vehicleid, Nitro[nitro_type][0]);
                }
            }

			// Лаунч
			if(launch_tex == 1)
            {
				vInfo[vehicleid][vLaunchControl] = true;
			}

			// Дрифт
			if(drift_mode == 1)
            {
			    //SetVehicleDriftForPlayerFix(playerid, vehicleid, 1);
                vInfo[vehicleid][vDrift] = true;
			}
			
			if(tonirovka > 0)
            {
				SetVehicleTonerFix(vehicleid, 0xFA000000, 0xFA000000, 0xFA000000, 0xFA000000, 1);
			}

            // Гидравлика
            if(hydra == 1)
            {
				SetVehicleHydraulics(vehicleid, 1, 1);
                vInfo[vehicleid][vHydraulics] = true;
                vInfo[vehicleid][vEnableHydraulics] = true;
            }

            // Стробоскопы
            if(strabiki == 1)
            {
				SetVehicleStroboscope(vehicleid, strabiki_type, 1);
                vInfo[vehicleid][vStrob] = strabiki_type;
                vInfo[vehicleid][vEnableStroboscope] = true;
            }

			if(wheels_size == 0) wheels_size = 40;
            if(wheels_otkl == 0) wheels_otkl = 50;
            if(wheels_kl == 0)   wheels_kl = 50;

                // Клиренс
				SetVehicleClearance(vehicleid, wheels_kl, 1);
                vInfo[vehicleid][vClearance] = wheels_kl;
                
                // Раздельный клиренс
				SetVehicleSeparateClearance(vehicleid, wheels_otkl, 1);
                vInfo[vehicleid][vSeparate] = wheels_otkl;
                
                // Ширина колес
				SetVehicleWheelWidth(vehicleid, wheels_size, wheels_size, 1);
                vInfo[vehicleid][vWheel][Width][0] = wheels_size;
                vInfo[vehicleid][vWheel][Width][1] = wheels_size;
                
                // Развал колес
				SetVehicleWheelAlignment(vehicleid, wheels_raz, wheels_raz, 1);
                vInfo[vehicleid][vWheel][Alignment][0] = wheels_raz;
                vInfo[vehicleid][vWheel][Alignment][1] = wheels_raz;
                
                // Радиус колес (фиксированный)
				SetVehicleWheelRadius(vehicleid, 75, 1);
                vInfo[vehicleid][vWheel][Radius] = 75;

            //UpdateVehicleVisualForPlayer(playerid, vehicleid);
        }
    }
    else //SendClientMessage(playerid, -1, "Машина с таким ID не найдена");

    cache_delete(result);
    return 1;
}

// это загрузка тюна исключительно вертона!
stock UpdateVehicleVisualForPlayer(playerid, vehicleid)
{
	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	if(vInfo[vehicleid][vWheel][Width][0] == 0) vInfo[vehicleid][vWheel][Width][0] = 40;
	if(vInfo[vehicleid][vWheel][Width][1] == 0) vInfo[vehicleid][vWheel][Width][1] = 40;
    if(vInfo[vehicleid][vSeparate] == 0)    vInfo[vehicleid][vSeparate] = 50;
    if(vInfo[vehicleid][vClearance] == 0)   vInfo[vehicleid][vClearance] = 50;
    SetVehicleClearanceForPlayer    (playerid, vehicleid, vInfo[vehicleid][vClearance]);
    SetVehicleSeparateClearanceFP   (playerid, vehicleid, vInfo[vehicleid][vSeparate]);
	SetVehicleWheelWidthFP          (playerid, vehicleid, vInfo[vehicleid][vWheel][Width][0], vInfo[vehicleid][vWheel][Width][1]);
	SetVehicleWheelAlignmentFP      (playerid, vehicleid, vInfo[vehicleid][vWheel][Alignment][0], vInfo[vehicleid][vWheel][Alignment][1]);
	SetVehicleTonerFixForPlayer		(playerid, vehicleid, vInfo[vehicleid][vTonerFront], vInfo[vehicleid][vTonerRear], vInfo[vehicleid][vTonerFrontSide], vInfo[vehicleid][vTonerRearSide]); 
	//SetVehicleLightColorForPlayer	(playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vLightColor]));
	//SetVehicleLightingForPlayer		(playerid, vehicleid, RGBA_to_ARGB(vInfo[vehicleid][vNeon][0]), RGBA_to_ARGB(vInfo[vehicleid][vNeon][1]), RGBA_to_ARGB(vInfo[vehicleid][vNeon][2]));
	//SetVehicleVinylForPlayer		(playerid, vehicleid, vInfo[vehicleid][vVinylTexture]);
	if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_OWNABLE_CAR)
	{
		ChangeVehicleColor(vehicleid, GetOwnableCarData(index, OC_COLOR_1), GetOwnableCarData(index, OC_COLOR_2));
		if(strcmp(g_ownable_car[index][OC_NUMBER], "------"))	SetVehicleNumberPlateForPlayer(playerid, vehicleid, 1, GetOwnableCarData(index, OC_NUMBER), "29");
	}
	else	ChangeVehicleColor(vehicleid, GetVehicleData(vehicleid, V_COLOR_1), GetVehicleData(vehicleid, V_COLOR_2));
	if(vInfo[vehicleid][vStrob] > 0) SetVehicleStroboscopeForPlayer	(playerid, vehicleid, vInfo[vehicleid][vStrob]);
	//SetVehicleHighLightForPlayer	(playerid, vehicleid, 1);
	//SetVehicleEnableSirenForPlayer	(playerid, vehicleid, 1); 
	//SetVehicleSirenForPlayer		(playerid, vehicleid, vInfo[vehicleid][vSiren]);
	SetVehicleHydraulicsForPlayer   (playerid, vehicleid, vInfo[vehicleid][vHydraulics]);
	if(vInfo[vehicleid][vNitro] > 0) AddVehicleComponent(vehicleid, Nitro[vInfo[vehicleid][vNitro] - 1][0]);
	if(vInfo[vehicleid][vDriftActive] == true) SetVehicleDriftForPlayerFix(playerid, vehicleid, 1);
	else SetVehicleDriftForPlayerFix(playerid, vehicleid, 0);

	if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_FAMILY_CAR)
	{
		new color_1 = GetCarFamily(index, V_F_COLOR_1);
		new color_2 = GetCarFamily(index, V_F_COLOR_2);
		ChangeVehicleColor(vehicleid, color_1, color_2);
		if(strcmp(vehicle_family[index][V_F_NUMBER], "------"))	SetVehicleNumberPlateForPlayer(playerid, vehicleid, 1, GetCarFamily(index, V_F_NUMBER), "29");

		SetVehicleWheelsFam(GetCarFamily(index, CAR_F_database), vehicleid); //(Это загрузка настройки шин для семьи)
		return 1;
	}
	return 1;
}