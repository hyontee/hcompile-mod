//>> Файл: bykranin_src/core/inventory/inventory_04.inc  (641 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: SellDebtorsHome, SellDebtorsBusiness, SellDebtorsFuel, /slethouse, /slet, CreateFractionCar, IsAIP
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock SellDebtorsHome()
{
	new query[800];
	for(new i; i < g_house_loaded; i ++)
	{
		new house_owner_id = GetHouseData(i, H_OWNER_ID);
		if(house_owner_id > 0)
		{
			new cur_time = gettime();
			new rent_time = (cur_time - (cur_time % 86400)) + (30 * 86400);

			if(GetHouseData(i, H_RENT_DATE) != rent_time)
			{
				SetHouseData(i, H_RENT_DATE, rent_time);
				format(query, sizeof query, "UPDATE houses SET rent_time=%d WHERE id=%d LIMIT 1", rent_time, GetHouseData(i, H_SQL_ID));
				mysql_query(mysql, query, false);
			}
			continue;
		}

		if(GetHouseData(i, H_RENT_DATE) < gettime())
		{
		    new owner_id = GetHouseData(i, H_OWNER_ID);

			if(owner_id == 0) continue;


			format(query, sizeof query, "UPDATE accounts a,houses h SET `house`=-1,`house_room`=-1,`house_type`=-1, h.owner_id='0', h.lock='0', h.rent_time='0' WHERE a.id=h.owner_id AND h.id='%d'", GetHouseData(i, H_SQL_ID));
			mysql_query(mysql, query, false);

			new Cache: result, owner_name[21];

			mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE id=%d LIMIT 1", owner_id);
			result = mysql_query(mysql, query);

			if(cache_num_rows(result))
				cache_get_field_content(0, "name", owner_name, mysql, 21);
			cache_delete(result);

			new owner_player = GetPlayerIDBySqlID(owner_id);
			if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
                SetPlayerData(owner_player, P_HOUSE, -1);
                SetPlayerData(owner_player, P_HOUSE_ROOM, -1);
                SetPlayerData(owner_player, P_HOUSE_TYPE, -1);
                mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
				mysql_query(mysql, query, false);
			}
					else {
				mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `house`=-1,`house_room`=-1,`house_type`=-1 WHERE `id`=%d LIMIT 1", owner_id);
				mysql_query(mysql, query, false);
			}
			SetHouseData(i, H_OWNER_ID, 0);
			SetHouseData(i, H_IMPROVEMENTS,		0);

			SetHouseData(i, H_RENT_DATE,		0);
			SetHouseData(i, H_LOCK_STATUS,		false);

			format(query, sizeof query, "UPDATE houses SET `owner_id`=0,`store_x`=0.0,`store_y`=0.0,`store_z`=0.0,`store_metall`=0,`store_drugs`=0,`store_weapon`=0,`store_ammo`=0,`store_skin`=0,`lock`=0 WHERE id=%d", GetHouseData(i, H_SQL_ID));
			mysql_query(mysql, query, false);

			
			UpdateHouse(i);

			HouseHealthInit(i);
			HouseStoreInit(i);

			new fmt_text[256];

			new description[64];

			description = "слет дома";

			format
			(
				fmt_text, sizeof fmt_text,
				"INSERT INTO return_money \
				(uid, money, description, status)\
				VALUES ('%d', '%d', '%s', 0)",
				owner_id,
				GetHouseData(i, H_PRICE) / 2,
				description
			);

			mysql_query(mysql, fmt_text, true);
		}
	}
//	return 1;
}
stock SellDebtorsBusiness()
{
	new query[400];
	for(new i; i < g_business_loaded; i ++)
	{
		if(GetBusinessData(i, B_RENT_DATE) < gettime())
		{
		    new owner_id = GetBusinessData(i, B_OWNER_ID);
		    if(owner_id == 0) continue;

			format(query, sizeof query, "UPDATE accounts a,business b SET a.business=-1,b.owner_id=0,b.products=0,b.prod_price=0,b.lock=0,b.rent_time=0 WHERE a.id=b.owner_id AND b.id=%d", GetBusinessData(i, B_SQL_ID));
			mysql_query(mysql, query, false);

			format(query, sizeof query, "DELETE FROM `business_gps` WHERE id = '%d'", i);
			mysql_query(mysql, query, false);
			new Cache: result, owner_name[21];

			mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE id=%d LIMIT 1", owner_id);
			result = mysql_query(mysql, query);

			if(cache_num_rows(result))
				cache_get_field_content(0, "name", owner_name, mysql, 21);
			cache_delete(result);

			format(query, sizeof query, "UPDATE accounts a,business b SET a.business=-1,b.owner_id=0,b.name='',b.products=0,b.prod_price=0,b.lock=0 WHERE a.id=%d AND b.id=%d", owner_id, GetBusinessData(i, B_SQL_ID));
			mysql_query(mysql, query, false);
			new owner_player = GetPlayerIDBySqlID(owner_id);
			if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
				SetPlayerData(owner_player, P_BUSINESS, -1);
                mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `business`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
				mysql_query(mysql, query, false);
			}
					else {
			    mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `business`=-1 WHERE `id`=%d LIMIT 1", owner_id);
				mysql_query(mysql, query, false);
			}
			SetBusinessData(i, B_OWNER_ID, 0);
			SetBusinessData(i, B_IMPROVEMENTS, 		0);

			SetBusinessData(i, B_PRODS, 			0);
			SetBusinessData(i, B_PROD_PRICE,		0);

			SetBusinessData(i, B_BALANCE,			0);
			SetBusinessData(i, B_RENT_DATE,			0);
			SetBusinessData(i, B_ENTER_MUSIC,		0);
			SetBusinessData(i, B_LOCK_STATUS,		false);

			BusinessHealthPickupInit(i);

			format(query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", i);
			mysql_query(mysql, query, false);

			g_business_gps_init = false;

			CallLocalFunction("UpdateBusinessLabel", "i", i);

			new fmt_text[256];

			new description[64];

			description = "слет бизнеса";

			format
			(
				fmt_text, sizeof fmt_text,
				"INSERT INTO return_money \
				(uid, money, description, status)\
				VALUES ('%d', '%d', '%s', 0)",
				owner_id,
				GetBusinessData(i, B_PRICE) / 2,
				description
			);

			mysql_query(mysql, fmt_text, true);
		}
	}
//	return 1;
}
stock SellDebtorsFuel()
{
	new query[400];
	for(new i; i < g_fuel_station_loaded; i ++)
	{

		if(GetFuelStationData(i, FS_RENT_DATE) < gettime())
		{
			new owner_id = GetFuelStationData(i, FS_OWNER_ID);

			if(owner_id == 0) continue;

			format(query, sizeof query, "UPDATE accounts a,fuel_stations f SET a.fuel_st=-1,f.owner_id=0,f.fuels=1000,f.fuel_price=3,f.lock=0,f.rent_time=0 WHERE a.id=f.owner_id AND f.id=%d", GetFuelStationData(i, FS_SQL_ID));
			mysql_query(mysql, query, false);

			new Cache: result, owner_name[21];

			mysql_format(mysql, query, sizeof query, "SELECT * FROM accounts WHERE id=%d LIMIT 1", owner_id);
			result = mysql_query(mysql, query);

			if(cache_num_rows(result))
				cache_get_field_content(0, "name", owner_name, mysql, 21);
			cache_delete(result);

			new owner_player = GetPlayerIDBySqlID(owner_id);
			if(IsPlayerConnected(owner_player) && IsPlayerLogged(owner_player)) {
	            SetPlayerData(owner_player, P_FUEL_ST, -1);
				format(query, sizeof query, "UPDATE accounts SET `fuel_st`=-1 WHERE `id`=%d LIMIT 1", GetPlayerAccountID(owner_player));
				mysql_query(mysql, query, false);
			}
					else {
				format(query, sizeof query, "UPDATE accounts SET `fuel_st`=-1 WHERE `id`=%d LIMIT 1", owner_id);
				mysql_query(mysql, query, false);
			}

			SetFuelStationData(i, FS_OWNER_ID, 0);
			SetFuelStationData(i, FS_IMPROVEMENTS, 0);

			SetFuelStationData(i, FS_FUELS, 		1000);
			SetFuelStationData(i, FS_FUEL_PRICE,	3);
			SetFuelStationData(i, FS_BUY_FUEL_PRICE,0);

			SetFuelStationData(i, FS_BALANCE,		0);
			SetFuelStationData(i, FS_RENT_DATE,		0);
			SetFuelStationData(i, FS_LOCK_STATUS,	false);

			CallLocalFunction("UpdateFuelStationLabel", "i", i);

			new fmt_text[256];

			new description[64];

			description = "слет АЗС";

			format
			(
				fmt_text, sizeof fmt_text,
				"INSERT INTO return_money \
				(uid, money, description, status)\
				VALUES ('%d', '%d', '%s', 0)",
				owner_id,
				GetFuelStationData(i, FS_PRICE) / 10,
				description
			);

			mysql_query(mysql, fmt_text, true);
		}
	}
//	return 1;
}

CMD:slethouse(playerid)
{
    
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	//SendClientMessageToAll(-1,"тест слет всего!");
	SellDebtorsHome();

	return 1;
}

CMD:slet(playerid)
{
    
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	//SendClientMessageToAll(-1,"тест слет всего!");
	SellDebtorsHome();
    SellDebtorsFuel();
	SellDebtorsBusiness();

	return 1;
}

stock CreateFractionCar()
{
	for(new i = 0; i < sizeof(g_org_car); i++)
    {
        format(sctring, sizeof(sctring), "{fcd000}(%s) \n\n Подойдите для взаимодействия \n с авторпарком организации", g_org_car[i][O_NAME]);
        CreateDynamic3DTextLabel(sctring, -1, g_org_car[i][O_PICKUP][0], g_org_car[i][O_PICKUP][1], g_org_car[i][O_PICKUP][2], 15.0);
        g_org_car[i][O_PICKUP_ID] = CreatePickup(19131, 23, g_org_car[i][O_PICKUP][0], g_org_car[i][O_PICKUP][1], g_org_car[i][O_PICKUP][2], 0, PICKUP_ACTION_TYPE_ORG_CAR, i);
    }
    printf("Загружено  пикапов авто %d штук", sizeof(g_org_car));
}

stock IsAIP(const text[])
{
    new numbers;
    for(new i = 0; i < strlen(text); i++) if('0' <= text[i] <= '9') if(!('0' <= text[i+1] <= '9')) numbers ++;
    if(numbers >= 4) return 1;
    return 0;
}

stock AntiTimerAdminNakaz(playerid)
{
    if(use_commad_time[playerid][adm_nakaz] > gettime())
        return SendClientMessage(playerid, -1, "Команду можно использовать раз в 60 секунд");

    use_commad_time[playerid][adm_nakaz] = gettime()+60;
    
    return false;
}

stock AntiTimerVipad(playerid)
{
    if(use_commad_time[playerid][vipad] > gettime())
        return SendClientMessage(playerid, -1, "Команду можно использовать раз в 5 минут");

    use_commad_time[playerid][adm_nakaz] = gettime()+300;

    return false;
}

stock AntiTimerReport(playerid)
{
    if(use_commad_time[playerid][report] > gettime())
        return SendClientMessage(playerid, -1, "Команду можно использовать раз в минуту");

    use_commad_time[playerid][adm_nakaz] = gettime()+60;

    return false;
}

stock AntiSliv(playerid, action[])
{
    if(GetPlayerData(playerid, P_ANTISLIV) > gettime())
    {
        SendClientMessage(playerid, -1, "{FFFF00}[!]{FFFFFF} Ошибка, ваши админ действия заблокированы!");

      	format(sctring, sizeof(sctring), "{FFFF00}[!]{FFFFFF} %s [%d] Подозрение на слив аккаунта (действие %s)", GetPlayerNameEx(playerid), playerid, action);
      	SendMessageToAdmins(sctring, 0x999999FF);
        return true;
    }
    g_player[playerid][P_ANTISLIV] = gettime() + 15;
    UpdatePlayerDatabaseInt(playerid, "antisliv", GetPlayerData(playerid, P_ANTISLIV));
    return false;
}

public: DonateQiwi(playerid, response_code, data[])
{
    if(response_code == 200)
    {
        SendClientMessage(playerid, -1, "Донат найден!");
        if(strfind(data, "success", true) != -1)
        {
            SendClientMessage(playerid, -1, "Донат оплачен!");

            new Cache:result;
            mysql_format(mysql, sctring, sizeof(sctring), "SELECT * FROM `payments` WHERE `user_id` = '%d' AND `status` = 1 LIMIT 1", GetPlayerAccountID(playerid));
            result = mysql_query(mysql, sctring, true);
            if(cache_num_rows(result))
            {

                new sum,id_pay;
                id_pay = cache_get_field_content_int(0, "id");
                sum = cache_get_field_content_int(0, "sum");

                mysql_format(mysql, sctring, sizeof(sctring), "UPDATE `payments` SET `status` = 2 WHERE `id` = '%d'", id_pay);
                mysql_query(mysql, sctring, false);

                format(sctring, sizeof(sctring), "{0099CC}Ваш баланс успешно пополнен на {FFD700}%i рублей! (QIWI)", sum);
                SendClientMessage(playerid, -1, sctring);

                if(Config[sDonPower] != 1)
                {
                    format(sctring, sizeof(sctring), "{0099CC}С учетом акции (X%d) на аккаунт зачислено {FFD700}%i рублей!",Config[sDonPower], sum*Config[sDonPower]);
                    SendClientMessage(playerid, -1, sctring);
                }
                GivePlayerDonateRub(playerid, sum*Config[sDonPower], "Донат QIWI");
                cache_delete(result);
                return 1;
            }
        }
    }
					else
    {
    	format(sctring, sizeof(sctring), "Пополнения по QIWI не найдены: (code: %d)", response_code);
        SendClientMessage(playerid, 0x999999FF, sctring);
    }
    return 1;
}


stock PlayerTotalOnline(playerid, count)
{
    return GetPlayerData(playerid, P_TOTALHOUR) >= count;
}

stock ShowVehicleImproveDialog(playerid = INVALID_PLAYER_ID, vehicle_type = 1) // VEHICLE_TYPE_OWNABLE_CAR)
{
	if(playerid == INVALID_PLAYER_ID)
	    return 0;

	if(!vehicle_type)
	    return 0;

	new vehicleid = GetPlayerOwnableCar(playerid);

	if(vehicleid == INVALID_VEHICLE_ID)
	    return 0;

	new index = GetVehicleData(vehicleid, V_ACTION_ID);

	new pt_engine = GetOwnableCarData(index, OC_PT_ENGINE),
	    pt_brake = GetOwnableCarData(index, OC_PT_BRAKE),
	    pt_stability = GetOwnableCarData(index, OC_PT_STABILITY);

	new fmt_text[128];

	format
	(
	    fmt_text,
	    sizeof fmt_text,
		"{FFFFFF}1. Улучшения двигателя [%d/5]\n"\
	    "2. Улучшения тормозной системы [%d/5]\n"\
	    "3. Улучшения устойчивости [%d/5]",
	    pt_engine, pt_brake, pt_stability
	);

	Dialog(playerid, DIALOG_OWNABLE_CAR_PT, DIALOG_STYLE_LIST, "Performance Tuning", fmt_text, "Выбрать", "Отмена");

	return 1;
}

stock ShowPerformanceItem(playerid, item_type = PT_ITEM_TYPE_NONE)
{
	if(item_type == PT_ITEM_TYPE_NONE)
		return 0;

    new vehicleid = GetPlayerOwnableCar(playerid);

	if(vehicleid == INVALID_VEHICLE_ID)
	    return 0;

	new index = GetVehicleData(vehicleid, V_ACTION_ID);

	new pt_engine = GetOwnableCarData(index, OC_PT_ENGINE),
	    pt_brake = GetOwnableCarData(index, OC_PT_BRAKE),
	    pt_stability = GetOwnableCarData(index, OC_PT_STABILITY);

	new fmt_text[128],
		fmt_dialog[128 * 5];

	for(new idx; idx < 5; idx ++)
	{
	    // if(GetOwnableCarData(index, OC_PT_ENGINE) > idx)

        format(fmt_text, sizeof fmt_text, "{FFFFFF}%d. ", idx + 1);

		new price,
		    item_level;

		switch(item_type)
		{
			case PT_ITEM_TYPE_ENGINE:
			{
				strcat(fmt_text, engine_ptune[idx]);

				price = engine_ptune_price[idx];
				item_level = pt_engine;
			}
			case PT_ITEM_TYPE_BRAKE:
			{
			    strcat(fmt_text, brake_ptune[idx]);

			    price = brake_ptune_price[idx];
			    item_level = pt_brake;
			}
			case PT_ITEM_TYPE_STABILITY:
			{
			    strcat(fmt_text, stability_ptune[idx]);

			    price = stability_ptune_price[idx];
			    item_level = pt_stability;
			}

			default:
			    return 0;
		}

		if(item_level > idx)
			format(fmt_text, sizeof fmt_text, "%s {FFCD00}[Установлено]", fmt_text);

		else
		    format(fmt_text, sizeof fmt_text, "%s {66CC33}[$%d]", fmt_text, price);

		if(idx > 2)
		    strcat(fmt_text, " {EC174F}[VIP Gold]\n");

		else
		    strcat(fmt_text, "\n");

		strcat(fmt_dialog, fmt_text);
	}

	new dialog_title[3][23] = {"Улучшения двигателя", "Улучшения тормозов", "Улучшения устойчивости"};

	Dialog(playerid, DIALOG_OWNABLE_CAR_PT_ITEM, DIALOG_STYLE_LIST, dialog_title[item_type - 1], fmt_dialog, "Выбрать", "Отмена");

	SetPVarInt(playerid, "pt_item_type", item_type);

	return 1;
}

stock ShowPlayerBuyHelper(playerid)
{
    new price = Config[helper_price];


    if(GetPlayerDonateRub(playerid) > price)
	{
        GivePlayerDonateRub(playerid, -price, "Покупка support-прав");

		SetPlayerData(playerid, P_HELPER, 1);
		UpdatePlayerDatabaseInt(playerid, "helper", 1);

        SendClientMessage(playerid, -1, "Используйте /shelp, чтобы узнать о новых возможностях");
	}
					else
	    return SendClientMessage(playerid, -1, "У Вас недостаточно рублей, пополнить их можно на сайте {FFCD00}"SERVER_SITE" -> Донат");

	return 1;

}

CMD:flip(playerid)
{
	if(GetPlayerAdminEx(playerid) < 1) return ShowNotificationNew(playerid, 2, 3, 0, 0, "У вас нет доступа к использованию данной команде", "");
	
	new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == 0)
    {
            SendClientMessage(playerid, -1, ""USC"Вы должны сидеть в транспорте");
            return 0;
    }

    // переменные которые будут хранить позицию и угол поворота
    new Float:x, Float:y, Float:z;
    new Float:angle;

    // получаем позицию и угол поворота
    GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, angle);

    // устанавливаем позицию и угол поворота
    SetVehiclePos(vehicleid, x, y, z + 1.5);
    SetVehicleZAngle(vehicleid, angle);

    SendClientMessage(playerid, -1, ""SC"Вы успешно поставили транспорт на колёса и починили его");
        
	RepairVehicle(vehicleid);
	SetVehicleHealth(vehicleid,1000);
	
	return 1;
}
CMD:setmoney(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 13) return 1;

	extract params -> new to_player, money; else return SendClientMessage(playerid, -1, "Используйте: /setmoney [id игрока] [количество]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0x999999FF, "Такого игрока нет");
		
	SetPlayerData(to_player, P_MONEY, money);
	UpdatePlayerDatabaseInt(to_player, "money", money);
	
	return 1;
	
}

CMD:setplayerhouse(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setplayerhouse [id игрока] [id house]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	else if(!(-1 <= health <= 1000)) return SendClientMessage(playerid, 0xCECECEFF, "Номер дома от -1 до 1000 ( -1 выселить )");

	SetPlayerData(to_player, P_HOUSE, health);
	SetPlayerData(playerid, P_HOUSE_ROOM, -1);
	SetPlayerData(playerid, P_HOUSE_TYPE, HOUSE_TYPE_HOME);
	if(health == -1)
	{
	    SetPlayerData(to_player, P_HOUSE, -1);
		SetPlayerData(playerid, P_HOUSE_ROOM, -1);
		SetPlayerData(playerid, P_HOUSE_TYPE, HOUSE_TYPE_NONE);
	}

	new fmt_msg[105];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам номер дома", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили игроку %s номер дома на %d", GetPlayerNameEx(to_player),health);
	SendClientMessage(playerid, -1, fmt_msg);
	new query[90];

	format(query, sizeof query, "UPDATE accounts SET house_type=%d,house=%d, WHERE id=%d LIMIT 1", HOUSE_TYPE_HOME, health, GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] изменил номер дому %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
		SendMessageToAdmins(fmt_msg, 0xCECECEFF);
	}

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] номер дома %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), health);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}
CMD:setplayerbiz(playerid, params[])
{
    
	if(GetPlayerAdminEx(playerid) < 6) return 1;

	extract params -> new to_player, health; else return SendClientMessage(playerid, 0xCECECEFF, "Используйте: /setplayerbiz [id игрока] [id biz]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SendClientMessage(playerid, 0xCECECEFF, "Такого игрока нет");

	else if(!(-1 <= health <= 1000)) return SendClientMessage(playerid, 0xCECECEFF, "Номер biz от -1 до 1000 ( -1 выселить )");

	SetPlayerData(to_player, P_BUSINESS, health);


	new fmt_msg[105];
	format(fmt_msg, sizeof fmt_msg, "Администратор %s изменил Вам номер biz", GetPlayerNameEx(playerid));
	SendClientMessage(to_player, -1, fmt_msg);

	format(fmt_msg, sizeof fmt_msg, "Вы изменили игроку %s номер biz", GetPlayerNameEx(to_player));
	SendClientMessage(playerid, -1, fmt_msg);
	new query[90];
	mysql_format(mysql, query, sizeof query, "UPDATE accounts SET business=%d WHERE id=%d LIMIT 1", health, GetPlayerAccountID(playerid));
	mysql_query(mysql, query, false);

	if(GetPlayerAdminEx(playerid) <= 5)
	{
		format(fmt_msg, sizeof fmt_msg, "[A] %s[%d] изменил номер biz %s[%d] на %d", GetPlayerNameEx(playerid), playerid, GetPlayerNameEx(to_player), to_player, health);
		SendMessageToAdmins(fmt_msg, 0xCECECEFF);
	}

	format(fmt_msg, sizeof fmt_msg, "Установил %s[acc:%d] номер biz %d", GetPlayerNameEx(to_player), GetPlayerAccountID(to_player), health);
	SendLog(playerid, LOG_TYPE_ADMIN_ACTION, fmt_msg);

	return 1;
}

