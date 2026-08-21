static Cache: ownableVehicleCache [ MAX_PLAYERS ] ;

stock ClearOwnableVehicleListCache ( playerid )
{
    if ( cache_is_valid ( ownableVehicleCache [ playerid ] ) ) {
        cache_delete ( ownableVehicleCache [ playerid ] ) ;
    }
    return true ;
}

CMD:testv ( playerid )
{
    if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;

    asdaweaw ( playerid ) ;
    return 1 ;
}

stock asdaweaw ( playerid )
{
    global_string [ 0 ] = EOS ;
    format ( global_string, 512, "\
        SELECT \
            uv.v_id, uv.v_model, uv.v_millage, uv.v_fuel, uv.v_date_used, uv.v_fine, uv.v_sell_price, \
		    IFNULL(lp.licence_plate_country, 'UNAVAILABLE') AS licence_plate_country, \
            IFNULL(lp.licence_plate_number, 'Отсутствует') AS licence_plate_number, \
            lp.licence_plate_region \
        FROM users_vehicles uv \
        LEFT JOIN licence_plate lp ON lp.licence_plate_use_own_car_id = uv.v_id \
        WHERE uv.v_owner = %d LIMIT %d", p_info [ playerid ] [ id ], p_info [ playerid ] [ max_veh ]
    ) ;
    mysql_tquery ( sql_connection, global_string, "LoadOwnableCarsList", "ii", playerid, true ) ;
    return 1 ;
}

callback: LoadOwnableCarsList ( playerid, bool: showList )
{
    new rows, fields ;
    cache_get_data ( rows, fields ) ;

    if ( ! rows )
    {
        send_check_cinfo ( playerid, "У Вас нет транспортных средств.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
        return 1 ;
    }

    if ( showList )
    {
        new Node: node = JSON_Array ( ), 
            incId, modelid, Float: fuel, Float: mileage, spawned,
            numberPlate [ 12 ], country [ 12 ], region [ 4 ], 
            isStatus, tempVehicleEndTime, priceVehicleSell, currentTime = gettime ( ) ;

        for ( new i = 0, Node: carNode, carsLoaded ; i < rows ; i ++ )
        {
            incId = cache_get_field_content_int ( i, "v_id" ) ;
            modelid = cache_get_field_content_int ( i, "v_model" ) ;
            mileage = cache_get_field_content_float ( i, "v_millage" ) ;
            fuel = cache_get_field_content_float ( i, "v_fuel" ) ;
            tempVehicleEndTime = cache_get_field_content_int ( i, "v_date_used" ) ;
            isStatus = cache_get_field_content_int ( i, "v_fine" ) ;
            priceVehicleSell = cache_get_field_content_int ( i, "v_sell_price" ) ;

            spawned = 0 ;
            foreach(new v: player_vehicles[playerid])
            {
                if ( veh_info [ v - 1 ] [ v_id ] != incId ) continue ;

                spawned = 1 ;
                break ;
            }

            cache_get_field_content ( i, "licence_plate_number", numberPlate ) ;
            cache_get_field_content ( i, "licence_plate_country", country ) ;

            if ( strcmp ( numberPlate, "Отсутствует") != 0 ) 
            {
                cache_get_field_content ( i, "licence_plate_region", region ) ;

                if ( ! strcmp ( country, "UA" ) ) {
                    format ( numberPlate, 24, "%s%s [%s]", region, numberPlate, country ) ;
                }
                else {
                    format ( numberPlate, 24, "%s %s [%s]", numberPlate, region, country ) ;
                }
            }

            if ( tempVehicleEndTime > 0 )
            {
                tempVehicleEndTime = floatround ( ( tempVehicleEndTime - currentTime ) / 3600, floatround_ceil ) ;
            }
            else 
            {
                tempVehicleEndTime = -1 ;
            }

            carNode = JSON_Array (
                JSON_Object (
                    "id",           JSON_Int ( i ),
                    "model",        JSON_Int ( modelid ),
                    "roadNumber",   JSON_String ( numberPlate ),
                    "modelName",    JSON_String ( veh_data [ modelid ] [ VEHICLE_NAME ] ),
                    "mileage",      JSON_Int ( floatround ( mileage ) ),
                    "fuel",         JSON_Int ( floatround ( fuel ) ),
                    "status",       JSON_Int ( spawned ),
                    "price",        JSON_Int ( veh_data [ modelid ] [ VEHICLE_PRICE ] ),
                    "country",      JSON_String ( country ),
                    "leftTime",     JSON_Int ( tempVehicleEndTime )
                )
            ) ;
            node = JSON_Append ( node, carNode ) ;

            if ( ++ carsLoaded == 5 || i == rows - 1 )
            {
                global_string [ 0 ] = EOS ;
                JSON_Stringify ( node, global_string, sizeof global_string ) ;
                onServerSendData ( playerid, UI_CARS_MENU, 0, global_string ) ;

                node = JSON_Array ( ) ;
                carsLoaded = 0 ;
            }
        }

        if ( priceVehicleSell > 0 )
        {
            onServerSendData ( playerid, UI_CARS_MENU, 1, "4" ) ;
        }
        else
        {
            if ( isStatus == 0 )
            {
                if ( p_info [ playerid ] [ family ] > 0 )
                    onServerSendData ( playerid, UI_CARS_MENU, 1, "1" ) ;

                else
                    onServerSendData ( playerid, UI_CARS_MENU, 1, "0" ) ;
            }
            else if ( isStatus == 1 )
            {
                onServerSendData ( playerid, UI_CARS_MENU, 1, "3" ) ;
            }
            else if ( isStatus == 2 )
            {
                onServerSendData ( playerid, UI_CARS_MENU, 1, "2" ) ;
            }
        }
    }

    ownableVehicleCache [ playerid ] = cache_save ( ) ;
    return true ;
}

stock show_packet_carsmenu ( playerid, actionId, data [ ] )
{
    new Node: node ;
    JSON_Parse ( data, node ) ;

    new vehicleIdx ;
    JSON_GetInt ( node, "index", vehicleIdx ) ;
    JSON_GetInt ( node, "actionId", actionId ) ;

    if ( vehicleIdx < 0 )
	{
		send_check_cinfo ( playerid, "Произошла ошибка при выборе авто!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
		return 1 ;
    }

    cache_set_active ( ownableVehicleCache [ playerid ] ) ;

	new rows, fields ;
	cache_get_data ( rows, fields ) ;

	switch ( actionId )
    {
        case 0: // Просмотреть инфу
        {
            new _number [ 24 ], country [ 3 ], region [ 12 ],
                _modelid, Float: _fuel, Float: _mileage, _spawned = 0, _vehid,
				plateType = 1 ;

			_vehid = cache_get_field_content_int ( vehicleIdx, "v_id" ) ;
			_modelid = cache_get_field_content_int ( vehicleIdx, "v_model" ) ;
			_mileage = cache_get_field_content_float ( vehicleIdx, "v_millage" ) ;
			_fuel = cache_get_field_content_float ( vehicleIdx, "fuel" ) ;
			
			foreach(new i: player_vehicles[playerid])
			{
				if ( veh_info [ i - 1 ] [ v_id ] != _vehid ) continue ;

				_spawned = 1 ;
				break ;
			}

			cache_get_field_content ( vehicleIdx, "licence_plate_country", country, sql_connection, 8 ) ;
			cache_get_field_content ( vehicleIdx, "licence_plate_number", _number, sql_connection, 12 ) ;
			cache_get_field_content ( vehicleIdx, "licence_plate_region", region, sql_connection, 12 ) ;

			if ( GetString ( country, "RU POLICE" ) ) plateType = NUMBERPLATE_TYPE_RU_POLICE ;
			else if ( GetString ( country, "RU" ) ) plateType = NUMBERPLATE_TYPE_RUS ;
			else if ( GetString ( country, "UA" ) ) plateType = NUMBERPLATE_TYPE_UA ;
			else if ( GetString ( country, "BY" ) ) plateType = NUMBERPLATE_TYPE_BY ;
			else if ( GetString ( country, "KZ" ) ) plateType = NUMBERPLATE_TYPE_KZ ;

            if ( plateType > 1 ) 
            {
                if ( ! strcmp ( country, "UA" ) ) {
                    format ( _number, 24, "%s%s [%s]", region, _number, country ) ;
                }
                else {
                    format ( _number, 24, "%s %s [%s]", _number, region, country ) ;
                }
            }

			global_string [ 0 ] = EOS ;
            format ( global_string, 512, "\
                {"#cWH"}Автомобиль №%d {"#cOR"}%s\n\n\
                {"#cWH"}Модель:\t\t{"#cOR"}%s{"#cWH"} (%d)\n\
                {"#cWH"}Номер:\t\t\t{"#cOR"}%s\n\
                {"#cWH"}Стоимость:\t\t{"#cGN"}%d рублей\n\
                {"#cWH"}Пробег:\t\t{"#cWV"}%d КМ\n\
                {"#cWH"}Топливо:\t\t{"#cWV"}%d литров\n\n\
				{"#cWH"}Количество данной модели на сервере: {"#cWV"}%d шт.\n\
                {"#cWH"}%s",
                vehicleIdx + 1, ( _spawned ) ? ( "(Используется)" ) : (""),
                GetVehicleNameEx ( INVALID_VEHICLE_ID, _modelid ), _modelid,
                _number,
                GetModelPrice ( _modelid ),
                floatround ( _mileage ),
                floatround ( _fuel ),
				get_model_count ( _modelid ),
                item_description ( _modelid )
            ) ;

            show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Ваш транспорт", global_string, "Закрыть", "" ) ;
            return true ;
        }
        case 1: // Загрузить/Выгрузить
        {
			new isVehicleLoaded,
				vehid = cache_get_field_content_int ( vehicleIdx, "v_id" ) ;
			
			foreach(new i: player_vehicles[playerid])
			{
				if ( veh_info [ i - 1 ] [ v_id ] != vehid ) continue ;

				isVehicleLoaded = 1 ;
				vehid = i ;
				break ;
			}

            if ( isVehicleLoaded )
            {
                global_string [ 0 ] = EOS ;
				format ( global_string, 512, "\
				UPDATE `users_vehicles` SET `v_fuel` = '%f',`v_millage` = '%f',\
				`v_last_pos_x` = '%.2f', `v_last_pos_x` = '%.2f', `v_last_pos_x` = '%.2f', `v_last_pos_x` = '%.2f'\
				WHERE `v_id` = '%d' LIMIT 1",
				veh_info [ vehid - 1 ] [ v_fuel ],
				veh_info [ vehid - 1 ] [ v_millage ],
				veh_info [ vehid - 1 ] [ v_now_pos ] [ 0 ],
				veh_info [ vehid - 1 ] [ v_now_pos ] [ 1 ],
				veh_info [ vehid - 1 ] [ v_now_pos ] [ 2 ],
				veh_info [ vehid - 1 ] [ v_now_pos ] [ 3 ],
				veh_info [ vehid - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, global_string, "", "" ) ;

		        Iter_Remove(player_vehicles[playerid], vehid ) ;
				DestroyVehicle ( vehid, 101 ) ;

                send_check_cinfo ( playerid, "Вы успешно выгрузили выбранное т/с.", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_SUCESS, "", "" ) ;
            }
            else
            {
				global_string [ 0 ] = EOS ;
				format ( global_string, 256, "SELECT uv.*, lp.* \
									FROM users_vehicles uv \
									LEFT JOIN licence_plate lp \
									ON lp.licence_plate_use_own_car_id = uv.v_id \
									WHERE `v_id` = '%d' LIMIT 1", vehid ) ;
				mysql_tquery ( sql_connection, global_string, "load_player_vehicles", "iii", playerid, false, -1 ) ;

				set_player_use_listitem ( playerid, 0 ) ;
            }
            return true ;
        }
       	case 2: // Отметить на карте
        {
			new isVehicleLoaded,
				vehid = cache_get_field_content_int ( vehicleIdx, "v_id" ) ;
			
			foreach(new i: player_vehicles[playerid])
			{
				if ( veh_info [ i - 1 ] [ v_id ] != vehid ) continue ;

				isVehicleLoaded = 1 ;
				vehid = i ;
				break ;
			}

            if ( isVehicleLoaded )
            {
				SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
				is_gps_used { playerid } = 1 ;

	            find_mark ( playerid, vehid ) ;   
            }
            else
            {
				global_string [ 0 ] = EOS ;
                format ( global_string, 124, "\
                    SELECT \
                        v_pos_x, \
                        v_pos_y, \
                        v_pos_z \
                    FROM users_vehicles \
                    WHERE v_id = %d LIMIT 1",
                    vehid
                ) ;
                mysql_tquery ( sql_connection, global_string, "MarkParkedVehicle", "i", playerid ) ;
            }        

			onServerDestroy ( playerid, UI_CARS_MENU ) ;
            return true ;
        }   
        case 3: // Продать в гос.
        {
            new tempVehicleEndTime = cache_get_field_content_int ( vehicleIdx, "v_date_used" ) ;
            new isStatus = cache_get_field_content_int ( vehicleIdx, "v_fine" ) ;
            new modelid = cache_get_field_content_int ( vehicleIdx, "v_model" ) ;
            new priceVehicleSell = cache_get_field_content_int ( vehicleIdx, "v_sell_price" ) ;

            if ( tempVehicleEndTime > 0 )
            {
                send_check_cinfo ( playerid, "Вы не можете продать временное т/с!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                return 1 ;
            }

            if ( priceVehicleSell > 0 )
            {
                send_check_cinfo ( playerid, "Вы не можете продать т/с, которое выставлено на продажу!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                return 1 ;
            }

            if ( isStatus == 1 )
            {
                send_check_cinfo ( playerid, "Вы не можете продать т/с, которое находится на штрафстоянке!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                return 1 ;
            }
            else if ( isStatus == 2 )
            {
                send_check_cinfo ( playerid, "Вы не можете продать т/с, которое находится в семье!", 0, 3, CINFO_OTHER_ID, PICTURE_INFO_ERROR, "", "" ) ;
                return 1 ;
            }

            new veh_price = veh_data [ modelid ] [ VEHICLE_PRICE ],
				dialog_str [ 141 + 32 + 9 ] ;

			format ( dialog_str, sizeof ( dialog_str ),"{"#cBL"}Вы действительно хотите продать %s государству за %s"valute_title"?\n\n{"#cGRDialog"}* Для продажи игроку используйте: /sellcar [ид/имя] [цена]",
			veh_data [ modelid ] [ VEHICLE_NAME ], GetPlayerCashValueToSmile ( floatround ( ( veh_price * sell_percent ) / 100 ) ) ) ;
			show_dialog ( playerid, d_sellcar_gov, DIALOG_STYLE_MSGBOX," {"#cBL"}Продажа транспортного средства", dialog_str, "Да", "Нет" ) ;
            return true ;
        }
        /*case 4: // Добавить в семью
        {
            if(!IsPlayerFamilyLeader(playerid)) {
                return ShowErrorNotification(playerid, "Данная возможность доступна только лидеру семьи");
            }

            new isTempVehicle;
            cache_get_value_index_int(vehicleIdx, sql_vehicle_temp, isTempVehicle);

            if(isTempVehicle) {
                return ShowNotificationToPlayer(playerid, "Вы не можете передать промокодный автомобиль в семью", NOTIFICATION_ERROR);
            }

            new isVehicleLoaded;
            cache_get_value_index_int(vehicleIdx, sql_vehicle_spawned, isVehicleLoaded);

            if(isVehicleLoaded) {
                return ShowNotificationToPlayer(playerid, "Сперва Вы должны выгрузить Т/С сервера", NOTIFICATION_ERROR);
            }

            new vehicleUID;
            cache_get_value_index_int(vehicleIdx, sql_vehicle_uid, vehicleUID);

            if(SetOwnableCarToFamily(playerid, vehicleUID)) // Если авто добавлено в семью - удаляем с интерфейса
            {
                RemoveVehicleFromCarsUI(playerid, vehicleIdx);

                if(player_temp[playerid][PT_CAR_COUNT] == 0) {
                    DestroyUI(playerid, UI_CARS);
                }
                else 
                {
                    ClearOwnableVehicleListCache(playerid);
                    GetOwnableCarsList(playerid, false);
                }
            }
            return true ;
        }*/
    }
	return true ;
}

callback: MarkParkedVehicle ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows ) return 1 ;

	new Float: posX, Float: posY, Float: posZ ;
	posX = cache_get_field_content_float ( 0, "v_pos_x" ) ;
	posY = cache_get_field_content_float ( 0, "v_pos_y" ) ;
	posZ = cache_get_field_content_float ( 0, "v_pos_z" ) ;

	SetPlayerRaceCheckpoint ( playerid, 1, posX, posY, posZ, 0.0, 0.0, 0.0, 2.0 ) ;
	SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}[GPS] - Метка установлена." ) ;
	is_gps_used { playerid } = 1 ;
	return 1 ;
}