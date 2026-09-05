CMD:tune(playerid, params[])
{
    new string[4096];
    strcat(string, "{FFD700}=== ТЮНИНГ ТРАНСПОРТА ==={FFFFFF}\n\n");
    
    strcat(string, "{FFA500}ВНЕШНИЙ ВИД:{FFFFFF}\n");
    strcat(string, "  /setplate - Номерной знак\n");
    strcat(string, "  /settoning - Тонировка стекол черного цвета\n");
    strcat(string, "  /setvinyl - Винил на кузов\n");
    strcat(string, "  /setvcolor - Цвет кузова и дисков\n");
    strcat(string, "  /setstrob - Стробоскопы\n");
    strcat(string, "  /setsiren - Сирена\n\n");
    
    strcat(string, "{00FF00}ПОДВЕСКА И КОЛЕСА:{FFFFFF}\n");
    strcat(string, "  /setclearance - Клиренс\n");
    strcat(string, "  /setsepclearance - Раздельный клиренс\n");
    strcat(string, "  /setwheelradius - Радиус колес\n");
    strcat(string, "  /setalignment - Развал колес\n");
    strcat(string, "  /setdeparture - Вылет колес\n");
    strcat(string, "  /setwheelwidth - Ширина колес\n");
    strcat(string, "  /sethydraulics - Гидравлика\n\n");
    
    strcat(string, "{FF69B4}ОСВЕЩЕНИЕ:{FFFFFF}\n");
    strcat(string, "  /setlightcolor - Цвет фар\n");
    strcat(string, "  /setneon - Неоновая подсветка\n");
    strcat(string, "  /sethighlight - Блики фар\n\n");
    
    strcat(string, "{87CEEB}ЗВУК И ДВИГАТЕЛЬ:{FFFFFF}\n");
    strcat(string, "  /sethorn - Звук клаксона\n");
    strcat(string, "  /setexhaust - Звук выхлопа\n");
    strcat(string, "  /setbodykit - обвес\n");
    strcat(string, "  /setlaunch - Launch Control");
    
    ShowPlayerDialog(playerid, 74774, DIALOG_STYLE_MSGBOX, "{ff0000}"SERVER_NAME" {ffffff}Помощь по тюнингу", string, "ОК", "");
    return 1;
}

CMD:setplate(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new type, number[9], region[4];
    if(sscanf(params, "is[9]s[4]", type, number, region)) 
        return SendClientMessage(playerid, -1, "Использование: /setplate [type] [number] [region]");
    
    SetVehicleNumberPlateEx(vehicleid, type, number, region);
    SendClientMessage(playerid, -1, "Номерной знак установлен!");
    return 1;
}

// ---------- ТОНИРОВКА ----------
CMD:settoning(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new front = 0xFF000000; 
    new rear = 0xFF000000;
    new front_side = 0xFF000000; 
    new back_side = 0xFF000000;
    
    SetVehicleTonerForPlayer(playerid, vehicleid, front, rear, front_side, back_side);
    SendClientMessage(playerid, -1, "Тонировка установлена!");
    return 1;
}

// ---------- КЛИРЕНС ----------
CMD:setclearance(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new clearance, setvalue = 1;
    if(sscanf(params, "i", clearance)) 
        return SendClientMessage(playerid, -1, "Использование: /setclearance [clearance]");
    
    SetVehicleClearance(vehicleid, clearance, setvalue);
    SendClientMessage(playerid, -1, "Клиренс установлен!");
    return 1;
}

// ---------- РАЗДЕЛЬНЫЙ КЛИРЕНС ----------
CMD:setsepclearance(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new clearance, setvalue = 1;
    if(sscanf(params, "i", clearance)) 
        return SendClientMessage(playerid, -1, "Использование: /setsepclearance [clearance]");
    
    SetVehicleSeparateClearance(vehicleid, clearance, setvalue);
    SendClientMessage(playerid, -1, "Раздельный клиренс установлен!");
    return 1;
}

// ---------- РАДИУС КОЛЕС ----------
CMD:setwheelradius(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new radius, setvalue = 1;
    if(sscanf(params, "i", radius)) 
        return SendClientMessage(playerid, -1, "Использование: /setwheelradius [radius]");
    
    SetVehicleWheelRadius(vehicleid, radius, setvalue);
    SendClientMessage(playerid, -1, "Радиус колес установлен!");
    return 1;
}

// ---------- ЦВЕТ ФАР ----------
CMD:setlightcolor(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new color, setvalue = 1;
    if(sscanf(params, "i", color)) 
        return SendClientMessage(playerid, -1, "Использование: /setlightcolor [color]");
    
    SetVehicleLightColor(vehicleid, color, setvalue);
    SendClientMessage(playerid, -1, "Цвет фар установлен!");
    return 1;
}

// ---------- НЕОН ----------
CMD:setneon(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new center, right, left, setvalue = 1;
    if(sscanf(params, "iii", center, right, left)) 
        return SendClientMessage(playerid, -1, "Использование: /setneon [center] [right] [left]");
    
    SetVehicleLightingColor(vehicleid, center, right, left, setvalue);
    SendClientMessage(playerid, -1, "Неон установлен!");
    return 1;
}

// ---------- РАЗВАЛ КОЛЕС ----------
CMD:setalignment(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new front, rear, setvalue = 1;
    if(sscanf(params, "ii", front, rear)) 
        return SendClientMessage(playerid, -1, "Использование: /setalignment [front] [rear]");
    
    SetVehicleWheelAlignment(vehicleid, front, rear, setvalue);
    SendClientMessage(playerid, -1, "Развал колес установлен!");
    return 1;
}

// ---------- ВИНИЛ ----------
CMD:setvinyl(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new texture[16], setvalue = 1;
    if(sscanf(params, "s[16]", texture)) 
        return SendClientMessage(playerid, -1, "Использование: /setvinyl [texture]");
    
    SetVehicleVinyl(vehicleid, texture, setvalue);
    SendClientMessage(playerid, -1, "Винил установлен!");
    return 1;
}

// ---------- ЗВУК КЛАКСОНА ----------
CMD:sethorn(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new horn_id, setvalue = 1;
    if(sscanf(params, "i", horn_id)) 
        return SendClientMessage(playerid, -1, "Использование: /sethorn [horn_id]");
    
    SetVehicleHornSound(vehicleid, horn_id, setvalue);
    SendClientMessage(playerid, -1, "Звук клаксона установлен!");
    return 1;
}

// ---------- ВЫЛЕТ КОЛЕС ----------
CMD:setdeparture(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new front, rear, setvalue = 1;
    if(sscanf(params, "ii", front, rear)) 
        return SendClientMessage(playerid, -1, "Использование: /setdeparture [front] [rear]");
    
    SetVehicleWheelDeparture(vehicleid, front, rear, setvalue);
    SendClientMessage(playerid, -1, "Вылет колес установлен!");
    return 1;
}

// ---------- ШИРИНА КОЛЕС ----------
CMD:setwheelwidth(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new front, rear, setvalue = 1;
    if(sscanf(params, "ii", front, rear)) 
        return SendClientMessage(playerid, -1, "Использование: /setwheelwidth [front] [rear]");
    
    SetVehicleWheelWidth(vehicleid, front, rear, setvalue);
    SendClientMessage(playerid, -1, "Ширина колес установлена!");
    return 1;
}

// ---------- ЦВЕТ КУЗОВА И ДИСКОВ ----------
CMD:setvcolor(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new body, wheel, setvalue = 1;
    if(sscanf(params, "ii", body, wheel)) 
        return SendClientMessage(playerid, -1, "Использование: /setvcolor [body] [wheel]");
    
    SetVehicleColor(vehicleid, body, wheel, setvalue);
    SendClientMessage(playerid, -1, "Цвет кузова и дисков установлен!");
    return 1;
}

// ---------- СТРОБОСКОП ----------
CMD:setstrob(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new type, setvalue = 1;
    if(sscanf(params, "i", type)) 
        return SendClientMessage(playerid, -1, "Использование: /setstrob [type]");
    
    SetVehicleStroboscope(vehicleid, type, setvalue);
    SendClientMessage(playerid, -1, "Стробоскоп установлен!");
    return 1;
}

// ---------- ПРОШИВКА (CHIP TUNE) ----------
CMD:setchiptune(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new type;
    if(sscanf(params, "i", type)) 
        return SendClientMessage(playerid, -1, "Использование: /setchiptune [type]");
    
    SetVehicleChipTune(vehicleid, type);
    SendClientMessage(playerid, -1, "Прошивка установлена!");
    return 1;
}

// ---------- ГИДРАВЛИКА ----------
CMD:sethydraulics(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new type, setvalue = 1;
    if(sscanf(params, "i", type)) 
        return SendClientMessage(playerid, -1, "Использование: /sethydraulics [type]");
    
    SetVehicleHydraulics(vehicleid, type, setvalue);
    SendClientMessage(playerid, -1, "Гидравлика установлена!");
    return 1;
}

// ---------- ХАЙЛАЙТЫ (БЛИКИ) ----------
CMD:sethighlight(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new type, setvalue = 1;
    if(sscanf(params, "i", type)) 
        return SendClientMessage(playerid, -1, "Использование: /sethighlight [type]");
    
    SetVehicleHighLight(vehicleid, type, setvalue);
    SendClientMessage(playerid, -1, "Блики установлены!");
    return 1;
}

// ---------- LAUNCH CONTROL ----------
CMD:setlaunch(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new type, setvalue = 1;
    if(sscanf(params, "i", type)) 
        return SendClientMessage(playerid, -1, "Использование: /setlaunch [type]");
    
    SetVehicleLaunchControl(vehicleid, type, setvalue);
    SendClientMessage(playerid, -1, "Launch control установлен!");
    return 1;
}

// ---------- ЗВУК ВЫХЛОПА ----------
CMD:setexhaust(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new type, setvalue = 1;
    if(sscanf(params, "i", type)) 
        return SendClientMessage(playerid, -1, "Использование: /setexhaust [type]");
    
    SetVehicleExhaust(vehicleid, type, setvalue);
    SendClientMessage(playerid, -1, "Звук выхлопа установлен!");
    return 1;
}

// ---------- СИРЕНА ----------
CMD:setsiren(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!IsPlayerInAnyVehicle(playerid)) 
        return SendClientMessage(playerid, -1, "Ошибка: Вы должны находиться в транспортном средстве!");
    
    new type, setvalue = 1;
    if(sscanf(params, "i", type)) 
        return SendClientMessage(playerid, -1, "Использование: /setsiren [type]");
    
    SetVehicleSiren(vehicleid, type, setvalue);
    SendClientMessage(playerid, -1, "Сирена установлена!");
    return 1;
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

stock SetVehicleClearance(vehicleid, clearance, setvalue=0)
{
    new playerid;
	if(setvalue) vInfo[vehicleid][vClearance] = clearance;
	foreach(playerid : Player)
    {
        if(IsPlayerConnected(playerid))  
        SetVehicleClearanceForPlayer(playerid, vehicleid, clearance); 
    }
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
    new playerid;
	if(setvalue) vInfo[vehicleid][vSeparate] = clearance;
	foreach(playerid : Player)
    {
        if(IsPlayerConnected(playerid))  
        SetVehicleSeparateClearanceFP(playerid, vehicleid, clearance); 
     }
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
    new playerid;
	if(setvalue) vInfo[vehicleid][vRadius] = radius; 
	foreach(playerid : Player)
    {
        if(IsPlayerConnected(playerid)) 
        SetVehicleWheelRadiusFP(playerid, vehicleid, radius); 
    }
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
    new playerid;
	if(setvalue) vInfo[vehicleid][vLightColor] = color; 
	foreach(playerid : Player)
    {
        if(IsPlayerConnected(playerid)) 
        SetVehicleLightColorForPlayer(playerid, vehicleid, RGBA_to_ARGB(color)); 
    }
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

	new playerid;
	foreach(playerid : Player)
    {
        if(IsPlayerConnected(playerid)) 
        SetVehicleLightingForPlayer(playerid, vehicleid, RGBA_to_ARGB(center), RGBA_to_ARGB(right), RGBA_to_ARGB(left)); 
    }
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
    new playerid;
	if(setvalue)
	{
		vInfo[vehicleid][vAlignmentP] = front; 
		vInfo[vehicleid][vAlignmentZ] = rear; 
	}
	foreach(playerid : Player)
    {
        if(IsPlayerConnected(playerid)) 
        SetVehicleWheelAlignmentFP(playerid, vehicleid, front, rear); 
     }
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
    new playerid;
	if(setvalue) format(vInfo[vehicleid][vVinylTexture], 16, texture); 
	foreach(playerid : Player)
    {
        if(IsPlayerConnected(playerid)) 
        SetVehicleVinylForPlayer(playerid, vehicleid, texture);
    }
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
		vInfo[vehicleid][vDepartureP] = front; 
		vInfo[vehicleid][vDepartureZ] = rear; 
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
		vInfo[vehicleid][vWidthP] = front; 
		vInfo[vehicleid][vWidthZ] = rear; 
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
		vInfo[vehicleid][vBodyColor] = body;
		vInfo[vehicleid][vDiskColor] = wheel;
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

CMD:setbodykit(playerid, params[])
{
    new vehicleid = GetPlayerVehicleID(playerid);
    if(!vehicleid) return SendClientMessage(playerid, -1, "Нужно быть в машине");
    
    if(isnull(params)) 
        return SendClientMessage(playerid, -1, "/setbodykits [ID]");
    
    new componentid = strval(params);
    
    new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 15);
    BS_WriteValue(bs, PR_UINT8, 0);
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT16, componentid);
    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
}

stock SetVehicleComponent(vehicleid, component, setvalue=0)
{
	if(setvalue) vInfo[vehicleid][vComponent] = component;
	foreach(new playerid: Player) SetVehicleComponentFP(playerid, vehicleid, component); 
} 

stock SetVehicleComponentFP(playerid, vehicleid, component)
{
   new BitStream:bs = BS_New();
    BS_WriteValue(bs, PR_UINT8, 15);
    BS_WriteValue(bs, PR_UINT8, 0);
    BS_WriteValue(bs, PR_UINT16, vehicleid);
    BS_WriteValue(bs, PR_UINT16, component);
    PR_SendRPC(bs, playerid, 168, PR_LOW_PRIORITY, PR_RELIABLE_ORDERED);
    BS_Delete(bs);
    return 1;
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

// синхра сирены (типо чтоб для всех была)
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