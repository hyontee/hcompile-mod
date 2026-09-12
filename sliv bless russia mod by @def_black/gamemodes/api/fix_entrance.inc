/*
// заменить кейс пикапа
                    case PICKUP_ACTION_TYPE_ENTRANCE_FLA:
							{
                                new flat_number = GetNearestFlat(playerid);
								new entranceid = GetPlayerInEntrance(playerid);
								new floor = GetPlayerInEntranceFloor(playerid);
								new entrance_sql_id = GetEntranceData(entranceid, E_SQL_ID);

								new house_sql_id = -1;
                                new query[128];
                                new Cache: result;

                                mysql_format(mysql, query, sizeof(query), "SELECT id FROM houses WHERE entrance = '%d' AND flat_floor = '%d' AND flat_number = '%d'", entrance_sql_id, floor, flat_number);
                                result = mysql_query(mysql, query, true);

                                if(cache_num_rows() > 0)
                                {
                                    house_sql_id = cache_get_field_content_int(0, "id");
									new houdeid = GetHouseIndexBySQLID(house_sql_id);
                                    ShowPlayerHouseInfo(playerid, houdeid);
								}
								else SendClientMessage(playerid, 0xFF0000FF, "Ошибка: Дом не найден.");
        						cache_delete(result);
							}

// заменить диалог
            case DIALOG_HOUSE_BUY:
			{
				new houseid = GetPlayerUseListitem(playerid);

				if(houseid >= 0 && response)
				{
					if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == -1)
					{
						if(GetPlayerHouse(playerid) == -1)
						{
							if(GetHouseData(houseid, H_ENTRACE) == -1)
		                    {
							    if(IsPlayerInRangeOfHouse(playerid, houseid, 5.0))
							    {
    								if(!IsHouseOwned(houseid))
	    							{
		    							if(GetPlayerMoneyEx(playerid) >= GetHouseData(houseid, H_PRICE))
			    						{
				    					    //if(Config[sBuyBiz] == 0)
					    		    		//{
										
									    	BuyPlayerHouse(playerid, houseid);

								    		EnterPlayerToHouse(playerid, houseid);
								    		PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);

									    	GameTextForPlayer(playerid, "~b~welcome ~g~to~n~~y~new ~w~home!", 4000, 1);
									    	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}Новый дом", "{FFFFFF}Вам нужно заплатить за дом в ближайшем отделением банка {FFCD00}(/gps)", "Ок", "");
							    	//	}
								    	//	else
								        	//	return Send(playerid,-1,"В данный момент все дома на сервере не доступны к покупке!");
								    
								    	}
								    	else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этого дома");
							    	}
							    	else
							    	{
								    	new fmt_str[64];

								    	format(fmt_str, sizeof fmt_str, "Этот дом уже куплен. Владелец: %s", GetHouseData(houseid, H_OWNER_NAME));
								    	SendClientMessage(playerid, 0xCECECEFF, fmt_str);
							    	}
						    	}
							}
							else
							{
								if(!IsHouseOwned(houseid))
	    						{
		    						if(GetPlayerMoneyEx(playerid) >= GetHouseData(houseid, H_PRICE))
			    					{
								    	BuyPlayerHouse(playerid, houseid);

										EnterPlayerToHouse(playerid, houseid);
										PlayerPlaySound(playerid, 1058, 0.0, 0.0, 0.0);

								    	GameTextForPlayer(playerid, "~b~welcome ~g~to~n~~y~new ~w~home!", 4000, 1);
								    	Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, "{3399FF}Новый дом", "{FFFFFF}Вам нужно заплатить за дом в ближайшем отделением банка {FFCD00}(/gps)", "Ок", "");
									}
									else SendClientMessage(playerid, 0xCECECEFF, "У Вас недостаточно денег для покупки этого дома");
							 	}
								else
								{
							    	new fmt_str[64];

									format(fmt_str, sizeof fmt_str, "Этот дом уже куплен. Владелец: %s", GetHouseData(houseid, H_OWNER_NAME));
									SendClientMessage(playerid, 0xCECECEFF, fmt_str);
								}
							}
						}
						else SendClientMessage(playerid, 0xCECECEFF, "У Вас уже есть дом. Чтобы купить новый - необходимо продать старый");
					}
					else SendClientMessage(playerid, 0xCECECEFF, "Вы снимаете номер в гостинице. Нужно выселиться перед покупкой дома");
				}
			}

// паблик

public: ShowPlayerHouseInfo(playerid, houseid)
{
	if(0 <= houseid <= g_house_loaded-1)
	{
		//if(GetPlayerInHouse(playerid) == -1)
		//{
			SetPlayerUseListitem(playerid, houseid);

			new fmt_str[60];
			new string[257];
			new type = GetHouseData(houseid, H_TYPE);

			if(IsHouseOwned(houseid))
			{
				if(!GetHouseData(houseid, H_EVICTION))
				{
					format(fmt_str, sizeof fmt_str, "{FFFFFF}Владелец: \t\t\t{00FF00}%s\t\t\t\t\t\t\t\t\t\n\n", GetHouseData(houseid, H_OWNER_NAME));
					strcat(string, fmt_str);
				}
				else
				{
				}
			}
			
			format(fmt_str, sizeof fmt_str, "{FFFFFF}Тип: \t\t\t{00FF00}%s\t\t\t\t\t\t\t\t\t\n", GetHouseData(houseid, H_NAME));
			strcat(string, fmt_str);

			if(GetHouseData(houseid, H_ENTRACE) != -1)
			{
				//format(fmt_str, sizeof fmt_str, "Этаж:\t\t\t\t%d\n", GetHouseData(houseid, H_FLAT_ID) / 4 + 1);
				//strcat(string, fmt_str);

				new flat_number = GetNearestFlat(playerid);
				new floor = GetPlayerInEntranceFloor(playerid);
				if(floor == 2) flat_number = flat_number + 4;

				format(fmt_str, sizeof fmt_str, "Номер квартиры:\t\t%d\n", flat_number);
				strcat(string, fmt_str);
				
				if(!IsHouseOwned(houseid)) strcat(string, "\n");

				format(fmt_str, sizeof fmt_str, "Номер подъезда:\t\t%d\n", GetPlayerInEntrance(playerid) + 1);
				strcat(string, fmt_str);
			}
			else
			{
				format(fmt_str, sizeof fmt_str, "Номер дома: \t\t\t{00FF00}%d\t\t\t\t\t\t\t\t\t\n", houseid);
				strcat(string, fmt_str);
				
				if(!IsHouseOwned(houseid)) strcat(string, "\n");
			}

			format(fmt_str, sizeof fmt_str, "Количество комнат: \t\t\t{00FF00}%d\t\t\t\t\t\t\t\t\t\n", GetHouseTypeInfo(type, HT_ROOMS));
			strcat(string, fmt_str);

			format(fmt_str, sizeof fmt_str, "Стоимость: \t\t\t{00FF00}%d руб\t\t\t\t\t\t\t\t\t\n", GetHouseData(houseid, H_PRICE));
			strcat(string, fmt_str);

			format(fmt_str, sizeof fmt_str, "Ежедневная квартплата: \t\t\t{00FF00}%d руб\t\t\t\t\t\t\t\t\t", GetHouseData(houseid, H_RENT_PRICE));
			strcat(string, fmt_str);

			if(IsHouseOwned(houseid))
			{
				if(GetHouseData(houseid, H_IMPROVEMENTS) >= 4)
				{
					format(fmt_str, sizeof fmt_str, " {33CC99}(%d руб)", GetHouseData(houseid, H_RENT_PRICE) / 2);
					strcat(string, fmt_str);
				}
				Dialog(playerid, DIALOG_HOUSE_ENTER, DIALOG_STYLE_LIST, "{FF0000}Дом занят", string, "Войти", "Отмена");
			}
			else Dialog(playerid, DIALOG_HOUSE_BUY, DIALOG_STYLE_LIST, "{33CC00}Дом свободен", string, "Купить", "Отмена");
		//}
	}
	return 1;
}

// заменить команду

CMD:addpadik(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 8) return SendClientMessage(playerid, 0xFF0000FF, "У вас недостаточно прав для использования этой команды.");

    extract params -> new type, price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addpadik [тип всех квартир] [цена всех квартир] [цена аренды всех квартир]");

    if(!(1 <= type <= 2) && type != 5)
	{
		SendClientMessage(playerid, 0x999999FF, "Типы квартир:");
		SendClientMessage(playerid, 0x999999FF, "1. Квартира эконом класса");
        SendClientMessage(playerid, 0x999999FF, "2. Квартира среднего класса");
		SendClientMessage(playerid, 0x999999FF, "5. Квартира наивысшего класса");
		SendClientMessage(playerid, 0x999999FF, "Примечание: использовать исключительно указанные типы");
		return 1;
	}

    new new_entrance_idx = g_entrance_loaded;
    g_entrance_loaded++;

    GetPlayerPos(playerid, g_entrance[new_entrance_idx][E_POS_X], g_entrance[new_entrance_idx][E_POS_Y], g_entrance[new_entrance_idx][E_POS_Z]);
    GetPlayerPos(playerid, g_entrance[new_entrance_idx][E_EXIT_POS_X], g_entrance[new_entrance_idx][E_EXIT_POS_Y], g_entrance[new_entrance_idx][E_EXIT_POS_Z]);
    GetPlayerFacingAngle(playerid, g_entrance[new_entrance_idx][E_EXIT_ANGLE]);

    SetEntranceData(new_entrance_idx, E_FLOORS, 2);

    new fmt_text[512];
    format(fmt_text, sizeof fmt_text, "INSERT INTO entrances (floors, pos_x, pos_y, pos_z, exit_x, exit_y, exit_z, exit_angle) " \
        "VALUES ('%d', '%f', '%f', '%f', '%f', '%f', '%f', '%f')",
        GetEntranceData(new_entrance_idx, E_FLOORS),
        GetEntranceData(new_entrance_idx, E_POS_X),
        GetEntranceData(new_entrance_idx, E_POS_Y),
        GetEntranceData(new_entrance_idx, E_POS_Z),
        GetEntranceData(new_entrance_idx, E_EXIT_POS_X),
        GetEntranceData(new_entrance_idx, E_EXIT_POS_Y),
        GetEntranceData(new_entrance_idx, E_EXIT_POS_Z),
        GetEntranceData(new_entrance_idx, E_EXIT_ANGLE)
    );

    new Cache: result = mysql_query(mysql, fmt_text, true);
    if(cache_affected_rows() > 0)
    {
        new sql_id = cache_insert_id();
        SetEntranceData(new_entrance_idx, E_SQL_ID, sql_id);

        UpdateEntrance(new_entrance_idx, new_entrance_idx); 
 
        new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
        GetCityName(GetEntranceData(new_entrance_idx, E_POS_X), GetEntranceData(new_entrance_idx, E_POS_Y), city);
        GetAreaName(GetEntranceData(new_entrance_idx, E_POS_X), GetEntranceData(new_entrance_idx, E_POS_Y), area);
        
        format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал подъезд №%d (SQL ID: %d) (%s / %s)", GetPlayerNameEx(playerid), playerid, new_entrance_idx, sql_id, city, area);
        SendMessageToAdmins(fmt_text, 0x66CC33FF);
        
        SendClientMessage(playerid, 0x66CC33FF, "Подъезд успешно создан!");
        SendClientMessage(playerid, 0x3399FFFF, "Используйте {FFFF00}/esetexitpos {3399FF}- чтобы установить точные координаты выхода.");

        new query[256];
		new flat_number_counter;

		for(new floor = 1; floor <= GetEntranceData(new_entrance_idx, E_FLOORS); floor++)
        {
            flat_number_counter = 1; // Сбрасываем счетчик квартир для каждого нового этажа
            for(new i = 0; i < 4; i++)
            {
                format(query, sizeof(query), "INSERT INTO houses (price, rent_price, type, entrance, flat_floor, flat_number)" \
                    "VALUES ('%d', '%d', '%d', '%d', '%d', '%d')",
                    price,
                    rent_price,
                    type,
                    sql_id,
                    floor, // Используем переменную цикла floor
                    flat_number_counter // Используем счетчик flat_number_counter
                );
                mysql_query(mysql, query, false);
                flat_number_counter++;
            }
        }
        SendClientMessage(playerid, 0x66CC33FF, "Все квартиры для подъезда успешно созданы!");
        // =============================================================
    }
    else
    {
        g_entrance_loaded--;
        
        printf("Ошибка выполнения запроса: %s", mysql_errno(mysql));
        SendClientMessage(playerid, 0xFF0000FF, "Ошибка при добавлении подъезда.");
    }

    return 1;
}
                            */

stock GetNearestFlat(playerid)
{
    new Float: x_pos, Float: y_pos, Float: z_pos;
        GetPlayerPos(playerid, x_pos, y_pos, z_pos);
    new closest_apartment_index = -1;
    new Float: min_distance_sq = -1.0;

    for(new i = 0; i < sizeof(g_entrance_flat_pos); i++)
    {
        new Float: apt_x = g_entrance_flat_pos[i][0];
        new Float: apt_y = g_entrance_flat_pos[i][1];
        new Float: apt_z = g_entrance_flat_pos[i][2];

        new Float: distance_sq = ((apt_x - x_pos) * (apt_x - x_pos)) +
                                 ((apt_y - y_pos) * (apt_y - y_pos)) +
                                 ((apt_z - z_pos) * (apt_z - z_pos));

        if(closest_apartment_index == -1 || distance_sq < min_distance_sq)
        {
            min_distance_sq = distance_sq;
            closest_apartment_index = i;
        }
    }
    
    if(closest_apartment_index != -1)
    {
        printf("[DEBUG] GetClosestApartment: Самая близкая квартира - %d", closest_apartment_index + 1);
        return closest_apartment_index + 1;
    }

    printf("[DEBUG] GetClosestApartment: Не удалось найти ближайшую квартиру.");
    return 0;
}