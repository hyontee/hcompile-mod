/*ShowDialog(playerid, DialogID(DIALOG_FRAC_MEMBERS_ACTION), DIALOG_STYLE_TABLIST_HEADERS, 
		fmt_str_header, 
		""#CLR_BLUE"1. "#CLR_WHITE"Информация\n"\
		""#CLR_BLUE"2. "#CLR_WHITE"Изменить ранг сотрудника\n"\
		""#CLR_BLUE"3. "#CLR_WHITE"Изменить должность сотрудника\n"\
		""#CLR_BLUE"4. "#CLR_WHITE"Уволить сотрудника",
		"Далее", "Назад"
	);


stock Fraction:ShowWarehouseState(playerid, fraction_id, bool:save = false) {
    t_string = ""colserver"[№] Наименование\tПатроны\t"colserver"Доступно с\n";
    switch(fraction_id) {
        case FRACTION_LSPD: {
            format(t_string, sizeof t_string, 
                "[0] Desert Eagle\t21\t%s(%d)\n[1] Shotgun\t30\t%s(%d)\n[2] MP5\t90\t%s(%d)\n[3] M4A1\t150\t[%s(%d)\n[4] Rifle\t30\t%s(%d)\n[5] Броня\t1\t%s(%d)\n[6] Спец оружие"
            );
        }
    }
}*/
/*new
	WareHouseName[3][3][32] = {
		{
			"Desert Eagle",
			"Shotgun",
			"MP5",
			"M4A1",
			"Rifle",
			"Броня",
			"Спец оружие",
			""
		},
		{
			"Desert Eagle",
			"Shotgun",
			"MP5",
			"M4A1",
			"Rifle",
			"Sniper Rifle",
			"Броня",
			"Спец оружие"
		},
		{
			"Desert Eagle",
			"Shotgun",
			"MP5",
			"M4A1",
			"Rifle",
			"Дубинка",
			"Броня",
			""
		}
	};
stock Fraction:ShowWarehouseState(playerid, fraction_id, bool:save = false) {
    t_string = ""colserver"[№] Наименование\t"colserver"Доступно с\n";
    switch(fraction_id) {
        case FRACTION_LSPD, FRACTION_ARMY_SF, FRACTION_SFPD, FRACTION_LVPD, FRACTION_ARMY_LV: {
			for(new i; i < sizeof (WareHouseName[]); i++) {
				format(string_, sizeof string_, "[%d] %s\t%s(%d)\n", i, WareHouseName[0][i], fInfo[fraction_id][fWareHouse][i])
				strcat(t_string, string_);
			}
            format(t_string, sizeof t_string, 
                "[0] Desert Eagle\t21\t%s(%d)\n[1] Shotgun\t30\t%s(%d)\n[2] MP5\t90\t%s(%d)\n[3] M4A1\t150\t[%s(%d)\n[4] Rifle\t30\t%s(%d)\n[5] Броня\t1\t%s(%d)\n[6] Спец оружие"
            );
        }
		case FRACTION_FBI: {

		}
		case FRACTION_CITYHALL: {

		}
    }
	ShowDialog(playerid, DialogID(D_FRACTION_WAREHOUSE), DIALOG_STYLE_TABLIST_HEADERS, 
		 ""colserver"Склад: "colwhi"Оружия", t_string, "Далее", "Отмена"
	);
	return 1;
}

CMD:waretest(playerid) {
	Fraction:ShowWarehouseState(playerid, FRACTION_LSPD, .save = false);
	return 1;
}*/
stock ShowGosGunMenu(playerid)//FRACTION_LSPD .. FRACTION_ARMY_SF, FRACTION_SFPD, FRACTION_LVPD, FRACTION_ARMY_LV
{
	if (!pTemp[playerid][tDutyWork]) {
		return SendClientMessage(playerid, COLOR_GREY, !"Необходимо начать рабочий день");
	}
	return ShowPlayerDialog(playerid, D_BUY_GOV_GUN, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружия",
			""colserver"[№] Оружие\t"colserver"[Патроны]\n\
		 	[0] Desert Eagle\t[21п]\n\
  			[1] Shotgun\t[30п]\n\
		   	[2] MP5\t[90п]\n\
		 	[3] M4A1\t[150п]\n\
		  	[4] Rifle\t[30п]\n\
		  	[5] Броня\n\
		   	[6] Спец оружие\n",
		    "Взять", "Отмена");
}
stock ShowGosGunMenuFBI(playerid)
{
	if (!pTemp[playerid][tDutyWork]) {
		return SendClientMessage(playerid, COLOR_GREY, !"Необходимо начать рабочий день");
	}
	return ShowPlayerDialog(playerid, D_BUY_GOV_GUN_0, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружия",
			""colserver"[№] Оружие\t"colserver"[Патроны]\n\
		 	[0] Desert Eagle\t[21п]\n\
  			[1] Shotgun\t[30п]\n\
		   	[2] MP5\t[90п]\n\
		 	[3] M4A1\t[150п]\n\
		  	[4] Rifle\t[30п]\n\
			[5] Sniper Rifle\t[7п]\n\
		  	[6] Броня\n\
		   	[7] Спец оружие\n",
		    "Взять", "Отмена");
}
stock ShowGosGunMenuCityHall(playerid)
{
	if (!pTemp[playerid][tDutyWork]) {
		return SendClientMessage(playerid, COLOR_GREY, !"Необходимо начать рабочий день");
	}
	return ShowPlayerDialog(playerid, D_BUY_GOV_GUN_1, DIALOG_STYLE_TABLIST_HEADERS, ""colserver"Склад: "colwhi"Оружия",
			""colserver"[№] Оружие\t"colserver"[Патроны]\n\
		 	[0] Desert Eagle\t[21п]\n\
  			[1] Shotgun\t[30п]\n\
		   	[2] MP5\t[90п]\n\
		 	[3] M4A1\t[150п]\n\
		  	[4] Rifle\t[30п]\n\
			[5] Дубинка\t[1 шт]\n\
		  	[6] Броня\n",
		    "Взять", "Отмена");
}