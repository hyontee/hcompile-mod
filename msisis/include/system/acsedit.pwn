//-Это в начало мода
new Text: acs_TD[26];
new PlayerText: acs_coords_PTD[MAX_PLAYERS][1];

//-Это к диалогам
DIALOG_ACS_EDIT

//-Это в OnPlayerDialogResponse(playerid)
			case DIALOG_ACS_EDIT:
			{
				if(response)
				{
				  	CreateAcsTextDraw(playerid);

					SetPlayerAttachedObject
					(
						playerid,
						GetPVarInt(playerid, "slot"),
						GetPVarInt(playerid, "modelid"),
						GetPVarInt(playerid, "bone"),
						GetPVarFloat(playerid, "num_1"),
						GetPVarFloat(playerid, "num_2"),
                        GetPVarFloat(playerid, "num_3"),
                        GetPVarFloat(playerid, "num_4"),
						GetPVarFloat(playerid, "num_5"),
						GetPVarFloat(playerid, "num_6"),
						GetPVarFloat(playerid, "num_7"),
						GetPVarFloat(playerid, "num_7"),
						GetPVarFloat(playerid, "num_7"),
						0
					);

					SetPVarInt(playerid, "acs_use", 1);
					SetPVarInt(playerid, "updateacs", 1);
				}
				else
				{
					SetPVarInt(playerid, "acs_use", 0);
				}
			}
			
//-к stock
stock CreateAcs(playerid)
{
	new query[220], rows, Cache: result;

	format(query, sizeof query, "SELECT slot, modelid, bone, x, y, z, rX, rY, rZ, scale FROM accessories WHERE id=%d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	for(new i; i < rows; i++)
	{
 		new slot = cache_get_field_content_int(i, "slot"),
		modelid = cache_get_field_content_int(i, "modelid"),
		bone = cache_get_field_content_int(i, "bone"),
		Float: x = cache_get_field_content_float(i, "x"),
  		Float: y = cache_get_field_content_float(i, "y"),
   		Float: z = cache_get_field_content_float(i, "z"),
   		Float: rX = cache_get_field_content_int(i, "rX"),
   		Float: rY = cache_get_field_content_int(i, "rY"),
   		Float: rZ = cache_get_field_content_int(i, "rZ"),
	   	Float: scale = cache_get_field_content_float(i, "scale");

		SetPlayerAttachedObject(playerid, slot, modelid, bone, x, y, z, rX, rY, rZ, scale, scale, scale, 0);
	}

	cache_delete(result);
}


//-это в public OnPlayerSpawn(playerid)
CreateAcs(playerid);


//-Это в OnPlayeClickTextDraw
	if(clickedid == acs_TD[1])
	{
	    for(new i; i < sizeof acs_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, acs_TD[i]);
		}

		RemovePlayerAttachedObject(playerid, GetPVarInt(playerid, "slot"));

		DeletePVar(playerid, "acs_use");
		DeletePVar(playerid, "acs_td_use");
		DeletePVar(playerid, "slot");
		DeletePVar(playerid, "modelid");
		DeletePVar(playerid, "bone");

		DeletePVar(playerid, "num_1");
		DeletePVar(playerid, "num_2");
		DeletePVar(playerid, "num_3");
		DeletePVar(playerid, "num_4");
		DeletePVar(playerid, "num_5");
		DeletePVar(playerid, "num_6");
		DeletePVar(playerid, "num_7");

		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		TogglePlayerControllable(playerid, true);
	}
	if(clickedid == acs_TD[2])
	{
		for(new i; i < sizeof acs_TD; i++)
	    {
	    	TextDrawHideForPlayer(playerid, acs_TD[i]);
		}

		new query[220], Cache: result;

		if(GetPVarInt(playerid, "updateacs") == 0)
		{
			format
			(
				query, sizeof query,
				"INSERT INTO accessories (id, slot, modelid, bone, x, y, z, rX, rY, rZ, scale)"\
				"VALUES ('%d', '%d', '%d', '%d', '%f', '%f', '%f', '%f', '%f', '%f', '%f')",
				GetPlayerAccountID(playerid),
				GetPVarInt(playerid, "slot"),
				GetPVarInt(playerid, "modelid"),
				GetPVarInt(playerid, "bone"),
				GetPVarFloat(playerid, "num_1"),
				GetPVarFloat(playerid, "num_2"),
				GetPVarFloat(playerid, "num_3"),
				GetPVarFloat(playerid, "num_4"),
				GetPVarFloat(playerid, "num_5"),
				GetPVarFloat(playerid, "num_6"),
				GetPVarFloat(playerid, "num_7")
			);
		}
		else
		{
			format
			(
				query, sizeof query,
				"UPDATE accessories SET modelid=%d, bone=%d, x=%f, y=%f, z=%f, rX=%f, rY=%f, rZ=%f, scale=%f WHERE id=%d AND slot=%d",
				GetPVarInt(playerid, "modelid"),
				GetPVarInt(playerid, "bone"),
				GetPVarFloat(playerid, "num_1"),
				GetPVarFloat(playerid, "num_2"),
				GetPVarFloat(playerid, "num_3"),
				GetPVarFloat(playerid, "num_4"),
				GetPVarFloat(playerid, "num_5"),
				GetPVarFloat(playerid, "num_6"),
				GetPVarFloat(playerid, "num_7"),
				GetPlayerAccountID(playerid),
				GetPVarInt(playerid, "slot")
			);
		}

		result = mysql_query(mysql, query, true);

		cache_delete(result);

		DeletePVar(playerid, "acs_use");
		DeletePVar(playerid, "acs_td_use");
		DeletePVar(playerid, "slot");
		DeletePVar(playerid, "modelid");
		DeletePVar(playerid, "bone");

		DeletePVar(playerid, "num_1");
		DeletePVar(playerid, "num_2");
		DeletePVar(playerid, "num_3");
		DeletePVar(playerid, "num_4");
		DeletePVar(playerid, "num_5");
		DeletePVar(playerid, "num_6");
		DeletePVar(playerid, "num_7");

		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		TogglePlayerControllable(playerid, true);
		SCM(playerid, -1, "{FFFF00}| {FFFFFF}Аксессуар успешно сохранен.");
	}
	if(clickedid == acs_TD[3])
	{
		TextDrawHideForPlayer(playerid, acs_TD[9 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawShowForPlayer(playerid, acs_TD[2 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[16 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[3]);
		TextDrawShowForPlayer(playerid, acs_TD[10]);
		TextDrawShowForPlayer(playerid, acs_TD[17]);
		SetPVarInt(playerid, "acs_td_use", 1);

		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_3"));
  		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);
	}
	if(clickedid == acs_TD[4])
	{
		TextDrawHideForPlayer(playerid, acs_TD[9 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawShowForPlayer(playerid, acs_TD[2 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[16 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[4]);
		TextDrawShowForPlayer(playerid, acs_TD[11]);
		TextDrawShowForPlayer(playerid, acs_TD[18]);
		SetPVarInt(playerid, "acs_td_use", 2);

		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_1"));
  		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);
	}
	if(clickedid == acs_TD[5])
	{
		TextDrawHideForPlayer(playerid, acs_TD[9 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawShowForPlayer(playerid, acs_TD[2 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[16 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[5]);
		TextDrawShowForPlayer(playerid, acs_TD[12]);
		TextDrawShowForPlayer(playerid, acs_TD[19]);
		SetPVarInt(playerid, "acs_td_use", 3);

		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_2"));
  		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);
	}
	if(clickedid == acs_TD[6])
	{
		TextDrawHideForPlayer(playerid, acs_TD[9 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawShowForPlayer(playerid, acs_TD[2 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[16 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[6]);
		TextDrawShowForPlayer(playerid, acs_TD[13]);
		TextDrawShowForPlayer(playerid, acs_TD[20]);
		SetPVarInt(playerid, "acs_td_use", 4);

		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_7"));
  		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);
	}
	if(clickedid == acs_TD[7])
	{
		TextDrawHideForPlayer(playerid, acs_TD[9 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawShowForPlayer(playerid, acs_TD[2 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[16 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[7]);
		TextDrawShowForPlayer(playerid, acs_TD[14]);
		TextDrawShowForPlayer(playerid, acs_TD[21]);
		SetPVarInt(playerid, "acs_td_use", 5);

		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_4"));
  		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);
	}
	if(clickedid == acs_TD[8])
	{
		TextDrawHideForPlayer(playerid, acs_TD[9 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawShowForPlayer(playerid, acs_TD[2 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[16 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[8]);
		TextDrawShowForPlayer(playerid, acs_TD[15]);
		TextDrawShowForPlayer(playerid, acs_TD[22]);
		SetPVarInt(playerid, "acs_td_use", 6);

		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_5"));
  		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);
	}
	if(clickedid == acs_TD[9])
	{
		TextDrawHideForPlayer(playerid, acs_TD[9 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawShowForPlayer(playerid, acs_TD[2 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[16 + GetPVarInt(playerid, "acs_td_use")]);
		TextDrawHideForPlayer(playerid, acs_TD[9]);
		TextDrawShowForPlayer(playerid, acs_TD[16]);
		TextDrawShowForPlayer(playerid, acs_TD[23]);
		SetPVarInt(playerid, "acs_td_use", 7);

		new acs_coords[11];
		format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_6"));
  		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);
	}
	if(clickedid == acs_TD[24] || clickedid == acs_TD[25])
	{
		new Float: x, Float: y, Float: z, Float: scale, Rx, Ry, Rz, acs_coords[11];

		switch(GetPVarInt(playerid, "acs_td_use"))
	    {
	        case 1:
	        {
				//-влево/вправо
				if(clickedid == acs_TD[24])
				{
					if(GetPVarFloat(playerid, "num_3") >= 0.500000) return 1;
	        		x += 0.01;
				}
				else
				{
				    if(GetPVarFloat(playerid, "num_3") <= -0.500000) return 1;
				    x -= 0.01;
				}

				format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_3") + x);
	        }
			case 2:
			{
				//-вверх/вниз
				if(clickedid == acs_TD[24])
				{
					if(GetPVarFloat(playerid, "num_1") >= 1.000000) return 1;
					y += 0.01;
				}
				else
				{
					if(GetPVarFloat(playerid, "num_1") <= -1.000000) return 1;
					y -= 0.01;
				}

				format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_1") + y);
			}
			case 3:
			{
			    //-от себя/на себя
			    if(clickedid == acs_TD[24])
				{
					if(GetPVarFloat(playerid, "num_2") >= 0.500000) return 1;
					z += 0.01;
				}
				else
				{
					if(GetPVarFloat(playerid, "num_2") <= -0.500000) return 1;
					z -= 0.01;
				}

				format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_2") + z);
			}
			case 4:
			{
			    //-масштаб
			    if(clickedid == acs_TD[24])
				{
					if(GetPVarFloat(playerid, "num_7") >= 2.000000) return 1;
					scale += 0.1;
				}
				else
				{
					if(GetPVarFloat(playerid, "num_7") <= 0.100000) return 1;
					scale -= 0.1;
				}

			    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_7") + scale);
			}
			case 5:
			{
			    //-поворот по X
			    if(clickedid == acs_TD[24])
				{
					if(GetPVarFloat(playerid, "num_4") >= 360.000000) SetPVarFloat(playerid, "num_4", -5.000000);
					Rx += 5;
				}
				else
				{
					if(GetPVarFloat(playerid, "num_4") <= -360.000000) SetPVarFloat(playerid, "num_4", 5.000000);
					Rx -= 5;
				}

			    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_4") + Rx);
			}
			case 6:
			{
				//-поворот по Y
				if(clickedid == acs_TD[24])
				{
					if(GetPVarFloat(playerid, "num_5") >= 360.000000) SetPVarFloat(playerid, "num_5", -5.000000);
					Ry += 5;
				}
				else
				{
					if(GetPVarFloat(playerid, "num_5") <= -360.000000) SetPVarFloat(playerid, "num_5", 5.000000);
					Ry -= 5;
				}

			    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_5") + Ry);
			}
			case 7:
			{
				//-поворот по Z
				if(clickedid == acs_TD[24])
				{
					if(GetPVarFloat(playerid, "num_6") >= 360.000000) SetPVarFloat(playerid, "num_6", -5.000000);
					Rz += 5;
				}
				else
				{
					if(GetPVarFloat(playerid, "num_6") <= -360.000000) SetPVarFloat(playerid, "num_6", 5.000000);
					Rz -= 5;
				}

			    format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_6") + Rz);
			}
	    }

		PlayerTextDrawHide(playerid, acs_coords_PTD[playerid][0]);
		PlayerTextDrawSetString(playerid, acs_coords_PTD[playerid][0], acs_coords);
		PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);

		SetPVarFloat(playerid, "num_1", GetPVarFloat(playerid, "num_1") + y);
		SetPVarFloat(playerid, "num_2", GetPVarFloat(playerid, "num_2") + z);
		SetPVarFloat(playerid, "num_3", GetPVarFloat(playerid, "num_3") + x);
		SetPVarFloat(playerid, "num_4", GetPVarFloat(playerid, "num_4") + Rx);
		SetPVarFloat(playerid, "num_5", GetPVarFloat(playerid, "num_5") + Ry);
		SetPVarFloat(playerid, "num_6", GetPVarFloat(playerid, "num_6") + Rz);
		SetPVarFloat(playerid, "num_7", GetPVarFloat(playerid, "num_7") + scale);

		SetPlayerAttachedObject
		(
			playerid,
			GetPVarInt(playerid, "slot"),
			GetPVarInt(playerid, "modelid"),
			GetPVarInt(playerid, "bone"),
			GetPVarFloat(playerid, "num_1"),
			GetPVarFloat(playerid, "num_2"),
			GetPVarFloat(playerid, "num_3"),
			GetPVarFloat(playerid, "num_4"),
			GetPVarFloat(playerid, "num_5"),
			GetPVarFloat(playerid, "num_6"),
			GetPVarFloat(playerid, "num_7"),
			GetPVarFloat(playerid, "num_7"),
			GetPVarFloat(playerid, "num_7"),
			0
		);
	}

//-Это в CreateTextDraws, ну или где у вас хранятся текстдравы
	//ТЕКСТ  "РЕЖИМ КАСТОМИЗАЦИЙ"
	acs_TD[0] = TextDrawCreate(35.0000, 18.0000, "txd:bracstext");
	TextDrawTextSize(acs_TD[0], 127.0000, 45.0000);
	TextDrawAlignment(acs_TD[0], 1);
	TextDrawColor(acs_TD[0], -1);
	TextDrawBackgroundColor(acs_TD[0], 255);
	TextDrawFont(acs_TD[0], 4);

	//КНОПКА "ВЫХОД"
	acs_TD[1] = TextDrawCreate(600.0000, 0.1, "txd:bracsbtnexit");
	TextDrawTextSize(acs_TD[1], 45.0000, 50.0000);
	TextDrawAlignment(acs_TD[1], 1);
	TextDrawColor(acs_TD[1], -1);
	TextDrawBackgroundColor(acs_TD[1], 255);
	TextDrawFont(acs_TD[1], 4);
	TextDrawSetSelectable(acs_TD[1], true);

	//КНОПКА "СОХРАНИТЬ"
	acs_TD[2] = TextDrawCreate(453.0000, 355.0000, "txd:bracssave");
	TextDrawTextSize(acs_TD[2], 130.0000, 40.0000);
	TextDrawAlignment(acs_TD[2], 1);
	TextDrawColor(acs_TD[2], -1);
	TextDrawBackgroundColor(acs_TD[2], 255);
	TextDrawFont(acs_TD[2], 4);
	TextDrawSetSelectable(acs_TD[2], true);

//-НЕ НАЖАТЫЕ КНОПКИ
   	//КНОПКА "ВЛЕВО/ВПРАВО"
	acs_TD[3] = TextDrawCreate(35.0000, 65.0000, "txd:bracsn1");
	TextDrawTextSize(acs_TD[3], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[3], 1);
	TextDrawColor(acs_TD[3], -1);
	TextDrawBackgroundColor(acs_TD[3], 255);
	TextDrawFont(acs_TD[3], 4);
	TextDrawSetSelectable(acs_TD[3], true);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acs_TD[4] = TextDrawCreate(35.0000, 110.0000, "txd:bracsn2");
	TextDrawTextSize(acs_TD[4], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[4], 1);
	TextDrawColor(acs_TD[4], -1);
	TextDrawBackgroundColor(acs_TD[4], 255);
	TextDrawFont(acs_TD[4], 4);
	TextDrawSetSelectable(acs_TD[4], true);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acs_TD[5] = TextDrawCreate(35.0000, 155.0000, "txd:bracsn3");
	TextDrawTextSize(acs_TD[5], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[5], 1);
	TextDrawColor(acs_TD[5], -1);
	TextDrawBackgroundColor(acs_TD[5], 255);
	TextDrawFont(acs_TD[5], 4);
	TextDrawSetSelectable(acs_TD[5], true);

	//КНОПКА "МАСШТАБ"
	acs_TD[6] = TextDrawCreate(35.0000, 200.0000, "txd:bracsn4");
	TextDrawTextSize(acs_TD[6], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[6], 1);
	TextDrawColor(acs_TD[6], -1);
	TextDrawBackgroundColor(acs_TD[6], 255);
	TextDrawFont(acs_TD[6], 4);
	TextDrawSetSelectable(acs_TD[6], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acs_TD[7] = TextDrawCreate(35.0000, 245.0000, "txd:bracsn5");
	TextDrawTextSize(acs_TD[7], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[7], 1);
	TextDrawColor(acs_TD[7], -1);
	TextDrawBackgroundColor(acs_TD[7], 255);
	TextDrawFont(acs_TD[7], 4);
	TextDrawSetSelectable(acs_TD[7], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acs_TD[8] = TextDrawCreate(35.0000, 290.0000, "txd:bracsn6");
	TextDrawTextSize(acs_TD[8], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[8], 1);
	TextDrawColor(acs_TD[8], -1);
	TextDrawBackgroundColor(acs_TD[8], 255);
	TextDrawFont(acs_TD[8], 4);
	TextDrawSetSelectable(acs_TD[8], true);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acs_TD[9] = TextDrawCreate(35.0000, 335.0000, "txd:bracsn7");
	TextDrawTextSize(acs_TD[9], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[9], 1);
	TextDrawColor(acs_TD[9], -1);
	TextDrawBackgroundColor(acs_TD[9], 255);
	TextDrawFont(acs_TD[9], 4);
	TextDrawSetSelectable(acs_TD[9], true);

//-НАЖАТЫЕ КНОПКИ
	//КНОПКА "ВЛЕВО/ВПРАВО"
	acs_TD[10] = TextDrawCreate(35.0000, 65.0000, "txd:bracsa1");
	TextDrawTextSize(acs_TD[10], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[10], 1);
	TextDrawColor(acs_TD[10], -1);
	TextDrawBackgroundColor(acs_TD[10], 255);
	TextDrawFont(acs_TD[10], 4);

	//КНОПКА "ВВЕРХ/ВНИЗ"
	acs_TD[11] = TextDrawCreate(35.0000, 110.0000, "txd:bracsa2");
	TextDrawTextSize(acs_TD[11], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[11], 1);
	TextDrawColor(acs_TD[11], -1);
	TextDrawBackgroundColor(acs_TD[11], 255);
	TextDrawFont(acs_TD[11], 4);

	//КНОПКА "ОТ СЕБЯ/НА СЕБЯ"
	acs_TD[12] = TextDrawCreate(35.0000, 155.0000, "txd:bracsa3");
	TextDrawTextSize(acs_TD[12], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[12], 1);
	TextDrawColor(acs_TD[12], -1);
	TextDrawBackgroundColor(acs_TD[12], 255);
	TextDrawFont(acs_TD[12], 4);

	//КНОПКА "МАСШТАБ"
	acs_TD[13] = TextDrawCreate(35.0000, 200.0000, "txd:bracsa4");
	TextDrawTextSize(acs_TD[13], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[13], 1);
	TextDrawColor(acs_TD[13], -1);
	TextDrawBackgroundColor(acs_TD[13], 255);
	TextDrawFont(acs_TD[13], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ X"
	acs_TD[14] = TextDrawCreate(35.0000, 245.0000, "txd:bracsa5");
	TextDrawTextSize(acs_TD[14], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[14], 1);
	TextDrawColor(acs_TD[14], -1);
	TextDrawBackgroundColor(acs_TD[14], 255);
	TextDrawFont(acs_TD[14], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Y"
	acs_TD[15] = TextDrawCreate(35.0000, 290.0000, "txd:bracsa6");
	TextDrawTextSize(acs_TD[15], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[15], 1);
	TextDrawColor(acs_TD[15], -1);
	TextDrawBackgroundColor(acs_TD[15], 255);
	TextDrawFont(acs_TD[15], 4);

	//КНОПКА "ПОВОРОТ ПО ОСИ Z"
	acs_TD[16] = TextDrawCreate(35.0000, 335.0000, "txd:bracsa7");
	TextDrawTextSize(acs_TD[16], 117.0000, 42.0000);
	TextDrawAlignment(acs_TD[16], 1);
	TextDrawColor(acs_TD[16], -1);
	TextDrawBackgroundColor(acs_TD[16], 255);
	TextDrawFont(acs_TD[16], 4);

	//РЕДАКТОР "ВЛЕВО/ВПРАВО"
	acs_TD[17] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm1");
	TextDrawTextSize(acs_TD[17], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[17], 1);
	TextDrawColor(acs_TD[17], -1);
	TextDrawBackgroundColor(acs_TD[17], 255);
	TextDrawFont(acs_TD[17], 4);
	TextDrawSetProportional(acs_TD[17], 0);
	TextDrawSetShadow(acs_TD[17], 0);

	//РЕДАКТОР "ВВЕРХ/ВНИЗ"
	acs_TD[18] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm2");
	TextDrawTextSize(acs_TD[18], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[18], 1);
	TextDrawColor(acs_TD[18], -1);
	TextDrawBackgroundColor(acs_TD[18], 255);
	TextDrawFont(acs_TD[18], 4);
	TextDrawSetProportional(acs_TD[18], 0);
	TextDrawSetShadow(acs_TD[18], 0);

	//РЕДАКТОР "ОТ СЕБЯ/НА СЕБЯ"
	acs_TD[19] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm3");
	TextDrawTextSize(acs_TD[19], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[19], 1);
	TextDrawColor(acs_TD[19], -1);
	TextDrawBackgroundColor(acs_TD[19], 255);
	TextDrawFont(acs_TD[19], 4);
	TextDrawSetProportional(acs_TD[19], 0);
	TextDrawSetShadow(acs_TD[19], 0);

	//РЕДАКТОР "МАСШТАБ"
	acs_TD[20] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm4");
	TextDrawTextSize(acs_TD[20], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[20], 1);
	TextDrawColor(acs_TD[20], -1);
	TextDrawBackgroundColor(acs_TD[20], 255);
	TextDrawFont(acs_TD[20], 4);
	TextDrawSetProportional(acs_TD[20], 0);
	TextDrawSetShadow(acs_TD[20], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ X"
	acs_TD[21] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm5");
	TextDrawTextSize(acs_TD[21], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[21], 1);
	TextDrawColor(acs_TD[21], -1);
	TextDrawBackgroundColor(acs_TD[21], 255);
	TextDrawFont(acs_TD[21], 4);
	TextDrawSetProportional(acs_TD[21], 0);
	TextDrawSetShadow(acs_TD[21], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Y"
	acs_TD[22] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm6");
	TextDrawTextSize(acs_TD[22], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[22], 1);
	TextDrawColor(acs_TD[22], -1);
	TextDrawBackgroundColor(acs_TD[22], 255);
	TextDrawFont(acs_TD[22], 4);
	TextDrawSetProportional(acs_TD[22], 0);
	TextDrawSetShadow(acs_TD[22], 0);

	//РЕДАКТОР "ПОВОРОТ ПО ОСИ Z"
	acs_TD[23] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm7");
	TextDrawTextSize(acs_TD[23], 180.0000, 230.0000);
	TextDrawAlignment(acs_TD[23], 1);
	TextDrawColor(acs_TD[23], -1);
	TextDrawBackgroundColor(acs_TD[23], 255);
	TextDrawFont(acs_TD[23], 4);
	TextDrawSetProportional(acs_TD[23], 0);
	TextDrawSetShadow(acs_TD[23], 0);

	acs_TD[24] = TextDrawCreate(460.0000, 205.0000, "plus");
	TextDrawTextSize(acs_TD[24], 50.0000, 50.0000);
	TextDrawAlignment(acs_TD[24], 1);
	TextDrawColor(acs_TD[24], -1);
	TextDrawBackgroundColor(acs_TD[24], 255);
	TextDrawFont(acs_TD[24], 4);
	TextDrawSetProportional(acs_TD[23], 0);
	TextDrawSetShadow(acs_TD[24], 0);
	TextDrawSetSelectable(acs_TD[24], true);

	acs_TD[25] = TextDrawCreate(530.0000, 205.0000, "minus");
	TextDrawTextSize(acs_TD[25], 50.0000, 50.0000);
	TextDrawAlignment(acs_TD[25], 1);
	TextDrawColor(acs_TD[25], -1);
	TextDrawBackgroundColor(acs_TD[23], 255);
	TextDrawFont(acs_TD[25], 4);
	TextDrawSetProportional(acs_TD[23], 0);
	TextDrawSetShadow(acs_TD[25], 0);
	TextDrawSetSelectable(acs_TD[25], true);

//-Это в конец мода
CMD:acs(playerid, params[])
{
	extract params -> new slot, modelid, bone; else return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: {FFFF00}/{FFFFFF}acs [слот] [модель] [кость]");
	if(!(0 <= slot <= 9)) return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: слот от 0 до 9");
	if(!(1 <= bone <= 18)) return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: кость от 1 до 18"), SCM(playerid, -1, "{FFFF00}| {FFFFFF}Кости 1 - Спина, 2 - Голова, 3 - Левое предплечье, 4 - Правое предплечье, 5 - Левая рука, 6 - Правая рука."), SCM(playerid, -1, "{FFFF00}| {FFFFFF}7 - Левое бедро, 8 - Правое бедро, 9 - Левая нога, 10 - Правая нога, 11 - Правая голень, 12 - Левая голень."), SCM(playerid, -1, "{FFFF00}| {FFFFFF}13 - Левое предплечье, 14 - Правое предплечье, 15 - Левое плечо, 16 - Правое плечо, 17 - Шея, 18 - Челюсть.");

	if(GetPVarInt(playerid, "acs_use") == 1) return 1;

	new query[220], rows, Cache: result;

	format(query, sizeof query, "SELECT x, y, z, rX, rY, rZ, scale FROM accessories WHERE id=%d AND slot=%d", GetPlayerAccountID(playerid), slot);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	new Float: x =  cache_get_field_content_float(0, "x"),
  	Float: y =  cache_get_field_content_float(0, "y"),
   	Float: z =  cache_get_field_content_float(0, "z"),
	Float: rX = cache_get_field_content_int(0, "rX"),
   	Float: rY = cache_get_field_content_int(0, "rY"),
   	Float: rZ = cache_get_field_content_int(0, "rZ"),
 	Float: scale =  cache_get_field_content_float(0, "scale");

	if(rows)
	{
		SetPVarInt(playerid, "slot", slot);
		SetPVarInt(playerid, "modelid", modelid);
		SetPVarInt(playerid, "bone", bone);
		SetPVarFloat(playerid, "num_1", x);
		SetPVarFloat(playerid, "num_2", y);
		SetPVarFloat(playerid, "num_3", z);
		SetPVarFloat(playerid, "num_4", rX);
		SetPVarFloat(playerid, "num_5", rY);
		SetPVarFloat(playerid, "num_6", rZ);
		SetPVarFloat(playerid, "num_7", scale);

		Dialog
		(
			playerid, DIALOG_ACS_EDIT, DIALOG_STYLE_MSGBOX,
			"{FFFF00}Server Name {FFFFFF}| Редактирование аксов",
			"Вы уверены что хотите редактировать акс?",
			"Да", "Нет"
		);
	}
	else
	{
		CreateAcsTextDraw(playerid);

		SetPVarInt(playerid, "slot", slot);
		SetPVarInt(playerid, "modelid", modelid);
		SetPVarInt(playerid, "bone", bone);
		SetPVarFloat(playerid, "num_7", 1.0);
		SetPVarInt(playerid, "updateacs", 0);

		SetPlayerAttachedObject(playerid, slot, modelid, bone, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, GetPVarFloat(playerid, "num_7"), GetPVarFloat(playerid, "num_7"), GetPVarFloat(playerid, "num_7"), 0);
		SetPVarInt(playerid, "acs_use", 1);
	}

	cache_delete(result);

	return 1;
}

stock CreateAcsTextDraw(playerid)
{
	SelectTextDraw(playerid, COR_SERVER);

	TextDrawShowForPlayer(playerid, acs_TD[0]);
	TextDrawShowForPlayer(playerid, acs_TD[1]);
	TextDrawShowForPlayer(playerid, acs_TD[2]);
	TextDrawShowForPlayer(playerid, acs_TD[4]);
	TextDrawShowForPlayer(playerid, acs_TD[5]);
	TextDrawShowForPlayer(playerid, acs_TD[6]);
	TextDrawShowForPlayer(playerid, acs_TD[7]);
	TextDrawShowForPlayer(playerid, acs_TD[8]);
	TextDrawShowForPlayer(playerid, acs_TD[9]);
	TextDrawShowForPlayer(playerid, acs_TD[10]);
	TextDrawShowForPlayer(playerid, acs_TD[17]);
	TextDrawShowForPlayer(playerid, acs_TD[24]);
	TextDrawShowForPlayer(playerid, acs_TD[25]);

	new acs_coords[144];
	format(acs_coords, sizeof acs_coords, "%f", GetPVarFloat(playerid, "num_3"));

	acs_coords_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, acs_coords);
	PlayerTextDrawLetterSize(playerid, acs_coords_PTD[playerid][0], 0.3000, 1.6000);
	PlayerTextDrawAlignment(playerid, acs_coords_PTD[playerid][0], 2);
	PlayerTextDrawColor(playerid, acs_coords_PTD[playerid][0], 0xFFFFFFFF);
	PlayerTextDrawBackgroundColor(playerid, acs_coords_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, acs_coords_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, acs_coords_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, acs_coords_PTD[playerid][0], 0);

	PlayerTextDrawShow(playerid, acs_coords_PTD[playerid][0]);

	SetPVarInt(playerid, "acs_td_use", 1);
	TogglePlayerControllable(playerid, true);
}

CMD:editacs(playerid, params[])
{
	extract params -> new slot; else return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: {FFFF00}/{FFFFFF}editacs [слот]");

	if(!(0 <= slot <= 9)) return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: слот от 0 до 9");

    new query[220], rows, Cache: result;

	format(query, sizeof query, "SELECT modelid, bone, x, y, x, rX, rY, rZ, scale FROM accessories WHERE id=%d AND slot=%d", GetPlayerAccountID(playerid), slot);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

	new modelid = cache_get_field_content_int(0, "modelid"),
	bone = cache_get_field_content_int(0, "bone"),
	Float: x =  cache_get_field_content_float(0, "x"),
  	Float: y =  cache_get_field_content_float(0, "y"),
   	Float: z =  cache_get_field_content_float(0, "z"),
   	Float: rX = cache_get_field_content_int(0, "rX"),
   	Float: rY = cache_get_field_content_int(0, "rY"),
   	Float: rZ = cache_get_field_content_int(0, "rZ"),
   	Float: scale =  cache_get_field_content_float(0, "scale");

	if(rows)
	{
       	SetPVarInt(playerid, "slot", slot);
		SetPVarInt(playerid, "modelid", modelid);
		SetPVarInt(playerid, "bone", bone);
		SetPVarFloat(playerid, "num_1", x);
		SetPVarFloat(playerid, "num_2", y);
		SetPVarFloat(playerid, "num_3", z);
		SetPVarFloat(playerid, "num_4", rX);
		SetPVarFloat(playerid, "num_5", rY);
		SetPVarFloat(playerid, "num_6", rZ);
		SetPVarFloat(playerid, "num_7", scale);

		CreateAcsTextDraw(playerid);

		SetPlayerAttachedObject
		(
			playerid,
			GetPVarInt(playerid, "slot"),
			GetPVarInt(playerid, "modelid"),
			GetPVarInt(playerid, "bone"),
			GetPVarFloat(playerid, "num_1"),
			GetPVarFloat(playerid, "num_2"),
   			GetPVarFloat(playerid, "num_3"),
      		GetPVarFloat(playerid, "num_4"),
			GetPVarFloat(playerid, "num_5"),
			GetPVarFloat(playerid, "num_6"),
			GetPVarFloat(playerid, "num_7"),
			GetPVarFloat(playerid, "num_7"),
			GetPVarFloat(playerid, "num_7"),
			0
		);

		SetPVarInt(playerid, "acs_use", 1);
		SetPVarInt(playerid, "updateacs", 1);
	}
	else
	{
	    SCM(playerid, -1, "{FFFF00}| {FFFFFF}В данном слоту нет аксессуара");
	}

	cache_delete(result);

	return 1;

}

CMD:delacs(playerid, params[])
{
	extract params -> new slot; else return SCM(playerid, -1, "{FFFF00}| {FFFFFF}Используйте: {FFFF00}/{FFFFFF}delacs [слот]");

	new query[220], rows, Cache: result;

	format(query, sizeof query, "SELECT x FROM accessories WHERE id=%d AND slot=%d", GetPlayerAccountID(playerid), slot);
	result = mysql_query(mysql, query, true);

	rows = cache_num_rows();

 	if(rows)
 	{
 		format(query, sizeof query, "DELETE FROM accessories WHERE id=%d AND slot=%d", GetPlayerAccountID(playerid), slot);
		result = mysql_query(mysql, query, true);
		RemovePlayerAttachedObject(playerid, slot);
		SCM(playerid, -1, "{FFFF00}| {FFFFFF}Аксессуар успешно удален");
	}
	else
	{
		SCM(playerid, -1, "{FFFF00}| {FFFFFF}Нет аксессуара в этом слоту");
	}

	cache_delete(result);

	return 1;
}
