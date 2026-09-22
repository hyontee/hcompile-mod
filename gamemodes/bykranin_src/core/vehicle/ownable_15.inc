//>> Файл: bykranin_src/core/vehicle/ownable_15.inc  (439 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: RandomNumberPlateByType, RandomNumberRegion, /plates, CheckPlayerOwnableCarLoaded, ShowWoundGUI, OwnableCarParkingInstructorTick, ApplyVehicleFirmware
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock RandomNumberPlateByType(numberType, plate[], size)
{
    switch (numberType)
    {
        case TYPE_RU:
        {
            static const letters[12] = {'a','b','c','e','h','k','m','o','p','t','x','y'};
            format(plate, size, "%c%d%d%d%c%c",
                letters[random(sizeof(letters))],
                random(10), random(10), random(10),
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))]);
        }
        case TYPE_UA:
        {
            static const letters[12] = {'A','B','C','E','H','K','M','O','P','T','X','Y'};
            format(plate, size, "%c%c %d%d%d%d %c%c",
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))],
                random(10), random(10), random(10), random(10),
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))]);
        }
        case TYPE_BY:
        {
            static const letters[12] = {'A','B','C','E','H','K','M','O','P','T','X','Y'};
            format(plate, size, "%d%d%d%d %c%c-%d",
                random(10), random(10), random(10), random(10),
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))],
                random(10));
        }
        case TYPE_KZ:
        {
            static const letters[12] = {'a','b','c','e','h','k','m','o','p','t','x','y'};
            format(plate, size, "%d%d%d%c%c%c",
                random(10), random(10), random(10),
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))],
                letters[random(sizeof(letters))]);
        }
        default:
        {
            format(plate, size, "UNKNOWN");
        }
    }
}

stock RandomNumberRegion(country, region[], size)
{
    switch (country)
    {
        case 0: format(region, size, "%02d", random(94) + 1);
        case 3: format(region, size, "%02d", random(17) + 1);
        default: format(region, size, "00");
    }
}

cmd:plates(playerid)
{
    DeletePVar(playerid, PVAR_PLATE_BUY_ACCESS);
    DeletePVar(playerid, PVAR_PLATE_BC_PRICE);
    ClearPlateDraftCache(playerid);
    gPlayerCountry[playerid] = -1;
    PlateDraft_EnsureLoaded(playerid);

    new JSON:json = JSON_Object();
    JSON_SetInt(json, "t", 0);
    ShowPlayerGUI(playerid, 1, json);
    ~json;
    return 1;
}

stock bool:CheckPlayerOwnableCarLoaded(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);

    if (vehicleid == INVALID_VEHICLE_ID)
    {
        if (GetPlayerOwnableCars(playerid) == 0)
            ShowNotificationNew(playerid, 2, 4, 0, 0, "У вас нет личного транспорта!", "");
        else
            ShowNotificationNew(playerid, 2, 4, 0, 0, "Ваш транспорт не загружен на сервер!", "");
        return false;
    }
    return true;
}
stock ShowWoundGUI(playerid, kilid)
{
 new JSON:JSONObject = JSON_Object();
 
 JSON_SetInt(JSONObject, "o", 1);
 JSON_SetInt(JSONObject, "id", kilid);
 JSON_SetString(JSONObject, "p", GetPlayerNameEx(kilid));
 
 ShowPlayerGUI(playerid, 40, JSONObject);
}
public OwnableCarParkingInstructorTick(playerid)
{
    if(!IsPlayerConnected(playerid)) return 0;

    new vehicleid = GetPVarInt(playerid, "ownable_vehicle_id");
    if(vehicleid == 0 || vehicleid == INVALID_VEHICLE_ID)
        goto __stop;

    new Float:px = GetPVarFloat(playerid, "park_x");
    new Float:py = GetPVarFloat(playerid, "park_y");
    new Float:pz = GetPVarFloat(playerid, "park_z");

    new Float:vx, Float:vy, Float:vz;
    GetVehiclePos(vehicleid, vx, vy, vz);

    if(GetDistanceBetweenCoords(vx, vy, vz, px, py, pz) > 20.0)
    {
        new JSON:close = JSON_Object();
        JSON_SetInt(close, "c", 1);
        OnPacketIncoming(playerid, 39, close);
        JSON_Cleanup(close);
        goto __stop;
    }

    new left = GetPVarInt(playerid, "park_hint_left");
    left--;
    SetPVarInt(playerid, "park_hint_left", left);

    if(left <= 0)
    {
        DestroyVehicle(vehicleid);

        new JSON:close2 = JSON_Object();
        JSON_SetInt(close2, "c", 1);
        OnPacketIncoming(playerid, 39, close2);
        JSON_Cleanup(close2);

        ShowNotificationNew(playerid, 3, 4, 0, 0, "Ваш транспорт отбуксирован!", "");

        goto __stop;
    }

    new msg[200];
    format(
        msg, sizeof msg,
        "Ваша машина удалится через <font color=#FFFF00>%d</font> сек., если вы не отъедете от парковки.",
        left
    );

    new JSON:update = JSON_Object();
    JSON_SetInt(update, "t", 0);
    JSON_SetString(update, "s", msg);
    OnPacketIncoming(playerid, 39, update);
    JSON_Cleanup(update);

    return 1;


__stop:
    if(GetPVarInt(playerid, "park_hint_timer"))
    {
        KillTimer(GetPVarInt(playerid, "park_hint_timer"));
        DeletePVar(playerid, "park_hint_timer");
    }
    DeletePVar(playerid, "park_hint_left");
    return 0;
}
forward ApplyVehicleFirmware(playerid, vehicleid);
public ApplyVehicleFirmware(playerid, vehicleid){
    if(IsAFamilyCar(vehicleid)) return 1; // Family firmware is applied from its own cache.
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_ADMIN_CAR) return 1;
	if (!IsPlayerConnected(playerid)) return 1;
    new i = GetVehicleData(vehicleid, V_ACTION_ID);
    TechCenter_ApplyPerformance(vehicleid);
	if (IsPlayerInAnyVehicle(playerid)){
		if (GetPlayerVehicleID(playerid) == vehicleid){
	        switch (vInfo[i][vFstate]){
	            case FSTATE_DRIFT:
	               SetVehicleDriftForPlayer(playerid, vehicleid, 1);
	            case FSTATE_COMFORT:
	                SendCarFirmware(playerid, FSTATE_COMFORT);
	            case FSTATE_SPORT:
	                SendCarFirmware(playerid, FSTATE_SPORT);
	            case FSTATE_SPORT_PLUS:
	                SendCarFirmware(playerid, FSTATE_SPORT_PLUS);
	        }
		}
	}
}


forward ApplyVehicleTuning(playerid, vehicleid);
public ApplyVehicleTuning(playerid, vehicleid)
{
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_ADMIN_CAR) return 1;
    if (!IsPlayerConnected(playerid)) return 1;
    new i = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_FAMILY_CAR)
    {
        new family_index = GetVehicleData(vehicleid, V_ACTION_ID);
        if(family_index < 0 || family_index >= MAX_OWNABLE_CARS) return 1;

        // Family cars use the same client component slots. Clear a component
        // left by an older vehicle with this ID and rebuild only valid parts.
        if(!g_tuning_additive_replay[playerid])
            RemoveAllVehicleComponentsForPlayer(playerid, vehicleid);
        FamilyCarApplyVehicleStoreComponents(
            vehicleid,
            GetCarFamily(family_index, CAR_F_database),
            playerid
        );

        new family_vinyl[32];
        ResolveFamilyCarVinylName(family_index, family_vinyl, sizeof family_vinyl, true);
        printf("[FAMILY CAR][APPLY TUNING] vehicleid=%d family_index=%d playerid=%d vinyl=%s", vehicleid, family_index, playerid, family_vinyl);
        if(family_vinyl[0] != '\0')
        {
            SetVehicleVinylForPlayer(playerid, vehicleid, family_vinyl);
        }
        if(GetCarFamily(family_index, V_F_LIGHTS_COLOR) != 0)
        {
            ddSetVehicleColorHexForPlayers(playerid, vehicleid, GetCarFamily(family_index, V_F_LIGHTS_COLOR));
        }
        if(GetCarFamily(family_index, V_F_UNDERLIGHT_COLOR) != 0 || GetCarFamily(family_index, V_F_UNDERLIGHT_COLOR_LF) != 0 || GetCarFamily(family_index, V_F_UNDERLIGHT_COLOR_RT) != 0)
        {
            SetVehicleNeonForPlayer(playerid, vehicleid, GetCarFamily(family_index, V_F_UNDERLIGHT_COLOR), GetCarFamily(family_index, V_F_UNDERLIGHT_COLOR_LF), GetCarFamily(family_index, V_F_UNDERLIGHT_COLOR_RT));
        }
        if(GetCarFamily(family_index, V_F_IS_FAR_LIGHT_ACTIVE))
        {
            SetVehicleFarLight(playerid, vehicleid, 1);
        }
        if(GetPlayerVehicleID(playerid) == vehicleid) switch(GetCarFamily(family_index, V_F_FSTATE))
        {
            case FSTATE_DRIFT:      SetVehicleDriftForPlayer(playerid, vehicleid, 1);
            case FSTATE_COMFORT:    SendCarFirmware(playerid, FSTATE_COMFORT);
            case FSTATE_SPORT:      SendCarFirmware(playerid, FSTATE_SPORT);
            case FSTATE_SPORT_PLUS: SendCarFirmware(playerid, FSTATE_SPORT_PLUS);
        }
        switch(GetCarFamily(family_index, V_F_SELECTED_PNEVMO))
        {
            case 1: SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.55);
            case 2: SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.35);
            case 3: SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.2);
        }
        if(!g_FT55_New[family_index] && GetCarFamily(family_index, V_F_PERCENT_CLR) > 0 && GetCarFamily(family_index, V_F_SELECTED_PNEVMO) == 0)
        {
            new Float:suspension = float(GetCarFamily(family_index, V_F_PERCENT_CLR)) / 50.0;
            if(suspension < 0.2) suspension = 0.2;
            SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, suspension);
        }
        if(!g_FT55_New[family_index] && GetCarFamily(family_index, V_F_PERCENT_CLR_Z) > 0)
        {
            new Float:suspension = float(GetCarFamily(family_index, V_F_PERCENT_CLR_Z)) / 100.0;
            if(suspension < 0.1) suspension = 0.1;
            if(suspension > 0.9) suspension = 0.9;
            SetVehicleSuspensionBiasFor(playerid, vehicleid, suspension);
        }
        if(GetCarFamily(family_index, V_F_IS_HYDRO_ACTIVE))
        {
            SetVehicleHydraulics(vehicleid, 1, 0);
        }
        new nitro_component = GetNitroComponentByLevel(GetCarFamily(family_index, V_F_NITRO));
        if(nitro_component > 0) AddToVehicleComponentForPlayer(playerid, vehicleid, nitro_component);
        if(GetPlayerVehicleID(playerid) == vehicleid)
        {
            launch[playerid] = GetCarFamily(family_index, V_F_LAUNCH);
        }
        FT55_Apply(playerid, vehicleid);
        return 1;
    }

    if(i < 0 || i >= MAX_OWNABLE_CARS)
    {
        return 1;
    }

    // A vehicle reload used to be the only path that refreshed these values.
    // Keep stream replays independent from a reload by rebuilding the runtime cache now.
    SyncOwnableVehicleTuningData(vehicleid);

    // A client can keep custom components when a server vehicle ID is reused.
    // Clear that local state first, then rebuild this vehicle from its own data.
    if(!g_tuning_additive_replay[playerid])
        RemoveAllVehicleComponentsForPlayer(playerid, vehicleid);
	
	if(vInfo[i][IsHydroActive]){
                SetVehicleHydraulics(vehicleid, 1, 0);
			}
    if(IsAOwnableCar(vehicleid)) Styling_ApplyWheels(playerid, vehicleid);
    if (!IsAOwnableCar(vehicleid) && (vInfo[i][wheel_comp] > 0))
    {
        new wheel_componentid = GetWheelTuneComponentId(vInfo[i][wheel_comp]);
        if(wheel_componentid > 0)
        {
	        AddToVehicleComponentForPlayer(playerid, vehicleid, wheel_componentid);
        }
    }

    if (vInfo[i][wheel_colors] != 0 || vInfo[i][body_colors] != 0)
        SetVehicleColorHexForPlayers(playerid, vehicleid, vInfo[i][body_colors], vInfo[i][wheel_colors]);

    if (!IsAOwnableCar(vehicleid) && (vInfo[i][wheel_offset_ft] > 0 || vInfo[i][wheel_offset_rr] > 0))
        SetVehicleWheelOffsetForPlayer(
            playerid,
            vehicleid,
            (vInfo[i][wheel_offset_ft] / 400.0) - 0.125,
            (vInfo[i][wheel_offset_rr] / 400.0) - 0.125
        );
	new modelid = GetOwnableCarData(i, OC_MODEL_ID);
	if (vInfo[i][iscase] > 0){
	   new name[64];
       GetRemapName(modelid, name, sizeof(name));
       printf("Bинил = %s",name);
		if (name[0] != '\0')
       {
           SetVehicleVinylForPlayer(playerid, vehicleid, name);
       }
	}
    if (!IsAOwnableCar(vehicleid) && (vInfo[i][align_ft] > 0 || vInfo[i][align_rr] > 0))
        SetVehicleWheelAlignForPlayer(
            playerid,
            vehicleid,
            (vInfo[i][align_ft] / -200.0),
            (vInfo[i][align_rr] / -200.0)
        );

    if (!IsAOwnableCar(vehicleid) && (vInfo[i][wheel_radius] > 0))
        SetVehicleWheelRadForPlayer(
            playerid,
            vehicleid,
            (vInfo[i][wheel_radius] / 250.0) + 0.7
        );

    if (!IsAOwnableCar(vehicleid) && (vInfo[i][width_ft] > 0 || vInfo[i][width_rr] > 0))
        SetVehicleWheelAddForPlayer(
            playerid,
            vehicleid,
            (vInfo[i][width_ft] / 80.0) + 0.5,
            (vInfo[i][width_rr] / 80.0) + 0.5
        );
       printf("Bинил = %s",vInfo[i][vynil_name]);
       if (vInfo[i][vynil_name][0] != '\0')
       {
           SetVehicleVinylForPlayer(playerid, vehicleid, vInfo[i][vynil_name]);
       }
	   if (vInfo[i][tonir_rr] != 0 || vInfo[i][tonir_ft] != 0)
	    SetVehicleColorTonrrHexForPlayers(playerid, vehicleid, vInfo[i][tonir_ft], vInfo[i][tonir_rr]);
	
	if(vInfo[i][lights_color] != 0)
	   ddSetVehicleColorHexForPlayers(playerid, vehicleid, vInfo[i][lights_color]);
	
    // Horn sound is intentionally NOT part of tuning replay. RPC 167/type 15
    // is client-side state and resending it on every stream/heal pass can retrigger
    // the horn on CRMP mobile clients. It is synchronized once from StreamIn instead.
	 if(vInfo[i][IsFarLightActive]){
		SetVehicleFarLight(playerid, vehicleid, 1);
	 }
	 if (vInfo[i][vExhaustSound] != 0)
        SetVehicleExhaustForPlayer(playerid, vehicleid, vInfo[i][vExhaustSound]-1);
	if(vInfo[i][vEnableNeon])
    {
		SetVehicleNeonForPlayer(playerid, vehicleid, vInfo[i][underlights_color], vInfo[i][underlights_color_lf], vInfo[i][underlights_color_rt]);
	}
	switch (vInfo[i][SelectedPnevmo]){
	    case 1:
	      SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.55);
	    case 2:
	      SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.35);
	    case 3:
	      SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, 0.2);
	}
	if (!IsAOwnableCar(vehicleid) && vInfo[i][percentofclirness] > 0 && vInfo[i][SelectedPnevmo] == 0){
		new Float:suspension = max(vInfo[i][percentofclirness] / 50.0, 0.2);
        SetVehicleSuspensionBiasForPlayer(playerid, vehicleid, suspension);
	}
	if (!IsAOwnableCar(vehicleid) && vInfo[i][percentofclirnessz] > 0){
		new suspension = min(max(vInfo[i][percentofclirnessz] / 100.0, 0.1), 0.9);
		
        SetVehicleSuspensionBiasFor(playerid, vehicleid, suspension);
	}
	if(vInfo[i][vStrob] != 0 && vInfo[i][strab_current] != 0 && EnableStrob[vehicleid])
	{
		SetVehicleStroboscopeForPlayere(playerid,vehicleid, vInfo[i][vStrob] - 1);
	}
	else
	{
		SetVehicleStroboscopeForPlayere(playerid,vehicleid, 5);
	}
    // Installed custom parts now live in the authoritative runtime snapshot
    // attached to this vehicleid. No SQL query is performed while streaming.
    PermanentTuning_ApplyComponentsForPlayer(playerid, vehicleid);
	ApplyOwnableVehicleNitro(playerid, vehicleid, vInfo[i][vNitro]);
}


forward OwnableCar_ReapplyTuningSafe(playerid, vehicleid, accountid, sqlid);
public OwnableCar_ReapplyTuningSafe(playerid, vehicleid, accountid, sqlid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid)) return 0;
    if(GetPlayerAccountID(playerid) != accountid) return 0;
    if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 0;
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR) return 0;

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || index >= MAX_OWNABLE_CARS) return 0;
    if(GetOwnableCarData(index, OC_SQL_ID) != sqlid) return 0;
    if(GetOwnableCarData(index, OC_OWNER_ID) != accountid) return 0;

    ApplyVehicleTuning(playerid, vehicleid);
    ApplyVehicleFirmware(playerid, vehicleid);
    Styling_QueueSuspension(vehicleid);
    FT55_Queue(vehicleid);

    printf("[OWNABLE_TUNING][REAPPLY] player=%d vehicle=%d car=%d", playerid, vehicleid, sqlid);
    return 1;
}

forward ApplyExhu(playerid, vehicleid);
public ApplyExhu(playerid, vehicleid)
{
    if (!IsPlayerConnected(playerid)) return 1;
    if(vehicleid == 0) return 1;

    new i = GetVehicleData(vehicleid, V_ACTION_ID);
    if(i < 0) return 1;

    // Horn synchronization is intentionally absent here. ApplyExhu is a visual/audio
    // tuning replay and must never touch the stock horn state.

    if(vInfo[i][vStrob] == 0 || vInfo[i][strab_current] == 0 || !EnableStrob[vehicleid])
        SetVehicleStroboscope(vehicleid, 5, 0);

    return 1;
}
stock Float:GetDistanceBetweenCoords(Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2)
{
    new Float:dx = x1 - x2;
    new Float:dy = y1 - y2;
    new Float:dz = z1 - z2;
    return floatsqroot(dx*dx + dy*dy + dz*dz);
}
