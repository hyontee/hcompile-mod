Furniture_OnPlayerClickTextDraw( playerid, Text:clickedid ) {
	if( _:clickedid == INVALID_TEXT_DRAW ) {
		switch(GetPVarInt( playerid, "Furn:View")) {
			case 1: {
				if( IsValidDynamicObject(furn_object[playerid])){
					DestroyDynamicObject(furn_object[playerid]);
					furn_object[playerid] = 0;
				}
				for(new i; i != 8; i ++) {
					TextDrawHideForPlayer(playerid, furnitureBuy[i]);
				}
					
				PlayerTextDrawHide( playerid, furniturePrice[playerid] );
				PlayerTextDrawHide( playerid, furnitureName[playerid] );
				
				SetPlayerVirtualWorld(playerid, GetPVarInt(playerid, "Furn:IntWorld"));
				SetPlayerPos(playerid, -492.8507,-257.6978,3095.8960);
				SetCameraBehindPlayer(playerid);
				
				TogglePlayerControllable( playerid, true );
				
				SetPVarInt( playerid, "Furn:IntWorld", INVALID_PLAYER_ID );
				SetPVarInt( playerid, "Furn:Type", INVALID_PLAYER_ID );
				SetPVarInt( playerid, "Furn:Max", INVALID_PLAYER_ID );
				SetPVarInt( playerid, "Furn:Object", INVALID_PLAYER_ID );
				SetPVarInt( playerid, "Furn:View", INVALID_PLAYER_ID );
				DeletePVar( playerid, "Furn:PlayerPos" );
				DeletePVar( playerid, "Player:World" );
				
				D(playerid, D_MEBEL_BUY_2, DSL, ""P"Покупка мебели", furniture_type, "Выбрать", "Закрыть");
				return 1;
			}
		}
	}
	else if( clickedid == furnitureBuy[2] ) //Стрелка влево
	{
		if( !GetPVarInt( playerid, "Furn:Object" ) )
		{
			SetPVarInt( playerid, "Furn:Object", GetPVarInt( playerid, "Furn:Max" ) - 1 );

			FurniturePreviewObject( playerid, GetPVarInt( playerid, "Furn:Type") );
			
			return 1;
		}
		
		GivePVarInt( playerid, "Furn:Object", -1 );

		FurniturePreviewObject( playerid, GetPVarInt( playerid, "Furn:Type") );
		return 1;
	}
	else if( clickedid == furnitureBuy[3] ) //Стрелка вправо
	{
		if( GetPVarInt( playerid, "Furn:Object" ) == GetPVarInt( playerid, "Furn:Max" ) - 1 )
		{
			SetPVarInt( playerid, "Furn:Object", 0 );

			FurniturePreviewObject( playerid, GetPVarInt( playerid, "Furn:Type") );
			return 1;
		}
		
		if( GetPVarInt( playerid, "Furn:Object" ) < GetPVarInt( playerid, "Furn:Max" ) ) 
		{
			GivePVarInt( playerid, "Furn:Object", 1 );

			FurniturePreviewObject( playerid, GetPVarInt( playerid, "Furn:Type") );
			return 1;
		}
		
		return 1;
	}
	else if( clickedid == furnitureBuy[5] ) //Кнопка Назад
	{
		CancelSelectTextDraw( playerid );
		return 1;
	}
	else if( clickedid == furnitureBuy[4] ) {
		if( PI[playerid][pCash] < furniture_list[GetPVarInt( playerid, "Furn:Type" )][GetPVarInt( playerid, "Furn:Object" )][f_price]) {
			return ErrorMessage(playerid,"У Вас недостаточно средств");
		}
		DeletePVar( playerid, "Furn:View" );
		new string[178];
		format(string,sizeof(string),"\n\n"W"Вы действительно хотите приобрести данный товар за "ORANGE"%d"W"?\n\n");
		D(playerid, D_MEBEL_BUY_3, DSM, ""P"Покупка мебели", string, "Купить", "Отмена" );
		CancelSelectTextDraw( playerid );
		return 1;
	}
	return 0;
}

stock FurniturePreviewObject( playerid, type ) 
{
	new
		world = GetPlayerVirtualWorld( playerid ),
		objectid = GetPVarInt( playerid, "Furn:Object" ),
		pos = GetPVarInt( playerid, "Furn:PlayerPos" );
		
	if( IsValidDynamicObject( furn_object[playerid] ) )
	{
		DestroyDynamicObject( furn_object[playerid] );
		furn_object[playerid] = 0;
	}
	new g_small_string[56],string[56];
	format:g_small_string("ЦЕНА: $%d", furniture_list[type][objectid][f_price]);
	PlayerTextDrawSetString(playerid, furniturePrice[playerid], g_small_string);	
	format:string("%s", furniture_list[type][objectid][f_name]);
	PlayerTextDrawSetString(playerid, furnitureName[playerid], string);
	
	furn_object[playerid] = CreateDynamicObject( furniture_list[type][objectid][f_id], 
												furniture_list[type][objectid][f_pos][0], 
												furniture_list[type][objectid][f_pos][1], 
												furniture_list[type][objectid][f_pos][2], 
												furniture_list[type][objectid][f_pos][3], 
												furniture_list[type][objectid][f_pos][4], 
												furniture_list[type][objectid][f_pos][5], world );
	switch( pos )
	{
		case 1:
		{
			SetPlayerPos( playerid, -490.3429, -260.2866, 3600.0859 );
			SetPVarInt( playerid, "Furn:PlayerPos", 2 );
		}
		
		case 2:
		{
			SetPlayerPos( playerid, -489.3429, -260.2866, 3600.0859 );
			SetPVarInt( playerid, "Furn:PlayerPos", 1 );
		}
	}
	
	return 1;
}
AddFurniture( index, ftype, object, subtype) {
	for(new i; i < GetMaxFurnHouse(index); i++) {
		if(!HFurn[index][i][f_id]) {
			switch(subtype) {
				case 0:	{
					HFurn[index][i][f_model] = furniture_list[ftype][object][f_id];
					
					HFurn[index][i][f_name][0] = EOS;
					strcat( HFurn[index][i][f_name], furniture_list[ftype][object][f_name], 32 );
				}
			}
			HFurn[index][i][f_hid] = gHouses[index][houseID];
			HFurn[index][i][f_state] = 0;
			new query[256];
			mysql_format(connects, query, sizeof(query), "INSERT INTO `furn` \
				( `f_hid` `f_model`, `f_name` ) VALUES \
				( '%d', '%d', '%e' )",
				HFurn[index][i][f_hid],
				HFurn[index][i][f_model],
				HFurn[index][i][f_name]
			);
			mysql_tquery(connects, query, "InsertFurniture", "dd", index, i);
			break;
		}
	}
}
UpdateFurnitureHouse(house, furnitureid) {
	new query[256];
	mysql_format(connects, query, sizeof(query), "UPDATE `furn` \
	SET `f_position` = '%f|%f|%f', \
		`f_rotation` = '%f|%f|%f', \
		`f_state` = %d \
	WHERE `f_id` = %d AND `f_hid` = %d LIMIT 1",
		HFurn[house][furnitureid][f_pos][0],
		HFurn[house][furnitureid][f_pos][1],
		HFurn[house][furnitureid][f_pos][2],
		HFurn[house][furnitureid][f_rot][0],
		HFurn[house][furnitureid][f_rot][1],
		HFurn[house][furnitureid][f_rot][2],
		HFurn[house][furnitureid][f_state],
		HFurn[house][furnitureid][f_id],
		gHouses[house][houseID]
	);
	mysql_tquery(connects, query);
	return 1;
}

DeleteFurnitureHouse(h, fid) {
	new query[156];
	mysql_format(connects, query, sizeof(query), "DELETE FROM `furn` \
	WHERE `f_id` = %d AND `f_hid` = %d LIMIT 1",
		HFurn[h][fid][f_id],
		gHouses[h][houseID]
	);
	mysql_tquery(connects, query );
	
	HFurn[h][fid][f_id] =
	HFurn[h][fid][f_state] = 
	HFurn[h][fid][f_object] =
	HFurn[h][fid][f_model] = 0;
	
	HFurn[h][fid][f_name][0] = EOS;
	
	for( new i = 0; i != 3; i++ ) {
		HFurn[h][fid][f_pos][i] = 
		HFurn[h][fid][f_rot][i] = 0.0;
	}
	return 1;
}
CB: LoadFurnitureHouse(house) {
	new rows;		
	cache_get_row_count(rows);
	new g_small_string[256];
	if(rows) {
		for(new max_furn; max_furn < rows; max_furn++) {
			if(!HFurn[house][max_furn][f_id]) {
				cache_get_value_name_int(max_furn, "f_id", HFurn[house][max_furn][f_id]);
				cache_get_value_name_int(max_furn, "f_hid", HFurn[house][max_furn][f_hid]);
				cache_get_value_name_int(max_furn, "f_state", HFurn[house][max_furn][f_state]);
				cache_get_value_name_int(max_furn, "f_model", HFurn[house][max_furn][f_model]);
				
				cache_get_value_name(max_furn, "f_position", g_small_string, 128);
				sscanf(g_small_string,"p<|>a<f>[3]", HFurn[house][max_furn][f_pos]);
				
				cache_get_value_name(max_furn, "f_rotation", g_small_string, 128);
				sscanf( g_small_string,"p<|>a<f>[3]", HFurn[house][max_furn][f_rot] );
				
				cache_get_value_name(max_furn, "f_name", g_small_string);
				strmid(HFurn[house][max_furn][f_name], g_small_string, 0, strlen(g_small_string), sizeof g_small_string);
				
				if( HFurn[house][max_furn][f_state] )
				{
					HFurn[house][max_furn][f_object] = CreateDynamicObject(
						HFurn[house][max_furn][f_model],
						HFurn[house][max_furn][f_pos][0], HFurn[house][max_furn][f_pos][1], HFurn[house][max_furn][f_pos][2],
						HFurn[house][max_furn][f_rot][0], HFurn[house][max_furn][f_rot][1], HFurn[house][max_furn][f_rot][2],
						gHouses[house][houseID], -1 
					);
				}
			}
		}
	}
	gHouses[house][hCountFurn] = rows;
	return 1;
}
stock ShowHouseFurnList(playerid, house, page) {
	new g_big_string[1524],g_small_string[156];
	strcat( g_big_string, ""W"Предмет\t"W"Статус\n" );
	
	new 
		idx = page * FURN_PAGE,
		slot = 0,
		max_furn = GetMaxFurnHouse( house ),
		max_page = floatround( float( max_furn ) / FURN_PAGE, floatround_ceil ) - 1;
		
	SetPVarInt(playerid, "Hpanel:FPage", page);	
	SetPVarInt(playerid, "HPanel:FPageMax", max_page);
		
	for(new i = idx; i < max_furn; i++) {
		if(HFurn[house][i][f_id]) {
			format:g_small_string(  ""P"%i. "G"%s \t%s"G"\n",idx + ( slot + 1 ), HFurn[house][i][f_name],HFurn[house][i][f_state] == 0 ? (""G"Не установлено"):(""P"Установлено" ));
			strcat( g_big_string, g_small_string );
			g_dialog_select[playerid][slot] = i;
			slot++;
			if(slot == FURN_PAGE) {
				strcat(g_big_string, "Следующая страница");
	   	    	break;
			}
		}
	}
	if(page || (page && slot < FURN_PAGE)) strcat( g_big_string, "\nПредыдущая страница");
	if(!slot && page < max_page) {
		DeletePVar(playerid, "Hpanel:FPage");
		DeletePVar(playerid, "HPanel:FPageMax");
		ErrorMessage(playerid,"У Вас нет мебели");
		return 1;
	}
	SetPVarInt( playerid, "Hpanel:FAll", slot);
	D(playerid, D_HOUSE_MEBEL, DIALOG_STYLE_TABLIST_HEADERS, "Управление мебелью", g_big_string, "Выбрать", "Назад");
	return 1;
}
CB: InsertFurniture(index, i) {
	HFurn[index][i][f_id] = cache_insert_id();
	return 1;
}
Furn_OnPlayerEditDynamicObject(playerid, objectid, response, Float:x, Float:y, Float:z, Float:rx, Float:ry, Float:rz) {
	switch(GetPVarInt(playerid, "Furn:Edit")) {
		case 2: {
			new
				h = GetPVarInt( playerid, "Hpanel:HId" ),
				fid = GetPVarInt( playerid, "Hpanel:FId" );
			if(response == EDIT_RESPONSE_FINAL || response == EDIT_RESPONSE_CANCEL) {
				if(!IsValidDynamicObject(objectid)) {
					ShowHouseFurnList( playerid, h, GetPVarInt( playerid, "Hpanel:FPage" ) );
					return ErrorMessage(playerid, !"Неверный идентификатор объекта. Попробуйте еще раз");
				}				
				if(objectid == HFurn[h][fid][f_object]) {
					MoveDynamicObject( objectid, x, y, z, 10.0, rx, ry, rz );
					HFurn[h][fid][f_pos][0] = x, 
					HFurn[h][fid][f_pos][1] = y, 
					HFurn[h][fid][f_pos][2] = z,
					HFurn[h][fid][f_rot][0] = rx, 
					HFurn[h][fid][f_rot][1] = ry, 
					HFurn[h][fid][f_rot][2] = rz;
						
					UpdateFurnitureHouse( h, fid );
					ShowHouseFurnList( playerid, h, GetPVarInt( playerid, "Hpanel:FPage" ) );	
					DeletePVar( playerid, "Furn:Edit" );
				}
			}
		}
	}
	return 1;
}