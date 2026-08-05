// ***************************************

new Text:select_spawn[6];
new Text:hud_elements[3];
new PlayerText:hud_elements_p[6][MAX_PLAYERS] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...};
new PlayerText:inventory_gui_p[59][MAX_PLAYERS] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...};
new Text:inventory_gui_back[4] = {Text:INVALID_TEXT_DRAW, ...};
new PlayerText:free_number_gai_p[7][MAX_PLAYERS] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...},
    PlayerText:buy_number_gai_p[6][MAX_PLAYERS] = {{PlayerText:INVALID_TEXT_DRAW, ...}, ...};
stock TextDraws()
{
	new playerid;
	CreateSpawnTD();
	create_hud_element();
	create_hud_element_p(playerid);
	create_inventory_global();
	create_autosalon();
	create_skins();
	return true;
}

// ****************************************

stock CreateSpawnTD()
{
	select_spawn[0] = TextDrawCreate(0.000000, 0.000000, "brilliantother:spawn_select_background"); // Texture element
	TextDrawLetterSize(select_spawn[0], 0.000000, 0.000000);
	TextDrawTextSize(select_spawn[0], 642.333312, 413.984924);
	TextDrawAlignment(select_spawn[0], 1);
	TextDrawColor(select_spawn[0], -1);
	TextDrawSetShadow(select_spawn[0], 0);
	TextDrawSetOutline(select_spawn[0], 0);
	TextDrawFont(select_spawn[0], 4);

	select_spawn[1] = TextDrawCreate(40.666687, 112.829627, "brilliantother:spawn_select_window_1"); // Texture element
	TextDrawLetterSize(select_spawn[1], 0.000000, 0.000000);
	TextDrawTextSize(select_spawn[1], 126.666648, 211.970382);
	TextDrawAlignment(select_spawn[1], 2);
	TextDrawColor(select_spawn[1], -1);
	TextDrawSetShadow(select_spawn[1], 0);
	TextDrawSetOutline(select_spawn[1], 0);
	TextDrawFont(select_spawn[1], 4);
	TextDrawSetSelectable(select_spawn[1], true);

	select_spawn[2] = TextDrawCreate(184.000045, 113.244415, "brilliantother:spawn_select_window_2"); // Texture element
	TextDrawLetterSize(select_spawn[2], 0.000000, 0.000000);
	TextDrawTextSize(select_spawn[2], 126.999992, 211.970306);
	TextDrawAlignment(select_spawn[2], 2);
	TextDrawColor(select_spawn[2], -1);
	TextDrawSetShadow(select_spawn[2], 0);
	TextDrawSetOutline(select_spawn[2], 0);
	TextDrawFont(select_spawn[2], 4);
	TextDrawSetSelectable(select_spawn[2], true);

	select_spawn[3] = TextDrawCreate(473.000152, 112.414764, "brilliantother:spawn_select_window_4"); // Texture element
	TextDrawLetterSize(select_spawn[3], 0.000000, 0.000000);
	TextDrawTextSize(select_spawn[3], 128.333282, 211.970321);
	TextDrawAlignment(select_spawn[3], 2);
	TextDrawColor(select_spawn[3], -1);
	TextDrawSetShadow(select_spawn[3], 0);
	TextDrawSetOutline(select_spawn[3], 0);
	TextDrawFont(select_spawn[3], 4);
	TextDrawSetSelectable(select_spawn[3], true);

	select_spawn[4] = TextDrawCreate(327.666748, 112.829627, "brilliantother:spawn_select_window_3"); // Texture element
	TextDrawLetterSize(select_spawn[4], 0.000000, 0.000000);
	TextDrawTextSize(select_spawn[4], 127.000000, 211.970291);
	TextDrawAlignment(select_spawn[4], 2);
	TextDrawColor(select_spawn[4], -1);
	TextDrawSetShadow(select_spawn[4], 0);
	TextDrawSetOutline(select_spawn[4], 0);
	TextDrawFont(select_spawn[4], 4);
	TextDrawSetSelectable(select_spawn[4], true);

	select_spawn[5] = TextDrawCreate(-1.000017, 1008.830078, "brilliantother:spawn_select_background"); // Texture element
	TextDrawLetterSize(select_spawn[5], 0.000000, 0.000000);
	TextDrawTextSize(select_spawn[5], 651.332824, -596.089294);
	TextDrawAlignment(select_spawn[5], 1);
	TextDrawColor(select_spawn[5], -1);
	TextDrawSetShadow(select_spawn[5], 0);
	TextDrawSetOutline(select_spawn[5], 0);
	TextDrawFont(select_spawn[5], 4);

	return true;
}

stock create_hud_element()
{
	hud_elements[0] = TextDrawCreate(482.450500, 26.400001, "brilliantother:golod");
	TextDrawTextSize(hud_elements[0], 98.179924, 16.180000);
	TextDrawAlignment(hud_elements[0], 1);
	TextDrawColor(hud_elements[0], -1);
	TextDrawBackgroundColor(hud_elements[0], 255);
	TextDrawFont(hud_elements[0], 4);
	TextDrawSetProportional(hud_elements[0], 0);

	hud_elements[1] = TextDrawCreate(482.450500, 59.100025, "brilliantother:heal");
	TextDrawTextSize(hud_elements[1], 98.179924, 16.180000);
	TextDrawAlignment(hud_elements[1], 1);
	TextDrawColor(hud_elements[1], -1);
	TextDrawBackgroundColor(hud_elements[1], 255);
	TextDrawFont(hud_elements[1], 4);
	TextDrawSetProportional(hud_elements[1], 0);

	hud_elements[2] = TextDrawCreate(482.450500, 74.699790, "brilliantother:armour");
	TextDrawTextSize(hud_elements[2], 98.179924, 16.180000);
	TextDrawAlignment(hud_elements[2], 1);
	TextDrawColor(hud_elements[2], -1);
	TextDrawBackgroundColor(hud_elements[2], 255);
	TextDrawFont(hud_elements[2], 4);
	TextDrawSetProportional(hud_elements[2], 0);

	return true;
}

stock create_hud_element_p(playerid)
{
	if(hud_elements_p[0][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		hud_elements_p[0][playerid] = CreatePlayerTextDraw(playerid, 509.599975, 29.500001, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, hud_elements_p[0][playerid], 57.310001, 9.790008);
		PlayerTextDrawAlignment(playerid, hud_elements_p[0][playerid], 1);
		PlayerTextDrawColor(playerid, hud_elements_p[0][playerid], -3721217);
		PlayerTextDrawBackgroundColor(playerid, hud_elements_p[0][playerid], 255);
		PlayerTextDrawFont(playerid, hud_elements_p[0][playerid], 4);
		PlayerTextDrawSetProportional(playerid, hud_elements_p[0][playerid], 0);
	}
	if(hud_elements_p[1][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		hud_elements_p[1][playerid] =  CreatePlayerTextDraw(playerid, 509.599975, 62.299983, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, hud_elements_p[1][playerid], 57.310001, 9.790008);
		PlayerTextDrawAlignment(playerid, hud_elements_p[1][playerid], 1);
		PlayerTextDrawColor(playerid, hud_elements_p[1][playerid], -13158401);
		PlayerTextDrawBackgroundColor(playerid, hud_elements_p[1][playerid], 255);
		PlayerTextDrawFont(playerid, hud_elements_p[1][playerid], 4);
		PlayerTextDrawSetProportional(playerid, hud_elements_p[1][playerid], 0);
	}
	if(hud_elements_p[2][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		hud_elements_p[2][playerid] = CreatePlayerTextDraw(playerid, 509.599975, 77.799964, "LD_SPAC:white");
		PlayerTextDrawTextSize(playerid, hud_elements_p[2][playerid], 57.310001, 9.790008);
		PlayerTextDrawAlignment(playerid, hud_elements_p[2][playerid], 1);
		PlayerTextDrawColor(playerid, hud_elements_p[2][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, hud_elements_p[2][playerid], 255);
		PlayerTextDrawFont(playerid, hud_elements_p[2][playerid], 4);
		PlayerTextDrawSetProportional(playerid, hud_elements_p[2][playerid], 0);
	}
	return true;
}

stock create_player_inventory(playerid)
{
	if(inventory_gui_p[0][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[0][playerid] = CreatePlayerTextDraw(playerid, 93.999992, 124.837142, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[0][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[0][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[0][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[0][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[0][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[0][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[0][playerid], true);
	}
	if(inventory_gui_p[1][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[1][playerid] = CreatePlayerTextDraw(playerid, 142.000015, 124.837142, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[1][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[1][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[1][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[1][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[1][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[1][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[1][playerid], true);
	}
	if(inventory_gui_p[2][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[2][playerid] = CreatePlayerTextDraw(playerid, 190.000015, 124.837142, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[2][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[2][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[2][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[2][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[2][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[2][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[2][playerid], true);
	}
	if(inventory_gui_p[3][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[3][playerid] = CreatePlayerTextDraw(playerid, 238.000015, 124.837142, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[3][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[3][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[3][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[3][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[3][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[3][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[3][playerid], true);
	}
	if(inventory_gui_p[4][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[4][playerid] = CreatePlayerTextDraw(playerid, 285.999969, 124.837142, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[4][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[4][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[4][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[4][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[4][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[4][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[4][playerid], true);
	}
	if(inventory_gui_p[5][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[5][playerid] = CreatePlayerTextDraw(playerid, 333.999969, 124.837142, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[5][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[5][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[5][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[5][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[5][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[5][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[5][playerid], true);
	}
	if(inventory_gui_p[6][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[6][playerid] = CreatePlayerTextDraw(playerid, 93.999992, 195.836883, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[6][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[6][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[6][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[6][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[6][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[6][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[6][playerid], true);
	}
	if(inventory_gui_p[7][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[7][playerid] = CreatePlayerTextDraw(playerid, 142.000015, 195.836883, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[7][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[7][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[7][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[7][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[7][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[7][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[7][playerid], true);
	}
	if(inventory_gui_p[8][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[8][playerid] = CreatePlayerTextDraw(playerid, 190.000015, 195.836883, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[8][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[8][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[8][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[8][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[8][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[8][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[8][playerid], true);
	}
	if(inventory_gui_p[9][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[9][playerid] = CreatePlayerTextDraw(playerid, 238.000015, 195.836883, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[9][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[9][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[9][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[9][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[9][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[9][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[9][playerid], true);
	}
	if(inventory_gui_p[10][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[10][playerid] = CreatePlayerTextDraw(playerid, 285.999969, 195.836883, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[10][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[10][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[10][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[10][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[10][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[10][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[10][playerid], true);
	}
	if(inventory_gui_p[11][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[11][playerid] = CreatePlayerTextDraw(playerid, 333.999969, 195.836883, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[11][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[11][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[11][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[11][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[11][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[11][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[11][playerid], true);
	}
	if(inventory_gui_p[12][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[12][playerid] = CreatePlayerTextDraw(playerid, 93.999992, 267.837219, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[12][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[12][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[12][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[12][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[12][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[12][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[12][playerid], true);
	}
	if(inventory_gui_p[13][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[13][playerid] = CreatePlayerTextDraw(playerid, 142.000015, 267.837219, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[13][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[13][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[13][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[13][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[13][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[13][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[13][playerid], true);
	}
	if(inventory_gui_p[14][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[14][playerid] = CreatePlayerTextDraw(playerid, 190.000015, 267.837219, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[14][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[14][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[14][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[14][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[14][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[14][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[14][playerid], true);
	}
	if(inventory_gui_p[15][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[15][playerid] = CreatePlayerTextDraw(playerid, 238.000015, 267.837219, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[15][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[15][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[15][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[15][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[15][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[15][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[15][playerid], true);
	}
	if(inventory_gui_p[16][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[16][playerid] = CreatePlayerTextDraw(playerid, 285.999969, 267.837219, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[16][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[16][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[16][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[16][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[16][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[16][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[16][playerid], true);
	}
	if(inventory_gui_p[17][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[17][playerid] = CreatePlayerTextDraw(playerid, 333.999969, 267.837219, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[17][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[17][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[17][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[17][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[17][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[17][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[17][playerid], true);
	}
	if(inventory_gui_p[18][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[18][playerid] = CreatePlayerTextDraw(playerid, 93.999992, 337.837402, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[18][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[18][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[18][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[18][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[18][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[18][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[18][playerid], true);
	}
	if(inventory_gui_p[19][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[19][playerid] = CreatePlayerTextDraw(playerid, 142.000015, 337.837402, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[19][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[19][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[19][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[19][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[19][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[19][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[19][playerid], true);
	}
	if(inventory_gui_p[20][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[20][playerid] = CreatePlayerTextDraw(playerid, 190.000015, 337.837402, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[20][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[20][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[20][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[20][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[20][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[20][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[20][playerid], true);
	}
	if(inventory_gui_p[21][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[21][playerid] = CreatePlayerTextDraw(playerid, 238.000015, 337.837402, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[21][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[21][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[21][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[21][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[21][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[21][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[21][playerid], true);
	}
	if(inventory_gui_p[22][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[22][playerid] = CreatePlayerTextDraw(playerid, 285.999969, 337.837402, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[22][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[22][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[22][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[22][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[22][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[22][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[22][playerid], true);
	}
	if(inventory_gui_p[23][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[23][playerid] = CreatePlayerTextDraw(playerid, 333.999969, 337.837402, "brillinv:inventory_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[23][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[23][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[23][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[23][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[23][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[23][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[23][playerid], true);
	}
	if(inventory_gui_p[24][playerid] == PlayerText:INVALID_TEXT_DRAW) 
	{
		inventory_gui_p[24][playerid] = CreatePlayerTextDraw(playerid, 455.999908, 82.585281, "brillinv:inventory_head_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[24][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[24][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[24][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[24][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[24][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[24][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[24][playerid], true);
	}
	if(inventory_gui_p[25][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[25][playerid] = CreatePlayerTextDraw(playerid, 388.999908, 134.585021, "brillinv:inventory_glasses_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[25][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[25][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[25][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[25][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[25][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[25][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[25][playerid], true);
	}
	if(inventory_gui_p[26][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[26][playerid] = CreatePlayerTextDraw(playerid, 388.999908, 195.585021, "brillinv:inventory_mask_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[26][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[26][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[26][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[26][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[26][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[26][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[26][playerid], true);
	}
	if(inventory_gui_p[27][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[27][playerid] = CreatePlayerTextDraw(playerid, 388.999908, 255.585479, "brillinv:inventory_belt_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[27][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[27][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[27][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[27][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[27][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[27][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[27][playerid], true);
	}
	if(inventory_gui_p[28][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[28][playerid] = CreatePlayerTextDraw(playerid, 434.999908, 310.585510, "brillinv:inventory_feet_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[28][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[28][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[28][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[28][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[28][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[28][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[28][playerid], true);
	}
	if(inventory_gui_p[29][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[29][playerid] = CreatePlayerTextDraw(playerid, 477.999908, 310.585510, "brillinv:inventory_hand_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[29][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[29][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[29][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[29][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[29][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[29][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[29][playerid], true);
	}
	if(inventory_gui_p[30][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[30][playerid] = CreatePlayerTextDraw(playerid, 525.000183, 255.585479, "brillinv:inventory_legs_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[30][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[30][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[30][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[30][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[30][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[30][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[30][playerid], true);
	}
	if(inventory_gui_p[31][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[31][playerid] = CreatePlayerTextDraw(playerid, 525.000183, 195.585021, "brillinv:inventory_back_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[31][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[31][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[31][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[31][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[31][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[31][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[31][playerid], true);
	}
	if(inventory_gui_p[32][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[32][playerid] = CreatePlayerTextDraw(playerid, 525.000183, 134.585021, "brillinv:inventory_chest_slot");
		PlayerTextDrawTextSize(playerid, inventory_gui_p[32][playerid], 38.000000, 53.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[32][playerid], 1);
		PlayerTextDrawColor(playerid, inventory_gui_p[32][playerid], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[32][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[32][playerid], 4);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[32][playerid], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_gui_p[32][playerid], true);
	}
	if(inventory_gui_p[33][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[33][playerid] = CreatePlayerTextDraw(playerid, 67.666671, 250.155532, "3/4");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[33][playerid], 0.484333, 2.110219);
		PlayerTextDrawTextSize(playerid, inventory_gui_p[33][playerid], 0.000000, 32.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[33][playerid], 2);
		PlayerTextDrawColor(playerid, inventory_gui_p[33][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[33][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[33][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[33][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[33][playerid], 1);
	}
	if(inventory_gui_p[34][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[34][playerid] = CreatePlayerTextDraw(playerid, 357.300567, 92.274101, "999_kg");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[34][playerid], 0.172332, 1.272296);
		PlayerTextDrawTextSize(playerid, inventory_gui_p[34][playerid], 0.000000, 32.000000);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[34][playerid], 2);
		PlayerTextDrawColor(playerid, inventory_gui_p[34][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[34][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[34][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[34][playerid], 2);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[34][playerid], 1);
	}
	if(inventory_gui_p[35][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[35][playerid] = CreatePlayerTextDraw(playerid, 129.000015, 160.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[35][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[35][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[35][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[35][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[35][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[35][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[35][playerid], 1);
	}
	if(inventory_gui_p[36][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[36][playerid] = CreatePlayerTextDraw(playerid, 177.000015, 160.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[36][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[36][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[36][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[36][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[36][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[36][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[36][playerid], 1);
	}
	if(inventory_gui_p[37][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[37][playerid] = CreatePlayerTextDraw(playerid, 225.000015, 160.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[37][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[37][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[37][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[37][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[37][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[37][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[37][playerid], 1);
	}
	if(inventory_gui_p[38][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[38][playerid] = CreatePlayerTextDraw(playerid, 272.999969, 160.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[38][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[38][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[38][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[38][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[38][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[38][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[38][playerid], 1);
	}
	if(inventory_gui_p[39][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[39][playerid] = CreatePlayerTextDraw(playerid, 320.999969, 160.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[39][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[39][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[39][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[39][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[39][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[39][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[39][playerid], 1);
	}
	if(inventory_gui_p[40][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[40][playerid] = CreatePlayerTextDraw(playerid, 368.999969, 160.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[40][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[40][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[40][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[40][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[40][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[40][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[40][playerid], 1);
	}
	if(inventory_gui_p[41][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[41][playerid] = CreatePlayerTextDraw(playerid, 129.000015, 231.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[41][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[41][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[41][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[41][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[41][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[41][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[41][playerid], 1);
	}
	if(inventory_gui_p[42][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[42][playerid] = CreatePlayerTextDraw(playerid, 177.000015, 231.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[42][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[42][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[42][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[42][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[42][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[42][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[42][playerid], 1);
	}
	if(inventory_gui_p[43][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[43][playerid] = CreatePlayerTextDraw(playerid, 225.000015, 231.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[43][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[43][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[43][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[43][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[43][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[43][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[43][playerid], 1);
	}
	if(inventory_gui_p[44][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[44][playerid] = CreatePlayerTextDraw(playerid, 272.999969, 231.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[44][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[44][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[44][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[44][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[44][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[44][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[44][playerid], 1);
	}
	if(inventory_gui_p[45][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[45][playerid] = CreatePlayerTextDraw(playerid, 320.999969, 231.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[45][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[45][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[45][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[45][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[45][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[45][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[45][playerid], 1);
	}
	if(inventory_gui_p[46][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[46][playerid] = CreatePlayerTextDraw(playerid, 368.999969, 231.836883, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[46][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[46][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[46][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[46][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[46][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[46][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[46][playerid], 1);
	}
	if(inventory_gui_p[47][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[47][playerid] = CreatePlayerTextDraw(playerid, 129.000015, 303.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[47][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[47][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[47][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[47][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[47][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[47][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[47][playerid], 1);
	}
	if(inventory_gui_p[48][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[48][playerid] = CreatePlayerTextDraw(playerid, 177.000015, 303.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[48][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[48][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[48][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[48][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[48][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[48][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[48][playerid], 1);
	}
	if(inventory_gui_p[49][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[49][playerid] = CreatePlayerTextDraw(playerid, 225.000015, 303.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[49][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[49][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[49][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[49][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[49][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[49][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[49][playerid], 1);
	}
	if(inventory_gui_p[50][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[50][playerid] = CreatePlayerTextDraw(playerid, 272.999969, 303.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[50][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[50][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[50][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[50][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[50][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[50][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[50][playerid], 1);
	}
	if(inventory_gui_p[51][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[51][playerid] = CreatePlayerTextDraw(playerid, 320.999969, 303.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[51][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[51][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[51][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[51][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[51][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[51][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[51][playerid], 1);
	}
	if(inventory_gui_p[52][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[52][playerid] = CreatePlayerTextDraw(playerid, 368.999969, 303.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[52][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[52][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[52][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[52][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[52][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[52][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[52][playerid], 1);
	}
	if(inventory_gui_p[53][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[53][playerid] = CreatePlayerTextDraw(playerid, 129.000015, 372.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[53][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[53][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[53][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[53][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[53][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[53][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[53][playerid], 1);
	}
	if(inventory_gui_p[54][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[54][playerid] = CreatePlayerTextDraw(playerid, 177.000015, 372.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[54][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[54][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[54][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[54][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[54][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[54][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[54][playerid], 1);
	}
	if(inventory_gui_p[55][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[55][playerid] = CreatePlayerTextDraw(playerid, 225.000015, 372.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[55][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[55][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[55][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[55][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[55][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[55][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[55][playerid], 1);
	}
	if(inventory_gui_p[56][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[56][playerid] = CreatePlayerTextDraw(playerid, 272.999969, 372.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[56][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[56][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[56][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[56][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[56][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[56][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[56][playerid], 1);
	}
	if(inventory_gui_p[57][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[57][playerid] = CreatePlayerTextDraw(playerid, 320.999969, 372.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[57][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[57][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[57][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[57][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[57][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[57][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[57][playerid], 1);
	}
	if(inventory_gui_p[58][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		inventory_gui_p[58][playerid] = CreatePlayerTextDraw(playerid, 368.999969, 372.837402, "25");
		PlayerTextDrawLetterSize(playerid, inventory_gui_p[58][playerid], 0.297666, 1.525333);
		PlayerTextDrawAlignment(playerid, inventory_gui_p[58][playerid], 3);
		PlayerTextDrawColor(playerid, inventory_gui_p[58][playerid], -1);
		PlayerTextDrawSetShadow(playerid, inventory_gui_p[58][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, inventory_gui_p[58][playerid], 255);
		PlayerTextDrawFont(playerid, inventory_gui_p[58][playerid], 1);
		PlayerTextDrawSetProportional(playerid, inventory_gui_p[58][playerid], 1);
	}

	return true;
}

stock create_inventory_global()
{

	inventory_gui_back[0] = TextDrawCreate(16.000000, 36.000000, "brillinv:inventory_main");
	TextDrawTextSize(inventory_gui_back[0], 610.000000, 370.000000);
	TextDrawAlignment(inventory_gui_back[0], 1);
	TextDrawColor(inventory_gui_back[0], -31);
	TextDrawBackgroundColor(inventory_gui_back[0], 255);
	TextDrawFont(inventory_gui_back[0], 4);
	TextDrawSetProportional(inventory_gui_back[0], 0);

	inventory_gui_back[1] = TextDrawCreate(46.066623, 126.081535, "brillinv:inventory_up");
	TextDrawTextSize(inventory_gui_back[1], 41.730213, 126.000000);
	TextDrawAlignment(inventory_gui_back[1], 1);
	TextDrawColor(inventory_gui_back[1], -1);
	TextDrawBackgroundColor(inventory_gui_back[1], 255);
	TextDrawFont(inventory_gui_back[1], 4);
	TextDrawSetProportional(inventory_gui_back[1], 0);
	TextDrawSetSelectable(inventory_gui_back[1], true);

	inventory_gui_back[2] = TextDrawCreate(46.066623, 267.081665, "brillinv:inventory_down");
	TextDrawTextSize(inventory_gui_back[2], 41.730213, 126.000000);
	TextDrawAlignment(inventory_gui_back[2], 1);
	TextDrawColor(inventory_gui_back[2], -1);
	TextDrawBackgroundColor(inventory_gui_back[2], 255);
	TextDrawFont(inventory_gui_back[2], 4);
	TextDrawSetProportional(inventory_gui_back[2], 0);
	TextDrawSetSelectable(inventory_gui_back[2], true);

	inventory_gui_back[3] = TextDrawCreate(590.999755, 48.059249, "brillinv:inventory_close");
	TextDrawTextSize(inventory_gui_back[3], 24.000000, 30.000000);
	TextDrawAlignment(inventory_gui_back[3], 1);
	TextDrawColor(inventory_gui_back[3], -1);
	TextDrawBackgroundColor(inventory_gui_back[3], 255);
	TextDrawFont(inventory_gui_back[3], 4);
	TextDrawSetProportional(inventory_gui_back[3], 0);
	TextDrawSetSelectable(inventory_gui_back[3], true);


	return true;
}

stock create_buy_number_gai_p(playerid)
{
	if(buy_number_gai_p[0][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		buy_number_gai_p[0][playerid] = CreatePlayerTextDraw(playerid, 110.333305, 124.029670, "brilliantother:number_pl_ru_select"); // Texture element
		PlayerTextDrawLetterSize(playerid, buy_number_gai_p[0][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, buy_number_gai_p[0][playerid], 83.999977, 66.370368);
		PlayerTextDrawAlignment(playerid, buy_number_gai_p[0][playerid], 2);
		PlayerTextDrawColor(playerid, buy_number_gai_p[0][playerid], -1);
		PlayerTextDrawSetShadow(playerid, buy_number_gai_p[0][playerid], 0);
		PlayerTextDrawSetOutline(playerid, buy_number_gai_p[0][playerid], 0);
		PlayerTextDrawFont(playerid, buy_number_gai_p[0][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, buy_number_gai_p[0][playerid], true);
	}
	if(buy_number_gai_p[1][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{	
		buy_number_gai_p[1][playerid] = CreatePlayerTextDraw(playerid, 110.333328, 176.296386, "brilliantother:number_pl_kz_no_select"); // Texture element
		PlayerTextDrawLetterSize(playerid, buy_number_gai_p[1][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, buy_number_gai_p[1][playerid], 83.999977, 66.370368);
		PlayerTextDrawAlignment(playerid, buy_number_gai_p[1][playerid], 2);
		PlayerTextDrawColor(playerid, buy_number_gai_p[1][playerid], -1);
		PlayerTextDrawSetShadow(playerid, buy_number_gai_p[1][playerid], 0);
		PlayerTextDrawSetOutline(playerid, buy_number_gai_p[1][playerid], 0);
		PlayerTextDrawFont(playerid, buy_number_gai_p[1][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, buy_number_gai_p[1][playerid], true);
	}
	if(buy_number_gai_p[2][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		buy_number_gai_p[2][playerid] = CreatePlayerTextDraw(playerid, 110.666664, 228.563095, "brilliantother:number_pl_by_no_select"); // Texture element
		PlayerTextDrawLetterSize(playerid, buy_number_gai_p[2][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, buy_number_gai_p[2][playerid], 83.999977, 66.370368);
		PlayerTextDrawAlignment(playerid, buy_number_gai_p[2][playerid], 2);
		PlayerTextDrawColor(playerid, buy_number_gai_p[2][playerid], -1);
		PlayerTextDrawSetShadow(playerid, buy_number_gai_p[2][playerid], 0);
		PlayerTextDrawSetOutline(playerid, buy_number_gai_p[2][playerid], 0);
		PlayerTextDrawFont(playerid, buy_number_gai_p[2][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, buy_number_gai_p[2][playerid], true);
	}
	if(buy_number_gai_p[3][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		buy_number_gai_p[3][playerid] = CreatePlayerTextDraw(playerid, 110.333312, 280.414886, "brilliantother:number_pl_ua_no_select"); // Texture element
		PlayerTextDrawLetterSize(playerid, buy_number_gai_p[3][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, buy_number_gai_p[3][playerid], 83.999977, 66.370368);
		PlayerTextDrawAlignment(playerid, buy_number_gai_p[3][playerid], 2);
		PlayerTextDrawColor(playerid, buy_number_gai_p[3][playerid], -1);
		PlayerTextDrawSetShadow(playerid, buy_number_gai_p[3][playerid], 0);
		PlayerTextDrawSetOutline(playerid, buy_number_gai_p[3][playerid], 0);
		PlayerTextDrawFont(playerid, buy_number_gai_p[3][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, buy_number_gai_p[3][playerid], true);
	}
	if(buy_number_gai_p[4][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		buy_number_gai_p[4][playerid] = CreatePlayerTextDraw(playerid, 277.999847, 305.303588, "0_RUB"); // Text element
		PlayerTextDrawLetterSize(playerid, buy_number_gai_p[4][playerid], 0.338333, 1.695405);
		PlayerTextDrawAlignment(playerid, buy_number_gai_p[4][playerid], 2);
		PlayerTextDrawColor(playerid, buy_number_gai_p[4][playerid], -1);
		PlayerTextDrawSetShadow(playerid, buy_number_gai_p[4][playerid], -1);
		PlayerTextDrawSetOutline(playerid, buy_number_gai_p[4][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, buy_number_gai_p[4][playerid], 51);
		PlayerTextDrawFont(playerid, buy_number_gai_p[4][playerid], 2);
		PlayerTextDrawSetProportional(playerid, buy_number_gai_p[4][playerid], 1);
	}
	if(buy_number_gai_p[5][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		buy_number_gai_p[5][playerid] = CreatePlayerTextDraw(playerid, 371.000030, 191.644454, ""); // Text element
		PlayerTextDrawLetterSize(playerid, buy_number_gai_p[5][playerid], 0.703666, 3.462519);
		PlayerTextDrawAlignment(playerid, buy_number_gai_p[5][playerid], 2);
		PlayerTextDrawColor(playerid, buy_number_gai_p[5][playerid], -1);
		PlayerTextDrawSetShadow(playerid, buy_number_gai_p[5][playerid], 1);
		PlayerTextDrawSetOutline(playerid, buy_number_gai_p[5][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, buy_number_gai_p[5][playerid], 51);
		PlayerTextDrawFont(playerid, buy_number_gai_p[5][playerid], 1);
		PlayerTextDrawSetProportional(playerid, buy_number_gai_p[5][playerid], 1);
	}

	return true;
}

stock create_free_number_gai_p(playerid)
{
	if(free_number_gai_p[0][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		free_number_gai_p[0][playerid] = CreatePlayerTextDraw(playerid, 134.000000, 154.311126, "brilliantother:number_pl_ru_no_select"); // Texture element
		PlayerTextDrawLetterSize(playerid, free_number_gai_p[0][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, free_number_gai_p[0][playerid], 102.333335, 72.592575);
		PlayerTextDrawAlignment(playerid, free_number_gai_p[0][playerid], 2);
		PlayerTextDrawColor(playerid, free_number_gai_p[0][playerid], -1);
		PlayerTextDrawUseBox(playerid, free_number_gai_p[0][playerid], true);
		PlayerTextDrawBoxColor(playerid, free_number_gai_p[0][playerid], 0);
		PlayerTextDrawSetShadow(playerid, free_number_gai_p[0][playerid], 0);
		PlayerTextDrawSetOutline(playerid, free_number_gai_p[0][playerid], 0);
		PlayerTextDrawFont(playerid, free_number_gai_p[0][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, free_number_gai_p[0][playerid], true);
	}
	if(free_number_gai_p[1][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		free_number_gai_p[1][playerid] = CreatePlayerTextDraw(playerid, 225.333312, 153.481475, "brilliantother:number_pl_kz_no_select"); // Texture element
		PlayerTextDrawLetterSize(playerid, free_number_gai_p[1][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, free_number_gai_p[1][playerid], 102.333335, 72.592575);
		PlayerTextDrawAlignment(playerid, free_number_gai_p[1][playerid], 2);
		PlayerTextDrawColor(playerid, free_number_gai_p[1][playerid], -1);
		PlayerTextDrawSetShadow(playerid, free_number_gai_p[1][playerid], 0);
		PlayerTextDrawSetOutline(playerid, free_number_gai_p[1][playerid], 0);
		PlayerTextDrawFont(playerid, free_number_gai_p[1][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, free_number_gai_p[1][playerid], true);
	}
	if(free_number_gai_p[2][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		free_number_gai_p[2][playerid] = CreatePlayerTextDraw(playerid, 134.000000, 212.385177, "brilliantother:number_pl_by_no_select"); // Texture element
		PlayerTextDrawLetterSize(playerid, free_number_gai_p[2][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, free_number_gai_p[2][playerid], 102.333335, 72.592575);
		PlayerTextDrawAlignment(playerid, free_number_gai_p[2][playerid], 2);
		PlayerTextDrawColor(playerid, free_number_gai_p[2][playerid], -1);
		PlayerTextDrawSetShadow(playerid, free_number_gai_p[2][playerid], 0);
		PlayerTextDrawSetOutline(playerid, free_number_gai_p[2][playerid], 0);
		PlayerTextDrawFont(playerid, free_number_gai_p[2][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, free_number_gai_p[2][playerid], true);
	}
	if(free_number_gai_p[3][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		free_number_gai_p[3][playerid] = CreatePlayerTextDraw(playerid, 225.666687, 211.970352, "brilliantother:number_pl_ua_no_select"); // Texture element
		PlayerTextDrawLetterSize(playerid, free_number_gai_p[3][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, free_number_gai_p[3][playerid], 102.333335, 72.592575);
		PlayerTextDrawAlignment(playerid, free_number_gai_p[3][playerid], 2);
		PlayerTextDrawColor(playerid, free_number_gai_p[3][playerid], -1);
		PlayerTextDrawSetShadow(playerid, free_number_gai_p[3][playerid], 0);
		PlayerTextDrawSetOutline(playerid, free_number_gai_p[3][playerid], 0);
		PlayerTextDrawFont(playerid, free_number_gai_p[3][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, free_number_gai_p[3][playerid], true);
	}
	if(free_number_gai_p[4][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		free_number_gai_p[4][playerid] = CreatePlayerTextDraw(playerid, 316.666687, 154.725936, "brilliantother:number_pl_button_start_free"); // Texture element
		PlayerTextDrawLetterSize(playerid, free_number_gai_p[4][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, free_number_gai_p[4][playerid], 180.000045, 127.348136);
		PlayerTextDrawAlignment(playerid, free_number_gai_p[4][playerid], 2);
		PlayerTextDrawColor(playerid, free_number_gai_p[4][playerid], -1);
		PlayerTextDrawSetShadow(playerid, free_number_gai_p[4][playerid], 0);
		PlayerTextDrawSetOutline(playerid, free_number_gai_p[4][playerid], 0);
		PlayerTextDrawFont(playerid, free_number_gai_p[4][playerid], 4);
		PlayerTextDrawSetSelectable(playerid, free_number_gai_p[4][playerid], true);
	}
	if(free_number_gai_p[5][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		free_number_gai_p[5][playerid] = CreatePlayerTextDraw(playerid, 140.666671, 302.399993, "brilliantother:number_pl_text_free_ramka"); // Texture element
		PlayerTextDrawLetterSize(playerid, free_number_gai_p[5][playerid], 0.000000, 0.000000);
		PlayerTextDrawTextSize(playerid, free_number_gai_p[5][playerid], 358.666687, 54.755554);
		PlayerTextDrawAlignment(playerid, free_number_gai_p[5][playerid], 2);
		PlayerTextDrawColor(playerid, free_number_gai_p[5][playerid], -1);
		PlayerTextDrawSetShadow(playerid, free_number_gai_p[5][playerid], 0);
		PlayerTextDrawSetOutline(playerid, free_number_gai_p[5][playerid], 0);
		PlayerTextDrawFont(playerid, free_number_gai_p[5][playerid], 4);
	}
	if(free_number_gai_p[6][playerid] == PlayerText:INVALID_TEXT_DRAW)
	{
		free_number_gai_p[6][playerid] = CreatePlayerTextDraw(playerid, 315.333251, 305.303619, "111111111"); // Text element
		PlayerTextDrawLetterSize(playerid, free_number_gai_p[6][playerid], 1.024999, 4.669631);
		PlayerTextDrawAlignment(playerid, free_number_gai_p[6][playerid], 2);
		PlayerTextDrawColor(playerid, free_number_gai_p[6][playerid], -1);
		PlayerTextDrawUseBox(playerid, free_number_gai_p[6][playerid], true);
		PlayerTextDrawBoxColor(playerid, free_number_gai_p[6][playerid], 0);
		PlayerTextDrawSetShadow(playerid, free_number_gai_p[6][playerid], 0);
		PlayerTextDrawSetOutline(playerid, free_number_gai_p[6][playerid], 0);
		PlayerTextDrawBackgroundColor(playerid, free_number_gai_p[6][playerid], 51);
		PlayerTextDrawFont(playerid, free_number_gai_p[6][playerid], 2);
		PlayerTextDrawSetProportional(playerid, free_number_gai_p[6][playerid], 1);
	}

	return true;

}

stock create_autosalon()
{
    autosalonkristen_TD[0] = TextDrawCreate(184.597381, 382.083374, "auto:lr");
	TextDrawLetterSize(autosalonkristen_TD[0], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[0], 260.497894, 47.833305);
	TextDrawAlignment(autosalonkristen_TD[0], 1);
	TextDrawColor(autosalonkristen_TD[0], -1);
	TextDrawSetShadow(autosalonkristen_TD[0], 0);
	TextDrawSetOutline(autosalonkristen_TD[0], 0);
	TextDrawFont(autosalonkristen_TD[0], 4);

	autosalonkristen_TD[1] = TextDrawCreate(466.178649, 134.750000, "auto:res");
	TextDrawLetterSize(autosalonkristen_TD[1], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[1], 156.017578, 60.083312);
	TextDrawAlignment(autosalonkristen_TD[1], 1);
	TextDrawColor(autosalonkristen_TD[1], -1);
	TextDrawSetShadow(autosalonkristen_TD[1], 0);
	TextDrawSetOutline(autosalonkristen_TD[1], 0);
	TextDrawFont(autosalonkristen_TD[1], 4);

	autosalonkristen_TD[2] = TextDrawCreate(519.121643, 146.416671, "auto:car");
	TextDrawLetterSize(autosalonkristen_TD[2], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[2], 53.880004, 12.250000);
	TextDrawAlignment(autosalonkristen_TD[2], 1);
	TextDrawColor(autosalonkristen_TD[2], -1);
	TextDrawSetShadow(autosalonkristen_TD[2], 0);
	TextDrawSetOutline(autosalonkristen_TD[2], 0);
	TextDrawFont(autosalonkristen_TD[2], 4);

	autosalonkristen_TD[3] = TextDrawCreate(466.178619, 204.166656, "auto:res");
	TextDrawLetterSize(autosalonkristen_TD[3], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[3], 157.423141, 63.583339);
	TextDrawAlignment(autosalonkristen_TD[3], 1);
	TextDrawColor(autosalonkristen_TD[3], -1);
	TextDrawSetShadow(autosalonkristen_TD[3], 0);
	TextDrawSetOutline(autosalonkristen_TD[3], 0);
	TextDrawFont(autosalonkristen_TD[3], 4);

	autosalonkristen_TD[4] = TextDrawCreate(528.960449, 216.416641, "auto:price");
	TextDrawLetterSize(autosalonkristen_TD[4], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[4], 30.922454, 10.500020);
	TextDrawAlignment(autosalonkristen_TD[4], 1);
	TextDrawColor(autosalonkristen_TD[4], -1);
	TextDrawSetShadow(autosalonkristen_TD[4], 0);
	TextDrawSetOutline(autosalonkristen_TD[4], 0);
	TextDrawFont(autosalonkristen_TD[4], 4);

	autosalonkristen_TD[5] = TextDrawCreate(466.178741, 279.416687, "auto:tbbuy");
	TextDrawLetterSize(autosalonkristen_TD[5], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[5], 79.648574, 34.416667);
	TextDrawAlignment(autosalonkristen_TD[5], 1);
	TextDrawColor(autosalonkristen_TD[5], -1);
	TextDrawSetShadow(autosalonkristen_TD[5], 0);
	TextDrawSetOutline(autosalonkristen_TD[5], 0);
	TextDrawFont(autosalonkristen_TD[5], 4);
	TextDrawSetSelectable(autosalonkristen_TD[5], true);

	autosalonkristen_TD[6] = TextDrawCreate(553.323608, 278.250000, "auto:exit");
	TextDrawLetterSize(autosalonkristen_TD[6], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[6], 72.152297, 34.416667);
	TextDrawAlignment(autosalonkristen_TD[6], 1);
	TextDrawColor(autosalonkristen_TD[6], -1);
	TextDrawSetShadow(autosalonkristen_TD[6], 0);
	TextDrawSetOutline(autosalonkristen_TD[6], 0);
	TextDrawFont(autosalonkristen_TD[6], 4);
	TextDrawSetSelectable(autosalonkristen_TD[6], true);

	autosalonkristen_TD[7] = TextDrawCreate(483.982421, 291.666656, "auto:buy");
	TextDrawLetterSize(autosalonkristen_TD[7], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[7], 46.852081, 12.833312);
	TextDrawAlignment(autosalonkristen_TD[7], 1);
	TextDrawColor(autosalonkristen_TD[7], -1);
	TextDrawSetShadow(autosalonkristen_TD[7], 0);
	TextDrawSetOutline(autosalonkristen_TD[7], 0);
	TextDrawFont(autosalonkristen_TD[7], 4);

	autosalonkristen_TD[8] = TextDrawCreate(567.847778, 290.499969, "auto:exitt");
	TextDrawLetterSize(autosalonkristen_TD[8], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[8], 46.852111, 12.250000);
	TextDrawAlignment(autosalonkristen_TD[8], 1);
	TextDrawColor(autosalonkristen_TD[8], -1);
	TextDrawSetShadow(autosalonkristen_TD[8], 0);
	TextDrawSetOutline(autosalonkristen_TD[8], 0);
	TextDrawFont(autosalonkristen_TD[8], 4);

	autosalonkristen_TD[9] = TextDrawCreate(13.587119, 200.666656, "auto:color");
	TextDrawLetterSize(autosalonkristen_TD[9], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[9], 172.884338, 67.666679);
	TextDrawAlignment(autosalonkristen_TD[9], 1);
	TextDrawColor(autosalonkristen_TD[9], -1);
	TextDrawSetShadow(autosalonkristen_TD[9], 0);
	TextDrawSetOutline(autosalonkristen_TD[9], 0);
	TextDrawFont(autosalonkristen_TD[9], 4);

	autosalonkristen_TD[10] = TextDrawCreate(405.270874, 385.000000, "");
	TextDrawLetterSize(autosalonkristen_TD[10], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[10], 35.607604, 40.833312);
	TextDrawAlignment(autosalonkristen_TD[10], 1);
	TextDrawColor(autosalonkristen_TD[10], -1);
	TextDrawSetShadow(autosalonkristen_TD[10], 0);
	TextDrawSetOutline(autosalonkristen_TD[10], 0);
	TextDrawFont(autosalonkristen_TD[10], 4);
	TextDrawSetSelectable(autosalonkristen_TD[10], true);

	autosalonkristen_TD[11] = TextDrawCreate(190.219604, 384.416687, "");
	TextDrawLetterSize(autosalonkristen_TD[11], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[11], 32.327987, 42.000000);
	TextDrawAlignment(autosalonkristen_TD[11], 1);
	TextDrawColor(autosalonkristen_TD[11], -1);
	TextDrawSetShadow(autosalonkristen_TD[11], 0);
	TextDrawSetOutline(autosalonkristen_TD[11], 0);
	TextDrawFont(autosalonkristen_TD[11], 4);
	TextDrawSetSelectable(autosalonkristen_TD[11], true);

	autosalonkristen_TD[12] = TextDrawCreate(24.363101, 231.000000, "");
	TextDrawLetterSize(autosalonkristen_TD[12], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[12], 25.300144, 26.833312);
	TextDrawAlignment(autosalonkristen_TD[12], 1);
	TextDrawColor(autosalonkristen_TD[12], -1);
	TextDrawSetShadow(autosalonkristen_TD[12], 0);
	TextDrawSetOutline(autosalonkristen_TD[12], 0);
	TextDrawFont(autosalonkristen_TD[12], 4);
	TextDrawSetSelectable(autosalonkristen_TD[12], true);

	autosalonkristen_TD[13] = TextDrawCreate(66.998535, 232.166671, "");
	TextDrawLetterSize(autosalonkristen_TD[13], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[13], 24.831619, 26.250015);
	TextDrawAlignment(autosalonkristen_TD[13], 1);
	TextDrawColor(autosalonkristen_TD[13], -1);
	TextDrawSetShadow(autosalonkristen_TD[13], 0);
	TextDrawSetOutline(autosalonkristen_TD[13], 0);
	TextDrawFont(autosalonkristen_TD[13], 4);
	TextDrawSetSelectable(autosalonkristen_TD[13], true);

	autosalonkristen_TD[14] = TextDrawCreate(108.696929, 231.000000, "");
	TextDrawLetterSize(autosalonkristen_TD[14], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[14], 24.831619, 27.416687);
	TextDrawAlignment(autosalonkristen_TD[14], 1);
	TextDrawColor(autosalonkristen_TD[14], -1);
	TextDrawSetShadow(autosalonkristen_TD[14], 0);
	TextDrawSetOutline(autosalonkristen_TD[14], 0);
	TextDrawFont(autosalonkristen_TD[14], 4);
	TextDrawSetSelectable(autosalonkristen_TD[14], true);

	autosalonkristen_TD[15] = TextDrawCreate(150.863830, 231.000000, "");
	TextDrawLetterSize(autosalonkristen_TD[15], 0.000000, 0.000000);
	TextDrawTextSize(autosalonkristen_TD[15], 24.831634, 27.416687);
	TextDrawAlignment(autosalonkristen_TD[15], 1);
	TextDrawColor(autosalonkristen_TD[15], -1);
	TextDrawSetShadow(autosalonkristen_TD[15], 0);
	TextDrawSetOutline(autosalonkristen_TD[15], 0);
	TextDrawFont(autosalonkristen_TD[15], 4);
	TextDrawSetSelectable(autosalonkristen_TD[15], true);
	return true;
}

stock create_skins()
{
    skinkristen_TD[0] = TextDrawCreate(177.569564, 390.833404, "auto:lrs");
	TextDrawLetterSize(skinkristen_TD[0], 0.000000, 0.000000);
	TextDrawTextSize(skinkristen_TD[0], 266.120056, 40.833312);
	TextDrawAlignment(skinkristen_TD[0], 1);
	TextDrawColor(skinkristen_TD[0], -1);
	TextDrawSetShadow(skinkristen_TD[0], 0);
	TextDrawSetOutline(skinkristen_TD[0], 0);
	TextDrawFont(skinkristen_TD[0], 4);

	skinkristen_TD[1] = TextDrawCreate(444.626525, 148.750030, "auto:two");
	TextDrawLetterSize(skinkristen_TD[1], 0.000000, 0.000000);
	TextDrawTextSize(skinkristen_TD[1], 180.849197, 140.583312);
	TextDrawAlignment(skinkristen_TD[1], 1);
	TextDrawColor(skinkristen_TD[1], -1);
	TextDrawSetShadow(skinkristen_TD[1], 0);
	TextDrawSetOutline(skinkristen_TD[1], 0);
	TextDrawFont(skinkristen_TD[1], 4);

	skinkristen_TD[2] = TextDrawCreate(179.912139, 393.750000, "");
	TextDrawLetterSize(skinkristen_TD[2], 0.000000, 0.000000);
	TextDrawTextSize(skinkristen_TD[2], 74.494888, 34.416687);
	TextDrawAlignment(skinkristen_TD[2], 1);
	TextDrawColor(skinkristen_TD[2], -1);
	TextDrawSetShadow(skinkristen_TD[2], 0);
	TextDrawSetOutline(skinkristen_TD[2], 0);
	TextDrawFont(skinkristen_TD[2], 4);
	TextDrawSetSelectable(skinkristen_TD[2], true);

	skinkristen_TD[3] = TextDrawCreate(362.635437, 394.916687, "");
	TextDrawLetterSize(skinkristen_TD[3], 0.000000, 0.000000);
	TextDrawTextSize(skinkristen_TD[3], 80.117126, 34.416625);
	TextDrawAlignment(skinkristen_TD[3], 1);
	TextDrawColor(skinkristen_TD[3], -1);
	TextDrawSetShadow(skinkristen_TD[3], 0);
	TextDrawSetOutline(skinkristen_TD[3], 0);
	TextDrawFont(skinkristen_TD[3], 4);
	TextDrawSetSelectable(skinkristen_TD[3], true);

	skinkristen_TD[4] = TextDrawCreate(448.374816, 244.416671, "");
	TextDrawLetterSize(skinkristen_TD[4], 0.000000, 0.000000);
	TextDrawTextSize(skinkristen_TD[4], 71.215209, 42.583328);
	TextDrawAlignment(skinkristen_TD[4], 1);
	TextDrawColor(skinkristen_TD[4], -1);
	TextDrawSetShadow(skinkristen_TD[4], 0);
	TextDrawSetOutline(skinkristen_TD[4], 0);
	TextDrawFont(skinkristen_TD[4], 4);
	TextDrawSetSelectable(skinkristen_TD[4], true);

	skinkristen_TD[5] = TextDrawCreate(547.701293, 247.333328, "");
	TextDrawLetterSize(skinkristen_TD[5], 0.000000, 0.000000);
	TextDrawTextSize(skinkristen_TD[5], 73.557861, 41.999984);
	TextDrawAlignment(skinkristen_TD[5], 1);
	TextDrawColor(skinkristen_TD[5], -1);
	TextDrawSetShadow(skinkristen_TD[5], 0);
	TextDrawSetOutline(skinkristen_TD[5], 0);
	TextDrawFont(skinkristen_TD[5], 4);
	TextDrawSetSelectable(skinkristen_TD[5], true);
	return true;
}
