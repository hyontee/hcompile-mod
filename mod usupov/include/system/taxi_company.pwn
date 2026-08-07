

#define TAXI_CLASS_ECONOMY  1
#define TAXI_CLASS_COMFORT  2
#define TAXI_CLASS_BUSINESS  3
#define TAXI_CLASS_BAD_RATING 0

enum main_orders_taxi
{
    Float:tStart_Vehicle[3],
    Float:tStart_Actor[4],
    Float:tFinish_Vehicle[3],
    Float:tFinish_Actor[4],
    TAXI_Type,
    TAXI_Status,
    TAXI_DistancePoints,
    TAXI_Actor[2]
}

#define TAXI_ORDER_NLOAD        0
#define TAXI_ORDER_NO_TAKE     1
#define TAXI_ORDER_STAGE_1        2
#define TAXI_ORDER_STAGE_2   3


new Text:taxi_panel_TD[1];
new PlayerText:taxi_panel_PTD[MAX_PLAYERS][4];


new orders_taxi[100][main_orders_taxi] = // 30 заказов по 3 раза (типо с разными комбинациями финишов и начала)
{
    {{2276.20,-1842.11,21.17}, {2272.86,-1841.69,21.96,267.64}, {2514.53,-2544.73,21.21}, {2511.05,-2547.73,21.98,95.62}, /*Спасибо Deepseek за помощь с координатами */             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0} /*Server_id | Skin */},//0
    {{2395.79,-2634.48,21.15}, {2394.22,-2629.56,21.98,176.84}, {2379.78,-1832.15,21.26}, {2384.80,-1831.48,21.87,257.01},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//1
    {{2303.20,-1917.76,21.26}, {2306.91,-1917.62,21.83,97.96}, {1037.94,-792.71,40.48}, {1034.43,-794.50,41.32,107.16},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//2
    {{2504.69,-666.45,11.59}, {2504.73,-669.54,12.33,5.80}, {-529.93,-1776.87,40.28}, {-527.22,-1778.52,40.92,240.62},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//3
    {{-520.87,-1553.05,40.53}, {-519.10,-1548.52,41.17,164.99}, {-2472.08,-262.23,26.86}, {-2468.44,-261.46,27.58,275.37},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//4
    {{-2332.43,54.63,25.75}, {-2332.19,50.80,26.48,355.20}, {-2175.15,-231.07,25.94}, {-2178.79,-234.04,26.70,129.04},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//5
    {{-2178.34,-247.79,25.82}, {-2181.98,-247.65,26.70,256.26}, {-1764.19,779.63,34.82}, {-1764.73,782.78,35.60,8.60},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//6
    {{-1764.01,796.53,35.05}, {-1762.53,794.62,35.78,6.94}, {-275.65,1040.48,11.49}, {-276.00,1036.41,12.13,197.25},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//7
    {{-308.18,914.65,11.51}, {-303.72,912.06,12.14,45.13}, {2766.11,-2419.33,21.03}, {2766.61,-2423.09,21.77,168.61},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//8
    {{2688.51,-2452.17,21.03}, {2694.06,-2453.08,21.77,68.04}, {-2418.62,180.65,25.36}, {-2418.39,183.05,26.09,356.95},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//9
    {{407.83,322.44,11.36}, {410.20,322.14,12.20,68.46}, {340.98,1892.38,11.35}, {341.03,1896.02,11.99,8.41},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//10
    {{271.27,1877.26,11.36}, {270.91,1873.19,12.00,349.17}, {2007.94,1329.82,25.50}, {2004.46,1332.83,26.14,11.15},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//11
    {{1857.79,1326.24,9.12}, {1857.15,1329.23,9.75,174.96}, {-2386.08,2757.03,37.15}, {-2390.66,2755.39,38.73,148.39},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//12
    {{-2654.93,2868.41,36.80}, {-2656.32,2871.92,37.63,183.24}, {-2371.66,-375.77,28.70}, {-2369.87,-379.67,29.38,177.64},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//13
    {{-2549.23,-156.81,26.51}, {-2545.93,-154.57,27.25,77.13}, {1896.24,-2248.71,10.18}, {1892.95,-2245.87,11.00,350.59},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//14
    {{1908.14,-2262.27,10.19}, {1909.15,-2265.12,11.02,353.62}, {1869.10,-138.79,15.05}, {1872.85,-140.62,15.69,206.21},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//15
    {{700.15,284.64,12.26}, {700.94,287.19,13.02,161.37}, {-114.06,936.48,11.36}, {-114.40,939.63,12.15,331.99},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//16
    {{-157.18,980.76,11.40}, {-153.73,980.84,12.04,82.73}, {251.19,1640.53,11.36}, {251.18,1636.92,12.14,170.76},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//17
    {{615.46,1708.74,11.43}, {619.06,1708.26,12.10,76.53}, {-728.98,110.06,15.64}, {-730.75,108.17,16.35,110.49},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//18
    {{-707.53,108.61,15.64}, {-702.35,105.48,16.28,62.53}, {1869.05,1873.84,12.58}, {1865.68,1870.85,13.22,107.05},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//19
    {{1808.43,2508.97,13.83}, {1810.51,2510.77,14.59,131.49}, {83.50,1342.43,11.36}, {85.64,1341.80,12.00,257.67},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//20
    {{-26.26,1285.84,11.36}, {-28.17,1283.06,12.00,302.42}, {628.67,-1342.17,40.33}, {628.17,-1339.26,40.96,17.88},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//21
    {{572.28,-1191.48,40.32}, {573.31,-1193.94,40.95,27.02}, {-107.69,606.72,11.38}, {-105.23,608.22,12.08,349.84},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//22
    {{569.11,893.73,11.45}, {569.10,896.20,12.27,164.34}, {-1496.34,1574.00,35.72}, {-1499.13,1571.06,36.56,88.71},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//23
    {{1339.52,2350.31,16.87}, {1339.76,2352.49,17.67,177.04}, {1419.03,446.27,12.33}, {1420.35,447.99,13.16,329.36},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//24
    {{817.25,765.42,12.41}, {820.29,766.03,13.14,87.10}, {-1304.98,316.39,32.04}, {-1307.31,317.54,32.70,55.20},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//25
    {{479.89,744.83,11.36}, {480.13,741.69,12.00,346.94}, {-7.59,2597.06,10.23}, {-9.66,2597.40,10.98,84.11},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//26
    {{99.58,1845.10,8.76}, {100.01,1842.04,9.40,3.26}, {1774.50,-2415.79,10.15}, {1776.47,-2416.12,11.00,271.92},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//27
    {{1732.72,-2411.86,10.17}, {1729.44,-2412.31,11.00,276.65}, {1722.26,2417.16,14.84}, {1721.75,2419.53,15.47,347.08},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//28
    {{465.92,659.93,11.42}, {465.24,657.43,12.32,338.69}, {-1043.90,-1686.00,40.33}, {-1042.83,-1688.65,40.97,215.41},             TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}},//29
    
    {{2276.20,-1842.11,21.17}, {2272.86,-1841.69,21.96,267.64}, {-1043.90,-1686.00,40.33}, {-1042.83,-1688.65,40.97,215.41},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//0
    {{2395.79,-2634.48,21.15}, {2394.22,-2629.56,21.98,176.84}, {-2386.08,2757.03,37.15}, {-2390.66,2755.39,38.73,148.39},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//1
    {{2303.20,-1917.76,21.26}, {2306.91,-1917.62,21.83,97.96}, {1722.26,2417.16,14.84}, {1721.75,2419.53,15.47,347.08},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//2
    {{2504.69,-666.45,11.59}, {2504.73,-669.54,12.33,5.80}, {-529.93,-1776.87,40.28}, {-527.22,-1778.52,40.92,240.62},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//3
    {{-2178.34,-247.79,25.82}, {-2181.98,-247.65,26.70,256.26}, {-1304.98,316.39,32.04}, {-1307.31,317.54,32.70,55.20},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//4
    {{-2332.43,54.63,25.75}, {-2332.19,50.80,26.48,355.20}, {-1764.19,779.63,34.82}, {-1764.73,782.78,35.60,8.60},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//5
    {{-2178.34,-247.79,25.82}, {-2181.98,-247.65,26.70,256.26}, {-1764.19,779.63,34.82}, {-1764.73,782.78,35.60,8.60},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//6
    {{-1764.01,796.53,35.05}, {-1762.53,794.62,35.78,6.94}, {-275.65,1040.48,11.49}, {-276.00,1036.41,12.13,197.25},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//7
    {{-308.18,914.65,11.51}, {-303.72,912.06,12.14,45.13}, {-1496.34,1574.00,35.72}, {-1499.13,1571.06,36.56,88.71},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//8
    {{2688.51,-2452.17,21.03}, {2694.06,-2453.08,21.77,68.04}, {-2418.62,180.65,25.36}, {-2418.39,183.05,26.09,356.95},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//9
    {{700.15,284.64,12.26}, {700.94,287.19,13.02,161.37}, {-275.65,1040.48,11.49}, {-276.00,1036.41,12.13,197.25},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//10
    {{271.27,1877.26,11.36}, {270.91,1873.19,12.00,349.17}, {2007.94,1329.82,25.50}, {2004.46,1332.83,26.14,11.15},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//11
    {{1857.79,1326.24,9.12}, {1857.15,1329.23,9.75,174.96}, {1896.24,-2248.71,10.18}, {1892.95,-2245.87,11.00,350.59},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//12
    {{-2654.93,2868.41,36.80}, {-2656.32,2871.92,37.63,183.24}, {-2371.66,-375.77,28.70}, {-2369.87,-379.67,29.38,177.64},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//13
    {{-2549.23,-156.81,26.51}, {-2545.93,-154.57,27.25,77.13}, {1896.24,-2248.71,10.18}, {1892.95,-2245.87,11.00,350.59},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//14
    {{1857.79,1326.24,9.12}, {1857.15,1329.23,9.75,174.96}, {1869.10,-138.79,15.05}, {1872.85,-140.62,15.69,206.21},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//15
    {{700.15,284.64,12.26}, {700.94,287.19,13.02,161.37}, {-7.59,2597.06,10.23}, {-9.66,2597.40,10.98,84.11},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//16
    {{-157.18,980.76,11.40}, {-153.73,980.84,12.04,82.73}, {251.19,1640.53,11.36}, {251.18,1636.92,12.14,170.76},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//17
    {{615.46,1708.74,11.43}, {619.06,1708.26,12.10,76.53}, {-728.98,110.06,15.64}, {-730.75,108.17,16.35,110.49},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//18
    {{572.28,-1191.48,40.32}, {573.31,-1193.94,40.95,27.02}, {1869.05,1873.84,12.58}, {1865.68,1870.85,13.22,107.05},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//19
    {{2688.51,-2452.17,21.03}, {2694.06,-2453.08,21.77,68.04}, {251.19,1640.53,11.36}, {251.18,1636.92,12.14,170.76},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//20
    {{-26.26,1285.84,11.36}, {-28.17,1283.06,12.00,302.42}, {628.67,-1342.17,40.33}, {628.17,-1339.26,40.96,17.88},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//21
    {{572.28,-1191.48,40.32}, {573.31,-1193.94,40.95,27.02}, {-1496.34,1574.00,35.72}, {-1499.13,1571.06,36.56,88.71},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//22
    {{569.11,893.73,11.45}, {569.10,896.20,12.27,164.34}, {-1496.34,1574.00,35.72}, {-1499.13,1571.06,36.56,88.71},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//23
    {{-2654.93,2868.41,36.80}, {-2656.32,2871.92,37.63,183.24}, {1419.03,446.27,12.33}, {1420.35,447.99,13.16,329.36},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//24
    {{817.25,765.42,12.41}, {820.29,766.03,13.14,87.10}, {-1304.98,316.39,32.04}, {-1307.31,317.54,32.70,55.20},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//25
    {{479.89,744.83,11.36}, {480.13,741.69,12.00,346.94}, {-7.59,2597.06,10.23}, {-9.66,2597.40,10.98,84.11},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//26
    {{99.58,1845.10,8.76}, {100.01,1842.04,9.40,3.26},  {-107.69,606.72,11.38}, {-105.23,608.22,12.08,349.84},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//27
    {{2504.69,-666.45,11.59}, {2504.73,-669.54,12.33,5.80}, {-2371.66,-375.77,28.70}, {-2369.87,-379.67,29.38,177.64},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//28
    {{1732.72,-2411.86,10.17}, {1729.44,-2412.31,11.00,276.65}, {628.67,-1342.17,40.33}, {628.17,-1339.26,40.96,17.88},             TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}},//29
    
    {{2276.20,-1842.11,21.17}, {2272.86,-1841.69,21.96,267.64}, {1037.94,-792.71,40.48}, {1034.43,-794.50,41.32,107.16},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 0
    {{2395.79,-2634.48,21.15}, {2394.22,-2629.56,21.98,176.84}, {2514.53,-2544.73,21.21}, {2511.05,-2547.73,21.98,95.62},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 1
    {{2303.20,-1917.76,21.26}, {2306.91,-1917.62,21.83,97.96}, {2379.78,-1832.15,21.26}, {2384.80,-1831.48,21.87,257.01},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 2
    {{2504.69,-666.45,11.59}, {2504.73,-669.54,12.33,5.80}, {-520.87,-1553.05,40.53}, {-519.10,-1548.52,41.17,164.99},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 3
    {{-2332.43,54.63,25.75}, {-2332.19,50.80,26.48,355.20}, {-2175.15,-231.07,25.94}, {-2178.79,-234.04,26.70,129.04},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 4
    {{-2178.34,-247.79,25.82}, {-2181.98,-247.65,26.70,256.26}, {-1764.01,796.53,35.05}, {-1762.53,794.62,35.78,6.94},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 5
    {{-1764.19,779.63,34.82}, {-1764.73,782.78,35.60,8.60}, {-308.18,914.65,11.51}, {-303.72,912.06,12.14,45.13},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 6
    {{-275.65,1040.48,11.49}, {-276.00,1036.41,12.13,197.25}, {2688.51,-2452.17,21.03}, {2694.06,-2453.08,21.77,68.04},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 7
    {{-1496.34,1574.00,35.72}, {-1499.13,1571.06,36.56,88.71}, {407.83,322.44,11.36}, {410.20,322.14,12.20,68.46},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 8
    {{-2418.62,180.65,25.36}, {-2418.39,183.05,26.09,356.95}, {271.27,1877.26,11.36}, {270.91,1873.19,12.00,349.17},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 9
    {{340.98,1892.38,11.35}, {341.03,1896.02,11.99,8.41}, {1857.79,1326.24,9.12}, {1857.15,1329.23,9.75,174.96},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 10
    {{2007.94,1329.82,25.50}, {2004.46,1332.83,26.14,11.15}, {-2654.93,2868.41,36.80}, {-2656.32,2871.92,37.63,183.24},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 11
    {{-2386.08,2757.03,37.15}, {-2390.66,2755.39,38.73,148.39}, {-2549.23,-156.81,26.51}, {-2545.93,-154.57,27.25,77.13},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 12
    {{-2371.66,-375.77,28.70}, {-2369.87,-379.67,29.38,177.64}, {1908.14,-2262.27,10.19}, {1909.15,-2265.12,11.02,353.62},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 13
    {{1896.24,-2248.71,10.18}, {1892.95,-2245.87,11.00,350.59}, {700.15,284.64,12.26}, {700.94,287.19,13.02,161.37},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 14
    {{1869.10,-138.79,15.05}, {1872.85,-140.62,15.69,206.21}, {-157.18,980.76,11.40}, {-153.73,980.84,12.04,82.73},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 15
    {{-114.06,936.48,11.36}, {-114.40,939.63,12.15,331.99}, {615.46,1708.74,11.43}, {619.06,1708.26,12.10,76.53},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 16
    {{251.19,1640.53,11.36}, {251.18,1636.92,12.14,170.76}, {572.28,-1191.48,40.32}, {573.31,-1193.94,40.95,27.02},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 17
    {{-728.98,110.06,15.64}, {-730.75,108.17,16.35,110.49}, {569.11,893.73,11.45}, {569.10,896.20,12.27,164.34},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 18
    {{1869.05,1873.84,12.58}, {1865.68,1870.85,13.22,107.05}, {-26.26,1285.84,11.36}, {-28.17,1283.06,12.00,302.42},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 19
    {{-1043.90,-1686.00,40.33}, {-1042.83,-1688.65,40.97,215.41}, {817.25,765.42,12.41}, {820.29,766.03,13.14,87.10},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 20
    {{1722.26,2417.16,14.84}, {1721.75,2419.53,15.47,347.08}, {479.89,744.83,11.36}, {480.13,741.69,12.00,346.94},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 21
    {{-529.93,-1776.87,40.28}, {-527.22,-1778.52,40.92,240.62}, {99.58,1845.10,8.76}, {100.01,1842.04,9.40,3.26},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 22
    {{-1304.98,316.39,32.04}, {-1307.31,317.54,32.70,55.20}, {1732.72,-2411.86,10.17}, {1729.44,-2412.31,11.00,276.65},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 23
    {{-7.59,2597.06,10.23}, {-9.66,2597.40,10.98,84.11}, {1339.52,2350.31,16.87}, {1339.76,2352.49,17.67,177.04},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 24
    {{1774.50,-2415.79,10.15}, {1776.47,-2416.12,11.00,271.92}, {1419.03,446.27,12.33}, {1420.35,447.99,13.16,329.36},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 25
    {{628.67,-1342.17,40.33}, {628.17,-1339.26,40.96,17.88}, {-107.69,606.72,11.38}, {-105.23,608.22,12.08,349.84},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 26
    {{1808.43,2508.97,13.83}, {1810.51,2510.77,14.59,131.49}, {83.50,1342.43,11.36}, {85.64,1341.80,12.00,257.67},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 27
    {{-707.53,108.61,15.64}, {-702.35,105.48,16.28,62.53}, {465.92,659.93,11.42}, {465.24,657.43,12.32,338.69},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 28
    {{2504.69,-666.45,11.59}, {2504.73,-669.54,12.33,5.80}, {2688.51,-2452.17,21.03}, {2694.06,-2453.08,21.77,68.04},          TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 29

    {{1774.50,-2415.79,10.15}, {1776.47,-2416.12,11.00,271.92}, {1732.72,-2411.86,10.17}, {1729.44,-2412.31,11.00,276.65},                   TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 23
    {{-7.59,2597.06,10.23}, {-9.66,2597.40,10.98,84.11}, {1339.52,2350.31,16.87}, {1339.76,2352.49,17.67,177.04},                   TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 24
    {{1774.50,-2415.79,10.15}, {1776.47,-2416.12,11.00,271.92}, {1419.03,446.27,12.33}, {1420.35,447.99,13.16,329.36},                   TAXI_CLASS_COMFORT, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 25
    {{628.67,-1342.17,40.33}, {628.17,-1339.26,40.96,17.88}, {465.92,659.93,11.42}, {465.24,657.43,12.32,338.69},                   TAXI_CLASS_ECONOMY, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 26
    {{1808.43,2508.97,13.83}, {1810.51,2510.77,14.59,131.49}, {-2654.93,2868.41,36.80}, {-2656.32,2871.92,37.63,183.24},                   TAXI_CLASS_BUSINESS, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 27

    {{176.36,735.37,11.45}, {0.0, 0.0, 0.0}, {-661.08,-1561.75,40.50}, {0.0, 0.0, 0.0},          TAXI_CLASS_BAD_RATING, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 23
    {{2434.15,-1911.76,21.37}, {0.0, 0.0, 0.0}, {-443.78,1404.16,20.17},{0.0, 0.0, 0.0},          TAXI_CLASS_BAD_RATING, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 24
    {{-538.29,1306.05,20.10}, {0.0, 0.0, 0.0}, {2030.16,1327.01,25.50}, {0.0, 0.0, 0.0},          TAXI_CLASS_BAD_RATING, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 25
    {{2257.82,-2099.56,21.33}, {0.0, 0.0, 0.0}, {2469.95,-208.89,1.50}, {0.0, 0.0, 0.0},          TAXI_CLASS_BAD_RATING, TAXI_ORDER_NLOAD, 0,{0, 0}}, // 26
    {{-1756.40,773.78,34.84}, {0.0, 0.0, 0.0}, {567.17,1000.84,11.69}, {0.0, 0.0, 0.0},          TAXI_CLASS_BAD_RATING, TAXI_ORDER_NLOAD, 0,{0, 0}} // 27
};


new Float:spawn_veh_taxi[3][4] = 
{
    {2424.359130,1377.407226,11.175258,0.927040},
    {364.510589,1380.897827,14.326881,267.020996},
    {2209.517333,-1734.787963,20.982763,1.837921}
};

new vehicle_taxi[3][] = {
    {419,401,404,479,412,458,491,492,585,529,540,547},
    {507,546,426,516,467,445,587,436,560,565,550,551,442},
    {489,505,400,405,402,475,604,490,490,579}
};

new taxi_name[3][28] = {
    "turbo.gett",
    "Swift Taxi",
    "meloveh.gett"
};

new taxi_company[3][2]; //sql , server_id

new class_name[4][9] = 
{
    "Грузовой",
    "Эконом",
    "Комфорт",
    "Бизнес"
};

new Float:taxi_enter[3][3] = {{2416.024658,1395.267822,12.647074}, {381.969848,1372.543212,15.451137}, {2225.064453,-1722.036376,22.281120} }, 
Float:taxi_exit_spawn[3][4] = {{2415.953369,1394.212890,12.654015,181.360275}, {380.612731,1372.525512,15.451137,86.802749}, {2225.074707,-1723.181518,22.281120,180.332794}},
//Float:taxi_exit[3] = {-0.251249,2500.500000,2011.005126},
//Float:taxi_enter_spawn[4] = {-0.251249,2502.8,2011.005126,0.857749},
Float:taxi_main[4] = {2.167587,2502.182128,2011.005126,19.245954}; //krch kak i realtor

new taxi_main_area[3];

#define GetNameClass(%0)    class_name[floatround(%0/100, floatround_floor)]
new BUSINESS_TYPE_TAXI_COMP;
public: CREATE_BUSINESS_TAXI()
{
    mysql_query(mysql, "SELECT * FROM accounts WHERE taxi_company AND taxi_rating", false);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `taxi_company` INT NOT NULL DEFAULT '-1' AFTER `job`, ADD `taxi_rating` INT NOT NULL DEFAULT '100' AFTER `taxi_company`", false);
    }

    new string[584];

    mysql_format(mysql, string, sizeof string, "SELECT * FROM business WHERE type = %d", BUSINESS_TYPE_TAXI_COMP);
    new Cache:cache = mysql_query(mysql, string, true);

    if(!cache_num_rows())
    {
        for(new i; i < 3;i ++)
        {
            mysql_format(mysql, string, sizeof string, "INSERT INTO `business` (`owner_id`, `name`, `improvements`, `products`, `prod_price`, `balance`, `rent_time`, `price`, `rent_price`, `type`, `interior`, `enter_price`, `enter_music`, `lock`, `x`, `y`, `z`, `exit_x`, `exit_y`, `exit_z`, `exit_angle`, `eviction`, `office_id`) \
            VALUES ('0', '%s', '0', '0', '0', '0', '0', '15000000', '1500', '%d', '11', '0', '0', '0', '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', '%.2f', '0', '-1')", 
            taxi_name[i], BUSINESS_TYPE_TAXI_COMP,    
            taxi_enter[i][0], taxi_enter[i][1], taxi_enter[i][2],
            taxi_exit_spawn[i][0], taxi_exit_spawn[i][1], taxi_exit_spawn[i][2], taxi_exit_spawn[i][3]
            );
            mysql_query(mysql, string, false);
            if(!mysql_errno()) printf("CREATE Business TAXI number %d", i);
        }
        SendRconCommand("gmx"); //Перезапуск
    }

    cache_delete(cache);

    return 1;
}

public OnGameModeInit()
{
    SetTimer("CREATE_BUSINESS_TAXI", 1500, false);
    for(new i; i < 100; i++){ //Тут вычисляется расстояние от старта до финиша (лучше конешно записать в массив, но для удобства каждый раз будет вычисляться)
        new distance = DistanceOrderToOrder(orders_taxi[i][tStart_Vehicle][0], orders_taxi[i][tStart_Vehicle][1], orders_taxi[i][tStart_Vehicle][2], 
        orders_taxi[i][tFinish_Vehicle][0], orders_taxi[i][tFinish_Vehicle][1], orders_taxi[i][tFinish_Vehicle][2]);

        orders_taxi[i][TAXI_DistancePoints] = distance;
    }
    TextDrawTaxi();

    SetTimer("LoadTaxiCompany", 2800, false);

    for(new i, p; i < 100;i ++)
    {
        if(orders_taxi[i][TAXI_Type] != TAXI_CLASS_BAD_RATING) continue;

        if(p != 5) orders_taxi[i][TAXI_Status] = TAXI_ORDER_NO_TAKE;
        p++;
    }

    for(new i= 1;i < 4;i++){
        for(new e, o; e < 100; e++){
            if(orders_taxi[e][TAXI_Status] != TAXI_ORDER_NLOAD) continue;
            else if(orders_taxi[e][TAXI_Type] != i) continue;

            if(o < 10){
                orders_taxi[e][TAXI_Status] = TAXI_ORDER_NO_TAKE;
                printf("order[%d] = %d", e, orders_taxi[e][TAXI_Status]);
            } else break;

            o++;
        }
    }

    SetTimer("UpdateNewOrderTaxi", 90000, true); // 90000 = 1,5 minute
    #if defined taxi_OnGameModeInit
        return taxi_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit taxi_OnGameModeInit
#if defined taxi_OnGameModeInit
    forward taxi_OnGameModeInit();
#endif

public:LoadTaxiCompany()
{
    for(new i, world,string[84];i < 3;i ++)
    {
        for(new e; e < g_business_loaded;e++)
        {
            if(GetBusinessData(e, B_SQL_ID) && strfind(GetBusinessData(e, B_NAME), taxi_name[i]) != -1)
            {
                taxi_company[i][0] = GetBusinessData(e, B_SQL_ID);
                taxi_company[i][1] = e;

                world = taxi_company[i][1] + 255;
                /*taxi_enter_pickup[i] = CreatePickup(19231, 23, taxi_enter[i][0], taxi_enter[i][1], taxi_enter[i][2], 0);
                taxi_exit_pickup[i] = CreatePickup(19231, 23, taxi_exit[0], taxi_exit[1], taxi_exit[2], world);*/

                format(string, sizeof string, "Таксопарк: {FFFF00}\"%s\"{FFFFFF}\nПодойдите для ознакомления", taxi_name[i]);

                Create3DTextLabel(string, -1, taxi_main[0], taxi_main[1], taxi_main[2], 3.5, world);
                CreateDynamicActor(25, taxi_main[0], taxi_main[1], taxi_main[2], taxi_main[3], _, _, world, 1);
                taxi_main_area[i] = CreateDynamicSphere(taxi_main[0], taxi_main[1], taxi_main[2], 1.5, world, 1);
            }
        }
    }

    return 1;
}

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    new taxi = -1;
    for(new i;i < 3; i ++) { if( areaid == taxi_main_area[i ] ) { taxi = i; break; }}

    if(taxi != -1) {
        new string[48];
        format(string, sizeof string, "Таксопарк {FFFF00}%s", taxi_name[taxi]);

        Dialog
        (
            playerid, 3321, DIALOG_STYLE_LIST, string, 
            "1. Устроиться в таксопарк\n2. Личная карточка\n3. Арендовать транспорт\n4. Взять заказ\n5. Зарегистрировать личный транспорт", "Далее", "Выйти"
        );

        SetPVarInt(playerid, "select_taxi", taxi+1);
    }
    #if defined taxi_OnPlayerEnterDynamicArea
        return taxi_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea taxi_OnPlayerEnterDynamicArea
#if defined taxi_OnPlayerEnterDynamicArea
    forward taxi_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 3321){
        if(response){

            new taxi = GetPlayerData(playerid, P_TAXI_COMPANY), select = GetPVarInt(playerid, "select_taxi")-1;
            switch(listitem)
            {
                case 0: {

                    if(GetPlayerData(playerid, P_TAXI_COMPANY) == select) return SendClientMessage(playerid, -1, "Вы уже состоите в данном таксопарке");

                    SetPlayerData(playerid, P_TAXI_COMPANY, select);

                    new string[84];
                    format(string, sizeof string, "Вы устроились в таксопарк {FFFF00}\"%s\"", taxi_name[select]);
                    SendClientMessage(playerid, -1, string);
                }
                case 1:{
                    if(taxi != select) return SendClientMessage(playerid, -1, "Вы не состоите в этом таксопарке");

                    new string[248], rating = GetPlayerData(playerid, P_TAXI_RATING);


                    format(
                        string, sizeof string, 
                        "Таксопарк: {FFFF00}%s\n{FFFFFF}Количество рейтинга: {FFFF00}%d\nКласс такси: %s", taxi_name[taxi],
                        rating, class_name[GetPlayerClassTaxi(playerid, false)]
                    );

                    Dialog(playerid, -1, DIALOG_STYLE_LIST, "Личная карточка", string, "Выйти", "");
                }
                case 2:{
                    if(taxi != select) return SendClientMessage(playerid, -1, "Вы не состоите в этом таксопарке");


                    Dialog(playerid, 3323, DIALOG_STYLE_MSGBOX, "Аренда транспорта", "Вы действительно хотите арендовать рабочий транспорт\nСтоимость: 3000 руб.", "Арендовать", "Выйти");

                }
                case 3:{
                    if(taxi != select) return SendClientMessage(playerid, -1, "Вы не состоите в этом таксопарке");
                    else if(GetPlayerData(playerid, P_TAXI_VEHICLE) == -1) return SendClientMessage(playerid, -1, "У вас нет транспорта. Арендуйте его или зарегистрируйте личный транспорт (доступно с Комфорта)");

                    if(GetPlayerData(playerid, P_TAXI_ORDER) != -1) {
                        SendClientMessage(playerid, -1, "Вы отказались от заказа");
                        TaxiSetRating(playerid, -1);
                        TaxiFinishOrder(playerid);
                    }
                    
                    ShowPlayerOrderTaxi(playerid);
                }
                case 4:{
                    if(GetPlayerData(playerid, P_TAXI_ORDER) != -1) return SendClientMessage(playerid, -1, "Сначала выполните заказ");
                    if(GetPlayerOwnableCar(playerid) == INVALID_VEHICLE_ID) return SendClientMessage(playerid, -1, "Ваш личный транспорт не загружен на сервере");

                    new vehicleid = GetPlayerOwnableCar(playerid), model = GetVehicleModel(vehicleid), class = GetPlayerClassTaxi(playerid, true),
                    bool:allow =false;

                    if(GetPlayerData(playerid, P_TAXI_VEHICLE) == vehicleid) {
                        SetPlayerData(playerid, P_TAXI_VEHICLE, -1);
                        SendClientMessage(playerid, -1, "Вы отозвали регистрацию транспорта в таксопарк. Вы больше не можете работать на личном транспорте");
                        ChangeVehicleColor(vehicleid, GetOwnableCarData(vehicleid, OC_COLOR_1), GetOwnableCarData(vehicleid, OC_COLOR_2));
                        return 1;
                    }
                    for(new i; i < 14; i++){
                        if(vehicle_taxi[class][i] == model) { allow = true; break;}
                    }

                    if(!allow) SendClientMessage(playerid, -1, "Ваш транспорт не подходит к вашему классу или не пятидверный");
                    else {
                        SetPlayerData(playerid, P_TAXI_VEHICLE, vehicleid);
                        ChangeVehicleColor(vehicleid, 6, 6);

                        new string[124];
                        format(string, sizeof string, "Вы успешно зарегистрировали %s в таксопарк", GetVehicleInfo(model-400, VI_NAME));
                        SendClientMessage(playerid, -1, string);
                        SendClientMessage(playerid, -1, "Возьмите заказ чтобы начать работу");
                    }
                }
            }
        }
    }
    if(dialogid == 3322)
    {
       if(response)
        {
            if(GetPVarInt(playerid, "select_id"))
            {
                new id = GetPVarInt(playerid, "select_id")-1;

                if(orders_taxi[id][TAXI_Type] > GetPlayerClassTaxi(playerid)) return SendClientMessage(playerid, -1, "Ваш класс ниже требуемого");
                else if(GetPlayerData(playerid, P_TAXI_VEHICLE) == -1) return SendClientMessage(playerid, -1, "У вас нет транспорта. Арендуйте его или зарегистрируйте личный транспорт (доступно с Комфорта)");

                if(GetPlayerVehicleID(playerid) != GetPlayerData(playerid, P_TAXI_VEHICLE)) {
                    new taxi = GetPlayerData(playerid, P_TAXI_COMPANY);
                    new Float:distance = GetVehicleDistanceFromPoint(GetPlayerData(playerid, P_TAXI_VEHICLE), taxi_enter[taxi][0],taxi_enter[taxi][1],taxi_enter[taxi][2]);

                    if(distance > 100.0) return SendClientMessage(playerid, -1, "Ваш рабочий транспорт далеко от таксопарка");
                    SetPlayerVirtualWorld(playerid, 0);
                    SetPlayerInterior(playerid, 0);
                    PutPlayerInVehicle(playerid, GetPlayerData(playerid, P_TAXI_VEHICLE), 0);
                }

                SendClientMessage(playerid, -1, "Вы успешно взяли заказ. Отправляйтесь на метку на карте");
                
                orders_taxi[id][TAXI_Status] = TAXI_ORDER_STAGE_1;
                SetPlayerData(playerid, P_TAXI_ORDER, id);
                SetPlayerData(playerid, P_TAXI_ORDER_RATING, 5);

                TaxiStartOrder(playerid);
                SetPlayerData(playerid, P_TAXI_TIMER, SetTimerEx("TaxiTimer", 1000, true, "ii", playerid, id));
                return 1;
            }
            
            if(listitem == 0 || listitem == 1)
            {
                new list_dialog = GetPVarInt(playerid, "list_dialog");

                if(!listitem)  list_dialog++;
                else if(listitem == 1 && list_dialog != 1) list_dialog--;
                SetPVarInt(playerid, "list_dialog", list_dialog);

                new max_list = 10 * GetPVarInt(playerid, "list_dialog");

                new list[68], string[sizeof list * 10 +48] = "Следующая страница\nПредыдущая страница\n", factor = GetPlayerClassTaxi(playerid);

                if(!factor) factor++;

                for(new i,or_all, or_dlg = max_list-10, l_dlg = 2, salary, salary_for_km, salary_for_100m; i < 100;i ++) //гавнокод (net)
                {
                    if(or_dlg == max_list) break;
                    if(orders_taxi[i][TAXI_Status] != TAXI_ORDER_NO_TAKE) continue;
                    or_all++;
                    if(or_dlg > or_all) continue;

                    salary = floatround((orders_taxi[i][TAXI_DistancePoints]/100)*factor, floatround_ceil), salary_for_100m =(10*salary)*factor, salary_for_km = salary_for_100m*10;

                    format(list, sizeof list, "%d. Заказ №%d\t %s\t %d за км\n", or_dlg, i+1, class_name[orders_taxi[i][TAXI_Type]],  salary_for_km);
                    strcat(string, list);
                    SetPlayerListitemValue(playerid, l_dlg, i);
                    or_dlg++; l_dlg++;
                }
                Dialog(playerid, 3322, DIALOG_STYLE_LIST, "Список заказов", string, "Далее", "Выйти");

                return 1;
            }

            new id = GetPlayerListitemValue(playerid, listitem), string[214], distance = orders_taxi[id][TAXI_DistancePoints], time, distance_player = floatround(GetPlayerDistanceFromPoint(playerid, orders_taxi[id][tStart_Vehicle][0],
            orders_taxi[id][tStart_Vehicle][1],orders_taxi[id][tStart_Vehicle][2])), factor = GetPlayerClassTaxi(playerid);
            if(!factor) factor = 1;
            new salary = floatround((orders_taxi[id][TAXI_DistancePoints]/100)*factor, floatround_ceil),salary_for_100m =(10*salary)*factor, salary_for_km = salary_for_100m*10;

            switch(distance){
                case 0..1000:time = 120;
                case 1001..1500:time = 180;
                case 1501..2000:time = 360;
                case 2001..3000:time = 420;
                default:time = 480; 
            }

            switch(distance_player) 
            {
                case 1000..2000:time += 60;
                case 2001..3000:time += 120;
                case 3001..4000:time += 240;
            }


            format(string, sizeof string, 
            "Заказ №%d\nТребуемый класс: %s и выше\nРасстояние точек от друг друга: %d м.\nВаше расстояния от стартовой точки: %d м.\nОплата за километр: %d руб\n\
            Время выполнения: %d:%02d", id+1, class_name[orders_taxi[id][TAXI_Type]], distance, distance_player, salary_for_km, ConvertUnixTime(time, CONVERT_TIME_TO_MINUTES), ConvertUnixTime(time, CONVERT_TIME_TO_SECONDS));

            Dialog
            (
                playerid, 3322, DIALOG_STYLE_MSGBOX,
                "Описание заказа",
                string,
                "Далее", "Выйти"
            );
            
            SetPVarInt(playerid, "select_id", id+1);
            SetPlayerData(playerid, P_TAXI_SECOND, time);
            SetPlayerData(playerid, P_TAXI_SALARY_100M, salary_for_100m);
        }
    }
    if(dialogid == 3323){
        if(response){

            new vehicleid = GetPlayerData(playerid, P_TAXI_VEHICLE);

            if(vehicleid != -1){

                if(vehicleid == GetPlayerOwnableCar(playerid)) return SendClientMessage(playerid, -1, "Вы зарегистрировали личный транспорт для работы в такси. Аренда рабочего невозможна");

                if(IsValidVehicle(vehicleid)) DestroyVehicle(vehicleid);

                SetPlayerData(playerid, P_TAXI_VEHICLE, -1);
                SendClientMessage(playerid, -1, "Вы отказались от рабочего транспорта");
            }

            if(GetPlayerMoneyEx(playerid) < 3000) return SendClientMessage(playerid, -1, "У вас нет 3000 руб. для аренды транспорта");

            new taxi = GetPlayerData(playerid, P_TAXI_COMPANY), factor = GetPlayerClassTaxi(playerid, true);

            if(taxi != GetPVarInt(playerid, "select_taxi")-1) return SendClientMessage(playerid, -1, "Вы не состоите в данном таксопарке");

            vehicleid = CreateVehicle(vehicle_taxi[factor][0], spawn_veh_taxi[taxi][0], spawn_veh_taxi[taxi][1], spawn_veh_taxi[taxi][2], spawn_veh_taxi[taxi][3], 6,6, 0, _, VEHICLE_ACTION_TYPE_TAXI_DRIVER);

            SetPlayerData(playerid, P_TAXI_VEHICLE, vehicleid);

            SendClientMessage(playerid, -1, "Вы успешно арендовали рабочий транспорт");

            GivePlayerMoneyEx(playerid, -3000);
        }
    }
    if(dialogid == 3324)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:{
                    new string[248], rating = GetPlayerData(playerid, P_TAXI_RATING);

                    format(
                        string, sizeof string, 
                        "Таксопарк: {FFFF00}%s\n{FFFFFF}Количество рейтинга: {FFFF00}%d\nКласс такси: %s", 
                        GetPlayerData(playerid, P_TAXI_COMPANY) > -1 ? taxi_name[GetPlayerData(playerid, P_TAXI_COMPANY)] : ("Нету"),
                        rating, class_name[GetPlayerClassTaxi(playerid, false)]
                    );

                    Dialog(playerid, -1, DIALOG_STYLE_LIST, "Личная карточка", string, "Выйти", "");
                }
                case 1:{
                    if(GetPlayerData(playerid, P_TAXI_COMPANY) == -1) return SendClientMessage(playerid, -1, "Сначала устройтесь в таксопарк");

                    if(GetPlayerData(playerid, P_TAXI_ORDER) != -1) {
                        SendClientMessage(playerid, -1, "Вы отказались от заказа");
                        TaxiSetRating(playerid, -1);
                        TaxiFinishOrder(playerid);
                    }

                    ShowPlayerOrderTaxi(playerid);
                }
            }
        }
    }
    #if defined taxi_OnDialogResponse
    return taxi_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse taxi_OnDialogResponse
#if defined taxi_OnDialogResponse
forward taxi_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
	#if defined taxi_OnVehicleDamageStatusUp
		return taxi_OnVehicleDamageStatusUp(vehicleid, playerid);
	#else
	    return 0;
	#endif
}
#if defined _ALS_OnVehicleDamageStatusUp
    #undef OnVehicleDamageStatusUpdate
#else
    #define _ALS_OnVehicleDamageStatusUp
#endif
#if defined taxi_OnVehicleDamageStatusUp
	forward taxi_OnVehicleDamageStatusUp(vehicleid, playerid);
#endif
#define	OnVehicleDamageStatusUpdate taxi_OnVehicleDamageStatusUp

public OnPlayerEnterCheckpoint(playerid)
{
    if(GetPlayerData(playerid, P_TAXI_ORDER) != -1){
        
        new vehicleid = GetPlayerVehicleID(playerid), id = GetPlayerData(playerid, P_TAXI_ORDER);

        SetVehicleSpeed(vehicleid, 1.0);
        if(vehicleid != GetPlayerData(playerid, P_TAXI_VEHICLE)) return SendClientMessage(playerid, -1, "Вы должны приехать на рабочем транспорте (или зарегистрировать личный как рабочий)");
        
        DisablePlayerCheckpoint(playerid);
        if(orders_taxi[id][TAXI_Status] == TAXI_ORDER_STAGE_2)
        {
            if(orders_taxi[id][TAXI_Type] != TAXI_CLASS_BAD_RATING) orders_taxi[id][TAXI_Actor][0] = CreateActor(orders_taxi[id][TAXI_Actor][1], orders_taxi[id][tFinish_Actor][0], orders_taxi[id][tFinish_Actor][1], orders_taxi[id][tFinish_Actor][2], orders_taxi[id][tFinish_Actor][3]);

            SendClientMessage(playerid, -1, "Вы успешно выполнили заказ");

            switch(GetPlayerData(playerid, P_TAXI_SECOND)){
                case 0..20:AddPlayerData(playerid, P_TAXI_ORDER_RATING, -, 1);
                case 21..40:AddPlayerData(playerid, P_TAXI_ORDER_RATING, -, 2);
            }

            new Float:heath;
            GetVehicleHealth(vehicleid, heath);

            switch(floatround(heath))
            {
                case 300..600:AddPlayerData(playerid, P_TAXI_ORDER_RATING, -, 3);
                case 601..800:AddPlayerData(playerid, P_TAXI_ORDER_RATING, -, 2);
                case 801..900:AddPlayerData(playerid, P_TAXI_ORDER_RATING, -, 1);
            }

            new distance = floatround(GetPlayerData(playerid, P_TAXI_MILEAGE)*10), salary = distance*GetPlayerData(playerid, P_TAXI_SALARY_100M);
            GivePlayerMoneyEx(playerid, salary);

            new string[184], take_prods = random(6)+2, biz_price = salary * 20 / 100, taxi = GetPlayerData(playerid, P_TAXI_COMPANY), businessid = taxi_company[taxi][1];

            if(GetBusinessData(businessid, B_PRODS) >= take_prods)
            {
                format(string, sizeof string, "UPDATE business SET products=%d, balance=%d WHERE id=%d", GetBusinessData(businessid, B_PRODS)-take_prods, GetBusinessData(businessid, B_BALANCE)+biz_price, GetBusinessData(businessid, B_SQL_ID));
                mysql_query(mysql, string, false);
            }

            if(!mysql_errno())
            {
                if(GetBusinessData(businessid, B_PRODS) >= take_prods)
                {
                    AddBusinessData(businessid, B_PRODS, -, take_prods);
                    AddBusinessData(businessid, B_BALANCE, +, biz_price);
                }

                mysql_format(mysql, string, sizeof string, "INSERT INTO business_profit (bid,uid,uip,time,money,view) VALUES (%d,%d,'%e',%d,%d,%d)", GetBusinessData(businessid, B_SQL_ID), GetPlayerAccountID(playerid), GetPlayerIpEx(playerid), gettime(), biz_price, IsBusinessOwned(businessid));
                mysql_query(mysql, string, false);

            }

            format(string, sizeof string, "Вы получили %d руб. и %d рейтинга", salary, GetPlayerData(playerid, P_TAXI_ORDER_RATING));
            SendClientMessage(playerid, -1, string);

            TaxiSetRating(playerid, GetPlayerData(playerid, P_TAXI_ORDER_RATING));

            if(vehicleid == GetPlayerOwnableCar(playerid) && GetPlayerClassTaxi(playerid) >= 3) {
                new bonus = salary * 5 / 100;

                format(string, sizeof string, "Вы получили %d руб. за работу на личном транспорте (+5%)", bonus);
                GivePlayerMoneyEx(playerid, bonus);
                SendClientMessage(playerid, -1, string);
            }

            TaxiFinishOrder(playerid);

        }
        else {

            if(orders_taxi[id][TAXI_Type] != TAXI_CLASS_BAD_RATING && IsValidActor(orders_taxi[id][TAXI_Actor])) DestroyActor(orders_taxi[id][TAXI_Actor]);
            
            SetPlayerCheckpoint(playerid, orders_taxi[id][tFinish_Vehicle][0], orders_taxi[id][tFinish_Vehicle][1], orders_taxi[id][tFinish_Vehicle][2], 5.0);


            if(orders_taxi[id][TAXI_Type] != TAXI_CLASS_BAD_RATING){
                SendClientMessage(playerid, -1, "Пассажир сел к вам в машину. Отправляйтесь на метку на карте");
            } else SendClientMessage(playerid, -1, "Вы получили продукты. Отправляйтесь на метку на карте");

            orders_taxi[id][TAXI_Status] = TAXI_ORDER_STAGE_2;
        }
    }
	#if defined taxi_OnPlayerEnterCheckpoint
		return taxi_OnPlayerEnterCheckpoint(playerid);
	#else
	    return 1;
	#endif
}
   #if defined _ALS_OnPlayerEnterCheckpoint
    #undef OnPlayerEnterCheckpoint
#else
    #define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint taxi_OnPlayerEnterCheckpoint
#if defined taxi_OnPlayerEnterCheckpoint
    forward taxi_OnPlayerEnterCheckpoint(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(GetPlayerData(playerid, P_TAXI_VEHICLE) != -1 && GetPlayerData(playerid, P_TAXI_VEHICLE) != GetPlayerOwnableCar(playerid)) 
    {
        if(IsValidVehicle(GetPlayerData(playerid, P_TAXI_VEHICLE))) DestroyVehicle(GetPlayerData(playerid, P_TAXI_VEHICLE));
    } 

    if(GetPlayerData(playerid, P_TAXI_ORDER) != -1){
        TaxiFinishOrder(playerid);
    }

    #if defined taxi_OnPlayerDisconnect
        return taxi_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect taxi_OnPlayerDisconnect
#if defined taxi_OnPlayerDisconnect
    forward taxi_OnPlayerDisconnect(playerid, reason);
#endif

stock ShowPlayerOrderTaxi(playerid){
    new list[68], string[sizeof list * 10 +48] = "Следующая страница\nПредыдущая страница\n", factor = GetPlayerClassTaxi(playerid);

    if(!factor) factor++;
    else if(factor > 3) factor = 3;

    for(new i, salary, salary_for_km,salary_for_100m, c = 2; i < 100;i ++, c++)
    {
        if(c == 12) break;
        if(orders_taxi[i][TAXI_Status] != TAXI_ORDER_NO_TAKE) continue;

        salary = floatround((orders_taxi[i][TAXI_DistancePoints]/100)*factor, floatround_ceil), salary_for_100m =(10*salary)*factor, salary_for_km = salary_for_100m*10;


        format(list, sizeof list, "%d. Заказ №%d\t %s\t %d за км\n", c-2+1, i+1, class_name[orders_taxi[i][TAXI_Type]], salary_for_km);
        strcat(string, list);
        SetPlayerListitemValue(playerid, c, i);
    }

    Dialog(playerid, 3322, DIALOG_STYLE_LIST, "Список заказов", string, "Взять", "Выйти");
    SetPVarInt(playerid, "list_dialog", 1);
    DeletePVar(playerid, "select_id");
}

stock DistanceOrderToOrder(Float: x, Float: y, Float: z, Float: fx, Float:fy, Float: fz) return floatround(floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2) + floatpower(fz - z, 2)));

stock TaxiPanel(playerid, show = -1){
    new string[24];

    if(show == 1){
        TextDrawShowForPlayer(playerid, taxi_panel_TD[0]);

        for(new i; i < 4; i ++) PlayerTextDrawShow(playerid, taxi_panel_PTD[playerid][i]);
    } else if(show == 0) {
        TextDrawHideForPlayer(playerid, taxi_panel_TD[0]);

        for(new i; i < 4; i ++) PlayerTextDrawHide(playerid, taxi_panel_PTD[playerid][i]);
        return 1;
    }

    new distancee = floatround(GetPlayerData(playerid, P_TAXI_MILEAGE)*10), salary = distancee*GetPlayerData(playerid, P_TAXI_SALARY_100M), 
    id = GetPlayerData(playerid, P_TAXI_ORDER), time = GetPlayerData(playerid, P_TAXI_SECOND); 

    if(id == -1) return TaxiFinishOrder(playerid);

    new Float:x, Float:y, Float:z;

    if(orders_taxi[GetPlayerData(playerid, P_TAXI_ORDER)][TAXI_Status] == TAXI_ORDER_STAGE_1) {
        x = orders_taxi[id][tStart_Vehicle][0],
        y = orders_taxi[id][tStart_Vehicle][1],
        z = orders_taxi[id][tStart_Vehicle][2];
    }
    else{
        x = orders_taxi[id][tFinish_Vehicle][0],
        y = orders_taxi[id][tFinish_Vehicle][1],
        z = orders_taxi[id][tFinish_Vehicle][2];
    }

    new distance = floatround(GetPlayerDistanceFromPoint(playerid, x, y, z));

    format(string, 24, "Pacc¦o¬®њe:_%d_Ї.", distance);
    PlayerTextDrawSetString(playerid, taxi_panel_PTD[playerid][0], string);

    format(string, 24, "C¦oњЇoc¦©:_%d_p.", salary);
    PlayerTextDrawSetString(playerid, taxi_panel_PTD[playerid][1], string);

    format(string, 24, "‹peЇ¬:_%0d:%02d",
    ConvertUnixTime(time, CONVERT_TIME_TO_MINUTES),
    ConvertUnixTime(time, CONVERT_TIME_TO_SECONDS));
    PlayerTextDrawSetString(playerid, taxi_panel_PTD[playerid][3], string);

    return 1;
}

public: TaxiTimer(playerid, order){

    if(GetPlayerData(playerid, P_TAXI_SECOND)){
        AddPlayerData(playerid, P_TAXI_SECOND, -, 1);

        
    } else {
        TaxiFinishOrder(playerid);

        SendClientMessage(playerid, -1, "Вы не успели закончить заказ до окончания времени на заказ");
        TaxiSetRating(playerid, -5);
    }

    TaxiPanel(playerid);

    return 1;
}

stock TaxiFinishOrder(playerid){
    if(GetPlayerData(playerid, P_TAXI_ORDER) == -1) return 1;

    new id = GetPlayerData(playerid, P_TAXI_ORDER);
    if(IsValidActor(orders_taxi[id][TAXI_Actor])) SetTimerEx("ActorExitVehicle", 2000, false, "i", id);
    
    DisablePlayerCheckpoint(playerid);

    orders_taxi[id][TAXI_Status] = TAXI_ORDER_NLOAD;

    SetPlayerData(playerid, P_TAXI_ORDER, -1);

    if(GetPlayerData(playerid, P_TAXI_TIMER) != -1) { KillTimer(GetPlayerData(playerid, P_TAXI_TIMER)); SetPlayerData(playerid, P_TAXI_TIMER, -1);}

    SetPlayerData(playerid, P_TAXI_SECOND, 0);
    SetPlayerData(playerid, P_TAXI_SALARY_100M, 0);

    TaxiPanel(playerid, 0);
    return 1;
}

stock TaxiStartOrder(playerid){
    
    new id = GetPlayerData(playerid, P_TAXI_ORDER);

    if(id==-1) return 1;
    SetPlayerData(playerid, P_TAXI_MILEAGE, 0.0);

    SetPlayerCheckpoint(playerid, orders_taxi[id][tStart_Vehicle][0], orders_taxi[id][tStart_Vehicle][1], orders_taxi[id][tStart_Vehicle][2], 5.0);

    new string[24];
    format(string, 24, "Kћacc:_%s", class_name[GetPlayerClassTaxi(playerid)]);
    PlayerTextDrawSetString(playerid, taxi_panel_PTD[playerid][2], string);

    TaxiPanel(playerid, 1);
    if(orders_taxi[id][TAXI_Type] != TAXI_CLASS_BAD_RATING){
        new skin = random(200)+10;
        orders_taxi[id][TAXI_Actor][1] = skin;
        orders_taxi[id][TAXI_Actor][0] = CreateActor(skin, orders_taxi[id][tStart_Actor][0], orders_taxi[id][tStart_Actor][1], orders_taxi[id][tStart_Actor][2], orders_taxi[id][tStart_Actor][3]);
    } 

    
    return 1;
}

stock TaxiSetRating(playerid, count){
    if(count <= 0 && GetPlayerData(playerid, P_TAXI_RATING) <= 0) return 1;

    AddPlayerData(playerid, P_TAXI_RATING, +, count);
    UpdatePlayerDatabaseInt(playerid, "taxi_rating", GetPlayerData(playerid, P_TAXI_RATING));

    if(count < 0){
        SendClientMessage(playerid, 0xE64646FF, "Ваш рейтинг таксиста понижен");
        
    }
    else SendClientMessage(playerid, 0x61D659FF, "Ваш рейтинг таксиста повышен");

    return 1;
}

public: ActorExitVehicle(id){
    if(IsValidActor(orders_taxi[id][TAXI_Actor][0])) DestroyActor(orders_taxi[id][TAXI_Actor][0]);
    orders_taxi[id][TAXI_Actor][0]= -1;
    orders_taxi[id][TAXI_Actor][1]= 0;

    return 1;
}

stock TextDrawTaxi()
{
    taxi_panel_TD[0] = TextDrawCreate(14.5833, 208.9259, "txd:br_taxistik"); // пусто
	TextDrawTextSize(taxi_panel_TD[0], 88.0000, 68.0000);
	TextDrawAlignment(taxi_panel_TD[0], 1);
	TextDrawColor(taxi_panel_TD[0], -1);
	TextDrawBackgroundColor(taxi_panel_TD[0], 255);
	TextDrawFont(taxi_panel_TD[0], 4);
	TextDrawSetProportional(taxi_panel_TD[0], 0);
	TextDrawSetShadow(taxi_panel_TD[0], 0);
}

stock PlayerTextDrawTaxi(playerid){

    taxi_panel_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 18.7500, 211.7777, "1234_Ї."); // пусто
    PlayerTextDrawLetterSize(playerid, taxi_panel_PTD[playerid][0], 0.2291, 1.4600);
    PlayerTextDrawAlignment(playerid, taxi_panel_PTD[playerid][0], 1);
    PlayerTextDrawColor(playerid, taxi_panel_PTD[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, taxi_panel_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, taxi_panel_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, taxi_panel_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, taxi_panel_PTD[playerid][0], 0);

    taxi_panel_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 18.7500, 223.7037, "123345_p."); // пусто
    PlayerTextDrawLetterSize(playerid, taxi_panel_PTD[playerid][1], 0.2291, 1.4600);
    PlayerTextDrawAlignment(playerid, taxi_panel_PTD[playerid][1], 1);
    PlayerTextDrawColor(playerid, taxi_panel_PTD[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, taxi_panel_PTD[playerid][1], 255);
    PlayerTextDrawFont(playerid, taxi_panel_PTD[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, taxi_panel_PTD[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, taxi_panel_PTD[playerid][1], 0);

    taxi_panel_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 19.1666, 235.1111, "KoЇop¦"); // пусто
    PlayerTextDrawLetterSize(playerid, taxi_panel_PTD[playerid][2], 0.2291, 1.4600);
    PlayerTextDrawAlignment(playerid, taxi_panel_PTD[playerid][2], 1);
    PlayerTextDrawColor(playerid, taxi_panel_PTD[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, taxi_panel_PTD[playerid][2], 255);
    PlayerTextDrawFont(playerid, taxi_panel_PTD[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, taxi_panel_PTD[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, taxi_panel_PTD[playerid][2], 0);

    taxi_panel_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 34.5833, 260.5184, "04:23"); // пусто
    PlayerTextDrawLetterSize(playerid, taxi_panel_PTD[playerid][3], 0.2291, 1.4600);
    PlayerTextDrawAlignment(playerid, taxi_panel_PTD[playerid][3], 1);
    PlayerTextDrawColor(playerid, taxi_panel_PTD[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, taxi_panel_PTD[playerid][3], 255);
    PlayerTextDrawFont(playerid, taxi_panel_PTD[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, taxi_panel_PTD[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, taxi_panel_PTD[playerid][3], 0);
}

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_TAXI_DRIVER && GetPlayerData(playerid, P_TAXI_VEHICLE) != vehicleid)
    {
        ClearAnimations(playerid);
        return SendClientMessage(playerid, -1, "Это рабочий транспорт таксиста");
    }
    #if defined taxi_OnPlayerEnterVehicle
        return taxi_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerEnterVehicle
    #undef OnPlayerEnterVehicle
#else
    #define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle taxi_OnPlayerEnterVehicle
#if defined taxi_OnPlayerEnterVehicle
    forward taxi_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif



stock GetPlayerClassTaxi(playerid, bool:null = false)
{
    new class = floatround(GetPlayerData(playerid, P_TAXI_RATING)/100, floatround_floor);
    if(class > 3) class = 3;

    if(null) class--;

    if(class <= -1) class = 0;
    
    return class;
}

cmd:taxapark(playerid)
{
    Dialog(
        playerid, 3324, DIALOG_STYLE_LIST,
        "Меню",
        "1. Личная карточка\n2. Взять заказ","Далее","Выйти"
    );
}

public:UpdateNewOrderTaxi()
{
    new count_order[4][40] = {-1, ...}; //+-
    
    for(new i, c; i < 4;i++, c = 0)
      for(new e; e < 100;e++) if(orders_taxi[e][TAXI_Type] == i && orders_taxi[e][TAXI_Status] == TAXI_ORDER_NLOAD) { count_order[i][c] = i; c++; } //govnocode

    new c_1, ye;

    for(new i; i < 5;i++) if(count_order[0][i] != -1) { c_1++; }
    
    if(c_1 < 5)
    {
        for(new i; i < 100;i ++)
        {
            if(orders_taxi[i][TAXI_Type] != TAXI_CLASS_BAD_RATING) continue;

            orders_taxi[i][TAXI_Status] = TAXI_ORDER_NO_TAKE;
            ye++;
            break;
        }
    }

    new max_order[3];

    for(new i = 1; i < 4;i++) for(new e; e < 40;e++) { if(count_order[i][e] == -1) { max_order[i-1] = i; break; }}

    for(new i= 1, r, c;i < 4;i++){

        if(max_order[i-1] < 20) continue;

        c = max_order[i-1];
        r = random(c); 

        for(new e; e < c; e++){
            if(e != r) continue;
            
            orders_taxi[count_order[i][e]][TAXI_Status] = TAXI_ORDER_NO_TAKE;
            ye++;
            break;
        }
    }


    if(ye){
        foreach(new i : Player){
            if(GetPlayerData(i, P_TAXI_COMPANY) == -1) continue;

            SendClientMessage(i, -1, "{FFFF00}Диспетчер:{FFFFFF} В список заказов добавлен новые заказы (/taxapark)");
        }
    }
}