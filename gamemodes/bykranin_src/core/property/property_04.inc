//>> Файл: bykranin_src/core/property/property_04.inc  (377 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: ShowPlayerHotelRoomPayForRent, ShowPlayerHotelClientMenu, GetHotelFreeRoom, ExitPlayerFromHotelRoom, EnterPlayerToHotelRoom, ShowPlayerHotelFloorsInfo, ShowPlayerHotelFloorsLift
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock ShowPlayerHotelRoomPayForRent(playerid)
{
	new hotel_id = GetPlayerInHotelID(playerid);
	new room_id = GetPlayerData(playerid, P_HOUSE_ROOM);

	if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == hotel_id)
	{
		new rent_days = GetElapsedTime(GetHotelData(hotel_id, room_id, H_RENT_DATE), gettime(), CONVERT_TIME_TO_DAYS);
		if(rent_days < 0)
		{
			rent_days = 0;
		}

		new fmt_str[128];
		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFFFF}Оплаченных дней:\t\t%d из 30\n"\
			"Ежедневная плата:\t\t1000 руб\n\n"\
			"На сколько дней Вы хотите оплатить номер?",
			rent_days
		);
		Dialog(playerid, DIALOG_HOTEL_PAY_FOR_ROOM, DIALOG_STYLE_INPUT, "{66CC99}Оплата проживания в отеле", fmt_str, "Оплатить", "Назад");
	}
}

stock ShowPlayerHotelClientMenu(playerid, hotel_id)
{
	if(GetPlayerHouse(playerid, HOUSE_TYPE_HOTEL) == hotel_id)
	{
		Dialog
		(
			playerid, DIALOG_HOTEL_CLIENT_MENU, DIALOG_STYLE_LIST,
			"{66CC99}Меню клиента",
			"1. Оплатить проживание\n"\
			"2. Информация о транспорте\n"\
			"3. Отметить транспорт на GPS\n"\
			"4. Подогнать транспорт к отелю (1000 руб)\n"\
			"5. Продать транспорт\n"\
			"6. Выселиться из отеля",
			"Выбрать", "Назад"
		);
	}
					else
	{
		SendClientMessage(playerid, 0xCECECEFF, "Вы не проживаете в этой гостинице");
		ShowPlayerHotelDialog(playerid);
	}
}

stock GetHotelFreeRoom(hotelid)
{
	new free_room = -1;
	if(0 <= hotelid <= MAX_HOTELS-1)
	{
		new max_rooms = g_hotel_rooms_loaded[hotelid] / 12;

		for(new idx; idx < max_rooms; idx ++)
		{
			if(IsHotelRoomOwned(hotelid, idx)) continue;

			free_room = idx;
			break;
		}
	}
	return free_room;
}

stock ExitPlayerFromHotelRoom(playerid)
{
	new room_id = GetPlayerData(playerid, P_IN_HOTEL_ROOM);
	if(room_id != -1)
	{
		new hotel_id = GetPlayerInHotelID(playerid);
		if(hotel_id != -1)
		{
			if(IsPlayerInRangeOfPoint(playerid, 1.0, 490.0204, -992.8733, 1002.9255))
			{
				new floor = (room_id / 12) + 1;
				new index = (room_id % 12) / 5;

				SetPlayerPosEx
				(
					playerid,
					g_hotel_room_exit_pos[index][0],
					g_hotel_room_exit_pos[index][1],
					g_hotel_room_exit_pos[index][2],
					180.0,
					floor,
					((hotel_id + 1) * 200) + (floor + 1000)
				);
				SetPlayerData(playerid, P_IN_HOTEL_ROOM, -1);
			}
		}
	}
}

stock EnterPlayerToHotelRoom(playerid, hotel_id, room_id)
{
	if(GetPlayerData(playerid, P_IN_HOTEL_ROOM) == -1)
	{
		if(!GetHotelData(hotel_id, room_id, H_STATUS) || GetPlayerAccountID(playerid) == GetHotelData(hotel_id, room_id, H_OWNER_ID))
		{
			SetPlayerPosEx(playerid, 491.5204, -992.8733, 1002.9255, 0.0, 6, ((hotel_id + 1) * 400) + (room_id + 2000));
			SetPlayerData(playerid, P_IN_HOTEL_ROOM, room_id);

			SetPlayerData(playerid, P_IN_HOTEL_FLOOR, (room_id / 12) + 1);
		}
					else GameTextForPlayer(playerid, "~r~Closed", 2500, 1);
	}
	return 1;
}

stock ShowPlayerHotelFloorsInfo(playerid, hotel_id)
{
	new fmt_str[8 + 1];
	new string[(sizeof fmt_str - 1) * MAX_HOTEL_FLOORS];

	new max_floors = g_hotel_rooms_loaded[hotel_id] / 12;
	for(new idx; idx < max_floors; idx ++)
	{
		format(fmt_str, sizeof fmt_str, "%d этаж\n", idx + 1);
		strcat(string, fmt_str);
	}
	Dialog(playerid, DIALOG_HOTEL_FLOOR_SELECT, DIALOG_STYLE_LIST, "{FFCD00}Выберите этаж", string, "Выбрать", "Отмена");
}

stock ShowPlayerHotelFloorsLift(playerid, hotel_id, floor_id)
{
	new fmt_str[8 + 1];
	new string[(sizeof fmt_str - 1) * MAX_HOTEL_FLOORS];

	new max_floors = g_hotel_rooms_loaded[hotel_id] / 12;
	for(new idx, count; idx <= max_floors; idx ++)
	{
		if(idx == floor_id) continue;
		if(idx)
		{
			format(fmt_str, sizeof fmt_str, "%d этаж\n", idx);
			strcat(string, fmt_str);
		}
					else strcat(string, "Выход\n");

		SetPlayerListitemValue(playerid, count ++, idx);
	}
	Dialog(playerid, DIALOG_HOTEL_FLOOR_LIFT, DIALOG_STYLE_LIST, "{FFCD00}Выберите этаж", string, "Выбрать", "Отмена");
}

stock ShowPlayerHotelFloorInfo(playerid, hotel_id, floor_id)
{
	if(0 <= hotel_id <= MAX_HOTELS-1)
	{
		if(0 <= floor_id <= MAX_HOTEL_FLOORS-1)
		{
			new string[256];
			new fmt_str[45 + 1];

			new rent_time;
			new time = gettime();

			new s_idx = floor_id * 12;
			new e_idx = s_idx + 12;

			string = "Номер\t\tСтатус\t\tОплаченные дни\tПостоялец\n\n{FFFFFF}";
			while(s_idx < e_idx)
			{
				if(IsHotelRoomOwned(hotel_id, s_idx))
				{
					rent_time = GetElapsedTime(GetHotelData(hotel_id, s_idx, H_RENT_DATE), time, CONVERT_TIME_TO_DAYS);
					if(rent_time < 0)
						rent_time = 0;

					format(fmt_str, sizeof fmt_str, "%d\t\t%s\t\t%d\t\t%s\n", (s_idx % 12) + 1, rent_time > 0 ? ("Занят\t") : ("Выселение"), rent_time, GetHotelData(hotel_id, s_idx, H_OWNER_NAME));
				}
					else format(fmt_str, sizeof fmt_str, "%d\t\tСвободен\n", (s_idx % 12) + 1);
				strcat(string, fmt_str);

				s_idx ++;
			}

			format(fmt_str, sizeof fmt_str, "{66CC99}Список номеров на %d этаже", floor_id + 1);
			Dialog(playerid, DIALOG_HOTEL_FLOOR_INFO, DIALOG_STYLE_MSGBOX, fmt_str, string, "Назад", "Закрыть");
		}
	}
}

stock ShowPlayerHotelDialog(playerid)
{
	if(GetPlayerInHotelID(playerid) != -1)
	{
		new businessid = GetPlayerInBiz(playerid);

		Dialog
		(
			playerid, DIALOG_HOTEL, DIALOG_STYLE_LIST,
			GetBusinessData(businessid, B_NAME),
			"1. Список номеров\n"\
			"2. Регистрация\n"\
			"3. Меню клиента",
			"Выбрать", "Закрыть"
		);
	}
}

stock GetPlayerInHotelID(playerid)
{
	new hotel_id = -1;
	new businessid = GetPlayerInBiz(playerid);

	if(businessid != -1)
	{
		if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_HOTEL)
		{
			switch(businessid)
			{
				case 30:
					hotel_id = 0;

				case 31:
					hotel_id = 1;

				case 32:
					hotel_id = 2;

				default:
					hotel_id = -1;
			}
		}
	}
	return hotel_id;
}

stock EntranceStatusInitAll()
{
	for(new idx; idx < g_entrance_loaded; idx ++)
	{
		CallLocalFunction("EntranceStatusInit", "i", idx);
	}
}

stock UpdateEntrance(entranceid, houses)
{
	new status = (houses >= GetEntranceData(entranceid, E_FLOORS) * 4);

	if(GetEntranceData(entranceid, E_STATUS) != status)
	{
		if(GetEntranceData(entranceid, E_PICKUP_ID))
			DestroyPickup(GetEntranceData(entranceid, E_PICKUP_ID));

		if(IsValidDynamicMapIcon(GetEntranceData(entranceid, E_MAP_ICON)))
			DestroyDynamicMapIcon(GetEntranceData(entranceid, E_MAP_ICON));

		SetEntranceData(entranceid, E_PICKUP_ID, CreatePickup((status ? 1272 : 1273), 23, GetEntranceData(entranceid, E_POS_X), GetEntranceData(entranceid, E_POS_Y), GetEntranceData(entranceid, E_POS_Z), 0, PICKUP_ACTION_TYPE_ENTRANCE_ENT, entranceid));
		SetEntranceData(entranceid, E_MAP_ICON, CreateDynamicMapIcon(GetEntranceData(entranceid, E_POS_X), GetEntranceData(entranceid, E_POS_Y), GetEntranceData(entranceid, E_POS_Z), (status ? 40 : 40), 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL));

		SetEntranceData(entranceid, E_STATUS, status);
	}
}

stock ShowPlayerEntranceFloorsLift(playerid, entranceid, floor)
{
	new fmt_str[10];
	new string[(sizeof fmt_str) * MAX_ENTRANCE_FLOORS];

	new max_floors = GetEntranceData(entranceid, E_FLOORS) + 1;

	for(new idx, count; idx < max_floors; idx ++)
	{
		if(idx == floor) continue;
		if(idx)
		{
			format(fmt_str, sizeof fmt_str, "%d этаж\n", idx);
			strcat(string, fmt_str);
		}
					else strcat(string, "Подъезд\n");

		SetPlayerListitemValue(playerid, count ++, idx);
	}
	Dialog(playerid, DIALOG_ENTRANCE_LIFT, DIALOG_STYLE_LIST, "{FFCD00}Выберите этаж", string, "Выбрать", "Отмена");
}

stock EnterPlayerToEntrance(playerid, entranceid)
{
	if(GetPlayerInEntrance(playerid) == -1)
	{
		SetPlayerPosEx(playerid, 558.4705, 24.8017, 1049.2731, 357.8067, 1, entranceid + 2500);

		SendClientMessage(playerid, -1, "ЧТО БЫ КУПИТЬ КВАРТИРУ, СНАЧАЛО ИСПОЛЬЗУЙТЕ ЛИФТ, И ВЫБЕРИТЕ ЭТАЖ!");

		SetPlayerInEntranceFloor(playerid, 0);
		SetPlayerInEntrance(playerid, entranceid);
	}
}

stock SetPlayerFactoryDeskUse(playerid, deskid, bool: status)
{
	if(!(0 <= deskid <= sizeof factory_desk-1)) return ;

	if(GetPlayerTempJob(playerid) == TEMP_JOB_FACTORY)
	{
		if(status)
		{
			if(!factory_desk[deskid][FD_USED] && GetPlayerData(playerid, P_FACTORY_USE_DESK) == -1)
			{
				if(GetPlayerTempJobState(playerid) == TEMP_JOB_STATE_FACTORY_CREATE_P)
				{
					factory_desk[deskid][FD_USED] = true;

					// static const
					//	p_object_id[3] = {1954, 2926, 1718};

					// static const
					//	Float: p_object_z[3] = {0.09, 0.0, 0.06};

					// new rand = random(sizeof(p_object_id));
					// new Float: x, Float: y, Float: z;
					// GetPlayerPos(playerid, x, y, z);

					new Float: angle;

					new take_metall = GetPVarInt(playerid, "factory_take_metall");
					new factory_fuel = GetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT);

					SetPlayerData(playerid, P_FACTORY_USE_DESK, deskid);
					TogglePlayerFactoryCP(playerid, false);

					if(!((deskid / 4) % 2))
					{
						angle = 180.0;
					}
					else angle = 0.0;
					SetPlayerFacingAngle(playerid, angle);

					//factory_object[playerid] = CreateDynamicObject(p_object_id[rand], x, y, 1044.08 + p_object_z[rand], 0.0, 0.0, angle + 180.0);
					ApplyAnimationEx(playerid, "OTB", "betslp_loop", 4.1, 1, 0, 0, 1, 20_000, 0, USE_ANIM_TYPE_NONE - 1);

				//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND, 18644, A_OBJECT_BONE_RIGHT_HAND, 0.06, 0.02, 0.0, 30.0, 0.0, 0.0, 1.0, 1.0, 1.0, 0);
				//	SetPlayerAttachedObject(playerid, A_OBJECT_SLOT_HAND + 1, 18635, A_OBJECT_BONE_LEFT_HAND, 0.1, 0.06, -0.1, 180.0, 80.0, 0.0, 1.0, 1.0, 1.0, 0);

					SetPlayerTempJobState(playerid, TEMP_JOB_STATE_FACTORY_CREATED);
					SetTimerEx("CreateFactoryProd", 18_000, false, "i", playerid);

					SetRepositoryData(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL, R_AMOUNT, factory_fuel - (take_metall * 6));
					UpdateRepository(REPOSITORY_TYPE_FACTORY, REPOSITORY_ACTION_FACTORY_FUEL);
				}
					else
				{
					if(GetPlayerTempJobState(playerid) != TEMP_JOB_STATE_FACTORY_PUT_PROD)
						SendClientMessage(playerid, 0x999999FF, "Возьмите Материалы у раздаточного стола");
				}
			}
		}
					else
		{
			if(factory_desk[deskid][FD_USED])
			{
				if(GetPlayerData(playerid, P_FACTORY_USE_DESK) == deskid)
				{
					TogglePlayerFactoryCP(playerid, true);
					SetPlayerData(playerid, P_FACTORY_USE_DESK, -1);

					/*
					if(IsValidDynamicObject(factory_object[playerid]))
					{
						DestroyDynamicObject(factory_object[playerid]);
						factory_object[playerid] = -1;
					}
					*/
					factory_desk[deskid][FD_USED] = false;
				}
			}
		}
		UpdateFactoryDesk(deskid);
	}
}

