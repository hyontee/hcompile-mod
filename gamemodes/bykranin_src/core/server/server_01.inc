//>> Файл: bykranin_src/core/server/server_01.inc  (271 строк)
//>> Тема: инфраструктура: таймеры, сохранение, MySQL, утилиты
//>> Внутри: LoadBusinesses
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
public: LoadBusinesses()
{
	new query[85], buffer[2];
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT b.*, IFNULL(a.name, 'None') AS owner_name FROM business b LEFT JOIN accounts a ON a.id=b.owner_id", true);
	rows = cache_num_rows(result);
	printf("[MYSQL][AUTOSALON] LoadBusinesses: rows=%d", rows);

	if(rows > MAX_BUSINESS)
	{
		rows = MAX_BUSINESS;
		print("[Business]: DB rows > MAX_BUSINESS");
	}
	for(new idx; idx < rows; idx ++)
	{
		SetBusinessData(idx, B_SQL_ID, 		cache_get_field_content_int(idx, "id"));
		SetBusinessData(idx, B_OWNER_ID, cache_get_field_content_int(idx, "owner_id"));

		cache_get_field_content(idx, "name", g_business[idx][B_NAME], mysql, 26);
		
		SetBusinessData(idx, B_IMPROVEMENTS,	cache_get_field_content_int(idx, "improvements"));
		SetBusinessData(idx, B_PRODS,            cache_get_field_content_int(idx, "products"));
		SetBusinessData(idx, B_PROD_PRICE,		cache_get_field_content_int(idx, "prod_price"));
		SetBusinessData(idx, B_BALANCE,			cache_get_field_content_int(idx, "balance"));
		SetBusinessData(idx, B_RENT_DATE,		cache_get_field_content_int(idx, "rent_time"));
		SetBusinessData(idx, B_PRICE,			cache_get_field_content_int(idx, "price"));
		SetBusinessData(idx, B_RENT_PRICE,       5000);

		SetBusinessData(idx, B_TYPE,			cache_get_field_content_int(idx, "type"));
		SetBusinessData(idx, B_INTERIOR,		cache_get_field_content_int(idx, "interior"));

		SetBusinessData(idx, B_ENTER_PRICE,		cache_get_field_content_int(idx, "enter_price"));
		SetBusinessData(idx, B_ENTER_MUSIC,		cache_get_field_content_int(idx, "enter_music"));

		SetBusinessData(idx, B_LOCK_STATUS,		bool: cache_get_field_content_int(idx, "lock"));

		SetBusinessData(idx, B_POS_X,			cache_get_field_content_float(idx, "x"));
		SetBusinessData(idx, B_POS_Y,			cache_get_field_content_float(idx, "y"));
		SetBusinessData(idx, B_POS_Z,			cache_get_field_content_float(idx, "z"));

		SetBusinessData(idx, B_EXIT_POS_X,		cache_get_field_content_float(idx, "exit_x"));
		SetBusinessData(idx, B_EXIT_POS_Y,		cache_get_field_content_float(idx, "exit_y"));
		SetBusinessData(idx, B_EXIT_POS_Z,		cache_get_field_content_float(idx, "exit_z"));
		SetBusinessData(idx, B_EXIT_ANGLE,		cache_get_field_content_float(idx, "exit_angle"));

		if(GetBusinessData(idx, B_TYPE) == BUSINESS_TYPE_CAR_MARKET)
		{
			switch(idx)
			{
				case 35:
				{
					SetBusinessData(idx, B_POS_X, 802.788635);
					SetBusinessData(idx, B_POS_Y, 497.319488);
					SetBusinessData(idx, B_POS_Z, 12.275835);
					SetBusinessData(idx, B_EXIT_POS_X, 807.004455);
					SetBusinessData(idx, B_EXIT_POS_Y, 508.142089);
					SetBusinessData(idx, B_EXIT_POS_Z, 12.236772);
					SetBusinessData(idx, B_EXIT_ANGLE, 337.131225);
				}
				case 36:
				{
					SetBusinessData(idx, B_POS_X, 660.813293);
					SetBusinessData(idx, B_POS_Y, 2667.927978);
					SetBusinessData(idx, B_POS_Z, 14.501132);
					SetBusinessData(idx, B_EXIT_POS_X, 655.518676);
					SetBusinessData(idx, B_EXIT_POS_Y, 2661.782714);
					SetBusinessData(idx, B_EXIT_POS_Z, 13.516562);
					SetBusinessData(idx, B_EXIT_ANGLE, 148.320831);
				}
				case 37:
				{
					SetBusinessData(idx, B_POS_X, 1411.059570);
					SetBusinessData(idx, B_POS_Y, 460.159515);
					SetBusinessData(idx, B_POS_Z, 13.203024);
					SetBusinessData(idx, B_EXIT_POS_X, 1406.829101);
					SetBusinessData(idx, B_EXIT_POS_Y, 455.163024);
					SetBusinessData(idx, B_EXIT_POS_Z, 13.203024);
					SetBusinessData(idx, B_EXIT_ANGLE, 146.174179);
				}
			}
		}

		SetBusinessData(idx, B_EVICTION,		cache_get_field_content_int(idx, "eviction"));

		cache_get_field_content(idx, "owner_name", g_business[idx][B_OWNER_NAME], mysql, 21);

		// -------------------------


		SetBusinessData(idx, B_ORDER_ID, -1);
        if(GetBusinessData(idx, B_TYPE) == BUSINESS_TYPE_SHOP_GUN)
        {
            SetBusinessData(idx, B_LABEL, Text3D:-1);
        }
        else
        {
            new Float:business_label_distance =
                GetBusinessData(idx, B_TYPE) == BUSINESS_TYPE_CASINO ? 20.0 : 6.50;
            SetBusinessData(idx, B_LABEL, CreateDynamic3DTextLabel(GetBusinessData(idx, B_NAME), 0xFFFF00FF, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z) + 1.0, business_label_distance));
        }

		if(IsBusinessOwned(idx) && !strcmp(GetBusinessData(idx, B_OWNER_NAME), "None", true))
		{
			mysql_format(mysql, query, sizeof query, "UPDATE accounts SET `business`=-1 WHERE `id`=%d LIMIT 1", GetBusinessData(idx, B_OWNER_ID));
			mysql_query(mysql, query, false);

			SetBusinessData(idx, B_OWNER_ID, 0);

			mysql_format(mysql, query, sizeof query, "UPDATE business SET owner_id=0,improvements=0 WHERE id=%d", GetBusinessData(idx, B_SQL_ID));
			mysql_query(mysql, query, false);
		}

		if(!IsBusinessOwned(idx))
		{
			SetBusinessData(idx, B_PRODS,		0);
			SetBusinessData(idx, B_PROD_PRICE, 	0);
			SetBusinessData(idx, B_LOCK_STATUS, false);

			SetBusinessData(idx, B_ENTER_MUSIC, 0);
			SetBusinessData(idx, B_ENTER_PRICE, 0);

			if(GetBusinessData(idx, B_IMPROVEMENTS) >= 6)
			{
				mysql_format(mysql, query, sizeof query, "DELETE FROM business_gps WHERE bid=%d", idx);
				mysql_query(mysql, query, false);
			}
		}
		CallLocalFunction("UpdateBusinessLabel", "i", idx);

		BusinessHealthPickupInit(idx);

		RecreateBusinessEnterPickup(idx);
        if(GetBusinessData(idx, B_TYPE) != BUSINESS_TYPE_SHOP_GUN && !(GetBusinessData(idx, B_TYPE) == BUSINESS_TYPE_ACCESSORY_SHOP && floatabs(GetBusinessData(idx, B_POS_X) - 398.195000) < 1.0 && floatabs(GetBusinessData(idx, B_POS_Y) - 560.202000) < 1.0))
        {
            CreateDynamicMapIcon(GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z), 52, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
        }

		//CreateDynamicMapIcon(GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z), 47, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
	}
	g_business_loaded = rows;
	cache_delete(result);
	printf("[MYSQL][AUTOSALON] Before InitStaticCarMarkets: g_business_loaded=%d", g_business_loaded);
	InitStaticCarMarkets();
	printf("[MYSQL][AUTOSALON] After InitStaticCarMarkets: g_business_loaded=%d", g_business_loaded);
	InitStaticAccessoryShopBusiness();
	InitStaticTuningCenterBusinesses();
	InitStaticShop247Businesses();

	for(new idx; idx < sizeof g_business_interiors; idx ++)
	{
		CreatePickup(1318, 23, GetBusinessInteriorInfo(idx, BT_EXIT_POS_X), GetBusinessInteriorInfo(idx, BT_EXIT_POS_Y), GetBusinessInteriorInfo(idx, BT_EXIT_POS_Z), -1, PICKUP_ACTION_TYPE_BIZ_EXIT, idx);
        if(idx == BUSINESS_INTERIOR_CASINO)
        {
        }
		buffer[0] = -1;

		switch(idx)
		{
			case BUSINESS_INTERIOR_SHOP_24_7:
			{
				CreateDynamic3DTextLabel
				(
					"Список\n"\
					"товаров\n"\
					"{FFCD00}Введите /buy",
					0x00CC00EE,
					GetBusinessInteriorInfo(idx, BT_BUY_POS_X),
					GetBusinessInteriorInfo(idx, BT_BUY_POS_Y),
					GetBusinessInteriorInfo(idx, BT_BUY_POS_Z) + 0.8,
					8.0
				);
				CreatePickup(1239, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1, PICKUP_ACTION_TYPE_BIZ_SHOP_247, idx);
			}
			case BUSINESS_INTERIOR_CLUB, BUSINESS_INTERIOR_CASINO:
			{
				CreateDynamic3DTextLabel
				(
					"Меню бара:\n\n"\
					"{6699FF}1. Лимонад\n"\
					"2. Пиво\n"\
					"3. Вино\n"\
					"4. Шампанское\n"\
					"5. Водка\n"\
					"6. Коньяк\n"\
					"7. Виски\n"\
					"8. Абсент\n"\
					"{00CC66}9. Закуска\n"\
					"10. Сигара",
					0xFFFFFFCC,
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_X),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Y),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Z),
					9.0
				);
				buffer[0] = CreateDynamicCP(GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), 1.0, _, _, _, 8.0);
			}
			case BUSINESS_INTERIOR_REALTOR_BIZ:
			{
				g_business_realtor_label = CreateDynamic3DTextLabel
				(
					"Состояние бизнеса",
					0xCCFF66FF,
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_X),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Y),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Z),
					10.0
				);
				//CreatePickup(1239, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1);
				buffer[0] = CreateDynamicCP(GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z) - 1.0, 1.2, _, _, _, 10.0);

				CallLocalFunction("UpdateRealtorBizInfo", "");
			}
			case BUSINESS_INTERIOR_REALTOR_HOME:
			{
				g_house_realtor_label = CreateDynamic3DTextLabel
				(
					"Состояние недвижимости",
					0xCCFF66FF,
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_X),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Y),
					GetBusinessInteriorInfo(idx, BT_LABEL_POS_Z),
					10.0
				);
				CreatePickup(1273, 23, 158.4875, 745.8184, 25.8272, -1, PICKUP_ACTION_TYPE_REALTOR_HOME, idx);
				CreatePickup(1272, 23, 156.3270, 746.5958, 25.8272, -1, PICKUP_ACTION_TYPE_REALTOR_HOME, idx);

				CreatePickup(1239, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1);
				buffer[0] = CreateDynamicCP(GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), 0.7, _, _, _, 5.0);

				CallLocalFunction("UpdateRealtorHomeInfo", "");
			}
			case BUSINESS_INTERIOR_HOTEL:
			{
				CreatePickup(1277, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1);

				CreateDynamic3DTextLabel("Услуги\n{FFFFFF}гост. комплекса", 0x3399FFFF, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z) + 0.8, 5.0);
				buffer[0] = CreateDynamicCP(GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), 1.2, _, _, _, 20.0);
			}
			case BUSINESS_INTERIOR_CELL_SALON:
			{
				/*CreateDynamic3DTextLabel
				(
					"Сотовый\n"\
					"салон\n"\
					"{FFCD00}Введите /buy",
					0x00CC00EE,
					GetBusinessInteriorInfo(idx, BT_BUY_POS_X),
					GetBusinessInteriorInfo(idx, BT_BUY_POS_Y),
					GetBusinessInteriorInfo(idx, BT_BUY_POS_Z) + 0.8,
					8.0
				);
				CreatePickup(1318, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1, PICKUP_ACTION_TYPE_CELL_SALON, idx);
			*/}
			case BUSINESS_INTERIOR_CAR_TUNING:
			{
				CreatePickup(1318, 23, GetBusinessInteriorInfo(idx, BT_BUY_POS_X), GetBusinessInteriorInfo(idx, BT_BUY_POS_Y), GetBusinessInteriorInfo(idx, BT_BUY_POS_Z), -1, PICKUP_ACTION_TYPE_BIZ_CAR_TUN, idx);
				CreateDynamic3DTextLabel("Обслуживание транспорта\nТюнинг", 0xCC6600EE, GetBusinessInteriorInfo(idx, BT_LABEL_POS_X), GetBusinessInteriorInfo(idx, BT_LABEL_POS_Y), GetBusinessInteriorInfo(idx, BT_LABEL_POS_Z), 5.0);
			}
            case BUSINESS_INTERIOR_SHOP_GUN:
            {
            }
		}
		SetBusinessInteriorInfo(idx, BT_BUY_CHECK_ID, buffer[0]);
	}
	BusinesGPSListInit();

	printf("[Business]: Бизнесов загружено: %d", g_business_loaded);
}

