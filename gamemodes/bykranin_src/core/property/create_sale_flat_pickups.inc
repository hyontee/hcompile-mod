//>> Файл: bykranin_src/core/property/create_sale_flat_pickups.inc  (454 строк)
//>> Тема: недвижимость: дома, квартиры, бизнесы, аренда, отели
//>> Внутри: CreateSaleFlatPickups
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock CreateSaleFlatPickups(worldid = -1)
{
    new fmt[2048];
    format(fmt, sizeof fmt, "{ffe135}« Лифт »\n\n{ffffff}Подойдите ближе\n{ffffff}для взаимодействия");
    CreateDynamic3DTextLabel(fmt, 0xffe135FF, -501.77, 1002.99, 1499.17 + 0.8, 4.0);
    CreateDynamic3DTextLabel(fmt, 0xffe135FF, 560.64, 23.05, 1049.36 + 0.8, 4.0);
	CreateDynamic3DTextLabel(fmt, 0xffe135FF, -493.166503, 1005.966674, 1499.172851 + 0.8, 4.0);
    new fmts[2048];
    format(fmts, sizeof fmts, "{ffe135}« Лифт »\n\n{ffffff}Подойдите {ffffff}для взаимодействия");
    CreateDynamic3DTextLabel(fmts, 0xffe135FF, -497.13, 500.15, 1501.04, 5.0);
	CreateDynamic3DTextLabel("{3399ff}Подойдите ближе для\n взаимодействия c выходом", 0x3399FFFF, 2903.2188,1498.0972,2001.0000 - 0.8, 8.0);
	CreateDynamic3DTextLabel("{3399ff}Подойдите ближе для\n взаимодействия c выходом", 0x3399FFFF, 667.4174,29.3543,1024.1985 - 0.8, 8.0);
	CreateDynamic3DTextLabel("{3399ff}Подойдите ближе для\n взаимодействия c выходом", 0x3399FFFF,  10.3718,2494.1458,1540.9941 - 0.8, 8.0);
    for (new i = 0; i < FLATS_FOR_SALE_COUNT; i++)
    {
        new Float:x = gFlatsForSale[i][0];
        new Float:y = gFlatsForSale[i][1];

        gFlatFloors[i] = 2;
        gFlatPrice[i] = 1500000;
        gFlatType[i] = 2;
        gFlatEnTypes[i] = 0;

        if (x > -2559.0 && x < -2497.0 &&
            y > 1153.0 && y < 1274.0)
        {
            gFlatFloors[i] = 2;
            gFlatPrice[i] = 850000;
            gFlatType[i] = 1;
        }
        else if (x > 1608.0 && x < 2647.0 &&
                 y > -2647.0 && y < -1819.0)
        {
            gFlatFloors[i] = 2;
            gFlatPrice[i] = 850000;
            gFlatType[i] = 1;
        }
        else if (x > -2547.0 && x < -1922.0 &&
                 y > 2060.0 && y < 2822.0)
        {
            gFlatFloors[i] = 2;
            gFlatPrice[i] = 450000;
            gFlatType[i] = 1;
        }
        else if (x > -1956.0 && x < -1377.0 &&
                 y > 2259.0 && y < 3036.0)
        {
            gFlatFloors[i] = 2;
            gFlatPrice[i] = 450000;
            gFlatType[i] = 1;
        }
        else if (x > -2372.0 && x < -2162.0 &&
                 y > -331.0 && y < -8.0)
        {
            gFlatFloors[i] = 2;
            gFlatPrice[i] = 450000;
            gFlatType[i] = 1;
        }
        else if (x > -396.0 && x < 960.0 &&
                 y > 398.0 && y < 1955.0)
        {
            gFlatPrice[i] = 450000;
            gFlatType[i] = 2;
            gFlatFloors[i] = 2;
        }
        else if (x > -2512.0 && x < -2246.0 &&
                 y > -157.0 && y < 176.0)
        {
            gFlatPrice[i] = 450000;
            gFlatType[i] = 2;
            gFlatFloors[i] = 2;
        }
        else if (x > 1660.0 && x < 1891.0 &&
                 y > 2136.0 && y < 2460.0)
        {
            gFlatType[i] = 1;
            gFlatFloors[i] = 2;
        }
        else if (x > -2603.0 && x < -2311.0 &&
                 y > 1256.0 && y < 1621.0)
        {
            gFlatPrice[i] = 250000;
            gFlatType[i] = 1;
            gFlatFloors[i] = 2;
        }
        else if (x > -2250.0 && x < -2121.0 &&
                 y > 1262.0 && y < 1448.0)
        {
            gFlatPrice[i] = 250000;
            gFlatType[i] = 1;
            gFlatFloors[i] = 2;
        }
        else if (x > 406.0 && x < 931.0 &&
                 y > 727.0 && y < 1318.0)
        {
            gFlatPrice[i] = 250000;
            gFlatType[i] = 1;
            gFlatFloors[i] = 2;
        }
        else if (x > -2356.191162 && x < -2316.191162 &&
                 y > 1595.378540 && y < 1635.378540)
        {
            gFlatPrice[i] = 1500000;
            gFlatType[i] = 3;
            gFlatFloors[i] = 2;
        }
        else if (x > -2525.680664 && x < -2485.680664 &&
                 y > 1588.905151 && y < 1628.905151)
        {
            gFlatPrice[i] = 1500000;
            gFlatType[i] = 3;
            gFlatFloors[i] = 2;
        }
        else if (x > -2596.450439 && x < -2556.450439 &&
                 y > 1080.072631 && y < 1120.072631)
        {
            gFlatPrice[i] = 1500000;
            gFlatType[i] = 3;
            gFlatFloors[i] = 2;
        }
        else if (x > -2387.620117 && x < -2347.620117 &&
                 y > 2189.166259 && y < 2229.166259)
        {
            gFlatPrice[i] = 1500000;
            gFlatType[i] = 3;
            gFlatFloors[i] = 2;
        }
        else if (x > -2376.770996 && x < -2336.770996 &&
                 y > 2323.885742 && y < 2363.885742)
        {
            gFlatPrice[i] = 1500000;
            gFlatType[i] = 3;
            gFlatFloors[i] = 2;
        }
        else if (x > 104.349601 && x < 144.349601 &&
                 y > 340.309478 && y < 380.309478)
        {
            gFlatPrice[i] = 450000;
            gFlatType[i] = 1;
            gFlatFloors[i] = 30;
        }

        if (i + 1 == 400)
        {
            gFlatPrice[i] = 450000;
            gFlatType[i] = 1;
            gFlatEnTypes[i] = 2;
            gFlatFloors[i] = 30;
        }

        if (i + 1 == 401)
        {
            gFlatPrice[i] = 450000;
            gFlatType[i] = 1;
            gFlatEnTypes[i] = 2;
            gFlatFloors[i] = 30;
        }

        if (i + 100 == 498 || i + 100 == 497 || i + 100 == 494 || i + 100 == 493 ||
            i + 100 == 491 || i + 100 == 492 || i + 100 == 495 || i + 100 == 496 ||
            i + 100 == 490 || i + 100 == 489 || i + 100 == 488 || i + 100 == 487)
        {
            gFlatPrice[i] = 500000;
            gFlatType[i] = 2;
            gFlatFloors[i] = 6;
            gFlatEnTypes[i] = 1;
        }
		if (i == 535 || i == 536 || i == 692 || i == 691 || i == 697 || i == 713 || i == 532 || i == 533)
        {
            gFlatPrice[i] = 1500000;
            gFlatType[i] = 4;
            gFlatFloors[i] = 2;
            gFlatEnTypes[i] = 0;
        }

        if (x > 303.779601 && x < 673.416601 &&
            y > 411.309478 && y < 725.309478)
        {
            gFlatPrice[i] = 500000;
            gFlatType[i] = 2;
            gFlatFloors[i] = 6;
            gFlatEnTypes[i] = 1;
        }

        if (x > 335.579601 && x < 650.086601 &&
            y > 769.031478 && y < 1082.059478)
        {
            gFlatPrice[i] = 500000;
            gFlatType[i] = 2;
            gFlatFloors[i] = 6;
            gFlatEnTypes[i] = 1;
        }

        if (x > 470.579601 && x < 973.686601 &&
            y > 1214.521478 && y < 1343.259478)
        {
            gFlatPrice[i] = 500000;
            gFlatType[i] = 2;
            gFlatFloors[i] = 6;
            gFlatEnTypes[i] = 1;
        }

        if (gFlatEnTypes[i] == 1)
        {
            CreateDynamicActionPickup(
                19134,
                23,
                -501.77,
                1002.99,
                1499.17,
                i,
                PICKUP_ACTION_TYPE_HOUSE_LIFT,
                i
            );
			

            CreateDynamicActionPickup(
                1318,
                23,
                -500.83,
                999.07,
                1499.17,
                i,
                PICKUP_ACTION_TYPE_FLAT_EXIT,
                i
            );
        }

        if (gFlatEnTypes[i] == 2)
        {
            CreateDynamicActionPickup(
                1318,
                23,
                -507.33,
                488.08,
                1501.04,
                i,
                PICKUP_ACTION_TYPE_FLAT_EXIT,
                i
            );
        }

        format(fmt, sizeof fmt, "{ffe135}« Вход в подъезд »\n| {ffffff}Номер подъезда: {ffe135}%d\n| {ffffff}Количество этажей: {ffe135}%d", i + 100, gFlatFloors[i]);
        CreateDynamic3DTextLabel(fmt, 0xffe135FF, x, y, gFlatsForSale[i][2] + 0.8, 8.0);

        gFlatSalePickup[i] = CreateDynamicActionPickup(
            1273,
            PICKUP_TYPE_DEFAULT,
            x,
            y,
            gFlatsForSale[i][2],
            0,
            PICKUP_ACTION_TYPE_HOUSE_NEWS,
            i
        );

        if (gFlatEnTypes[i] == 0)
        {
            CreateDynamicActionPickup(
                19134,
                23,
                560.64,
                23.05,
                1049.36,
                i,
                PICKUP_ACTION_TYPE_HOUSE_LIFT,
                i
            );

            CreateDynamicActionPickup(
                1318,
                23,
                558.33,
                22.61,
                1049.30,
                i,
                PICKUP_ACTION_TYPE_FLAT_EXIT,
                i
            );
        }

        for (new v = 1; v <= gFlatFloors[i]; v++)
        {
            new worldids = i + ((v - 1) * (FLATS_FOR_SALE_COUNT + 1));

            if (gFlatEnTypes[i] == 0)
            {
                CreateDynamicActionPickup(
                    19134,
                    23,
                    560.64,
                    23.05,
                    1049.36,
                    worldids,
                    PICKUP_ACTION_TYPE_HOUSE_LIFT,
                    i
                );

                if (v != 1)
                {
                    new fmtl[2048];
                    format(fmtl, sizeof fmtl, "{ffff00}Этаж: №%d", v);

                    CreateDynamic3DTextLabel(
                        fmtl,
                        0xffff00FF,
                        558.33,
                        22.61,
                        1049.30 + 1,
                        10.0,
                        INVALID_PLAYER_ID,
                        INVALID_VEHICLE_ID,
                        1,
                        worldids,
                        1
                    );
                }else{
					CreateDynamic3DTextLabel(
                        "{ffff00}Этаж: №1",
                        0xffff00FF,
                        558.33,
                        22.61,
                        1049.30 + 1,
                        10.0,
                        INVALID_PLAYER_ID,
                        INVALID_VEHICLE_ID,
                        1,
                        worldids,
                        1
                    );
				}

                CreateDynamicActionPickup(
                    1318,
                    23,
                    558.33,
                    22.61,
                    1049.30,
                    worldids,
                    PICKUP_ACTION_TYPE_FLAT_EXIT,
                    i
                );

				new Float:flatPos[4][3] =
                {
                    {552.79, 25.45, 1049.31},
                    {554.67, 26.63, 1049.31},
                    {565.18, 26.63, 1049.31},
                    {567.20, 25.33, 1049.31}
                };

                for (new k = 0; k < 4; k++)
                {
                    new flat_number = ((v - 1) * 4) + (k + 1);
                    new subid = i * 1000 + v * 10 + (k + 1);

                    CreateDynamicActionPickup(
                        19198,
                        23,
                        flatPos[k][0],
                        flatPos[k][1],
                        flatPos[k][2],
                        worldids,
                        PICKUP_ACTION_TYPE_FLAT_ENTER,
                        subid
                    );

                    new flat_label[144];
                    format(
                        flat_label,
                        sizeof flat_label,
                        "{ffff00}« Квартира »\n| {ffffff}Номер квартиры{ffff00}: %d",
                        flat_number
                    );

                    CreateDynamic3DTextLabel(
                        flat_label,
                        0xFFFFFFFF,
                        flatPos[k][0],
                        flatPos[k][1],
                        flatPos[k][2] + 1.3,
                        6.0,
                        INVALID_PLAYER_ID,
                        INVALID_VEHICLE_ID,
                        1,
                        worldids,
                        1
                    );
                }
            }

			if (gFlatEnTypes[i] == 1)
            {
                CreateDynamicActionPickup(
                    19134,
                    23,
                    -493.166503, 1005.966674, 1499.172851,
                    worldids,
                    PICKUP_ACTION_TYPE_HOUSE_LIFT,
                    i
                );

				new Float:flatPos[4][3] =
                {
                    {-491.66, 1004.88, 1499.17},
                    {-491.95, 998.40, 1499.17},
                    {-494.54, 995.28, 1499.17},
                    {-494.45, 1001.47, 1499.17}
                };

                for (new k = 0; k < 4; k++)
                {
                    new flat_number = ((v - 2) * 4) + (k + 1);
                    new subid = i * 1000 + v * 10 + (k + 1);

                    CreateDynamicActionPickup(
                        19198,
                        23,
                        flatPos[k][0],
                        flatPos[k][1],
                        flatPos[k][2],
                        worldids,
                        PICKUP_ACTION_TYPE_FLAT_ENTER,
                        subid
                    );

                    new flat_label[144];
                    format(
                        flat_label,
                        sizeof flat_label,
                        "{ffff00}« Квартира »\n| {ffffff}Номер квартиры{ffff00}: %d",
                        flat_number
                    );

                    CreateDynamic3DTextLabel(
                        flat_label,
                        0xFFFFFFFF,
                        flatPos[k][0],
                        flatPos[k][1],
                        flatPos[k][2] + 1.3,
                        6.0,
                        INVALID_PLAYER_ID,
                        INVALID_VEHICLE_ID,
                        1,
                        worldids,
                        1
                    );
                }
            }
        }
    }
    return 1;
}
