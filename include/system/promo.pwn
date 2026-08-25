
//============= [DIALOGS]
DIALOG_PROMOCOD,
DIALOG_PROMOCODACTIVE,
DIALOG_PROMOCODCREATE,
DIALOG_CHECKPROMO,
//=======================

//=================== [ONDIALOGRESPONSE] ===========
case DIALOG_PROMOCOD:
   			{
   			    if(response)
   			    {
   			        switch(listitem)
   			        {
   			            case 0:
   			            {
                                new string[1222];
								format(string, sizeof(string), ""c_white"Введите промокод для того чтобы получить приз:");
								SPD(playerid, DIALOG_PROMOCODACTIVE, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} Активация промокода", string, "Далее", "Закрыть");
						}
						case 1:
						{
						     	new string[1222];
								format(string, sizeof(string), ""c_yellow"Промокод - "c_white" уникальный набор символов,озволяющий Вам и человеку, использующему Ваш промокод получить\nвознаграждание. Промокод разделен на "c_yellow"10 уровней"c_white", с повыщением которого Вы будете получать ценные призы.\nВы можете самостоятельно создать "c_yellow"свой промокод"c_white", при условии что он свободен.\n\nОднако стоит помнить что промокод стоит "c_yellow"3.000.000 рублей.\n"c_white"Вы можете использовать "c_yellow"латиницу и кириллицу, # и цифры.\n"c_red"Примичиание!"c_white" Первый символ прмоокода должен быть - "c_red"@"c_red"");
								SPD(playerid, DIALOG_PROMOCODCREATE, DIALOG_STYLE_INPUT, "{ff0000}Создание промокода", string, "Далее", "Закрыть");
						}
   			        }
   			    }
   			}
   			
			case DIALOG_PROMOCODACTIVE:
			{
				if(response)
				{
				    if(!strlen(inputtext))
				    {
		        		new string[1222];
						format(string, sizeof(string), ""c_white"Введите промокод для того чтобы получить приз:");
						SPD(playerid, DIALOG_PROMOCODACTIVE, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} Активация промокода", string, "Далее", "Закрыть");
				    }
					else
					{
						new query[256], Cache: result, rows;
						mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode_activations WHERE `uid` =' %d' AND `code` = '%s'", GetPlayerAccountID(playerid), inputtext);
						result = mysql_query(mysql, query, true);
						rows = cache_num_rows();
						if(rows)
						{
							format(query, sizeof query, "Вы уже активировали этот промокод");
							SCM(playerid, COLOR_WHITE, query);

		    				new string[1222];
							format(string, sizeof(string), ""c_white"Введите промокод для того чтобы получить приз:");
							SPD(playerid, DIALOG_PROMOCODACTIVE, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} Активация промокода", string, "Далее", "Закрыть");
							cache_delete(result);
							return 1;
						}

						cache_delete(result);

						mysql_format(mysql, query, sizeof query, "SELECT * FROM promocode WHERE `code` = '%s'", inputtext);
						result = mysql_query(mysql, query, true);

						rows = cache_num_rows();

						cache_delete(result);

						if(!rows)
						{
							SendClientMessage(playerid, 0x999999FF, "Введенный промокод не существует");
							new string[1222];
							format(string, sizeof(string), ""c_white"Введите промокод для того чтобы получить приз:");
							SPD(playerid, DIALOG_PROMOCODACTIVE, DIALOG_STYLE_INPUT, "{ff0000}BLACK RUSSIA --> {FFFFFF} Активация промокода", string, "Далее", "Закрыть");
							return 1;
						}

						format(query, sizeof query, ""c_white"Поздравляем!\n\nВы успешно активировали промокод: "c_yellow"%s.\nВы получили: 15.000 рублей и 2 exp\n\nПриятной игры на: "c_yellow""SERVER_NAME"!", inputtext);
						SPD(playerid, 45448889889, DIALOG_STYLE_MSGBOX, "{ff0000}BLACK RUSSIA --> {FFFFFF} Активация промокода", query, "Закрыть", "");
						GivePlayerMoneyEx(playerid, 15000);
						g_player[playerid][P_EXP] = 2;
						UpdatePlayerDatabaseInt(playerid, "exp", 2);

						mysql_format(mysql, query, sizeof query, "UPDATE `promocode` SET `code` = '%d' WHERE `uid` = '%s'", inputtext, GetPlayerAccountID(playerid));
						mysql_query(mysql, query, false);
						mysql_format(mysql, query, sizeof query, "INSERT INTO `promocode_activations` (`uid`, `code`) VALUES ('%d','%e')", GetPlayerAccountID(playerid), inputtext);
						mysql_query(mysql, query, false);
					}
				}
			}
			case DIALOG_PROMOCODCREATE:
			{
			    if(response)
			    {
			        if(!strlen(inputtext))
			        {
	     				new string[1222];
						format(string, sizeof(string), ""c_yellow"Промокод - "c_white" уникальный набор символов,озволяющий Вам и человеку, использующему Ваш промокод получить\nвознаграждание. Промокод разделен на "c_yellow"10 уровней"c_white", с повыщением которого Вы будете получать ценные призы.\nВы можете самостоятельно создать "c_yellow"свой промокод"c_white", при условии что он свободен.\n\nОднако стоит помнить что промокод стоит "c_yellow"3.000.000 рублей.\n"c_white"Вы можете использовать "c_yellow"латиницу и кириллицу, # и цифры.\n"c_red"Примичиание!"c_white" Первый символ прмоокода должен быть - "c_red"@"c_red"");
						SPD(playerid, DIALOG_PROMOCODCREATE, DIALOG_STYLE_INPUT, "{ff0000} Создание промокода", string, "Далее", "Закрыть");
			        }
					else
					{
						new query[450];
						mysql_format(mysql, query, sizeof query, "SELECT * FROM `promocode` WHERE `code` = '%s'", pPromo[playerid][pCode]);
						mysql_query(mysql, query);
						new rows, fileds;
						cache_get_data(rows, fileds);
						if(rows)
						{
							new string[1222];
							format(string, sizeof(string), ""c_yellow"Промокод - "c_white" уникальный набор символов,озволяющий Вам и человеку, использующему Ваш промокод получить\nвознаграждание. Промокод разделен на "c_yellow"10 уровней"c_white", с повыщением которого Вы будете получать ценные призы.\nВы можете самостоятельно создать "c_yellow"свой промокод"c_white", при условии что он свободен.\n\nОднако стоит помнить что промокод стоит "c_yellow"3.000.000 рублей.\n"c_white"Вы можете использовать "c_yellow"латиницу и кириллицу, # и цифры.\n"c_red"Примичиание!"c_white" Первый символ прмоокода должен быть - "c_red"@"c_red"");
							SPD(playerid, DIALOG_PROMOCODCREATE, DIALOG_STYLE_INPUT, "{ff0000} Создание промокода", string, "Далее", "Закрыть");
							return SCM(playerid, 0x999999FF, "Такой промокод уже есть в базе данных");
						}
						else
						{
							strmid(pPromo[playerid][pCode], inputtext, 0, strlen(inputtext), 32);
							mysql_format(mysql, query, sizeof query, "INSERT INTO `promocode` (`code`, `promo`) VALUES ('%s', '1')", pPromo[playerid][pCode], pPromo[playerid][pPromocod]);
							mysql_query(mysql, query, false);
							new string[128];
							format(string, sizeof(string), "{FFFF00}| {FFFFFF} Вы успешно создали промокод: %s", pPromo[playerid][pCode]);
							SCM(playerid, COLOR_WHITE, string);
							SCM(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF} Введите /checkpromo для управлением промокодом.");

							GivePlayerMoneyEx(playerid, -3000000);
						}
					}
			    }
			}
//==================================================


//CMD
CMD:promo(playerid)
{
    new string[1222];
	format(string, sizeof(string), ""c_red"#1"c_white"\t\tАктивировать промокод"c_gray"\t\tнажмите для взаимодействия\n"c_red"#2"c_white"\t\tСоздать промокод"c_gray"\tнажмите для взаимодействия");
	SPD(playerid, DIALOG_PROMOCOD, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Промокод", string, "Далее", "Закрыть");
}
CMD:checkpromo(playerid)
{
	if(pPromo[playerid][pPromocod] == 0)
	{
	    SCM(playerid, COLOR_WHITE, "{FFFF00}| {FFFFFF} У вас нет промокода( /mm --> промокод)");
	}
	else
	{
	    new string[1222];
		format(string, sizeof(string), ""c_red"#1"c_white"\tВаш промокод:"c_red"\t%s\n"c_red"#2"c_white"\tУровень промокода: "c_red"0\n"c_red"#3"c_white"\tСобщение о промокоде"c_gray"\t(в разработке)\n"c_red"#4"c_white"\tИнформаиця о промокодах"c_gray"\t(в разработке)", pPromo[playerid][pCode]);
		SPD(playerid, DIALOG_CHECKPROMO, DIALOG_STYLE_LIST, "{ff0000}BLACK RUSSIA --> {FFFFFF} Промокод", string, "Далее", "Закрыть");
	}
}