#include "../gamemodes/sile/TuningCostCalculation.inc"

new g_TuningGosCost[MAX_PLAYERS];

static const gVehicleComponentOffset[538] =
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

static const gVehicleComponentCount[538] =
{
    0, 9, 35, 0, 0, 30, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 15, 24, 15, 0, 0, 0, 0, 17, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 13, 0, 1, 0, 0, 0, 0, 0, 0, 9, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 17, 0, 0, 0, 0,
    0, 0, 0, 10, 15, 0, 0, 0, 0, 0, 0, 0, 27, 0, 8, 0,
    19, 31, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 7, 0, 0, 0, 1, 0, 0, 9, 0, 0, 0, 10, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    18, 0, 16, 0, 0, 0, 35, 11, 0, 6, 0, 0, 0, 0, 0, 11,
    0, 0, 0, 0, 0, 0, 7, 12, 60, 0, 0, 0, 15, 0, 0, 13,
    0, 26, 0, 11, 0, 0, 0, 0, 16, 0, 0, 0, 0, 0, 14, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 18, 0, 9, 0, 7, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 9, 19, 0, 1, 6, 0, 0, 0, 24, 22,
    17, 0, 0, 3, 0, 0, 10, 8, 0, 0, 0, 0, 0, 17, 15, 0,
    0, 0, 0, 24, 14, 13, 0, 0, 0, 0, 0, 0, 0, 0, 6, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
    7, 0, 0, 0, 0, 0, 0, 0, 0, 14, 0, 0, 0, 0, 0, 0,
    7, 6, 7, 0, 0, 0, 3, 0, 0, 0, 0, 10, 5, 0, 0, 0,
    0, 0, 0, 0, 0, 0, 10, 0, 21, 12, 14, 0, 0, 7, 0, 5,
    7, 14, 12, 9, 8, 0, 8, 0, 0, 0, 0, 0, 6, 6, 10, 6,
    7, 0, 14, 0, 0, 0, 8, 0, 2, 0, 6, 1, 3, 0, 0, 0,
    0, 0, 0, 1, 0, 0, 0, 0, 0, 14, 3, 1, 6, 0, 0, 4,
    6, 6, 3, 5, 8, 10, 5, 0, 5, 3, 9, 1, 8, 17, 8, 4,
    4, 8, 6, 3, 0, 17, 9, 9, 13, 12, 0, 11, 17, 7, 7, 10,
    12, 0, 7, 7, 7, 11, 8, 7, 3, 10, 7, 4, 0, 0, 0, 0,
    0, 11, 11, 0, 6, 3, 6, 10, 5, 7, 9, 7, 8, 5, 9, 24,
    12, 8, 14, 6, 13, 6, 2, 12, 8, 12, 0, 9, 8, 9, 7, 11,
    13, 10, 10, 12, 9, 12, 5, 8, 4, 3, 0, 0, 0, 0, 10, 8,
    8, 8, 9, 11, 9, 7, 6, 2, 4, 4, 5, 5, 8, 7, 7, 7,
    7, 7, 9, 12, 9, 8, 8, 9, 9, 9, 7, 8, 7, 7, 6, 9,
    6, 5, 4, 11, 4, 10, 9, 16, 11, 6, 8, 13, 9, 8, 11, 8,
    11, 12, 9, 11, 8, 6, 2, 13, 7, 1
};

static const gVehicleComponentList[2252] =
{
    464, 465, 466, 467, 468, 469, 470, 471, 472, 584, 585, 586, 587, 588, 589, 590,
    591, 592, 593, 594, 595, 596, 597, 598, 599, 600, 601, 602, 603, 604, 605, 606,
    607, 608, 609, 610, 611, 612, 1549, 1550, 1551, 1552, 1553, 1554, 613, 614, 615, 616,
    617, 618, 619, 620, 621, 622, 623, 624, 625, 626, 627, 628, 629, 630, 631, 632,
    633, 634, 635, 636, 637, 638, 639, 640, 641, 642, 774, 775, 776, 777, 778, 779,
    780, 781, 782, 783, 784, 785, 786, 787, 788, 366, 367, 368, 369, 370, 371, 372,
    373, 374, 375, 376, 377, 378, 379, 380, 381, 382, 383, 384, 385, 386, 387, 388,
    389, 759, 760, 761, 762, 763, 764, 765, 766, 767, 768, 769, 770, 771, 772, 773,
    710, 711, 712, 713, 714, 715, 716, 717, 718, 719, 720, 721, 722, 723, 724, 725,
    726, 1211, 1212, 1213, 1214, 1215, 1216, 1217, 1218, 1219, 1220, 1221, 1222, 1223, 1729, 1593,
    1594, 1595, 1596, 1597, 1598, 1599, 1600, 1601, 643, 644, 645, 646, 647, 648, 649, 650,
    651, 652, 1441, 1442, 1443, 1444, 1445, 1446, 1447, 454, 455, 456, 457, 458, 459, 460,
    461, 462, 463, 789, 790, 791, 792, 793, 794, 795, 796, 797, 798, 799, 800, 801,
    802, 803, 35, 106, 107, 108, 109, 110, 111, 113, 121, 122, 123, 124, 125, 126,
    325, 326, 327, 328, 329, 330, 331, 332, 333, 334, 335, 336, 337, 485, 486, 487,
    488, 489, 490, 491, 492, 473, 474, 475, 476, 477, 478, 479, 480, 481, 482, 483,
    484, 1608, 1609, 1610, 1611, 1612, 1613, 1614, 1562, 1563, 1564, 1565, 1566, 1567, 1568, 1569,
    1570, 1571, 1572, 1573, 1574, 1575, 1576, 1577, 1578, 1579, 1580, 1581, 1582, 1583, 1584, 1585,
    1586, 1587, 1588, 1589, 1590, 1591, 1592, 571, 572, 573, 574, 575, 576, 577, 845, 1615,
    1616, 1617, 1618, 1619, 1620, 1621, 1622, 1623, 409, 410, 411, 412, 413, 414, 415, 416,
    417, 418, 430, 431, 432, 433, 434, 435, 436, 437, 438, 439, 440, 1134, 1135, 1136,
    1137, 1138, 1139, 1140, 669, 670, 671, 672, 673, 674, 675, 676, 677, 678, 1602, 1603,
    1604, 1605, 1606, 1607, 114, 115, 116, 117, 127, 128, 129, 338, 339, 340, 341, 342,
    343, 344, 345, 346, 347, 348, 349, 350, 351, 352, 353, 354, 355, 356, 357, 358,
    359, 360, 361, 362, 363, 364, 365, 419, 420, 421, 422, 423, 424, 425, 426, 427,
    428, 429, 578, 579, 580, 581, 582, 583, 663, 664, 665, 666, 667, 668, 2403, 2404,
    2405, 2406, 2407, 1555, 1556, 1557, 1558, 1559, 1560, 1561, 529, 530, 531, 532, 533, 534,
    535, 536, 537, 538, 539, 540, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12,
    13, 14, 15, 16, 17, 19, 20, 21, 22, 24, 25, 26, 27, 28, 29, 30,
    31, 32, 33, 34, 93, 94, 95, 96, 97, 98, 99, 300, 301, 302, 303, 304,
    305, 306, 307, 308, 309, 310, 311, 312, 313, 314, 1851, 1852, 1853, 1854, 1855, 1856,
    1928, 1929, 679, 680, 681, 682, 683, 1448, 1449, 1450, 1451, 1452, 1453, 1454, 1455, 1456,
    1457, 441, 442, 443, 444, 445, 446, 447, 448, 449, 450, 451, 452, 453, 504, 505,
    506, 507, 508, 509, 510, 511, 512, 513, 514, 515, 516, 517, 518, 519, 1045, 1046,
    1047, 1048, 1049, 1050, 1051, 1052, 1053, 1054, 493, 494, 495, 496, 497, 498, 499, 500,
    501, 502, 503, 953, 954, 955, 956, 957, 958, 959, 960, 961, 962, 963, 964, 965,
    966, 967, 968, 856, 857, 858, 859, 860, 1514, 1515, 1516, 1517, 1518, 1519, 1520, 1521,
    1522, 653, 654, 655, 656, 657, 658, 659, 660, 661, 662, 1433, 1434, 1435, 1436, 1437,
    1438, 1439, 1440, 1301, 1302, 1303, 1304, 1305, 1306, 1307, 1308, 1309, 1737, 1738, 1739, 1740,
    1741, 1742, 1743, 520, 521, 522, 523, 524, 525, 526, 527, 528, 390, 391, 392, 393,
    394, 395, 396, 397, 398, 399, 400, 401, 402, 403, 404, 405, 406, 407, 408, 1986,
    562, 563, 564, 565, 566, 567, 541, 542, 543, 544, 545, 546, 547, 548, 549, 550,
    551, 552, 553, 554, 555, 556, 557, 558, 559, 560, 561, 1024, 1025, 1026, 18, 23,
    100, 101, 102, 103, 104, 105, 112, 118, 119, 120, 315, 316, 317, 318, 319, 320,
    321, 322, 323, 324, 828, 829, 830, 831, 832, 833, 834, 835, 836, 837, 838, 839,
    840, 841, 842, 843, 844, 568, 569, 570, 846, 847, 848, 849, 850, 851, 852, 853,
    854, 855, 1530, 1531, 1532, 1533, 1534, 1535, 1536, 1537, 727, 728, 729, 730, 731, 732,
    733, 734, 735, 736, 737, 738, 739, 740, 741, 742, 743, 744, 745, 746, 747, 748,
    749, 750, 751, 752, 753, 754, 755, 756, 757, 758, 804, 805, 806, 807, 808, 809,
    810, 811, 812, 813, 814, 815, 816, 817, 818, 819, 820, 821, 822, 823, 824, 825,
    826, 827, 299, 684, 685, 686, 687, 688, 689, 690, 691, 692, 693, 694, 695, 696,
    697, 698, 699, 700, 701, 702, 703, 704, 705, 706, 707, 708, 709, 2024, 2025, 2026,
    2027, 2028, 2029, 2501, 2502, 2503, 2504, 2505, 2506, 2507, 1090, 1091, 1092, 1093, 1094, 1095,
    1096, 1097, 1098, 1099, 1100, 1101, 1102, 1103, 861, 862, 863, 864, 865, 866, 867, 868,
    869, 870, 871, 872, 873, 874, 875, 876, 877, 878, 879, 880, 881, 882, 883, 884,
    885, 886, 887, 888, 889, 890, 891, 892, 893, 894, 895, 896, 897, 898, 1624, 1625,
    1626, 1627, 1628, 1629, 1630, 1631, 1632, 1633, 899, 900, 901, 902, 903, 904, 905, 906,
    907, 908, 909, 910, 911, 912, 913, 914, 915, 916, 917, 918, 919, 920, 921, 922,
    923, 924, 925, 926, 927, 928, 929, 930, 931, 932, 933, 934, 935, 936, 937, 938,
    939, 940, 941, 942, 943, 944, 945, 946, 947, 948, 949, 950, 951, 952, 969, 970,
    971, 972, 973, 974, 975, 976, 977, 978, 979, 980, 981, 982, 983, 984, 985, 986,
    987, 988, 989, 990, 991, 992, 993, 994, 995, 996, 997, 998, 999, 1000, 1001, 1002,
    1003, 1004, 1005, 1006, 1007, 1008, 1009, 1010, 1011, 1012, 1013, 1014, 1015, 1016, 1017, 1018,
    1019, 1020, 1021, 1022, 1023, 1027, 1028, 1029, 1030, 1031, 1032, 1033, 1034, 1055, 1056, 1057,
    1058, 1059, 1060, 1061, 1062, 1063, 1064, 1065, 1066, 1067, 1068, 1069, 1070, 1071, 1072, 1073,
    1074, 1060, 1076, 1077, 1078, 1079, 1080, 1081, 1082, 1083, 1084, 1085, 1086, 1087, 1088, 1089,
    1189, 1190, 1191, 1192, 1193, 1194, 1195, 1196, 1197, 2164, 2165, 2166, 2167, 2168, 1198, 1199,
    1200, 1201, 1202, 1203, 1204, 1205, 1104, 1105, 1106, 1107, 1108, 1109, 1110, 1111, 1112, 1113,
    1114, 1115, 2007, 1116, 1117, 1118, 1119, 1120, 1121, 1122, 1123, 1124, 1125, 1126, 1127, 1128,
    1129, 1130, 1131, 1132, 1133, 1159, 1160, 1161, 1162, 1163, 1164, 1165, 1166, 1167, 1168, 1169,
    1170, 1171, 1172, 1173, 1174, 1175, 1176, 1177, 1178, 1179, 1180, 1181, 1182, 1183, 1184, 1185,
    1186, 1187, 1188, 1141, 1142, 1143, 1144, 1145, 1146, 1147, 1148, 1149, 1150, 1151, 1152, 1153,
    1154, 1155, 1156, 1157, 1158, 1206, 1207, 1208, 1209, 1210, 1224, 1225, 1226, 1227, 1228, 1231,
    1232, 1233, 1234, 1235, 1236, 1237, 1238, 1239, 1240, 1241, 1242, 1229, 1243, 1244, 1245, 1246,
    1247, 1248, 1249, 1250, 1251, 1252, 1253, 1254, 1255, 1256, 1257, 1258, 1259, 1260, 1261, 1262,
    1263, 1264, 1265, 1266, 1267, 1293, 1294, 1295, 1296, 1297, 1298, 1299, 1300, 1269, 1270, 1271,
    1272, 1273, 1274, 1275, 1276, 1277, 1278, 1279, 1280, 1281, 1282, 1283, 1284, 1285, 1286, 1287,
    1288, 1289, 1290, 1, 1291, 1292, 1310, 1311, 1312, 1313, 1314, 1315, 1316, 1317, 1318, 1319,
    1320, 1321, 1322, 1323, 1324, 1325, 1326, 1424, 1425, 1426, 1427, 1428, 1429, 1430, 1431, 1432,
    1415, 1416, 1417, 1418, 1419, 1420, 1421, 1422, 1423, 1327, 1328, 1329, 1330, 1331, 1332, 1333,
    1334, 1335, 1336, 1337, 1338, 1339, 1340, 1341, 1342, 1343, 1344, 1345, 1346, 1347, 1348, 1349,
    1350, 1351, 1352, 1353, 1354, 1355, 1356, 1357, 1358, 1359, 1360, 1361, 1362, 1363, 1364, 1365,
    1366, 1367, 1368, 1369, 1370, 1371, 1372, 1373, 1374, 1375, 1376, 1377, 1378, 1379, 0, 2,
    1380, 1381, 1382, 1383, 1384, 1385, 1386, 1387, 1388, 1389, 1390, 1391, 1392, 1393, 1394, 1395,
    1396, 1397, 1398, 1399, 1400, 1401, 1402, 1403, 1405, 1406, 1407, 1408, 1409, 1410, 1411, 1412,
    1413, 1414, 1504, 1505, 1506, 1507, 1508, 1509, 1510, 1523, 1524, 1525, 1526, 1527, 1528, 1529,
    1538, 1539, 1540, 1541, 1542, 1543, 1544, 1459, 1460, 1461, 1462, 1463, 1464, 1465, 1466, 1467,
    1468, 1469, 1470, 1471, 1472, 1473, 1474, 1475, 1476, 1477, 1478, 1479, 1480, 1481, 1482, 1483,
    1486, 1511, 1512, 1513, 1487, 1488, 1489, 1490, 1491, 1492, 1493, 1494, 1495, 1496, 1497, 1498,
    1499, 1500, 1501, 1502, 1503, 1545, 1546, 1547, 1548, 1657, 1658, 1659, 1660, 1661, 1922, 1923,
    1924, 1925, 1926, 1927, 1662, 1663, 1664, 1665, 1666, 1667, 1668, 1669, 1670, 1671, 1672, 1673,
    1674, 1675, 1676, 1677, 1678, 1679, 1680, 1681, 1731, 1732, 1733, 1734, 1735, 1736, 1683, 1684,
    1685, 1686, 1687, 1688, 1689, 1690, 1691, 1692, 1753, 1754, 1755, 1756, 1757, 1693, 1694, 1695,
    1696, 1697, 1698, 1699, 1700, 1701, 1702, 1703, 1704, 1705, 1706, 1707, 1708, 1709, 1710, 1711,
    1712, 1713, 1714, 1715, 1744, 1745, 1746, 1747, 1748, 1749, 1750, 1751, 1716, 1717, 1718, 1719,
    1720, 1721, 1722, 1723, 1724, 1725, 1726, 1727, 1728, 1730, 1634, 1635, 1636, 1637, 1638, 1639,
    1640, 1641, 1642, 1643, 1644, 1645, 1646, 1647, 1648, 1649, 1650, 1651, 1652, 1653, 1654, 1655,
    1656, 1682, 1758, 1759, 1760, 1761, 1762, 1763, 1764, 1765, 1766, 1767, 1768, 1769, 1770, 1771,
    1772, 1773, 1774, 1775, 1776, 1777, 1778, 1779, 1780, 1781, 1782, 1783, 1784, 1785, 1786, 1787,
    1788, 1789, 1790, 1791, 1845, 1846, 1847, 1848, 1849, 1850, 1812, 1813, 1814, 1815, 1816, 1817,
    1818, 1819, 1820, 1821, 1822, 1823, 1824, 1792, 1793, 1794, 1795, 1796, 1797, 1810, 1811, 1798,
    1799, 1800, 1801, 1802, 1803, 1804, 1805, 1806, 1807, 1808, 1809, 1837, 1838, 1839, 1840, 1841,
    1842, 1843, 1844, 1825, 1826, 1827, 1828, 1829, 1830, 1831, 1832, 1833, 1834, 1835, 1836, 1857,
    1858, 1859, 1860, 1861, 1862, 1863, 1864, 1865, 1888, 1889, 1890, 1891, 1892, 1893, 1894, 1895,
    1896, 1897, 1898, 1899, 1900, 1901, 1902, 1903, 1904, 1905, 1906, 1907, 1908, 1909, 1910, 1911,
    1912, 1913, 1914, 1915, 1916, 1917, 1918, 1919, 1920, 1921, 1974, 1951, 1952, 1953, 1954, 1955,
    1956, 1957, 1958, 1959, 1960, 1961, 1962, 1963, 1964, 1965, 1966, 1967, 1968, 1969, 1970, 1971,
    1972, 1973, 1866, 1867, 1868, 1869, 1870, 1871, 1872, 1873, 1874, 1875, 1939, 1940, 1941, 1942,
    1943, 1944, 1945, 1946, 1947, 1948, 1949, 1950, 1930, 1931, 1932, 1933, 1934, 1935, 1936, 1937,
    1938, 1876, 1877, 1878, 1879, 1880, 1881, 1882, 1883, 1884, 1885, 1886, 1887, 1987, 1988, 1989,
    1990, 1991, 1975, 1976, 1977, 1978, 1979, 1980, 1981, 1982, 1992, 1993, 1994, 1995, 1983, 1984,
    1985, 2030, 2031, 2032, 2033, 2034, 2035, 2036, 2037, 2038, 2039, 2016, 2017, 2018, 2019, 2020,
    2021, 2022, 2023, 2040, 2041, 2042, 2043, 2044, 2045, 2046, 2078, 2008, 2009, 2010, 2011, 2012,
    2013, 2014, 2015, 2047, 2048, 2049, 2050, 2051, 2052, 2053, 2054, 2055, 1996, 1997, 1998, 1999,
    2000, 2001, 2002, 2003, 2004, 2005, 2006, 2056, 2057, 2058, 2059, 2060, 2061, 2062, 2063, 2064,
    2071, 2072, 2073, 2074, 2060, 2076, 2077, 2065, 2066, 2067, 2068, 2069, 2070, 2106, 2107, 2102,
    2103, 2104, 2105, 2108, 2109, 2110, 2111, 2117, 2118, 2119, 2120, 2121, 2112, 2113, 2114, 2115,
    2116, 2169, 2170, 2171, 2172, 2173, 2174, 2175, 2176, 2187, 2188, 2189, 2190, 2191, 2192, 2193,
    2141, 2142, 2143, 2144, 2145, 2146, 2147, 2079, 2080, 2081, 2082, 2083, 2084, 2085, 2148, 2149,
    2150, 2151, 2152, 2153, 2154, 2122, 2123, 2124, 2125, 2126, 2127, 2128, 2093, 2094, 2095, 2096,
    2097, 2098, 2099, 2100, 2101, 2129, 2130, 2131, 2132, 2133, 2134, 2135, 2136, 2137, 2138, 2139,
    2140, 2155, 2156, 2157, 2158, 2159, 2160, 2161, 2162, 2163, 2194, 2195, 2196, 2197, 2198, 2199,
    2200, 2201, 2086, 2087, 2088, 2089, 2090, 2091, 2092, 2177, 2178, 2179, 2180, 2181, 2182, 2183,
    2184, 2185, 2186, 2224, 2225, 2226, 2227, 2228, 2229, 2230, 2231, 2232, 2233, 2234, 2235, 2236,
    2237, 2238, 2239, 2240, 2336, 2274, 2275, 2276, 2277, 2279, 2280, 2281, 2257, 2258, 2259, 2260,
    2261, 2262, 2263, 2264, 2211, 2212, 2213, 2214, 2215, 2216, 2217, 2329, 2330, 2331, 2332, 2333,
    2334, 2335, 2218, 2219, 2220, 2221, 2222, 2223, 2265, 2266, 2267, 2268, 2269, 2270, 2271, 2272,
    2273, 2241, 2242, 2243, 2244, 2245, 2246, 2282, 2283, 2284, 2285, 2286, 2287, 2288, 2289, 2290,
    2291, 2292, 2293, 2294, 2295, 2296, 2297, 2298, 2299, 2300, 2301, 2309, 2310, 2311, 2312, 2247,
    2248, 2249, 2250, 2251, 2252, 2253, 2254, 2255, 2256, 2202, 2203, 2204, 2205, 2206, 2207, 2208,
    2209, 2210, 2313, 2314, 2315, 2316, 2317, 2318, 2319, 2320, 2321, 2322, 2323, 2324, 2325, 2326,
    2327, 2328, 2345, 2346, 2347, 2348, 2349, 2350, 2351, 2352, 2353, 2354, 2355, 2356, 2357, 2358,
    2359, 2360, 2361, 2337, 2338, 2339, 2340, 2341, 2342, 2343, 2344, 2362, 2363, 2364, 2365, 2366,
    2367, 2368, 2369, 2370, 2371, 2372, 2373, 2374, 2375, 2376, 2377, 2378, 2379, 2380, 2381, 2382,
    2383, 2384, 2385, 2386, 2387, 2388, 2389, 2390, 2391, 2392, 2393, 2394, 2395, 2396, 2397, 2398,
    2399, 2400, 2401, 2402, 2414, 2415, 2416, 2417, 2418, 2419, 2420, 2421, 2422, 2423, 2424, 2425,
    2426, 2427, 2428, 2429, 2430, 2431, 2432, 2468, 2469, 2470, 2471, 2472, 2473, 2474, 2475, 2476,
    2477, 2478, 2479, 2433, 2434, 2435, 2436, 2437, 2438, 2439, 2440, 2441, 2442, 2443, 2444, 2445,
    2446, 2447, 2448, 2449, 2450, 2451, 2452, 2453, 2454, 2455, 2456, 2457, 2458, 2459, 2500, 2460,
    2461, 2462, 2463, 2464, 2465, 2466, 2467, 2480, 2481, 2482, 2483, 2484, 2485, 2486, 2487, 2488,
    2489, 2490, 2491, 2492, 2493, 2494, 2495, 2496, 2497, 2498, 2499, 2413
};


stock GetVehicleComponents(model, &start, &count)
{
    if(model < 0 || model >= sizeof(gVehicleComponentOffset))
        return 0;

    start = gVehicleComponentOffset[model];
    count = gVehicleComponentCount[model];

    if(start == -1 || count == 0)
        return 0;

    return 1;
}

stock bool:GetVinylNameById(vinylId, outName[], outLen)
{
    if (outLen <= 0) return false;
    outName[0] = '\0';

    switch (vinylId)
    {
        case 0:  return format(outName, outLen, "remapbody8"), true;
        case 1:  return format(outName, outLen, "remapbody5"), true;
        case 2:  return format(outName, outLen, "remapbody32"), true;
        case 3:  return format(outName, outLen, "remapbody40"), true;
        case 4:  return format(outName, outLen, "remapbody21"), true;
        case 5:  return format(outName, outLen, "remapbody29"), true;
        case 6:  return format(outName, outLen, "remapbody41"), true;
        case 7:  return format(outName, outLen, "remapbody6"), true;
        case 8:  return format(outName, outLen, "remapbody31"), true;
        case 9:  return format(outName, outLen, "remapbody19"), true;
        case 10: return format(outName, outLen, "remapbody28"), true;
        case 11: return format(outName, outLen, "remapbody30"), true;
        case 12: return format(outName, outLen, "remapbody11"), true;
        case 13: return format(outName, outLen, "remapbody12"), true;
        case 14: return format(outName, outLen, "remapbody15"), true;
        case 15: return format(outName, outLen, "remapbody26"), true;
        case 16: return format(outName, outLen, "remapbody16"), true;
        case 17: return format(outName, outLen, "remapbody13"), true;
        case 18: return format(outName, outLen, "remapbody18"), true;
        case 19: return format(outName, outLen, "remapbody35"), true;
        case 20: return format(outName, outLen, "remapbody10"), true;
        case 21: return format(outName, outLen, "remapbody17"), true;
        case 22: return format(outName, outLen, "remapbody38"), true;
        case 23: return format(outName, outLen, "remapbody2"), true;
        case 24: return format(outName, outLen, "remapbody23"), true;
        case 25: return format(outName, outLen, "remapbody36"), true;
        case 26: return format(outName, outLen, "remapbody4"), true;
        case 27: return format(outName, outLen, "remapbody14"), true;
        case 28: return format(outName, outLen, "remapbody37"), true;
        case 29: return format(outName, outLen, "remapbody20"), true;
        case 30: return format(outName, outLen, "remapbody7"), true;
        case 31: return format(outName, outLen, "remapbody25"), true;
        case 32: return format(outName, outLen, "remapbody39"), true;
        case 33: return format(outName, outLen, "remapbody1"), true;
        case 34: return format(outName, outLen, "remapbody33"), true;
        case 35: return format(outName, outLen, "remapbody9"), true;
        case 36: return format(outName, outLen, "remapbody22"), true;
        case 37: return format(outName, outLen, "remapbody24"), true;
        case 38: return format(outName, outLen, "remapbody34"), true;
        case 39: return format(outName, outLen, "remapbody42"), true;
        case 40: return format(outName, outLen, "remapbody47"), true;
        case 41: return format(outName, outLen, "remapbody48"), true;
        case 42: return format(outName, outLen, "remapbody43"), true;
        case 43: return format(outName, outLen, "remapbody44"), true;
        case 44: return format(outName, outLen, "remapbody49"), true;
        case 45: return format(outName, outLen, "remapbody51"), true;
        case 46: return format(outName, outLen, "remapbody45"), true;
        case 47: return format(outName, outLen, "remapbody46"), true;
		case 48: return format(outName, outLen, "remaphbody1"), true;
        case 49: return format(outName, outLen, "remaphbody2"), true;
        case 50: return format(outName, outLen, "remaphbody3"), true;
        case 51: return format(outName, outLen, "remaphbody4"), true;
        case 52: return format(outName, outLen, "remaphbody5"), true;
        case 53: return format(outName, outLen, "remaphbody6"), true;
        case 54: return format(outName, outLen, "remaphbody7"), true;
        case 55: return format(outName, outLen, "remaphbody8"), true;
        case 56: return format(outName, outLen, "remaphbody9"), true;
        case 57: return format(outName, outLen, "remaphbody10"), true;
        case 58: return format(outName, outLen, "remaphbody11"), true;

        case 59: return format(outName, outLen, "remapnbody1"), true;
        case 60: return format(outName, outLen, "remapnbody2"), true;
        case 61: return format(outName, outLen, "remapnbody3"), true;
        case 62: return format(outName, outLen, "remapnbody4"), true;
        case 63: return format(outName, outLen, "remapnbody5"), true;
        case 64: return format(outName, outLen, "remapnbody6"), true;
        case 65: return format(outName, outLen, "remapnbody7"), true;
        case 66: return format(outName, outLen, "remapnbody8"), true;
        case 67: return format(outName, outLen, "remapnbody9"), true;
        case 68: return format(outName, outLen, "remapnbody10"), true;
        case 69: return format(outName, outLen, "remapnbody11"), true;
        case 70: return format(outName, outLen, "remapnbody12"), true;
        case 71: return format(outName, outLen, "remapnbody13"), true;
        case 72: return format(outName, outLen, "remapnbody14"), true;
        case 73: return format(outName, outLen, "remapnbody15"), true;
        case 74: return format(outName, outLen, "remapnbody16"), true;
        case 75: return format(outName, outLen, "remapnbody17"), true;

        case 76: return format(outName, outLen, "remapmbody1"), true;
        case 77: return format(outName, outLen, "remapmbody2"), true;
        case 78: return format(outName, outLen, "remapmbody3"), true;
        case 79: return format(outName, outLen, "remapmbody4"), true;
        case 80: return format(outName, outLen, "remapmbody5"), true;
        case 81: return format(outName, outLen, "remapmbody6"), true;
        case 82: return format(outName, outLen, "remapmbody7"), true;
        case 83: return format(outName, outLen, "remapmbody8"), true;
        case 84: return format(outName, outLen, "remapmbody9"), true;
        case 85: return format(outName, outLen, "remapmbody10"), true;
        case 86: return format(outName, outLen, "remapmbody11"), true;
        case 87: return format(outName, outLen, "remapmbody12"), true;
        case 88: return format(outName, outLen, "remapmbody13"), true;
        case 89: return format(outName, outLen, "remapmbody14"), true;
        case 90: return format(outName, outLen, "remapmbody15"), true;
        case 91: return format(outName, outLen, "remapmbody16"), true;
        case 92: return format(outName, outLen, "remapmbody17"), true;

        // Обрати внимание: в JSON есть разрыв (после 92 сразу 110)
        case 110: return format(outName, outLen, "remapnbody18"), true;
        case 111: return format(outName, outLen, "remapnbody19"), true;
        case 112: return format(outName, outLen, "remapnbody20"), true;
        case 113: return format(outName, outLen, "remapnbody21"), true;
        case 114: return format(outName, outLen, "remapnbody22"), true;
        case 115: return format(outName, outLen, "remapnbody23"), true;
        case 116: return format(outName, outLen, "remapnbody24"), true;
        case 117: return format(outName, outLen, "remapnbody25"), true;
        case 118: return format(outName, outLen, "remapnbody26"), true;
        case 119: return format(outName, outLen, "remapnbody27"), true;
    }
    return false;
}

stock ShowTuningStylingGUI(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Вы должны быть в автомобиле!");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "Ошибка: Не удалось получить ID автомобиля!");

    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        return SendClientMessage(playerid, -1, "Вы должны находится в своём автомобиле.");

    new owner_id = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetOwnableCarData(owner_id, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, -1, "Вы должны находится в своём автомобиле.");
        
     new modelid = GetVehicleData(vehicleid, V_MODELID);

    g_TuningType[playerid] = 0;
    new Node:tuning_json = JSON_Object();
    new price;
    
	GetVehicleJsonCostByModelId(modelid, price);

    g_TuningGosCost[playerid] = price;
	 
	 JSON_SetInt(tuning_json, "t", 0);
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "t", 0);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));

    new Node:k_array = JSON_Array(), index = GetVehicleData(vehicleid, V_ACTION_ID);
    new current_strob = g_ownable_car[index][OC_STROB], current_horn = g_ownable_car[index][OC_HORN_ID], exhaust_type = g_ownable_car[index][OC_EXHAUST],
    vinyl_current = g_ownable_car[index][OC_VINYL_CURRENT];

    switch(current_strob)
    {
        case 0: current_strob = 28;
        case 1: current_strob = 29;
        case 2: current_strob = 30;
        case 3: current_strob = 31;
        case 4: current_strob = 32;
        case 5: current_strob = 0;
    }
    
    switch (current_horn)
{
    case 14: current_horn = 99;   // Короткий - бесплатный
    case 15: current_horn = 100;  // Мягкий №1 - бесплатный
    case 16: current_horn = 101;  // Резкий - бесплатный
    case 17: current_horn = 102;  // Мягкий №2 - бесплатный
    case 18: current_horn = 103;  // Громкий №1 - бесплатный
    case 19: current_horn = 104;  // Громкий №2 - бесплатный
    case 23: current_horn = 105;  // Громкий №3 - бесплатный
    case 29: current_horn = 106;  // Не громкий - бесплатный
    case 30: current_horn = 107;  // Crystal - платный
    case 31: current_horn = 108;  // 99 Problems - платный
    case 32: current_horn = 109;  // Million - платный
    case 33: current_horn = 110;  // HDMI - платный
    case 34: current_horn = 111;  // HIGHEST - платный
    case 24: current_horn = 112;  // Сирена №1 - платный
    case 25: current_horn = 113;  // Сирена №2 - бесплатный
    case 41: current_horn = 114;  // Крякалка №1 - платный
    case 42: current_horn = 115;  // Спец.сигнал №1 - платный
    case 43: current_horn = 116;  // Крякалка №2 - платный
    case 44: current_horn = 117;  // Спец.сигнал №2 - платный
    case 20: current_horn = 118;  // Гнусный - бесплатный
    case 21: current_horn = 119;  // Тяжелый - бесплатный
    case 22: current_horn = 120;  // Затянутый - бесплатный
    case 26: current_horn = 121;  // Звонкий №1 - бесплатный
    case 27: current_horn = 122;  // Писклявый - бесплатный
    case 28: current_horn = 123;  // Звонкий №2 - бесплатный
    case 35: current_horn = 124;  // Merry Christmas - платный
    case 36: current_horn = 125;  // Колокол №1 - бесплатный
    case 37: current_horn = 126;  // Колокол №2 - бесплатный
    case 38: current_horn = 127;  // Happy New Year - платный
    case 39: current_horn = 128;  // Sinatra - платный
    case 40: current_horn = 129;  // Человек года - платный
}

    switch(exhaust_type)
    {
        case 0: exhaust_type = 93;  // Резкий
        case 1: exhaust_type = 94;  // Затянутый
        case 2: exhaust_type = 95;  // Глухой
        case 3: exhaust_type = 96;  // Стреляющий
        case 4: exhaust_type = 97;  // Громкий
        case 5: exhaust_type = 98;  // Стреляющий
    }

    if(current_strob != -1)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(current_strob))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }
    if(g_ownable_car[index][OC_HIGHLIGHT] != -1)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(130))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }
    if(current_horn != -1)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(current_horn))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }
    if(exhaust_type != -1)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(exhaust_type))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }
    if(vinyl_current != -1)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(vinyl_current))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }
    JSON_SetArray(tuning_json, "k", k_array);

    new name[64];
    GetVehicleModelName(modelid, name, sizeof(name));
    JSON_SetString(tuning_json, "n", name);

    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    new Float:x = 1000.0847, Float:y = 1502.3265, Float:z = 1497.5124;
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, 180.0);

    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, playerid + 1);

    SetVehicleVirtualWorld(vehicleid, playerid + 1);

    SetPlayerCameraPos(playerid, 1004.384033, 1497.215942, 1500.519287);
    SetPlayerCameraLookAt(playerid, 1001.266967, 1501.026733, 1499.646728);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

stock ShowTuningTehGUI(playerid)
{
    if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Вы должны быть в автомобиле!");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "Ошибка: Не удалось получить ID автомобиля!");

    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        return SendClientMessage(playerid, -1, "Вы должны находится в своём автомобиле.");

    new owner_id = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetOwnableCarData(owner_id, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, -1, "Вы должны находится в своём автомобиле.");
        
     new modelid = GetVehicleData(vehicleid, V_MODELID);

    g_TuningType[playerid] = 3;
    new Node:tuning_json = JSON_Object();
    new price;
    
	GetVehicleJsonCostByModelId(modelid, price);

    g_TuningGosCost[playerid] = price;
	 
	JSON_SetInt(tuning_json, "t", 0);
    JSON_SetInt(tuning_json, "o", 1);
    JSON_SetInt(tuning_json, "w", 0);
    JSON_SetInt(tuning_json, "w", 3);
    JSON_SetInt(tuning_json, "t", 0);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));
    JSON_SetInt(tuning_json, "engine", 1);
    JSON_SetInt(tuning_json, "brakes", 2);
    JSON_SetInt(tuning_json, "suspension", 3);
    JSON_SetInt(tuning_json, "wheels", 1);

    new Node:k_array = JSON_Array(), i = GetVehicleData(vehicleid, V_ACTION_ID);
    new nitro_current = g_ownable_car[i][OC_NITRO], launch_current = g_ownable_car[i][OC_LAUNCHCONT];

    if(nitro_current != -1)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(nitro_current))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }
    if(launch_current != 0)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(35))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }
    if(g_ownable_car[i][OC_SPORT] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 3)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(5))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(5))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORT1] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 3)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(10))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(10))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORT2] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 3)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(15))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(15))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORT3] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 3)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(20))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(20))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORT4] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 3)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(25))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(25))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORTPLUS] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 4)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(7))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(7))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORTPLUS1] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 4)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(12))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(12))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORTPLUS2] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 4)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(17))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(17))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORTPLUS3] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 4)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(22))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(22))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_SPORTPLUS4] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 4)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(27))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(27))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_DRIFT] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 2)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(6))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(6))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_DRIFT1] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 2)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(11))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(11))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_DRIFT2] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 2)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(16))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(16))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_DRIFT3] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 2)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(21))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(21))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_DRIFT4] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 2)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(26))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(26))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_COMFORT] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 1)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(4))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(4))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_COMFORT1] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 1)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(9))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(9))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_COMFORT2] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 1)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(14))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(14))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_COMFORT3] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 1)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(19))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(19))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    if(g_ownable_car[i][OC_COMFORT4] == 1)
    {
        if(g_ownable_car[i][OC_ENABLE_HAND] == 1)
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(24))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
        }
        else 
        {
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(24))); 
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(1))); 
        }
    }
    
    
    
    JSON_SetArray(tuning_json, "k", k_array);

    new name[64];
    GetVehicleModelName(modelid, name, sizeof(name));
    JSON_SetString(tuning_json, "n", name);

    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    SetVehiclePos(vehicleid, 996.368164,999.465759,1001.791540);
    SetVehicleZAngle(vehicleid, 273.919586);

    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, playerid + 1);

    SetVehicleVirtualWorld(vehicleid, playerid + 1);

    SetPlayerCameraPos(playerid, 1001.483154,1002.271240,1000.906738);
    SetPlayerCameraLookAt(playerid, 997.090454,999.934204,1001.398864);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

stock ShowStoGUI(playerid)
{
        new vehicleID = GetPlayerVehicleID(playerid);
        new modelid = GetVehicleData(vehicleID, V_MODELID);
        if(vehicleID)
        {
            SetVehicleVirtualWorld(vehicleID, vehicleID);
            LinkVehicleToInterior(vehicleID, 1);
            SetVehiclePos(vehicleID, 2508.3931, 1504.2278, 1497.5);
            SetVehicleZAngle(vehicleID, 0.0);
        
            SetPlayerCameraPos(playerid, 2501.2969, 1511.0194, 1500.2665);
            SetPlayerCameraLookAt(playerid, 2502.0427, 1510.3536, 1500.0214);
            SetPlayerInterior(playerid, 1);
            SetPlayerVirtualWorld(playerid, vehicleID);
            
            for(new i = 0; i < MAX_PLAYERS; i++)
            {
                if(IsPlayerConnected(i) && GetPlayerVehicleID(i) == vehicleID)
                {
                    SetPlayerVirtualWorld(i, vehicleID);
                    SetPlayerInterior(i, 1);
                }
            }
new price;
    
	GetVehicleJsonCostByModelId(modelid, price);
    g_TuningGosCost[playerid] = price;
            new Node:tuning_jsonn = JSON_Object();
            JSON_SetInt(tuning_jsonn, "o", 1);
            JSON_SetInt(tuning_jsonn, "w", 1);
            JSON_SetInt(tuning_jsonn, "t", 0);
            JSON_SetInt(tuning_jsonn, "j", price);
            JSON_SetString(tuning_jsonn, "nm", GetPlayerNameEx(playerid));
            JSON_SetInt(tuning_jsonn, "m", GetPlayerMoney(playerid));
            JSON_SetInt(tuning_jsonn, "engine", 1);
            JSON_SetInt(tuning_jsonn, "brakes", 2);
            JSON_SetInt(tuning_jsonn, "suspension", 3);
			new jsonid = GetVehicleJsonIdFromModel(modelid);
			printf("JSONID : %d", jsonid);
            JSON_SetInt(tuning_jsonn, "s", jsonid);
			new name[64];
            GetVehicleDataName(modelid, name, sizeof(name));
            JSON_SetString(tuning_jsonn, "n", name);
			new vehicleid = GetPlayerOwnableCar(playerid);
			new i = GetVehicleData(vehicleid, V_ACTION_ID);
			new is = GetVehicleData(GetPlayerOwnableCar(playerid), V_ACTION_ID);
			g_TuningType[playerid] = 2;
			
			new Node:k_array = JSON_Array();
		    
			k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100))); //
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100))); //
			k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100))); //
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100)));
			k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100))); //
            k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100)));
			k_array = JSON_Append(k_array, JSON_Array(JSON_Int(100)));
		    JSON_SetArray(tuning_jsonn, "d", k_array);
			
            
            
            new Node:d_array = JSON_Array();
            
            if(!cache_num_rows())
            {
                new start, count;
            
                if(GetVehicleComponents(jsonid, start, count))
                {
                    for(new x; x < count; x++)
                    {
                        new component = gVehicleComponentList[start + x];
            
                        d_array = JSON_Append(d_array, JSON_Array(JSON_Int(component)));
                        d_array = JSON_Append(d_array, JSON_Array(JSON_Int(0)));
            
                    }
                }
            }
            else
            {
                new componentid, states;
            
                for(new x; x < cache_num_rows(); x++)
                {
                }
            }
            
            JSON_SetArray(tuning_jsonn, "k", d_array);
            new json_string[1024];
            JSON_Stringify(tuning_jsonn, json_string, sizeof(json_string));
            
            printf("TUNING JSON: %s", json_string);
            
            ShowPlayerGUI(playerid, 28, tuning_jsonn);
            JSON_Cleanup(d_array);
            JSON_Cleanup(tuning_jsonn);
			
			JSON_Cleanup(k_array);
			
        }
}

CMD:sto(playerid)
{
    ShowStoGUI(playerid);
    return 1;
}

stock ShowTireServiceGUI(playerid)
{
	if(!IsPlayerInAnyVehicle(playerid))
        return SendClientMessage(playerid, -1, "Вы должны быть в автомобиле!");

    new vehicleid = GetPlayerVehicleID(playerid);
    if(vehicleid == INVALID_VEHICLE_ID)
        return SendClientMessage(playerid, -1, "Ошибка: Не удалось получить ID автомобиля!");

    if(GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_OWNABLE_CAR)
        return SendClientMessage(playerid, -1, "Вы должны находится в своём автомобиле.");

    new owner_id = GetVehicleData(vehicleid, V_ACTION_ID);
    if(GetOwnableCarData(owner_id, OC_OWNER_ID) != GetPlayerAccountID(playerid))
        return SendClientMessage(playerid, -1, "Вы должны находится в своём автомобиле.");
        
     new modelid = GetVehicleData(vehicleid, V_MODELID);

    g_TuningType[playerid] = 1;

    SyncVehicleTuningForPlayer(playerid, vehicleid);

    new Node:tuning_json = JSON_Object();
    new price;
    
	GetVehicleJsonCostByModelId(modelid, price);


    g_TuningGosCost[playerid] = price;

    JSON_SetInt(tuning_json, "o", 2);
    JSON_SetInt(tuning_json, "w", 2);
    JSON_SetInt(tuning_json, "t", 2);
    JSON_SetInt(tuning_json, "j", price);
    JSON_SetString(tuning_json, "nm", GetPlayerNameEx(playerid));

    new Node:k_array = JSON_Array(), index = GetVehicleData(vehicleid, V_ACTION_ID);
    new disk_id = g_ownable_car[index][OC_DISKI_ID], gidra_current = g_ownable_car[index][OC_GIDRA], pnevmo_current = g_ownable_car[index][OC_PNEVMO];

    switch (disk_id)
{
    case 1908: disk_id = 36;  // 3SDM 3.0
    case 1909: disk_id = 37;  // 3SDM 3.01
    case 1910: disk_id = 38;  // 3SDM 3.05
    case 1911: disk_id = 39;  // 3SDM 3.06
    case 1912: disk_id = 40;  // 3SDM 3.33
    case 1913: disk_id = 41;  // 3SDM 3.35
    case 1914: disk_id = 42;  // 3SDM 3.41
    case 1915: disk_id = 43;  // 3SDM 3.66
    case 1916: disk_id = 44;  // BBS CC-R
    case 1917: disk_id = 45;  // BBS CH-R
    case 1918: disk_id = 46;  // BBS CL-R
    case 1919: disk_id = 47;  // BBS LM
    case 1920: disk_id = 48;  // BBS RS
    case 1921: disk_id = 49;  // COSMIS ILS1
    case 1922: disk_id = 50;  // COSMIS MXT
    case 1923: disk_id = 51;  // COSMIS MR7
    case 1924: disk_id = 52;  // COSMIS N5R
    case 1925: disk_id = 53;  // COSMIS XT
    case 1926: disk_id = 54;  // RTFBLQS
    case 1927: disk_id = 55;  // RTFCCVT
    case 1928: disk_id = 56;  // RTFBTH
    case 1929: disk_id = 57;  // RTFFINDT
    case 1930: disk_id = 58;  // RTFFIND
    case 1931: disk_id = 59;  // RTFLVS
    case 1932: disk_id = 60;  // RTFHURT
    case 1933: disk_id = 61;  // RTFFOZR
    case 1934: disk_id = 62;  // RTFSFOT
    case 1935: disk_id = 63;  // RTFFWGRM
    case 1936: disk_id = 64;  // HRE 305
    case 1937: disk_id = 65;  // HRE 935
    case 1938: disk_id = 66;  // HRE C109
    case 1939: disk_id = 67;  // HRE 505
    case 1940: disk_id = 68;  // HRE 501
    case 1941: disk_id = 69;  // HRE P200
    case 1942: disk_id = 70;  // HRE R101
    case 1943: disk_id = 71;  // HRE RS106
    case 1944: disk_id = 72;  // HRE S107
    case 1945: disk_id = 73;  // HRE S201H
    case 1946: disk_id = 74;  // VN VSE001
    case 1947: disk_id = 75;  // VN VSE002
    case 1948: disk_id = 76;  // VN VSM310
    case 1949: disk_id = 77;  // VN VSM312
    case 1950: disk_id = 78;  // VN VSM313
    case 1951: disk_id = 79;  // VN VSR162
    case 1952: disk_id = 80;  // VN VSR163
    case 1953: disk_id = 81;  // VN VSR165
    case 1954: disk_id = 82;  // VN VTM350
    case 1955: disk_id = 83;  // VN VTM351
    case 1956: disk_id = 84;  // VOSSEN CV3
    case 1957: disk_id = 85;  // VOSSEN CV5
    case 1958: disk_id = 86;  // VOSSEN VFS2
    case 1959: disk_id = 87;  // WH CR01
    case 1960: disk_id = 88;  // WH CRKAI
    case 1961: disk_id = 89;  // WH D9R
    case 1962: disk_id = 90;  // WH M1
    case 1963: disk_id = 91;  // WH S1
    case 1964: disk_id = 92;  // WH XT7
}

    if(disk_id != -1)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(disk_id))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }

    if(gidra_current != -1)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(gidra_current))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }

    if(pnevmo_current != 0)
    {
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(34))); 
        k_array = JSON_Append(k_array, JSON_Array(JSON_Int(2))); 
    }

    JSON_SetArray(tuning_json, "k", k_array);

    new name[64];
    GetVehicleDataName(modelid, name, sizeof(name));
    JSON_SetString(tuning_json, "n", name);
    JSON_SetInt(tuning_json, "m", GetPlayerMoneyEx(playerid));

    new Float:x = 995.452331, Float:y = 1001.766601, Float:z = 1500.253295;
    SetVehiclePos(vehicleid, x, y, z);
    SetVehicleZAngle(vehicleid, 180.0);

    SetPlayerInterior(playerid, 1);
    SetPlayerVirtualWorld(playerid, playerid + 1);

    SetVehicleVirtualWorld(vehicleid, playerid + 1);

    SetPlayerCameraPos(playerid, 998.835937, 997.811462, 1501.182983);
    SetPlayerCameraLookAt(playerid, 995.605468, 1001.587646, 1501.734863);

    ShowPlayerGUI(playerid, 28, tuning_json);
    JSON_Cleanup(tuning_json);
    return 1;
}

stock CloseTuningGUI(playerid)
{
    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid != INVALID_VEHICLE_ID)
    {
        SyncVehicleTuningForPlayer(playerid, vehicleid);
    }

    new Node:json = JSON_Object();
    JSON_SetInt(json, "t", 255);
    JSON_SetInt(json, "s", 1);
    ShowPlayerGUI(playerid, 28, json);
    JSON_Cleanup(json);

    TogglePlayerControllable(playerid, 1);
    SetCameraBehindPlayer(playerid);

    switch(g_TuningType[playerid])
    {
        case 0:
        {
            SetVehiclePos(vehicleid, 2296.146240, -2613.668457, 21.829063);
            SetVehicleZAngle(vehicleid, 90.0);
        }
        case 1:
        {
            SetVehiclePos(vehicleid, 1742.453979, 2465.383544, 14.454860);
            SetVehicleZAngle(vehicleid, 285.0);
        }
    }

    SetPlayerInterior(playerid, 0);
    g_TuningType[playerid] = 0;

    printf("Tuning GUI closed for player %d", playerid);
}

stock GetFirmwarePrice(vehicleID, Float:percent)
{
    new car_price;
    GetVehicleJsonCostByModelId(GetVehicleData(vehicleID, V_MODELID), car_price);
	printf("carprice %d", car_price);
	printf("carpriceper %d", floatround(car_price * (percent / 100.0)));
    return floatround(car_price * (percent / 100.0));
}

stock PacketIncomingTuning(playerid, Node:JSONObject)
{
    new Node:tuning_response = JSON_Object(), 
        type, 
        selector_id, 
        detail_id, 
        color_val,
        color_hex[64],
        status,
        operation,
        car_id,
        current_money,
        color[32], data_value, vinyl[64], currency_type;
    
    JSON_GetInt(JSONObject, "t", type);
    JSON_GetInt(JSONObject, "s", status);           // статус операции
    JSON_GetInt(JSONObject, "m", selector_id);      // ID селектора/цвета (m - selector)
    JSON_GetInt(JSONObject, "d", data_value);
    JSON_GetString(JSONObject, "d", color, sizeof(color));
    JSON_GetInt(JSONObject, "p", detail_id);        // ID детали для ремонта
    JSON_GetInt(JSONObject, "mt", operation);       // тип операции для деталей
    JSON_GetString(JSONObject, "d", color_hex, sizeof(color_hex)); // HEX цвет
    JSON_GetString(JSONObject, "co", color, sizeof(color));
    JSON_GetString(JSONObject, "v", vinyl, sizeof(vinyl));
    JSON_GetInt(JSONObject, "c", currency_type);

    BlackPass_OnTuningPurchase(playerid);

    new gosCost = g_TuningGosCost[playerid];
    
    switch(type) 
    {
        case 0:
        {
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            
            switch(g_TuningType[playerid])
            {
                case 0: 
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 2296.146240, -2613.668457, 21.829063);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 90.0);
                }
                case 1:
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 1742.453979, 2465.383544, 14.454860);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 285.0);
                }
                case 2:
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), 2131.0, -876.0, 27.947052);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 285.0);
                }
                case 3:
                {
                    SetVehiclePos(GetPlayerVehicleID(playerid), -422.748107, 1030.279174, 11.246218);
                    SetVehicleZAngle(GetPlayerVehicleID(playerid), 285.0);
                }
            }
            
            SetPlayerInterior(playerid, 0);
            SetPlayerVirtualWorld(playerid, 0);
            SetVehicleVirtualWorld(GetPlayerVehicleID(playerid), 0);
            g_TuningType[playerid] = 0;
            
            JSON_SetInt(tuning_response, "t", 0);
            JSON_SetInt(tuning_response, "s", 1); 
        }
        case 1:
    {
        new price = GetTuningPrice(selector_id, gosCost);

        new vehid = GetPlayerVehicleID(playerid), database_id = GetOwnableCarData(GetVehicleData(vehid, V_ACTION_ID), OC_SQL_ID);
        new r, g, b, hex_color, color2_string[18], color_string[18];
        sscanf(color, "x", hex_color);
        r = (hex_color >> 16) & 0xFF;
        g = (hex_color >> 8) & 0xFF;
        b = hex_color & 0xFF;
        printf("[DEBUG] : R=%d, G=%d, B=%d", r, g, b);
        new tint_level = floatround((r + g + b) / 3.0);

        if(selector_id == 0)
        {
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                new query[256];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET body_color = %d WHERE id = %d", HexToInt(color), database_id);
                new i = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[i][OC_COLOR_BODY]   = HexToInt(color);
                                            
                SetVehicleColorHexForPlayers(playerid, GetPlayerVehicleID(playerid), g_ownable_car[i][OC_COLOR_BODY], g_ownable_car[i][OC_COLOR_WHEEL]);

                mysql_query(mysql, query, false);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetString(tuning_response, "d", color);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                GivePlayerMoneyEx(playerid, -price);
            }
            else
            {
                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
            }
        }
        else if(selector_id == 31 || selector_id == 1)
        {
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                new query[256];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET wheel_color = %d WHERE id = %d", HexToInt(color), database_id);
                new i = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[i][OC_COLOR_WHEEL]   = HexToInt(color);
                                            
                SetVehicleColorHexForPlayers(playerid, GetPlayerVehicleID(playerid), g_ownable_car[i][OC_COLOR_BODY], g_ownable_car[i][OC_COLOR_WHEEL]);

                mysql_query(mysql, query, false);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetString(tuning_response, "d", color);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                GivePlayerMoneyEx(playerid, -price);
            }
            else
            {
                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
            }
        }
        else if(selector_id == 3)
        {
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                new query[256];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET toner_ft = %d WHERE id = %d", HexToInt(color), database_id);
                new index = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[index][OC_TONER_FT]   = HexToInt(color);
                SetVehicleTonerForPlayer(playerid, GetPlayerVehicleID(playerid), g_ownable_car[index][OC_TONER_FT], g_ownable_car[index][OC_TONER_RR]);
                mysql_query(mysql, query, false);
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetString(tuning_response, "d", color);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                GivePlayerMoneyEx(playerid, -price);
            }
            else
            {
                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
            }
        }
        else if(selector_id == 4)
        {
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                new query[256];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET toner_rr = %d WHERE id = %d", HexToInt(color), database_id);
                new index = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[index][OC_TONER_RR]   = HexToInt(color);
                SetVehicleTonerForPlayer(playerid, GetPlayerVehicleID(playerid), g_ownable_car[index][OC_TONER_FT], g_ownable_car[index][OC_TONER_RR]);
                mysql_query(mysql, query, false);
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetString(tuning_response, "d", color);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                GivePlayerMoneyEx(playerid, -price);
            }
            else
            {
                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
            }
        }
        else if(selector_id == 10)
        {
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                new query[256];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET lights_color = %d WHERE id = %d", HexToInt(color), database_id);
                new index = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[index][OC_LIGHTS_COLOR]   = HexToInt(color);
                SetVehicleLightsColorForPlayers(playerid, vehid, g_ownable_car[index][OC_LIGHTS_COLOR]);
                mysql_query(mysql, query, false);
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetString(tuning_response, "d", color);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                GivePlayerMoneyEx(playerid, -price);
            }
            else
            {
                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
            }
        }
        else if(selector_id == 11)
        {
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                new query[256];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET underlights = %d WHERE id = %d", HexToInt(color), database_id);
                new index = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[index][OC_UNDERLIGHTS]   = HexToInt(color);
                SetVehicleNeonForPlayer(playerid, GetPlayerVehicleID(playerid), g_ownable_car[index][OC_UNDERLIGHTS], g_ownable_car[index][OC_UNDERLIGHTS_LT], g_ownable_car[index][OC_UNDERLIGHTS_RT]);
                mysql_query(mysql, query, false);
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_neon = %d WHERE id = %d", 1, database_id);
                mysql_query(mysql, query, false);
                g_ownable_car[index][OC_ENABLE_NEON] = 1;
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetString(tuning_response, "d", color);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                GivePlayerMoneyEx(playerid, -price);
            }
            else
            {
                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
            }
        }
        else if(selector_id == 12)
        {
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                new query[256];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET underlights_rt = %d WHERE id = %d", HexToInt(color), database_id);
                new index = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[index][OC_UNDERLIGHTS_RT]   = HexToInt(color);
                SetVehicleNeonForPlayer(playerid, GetPlayerVehicleID(playerid), g_ownable_car[index][OC_UNDERLIGHTS], g_ownable_car[index][OC_UNDERLIGHTS_LT], g_ownable_car[index][OC_UNDERLIGHTS_RT]);
                mysql_query(mysql, query, false);
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_neon = %d WHERE id = %d", 1, database_id);
                mysql_query(mysql, query, false);
                g_ownable_car[index][OC_ENABLE_NEON] = 1;
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetString(tuning_response, "d", color);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                GivePlayerMoneyEx(playerid, -price);
            }
            else
            {
                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
            }
        }
        else if(selector_id == 13)
        {
            if(GetPlayerMoneyEx(playerid) >= price)
            {
                new query[256];
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET underlights_lt = %d WHERE id = %d", HexToInt(color), database_id);
                new index = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[index][OC_UNDERLIGHTS_LT]   = HexToInt(color);
                SetVehicleNeonForPlayer(playerid, GetPlayerVehicleID(playerid), g_ownable_car[index][OC_UNDERLIGHTS], g_ownable_car[index][OC_UNDERLIGHTS_LT], g_ownable_car[index][OC_UNDERLIGHTS_RT]);
                mysql_query(mysql, query, false);
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_neon = %d WHERE id = %d", 1, database_id);
                mysql_query(mysql, query, false);
                g_ownable_car[index][OC_ENABLE_NEON] = 1;
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetString(tuning_response, "d", color);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
				JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                GivePlayerMoneyEx(playerid, -price);
            }
            else
            {
                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 0);
                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
            }
        }
        printf("color_hex: %s", color_hex);
   
    }
        case 2:
        {
            new vehid = GetPlayerVehicleID(playerid);
            new transparency, price;
            new hex_with_alpha[16];
            
            JSON_GetInt(JSONObject, "h", transparency);
            JSON_GetInt(JSONObject, "j", price);
            
            format(hex_with_alpha, sizeof(hex_with_alpha), "%02X%s", transparency, color_hex);
            
            JSON_SetInt(tuning_response, "t", 2);
            JSON_SetInt(tuning_response, "s", 1);
            JSON_SetString(tuning_response, "d", hex_with_alpha); // D_KEY_SEND_COLOR_HEX
        }
        case 7:
        {
            new vehid = GetPlayerVehicleID(playerid), database_id = GetOwnableCarData(GetVehicleData(vehid, V_ACTION_ID), OC_SQL_ID), query[256];
            if(data_value == 0 || data_value == 1 || data_value == 2)
            {
                new i = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[i][OC_NITRO] = data_value;
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET nitro = %d WHERE id = %d", g_ownable_car[i][OC_NITRO], database_id);
                mysql_query(mysql, query, false);
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetInt(tuning_response, "d", data_value);
                JSON_SetInt(tuning_response, "p", data_value);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                if(g_ownable_car[i][OC_NITRO] != -1)
                {
                    switch(g_ownable_car[i][OC_NITRO])
                    {
                        case 0: AddVehicleComponent(vehid, 1008);
                        case 1: AddVehicleComponent(vehid, 1009);
                        case 2: AddVehicleComponent(vehid, 1010);
                    }
                }

            }
            else if(data_value == 4 || data_value == 9 || data_value == 14 || data_value == 19 || data_value == 24)
            {
                new i = GetVehicleData(vehid, V_ACTION_ID);

                if(data_value == 4)
                {
                    g_ownable_car[i][OC_COMFORT] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort = %d WHERE id = %d", g_ownable_car[i][OC_COMFORT], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_COMFORT] == 1 
                    && g_ownable_car[i][OC_COMFORT1] == 1 
                    && g_ownable_car[i][OC_COMFORT2] == 1 
                    && g_ownable_car[i][OC_COMFORT3] == 1 
                    && g_ownable_car[i][OC_COMFORT4] == 1)
                    {
                        SetVehicleComfortFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 1;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 9)
                {
                    g_ownable_car[i][OC_COMFORT1] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort1 = %d WHERE id = %d", g_ownable_car[i][OC_COMFORT1], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_COMFORT] == 1 
                    && g_ownable_car[i][OC_COMFORT1] == 1 
                    && g_ownable_car[i][OC_COMFORT2] == 1 
                    && g_ownable_car[i][OC_COMFORT3] == 1 
                    && g_ownable_car[i][OC_COMFORT4] == 1)
                    {
                        SetVehicleComfortFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 1;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 14)
                {
                    g_ownable_car[i][OC_COMFORT2] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort2 = %d WHERE id = %d", g_ownable_car[i][OC_COMFORT2], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_COMFORT] == 1 
                    && g_ownable_car[i][OC_COMFORT1] == 1 
                    && g_ownable_car[i][OC_COMFORT2] == 1 
                    && g_ownable_car[i][OC_COMFORT3] == 1 
                    && g_ownable_car[i][OC_COMFORT4] == 1)
                    {
                        SetVehicleComfortFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 1;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 19)
                {
                    g_ownable_car[i][OC_COMFORT3] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort3 = %d WHERE id = %d", g_ownable_car[i][OC_COMFORT3], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_COMFORT] == 1 
                    && g_ownable_car[i][OC_COMFORT1] == 1 
                    && g_ownable_car[i][OC_COMFORT2] == 1 
                    && g_ownable_car[i][OC_COMFORT3] == 1 
                    && g_ownable_car[i][OC_COMFORT4] == 1)
                    {
                        SetVehicleComfortFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 1;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 24)
                {
                    g_ownable_car[i][OC_COMFORT4] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET comfort4 = %d WHERE id = %d", g_ownable_car[i][OC_COMFORT4], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_COMFORT] == 1 
                    && g_ownable_car[i][OC_COMFORT1] == 1 
                    && g_ownable_car[i][OC_COMFORT2] == 1 
                    && g_ownable_car[i][OC_COMFORT3] == 1 
                    && g_ownable_car[i][OC_COMFORT4] == 1)
                    {
                        SetVehicleComfortFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 1;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
            }
            else if(data_value == 6 || data_value == 11 || data_value == 16 || data_value == 21 || data_value == 26)
            {
                new i = GetVehicleData(vehid, V_ACTION_ID);

                if(data_value == 6)
                {
                    g_ownable_car[i][OC_DRIFT] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift = %d WHERE id = %d", g_ownable_car[i][OC_DRIFT], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_DRIFT] == 1 
                    && g_ownable_car[i][OC_DRIFT1] == 1 
                    && g_ownable_car[i][OC_DRIFT2] == 1 
                    && g_ownable_car[i][OC_DRIFT3] == 1 
                    && g_ownable_car[i][OC_DRIFT4] == 1)
                    {
                        SetVehicleDriftFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 2;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 11)
                {
                    g_ownable_car[i][OC_DRIFT1] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift1 = %d WHERE id = %d", g_ownable_car[i][OC_DRIFT1], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_DRIFT] == 1 
                    && g_ownable_car[i][OC_DRIFT1] == 1 
                    && g_ownable_car[i][OC_DRIFT2] == 1 
                    && g_ownable_car[i][OC_DRIFT3] == 1 
                    && g_ownable_car[i][OC_DRIFT4] == 1)
                    {
                        SetVehicleDriftFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 2;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 16)
                {
                    g_ownable_car[i][OC_DRIFT2] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift2 = %d WHERE id = %d", g_ownable_car[i][OC_DRIFT2], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_DRIFT] == 1 
                    && g_ownable_car[i][OC_DRIFT1] == 1 
                    && g_ownable_car[i][OC_DRIFT2] == 1 
                    && g_ownable_car[i][OC_DRIFT3] == 1 
                    && g_ownable_car[i][OC_DRIFT4] == 1)
                    {
                        SetVehicleDriftFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 2;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 21)
                {
                    g_ownable_car[i][OC_DRIFT3] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift3 = %d WHERE id = %d", g_ownable_car[i][OC_DRIFT3], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_DRIFT] == 1 
                    && g_ownable_car[i][OC_DRIFT1] == 1 
                    && g_ownable_car[i][OC_DRIFT2] == 1 
                    && g_ownable_car[i][OC_DRIFT3] == 1 
                    && g_ownable_car[i][OC_DRIFT4] == 1)
                    {
                        SetVehicleDriftFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 2;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 26)
                {
                    g_ownable_car[i][OC_DRIFT4] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET drift4 = %d WHERE id = %d", g_ownable_car[i][OC_DRIFT4], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_DRIFT] == 1 
                    && g_ownable_car[i][OC_DRIFT1] == 1 
                    && g_ownable_car[i][OC_DRIFT2] == 1 
                    && g_ownable_car[i][OC_DRIFT3] == 1 
                    && g_ownable_car[i][OC_DRIFT4] == 1)
                    {
                        SetVehicleDriftFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 2;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
            }
            else if(data_value == 5 || data_value == 10 || data_value == 15 || data_value == 20 || data_value == 25)
            {
                new i = GetVehicleData(vehid, V_ACTION_ID);

                if(data_value == 5)
                {
                    g_ownable_car[i][OC_SPORT] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport = %d WHERE id = %d", g_ownable_car[i][OC_SPORT], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORT] == 1 
                    && g_ownable_car[i][OC_SPORT1] == 1 
                    && g_ownable_car[i][OC_SPORT2] == 1 
                    && g_ownable_car[i][OC_SPORT3] == 1 
                    && g_ownable_car[i][OC_SPORT4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 3;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 10)
                {
                    g_ownable_car[i][OC_SPORT1] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport1 = %d WHERE id = %d", g_ownable_car[i][OC_SPORT1], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORT] == 1 
                    && g_ownable_car[i][OC_SPORT1] == 1 
                    && g_ownable_car[i][OC_SPORT2] == 1 
                    && g_ownable_car[i][OC_SPORT3] == 1 
                    && g_ownable_car[i][OC_SPORT4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 3;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 15)
                {
                    g_ownable_car[i][OC_SPORT2] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport2 = %d WHERE id = %d", g_ownable_car[i][OC_SPORT2], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORT] == 1 
                    && g_ownable_car[i][OC_SPORT1] == 1 
                    && g_ownable_car[i][OC_SPORT2] == 1 
                    && g_ownable_car[i][OC_SPORT3] == 1 
                    && g_ownable_car[i][OC_SPORT4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 3;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 20)
                {
                    g_ownable_car[i][OC_SPORT3] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport3 = %d WHERE id = %d", g_ownable_car[i][OC_SPORT3], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORT] == 1 
                    && g_ownable_car[i][OC_SPORT1] == 1 
                    && g_ownable_car[i][OC_SPORT2] == 1 
                    && g_ownable_car[i][OC_SPORT3] == 1 
                    && g_ownable_car[i][OC_SPORT4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 3;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 25)
                {
                    g_ownable_car[i][OC_SPORT4] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sport4 = %d WHERE id = %d", g_ownable_car[i][OC_SPORT4], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORT] == 1 
                    && g_ownable_car[i][OC_SPORT1] == 1 
                    && g_ownable_car[i][OC_SPORT2] == 1 
                    && g_ownable_car[i][OC_SPORT3] == 1 
                    && g_ownable_car[i][OC_SPORT4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 3;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
            }
            else if(data_value == 7 || data_value == 12 || data_value == 17 || data_value == 22 || data_value == 27)
            {
                new i = GetVehicleData(vehid, V_ACTION_ID);

                if(data_value == 7)
                {
                    g_ownable_car[i][OC_SPORTPLUS] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sportplus = %d WHERE id = %d", g_ownable_car[i][OC_SPORTPLUS], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORTPLUS] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS1] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS2] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS3] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 4;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 12)
                {
                    g_ownable_car[i][OC_SPORTPLUS1] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sportplus1 = %d WHERE id = %d", g_ownable_car[i][OC_SPORTPLUS1], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORTPLUS] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS1] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS2] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS3] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 4;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 17)
                {
                    g_ownable_car[i][OC_SPORTPLUS2] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sportplus2 = %d WHERE id = %d", g_ownable_car[i][OC_SPORTPLUS2], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORTPLUS] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS1] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS2] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS3] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 4;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 22)
                {
                    g_ownable_car[i][OC_SPORTPLUS3] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sportplus3 = %d WHERE id = %d", g_ownable_car[i][OC_SPORTPLUS3], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORTPLUS] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS1] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS2] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS3] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 4;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
                else if(data_value == 27)
                {
                    g_ownable_car[i][OC_SPORTPLUS4] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET sportplus4 = %d WHERE id = %d", g_ownable_car[i][OC_SPORTPLUS4], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));

                    if(g_ownable_car[i][OC_SPORTPLUS] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS1] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS2] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS3] == 1 
                    && g_ownable_car[i][OC_SPORTPLUS4] == 1)
                    {
                        SetVehicleSportFP(playerid, vehid);
                        g_ownable_car[i][OC_ENABLE_HAND] = 4;
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET enable_hand = %d WHERE id = %d", g_ownable_car[i][OC_ENABLE_HAND], database_id);
                        mysql_query(mysql, query, false);
                    }
                }
            }
            else if(data_value >= 28 && data_value <= 31)
            {
                new price = GetTuningPrice(selector_id, gosCost, data_value);
                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);
                    new stroboscope_type;
                    switch(data_value)
                    {
                        case 28: stroboscope_type = 0;
                        case 29: stroboscope_type = 1;
                        case 30: stroboscope_type = 2;
                        case 31: stroboscope_type = 3;
                    }
                    new i = GetVehicleData(vehid, V_ACTION_ID);
                    g_ownable_car[i][OC_STROB] = stroboscope_type;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET strob = %d WHERE id = %d", g_ownable_car[i][OC_STROB], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                    ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы успешно установили стробоскопы!", "");
                }
                else
                {
                    ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(data_value == 32)
            {
                new price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0050871080139373);
                if(GetPlayerDonateRub(playerid) >= price)
                {
                    SetPlayerData(playerid, P_DONATE_RUB, GetPlayerData(playerid, P_DONATE_RUB) - price);
                    UpdatePlayerDatabaseInt(playerid, "rub", GetPlayerData(playerid, P_DONATE_RUB));
                    new i = GetVehicleData(vehid, V_ACTION_ID);
                    g_ownable_car[i][OC_STROB] = 4;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET strob = %d WHERE id = %d", g_ownable_car[i][OC_STROB], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                    ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы успешно установили стробоскопы!", "");
                }
                else
                {
                    ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(data_value == 33)
            {
                new price = GetTuningPrice(selector_id, gosCost, data_value);
                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);
                    new i = GetVehicleData(vehid, V_ACTION_ID);
                    g_ownable_car[i][OC_GIDRA] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET gidra = %d WHERE id = %d", g_ownable_car[i][OC_GIDRA], database_id);
                    SetVehicleHydraulics(vehid, 1, 0);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                }
                else 
                {
                    ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(data_value == 34)
            {
                new price = GetTuningPrice(selector_id, gosCost, data_value);
                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    GivePlayerMoneyEx(playerid, -price);
                    new i = GetVehicleData(vehid, V_ACTION_ID);
                    g_ownable_car[i][OC_PNEVMO] = 1;
                    g_ownable_car[i][OC_ENABLE_PNEVMO] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET pnevmo = %d, enable_pnevmo = %d WHERE id = %d", g_ownable_car[i][OC_PNEVMO], g_ownable_car[i][OC_ENABLE_PNEVMO], database_id);
                    SetVehicleSuspensionForceForPlayer(playerid, vehid, 0.55);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                }
                else 
                {
                    ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            if(data_value == 35)
            {
                new i = GetVehicleData(vehid, V_ACTION_ID);
                g_ownable_car[i][OC_LAUNCHCONT] = 1;
                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET launch = %d WHERE id = %d", g_ownable_car[i][OC_LAUNCHCONT], database_id);
                mysql_query(mysql, query, false);
                JSON_SetInt(tuning_response, "t", type);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetInt(tuning_response, "d", data_value);
                JSON_SetInt(tuning_response, "p", data_value);
                JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы успешно установили Лануч-контроль!", "");
            }
            else if(data_value >= 36 && data_value <= 92)
            {
                new price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 1.139372822299652), disk_id;
                if(GetPlayerMoneyEx(playerid) >= price)
                {
                    switch (data_value)
                    {
                        case 36: disk_id = 1908;  // 3SDM 3.0
                        case 37: disk_id = 1909;  // 3SDM 3.01
                        case 38: disk_id = 1910;  // 3SDM 3.05
                        case 39: disk_id = 1911;  // 3SDM 3.06
                        case 40: disk_id = 1912;  // 3SDM 3.33
                        case 41: disk_id = 1913;  // 3SDM 3.35
                        case 42: disk_id = 1914;  // 3SDM 3.41
                        case 43: disk_id = 1915;  // 3SDM 3.66
                        case 44: disk_id = 1916;  // BBS CC-R
                        case 45: disk_id = 1917;  // BBS CH-R
                        case 46: disk_id = 1918;  // BBS CL-R
                        case 47: disk_id = 1919;  // BBS LM
                        case 48: disk_id = 1920;  // BBS RS
                        case 49: disk_id = 1921;  // COSMIS ILS1
                        case 50: disk_id = 1922;  // COSMIS MXT
                        case 51: disk_id = 1923;  // COSMIS MR7
                        case 52: disk_id = 1924;  // COSMIS N5R
                        case 53: disk_id = 1925;  // COSMIS XT
                        case 54: disk_id = 1926;  // RTFBLQS
                        case 55: disk_id = 1927;  // RTFCCVT
                        case 56: disk_id = 1928;  // RTFBTH
                        case 57: disk_id = 1929;  // RTFFINDT
                        case 58: disk_id = 1930;  // RTFFIND
                        case 59: disk_id = 1931;  // RTFLVS
                        case 60: disk_id = 1932;  // RTFHURT
                        case 61: disk_id = 1933;  // RTFFOZR
                        case 62: disk_id = 1934;  // RTFSFOT
                        case 63: disk_id = 1935;  // RTFFWGRM
                        case 64: disk_id = 1936;  // HRE 305
                        case 65: disk_id = 1937;  // HRE 935
                        case 66: disk_id = 1938;  // HRE C109
                        case 67: disk_id = 1939;  // HRE 505
                        case 68: disk_id = 1940;  // HRE 501
                        case 69: disk_id = 1941;  // HRE P200
                        case 70: disk_id = 1942;  // HRE R101
                        case 71: disk_id = 1943;  // HRE RS106
                        case 72: disk_id = 1944;  // HRE S107
                        case 73: disk_id = 1945;  // HRE S201H
                        case 74: disk_id = 1946;  // VN VSE001
                        case 75: disk_id = 1947;  // VN VSE002
                        case 76: disk_id = 1948;  // VN VSM310
                        case 77: disk_id = 1949;  // VN VSM312
                        case 78: disk_id = 1950;  // VN VSM313
                        case 79: disk_id = 1951;  // VN VSR162
                        case 80: disk_id = 1952;  // VN VSR163
                        case 81: disk_id = 1953;  // VN VSR165
                        case 82: disk_id = 1954;  // VN VTM350
                        case 83: disk_id = 1955;  // VN VTM351
                        case 84: disk_id = 1956;  // VOSSEN CV3
                        case 85: disk_id = 1957;  // VOSSEN CV5
                        case 86: disk_id = 1958;  // VOSSEN VFS2
                        case 87: disk_id = 1959;  // WH CR01
                        case 88: disk_id = 1960;  // WH CRKAI
                        case 89: disk_id = 1961;  // WH D9R
                        case 90: disk_id = 1962;  // WH M1
                        case 91: disk_id = 1963;  // WH S1
                        case 92: disk_id = 1964;  // WH XT7
                    }
                    SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - price);
                    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                    GivePlayerMoney(playerid, -price);
                    new i = GetVehicleData(vehid, V_ACTION_ID);
                    g_ownable_car[i][OC_DISKI_ID] = disk_id;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET disk_id = %d WHERE id = %d", g_ownable_car[i][OC_DISKI_ID], database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы успешно установили диски!", "");
                }
                else
                {
                    ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(data_value == 130)
            {
                new price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.2393728222996516);
                if(GetPlayerMoney(playerid) >= price)
                {
                    SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - price);
                    UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                    new i = GetVehicleData(vehid, V_ACTION_ID);
                    g_ownable_car[i][OC_HIGHLIGHT] = 1;
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET highlight = %d WHERE id = %d", 1, database_id);
                    mysql_query(mysql, query, false);
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "d", data_value);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                    JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                    ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы успешно установили дальний свет!", "");
                }
                else
                {
                    ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(data_value >= 93 && data_value <= 98)
            {
                new exhaust_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 3.696864111498258);
                new i = GetVehicleData(vehid, V_ACTION_ID);
                new exhaust_type = data_value;
                switch(data_value)
        {
            case 93: exhaust_type = 0;  // Резкий
            case 94: exhaust_type = 1;  // Затянутый
            case 95: exhaust_type = 2;  // Глухой
            case 96: exhaust_type = 3;  // Стреляющий
            case 97: exhaust_type = 4;  // Громкий
            case 98: exhaust_type = 5;  // Стреляющий
        }
        if(GetPlayerMoney(playerid) >= exhaust_price)
                            {
                                SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - exhaust_price);
                                UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                                GivePlayerMoney(playerid, -exhaust_price);
                                mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET exhaust = %d WHERE id = %d", exhaust_type, database_id);
                                g_ownable_car[i][OC_EXHAUST] = exhaust_type;
                                SetVehicleExhaust(vehid, exhaust_type, 1);
                                
                                mysql_query(mysql, query, false);
                                JSON_SetInt(tuning_response, "t", type);
                                JSON_SetInt(tuning_response, "s", 1);
                                JSON_SetInt(tuning_response, "d", data_value);
                                JSON_SetInt(tuning_response, "p", data_value);
                                ShowNotificationSile(playerid, 3, 5, -1, -1, "Вы успешно установили новый звук выхлопа!", "");
                            }
                            else 
                            {
                                ShowNotificationSile(playerid, 2, 6, 0, 0, "Недостаточно средств!", "");
                                JSON_SetInt(tuning_response, "t", type);
                                JSON_SetInt(tuning_response, "s", 0);
                                JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                            }
            } else if(data_value >= 99 && data_value <= 129)
            {
                new i = GetVehicleData(vehid, V_ACTION_ID);
                new sound_id = data_value;
                new sound_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 8.393728222996516);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 0.0078048780487);
                
                switch (data_value)
                {
                    case 99: 
                    {
                        sound_id = 14;  // Короткий - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 100: 
                    {
                        sound_id = 15;  // Мягкий №1 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 101: 
                    {
                        sound_id = 16;  // Резкий - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 102: 
                    {
                        sound_id = 17;  // Мягкий №2 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 103: 
                    {
                        sound_id = 18;  // Громкий №1 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 104: 
                    {
                        sound_id = 19;  // Громкий №2 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 105: 
                    {
                        sound_id = 23;  // Громкий №3 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 106: 
                    {
                        sound_id = 29;  // Не громкий - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 107: 
                    {
                        sound_id = 30;  // Crystal - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 108: 
                    {
                        sound_id = 31;  // 99 Problems - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 109: 
                    {
                        sound_id = 32;  // Million - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 110: 
                    {
                        sound_id = 33;  // HDMI - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 111: 
                    {
                        sound_id = 34;  // HIGHEST - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 112: 
                    {
                        sound_id = 24;  // Сирена №1 - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 113: 
                    {
                        sound_id = 25;  // Сирена №2 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 114: 
                    {
                        sound_id = 41;  // Крякалка №1 - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 115: 
                    {
                        sound_id = 42;  // Спец.сигнал №1 - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 116: 
                    {
                        sound_id = 43;  // Крякалка №2 - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 117: 
                    {
                        sound_id = 44;  // Спец.сигнал №2 - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 118: 
                    {
                        sound_id = 20;  // Гнусный - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 119: 
                    {
                        sound_id = 21;  // Тяжелый - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 120: 
                    {
                        sound_id = 22;  // Затянутый - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 121: 
                    {
                        sound_id = 26;  // Звонкий №1 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 122: 
                    {
                        sound_id = 27;  // Писклявый - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 123: 
                    {
                        sound_id = 28;  // Звонкий №2 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 124: 
                    {
                        sound_id = 35;  // Merry Christmas - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 125: 
                    {
                        sound_id = 36;  // Колокол №1 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 126: 
                    {
                        sound_id = 37;  // Колокол №2 - бесплатный
                        currency_type = 0; // обычные рубли
                    }
                    case 127: 
                    {
                        sound_id = 38;  // Happy New Year - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 128: 
                    {
                        sound_id = 39;  // Sinatra - платный
                        currency_type = 1; // донат-рубли
                    }
                    case 129: 
                    {
                        sound_id = 40;  // Человек года - платный
                        currency_type = 1; // донат-рубли
                    }
                }

                if(currency_type == 0)
                {
                    if(GetPlayerMoney(playerid) >= sound_price)
                    {
                        SetPlayerData(playerid, P_MONEY, GetPlayerData(playerid, P_MONEY) - sound_price);
                        UpdatePlayerDatabaseInt(playerid, "money", GetPlayerData(playerid, P_MONEY));
                        GivePlayerMoney(playerid, -sound_price);
                        g_ownable_car[i][OC_HORN_ID] = sound_id;
                        
                        ShowNotificationSile(playerid, 3, 6, 0, 0, "Вы успешно купили новый звук гудка!", "");
                        SetVehicleHornSound(vehid, sound_id, 1);
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET horn_id = %d WHERE id = %d", sound_id, database_id);
                        mysql_query(mysql, query, false);
                        JSON_SetInt(tuning_response, "t", type);
                        JSON_SetInt(tuning_response, "s", 1);
                        JSON_SetInt(tuning_response, "h", sound_id);
                        JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
                        JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                        JSON_SetInt(tuning_response, "p", data_value);
                    }
                    else
                    {
                        ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                        JSON_SetInt(tuning_response, "t", type);
                        JSON_SetInt(tuning_response, "s", 0);
                        JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                    }
                }
                else if(currency_type == 1)
                {
                    if(GetPlayerDonateRub(playerid) >= hydraulics_price)
                    {
                        SetPlayerData(playerid, P_DONATE_RUB, GetPlayerData(playerid, P_DONATE_RUB) - hydraulics_price);
                        UpdatePlayerDatabaseInt(playerid, "rub", GetPlayerData(playerid, P_DONATE_RUB));
                        GivePlayerDonateRub(playerid, -hydraulics_price);
                        g_ownable_car[i][OC_HORN_ID] = sound_id;
                        SetVehicleHornSound(vehid, sound_id, 1);
                        ShowNotificationSile(playerid, 2, 6, 0, 0, "Вы успешно купили новый звук гудка!", "");
                        mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET horn_id = %d WHERE id = %d", sound_id, database_id);
                        mysql_query(mysql, query, false);
                        JSON_SetInt(tuning_response, "t", type);
                        JSON_SetInt(tuning_response, "s", 1);
                        JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                        JSON_SetInt(tuning_response, "h", sound_id);
                        JSON_SetInt(tuning_response, "d", GetPlayerDonateRub(playerid));
                        JSON_SetInt(tuning_response, "p", data_value);
                    }
                    else
                    {
                        ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно донат-рублей!", "OK");
                        JSON_SetInt(tuning_response, "t", type);
                        JSON_SetInt(tuning_response, "s", 0);
                        JSON_SetString(tuning_response, "m", "Недостаточно донат-рублей!");
                    }
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Неверный тип валюты!", "OK");
                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Неверный тип валюты!");
                }
            }
        }
        case 6:
        {
            new total_cost;
            new sql_id = GetOwnableCarData(GetVehicleData(GetPlayerVehicleID(playerid), V_ACTION_ID), OC_SQL_ID);
            
            JSON_GetInt(JSONObject, "j", total_cost);
            
            if(GetPlayerMoneyEx(playerid) >= total_cost)
            {
                GivePlayerMoneyEx(playerid, -total_cost);
                
                JSON_SetInt(tuning_response, "t", 6);
                JSON_SetInt(tuning_response, "s", 1);
                JSON_SetInt(tuning_response, "a", 1); // A_KEY_GET_STATUS_DIAGNOSTIC - статус актуален
                JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
            }
            else
            {
                JSON_SetInt(tuning_response, "t", 6);
                JSON_SetInt(tuning_response, "s", 0);
            }
        }
        case 26:
        {
            new vinyl_name[64];
            JSON_GetString(JSONObject, "v", vinyl_name, sizeof(vinyl_name));
            
            JSON_SetInt(tuning_response, "t", 26);
            JSON_SetInt(tuning_response, "s", 1);
            JSON_SetString(tuning_response, "v", vinyl_name);
        }
        case 3:
        {
            new vehid = GetPlayerVehicleID(playerid), database_id = GetOwnableCarData(GetVehicleData(vehid, V_ACTION_ID), OC_SQL_ID);
            new i = GetVehicleData(vehid, V_ACTION_ID);
            new query[256];
            JSON_SetInt(tuning_response, "t", type);
            JSON_SetInt(tuning_response, "s", 1);
            JSON_SetInt(tuning_response, "d", data_value);
            JSON_SetString(tuning_response, "v", vinyl);
				
            JSON_SetInt(tuning_response, "p", data_value);
			new vname[64];
            if(GetVinylNameById(data_value, vname, sizeof vname))
            {
                printf("Vinyl = %s", vname);
            }
			else
            {
                printf("Vinyl not found");
            }
			g_ownable_car[i][OC_VINYL_NAME] = vname;
            g_ownable_car[i][OC_VINYL_CURRENT] = data_value;
				
			SetVehicleVinylForPlayer(playerid, vehid, g_ownable_car[i][OC_VINYL_NAME]);
			mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET vinyl_name = '%e', vinyl_current = %d WHERE id = %d", vname, g_ownable_car[i][OC_VINYL_CURRENT], database_id);                  	    
            mysql_query(mysql, query, false);
            JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
            JSON_SetInt(tuning_response, "d", GetPlayerDonateRub(playerid));
        }
        case 5: // OPERATION_SET_STOCK
        {
            if(IsPlayerInAnyVehicle(playerid))
            {
                new vehid = GetPlayerVehicleID(playerid);
                new i = GetVehicleData(vehid, V_ACTION_ID);
                new database_id = GetOwnableCarData(GetVehicleData(vehid, V_ACTION_ID), OC_SQL_ID), query[256];

                if(operation == -1)
                {
                    SetVehicleVinylForPlayer(playerid, vehid, "remapvehicles");
                    g_ownable_car[i][OC_VINYL_CURRENT] = -1;
                    format(g_ownable_car[i][OC_VINYL_NAME], 64, "remapvehicles");
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET vinyl_name='remapvehicles', vinyl_current=-1 WHERE id=%d", database_id);
                    mysql_query(mysql, query, false);

                    JSON_SetInt(tuning_response, "t", type);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "m", selector_id);
                    JSON_SetInt(tuning_response, "mt", operation);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
                }
            }
            
            JSON_SetInt(tuning_response, "t", 5);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 18:
        {
            new sql_id = GetOwnableCarData(GetVehicleData(GetPlayerVehicleID(playerid), V_ACTION_ID), OC_SQL_ID);
            
            JSON_GetInt(JSONObject, "m", selector_id);
            JSON_GetInt(JSONObject, "mt", operation);
            
            //ResetTuningDetails(sql_id, selector_id);
            
            JSON_SetInt(tuning_response, "t", 18);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 23:
        {
            new color_val;
            sscanf(color_hex, "h", color_val);
            
            JSON_SetInt(tuning_response, "t", 23);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 27:
        {
            new car_preview_id;
            JSON_GetInt(JSONObject, "d", car_preview_id);
            
            SetPlayerCameraLookAt(playerid, 0.0, 0.0, 0.0);
            
            JSON_SetInt(tuning_response, "t", 27);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 19:
        {
            SetCameraBehindPlayer(playerid);
            TogglePlayerControllable(playerid, 1);
            
            JSON_SetInt(tuning_response, "t", 19);
            JSON_SetInt(tuning_response, "s", 1);
        }
        case 12:
        {
            new query[256], vehid = GetPlayerVehicleID(playerid), database_id = GetOwnableCarData(GetVehicleData(vehid, V_ACTION_ID), OC_SQL_ID);
            if(selector_id == 22)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 10.55749128919861);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET obclearance = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_OBCLEARANCE] = percent + 1;

                    mysql_query(mysql, query, false);
					new suspension = max(percent / 50.0, 0.2);
                    SetVehicleSuspensionForceForPlayer(playerid, vehid, suspension);
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(selector_id == 23)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 7.418118466898955);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET razclearance = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_RAZCLEARANCE] = percent + 1;

                    mysql_query(mysql, query, false);
					new suspension = min(max(percent / 100.0, 0.1), 0.9);
			        SetVehicleSuspensionBiasForPlayer(playerid, vehid, suspension);
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(selector_id == 24)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 3.557491289198606);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET departure_ft = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_DEPARTURE_FT] = percent + 1;

                    mysql_query(mysql, query, false);
					SetVehicleWheelDepartureFP(playerid, vehid, (g_ownable_car[index][OC_DEPARTURE_FT] / 400.0) + -0.125, (g_ownable_car[index][OC_DEPARTURE_RR] / 400.0) + -0.125);
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(selector_id == 25)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 3.557491289198606);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET departure_rr = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_DEPARTURE_RR] = percent + 1;

                    mysql_query(mysql, query, false);
					SetVehicleWheelDepartureFP(playerid, vehid, (g_ownable_car[index][OC_DEPARTURE_FT] / 400.0) + -0.125, (g_ownable_car[index][OC_DEPARTURE_RR] / 400.0) + -0.125);
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(selector_id == 26)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.5574912891986066);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET collapse_ft = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_COLLAPSE_FT] = percent + 1;

                    mysql_query(mysql, query, false);
					SetVehicleCollapseForPlayer(playerid, vehid, (g_ownable_car[index][OC_COLLAPSE_FT] / -200.0) , (g_ownable_car[index][OC_COLLAPSE_RR] / -200.0) );
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoneyEx(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoneyEx(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(selector_id == 27)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.5574912891986066);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET collapse_rr = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_COLLAPSE_RR] = percent + 1;

                    mysql_query(mysql, query, false);
					SetVehicleCollapseForPlayer(playerid, vehid, (g_ownable_car[index][OC_COLLAPSE_FT] / -200.0) , (g_ownable_car[index][OC_COLLAPSE_RR] / -200.0) );
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(selector_id == 28)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.696864111498258);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET width_ft = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_WIDTH_FT] = percent + 1;

                    mysql_query(mysql, query, false);
					SetVehicleWheelAddForPlayer(playerid, vehid, (g_ownable_car[index][OC_WIDTH_FT] / 80.0) + 0.5 , (g_ownable_car[index][OC_WIDTH_RR] / 80.0) + 0.5);
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(selector_id == 29)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 5.696864111498258);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET width_rr = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_WIDTH_RR] = percent + 1;

                    mysql_query(mysql, query, false);
					SetVehicleWheelAddForPlayer(playerid, vehid, (g_ownable_car[index][OC_WIDTH_FT] / 80.0) + 0.5 , (g_ownable_car[index][OC_WIDTH_RR] / 80.0) + 0.5);
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
            else if(selector_id == 30)
            {
                new percent;
                JSON_GetInt(JSONObject, "d", percent);
                new hydraulics_price = GetFirmwarePrice(GetPlayerVehicleID(playerid), 8.393728222996516);
                if(GetPlayerMoney(playerid) >= hydraulics_price)
                {
                    GivePlayerMoneyEx(playerid, - hydraulics_price);
                    mysql_format(mysql, query, sizeof query, "UPDATE ownable_cars SET wheel_radius = %d WHERE id = %d", percent+1, database_id);
					new index = GetVehicleData(vehid, V_ACTION_ID);
					g_ownable_car[index][OC_WHEEL_RADIUS] = percent + 1;

                    mysql_query(mysql, query, false);
					SetVehicleWheelRadiusFP(playerid, vehid, (g_ownable_car[index][OC_WHEEL_RADIUS]  / 250.0) + 0.7);
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 1);
                    JSON_SetInt(tuning_response, "p", data_value);
                    JSON_SetInt(tuning_response, "r", GetPlayerMoney(playerid));
					JSON_SetInt(tuning_response, "m", GetPlayerMoney(playerid));
                }
                else
                {
                    ShowNotificationSile(playerid, 3, 6, 0, 0, "Недостаточно средств!", "OK");
                    JSON_SetInt(tuning_response, "t", 12);
                    JSON_SetInt(tuning_response, "s", 0);
                    JSON_SetString(tuning_response, "m", "Недостаточно средств!");
                }
            }
        }
        case 28:
        {
            JSON_SetInt(tuning_response, "t", 28);
            JSON_SetInt(tuning_response, "s", 1);
        }
    }
    SendPacketToClient(playerid, 28, tuning_response);
    JSON_Cleanup(tuning_response);
}