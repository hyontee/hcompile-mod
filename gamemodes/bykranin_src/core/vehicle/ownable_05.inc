//>> Файл: bykranin_src/core/vehicle/ownable_05.inc  (582 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: EntranceStatusInit, LoadOwnableCars, LoadOwnableCar, GetFreeOwnableCarID, UnloadPlayerOwnableCar, UnloadOwnableCarBySqlID, LoadTrunks
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: EntranceStatusInit(entranceid)
{
	new e_houses = 0;
	for(new idx; idx < g_house_loaded; idx ++)
	{
		if(GetHouseData(idx, H_ENTRACE) != entranceid) continue;
		if(!IsHouseOwned(idx)) continue;

		e_houses ++;
	}
	UpdateEntrance(entranceid, e_houses);
}

public: LoadOwnableCars()
{
	new rows, vehicleid;
	new Cache: result;

	result = mysql_query(mysql, "SELECT oc.*, IFNULL(a.name, 'None') AS owner_name FROM ownable_cars oc LEFT JOIN accounts a ON a.id = oc.owner_id", true);
	rows = cache_num_rows(result);

	if(rows > MAX_OWNABLE_CARS)
	{
		rows = MAX_OWNABLE_CARS;
		print("[OwnableCars]: DB rows > MAX_OWNABLE_CARS");
	}
	for(new idx; idx < rows; idx ++)
	{
		SetOwnableCarData(idx, OC_SQL_ID, 		cache_get_field_content_int(idx, "id"));
		SetOwnableCarData(idx, OC_OWNER_ID, 	cache_get_field_content_int(idx, "owner_id"));

		SetOwnableCarData(idx, OC_MODEL_ID, 	cache_get_field_content_int(idx, "model_id"));
		SetOwnableCarData(idx, OC_COLOR_1, 		cache_get_field_content_int(idx, "color_1"));
		SetOwnableCarData(idx, OC_COLOR_2, 		cache_get_field_content_int(idx, "color_2"));

		SetOwnableCarData(idx, OC_POS_X, 		cache_get_field_content_float(idx, "pos_x"));
		SetOwnableCarData(idx, OC_POS_Y, 		cache_get_field_content_float(idx, "pos_y"));
		SetOwnableCarData(idx, OC_POS_Z, 		cache_get_field_content_float(idx, "pos_z"));
		SetOwnableCarData(idx, OC_ANGLE, 		cache_get_field_content_float(idx, "angle"));

		cache_get_field_content(idx, "number", g_ownable_car[idx][OC_NUMBER], mysql, 32);

		SetOwnableCarData(idx, OC_ALARM, 		bool: cache_get_field_content_int(idx, "alarm"));
		SetOwnableCarData(idx, OC_KEY_IN, 		bool: cache_get_field_content_int(idx, "key_in"));

		SetOwnableCarData(idx, OC_CREATE, 		cache_get_field_content_int(idx, "create_time"));
		SetOwnableCarData(idx, OC_VINILCAR, 		cache_get_field_content_int(idx, "vinilcar"));
		
		SetOwnableCarData(idx, OC_PT_ENGINE, 	cache_get_field_content_int(idx, "pt_engine"));
		SetOwnableCarData(idx, OC_PT_BRAKE, 	cache_get_field_content_int(idx, "pt_brake"));
		SetOwnableCarData(idx, OC_PT_STABILITY, cache_get_field_content_int(idx, "pt_stability"));
		SetOwnableCarData(idx, 	OC_COMFORT_PL,	cache_get_field_content_int(idx, "comfort"));
		SetOwnableCarData(idx, 	OC_SPORT,	cache_get_field_content_int(idx, "sport"));
		SetOwnableCarData(idx, 	OC_SPORT_PL,	cache_get_field_content_int(idx, "sport_plus"));
		SetOwnableCarData(idx, 	OC_DRIFT,	cache_get_field_content_int(idx, "drift"));
		// Slot 1
        SetOwnableCarData(idx, OC_COMFORT1,   cache_get_field_content_int(idx, "comfort1"));
		
        SetOwnableCarData(idx, OC_vinil_current,   cache_get_field_content_int(idx, "vinil_current"));
		SetOwnableCarData(idx, OC_exhsuast_current,   cache_get_field_content_int(idx, "exhsuast_current"));
		SetOwnableCarData(idx, OC_strab_current,   cache_get_field_content_int(idx, "strab_current"));
		
		SetOwnableCarData(idx, OC_EnableNeon,   cache_get_field_content_int(idx, "EnableNeon"));
		SetOwnableCarData(idx, OC_horn_current,   cache_get_field_content_int(idx, "horn_current"));
		
        SetOwnableCarData(idx, OC_SPORT1,     cache_get_field_content_int(idx, "sport1"));
        SetOwnableCarData(idx, OC_DRIFT1,     cache_get_field_content_int(idx, "drift1"));
        SetOwnableCarData(idx, OC_SPORT_PL1,  cache_get_field_content_int(idx, "sport_plus1"));
        
        // Slot 2
        SetOwnableCarData(idx, OC_COMFORT2,   cache_get_field_content_int(idx, "comfort2"));
        SetOwnableCarData(idx, OC_SPORT2,     cache_get_field_content_int(idx, "sport2"));
        SetOwnableCarData(idx, OC_DRIFT2,     cache_get_field_content_int(idx, "drift2"));
        SetOwnableCarData(idx, OC_SPORT_PL2,  cache_get_field_content_int(idx, "sport_plus2"));
        
        // Slot 3
        SetOwnableCarData(idx, OC_COMFORT3,   cache_get_field_content_int(idx, "comfort3"));
        SetOwnableCarData(idx, OC_SPORT3,     cache_get_field_content_int(idx, "sport3"));
        SetOwnableCarData(idx, OC_DRIFT3,     cache_get_field_content_int(idx, "drift3"));
        SetOwnableCarData(idx, OC_SPORT_PL3,  cache_get_field_content_int(idx, "sport_plus3"));
        
        // Slot 4
        SetOwnableCarData(idx, OC_COMFORT4,   cache_get_field_content_int(idx, "comfort4"));
        SetOwnableCarData(idx, OC_SPORT4,     cache_get_field_content_int(idx, "sport4"));
        SetOwnableCarData(idx, OC_DRIFT4,     cache_get_field_content_int(idx, "drift4"));
        SetOwnableCarData(idx, OC_SPORT_PL4,  cache_get_field_content_int(idx, "sport_plus4"));
        SetOwnableCarData(idx, OC_BRAKE,         cache_get_field_content_int(idx, "brake_level"));
        SetOwnableCarData(idx, OC_HIGHLIGHT,     cache_get_field_content_int(idx, "highlight_type"));
        SetOwnableCarData(idx, OC_STROBOSCOPE,   cache_get_field_content_int(idx, "stroboscope_type"));
        SetOwnableCarData(idx, OC_EXHAUST,       cache_get_field_content_int(idx, "exhaust_type"));
        SetOwnableCarData(idx, OC_HORN,          cache_get_field_content_int(idx, "horn_id"));
        SetOwnableCarData(idx, OC_HYDRAULICS,    cache_get_field_content_int(idx, "hydraulic"));
        cache_get_field_content(idx, "vynil_name", g_ownable_car[idx][OC_VINYL], mysql, 32);
        SetOwnableCarData(idx, OC_LAUCH,         cache_get_field_content_int(idx, "launch"));
        SetOwnableCarData(idx, OC_NITRO,         cache_get_field_content_int(idx, "nitro_level"));
        SetOwnableCarData(idx, OC_isHydroActive, cache_get_field_content_int(idx, "is_hydro_active"));
        SetOwnableCarData(idx, OC_isHydroBought, cache_get_field_content_int(idx, "is_hydro_bought"));
        SetOwnableCarData(idx, OC_isFarLightBought, cache_get_field_content_int(idx, "is_FarLight_bought"));
        SetOwnableCarData(idx, OC_isFarLightActive, cache_get_field_content_int(idx, "is_FarLight_active"));
        SetOwnableCarData(idx, OC_PnevmoSelected, cache_get_field_content_int(idx, "pnevmo_selected"));
        SetOwnableCarData(idx, OC_isPnevmoBought, cache_get_field_content_int(idx, "is_pnevmo_bought"));
        SetOwnableCarData(idx, OC_PDVRADAR,      cache_get_field_content_int(idx, "pdvradar"));
        cache_get_field_content(idx, "vynil_name", vInfo[idx][vynil_name]);
        SetOwnableCarData(idx, OC_ISCASE,        cache_get_field_content_int(idx, "iscase"));
        SetOwnableCarData(idx, OC_percentofclirness,  cache_get_field_content_int(idx, "percentofclirness"));
        SetOwnableCarData(idx, OC_percentofclirnessZ, cache_get_field_content_int(idx, "percentofclirnessZ"));
        SetOwnableCarData(idx, OC_wheel_offset_ft, cache_get_field_content_int(idx, "wheel_offset_ft"));
        SetOwnableCarData(idx, OC_wheel_offset_rr, cache_get_field_content_int(idx, "wheel_offset_rr"));
        SetOwnableCarData(idx, OC_align_ft,      cache_get_field_content_int(idx, "align_ft"));
        SetOwnableCarData(idx, OC_align_rr,      cache_get_field_content_int(idx, "align_rr"));
        SetOwnableCarData(idx, OC_width_ft,      cache_get_field_content_int(idx, "width_ft"));
        SetOwnableCarData(idx, OC_width_rr,      cache_get_field_content_int(idx, "width_rr"));
        SetOwnableCarData(idx, OC_wheel_radius,  cache_get_field_content_int(idx, "wheel_radius"));
        SetOwnableCarData(idx, OC_wheelcolors,   cache_get_field_content_int(idx, "wheel_colors"));
        SetOwnableCarData(idx, OC_lights_color,  cache_get_field_content_int(idx, "lights_color"));
        SetOwnableCarData(idx, OC_underlights_color,    cache_get_field_content_int(idx, "underlights_color"));
        SetOwnableCarData(idx, OC_underlights_color_lf, cache_get_field_content_int(idx, "underlights_color_lf"));
        SetOwnableCarData(idx, OC_underlights_color_rt, cache_get_field_content_int(idx, "underlights_color_rt"));
        SetOwnableCarData(idx, OC_body_colors,   cache_get_field_content_int(idx, "body_colors"));
        SetOwnableCarData(idx, OC_tonir_ft,      cache_get_field_content_int(idx, "tonir_ft"));
        SetOwnableCarData(idx, OC_tonir_rr,      cache_get_field_content_int(idx, "tonir_rr"));
        SetOwnableCarData(idx, OC_wheelcomp,     cache_get_field_content_int(idx, "wheel_comp"));
        SetOwnableCarData(idx, OC_FSTATE,        cache_get_field_content_int(idx, "f_state"));
        SetOwnableCarData(idx, OC_SUPERCHARGER,  cache_get_field_content_int(idx, "supercharger"));
        SetOwnableCarData(idx, OC_PT_TURBO,      cache_get_field_content_int(idx, "pt_turbo"));

        new tuning_hex_string[18];
        cache_get_field_content(idx, "color_body_r", tuning_hex_string);
        sscanf(tuning_hex_string, "x", g_ownable_car[idx][OC_COLOR_BODY_R]);
        cache_get_field_content(idx, "color_body_g", tuning_hex_string);
        sscanf(tuning_hex_string, "x", g_ownable_car[idx][OC_COLOR_BODY_G]);
        cache_get_field_content(idx, "color_wheels", tuning_hex_string);
        sscanf(tuning_hex_string, "x", g_ownable_car[idx][OC_COLOR_WHEELS]);
        cache_get_field_content(idx, "light_color", tuning_hex_string);
        sscanf(tuning_hex_string, "x", g_ownable_car[idx][OC_LIGHT_COLOR]);
        cache_get_field_content(idx, "neon_center", tuning_hex_string);
        if(tuning_hex_string[0] == EOS) SetOwnableCarData(idx, OC_NEON_CENTER, 0);
        else sscanf(tuning_hex_string, "x", GetOwnableCarData(idx, OC_NEON_CENTER));
        cache_get_field_content(idx, "neon_left", tuning_hex_string);
        if(tuning_hex_string[0] == EOS) SetOwnableCarData(idx, OC_NEON_LEFT, 0);
        else sscanf(tuning_hex_string, "x", GetOwnableCarData(idx, OC_NEON_LEFT));
        cache_get_field_content(idx, "neon_right", tuning_hex_string);
        if(tuning_hex_string[0] == EOS) SetOwnableCarData(idx, OC_NEON_RIGHT, 0);
        else sscanf(tuning_hex_string, "x", GetOwnableCarData(idx, OC_NEON_RIGHT));
        SetOwnableCarData(idx, OC_TONER_FRONT,   cache_get_field_content_int(idx, "toner_front"));
        SetOwnableCarData(idx, OC_TONER_REAR,    cache_get_field_content_int(idx, "toner_rear"));
		// cache_get_field_content(idx, "owner_name", g_ownable_car[idx][OC_OWNER_NAME], mysql, 21);
		// ----------------------------------------------------------------------------------------

		new tmp_plate_type;
		new tmp_plate[16], tmp_region[8];
		if(!ParseStoredPlateValue(g_ownable_car[idx][OC_NUMBER], tmp_plate_type, tmp_plate, sizeof(tmp_plate), tmp_region, sizeof(tmp_region)))
			strmid(g_ownable_car[idx][OC_NUMBER], "------", 0, 8, 32);

		vehicleid = CreateVehicle
		(
			GetOwnableCarData(idx, OC_MODEL_ID),
			GetOwnableCarData(idx, OC_POS_X),
			GetOwnableCarData(idx, OC_POS_Y),
			GetOwnableCarData(idx, OC_POS_Z),
			GetOwnableCarData(idx, OC_ANGLE),
			GetOwnableCarData(idx, OC_COLOR_1),
			GetOwnableCarData(idx, OC_COLOR_2),
			-1,
			0,
			VEHICLE_ACTION_TYPE_OWNABLE_CAR,
			idx
		);
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			//CreateVehicleLabel(vehicleid, GetOwnableCarData(idx, OC_NUMBER), 0xFFFF00EE, 0.0, 0.0, 1.3, 20.0);
			//index = GetVehicleData(vehicleid, V_ACTION_ID);
            format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
            ApplyOwnableCarStoredPlate(vehicleid, idx);
			SetVehicleParam(vehicleid, V_LOCK, bool: cache_get_field_content_int(idx, "status"));
			// `ownable_cars.alarm` historically stored the *active* GTA alarm flag.
            // Restoring it on spawn makes the stock alarm honk forever. Alarm is session-only:
            // every new vehicle entity starts with the alarm OFF.
            SetVehicleParam(vehicleid, V_ALARM, VEHICLE_PARAM_OFF);
            SetOwnableCarData(idx, OC_ALARM, false);

			new Float:loaded_mileage = cache_get_field_content_float(idx, "mileage");
            new Float:loaded_fuel = cache_get_field_content_float(idx, "fuel");
            if(loaded_fuel < 0.0) loaded_fuel = 40.0;
            SetVehicleData(vehicleid, V_MILEAGE, loaded_mileage);
            SetVehicleData(vehicleid, V_FUEL, loaded_fuel);
            SetVehicleSpeedometerInfo(vehicleid, loaded_fuel, loaded_mileage);
            g_ownable_mileage_saved[vehicleid] = loaded_mileage;
            g_ownable_mileage_sync_time[vehicleid] = gettime();
            g_ownable_fuel_saved[vehicleid] = loaded_fuel;
            g_ownable_fuel_sync_time[vehicleid] = gettime();
		}
	}
	g_ownable_car_loaded = rows;
	cache_delete(result);

	printf("[OwnableCars]: Личных авто загружено: %d", g_ownable_car_loaded);
}

public: LoadOwnableCar(oc_id)
{
	if(g_ownable_car_loaded + 1 > MAX_OWNABLE_CARS)
	{
		print("[OwnableCars]: Ошибка в загрузке. Превышен лимит личного транспорта (MAX_OWNABLE_CARS)");
		return -1;
	}

	new query[55],
		Cache: result,
		vehicleid;

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ownable_cars WHERE id='%d' LIMIT 1", oc_id);
	result = mysql_query(mysql, query, true);

	new idx = GetFreeOwnableCarID();
	SetOwnableCarData(idx, OC_SQL_ID, 		cache_get_field_content_int(0, "id"));
	SetOwnableCarData(idx, OC_OWNER_ID, 	cache_get_field_content_int(0, "owner_id"));

	SetOwnableCarData(idx, OC_MODEL_ID, 	cache_get_field_content_int(0, "model_id"));
	SetOwnableCarData(idx, OC_COLOR_1, 		cache_get_field_content_int(0, "color_1"));
	SetOwnableCarData(idx, OC_COLOR_2, 		cache_get_field_content_int(0, "color_2"));

	SetOwnableCarData(idx, OC_POS_X, 		cache_get_field_content_float(0, "pos_x"));
	SetOwnableCarData(idx, OC_POS_Y, 		cache_get_field_content_float(0, "pos_y"));
	SetOwnableCarData(idx, OC_POS_Z, 		cache_get_field_content_float(0, "pos_z"));
	SetOwnableCarData(idx, OC_ANGLE, 		cache_get_field_content_float(0, "angle"));

	cache_get_field_content(0, "number", g_ownable_car[idx][OC_NUMBER], mysql, 32);

	SetOwnableCarData(idx, OC_ALARM, 		bool: cache_get_field_content_int(0, "alarm"));
	SetOwnableCarData(idx, OC_KEY_IN, 		bool: cache_get_field_content_int(0, "key_in"));

	SetOwnableCarData(idx, OC_CREATE, 		cache_get_field_content_int(0, "create_time"));
	SetOwnableCarData(idx, OC_VINILCAR, 		cache_get_field_content_int(0, "vinilcar"));
	// Slot 1
	SetOwnableCarData(idx, OC_vinil_current,   cache_get_field_content_int(0, "vinil_current"));
		SetOwnableCarData(idx, OC_exhsuast_current,   cache_get_field_content_int(0, "exhsuast_current"));
		SetOwnableCarData(idx, OC_strab_current,   cache_get_field_content_int(0, "strab_current"));
		SetOwnableCarData(idx, OC_EnableNeon,   cache_get_field_content_int(0, "EnableNeon"));
		SetOwnableCarData(idx, OC_horn_current,   cache_get_field_content_int(0, "horn_current"));
SetOwnableCarData(idx, OC_COMFORT1,   cache_get_field_content_int(0, "comfort1"));
SetOwnableCarData(idx, OC_SPORT1,     cache_get_field_content_int(0, "sport1"));
SetOwnableCarData(idx, OC_DRIFT1,     cache_get_field_content_int(0, "drift1"));
SetOwnableCarData(idx, OC_SPORT_PL1,  cache_get_field_content_int(0, "sport_plus1"));

// Slot 2
SetOwnableCarData(idx, OC_COMFORT2,   cache_get_field_content_int(0, "comfort2"));
SetOwnableCarData(idx, OC_SPORT2,     cache_get_field_content_int(0, "sport2"));
SetOwnableCarData(idx, OC_DRIFT2,     cache_get_field_content_int(0, "drift2"));
SetOwnableCarData(idx, OC_SPORT_PL2,  cache_get_field_content_int(0, "sport_plus2"));

// Slot 3
SetOwnableCarData(idx, OC_COMFORT3,   cache_get_field_content_int(0, "comfort3"));
SetOwnableCarData(idx, OC_SPORT3,     cache_get_field_content_int(0, "sport3"));
SetOwnableCarData(idx, OC_DRIFT3,     cache_get_field_content_int(0, "drift3"));
SetOwnableCarData(idx, OC_SPORT_PL3,  cache_get_field_content_int(0, "sport_plus3"));

// Slot 4
SetOwnableCarData(idx, OC_COMFORT4,   cache_get_field_content_int(0, "comfort4"));
SetOwnableCarData(idx, OC_SPORT4,     cache_get_field_content_int(0, "sport4"));
SetOwnableCarData(idx, OC_DRIFT4,     cache_get_field_content_int(0, "drift4"));
SetOwnableCarData(idx, OC_SPORT_PL4,  cache_get_field_content_int(0, "sport_plus4"));
	SetOwnableCarData(idx, OC_COMFORT_PL, 		cache_get_field_content_int(0, "comfort"));
	SetOwnableCarData(idx, OC_SPORT, 		cache_get_field_content_int(0, "sport"));
	SetOwnableCarData(idx, OC_SPORT_PL, 		cache_get_field_content_int(0, "sport_plus"));
	SetOwnableCarData(idx, OC_DRIFT, 		cache_get_field_content_int(0, "drift"));

	SetOwnableCarData(idx, OC_BRAKE, 		cache_get_field_content_int(0, "brake_level"));
	SetOwnableCarData(idx, OC_HIGHLIGHT, 		cache_get_field_content_int(0, "highlight_type"));
	SetOwnableCarData(idx, OC_STROBOSCOPE, 		cache_get_field_content_int(0, "stroboscope_type"));
	SetOwnableCarData(idx, OC_EXHAUST, 		cache_get_field_content_int(0, "exhaust_type"));
	SetOwnableCarData(idx, OC_HORN, 		cache_get_field_content_int(0, "horn_id"));
	SetOwnableCarData(idx, OC_HYDRAULICS, 		cache_get_field_content_int(0, "hydraulic"));
	cache_get_field_content(0, "vynil_name", g_ownable_car[idx][OC_VINYL], mysql, 32);
	

	SetOwnableCarData(idx, OC_PT_BRAKE, 		cache_get_field_content_int(0, "pt_brake"));
	SetOwnableCarData(idx, OC_PT_STABILITY, 	cache_get_field_content_int(0, "pt_stability"));

	SetOwnableCarData(idx, OC_PT_ENGINE, 		cache_get_field_content_int(0, "pt_engine"));
	SetOwnableCarData(idx, OC_LAUCH, 		    cache_get_field_content_int(0, "launch"));
	SetOwnableCarData(idx, OC_NITRO, 		    cache_get_field_content_int(0, "nitro_level"));
	
	SetOwnableCarData(idx, OC_isHydroActive, 		    cache_get_field_content_int(0, "is_hydro_active"));
	SetOwnableCarData(idx, OC_isHydroBought, 		    cache_get_field_content_int(0, "is_hydro_bought"));
	SetOwnableCarData(idx, OC_isFarLightBought, 		    cache_get_field_content_int(0, "is_FarLight_bought"));
	SetOwnableCarData(idx, OC_isFarLightActive, 		    cache_get_field_content_int(0, "is_FarLight_active"));
	
	SetOwnableCarData(idx, OC_PnevmoSelected, 		    cache_get_field_content_int(0, "pnevmo_selected"));
	SetOwnableCarData(idx, OC_isPnevmoBought, 		    cache_get_field_content_int(0, "is_pnevmo_bought"));
	SetOwnableCarData(idx, OC_PDVRADAR, 		    cache_get_field_content_int(0, "pdvradar"));
	cache_get_field_content(0, "vynil_name", vInfo[idx][vynil_name]);
	SetOwnableCarData(idx, OC_ISCASE, 		    cache_get_field_content_int(0, "iscase"));
	SetOwnableCarData(idx, OC_percentofclirness, 		    cache_get_field_content_int(0, "percentofclirness"));
	SetOwnableCarData(idx, OC_percentofclirnessZ, 		    cache_get_field_content_int(0, "percentofclirnessZ"));
	SetOwnableCarData(idx, OC_wheel_offset_ft,     cache_get_field_content_int(0, "wheel_offset_ft"));
	SetOwnableCarData(idx, OC_wheel_offset_rr,     cache_get_field_content_int(0, "wheel_offset_rr"));
	SetOwnableCarData(idx, OC_align_ft,            cache_get_field_content_int(0, "align_ft"));
	SetOwnableCarData(idx, OC_align_rr,            cache_get_field_content_int(0, "align_rr"));
	SetOwnableCarData(idx, OC_width_ft,            cache_get_field_content_int(0, "width_ft"));
	SetOwnableCarData(idx, OC_width_rr,            cache_get_field_content_int(0, "width_rr"));
	SetOwnableCarData(idx, OC_wheel_radius,        cache_get_field_content_int(0, "wheel_radius"));
	SetOwnableCarData(idx, OC_wheelcolors, 		    cache_get_field_content_int(0, "wheel_colors"));
	SetOwnableCarData(idx, OC_lights_color,          cache_get_field_content_int(0, "lights_color"));
    SetOwnableCarData(idx, OC_underlights_color,     cache_get_field_content_int(0, "underlights_color"));
    SetOwnableCarData(idx, OC_underlights_color_lf, cache_get_field_content_int(0, "underlights_color_lf"));
    SetOwnableCarData(idx, OC_underlights_color_rt, cache_get_field_content_int(0, "underlights_color_rt"));    
	SetOwnableCarData(idx, OC_body_colors, 		    cache_get_field_content_int(0, "body_colors"));
	SetOwnableCarData(idx, OC_tonir_ft, 		    cache_get_field_content_int(0, "tonir_ft"));
	SetOwnableCarData(idx, OC_tonir_rr, 		    cache_get_field_content_int(0, "tonir_rr"));
	SetOwnableCarData(idx, OC_wheelcomp, 		    cache_get_field_content_int(0, "wheel_comp"));
	SetOwnableCarData(idx, OC_FSTATE, 		    cache_get_field_content_int(0, "f_state"));
	SetOwnableCarData(idx, OC_SUPERCHARGER, 	cache_get_field_content_int(0, "supercharger"));
	SetOwnableCarData(idx, OC_PT_TURBO, 		cache_get_field_content_int(0, "pt_turbo"));

	new string[18], hex;

	cache_get_field_content(0, "color_body_r", string);
	sscanf(string, "x", g_ownable_car[idx][OC_COLOR_BODY_R]);
	cache_get_field_content(0, "color_body_g", string);
	sscanf(string, "x", g_ownable_car[idx][OC_COLOR_BODY_G]);
	cache_get_field_content(0, "color_wheels", string);
	sscanf(string, "x", g_ownable_car[idx][OC_COLOR_WHEELS]);
	cache_get_field_content(0, "light_color", string);
	sscanf(string, "x", g_ownable_car[idx][OC_LIGHT_COLOR]);

	cache_get_field_content(0, "neon_center", string);
	if(strfind(string, "") != -1) SetOwnableCarData(idx, OC_NEON_CENTER, 0);
	else sscanf(string, "x", GetOwnableCarData(idx, OC_NEON_CENTER));
	cache_get_field_content(0, "neon_left", string);
	if(strfind(string, "") != -1) SetOwnableCarData(idx, OC_NEON_LEFT, 0);
	else sscanf(string, "x", GetOwnableCarData(idx, OC_NEON_LEFT));
	cache_get_field_content(0, "neon_right", string);
	if(strfind(string, "") != -1) SetOwnableCarData(idx, OC_NEON_RIGHT, 0);
	else sscanf(string, "x", GetOwnableCarData(idx, OC_NEON_RIGHT));

	SetOwnableCarData(idx, OC_TONER_FRONT, 		cache_get_field_content_int(0, "toner_front"));
	SetOwnableCarData(idx, OC_TONER_REAR, 		cache_get_field_content_int(0, "toner_rear"));




	// cache_get_field_content(0, "owner_name", g_ownable_car[idx][OC_OWNER_NAME], mysql, 21);

	// ----------------------------------------------------------------------------------------

	new tmp_plate_type;
	new tmp_plate[16], tmp_region[8];
	if(!ParseStoredPlateValue(g_ownable_car[idx][OC_NUMBER], tmp_plate_type, tmp_plate, sizeof(tmp_plate), tmp_region, sizeof(tmp_region)))
		strmid(g_ownable_car[idx][OC_NUMBER], "------", 0, 8, 32);

	new Float:ownable_spawn_x = GetOwnableCarData(idx, OC_POS_X),
		Float:ownable_spawn_y = GetOwnableCarData(idx, OC_POS_Y),
		Float:ownable_spawn_z = GetOwnableCarData(idx, OC_POS_Z),
		Float:ownable_spawn_a = GetOwnableCarData(idx, OC_ANGLE);
	GarageSys_ConsumeOwnableSpawnOverride(oc_id, ownable_spawn_x, ownable_spawn_y, ownable_spawn_z, ownable_spawn_a);

	vehicleid = CreateVehicle
	(
		GetOwnableCarData(idx, OC_MODEL_ID),
		ownable_spawn_x,
		ownable_spawn_y,
		ownable_spawn_z,
		ownable_spawn_a,
		GetOwnableCarData(idx, OC_COLOR_1),
		GetOwnableCarData(idx, OC_COLOR_2),
		-1,
		0,
		VEHICLE_ACTION_TYPE_OWNABLE_CAR,
		idx
	);
	if(vehicleid != INVALID_VEHICLE_ID)
	{
		//CreateVehicleLabel(vehicleid, GetOwnableCarData(idx, OC_NUMBER), 0xFFFF00EE, 0.0, 0.0, 1.3, 20.0);
		//index = GetVehicleData(vehicleid, V_ACTION_ID);
        format(g_ownable_car[idx][OC_NUMBER], 32, g_ownable_car[idx][OC_NUMBER]);
        SetVehicleColor(vehicleid, GetVehicleRGBAColorById(GetOwnableCarData(idx, OC_COLOR_1)), GetVehicleRGBAColorById(GetOwnableCarData(idx, OC_COLOR_2)), 1);
        ApplyOwnableCarStoredPlate(vehicleid, idx);
		SetVehicleParam(vehicleid, V_LOCK, bool: cache_get_field_content_int(0, "status"));
		// `ownable_cars.alarm` historically stored the *active* GTA alarm flag.
            // Restoring it on spawn makes the stock alarm honk forever. Alarm is session-only:
            // every new vehicle entity starts with the alarm OFF.
            SetVehicleParam(vehicleid, V_ALARM, VEHICLE_PARAM_OFF);
            SetOwnableCarData(idx, OC_ALARM, false);

		new Float:loaded_mileage = cache_get_field_content_float(0, "mileage");
        new Float:loaded_fuel = cache_get_field_content_float(0, "fuel");
        if(loaded_fuel < 0.0) loaded_fuel = 40.0;
        SetVehicleData(vehicleid, V_MILEAGE, loaded_mileage);
        SetVehicleData(vehicleid, V_FUEL, loaded_fuel);
        SetVehicleSpeedometerInfo(vehicleid, loaded_fuel, loaded_mileage);
        g_ownable_mileage_saved[vehicleid] = loaded_mileage;
        g_ownable_mileage_sync_time[vehicleid] = gettime();
            g_ownable_fuel_saved[vehicleid] = loaded_fuel;
            g_ownable_fuel_sync_time[vehicleid] = gettime();

		SetVehicleData(vehicleid, V_LAST_LOAD_TIME, gettime());
//        SetVehicleWheels(GetOwnableCarData(idx, OC_SQL_ID), vehicleid); //(Это загрузка настройки шин)
		
		//ChangeVehiclePaintjob(vehicleid, GetOwnableCarData(idx, OC_VINILCAR));

		SetVehicleData(vehicleid, V_HEALTH, 1000);

		SetVehicleHealth(vehicleid, 1000);
	}

	cache_delete(result);

	LoadOwnableCarTrunk(vehicleid);

	return 1;
}



stock GetFreeOwnableCarID()
{
	for(new idx; idx < sizeof g_ownable_car; idx ++)
	{
		if(GetOwnableCarData(idx, OC_CREATE)) continue;

		return idx;
	}

	return -1;
}

stock UnloadPlayerOwnableCar(playerid, bool: ignore_time = false)
{
	new vehicleid = GetPlayerOwnableCar(playerid);

	if(vehicleid == INVALID_VEHICLE_ID)
	{
		return -1;
	}

	/*if((GetVehicleData(vehicleid, V_LAST_LOAD_TIME) > gettime() - 300) && !ignore_time)
	{
		return 0;
	}*/

	new index = GetVehicleData(vehicleid, V_ACTION_ID);

    new Float:unload_x, Float:unload_y, Float:unload_z, Float:unload_a;
    GetVehiclePos(vehicleid, unload_x, unload_y, unload_z);
    GetVehicleZAngle(vehicleid, unload_a);
    // A car stored in the new garage interior keeps its last exterior DB load point.
    // Otherwise a later normal /car load could spawn at interior coordinates in world 0.
    if(!GarageSys_IsVehicleStored(vehicleid))
        SaveOwnableCarUnloadPosition(GetOwnableCarData(index, OC_SQL_ID), unload_x, unload_y, unload_z, unload_a);
	SaveOwnableCar(vehicleid);

	ResetVehicleStreamCache(vehicleid);
	DestroyVehicleLabel(vehicleid);

	SetOwnableCarData(index, OC_CREATE, 0);
	DestroyVehicle(vehicleid);
	UnloadOwnableCarTrunk(vehicleid);

	SetVehicleData(vehicleid, V_LAST_LOAD_TIME, 0);

	SetPlayerData(playerid, P_OWNABLE_CAR, INVALID_VEHICLE_ID);

	foreach(new idx : Player)
	{
		if(!IsPlayerLogged(idx)) continue;
		else if(GetPlayerAllowedCar(idx) != vehicleid) continue;

		if(ignore_time)
			SendClientMessage(idx, 0xFF5533FF, "Владелец доверенного Вам транспорта отключился. Транспорт выгружен с сервера");
		else
			SendClientMessage(idx, 0xFF5533FF, "Владелец доверенного Вам транспорта выгрузил транспорт с сервера");

		SetPlayerData(idx, P_ALLOWED_CAR, INVALID_VEHICLE_ID);
	}

	return 1;
}

stock UnloadOwnableCarBySqlID(playerid, sql_id)
{
    new vehicleid = GetOwnableCarBySqlID(sql_id);
    if(vehicleid == INVALID_VEHICLE_ID)
    {
        return -1;
    }

    new index = GetVehicleData(vehicleid, V_ACTION_ID);
    if(index < 0 || GetOwnableCarData(index, OC_OWNER_ID) != GetPlayerAccountID(playerid))
    {
        return 0;
    }

    new old_vehicleid = GetPlayerOwnableCar(playerid);
    SetPlayerData(playerid, P_OWNABLE_CAR, vehicleid);

    new result = UnloadPlayerOwnableCar(playerid);

    if(result != 1)
    {
        SetPlayerData(playerid, P_OWNABLE_CAR, old_vehicleid);
        return result;
    }

    if(old_vehicleid != vehicleid && IsAOwnableCar(old_vehicleid))
    {
        SetPlayerData(playerid, P_OWNABLE_CAR, old_vehicleid);
    }

    return 1;
}

public: LoadTrunks()
{
	new Cache: result, rows;
	new vehicleid, slot, buffer;

	result = mysql_query(mysql, "SELECT * FROM trunks ORDER BY owner_id ASC, id ASC", true);
	rows = cache_num_rows(result);

	for(new idx; idx < rows; idx ++)
	{
		vehicleid = GetOwnableCarBySqlID(cache_get_field_content_int(idx, "owner_id"));
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			for(slot = 0; slot < MAX_VEHICLE_TRUNK_SLOTS; slot ++)
			{
				if(GetTrunkData(vehicleid, slot, VT_SQL_ID)) continue;

				SetTrunkData(vehicleid, slot, VT_SQL_ID,		cache_get_field_content_int(idx, "id"));
				SetTrunkData(vehicleid, slot, VT_ITEM_TYPE, 	cache_get_field_content_int(idx, "item_id"));
				SetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT, 	cache_get_field_content_int(idx, "amount"));
				SetTrunkData(vehicleid, slot, VT_ITEM_VALUE,	cache_get_field_content_int(idx, "value"));
			}
			buffer ++;
		}
	}

	cache_delete(result);
	printf("[Trunks]: Предметов загружено: %d", buffer);
}

public: LoadOwnableCarTrunk(vehicleid)
{
	new query[60],
		slot,
		index,
		rows,
		Cache: result;

	index = GetVehicleData(vehicleid, V_ACTION_ID);

	mysql_format(mysql, query, sizeof query, "SELECT * FROM trunks WHERE oc_id='%d' ORDER BY id ASC", index);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows(result);

	if(rows > MAX_VEHICLE_TRUNK_SLOTS)
		rows = MAX_VEHICLE_TRUNK_SLOTS;

	for(slot = 0; slot < rows; slot ++)
	{
		if(GetTrunkData(vehicleid, slot, VT_SQL_ID)) continue;

		SetTrunkData(vehicleid, slot, VT_SQL_ID,		cache_get_field_content_int(slot, "id"));
		SetTrunkData(vehicleid, slot, VT_ITEM_TYPE, 	cache_get_field_content_int(slot, "item_id"));
		SetTrunkData(vehicleid, slot, VT_ITEM_AMOUNT, 	cache_get_field_content_int(slot, "amount"));
		SetTrunkData(vehicleid, slot, VT_ITEM_VALUE,	cache_get_field_content_int(slot, "value"));
	}

	cache_delete(result);
}

stock UnloadOwnableCarTrunk(vehicleid)
{
	for(new slot = 0; slot < MAX_VEHICLE_TRUNK_SLOTS; slot ++)
	{
		RemoveTrunkItem(vehicleid, slot);
	}
}

