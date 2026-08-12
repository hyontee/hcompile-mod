	TextDrawSpeedP[playerid][0] = CreatePlayerTextDraw(playerid, 336.7329, 392.9113, "INFERNUS"); // Name Car
	PlayerTextDrawLetterSize(playerid, TextDrawSpeedP[playerid][0], 0.1550, 0.5960);
	PlayerTextDrawAlignment(playerid, TextDrawSpeedP[playerid][0], 2);
	PlayerTextDrawColor(playerid, TextDrawSpeedP[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, TextDrawSpeedP[playerid][0], 255);
	PlayerTextDrawFont(playerid, TextDrawSpeedP[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, TextDrawSpeedP[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, TextDrawSpeedP[playerid][0], 0);
 
	TextDrawSpeedP[playerid][1] = CreatePlayerTextDraw(playerid, 289.4625, 404.1889, "LD_Beat:Chit"); // Engine
	PlayerTextDrawTextSize(playerid, TextDrawSpeedP[playerid][1], 5.0000, 6.3400);
	PlayerTextDrawAlignment(playerid, TextDrawSpeedP[playerid][1], 1);
	PlayerTextDrawColor(playerid, TextDrawSpeedP[playerid][1], 8388863);
	PlayerTextDrawBackgroundColor(playerid, TextDrawSpeedP[playerid][1], 255);
	PlayerTextDrawFont(playerid, TextDrawSpeedP[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, TextDrawSpeedP[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, TextDrawSpeedP[playerid][1], 0);
 
	TextDrawSpeedP[playerid][2] = CreatePlayerTextDraw(playerid, 354.6666, 404.1889, "LD_Beat:Chit"); // Lock
	PlayerTextDrawTextSize(playerid, TextDrawSpeedP[playerid][2], 5.0000, 6.5398);
	PlayerTextDrawAlignment(playerid, TextDrawSpeedP[playerid][2], 1);
	PlayerTextDrawColor(playerid, TextDrawSpeedP[playerid][2], -347323649);
	PlayerTextDrawBackgroundColor(playerid, TextDrawSpeedP[playerid][2], 255);
	PlayerTextDrawFont(playerid, TextDrawSpeedP[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, TextDrawSpeedP[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, TextDrawSpeedP[playerid][2], 0);
 
	TextDrawSpeedP[playerid][3] = CreatePlayerTextDraw(playerid, 323.8646, 404.1889, "LD_Beat:Chit"); // Lamp
	PlayerTextDrawTextSize(playerid, TextDrawSpeedP[playerid][3], 5.1399, 6.1599);
	PlayerTextDrawAlignment(playerid, TextDrawSpeedP[playerid][3], 1);
	PlayerTextDrawColor(playerid, TextDrawSpeedP[playerid][3], -347323649);
	PlayerTextDrawBackgroundColor(playerid, TextDrawSpeedP[playerid][3], 255);
	PlayerTextDrawFont(playerid, TextDrawSpeedP[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, TextDrawSpeedP[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, TextDrawSpeedP[playerid][3], 0);
 
	TextDrawSpeedP[playerid][4] = CreatePlayerTextDraw(playerid, 262.1000, 398.3482, "100"); // Speed
	PlayerTextDrawLetterSize(playerid, TextDrawSpeedP[playerid][4], 0.4059, 1.8322);
	PlayerTextDrawAlignment(playerid, TextDrawSpeedP[playerid][4], 2);
	PlayerTextDrawColor(playerid, TextDrawSpeedP[playerid][4], -1);
	PlayerTextDrawSetOutline(playerid, TextDrawSpeedP[playerid][4], 1);
	PlayerTextDrawBackgroundColor(playerid, TextDrawSpeedP[playerid][4], 901119311);
	PlayerTextDrawFont(playerid, TextDrawSpeedP[playerid][4], 3);
	PlayerTextDrawSetProportional(playerid, TextDrawSpeedP[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, TextDrawSpeedP[playerid][4], 0);
 
	TextDrawSpeedP[playerid][5] = CreatePlayerTextDraw(playerid, 262.0997, 427.8641, "00000_k?"); // Mileage
	PlayerTextDrawLetterSize(playerid, TextDrawSpeedP[playerid][5], 0.1351, 0.8574);
	PlayerTextDrawAlignment(playerid, TextDrawSpeedP[playerid][5], 2);
	PlayerTextDrawColor(playerid, TextDrawSpeedP[playerid][5], -1);
	PlayerTextDrawBackgroundColor(playerid, TextDrawSpeedP[playerid][5], 255);
	PlayerTextDrawFont(playerid, TextDrawSpeedP[playerid][5], 2);
	PlayerTextDrawSetProportional(playerid, TextDrawSpeedP[playerid][5], 1);
	PlayerTextDrawSetShadow(playerid, TextDrawSpeedP[playerid][5], 0);
 
	TextDrawSpeedP[playerid][6] = CreatePlayerTextDraw(playerid, 298.3331, 421.1368, "fuel:_100%"); // Gas Station
	PlayerTextDrawLetterSize(playerid, TextDrawSpeedP[playerid][6], 0.1366, 0.6915);
	PlayerTextDrawAlignment(playerid, TextDrawSpeedP[playerid][6], 1);
	PlayerTextDrawColor(playerid, TextDrawSpeedP[playerid][6], -1);
	PlayerTextDrawBackgroundColor(playerid, TextDrawSpeedP[playerid][6], 255);
	PlayerTextDrawFont(playerid, TextDrawSpeedP[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid, TextDrawSpeedP[playerid][6], 1);
	PlayerTextDrawSetShadow(playerid, TextDrawSpeedP[playerid][6], 0);
 
	TextDrawSpeedP[playerid][7] = CreatePlayerTextDraw(playerid, 326.7329, 421.9521, "LD_SPAC:white"); // Fuel
	PlayerTextDrawTextSize(playerid, TextDrawSpeedP[playerid][7], 0.0000, 3.0000);  //52
	PlayerTextDrawAlignment(playerid, TextDrawSpeedP[playerid][7], 1);
	PlayerTextDrawColor(playerid, TextDrawSpeedP[playerid][7], COLOR_SERVER);
	PlayerTextDrawBackgroundColor(playerid, TextDrawSpeedP[playerid][7], 255);
	PlayerTextDrawFont(playerid, TextDrawSpeedP[playerid][7], 4);
	PlayerTextDrawSetProportional(playerid, TextDrawSpeedP[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid, TextDrawSpeedP[playerid][7], 0);
	
	//speedometr
	gSpeedometr[playerid][0] = CreatePlayerTextDraw(playerid, 531.500000, 379.166748, "100 KM/H");
	PlayerTextDrawLetterSize(playerid, gSpeedometr[playerid][0], 0.216000, 0.940832);
	PlayerTextDrawAlignment(playerid, gSpeedometr[playerid][0], 1);
	PlayerTextDrawColor(playerid, gSpeedometr[playerid][0], COLOR_SERVER);
	PlayerTextDrawSetShadow(playerid, gSpeedometr[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid, gSpeedometr[playerid][0], 0);
	PlayerTextDrawBackgroundColor(playerid, gSpeedometr[playerid][0], 51);
	PlayerTextDrawFont(playerid, gSpeedometr[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, gSpeedometr[playerid][0], 1);

	gSpeedometr[playerid][1] = CreatePlayerTextDraw(playerid, 528.000000, 389.083221, "100 L");
	PlayerTextDrawLetterSize(playerid, gSpeedometr[playerid][1], 0.216000, 0.940832);
	PlayerTextDrawAlignment(playerid, gSpeedometr[playerid][1], 1);
	PlayerTextDrawColor(playerid, gSpeedometr[playerid][1], COLOR_SERVER);
	PlayerTextDrawSetShadow(playerid, gSpeedometr[playerid][1], 0);
	PlayerTextDrawSetOutline(playerid, gSpeedometr[playerid][1], 0);
	PlayerTextDrawBackgroundColor(playerid, gSpeedometr[playerid][1], 51);
	PlayerTextDrawFont(playerid, gSpeedometr[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, gSpeedometr[playerid][1], 1);

	gSpeedometr[playerid][2] = CreatePlayerTextDraw(playerid, 537.000000, 398.416748, "0.401 KM");
	PlayerTextDrawLetterSize(playerid, gSpeedometr[playerid][2], 0.216000, 0.940832);
	PlayerTextDrawAlignment(playerid, gSpeedometr[playerid][2], 1);
	PlayerTextDrawColor(playerid, gSpeedometr[playerid][2], COLOR_SERVER);
	PlayerTextDrawSetShadow(playerid, gSpeedometr[playerid][2], 0);
	PlayerTextDrawSetOutline(playerid, gSpeedometr[playerid][2], 0);
	PlayerTextDrawBackgroundColor(playerid, gSpeedometr[playerid][2], 51);
	PlayerTextDrawFont(playerid, gSpeedometr[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, gSpeedometr[playerid][2], 1);

	gSpeedometr[playerid][3] = CreatePlayerTextDraw(playerid, 537.000000, 407.750061, "100");
	PlayerTextDrawLetterSize(playerid, gSpeedometr[playerid][3], 0.216000, 0.940832);
	PlayerTextDrawAlignment(playerid, gSpeedometr[playerid][3], 1);
	PlayerTextDrawColor(playerid, gSpeedometr[playerid][3], COLOR_SERVER);
	PlayerTextDrawSetShadow(playerid, gSpeedometr[playerid][3], 0);
	PlayerTextDrawSetOutline(playerid, gSpeedometr[playerid][3], 0);
	PlayerTextDrawBackgroundColor(playerid, gSpeedometr[playerid][3], 51);
	PlayerTextDrawFont(playerid, gSpeedometr[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, gSpeedometr[playerid][3], 1);

	gSpeedometr[playerid][4] = CreatePlayerTextDraw(playerid, 601.000000, 379.749877, "LD_BEAT:chit");//индикатор двигателя Engine
	PlayerTextDrawLetterSize(playerid, gSpeedometr[playerid][4], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gSpeedometr[playerid][4], 10.000000, 11.666646);
	PlayerTextDrawAlignment(playerid, gSpeedometr[playerid][4], 1);
	PlayerTextDrawColor(playerid, gSpeedometr[playerid][4], -16776961);//При выключенном состоянии код цвета -16776961 при включенном 16711935
	PlayerTextDrawSetShadow(playerid, gSpeedometr[playerid][4], 0);
	PlayerTextDrawSetOutline(playerid, gSpeedometr[playerid][4], 0);
	PlayerTextDrawFont(playerid, gSpeedometr[playerid][4], 4);

	gSpeedometr[playerid][5] = CreatePlayerTextDraw(playerid, 601.000000, 392.000183, "LD_BEAT:chit");//индикатор фар Light
	PlayerTextDrawLetterSize(playerid, gSpeedometr[playerid][5], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gSpeedometr[playerid][5], 10.000000, 11.666665);
	PlayerTextDrawAlignment(playerid, gSpeedometr[playerid][5], 1);
	PlayerTextDrawColor(playerid, gSpeedometr[playerid][5], -16776961);//При выключенном состоянии код цвета -16776961 при включенном 16711935
	PlayerTextDrawSetShadow(playerid, gSpeedometr[playerid][5], 0);
	PlayerTextDrawSetOutline(playerid, gSpeedometr[playerid][5], 0);
	PlayerTextDrawFont(playerid, gSpeedometr[playerid][5], 4);

	gSpeedometr[playerid][6] = CreatePlayerTextDraw(playerid, 601.000000, 403.666839, "LD_BEAT:chit");//индикатор дверей Doors
	PlayerTextDrawLetterSize(playerid, gSpeedometr[playerid][6], 0.000000, 0.000000);
	PlayerTextDrawTextSize(playerid, gSpeedometr[playerid][6], 10.000000, 11.666671);
	PlayerTextDrawAlignment(playerid, gSpeedometr[playerid][6], 1);
	PlayerTextDrawColor(playerid, gSpeedometr[playerid][6], 16711935);//При выключенном состоянии код цвета -16776961 при включенном 16711935
	PlayerTextDrawSetShadow(playerid, gSpeedometr[playerid][6], 0);
	PlayerTextDrawSetOutline(playerid, gSpeedometr[playerid][6], 0);
	PlayerTextDrawFont(playerid, gSpeedometr[playerid][6], 4);
	
    sk_info_text[playerid] = CreatePlayerTextDraw(playerid, 347.5664, 420.6369, "$55000"); // пусто
	PlayerTextDrawLetterSize     (playerid, sk_info_text[playerid], 0.1414, 1.0398);
	PlayerTextDrawTextSize       (playerid, sk_info_text[playerid], 1051.0000, 0.0000);
	PlayerTextDrawAlignment      (playerid, sk_info_text[playerid], 2);
	PlayerTextDrawColor          (playerid, sk_info_text[playerid], -1);
	PlayerTextDrawBackgroundColor(playerid, sk_info_text[playerid], -1);
	PlayerTextDrawFont           (playerid, sk_info_text[playerid], 2);
	PlayerTextDrawSetProportional(playerid, sk_info_text[playerid], 1);
	PlayerTextDrawSetShadow      (playerid, sk_info_text[playerid], 0);

	DmArenaTextDraw[playerid] = CreatePlayerTextDraw(playerid, 520.00, 100.00, "~b~Kills: ~g~0~n~~b~Deatch: ~g~Kills~n~~b~Deatch:~g~ 0 km");
	PlayerTextDrawAlignment(playerid, DmArenaTextDraw[playerid], 0);
	PlayerTextDrawBackgroundColor(playerid, DmArenaTextDraw[playerid], 0x000000ff);
	PlayerTextDrawFont(playerid, DmArenaTextDraw[playerid], 3);
	PlayerTextDrawLetterSize(playerid, DmArenaTextDraw[playerid], 0.399999, 1.00);
	PlayerTextDrawColor(playerid, DmArenaTextDraw[playerid], 0x0054c6ff);
	PlayerTextDrawSetOutline(playerid, DmArenaTextDraw[playerid], 1);
	PlayerTextDrawSetProportional(playerid, DmArenaTextDraw[playerid], 1);
	PlayerTextDrawSetShadow(playerid, DmArenaTextDraw[playerid], 1);



	gOldSpeedometr[playerid][0] = CreatePlayerTextDraw(playerid,557.217968, 427.333312, "usebox");
	PlayerTextDrawLetterSize(playerid,gOldSpeedometr[playerid][0], 0.000000, -5.601846);
	PlayerTextDrawTextSize(playerid,gOldSpeedometr[playerid][0], 384.998535, 0.000000);
	PlayerTextDrawAlignment(playerid,gOldSpeedometr[playerid][0], 1);
	PlayerTextDrawColor(playerid,gOldSpeedometr[playerid][0], 0);
	PlayerTextDrawUseBox(playerid,gOldSpeedometr[playerid][0], true);
	PlayerTextDrawBoxColor(playerid,gOldSpeedometr[playerid][0], 102);
	PlayerTextDrawSetShadow(playerid,gOldSpeedometr[playerid][0], 0);
	PlayerTextDrawSetOutline(playerid,gOldSpeedometr[playerid][0], 0);
	PlayerTextDrawFont(playerid,gOldSpeedometr[playerid][0], 0);

	gOldSpeedometr[playerid][1] = CreatePlayerTextDraw(playerid,352.000000, 356.000000, "_~n~_");
	PlayerTextDrawBackgroundColor(playerid,gOldSpeedometr[playerid][1], 255);
	PlayerTextDrawFont(playerid,gOldSpeedometr[playerid][1], 1);
	PlayerTextDrawLetterSize(playerid,gOldSpeedometr[playerid][1], 0.500000, 1.000000);
	PlayerTextDrawColor(playerid,gOldSpeedometr[playerid][1], 943208449);
	PlayerTextDrawSetOutline(playerid,gOldSpeedometr[playerid][1], 0);
	
	gOldSpeedometr[playerid][2] = CreatePlayerTextDraw(playerid,401.054473, 394.333343, "_");
	PlayerTextDrawBackgroundColor(playerid,gOldSpeedometr[playerid][2], 96);
	PlayerTextDrawAlignment(playerid,gOldSpeedometr[playerid][2], 1);
	PlayerTextDrawLetterSize(playerid,gOldSpeedometr[playerid][2],0.496852, 1.716667);
	PlayerTextDrawFont(playerid,gOldSpeedometr[playerid][2],0);
	PlayerTextDrawColor(playerid,gOldSpeedometr[playerid][2], 208117759);
	PlayerTextDrawSetOutline(playerid,gOldSpeedometr[playerid][2],1);
	PlayerTextDrawSetProportional(playerid,gOldSpeedometr[playerid][2],1);
	PlayerTextDrawSetShadow(playerid,gOldSpeedometr[playerid][2],0);
	PlayerTextDrawHide(playerid, gOldSpeedometr[playerid][2]);
	
	gOldSpeedometr[playerid][3] = CreatePlayerTextDraw(playerid,476.017822, 389.083312, "_");
	PlayerTextDrawBackgroundColor(playerid,gOldSpeedometr[playerid][3], 80);
	PlayerTextDrawLetterSize(playerid,gOldSpeedometr[playerid][3],0.530584, 1.016667);
	PlayerTextDrawFont(playerid,gOldSpeedometr[playerid][3], 0);
	PlayerTextDrawColor(playerid,gOldSpeedometr[playerid][3], -1);
	PlayerTextDrawSetOutline(playerid,gOldSpeedometr[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid,gOldSpeedometr[playerid][3],1);
	PlayerTextDrawSetShadow(playerid,gOldSpeedometr[playerid][3],0);
	PlayerTextDrawShow(playerid, gOldSpeedometr[playerid][3]);
	
	gOldSpeedometr[playerid][4] = CreatePlayerTextDraw(playerid,488.199462, 405.416809, "_");
	PlayerTextDrawBackgroundColor(playerid,gOldSpeedometr[playerid][4], 255);
	PlayerTextDrawLetterSize(playerid,gOldSpeedometr[playerid][4],0.463586, 1.168333);
	PlayerTextDrawFont(playerid,gOldSpeedometr[playerid][4], 1);
	PlayerTextDrawColor(playerid,gOldSpeedometr[playerid][4], -16776961);
	PlayerTextDrawSetOutline(playerid,gOldSpeedometr[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid,gOldSpeedometr[playerid][4],1);
	PlayerTextDrawSetShadow(playerid,gOldSpeedometr[playerid][4],0);
	PlayerTextDrawHide(playerid, gOldSpeedometr[playerid][4]);
	
	gOldSpeedometr[playerid][5] = CreatePlayerTextDraw(playerid,431.976928, 396.666717, "KM/H");
	PlayerTextDrawBackgroundColor(playerid,gOldSpeedometr[playerid][5], 128);
	PlayerTextDrawLetterSize(playerid,gOldSpeedometr[playerid][5],0.278052, 1.185832);
	PlayerTextDrawFont(playerid,gOldSpeedometr[playerid][5], 2);
	PlayerTextDrawColor(playerid,gOldSpeedometr[playerid][5], 208117604);
	PlayerTextDrawSetOutline(playerid,gOldSpeedometr[playerid][5], 1);
	PlayerTextDrawSetProportional(playerid,gOldSpeedometr[playerid][5],1);
	PlayerTextDrawSetShadow(playerid,gOldSpeedometr[playerid][5],0);
	PlayerTextDrawHide(playerid, gOldSpeedometr[playerid][5]);
	
	gOldSpeedometr[playerid][6] = CreatePlayerTextDraw(playerid,508.814239, 387.333526, "FUEL");
	PlayerTextDrawBackgroundColor(playerid,gOldSpeedometr[playerid][6], 255);
	PlayerTextDrawFont(playerid,gOldSpeedometr[playerid][6], 2);
	PlayerTextDrawLetterSize(playerid,gOldSpeedometr[playerid][6], 0.301010, 1.308333);
	PlayerTextDrawColor(playerid,gOldSpeedometr[playerid][6], -2147483393);
	PlayerTextDrawSetOutline(playerid,gOldSpeedometr[playerid][6], 1);
	PlayerTextDrawSetProportional(playerid,gOldSpeedometr[playerid][6], 1);
	PlayerTextDrawHide(playerid, gOldSpeedometr[playerid][6]);
	
	gOldSpeedometr[playerid][7] = CreatePlayerTextDraw(playerid,438.067504, 410.083374, "MAX");
	PlayerTextDrawLetterSize(playerid,gOldSpeedometr[playerid][7], 0.187159, 0.713333);
	PlayerTextDrawAlignment(playerid,gOldSpeedometr[playerid][7], 1);
	PlayerTextDrawColor(playerid,gOldSpeedometr[playerid][7], 255);
	PlayerTextDrawBackgroundColor(playerid,gOldSpeedometr[playerid][7], 51);
	PlayerTextDrawFont(playerid,gOldSpeedometr[playerid][7], 1);
	PlayerTextDrawSetProportional(playerid,gOldSpeedometr[playerid][7], 1);
	PlayerTextDrawSetOutline(playerid,gOldSpeedometr[playerid][7], 0);
	PlayerTextDrawSetShadow(playerid,gOldSpeedometr[playerid][7],0);