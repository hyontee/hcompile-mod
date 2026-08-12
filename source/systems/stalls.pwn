#if defined _stalls_inc
	#endinput
#endif
#define _stalls_inc

#define MAX_STALL	(50)

enum {
	STALL_TYPE_NONE = 0,
	STALL_TYPE_FREE,
}
enum STALL_MENU_e {
	stallMenuType,
	stallMenuName[32],
	stallMenuSatiety,
	stallMenuPrice,
}
new const StallMenuInfo[][STALL_MENU_e] = {
	// { type, name[], satietyLevel, price }
	/*{ STALL_TYPE_FREE, "Кола", 100, 0 },
	{ STALL_TYPE_FREE, "Хот-Дог", 1000, 0 },*/
	{ STALL_TYPE_FREE, "Кола", 1000, 0 },
	{ STALL_TYPE_FREE, "Спрайт", 1000, 0 },
	{ STALL_TYPE_FREE, "Хот-Дог", 1000, 0 }
};
enum STALL_e {
	stallID,
	stallType,
	stallObjectID[2],
	stallActor,
	stallArea,
	stallPickup,
	Text3D:stallText,
}
new StallsInfo[MAX_STALL][STALL_e];

new  bool: stall_menu[MAX_PLAYERS] = false;

stock CreateStall(id, type, Float:x, Float:y, Float:z, Float:angle, Float:stream_distance = 100.0) {
	new Float:obj_s_Pos[6];
	StallsInfo[id][stallType] = type;

	StallsInfo[id][stallObjectID][0] = CreateDynamicObject(1340, x, y, z, 0.000, 0.000, angle, 0, 0, -1, stream_distance); // MainObj
	SetDynamicObjectMaterial(StallsInfo[id][stallObjectID][0], 5, 14584, "ab_abbatoir01", "ab_vent1", 0x00000000);
	SetDynamicObjectMaterial(StallsInfo[id][stallObjectID][0], 6, 17524, "lae2bigblock", "venfood01_law", 0x00000000);

	AttachPosToDynamicObject(StallsInfo[id][stallObjectID][0], 0.440759, 0.022563, 0.806289, 0.000000, 0.000000, 0.000000,
		obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2], obj_s_Pos[3], obj_s_Pos[4], obj_s_Pos[5]
	);
	StallsInfo[id][stallObjectID][1] = CreateDynamicObject(19476, 
		obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2], obj_s_Pos[3], obj_s_Pos[4], obj_s_Pos[5], 0, 0, -1, stream_distance
	); 
	SetDynamicObjectMaterial(StallsInfo[id][stallObjectID][1], 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterialText(StallsInfo[id][stallObjectID][1], 0, "БЫСТРАЯ ЕДА", 80, "Trebuchet MS", 30, 1, 0xFFFFFFFF, 0xFF333333, 1);

	AttachPosToDynamicObject(StallsInfo[id][stallObjectID][0], -0.990000, -0.004000, -0.124000/*99.876300*/, 0.0, 0.0, 270.0,
		obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2], obj_s_Pos[3], obj_s_Pos[4], obj_s_Pos[5]
	);
	StallsInfo[id][stallActor] = CreateDynamicActor(142, 
		obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2] + 0.10, obj_s_Pos[5], .worldid = 0, .interiorid = 0
	);
	//printf("(acter x = %0.4f y = %0.4f z = %0.4f a = %0.4f)", obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2] + 1.10, obj_s_Pos[5]);
	AttachPosToDynamicObject(StallsInfo[id][stallObjectID][0], 1.0502, 0.0315, -0.1237, 0.0, 0.0, 0.0,
		obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2], obj_s_Pos[3], obj_s_Pos[4], obj_s_Pos[5]
	);
	StallsInfo[id][stallPickup] = CreateDynamicPickup(1239, 23, 
		obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2], .worldid = 0, .interiorid = 0
	);
	
	t_string = "Бесплатная еда";

	StallsInfo[id][stallText] = CreateDynamic3DTextLabel(t_string, 0xFFFFFFFF, 
		obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2] + 0.5, 8.00, .testlos = 1, .worldid = 0, .interiorid = 0
	);
	t_string[0] = EOS;

	StallsInfo[id][stallArea] = CreateDynamicSphere(obj_s_Pos[0], obj_s_Pos[1], obj_s_Pos[2], 0.5, .worldid = 0, .interiorid = 0);
	SetDynamicAreaType(StallsInfo[id][stallArea], AREA_TYPE_STALL, id);
}
stock DestroyStall(id) {
	if (StallsInfo[id][stallType] == STALL_TYPE_NONE) return;
	for (new i = 0; i < 2; i++) DestroyDynamicObject(StallsInfo[id][stallObjectID][i]);
	DestroyDynamicPickup(StallsInfo[id][stallPickup]);
	DestroyDynamic3DTextLabel(StallsInfo[id][stallText]);
	DestroyDynamicActor(StallsInfo[id][stallActor]);
	DestroyDynamicArea(StallsInfo[id][stallArea]);
}
stock AttachPosToDynamicObject(objectid, Float:off_x, Float:off_y, Float:off_z, Float:rot_x, Float:rot_y, Float:rot_z, &Float:X, &Float:Y, &Float:Z, &Float:RX, &Float:RY, &Float:RZ) {
	new 
		Float:sin[3], Float:cos[3], 
		Float:pos_x, Float:pos_y, Float:pos_z, 
		Float:pos_rx, Float:pos_ry, Float:pos_rz;

	GetDynamicObjectPos(objectid, pos_x, pos_y, pos_z);
	GetDynamicObjectRot(objectid, pos_rx, pos_ry, pos_rz);

	AOP_FloatEulerFix(pos_rx, pos_ry, pos_rz);

	cos[0] = floatcos(pos_rx, degrees); cos[1] = floatcos(pos_ry, degrees); cos[2] = floatcos(pos_rz, degrees); sin[0] = floatsin(pos_rx, degrees); sin[1] = floatsin(pos_ry, degrees); sin[2] = floatsin(pos_rz, degrees);
	pos_x = pos_x + off_x * cos[1] * cos[2] - off_x * sin[0] * sin[1] * sin[2] - off_y * cos[0] * sin[2] + off_z * sin[1] * cos[2] + off_z * sin[0] * cos[1] * sin[2];
	pos_y = pos_y + off_x * cos[1] * sin[2] + off_x * sin[0] * sin[1] * cos[2] + off_y * cos[0] * cos[2] + off_z * sin[1] * sin[2] - off_z * sin[0] * cos[1] * cos[2];
	pos_z = pos_z - off_x * cos[0] * sin[1] + off_y * sin[0] + off_z * cos[0] * cos[1];
	pos_rx = asin(cos[0] * cos[1]); pos_ry = atan2(sin[0], cos[0] * sin[1]) + rot_z; pos_rz = atan2(cos[1] * cos[2] * sin[0] - sin[1] * sin[2], cos[2] * sin[1] - cos[1] * sin[0] * -sin[2]);
	cos[0] = floatcos(pos_rx, degrees); cos[1] = floatcos(pos_ry, degrees); cos[2] = floatcos(pos_rz, degrees); sin[0] = floatsin(pos_rx, degrees); sin[1] = floatsin(pos_ry, degrees); sin[2] = floatsin(pos_rz, degrees);
	pos_rx = asin(cos[0] * sin[1]); pos_ry = atan2(cos[0] * cos[1], sin[0]); pos_rz = atan2(cos[2] * sin[0] * sin[1] - cos[1] * sin[2], cos[1] * cos[2] + sin[0] * sin[1] * sin[2]);
	cos[0] = floatcos(pos_rx, degrees); cos[1] = floatcos(pos_ry, degrees); cos[2] = floatcos(pos_rz, degrees); sin[0] = floatsin(pos_rx, degrees); sin[1] = floatsin(pos_ry, degrees); sin[2] = floatsin(pos_rz, degrees);
	pos_rx = atan2(sin[0], cos[0] * cos[1]) + rot_x; pos_ry = asin(cos[0] * sin[1]); pos_rz = atan2(cos[2] * sin[0] * sin[1] + cos[1] * sin[2], cos[1] * cos[2] - sin[0] * sin[1] * sin[2]);
	cos[0] = floatcos(pos_rx, degrees); cos[1] = floatcos(pos_ry, degrees); cos[2] = floatcos(pos_rz, degrees); sin[0] = floatsin(pos_rx, degrees); sin[1] = floatsin(pos_ry, degrees); sin[2] = floatsin(pos_rz, degrees);
	pos_rx = asin(cos[1] * sin[0]); pos_ry = atan2(sin[1], cos[0] * cos[1]) + rot_y; pos_rz = atan2(cos[0] * sin[2] - cos[2] * sin[0] * sin[1], cos[0] * cos[2] + sin[0] * sin[1] * sin[2]);

	X = pos_x, Y = pos_y, Z = pos_z;
	RX = pos_rx, RY = pos_ry, RZ = pos_rz;
}
stock AOP_FloatEulerFix(&Float:rot_x, &Float:rot_y, &Float:rot_z) {
	AOP_FloatGetRemainder(rot_x, rot_y, rot_z);
	if (
		(!floatcmp(rot_x, 0.0) || !floatcmp(rot_x, 360.0)) &&
		(!floatcmp(rot_y, 0.0) || !floatcmp(rot_y, 360.0))
	) rot_y = 0.00000002;

	return true;
}
stock AOP_FloatGetRemainder(&Float:rot_x, &Float:rot_y, &Float:rot_z) {
	AOP_FloatRemainder(rot_x, 360.0);
	AOP_FloatRemainder(rot_y, 360.0);
	AOP_FloatRemainder(rot_z, 360.0);

	return true;
}
stock AOP_FloatRemainder(&Float:remainder, Float:value) {
	if (remainder >= value) {
		while (remainder >= value) {
			remainder = remainder - value;
		}
	}
	else if (remainder < 0.0) {
		while (remainder < 0.0) {
			remainder = remainder + value;
		}
	}
	return true;
}
stock ShowStallMenu(playerid) {
	/*new id = pTemp[playerid][tStallID];
	if (!(0 <= id < sizeof (StallsInfo)) || StallsInfo[id][stallType] == STALL_TYPE_NONE) 
		return;
	t_string[0] = EOS;

	for (new i = 0, idx = 0; i < sizeof (StallMenuInfo); i++) {
		if (StallMenuInfo[i][stallMenuType] != StallsInfo[id][stallType]) 
			continue;
		if (!StallMenuInfo[i][stallMenuPrice]) {
			format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[Бесплатно]\n", t_string, idx, 
				StallMenuInfo[i][stallMenuName]
			);
		} else {
			format(t_string, sizeof (t_string), "%s"colwhi"[%i] %s\t"collime"[$%i]\n", t_string, idx, 
				StallMenuInfo[i][stallMenuName], StallMenuInfo[i][stallMenuPrice]
			);
		}
		playerListItem[playerid][idx++] = i;
	}
	ShowPlayerDialog(playerid, D_STALL_MENU, DIALOG_STYLE_TABLIST, ""colserver"Лавка: "colwhi"Покупка еды", t_string, "Выбрать", "Отмена");

	t_string[0] = EOS;*/

	ShowMenuStall(playerid);

}

stock HideMenuStall(playerid)
{
	stall_menu[playerid] = false;

	for(new i; i < sizeof (food_TD); i++) {
	TextDrawHideForPlayer(playerid, food_TD[i]); 
	} 	
	return CancelSelectTextDraw(playerid);	
}

stock ShowMenuStall(playerid)
{
	stall_menu[playerid] = true;

	for(new i; i < sizeof (food_TD); i++) {
	TextDrawShowForPlayer(playerid, food_TD[i]); 
	} 		
	return SelectTextDraw(playerid, COLOR_SERVER);
}
