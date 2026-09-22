//>> Файл: bykranin_src/core/property/property_02.inc  (922 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: FindBusinessByCoords, WeaponShop_FindBusiness, WeaponShop_SetPlayerBusiness, WeaponShop_CanPurchase, WeaponShop_RecordPurchase, InitStaticShop247Businesses, InitStaticAccessoryShopBusiness
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock FindBusinessByCoords(Float:x, Float:y, Float:z, Float:radius = 1.5)
{
	for(new idx; idx < g_business_loaded; idx ++)
	{
		if(GetDistanceBetweenCoords(x, y, z, GetBusinessData(idx, B_POS_X), GetBusinessData(idx, B_POS_Y), GetBusinessData(idx, B_POS_Z)) <= radius)
			return idx;
	}
	return -1;
}

stock WeaponShop_FindBusiness(shopid)
{
	if(shopid < 0 || shopid >= STATIC_GUN_SHOP_COUNT) return -1;
	return FindBusinessByCoords(g_static_gun_shop_pos[shopid][0],
		g_static_gun_shop_pos[shopid][1], g_static_gun_shop_pos[shopid][2], 2.0);
}

forward WeaponShop_SetPlayerBusiness(playerid, shopid);
public WeaponShop_SetPlayerBusiness(playerid, shopid)
{
	new businessid = WeaponShop_FindBusiness(shopid);
	SetPlayerInBiz(playerid, businessid);
	return businessid;
}

forward WeaponShop_CanPurchase(playerid);
public WeaponShop_CanPurchase(playerid)
{
	new businessid = WeaponShop_FindBusiness(g_static_gun_shop_player_entrance[playerid]);
	if(businessid == -1) return 0;
	if(!IsBusinessOwned(businessid)) return 1;
	if(GetBusinessData(businessid, B_PRODS) > 0) return 1;
	SendClientMessage(playerid, 0xCECECEFF, "В магазине закончились товары. Владелец должен пополнить склад.");
	return 0;
}

forward WeaponShop_RecordPurchase(playerid, price);
public WeaponShop_RecordPurchase(playerid, price)
{
	new businessid = WeaponShop_FindBusiness(g_static_gun_shop_player_entrance[playerid]);
	if(businessid == -1 || !IsBusinessOwned(businessid) || price <= 0) return 0;
	AddBusinessData(businessid, B_PRODS, -, 1);
	AddBusinessData(businessid, B_BALANCE, +, price * 20 / 100);
	new query[192];
	mysql_format(mysql, query, sizeof query,
		"UPDATE business SET products=%d,balance=%d WHERE id=%d LIMIT 1",
		GetBusinessData(businessid, B_PRODS), GetBusinessData(businessid, B_BALANCE),
		GetBusinessData(businessid, B_SQL_ID));
	mysql_query(mysql, query, false);
	return 1;
}

stock InitStaticShop247Businesses()
{
	new query[256];
	new created_count;
	new updated_count;
	new Cache:insert_result;

	for(new pos_idx; pos_idx < sizeof g_static_shop247_positions; pos_idx ++)
	{
		new Float:x = g_static_shop247_positions[pos_idx][0];
		new Float:y = g_static_shop247_positions[pos_idx][1];
		new Float:z = g_static_shop247_positions[pos_idx][2];
		new businessid = FindBusinessByCoords(x, y, z);

		if(businessid != -1)
		{
			format(g_business[businessid][B_NAME], 24, "Магазин 24/7");
			if(!IsBusinessOwned(businessid))
				format(g_business[businessid][B_OWNER_NAME], 21, "None");
			SetBusinessData(businessid, B_INTERIOR, BUSINESS_INTERIOR_SHOP_24_7);
			SetBusinessData(businessid, B_PRICE, 500000);
			SetBusinessData(businessid, B_RENT_PRICE, 5000);
			SetBusinessData(businessid, B_PRODS, 10_000);
			SetBusinessData(businessid, B_POS_X, x);
			SetBusinessData(businessid, B_POS_Y, y);
			SetBusinessData(businessid, B_POS_Z, z);
			SetBusinessData(businessid, B_EXIT_POS_X, x);
			SetBusinessData(businessid, B_EXIT_POS_Y, y);
			SetBusinessData(businessid, B_EXIT_POS_Z, z);
			SetBusinessData(businessid, B_EXIT_ANGLE, 0.0);

			if(GetBusinessData(businessid, B_SQL_ID) > 0)
			{
				mysql_format(mysql, query, sizeof query, "UPDATE business SET type=%d,interior=%d,name='%e',price=%d,rent_price=%d,x='%f',y='%f',z='%f',exit_x='%f',exit_y='%f',exit_z='%f',exit_angle='%f' WHERE id=%d LIMIT 1", BUSINESS_TYPE_SHOP_24_7, BUSINESS_INTERIOR_SHOP_24_7, "Магазин 24/7", 500000, 5000, x, y, z, x, y, z, 0.0, GetBusinessData(businessid, B_SQL_ID));
				mysql_query(mysql, query, false);
			}

			UpdateBusinessLabel(businessid);
			updated_count ++;
			continue;
		}

		if(g_business_loaded >= MAX_BUSINESS)
			break;

		businessid = g_business_loaded ++;

		SetBusinessData(businessid, B_SQL_ID, 0);
		SetBusinessData(businessid, B_OWNER_ID, 0);
		SetBusinessData(businessid, B_ENTER_PRICE, 0);
		SetBusinessData(businessid, B_ENTER_MUSIC, 0);
		SetBusinessData(businessid, B_IMPROVEMENTS, 0);
		SetBusinessData(businessid, B_PRODS, 0);
		SetBusinessData(businessid, B_PROD_PRICE, 0);
		SetBusinessData(businessid, B_BALANCE, 0);
		SetBusinessData(businessid, B_RENT_DATE, 0);
		SetBusinessData(businessid, B_PRICE, 500000);
		SetBusinessData(businessid, B_RENT_PRICE, 5000);
		SetBusinessData(businessid, B_PRODS, 10_000);
		SetBusinessData(businessid, B_LOCK_STATUS, false);
		SetBusinessData(businessid, B_TYPE, BUSINESS_TYPE_SHOP_24_7);
		SetBusinessData(businessid, B_INTERIOR, BUSINESS_INTERIOR_SHOP_24_7);
		SetBusinessData(businessid, B_POS_X, x);
		SetBusinessData(businessid, B_POS_Y, y);
		SetBusinessData(businessid, B_POS_Z, z);
		SetBusinessData(businessid, B_EXIT_POS_X, x);
		SetBusinessData(businessid, B_EXIT_POS_Y, y);
		SetBusinessData(businessid, B_EXIT_POS_Z, z);
		SetBusinessData(businessid, B_EXIT_ANGLE, 0.0);
		SetBusinessData(businessid, B_ORDER_ID, -1);
		SetBusinessData(businessid, B_HEALTH_PICKUP, 0);
		SetBusinessData(businessid, B_EVICTION, 0);
		format(g_business[businessid][B_NAME], 24, "Магазин 24/7");
		format(g_business[businessid][B_OWNER_NAME], 21, "None");

		mysql_format(mysql, query, sizeof query, "INSERT INTO business (type, price, rent_price, x, y, z, interior, name, exit_x, exit_y, exit_z, exit_angle) VALUES (%d, %d, %d, '%f', '%f', '%f', %d, '%e', '%f', '%f', '%f', '%f')", BUSINESS_TYPE_SHOP_24_7, 500000, 5000, x, y, z, BUSINESS_INTERIOR_SHOP_24_7, "Магазин 24/7", x, y, z, 0.0);
		insert_result = mysql_query(mysql, query, true);
		SetBusinessData(businessid, B_SQL_ID, cache_insert_id());
		cache_delete(insert_result);

		SetBusinessData(businessid, B_LABEL, CreateDynamic3DTextLabel(g_business[businessid][B_NAME], 0xFFFF00FF, x, y, z + 1.0, 6.50));
		UpdateBusinessLabel(businessid);
		RecreateBusinessEnterPickup(businessid);
		CreateDynamicMapIcon(x, y, z, 52, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
		created_count ++;
	}

	printf("[Business] Static 24/7 init: created=%d updated=%d loaded=%d", created_count, updated_count, g_business_loaded);
	return 1;
}

new const Float:g_static_accessory_shops[][4] =
{
    { 216.875778,  860.865112, 13.420687, 317.259765 },
    {-1628.423461, 2433.973632, 58.056365, 27.388212 },
    {-2393.761230, 1144.379150, 9.886712, 249.927566 },
    {-2379.521484, 59.116008, 27.070049, 270.328338 },
    { 2409.158447,-2141.038085, 22.457817, 180.079177 },
    { 1945.622802, 2068.590332, 16.192081, 179.089263 }
};

stock InitStaticAccessoryShopBusiness()
{
    // Migrate the obsolete generated shop instead of creating a seventh one.
    // Keeping its SQL id also preserves ownership and business balance.
    for(new legacy_business = 0; legacy_business < g_business_loaded; legacy_business++)
    {
        if(GetBusinessData(legacy_business, B_TYPE) != BUSINESS_TYPE_ACCESSORY_SHOP) continue;
        if(floatabs(GetBusinessData(legacy_business, B_POS_X) - 398.195000) >= 1.0 ||
           floatabs(GetBusinessData(legacy_business, B_POS_Y) - 560.202000) >= 1.0) continue;

        new Float:new_x = g_static_accessory_shops[0][0];
        new Float:new_y = g_static_accessory_shops[0][1];
        new Float:new_z = g_static_accessory_shops[0][2];
        new Float:new_a = g_static_accessory_shops[0][3];
        new migrate_query[256];
        mysql_format(mysql, migrate_query, sizeof migrate_query,
            "UPDATE business SET x='%f',y='%f',z='%f',exit_x='%f',exit_y='%f',exit_z='%f',exit_angle='%f' WHERE id=%d LIMIT 1",
            new_x, new_y, new_z, new_x, new_y, new_z, new_a, GetBusinessData(legacy_business, B_SQL_ID));
        mysql_query(mysql, migrate_query, false);

        SetBusinessData(legacy_business, B_POS_X, new_x);
        SetBusinessData(legacy_business, B_POS_Y, new_y);
        SetBusinessData(legacy_business, B_POS_Z, new_z);
        SetBusinessData(legacy_business, B_EXIT_POS_X, new_x);
        SetBusinessData(legacy_business, B_EXIT_POS_Y, new_y);
        SetBusinessData(legacy_business, B_EXIT_POS_Z, new_z);
        SetBusinessData(legacy_business, B_EXIT_ANGLE, new_a);
        RecreateBusinessEnterPickup(legacy_business);

        if(IsValidDynamic3DTextLabel(Text3D:GetBusinessData(legacy_business, B_LABEL)))
            DestroyDynamic3DTextLabel(Text3D:GetBusinessData(legacy_business, B_LABEL));
        new Text3D:migrated_label = CreateDynamic3DTextLabel(g_business[legacy_business][B_NAME], 0xFFFF00FF, new_x, new_y, new_z + 1.0, 6.50);
        SetBusinessData(legacy_business, B_LABEL, _:migrated_label);
        UpdateBusinessLabel(legacy_business);
        CreateDynamicMapIcon(new_x, new_y, new_z, 52, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
        printf("[AccessoryShop] migrated legacy sql=%d to point 1", GetBusinessData(legacy_business, B_SQL_ID));
        break;
    }

    new created_count;
    for(new point = 0; point < sizeof(g_static_accessory_shops); point++)
    {
        new bool:exists = false;
        for(new businessid = 0; businessid < g_business_loaded; businessid++)
        {
            if(GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_ACCESSORY_SHOP) continue;
            new Float:dx = GetBusinessData(businessid, B_POS_X) - g_static_accessory_shops[point][0];
            new Float:dy = GetBusinessData(businessid, B_POS_Y) - g_static_accessory_shops[point][1];
            new Float:dz = GetBusinessData(businessid, B_POS_Z) - g_static_accessory_shops[point][2];
            if((dx * dx + dy * dy + dz * dz) <= 4.0)
            {
                exists = true;
                break;
            }
        }
        if(exists) continue;
        if(g_business_loaded >= MAX_BUSINESS)
        {
            printf("[AccessoryShop][ERROR] no runtime slot for point=%d", point + 1);
            break;
        }

        new Float:x = g_static_accessory_shops[point][0];
        new Float:y = g_static_accessory_shops[point][1];
        new Float:z = g_static_accessory_shops[point][2];
        new Float:a = g_static_accessory_shops[point][3];
        new query[640];
        mysql_format(mysql, query, sizeof query,
            "INSERT INTO business (owner_id,name,kriha,improvements,products,prod_price,balance,rent_time,price,rent_price,type,interior,enter_price,enter_music,`lock`,x,y,z,exit_x,exit_y,exit_z,exit_angle,eviction) VALUES (0,'%e','',0,0,0,0,0,25000000,25000,%d,%d,0,0,0,'%f','%f','%f','%f','%f','%f','%f',0)",
            "Accessory Shop", BUSINESS_TYPE_ACCESSORY_SHOP, BUSINESS_INTERIOR_ACCESSORY_SHOP,
            x, y, z, x, y, z, a);
        new Cache:insert_result = mysql_query(mysql, query, true);
        new sql_id = cache_insert_id();
        new insert_errno = mysql_errno();
        cache_delete(insert_result);
        if(insert_errno || sql_id <= 0)
        {
            printf("[AccessoryShop][ERROR] create point=%d errno=%d", point + 1, insert_errno);
            continue;
        }

        new businessid = g_business_loaded++;
        SetBusinessData(businessid, B_SQL_ID, sql_id);
        SetBusinessData(businessid, B_OWNER_ID, 0);
        SetBusinessData(businessid, B_IMPROVEMENTS, 0);
        SetBusinessData(businessid, B_PRODS, 0);
        SetBusinessData(businessid, B_PROD_PRICE, 0);
        SetBusinessData(businessid, B_BALANCE, 0);
        SetBusinessData(businessid, B_RENT_DATE, 0);
        SetBusinessData(businessid, B_PRICE, 25000000);
        SetBusinessData(businessid, B_RENT_PRICE, 25000);
        SetBusinessData(businessid, B_TYPE, BUSINESS_TYPE_ACCESSORY_SHOP);
        SetBusinessData(businessid, B_INTERIOR, BUSINESS_INTERIOR_ACCESSORY_SHOP);
        SetBusinessData(businessid, B_ENTER_PRICE, 0);
        SetBusinessData(businessid, B_ENTER_MUSIC, 0);
        SetBusinessData(businessid, B_LOCK_STATUS, false);
        SetBusinessData(businessid, B_POS_X, x);
        SetBusinessData(businessid, B_POS_Y, y);
        SetBusinessData(businessid, B_POS_Z, z);
        SetBusinessData(businessid, B_EXIT_POS_X, x);
        SetBusinessData(businessid, B_EXIT_POS_Y, y);
        SetBusinessData(businessid, B_EXIT_POS_Z, z);
        SetBusinessData(businessid, B_EXIT_ANGLE, a);
        SetBusinessData(businessid, B_EVICTION, 0);
        SetBusinessData(businessid, B_ORDER_ID, -1);
        SetBusinessData(businessid, B_HEALTH_PICKUP, 0);
        format(g_business[businessid][B_NAME], 24, "%s", GetBusinessInteriorInfo(BUSINESS_INTERIOR_ACCESSORY_SHOP, BT_NAME));
        format(g_business[businessid][B_OWNER_NAME], 21, "None");

        new Text3D:shop_label = CreateDynamic3DTextLabel(g_business[businessid][B_NAME], 0xFFFF00FF, x, y, z + 1.0, 6.50);
        SetBusinessData(businessid, B_LABEL, _:shop_label);
        RecreateBusinessEnterPickup(businessid);
        UpdateBusinessLabel(businessid);
        CreateDynamicMapIcon(x, y, z, 52, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
        created_count++;
        printf("[AccessoryShop] point=%d slot=%d sql=%d pos=%.3f %.3f %.3f", point + 1, businessid, sql_id, x, y, z);
    }
    printf("[AccessoryShop] six-point init complete: created=%d total_loaded=%d", created_count, g_business_loaded);
    return 1;
}
stock InitStaticTuningCenterBusiness(business_type, const business_name[], Float:x, Float:y, Float:z, Float:angle)
{
    new businessid = -1;
    for(new idx; idx < g_business_loaded; idx++)
    {
        if(GetBusinessData(idx, B_TYPE) == business_type)
        {
            businessid = idx;
            break;
        }
    }

    if(businessid == -1)
    {
        if(g_business_loaded >= MAX_BUSINESS)
        {
            printf("[TuningCenter][ERROR] no runtime slot for type=%d", business_type);
            return 0;
        }

        new insert_query[512];
        mysql_format(mysql, insert_query, sizeof insert_query,
            "INSERT INTO business (owner_id,name,improvements,products,prod_price,balance,rent_time,price,rent_price,type,interior,enter_price,enter_music,`lock`,x,y,z,exit_x,exit_y,exit_z,exit_angle,eviction) VALUES (0,'%e',0,0,0,0,0,25000000,25000,%d,%d,0,0,0,'%f','%f','%f','%f','%f','%f','%f',0)",
            business_name, business_type, BUSINESS_INTERIOR_CAR_TUNING,
            x, y, z, x, y, z, angle);
        new Cache:insert_result = mysql_query(mysql, insert_query, true);
        new sql_id = cache_insert_id();
        new insert_error = mysql_errno();
        cache_delete(insert_result);
        if(insert_error || sql_id <= 0)
        {
            printf("[TuningCenter][ERROR] create type=%d errno=%d", business_type, insert_error);
            return 0;
        }

        businessid = g_business_loaded++;
        SetBusinessData(businessid, B_SQL_ID, sql_id);
        SetBusinessData(businessid, B_OWNER_ID, 0);
        SetBusinessData(businessid, B_IMPROVEMENTS, 0);
        SetBusinessData(businessid, B_PRODS, 0);
        SetBusinessData(businessid, B_PROD_PRICE, 0);
        SetBusinessData(businessid, B_BALANCE, 0);
        SetBusinessData(businessid, B_RENT_DATE, 0);
        SetBusinessData(businessid, B_PRICE, 25000000);
        SetBusinessData(businessid, B_RENT_PRICE, 25000);
        SetBusinessData(businessid, B_TYPE, business_type);
        SetBusinessData(businessid, B_INTERIOR, BUSINESS_INTERIOR_CAR_TUNING);
        SetBusinessData(businessid, B_ENTER_PRICE, 0);
        SetBusinessData(businessid, B_ENTER_MUSIC, 0);
        SetBusinessData(businessid, B_LOCK_STATUS, false);
        SetBusinessData(businessid, B_EVICTION, 0);
        SetBusinessData(businessid, B_ORDER_ID, -1);
        SetBusinessData(businessid, B_HEALTH_PICKUP, 0);
		SetBusinessData(businessid, B_LABEL, Text3D:-1);
        format(g_business[businessid][B_OWNER_NAME], 21, "None");
    }
    else
    {
        new update_query[512];
        mysql_format(mysql, update_query, sizeof update_query,
            "UPDATE business SET name='%e',type=%d,interior=%d,x='%f',y='%f',z='%f',exit_x='%f',exit_y='%f',exit_z='%f',exit_angle='%f' WHERE id=%d LIMIT 1",
            business_name, business_type, BUSINESS_INTERIOR_CAR_TUNING,
            x, y, z, x, y, z, angle, GetBusinessData(businessid, B_SQL_ID));
        mysql_query(mysql, update_query, false);
        SetBusinessData(businessid, B_TYPE, business_type);
        SetBusinessData(businessid, B_INTERIOR, BUSINESS_INTERIOR_CAR_TUNING);
    }

    SetBusinessData(businessid, B_POS_X, x);
    SetBusinessData(businessid, B_POS_Y, y);
    SetBusinessData(businessid, B_POS_Z, z);
    SetBusinessData(businessid, B_EXIT_POS_X, x);
    SetBusinessData(businessid, B_EXIT_POS_Y, y);
    SetBusinessData(businessid, B_EXIT_POS_Z, z);
    SetBusinessData(businessid, B_EXIT_ANGLE, angle);
    format(g_business[businessid][B_NAME], 24, "%s", business_name);

    if(IsValidDynamic3DTextLabel(Text3D:GetBusinessData(businessid, B_LABEL)))
        DestroyDynamic3DTextLabel(Text3D:GetBusinessData(businessid, B_LABEL));
    SetBusinessData(businessid, B_LABEL, CreateDynamic3DTextLabel(g_business[businessid][B_NAME], 0xFFFF00FF, x, y, z + 1.0, 10.0));
	RecreateBusinessEnterPickup(businessid);
    UpdateBusinessLabel(businessid);
    CreateDynamicMapIcon(x, y, z, 52, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
    printf("[TuningCenter] type=%d slot=%d sql=%d pos=%.3f %.3f %.3f", business_type, businessid, GetBusinessData(businessid, B_SQL_ID), x, y, z);
    return 1;
}

stock InitStaticTuningCenterBusinesses()
{
    InitStaticTuningCenterBusiness(BUSINESS_TYPE_STYLING_CENTER, "Стайлинг центр", 2312.133056, -2601.552246, 21.829063, 266.764404);
    InitStaticTuningCenterBusiness(BUSINESS_TYPE_TIRE_CENTER, "Шиномонтажный центр", 1731.648803, 2447.955810, 14.979245, 117.855155);
    InitStaticTuningCenterBusiness(BUSINESS_TYPE_TECH_CENTER, "Технический центр", -431.906372, 1005.235168, 12.189999, 170.943725);
    return 1;
}

stock InitStaticCarMarkets()
{
	printf("[MYSQL][AUTOSALON] InitStaticCarMarkets: start loaded=%d", g_business_loaded);
	if(g_business_loaded < 40)
	{
		for(new idx = g_business_loaded; idx < 40; idx++)
		{
			SetBusinessData(idx, B_SQL_ID, 0);
			SetBusinessData(idx, B_OWNER_ID, 0);
			SetBusinessData(idx, B_TYPE, 20);
			SetBusinessData(idx, B_INTERIOR, 0);
			SetBusinessData(idx, B_POS_X, 30000.0 + float(idx));
			SetBusinessData(idx, B_POS_Y, 30000.0 + float(idx));
			SetBusinessData(idx, B_POS_Z, 0.0);
			SetBusinessData(idx, B_EXIT_POS_X, 30000.0 + float(idx));
			SetBusinessData(idx, B_EXIT_POS_Y, 30000.0 + float(idx));
			SetBusinessData(idx, B_EXIT_POS_Z, 0.0);
			SetBusinessData(idx, B_EXIT_ANGLE, 0.0);
			SetBusinessData(idx, B_LABEL, Text3D:-1);
			format(g_business[idx][B_NAME], 24, "");
			format(g_business[idx][B_OWNER_NAME], 21, "None");
		}
		g_business_loaded = 40;
		printf("[MYSQL][AUTOSALON] Expanded g_business_loaded to %d for static car markets", g_business_loaded);
	}

	if(moto_salon_entry_pickup != -1)
	{
		DestroyPickup(moto_salon_entry_pickup);
		moto_salon_entry_pickup = -1;
	}
	if(moto_salon_exit_pickup != -1)
	{
		DestroyPickup(moto_salon_exit_pickup);
		moto_salon_exit_pickup = -1;
	}
	if(moto_salon_range_pickup != -1)
	{
		DestroyPickup(moto_salon_range_pickup);
		moto_salon_range_pickup = -1;
	}
	if(moto_salon_range_area != -1)
	{
		DestroyDynamicArea(moto_salon_range_area);
		moto_salon_range_area = -1;
	}
	if(IsValidDynamic3DTextLabel(moto_salon_exit_label))
	{
		DestroyDynamic3DTextLabel(moto_salon_exit_label);
		moto_salon_exit_label = Text3D:-1;
	}
	if(IsValidDynamic3DTextLabel(moto_salon_range_label))
	{
		DestroyDynamic3DTextLabel(moto_salon_range_label);
		moto_salon_range_label = Text3D:-1;
	}

	for(new biz_id = 35; biz_id <= STATIC_BIZ_ID_TRUCK_SALON; biz_id++)
	{
		if(g_business_enter_pickup[biz_id] != 0)
		{
			DestroyPickup(g_business_enter_pickup[biz_id]);
			g_business_enter_pickup[biz_id] = 0;
		}

		if(IsValidDynamic3DTextLabel(Text3D:GetBusinessData(biz_id, B_LABEL)))
			DestroyDynamic3DTextLabel(Text3D:GetBusinessData(biz_id, B_LABEL));

		// SQL id and owner are loaded from business; never replace them with volatile State data.
		SetBusinessData(biz_id, B_TYPE, BUSINESS_TYPE_CAR_MARKET);
		SetBusinessData(biz_id, B_INTERIOR, 0);
		SetBusinessData(biz_id, B_ENTER_PRICE, 0);
		SetBusinessData(biz_id, B_ENTER_MUSIC, 0);
		// Keep the persisted warehouse amount. Owners must replenish it through deliveries.
		SetBusinessData(biz_id, B_LOCK_STATUS, false);
		SetBusinessData(biz_id, B_EVICTION, 0);
		SetBusinessData(biz_id, B_ORDER_ID, -1);
		if(!IsBusinessOwned(biz_id)) format(g_business[biz_id][B_OWNER_NAME], 21, "None");

		switch(biz_id)
		{
			case 35:
			{
				format(g_business[biz_id][B_NAME], 24, "Автосалон Эконом");
				SetBusinessData(biz_id, B_POS_X, 802.788635);
				SetBusinessData(biz_id, B_POS_Y, 497.319488);
				SetBusinessData(biz_id, B_POS_Z, 12.275835);
				SetBusinessData(biz_id, B_EXIT_POS_X, 807.004455);
				SetBusinessData(biz_id, B_EXIT_POS_Y, 508.142089);
				SetBusinessData(biz_id, B_EXIT_POS_Z, 12.236772);
				SetBusinessData(biz_id, B_EXIT_ANGLE, 337.131225);
			}
			case 36:
			{
				format(g_business[biz_id][B_NAME], 24, "Автосалон Высокий");
				SetBusinessData(biz_id, B_POS_X, 660.813293);
				SetBusinessData(biz_id, B_POS_Y, 2667.927978);
				SetBusinessData(biz_id, B_POS_Z, 14.501132);
				SetBusinessData(biz_id, B_EXIT_POS_X, 655.518676);
				SetBusinessData(biz_id, B_EXIT_POS_Y, 2661.782714);
				SetBusinessData(biz_id, B_EXIT_POS_Z, 13.516562);
				SetBusinessData(biz_id, B_EXIT_ANGLE, 148.320831);
			}
			case 37:
			{
				format(g_business[biz_id][B_NAME], 24, "Автосалон Средний");
				SetBusinessData(biz_id, B_POS_X, 1411.059570);
				SetBusinessData(biz_id, B_POS_Y, 460.159515);
				SetBusinessData(biz_id, B_POS_Z, 13.203024);
				SetBusinessData(biz_id, B_EXIT_POS_X, 1406.829101);
				SetBusinessData(biz_id, B_EXIT_POS_Y, 455.163024);
				SetBusinessData(biz_id, B_EXIT_POS_Z, 13.203024);
				SetBusinessData(biz_id, B_EXIT_ANGLE, 146.174179);
			}
			case STATIC_BIZ_ID_MOTO_SALON:
			{
				format(g_business[biz_id][B_NAME], 24, "Мотосалон");
				SetBusinessData(biz_id, B_POS_X, -916.011230);
				SetBusinessData(biz_id, B_POS_Y, 1188.013427);
				SetBusinessData(biz_id, B_POS_Z, 10.724749);
				SetBusinessData(biz_id, B_EXIT_POS_X, -583.071289);
				SetBusinessData(biz_id, B_EXIT_POS_Y, 2301.811279);
				SetBusinessData(biz_id, B_EXIT_POS_Z, 1501.040039);
				SetBusinessData(biz_id, B_EXIT_ANGLE, 209.909362);
			}
			case STATIC_BIZ_ID_TRUCK_SALON:
			{
				format(g_business[biz_id][B_NAME], 24, "Салон грузовых");
				SetBusinessData(biz_id, B_POS_X, -735.495544);
				SetBusinessData(biz_id, B_POS_Y, 1964.257446);
				SetBusinessData(biz_id, B_POS_Z, 45.941688);
				SetBusinessData(biz_id, B_EXIT_POS_X, -739.473022);
				SetBusinessData(biz_id, B_EXIT_POS_Y, 1964.449951);
				SetBusinessData(biz_id, B_EXIT_POS_Z, 45.941688);
				SetBusinessData(biz_id, B_EXIT_ANGLE, 89.766098);
			}
		}

		SetBusinessData(biz_id, B_LABEL, CreateDynamic3DTextLabel(g_business[biz_id][B_NAME], 0xFFFF00FF, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z) + 1.0, 6.50));
		UpdateBusinessLabel(biz_id);
		if(biz_id == STATIC_BIZ_ID_MOTO_SALON)
		{
			moto_salon_entry_pickup = CreatePickup(19132, 23, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z), 0, PICKUP_ACTION_TYPE_MOTO_SALON_ENTER, biz_id);
			moto_salon_exit_pickup = CreatePickup(19132, 23, -587.679565, 2313.521728, 1501.040039, 0, PICKUP_ACTION_TYPE_MOTO_SALON_EXIT, biz_id);
			moto_salon_exit_label = CreateDynamic3DTextLabel("{FFFF00}« Выход из мотосалона »\n\n{FFFFFF}Подойдите ближе для выхода", 0xFFFF00FF, -587.679565, 2313.521728, 1501.040039 + 1.0, 10.0);
			moto_salon_range_pickup = CreatePickup(1239, 23, -581.895996, 2308.058105, 1501.040039, 0);
			moto_salon_range_label = CreateDynamic3DTextLabel("{FFFF00}« Модельный ряд »\n\n{FFFFFF}Подойдите для взаимодействия", 0xFFFF00FF, -581.895996, 2308.058105, 1501.040039 + 0.45, 10.0);
			moto_salon_range_area = CreateDynamicSphere(-581.895996, 2308.058105, 1501.040039, 2.0, 0, 1);
		}
		else
		{
			RecreateBusinessEnterPickup(biz_id);
		}
		CreateDynamicMapIcon(GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z), 52, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
		printf("[MYSQL][AUTOSALON] Static car market created: biz_id=%d pos=(%.3f, %.3f, %.3f) exit=(%.3f, %.3f, %.3f) angle=%.3f", biz_id, GetBusinessData(biz_id, B_POS_X), GetBusinessData(biz_id, B_POS_Y), GetBusinessData(biz_id, B_POS_Z), GetBusinessData(biz_id, B_EXIT_POS_X), GetBusinessData(biz_id, B_EXIT_POS_Y), GetBusinessData(biz_id, B_EXIT_POS_Z), GetBusinessData(biz_id, B_EXIT_ANGLE));
	}
	return 1;
}

public: UpdateBusinessLabel(businessid)
{
	if(IsBusinessOnAuction(businessid) && GetBusinessData(businessid, B_TYPE) != BUSINESS_TYPE_CASINO)
	{
		new auction_type_name[32], auction_label[192];
		BusinessManager_GetTypeName(businessid, auction_type_name, sizeof auction_type_name);
		format
		(
			auction_label, sizeof auction_label,
			"{FFFF00}%s (%d)\n{66CC00}Бизнес находится на аукционе\n{FFFFFF}Владелец до окончания торгов: {0b7ecf}%s",
			auction_type_name,
			businessid,
			g_business[businessid][B_OWNER_NAME]
		);
		UpdateDynamic3DTextLabelText(g_business[businessid][B_LABEL], 0xFFFF00FF, auction_label);
		return 1;
	}

	if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_LAREK) return Larek_UpdateLabelPublic(businessid);
    new fmt_str[169 + 1];

    if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_SHOP_GUN) return 1;

    if(Diner_IsEnterPosition(GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), GetBusinessData(businessid, B_POS_Z)))
    {
        new diner_owner_name[21];
        if(IsBusinessOwned(businessid)) format(diner_owner_name, sizeof diner_owner_name, "%s", g_business[businessid][B_OWNER_NAME]);
        else format(diner_owner_name, sizeof diner_owner_name, "отсутствует");

        format(fmt_str, sizeof fmt_str,
            "{FFFF00}Закусочная (%d)\n{FFFFFF}Владелец: {0b7ecf}%s\n{FFFF00}Крыша: отсутствует",
            businessid, diner_owner_name);

        Diner_UpdateBusinessEnterLabel(GetBusinessData(businessid, B_POS_X), GetBusinessData(businessid, B_POS_Y), GetBusinessData(businessid, B_POS_Z), businessid, diner_owner_name);
        UpdateDynamic3DTextLabelText(g_business[businessid][B_LABEL], 0xFFFF00FF, fmt_str);
        return 1;
    }

	if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_CAR_MARKET)
	{
		new salon_name[64], salon_owner[21];
		if(IsBusinessOwned(businessid)) format(salon_owner, sizeof salon_owner, "%s", g_business[businessid][B_OWNER_NAME]);
		else format(salon_owner, sizeof salon_owner, "отсутствует");

		switch(businessid)
		{
			case 36: format(salon_name, sizeof salon_name, "Автосалон высокого класса (28)");
			case 37: format(salon_name, sizeof salon_name, "Автосалон среднего класса (29)");
			case STATIC_BIZ_ID_MOTO_SALON: format(salon_name, sizeof salon_name, "Мотосалон (41)");
			case STATIC_BIZ_ID_TRUCK_SALON: format(salon_name, sizeof salon_name, "Салон грузовых автомобилей (42)");
			default: format(salon_name, sizeof salon_name, "Автосалон низкого класса (30)");
		}

		format
		(
			fmt_str, sizeof fmt_str,
			"{FFFF00} %s\n{FFFFFF} Владелец: {0b7ecf}%s\n{FFFFFF}Продукты: {FFCC00}%d/%d",
			salon_name,
			salon_owner,
			GetBusinessData(businessid, B_PRODS), AUTOSALON_FULL_PRODUCTS
		);
		UpdateDynamic3DTextLabelText(Text3D:GetBusinessData(businessid, B_LABEL), 0xFFFF00FF, fmt_str);
		return 1;
	}

	if(GetBusinessData(businessid, B_TYPE) == BUSINESS_TYPE_CASINO)
	{
		new casino_public_id = IsBonusCasinoBusiness(businessid) ? 30 : businessid;

		if(IsBusinessOnAuction(businessid))
		{
			format
			(
				fmt_str, sizeof fmt_str,
				"{FFFF00}Казино (%d)\n" \
				"{66CC00}Бизнес находится на аукционе\n" \
				"{66CC00}Крыша: Пыткаринская ОПГ",
				casino_public_id
			);
		}
		else if(IsBusinessOwned(businessid))
		{
			format
			(
				fmt_str, sizeof fmt_str,
				"{FFFF00}Казино (%d)\n" \
				"{FFFFFF}Крыша: Пыткаринская ОПГ\n" \
				"{FFFFFF}Владелец: {0b7ecf}%s",
				casino_public_id,
				g_business[businessid][B_OWNER_NAME]
			);
		}
		else
		{
			format
			(
				fmt_str, sizeof fmt_str,
				"{FFFF00}Казино (%d)\n" \
				"{66CC00}Бизнес находится на аукционе\n" \
				"{FFCC00}Цена: {FF9900}%d руб",
				casino_public_id,
				g_business[businessid][B_PRICE]
			);
		}

		UpdateDynamic3DTextLabelText(g_business[businessid][B_LABEL], 0xFFFF00FF, fmt_str);
		return 1;
	}

if(!IsBusinessOwned(businessid))
{
	format
	(
		fmt_str, sizeof fmt_str,
		"{FFFF00}%s\n" \
		"{66CC00}Бизнес находится на аукционе\n" \
		"{FFCC00}Цена: {FF9900}%d руб\n",
		//"{FF6600}Крыша: Арзамасское ОПГ",
		g_business[businessid][B_NAME],
		g_business[businessid][B_PRICE]
	);
}
					else
{
	format
	(
		fmt_str, sizeof fmt_str,
		"{FFFF00}%s (%d)\n" \
		"{FFFF00}Крыша: отсутствует\n" \
		"{FFFFFF}Владелец: {0b7ecf}%s\n",
		g_business[businessid][B_NAME],
		businessid,
		g_business[businessid][B_OWNER_NAME]
	);

	if(g_business[businessid][B_LOCK_STATUS])
	{
		strcat(fmt_str, "{FF6600}Закрыто");
	}
}

UpdateDynamic3DTextLabelText(g_business[businessid][B_LABEL], 0xFFFF00FF, fmt_str);
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

public:	LoadFuelStations()
{
	new query[85];
	new Cache: result, rows;

	result = mysql_query(mysql, "SELECT fs.*, IFNULL(a.name, 'None') AS owner_name FROM fuel_stations fs LEFT JOIN accounts a ON a.id=fs.owner_id", true);
	rows = cache_num_rows(result);

	if(rows > MAX_FUEL_STATIONS)
	{
		rows = MAX_FUEL_STATIONS;
		print("[FuelST]: DB rows > MAX_FUEL_STATIONS");
	}

	for(new idx; idx < rows; idx ++)
	{
		SetFuelStationData(idx, FS_SQL_ID,		cache_get_field_content_int(idx, "id"));
		SetFuelStationData(idx, FS_OWNER_ID, 	cache_get_field_content_int(idx, "owner_id"));

		cache_get_field_content(idx, "name", g_fuel_station[idx][FS_NAME], mysql, 20);

		SetFuelStationData(idx, FS_IMPROVEMENTS, cache_get_field_content_int(idx, "improvements"));
		SetFuelStationData(idx, FS_FUELS, 			cache_get_field_content_int(idx, "fuels"));
		SetFuelStationData(idx, FS_FUEL_PRICE,		cache_get_field_content_int(idx, "fuel_price"));
		SetFuelStationData(idx, FS_BUY_FUEL_PRICE,	cache_get_field_content_int(idx, "buy_fuel_price"));
		SetFuelStationData(idx, FS_BALANCE,			cache_get_field_content_int(idx, "balance"));
		SetFuelStationData(idx, FS_RENT_DATE,		cache_get_field_content_int(idx, "rent_time"));

		SetFuelStationData(idx, FS_PRICE,			cache_get_field_content_int(idx, "price"));
		SetFuelStationData(idx, FS_RENT_PRICE,		cache_get_field_content_int(idx, "rent_price"));

		SetFuelStationData(idx, FS_LOCK_STATUS,		bool: cache_get_field_content_int(idx, "lock"));

		SetFuelStationData(idx, FS_POS_X,			cache_get_field_content_float(idx, "x"));
		SetFuelStationData(idx, FS_POS_Y,			cache_get_field_content_float(idx, "y"));
		SetFuelStationData(idx, FS_POS_Z,			cache_get_field_content_float(idx, "z"));

		SetFuelStationData(idx, FS_EVICTION,		cache_get_field_content_int(idx, "eviction"));

		cache_get_field_content(idx, "owner_name", g_fuel_station[idx][FS_OWNER_NAME], mysql, 21);
		// -------------------------

		SetFuelStationData(idx, FS_LABEL, CreateDynamic3DTextLabel(GetFuelStationData(idx, FS_NAME), 0x3399FFFF, GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z) + 0.5, 15.0));
		SetFuelStationData(idx, FS_AREA, CreateDynamicSphere(GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z), 15.0));

		SetFuelStationData(idx, FS_ORDER_ID, -1);

		if(IsFuelStationOwned(idx) && !strcmp(GetFuelStationData(idx, FS_OWNER_NAME), "None", true))
		{
			format(query, sizeof query, "UPDATE accounts SET `fuel_st`=-1 WHERE `id`=%d LIMIT 1", GetFuelStationData(idx, FS_OWNER_ID));
			mysql_query(mysql, query, false);

			SetFuelStationData(idx, FS_OWNER_ID, 0);

			mysql_format(mysql, query, sizeof query, "UPDATE fuel_stations SET owner_id=0 WHERE id=%d", GetFuelStationData(idx, FS_SQL_ID));
			mysql_query(mysql, query, false);
		}

		if(!IsFuelStationOwned(idx))
		{
			SetFuelStationData(idx, FS_FUELS, 1000);
			SetFuelStationData(idx, FS_FUEL_PRICE, 3);

			SetFuelStationData(idx, FS_LOCK_STATUS, false);
		}
		CallLocalFunction("UpdateFuelStationLabel", "i", idx);

		#if defined FUEL_ST_CREATED_PICKUP
			CreatePickup(1650, 23, GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z), 0, PICKUP_ACTION_TYPE_FUEL_STATION, idx);
		#endif

		CreateDynamicMapIcon(GetFuelStationData(idx, FS_POS_X), GetFuelStationData(idx, FS_POS_Y), GetFuelStationData(idx, FS_POS_Z), 47, 0, 0, 0, -1, STREAMER_MAP_ICON_SD, MAPICON_LOCAL);
	}
	g_fuel_station_loaded = rows;
	cache_delete(result);

	printf("[FuelST]: Заправок загружено: %d", g_fuel_station_loaded);
}

public: UpdateFuelStationLabel(stationid)
{
	new fmt_str[350];

	if(!IsFuelStationOwned(stationid))
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"{ffff00} АЗС (none)\n"\
			"{0099CC}Стоимость топлива:\n"\
			"  \n"\
			"{FFFFFF}АИ-92: {00CC00}50  руб\n"\
			"{FFFFFF}АИ-95: {00CC00}50 руб\n"\
			"{FFFFFF}АИ-98: {00CC00}50 руб\n"\
			"{FFFFFF}АИ-100: {00CC00}50 руб\n"\
			"{FFFFFF}АИ-ДТ: {00CC00}50  руб\n"\
			"  \n"\
			"{66CC00}Бизнес находится на аукционе\n"\
			"{66CC00}Крыша: Арзамасское ОПГ\n"\
			"{0099CC}Для заправки введите /i или нажмите гудок",
			GetFuelStationData(stationid, FS_NAME),
			GetFuelStationData(stationid, FS_NAME),
			GetFuelStationData(stationid, FS_NAME)
		);

	}
					else
	{
		format
		(
			fmt_str, sizeof fmt_str,
			"%s\n"\
			"Крыша: Арзамасская ОПГ\n"\
			"{FFFFFF}Владелец: {66CC00}%s\n"\
			"  \n"\
			"{66CC00}Стоимость топлива:\n"\
			"{FFFFFF}АИ-92: {00CC00}50  руб\n"\
			"{FFFFFF}АИ-95: {00CC00}50 руб\n"\
			"{FFFFFF}АИ-98: {00CC00}50 руб\n"\
			"{FFFFFF}АИ-100: {00CC00}50 руб\n"\
			"{FFFFFF}АИ-ДТ: {00CC00}50  руб\n"\
			"{0099CC}Для заправки введите /i или нажмите гудок\n",
			GetFuelStationData(stationid, FS_NAME),
			GetFuelStationData(stationid, FS_OWNER_NAME),
			GetFuelStationData(stationid, FS_FUEL_PRICE) * 10
		);

		/*if(GetFuelStationData(stationid, FS_LOCK_STATUS))
		{
			strcat(fmt_str, "{FF6600}Станция закрыта");
		}
					else format(fmt_str, sizeof fmt_str, "%s{FFFFFF}Цена за 10 литров: {FFCD00}%d руб", fmt_str, GetFuelStationData(stationid, FS_FUEL_PRICE) * 10);*/
	}
	UpdateDynamic3DTextLabelText(GetFuelStationData(stationid, FS_LABEL), 0x3399FFFF, fmt_str);
}

public: OnGiveReferBonus(refer_id)
{
	new fmt_str[155];
	new playerid = GetPlayerIDBySqlID(refer_id);

	if(playerid != INVALID_PLAYER_ID)
	{
		GivePlayerMoneyEx(playerid, REFER_BONUS_MONEY, "Реферальная программа 'Пригласи друга'", true, false);

		format(fmt_str, sizeof fmt_str, "Поздравляем! Приглашенный Вами игрок достиг 5 уровня, Вы получаете %d рублей", REFER_BONUS_MONEY);
		SendClientMessage(playerid, 0x66CC00FF, fmt_str);
	}
					else
	{
		format(fmt_str, sizeof fmt_str, "INSERT INTO money_log (uid,uip,time,money,description) VALUES (%d,'%s',%d,%d,'%s')", refer_id, "system", gettime(), REFER_BONUS_MONEY, "Реферальная программа 'Пригласи друга'");
		mysql_query(mysql, fmt_str, false);

		format(fmt_str, sizeof fmt_str, "UPDATE accounts SET money=money+%d WHERE id=%d LIMIT 1", REFER_BONUS_MONEY, refer_id);
		mysql_query(mysql, fmt_str, false);

		if(mysql_errno() != 0)
			printf("[Referal System]: Произошла ошибка при выдаче бонуса реферу №%d", refer_id);
	}
}

