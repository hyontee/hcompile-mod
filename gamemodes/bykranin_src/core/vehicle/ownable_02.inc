//>> Файл: bykranin_src/core/vehicle/ownable_02.inc  (98 строк)
//>> Тема: транспорт: автосалон, тюнинг, номера, личные авто, топливо
//>> Внутри: GetSellCarPriceByModel, GetVehiclePriceByModel
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock GetSellCarPriceByModel(modelid)
{
    for(new i = 0; i < sizeof(g_sellcar_price_map); i++)
    {
        if(g_sellcar_price_map[i][SELLCAR_MODEL_ID] == modelid)
            return g_sellcar_price_map[i][SELLCAR_PRICE];
    }

    return GetVehiclePriceByModel(modelid);
}

stock GetVehiclePriceByModel(model)
{
    new index = model - VEHICLE_MODEL_OFFSET;

    if(index < 0 || index >= sizeof(g_vehicle_info))
        return 6000000;

    new price = g_vehicle_info[index][VI_PRICE];
    if(price <= 0)
        return 6000000;

    return price;
}

#define MAX_VEHICLE_COMPONENTS 2252

// Ultra fast vehicle component system

new const gVehicleComponentOffset[538] =
{
    -1, 0, 9, -1, -1, 44, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, 74, 89, 113, -1, -1, -1, -1, 128, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, 145, -1, 158, -1, -1, -1, -1, -1, -1, 159, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 168, -1, -1, -1, -1,
    -1, -1, -1, 185, 195, -1, -1, -1, -1, -1, -1, -1, 210, -1, 237, -1,
    245, 264, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, 295, -1, -1, -1, 302, -1, -1, 303, -1, -1, -1, 312, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    322, -1, 340, -1, -1, -1, 356, 391, -1, 402, -1, -1, -1, -1, -1, 408,
    -1, -1, -1, -1, -1, -1, 419, 426, 438, -1, -1, -1, 498, -1, -1, 513,
    -1, 526, -1, 552, -1, -1, -1, -1, 563, -1, -1, -1, -1, -1, 579, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 593, -1, 611, -1, 620, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, 627, 636, -1, 655, 656, -1, -1, -1, 662, 686,
    708, -1, -1, 725, -1, -1, 728, 738, -1, -1, -1, -1, -1, 746, 763, -1,
    -1, -1, -1, 778, 802, 816, -1, -1, -1, -1, -1, -1, -1, -1, 829, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
    835, -1, -1, -1, -1, -1, -1, -1, -1, 842, -1, -1, -1, -1, -1, -1,
    856, 863, 869, -1, -1, -1, 876, -1, -1, -1, -1, 879, 889, -1, -1, -1,
    -1, -1, -1, -1, -1, -1, 894, -1, 904, 925, 937, -1, -1, 951, -1, 958,
    963, 970, 984, 996, 1005, -1, 1013, -1, -1, -1, -1, -1, 1021, 1027, 1033, 1043,
    1049, -1, 1056, -1, -1, -1, 1070, -1, 1078, -1, 1080, 1086, 1087, -1, -1, -1,
    -1, -1, -1, 1090, -1, -1, -1, -1, -1, 1091, 1105, 1108, 1109, -1, -1, 1115,
    1119, 1125, 1131, 1134, 1139, 1147, 1157, -1, 1162, 1167, 1170, 1179, 1180, 1188, 1205, 1213,
    1217, 1221, 1229, 1235, -1, 1238, 1255, 1264, 1273, 1286, -1, 1298, 1309, 1326, 1333, 1340,
    1350, -1, 1362, 1369, 1376, 1383, 1394, 1402, 1409, 1412, 1422, 1429, -1, -1, -1, -1,
    -1, 1433, 1444, -1, 1455, 1461, 1464, 1470, 1480, 1485, 1492, 1501, 1508, 1516, 1521, 1530,
    1554, 1566, 1574, 1588, 1594, 1607, 1613, 1615, 1627, 1635, -1, 1647, 1656, 1664, 1673, 1680,
    1691, 1704, 1714, 1724, 1736, 1745, 1757, 1762, 1770, 1774, -1, -1, -1, -1, 1777, 1787,
    1795, 1803, 1811, 1820, 1831, 1840, 1847, 1853, 1855, 1859, 1863, 1868, 1873, 1881, 1888, 1895,
    1902, 1909, 1916, 1925, 1937, 1946, 1954, 1962, 1971, 1980, 1989, 1996, 2004, 2011, 2018, 2024,
    2033, 2039, 2044, 2048, 2059, 2063, 2073, 2082, 2098, 2109, 2115, 2123, 2136, 2145, 2153, 2164,
    2172, 2183, 2195, 2204, 2215, 2223, 2229, 2231, 2244, 2251
};

#define HOUSES_FOR_SALE_COUNT     (273)
#define HNEW_MAX_RENT_DAYS       (30)

new bool:gHouseOwned[HOUSES_FOR_SALE_COUNT];
new gHouseRentTime[HOUSES_FOR_SALE_COUNT];
new bool:g_house_new_opens[HOUSES_FOR_SALE_COUNT];
new bool:g_house_new_apt[HOUSES_FOR_SALE_COUNT];
new bool:g_house_new_remont[HOUSES_FOR_SALE_COUNT];
new bool:g_house_new_shkaf[HOUSES_FOR_SALE_COUNT];
new bool:g_flat_new_opens[200000];
new bool:g_flat_new_apt[200000];
new bool:g_flat_new_remont[200000];
new bool:g_flat_new_shkaf[200000];
new g_flat_real_id[200000];
#define LEGEND_ID_FLAT_FOR_SALE   (90)
#define LEGEND_ID_HOUSE_FOR_SALE  (91)

#define MODEL_PICKUP_FLAT         (1273)
#define MODEL_PICKUP_HOUSE        (1272)
#define PICKUP_TYPE_DEFAULT       (23)

#define FLATS_FOR_SALE_COUNT      (741)
new bool:gFlatOwned[200000];
new gFlatRentTime[200000];
new gFlatType[FLATS_FOR_SALE_COUNT];
new gFlatEnTypes[FLATS_FOR_SALE_COUNT];
new gFlatPrice[FLATS_FOR_SALE_COUNT];
new gFlatFloors[FLATS_FOR_SALE_COUNT];
new gFlatOwner[200000][24];
new gFlatOwnerID[200000];
