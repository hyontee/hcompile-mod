static const get_buisnes_autosalon_n[][] =
{	
	"",
    " ",
    "",
    "",
    ""
};


public create_realtor_buisnes_other()
{

	realtor_agency_pickup = create_circle_pickup(1085.7275,310.0064,1205.0166, TRIGGER_LBLUE);	

	CreateDynamic3DTextLabel(""cWH" \n"cBLUE"[  ]",-1, \
	1085.7275,310.0064,1205.0166, 2.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, -1, -1);	

	return true;
}


stock open_menu_realtor_buisnes(playerid)
{
	return SPD(playerid, DIALOG_GENERAL_REALTOR_AGENCY, 2, \
	""cBLUE" ", \
	""cBLUE"1. "cWH" \n\
	"cBLUE"2. "cWH" \n\
	"cBLUE"3. "cWH" \n\
	"cBLUE"4. "cWH" \n\
	"cBLUE"5. "cWH" \n\
	"cBLUE"6. "cWH" \n\
	"cBLUE"7. "cWH"  \n\
	"cBLUE"8. "cWH" \n\
	"cBLUE"9. "cWH" \n\
	"cBLUE"10. "cWH"  ", "", "");
}


stock show_free_house_realtor(playerid, last = 0)
{
	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = all_houses; i < idx; i ++)
	{
		if(House[i][house_owned] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				format(fmt_str, sizeof(fmt_str), "%s\n | : %s "cBLUE"[%d]", fmt_str, get_house_class(i), i+1);
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  .");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_HOUSE, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_house_info(playerid, i) 
{	
	new 
		info_sell[32];

	if(House[i][house_sell_count_payday] == -1)
	{
		format(info_sell, 32, ""cGR" ");
	}
	else
	{
		format(info_sell, 32, ""cORANGE"%d   ", House[i][house_sell_count_payday]);
	}

	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH":"cBLUE" %s\n\
		"cWH": "cGR"%d \n\
		"cWH"   : "cGR"%d \n\
		"cWH"  : "cBLUE"%s\n\n\
		"cGREY" >>    GPS", i+1, get_house_class(i), House[i][house_price], House[i][house_takings], info_sell);
	return SPD(playerid, DIALOG_REALTOR_INFO_HOUSE_2, 2, !""cBLUE"  ", String512, !"", !"");
}

stock show_free_apart_realtor(playerid, last = 0)
{
	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = all_flates; i < idx; i ++)
	{
		if(flate[i][flate_owned] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				format(fmt_str, sizeof(fmt_str), "%s\n | : %s "cBLUE"[%d]", fmt_str, get_house_class(i), i+1);
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  ");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_FLATE, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_flate_info(playerid, i) 
{

	new 
		info_sell[32];

	if(flate[i][flate_sell_count_payday] == -1)
	{
		format(info_sell, 32, ""cGR" ");
	}
	else
	{
		format(info_sell, 32, ""cORANGE"%d   ", flate[i][flate_sell_count_payday]);
	}

	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH":"cBLUE" %s\n\
		"cWH": "cGR"%d \n\
		"cWH"   : "cGR"%d \n\
		"cWH"  : "cBLUE"%s\n\n\
		"cGREY" >>    GPS", i+1, get_house_class(i), flate[i][flate_price], flate[i][flate_takings], info_sell);
	return SPD(playerid, DIALOG_REALTOR_INFO_FLATE_2, 2, !""cBLUE"  ", String512, !"", !"");
}

stock show_free_filling_realtor(playerid, last = 0)
{
	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = all_filling; i < idx; i ++)
	{
		if(filling[i][filling_owner_id] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_name_filling(filling[i][filling_type_name]), i+1);
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  ");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_FILL, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_fill_info(playerid, i) 
{

	new 
		info_sell[32];

	if(filling[i][filling_sell_day_payday] == -1)
	{
		format(info_sell, 32, ""cGR" ");
	}
	else
	{
		format(info_sell, 32, ""cORANGE"%d   ", filling[i][filling_sell_day_payday]);
	}

	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH":"cBLUE" %s\n\
		"cWH": "cGR"%d \n\
		"cWH"   : "cGR"%d \n\
		"cWH"  : "cBLUE"%s\n\n\
		"cGREY" >>    GPS", i+1, get_name_filling(filling[i][filling_type_name]), filling[i][filling_price], filling[i][filling_takings], info_sell);
	return SPD(playerid, DIALOG_REALTOR_INFO_FILL_2, 2, !""cBLUE"  ", String512, !"", !"");
}

stock show_free_hotel_realtor(playerid, last = 0)
{
	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = all_hotels; i < idx; i ++)
	{
		if(hotel[i][hotel_owned] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_hotel_name(hotel[i][hotel_class]), i+1);
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  ");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_HOTEL, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_hotel_info(playerid, i) 
{

	new 
		info_sell[32];

	if(hotel[i][hotel_sell_day_payday] == -1)
	{
		format(info_sell, 32, ""cGR" ");
	}
	else
	{
		format(info_sell, 32, ""cORANGE"%d   ", hotel[i][hotel_sell_day_payday]);
	}

	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH":"cBLUE" %s\n\
		"cWH": "cGR"%d \n\
		"cWH"  : "cBLUE"%s\n\n\
		"cGREY" >>    GPS", i+1, get_hotel_name(hotel[i][hotel_class]), hotel[i][hotel_price], info_sell);
	return SPD(playerid, DIALOG_REALTOR_INFO_HOTEL_2, 2, !""cBLUE"  ", String512, !"", !"");
}


stock show_free_garage_realtor(playerid, last = 0)
{
	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = all_garage; i < idx; i ++)
	{
		if(garage[i][garage_owner_id] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				format(fmt_str, sizeof(fmt_str), "%s\n "cBLUE"[%d]", fmt_str, i+1);
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  ");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_GARAGE, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_garage_info(playerid, i) 
{
	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH": "cGR"%d \n\
		"cWH"   : "cGR"%d \n\n\
		"cGREY" >>    GPS", i+1, garage[i][garage_price], garage[i][garage_takings]);
	return SPD(playerid, DIALOG_REALTOR_INFO_GARAGE_2, 2, !""cBLUE"  ", String512, !"", !"");
}


stock show_free_sto_realtor(playerid, last = 0)
{
	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = MAX_MECHANIC_BASE; i < idx; i ++)
	{
		if(mechanic[i][mechanic_base_owner_id] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				format(fmt_str, sizeof(fmt_str), "%s\n%s "cBLUE"[%d]", fmt_str, mechanic[i][mechanic_base_name], i+1);
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  ");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_MECH, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_mech_info(playerid, i) 
{

	new 
		info_sell[32];

	if(mechanic[i][mechanic_sell_day_payday] == -1)
	{
		format(info_sell, 32, ""cGR" ");
	}
	else
	{
		format(info_sell, 32, ""cORANGE"%d   ", mechanic[i][mechanic_sell_day_payday]);
	}
	

	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH":"cBLUE" %s\n\
		"cWH": "cGR"%d \n\
		"cWH"   : "cGR"%d \n\
		"cWH"  : "cBLUE"%s\n\n\
		"cGREY" >>    GPS", i+1, mechanic[i][mechanic_base_name], mechanic[i][mechanic_base_price], 1500, info_sell);
	return SPD(playerid, DIALOG_REALTOR_INFO_MECH_2, 2, !""cBLUE"  ", String512, !"", !"");
}

stock show_free_tk_realtor(playerid, last = 0)
{
	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = MAX_TRUCKER_BASE; i < idx; i ++)
	{
		if(trucker_station[i][trucker_base_owner_id] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				format(fmt_str, sizeof(fmt_str), "%s\n%s "cBLUE"[%d]", fmt_str, trucker_station[i][trucker_base_name], i+1);
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  ");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_TK, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_tk_info(playerid, i) 
{

	new 
		info_sell[32];

	if(trucker_station[i][trucker_sell_day_payday] == -1)
	{
		format(info_sell, 32, ""cGR" ");
	}
	else
	{
		format(info_sell, 32, ""cORANGE"%d   ", trucker_station[i][trucker_sell_day_payday]);
	}
	

	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH":"cBLUE" %s\n\
		"cWH": "cGR"%d \n\
		"cWH"   : "cGR"%d \n\
		"cWH"  : "cBLUE"%s\n\n\
		"cGREY" >>    GPS", i+1, trucker_station[i][trucker_base_name], trucker_station[i][trucker_base_price], 1500, info_sell);
	return SPD(playerid, DIALOG_REALTOR_INFO_TK_2, 2, !""cBLUE"  ", String512, !"", !"");
}


stock show_free_taxi_realtor(playerid, last = 0)
{

	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = MAX_TAXI_COMPANY; i < idx; i ++)
	{
		if(taxi_company[i][taxi_company_owner_id] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				format(fmt_str, sizeof(fmt_str), "%s\n "cBLUE"[%d]", fmt_str, i+1);
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  !");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_TAXI, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_taxi_info(playerid, i) 
{
	new 
		info_sell[32];

	if(taxi_company[i][taxi_sell_day_payday] == -1)
	{
		format(info_sell, 32, ""cGR" ");
	}
	else
	{
		format(info_sell, 32, ""cORANGE"%d   ", taxi_company[i][taxi_sell_day_payday]);
	}

	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH": "cGR"%d \n\
		"cWH"   : "cGR"%d \n\
		"cWH"  : "cBLUE"%s\n\n\
		"cGREY" >>    GPS", i+1, taxi_company[i][taxi_company_price], 1500, info_sell);
	return SPD(playerid, DIALOG_REALTOR_INFO_TAXI_2, 2, !""cBLUE"  ", String512, !"", !"");
}

stock show_free_casino_realtor(playerid, last = 0)
{


	if(casino[0][casino_owner_id] == -1)
	{

		new 
			info_sell[32];

		if(casino[0][casino_sell_day_payday] == -1)
		{
			format(info_sell, 32, ""cGR" ");
		}
		else
		{
			format(info_sell, 32, ""cORANGE"%d   ", casino[0][casino_sell_day_payday]);
		}

		format(String512, sizeof(String512), "\
			"cWH": "cBLUE"1\n\
			"cWH": "cGR"%d \n\
			"cWH"   : "cGR"%d \n\
			"cWH"  : "cBLUE"%s\n\n\
			"cGREY" >>    GPS", casino[0][casino_buy_price], casino[0][casino_takings], info_sell);
		SPD(playerid, DIALOG_REALTOR_INFO_CASINO_2, 2, !""cBLUE"  ", String512, !"", !"");
	}
	else
	{
		open_menu_realtor_buisnes(playerid);
		SendErr(playerid, "  !");
	}

	return true;
}

stock show_free_other_buisnes_realtor(playerid, last = 0)
{
	new 
		selectes, next, fmt_str[1024];

	for(new i = last, idx = all_buisness; i < idx; i ++)
	{
		if(buisness[i][buisnes_owned] == -1)
		{
			if(selectes < 20)
			{
				Select[playerid] = i;
				selectID[playerid][selectes] = i;
				selectes++;				

				if(buisness[i][buisnes_type] == BUISNES_RIELTOR_AGENCY)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_realtor(i), i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_CLOTHES)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_clothes_n(i), i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_ACCESSORIES)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_aks_n(i), i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_AUTOSALON_1)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_autosalon_n[buisness[i][buisnes_name]], i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_AUTOSALON_2)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_autosalon_n[buisness[i][buisnes_name]], i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_AUTOSALON_3)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_autosalon_n[buisness[i][buisnes_name]], i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_PRODUCTION)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_univermag_n(i), i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_BAR)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_bar_n(i), i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_AMMO_1)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_ammo_n(i), i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_AMMO_2)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_ammo_n(i), i+1);
				}
				else if(buisness[i][buisnes_type] == BUISNES_RESTORAN)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_restoran_n(i), i+1);
				}	
				else if(buisness[i][buisnes_type] == BUISNES_FASTFOOD)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_fastfood_n(i), i+1);
				}	
				else if(buisness[i][buisnes_type] == BUISNES_CLUB)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n %s "cBLUE"[%d]", fmt_str, get_buisnes_club_n(i), i+1);
				}		
				else if(buisness[i][buisnes_type] == BUISNES_PARKING)
				{
					format(fmt_str, sizeof(fmt_str), "%s\n  "cBLUE"[%d]", fmt_str, i+1);
				}				
			}
			else 
			{
				next = 1;
				break;
			}
		}
	}
	if(selectes == 0) 
	{
		open_menu_realtor_buisnes(playerid);
		return SendErr(playerid, "  !");
	}

	if(next)
	{
		strcat(fmt_str, "\n"cGREY" >>");
	}
	return SPD(playerid, DIALOG_REALTOR_FREE_BIZ, 2, !""cBLUE" :", fmt_str, !"", !"");
}

stock show_free_biz_info(playerid, i) 
{

	new 
		info_sell[32];

	if(buisness[i][buisnes_sell_day_payday] == -1)
	{
		format(info_sell, 32, ""cGR" ");
	}
	else
	{
		format(info_sell, 32, ""cORANGE"%d   ", buisness[i][buisnes_sell_day_payday]);
	}

	format(String512, sizeof(String512), "\
		"cWH":"cBLUE" %d\n\
		"cWH": "cGR"%d \n\
		"cWH"   : "cGR"%d \n\
		"cWH"  : "cBLUE"%s\n\n\
		"cGREY" >>    GPS", i+1, buisness[i][buisnes_price], buisness[i][buisnes_takings], info_sell);
	return SPD(playerid, DIALOG_REALTOR_INFO_BIZ_2, 2, !""cBLUE"  ", String512, !"", !"");
}


stock dialog_all_realtor_agency(playerid, dialogid, response, listitem, inputtext[])
{

	switch(dialogid)
	{
		//      


		case DIALOG_GENERAL_REALTOR_AGENCY:
		{
			if(!response)
				return true;

			switch(listitem)
			{
				case 0: return show_free_house_realtor(playerid);
				case 1: return show_free_apart_realtor(playerid);
				case 2: return show_free_filling_realtor(playerid);
				case 3: return show_free_hotel_realtor(playerid);
				case 4: return show_free_garage_realtor(playerid);
				case 5: return show_free_sto_realtor(playerid);
				case 6: return show_free_tk_realtor(playerid);
				case 7: return show_free_taxi_realtor(playerid);
				case 8: return show_free_casino_realtor(playerid);
				case 9: return show_free_other_buisnes_realtor(playerid);
			}
		}
		case DIALOG_REALTOR_FREE_HOUSE:
		{



		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_house_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_HOUSE, 0, !""cBLUE"  ", ""cWH"      "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}
		}
		case DIALOG_REALTOR_FREE_FLATE:
		{
		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_house_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_FLATE, 0, !""cBLUE"  ", ""cWH"      "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}
		}
		case DIALOG_REALTOR_FREE_FILL:
		{
		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_house_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_FILL, 0, !""cBLUE"  ", ""cWH"      "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_FREE_HOTEL:
		{
		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_hotel_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_HOTEL, 0, !""cBLUE"  ", ""cWH"      "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}				
		}
		case DIALOG_REALTOR_FREE_GARAGE:
		{
		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_garage_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_GARAGE, 0, !""cBLUE"  ", ""cWH"      "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_FREE_MECH:
		{
		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_sto_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_MECH, 0, !""cBLUE"  ", ""cWH"      "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}

		case DIALOG_REALTOR_FREE_TK:
		{
		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_tk_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_TK, 0, !""cBLUE"  ", ""cWH"       "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_FREE_TAXI:
		{
		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_taxi_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_TAXI, 0, !""cBLUE"  ", ""cWH"      "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}				
		}
		case DIALOG_REALTOR_FREE_BIZ:
		{
		    if(response) 
		    {
				if(listitem == 20)
				{
					return show_free_other_buisnes_realtor(playerid, Select[playerid]+1);
				}
				else 
				{
                    zSelected[playerid] = selectID[playerid][listitem];
					SPD(playerid, DIALOG_REALTOR_INFO_BIZ, 0, !""cBLUE"  ", ""cWH"      "cGR"100 "cWH"\n\n   ?", "","");
				}
			}
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}				
		}

		//         



		case DIALOG_REALTOR_INFO_HOUSE: 
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");

		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_house_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}
		}
		case DIALOG_REALTOR_INFO_FLATE: 
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");


		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_flate_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}
		}

		case DIALOG_REALTOR_INFO_FILL:
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");


		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_fill_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_INFO_HOTEL:
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");


		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_hotel_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_INFO_GARAGE:
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");


		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_garage_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_INFO_MECH:
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");


		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_mech_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_INFO_TK:
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");


		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_tk_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_INFO_TAXI:
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");


		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_taxi_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_INFO_BIZ:
		{
		    if(response) 
		    {
		    	if(GetPlayerMoneyEx(playerid) < PRICE_WATCH_INFO_REALTOR)
		    	{
		    		show_notify_gui(playerid, TEXTDRAW_SHOW, NOTIFY_GUI_256_RIGHT, "brilliantother:notify_player_21", 3000);
		    		open_menu_realtor_buisnes(playerid);
		    		return SendErr(playerid, "        !");
		    	}

		    	new 
		    		buisness_ids = GetPVarIntNew(playerid, "buisnes_enter_id");

		    	give_money(playerid, -PRICE_WATCH_INFO_REALTOR, "    !");


		    	buisness_bank_update(buisness_ids, PRICE_WATCH_INFO_REALTOR, "   ");
		    	
				show_free_biz_info(playerid, zSelected[playerid]);
		    }
			else 
			{
				open_menu_realtor_buisnes(playerid);
			}			
		}

		//          


		case DIALOG_REALTOR_INFO_HOUSE_2: 
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..4: return show_free_house_info(playerid, i);
					case 5: 
					{
					    SendSucc(playerid, "        !");
					    SetPlayerCheckpoint(playerid,House[i][house_enter_x],House[i][house_enter_y],House[i][house_enter_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_house_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}
		}
		case DIALOG_REALTOR_INFO_FLATE_2: 
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid],
		        	entrance_id = flate[i][flate_entrance_id];

				switch(listitem) 
				{
					case 0..4: return show_free_flate_info(playerid, i);
					case 5: 
					{
					    SendSucc(playerid, "        !");
					    SetPlayerCheckpoint(playerid,apartament[entrance_id][apartament_enter_x],apartament[entrance_id][apartament_enter_y],apartament[entrance_id][apartament_enter_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_apart_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}
		}

		case DIALOG_REALTOR_INFO_FILL_2: 
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..4: return show_free_fill_info(playerid, i);
					case 5: 
					{
					    SendSucc(playerid, "        !");
					    SetPlayerCheckpoint(playerid, filling[i][filling_info_enter_x], filling[i][filling_info_enter_y], filling[i][filling_info_enter_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_filling_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}
		}
		case DIALOG_REALTOR_INFO_HOTEL_2:
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..3: return show_free_hotel_info(playerid, i);
					case 4: 
					{
					    SendSucc(playerid, "        !");
					    SetPlayerCheckpoint(playerid, hotel[i][hotel_enter_x], hotel[i][hotel_enter_y], hotel[i][hotel_enter_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_hotel_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}			
		}
		case DIALOG_REALTOR_INFO_GARAGE_2:
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..2: return show_free_garage_info(playerid, i);
					case 3: 
					{
					    SendSucc(playerid, "        !");
					    SetPlayerCheckpoint(playerid, garage[i][garage_enter_x], garage[i][garage_enter_y], garage[i][garage_enter_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_garage_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}			
		}
		case DIALOG_REALTOR_INFO_MECH_2:
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..4: return show_free_mech_info(playerid, i);
					case 5: 
					{
					    SendSucc(playerid, "        !");

					    SetPlayerCheckpoint(playerid, mechanic[i][mechanic_pos_x], mechanic[i][mechanic_pos_y], mechanic[i][mechanic_pos_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_sto_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}			
		}
		case DIALOG_REALTOR_INFO_TK_2:
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..4: return show_free_tk_info(playerid, i);
					case 5: 
					{
					    SendSucc(playerid, "        !");

					    SetPlayerCheckpoint(playerid, trucker_station[i][trucker_pos_x], trucker_station[i][trucker_pos_y], trucker_station[i][trucker_pos_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_tk_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}			
		}
		case DIALOG_REALTOR_INFO_TAXI_2:
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..3: return show_free_taxi_info(playerid, i);
					case 4: 
					{
					    SendSucc(playerid, "        !");

					    SetPlayerCheckpoint(playerid, taxi_company[i][taxi_pos_x], taxi_company[i][taxi_pos_y], taxi_company[i][taxi_pos_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_taxi_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}			
		}
		case DIALOG_REALTOR_INFO_CASINO_2:
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..3: return show_free_casino_realtor(playerid, i);
					case 4: 
					{
					    SendSucc(playerid, "        !");

					    SetPlayerCheckpoint(playerid, casino[0][casino_pos_x], casino[0][casino_pos_y], casino[0][casino_pos_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				open_menu_realtor_buisnes(playerid);
			}			
		}
		case DIALOG_REALTOR_INFO_BIZ_2:
		{
		    if(response) 
		    {
		        new 
		        	i = zSelected[playerid];

				switch(listitem) 
				{
					case 0..3: return show_free_other_buisnes_realtor(playerid, i);
					case 4: 
					{
					    SendSucc(playerid, "       !");

					    SetPlayerCheckpoint(playerid, buisness[i][buisnes_enter_x], buisness[i][buisnes_enter_y], buisness[i][buisnes_enter_z], 4.0);

						status_navigator_player(playerid, TEXTDRAW_SHOW);
						SendSucc(playerid, "     ,  ,  - /gps!");

						pTemp[playerid][pGPS] = true;
						zSelected[playerid] = 0;
					}
				}
		    }
		    else 
		    {
				show_free_other_buisnes_realtor(playerid, 0);
				zSelected[playerid] = 0;
			}			
		}
	}
	return true;
}