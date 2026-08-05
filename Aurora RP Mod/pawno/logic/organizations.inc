#if defined _organizations_included
	#endinput
#endif
#define _organizations_included

#define TABLE_ORGANIZATIONS			"organizations"

#define MAX_ORGANIZATONS			50
#define MIN_ORGANIZATION_RANK		2
#define MAX_ORGANIZATION_RANK		10

#define MAX_WAREHOUSE_TYPE_WEAPON	13
#define MAX_WAREHOUSE_TYPE_AMMO		8
#define MAX_WAREHOUSE_TYPE_BLANKS	13
#define MAX_WAREHOUSE_TYPE_DRUGS	3

#define ORG_PLANTS_TIMER			(5) // every 5s
#define ORG_PLANT_100_TIMER			(600) // default = 10m [600s]

#define ORGANIZATION_MESSAGE_SIZE	(64)

#define ORG_PLANT_WORK_PROCESS_ID	25
#define ORG_GUN_WORK_PROCESS_ID		26

#define ORG_PLANT_MINUS_Z%0(%1) 	\
		( 0.0 + (((1.1 - 0.0) / 100) * (%1)) )

#define ORG_WAREHOUSE_INTERIORID	111

enum {
	ORG_ACCESS_CMD_R = 0,
	ORG_ACCESS_CMD_INVITE,
	ORG_ACCESS_CMD_UNINVITE,
	ORG_ACCESS_CMD_GIVERANK,
	ORG_ACCESS_CMD_GIVEKEY,
	ORG_ACCESS_CMD_TAKEKEY,
	ORG_ACCESS_CMD_CAPTURE
};
enum {
	ORG_ACCESS_CREATE_WEAPON = 0,
	ORG_ACCESS_CREATE_DRUGS,
	ORG_ACCESS_CAPTURE,
	ORG_ACCESS_DEPARTMENT_CHAT
};
enum {
	/* ( /orgedit )  */
	ORG_MENU_EDIT_MAIN = 0,
	ORG_MENU_EDIT_CREATE,
	ORG_MENU_EDIT_LIST,
	ORG_MENU_EDIT_SELECT,
	ORG_MENU_EDIT_COLOR,
	ORG_MENU_EDIT_LEADER,
	ORG_MENU_EDIT_NAME,
	ORG_MENU_EDIT_INTERIOR,
	ORG_MENU_EDIT_DELETE_INT,
	ORG_MENU_EDIT_ACCESS,
	ORG_MENU_EDIT_DISBAND, 
	ORG_MENU_EDIT_DELETE, 
	ORG_MENU_EDIT_MEMBERS, 
	ORG_MENU_EDIT_ROOM_INTERIOR,
	ORG_MENU_EDIT_ROOM_DELETE_INT,

	/* ( /orgpanel ) */
	ORG_MENU_PANEL_MAIN,
	ORG_MENU_PANEL_RANK_COUNT,
	ORG_MENU_PANEL_RANK_LIST,
	ORG_MENU_PANEL_UNINVITE,

	ORG_MENU_PANEL_MESSAGE,
	ORG_MENU_PANEL_INVITE,
	ORG_MENU_PANEL_GIVERANK,
	ORG_MENU_PANEL_RIGHTS,
	ORG_MENU_PANEL_WH_RANK,
	//
	ORG_MENU_WAREHOUSE_MAIN,
	ORG_MENU_WAREHOUSE_WEAPON,
	ORG_MENU_WAREHOUSE_AMMO,
	ORG_MENU_WAREHOUSE_WEAPON_MENU,
	ORG_MENU_WAREHOUSE_AMMO_MENU,
	ORG_MENU_WAREHOUSE_AMMO_TAKE,
	ORG_MENU_WAREHOUSE_AMMO_PUT,
	ORG_MENU_WAREHOUSE_BLANKS,
	ORG_MENU_WAREHOUSE_BLANKS_MENU,
	ORG_MENU_WAREHOUSE_BLANKS_PUT,
	ORG_MENU_WAREHOUSE_BLANKS_TAKE,
	ORG_MENU_WAREHOUSE_DRUGS,
	ORG_MENU_WAREHOUSE_DRUGS_MENU,
	ORG_MENU_WAREHOUSE_DRUGS_PUT,
	ORG_MENU_WAREHOUSE_DRUGS_TAKE,
	//
	ORG_MENU_ACCESS
};
enum ORG_COLOR_E {
	colorRGBA,
	colorRGB[8],
	colorName[24]
};
new const orgColorList[][ORG_COLOR_E] = {
	{ 0xFFFF00AA, "FFFF00", "Желтый" },
	{ 0xFF66FFAA, "FF66FF", "Розовый" },
	{ 0x0000BBAA, "0000BB", "Синий" },
	{ 0x660000AA, "660000", "Темно-красный" },
	{ 0xFF9900AA, "FF9900", "Оранжевый" },
	{ 0x4B00B0AA, "4B00B0", "Индиго" },
	{ 0x00EEADAA, "00EEAD", "Морской зеленый" },
	{ 0xABCDEFAA, "ABCDEF", "Нейтральный синий" },
	{ 0xAAFFCCAA, "AAFFCC", "Ярко-голубой" },
	{ 0xDDDD23AA, "DDDD23", "Лимонный" },
	{ 0x81CFABAA, "81CFAB", "Зеленый" },
	{ 0x12900BAA, "12900B", "Темно-зеленый" },
	{ 0x800080AA, "800080", "Фиолетовый" },
	{ 0xAA3333AA, "AA3333", "Красный" }
};
enum ORG_MAKEGUN_E {
	orgGunName[32],
	orgMaterialAmount,
}
new const OrganizationMakegunInfo[][ORG_MAKEGUN_E] = {
	{ "Colt 45", 4 },
	{ "Пистолет с глушителем", 4 },
	{ "Desert Eagle", 4 },
	{ "Shotgun", 5 },
	{ "Sawnoff Shotgun", 5 },
	{ "Combat Shotgun", 5 },
	{ "Micro UZI", 5 },
	{ "TEC-9", 5 },
	{ "MP5", 5 },
	{ "AK-47", 6 },
	{ "M4", 6 },
	{ "Rifle", 7 },
	{ "Sniper Rifle", 7 }
};
enum ORG_INTERIOR_E {
	intName[32],
	intInterior,
	intFreezeTime,
	Float:intExitPos[3],
	Float:intEnterPos[4],
	Float:intSpawnPos[4],
	Float:intWarehousePos[3],
	Float:intEnterWarehousePos[3],
	Float:intExitWarehousePos[4],
}
new const OrganizationInteriorInfo[][ORG_INTERIOR_E] = {
	{
		"Интерьер банды #1",	55,	0,					// [Название, номер интерьера, заморозка]
		{ 912.8742, 315.0077, 1500.0278 }, 				// Координаты пикапа выхода
		{ 914.3572, 315.2099, 1500.0278, 269.9184 }, 	// Координаты телепорта в интерьер
		{ 934.0837, 329.5854, 1500.0319, 174.6642 }, 	// Координаты спавна
		{ 929.5048, 326.1280, 1500.0319 }, 				// Координаты точки склада

		{ 0.0, 0.0, 0.0 }, 								// Координаты пикапа входа на склад
		{ 0.0, 0.0, 0.0, 0.0 } 							// Координаты пикапа выхода из склада
	},
	{
		"Интерьер банды #2",	56,	0,					// [Название, номер интерьера, заморозка]
		{ 938.8944, 344.8913, 1500.0203 }, 				// Координаты пикапа выхода
		{ 937.4916, 344.7486, 1500.0203, 97.9637 }, 	// Координаты телепорта в интерьер
		{ 941.4221, 330.6443, 1500.0222, 99.0498 }, 	// Координаты спавна
		{ 938.6714, 319.8660, 1500.0243 }, 				// Координаты точки склада

		{ 0.0, 0.0, 0.0 }, 								// Координаты пикапа входа на склад
		{ 0.0, 0.0, 0.0, 0.0 } 							// Координаты пикапа выхода из склада
	},
	{
		"Интерьер банды #3",	51,	0,					// [Название, номер интерьера, заморозка]
		{ 2366.7048, 1321.7765, 966.3950 }, 			// Координаты пикапа выхода
		{ 2364.3650, 1321.7607, 966.3950, 85.3634 }, 	// Координаты телепорта в интерьер
		{ 2357.4231, 1333.0718, 966.4043, 79.3868 }, 	// Координаты спавна
		{ 2351.6770, 1342.6737, 966.4043 }, 			// Координаты точки склада

		{ 0.0, 0.0, 0.0 }, 								// Координаты пикапа входа на склад
		{ 0.0, 0.0, 0.0, 0.0 } 							// Координаты пикапа выхода из склада
	},
	{
		"Бар #1",	52,	0,								// [Название, номер интерьера, заморозка]
		{ 945.8891, 305.0777, 1500.0286 }, 				// Координаты пикапа выхода
		{ 944.4137, 305.0839, 1500.0286, 85.2797 }, 	// Координаты телепорта в интерьер
		{ 935.4753, 301.9068, 1500.0286, 57.7558 }, 	// Координаты спавна
		{ 9000.0, 0.0, 0.0 }, 							// Координаты точки склада

		{ 933.6096, 301.3354, 1500.0286 }, 				// Координаты пикапа входа на склад
		{ 935.4246, 302.0498, 1500.0286, 269.8555 } 	// Координаты пикапа выхода из склада
	},
	{
		"Бар #2",	53,	0,								// [Название, номер интерьера, заморозка]
		{ 924.1654, 337.8330, 1500.0298 }, 				// Координаты пикапа выхода
		{ 924.1117, 336.3815, 1500.0298, 179.5668 }, 	// Координаты телепорта в интерьер
		{ 930.0072, 323.6470, 1500.0298, 354.5733 }, 	// Координаты спавна
		{ 9000.0, 0.0, 0.0 }, 							// Координаты точки склада

		{ 930.0137, 321.7983, 1500.0298 }, 				// Координаты пикапа входа на склад
		{ 929.7186, 323.0549, 1500.0298, 353.4953 } 	// Координаты пикапа выхода из склада
	},
	{
		"Офис #1",	54,	0,								// [Название, номер интерьера, заморозка]
		{ 938.0445, 342.5479, 1500.0217 }, 				// Координаты пикапа выхода
		{ 938.1550, 340.9355, 1500.0217, 177.1438 }, 	// Координаты телепорта в интерьер
		{ 922.2396, 317.4429, 1500.0217, 262.2876 }, 	// Координаты спавна
		{ 9000.0, 0.0, 0.0 }, 							// Координаты точки склада

		{ 916.8303, 322.4760, 1500.0217 }, 				// Координаты пикапа входа на склад
		{ 918.2504, 322.7483, 1500.0217, 262.5464 } 	// Координаты пикапа выхода из склада
	},
	{
		"Кальяная #1",	57,	1,							// [Название, номер интерьера, заморозка]
		{ 926.7155, 322.2678, 1500.0477 }, 				// Координаты пикапа выхода
		{ 928.2066, 322.4455, 1500.0477, 267.8459 }, 	// Координаты телепорта в интерьер
		{ 932.9287, 319.8973, 1500.0477, 356.3278 }, 	// Координаты спавна
		{ 9000.0, 0.0, 0.0 }, 							// Координаты точки склада

		{ 938.9771, 323.7457, 1500.0458 }, 				// Координаты пикапа входа на склад
		{ 937.8195, 323.8300, 1500.0458, 89.8174 } 		// Координаты пикапа выхода из склада
	},
	{
		"Кальяная #2",	58,	1,							// [Название, номер интерьера, заморозка]
		{ 926.8528, 329.0561, 1500.0488 }, 				// Координаты пикапа выхода
		{ 928.8569, 329.1443, 1500.0488, 272.5168 }, 	// Координаты телепорта в интерьер
		{ 939.7427, 330.0770, 1500.0488, 93.7064 }, 	// Координаты спавна
		{ 9000.0, 0.0, 0.0 }, 							// Координаты точки склада

		{ 927.4330, 333.1229, 1500.0488 }, 				// Координаты пикапа входа на склад
		{ 927.5250, 331.8883, 1500.0488, 184.0258 } 	// Координаты пикапа выхода из склада
	},
	{
		"Мафия #1",	59,	1,								// [Название, номер интерьера, заморозка]
		{ 922.8772, 326.3475, 1500.0216 }, 				// Координаты пикапа выхода
		{ 922.9380, 328.7555, 1500.0216, 6.6409 }, 		// Координаты телепорта в интерьер
		{ 923.0131, 338.3714, 1500.0216, 179.7256 }, 	// Координаты спавна
		{ 935.1917, 336.9556, 1503.5276 }, 				// Координаты точки склада

		{ 0.0, 0.0, 0.0 }, 								// Координаты пикапа входа на склад
		{ 0.0, 0.0, 0.0, 0.0 } 							// Координаты пикапа выхода из склада
	},
	{
		"Мафия #2",	60,	1,								// [Название, номер интерьера, заморозка]
		{ 934.5855, 327.0168, 1500.0460 }, 				// Координаты пикапа выхода
		{ 934.4329, 328.6159, 1500.0460, 1.8906 }, 		// Координаты телепорта в интерьер
		{ 940.9562, 337.8512, 1500.0460, 165.8674 }, 	// Координаты спавна
		{ 937.8104, 350.9720, 1503.9868 }, 				// Координаты точки склада

		{ 0.0, 0.0, 0.0 }, 								// Координаты пикапа входа на склад
		{ 0.0, 0.0, 0.0, 0.0 } 							// Координаты пикапа выхода из склада
	},
	{
		"Ресторан #1",	61,	3,							// [Название, номер интерьера, заморозка]
		{ 1378.3611, -35.0322, 1000.9169 }, 			// Координаты пикапа выхода
		{ 1380.2111, -35.1238, 1000.9169, 265.8406 }, 	// Координаты телепорта в интерьер
		{ 1420.7776, -32.7396, 1001.1005, 93.6750 }, 	// Координаты спавна
		{ 9000.0, 0.0, 0.0 }, 							// Координаты точки склада

		{ 1419.6553, -42.7814, 1001.1005 }, 			// Координаты пикапа входа на склад
		{ 1419.4194, -40.7437, 1001.1005, 358.9445 } 	// Координаты пикапа выхода из склада
	},
	{
		"Ресторан #2",	62,	3, 							// [Название, номер интерьера, заморозка]
		{ 1414.2196, 1.5247, 1000.8949 }, 				// Координаты пикапа выхода
		{ 1414.3499, -0.5162, 1000.8949, 179.6544 }, 	// Координаты телепорта в интерьер
		{ 1427.8109, -2.9545, 1001.0728, 135.2025 }, 	// Координаты спавна
		{ 9000.0, 0.0, 0.0 }, 							// Координаты точки склада

		{ 1426.2463, -12.9986, 1001.0728 }, 			// Координаты пикапа входа на склад
		{ 1426.0436, -11.2566, 1001.0728, 2.7353 } 		// Координаты пикапа выхода из склада
	},
	{
		"Офис #2",	0,	3, 								// [Название, номер интерьера, заморозка]
		{ 1580.0431, -1247.8058, 93.9905 }, 			// Координаты пикапа выхода
		{ 1577.7748, -1247.8252, 93.9905, 85.0249 }, 	// Координаты телепорта в интерьер
		{ 1584.4689, -1232.3311, 93.9865, 100.5664 }, 	// Координаты спавна
		{ 9000.0, 0.0, 0.0 }, 							// Координаты точки склада

		{ 1580.0367, -1244.0873, 93.9885 }, 			// Координаты пикапа входа на склад
		{ 1578.4208, -1243.8833, 93.9885, 96.9059 } 	// Координаты пикапа выхода из склада
	},
	{
		"Байкерский клуб #1",	63,	1,					// [Название, номер интерьера, заморозка]
		{ 934.8666, 328.2662, 1500.0023 }, 				// Координаты пикапа выхода
		{ 933.0952, 327.9368, 1500.0023, 90.1967 }, 	// Координаты телепорта в интерьер
		{ 929.1058, 359.9338, 1500.0023, 168.6603 }, 	// Координаты спавна
		{ 932.1539, 354.0661, 1500.0023 }, 				// Координаты точки склада

		{ 0.0, 0.0, 0.0 }, 								// Координаты пикапа входа на склад
		{ 0.0, 0.0, 0.0, 0.0 } 							// Координаты пикапа выхода из склада
	}
};
new const OrganizationRoomInteriorInfo[][ORG_INTERIOR_E] = {
	{
		"Gun House",	41, 0, 							// [Название, номер интерьера, заморозка]
		{ 1198.8096, 2560.2490, 1121.0079 }, 			// Координаты пикапа выхода
		{ 1200.4155, 2560.3691, 1121.0120, 276.0782 } 	// Координаты телепорта в интерьер
	}, {
		"Crack House",	42, 0, 							// [Название, номер интерьера, заморозка]
		{ 898.8090, 2421.6262, 1121.0079 }, 			// Координаты пикапа выхода
		{ 900.2770, 2421.7146, 1121.0120, 268.0477 } 	// Координаты телепорта в интерьер
	}
};
new 
	OrganizationInteriorArea[sizeof (OrganizationInteriorInfo)], 
	OrganizationInteriorPickup[sizeof (OrganizationInteriorInfo)], 
	Text3D:OrganizationInteriorText[sizeof (OrganizationInteriorInfo)],

	OrganizationInteriorWH_Area[sizeof (OrganizationInteriorInfo)], 
	OrganizationInteriorWH_Pickup[sizeof (OrganizationInteriorInfo)], 
	Text3D:OrganizationInteriorWH_Text[sizeof (OrganizationInteriorInfo)],

	OrganizationWarehouseArea[sizeof (OrganizationInteriorInfo)], 
	OrganizationWarehousePickup[sizeof (OrganizationInteriorInfo)],

	OrganizationWH_InteriorArea, 
	OrganizationWH_InteriorPickup, 
	Text3D:OrganizationWH_InteriorText,

	OrganizationRoomInteriorArea[sizeof (OrganizationRoomInteriorInfo)], 
	OrganizationRoomInteriorPickup[sizeof (OrganizationRoomInteriorInfo)], 
	Text3D:OrganizationRoomInteriorText[sizeof (OrganizationRoomInteriorInfo)];


new const Float:OrganizationIntGunWorkPos[][4] = {
	{ 1204.4594, 2569.8848, 1121.0100, 185.6704 },
	{ 1208.6104, 2569.8853, 1121.0100, 178.8187 },
	{ 1208.5697, 2565.5154, 1121.0100, 357.1674 },
	{ 1204.5293, 2565.5154, 1121.0100, 4.019000 }
};
static const Float:OrganizationIntPlantWorkPos[][4] = {
	{ 899.9218, 2433.7659, 1121.0079, 94.0 },
	{ 899.9265, 2430.9146, 1121.0100, 94.0 },
	{ 899.9218, 2427.7793, 1121.0100, 94.0 }
};
static const Float:OrganizationIntPlantPos[][3] = {
	{ 904.186279, 2428.140869, 1120.070068 },
	{ 904.186279, 2429.482177, 1120.070068 },
	{ 904.186279, 2430.932373, 1120.070068 },
	{ 904.186279, 2432.323730, 1120.070068 },
	{ 906.687194, 2428.140869, 1120.070068 },
	{ 906.687194, 2429.482177, 1120.070068 },
	{ 906.687194, 2430.932373, 1120.070068 },
	{ 906.687194, 2432.323730, 1120.070068 },
	{ 909.129394, 2428.140869, 1120.070068 },
	{ 909.129394, 2429.482177, 1120.070068 },
	{ 909.129394, 2430.932373, 1120.070068 },
	{ 909.129394, 2432.323730, 1120.070068 }
};

enum {
	ORG_PLANT_STATUS_NONE = 0,
	ORG_PLANT_STATUS_CREATED = 1,
	ORG_PLANT_STATUS_GROWN,
}
#define MAX_ORGANIZATONS_PLANTS 500

enum ORGANIZATON_PLANT_E { 
	orgPlantObjectID,
	orgPlantOwner[MAX_PLAYER_NAME + 2],
	orgPlantInterior,
	orgPlantWorld,

	orgPlantStatus,
	orgPlantAmount,
	orgPlantPosition,

	Text3D:orgPlantTextID,
	Float:orgPlantPos[3],
	Float:orgPlantProcess,
}
new OrganizationPlantInfo[MAX_ORGANIZATONS_PLANTS][ORGANIZATON_PLANT_E], Iterator:orgPlants<MAX_ORGANIZATONS_PLANTS>;

enum ORGANIZATION_E {
	orgID,
	orgName[32],
	orgLeader[MAX_PLAYER_NAME],
	orgColor,
	//Text3D:orgWarehouseText,
	orgRankCount,

	orgMessage[ORGANIZATION_MESSAGE_SIZE],
	orgCreated[22],

	orgAccess[ORG_ACCESS_DEPARTMENT_CHAT + 1],
	orgWarehouseItemAmount[MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + MAX_WAREHOUSE_TYPE_BLANKS + MAX_WAREHOUSE_TYPE_DRUGS],

	orgInteriorDoorType,
	orgRoomInteriorDoorType,
	orgWarehouseRank,

	orgInterior,
	orgPickup,
	orgArea,
	Text3D:orgText,
	Float:orgEnterPos[3],
	Float:orgExitPos[4],

	orgPlantSlot[sizeof (OrganizationIntPlantPos)],
	orgRoomInterior,
	orgRoomPickup,
	orgRoomArea,
	Text3D:orgRoomText,
	Float:orgRoomEnterPos[3],
	Float:orgRoomExitPos[4]
};
new
	TOTAL_ORGANIZATIONS = 0,

	OrganizationRank[MAX_ORGANIZATONS][MAX_ORGANIZATION_RANK][32],
	OrganizationInfo[MAX_ORGANIZATONS][ORGANIZATION_E]
;
static orgPlantsTimer;

org_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		return false;
	new organization_id = PI[playerid][pOrgMember];
	if (!organization_id || JobTempProcess[playerid]) return false;

	if ((newkeys & KEY_CTRL_BACK) && !(oldkeys & KEY_CTRL_BACK)) {
		new bool:isReturn = false;
		#if defined _organizations_included
		if (GetPlayerVirtualWorld(playerid) == organization_id) {
			/* (Gun House) */
			if (GetPlayerInterior(playerid) == OrganizationRoomInteriorInfo[0][intInterior]) {
				for (new gun_position_id = 0; gun_position_id < sizeof (OrganizationIntGunWorkPos); gun_position_id++) {
					if (!IsPlayerInRangeOfPoint(playerid, 0.5, 
						OrganizationIntGunWorkPos[gun_position_id][0],
						OrganizationIntGunWorkPos[gun_position_id][1],
						OrganizationIntGunWorkPos[gun_position_id][2])
					) continue;

					if (!OrganizationInfo[organization_id][orgAccess][ORG_ACCESS_CREATE_WEAPON]) {
						ErrorMessage(playerid, "У вашей организации закрыт доступ к производству оружия.");
						isReturn = true;
						break;
					}
					org_MakegunMenu(playerid);
					isReturn = true;
					break;
				}
				if (isReturn) return true;
			}
			/* (Crack House) */
			else if (GetPlayerInterior(playerid) == OrganizationRoomInteriorInfo[1][intInterior]) {
				foreach (new plant_id: orgPlants) {
					if (!IsPlayerInRangeOfPoint(playerid, 1.25, 
						OrganizationPlantInfo[plant_id][orgPlantPos][0], 
						OrganizationPlantInfo[plant_id][orgPlantPos][1], 
						OrganizationPlantInfo[plant_id][orgPlantPos][2] + 0.93)
					) continue;
					if (GetPlayerInterior(playerid) != OrganizationPlantInfo[plant_id][orgPlantInterior])
						continue;
					if (GetPlayerVirtualWorld(playerid) != OrganizationPlantInfo[plant_id][orgPlantWorld]) 
						continue;
					org_CollectPlant(playerid, plant_id);
					isReturn = true;
					break;
				}
				if (isReturn) return true;
				for (new plant_position_id = 0; plant_position_id < sizeof (OrganizationIntPlantPos); plant_position_id++) {
					if (!IsPlayerInRangeOfPoint(playerid, 1.25, 
						OrganizationIntPlantPos[plant_position_id][0],
						OrganizationIntPlantPos[plant_position_id][1],
						OrganizationIntPlantPos[plant_position_id][2])
					) continue;

					org_CreatePlant(playerid, plant_position_id);
					isReturn = true;
					break;
				}
				if (isReturn) return true;

				for (new plant_position_id = 0; plant_position_id < sizeof (OrganizationIntPlantWorkPos); plant_position_id++) {
					if (!IsPlayerInRangeOfPoint(playerid, 0.5, 
						OrganizationIntPlantWorkPos[plant_position_id][0],
						OrganizationIntPlantWorkPos[plant_position_id][1],
						OrganizationIntPlantWorkPos[plant_position_id][2])
					) continue;

					if (!OrganizationInfo[organization_id][orgAccess][ORG_ACCESS_CREATE_DRUGS]) {
						ErrorMessage(playerid, "У вашей организации закрыт доступ к производству наркотических веществ.");
						isReturn = true;
						break;
					}
					if (!ItemCounts(playerid, 166)) {
						ErrorMessage(playerid, "У вас нет необработанной марихуаны.");
						isReturn = true;
						break;
					}
					SetPlayerPosAC(playerid, 
						OrganizationIntPlantWorkPos[plant_position_id][0],
						OrganizationIntPlantWorkPos[plant_position_id][1],
						OrganizationIntPlantWorkPos[plant_position_id][2], 
						organization_id, GetPlayerInterior(playerid)
					);
					SetPlayerFacingAngle(playerid, OrganizationIntPlantWorkPos[plant_position_id][3]);
					
					SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_1, 335, 6);
					SetPlayerAttachedObject(playerid, ATTACH_SLOT_JOB_2, 1577, 5, 0.035000, 0.090000, -0.015000, 75.400024, 82.899986, -95.299987, 0.528000, 0.571000, 0.568999);

					ApplyAnimation(playerid, "BD_FIRE", "wash_up", 4.1, 0, 1, 1, 1, 1);

					JobTempProcess[playerid] = ORG_PLANT_WORK_PROCESS_ID;
					TI[playerid][tProcess][0] = 0;
					TI[playerid][tProcess][1] = 10;
					PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
					for(new YN = 0; YN < 3; YN++)
					{
						TextDrawShowForPlayer(playerid, YandNsysTD[YN]);
						if (YN < 2) PlayerTextDrawShow(playerid, YandNsysTDPlayer[playerid][YN]);
					}
					RandomYareNforJOBS(playerid);
					TogglePlayerControllable(playerid, false);

					isReturn = true;
					break;
				}
				if (isReturn) return true;
				
			}
		}
		#endif
	}
	return false;
}
org_Timer() {
	if (++orgPlantsTimer < ORG_PLANTS_TIMER) 
		return;
	if (!Iter_Count(orgPlants)) 
		return;
	foreach (new plant_id: orgPlants) {
		if (OrganizationPlantInfo[plant_id][orgPlantProcess] >= 100.0 || OrganizationPlantInfo[plant_id][orgPlantStatus] != ORG_PLANT_STATUS_CREATED)
			continue;
		OrganizationPlantInfo[plant_id][orgPlantProcess] += ORG_PLANTS_TIMER * (100.0 / ORG_PLANT_100_TIMER);
		if (OrganizationPlantInfo[plant_id][orgPlantProcess] > 100.0) {
			OrganizationPlantInfo[plant_id][orgPlantAmount] = RandomEx(5, 10);
			OrganizationPlantInfo[plant_id][orgPlantProcess] = 100.0;
		}
		org_UpdatePlantText(plant_id);

		MoveDynamicObject(OrganizationPlantInfo[plant_id][orgPlantObjectID], 
			OrganizationPlantInfo[plant_id][orgPlantPos][0], OrganizationPlantInfo[plant_id][orgPlantPos][1], 
			OrganizationPlantInfo[plant_id][orgPlantPos][2] - ORG_PLANT_MINUS_Z(100.0 - OrganizationPlantInfo[plant_id][orgPlantProcess]),
			10.0, 0.0, 0.0, 0.0
		);
	}
	orgPlantsTimer = 0;
}
org_OnGameModeInit() {
	LoadOrganizations();

	for (new weapon_position_id = 0; weapon_position_id < sizeof (OrganizationIntGunWorkPos); weapon_position_id++) {
		CreateDynamic3DTextLabel("Рабочий стол\n\n"G"Нажмите \"H\", чтобы начать сборку оружия", PP, 
			OrganizationIntGunWorkPos[weapon_position_id][0], OrganizationIntGunWorkPos[weapon_position_id][1], 
			OrganizationIntGunWorkPos[weapon_position_id][2], 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationRoomInteriorInfo[0][intInterior]
		); 
	}
	for (new interiorid = 0; interiorid < sizeof (OrganizationInteriorInfo); interiorid++) {
		OrganizationInteriorPickup[interiorid] = CreateDynamicPickup(1318, 23, 
			OrganizationInteriorInfo[interiorid][intExitPos][0],
			OrganizationInteriorInfo[interiorid][intExitPos][1],
			OrganizationInteriorInfo[interiorid][intExitPos][2], 
			-1, OrganizationInteriorInfo[interiorid][intInterior]
		);
		OrganizationInteriorArea[interiorid] = CreateDynamicSphere( 
			OrganizationInteriorInfo[interiorid][intExitPos][0],
			OrganizationInteriorInfo[interiorid][intExitPos][1],
			OrganizationInteriorInfo[interiorid][intExitPos][2], 
			1.0, -1, OrganizationInteriorInfo[interiorid][intInterior]
		);
		SetDynamicAreaType(OrganizationInteriorArea[interiorid], AREA_TYPE_ORG_EXIT, interiorid);

		OrganizationInteriorText[interiorid] = CreateDynamic3DTextLabel("Выход\n\n"G"Вcтаньте на пикап, чтобы выйти", PP, 
			OrganizationInteriorInfo[interiorid][intExitPos][0],
			OrganizationInteriorInfo[interiorid][intExitPos][1],
			OrganizationInteriorInfo[interiorid][intExitPos][2],
			10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationInteriorInfo[interiorid][intInterior]
		);
		// ---
		if (OrganizationInteriorInfo[interiorid][intWarehousePos][0] == 9000.0) {
			OrganizationInteriorWH_Pickup[interiorid] = CreateDynamicPickup(1318, 23, 
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][0],
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][1],
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][2], 
				-1, OrganizationInteriorInfo[interiorid][intInterior]
			);
			OrganizationInteriorWH_Area[interiorid] = CreateDynamicSphere( 
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][0],
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][1],
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][2], 
				1.0, -1, OrganizationInteriorInfo[interiorid][intInterior]
			);
			SetDynamicAreaType(OrganizationInteriorWH_Area[interiorid], AREA_TYPE_ORG_ENTER_WAREHOUSE, interiorid);

			OrganizationInteriorWH_Text[interiorid] = CreateDynamic3DTextLabel("Склад\n\n"G"Вcтаньте на пикап, чтобы выйти", PP, 
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][0],
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][1],
				OrganizationInteriorInfo[interiorid][intEnterWarehousePos][2],
				10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationInteriorInfo[interiorid][intInterior]
			);
			// ---
			OrganizationWarehousePickup[interiorid] = CreateDynamicPickup(2040, 23, 
				9000+932.2559, 354.0892, 1500.0322, -1, ORG_WAREHOUSE_INTERIORID
			);
			OrganizationWarehouseArea[interiorid] = CreateDynamicSphere( 
				932.2559, 354.0892, 1500.0322, 1.0, -1, ORG_WAREHOUSE_INTERIORID
			);
			SetDynamicAreaType(OrganizationWarehouseArea[interiorid], AREA_TYPE_ORG_WAREHOUSE, interiorid);

			CreateDynamicObjectCP(932.2559,  354.0892,  1500.0322, 
				60.0, -1, ORG_WAREHOUSE_INTERIORID
			);
		} else {
			OrganizationWarehousePickup[interiorid] = CreateDynamicPickup(2040, 23, 
				9000+OrganizationInteriorInfo[interiorid][intWarehousePos][0],
				OrganizationInteriorInfo[interiorid][intWarehousePos][1],
				OrganizationInteriorInfo[interiorid][intWarehousePos][2], 
				-1, OrganizationInteriorInfo[interiorid][intInterior]
			);
			OrganizationWarehouseArea[interiorid] = CreateDynamicSphere( 
				OrganizationInteriorInfo[interiorid][intWarehousePos][0],
				OrganizationInteriorInfo[interiorid][intWarehousePos][1],
				OrganizationInteriorInfo[interiorid][intWarehousePos][2], 
				1.0, -1, OrganizationInteriorInfo[interiorid][intInterior]
			);
			SetDynamicAreaType(OrganizationWarehouseArea[interiorid], AREA_TYPE_ORG_WAREHOUSE, interiorid);

			CreateDynamicObjectCP(
				OrganizationInteriorInfo[interiorid][intWarehousePos][0],
				OrganizationInteriorInfo[interiorid][intWarehousePos][1],
				OrganizationInteriorInfo[interiorid][intWarehousePos][2], 
				60.0, -1, OrganizationInteriorInfo[interiorid][intInterior]
			);
		}
	}
	for (new interiorid = 0; interiorid < sizeof (OrganizationRoomInteriorInfo); interiorid++) {
		OrganizationRoomInteriorPickup[interiorid] = CreateDynamicPickup(1318, 23, 
			OrganizationRoomInteriorInfo[interiorid][intExitPos][0],
			OrganizationRoomInteriorInfo[interiorid][intExitPos][1],
			OrganizationRoomInteriorInfo[interiorid][intExitPos][2], 
			-1, OrganizationRoomInteriorInfo[interiorid][intInterior]
		);
		OrganizationRoomInteriorArea[interiorid] = CreateDynamicSphere( 
			OrganizationRoomInteriorInfo[interiorid][intExitPos][0],
			OrganizationRoomInteriorInfo[interiorid][intExitPos][1],
			OrganizationRoomInteriorInfo[interiorid][intExitPos][2], 
			1.0, -1, OrganizationRoomInteriorInfo[interiorid][intInterior]
		);
		SetDynamicAreaType(OrganizationRoomInteriorArea[interiorid], AREA_TYPE_ORG_EXIT_ROOM, interiorid);
		OrganizationRoomInteriorText[interiorid] = CreateDynamic3DTextLabel("Выход\n\n"G"Вcтаньте на пикап, чтобы выйти", PP, 
			OrganizationRoomInteriorInfo[interiorid][intExitPos][0],
			OrganizationRoomInteriorInfo[interiorid][intExitPos][1],
			OrganizationRoomInteriorInfo[interiorid][intExitPos][2],
			10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationRoomInteriorInfo[interiorid][intInterior]
		);
	}
	OrganizationWH_InteriorPickup = CreateDynamicPickup(1318, 23, 
		929.0546, 351.0051, 1500.0322, -1, ORG_WAREHOUSE_INTERIORID
	);
	OrganizationWH_InteriorArea = CreateDynamicSphere( 
		929.0546, 351.0051, 1500.0322, 1.0, -1, ORG_WAREHOUSE_INTERIORID
	);
	SetDynamicAreaType(OrganizationWH_InteriorArea, AREA_TYPE_ORG_EXIT_WAREHOUSE);
	OrganizationWH_InteriorText = CreateDynamic3DTextLabel("Выход\n\n"G"Вcтаньте на пикап, чтобы выйти", PP, 
		929.0546, 351.0051, 1500.0322, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, ORG_WAREHOUSE_INTERIORID
	);
	#pragma unused OrganizationWH_InteriorPickup, OrganizationWH_InteriorText
	//
	CreateDynamic3DTextLabel("Место посадки\n\n"G"Нажмите \"H\", чтобы посадить семена", PP, 
		904.1745, 2430.1680, 1122.6000, 
		5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationRoomInteriorInfo[1][intInterior]
	); 
	CreateDynamic3DTextLabel("Место посадки\n\n"G"Нажмите \"H\", чтобы посадить семена", PP, 
		906.6901, 2430.1680, 1122.6000, 
		5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationRoomInteriorInfo[1][intInterior]
	); 
	CreateDynamic3DTextLabel("Место посадки\n\n"G"Нажмите \"H\", чтобы посадить семена", PP, 
		909.1831, 2430.1680, 1122.6000, 
		5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationRoomInteriorInfo[1][intInterior]
	);
	CreateDynamic3DTextLabel("Рабочий стол\n\n"G"Нажмите \"H\", чтобы начать обработку", PP, 
		OrganizationIntPlantWorkPos[0][0], OrganizationIntPlantWorkPos[0][1], OrganizationIntPlantWorkPos[0][2], 
		1.75, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationRoomInteriorInfo[1][intInterior]
	); 
	CreateDynamic3DTextLabel("Рабочий стол\n\n"G"Нажмите \"H\", чтобы начать обработку", PP, 
		OrganizationIntPlantWorkPos[1][0], OrganizationIntPlantWorkPos[1][1], OrganizationIntPlantWorkPos[1][2], 
		1.75, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationRoomInteriorInfo[1][intInterior]
	); 
	CreateDynamic3DTextLabel("Рабочий стол\n\n"G"Нажмите \"H\", чтобы начать обработку", PP, 
		OrganizationIntPlantWorkPos[2][0], OrganizationIntPlantWorkPos[2][1], OrganizationIntPlantWorkPos[2][2], 
		1.75, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, -1, OrganizationRoomInteriorInfo[1][intInterior]
	);
}
stock org_ShowMenu(playerid, type = ORG_MENU_EDIT_MAIN) {
	STRING_GLOBAL[0] = EOS;
	new organization_id = PI[playerid][pOrgMember];

	switch (type) {
		case ORG_MENU_EDIT_COLOR: {
			for (new colorid = 0; colorid < sizeof (orgColorList); colorid++) {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), 
					"%s"P"%d. {%s}%s\n", STRING_GLOBAL, colorid + 1, 
					orgColorList[colorid][colorRGB],
					orgColorList[colorid][colorName]
				);
			}
			ShowPlayerDialog(playerid, D_ORG_EDIT_COLOR, DIALOG_STYLE_LIST, ""P"Изменить цвет", STRING_GLOBAL, "Выбрать", "Назад");
		}
		case ORG_MENU_EDIT_LEADER: {
			new organizationid = GetPVarInt(playerid, "organizationTempID");

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"W"Введите никнейм игрока, которого хотите назначить лидером организации \"%s\" [%d]:\n\
				"W"Текущий лидер организации: "P"%s\n \n\
				"G"Примечание: чтобы просто снять лидера, введите \"None\".",
				OrganizationInfo[organizationid][orgName], organizationid,
				OrganizationInfo[organizationid][orgLeader]
			);
			ShowPlayerDialog(playerid, D_ORG_EDIT_LEADER, DIALOG_STYLE_INPUT, ""P"Изменение лидера", STRING_GLOBAL, "Принять", "Назад");
		}
		case ORG_MENU_EDIT_NAME: {
			new organizationid = GetPVarInt(playerid, "organizationTempID");

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"W"Введите новое название для организации \"%s\" [%d]:\n \n\
				"G"Примечание: длина названия должна быть не менее 4 символов и не более 30 символов.", 
				OrganizationInfo[organizationid][orgName], organizationid
			);
			ShowPlayerDialog(playerid, D_ORG_EDIT_NAME, DIALOG_STYLE_INPUT, ""P"Изменение названия", STRING_GLOBAL, "Принять", "Назад");
		}
		case ORG_MENU_EDIT_MAIN: {
			ShowPlayerDialog(playerid, D_ORG_EDIT_MENU, DIALOG_STYLE_LIST, ""P"Пользовательские организации", "\
				"P"1. "W"Создать новую организацию\n\
				"P"2. "W"Управление организациями",
				"Выбрать", "Отмена"
			);
		}
		case ORG_MENU_EDIT_CREATE: {
			ShowPlayerDialog(playerid, D_ORG_EDIT_CREATE, DIALOG_STYLE_INPUT, ""P"Создание организации", "\
				"W"Введите название пользовательской организации, которую создаете:\n \n\
				"G"Примечание: длина названия должна быть не менее 4 символов и не более 30 символов.", 
				"Принять", "Назад"
			);
		}
		case ORG_MENU_EDIT_DISBAND: {
			ShowPlayerDialog(playerid, D_ORG_EDIT_DISBAND, DIALOG_STYLE_MSGBOX, ""P"Расформирование организации", "\
				{A52A2A}Вы действительно хотите расформировать пользовательскую организацию?", 
				"Да", "Отмена"
			);
		}
		case ORG_MENU_EDIT_DELETE: {
			ShowPlayerDialog(playerid, D_ORG_EDIT_DELETE, DIALOG_STYLE_MSGBOX, ""P"Удаление организации", "\
				{800000}Вы действительно хотите удалить пользовательскую организацию?", 
				"Да", "Отмена"
			);
		}
		case ORG_MENU_EDIT_MEMBERS: {
			new organizationid = GetPVarInt(playerid, "organizationTempID");

			SetPVarInt(playerid, "AmountMember", 0);
			SetPVarInt(playerid, "RowsMember", 0);

			MYSQL_GLOBAL[0] = EOS;

			mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), 
				"SELECT * FROM `accounts` WHERE `orgMember` = %i", 
				OrganizationInfo[organizationid][orgID]
			);
			mysql_tquery(connects, MYSQL_GLOBAL, "org_MemberList", "dd", playerid, organizationid), MYSQL_GLOBAL[0] = EOS;
		}
		case ORG_MENU_EDIT_LIST: {
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"#\t"P"Название\t"P"Лидер\n");

			for (new org_id = 1, idx; org_id <= TOTAL_ORGANIZATIONS; org_id++) {
				if (OrganizationInfo[org_id][orgID] == 0) {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s"P"%d\t{800000}%s\t%s\n", STRING_GLOBAL,
						org_id, OrganizationInfo[org_id][orgName], OrganizationInfo[org_id][orgLeader]
					);
				} else {
					format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s"P"%d\t"W"%s\t%s\n", STRING_GLOBAL,
						org_id, OrganizationInfo[org_id][orgName], OrganizationInfo[org_id][orgLeader]
					);
				}
				playerListitemID[playerid][idx++] = org_id;
			}
			ShowPlayerDialog(playerid, D_ORG_EDIT_LIST, DIALOG_STYLE_TABLIST_HEADERS, ""P"Управление организациями", STRING_GLOBAL, "Выбрать", "Назад");
		}
		case ORG_MENU_EDIT_DELETE_INT: {
			new organizationid = GetPVarInt(playerid, "organizationTempID");

			if (OrganizationInfo[organizationid][orgPickup] == -1) 
				return ErrorMessage(playerid, "У данной пользовательской организации не установлен вход в интерьер.");
			
			DestroyDynamicPickup(OrganizationInfo[organizationid][orgPickup]);
			DestroyDynamicArea(OrganizationInfo[organizationid][orgArea]);
			DestroyDynamic3DTextLabel(OrganizationInfo[organizationid][orgText]);
			//DestroyDynamic3DTextLabel(OrganizationInfo[organizationid][orgWarehouseText]);
			OrganizationInfo[organizationid][orgPickup] = -1;
			OrganizationInfo[organizationid][orgInterior] = 0;
			SaveOrganization(organizationid);

			SendOk(playerid, "Вы успешно удалили вход в интерьер у пользовательской организации.");
		}
		case ORG_MENU_EDIT_ROOM_DELETE_INT: {
			new organizationid = GetPVarInt(playerid, "organizationTempID");

			if (OrganizationInfo[organizationid][orgRoomPickup] == -1) 
				return ErrorMessage(playerid, "У данной пользовательской организации не установлен вход в помещение.");
			
			DestroyDynamicPickup(OrganizationInfo[organizationid][orgRoomPickup]);
			DestroyDynamicArea(OrganizationInfo[organizationid][orgRoomArea]);
			DestroyDynamic3DTextLabel(OrganizationInfo[organizationid][orgRoomText]);
			OrganizationInfo[organizationid][orgRoomPickup] = -1;
			OrganizationInfo[organizationid][orgRoomInterior] = 0;
			SaveOrganization(organizationid);

			SendOk(playerid, "Вы успешно удалили вход в помещение у пользовательской организации.");
		}
		case ORG_MENU_ACCESS: {
			new targetid = GetPVarInt(playerid, "organizationTempID");

			if (!IsPlayerConnected(targetid) || !TI[targetid][tLogin]) 
				return ErrorMessage(playerid, not_id);
			if (PI[targetid][pOrgMember] != PI[playerid][pOrgMember]) 
				return true;
			format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), ""P"Доступы %s", player_name[targetid]);

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"P"1. "W"/r \t%s\n\
				"P"2. "W"/oinvite\t%s \n\
				"P"3. "W"/ouninvite\t%s \n\
				"P"4. "W"/ogiverank\t%s \n\
				"P"5. "W"/givekey\t%s \n\
				"P"5. "W"/takekey\t%s \n\
				"P"6. "W"/capture\t%s",
				(!PI[targetid][pOrgAccess][ORG_ACCESS_CMD_R]) ? (""G"[{B22222}нет доступа"G"]") : (""G"[{6B8E23}есть доступ"G"]"),
				(!PI[targetid][pOrgAccess][ORG_ACCESS_CMD_INVITE]) ? (""G"[{B22222}нет доступа"G"]") : (""G"[{6B8E23}есть доступ"G"]"),
				(!PI[targetid][pOrgAccess][ORG_ACCESS_CMD_UNINVITE]) ? (""G"[{B22222}нет доступа"G"]") : (""G"[{6B8E23}есть доступ"G"]"),
				(!PI[targetid][pOrgAccess][ORG_ACCESS_CMD_GIVERANK]) ? (""G"[{B22222}нет доступа"G"]") : (""G"[{6B8E23}есть доступ"G"]"),
				(!PI[targetid][pOrgAccess][ORG_ACCESS_CMD_GIVEKEY]) ? (""G"[{B22222}нет доступа"G"]") : (""G"[{6B8E23}есть доступ"G"]"),
				(!PI[targetid][pOrgAccess][ORG_ACCESS_CMD_TAKEKEY]) ? (""G"[{B22222}нет доступа"G"]") : (""G"[{6B8E23}есть доступ"G"]"),
				(!PI[targetid][pOrgAccess][ORG_ACCESS_CMD_CAPTURE]) ? (""G"[{B22222}нет доступа"G"]") : (""G"[{6B8E23}есть доступ"G"]")
			);
			ShowPlayerDialog(playerid, D_ORG_ACCESS, DIALOG_STYLE_LIST, COMMAND_GLOBAL, STRING_GLOBAL, "Изменить", "Закрыть");
		}	
		case ORG_MENU_EDIT_ACCESS: {
			new organizationid = GetPVarInt(playerid, "organizationTempID");

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"P"1. "W"Создавать оружие\t%s\n\
				"P"2. "W"Создавать наркотики\t%s\n\
				"P"3. "W"Борьба за точки сбыта\t%s\n\
				"P"4. "W"Чат департамента\t%s\n",
				(!OrganizationInfo[organizationid][orgAccess][ORG_ACCESS_CREATE_WEAPON]) ? (""G"[{B22222}запрещено"G"]") : (""G"[{6B8E23}разрешено"G"]"),
				(!OrganizationInfo[organizationid][orgAccess][ORG_ACCESS_CREATE_DRUGS]) ? (""G"[{B22222}запрещено"G"]") : (""G"[{6B8E23}разрешено"G"]"),
				(!OrganizationInfo[organizationid][orgAccess][ORG_ACCESS_CAPTURE]) ? (""G"[{B22222}запрещено"G"]") : (""G"[{6B8E23}разрешено"G"]"),
				(!OrganizationInfo[organizationid][orgAccess][ORG_ACCESS_DEPARTMENT_CHAT]) ? (""G"[{B22222}запрещено"G"]") : (""G"[{6B8E23}разрешено"G"]")
			); 
			ShowPlayerDialog(playerid, D_ORG_EDIT_ACCESS, DIALOG_STYLE_TABLIST, ""P"Изменение доступов", STRING_GLOBAL, "Выбрать", "Назад");
		}
		case ORG_MENU_EDIT_INTERIOR: {
			for (new interiorid = 0; interiorid < sizeof (OrganizationInteriorInfo); interiorid++) {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s"P"%d. "W"%s\n", STRING_GLOBAL,
					interiorid + 1, OrganizationInteriorInfo[interiorid][intName]
				);
			}
			ShowPlayerDialog(playerid, D_ORG_EDIT_INTERIOR, DIALOG_STYLE_LIST, ""P"Выберите интерьер", STRING_GLOBAL, "Выбрать", "Назад");
		}
		case ORG_MENU_EDIT_ROOM_INTERIOR: {
			for (new interiorid = 0; interiorid < sizeof (OrganizationRoomInteriorInfo); interiorid++) {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s"P"%d. "W"%s\n", STRING_GLOBAL,
					interiorid + 1, OrganizationRoomInteriorInfo[interiorid][intName]
				);
			}
			ShowPlayerDialog(playerid, D_ORG_EDIT_ROOM_INTERIOR, DIALOG_STYLE_LIST, ""P"Выберите интерьер помещения", STRING_GLOBAL, "Выбрать", "Назад");
		}
		case ORG_MENU_EDIT_SELECT: {
			new 
				organizationid = GetPVarInt(playerid, "organizationTempID"),
				colorid = OrganizationInfo[organizationid][orgColor];

			format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), ""P"%s", OrganizationInfo[organizationid][orgName]);

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"P"1. "W"Изменить название "G"[%s]\n\
				"P"2. "W"Изменить цвет "G"[{%s}%s"G"]\n\
				"P"3. "W"Изменить лидера "G"[%s]\n\
				"P"4. "W"Управление доступами\n\
				"P"5. "W"Весь состав организации\n\
				"P"6. "W"Установить вход в интерьер "G"(где стоите)\n\
				"P"7. "G"Удалить интерьер\n\
				"P"8. "W"Установить вход в помещение "G"(где стоите)\n\
				"P"9. "G"Удалить помещение\n\
				"P"10. "W"Управление складом\n\
				"P"11. {A52A2A}Расформировать состав\n\
				"P"12. {800000}Удалить организацию", 
				OrganizationInfo[organizationid][orgName],
				orgColorList[colorid][colorRGB],
				orgColorList[colorid][colorName],
				OrganizationInfo[organizationid][orgLeader]
			);
			ShowPlayerDialog(playerid, D_ORG_EDIT_SELECT, DIALOG_STYLE_LIST, COMMAND_GLOBAL, STRING_GLOBAL, "Выбрать", "Назад");
		}
		case ORG_MENU_PANEL_MAIN: {
			if (!GetString(player_name[playerid], OrganizationInfo[organization_id][orgLeader])) {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Вы не являетесь лидером организации \"%s\"!",
					OrganizationInfo[organization_id][orgName]
				);
				ErrorMessage(playerid, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
				return true;
			}
			format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), ""P"%s", OrganizationInfo[organization_id][orgName]);

			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"P"1. "W"Информация\n\
				"P"2. "W"Сообщение при входе\n\
				"P"3. "W"Список игроков "G"(полный список)\n\
				"P"4. "W"Пригласить игрока "G"(/oinvite)\n\
				"P"5. "W"Уволить игрока "G"(/ouninvite)\n\
				"P"6. "W"Изменить ранг игроку "G"(/orights)\n\
				"P"7. "W"Изменить доступы игроку "G"(/orights)\n\
				"P"8. "W"Изменить количество рангов\n\
				"P"9. "W"Изменить название рангов\n\
				"P"10. "W"Доступ к интерьеру "G"(спавну) %s\n\
				"P"11. "W"Доступ к рабочему помещению %s\n\
				"P"12. "W"Доступ к складу "G"[c %i ранга]\n\
				"P"13. "W"Список транспорта организации",
				(!OrganizationInfo[organization_id][orgInteriorDoorType]) ? (""W"[для всех]") : (""W"[только сотрудники]"),
				(!OrganizationInfo[organization_id][orgRoomInteriorDoorType]) ? (""W"[для всех]") : (""W"[только сотрудники]"),
				OrganizationInfo[organization_id][orgWarehouseRank]
			);
			ShowPlayerDialog(playerid, D_ORG_PANEL, DIALOG_STYLE_TABLIST, COMMAND_GLOBAL, STRING_GLOBAL, "Выбрать", "Отмена");
			COMMAND_GLOBAL[0] = EOS;
		}
		case ORG_MENU_PANEL_INVITE: {
			ShowPlayerDialog(playerid, D_ORG_PANEL_INVITE, DIALOG_STYLE_INPUT, ""P"Принятие игрока", "\
				"W"Введите имя игрока, которого хотите пригласить:", 
				"Принять", "Назад"
			);
		}
		case ORG_MENU_PANEL_WH_RANK: {
			ShowPlayerDialog(playerid, D_ORG_PANEL_WH_RANK, DIALOG_STYLE_INPUT, ""P"Доступ к складу", "\
				"W"Введите ранг, с которого будет доступен склад:", 
				"Принять", "Назад"
			);

		}
		case ORG_MENU_PANEL_UNINVITE: {
			ShowPlayerDialog(playerid, D_ORG_PANEL_UNINVITE, DIALOG_STYLE_INPUT, ""P"Увольнение игрока", "\
				"W"Введите имя игрока, которого хотите уволить:", 
				"Принять", "Назад"
			);
		}
		case ORG_MENU_PANEL_GIVERANK: {
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), 
				""W"Введите ID игрока и номер ранга через запятую, которому хотите изменить ранг:\n \n"G"Список рангов:\n"
			);
			for (new rankid = 0; rankid < OrganizationInfo[organization_id][orgRankCount] - 1; rankid++) {
				format(COMMAND_GLOBAL, sizeof (COMMAND_GLOBAL), "\t%d. %s\n",
					rankid + 1, OrganizationRank[organization_id][rankid]
				);
				strcat(STRING_GLOBAL, COMMAND_GLOBAL);
			}
			ShowPlayerDialog(playerid, D_ORG_PANEL_GIVERANK, DIALOG_STYLE_INPUT, ""P"Изменение ранга", STRING_GLOBAL, "Принять", "Назад");
		}
		case ORG_MENU_PANEL_MESSAGE: {
			ShowPlayerDialog(playerid, D_ORG_PANEL_MESSAGE, DIALOG_STYLE_INPUT, ""P"Сообщение при входе", "\
				"W"Введите сообщение, которое будет отображаться при входе игрока:\n \n\
				"G"Введите \"None\", чтобы удалить сообщение при входе.", 
				"Принять", "Назад"
			);
		}
		case ORG_MENU_PANEL_RIGHTS: {
			ShowPlayerDialog(playerid, D_ORG_PANEL_RIGHTS, DIALOG_STYLE_INPUT, ""P"Изменение доступов игрока", "\
				"W"Введите ID игрока, которому хотите настроить доступы:", 
				"Принять", "Назад"
			);
		}
		case ORG_MENU_PANEL_RANK_COUNT: {
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
				"W"Введите количество рангов, которое будет в вашей организации "G"(сейчас %d)"W":\n \n\
				"G"Примечание: количество рангов должно быть не меньше "#MIN_ORGANIZATION_RANK" и не больше "#MAX_ORGANIZATION_RANK".\n\
				"G"Внимание! Если у игроков в организации будет ранг выше поставленного, то он изменится на текущий максимальный.",
				OrganizationInfo[organization_id][orgRankCount]
			);
			ShowPlayerDialog(playerid, D_ORG_PANEL_RANK_COUNT, DIALOG_STYLE_INPUT, ""P"Изменить количество рангов", STRING_GLOBAL, "Принять", "Назад");
		}
		case ORG_MENU_PANEL_RANK_LIST: {
			for (new rankid = 0; rankid < OrganizationInfo[organization_id][orgRankCount]; rankid++) {
				format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s"P"%d. "W"%s\n", STRING_GLOBAL,
					rankid + 1, OrganizationRank[organization_id][rankid]
				);
			}
			ShowPlayerDialog(playerid, D_ORG_PANEL_RANK_LIST, DIALOG_STYLE_LIST, ""P"Изменить количество рангов", STRING_GLOBAL, "Выбрать", "Назад");
		}
	case ORG_MENU_WAREHOUSE_MAIN: {
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_MAIN, DIALOG_STYLE_LIST, ""P"Склад организации", "\
			"P"- "W"Управление оружием\n\
			"P"- "W"Управление патронами\n\
			"P"- "W"Управление заготовками\n\
			"P"- "W"Управление наркотиками",
			"Выбрать", "Отмена"
		);
	}
	case ORG_MENU_WAREHOUSE_WEAPON: {
		format (STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
			"P"1. "W"Colt 45\t%i шт.\n\
			"P"2. "W"Пистолет с глушителем\t%i шт.\n\
			"P"3. "W"Desert Eagle\t%i шт.\n\
			"P"4. "W"Shotgun\t%i шт.\n\
			"P"5. "W"Sawnoff Shotgun\t%i шт.\n\
			"P"6. "W"Combat Shotgun\t%i шт.\n\
			"P"7. "W"Micro UZI\t%i шт.\n\
			"P"8. "W"TEC-9\t%i шт.\n\
			"P"9. "W"MP5\t%i шт.\n\
			"P"10. "W"AK-47\t%i шт.\n\
			"P"11. "W"M4\t%i шт.\n\
			"P"12. "W"Rifle\t%i шт.\n\
			"P"13. "W"Sniper Rifle\t%i шт.",
			/* (20 - 32) */
			OrganizationInfo[organization_id][orgWarehouseItemAmount][0],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][1],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][2],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][3],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][4],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][5],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][6],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][7],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][8],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][9],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][10],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][11],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][12]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_WEAPON, DIALOG_STYLE_TABLIST, ""P"Управление оружием", STRING_GLOBAL, "Выбрать", "Назад");
	}
	case ORG_MENU_WAREHOUSE_WEAPON_MENU: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[20 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_WEAPON_ACTION, DIALOG_STYLE_LIST, STRING_GLOBAL, "\
			"P"1. "W"Взять со склада\n\
			"P"2. "W"Положить на склад",
			"Выбрать", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_AMMO: {
		format (STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
			"P"1. "W"Патроны (.45ACP)\t%i шт.\n\
			"P"2. "W"Патроны (.50AE)\t%i шт.\n\
			"P"3. "W"Патроны (12 Gauge)\t%i шт.\n\
			"P"4. "W"Патроны (9 мм)\t%i шт.\n\
			"P"5. "W"Патроны (7.62 мм)\t%i шт.\n\
			"P"6. "W"Патроны (5.56 мм)\t%i шт.\n\
			"P"7. "W"Патроны (.366)\t%i шт.\n\
			"P"8. "W"Патроны (7.62x51mm HATO)\t%i шт.",
			/* (33 - 40) */
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + 0],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + 1],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + 2],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + 3],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + 4],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + 5],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + 6],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + 7]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_AMMO, DIALOG_STYLE_TABLIST, ""P"Управление патронами", STRING_GLOBAL, "Выбрать", "Назад");
	}
	case ORG_MENU_WAREHOUSE_AMMO_MENU: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[33 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_AMMO_ACTION, DIALOG_STYLE_LIST, STRING_GLOBAL, "\
			"P"1. "W"Взять со склада\n\
			"P"2. "W"Положить на склад",
			"Выбрать", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_AMMO_TAKE: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[33 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_AMMO_TAKE, DIALOG_STYLE_INPUT, STRING_GLOBAL, "\
			"W"Введите количество патрон, которое хотите взять со склада:", "Принять", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_AMMO_PUT: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[33 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_AMMO_PUT, DIALOG_STYLE_INPUT, STRING_GLOBAL, "\
			"W"Введите количество патрон, которое хотите положить на склад:", "Принять", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_BLANKS: {
		format (STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
			"P"1. "W"Заготовки Colt 45\t%i шт.\n\
			"P"2. "W"Заготовки Пистолет с глушителем\t%i шт.\n\
			"P"3. "W"Заготовки Desert Eagle\t%i шт.\n\
			"P"4. "W"Заготовки Shotgun\t%i шт.\n\
			"P"5. "W"Заготовки Sawnoff Shotgun\t%i шт.\n\
			"P"6. "W"Заготовки Combat Shotgun\t%i шт.\n\
			"P"7. "W"Заготовки Micro UZI\t%i шт.\n\
			"P"8. "W"Заготовки TEC-9\t%i шт.\n\
			"P"9. "W"Заготовки MP5\t%i шт.\n\
			"P"10. "W"Заготовки AK-47\t%i шт.\n\
			"P"11. "W"Заготовки M4\t%i шт.\n\
			"P"12. "W"Заготовки Rifle\t%i шт.\n\
			"P"13. "W"Заготовки Sniper Rifle\t%i шт.",
			/* (168 - 180) */
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 0],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 1],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 2],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 3],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 4],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 5],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 6],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 7],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 8],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 9],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 10],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 11],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + 12]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_BLANKS, DIALOG_STYLE_TABLIST, ""P"Управление заготовками", STRING_GLOBAL, "Выбрать", "Назад");
	}
	case ORG_MENU_WAREHOUSE_BLANKS_MENU: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[168 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_BLANKS_ACTION, DIALOG_STYLE_LIST, STRING_GLOBAL, "\
			"P"1. "W"Взять со склада\n\
			"P"2. "W"Положить на склад",
			"Выбрать", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_BLANKS_TAKE: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[168 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_BLANKS_TAKE, DIALOG_STYLE_INPUT, STRING_GLOBAL, "\
			"W"Введите количество заготовок, которое хотите взять со склада:", "Принять", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_BLANKS_PUT: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[168 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_BLANKS_PUT, DIALOG_STYLE_INPUT, STRING_GLOBAL, "\
			"W"Введите количество заготовок, которое хотите положить на склад:", "Принять", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_DRUGS: {
		format (STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
			"P"1. "W"Душистые семена\t%i шт.\n\
			"P"2. "W"Необработанная марихуана\t%i шт.\n\
			"P"3. "W"Обработанная марихуана\t%i шт.",
			/* (165 - 167) */
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + MAX_WAREHOUSE_TYPE_BLANKS + 0],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + MAX_WAREHOUSE_TYPE_BLANKS + 1],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + MAX_WAREHOUSE_TYPE_BLANKS + 2]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_DRUGS, DIALOG_STYLE_TABLIST, ""P"Управление наркотиками", STRING_GLOBAL, "Выбрать", "Назад");
	}
	case ORG_MENU_WAREHOUSE_DRUGS_MENU: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[165 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_DRUGS_ACTION, DIALOG_STYLE_LIST, STRING_GLOBAL, "\
			"P"1. "W"Взять со склада\n\
			"P"2. "W"Положить на склад",
			"Выбрать", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_DRUGS_TAKE: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[165 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_DRUGS_TAKE, DIALOG_STYLE_INPUT, STRING_GLOBAL, "\
			"W"Введите количество, которое хотите взять со склада:", "Принять", "Назад"
		);
	}
	case ORG_MENU_WAREHOUSE_DRUGS_PUT: {
		new itemid = GetPVarInt(playerid, "organizationTempItemID");

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), ""P"%s [%i шт.]", 
			InventoryItemInfo[165 + itemid][itemName],
			OrganizationInfo[organization_id][orgWarehouseItemAmount][MAX_WAREHOUSE_TYPE_WEAPON + MAX_WAREHOUSE_TYPE_AMMO + itemid]
		);
		ShowPlayerDialog(playerid, D_ORG_WAREHOUSE_DRUGS_PUT, DIALOG_STYLE_INPUT, STRING_GLOBAL, "\
			"W"Введите количество, которое хотите положить на склад:", "Принять", "Назад"
		);
	}
	}
	STRING_GLOBAL[0] = EOS;

	return true;
}
stock LoadOrganizations() {
	new Cache:result, rows;
	result = mysql_query(connects, "SELECT * FROM "TABLE_ORGANIZATIONS" LIMIT "#MAX_ORGANIZATONS"");
	rows = cache_num_rows();

	if (!rows) {
		print("[Загрузка ...] Пользовательских организаций не найдено.");
		cache_delete(result);
		return;
	}
	for (new organization_id = 1, i, params[148]; organization_id <= rows; organization_id++) {
		i = organization_id - 1;

		cache_get_value_name_int(i, "id", OrganizationInfo[organization_id][orgID]);
		cache_get_value_name_int(i, "color", OrganizationInfo[organization_id][orgColor]);
		cache_get_value_name_int(i, "interior", OrganizationInfo[organization_id][orgInterior]);
		cache_get_value_name_int(i, "rank_amount", OrganizationInfo[organization_id][orgRankCount]);
		cache_get_value_name(i, "date", OrganizationInfo[organization_id][orgCreated], 22);

		cache_get_value_name_int(i, "room_interior", OrganizationInfo[organization_id][orgRoomInterior]);
		cache_get_value_name_int(i, "interior_door_type", OrganizationInfo[organization_id][orgInteriorDoorType]);
		cache_get_value_name_int(i, "warehouse_rank", OrganizationInfo[organization_id][orgWarehouseRank]);
		if (OrganizationInfo[organization_id][orgWarehouseRank] < 1) OrganizationInfo[organization_id][orgWarehouseRank] = 1;
		cache_get_value_name_int(i, "room_door_type", OrganizationInfo[organization_id][orgRoomInteriorDoorType]);

		cache_get_value_name(i, "message", OrganizationInfo[organization_id][orgMessage], ORGANIZATION_MESSAGE_SIZE);
		cache_get_value_name(i, "name", OrganizationInfo[organization_id][orgName], 32);
		cache_get_value_name(i, "leader", OrganizationInfo[organization_id][orgLeader], MAX_PLAYER_NAME);

		cache_get_value(i, "org_access", params);
		sscanf(params, "p<,>a<i>[4]", OrganizationInfo[organization_id][orgAccess]);

		cache_get_value(i, "warehouse_items", params);
		if (strlen(params) < 50) {
			sscanf(params, "p<,>a<i>[21]", OrganizationInfo[organization_id][orgWarehouseItemAmount]);
		} else {
			sscanf(params, "p<,>a<i>[37]", OrganizationInfo[organization_id][orgWarehouseItemAmount]);
		}
		cache_get_value_name(i, "rank_name_1", OrganizationRank[organization_id][0], 30);
		cache_get_value_name(i, "rank_name_2", OrganizationRank[organization_id][1], 30);
		cache_get_value_name(i, "rank_name_3", OrganizationRank[organization_id][2], 30);
		cache_get_value_name(i, "rank_name_4", OrganizationRank[organization_id][3], 30);
		cache_get_value_name(i, "rank_name_5", OrganizationRank[organization_id][4], 30);
		cache_get_value_name(i, "rank_name_6", OrganizationRank[organization_id][5], 30);
		cache_get_value_name(i, "rank_name_7", OrganizationRank[organization_id][6], 30);
		cache_get_value_name(i, "rank_name_8", OrganizationRank[organization_id][7], 30);
		cache_get_value_name(i, "rank_name_9", OrganizationRank[organization_id][8], 30);
		cache_get_value_name(i, "rank_name_10", OrganizationRank[organization_id][9], 30);

		new interior_id = OrganizationInfo[organization_id][orgInterior];
		if (interior_id != 0) {
			cache_get_value_name_float(i, "enter_pos_x", OrganizationInfo[organization_id][orgEnterPos][0]);
			cache_get_value_name_float(i, "enter_pos_y", OrganizationInfo[organization_id][orgEnterPos][1]);
			cache_get_value_name_float(i, "enter_pos_z", OrganizationInfo[organization_id][orgEnterPos][2]);

			cache_get_value_name_float(i, "exit_pos_x", OrganizationInfo[organization_id][orgExitPos][0]);
			cache_get_value_name_float(i, "exit_pos_y", OrganizationInfo[organization_id][orgExitPos][1]);
			cache_get_value_name_float(i, "exit_pos_z", OrganizationInfo[organization_id][orgExitPos][2]);
			cache_get_value_name_float(i, "exit_pos_fa", OrganizationInfo[organization_id][orgExitPos][3]);

			/*format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Склад %s\n\n"G"Встаньте на пикап", OrganizationInfo[organization_id][orgName]);

			OrganizationInfo[organization_id][orgWarehouseText] = CreateDynamic3DTextLabel(STRING_GLOBAL, PP, 
				OrganizationInteriorInfo[interior_id - 1][intWarehousePos][0],
				OrganizationInteriorInfo[interior_id - 1][intWarehousePos][1],
				OrganizationInteriorInfo[interior_id - 1][intWarehousePos][2],
				10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 
				organization_id, OrganizationInteriorInfo[interior_id - 1][intInterior]
			);*/
			OrganizationInfo[organization_id][orgPickup] = CreateDynamicPickup(1318, 23, 
				OrganizationInfo[organization_id][orgEnterPos][0],
				OrganizationInfo[organization_id][orgEnterPos][1],
				OrganizationInfo[organization_id][orgEnterPos][2], 0, 0
			);
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s\n\n"G"Вcтаньте на пикап, чтобы войти", OrganizationInfo[organization_id][orgName]);

			OrganizationInfo[organization_id][orgText] = CreateDynamic3DTextLabel(STRING_GLOBAL, PP, 
				OrganizationInfo[organization_id][orgEnterPos][0],
				OrganizationInfo[organization_id][orgEnterPos][1],
				OrganizationInfo[organization_id][orgEnterPos][2],
				10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0
			);
			OrganizationInfo[organization_id][orgArea] = CreateDynamicSphere(
				OrganizationInfo[organization_id][orgEnterPos][0],
				OrganizationInfo[organization_id][orgEnterPos][1],
				OrganizationInfo[organization_id][orgEnterPos][2], 1.0, 0, 0
			);
			SetDynamicAreaType(OrganizationInfo[organization_id][orgArea], AREA_TYPE_ORG_ENTER, organization_id);
			STRING_GLOBAL[0] = EOS;
		}
		else OrganizationInfo[organization_id][orgPickup] = -1;

		interior_id = OrganizationInfo[organization_id][orgRoomInterior];
		if (interior_id != 0) {
			cache_get_value_name_float(i, "room_enter_pos_x", OrganizationInfo[organization_id][orgRoomEnterPos][0]);
			cache_get_value_name_float(i, "room_enter_pos_y", OrganizationInfo[organization_id][orgRoomEnterPos][1]);
			cache_get_value_name_float(i, "room_enter_pos_z", OrganizationInfo[organization_id][orgRoomEnterPos][2]);

			cache_get_value_name_float(i, "room_exit_pos_x", OrganizationInfo[organization_id][orgRoomExitPos][0]);
			cache_get_value_name_float(i, "room_exit_pos_y", OrganizationInfo[organization_id][orgRoomExitPos][1]);
			cache_get_value_name_float(i, "room_exit_pos_z", OrganizationInfo[organization_id][orgRoomExitPos][2]);
			cache_get_value_name_float(i, "room_exit_pos_fa", OrganizationInfo[organization_id][orgRoomExitPos][3]);

			OrganizationInfo[organization_id][orgRoomPickup] = CreateDynamicPickup(1318, 23, 
				OrganizationInfo[organization_id][orgRoomEnterPos][0],
				OrganizationInfo[organization_id][orgRoomEnterPos][1],
				OrganizationInfo[organization_id][orgRoomEnterPos][2], 0, 0
			);
			// format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s\n\n"G"Вcтаньте на пикап, чтобы войти", OrganizationInfo[organization_id][orgName]);
			format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Вход\n\n"G"Вcтаньте на пикап, чтобы войти");

			OrganizationInfo[organization_id][orgRoomText] = CreateDynamic3DTextLabel(STRING_GLOBAL, PP, 
				OrganizationInfo[organization_id][orgRoomEnterPos][0],
				OrganizationInfo[organization_id][orgRoomEnterPos][1],
				OrganizationInfo[organization_id][orgRoomEnterPos][2],
				10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0
			);
			OrganizationInfo[organization_id][orgRoomArea] = CreateDynamicSphere(
				OrganizationInfo[organization_id][orgRoomEnterPos][0],
				OrganizationInfo[organization_id][orgRoomEnterPos][1],
				OrganizationInfo[organization_id][orgRoomEnterPos][2], 1.0, 0, 0
			);
			SetDynamicAreaType(OrganizationInfo[organization_id][orgRoomArea], AREA_TYPE_ORG_ENTER_ROOM, organization_id);
			STRING_GLOBAL[0] = EOS;
		}
		else OrganizationInfo[organization_id][orgRoomPickup] = -1;

		TOTAL_ORGANIZATIONS++;
	}
	cache_delete(result);
	printf("[Загрузка ...] Пользовательские организации загружены (%i шт.)", rows);
}
CB:org_UninviteAction(playerid, name[]) {
	new organization_id = PI[playerid][pOrgMember];

	if (!(1 <= organization_id < MAX_ORGANIZATONS) || OrganizationInfo[organization_id][orgID] == 0) 
		return;

	new rows = cache_num_rows();

	if (!rows) {
		ErrorMessage(playerid, "Данный игрок не найден в вашем составе организации.");
		return;
	} 
	new targetid = GetPlayerID(name);

	if (targetid != INVALID_PLAYER_ID) {
		PI[targetid][pOrgMember] = 0;
		PI[playerid][pOrgRank] = 0;

		for (new i = 0; i < (ORG_ACCESS_CMD_CAPTURE + 1); i++)
			PI[targetid][pOrgAccess][i] = 0;
		format(CHAT_GLOBAL, sizeof (CHAT_GLOBAL), "%s уволил Вас из пользовательской организации - \"%s\".",
			player_name[playerid], OrganizationInfo[organization_id][orgName]
		);
		ErrorMessage(targetid, CHAT_GLOBAL), CHAT_GLOBAL[0] = EOS;
	}
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), 
		"UPDATE `accounts` SET `orgMember`=0,`orgRank`=0,`orgAccess`='0,0,0,0,0,0,0' WHERE `name`='%e' AND `orgMember` = %i", 
		name, OrganizationInfo[organization_id][orgID]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""), MYSQL_GLOBAL[0] = EOS;

	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Вы уволили игрока %s из пользовательской организации.", name);
	SendOk(playerid, STRING_GLOBAL), STRING_GLOBAL[0] = EOS;
}
CB:org_MemberList(playerid, organization_id) {
	if (!(1 <= organization_id < MAX_ORGANIZATONS) || OrganizationInfo[organization_id][orgID] == 0) 
		return;
	STRING_GLOBAL[0] = EOS;

	new amount = GetPVarInt(playerid, "AmountMember"), 
		rows = cache_num_rows(),
		totalMembers = 0, playerName[32], playerRank
	;
	if (!rows) {
		ErrorMessage(playerid, "В организации нет игроков.");
		return;
	} 
	for (new i = amount; i < (amount + 30); i++) {
		if (rows <= i) break;

		cache_get_value_name(i, "Name", playerName, MAX_PLAYER_NAME + 2);
		cache_get_value_name_int(i, "orgRank", playerRank);

		if (playerRank <= 0) continue;

		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s"ORANGE"%s - "G"%s [%d ранг]\n", STRING_GLOBAL,
			playerName, OrganizationRank[organization_id][playerRank - 1], playerRank
		);
		totalMembers++;
	}
	if(totalMembers > 0) 
		format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s"G"\nВсего игроков в организации: %d.", STRING_GLOBAL, rows);
	SetPVarInt(playerid, "RowsMember", rows - 1);
	ShowPlayerDialog(playerid, D_ORG_EDIT_MEMBERS, DIALOG_STYLE_MSGBOX, ""P"Весь состав организации", STRING_GLOBAL, "Назад", "Далее");
	SetPVarInt(playerid, "organizationTempID", organization_id);	
	STRING_GLOBAL[0] = 0;
}

stock org_Create(const name[], const leader[] = "None") {
	if (TOTAL_ORGANIZATIONS >= MAX_ORGANIZATONS) 
		return false;
	new organization_id = ++TOTAL_ORGANIZATIONS;

	new hour, minute, second, year, month, day;
	gettime(hour, minute, second);
	getdate(year, month, day);

	OrganizationInfo[organization_id][orgColor] = 0;
	OrganizationInfo[organization_id][orgInterior] = 0;
	OrganizationInfo[organization_id][orgPickup] = -1;
	OrganizationInfo[organization_id][orgWarehouseRank] = 1;

	format(OrganizationInfo[organization_id][orgLeader], MAX_PLAYER_NAME, leader);
	format(OrganizationInfo[organization_id][orgName], 32, name);

	format(OrganizationInfo[organization_id][orgMessage], ORGANIZATION_MESSAGE_SIZE, "None");

	format(OrganizationInfo[organization_id][orgCreated], 22, "%04d-%02d-%02d %02d:%02d:%02d",
		year, month, day, hour, minute, second
	);
	format(OrganizationRank[organization_id][0], 32, "1 ранг");
	format(OrganizationRank[organization_id][1], 32, "2 ранг");
	format(OrganizationRank[organization_id][2], 32, "3 ранг");
	format(OrganizationRank[organization_id][3], 32, "4 ранг");
	format(OrganizationRank[organization_id][4], 32, "5 ранг");
	format(OrganizationRank[organization_id][5], 32, "6 ранг");
	format(OrganizationRank[organization_id][6], 32, "7 ранг");
	format(OrganizationRank[organization_id][7], 32, "8 ранг");
	format(OrganizationRank[organization_id][8], 32, "9 ранг");
	format(OrganizationRank[organization_id][9], 32, "10 ранг");
	OrganizationInfo[organization_id][orgRankCount] = MAX_ORGANIZATION_RANK;

	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof (MYSQL_GLOBAL), 
		"INSERT INTO "TABLE_ORGANIZATIONS" (`name`) VALUES ('%e');", OrganizationInfo[organization_id][orgName]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "org_GetMySQL_ID", "i", organization_id), MYSQL_GLOBAL[0] = EOS;

	return true;
}
CB:org_GetMySQL_ID(organization_id) {
	OrganizationInfo[organization_id][orgID] = cache_insert_id();
	/*printf("(debug) org_OnGameModeInit >> Организация - \"%s\" [ID: %d] успешно создана.",
		OrganizationInfo[organization_id][orgName], OrganizationInfo[organization_id][orgID]
	);*/
	SaveOrganizationWarehouse(organization_id);
}
stock org_EditInterior(playerid, organization_id, organization_interiorid) {
	if (!(1 <= organization_id < MAX_ORGANIZATONS)) return;

	new Float:playerPos[4];
	GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
	GetPlayerFacingAngle(playerid, playerPos[3]);

	OrganizationInfo[organization_id][orgEnterPos][0] = playerPos[0];
	OrganizationInfo[organization_id][orgEnterPos][1] = playerPos[1];
	OrganizationInfo[organization_id][orgEnterPos][2] = playerPos[2];

	GetXYInBackOfPoint(playerPos[0], playerPos[1], playerPos[3], 2.0), playerPos[3] += 180.0;
	SetPlayerPosAC(playerid, playerPos[0], playerPos[1], playerPos[2], 0, 0);

	OrganizationInfo[organization_id][orgExitPos] = playerPos;
	OrganizationInfo[organization_id][orgInterior] = (organization_interiorid + 1);

	if (OrganizationInfo[organization_id][orgPickup] != -1) {
		DestroyDynamicPickup(OrganizationInfo[organization_id][orgPickup]);
		DestroyDynamicArea(OrganizationInfo[organization_id][orgArea]);
		DestroyDynamic3DTextLabel(OrganizationInfo[organization_id][orgText]);
		//DestroyDynamic3DTextLabel(OrganizationInfo[organization_id][orgWarehouseText]);
		OrganizationInfo[organization_id][orgPickup] = -1;
	}
	/*format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Склад %s\n\n"G"Встаньте на пикап", OrganizationInfo[organization_id][orgName]);

	OrganizationInfo[organization_id][orgWarehouseText] = CreateDynamic3DTextLabel(STRING_GLOBAL, PP, 
		OrganizationInteriorInfo[organization_interiorid][intWarehousePos][0],
		OrganizationInteriorInfo[organization_interiorid][intWarehousePos][1],
		OrganizationInteriorInfo[organization_interiorid][intWarehousePos][2],
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 
		organization_id, OrganizationInteriorInfo[organization_interiorid][intInterior]
	);*/
	OrganizationInfo[organization_id][orgPickup] = CreateDynamicPickup(1318, 23, 
		OrganizationInfo[organization_id][orgEnterPos][0],
		OrganizationInfo[organization_id][orgEnterPos][1],
		OrganizationInfo[organization_id][orgEnterPos][2], 0, 0
	);
	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s\n\n"G"Вcтаньте на пикап, чтобы войти", OrganizationInfo[organization_id][orgName]);

	OrganizationInfo[organization_id][orgText] = CreateDynamic3DTextLabel(STRING_GLOBAL, PP, 
		OrganizationInfo[organization_id][orgEnterPos][0],
		OrganizationInfo[organization_id][orgEnterPos][1],
		OrganizationInfo[organization_id][orgEnterPos][2],
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0
	);
	OrganizationInfo[organization_id][orgArea] = CreateDynamicSphere(
		OrganizationInfo[organization_id][orgEnterPos][0],
		OrganizationInfo[organization_id][orgEnterPos][1],
		OrganizationInfo[organization_id][orgEnterPos][2], 1.0, 0, 0
	);
	SetDynamicAreaType(OrganizationInfo[organization_id][orgArea], AREA_TYPE_ORG_ENTER, organization_id);
	SaveOrganization(organization_id);
}

stock org_EditRoomInterior(playerid, organization_id, organization_interiorid) {
	if (!(1 <= organization_id < MAX_ORGANIZATONS)) return;

	new Float:playerPos[4];
	GetPlayerPos(playerid, playerPos[0], playerPos[1], playerPos[2]);
	GetPlayerFacingAngle(playerid, playerPos[3]);

	OrganizationInfo[organization_id][orgRoomEnterPos][0] = playerPos[0];
	OrganizationInfo[organization_id][orgRoomEnterPos][1] = playerPos[1];
	OrganizationInfo[organization_id][orgRoomEnterPos][2] = playerPos[2];

	GetXYInBackOfPoint(playerPos[0], playerPos[1], playerPos[3], 2.0), playerPos[3] += 180.0;
	SetPlayerPosAC(playerid, playerPos[0], playerPos[1], playerPos[2], 0, 0);

	OrganizationInfo[organization_id][orgRoomExitPos] = playerPos;
	OrganizationInfo[organization_id][orgRoomInterior] = (organization_interiorid + 1);

	if (OrganizationInfo[organization_id][orgRoomPickup] != -1) {
		DestroyDynamicPickup(OrganizationInfo[organization_id][orgRoomPickup]);
		DestroyDynamicArea(OrganizationInfo[organization_id][orgRoomArea]);
		DestroyDynamic3DTextLabel(OrganizationInfo[organization_id][orgRoomText]);
		OrganizationInfo[organization_id][orgRoomPickup] = -1;
	}
	OrganizationInfo[organization_id][orgRoomPickup] = CreateDynamicPickup(1318, 23, 
		OrganizationInfo[organization_id][orgRoomEnterPos][0],
		OrganizationInfo[organization_id][orgRoomEnterPos][1],
		OrganizationInfo[organization_id][orgRoomEnterPos][2], 0, 0
	);
	// format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "%s\n\n"G"Вcтаньте на пикап, чтобы войти", OrganizationInfo[organization_id][orgName]);
	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "Вход\n\n"G"Вcтаньте на пикап, чтобы войти");

	OrganizationInfo[organization_id][orgRoomText] = CreateDynamic3DTextLabel(STRING_GLOBAL, PP, 
		OrganizationInfo[organization_id][orgRoomEnterPos][0],
		OrganizationInfo[organization_id][orgRoomEnterPos][1],
		OrganizationInfo[organization_id][orgRoomEnterPos][2],
		10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1, 0, 0
	);
	OrganizationInfo[organization_id][orgRoomArea] = CreateDynamicSphere(
		OrganizationInfo[organization_id][orgRoomEnterPos][0],
		OrganizationInfo[organization_id][orgRoomEnterPos][1],
		OrganizationInfo[organization_id][orgRoomEnterPos][2], 1.0, 0, 0
	);
	SetDynamicAreaType(OrganizationInfo[organization_id][orgRoomArea], AREA_TYPE_ORG_ENTER_ROOM, organization_id);
	SaveOrganization(organization_id);
}


CMD:orgpanel(playerid) {
	new organization_id = PI[playerid][pOrgMember];
	if (!organization_id)
		return ErrorMessage(playerid, "Вы не состоите в пользовательской организации.");
	if (!GetString(player_name[playerid], OrganizationInfo[organization_id][orgLeader])) 
		return ErrorMessage(playerid, "У вас нет доступа к данной команде!");
	org_ShowMenu(playerid, ORG_MENU_PANEL_MAIN);
	return true;
}
CMD:oinvite(playerid, params[]) {
	new organization_id = PI[playerid][pOrgMember];
	if (!organization_id)
		return ErrorMessage(playerid, "Вы не состоите в пользовательской организации.");
	if (!(PI[playerid][pAdmin] >= 5 && dostup[playerid]) && !GetString(player_name[playerid], OrganizationInfo[organization_id][orgLeader]) && !PI[playerid][pOrgAccess][ORG_ACCESS_CMD_INVITE])
		return ErrorMessage(playerid, "У вас нет доступа к данной команде!");
	new targetid;
	if (sscanf(params, "u", targetid))
		return SendEsp(playerid, "/oinvite [id игрока]");

	if (!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
		return ErrorMessage(playerid, not_id);
	if (PI[targetid][pOrgMember])
		return ErrorMessage(playerid, "Игрок уже состоит в пользовательской организации.");
	if (PI[targetid][pWarns] >= 1)
		return ErrorMessage(playerid, "У игрока имеются предупреждения.");
	if (!IsPlayerStream(7.0, playerid, targetid))
		return ErrorMessage(playerid, "Вы далеко от игрока.");

	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
		"P"%s "W"предлагает Вам вступить в организацию - "P"\"%s\"\n \n\
		"W"Согласны ли Вы вступить в данную организацию?",
		player_name[playerid], OrganizationInfo[organization_id][orgName]
	);
	ShowPlayerDialog(targetid, D_ORG_INVITE, DIALOG_STYLE_MSGBOX, ""P"Предложение о вступлении", STRING_GLOBAL, "Да", "Отмена"), STRING_GLOBAL[0] = EOS;
	SetPVarInt(targetid, "invkot", playerid);

	return true;
}
CMD:oleave(playerid) {
	if (PI[playerid][pOrgMember]) {
		if (GetString(OrganizationInfo[PI[playerid][pOrgMember]][orgLeader], player_name[playerid]))
			return ErrorMessage(playerid, "Лидеру запрещено");

		ShowPlayerDialog(playerid, D_ORG_LEAVE, DIALOG_STYLE_MSGBOX, ""P"Покинуть организацию", "\
			"W"Вы действительно хотите покинуть пользовательскую организацию?",
			"Да", "Отмена"
		);
	}
	return true;
}
CMD:omembers(playerid) {
	if (!PI[playerid][pOrgMember]) 
		return ErrorMessage(playerid, "Вы не состоите в пользовательской организации.");
	new ids = 0, str[128];
	strcat(str, ""ORANGE"ID\tРанг\tТелефон\tИмя"W"\n\n");
	
	STRING_GLOBAL[0] = EOS;
	strcat(STRING_GLOBAL, str);
	
	foreach(new i: Player) {
		if (!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;
		if (PI[i][pOrgMember] != PI[playerid][pOrgMember]) continue;
		if (!PI[i][pOrgRank] || PI[i][pAdmin]) continue;

		format(str, sizeof(str), ""W"%d\t%d\t%d\t\t\t%s %s\n", 
			i, PI[i][pRank], PI[i][pPhone], player_name[i], 
			(TI[i][tAFK] > 3) ? (""P"[AFK]"W"") : ("")
		);
		strcat(STRING_GLOBAL, str);
		ids++;
	}
	ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, ""P"Члены организации онлайн", STRING_GLOBAL, "Закрыть", "");

	format(CHAT_GLOBAL, sizeof(CHAT_GLOBAL), ""W"Всего игроков в организации: "ORANGE"%d", ids);
	SendOk(playerid, CHAT_GLOBAL), CHAT_GLOBAL[0] = EOS;

	return 1;
}
CMD:ogiverank(playerid, params[]) {
	new organization_id = PI[playerid][pOrgMember];
	if (!organization_id)
		return ErrorMessage(playerid, "Вы не состоите в пользовательской организации.");
	if (!GetString(player_name[playerid], OrganizationInfo[organization_id][orgLeader]) && !PI[playerid][pOrgAccess][ORG_ACCESS_CMD_GIVERANK]) 
		return ErrorMessage(playerid, "У вас нет доступа к данной команде!");
	new targetid, rank, max_rank = OrganizationInfo[organization_id][orgRankCount] - 1;
	if (sscanf(params, "ui", targetid, rank) || !(1 <= rank <= max_rank)) {
		format(CHAT_GLOBAL, sizeof (CHAT_GLOBAL), "/ogiverank [id игрока] [ранг (1 - %d)]", max_rank);
		SendEsp(playerid, CHAT_GLOBAL), CHAT_GLOBAL[0] = EOS;
		return true;
	}
	if (!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
		return ErrorMessage(playerid, not_id);
	if (PI[targetid][pOrgMember] != organization_id)
		return ErrorMessage(playerid, "Игрок не состоит в вашей пользовательской организации.");

	PI[targetid][pOrgRank] = rank; // SaveOrgMember
	UpdatePlayerData(targetid, "orgRank", PI[targetid][pOrgRank]);

	format(CHAT_GLOBAL, sizeof (CHAT_GLOBAL), "%s изменил ваш ранг в организации на \"%s\".",
		player_name[playerid], OrganizationRank[organization_id][rank - 1]
	);
	ErrorMessage(targetid, CHAT_GLOBAL), CHAT_GLOBAL[0] = EOS;

	format(CHAT_GLOBAL, sizeof (CHAT_GLOBAL), "Вы изменили %s ранг в организации на \"%s\".",
		player_name[targetid], OrganizationRank[organization_id][rank - 1]
	);
	ErrorMessage(playerid, CHAT_GLOBAL), CHAT_GLOBAL[0] = EOS;

	return true;
}
CMD:orights(playerid, params[]) {
	new organization_id = PI[playerid][pOrgMember];
	if (!organization_id)
		return ErrorMessage(playerid, "Вы не состоите в пользовательской организации.");
	if (!GetString(player_name[playerid], OrganizationInfo[organization_id][orgLeader])) 
		return ErrorMessage(playerid, "У вас нет доступа к данной команде!");
	new targetid;
	if (sscanf(params, "u", targetid)) 
		return SendEsp(playerid, "/orights [id игрока]");
	if (!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
		return ErrorMessage(playerid, not_id);
	if (PI[targetid][pOrgMember] != organization_id)
		return ErrorMessage(playerid, "Игрок не состоит в вашей пользовательской организации.");

	SetPVarInt(playerid, "organizationTempID", targetid);
	org_ShowMenu(playerid, ORG_MENU_ACCESS);

	return true;
}
CMD:ouninvite(playerid, params[]) {
	new organization_id = PI[playerid][pOrgMember];
	if (!organization_id)
		return ErrorMessage(playerid, "Вы не состоите в пользовательской организации.");
	if (!GetString(player_name[playerid], OrganizationInfo[organization_id][orgLeader]) && !PI[playerid][pOrgAccess][ORG_ACCESS_CMD_UNINVITE]) 
		return ErrorMessage(playerid, "У вас нет доступа к данной команде!");
	new targetid;
	if (sscanf(params, "u", targetid))
		return SendEsp(playerid, "/ouninvite [id игрока]");

	if (!IsPlayerConnected(targetid) || targetid == INVALID_PLAYER_ID)
		return ErrorMessage(playerid, not_id);
	if (PI[targetid][pOrgMember] != organization_id)
		return ErrorMessage(playerid, "Игрок не состоит в вашей пользовательской организации.");

	PI[targetid][pOrgRank] = 0;
	PI[targetid][pOrgMember] = 0; // SaveOrgMember

	UpdatePlayerData(playerid, "orgMember", 0);
	UpdatePlayerData(playerid, "orgRank", 0);

	format(CHAT_GLOBAL, sizeof (CHAT_GLOBAL), "%s уволил Вас из пользовательской организации - \"%s\".",
		player_name[playerid], OrganizationInfo[organization_id][orgName]
	);
	ErrorMessage(targetid, CHAT_GLOBAL), CHAT_GLOBAL[0] = EOS;

	format(CHAT_GLOBAL, sizeof (CHAT_GLOBAL), "Вы уволили %s из пользовательской организации - \"%s\".",
		player_name[targetid], OrganizationInfo[organization_id][orgName]
	);
	ErrorMessage(playerid, CHAT_GLOBAL), CHAT_GLOBAL[0] = EOS;

	return true;
}
CMD:orgedit(playerid) {
	if (PI[playerid][pAdmin] < 5 || dostup[playerid] == 0) 
		return true;
	org_ShowMenu(playerid, ORG_MENU_EDIT_MAIN);
	return true;
}
CMD:org(playerid, params[]) {
	if (PI[playerid][pAdmin] < 3 || dostup[playerid] == 0) 
		return true;
	new organization_id;
	if (sscanf(params, "i", organization_id) || !(1 <= organization_id <= TOTAL_ORGANIZATIONS))
		return SendEsp(playerid, "/org [id организации]");

	if (OrganizationInfo[organization_id][orgID] == 0)
		return ErrorMessage(playerid, "Данная организация была удалена.");
	PI[playerid][pOrgMember] = organization_id;
	PI[playerid][pOrgRank] = OrganizationInfo[organization_id][orgRankCount];

	UpdatePlayerData(playerid, "orgMember", OrganizationInfo[organization_id][orgID]);
	UpdatePlayerData(playerid, "orgRank", PI[playerid][pOrgRank]);

	SendOk(playerid, "Вы успешно изменили свою пользовательскую организацию.");
	return true;
}
stock SaveOrganization(organization_id) {
	if (!(1 <= organization_id < MAX_ORGANIZATONS) || OrganizationInfo[organization_id][orgID] == 0) 
		return;
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE "TABLE_ORGANIZATIONS" SET \
		name='%e',leader='%e',color=%i,interior=%i,rank_amount=%i,message='%e',\
		interior_door_type=%i,room_door_type=%i,warehouse_rank=%i,org_access='%i,%i,%i,%i',\
		enter_pos_x='%.3f',enter_pos_y='%.3f',enter_pos_z='%.3f',\
		exit_pos_x='%.3f',exit_pos_y='%.3f',exit_pos_z='%.3f',exit_pos_fa='%.3f',\
		room_interior=%i, room_enter_pos_x='%.3f',room_enter_pos_y='%.3f',room_enter_pos_z='%.3f',\
		room_exit_pos_x='%.3f',room_exit_pos_y='%.3f',room_exit_pos_z='%.3f',room_exit_pos_fa='%.3f',\
		rank_name_1='%e',rank_name_2='%e',rank_name_3='%e',rank_name_4='%e',rank_name_5='%e',\
		rank_name_6='%e',rank_name_7='%e',rank_name_8='%e',rank_name_9='%e',rank_name_10='%e' \
		WHERE id = %d LIMIT 1",
		OrganizationInfo[organization_id][orgName], OrganizationInfo[organization_id][orgLeader],
		OrganizationInfo[organization_id][orgColor], OrganizationInfo[organization_id][orgInterior],
		OrganizationInfo[organization_id][orgRankCount], OrganizationInfo[organization_id][orgMessage],

		OrganizationInfo[organization_id][orgInteriorDoorType], OrganizationInfo[organization_id][orgRoomInteriorDoorType],
		OrganizationInfo[organization_id][orgWarehouseRank],

		OrganizationInfo[organization_id][orgAccess][0], OrganizationInfo[organization_id][orgAccess][1],
		OrganizationInfo[organization_id][orgAccess][2], OrganizationInfo[organization_id][orgAccess][3],

		OrganizationInfo[organization_id][orgEnterPos][0], OrganizationInfo[organization_id][orgEnterPos][1],
		OrganizationInfo[organization_id][orgEnterPos][2],

		OrganizationInfo[organization_id][orgExitPos][0], OrganizationInfo[organization_id][orgExitPos][1],
		OrganizationInfo[organization_id][orgExitPos][2], OrganizationInfo[organization_id][orgExitPos][3],

		OrganizationInfo[organization_id][orgRoomInterior], OrganizationInfo[organization_id][orgRoomEnterPos][0], 
		OrganizationInfo[organization_id][orgRoomEnterPos][1], OrganizationInfo[organization_id][orgRoomEnterPos][2],

		OrganizationInfo[organization_id][orgRoomExitPos][0], OrganizationInfo[organization_id][orgRoomExitPos][1],
		OrganizationInfo[organization_id][orgRoomExitPos][2], OrganizationInfo[organization_id][orgRoomExitPos][3],

		OrganizationRank[organization_id][0], OrganizationRank[organization_id][1], OrganizationRank[organization_id][2],
		OrganizationRank[organization_id][3], OrganizationRank[organization_id][4], OrganizationRank[organization_id][5],
		OrganizationRank[organization_id][6], OrganizationRank[organization_id][7], OrganizationRank[organization_id][8],
		OrganizationRank[organization_id][9], 

		OrganizationInfo[organization_id][orgID]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""); // print(MYSQL_GLOBAL);

	MYSQL_GLOBAL[0] = EOS;
}
stock SaveOrganizationWarehouse(organization_id) {
	if (!(1 <= organization_id < MAX_ORGANIZATONS) || OrganizationInfo[organization_id][orgID] == 0) 
		return;
	MYSQL_GLOBAL[0] = EOS;

	mysql_format(connects, MYSQL_GLOBAL, sizeof(MYSQL_GLOBAL), "UPDATE "TABLE_ORGANIZATIONS" SET \
		`warehouse_items`='\
		%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,\
		%i,%i,%i,%i,%i,%i,%i,%i,\
		%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,%i,\
		%i,%i,%i' \
		WHERE id = %d LIMIT 1",
		OrganizationInfo[organization_id][orgWarehouseItemAmount][0], OrganizationInfo[organization_id][orgWarehouseItemAmount][1],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][2], OrganizationInfo[organization_id][orgWarehouseItemAmount][3],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][4], OrganizationInfo[organization_id][orgWarehouseItemAmount][5],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][6], OrganizationInfo[organization_id][orgWarehouseItemAmount][7],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][8], OrganizationInfo[organization_id][orgWarehouseItemAmount][9],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][10], OrganizationInfo[organization_id][orgWarehouseItemAmount][11],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][12], 

		OrganizationInfo[organization_id][orgWarehouseItemAmount][13],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][14], OrganizationInfo[organization_id][orgWarehouseItemAmount][15],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][16], OrganizationInfo[organization_id][orgWarehouseItemAmount][17],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][18], OrganizationInfo[organization_id][orgWarehouseItemAmount][19],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][20],

		OrganizationInfo[organization_id][orgWarehouseItemAmount][21], OrganizationInfo[organization_id][orgWarehouseItemAmount][22],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][23], OrganizationInfo[organization_id][orgWarehouseItemAmount][24],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][25], OrganizationInfo[organization_id][orgWarehouseItemAmount][26],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][27], OrganizationInfo[organization_id][orgWarehouseItemAmount][28],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][29], OrganizationInfo[organization_id][orgWarehouseItemAmount][30],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][31], OrganizationInfo[organization_id][orgWarehouseItemAmount][32],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][33], 

		OrganizationInfo[organization_id][orgWarehouseItemAmount][34], OrganizationInfo[organization_id][orgWarehouseItemAmount][35],
		OrganizationInfo[organization_id][orgWarehouseItemAmount][36],

		OrganizationInfo[organization_id][orgID]
	);
	mysql_tquery(connects, MYSQL_GLOBAL, "", ""); // print(MYSQL_GLOBAL);

	MYSQL_GLOBAL[0] = EOS;
}
stock SendOrganizationMessage(organization_id, color, const str[]) {
	foreach(new i: Player) {
		if (!TI[i][tLogin] || AntiCheatIsKickedWithDecync(i)) continue;

		if (PI[i][pSettings][1] && PI[i][pMember] == organization_id) { 
			SendClientMessage(i, color, str);
		}
	}
}
static orgCollectPlantFlood[MAX_PLAYERS];
stock org_CollectPlant(playerid, plant_id) {
	if (orgCollectPlantFlood[playerid] > GetTickCount()) 
		return false;
	if (OrganizationPlantInfo[plant_id][orgPlantProcess] < 100.0) {
		ErrorMessage(playerid, "Дождитесь пока куст вырастет!");
		return false;
	}
	new organization_id = PI[playerid][pOrgMember];
	if (OrganizationPlantInfo[plant_id][orgPlantWorld] != organization_id) {
		ErrorMessage(playerid, "Вы не можете взаимодействовать с данным кустом!");
		return false;
	}
	if (!OrganizationPlantInfo[plant_id][orgPlantAmount]) 
		return false;
	if (!GivePlayerItem(playerid, 166, 1)) 
		return false;
	orgCollectPlantFlood[playerid] = GetTickCount() + 1500;

	OrganizationPlantInfo[plant_id][orgPlantAmount]--;
	GameTextForPlayer(playerid, "~y~+1", 1000, 6);
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);

	if (!OrganizationPlantInfo[plant_id][orgPlantAmount]) {
		OrganizationPlantInfo[plant_id][orgPlantStatus] = ORG_PLANT_STATUS_NONE;
		OrganizationPlantInfo[plant_id][orgPlantProcess] = 0.0;

		DestroyDynamicObject(OrganizationPlantInfo[plant_id][orgPlantObjectID]);
		DestroyDynamic3DTextLabel(OrganizationPlantInfo[plant_id][orgPlantTextID]);

		OrganizationInfo[organization_id][orgPlantSlot][OrganizationPlantInfo[plant_id][orgPlantPosition]] = 0;
		OrganizationPlantInfo[plant_id][orgPlantAmount] = 0;
		Iter_Remove(orgPlants, plant_id);

		SendOk(playerid, "Вы успешно собрали все ростки с куста. Чтобы обработать, подойдите к рабочему столу.");
	}
	return true;
}
stock org_CreatePlant(playerid, plant_position_id) {
	if (!ItemCounts(playerid, 165)) {
		ErrorMessage(playerid, "У вас нет семян марихуаны!");
		return false;
	}
	new plants_amount = Iter_Count(orgPlants);

	if (plants_amount >= MAX_ORGANIZATONS_PLANTS) {
		ErrorMessage(playerid, "В данный момент нельзя посадить семена. (максимальное количество)");
		return false;
	}
	new plant_id = Iter_Free(orgPlants), organization_id = PI[playerid][pOrgMember];

	if (!organization_id) {
		ErrorMessage(playerid, "Вы не состоите в организации.");
		return false;
	}
	if (!OrganizationInfo[organization_id][orgAccess][ORG_ACCESS_CREATE_DRUGS]) {
		ErrorMessage(playerid, "У вашей организации закрыт доступ к производству наркотических веществ.");
		return false;
	}
	new organization_interiorid = OrganizationInfo[organization_id][orgRoomInterior] - 1;

	if (!organization_interiorid) 
		return false;

	if (GetPlayerVirtualWorld(playerid) != organization_id || 
		GetPlayerInterior(playerid) != OrganizationRoomInteriorInfo[organization_interiorid][intInterior]) {
		ErrorMessage(playerid, "Вы должны находиться в рабочем помещении своей пользовательской организации.");
		return false;
	}
	if (OrganizationInfo[organization_id][orgPlantSlot][plant_position_id]) 
		return false;
	GivePlayerItem(playerid, 165, -1);

	OrganizationInfo[organization_id][orgPlantSlot][plant_position_id] = plant_id + 1;
	format(OrganizationPlantInfo[plant_id][orgPlantOwner], MAX_PLAYER_NAME + 2, player_name[playerid]);
	
	OrganizationPlantInfo[plant_id][orgPlantInterior] = GetPlayerInterior(playerid);
	OrganizationPlantInfo[plant_id][orgPlantWorld] = GetPlayerVirtualWorld(playerid);


	OrganizationPlantInfo[plant_id][orgPlantProcess] = 0.0;
	OrganizationPlantInfo[plant_id][orgPlantStatus] = ORG_PLANT_STATUS_CREATED;

	OrganizationPlantInfo[plant_id][orgPlantPosition] = plant_position_id;
	OrganizationPlantInfo[plant_id][orgPlantPos] = OrganizationIntPlantPos[plant_position_id];

	OrganizationPlantInfo[plant_id][orgPlantObjectID] = CreateDynamicObject(19473, 
		OrganizationPlantInfo[plant_id][orgPlantPos][0], OrganizationPlantInfo[plant_id][orgPlantPos][1],
		OrganizationPlantInfo[plant_id][orgPlantPos][2] - ORG_PLANT_MINUS_Z(100.0 - OrganizationPlantInfo[plant_id][orgPlantProcess]), 
		0.000000, 0.000000, 0.000000, 
		OrganizationPlantInfo[plant_id][orgPlantWorld], OrganizationPlantInfo[plant_id][orgPlantInterior], 
		-1, 50.00, 50.00
	);
	OrganizationPlantInfo[plant_id][orgPlantTextID] = CreateDynamic3DTextLabel(" ", 0xFFFFFFFF,
		OrganizationPlantInfo[plant_id][orgPlantPos][0], OrganizationPlantInfo[plant_id][orgPlantPos][1],
		OrganizationPlantInfo[plant_id][orgPlantPos][2] + 1.5, 3.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 
		0/*(testlos)*/, OrganizationPlantInfo[plant_id][orgPlantWorld], OrganizationPlantInfo[plant_id][orgPlantInterior], -1
	);


	org_UpdatePlantText(plant_id);

	SetPlayerFaceToPoint(playerid, OrganizationPlantInfo[plant_id][orgPlantPos][0], OrganizationPlantInfo[plant_id][orgPlantPos][1]);
	ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 2, 0, 0, 0, 0, 0);
	SendOk(playerid, "Вы успешно посадили семена конопли, дождитесь когда куст вырастет.");

	Iter_Add(orgPlants, plant_id);
	Streamer_Update(playerid);

	return true;
}
stock org_UpdatePlantText(plant_id) {
	if (OrganizationPlantInfo[plant_id][orgPlantStatus] != ORG_PLANT_STATUS_CREATED) 
		return;
	if (OrganizationPlantInfo[plant_id][orgPlantProcess] < 100.0) {
		format(COMMAND_GLOBAL, sizeof(COMMAND_GLOBAL), 
			""P"Конопля\n \n"W"Посадил: "G"%s\n"W"Статус роста: "P"%.0f%%/100%%",
			OrganizationPlantInfo[plant_id][orgPlantOwner], OrganizationPlantInfo[plant_id][orgPlantProcess]
		);
	}
	else {
		format(COMMAND_GLOBAL, sizeof(COMMAND_GLOBAL), 
			""P"Конопля\n \n"W"Посадил: "G"%s\n"W"Статус роста: "P"%.0f%%/100%%\n \n"W"Нажмите "P"\"H\""W", чтобы собрать",
			OrganizationPlantInfo[plant_id][orgPlantOwner], OrganizationPlantInfo[plant_id][orgPlantProcess]
		);
	}
	UpdateDynamic3DTextLabelText(OrganizationPlantInfo[plant_id][orgPlantTextID], 0xFFFFFFFF, COMMAND_GLOBAL), COMMAND_GLOBAL[0] = EOS;
}
stock org_MakegunMenu(playerid) {
	new materialAmount[sizeof (OrganizationMakegunInfo)];

	for (new slotid = 0; slotid < (INVENTORY_MAX_PAGE_SLOTS * 3 + INVENTORY_MAX_PAGE_USE_SLOTS * 3); slotid++) {
		for (new weapon_id = 0; weapon_id < sizeof (OrganizationMakegunInfo); weapon_id++) {
			if (PI[playerid][pItemsID][slotid] != weapon_id + 168) continue;
			materialAmount[weapon_id] += PI[playerid][pItemsAmount][slotid];
		}
	}
	format(STRING_GLOBAL, sizeof (STRING_GLOBAL), "\
		"P"Название\t"P"Количество материала\n\
		"P"1. "W"%s\t"G"[%i / %i]\n\
		"P"2. "W"%s\t"G"[%i / %i]\n\
		"P"3. "W"%s\t"G"[%i / %i]\n\
		"P"4. "W"%s\t"G"[%i / %i]\n\
		"P"5. "W"%s\t"G"[%i / %i]\n\
		"P"6. "W"%s\t"G"[%i / %i]\n\
		"P"7. "W"%s\t"G"[%i / %i]\n\
		"P"8. "W"%s\t"G"[%i / %i]\n\
		"P"9. "W"%s\t"G"[%i / %i]\n\
		"P"10. "W"%s\t"G"[%i / %i]\n\
		"P"11. "W"%s\t"G"[%i / %i]\n\
		"P"12. "W"%s\t"G"[%i / %i]\n\
		"P"13. "W"%s\t"G"[%i / %i]",
		OrganizationMakegunInfo[0][orgGunName], materialAmount[0], OrganizationMakegunInfo[0][orgMaterialAmount],
		OrganizationMakegunInfo[1][orgGunName], materialAmount[1], OrganizationMakegunInfo[1][orgMaterialAmount],
		OrganizationMakegunInfo[2][orgGunName], materialAmount[2], OrganizationMakegunInfo[2][orgMaterialAmount],
		OrganizationMakegunInfo[3][orgGunName], materialAmount[3], OrganizationMakegunInfo[3][orgMaterialAmount],
		OrganizationMakegunInfo[4][orgGunName], materialAmount[4], OrganizationMakegunInfo[4][orgMaterialAmount],
		OrganizationMakegunInfo[5][orgGunName], materialAmount[5], OrganizationMakegunInfo[5][orgMaterialAmount],
		OrganizationMakegunInfo[6][orgGunName], materialAmount[6], OrganizationMakegunInfo[6][orgMaterialAmount],
		OrganizationMakegunInfo[7][orgGunName], materialAmount[7], OrganizationMakegunInfo[7][orgMaterialAmount],
		OrganizationMakegunInfo[8][orgGunName], materialAmount[8], OrganizationMakegunInfo[8][orgMaterialAmount],
		OrganizationMakegunInfo[9][orgGunName], materialAmount[9], OrganizationMakegunInfo[9][orgMaterialAmount],
		OrganizationMakegunInfo[10][orgGunName], materialAmount[10], OrganizationMakegunInfo[10][orgMaterialAmount],
		OrganizationMakegunInfo[11][orgGunName], materialAmount[11], OrganizationMakegunInfo[11][orgMaterialAmount],
		OrganizationMakegunInfo[12][orgGunName], materialAmount[12], OrganizationMakegunInfo[12][orgMaterialAmount]
	);
	ShowPlayerDialog(playerid, D_ORG_MAKEGUN, DIALOG_STYLE_TABLIST_HEADERS, ""P"Создание оружия", STRING_GLOBAL, "Выбрать", "Отмена");
}
CMD:org_int(playerid, params[]) {
	if (PI[playerid][pAdmin] < 2 || dostup[playerid] == 0) 
		return true;
	new org_interiorid;
	if (sscanf(params, "i", org_interiorid) || !(1 <= org_interiorid <= sizeof (OrganizationInteriorInfo)))
		return SendEsp(playerid, "/org_int [interior ID]"); 

	org_interiorid--;

	SetPlayerPosAC(playerid,
		OrganizationInteriorInfo[org_interiorid][intEnterPos][0],
		OrganizationInteriorInfo[org_interiorid][intEnterPos][1],
		OrganizationInteriorInfo[org_interiorid][intEnterPos][2],
		2, OrganizationInteriorInfo[org_interiorid][intInterior]
	);
	SetPlayerFacingAngle(playerid, OrganizationInteriorInfo[org_interiorid][intEnterPos][3]);

	new freeze_time = OrganizationInteriorInfo[org_interiorid][intFreezeTime];
	if (freeze_time) FreezePlayerForTime(playerid, freeze_time);

	return true;
}