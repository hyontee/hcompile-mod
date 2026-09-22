//>> Файл: bykranin_src/core/vehicle/ownable_01.inc  (275 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: ApplyCarMarketPreviewScene, BuyCarPTDUpdate, ShowBuyCarInfo, RefreshAutosalonChat, PlayerHasFreeCarSlotForMarket, EnterPlayerBuyCarMarket
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ApplyCarMarketPreviewScene(playerid, vehicleid, car_market_id, bool:animate_camera = false)
{
	if(!(0 <= car_market_id <= 4)) return 1;
	if(vehicleid == INVALID_VEHICLE_ID || !IsValidVehicle(vehicleid)) return 1;

	new bool:keep_moto_camera_animation =
	(
		car_market_id == MOTO_SALON_MARKET_ID
		&& !animate_camera
		&& IsMotoSalonCameraAnimating(playerid)
	);

	if(!keep_moto_camera_animation)
	{
		SetPlayerVirtualWorld(playerid, playerid + 1);
		SetPlayerInterior(playerid, g_car_market_scene[car_market_id][CMS_INTERIOR]);
		SetPlayerPosEx
		(
			playerid,
			g_car_market_scene[car_market_id][CMS_PLAYER_X],
			g_car_market_scene[car_market_id][CMS_PLAYER_Y],
			g_car_market_scene[car_market_id][CMS_PLAYER_Z],
			g_car_market_scene[car_market_id][CMS_PLAYER_A],
			g_car_market_scene[car_market_id][CMS_INTERIOR],
			playerid + 1,
			false
		);
		TogglePlayerControllable(playerid, false);
	}

	SetVehiclePos
	(
		vehicleid,
		g_car_market_scene[car_market_id][CMS_VEH_X],
		g_car_market_scene[car_market_id][CMS_VEH_Y],
		g_car_market_scene[car_market_id][CMS_VEH_Z]
	);
	SetVehicleZAngle(vehicleid, g_car_market_scene[car_market_id][CMS_VEH_A]);
	SetVehicleVirtualWorld(vehicleid, playerid + 1);
	LinkVehicleToInterior(vehicleid, g_car_market_scene[car_market_id][CMS_INTERIOR]);
	SetVehicleNumberPlateEx(vehicleid, TYPE_RU, "", "");

	if(car_market_id == MOTO_SALON_MARKET_ID && animate_camera)
	{
		SetPVarInt(playerid, "moto_salon_camera_anim_until", GetTickCount() + 2500);
		SetPlayerCameraPos(playerid, -586.811035, 2288.229980, 1501.715820);
		SetPlayerCameraLookAt
		(
			playerid,
			g_car_market_scene[car_market_id][CMS_LOOK_X],
			g_car_market_scene[car_market_id][CMS_LOOK_Y],
			g_car_market_scene[car_market_id][CMS_LOOK_Z]
		);
		InterpolateCameraPos
		(
			playerid,
			-586.811035, 2288.229980, 1501.715820,
			g_car_market_scene[car_market_id][CMS_CAM_X],
			g_car_market_scene[car_market_id][CMS_CAM_Y],
			g_car_market_scene[car_market_id][CMS_CAM_Z],
			2500,
			CAMERA_MOVE
		);
		InterpolateCameraLookAt
		(
			playerid,
			g_car_market_scene[car_market_id][CMS_LOOK_X],
			g_car_market_scene[car_market_id][CMS_LOOK_Y],
			g_car_market_scene[car_market_id][CMS_LOOK_Z],
			g_car_market_scene[car_market_id][CMS_LOOK_X],
			g_car_market_scene[car_market_id][CMS_LOOK_Y],
			g_car_market_scene[car_market_id][CMS_LOOK_Z],
			2500,
			CAMERA_MOVE
		);
	}
	else
	{
		if(keep_moto_camera_animation)
		{
			return 1;
		}
		if(car_market_id == MOTO_SALON_MARKET_ID)
		{
			DeletePVar(playerid, "moto_salon_camera_anim_until");
		}
		SetPlayerCameraPos
		(
			playerid,
			g_car_market_scene[car_market_id][CMS_CAM_X],
			g_car_market_scene[car_market_id][CMS_CAM_Y],
			g_car_market_scene[car_market_id][CMS_CAM_Z]
		);
		SetPlayerCameraLookAt
		(
			playerid,
			g_car_market_scene[car_market_id][CMS_LOOK_X],
			g_car_market_scene[car_market_id][CMS_LOOK_Y],
			g_car_market_scene[car_market_id][CMS_LOOK_Z]
		);
	}
	return 1;
}

public: BuyCarPTDUpdate(playerid)
{
	new fmt_str[64];
	new fmt_text[96];
	if(GetPlayerData(playerid, P_BUY_CAR) == INVALID_VEHICLE_ID) return 1;

	new biz_id = GetPlayerInBiz(playerid);
	if (biz_id == -1) return 1;
	new car_market_id = GetCarMarketIdByBizId(biz_id);
	if(car_market_id == -1) return 1;

	new select_car = buy_car_select_car[playerid];
	new modelid = car_market_data[car_market_id][select_car][CM_MODELID];
	if(!modelid) return 1;

	new vehicle_price = car_market_data[car_market_id][select_car][CM_COST];
	new vehicle_speed = car_market_data[car_market_id][select_car][CM_SPEED];
	new Float:vehicle_acceleration = car_market_data[car_market_id][select_car][CM_ACCELERATION];
	new limit_text[32];
	if(IsAutosalonInfiniteStock(car_market_id))
		format(limit_text, sizeof limit_text, "INF");
	else
		format(limit_text, sizeof limit_text, "%d", GetAutosalonVehicleSlots(car_market_id, modelid));

	if(!vehicle_price && car_market_id != TRUCK_SALON_MARKET_ID) vehicle_price = GetVehicleInfo(modelid - 400, VI_PRICE);
	if(!vehicle_speed) vehicle_speed = GetVehicleInfo(modelid - 400, VI_MAXSP);
	if(vehicle_acceleration <= 0.0) vehicle_acceleration = float(GetVehicleInfo(modelid - 400, VI_USCOR));

	if(car_market_data[car_market_id][select_car][CM_NAME][0])
		format(fmt_text, sizeof fmt_text, "%s", car_market_data[car_market_id][select_car][CM_NAME]);
	else
		format(fmt_text, sizeof fmt_text, "%s", GetVehicleInfo(modelid - 400, VI_NAME));
	PlayerTextDrawSetString(playerid, avtsln_PTDD[playerid][0], fmt_text);
	new price_str[32], price_td_str[48];
	FormatNumberDots(vehicle_price, price_str, sizeof price_str);
	format(price_td_str, sizeof price_td_str, "%s РУБ.      ", price_str);
	PlayerTextDrawSetString(playerid, avtsln_PTDD[playerid][1], price_td_str);

	format(fmt_text, sizeof fmt_text, "%d км/ч", vehicle_speed);
	PlayerTextDrawSetString(playerid, avtsln_PTDD[playerid][2], fmt_text);

	format(fmt_text, sizeof fmt_text, "%.1f сек", vehicle_acceleration);
	PlayerTextDrawSetString(playerid, avtsln_PTDD[playerid][3], fmt_text);

	TextDrawSetString(avtsln_TD[7], "txd:brsalonlimit");
	if(car_market_id == TRUCK_SALON_MARKET_ID)
	{
		format(limit_text, sizeof limit_text, "-");
		switch(modelid)
		{
			case 514:
			{
				TextDrawSetString(avtsln_TD[7], "txd:brsaloncargo");
				format(limit_text, sizeof limit_text, "15.0 ТОНН");
			}
			case 403:
			{
				TextDrawSetString(avtsln_TD[7], "txd:brsaloncargo");
				format(limit_text, sizeof limit_text, "14.5 ТОНН");
			}
		}
	}
	PlayerTextDrawSetString(playerid, avtsln_PTDD[playerid][4], limit_text);
	buy_car_select_color[playerid][0] = GetPlayerData(playerid, P_AUTOSALON_COLOR1);
	buy_car_select_color[playerid][1] = GetPlayerData(playerid, P_AUTOSALON_COLOR2);
	ApplyAutosalonPreviewColor(playerid);
	return 1;
}
public: ShowBuyCarInfo(playerid, vehicleid)
{
	new text[275];

	//static const vehicle_class_name[][] = {"Мото-вело", "Эконом", "Средний", "Премиум"};

	new modelid = GetVehicleModel(vehicleid) - 400;
	format
	(
		text, sizeof text,
		"{FFFFFF}Тип автомобиля:\t%s класс\n\
		Название:\t\t%s\n\
		Номер модели:\t%d\n\
		Стоимость аренды:\t{FFFF00}%d руб.\n\
		{FFFFFF}Стоимость покупки:\t{00CC00}%d руб.\n\n\
		{FFFFFF}Для покупки этой модели нажмите \"Купить\"\n\
		Чтобы взять авто в аренду используйте /rentcar",
		"Неопределённый",
		//vehicle_class_name[ GetVehicleInfo(modelid, VI_TYPE) ],
		GetVehicleInfo(modelid, VI_NAME),
		modelid + 400,
		GetVehicleInfo(modelid, VI_PRICE) / 100,
		GetVehicleInfo(modelid, VI_PRICE)
	);

	Dialog(playerid, DIALOG_BIZ_CAR_MARKET_CAR_INFO, DIALOG_STYLE_MSGBOX, "{FF9900}Авторынок", text, "Купить", "Выйти");
	return 1;
}

stock RefreshAutosalonChat(playerid)
{
	SetPlayerCleanChat(playerid, 1);
	SetPlayerCleanChat(playerid, 0);
	return 1;
}

stock bool:PlayerHasFreeCarSlotForMarket(playerid, biz_id)
{
	if((GetPlayerOwnableCars(playerid) + 1) <= GetPlayerCarSlots(playerid))
	{
		return true;
	}

	if(IsMotoSalonBiz(biz_id))
	{
		SendClientMessage(playerid, 0x3399FFFF, "Все слоты для покупки нового мотоцикла заняты. Вы можете увеличить их: {FFFF00}\"/donate\"");
	}
	else
	{
		SendClientMessage(playerid, 0x3399FFFF, ""USC"У вас нет свободного слота. Вы можете купить их: {FFFF00}/donate");
	}
	return false;
}

stock EnterPlayerBuyCarMarket(playerid, biz_id)
{
	if(!PlayerHasFreeCarSlotForMarket(playerid, biz_id))
	{
		return 1;
	}

	if(biz_id == -1 || GetBusinessData(biz_id, B_TYPE) != BUSINESS_TYPE_CAR_MARKET)
		return 1;

	if(GetPVarInt(playerid, "car_market_open_lock") > GetTickCount())
		return 1;
	SetPVarInt(playerid, "car_market_open_lock", GetTickCount() + 1000);

	SetPlayerInBiz(playerid, biz_id);

	if(GetPlayerData(playerid, P_BUY_CAR) != INVALID_VEHICLE_ID)
	{
		DestroyVehicle(GetPlayerData(playerid, P_BUY_CAR));
		SetPlayerData(playerid, P_BUY_CAR, INVALID_VEHICLE_ID);
	}

	new car_market_id = GetCarMarketIdByBizId(biz_id);
	if(car_market_id == -1)
		return 1;

	new modelid = car_market_data[car_market_id][0][CM_MODELID];
	if(!modelid)
		return 1;

	buy_car_select_car[playerid] = 0;
	buy_car_select_color_type[playerid] = 0;
	buy_car_select_color[playerid][0] = 1;
	buy_car_select_color[playerid][1] = 1;
	SetPlayerData(playerid, P_AUTOSALON_COLOR1, 1);
	SetPlayerData(playerid, P_AUTOSALON_COLOR2, 1);

	new vehicleid = CreateVehicle(modelid, 1149.8434, 226.0655, 995.1953, 67.6542, 1, 1, 1);
	SetPlayerData(playerid, P_BUY_CAR, vehicleid);
	ApplyCarMarketPreviewScene(playerid, vehicleid, car_market_id, (car_market_id == MOTO_SALON_MARKET_ID));

	CallLocalFunction("BuyCarPTDUpdate", "i", playerid);
	CreateAutosalonTextDraws(playerid);
	HideHud(playerid);
	RefreshAutosalonChat(playerid);
	return 1;
}

