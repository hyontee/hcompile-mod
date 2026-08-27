/*
ОЧЕНЬ ВАЖНО!
ищем в коде #include "api/register/ipacket.inc"
и добавляем ПЕРЕД ним
#include "../include/system/stalls.pwn"
подключаем ко всем инклудам
это где-то строка 8252 в моде Werton OLD

//поменяй типы бизнесов на те что снизу
enum // типы бизнесов
{
	BUSINESS_TYPE_SHOP_24_7 = 1, 	// магазин 24/7
	BUSINESS_TYPE_CLUB = 2, 		// клуб (алхамбра)
	BUSINESS_TYPE_REALTOR_BIZ = 3, 	// управление статистики (бизнесы)
	BUSINESS_TYPE_REALTOR_HOME = 4,	// риелторское агенство (дома)
	BUSINESS_TYPE_CLOTHING_SHOP = 5,// магазин одежды
	BUSINESS_TYPE_HOTEL = 6,		// отель
	BUSINESS_TYPE_CAR_MARKET = 7,	// авторынок
	BUSINESS_TYPE_CASINO = 8,		// казино
	BUSINESS_TYPE_CELL_SALON = 9,	// сотовый салон
	BUSINESS_TYPE_CAR_TUNING = 10, 	// станция тех. обслуживания
	BUSINESS_TYPE_SHOP_GUN = 11, 	// магазин оружия (либо просто добавьте этот)
	BUSINESS_TYPE_ACCESSORY_SHOP = 13,// магазин аксов
	BUSINESS_TYPE_STALLS = 14, 	    // ларьки
};

в IPacket:251(playerid, BitStream:bs) 
добавить после switch(rpcid)

(если что в \gamemodes\api\register\ipacket.inc)

        case 3:
        {
            new query[220];
            new actionType, orderMask;

            JSON_GetInt(json, "t", actionType);
            JSON_GetInt(json, "r", orderMask);

            if(actionType == 1 && orderMask > 0)
            {
                new totalCost = CalculateTotalCost(orderMask);

                if(GetPlayerMoney(playerid) >= totalCost)
                {
                    new str[128];
                    format(str, sizeof(str), "Вы потратили %dp! Приятного аппетита!", totalCost);
                    ShowClientNotification(playerid, 2, 5, 1, 1, str, "");

                    GivePlayerMoneyEx(playerid, -totalCost);

                    golod[playerid] += 20;
                    if(golod[playerid] > 100) golod[playerid] = 100;

                    new businessid = GetPlayerInBiz(playerid), take_prods = random(4) + 6;
                    if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                    {
                        format(query, sizeof query, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+totalCost, GetBusinessData(businessid, B_SQL_ID));
                        mysql_query(mysql, query, false);
                    }

                    if(!mysql_errno())
                    {
                        if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                        {
                            AddBusinessData(businessid, B_PRODS, -, take_prods);
                            AddBusinessData(businessid, B_BALANCE, +, totalCost);
                        }

                        mysql_format(mysql, query, sizeof query, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), totalCost, IsBusinessOwned(businessid));
                        mysql_query(mysql, query, false);
                    }
                }
                else
                {
                    ShowClientNotification(playerid, 2, 5, 1, 1, "Недостаточно денег для покупки еды!", "");
                }
            }

            new Node:response = JSON_Object();
            JSON_SetInt(response, "t", actionType);
            JSON_SetInt(response, "r", orderMask);

            new outcoming_data[256];
            JSON_Stringify(response, outcoming_data);

            OnPacketIncoming2(playerid, 3, outcoming_data);

            JSON_Cleanup(response);

            SetPlayerInBiz(playerid, -1);
        }
        
теперь заменяем UpdateBusinessLabel(businessid) полностью на то что ниже

public: UpdateBusinessLabel(businessid)
{
	new fmt_str[129 + 1];
	
	new type = GetBusinessData(businessid, B_TYPE);
	if(type == BUSINESS_TYPE_SHOP_24_7)
	{
	if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Магазин 24/7 (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Магазин 24/7 (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
	else if(type == BUSINESS_TYPE_CLOTHING_SHOP)
	{
	if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Магазин одежды (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Магазин одежды (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
    else if(type == BUSINESS_TYPE_CASINO)
	{
	if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Казино (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Казино (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
    else if(type == BUSINESS_TYPE_SHOP_GUN)
	{
	if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Магазин оружия (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Магазин оружия (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
    else if(type == BUSINESS_TYPE_ACCESSORY_SHOP)
	{
	if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Аксессуары (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Аксессуары (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
	else if(type == BUSINESS_TYPE_STALLS)
	{
	if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Ларек (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Ларек (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
    else if(GetBusinessData(businessid, B_SQL_ID) == 34)
    {
    if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Мотосалон (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Мотосалон (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
    else if(GetBusinessData(businessid, B_SQL_ID) == 35)
    {
    if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Автосалон низкого класса (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Автосалон низкого класса (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
	else if(GetBusinessData(businessid, B_SQL_ID) == 36)
    {
    if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Автосалон высокого класса (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Автосалон высокого класса (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
    else if(GetBusinessData(businessid, B_SQL_ID) == 37)
    {
    if(!IsBusinessOwned(businessid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Автосалон среднего класса (%d)\n"\
			"{66CC00}Бизнес продается\n"\
			"Используйте /buybiz\n"\
			"Цена: %d руб",
			businessid, 
			GetBusinessData(businessid, B_PRICE)
		);
	}
	else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00}Автосалон среднего класса (%d)\n"\
			"Крыша: Арзамасское ОПГ\n"\
			"{FFFFFF}Владелец: {0099FF}%s\n",
			businessid, 
			GetBusinessData(businessid, B_OWNER_NAME)
		);

		if(!GetBusinessData(businessid, B_LOCK_STATUS))
		{
			if(GetBusinessData(businessid, B_ENTER_PRICE) > 0)
			{
				format(fmt_str, sizeof fmt_str, "%s{66CC00}Вход: {FF9900}%d руб", fmt_str, GetBusinessData(businessid, B_ENTER_PRICE));
			}
			else strcat(fmt_str, "{66CC00}Вход свободный");
		}
		else strcat(fmt_str, "{FF6600}Закрыто");
	}
    }
    
	UpdateDynamic3DTextLabelText(GetBusinessData(businessid, B_LABEL), 0xFFFF00FF, fmt_str);
}

public: UpdateRealtorBizInfo()
{
	new count = 0;
	new fmt_str[128];

	g_business_realtor_list = "";
	for(new idx; idx < g_business_loaded; idx ++)
	{
		if(IsBusinessOwned(idx)) continue;
		g_business_realtor_list_idx[count ++] = idx;

		format(fmt_str, sizeof fmt_str, "%d\n", idx);
		strcat(g_business_realtor_list, fmt_str);
	}

	count = GetFreeBusinessCount();
	format
	(
		fmt_str, sizeof fmt_str,
		"Состояние бизнеса\n"\
		"(обновляется каждый час)\n\n"\
		"{FF6633}Куплено бизнесов: %d\n"\
		"{99FF33}Свободно бизнесов: %d",
		g_business_loaded - count,
		count
	);
	UpdateDynamic3DTextLabelText(g_business_realtor_label, 0xCCFF66FF, fmt_str);
}

public: SetRealtorMakePhoto(playerid, type, index)
{
	if(GetPlayerData(playerid, P_REALTOR_TYPE) == type)
	{
		new Float: angle;
		new Float: pos_x, Float: pos_y, Float: pos_z;
		new Float: exit_x, Float: exit_y, Float:cam_x, Float:cam_y;

		switch(type)
		{
			case REALTOR_TYPE_HOUSE:
			{
				new entranceid = GetHouseData(index, H_ENTRACE);
				if(entranceid != -1)
				{
					pos_x = GetEntranceData(entranceid, E_POS_X);
					pos_y = GetEntranceData(entranceid, E_POS_Y);
					pos_z = GetEntranceData(entranceid, E_POS_Z);

					exit_x = GetEntranceData(entranceid, E_EXIT_POS_X);
					exit_y = GetEntranceData(entranceid, E_EXIT_POS_Y);

					new fmt_str[32];
					format(fmt_str, sizeof fmt_str, "Номер подъезда: %d", entranceid + 1);
					SendClientMessage(playerid, 0x999999FF, fmt_str);
				}
				else
				{
					pos_x = GetHouseData(index, H_POS_X);
					pos_y = GetHouseData(index, H_POS_Y);
					pos_z = GetHouseData(index, H_POS_Z);

					exit_x = GetHouseData(index, H_EXIT_POS_X);
					exit_y = GetHouseData(index, H_EXIT_POS_Y);
				}
			}
			case REALTOR_TYPE_BIZ:
			{
				pos_x = GetBusinessData(index, B_POS_X);
				pos_y = GetBusinessData(index, B_POS_Y);
				pos_z = GetBusinessData(index, B_POS_Z);

				exit_x = GetBusinessData(index, B_EXIT_POS_X);
				exit_y = GetBusinessData(index, B_EXIT_POS_Y);
			}
		}
		angle = GetAngleToPoint(exit_x, exit_y, pos_x, pos_y);
		SetPlayerPos(playerid, pos_x, pos_y, pos_z);

		cam_x = pos_x + 15.0 * -floatsin(angle, degrees);
		cam_y = pos_y + 15.0 * floatcos(angle, degrees);

		SetPlayerCameraPos(playerid, cam_x, cam_y, pos_z + 10.0);
		SetPlayerCameraLookAt(playerid, pos_x, pos_y, pos_z);

		//HidePlayerWaitPanel(playerid);
		SetPlayerData(playerid, P_REALTOR_TYPE, type);
	}
}

команду тоже заменяем

CMD:addbiz(playerid, params[])
{
    if(TEST_SERVER == 1) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Данная команда не доступна на ТЕСТ СЕРВЕРЕ!");
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new type, price, rent_price; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /addbiz [тип] [стоимость] [цена аренды]");

	new fmt_text[320];

	if(!(1 <= type <= 11) && type != 13 && type != 14)
		return SendClientMessage(playerid, 0x999999FF, "Типы бизнесов: 1-24/7, 2-Клуб, 3-Управление стат., 4-Риэлторск., 5-Одежда, 6-Отель, 7-Авторынок, 8-Казино, 9-Сотовый салон 10 - Тюнинг салон 11-Магазин оружия 12-НЕТУ СУКА РОТ ЕБАЛ 13-Магазин аксессуаров (не ворк)");

	if(price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость бизнеса не может быть меньше 1");

	if(rent_price < 1) return SendClientMessage(playerid, 0x999999FF, "Стоимость аренды не может быть меньше 1");

	new Cache: result,
		idx = g_business_loaded;

	GetPlayerPos(playerid, g_business[idx][B_POS_X], g_business[idx][B_POS_Y], g_business[idx][B_POS_Z]);

	SetBusinessData(idx, B_PRICE,			price);
	SetBusinessData(idx, B_RENT_PRICE,		rent_price);
	SetBusinessData(idx, B_TYPE,			type);

	SetBusinessData(idx, B_INTERIOR,		type-1);



	format
	(
		fmt_text, sizeof fmt_text,
		"INSERT INTO business \
		(type, price, rent_price, x, y, z, interior)\
		VALUES ('%d', '%d', '%f', '%f', '%f', '%f', '%d')",
		type, price, rent_price,
		GetBusinessData(idx, B_POS_X),
		GetBusinessData(idx, B_POS_Y),
		GetBusinessData(idx, B_POS_Z),
		type-1
	);

	result = mysql_query(mysql, fmt_text, true);

	SetBusinessData(idx, B_SQL_ID, 		cache_insert_id());
	
	cache_delete(result);

	g_business_loaded ++;

	CreatePickup(1318, 23, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z), 0, PICKUP_ACTION_TYPE_BIZ_ENTER, idx);

	UpdateBusinessLabel(idx);

	new city[MAX_ZONES_NAME + 1], area[MAX_ZONES_NAME + 1];
	GetCityName(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), city);
	GetAreaName(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), area);
	format(fmt_text, sizeof fmt_text, "[A] %s[%d] создал бизнес №%d (%s / %s)", GetPlayerNameEx(playerid), playerid, idx, city, area);

	SendMessageToAdmins(fmt_text, 0x66CC33FF);

    if(type != 14) SendClientMessage(playerid, 0x3399FFFF, "Используйте {FFFF00}/bsetexitpos{3399FF}, чтобы завершить создание бизнеса");
    else SendClientMessage(playerid, 0x3399FFFF, "Вы создали бизнесс с типом {FFFF00}\"Ларек\"{3399FF}, установка выхода из бизнесса не требуется");
	return 1;
}

//ищем в моде stock EnterPlayerToBiz и заменяем фулл на то что ниже

stock EnterPlayerToBiz(playerid, businessid)
{
    if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_STALLS) return 1;
	print("okey");
	if(GetPlayerInBiz(playerid) == -1)
	{
		new type = GetBusinessData(businessid, B_TYPE),
			buffer = GetBusinessData(businessid, B_INTERIOR);

		printf("okey type %d buffer %d",type,buffer);

		if(type == BUSINESS_TYPE_CAR_TUNING)
		{
			new vehicleid = GetPlayerOwnableCar(playerid);

			if(vehicleid == INVALID_VEHICLE_ID)
				return 1;

			GetVehiclePos(vehicleid, vehicle_temp_position[playerid][0], vehicle_temp_position[playerid][3], vehicle_temp_position[playerid][2]);
			GetVehicleZAngle(vehicleid, vehicle_temp_position[playerid][3]);

			SetVehiclePos(vehicleid, 2503.6116,1503.9767,1497.8375);
			SetVehicleZAngle(vehicleid, 161.0);

			LinkVehicleToInterior(vehicleid, GetBusinessInteriorInfo(buffer, BT_ENTER_INTERIOR));
			SetVehicleVirtualWorld(vehicleid, businessid + 255);
		}

		SetPlayerPosEx
		(
			playerid,
			GetBusinessInteriorInfo(buffer, BT_ENTER_POS_X),
			GetBusinessInteriorInfo(buffer, BT_ENTER_POS_Y),
			GetBusinessInteriorInfo(buffer, BT_ENTER_POS_Z),
			GetBusinessInteriorInfo(buffer, BT_ENTER_ANGLE),
			GetBusinessInteriorInfo(buffer, BT_ENTER_INTERIOR),
			businessid + 255, false
		);
		SetPlayerInBiz(playerid, businessid);

		buffer = GetBusinessData(businessid, B_ENTER_MUSIC);
		
		if(1 <= buffer <= sizeof g_business_sound)
		{
			PlayerPlaySound(playerid, g_business_sound[buffer - 1], 0.0, 0.0, 0.0);
		}
	}
	return 1;
}

теперь ищем

case PICKUP_ACTION_TYPE_BIZ_ENTER:

и добавляем в него
                        if(GetBusinessData(action_id, B_TYPE) == BUSINESS_TYPE_STALLS)
					    {
                            SetPlayerInBiz(playerid, action_id);
						    ShowPlayerStallsMenu(playerid);
						    return 1;
					    }
*/

// Координаты для ларьков для автодобавления
new Float:larek_coords[15][3] = {
    {2744.195312, -2429.347167, 21.781099},
    {1801.870971, 2531.611572, 14.658257},
    {847.433837, 802.794616, 13.378705},
    {-2402.389892, 194.550170, 26.032144},
    {-256.008636, 573.953796, 12.194987},
    {-1760.459106, 791.015319, 35.744747},
    {-2322.793212, -150.507369, 26.527236},
    {-112.912979, 942.352966, 12.214087},
    {-111.541137, 905.045593, 12.214187},
    {57.969646, 942.911987, 12.212887},
    {154.856292, 586.634887, 12.214087},
    {1905.709228, 2103.839843, 15.697778},
    {1888.656494, -2243.409423, 11.075387},
    {1912.993286, -2267.191406, 11.091187},
    {2251.602783, -2110.579589, 22.037588}
};

new GolodTimer[MAX_PLAYERS];

/*#if defined _INC_STALLS
    #endinput
#endif
#define _INC_STALLS

#if defined OnGameModeInit
    #undef OnGameModeInit
#endif
#define OnGameModeInit Stalls_OnGameModeInitHook

#if defined Stalls_OnGameModeInitHook
    #endinput
#endif
#define Stalls_OnGameModeInitHook _@Stalls_OnGameModeInit

forward _@Stalls_OnGameModeInit();
public _@Stalls_OnGameModeInit()
{
    print("Вертон не гей");
    SetTimer("CheckAndAddLarekBusinesses", 2000, false);

    #if defined Stalls_OnGameModeInitHook
        return Stalls_OnGameModeInitHook();
    #else
        return 1;
    #endif
}*/

public OnGameModeInit()
{
	SetTimer("CheckForGolodColumn", 1000, false);
    SetTimer("CheckAndAddLarekBusinesses", 2000, false);

    #if defined lorki_OnGameModeInit
        return lorki_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit lorki_OnGameModeInit
#if defined lorki_OnGameModeInit
    forward lorki_OnGameModeInit();
#endif

// stalls_ сменил на lorki_ потому что какая-то хуйня с сервером была 

public OnPlayerConnect(playerid)
{
	KillTimer(GolodTimer[playerid]);
	SetTimerEx("load_golod", 20000, false, "i", playerid);

    #if defined stalls_OnPlayerConnect
        return stalls_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect stalls_OnPlayerConnect
#if defined stalls_OnPlayerConnect
    forward stalls_OnPlayerConnect(playerid);
#endif

forward load_golod(playerid);
public load_golod(playerid)
{
    new query[128];
    mysql_format(mysql, query, sizeof(query), "SELECT golod FROM `accounts` WHERE `id` = '%d'", playerid);
    new Cache:result = mysql_query(mysql, query);

    if(cache_num_rows(result) > 0)
    {
        new player_golod = cache_get_field_content_int(0, "golod");
        SetPVarInt(playerid, "golod", player_golod);
    }
    else
    {
        SetPVarInt(playerid, "golod", 100);
    }
    cache_delete(result);

    if(GetPVarInt(playerid, "golod") <= 100)
	{
        GolodTimer[playerid] = SetTimerEx("golodbr", 60000, true, "i", playerid);
	}
}

forward golodbr(playerid);
public golodbr(playerid)
{
    if(GetPVarInt(playerid, "golod") <= 0)
    {
        ShowNewNotification(playerid, 3, 5, 1, 1, "Вы проголодались,ваше здоровье ухудшилось", "");
        new Float:hp;
        GetPlayerHealth(playerid, hp);
        SetPlayerHealth(playerid, hp - 5.0);
    }
    else
    {
		new player_golod = GetPVarInt(playerid, "golod");
        player_golod -= 5;
        SetPVarInt(playerid, "golod", player_golod);
    }
    UpdatePlayerDatabaseInt(playerid, "golod", GetPVarInt(playerid, "golod"));

    return 1;
}

stock CalculateTotalCost(orderMask)
{
    new cost = 0;

    if(orderMask & (1 << 0)) cost += 120;
    if(orderMask & (1 << 1)) cost += 230;
    if(orderMask & (1 << 2)) cost += 320;
    if(orderMask & (1 << 3)) cost += 580;
    if(orderMask & (1 << 4)) cost += 80;
    if(orderMask & (1 << 5)) cost += 30;

    return cost;
}

stock ShowPlayerStallsMenu(playerid)
{
    new Node:json = JSON_Object();
    JSON_SetInt(json, "o", 1);
    JSON_SetInt(json, "m", GetPlayerMoney(playerid));
    ShowPlayerGUI(playerid, 3, json);
    JSON_Cleanup(json);
    
    return 1;
}

forward CheckForGolodColumn();
public CheckForGolodColumn()
{
    new query[128];
    mysql_format(mysql, query, sizeof(query), "SHOW COLUMNS FROM `accounts` LIKE 'golod'");
    new Cache:result = mysql_query(mysql, query);

    if (cache_num_rows(result) == 0)
    {
        mysql_format(mysql, query, sizeof(query), "ALTER TABLE `accounts` ADD COLUMN `golod` INT(11) NOT NULL DEFAULT '100'");
        mysql_query(mysql, query);
        printf("Столбец 'golod' был добавлен в таблицу 'accounts'.");
    }
    cache_delete(result);
    return 1;
}

forward CheckAndAddLarekBusinesses();
public CheckAndAddLarekBusinesses()
{
    new query[556];
    mysql_format(mysql, query, sizeof(query), "SELECT * FROM `business` WHERE `type` = 14");
    new Cache:result = mysql_query(mysql, query);

    if (mysql_errno() != 0)
    {
        printf("Ошибка SQL при проверке ларьков (SELECT): Код %d", mysql_errno());
        cache_delete(result);
        return 1;
    }
    if (cache_num_rows(result) == 0)
    {
        for (new i = 0; i < sizeof(larek_coords); i++)
        {
            mysql_format(mysql, query, sizeof(query),
                "INSERT INTO business (type, price, rent_price, x, y, z, interior, name) VALUES ('14', '10000000', '5000', '%f', '%f', '%f', '0', 'Ларек')",
                larek_coords[i][0], larek_coords[i][1], larek_coords[i][2]
            );
            mysql_query(mysql, query);
        }
        print("Ларьки (тип 14) успешно добавлены в базу данных.");
    }
    else
    {
        print("Ларьки (тип 14) уже существуют в базе данных.");
    }
    cache_delete(result);
	return 1;
}