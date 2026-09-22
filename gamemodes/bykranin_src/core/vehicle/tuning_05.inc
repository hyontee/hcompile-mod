//>> Файл: bykranin_src/core/vehicle/tuning_05.inc  (349 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: RestorePlayerAndVehicles, SyncOwnableVehicleTuningData, LoadTuning, /testcasino
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
forward RestorePlayerAndVehicles(playerid, interior, world, epoch);
public RestorePlayerAndVehicles(playerid, interior, world, epoch)
{
    if(playerid < 0 || playerid >= MAX_PLAYERS || !IsPlayerConnected(playerid)) return 1;
    if(epoch != g_BRAuthEpoch[playerid]) return 1;
    g_stability_visual_timer[playerid] = 0;
    if(!IsPlayerLogged(playerid)) return 1;
    // Do not undo a teleport/spawn that took place while the timer was pending.
    if(GetPlayerVirtualWorld(playerid) != world + 1000 || GetPlayerInterior(playerid) != interior) return 1;
    SetPlayerVirtualWorld(playerid, world);
    Streamer_Update(playerid);
    SendClientMessage(playerid, -1, "Визуальное обновление выполнено!");
    return 1;
}

stock SyncOwnableVehicleTuningData(vehicleid)
{
    if(!IsAOwnableCar(vehicleid)) return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0) return 0;

    vInfo[index][vSQLID] = GetOwnableCarData(index, OC_SQL_ID);
    vInfo[index][vModelID] = GetOwnableCarData(index, OC_MODEL_ID);
    vInfo[index][vFstate] = GetOwnableCarData(index, OC_FSTATE);
    vInfo[index][vNitro] = GetOwnableCarData(index, OC_NITRO);
    vInfo[index][vLaunchControl] = GetOwnableCarData(index, OC_LAUCH);
    vInfo[index][vExhaustSound] = GetOwnableCarData(index, OC_EXHAUST);
    vInfo[index][vHornSound] = GetOwnableCarData(index, OC_HORN);
    vInfo[index][vStrob] = GetOwnableCarData(index, OC_STROBOSCOPE);
    vInfo[index][IsHydroActive] = GetOwnableCarData(index, OC_isHydroActive);
    vInfo[index][IsHydroBought] = GetOwnableCarData(index, OC_isHydroBought);
    vInfo[index][IsFarLightActive] = GetOwnableCarData(index, OC_isFarLightActive);
    vInfo[index][IsFarLightBought] = GetOwnableCarData(index, OC_isFarLightBought);
    vInfo[index][SelectedPnevmo] = GetOwnableCarData(index, OC_PnevmoSelected);
    vInfo[index][IsPnevmoBought] = GetOwnableCarData(index, OC_isPnevmoBought);
    vInfo[index][iscase] = GetOwnableCarData(index, OC_ISCASE);
    vInfo[index][pdvradar] = GetOwnableCarData(index, OC_PDVRADAR);
    vInfo[index][percentofclirness] = GetOwnableCarData(index, OC_percentofclirness);
    vInfo[index][percentofclirnessz] = GetOwnableCarData(index, OC_percentofclirnessZ);
    vInfo[index][wheel_offset_ft] = GetOwnableCarData(index, OC_wheel_offset_ft);
    if(vInfo[index][wheel_offset_ft] == 0) vInfo[index][wheel_offset_ft] = 50;
    vInfo[index][wheel_offset_rr] = GetOwnableCarData(index, OC_wheel_offset_rr);
    if(vInfo[index][wheel_offset_rr] == 0) vInfo[index][wheel_offset_rr] = 50;
    vInfo[index][align_ft] = GetOwnableCarData(index, OC_align_ft);
    vInfo[index][align_rr] = GetOwnableCarData(index, OC_align_rr);
    vInfo[index][width_ft] = GetOwnableCarData(index, OC_width_ft);
    if(vInfo[index][width_ft] == 0) vInfo[index][width_ft] = 40;
    vInfo[index][width_rr] = GetOwnableCarData(index, OC_width_rr);
    if(vInfo[index][width_rr] == 0) vInfo[index][width_rr] = 40;
    vInfo[index][wheel_radius] = GetOwnableCarData(index, OC_wheel_radius);
    vInfo[index][wheel_colors] = GetOwnableCarData(index, OC_wheelcolors);
    vInfo[index][lights_color] = GetOwnableCarData(index, OC_lights_color);
    vInfo[index][underlights_color] = GetOwnableCarData(index, OC_underlights_color);
    vInfo[index][underlights_color_lf] = GetOwnableCarData(index, OC_underlights_color_lf);
    vInfo[index][underlights_color_rt] = GetOwnableCarData(index, OC_underlights_color_rt);
    vInfo[index][body_colors] = GetOwnableCarData(index, OC_body_colors);
    vInfo[index][tonir_ft] = GetOwnableCarData(index, OC_tonir_ft);
    vInfo[index][tonir_rr] = GetOwnableCarData(index, OC_tonir_rr);
    vInfo[index][wheel_comp] = GetOwnableCarData(index, OC_wheelcomp);
    vInfo[index][vComfort] = GetOwnableCarData(index, OC_COMFORT_PL);
    vInfo[index][vSport] = GetOwnableCarData(index, OC_SPORT);
    vInfo[index][vDrift] = GetOwnableCarData(index, OC_DRIFT);
    vInfo[index][vSportPlus] = GetOwnableCarData(index, OC_SPORT_PL);
    vInfo[index][vComfort1] = GetOwnableCarData(index, OC_COMFORT1);
    vInfo[index][vSport1] = GetOwnableCarData(index, OC_SPORT1);
    vInfo[index][vDrift1] = GetOwnableCarData(index, OC_DRIFT1);
    vInfo[index][vSportPlus1] = GetOwnableCarData(index, OC_SPORT_PL1);
    vInfo[index][vComfort2] = GetOwnableCarData(index, OC_COMFORT2);
    vInfo[index][vSport2] = GetOwnableCarData(index, OC_SPORT2);
    vInfo[index][vDrift2] = GetOwnableCarData(index, OC_DRIFT2);
    vInfo[index][vSportPlus2] = GetOwnableCarData(index, OC_SPORT_PL2);
    vInfo[index][vComfort3] = GetOwnableCarData(index, OC_COMFORT3);
    vInfo[index][vSport3] = GetOwnableCarData(index, OC_SPORT3);
    vInfo[index][vDrift3] = GetOwnableCarData(index, OC_DRIFT3);
    vInfo[index][vSportPlus3] = GetOwnableCarData(index, OC_SPORT_PL3);
    vInfo[index][vComfort4] = GetOwnableCarData(index, OC_COMFORT4);
    vInfo[index][vSport4] = GetOwnableCarData(index, OC_SPORT4);
    vInfo[index][vDrift4] = GetOwnableCarData(index, OC_DRIFT4);
    vInfo[index][vSportPlus4] = GetOwnableCarData(index, OC_SPORT_PL4);
    vInfo[index][vEnableNeon] = GetOwnableCarData(index, OC_EnableNeon);
    vInfo[index][exhsuast_current] = GetOwnableCarData(index, OC_exhsuast_current);
    vInfo[index][strab_current] = GetOwnableCarData(index, OC_strab_current);
    vInfo[index][horn_current] = GetOwnableCarData(index, OC_horn_current);
    vInfo[index][vinil_current] = GetOwnableCarData(index, OC_vinil_current);
    vInfo[index][vTonerFront] = GetOwnableCarData(index, OC_TONER_FRONT);
    vInfo[index][vTonerRear] = GetOwnableCarData(index, OC_TONER_REAR);
    vInfo[index][vLightColor] = GetOwnableCarData(index, OC_LIGHT_COLOR);
    vInfo[index][vNeon][0] = GetOwnableCarData(index, OC_NEON_CENTER);
    vInfo[index][vNeon][1] = GetOwnableCarData(index, OC_NEON_RIGHT);
    vInfo[index][vNeon][2] = GetOwnableCarData(index, OC_NEON_LEFT);
    format(vInfo[index][vynil_name], 32, "%s", g_ownable_car[index][OC_VINYL]);

    SetOwnableCarData(index, OC_SQL_ID, vInfo[index][vSQLID]);
    vInfo[vehicleid][vModelID] = vInfo[index][vModelID];
    vInfo[vehicleid][vFstate] = vInfo[index][vFstate];
    vInfo[vehicleid][vNitro] = vInfo[index][vNitro];
    vInfo[vehicleid][vExhaustSound] = vInfo[index][vExhaustSound];
    vInfo[vehicleid][vHornSound] = vInfo[index][vHornSound];
    vInfo[vehicleid][vStrob] = vInfo[index][vStrob];
    vInfo[vehicleid][strab_current] = vInfo[index][strab_current];
    vInfo[vehicleid][horn_current] = vInfo[index][horn_current];
    vInfo[vehicleid][vEnableNeon] = vInfo[index][vEnableNeon];
    return 1;
}
stock LoadTuning(playerid)
{
    new id = GetPlayerOwnableCar(playerid);
    if(id == -1 || id == INVALID_VEHICLE_ID) return printf("ID личного транспорта игрока не найден");

    new i = GetVehicleData(id, V_ACTION_ID);
    new Float:brake_power;
CarLights[GetPlayerOwnableCar(playerid)] = true;
CarLock[GetPlayerOwnableCar(playerid)] = true;
CarEngine[GetPlayerOwnableCar(playerid)] = true;
CarKey[GetPlayerOwnableCar(playerid)] = true;
    RemoveVehicleComponent(id, 1008);
    RemoveVehicleComponent(id, 1009);
    RemoveVehicleComponent(id, 1010);

    
    
    // Исправленный switch statement
    switch(GetOwnableCarData(i, OC_BRAKE))
    {
        case 1: 
        { 
            brake_power = 1.5;         
            vInfo[id][vBrakePower] = brake_power;
            ApplyBrakePower(id, brake_power);    
        }
        case 2: 
        { 
            brake_power = 2.0;         
            vInfo[id][vBrakePower] = brake_power;
            ApplyBrakePower(id, brake_power);    
        }
        case 3: 
        { 
            brake_power = 2.5;         
            vInfo[id][vBrakePower] = brake_power;
            ApplyBrakePower(id, brake_power);    
        }
        case 4: 
        { 
            brake_power = 3.0;         
            vInfo[id][vBrakePower] = brake_power;
            ApplyBrakePower(id, brake_power);    
        }
    }
    printf("[LoadTun] Set Brake_Power");

    if(GetOwnableCarData(i, OC_HIGHLIGHT)) 
    {
        vInfo[id][vHighLights] = 299;
        SetVehicleHighLight(id, 299, 1);
        printf("[LoadTun] Set HighLights");
    }

    vInfo[i][vStrob] = GetOwnableCarData(i, OC_STROBOSCOPE);
    vInfo[id][vStrob] = vInfo[i][vStrob];
    vInfo[i][strab_current] = GetOwnableCarData(i, OC_strab_current);
    vInfo[id][strab_current] = vInfo[i][strab_current];
    EnableStrob[id] = false;
    // Installed strobe survives load, but active/off is runtime state. RPC 5 is OFF.
    SetVehicleStroboscope(id, 5, 0);
    if(vInfo[i][vStrob] != 0)
        printf("[LoadTun] Stroboscope installed type=%d item=%d", vInfo[i][vStrob], vInfo[i][strab_current]);

    printf("[LoadTun] Set Exhaust");
    vInfo[i][vExhaustSound] = GetOwnableCarData(i, OC_EXHAUST);
    vInfo[id][vExhaustSound] = vInfo[i][vExhaustSound];
    if(vInfo[i][vExhaustSound] != 0)
        SetVehicleExhaust(id, vInfo[i][vExhaustSound], 1);

    vInfo[i][vHornSound] = GetOwnableCarData(i, OC_HORN);
    vInfo[id][vHornSound] = vInfo[i][vHornSound];
    // Do not send horn_id=0 while loading tuning; stock horn needs no RPC.
    

    if(GetOwnableCarData(i, OC_HYDRAULICS))
    {
        printf("[LoadTun] Set Hydraulics");
    }

    if(strlen(g_ownable_car[i][OC_VINYL]) != 0)
    {
        printf("[LoadTun] Set Vinyl %s", g_ownable_car[i][OC_VINYL]);
        format(vInfo[i][vynil_name], 32, "%s", g_ownable_car[i][OC_VINYL]);
        format(vInfo[id][vynil_name], 32, "%s", g_ownable_car[i][OC_VINYL]);
        SetVehicleVinylForPlayer(playerid, id, g_ownable_car[i][OC_VINYL]);
    }

	
    // V7: speed is calculated after the saved firmware state is loaded below.
    vInfo[i][vLaunchControl] = GetOwnableCarData(i, OC_LAUCH);
    vInfo[id][vLaunchControl] = vInfo[i][vLaunchControl];
    launch[playerid] = vInfo[i][vLaunchControl];
	vInfo[id][vSQLID] = GetOwnableCarData(i, OC_SQL_ID); 
	vInfo[id][vModelID] = GetOwnableCarData(i, OC_MODEL_ID); 
	vInfo[i][vFstate] = GetOwnableCarData(i, OC_FSTATE); 
    vInfo[id][vFstate] = vInfo[i][vFstate];
    TechCenter_ApplyPerformance(id);
	printf("[LoadTun] Set Firmware %d", vInfo[i][vFstate]);
	
	
	vInfo[i][vNitro]        = GetOwnableCarData(i, OC_NITRO);
	vInfo[i][IsHydroActive]        = GetOwnableCarData(i, OC_isHydroActive);
	vInfo[i][IsHydroBought]        = GetOwnableCarData(i, OC_isHydroBought);
	vInfo[i][IsFarLightActive]        = GetOwnableCarData(i, OC_isFarLightActive);
	vInfo[i][IsFarLightBought]        = GetOwnableCarData(i, OC_isFarLightBought);
	vInfo[i][SelectedPnevmo]        = GetOwnableCarData(i, OC_PnevmoSelected);
	vInfo[i][IsPnevmoBought]        = GetOwnableCarData(i, OC_isPnevmoBought);
	vInfo[i][iscase]        = GetOwnableCarData(i, OC_ISCASE);
	vInfo[i][pdvradar]        = GetOwnableCarData(i, OC_PDVRADAR);
	vInfo[i][percentofclirness]        = GetOwnableCarData(i, OC_percentofclirness);
	vInfo[i][percentofclirnessz]        = GetOwnableCarData(i, OC_percentofclirnessZ);
	vInfo[i][wheel_offset_ft] = GetOwnableCarData(i, OC_wheel_offset_ft);
	if (vInfo[i][wheel_offset_ft] == 0){
		vInfo[i][wheel_offset_ft] = 50;
	}
	vInfo[i][wheel_offset_rr] = GetOwnableCarData(i, OC_wheel_offset_rr);
	if (vInfo[i][wheel_offset_rr] == 0){
		vInfo[i][wheel_offset_rr] = 50;
	}
	vInfo[i][align_ft] = GetOwnableCarData(i, OC_align_ft);
	vInfo[i][align_rr] = GetOwnableCarData(i, OC_align_rr);
	vInfo[i][width_ft] = GetOwnableCarData(i, OC_width_ft);
	if (vInfo[i][width_ft] == 0){
		vInfo[i][width_ft] = 40;
	}
	vInfo[i][width_rr] = GetOwnableCarData(i, OC_width_rr);
	if (vInfo[i][width_rr] == 0){
		vInfo[i][width_rr] = 40;
	}
	vInfo[i][wheel_radius] = GetOwnableCarData(i, OC_wheel_radius);
	vInfo[i][wheel_colors]        = GetOwnableCarData(i, OC_wheelcolors);

	vInfo[i][lights_color]           = GetOwnableCarData(i, OC_lights_color);   
    vInfo[i][underlights_color]      = GetOwnableCarData(i, OC_underlights_color);  
    vInfo[i][underlights_color_lf]   = GetOwnableCarData(i, OC_underlights_color_lf);  
    vInfo[i][underlights_color_rt]   = GetOwnableCarData(i, OC_underlights_color_rt); 

	vInfo[i][body_colors]        = GetOwnableCarData(i, OC_body_colors);
	vInfo[i][tonir_ft]        = GetOwnableCarData(i, OC_tonir_ft);
	vInfo[i][tonir_rr]        = GetOwnableCarData(i, OC_tonir_rr);
	vInfo[i][wheel_comp]        = GetOwnableCarData(i, OC_wheelcomp);
    vInfo[i][vComfort]     = GetOwnableCarData(i, OC_COMFORT_PL);
    vInfo[i][vSport]       = GetOwnableCarData(i, OC_SPORT);
    vInfo[i][vDrift]       = GetOwnableCarData(i, OC_DRIFT);
    vInfo[i][vSportPlus]   = GetOwnableCarData(i, OC_SPORT_PL);
	vInfo[i][vEnableNeon]    = GetOwnableCarData(i, OC_EnableNeon);
	vInfo[i][exhsuast_current]    = GetOwnableCarData(i, OC_exhsuast_current);
	
	vInfo[i][strab_current]    = GetOwnableCarData(i, OC_strab_current);
	
	vInfo[i][horn_current]    = GetOwnableCarData(i, OC_horn_current);
	
    vInfo[i][vinil_current]      = GetOwnableCarData(i, OC_vinil_current);

    vInfo[id][vNitro] = vInfo[i][vNitro];
    vInfo[id][vExhaustSound] = vInfo[i][vExhaustSound];
    vInfo[id][vHornSound] = vInfo[i][vHornSound];
    vInfo[id][vStrob] = vInfo[i][vStrob];
    vInfo[id][strab_current] = vInfo[i][strab_current];
    vInfo[id][horn_current] = vInfo[i][horn_current];
    vInfo[id][IsHydroActive] = vInfo[i][IsHydroActive];
    vInfo[id][IsFarLightActive] = vInfo[i][IsFarLightActive];

    vInfo[i][vComfort1]    = GetOwnableCarData(i, OC_COMFORT1);
    vInfo[i][vSport1]      = GetOwnableCarData(i, OC_SPORT1);
    vInfo[i][vDrift1]      = GetOwnableCarData(i, OC_DRIFT1);
    vInfo[i][vSportPlus1]  = GetOwnableCarData(i, OC_SPORT_PL1);
    
    vInfo[i][vComfort2]    = GetOwnableCarData(i, OC_COMFORT2);
    vInfo[i][vSport2]      = GetOwnableCarData(i, OC_SPORT2);
    vInfo[i][vDrift2]      = GetOwnableCarData(i, OC_DRIFT2);
    vInfo[i][vSportPlus2]  = GetOwnableCarData(i, OC_SPORT_PL2);
    
    vInfo[i][vComfort3]    = GetOwnableCarData(i, OC_COMFORT3);
    vInfo[i][vSport3]      = GetOwnableCarData(i, OC_SPORT3);
    vInfo[i][vDrift3]      = GetOwnableCarData(i, OC_DRIFT3);
    vInfo[i][vSportPlus3]  = GetOwnableCarData(i, OC_SPORT_PL3);
    
    vInfo[i][vComfort4]    = GetOwnableCarData(i, OC_COMFORT4);
    vInfo[i][vSport4]      = GetOwnableCarData(i, OC_SPORT4);
    vInfo[i][vDrift4]      = GetOwnableCarData(i, OC_DRIFT4);
    vInfo[i][vSportPlus4]  = GetOwnableCarData(i, OC_SPORT_PL4);

    if(vInfo[i][vNitro] != 0) printf("[LoadTun] Set Nitro (%d)", vInfo[i][vNitro]);
	
    ChangeVehicleColor(id, GetOwnableCarData(i, OC_COLOR_1), GetOwnableCarData(i, OC_COLOR_2));
    printf("Vehicle colors: %d, %d", GetOwnableCarData(i, OC_COLOR_1), GetOwnableCarData(i, OC_COLOR_2));




    new hex = GetOwnableCarData(i, OC_LIGHT_COLOR);
    SetVehicleLightColor(id, hex, 1);
    printf("Light Color: %x", GetOwnableCarData(i, OC_LIGHT_COLOR));

    if(GetOwnableCarData(i, OC_TONER_FRONT))
    {
        printf("[LoadTun] Set TonerFront (%d)", GetOwnableCarData(i, OC_TONER_FRONT));
        vInfo[id][vTonerFront] = GetOwnableCarData(i, OC_TONER_FRONT);
        SetVehicleTint(id, GetOwnableCarData(i, OC_TONER_FRONT), 1);
    }

    if(GetOwnableCarData(i, OC_TONER_REAR))
    {
        printf("[LoadTun] Set TonerRear (%d)", GetOwnableCarData(i, OC_TONER_REAR));
        vInfo[id][vTonerRear] = GetOwnableCarData(i, OC_TONER_REAR);
        SetVehicleTint(id, GetOwnableCarData(i, OC_TONER_REAR), 1);
    }

    if(GetOwnableCarData(i, OC_NEON_CENTER) != 0)
    {
        printf("[LoadTun] Set NeonCenter");
        SetVehicleLightingColor(id, GetOwnableCarData(i, OC_NEON_CENTER), vInfo[id][vNeon][1], vInfo[id][vNeon][2], 1);
    }

    if(GetOwnableCarData(i, OC_NEON_RIGHT) != 0)
    {
        printf("[LoadTun] Set NeonRight");
        SetVehicleLightingColor(id, vInfo[id][vNeon][0], GetOwnableCarData(i, OC_NEON_RIGHT), vInfo[id][vNeon][2], 1);
    }
    
    if(GetOwnableCarData(i, OC_NEON_LEFT) != 0)
    {
        SetVehicleLightingColor(id, vInfo[id][vNeon][0], vInfo[id][vNeon][1], GetOwnableCarData(i, OC_NEON_LEFT), 1);
        printf("[LoadTun] Set NeonLeft");
    }

	ApplyOwnableVehicleNitro(playerid, id, vInfo[i][vNitro]);
	ApplyOwnableVehicleColors(id, i);
	Styling_QueueSuspension(id);
    TechCenter_ApplyPerformance(id);
	
    return 1;
}

CMD:testcasino(playerid, params[])
{
    TextDrawShowForPlayer(playerid, casino_TD[0]);
    SelectTextDraw(playerid, 0x00FF00FF); // Включаем выбор текстдравов (зелёный курсор)
    SendClientMessage(playerid, -1, "Текстдрав казино отображен! Кликни по нему.");
    return 1;
}
