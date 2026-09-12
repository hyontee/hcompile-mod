
CMD:myskins(playerid)
{
    new fmt_text[4096], // Безопасный размер для большинства случаев
        Cache: result,
        id;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM inventory_skins WHERE owner_skin='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows();

    if(!rows)
    {
        ShowNewNotification(playerid, 2, 6, 0, 0, "У Вас нет никаких скинов", "");
        CheckSkinPlayer(playerid);
    }
    else
    {	
        new query[150],
            skin_id, use, skin_use[50];
            
        // Заголовок для таблицы
        format(fmt_text, sizeof fmt_text, "№\tНазвание (ID)\tСтатус скина\n");
        
        for(new i = 0; i < rows; i++)
        {
            if(strlen(fmt_text) > 4096) // Защита от переполнения
            ShowNewNotification(playerid, 2, 6, 0, 0, "ОШИБКА! У вас очень много скинов.", "");
                break;
                
            id = cache_get_field_content_int(i, "id");
            skin_id = cache_get_field_content_int(i, "skin_id");
            use = cache_get_field_content_int(i, "use_skin");

            if(use > 0) format(skin_use, sizeof skin_use, "{8EF674}[ надет ]");
            else format(skin_use, sizeof skin_use, "{DCDCDC}[ можно надеть ]");

            format(query, sizeof query, "{FA8072}%d\t{FFFFFF}Одежда (%d)\t%s\n", i + 1, skin_id, skin_use);
            strcat(fmt_text, query);
            SetPlayerListitemValue(playerid, i, id);
        }

        Dialog(
            playerid, 1789, DIALOG_STYLE_TABLIST_HEADERS,
            "{FA8072}Инвентарь {FFFFFF}| Выберите игровой скин из списка ниже",
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
		ShowNewNotification(playerid, 1, 6, 0, 0, "Одежда Добавлена в инвентарь", "");
		
		return 1;
	}
	return 0;
}
stock GivePlayerOwnableSkin(playerid, skinid)
{

		new query[144], Cache:result;
	mysql_format(mysql, query, sizeof query, "SELECT * FROM inventory_skins WHERE owner_skin = %d", GetPlayerAccountID(playerid));
	result = mysql_query(mysql, query, true);

	new rows = cache_num_rows();
	cache_delete(result);

		mysql_format(mysql, query, sizeof query, "INSERT INTO inventory_skins (owner_skin,skin_id,use_skin) VALUES (%d,%d,0)", GetPlayerAccountID(playerid), skinid);
		mysql_query(mysql, query, false);
		if(mysql_errno()) return SCM(playerid, -1, "CheckSkinPlayer | SQL ERROR 1");
		ShowNewNotification(playerid, 1, 6, 0, 0, "Одежда добавлена в инвентарь", "");
		
		return 1;
		//format(fmt_text, sizeof(fmt_text), "");
}

stock ShowOwnableSkinLoadDialog(playerid, id)
{
	SetPVarInt(playerid, "ownableskin_id", id);

	Dialog
(
    playerid, 1790, DIALOG_STYLE_TABLIST_HEADERS,
    "{FA8072}Инвентарь {FFFFFF}| Выберите действие для взаимодействия со скином",
    "№\tДействие\tОписание кнопки\n"\
    "{FA8072}1.\t{FFFFFF}Использовать\t{DCDCDC}Надеть этот скин на персонажа\n"\
    "{FA8072}2.\t{FFFFFF}Удалить\t{DCDCDC}Удалить скин из инвентаря",
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
                        ShowNewNotification(playerid, 1, 6, 0, 0, "Установка одежды недоступна в здании", "");
                        return 1;
                    }
                    if(use)
                    {
                        ShowNewNotification(playerid, 2, 6, 0, 0, "Одежда используется!", "");
                        return 1;
                    }
                    new fmt_str[12];
                    SetPlayerData(playerid, P_SKIN, skin_id);
                    mysql_format(mysql, query, sizeof query, "UPDATE inventory_skins SET `use_skin` = 0 WHERE `owner_skin` = %d", GetPlayerAccountID(playerid));
mysql_query(mysql, query, false);
                    UpdatePlayerDatabaseInt(playerid, "skin", skin_id);

                   

                    mysql_format(mysql, query, sizeof query, "UPDATE inventory_skins SET `use_skin` = 1 WHERE `id` = %d", idx);
                    mysql_query(mysql, query, false);

                    SetPlayerSkinInit(playerid);
                    ShowNewNotification(playerid, 1, 6, 0, 0, "Одежда надета.", "");
                    SetPlayerSkin(playerid, skin_id);
                }
                case 2:
                {	
                    if(use)
                    {
                        ShowNewNotification(playerid, 1, 6, 0, 0, "Эта одежда используется!", "");
                        return 1;
                    }
                    mysql_format(mysql, query, sizeof query, "DELETE FROM inventory_skins WHERE id=%d", idx);
                    mysql_query(mysql, query, false);
                    ShowNewNotification(playerid, 1, 6, 0, 0, "Скин удалён!", "");

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

