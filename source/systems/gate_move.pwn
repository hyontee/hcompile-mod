enum MOVING_GATE_e {
	mdModel,
	Float: mdClosedPos[6],
	Float: mdOpenPos[6],
	Float: mdActionPos[4], 
	Float: mdSpeed,
	mdWorld,
	mdInterior,
	mdIndex,
	mdModelID,
	mdTXD[32],
	mdTexture[32],
	mdColor,

	mdObjectID,
	Text3D:mdTextID,
	bool:mdIsOpened,
	mdFloodTimer,
	mdTimer,
};
new MovingGateInfo[][MOVING_GATE_e] = {
	{ 975, /* VOENTKOMAT*/
		{ 1135.374389, 1361.747314, 11.482428, 0.000000, 0.000000, 0.000000 }, // closed
		{ 1126.544433, 1361.747314, 11.482428, 0.000000, 0.000000, 0.000000 }, // opened
		{ 1140.6737, 1362.7390, 10.7796, 2.2409 }, // keyPos
		1.020, 0, 0,
		2, 19962, "samproadsigns", "stopsign", 0x00000000
	},
	{ 975, /* SFa */
		{ -1530.687622, 482.310791, 7.869689, 0.000000, 0.000000, 0.000000 }, // closed
		{ -1538.947631, 482.310791, 7.869689, 0.000000, 0.000000, 0.000000 }, // opened
		{ -1525.5619, 482.9151, 7.1797, 176.1050 }, // keyPos
		1.020, 0, INTERIOR_NONE,
		2, 19962, "samproadsigns", "stopsign", 0x00000000
	},
	{ 968, /* Автошкола */
		{ -2074.500000, -94.900001 ,35.000000, 0.000000, 90.000000, 90.000000}, //closed
		{ -2074.500000, -94.900001 ,35.000000, 0.000000, 0.000000, 90.000000}, //open
		{ -2074.500000, -94.900001 ,35.000000}, //keyPos
		0.04, 0, INTERIOR_NONE,
		2, 19962, "samproadsigns", "stopsign", 0x00000000 
	},
	{ 980, /* LSa 1*/
		{ -343.1787,129.6014,-42.9600, 0.000000, 0.000000, 90.000000 }, // closed
		{ -343.1787,129.6014,-42.9600, 0.000000, 0.000000, 90.000000 }, // opened
		{ -343.1787,129.6014,-42.9600}, // keyPos
		1.020, 0, INTERIOR_NONE,
		2, 19962, "samproadsigns", "stopsign", 0x00000000
	},
	{ 980, /* LSa 2*/
		{ 2720.042968, -2405.565673, 15.476907, 0.000000, 0.000000, 90.000000 }, // closed
		{ 2720.042968, -2395.565673, 15.476907, 0.000000, 0.000000, 90.000000 }, // opened
		{ 2719.6343, -2410.2156, 13.4609 }, // keyPos
		1.020, 0, INTERIOR_NONE,
		2, 19962, "samproadsigns", "stopsign", 0x00000000
	}
	/*{ 968, // FBI 
		{ -2436.836669, 495.462524, 29.764352, -2.399981, 90.000000, 25.100034}, //closed
		{ -2436.836669, 495.462524, 29.764352, -2.399981, 0.000000, 25.100034}, //open
		{ -2439.365, 494.655, 30.111}, //keyPos
		0.04, 0, INTERIOR_NONE,
		2, 19962, "samproadsigns", "stopsign", 0x00000000 
	}*/
   //CreateDynamicObject(968, -2436.836669, 495.462524, 29.764352, -2.399981, 90.000000, 25.100034, 0, 0, -1, 200.00, 200.00); // 1
	//gate_fbi = CreateDynamicObject(968, -2436.865, 495.447, 29.647, 0.000, 89.099, 24.999, 0, 0, -1, 300.00, 300.00);//Шлагбаум fbi
	//CreateDynamicObject(2886,-2439.365, 494.655, 30.111, 0.000, 0.000, 114.799, 0, 0, -1, 100.00, 100.00); // консоль ввода пин fbi  
/*

	MoveDynamicObject(gate_fbi, -2436.865, 495.447,29.647+0.04,0.04, 0.000, -0.300, 24.999);
			if (type == 1 && fbi_type == 0)
			{
				fbi_type = 1;
				SetTimerEx("UpdateStatusGate", 10_000, false, "ii",gate_id,2);
			}
		}
		else
		{
			close_gate_fbi:
			fbi_go = 0;  // 968 -2436.865 495.447 29.647 0.000 89.099 24.999
            MoveDynamicObject(gate_fbi, -2436.865, 495.447, 29.647-0.04,0.04, 0.000, 89.099, 24.999);*/
}; 
enum E_KEY_PASS {
	Float: keyPos[6],
	keyGateID,
	bool: keyStatus,

	keyObject
}
new gateAttack[][E_KEY_PASS] = {
	{{2720.010742, -2410.176025, 13.962821, 0.000000, 0.000000, -90.0}, 4, false},
	{{2720.470703, -2411.556640, 13.962821, 0.000000, 0.000000, 90.0}, 4, false},
	{{2720.018798, -2499.018066, 13.962821, 0.000000, 0.000000, -90.0}, 3, false},
	{{2720.482910, -2499.154541, 14.116911, 0.000000, 0.000000, 90.0}, 3, false},
	{{342.018, 1795.808, 18.660, 0.000, 0.000, 122.334},100,false},
	{{140.814,1941.065,19.745,0.000,0.000, -90.00},101,false}
	//140.814,1941.065,19.745,0.000,0.000,-90.0
};
/*
tempobjid = CreateDynamicObject(980, 2720.560791, -2405.565673, 15.476907, 0.000000, 0.000000, 90.000000, 0, 0, -1, 200.00, 200.00); 
SetDynamicObjectMaterial(tempobjid, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 2, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 3, 10806, "airfence_sfse", "ws_leccyfncesign", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 4, 16322, "a51_stores", "fence_64", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 5, 10806, "airfence_sfse", "ws_leccyfncesign", 0x00000000);


tempobjid = CreateDynamicObject(980, 2720.560791, -2504.252441, 15.476907, 0.000000, 0.000000, 90.000000, 0, 0, -1, 200.00, 200.00); 
SetDynamicObjectMaterial(tempobjid, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 1, 19962, "samproadsigns", "materialtext1", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 2, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 3, 10806, "airfence_sfse", "ws_leccyfncesign", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 4, 16322, "a51_stores", "fence_64", 0x00000000);
SetDynamicObjectMaterial(tempobjid, 5, 10806, "airfence_sfse", "ws_leccyfncesign", 0x00000000);*/
//
enum MOVING_DOOR_e {
	mdModel,
	Float:mdClosedPos[6],
	Float:mdOpenPos[6],
	mdMember,
	mdWorld,
	mdInterior,
	mdKeyAction, // [ KEY_WALK, KEY_CROUCH, KEY_CTRL_BACK ]
	mdIndex,
	mdModelID,
	mdTXD[32],
	mdTexture[32],
	mdColor,
	mdObjectID,
	Text3D:mdTextID,
	bool:mdIsOpened,
	mdTimer,
};

new MovingDoorInfo[][MOVING_DOOR_e] = {
	// ( LSPD interior )
	{ 1569, 
		{ 2746.723388, 1391.421997, 1099.906494, 0.000000, 0.000000, 360.000000 },	// (closed)
		{ 2746.723388, 1391.421997, 1099.906494, 0.000000, 0.000000, 475.000000 },	// (open)
		FRACTION_LSPD, 1, 6, KEY_WALK,
		0, 3241, "conhooses", "trail_door", 0xFFFFFFFF
	},
	{ 1569, 
		{ 2769.150390, 1371.880981, 1099.906494, 0.000000, 0.000000, 450.000000 },	// (closed)
		{ 2769.150390, 1371.880981, 1099.906494, 0.000000, 0.000000, 335.000000 },	// (open)
		FRACTION_LSPD, 1, 6, KEY_WALK,
		0, 3241, "conhooses", "trail_door", 0xFFFFFFFF
	},
	{ 1569, 
		{ 2769.162353, 1391.307495, 1099.900512, 0.000000, 0.000000, -90.000000 },	// (closed)
		{ 2769.162353, 1391.307495, 1099.900512, 0.000000, 0.000000, -181.000000 },	// (open)
		FRACTION_LSPD, 1, 6, KEY_WALK,
		0, 18027, "cj_barb2", "interiordoor1_256", 0x00000000
	},
	{ 1569, 
		{ 2769.168212, 1388.307006, 1099.900512, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ 2769.168212, 1388.307006, 1099.900512, 0.000000, 0.000000, 205.000000 },	// (open)
		FRACTION_LSPD, 1, 6, KEY_WALK,
		0, 18027, "cj_barb2", "interiordoor1_256", 0x00000000
	},//0 .. 3
	{ 1569, 
		{ 847.352844, 1350.999267, 1070.458984, 0.000000, 0.000000, 90.0000 },	// (closed)
		{ 847.352844, 1350.999267, 1070.458984, 0.000000, 0.000000, 335.000 }, 	// (open)
		FRACTION_HOSPITAL_LS, 1, 7, KEY_WALK,
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ 843.222839, 1337.417236, 1070.458984, 0.000000, 0.000000, 180.000 },	// (closed)
		{ 843.222839, 1337.417236, 1070.458984, 0.000000, 0.000000, 295.000 }, 	// (open)
		FRACTION_HOSPITAL_LS, 1, 7, KEY_WALK,
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ 851.223754, 1340.407714, 1070.458984, 0.000000, 0.000000, 180.000 },	// (closed)
		{ 851.223754, 1340.407714, 1070.458984, 0.000000, 0.000000, 295.000 }, 	// (open)
		FRACTION_HOSPITAL_LS, 1, 7, KEY_WALK,
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{856.814331, 1343.548339, 1070.458984, 0.000000, 0.000000, 270.000000},	// (closed)
		{856.814331, 1343.548339, 1070.458984, 0.000000, 0.000000, 25.000000}, 	// (open)
		FRACTION_HOSPITAL_LS, 1, 7, KEY_WALK,
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},//4 .. 7 
	// (CityHall Interior)
	{ 1569, 
		{ 894.811157, 1567.718627, 1086.705078, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ 894.811157, 1567.718627, 1086.705078, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_CITYHALL, 1, 8, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ 892.430969, 1574.779785, 1086.705078, 0.000000, 0.000000, 180.000000 },	// (closed)
		{ 892.430969, 1574.779785, 1086.705078, 0.000000, 0.000000, 65.000000 }, 
		FRACTION_CITYHALL, 1, 8, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ 894.811218, 1539.919555, 1086.705078, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ 894.811218, 1539.919555, 1086.705078, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_CITYHALL, 1, 8, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ 894.811218, 1536.719116, 1086.705078, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ 894.811218, 1536.719116, 1086.705078, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_CITYHALL, 1, 8, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},//8 .. 11
	//LCN
	{ 1569, 
		{ -917.999389, 1026.412231, 1284.313964, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ -917.999389, 1026.412231, 1284.313964, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_LCN, 1, LCN_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ -925.069885, 1027.222412, 1284.313964, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ -925.069885, 1027.222412, 1284.313964, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_LCN, 1, LCN_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ -919.618041, 1032.522460, 1280.817993, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ -919.618041, 1032.522460, 1280.817993, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_LCN, 1, LCN_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF//Default texture
	},
	{ 1569, 
		{ -914.110351, 1032.516357, 1280.817993, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ -914.110351, 1032.516357, 1280.817993, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_LCN, 1, LCN_INTERIOR, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0xFFFFFFFF
	},
	{ 1569, 
		{ -915.300842, 1044.389282, 1280.817993, 0.000000, 0.000000, 180.000000 },	// (closed)
		{ -915.300842, 1044.389282, 1280.817993, 0.000000, 0.000000, 65.000000 }, 
		FRACTION_LCN, 1, LCN_INTERIOR, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0xFFFFFFFF
	},//12 .. 16 
	//RM INT 32
	{ 1569, 
		{ 1748.799194, 2068.838623, 1307.864990, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ 1748.799194, 2068.838623, 1307.864990, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_RUSSIAN, 1, RM_INTERIOR, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ 1755.219848, 2068.838623, 1307.864990, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ 1755.219848, 2068.838623, 1307.864990, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_RUSSIAN, 1, RM_INTERIOR, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ 1760.900878, 2066.498046, 1307.864990, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ 1760.900878, 2066.498046, 1307.864990, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_RUSSIAN, 1, RM_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ 1773.794799, 2079.414794, 1311.514892, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ 1773.794799, 2079.414794, 1311.514892, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_RUSSIAN, 1, RM_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},
	{ 1569, 
		{ 1780.289428, 2079.412841, 1311.514892, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ 1780.289428, 2079.412841, 1311.514892, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_RUSSIAN, 1, RM_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0xFFFFFFFF
	},//17 .. 21
	//YAKUZA
	{ 1569, 
		{ -640.301330, 807.912353, 1252.219238, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ -640.301330, 807.912353, 1252.219238, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_YAKUZA, 1, YAKUZA_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ -640.301330, 800.812561, 1252.219238, 0.000000, 0.000000, 275.000000 },	// (closed)
		{ -640.301330, 800.812561, 1252.219238, 0.000000, 0.000000, 25.000000 }, 
		FRACTION_YAKUZA, 1, YAKUZA_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	}, 
	{ 1569, 
		{ -626.690063, 807.723022, 1248.729248, 0.000000, 0.000000, 275.000000 },	// (closed)
		{ -626.690063, 807.723022, 1248.729248, 0.000000, 0.000000, 25.000000 }, 
		FRACTION_YAKUZA, 1, YAKUZA_INTERIOR, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ -622.590148, 805.282653, 1248.729248, 0.000000, 0.000000, 360.000000 },	// (closed)
		{ -622.590148, 805.282653, 1248.729248, 0.000000, 0.000000, 475.000000 }, 
		FRACTION_YAKUZA, 1, YAKUZA_INTERIOR, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0xFFFFFFFF
	},
	{ 1569, 
		{ -613.178161, 806.223510, 1248.729248, 0.000000, 0.000000, 450.000000 },	// (closed)
		{ -613.178161, 806.223510, 1248.729248, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_YAKUZA, 1, YAKUZA_INTERIOR, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0xFFFFFFFF
	},//22 .. 26 
	//Hospital SF
	{ 1569, 
		{ -2607.703613, 593.643310, 1337.965332, 0.000000, 0.000000, 90.000000 },	// (closed)
		{ -2607.703613, 593.643310, 1337.965332, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_HOSPITAL_SF, 1, HOSPITAL_SF_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ -2607.703613, 578.332702, 1337.965332, 0.000000, 0.000000, 90.000000 },
		{ -2607.703613, 578.332702, 1337.965332, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_HOSPITAL_SF, 1, HOSPITAL_SF_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ -2597.598876, 592.423278, 1337.965332, 0.000000, 0.000000, 90.000000 },
		{ -2597.598876, 592.423278, 1337.965332, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_HOSPITAL_SF, 1, HOSPITAL_SF_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ -2602.542236, 578.332702, 1337.965332, 0.000000, 0.000000, 90.000000 },
		{ -2602.542236, 578.332702, 1337.965332, 0.000000, 0.000000, 335.000000 }, 
		FRACTION_HOSPITAL_SF, 1, HOSPITAL_SF_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},//27 .. 30
	
	/* HOSPITAL LV */
	{ 1569, 
		{ 1671.708618, 1786.424682, 1097.144287, 0.000000, 0.000000, 0.000000 },
		{ 1671.708618, 1786.424682, 1097.144287, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_HOSPITAL_LV, 1, HOSPITAL_LV_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ 1671.708618, 1776.925537, 1097.144287, 0.000000, 0.000000, 0.000000 },
		{ 1671.708618, 1776.925537, 1097.144287, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_HOSPITAL_LV, 1, HOSPITAL_LV_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ 1680.609008, 1776.905517, 1097.144287, 0.000000, 0.000000, 0.000000 },
		{ 1680.609008, 1776.905517, 1097.144287, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_HOSPITAL_LV, 1, HOSPITAL_LV_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ 1695.875000, 1772.915405, 1097.144287, 0.000000, 0.000000, 0.000000 },
		{ 1695.875000, 1772.915405, 1097.144287, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_HOSPITAL_LV, 1, HOSPITAL_LV_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},
	{ 1569, 
		{ 1695.875000, 1790.525146, 1097.144287, 0.000000, 0.000000, 0.000000 },
		{ 1695.875000, 1790.525146, 1097.144287, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_LSPD, 1, HOSPITAL_LV_INT, KEY_WALK, 
		0, 18029, "genintintsmallrest", "GB_restaursmll12", 0x00000000
	},//31 .. 35 
	{ 1569, 
		{ 1758.217895, 524.531005, 26.571807, 0.000000, 0.000000, 161.299789 },	// (closed)
		{ 1758.217895, 524.531005, 26.571807, 0.000000, 0.000000, 286.000000 }, 
		FRACTION_LSPD, 0, INTERIOR_NONE, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ 1742.926269, 529.908752, 26.571807, 0.000000, 0.000000, 161.299789 },	// (closed)
		{ 1742.926269, 529.908752, 26.571807, 0.000000, 0.000000, 286.000000 }, 
		FRACTION_LSPD, 0, INTERIOR_NONE, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ 1725.875732, 535.554138, 26.571807, 0.000000, 0.000000, 161.299789 },	// (closed)
		{ 1725.875732, 535.554138, 26.571807, 0.000000, 0.000000, 286.000000 }, 
		FRACTION_LSPD, 0, INTERIOR_NONE, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, //kpp sf lv
		{ -1364.764282, 863.085693, 46.476963, 0.000000, 0.000000, -43.699943 },	// (closed)
		{ -1364.764282, 863.085693, 46.476963, 0.000000, 0.000000, -133.699943 }, 
		FRACTION_LSPD, 0, INTERIOR_NONE, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, //kpp ls sf
		{ 60.444114, -1532.915649, 4.591358, 0.000000, 0.000000, 443.000000 },	// (closed)
		{ 60.444114, -1532.915649, 4.591358, 0.000000, 0.000000, 328.000000 }, 
		FRACTION_LSPD, 0, INTERIOR_NONE, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, //kpp ls sf
		{ 44.274208, -1532.580932, 4.591358, 0.000000, 0.000000, 443.000000 },	// (closed)
		{ 44.274208, -1532.580932, 4.591358, 0.000000, 0.000000, 328.000000 }, 
		FRACTION_LSPD, 0, INTERIOR_NONE, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},//36 .. 41
	/* Mongols MC (ID: 24 | World: 1) */
	{ 1569, 
		{ -1010.063537, 1961.785522, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1010.063537, 1961.785522, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_MONGOLS_MC, 1, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ -1005.249145, 1961.785522, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1005.249145, 1961.785522, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_MONGOLS_MC, 1, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ -1009.303405, 1944.295532, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1009.303405, 1944.295532, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_MONGOLS_MC, 1, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	}, //42, 43, 44
	/* Warlocks MC (ID: 25 | World: 2) */
	{ 1569, 
		{ -1010.063537, 1961.785522, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1010.063537, 1961.785522, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_BANDIDOS_MC, 2, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ -1005.249145, 1961.785522, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1005.249145, 1961.785522, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_BANDIDOS_MC, 2, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ -1009.303405, 1944.295532, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1009.303405, 1944.295532, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_BANDIDOS_MC, 2, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	}, //45,46,47
	/* Outlaws MC (ID: 26 | World: 3) */
	{ 1569, 
		{ -1010.063537, 1961.785522, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1010.063537, 1961.785522, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_OUTLAWS_MC, 3, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ -1005.249145, 1961.785522, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1005.249145, 1961.785522, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_OUTLAWS_MC, 3, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	},
	{ 1569, 
		{ -1009.303405, 1944.295532, 1076.539916, 0.000000, 0.000000, 0.000000 },	// (closed)
		{ -1009.303405, 1944.295532, 1076.539916, 0.000000, 0.000000, 125.000000 }, 
		FRACTION_OUTLAWS_MC, 3, BIKERS_INT, KEY_WALK, 
		0, 12805, "ce_loadbay", "sw_waredoor", 0x00000000
	}//48,49,50 
}; 
stock CheckingPlayerAccessDoor(playerid, gateid) {
	switch(gateid) {
		case 0 .. 3: {//LSPD
			if(!IsACop(playerid) && !IsAMayor(playerid) && MovingDoorInfo[gateid][mdMember] != pInfo[playerid][pMember] && pInfo[playerid][pFracIntKeys][MovingDoorInfo[gateid][mdMember]-1] != 322) return 1;
		}
	    case 4 .. 7: {//Hospital LS
			if(!IsAMedic(playerid) && !IsAMayor(playerid) && !IsACop(playerid)) return 1;
		} 
		case 8 .. 11: {//Government
			if(!IsAMayor(playerid) && !IsACop(playerid)) return 1;
		} 
		case 12 .. 16: {//LCN
			if(!IsAMafia(playerid) && !IsAGang(playerid)) return 1;
		}
		case 17 .. 21: {//RM
			if(!IsAMafia(playerid) && !IsAGang(playerid)) return 1;
		}
		case 22 .. 26: {//YAKUZA
			if(!IsAMafia(playerid) && !IsAGang(playerid)) return 1;
		}
		case 27 .. 30: {//FRACTION_HOSPITAL_SF
			if(!IsAMedic(playerid) && !IsAMayor(playerid) && !IsACop(playerid)) return 1;
		}
		case 31 .. 35: {//FRACTION_HOSPITAL_LV
			if(!IsAMedic(playerid) && !IsAMayor(playerid) && !IsACop(playerid)) return 1;
		}
		case 36 .. 41: {//LSPD (KPP ALL STATE)
			if(!IsACop(playerid) && MovingDoorInfo[gateid][mdMember] != pInfo[playerid][pMember]) return 1;
		}
		case 42 .. 50: { /* Door All Fraction Bikers*/ 
			if (!IsABiker(playerid)) return 1;
		}
		default: {
			return 0;
		}
	} 
	return 0;
} 

/* 
	Mongols MC (ID: 24 | World: 1) 42,43
	Warlocks MC (ID: 25 | World: 2) 44,45
	Outlaws MC (ID: 26 | World: 3) 46,47
 */
gate_OnGameModeInit() {
	for(new i = 0; i < sizeof(gateAttack); i++) {
		/*SendMes(playerid, COLOR_GREY, "[debug] attack id %d", i);
		if (gateAttack[i][keyStatus] == false) continue; 
		SendMes(playerid, COLOR_GREY, "[debug] attack id %d status", i);
		if (objectid == gateAttack[i][keyObject]) {
			if (!IsAGang(playerid)) {
				break;
			}
			SendMes(playerid, COLOR_GREY, "[debug] attack id %d status | object %d", i, objectid);
			OpenGateAttack(gateAttack[i][keyGateID]);//keyGateID
			//gateAttack[i][keyStatus]
			break;
		}*/
		gateAttack[i][keyObject] = CreateDynamicObject(2886, 
			gateAttack[i][keyPos][0], gateAttack[i][keyPos][1], gateAttack[i][keyPos][2], 
			gateAttack[i][keyPos][3], gateAttack[i][keyPos][4], gateAttack[i][keyPos][5], 0, INTERIOR_NONE, -1, 80.00, 80.00
		);
	}
    for (new id = 0, key_name[12], objectid; id < sizeof (MovingDoorInfo); id++) {
		switch (MovingDoorInfo[id][mdKeyAction]) {
			case KEY_WALK: key_name = "ALT";
			case KEY_CTRL_BACK: key_name = "H";
			case KEY_CROUCH: key_name = "C";
		}
		format(t_string, sizeof (t_string), "Дверь: "colserver"\"%s\"", key_name);
		MovingDoorInfo[id][mdTextID] = CreateDynamic3DTextLabel(t_string, -1,
			MovingDoorInfo[id][mdClosedPos][0], MovingDoorInfo[id][mdClosedPos][1],
			MovingDoorInfo[id][mdClosedPos][2] + 1.5, 7.5, .testlos = 0,
			.worldid = MovingDoorInfo[id][mdWorld], .interiorid = MovingDoorInfo[id][mdInterior]
		), t_string[0] = EOS;
		objectid = CreateDynamicObject(MovingDoorInfo[id][mdModel],
			MovingDoorInfo[id][mdClosedPos][0], MovingDoorInfo[id][mdClosedPos][1],
			MovingDoorInfo[id][mdClosedPos][2], MovingDoorInfo[id][mdClosedPos][3],
			MovingDoorInfo[id][mdClosedPos][4], MovingDoorInfo[id][mdClosedPos][5],
			MovingDoorInfo[id][mdWorld], MovingDoorInfo[id][mdInterior], -1, 80.0, 80.0
		);
		MovingDoorInfo[id][mdObjectID] = objectid;

		SetDynamicObjectMaterial(objectid, MovingDoorInfo[id][mdIndex],
			MovingDoorInfo[id][mdModelID], MovingDoorInfo[id][mdTXD],
			MovingDoorInfo[id][mdTexture], MovingDoorInfo[id][mdColor]
		);
		MovingDoorInfo[id][mdIsOpened] = false;
	}
    return true;
}

static md_TimerTicks[2] = { 5, 10 };
stock md_Timer() {
	if (--md_TimerTicks[0] <= 0) {
		for (new id = 0; id < sizeof (MovingDoorInfo); id++) {
			if (!MovingDoorInfo[id][mdIsOpened])
				continue;
			MovingDoorInfo[id][mdTimer] -= md_TimerTicks[0];

			if (MovingDoorInfo[id][mdTimer] <= 0) {
				MovingDoorInfo[id][mdIsOpened] = false;

				MoveDynamicObject(MovingDoorInfo[id][mdObjectID],
					MovingDoorInfo[id][mdClosedPos][0], MovingDoorInfo[id][mdClosedPos][1] - 0.001,
					MovingDoorInfo[id][mdClosedPos][2], 0.020,
					MovingDoorInfo[id][mdClosedPos][3], MovingDoorInfo[id][mdClosedPos][4],
					MovingDoorInfo[id][mdClosedPos][5]
				);
				MovingDoorInfo[id][mdTimer] = 0;
			}
		}
		md_TimerTicks[0] = 5;
	}
	if (--md_TimerTicks[1] <= 0) {
		for (new id = 0; id < sizeof (MovingGateInfo); id++) {
			if (!MovingGateInfo[id][mdIsOpened])
				continue;
			if (gettime() <= MovingGateInfo[id][mdFloodTimer])
				continue;
			MovingGateInfo[id][mdTimer] -= md_TimerTicks[1];

			if (MovingGateInfo[id][mdTimer] <= 0) {
				MovingGateInfo[id][mdIsOpened] = false;
				if (MovingGateInfo[id][mdModel] == 975 || MovingGateInfo[id][mdModel] == 980) {
					MoveDynamicObject(MovingGateInfo[id][mdObjectID],
						MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1] - 0.001,
						MovingGateInfo[id][mdClosedPos][2], MovingGateInfo[id][mdSpeed],
						MovingGateInfo[id][mdClosedPos][3], MovingGateInfo[id][mdClosedPos][4],
						MovingGateInfo[id][mdClosedPos][5]
					);
				}
				if (MovingGateInfo[id][mdModel] == 968) {
					MoveDynamicObject(MovingGateInfo[id][mdObjectID],
						MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1],
						MovingGateInfo[id][mdClosedPos][2] - 0.04, MovingGateInfo[id][mdSpeed],
						MovingGateInfo[id][mdClosedPos][3], MovingGateInfo[id][mdClosedPos][4],
						MovingGateInfo[id][mdClosedPos][5]
					);
				}
				MovingGateInfo[id][mdTimer] = 0;
			}
		}
		md_TimerTicks[1] = 20;
	}
}

stock CheckingPlayerAccessGates(playerid, gateid) {
	switch(gateid) {
		case 0: {//Военкомат
			if(!IsAArmy(playerid)) return 1;
		}
	    case 1: {//Армия СФ
			if(!IsAArmy(playerid)) return 1;
		} 
		case 2: {//Автошкола
			if(!pTemp[playerid][TestAutoShcool]) return 1;
		} 
		case 3, 4: {//LSa
			if(!IsAArmy(playerid) && pTemp[playerid][PlayerInArmyForm] != true) return 1;
		}
		case 5: {//Автошкола
			if(!IsAFBI(playerid)) return 1;
		} 
	} 
	return 0;
}

stock md_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	new bool:isReturn = false;
	if ((oldkeys & newkeys))
		return isReturn;
	switch (newkeys) {
		case KEY_WALK, KEY_CROUCH, KEY_CTRL_BACK: {
			if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
				for (new id = 0; id < sizeof (MovingDoorInfo); id++) {
					if (MovingDoorInfo[id][mdKeyAction] != newkeys)
						continue;
					if (MovingDoorInfo[id][mdInterior] != -1 && GetPlayerInterior(playerid) != MovingDoorInfo[id][mdInterior])
						continue;
					if (MovingDoorInfo[id][mdWorld] != -1 && GetPlayerVirtualWorld(playerid) != MovingDoorInfo[id][mdWorld])
						continue;
					if (!IsPlayerInRangeOfPoint(playerid, 2.4, MovingDoorInfo[id][mdClosedPos][0], MovingDoorInfo[id][mdClosedPos][1], MovingDoorInfo[id][mdClosedPos][2]))
						continue;
				//	SendMes(playerid, -1, "return %d", CheckingPlayerAccessDoor(playerid, id));
					
					if (CheckingPlayerAccessDoor(playerid, id))
						continue; 

					MovingDoorInfo[id][mdIsOpened] = !MovingDoorInfo[id][mdIsOpened];
					if (MovingDoorInfo[id][mdIsOpened]) {
						MoveDynamicObject(MovingDoorInfo[id][mdObjectID],
							MovingDoorInfo[id][mdOpenPos][0], MovingDoorInfo[id][mdOpenPos][1] + 0.001,
							MovingDoorInfo[id][mdOpenPos][2], 0.020,
							MovingDoorInfo[id][mdOpenPos][3], MovingDoorInfo[id][mdOpenPos][4],
							MovingDoorInfo[id][mdOpenPos][5]
						);
					} else {
						MoveDynamicObject(MovingDoorInfo[id][mdObjectID],
							MovingDoorInfo[id][mdClosedPos][0], MovingDoorInfo[id][mdClosedPos][1] - 0.001,
							MovingDoorInfo[id][mdClosedPos][2], 0.020,
							MovingDoorInfo[id][mdClosedPos][3], MovingDoorInfo[id][mdClosedPos][4],
							MovingDoorInfo[id][mdClosedPos][5]
						);
					}
					isReturn = true;
					break;
				}
			}
			if (isReturn) return true; 
			for (new id = 0, Float:distance; id < sizeof (MovingGateInfo); id++) {
				if (gettime() <= MovingGateInfo[id][mdFloodTimer])
					continue;
				if (MovingGateInfo[id][mdInterior] != -1 && GetPlayerInterior(playerid) != MovingGateInfo[id][mdInterior])
					continue;
				if (MovingGateInfo[id][mdWorld] != -1 && GetPlayerVirtualWorld(playerid) != MovingGateInfo[id][mdWorld])
					continue;
				if (CheckingPlayerAccessGates(playerid, id))
					continue; 

				if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) {
					distance = 0.50;
					if (newkeys != KEY_WALK) continue;
				}
				else if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER) {
					distance = 10.0;
					if (newkeys != KEY_CROUCH) continue;
				}
				else continue;

				if (!IsPlayerInRangeOfPoint(playerid, distance, MovingGateInfo[id][mdActionPos][0], MovingGateInfo[id][mdActionPos][1], MovingGateInfo[id][mdActionPos][2]))
					continue;
				MovingGateInfo[id][mdFloodTimer] = gettime() + 10;

				if (GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) { 
					ApplyAnimation(playerid, "CASINO", "Slot_Plyr", 4.1, 0, 0, 0, 0, 0, 1);
					SetPlayerFacingAngle(playerid, MovingGateInfo[id][mdActionPos][3]);

				}
				MovingGateInfo[id][mdIsOpened] = !MovingGateInfo[id][mdIsOpened]; 
				if (MovingGateInfo[id][mdIsOpened]) {
					if( MovingGateInfo[id][mdModel] == 975 || MovingGateInfo[id][mdModel] == 980) {
						MoveDynamicObject(MovingGateInfo[id][mdObjectID],
						MovingGateInfo[id][mdOpenPos][0], MovingGateInfo[id][mdOpenPos][1],
						MovingGateInfo[id][mdOpenPos][2], MovingGateInfo[id][mdSpeed],
						MovingGateInfo[id][mdOpenPos][3], MovingGateInfo[id][mdOpenPos][4],
						MovingGateInfo[id][mdOpenPos][5]
					);
					}
					if( MovingGateInfo[id][mdModel] == 968) {
						MoveDynamicObject(MovingGateInfo[id][mdObjectID],
						MovingGateInfo[id][mdOpenPos][0], MovingGateInfo[id][mdOpenPos][1],
						MovingGateInfo[id][mdOpenPos][2]+0.04, MovingGateInfo[id][mdSpeed],
						MovingGateInfo[id][mdOpenPos][3], MovingGateInfo[id][mdOpenPos][4],
						MovingGateInfo[id][mdOpenPos][5]
					);
					} 
				} else {
					if( MovingGateInfo[id][mdModel] == 975 || MovingGateInfo[id][mdModel] == 980) {
						MoveDynamicObject(MovingGateInfo[id][mdObjectID],
							MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1],
							MovingGateInfo[id][mdClosedPos][2], MovingGateInfo[id][mdSpeed],
							MovingGateInfo[id][mdClosedPos][3], MovingGateInfo[id][mdClosedPos][4],
							MovingGateInfo[id][mdClosedPos][5]
						);
					}
					if( MovingGateInfo[id][mdModel] == 968) {
						MoveDynamicObject(MovingGateInfo[id][mdObjectID],
							MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1],
							MovingGateInfo[id][mdClosedPos][2]-0.04, MovingGateInfo[id][mdSpeed],
							MovingGateInfo[id][mdClosedPos][3], MovingGateInfo[id][mdClosedPos][4],
							MovingGateInfo[id][mdClosedPos][5]
						);
					}
				}
				isReturn = true;
				break;
			}
			if (isReturn) return true;

		}
	}
	return isReturn;
}

stock OpenGateAttack(id) {

	if(id < 100)
	{
	
		MovingGateInfo[id][mdFloodTimer] = gettime() + 10;

		MovingGateInfo[id][mdIsOpened] = !MovingGateInfo[id][mdIsOpened]; 
		if (MovingGateInfo[id][mdIsOpened]) {
			if( MovingGateInfo[id][mdModel] == 975 || MovingGateInfo[id][mdModel] == 980) {
				MoveDynamicObject(MovingGateInfo[id][mdObjectID],
				MovingGateInfo[id][mdOpenPos][0], MovingGateInfo[id][mdOpenPos][1],
				MovingGateInfo[id][mdOpenPos][2], MovingGateInfo[id][mdSpeed],
				MovingGateInfo[id][mdOpenPos][3], MovingGateInfo[id][mdOpenPos][4],
				MovingGateInfo[id][mdOpenPos][5]
			);
			}
			if( MovingGateInfo[id][mdModel] == 968) {
				MoveDynamicObject(MovingGateInfo[id][mdObjectID],
				MovingGateInfo[id][mdOpenPos][0], MovingGateInfo[id][mdOpenPos][1],
				MovingGateInfo[id][mdOpenPos][2]+0.04, MovingGateInfo[id][mdSpeed],
				MovingGateInfo[id][mdOpenPos][3], MovingGateInfo[id][mdOpenPos][4],
				MovingGateInfo[id][mdOpenPos][5]
			);
			} 
		} else {
			if( MovingGateInfo[id][mdModel] == 975 || MovingGateInfo[id][mdModel] == 980) {
				MoveDynamicObject(MovingGateInfo[id][mdObjectID],
					MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1],
					MovingGateInfo[id][mdClosedPos][2], MovingGateInfo[id][mdSpeed],
					MovingGateInfo[id][mdClosedPos][3], MovingGateInfo[id][mdClosedPos][4],
					MovingGateInfo[id][mdClosedPos][5]
				);
			}
			if( MovingGateInfo[id][mdModel] == 968) {
				MoveDynamicObject(MovingGateInfo[id][mdObjectID],
					MovingGateInfo[id][mdClosedPos][0], MovingGateInfo[id][mdClosedPos][1],
					MovingGateInfo[id][mdClosedPos][2]-0.04, MovingGateInfo[id][mdSpeed],
					MovingGateInfo[id][mdClosedPos][3], MovingGateInfo[id][mdClosedPos][4],
					MovingGateInfo[id][mdClosedPos][5]
				);
			}
		}
	}
	else
	{
		switch(id)
		{
			case 100:
			{
				UpdateStatusGate(0, 3); // не открываются потом тип 3
			}
			case 101:
			{
				UpdateStatusGate(1, 3); // не открываются потом тип 3
			}
		}
	}
}