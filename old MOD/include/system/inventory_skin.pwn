CMD:myskins(playerid)
{
			new fmt_text[640],
			Cache: result,
			id;

		mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM inventory_skins WHERE owner_skin='%d'", GetPlayerAccountID(playerid));
		result = mysql_query(mysql, fmt_text, true);

		new rows = cache_num_rows();

		if(!rows)
		{
			SendClientMessage(playerid, 0x999999FF, "У Вас нет личного скина");
			CheckSkinPlayer(playerid);
		}
		else
		{	

				new query[60],
					skin_id, use, skin_use[24];
                
				format(fmt_text, sizeof fmt_text, "");

				for(new i = 0; i < rows; i ++)
				{
					id = cache_get_field_content_int(i, "id");
					skin_id = cache_get_field_content_int(i, "skin_id");
					use = cache_get_field_content_int(i, "use_skin");

					if(use > 0) skin_use = "{636363}[используется]";
					else  skin_use = "";

					format
					(
						query,
						sizeof query,
						"{FFFFFF}%d. Скин (%d) %s\n",
					    i + 1, 
				 	  	skin_id, skin_use
					);
					strcat(fmt_text, query);
					SetPlayerListitemValue(playerid, i, id);
				}

				Dialog
				(
					playerid, 1789, DIALOG_STYLE_LIST,
					"{FFCD00}Выберите скин",
					fmt_text,
					"Выбрать", "Закрыть"
				);
		}

		cache_delete(result);

	return 1;
}
stock CheckSkinPlayer(playerid)
{
	new query[144], Cache:result;
	mysql_format(mysql, query, sizeof query, "SELECT * FROM inventory_skins WHERE owner_skin = %d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();
	cache_delete(result);

	if(!rows)
	{
		mysql_format(mysql, query, sizeof query, "INSERT INTO inventory_skins (owner_skin,skin_id,use_skin) VALUES (%d,%d,1)", GetPlayerAccountID(playerid), GetPlayerSkinEx(playerid));
		mysql_query(mysql, query, false);
		if(mysql_errno()) return SCM(playerid, -1, "CheckSkinPlayer | SQL ERROR 1");
		SendClientMessage(playerid, -1, ""SC"Добавлена одежда в инвентарь");
		
		return 1;
	}
	return 0;
}
stock GivePlayerOwnableSkin(playerid, skinid)
{
		/*new fmt_text[144],
		Cache: result,
		query[64];

		mysql_format(mysql, query, sizeof query, "INSERT INTO inventory_skins (owner_skin,skin_id) VALUES (%d,%d)", GetPlayerAccountID(playerid), skinid);
		result = mysql_query(mysql, query, true);
		cache_delete(result);*/
		
		new query[144], Cache:result;
	mysql_format(mysql, query, sizeof query, "SELECT * FROM inventory_skins WHERE owner_skin = %d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();
	cache_delete(result);

		mysql_format(mysql, query, sizeof query, "INSERT INTO inventory_skins (owner_skin,skin_id,use_skin) VALUES (%d,%d,0)", GetPlayerAccountID(playerid), skinid);
		mysql_query(mysql, query, false);
		if(mysql_errno()) return SCM(playerid, -1, "CheckSkinPlayer | SQL ERROR 1");
		SendClientMessage(playerid, -1, ""SC"Добавлена одежда в инвентарь");
		SCM(playerid, -1, "Позравляем! Вы приобрели новую одежду. Чтобы использовать /myskins");
		return 1;
		//format(fmt_text, sizeof(fmt_text), "");
}

stock ShowOwnableSkinLoadDialog(playerid, id)
{
	SetPVarInt(playerid, "ownableskin_id", id);

	Dialog
	(
		playerid, 1790, DIALOG_STYLE_LIST,
		"{FFCD00}Система управление скином",
		"1. Использовать\n"\
		"{888888}2. Удалить",
		"Выбрать", "Закрыть"
	);
}


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 1789)
    {
        if(response)
        {
            new idx = GetPlayerListitemValue(playerid, listitem);

            ShowOwnableSkinLoadDialog(playerid, idx);
        }
    }
    if(dialogid == 1790)
    {
        if(response)
        {
            new idx = GetPVarInt(playerid, "ownableskin_id");
            
            new query[164], skin_id, use, use_skin_id,
            Cache:result;
            mysql_format(mysql, query, sizeof query, "SELECT skin_id, use_skin FROM inventory_skins WHERE id = %d ", idx);
            result = mysql_query(mysql, query, true);
            skin_id = cache_get_row_int(0, 0);
            use = cache_get_row_int(0, 1);
            cache_delete(result);

            mysql_format(mysql, query, sizeof query, "SELECT id FROM inventory_skins WHERE `use_skin` = 1 LIMIT 1");
            result = mysql_query(mysql, query, true);
            use_skin_id = cache_get_row_int(0, 0);
            cache_delete(result);

            switch(listitem + 1)
            {
                case 1:
                {
                    if(GetPlayerInterior(playerid))
                    {
                        SendClientMessage(playerid, 0x999999FF, ""USC"Вы должны находится на улице");
                        return 1;
                    }
                    if(use)
                    {
                        SendClientMessage(playerid, 0x999999FF, "Одежда используется.");
                        return 1;
                    }
                    new fmt_str[12];
                    SetPlayerData(playerid, P_SKIN, skin_id);
                    UpdatePlayerDatabaseInt(playerid, "skin", skin_id);

                    mysql_format(mysql, query, sizeof query, "UPDATE inventory_skins SET `use_skin` = 0 WHERE `id` = %d", use_skin_id);
                    mysql_query(mysql, query, false);

                    mysql_format(mysql, query, sizeof query, "UPDATE inventory_skins SET `use_skin` = 1 WHERE `id` = %d", idx);
                    mysql_query(mysql, query, false);

                    SetPlayerSkinInit(playerid);
                    SendClientMessage(playerid, 0x66CC33FF, ""SC" Вы надели одежду!");
                    SetPlayerSkinFixWerton(playerid);
                }
                case 2:
                {	
                    if(use)
                    {
                        SendClientMessage(playerid, 0x999999FF, ""USC"Нельзя удалить одежду которая используется.");
                        return 1;
                    }
                    mysql_format(mysql, query, sizeof query, "DELETE FROM inventory_skins WHERE id=%d", idx);
                    mysql_query(mysql, query, false);

                }
            }
        }
        
        return 1;
    }
    #if defined skin_OnDialogResponse
return skin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse skin_OnDialogResponse
#if defined skin_OnDialogResponse
forward skin_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif
