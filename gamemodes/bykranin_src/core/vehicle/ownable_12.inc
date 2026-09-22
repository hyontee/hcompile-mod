//>> Файл: bykranin_src/core/vehicle/ownable_12.inc  (377 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: LoadOwnableCarRent, LoadPlayerAccessories, OnLoadPlayerAccessories, RemoveAllAccessories
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
forward LoadOwnableCarRent(playerid, oc_id);
public LoadOwnableCarRent(playerid, oc_id)
{
	new Float:POS[4];
	GetPlayerPos(playerid, POS[0],POS[1],POS[2]);
	GetPlayerFacingAngle(playerid, POS[3]);

	if(g_ownable_car_loaded + 1 > MAX_OWNABLE_CARS)
	{
		print("[OwnableCars]: Превышен лимит транспорта");
		return INVALID_VEHICLE_ID;
	}

	new idx = GetFreeOwnableCarID();
	if(idx == -1)
	{
		print("[OwnableCars]: Нет свободного ID транспорта");
		return INVALID_VEHICLE_ID;
	}

	new query[128], Cache:result;
	mysql_format(mysql, query, sizeof query, "SELECT * FROM ownable_cars WHERE id='%d' LIMIT 1", oc_id);
	result = mysql_query(mysql, query, true);

	if(!cache_num_rows(result))
	{
		cache_delete(result);
		print("[OwnableCars]: Машина не найдена в БД");
		return INVALID_VEHICLE_ID;
	}

	// заполнение данных машины
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
	SetOwnableCarData(idx, OC_vinil_current,   cache_get_field_content_int(0, "vinil_current"));
		SetOwnableCarData(idx, OC_exhsuast_current,   cache_get_field_content_int(0, "exhsuast_current"));
		SetOwnableCarData(idx, OC_strab_current,   cache_get_field_content_int(0, "strab_current"));
		SetOwnableCarData(idx, OC_EnableNeon,   cache_get_field_content_int(0, "EnableNeon"));
		SetOwnableCarData(idx, OC_horn_current,   cache_get_field_content_int(0, "horn_current"));
	// Slot 1
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
	cache_get_field_content(
    0,
    "vynil_name",
    vInfo[idx][vynil_name]
);

	
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
	SetOwnableCarData(idx, OC_percentofclirness, 		    cache_get_field_content_int(0, "percentofclirness"));
	SetOwnableCarData(idx, OC_ISCASE, 		    cache_get_field_content_int(0, "iscase"));
	
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
	printf("R: %s", string);
	sscanf(string, "x", GetOwnableCarData(idx, OC_COLOR_BODY_R));
	cache_get_field_content(0, "color_body_g", string);
	printf("G: %s", string);
	sscanf(string, "x", GetOwnableCarData(idx, OC_COLOR_BODY_G));
	cache_get_field_content(0, "color_wheels", string);
	printf("C_W: %s", string);
	sscanf(string, "x", GetOwnableCarData(idx, OC_COLOR_WHEELS));
	cache_get_field_content(0, "light_color", string);
	printf("C_L: %s", string);
	sscanf(string, "x", GetOwnableCarData(idx, OC_LIGHT_COLOR));

	format(string, sizeof string, "%x", GetOwnableCarData(idx, OC_LIGHT_COLOR));
	printf("OC_LIGHT_COLOR: %s", string);

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


	// если номера нет, генерируем
	new tmp_plate_type;
	new tmp_plate[16], tmp_region[8];
	if(!ParseStoredPlateValue(g_ownable_car[idx][OC_NUMBER], tmp_plate_type, tmp_plate, sizeof(tmp_plate), tmp_region, sizeof(tmp_region)))
		strmid(g_ownable_car[idx][OC_NUMBER], "------", 0, 8, 32);

	new vehicleid = CreateVehicle(
		GetOwnableCarData(idx, OC_MODEL_ID),
		POS[0], POS[1], POS[2], POS[3],
		GetOwnableCarData(idx, OC_COLOR_1),
		GetOwnableCarData(idx, OC_COLOR_2),
		-1, 0,
		VEHICLE_ACTION_TYPE_OWNABLE_CAR, idx
	);

	if(vehicleid == INVALID_VEHICLE_ID)
	{
		print("[OwnableCars]: CreateVehicle вернул INVALID_VEHICLE_ID");
		cache_delete(result);
		return INVALID_VEHICLE_ID;
	}

	SetVehicleData(vehicleid, V_HEALTH, 1000.0);
	SetVehicleHealth(vehicleid, 1000.0);
	SetVehicleData(vehicleid, V_LAST_LOAD_TIME, gettime());
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
	SetVehicleParam(vehicleid, V_LOCK, bool:cache_get_field_content_int(0, "status"));
	// `ownable_cars.alarm` historically stored the *active* GTA alarm flag.
            // Restoring it on spawn makes the stock alarm honk forever. Alarm is session-only:
            // every new vehicle entity starts with the alarm OFF.
            SetVehicleParam(vehicleid, V_ALARM, VEHICLE_PARAM_OFF);
            SetOwnableCarData(idx, OC_ALARM, false);
	ApplyOwnableCarStoredPlate(vehicleid, idx);

	cache_delete(result);

	LoadOwnableCarTrunk(vehicleid);

	return vehicleid;
}


forward LoadPlayerAccessories(playerid);
public LoadPlayerAccessories(playerid)
{
    new account_id = GetPlayerAccountID(playerid);

    if(account_id <= 0)
        return 0;

    new query[160];
    format(query, sizeof(query),
        "SELECT * FROM accessories_players WHERE account_id = %d AND bone > 0",
        account_id
    );

    printf("[ACS][AUTH] LoadPlayerAccessories request: player=%d account_id=%d", playerid, account_id);
    mysql_tquery(mysql, query, "OnLoadPlayerAccessories", "d", playerid);
    return 1;
}

forward OnLoadPlayerAccessories(playerid);
public OnLoadPlayerAccessories(playerid)
{
    new rows, fields;
    cache_get_data(rows, fields, mysql);

    printf("[ACS][AUTH] OnLoadPlayerAccessories: player=%d rows=%d fields=%d", playerid, rows, fields);

    if(rows <= 0)
        return 1;

    new str_val[32];

    for(new i = 0; i < rows; i++)
    {
        new slot, modelid, bone;
        new Float:pos_x, Float:pos_y, Float:pos_z;
        new Float:rot_x, Float:rot_y, Float:rot_z;
        new Float:scale_x, Float:scale_y, Float:scale_z;

        cache_get_field_content(i, "slot", str_val, mysql, sizeof(str_val));
        slot = strval(str_val);

        cache_get_field_content(i, "modelid", str_val, mysql, sizeof(str_val));
        modelid = strval(str_val);

        cache_get_field_content(i, "bone", str_val, mysql, sizeof(str_val));
        bone = strval(str_val);

        cache_get_field_content(i, "pos_x", str_val, mysql, sizeof(str_val));
        pos_x = floatstr(str_val);

        cache_get_field_content(i, "pos_y", str_val, mysql, sizeof(str_val));
        pos_y = floatstr(str_val);

        cache_get_field_content(i, "pos_z", str_val, mysql, sizeof(str_val));
        pos_z = floatstr(str_val);

        cache_get_field_content(i, "rot_x", str_val, mysql, sizeof(str_val));
        rot_x = floatstr(str_val);

        cache_get_field_content(i, "rot_y", str_val, mysql, sizeof(str_val));
        rot_y = floatstr(str_val);

        cache_get_field_content(i, "rot_z", str_val, mysql, sizeof(str_val));
        rot_z = floatstr(str_val);

        cache_get_field_content(i, "scale_x", str_val, mysql, sizeof(str_val));
        scale_x = floatstr(str_val);

        cache_get_field_content(i, "scale_y", str_val, mysql, sizeof(str_val));
        scale_y = floatstr(str_val);

        cache_get_field_content(i, "scale_z", str_val, mysql, sizeof(str_val));
        scale_z = floatstr(str_val);

        // Пустая строка — пропускаем
        if(slot == 0 && modelid == 0 && bone == 0 &&
           pos_x == 0.0 && pos_y == 0.0 && pos_z == 0.0 &&
           rot_x == 0.0 && rot_y == 0.0 && rot_z == 0.0 &&
           scale_x == 0.0 && scale_y == 0.0 && scale_z == 0.0)
        {
            printf("[ACS][AUTH] skip empty row=%d player=%d", i, playerid);
            continue;
        }

        // Validate every field before sending an attached-object RPC.
        if(slot < 0 || slot >= MAX_PLAYER_ATTACHED_OBJECTS)
        {
            printf("[ACS][AUTH] skip row=%d invalid slot=%d player=%d", i, slot, playerid);
            continue;
        }

        if(modelid <= 0 || bone < 1 || bone > 18)
        {
            printf("[ACS][AUTH] skip row=%d invalid model=%d bone=%d player=%d", i, modelid, bone, playerid);
            continue;
        }

        if(scale_x < 0.01 || scale_x > 10.0 ||
           scale_y < 0.01 || scale_y > 10.0 ||
           scale_z < 0.01 || scale_z > 10.0 ||
           floatabs(pos_x) > 10.0 || floatabs(pos_y) > 10.0 || floatabs(pos_z) > 10.0)
        {
            printf("[ACS][AUTH] skip row=%d unsafe transform player=%d sx=%.4f sy=%.4f sz=%.4f x=%.4f y=%.4f z=%.4f",
                i, playerid, scale_x, scale_y, scale_z, pos_x, pos_y, pos_z);
            continue;
        }

        SetPlayerAttachedObject(
            playerid,
            slot,
            modelid,
            bone,
            pos_x, pos_y, pos_z,
            rot_x, rot_y, rot_z,
            scale_x, scale_y, scale_z
        );

        printf("[ACS][AUTH] apply row=%d player=%d slot=%d model=%d bone=%d x=%.4f y=%.4f z=%.4f rx=%.2f ry=%.2f rz=%.2f sx=%.4f sy=%.4f sz=%.4f",
            i, playerid, slot, modelid, bone,
            pos_x, pos_y, pos_z,
            rot_x, rot_y, rot_z,
            scale_x, scale_y, scale_z
        );

        gPlayerTempAccData[playerid][slot][0] = float(modelid);
        gPlayerTempAccData[playerid][slot][1] = float(bone);
        gPlayerTempAccData[playerid][slot][2] = pos_x;
        gPlayerTempAccData[playerid][slot][3] = pos_y;
        gPlayerTempAccData[playerid][slot][4] = pos_z;
        gPlayerTempAccData[playerid][slot][5] = rot_x;
        gPlayerTempAccData[playerid][slot][6] = rot_y;
        gPlayerTempAccData[playerid][slot][7] = rot_z;
        gPlayerTempAccData[playerid][slot][8] = scale_x;
        gPlayerTempAccData[playerid][slot][9] = scale_y;
        gPlayerTempAccData[playerid][slot][10] = scale_z;
    }

    return 1;
}
stock RemoveAllAccessories(playerid)
{
	for (new i = 0; i < MAX_PLAYER_ATTACHED_OBJECTS; i++)
	{
		if (IsPlayerAttachedObjectSlotUsed(playerid, i))
		{
			RemovePlayerAttachedObject(playerid, i);
		}
	}
}

enum E_VEHICLE_MODEL_NAME_MAP
{
    VM_ID,
    VM_NAME[64]
};

