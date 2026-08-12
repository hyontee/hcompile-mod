
#define @p playerid

#define SPD ShowPlayerDialog

#define SCM SendClientMessage

#define U_Day 86400
#define gpvi GetPVarInt
#define spvi SetPVarInt



enum E_HOUSE_SERVER
{
    hID,
	Float: hEnter[3],
	Float: hCar[4],
	hOwner[MAX_PLAYER_NAME + 1],
    hFamily,
	hValue,
    hReturnValue,
	hHel,
	hVirtualWorld,
	hIntID,
	hGarageID,
	hLock,
	hTakings,
	hKlass,
	hPickup[3],
    hArea,
	hMIcon,
	hSafe[4],
	hSafeGun[6],
	hSafeAmmo[6], 
    rentable,rentsumma, 
	
    Text3D: hClothesText,
	Text3D: hExitText,
    Text3D: hGarageText,
    Text3D: hGarageExitText,

    hAreaRob[2],
    hPickupRob,
    Text3D: hTextRob,
    hCountItemRob[2],
	bool: hRobHouse
};
new HouseInfo[HOUSE_COUNT][E_HOUSE_SERVER], TOTALHOUSE = 0; 

/* Moretti */
enum G_ENUM
{
    gID,

    gCoast,
    gVirtualWorld,
    gPickUp,
}
new GarageHouse [ HOUSE_COUNT ] [ G_ENUM ];
/* Moretti */

enum E_INTERIOR_GARAGE
{
	gIntID,
	gIntName[32],
	gIntInterior,
	gVehicleCount,
    //Float: gIntPos[4], 
	Float: gEnterPos[4],
	Float: gCarPos_0[4],
	Float: gCarPos_1[4],
	Float: gCarPos_2[4],
	Float: gCarPos_3[4],
	Float: gCarPos_4[4],
	Float: gExitCar[3]
}
new GarageInt[][E_INTERIOR_GARAGE] = {
    {0, "Гараж 2-х местный", G_GTA5_INTERIOR, 2, //Действущий 
        {1361.4928,-27.6118,1000.9219,355.1108},  
        {1376.5686,-21.1362,1000.6509,251.1899}, //Car 1
        {1370.4001,-25.1288,1000.6490,270.7324}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {1379.7710, -22.8385, 1000.9250}
    },
    {1, "Гараж Эконом", G_ECO_INTERIOR, 2, //Действущий 
        {1843.8673,717.8274,1067.9113,0.5075},  
        {1844.3978,725.2849,1067.6383,0.3257}, 
        {1850.0236,725.4982,1067.6384,1.1771}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {1846.7461,728.9247,1067.9113}
    },
    {2, "Гараж 2-х местный", GARAGE_E_INT, 2, //Добавить платформу
        {1380.2573,-21.8467,1000.9248,263.1689}, 
        {1397.5087,-21.0297,1000.6439,167.2334}, 
        {1389.7920,-21.9033,1000.6447,168.5720},  
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {1390.2886,-26.2456,1000.9168} 
    },//
    {3, "Гараж 2-х местный", GARAGE_B_INT, 2, //Добавить платформу
        {1402.1847,-27.4075,1000.9203,0.6062}, 
        {1396.4545,-22.8298,1000.6472,278.2398}, 
        {1397.3187,-14.6153,1000.6472,255.4398},  
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {1406.9078,-18.5987,1000.9216} 
    },//
    {4, "Гараж 3-х местный", GARAGE_A_INT, 3, 
        {1397.8826,-20.7496,1000.9168,90.6952}, 
        {1395.1497,-13.8853,1000.6443,140.0585},
        {1388.6041,-13.7106,1000.6448,140.0585},
        {1380.3196,-14.3738,1000.6517,181.6701}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {1378.3525,-20.9466,1000.9257}
    },
    {5, "Гараж 4-х местный", GARAGE_S_INT, 4, 
        {1378.6563,-22.9149,1000.9256,266.2679}, 
        {1400.5675,-24.7771,1000.6464,304.8275},
        {1389.8608,-24.7011,1000.6467,306.1663},
        {1391.8209,-12.6941,1000.6470,240.6840}, 
        {1400.0695,-13.2477,1000.6470,228.9137}, 
        {0.0, 0.0, 0.0, 0.0}, 
        {1410.0875,-18.2931,1000.9232}
    }
}; 
enum E_INTERIOR_HOUSE
{
	hIntID,
	hIntInterior,
	hIntCost,
	hIntClass,
	Float: hIntPos[3], 
	hIntName[32],
	Float: hClothes[3], 
    Float: hSafePos[6]
}
new HouseInt[][E_INTERIOR_HOUSE] = {
//static const HouseInt[35][E_INTERIOR_HOUSE] = {
/*ID, INT, COST, Class, Coord*/
{0, 2, 100_000, 0, {267.4610, 304.9829, 999.1484}, "Хиппи стиль", {267.1403, 303.4059, 999.1484}, {271.63727, 309.19241, 998.58881, 0.00000, 0.00000, -1.00000}},//1 NOPE
{1, 10, 100_000, 0, {421.5309, 2536.5486, 10.0000}, "Лачуга", {415.1374, 2534.9619, 10.0000}, {415.49210, 2539.70996, 9.81640, 0.00000, 0.00000, 91.00000}},//2
{2, 5, 100_000, 0, {2233.6919, -1112.8107, 1050.8828}, "Комната", {2231.7356, -1112.2380, 1050.8828}, {2235.47876, -1110.62146, 1050.96179, 0.00000, 0.00000, -91.00000}},//3 ///////////////////////1
{3, 1, 100_000, 0, {2217.9087, -1076.3169, 1050.4844}, "Красный дом", {2215.8215,-1074.6964, 1050.4844}, {2213.79883, -1078.97571, 1050.77783, 0.00000, 0.00000, 178.00000}}, //4
{4, 2, 100_000, 0, {2467.8691, -1698.3516, 1013.5078}, "Грязный дом", {2455.9214, -1700.5446, 1013.5078}, {2453.17798, -1687.45679, 1013.89221, 0.00000, 0.00000, -91.00000}}, //5 Конец NOPE

{5, 10, 200_000, 1, {2261.3103, -1136.4467, 1050.6328}, "Дешевый стиль", {2263.0842, -1132.6631, 1050.6328}, {2264.95654, -1142.88159, 1050.96216, 0.00000, 0.00000, 179.00000}},//1 D Class
{6, 15, 200_000, 1, {327.8892, 1477.9272, 1084.4375}, "Пустой дом", {335.9887, 1480.9871, 1084.4364}, {329.77271, 1477.32751, 1084.83606, 0.00000, 0.00000, 180.00000}},//2 Заказать Интерьеры D Class 5 штук
{7, 15, 200_000, 1, {386.7251, 1471.6462, 1080.1949}, "Пустой дом", {377.6802, 1461.8710, 1080.1875}, {386.21149, 1470.09106, 1080.47559, 0.00000, 0.00000, 180.00000}},//3
{8, 4, 200_000, 1, {261.0327, 1284.4261, 1080.2578}, "Пустой дом", {264.3949, 1285.9189, 1080.2578}, {250.52232, 1290.99609, 1080.64478, 0.00000, 0.00000, 180.00000}},//4 Пустой
{9, 8, 200_000, 1, {-42.5901, 1405.5869, 1084.4297}, "Пустой дом", {-52.5169, 1403.8401, 1084.4297}, {-40.41080, 1411.82495, 1084.87146, 0.00000, 0.00000, 270.00000}},//5 //Прыгает варнинг (s007)
{10, 9, 200_000, 1, {260.7397, 1237.3687, 1084.2578}, "Пустой дом", { 260.6448, 1255.4097, 1084.2578}, {257.18350, 1243.13745, 1084.65564, 0.00000, 0.00000, 180.00000}},//6 Конец D Class

{11, 10, 300_000, 2, {2269.5125, -1210.5259, 1047.5625}, "Уютный домик", {2262.7839,-1216.7322,1049.0234}, {2263.14844, -1220.75122, 1049.50610, 0.00000, 0.00000, -90.00000}},//1 C Class
{12, 15, 300_000, 2, {295.0497, 1473.2526, 1080.2578}, "Пустой дом", { 304.7436,1471.2416,1080.2651}, {286.03909, 1479.23779, 1080.64038, 0.00000, 0.00000, 180.00000}},//2 //Прыгает варнинг//295.1081,1472.2552,1080.2578
{13, 15, 300_000, 2, {376.3149, 1417.2452, 1081.3281}, "Пустой дом", { 369.9906,1409.3152,1081.3345}, {376.53021, 1415.55591, 1081.57397, 0.00000, 0.00000, 180.00000}},//3 //Прыгает варнинг
{14, 2, 300_000, 2, {447.0495, 1398.1041, 1084.3047}, "Пустой дом", {443.3055,1399.4373,1084.3132}, {459.69257, 1407.95374, 1084.91614, 0.00000, 0.00000, 270.00000}},//4 | Пустой
{15, 5, 300_000, 2, {22.7479, 1404.0393, 1084.4297}, "Домашний стиль", {21.7159,1414.6810,1084.4297}, {14.78900, 1411.45532, 1085.08069, 0.00000, 0.00000, 90.00000}},//5
{16, 6, 300_000, 2, {-68.8678, 1352.1532, 1080.2109}, "Пустой дом", {-70.4734,1365.5361,1080.2109}, {-70.96730, 1353.02112, 1080.78552, 0.00000, 0.00000, 90.00000}},//6
{17, 8, 300_000, 2, {2807.6147, -1173.7506, 1025.5703}, "Оружейный дом", {2807.3591,-1165.1394,1025.5703}, {2805.02661, -1172.05994, 1025.78284, 0.00000, 0.00000, 90.00000}},//7
{18, 2, 300_000, 2, {2237.5376, -1080.5271, 1049.0234}, "Современный стиль", {2235.8845,-1073.9330,1049.0234}, {2235.39233, -1071.82239, 1049.43372, 0.00000, 0.00000, 90.00000}},//8
{19, 8, 300_000, 2, {2365.1992, -1134.6941, 1050.8750}, "Зеркальный интерьер", {2363.7671,-1127.4722,1050.8826}, {2376.31006, -1128.08984, 1050.98438, 0.00000, 0.00000, -90.00000}},//9 Конец C Class

{20, 2, 400_000, 3, {491.1569, 1399.1304, 1080.2578}, "Пустой красный дом", {228.3887,1195.7487,1080.2645}, {493.75800, 1413.35767, 1084.79822,0.00000, 0.00000, 270.00000}},//1 B Calss
{21, 10, 400_000, 3, {23.7754, 1341.2480, 1084.3750}, "Пустой 2-х этажный", {23.4715,1349.0693,1088.8750}, {27.59996, 1339.71667, 1089.56177, 0.00000, 0.00000, 180.00000}},//2 /Пустой
{22, 12, 400_000, 3, {2324.3342, -1148.4485, 1050.7101}, "Особняк", {2311.0996,-1135.9833,1054.3047}, {2328.30566, -1136.55115, 1050.69165, 0.00000, 0.00000, 0.00000}},//3
{23, 4, 400_000, 3, {-262.1759, 1456.6158, 1084.3672}, "Деревянный стиль", {-270.5288,1451.5757,1088.8672}, {-262.75821, 1458.84497, 1084.94836, 0.00000, 0.00000, 0.00000}},//5
{24, 3, 400_000, 3, {235.2905, 1187.5282, 1080.2578}, "Пустой красный дом",{ 228.3887,1195.7487,1080.2645}, {234.09001, 1186.35925, 1084.88049, 0.00000, 0.00000, 180.00000}},//6 Конец B Class

{25, 9, 500_000, 4, {2317.7722, -1026.1692, 1050.2178}, "Дорогой интерьер", {2316.1655,-1010.7783,1054.7188}, {2315.64014, -1025.84045, 1050.85571,0.00000, 0.00000, 90.00000}},//1 A Class
{26, 5, 500_000, 4, {226.9458, 1114.2930, 1080.9962}, "Большой мрамор пустой", {230.8530,1111.2870,1080.9922}, {248.65100, 1116.06311, 1081.63794,0.00000, 0.00000, 270.00000}},//2
{27, 5, 500_000, 4, {140.2581, 1366.7158, 1083.8594}, "Дворец", {141.1709,1382.5786,1083.8672}, {138.27589, 1375.10754, 1084.41748,0.00000, 0.00000, 270.00000}},//3
{28, 6, 500_000, 4, {234.2826, 1065.229, 1084.2101}, "Мрамор", {235.5965,1079.4858,1087.8126}, {237.91389, 1066.03455, 1084.68274,0.00000, 0.00000, 270.00000}},//4,
{29, 7, 500_000, 4, {225.6309, 1022.4799, 1084.0699}, "Евро дом", {233.2849,1046.3265,1084.0142}, {232.08603, 1040.17590, 1088.81189,0.00000, 0.02000, 0.00000}},//5 Конец A Class

{30, 9, 500_000, 4, {2317.7722, -1026.1692, 1050.2178}, "Дорогой интерьер", {2316.1655,-1010.7783,1054.7188}, {2315.64014, -1025.84045, 1050.85571,0.00000, 0.00000, 90.00000}},//1 S Class
{31, 5, 500_000, 4, {226.9458, 1114.2930, 1080.9962}, "Большой мрамор пустой", {230.8530,1111.2870,1080.9922}, {248.65100, 1116.06311, 1081.63794,0.00000, 0.00000, 270.00000}},//2
{32, 5, 500_000, 4, {140.2581, 1366.7158, 1083.8594}, "Дворец", {141.1709,1382.5786,1083.8672}, {138.27589, 1375.10754, 1084.41748,0.00000, 0.00000, 270.00000}},//3
{33, 6, 500_000, 4, {234.2826, 1065.229, 1084.2101}, "Мрамор", {235.5965,1079.4858,1087.8126}, {237.91389, 1066.03455, 1084.68274,0.00000, 0.00000, 270.00000}},//4,
{34, 7, 500_000, 4, {225.6309, 1022.4799, 1084.0699}, "Евро дом", {233.2849,1046.3265,1084.0142}, {232.08603, 1040.17590, 1088.81189,0.00000, 0.02000, 0.00000}}//5 Конец S Class
}; 
static const defaultHouseCost[] = {
	50_000_000, 10000000, 16000000, 1500000, 1500000, 2500000,30000000,30000000,16000000,5000000, /*1 - 20 */
	16000000,9000000,30000000,5000000,1500000,1500000,2500000,16000000,2500000,2500000,16000000,2500000,
	1500000,1500000,2500000,1500000,2500000,2500000,2500000,2500000,30000000,30000000,30000000,
	16000000,30000000,500000,2500000,16000000,16000000,9000000,30000000,2500000,2500000,1500000,1500000,2500000,
	1500000,1500000,1500000,2500000,1500000,2500000,1500000,2500000,1500000,2500000,1500000,
	1500000,1500000,30000000,2500000,2500000,2500000,2500000,350000,350000,
	1500000,1500000,2500000,2500000,350000,350000,350000,350000,350000,350000,350000,350000,1500000,1500000,
	1500000,1500000,1500000,500000,2500000,2500000,350000,500000,500000,
	350000,500000,500000,500000,500000,500000,500000,500000,500000,500000,500000,350000, 350000, 500000, 350000, 1500000, 700000, 350000, 350000, 350000, 500000, 500000, 1500000, 
	500000, 350000, 500000, 350000, 500000, 350000, 790000, 500000, 350000, 30000000, 350000, 350000, 500000, 500000, 350000, 500000, 1500000, 500000, 500000, 1500000, 500000, 500000, 500000, 350000, 350000, 350000,
	350000, 350000, 350000, 500000, 500000, 350000, 350000, 500000, 350000, 500000, 500000, 500000, 500000, 350000, 500000, 350000, 500000, 700000, 500000, 500000, 1500000, 
	2500000, 1500000, 350000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 350000, 350000, 350000, 2500000, 500000, 500000, 500000, 500000, 
	350000, 350000, 500000, 350000, 350000, 500000, 500000,
	500000, 500000, 500000, 350000, 350000, 500000, 350000, 500000, 350000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 350000, 350000, 1500000, 500000, 350000, 500000, 
	500000, 350000, 350000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 350000, 350000, 500000, 500000, 350000, 350000, 500000, 500000,
	500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 350000, 350000, 500000, 900000, 1500000, 1500000, 350000, 500000, 500000, 500000, 
	700000, 500000, 500000, 500000, 350000, 350000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 350000, 350000, 350000, 500000, 500000, 350000, 350000, 1500000, 350000,
	1500000, 500000, 500000, 350000, 500000, 350000, 500000, 350000, 500000, 350000, 500000, 500000, 350000, 500000, 1500000, 500000, 500000, 500000, 350000, 350000, 350000, 
	350000, 350000, 350000, 350000, 350000, 500000, 500000, 500000, 350000, 500000, 350000, 500000, 500000, 500000, 350000, 350000, 500000, 500000,
	1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 2500000, 2500000, 1500000, 1500000, 500000, 500000, 500000, 1500000, 1500000, 1500000, 1500000, 
	500000, 1500000, 1500000, 500000, 500000, 1500000, 500000, 500000, 500000, 1500000, 1500000, 1500000, 1500000, 1500000, 500000, 1500000, 1500000, 500000, 500000,
	1500000, 1500000, 500000, 1500000, 1500000, 1500000, 500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 500000, 1500000, 1500000, 1500000, 2500000,
	1500000, 1500000, 1500000, 500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 500000, 800000, 1500000, 1500000, 800000, 1500000, 800000, 800000, 1500000, 1500000, 
	1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 800000, 1500000,
	1500000, 1500000, 800000, 500000, 1500000, 1500000, 1500000, 500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 800000, 500000, 1500000, 1500000, 
	1500000, 2500000, 1500000, 800000, 800000, 800000, 1500000, 1500000, 1500000, 1500000, 1500000,
	500000, 1500000, 1500000, 1500000, 1500000, 1500000, 1500000, 2500000, 1500000, 1500000, 1500000, 800000, 1500000, 500000, 1500000, 1500000, 700000, 16000000, 1500000, 2500000, 2500000, 2500000, 7500000, 2500000, 1500000, 2500000, 7500000, 500000,
	1500000,1500000,1500000,1500000,1500000,1500000,1500000,1500000,800000,1500000,800000,800000,800000,1500000,1500000,800000,1500000,1500000,800000,1500000,
	800000,1500000,1500000,1500000,1500000,1500000,1500000,1500000,1500000,1500000,1500000,2500000,2500000,2500000,16000000,16000000,16000000,
	16000000,16000000,16000000,2500000,1300000,2500000,1300000,1300000,1500000,800000,2500000,1500000,2500000,2500000,2500000,2500000,2500000,2500000,2500000,2500000,
	1500000,2500000,2500000,2500000,2500000,2500000,2500000,2500000,600000,2500000,350000,
	800000, 350000, 800000, 350000, 800000, 350000, 1500000, 350000, 30000000, 9000000, 2500000, 2500000, 30000000, 2500000, 1500000, 350000, 350000, 800000, 350000, 
	1500000, 1500000, 350000, 1500000, 350000, 1500000, 350000, 1500000, 350000, 30000000, 1500000, 800000, 350000,350000,350000,1500000,350000,
	800000, 1500000, 350000, 1500000, 350000, 350000, 1500000, 350000, 800000, 350000, 2500000, 350000, 1500000, 20000000, 350000, 1500000, 350000, 800000, 350000, 350000, 2500000, 1500000, 2500000,
	350000,1500000,350000,350000,350000,1500000,2500000,350000,1500000,350000,600000,600000,350000,350000,1500000,350000,1500000,350000,
	2500000,800000,350000,800000,350000,900000,350000,350000,1500000,350000,1500000,350000,1500000,1500000,1500000,1500000,1500000,1500000,1500000,500000,1500000,2500000,
	1500000,30000000,2500000,2500000,1500000,2500000,1500000,1500000,1500000,2500000,1500000,1500000,1500000,1500000,2500000,1500000,1500000,1900000,2500000,
	2500000, 2500000, 350000, 350000, 350000, 350000, 350000, 1500000, 1500000, 350000, 350000, 1500000, 1500000, 1500000, 1500000, 1500000,
	1500000, 1500000, 350000, 350000, 2500000, 30000000, 2000000, 2000000, 1500000, 1500000,
	1500000, 1500000, 500000, 500000, 500000, 500000, 500000, 500000,500000, 500000, 500000,
	500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000, 500000,
	500000, 350000, 350000, 1500000, 1500000, 500000, 500000, 500000, 500000
};
stock GetDefaultHouseCost(house) {
    return defaultHouseCost[house];
}
stock UpdateHouseInfo(idx, bool: change_int = true)
{
    DestroyDynamicMapIcon(HouseInfo[idx][hMIcon]);
	DestroyDynamicPickup(HouseInfo[idx][hPickup][0]);
    if (change_int) {
        DestroyDynamic3DTextLabel(HouseInfo[idx][hExitText]); 
        DestroyDynamic3DTextLabel(HouseInfo[idx][hClothesText]); 
        DestroyDynamicPickup(HouseInfo[idx][hPickup][1]);//[hClothes][0]
        new 
            id_x = HouseInfo[idx][hIntID];

        
        HouseInfo[idx][hPickup][1] = CreateDynamicPickup(1275, 23, 
            HouseInt[id_x][hClothes][0], HouseInt[id_x][hClothes][1], HouseInt[id_x][hClothes][2], idx+50, HouseInt[id_x][hIntInterior]
        );
        HouseInfo[idx][hClothesText] = CreateDynamic3DTextLabel("{006666}Шкаф\n"colwhi"Используйте: ALT",
            0x0076FCFF,  HouseInt[id_x][hClothes][0], HouseInt[id_x][hClothes][1], HouseInt[id_x][hClothes][2]+1, 5.0,
            .worldid = idx+50, .interiorid = HouseInt[id_x][hIntInterior] 
        );
        HouseInfo[idx][hExitText] = CreateDynamic3DTextLabel("Чтобы выйти, нажмите клавишу 'ENTER'\nКупить/продать, нажмите клавишу 'ALT'",
            0x0076FCFF, HouseInt[id_x][hIntPos][0], HouseInt[id_x][hIntPos][1], HouseInt[id_x][hIntPos][2]+1, 5.0, 
            .worldid = idx+50, .interiorid = HouseInt[id_x][hIntInterior]
        );
    } 
	if (strcmp(HouseInfo[idx][hOwner], "None", true) == 0)
	{
		HouseInfo[idx][hPickup][0] = CreateDynamicPickup(1273, 23, HouseInfo[idx][hEnter][0], HouseInfo[idx][hEnter][1], HouseInfo[idx][hEnter][2], 0, 0);
		HouseInfo[idx][hMIcon] = CreateDynamicMapIcon(HouseInfo[idx][hEnter][0], HouseInfo[idx][hEnter][1], HouseInfo[idx][hEnter][2], 31, COLOR_WHITE, 0, -1, -1);
	}
	else
	{
		HouseInfo[idx][hPickup][0] = CreateDynamicPickup(1272, 23, HouseInfo[idx][hEnter][0], HouseInfo[idx][hEnter][1], HouseInfo[idx][hEnter][2], 0, 0);
		HouseInfo[idx][hMIcon] = CreateDynamicMapIcon(HouseInfo[idx][hEnter][0], HouseInfo[idx][hEnter][1], HouseInfo[idx][hEnter][2], 32, COLOR_WHITE, 0, -1, -1);
	} 
    //OnHouseIconUpdate(idx);
}

/* Гаражи */

forward OnCreateGarageInfo ( hid );
public OnCreateGarageInfo ( hid )
{
    GarageHouse [ hid ] [ gID ] = cache_insert_id();
    return 1; 
}

stock UpdateGarageInfo ( hid, idx, type = 0 )
{
    HouseInfo [ hid ] [ hGarageExitText ] = 
        CreateDynamic3DTextLabel ( "{006666}Войти в дом\n"colwhi"Используйте: \"ALT\"",
            0x0076FCFF,  GarageInt [ idx ] [ gEnterPos ] [ 0 ], GarageInt [ idx ] [ gEnterPos ] [ 1 ], GarageInt [ idx ] [ gEnterPos ] [ 2 ] + 0.5, 5.0,
            INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, GarageHouse [ hid ] [ gVirtualWorld ], GarageInt [ idx ] [ gIntInterior ]
        );
    GarageHouse [ hid ] [ gPickUp ] =  
        CreateDynamicPickup ( 1318, 23, GarageInt [ idx ] [ gEnterPos ] [ 0 ], GarageInt [ idx ] [ gEnterPos ] [ 1 ], GarageInt [ idx ] [ gEnterPos ] [ 2 ], .worldid = GarageHouse [ hid ] [ gVirtualWorld ], .interiorid = GarageInt [ idx ] [ gIntInterior ] ); 
    
    if ( type == 1 )
    {
        new query [ 128 ];
        mysql_format ( dbHandle, query, sizeof ( query ), "UPDATE house SET hGarageID = %i WHERE hID = %i", idx, HouseInfo [ hid ] [ hID ] ); 
        mysql_tquery ( dbHandle, query );
    }
    return 1;
}
/* Гаражи */

publics: OnLoadHouseData()
{
    new 
        time = GetTickCount(), 
        rows;
    cache_get_row_count(rows);
    if (!rows) return print("[Загрузка ...] Данные из House не получены!");
    for(new i = 1, itemSafes[128]; i <= rows; i++)
    {
        cache_get_value_name_int(i-1, "hID", HouseInfo[i][hID]);
        cache_get_value_name_float(i-1, "enterx", HouseInfo[i][hEnter][0]);
        cache_get_value_name_float(i-1, "entery", HouseInfo[i][hEnter][1]);
        cache_get_value_name_float(i-1, "enterz", HouseInfo[i][hEnter][2]);
        cache_get_value_name_float(i-1, "hCarx", HouseInfo[i][hCar][0]);
        cache_get_value_name_float(i-1, "hCary", HouseInfo[i][hCar][1]);
        cache_get_value_name_float(i-1, "hCarz", HouseInfo[i][hCar][2]);
        cache_get_value_name_float(i-1, "hCarc", HouseInfo[i][hCar][3]);
        cache_get_value_name(i-1, "hOwner", HouseInfo[i][hOwner], MAX_PLAYER_NAME + 1);
        cache_get_value_name_int(i-1, "hFamily", HouseInfo[i][hFamily]);  
        cache_get_value_name_int(i-1, "hValue", HouseInfo[i][hValue]);  
        cache_get_value_name_int(i-1, "hReturnValue", HouseInfo[i][hReturnValue]);
        cache_get_value_name_int(i-1, "hHel", HouseInfo[i][hHel]);
        cache_get_value_name_int(i-1, "hLock", HouseInfo[i][hLock]);
        cache_get_value_name_int(i-1, "hTakings", HouseInfo[i][hTakings]);
        cache_get_value_name_int(i-1, "hKlass", HouseInfo[i][hKlass]);
        cache_get_value_name_int(i-1, "hIntID", HouseInfo[i][hIntID]);
        cache_get_value_name_int(i-1, "hGarageID", HouseInfo[i][hGarageID]);
        
        /* Гаражи */
        if ( HouseInfo[i][hGarageID] != -1 )
            UpdateGarageInfo ( i, HouseInfo [ i ] [ hGarageID ] );

        /* Гаражи */
        GarageHouse [ i ] [ gVirtualWorld ] = i + 50;
        cache_get_value_name_int(i-1, "rentable", HouseInfo[i][rentable]);
        cache_get_value_name_int(i-1, "rentsumma", HouseInfo[i][rentsumma]);
        


        cache_get_value_name(i-1, "hSafe", itemSafes, sizeof itemSafes);
        sscanf(itemSafes, "p<,>a<d>[4]", HouseInfo[i][hSafe]);
        cache_get_value_name(i-1, "hSafeGun", itemSafes,  sizeof itemSafes);
        sscanf(itemSafes, "p<,>a<d>[6]", HouseInfo[i][hSafeGun]);
        cache_get_value_name(i-1, "hSafeAmmo", itemSafes, sizeof itemSafes);
        sscanf(itemSafes, "p<,>a<d>[6]", HouseInfo[i][hSafeAmmo]);

        HouseInfo[i][hPickup][0] = CreateDynamicPickup(((GetString(HouseInfo[i][hOwner],"None")) ? 1273 : 1272), 23, HouseInfo[i][hEnter][0], HouseInfo[i][hEnter][1], HouseInfo[i][hEnter][2], 0, 0);

        HouseInfo[i][hArea] = CreateDynamicSphere(HouseInfo[i][hEnter][0], HouseInfo[i][hEnter][1], HouseInfo[i][hEnter][2], 1.0, 0, INTERIOR_NONE);
        SetDynamicAreaType(HouseInfo[i][hArea], AREA_TYPE_HOUSE, i);

        HouseInfo[i][hMIcon] = 
            CreateDynamicMapIcon(
                HouseInfo[i][hEnter][0], 
                HouseInfo[i][hEnter][1],
                HouseInfo[i][hEnter][2], 
                ((GetString(HouseInfo[i][hOwner],"None"))? 31 : 32), 
                COLOR_WHITE, 
                0, 0, -1);

        new
            I_IDX = HouseInfo[i][hIntID];

        HouseInfo[i][hPickup][1] = CreateDynamicPickup(1275, 23, HouseInt[I_IDX][hClothes][0], HouseInt[I_IDX][hClothes][1], HouseInt[I_IDX][hClothes][2], i+50, HouseInt[I_IDX][hIntInterior]);
        HouseInfo[i][hClothesText] = CreateDynamic3DTextLabel("{006666}Шкаф\n"colwhi"Используйте: \"ALT\"",
            0x0076FCFF,  HouseInt[I_IDX][hClothes][0], HouseInt[I_IDX][hClothes][1], HouseInt[I_IDX][hClothes][2]+1, 5.0,
            .worldid = i+50, .interiorid = HouseInt[I_IDX][hIntInterior] 
        );  
        HouseInfo[i][hExitText] = CreateDynamic3DTextLabel("Чтобы выйти, нажмите клавишу 'ENTER'\nКупить/продать, нажмите клавишу 'ALT'",
            0x0076FCFF,  HouseInt[I_IDX][hIntPos][0], HouseInt[I_IDX][hIntPos][1], HouseInt[I_IDX][hIntPos][2]+1, 5.0,
            .worldid = i+50, .interiorid = HouseInt[I_IDX][hIntInterior] 
        ); 

        CreateDynamicObject(2332, 
            HouseInt[I_IDX][hSafePos][0], HouseInt[I_IDX][hSafePos][1], HouseInt[I_IDX][hSafePos][2], 
            HouseInt[I_IDX][hSafePos][3], HouseInt[I_IDX][hSafePos][4], HouseInt[I_IDX][hSafePos][5], 
            (i + 50), HouseInt[I_IDX][hIntInterior]
        );
        if (HouseInfo[i][hGarageID] != -1)
        {
            new
                G_IDX = HouseInfo[i][hGarageID],
                string_[64];
            format(string_, sizeof string_, ""colmaline"Гараж: %d\n"colwhi"Нажмите: \"H\"", HouseInfo[i][hID]);
            HouseInfo[i][hGarageText] = CreateDynamic3DTextLabel(string_, -1,
                                            HouseInfo[i][hCar][0], 
                                            HouseInfo[i][hCar][1],
                                            HouseInfo[i][hCar][2], 
                                            9.0, .worldid = 0, .interiorid = 0);
            HouseInfo[i][hGarageExitText] = CreateDynamic3DTextLabel("{006666}Войти в дом\n"colwhi"Используйте: \"ALT\"",
                0x0076FCFF,  GarageInt[G_IDX][gEnterPos][0], GarageInt[G_IDX][gEnterPos][1], GarageInt[G_IDX][gEnterPos][2] + 0.5, 5.0,
                .worldid = i+50, .interiorid = GarageInt[G_IDX][gIntInterior]
            ); 
            HouseInfo[i][hPickup][2] = CreateDynamicPickup(1318, 23, GarageInt[G_IDX][gEnterPos][0], GarageInt[G_IDX][gEnterPos][1], GarageInt[G_IDX][gEnterPos][2], i+50, GarageInt[G_IDX][gIntInterior]);
        }
        
        TOTALHOUSE++;


    }
    printf("[Загрузка ...] Данные из House получены! (%d шт.) Время: %d",TOTALHOUSE, GetTickCount() - time);
    return 1;
} 
House_OnGameModeInit()
{
    mysql_tquery(
        dbHandle, "SELECT * FROM `house`", #OnLoadHouseData\
    );
    return;
}
House_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    new 
        bool:isReturn = false;
    if (newkeys & KEY_CROUCH && !(oldkeys & KEY_CROUCH))
    {
        if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER) 
		    return false; 
        if (pTemp[playerid][tCurrentHouseID] != -1 && HouseInfo[ pTemp[playerid][tCurrentHouseID] ][hGarageID] != -1)
        {
            new
                HOUSE_ID = pTemp[playerid][tCurrentHouseID],
                V_IDX = GetPlayerVehicleID(playerid),
                G_IDX = HouseInfo[HOUSE_ID][hGarageID];
            if (IsPlayerInRangeOfPoint(playerid,  15.0, GarageInt[G_IDX][gExitCar][0], GarageInt[G_IDX][gExitCar][1], GarageInt[G_IDX][gExitCar][2])
                && GetPlayerVirtualWorld(playerid) == HOUSE_ID + 50)
            {
                foreach(new i: PlayerInLogin)
                {
                    if (GetPlayerVehicleID(i) == V_IDX) {
                        SetPlayerVirtualWorld(i, 0);
                        SetPlayerInterior(i, 0);
                    }
                }
                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, 0);
                SetVehicleVirtualWorld(V_IDX, 0); 
                SetVehiclePos(V_IDX, HouseInfo[HOUSE_ID][hCar][0], HouseInfo[HOUSE_ID][hCar][1], HouseInfo[HOUSE_ID][hCar][2]);
                SetVehicleZAngle(V_IDX, HouseInfo[HOUSE_ID][hCar][3]);
                LinkVehicleToInterior(V_IDX, 0); 
                SetPVarInt(playerid,"AntiKickGarage",gettime()+2);
                isReturn = true;
            }
            if (IsPlayerInRangeOfPoint(playerid,  10.0, HouseInfo[HOUSE_ID][hCar][0], HouseInfo[HOUSE_ID][hCar][1], HouseInfo[HOUSE_ID][hCar][2]) 
                && GetPlayerVirtualWorld(playerid) == 0 && HouseInfo[HOUSE_ID][hGarageID] != -1)
            { 
                foreach(new i: PlayerInLogin)
                { 
                    if (GetPlayerVehicleID(i) == V_IDX) 
                    { 
                        SetPlayerVirtualWorld(i, HOUSE_ID + 50);
                        SetPlayerInterior(i, GarageInt[G_IDX][gIntInterior]); 
                    } 
                }
                SetVehiclePos(V_IDX, GarageInt[G_IDX][gCarPos_0][0], GarageInt[G_IDX][gCarPos_0][1], GarageInt[G_IDX][gCarPos_0][2]);
                SetVehicleZAngle(V_IDX, GarageInt[G_IDX][gCarPos_0][3]);

                SetPlayerVirtualWorld(playerid, HOUSE_ID + 50);
                SetVehicleVirtualWorld(V_IDX, HOUSE_ID + 50);

                SetPlayerInterior(playerid, GarageInt[G_IDX][gIntInterior]);
                LinkVehicleToInterior(V_IDX, GarageInt[G_IDX][gIntInterior]); 
                setFreezePlayerForTime(playerid, 3);
                SetPVarInt(playerid,"AntiKickGarage",gettime()+2);
                isReturn = true;
            }
        }
        isReturn = false;
        
    } 
    if (newkeys & KEY_SECONDARY_ATTACK && !(oldkeys & KEY_SECONDARY_ATTACK)) { 
        if (pTemp[playerid][tCurrentHouseID] != -1) {
            new 
                H_IDX = pTemp[playerid][tCurrentHouseID],
                idx = HouseInfo[H_IDX][hIntID];
            if (IsPlayerInRangeOfPoint(playerid, 3.0, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) && GetPlayerVirtualWorld(playerid) == H_IDX + 50)
            { 
                SetPlayerPosAC(playerid, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2], 0, 0);
                if (H_IDX >= 694 && H_IDX <= 708) {
                    setFreezePlayerForTime(playerid, 2);
                } 
                teleport_tick[playerid] = GetTickCount();
                isReturn = true;
            }
        } 
        isReturn = false;  
    }  
    if (newkeys & 1024 && !(oldkeys & 1024)) 
    {
        if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		    return false; 
        if (pTemp[playerid][tCurrentHouseID] != -1) {
            new 
                H_IDX = pTemp[playerid][tCurrentHouseID],
                idx = HouseInfo[H_IDX][hIntID],
                G_IDX = HouseInfo[H_IDX][hGarageID];
            t_string[0] = EOS;
            new house_class_name[MAX_HOUSE_CLASS_NAME + 1];
            
            GetHouseClassName(H_IDX, house_class_name);
            if (IsPlayerInRangeOfPoint(playerid, 2.5, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) && GetPlayerVirtualWorld(playerid) == H_IDX+50)
            {
                if (!strcmp(HouseInfo[H_IDX][hOwner],"None",true))
                { 
                    new
                        text_gInf[64];
                    new cost = GetVipBoostMaxPlayerValueSale(playerid, vSaleHome, bSaleHome, HouseInfo[H_IDX][hValue]);
                    if (HouseInfo[H_IDX][hGarageID] == -1) text_gInf = "Не имеет";
                    else format(text_gInf, sizeof text_gInf, "Имеет, на %d %s", GarageInt[G_IDX][gVehicleCount], Declension_ReturnWord(GarageInt[G_IDX][gVehicleCount], "машину", "машины", "машин"));
                    format(t_string, sizeof t_string,""colwhi"Номер дома: "colserver"%d\n\
                        "colwhi"Стоимость: "collime"$%d\n\
                        "colwhi"Класс: "colserver"%s\n\
                        "colwhi"Гараж: "colserver"%s\n\
                        "colwhi"Квартплата: "collime"$%d в час\n", HouseInfo[H_IDX][hID], cost+(GetHouseOplata(H_IDX) * 24), house_class_name, text_gInf, GetHouseOplata(H_IDX));
                        
                    ShowPlayerDialog(playerid, D_HOUSE_FUNC_13, 0,""colserver"Дом: "colwhi"Продаеться", t_string, "Купить", "Отмена");
                }
                else if (pInfo[playerid][pHouseID] == H_IDX)
                {
                    new
                        str_[64];
                    format(str_, sizeof str_, ""colserver"Дом: "colwhi"%s [№: %d]", HouseInfo[H_IDX][hOwner], HouseInfo[H_IDX][hID]);
                    format(t_string, sizeof t_string, ""colserver"[№] Параметр\t"colserver"[Статус]\n\
                        "colwhi"[0] Дверной замок:\t[%s]\n\
                        [1] Заселить в дом\t["collime"Возможно"colwhi"]\n\
                        [2] Информация по жильцам\t["collime"Посмотреть"colwhi"]\n\
                        [3] Интерьер дома\t["collime"Изменить"colwhi"]\n\
                        [4] Гараж\n\
                        [5] Установить спавн семьи\n\
                        [6] Автомобили\n\
                        [7] Изменить стоимость аренды\n\
                        [8] Интерьер гаража\t["collime"Изменить"colwhi"]\n\
                        [9] Продать дом",
                        HouseInfo[H_IDX][hLock] ? (""colwarn"Закрыт"colwhi"") : (""collime"Открыт"colwhi""), HouseInfo[H_IDX][hHel]);
                    if(pInfo[playerid][pFamily] && GetFamilyDefaultHouse(playerid) != -1) strcat(t_string,"\n[10] Семейный автопарк");
                    ShowPlayerDialog(playerid, D_HOUSE_FUNC_10, DIALOG_STYLE_TABLIST_HEADERS, str_, t_string, "Выбор", "Закрыть"); 
                }
                isReturn = true;
            } 
            if (G_IDX > -1 && IsPlayerInRangeOfPoint(playerid, 3.0, GarageInt[G_IDX][gEnterPos][0], GarageInt[G_IDX][gEnterPos][1], GarageInt[G_IDX][gEnterPos][2]) && GetPlayerVirtualWorld(playerid) == H_IDX + 50) 
            { 
                SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], (H_IDX + 50), HouseInt[idx][hIntInterior]);
                isReturn = true;
            }
            if (IsPlayerInRangeOfPoint(playerid, 3.0, HouseInt[idx][hSafePos][0], HouseInt[idx][hSafePos][1], HouseInt[idx][hSafePos][2]) && GetPlayerVirtualWorld(playerid) == H_IDX + 50) 
            { 
                if (HouseInfo[H_IDX][hRobHouse]) { 
                    if (HouseInfo[H_IDX][hCountItemRob][1] != 0) {
                        if (pTemp[playerid][tRobItems]) return SendClientMessage(playerid, COLOR_GREY, !"У Вас заняты руки!");
                        HouseInfo[H_IDX][hCountItemRob][1] --;
                        ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,0,0,1,1,1);
                        switch(random(14)) {
                            case 0: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2317, 4, 0.1169, -0.4219, 0.0739, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV5" 
                            case 1: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 1518, 4, 0.0829, -0.4219, 0.0739, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV4" 
                            case 2: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2648, 4, 0.0689, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV3" 
                            case 3: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2318, 4, 0.0689, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV2" 
                            case 4: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2320, 4, 0.1299, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV1" 
                            case 5: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 19921, 4, 0.3669, -0.5089, 0.0979, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "yashik" 
                            case 6: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 1738, 4, 0.1219, -0.4249, 0.0419, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "truba" 
                            case 7: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2124, 4, 0.1580, -0.4499, 0.0710, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "stul2" 
                            case 8: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2120, 4, 0.2660, -0.3600, 0.1139, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "stul" 
                            case 9: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2102, 4, 0.3619, -0.3669, 0.1609, -64.8999, -120.6999, -72.7999, 0.9789, 0.9900, 1.0000, 0, 0); // "muzlo" 
                            case 10: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2421, 4, 0.2540, -0.1539, 0.3339, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "Mikrov" 
                            case 11: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 1727, 4, 0.5619, -0.2700, -0.1969, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "kreslo" 
                            case 12: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 19614, 4, 0.3109, -0.2999, 0.1609, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "акустика" 
                            case 13: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2226, 4, 0.3699, -0.3359, 0.1049, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "bumbox" 
                            case 14: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 11743, 4, 0.3109, -0.2999, 0.1609, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "blender"
                        }
                        pTemp[playerid][tRobItems] = true;
                        new string_[64];
                        format(string_, sizeof string_, "Доступно техники: "colmaline"%iед\n"colwhi"Используйте: ALT", HouseInfo[H_IDX][hCountItemRob][1] );
                        UpdateDynamic3DTextLabelText(HouseInfo[H_IDX][hTextRob], COLOR_WHITE, string_);//Обновил 3D Text
                    }
                    else {
                        SendClientMessage(playerid, COLOR_BLUE, !"В сейфе закончилась техника, отправляйся сдавать награбленое или проверьте шкаф!"); 
                    } 
                    return true;
                } 
                isReturn = true; 
            }
            if (IsPlayerInRangeOfPoint(playerid, 1.0, HouseInt[idx][hClothes][0], HouseInt[idx][hClothes][1], HouseInt[idx][hClothes][2]) && GetPlayerVirtualWorld(playerid) == H_IDX + 50) 
            { 
                if (HouseInfo[H_IDX][hRobHouse]) {
                    if (pInfo[playerid][pHouseID] != H_IDX && pInfo[playerid][pRentHouse] != H_IDX) {
                        if (HouseInfo[H_IDX][hCountItemRob][0] != 0) {
                            if (pTemp[playerid][tRobItems]) return SendClientMessage(playerid, COLOR_GREY, !"У Вас заняты руки!");
                            HouseInfo[H_IDX][hCountItemRob][0] --;
                            ApplyAnimation(playerid,"CARRY","crry_prtial",4.0,1,0,0,1,1,1);
                            switch(random(14)) {
                                case 0: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2317, 4, 0.1169, -0.4219, 0.0739, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV5" 
                                case 1: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 1518, 4, 0.0829, -0.4219, 0.0739, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV4" 
                                case 2: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2648, 4, 0.0689, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV3" 
                                case 3: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2318, 4, 0.0689, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV2" 
                                case 4: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2320, 4, 0.1299, -0.4219, 0.0739, -68.1999, -115.2999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "TV1" 
                                case 5: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 19921, 4, 0.3669, -0.5089, 0.0979, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "yashik" 
                                case 6: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 1738, 4, 0.1219, -0.4249, 0.0419, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "truba" 
                                case 7: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2124, 4, 0.1580, -0.4499, 0.0710, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "stul2" 
                                case 8: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2120, 4, 0.2660, -0.3600, 0.1139, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "stul" 
                                case 9: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2102, 4, 0.3619, -0.3669, 0.1609, -64.8999, -120.6999, -72.7999, 0.9789, 0.9900, 1.0000, 0, 0); // "muzlo" 
                                case 10: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2421, 4, 0.2540, -0.1539, 0.3339, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "Mikrov" 
                                case 11: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 1727, 4, 0.5619, -0.2700, -0.1969, -64.8999, -120.6999, -72.7999, 0.7850, 0.7200, 0.6640, 0, 0); // "kreslo" 
                                case 12: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 19614, 4, 0.3109, -0.2999, 0.1609, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "акустика" 
                                case 13: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 2226, 4, 0.3699, -0.3359, 0.1049, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "bumbox" 
                                case 14: SetPlayerAttachedObject(playerid, ATTACHED_SLOT_JOB_1, 11743, 4, 0.3109, -0.2999, 0.1609, -66.5999, -120.6999, -78.2999, 1.0000, 1.0000, 1.0000, 0, 0); // "blender"
                            }
                            pTemp[playerid][tRobItems] = true;
                            new string_[64];
                            format(string_, sizeof string_, "Доступно техники: "colmaline"%iед\n"colwhi"Используйте: ALT", HouseInfo[H_IDX][hCountItemRob][0] );
                            UpdateDynamic3DTextLabelText(HouseInfo[H_IDX][hClothesText], COLOR_WHITE, string_);//Обновил 3D Text
                        }
                        else {
                            SendClientMessage(playerid, COLOR_BLUE, !"В шкафу закончилась техника, отправляйся сдавать награбленое или проверьте сейф!"); 
                        }
                        
                    }
                    else {
                        SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш дом был недавно ограблен в данный момент шкаф недоступен");
                    }
                    return true;
                }
                if (pInfo[playerid][pHouseID] != H_IDX && pInfo[playerid][pRentHouse] != H_IDX) return SendClientMessage(playerid, COLOR_GREY, !"Это не Ваш дом!"); 
                new str_[64];
                t_string[0] = EOS;
                for(new j = 0; j < 11; j ++) {
                    if (pInfo[playerid][pChar][j] == 0) {
                        format(str_, sizeof str_, ""colwhi"[%d] Пусто\n", j);
                        strcat(t_string, str_);
                    }
                    else { 
                        if (j == 0) {
                            format(str_, sizeof str_, ""colwhi"[%d] Одежда: %d "collime"[Текущий]\n", j, pInfo[playerid][pChar][j]); 
                        }
                        else {
                            format(str_, sizeof str_, ""colwhi"[%d] Одежда: %d\n", j, pInfo[playerid][pChar][j]); 
                        }
                        strcat(t_string, str_);
                    }
                }
                if (pInfo[playerid][pMember] != 0 && !IsAGang(playerid) && !IsAMafia(playerid)) {
                    strcat(t_string, "[-] Одежда организации");
            
                } 
                ShowPlayerDialog(playerid, D_HOUSE_FUNC_4, DIALOG_STYLE_LIST, ""colserver"Гардероб: "colwhi"Дома", t_string, "Выбрать", "Закрыть" );
                 isReturn = true; 
            }
            isReturn = false;
        } 
        isReturn = false; 
    }
    return isReturn;
}

ShowPlayerHouseMenu(playerid, idx) { 
    if (pTemp[playerid][tRobItems]) {
        return true;
    }
    new house_class_name[MAX_HOUSE_CLASS_NAME + 1];
    
    GetHouseClassName(idx, house_class_name);
    t_string[0] = EOS;
    if (strcmp(HouseInfo[idx][hOwner],"None",true) != 0)
    {
        new 
            targetid = GetCheckID(HouseInfo[idx][hOwner]); 
        
        format(t_string, sizeof t_string, 
            ""colwhi"Владелец: "colserver"%s "colwhi"%s\n\
            "colwhi"Класс: "colserver"%s\n\
            "colwhi"Статус дверей: %s\n\
            "colwhi"Цена аренды: "collime"$%d час\n\
            "colwhi"Номер дома: "colserver"%d",
            HouseInfo[idx][hOwner], 
            ( targetid == INVALID_PLAYER_ID ) ? ("[{ff001c}Offline"colwhi"]") : ("[{22ff00}Online"colwhi"]"), 
            house_class_name, 
            HouseInfo[idx][hLock] ? (""colwarn"Закрыты"colwhi"") : (""collime"Открыты"colwhi""),HouseInfo[idx][rentsumma], idx
        );

        ShowPlayerDialog(playerid, D_HOUSE_FUNC_5, DIALOG_STYLE_MSGBOX, ""colserver"Дом: "colwhi"Занят", t_string, "Войти", "Отмена");//pTemp[playerid][tSelectHouseID] = -1; 
      
        t_string[0] = EOS;
    }
    else
    {
        new G_IDX = HouseInfo[idx][hGarageID],
            text_gInf[64];
        if (HouseInfo[idx][hGarageID] == -1) text_gInf = "Не имеет";
        else format(text_gInf, sizeof text_gInf, "Имеется, на %d %s", GarageInt[G_IDX][gVehicleCount], Declension_ReturnWord(GarageInt[G_IDX][gVehicleCount], "машину", "машины", "машин"));

        
       //
        new 
            cost_home = HouseInfo[idx][hValue]+(GetHouseOplata(idx) * 24);
            cost_home = GetVipBoostMaxPlayerValueSale(playerid, vSaleHome, bSaleHome, cost_home);
        format(t_string, sizeof t_string, "\
            "colwhi"Номер дома: "colserver"%d\n\
            "colwhi"Стоимость дома: "collime"$%d\n\
            "colwhi"Класс: "colserver"%s\n\
            "colwhi"Гараж: "colserver"%s\n\n\
            "colwhi"Цена аренды: "colserver"Аренда закрыта\n\
            "colwhi"Введите номер пункта:\n\
            [1] Войти\n\
            [2] Купить\n\
            [3] Закрыть диалог",
            HouseInfo[idx][hID], cost_home, house_class_name, text_gInf
        );
        ShowPlayerDialog(playerid, D_HOUSE_FUNC_6, 1, ""colserver"Дом: "colwhi"Cвободен", t_string, "Выбор", "Отмена");
        t_string[0] = EOS;
    }
    return true;
} 

House_OnDialogResponse(playerid, dialogid, response, listitem, const inputtext[]) { 
	switch (dialogid) {
        case D_HOUSE_FUNC_4:/* 0 - 3 */
		{
			if (!response) return 1;
			if (listitem == 11)
			{
                if (pInfo[playerid][pMember] == 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в организации!");
				if (pTemp[playerid][tDutyWork] == 0)
				{
					SendClientMessage(playerid, 0x6BB3FFAA, !"Рабочий день начат");
					pTemp[playerid][tDutyWork] = 1;
					SetWeaponFraction(playerid);
					SetPlayerColor(playerid, gFractionColor[pInfo[playerid][pMember]]);
					SetPlayerSkinEx(playerid, pInfo[playerid][pModel]);
				}
				else
				{
				    SendClientMessage(playerid, 0x6BB3FFAA, !"Рабочий день окончен");
		   			SetPlayerColor(playerid, TEAM_HIT_COLOR);
					pTemp[playerid][tDutyWork] = 0;
					SetPlayerArmour(playerid, 0);
					ResetPlayerWeapons(playerid);
					SetPlayerSkinEx(playerid, pInfo[playerid][pChar][0]);
				}
				return 1;
			}
			if (pInfo[playerid][pChar][listitem] == 0) {
				return SendClientMessage(playerid, COLOR_GREY, !"На данной полке у Вас нет одежды");
			}
            if (pTemp[playerid][tDutyWork]) return SendClientMessage(playerid, COLOR_GREY, !"Вы сначало должны завершить рабочий день!");
			if (listitem == 0) {
                SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Данный скин уже надет на Вас");
                return 1;
            }
            new skin = pInfo[playerid][pChar][0];
            pInfo[playerid][pChar][0] = pInfo[playerid][pChar][listitem]; 
            SetPlayerSkinEx(playerid, pInfo[playerid][pChar][0]);
            pInfo[playerid][pChar][listitem] = skin;
            save_player_skins(playerid);
            return 1;
		}
		case D_HOUSE_FUNC_5:
		{
			if (!response) {  
                //pTemp[playerid][tCurrentHouseID] = -1;
				return true;
			}  
            if (pTemp[playerid][tSelectHouseID] == -1) {
                SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть возле дома!");
                return true;
            }
			new	
				H_IDX = pTemp[playerid][tSelectHouseID];
			if (IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2]))
			{
				if (pInfo[playerid][pHouseID] == H_IDX || pInfo[playerid][pRentHouse] == H_IDX || HouseInfo[H_IDX][hLock] == 0 || HouseInfo[H_IDX][hRobHouse])
				{
					new
						idx = HouseInfo[H_IDX][hIntID];
					SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], H_IDX+50, HouseInt[idx][hIntInterior]); 
                    pTemp[playerid][tCurrentHouseID] = H_IDX;
					return 1;
				}
				else GameTextForPlayer(playerid, !"~r~CLOSED", 5000, 1);
			} 
			return 1;
		}
		case D_HOUSE_FUNC_6:
		{
		    if (!response) {

                return true;
            }
		    new buyhouse;
	        if (sscanf(inputtext, "d",buyhouse)) return true;
	        if (buyhouse < 1 || buyhouse > 4) return true;
	        if (buyhouse == 1)
	        {
				if (pTemp[playerid][tSelectHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны быть возле дома!");
				new 
					H_IDX = pTemp[playerid][tSelectHouseID]; 
				if (!IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2])) return SendClientMessage(playerid, COLOR_GREY, !"Вы далеко от дома!");
				new
					idx = HouseInfo[H_IDX][hIntID];
				SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], H_IDX+50, HouseInt[idx][hIntInterior]); 
                pTemp[playerid][tCurrentHouseID] = H_IDX;
				return true;
			}
			if (buyhouse == 2)
		    {
                new 
					H_IDX = pTemp[playerid][tSelectHouseID], 
				    idx = HouseInfo[H_IDX][hIntID];
                if ((IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2]) 
                    || (IsPlayerInRangeOfPoint(playerid, 2.0, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) 
                        && GetPlayerVirtualWorld(playerid) == H_IDX+50))
                && strcmp(HouseInfo[H_IDX][hOwner],"None",true) == 0)
                {
                    if (pInfo[playerid][pHouseID] != -1) return SendClientMessage(playerid, COLOR_LIGHTGREEN, !"У вас уже есть дом!"); 
                    new 
                        cost_home = HouseInfo[H_IDX][hValue]+(GetHouseOplata(H_IDX) * 24);
                    cost_home = GetVipBoostMaxPlayerValueSale(playerid, vSaleHome, bSaleHome, cost_home);
                    if (pInfo[playerid][pBank] < cost_home) return SendClientMessage(playerid, COLOR_GREY, !"На банковском счете нет столько денег!");

                    HouseInfo[H_IDX][hHel] = 0;
                    HouseInfo[H_IDX][hLock] = 1;
                     HouseInfo[H_IDX][rentsumma] = 50;
                    new 
                        query_[128];
                    format(query_, sizeof query_, "rentsumma = '%d', `hHel`= '%d', `hLock`= '%d'",HouseInfo[H_IDX][rentsumma], HouseInfo[H_IDX][hHel], HouseInfo[H_IDX][hLock]);
                    SaveHouse(H_IDX, query_);

            
                    strmid(HouseInfo[H_IDX][hOwner], pInfo[playerid][pName], 0, strlen(pInfo[playerid][pName]), 32); 
                    pInfo[playerid][pHouseID] = H_IDX; 
                    pTemp[playerid][tCurrentHouseID] = H_IDX;
                    pInfo[playerid][pBank] -= cost_home; 
                    format(string_chat_, sizeof (string_chat_), "покупка дома #%i", HouseInfo[H_IDX][hID]);
                    LogMoney(playerid, -cost_home, string_chat_), string_chat_[0] = EOS; 
                    HouseInfo[H_IDX][hTakings] = GetHouseOplata(H_IDX) * 24;
                    SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], H_IDX+50, HouseInt[idx][hIntInterior]);
                    OnPlayerQuestProgress(playerid, QUEST_GUEST, QUEST_TASK_HOUSE);
                    pInfo[playerid][PlayerSpawn] = 1;  
                    format(query_, sizeof query_,"playerspawn = '%i', pBank = '%i', pHouseID = '%i'",pInfo[playerid][PlayerSpawn], pInfo[playerid][pBank], pInfo[playerid][pHouseID]);
		            SavePlayerStr(playerid, query_); 

                    SendClientMessage(playerid, COLOR_WHITE, !"Поздравляем с покупкой!");
                    SendMes(playerid, COLOR_YELLOW, "Внимание! Теперь каждый час со счёта вашего дома будут снимать комунальные платежи в размере "collime"$%d", GetHouseOplata(H_IDX));
                    SendClientMessage(playerid, COLOR_YELLOW, !"Если на счету недостаточно денег, вас выселят");
                    SendClientMessage(playerid, COLOR_YELLOW, !"Пополнить домашний счёт или узнать баланс можно через банк/банкомат (помощь: /mm -> команды)");
                    GameTextForPlayer(playerid,"~w~welcome home~n~print:~g~/exit", 5000, 3);  
                    UpdateHouseInfo(H_IDX, false);
                    SaveHouseID(H_IDX);
                    return 1;
                } 
				return true;
			}
			if (buyhouse == 3) return true;
           /* if (buyhouse == 4) {
                new 
					H_IDX = pTemp[playerid][tSelectHouseID], 
				    idx = HouseInfo[H_IDX][hIntID];
                if ((IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2]) 
                    || (IsPlayerInRangeOfPoint(playerid, 2.0, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) 
                        && GetPlayerVirtualWorld(playerid) == H_IDX+50))
                && strcmp(HouseInfo[H_IDX][hOwner],"None",true) == 0)
                {
                    if (pInfo[playerid][pHouseID] != -1) return SendClientMessage(playerid, COLOR_LIGHTGREEN, !"У вас уже есть дом!");
                    if (ChristmasInfo[playerid][aCirtificationHome] == 0) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет сертификата");
                    if (HouseInfo[H_IDX][hKlass] != 0 && HouseInfo[H_IDX][hKlass] != 1) {
                        SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"За сертификат можно купить дом класс Nope, D");
                        return 1;
                    } 
                    HouseInfo[H_IDX][hHel] = 0;
                    HouseInfo[H_IDX][hLock] = 1;
                    HouseInfo[H_IDX][hReturnValue] = HouseInfo[H_IDX][hValue];
                    HouseInfo[H_IDX][hValue] = 0;

                    HouseInfo[H_IDX][rentsumma] = 50;
                    new //cache_get_value_name_int(i-1, "hValue", HouseInfo[i][hValue]);  
                        query_[128];
                    format(query_, sizeof query_, "rentsumma = '%d', hHel = '%d', hLock = '%d', hValue = '0', hReturnValue = '%d'",HouseInfo[H_IDX][rentsumma], HouseInfo[H_IDX][hHel], HouseInfo[H_IDX][hLock], HouseInfo[H_IDX][hReturnValue]);
                    SaveHouse(H_IDX, query_);

                    strmid(HouseInfo[H_IDX][hOwner], pInfo[playerid][pName], 0, strlen(pInfo[playerid][pName]), 32); 
                    pInfo[playerid][pHouseID] = H_IDX; 
                    pTemp[playerid][tCurrentHouseID] = H_IDX;
                    ChristmasInfo[playerid][aCirtificationHome] -= 1;  


                    SavePlayerCristmasInteger(playerid, "aCirtificationHome", ChristmasInfo[playerid][aCirtificationHome]);
                    HouseInfo[H_IDX][hTakings] = GetHouseOplata(H_IDX) * 24;
                    SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], H_IDX+50, HouseInt[idx][hIntInterior]);
                    OnPlayerQuestProgress(playerid, QUEST_GUEST, QUEST_TASK_HOUSE);
                    pInfo[playerid][PlayerSpawn] = 1;  
                    format(query_, sizeof query_,"playerspawn = '%i', pHouseID = '%i'",pInfo[playerid][PlayerSpawn], pInfo[playerid][pHouseID]);
		            SavePlayerStr(playerid, query_); 

                    SendClientMessage(playerid, COLOR_WHITE, !"Поздравляем с покупкой!");
                    SendMes(playerid, COLOR_YELLOW, "Внимание! Теперь каждый час со счёта вашего дома будут снимать комунальные платежи в размере "collime"$%d", GetHouseOplata(H_IDX));
                    SendClientMessage(playerid, COLOR_YELLOW, !"Если на счету недостаточно денег, вас выселят");
                    SendClientMessage(playerid, COLOR_YELLOW, !"Пополнить домашний счёт или узнать баланс можно через банк/банкомат (помощь: /mm -> команды)");
                    GameTextForPlayer(playerid,"~w~welcome home~n~print:~g~/exit", 5000, 3);  
                    UpdateHouseInfo(H_IDX, false);
                    SaveHouseID(H_IDX);
                    return 1;
                } 
				return true;
            }*/
		}  
        case D_HOUSE_FUNC_8:// N class
		{
		    if (!response) {
                return 1;
            }
		    new 
                house = pInfo[playerid][pHouseID],
                count_ammo = 1;
		    for(new i = 0; i < sizeof(HouseInt); i++)
		    {
      			if (HouseInfo[house][hKlass] != HouseInt[i][hIntClass]) continue;
		       	if ((count_ammo-1) == listitem) {
					SetPlayerPosAC(playerid, HouseInt[i][hIntPos][0], HouseInt[i][hIntPos][1], HouseInt[i][hIntPos][2], house, HouseInt[i][hIntInterior]);
					pTemp[playerid][SelectBuyInt] = i;
					SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Когда будете готовы, введите "colwarn"\"/buyinterior\""colwhi" еще раз");
					break;
				}
				count_ammo++;
    		}
		    return 1;
		}
        case D_HOUSE_FUNC_15:// N class
		{
		    if (!response) {
                return 1;
            }
            if(HouseInfo[playerid][hGarageID] == -1)
            {
                SendClientMessage(playerid, COLOR_GREY, !"В Вашем доме нет гаража!"); 
                new 
                    garage = pInfo[playerid][pHouseID],
                    count_ammo = 1;
                for(new i = 0; i < sizeof(GarageInt); i++)
                {
                    //if (HouseInfo[garage][hKlass] != GarageInt[i][hIntClass]) continue;
                    if ((count_ammo-1) == listitem) {
                        SetPlayerPosAC(playerid, GarageInt[i][gEnterPos][0], GarageInt[i][gEnterPos][1], GarageInt[i][gEnterPos][2], garage, GarageInt[i][gIntInterior]);
                        pTemp[playerid][SelectBuyInt] = i;
                        SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Когда будете готовы, введите "colwarn"\"/buygarageint\""colwhi" еще раз");
                        break;
                    }
                    count_ammo++;
                }
		        return 0;
            }
            else
            {
                new 
                    garage = pInfo[playerid][pHouseID],
                    count_ammo = 1;
                for(new i = 0; i < sizeof(GarageInt); i++)
                {
                    //if (HouseInfo[garage][hKlass] != GarageInt[i][hIntClass]) continue;
                    if ((count_ammo-1) == listitem) {
                        SetPlayerPosAC(playerid, GarageInt[i][gEnterPos][0], GarageInt[i][gEnterPos][1], GarageInt[i][gEnterPos][2], garage, GarageInt[i][gIntInterior]);
                        pTemp[playerid][SelectBuyInt] = i;
                        SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Когда будете готовы, введите "colwarn"\"/buygarageint\""colwhi" еще раз");
                        break;
                    }
                    count_ammo++;
                }
		        return 1;
            }
		}
		case D_HOUSE_FUNC_9:
		{
		    new 
                house = pInfo[playerid][pHouseID], 
                idx_ = pTemp[playerid][SelectBuyInt];
		    if (!response)
			{
				new
					idx = HouseInfo[house][hIntID];
                SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], house+50, HouseInt[idx][hIntInterior]);
				pTemp[playerid][SelectBuyInt] = -1;
				return 1;
			}
   			if (pInfo[playerid][pBank] < HouseInt[idx_][hIntCost]) return SendClientMessage(playerid, COLOR_GREY, !"Недостаточно средств в банке!");
			HouseInfo[house][hIntID] = HouseInt[idx_][hIntID];
			pInfo[playerid][pBank] -= HouseInt[idx_][hIntCost];
			SavePlayerInteger(playerid, "pBank", pInfo[playerid][pBank]);
			LogMoney(playerid, -HouseInt[idx_][hIntCost], "успешная сделка дома");
			new idx = HouseInfo[house][hIntID];
			
			UpdateHouseInfo(house, true);//Save position
			SaveHouseID(house);
			SendClientMessage(playerid, COLOR_BLUE, !"Сделка прошла успешно");
			SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], house+50, HouseInt[idx][hIntInterior]);
			pTemp[playerid][SelectBuyInt] = -1;
			return 1;
		}
		/*case D_HOUSE_FUNC_10:
	    {
	        if (!response) return 1;
	        new
                WORLD_IDX = GetPlayerVirtualWorld(playerid)-50,
                string_[128];
            new
                H_IDX = pTemp[playerid][tCurrentHouseID];
         	switch(listitem)
          	{
                case 0:
                {
					if (GetString(HouseInfo[WORLD_IDX][hOwner], pInfo[playerid][pName]) || pInfo[playerid][pRentHouse] == WORLD_IDX)
					{
						if (HouseInfo[H_IDX][hLock] == 1) HouseInfo[H_IDX][hLock] = 0;  
						else HouseInfo[H_IDX][hLock] = 1;  
						GameTextForPlayer(playerid, (HouseInfo[H_IDX][hLock] == 1)?("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~HOUSE ~g~UNLOCK"):("~n~~n~~n~~n~~n~~n~~n~~n~~n~~n~~w~HOUSE ~r~LOCK"), 3000, 3);
						PlayerPlaySound(playerid, 1145, 0.0, 0.0, 0.0);
					}
					else SendClientMessage(playerid, COLOR_GREY, !"Это не ваш дом"); 
                }
                case 1: SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Используйте команду "colserver"\"/healme\"");
				case 2:
				{
				    if (pInfo[playerid][pHouseID] != WORLD_IDX) return SendClientMessage(playerid, COLOR_GREY, !"Это не ваш дом");
					new
						count_evict = 0;
					if (HouseInfo[H_IDX][hKlass] == 0 || HouseInfo[H_IDX][hKlass] == 1) count_evict = 1;
				    else count_evict = HouseInfo[H_IDX][hKlass]; 
					if (GetHouseEvictCount(H_IDX) >= count_evict) return SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Для начала Вам надо выселить одного из жильцов"); 
					ShowPlayerDialog(playerid, D_HOUSE_FUNC_11, DIALOG_STYLE_INPUT, ""colserver"Управление: "colwhi"Заселить", ""colwhi"Введите ID игрока, которого желаете подселить в дом:", "Принять", "Назад");
				}
				case 3:
				{
				    if (pInfo[playerid][pHouseID] != WORLD_IDX) return SendClientMessage(playerid, COLOR_GREY, !"Это не ваш дом"); 
					new 
						query_[128];
					format (query_, sizeof query_, "SELECT `Name`,`pID` FROM `s_users` WHERE `pRentHouse`='%d'",  H_IDX);
					new Cache:result = mysql_query (dbHandle, query_), rows;
					cache_get_row_count(rows); 
					if (!rows) {
						if (cache_is_valid(result)) cache_delete(result);
						SendClientMessage(playerid, COLOR_GREY, !"У Вас нет подселённых жильцов");
						return 1;
					}
					else
					{ 
						t_string[0] = EOS;
						for(new i = 0, account_id, name_[MAX_PLAYER_NAME]; i < rows; i++)
						{
							cache_get_value_name_int(i, "pID", account_id);  
							new pvar_string[20];
							format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i ) ;
							SetPVarInt ( playerid, pvar_string, account_id ) ;
 
							cache_get_value_name(i, "Name", name_, MAX_PLAYER_NAME); 
 
							format(string_, sizeof string_, "[%d] Жилец: %s\n", i + 1, name_);
							strcat(t_string, string_);
						}
						if (cache_is_valid(result)) cache_delete(result);
					}
					ShowPlayerDialog(playerid, D_HOUSE_FUNC_12, DIALOG_STYLE_LIST, ""colserver"Дом: "colwhi"Информация", t_string, "Выбрать", "Назад"); 
				}
                case 4: callcmd::buyinterior(playerid);
                case 5:
				{
                    if (HouseInfo[H_IDX][hGarageID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"В Вашем доме нет гаража!");
                    else
                    {
						PressedPickup[playerid] = HouseInfo[H_IDX][hPickup][2];
                        new G_IDX = HouseInfo[H_IDX][hGarageID];
                        SetPlayerPosAC(playerid, 
							GarageInt[G_IDX][gEnterPos][0], 
							GarageInt[G_IDX][gEnterPos][1], 
							GarageInt[G_IDX][gEnterPos][2], 
                            GarageInt[G_IDX][gEnterPos][3], 
                            GarageInt[G_IDX][gEnterPos][4], 
							WORLD_IDX+50, 
							GarageInt[G_IDX][gIntInterior]);
                        SetPlayerFacingAngle(playerid, GarageInt[G_IDX][gEnterPos][4]);
						setFreezePlayerForTime(playerid, 3);
                    }
				}
                case 6: {
                    if (!pInfo[playerid][pFamily]) return SendClientMessage(playerid, COLOR_GREY, !"Вы не состоите в семье");
                    if (!GetString(FamilyInfo[ pInfo[playerid][pFamily] - 1 ][fOwner], pInfo[playerid][pName])) return SendClientMessage(playerid, COLOR_GREY, !"Передать семью может только создатель!");
                    new
                        F_IDX = pInfo[playerid][pFamily] - 1,
                        H_IDX = pInfo[playerid][pHouseID];
                    FamilyInfo[F_IDX][fDefHouse] = H_IDX;
                    HouseInfo[H_IDX][hFamily] = pInfo[playerid][pFamily];
                    format(t_string, sizeof t_string, "fDefHouse = %d", FamilyInfo[F_IDX][fDefHouse]);
                    SaveFamily(playerid, t_string), t_string[0] = EOS;

                    new //cache_get_value_name_int(i-1, "hValue", HouseInfo[i][hValue]);  
                        query_[128];
                    format(query_, sizeof query_, "hFamily = '%d'", HouseInfo[H_IDX][hFamily]);
                    SaveHouse(H_IDX, query_);*/
                    //cache_get_value_name_int(i-1, "hFamily", HouseInfo[i][hFamily]);  
                    //SendClientMessage(playerid, COLOR_)

/*
                    new family_id = pInfo[playerid][pFamily] - 1,
                        H_IDX = pTemp[playerid][tSelectFamilyHouse];
                    if (FamilyInfo[family_id][f"DonatePoint"] < FamilyHouse[H_IDX][fhCost]) return SendClientMessage(playerid, COLOR_GREY, !"На счету семьи недостаточно Family Coins!");
                    FamilyInfo[family_id][f"DonatePoint"] -= FamilyHouse[H_IDX][fhCost];
                    FamilyInfo[family_id][fHouse] = H_IDX;
                    FamilyHouse[H_IDX][fhLandTax] = (GetFamilyHouseRent*24);
                    strmid(FamilyHouse[H_IDX][fhOwner], FamilyInfo[family_id][fName], 0, strlen(FamilyInfo[family_id][fName]), 32); 
                    format(t_string, sizeof t_string, "hLandTax = '%d', hOwner = '%s'", FamilyHouse[H_IDX][fhLandTax], FamilyHouse[H_IDX][fhOwner]);
                    SaveFamilyHouse(H_IDX, t_string), t_string[0] = EOS;

                    format(t_string, sizeof t_string, "f"DonatePoint" = %d, fHouse = %d", FamilyInfo[family_id][f"DonatePoint"], FamilyInfo[family_id][fHouse]);
                    SaveFamily(playerid, t_string), t_string[0] = EOS;*/

/*
                }
                case 7:
                {
                    if (pInfo[playerid][pHouseID] != WORLD_IDX) return SendClientMessage(playerid, COLOR_GREY, !"Это не ваш дом");
                    if (!HouseInfo[H_IDX][hValue]) {
                        ShowPlayerDialog(playerid, D_SELL_HOUSE_GOS_0, DIALOG_STYLE_MSGBOX, ""colserver"Продажа: "colwhi"Дома",
                            ""colwhi"Внимание! Вы собираетесь продать дом\n"col_li_red"Так как дом был приобретен за сертификат, вы не получите деньги с продажи дома",
                            "Да", "Нет"
                        );
                    }
                    else {
                        new 
                            house_cash = ((HouseInfo[H_IDX][hValue]+HouseInfo[H_IDX][hTakings])*75)/100;
                        format(t_string, sizeof t_string, 
                            ""colwhi"Внимание! Вы собираетесь продать дом\nВам будет выплачено "collime"75%% процентов"colwhi" от стоимости дома\n\nПродать дом за "collime"$%d"colwhi"?", house_cash
                        );
                        ShowPlayerDialog(playerid, D_SELL_HOUSE_GOS, DIALOG_STYLE_MSGBOX, ""colserver"Продажа: "colwhi"Дома", t_string, "Да", "Нет"), t_string[0] = EOS;
                    }  
                }
			}
            return true;
		}*/
		//#if !defined _poffer_inc
		case D_HOUSE_FUNC_11:
		{
			//if (!response) return 1;
			if (!response) return 1;
		   	new targetid;
		    if (sscanf(inputtext,"u", targetid)) return ShowPlayerDialog(playerid, D_HOUSE_FUNC_11, DIALOG_STYLE_INPUT,"Заселение","{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
		    new Float:x,
				Float:y,
				Float:z;
		    GetPlayerPos(targetid, x, y, z);
		    if (!PlayerInConnected(targetid)) return ShowPlayerDialog(playerid, D_HOUSE_FUNC_11,DIALOG_STYLE_INPUT,"Заселение","{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
		    if (!IsPlayerInRangeOfPoint(playerid, 5.0, x,y,z))
			{
				SendClientMessage(playerid, COLOR_GREY, !"Вы не рядом с игроком");
				ShowPlayerDialog(playerid, D_HOUSE_FUNC_11, DIALOG_STYLE_INPUT, "Заселение", "{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
				return 1;
			}
			if (Select[targetid][SelectCharEvict] == 255) return SendClientMessage(playerid, COLOR_GREY, !"Человеку уже кто то сделал предложение!");
   			if (pInfo[targetid][pHouseID] != -1 || pInfo[targetid][pRentHouse] != -1)
			{
				SendClientMessage(playerid, COLOR_GREY, !"Игрок имеет жильё");
				ShowPlayerDialog(playerid, D_HOUSE_FUNC_11, DIALOG_STYLE_INPUT,"Заселение","{FFFFFF}Введите ID, которого хотите подселить:" ,"Далее","Назад");
				return 1;
			}
			SendMes(playerid, 0x6495EDFF,"Вы предложили %s подселиться к Вам", pInfo[targetid][pName]);
			SendMes(targetid, 0x6495EDFF,"%s предложил Вам подселиться к нему в дом", pInfo[playerid][pName]);
			SendClientMessage(targetid, 0x6495EDFF, !"(( Нажмите: {33AA33}Y {6495ED}- согласиться или "colred"N {6495ED}- отказаться))");
			Select[targetid][SelectCharEvict] = 255;
			SetPVarInt(targetid, "HouseOwnerPlayer", playerid); 
		}
		case D_HOUSE_FUNC_12:
		{
			if (! response)
			{
				for(new i = 0 ; i < 5 ; i ++)
				{
					new pvar_string[8] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i ) ;
					DeletePVar ( playerid, pvar_string ) ;
				}
				return 1;
			}
			SetPVarInt ( playerid, "dialog_listitem", listitem ) ;
			ShowPlayerDialog( playerid, D_HOUSE_FUNC_14, DIALOG_STYLE_LIST, "Подселение", "[0] Выселить", "Выбрать", "Назад");
		}
		case D_HOUSE_FUNC_14:
		{
			if (!response)
			{
				DeletePVar(playerid, "dialog_listitem");
				/*
				LIST EVICT
				*/ 
				return 1 ;
			}
			switch(listitem)
			{
				case 0:
				{
					new pvar_string [ 20 ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "dialog_listitem" ) ) ;
					new account_id = GetPVarInt ( playerid, pvar_string ) ;
					DeletePVar ( playerid, "dialog_listitem" ) ;

					new 
						query_[128]; 
					format(query_, sizeof query_, "UPDATE `s_users` SET `pRentHouse`='-1' WHERE `pID`='%d'",  account_id);
					mysql_query(dbHandle, query_); 
					new targetid = INVALID_PLAYER_ID;
					foreach(new i : PlayerInLogin) {
						if (pInfo[i][pID] != account_id) continue;
						targetid = i;
						break;
					} 
					if (targetid != INVALID_PLAYER_ID) {
						format(query_, sizeof query_, "%s[%d] Выселил Вас из своего дома", pInfo[playerid][pName], playerid);
						SendClientMessage(targetid, COLOR_ROSE, query_); 
						format(query_, sizeof query_, "Вы выселили из своего дома %s[%d].", pInfo[targetid][pName], targetid);
						SendClientMessage(playerid, COLOR_ROSE, query_); 
						pInfo[targetid][pRentHouse] = -1;
						SavePlayerInteger(targetid, "pRentHouse", pInfo[targetid][pRentHouse]);
					}
					else SendClientMessage(playerid, COLOR_ROSE, !"Игрок успешно выселен из Вашего дома"); 
				}
			}
            return true;
		} 
        case D_HOUSE_FUNC_16:
		{
		    new
                house = pInfo [ playerid ] [ pHouseID ], 
                H_IDX = pTemp [ playerid ] [ tCurrentHouseID ],
                idx_ = pTemp [ playerid ] [ SelectBuyInt ],
                hint = HouseInfo [ H_IDX ] [ hIntID ];
		    
            /* Moretti */
            if ( !response )
            {
                SetPlayerPosAC ( playerid, HouseInt [ hint ] [ hIntPos ] [ 0 ], HouseInt [ hint ] [ hIntPos ] [ 1 ], HouseInt [ hint ] [ hIntPos ] [ 2 ], house + 50, HouseInt [ hint ] [ hIntInterior ] );
                SendClientMessage ( playerid, COLOR_GREY, !"Вы отказались от покупки." );
                pTemp [ playerid ] [ SelectBuyInt ] = -1;
                return 1;
            }
            if ( pInfo [ playerid ] [ pBank ] < 500000 ) return SendClientMessage ( playerid, COLOR_GREY, !"Недостаточно средств в банке!" );
            
            GarageHouse [ H_IDX ] [ gCoast ] = 500000;
            GarageHouse [ H_IDX ] [ gVirtualWorld ] = house + 50;
            pInfo [ playerid ] [ pBank ] -= 500000;
            SavePlayerInteger ( playerid, "pBank", pInfo [ playerid ] [ pBank ] );
			LogMoney ( playerid, -500000, "Покупка гаража (интерьер)" );
            HouseInfo [ H_IDX ] [ hGarageID ] = idx_;
            pTemp [ playerid ] [ SelectBuyInt ] = -1;
            UpdateGarageInfo ( H_IDX, idx_, 1 );
            SendClientMessage ( playerid, COLOR_BLUE, !"Сделка прошла успешно" );
            SetPlayerPosAC ( playerid, HouseInt [ hint ] [ hIntPos ] [ 0 ], HouseInt [ hint ] [ hIntPos ] [ 1 ], HouseInt [ hint ] [ hIntPos ] [ 2 ], house + 50, HouseInt [ hint ] [ hIntInterior ] );
            /* Moretti */
            return 1;
		}
		case D_HOUSE_FUNC_13:
  		{
	    	if (!response)
			{
			    //DeletePVar(playerid, #StaticHouseID);
				return 1;
			}
	        new
				H_IDX = pTemp[playerid][tCurrentHouseID],
				idx = HouseInfo[H_IDX][hIntID];
			if ((IsPlayerInRangeOfPoint(playerid, 2.0, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2])
				|| (IsPlayerInRangeOfPoint(playerid, 2.0, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2]) && GetPlayerVirtualWorld(playerid) == H_IDX+50))
				&& strcmp(HouseInfo[H_IDX][hOwner],"None",true) == 0)
			{
				if (pInfo[playerid][pHouseID] != -1) return SendClientMessage(playerid, COLOR_GREY, !"У вас уже есть дом!"); 
				new cost = GetVipBoostMaxPlayerValueSale(playerid, vSaleHome, bSaleHome, HouseInfo[H_IDX][hValue]);
				new
					cost_home = cost+(GetHouseOplata(H_IDX) * 24);
				if (pInfo[playerid][pBank] < cost_home) return SendClientMessage(playerid, COLOR_GREY, !"Недостаточно денег для покупки на счету!");
				HouseInfo[H_IDX][hHel] = 0;
				HouseInfo[H_IDX][hLock] = 1;
				new
					query_[128]; 
                format(query_, sizeof query_, "`hHel`= '%d', `hLock`= '%d'", HouseInfo[H_IDX][hHel], HouseInfo[H_IDX][hLock]);
                SaveHouse(H_IDX, query_);
				strmid(HouseInfo[H_IDX][hOwner],pInfo[playerid][pName], 0, strlen(pInfo[playerid][pName]), MAX_PLAYER_NAME); 
				pInfo[playerid][pHouseID] = H_IDX;
                pTemp[playerid][tCurrentHouseID] = H_IDX;
				pInfo[playerid][pBank] -= cost_home; 
		
				format(string_chat_, sizeof (string_chat_), "покупка дома #%i", HouseInfo[H_IDX][hID]);
				LogMoney(playerid, -cost_home, string_chat_), string_chat_[0] = EOS;
			
	            HouseInfo[H_IDX][hTakings] = GetHouseOplata(H_IDX) * 24;
				SetPlayerPosAC(playerid, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2], H_IDX+50, HouseInt[idx][hIntInterior]);
	            OnPlayerQuestProgress(playerid, QUEST_GUEST, QUEST_TASK_HOUSE);
				pInfo[playerid][PlayerSpawn] = 1; 

                format(query_, sizeof query_,"playerspawn = '%i', pBank = '%i', pHouseID = '%i'",pInfo[playerid][PlayerSpawn], pInfo[playerid][pBank], pInfo[playerid][pHouseID]);
                SavePlayerStr(playerid, query_); 
				SendClientMessage(playerid, COLOR_WHITE, !"Поздравляем с покупкой!");
				SendMes(playerid, COLOR_YELLOW, "Внимание! Теперь каждый час со счёта вашего дома будут снимать комунальные платежи в размере $%d", GetHouseOplata(H_IDX));
				SendClientMessage(playerid, COLOR_YELLOW, !"Если на счету недостаточно денег, вас выселят");
				SendClientMessage(playerid, COLOR_YELLOW, !"Пополнить домашний счёт или узнать баланс можно через банк/банкомат (помощь: /mm -> команды)");
				GameTextForPlayer(playerid,"~w~welcome home~n~print:~g~/exit", 5000, 3); 
				UpdateHouseInfo(H_IDX, false);
				SaveHouseID(H_IDX); 
				return 1;
			}
			return 1;
        }
        case 12401:
		{
			if(!response) return DeletePVar(playerid,#P_House_Id);
			switch(listitem)
			{
                case 0: SPD(@p,12403,DIALOG_STYLE_LIST,"Аренда жилого помещения","{ffffff}1. 1 день\n2. 3 дня\n3. 1 неделя\n4. 2 недели","Выбор","Отмена");
                
			}
            return 1;
		}
        case 12403:
		{
			if(!response) return DeletePVar(playerid,#P_House_Id);
			new days;
			switch(listitem)
			{
			case 0: days = 1;
			case 1: days = 3;
			case 2: days = 7;
			case 3: days = 14;
			}
            new i = GetPVarInt(playerid,#P_House_Id);
			new rents = HouseInfo[i][rentsumma];
			new summ = (days*24)* rents;
			if(pInfo[playerid][pCash] < summ) return (GetPVarInt(playerid,#P_HArend)) ? (SCM(playerid,-1,"У вас недостаточно средств, чтобы продлить аренду этого дома на данный срок.")):(SCM(playerid,-1,"У вас недостаточно средств, чтобы арендовать этот дом на данный срок."));
			SetPVarInt(playerid,#P_Ar_Summ,summ);
			pInfo[playerid][pRent][0] = gettime();
			pInfo[playerid][pRent][1] = gettime() + days*U_Day;
			
            static const str0[] = "{ffffff}Вы действительно хотите продлить аренду на этот дом до {FF0000}%s{ffffff} за {FF0000}%d{ffffff} рублей?\n\n{B2B2B2}Данная сумма будет списана с вашего счета единоразово \nи возврату в случае расторжения договора не подлежит";
            new str[sizeof(str0)+32];
            format(str,sizeof(str),str0,date("%dd.%mm.%yyyy  %hh:%ii",pInfo[playerid][pRent][1]),summ);
            ShowPlayerDialog(playerid,12402,DIALOG_STYLE_MSGBOX,"Аренда дома(продление)",str,"Да","Нет");
        
			return 1;
		}
        case 12402:
		{
			if(!response)
			{
				pInfo[playerid][pRent][0] = 0;
				pInfo[playerid][pRent][1] = 0;
				DeletePVar(playerid,#P_Ar_Summ);
				SCM(playerid,-1,"Вы отказались от аренды этого дома.");
				return 1;
			}

			new i = GetPVarInt(@p,#P_House_Id);
		
            
            static const str0[] = "Вы продлили аренду этого дома до %s за %d рублей";
            new str[sizeof(str0)+32];
            format(str,sizeof(str),str0,date("%dd.%mm.%yyyy %hh:%ii",pInfo[playerid][pRent][1]),GetPVarInt(playerid,#P_Ar_Summ));
            DeletePVar(playerid,#P_HArend);
            SendClientMessage(playerid, COLOR_LIGHTBLUE, str);
    
			SendClientMessage(playerid, COLOR_GREY, "Чтобы выселиться из дома, используйте команду {FFFFFF}/unrenthouse");

             pInfo[playerid][pRentHouse] = HouseInfo[i][hID];

            pInfo[playerid][pCash] -= GetPVarInt(playerid,#P_Ar_Summ); GivePlayerMoneyEx(playerid);
		//	House[i][HBank] += GetPVarInt(playerid,#P_Ar_Summ);
		
        	DeletePVar(playerid,#P_House_Id);

			SavePlayerInteger(playerid, "pRentHouse", pInfo[playerid][pRentHouse]);
            SavePlayerInteger(playerid,"pCash",pInfo[playerid][pCash]);
			SavePlayerInteger(playerid,"rent_0",pInfo[playerid][pRent][0]);
			SavePlayerInteger(playerid,"rent_1",pInfo[playerid][pRent][1]);
         
			return 1;
		}
        case D_SELL_HOUSE_GOS:
		{
		    if (!response) return 1; 
			if (pInfo[playerid][pHouseID] == -1) {
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет дома");
				return 1;
			}
			new 
                H_IDX = pInfo[playerid][pHouseID],
                query_[128]; 
			HouseInfo[H_IDX][hHel] = 0;
			HouseInfo[H_IDX][hLock] = 1; 

            format(query_, sizeof query_, "`hHel`= '%d', `hLock`= '%d'", HouseInfo[H_IDX][hHel], HouseInfo[H_IDX][hLock]);
            SaveHouse(H_IDX, query_);


			strmid( HouseInfo[H_IDX][hOwner], "None", 0, strlen("None"), 15);
            new Float:summary = HouseInfo[H_IDX][hValue] + HouseInfo[H_IDX][hTakings];
			new house_cash = floatround(summary * 0.75); //75% от дома
			pInfo[playerid][pBank] += house_cash;
			LogMoney(playerid,house_cash, "продал дом в гос");
			new string_[64];
			format(string_,sizeof(string_),"~w~house in sold~n~~g~$%d",house_cash);
			GameTextForPlayer(playerid, string_, 5000, 3);
            pTemp[playerid][tCurrentHouseID] = -1;
			pInfo[playerid][pHouseID] = -1;
			pInfo[playerid][PlayerSpawn] = 0;  
            format(query_, sizeof query_,"playerspawn = '%i', pBank = '%i', pHouseID = '-1'",pInfo[playerid][PlayerSpawn], pInfo[playerid][pBank]);
		    SavePlayerStr(playerid, query_); 
			SetPlayerPosAC(playerid, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2], 0, 0);
			UpdateHouseInfo(H_IDX, false);
			SaveHouseID(H_IDX);
			CheckEvictFree(H_IDX); 
            CheckFamilyHouseFree(H_IDX);
            HouseInfo[H_IDX][hFamily] = pInfo[playerid][pFamily];
            format(t_string, sizeof t_string, "fDefHouse = '-1'");
            SaveFamily(playerid, t_string), t_string[0] = EOS;               
            return 1;
		}
        case D_SELL_HOUSE_GOS_0: {
            if (!response) {
                return 1;
            }
			if (pInfo[playerid][pHouseID] == -1) {
				SendClientMessage(playerid, COLOR_GREY, !"У Вас нет дома");
				return 1;
			}
			new 
                H_IDX = pInfo[playerid][pHouseID],
                query_[128]; 
			HouseInfo[H_IDX][hHel] = 0;
			HouseInfo[H_IDX][hLock] = 1; 
            HouseInfo[H_IDX][hValue] = HouseInfo[H_IDX][hReturnValue];
            format(query_, sizeof query_, "hHel = '%d', hLock = '%d', hValue = '%d'", HouseInfo[H_IDX][hHel], HouseInfo[H_IDX][hLock], HouseInfo[H_IDX][hValue]);
            SaveHouse(H_IDX, query_);
			strmid( HouseInfo[H_IDX][hOwner], "None", 0, strlen("None"), 15);
            pTemp[playerid][tCurrentHouseID] = -1;
			pInfo[playerid][pHouseID] = -1;
			pInfo[playerid][PlayerSpawn] = 0;  
            format(query_, sizeof query_,"`playerspawn` = '%i', `pHouseID` = '-1'",pInfo[playerid][PlayerSpawn]);
		    SavePlayerStr(playerid, query_); 
			SetPlayerPosAC(playerid, HouseInfo[H_IDX][hEnter][0], HouseInfo[H_IDX][hEnter][1], HouseInfo[H_IDX][hEnter][2], 0, 0);
			UpdateHouseInfo(H_IDX, false);
			SaveHouseID(H_IDX);
			CheckEvictFree(H_IDX); 
            CheckFamilyHouseFree(H_IDX);
            SendClientMessage(playerid, COLOR_LI_RED, !"[Оповещение] "colwhi"Вы успешно вернули дом госудаству");
            HouseInfo[H_IDX][hFamily] = pInfo[playerid][pFamily];
            format(t_string, sizeof t_string, "fDefHouse = '-1'");
            SaveFamily(playerid, t_string), t_string[0] = EOS;               
            return 1;
        }
    }
    return false;
} 
stock GetHouseOplata(idx)
{
	switch(HouseInfo[idx][hKlass])
	{
 		case 0: return 63; 
   		case 1: return 122;
        case 2: return 171;
        case 3: return 122;
        case 4: return 63;
        case 5: return 50;
	    default: return 0;
	}
	return 0;
}
GetHouseClassName(houseid, dest[MAX_HOUSE_CLASS_NAME + 1]) {
    dest[0] = EOS;
    
    switch(HouseInfo[houseid][hKlass])
    {
        case 0: dest = "Nope";
        case 1: dest = "D";
        case 2: dest = "C";
        case 3: dest = "B";
        case 4: dest = "A";
        case 5: dest = "S";
    }
} 
CMD:hleave(playerid)
{
	if (pInfo[playerid][pRentHouse] <= 0) return SendClientMessage(playerid, COLOR_GREY, !"Вы не где не подселены");
	pInfo[playerid][pRentHouse] = -1;
	SavePlayerInteger(playerid, "pRentHouse", pInfo[playerid][pRentHouse]);
    if (pInfo[playerid][PlayerSpawn] == 1) {
        SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш спавн был изменен на "colserver"\"Стандартный\"!");
        SavePlayerInteger(playerid, "playerspawn", pInfo[playerid][PlayerSpawn]);
    }
	SendClientMessage(playerid, COLOR_YELLOW, !"[Подсказка] "colwhi"Вы успешно выселились!");
	return 1;
}
CMD:hgarage(playerid, params[])
{
	if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
	if (sscanf(params, "dd", params[0], params[1])) return SendClientMessage(playerid, COLOR_GREY, !"/hgarage [HOUSE] [ID Garage]" ) ;

	if (params[0] < 1 || params[0] > TOTALHOUSE) return SendClientMessage(playerid, COLOR_GREY, !"Error ID House" ) ;
    if (params[1] < 0 || params[1] > sizeof(GarageInt)) return SendClientMessage(playerid, COLOR_GREY, !"Error ID Garage");
	if (GetPlayerState(playerid) != 2) return SendClientMessage(playerid, COLOR_GREY, !"Нужно находиться в транспорте." ) ;

	new 
        V_IDX = GetPlayerVehicleID(playerid),
        string_[128];

	GetVehiclePos(V_IDX, HouseInfo[ params[0] ][hCar][0], HouseInfo[ params[0] ][hCar][1], HouseInfo[ params[0] ][hCar][2]);
	GetVehicleZAngle(V_IDX, HouseInfo[ params[0]  ] [hCar][3]);
	HouseInfo[params[0]][hGarageID] = params[1];  
    HouseInfo[params[0]][hPickup][2] = CreateDynamicPickup(1318, 23, 
        GarageInt[params[1]][gEnterPos][0], 
        GarageInt[params[1]][gEnterPos][1], 
        GarageInt[params[1]][gEnterPos][2], 
        params[0]+50, 
        GarageInt[params[1]][gIntInterior]
    );
    format(string_, sizeof string_, ""colmaline"Гараж: %d\n"colwhi"Нажмите: \"H\"", HouseInfo[params[0]][hID]);
    HouseInfo[params[0]][hGarageExitText] = CreateDynamic3DTextLabel("{006666}Войти в дом\n"colwhi"Используйте: \"ALT\"",
        0x0076FCFF,  GarageInt[ params[1] ][gEnterPos][0], GarageInt[ params[1] ][gEnterPos][1], GarageInt[ params[1] ][gEnterPos][2] + 0.5, 5.0,
        .worldid = (params[0] + 50), .interiorid = GarageInt[ params[1] ][gIntInterior] 
    );
    HouseInfo[params[0]][hGarageText] = CreateDynamic3DTextLabel(string_, -1,
                                    HouseInfo[params[0]][hCar][0], 
                                    HouseInfo[params[0]][hCar][1],
                                    HouseInfo[params[0]][hCar][2], 
                                    9.0, .worldid = 0, .interiorid = 0);
	format(string_, sizeof string_, "Вы установили новые координаты гаража для %d дома.", params [0]);
	SendClientMessage(playerid, COLOR_WHITE, string_) ;

	format(string_, sizeof string_, "`hCarx` = '%.2f', `hCary` = '%.2f', `hCarz` = '%.2f',`hCarc` = '%.2f',`hGarageID` = '%d'",
	    HouseInfo[params[0]][hCar][0], 
        HouseInfo[params[0]][hCar][1], 
        HouseInfo[params[0]][hCar][2], 
        HouseInfo[params[0]][hCar][3],
        params[1]) ;
    SaveHouse(params[0], string_);
	return 1 ;
} 
stock SaveHouse(id, const query_string[]) {
	mysql_format(dbHandle, t_string, sizeof (t_string), 
		"UPDATE house SET %s WHERE hID = %i LIMIT 1", query_string, id
	);
	if (MYSQL_DEBUG) printf("CALLBACK | [SaveHouse]: \"%s\"", t_string);
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
}
stock SaveHouseID(idx)
{
 	new query_[180];
    format(query_, sizeof query_,"UPDATE `house` SET hOwner = '%s', hTakings = '%d', hKlass = '%d', hIntID = '%d', hValue = '%d' WHERE `hID` = '%d' LIMIT 1",
        HouseInfo[idx][hOwner], HouseInfo[idx][hTakings], HouseInfo[idx][hKlass], HouseInfo[idx][hIntID], HouseInfo[idx][hValue], HouseInfo[idx][hID]
    );
	mysql_tquery(dbHandle, query_, "", "");
	return 1;
}
stock SaveGarageID(idx)
{
 	new query_[180];
    format(query_, sizeof query_,"UPDATE `house` SET hOwner = '%s', hTakings = '%d', hKlass = '%d', gIntID = '%d', hValue = '%d' WHERE `hID` = '%d' LIMIT 1",
        HouseInfo[idx][hOwner], HouseInfo[idx][hTakings], HouseInfo[idx][hKlass], HouseInfo[idx][hIntID], HouseInfo[idx][hValue], HouseInfo[idx][hID]
    );
	mysql_tquery(dbHandle, query_, "", "");
	return 1;
}
stock SaveHouseString(idx, const field[], const var[])
{
	new query_[128];
	format(query_, sizeof query_, "UPDATE house SET  %s = '%s' WHERE hID = '%d' LIMIT 1", field, var, idx);
	mysql_tquery(dbHandle, query_, "", ""); 
	return 1;
}
stock SaveHouseInteger(idx, const field[], var)
{
	new query_[128];
	format(query_, sizeof query_, "UPDATE house SET  %s = '%d' WHERE hID = '%d' LIMIT 1", field, var, idx);
	mysql_tquery(dbHandle, query_, "", ""); 
	return 1;
}

stock GetHouseEvictCount(idx)
{
	new _veh_count = 0,
		query_[78]; //SELECT `Name`,`pID` FROM `s_users` WHERE `pRentHouse`='%d'
	format(query_, sizeof query_,"SELECT `Name`,`pID` FROM `s_users` WHERE `pRentHouse`='%d'", idx);
	new Cache: result = mysql_query(dbHandle, query_);
	_veh_count = cache_num_rows( );
	if (cache_is_valid(result)) cache_delete(result);
	return _veh_count;
}
stock CheckEvictFree(idx) {
    new query_[100]; 
	format(query_, sizeof query_,"SELECT `Name`,`pID` FROM `s_users` WHERE `pRentHouse`='%d'", idx);
	new Cache: result = mysql_query(dbHandle, query_), rows; 
    cache_get_row_count(rows);
    if (!rows) {
        if (cache_is_valid(result)) cache_delete(result);
        return 1;
    }
    for(new i = 0, account_id, name_[MAX_PLAYER_NAME], get_id; i < rows; i++)
    {
        cache_get_value_name_int(i, "pID", account_id);
        cache_get_value_name(i, "Name", name_, MAX_PLAYER_NAME + 1); 
        get_id = GetCheckID(name_);
        if (get_id != INVALID_PLAYER_ID) {   
            SendClientMessage(get_id, COLOR_YELLOW, !"[Подсказка] "colwhi"Дом, в котором Вы жили был продан");
            SendClientMessage(get_id, COLOR_YELLOW, !"[Подсказка] "colwhi"Ваш спавн был изменен на "colserver"\"Стандартный\"");
            pInfo[get_id][pRentHouse] = -1;
            pInfo[get_id][PlayerSpawn] = 0;
        }
        format(query_, sizeof query_, "UPDATE `s_users` SET `playerspawn` = '0', `pRentHouse` = '-1' WHERE `pID` = '%d'", account_id);
        mysql_tquery(dbHandle, query_);
    }
    if (cache_is_valid(result)) cache_delete(result);
    return 1;
}
CMD:hint(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /hint [id]");
    if (params[0] < 1 || params[0] > sizeof(HouseInt)) return SendClientMessage(playerid, COLOR_GREY, !"Error Int ID House" ) ;
    SetPlayerPosAC(playerid, HouseInt[params[0]][hIntPos][0], HouseInt[params[0]][hIntPos][1], HouseInt[params[0]][hIntPos][2], playerid + 50, HouseInt[params[0]][hIntInterior]);
    return 1;
}
CMD:clearsafe(playerid, params[]) {
    if (pInfo[playerid][pAdmin] < 4 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность");
    if (sscanf(params, "d", params[0])) return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /clearsafe [id]");
    new 
        data_g[48], 
        data_a[48], 
        data[48];
    for(new i; i < 6; i++) { 
        HouseInfo[params[0]][hSafeGun][i] = 0;
        HouseInfo[params[0]][hSafeAmmo][i] = 0;
        if (!i) {
            format(data_g, sizeof data_g, "%d", HouseInfo[params[0]][hSafeGun][i]);
            format(data_a, sizeof data_a, "%d", HouseInfo[params[0]][hSafeAmmo][i]);
        }
        else {
            format(data_g, sizeof data_g, "%s,%d", data_g, HouseInfo[params[0]][hSafeGun][i]);
            format(data_a, sizeof data_a, "%s,%d", data_a, HouseInfo[params[0]][hSafeAmmo][i]);
        }
        if (i > 3) continue;
        HouseInfo[params[0]][hSafe][i] = 0;
        if (!i) format(data, sizeof data, "%d", HouseInfo[params[0]][hSafe][i]); 
        else format(data, sizeof data, "%s,%d", data, HouseInfo[params[0]][hSafe][i]); 
    } 
	format(t_string, sizeof t_string, "UPDATE `house` SET `hSafe` = '%s', `hSafeGun` = '%s', `hSafeAmmo` = '%s' WHERE `hID` = '%d' LIMIT 1",
        data, data_g, data_a,
        HouseInfo[params[0]][hID]
    );
	mysql_tquery(dbHandle, t_string, "", ""), t_string[0] = EOS;
    return 1;
} 

/*tock GetPlayerHouse(playerid)
{
	new houseID = 0, time = GetTickCount();
	for(new i = 1; i <= TOTALHOUSE;i++)
	{
		if (strcmp(HouseInfo[i][hOwner], pInfo[playerid][pName], false) == 0 && strcmp(HouseInfo[i][hOwner],"None",true) != 0) 
        {
            houseID++; 
            pInfo[playerid][pHouseID] = i;
           // SetPVarInt(playerid, "PlayerHouseID", i);
        }
	}
    printf("[UpTime...] GetPlayerHouse: %d", GetTickCount() - time);
	return houseID;
}*/
CMD:sellhouse(playerid)
{
	if (pInfo[playerid][pHouseID] == -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вас нет дома!");
	new H_IDX = pInfo[playerid][pHouseID],
		idx = HouseInfo[H_IDX][hIntID];
	if (!IsPlayerInRangeOfPoint(playerid, 10, HouseInt[idx][hIntPos][0], HouseInt[idx][hIntPos][1], HouseInt[idx][hIntPos][2])) return 1;
	if (GetPlayerVirtualWorld(playerid) != H_IDX+50) return 1; 
    if (!HouseInfo[H_IDX][hValue]) {
        ShowPlayerDialog(playerid, D_SELL_HOUSE_GOS_0, DIALOG_STYLE_MSGBOX, ""colserver"Продажа: "colwhi"Дома",
            ""colwhi"Внимание! Вы собираетесь продать дом\n"col_li_red"Так как дом был приобретен за сертификат, вы не получите деньги с продажи дома",
            "Да", "Нет"
        );
    }
    else {
        new Float:summary = HouseInfo[H_IDX][hValue] + HouseInfo[H_IDX][hTakings];
		new house_cash = floatround(summary * 0.75); //75% от дома
        format(t_string, sizeof t_string, 
            ""colwhi"Внимание! Вы собираетесь продать дом\nВам будет выплачено "collime"75%% процентов"colwhi" от стоимости дома\n\nПродать дом за "collime"$%d"colwhi"?", house_cash
        );
        ShowPlayerDialog(playerid, D_SELL_HOUSE_GOS, DIALOG_STYLE_MSGBOX, ""colserver"Продажа: "colwhi"Дома", t_string, "Да", "Нет"), t_string[0] = EOS;
    } 
	return 1;
}



CMD:rentable(playerid, params[]) 
{

    new idx = 0;
	for(new i = 1; i <= TOTALHOUSE; i++) {
		if (IsPlayerInRangeOfPoint(playerid, 3.0, HouseInfo[i][hEnter][0], HouseInfo[i][hEnter][1], HouseInfo[i][hEnter][2]) && GetPlayerVirtualWorld(playerid) == 0) {
			idx = i;
			break;
		}
	}
	if(!idx) return SendClientMessage(playerid, COLOR_GREY, !"Вы должны находиться рядом с домом!"); 

    if (!strcmp(HouseInfo[idx][hOwner],"None",true)) return SendClientMessage(playerid, COLOR_GREY, !"У дома нет владельца!");
    if(pInfo[playerid][pHouseID] != -1) return SendClientMessage(playerid, COLOR_GREY, !"У Вас уже есть свой личный дом!");
  
    if(pInfo[playerid][pRentHouse] != -1) return SendClientMessage(playerid, COLOR_GRAD1, "Вы уже  арендуете другой дом! Воспользуйтесь командой  '/unrent_house'.");
   
   // SetPVarInt(playerid,#P_House_Id,idx);
    if(pInfo[playerid][pRentHouse] == HouseInfo[idx][hID] && GetPVarInt(@p,#P_HArend))
    {
         ShowPlayerDialog(playerid,12401,DIALOG_STYLE_LIST,"Действия с домом(продление аренды)","Арендовать","Далее","Отмена"); 
         return 1;
    }
    else ShowPlayerDialog(playerid,12401,DIALOG_STYLE_LIST,"Действия с домом","Арендовать","Далее","Отмена"); 
    

	return 1;
}

CMD:unrent_house(playerid, params[]) 
{
    if(pInfo[playerid][pRentHouse] == -1) return SendClientMessage(playerid, COLOR_GRAD1, "Вы не арендуете дом!");


    pInfo[playerid][pRentHouse] = -1;
    pInfo[playerid][pRent][0] = 0;
    pInfo[playerid][pRent][1] = 0;
    SavePlayerInteger(@p,"rent_0",0);
    SavePlayerInteger(@p,"rent_1",0);
    SavePlayerInteger(@p,"pRentHouse",-1);
    SCM(playerid, COLOR_LIGHTBLUE, "Вы выселились из дома!");

    new  query_[128]; 
    format(query_, sizeof query_, "UPDATE `s_users` SET `pRentHouse`='-1', `rent_1` = '0', `rent_0` = '0' WHERE `pID`='%d'",  pInfo[playerid][pID]);
    mysql_query(dbHandle, query_); 

    return 1;
}


/* ================================= Test CMD */
CMD:tickratestr(playerid) {
    SendMes(playerid, -1, "%d", Streamer_GetTickRate());
    return 1;
}
