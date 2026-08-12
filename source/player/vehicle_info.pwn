#define TABLE_VEHICLE_SERVER        "s_vehicle_server"
#define TABLE_VEHICLE_PLAYER        "s_vehicle_player"


#define 	MAX_VALUE_FOR_SALE_GOS			50000 //default 50000
#define 	MAX_VALUE_FOR_SALE_GOS_IN_FINE	14 //default 14 day

enum ADD_YACHT_E {
	vehID,
	vehCost,
	Float:vehX,
	Float:vehY,
	Float:vehZ,
	Float:vehA,
	vehType, 
	vehTypeCost 
}
/*enum E_SLOT_SALE_VEHICLE {
	Float: vehSaleX,
	Float: vehSaleY,
	vehSaleType
}
new slotSaleVehicle[55][E_SLOT_SALE_VEHICLE], TOTAL_SALE_VEHICLE = 0;*/
static const vehTypeinfo[][ADD_YACHT_E] = {
/*0*/{ 454, 14_000_000, 209.3691, -1923.4834, 0.0716, 184.1028, TYPE_BOAT, TYPE_COST_CASH}, // 454 1
/*1*/{ 454, 14_000_000, 196.7077, -1924.3802, 0.2156, 181.2384, TYPE_BOAT, TYPE_COST_CASH}, // 454 2
/*2*/{ 446, 8_000_000, 228.4050, -1944.3567, -0.5975, 178.3397, TYPE_BOAT, TYPE_COST_CASH}, // 446 1
/*3*/{ 446, 8_000_000, 234.8545, -1944.6963, -0.6253, 178.1985, TYPE_BOAT, TYPE_COST_CASH}, // 446 2
/*4*/{ 446, 8_000_000, 240.9773, -1944.7440, -0.4976, 178.8560, TYPE_BOAT, TYPE_COST_CASH}, // 446 3
/*5*/{ 446, 8_000_000, 247.4944, -1944.4446, -0.6705, 178.9674, TYPE_BOAT, TYPE_COST_CASH}, // 446 4
/*6*/{ 446, 8_000_000, 253.8512, -1943.7828, -0.5674, 180.0391, TYPE_BOAT, TYPE_COST_CASH}, // 446 5
/*7*/{ 446, 8_000_000, 259.6019, -1943.6750, -0.6716, 179.8040, TYPE_BOAT, TYPE_COST_CASH}, // 446 6
/*8*/{ 446, 8_000_000, 264.7614, -1944.5663, -0.6247, 179.1747, TYPE_BOAT, TYPE_COST_CASH}, // 446 7
/*9*/{ 484, 12_000_000, 222.7020, -2004.6588, 0.1565, 270.6096, TYPE_BOAT, TYPE_COST_CASH}, // 484 1
/*10*/{ 484, 12_000_000, 222.4961, -2012.8461, 0.2404, 270.6486, TYPE_BOAT, TYPE_COST_CASH}, // 484 2
/*11*/{ 484, 12_000_000, 222.7990, -1987.9917, 0.2921, 271.9738, TYPE_BOAT, TYPE_COST_CASH}, // 484 3
/*12*/{ 484, 12_000_000, 222.9470, -1996.5627, 0.2851, 269.0756, TYPE_BOAT, TYPE_COST_CASH}, // 484 4
/*13*/{ 493, 10_000_000, 218.1466, -2022.9158, -0.3002, 178.9413, TYPE_BOAT, TYPE_COST_CASH}, // 493 1
/*14*/{ 493, 10_000_000, 224.0269, -2022.5089, -0.3048, 178.8052, TYPE_BOAT, TYPE_COST_CASH}, // 493 2
/*15*/{ 493, 10_000_000, 230.2429, -2022.1046, -0.2431, 178.0156, TYPE_BOAT, TYPE_COST_CASH}, // 493 3
/*16*/{ 493, 10_000_000, 235.8779, -2023.1146, -0.2286, 180.9658, TYPE_BOAT, TYPE_COST_CASH}, // 493 4
/*17*/{ 493, 10_000_000, 241.7736, -2022.7971, 0.0049, 179.1997, TYPE_BOAT, TYPE_COST_CASH}, // 493 5
/*18*/{ 493, 10_000_000, 247.4518, -2022.7628, -0.2725, 178.6040, TYPE_BOAT, TYPE_COST_CASH}, // 493 6 
// Donate car

/*19*/{ 539, 1_000,  892.2695, -1669.7184, 12.8383, 0.3305, TYPE_CAR, TYPE_COST_POINT},
/*20*/{ 539, 1_000,  888.0304, -1669.6632, 12.8344, 355.2601, TYPE_CAR, TYPE_COST_POINT},
/*23*/{ 568, 1_500,  883.8177, -1677.8239, 13.3810, 180.8632, TYPE_CAR, TYPE_COST_POINT},
/*24*/{ 568, 1_500,  879.5457, -1677.4441, 13.3833, 176.0302, TYPE_CAR, TYPE_COST_POINT},
/*25*/{ 490, 5_000,  883.3123, -1668.3689, 13.6120, 1.6414, TYPE_CAR, TYPE_COST_POINT},
/*26*/{ 490, 5_000,  879.2552, -1668.8756, 13.6355, 355.5956, TYPE_CAR, TYPE_COST_POINT},
/*27*/{ 490, 5_000,  874.2698, -1668.9323, 13.6017, 1.5703, TYPE_CAR, TYPE_COST_POINT},
/*28*/{ 482, 3_000,  869.9842, -1678.3037, 13.6522, 176.8060, TYPE_CAR, TYPE_COST_POINT},
/*29*/{ 482, 3_000,  874.3675, -1678.2871, 13.6681, 181.6108, TYPE_CAR, TYPE_COST_POINT},
/*30*/{ 482, 3_000,  869.4102, -1669.3617, 13.5425, 1.3979, TYPE_CAR, TYPE_COST_POINT},
/*31*/{ 457, 1_000,  883.3937, -1657.6278, 13.2002, 176.9134, TYPE_CAR, TYPE_COST_POINT},
/*32*/{ 457, 1_000,  878.7866, -1657.8595, 13.1796, 178.7871, TYPE_CAR, TYPE_COST_POINT},
/*33*/{ 573, 3_000,  870.3304, -1658.4390, 14.1419, 174.4894, TYPE_CAR, TYPE_COST_POINT},
/*34*/{ 573, 3_000,  892.4070, -1658.4572, 14.1660, 170.7289, TYPE_CAR, TYPE_COST_POINT},
/////// donate car

/*35*/{ 513, 5_000_000, 1307.3752, 1297.0338, 11.5060, 0.0000, TYPE_PLANE, TYPE_COST_CASH},
/*36*/{ 513, 5_000_000, 1319.2025, 1296.8568, 11.5060, 0.0000, TYPE_PLANE, TYPE_COST_CASH},
/*37*/{ 513, 5_000_000, 1330.9257, 1296.6975, 11.5060, 0.0000, TYPE_PLANE, TYPE_COST_CASH},
/*38*/{ 513, 5_000_000, 1342.6641, 1296.6387, 11.5060, 0.0000, TYPE_PLANE, TYPE_COST_CASH},
/*39*/{ 519, 30_000_000, 1303.8342, 1324.3270, 11.8275, -91.0000, TYPE_PLANE, TYPE_COST_CASH},
/*40*/{ 519, 30_000_000, 1303.8143, 1360.8373, 11.8275, -91.0000, TYPE_PLANE, TYPE_COST_CASH},
/*41*/{ 553, 25_000_000, 1477.3003, 1208.1685, 12.8300, 0.0000, TYPE_PLANE, TYPE_COST_CASH},
/*42*/{ 511, 20_000_000, 1362.0455, 1257.0104, 12.2339, 0.0000, TYPE_PLANE, TYPE_COST_CASH},
/*43*/{ 511, 20_000_000, 1361.9176, 1276.2686, 12.2339, 0.0000, TYPE_PLANE, TYPE_COST_CASH},
/*44*/{ 511, 20_000_000, 1361.8977, 1295.2477, 12.2339, 0.0000, TYPE_PLANE, TYPE_COST_CASH},
/*45*/{ 487, 14_000_000, 1299.1617, 1395.2688, 10.9523, 178.0000, TYPE_PLANE, TYPE_COST_CASH},
/*46*/{ 487, 14_000_000, 1314.5222, 1394.7227, 10.9523, 178.0000, TYPE_PLANE, TYPE_COST_CASH},
/*47*/{ 487, 14_000_000, 1330.0029, 1394.2371, 10.9523, 178.0000, TYPE_PLANE, TYPE_COST_CASH},
/*48*/{ 487, 14_000_000, 1345.2806, 1393.9158, 10.9523, 178.0000, TYPE_PLANE, TYPE_COST_CASH},
/*49*/{ 469, 10_000_000, 1293.2953, 1302.3335, 10.6888, -91.0000, TYPE_PLANE, TYPE_COST_CASH},
/*50*/{ 469, 10_000_000, 1293.0278, 1288.1514, 10.6888, -91.0000, TYPE_PLANE, TYPE_COST_CASH},
/*51*/{ 469, 10_000_000, 1292.7169, 1273.0123, 10.6888, -91.0000, TYPE_PLANE, TYPE_COST_CASH},
/*52*/{ 487, 14_000_000, 1284.7715, 1384.6254, 11.5324, -120.0000, TYPE_PLANE, TYPE_COST_CASH},
/*53*/{ 487, 14_000_000, 1361.3309, 1388.1471, 11.5266, 135.0000, TYPE_PLANE, TYPE_COST_CASH} 
};

new
	vehicleNameBreak[][] = {"Сток", "NK", "TRW", "Akebono", "Bremdo"},
	vehicleNameEngine[][] = {"Сток", "Классическая", "Твинскрольная", "Twin Turbo", "Twin N-Power"},
	vehicleNameArmour[][] = {"Стандартный", "Средний", "Улучшенный", "Максимальный"},
	vehicleNameBrend[] = {"Нет", "Supreme", "ADIDAS", "LEVIS", "BALENCIAGA"};
new	
	Float: vehicleCountArmour[] = {1000.0, 1500.0, 2000.0, 3000.0},
	Float: engine1_ptune_boost[5] = {3.3, 4.5, 5.7, 6.0, 7.5},
	Float: brake_name_boost[5] = {1.0, 2.0, 2.0, 3.0, 4.0};//Буст

static const Float: NewFinePosition[][4] = {
	{1803.1868, -1085.6481, 23.6880, 0.1903}, // 
	{1798.8336, -1085.6481, 23.6880, 0.1903}, // 
	{1794.5837, -1085.6481, 23.6880, 0.1903}, // 
	{1789.8945, -1085.6481, 23.6880, 0.1903}, // 
	{1785.3450, -1085.6481, 23.6880, 0.1903}, // 
	{1781.0298, -1085.6481, 23.6880, 0.1903}, // 
	{1776.5750, -1085.6481, 23.6880, 0.1903}, // 
	{1772.0054, -1085.6481, 23.6880, 0.1903}, // 
	{1767.5193, -1085.6481, 23.6880, 0.1903}, // 
	{1762.5836, -1085.6481, 23.6880, 0.1903}, // 
	{1758.0876, -1085.6481, 23.6880, 0.1903}, // 
	{1753.6057, -1085.6481, 23.6880, 0.1903}, // 
	{1749.0914, -1085.6481, 23.6880, 0.1903}, // 
	{1744.6093, -1085.6481, 23.6880, 0.1903}, // 
	{1740.1869, -1085.6481, 23.6880, 0.1903}, // 
	{1735.6257, -1085.6481, 23.6880, 0.1903}, // 
	{1731.1973, -1085.6481, 23.6875, 0.1903}, // 
	{1726.5522, -1085.6481, 23.6668, 0.1903}, // 
	{1793.5072, -1070.2399, 23.6880, 180.0}, // 
	{1788.8577, -1070.2399, 23.6880, 180.0}, // 
	{1784.4664, -1070.2399, 23.6880, 180.0}, // 
	{1779.9585, -1070.2399, 23.6880, 180.0}, // 
	{1775.5474, -1070.2399, 23.6880, 180.0}, // 
	{1771.2174, -1070.2399, 23.6880, 180.0}, // 
	{1766.5308, -1070.2399, 23.6880, 180.0}, // 
	{1761.9305, -1070.2399, 23.6880, 180.0}, // 
	{1762.0372,-1061.6488,23.6880,1.0260}, // 
	{1766.4536,-1061.5697,23.6880,1.0260}, // 
	{1770.8583,-1061.4908,23.6880,1.0260}, // 
	{1775.3185,-1061.8344,23.6880,359.4818}, // 
	{1780.0116,-1061.8766,23.6880,359.4818}, // 
	{1784.2495,-1061.9144,23.6880,359.4818}, // 
	{1788.8188,-1061.9553,23.6880,359.4818}, // 
	{1793.3282,-1061.9957,23.6880,359.4819}, // 
	{1761.9716,-1046.5172,23.6880,182.0139}, // 
	{1757.5522,-1046.6726,23.6880,182.0139}, // 
	{1753.1661,-1046.8275,23.6880,182.0139}, // 
	{1748.6832,-1046.9849,23.6880,182.0139}, // 
	{1744.2640,-1047.1407,23.6880,182.0139}, // 
	{1743.9480,-1037.2480,23.6880,358.2781}, // 
	{1748.6136,-1037.7189,23.6880,358.2781}, // 
	{1753.0831,-1037.8535,23.6880,358.2781}, // 
	{1757.3176,-1037.9812,23.6880,358.2781}, // 
	{1761.8497,-1038.1173,23.6880,358.2781} // 
}; 
#define MAX_FINE_POSITION	sizeof (NewFinePosition)

new 
	bool: NewFinePositionSlots[MAX_FINE_POSITION] = {false, ...};	

new Float: non_parking_pos[][4] =
{
	{ 1426.5, -1747.0, 1540.5, -1729.0}, // Мэрия   
	{ 520.5, -1317.5, 584.5, -1265.5 },
	{ -2596.7688, 477.8199, -2536.7046, 553.7369 },
	{ 2556.9045, 1382.9697, 2617.9646, 1463.2864 },
	{ 2440.7141,-1565.0212, 2497.6780, -1513.7098 },
	{ 2614.5276,-2562.1785, 2812.3604,-2335.2041 },
	{ -1130.7028, -1759.6340, -941.0256, -1604.3983 },
	{ 1569.4181,-2368.1838, 1807.1868,-2231.6548 },
	{ 922.0099, -1390.3119, 1048.7323, -1332.7876 },
	{ -2095.7939,-280.0992, -2011.8822,-102.9060 },
	{ 1131.9663, -1388.0736, 1216.4728, -1289.8777},
	{ -2740.4875, 576.2866, -2602.3850, 697.5250 },
	{ 1577.0034, 1722.7375, 1637.7700, 1867.1422 },
	{ 1894.0317, 983.2147, 2055.6013, 1082.2726 },
	{ 2087.0618,1383.3145,2236.8276,1448.2604},
	{ -1997.5977,219.6909,-1885.6005,310.1315}, 
	{ 1622.13987,-1052.5920, 1660.242,-1029.3}//Штрафстоянка 
};
#define MAX_NONPARKING_ZONES 	sizeof (non_parking_pos)//18
new non_parking_area[MAX_NONPARKING_ZONES];
new is_player_nonpark_zone[ MAX_PLAYERS char ];
#define PLAYER_JOB_BUS  			1
#define TYPE_ROUTE_BUS_0  		1
#define TYPE_ROUTE_BUS_1  		2
#define TYPE_ROUTE_BUS_2  		3
#define TYPE_ROUTE_BUS_3  		4

#define PLAYER_JOB_TAXI  			2
#define TAXI_SKILL_0    		0
#define TAXI_SKILL_1    		5
#define TAXI_SKILL_2    		10

#define PLAYER_JOB_HOTDOG_SALLER    3
#define PLAYER_JOB_MECHANIC 		4

#define PLAYER_JOB_DELIVERY  		5
#define DELIVERY_TYPE_0   		0
#define DELIVERY_TYPE_1   		1
#define DELIVERY_TYPE_2   		2
#define DELIVERY_TYPE_3   		3
#define DELIVERY_TYPE_4   		4

#define PLAYER_JOB_TRUCKER  		7
#define TRUCKER_SKILL_0   		0
#define TRUCKER_SKILL_1   		25

#define PLAYER_JOB_COLLECTOR  		8
#define PLAYER_JOB_HUNTER			9

#define RENT_CAR_SANTA_MARIA    0
#define RENT_CAR_SAN_FIERO    	1
#define RENT_CAR_LOS_SANTOS     2
#define RENT_CAR_LAS_VETURAS    3
#define RENT_CAR_FAGGIO    		4
#define RENT_CAR_BOAT           5
#define RENT_CAR_FAGGIO_THEFT  	6

#define VEHICLE_TYPE_FRACTION		1
#define VEHICLE_TYPE_JOB            2
#define VEHICLE_TYPE_RENTCAR        3
#define VEHICLE_TYPE_PLAYER			4
#define VEHICLE_TYPE_JOB_FARM       5
#define VEHICLE_TYPE_DYNAMIC        6
#define VEHICLE_TYPE_FAMILY			7
#define VEHICLE_TYPE_BUSINESS		8

#define DYNAMIC_VEH_ADMINS  	1
#define DYNAMIC_VEH_MATS		2
#define DYNAMIC_VEH_ROB_HOUSE	3


//VehicleInfo[ pTemp[playerid][tRobVeh] - 1][vType] = VEHICLE_TYPE_DYNAMIC;
			//VehicleInfo[ pTemp[playerid][tRobVeh] - 1][vFraction] = DYNAMIC_VEH_ROB_HOUSE;



#define F_VEHICLE_FARM_0  1
#define F_VEHICLE_FARM_1  2
#define F_VEHICLE_FARM_2  3
#define F_VEHICLE_FARM_3  4
#define F_VEHICLE_FARM_4  5

#define F_VEHILE_FARM_SEEDCAR   1
#define F_VEHILE_FARM_COMBINE   2

new player_holding_key_down[MAX_PLAYERS];

enum E_VEHICLE_SERVER
{
    vVehicle, //CreateVehicke
	vID,
	vDriverID, 
	vType, // Тип машин
	vModel,
	vTempModel,
	vTimeModel,
	Float: vPos[4],
	Float: vNewPos[4],
	vInt,
	vWorld,
	vColor[2],
	vPaint,
	Float: vVelocity[2],
	Float: vHealth,
	Float: vFuel,
	Float: vMillage,
	Float: vTempMillage,
	vNumber[12],
	vFraction,
	vSubFraction,
	vRank, //Для Фракционых машин
	bool: vLocked,
	bool: vEngBreaked, 
	Float: vOldZAngle,
	
	vPT_Engine[5],
	vPT_Brake[5],
	vPT_Stability[5],
	vComponent[10],
	
	vSellSlot,
	vSellCost,
	vSellCarMarket,
	vTypeCost,
	vTax,
	Text3D:	vSellText,
	Text3D: vText,
	Text3D: vFarmText,
	vFine,
	vFineSlots,

	vJobAmount[2],
	vJobMaterials,
	vJobPickup,
	vJobArea,
	bool: vJobLoad,

	//vStatus,
	vCost,
	vLockBag,
    vRepair,
	vFillBag,
    vMoney,
    vDrugs,
    vMaterials,
    vBootGun[6],
	vBootAmmo[6],

	bool: vClearAnimation,
	vJacker,
	bool: vJackerOff,
	id_arender_truck, 
	v_object[12]
}

new VehicleInfo[MAX_VEHICLES][E_VEHICLE_SERVER], S_VEHICLE_COUNT = 0;


enum 
{
	VEHICLE_STATE_ERROR,// Авто для просмотра передпокупкой
    VEHICLE_STATE_TRAILER, // трейлер
	VEHICLE_STATE_TRAIN, // поезд
	VEHICLE_STATE_LOW_BIKE, // велики
    VEHICLE_STATE_BOAT, // яхты
    VEHICLE_STATE_PLANE, // самалеты / вертолёты
    VEHICLE_STATE_BIKE, // мотоциклы мопед
	VEHICLE_RADIO_REMOTE, // RC VEHICLE
    VEHICLE_STATE_CAR // авто
}
new VehicleState[MAX_VEHICLES];

stock n_ChangeVehicleColor(vehicleID, color1, color2)
{
	VehicleInfo[ vehicleID - 1 ][vColor][0] = color1;
	VehicleInfo[ vehicleID - 1 ][vColor][1] = color2;
	return ChangeVehicleColor(vehicleID, color1, color2);
}

stock GetVehicleColor(vehicleID, &color1, &color2)
{
	color1 = VehicleInfo[ vehicleID - 1 ][vColor][0];
	color2 = VehicleInfo[ vehicleID - 1 ][vColor][1];
	return 1;
}



stock GetVehicleBag(vehicleid)
{
	new slots;
	switch(GetVehicleModel(vehicleid))
	{
		case 400,444,458,556,557: slots = 9;
		case 401,402,429,412,410,439,518,533,536,546,549,575,585,593: slots = 5;
		case 403,477,481,484 .. 486,493,494,501 .. 504,509 .. 515,581,520 .. 524,604,605,586,587,588,525,583,584,530 .. 532,537 .. 539,544,552,564,568 .. 574,577,578: slots = 0;
		case 404: slots = 11;
		case 405,442: slots = 7;
		case 406,407,408,417,411,423,424,425,430,431,432,435,437,441,443,446,447,449,450,452,453,454,460,461 .. 465,468,469,471 .. 473,476,590,591,594,595,606 .. 608,610,611: slots = 0;
		case 409,470,478,479,495,505,528,535,543,600: slots = 8;
		case 413: slots = 15;
		case 414: slots = 18;
		case 415,451,500,506,541,555: slots = 3;
		case 418: slots = 12;
		case 419,420,426,436,445,466,467,474,475,480,491,492,496,507,516,529,534,542,547,550,551,560,562,566,567,576,596 .. 598: slots = 6;
		case 421,438,517,561,579,580: slots = 7;
		case 422,489,490,599,601,416: slots = 10;
		case 427,428,440,482,483,498,499,508,553,609: slots = 16;
		case 433,455,456,519,548,592: slots = 18;
		case 434,487,488,497,526,527,540,545,558,559,565,589,602,603: slots = 4;
		case 448,457: slots = 1;
		case 459,582: slots = 14;
		case 554,563: slots = 12;
	}
	return slots;
}
stock GetCoordBonnetVehicle(vehicleid, &Float:x, &Float:y, &Float:z) {
	new Float:angle,Float:distance;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), 1, x, distance, z);
	distance = distance/2 + 0.1;
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);
	x -= (distance * floatsin(-angle+180, degrees));
	y -= (distance * floatcos(-angle+180, degrees));
	return 1;
} 
stock GetCoordBootVehicle(vehicleid, &Float:x, &Float:y, &Float:z) {
	new Float:angle,Float:distance;
	GetVehicleModelInfo(GetVehicleModel(vehicleid), 1, x, distance, z);
	distance = distance/2 + 0.1;
	GetVehiclePos(vehicleid, x, y, z);
	GetVehicleZAngle(vehicleid, angle);
	x += (distance * floatsin(-angle+180, degrees));
	y += (distance * floatcos(-angle+180, degrees));
	return 1;
}
stock ChangeVehicleState(vehicleid, modelid, state_vehicle = 0)
{
	if (vehicleid == INVALID_VEHICLE_ID) return 0;
	switch(modelid)
	{
		case 0: VehicleState[vehicleid] = state_vehicle;
		case 430, 446, 452, 453, 454, 472, 473, 484, 493,595: VehicleState[vehicleid] = VEHICLE_STATE_BOAT;
		case 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553,
			563, 577, 592, 593:  VehicleState[vehicleid] = VEHICLE_STATE_PLANE;
		case 448, 461, /*462,*/ 463, 468 ,471, 521, 522, 523, 581, 586: VehicleState[vehicleid] = VEHICLE_STATE_BIKE;
		case 462, 481, 509, 510: VehicleState[vehicleid] = VEHICLE_STATE_LOW_BIKE;
		case 449, 538, 537: VehicleState[vehicleid] = VEHICLE_STATE_TRAIN;
		case 435,450,569,570,584,590,591,606,607,608,610,611:  VehicleState[vehicleid] = VEHICLE_STATE_TRAILER;
		case 441, 464, 465, 501, 564: VehicleState[vehicleid] = VEHICLE_RADIO_REMOTE;
		default: VehicleState[vehicleid] = VEHICLE_STATE_CAR;
	}
	return vehicleid;
}
stock IsAnAmbulance(vehicleid)
{
	if (vehicleid == INVALID_VEHICLE_ID) return 0;
	else if (VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_FRACTION &&
		( VehicleInfo[ vehicleid - 1 ][vFraction] == 4 || VehicleInfo[ vehicleid - 1 ][vFraction] == 22 || VehicleInfo[ vehicleid - 1 ][vFraction] == 23 )) return 1;
	return 0;
}


stock GetVehicleState(vehicleid) return VehicleState[vehicleid];
stock _SetVehicleHealth(vehicleid, Float: health)
{
	VehicleInfo[ vehicleid - 1 ][vHealth] = health;
	return SetVehicleHealth(vehicleid, health);
}

stock _RepairVehicle(vehicleid)
{
	//_SetVehicleHealth(new_veh_id, vehicleCountArmour[VehicleInfo[ new_veh_id - 1 ][vPT_Engine][1]]);
	/*if (VehicleInfo[ new_veh_id - 1 ][vPT_Engine][1] > 0) {

	} else {

	}*/
	VehicleInfo[ vehicleid - 1 ][vHealth] = 1000.0;
	VehicleInfo[ vehicleid - 1 ][vEngBreaked] = false;
	return RepairVehicle(vehicleid) ;
}

publics: ChangeStatusVehicle(const playerid, const vehicleid)
{
	SetVehicleParamsForPlayer(vehicleid, playerid, 0, VehicleInfo[ vehicleid ][vLocked]);
	return 1;
}
stock GetVehicleIsNoParking(vehicleid)
{
	for(new j ; j < MAX_NONPARKING_ZONES; j ++)
	{
		if (IsVehicleInQuad(
			VehicleInfo[ vehicleid - 1 ][vPos][0], 
			VehicleInfo[ vehicleid - 1 ][vPos][1], 
			non_parking_pos[j][0], non_parking_pos[j][1],
			non_parking_pos[j][2], non_parking_pos[j][3]
		) && VehicleInfo[ vehicleid - 1 ][vFine] == 0/* && VehicleInfo[ vehicleid - 1 ][vJakcer] == 0*/) {
			return 1;
		} else return 0;
	}
	return 0;
}
stock IsVehicleInterior(vehicleid)
{
	switch(VehicleInfo[ vehicleid - 1 ][vModel])
	{
		case 454, 446, 484, 493: return 1;
		case 508: return 2; 
	}
	return 0;
}
stock IsVehicleTypeInterior(vehicleid)
{
	if (vehicleid < 1) return 0;
	switch(VehicleInfo[ vehicleid - 1 ][vModel])
	{
	    case 454, 446, 484, 493: return 1;
	    case 508: return 2;
	}
	return 0;
}
stock GetBoatDoorPos(vehicleid, &Float:x, &Float:y, &Float:z)
{
	new Float:v_angle,
		Float:v_distance_d,
		Float:v_distance_a ;

	switch ( GetVehicleModel ( vehicleid ) )
	{
		case 454:x = -0.6802, y = -2.6828, z = 1.8636 ;//++
		case 446:x = -0.1356, y = 0.9229, z = 3.6700 ;
		case 484:x = -0.0601, y = -1.4653, z = 3.6859 ;
		case 493:x = -0.6802, y = -2.6828, z = 2.8636 ;
		case 508:x = -0.6802, y = -3.6828, z = 0.8636 ;
	}
    x += 0.20 ; 
	v_distance_d = floatsqroot ( ( x * x ) + (y*y));
    v_distance_a = atan2 ( x, y ) ; 
    GetVehicleZAngle ( vehicleid, v_angle );
    GetVehiclePos ( vehicleid, x, y, z ) ;
	x += v_distance_d * floatsin ( v_distance_a - v_angle, degrees ) ;
	y += v_distance_d * floatcos ( v_distance_a - v_angle, degrees ) ;
    return 1 ;
} 
stock _AddStaticVehicle(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2)
{
	new vehicleid = AddStaticVehicle(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2 );
	VehicleInfo[ vehicleid - 1 ][vModel] = modelid;
	VehicleInfo[ vehicleid - 1 ][vColor][0] = color1;
	VehicleInfo[ vehicleid - 1 ][vColor][1] = color2;
	VehicleInfo[ vehicleid - 1 ][vHealth] = 1000.0;
	VehicleInfo[ vehicleid - 1 ][vPaint] = 3;
	VehicleInfo[ vehicleid - 1 ][vEngBreaked] = false;
	ChangeVehicleState(vehicleid, modelid); 
	return vehicleid;
}


stock _AddStaticVehicleEx(modelid, Float:spawn_x, Float:spawn_y, Float:spawn_z, Float:z_angle, color1, color2, respawn_delay, addsiren = 0)
{
	new vehicleid = AddStaticVehicleEx(modelid, spawn_x, spawn_y, spawn_z, z_angle, color1, color2, respawn_delay, addsiren );
	VehicleInfo[ vehicleid - 1 ][vModel] = modelid;
	VehicleInfo[ vehicleid - 1 ][vColor][0] = color1;
	VehicleInfo[ vehicleid - 1 ][vColor][1] = color2;
	VehicleInfo[ vehicleid - 1 ][vHealth] = 1000.0;
	VehicleInfo[ vehicleid - 1 ][vPaint] = 3;
	VehicleInfo[ vehicleid - 1 ][vEngBreaked] = false;
	ChangeVehicleState(vehicleid, modelid); 
	return vehicleid;
} 
stock _CreateVehicle(vehicletype, Float:x, Float:y, Float:z, Float:rotation, color1, color2, respawn_delay, addsiren = 0)
{
	new vehicleid = CreateVehicle(vehicletype, x, y, z, rotation, color1, color2, respawn_delay, addsiren);
	VehicleInfo[ vehicleid - 1 ][vModel] = vehicletype;
	VehicleInfo[ vehicleid - 1 ][vColor][0] = color1;
	VehicleInfo[ vehicleid - 1 ][vColor][1] = color2;
	VehicleInfo[ vehicleid - 1 ][vHealth] = 1000.0;
	VehicleInfo[ vehicleid - 1 ][vPaint] = 3;
	VehicleInfo[ vehicleid - 1 ][vEngBreaked] = false;
	ChangeVehicleState(vehicleid, vehicletype);
	return vehicleid;
}


stock _DestroyVehicle(vehicleid)
{
	ChangeVehicleState(vehicleid, 0, VEHICLE_STATE_ERROR);
    DestroyVehicle(vehicleid); 
	VehicleInfo[ vehicleid - 1 ][vTempModel] 	= 0;
	VehicleInfo[ vehicleid - 1 ][vTimeModel] 	= 0;  
	VehicleInfo[ vehicleid - 1 ][vColor][0] 	= 0;
	VehicleInfo[ vehicleid - 1 ][vColor][1] 	= 0;
	VehicleInfo[ vehicleid - 1 ][vType] 		= 0;
	VehicleInfo[ vehicleid - 1 ][vVehicle] 		= INVALID_VEHICLE_ID;
	VehicleInfo[ vehicleid - 1 ][vFraction] 	= 0;
	VehicleInfo[ vehicleid - 1 ][vSubFraction] 	= 0;
	VehicleInfo[ vehicleid - 1 ][vMillage] 		= 0.0;
	VehicleInfo[ vehicleid - 1 ][vTempMillage] 	= 0.0;
	VehicleInfo[ vehicleid - 1 ][vHealth] 		= 0.0;
	VehicleInfo[ vehicleid - 1 ][vEngBreaked] 	= false;
	VehicleInfo[ vehicleid - 1 ][vPaint] 		= 3; 


	VehicleInfo[ vehicleid - 1 ][vSellCost] 	= 0;
	VehicleInfo[ vehicleid - 1 ][vSellSlot] 	= 0;
	VehicleInfo[ vehicleid - 1 ][vSellCarMarket] = 0;
	VehicleInfo[ vehicleid - 1 ][vTypeCost] 	= 0;

	VehicleInfo[ vehicleid - 1 ][vTax] 			= 0;

	VehicleInfo[ vehicleid - 1 ][vFine] = 0; 
	/*if (VehicleInfo[ vehicleid - 1 ][vFineSlots] != -1) {
		NewFinePositionSlots[ VehicleInfo[ vehicleid - 1 ][vFineSlots] ] = false;
		VehicleInfo[ vehicleid - 1 ][vFineSlots] = -1;
	}*/

	VehicleInfo[ vehicleid - 1 ][vPos][0] 		= 0.0;
	VehicleInfo[ vehicleid - 1 ][vPos][1] 		= 0.0;
	VehicleInfo[ vehicleid - 1 ][vPos][2] 		= 0.0;

	for ( new i ; i < 5 ; i ++ ) {
		VehicleInfo[ vehicleid - 1 ][vPT_Engine][i] = 0;
		VehicleInfo[ vehicleid - 1 ][vPT_Brake][i] = 0;
		VehicleInfo[ vehicleid - 1 ][vPT_Stability][i] = 0;
	}
	if (VehicleInfo[ vehicleid - 1 ][vSellText] != Text3D:-1) {
		DestroyDynamic3DTextLabel(VehicleInfo[ vehicleid - 1 ][vSellText]);
		VehicleInfo[ vehicleid - 1 ][vSellText] = Text3D:-1;
	} 
	if (VehicleInfo[ vehicleid - 1 ][vText] != Text3D:-1) {
		DestroyDynamic3DTextLabel(VehicleInfo[ vehicleid - 1 ][vText]);
		VehicleInfo[ vehicleid - 1 ][vText] = Text3D:-1;
	}

	if (VehicleInfo[ vehicleid - 1 ][vFarmText] != Text3D:-1) {
		DestroyDynamic3DTextLabel(VehicleInfo[ vehicleid - 1 ][vFarmText]);
		VehicleInfo[ vehicleid - 1 ][vFarmText] = Text3D:-1;
	}

	for ( new i = 0 ; i < 10 ; i ++ ) {
		VehicleInfo[ vehicleid - 1 ][vComponent][i] = 0;
	}
	return 1;
} 

Vehicle_OnGameModeInit() {
    mysql_tquery( 
        dbHandle, "SELECT * FROM "TABLE_VEHICLE_SERVER"", #OnLoadVehicleServer\
    );
/*	mysql_tquery( //vID, vTax, vOwner
        dbHandle, "SELECT * FROM "TABLE_VEHICLE_PLAYER" WHERE `vFine` > '0'", #OnGiveTaxFineVehiclePlayer\
    );*/
    mysql_tquery( 
        dbHandle, "SELECT * FROM "TABLE_VEHICLE_PLAYER" WHERE `vSellCost` > '0'", #OnLoadVehiclePlayer\
    );
    return;
}   

publics: OnLoadVehicleServer() {
    new
        time = GetTickCount(),
        RESPAWN_CAR_TIME = 1800;
    cache_get_row_count(S_VEHICLE_COUNT);
    if (!S_VEHICLE_COUNT) {
        print(!"[Загрузка ...] Данные из Vehicle Server не получены!");
        return true;
    }
    for (new V_IDX = 0, colors_mass[10], position_mass[128]; V_IDX < S_VEHICLE_COUNT; V_IDX++)
    {
        cache_get_value_name_int(V_IDX, "vID", VehicleInfo[V_IDX][vID]);
        cache_get_value_name_int(V_IDX, "vType", VehicleInfo[V_IDX][vType]);
        cache_get_value_name_int(V_IDX, "vModel", VehicleInfo[V_IDX][vModel]);
        cache_get_value_name_int(V_IDX, "vTempModel", VehicleInfo[V_IDX][vTempModel]);
        cache_get_value_name_int(V_IDX, "vTimeModel", VehicleInfo[V_IDX][vTimeModel]); 

        cache_get_value_name(V_IDX, "vPos", position_mass, 128);
        sscanf(position_mass,"p<|>a<f>[4]", VehicleInfo[V_IDX][vPos]);
        
        cache_get_value_name_int(V_IDX, "vInt", VehicleInfo[V_IDX][vInt]);
        cache_get_value_name_int(V_IDX, "vWorld", VehicleInfo[V_IDX][vWorld]);
        
        cache_get_value_name(V_IDX, "vColor", colors_mass, 10);
        sscanf(colors_mass, "p<,>a<d>[2]", VehicleInfo[V_IDX][vColor]);

        cache_get_value_name(V_IDX, "vNumber", VehicleInfo[V_IDX][vNumber], 12);
        cache_get_value_name_int(V_IDX, "vFraction", VehicleInfo[V_IDX][vFraction]);
        cache_get_value_name_int(V_IDX, "vSubFraction", VehicleInfo[V_IDX][vSubFraction]);
        cache_get_value_name_int(V_IDX, "vRank", VehicleInfo[V_IDX][vRank]);
        //cache_get_value_name_int(V_IDX, "vStatus", VehicleInfo[V_IDX][vStatus]);
        cache_get_value_name_int(V_IDX, "vCost", VehicleInfo[V_IDX][vCost]);
        cache_get_value_name_int(V_IDX, "vRepair", VehicleInfo[V_IDX][vRepair]);
        cache_get_value_name_int(V_IDX, "vFillBag", VehicleInfo[V_IDX][vFillBag]);
        cache_get_value_name_int(V_IDX, "vMoney", VehicleInfo[V_IDX][vMoney]);
        cache_get_value_name_int(V_IDX, "vDrugs", VehicleInfo[V_IDX][vDrugs]);
        cache_get_value_name_int(V_IDX, "vMaterials", VehicleInfo[V_IDX][vMaterials]);
        
        new
            bootg_mass[32],
            boota_mass[32];
            
        cache_get_value_name(V_IDX, "vGun", bootg_mass, 32);
        sscanf(bootg_mass, "p<,>a<d>[6]", VehicleInfo[V_IDX][vBootGun]);
        cache_get_value_name(V_IDX, "vAmmo", boota_mass, 32);
        sscanf(boota_mass, "p<,>a<d>[6]", VehicleInfo[V_IDX][vBootAmmo]);
        
        VehicleInfo[V_IDX][vMillage] = 0.0;
        VehicleInfo[V_IDX][vTempMillage] = 0.0;
        VehicleInfo[V_IDX][vHealth] = 1000.0;
        VehicleInfo[V_IDX][vFuel] = GetModelMaxFuel(VehicleInfo[ V_IDX ][vModel]);
        VehicleInfo[V_IDX][vLocked] = false;
        VehicleInfo[V_IDX][vEngBreaked] = false;

        if (VehicleInfo[V_IDX][vType] == VEHICLE_TYPE_JOB_FARM) RESPAWN_CAR_TIME = -1;//7200 - 2 hour//86400 - 24 hour
		else if (VehicleInfo[V_IDX][vType] == VEHICLE_TYPE_JOB && VehicleInfo[V_IDX][vFraction] == PLAYER_JOB_HUNTER) {
			RESPAWN_CAR_TIME = -1;
			//print("hunter car -1");
		}
        else RESPAWN_CAR_TIME = 1800; 

        new status_model; 

        if (VehicleInfo[V_IDX][vTempModel] != 0)
        {
            if (VehicleInfo[V_IDX][vTimeModel] < gettime())
            {
                VehicleInfo[V_IDX][vTempModel] = 0;
                VehicleInfo[V_IDX][vTimeModel] = 0;
                SaveFractionVehicleServer(V_IDX);
                printf("Clear vehicle: %d",VehicleInfo[V_IDX][vID]);
            }
            else {
                status_model = 1;
            }
            
        }
        new siren_car;
        if (IsGosVehicle(V_IDX)) siren_car = 1;

        VehicleInfo[V_IDX][vVehicle] =
        _CreateVehicle( status_model == 1? VehicleInfo[V_IDX][vTempModel] : VehicleInfo[V_IDX][vModel], 
            VehicleInfo[V_IDX][vPos][0], VehicleInfo[V_IDX][vPos][1], 
            VehicleInfo[V_IDX][vPos][2], VehicleInfo[V_IDX][vPos][3], 
            VehicleInfo[V_IDX][vColor][0], VehicleInfo[V_IDX][vColor][1], RESPAWN_CAR_TIME,siren_car
        );
		if (VehicleInfo[V_IDX][vType] == VEHICLE_TYPE_JOB)
		{ 
			if (VehicleInfo[V_IDX][vFraction] == PLAYER_JOB_COLLECTOR)
			{
				_SetVehicleHealth(VehicleInfo[V_IDX][vVehicle], 3000.0);
			}
			if (VehicleInfo[V_IDX][vFraction] == PLAYER_JOB_HUNTER) {
				_SetVehicleHealth(VehicleInfo[V_IDX][vVehicle], 3000.0);
			}
		}

        LinkVehicleToInterior(VehicleInfo[V_IDX][vVehicle], VehicleInfo[V_IDX][vInt]);
        SetVehicleVirtualWorld(VehicleInfo[V_IDX][vVehicle], VehicleInfo[V_IDX][vWorld]);
        SetVehicleNumberPlate(VehicleInfo[V_IDX][vVehicle], VehicleInfo[V_IDX][vNumber]);
        //type ==VEHICLE_TYPE_JOB_FARM

        AttachJobVehicleObjects(V_IDX,0); 
        VehicleBlinkStatus[ VehicleInfo[V_IDX][vVehicle] ] = false;
    }
    printf("[Загрузка ...] Данные из s_vehicle_server получены! (%d шт.) Время: %d", S_VEHICLE_COUNT, GetTickCount() - time);
    return 1;
}

publics: OnUpdateVehicleServer()
{
	new rows,
		RESPAWN_CAR_TIME = 1800;
	cache_get_row_count(rows);
	if (rows)
	{
		for(new i = 0; i < rows ; i++)
		{
		    new V_IDX = GetVehicleID();

			cache_get_value_name_int(i, "vID", VehicleInfo[ V_IDX - 1 ][vID]);
			cache_get_value_name_int(i, "vType", VehicleInfo[ V_IDX - 1 ][vType]);
			cache_get_value_name_int(i, "vModel", VehicleInfo[ V_IDX - 1 ][vModel]);
			cache_get_value_name_int(i, "vTempModel", VehicleInfo[ V_IDX - 1 ][vTempModel]);
			cache_get_value_name_int(i, "vTimeModel", VehicleInfo[ V_IDX - 1 ][vTimeModel]);

			new
				colors_mass[10], position_mass[128];
			
			cache_get_value_name(i, "vPos", position_mass, 128);
			sscanf(position_mass,"p<|>a<f>[4]", VehicleInfo[ V_IDX - 1 ][vPos]);
			
			cache_get_value_name_int(i, "vInt", VehicleInfo[ V_IDX - 1 ][vInt]);
			cache_get_value_name_int(i, "vWorld", VehicleInfo[ V_IDX - 1 ][vWorld]);
			
			cache_get_value_name(i, "vColor", colors_mass, 10);
			sscanf(colors_mass, "p<,>a<d>[2]", VehicleInfo[ V_IDX - 1 ][vColor]);

			cache_get_value_name(i, "vNumber", VehicleInfo[ V_IDX - 1 ][vNumber], 12);
			cache_get_value_name_int(i, "vFraction", VehicleInfo[ V_IDX - 1 ][vFraction]);
			cache_get_value_name_int(i, "vSubFraction", VehicleInfo[ V_IDX - 1 ][vSubFraction]);
			cache_get_value_name_int(i, "vRank", VehicleInfo[ V_IDX - 1 ][vRank]);
			//cache_get_value_name_int(i, "vStatus", VehicleInfo[ V_IDX - 1 ][vStatus]);
			cache_get_value_name_int(i, "vCost", VehicleInfo[ V_IDX - 1 ][vCost]);

			cache_get_value_name_int(i, "vRepair", VehicleInfo[ V_IDX - 1 ][vRepair]);
			cache_get_value_name_int(i, "vFillBag", VehicleInfo[ V_IDX - 1 ][vFillBag]);
			cache_get_value_name_int(i, "vMoney", VehicleInfo[ V_IDX - 1 ][vMoney]);
			cache_get_value_name_int(i, "vDrugs", VehicleInfo[ V_IDX - 1 ][vDrugs]);
			cache_get_value_name_int(i, "vMaterials", VehicleInfo[ V_IDX - 1 ][vMaterials]);
			
			new
				bootg_mass[32],
				boota_mass[32];
				
			cache_get_value_name(i, "vGun", bootg_mass, 32);
			sscanf(bootg_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootGun]);
			cache_get_value_name(i, "vAmmo", boota_mass, 32);
			sscanf(boota_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootAmmo]);
			
			VehicleInfo[ V_IDX - 1 ][vMillage] = 0.0;
			VehicleInfo[ V_IDX - 1 ][vTempMillage] = 0.0;
			VehicleInfo[ V_IDX - 1 ][vHealth] = 1000.0;
			VehicleInfo[ V_IDX - 1 ][vFuel] = GetModelMaxFuel(VehicleInfo[ V_IDX - 1 ][vModel]);
			VehicleInfo[ V_IDX - 1 ][vLocked] = false;
			VehicleInfo[ V_IDX - 1 ][vEngBreaked] = false;
			if (VehicleInfo[ V_IDX - 1 ][vType] == VEHICLE_TYPE_JOB_FARM) RESPAWN_CAR_TIME = -1;//7200 - 2 hour//86400 - 24 hour
				else RESPAWN_CAR_TIME = 1800;
				if (VehicleInfo[ V_IDX - 1 ][vTempModel] != 0)
				{
					VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vTempModel], VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], 
						VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
						VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], RESPAWN_CAR_TIME
					);
				}
				else
				{
					VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], 
						VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
						VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], RESPAWN_CAR_TIME
					);
				} 
	            LinkVehicleToInterior(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vInt]);
	            SetVehicleVirtualWorld(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vWorld]);
	            SetVehicleNumberPlate(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vNumber]);

			VehicleInfo[ V_IDX - 1 ][vLocked] = false;
			GetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
			SetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, false, bonnet2, boot1, objective1);
 
			VehicleBlinkStatus[ VehicleInfo[V_IDX - 1][vVehicle] ] = false;

			printf("UPDATE FRACTION CAR LOAD: %d, ", VehicleInfo[ V_IDX - 1 ][vID]);

		}
	}
	return 1;
}
publics: OnLoadVehiclePlayer() {
    new 
        time = GetTickCount(),
        rows;
    cache_get_row_count(rows);
    if (!rows) return print("[Загрузка ...] Данные из Vehicle Player не получены!");
    else
    {
        for(new i = 0, colors_mass[10], position_mass[128], date_mass[126]; i < rows ; i++)
        {
            new V_IDX = GetVehicleID(); 
            VehicleInfo[ V_IDX - 1 ] [vType] = VEHICLE_TYPE_PLAYER;

            cache_get_value_name_int(i, "vID", VehicleInfo[ V_IDX - 1 ][vID]);
            cache_get_value_name_int(i, "vModel", VehicleInfo[ V_IDX - 1 ][vModel]);
            cache_get_value_name_int(i, "vOwner", VehicleInfo[ V_IDX - 1 ][vFraction]); 

            cache_get_value_name(i, "vColor", colors_mass, 10);
            sscanf(colors_mass, "p<|>a<d>[2]", VehicleInfo[ V_IDX - 1 ][vColor]);
            
            cache_get_value_name(i, "vNumber", VehicleInfo[ V_IDX - 1 ][vNumber], 12); 
            cache_get_value_name_float(i, "vFuel", VehicleInfo[ V_IDX - 1 ][vFuel]); 
            cache_get_value_name_float(i, "vMillage", VehicleInfo[ V_IDX - 1 ][vMillage]);

            VehicleInfo[ V_IDX - 1 ][vSubFraction] = 0;
            VehicleInfo[ V_IDX - 1 ][vRank] = 0;
            VehicleInfo[ V_IDX - 1 ][vJacker] = 0;
            VehicleInfo[ V_IDX - 1 ][vJackerOff] = false;

            cache_get_value_name(i, "vPos", position_mass, 128);
            sscanf(position_mass,"p<|>a<f>[4]", VehicleInfo[ V_IDX - 1 ][vPos]); 

            cache_get_value_name(i, "vPT_Engine", date_mass, 16);
            sscanf(date_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Engine][0], VehicleInfo[ V_IDX - 1 ][vPT_Engine][1],
            VehicleInfo[ V_IDX - 1][vPT_Engine][2], VehicleInfo[ V_IDX - 1 ][vPT_Engine][3], VehicleInfo[ V_IDX - 1 ][vPT_Engine][4]);

            cache_get_value_name(i, "vPT_Brake", date_mass, 16);
            sscanf(date_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Brake][0], VehicleInfo[ V_IDX - 1 ][vPT_Brake][1],
            VehicleInfo[ V_IDX - 1 ][vPT_Brake][2], VehicleInfo[ V_IDX - 1 ][vPT_Brake][3], VehicleInfo[ V_IDX - 1 ][vPT_Brake][4]);

            cache_get_value_name(i, "vPT_Stability", date_mass, 16);
            sscanf(date_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Stability][0], VehicleInfo[ V_IDX - 1 ][vPT_Stability][1],
            VehicleInfo[ V_IDX - 1 ][vPT_Stability][2], VehicleInfo[ V_IDX - 1 ][vPT_Stability][3], VehicleInfo[ V_IDX - 1 ][vPT_Stability][4]);

            cache_get_value_name(i, "vComponent", date_mass, 126);
            sscanf ( date_mass, "p<|>dddddddddd", VehicleInfo[ V_IDX - 1 ][vComponent][0], VehicleInfo[ V_IDX - 1 ][vComponent][1],
            VehicleInfo[ V_IDX - 1 ][vComponent][2], VehicleInfo[ V_IDX - 1 ][vComponent][3], VehicleInfo[ V_IDX - 1 ][vComponent][4],
            VehicleInfo[ V_IDX - 1 ][vComponent][5], VehicleInfo[ V_IDX - 1 ][vComponent][6], VehicleInfo[ V_IDX - 1 ][vComponent][7],
            VehicleInfo[ V_IDX - 1 ][vComponent][8], VehicleInfo[ V_IDX - 1 ][vComponent][9]);
            
            cache_get_value_name_int(i, "vSellSlot", VehicleInfo[ V_IDX - 1 ][vSellSlot]);
            cache_get_value_name_int(i, "vSellCost", VehicleInfo[ V_IDX - 1 ][vSellCost]);
            cache_get_value_name_int(i, "vSellCarMarket", VehicleInfo[ V_IDX - 1 ][vSellCarMarket]);
            cache_get_value_name_int(i, "vTypeCost", VehicleInfo[ V_IDX - 1 ][vTypeCost]);
            
			cache_get_value_name_int(i, "vTax", VehicleInfo[ V_IDX - 1 ][vTax]);

            cache_get_value_name_int(i, "vRepair", VehicleInfo[ V_IDX - 1 ][vRepair]);
            cache_get_value_name_int(i, "vFillBag", VehicleInfo[ V_IDX - 1 ][vFillBag]);
            cache_get_value_name_int(i, "vMoney", VehicleInfo[ V_IDX - 1 ][vMoney]);
            cache_get_value_name_int(i, "vDrugs", VehicleInfo[ V_IDX - 1 ][vDrugs]);
            cache_get_value_name_int(i, "vMaterials", VehicleInfo[ V_IDX - 1 ][vMaterials]);
			/*new 
				type_car = 55;
			cache_get_value_name_int(i, "vTypeCar", type_car);*/
            new
                bootg_mass[32],
                boota_mass[32];
                
            cache_get_value_name(i, "vGun", bootg_mass, 32);
            sscanf(bootg_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootGun]);
            cache_get_value_name(i, "vAmmo", boota_mass, 32);
            sscanf(boota_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootAmmo]); 

            VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1);
            SetVehicleNumberPlate (VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vNumber]); 
			_SetVehicleHealth(VehicleInfo[ V_IDX - 1 ][vVehicle], vehicleCountArmour[ VehicleInfo[ V_IDX - 1 ][vPT_Engine][1] ]);
            if (VehicleInfo[ V_IDX - 1 ][vSellCost] != 0)
            {
				/*if (type_car != 55) {
					slotSaleVehicle[TOTAL_SALE_VEHICLE][vehSaleX] = VehicleInfo[ V_IDX - 1 ][vPos][0];
					slotSaleVehicle[TOTAL_SALE_VEHICLE][vehSaleY] = VehicleInfo[ V_IDX - 1 ][vPos][1];
					slotSaleVehicle[TOTAL_SALE_VEHICLE][vehSaleType] = type_car;
					TOTAL_SALE_VEHICLE++;
				}*/
				
                format(VehicleInfo[ V_IDX - 1 ][vNumber], 12, "Sale");
                SetVehicleNumberPlate(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vNumber]); 
                UpdateSellVehicleInfo(V_IDX);
				
            }  
/*

enum E_SLOT_SALE_VEHICLE {
	Float: vehSaleX,
	Float: vehSaleY,
	vehSaleType
}
new slotSaleVehicle[55][E_SLOT_SALE_VEHICLE], TOTAL_SALE_VEHICLE = 0;
*/
            for(new j = 0; j < 10; j ++) {
                AddVehicleComponent(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vComponent][j]);
            }

            VehicleInfo[ V_IDX - 1 ][vLocked] = false;
            GetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
            SetVehicleParamsEx(V_IDX, engine1, lights2, alarm2, false, bonnet2, boot1, objective1);
        }
    }
    printf("[Загрузка ...] Данные из s_vehicle_player получены! Время: %d", GetTickCount() - time);
    return 1;
}

vehicle_OnPlayerDisconnect(playerid) {
    if (pTemp[playerid][PlayerVehicle] != INVALID_VEHICLE_ID) {
		VehicleInfo[ pTemp[playerid][PlayerVehicle] - 1 ][vDriverID] = INVALID_PLAYER_ID;
	}

    if (Iter_Count(PlayerListVehicle[playerid]) != 0)
	{
		foreach(new V_IDX:PlayerListVehicle[playerid])
		{ 
			new query_[146]; 
			format(query_, sizeof query_,"UPDATE `s_vehicle_player` SET `vFuel` = '%f',`vMillage` = '%f' WHERE `vID` = '%d' LIMIT 1", 
			VehicleInfo[ V_IDX - 1 ][vFuel],
			VehicleInfo[ V_IDX - 1 ][vMillage], 
			VehicleInfo[ V_IDX - 1 ][vID]);
			mysql_tquery(dbHandle, query_, "", "");
			
			VehicleInfo[ V_IDX - 1 ][vFraction] = 0;
			VehicleInfo[ V_IDX - 1 ][vSubFraction] = 0;
			VehicleInfo[ V_IDX - 1 ][vRank] = 0;
			VehicleInfo[ V_IDX - 1 ][vType] = 0;
			VehicleInfo[ V_IDX - 1 ][vMoney] = 0;
			VehicleInfo[ V_IDX - 1 ][vFillBag] = 0;
			VehicleInfo[ V_IDX - 1 ][vRepair] = 0;
			VehicleInfo[ V_IDX - 1 ][vDrugs] = 0;
			VehicleInfo[ V_IDX - 1 ][vMaterials] = 0;
			for(new t = 0; t < 6; t++)
		    {
		        VehicleInfo[ V_IDX - 1 ][vBootGun][t] = 0;
		        VehicleInfo[ V_IDX - 1 ][vBootAmmo][t] = 0;
			}
			_DestroyVehicle(V_IDX); 
		}
		Iter_Clear(PlayerListVehicle[playerid]);
	}

    if (pTemp[playerid][id_arended_truck] != INVALID_VEHICLE_ID) {
	    VehicleInfo[ pTemp[playerid][id_arended_truck] - 1 ][id_arender_truck] = INVALID_PLAYER_ID;
	} 

	if (pTemp[playerid][tTruckerTrailerBuy] != INVALID_VEHICLE_ID) {
		for (new i = 0; i < LOADING_ALL; i++) {
			if (TurnLoadingTrucker[i][0] == playerid) {
				TurnLoadingTrucker[i][0] = INVALID_PLAYER_ID;
			}
		} 
		HideTruckerMainMenu(playerid, .main = true, .timer = true); 
		new 
			trailer_id = pTemp[playerid][tTruckerTrailerBuy];
		trailer_count[ trailer_id - 1 ] = 0;
		trailer_type[ trailer_id - 1 ] = -1;
		_DestroyVehicle(trailer_id);
	}
}
/*
stock vehicle_OnPlayerExitVehicle(playerid, vehicleid)
{
    #pragma unused playerid
	VehicleInfo[vehicleid][vDriverID] = INVALID_PLAYER_ID;
	//return 0;
}*/
/*
stock vehicle_OnPlayerEnterVehicle(playerid, vehicleid)
{ 
	return 0;
}*/
 

stock GetVeicleFineSlots() {
	new 
		current_slot = -1;
	printf("count fine %d", sizeof(NewFinePosition));
	for (new idx = 0; idx < MAX_FINE_POSITION; idx++ ) {
		if (NewFinePositionSlots[idx] == false) {
			current_slot = idx;
			return current_slot;
		}
		/*if (NewFinePositionSlots[idx] != false) continue;
		current_slot = idx;
		break;*/
	} 
	return current_slot;
}


stock GetPlayerVehicleCount(playerid, type)
{
	new _veh_count = 0,
		query_[78]; 
	format(query_, sizeof query_,"SELECT * FROM s_vehicle_player WHERE vOwner = '%d' AND vTypeCar = '%d'", pInfo[playerid][pID], type);
	new Cache: result = mysql_query(dbHandle, query_);
	_veh_count = cache_num_rows( );
	if (cache_is_valid(result)) cache_delete(result);
	return _veh_count;
} 
publics: create_vehicle_callback(veh_id) {
	VehicleInfo[ veh_id - 1 ][vID] = cache_insert_id();
	return 1;
}
publics: OnPlayerTypeLoadVehicle(playerid, type, time_s)
{
	printf("count fine %d", sizeof(NewFinePosition));
	new rows;
	cache_get_row_count(rows);
	if (rows)
	{
		for( new i = 0, date_mass[128]; i < rows ; i++)
		{
		    new V_IDX = GetVehicleID();

			VehicleInfo[ V_IDX - 1 ] [vType] = VEHICLE_TYPE_PLAYER; 
            cache_get_value_name_int(i, "vID", VehicleInfo[ V_IDX - 1 ][vID]);
            cache_get_value_name_int(i, "vModel", VehicleInfo[ V_IDX - 1 ][vModel]);
            cache_get_value_name_int(i, "vOwner", VehicleInfo[ V_IDX - 1 ][vFraction]); 
            cache_get_value_name(i, "vColor", date_mass, sizeof date_mass);
	 		sscanf(date_mass, "p<|>a<d>[2]", VehicleInfo[V_IDX - 1][vColor]); 
            cache_get_value_name(i, "vNumber", VehicleInfo[V_IDX - 1][vNumber], 12); 
			cache_get_value_name_float(i, "vFuel", VehicleInfo[ V_IDX - 1 ][vFuel]); 
			cache_get_value_name_float(i, "vMillage", VehicleInfo[ V_IDX - 1 ][vMillage]);
			VehicleInfo[ V_IDX - 1 ][vSubFraction] 	= 0;
			VehicleInfo[ V_IDX - 1 ][vRank] 		= 0; 
			cache_get_value_name(i, "vPos", date_mass, sizeof date_mass);
			sscanf(date_mass, "p<|>a<f>[4]", VehicleInfo[ V_IDX - 1 ][vPos]);  
            cache_get_value_name_int(i, "vWorld", VehicleInfo[ V_IDX - 1 ][vWorld]);
            cache_get_value_name_int(i, "vInt", VehicleInfo[ V_IDX - 1 ][vInt]); 
            cache_get_value_name_int(i, "vFine", VehicleInfo[ V_IDX - 1 ][vFine]);
			cache_get_value_name_int(i, "vTax", VehicleInfo[ V_IDX - 1 ][vTax]);
			new
				type_car;
			cache_get_value_name_int(i, "vTypeCar", type_car);
			if (VehicleInfo[ V_IDX - 1 ][vFine] > 0)
			{
				new 
					current_slot = GetVeicleFineSlots(),
					query_[228]; 
				NewFinePositionSlots[current_slot] = true;
				for(new j = 0; j < 4; j++) { 
					VehicleInfo[ V_IDX - 1 ][vPos][j] = NewFinePosition[current_slot][j];
				}
				printf("NewFinePositionSlots[current_slot] %d", current_slot); 
				VehicleInfo[ V_IDX - 1 ][vFineSlots] = current_slot; 
				format(query_, sizeof query_, "UPDATE "TABLE_VEHICLE_PLAYER" SET vFine = '0', vDayFine = '0', vPos = '%.2f|%.2f|%.2f|%.2f', vWorld = '%d', vInt = '%d' WHERE vID = '%d'",
					VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3],
					VehicleInfo[ V_IDX - 1 ][vWorld], VehicleInfo[ V_IDX - 1 ][vInt], VehicleInfo[ V_IDX - 1 ][vID]
				);
				mysql_tquery(dbHandle, query_); 
			}
			cache_get_value_name(i, "vPT_Engine", date_mass, sizeof date_mass);
			sscanf(date_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Engine][0], VehicleInfo[ V_IDX - 1 ][vPT_Engine][1],
			VehicleInfo[ V_IDX - 1][vPT_Engine][2], VehicleInfo[ V_IDX - 1 ][vPT_Engine][3], VehicleInfo[ V_IDX - 1 ][vPT_Engine][4]);

			cache_get_value_name(i, "vPT_Brake", date_mass, sizeof date_mass);
			sscanf(date_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Brake][0], VehicleInfo[ V_IDX - 1 ][vPT_Brake][1],
			VehicleInfo[ V_IDX - 1 ][vPT_Brake][2], VehicleInfo[ V_IDX - 1 ][vPT_Brake][3], VehicleInfo[ V_IDX - 1 ][vPT_Brake][4]);

			cache_get_value_name(i, "vPT_Stability", date_mass, sizeof date_mass);
			sscanf(date_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Stability][0], VehicleInfo[ V_IDX - 1 ][vPT_Stability][1],
			VehicleInfo[ V_IDX - 1 ][vPT_Stability][2], VehicleInfo[ V_IDX - 1 ][vPT_Stability][3], VehicleInfo[ V_IDX - 1 ][vPT_Stability][4]);

			cache_get_value_name(i, "vComponent", date_mass, sizeof date_mass);
			sscanf(date_mass, "p<|>dddddddddd", VehicleInfo[ V_IDX - 1 ][vComponent][0], VehicleInfo[ V_IDX - 1 ][vComponent][1], VehicleInfo[ V_IDX - 1 ][vComponent][2], VehicleInfo[ V_IDX - 1 ][vComponent][3], 
				VehicleInfo[ V_IDX - 1 ][vComponent][4], VehicleInfo[ V_IDX - 1 ][vComponent][5], VehicleInfo[ V_IDX - 1 ][vComponent][6], VehicleInfo[ V_IDX - 1 ][vComponent][7], VehicleInfo[ V_IDX - 1 ][vComponent][8], 
				VehicleInfo[ V_IDX - 1 ][vComponent][9]
			);
			
			cache_get_value_name_int(i, "vRepair", VehicleInfo[ V_IDX - 1 ][vRepair]);
        	cache_get_value_name_int(i, "vFillBag", VehicleInfo[ V_IDX - 1 ][vFillBag]);
        	cache_get_value_name_int(i, "vMoney", VehicleInfo[ V_IDX - 1 ][vMoney]);
			cache_get_value_name_int(i, "vDrugs", VehicleInfo[ V_IDX - 1 ][vDrugs]);
			cache_get_value_name_int(i, "vMaterials", VehicleInfo[ V_IDX - 1 ][vMaterials]); 

			cache_get_value_name(i, "vGun", date_mass, sizeof date_mass);
 			sscanf(date_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootGun]);
 			cache_get_value_name(i, "vAmmo", date_mass, sizeof date_mass);
 			sscanf(date_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootAmmo]); 
			if (type_car == TYPE_CAR)
			{
				if (type == 0) // house
				{  
					if (pInfo[playerid][pHouseID] != -1 && VehicleInfo[ V_IDX - 1 ][vModel] != 508)
					{
						new HOUSE_ID = pInfo[playerid][pHouseID],
							G_IDX = HouseInfo[HOUSE_ID][hGarageID];
						if (HouseInfo[HOUSE_ID][hGarageID] == -1) {
							//if (Iter_Count(PlayerListVehicle[playerid]) == 0) {
								for(new j = 0; j < 4; j++) { 
									VehicleInfo[ V_IDX - 1 ][vPos][j] = HouseInfo[HOUSE_ID][hCar][j];
								} 
								VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
									HouseInfo[HOUSE_ID][hCar][0], HouseInfo[HOUSE_ID][hCar][1], HouseInfo[HOUSE_ID][hCar][2], HouseInfo[HOUSE_ID][hCar][3], 
									VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
								);
							/*} else {
								VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
                                	VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
                                	VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 
								);
							} */
						}
						else
						{ 
							if (GarageInt[G_IDX][gVehicleCount] > Iter_Count(PlayerListVehicle[playerid])) { 
								if (Iter_Count(PlayerListVehicle[playerid]) == 0 && GarageInt[G_IDX][gCarPos_0][0] != 0.0) {
									for(new j = 0; j < 4; j++) { 
										VehicleInfo[ V_IDX - 1 ][vPos][j] = GarageInt[G_IDX][gCarPos_0][j];
									} 
									VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
										GarageInt[G_IDX][gCarPos_0][0], GarageInt[G_IDX][gCarPos_0][1], GarageInt[G_IDX][gCarPos_0][2], GarageInt[G_IDX][gCarPos_0][3], 
										VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
									);  
								} 
								else if (Iter_Count(PlayerListVehicle[playerid]) == 1 && GarageInt[G_IDX][gCarPos_1][0] != 0.0) {
									for(new j = 0; j < 4; j++) { 
										VehicleInfo[ V_IDX - 1 ][vPos][j] = GarageInt[G_IDX][gCarPos_1][j];
									} 
									VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
										GarageInt[G_IDX][gCarPos_1][0], GarageInt[G_IDX][gCarPos_1][1], GarageInt[G_IDX][gCarPos_1][2], GarageInt[G_IDX][gCarPos_1][3], 
										VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
									);   
								}
								else if (Iter_Count(PlayerListVehicle[playerid]) == 2 && GarageInt[G_IDX][gCarPos_2][0] != 0.0) {
									for(new j = 0; j < 4; j++) { 
										VehicleInfo[ V_IDX - 1 ][vPos][j] = GarageInt[G_IDX][gCarPos_2][j];
									} 
									VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
										GarageInt[G_IDX][gCarPos_2][0], GarageInt[G_IDX][gCarPos_2][1], GarageInt[G_IDX][gCarPos_2][2], GarageInt[G_IDX][gCarPos_2][3], 
										VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
									);   
								}
								else if (Iter_Count(PlayerListVehicle[playerid]) == 3 && GarageInt[G_IDX][gCarPos_3][0] != 0.0) {
									for(new j = 0; j < 4; j++) { 
										VehicleInfo[ V_IDX - 1 ][vPos][j] = GarageInt[G_IDX][gCarPos_3][j];
									} 
									VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
										GarageInt[G_IDX][gCarPos_3][0], GarageInt[G_IDX][gCarPos_3][1], GarageInt[G_IDX][gCarPos_3][2], GarageInt[G_IDX][gCarPos_3][3], 
										VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
									);   
								} 
							} else {
								VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
									VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
									VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 
								);
							}  
							VehicleInfo[ V_IDX - 1 ][vInt] = GarageInt[G_IDX][gIntInterior];
							VehicleInfo[ V_IDX - 1 ][vWorld] = HOUSE_ID+50;
							LinkVehicleToInterior(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vInt]);
							SetVehicleVirtualWorld(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vWorld]);
						}
						
					}
					else {
                        static const Float: pos_dnk_invalid_mir[][] = {//Удалить 17.10.20
						    {1558.5729, -1013.2316, 24.2814, 179.8318},
                            {1563.2352, -1013.2453, 24.2814, 179.8318},
                            {1567.7114, -1013.2587, 24.2814, 179.8319},
                            {1572.0642, -1013.2714, 24.2726, 179.8318},
                            {1576.3301, -1013.2838, 24.2721, 179.8318},
                            {1581.5461, -1012.5868, 24.2812, 185.4338},
                            {1586.1617, -1012.1478, 24.2812, 185.4338},
                            {1590.3918, -1011.7454, 24.2812, 185.4338},
                            {1594.6818, -1011.3377, 24.2812, 185.4338},
                            {1599.6234, -1010.8677, 24.2812, 185.4338},
                            {1604.7522, -1010.9351, 24.2812, 179.1941},
                            {1608.9543, -1010.9944, 24.2812, 179.1941},
                            {1613.5310, -1011.0590, 24.2812, 179.1941},
                            {1617.9485, -1011.1209, 24.2738, 179.1940}
                        };  
                        new
                            rand_ = random(sizeof(pos_dnk_invalid_mir));  
                        if (VehicleInfo[ V_IDX - 1 ][vInt] != 0 ) {
                            VehicleInfo[ V_IDX - 1 ][vPos][0] = pos_dnk_invalid_mir[rand_][0];
							VehicleInfo[ V_IDX - 1 ][vPos][1] = pos_dnk_invalid_mir[rand_][1];
							VehicleInfo[ V_IDX - 1 ][vPos][2] = pos_dnk_invalid_mir[rand_][2];
							VehicleInfo[ V_IDX - 1 ][vPos][3] = pos_dnk_invalid_mir[rand_][3];
                            
							VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
								pos_dnk_invalid_mir[rand_][0], pos_dnk_invalid_mir[rand_][1], pos_dnk_invalid_mir[rand_][2], pos_dnk_invalid_mir[rand_][3], 
								VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
							);
                            VehicleInfo[ V_IDX - 1 ][vInt] = 0;
                            VehicleInfo[ V_IDX - 1 ][vWorld] = 0;
                            LinkVehicleToInterior(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vInt]);
                            SetVehicleVirtualWorld(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vWorld]);
                            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш дом на колесах припоркован не далеко от штрафстоянки");
                            SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Используйте \"/gps\" [0] Важные места - [16] Штрафстоянка");
                        }
                        else {
                            VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
                                VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
                                VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 ) ;
                        }     
                    }
				}
				else if (type == 1)//fine pos
				{ 
					VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
						VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
						VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 
					);
				} 
			}
			if (type_car == TYPE_BOAT) {
				VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
					VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
					VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 
				);
			}
			if (type_car == TYPE_PLANE) {
				VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
					VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
					VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 
				);
			} 
			if (type_car == TYPE_CARAVAN) {
				VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
					VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
					VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 ) ;
			}
	
			SetVehicleNumberPlate(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vNumber]);  
			_SetVehicleHealth(VehicleInfo[ V_IDX - 1 ][vVehicle], vehicleCountArmour[ VehicleInfo[ V_IDX - 1 ][vPT_Engine][1] ]);
            cache_get_value_name_int(i, "vPaint", VehicleInfo[ V_IDX - 1 ][vPaint]);
			if (VehicleInfo[ V_IDX - 1 ][vPaint] != 3) {
				ChangeVehiclePaintjob(V_IDX, VehicleInfo[ V_IDX - 1 ][vPaint]);
			} 
			if (VehicleInfo[ V_IDX - 1 ][vInt] != 0) LinkVehicleToInterior(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vInt]);
			if (VehicleInfo[ V_IDX - 1 ][vWorld] != 0) SetVehicleVirtualWorld(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vWorld]); 
			for(new j = 0; j < 10; j ++) {
				AddVehicleComponent(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vComponent][j]);
			} 
			Iter_Add(PlayerListVehicle[playerid], VehicleInfo[ V_IDX - 1 ][vVehicle]); 
			VehicleInfo[ V_IDX - 1 ][vLocked] = true;
			GetVehicleParamsEx (V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
			SetVehicleParamsEx (V_IDX, engine1, lights2, alarm2, true, bonnet2, boot1, objective1);  
            UpdateVehiclevText(playerid, V_IDX, true);
		}
		if (time_s != 0) {
			printf("Затрачено времени %d ms", GetTickCount() - time_s);
		}
	}
	return 1;
} 
/*
CMD:nalogcar(playerid) {
	new 
		string_[128],
		def_tax = 500,
		query_[64];
	foreach(new V_IDX: PlayerListVehicle[playerid])
	{
		if(GetString(VehicleInfo[ V_IDX - 1 ][vNumber], "None")) {
			VehicleInfo[ V_IDX - 1 ][vTax] += (def_tax*2); 
			format(string_, sizeof string_, "[Оповещение] "colwhi"транспорт %s не стоит на учете, сумма налога повышена", VehicleNames[ VehicleInfo[ V_IDX - 1 ][vModel] - 400 ]);
			SendClientMessage(playerid, COLOR_LI_RED, string_); 
		} else {
			VehicleInfo[ V_IDX - 1 ][vTax] += def_tax;
		}
		if (VehicleInfo[ V_IDX - 1 ][vTax] > MAX_VALUE_FOR_SALE_GOS) {
			SendClientMessage(playerid, COLOR_WHITE, !"Ваш транспорт был продан государству за неуплату налогов!");
			format(query_, sizeof query_, "DELETE FROM "TABLE_VEHICLE_PLAYER" WHERE vID = '%d'", VehicleInfo[ V_IDX - 1 ][vID]);
			mysql_tquery(dbHandle, query_, "", ""); 
			Iter_Remove(PlayerListVehicle[playerid], V_IDX);
			_DestroyVehicle(V_IDX);
		}
		format(string_, sizeof string_, "debug ID: %d", VehicleInfo[ V_IDX - 1 ][vModel]);
		SendClientMessage(playerid, -1, string_); 
	}
	return 1;
}
*/
publics: OnGiveTaxFineVehiclePlayer() {
    new
        time = GetTickCount(), rows,
        SELL_GOS_CAR = 0, COUNT_FINE_CAR = 0;
    cache_get_row_count(rows);
    if (!rows) {
        print(!"[Загрузка ...] Данные из "#TABLE_VEHICLE_PLAYER" не получены!");
        return true;
    } 
	for (new i = 0, V_IDX, V_TAX, V_OWNER, query_[128]; i < rows; i++) {
		cache_get_value_name_int(i, "vID", V_IDX); 
		cache_get_value_name_int(i, "vDayFine", V_TAX);
		cache_get_value_name_int(i, "vOwner", V_OWNER); 
		V_TAX ++; 
		if (V_TAX > MAX_VALUE_FOR_SALE_GOS_IN_FINE) {
			format(query_, sizeof query_, ""colinfo"[Штрафстоянка] "colwhi"Ваш транспорт был продан государству, за неуплату места на стоянке!");
			MessagePlayerOffline(V_OWNER, query_), query_[0] = EOS;
			format(query_, sizeof query_, "DELETE FROM "TABLE_VEHICLE_PLAYER" WHERE vID = '%d'", V_IDX);
			mysql_tquery(dbHandle, query_, "", "");  
			SELL_GOS_CAR++;
		}
		else {
			format(query_, sizeof query_, "UPDATE "TABLE_VEHICLE_PLAYER" SET vDayFine = '%d' WHERE vID = '%d'", V_TAX, V_IDX);
			mysql_tquery(dbHandle, query_, "", ""); 
		}
		COUNT_FINE_CAR++;
	}
	printf("[Загрузка ...] Данные из "#TABLE_VEHICLE_PLAYER" получены! (%d шт.) Время: %d", rows, GetTickCount() - time);
	printf("[Загрузка ...] Было продано транспорта: %d | На штрафстоянке: %d", SELL_GOS_CAR, COUNT_FINE_CAR);
	return 1;
}
publics: OnPlayerFixCarVehicle(playerid, type) {
	new 
		rows;
	cache_get_row_count(rows);
	if (rows) {
		for(new i = 0, position_mass[128]; i < rows ; i++)
		{
		    new V_IDX = GetVehicleID();

			VehicleInfo[ V_IDX - 1 ] [vType] = VEHICLE_TYPE_PLAYER;
			
            cache_get_value_name_int(i, "vID", VehicleInfo[ V_IDX - 1 ][vID]);
            cache_get_value_name_int(i, "vModel", VehicleInfo[ V_IDX - 1 ][vModel]);
            cache_get_value_name_int(i, "vOwner", VehicleInfo[ V_IDX - 1 ][vFraction]); 
            cache_get_value_name(i, "vColor", position_mass, sizeof position_mass);
	 		sscanf(position_mass, "p<|>a<d>[2]", VehicleInfo[V_IDX - 1][vColor]);
            cache_get_value_name(i, "vNumber", VehicleInfo[V_IDX - 1][vNumber], 12);

			cache_get_value_name_float(i, "vFuel", VehicleInfo[ V_IDX - 1 ][vFuel]); 
			cache_get_value_name_float(i, "vMillage", VehicleInfo[ V_IDX - 1 ][vMillage]);
			VehicleInfo[ V_IDX - 1 ][vSubFraction] = 0;
			VehicleInfo[ V_IDX - 1 ][vRank] = 0;

			cache_get_value_name(i, "vPos", position_mass, sizeof position_mass);
			sscanf(position_mass,"p<|>a<f>[4]", VehicleInfo[ V_IDX - 1 ][vPos]); 

            cache_get_value_name_int(i, "vWorld", VehicleInfo[ V_IDX - 1 ][vWorld]);
            cache_get_value_name_int(i, "vInt", VehicleInfo[ V_IDX - 1 ][vInt]);
			cache_get_value_name_int(i, "vTax", VehicleInfo[ V_IDX - 1 ][vTax]);
            cache_get_value_name_int(i, "vFine", VehicleInfo[ V_IDX - 1 ][vFine]);
			if (VehicleInfo[ V_IDX - 1 ][vFine] > 0) {
				new 
					current_slot = GetVeicleFineSlots(),
					query_[228]; 
				NewFinePositionSlots[current_slot] = true;
				for(new j = 0; j < 4; j++) { 
					VehicleInfo[ V_IDX - 1 ][vPos][j] = NewFinePosition[current_slot][j];
				}
				printf("NewFinePositionSlots[current_slot] %d", current_slot); 
				VehicleInfo[ V_IDX - 1 ][vFineSlots] = current_slot; 
				format(query_, sizeof query_, "UPDATE "TABLE_VEHICLE_PLAYER" SET vFine = '0', vDayFine = '0', vPos = '%.2f|%.2f|%.2f|%.2f', vWorld = '%d', vInt = '%d' WHERE vID = '%d'",
					VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3],
					VehicleInfo[ V_IDX - 1 ][vWorld], VehicleInfo[ V_IDX - 1 ][vInt], VehicleInfo[ V_IDX - 1 ][vID]
				);
				mysql_tquery(dbHandle, query_);  
			}
			cache_get_value_name(i, "vPT_Engine", position_mass, sizeof position_mass);
			sscanf(position_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Engine][0], VehicleInfo[ V_IDX - 1 ][vPT_Engine][1],
				VehicleInfo[ V_IDX - 1][vPT_Engine][2], VehicleInfo[ V_IDX - 1 ][vPT_Engine][3], VehicleInfo[ V_IDX - 1 ][vPT_Engine][4]);

			cache_get_value_name(i, "vPT_Brake", position_mass, sizeof position_mass);
			sscanf(position_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Brake][0], VehicleInfo[ V_IDX - 1 ][vPT_Brake][1],
				VehicleInfo[ V_IDX - 1 ][vPT_Brake][2], VehicleInfo[ V_IDX - 1 ][vPT_Brake][3], VehicleInfo[ V_IDX - 1 ][vPT_Brake][4]);

			cache_get_value_name(i, "vPT_Stability", position_mass, sizeof position_mass);
				sscanf(position_mass, "p<|>ddddd", VehicleInfo[ V_IDX - 1 ][vPT_Stability][0], VehicleInfo[ V_IDX - 1 ][vPT_Stability][1],
			VehicleInfo[ V_IDX - 1 ][vPT_Stability][2], VehicleInfo[ V_IDX - 1 ][vPT_Stability][3], VehicleInfo[ V_IDX - 1 ][vPT_Stability][4]);

			cache_get_value_name(i, "vComponent", position_mass, sizeof position_mass);
			sscanf ( position_mass, "p<|>dddddddddd", VehicleInfo[ V_IDX - 1 ][vComponent][0], VehicleInfo[ V_IDX - 1 ][vComponent][1],
			VehicleInfo[ V_IDX - 1 ][vComponent][2], VehicleInfo[ V_IDX - 1 ][vComponent][3], VehicleInfo[ V_IDX - 1 ][vComponent][4],
			VehicleInfo[ V_IDX - 1 ][vComponent][5], VehicleInfo[ V_IDX - 1 ][vComponent][6], VehicleInfo[ V_IDX - 1 ][vComponent][7],
			VehicleInfo[ V_IDX - 1 ][vComponent][8], VehicleInfo[ V_IDX - 1 ][vComponent][9]);
			
			cache_get_value_name_int(i, "vRepair", VehicleInfo[ V_IDX - 1 ][vRepair]);
        	cache_get_value_name_int(i, "vFillBag", VehicleInfo[ V_IDX - 1 ][vFillBag]);
        	cache_get_value_name_int(i, "vMoney", VehicleInfo[ V_IDX - 1 ][vMoney]);
			cache_get_value_name_int(i, "vDrugs", VehicleInfo[ V_IDX - 1 ][vDrugs]);
			cache_get_value_name_int(i, "vMaterials", VehicleInfo[ V_IDX - 1 ][vMaterials]); 
			cache_get_value_name(i, "vGun",position_mass, sizeof position_mass);
 			sscanf(position_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootGun]);
 			cache_get_value_name(i, "vAmmo",position_mass, sizeof position_mass);
 			sscanf(position_mass, "p<,>a<d>[6]", VehicleInfo[ V_IDX - 1 ][vBootAmmo]);
			if (type == 0) //Возле дома
			{
				if (pInfo[playerid][pHouseID] != -1) {
					new 
						HOUSE_ID = pInfo[playerid][pHouseID]; 
					VehicleInfo[ V_IDX - 1 ][vPos][0] = HouseInfo[HOUSE_ID][hCar][0];
					VehicleInfo[ V_IDX - 1 ][vPos][1] = HouseInfo[HOUSE_ID][hCar][1];
					VehicleInfo[ V_IDX - 1 ][vPos][2] = HouseInfo[HOUSE_ID][hCar][2];
					VehicleInfo[ V_IDX - 1 ][vPos][3] = HouseInfo[HOUSE_ID][hCar][3];
					VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], HouseInfo[HOUSE_ID][hCar][0], HouseInfo[HOUSE_ID][hCar][1], HouseInfo[HOUSE_ID][hCar][2], HouseInfo[HOUSE_ID][hCar][3], 
						VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
					); 
				}
			}
			if (type == 1) // В гараже
			{
				new 
					HOUSE_ID = pInfo[playerid][pHouseID],
					G_IDX = HouseInfo[HOUSE_ID][hGarageID];
				if (HouseInfo[HOUSE_ID][hGarageID] == -1) {
					if (Iter_Count(PlayerListVehicle[playerid]) == 0) {
						for(new j = 0; j < 4; j++) { 
							VehicleInfo[ V_IDX - 1 ][vPos][j] = HouseInfo[HOUSE_ID][hCar][j];
						} 
						VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
							HouseInfo[HOUSE_ID][hCar][0], HouseInfo[HOUSE_ID][hCar][1], HouseInfo[HOUSE_ID][hCar][2], HouseInfo[HOUSE_ID][hCar][3], 
							VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
						);
					} else {
						VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
							VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
							VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 
						);
					} 
				}
				else
				{ 
					if (GarageInt[G_IDX][gVehicleCount] > Iter_Count(PlayerListVehicle[playerid])) { 
						if (Iter_Count(PlayerListVehicle[playerid]) == 0 && GarageInt[G_IDX][gCarPos_0][0] != 0.0) {
							for(new j = 0; j < 4; j++) { 
								VehicleInfo[ V_IDX - 1 ][vPos][j] = GarageInt[G_IDX][gCarPos_0][j];
							} 
							VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
								GarageInt[G_IDX][gCarPos_0][0], GarageInt[G_IDX][gCarPos_0][1], GarageInt[G_IDX][gCarPos_0][2], GarageInt[G_IDX][gCarPos_0][3], 
								VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
							);  
						} 
						else if (Iter_Count(PlayerListVehicle[playerid]) == 1 && GarageInt[G_IDX][gCarPos_1][0] != 0.0) {
							for(new j = 0; j < 4; j++) { 
								VehicleInfo[ V_IDX - 1 ][vPos][j] = GarageInt[G_IDX][gCarPos_1][j];
							} 
							VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
								GarageInt[G_IDX][gCarPos_1][0], GarageInt[G_IDX][gCarPos_1][1], GarageInt[G_IDX][gCarPos_1][2], GarageInt[G_IDX][gCarPos_1][3], 
								VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
							);   
						}
						else if (Iter_Count(PlayerListVehicle[playerid]) == 2 && GarageInt[G_IDX][gCarPos_2][0] != 0.0) {
							for(new j = 0; j < 4; j++) { 
								VehicleInfo[ V_IDX - 1 ][vPos][j] = GarageInt[G_IDX][gCarPos_2][j];
							} 
							VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
								GarageInt[G_IDX][gCarPos_2][0], GarageInt[G_IDX][gCarPos_2][1], GarageInt[G_IDX][gCarPos_2][2], GarageInt[G_IDX][gCarPos_2][3], 
								VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
							);   
						}
						else if (Iter_Count(PlayerListVehicle[playerid]) == 3 && GarageInt[G_IDX][gCarPos_3][0] != 0.0) {
							for(new j = 0; j < 4; j++) { 
								VehicleInfo[ V_IDX - 1 ][vPos][j] = GarageInt[G_IDX][gCarPos_3][j];
							} 
							VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
								GarageInt[G_IDX][gCarPos_3][0], GarageInt[G_IDX][gCarPos_3][1], GarageInt[G_IDX][gCarPos_3][2], GarageInt[G_IDX][gCarPos_3][3], 
								VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
							);   
						} 
					} else {
						SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"В гараже недостаточно места");
						VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
							VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
							VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 
						);
					}  
				}
				VehicleInfo[ V_IDX - 1 ][vInt] = GarageInt[G_IDX][gIntInterior];
				VehicleInfo[ V_IDX - 1 ][vWorld] = HOUSE_ID+50;
				LinkVehicleToInterior(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vInt]);
				SetVehicleVirtualWorld(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vWorld]);  
			}
			if (type == 2) // /park
			{ 
				VehicleInfo[ V_IDX - 1 ][vVehicle] = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], 
					VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], 
					VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1
				);
			}
 
			SetVehicleNumberPlate(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vNumber]);
			_SetVehicleHealth(VehicleInfo[ V_IDX - 1 ][vVehicle], vehicleCountArmour[ VehicleInfo[ V_IDX - 1 ][vPT_Engine][1] ]);
            cache_get_value_name_int(i, "vPaint", VehicleInfo[ V_IDX - 1 ][vPaint]);
			if (VehicleInfo[ V_IDX - 1 ][vPaint] != 3) {
				ChangeVehiclePaintjob (V_IDX, VehicleInfo[ V_IDX - 1 ][vPaint]);
			}

			if (VehicleInfo[ V_IDX - 1 ][vInt] != 0 ) LinkVehicleToInterior(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vInt]);
			if (VehicleInfo[ V_IDX - 1 ][vWorld] != 0 ) SetVehicleVirtualWorld(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vWorld]);


			for(new j = 0; j < 10; j ++)
			{
				AddVehicleComponent(VehicleInfo[ V_IDX - 1 ][vVehicle], VehicleInfo[ V_IDX - 1 ][vComponent][j]);
			}
			Iter_Add(PlayerListVehicle[playerid], VehicleInfo[ V_IDX - 1 ][vVehicle]);

			VehicleInfo[ V_IDX - 1 ][vLocked] = true;
			GetVehicleParamsEx (V_IDX, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
			SetVehicleParamsEx (V_IDX, engine1, lights2, alarm2, true, bonnet2, boot1, objective1);
            UpdateVehiclevText(playerid, V_IDX, true);
		}
		
	}
	return 1;
}

CMD:park(playerid)
{ 
	for(new j = 0 ; j < MAX_NONPARKING_ZONES ; j ++) {
		if (IsPlayerInDynamicArea(playerid, non_parking_area[j])) return SendClientMessage(playerid, -1, !"Здесь запрещена парковка");
	}
	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в машине!");

	new V_IDX = GetPlayerVehicleID(playerid);
	if (IsValidVehicle(V_IDX))
	{
		if (VehicleInfo[ V_IDX - 1 ][vFraction] != pInfo[playerid][pID] || VehicleInfo[ V_IDX - 1 ][vType] != VEHICLE_TYPE_PLAYER) {
			SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться в Вашем личном транспорте!");
			return 1;
		}
		new 
			Float:vehicle_health;
		GetVehicleHealth(V_IDX, vehicle_health);
		if (vehicle_health < 500) return SendClientMessage(playerid, COLOR_WHITE, !"Для начала нужно починить транспортное средство."); 
		//new time = GetTickCount();
		for(new j = GetVehiclePoolSize() + 1; --j != 0;) {
			if (!IsValidVehicle(j)) continue;
			if (VehicleInfo[ j - 1 ][vWorld] == GetPlayerVirtualWorld(playerid)
				&& IsPlayerInRangeOfPoint(playerid, 3.0, VehicleInfo[ j - 1 ][vPos][0], VehicleInfo[ j - 1 ][vPos][1], VehicleInfo[ j - 1 ][vPos][2]))
			{ 
				SendClientMessage(playerid, COLOR_WHITE, !"Невозможно припарковать транспорт вбилизи парковки другого транспортного средства." );
				return 1 ;
			}
		} 
		GetVehiclePos(V_IDX, VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2]);
		GetVehicleZAngle(V_IDX, VehicleInfo[ V_IDX - 1 ][vPos][3]);

		new new_veh_id = _CreateVehicle(VehicleInfo[ V_IDX - 1 ][vModel], VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2], VehicleInfo[ V_IDX - 1 ][vPos][3], VehicleInfo[ V_IDX - 1 ][vColor][0], VehicleInfo[ V_IDX - 1 ][vColor][1], -1 ) ;
		Iter_Add(PlayerListVehicle[playerid], new_veh_id);

		VehicleInfo[ new_veh_id - 1 ][vType] = VEHICLE_TYPE_PLAYER ;
		VehicleInfo[ new_veh_id - 1 ][vID] = VehicleInfo[ V_IDX - 1 ][vID];
		VehicleInfo[ new_veh_id - 1 ][vPos][0] = VehicleInfo[ V_IDX - 1 ][vPos][0];
		VehicleInfo[ new_veh_id - 1 ][vPos][1] = VehicleInfo[ V_IDX - 1 ][vPos][1];
		VehicleInfo[ new_veh_id - 1 ][vPos][2] = VehicleInfo[ V_IDX - 1 ][vPos][2];
		VehicleInfo[ new_veh_id - 1 ][vPos][3] = VehicleInfo[ V_IDX - 1 ][vPos][3];

		VehicleInfo[ new_veh_id - 1 ][vFraction] = VehicleInfo[ V_IDX - 1 ][vFraction];
		VehicleInfo[ new_veh_id - 1 ][vColor][0] = VehicleInfo[ V_IDX - 1 ][vColor][0];
		VehicleInfo[ new_veh_id - 1 ][vColor][1] = VehicleInfo[ V_IDX - 1 ][vColor][1];

		VehicleInfo[ new_veh_id - 1 ][vPaint] = VehicleInfo[ V_IDX - 1 ][vPaint];
		if ( VehicleInfo[ new_veh_id - 1 ][vPaint] != 3) {
			ChangeVehiclePaintjob(new_veh_id, VehicleInfo[ new_veh_id - 1 ][vPaint]);
		}

		VehicleInfo[ new_veh_id - 1 ][vLocked] = VehicleInfo[ V_IDX - 1 ][vLocked];

		VehicleInfo[ new_veh_id - 1 ][vNumber] = VehicleInfo[ V_IDX - 1 ][vNumber] ;
		format(VehicleInfo[ new_veh_id - 1 ] [vNumber], 12, "%s", VehicleInfo[ V_IDX - 1 ] [vNumber]);

		VehicleInfo[ new_veh_id - 1 ][vFuel] = VehicleInfo[ V_IDX - 1 ][vFuel];
		VehicleInfo[ new_veh_id - 1 ][vMillage] = VehicleInfo[ V_IDX - 1 ][vMillage]; 

		VehicleInfo[ new_veh_id - 1 ][vVehicle] = new_veh_id ;

		for(new i = 0; i < 5 ; i ++ ) {
			VehicleInfo[ new_veh_id - 1 ][vPT_Engine][i] = VehicleInfo[ V_IDX - 1 ][vPT_Engine][i]; 
		}  
		_SetVehicleHealth(new_veh_id, vehicleCountArmour[VehicleInfo[ new_veh_id - 1 ][vPT_Engine][1]]);

		VehicleInfo[ new_veh_id - 1 ][vWorld] = GetPlayerVirtualWorld(playerid);
		VehicleInfo[ new_veh_id - 1 ][vInt] = GetPlayerInterior(playerid);
		if (VehicleInfo[ new_veh_id - 1 ][vInt] != 0 ) LinkVehicleToInterior(new_veh_id, VehicleInfo[ new_veh_id - 1 ][vInt]);
		if (VehicleInfo[ new_veh_id - 1 ][vWorld] != 0 ) SetVehicleVirtualWorld(new_veh_id, VehicleInfo[ new_veh_id - 1 ][vWorld]);

		for ( new j = 0; j < 10; j ++ )
		{
			VehicleInfo[ new_veh_id - 1 ][vComponent][j] = VehicleInfo[ V_IDX - 1 ][vComponent][j];
			AddVehicleComponent(VehicleInfo[ new_veh_id - 1 ] [vVehicle ], VehicleInfo[ new_veh_id - 1 ][vComponent][j]);
		}

		SetVehicleNumberPlate(new_veh_id, VehicleInfo[ new_veh_id - 1 ] [vNumber]);

		VehicleInfo[ new_veh_id - 1 ][vMoney] = VehicleInfo[ V_IDX - 1 ][vMoney];
		VehicleInfo[ new_veh_id - 1 ][vFillBag] = VehicleInfo[ V_IDX - 1 ][vFillBag];
		VehicleInfo[ new_veh_id - 1 ][vRepair] = VehicleInfo[ V_IDX - 1 ][vRepair];
		VehicleInfo[ new_veh_id - 1 ][vDrugs] = VehicleInfo[ V_IDX - 1 ][vDrugs];
		VehicleInfo[ new_veh_id - 1 ][vMaterials] = VehicleInfo[ V_IDX - 1 ][vMaterials];
		for(new t = 0; t < 6; t++)
		{
			VehicleInfo[ new_veh_id - 1 ][vBootGun][t] = VehicleInfo[ V_IDX - 1 ][vBootGun][t];
			VehicleInfo[ new_veh_id - 1 ][vBootAmmo][t] = VehicleInfo[ V_IDX - 1 ][vBootAmmo][t];
		} 



		_DestroyVehicle(V_IDX);
		Iter_Remove(PlayerListVehicle[playerid], V_IDX);
		GetVehicleParamsEx(new_veh_id, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1 );
		SetVehicleParamsEx(new_veh_id, engine1, lights2, alarm2, VehicleInfo[ new_veh_id - 1 ] [vLocked], bonnet2, boot1, objective1 );

		new query_[198];
		GameTextForPlayer(playerid, !"~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~CAR ~g~PARKING", 3000, 3 ) ;

		format(query_, sizeof query_, "UPDATE `s_vehicle_player` SET `vPos` = '%.2f|%.2f|%.2f|%.2f',`vWorld` = '%d',`vInt` = '%d' WHERE `vID` = '%d'",
			VehicleInfo[ new_veh_id - 1 ][vPos][0], VehicleInfo[ new_veh_id - 1 ][vPos][1], VehicleInfo[ new_veh_id - 1 ][vPos][2], VehicleInfo[ new_veh_id - 1 ][vPos][3],
			VehicleInfo[ new_veh_id - 1 ][vWorld], VehicleInfo[ new_veh_id - 1 ] [vInt],
			VehicleInfo[ new_veh_id - 1 ][vID] 
		);
		mysql_tquery(dbHandle, query_, "", "");
        UpdateVehiclevText(playerid, new_veh_id, true);
	}
	return 1 ;
} 

CMD:addyacht(playerid) {
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	for(new i; i < sizeof (vehTypeinfo); i++) { 
		if (vehTypeinfo[i][vehType] != TYPE_BOAT) continue;
		CreateSellCar(vehTypeinfo[i][vehID], vehTypeinfo[i][vehCost], vehTypeinfo[i][vehX], vehTypeinfo[i][vehY], vehTypeinfo[i][vehZ], 
			vehTypeinfo[i][vehA], random(255), random(255), vehTypeinfo[i][vehType], vehTypeinfo[i][vehTypeCost]
		);
	}
	new
		string_[128];
	format(string_, sizeof string_, "[Подсказка] Администратор: %s, пополнил Авторынок водного транспорта", pInfo[playerid][pName]);
	SendClientMessageToAll(COLOR_ROSE, string_);
	return 1;
}
CMD:addcar(playerid) {
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	for(new i; i < sizeof (vehTypeinfo); i++) {
		if (vehTypeinfo[i][vehType] != TYPE_CAR) continue;
		CreateSellCar(vehTypeinfo[i][vehID], vehTypeinfo[i][vehCost], vehTypeinfo[i][vehX], vehTypeinfo[i][vehY], vehTypeinfo[i][vehZ], 
			vehTypeinfo[i][vehA], random(255), random(255), vehTypeinfo[i][vehType], vehTypeinfo[i][vehTypeCost]
		);
	}
	new
		string_[128];
	format(string_, sizeof string_, "[Подсказка] Администратор: %s, пополнил Авторынок редкого транспорта", pInfo[playerid][pName]);
	SendClientMessageToAll(COLOR_ROSE, string_);
	return 1;
} 
CMD:addplane(playerid) {
	if (pInfo[playerid][pAdmin] < 10 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	for(new i; i < sizeof (vehTypeinfo); i++) {
		if (vehTypeinfo[i][vehType] != TYPE_PLANE) continue;
		CreateSellCar(vehTypeinfo[i][vehID], vehTypeinfo[i][vehCost], vehTypeinfo[i][vehX], vehTypeinfo[i][vehY], vehTypeinfo[i][vehZ], 
			vehTypeinfo[i][vehA], random(255), random(255), vehTypeinfo[i][vehType], vehTypeinfo[i][vehTypeCost]
		);
	}
	new
		string_[128];
	format(string_, sizeof string_, "[Подсказка] Администратор: %s, пополнил Авторынок воздушного транспорта", pInfo[playerid][pName]);
	SendClientMessageToAll(COLOR_ROSE, string_);
	return 1;
}
CreateSellCar(model, cost, Float: x, Float: y, Float: z, Float: a, color1, color2, type, type_cost)
{  
	new	V_CREATE = _CreateVehicle(model,
		x, y, z, a, color1, color2, -1);

	VehicleInfo[ V_CREATE - 1 ][vModel] = model;
//, 
	new query_[226];
	mysql_format(dbHandle, query_, sizeof query_, "INSERT INTO `s_vehicle_player`(`vModel`,`vOwner`,`vColor`,`vPos`,`vBuyDate`,`vSellCost`,`vTypeCar`,`vTypeCost`) VALUES ('%d','0','%d|%d','%f|%f|%f|%f',NOW(),'%d','%d','%d')",
		model, 
		color1, color2,
		x, y, z, a, cost, type, type_cost
	); 
	mysql_tquery(dbHandle, query_, "create_vehicle_callback", "d", V_CREATE);


	VehicleInfo[ V_CREATE - 1 ][vType] = VEHICLE_TYPE_PLAYER;
	VehicleInfo[ V_CREATE - 1 ][vVehicle] = V_CREATE;
	
	VehicleInfo[ V_CREATE - 1 ][vPos][0] = x;
	VehicleInfo[ V_CREATE - 1 ][vPos][1] = y;
	VehicleInfo[ V_CREATE - 1 ][vPos][2] = z;
	VehicleInfo[ V_CREATE - 1 ][vPos][3] = a;
	VehicleInfo[ V_CREATE - 1 ][vColor][0] = color1;
	VehicleInfo[ V_CREATE - 1 ][vColor][1] = color2;
	VehicleInfo[ V_CREATE - 1 ][vFuel] = GetModelMaxFuel(VehicleInfo[ V_CREATE - 1 ][vModel]);
	VehicleInfo[ V_CREATE - 1 ][vMillage] = 0.0;
	VehicleInfo[ V_CREATE - 1 ][vTempMillage] = 0.0;
	VehicleInfo[ V_CREATE - 1 ][vFine] = 3;
	VehicleInfo[ V_CREATE - 1 ][vSellCost] = cost;
	VehicleInfo[ V_CREATE - 1 ][vTypeCost] = type_cost;
	VehicleInfo[ V_CREATE - 1 ][vTax] = 0;
	VehicleInfo[ V_CREATE - 1 ][vMoney] = 0;
	VehicleInfo[ V_CREATE - 1 ][vFillBag] = 0;
	VehicleInfo[ V_CREATE - 1 ][vRepair] = 0;
	VehicleInfo[ V_CREATE - 1 ][vDrugs] = 0;
	VehicleInfo[ V_CREATE - 1 ][vMaterials] = 0;
	for(new t = 0; t < 6; t++) {
		VehicleInfo[ V_CREATE - 1 ][vBootGun][t] = 0;
		VehicleInfo[ V_CREATE - 1 ][vBootAmmo][t] = 0;
	}

	VehicleInfo[ V_CREATE - 1 ][vLocked] = false;
	GetVehicleParamsEx(V_CREATE, engine1, lights2, alarm2, doors3, bonnet2, boot1, objective1);
	SetVehicleParamsEx(V_CREATE, engine1, lights2, alarm2, false, bonnet2, boot1, objective1);


	VehicleInfo[ V_CREATE - 1 ][vFraction] = 0;
	format(VehicleInfo[ V_CREATE - 1 ][vNumber], 12, "Sale");
	SetVehicleNumberPlate(VehicleInfo[ V_CREATE - 1 ][vVehicle], VehicleInfo[ V_CREATE - 1 ][vNumber]); 
	UpdateSellVehicleInfo(V_CREATE);
}  

		
IsASellCar(vehicleid) {
    if (VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_PLAYER) { 
	    if (VehicleInfo[ vehicleid - 1 ][vSellCost] != 0) return true;
	}
	return false;
}
UpdateSellVehicleInfo(vehicleid)
{
	if (VehicleInfo[ vehicleid - 1 ][vType] == VEHICLE_TYPE_PLAYER)
	{
		new 
			string_[156], type_cost[64];
		if (VehicleInfo[ vehicleid - 1 ][vTypeCost] == TYPE_COST_CASH) {
			format(type_cost, sizeof type_cost, ""colwhi"Цена: "collime"$%d", VehicleInfo[ vehicleid - 1 ][vSellCost]);
		}
		else format(type_cost, sizeof type_cost, ""colwhi"Цена: "collime"%d "DonatePoint"", VehicleInfo[ vehicleid - 1 ][vSellCost]);
		format(string_, sizeof string_, 
			""colmaline"~~~~ Транспорт продаётся ~~~~\n\
			"colwhi"Модель: "colmaline"%s(%d)\n\
			%s\n\
			"colwhi"Номер: "colserver"%s",
			VehicleNames[ VehicleInfo[ vehicleid - 1 ][vModel] - 400 ], VehicleInfo[ vehicleid - 1 ][vModel],
			type_cost, 
			VehicleInfo[ vehicleid - 1 ][vNumber]
		);
		if (VehicleInfo[ vehicleid - 1 ][vSellText] == Text3D:-1) {
			VehicleInfo[ vehicleid - 1 ][vSellText] = CreateDynamic3DTextLabel(string_, COLOR_WHITE, 0.0, 0.0, 1.7, 10.0, INVALID_PLAYER_ID, VehicleInfo[ vehicleid - 1 ][vVehicle]);
		}
		else {
			UpdateDynamic3DTextLabelText(VehicleInfo[ vehicleid - 1 ][vSellText], COLOR_WHITE, string_);
		}
	}
	return true;
}
stock UpdateVehiclevText(playerid, V_IDX, bool: create = false)
{
    if(create) { 
        if (VehicleInfo[ V_IDX - 1 ][vModel] == 508 ) {
            if (VehicleInfo[ V_IDX - 1 ][vText] == Text3D:-1) {
                new 
                    string_[75];
                format(string_, sizeof string_, "Владелец: {10A010}%s\n{FFFFFF}Дверь: %s",
                    pInfo[playerid][pName],
                    VehicleInfo[ V_IDX - 1 ][vLocked] == false ? ("{00CC00}Открыта") : ("{990000}Закрыта")
                );

                VehicleInfo[ V_IDX - 1 ][vText] = CreateDynamic3DTextLabel(string_, 0xFFFFFFFF,
                    VehicleInfo[ V_IDX - 1 ][vPos][0], VehicleInfo[ V_IDX - 1 ][vPos][1], VehicleInfo[ V_IDX - 1 ][vPos][2],
                    7.6, INVALID_PLAYER_ID, VehicleInfo[ V_IDX - 1 ][vVehicle], 0,0, 0, -1
                ); 
                AttachDynamic3DTextLabelToVeh(VehicleInfo[ V_IDX - 1 ][vText], VehicleInfo[ V_IDX - 1 ][vVehicle], 1.4, 0.2, 0.25);
            }
        }
    }
    else {
        if (VehicleInfo[ V_IDX - 1 ][vModel] == 508 && VehicleInfo[ V_IDX - 1 ][vText] != Text3D:-1) {
			new 
                string_[75];
			format(string_, sizeof string_, "Владелец: {10A010}%s\n{FFFFFF}Дверь: %s",
			    pInfo[playerid][pName], VehicleInfo[ V_IDX - 1 ][vLocked] == false ? ("{00CC00}Открыта") : ("{990000}Закрыта")
            ); 
			UpdateDynamic3DTextLabelText(VehicleInfo[ V_IDX - 1 ][vText], 0xFFFFFFFF, string_);
		}
    }
	return 1;
}
stock AttachJobVehicleObjects(v_idx, type = 0)
{
	if (VehicleInfo[v_idx][vType] == VEHICLE_TYPE_JOB)
	{
		if (type == 0)
		{
			if (VehicleInfo[v_idx][vFraction] == PLAYER_JOB_TAXI)
			{
				if (VehicleInfo[v_idx][vSubFraction] == TAXI_SKILL_1)
				{
					VehicleInfo[v_idx][v_object][0] = CreateDynamicObject(19308, VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2], 0.0,0.0, VehicleInfo[v_idx][vPos][3]);
					AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0], VehicleInfo[v_idx][vVehicle] , 0.000000, -0.400000, 0.854999, 0.000000, 0.000000, 0.0);
				}
				else if (VehicleInfo[v_idx][vSubFraction] == TAXI_SKILL_2)
				{
					VehicleInfo[v_idx][v_object][0] = CreateDynamicObject(19308, VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2], 0.0,0.0, VehicleInfo[v_idx][vPos][3]);
					AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0], VehicleInfo[v_idx][vVehicle] , -0.014999, -0.140000, 0.919999, -1.005000, 0.000000, 0.0);
				}
				VehicleInfo[v_idx][v_object][1] = CreateDynamicObject(19327, 0.0, 0.0, -1000.0, 0.0, 0.0, 0.0, 0, 0, -1, 300.0, 300.0);
				SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][1], 0, "{FFFF00}БЕСПЛАТНОЕ ТАКСИ", 90, "Arial", 18, 1, 0xFFFFFF00, 0, 1);
				VehicleInfo[v_idx][v_object][2] = CreateDynamicObject(19327,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0); 
				SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][2],0, "{FFFF00}БЕСПЛАТНОЕ ТАКСИ", 130, "Arial", 34, 1, 0xFFFFFF00, 0, 1);
			}
			else if (VehicleInfo[v_idx][vFraction] == PLAYER_JOB_BUS)
			{
				for(new i; i < 5; i ++){
					VehicleInfo[v_idx][v_object][i] = CreateDynamicObject(19327,0.0,0.0,-1000.0,0.0,0.0,0.0,0,0,-1,300.0,300.0);
				}
				switch(VehicleInfo[v_idx][vSubFraction])
				{
					case 1: {
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][0], 0, "LS", 90, "Arial", 20, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][1], 0, "Городской Лос-Сантос", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][2], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][3], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][4], 0, "Городской Лос-Сантос", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
					}
					case 2:{
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][0], 0, "SF", 90, "Arial", 20, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][1], 0, "Городской Сан-Фиерро", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][2], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][3], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][4], 0, "Городской Сан-Фиерро", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
					}
					case 3:{
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][0], 0, "LV", 90, "Arial", 20, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][1], 0, "Городской Лас-Вентурас", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][2], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][3], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][4], 0, "Городской Лас-Вентурас", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
					}
					case 4:{
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][0], 0, "LV-LS", 90, "Arial", 20, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][1], 0, "Las-Venturas - Los-Santos", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][2], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][3], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][4], 0, "Las-Venturas - Los-Santos", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
					}
					case 5:{
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][0], 0, "LS-SF", 90, "Arial", 20, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][1], 0, "Los-Santos - San-Fierro", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][2], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][3], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][4], 0, "Los-Santos - San-Fierro", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
					}
					case 6:{
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][0], 0, "SF-LV", 90, "Arial", 20, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][1], 0, "San-Fierro - Las-Venturas", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][2], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][3], 0, "• Маршрут №1\n• Маршрут №2\n• Маршрут №3\n\
							• Маршрут №4\n• Маршрут №5", 130, "Arial", 23, 1, 0xFFFFFFFF, 0, 1);
						SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][4], 0, "San-Fierro - Las-Venturas", 90, "Arial", 24, 1, 0xFFFFFFFF, 0, 1);
					}
				}
			}
			goto attach_started;
		}
		else
		{
			attach_started:
			
			if (VehicleInfo[v_idx][vFraction] == PLAYER_JOB_TAXI)
			{
				if (VehicleInfo[v_idx ][vSubFraction] == TAXI_SKILL_1)
				{
					if (IsValidDynamicObject(VehicleInfo[v_idx ][v_object][0]))
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx ][v_object][0],VehicleInfo[v_idx][vVehicle], 0.000000, -0.400000, 0.854999, 0.000000, 0.000000, 0.0);
				}
				else if (VehicleInfo[v_idx ][vSubFraction] == TAXI_SKILL_2)
				{
					if (IsValidDynamicObject(VehicleInfo[v_idx ][v_object][0]))
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx ][v_object][0], VehicleInfo[v_idx][vVehicle], -0.014999, -0.140000, 0.919999, -1.005000, 0.000000, 0.0);
				}
				if (IsValidDynamicObject(VehicleInfo[v_idx ][v_object][1]) && IsValidDynamicObject(VehicleInfo[v_idx ][v_object][2]))
				{
					switch(VehicleInfo[v_idx ][vModel])
					{
						case 405:{
							AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][1], VehicleInfo[v_idx][vVehicle], 0.000, -1.647, 0.372, -62.799, 0.000, 0.000);
							AttachDynamicObjectToVehicle(VehicleInfo[ v_idx ][v_object][2], VehicleInfo[v_idx][vVehicle], 0.019, 0.782, 0.278, -52.199, 0.000, 180.0);
						}
						case 420:{
							AttachDynamicObjectToVehicle(VehicleInfo[v_idx ][v_object][1], VehicleInfo[v_idx][vVehicle],-0.000, -1.842, 0.395, -53.299, 0.000, 360.000);
							AttachDynamicObjectToVehicle(VehicleInfo[v_idx ][v_object][2], VehicleInfo[v_idx][vVehicle], -0.020, 0.899, 0.359, -49.200, 0.099, 180.0);
						}
						case 438:{
							AttachDynamicObjectToVehicle(VehicleInfo[v_idx ][v_object][1], VehicleInfo[v_idx][vVehicle], 0.000, -1.507, 0.359, -34.899, 0.000, 0.000);
							AttachDynamicObjectToVehicle(VehicleInfo[v_idx ][v_object][2], VehicleInfo[v_idx][vVehicle], 0.000, 1.113, 0.308, -26.500, 0.000, 180.0);
						}
						default:{
							AttachDynamicObjectToVehicle(VehicleInfo[v_idx ][v_object][1], VehicleInfo[v_idx][vVehicle], 0.000, -1.402, 0.500, -57.900, 0.000, 0.000);
							AttachDynamicObjectToVehicle(VehicleInfo[v_idx ][v_object][2], VehicleInfo[v_idx][vVehicle], 0.037, 0.948, 0.415, -60.100, 0.000, 180.0);
						}
					}	
				}
			}
			else if (VehicleInfo[v_idx][vFraction] == PLAYER_JOB_BUS)
			{
				if (!IsValidDynamicObject(VehicleInfo[v_idx ][v_object][0])) return 1;
				
				switch(VehicleInfo[v_idx][vModel])
				{
					case 431:
					{
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0], VehicleInfo[v_idx][vVehicle], 0.909, 5.708, 1.664, -6.399, 0.000, -180.0); // LF-LV
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][1], VehicleInfo[v_idx][vVehicle], 1.323, 0.296, 0.650, 0.000, 0.000, 90.0); // San-Fierro - Las-Venturas
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][2], VehicleInfo[v_idx][vVehicle], 1.287, 2.674, 1.420, 0.000, 0.000, 90.0); // маршрут №
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][3], VehicleInfo[v_idx][vVehicle], -1.277, 2.900, 1.460, 0.000, 0.000, -90.0); // маршрут №
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][4], VehicleInfo[v_idx][vVehicle], -1.343, 0.339, 0.650, 0.000, 0.000, -90.0); // San-Fierro - Las-Venturas
					}
					case 437:
					{
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0], VehicleInfo[v_idx][vVehicle],  -0.451, 5.415, 1.740, 0.000, 0.000, 180.0); // LF-LV
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][1], VehicleInfo[v_idx][vVehicle], -1.319, -3.421, 0.720, 0.000, 0.000, -90.0);
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][2], VehicleInfo[v_idx][vVehicle], -1.323, 4.077, 1.330, 0.000, 0.000, -90.0);
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][3], VehicleInfo[v_idx][vVehicle], 1.261, 3.454, 1.330, 0.000, 0.000, 90.0);
						AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][4], VehicleInfo[v_idx][vVehicle], 1.309, -3.390, 0.750, 0.000, 0.000, 90.0); 
					}
				}
			}
		}
	}
	else if (VehicleInfo[v_idx][vType] == VEHICLE_TYPE_FRACTION)
	{
		if (type == 0)
		{
			if (VehicleInfo[v_idx][vFraction] == FRACTION_AUTOSCHOOL && VehicleInfo[v_idx][vModel] == 426 )
			{
				VehicleInfo[v_idx][v_object][0] = CreateDynamicObject(19309, VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2], 0.0,0.0, VehicleInfo[v_idx][vPos][3]);
				SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][0],0,"Учебная",50,"Arial",26,1,-1, -65536, 1);
			}
			/*if ((VehicleInfo[v_idx][vFraction] == FRACTION_LSPD || VehicleInfo[v_idx][vFraction] == FRACTION_SFPD || VehicleInfo[v_idx][vFraction] == FRACTION_LVPD) && VehicleInfo[v_idx][vModel] == 497) {
				VehicleInfo[v_idx][v_object][0] = CreateDynamicObject(2679,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][0], 0, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][0], 1, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][0], 2, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][0], 3, 14674, "civic02cj", "sl_hotelwallplain1", 0);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0] ,  VehicleInfo[v_idx][vVehicle], 1.841, 0.171, -0.972, 89.999, 0.000, 0.000);
				VehicleInfo[v_idx][v_object][1] = CreateDynamicObject(2679,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][1], 0, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][1], 1, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][1], 2, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][1], 3, 14674, "civic02cj", "sl_hotelwallplain1", 0);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][1] ,  VehicleInfo[v_idx][vVehicle], 1.839, 1.476, -0.975, 89.799, 0.000, 0.000);
				VehicleInfo[v_idx][v_object][2] = CreateDynamicObject(2678,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][2], 0, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][2], 1, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][2], 2, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][2], 3, 14674, "civic02cj", "sl_hotelwallplain1", 0);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][2] ,  VehicleInfo[v_idx][vVehicle], -1.859, 0.169, -1.011, 89.400, 0.000, 0.000);
				VehicleInfo[v_idx][v_object][3] = CreateDynamicObject(2678,0.0,0.0,-1000.0,0.0,0.0,0.0,-1,-1,-1,300.0,300.0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][3], 0, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][3], 1, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][3], 2, 10765, "airportgnd_sfse", "black64", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][3], 3, 14674, "civic02cj", "sl_hotelwallplain1", 0);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][3] ,  VehicleInfo[v_idx][vVehicle], -1.861, 1.460, -1.020, 89.999, 0.000, 0.000);
			}*/
			/*if (VehicleInfo[v_idx][vFraction] == FRACTION_MONGOLS_MC && VehicleInfo[v_idx][vModel] == 463)
			{
				VehicleInfo[v_idx][v_object][0] = CreateDynamicObject(19579,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][0], 0, 1560, "7_11_door", "cj_sheetmetal2", -15724528);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0] ,  VehicleInfo[v_idx][vVehicle], 0.000, -1.041, 0.170, 20.000, 0.000, 0.000);

				VehicleInfo[v_idx][v_object][1] = CreateDynamicObject(19624,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][1], 0, 16640, "a51", "Metal3_128", -1);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][1], 1, 1560, "7_11_door", "cj_sheetmetal2", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][1], 2, 19480, "signsurf", "sign", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][1], 3, 19480, "signsurf", "sign", 0);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][1] ,  VehicleInfo[v_idx][vVehicle], 0.000, -1.106, 0.341, 20.000, 0.000, 0.000);

				VehicleInfo[v_idx][v_object][2] = CreateDynamicObject(2914,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][2], 0, 12979, "sw_block9", "sw_bikeshed", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][2], 1, 18901, "matclothes", "bandanaskull", 0); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][2],  VehicleInfo[v_idx][vVehicle], 0.000, -1.067, 0.153, 0.000, 20.000, -90.000);

				VehicleInfo[v_idx][v_object][3] = CreateDynamicObject(2914,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][3], 0, 19480, "signsurf", "sign", 0);
				SetDynamicObjectMaterial(VehicleInfo[v_idx][v_object][3], 1, 18901, "matclothes", "bandanaskull", 0);
				//SetDynamicObjectMaterialText(VehicleInfo[v_idx][v_object][3], 2, "HELLS ANGELS MC", 130, "Calibri", 75, 1, -65536, 0, 1);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][3],  VehicleInfo[v_idx][vVehicle], -0.002, -1.067, 0.153, 0.000, 20.000, 270.000);

				

				VehicleInfo[v_idx][v_object][4] = CreateDynamicObject(2680,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][4],  VehicleInfo[v_idx][vVehicle], 0.000, -1.311, 0.059, -10.000, 0.000, 0.000);

				VehicleInfo[v_idx][v_object][5] = CreateDynamicObject(2680,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][5],  VehicleInfo[v_idx][vVehicle], 0.000, 0.000, 0.000, 0.000, 0.000, 0.000);

				VehicleInfo[v_idx][v_object][6] = CreateDynamicObject(1104,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][6],  VehicleInfo[v_idx][vVehicle], -0.611, 0.356, -0.124, -10.000, -60.000, 90.000);

				VehicleInfo[v_idx][v_object][7] = CreateDynamicObject(1104,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][7],  VehicleInfo[v_idx][vVehicle], 0.611, 0.356, -0.124, -10.000, 60.000, -90.000);

				VehicleInfo[v_idx][v_object][8] = CreateDynamicObject(1111,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][8],  VehicleInfo[v_idx][vVehicle], 0.150, 0.380, 0.412, 20.000, 90.000, -7.699);

				VehicleInfo[v_idx][v_object][9] = CreateDynamicObject(1111,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][9],  VehicleInfo[v_idx][vVehicle], -0.150, 0.380, 0.412, 20.000, -90.000, 7.699);

				VehicleInfo[v_idx][v_object][10] = CreateDynamicObject(18701,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][10],  VehicleInfo[v_idx][vVehicle], -1.371, -0.570, -0.250, 0.000, -90.000, 180.000);

				VehicleInfo[v_idx][v_object][11] = CreateDynamicObject(18701,VehicleInfo[v_idx][vPos][0], VehicleInfo[v_idx][vPos][1], VehicleInfo[v_idx][vPos][2],0.0,0.0,VehicleInfo[v_idx][vPos][3]);
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][11],  VehicleInfo[v_idx][vVehicle], -1.371, -0.570, -0.320, 0.000, 90.000, 360.000); 
			}*/
			goto attach_frac_started;
		}
		else
		{
			attach_frac_started:
			if (VehicleInfo[v_idx][vFraction] == 11 && VehicleInfo[v_idx][vModel] == 426 && IsValidDynamicObject(VehicleInfo[v_idx ][v_object][0]))
			{
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0], VehicleInfo[v_idx][vVehicle],  0.0, -0.4, 0.9, 0.0, 0.0, 0.0);
			}
			/*if ((VehicleInfo[v_idx][vFraction] == FRACTION_LSPD || VehicleInfo[v_idx][vFraction] == FRACTION_SFPD || VehicleInfo[v_idx][vFraction] == FRACTION_LVPD) && VehicleInfo[v_idx][vModel] == 497 && IsValidDynamicObject(VehicleInfo[v_idx][v_object][0])) { 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0], VehicleInfo[v_idx][vVehicle], 1.841, 0.171, -0.972, 89.999, 0.000, 0.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][1], VehicleInfo[v_idx][vVehicle], 1.839, 1.476, -0.975, 89.799, 0.000, 0.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][2], VehicleInfo[v_idx][vVehicle], -1.859, 0.169, -1.011, 89.400, 0.000, 0.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][3], VehicleInfo[v_idx][vVehicle], -1.861, 1.460, -1.020, 89.999, 0.000, 0.000);
			}*/
			/*if (VehicleInfo[v_idx][vFraction] == FRACTION_MONGOLS_MC && VehicleInfo[v_idx][vModel] == 463 && IsValidDynamicObject(VehicleInfo[v_idx ][v_object][0]))
			{ 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][0],  VehicleInfo[v_idx][vVehicle], 0.000, -1.041, 0.170, 20.000, 0.000, 0.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][1],  VehicleInfo[v_idx][vVehicle], 0.000, -1.106, 0.341, 20.000, 0.000, 0.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][2],  VehicleInfo[v_idx][vVehicle], 0.000, -1.067, 0.153, 0.000, 20.000, -90.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][3],  VehicleInfo[v_idx][vVehicle], -0.002, -1.067, 0.153, 0.000, 20.000, 270.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][4],  VehicleInfo[v_idx][vVehicle], 0.000, -1.311, 0.059, -10.000, 0.000, 0.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][5],  VehicleInfo[v_idx][vVehicle], 0.000, 0.000, 0.000, 0.000, 0.000, 0.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][6],  VehicleInfo[v_idx][vVehicle], -0.611, 0.356, -0.124, -10.000, -60.000, 90.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][7],  VehicleInfo[v_idx][vVehicle], 0.611, 0.356, -0.124, -10.000, 60.000, -90.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][8],  VehicleInfo[v_idx][vVehicle], 0.150, 0.380, 0.412, 20.000, 90.000, -7.699); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][9],  VehicleInfo[v_idx][vVehicle], -0.150, 0.380, 0.412, 20.000, -90.000, 7.699); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][10],  VehicleInfo[v_idx][vVehicle], -1.371, -0.570, -0.250, 0.000, -90.000, 180.000); 
				AttachDynamicObjectToVehicle(VehicleInfo[v_idx][v_object][11],  VehicleInfo[v_idx][vVehicle], -1.371, -0.570, -0.320, 0.000, 90.000, 360.000); 
			}*/
		}
	}
	return 1;
}

stock SaveBootVehiclePlayer(vehicleid)
{
    new 
        query_[300];
	format(query_, sizeof query_,
        "UPDATE "TABLE_VEHICLE_PLAYER" SET `vRepair` = '%d',`vFillBag` = '%d', `vMoney` = '%d', `vDrugs` = '%d', `vMaterials` = '%d', `vGun` = '%d,%d,%d,%d,%d,%d', `vAmmo` = '%d,%d,%d,%d,%d,%d' WHERE `vID` = '%d' LIMIT 1",
	    VehicleInfo[ vehicleid - 1 ][vRepair], VehicleInfo[ vehicleid - 1 ][vFillBag], VehicleInfo[ vehicleid - 1 ][vMoney], VehicleInfo[ vehicleid - 1 ][vDrugs], VehicleInfo[ vehicleid - 1 ][vMaterials],
	    VehicleInfo[ vehicleid - 1 ][vBootGun][0], VehicleInfo[ vehicleid - 1 ][vBootGun][1], VehicleInfo[ vehicleid - 1 ][vBootGun][2], VehicleInfo[ vehicleid - 1 ][vBootGun][3], VehicleInfo[ vehicleid - 1 ][vBootGun][4], VehicleInfo[ vehicleid - 1 ][vBootGun][5],
	    VehicleInfo[ vehicleid - 1 ][vBootAmmo][0], VehicleInfo[ vehicleid - 1 ][vBootAmmo][1], VehicleInfo[ vehicleid - 1 ][vBootAmmo][2], VehicleInfo[ vehicleid - 1 ][vBootAmmo][3], VehicleInfo[ vehicleid - 1 ][vBootAmmo][4], VehicleInfo[ vehicleid - 1 ][vBootAmmo][5],
	    VehicleInfo[ vehicleid - 1 ][vID]
    );
	mysql_tquery(dbHandle, query_); 
}
stock SaveBootVehicleServer(vehicleid)
{
    new 
        query_[300];
 	format(query_, sizeof query_,
        "UPDATE "TABLE_VEHICLE_SERVER" SET `vRepair` = '%d',`vFillBag` = '%d', `vMoney` = '%d', `vDrugs` = '%d', `vMaterials` = '%d', `vGun` = '%d,%d,%d,%d,%d,%d', `vAmmo` = '%d,%d,%d,%d,%d,%d' WHERE `vID` = '%d' LIMIT 1",
	    VehicleInfo[ vehicleid - 1 ][vRepair], VehicleInfo[ vehicleid - 1 ][vFillBag], VehicleInfo[ vehicleid - 1 ][vMoney], VehicleInfo[ vehicleid - 1 ][vDrugs], VehicleInfo[ vehicleid - 1 ][vMaterials],
	    VehicleInfo[ vehicleid - 1 ][vBootGun][0], VehicleInfo[ vehicleid - 1 ][vBootGun][1], VehicleInfo[ vehicleid - 1 ][vBootGun][2], VehicleInfo[ vehicleid - 1 ][vBootGun][3], VehicleInfo[ vehicleid - 1 ][vBootGun][4], VehicleInfo[ vehicleid - 1 ][vBootGun][5],
	    VehicleInfo[ vehicleid - 1 ][vBootAmmo][0], VehicleInfo[ vehicleid - 1 ][vBootAmmo][1], VehicleInfo[ vehicleid - 1 ][vBootAmmo][2], VehicleInfo[ vehicleid - 1 ][vBootAmmo][3], VehicleInfo[ vehicleid - 1 ][vBootAmmo][4], VehicleInfo[ vehicleid - 1 ][vBootAmmo][5],
	    VehicleInfo[ vehicleid - 1 ][vID]
    );
	mysql_tquery(dbHandle, query_); 
}
stock SaveFractionVehicleServer(vehicleid)
{
    new 
        query_[128];
 	format(query_, sizeof query_,
        "UPDATE "TABLE_VEHICLE_SERVER" SET `vTempModel` = '%d',`vTimeModel` = '%d',`vRank` = '%d' WHERE `vID` = '%d' LIMIT 1",
	    VehicleInfo[vehicleid][vTempModel], 
	    VehicleInfo[vehicleid][vTimeModel],
		VehicleInfo[vehicleid][vRank],
	    VehicleInfo[vehicleid][vID]
    );
	mysql_tquery(dbHandle, query_); 
}

 

CMD:vowner ( playerid )
{
	if (pInfo[playerid][pAdmin] < 3 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	new _str [ 64 ] ;
	new
		V_IDX = GetPlayerVehicleID ( playerid );
	format( _str, 32, "%d model %d owner %d type [-1]",VehicleInfo [ V_IDX - 1 ] [vModel], VehicleInfo [ V_IDX - 1 ] [ vFraction ], VehicleInfo [ V_IDX - 1 ] [ vType ] ) ;
	SendClientMessage ( playerid, -1, _str ) ;
	format( _str, 32, "%d owner %d type", VehicleInfo [ V_IDX ] [ vFraction ], VehicleInfo [ V_IDX ] [ vType ] ) ;
	SendClientMessage ( playerid, -1, _str ) ;
	format( _str, sizeof _str, "Max Fuel: %f", GetModelMaxFuel(VehicleInfo [ V_IDX - 1 ] [vModel]));
	SendClientMessage ( playerid, -1, _str ) ;
	return 1 ;
}	

CMD:newvehpos( playerid )
{
	new 
		Float: pos_[4],
		V_IDX = GetPlayerVehicleID(playerid);

	if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) return SendClientMessage(playerid, COLOR_GRAD2, !"Вы не в машине!");

	GetVehiclePos(V_IDX, pos_[0], pos_[1], pos_[2]);
	GetVehicleZAngle(V_IDX, pos_[3]);
	new 
        query_[300];
 	format(query_, sizeof query_,
        "UPDATE `s_vehicle_server` SET `vPos` = '%f|%f|%f|%f' WHERE `vID` = '%d'",
	   	pos_[0], pos_[1], pos_[2], pos_[3],
	    VehicleInfo[ V_IDX - 1 ][vID]
    );
	mysql_tquery(dbHandle, query_); 

	SendClientMessage(playerid, -1, "pos save");
	return 1;
}
