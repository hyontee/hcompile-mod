stock CreateTextDraws(playerid) {

/* 	mobile_local_hud[playerid][0] = CreatePlayerTextDraw(playerid, 508.000000, 98.000000, "200");
	PlayerTextDrawFont(playerid, mobile_local_hud[playerid][0], 1);
	PlayerTextDrawLetterSize(playerid, mobile_local_hud[playerid][0], 0.312500, 1.249999);
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][0], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_hud[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, mobile_local_hud[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_hud[playerid][0], 1);
	PlayerTextDrawColor(playerid, mobile_local_hud[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_hud[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_hud[playerid][0], 0);
	PlayerTextDrawUseBox(playerid, mobile_local_hud[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_hud[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_hud[playerid][0], 0);

	mobile_local_hud[playerid][1] = CreatePlayerTextDraw(playerid, 592.000000, 112.000000, "__"); // здесь выводить патроны
	PlayerTextDrawFont(playerid, mobile_local_hud[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, mobile_local_hud[playerid][1], 0.408333, 1.599997);
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_hud[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, mobile_local_hud[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_hud[playerid][1], 1);
	PlayerTextDrawColor(playerid, mobile_local_hud[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_hud[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_hud[playerid][1], 0);
	PlayerTextDrawUseBox(playerid, mobile_local_hud[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_hud[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_hud[playerid][1], 0);


	mobile_local_hud[playerid][2] = CreatePlayerTextDraw(playerid, 584.000000, 59.000000, "hud:fist");
	PlayerTextDrawFont(playerid, mobile_local_hud[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_hud[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][2], 46.500000, 49.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_hud[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_hud[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_hud[playerid][2], 1);
	PlayerTextDrawColor(playerid, mobile_local_hud[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_hud[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_hud[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_hud[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_hud[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_hud[playerid][2], 1);

	mobile_local_hud[playerid][3] = CreatePlayerTextDraw(playerid, 500.000000, 57.000000, "__");
	PlayerTextDrawFont(playerid, mobile_local_hud[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, mobile_local_hud[playerid][3], 6.662489, 0.499998);
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][3], 565.000000, 57.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_hud[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_hud[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_hud[playerid][3], 1);
	PlayerTextDrawColor(playerid, mobile_local_hud[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_hud[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_hud[playerid][3], -100663041);
	PlayerTextDrawUseBox(playerid, mobile_local_hud[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_hud[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_hud[playerid][3], 0);

	mobile_local_hud[playerid][4] = CreatePlayerTextDraw(playerid, 500.000000, 72.000000, "__");
	PlayerTextDrawFont(playerid, mobile_local_hud[playerid][4], 1);
	PlayerTextDrawLetterSize(playerid, mobile_local_hud[playerid][4], 6.662489, 0.499998);
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][4], 565.000000, 57.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_hud[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_hud[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_hud[playerid][4], 1);
	PlayerTextDrawColor(playerid, mobile_local_hud[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_hud[playerid][4], -91160321);
	PlayerTextDrawBoxColor(playerid, mobile_local_hud[playerid][4], -328859393);
	PlayerTextDrawUseBox(playerid, mobile_local_hud[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_hud[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_hud[playerid][4], 0);

	mobile_local_hud[playerid][5] = CreatePlayerTextDraw(playerid, 501.000000, 86.000000, "__");
	PlayerTextDrawFont(playerid, mobile_local_hud[playerid][5], 1);
	PlayerTextDrawLetterSize(playerid, mobile_local_hud[playerid][5], 6.662489, 0.499998);
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][5], 565.000000, 57.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_hud[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_hud[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_hud[playerid][5], 1);
	PlayerTextDrawColor(playerid, mobile_local_hud[playerid][5], 1097458175);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_hud[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_hud[playerid][5], 7531775);
	PlayerTextDrawUseBox(playerid, mobile_local_hud[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_hud[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_hud[playerid][5], 0);

	mobile_local_hud[playerid][6] = CreatePlayerTextDraw(playerid, 483.000000, 114.000000, "txd:wanted_0");
	PlayerTextDrawFont(playerid, mobile_local_hud[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_hud[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_hud[playerid][6], 82.000000, 22.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_hud[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_hud[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_hud[playerid][6], 1);
	PlayerTextDrawColor(playerid, mobile_local_hud[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_hud[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_hud[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_hud[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_hud[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_hud[playerid][6], 0); */

	SPEEDOMETR_LOCAL[playerid][0] = CreatePlayerTextDraw(playerid, 521.067504, 367.955749, "ENGINE");
	PlayerTextDrawLetterSize(playerid, SPEEDOMETR_LOCAL[playerid][0], 0.163332, 0.952889);
	PlayerTextDrawAlignment(playerid, SPEEDOMETR_LOCAL[playerid][0], 2);
	PlayerTextDrawColor(playerid, SPEEDOMETR_LOCAL[playerid][0], 1648129279);
	PlayerTextDrawSetShadow(playerid, SPEEDOMETR_LOCAL[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, SPEEDOMETR_LOCAL[playerid][0], 255);
	PlayerTextDrawFont(playerid, SPEEDOMETR_LOCAL[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, SPEEDOMETR_LOCAL[playerid][0], 1);

	SPEEDOMETR_LOCAL[playerid][1] = CreatePlayerTextDraw(playerid, 558.865417, 367.955749, "lock");
	PlayerTextDrawLetterSize(playerid, SPEEDOMETR_LOCAL[playerid][1], 0.163332, 0.952889);
	PlayerTextDrawAlignment(playerid, SPEEDOMETR_LOCAL[playerid][1], 2);
	PlayerTextDrawColor(playerid, SPEEDOMETR_LOCAL[playerid][1], 1648129279);
	PlayerTextDrawSetShadow(playerid, SPEEDOMETR_LOCAL[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, SPEEDOMETR_LOCAL[playerid][1], 255);
	PlayerTextDrawFont(playerid, SPEEDOMETR_LOCAL[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, SPEEDOMETR_LOCAL[playerid][1], 1);

	SPEEDOMETR_LOCAL[playerid][2] = CreatePlayerTextDraw(playerid, 595.657409, 367.955749, "LIGHT");
	PlayerTextDrawLetterSize(playerid, SPEEDOMETR_LOCAL[playerid][2], 0.163332, 0.952889);
	PlayerTextDrawAlignment(playerid, SPEEDOMETR_LOCAL[playerid][2], 2);
	PlayerTextDrawColor(playerid, SPEEDOMETR_LOCAL[playerid][2], 1648129279);
	PlayerTextDrawSetShadow(playerid, SPEEDOMETR_LOCAL[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, SPEEDOMETR_LOCAL[playerid][2], 255);
	PlayerTextDrawFont(playerid, SPEEDOMETR_LOCAL[playerid][2], 2);
	PlayerTextDrawSetProportional(playerid, SPEEDOMETR_LOCAL[playerid][2], 1);

	SPEEDOMETR_LOCAL[playerid][3] = CreatePlayerTextDraw(playerid, 523.966064, 385.159637, "000");
	PlayerTextDrawLetterSize(playerid, SPEEDOMETR_LOCAL[playerid][3], 0.387665, 2.392296);
	PlayerTextDrawAlignment(playerid, SPEEDOMETR_LOCAL[playerid][3], 2);
	PlayerTextDrawColor(playerid, SPEEDOMETR_LOCAL[playerid][3], -1);
	PlayerTextDrawSetShadow(playerid, SPEEDOMETR_LOCAL[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, SPEEDOMETR_LOCAL[playerid][3], 255);
	PlayerTextDrawFont(playerid, SPEEDOMETR_LOCAL[playerid][3], 2);
	PlayerTextDrawSetProportional(playerid, SPEEDOMETR_LOCAL[playerid][3], 1);

	SPEEDOMETR_LOCAL[playerid][4] = CreatePlayerTextDraw(playerid, 523.632995, 407.144561, "00000_km");
	PlayerTextDrawLetterSize(playerid, SPEEDOMETR_LOCAL[playerid][4], 0.173333, 1.156147);
	PlayerTextDrawAlignment(playerid, SPEEDOMETR_LOCAL[playerid][4], 2);
	PlayerTextDrawColor(playerid, SPEEDOMETR_LOCAL[playerid][4], 842150655);
	PlayerTextDrawSetShadow(playerid, SPEEDOMETR_LOCAL[playerid][4], 0);
	PlayerTextDrawBackgroundColor(playerid, SPEEDOMETR_LOCAL[playerid][4], 255);
	PlayerTextDrawFont(playerid, SPEEDOMETR_LOCAL[playerid][4], 2);
	PlayerTextDrawSetProportional(playerid, SPEEDOMETR_LOCAL[playerid][4], 1);

	SPEEDOMETR_LOCAL[playerid][5] = CreatePlayerTextDraw(playerid, 548.966186, 409.905151, "LD_SPAC:white"); // Fuel
	PlayerTextDrawTextSize(playerid, SPEEDOMETR_LOCAL[playerid][5], 62.0000, 5.0000);
	PlayerTextDrawAlignment(playerid, SPEEDOMETR_LOCAL[playerid][5], 1);
	PlayerTextDrawColor(playerid, SPEEDOMETR_LOCAL[playerid][5], -256957441);
	PlayerTextDrawBackgroundColor(playerid, SPEEDOMETR_LOCAL[playerid][5], 255);
	PlayerTextDrawFont(playerid, SPEEDOMETR_LOCAL[playerid][5], 4);
	PlayerTextDrawSetProportional(playerid, SPEEDOMETR_LOCAL[playerid][5], 0);

	SPEEDOMETR_LOCAL[playerid][6] = CreatePlayerTextDraw(playerid, 559.632812, 387.881744, "HP_CAR:_~w~100%");
	PlayerTextDrawLetterSize(playerid, SPEEDOMETR_LOCAL[playerid][6], 0.141000, 0.915553);
	PlayerTextDrawTextSize(playerid, SPEEDOMETR_LOCAL[playerid][6], 2000.000000, 0.000000);
	PlayerTextDrawAlignment(playerid, SPEEDOMETR_LOCAL[playerid][6], 1);
	PlayerTextDrawColor(playerid, SPEEDOMETR_LOCAL[playerid][6], -13356545);
	PlayerTextDrawSetShadow(playerid, SPEEDOMETR_LOCAL[playerid][6], 0);
	PlayerTextDrawBackgroundColor(playerid, SPEEDOMETR_LOCAL[playerid][6], 255);
	PlayerTextDrawFont(playerid, SPEEDOMETR_LOCAL[playerid][6], 2);
	PlayerTextDrawSetProportional(playerid, SPEEDOMETR_LOCAL[playerid][6], 1);

	fspeed[playerid][0] = CreatePlayerTextDraw(playerid, 245.000000, 322.000000, "txd:speed");
	PlayerTextDrawFont(playerid, fspeed[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, fspeed[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, fspeed[playerid][0], 151.000000, 147.000000);
	PlayerTextDrawSetOutline(playerid, fspeed[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, fspeed[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, fspeed[playerid][0], 1);
	PlayerTextDrawColor(playerid, fspeed[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, fspeed[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, fspeed[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, fspeed[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, fspeed[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, fspeed[playerid][0], 0);

	new Float: fspeed_correct_text_x = 2.0;
	
	fspeed[playerid][1] = CreatePlayerTextDraw(playerid, 299.000000+fspeed_correct_text_x, 377.000000, "123");
	PlayerTextDrawFont(playerid, fspeed[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid, fspeed[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, fspeed[playerid][1], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, fspeed[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, fspeed[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, fspeed[playerid][1], 1);
	PlayerTextDrawColor(playerid, fspeed[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, fspeed[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, fspeed[playerid][1], 0);
	PlayerTextDrawUseBox(playerid, fspeed[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, fspeed[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, fspeed[playerid][1], 0);

	fspeed[playerid][2] = CreatePlayerTextDraw(playerid, 303.000000+fspeed_correct_text_x, 401.000000, "Infernus");
	PlayerTextDrawFont(playerid, fspeed[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, fspeed[playerid][2], 0.254166, 1.149999);
	PlayerTextDrawTextSize(playerid, fspeed[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, fspeed[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, fspeed[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, fspeed[playerid][2], 1);
	PlayerTextDrawColor(playerid, fspeed[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, fspeed[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, fspeed[playerid][2], 0);
	PlayerTextDrawUseBox(playerid, fspeed[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, fspeed[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, fspeed[playerid][2], 0);

	fspeed[playerid][3] = CreatePlayerTextDraw(playerid, 298.000000+fspeed_correct_text_x, 409.000000, "00052 KM");
	PlayerTextDrawFont(playerid, fspeed[playerid][3], 1);
	PlayerTextDrawLetterSize(playerid, fspeed[playerid][3], 0.254166, 1.000000);
	PlayerTextDrawTextSize(playerid, fspeed[playerid][3], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, fspeed[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, fspeed[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, fspeed[playerid][3], 1);
	PlayerTextDrawColor(playerid, fspeed[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, fspeed[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, fspeed[playerid][3], 0);
	PlayerTextDrawUseBox(playerid, fspeed[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, fspeed[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, fspeed[playerid][3], 0);

	fspeed[playerid][4] = CreatePlayerTextDraw(playerid, 366.000000, 399.000000, "txd:lockoff");
	PlayerTextDrawFont(playerid, fspeed[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, fspeed[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, fspeed[playerid][4], 17.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, fspeed[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, fspeed[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, fspeed[playerid][4], 1);
	PlayerTextDrawColor(playerid, fspeed[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, fspeed[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, fspeed[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, fspeed[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, fspeed[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, fspeed[playerid][4], 0);

	fspeed[playerid][5] = CreatePlayerTextDraw(playerid, 368.000000, 417.000000, "txd:lightoff");
	PlayerTextDrawFont(playerid, fspeed[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, fspeed[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, fspeed[playerid][5], 13.500000, 17.000000);
	PlayerTextDrawSetOutline(playerid, fspeed[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, fspeed[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, fspeed[playerid][5], 1);
	PlayerTextDrawColor(playerid, fspeed[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, fspeed[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, fspeed[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, fspeed[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, fspeed[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, fspeed[playerid][5], 0);

	fspeed[playerid][6] = CreatePlayerTextDraw(playerid, 259.000000, 400.000000, "txd:fuellow");
	PlayerTextDrawFont(playerid, fspeed[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, fspeed[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, fspeed[playerid][6], 13.500000, 15.000000);
	PlayerTextDrawSetOutline(playerid, fspeed[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, fspeed[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, fspeed[playerid][6], 1);
	PlayerTextDrawColor(playerid, fspeed[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, fspeed[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, fspeed[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, fspeed[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, fspeed[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, fspeed[playerid][6], 0);

	fspeed[playerid][7] = CreatePlayerTextDraw(playerid, 259.000000, 418.000000, "txd:enoff");
	PlayerTextDrawFont(playerid, fspeed[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, fspeed[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, fspeed[playerid][7], 13.500000, 15.000000);
	PlayerTextDrawSetOutline(playerid, fspeed[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, fspeed[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, fspeed[playerid][7], 1);
	PlayerTextDrawColor(playerid, fspeed[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, fspeed[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, fspeed[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, fspeed[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, fspeed[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, fspeed[playerid][7], 0);

	theft_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 583.7628, 297.9164, "00:00"); // угон
	PlayerTextDrawLetterSize(playerid, theft_PTD[playerid][0], 0.4000, 1.6000);
	PlayerTextDrawAlignment(playerid, theft_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, theft_PTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, theft_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, theft_PTD[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, theft_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, theft_PTD[playerid][0], 0);

	theft_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 583.7627, 286.8330, "00:00"); // угон
	PlayerTextDrawLetterSize(playerid, theft_PTD[playerid][1], 0.4000, 1.6000);
	PlayerTextDrawAlignment(playerid, theft_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, theft_PTD[playerid][1], -16776961);
	PlayerTextDrawBackgroundColor(playerid, theft_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, theft_PTD[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid, theft_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, theft_PTD[playerid][1], 0);

	buy_player_skins[playerid] = CreatePlayerTextDraw(playerid, 294.555664, 404.706756, "10000$");
	PlayerTextDrawLetterSize(playerid, buy_player_skins[playerid], 0.217999, 1.316264);
	PlayerTextDrawAlignment(playerid, buy_player_skins[playerid], 1);
	PlayerTextDrawColor(playerid, buy_player_skins[playerid], -1);
	PlayerTextDrawSetShadow(playerid, buy_player_skins[playerid], 0);
	PlayerTextDrawSetOutline(playerid, buy_player_skins[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, buy_player_skins[playerid], 255);
	PlayerTextDrawFont(playerid, buy_player_skins[playerid], 2);
	PlayerTextDrawSetProportional(playerid, buy_player_skins[playerid], 1);

	skill_player_td[playerid][0] = CreatePlayerTextDraw(playerid,484.000091, 363.875549, "Desert Eagle");
	PlayerTextDrawLetterSize(playerid,skill_player_td[playerid][0], 0.186000, 1.077332);
	PlayerTextDrawAlignment(playerid,skill_player_td[playerid][0], 1);
	PlayerTextDrawColor(playerid,skill_player_td[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid,skill_player_td[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid,skill_player_td[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid,skill_player_td[playerid][0], 51);
	PlayerTextDrawFont(playerid,skill_player_td[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid,skill_player_td[playerid][0], 1);

	skill_player_td[playerid][1] = CreatePlayerTextDraw(playerid,497.444732, 372.342224, "0/0");
	PlayerTextDrawLetterSize(playerid,skill_player_td[playerid][1], 0.198444, 1.127111);
	PlayerTextDrawAlignment(playerid,skill_player_td[playerid][1], 1);
	PlayerTextDrawColor(playerid,skill_player_td[playerid][1], COLOR_SERVER);
	PlayerTextDrawSetShadow(playerid,skill_player_td[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid,skill_player_td[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid,skill_player_td[playerid][1], 51);
	PlayerTextDrawFont(playerid,skill_player_td[playerid][1], 2);
	PlayerTextDrawSetProportional(playerid,skill_player_td[playerid][1], 1);

	RECON[playerid] = CreatePlayerTextDraw(playerid, 457.7958, 241.8333, "_");
	PlayerTextDrawFont(playerid, RECON[playerid], 2);
	PlayerTextDrawColor(playerid, RECON[playerid],-1);
	PlayerTextDrawSetOutline(playerid, RECON[playerid], 0);
	PlayerTextDrawLetterSize(playerid, RECON[playerid], 0.410000, 1.000000);
	PlayerTextDrawSetOutline(playerid, RECON[playerid],1);
	PlayerTextDrawSetProportional(playerid, RECON[playerid], 1);
	PlayerTextDrawAlignment(playerid, RECON[playerid], 1);
	PlayerTextDrawSetShadow(playerid, RECON[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, RECON[playerid], 51);
	//PlayerTextDrawUseBox(playerid,RECON[playerid], 1);
	//PlayerTextDrawBoxColor(playerid,RECON[playerid], 100);

	

	work_td_local[playerid][0] = CreatePlayerTextDraw(playerid, 550.432678, 141.611038, "MONEY:_0");
	PlayerTextDrawLetterSize(playerid, work_td_local[playerid][0], 0.159998, 1.114665);
	PlayerTextDrawAlignment(playerid, work_td_local[playerid][0], 1);
	PlayerTextDrawColor(playerid, work_td_local[playerid][0], -1);
	PlayerTextDrawSetShadow(playerid, work_td_local[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, work_td_local[playerid][0], 255);
	PlayerTextDrawFont(playerid, work_td_local[playerid][0], 2);
	PlayerTextDrawSetProportional(playerid, work_td_local[playerid][0], 1);

	// YandNsysTDPlayer[playerid][0] = CreatePlayerTextDraw(playerid, 287.288482, 318.583343, "PRESS Y");
	// PlayerTextDrawLetterSize(playerid, YandNsysTDPlayer[playerid][0], 0.449999, 1.600000);
	// PlayerTextDrawAlignment(playerid, YandNsysTDPlayer[playerid][0], 1);
	// PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][0], -1);
	// PlayerTextDrawSetShadow(playerid, YandNsysTDPlayer[playerid][0], 0);
	// PlayerTextDrawSetOutline(playerid, YandNsysTDPlayer[playerid][0], 1);
	// PlayerTextDrawBackgroundColor(playerid, YandNsysTDPlayer[playerid][0], 51);
	// PlayerTextDrawFont(playerid, YandNsysTDPlayer[playerid][0], 2);
	// PlayerTextDrawSetProportional(playerid, YandNsysTDPlayer[playerid][0], 1);
	
	// YandNsysTDPlayer[playerid][1] = CreatePlayerTextDraw(playerid, 294.472076, 332.583099, "IIIIIIIIII");
	// PlayerTextDrawLetterSize(playerid, YandNsysTDPlayer[playerid][1], 0.402498, 1.553333);
	// PlayerTextDrawAlignment(playerid, YandNsysTDPlayer[playerid][1], 1);
	// PlayerTextDrawColor(playerid, YandNsysTDPlayer[playerid][1], -1);
	// PlayerTextDrawSetShadow(playerid, YandNsysTDPlayer[playerid][1], 0);
	// PlayerTextDrawSetOutline(playerid, YandNsysTDPlayer[playerid][1], 1);
	// PlayerTextDrawBackgroundColor(playerid, YandNsysTDPlayer[playerid][1], 51);
	// PlayerTextDrawFont(playerid, YandNsysTDPlayer[playerid][1], 1);
	// PlayerTextDrawSetProportional(playerid, YandNsysTDPlayer[playerid][1], 1);
	
	load_tunes(playerid);

	LoadTexturess[playerid] = CreatePlayerTextDraw(playerid,394.110778, 221.522186, "usebox");
	PlayerTextDrawLetterSize(playerid,LoadTexturess[playerid], 0.000000, 0.091233);
	PlayerTextDrawTextSize(playerid,LoadTexturess[playerid], 211.777893, 0.000000);
	PlayerTextDrawAlignment(playerid,LoadTexturess[playerid], 1);
	PlayerTextDrawColor(playerid,LoadTexturess[playerid], 0);
	PlayerTextDrawUseBox(playerid,LoadTexturess[playerid], true);
	PlayerTextDrawBoxColor(playerid,LoadTexturess[playerid], 255);
	PlayerTextDrawSetShadow(playerid,LoadTexturess[playerid], 0);
	PlayerTextDrawSetOutline(playerid,LoadTexturess[playerid], 0);
	PlayerTextDrawFont(playerid,LoadTexturess[playerid], 0);

	HungerProgres[playerid] = CreatePlayerTextDraw(playerid,549.500000, 60.000000, "____");
	PlayerTextDrawBackgroundColor(playerid,HungerProgres[playerid], 255);
	PlayerTextDrawFont(playerid,HungerProgres[playerid], 1);
	PlayerTextDrawLetterSize(playerid,HungerProgres[playerid], 0.490000, -0.000000);
	PlayerTextDrawColor(playerid,HungerProgres[playerid], -1);
	PlayerTextDrawSetOutline(playerid,HungerProgres[playerid], 0);
	PlayerTextDrawSetProportional(playerid,HungerProgres[playerid], 1);
	PlayerTextDrawSetShadow(playerid,HungerProgres[playerid], 1);
	PlayerTextDrawUseBox(playerid,HungerProgres[playerid], 1);
	PlayerTextDrawBoxColor(playerid,HungerProgres[playerid], COLOR_SERVER);
	PlayerTextDrawTextSize(playerid,HungerProgres[playerid], 604.000000, 40.000000);
	PlayerTextDrawSetSelectable(playerid,HungerProgres[playerid], 0);

	HungerProgres_ANDROID[playerid] = CreatePlayerTextDraw(playerid,549.500000-xANDROIDHUNGRY, 60.000000+yANDROIDHUNGRY, "____");
	PlayerTextDrawBackgroundColor(playerid,HungerProgres_ANDROID[playerid], 255);
	PlayerTextDrawFont(playerid,HungerProgres_ANDROID[playerid], 1);
	PlayerTextDrawLetterSize(playerid,HungerProgres_ANDROID[playerid], 0.490000-xANDROIDHUNGRY, -0.000000+yANDROIDHUNGRY);
	PlayerTextDrawColor(playerid,HungerProgres_ANDROID[playerid], -1);
	PlayerTextDrawSetOutline(playerid,HungerProgres_ANDROID[playerid], 0);
	PlayerTextDrawSetProportional(playerid,HungerProgres_ANDROID[playerid], 1);
	PlayerTextDrawSetShadow(playerid,HungerProgres_ANDROID[playerid], 1);
	PlayerTextDrawUseBox(playerid,HungerProgres_ANDROID[playerid], 1);
	PlayerTextDrawBoxColor(playerid,HungerProgres_ANDROID[playerid], COLOR_SERVER);
	PlayerTextDrawTextSize(playerid,HungerProgres_ANDROID[playerid], 604.000000-xANDROIDHUNGRY, 40.000000+yANDROIDHUNGRY);
	PlayerTextDrawSetSelectable(playerid,HungerProgres_ANDROID[playerid], 0);

	new Float: DmArenaTextDrawY = 4.0;
	DmArenaTextDraw[playerid] = CreatePlayerTextDraw(playerid, 520.00, 100.00-DmArenaTextDrawY, "~b~Kills: ~g~0~n~~b~Deatch: ~g~Kills~n~~b~Deaths:~g~ 0 km");
	PlayerTextDrawAlignment(playerid, DmArenaTextDraw[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DmArenaTextDraw[playerid], 0x000000ff);
	PlayerTextDrawFont(playerid, DmArenaTextDraw[playerid], 3);
	PlayerTextDrawLetterSize(playerid, DmArenaTextDraw[playerid], 0.399999, 1.00);
	PlayerTextDrawColor(playerid, DmArenaTextDraw[playerid], 0x0054c6ff);
	PlayerTextDrawSetOutline(playerid, DmArenaTextDraw[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DmArenaTextDraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DmArenaTextDraw[playerid], 1);
}
/* stock createAuthInterface(playerid) {
	mobile_local_register[playerid][0] = CreatePlayerTextDraw(playerid, 194.000000, 118.000000, "txd:f_reg_1");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][0], 232.000000, 266.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][0], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][0], 0);

	//  нопка при нажатии на которою по€витс€ окно ввода парол€
	mobile_local_register[playerid][1] = CreatePlayerTextDraw(playerid, 241.000000, 214.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][1], 139.500000, 22.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][1], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][1], 1);

	//  нопка при нажатии на которою по€витс€ окно ввода почты
	mobile_local_register[playerid][2] = CreatePlayerTextDraw(playerid, 241.000000, 261.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][2], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][2], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][2], 139.500000, 22.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][2], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][2], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][2], 1);

	//  нопка при нажатии на которою по€витс€ окно авторизации
	mobile_local_register[playerid][3] = CreatePlayerTextDraw(playerid, 270.000000, 294.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][3], 81.000000, 15.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][3], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][3], 1);

	//  нопка при нажатии на которую отменитс€ регистраци€
	mobile_local_register[playerid][4] = CreatePlayerTextDraw(playerid, 231.000000, 319.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][4], 69.500000, 25.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][4], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][4], 1);

	//  нопка при нажатии на которою по€витс€ другой тд с выбором пола и т.д
	mobile_local_register[playerid][5] = CreatePlayerTextDraw(playerid, 319.000000, 319.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][5], 70.500000, 25.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][5], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][5], 1);
	
	

	mobile_local_register[playerid][6] = CreatePlayerTextDraw(playerid, 181.000000, 121.000000, "txd:f_reg_2");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][6], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][6], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][6], 237.500000, 274.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][6], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][6], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][6], 0);

	// †нопка при нажатии на которою по§витс§ окно ввода реферала
	mobile_local_register[playerid][7] = CreatePlayerTextDraw(playerid, 231.000000, 221.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][7], 140.500000, 22.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][7], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][7], 1);

	// †нопка при нажатии на которою выберитс§ мужской пол
	mobile_local_register[playerid][8] = CreatePlayerTextDraw(playerid, 234.000000, 268.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][8], 56.500000, 22.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][8], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][8], 1);

	// †нопка при нажатии на которою выберитс§ женский пол
	mobile_local_register[playerid][9] = CreatePlayerTextDraw(playerid, 309.000000, 268.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][9], 56.500000, 22.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][9], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][9], 1);

	// †нопка при нажатии на которою по§витс§ предыдущий текстдрав реги
	mobile_local_register[playerid][10] = CreatePlayerTextDraw(playerid, 221.000000, 326.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][10], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][10], 69.500000, 25.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][10], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][10], 1);

	// †нопка при нажатии на которою человек зарегистрируетс§
	mobile_local_register[playerid][11] = CreatePlayerTextDraw(playerid, 310.000000, 326.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][11], 69.500000, 25.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][11], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][11], 1);

    mobile_local_auth[playerid][0] = CreatePlayerTextDraw(playerid, 194.000000, 109.000000, "txd:f_auth");
    PlayerTextDrawFont(playerid, mobile_local_auth[playerid][0], 4);
    PlayerTextDrawLetterSize(playerid, mobile_local_auth[playerid][0], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, mobile_local_auth[playerid][0], 241.000000, 269.500000);
    PlayerTextDrawSetOutline(playerid, mobile_local_auth[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, mobile_local_auth[playerid][0], 0);
    PlayerTextDrawAlignment(playerid, mobile_local_auth[playerid][0], 1);
    PlayerTextDrawColor(playerid, mobile_local_auth[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, mobile_local_auth[playerid][0], 255);
    PlayerTextDrawBoxColor(playerid, mobile_local_auth[playerid][0], 50);
    PlayerTextDrawUseBox(playerid, mobile_local_auth[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, mobile_local_auth[playerid][0], 1);
    PlayerTextDrawSetSelectable(playerid, mobile_local_auth[playerid][0], 0);

    mobile_local_auth[playerid][1] = CreatePlayerTextDraw(playerid, 243.000000, 230.000000, "txd:btn"); // †нопка по нажатию которой по§витс§ диалог со вводом парол§
    PlayerTextDrawFont(playerid, mobile_local_auth[playerid][1], 4);
    PlayerTextDrawLetterSize(playerid, mobile_local_auth[playerid][1], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, mobile_local_auth[playerid][1], 144.500000, 22.000000);
    PlayerTextDrawSetOutline(playerid, mobile_local_auth[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, mobile_local_auth[playerid][1], 0);
    PlayerTextDrawAlignment(playerid, mobile_local_auth[playerid][1], 1);
    PlayerTextDrawColor(playerid, mobile_local_auth[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, mobile_local_auth[playerid][1], 255);
    PlayerTextDrawBoxColor(playerid, mobile_local_auth[playerid][1], 50);
    PlayerTextDrawUseBox(playerid, mobile_local_auth[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, mobile_local_auth[playerid][1], 1);
    PlayerTextDrawSetSelectable(playerid, mobile_local_auth[playerid][1], 1);

    mobile_local_auth[playerid][2] = CreatePlayerTextDraw(playerid, 280.000000, 279.000000, "txd:btn"); // †нопка по нажатию которой по§витс§ диалог восстановлени§ парол§
    PlayerTextDrawFont(playerid, mobile_local_auth[playerid][2], 4);
    PlayerTextDrawLetterSize(playerid, mobile_local_auth[playerid][2], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, mobile_local_auth[playerid][2], 73.000000, 14.500000);
    PlayerTextDrawSetOutline(playerid, mobile_local_auth[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, mobile_local_auth[playerid][2], 0);
    PlayerTextDrawAlignment(playerid, mobile_local_auth[playerid][2], 1);
    PlayerTextDrawColor(playerid, mobile_local_auth[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, mobile_local_auth[playerid][2], 255);
    PlayerTextDrawBoxColor(playerid, mobile_local_auth[playerid][2], 50);
    PlayerTextDrawUseBox(playerid, mobile_local_auth[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, mobile_local_auth[playerid][2], 1);
    PlayerTextDrawSetSelectable(playerid, mobile_local_auth[playerid][2], 1);

    mobile_local_auth[playerid][3] = CreatePlayerTextDraw(playerid, 233.000000, 311.000000, "txd:btn"); // †нопка по нажатию которой игрок отменит авторизацию
    PlayerTextDrawFont(playerid, mobile_local_auth[playerid][3], 4);
    PlayerTextDrawLetterSize(playerid, mobile_local_auth[playerid][3], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, mobile_local_auth[playerid][3], 74.000000, 25.000000);
    PlayerTextDrawSetOutline(playerid, mobile_local_auth[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, mobile_local_auth[playerid][3], 0);
    PlayerTextDrawAlignment(playerid, mobile_local_auth[playerid][3], 1);
    PlayerTextDrawColor(playerid, mobile_local_auth[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, mobile_local_auth[playerid][3], 255);
    PlayerTextDrawBoxColor(playerid, mobile_local_auth[playerid][3], 50);
    PlayerTextDrawUseBox(playerid, mobile_local_auth[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, mobile_local_auth[playerid][3], 1);
    PlayerTextDrawSetSelectable(playerid, mobile_local_auth[playerid][3], 1);

    mobile_local_auth[playerid][4] = CreatePlayerTextDraw(playerid, 325.000000, 311.000000, "txd:btn"); // †нопка по нажатию которой игрок авторизируетс§ если пароль введен верно
    PlayerTextDrawFont(playerid, mobile_local_auth[playerid][4], 4);
    PlayerTextDrawLetterSize(playerid, mobile_local_auth[playerid][4], 0.600000, 2.000000);
    PlayerTextDrawTextSize(playerid, mobile_local_auth[playerid][4], 72.000000, 25.000000);
    PlayerTextDrawSetOutline(playerid, mobile_local_auth[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, mobile_local_auth[playerid][4], 0);
    PlayerTextDrawAlignment(playerid, mobile_local_auth[playerid][4], 1);
    PlayerTextDrawColor(playerid, mobile_local_auth[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, mobile_local_auth[playerid][4], 255);
    PlayerTextDrawBoxColor(playerid, mobile_local_auth[playerid][4], 50);
    PlayerTextDrawUseBox(playerid, mobile_local_auth[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, mobile_local_auth[playerid][4], 1);
    PlayerTextDrawSetSelectable(playerid, mobile_local_auth[playerid][4], 1);

	return 1;
}
stock createRegisterInterface(playerid) {
	// ‘он 1 страницы
	mobile_local_register[playerid][0] = CreatePlayerTextDraw(playerid, 220.000000, 121.000000, "txd:f_reg_1");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][0], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][0], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][0], 193.000000, 234.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][0], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][0], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][0], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][0], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][0], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][0], 0);

	//  нопка ввода парол€
	mobile_local_register[playerid][1] = CreatePlayerTextDraw(playerid, 259.000000, 206.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][1], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][1], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][1], 116.500000, 17.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][1], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][1], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][1], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][1], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][1], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][1], 1);

	// ѕочта (измени на пробелы, потом сетнешь когда игрок введет)
	mobile_local_register[playerid][2] = CreatePlayerTextDraw(playerid, 264.000000, 252.000000, "");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][2], 0.254166, 0.999998);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][2], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][2], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][2], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][2], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][2], 0);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][2], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][2], 0);

	//  нопка ввода почты
	mobile_local_register[playerid][3] = CreatePlayerTextDraw(playerid, 259.000000, 247.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][3], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][3], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][3], 117.000000, 19.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][3], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][3], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][3], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][3], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][3], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][3], 1);

	//  нопка выйти
	mobile_local_register[playerid][4] = CreatePlayerTextDraw(playerid, 252.000000, 295.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][4], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][4], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][4], 58.500000, 22.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][4], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][4], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][4], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][4], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][4], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][4], 1);

	//  нопка далее
	mobile_local_register[playerid][5] = CreatePlayerTextDraw(playerid, 325.000000, 296.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][5], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][5], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][5], 58.500000, 22.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][5], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][5], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][5], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][5], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][5], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][5], 1);

	// ѕароль (ќЅя«ј“≈Ћ№Ќќ сетай точки (другое не работает), сетни пробел, когда игрок введет - сетай точки)
	mobile_local_register[playerid][6] = CreatePlayerTextDraw(playerid, 296.000000, 192.000000, "......");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][6], 1);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][6], 0.645833, 3.249997);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][6], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][6], 0);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][6], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][6], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][6], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][6], 0);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][6], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][6], 0);
	
	// - - - - - - - - - -- - - - 2 страница - - - - - - - - - - - - -- - - - - - - - - - - - - - -- - - -- - --- -
	// ‘он 2 страница
	mobile_local_register[playerid][7] = CreatePlayerTextDraw(playerid, 220.000000, 121.000000, "txd:f_reg_2");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][7], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][7], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][7], 194.000000, 234.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][7], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][7], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][7], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][7], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][7], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][7], 0);

	//  нопка ввода реферала
	mobile_local_register[playerid][8] = CreatePlayerTextDraw(playerid, 260.000000, 207.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][8], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][8], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][8], 116.500000, 17.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][8], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][8], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][8], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][8], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][8], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][8], 1);

	//  нопка выбора мужского пола
	mobile_local_register[playerid][9] = CreatePlayerTextDraw(playerid, 324.000000, 247.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][9], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][9], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][9], 46.500000, 19.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][9], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][9], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][9], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][9], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][9], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][9], 1);

	//  нопка выбора женского пола
	mobile_local_register[playerid][10] = CreatePlayerTextDraw(playerid, 264.000000, 247.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][10], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][10], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][10], 46.500000, 19.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][10], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][10], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][10], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][10], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][10], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][10], 1);

	//  нопка назад
	mobile_local_register[playerid][11] = CreatePlayerTextDraw(playerid, 252.000000, 295.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][11], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][11], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][11], 58.500000, 22.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][11], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][11], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][11], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][11], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][11], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][11], 1);

	//  нопка завершени€ реги
	mobile_local_register[playerid][12] = CreatePlayerTextDraw(playerid, 325.000000, 296.000000, "txd:btn");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][12], 4);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][12], 0.600000, 2.000000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][12], 58.500000, 22.500000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][12], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][12], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][12], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][12], 50);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][12], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][12], 1);

	// »м€ реферала (—мени на несколько пробелов, потом сетнешь ник)
	mobile_local_register[playerid][13] = CreatePlayerTextDraw(playerid, 291.000000, 208.000000, "__");
	PlayerTextDrawFont(playerid, mobile_local_register[playerid][13], 1);
	PlayerTextDrawLetterSize(playerid, mobile_local_register[playerid][13], 0.291666, 1.350000);
	PlayerTextDrawTextSize(playerid, mobile_local_register[playerid][13], 400.000000, 17.000000);
	PlayerTextDrawSetOutline(playerid, mobile_local_register[playerid][13], 0);
	PlayerTextDrawSetShadow(playerid, mobile_local_register[playerid][13], 0);
	PlayerTextDrawAlignment(playerid, mobile_local_register[playerid][13], 1);
	PlayerTextDrawColor(playerid, mobile_local_register[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, mobile_local_register[playerid][13], 255);
	PlayerTextDrawBoxColor(playerid, mobile_local_register[playerid][13], 0);
	PlayerTextDrawUseBox(playerid, mobile_local_register[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, mobile_local_register[playerid][13], 1);
	PlayerTextDrawSetSelectable(playerid, mobile_local_register[playerid][13], 0);

	return 1;
} */