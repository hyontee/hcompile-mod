	AutoShopText[0] = TextDrawCreate(527.000000, 230.000000, "<<");
	TextDrawLetterSize(AutoShopText[0], 0.220000, 1.199999);
	AutoShopText[1] = TextDrawCreate(581.000000, 230.000000, ">>");
	TextDrawLetterSize(AutoShopText[1], 0.220000, 1.199999);
	AutoShopText[2] = TextDrawCreate(581.000000, 271.000000, ">");
	TextDrawLetterSize(AutoShopText[2], 0.220000, 0.599999);
	AutoShopText[3] = TextDrawCreate(581.000000, 281.000000, ">");
	TextDrawLetterSize(AutoShopText[3], 0.220000, 0.599999);
	AutoShopText[4] = TextDrawCreate(527.000000, 281.000000, "<");
	TextDrawLetterSize(AutoShopText[4], 0.220000, 0.599999);
	AutoShopText[5] = TextDrawCreate(527.000000, 271.000000, "<");
	TextDrawLetterSize(AutoShopText[5], 0.220000, 0.599999);
	for(new s; s < 6; s++)
	{
	    TextDrawTextSize(AutoShopText[s], 10.10, 40.40);
		TextDrawAlignment(AutoShopText[s], 2);
		TextDrawBackgroundColor(AutoShopText[s], 255);
		TextDrawFont(AutoShopText[s], 2);
		TextDrawColor(AutoShopText[s], -1);
		TextDrawSetProportional(AutoShopText[s], 1);
		TextDrawSetShadow(AutoShopText[s], 1);
		TextDrawUseBox(AutoShopText[s], 1);
		TextDrawBoxColor(AutoShopText[s], 555819392);
		TextDrawSetSelectable(AutoShopText[s],true);
	}
	
	AutoShopText[6] = TextDrawCreate(556.000000, 311.000000, "BUY");
	TextDrawLetterSize(AutoShopText[6], 0.450000, 0.899999);
	TextDrawBoxColor(AutoShopText[6], 144);
	TextDrawTextSize(AutoShopText[6], 10.10, 56.56);
	TextDrawSetSelectable(AutoShopText[6], 1);
	
	AutoShopText[7] = TextDrawCreate(556.000000, 331.000000, "EXIT");
	TextDrawLetterSize(AutoShopText[7], 0.450000, 0.899999);
	TextDrawBoxColor(AutoShopText[7], 144);
	TextDrawTextSize(AutoShopText[7], 10.10, 56.56);
	TextDrawSetSelectable(AutoShopText[7],true);
	
	AutoShopText[8] = TextDrawCreate(554.000000, 161.000000, "_");// фон
	TextDrawLetterSize(AutoShopText[8], 0.500000, 22.200017);
	TextDrawSetProportional(AutoShopText[8], 1);
	TextDrawBoxColor(AutoShopText[8], 1128481664);
	TextDrawTextSize(AutoShopText[8], 0.000000, 105.000000);
	
	for(new e = 6; e < 9; e++)
	{
		TextDrawAlignment(AutoShopText[e], 2);
		TextDrawBackgroundColor(AutoShopText[e], 255);
		TextDrawFont(AutoShopText[e], 1);
		TextDrawColor(AutoShopText[e], -1);
		TextDrawSetProportional(AutoShopText[e], 1);
		TextDrawSetShadow(AutoShopText[e], 1);
		TextDrawUseBox(AutoShopText[e], 1);
	}

	AutoShopText[9] = TextDrawCreate(522.000000, 211.000000, "SELECT CAR");
	AutoShopText[10] = TextDrawCreate(537.000000, 251.000000, "COLOR");
	AutoShopText[11] = TextDrawCreate(541.000000, 165.000000, "INFO");
	
	for(new r = 9; r < 12; r++)
	{
		TextDrawBackgroundColor(AutoShopText[r], 255);
		TextDrawFont(AutoShopText[r], 2);
		TextDrawSetOutline(AutoShopText[r], 0);
		TextDrawSetShadow(AutoShopText[r], 0);
		TextDrawLetterSize(AutoShopText[r], 0.260000, 1.300000);
		TextDrawColor(AutoShopText[r], -2016477185);
		TextDrawSetProportional(AutoShopText[r], 1);
	}
	/* Дверь и ворото у гротти Grotti */
	CreateDynamicObject(19861,545.60601806641,-1294.2919921875,18.739999771118,0,0,0); /// object (MIHouse1GarageDoor1) (1) ///
	CreateDynamicObject(19861,550.86700439453,-1294.2919921875,18.746000289917,0,0,0); /// object (MIHouse1GarageDoor1) (2) ///
	CreateDynamicObject(19861,545.60601806641,-1294.3010253906,17.416000366211,0,180,0); /// object (MIHouse1GarageDoor1) (3) ///
	CreateDynamicObject(19861,550.8662109375,-1294.3010253906,17.416000366211,0,180,0); /// object (MIHouse1GarageDoor1) (4) ///
	CreateDynamicObject(1557,538.791015625,-1294.3819580078,16.242000579834,0,0,0); /// object (Gen_doorEXT19) (1) ///
	/* Автосалон ИНТ */
	new auto_salon_int;
	auto_salon_int = CreateObject(19378,1205.990,-829.125,1083.200,0.000,90.000,90.000,300.000);
	SetObjectMaterial(auto_salon_int, 0, 15041, "bigsfsave", "AH_flroortile9", 0);
	auto_salon_int = CreateDynamicObject(19380,1205.604,-829.679,1086.683,0.000,90.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 10023, "bigwhitesfe", "sfe_arch10", 0);
	auto_salon_int = CreateDynamicObject(1726,1207.384,-833.829,1083.250,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 10056, "bigoldbuild_sfe", "vgnburgwal3_256", 0);
	auto_salon_int = CreateDynamicObject(19460,1201.398,-829.076,1084.889,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19460,1201.399,-838.677,1084.889,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19460,1201.887,-824.319,1084.889,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19380,1215.239,-829.678,1086.683,0.000,90.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 10023, "bigwhitesfe", "sfe_arch10", 0);
	auto_salon_int = CreateDynamicObject(19460,1206.239,-834.442,1084.889,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19460,1215.866,-834.444,1084.889,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19460,1216.080,-829.024,1084.889,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19414,1214.684,-824.316,1084.889,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19460,1216.079,-838.654,1084.889,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19396,1211.507,-824.320,1084.889,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateObject(19378,1215.615,-829.129,1083.200,0.000,90.000,90.000,300.000);
	SetObjectMaterial(auto_salon_int, 0, 15041, "bigsfsave", "AH_flroortile9", 0);
	auto_salon_int = CreateDynamicObject(19460,1206.773,-819.447,1084.889,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19460,1214.275,-818.575,1084.889,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19460,1216.086,-819.681,1084.889,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(19380,1214.573,-819.181,1086.683,0.000,90.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 10023, "bigwhitesfe", "sfe_arch10", 0);
	auto_salon_int = CreateObject(19378,1215.614,-818.630,1083.200,0.000,90.000,90.000,300.000);
	SetObjectMaterial(auto_salon_int, 0, 15041, "bigsfsave", "AH_flroortile9", 0);
	auto_salon_int = CreateDynamicObject(19462,1217.050,-824.323,1082.579,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1205.928,-824.324,1082.579,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1201.405,-828.065,1082.579,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1201.404,-837.688,1082.579,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1216.078,-829.122,1082.579,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1211.916,-834.434,1082.579,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1216.079,-838.741,1082.579,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1202.290,-834.433,1082.579,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19414,1208.299,-824.320,1084.889,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateObject(19378,1205.989,-818.624,1083.200,0.000,90.000,90.000,300.000);
	SetObjectMaterial(auto_salon_int, 0, 15041, "bigsfsave", "AH_flroortile9", 0);
	auto_salon_int = CreateDynamicObject(19460,1204.659,-818.575,1084.889,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(2608,1210.539,-818.857,1085.261,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14581, "ab_mafiasuitea", "wood02S", 0);
	auto_salon_int = CreateDynamicObject(19380,1204.939,-819.181,1086.683,0.000,90.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 10023, "bigwhitesfe", "sfe_arch10", 0);
	auto_salon_int = CreateDynamicObject(19462,1211.305,-824.337,1087.508,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1201.698,-824.332,1087.508,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1201.424,-829.201,1087.508,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1201.409,-838.817,1087.508,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1206.207,-834.422,1087.508,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1215.835,-834.429,1087.508,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1216.059,-829.544,1087.508,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1216.063,-819.924,1087.508,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1216.055,-819.477,1082.579,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1211.597,-818.582,1082.579,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1206.780,-819.430,1082.579,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1211.252,-818.582,1087.508,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1206.789,-819.429,1087.508,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(19462,1211.686,-824.283,1087.508,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "stonewall_la", 0);
	auto_salon_int = CreateDynamicObject(1822,1207.790,-834.207,1083.264,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 10056, "bigoldbuild_sfe", "vgnburgwal3_256", 0);
	auto_salon_int = CreateDynamicObject(2254,1204.534,-824.424,1085.060,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 14383, "burg_1", "carpet4kb", 0);
	auto_salon_int = CreateDynamicObject(1822,1204.041,-827.127,1083.264,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 10056, "bigoldbuild_sfe", "vgnburgwal3_256", 0);
	auto_salon_int = CreateDynamicObject(1822,1213.281,-830.123,1083.264,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 10056, "bigoldbuild_sfe", "vgnburgwal3_256", 0);
	auto_salon_int = CreateDynamicObject(2073,1204.821,-829.080,1086.672,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "LAgreenwall", 0);
	auto_salon_int = CreateDynamicObject(2073,1208.022,-829.063,1086.672,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "LAgreenwall", 0);
	auto_salon_int = CreateDynamicObject(2073,1211.267,-829.234,1086.672,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "LAgreenwall", 0);
	auto_salon_int = CreateDynamicObject(2073,1215.082,-829.507,1086.672,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "LAgreenwall", 0);
	auto_salon_int = CreateDynamicObject(2073,1211.761,-821.091,1086.672,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	SetDynamicObjectMaterial(auto_salon_int, 0, 3820, "boxhses_sfsx", "LAgreenwall", 0);
	auto_salon_int = CreateDynamicObject(1569,1201.444,-827.632,1083.239,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1569,1201.450,-830.606,1083.239,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2165,1215.396,-823.772,1083.250,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1663,1214.587,-822.584,1083.742,0.000,0.000,9.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1726,1211.623,-819.150,1083.250,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1727,1214.323,-819.150,1083.250,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(19325,1216.425,-824.317,1086.620,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1569,1210.738,-824.331,1083.180,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(0,1206.247,-840.008,1083.233,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(14680,1200.421,-828.443,1085.819,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1726,1211.209,-833.802,1083.250,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1726,1203.511,-824.947,1083.250,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(19325,1207.258,-824.351,1086.620,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2165,1208.644,-823.778,1083.250,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1663,1207.990,-822.760,1083.742,0.000,0.000,36.300,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2164,1207.367,-818.674,1083.254,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2167,1209.140,-818.650,1083.268,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2163,1210.038,-818.637,1083.266,0.000,0.000,0.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1726,1215.464,-828.588,1083.250,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1811,1207.655,-824.801,1083.875,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(1811,1214.130,-824.772,1083.875,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(14852,1201.833,-858.080,1081.523,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(14852,1188.763,-834.132,1082.788,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(14852,1215.805,-857.016,1082.788,0.000,0.000,270.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(14852,1201.841,-837.297,1081.523,0.000,0.000,90.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2255,1208.257,-833.868,1084.665,0.000,0.000,180.000,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2253,1213.727,-829.654,1084.021,0.000,0.000,-51.660,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2253,1208.286,-833.627,1084.021,0.000,0.000,-27.540,-1,-1,-1,300.000,300.000);
	auto_salon_int = CreateDynamicObject(2253,1204.563,-826.594,1084.021,0.000,0.000,-26.280,-1,-1,-1,300.000,300.000);
