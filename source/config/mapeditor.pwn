/*
	> commands:
		/sobject(sel) [id] - выделить объект
		/cobject [id] - создать объект
		/dobject [id] - удалить объект
		/ogoto [id] - телепортироваться к объекту
		/e(dit)object - редактирование объекта
		/rz /rx /ry [angle] - повороты по осям
		/oz /ox /oy [value] - перемещение по осям
		/otext [distance] - показ индексов объектов
		/odeleteobjects - удалить все объекты
		/oexportobjects - экспорт всех объектов
		/aobject - для собейта /mtamap
*/
#if defined _mapeditor_included
	#endinput
#endif
#define _mapeditor_included

#define MAX_MAP_EDITOR_OBJECT		100

alias:sobject("sel", "selobject");
alias:eobject("editobject", "eo");
alias:cobject("createobject", "co");////
alias:dobject("deleteobject", "destroyobject", "dob");

enum ME_enum {
	objectID,
	objectModel,
	objectInterior,
	objectWorld,
	Float:objectPosME[6],
	Text3D:objectText
};
static MAP_EDITOR_TOTAL = 0,
	MapEditorInfo[MAX_MAP_EDITOR_OBJECT][ME_enum],

	Float:ME_draw_distance = 0.01,
	bool:ME_text_arrayed = false
;
stock CreateMapEditorObject(playerid, modelid, Float:x = 0.0, Float:y = 0.0, Float:z = 0.0, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0) {
	new free_objectid = MAX_MAP_EDITOR_OBJECT;
	for (free_objectid = 0; free_objectid < MAX_MAP_EDITOR_OBJECT; free_objectid++)
		if (0 == MapEditorInfo[free_objectid][objectID]) break;

	if (free_objectid == MAX_MAP_EDITOR_OBJECT)
		return SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Превышен лимит объектов (максимум: %i).", MAX_MAP_EDITOR_OBJECT);

	MapEditorInfo[free_objectid][objectPosME][0] = x;
	MapEditorInfo[free_objectid][objectPosME][1] = y;
	MapEditorInfo[free_objectid][objectPosME][2] = z;

	if ((x == 0.0) && (y == 0.0) && (z == 0.0)) {
		GetPlayerPos(playerid,
			MapEditorInfo[free_objectid][objectPosME][0], MapEditorInfo[free_objectid][objectPosME][1], MapEditorInfo[free_objectid][objectPosME][2]
		);
	}
	MapEditorInfo[free_objectid][objectID] = CreateDynamicObject(
		(MapEditorInfo[free_objectid][objectModel] = modelid),
		MapEditorInfo[free_objectid][objectPosME][0], MapEditorInfo[free_objectid][objectPosME][1], MapEditorInfo[free_objectid][objectPosME][2],
		(MapEditorInfo[free_objectid][objectPosME][3] = rx),
		(MapEditorInfo[free_objectid][objectPosME][4] = ry),
		(MapEditorInfo[free_objectid][objectPosME][5] = rz),
		(MapEditorInfo[free_objectid][objectWorld] = GetPlayerVirtualWorld(playerid)),
		(MapEditorInfo[free_objectid][objectInterior] = GetPlayerInterior(playerid)),
		-1, 200.00, 200.00
	);
	new
		objectWorlds[1],
		objectInteriors[1],
		ME_players[1],
		ME_areas[1]
	;
	objectWorlds[0] = MapEditorInfo[free_objectid][objectWorld];
	objectInteriors[0] = MapEditorInfo[free_objectid][objectInterior];
	ME_players[0] = ME_areas[0] = -1;
	new ME_str[24];
	format(ME_str, sizeof(ME_str), "Ind: {33DD11}%i", free_objectid);
	MapEditorInfo[free_objectid][objectText] = CreateDynamic3DTextLabelEx(ME_str, 0xFF8800FF,
		MapEditorInfo[free_objectid][objectPosME][0], MapEditorInfo[free_objectid][objectPosME][1], MapEditorInfo[free_objectid][objectPosME][2],
		ME_draw_distance, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 100.0,
		objectWorlds, objectInteriors, ME_players, ME_areas, 0
	);
	if (free_objectid >= MAP_EDITOR_TOTAL)
		MAP_EDITOR_TOTAL++;

	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
	SetPVarInt(playerid, "ME_object_id", free_objectid);
	SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Вы создали объект ID: %i [Модель: %i].", free_objectid, modelid);
	return MapEditorInfo[free_objectid][objectID];
}
stock DestroyMapEditorObject(playerid, meobjectid) {
	if (0 == MapEditorInfo[meobjectid][objectID] || !IsValidDynamicObject(MapEditorInfo[meobjectid][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");

	DestroyDynamicObject(MapEditorInfo[meobjectid][objectID]);
	DestroyDynamic3DTextLabel(MapEditorInfo[meobjectid][objectText]);

	MapEditorInfo[meobjectid][objectID] =
	MapEditorInfo[meobjectid][objectModel] =
	MapEditorInfo[meobjectid][objectWorld] =
	MapEditorInfo[meobjectid][objectInterior] = 0;

	MapEditorInfo[meobjectid][objectPosME][0] = MapEditorInfo[meobjectid][objectPosME][1] = MapEditorInfo[meobjectid][objectPosME][2] =
	MapEditorInfo[meobjectid][objectPosME][3] = MapEditorInfo[meobjectid][objectPosME][4] = MapEditorInfo[meobjectid][objectPosME][5] = 0.0;

	if (playerid != INVALID_PLAYER_ID) {
		Streamer_Update(playerid);
		SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Вы удалили объект ID: %i.", meobjectid);
	}
	return meobjectid;
}
stock UpdateMapEditorObject(meobjectid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	if (0 == MapEditorInfo[meobjectid][objectID] || !IsValidDynamicObject(MapEditorInfo[meobjectid][objectID]))
		return;
	MapEditorInfo[meobjectid][objectPosME][0] = x;
	MapEditorInfo[meobjectid][objectPosME][1] = y;
	MapEditorInfo[meobjectid][objectPosME][2] = z;
	MapEditorInfo[meobjectid][objectPosME][3] = rx;
	MapEditorInfo[meobjectid][objectPosME][4] = ry;
	MapEditorInfo[meobjectid][objectPosME][5] = rz;

	SetDynamicObjectPos(MapEditorInfo[meobjectid][objectID], MapEditorInfo[meobjectid][objectPosME][0], MapEditorInfo[meobjectid][objectPosME][1], MapEditorInfo[meobjectid][objectPosME][2]);
	SetDynamicObjectRot(MapEditorInfo[meobjectid][objectID], MapEditorInfo[meobjectid][objectPosME][3], MapEditorInfo[meobjectid][objectPosME][4], MapEditorInfo[meobjectid][objectPosME][5]);

	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapEditorInfo[meobjectid][objectText], E_STREAMER_X, MapEditorInfo[meobjectid][objectPosME][0]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapEditorInfo[meobjectid][objectText], E_STREAMER_Y, MapEditorInfo[meobjectid][objectPosME][1]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapEditorInfo[meobjectid][objectText], E_STREAMER_Z, MapEditorInfo[meobjectid][objectPosME][2]);
}
stock ME_toggle_text(playerid, Float:drawdistance = 10.0) {
	if (ME_text_arrayed || drawdistance < 1.0) {
		for (new meobjectid = 0; meobjectid < MAX_MAP_EDITOR_OBJECT; meobjectid++) if (0 != MapEditorInfo[meobjectid][objectID])
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapEditorInfo[meobjectid][objectText], E_STREAMER_DRAW_DISTANCE, 0.01);
		ME_text_arrayed = false;
		ME_draw_distance = 0.01;
		SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Текста с ID объектами теперь скрыты.");
	}
	else {
		for (new meobjectid = 0; meobjectid < MAX_MAP_EDITOR_OBJECT; meobjectid++) if (0 != MapEditorInfo[meobjectid][objectID])
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, MapEditorInfo[meobjectid][objectText], E_STREAMER_DRAW_DISTANCE, drawdistance);
		ME_text_arrayed = true;
		ME_draw_distance = drawdistance;
		SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Текста с ID объектами теперь показаны.");
	}
	return ME_text_arrayed;
}
cmd:sobject(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || params[0] < 0 || params[0] >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /s(el)object [id объекта]");
	if (0 == MapEditorInfo[params[0]][objectID] || !IsValidDynamicObject(MapEditorInfo[params[0]][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");

	SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Вы выбрали объект ID: %i.", params[0]);
	SetPVarInt(playerid, "ME_object_id", params[0]);
	return true;
}
cmd:cobject(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || !IsValidObjectModel(params[0]))
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /cobject [id модели]");
	if (MAP_EDITOR_TOTAL >= MAX_MAP_EDITOR_OBJECT)
		return SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Превышен лимит объектов (максимум: %i).", MAX_MAP_EDITOR_OBJECT);
	CreateMapEditorObject(playerid, params[0]);
	return true;
}
CMD:aobject(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	new 
		count_obj, c_object,
		Float:fX = 0.0, Float:fY = 0.0, 
		Float:fZ = 0.0, Float:fRZ = 0.0, 
		Float:fRX = 0.0, Float:fRY = 0.0;
	if (sscanf(params, "ddffffff", count_obj, c_object, fX, fY, fZ, fRX, fRY, fRZ) || !IsValidObjectModel(c_object))
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /aobject [id модели]");
	if (MAP_EDITOR_TOTAL >= MAX_MAP_EDITOR_OBJECT)
		return SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Превышен лимит объектов (максимум: %i).", MAX_MAP_EDITOR_OBJECT);
	CreateMapEditorObject(playerid, c_object, fX, fY, fZ, fRX, fRY, fRZ); 
	return 1;
} 
stock IsValidObjectModel(modelid) {
	if (modelid < 321) 
		return false;
	switch (modelid) {
		case 20000, 1264, 1265, 2704 .. 2706, 2689, 18553: return false;
	}
	return true;
}
cmd:dobject(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || params[0] < 0 || params[0] >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /dobject [id объекта]");
	if (GetPVarInt(playerid, "ME_object_id") == params[0]) SetPVarInt(playerid, "ME_object_id", MAX_MAP_EDITOR_OBJECT);
	DestroyMapEditorObject(playerid, params[0]);
	return true;
}
cmd:eobject(playerid) {
	if (!IsAMapper(playerid))
		return false;
	if (GetPVarInt(playerid, "ME_object_id") >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Сначала выберите объект.");
	if (0 == MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID] || !IsValidDynamicObject(MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");
	SetPVarInt(playerid, "ME_edit_mode", 1);
	EditDynamicObject(playerid, MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID]);
	SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Вы редактируете объект ID: %i.", GetPVarInt(playerid, "ME_object_id"));
	return true;
}
cmd:odeleteobjects(playerid) {
	if (!IsAMapper(playerid))
		return false;
	for (new meobjectid = 0; meobjectid < MAX_MAP_EDITOR_OBJECT; meobjectid++) if (0 != MapEditorInfo[meobjectid][objectID])
		DestroyMapEditorObject(playerid, meobjectid);
	MAP_EDITOR_TOTAL = 0;
	SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Вы удалили все объекты.");
	return true;
}
cmd:oexportobjects(playerid) {
	if (!IsAMapper(playerid))
		return false;
	SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] Exported Objects [chatlog.txt] START:");
	for (new meobjectid = 0, me_str[144]; meobjectid < MAX_MAP_EDITOR_OBJECT; meobjectid++) if (0 != MapEditorInfo[meobjectid][objectID]) {
		format(me_str,sizeof(me_str), "CreateDynamicObject(%i, %f, %f, %f, %f, %f, %f, %i, %i, -1, 200.00, 200.00); // %i",
			MapEditorInfo[meobjectid][objectModel],
			MapEditorInfo[meobjectid][objectPosME][0], MapEditorInfo[meobjectid][objectPosME][1], MapEditorInfo[meobjectid][objectPosME][2],
			MapEditorInfo[meobjectid][objectPosME][3], MapEditorInfo[meobjectid][objectPosME][4], MapEditorInfo[meobjectid][objectPosME][5],
			MapEditorInfo[meobjectid][objectWorld], MapEditorInfo[meobjectid][objectInterior],
			meobjectid
		);
		SendClientMessage(playerid, COLOR_WHITE, me_str);
	}
	SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] Exported Objects [chatlog.txt] END.");
	return true;
}
cmd:ogoto(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || params[0] < 0 || params[0] >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ogoto [id объекта]");
	if (GetPVarInt(playerid, "ME_object_id") >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Сначала выберите объект.");
	if (0 == MapEditorInfo[params[0]][objectID] || !IsValidDynamicObject(MapEditorInfo[params[0]][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");
	SetPlayerPos(playerid, MapEditorInfo[params[0]][objectPosME][0], MapEditorInfo[params[0]][objectPosME][1], MapEditorInfo[params[0]][objectPosME][2]);
	SetPlayerInterior(playerid, MapEditorInfo[params[0]][objectInterior]);
	SetPlayerVirtualWorld(playerid, MapEditorInfo[params[0]][objectWorld]);
	SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Вы телепортировались к объекту ID: %i.", params[0]);
	return true;
}

cmd:ox(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -3000 || params[0] > 3000)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ox [значение]");
	if (GetPVarInt(playerid, "ME_object_id") >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Сначала выберите объект.");
	if (0 == MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID] || !IsValidDynamicObject(MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");
	MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][0] += (params[0] * 1.0);
	UpdateMapEditorObject(GetPVarInt(playerid, "ME_object_id"),
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][0],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][1],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][2],

		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][3],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][4],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:oy(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -3000 || params[0] > 3000)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /oy [значение]");
	if (GetPVarInt(playerid, "ME_object_id") >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Сначала выберите объект.");
	if (0 == MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID] || !IsValidDynamicObject(MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");
	MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][1] += (params[0] * 1.0);
	UpdateMapEditorObject(GetPVarInt(playerid, "ME_object_id"),
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][0],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][1],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][2],

		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][3],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][4],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:oz(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -3000 || params[0] > 3000)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /oz [значение]");
	if (GetPVarInt(playerid, "ME_object_id") >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Сначала выберите объект.");
	if (0 == MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID] || !IsValidDynamicObject(MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");
	MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][2] += (params[0] * 1.0);
	UpdateMapEditorObject(GetPVarInt(playerid, "ME_object_id"),
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][0],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][1],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][2],

		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][3],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][4],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:rx(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -360 || params[0] > 360)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /rx [угол поворота]");
	if (GetPVarInt(playerid, "ME_object_id") >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Сначала выберите объект.");
	if (0 == MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID] || !IsValidDynamicObject(MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");
	MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][3] += (params[0] * 1.0);
	UpdateMapEditorObject(GetPVarInt(playerid, "ME_object_id"),
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][0],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][1],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][2],

		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][3],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][4],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:ry(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -360 || params[0] > 360)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /ry [угол поворота]");
	if (GetPVarInt(playerid, "ME_object_id") >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Сначала выберите объект.");
	if (0 == MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID] || !IsValidDynamicObject(MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");
	MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][4] += (params[0] * 1.0);
	UpdateMapEditorObject(GetPVarInt(playerid, "ME_object_id"),
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][0],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][1],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][2],

		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][3],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][4],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:rz(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -360 || params[0] > 360)
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /rz [угол поворота]");
	if (GetPVarInt(playerid, "ME_object_id") >= MAX_MAP_EDITOR_OBJECT)
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Сначала выберите объект.");
	if (0 == MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID] || !IsValidDynamicObject(MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectID]))
		return SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Объект с данным ID еще не создан.");
	MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][5] += (params[0] * 1.0);
	UpdateMapEditorObject(GetPVarInt(playerid, "ME_object_id"),
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][0],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][1],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][2],

		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][3],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][4],
		MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:otext(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(0)", params[0]))
		return SendClientMessage(playerid, COLOR_WHITE, !"Введите: /otext [дальность прорисовки]");
	if (params[0] > 0 && params[0] < 50)
		ME_toggle_text(playerid, floatround(params[0]));
	else ME_toggle_text(playerid, 0.01);
	return true;
}
CMD:mehelp(playerid) {
	if (!IsAMapper(playerid))
		return true;
	SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor] "colwhi"Список доступных команд:\n ");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/sobject(sel) [id объекта] - "colwhi"выделить объект;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/cobject [id объекта] - "colwhi"создать объект;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/dobject [id объекта] - "colwhi"удалить объект;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/ogoto [id объекта] - "colwhi"телепортироваться к объекту;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/e(dit)object - "colwhi"редактирование объекта;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/rz /rx /ry [значение] - "colwhi"повороты по осям;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/oz /ox /oy [значение] - "colwhi"перемещение по осям;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/otext [дистанция] - "colwhi"показ индексов объектов;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/odeleteobjects - "colwhi"удалить все объекты;");
	SendClientMessage(playerid, COLOR_SERVER, ""colserver"/oexportobjects - "colwhi"экспорт всех объектов;");
	SendClientMessage(playerid, COLOR_SERVER, ""colwhi"Клавиша "colserver"ALT "colwhi"(в режиме редактирования) - клонировать текущий объект.");
	return true;
}
IsAMapper(playerid) {
	if (pInfo[playerid][pAdmin] >= 10) return true; 
	return false;
}
/*
	if (ME_OnPlayerEditDynamicObject(playerid, objectid, response, x, y, z, rx, ry, rz)) return true;
*/
ME_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	#pragma unused objectid
	if (GetPVarInt(playerid, "ME_edit_mode") && MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectModel]) {
		if (response == EDIT_RESPONSE_FINAL) {
			new meobjectid = GetPVarInt(playerid, "ME_object_id");
			UpdateMapEditorObject(meobjectid, x, y, z, rx, ry, rz);
			Streamer_Update(playerid);
			SendMes(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Вы изменили позицию объекта #%i.", meobjectid);

			DeletePVar(playerid, "ME_edit_mode");
			return true;
		}
		else if (response == EDIT_RESPONSE_CANCEL) {
			new meobjectid = GetPVarInt(playerid, "ME_object_id");
			if (0 == MapEditorInfo[meobjectid][objectID] || !IsValidDynamicObject(MapEditorInfo[meobjectid][objectID]))
				return false;
			SetDynamicObjectPos(MapEditorInfo[meobjectid][objectID], MapEditorInfo[meobjectid][objectPosME][0], MapEditorInfo[meobjectid][objectPosME][1], MapEditorInfo[meobjectid][objectPosME][2]);
			SetDynamicObjectRot(MapEditorInfo[meobjectid][objectID], MapEditorInfo[meobjectid][objectPosME][3], MapEditorInfo[meobjectid][objectPosME][4], MapEditorInfo[meobjectid][objectPosME][5]);
			SendClientMessage(playerid, COLOR_SERVER, "[ Map Editor ] "colwhi"Вы отменили редактирование.");

			DeletePVar(playerid, "ME_edit_mode");
			return true;
		}
	}
	return false;
}
/*
	if (ME_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)) return true;
*/
ME_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	if (newkeys & KEY_WALK && !(oldkeys & KEY_WALK)) {
		if (GetPVarInt(playerid, "ME_edit_mode") && IsAMapper(playerid) && MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectModel]) {
			CreateMapEditorObject(playerid,
				MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectModel],

				MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][0],
				MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][1],
				MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][2],

				MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][3],
				MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][4],
				MapEditorInfo[GetPVarInt(playerid, "ME_object_id")][objectPosME][5]
			);
			callcmd::eobject(playerid);
			return true;
		}
	}
	return false;
}