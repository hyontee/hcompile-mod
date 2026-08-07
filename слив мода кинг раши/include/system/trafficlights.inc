#if defined TL_VERSION
	#endinput
#endif
#define TL_VERSION 1

// ================================== [ОПРЕДЕЛЕНИЯ] ================================== //
#define MAX_TRAFFIC_LIGHTS_TYPES		6    		// Количество различных типов светофора
#define MAX_TRAFFIC_LIGHTS				50			// Максимальное колличество светофоров
#define TRAFFIC_LIGHTS_PRICE		500			// Цена которая списывается


#if !defined TLC_GREEN
	#define TLC_GREEN					11112		// ID зеленого света (CUSTOM OBJECT)
#endif

#if !defined TLC_YELLOW
	#define TLC_YELLOW					11114		// ID желтого света (CUSTOM OBJECT)
#endif

#if !defined TLC_RED
	#define TLC_RED						11113		// ID красного света (CUSTOM OBJECT)
#endif

#define TL_TYPE_1						11111		// CUSTOM OBJECT
#define TL_TYPE_2						00002		// CUSTOM OBJECT
#define TL_TYPE_3						00003		// CUSTOM OBJECT
#define TL_TYPE_4						00004		// CUSTOM OBJECT
#define TL_TYPE_5						00005		// CUSTOM OBJECT
#define TL_TYPE_6						00006		// CUSTOM OBJECT
#define TL_TYPE_7						00007		// CUSTOM OBJECT
#define TL_TYPE_8						00008		// CUSTOM OBJECT


// ================================== [ПЕРЕМЕННЫЕ] ================================== //

enum E_TL_DATA
{
	tl_model_id,
	tl_object_id,
	tl_color,
	tl_light_object[3]
}
new TL_Data[MAX_TRAFFIC_LIGHTS][E_TL_DATA];
new Iterator:TL_Data<MAX_TRAFFIC_LIGHTS>;

// Данные для каждого типа (type, amount, offsets_idx_start, upper_light_offsets_idx).
new E_TL_TYPE_DATA[MAX_TRAFFIC_LIGHTS_TYPES][4] =
{
	{TL_TYPE_1, 1, 0, 0},
	{TL_TYPE_2, 1, 0, 0},
	{TL_TYPE_3, 1, 0, 0},
	{TL_TYPE_4, 1, 0, 0},
	{TL_TYPE_5, 1, 0, 0},
	{TL_TYPE_6, 1, 0, 0}
};

// Позиции света для каждого типа светофора
new Float:E_TL_OFFSETS[3][3] =
{
	// type 1-6
	{0.0000, 0.0000, 2.6693}, 	// Green
	{0.0000, 0.0000, 2.9503}, 	// Yellow
 	{0.0000, 0.0000, 3.2313} 	// Red
};

enum E_TRAFFIC_LIGHTS_STRUCT
{
	TL_TYPE,
	TL_COLOR,
Float: TL_POS_X,
Float: TL_POS_Y,
Float: TL_POS_Z,
Float: TL_POS_RX,
Float: TL_POS_RY,
Float: TL_POS_RZ
}

new g_traffic_lights[][E_TRAFFIC_LIGHTS_STRUCT] = 
{
	{TL_TYPE_1, TLC_GREEN, 2475.28369, -2170.06445, 20.80423,   0.00000, 0.00000, 0.00000},
	{TL_TYPE_1, TLC_RED, 2449.94556, -2165.42578, 20.80420,   0.00000, 0.00000, -90.00000},
	{TL_TYPE_1, TLC_GREEN, 2454.68115, -2140.10156, 20.80420,   0.00000, 0.00000, 180.00000},
	{TL_TYPE_1, TLC_RED, 2479.97046, -2144.72119, 20.80420,   0.00000, 0.00000, 90.00000}
};

new g_total_traffic_lights, g_player_timer[MAX_PLAYERS];


// ================================== [ПЕРЕХВАТ ФУНКЦИЙ] ================================== //
public OnGameModeExit()
{
	RemoveAllTrafficLights();
	#if defined tl_OnGameModeExit
		return tl_OnGameModeExit();
	#else
	    return 1;
	#endif
}
#if defined _ALS_OnGameModeExit
    #undef OnGameModeExit
#else
    #define _ALS_OnGameModeExit
#endif
#if defined tl_OnGameModeExit
	forward tl_OnGameModeExit();
#endif
#define	OnGameModeExit tl_OnGameModeExit

// ================================== [НОВЫЕ СВЕТОФОРЫ] ================================== //
stock CreateTrafficLight(idx, type, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz, init_color = TLC_GREEN)
{
	if(!IsValidTrafficLightPost(type))
	{
		printf("** [СВЕТОФОРЫ] Светофор не может быть создан, модель не валидна.");
		return -1;
	}

	if(!IsValidTrafficLightColor(init_color))
	{
		printf("** [СВЕТОФОРЫ] Светофор не может быть создан, цвет не правильный.");
		return -1;
	}

	if(idx >= MAX_TRAFFIC_LIGHTS)
	{
		printf("** [СВЕТОФОРЫ] Светофор не удалось создать, предел был достигнут.");
		return -1;
	}
	
	Iter_Add(TL_Data, idx);

	TL_Data[idx][tl_model_id] = type;
	TL_Data[idx][tl_color] = init_color;

	TL_Data[idx][tl_object_id] = CreateDynamicObject(type, x, y, z, rx, ry, rz);

	new upper_light = CheckPostUpperLight(type);

	if(upper_light)
	{
		new Float:pos_obj[6];
		GetDynamicObjectPos(TL_Data[idx][tl_object_id], pos_obj[0], pos_obj[1], pos_obj[2]);
		GetDynamicObjectRot(TL_Data[idx][tl_object_id], pos_obj[3], pos_obj[4], pos_obj[5]);
		
		TL_Data[idx][tl_light_object][2] = CreateDynamicObject(19281, pos_obj[0]+E_TL_OFFSETS[upper_light][0], pos_obj[1]+E_TL_OFFSETS[upper_light][1], pos_obj[2]+E_TL_OFFSETS[upper_light][2], pos_obj[3], pos_obj[4], pos_obj[5]);

	}
	SetTrafficLightColor(idx, init_color);
	return idx;
}

stock SetTrafficLightColor(idx, color)
{
	if(!Iter_Contains(TL_Data, idx)) return 0;

	if(!IsValidTrafficLightColor(color))
	{
		printf("** [СВЕТОФОРЫ] Свет не может быть установлен, цвет не правильный.");
		return -1;
	}

	new offsets_idx = GetPostOffsetsIndex(TL_Data[idx][tl_model_id]);
	new lights_amount = GetPostRequiredLights(TL_Data[idx][tl_model_id]);

	switch(color)
	{
		case TLC_YELLOW: offsets_idx += 1;
		case TLC_RED: offsets_idx += 2;
	}

	DisableTrafficLight(idx);

	for(new x = 0; x < lights_amount; x++)
	{
		new Float:pos_obj[6];
		GetDynamicObjectPos(TL_Data[idx][tl_object_id], pos_obj[0], pos_obj[1], pos_obj[2]);
		GetDynamicObjectRot(TL_Data[idx][tl_object_id], pos_obj[3], pos_obj[4], pos_obj[5]);
		
		TL_Data[idx][tl_light_object][x] = CreateDynamicObject(color, pos_obj[0]+E_TL_OFFSETS[offsets_idx][0], pos_obj[1]+E_TL_OFFSETS[offsets_idx][1], pos_obj[2]+E_TL_OFFSETS[offsets_idx][2], pos_obj[3], pos_obj[4], pos_obj[5]);

		offsets_idx += 3;
	}
	return 1;
}

stock GetTrafficLightColor(idx)
{
	if(!Iter_Contains(TL_Data, idx)) return 0;
	return TL_Data[idx][tl_color];
}

stock DisableTrafficLight(idx)
{
	if(!Iter_Contains(TL_Data, idx)) return 0;

	new lights_amount = GetPostRequiredLights(TL_Data[idx][tl_model_id]);

	for(new x = 0; x < lights_amount; x++)
	{
		if(IsValidDynamicObject(TL_Data[idx][tl_light_object][x])) DestroyDynamicObject(TL_Data[idx][tl_light_object][x]);
	}

	return 1;
}

stock RemoveTrafficLight(idx)
{
	if(!Iter_Contains(TL_Data, idx)) return 0;

	DisableTrafficLight(idx);

	if(IsValidDynamicObject(TL_Data[idx][tl_light_object][2])) DestroyDynamicObject(TL_Data[idx][tl_light_object][2]);

	if(IsValidDynamicObject(TL_Data[idx][tl_object_id])) DestroyDynamicObject(TL_Data[idx][tl_object_id]);


	Iter_Remove(TL_Data, idx);
	return 1;
}

stock RemoveAllTrafficLights()
{
	foreach(new x : TL_Data)
	{
		DisableTrafficLight(x);

		if(IsValidDynamicObject(TL_Data[x][tl_light_object][2])) DestroyDynamicObject(TL_Data[x][tl_light_object][2]);
		
		if(IsValidDynamicObject(TL_Data[x][tl_object_id])) DestroyDynamicObject(TL_Data[x][tl_object_id]);
	}

	Iter_Clear(TL_Data);
	return 1;
}

stock GetPostRequiredLights(tl_type)
{
	for(new x = 0; x < MAX_TRAFFIC_LIGHTS_TYPES; x++)
	{
		if(E_TL_TYPE_DATA[x][0] == tl_type)
		{
			return E_TL_TYPE_DATA[x][1];
		}
	}
	return 0;
}

stock GetPostOffsetsIndex(tl_type)
{
	for(new x = 0; x < MAX_TRAFFIC_LIGHTS_TYPES; x++)
	{
		if(E_TL_TYPE_DATA[x][0] == tl_type)
		{
			return E_TL_TYPE_DATA[x][2];
		}
	}
	return 0;
}

stock CheckPostUpperLight(tl_type)
{
	for(new x = 0; x < MAX_TRAFFIC_LIGHTS_TYPES; x++)
	{
		if(E_TL_TYPE_DATA[x][0] == tl_type && E_TL_TYPE_DATA[x][3] != 0)
		{
			return E_TL_TYPE_DATA[x][3];
		}
	}
	return 0;
}

stock IsValidTrafficLightColor(color)
{
	if(color == TLC_GREEN || color == TLC_YELLOW || color == TLC_RED) return 1;
	return 0;
}

stock IsValidTrafficLightPost(modelid)
{
	for(new x = 0; x < MAX_TRAFFIC_LIGHTS_TYPES; x++)
	{
		if(E_TL_TYPE_DATA[x][0] == modelid)
		{
			return 1;
		}
	}
	return 0;
}
