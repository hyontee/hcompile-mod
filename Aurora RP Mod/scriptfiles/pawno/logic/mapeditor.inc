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
*/
#if defined _mapeditor_included
	#endinput
#endif
#define _mapeditor_included

#define max_map_object		300

#define SendFormattedMessage%0(%1,%2,%3,%4) \
	format(STRING_GLOBAL, 144, %3, %4), SendClientMessage(%1, %2, STRING_GLOBAL), STRING_GLOBAL[0] = EOS

alias:sobject("sel", "selobject");
alias:eobject("editobject", "eo");
alias:cobject("createobject", "co");
alias:dobject("deleteobject", "destroyobject", "dob");

enum ME_enum {
	me_objectid,
	me_modelid,
	me_interior,
	me_virtualworld,
	Float:me_pos[6],
	Text3D:me_text_label
};
new ME_TOTALOBJECTS = 0,
	ME_object_info[max_map_object][ME_enum],

	Float:ME_draw_distance = 0.01,
	bool:ME_text_arrayed = false
;
stock ME_create_object(playerid, modelid, Float:x = 0.0, Float:y = 0.0, Float:z = 0.0, Float:rx = 0.0, Float:ry = 0.0, Float:rz = 0.0) {
	new free_objectid = max_map_object;
	for (free_objectid = 0; free_objectid < max_map_object; free_objectid++)
		if (0 == ME_object_info[free_objectid][me_objectid]) break;

	if (free_objectid == max_map_object)
		return SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Превышен лимит объектов (максимум: %i).", max_map_object);

	ME_object_info[free_objectid][me_pos][0] = x;
	ME_object_info[free_objectid][me_pos][1] = y;
	ME_object_info[free_objectid][me_pos][2] = z;

	if ((x == 0.0) && (y == 0.0) && (z == 0.0)) {
		GetPlayerPos(playerid,
			ME_object_info[free_objectid][me_pos][0], ME_object_info[free_objectid][me_pos][1], ME_object_info[free_objectid][me_pos][2]
		);
	}
	ME_object_info[free_objectid][me_objectid] = CreateDynamicObject(
		(ME_object_info[free_objectid][me_modelid] = modelid),
		ME_object_info[free_objectid][me_pos][0], ME_object_info[free_objectid][me_pos][1], ME_object_info[free_objectid][me_pos][2],
		(ME_object_info[free_objectid][me_pos][3] = rx),
		(ME_object_info[free_objectid][me_pos][4] = ry),
		(ME_object_info[free_objectid][me_pos][5] = rz),
		(ME_object_info[free_objectid][me_virtualworld] = GetPlayerVirtualWorld(playerid)),
		(ME_object_info[free_objectid][me_interior] = GetPlayerInterior(playerid)),
		-1, 200.00, 200.00
	);
	new
		ME_virtualworlds[1],
		ME_interiors[1],
		ME_players[1],
		ME_areas[1]
	;
	ME_virtualworlds[0] = ME_object_info[free_objectid][me_virtualworld];
	ME_interiors[0] = ME_object_info[free_objectid][me_interior];
	ME_players[0] = ME_areas[0] = -1;
	new ME_str[24];
	format(ME_str, sizeof(ME_str), "Ind: {33DD11}%i", free_objectid);
	ME_object_info[free_objectid][me_text_label] = CreateDynamic3DTextLabelEx(ME_str, 0xFF8800FF,
		ME_object_info[free_objectid][me_pos][0], ME_object_info[free_objectid][me_pos][1], ME_object_info[free_objectid][me_pos][2],
		ME_draw_distance, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 100.0,
		ME_virtualworlds, ME_interiors, ME_players, ME_areas, 0
	);
	if (free_objectid >= ME_TOTALOBJECTS)
		ME_TOTALOBJECTS++;

	/*foreach(new i: Player) {
		if (!ME_text_arrayed) continue;
		if (!IsAMapper(i)) continue;
		if (!Streamer_IsInArrayData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[free_objectid][me_text_label], E_STREAMER_PLAYER_ID, i)) continue;
		Streamer_AppendArrayData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[free_objectid][me_text_label], E_STREAMER_PLAYER_ID, i);
		Streamer_Update(i, STREAMER_TYPE_3D_TEXT_LABEL);
	}*/
	Streamer_Update(playerid, STREAMER_TYPE_OBJECT);
	SetPVarInt(playerid, "ME_object_id", free_objectid);
	SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы создали объект под номером #%i [Модель: %i].", free_objectid, modelid);
	return ME_object_info[free_objectid][me_objectid];
}
stock ME_destroy_object(playerid, meobjectid) {
	if (0 == ME_object_info[meobjectid][me_objectid] || !IsValidDynamicObject(ME_object_info[meobjectid][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	/*foreach(new i: Player) {
		if (!ME_text_arrayed) continue;
		if (!IsAMapper(i)) continue;
		if (!Streamer_IsInArrayData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_PLAYER_ID, i)) continue;
		Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_PLAYER_ID, i);
		Streamer_Update(i, STREAMER_TYPE_3D_TEXT_LABEL);
	}*/
	DestroyDynamicObject(ME_object_info[meobjectid][me_objectid]);
	DestroyDynamic3DTextLabel(ME_object_info[meobjectid][me_text_label]);
	Streamer_Update(playerid);

	ME_object_info[meobjectid][me_objectid] =
	ME_object_info[meobjectid][me_modelid] =
	ME_object_info[meobjectid][me_virtualworld] =
	ME_object_info[meobjectid][me_interior] = 0;

	ME_object_info[meobjectid][me_pos][0] = ME_object_info[meobjectid][me_pos][1] = ME_object_info[meobjectid][me_pos][2] =
	ME_object_info[meobjectid][me_pos][3] = ME_object_info[meobjectid][me_pos][4] = ME_object_info[meobjectid][me_pos][5] = 0.0;

	//ME_TOTALOBJECTS--;
	SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы удалили объект под номером #%i.", meobjectid);
	return meobjectid;
}
stock ME_update_object_data(meobjectid, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	if (0 == ME_object_info[meobjectid][me_objectid] || !IsValidDynamicObject(ME_object_info[meobjectid][me_objectid]))
		return;
	ME_object_info[meobjectid][me_pos][0] = x;
	ME_object_info[meobjectid][me_pos][1] = y;
	ME_object_info[meobjectid][me_pos][2] = z;
	ME_object_info[meobjectid][me_pos][3] = rx;
	ME_object_info[meobjectid][me_pos][4] = ry;
	ME_object_info[meobjectid][me_pos][5] = rz;

	SetDynamicObjectPos(ME_object_info[meobjectid][me_objectid], ME_object_info[meobjectid][me_pos][0], ME_object_info[meobjectid][me_pos][1], ME_object_info[meobjectid][me_pos][2]);
	SetDynamicObjectRot(ME_object_info[meobjectid][me_objectid], ME_object_info[meobjectid][me_pos][3], ME_object_info[meobjectid][me_pos][4], ME_object_info[meobjectid][me_pos][5]);

	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_X, ME_object_info[meobjectid][me_pos][0]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_Y, ME_object_info[meobjectid][me_pos][1]);
	Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_Z, ME_object_info[meobjectid][me_pos][2]);
}
stock ME_toggle_text(playerid, Float:drawdistance = 10.0) {
	if (ME_text_arrayed || drawdistance < 1.0) {
		/*for (new meobjectid = 0; meobjectid < max_map_object; meobjectid++) if (0 != ME_object_info[meobjectid][me_objectid]) {
			if (Streamer_IsInArrayData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_PLAYER_ID, playerid))
				Streamer_RemoveArrayData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_PLAYER_ID, playerid),
				Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_DRAW_DISTANCE, drawdistance);
		}*/
		for (new meobjectid = 0; meobjectid < max_map_object; meobjectid++) if (0 != ME_object_info[meobjectid][me_objectid])
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_DRAW_DISTANCE, 0.01);
		ME_text_arrayed = false;
		ME_draw_distance = 0.01;
		SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Текста с ID объектами теперь скрыты.");
	}
	else {
		/*for (new meobjectid = 0; meobjectid < max_map_object; meobjectid++) if (0 != ME_object_info[meobjectid][me_objectid]) {
			if (!Streamer_IsInArrayData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_PLAYER_ID, playerid))
				Streamer_AppendArrayData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_PLAYER_ID, playerid),
				Streamer_Update(playerid, STREAMER_TYPE_3D_TEXT_LABEL);
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_DRAW_DISTANCE, drawdistance);
		}*/
		for (new meobjectid = 0; meobjectid < max_map_object; meobjectid++) if (0 != ME_object_info[meobjectid][me_objectid])
			Streamer_SetFloatData(STREAMER_TYPE_3D_TEXT_LABEL, ME_object_info[meobjectid][me_text_label], E_STREAMER_DRAW_DISTANCE, drawdistance);
		ME_text_arrayed = true;
		ME_draw_distance = drawdistance;
		SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Текста с ID объектами теперь показаны.");
	}
	return ME_text_arrayed;
}
cmd:sobject(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || params[0] < 0 || params[0] >= max_map_object)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /s(el)object [id объекта]");
	if (0 == ME_object_info[params[0]][me_objectid] || !IsValidDynamicObject(ME_object_info[params[0]][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");

	SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы выбрали объект под номером #%i.", params[0]);
	SetPVarInt(playerid, "ME_object_id", params[0]);
	return true;
}
cmd:cobject(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || !IsValidObjectModel(params[0]))
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /cobject [id модели]");
	if (ME_TOTALOBJECTS >= max_map_object)
		return SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Превышен лимит объектов (максимум: %i).", max_map_object);
	ME_create_object(playerid, params[0]);
	return true;
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
	if (sscanf(params, "i", params[0]) || params[0] < 0 || params[0] >= max_map_object)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /dobject [id объекта]");
	if (GetPVarInt(playerid, "ME_object_id") == params[0]) SetPVarInt(playerid, "ME_object_id", max_map_object);
	ME_destroy_object(playerid, params[0]);
	return true;
}
cmd:eobject(playerid) {
	if (!IsAMapper(playerid))
		return false;
	if (GetPVarInt(playerid, "ME_object_id") >= max_map_object)
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Сначала выберите объект.");
	if (0 == ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid] || !IsValidDynamicObject(ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	SetPVarInt(playerid, "ME_edit_mode", 1);
	EditDynamicObject(playerid, ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid]);
	SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы редактируете объект под номером #%i.", GetPVarInt(playerid, "ME_object_id"));
	return true;
}
cmd:odeleteobjects(playerid) {
	if (!IsAMapper(playerid))
		return false;
	for (new meobjectid = 0; meobjectid < max_map_object; meobjectid++) if (0 != ME_object_info[meobjectid][me_objectid])
		ME_destroy_object(playerid, meobjectid);
	ME_TOTALOBJECTS = 0;
	SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы удалили все объекты.");
	return true;
}
cmd:oexportobjects(playerid) {
	if (!IsAMapper(playerid))
		return false;
	SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] Exported Objects [chatlog.txt] START:");
	for (new meobjectid = 0, me_str[144]; meobjectid < max_map_object; meobjectid++) if (0 != ME_object_info[meobjectid][me_objectid]) {
		format(me_str,sizeof(me_str), "CreateDynamicObject(%i, %f, %f, %f, %f, %f, %f, %i, %i, -1, 200.00, 200.00); // %i",
			ME_object_info[meobjectid][me_modelid],
			ME_object_info[meobjectid][me_pos][0], ME_object_info[meobjectid][me_pos][1], ME_object_info[meobjectid][me_pos][2],
			ME_object_info[meobjectid][me_pos][3], ME_object_info[meobjectid][me_pos][4], ME_object_info[meobjectid][me_pos][5],
			ME_object_info[meobjectid][me_virtualworld], ME_object_info[meobjectid][me_interior],
			meobjectid
		);
		SendClientMessage(playerid, COLOR_WHITE, me_str);
	}
	SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] Exported Objects [chatlog.txt] END.");
	return true;
}
/*cmd:ointerior(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || params[0] < 0 || params[0] >= max_map_object)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /ointerior [id интерьера]");
	for (new meobjectid = 0; meobjectid < max_map_object; meobjectid++) if (0 != ME_object_info[meobjectid][me_objectid]) {
		ME_object_info[meobjectid][me_interior] = params[0];
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, ME_object_info[meobjectid][me_objectid], E_STREAMER_INTERIOR_ID, ME_object_info[meobjectid][me_interior]);
	}
	SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы переместили все объекты в интерьер #%i.", params[0]);
	return true;
}
cmd:ovirtualworld(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || params[0] < 0 || params[0] >= max_map_object)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /ovirtualworld [id виртуального мира]");
	for (new meobjectid = 0; meobjectid < max_map_object; meobjectid++) if (0 != ME_object_info[meobjectid][me_objectid]) {
		ME_object_info[meobjectid][me_virtualworld] = params[0];
		Streamer_SetIntData(STREAMER_TYPE_OBJECT, ME_object_info[meobjectid][me_objectid], E_STREAMER_WORLD_ID, ME_object_info[meobjectid][me_virtualworld]);
	}
	SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы переместили все объекты в виртуальный мир #%i.", params[0]);
	return true;
}*/
cmd:ogoto(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "i", params[0]) || params[0] < 0 || params[0] >= max_map_object)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /ogoto [id объекта]");
	if (GetPVarInt(playerid, "ME_object_id") >= max_map_object)
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Сначала выберите объект.");
	if (0 == ME_object_info[params[0]][me_objectid] || !IsValidDynamicObject(ME_object_info[params[0]][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	SetPlayerPos(playerid, ME_object_info[params[0]][me_pos][0], ME_object_info[params[0]][me_pos][1], ME_object_info[params[0]][me_pos][2]);
	SetPlayerInterior(playerid, ME_object_info[params[0]][me_interior]);
	SetPlayerVirtualWorld(playerid, ME_object_info[params[0]][me_virtualworld]);
	SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы телепортировались к объекту под номером #%i.", params[0]);
	return true;
}

cmd:ox(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -3000 || params[0] > 3000)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /ox [значение]");
	if (GetPVarInt(playerid, "ME_object_id") >= max_map_object)
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Сначала выберите объект.");
	if (0 == ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid] || !IsValidDynamicObject(ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][0] += (params[0] * 1.0);
	ME_update_object_data(GetPVarInt(playerid, "ME_object_id"),
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][0],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][1],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][2],

		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][3],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][4],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:oy(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -3000 || params[0] > 3000)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /oy [значение]");
	if (GetPVarInt(playerid, "ME_object_id") >= max_map_object)
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Сначала выберите объект.");
	if (0 == ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid] || !IsValidDynamicObject(ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][1] += (params[0] * 1.0);
	ME_update_object_data(GetPVarInt(playerid, "ME_object_id"),
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][0],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][1],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][2],

		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][3],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][4],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:oz(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -3000 || params[0] > 3000)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /oz [значение]");
	if (GetPVarInt(playerid, "ME_object_id") >= max_map_object)
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Сначала выберите объект.");
	if (0 == ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid] || !IsValidDynamicObject(ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][2] += (params[0] * 1.0);
	ME_update_object_data(GetPVarInt(playerid, "ME_object_id"),
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][0],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][1],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][2],

		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][3],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][4],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:rx(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -360 || params[0] > 360)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /rx [угол поворота]");
	if (GetPVarInt(playerid, "ME_object_id") >= max_map_object)
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Сначала выберите объект.");
	if (0 == ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid] || !IsValidDynamicObject(ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][3] += (params[0] * 1.0);
	ME_update_object_data(GetPVarInt(playerid, "ME_object_id"),
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][0],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][1],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][2],

		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][3],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][4],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:ry(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -360 || params[0] > 360)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /ry [угол поворота]");
	if (GetPVarInt(playerid, "ME_object_id") >= max_map_object)
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Сначала выберите объект.");
	if (0 == ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid] || !IsValidDynamicObject(ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][4] += (params[0] * 1.0);
	ME_update_object_data(GetPVarInt(playerid, "ME_object_id"),
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][0],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][1],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][2],

		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][3],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][4],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:rz(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(1)", params[0]) || params[0] < -360 || params[0] > 360)
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /rz [угол поворота]");
	if (GetPVarInt(playerid, "ME_object_id") >= max_map_object)
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Сначала выберите объект.");
	if (0 == ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid] || !IsValidDynamicObject(ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_objectid]))
		return SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Объект с данным ID еще не создан.");
	ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][5] += (params[0] * 1.0);
	ME_update_object_data(GetPVarInt(playerid, "ME_object_id"),
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][0],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][1],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][2],

		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][3],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][4],
		ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][5]
	);
	Streamer_Update(playerid);
	return true;
}
cmd:otext(playerid, params[]) {
	if (!IsAMapper(playerid))
		return false;
	if (sscanf(params, "I(0)", params[0]))
		return SendClientMessage(playerid, COLOR_WHITE, ""P"Используйте:"W" /otext [дальность прорисовки]");
	if (params[0] > 0 && params[0] < 50)
		ME_toggle_text(playerid, floatround(params[0]));
	else ME_toggle_text(playerid, 0.01);
	return true;
}
CMD:mehelp(playerid) {
	if (!IsAMapper(playerid)) 
		return true;
	ShowPlayerDialog(playerid, DIALOG_NONE, DIALOG_STYLE_MSGBOX, ""P"MapEditor "O"[1.0]", 
		""W"Список доступных команд:\n \n\
		"P"/sobject(sel) [id объекта] - "W"выделить объект;\n\
		"P"/cobject [id объекта] - "W"создать объект;\n\
		"P"/dobject [id объекта] - "W"удалить объект;\n\
		"P"/ogoto [id объекта] - "W"телепортироваться к объекту;\n\
		"P"/e(dit)object - "W"редактирование объекта;\n\
		"P"/rz /rx /ry [значение] - "W"повороты по осям;\n\
		"P"/oz /ox /oy [значение] - "W"перемещение по осям;\n\
		"P"/otext [дистанция] - "W"показ индексов объектов;\n\
		"P"/odeleteobjects - "W"удалить все объекты;\n\
		"P"/oexportobjects - "W"экспорт всех объектов;\n \n\
		Клавиша "P"ALT "W"(в режиме редактирования) - клонировать текущий объект.",
		"Закрыть", ""
	);
	return true;
}
IsAMapper(playerid) {
	if (PI[playerid][pAdmin] < 4 || dostup[playerid] == 0) 
		return false;
	return true;
}
/*stock IsValidObjectModel(modelid) {
	if (
		(modelid >= 19522 && modelid <= 19787) ||
		(modelid >= 19788 && modelid <= 19870) ||
		(modelid >= 11682 && modelid <= 11691) ||
		(modelid >= 19871 && modelid <= 19999) ||
		(modelid >= 11692 && modelid <= 11753)
	) return 1;
	new modeldat[] = {
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -128,
		-515899393, -134217729, -1, -1, 33554431, -1, -1, -1, -14337, -1, -33,
		127, 0, 0, 0, 0, 0, -8388608, -1, -1, -1, -16385, -1, -1, -1, -1, -1,
		-1, -1, -33, -1, -771751937, -1, -9, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, 33554431, -25, -1, -1, -1, -1, -1, -1,
		-1073676289, -2147483648, 34079999, 2113536, -4825600, -5, -1, -3145729,
		-1, -16777217, -63, -1, -1, -1, -1, -201326593, -1, -1, -1, -1, -1,
		-257, -1, 1073741823, -133122, -1, -1, -65, -1, -1, -1, -1, -1, -1,
		-2146435073, -1, -1, -1, -1, -1, -1, -1, -1, -1, 1073741823, -64, -1,
		-1, -1, -1, -2635777, 134086663, 0, -64, -1, -1, -1, -1, -1, -1, -1,
		-536870927, -131069, -1, -1, -1, -1, -1, -1, -1, -1, -16384, -1,
		-33554433, -1, -1, -1, -1, -1, -1610612737, 524285, -128, -1,
		2080309247, -1, -1, -1114113, -1, -1, -1, 66977343, -524288, -1, -1, -1,
		-1, -2031617, -1, 114687, -256, -1, -4097, -1, -4097, -1, -1,
		1010827263, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, -32768, -1, -1, -1, -1, -1,
		2147483647, -33554434, -1, -1, -49153, -1148191169, 2147483647,
		-100781080, -262145, -57, 134217727, -8388608, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1048577, -1, -449, -1017, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1835009, -2049, -1, -1, -1, -1, -1, -1,
		-8193, -1, -536870913, -1, -1, -1, -1, -1, -87041, -1, -1, -1, -1, -1,
		-1, -209860, -1023, -8388609, -2096897, -1, -1048577, -1, -1, -1, -1,
		-1, -1, -897, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1610612737,
		-3073, -28673, -1, -1, -1, -1537, -1, -1, -13, -1, -1, -1, -1, -1985,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1056964609, -1, -1, -1,
		-1, -1, -1, -1, -2, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-236716037, -1, -1, -1, -1, -1, -1, -1, -536870913, 3, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -2097153, -2109441, -1, 201326591, -4194304, -1, -1,
		-241, -1, -1, -1, -1, -1, -1, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, -32768, -1, -1, -1, -2, -671096835, -1, -8388609, -66323585, -13,
		-1793, -32257, -247809, -1, -1, -513, 16252911, 0, 0, 0, -131072,
		33554383, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
		0, 0, 0, 0, 0, 0, 0, 0, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 8356095, 0, 0, 0, 0, 0,
		0, -256, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		-268435449, -1, -1, -2049, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
		92274627, -65536, -2097153, -268435457, 591191935, 1, 0, -16777216, -1,
		-1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 127
	};
	if ((modelid >= 0) && ((modelid / 32) < sizeof (modeldat)) && (modeldat[modelid / 32] & (1 << (modelid % 32))))
		return 1;
	return 0;
}
*/
ME_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	#pragma unused objectid
	if (GetPVarInt(playerid, "ME_edit_mode")) {
		if (response == EDIT_RESPONSE_FINAL) {
			new meobjectid = GetPVarInt(playerid, "ME_object_id");
			ME_update_object_data(meobjectid, x, y, z, rx, ry, rz);
			Streamer_Update(playerid);
			SendFormattedMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы изменили позицию объекта #%i.", meobjectid);

			DeletePVar(playerid, "ME_edit_mode");
			return true;
		}
		else if (response == EDIT_RESPONSE_CANCEL) {
			new meobjectid = GetPVarInt(playerid, "ME_object_id");
			if (0 == ME_object_info[meobjectid][me_objectid] || !IsValidDynamicObject(ME_object_info[meobjectid][me_objectid]))
				return false;
			SetDynamicObjectPos(ME_object_info[meobjectid][me_objectid], ME_object_info[meobjectid][me_pos][0], ME_object_info[meobjectid][me_pos][1], ME_object_info[meobjectid][me_pos][2]);
			SetDynamicObjectRot(ME_object_info[meobjectid][me_objectid], ME_object_info[meobjectid][me_pos][3], ME_object_info[meobjectid][me_pos][4], ME_object_info[meobjectid][me_pos][5]);
			SendClientMessage(playerid, 0xd8284cFF, "[ Map Editor ] "W"Вы отменили редактирование.");

			DeletePVar(playerid, "ME_edit_mode");
			return true;
		}
	}
	return false;
}
ME_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) {
	#pragma unused oldkeys

	if (newkeys == KEY_WALK) {
		if (GetPVarInt(playerid, "ME_edit_mode") && IsAMapper(playerid)) {
			ME_create_object(playerid,
				ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_modelid],

				ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][0],
				ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][1],
				ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][2],

				ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][3],
				ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][4],
				ME_object_info[GetPVarInt(playerid, "ME_object_id")][me_pos][5]
			);
			callcmd::eobject(playerid);
			return true;
		}
	}
	return false;
}