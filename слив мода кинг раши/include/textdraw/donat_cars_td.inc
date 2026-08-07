    donat_cars_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 167.9998, 118.7406, "perfect:donat_cars_background_prptxd"); // Background
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][0], 299.2402, 237.0809);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][0], 0);

	donat_cars_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 250.7333, 317.0664, "perfect:donat_cars_buy_prptxd"); // Buy
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][1], 60.4099, 21.0799);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][1], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][1], true);

	donat_cars_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 320.5375, 317.0664, "perfect:donat_cars_exit_prptxd"); // Exit
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][2], 60.4099, 21.0799);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][2], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][2], true);

	donat_cars_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 179.4998, 214.7480, "perfect:donat_cars_left_prptxd"); // Left
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][3], 9.0000, 23.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][3], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][3], true);

	donat_cars_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 442.5997, 214.6629, "perfect:donat_cars_right_prptxd"); // Right
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][4], 9.0000, 23.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][4], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][4], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][4], true);

	donat_cars_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 222.3666, 204.9185, "Tesla Model S"); // Car 1
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][5], 0.1383, 0.6998);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][5], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][5], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][5], 0);

	donat_cars_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 284.6705, 204.9185, "BMW_M8_COMPETITION"); // Car 2
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][6], 0.1383, 0.6998);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][6], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][6], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][6], 0);

	donat_cars_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 346.7676, 204.9185, "BMW_M8_COMPETITION"); // Car 3
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][7], 0.1383, 0.6998);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][7], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][7], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][7], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][7], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][7], 0);

	donat_cars_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 409.0714, 204.9185, "BMW_M8_COMPETITION"); // Car 4
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][8], 0.1383, 0.6998);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][8], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][8], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][8], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][8], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][8], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][8], 0);

	donat_cars_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 222.3666, 288.4236, "BMW_M8_COMPETITION"); // Car 5
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][9], 0.1383, 0.6998);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][9], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][9], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][9], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][9], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][9], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][9], 0);

	donat_cars_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 284.6705, 288.4236, "BMW_M8_COMPETITION"); // Car 6
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][10], 0.1383, 0.6998);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][10], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][10], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][10], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][10], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][10], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][10], 0);

	donat_cars_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 346.7676, 288.4236, "BMW_M8_COMPETITION"); // Car 7
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][11], 0.1383, 0.6998);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][11], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][11], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][11], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][11], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][11], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][11], 0);

	donat_cars_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 409.0714, 288.4236, "BMW_M8_COMPETITION"); // Car 8
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][12], 0.1383, 0.6998);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][12], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][12], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][12], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][12], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][12], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][12], 0);

	donat_cars_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 222.3666, 219.2194, "ÉEHA:_500P"); // Price 1
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][13], 0.1378, 0.7287);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][13], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][13], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][13], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][13], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][13], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][13], 0);

	donat_cars_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 284.6705, 219.2194, "ÉEHA:_500P"); // Price 2
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][14], 0.1378, 0.7287);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][14], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][14], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][14], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][14], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][14], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][14], 0);

	donat_cars_PTD[playerid][15] = CreatePlayerTextDraw(playerid, 346.7676, 219.2194, "ÉEHA:_500P"); // Price 3
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][15], 0.1378, 0.7287);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][15], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][15], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][15], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][15], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][15], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][15], 0);

	donat_cars_PTD[playerid][16] = CreatePlayerTextDraw(playerid, 409.0714, 219.2194, "ÉEHA:_500P"); // Price 4
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][16], 0.1378, 0.7287);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][16], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][16], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][16], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][16], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][16], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][16], 0);

	donat_cars_PTD[playerid][17] = CreatePlayerTextDraw(playerid, 222.3666, 302.7243, "ÉEHA:_500P"); // Price 5
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][17], 0.1378, 0.7287);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][17], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][17], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][17], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][17], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][17], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][17], 0);

	donat_cars_PTD[playerid][18] = CreatePlayerTextDraw(playerid, 284.6705, 302.7243, "ÉEHA:_500P"); // Price 6
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][18], 0.1378, 0.7287);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][18], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][18], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][18], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][18], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][18], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][18], 0);

	donat_cars_PTD[playerid][19] = CreatePlayerTextDraw(playerid, 346.7676, 302.7244, "ÉEHA:_500P"); // Price 7
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][19], 0.1378, 0.7287);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][19], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][19], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][19], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][19], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][19], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][19], 0);

	donat_cars_PTD[playerid][20] = CreatePlayerTextDraw(playerid, 409.0714, 302.7244, "ÉEHA:_500P"); // Price 8
	PlayerTextDrawLetterSize(playerid, donat_cars_PTD[playerid][20], 0.1378, 0.7287);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][20], 2);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][20], -1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][20], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][20], 1);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][20], 1);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][20], 0);

	donat_cars_PTD[playerid][21] = CreatePlayerTextDraw(playerid, 198.3999, 149.2221, ""); // Vehicle 1
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][21], 56.0000, 54.1198);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][21], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][21], -1);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][21], 5);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][21], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][21], 0);
	PlayerTextDrawSetPreviewModel(playerid, donat_cars_PTD[playerid][21], 411);
	PlayerTextDrawSetPreviewRot(playerid, donat_cars_PTD[playerid][21], -10.0000, 0.0000, -35.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, donat_cars_PTD[playerid][21], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][21], 0xFFFFFF00);

	donat_cars_PTD[playerid][22] = CreatePlayerTextDraw(playerid, 260.1000, 149.2221, ""); // Vehicle 2
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][22], 56.0000, 54.1198);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][22], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][22], -1);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][22], 5);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][22], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][22], 0);
	PlayerTextDrawSetPreviewModel(playerid, donat_cars_PTD[playerid][22], 411);
	PlayerTextDrawSetPreviewRot(playerid, donat_cars_PTD[playerid][22], -10.0000, 0.0000, -35.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, donat_cars_PTD[playerid][22], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][22], 0xFFFFFF00);

	donat_cars_PTD[playerid][23] = CreatePlayerTextDraw(playerid, 322.8666, 149.6369, ""); // Vehicle 3
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][23], 56.0000, 54.1198);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][23], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][23], -1);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][23], 5);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][23], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][23], 0);
	PlayerTextDrawSetPreviewModel(playerid, donat_cars_PTD[playerid][23], 411);
	PlayerTextDrawSetPreviewRot(playerid, donat_cars_PTD[playerid][23], -10.0000, 0.0000, -35.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, donat_cars_PTD[playerid][23], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][23], 0xFFFFFF00);

	donat_cars_PTD[playerid][24] = CreatePlayerTextDraw(playerid, 384.5668, 149.6371, ""); // Vehicle 4
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][24], 56.0000, 54.1198);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][24], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][24], -1);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][24], 5);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][24], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][24], 0);
	PlayerTextDrawSetPreviewModel(playerid, donat_cars_PTD[playerid][24], 411);
	PlayerTextDrawSetPreviewRot(playerid, donat_cars_PTD[playerid][24], -10.0000, 0.0000, -35.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, donat_cars_PTD[playerid][24], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][24], 0xFFFFFF00);

	donat_cars_PTD[playerid][25] = CreatePlayerTextDraw(playerid, 197.7332, 232.0260, ""); // Vehicle 5
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][25], 56.0000, 54.1198);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][25], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][25], -1);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][25], 5);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][25], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][25], 0);
	PlayerTextDrawSetPreviewModel(playerid, donat_cars_PTD[playerid][25], 411);
	PlayerTextDrawSetPreviewRot(playerid, donat_cars_PTD[playerid][25], -10.0000, 0.0000, -35.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, donat_cars_PTD[playerid][25], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][25], 0xFFFFFF00);

	donat_cars_PTD[playerid][26] = CreatePlayerTextDraw(playerid, 259.4334, 232.0260, ""); // Vehicle 6
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][26], 56.0000, 54.1198);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][26], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][26], -1);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][26], 5);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][26], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][26], 0);
	PlayerTextDrawSetPreviewModel(playerid, donat_cars_PTD[playerid][26], 411);
	PlayerTextDrawSetPreviewRot(playerid, donat_cars_PTD[playerid][26], -10.0000, 0.0000, -35.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, donat_cars_PTD[playerid][26], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][26], 0xFFFFFF00);

	donat_cars_PTD[playerid][27] = CreatePlayerTextDraw(playerid, 322.2000, 232.4407, ""); // Vehicle 7
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][27], 56.0000, 54.1198);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][27], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][27], -1);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][27], 5);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][27], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][27], 0);
	PlayerTextDrawSetPreviewModel(playerid, donat_cars_PTD[playerid][27], 411);
	PlayerTextDrawSetPreviewRot(playerid, donat_cars_PTD[playerid][27], -10.0000, 0.0000, -35.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, donat_cars_PTD[playerid][27], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][27], 0xFFFFFF00);

	donat_cars_PTD[playerid][28] = CreatePlayerTextDraw(playerid, 383.9002, 232.4409, ""); // Vehicle 8
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][28], 56.0000, 54.1198);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][28], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][28], -1);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][28], 5);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][28], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][28], 0);
	PlayerTextDrawSetPreviewModel(playerid, donat_cars_PTD[playerid][28], 411);
	PlayerTextDrawSetPreviewRot(playerid, donat_cars_PTD[playerid][28], -10.0000, 0.0000, -35.0000, 1.0000);
	PlayerTextDrawSetPreviewVehCol(playerid, donat_cars_PTD[playerid][28], 1, 1);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][28], 0xFFFFFF00);

	donat_cars_PTD[playerid][29] = CreatePlayerTextDraw(playerid, 195.6665, 152.9259, "LD_SPAC:white"); // Box 1
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][29], 54.0000, 63.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][29], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][29], -256);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][29], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][29], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][29], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][29], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][29], true);

	donat_cars_PTD[playerid][30] = CreatePlayerTextDraw(playerid, 258.0000, 153.3406, "LD_SPAC:white"); // Box 2
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][30], 54.0000, 63.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][30], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][30], -256);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][30], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][30], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][30], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][30], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][30], true);

	donat_cars_PTD[playerid][31] = CreatePlayerTextDraw(playerid, 320.0333, 153.7554, "LD_SPAC:white"); // Box 3
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][31], 54.0000, 63.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][31], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][31], -256);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][31], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][31], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][31], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][31], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][31], true);

	donat_cars_PTD[playerid][32] = CreatePlayerTextDraw(playerid, 382.3666, 154.1703, "LD_SPAC:white"); // Box 4
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][32], 54.0000, 63.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][32], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][32], -256);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][32], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][32], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][32], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][32], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][32], true);

	donat_cars_PTD[playerid][33] = CreatePlayerTextDraw(playerid, 195.6667, 235.7156, "LD_SPAC:white"); // Box 5
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][33], 54.0000, 63.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][33], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][33], -256);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][33], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][33], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][33], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][33], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][33], true);

	donat_cars_PTD[playerid][34] = CreatePlayerTextDraw(playerid, 257.9999, 236.1304, "LD_SPAC:white"); // Box 6
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][34], 54.0000, 63.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][34], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][34], -256);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][34], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][34], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][34], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][34], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][34], true);

	donat_cars_PTD[playerid][35] = CreatePlayerTextDraw(playerid, 320.0332, 236.5451, "LD_SPAC:white"); // Box 7
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][35], 54.0000, 63.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][35], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][35], -256);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][35], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][35], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][35], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][35], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][35], true);

	donat_cars_PTD[playerid][36] = CreatePlayerTextDraw(playerid, 382.3666, 236.9600, "LD_SPAC:white"); // Box 8
	PlayerTextDrawTextSize(playerid, donat_cars_PTD[playerid][36], 54.0000, 63.0000);
	PlayerTextDrawAlignment(playerid, donat_cars_PTD[playerid][36], 1);
	PlayerTextDrawColor(playerid, donat_cars_PTD[playerid][36], -256);
	PlayerTextDrawBackgroundColor(playerid, donat_cars_PTD[playerid][36], 255);
	PlayerTextDrawFont(playerid, donat_cars_PTD[playerid][36], 4);
	PlayerTextDrawSetProportional(playerid, donat_cars_PTD[playerid][36], 0);
	PlayerTextDrawSetShadow(playerid, donat_cars_PTD[playerid][36], 0);
	PlayerTextDrawSetSelectable(playerid, donat_cars_PTD[playerid][36], true);