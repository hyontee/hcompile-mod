#if defined _vigsa_market_module_included
    #endinput
#endif
#define _vigsa_market_module_included

// Active VIGSA marketplace module.
// The former incompatible implementation is stored in legacy/market_legacy_unused.inc.

#define MARKET_SOURCE_ACTIVE_BASE     (1000)
#define MARKET_SOURCE_ACCESSORY_BASE  (2000)
#define MARKET_SOURCE_ACCESSORY_SLOTS (10)
#define MARKET_SOURCE_SKIN_BASE       (3000)
#define MARKET_SOURCE_SKIN_SLOTS      (100)
// Same fallback used by Inventory.inc when a player has no valid skin on load.
#define MARKET_DEFAULT_SKIN           (60)

// Canonical accessory inventory ID -> object model. The original mod stores
// some accessories as canonical IDs and some donate accessories as raw models.
new const g_MarketAccessoryItemModels[][2] =
{
    {1, 907}, {2, 908}, {3, 909}, {4, 912}, {5, 916}, {6, 926},
    {7, 918}, {8, 910}, {9, 914}, {10, 919}, {11, 921}, {12, 923},
    {13, 915}, {14, 917}, {15, 922}, {16, 924}, {17, 925}, {18, 911},
    {19, 913}, {20, 920}, {30, 985}, {31, 986}, {32, 990}, {33, 994},
    {34, 995}, {35, 967}, {36, 968}, {37, 969}, {38, 979}, {39, 980},
    {40, 981}, {41, 982}, {42, 984}, {43, 987}, {44, 988}, {45, 989},
    {46, 992}, {47, 993}, {48, 970}, {49, 971}, {50, 972}, {51, 973},
    {52, 974}, {53, 975}, {54, 976}, {55, 977}, {56, 978}, {57, 983},
    {60, 1194}, {61, 1195}, {62, 1196}, {63, 1197}, {64, 1198}, {65, 1199},
    {66, 2646}, {67, 1716}, {68, 1699}, {69, 1701}, {70, 1702}, {71, 1703},
    {72, 1704}, {73, 1705}, {74, 1706}, {75, 1707}, {76, 1708}, {77, 1709},
    {78, 1710}, {79, 1711}, {84, 1720}, {85, 1721}, {86, 1722}, {87, 1723},
    {88, 1724}, {89, 1725}, {90, 1726}, {91, 1747}, {92, 1748}, {93, 1749},
    {94, 1750}, {95, 1751}, {96, 1727}, {97, 1728}, {98, 1729}, {99, 1730},
    {100, 1731}, {101, 1732}, {102, 1743}, {103, 1744}, {104, 1745}, {105, 1746},
    {106, 1733}, {107, 1734}, {108, 1735}, {109, 1736}, {110, 1737}, {111, 1783},
    {112, 1779}, {113, 1778}, {114, 1777}, {115, 1776}, {135, 15134}, {136, 15135},
    {137, 15136}, {138, 15137}, {139, 15138}, {140, 15139}, {141, 15140}, {142, 15141},
    {143, 15142}, {144, 15143}, {145, 15144}, {146, 15145}, {147, 15146}, {148, 15147},
    {149, 15148}, {150, 15149}, {151, 15152}, {152, 15153}, {153, 15154}, {154, 15155},
    {155, 15150}, {156, 15160}, {157, 15161}, {158, 15159}, {159, 15151}, {160, 15157},
    {161, 15158}, {162, 1212}, {163, 18226}, {164, 18227}, {165, 18228}, {166, 18229},
    {167, 18230}, {168, 18231}, {169, 18232}, {170, 18233}, {171, 18234}, {172, 18235},
    {173, 18236}, {174, 18237}, {175, 18238}, {176, 18239}, {177, 18240}, {178, 18241},
    {179, 18242}, {180, 18243}, {181, 18244}, {182, 18245}, {183, 18246}, {184, 18247},
    {185, 18248}, {186, 18249}, {187, 18250}, {188, 18251}, {189, 18252}, {190, 18253},
    {191, 18254}, {192, 18255}, {193, 18256}, {194, 18257}, {195, 18258}, {196, 18259},
    {197, 18260}, {198, 18261}, {199, 18262}, {200, 18263}, {201, 18264}, {202, 18265},
    {203, 18266}, {204, 18267}, {205, 18268}, {206, 18269}, {207, 18270}, {208, 18271},
    {209, 18272}, {210, 18273}, {211, 18274}, {212, 18275}, {213, 18276}, {214, 18277},
    {215, 18278}, {216, 18279}, {217, 18282}, {218, 18283}, {219, 18284}, {220, 18285},
    {221, 18286}, {222, 18287}, {223, 18288}, {224, 18289}, {225, 18290}, {226, 18291},
    {227, 18292}, {228, 18293}, {229, 18294}, {230, 18295}, {231, 18296}, {232, 18298},
    {233, 18300}, {234, 18301}, {235, 18302}, {236, 18306}, {237, 18307}, {238, 18310},
    {239, 18312}, {240, 18313}, {241, 18318}, {242, 18315}, {243, 18319}, {244, 18322},
    {245, 18328}, {246, 18329}, {247, 18330}, {248, 18331}, {249, 18332}, {250, 18333},
    {251, 18334}, {252, 18335}, {253, 18336}, {254, 18337}, {255, 18338}, {256, 18339},
    {257, 18340}, {258, 18341}, {259, 18342}, {260, 18343}, {261, 18344}, {262, 18345},
    {263, 18346}, {264, 18347}, {265, 18348}, {266, 18349}, {267, 18350}, {268, 18351},
    {269, 18352}, {270, 18353}, {271, 18354}, {272, 18355}, {273, 18356}, {274, 18357},
    {275, 18358}, {276, 18366}, {277, 18364}, {278, 18365}, {279, 18367}, {280, 18368},
    {281, 18369}, {282, 18370}, {283, 18371}, {284, 18372}, {285, 18373}, {286, 18374},
    {287, 18375}, {288, 18376}, {289, 18377}, {290, 18378}, {291, 18379}, {292, 18380},
    {293, 18381}, {294, 18382}, {295, 18383}, {296, 18384}, {297, 18385}, {298, 18386},
    {299, 18387}, {300, 18388}, {301, 18389}, {302, 18390}, {303, 18391}, {304, 18392},
    {305, 18393}, {306, 18394}, {307, 18395}, {308, 18396}, {309, 18397}, {310, 18398},
    {311, 18399}, {312, 18400}, {313, 18401}, {314, 18402}, {315, 18403}, {316, 18404},
    {317, 18405}, {318, 18406}, {319, 18407}, {320, 18408}, {321, 18409}, {322, 18410},
    {323, 18411}, {324, 18412}, {325, 18413}, {326, 18414}, {327, 18415}, {328, 17983},
    {329, 17984}, {330, 17985}, {331, 17986}, {332, 17987}, {333, 17988}, {334, 17989},
    {335, 17990}, {336, 17991}, {337, 17992}, {338, 17993}, {339, 17994}, {340, 17995},
    {341, 17996}, {342, 17997}, {343, 17998}, {344, 17999}, {345, 13628}, {346, 1210},
    {347, 18497}, {348, 18498}, {349, 18499}, {350, 18500}, {351, 18501}, {352, 18502},
    {353, 18503}, {354, 18504}, {355, 18505}, {356, 18506}, {357, 18507}, {358, 18508},
    {359, 18509}, {360, 18510}, {361, 18511}, {362, 18512}, {363, 18513}, {364, 18514},
    {365, 18515}, {366, 18516}, {367, 18517}, {368, 18518}, {369, 18519}, {370, 18520},
    {371, 18521}, {372, 18522}, {373, 18523}, {374, 18524}, {375, 18525}, {376, 18526},
    {377, 18527}, {378, 18528}, {379, 18529}, {380, 18530}, {381, 18567}, {382, 18568},
    {383, 18569}, {384, 18570}, {385, 18571}, {386, 18572}, {387, 18573}, {388, 18574},
    {389, 18575}, {390, 18576}, {391, 7327}, {392, 7328}, {393, 7329}, {394, 7330},
    {395, 7331}, {396, 7332}, {397, 7333}, {398, 7334}, {399, 7335}, {400, 7336},
    {401, 7337}, {402, 7338}, {403, 7339}, {404, 7340}, {405, 7341}, {406, 7342},
    {407, 7343}, {408, 7344}, {409, 7345}, {410, 7346}, {411, 7347}, {412, 7348},
    {413, 7349}, {414, 7350}, {415, 7351}, {416, 7352}, {417, 7353}, {418, 7354},
    {419, 7355}, {420, 7356}, {421, 7357}, {422, 7358}, {423, 7359}, {424, 7360},
    {425, 7361}, {426, 7362}, {427, 7363}, {428, 7364}, {429, 7365}, {430, 7366},
    {431, 7367}, {432, 7368}, {433, 7369}, {434, 7370}, {435, 7371}, {436, 7372},
    {437, 7373}, {438, 7374}, {439, 7375}, {440, 7376}, {441, 7377}, {442, 7378},
    {443, 7379}, {444, 7380}, {445, 7381}, {446, 7382}, {447, 7383}, {448, 7384},
    {449, 7385}, {450, 7386}, {451, 7387}, {452, 7388}, {453, 7389}, {454, 7390},
    {455, 7391}, {456, 7392}, {457, 7393}, {458, 7394}, {459, 7395}, {460, 7396},
    {461, 7397}, {463, 5371}, {464, 5372}, {465, 5373}, {466, 5374}, {467, 5375},
    {468, 5376}, {469, 5377}, {470, 5378}, {471, 5379}, {472, 5380}, {473, 5381},
    {474, 5382}, {475, 5383}, {476, 5384}, {477, 4231}, {478, 4242}, {479, 4243},
    {480, 4241}, {481, 4240}, {482, 4239}, {483, 4238}, {484, 4237}, {485, 4232},
    {486, 4236}, {487, 4234}, {488, 4233}, {489, 4235}, {490, 4196}, {491, 4197},
    {492, 4198}, {493, 4199}, {494, 4200}, {495, 4201}, {496, 4202}, {497, 4203},
    {498, 4204}, {499, 4205}, {500, 4206}, {501, 4207}, {502, 4208}, {503, 13908},
    {504, 13879}, {505, 13880}, {506, 13881}, {507, 13882}, {508, 13883}, {509, 14574},
    {510, 13884}, {511, 14575}, {512, 13885}, {513, 14589}, {514, 14590}, {515, 14591},
    {516, 14592}, {517, 14593}, {518, 14594}, {519, 14595}, {520, 14596}, {521, 14597},
    {522, 14598}, {523, 14599}, {524, 14600}, {525, 14601}, {526, 14602}, {527, 14603},
    {528, 14604}, {529, 4158}, {530, 4159}, {531, 4160}, {532, 4161}, {533, 4162},
    {534, 4163}, {535, 4164}, {536, 4165}, {537, 4166}, {538, 13761}, {539, 13762},
    {540, 13746}, {541, 13747}, {542, 13748}, {543, 13749}, {544, 13750}, {545, 13751},
    {546, 13752}, {547, 13753}, {548, 13754}, {549, 13755}, {550, 13735}, {551, 13736},
    {552, 13737}, {553, 13738}, {554, 13739}, {555, 13740}, {556, 13741}, {557, 13742},
    {558, 13743}, {559, 13744}, {560, 13745}, {561, 13266}, {562, 13897}, {563, 13804},
    {564, 13805}, {565, 13806}, {566, 13807}, {567, 13808}, {568, 13809}, {569, 13810},
    {570, 13811}, {571, 13812}, {572, 13813}, {573, 13814}, {574, 13815}, {575, 13816},
    {576, 13801}, {577, 13802}, {578, 13803}, {579, 11919}, {580, 11920}, {581, 11921},
    {582, 11922}, {583, 11923}, {584, 11924}, {585, 11925}, {586, 1377}, {587, 1378},
    {588, 1379}, {589, 1380}, {590, 1381}, {591, 1382}, {592, 1383}, {593, 1384},
    {594, 1385}, {595, 1386}, {596, 1387}, {597, 1388}, {598, 1389}, {599, 1390},
    {600, 9794}, {601, 9795}, {602, 9796}, {603, 9797}, {604, 9798}, {605, 9799},
    {606, 9800}, {607, 9801}, {608, 9802}, {609, 9803}, {610, 9804}, {611, 9805},
    {612, 9806}, {613, 4103}, {614, 4112}, {615, 4105}, {616, 4109}, {617, 4110},
    {618, 4098}, {619, 4097}, {620, 4102}, {621, 4096}, {622, 4119}, {623, 4100},
    {624, 4101}, {625, 4107}, {626, 4108}, {627, 4099}, {628, 4104}, {629, 4106},
    {630, 4111}, {631, 4085}, {632, 4084}, {633, 4087}, {634, 4089}, {635, 4086},
    {636, 4088}, {637, 4094}, {638, 4090}, {639, 4092}, {640, 4091}, {641, 4093},
    {642, 4117}, {643, 4116}, {644, 4114}, {645, 4113}, {646, 4115}, {647, 9376},
    {648, 9377}, {649, 9378}, {650, 9379}, {651, 9380}, {652, 9381}, {653, 9382},
    {654, 9383}, {655, 9384}, {656, 9385}, {657, 9386}, {658, 9387}, {659, 9388},
    {660, 9824}, {661, 9825}, {662, 9826}, {663, 9827}, {664, 9828}, {665, 19211},
    {666, 19212}, {667, 19213}, {668, 6169}, {669, 6170}, {670, 6171}, {671, 6172},
    {672, 6173}, {673, 6174}, {674, 6175}, {675, 6176}, {676, 6177}, {677, 6178},
    {678, 6179}, {679, 6180}, {680, 6181}, {681, 786}, {682, 787}, {683, 788},
    {684, 789}, {685, 790}, {686, 662}, {687, 663}, {688, 9406}, {689, 9407},
    {690, 9408}, {691, 9409}, {692, 9410}, {693, 15446}, {694, 15447}, {695, 15448},
    {696, 15449}, {697, 1094}, {698, 1095}, {699, 1205}, {700, 1206}, {701, 781},
    {702, 780}, {703, 1231}, {704, 1230}, {705, 4359}, {706, 4360}, {707, 4361},
    {708, 16045}, {709, 16055}, {710, 4784}, {711, 4785}, {712, 4786}, {713, 4787},
    {714, 4788}, {715, 4789}, {716, 4790}, {717, 4791}, {718, 4792}, {719, 4793},
    {720, 4794}, {721, 4795}, {722, 14672}, {723, 14671}, {724, 1328}, {725, 1329},
    {726, 1330}, {727, 3154}, {728, 3153}, {729, 1997}, {730, 1991}, {731, 2001},
    {732, 1984}, {733, 1992}, {734, 2005}, {735, 1986}, {736, 2006}, {737, 1982},
    {738, 1998}, {739, 1987}, {740, 2003}, {741, 1999}, {742, 1980}, {743, 1995},
    {744, 1996}, {745, 1979}, {746, 1990}, {747, 1985}, {748, 2007}, {749, 1978},
    {750, 1981}, {751, 1993}, {752, 1983}, {753, 2002}, {754, 2008}, {755, 32423},
    {756, 32405}, {757, 1988}, {758, 2004}, {759, 1989}, {760, 9960}, {761, 5283},
    {762, 5286}, {763, 9966}, {764, 5275}, {765, 5284}, {766, 5287}, {767, 5291},
    {768, 10001}, {769, 5289}, {770, 9972}, {771, 5826}, {772, 5828}, {773, 9999},
    {774, 5285}, {775, 9990}, {776, 9975}, {777, 9984}, {778, 5822}, {779, 5283},
    {780, 2649}, {781, 5280}, {782, 9994}, {783, 9998}, {784, 9993}, {785, 10002},
    {786, 5828}, {787, 5281}, {788, 5273}, {789, 9992}, {790, 9969}, {791, 5830},
    {792, 10000}, {793, 9964}, {794, 9974}, {795, 9997}, {796, 5274}, {797, 5270},
    {798, 5272}, {799, 5292}, {800, 5278}, {801, 5288}, {802, 5271}, {803, 9980},
    {804, 9973}, {805, 9973}, {806, 9973}, {807, 9973}, {808, 9973}, {809, 9973},
    {810, 9973}, {811, 9973}, {812, 9973}, {813, 9973}, {814, 9973}, {815, 9973},
    {816, 9973}, {817, 9973}, {818, 9973}, {819, 9973}, {820, 9973}, {821, 9973},
    {822, 9973}, {823, 9973}, {824, 9973}, {825, 9973}, {826, 9973}, {827, 9973},
    {828, 9973}, {829, 9973}, {830, 9973}, {831, 9973}, {832, 9973}, {833, 9973},
    {834, 9973}, {835, 9973}, {836, 9973}, {837, 9973}, {838, 9973}, {839, 9973},
    {840, 9973}, {841, 9973}, {842, 9973}, {843, 9973}, {844, 9973}, {845, 9973},
    {846, 9973}, {847, 9973}, {848, 9973}, {849, 9973}, {850, 9973}, {851, 9973},
    {852, 9973}, {853, 9973}, {854, 9973}, {855, 9973}, {856, 9973}, {857, 9973},
    {858, 9973}, {859, 9973}, {860, 9973}, {861, 9973}, {862, 9973}, {863, 9973},
    {864, 9973}, {865, 9973}, {866, 9973}, {867, 9973}, {868, 9973}, {869, 9973},
    {870, 9973}, {871, 9973}, {872, 9973}, {873, 9973}, {874, 9973}, {875, 9973},
    {876, 9973}, {877, 16026}, {878, 16027}, {879, 16028}, {880, 16029}, {881, 16030},
    {882, 16031}, {883, 16032}, {884, 16033}, {885, 16034}, {886, 16035}, {887, 6101},
    {888, 6102}, {889, 6103}, {890, 1652}, {891, 1651}, {892, 1653}, {893, 9973},
    {894, 9973}, {895, 9973}, {896, 9973}, {897, 9973}, {898, 9973}, {899, 9973},
    {900, 9973}, {901, 9973}, {902, 9973}, {903, 9973}, {904, 9973}, {905, 12302},
    {906, 12308}, {907, 12304}, {908, 12306}, {909, 12303}, {910, 12301}, {911, 12307},
    {912, 791}, {913, 792}, {914, 2655}, {915, 2656}, {916, 2657}, {917, 676},
    {918, 677}, {919, 4859}, {920, 4862}, {921, 1975}, {922, 4861}, {923, 4863},
    {924, 4864}, {925, 4860}, {926, 4550}, {927, 4372}, {928, 4542}, {929, 4543},
    {930, 10493}, {931, 10494}, {932, 7712}, {933, 4544}, {934, 4548}, {935, 4545},
    {936, 7727}, {937, 7729}, {938, 4546}, {939, 10492}, {940, 4547}, {941, 4549},
    {942, 14641}, {943, 10488}, {944, 14647}, {945, 14643}, {946, 4702}, {947, 14645},
    {948, 14790}, {949, 14791}, {950, 14648}, {951, 14644}, {952, 14646}, {953, 4699},
    {954, 4700}, {955, 14630}, {956, 14642}, {957, 4701}, {958, 11292}, {959, 15056},
    {960, 14266}, {961, 14265}, {962, 11328}, {963, 15057}, {964, 10916}, {965, 11304},
    {966, 15055}, {967, 15058}, {968, 17510}, {969, 17509}, {970, 16699}, {971, 15630},
    {972, 15631}, {973, 15632}, {974, 15633}, {975, 15634}, {976, 15626}, {977, 15627},
    {978, 15635}, {979, 15636}, {980, 15638}, {981, 15628}, {982, 15629}, {983, 31949},
    {984, 31963}, {985, 31962}, {986, 31967}, {987, 31970}, {988, 31969}, {989, 31966},
    {990, 31965}, {991, 31961}, {992, 31964}, {993, 32154}, {994, 32131}, {995, 32132},
    {996, 32133}, {997, 32134}, {998, 32135}, {999, 32129}, {1000, 32136}, {1001, 32130},
    {1002, 32137}, {1003, 32138}, {1004, 32139}, {1005, 32144}, {1006, 32154}, {1007, 32404},
    {1008, 32171}, {1009, 100006}, {1010, 100007}, {1011, 9973}, {1012, 9973}, {1013, 32414},
    {1014, 32415}, {1015, 32416}, {1016, 32417}, {1017, 32418}, {1018, 32419}, {1019, 32420},
    {1020, 32421}, {1021, 100035}, {1022, 100034}, {1023, 100065}, {1024, 100066}, {1025, 100067},
    {1026, 100068}, {1027, 100069}, {1028, 100070}, {1029, 100071}, {1030, 100072}, {1031, 100073},
    {1032, 100074}, {1033, 100075}, {1034, 100076}, {1035, 9973}, {1036, 9973}, {1037, 9973},
    {1038, 9974}, {1039, 0}, {1040, 0}, {1041, 0}, {1042, 0}, {1043, 100077},
    {1044, 100078}, {1045, 100079}, {1046, 100101}, {1047, 100102}, {1048, 100103}, {1049, 100104},
    {1050, 100105}, {1051, 100106}, {1052, 100107}, {1053, 100108}, {1054, 100109}, {1055, 100110},
    {1056, 100111}, {1057, 100112}, {1058, 100113}, {1059, 9973}, {1060, 9973}, {1061, 9974},
    {1062, 100162}, {1063, 100163}, {1064, 100164}, {1065, 100165}, {1066, 100166}, {1067, 100167},
    {1068, 100170}, {1069, 100171}, {1070, 9973}, {1071, 9973}, {1072, 9974}, {1073, 100169},
    {1074, 9974}, {1075, 100189}, {1076, 9973}, {1085, 9974}
};

stock Market_GetAccessoryModelByCanonicalItem(item_id)
{
    for(new i = 0; i < sizeof(g_MarketAccessoryItemModels); i++)
    {
        if(g_MarketAccessoryItemModels[i][0] == item_id)
            return g_MarketAccessoryItemModels[i][1];
    }
    return -1;
}

stock Market_GetAccessoryCanonicalItemByStoredId(stored_item_id)
{
    if(stored_item_id <= 0 || stored_item_id == 58 || stored_item_id == 134) return -1;

    if(Market_GetAccessoryModelByCanonicalItem(stored_item_id) > 0)
        return stored_item_id;

    // Legacy donate path stores the object model directly in item_id.
    for(new i = 0; i < sizeof(g_MarketAccessoryItemModels); i++)
    {
        if(g_MarketAccessoryItemModels[i][1] == stored_item_id)
            return g_MarketAccessoryItemModels[i][0];
    }
    return -1;
}

stock Market_GetAccessoryModelByStoredId(stored_item_id)
{
    new model_id = Market_GetAccessoryModelByCanonicalItem(stored_item_id);
    if(model_id > 0) return model_id;

    if(Market_GetAccessoryCanonicalItemByStoredId(stored_item_id) > 0)
        return stored_item_id;

    return -1;
}

new g_MarketAccessoryItem[MAX_PLAYERS][MARKET_SOURCE_ACCESSORY_SLOTS];
new g_MarketAccessoryModel[MAX_PLAYERS][MARKET_SOURCE_ACCESSORY_SLOTS];
new g_MarketAccessoryBone[MAX_PLAYERS][MARKET_SOURCE_ACCESSORY_SLOTS];

stock Market_IsAccessoryInventoryItem(item_id)
{
    return Market_GetAccessoryCanonicalItemByStoredId(item_id) > 0;
}

stock Market_ClearAccessoryCache(playerid)
{
    for(new i = 0; i < MARKET_SOURCE_ACCESSORY_SLOTS; i++)
    {
        g_MarketAccessoryItem[playerid][i] = 0;
        g_MarketAccessoryModel[playerid][i] = 0;
        g_MarketAccessoryBone[playerid][i] = 0;
    }
    return 1;
}

stock Market_RefreshAccessoryCache(playerid)
{
    Market_ClearAccessoryCache(playerid);
    if(!IsPlayerLogged(playerid)) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof(query),
        "SELECT `slot`,`modelid`,`bone` FROM `accessories` WHERE `id`=%d ORDER BY `slot` ASC",
        GetPlayerAccountID(playerid));

    new Cache:result = mysql_query(mysql, query, true);
    new rows = cache_num_rows();

    for(new i = 0; i < rows; i++)
    {
        new slot = cache_get_field_content_int(i, "slot", mysql);
        new model_id = cache_get_field_content_int(i, "modelid", mysql);
        new bone = cache_get_field_content_int(i, "bone", mysql);
        if(slot < 0 || slot >= MARKET_SOURCE_ACCESSORY_SLOTS) continue;

        new item_id = Accessory_GetItemIdByModel(model_id);
        if(item_id <= 0) continue;

        g_MarketAccessoryItem[playerid][slot] = item_id;
        g_MarketAccessoryModel[playerid][slot] = model_id;
        g_MarketAccessoryBone[playerid][slot] = bone;
    }

    cache_delete(result);
    return 1;
}

stock Market_IsAccessorySource(source_id)
{
    return source_id >= MARKET_SOURCE_ACCESSORY_BASE && source_id < (MARKET_SOURCE_ACCESSORY_BASE + MARKET_SOURCE_ACCESSORY_SLOTS);
}

// -----------------------------------------------------------------------
// Owned-but-not-equipped skins live in the `inventory_skins` table and are
// otherwise only ever loaded into memory by /myskins (PlayerSkinsData in
// inventory_skin.pwn). The marketplace never queried that table, so any
// skin except the currently worn one was invisible to Market_CanSellSource -
// hence "Инвентарь" shows owned skins but the marketplace claims there are
// none. This cache is queried independently (own SQL, no dependency on
// inventory_skin.pwn's load order) the same way accessories are.
// -----------------------------------------------------------------------
new g_MarketSkinDbId[MAX_PLAYERS][MARKET_SOURCE_SKIN_SLOTS];
new g_MarketSkinGameId[MAX_PLAYERS][MARKET_SOURCE_SKIN_SLOTS];
new g_MarketSkinInUse[MAX_PLAYERS][MARKET_SOURCE_SKIN_SLOTS];
new g_MarketSkinCount[MAX_PLAYERS];

stock Market_ClearSkinCache(playerid)
{
    for(new i = 0; i < MARKET_SOURCE_SKIN_SLOTS; i++)
    {
        g_MarketSkinDbId[playerid][i] = 0;
        g_MarketSkinGameId[playerid][i] = 0;
        g_MarketSkinInUse[playerid][i] = 0;
    }
    g_MarketSkinCount[playerid] = 0;
    return 1;
}

stock Market_RefreshSkinCache(playerid)
{
    Market_ClearSkinCache(playerid);
    if(!IsPlayerLogged(playerid)) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof(query),
        "SELECT `id`,`game_id`,`use_skin` FROM `inventory_skins` WHERE `owner_skin`=%d ORDER BY `use_skin` DESC, `id` ASC",
        GetPlayerAccountID(playerid));

    new Cache:result = mysql_query(mysql, query, true);
    new rows = cache_num_rows();

    for(new i = 0; i < rows && i < MARKET_SOURCE_SKIN_SLOTS; i++)
    {
        g_MarketSkinDbId[playerid][i] = cache_get_field_content_int(i, "id", mysql);
        g_MarketSkinGameId[playerid][i] = cache_get_field_content_int(i, "game_id", mysql);
        g_MarketSkinInUse[playerid][i] = cache_get_field_content_int(i, "use_skin", mysql);
    }
    g_MarketSkinCount[playerid] = (rows < MARKET_SOURCE_SKIN_SLOTS) ? rows : MARKET_SOURCE_SKIN_SLOTS;

    cache_delete(result);
    return 1;
}

stock Market_IsSkinSource(source_id)
{
    return source_id >= MARKET_SOURCE_SKIN_BASE && source_id < (MARKET_SOURCE_SKIN_BASE + MARKET_SOURCE_SKIN_SLOTS);
}

stock Market_MakeSkinSource(skin_slot)
{
    return MARKET_SOURCE_SKIN_BASE + skin_slot;
}

stock Market_GetSkinSlotFromSource(source_id)
{
    if(!Market_IsSkinSource(source_id)) return -1;
    return source_id - MARKET_SOURCE_SKIN_BASE;
}

stock Market_MakeAccessorySource(accessory_slot)
{
    return MARKET_SOURCE_ACCESSORY_BASE + accessory_slot;
}

stock Market_GetAccessorySlotFromSource(source_id)
{
    if(!Market_IsAccessorySource(source_id)) return -1;
    return source_id - MARKET_SOURCE_ACCESSORY_BASE;
}

stock Market_GetAccessoryModelFromSource(playerid, source_id)
{
    if(Market_IsAccessorySource(source_id))
    {
        new accessory_slot = Market_GetAccessorySlotFromSource(source_id);
        return g_MarketAccessoryModel[playerid][accessory_slot];
    }

    if(source_id < 0 || source_id >= MAX_INVENTORY_SLOTS) return -1;
    return Market_GetAccessoryModelByStoredId(g_PlayerInventory[playerid][source_id][inv_itemId]);
}

stock Market_IsSingleInventoryEntity(item_id)
{
    switch(item_id)
    {
        // item_count stores metadata for these items, not a stack size.
        case 58, 59, 81, 82, 83, 134: return 1;
    }
    return Market_GetAccessoryCanonicalItemByStoredId(item_id) > 0;
}

stock Market_IsSellableInventoryItem(item_id)
{
    if(item_id == 58 || item_id == 134) return 1;
    return Market_IsAccessoryInventoryItem(item_id);
}

stock Market_IsActiveSource(source_id)
{
    return source_id >= MARKET_SOURCE_ACTIVE_BASE && source_id < (MARKET_SOURCE_ACTIVE_BASE + MAX_ACTIVE_SLOTS);
}

stock Market_MakeActiveSource(active_slot)
{
    return MARKET_SOURCE_ACTIVE_BASE + active_slot;
}

stock Market_GetActiveSlotFromSource(source_id)
{
    if(!Market_IsActiveSource(source_id)) return -1;
    return source_id - MARKET_SOURCE_ACTIVE_BASE;
}

stock Market_GetSourceItemId(playerid, source_id)
{
    if(Market_IsAccessorySource(source_id))
    {
        new accessory_slot = Market_GetAccessorySlotFromSource(source_id);
        return g_MarketAccessoryItem[playerid][accessory_slot];
    }

    if(Market_IsSkinSource(source_id))
    {
        new skin_slot = Market_GetSkinSlotFromSource(source_id);
        if(skin_slot < 0 || skin_slot >= g_MarketSkinCount[playerid]) return 0;
        if(g_MarketSkinGameId[playerid][skin_slot] <= 0) return 0;
        return 134;
    }

    if(Market_IsActiveSource(source_id))
    {
        new active_slot = Market_GetActiveSlotFromSource(source_id);
        new item_id = g_PlayerActiveSlots[playerid][active_slot][inv_itemId];

        if(active_slot == SIM_SLOT && item_id != 58 && GetPlayerData(playerid, P_PHONE) > 0)
            return 58;

        // The active-slot cache for SKIN_SLOT can lag behind the player's real
        // skin - donate-bought skins (BuyPlayerSkin) change P_SKIN/the player's
        // model directly without updating g_PlayerActiveSlots. Trust the live
        // skin whenever one exists instead of only falling back when the cache
        // isn't already 134, otherwise a stale cached skin keeps being reported
        // and a freshly-bought donate skin never appears as sellable.
        if(active_slot == SKIN_SLOT)
        {
            new skin_model = GetPlayerData(playerid, P_SKIN);
            if(skin_model <= 0) skin_model = GetPlayerSkin(playerid);
            if(skin_model > 0) return 134;
        }

        return item_id;
    }

    if(source_id < 0 || source_id >= MAX_INVENTORY_SLOTS) return 0;

    new stored_item_id = g_PlayerInventory[playerid][source_id][inv_itemId];
    new accessory_item_id = Market_GetAccessoryCanonicalItemByStoredId(stored_item_id);
    if(accessory_item_id > 0) return accessory_item_id;
    return stored_item_id;
}

stock Market_GetSourceItemCount(playerid, source_id)
{
    if(Market_IsAccessorySource(source_id)) return 1;

    if(Market_IsSkinSource(source_id))
    {
        new skin_slot = Market_GetSkinSlotFromSource(source_id);
        if(skin_slot < 0 || skin_slot >= g_MarketSkinCount[playerid]) return 0;
        return g_MarketSkinGameId[playerid][skin_slot];
    }

    if(Market_IsActiveSource(source_id))
    {
        new active_slot = Market_GetActiveSlotFromSource(source_id);
        new item_id = Market_GetSourceItemId(playerid, source_id);
        new stored_count = g_PlayerActiveSlots[playerid][active_slot][inv_itemCount];

        if(item_id == 58 && stored_count <= 0) return GetPlayerData(playerid, P_PHONE);
        if(item_id == 134)
        {
            // Same staleness problem as Market_GetSourceItemId above: a
            // donate-bought skin changes P_SKIN without updating the cached
            // active-slot count, so the cache can hold an old skin model
            // even though it's non-zero. Always trust the live skin first.
            new live_skin_model = GetPlayerData(playerid, P_SKIN);
            if(live_skin_model <= 0) live_skin_model = GetPlayerSkin(playerid);
            if(live_skin_model > 0) return live_skin_model;
            return stored_count;
        }
        return stored_count;
    }

    if(source_id < 0 || source_id >= MAX_INVENTORY_SLOTS) return 0;
    return g_PlayerInventory[playerid][source_id][inv_itemCount];
}

stock Market_GetSourcePlate(playerid, source_id, plate[], plate_size)
{
    plate[0] = EOS;

    if(Market_IsAccessorySource(source_id)) return 1;

    if(Market_IsActiveSource(source_id))
    {
        new active_slot = Market_GetActiveSlotFromSource(source_id);
        format(plate, plate_size, "%s", g_PlayerActiveSlots[playerid][active_slot][inv_itemPlate]);

        if(active_slot == SIM_SLOT && !strlen(plate) && GetPlayerData(playerid, P_PHONE) > 0)
            format(plate, plate_size, "%d", GetPlayerData(playerid, P_PHONE));
        return 1;
    }

    if(source_id < 0 || source_id >= MAX_INVENTORY_SLOTS) return 0;
    format(plate, plate_size, "%s", g_PlayerInventory[playerid][source_id][inv_itemPlate]);
    return 1;
}

stock Market_FindReplacementSkinSlot(playerid)
{
    for(new i = 0; i < MAX_INVENTORY_SLOTS; i++)
    {
        if(g_PlayerInventory[playerid][i][inv_itemId] == 134 && g_PlayerInventory[playerid][i][inv_itemCount] > 0)
            return i;
    }
    return -1;
}

stock Market_CanSellSource(playerid, source_id)
{
    new item_id = Market_GetSourceItemId(playerid, source_id);
    if(!Market_IsSellableInventoryItem(item_id)) return 0;

    if(Market_IsAccessorySource(source_id))
        return Market_GetAccessoryModelFromSource(playerid, source_id) > 0;

    if(Market_IsSkinSource(source_id))
    {
        new skin_slot = Market_GetSkinSlotFromSource(source_id);
        if(skin_slot < 0 || skin_slot >= g_MarketSkinCount[playerid]) return 0;
        // The equipped skin is sold through the active-slot path below
        // (it enforces "must have another skin to switch into" first).
        // Selling it again from here would let the same skin be listed twice.
        if(g_MarketSkinInUse[playerid][skin_slot]) return 0;
        return g_MarketSkinGameId[playerid][skin_slot] > 0;
    }

    if(Market_IsActiveSource(source_id))
    {
        // Accessories use their authoritative `accessories` table source below.
        if(item_id != 58 && item_id != 134) return 0;

        // The equipped skin is always sellable. If there's no spare skin in the
        // inventory to switch into (true for donate-bought skins, which are never
        // added to player_inventory - see BuyPlayerSkin), Market_DeleteActiveSource
        // falls back to MARKET_DEFAULT_SKIN instead of blocking the sale.
        if(item_id == 134) return 1;
    }

    return 1;
}

stock Market_ClearActiveSlotData(playerid, active_slot)
{
    g_PlayerActiveSlots[playerid][active_slot][inv_itemId] = 0;
    g_PlayerActiveSlots[playerid][active_slot][inv_itemCount] = 0;
    g_PlayerActiveSlots[playerid][active_slot][inv_itemSlot] = active_slot;
    g_PlayerActiveSlots[playerid][active_slot][inv_itemPlate][0] = EOS;
    g_PlayerActiveSlots[playerid][active_slot][inv_itemType] = 0;
    g_PlayerActiveSlots[playerid][active_slot][inv_itemWeight] = 0;
    g_PlayerActiveSlots[playerid][active_slot][inv_itemName][0] = EOS;
    g_PlayerActiveSlots[playerid][active_slot][inv_itemActive] = false;
    g_PlayerActiveSlots[playerid][active_slot][inv_activeSlot] = -1;
    return 1;
}

stock Market_DeleteInventorySlot(playerid, slot)
{
    if(slot < 0 || slot >= MAX_INVENTORY_SLOTS) return 0;
    if(g_PlayerInventory[playerid][slot][inv_itemId] <= 0) return 0;

    new stored_count = g_PlayerInventory[playerid][slot][inv_itemCount];
    if(Market_IsSingleInventoryEntity(g_PlayerInventory[playerid][slot][inv_itemId]))
    {
        // Inventory_DeleteItem multiplies weight by item_count. For metadata items
        // temporarily normalize the count to one physical inventory entity.
        g_PlayerInventory[playerid][slot][inv_itemCount] = 1;
    }

    new result = Inventory_DeleteItem(playerid, slot);
    if(!result) g_PlayerInventory[playerid][slot][inv_itemCount] = stored_count;
    return result;
}

stock Market_DeleteActiveSource(playerid, active_slot)
{
    if(active_slot < 0 || active_slot >= MAX_ACTIVE_SLOTS) return 0;

    new source_id = Market_MakeActiveSource(active_slot);
    new item_id = Market_GetSourceItemId(playerid, source_id);
    if(item_id != 58 && item_id != 134) return 0;

    new query[320];

    if(item_id == 134)
    {
        new replacement_slot = Market_FindReplacementSkinSlot(playerid);
        new replacement_model;

        if(replacement_slot != -1)
        {
            replacement_model = g_PlayerInventory[playerid][replacement_slot][inv_itemCount];
            if(replacement_model <= 0 || !IsValidSkinModel(replacement_model)) return 0;
            if(!Market_DeleteInventorySlot(playerid, replacement_slot)) return 0;
        }
        else
        {
            // No spare skin owned (typical for donate-bought skins, which never
            // get added to player_inventory) - fall back to the default skin
            // instead of blocking the sale entirely.
            replacement_model = MARKET_DEFAULT_SKIN;
        }

        g_PlayerActiveSlots[playerid][active_slot][inv_itemId] = 134;
        g_PlayerActiveSlots[playerid][active_slot][inv_itemCount] = replacement_model;
        g_PlayerActiveSlots[playerid][active_slot][inv_itemType] = ITEM_TYPE_SKIN;
        g_PlayerActiveSlots[playerid][active_slot][inv_itemWeight] = GetItemWeight(134);
        GetItemName(134, g_PlayerActiveSlots[playerid][active_slot][inv_itemName], 64);
        g_PlayerActiveSlots[playerid][active_slot][inv_itemActive] = true;
        g_PlayerActiveSlots[playerid][active_slot][inv_activeSlot] = active_slot;

        SetPlayerSkin(playerid, replacement_model);
        SetPlayerData(playerid, P_SKIN, replacement_model);
        UpdatePlayerDatabaseInt(playerid, "skin", replacement_model);

        mysql_format(mysql, query, sizeof(query),
            "DELETE FROM `player_inventory` WHERE `player_id`=%d AND `is_active`=1 AND `active_slot`=%d",
            GetPlayerAccountID(playerid), active_slot);
        mysql_tquery(mysql, query);

        mysql_format(mysql, query, sizeof(query),
            "INSERT INTO `player_inventory` (`player_id`,`slot`,`item_id`,`item_count`,`item_plate`,`is_active`,`active_slot`) VALUES (%d,%d,134,%d,'',1,%d)",
            GetPlayerAccountID(playerid), active_slot, replacement_model, active_slot);
        mysql_tquery(mysql, query);
        return 1;
    }

    if(item_id == 58)
    {
        // P_PHONE is authoritative. Slot 0 can also contain an equipped
        // accessory in this mod, so never wipe that accessory by accident.
        if(g_PlayerActiveSlots[playerid][active_slot][inv_itemId] == 58)
            Market_ClearActiveSlotData(playerid, active_slot);

        SetPlayerData(playerid, P_PHONE, 0);
        UpdatePlayerDatabaseInt(playerid, "phone", 0);

        mysql_format(mysql, query, sizeof(query),
            "DELETE FROM `player_inventory` WHERE `player_id`=%d AND `is_active`=1 AND `active_slot`=%d AND `item_id`=58",
            GetPlayerAccountID(playerid), active_slot);
        mysql_tquery(mysql, query);
        return 1;
    }


    return 0;
}

stock Market_DeleteAccessorySource(playerid, accessory_slot)
{
    if(accessory_slot < 0 || accessory_slot >= MARKET_SOURCE_ACCESSORY_SLOTS) return 0;
    if(g_MarketAccessoryItem[playerid][accessory_slot] <= 0) return 0;

    RemovePlayerAttachedObject(playerid, accessory_slot);
    new accessory_item_id = g_MarketAccessoryItem[playerid][accessory_slot];
    if(accessory_slot < MAX_ACTIVE_SLOTS && g_PlayerActiveSlots[playerid][accessory_slot][inv_itemId] == accessory_item_id)
        Market_ClearActiveSlotData(playerid, accessory_slot);

    new query[320];
    mysql_format(mysql, query, sizeof(query),
        "DELETE FROM `accessories` WHERE `id`=%d AND `slot`=%d LIMIT 1",
        GetPlayerAccountID(playerid), accessory_slot);
    new Cache:delete_result = mysql_query(mysql, query, true);
    new deleted = cache_affected_rows(mysql);
    cache_delete(delete_result);
    if(!deleted) return 0;

    mysql_format(mysql, query, sizeof(query),
        "DELETE FROM `player_inventory` WHERE `player_id`=%d AND `is_active`=1 AND `active_slot`=%d AND `item_id`=%d",
        GetPlayerAccountID(playerid), accessory_slot, accessory_item_id);
    mysql_tquery(mysql, query);

    g_MarketAccessoryItem[playerid][accessory_slot] = 0;
    g_MarketAccessoryModel[playerid][accessory_slot] = 0;
    g_MarketAccessoryBone[playerid][accessory_slot] = 0;
    return 1;
}

stock Market_DeleteSkinSource(playerid, skin_slot)
{
    if(skin_slot < 0 || skin_slot >= g_MarketSkinCount[playerid]) return 0;
    new db_id = g_MarketSkinDbId[playerid][skin_slot];
    if(db_id <= 0) return 0;

    new query[160];
    mysql_format(mysql, query, sizeof(query), "DELETE FROM `inventory_skins` WHERE `id`=%d AND `owner_skin`=%d LIMIT 1",
        db_id, GetPlayerAccountID(playerid));
    new Cache:delete_result = mysql_query(mysql, query, true);
    new deleted = cache_affected_rows(mysql);
    cache_delete(delete_result);
    if(!deleted) return 0;

    Market_RefreshSkinCache(playerid);
    return 1;
}

stock Market_DeleteSource(playerid, source_id)
{
    if(Market_IsAccessorySource(source_id))
        return Market_DeleteAccessorySource(playerid, Market_GetAccessorySlotFromSource(source_id));

    if(Market_IsSkinSource(source_id))
        return Market_DeleteSkinSource(playerid, Market_GetSkinSlotFromSource(source_id));

    if(Market_IsActiveSource(source_id))
        return Market_DeleteActiveSource(playerid, Market_GetActiveSlotFromSource(source_id));

    return Market_DeleteInventorySlot(playerid, source_id);
}

#include "../include/system/marketplace_reward.inc"
#include "../include/system/marketplace_gui.inc"

#define MARKET_GUI_ID MARKETPLACE_GUI_ID

stock Marketplace_Init()
{
    return Marketplace_OnGameModeInit();
}

stock Market_ResetPlayer(playerid)
{
    Market_ClearAccessoryCache(playerid);
    Market_ClearSkinCache(playerid);
    Marketplace_ResetPlayer(playerid);
    MPReward_ResetPlayer(playerid);
    return 1;
}

stock Market_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    return Marketplace_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
}

stock Market_OnPacket(playerid, Node:json)
{
    return Marketplace_OnPacket(playerid, json);
}

stock Market_Open(playerid)
{
    return Marketplace_OpenGUI(playerid);
}
