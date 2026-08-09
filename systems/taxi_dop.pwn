//В enum E_PLAYER_STRUCT // структура игрока
	P_TAXI_COMPANY, //taxi
	P_TAXI_RATING, //taxi
	P_TAXI_ORDER,
	P_TAXI_VEHICLE,
	P_TAXI_TIMER,
	P_TAXI_SECOND,
	P_TAXI_SALARY_100M,
	Float:P_TAXI_MILEAGE,
	P_TAXI_ORDER_RATING


//Меняем
new const
	g_business_interiors[11][E_BUSINESS_INTERIOR_STRUCT] =
//На
new const
	g_business_interiors[12][E_BUSINESS_INTERIOR_STRUCT] =
//Добавляем в g_business_interiors[12][E_BUSINESS_INTERIOR_STRUCT]

    {
		"Таксопарк",
		-0.251249,2500.500000,2011.005126, 		// позиции пикапа (выход)
		-0.251249,2502.8,2011.005126,0.857749,// позиции входа
		1, 									// интерьер
		1.001608,2508.271484,2011.005126, 		// позиции аптечки
		0.0, 0.0, 0.0, 		// позиции покупки
		0.0, 0.0, 0.0,						// позиции 3д текста
		-1									// чекпоинт\пикап
	}

//Меняем
			if(!IsABike(vehicleid))
			{
				new	Float: fuels = GetVehicleData(vehicleid, V_FUEL),
					Float: veh_health;

				GetVehicleHealth(vehicleid, veh_health);

				SetVehicleParamsInit(vehicleid);
				SetVehicleData(vehicleid, V_MILEAGE, GetVehicleData(vehicleid, V_MILEAGE) + (float(speed) / 3600.0));
//На

			if(!IsABike(vehicleid))
			{
				new	Float: fuels = GetVehicleData(vehicleid, V_FUEL),
					Float: health, Float:mileage = float(speed) / 3600.0;

				GetVehicleHealth(vehicleid, health);
				SetFuelProgress(playerid, floatround(fuels));

				SetVehicleParamsInit(vehicleid);
				SetVehicleData(vehicleid, V_MILEAGE, GetVehicleData(vehicleid, V_MILEAGE) + mileage); //taxi
				if(GetPlayerData(playerid, P_TAXI_ORDER) != -1) AddPlayerData(playerid, P_TAXI_MILEAGE, +, mileage);


//В public: LoadPlayerData(playerid) (ищите подобные строки)

        SetPlayerData(playerid, P_TAXI_COMPANY,        		cache_get_field_content_int(0, "taxi_company")); //taxi
        SetPlayerData(playerid, P_TAXI_RATING,        		cache_get_field_content_int(0, "taxi_rating"));
		SetPlayerData(playerid, P_TAXI_VEHICLE, -1);
		SetPlayerData(playerid, P_TAXI_TIMER, -1);
		SetPlayerData(playerid, P_TAXI_ORDER, -1);
		PlayerTextDrawTaxi(playerid);
        