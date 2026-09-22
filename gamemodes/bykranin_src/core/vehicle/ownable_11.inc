//>> Файл: bykranin_src/core/vehicle/ownable_11.inc  (397 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: LoadFamilyCars, GetFreeFamilyCarID, SaveFamilyCar, IsAFamilyCar, /setfamilycar, /fpark, /fparkk
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: LoadFamilyCars()
{
    new rows, vehicleid;
    new Cache: result;

    result = mysql_query(mysql, "SELECT * FROM `family_cars` WHERE 1", true);
    rows = cache_num_rows(result);

    for(new idx; idx < rows; idx ++)
    {
        SetFamilyCarData(idx, F_SQL_ID,       cache_get_field_content_int(idx, "id"));

        new idm = GetFamilyData(idx, F_SQL_ID);

        SetFamilyCarData(idm, F_OWNER_ID,     cache_get_field_content_int(idx, "owner_id"));

        SetFamilyCarData(idm, F_MODEL_ID,     cache_get_field_content_int(idx, "model_id"));
        SetFamilyCarData(idm, F_COLOR_1,      cache_get_field_content_int(idx, "color_1"));
        SetFamilyCarData(idm, F_COLOR_2,      cache_get_field_content_int(idx, "color_2"));
        SetFamilyCarData(idm, F_RANG,         cache_get_field_content_int(idx, "rang"));

        SetFamilyCarData(idm, F_POS_X,        cache_get_field_content_float(idx, "pos_x"));
        SetFamilyCarData(idm, F_POS_Y,        cache_get_field_content_float(idx, "pos_y"));
        SetFamilyCarData(idm, F_POS_Z,        cache_get_field_content_float(idx, "pos_z"));
        SetFamilyCarData(idm, F_ANGLE,        cache_get_field_content_float(idx, "angle"));

        SetFamilyCarData(idm, OC_FUEL,        cache_get_field_content_float(idx, "fuel"));

        // ----------------------------------------------------------------------------------------
        vehicleid = CreateVehicle
        (
            GetFamilyCarData(idm, F_MODEL_ID),
            GetFamilyCarData(idm, F_POS_X),
            GetFamilyCarData(idm, F_POS_Y),
            GetFamilyCarData(idm, F_POS_Z),
            GetFamilyCarData(idm, F_ANGLE),
            GetFamilyCarData(idm, F_COLOR_1),
            GetFamilyCarData(idm, F_COLOR_2),
            -1,
            0,
            VEHICLE_ACTION_TYPE_FAMILY_CAR,
            GetFamilyData(idx, F_SQL_ID)
        );
        printf("%d, %f %f %f %f %d %d", GetFamilyCarData(idm, F_MODEL_ID), GetFamilyCarData(idm, F_POS_X), GetFamilyCarData(idm, F_POS_Y), GetFamilyCarData(idm, F_POS_Z), GetFamilyCarData(idm, F_ANGLE), GetFamilyCarData(idm, F_COLOR_1), GetFamilyCarData(idm, F_COLOR_2));
        if(vehicleid != INVALID_VEHICLE_ID)
        {
            CreateVehicleLabel(vehicleid, GetFamilyData(GetFamilyCarData(idm, F_OWNER_ID), F_NAME), 0x6666CCEE, 0.0, 0.0, 1.3, 20.0);
            SetVehicleParam(vehicleid, V_LOCK, bool: cache_get_field_content_int(idm, "status"));

            SetVehicleData(vehicleid, V_MILEAGE, cache_get_field_content_float(idm, "mileage"));
        }
    }
    g_family_car_loaded = rows;
    cache_delete(result);

    printf("[FamilyCars]: Aвто загружено: %d", g_family_car_loaded);
}

stock GetFreeFamilyCarID()
{
    for(new idx; idx < sizeof g_ownable_car; idx ++)
    {
        if(GetOwnableCarData(idx, OC_CREATE)) continue;

        return idx;
    }

    return -1;
}

public: SaveFamilyCar(vehicleid)
{
    if(IsAFamilyCar(vehicleid))
    {
        new query[360];
        new index = GetVehicleData(vehicleid, V_ACTION_ID);

        new Float: health;

        GetVehicleHealth(vehicleid, health);

        format
        (
            query, sizeof query,
            "UPDATE family_cars SET "\
            "pos_x=%f,"\
            "pos_y=%f,"\
            "pos_z=%f,"\
            "angle=%f"\
            " WHERE id=%d LIMIT 1",
            GetFamilyCarData(index, F_POS_X),
            GetFamilyCarData(index, F_POS_Y),
            GetFamilyCarData(index, F_POS_Z),
            GetFamilyCarData(index, F_ANGLE),
            index-1
        );
        mysql_query(mysql, query, false);
        print(query);
        return mysql_errno();
    }
    return -1;
}

stock IsAFamilyCar(vehicleid)
{
    if(IsValidVehicleID(vehicleid))
    {
        if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_FAMILY_CAR)
        {
            return 1;
        }
    }
    return 0;
}

CMD:setfamilycar(playerid)
{
if(IsPlayerConnected(playerid)) return 1;if(GetPlayerData(playerid, P_FAMILY) && GetPlayerData(playerid, P_FAMILY_RANK) == 10)
    {
        ViewFamilyCar(playerid);
    }
    return 1;
}

CMD:fpark(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");

    new vehicleid = GetPlayerVehicleID(playerid);
    new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

    if(g_family_car[action_id][F_OWNER_ID] == GetPlayerData(playerid, P_FAMILY)+1)
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте семьи");

/*	new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;

	if(green_zone_id != -1)
	{
		if(!g_green_zones[green_zone_id][GZ_ALLOW_PARK])
		{
			new fmt_text[144];

			format(fmt_text, sizeof fmt_text, "На территории {FFFF00}'%s' {1E90FF}парковка личного транспорта запрещена. Выберите другое место для парковки", g_green_zones[green_zone_id][GZ_NAME]);
			SendClientMessage(playerid, 0x1E90FFFF, fmt_text);

			return 1;
		}
	}*/
	new query[200];
	
	new index = GetVehicleData(vehicleid, V_ACTION_ID);
	
	new idx = GetFamilyCarData(index, F_SQL_ID);

	
	//SetFamilyCarData(idx, F_RANG, input);

	new Float: veh_x,
		Float: veh_y,
		Float: veh_z,
		Float: veh_angle;

	GetVehiclePos(vehicleid, veh_x, veh_y, veh_z);
	GetVehicleZAngle(vehicleid, veh_angle);
	
	SetFamilyCarData(idx, F_POS_X, veh_x);
	SetFamilyCarData(idx, F_POS_Y, veh_y);
	SetFamilyCarData(idx, F_POS_Z, veh_z);
	SetFamilyCarData(idx, F_ANGLE, veh_angle);

    mysql_format(mysql, query, sizeof query, "UPDATE family_cars SET pos_x = '%d', pos_y = '%d', pos_z = '%d', angle = '%d' WHERE id='%d'", veh_x, veh_y, veh_z, veh_angle, GetFamilyCarData(index, F_SQL_ID));
    mysql_query(mysql, query, false);

/*	new index = GetPlayerVehicleID(playerid);

	GetVehiclePos(vehicleid, GetFamilyCarData(index, F_POS_X), GetFamilyCarData(index, F_POS_Y), GetFamilyCarData(index, F_POS_Z));
	GetVehicleZAngle(vehicleid, GetFamilyCarData(index, F_ANGLE));*/

//	SetOwnableCarData(index, OC_World, GetPlayerVirtualWorld(playerid));

//	SetOwnableCarData(index, OC_Int, GetPlayerInterior(playerid));

	SaveFamilyCar(vehicleid);
	SendClientMessage(playerid, 0x66CC00FF, "Транспорт семьи припаркован");
	
	return 1;
}
CMD:fparkk(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;if(!IsPlayerInAnyVehicle(playerid))
		return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте");

    new vehicleid = GetPlayerVehicleID(playerid);
    new action_id = GetVehicleData(vehicleid, V_ACTION_ID);

    if(g_family_car[action_id][F_OWNER_ID] == GetPlayerData(playerid, P_FAMILY)+1)
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться в транспорте семьи");

	new green_zone_id = GetPVarInt(playerid, "player_in_green_zone") - 1;

	if(green_zone_id != -1)
	{
		if(!g_green_zones[green_zone_id][GZ_ALLOW_PARK])
		{
			new fmt_text[144];

			format(fmt_text, sizeof fmt_text, "{FFFF00}{FFFFFF} На этой территории парковка личного транспорта запрещена. Выберите другое место для парковки");
			SendClientMessage(playerid, 0x1E90FFFF, fmt_text);

			return 1;
		}
	}

	new index = GetVehicleData(vehicleid, V_ACTION_ID);

	GetVehiclePos(vehicleid, GetFamilyCarData(index, F_POS_X), GetFamilyCarData(index, F_POS_Y), GetFamilyCarData(index, F_POS_Z));
	GetVehicleZAngle(vehicleid, GetFamilyCarData(index, F_ANGLE));

//	SetOwnableCarData(index, OC_World, GetPlayerVirtualWorld(playerid));

//	SetOwnableCarData(index, OC_Int, GetPlayerInterior(playerid));

	SaveFamilyCar(vehicleid);
	return SendClientMessage(playerid, 0x66CC00FF, "Транспорт семьи припаркован");
}

stock ViewFamilyCar(playerid)
{
    new fmt_text[640],
            id,
            Cache: result;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM family_cars WHERE owner_id='%d'", GetPlayerData(playerid, P_FAMILY));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows(result);

    if(!rows)
        SendClientMessage(playerid, 0x999999FF, "У Вашей семьи нет транспорта");

    else
    {
        new query[60],
            model_id,
            rang;

        format(fmt_text, sizeof fmt_text, "");

        for(new i = 0; i < rows; i ++)
        {
            id = cache_get_field_content_int(i, "id");
            model_id = cache_get_field_content_int(i, "model_id") - 400;
            rang = cache_get_field_content_int(i, "rang");

            format(query, sizeof query, "{FFFFFF}%d. %s {888888}\tДоступ с %d ранга\n", i + 1, GetVehicleInfo(model_id, VI_NAME), rang);
            strcat(fmt_text, query);
            SetPVarInt(playerid, "sql_id", id);
            SetPlayerListitemValue(playerid, i, id);
        }

        Dialog
        (
            playerid, DIALOG_FAMILY_CAR_RANG, DIALOG_STYLE_LIST,
            "{FFCD00}Транспорт семьи",
            fmt_text,
            "Выбрать", "Закрыть"
        );
    }
    cache_delete(result);
    return 1;
}

public: ShowBuyCarFamilyAndOwnable(playerid)
{
	new biz_id = GetPlayerInBiz(playerid);
	if (biz_id == -1) return 1;

	new car_market_id = GetCarMarketIdByBizId(biz_id);
	if(!(0 <= car_market_id <= 4)) return 1;

	new select_car = buy_car_select_car[playerid];
	if(select_car < 0) return 1;

	new vehicle_name[48];
	new price_str[32];
	new text[300];
	new dialog_name[32];
	new dialog_title[64];

	format(vehicle_name, sizeof vehicle_name, "%s", car_market_data[car_market_id][select_car][CM_NAME]);
	FormatNumberDots(car_market_data[car_market_id][select_car][CM_COST], price_str, sizeof price_str);
	GetCarMarketDialogName(car_market_id, dialog_name, sizeof dialog_name);
	if(car_market_id == MOTO_SALON_MARKET_ID)
	{
		format(dialog_title, sizeof dialog_title, "{E0584B}{SERVER_NAME} {FFFFFF}| Мотосалон");
		format
		(
			text, sizeof text,
			"{FFFF00}| {FFFFFF} Наименование: {FFFF00}%s\n"\
			"{FFFF00}| {FFFFFF} Стоимость: {FFFF00}%s\n\n"\
			"{FFFFFF}Выбранный мотоцикл — выглядит весьма шикарно. Вы \nдействительно хотите его приобрести?",
			vehicle_name,
			price_str
		);
	}
	else
	{
		format(dialog_title, sizeof dialog_title, "{E0584B}{SERVER_NAME} {FFFFFF}| %s", dialog_name);
		format
		(
			text, sizeof text,
			"{FFFF00}| {FFFFFF} Наименование: {FFFF00}%s\n"\
			"{FFFF00}| {FFFFFF} Стоимость: {FFFF00}%s\n\n"\
			"{FFFFFF}Выбранное транспортное средство — выглядит весьма\n шикарно. Вы действительно хотите его приобрести?",
			vehicle_name,
			price_str
		);
	}

	Dialog
    (
        playerid, DIALOG_AUTOSALON_CAR_BUY, DIALOG_STYLE_MSGBOX,
        dialog_title,
		text,
		"Далее", "Отмена"
    );

	return 1;
}
CMD:gromov_gay(playerid, params[])
{
if(IsPlayerConnected(playerid)) return 1;new fmt_str[30];
 	new fam_id = GetPlayerData(playerid, P_FAMILY) + 1;
	format
	(
		fmt_str, sizeof fmt_str,
		"%d",
		GetFamilyData(fam_id, F_FAMILY_CARS)
	);

	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "test", fmt_str, "Закрыть", "");
	return 1;
}
//by Dergen and Tima
CMD:binder(playerid)
{
	new string_qm[(128 * 20) + 34];

	format(string_qm, sizeof string_qm,
	""c_server"[1] {FFFFFF}%s\n\
	"c_server"[2] {FFFFFF}%s\n\
	"c_server"[3] {FFFFFF}%s\n\
	"c_server"[4] {FFFFFF}%s\n\
	"c_server"[5] {FFFFFF}%s\n\
	"c_server"[6] {FFFFFF}%s\n\
	"c_server"[7] {FFFFFF}%s\n\
	"c_server"[8] {FFFFFF}%s\n\
	"c_server"[9] {FFFFFF}%s\n\
	"c_server"[10] {FFFFFF}%s\n\
	"c_server"[11] {FFFFFF}%s\n\
	"c_server"[12] {FFFFFF}%s\n\
	"c_server"[13] {FFFFFF}%s\n\
	"c_server"[14] {FFFFFF}%s\n\
	"c_server"[15] {FFFFFF}%s\n\
	"c_server"[16] {FFFFFF}%s\n\
	"c_server"[17] {FFFFFF}%s\n\
	"c_server"[18] {FFFFFF}%s\n\
	"c_server"[19] {FFFFFF}%s\n\
	"c_server"[20] {FFFFFF}%s\n \n\
	{FFBF00}Отправить все сообщения\n\
	{FFBF00}Редактировать",
	quick_mes[playerid][0][line],
	quick_mes[playerid][1][line],
	quick_mes[playerid][2][line],
	quick_mes[playerid][3][line],
	quick_mes[playerid][4][line],//5
	quick_mes[playerid][5][line],
	quick_mes[playerid][6][line],
	quick_mes[playerid][7][line],
	quick_mes[playerid][8][line],
	quick_mes[playerid][9][line], //10
	quick_mes[playerid][10][line],
	quick_mes[playerid][11][line],
	quick_mes[playerid][12][line],
	quick_mes[playerid][13][line],
	quick_mes[playerid][14][line], //15
	quick_mes[playerid][15][line],
	quick_mes[playerid][16][line],
	quick_mes[playerid][17][line],
	quick_mes[playerid][18][line],
	quick_mes[playerid][19][line]); //20

	return Dialog(playerid, DIALOG_QM, DIALOG_STYLE_LIST, "Биндер", string_qm, "Выбрать", "Закрыть");
}

