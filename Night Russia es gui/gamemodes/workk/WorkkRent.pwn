// ============================================================
// WorkkRent.pwn -- система аренды скутера / загрузки личного Т/С
// (перенесено из старого мода workk.pwn)
// ============================================================

stock CreateRentPickups()
{
	new fmt_text[48];

	for(new city; city < RENT_CITY_COUNT; city ++)
	{
		CreatePickup
		(
			19134, 23,
			g_rent_pickup_pos[city][0], g_rent_pickup_pos[city][1], g_rent_pickup_pos[city][2],
			-1, PICKUP_ACTION_RENT_MENU, city
		);

		format(fmt_text, sizeof fmt_text, "{ffff00}Аренда скутера (%s)", g_rent_city_name[city]);

		CreateDynamic3DTextLabel
		(
			fmt_text, 0x3399FFFF,
			g_rent_pickup_pos[city][0], g_rent_pickup_pos[city][1], g_rent_pickup_pos[city][2] + 1.8,
			10.0
		);
	}
	return 1;
}

stock ShowPlayerLoadCarListDialog(playerid)
{
	new fmt_text[900],
		query[60],
		Cache: result,
		id, model_id,
		car_number[7];

	mysql_format(mysql, query, sizeof query, "SELECT * FROM ownable_cars WHERE owner_id='%d'", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();

	if(!rows)
	{
		ShowNotification(playerid, 2, "У Вас нет личного транспорта", 4, "", "");
		cache_delete(result);
		return 0;
	}

	format(fmt_text, sizeof fmt_text, "");

	for(new i; i < rows; i ++)
	{
		id = cache_get_field_content_int(i, "id");
		model_id = cache_get_field_content_int(i, "model_id") - 400;
		cache_get_field_content(i, "number", car_number);

		format(query, sizeof query, "{FFFFFF}%d. %s \t\t\t{888888}[%s]\n", i + 1, GetVehicleInfo(model_id, VI_NAME), car_number);
		strcat(fmt_text, query);
		SetPlayerListitemValue(playerid, i, id);
	}

	cache_delete(result);

	Dialog
	(
		playerid, DIALOG_LOAD_CAR_LIST, DIALOG_STYLE_LIST,
		"{FF6347}"SERVER_NAME"{ffffff} | Загрузка Т/С",
		fmt_text,
		"Выбрать", "Отмена"
	);
	return 1;
}
