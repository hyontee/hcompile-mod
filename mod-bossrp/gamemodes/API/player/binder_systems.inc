stock load_binder_player(playerid)
{
	format(String256, sizeof(String256), "SELECT * FROM `player_binder` WHERE `userid` = '%i'", pData[playerid][pMysqlID]);
	new Result:rdd = sql_queryEx(zConn, String256, QUERY_CACHED);

	if(sql_num_rows(rdd)) 
	{
	    sql_get_field(rdd, 1, pData[playerid][pBinderCommand_1]);
	    sql_get_field(rdd, 2, pData[playerid][pBinderCommand_2]);
	    sql_get_field(rdd, 3, pData[playerid][pBinderCommand_3]);
	    sql_get_field(rdd, 4, pData[playerid][pBinderCommand_4]);
	    sql_get_field(rdd, 5, pData[playerid][pBinderCommand_5]);
	    sql_get_field(rdd, 6, pData[playerid][pBinderCommand_6]);
	    sql_get_field(rdd, 7, pData[playerid][pBinderCommand_7]);
	    sql_get_field(rdd, 8, pData[playerid][pBinderCommand_8]);
	    sql_get_field(rdd, 9, pData[playerid][pBinderCommand_9]);
	    sql_get_field(rdd, 10, pData[playerid][pBinderCommand_10]);
	    sql_get_field(rdd, 11, pData[playerid][pBinderCommand_11]);
	    sql_get_field(rdd, 12, pData[playerid][pBinderCommand_12]);
	    sql_get_field(rdd, 13, pData[playerid][pBinderCommand_13]);
	    sql_get_field(rdd, 14, pData[playerid][pBinderCommand_14]);
	    sql_get_field(rdd, 15, pData[playerid][pBinderCommand_15]);
	    sql_get_field(rdd, 16, pData[playerid][pBinderCommand_16]);
	    sql_get_field(rdd, 17, pData[playerid][pBinderCommand_17]);
	    sql_get_field(rdd, 18, pData[playerid][pBinderCommand_18]);
	    sql_get_field(rdd, 19, pData[playerid][pBinderCommand_19]);
	    sql_get_field(rdd, 20, pData[playerid][pBinderCommand_20]);
	}
	else
	{

		format(String256, sizeof(String256), "INSERT INTO `player_binder` VALUES ('%i', \
			'0', '0', '0', '0', '0', '0', '0', '0',\
			'0', '0', '0', '0', '0', '0', '0', '0',\
			'0', '0', '0', '0')", pData[playerid][pMysqlID]);
		sql_queryEx(zConn, String256);
 	}

	sql_free_result(rdd);
	return true;
}

stock dialog_all_binder(playerid, dialogid, response, listitem, inputtext[]) 
{
	switch(dialogid)
	{
		case DIALOG_SELECT_BINDER:
		{
			if(!response)
				return true;

			SetPVarIntNew(playerid, "binder_number", listitem+1);
			return show_dialog_new_bind(playerid);
		}
		case DIALOG_NEW_COMMAND_BINDER:
		{
			if(!response)
				return show_binder_menu(playerid);

			if(strlen(inputtext) < 3 || strlen(inputtext) > 128 || !strlen(inputtext)) 
				return show_dialog_new_bind(playerid);

			if(inputtext[0] != '/')
			{
				SendErr(playerid, "Биндер должен начинаться с команды!");
				return show_dialog_new_bind(playerid);
			}

			if(check_no_valid_symbol_text(inputtext) || check_sql_injection_text(inputtext))
			{
				SendErr(playerid,"Бинд содержит запрещенные символы!");
				return show_dialog_new_bind(playerid);
			}	

			new 
				bid = GetPVarIntNew(playerid, "binder_number");

			DeletePVarNew(playerid, "binder_number");

			format(String512, sizeof(String512), "UPDATE `player_binder` SET `command%i` = '%s' WHERE `userid` = '%i'",
			bid,
			inputtext,
			pData[playerid][pMysqlID]);
            sql_queryEx(zConn, String512, QUERY_THREADED);		


            load_binder_player(playerid);

            format(String144, sizeof(String144), "Вы обновили биндер %i команды. Используйте /bq %i", bid, bid);
			SendSucc(playerid, String144);
		}
	}
	return true;
}

stock show_dialog_new_bind(playerid)
{
	SPD(playerid, DIALOG_NEW_COMMAND_BINDER, DIALOG_STYLE_INPUT, !""cBLUE"Редактирование биндера", !"\
		"cWH"Введите новую команду с действием для биндера\n\
		"cGREY"Примечание: начало должно быть с команды, длина текста не более 128 символов", 
		!"Применить", !"Назад");
	return true;
}

stock show_binder_menu(playerid)
{
	format(String2048,sizeof(String2048),""cGREY"Наименование\t"cGREY"Команда\t"cGREY"Состояние\n\
    "cBLUE"1. "cWH"Биндер - 1\t/bq 1\t%s\n\
    "cBLUE"2. "cWH"Биндер - 2\t/bq 2\t%s\n\
    "cBLUE"3. "cWH"Биндер - 3\t/bq 3\t%s\n\
    "cBLUE"4. "cWH"Биндер - 4\t/bq 4\t%s\n\
    "cBLUE"5. "cWH"Биндер - 5\t/bq 5\t%s\n\
    "cBLUE"6. "cWH"Биндер - 6\t/bq 6\t%s\n\
    "cBLUE"7. "cWH"Биндер - 7\t/bq 7\t%s\n\
    "cBLUE"8. "cWH"Биндер - 8\t/bq 8\t%s\n\
    "cBLUE"9. "cWH"Биндер - 9\t/bq 9\t%s\n\
    "cBLUE"10. "cWH"Биндер - 10\t/bq 10\t%s\n\
    "cBLUE"11. "cWH"Биндер - 11\t/bq 11\t%s\n\
    "cBLUE"12. "cWH"Биндер - 12\t/bq 12\t%s\n\
    "cBLUE"13. "cWH"Биндер - 13\t/bq 13\t%s\n\
    "cBLUE"14. "cWH"Биндер - 14\t/bq 14\t%s\n\
    "cBLUE"15. "cWH"Биндер - 15\t/bq 15\t%s\n\
    "cBLUE"16. "cWH"Биндер - 16\t/bq 16\t%s\n\
    "cBLUE"17. "cWH"Биндер - 17\t/bq 17\t%s\n\
    "cBLUE"18. "cWH"Биндер - 18\t/bq 18\t%s\n\
    "cBLUE"19. "cWH"Биндер - 19\t/bq 19\t%s\n\
    "cBLUE"20. "cWH"Биндер - 20\t/bq 20\t%s",
    strlen(pData[playerid][pBinderCommand_1]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_2]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_3]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_4]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_5]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_6]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_7]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_8]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_9]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_10]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_11]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_12]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_13]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_14]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_15]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_16]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_17]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_18]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_19]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"),
    strlen(pData[playerid][pBinderCommand_20]) < 2 ? (""cLRED"[Неактивен]") : (""cGR"[Активен]"));

   	SPD(playerid, DIALOG_SELECT_BINDER, DIALOG_STYLE_TABLIST_HEADERS,!""cBLUE"Настройка биндера",String2048,!"Открыть",!"Закрыть"); 
	return true;
}

CMD:editbinder(playerid)
{
	load_binder_player(playerid);

	show_binder_menu(playerid);

	return true;
}

CMD:bq(playerid, params[])
{
	if(pData[playerid][pMut]) 
		return SendClientMessage(playerid, CGRAY, "У Вас бан чата. Используйте /mutetime чтобы узнать время бана.");

	if(pTemp[playerid][pMutM])
		return SendClientMessage(playerid, CGRAY, "У Вас затычка во рту.");

	if(sscanf(params, "d",params[0]))
		return SendErr(playerid, "/bq [1-20]");

	if(params[0] < 1 || params[0] > 20)
		return SendErr(playerid, "Клавиша бинда от 1 до 20");

	load_binder_player(playerid);

	switch(params[0])
	{
		case 1:
		{
			if(strlen(pData[playerid][pBinderCommand_1]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_1]);
			PC_EmulateCommand(playerid, String144);
		}
		case 2:
		{
			if(strlen(pData[playerid][pBinderCommand_2]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_2]);
			PC_EmulateCommand(playerid, String144);
		}
		case 3:
		{
			if(strlen(pData[playerid][pBinderCommand_3]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_3]);
			PC_EmulateCommand(playerid, String144);
		}
		case 4:
		{
			if(strlen(pData[playerid][pBinderCommand_4]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_4]);
			PC_EmulateCommand(playerid, String144);
		}
		case 5:
		{
			if(strlen(pData[playerid][pBinderCommand_5]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_5]);
			PC_EmulateCommand(playerid, String144);
		}
		case 6:
		{
			if(strlen(pData[playerid][pBinderCommand_6]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_6]);
			PC_EmulateCommand(playerid, String144);
		}
		case 7:
		{
			if(strlen(pData[playerid][pBinderCommand_7]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_7]);
			PC_EmulateCommand(playerid, String144);
		}
		case 8:
		{
			if(strlen(pData[playerid][pBinderCommand_8]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_8]);
			PC_EmulateCommand(playerid, String144);
		}
		case 9:
		{
			if(strlen(pData[playerid][pBinderCommand_9]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_9]);
			PC_EmulateCommand(playerid, String144);
		}
		case 10:
		{
			if(strlen(pData[playerid][pBinderCommand_10]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_10]);
			PC_EmulateCommand(playerid, String144);
		}
		case 11:
		{
			if(strlen(pData[playerid][pBinderCommand_11]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_11]);
			PC_EmulateCommand(playerid, String144);
		}
		case 12:
		{
			if(strlen(pData[playerid][pBinderCommand_12]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_12]);
			PC_EmulateCommand(playerid, String144);
		}
		case 13:
		{
			if(strlen(pData[playerid][pBinderCommand_13]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_13]);
			PC_EmulateCommand(playerid, String144);
		}
		case 14:
		{
			if(strlen(pData[playerid][pBinderCommand_14]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_14]);
			PC_EmulateCommand(playerid, String144);
		}
		case 15:
		{
			if(strlen(pData[playerid][pBinderCommand_15]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_15]);
			PC_EmulateCommand(playerid, String144);
		}
		case 16:
		{
			if(strlen(pData[playerid][pBinderCommand_16]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_16]);
			PC_EmulateCommand(playerid, String144);
		}
		case 17:
		{
			if(strlen(pData[playerid][pBinderCommand_17]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_17]);
			PC_EmulateCommand(playerid, String144);
		}
		case 18:
		{
			if(strlen(pData[playerid][pBinderCommand_18]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_18]);
			PC_EmulateCommand(playerid, String144);
		}
		case 19:
		{
			if(strlen(pData[playerid][pBinderCommand_19]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_19]);
			PC_EmulateCommand(playerid, String144);
		}
		case 20:
		{
			if(strlen(pData[playerid][pBinderCommand_20]) < 2)
				return SendErr(playerid, "Данный бинд не настроен");

			format(String144, sizeof(String144), "%s", pData[playerid][pBinderCommand_20]);
			PC_EmulateCommand(playerid, String144);
		}
	}	
	return true;
}