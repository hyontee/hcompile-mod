	/*

			Выбор скина при регистрации
				
	*/

	td_regskins[0] = TextDrawCreate(242.5664, 417.5036, "ld_spac:white"); // пусто
	TextDrawTextSize(td_regskins[0], 150.0000, 24.0000);
	TextDrawAlignment(td_regskins[0], 1);
	TextDrawColor(td_regskins[0], color_box);
	TextDrawBackgroundColor(td_regskins[0], 255);
	TextDrawFont(td_regskins[0], 4);
	TextDrawSetProportional(td_regskins[0], 0);
	TextDrawSetShadow(td_regskins[0], 0);

	td_regskins[1] = TextDrawCreate(384.8330, 414.3294, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[1], 16.0000, 20.0000);
	TextDrawAlignment(td_regskins[1], 1);
	TextDrawColor(td_regskins[1], color_box);
	TextDrawBackgroundColor(td_regskins[1], 255);
	TextDrawFont(td_regskins[1], 4);
	TextDrawSetProportional(td_regskins[1], 0);
	TextDrawSetShadow(td_regskins[1], 0);

	td_regskins[2] = TextDrawCreate(384.8330, 424.8301, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[2], 16.0000, 20.0000);
	TextDrawAlignment(td_regskins[2], 1);
	TextDrawColor(td_regskins[2], color_box);
	TextDrawBackgroundColor(td_regskins[2], 255);
	TextDrawFont(td_regskins[2], 4);
	TextDrawSetProportional(td_regskins[2], 0);
	TextDrawSetShadow(td_regskins[2], 0);

	td_regskins[3] = TextDrawCreate(234.5664, 414.3146, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[3], 16.0000, 20.0000);
	TextDrawAlignment(td_regskins[3], 1);
	TextDrawColor(td_regskins[3], color_box);
	TextDrawBackgroundColor(td_regskins[3], 255);
	TextDrawFont(td_regskins[3], 4);
	TextDrawSetProportional(td_regskins[3], 0);
	TextDrawSetShadow(td_regskins[3], 0);

	td_regskins[4] = TextDrawCreate(234.5664, 424.8153, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[4], 16.0000, 20.0000);
	TextDrawAlignment(td_regskins[4], 1);
	TextDrawColor(td_regskins[4], color_box);
	TextDrawBackgroundColor(td_regskins[4], 255);
	TextDrawFont(td_regskins[4], 4);
	TextDrawSetProportional(td_regskins[4], 0);
	TextDrawSetShadow(td_regskins[4], 0);

	td_regskins[5] = TextDrawCreate(237.2664, 424.6296, "ld_spac:white"); // пусто
	TextDrawTextSize(td_regskins[5], 160.9705, 9.0797);
	TextDrawAlignment(td_regskins[5], 1);
	TextDrawColor(td_regskins[5], color_box);
	TextDrawBackgroundColor(td_regskins[5], 255);
	TextDrawFont(td_regskins[5], 4);
	TextDrawSetProportional(td_regskins[5], 0);
	TextDrawSetShadow(td_regskins[5], 0);

	td_regskins[6] = TextDrawCreate(371.6339, 423.5407, ">>"); // пусто
	TextDrawLetterSize(td_regskins[6], 0.1886, 1.2308);
	TextDrawTextSize(td_regskins[6], 15.0000, 21.0000);
	TextDrawAlignment(td_regskins[6], 2);
	TextDrawColor(td_regskins[6], color_box);
	TextDrawUseBox(td_regskins[6], 1);
	TextDrawBoxColor(td_regskins[6], color_textdraw);
	TextDrawBackgroundColor(td_regskins[6], 255);
	TextDrawFont(td_regskins[6], 1);
	TextDrawSetProportional(td_regskins[6], 1);
	TextDrawSetShadow(td_regskins[6], 0);
	TextDrawSetSelectable(td_regskins[6], true);

	td_regskins[7] = TextDrawCreate(349.6337, 418.3926, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[7], 19.0000, 21.2800);
	TextDrawAlignment(td_regskins[7], 1);
	TextDrawColor(td_regskins[7], color_textdraw);
	TextDrawBackgroundColor(td_regskins[7], 255);
	TextDrawFont(td_regskins[7], 4);
	TextDrawSetProportional(td_regskins[7], 0);
	TextDrawSetShadow(td_regskins[7], 0);

	td_regskins[8] = TextDrawCreate(373.3005, 418.4778, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[8], 19.0000, 21.2800);
	TextDrawAlignment(td_regskins[8], 1);
	TextDrawColor(td_regskins[8], color_textdraw);
	TextDrawBackgroundColor(td_regskins[8], 255);
	TextDrawFont(td_regskins[8], 4);
	TextDrawSetProportional(td_regskins[8], 0);
	TextDrawSetShadow(td_regskins[8], 0);

	td_regskins[9] = TextDrawCreate(284.9661, 418.8926, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[9], 19.0000, 21.2800);
	TextDrawAlignment(td_regskins[9], 1);
	TextDrawColor(td_regskins[9], color_textdraw);
	TextDrawBackgroundColor(td_regskins[9], 255);
	TextDrawFont(td_regskins[9], 4);
	TextDrawSetProportional(td_regskins[9], 0);
	TextDrawSetShadow(td_regskins[9], 0);

	td_regskins[10] = TextDrawCreate(316.7666, 424.0555, "SELECT"); // пусто
	TextDrawLetterSize(td_regskins[10], 0.2766, 1.2058);
	TextDrawTextSize(td_regskins[10], 15.0000, 43.0000);
	TextDrawAlignment(td_regskins[10], 2);
	TextDrawColor(td_regskins[10], color_box);
	TextDrawUseBox(td_regskins[10], 1);
	TextDrawBoxColor(td_regskins[10], color_textdraw);
	TextDrawBackgroundColor(td_regskins[10], 255);
	TextDrawFont(td_regskins[10], 1);
	TextDrawSetProportional(td_regskins[10], 1);
	TextDrawSetShadow(td_regskins[10], 0);
	TextDrawSetSelectable(td_regskins[10], true);

	td_regskins[11] = TextDrawCreate(330.2995, 418.9778, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[11], 19.0000, 21.2800);
	TextDrawAlignment(td_regskins[11], 1);
	TextDrawColor(td_regskins[11], color_textdraw);
	TextDrawBackgroundColor(td_regskins[11], 255);
	TextDrawFont(td_regskins[11], 4);
	TextDrawSetProportional(td_regskins[11], 0);
	TextDrawSetShadow(td_regskins[11], 0);

	td_regskins[12] = TextDrawCreate(263.9999, 423.9554, "<<"); // пусто
	TextDrawLetterSize(td_regskins[12], 0.1886, 1.2308);
	TextDrawTextSize(td_regskins[12], 15.0000, 20.0000);
	TextDrawAlignment(td_regskins[12], 2);
	TextDrawColor(td_regskins[12], color_box);
	TextDrawUseBox(td_regskins[12], 1);
	TextDrawBoxColor(td_regskins[12], color_textdraw);
	TextDrawBackgroundColor(td_regskins[12], 255);
	TextDrawFont(td_regskins[12], 1);
	TextDrawSetProportional(td_regskins[12], 1);
	TextDrawSetShadow(td_regskins[12], 0);
	TextDrawSetSelectable(td_regskins[12], true);

	td_regskins[13] = TextDrawCreate(242.9998, 418.8073, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[13], 19.0000, 21.2800);
	TextDrawAlignment(td_regskins[13], 1);
	TextDrawColor(td_regskins[13], color_textdraw);
	TextDrawBackgroundColor(td_regskins[13], 255);
	TextDrawFont(td_regskins[13], 4);
	TextDrawSetProportional(td_regskins[13], 0);
	TextDrawSetShadow(td_regskins[13], 0);

	td_regskins[14] = TextDrawCreate(266.6665, 418.8926, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[14], 19.0000, 21.2800);
	TextDrawAlignment(td_regskins[14], 1);
	TextDrawColor(td_regskins[14], color_textdraw);
	TextDrawBackgroundColor(td_regskins[14], 255);
	TextDrawFont(td_regskins[14], 4);
	TextDrawSetProportional(td_regskins[14], 0);
	TextDrawSetShadow(td_regskins[14], 0);

	td_regskins[15] = TextDrawCreate(394.4331, 429.4072, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[15], 3.0000, 4.0000);
	TextDrawAlignment(td_regskins[15], 1);
	TextDrawColor(td_regskins[15], color_textdraw);
	TextDrawBackgroundColor(td_regskins[15], 255);
	TextDrawFont(td_regskins[15], 4);
	TextDrawSetProportional(td_regskins[15], 0);
	TextDrawSetShadow(td_regskins[15], 0);

	td_regskins[16] = TextDrawCreate(242.3332, 417.5628, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[16], 3.0000, 4.0000);
	TextDrawAlignment(td_regskins[16], 1);
	TextDrawColor(td_regskins[16], color_textdraw);
	TextDrawBackgroundColor(td_regskins[16], 255);
	TextDrawFont(td_regskins[16], 4);
	TextDrawSetProportional(td_regskins[16], 0);
	TextDrawSetShadow(td_regskins[16], 0);

	td_regskins[17] = TextDrawCreate(237.6665, 422.9555, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[17], 3.0000, 4.0000);
	TextDrawAlignment(td_regskins[17], 1);
	TextDrawColor(td_regskins[17], color_textdraw);
	TextDrawBackgroundColor(td_regskins[17], 255);
	TextDrawFont(td_regskins[17], 4);
	TextDrawSetProportional(td_regskins[17], 0);
	TextDrawSetShadow(td_regskins[17], 0);

	td_regskins[18] = TextDrawCreate(239.3332, 419.2221, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[18], 3.0000, 4.0000);
	TextDrawAlignment(td_regskins[18], 1);
	TextDrawColor(td_regskins[18], color_textdraw);
	TextDrawBackgroundColor(td_regskins[18], 255);
	TextDrawFont(td_regskins[18], 4);
	TextDrawSetProportional(td_regskins[18], 0);
	TextDrawSetShadow(td_regskins[18], 0);

	td_regskins[19] = TextDrawCreate(391.3999, 436.6593, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[19], 3.0000, 4.0000);
	TextDrawAlignment(td_regskins[19], 1);
	TextDrawColor(td_regskins[19], color_textdraw);
	TextDrawBackgroundColor(td_regskins[19], 255);
	TextDrawFont(td_regskins[19], 4);
	TextDrawSetProportional(td_regskins[19], 0);
	TextDrawSetShadow(td_regskins[19], 0);

	td_regskins[20] = TextDrawCreate(393.6333, 433.7554, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_regskins[20], 3.0000, 4.0000);
	TextDrawAlignment(td_regskins[20], 1);
	TextDrawColor(td_regskins[20], color_textdraw);
	TextDrawBackgroundColor(td_regskins[20], 255);
	TextDrawFont(td_regskins[20], 4);
	TextDrawSetProportional(td_regskins[20], 0);
	TextDrawSetShadow(td_regskins[20], 0);

	td_regskins[21] = TextDrawCreate(237.3332, 420.4371, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(td_regskins[21], 161.0000, 21.0000);
	TextDrawAlignment(td_regskins[21], 1);
	TextDrawColor(td_regskins[21], color_particle);
	TextDrawBackgroundColor(td_regskins[21], 255);
	TextDrawFont(td_regskins[21], 4);
	TextDrawSetProportional(td_regskins[21], 0);
	TextDrawSetShadow(td_regskins[21], 0);

	/*

			car tuning
		
	*/
	
	td_tuning[0] = TextDrawCreate(255.5997, 400.7348, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[0], 118.0000, 26.0000);
	TextDrawAlignment(td_tuning[0], 1);
	TextDrawColor(td_tuning[0], color_black_box);
	TextDrawBackgroundColor(td_tuning[0], 255);
	TextDrawFont(td_tuning[0], 4);
	TextDrawSetProportional(td_tuning[0], 0);
	TextDrawSetShadow(td_tuning[0], 0);

	td_tuning[1] = TextDrawCreate(255.5997, 371.9331, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[1], 118.0000, 26.0000);
	TextDrawAlignment(td_tuning[1], 1);
	TextDrawColor(td_tuning[1], color_black_box);
	TextDrawBackgroundColor(td_tuning[1], 255);
	TextDrawFont(td_tuning[1], 4);
	TextDrawSetProportional(td_tuning[1], 0);
	TextDrawSetShadow(td_tuning[1], 0);

	td_tuning[2] = TextDrawCreate(367.6329, 369.4440, "ld_beat:chit"); // Tuning
	TextDrawTextSize(td_tuning[2], 13.0000, 16.0000);
	TextDrawAlignment(td_tuning[2], 1);
	TextDrawColor(td_tuning[2], color_black_box);
	TextDrawBackgroundColor(td_tuning[2], 255);
	TextDrawFont(td_tuning[2], 4);
	TextDrawSetProportional(td_tuning[2], 0);
	TextDrawSetShadow(td_tuning[2], 0);

	td_tuning[3] = TextDrawCreate(367.6329, 384.5451, "ld_beat:chit"); // Tuning
	TextDrawTextSize(td_tuning[3], 13.0000, 16.0000);
	TextDrawAlignment(td_tuning[3], 1);
	TextDrawColor(td_tuning[3], color_black_box);
	TextDrawBackgroundColor(td_tuning[3], 255);
	TextDrawFont(td_tuning[3], 4);
	TextDrawSetProportional(td_tuning[3], 0);
	TextDrawSetShadow(td_tuning[3], 0);

	td_tuning[4] = TextDrawCreate(248.7664, 369.3442, "ld_beat:chit"); // Tuning
	TextDrawTextSize(td_tuning[4], 13.0000, 16.0000);
	TextDrawAlignment(td_tuning[4], 1);
	TextDrawColor(td_tuning[4], color_black_box);
	TextDrawBackgroundColor(td_tuning[4], 255);
	TextDrawFont(td_tuning[4], 4);
	TextDrawSetProportional(td_tuning[4], 0);
	TextDrawSetShadow(td_tuning[4], 0);

	td_tuning[5] = TextDrawCreate(248.7664, 384.4450, "ld_beat:chit"); // Tuning
	TextDrawTextSize(td_tuning[5], 13.0000, 16.0000);
	TextDrawAlignment(td_tuning[5], 1);
	TextDrawColor(td_tuning[5], color_black_box);
	TextDrawBackgroundColor(td_tuning[5], 255);
	TextDrawFont(td_tuning[5], 4);
	TextDrawSetProportional(td_tuning[5], 0);
	TextDrawSetShadow(td_tuning[5], 0);

	td_tuning[6] = TextDrawCreate(250.7664, 377.2810, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[6], 127.6899, 14.0000);
	TextDrawAlignment(td_tuning[6], 1);
	TextDrawColor(td_tuning[6], color_black_box);
	TextDrawBackgroundColor(td_tuning[6], 255);
	TextDrawFont(td_tuning[6], 4);
	TextDrawSetProportional(td_tuning[6], 0);
	TextDrawSetShadow(td_tuning[6], 0);

	td_tuning[7] = TextDrawCreate(365.9328, 374.9223, "ld_beat:chit"); // Tuning
	TextDrawTextSize(td_tuning[7], 10.0000, 12.0000);
	TextDrawAlignment(td_tuning[7], 1);
	TextDrawColor(td_tuning[7], color_textdraw);
	TextDrawBackgroundColor(td_tuning[7], 255);
	TextDrawFont(td_tuning[7], 4);
	TextDrawSetProportional(td_tuning[7], 0);
	TextDrawSetShadow(td_tuning[7], 0);

	td_tuning[8] = TextDrawCreate(254.9996, 381.8034, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[8], 119.3298, 7.0000);
	TextDrawAlignment(td_tuning[8], 1);
	TextDrawColor(td_tuning[8], color_textdraw);
	TextDrawBackgroundColor(td_tuning[8], 255);
	TextDrawFont(td_tuning[8], 4);
	TextDrawSetProportional(td_tuning[8], 0);
	TextDrawSetShadow(td_tuning[8], 0);

	td_tuning[9] = TextDrawCreate(253.1994, 374.7221, "ld_beat:chit"); // Tuning
	TextDrawTextSize(td_tuning[9], 10.0000, 12.0000);
	TextDrawAlignment(td_tuning[9], 1);
	TextDrawColor(td_tuning[9], color_textdraw);
	TextDrawBackgroundColor(td_tuning[9], 255);
	TextDrawFont(td_tuning[9], 4);
	TextDrawSetProportional(td_tuning[9], 0);
	TextDrawSetShadow(td_tuning[9], 0);

	td_tuning[10] = TextDrawCreate(366.0328, 382.8226, "ld_beat:chit"); // Tuning
	TextDrawTextSize(td_tuning[10], 10.0000, 12.0000);
	TextDrawAlignment(td_tuning[10], 1);
	TextDrawColor(td_tuning[10], color_textdraw);
	TextDrawBackgroundColor(td_tuning[10], 255);
	TextDrawFont(td_tuning[10], 4);
	TextDrawSetProportional(td_tuning[10], 0);
	TextDrawSetShadow(td_tuning[10], 0);

	td_tuning[11] = TextDrawCreate(253.2993, 382.6224, "ld_beat:chit"); // Tuning
	TextDrawTextSize(td_tuning[11], 10.0000, 12.0000);
	TextDrawAlignment(td_tuning[11], 1);
	TextDrawColor(td_tuning[11], color_textdraw);
	TextDrawBackgroundColor(td_tuning[11], 255);
	TextDrawFont(td_tuning[11], 4);
	TextDrawSetProportional(td_tuning[11], 0);
	TextDrawSetShadow(td_tuning[11], 0);

	td_tuning[12] = TextDrawCreate(258.5997, 376.9255, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[12], 113.0000, 15.6899);
	TextDrawAlignment(td_tuning[12], 1);
	TextDrawColor(td_tuning[12], color_textdraw);
	TextDrawBackgroundColor(td_tuning[12], 255);
	TextDrawFont(td_tuning[12], 4);
	TextDrawSetProportional(td_tuning[12], 0);
	TextDrawSetShadow(td_tuning[12], 0);

	td_tuning[13] = TextDrawCreate(280.1997, 371.9331, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[13], 1.1799, 25.0000);
	TextDrawAlignment(td_tuning[13], 1);
	TextDrawColor(td_tuning[13], color_black_box);
	TextDrawBackgroundColor(td_tuning[13], 255);
	TextDrawFont(td_tuning[13], 4);
	TextDrawSetProportional(td_tuning[13], 0);
	TextDrawSetShadow(td_tuning[13], 0);

	td_tuning[14] = TextDrawCreate(348.1997, 372.3479, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[14], 1.1799, 25.0000);
	TextDrawAlignment(td_tuning[14], 1);
	TextDrawColor(td_tuning[14], color_black_box);
	TextDrawBackgroundColor(td_tuning[14], 255);
	TextDrawFont(td_tuning[14], 4);
	TextDrawSetProportional(td_tuning[14], 0);
	TextDrawSetShadow(td_tuning[14], 0);

	td_tuning[15] = TextDrawCreate(282.8327, 390.6849, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[15], 64.0000, 0.9599);
	TextDrawAlignment(td_tuning[15], 1);
	TextDrawColor(td_tuning[15], color_black_box);
	TextDrawBackgroundColor(td_tuning[15], 255);
	TextDrawFont(td_tuning[15], 4);
	TextDrawSetProportional(td_tuning[15], 0);
	TextDrawSetShadow(td_tuning[15], 0);

	td_tuning[16] = TextDrawCreate(350.5997, 390.6701, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[16], 25.0000, 1.0000);
	TextDrawAlignment(td_tuning[16], 1);
	TextDrawColor(td_tuning[16], color_black_box);
	TextDrawBackgroundColor(td_tuning[16], 255);
	TextDrawFont(td_tuning[16], 4);
	TextDrawSetProportional(td_tuning[16], 0);
	TextDrawSetShadow(td_tuning[16], 0);

	td_tuning[17] = TextDrawCreate(253.7666, 390.6701, "ld_spac:white"); // Tuning
	TextDrawTextSize(td_tuning[17], 25.0000, 1.0000);
	TextDrawAlignment(td_tuning[17], 1);
	TextDrawColor(td_tuning[17], color_black_box);
	TextDrawBackgroundColor(td_tuning[17], 255);
	TextDrawFont(td_tuning[17], 4);
	TextDrawSetProportional(td_tuning[17], 0);
	TextDrawSetShadow(td_tuning[17], 0);

	td_tuning[18] = TextDrawCreate(267.4996, 379.8554, "<<"); // Tuning
	TextDrawLetterSize(td_tuning[18], 0.1588, 1.0355);
	TextDrawTextSize(td_tuning[18], 10.0000, 24.0000);
	TextDrawAlignment(td_tuning[18], 2);
	TextDrawColor(td_tuning[18], color_black_box);
	TextDrawBackgroundColor(td_tuning[18], 255);
	TextDrawFont(td_tuning[18], 2);
	TextDrawSetProportional(td_tuning[18], 1);
	TextDrawSetShadow(td_tuning[18], 0);
	TextDrawSetSelectable(td_tuning[18], true);

	td_tuning[19] = TextDrawCreate(362.7326, 379.8554, ">>"); // Tuning
	TextDrawLetterSize(td_tuning[19], 0.1588, 1.0355);
	TextDrawTextSize(td_tuning[19], 10.0000, 24.0000);
	TextDrawAlignment(td_tuning[19], 2);
	TextDrawColor(td_tuning[19], color_black_box);
	TextDrawBackgroundColor(td_tuning[19], 255);
	TextDrawFont(td_tuning[19], 2);
	TextDrawSetProportional(td_tuning[19], 1);
	TextDrawSetShadow(td_tuning[19], 0);
	TextDrawSetSelectable(td_tuning[19], true);

	td_tuning[20] = TextDrawCreate(367.6329, 398.3460, "ld_beat:chit"); // Tuning Style
	TextDrawTextSize(td_tuning[20], 13.0000, 16.0000);
	TextDrawAlignment(td_tuning[20], 1);
	TextDrawColor(td_tuning[20], color_black_box);
	TextDrawBackgroundColor(td_tuning[20], 255);
	TextDrawFont(td_tuning[20], 4);
	TextDrawSetProportional(td_tuning[20], 0);
	TextDrawSetShadow(td_tuning[20], 0);

	td_tuning[21] = TextDrawCreate(367.6329, 413.3468, "ld_beat:chit"); // Tuning Style
	TextDrawTextSize(td_tuning[21], 13.0000, 16.0000);
	TextDrawAlignment(td_tuning[21], 1);
	TextDrawColor(td_tuning[21], color_black_box);
	TextDrawBackgroundColor(td_tuning[21], 255);
	TextDrawFont(td_tuning[21], 4);
	TextDrawSetProportional(td_tuning[21], 0);
	TextDrawSetShadow(td_tuning[21], 0);

	td_tuning[22] = TextDrawCreate(248.7664, 398.1459, "ld_beat:chit"); // Tuning Style
	TextDrawTextSize(td_tuning[22], 13.0000, 16.0000);
	TextDrawAlignment(td_tuning[22], 1);
	TextDrawColor(td_tuning[22], color_black_box);
	TextDrawBackgroundColor(td_tuning[22], 255);
	TextDrawFont(td_tuning[22], 4);
	TextDrawSetProportional(td_tuning[22], 0);
	TextDrawSetShadow(td_tuning[22], 0);

	td_tuning[23] = TextDrawCreate(248.7664, 413.2467, "ld_beat:chit"); // Tuning Style
	TextDrawTextSize(td_tuning[23], 13.0000, 16.0000);
	TextDrawAlignment(td_tuning[23], 1);
	TextDrawColor(td_tuning[23], color_black_box);
	TextDrawBackgroundColor(td_tuning[23], 255);
	TextDrawFont(td_tuning[23], 4);
	TextDrawSetProportional(td_tuning[23], 0);
	TextDrawSetShadow(td_tuning[23], 0);

	td_tuning[24] = TextDrawCreate(250.7664, 406.0830, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[24], 127.6899, 14.0000);
	TextDrawAlignment(td_tuning[24], 1);
	TextDrawColor(td_tuning[24], color_black_box);
	TextDrawBackgroundColor(td_tuning[24], 255);
	TextDrawFont(td_tuning[24], 4);
	TextDrawSetProportional(td_tuning[24], 0);
	TextDrawSetShadow(td_tuning[24], 0);

	td_tuning[25] = TextDrawCreate(365.8327, 403.9237, "ld_beat:chit"); // Tuning Style
	TextDrawTextSize(td_tuning[25], 10.0000, 12.0000);
	TextDrawAlignment(td_tuning[25], 1);
	TextDrawColor(td_tuning[25], color_textdraw);
	TextDrawBackgroundColor(td_tuning[25], 255);
	TextDrawFont(td_tuning[25], 4);
	TextDrawSetProportional(td_tuning[25], 0);
	TextDrawSetShadow(td_tuning[25], 0);

	td_tuning[26] = TextDrawCreate(254.9996, 410.6051, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[26], 119.3298, 7.0000);
	TextDrawAlignment(td_tuning[26], 1);
	TextDrawColor(td_tuning[26], color_textdraw);
	TextDrawBackgroundColor(td_tuning[26], 255);
	TextDrawFont(td_tuning[26], 4);
	TextDrawSetProportional(td_tuning[26], 0);
	TextDrawSetShadow(td_tuning[26], 0);

	td_tuning[27] = TextDrawCreate(253.2993, 403.9237, "ld_beat:chit"); // Tuning Style
	TextDrawTextSize(td_tuning[27], 10.0000, 12.0000);
	TextDrawAlignment(td_tuning[27], 1);
	TextDrawColor(td_tuning[27], color_textdraw);
	TextDrawBackgroundColor(td_tuning[27], 255);
	TextDrawFont(td_tuning[27], 4);
	TextDrawSetProportional(td_tuning[27], 0);
	TextDrawSetShadow(td_tuning[27], 0);

	td_tuning[28] = TextDrawCreate(365.9328, 411.3240, "ld_beat:chit"); // Tuning Style
	TextDrawTextSize(td_tuning[28], 10.0000, 12.0000);
	TextDrawAlignment(td_tuning[28], 1);
	TextDrawColor(td_tuning[28], color_textdraw);
	TextDrawBackgroundColor(td_tuning[28], 255);
	TextDrawFont(td_tuning[28], 4);
	TextDrawSetProportional(td_tuning[28], 0);
	TextDrawSetShadow(td_tuning[28], 0);

	td_tuning[29] = TextDrawCreate(253.2993, 411.2243, "ld_beat:chit"); // Tuning Style
	TextDrawTextSize(td_tuning[29], 10.0000, 12.0000);
	TextDrawAlignment(td_tuning[29], 1);
	TextDrawColor(td_tuning[29], color_textdraw);
	TextDrawBackgroundColor(td_tuning[29], 255);
	TextDrawFont(td_tuning[29], 4);
	TextDrawSetProportional(td_tuning[29], 0);
	TextDrawSetShadow(td_tuning[29], 0);

	td_tuning[30] = TextDrawCreate(258.5997, 405.7275, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[30], 113.0000, 15.6899);
	TextDrawAlignment(td_tuning[30], 1);
	TextDrawColor(td_tuning[30], color_textdraw);
	TextDrawBackgroundColor(td_tuning[30], 255);
	TextDrawFont(td_tuning[30], 4);
	TextDrawSetProportional(td_tuning[30], 0);
	TextDrawSetShadow(td_tuning[30], 0);

	td_tuning[31] = TextDrawCreate(280.1997, 400.7348, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[31], 1.1799, 25.0000);
	TextDrawAlignment(td_tuning[31], 1);
	TextDrawColor(td_tuning[31], color_black_box);
	TextDrawBackgroundColor(td_tuning[31], 255);
	TextDrawFont(td_tuning[31], 4);
	TextDrawSetProportional(td_tuning[31], 0);
	TextDrawSetShadow(td_tuning[31], 0);

	td_tuning[32] = TextDrawCreate(348.1997, 401.1495, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[32], 1.1799, 25.0000);
	TextDrawAlignment(td_tuning[32], 1);
	TextDrawColor(td_tuning[32], color_black_box);
	TextDrawBackgroundColor(td_tuning[32], 255);
	TextDrawFont(td_tuning[32], 4);
	TextDrawSetProportional(td_tuning[32], 0);
	TextDrawSetShadow(td_tuning[32], 0);

	td_tuning[33] = TextDrawCreate(282.8327, 419.4866, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[33], 64.0000, 0.9599);
	TextDrawAlignment(td_tuning[33], 1);
	TextDrawColor(td_tuning[33], color_black_box);
	TextDrawBackgroundColor(td_tuning[33], 255);
	TextDrawFont(td_tuning[33], 4);
	TextDrawSetProportional(td_tuning[33], 0);
	TextDrawSetShadow(td_tuning[33], 0);

	td_tuning[34] = TextDrawCreate(350.5997, 419.5718, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[34], 25.0000, 1.0000);
	TextDrawAlignment(td_tuning[34], 1);
	TextDrawColor(td_tuning[34], color_black_box);
	TextDrawBackgroundColor(td_tuning[34], 255);
	TextDrawFont(td_tuning[34], 4);
	TextDrawSetProportional(td_tuning[34], 0);
	TextDrawSetShadow(td_tuning[34], 0);

	td_tuning[35] = TextDrawCreate(253.7666, 419.4718, "ld_spac:white"); // Tuning Style
	TextDrawTextSize(td_tuning[35], 25.0000, 1.0000);
	TextDrawAlignment(td_tuning[35], 1);
	TextDrawColor(td_tuning[35], color_black_box);
	TextDrawBackgroundColor(td_tuning[35], 255);
	TextDrawFont(td_tuning[35], 4);
	TextDrawSetProportional(td_tuning[35], 0);
	TextDrawSetShadow(td_tuning[35], 0);

	td_tuning[36] = TextDrawCreate(267.5997, 408.6571, "<<"); // Tuning Style
	TextDrawLetterSize(td_tuning[36], 0.1588, 1.0355);
	TextDrawTextSize(td_tuning[36], 10.0000, 25.0000);
	TextDrawAlignment(td_tuning[36], 2);
	TextDrawColor(td_tuning[36], color_black_box);
	TextDrawBackgroundColor(td_tuning[36], 255);
	TextDrawFont(td_tuning[36], 2);
	TextDrawSetProportional(td_tuning[36], 1);
	TextDrawSetShadow(td_tuning[36], 0);
	TextDrawSetSelectable(td_tuning[36], true);

	td_tuning[37] = TextDrawCreate(362.7326, 408.6571, ">>"); // Tuning Style
	TextDrawLetterSize(td_tuning[37], 0.1588, 1.0355);
	TextDrawTextSize(td_tuning[37], 10.0000, 24.0000);
	TextDrawAlignment(td_tuning[37], 2);
	TextDrawColor(td_tuning[37], color_black_box);
	TextDrawBackgroundColor(td_tuning[37], 255);
	TextDrawFont(td_tuning[37], 2);
	TextDrawSetProportional(td_tuning[37], 1);
	TextDrawSetShadow(td_tuning[37], 0);
	TextDrawSetSelectable(td_tuning[37], true);

	td_tuning[38] = TextDrawCreate(257.7333, 361.3629, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tuning[38], 41.8400, 11.0000);
	TextDrawAlignment(td_tuning[38], 1);
	TextDrawColor(td_tuning[38], color_textdraw);
	TextDrawBackgroundColor(td_tuning[38], 255);
	TextDrawFont(td_tuning[38], 4);
	TextDrawSetProportional(td_tuning[38], 0);
	TextDrawSetShadow(td_tuning[38], 0);

	td_tuning[39] = TextDrawCreate(307.8000, 360.8629, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tuning[39], 65.0000, 11.0000);
	TextDrawAlignment(td_tuning[39], 1);
	TextDrawColor(td_tuning[39], color_textdraw);
	TextDrawBackgroundColor(td_tuning[39], 255);
	TextDrawFont(td_tuning[39], 4);
	TextDrawSetProportional(td_tuning[39], 0);
	TextDrawSetShadow(td_tuning[39], 0);

	td_tuning[40] = TextDrawCreate(256.7666, 357.4147, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[40], 6.0000, 7.0000);
	TextDrawAlignment(td_tuning[40], 1);
	TextDrawColor(td_tuning[40], color_textdraw);
	TextDrawBackgroundColor(td_tuning[40], 255);
	TextDrawFont(td_tuning[40], 4);
	TextDrawSetProportional(td_tuning[40], 0);
	TextDrawSetShadow(td_tuning[40], 0);

	td_tuning[41] = TextDrawCreate(294.4331, 357.5520, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[41], 6.0000, 7.0000);
	TextDrawAlignment(td_tuning[41], 1);
	TextDrawColor(td_tuning[41], color_textdraw);
	TextDrawBackgroundColor(td_tuning[41], 255);
	TextDrawFont(td_tuning[41], 4);
	TextDrawSetProportional(td_tuning[41], 0);
	TextDrawSetShadow(td_tuning[41], 0);

	td_tuning[42] = TextDrawCreate(260.5000, 358.7296, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tuning[42], 37.0000, 7.0000);
	TextDrawAlignment(td_tuning[42], 1);
	TextDrawColor(td_tuning[42], color_textdraw);
	TextDrawBackgroundColor(td_tuning[42], 255);
	TextDrawFont(td_tuning[42], 4);
	TextDrawSetProportional(td_tuning[42], 0);
	TextDrawSetShadow(td_tuning[42], 0);

	td_tuning[43] = TextDrawCreate(307.0339, 357.5148, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[43], 6.0000, 7.0000);
	TextDrawAlignment(td_tuning[43], 1);
	TextDrawColor(td_tuning[43], color_textdraw);
	TextDrawBackgroundColor(td_tuning[43], 255);
	TextDrawFont(td_tuning[43], 4);
	TextDrawSetProportional(td_tuning[43], 0);
	TextDrawSetShadow(td_tuning[43], 0);

	td_tuning[44] = TextDrawCreate(367.6672, 357.5148, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[44], 6.0000, 7.0000);
	TextDrawAlignment(td_tuning[44], 1);
	TextDrawColor(td_tuning[44], color_textdraw);
	TextDrawBackgroundColor(td_tuning[44], 255);
	TextDrawFont(td_tuning[44], 4);
	TextDrawSetProportional(td_tuning[44], 0);
	TextDrawSetShadow(td_tuning[44], 0);

	td_tuning[45] = TextDrawCreate(310.7330, 358.6592, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tuning[45], 60.0000, 14.0000);
	TextDrawAlignment(td_tuning[45], 1);
	TextDrawColor(td_tuning[45], color_textdraw);
	TextDrawBackgroundColor(td_tuning[45], 255);
	TextDrawFont(td_tuning[45], 4);
	TextDrawSetProportional(td_tuning[45], 0);
	TextDrawSetShadow(td_tuning[45], 0);

	td_tuning[46] = TextDrawCreate(250.3995, 370.4999, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[46], 7.0000, 8.0000);
	TextDrawAlignment(td_tuning[46], 1);
	TextDrawColor(td_tuning[46], color_textdraw);
	TextDrawBackgroundColor(td_tuning[46], 255);
	TextDrawFont(td_tuning[46], 4);
	TextDrawSetProportional(td_tuning[46], 0);
	TextDrawSetShadow(td_tuning[46], 0);

	td_tuning[47] = TextDrawCreate(372.5000, 370.6997, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[47], 7.0000, 8.0000);
	TextDrawAlignment(td_tuning[47], 1);
	TextDrawColor(td_tuning[47], color_textdraw);
	TextDrawBackgroundColor(td_tuning[47], 255);
	TextDrawFont(td_tuning[47], 4);
	TextDrawSetProportional(td_tuning[47], 0);
	TextDrawSetShadow(td_tuning[47], 0);

	td_tuning[48] = TextDrawCreate(253.4998, 371.7998, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tuning[48], 123.0000, 1.0000);
	TextDrawAlignment(td_tuning[48], 1);
	TextDrawColor(td_tuning[48], color_textdraw);
	TextDrawBackgroundColor(td_tuning[48], 255);
	TextDrawFont(td_tuning[48], 4);
	TextDrawSetProportional(td_tuning[48], 0);
	TextDrawSetShadow(td_tuning[48], 0);

	td_tuning[49] = TextDrawCreate(370.8999, 371.3999, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[49], 9.0000, 8.0000);
	TextDrawAlignment(td_tuning[49], 1);
	TextDrawColor(td_tuning[49], color_box);
	TextDrawBackgroundColor(td_tuning[49], 255);
	TextDrawFont(td_tuning[49], 4);
	TextDrawSetProportional(td_tuning[49], 0);
	TextDrawSetShadow(td_tuning[49], 0);

	td_tuning[50] = TextDrawCreate(249.9996, 371.2998, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[50], 9.0000, 8.0000);
	TextDrawAlignment(td_tuning[50], 1);
	TextDrawColor(td_tuning[50], color_box);
	TextDrawBackgroundColor(td_tuning[50], 255);
	TextDrawFont(td_tuning[50], 4);
	TextDrawSetProportional(td_tuning[50], 0);
	TextDrawSetShadow(td_tuning[50], 0);

	td_tuning[51] = TextDrawCreate(249.1665, 425.9335, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[51], 14.0000, 17.2299);
	TextDrawAlignment(td_tuning[51], 1);
	TextDrawColor(td_tuning[51], color_black_box);
	TextDrawBackgroundColor(td_tuning[51], 255);
	TextDrawFont(td_tuning[51], 4);
	TextDrawSetProportional(td_tuning[51], 0);
	TextDrawSetShadow(td_tuning[51], 0);

	td_tuning[52] = TextDrawCreate(367.1661, 425.9335, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tuning[52], 14.0000, 17.3199);
	TextDrawAlignment(td_tuning[52], 1);
	TextDrawColor(td_tuning[52], color_black_box);
	TextDrawBackgroundColor(td_tuning[52], 255);
	TextDrawFont(td_tuning[52], 4);
	TextDrawSetProportional(td_tuning[52], 0);
	TextDrawSetShadow(td_tuning[52], 0);

	td_tuning[53] = TextDrawCreate(256.1333, 428.8775, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tuning[53], 118.0000, 11.3599);
	TextDrawAlignment(td_tuning[53], 1);
	TextDrawColor(td_tuning[53], color_black_box);
	TextDrawBackgroundColor(td_tuning[53], 255);
	TextDrawFont(td_tuning[53], 4);
	TextDrawSetProportional(td_tuning[53], 0);
	TextDrawSetShadow(td_tuning[53], 0);

	td_tuning[54] = TextDrawCreate(315.5997, 429.7478, "SELECT"); // пусто
	TextDrawLetterSize(td_tuning[54], 0.1412, 0.9362);
	TextDrawTextSize(td_tuning[54], 10.0000, 39.0000);
	TextDrawAlignment(td_tuning[54], 2);
	TextDrawColor(td_tuning[54], color_textdraw);
	TextDrawBackgroundColor(td_tuning[54], 255);
	TextDrawFont(td_tuning[54], 2);
	TextDrawSetProportional(td_tuning[54], 1);
	TextDrawSetShadow(td_tuning[54], 0);
	TextDrawSetSelectable(td_tuning[54], true);

	td_tuning[55] = TextDrawCreate(269.2662, 429.7478, "BUY"); // пусто
	TextDrawLetterSize(td_tuning[55], 0.1412, 0.9362);
	TextDrawTextSize(td_tuning[55], 10.0000, 39.0000);
	TextDrawAlignment(td_tuning[55], 2);
	TextDrawColor(td_tuning[55], color_textdraw);
	TextDrawBackgroundColor(td_tuning[55], 255);
	TextDrawFont(td_tuning[55], 2);
	TextDrawSetProportional(td_tuning[55], 1);
	TextDrawSetShadow(td_tuning[55], 0);
	TextDrawSetSelectable(td_tuning[55], true);

	td_tuning[56] = TextDrawCreate(360.2662, 429.7481, "EXIT"); // пусто
	TextDrawLetterSize(td_tuning[56], 0.1412, 0.9362);
	TextDrawTextSize(td_tuning[56], 10.0000, 39.0000);
	TextDrawAlignment(td_tuning[56], 2);
	TextDrawColor(td_tuning[56], color_textdraw);
	TextDrawBackgroundColor(td_tuning[56], 255);
	TextDrawFont(td_tuning[56], 2);
	TextDrawSetProportional(td_tuning[56], 1);
	TextDrawSetShadow(td_tuning[56], 0);
	TextDrawSetSelectable(td_tuning[56], true);

	td_tuning[57] = TextDrawCreate(277.1333, 390.6849, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tuning[57], 75.0000, 1.0000);
	TextDrawAlignment(td_tuning[57], 1);
	TextDrawColor(td_tuning[57], color_box);
	TextDrawBackgroundColor(td_tuning[57], 255);
	TextDrawFont(td_tuning[57], 4);
	TextDrawSetProportional(td_tuning[57], 0);
	TextDrawSetShadow(td_tuning[57], 0);

	td_tuning[58] = TextDrawCreate(276.8656, 419.6072, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tuning[58], 75.0000, 1.0000);
	TextDrawAlignment(td_tuning[58], 1);
	TextDrawColor(td_tuning[58], color_black_box);
	TextDrawBackgroundColor(td_tuning[58], 255);
	TextDrawFont(td_tuning[58], 4);
	TextDrawSetProportional(td_tuning[58], 0);
	TextDrawSetShadow(td_tuning[58], 0);
	
	/*

			perfomance tuning

	*/

	td_performance[0] = TextDrawCreate(199.9665, 419.9515, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[0], 237.0000, 20.8798);
	TextDrawAlignment(td_performance[0], 1);
	TextDrawColor(td_performance[0], color_box);
	TextDrawBackgroundColor(td_performance[0], 255);
	TextDrawFont(td_performance[0], 4);
	TextDrawSetProportional(td_performance[0], 0);
	TextDrawSetShadow(td_performance[0], 0);

	td_performance[1] = TextDrawCreate(433.0997, 418.0924, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[1], 9.0000, 11.0000);
	TextDrawAlignment(td_performance[1], 1);
	TextDrawColor(td_performance[1], color_textdraw);
	TextDrawBackgroundColor(td_performance[1], 255);
	TextDrawFont(td_performance[1], 4);
	TextDrawSetProportional(td_performance[1], 0);
	TextDrawSetShadow(td_performance[1], 0);

	td_performance[2] = TextDrawCreate(432.9666, 431.5932, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[2], 9.0000, 11.0000);
	TextDrawAlignment(td_performance[2], 1);
	TextDrawColor(td_performance[2], color_box);
	TextDrawBackgroundColor(td_performance[2], 255);
	TextDrawFont(td_performance[2], 4);
	TextDrawSetProportional(td_performance[2], 0);
	TextDrawSetShadow(td_performance[2], 0);

	td_performance[3] = TextDrawCreate(195.3000, 418.0924, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[3], 9.0000, 11.0000);
	TextDrawAlignment(td_performance[3], 1);
	TextDrawColor(td_performance[3], color_textdraw);
	TextDrawBackgroundColor(td_performance[3], 255);
	TextDrawFont(td_performance[3], 4);
	TextDrawSetProportional(td_performance[3], 0);
	TextDrawSetShadow(td_performance[3], 0);

	td_performance[4] = TextDrawCreate(195.5000, 431.5932, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[4], 9.0000, 11.0000);
	TextDrawAlignment(td_performance[4], 1);
	TextDrawColor(td_performance[4], color_box);
	TextDrawBackgroundColor(td_performance[4], 255);
	TextDrawFont(td_performance[4], 4);
	TextDrawSetProportional(td_performance[4], 0);
	TextDrawSetShadow(td_performance[4], 0);

	td_performance[5] = TextDrawCreate(196.8332, 424.3998, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[5], 4.0000, 14.0000);
	TextDrawAlignment(td_performance[5], 1);
	TextDrawColor(td_performance[5], color_box);
	TextDrawBackgroundColor(td_performance[5], 255);
	TextDrawFont(td_performance[5], 4);
	TextDrawSetProportional(td_performance[5], 0);
	TextDrawSetShadow(td_performance[5], 0);

	td_performance[6] = TextDrawCreate(436.4999, 423.4814, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[6], 4.0000, 14.0000);
	TextDrawAlignment(td_performance[6], 1);
	TextDrawColor(td_performance[6], color_box);
	TextDrawBackgroundColor(td_performance[6], 255);
	TextDrawFont(td_performance[6], 4);
	TextDrawSetProportional(td_performance[6], 0);
	TextDrawSetShadow(td_performance[6], 0);

	td_performance[7] = TextDrawCreate(401.7073, 410.2961, "STABILITY"); // пусто
	TextDrawLetterSize(td_performance[7], 0.1659, 0.8988);
	TextDrawTextSize(td_performance[7], 0.0000, 37.0000);
	TextDrawAlignment(td_performance[7], 2);
	TextDrawColor(td_performance[7], color_box);
	TextDrawBackgroundColor(td_performance[7], 255);
	TextDrawFont(td_performance[7], 2);
	TextDrawSetProportional(td_performance[7], 1);
	TextDrawSetShadow(td_performance[7], 0);

	td_performance[8] = TextDrawCreate(419.1072, 407.5924, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[8], 6.0000, 7.3899);
	TextDrawAlignment(td_performance[8], 1);
	TextDrawColor(td_performance[8], color_textdraw);
	TextDrawBackgroundColor(td_performance[8], 255);
	TextDrawFont(td_performance[8], 4);
	TextDrawSetProportional(td_performance[8], 0);
	TextDrawSetShadow(td_performance[8], 0);

	td_performance[9] = TextDrawCreate(216.2330, 408.6809, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[9], 205.6495, 8.0000);
	TextDrawAlignment(td_performance[9], 1);
	TextDrawColor(td_performance[9], color_textdraw);
	TextDrawBackgroundColor(td_performance[9], 255);
	TextDrawFont(td_performance[9], 4);
	TextDrawSetProportional(td_performance[9], 0);
	TextDrawSetShadow(td_performance[9], 0);

	td_performance[10] = TextDrawCreate(235.9333, 410.2962, "ENGINE"); // пусто
	TextDrawLetterSize(td_performance[10], 0.1659, 0.8988);
	TextDrawTextSize(td_performance[10], 0.0000, 37.0000);
	TextDrawAlignment(td_performance[10], 2);
	TextDrawColor(td_performance[10], color_box);
	TextDrawBackgroundColor(td_performance[10], color_textdraw);
	TextDrawFont(td_performance[10], 2);
	TextDrawSetProportional(td_performance[10], 1);
	TextDrawSetShadow(td_performance[10], 0);

	td_performance[11] = TextDrawCreate(212.8665, 407.5927, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[11], 6.0000, 7.0000);
	TextDrawAlignment(td_performance[11], 1);
	TextDrawColor(td_performance[11], color_textdraw);
	TextDrawBackgroundColor(td_performance[11], 255);
	TextDrawFont(td_performance[11], 4);
	TextDrawSetProportional(td_performance[11], 0);
	TextDrawSetShadow(td_performance[11], 0);

	td_performance[12] = TextDrawCreate(213.7666, 411.7850, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[12], 210.4700, 8.2299);
	TextDrawAlignment(td_performance[12], 1);
	TextDrawColor(td_performance[12], color_textdraw);
	TextDrawBackgroundColor(td_performance[12], 255);
	TextDrawFont(td_performance[12], 4);
	TextDrawSetProportional(td_performance[12], 0);
	TextDrawSetShadow(td_performance[12], 0);

	td_performance[13] = TextDrawCreate(318.3023, 410.4963, "BRAKE"); // пусто
	TextDrawLetterSize(td_performance[13], 0.1659, 0.8988);
	TextDrawTextSize(td_performance[13], 0.0000, 37.0000);
	TextDrawAlignment(td_performance[13], 2);
	TextDrawColor(td_performance[13], color_box);
	TextDrawBackgroundColor(td_performance[13], 255);
	TextDrawFont(td_performance[13], 2);
	TextDrawSetProportional(td_performance[13], 1);
	TextDrawSetShadow(td_performance[13], 0);

	td_performance[14] = TextDrawCreate(200.2998, 419.8962, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[14], 237.0000, 1.0000);
	TextDrawAlignment(td_performance[14], 1);
	TextDrawColor(td_performance[14], color_textdraw);
	TextDrawBackgroundColor(td_performance[14], 255);
	TextDrawFont(td_performance[14], 4);
	TextDrawSetProportional(td_performance[14], 0);
	TextDrawSetShadow(td_performance[14], 0);

	td_performance[15] = TextDrawCreate(433.1997, 419.0924, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[15], 9.0000, 11.0000);
	TextDrawAlignment(td_performance[15], 1);
	TextDrawColor(td_performance[15], color_box);
	TextDrawBackgroundColor(td_performance[15], 255);
	TextDrawFont(td_performance[15], 4);
	TextDrawSetProportional(td_performance[15], 0);
	TextDrawSetShadow(td_performance[15], 0);

	td_performance[16] = TextDrawCreate(195.3999, 419.0924, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[16], 9.0000, 11.0000);
	TextDrawAlignment(td_performance[16], 1);
	TextDrawColor(td_performance[16], color_box);
	TextDrawBackgroundColor(td_performance[16], 255);
	TextDrawFont(td_performance[16], 4);
	TextDrawSetProportional(td_performance[16], 0);
	TextDrawSetShadow(td_performance[16], 0);

	td_performance[17] = TextDrawCreate(200.1667, 420.8406, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[17], 238.0000, 6.0000);
	TextDrawAlignment(td_performance[17], 1);
	TextDrawColor(td_performance[17], color_box);
	TextDrawBackgroundColor(td_performance[17], 255);
	TextDrawFont(td_performance[17], 4);
	TextDrawSetProportional(td_performance[17], 0);
	TextDrawSetShadow(td_performance[17], 0);

	td_performance[18] = TextDrawCreate(619.8040, 156.9147, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[18], 14.0000, 17.0000);
	TextDrawAlignment(td_performance[18], 1);
	TextDrawColor(td_performance[18], color_textdraw);
	TextDrawBackgroundColor(td_performance[18], 255);
	TextDrawFont(td_performance[18], 4);
	TextDrawSetProportional(td_performance[18], 0);
	TextDrawSetShadow(td_performance[18], 0);

	td_performance[19] = TextDrawCreate(548.8999, 156.9147, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[19], 14.0000, 17.0000);
	TextDrawAlignment(td_performance[19], 1);
	TextDrawColor(td_performance[19], color_textdraw);
	TextDrawBackgroundColor(td_performance[19], 255);
	TextDrawFont(td_performance[19], 4);
	TextDrawSetProportional(td_performance[19], 0);
	TextDrawSetShadow(td_performance[19], 0);

	td_performance[20] = TextDrawCreate(556.1333, 159.4776, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[20], 70.0000, 98.0000);
	TextDrawAlignment(td_performance[20], 1);
	TextDrawColor(td_performance[20], color_textdraw);
	TextDrawBackgroundColor(td_performance[20], 255);
	TextDrawFont(td_performance[20], 4);
	TextDrawSetProportional(td_performance[20], 0);
	TextDrawSetShadow(td_performance[20], 0);

	td_performance[21] = TextDrawCreate(619.8040, 158.0148, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[21], 14.0000, 17.0000);
	TextDrawAlignment(td_performance[21], 1);
	TextDrawColor(td_performance[21], color_box);
	TextDrawBackgroundColor(td_performance[21], 255);
	TextDrawFont(td_performance[21], 4);
	TextDrawSetProportional(td_performance[21], 0);
	TextDrawSetShadow(td_performance[21], 0);

	td_performance[22] = TextDrawCreate(548.8999, 158.0148, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[22], 14.0000, 17.0000);
	TextDrawAlignment(td_performance[22], 1);
	TextDrawColor(td_performance[22], color_box);
	TextDrawBackgroundColor(td_performance[22], 255);
	TextDrawFont(td_performance[22], 4);
	TextDrawSetProportional(td_performance[22], 0);
	TextDrawSetShadow(td_performance[22], 0);

	td_performance[23] = TextDrawCreate(556.1333, 160.5776, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[23], 70.0000, 98.0000);
	TextDrawAlignment(td_performance[23], 1);
	TextDrawColor(td_performance[23], color_box);
	TextDrawBackgroundColor(td_performance[23], 255);
	TextDrawFont(td_performance[23], 4);
	TextDrawSetProportional(td_performance[23], 0);
	TextDrawSetShadow(td_performance[23], 0);

	td_performance[24] = TextDrawCreate(551.3333, 167.0000, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[24], 80.0100, 86.0000);
	TextDrawAlignment(td_performance[24], 1);
	TextDrawColor(td_performance[24], color_box);
	TextDrawBackgroundColor(td_performance[24], 255);
	TextDrawFont(td_performance[24], 4);
	TextDrawSetProportional(td_performance[24], 0);
	TextDrawSetShadow(td_performance[24], 0);

	td_performance[25] = TextDrawCreate(619.8040, 244.5110, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[25], 14.0000, 17.0000);
	TextDrawAlignment(td_performance[25], 1);
	TextDrawColor(td_performance[25], color_box);
	TextDrawBackgroundColor(td_performance[25], 255);
	TextDrawFont(td_performance[25], 4);
	TextDrawSetProportional(td_performance[25], 0);
	TextDrawSetShadow(td_performance[25], 0);

	td_performance[26] = TextDrawCreate(548.9998, 244.4111, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[26], 14.0000, 17.0000);
	TextDrawAlignment(td_performance[26], 1);
	TextDrawColor(td_performance[26], color_box);
	TextDrawBackgroundColor(td_performance[26], 255);
	TextDrawFont(td_performance[26], 4);
	TextDrawSetProportional(td_performance[26], 0);
	TextDrawSetShadow(td_performance[26], 0);

	td_performance[27] = TextDrawCreate(556.1660, 173.0962, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[27], 70.0000, 20.0000);
	TextDrawAlignment(td_performance[27], 1);
	TextDrawColor(td_performance[27], color_black_box);
	TextDrawBackgroundColor(td_performance[27], 255);
	TextDrawFont(td_performance[27], 4);
	TextDrawSetProportional(td_performance[27], 0);
	TextDrawSetShadow(td_performance[27], 0);

	td_performance[28] = TextDrawCreate(590.9998, 174.9111, "ENGINE"); // пусто
	TextDrawLetterSize(td_performance[28], 0.2113, 0.8948);
	TextDrawTextSize(td_performance[28], 10.0000, 59.0000);
	TextDrawAlignment(td_performance[28], 2);
	TextDrawColor(td_performance[28], -1);
	TextDrawBackgroundColor(td_performance[28], 255);
	TextDrawFont(td_performance[28], 1);
	TextDrawSetProportional(td_performance[28], 1);
	TextDrawSetShadow(td_performance[28], 0);
	TextDrawSetSelectable(td_performance[28], true);

	td_performance[29] = TextDrawCreate(556.1660, 195.4777, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[29], 70.0000, 20.0000);
	TextDrawAlignment(td_performance[29], 1);
	TextDrawColor(td_performance[29], color_black_box);
	TextDrawBackgroundColor(td_performance[29], 255);
	TextDrawFont(td_performance[29], 4);
	TextDrawSetProportional(td_performance[29], 0);
	TextDrawSetShadow(td_performance[29], 0);

	td_performance[30] = TextDrawCreate(590.9998, 197.2924, "BRAKE"); // пусто
	TextDrawLetterSize(td_performance[30], 0.2113, 0.8948);
	TextDrawTextSize(td_performance[30], 10.0000, 59.0000);
	TextDrawAlignment(td_performance[30], 2);
	TextDrawColor(td_performance[30], -1);
	TextDrawBackgroundColor(td_performance[30], 255);
	TextDrawFont(td_performance[30], 1);
	TextDrawSetProportional(td_performance[30], 1);
	TextDrawSetShadow(td_performance[30], 0);
	TextDrawSetSelectable(td_performance[30], true);

	td_performance[31] = TextDrawCreate(556.2661, 217.6782, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[31], 70.0000, 20.0000);
	TextDrawAlignment(td_performance[31], 1);
	TextDrawColor(td_performance[31], color_black_box);
	TextDrawBackgroundColor(td_performance[31], 255);
	TextDrawFont(td_performance[31], 4);
	TextDrawSetProportional(td_performance[31], 0);
	TextDrawSetShadow(td_performance[31], 0);

	td_performance[32] = TextDrawCreate(590.9998, 219.4931, "STABILITY"); // пусто
	TextDrawLetterSize(td_performance[32], 0.2113, 0.8948);
	TextDrawTextSize(td_performance[32], 10.0000, 59.0000);
	TextDrawAlignment(td_performance[32], 2);
	TextDrawColor(td_performance[32], -1);
	TextDrawBackgroundColor(td_performance[32], 255);
	TextDrawFont(td_performance[32], 1);
	TextDrawSetProportional(td_performance[32], 1);
	TextDrawSetShadow(td_performance[32], 0);
	TextDrawSetSelectable(td_performance[32], true);

	td_performance[33] = TextDrawCreate(556.2998, 239.9335, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[33], 34.0000, 13.0000);
	TextDrawAlignment(td_performance[33], 1);
	TextDrawColor(td_performance[33], color_black_box);
	TextDrawBackgroundColor(td_performance[33], 255);
	TextDrawFont(td_performance[33], 4);
	TextDrawSetProportional(td_performance[33], 0);
	TextDrawSetShadow(td_performance[33], 0);

	td_performance[34] = TextDrawCreate(591.9326, 240.1483, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[34], 34.0000, 13.0000);
	TextDrawAlignment(td_performance[34], 1);
	TextDrawColor(td_performance[34], color_black_box);
	TextDrawBackgroundColor(td_performance[34], 255);
	TextDrawFont(td_performance[34], 4);
	TextDrawSetProportional(td_performance[34], 0);
	TextDrawSetShadow(td_performance[34], 0);

	td_performance[35] = TextDrawCreate(568.3332, 155.7148, "ld_spac:white"); // пусто
	TextDrawTextSize(td_performance[35], 45.0000, 9.6900);
	TextDrawAlignment(td_performance[35], 1);
	TextDrawColor(td_performance[35], color_black_box);
	TextDrawBackgroundColor(td_performance[35], 255);
	TextDrawFont(td_performance[35], 4);
	TextDrawSetProportional(td_performance[35], 0);
	TextDrawSetShadow(td_performance[35], 0);

	td_performance[36] = TextDrawCreate(561.7335, 153.3146, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[36], 12.0000, 15.0000);
	TextDrawAlignment(td_performance[36], 1);
	TextDrawColor(td_performance[36], color_black_box);
	TextDrawBackgroundColor(td_performance[36], 255);
	TextDrawFont(td_performance[36], 4);
	TextDrawSetProportional(td_performance[36], 0);
	TextDrawSetShadow(td_performance[36], 0);

	td_performance[37] = TextDrawCreate(607.7337, 153.3146, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_performance[37], 12.0000, 15.0000);
	TextDrawAlignment(td_performance[37], 1);
	TextDrawColor(td_performance[37], color_black_box);
	TextDrawBackgroundColor(td_performance[37], 255);
	TextDrawFont(td_performance[37], 4);
	TextDrawSetProportional(td_performance[37], 0);
	TextDrawSetShadow(td_performance[37], 0);

	td_performance[38] = TextDrawCreate(572.7664, 242.0924, "BUY"); // пусто
	TextDrawLetterSize(td_performance[38], 0.2169, 0.9114);
	TextDrawTextSize(td_performance[38], 10.0000, 59.0000);
	TextDrawAlignment(td_performance[38], 2);
	TextDrawColor(td_performance[38], -1);
	TextDrawBackgroundColor(td_performance[38], 255);
	TextDrawFont(td_performance[38], 1);
	TextDrawSetProportional(td_performance[38], 1);
	TextDrawSetShadow(td_performance[38], 0);
	TextDrawSetSelectable(td_performance[38], true);

	td_performance[39] = TextDrawCreate(609.2999, 242.0924, "EXIT"); // пусто
	TextDrawLetterSize(td_performance[39], 0.2169, 0.9114);
	TextDrawTextSize(td_performance[39], 10.0000, 59.0000);
	TextDrawAlignment(td_performance[39], 2);
	TextDrawColor(td_performance[39], -1);
	TextDrawBackgroundColor(td_performance[39], 255);
	TextDrawFont(td_performance[39], 1);
	TextDrawSetProportional(td_performance[39], 1);
	TextDrawSetShadow(td_performance[39], 0);
	TextDrawSetSelectable(td_performance[39], true);

	td_performance[40] = TextDrawCreate(590.6668, 157.4591, "PERFOMANCE"); // пусто
	TextDrawLetterSize(td_performance[40], 0.1639, 0.8201);
	TextDrawTextSize(td_performance[40], 0.0000, 43.0000);
	TextDrawAlignment(td_performance[40], 2);
	TextDrawColor(td_performance[40], -1061109505);
	TextDrawBackgroundColor(td_performance[40], 255);
	TextDrawFont(td_performance[40], 1);
	TextDrawSetProportional(td_performance[40], 1);
	TextDrawSetShadow(td_performance[40], 0);
	
	/*

			Skin shop

	*/
	
	td_skinshop[0] = TextDrawCreate(252.3666, 394.5629, "ld_spac:white"); // пусто
	TextDrawTextSize(td_skinshop[0], 124.0000, 45.0000);
	TextDrawAlignment(td_skinshop[0], 1);
	TextDrawColor(td_skinshop[0], color_box);
	TextDrawBackgroundColor(td_skinshop[0], 255);
	TextDrawFont(td_skinshop[0], 4);
	TextDrawSetProportional(td_skinshop[0], 0);
	TextDrawSetShadow(td_skinshop[0], 0);

	td_skinshop[1] = TextDrawCreate(368.0000, 391.1148, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[1], 17.0000, 21.0000);
	TextDrawAlignment(td_skinshop[1], 1);
	TextDrawColor(td_skinshop[1], color_box);
	TextDrawBackgroundColor(td_skinshop[1], 255);
	TextDrawFont(td_skinshop[1], 4);
	TextDrawSetProportional(td_skinshop[1], 0);
	TextDrawSetShadow(td_skinshop[1], 0);

	td_skinshop[2] = TextDrawCreate(368.0000, 422.2167, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[2], 17.0000, 21.0000);
	TextDrawAlignment(td_skinshop[2], 1);
	TextDrawColor(td_skinshop[2], color_box);
	TextDrawBackgroundColor(td_skinshop[2], 255);
	TextDrawFont(td_skinshop[2], 4);
	TextDrawSetProportional(td_skinshop[2], 0);
	TextDrawSetShadow(td_skinshop[2], 0);

	td_skinshop[3] = TextDrawCreate(243.1667, 391.0296, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[3], 17.0000, 21.0000);
	TextDrawAlignment(td_skinshop[3], 1);
	TextDrawColor(td_skinshop[3], color_box);
	TextDrawBackgroundColor(td_skinshop[3], 255);
	TextDrawFont(td_skinshop[3], 4);
	TextDrawSetProportional(td_skinshop[3], 0);
	TextDrawSetShadow(td_skinshop[3], 0);

	td_skinshop[4] = TextDrawCreate(243.1667, 422.1315, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[4], 17.0000, 21.0000);
	TextDrawAlignment(td_skinshop[4], 1);
	TextDrawColor(td_skinshop[4], color_box);
	TextDrawBackgroundColor(td_skinshop[4], 255);
	TextDrawFont(td_skinshop[4], 4);
	TextDrawSetProportional(td_skinshop[4], 0);
	TextDrawSetShadow(td_skinshop[4], 0);

	td_skinshop[5] = TextDrawCreate(245.9333, 401.0444, "ld_spac:white"); // пусто
	TextDrawTextSize(td_skinshop[5], 136.1898, 33.0000);
	TextDrawAlignment(td_skinshop[5], 1);
	TextDrawColor(td_skinshop[5], color_box);
	TextDrawBackgroundColor(td_skinshop[5], 255);
	TextDrawFont(td_skinshop[5], 4);
	TextDrawSetProportional(td_skinshop[5], 0);
	TextDrawSetShadow(td_skinshop[5], 0);

	td_skinshop[6] = TextDrawCreate(247.6666, 402.5148, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(td_skinshop[6], 139.0000, 37.0000);
	TextDrawAlignment(td_skinshop[6], 1);
	TextDrawColor(td_skinshop[6], color_particle);
	TextDrawBackgroundColor(td_skinshop[6], 255);
	TextDrawFont(td_skinshop[6], 4);
	TextDrawSetProportional(td_skinshop[6], 0);
	TextDrawSetShadow(td_skinshop[6], 0);

	td_skinshop[7] = TextDrawCreate(329.0000, 377.2033, "I"); // пусто
	TextDrawLetterSize(td_skinshop[7], 12.0680, 2.3466);
	TextDrawAlignment(td_skinshop[7], 2);
	TextDrawColor(td_skinshop[7], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[7], 255);
	TextDrawFont(td_skinshop[7], 1);
	TextDrawSetProportional(td_skinshop[7], 1);
	TextDrawSetShadow(td_skinshop[7], 0);

	td_skinshop[8] = TextDrawCreate(296.4350, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[8], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[8], 1);
	TextDrawColor(td_skinshop[8], color_box);
	TextDrawBackgroundColor(td_skinshop[8], 255);
	TextDrawFont(td_skinshop[8], 4);
	TextDrawSetProportional(td_skinshop[8], 0);
	TextDrawSetShadow(td_skinshop[8], 0);

	td_skinshop[9] = TextDrawCreate(291.1347, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[9], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[9], 1);
	TextDrawColor(td_skinshop[9], color_box);
	TextDrawBackgroundColor(td_skinshop[9], 255);
	TextDrawFont(td_skinshop[9], 4);
	TextDrawSetProportional(td_skinshop[9], 0);
	TextDrawSetShadow(td_skinshop[9], 0);

	td_skinshop[10] = TextDrawCreate(318.3363, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[10], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[10], 1);
	TextDrawColor(td_skinshop[10], color_box);
	TextDrawBackgroundColor(td_skinshop[10], 255);
	TextDrawFont(td_skinshop[10], 4);
	TextDrawSetProportional(td_skinshop[10], 0);
	TextDrawSetShadow(td_skinshop[10], 0);

	td_skinshop[11] = TextDrawCreate(313.0360, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[11], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[11], 1);
	TextDrawColor(td_skinshop[11], color_box);
	TextDrawBackgroundColor(td_skinshop[11], 255);
	TextDrawFont(td_skinshop[11], 4);
	TextDrawSetProportional(td_skinshop[11], 0);
	TextDrawSetShadow(td_skinshop[11], 0);

	td_skinshop[12] = TextDrawCreate(300.8999, 400.4703, "ld_spac:white"); // пусто
	TextDrawTextSize(td_skinshop[12], 5.0000, 14.4399);
	TextDrawAlignment(td_skinshop[12], 1);
	TextDrawColor(td_skinshop[12], color_box);
	TextDrawBackgroundColor(td_skinshop[12], 255);
	TextDrawFont(td_skinshop[12], 4);
	TextDrawSetProportional(td_skinshop[12], 0);
	TextDrawSetShadow(td_skinshop[12], 0);

	td_skinshop[13] = TextDrawCreate(322.2332, 400.5556, "ld_spac:white"); // пусто
	TextDrawTextSize(td_skinshop[13], 5.0000, 14.4399);
	TextDrawAlignment(td_skinshop[13], 1);
	TextDrawColor(td_skinshop[13], color_box);
	TextDrawBackgroundColor(td_skinshop[13], 255);
	TextDrawFont(td_skinshop[13], 4);
	TextDrawSetProportional(td_skinshop[13], 0);
	TextDrawSetShadow(td_skinshop[13], 0);

	td_skinshop[14] = TextDrawCreate(356.3377, 402.2850, ">>"); // пусто
	TextDrawLetterSize(td_skinshop[14], 0.1886, 1.2308);
	TextDrawTextSize(td_skinshop[14], 15.0000, 21.0000);
	TextDrawAlignment(td_skinshop[14], 2);
	TextDrawColor(td_skinshop[14], color_box);
	TextDrawUseBox(td_skinshop[14], 1);
	TextDrawBoxColor(td_skinshop[14], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[14], 255);
	TextDrawFont(td_skinshop[14], 1);
	TextDrawSetProportional(td_skinshop[14], 1);
	TextDrawSetShadow(td_skinshop[14], 0);
	TextDrawSetSelectable(td_skinshop[14], true);

	td_skinshop[15] = TextDrawCreate(334.3373, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[15], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[15], 1);
	TextDrawColor(td_skinshop[15], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[15], 255);
	TextDrawFont(td_skinshop[15], 4);
	TextDrawSetProportional(td_skinshop[15], 0);
	TextDrawSetShadow(td_skinshop[15], 0);

	td_skinshop[16] = TextDrawCreate(358.0043, 397.2221, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[16], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[16], 1);
	TextDrawColor(td_skinshop[16], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[16], 255);
	TextDrawFont(td_skinshop[16], 4);
	TextDrawSetProportional(td_skinshop[16], 0);
	TextDrawSetShadow(td_skinshop[16], 0);

	td_skinshop[17] = TextDrawCreate(313.2993, 416.4036, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[17], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[17], 1);
	TextDrawColor(td_skinshop[17], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[17], 255);
	TextDrawFont(td_skinshop[17], 4);
	TextDrawSetProportional(td_skinshop[17], 0);
	TextDrawSetShadow(td_skinshop[17], 0);

	td_skinshop[18] = TextDrawCreate(345.0998, 421.5665, "CANCEL"); // пусто
	TextDrawLetterSize(td_skinshop[18], 0.2766, 1.2058);
	TextDrawTextSize(td_skinshop[18], 15.0000, 43.0000);
	TextDrawAlignment(td_skinshop[18], 2);
	TextDrawColor(td_skinshop[18], color_box);
	TextDrawUseBox(td_skinshop[18], 1);
	TextDrawBoxColor(td_skinshop[18], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[18], 255);
	TextDrawFont(td_skinshop[18], 1);
	TextDrawSetProportional(td_skinshop[18], 1);
	TextDrawSetShadow(td_skinshop[18], 0);
	TextDrawSetSelectable(td_skinshop[18], true);

	td_skinshop[19] = TextDrawCreate(358.6327, 416.4888, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[19], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[19], 1);
	TextDrawColor(td_skinshop[19], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[19], 255);
	TextDrawFont(td_skinshop[19], 4);
	TextDrawSetProportional(td_skinshop[19], 0);
	TextDrawSetShadow(td_skinshop[19], 0);

	td_skinshop[20] = TextDrawCreate(272.9998, 402.1068, "<<"); // пусто
	TextDrawLetterSize(td_skinshop[20], 0.1886, 1.2308);
	TextDrawTextSize(td_skinshop[20], 15.0000, 20.0000);
	TextDrawAlignment(td_skinshop[20], 2);
	TextDrawColor(td_skinshop[20], color_box);
	TextDrawUseBox(td_skinshop[20], 1);
	TextDrawBoxColor(td_skinshop[20], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[20], 255);
	TextDrawFont(td_skinshop[20], 1);
	TextDrawSetProportional(td_skinshop[20], 1);
	TextDrawSetShadow(td_skinshop[20], 0);
	TextDrawSetSelectable(td_skinshop[20], true);

	td_skinshop[21] = TextDrawCreate(251.9998, 396.9588, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[21], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[21], 1);
	TextDrawColor(td_skinshop[21], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[21], 255);
	TextDrawFont(td_skinshop[21], 4);
	TextDrawSetProportional(td_skinshop[21], 0);
	TextDrawSetShadow(td_skinshop[21], 0);

	td_skinshop[22] = TextDrawCreate(275.6664, 397.0440, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[22], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[22], 1);
	TextDrawColor(td_skinshop[22], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[22], 255);
	TextDrawFont(td_skinshop[22], 4);
	TextDrawSetProportional(td_skinshop[22], 0);
	TextDrawSetShadow(td_skinshop[22], 0);

	td_skinshop[23] = TextDrawCreate(325.8377, 402.2999, ">"); // пусто
	TextDrawLetterSize(td_skinshop[23], 0.1886, 1.2308);
	TextDrawTextSize(td_skinshop[23], 15.0000, 16.0000);
	TextDrawAlignment(td_skinshop[23], 2);
	TextDrawColor(td_skinshop[23], color_textdraw);
	TextDrawUseBox(td_skinshop[23], 1);
	TextDrawBoxColor(td_skinshop[23], -6619392);
	TextDrawBackgroundColor(td_skinshop[23], 255);
	TextDrawFont(td_skinshop[23], 1);
	TextDrawSetProportional(td_skinshop[23], 1);
	TextDrawSetShadow(td_skinshop[23], 0);
	TextDrawSetSelectable(td_skinshop[23], true);

	td_skinshop[24] = TextDrawCreate(302.9377, 402.2999, "<"); // пусто
	TextDrawLetterSize(td_skinshop[24], 0.1886, 1.2308);
	TextDrawTextSize(td_skinshop[24], 15.0000, 16.0000);
	TextDrawAlignment(td_skinshop[24], 2);
	TextDrawColor(td_skinshop[24], color_textdraw);
	TextDrawUseBox(td_skinshop[24], 1);
	TextDrawBoxColor(td_skinshop[24], -6619392);
	TextDrawBackgroundColor(td_skinshop[24], 255);
	TextDrawFont(td_skinshop[24], 1);
	TextDrawSetProportional(td_skinshop[24], 1);
	TextDrawSetShadow(td_skinshop[24], 0);
	TextDrawSetSelectable(td_skinshop[24], true);

	td_skinshop[25] = TextDrawCreate(251.2328, 416.4036, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[25], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[25], 1);
	TextDrawColor(td_skinshop[25], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[25], 255);
	TextDrawFont(td_skinshop[25], 4);
	TextDrawSetProportional(td_skinshop[25], 0);
	TextDrawSetShadow(td_skinshop[25], 0);

	td_skinshop[26] = TextDrawCreate(283.0326, 421.5665, "SELECT"); // пусто
	TextDrawLetterSize(td_skinshop[26], 0.2766, 1.2058);
	TextDrawTextSize(td_skinshop[26], 15.0000, 43.0000);
	TextDrawAlignment(td_skinshop[26], 2);
	TextDrawColor(td_skinshop[26], color_box);
	TextDrawUseBox(td_skinshop[26], 1);
	TextDrawBoxColor(td_skinshop[26], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[26], 255);
	TextDrawFont(td_skinshop[26], 1);
	TextDrawSetProportional(td_skinshop[26], 1);
	TextDrawSetShadow(td_skinshop[26], 0);
	TextDrawSetSelectable(td_skinshop[26], true);

	td_skinshop[27] = TextDrawCreate(296.5655, 416.4888, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_skinshop[27], 19.0000, 21.2800);
	TextDrawAlignment(td_skinshop[27], 1);
	TextDrawColor(td_skinshop[27], color_textdraw);
	TextDrawBackgroundColor(td_skinshop[27], 255);
	TextDrawFont(td_skinshop[27], 4);
	TextDrawSetProportional(td_skinshop[27], 0);
	TextDrawSetShadow(td_skinshop[27], 0);
	
	/*
		action
	*/
	
	action_td[0] = TextDrawCreate(274.0001, 392.2740, "ld_spac:white"); // пусто
	TextDrawTextSize(action_td[0], 93.6499, 44.0000);
	TextDrawAlignment(action_td[0], 1);
	TextDrawColor(action_td[0], color_box);
	TextDrawBackgroundColor(action_td[0], 255);
	TextDrawFont(action_td[0], 4);
	TextDrawSetProportional(action_td[0], 0);
	TextDrawSetShadow(action_td[0], 0);

	action_td[1] = TextDrawCreate(361.6667, 389.6703, "ld_beat:chit"); // пусто
	TextDrawTextSize(action_td[1], 13.0000, 15.0000);
	TextDrawAlignment(action_td[1], 1);
	TextDrawColor(action_td[1], color_box);
	TextDrawBackgroundColor(action_td[1], 255);
	TextDrawFont(action_td[1], 4);
	TextDrawSetProportional(action_td[1], 0);
	TextDrawSetShadow(action_td[1], 0);

	action_td[2] = TextDrawCreate(361.6667, 423.7724, "ld_beat:chit"); // пусто
	TextDrawTextSize(action_td[2], 13.0000, 15.0000);
	TextDrawAlignment(action_td[2], 1);
	TextDrawColor(action_td[2], color_box);
	TextDrawBackgroundColor(action_td[2], 255);
	TextDrawFont(action_td[2], 4);
	TextDrawSetProportional(action_td[2], 0);
	TextDrawSetShadow(action_td[2], 0);

	action_td[3] = TextDrawCreate(267.0001, 389.7851, "ld_beat:chit"); // пусто
	TextDrawTextSize(action_td[3], 13.0000, 15.0000);
	TextDrawAlignment(action_td[3], 1);
	TextDrawColor(action_td[3], color_box);
	TextDrawBackgroundColor(action_td[3], 255);
	TextDrawFont(action_td[3], 4);
	TextDrawSetProportional(action_td[3], 0);
	TextDrawSetShadow(action_td[3], 0);

	action_td[4] = TextDrawCreate(267.0001, 423.8872, "ld_beat:chit"); // пусто
	TextDrawTextSize(action_td[4], 13.0000, 15.0000);
	TextDrawAlignment(action_td[4], 1);
	TextDrawColor(action_td[4], color_box);
	TextDrawBackgroundColor(action_td[4], 255);
	TextDrawFont(action_td[4], 4);
	TextDrawSetProportional(action_td[4], 0);
	TextDrawSetShadow(action_td[4], 0);

	action_td[5] = TextDrawCreate(269.1999, 397.3665, "ld_spac:white"); // пусто
	TextDrawTextSize(action_td[5], 103.3800, 34.0000);
	TextDrawAlignment(action_td[5], 1);
	TextDrawColor(action_td[5], color_box);
	TextDrawBackgroundColor(action_td[5], 255);
	TextDrawFont(action_td[5], 4);
	TextDrawSetProportional(action_td[5], 0);
	TextDrawSetShadow(action_td[5], 0);

	action_td[6] = TextDrawCreate(268.9999, 391.7331, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(action_td[6], 106.0000, 23.0000);
	TextDrawAlignment(action_td[6], 1);
	TextDrawColor(action_td[6], color_particle);
	TextDrawBackgroundColor(action_td[6], 255);
	TextDrawFont(action_td[6], 4);
	TextDrawSetProportional(action_td[6], 0);
	TextDrawSetShadow(action_td[6], 0);

	action_td[7] = TextDrawCreate(267.6666, 440.7552, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(action_td[7], 106.0000, -26.0000);
	TextDrawAlignment(action_td[7], 1);
	TextDrawColor(action_td[7], color_particle);
	TextDrawBackgroundColor(action_td[7], 255);
	TextDrawFont(action_td[7], 4);
	TextDrawSetProportional(action_td[7], 0);
	TextDrawSetShadow(action_td[7], 0);

	action_td[8] = TextDrawCreate(320.3332, 412.2260, "PRESS_THIS_KEY"); // пусто
	TextDrawLetterSize(action_td[8], 0.1166, 0.8757);
	TextDrawAlignment(action_td[8], 2);
	TextDrawColor(action_td[8], color_box);
	TextDrawBackgroundColor(action_td[8], 255);
	TextDrawFont(action_td[8], 2);
	TextDrawSetProportional(action_td[8], 1);
	TextDrawSetShadow(action_td[8], 0);

	action_td[9] = TextDrawCreate(314.3332, 397.2518, "ld_beat:chit"); // пусто
	TextDrawTextSize(action_td[9], 3.0000, 4.0000);
	TextDrawAlignment(action_td[9], 1);
	TextDrawColor(action_td[9], color_textdraw);
	TextDrawBackgroundColor(action_td[9], 255);
	TextDrawFont(action_td[9], 4);
	TextDrawSetProportional(action_td[9], 0);
	TextDrawSetShadow(action_td[9], 0);

	action_td[10] = TextDrawCreate(323.6666, 408.8667, "ld_beat:chit"); // пусто
	TextDrawTextSize(action_td[10], 3.0000, 4.0000);
	TextDrawAlignment(action_td[10], 1);
	TextDrawColor(action_td[10], color_textdraw);
	TextDrawBackgroundColor(action_td[10], 255);
	TextDrawFont(action_td[10], 4);
	TextDrawSetProportional(action_td[10], 0);
	TextDrawSetShadow(action_td[10], 0);

	action_td[11] = TextDrawCreate(313.3332, 400.5704, "ld_beat:chit"); // пусто
	TextDrawTextSize(action_td[11], 2.0000, 2.0000);
	TextDrawAlignment(action_td[11], 1);
	TextDrawColor(action_td[11], color_textdraw);
	TextDrawBackgroundColor(action_td[11], 255);
	TextDrawFont(action_td[11], 4);
	TextDrawSetProportional(action_td[11], 0);
	TextDrawSetShadow(action_td[11], 0);

	action_td[12] = TextDrawCreate(325.6665, 407.2074, "ld_beat:chit"); // пусто
	TextDrawTextSize(action_td[12], 2.0000, 2.0000);
	TextDrawAlignment(action_td[12], 1);
	TextDrawColor(action_td[12], color_textdraw);
	TextDrawBackgroundColor(action_td[12], 255);
	TextDrawFont(action_td[12], 4);
	TextDrawSetProportional(action_td[12], 0);
	TextDrawSetShadow(action_td[12], 0);

	action_td[13] = TextDrawCreate(273.6666, 423.3852, "ld_spac:white"); // пусто
	TextDrawTextSize(action_td[13], 94.0000, 9.0000);
	TextDrawAlignment(action_td[13], 1);
	TextDrawColor(action_td[13], color_textdraw);
	TextDrawBackgroundColor(action_td[13], 255);
	TextDrawFont(action_td[13], 4);
	TextDrawSetProportional(action_td[13], 0);
	TextDrawSetShadow(action_td[13], 0);

	action_td[14] = TextDrawCreate(274.4667, 424.2852, "ld_spac:white"); // пусто
	TextDrawTextSize(action_td[14], 92.2300, 7.0000);
	TextDrawAlignment(action_td[14], 1);
	TextDrawColor(action_td[14], color_box);
	TextDrawBackgroundColor(action_td[14], 255);
	TextDrawFont(action_td[14], 4);
	TextDrawSetProportional(action_td[14], 0);
	TextDrawSetShadow(action_td[14], 0);
	
	/*
		filling
	*/
	
	filling_td[0] = TextDrawCreate(237.7997, 175.7405, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[0], 152.0000, 68.0000);
	TextDrawAlignment(filling_td[0], 1);
	TextDrawColor(filling_td[0], color_box);
	TextDrawBackgroundColor(filling_td[0], 255);
	TextDrawFont(filling_td[0], 4);
	TextDrawSetProportional(filling_td[0], 0);
	TextDrawSetShadow(filling_td[0], 0);

	filling_td[1] = TextDrawCreate(234.5664, 231.6701, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[1], 20.0000, 24.0000);
	TextDrawAlignment(filling_td[1], 1);
	TextDrawColor(filling_td[1], color_box);
	TextDrawBackgroundColor(filling_td[1], 255);
	TextDrawFont(filling_td[1], 4);
	TextDrawSetProportional(filling_td[1], 0);
	TextDrawSetShadow(filling_td[1], 0);

	filling_td[2] = TextDrawCreate(373.2664, 231.6702, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[2], 20.0000, 24.0000);
	TextDrawAlignment(filling_td[2], 1);
	TextDrawColor(filling_td[2], color_box);
	TextDrawBackgroundColor(filling_td[2], 255);
	TextDrawFont(filling_td[2], 4);
	TextDrawSetProportional(filling_td[2], 0);
	TextDrawSetShadow(filling_td[2], 0);

	filling_td[3] = TextDrawCreate(245.3334, 238.4924, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[3], 138.0000, 13.2100);
	TextDrawAlignment(filling_td[3], 1);
	TextDrawColor(filling_td[3], color_box);
	TextDrawBackgroundColor(filling_td[3], 255);
	TextDrawFont(filling_td[3], 4);
	TextDrawSetProportional(filling_td[3], 0);
	TextDrawSetShadow(filling_td[3], 0);

	filling_td[4] = TextDrawCreate(328.2997, 186.4110, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[4], 50.0000, 13.0000);
	TextDrawAlignment(filling_td[4], 1);
	TextDrawColor(filling_td[4], color_textdraw);
	TextDrawBackgroundColor(filling_td[4], 255);
	TextDrawFont(filling_td[4], 4);
	TextDrawSetProportional(filling_td[4], 0);
	TextDrawSetShadow(filling_td[4], 0);

	filling_td[5] = TextDrawCreate(244.2999, 184.0221, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[5], 13.0000, 15.0000);
	TextDrawAlignment(filling_td[5], 1);
	TextDrawColor(filling_td[5], color_textdraw);
	TextDrawBackgroundColor(filling_td[5], 255);
	TextDrawFont(filling_td[5], 4);
	TextDrawSetProportional(filling_td[5], 0);
	TextDrawSetShadow(filling_td[5], 0);

	filling_td[6] = TextDrawCreate(251.4998, 186.4110, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[6], 77.0000, 13.0000);
	TextDrawAlignment(filling_td[6], 1);
	TextDrawColor(filling_td[6], color_textdraw);
	TextDrawBackgroundColor(filling_td[6], 255);
	TextDrawFont(filling_td[6], 4);
	TextDrawSetProportional(filling_td[6], 0);
	TextDrawSetShadow(filling_td[6], 0);

	filling_td[7] = TextDrawCreate(322.6331, 186.8110, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[7], 13.0000, 15.0000);
	TextDrawAlignment(filling_td[7], 1);
	TextDrawColor(filling_td[7], color_textdraw);
	TextDrawBackgroundColor(filling_td[7], 255);
	TextDrawFont(filling_td[7], 4);
	TextDrawSetProportional(filling_td[7], 0);
	TextDrawSetShadow(filling_td[7], 0);

	filling_td[8] = TextDrawCreate(246.3665, 192.3184, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[8], 79.0000, 7.0000);
	TextDrawAlignment(filling_td[8], 1);
	TextDrawColor(filling_td[8], color_textdraw);
	TextDrawBackgroundColor(filling_td[8], 255);
	TextDrawFont(filling_td[8], 4);
	TextDrawSetProportional(filling_td[8], 0);
	TextDrawSetShadow(filling_td[8], 0);

	filling_td[9] = TextDrawCreate(254.5997, 186.4110, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[9], 78.8699, 7.0000);
	TextDrawAlignment(filling_td[9], 1);
	TextDrawColor(filling_td[9], color_textdraw);
	TextDrawBackgroundColor(filling_td[9], 255);
	TextDrawFont(filling_td[9], 4);
	TextDrawSetProportional(filling_td[9], 0);
	TextDrawSetShadow(filling_td[9], 0);

	filling_td[10] = TextDrawCreate(245.6332, 185.6813, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[10], 11.0000, 13.0000);
	TextDrawAlignment(filling_td[10], 1);
	TextDrawColor(filling_td[10], color_box);
	TextDrawBackgroundColor(filling_td[10], 255);
	TextDrawFont(filling_td[10], 4);
	TextDrawSetProportional(filling_td[10], 0);
	TextDrawSetShadow(filling_td[10], 0);

	filling_td[11] = TextDrawCreate(323.0664, 187.4406, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[11], 11.0000, 13.0000);
	TextDrawAlignment(filling_td[11], 1);
	TextDrawColor(filling_td[11], color_box);
	TextDrawBackgroundColor(filling_td[11], 255);
	TextDrawFont(filling_td[11], 4);
	TextDrawSetProportional(filling_td[11], 0);
	TextDrawSetShadow(filling_td[11], 0);

	filling_td[12] = TextDrawCreate(251.2999, 187.7702, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[12], 80.9699, 7.0000);
	TextDrawAlignment(filling_td[12], 1);
	TextDrawColor(filling_td[12], color_box);
	TextDrawBackgroundColor(filling_td[12], 255);
	TextDrawFont(filling_td[12], 4);
	TextDrawSetProportional(filling_td[12], 0);
	TextDrawSetShadow(filling_td[12], 0);

	filling_td[13] = TextDrawCreate(247.5332, 191.5592, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[13], 80.9598, 6.6897);
	TextDrawAlignment(filling_td[13], 1);
	TextDrawColor(filling_td[13], color_box);
	TextDrawBackgroundColor(filling_td[13], 255);
	TextDrawFont(filling_td[13], 4);
	TextDrawSetProportional(filling_td[13], 0);
	TextDrawSetShadow(filling_td[13], 0);

	filling_td[14] = TextDrawCreate(372.1667, 189.4295, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[14], 11.0000, 12.0000);
	TextDrawAlignment(filling_td[14], 1);
	TextDrawColor(filling_td[14], color_textdraw);
	TextDrawBackgroundColor(filling_td[14], 255);
	TextDrawFont(filling_td[14], 4);
	TextDrawSetProportional(filling_td[14], 0);
	TextDrawSetShadow(filling_td[14], 0);

	filling_td[15] = TextDrawCreate(365.4331, 186.4258, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[15], 15.9498, 9.0000);
	TextDrawAlignment(filling_td[15], 1);
	TextDrawColor(filling_td[15], color_textdraw);
	TextDrawBackgroundColor(filling_td[15], 255);
	TextDrawFont(filling_td[15], 4);
	TextDrawSetProportional(filling_td[15], 0);
	TextDrawSetShadow(filling_td[15], 0);

	filling_td[16] = TextDrawCreate(287.8670, 207.7525, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[16], 20.0000, 10.0000);
	TextDrawAlignment(filling_td[16], 1);
	TextDrawColor(filling_td[16], color_textdraw);
	TextDrawBackgroundColor(filling_td[16], 255);
	TextDrawFont(filling_td[16], 4);
	TextDrawSetProportional(filling_td[16], 0);
	TextDrawSetShadow(filling_td[16], 0);

	filling_td[17] = TextDrawCreate(280.2003, 205.2489, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[17], 14.0000, 14.8899);
	TextDrawAlignment(filling_td[17], 1);
	TextDrawColor(filling_td[17], color_textdraw);
	TextDrawBackgroundColor(filling_td[17], 255);
	TextDrawFont(filling_td[17], 4);
	TextDrawSetProportional(filling_td[17], 0);
	TextDrawSetShadow(filling_td[17], 0);

	filling_td[18] = TextDrawCreate(301.2004, 205.2489, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[18], 14.0000, 14.8899);
	TextDrawAlignment(filling_td[18], 1);
	TextDrawColor(filling_td[18], color_textdraw);
	TextDrawBackgroundColor(filling_td[18], 255);
	TextDrawFont(filling_td[18], 4);
	TextDrawSetProportional(filling_td[18], 0);
	TextDrawSetShadow(filling_td[18], 0);

	filling_td[19] = TextDrawCreate(251.6333, 207.7525, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[19], 20.0000, 10.0000);
	TextDrawAlignment(filling_td[19], 1);
	TextDrawColor(filling_td[19], color_textdraw);
	TextDrawBackgroundColor(filling_td[19], 255);
	TextDrawFont(filling_td[19], 4);
	TextDrawSetProportional(filling_td[19], 0);
	TextDrawSetShadow(filling_td[19], 0);

	filling_td[20] = TextDrawCreate(243.9666, 205.2489, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[20], 14.0000, 14.8899);
	TextDrawAlignment(filling_td[20], 1);
	TextDrawColor(filling_td[20], color_textdraw);
	TextDrawBackgroundColor(filling_td[20], 255);
	TextDrawFont(filling_td[20], 4);
	TextDrawSetProportional(filling_td[20], 0);
	TextDrawSetShadow(filling_td[20], 0);

	filling_td[21] = TextDrawCreate(264.9665, 205.2489, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[21], 14.0000, 14.8899);
	TextDrawAlignment(filling_td[21], 1);
	TextDrawColor(filling_td[21], color_textdraw);
	TextDrawBackgroundColor(filling_td[21], 255);
	TextDrawFont(filling_td[21], 4);
	TextDrawSetProportional(filling_td[21], 0);
	TextDrawSetShadow(filling_td[21], 0);

	filling_td[22] = TextDrawCreate(261.8666, 207.7074, "+"); // пусто
	TextDrawLetterSize(filling_td[22], 0.2623, 1.0730);
	TextDrawTextSize(filling_td[22], 15.0000, 29.0000);
	TextDrawAlignment(filling_td[22], 2);
	TextDrawColor(filling_td[22], color_box);
	TextDrawUseBox(filling_td[22], 1);
	TextDrawBoxColor(filling_td[22], 0);
	TextDrawBackgroundColor(filling_td[22], 255);
	TextDrawFont(filling_td[22], 1);
	TextDrawSetProportional(filling_td[22], 1);
	TextDrawSetShadow(filling_td[22], 0);
	TextDrawSetSelectable(filling_td[22], true);

	filling_td[23] = TextDrawCreate(298.5332, 206.2482, "-"); // пусто
	TextDrawLetterSize(filling_td[23], 0.4893, 1.1477);
	TextDrawTextSize(filling_td[23], 15.0000, 29.0000);
	TextDrawAlignment(filling_td[23], 2);
	TextDrawColor(filling_td[23], color_box);
	TextDrawUseBox(filling_td[23], 1);
	TextDrawBoxColor(filling_td[23], 0);
	TextDrawBackgroundColor(filling_td[23], 255);
	TextDrawFont(filling_td[23], 1);
	TextDrawSetProportional(filling_td[23], 1);
	TextDrawSetShadow(filling_td[23], 0);
	TextDrawSetSelectable(filling_td[23], true);

	filling_td[24] = TextDrawCreate(316.3675, 205.3341, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[24], 14.0000, 14.8899);
	TextDrawAlignment(filling_td[24], 1);
	TextDrawColor(filling_td[24], color_textdraw);
	TextDrawBackgroundColor(filling_td[24], 255);
	TextDrawFont(filling_td[24], 4);
	TextDrawSetProportional(filling_td[24], 0);
	TextDrawSetShadow(filling_td[24], 0);

	filling_td[25] = TextDrawCreate(369.2345, 205.3341, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[25], 14.0000, 14.8899);
	TextDrawAlignment(filling_td[25], 1);
	TextDrawColor(filling_td[25], color_textdraw);
	TextDrawBackgroundColor(filling_td[25], 255);
	TextDrawFont(filling_td[25], 4);
	TextDrawSetProportional(filling_td[25], 0);
	TextDrawSetShadow(filling_td[25], 0);

	filling_td[26] = TextDrawCreate(323.6330, 207.7666, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[26], 53.0000, 10.0000);
	TextDrawAlignment(filling_td[26], 1);
	TextDrawColor(filling_td[26], color_textdraw);
	TextDrawBackgroundColor(filling_td[26], 255);
	TextDrawFont(filling_td[26], 4);
	TextDrawSetProportional(filling_td[26], 0);
	TextDrawSetShadow(filling_td[26], 0);

	filling_td[27] = TextDrawCreate(317.8675, 206.7786, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[27], 11.0000, 11.9598);
	TextDrawAlignment(filling_td[27], 1);
	TextDrawColor(filling_td[27], color_box);
	TextDrawBackgroundColor(filling_td[27], 255);
	TextDrawFont(filling_td[27], 4);
	TextDrawSetProportional(filling_td[27], 0);
	TextDrawSetShadow(filling_td[27], 0);

	filling_td[28] = TextDrawCreate(370.8679, 206.9638, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[28], 11.0000, 11.5999);
	TextDrawAlignment(filling_td[28], 1);
	TextDrawColor(filling_td[28], color_box);
	TextDrawBackgroundColor(filling_td[28], 255);
	TextDrawFont(filling_td[28], 4);
	TextDrawSetProportional(filling_td[28], 0);
	TextDrawSetShadow(filling_td[28], 0);

	filling_td[29] = TextDrawCreate(324.2998, 208.9110, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[29], 52.0000, 7.7498);
	TextDrawAlignment(filling_td[29], 1);
	TextDrawColor(filling_td[29], color_box);
	TextDrawBackgroundColor(filling_td[29], 255);
	TextDrawFont(filling_td[29], 4);
	TextDrawSetProportional(filling_td[29], 0);
	TextDrawSetShadow(filling_td[29], 0);

	filling_td[30] = TextDrawCreate(285.5663, 223.7415, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[30], 18.0000, 21.0000);
	TextDrawAlignment(filling_td[30], 1);
	TextDrawColor(filling_td[30], color_textdraw);
	TextDrawBackgroundColor(filling_td[30], 255);
	TextDrawFont(filling_td[30], 4);
	TextDrawSetProportional(filling_td[30], 0);
	TextDrawSetShadow(filling_td[30], 0);

	filling_td[31] = TextDrawCreate(295.2328, 227.2600, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[31], 38.0000, 14.0000);
	TextDrawAlignment(filling_td[31], 1);
	TextDrawColor(filling_td[31], color_textdraw);
	TextDrawBackgroundColor(filling_td[31], 255);
	TextDrawFont(filling_td[31], 4);
	TextDrawSetProportional(filling_td[31], 0);
	TextDrawSetShadow(filling_td[31], 0);

	filling_td[32] = TextDrawCreate(324.8663, 223.7415, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[32], 18.0000, 21.0000);
	TextDrawAlignment(filling_td[32], 1);
	TextDrawColor(filling_td[32], color_textdraw);
	TextDrawBackgroundColor(filling_td[32], 255);
	TextDrawFont(filling_td[32], 4);
	TextDrawSetProportional(filling_td[32], 0);
	TextDrawSetShadow(filling_td[32], 0);

	filling_td[33] = TextDrawCreate(314.5662, 229.0749, "FILL"); // пусто
	TextDrawLetterSize(filling_td[33], 0.2899, 1.1601);
	TextDrawTextSize(filling_td[33], 15.0000, 50.0000);
	TextDrawAlignment(filling_td[33], 2);
	TextDrawColor(filling_td[33], color_box);
	TextDrawUseBox(filling_td[33], 1);
	TextDrawBoxColor(filling_td[33], 0);
	TextDrawBackgroundColor(filling_td[33], 255);
	TextDrawFont(filling_td[33], 1);
	TextDrawSetProportional(filling_td[33], 1);
	TextDrawSetShadow(filling_td[33], 0);
	TextDrawSetSelectable(filling_td[33], true);

	filling_td[34] = TextDrawCreate(237.8000, 164.9555, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[34], 152.0899, 11.0000);
	TextDrawAlignment(filling_td[34], 1);
	TextDrawColor(filling_td[34], color_textdraw);
	TextDrawBackgroundColor(filling_td[34], 255);
	TextDrawFont(filling_td[34], 4);
	TextDrawSetProportional(filling_td[34], 0);
	TextDrawSetShadow(filling_td[34], 0);

	filling_td[35] = TextDrawCreate(234.6000, 153.3703, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[35], 20.0000, 22.0000);
	TextDrawAlignment(filling_td[35], 1);
	TextDrawColor(filling_td[35], color_textdraw);
	TextDrawBackgroundColor(filling_td[35], 255);
	TextDrawFont(filling_td[35], 4);
	TextDrawSetProportional(filling_td[35], 0);
	TextDrawSetShadow(filling_td[35], 0);

	filling_td[36] = TextDrawCreate(373.1666, 153.3703, "ld_beat:chit"); // пусто
	TextDrawTextSize(filling_td[36], 20.0000, 22.0000);
	TextDrawAlignment(filling_td[36], 1);
	TextDrawColor(filling_td[36], color_textdraw);
	TextDrawBackgroundColor(filling_td[36], 255);
	TextDrawFont(filling_td[36], 4);
	TextDrawSetProportional(filling_td[36], 0);
	TextDrawSetShadow(filling_td[36], 0);

	filling_td[37] = TextDrawCreate(245.4999, 157.0740, "ld_spac:white"); // пусто
	TextDrawTextSize(filling_td[37], 139.0000, 18.0000);
	TextDrawAlignment(filling_td[37], 1);
	TextDrawColor(filling_td[37], color_textdraw);
	TextDrawBackgroundColor(filling_td[37], 255);
	TextDrawFont(filling_td[37], 4);
	TextDrawSetProportional(filling_td[37], 0);
	TextDrawSetShadow(filling_td[37], 0);

	filling_td[38] = TextDrawCreate(314.4333, 160.9629, "FUEL_STATION"); // пусто
	TextDrawLetterSize(filling_td[38], 0.2899, 1.2640);
	TextDrawAlignment(filling_td[38], 2);
	TextDrawColor(filling_td[38], color_server);
	TextDrawBackgroundColor(filling_td[38], 255);
	TextDrawFont(filling_td[38], 1);
	TextDrawSetProportional(filling_td[38], 1);
	TextDrawSetShadow(filling_td[38], 0);
	
	/*filling_td[38] = TextDrawCreate(241.6667, 162.6222, "X"); // пусто
	TextDrawLetterSize(filling_td[38], 0.2753, 1.1105);
	TextDrawAlignment(filling_td[38], 1);
	TextDrawColor(filling_td[38], -6881281);
	TextDrawBackgroundColor(filling_td[38], 255);
	TextDrawFont(filling_td[38], 1);
	TextDrawSetProportional(filling_td[38], 1);
	TextDrawSetShadow(filling_td[38], 0);

	filling_td[39] = TextDrawCreate(380.3333, 157.2296, "X"); // пусто
	TextDrawLetterSize(filling_td[39], 0.2753, 1.1105);
	TextDrawAlignment(filling_td[39], 1);
	TextDrawColor(filling_td[39], -6881281);
	TextDrawBackgroundColor(filling_td[39], 255);
	TextDrawFont(filling_td[39], 1);
	TextDrawSetProportional(filling_td[39], 1);
	TextDrawSetShadow(filling_td[39], 0);

	filling_td[40] = TextDrawCreate(295.3333, 154.7407, "X"); // пусто
	TextDrawLetterSize(filling_td[40], 0.2753, 1.1105);
	TextDrawAlignment(filling_td[40], 1);
	TextDrawColor(filling_td[40], -6881281);
	TextDrawBackgroundColor(filling_td[40], 255);
	TextDrawFont(filling_td[40], 1);
	TextDrawSetProportional(filling_td[40], 1);
	TextDrawSetShadow(filling_td[40], 0);

	filling_td[41] = TextDrawCreate(328.0000, 165.9407, "X"); // пусто
	TextDrawLetterSize(filling_td[41], 0.2753, 1.1105);
	TextDrawAlignment(filling_td[41], 1);
	TextDrawColor(filling_td[41], -6881281);
	TextDrawBackgroundColor(filling_td[41], 255);
	TextDrawFont(filling_td[41], 1);
	TextDrawSetProportional(filling_td[41], 1);
	TextDrawSetShadow(filling_td[41], 0);

	filling_td[42] = TextDrawCreate(259.3333, 155.9851, "o"); // пусто
	TextDrawLetterSize(filling_td[42], 0.2753, 1.1105);
	TextDrawAlignment(filling_td[42], 1);
	TextDrawColor(filling_td[42], -6881281);
	TextDrawBackgroundColor(filling_td[42], 255);
	TextDrawFont(filling_td[42], 1);
	TextDrawSetProportional(filling_td[42], 1);
	TextDrawSetShadow(filling_td[42], 0);

	filling_td[43] = TextDrawCreate(368.6666, 166.7703, "o"); // пусто
	TextDrawLetterSize(filling_td[43], 0.2753, 1.1105);
	TextDrawAlignment(filling_td[43], 1);
	TextDrawColor(filling_td[43], -6881281);
	TextDrawBackgroundColor(filling_td[43], 255);
	TextDrawFont(filling_td[43], 1);
	TextDrawSetProportional(filling_td[43], 1);
	TextDrawSetShadow(filling_td[43], 0);

	filling_td[44] = TextDrawCreate(341.0000, 154.3259, "o"); // пусто
	TextDrawLetterSize(filling_td[44], 0.2753, 1.1105);
	TextDrawAlignment(filling_td[44], 1);
	TextDrawColor(filling_td[44], -6881281);
	TextDrawBackgroundColor(filling_td[44], 255);
	TextDrawFont(filling_td[44], 1);
	TextDrawSetProportional(filling_td[44], 1);
	TextDrawSetShadow(filling_td[44], 0);

	filling_td[45] = TextDrawCreate(353.6665, 159.7185, ">"); // пусто
	TextDrawLetterSize(filling_td[45], -0.1406, 1.7037);
	TextDrawAlignment(filling_td[45], 1);
	TextDrawColor(filling_td[45], -6881281);
	TextDrawBackgroundColor(filling_td[45], 255);
	TextDrawFont(filling_td[45], 1);
	TextDrawSetProportional(filling_td[45], 1);
	TextDrawSetShadow(filling_td[45], 0);

	filling_td[46] = TextDrawCreate(275.3332, 161.7926, ">"); // пусто
	TextDrawLetterSize(filling_td[46], -0.1406, 1.7037);
	TextDrawAlignment(filling_td[46], 1);
	TextDrawColor(filling_td[46], -6881281);
	TextDrawBackgroundColor(filling_td[46], 255);
	TextDrawFont(filling_td[46], 1);
	TextDrawSetProportional(filling_td[46], 1);
	TextDrawSetShadow(filling_td[46], 0);*/
	
	// server . logo
	
	#if defined SAMP
	td_logo = TextDrawCreate(1.000000, 372.000000, "logotape:logotype");
	TextDrawTextSize(td_logo, 84.000000, 97.000000);
	TextDrawAlignment(td_logo, 1);
	TextDrawColor(td_logo, -1);
	TextDrawBackgroundColor(td_logo, 255);
	TextDrawFont(td_logo, 4);
	TextDrawSetProportional(td_logo, 0);
	#endif
	
	#if defined CRMP
	td_logo = TextDrawCreate(18.6665, 396.0072, "crime:logotype"); // пусто
	TextDrawTextSize(td_logo, 38.0000, 31.1399);
	TextDrawAlignment(td_logo, 1);
	TextDrawColor(td_logo, -1);
	TextDrawBackgroundColor(td_logo, 255);
	TextDrawFont(td_logo, 4);
	TextDrawSetProportional(td_logo, 0);
	TextDrawSetShadow(td_logo, 0);
	#endif
		
	// slot machine
	
	sm_td [ 0 ] = TextDrawCreate ( 276.000000, 355.000000, "    SET" ) ;
	TextDrawBackgroundColor ( sm_td [ 0 ], 255 ) ;
	TextDrawFont ( sm_td [ 0 ], 2 ) ;
	TextDrawLetterSize ( sm_td [ 0 ], 0.419999, 2.099999 ) ;
	TextDrawColor ( sm_td [ 0 ], -2711041 ) ;
	TextDrawSetOutline ( sm_td [ 0 ], 0 ) ;
	TextDrawSetProportional ( sm_td [ 0 ], 1 ) ;
	TextDrawSetShadow ( sm_td [ 0 ], 1 ) ;
	TextDrawBoxColor ( sm_td [ 0 ], 255 ) ;
	TextDrawTextSize ( sm_td [ 0 ], 336.000000, 12.000000 ) ;
	TextDrawSetSelectable ( sm_td [ 0 ], 1 ) ;

	sm_td [ 1 ] = TextDrawCreate ( 375.000000, 355.000000, " RESET" ) ;
	TextDrawBackgroundColor ( sm_td [ 1 ], 255 ) ;
	TextDrawFont ( sm_td [ 1 ], 2 ) ;
	TextDrawLetterSize ( sm_td [ 1 ], 0.419999, 2.099999 ) ;
	TextDrawColor ( sm_td [ 1 ], -2711041 ) ;
	TextDrawSetOutline ( sm_td [ 1 ], 0 ) ;
	TextDrawSetProportional ( sm_td [ 1 ], 1 ) ;
	TextDrawSetShadow ( sm_td [ 1 ], 1 ) ;
	TextDrawBoxColor ( sm_td [ 1 ], 255 ) ;
	TextDrawTextSize ( sm_td [ 1 ], 436.000000, 12.000000 ) ;
	TextDrawSetSelectable ( sm_td [ 1 ], 1 ) ;

	sm_td [ 2 ] = TextDrawCreate ( 182.000000, 355.000000, "   ~r~Exit" ) ;
	TextDrawBackgroundColor ( sm_td [ 2 ], 255 ) ;
	TextDrawFont ( sm_td [ 2 ], 2 ) ;
	TextDrawLetterSize ( sm_td [ 2 ], 0.419999, 2.099999 ) ;
	TextDrawColor ( sm_td [ 2 ], -2711041 ) ;
	TextDrawSetOutline ( sm_td [ 2 ], 0 ) ;
	TextDrawSetProportional ( sm_td [ 2 ], 1 ) ;
	TextDrawSetShadow ( sm_td [ 2 ], 1 ) ;
	TextDrawBoxColor ( sm_td [ 2 ], 255 ) ;
	TextDrawTextSize ( sm_td [ 2 ], 244.000000, 12.000000 ) ;
	TextDrawSetSelectable ( sm_td [ 2 ], 1 ) ;

	sm_td [ 3 ] = TextDrawCreate (  482.000000, 355.000000, " ~g~PLAY" ) ;
	TextDrawBackgroundColor ( sm_td [ 3 ], 255 ) ;
	TextDrawFont ( sm_td [ 3 ], 2 ) ;
	TextDrawLetterSize ( sm_td [ 3 ], 0.419999, 2.099999 ) ;
	TextDrawColor ( sm_td [ 3 ], -2711041 ) ;
	TextDrawSetOutline ( sm_td [ 3 ], 0 ) ;
	TextDrawSetProportional ( sm_td [ 3 ], 1 ) ;
	TextDrawSetShadow ( sm_td [ 3 ], 1 ) ;
	TextDrawBoxColor ( sm_td [ 3 ], 255 ) ;
	TextDrawTextSize ( sm_td [ 3 ], 544.000000, 12.000000 ) ;
	TextDrawSetSelectable ( sm_td [ 3 ], 1 ) ;

	// capture
	capture_td[0] = TextDrawCreate(11.1999, 218.4666, "ld_spac:white"); // 1 Box
	TextDrawTextSize(capture_td[0], 120.0000, 40.0000);
	TextDrawAlignment(capture_td[0], 1);
	TextDrawColor(capture_td[0], color_black_box);
	TextDrawBackgroundColor(capture_td[0], 255);
	TextDrawFont(capture_td[0], 4);
	TextDrawSetProportional(capture_td[0], 0);
	TextDrawSetShadow(capture_td[0], 0);

	capture_td[1] = TextDrawCreate(11.1332, 209.7555, "ld_spac:white"); // 1 Box
	TextDrawTextSize(capture_td[1], 120.0000, 9.5899);
	TextDrawAlignment(capture_td[1], 1);
	TextDrawColor(capture_td[1], color_textdraw);
	TextDrawBackgroundColor(capture_td[1], 255);
	TextDrawFont(capture_td[1], 4);
	TextDrawSetProportional(capture_td[1], 0);
	TextDrawSetShadow(capture_td[1], 0);

	capture_td[2] = TextDrawCreate(8.6999, 200.2147, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[2], 15.0000, 18.0000);
	TextDrawAlignment(capture_td[2], 1);
	TextDrawColor(capture_td[2], color_textdraw);
	TextDrawBackgroundColor(capture_td[2], 255);
	TextDrawFont(capture_td[2], 4);
	TextDrawSetProportional(capture_td[2], 0);
	TextDrawSetShadow(capture_td[2], 0);

	capture_td[3] = TextDrawCreate(13.1672, 222.9592, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[3], 12.0000, 15.0000);
	TextDrawAlignment(capture_td[3], 1);
	TextDrawColor(capture_td[3], color_box);
	TextDrawBackgroundColor(capture_td[3], 255);
	TextDrawFont(capture_td[3], 4);
	TextDrawSetProportional(capture_td[3], 0);
	TextDrawSetShadow(capture_td[3], 0);

	capture_td[4] = TextDrawCreate(54.7342, 222.9591, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[4], 12.0000, 15.0000);
	TextDrawAlignment(capture_td[4], 1);
	TextDrawColor(capture_td[4], color_box);
	TextDrawBackgroundColor(capture_td[4], 255);
	TextDrawFont(capture_td[4], 4);
	TextDrawSetProportional(capture_td[4], 0);
	TextDrawSetShadow(capture_td[4], 0);

	capture_td[5] = TextDrawCreate(75.4665, 222.9592, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[5], 12.0000, 15.0000);
	TextDrawAlignment(capture_td[5], 1);
	TextDrawColor(capture_td[5], color_box);
	TextDrawBackgroundColor(capture_td[5], 255);
	TextDrawFont(capture_td[5], 4);
	TextDrawSetProportional(capture_td[5], 0);
	TextDrawSetShadow(capture_td[5], 0);

	capture_td[6] = TextDrawCreate(117.0333, 222.9591, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[6], 12.0000, 15.0000);
	TextDrawAlignment(capture_td[6], 1);
	TextDrawColor(capture_td[6], color_box);
	TextDrawBackgroundColor(capture_td[6], 255);
	TextDrawFont(capture_td[6], 4);
	TextDrawSetProportional(capture_td[6], 0);
	TextDrawSetShadow(capture_td[6], 0);

	capture_td[7] = TextDrawCreate(67.5999, 226.7037, "VS"); // 1 Box
	TextDrawLetterSize(capture_td[7], 0.1688, 0.7745);
	TextDrawAlignment(capture_td[7], 1);
	TextDrawColor(capture_td[7], -2139062017);
	TextDrawBackgroundColor(capture_td[7], 255);
	TextDrawFont(capture_td[7], 1);
	TextDrawSetProportional(capture_td[7], 1);
	TextDrawSetShadow(capture_td[7], 0);

	capture_td[8] = TextDrawCreate(14.3332, 253.6857, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(capture_td[8], 117.0000, -10.0000);
	TextDrawAlignment(capture_td[8], 1);
	TextDrawColor(capture_td[8], color_particle);
	TextDrawBackgroundColor(capture_td[8], 255);
	TextDrawFont(capture_td[8], 4);
	TextDrawSetProportional(capture_td[8], 0);
	TextDrawSetShadow(capture_td[8], 0);

	capture_td[9] = TextDrawCreate(118.6999, 200.2147, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[9], 15.0000, 18.0000);
	TextDrawAlignment(capture_td[9], 1);
	TextDrawColor(capture_td[9], color_textdraw);
	TextDrawBackgroundColor(capture_td[9], 255);
	TextDrawFont(capture_td[9], 4);
	TextDrawSetProportional(capture_td[9], 0);
	TextDrawSetShadow(capture_td[9], 0);

	capture_td[10] = TextDrawCreate(16.0665, 203.2184, "ld_spac:white"); // 1 Box
	TextDrawTextSize(capture_td[10], 110.0000, 9.0000);
	TextDrawAlignment(capture_td[10], 1);
	TextDrawColor(capture_td[10], color_textdraw);
	TextDrawBackgroundColor(capture_td[10], 255);
	TextDrawFont(capture_td[10], 4);
	TextDrawSetProportional(capture_td[10], 0);
	TextDrawSetShadow(capture_td[10], 0);

	capture_td[11] = TextDrawCreate(126.1998, 213.9296, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[11], 6.0000, 10.0000);
	TextDrawAlignment(capture_td[11], 1);
	TextDrawColor(capture_td[11], color_textdraw);
	TextDrawBackgroundColor(capture_td[11], 255);
	TextDrawFont(capture_td[11], 4);
	TextDrawSetProportional(capture_td[11], 0);
	TextDrawSetShadow(capture_td[11], 0);

	capture_td[12] = TextDrawCreate(14.3332, 244.8851, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(capture_td[12], 117.0000, 9.0000);
	TextDrawAlignment(capture_td[12], 1);
	TextDrawColor(capture_td[12], 1030548065);
	TextDrawBackgroundColor(capture_td[12], 255);
	TextDrawFont(capture_td[12], 4);
	TextDrawSetProportional(capture_td[12], 0);
	TextDrawSetShadow(capture_td[12], 0);

	capture_td[13] = TextDrawCreate(13.1672, 241.0603, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[13], 12.0000, 15.0000);
	TextDrawAlignment(capture_td[13], 1);
	TextDrawColor(capture_td[13], color_textdraw);
	TextDrawBackgroundColor(capture_td[13], 255);
	TextDrawFont(capture_td[13], 4);
	TextDrawSetProportional(capture_td[13], 0);
	TextDrawSetShadow(capture_td[13], 0);

	capture_td[14] = TextDrawCreate(117.0333, 241.1602, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[14], 12.0000, 15.0000);
	TextDrawAlignment(capture_td[14], 1);
	TextDrawColor(capture_td[14], color_textdraw);
	TextDrawBackgroundColor(capture_td[14], 255);
	TextDrawFont(capture_td[14], 4);
	TextDrawSetProportional(capture_td[14], 0);
	TextDrawSetShadow(capture_td[14], 0);

	capture_td[15] = TextDrawCreate(10.1332, 212.9556, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[15], 6.0000, 10.0000);
	TextDrawAlignment(capture_td[15], 1);
	TextDrawColor(capture_td[15], color_textdraw);
	TextDrawBackgroundColor(capture_td[15], 255);
	TextDrawFont(capture_td[15], 4);
	TextDrawSetProportional(capture_td[15], 0);
	TextDrawSetShadow(capture_td[15], 0);

	capture_td[16] = TextDrawCreate(20.1332, 206.3186, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[16], 6.0000, 17.0000);
	TextDrawAlignment(capture_td[16], 1);
	TextDrawColor(capture_td[16], color_textdraw);
	TextDrawBackgroundColor(capture_td[16], 255);
	TextDrawFont(capture_td[16], 4);
	TextDrawSetProportional(capture_td[16], 0);
	TextDrawSetShadow(capture_td[16], 0);

	capture_td[17] = TextDrawCreate(33.1332, 213.7853, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[17], 6.0000, 8.0000);
	TextDrawAlignment(capture_td[17], 1);
	TextDrawColor(capture_td[17], color_textdraw);
	TextDrawBackgroundColor(capture_td[17], 255);
	TextDrawFont(capture_td[17], 4);
	TextDrawSetProportional(capture_td[17], 0);
	TextDrawSetShadow(capture_td[17], 0);

	capture_td[18] = TextDrawCreate(46.7998, 215.0297, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[18], 7.0000, 6.0000);
	TextDrawAlignment(capture_td[18], 1);
	TextDrawColor(capture_td[18], color_textdraw);
	TextDrawBackgroundColor(capture_td[18], 255);
	TextDrawFont(capture_td[18], 4);
	TextDrawSetProportional(capture_td[18], 0);
	TextDrawSetShadow(capture_td[18], 0);

	capture_td[19] = TextDrawCreate(113.4665, 215.0298, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[19], 6.0000, 6.0000);
	TextDrawAlignment(capture_td[19], 1);
	TextDrawColor(capture_td[19], color_textdraw);
	TextDrawBackgroundColor(capture_td[19], 255);
	TextDrawFont(capture_td[19], 4);
	TextDrawSetProportional(capture_td[19], 0);
	TextDrawSetShadow(capture_td[19], 0);

	capture_td[20] = TextDrawCreate(101.4665, 213.7297, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[20], 6.0000, 9.0000);
	TextDrawAlignment(capture_td[20], 1);
	TextDrawColor(capture_td[20], color_textdraw);
	TextDrawBackgroundColor(capture_td[20], 255);
	TextDrawFont(capture_td[20], 4);
	TextDrawSetProportional(capture_td[20], 0);
	TextDrawSetShadow(capture_td[20], 0);

	capture_td[21] = TextDrawCreate(85.9665, 214.2001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[21], 6.0000, 7.0000);
	TextDrawAlignment(capture_td[21], 1);
	TextDrawColor(capture_td[21], color_textdraw);
	TextDrawBackgroundColor(capture_td[21], 255);
	TextDrawFont(capture_td[21], 4);
	TextDrawSetProportional(capture_td[21], 0);
	TextDrawSetShadow(capture_td[21], 0);

	capture_td[22] = TextDrawCreate(73.8998, 214.2001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[22], 5.0000, 8.0000);
	TextDrawAlignment(capture_td[22], 1);
	TextDrawColor(capture_td[22], color_textdraw);
	TextDrawBackgroundColor(capture_td[22], 255);
	TextDrawFont(capture_td[22], 4);
	TextDrawSetProportional(capture_td[22], 0);
	TextDrawSetShadow(capture_td[22], 0);

	capture_td[23] = TextDrawCreate(58.9665, 213.8001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(capture_td[23], 7.0000, 8.0000);
	TextDrawAlignment(capture_td[23], 1);
	TextDrawColor(capture_td[23], color_textdraw);
	TextDrawBackgroundColor(capture_td[23], 255);
	TextDrawFont(capture_td[23], 4);
	TextDrawSetProportional(capture_td[23], 0);
	TextDrawSetShadow(capture_td[23], 0);

	capture_td[24] = TextDrawCreate(10.3332, 202.2888, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(capture_td[24], 124.0000, 17.0000);
	TextDrawAlignment(capture_td[24], 1);
	TextDrawColor(capture_td[24], -234);
	TextDrawBackgroundColor(capture_td[24], 255);
	TextDrawFont(capture_td[24], 4);
	TextDrawSetProportional(capture_td[24], 0);
	TextDrawSetShadow(capture_td[24], 0);

	capture_td[25] = TextDrawCreate(56.2999, 207.0074, "CAPTURE"); // 1 Box
	TextDrawLetterSize(capture_td[25], 0.2009, 0.8947);
	TextDrawAlignment(capture_td[25], 1);
	TextDrawColor(capture_td[25], -1);
	TextDrawBackgroundColor(capture_td[25], 255);
	TextDrawFont(capture_td[25], 1);
	TextDrawSetProportional(capture_td[25], 1);
	TextDrawSetShadow(capture_td[25], 0);

	capture_td[26] = TextDrawCreate(11.1999, 261.9692, "ld_spac:white"); // 2 Box
	TextDrawTextSize(capture_td[26], 120.0000, 27.0000);
	TextDrawAlignment(capture_td[26], 1);
	TextDrawColor(capture_td[26], color_black_box);
	TextDrawBackgroundColor(capture_td[26], 255);
	TextDrawFont(capture_td[26], 4);
	TextDrawSetProportional(capture_td[26], 0);
	TextDrawSetShadow(capture_td[26], 0);

	capture_td[27] = TextDrawCreate(13.1672, 272.2622, "ld_beat:chit"); // 2 Box
	TextDrawTextSize(capture_td[27], 12.0000, 15.0000);
	TextDrawAlignment(capture_td[27], 1);
	TextDrawColor(capture_td[27], color_textdraw);
	TextDrawBackgroundColor(capture_td[27], 255);
	TextDrawFont(capture_td[27], 4);
	TextDrawSetProportional(capture_td[27], 0);
	TextDrawSetShadow(capture_td[27], 0);

	capture_td[28] = TextDrawCreate(117.0333, 272.3620, "ld_beat:chit"); // 2 Box
	TextDrawTextSize(capture_td[28], 12.0000, 15.0000);
	TextDrawAlignment(capture_td[28], 1);
	TextDrawColor(capture_td[28], color_textdraw);
	TextDrawBackgroundColor(capture_td[28], 255);
	TextDrawFont(capture_td[28], 4);
	TextDrawSetProportional(capture_td[28], 0);
	TextDrawSetShadow(capture_td[28], 0);

	capture_td[29] = TextDrawCreate(14.3332, 284.8875, "particle:lamp_shad_64"); // 2 Box
	TextDrawTextSize(capture_td[29], 117.0000, -10.0000);
	TextDrawAlignment(capture_td[29], 1);
	TextDrawColor(capture_td[29], color_particle);
	TextDrawBackgroundColor(capture_td[29], 255);
	TextDrawFont(capture_td[29], 4);
	TextDrawSetProportional(capture_td[29], 0);
	TextDrawSetShadow(capture_td[29], 0);

	capture_td[30] = TextDrawCreate(14.3332, 276.0870, "particle:lamp_shad_64"); // 2 Box
	TextDrawTextSize(capture_td[30], 117.0000, 9.0000);
	TextDrawAlignment(capture_td[30], 1);
	TextDrawColor(capture_td[30], 1030548065);
	TextDrawBackgroundColor(capture_td[30], 255);
	TextDrawFont(capture_td[30], 4);
	TextDrawSetProportional(capture_td[30], 0);
	TextDrawSetShadow(capture_td[30], 0);

	capture_td[31] = TextDrawCreate(44.8332, 264.4813, "PERSONAL_STATISTIC~n~"); // 2 Box
	TextDrawLetterSize(capture_td[31], 0.1636, 0.7869);
	TextDrawAlignment(capture_td[31], 1);
	TextDrawColor(capture_td[31], -1);
	TextDrawBackgroundColor(capture_td[31], 67);
	TextDrawFont(capture_td[31], 1);
	TextDrawSetProportional(capture_td[31], 1);
	TextDrawSetShadow(capture_td[31], 1);

	capture_td[32] = TextDrawCreate(11.1999, 292.1710, "ld_spac:white"); // 3 Box
	TextDrawTextSize(capture_td[32], 120.0000, 21.0000);
	TextDrawAlignment(capture_td[32], 1);
	TextDrawColor(capture_td[32], color_black_box);
	TextDrawBackgroundColor(capture_td[32], 255);
	TextDrawFont(capture_td[32], 4);
	TextDrawSetProportional(capture_td[32], 0);
	TextDrawSetShadow(capture_td[32], 0);

	capture_td[33] = TextDrawCreate(8.9666, 304.6155, "ld_beat:chit"); // 3 Box
	TextDrawTextSize(capture_td[33], 14.0000, 17.0000);
	TextDrawAlignment(capture_td[33], 1);
	TextDrawColor(capture_td[33], color_black_box);
	TextDrawBackgroundColor(capture_td[33], 255);
	TextDrawFont(capture_td[33], 4);
	TextDrawSetProportional(capture_td[33], 0);
	TextDrawSetShadow(capture_td[33], 0);

	capture_td[34] = TextDrawCreate(119.6001, 304.6155, "ld_beat:chit"); // 3 Box
	TextDrawTextSize(capture_td[34], 14.0000, 17.0000);
	TextDrawAlignment(capture_td[34], 1);
	TextDrawColor(capture_td[34], color_black_box);
	TextDrawBackgroundColor(capture_td[34], 255);
	TextDrawFont(capture_td[34], 4);
	TextDrawSetProportional(capture_td[34], 0);
	TextDrawSetShadow(capture_td[34], 0);

	capture_td[35] = TextDrawCreate(16.1999, 307.6518, "ld_spac:white"); // 3 Box
	TextDrawTextSize(capture_td[35], 111.0000, 11.0000);
	TextDrawAlignment(capture_td[35], 1);
	TextDrawColor(capture_td[35], color_black_box);
	TextDrawBackgroundColor(capture_td[35], 255);
	TextDrawFont(capture_td[35], 4);
	TextDrawSetProportional(capture_td[35], 0);
	TextDrawSetShadow(capture_td[35], 0);

	capture_td[36] = TextDrawCreate(6.6666, 306.7100, "particle:lamp_shad_64"); // 3 Box
	TextDrawTextSize(capture_td[36], 132.0000, 12.0000);
	TextDrawAlignment(capture_td[36], 1);
	TextDrawColor(capture_td[36], color_particle);
	TextDrawBackgroundColor(capture_td[36], 255);
	TextDrawFont(capture_td[36], 4);
	TextDrawSetProportional(capture_td[36], 0);
	TextDrawSetShadow(capture_td[36], 0);

	capture_td[37] = TextDrawCreate(37.4999, 294.9832, "BEST_PLAYERS_OF_CAPTURE"); // 3 Box
	TextDrawLetterSize(capture_td[37], 0.1636, 0.7869);
	TextDrawAlignment(capture_td[37], 1);
	TextDrawColor(capture_td[37], -1);
	TextDrawBackgroundColor(capture_td[37], 67);
	TextDrawFont(capture_td[37], 1);
	TextDrawSetProportional(capture_td[37], 1);
	TextDrawSetShadow(capture_td[37], 1);

/*	голод */
	
	satiery_td[0] = TextDrawCreate(28.9988, 226.3477, "ld_beat:chit"); // пусто
	TextDrawTextSize(satiery_td[0], 9.0000, 10.0000);
	TextDrawAlignment(satiery_td[0], 1);
	TextDrawColor(satiery_td[0], 522133503);
	TextDrawBackgroundColor(satiery_td[0], 255);
	TextDrawFont(satiery_td[0], 4);
	TextDrawSetProportional(satiery_td[0], 0);
	TextDrawSetShadow(satiery_td[0], 0);

	satiery_td[1] = TextDrawCreate(28.9988, 253.3103, "ld_beat:chit"); // пусто
	TextDrawTextSize(satiery_td[1], 9.0000, 10.0000);
	TextDrawAlignment(satiery_td[1], 1);
	TextDrawColor(satiery_td[1], 522133503);
	TextDrawBackgroundColor(satiery_td[1], 255);
	TextDrawFont(satiery_td[1], 4);
	TextDrawSetProportional(satiery_td[1], 0);
	TextDrawSetShadow(satiery_td[1], 0);

	satiery_td[2] = TextDrawCreate(136.6657, 226.3477, "ld_beat:chit"); // пусто
	TextDrawTextSize(satiery_td[2], 9.0000, 10.0000);
	TextDrawAlignment(satiery_td[2], 1);
	TextDrawColor(satiery_td[2], 522133503);
	TextDrawBackgroundColor(satiery_td[2], 255);
	TextDrawFont(satiery_td[2], 4);
	TextDrawSetProportional(satiery_td[2], 0);
	TextDrawSetShadow(satiery_td[2], 0);

	satiery_td[3] = TextDrawCreate(136.6657, 253.3103, "ld_beat:chit"); // пусто
	TextDrawTextSize(satiery_td[3], 9.0000, 10.0000);
	TextDrawAlignment(satiery_td[3], 1);
	TextDrawColor(satiery_td[3], 522133503);
	TextDrawBackgroundColor(satiery_td[3], 255);
	TextDrawFont(satiery_td[3], 4);
	TextDrawSetProportional(satiery_td[3], 0);
	TextDrawSetShadow(satiery_td[3], 0);

	satiery_td[4] = TextDrawCreate(33.9992, 227.6925, "ld_spac:white"); // пусто
	TextDrawTextSize(satiery_td[4], 107.0000, 34.0000);
	TextDrawAlignment(satiery_td[4], 1);
	TextDrawColor(satiery_td[4], 522133503);
	TextDrawBackgroundColor(satiery_td[4], 255);
	TextDrawFont(satiery_td[4], 4);
	TextDrawSetProportional(satiery_td[4], 0);
	TextDrawSetShadow(satiery_td[4], 0);

	satiery_td[5] = TextDrawCreate(30.3324, 231.4257, "ld_spac:white"); // пусто
	TextDrawTextSize(satiery_td[5], 114.0000, 26.0000);
	TextDrawAlignment(satiery_td[5], 1);
	TextDrawColor(satiery_td[5], 522133503);
	TextDrawBackgroundColor(satiery_td[5], 255);
	TextDrawFont(satiery_td[5], 4);
	TextDrawSetProportional(satiery_td[5], 0);
	TextDrawSetShadow(satiery_td[5], 0);

	satiery_td[6] = TextDrawCreate(30.3323, 227.6925, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(satiery_td[6], 113.0000, 34.0000);
	TextDrawAlignment(satiery_td[6], 1);
	TextDrawColor(satiery_td[6], 1280068728);
	TextDrawBackgroundColor(satiery_td[6], 255);
	TextDrawFont(satiery_td[6], 4);
	TextDrawSetProportional(satiery_td[6], 0);
	TextDrawSetShadow(satiery_td[6], 0);

	satiery_td[7] = TextDrawCreate(33.9996, 221.1110, "O"); // пусто
	TextDrawLetterSize(satiery_td[7], 0.8366, 4.6529);
	TextDrawAlignment(satiery_td[7], 1);
	TextDrawColor(satiery_td[7], 977690367);
	TextDrawBackgroundColor(satiery_td[7], 255);
	TextDrawFont(satiery_td[7], 2);
	TextDrawSetProportional(satiery_td[7], 1);
	TextDrawSetShadow(satiery_td[7], 0);

	satiery_td[8] = TextDrawCreate(33.9996, 151.4223, "."); // пусто
	TextDrawLetterSize(satiery_td[8], 2.2411, 13.1898);
	TextDrawAlignment(satiery_td[8], 1);
	TextDrawColor(satiery_td[8], 1112566783);
	TextDrawBackgroundColor(satiery_td[8], 255);
	TextDrawFont(satiery_td[8], 3);
	TextDrawSetProportional(satiery_td[8], 1);
	TextDrawSetShadow(satiery_td[8], 0);

	satiery_td[9] = TextDrawCreate(39.3331, 237.7044, "!"); // пусто
	TextDrawLetterSize(satiery_td[9], 0.4000, 1.6000);
	TextDrawTextSize(satiery_td[9], 0.0000, -3.0000);
	TextDrawAlignment(satiery_td[9], 2);
	TextDrawColor(satiery_td[9], 1870104831);
	TextDrawBackgroundColor(satiery_td[9], 255);
	TextDrawFont(satiery_td[9], 1);
	TextDrawSetProportional(satiery_td[9], 1);
	TextDrawSetShadow(satiery_td[9], 0);

	satiery_td[10] = TextDrawCreate(41.9997, 240.1929, "INFO"); // пусто
	TextDrawLetterSize(satiery_td[10], 0.1419, 0.6915);
	TextDrawTextSize(satiery_td[10], -3.0000, 0.0000);
	TextDrawAlignment(satiery_td[10], 1);
	TextDrawColor(satiery_td[10], 1870104831);
	TextDrawBackgroundColor(satiery_td[10], 255);
	TextDrawFont(satiery_td[10], 1);
	TextDrawSetProportional(satiery_td[10], 1);
	TextDrawSetShadow(satiery_td[10], 0);

	satiery_td[11] = TextDrawCreate(59.9997, 249.9920, "ld_spac:white"); // пусто
	TextDrawTextSize(satiery_td[11], 78.0000, 5.0000);
	TextDrawAlignment(satiery_td[11], 1);
	TextDrawColor(satiery_td[11], 774778623);
	TextDrawBackgroundColor(satiery_td[11], 255);
	TextDrawFont(satiery_td[11], 4);
	TextDrawSetProportional(satiery_td[11], 0);
	TextDrawSetShadow(satiery_td[11], 0);

	satiery_td[12] = TextDrawCreate(72.3329, 239.7776, "SATIETY"); // пусто
	TextDrawLetterSize(satiery_td[12], 0.1972, 0.9236);
	TextDrawAlignment(satiery_td[12], 2);
	TextDrawColor(satiery_td[12], -1061109505);
	TextDrawBackgroundColor(satiery_td[12], 255);
	TextDrawFont(satiery_td[12], 1);
	TextDrawSetProportional(satiery_td[12], 1);
	TextDrawSetShadow(satiery_td[12], 0);

	satiery_td[13] = TextDrawCreate(41.9997, 244.7559, "BOX"); // пусто
	TextDrawLetterSize(satiery_td[13], 0.1419, 0.6915);
	TextDrawTextSize(satiery_td[13], -3.0000, 0.0000);
	TextDrawAlignment(satiery_td[13], 1);
	TextDrawColor(satiery_td[13], 1870104831);
	TextDrawBackgroundColor(satiery_td[13], 255);
	TextDrawFont(satiery_td[13], 1);
	TextDrawSetProportional(satiery_td[13], 1);
	TextDrawSetShadow(satiery_td[13], 0);
	
/*	payment */

	payment_td [ 0 ] = TextDrawCreate(28.6655, 262.0209, "ld_beat:chit"); // пусто
	TextDrawTextSize(payment_td [ 0 ], 9.0000, 10.0000);
	TextDrawAlignment(payment_td [ 0 ], 1);
	TextDrawColor(payment_td [ 0 ], 522133503);
	TextDrawBackgroundColor(payment_td [ 0 ], 255);
	TextDrawFont(payment_td [ 0 ], 4);
	TextDrawSetProportional(payment_td [ 0 ], 0);
	TextDrawSetShadow(payment_td [ 0 ], 0);

	payment_td [ 1 ] = TextDrawCreate(28.6655, 288.9844, "ld_beat:chit"); // пусто
	TextDrawTextSize(payment_td [ 1 ], 9.0000, 10.0000);
	TextDrawAlignment(payment_td [ 1 ], 1);
	TextDrawColor(payment_td [ 1 ], 522133503);
	TextDrawBackgroundColor(payment_td [ 1 ], 255);
	TextDrawFont(payment_td [ 1 ], 4);
	TextDrawSetProportional(payment_td [ 1 ], 0);
	TextDrawSetShadow(payment_td [ 1 ], 0);

	payment_td [ 2 ] = TextDrawCreate(136.3323, 262.0209, "ld_beat:chit"); // пусто
	TextDrawTextSize(payment_td [ 2 ], 9.0000, 10.0000);
	TextDrawAlignment(payment_td [ 2 ], 1);
	TextDrawColor(payment_td [ 2 ], 522133503);
	TextDrawBackgroundColor(payment_td [ 2 ], 255);
	TextDrawFont(payment_td [ 2 ], 4);
	TextDrawSetProportional(payment_td [ 2 ], 0);
	TextDrawSetShadow(payment_td [ 2 ], 0);

	payment_td [ 3 ] = TextDrawCreate(136.3323, 288.9844, "ld_beat:chit"); // пусто
	TextDrawTextSize(payment_td [ 3 ], 9.0000, 10.0000);
	TextDrawAlignment(payment_td [ 3 ], 1);
	TextDrawColor(payment_td [ 3 ], 522133503);
	TextDrawBackgroundColor(payment_td [ 3 ], 255);
	TextDrawFont(payment_td [ 3 ], 4);
	TextDrawSetProportional(payment_td [ 3 ], 0);
	TextDrawSetShadow(payment_td [ 3 ], 0);

	payment_td [ 4 ] = TextDrawCreate(33.6659, 263.3658, "ld_spac:white"); // пусто
	TextDrawTextSize(payment_td [ 4 ], 107.0000, 34.0000);
	TextDrawAlignment(payment_td [ 4 ], 1);
	TextDrawColor(payment_td [ 4 ], 522133503);
	TextDrawBackgroundColor(payment_td [ 4 ], 255);
	TextDrawFont(payment_td [ 4 ], 4);
	TextDrawSetProportional(payment_td [ 4 ], 0);
	TextDrawSetShadow(payment_td [ 4 ], 0);

	payment_td [ 5 ] = TextDrawCreate(29.9991, 267.0993, "ld_spac:white"); // пусто
	TextDrawTextSize(payment_td [ 5 ], 114.0000, 26.0000);
	TextDrawAlignment(payment_td [ 5 ], 1);
	TextDrawColor(payment_td [ 5 ], 522133503);
	TextDrawBackgroundColor(payment_td [ 5 ], 255);
	TextDrawFont(payment_td [ 5 ], 4);
	TextDrawSetProportional(payment_td [ 5 ], 0);
	TextDrawSetShadow(payment_td [ 5 ], 0);

	payment_td [ 6 ] = TextDrawCreate(30.3323, 262.9511, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(payment_td [ 6 ], 113.0000, 34.0000);
	TextDrawAlignment(payment_td [ 6 ], 1);
	TextDrawColor(payment_td [ 6 ], 1280068728);
	TextDrawBackgroundColor(payment_td [ 6 ], 255);
	TextDrawFont(payment_td [ 6 ], 4);
	TextDrawSetProportional(payment_td [ 6 ], 0);
	TextDrawSetShadow(payment_td [ 6 ], 0);

	payment_td [ 7 ] = TextDrawCreate(59.6665, 274.2066, "EMOLUMENT"); // пусто
	TextDrawLetterSize(payment_td [ 7 ], 0.1419, 0.6915);
	TextDrawAlignment(payment_td [ 7 ], 1);
	TextDrawColor(payment_td [ 7 ], -2139062017);
	TextDrawBackgroundColor(payment_td [ 7 ], 255);
	TextDrawFont(payment_td [ 7 ], 1);
	TextDrawSetProportional(payment_td [ 7 ], 1);
	TextDrawSetShadow(payment_td [ 7 ], 0);

	payment_td [ 8 ] = TextDrawCreate(59.3330, 279.5997, "~g~$"); // пусто
	TextDrawLetterSize(payment_td [ 8 ], 0.1972, 0.9236);
	TextDrawAlignment(payment_td [ 8 ], 1);
	TextDrawColor(payment_td [ 8 ], -1061109505);
	TextDrawBackgroundColor(payment_td [ 8 ], 255);
	TextDrawFont(payment_td [ 8 ], 1);
	TextDrawSetProportional(payment_td [ 8 ], 1);
	TextDrawSetShadow(payment_td [ 8 ], 0);

	payment_td [ 9 ] = TextDrawCreate(33.9996, 256.7851, "O"); // пусто
	TextDrawLetterSize(payment_td [ 9 ], 0.8366, 4.6529);
	TextDrawAlignment(payment_td [ 9 ], 1);
	TextDrawColor(payment_td [ 9 ], 977690367);
	TextDrawBackgroundColor(payment_td [ 9 ], 255);
	TextDrawFont(payment_td [ 9 ], 2);
	TextDrawSetProportional(payment_td [ 9 ], 1);
	TextDrawSetShadow(payment_td [ 9 ], 0);

	payment_td [ 10 ] = TextDrawCreate(33.9996, 187.0964, "."); // пусто
	TextDrawLetterSize(payment_td [ 10 ], 2.2411, 13.1898);
	TextDrawAlignment(payment_td [ 10 ], 1);
	TextDrawColor(payment_td [ 10 ], 1112566783);
	TextDrawBackgroundColor(payment_td [ 10 ], 255);
	TextDrawFont(payment_td [ 10 ], 3);
	TextDrawSetProportional(payment_td [ 10 ], 1);
	TextDrawSetShadow(payment_td [ 10 ], 0);

	payment_td [ 11 ] = TextDrawCreate(39.3331, 273.3786, "!"); // пусто
	TextDrawLetterSize(payment_td [ 11 ], 0.4000, 1.6000);
	TextDrawTextSize(payment_td [ 11 ], 0.0000, -3.0000);
	TextDrawAlignment(payment_td [ 11 ], 2);
	TextDrawColor(payment_td [ 11 ], 1870104831);
	TextDrawBackgroundColor(payment_td [ 11 ], 255);
	TextDrawFont(payment_td [ 11 ], 1);
	TextDrawSetProportional(payment_td [ 11 ], 1);
	TextDrawSetShadow(payment_td [ 11 ], 0);

	payment_td [ 12 ] = TextDrawCreate(41.9997, 275.8671, "INFO"); // пусто
	TextDrawLetterSize(payment_td [ 12 ], 0.1419, 0.6915);
	TextDrawTextSize(payment_td [ 12 ], -3.0000, 0.0000);
	TextDrawAlignment(payment_td [ 12 ], 1);
	TextDrawColor(payment_td [ 12 ], 1870104831);
	TextDrawBackgroundColor(payment_td [ 12 ], 255);
	TextDrawFont(payment_td [ 12 ], 1);
	TextDrawSetProportional(payment_td [ 12 ], 1);
	TextDrawSetShadow(payment_td [ 12 ], 0);

	payment_td [ 13 ] = TextDrawCreate(41.9997, 280.4301, "BOX"); // пусто
	TextDrawLetterSize(payment_td [ 13 ], 0.1419, 0.6915);
	TextDrawTextSize(payment_td [ 13 ], -3.0000, 0.0000);
	TextDrawAlignment(payment_td [ 13 ], 1);
	TextDrawColor(payment_td [ 13 ], 1870104831);
	TextDrawBackgroundColor(payment_td [ 13 ], 255);
	TextDrawFont(payment_td [ 13 ], 1);
	TextDrawSetProportional(payment_td [ 13 ], 1);
	TextDrawSetShadow(payment_td [ 13 ], 0);
	
	/* accessories */
	acc_td[0] = TextDrawCreate(252.3666, 394.5629, "ld_spac:white"); // пусто
	TextDrawTextSize(acc_td[0], 124.0000, 45.0000);
	TextDrawAlignment(acc_td[0], 1);
	TextDrawColor(acc_td[0], color_box);
	TextDrawBackgroundColor(acc_td[0], 255);
	TextDrawFont(acc_td[0], 4);
	TextDrawSetProportional(acc_td[0], 0);
	TextDrawSetShadow(acc_td[0], 0);

	acc_td[1] = TextDrawCreate(368.0000, 391.1148, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[1], 17.0000, 21.0000);
	TextDrawAlignment(acc_td[1], 1);
	TextDrawColor(acc_td[1], color_box);
	TextDrawBackgroundColor(acc_td[1], 255);
	TextDrawFont(acc_td[1], 4);
	TextDrawSetProportional(acc_td[1], 0);
	TextDrawSetShadow(acc_td[1], 0);

	acc_td[2] = TextDrawCreate(368.0000, 422.2167, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[2], 17.0000, 21.0000);
	TextDrawAlignment(acc_td[2], 1);
	TextDrawColor(acc_td[2], color_box);
	TextDrawBackgroundColor(acc_td[2], 255);
	TextDrawFont(acc_td[2], 4);
	TextDrawSetProportional(acc_td[2], 0);
	TextDrawSetShadow(acc_td[2], 0);

	acc_td[3] = TextDrawCreate(243.1667, 391.0296, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[3], 17.0000, 21.0000);
	TextDrawAlignment(acc_td[3], 1);
	TextDrawColor(acc_td[3], color_box);
	TextDrawBackgroundColor(acc_td[3], 255);
	TextDrawFont(acc_td[3], 4);
	TextDrawSetProportional(acc_td[3], 0);
	TextDrawSetShadow(acc_td[3], 0);

	acc_td[4] = TextDrawCreate(243.1667, 422.1315, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[4], 17.0000, 21.0000);
	TextDrawAlignment(acc_td[4], 1);
	TextDrawColor(acc_td[4], color_box);
	TextDrawBackgroundColor(acc_td[4], 255);
	TextDrawFont(acc_td[4], 4);
	TextDrawSetProportional(acc_td[4], 0);
	TextDrawSetShadow(acc_td[4], 0);

	acc_td[5] = TextDrawCreate(245.9333, 401.0444, "ld_spac:white"); // пусто
	TextDrawTextSize(acc_td[5], 136.1898, 33.0000);
	TextDrawAlignment(acc_td[5], 1);
	TextDrawColor(acc_td[5], color_box);
	TextDrawBackgroundColor(acc_td[5], 255);
	TextDrawFont(acc_td[5], 4);
	TextDrawSetProportional(acc_td[5], 0);
	TextDrawSetShadow(acc_td[5], 0);

	acc_td[6] = TextDrawCreate(247.6666, 402.5148, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(acc_td[6], 139.0000, 37.0000);
	TextDrawAlignment(acc_td[6], 1);
	TextDrawColor(acc_td[6], color_particle);
	TextDrawBackgroundColor(acc_td[6], 255);
	TextDrawFont(acc_td[6], 4);
	TextDrawSetProportional(acc_td[6], 0);
	TextDrawSetShadow(acc_td[6], 0);

	acc_td[7] = TextDrawCreate(329.0000, 377.2033, "I"); // пусто
	TextDrawLetterSize(acc_td[7], 12.0680, 2.3466);
	TextDrawAlignment(acc_td[7], 2);
	TextDrawColor(acc_td[7], color_textdraw);
	TextDrawBackgroundColor(acc_td[7], 255);
	TextDrawFont(acc_td[7], 1);
	TextDrawSetProportional(acc_td[7], 1);
	TextDrawSetShadow(acc_td[7], 0);

	acc_td[8] = TextDrawCreate(296.4350, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[8], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[8], 1);
	TextDrawColor(acc_td[8], color_box);
	TextDrawBackgroundColor(acc_td[8], 255);
	TextDrawFont(acc_td[8], 4);
	TextDrawSetProportional(acc_td[8], 0);
	TextDrawSetShadow(acc_td[8], 0);

	acc_td[9] = TextDrawCreate(291.1347, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[9], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[9], 1);
	TextDrawColor(acc_td[9], color_box);
	TextDrawBackgroundColor(acc_td[9], 255);
	TextDrawFont(acc_td[9], 4);
	TextDrawSetProportional(acc_td[9], 0);
	TextDrawSetShadow(acc_td[9], 0);

	acc_td[10] = TextDrawCreate(318.3363, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[10], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[10], 1);
	TextDrawColor(acc_td[10], color_box);
	TextDrawBackgroundColor(acc_td[10], 255);
	TextDrawFont(acc_td[10], 4);
	TextDrawSetProportional(acc_td[10], 0);
	TextDrawSetShadow(acc_td[10], 0);

	acc_td[11] = TextDrawCreate(313.0360, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[11], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[11], 1);
	TextDrawColor(acc_td[11], color_box);
	TextDrawBackgroundColor(acc_td[11], 255);
	TextDrawFont(acc_td[11], 4);
	TextDrawSetProportional(acc_td[11], 0);
	TextDrawSetShadow(acc_td[11], 0);

	acc_td[12] = TextDrawCreate(300.8999, 400.4703, "ld_spac:white"); // пусто
	TextDrawTextSize(acc_td[12], 5.0000, 14.4399);
	TextDrawAlignment(acc_td[12], 1);
	TextDrawColor(acc_td[12], color_box);
	TextDrawBackgroundColor(acc_td[12], 255);
	TextDrawFont(acc_td[12], 4);
	TextDrawSetProportional(acc_td[12], 0);
	TextDrawSetShadow(acc_td[12], 0);

	acc_td[13] = TextDrawCreate(322.2332, 400.5556, "ld_spac:white"); // пусто
	TextDrawTextSize(acc_td[13], 5.0000, 14.4399);
	TextDrawAlignment(acc_td[13], 1);
	TextDrawColor(acc_td[13], color_box);
	TextDrawBackgroundColor(acc_td[13], 255);
	TextDrawFont(acc_td[13], 4);
	TextDrawSetProportional(acc_td[13], 0);
	TextDrawSetShadow(acc_td[13], 0);

	acc_td[14] = TextDrawCreate(356.3377, 402.2850, ">>"); // пусто
	TextDrawLetterSize(acc_td[14], 0.1886, 1.2308);
	TextDrawTextSize(acc_td[14], 15.0000, 21.0000);
	TextDrawAlignment(acc_td[14], 2);
	TextDrawColor(acc_td[14], color_box);
	TextDrawUseBox(acc_td[14], 1);
	TextDrawBoxColor(acc_td[14], color_textdraw);
	TextDrawBackgroundColor(acc_td[14], 255);
	TextDrawFont(acc_td[14], 1);
	TextDrawSetProportional(acc_td[14], 1);
	TextDrawSetShadow(acc_td[14], 0);
	TextDrawSetSelectable(acc_td[14], true);

	acc_td[15] = TextDrawCreate(334.3373, 397.1369, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[15], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[15], 1);
	TextDrawColor(acc_td[15], color_textdraw);
	TextDrawBackgroundColor(acc_td[15], 255);
	TextDrawFont(acc_td[15], 4);
	TextDrawSetProportional(acc_td[15], 0);
	TextDrawSetShadow(acc_td[15], 0);

	acc_td[16] = TextDrawCreate(358.0043, 397.2221, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[16], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[16], 1);
	TextDrawColor(acc_td[16], color_textdraw);
	TextDrawBackgroundColor(acc_td[16], 255);
	TextDrawFont(acc_td[16], 4);
	TextDrawSetProportional(acc_td[16], 0);
	TextDrawSetShadow(acc_td[16], 0);

	acc_td[17] = TextDrawCreate(313.2993, 416.4036, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[17], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[17], 1);
	TextDrawColor(acc_td[17], color_textdraw);
	TextDrawBackgroundColor(acc_td[17], 255);
	TextDrawFont(acc_td[17], 4);
	TextDrawSetProportional(acc_td[17], 0);
	TextDrawSetShadow(acc_td[17], 0);

	acc_td[18] = TextDrawCreate(345.0998, 421.5665, "CANCEL"); // пусто
	TextDrawLetterSize(acc_td[18], 0.2766, 1.2058);
	TextDrawTextSize(acc_td[18], 15.0000, 43.0000);
	TextDrawAlignment(acc_td[18], 2);
	TextDrawColor(acc_td[18], color_box);
	TextDrawUseBox(acc_td[18], 1);
	TextDrawBoxColor(acc_td[18], color_textdraw);
	TextDrawBackgroundColor(acc_td[18], 255);
	TextDrawFont(acc_td[18], 1);
	TextDrawSetProportional(acc_td[18], 1);
	TextDrawSetShadow(acc_td[18], 0);
	TextDrawSetSelectable(acc_td[18], true);

	acc_td[19] = TextDrawCreate(358.6327, 416.4888, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[19], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[19], 1);
	TextDrawColor(acc_td[19], color_textdraw);
	TextDrawBackgroundColor(acc_td[19], 255);
	TextDrawFont(acc_td[19], 4);
	TextDrawSetProportional(acc_td[19], 0);
	TextDrawSetShadow(acc_td[19], 0);

	acc_td[20] = TextDrawCreate(272.9998, 402.1068, "<<"); // пусто
	TextDrawLetterSize(acc_td[20], 0.1886, 1.2308);
	TextDrawTextSize(acc_td[20], 15.0000, 20.0000);
	TextDrawAlignment(acc_td[20], 2);
	TextDrawColor(acc_td[20], color_box);
	TextDrawUseBox(acc_td[20], 1);
	TextDrawBoxColor(acc_td[20], color_textdraw);
	TextDrawBackgroundColor(acc_td[20], 255);
	TextDrawFont(acc_td[20], 1);
	TextDrawSetProportional(acc_td[20], 1);
	TextDrawSetShadow(acc_td[20], 0);
	TextDrawSetSelectable(acc_td[20], true);

	acc_td[21] = TextDrawCreate(251.9998, 396.9588, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[21], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[21], 1);
	TextDrawColor(acc_td[21], color_textdraw);
	TextDrawBackgroundColor(acc_td[21], 255);
	TextDrawFont(acc_td[21], 4);
	TextDrawSetProportional(acc_td[21], 0);
	TextDrawSetShadow(acc_td[21], 0);

	acc_td[22] = TextDrawCreate(275.6664, 397.0440, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[22], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[22], 1);
	TextDrawColor(acc_td[22], color_textdraw);
	TextDrawBackgroundColor(acc_td[22], 255);
	TextDrawFont(acc_td[22], 4);
	TextDrawSetProportional(acc_td[22], 0);
	TextDrawSetShadow(acc_td[22], 0);

	acc_td[23] = TextDrawCreate(325.8377, 402.2999, ">"); // пусто
	TextDrawLetterSize(acc_td[23], 0.1886, 1.2308);
	TextDrawTextSize(acc_td[23], 15.0000, 16.0000);
	TextDrawAlignment(acc_td[23], 2);
	TextDrawColor(acc_td[23], color_textdraw);
	TextDrawUseBox(acc_td[23], 1);
	TextDrawBoxColor(acc_td[23], -6619392);
	TextDrawBackgroundColor(acc_td[23], 255);
	TextDrawFont(acc_td[23], 1);
	TextDrawSetProportional(acc_td[23], 1);
	TextDrawSetShadow(acc_td[23], 0);
	TextDrawSetSelectable(acc_td[23], true);

	acc_td[24] = TextDrawCreate(302.9377, 402.2999, "<"); // пусто
	TextDrawLetterSize(acc_td[24], 0.1886, 1.2308);
	TextDrawTextSize(acc_td[24], 15.0000, 16.0000);
	TextDrawAlignment(acc_td[24], 2);
	TextDrawColor(acc_td[24], color_textdraw);
	TextDrawUseBox(acc_td[24], 1);
	TextDrawBoxColor(acc_td[24], -6619392);
	TextDrawBackgroundColor(acc_td[24], 255);
	TextDrawFont(acc_td[24], 1);
	TextDrawSetProportional(acc_td[24], 1);
	TextDrawSetShadow(acc_td[24], 0);
	TextDrawSetSelectable(acc_td[24], true);

	acc_td[25] = TextDrawCreate(251.2328, 416.4036, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[25], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[25], 1);
	TextDrawColor(acc_td[25], color_textdraw);
	TextDrawBackgroundColor(acc_td[25], 255);
	TextDrawFont(acc_td[25], 4);
	TextDrawSetProportional(acc_td[25], 0);
	TextDrawSetShadow(acc_td[25], 0);

	acc_td[26] = TextDrawCreate(283.0326, 421.5665, "SELECT"); // пусто
	TextDrawLetterSize(acc_td[26], 0.2766, 1.2058);
	TextDrawTextSize(acc_td[26], 15.0000, 43.0000);
	TextDrawAlignment(acc_td[26], 2);
	TextDrawColor(acc_td[26], color_box);
	TextDrawUseBox(acc_td[26], 1);
	TextDrawBoxColor(acc_td[26], color_textdraw);
	TextDrawBackgroundColor(acc_td[26], 255);
	TextDrawFont(acc_td[26], 1);
	TextDrawSetProportional(acc_td[26], 1);
	TextDrawSetShadow(acc_td[26], 0);
	TextDrawSetSelectable(acc_td[26], true);

	acc_td[27] = TextDrawCreate(296.5655, 416.4888, "ld_beat:chit"); // пусто
	TextDrawTextSize(acc_td[27], 19.0000, 21.2800);
	TextDrawAlignment(acc_td[27], 1);
	TextDrawColor(acc_td[27], color_textdraw);
	TextDrawBackgroundColor(acc_td[27], 255);
	TextDrawFont(acc_td[27], 4);
	TextDrawSetProportional(acc_td[27], 0);
	TextDrawSetShadow(acc_td[27], 0);
	
/*	green zone */
	zz_td[0] = TextDrawCreate(28.6655, 297.2803, "ld_beat:chit"); // пусто
	TextDrawTextSize(zz_td[0], 9.0000, 10.0000);
	TextDrawAlignment(zz_td[0], 1);
	TextDrawColor(zz_td[0], 522133503);
	TextDrawBackgroundColor(zz_td[0], 255);
	TextDrawFont(zz_td[0], 4);
	TextDrawSetProportional(zz_td[0], 0);
	TextDrawSetShadow(zz_td[0], 0);

	zz_td[1] = TextDrawCreate(28.6655, 324.2437, "ld_beat:chit"); // пусто
	TextDrawTextSize(zz_td[1], 9.0000, 10.0000);
	TextDrawAlignment(zz_td[1], 1);
	TextDrawColor(zz_td[1], 522133503);
	TextDrawBackgroundColor(zz_td[1], 255);
	TextDrawFont(zz_td[1], 4);
	TextDrawSetProportional(zz_td[1], 0);
	TextDrawSetShadow(zz_td[1], 0);

	zz_td[2] = TextDrawCreate(136.3323, 297.2803, "ld_beat:chit"); // пусто
	TextDrawTextSize(zz_td[2], 9.0000, 10.0000);
	TextDrawAlignment(zz_td[2], 1);
	TextDrawColor(zz_td[2], 522133503);
	TextDrawBackgroundColor(zz_td[2], 255);
	TextDrawFont(zz_td[2], 4);
	TextDrawSetProportional(zz_td[2], 0);
	TextDrawSetShadow(zz_td[2], 0);

	zz_td[3] = TextDrawCreate(136.3323, 324.2437, "ld_beat:chit"); // пусто
	TextDrawTextSize(zz_td[3], 9.0000, 10.0000);
	TextDrawAlignment(zz_td[3], 1);
	TextDrawColor(zz_td[3], 522133503);
	TextDrawBackgroundColor(zz_td[3], 255);
	TextDrawFont(zz_td[3], 4);
	TextDrawSetProportional(zz_td[3], 0);
	TextDrawSetShadow(zz_td[3], 0);

	zz_td[4] = TextDrawCreate(33.6659, 298.6252, "ld_spac:white"); // пусто
	TextDrawTextSize(zz_td[4], 107.0000, 34.0000);
	TextDrawAlignment(zz_td[4], 1);
	TextDrawColor(zz_td[4], 522133503);
	TextDrawBackgroundColor(zz_td[4], 255);
	TextDrawFont(zz_td[4], 4);
	TextDrawSetProportional(zz_td[4], 0);
	TextDrawSetShadow(zz_td[4], 0);

	zz_td[5] = TextDrawCreate(29.9991, 302.3587, "ld_spac:white"); // пусто
	TextDrawTextSize(zz_td[5], 114.0000, 26.0000);
	TextDrawAlignment(zz_td[5], 1);
	TextDrawColor(zz_td[5], 522133503);
	TextDrawBackgroundColor(zz_td[5], 255);
	TextDrawFont(zz_td[5], 4);
	TextDrawSetProportional(zz_td[5], 0);
	TextDrawSetShadow(zz_td[5], 0);

	zz_td[6] = TextDrawCreate(30.3323, 299.0401, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(zz_td[6], 113.0000, 33.0000);
	TextDrawAlignment(zz_td[6], 1);
	TextDrawColor(zz_td[6], 1280068728);
	TextDrawBackgroundColor(zz_td[6], 255);
	TextDrawFont(zz_td[6], 4);
	TextDrawSetProportional(zz_td[6], 0);
	TextDrawSetShadow(zz_td[6], 0);

	zz_td[7] = TextDrawCreate(33.9997, 292.0434, "O"); // пусто
	TextDrawLetterSize(zz_td[7], 0.8366, 4.6529);
	TextDrawAlignment(zz_td[7], 1);
	TextDrawColor(zz_td[7], 1583695103);
	TextDrawBackgroundColor(zz_td[7], 255);
	TextDrawFont(zz_td[7], 2);
	TextDrawSetProportional(zz_td[7], 1);
	TextDrawSetShadow(zz_td[7], 0);

	zz_td[8] = TextDrawCreate(33.9997, 222.3553, "."); // пусто
	TextDrawLetterSize(zz_td[8], 2.2411, 13.1898);
	TextDrawAlignment(zz_td[8], 1);
	TextDrawColor(zz_td[8], 1667975423);
	TextDrawBackgroundColor(zz_td[8], 255);
	TextDrawFont(zz_td[8], 3);
	TextDrawSetProportional(zz_td[8], 1);
	TextDrawSetShadow(zz_td[8], 0);

	zz_td[9] = TextDrawCreate(39.3332, 308.2218, "!"); // пусто
	TextDrawLetterSize(zz_td[9], 0.4000, 1.6000);
	TextDrawTextSize(zz_td[9], 0.0000, -3.0000);
	TextDrawAlignment(zz_td[9], 2);
	TextDrawColor(zz_td[9], -1970244353);
	TextDrawBackgroundColor(zz_td[9], 255);
	TextDrawFont(zz_td[9], 1);
	TextDrawSetProportional(zz_td[9], 1);
	TextDrawSetShadow(zz_td[9], 0);

	zz_td[10] = TextDrawCreate(41.9998, 310.7106, "INFO"); // пусто
	TextDrawLetterSize(zz_td[10], 0.1419, 0.6915);
	TextDrawTextSize(zz_td[10], -3.0000, 0.0000);
	TextDrawAlignment(zz_td[10], 1);
	TextDrawColor(zz_td[10], -1970244353);
	TextDrawBackgroundColor(zz_td[10], 255);
	TextDrawFont(zz_td[10], 1);
	TextDrawSetProportional(zz_td[10], 1);
	TextDrawSetShadow(zz_td[10], 0);

	zz_td[11] = TextDrawCreate(59.3330, 314.8591, "GREEN_ZONE"); // пусто
	TextDrawLetterSize(zz_td[11], 0.1972, 0.9236);
	TextDrawAlignment(zz_td[11], 1);
	TextDrawColor(zz_td[11], -1061109505);
	TextDrawBackgroundColor(zz_td[11], 255);
	TextDrawFont(zz_td[11], 1);
	TextDrawSetProportional(zz_td[11], 1);
	TextDrawSetShadow(zz_td[11], 0);

	zz_td[12] = TextDrawCreate(59.6665, 309.4660, "YOU_ENTERED_IN"); // пусто
	TextDrawLetterSize(zz_td[12], 0.1419, 0.6915);
	TextDrawAlignment(zz_td[12], 1);
	TextDrawColor(zz_td[12], -2139062017);
	TextDrawBackgroundColor(zz_td[12], 255);
	TextDrawFont(zz_td[12], 1);
	TextDrawSetProportional(zz_td[12], 1);
	TextDrawSetShadow(zz_td[12], 0);

	zz_td[13] = TextDrawCreate(41.9998, 315.2735, "BOX"); // пусто
	TextDrawLetterSize(zz_td[13], 0.1419, 0.6915);
	TextDrawTextSize(zz_td[13], -3.0000, 0.0000);
	TextDrawAlignment(zz_td[13], 1);
	TextDrawColor(zz_td[13], -1970244353);
	TextDrawBackgroundColor(zz_td[13], 255);
	TextDrawFont(zz_td[13], 1);
	TextDrawSetProportional(zz_td[13], 1);
	TextDrawSetShadow(zz_td[13], 0);
	
	zz_td[14] = TextDrawCreate(128.9999, 313.1994, "10_sek"); // пусто
	TextDrawLetterSize(zz_td[14], 0.1419, 0.6915);
	TextDrawAlignment(zz_td[14], 2);
	TextDrawColor(zz_td[14], 1111638783);
	TextDrawBackgroundColor(zz_td[14], 255);
	TextDrawFont(zz_td[14], 1);
	TextDrawSetProportional(zz_td[14], 1);
	TextDrawSetShadow(zz_td[14], 0);
	
	/* 
	
		non parking td 
		
	*/

	np_td[0] = TextDrawCreate(235.5997, 367.3703, "ld_beat:chit"); // пусто
	TextDrawTextSize(np_td[0], 4.0000, 5.0000);
	TextDrawAlignment(np_td[0], 1);
	TextDrawColor(np_td[0], color_textdraw);
	TextDrawBackgroundColor(np_td[0], 255);
	TextDrawFont(np_td[0], 4);
	TextDrawSetProportional(np_td[0], 0);
	TextDrawSetShadow(np_td[0], 0);

	np_td[1] = TextDrawCreate(233.8995, 371.0036, "ld_beat:chit"); // пусто
	TextDrawTextSize(np_td[1], 2.2297, 3.2699);
	TextDrawAlignment(np_td[1], 1);
	TextDrawColor(np_td[1], color_textdraw);
	TextDrawBackgroundColor(np_td[1], 255);
	TextDrawFont(np_td[1], 4);
	TextDrawSetProportional(np_td[1], 0);
	TextDrawSetShadow(np_td[1], 0);

	np_td[2] = TextDrawCreate(235.3665, 354.9407, "ld_beat:chit"); // пусто
	TextDrawTextSize(np_td[2], 18.0000, 19.0000);
	TextDrawAlignment(np_td[2], 1);
	TextDrawColor(np_td[2], color_textdraw);
	TextDrawBackgroundColor(np_td[2], 255);
	TextDrawFont(np_td[2], 4);
	TextDrawSetProportional(np_td[2], 0);
	TextDrawSetShadow(np_td[2], 0);

	np_td[3] = TextDrawCreate(244.9998, 358.0592, "ld_spac:white"); // пусто
	TextDrawTextSize(np_td[3], 38.0000, 12.7199);
	TextDrawAlignment(np_td[3], 1);
	TextDrawColor(np_td[3], color_textdraw);
	TextDrawBackgroundColor(np_td[3], 255);
	TextDrawFont(np_td[3], 4);
	TextDrawSetProportional(np_td[3], 0);
	TextDrawSetShadow(np_td[3], 0);

	np_td[4] = TextDrawCreate(275.6997, 354.9407, "ld_beat:chit"); // пусто
	TextDrawTextSize(np_td[4], 16.0000, 19.0000);
	TextDrawAlignment(np_td[4], 1);
	TextDrawColor(np_td[4], color_textdraw);
	TextDrawBackgroundColor(np_td[4], 255);
	TextDrawFont(np_td[4], 4);
	TextDrawSetProportional(np_td[4], 0);
	TextDrawSetShadow(np_td[4], 0);

	np_td[5] = TextDrawCreate(244.8999, 360.2886, "NON_PARKING"); // пусто
	TextDrawLetterSize(np_td[5], 0.1429, 0.8159);
	TextDrawAlignment(np_td[5], 1);
	TextDrawColor(np_td[5], color_box);
	TextDrawBackgroundColor(np_td[5], 255);
	TextDrawFont(np_td[5], 2);
	TextDrawSetProportional(np_td[5], 1);
	TextDrawSetShadow(np_td[5], 0);
	
	/*
	
			mafia war
			
	*/
	
	mw_td[0] = TextDrawCreate(11.1999, 218.4666, "ld_spac:white"); // 1 Box
	TextDrawTextSize(mw_td[0], 120.0000, 40.0000);
	TextDrawAlignment(mw_td[0], 1);
	TextDrawColor(mw_td[0], color_black_box);
	TextDrawBackgroundColor(mw_td[0], 255);
	TextDrawFont(mw_td[0], 4);
	TextDrawSetProportional(mw_td[0], 0);
	TextDrawSetShadow(mw_td[0], 0);

	mw_td[1] = TextDrawCreate(11.1332, 209.7555, "ld_spac:white"); // 1 Box
	TextDrawTextSize(mw_td[1], 120.0000, 9.5899);
	TextDrawAlignment(mw_td[1], 1);
	TextDrawColor(mw_td[1], color_textdraw);
	TextDrawBackgroundColor(mw_td[1], 255);
	TextDrawFont(mw_td[1], 4);
	TextDrawSetProportional(mw_td[1], 0);
	TextDrawSetShadow(mw_td[1], 0);

	mw_td[2] = TextDrawCreate(8.6999, 200.2147, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[2], 15.0000, 18.0000);
	TextDrawAlignment(mw_td[2], 1);
	TextDrawColor(mw_td[2], color_textdraw);
	TextDrawBackgroundColor(mw_td[2], 255);
	TextDrawFont(mw_td[2], 4);
	TextDrawSetProportional(mw_td[2], 0);
	TextDrawSetShadow(mw_td[2], 0);

	mw_td[3] = TextDrawCreate(13.1672, 222.9592, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[3], 12.0000, 15.0000);
	TextDrawAlignment(mw_td[3], 1);
	TextDrawColor(mw_td[3], color_box);
	TextDrawBackgroundColor(mw_td[3], 255);
	TextDrawFont(mw_td[3], 4);
	TextDrawSetProportional(mw_td[3], 0);
	TextDrawSetShadow(mw_td[3], 0);

	mw_td[4] = TextDrawCreate(54.7342, 222.9591, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[4], 12.0000, 15.0000);
	TextDrawAlignment(mw_td[4], 1);
	TextDrawColor(mw_td[4], color_box);
	TextDrawBackgroundColor(mw_td[4], 255);
	TextDrawFont(mw_td[4], 4);
	TextDrawSetProportional(mw_td[4], 0);
	TextDrawSetShadow(mw_td[4], 0);

	mw_td[5] = TextDrawCreate(75.4665, 222.9592, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[5], 12.0000, 15.0000);
	TextDrawAlignment(mw_td[5], 1);
	TextDrawColor(mw_td[5], color_box);
	TextDrawBackgroundColor(mw_td[5], 255);
	TextDrawFont(mw_td[5], 4);
	TextDrawSetProportional(mw_td[5], 0);
	TextDrawSetShadow(mw_td[5], 0);

	mw_td[6] = TextDrawCreate(117.0333, 222.9591, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[6], 12.0000, 15.0000);
	TextDrawAlignment(mw_td[6], 1);
	TextDrawColor(mw_td[6], color_box);
	TextDrawBackgroundColor(mw_td[6], 255);
	TextDrawFont(mw_td[6], 4);
	TextDrawSetProportional(mw_td[6], 0);
	TextDrawSetShadow(mw_td[6], 0);

	mw_td[7] = TextDrawCreate(67.5999, 226.7037, "VS"); // 1 Box
	TextDrawLetterSize(mw_td[7], 0.1688, 0.7745);
	TextDrawAlignment(mw_td[7], 1);
	TextDrawColor(mw_td[7], -2139062017);
	TextDrawBackgroundColor(mw_td[7], 255);
	TextDrawFont(mw_td[7], 1);
	TextDrawSetProportional(mw_td[7], 1);
	TextDrawSetShadow(mw_td[7], 0);

	mw_td[8] = TextDrawCreate(14.3332, 253.6857, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(mw_td[8], 117.0000, -10.0000);
	TextDrawAlignment(mw_td[8], 1);
	TextDrawColor(mw_td[8], color_particle);
	TextDrawBackgroundColor(mw_td[8], 255);
	TextDrawFont(mw_td[8], 4);
	TextDrawSetProportional(mw_td[8], 0);
	TextDrawSetShadow(mw_td[8], 0);

	mw_td[9] = TextDrawCreate(118.6999, 200.2147, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[9], 15.0000, 18.0000);
	TextDrawAlignment(mw_td[9], 1);
	TextDrawColor(mw_td[9], color_textdraw);
	TextDrawBackgroundColor(mw_td[9], 255);
	TextDrawFont(mw_td[9], 4);
	TextDrawSetProportional(mw_td[9], 0);
	TextDrawSetShadow(mw_td[9], 0);

	mw_td[10] = TextDrawCreate(16.0665, 203.2184, "ld_spac:white"); // 1 Box
	TextDrawTextSize(mw_td[10], 110.0000, 9.0000);
	TextDrawAlignment(mw_td[10], 1);
	TextDrawColor(mw_td[10], color_textdraw);
	TextDrawBackgroundColor(mw_td[10], 255);
	TextDrawFont(mw_td[10], 4);
	TextDrawSetProportional(mw_td[10], 0);
	TextDrawSetShadow(mw_td[10], 0);

	mw_td[11] = TextDrawCreate(126.1998, 213.9296, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[11], 6.0000, 10.0000);
	TextDrawAlignment(mw_td[11], 1);
	TextDrawColor(mw_td[11], color_textdraw);
	TextDrawBackgroundColor(mw_td[11], 255);
	TextDrawFont(mw_td[11], 4);
	TextDrawSetProportional(mw_td[11], 0);
	TextDrawSetShadow(mw_td[11], 0);

	mw_td[12] = TextDrawCreate(14.3332, 244.8851, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(mw_td[12], 117.0000, 9.0000);
	TextDrawAlignment(mw_td[12], 1);
	TextDrawColor(mw_td[12], 1030548065);
	TextDrawBackgroundColor(mw_td[12], 255);
	TextDrawFont(mw_td[12], 4);
	TextDrawSetProportional(mw_td[12], 0);
	TextDrawSetShadow(mw_td[12], 0);

	mw_td[13] = TextDrawCreate(13.1672, 241.0603, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[13], 12.0000, 15.0000);
	TextDrawAlignment(mw_td[13], 1);
	TextDrawColor(mw_td[13], color_textdraw);
	TextDrawBackgroundColor(mw_td[13], 255);
	TextDrawFont(mw_td[13], 4);
	TextDrawSetProportional(mw_td[13], 0);
	TextDrawSetShadow(mw_td[13], 0);

	mw_td[14] = TextDrawCreate(117.0333, 241.1602, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[14], 12.0000, 15.0000);
	TextDrawAlignment(mw_td[14], 1);
	TextDrawColor(mw_td[14], color_textdraw);
	TextDrawBackgroundColor(mw_td[14], 255);
	TextDrawFont(mw_td[14], 4);
	TextDrawSetProportional(mw_td[14], 0);
	TextDrawSetShadow(mw_td[14], 0);

	mw_td[15] = TextDrawCreate(10.1332, 212.9556, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[15], 6.0000, 10.0000);
	TextDrawAlignment(mw_td[15], 1);
	TextDrawColor(mw_td[15], color_textdraw);
	TextDrawBackgroundColor(mw_td[15], 255);
	TextDrawFont(mw_td[15], 4);
	TextDrawSetProportional(mw_td[15], 0);
	TextDrawSetShadow(mw_td[15], 0);

	mw_td[16] = TextDrawCreate(20.1332, 206.3186, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[16], 6.0000, 17.0000);
	TextDrawAlignment(mw_td[16], 1);
	TextDrawColor(mw_td[16], color_textdraw);
	TextDrawBackgroundColor(mw_td[16], 255);
	TextDrawFont(mw_td[16], 4);
	TextDrawSetProportional(mw_td[16], 0);
	TextDrawSetShadow(mw_td[16], 0);

	mw_td[17] = TextDrawCreate(33.1332, 213.7853, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[17], 6.0000, 8.0000);
	TextDrawAlignment(mw_td[17], 1);
	TextDrawColor(mw_td[17], color_textdraw);
	TextDrawBackgroundColor(mw_td[17], 255);
	TextDrawFont(mw_td[17], 4);
	TextDrawSetProportional(mw_td[17], 0);
	TextDrawSetShadow(mw_td[17], 0);

	mw_td[18] = TextDrawCreate(46.7998, 215.0297, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[18], 7.0000, 6.0000);
	TextDrawAlignment(mw_td[18], 1);
	TextDrawColor(mw_td[18], color_textdraw);
	TextDrawBackgroundColor(mw_td[18], 255);
	TextDrawFont(mw_td[18], 4);
	TextDrawSetProportional(mw_td[18], 0);
	TextDrawSetShadow(mw_td[18], 0);

	mw_td[19] = TextDrawCreate(113.4665, 215.0298, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[19], 6.0000, 6.0000);
	TextDrawAlignment(mw_td[19], 1);
	TextDrawColor(mw_td[19], color_textdraw);
	TextDrawBackgroundColor(mw_td[19], 255);
	TextDrawFont(mw_td[19], 4);
	TextDrawSetProportional(mw_td[19], 0);
	TextDrawSetShadow(mw_td[19], 0);

	mw_td[20] = TextDrawCreate(101.4665, 213.7297, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[20], 6.0000, 9.0000);
	TextDrawAlignment(mw_td[20], 1);
	TextDrawColor(mw_td[20], color_textdraw);
	TextDrawBackgroundColor(mw_td[20], 255);
	TextDrawFont(mw_td[20], 4);
	TextDrawSetProportional(mw_td[20], 0);
	TextDrawSetShadow(mw_td[20], 0);

	mw_td[21] = TextDrawCreate(85.9665, 214.2001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[21], 6.0000, 7.0000);
	TextDrawAlignment(mw_td[21], 1);
	TextDrawColor(mw_td[21], color_textdraw);
	TextDrawBackgroundColor(mw_td[21], 255);
	TextDrawFont(mw_td[21], 4);
	TextDrawSetProportional(mw_td[21], 0);
	TextDrawSetShadow(mw_td[21], 0);

	mw_td[22] = TextDrawCreate(73.8998, 214.2001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[22], 5.0000, 8.0000);
	TextDrawAlignment(mw_td[22], 1);
	TextDrawColor(mw_td[22], color_textdraw);
	TextDrawBackgroundColor(mw_td[22], 255);
	TextDrawFont(mw_td[22], 4);
	TextDrawSetProportional(mw_td[22], 0);
	TextDrawSetShadow(mw_td[22], 0);

	mw_td[23] = TextDrawCreate(58.9665, 213.8001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(mw_td[23], 7.0000, 8.0000);
	TextDrawAlignment(mw_td[23], 1);
	TextDrawColor(mw_td[23], color_textdraw);
	TextDrawBackgroundColor(mw_td[23], 255);
	TextDrawFont(mw_td[23], 4);
	TextDrawSetProportional(mw_td[23], 0);
	TextDrawSetShadow(mw_td[23], 0);

	mw_td[24] = TextDrawCreate(10.3332, 202.2888, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(mw_td[24], 124.0000, 17.0000);
	TextDrawAlignment(mw_td[24], 1);
	TextDrawColor(mw_td[24], -234);
	TextDrawBackgroundColor(mw_td[24], 255);
	TextDrawFont(mw_td[24], 4);
	TextDrawSetProportional(mw_td[24], 0);
	TextDrawSetShadow(mw_td[24], 0);

	mw_td[25] = TextDrawCreate(56.2999, 207.0074, "BIZWAR"); // 1 Box
	TextDrawLetterSize(mw_td[25], 0.2009, 0.8947);
	TextDrawAlignment(mw_td[25], 1);
	TextDrawColor(mw_td[25], -1);
	TextDrawBackgroundColor(mw_td[25], 255);
	TextDrawFont(mw_td[25], 1);
	TextDrawSetProportional(mw_td[25], 1);
	TextDrawSetShadow(mw_td[25], 0);

	mw_td[26] = TextDrawCreate(11.1999, 261.9692, "ld_spac:white"); // 2 Box
	TextDrawTextSize(mw_td[26], 120.0000, 27.0000);
	TextDrawAlignment(mw_td[26], 1);
	TextDrawColor(mw_td[26], color_black_box);
	TextDrawBackgroundColor(mw_td[26], 255);
	TextDrawFont(mw_td[26], 4);
	TextDrawSetProportional(mw_td[26], 0);
	TextDrawSetShadow(mw_td[26], 0);

	mw_td[27] = TextDrawCreate(13.1672, 272.2622, "ld_beat:chit"); // 2 Box
	TextDrawTextSize(mw_td[27], 12.0000, 15.0000);
	TextDrawAlignment(mw_td[27], 1);
	TextDrawColor(mw_td[27], color_textdraw);
	TextDrawBackgroundColor(mw_td[27], 255);
	TextDrawFont(mw_td[27], 4);
	TextDrawSetProportional(mw_td[27], 0);
	TextDrawSetShadow(mw_td[27], 0);

	mw_td[28] = TextDrawCreate(117.0333, 272.3620, "ld_beat:chit"); // 2 Box
	TextDrawTextSize(mw_td[28], 12.0000, 15.0000);
	TextDrawAlignment(mw_td[28], 1);
	TextDrawColor(mw_td[28], color_textdraw);
	TextDrawBackgroundColor(mw_td[28], 255);
	TextDrawFont(mw_td[28], 4);
	TextDrawSetProportional(mw_td[28], 0);
	TextDrawSetShadow(mw_td[28], 0);

	mw_td[29] = TextDrawCreate(14.3332, 284.8875, "particle:lamp_shad_64"); // 2 Box
	TextDrawTextSize(mw_td[29], 117.0000, -10.0000);
	TextDrawAlignment(mw_td[29], 1);
	TextDrawColor(mw_td[29], color_particle);
	TextDrawBackgroundColor(mw_td[29], 255);
	TextDrawFont(mw_td[29], 4);
	TextDrawSetProportional(mw_td[29], 0);
	TextDrawSetShadow(mw_td[29], 0);

	mw_td[30] = TextDrawCreate(14.3332, 276.0870, "particle:lamp_shad_64"); // 2 Box
	TextDrawTextSize(mw_td[30], 117.0000, 9.0000);
	TextDrawAlignment(mw_td[30], 1);
	TextDrawColor(mw_td[30], 1030548065);
	TextDrawBackgroundColor(mw_td[30], 255);
	TextDrawFont(mw_td[30], 4);
	TextDrawSetProportional(mw_td[30], 0);
	TextDrawSetShadow(mw_td[30], 0);

	mw_td[31] = TextDrawCreate(44.8332, 264.4813, "PERSONAL_STATISTIC~n~"); // 2 Box
	TextDrawLetterSize(mw_td[31], 0.1636, 0.7869);
	TextDrawAlignment(mw_td[31], 1);
	TextDrawColor(mw_td[31], -1);
	TextDrawBackgroundColor(mw_td[31], 67);
	TextDrawFont(mw_td[31], 1);
	TextDrawSetProportional(mw_td[31], 1);
	TextDrawSetShadow(mw_td[31], 1);

	mw_td[32] = TextDrawCreate(11.1999, 292.1710, "ld_spac:white"); // 3 Box
	TextDrawTextSize(mw_td[32], 120.0000, 21.0000);
	TextDrawAlignment(mw_td[32], 1);
	TextDrawColor(mw_td[32], color_black_box);
	TextDrawBackgroundColor(mw_td[32], 255);
	TextDrawFont(mw_td[32], 4);
	TextDrawSetProportional(mw_td[32], 0);
	TextDrawSetShadow(mw_td[32], 0);

	mw_td[33] = TextDrawCreate(8.9666, 304.6155, "ld_beat:chit"); // 3 Box
	TextDrawTextSize(mw_td[33], 14.0000, 17.0000);
	TextDrawAlignment(mw_td[33], 1);
	TextDrawColor(mw_td[33], color_black_box);
	TextDrawBackgroundColor(mw_td[33], 255);
	TextDrawFont(mw_td[33], 4);
	TextDrawSetProportional(mw_td[33], 0);
	TextDrawSetShadow(mw_td[33], 0);

	mw_td[34] = TextDrawCreate(119.6001, 304.6155, "ld_beat:chit"); // 3 Box
	TextDrawTextSize(mw_td[34], 14.0000, 17.0000);
	TextDrawAlignment(mw_td[34], 1);
	TextDrawColor(mw_td[34], color_black_box);
	TextDrawBackgroundColor(mw_td[34], 255);
	TextDrawFont(mw_td[34], 4);
	TextDrawSetProportional(mw_td[34], 0);
	TextDrawSetShadow(mw_td[34], 0);

	mw_td[35] = TextDrawCreate(16.1999, 307.6518, "ld_spac:white"); // 3 Box
	TextDrawTextSize(mw_td[35], 111.0000, 11.0000);
	TextDrawAlignment(mw_td[35], 1);
	TextDrawColor(mw_td[35], color_black_box);
	TextDrawBackgroundColor(mw_td[35], 255);
	TextDrawFont(mw_td[35], 4);
	TextDrawSetProportional(mw_td[35], 0);
	TextDrawSetShadow(mw_td[35], 0);

	mw_td[36] = TextDrawCreate(6.6666, 306.7100, "particle:lamp_shad_64"); // 3 Box
	TextDrawTextSize(mw_td[36], 132.0000, 12.0000);
	TextDrawAlignment(mw_td[36], 1);
	TextDrawColor(mw_td[36], color_particle);
	TextDrawBackgroundColor(mw_td[36], 255);
	TextDrawFont(mw_td[36], 4);
	TextDrawSetProportional(mw_td[36], 0);
	TextDrawSetShadow(mw_td[36], 0);

	mw_td[37] = TextDrawCreate(37.4999, 294.9832, "BEST_PLAYERS_OF_BIZWAR"); // 3 Box
	TextDrawLetterSize(mw_td[37], 0.1636, 0.7869);
	TextDrawAlignment(mw_td[37], 1);
	TextDrawColor(mw_td[37], -1);
	TextDrawBackgroundColor(mw_td[37], 67);
	TextDrawFont(mw_td[37], 1);
	TextDrawSetProportional(mw_td[37], 1);
	TextDrawSetShadow(mw_td[37], 1);

	/*
	
		Work Status
	
	*/
	
	workstatus_td [ 0 ] = TextDrawCreate(455.7055, 370.8330, "ld_beat:chit"); // pink
	TextDrawTextSize(workstatus_td [ 0 ], 26.0000, 29.0000);
	TextDrawAlignment(workstatus_td [ 0 ], 1);
	TextDrawColor(workstatus_td [ 0 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 0 ], 255);
	TextDrawFont(workstatus_td [ 0 ], 4);
	TextDrawSetProportional(workstatus_td [ 0 ], 0);
	TextDrawSetShadow(workstatus_td [ 0 ], 0);

	workstatus_td [ 1 ] = TextDrawCreate(455.7055, 413.4356, "ld_beat:chit"); // pink
	TextDrawTextSize(workstatus_td [ 1 ], 26.0000, 29.0000);
	TextDrawAlignment(workstatus_td [ 1 ], 1);
	TextDrawColor(workstatus_td [ 1 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 1 ], 255);
	TextDrawFont(workstatus_td [ 1 ], 4);
	TextDrawSetProportional(workstatus_td [ 1 ], 0);
	TextDrawSetShadow(workstatus_td [ 1 ], 0);

	workstatus_td [ 2 ] = TextDrawCreate(390.5346, 385.0775, "ld_spac:white"); // pink
	TextDrawTextSize(workstatus_td [ 2 ], 87.0000, 41.0000);
	TextDrawAlignment(workstatus_td [ 2 ], 1);
	TextDrawColor(workstatus_td [ 2 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 2 ], 255);
	TextDrawFont(workstatus_td [ 2 ], 4);
	TextDrawSetProportional(workstatus_td [ 2 ], 0);
	TextDrawSetShadow(workstatus_td [ 2 ], 0);

	workstatus_td [ 3 ] = TextDrawCreate(386.2015, 370.8330, "ld_beat:chit"); // pink
	TextDrawTextSize(workstatus_td [ 3 ], 26.0000, 29.0000);
	TextDrawAlignment(workstatus_td [ 3 ], 1);
	TextDrawColor(workstatus_td [ 3 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 3 ], 255);
	TextDrawFont(workstatus_td [ 3 ], 4);
	TextDrawSetProportional(workstatus_td [ 3 ], 0);
	TextDrawSetShadow(workstatus_td [ 3 ], 0);

	workstatus_td [ 4 ] = TextDrawCreate(386.2015, 413.4356, "ld_beat:chit"); // pink
	TextDrawTextSize(workstatus_td [ 4 ], 26.0000, 29.0000);
	TextDrawAlignment(workstatus_td [ 4 ], 1);
	TextDrawColor(workstatus_td [ 4 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 4 ], 255);
	TextDrawFont(workstatus_td [ 4 ], 4);
	TextDrawSetProportional(workstatus_td [ 4 ], 0);
	TextDrawSetShadow(workstatus_td [ 4 ], 0);

	workstatus_td [ 5 ] = TextDrawCreate(387.2015, 370.8330, "ld_beat:chit"); // пусто
	TextDrawTextSize(workstatus_td [ 5 ], 26.0000, 29.0000);
	TextDrawAlignment(workstatus_td [ 5 ], 1);
	TextDrawColor(workstatus_td [ 5 ], color_box);
	TextDrawBackgroundColor(workstatus_td [ 5 ], 255);
	TextDrawFont(workstatus_td [ 5 ], 4);
	TextDrawSetProportional(workstatus_td [ 5 ], 0);
	TextDrawSetShadow(workstatus_td [ 5 ], 0);

	workstatus_td [ 6 ] = TextDrawCreate(387.2015, 413.4356, "ld_beat:chit"); // пусто
	TextDrawTextSize(workstatus_td [ 6 ], 26.0000, 29.0000);
	TextDrawAlignment(workstatus_td [ 6 ], 1);
	TextDrawColor(workstatus_td [ 6 ], color_box);
	TextDrawBackgroundColor(workstatus_td [ 6 ], 255);
	TextDrawFont(workstatus_td [ 6 ], 4);
	TextDrawSetProportional(workstatus_td [ 6 ], 0);
	TextDrawSetShadow(workstatus_td [ 6 ], 0);

	workstatus_td [ 7 ] = TextDrawCreate(454.7055, 370.8330, "ld_beat:chit"); // пусто
	TextDrawTextSize(workstatus_td [ 7 ], 26.0000, 29.0000);
	TextDrawAlignment(workstatus_td [ 7 ], 1);
	TextDrawColor(workstatus_td [ 7 ], color_box);
	TextDrawBackgroundColor(workstatus_td [ 7 ], 255);
	TextDrawFont(workstatus_td [ 7 ], 4);
	TextDrawSetProportional(workstatus_td [ 7 ], 0);
	TextDrawSetShadow(workstatus_td [ 7 ], 0);

	workstatus_td [ 8 ] = TextDrawCreate(454.7055, 413.4356, "ld_beat:chit"); // пусто
	TextDrawTextSize(workstatus_td [ 8 ], 26.0000, 29.0000);
	TextDrawAlignment(workstatus_td [ 8 ], 1);
	TextDrawColor(workstatus_td [ 8 ], color_box);
	TextDrawBackgroundColor(workstatus_td [ 8 ], 255);
	TextDrawFont(workstatus_td [ 8 ], 4);
	TextDrawSetProportional(workstatus_td [ 8 ], 0);
	TextDrawSetShadow(workstatus_td [ 8 ], 0);

	workstatus_td [ 9 ] = TextDrawCreate(401.4331, 375.5963, "ld_spac:white"); // пусто
	TextDrawTextSize(workstatus_td [ 9 ], 67.0000, 62.0097);
	TextDrawAlignment(workstatus_td [ 9 ], 1);
	TextDrawColor(workstatus_td [ 9 ], color_box);
	TextDrawBackgroundColor(workstatus_td [ 9 ], 255);
	TextDrawFont(workstatus_td [ 9 ], 4);
	TextDrawSetProportional(workstatus_td [ 9 ], 0);
	TextDrawSetShadow(workstatus_td [ 9 ], 0);

	workstatus_td [ 10 ] = TextDrawCreate(391.3999, 385.7369, "ld_spac:white"); // пусто
	TextDrawTextSize(workstatus_td [ 10 ], 85.0000, 41.0000);
	TextDrawAlignment(workstatus_td [ 10 ], 1);
	TextDrawColor(workstatus_td [ 10 ], color_box);
	TextDrawBackgroundColor(workstatus_td [ 10 ], 255);
	TextDrawFont(workstatus_td [ 10 ], 4);
	TextDrawSetProportional(workstatus_td [ 10 ], 0);
	TextDrawSetShadow(workstatus_td [ 10 ], 0);

	workstatus_td [ 11 ] = TextDrawCreate(403.3663, 418.8940, "ld_spac:white"); // пусто
	TextDrawTextSize(workstatus_td [ 11 ], 26.0000, 1.0000);
	TextDrawAlignment(workstatus_td [ 11 ], 1);
	TextDrawColor(workstatus_td [ 11 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 11 ], 255);
	TextDrawFont(workstatus_td [ 11 ], 4);
	TextDrawSetProportional(workstatus_td [ 11 ], 0);
	TextDrawSetShadow(workstatus_td [ 11 ], 0);

	workstatus_td [ 12 ] = TextDrawCreate(440.0332, 418.8940, "ld_spac:white"); // пусто
	TextDrawTextSize(workstatus_td [ 12 ], 26.0000, 1.0000);
	TextDrawAlignment(workstatus_td [ 12 ], 1);
	TextDrawColor(workstatus_td [ 12 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 12 ], 255);
	TextDrawFont(workstatus_td [ 12 ], 4);
	TextDrawSetProportional(workstatus_td [ 12 ], 0);
	TextDrawSetShadow(workstatus_td [ 12 ], 0);

	workstatus_td [ 13 ] = TextDrawCreate(403.3330, 394.7630, "ld_spac:white"); // пусто
	TextDrawTextSize(workstatus_td [ 13 ], 26.0000, 1.0000);
	TextDrawAlignment(workstatus_td [ 13 ], 1);
	TextDrawColor(workstatus_td [ 13 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 13 ], 255);
	TextDrawFont(workstatus_td [ 13 ], 4);
	TextDrawSetProportional(workstatus_td [ 13 ], 0);
	TextDrawSetShadow(workstatus_td [ 13 ], 0);

	workstatus_td [ 14 ] = TextDrawCreate(440.0000, 394.7629, "ld_spac:white"); // пусто
	TextDrawTextSize(workstatus_td [ 14 ], 26.0000, 1.0000);
	TextDrawAlignment(workstatus_td [ 14 ], 1);
	TextDrawColor(workstatus_td [ 14 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 14 ], 255);
	TextDrawFont(workstatus_td [ 14 ], 4);
	TextDrawSetProportional(workstatus_td [ 14 ], 0);
	TextDrawSetShadow(workstatus_td [ 14 ], 0);

	workstatus_td [ 15 ] = TextDrawCreate(392.8669, 401.4703, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(workstatus_td [ 15 ], 89.0000, 36.0000);
	TextDrawAlignment(workstatus_td [ 15 ], 1);
	TextDrawColor(workstatus_td [ 15 ], color_particle);
	TextDrawBackgroundColor(workstatus_td [ 15 ], 255);
	TextDrawFont(workstatus_td [ 15 ], 4);
	TextDrawSetProportional(workstatus_td [ 15 ], 0);
	TextDrawSetShadow(workstatus_td [ 15 ], 0);

	workstatus_td [ 16 ] = TextDrawCreate(415.8666, 385.7926, "TIME"); // пусто
	TextDrawLetterSize(workstatus_td [ 16 ], 0.1448, 0.8615);
	TextDrawAlignment(workstatus_td [ 16 ], 2);
	TextDrawColor(workstatus_td [ 16 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 16 ], 255);
	TextDrawFont(workstatus_td [ 16 ], 2);
	TextDrawSetProportional(workstatus_td [ 16 ], 1);
	TextDrawSetShadow(workstatus_td [ 16 ], 0);

	workstatus_td [ 17 ] = TextDrawCreate(452.9670, 384.9630, "ACTIVE"); // пусто
	TextDrawLetterSize(workstatus_td [ 17 ], 0.1448, 0.8615);
	TextDrawAlignment(workstatus_td [ 17 ], 2);
	TextDrawColor(workstatus_td [ 17 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 17 ], 255);
	TextDrawFont(workstatus_td [ 17 ], 2);
	TextDrawSetProportional(workstatus_td [ 17 ], 1);
	TextDrawSetShadow(workstatus_td [ 17 ], 0);

	workstatus_td [ 18 ] = TextDrawCreate(416.3337, 409.5520, "EARNED"); // пусто
	TextDrawLetterSize(workstatus_td [ 18 ], 0.1448, 0.8615);
	TextDrawAlignment(workstatus_td [ 18 ], 2);
	TextDrawColor(workstatus_td [ 18 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 18 ], 255);
	TextDrawFont(workstatus_td [ 18 ], 2);
	TextDrawSetProportional(workstatus_td [ 18 ], 1);
	TextDrawSetShadow(workstatus_td [ 18 ], 0);

	workstatus_td [ 19 ] = TextDrawCreate(453.3337, 409.5519, "ALL"); // пусто
	TextDrawLetterSize(workstatus_td [ 19 ], 0.1448, 0.8615);
	TextDrawAlignment(workstatus_td [ 19 ], 2);
	TextDrawColor(workstatus_td [ 19 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 19 ], 255);
	TextDrawFont(workstatus_td [ 19 ], 2);
	TextDrawSetProportional(workstatus_td [ 19 ], 1);
	TextDrawSetShadow(workstatus_td [ 19 ], 0);

	workstatus_td [ 20 ] = TextDrawCreate(398.5086, 369.6888, "ld_beat:chit"); // пусто
	TextDrawTextSize(workstatus_td [ 20 ], 3.1398, 4.0000);
	TextDrawAlignment(workstatus_td [ 20 ], 1);
	TextDrawColor(workstatus_td [ 20 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 20 ], 255);
	TextDrawFont(workstatus_td [ 20 ], 4);
	TextDrawSetProportional(workstatus_td [ 20 ], 0);
	TextDrawSetShadow(workstatus_td [ 20 ], 0);

	workstatus_td [ 21 ] = TextDrawCreate(400.5086, 365.5407, "ld_beat:chit"); // пусто
	TextDrawTextSize(workstatus_td [ 21 ], 5.0000, 6.0000);
	TextDrawAlignment(workstatus_td [ 21 ], 1);
	TextDrawColor(workstatus_td [ 21 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 21 ], 255);
	TextDrawFont(workstatus_td [ 21 ], 4);
	TextDrawSetProportional(workstatus_td [ 21 ], 0);
	TextDrawSetShadow(workstatus_td [ 21 ], 0);

	workstatus_td [ 22 ] = TextDrawCreate(402.1748, 355.5851, "ld_beat:chit"); // пусто
	TextDrawTextSize(workstatus_td [ 22 ], 15.0000, 18.0000);
	TextDrawAlignment(workstatus_td [ 22 ], 1);
	TextDrawColor(workstatus_td [ 22 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 22 ], 255);
	TextDrawFont(workstatus_td [ 22 ], 4);
	TextDrawSetProportional(workstatus_td [ 22 ], 0);
	TextDrawSetShadow(workstatus_td [ 22 ], 0);

	workstatus_td [ 23 ] = TextDrawCreate(440.2774, 355.5851, "ld_beat:chit"); // пусто
	TextDrawTextSize(workstatus_td [ 23 ], 15.0000, 18.0000);
	TextDrawAlignment(workstatus_td [ 23 ], 1);
	TextDrawColor(workstatus_td [ 23 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 23 ], 255);
	TextDrawFont(workstatus_td [ 23 ], 4);
	TextDrawSetProportional(workstatus_td [ 23 ], 0);
	TextDrawSetShadow(workstatus_td [ 23 ], 0);

	workstatus_td [ 24 ] = TextDrawCreate(409.4414, 358.6036, "ld_spac:white"); // пусто
	TextDrawTextSize(workstatus_td [ 24 ], 38.0000, 12.0000);
	TextDrawAlignment(workstatus_td [ 24 ], 1);
	TextDrawColor(workstatus_td [ 24 ], color_textdraw);
	TextDrawBackgroundColor(workstatus_td [ 24 ], 255);
	TextDrawFont(workstatus_td [ 24 ], 4);
	TextDrawSetProportional(workstatus_td [ 24 ], 0);
	TextDrawSetShadow(workstatus_td [ 24 ], 0);

	workstatus_td [ 25 ] = TextDrawCreate(408.2749, 360.0887, "WORK_STATUS"); // пусто
	TextDrawLetterSize(workstatus_td [ 25 ], 0.1465, 0.8948);
	TextDrawAlignment(workstatus_td [ 25 ], 1);
	TextDrawColor(workstatus_td [ 25 ], color_box);
	TextDrawBackgroundColor(workstatus_td [ 25 ], 255);
	TextDrawFont(workstatus_td [ 25 ], 2);
	TextDrawSetProportional(workstatus_td [ 25 ], 1);
	TextDrawSetShadow(workstatus_td [ 25 ], 0);

	
	/*
	
		speedometr
	
	*/
	
	td_sp [ 0 ] = TextDrawCreate(239.3332, 375.6813, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 0 ], 51.0000, 61.0000);
	TextDrawAlignment(td_sp [ 0 ], 1);
	TextDrawColor(td_sp [ 0 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 0 ], 255);
	TextDrawFont(td_sp [ 0 ], 4);
	TextDrawSetProportional(td_sp [ 0 ], 0);
	TextDrawSetShadow(td_sp [ 0 ], 0);

	td_sp [ 1 ] = TextDrawCreate(228.0666, 371.3182, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 1 ], 21.0000, 26.0000);
	TextDrawAlignment(td_sp [ 1 ], 1);
	TextDrawColor(td_sp [ 1 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 1 ], 255);
	TextDrawFont(td_sp [ 1 ], 4);
	TextDrawSetProportional(td_sp [ 1 ], 0);
	TextDrawSetShadow(td_sp [ 1 ], 0);

	td_sp [ 2 ] = TextDrawCreate(228.1665, 415.0212, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 2 ], 21.0000, 26.0000);
	TextDrawAlignment(td_sp [ 2 ], 1);
	TextDrawColor(td_sp [ 2 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 2 ], 255);
	TextDrawFont(td_sp [ 2 ], 4);
	TextDrawSetProportional(td_sp [ 2 ], 0);
	TextDrawSetShadow(td_sp [ 2 ], 0);

	td_sp [ 3 ] = TextDrawCreate(231.6999, 385.2814, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 3 ], 46.0000, 43.0000);
	TextDrawAlignment(td_sp [ 3 ], 1);
	TextDrawColor(td_sp [ 3 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 3 ], 255);
	TextDrawFont(td_sp [ 3 ], 4);
	TextDrawSetProportional(td_sp [ 3 ], 0);
	TextDrawSetShadow(td_sp [ 3 ], 0);

	td_sp [ 4 ] = TextDrawCreate(260.6669, 399.0419, "KM/H"); // пусто
	TextDrawLetterSize(td_sp [ 4 ], 0.1770, 0.9527);
	TextDrawAlignment(td_sp [ 4 ], 2);
	TextDrawColor(td_sp [ 4 ], color_server);
	TextDrawBackgroundColor(td_sp [ 4 ], 255);
	TextDrawFont(td_sp [ 4 ], 1);
	TextDrawSetProportional(td_sp [ 4 ], 1);
	TextDrawSetShadow(td_sp [ 4 ], 0);

	td_sp [ 5 ] = TextDrawCreate(260.9667, 420.7431, "MILEAGE"); // пусто
	TextDrawLetterSize(td_sp [ 5 ], 0.1770, 0.9527);
	TextDrawAlignment(td_sp [ 5 ], 2);
	TextDrawColor(td_sp [ 5 ], color_server);
	TextDrawBackgroundColor(td_sp [ 5 ], 255);
	TextDrawFont(td_sp [ 5 ], 1);
	TextDrawSetProportional(td_sp [ 5 ], 1);
	TextDrawSetShadow(td_sp [ 5 ], 0);

	td_sp [ 6 ] = TextDrawCreate(290.1333, 375.6109, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 6 ], 83.0000, 62.0000);
	TextDrawAlignment(td_sp [ 6 ], 1);
	TextDrawColor(td_sp [ 6 ], color_box);
	TextDrawBackgroundColor(td_sp [ 6 ], 255);
	TextDrawFont(td_sp [ 6 ], 4);
	TextDrawSetProportional(td_sp [ 6 ], 0);
	TextDrawSetShadow(td_sp [ 6 ], 0);

	td_sp [ 7 ] = TextDrawCreate(361.1000, 370.8330, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 7 ], 26.0000, 29.0000);
	TextDrawAlignment(td_sp [ 7 ], 1);
	TextDrawColor(td_sp [ 7 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 7 ], 255);
	TextDrawFont(td_sp [ 7 ], 4);
	TextDrawSetProportional(td_sp [ 7 ], 0);
	TextDrawSetShadow(td_sp [ 7 ], 0);

	td_sp [ 8 ] = TextDrawCreate(361.1000, 413.4356, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 8 ], 26.0000, 29.0000);
	TextDrawAlignment(td_sp [ 8 ], 1);
	TextDrawColor(td_sp [ 8 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 8 ], 255);
	TextDrawFont(td_sp [ 8 ], 4);
	TextDrawSetProportional(td_sp [ 8 ], 0);
	TextDrawSetShadow(td_sp [ 8 ], 0);

	td_sp [ 9 ] = TextDrawCreate(314.8666, 385.4924, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 9 ], 68.0000, 43.0000);
	TextDrawAlignment(td_sp [ 9 ], 1);
	TextDrawColor(td_sp [ 9 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 9 ], 255);
	TextDrawFont(td_sp [ 9 ], 4);
	TextDrawSetProportional(td_sp [ 9 ], 0);
	TextDrawSetShadow(td_sp [ 9 ], 0);

	td_sp [ 10 ] = TextDrawCreate(360.2998, 370.8330, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 10 ], 26.0000, 29.0000);
	TextDrawAlignment(td_sp [ 10 ], 1);
	TextDrawColor(td_sp [ 10 ], color_box);
	TextDrawBackgroundColor(td_sp [ 10 ], 255);
	TextDrawFont(td_sp [ 10 ], 4);
	TextDrawSetProportional(td_sp [ 10 ], 0);
	TextDrawSetShadow(td_sp [ 10 ], 0);

	td_sp [ 11 ] = TextDrawCreate(360.2998, 413.3356, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 11 ], 26.0000, 29.0000);
	TextDrawAlignment(td_sp [ 11 ], 1);
	TextDrawColor(td_sp [ 11 ], color_box);
	TextDrawBackgroundColor(td_sp [ 11 ], 255);
	TextDrawFont(td_sp [ 11 ], 4);
	TextDrawSetProportional(td_sp [ 11 ], 0);
	TextDrawSetShadow(td_sp [ 11 ], 0);

	td_sp [ 12 ] = TextDrawCreate(313.8663, 384.3742, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 12 ], 68.0000, 45.0000);
	TextDrawAlignment(td_sp [ 12 ], 1);
	TextDrawColor(td_sp [ 12 ], color_box);
	TextDrawBackgroundColor(td_sp [ 12 ], 255);
	TextDrawFont(td_sp [ 12 ], 4);
	TextDrawSetProportional(td_sp [ 12 ], 0);
	TextDrawSetShadow(td_sp [ 12 ], 0);

	td_sp [ 13 ] = TextDrawCreate(300.0999, 381.8309, "ENGINE"); // пусто
	TextDrawLetterSize(td_sp [ 13 ], 0.1990, 1.0025);
	TextDrawAlignment(td_sp [ 13 ], 1);
	TextDrawColor(td_sp [ 13 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 13 ], 255);
	TextDrawFont(td_sp [ 13 ], 1);
	TextDrawSetProportional(td_sp [ 13 ], 1);
	TextDrawSetShadow(td_sp [ 13 ], 0);

	td_sp [ 14 ] = TextDrawCreate(327.5664, 381.8309, "LIGHT"); // пусто
	TextDrawLetterSize(td_sp [ 14 ], 0.1990, 1.0025);
	TextDrawAlignment(td_sp [ 14 ], 1);
	TextDrawColor(td_sp [ 14 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 14 ], 255);
	TextDrawFont(td_sp [ 14 ], 1);
	TextDrawSetProportional(td_sp [ 14 ], 1);
	TextDrawSetShadow(td_sp [ 14 ], 0);

	td_sp [ 15 ] = TextDrawCreate(350.7668, 381.8309, "DOORS"); // пусто
	TextDrawLetterSize(td_sp [ 15 ], 0.1990, 1.0025);
	TextDrawAlignment(td_sp [ 15 ], 1);
	TextDrawColor(td_sp [ 15 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 15 ], 255);
	TextDrawFont(td_sp [ 15 ], 1);
	TextDrawSetProportional(td_sp [ 15 ], 1);
	TextDrawSetShadow(td_sp [ 15 ], 0);

	td_sp [ 16 ] = TextDrawCreate(368.2998, 375.9963, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 16 ], 4.0798, 7.0000);
	TextDrawAlignment(td_sp [ 16 ], 1);
	TextDrawColor(td_sp [ 16 ], color_box);
	TextDrawBackgroundColor(td_sp [ 16 ], 255);
	TextDrawFont(td_sp [ 16 ], 4);
	TextDrawSetProportional(td_sp [ 16 ], 0);
	TextDrawSetShadow(td_sp [ 16 ], 0);

	td_sp [ 17 ] = TextDrawCreate(368.9666, 430.5516, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 17 ], 4.0798, 7.0000);
	TextDrawAlignment(td_sp [ 17 ], 1);
	TextDrawColor(td_sp [ 17 ], color_box);
	TextDrawBackgroundColor(td_sp [ 17 ], 255);
	TextDrawFont(td_sp [ 17 ], 4);
	TextDrawSetProportional(td_sp [ 17 ], 0);
	TextDrawSetShadow(td_sp [ 17 ], 0);

	td_sp [ 18 ] = TextDrawCreate(327.4335, 425.8446, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 18 ], 46.0000, 4.0000);
	TextDrawAlignment(td_sp [ 18 ], 1);
	TextDrawColor(td_sp [ 18 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 18 ], 255);
	TextDrawFont(td_sp [ 18 ], 4);
	TextDrawSetProportional(td_sp [ 18 ], 0);
	TextDrawSetShadow(td_sp [ 18 ], 0);

	td_sp [ 19 ] = TextDrawCreate(327.9335, 426.3446, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 19 ], 45.0000, 3.1798);
	TextDrawAlignment(td_sp [ 19 ], 1);
	TextDrawColor(td_sp [ 19 ], color_box);
	TextDrawBackgroundColor(td_sp [ 19 ], 255);
	TextDrawFont(td_sp [ 19 ], 4);
	TextDrawSetProportional(td_sp [ 19 ], 0);
	TextDrawSetShadow(td_sp [ 19 ], 0);

	td_sp [ 20 ] = TextDrawCreate(362.3706, 399.6343, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 20 ], 13.0000, 15.0000);
	TextDrawAlignment(td_sp [ 20 ], 1);
	TextDrawColor(td_sp [ 20 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 20 ], 255);
	TextDrawFont(td_sp [ 20 ], 4);
	TextDrawSetProportional(td_sp [ 20 ], 0);
	TextDrawSetShadow(td_sp [ 20 ], 0);

	td_sp [ 21 ] = TextDrawCreate(362.3706, 408.4348, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 21 ], 13.0000, 15.0000);
	TextDrawAlignment(td_sp [ 21 ], 1);
	TextDrawColor(td_sp [ 21 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 21 ], 255);
	TextDrawFont(td_sp [ 21 ], 4);
	TextDrawSetProportional(td_sp [ 21 ], 0);
	TextDrawSetShadow(td_sp [ 21 ], 0);

	td_sp [ 22 ] = TextDrawCreate(286.8666, 401.8851, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(td_sp [ 22 ], 96.0000, 36.0000);
	TextDrawAlignment(td_sp [ 22 ], 1);
	TextDrawColor(td_sp [ 22 ], color_particle);
	TextDrawBackgroundColor(td_sp [ 22 ], 255);
	TextDrawFont(td_sp [ 22 ], 4);
	TextDrawSetProportional(td_sp [ 22 ], 0);
	TextDrawSetShadow(td_sp [ 22 ], 0);

	td_sp [ 23 ] = TextDrawCreate(297.9667, 399.6343, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 23 ], 13.0000, 15.0000);
	TextDrawAlignment(td_sp [ 23 ], 1);
	TextDrawColor(td_sp [ 23 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 23 ], 255);
	TextDrawFont(td_sp [ 23 ], 4);
	TextDrawSetProportional(td_sp [ 23 ], 0);
	TextDrawSetShadow(td_sp [ 23 ], 0);

	td_sp [ 24 ] = TextDrawCreate(297.9667, 408.4348, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 24 ], 13.0000, 15.0000);
	TextDrawAlignment(td_sp [ 24 ], 1);
	TextDrawColor(td_sp [ 24 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 24 ], 255);
	TextDrawFont(td_sp [ 24 ], 4);
	TextDrawSetProportional(td_sp [ 24 ], 0);
	TextDrawSetShadow(td_sp [ 24 ], 0);

	td_sp [ 25 ] = TextDrawCreate(305.1997, 402.2296, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 25 ], 63.0000, 18.5400);
	TextDrawAlignment(td_sp [ 25 ], 1);
	TextDrawColor(td_sp [ 25 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 25 ], 255);
	TextDrawFont(td_sp [ 25 ], 4);
	TextDrawSetProportional(td_sp [ 25 ], 0);
	TextDrawSetShadow(td_sp [ 25 ], 0);

	td_sp [ 26 ] = TextDrawCreate(300.1665, 408.0368, "ld_spac:white"); // пусто
	TextDrawTextSize(td_sp [ 26 ], 73.0000, 7.0000);
	TextDrawAlignment(td_sp [ 26 ], 1);
	TextDrawColor(td_sp [ 26 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 26 ], 255);
	TextDrawFont(td_sp [ 26 ], 4);
	TextDrawSetProportional(td_sp [ 26 ], 0);
	TextDrawSetShadow(td_sp [ 26 ], 0);
	
	/*td_sp [ 27 ] = TextDrawCreate(274.3330, 423.3850, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 27 ], 8.0000, 10.0000);
	TextDrawAlignment(td_sp [ 27 ], 1);
	TextDrawColor(td_sp [ 27 ], -1791099102);
	TextDrawBackgroundColor(td_sp [ 27 ], 255);
	TextDrawFont(td_sp [ 27 ], 4);
	TextDrawSetProportional(td_sp [ 27 ], 0);
	TextDrawSetShadow(td_sp [ 27 ], 0);

	td_sp [ 28 ] = TextDrawCreate(275.3330, 424.3294, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 28 ], 6.0000, 8.0000);
	TextDrawAlignment(td_sp [ 28 ], 1);
	TextDrawColor(td_sp [ 28 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 28 ], 255);
	TextDrawFont(td_sp [ 28 ], 4);
	TextDrawSetProportional(td_sp [ 28 ], 0);
	TextDrawSetShadow(td_sp [ 28 ], 0);

	td_sp [ 29 ] = TextDrawCreate(234.9998, 410.1109, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 29 ], 8.0000, 10.0000);
	TextDrawAlignment(td_sp [ 29 ], 1);
	TextDrawColor(td_sp [ 29 ], -1791099102);
	TextDrawBackgroundColor(td_sp [ 29 ], 255);
	TextDrawFont(td_sp [ 29 ], 4);
	TextDrawSetProportional(td_sp [ 29 ], 0);
	TextDrawSetShadow(td_sp [ 29 ], 0);
	
	td_sp [ 30 ] = TextDrawCreate(235.9998, 411.0552, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 30 ], 6.0000, 8.0000);
	TextDrawAlignment(td_sp [ 30 ], 1);
	TextDrawColor(td_sp [ 30 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 30 ], 255);
	TextDrawFont(td_sp [ 30 ], 4);
	TextDrawSetProportional(td_sp [ 30 ], 0);
	TextDrawSetShadow(td_sp [ 30 ], 0);

	td_sp [ 31 ] = TextDrawCreate(279.9999, 377.7554, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 31 ], 8.0000, 10.0000);
	TextDrawAlignment(td_sp [ 31 ], 1);
	TextDrawColor(td_sp [ 31 ], -1791099102);
	TextDrawBackgroundColor(td_sp [ 31 ], 255);
	TextDrawFont(td_sp [ 31 ], 4);
	TextDrawSetProportional(td_sp [ 31 ], 0);
	TextDrawSetShadow(td_sp [ 31 ], 0);

	td_sp [ 32 ] = TextDrawCreate(280.9999, 378.6997, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_sp [ 32 ], 6.0000, 8.0000);
	TextDrawAlignment(td_sp [ 32 ], 1);
	TextDrawColor(td_sp [ 32 ], color_textdraw);
	TextDrawBackgroundColor(td_sp [ 32 ], 255);
	TextDrawFont(td_sp [ 32 ], 4);
	TextDrawSetProportional(td_sp [ 32 ], 0);
	TextDrawSetShadow(td_sp [ 32 ], 0);

	td_sp [ 33 ] = TextDrawCreate(251.6665, 379.5704, "X"); // пусто
	TextDrawLetterSize(td_sp [ 33 ], 0.1668, 0.9031);
	TextDrawAlignment(td_sp [ 33 ], 1);
	TextDrawColor(td_sp [ 33 ], -1791099103);
	TextDrawBackgroundColor(td_sp [ 33 ], 255);
	TextDrawFont(td_sp [ 33 ], 2);
	TextDrawSetProportional(td_sp [ 33 ], 1);
	TextDrawSetShadow(td_sp [ 33 ], 0);

	td_sp [ 34 ] = TextDrawCreate(277.9999, 395.3330, "X"); // пусто
	TextDrawLetterSize(td_sp [ 34 ], 0.1668, 0.9031);
	TextDrawAlignment(td_sp [ 34 ], 1);
	TextDrawColor(td_sp [ 34 ], -1791099103);
	TextDrawBackgroundColor(td_sp [ 34 ], 255);
	TextDrawFont(td_sp [ 34 ], 2);
	TextDrawSetProportional(td_sp [ 34 ], 1);
	TextDrawSetShadow(td_sp [ 34 ], 0);

	td_sp [ 35 ] = TextDrawCreate(238.6665, 426.0296, "X"); // пусто
	TextDrawLetterSize(td_sp [ 35 ], 0.1668, 0.9031);
	TextDrawAlignment(td_sp [ 35 ], 1);
	TextDrawColor(td_sp [ 35 ], -1791099103);
	TextDrawBackgroundColor(td_sp [ 35 ], 255);
	TextDrawFont(td_sp [ 35 ], 2);
	TextDrawSetProportional(td_sp [ 35 ], 1);
	TextDrawSetShadow(td_sp [ 35 ], 0);

	td_sp [ 36 ] = TextDrawCreate(231.3332, 389.5256, ">"); // пусто
	TextDrawLetterSize(td_sp [ 36 ], 0.1668, 0.9031);
	TextDrawAlignment(td_sp [ 36 ], 1);
	TextDrawColor(td_sp [ 36 ], -1791099103);
	TextDrawBackgroundColor(td_sp [ 36 ], 255);
	TextDrawFont(td_sp [ 36 ], 2);
	TextDrawSetProportional(td_sp [ 36 ], 1);
	TextDrawSetShadow(td_sp [ 36 ], 0);*/
	
	// Dice
	dice_td[0] = TextDrawCreate(502.9996, 125.6889, "ld_spac:white"); // пусто
	TextDrawTextSize(dice_td[0], 106.0000, 234.0000);
	TextDrawAlignment(dice_td[0], 1);
	TextDrawColor(dice_td[0], color_black_box);
	TextDrawBackgroundColor(dice_td[0], 255);
	TextDrawFont(dice_td[0], 4);
	TextDrawSetProportional(dice_td[0], 0);
	TextDrawSetShadow(dice_td[0], 0);

	dice_td[1] = TextDrawCreate(516.6665, 144.4886, "ld_spac:white"); // First Player
	TextDrawTextSize(dice_td[1], 66.0000, 15.0000);
	TextDrawAlignment(dice_td[1], 1);
	TextDrawColor(dice_td[1], color_box);
	TextDrawBackgroundColor(dice_td[1], 255);
	TextDrawFont(dice_td[1], 4);
	TextDrawSetProportional(dice_td[1], 0);
	TextDrawSetShadow(dice_td[1], 0);

	dice_td[2] = TextDrawCreate(514.6333, 146.3032, "1"); // First Player
	TextDrawLetterSize(dice_td[2], 0.2623, 1.1768);
	TextDrawAlignment(dice_td[2], 1);
	TextDrawColor(dice_td[2], -2139062017);
	TextDrawBackgroundColor(dice_td[2], 255);
	TextDrawFont(dice_td[2], 2);
	TextDrawSetProportional(dice_td[2], 1);
	TextDrawSetShadow(dice_td[2], 0);

	dice_td[3] = TextDrawCreate(506.6665, 140.6701, "ld_beat:chit"); // First Player
	TextDrawTextSize(dice_td[3], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[3], 1);
	TextDrawColor(dice_td[3], color_box);
	TextDrawBackgroundColor(dice_td[3], 255);
	TextDrawFont(dice_td[3], 4);
	TextDrawSetProportional(dice_td[3], 0);
	TextDrawSetShadow(dice_td[3], 0);

	dice_td[4] = TextDrawCreate(508.6665, 143.3701, "ld_beat:chit"); // First Player
	TextDrawTextSize(dice_td[4], 15.0000, 17.8899);
	TextDrawAlignment(dice_td[4], 1);
	TextDrawColor(dice_td[4], color_black_box);
	TextDrawBackgroundColor(dice_td[4], 255);
	TextDrawFont(dice_td[4], 4);
	TextDrawSetProportional(dice_td[4], 0);
	TextDrawSetShadow(dice_td[4], 0);

	dice_td[5] = TextDrawCreate(574.5000, 140.5700, "ld_beat:chit"); // First Player
	TextDrawTextSize(dice_td[5], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[5], 1);
	TextDrawColor(dice_td[5], color_box);
	TextDrawBackgroundColor(dice_td[5], 255);
	TextDrawFont(dice_td[5], 4);
	TextDrawSetProportional(dice_td[5], 0);
	TextDrawSetShadow(dice_td[5], 0);

	dice_td[6] = TextDrawCreate(576.2000, 140.5700, "ld_beat:chit"); // First Player
	TextDrawTextSize(dice_td[6], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[6], 1);
	TextDrawColor(dice_td[6], color_textdraw);
	TextDrawBackgroundColor(dice_td[6], 255);
	TextDrawFont(dice_td[6], 4);
	TextDrawSetProportional(dice_td[6], 0);
	TextDrawSetShadow(dice_td[6], 0);

	dice_td[7] = TextDrawCreate(588.5006, 140.5700, "ld_beat:chit"); // First Player
	TextDrawTextSize(dice_td[7], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[7], 1);
	TextDrawColor(dice_td[7], color_textdraw);
	TextDrawBackgroundColor(dice_td[7], 255);
	TextDrawFont(dice_td[7], 4);
	TextDrawSetProportional(dice_td[7], 0);
	TextDrawSetShadow(dice_td[7], 0);

	dice_td[8] = TextDrawCreate(586.0664, 144.3737, "ld_spac:white"); // First Player
	TextDrawTextSize(dice_td[8], 12.0000, 15.1597);
	TextDrawAlignment(dice_td[8], 1);
	TextDrawColor(dice_td[8], color_textdraw);
	TextDrawBackgroundColor(dice_td[8], 255);
	TextDrawFont(dice_td[8], 4);
	TextDrawSetProportional(dice_td[8], 0);
	TextDrawSetShadow(dice_td[8], 0);

	dice_td[9] = TextDrawCreate(516.6665, 166.7899, "ld_spac:white"); // Second Player
	TextDrawTextSize(dice_td[9], 66.0000, 15.0000);
	TextDrawAlignment(dice_td[9], 1);
	TextDrawColor(dice_td[9], color_box);
	TextDrawBackgroundColor(dice_td[9], 255);
	TextDrawFont(dice_td[9], 4);
	TextDrawSetProportional(dice_td[9], 0);
	TextDrawSetShadow(dice_td[9], 0);

	dice_td[10] = TextDrawCreate(514.4331, 168.6047, "2"); // Second Player
	TextDrawLetterSize(dice_td[10], 0.1523, 1.1849);
	TextDrawAlignment(dice_td[10], 1);
	TextDrawColor(dice_td[10], -2139062017);
	TextDrawBackgroundColor(dice_td[10], 255);
	TextDrawFont(dice_td[10], 2);
	TextDrawSetProportional(dice_td[10], 1);
	TextDrawSetShadow(dice_td[10], 0);

	dice_td[11] = TextDrawCreate(506.6665, 162.9714, "ld_beat:chit"); // Second Player
	TextDrawTextSize(dice_td[11], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[11], 1);
	TextDrawColor(dice_td[11], color_box);
	TextDrawBackgroundColor(dice_td[11], 255);
	TextDrawFont(dice_td[11], 4);
	TextDrawSetProportional(dice_td[11], 0);
	TextDrawSetShadow(dice_td[11], 0);

	dice_td[12] = TextDrawCreate(508.6665, 165.6714, "ld_beat:chit"); // Second Player
	TextDrawTextSize(dice_td[12], 15.0000, 17.8899);
	TextDrawAlignment(dice_td[12], 1);
	TextDrawColor(dice_td[12], color_black_box);
	TextDrawBackgroundColor(dice_td[12], 255);
	TextDrawFont(dice_td[12], 4);
	TextDrawSetProportional(dice_td[12], 0);
	TextDrawSetShadow(dice_td[12], 0);

	dice_td[13] = TextDrawCreate(574.5000, 162.8713, "ld_beat:chit"); // Second Player
	TextDrawTextSize(dice_td[13], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[13], 1);
	TextDrawColor(dice_td[13], color_box);
	TextDrawBackgroundColor(dice_td[13], 255);
	TextDrawFont(dice_td[13], 4);
	TextDrawSetProportional(dice_td[13], 0);
	TextDrawSetShadow(dice_td[13], 0);

	dice_td[14] = TextDrawCreate(576.2000, 162.8713, "ld_beat:chit"); // Second Player
	TextDrawTextSize(dice_td[14], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[14], 1);
	TextDrawColor(dice_td[14], color_textdraw);
	TextDrawBackgroundColor(dice_td[14], 255);
	TextDrawFont(dice_td[14], 4);
	TextDrawSetProportional(dice_td[14], 0);
	TextDrawSetShadow(dice_td[14], 0);

	dice_td[15] = TextDrawCreate(588.5006, 162.8713, "ld_beat:chit"); // Second Player
	TextDrawTextSize(dice_td[15], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[15], 1);
	TextDrawColor(dice_td[15], color_textdraw);
	TextDrawBackgroundColor(dice_td[15], 255);
	TextDrawFont(dice_td[15], 4);
	TextDrawSetProportional(dice_td[15], 0);
	TextDrawSetShadow(dice_td[15], 0);

	dice_td[16] = TextDrawCreate(586.0664, 166.6752, "ld_spac:white"); // Second Player
	TextDrawTextSize(dice_td[16], 12.0000, 15.1597);
	TextDrawAlignment(dice_td[16], 1);
	TextDrawColor(dice_td[16], color_textdraw);
	TextDrawBackgroundColor(dice_td[16], 255);
	TextDrawFont(dice_td[16], 4);
	TextDrawSetProportional(dice_td[16], 0);
	TextDrawSetShadow(dice_td[16], 0);

	dice_td[17] = TextDrawCreate(517.1666, 188.5209, "ld_spac:white"); // Three Player
	TextDrawTextSize(dice_td[17], 72.0000, 15.0000);
	TextDrawAlignment(dice_td[17], 1);
	TextDrawColor(dice_td[17], color_box);
	TextDrawBackgroundColor(dice_td[17], 255);
	TextDrawFont(dice_td[17], 4);
	TextDrawSetProportional(dice_td[17], 0);
	TextDrawSetShadow(dice_td[17], 0);

	dice_td[18] = TextDrawCreate(576.2000, 184.3726, "ld_beat:chit"); // Three Player
	TextDrawTextSize(dice_td[18], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[18], 1);
	TextDrawColor(dice_td[18], color_textdraw);
	TextDrawBackgroundColor(dice_td[18], 255);
	TextDrawFont(dice_td[18], 4);
	TextDrawSetProportional(dice_td[18], 0);
	TextDrawSetShadow(dice_td[18], 0);

	dice_td[19] = TextDrawCreate(588.5006, 184.3726, "ld_beat:chit"); // Three Player
	TextDrawTextSize(dice_td[19], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[19], 1);
	TextDrawColor(dice_td[19], color_textdraw);
	TextDrawBackgroundColor(dice_td[19], 255);
	TextDrawFont(dice_td[19], 4);
	TextDrawSetProportional(dice_td[19], 0);
	TextDrawSetShadow(dice_td[19], 0);

	dice_td[20] = TextDrawCreate(586.0664, 188.1764, "ld_spac:white"); // Three Player
	TextDrawTextSize(dice_td[20], 12.0000, 15.1597);
	TextDrawAlignment(dice_td[20], 1);
	TextDrawColor(dice_td[20], color_textdraw);
	TextDrawBackgroundColor(dice_td[20], 255);
	TextDrawFont(dice_td[20], 4);
	TextDrawSetProportional(dice_td[20], 0);
	TextDrawSetShadow(dice_td[20], 0);

	dice_td[21] = TextDrawCreate(514.4331, 190.1060, "3"); // Three Player
	TextDrawLetterSize(dice_td[21], 0.1523, 1.1849);
	TextDrawAlignment(dice_td[21], 1);
	TextDrawColor(dice_td[21], -2139062017);
	TextDrawBackgroundColor(dice_td[21], 255);
	TextDrawFont(dice_td[21], 2);
	TextDrawSetProportional(dice_td[21], 1);
	TextDrawSetShadow(dice_td[21], 0);

	dice_td[22] = TextDrawCreate(506.6665, 184.4727, "ld_beat:chit"); // Three Player
	TextDrawTextSize(dice_td[22], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[22], 1);
	TextDrawColor(dice_td[22], color_box);
	TextDrawBackgroundColor(dice_td[22], 255);
	TextDrawFont(dice_td[22], 4);
	TextDrawSetProportional(dice_td[22], 0);
	TextDrawSetShadow(dice_td[22], 0);

	dice_td[23] = TextDrawCreate(508.6665, 187.1728, "ld_beat:chit"); // Three Player
	TextDrawTextSize(dice_td[23], 15.0000, 17.8899);
	TextDrawAlignment(dice_td[23], 1);
	TextDrawColor(dice_td[23], color_black_box);
	TextDrawBackgroundColor(dice_td[23], 255);
	TextDrawFont(dice_td[23], 4);
	TextDrawSetProportional(dice_td[23], 0);
	TextDrawSetShadow(dice_td[23], 0);

	dice_td[24] = TextDrawCreate(517.1666, 210.0222, "ld_spac:white"); // Four Player
	TextDrawTextSize(dice_td[24], 72.0000, 15.0000);
	TextDrawAlignment(dice_td[24], 1);
	TextDrawColor(dice_td[24], color_box);
	TextDrawBackgroundColor(dice_td[24], 255);
	TextDrawFont(dice_td[24], 4);
	TextDrawSetProportional(dice_td[24], 0);
	TextDrawSetShadow(dice_td[24], 0);

	dice_td[25] = TextDrawCreate(576.2000, 205.8739, "ld_beat:chit"); // Four Player
	TextDrawTextSize(dice_td[25], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[25], 1);
	TextDrawColor(dice_td[25], color_textdraw);
	TextDrawBackgroundColor(dice_td[25], 255);
	TextDrawFont(dice_td[25], 4);
	TextDrawSetProportional(dice_td[25], 0);
	TextDrawSetShadow(dice_td[25], 0);

	dice_td[26] = TextDrawCreate(588.5006, 205.8739, "ld_beat:chit"); // Four Player
	TextDrawTextSize(dice_td[26], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[26], 1);
	TextDrawColor(dice_td[26], color_textdraw);
	TextDrawBackgroundColor(dice_td[26], 255);
	TextDrawFont(dice_td[26], 4);
	TextDrawSetProportional(dice_td[26], 0);
	TextDrawSetShadow(dice_td[26], 0);

	dice_td[27] = TextDrawCreate(586.0664, 209.6777, "ld_spac:white"); // Four Player
	TextDrawTextSize(dice_td[27], 12.0000, 15.1597);
	TextDrawAlignment(dice_td[27], 1);
	TextDrawColor(dice_td[27], color_textdraw);
	TextDrawBackgroundColor(dice_td[27], 255);
	TextDrawFont(dice_td[27], 4);
	TextDrawSetProportional(dice_td[27], 0);
	TextDrawSetShadow(dice_td[27], 0);

	dice_td[28] = TextDrawCreate(514.1328, 211.6071, "4"); // Four Player
	TextDrawLetterSize(dice_td[28], 0.1523, 1.1849);
	TextDrawAlignment(dice_td[28], 1);
	TextDrawColor(dice_td[28], -2139062017);
	TextDrawBackgroundColor(dice_td[28], 255);
	TextDrawFont(dice_td[28], 2);
	TextDrawSetProportional(dice_td[28], 1);
	TextDrawSetShadow(dice_td[28], 0);

	dice_td[29] = TextDrawCreate(506.6665, 205.9739, "ld_beat:chit"); // Four Player
	TextDrawTextSize(dice_td[29], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[29], 1);
	TextDrawColor(dice_td[29], color_box);
	TextDrawBackgroundColor(dice_td[29], 255);
	TextDrawFont(dice_td[29], 4);
	TextDrawSetProportional(dice_td[29], 0);
	TextDrawSetShadow(dice_td[29], 0);

	dice_td[30] = TextDrawCreate(508.6665, 208.6741, "ld_beat:chit"); // Four Player
	TextDrawTextSize(dice_td[30], 15.0000, 17.8899);
	TextDrawAlignment(dice_td[30], 1);
	TextDrawColor(dice_td[30], color_black_box);
	TextDrawBackgroundColor(dice_td[30], 255);
	TextDrawFont(dice_td[30], 4);
	TextDrawSetProportional(dice_td[30], 0);
	TextDrawSetShadow(dice_td[30], 0);

	dice_td[31] = TextDrawCreate(517.1666, 232.9237, "ld_spac:white"); // Five Player
	TextDrawTextSize(dice_td[31], 72.0000, 15.0000);
	TextDrawAlignment(dice_td[31], 1);
	TextDrawColor(dice_td[31], color_box);
	TextDrawBackgroundColor(dice_td[31], 255);
	TextDrawFont(dice_td[31], 4);
	TextDrawSetProportional(dice_td[31], 0);
	TextDrawSetShadow(dice_td[31], 0);

	dice_td[32] = TextDrawCreate(576.2000, 228.7752, "ld_beat:chit"); // Five Player
	TextDrawTextSize(dice_td[32], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[32], 1);
	TextDrawColor(dice_td[32], color_textdraw);
	TextDrawBackgroundColor(dice_td[32], 255);
	TextDrawFont(dice_td[32], 4);
	TextDrawSetProportional(dice_td[32], 0);
	TextDrawSetShadow(dice_td[32], 0);

	dice_td[33] = TextDrawCreate(588.5006, 228.7752, "ld_beat:chit"); // Five Player
	TextDrawTextSize(dice_td[33], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[33], 1);
	TextDrawColor(dice_td[33], color_textdraw);
	TextDrawBackgroundColor(dice_td[33], 255);
	TextDrawFont(dice_td[33], 4);
	TextDrawSetProportional(dice_td[33], 0);
	TextDrawSetShadow(dice_td[33], 0);

	dice_td[34] = TextDrawCreate(586.0664, 232.5791, "ld_spac:white"); // Five Player
	TextDrawTextSize(dice_td[34], 12.0000, 15.1597);
	TextDrawAlignment(dice_td[34], 1);
	TextDrawColor(dice_td[34], color_textdraw);
	TextDrawBackgroundColor(dice_td[34], 255);
	TextDrawFont(dice_td[34], 4);
	TextDrawSetProportional(dice_td[34], 0);
	TextDrawSetShadow(dice_td[34], 0);

	dice_td[35] = TextDrawCreate(514.5330, 234.5086, "5"); // Five Player
	TextDrawLetterSize(dice_td[35], 0.1523, 1.1849);
	TextDrawAlignment(dice_td[35], 1);
	TextDrawColor(dice_td[35], -2139062017);
	TextDrawBackgroundColor(dice_td[35], 255);
	TextDrawFont(dice_td[35], 2);
	TextDrawSetProportional(dice_td[35], 1);
	TextDrawSetShadow(dice_td[35], 0);

	dice_td[36] = TextDrawCreate(506.6665, 228.8753, "ld_beat:chit"); // Five Player
	TextDrawTextSize(dice_td[36], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[36], 1);
	TextDrawColor(dice_td[36], color_box);
	TextDrawBackgroundColor(dice_td[36], 255);
	TextDrawFont(dice_td[36], 4);
	TextDrawSetProportional(dice_td[36], 0);
	TextDrawSetShadow(dice_td[36], 0);

	dice_td[37] = TextDrawCreate(508.6665, 231.5755, "ld_beat:chit"); // Five Player
	TextDrawTextSize(dice_td[37], 15.0000, 17.8899);
	TextDrawAlignment(dice_td[37], 1);
	TextDrawColor(dice_td[37], color_black_box);
	TextDrawBackgroundColor(dice_td[37], 255);
	TextDrawFont(dice_td[37], 4);
	TextDrawSetProportional(dice_td[37], 0);
	TextDrawSetShadow(dice_td[37], 0);

	dice_td[38] = TextDrawCreate(519.9998, 148.8627, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(dice_td[38], 62.0000, 10.1800);
	TextDrawAlignment(dice_td[38], 1);
	TextDrawColor(dice_td[38], color_particle);
	TextDrawBackgroundColor(dice_td[38], 255);
	TextDrawFont(dice_td[38], 4);
	TextDrawSetProportional(dice_td[38], 0);
	TextDrawSetShadow(dice_td[38], 0);

	dice_td[39] = TextDrawCreate(519.9998, 170.9642, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(dice_td[39], 62.0000, 10.1800);
	TextDrawAlignment(dice_td[39], 1);
	TextDrawColor(dice_td[39], color_particle);
	TextDrawBackgroundColor(dice_td[39], 255);
	TextDrawFont(dice_td[39], 4);
	TextDrawSetProportional(dice_td[39], 0);
	TextDrawSetShadow(dice_td[39], 0);

	dice_td[40] = TextDrawCreate(519.9998, 193.1654, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(dice_td[40], 62.0000, 10.1800);
	TextDrawAlignment(dice_td[40], 1);
	TextDrawColor(dice_td[40], color_particle);
	TextDrawBackgroundColor(dice_td[40], 255);
	TextDrawFont(dice_td[40], 4);
	TextDrawSetProportional(dice_td[40], 0);
	TextDrawSetShadow(dice_td[40], 0);

	dice_td[41] = TextDrawCreate(519.9998, 214.6669, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(dice_td[41], 62.0000, 10.1800);
	TextDrawAlignment(dice_td[41], 1);
	TextDrawColor(dice_td[41], color_particle);
	TextDrawBackgroundColor(dice_td[41], 255);
	TextDrawFont(dice_td[41], 4);
	TextDrawSetProportional(dice_td[41], 0);
	TextDrawSetShadow(dice_td[41], 0);

	dice_td[42] = TextDrawCreate(519.9998, 237.5682, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(dice_td[42], 62.0000, 10.1800);
	TextDrawAlignment(dice_td[42], 1);
	TextDrawColor(dice_td[42], color_particle);
	TextDrawBackgroundColor(dice_td[42], 255);
	TextDrawFont(dice_td[42], 4);
	TextDrawSetProportional(dice_td[42], 0);
	TextDrawSetShadow(dice_td[42], 0);

	dice_td[43] = TextDrawCreate(588.5006, 275.4783, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[43], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[43], 1);
	TextDrawColor(dice_td[43], color_textdraw);
	TextDrawBackgroundColor(dice_td[43], 255);
	TextDrawFont(dice_td[43], 4);
	TextDrawSetProportional(dice_td[43], 0);
	TextDrawSetShadow(dice_td[43], 0);

	dice_td[44] = TextDrawCreate(506.6665, 275.5783, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[44], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[44], 1);
	TextDrawColor(dice_td[44], color_textdraw);
	TextDrawBackgroundColor(dice_td[44], 255);
	TextDrawFont(dice_td[44], 4);
	TextDrawSetProportional(dice_td[44], 0);
	TextDrawSetShadow(dice_td[44], 0);

	dice_td[45] = TextDrawCreate(588.5006, 251.9768, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[45], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[45], 1);
	TextDrawColor(dice_td[45], color_textdraw);
	TextDrawBackgroundColor(dice_td[45], 255);
	TextDrawFont(dice_td[45], 4);
	TextDrawSetProportional(dice_td[45], 0);
	TextDrawSetShadow(dice_td[45], 0);

	dice_td[46] = TextDrawCreate(506.6665, 252.0769, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[46], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[46], 1);
	TextDrawColor(dice_td[46], color_textdraw);
	TextDrawBackgroundColor(dice_td[46], 255);
	TextDrawFont(dice_td[46], 4);
	TextDrawSetProportional(dice_td[46], 0);
	TextDrawSetShadow(dice_td[46], 0);

	dice_td[47] = TextDrawCreate(516.4995, 255.8997, "ld_spac:white"); // пусто
	TextDrawTextSize(dice_td[47], 81.2200, 38.6500);
	TextDrawAlignment(dice_td[47], 1);
	TextDrawColor(dice_td[47], color_textdraw);
	TextDrawBackgroundColor(dice_td[47], 255);
	TextDrawFont(dice_td[47], 4);
	TextDrawSetProportional(dice_td[47], 0);
	TextDrawSetShadow(dice_td[47], 0);

	dice_td[48] = TextDrawCreate(588.5006, 252.9768, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[48], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[48], 1);
	TextDrawColor(dice_td[48], color_black_box);
	TextDrawBackgroundColor(dice_td[48], 255);
	TextDrawFont(dice_td[48], 4);
	TextDrawSetProportional(dice_td[48], 0);
	TextDrawSetShadow(dice_td[48], 0);

	dice_td[49] = TextDrawCreate(506.6665, 252.8769, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[49], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[49], 1);
	TextDrawColor(dice_td[49], color_black_box);
	TextDrawBackgroundColor(dice_td[49], 255);
	TextDrawFont(dice_td[49], 4);
	TextDrawSetProportional(dice_td[49], 0);
	TextDrawSetShadow(dice_td[49], 0);

	dice_td[50] = TextDrawCreate(588.5006, 274.5783, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[50], 19.0000, 22.8999);
	TextDrawAlignment(dice_td[50], 1);
	TextDrawColor(dice_td[50], color_black_box);
	TextDrawBackgroundColor(dice_td[50], 255);
	TextDrawFont(dice_td[50], 4);
	TextDrawSetProportional(dice_td[50], 0);
	TextDrawSetShadow(dice_td[50], 0);

	dice_td[51] = TextDrawCreate(506.6665, 274.6784, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[51], 19.0000, 23.0000);
	TextDrawAlignment(dice_td[51], 1);
	TextDrawColor(dice_td[51], color_black_box);
	TextDrawBackgroundColor(dice_td[51], 255);
	TextDrawFont(dice_td[51], 4);
	TextDrawSetProportional(dice_td[51], 0);
	TextDrawSetShadow(dice_td[51], 0);

	dice_td[52] = TextDrawCreate(516.9331, 256.6293, "ld_spac:white"); // пусто
	TextDrawTextSize(dice_td[52], 81.0000, 37.2097);
	TextDrawAlignment(dice_td[52], 1);
	TextDrawColor(dice_td[52], color_black_box);
	TextDrawBackgroundColor(dice_td[52], 255);
	TextDrawFont(dice_td[52], 4);
	TextDrawSetProportional(dice_td[52], 0);
	TextDrawSetShadow(dice_td[52], 0);

	dice_td[53] = TextDrawCreate(508.0000, 260.7778, "ld_spac:white"); // пусто
	TextDrawTextSize(dice_td[53], 101.0000, 28.0000);
	TextDrawAlignment(dice_td[53], 1);
	TextDrawColor(dice_td[53], color_black_box);
	TextDrawBackgroundColor(dice_td[53], 255);
	TextDrawFont(dice_td[53], 4);
	TextDrawSetProportional(dice_td[53], 0);
	TextDrawSetShadow(dice_td[53], 0);

	dice_td[54] = TextDrawCreate(556.8665, 342.0733, "EXIT"); // пусто
	TextDrawLetterSize(dice_td[54], 0.1782, 1.0814);
	TextDrawTextSize(dice_td[54], 15.0000, 81.0000);
	TextDrawAlignment(dice_td[54], 2);
	TextDrawColor(dice_td[54], color_black_box);
	TextDrawUseBox(dice_td[54], 1);
	TextDrawBoxColor(dice_td[54], color_textdraw);
	TextDrawBackgroundColor(dice_td[54], 255);
	TextDrawFont(dice_td[54], 2);
	TextDrawSetProportional(dice_td[54], 1);
	TextDrawSetShadow(dice_td[54], 0);
	TextDrawSetSelectable(dice_td[54], true);

	dice_td[55] = TextDrawCreate(506.1000, 336.9400, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[55], 17.0000, 20.0000);
	TextDrawAlignment(dice_td[55], 1);
	TextDrawColor(dice_td[55], color_textdraw);
	TextDrawBackgroundColor(dice_td[55], 255);
	TextDrawFont(dice_td[55], 4);
	TextDrawSetProportional(dice_td[55], 0);
	TextDrawSetShadow(dice_td[55], 0);

	dice_td[56] = TextDrawCreate(591.0999, 336.9400, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[56], 17.0000, 20.0000);
	TextDrawAlignment(dice_td[56], 1);
	TextDrawColor(dice_td[56], color_textdraw);
	TextDrawBackgroundColor(dice_td[56], 255);
	TextDrawFont(dice_td[56], 4);
	TextDrawSetProportional(dice_td[56], 0);
	TextDrawSetShadow(dice_td[56], 0);

	dice_td[57] = TextDrawCreate(556.8665, 303.5711, "SET_BET"); // пусто
	TextDrawLetterSize(dice_td[57], 0.1782, 1.0814);
	TextDrawTextSize(dice_td[57], 15.0000, 81.0000);
	TextDrawAlignment(dice_td[57], 2);
	TextDrawColor(dice_td[57], color_black_box);
	TextDrawUseBox(dice_td[57], 1);
	TextDrawBoxColor(dice_td[57], color_textdraw);
	TextDrawBackgroundColor(dice_td[57], 255);
	TextDrawFont(dice_td[57], 2);
	TextDrawSetProportional(dice_td[57], 1);
	TextDrawSetShadow(dice_td[57], 0);
	TextDrawSetSelectable(dice_td[57], true);

	dice_td[58] = TextDrawCreate(506.1000, 298.4378, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[58], 17.0000, 20.0000);
	TextDrawAlignment(dice_td[58], 1);
	TextDrawColor(dice_td[58], color_textdraw);
	TextDrawBackgroundColor(dice_td[58], 255);
	TextDrawFont(dice_td[58], 4);
	TextDrawSetProportional(dice_td[58], 0);
	TextDrawSetShadow(dice_td[58], 0);

	dice_td[59] = TextDrawCreate(591.0999, 298.4378, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[59], 17.0000, 20.0000);
	TextDrawAlignment(dice_td[59], 1);
	TextDrawColor(dice_td[59], color_textdraw);
	TextDrawBackgroundColor(dice_td[59], 255);
	TextDrawFont(dice_td[59], 4);
	TextDrawSetProportional(dice_td[59], 0);
	TextDrawSetShadow(dice_td[59], 0);

	dice_td[60] = TextDrawCreate(556.8665, 322.8723, "DICE"); // пусто
	TextDrawLetterSize(dice_td[60], 0.1782, 1.0814);
	TextDrawTextSize(dice_td[60], 15.0000, 81.0000);
	TextDrawAlignment(dice_td[60], 2);
	TextDrawColor(dice_td[60], color_black_box);
	TextDrawUseBox(dice_td[60], 1);
	TextDrawBoxColor(dice_td[60], color_textdraw);
	TextDrawBackgroundColor(dice_td[60], 255);
	TextDrawFont(dice_td[60], 2);
	TextDrawSetProportional(dice_td[60], 1);
	TextDrawSetShadow(dice_td[60], 0);
	TextDrawSetSelectable(dice_td[60], true);

	dice_td[61] = TextDrawCreate(506.1000, 317.7388, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[61], 17.0000, 20.0000);
	TextDrawAlignment(dice_td[61], 1);
	TextDrawColor(dice_td[61], color_textdraw);
	TextDrawBackgroundColor(dice_td[61], 255);
	TextDrawFont(dice_td[61], 4);
	TextDrawSetProportional(dice_td[61], 0);
	TextDrawSetShadow(dice_td[61], 0);

	dice_td[62] = TextDrawCreate(591.0999, 317.7390, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[62], 17.0000, 20.0000);
	TextDrawAlignment(dice_td[62], 1);
	TextDrawColor(dice_td[62], color_textdraw);
	TextDrawBackgroundColor(dice_td[62], 255);
	TextDrawFont(dice_td[62], 4);
	TextDrawSetProportional(dice_td[62], 0);
	TextDrawSetShadow(dice_td[62], 0);

	dice_td[63] = TextDrawCreate(594.7390, 350.0031, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[63], 17.0000, 21.0000);
	TextDrawAlignment(dice_td[63], 1);
	TextDrawColor(dice_td[63], color_black_box);
	TextDrawBackgroundColor(dice_td[63], 255);
	TextDrawFont(dice_td[63], 4);
	TextDrawSetProportional(dice_td[63], 0);
	TextDrawSetShadow(dice_td[63], 0);

	dice_td[64] = TextDrawCreate(500.3333, 350.0031, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[64], 17.0000, 21.0000);
	TextDrawAlignment(dice_td[64], 1);
	TextDrawColor(dice_td[64], color_black_box);
	TextDrawBackgroundColor(dice_td[64], 255);
	TextDrawFont(dice_td[64], 4);
	TextDrawSetProportional(dice_td[64], 0);
	TextDrawSetShadow(dice_td[64], 0);

	dice_td[65] = TextDrawCreate(509.0999, 358.4699, "ld_spac:white"); // пусто
	TextDrawTextSize(dice_td[65], 94.0000, 9.0000);
	TextDrawAlignment(dice_td[65], 1);
	TextDrawColor(dice_td[65], color_black_box);
	TextDrawBackgroundColor(dice_td[65], 255);
	TextDrawFont(dice_td[65], 4);
	TextDrawSetProportional(dice_td[65], 0);
	TextDrawSetShadow(dice_td[65], 0);

	dice_td[66] = TextDrawCreate(503.0664, 122.6444, "ld_spac:white"); // пусто
	TextDrawTextSize(dice_td[66], 106.0000, 13.0000);
	TextDrawAlignment(dice_td[66], 1);
	TextDrawColor(dice_td[66], color_textdraw);
	TextDrawBackgroundColor(dice_td[66], 255);
	TextDrawFont(dice_td[66], 4);
	TextDrawSetProportional(dice_td[66], 0);
	TextDrawSetShadow(dice_td[66], 0);

	dice_td[67] = TextDrawCreate(499.1333, 108.6703, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[67], 24.0000, 27.0000);
	TextDrawAlignment(dice_td[67], 1);
	TextDrawColor(dice_td[67], color_textdraw);
	TextDrawBackgroundColor(dice_td[67], 255);
	TextDrawFont(dice_td[67], 4);
	TextDrawSetProportional(dice_td[67], 0);
	TextDrawSetShadow(dice_td[67], 0);

	dice_td[68] = TextDrawCreate(589.1998, 108.6703, "ld_beat:chit"); // пусто
	TextDrawTextSize(dice_td[68], 24.0000, 27.0000);
	TextDrawAlignment(dice_td[68], 1);
	TextDrawColor(dice_td[68], color_textdraw);
	TextDrawBackgroundColor(dice_td[68], 255);
	TextDrawFont(dice_td[68], 4);
	TextDrawSetProportional(dice_td[68], 0);
	TextDrawSetShadow(dice_td[68], 0);

	dice_td[69] = TextDrawCreate(512.5999, 113.2183, "ld_spac:white"); // пусто
	TextDrawTextSize(dice_td[69], 90.0000, 21.0000);
	TextDrawAlignment(dice_td[69], 1);
	TextDrawColor(dice_td[69], color_textdraw);
	TextDrawBackgroundColor(dice_td[69], 255);
	TextDrawFont(dice_td[69], 4);
	TextDrawSetProportional(dice_td[69], 0);
	TextDrawSetShadow(dice_td[69], 0);

	/*dice_td[70] = TextDrawCreate(509.3330, 127.3628, "X"); // пусто
	TextDrawLetterSize(dice_td[70], 0.2063, 0.7828);
	TextDrawAlignment(dice_td[70], 1);
	TextDrawColor(dice_td[70], -10879184);
	TextDrawBackgroundColor(dice_td[70], 255);
	TextDrawFont(dice_td[70], 1);
	TextDrawSetProportional(dice_td[70], 1);
	TextDrawSetShadow(dice_td[70], 0);

	dice_td[71] = TextDrawCreate(598.6666, 113.2592, "X"); // пусто
	TextDrawLetterSize(dice_td[71], 0.2063, 0.7828);
	TextDrawAlignment(dice_td[71], 1);
	TextDrawColor(dice_td[71], -10879184);
	TextDrawBackgroundColor(dice_td[71], 255);
	TextDrawFont(dice_td[71], 1);
	TextDrawSetProportional(dice_td[71], 1);
	TextDrawSetShadow(dice_td[71], 0);

	dice_td[72] = TextDrawCreate(539.3331, 115.7481, "X"); // пусто
	TextDrawLetterSize(dice_td[72], 0.2063, 0.7828);
	TextDrawAlignment(dice_td[72], 1);
	TextDrawColor(dice_td[72], -10879184);
	TextDrawBackgroundColor(dice_td[72], 255);
	TextDrawFont(dice_td[72], 1);
	TextDrawSetProportional(dice_td[72], 1);
	TextDrawSetShadow(dice_td[72], 0);

	dice_td[73] = TextDrawCreate(502.0000, 118.2369, ">"); // пусто
	TextDrawLetterSize(dice_td[73], 0.2063, 0.7828);
	TextDrawAlignment(dice_td[73], 1);
	TextDrawColor(dice_td[73], -10879184);
	TextDrawBackgroundColor(dice_td[73], 255);
	TextDrawFont(dice_td[73], 2);
	TextDrawSetProportional(dice_td[73], 1);
	TextDrawSetShadow(dice_td[73], 0);

	dice_td[74] = TextDrawCreate(609.0000, 124.4590, ">"); // пусто
	TextDrawLetterSize(dice_td[74], -0.2673, 1.4630);
	TextDrawAlignment(dice_td[74], 1);
	TextDrawColor(dice_td[74], -10879184);
	TextDrawBackgroundColor(dice_td[74], 255);
	TextDrawFont(dice_td[74], 2);
	TextDrawSetProportional(dice_td[74], 1);
	TextDrawSetShadow(dice_td[74], 0);

	dice_td[75] = TextDrawCreate(565.6666, 125.7035, "X"); // пусто
	TextDrawLetterSize(dice_td[75], 0.2063, 0.7828);
	TextDrawAlignment(dice_td[75], 1);
	TextDrawColor(dice_td[75], -10879184);
	TextDrawBackgroundColor(dice_td[75], 255);
	TextDrawFont(dice_td[75], 1);
	TextDrawSetProportional(dice_td[75], 1);
	TextDrawSetShadow(dice_td[75], 0);*/
	
	// Kamikaze
	kamikaze_td[0] = TextDrawCreate(175.8327, 86.7294, "ld_spac:white"); // пусто
	TextDrawTextSize(kamikaze_td[0], 286.0000, 260.0000);
	TextDrawAlignment(kamikaze_td[0], 1);
	TextDrawColor(kamikaze_td[0], color_black_box);
	TextDrawBackgroundColor(kamikaze_td[0], 255);
	TextDrawFont(kamikaze_td[0], 4);
	TextDrawSetProportional(kamikaze_td[0], 0);
	TextDrawSetShadow(kamikaze_td[0], 0);

	kamikaze_td[1] = TextDrawCreate(176.0325, 202.2888, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(kamikaze_td[1], 173.0000, 135.0000);
	TextDrawAlignment(kamikaze_td[1], 1);
	TextDrawColor(kamikaze_td[1], color_particle);
	TextDrawBackgroundColor(kamikaze_td[1], 255);
	TextDrawFont(kamikaze_td[1], 4);
	TextDrawSetProportional(kamikaze_td[1], 0);
	TextDrawSetShadow(kamikaze_td[1], 0);

	kamikaze_td[2] = TextDrawCreate(175.0325, 280.0371, "particle:lamp_shad_64"); // пусто
	TextDrawTextSize(kamikaze_td[2], 174.0000, -163.0000);
	TextDrawAlignment(kamikaze_td[2], 1);
	TextDrawColor(kamikaze_td[2], color_particle);
	TextDrawBackgroundColor(kamikaze_td[2], 255);
	TextDrawFont(kamikaze_td[2], 4);
	TextDrawSetProportional(kamikaze_td[2], 0);
	TextDrawSetShadow(kamikaze_td[2], 0);

	kamikaze_td[3] = TextDrawCreate(451.9414, 117.7962, "ld_spac:white"); // пусто
	TextDrawTextSize(kamikaze_td[3], -95.0000, 221.0000);
	TextDrawAlignment(kamikaze_td[3], 1);
	TextDrawColor(kamikaze_td[3], color_box);
	TextDrawBackgroundColor(kamikaze_td[3], 255);
	TextDrawFont(kamikaze_td[3], 4);
	TextDrawSetProportional(kamikaze_td[3], 0);
	TextDrawSetShadow(kamikaze_td[3], 0);

	kamikaze_td[4] = TextDrawCreate(367.2661, 156.4237, "x3.5"); // пусто
	TextDrawLetterSize(kamikaze_td[4], 0.3165, 1.2888);
	TextDrawAlignment(kamikaze_td[4], 1);
	TextDrawColor(kamikaze_td[4], -1061109505);
	TextDrawBackgroundColor(kamikaze_td[4], 255);
	TextDrawFont(kamikaze_td[4], 1);
	TextDrawSetProportional(kamikaze_td[4], 1);
	TextDrawSetShadow(kamikaze_td[4], 0);

	kamikaze_td[5] = TextDrawCreate(367.2661, 125.5242, "x4.5"); // пусто
	TextDrawLetterSize(kamikaze_td[5], 0.3165, 1.2888);
	TextDrawAlignment(kamikaze_td[5], 1);
	TextDrawColor(kamikaze_td[5], -1061109505);
	TextDrawBackgroundColor(kamikaze_td[5], 255);
	TextDrawFont(kamikaze_td[5], 1);
	TextDrawSetProportional(kamikaze_td[5], 1);
	TextDrawSetShadow(kamikaze_td[5], 0);

	kamikaze_td[6] = TextDrawCreate(366.9327, 314.6364, "x1.2"); // пусто
	TextDrawLetterSize(kamikaze_td[6], 0.3165, 1.2888);
	TextDrawAlignment(kamikaze_td[6], 1);
	TextDrawColor(kamikaze_td[6], -1061109505);
	TextDrawBackgroundColor(kamikaze_td[6], 255);
	TextDrawFont(kamikaze_td[6], 1);
	TextDrawSetProportional(kamikaze_td[6], 1);
	TextDrawSetShadow(kamikaze_td[6], 0);

	kamikaze_td[7] = TextDrawCreate(367.2327, 252.4344, "x2.0"); // пусто
	TextDrawLetterSize(kamikaze_td[7], 0.3165, 1.2888);
	TextDrawTextSize(kamikaze_td[7], 0.0000, 0.0296);
	TextDrawAlignment(kamikaze_td[7], 1);
	TextDrawColor(kamikaze_td[7], -1061109505);
	TextDrawBackgroundColor(kamikaze_td[7], 255);
	TextDrawFont(kamikaze_td[7], 1);
	TextDrawSetProportional(kamikaze_td[7], 1);
	TextDrawSetShadow(kamikaze_td[7], 0);

	kamikaze_td[8] = TextDrawCreate(366.9327, 219.4850, "x2.5"); // пусто
	TextDrawLetterSize(kamikaze_td[8], 0.3165, 1.2888);
	TextDrawAlignment(kamikaze_td[8], 1);
	TextDrawColor(kamikaze_td[8], -1061109505);
	TextDrawBackgroundColor(kamikaze_td[8], 255);
	TextDrawFont(kamikaze_td[8], 1);
	TextDrawSetProportional(kamikaze_td[8], 1);
	TextDrawSetShadow(kamikaze_td[8], 0);

	kamikaze_td[9] = TextDrawCreate(366.9327, 188.5847, "x3.0"); // пусто
	TextDrawLetterSize(kamikaze_td[9], 0.3165, 1.2888);
	TextDrawAlignment(kamikaze_td[9], 1);
	TextDrawColor(kamikaze_td[9], -1061109505);
	TextDrawBackgroundColor(kamikaze_td[9], 255);
	TextDrawFont(kamikaze_td[9], 1);
	TextDrawSetProportional(kamikaze_td[9], 1);
	TextDrawSetShadow(kamikaze_td[9], 0);

	kamikaze_td[10] = TextDrawCreate(367.5328, 283.5772, "x1.5"); // пусто
	TextDrawLetterSize(kamikaze_td[10], 0.3165, 1.2888);
	TextDrawAlignment(kamikaze_td[10], 1);
	TextDrawColor(kamikaze_td[10], -1061109505);
	TextDrawBackgroundColor(kamikaze_td[10], 255);
	TextDrawFont(kamikaze_td[10], 1);
	TextDrawSetProportional(kamikaze_td[10], 1);
	TextDrawSetShadow(kamikaze_td[10], 0);

	kamikaze_td[11] = TextDrawCreate(408.8688, 315.6058, "ld_spac:white"); // x1.2
	TextDrawTextSize(kamikaze_td[11], 43.0000, 12.0000);
	TextDrawAlignment(kamikaze_td[11], 1);
	TextDrawColor(kamikaze_td[11], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[11], 255);
	TextDrawFont(kamikaze_td[11], 4);
	TextDrawSetProportional(kamikaze_td[11], 0);
	TextDrawSetShadow(kamikaze_td[11], 0);

	kamikaze_td[12] = TextDrawCreate(408.5354, 189.1591, "ld_spac:white"); // x3.0
	TextDrawTextSize(kamikaze_td[12], 43.0000, 12.0000);
	TextDrawAlignment(kamikaze_td[12], 1);
	TextDrawColor(kamikaze_td[12], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[12], 255);
	TextDrawFont(kamikaze_td[12], 4);
	TextDrawSetProportional(kamikaze_td[12], 0);
	TextDrawSetShadow(kamikaze_td[12], 0);

	kamikaze_td[13] = TextDrawCreate(408.5354, 156.6578, "ld_spac:white"); // x3.5
	TextDrawTextSize(kamikaze_td[13], 43.0000, 12.0000);
	TextDrawAlignment(kamikaze_td[13], 1);
	TextDrawColor(kamikaze_td[13], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[13], 255);
	TextDrawFont(kamikaze_td[13], 4);
	TextDrawSetProportional(kamikaze_td[13], 0);
	TextDrawSetShadow(kamikaze_td[13], 0);

	kamikaze_td[14] = TextDrawCreate(408.5354, 125.7583, "ld_spac:white"); // x4.5
	TextDrawTextSize(kamikaze_td[14], 43.0000, 12.0000);
	TextDrawAlignment(kamikaze_td[14], 1);
	TextDrawColor(kamikaze_td[14], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[14], 255);
	TextDrawFont(kamikaze_td[14], 4);
	TextDrawSetProportional(kamikaze_td[14], 0);
	TextDrawSetShadow(kamikaze_td[14], 0);

	kamikaze_td[15] = TextDrawCreate(408.8688, 219.7003, "ld_spac:white"); // x2.5
	TextDrawTextSize(kamikaze_td[15], 43.0000, 12.0000);
	TextDrawAlignment(kamikaze_td[15], 1);
	TextDrawColor(kamikaze_td[15], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[15], 255);
	TextDrawFont(kamikaze_td[15], 4);
	TextDrawSetProportional(kamikaze_td[15], 0);
	TextDrawSetShadow(kamikaze_td[15], 0);

	kamikaze_td[16] = TextDrawCreate(408.8688, 253.6024, "ld_spac:white"); // x2.0
	TextDrawTextSize(kamikaze_td[16], 43.0000, 12.0000);
	TextDrawAlignment(kamikaze_td[16], 1);
	TextDrawColor(kamikaze_td[16], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[16], 255);
	TextDrawFont(kamikaze_td[16], 4);
	TextDrawSetProportional(kamikaze_td[16], 0);
	TextDrawSetShadow(kamikaze_td[16], 0);

	kamikaze_td[17] = TextDrawCreate(408.8688, 284.6040, "ld_spac:white"); // x1.5
	TextDrawTextSize(kamikaze_td[17], 43.0000, 12.0000);
	TextDrawAlignment(kamikaze_td[17], 1);
	TextDrawColor(kamikaze_td[17], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[17], 255);
	TextDrawFont(kamikaze_td[17], 4);
	TextDrawSetProportional(kamikaze_td[17], 0);
	TextDrawSetShadow(kamikaze_td[17], 0);

	kamikaze_td[18] = TextDrawCreate(431.3330, 317.6910, "STOP_1.2"); // x1.2
	TextDrawLetterSize(kamikaze_td[18], 0.1439, 0.7950);
	TextDrawTextSize(kamikaze_td[18], 10.0000, 40.0000);
	TextDrawAlignment(kamikaze_td[18], 2);
	TextDrawColor(kamikaze_td[18], -1);
	TextDrawBackgroundColor(kamikaze_td[18], 255);
	TextDrawFont(kamikaze_td[18], 1);
	TextDrawSetProportional(kamikaze_td[18], 1);
	TextDrawSetShadow(kamikaze_td[18], 0);
	TextDrawSetSelectable(kamikaze_td[18], true);

	kamikaze_td[19] = TextDrawCreate(430.9996, 191.2442, "STOP_3.0"); // x3.0
	TextDrawLetterSize(kamikaze_td[19], 0.1439, 0.7950);
	TextDrawTextSize(kamikaze_td[19], 10.0000, 40.0000);
	TextDrawAlignment(kamikaze_td[19], 2);
	TextDrawColor(kamikaze_td[19], -1);
	TextDrawBackgroundColor(kamikaze_td[19], 255);
	TextDrawFont(kamikaze_td[19], 1);
	TextDrawSetProportional(kamikaze_td[19], 1);
	TextDrawSetShadow(kamikaze_td[19], 0);
	TextDrawSetSelectable(kamikaze_td[19], true);

	kamikaze_td[20] = TextDrawCreate(430.9996, 158.7431, "STOP_3.5"); // x3.5
	TextDrawLetterSize(kamikaze_td[20], 0.1439, 0.7950);
	TextDrawTextSize(kamikaze_td[20], 10.0000, 40.0000);
	TextDrawAlignment(kamikaze_td[20], 2);
	TextDrawColor(kamikaze_td[20], -1);
	TextDrawBackgroundColor(kamikaze_td[20], 255);
	TextDrawFont(kamikaze_td[20], 1);
	TextDrawSetProportional(kamikaze_td[20], 1);
	TextDrawSetShadow(kamikaze_td[20], 0);
	TextDrawSetSelectable(kamikaze_td[20], true);

	kamikaze_td[21] = TextDrawCreate(430.9996, 127.8432, "STOP_4.5"); // x4.5
	TextDrawLetterSize(kamikaze_td[21], 0.1439, 0.7950);
	TextDrawTextSize(kamikaze_td[21], 10.0000, 40.0000);
	TextDrawAlignment(kamikaze_td[21], 2);
	TextDrawColor(kamikaze_td[21], -1);
	TextDrawBackgroundColor(kamikaze_td[21], 255);
	TextDrawFont(kamikaze_td[21], 1);
	TextDrawSetProportional(kamikaze_td[21], 1);
	TextDrawSetShadow(kamikaze_td[21], 0);
	TextDrawSetSelectable(kamikaze_td[21], true);

	kamikaze_td[22] = TextDrawCreate(431.3330, 221.7854, "STOP_2.5"); // x2.5
	TextDrawLetterSize(kamikaze_td[22], 0.1439, 0.7950);
	TextDrawTextSize(kamikaze_td[22], 10.0000, 40.0000);
	TextDrawAlignment(kamikaze_td[22], 2);
	TextDrawColor(kamikaze_td[22], -1);
	TextDrawBackgroundColor(kamikaze_td[22], 255);
	TextDrawFont(kamikaze_td[22], 1);
	TextDrawSetProportional(kamikaze_td[22], 1);
	TextDrawSetShadow(kamikaze_td[22], 0);
	TextDrawSetSelectable(kamikaze_td[22], true);

	kamikaze_td[23] = TextDrawCreate(431.3330, 255.6873, "STOP_2.0"); // x2.0
	TextDrawLetterSize(kamikaze_td[23], 0.1439, 0.7950);
	TextDrawTextSize(kamikaze_td[23], 10.0000, 40.0000);
	TextDrawAlignment(kamikaze_td[23], 2);
	TextDrawColor(kamikaze_td[23], -1);
	TextDrawBackgroundColor(kamikaze_td[23], 255);
	TextDrawFont(kamikaze_td[23], 1);
	TextDrawSetProportional(kamikaze_td[23], 1);
	TextDrawSetShadow(kamikaze_td[23], 0);
	TextDrawSetSelectable(kamikaze_td[23], true);

	kamikaze_td[24] = TextDrawCreate(431.3330, 286.6892, "STOP_1.5"); // x1.5
	TextDrawLetterSize(kamikaze_td[24], 0.1439, 0.7950);
	TextDrawTextSize(kamikaze_td[24], 10.0000, 40.0000);
	TextDrawAlignment(kamikaze_td[24], 2);
	TextDrawColor(kamikaze_td[24], -1);
	TextDrawBackgroundColor(kamikaze_td[24], 255);
	TextDrawFont(kamikaze_td[24], 1);
	TextDrawSetProportional(kamikaze_td[24], 1);
	TextDrawSetShadow(kamikaze_td[24], 0);
	TextDrawSetSelectable(kamikaze_td[24], true);

	kamikaze_td[25] = TextDrawCreate(184.8329, 95.3814, "ld_spac:white"); // пусто
	TextDrawTextSize(kamikaze_td[25], 151.0000, 15.0000);
	TextDrawAlignment(kamikaze_td[25], 1);
	TextDrawColor(kamikaze_td[25], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[25], 255);
	TextDrawFont(kamikaze_td[25], 4);
	TextDrawSetProportional(kamikaze_td[25], 0);
	TextDrawSetShadow(kamikaze_td[25], 0);

	kamikaze_td[26] = TextDrawCreate(357.0014, 95.3815, "ld_spac:white"); // пусто
	TextDrawTextSize(kamikaze_td[26], 94.0000, 15.0000);
	TextDrawAlignment(kamikaze_td[26], 1);
	TextDrawColor(kamikaze_td[26], color_textdraw);
	TextDrawBackgroundColor(kamikaze_td[26], 255);
	TextDrawFont(kamikaze_td[26], 4);
	TextDrawSetProportional(kamikaze_td[26], 0);
	TextDrawSetShadow(kamikaze_td[26], 0);

	kamikaze_td[27] = TextDrawCreate(243.9998, 98.5407, "KAMIKAZE"); // пусто
	TextDrawLetterSize(kamikaze_td[27], 0.1864, 0.8988);
	TextDrawAlignment(kamikaze_td[27], 1);
	TextDrawColor(kamikaze_td[27], -1);
	TextDrawBackgroundColor(kamikaze_td[27], 255);
	TextDrawFont(kamikaze_td[27], 1);
	TextDrawSetProportional(kamikaze_td[27], 1);
	TextDrawSetShadow(kamikaze_td[27], 0);

	kamikaze_td[28] = TextDrawCreate(382.2337, 98.2406, "BET"); // пусто
	TextDrawLetterSize(kamikaze_td[28], 0.1864, 0.8988);
	TextDrawTextSize(kamikaze_td[28], 10.0000, 35.0000);
	TextDrawAlignment(kamikaze_td[28], 2);
	TextDrawColor(kamikaze_td[28], -1);
	TextDrawBackgroundColor(kamikaze_td[28], 255);
	TextDrawFont(kamikaze_td[28], 1);
	TextDrawSetProportional(kamikaze_td[28], 1);
	TextDrawSetShadow(kamikaze_td[28], 0);
	TextDrawSetSelectable(kamikaze_td[28], true);

	kamikaze_td[29] = TextDrawCreate(427.7666, 98.2406, "EXIT"); // пусто
	TextDrawLetterSize(kamikaze_td[29], 0.1864, 0.8988);
	TextDrawTextSize(kamikaze_td[29], 10.0000, 35.0000);
	TextDrawAlignment(kamikaze_td[29], 2);
	TextDrawColor(kamikaze_td[29], -1);
	TextDrawBackgroundColor(kamikaze_td[29], 255);
	TextDrawFont(kamikaze_td[29], 1);
	TextDrawSetProportional(kamikaze_td[29], 1);
	TextDrawSetShadow(kamikaze_td[29], 0);
	TextDrawSetSelectable(kamikaze_td[29], true);

	kamikaze_td[30] = TextDrawCreate(451.8330, 79.2629, "ld_beat:chit"); // пусто
	TextDrawTextSize(kamikaze_td[30], 12.0000, 16.0000);
	TextDrawAlignment(kamikaze_td[30], 1);
	TextDrawColor(kamikaze_td[30], color_black_box);
	TextDrawBackgroundColor(kamikaze_td[30], 255);
	TextDrawFont(kamikaze_td[30], 4);
	TextDrawSetProportional(kamikaze_td[30], 0);
	TextDrawSetShadow(kamikaze_td[30], 0);

	kamikaze_td[31] = TextDrawCreate(173.8661, 79.2628, "ld_beat:chit"); // пусто
	TextDrawTextSize(kamikaze_td[31], 12.0000, 16.0000);
	TextDrawAlignment(kamikaze_td[31], 1);
	TextDrawColor(kamikaze_td[31], color_black_box);
	TextDrawBackgroundColor(kamikaze_td[31], 255);
	TextDrawFont(kamikaze_td[31], 4);
	TextDrawSetProportional(kamikaze_td[31], 0);
	TextDrawSetShadow(kamikaze_td[31], 0);

	kamikaze_td[32] = TextDrawCreate(451.8327, 338.5220, "ld_beat:chit"); // пусто
	TextDrawTextSize(kamikaze_td[32], 12.0000, 16.0000);
	TextDrawAlignment(kamikaze_td[32], 1);
	TextDrawColor(kamikaze_td[32], color_black_box);
	TextDrawBackgroundColor(kamikaze_td[32], 255);
	TextDrawFont(kamikaze_td[32], 4);
	TextDrawSetProportional(kamikaze_td[32], 0);
	TextDrawSetShadow(kamikaze_td[32], 0);

	kamikaze_td[33] = TextDrawCreate(173.8661, 338.5220, "ld_beat:chit"); // пусто
	TextDrawTextSize(kamikaze_td[33], 12.0000, 16.0000);
	TextDrawAlignment(kamikaze_td[33], 1);
	TextDrawColor(kamikaze_td[33], color_black_box);
	TextDrawBackgroundColor(kamikaze_td[33], 255);
	TextDrawFont(kamikaze_td[33], 4);
	TextDrawSetProportional(kamikaze_td[33], 0);
	TextDrawSetShadow(kamikaze_td[33], 0);

	kamikaze_td[34] = TextDrawCreate(180.5997, 81.8777, "ld_spac:white"); // пусто
	TextDrawTextSize(kamikaze_td[34], 278.0000, 9.0000);
	TextDrawAlignment(kamikaze_td[34], 1);
	TextDrawColor(kamikaze_td[34], color_black_box);
	TextDrawBackgroundColor(kamikaze_td[34], 255);
	TextDrawFont(kamikaze_td[34], 4);
	TextDrawSetProportional(kamikaze_td[34], 0);
	TextDrawSetShadow(kamikaze_td[34], 0);

	kamikaze_td[35] = TextDrawCreate(179.6665, 342.8814, "ld_spac:white"); // пусто
	TextDrawTextSize(kamikaze_td[35], 278.0000, 9.0000);
	TextDrawAlignment(kamikaze_td[35], 1);
	TextDrawColor(kamikaze_td[35], color_black_box);
	TextDrawBackgroundColor(kamikaze_td[35], 255);
	TextDrawFont(kamikaze_td[35], 4);
	TextDrawSetProportional(kamikaze_td[35], 0);
	TextDrawSetShadow(kamikaze_td[35], 0);
	
	// Car Shop count
	TextDrawTextSize(td_tshop_count[0], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop_count[0], 1);
	TextDrawColor(td_tshop_count[0], 437918463);
	TextDrawBackgroundColor(td_tshop_count[0], 255);
	TextDrawFont(td_tshop_count[0], 4);
	TextDrawSetProportional(td_tshop_count[0], 0);
	TextDrawSetShadow(td_tshop_count[0], 0);

	td_tshop_count[1] = TextDrawCreate(482.3699, 319.4995, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tshop_count[1], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop_count[1], 1);
	TextDrawColor(td_tshop_count[1], 437918463);
	TextDrawBackgroundColor(td_tshop_count[1], 255);
	TextDrawFont(td_tshop_count[1], 4);
	TextDrawSetProportional(td_tshop_count[1], 0);
	TextDrawSetShadow(td_tshop_count[1], 0);

	td_tshop_count[2] = TextDrawCreate(490.3699, 321.9884, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tshop_count[2], 63.0000, 24.0599);
	TextDrawAlignment(td_tshop_count[2], 1);
	TextDrawColor(td_tshop_count[2], 437918463);
	TextDrawBackgroundColor(td_tshop_count[2], 255);
	TextDrawFont(td_tshop_count[2], 4);
	TextDrawSetProportional(td_tshop_count[2], 0);
	TextDrawSetShadow(td_tshop_count[2], 0);

	td_tshop_count[3] = TextDrawCreate(484.7031, 326.1365, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tshop_count[3], 63.0000, 14.0600);
	TextDrawAlignment(td_tshop_count[3], 1);
	TextDrawColor(td_tshop_count[3], 437918463);
	TextDrawBackgroundColor(td_tshop_count[3], 255);
	TextDrawFont(td_tshop_count[3], 4);
	TextDrawSetProportional(td_tshop_count[3], 0);
	TextDrawSetShadow(td_tshop_count[3], 0);

	td_tshop_count[4] = TextDrawCreate(511.1328, 329.7911, "IN_STOCK"); // пусто
	TextDrawLetterSize(td_tshop_count[4], 0.1784, 0.8529);
	TextDrawTextSize(td_tshop_count[4], 0.0000, 77.0000);
	TextDrawAlignment(td_tshop_count[4], 2);
	TextDrawColor(td_tshop_count[4], -1061109505);
	TextDrawUseBox(td_tshop_count[4], 1);
	TextDrawBoxColor(td_tshop_count[4], 0);
	TextDrawBackgroundColor(td_tshop_count[4], 255);
	TextDrawFont(td_tshop_count[4], 1);
	TextDrawSetProportional(td_tshop_count[4], 1);
	TextDrawSetShadow(td_tshop_count[4], 0);

	td_tshop_count[5] = TextDrawCreate(591.2990, 333.8004, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tshop_count[5], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop_count[5], 1);
	TextDrawColor(td_tshop_count[5], 336860415);
	TextDrawBackgroundColor(td_tshop_count[5], 255);
	TextDrawFont(td_tshop_count[5], 4);
	TextDrawSetProportional(td_tshop_count[5], 0);
	TextDrawSetShadow(td_tshop_count[5], 0);

	td_tshop_count[6] = TextDrawCreate(533.0670, 333.8004, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tshop_count[6], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop_count[6], 1);
	TextDrawColor(td_tshop_count[6], 336860415);
	TextDrawBackgroundColor(td_tshop_count[6], 255);
	TextDrawFont(td_tshop_count[6], 4);
	TextDrawSetProportional(td_tshop_count[6], 0);
	TextDrawSetShadow(td_tshop_count[6], 0);

	td_tshop_count[7] = TextDrawCreate(591.2990, 319.4995, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tshop_count[7], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop_count[7], 1);
	TextDrawColor(td_tshop_count[7], 336860415);
	TextDrawBackgroundColor(td_tshop_count[7], 255);
	TextDrawFont(td_tshop_count[7], 4);
	TextDrawSetProportional(td_tshop_count[7], 0);
	TextDrawSetShadow(td_tshop_count[7], 0);

	td_tshop_count[8] = TextDrawCreate(533.0670, 319.4995, "ld_beat:chit"); // пусто
	TextDrawTextSize(td_tshop_count[8], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop_count[8], 1);
	TextDrawColor(td_tshop_count[8], 336860415);
	TextDrawBackgroundColor(td_tshop_count[8], 255);
	TextDrawFont(td_tshop_count[8], 4);
	TextDrawSetProportional(td_tshop_count[8], 0);
	TextDrawSetShadow(td_tshop_count[8], 0);

	td_tshop_count[9] = TextDrawCreate(541.1671, 321.9735, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tshop_count[9], 58.0000, 24.0000);
	TextDrawAlignment(td_tshop_count[9], 1);
	TextDrawColor(td_tshop_count[9], 336860415);
	TextDrawBackgroundColor(td_tshop_count[9], 255);
	TextDrawFont(td_tshop_count[9], 4);
	TextDrawSetProportional(td_tshop_count[9], 0);
	TextDrawSetShadow(td_tshop_count[9], 0);

	td_tshop_count[10] = TextDrawCreate(535.6007, 327.3662, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tshop_count[10], 68.2898, 14.0000);
	TextDrawAlignment(td_tshop_count[10], 1);
	TextDrawColor(td_tshop_count[10], 336860415);
	TextDrawBackgroundColor(td_tshop_count[10], 255);
	TextDrawFont(td_tshop_count[10], 4);
	TextDrawSetProportional(td_tshop_count[10], 0);
	TextDrawSetShadow(td_tshop_count[10], 0);
	
	// Car Shop
	td_tshop[0] = TextDrawCreate(482.6329, 135.0879, "ld_beat:chit"); // header box
	TextDrawTextSize(td_tshop[0], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop[0], 1);
	TextDrawColor(td_tshop[0], color_textdraw);
	TextDrawBackgroundColor(td_tshop[0], 255);
	TextDrawFont(td_tshop[0], 4);
	TextDrawSetProportional(td_tshop[0], 0);
	TextDrawSetShadow(td_tshop[0], 0);

	td_tshop[1] = TextDrawCreate(591.3325, 135.1737, "ld_beat:chit"); // header box
	TextDrawTextSize(td_tshop[1], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop[1], 1);
	TextDrawColor(td_tshop[1], color_textdraw);
	TextDrawBackgroundColor(td_tshop[1], 255);
	TextDrawFont(td_tshop[1], 4);
	TextDrawSetProportional(td_tshop[1], 0);
	TextDrawSetShadow(td_tshop[1], 0);

	td_tshop[2] = TextDrawCreate(482.4992, 302.8869, "ld_beat:chit"); // body box
	TextDrawTextSize(td_tshop[2], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop[2], 1);
	TextDrawColor(td_tshop[2], color_black_box);
	TextDrawBackgroundColor(td_tshop[2], 255);
	TextDrawFont(td_tshop[2], 4);
	TextDrawSetProportional(td_tshop[2], 0);
	TextDrawSetShadow(td_tshop[2], 0);

	td_tshop[3] = TextDrawCreate(591.4992, 302.9873, "ld_beat:chit"); // body box
	TextDrawTextSize(td_tshop[3], 15.0000, 15.0000);
	TextDrawAlignment(td_tshop[3], 1);
	TextDrawColor(td_tshop[3], color_black_box);
	TextDrawBackgroundColor(td_tshop[3], 255);
	TextDrawFont(td_tshop[3], 4);
	TextDrawSetProportional(td_tshop[3], 0);
	TextDrawSetShadow(td_tshop[3], 0);

	td_tshop[4] = TextDrawCreate(490.3327, 137.5767, "ld_spac:white"); // header box
	TextDrawTextSize(td_tshop[4], 108.0000, 19.0000);
	TextDrawAlignment(td_tshop[4], 1);
	TextDrawColor(td_tshop[4], color_textdraw);
	TextDrawBackgroundColor(td_tshop[4], 255);
	TextDrawFont(td_tshop[4], 4);
	TextDrawSetProportional(td_tshop[4], 0);
	TextDrawSetShadow(td_tshop[4], 0);

	td_tshop[5] = TextDrawCreate(484.8995, 142.9696, "ld_spac:white"); // header box
	TextDrawTextSize(td_tshop[5], 119.0000, 15.0000);
	TextDrawAlignment(td_tshop[5], 1);
	TextDrawColor(td_tshop[5], color_textdraw);
	TextDrawBackgroundColor(td_tshop[5], 255);
	TextDrawFont(td_tshop[5], 4);
	TextDrawSetProportional(td_tshop[5], 0);
	TextDrawSetShadow(td_tshop[5], 0);

	td_tshop[6] = TextDrawCreate(490.3323, 275.4989, "ld_spac:white"); // body box
	TextDrawTextSize(td_tshop[6], 110.0000, 40.0000);
	TextDrawAlignment(td_tshop[6], 1);
	TextDrawColor(td_tshop[6], color_black_box);
	TextDrawBackgroundColor(td_tshop[6], 255);
	TextDrawFont(td_tshop[6], 4);
	TextDrawSetProportional(td_tshop[6], 0);
	TextDrawSetShadow(td_tshop[6], 0);

	td_tshop[7] = TextDrawCreate(484.9996, 157.9033, "ld_spac:white"); // body box
	TextDrawTextSize(td_tshop[7], 119.0000, 152.0000);
	TextDrawAlignment(td_tshop[7], 1);
	TextDrawColor(td_tshop[7], color_black_box);
	TextDrawBackgroundColor(td_tshop[7], 255);
	TextDrawFont(td_tshop[7], 4);
	TextDrawSetProportional(td_tshop[7], 0);
	TextDrawSetShadow(td_tshop[7], 0);

	td_tshop[8] = TextDrawCreate(486.9992, 159.9777, "ld_spac:white"); // пусто
	TextDrawTextSize(td_tshop[8], 115.0000, 2.0000);
	TextDrawAlignment(td_tshop[8], 1);
	TextDrawColor(td_tshop[8], color_light_grey);
	TextDrawBackgroundColor(td_tshop[8], 255);
	TextDrawFont(td_tshop[8], 4);
	TextDrawSetProportional(td_tshop[8], 0);
	TextDrawSetShadow(td_tshop[8], 0);

	td_tshop[9] = TextDrawCreate(544.3322, 141.0507, "AUTOSALON"); // header tx
	TextDrawLetterSize(td_tshop[9], 0.1972, 0.9236);
	TextDrawAlignment(td_tshop[9], 2);
	TextDrawColor(td_tshop[9], color_server);
	TextDrawBackgroundColor(td_tshop[9], 255);
	TextDrawFont(td_tshop[9], 1);
	TextDrawSetProportional(td_tshop[9], 1);
	TextDrawSetShadow(td_tshop[9], 0);

	td_tshop[10] = TextDrawCreate(544.3328, 147.6876, "PREMIUM CLASS"); // header tx
	TextDrawLetterSize(td_tshop[10], 0.1419, 0.6915);
	TextDrawAlignment(td_tshop[10], 2);
	TextDrawColor(td_tshop[10], color_server);
	TextDrawBackgroundColor(td_tshop[10], 255);
	TextDrawFont(td_tshop[10], 1);
	TextDrawSetProportional(td_tshop[10], 1);
	TextDrawSetShadow(td_tshop[10], 0);

	td_tshop[11] = TextDrawCreate(585.5321, 173.6654, "ld_spac:white"); // range 1 bt ">>"
	TextDrawTextSize(td_tshop[11], 15.0000, 14.0000);
	TextDrawAlignment(td_tshop[11], 1);
	TextDrawColor(td_tshop[11], color_box);
	TextDrawBackgroundColor(td_tshop[11], 255);
	TextDrawFont(td_tshop[11], 4);
	TextDrawSetProportional(td_tshop[11], 0);
	TextDrawSetShadow(td_tshop[11], 0);

	td_tshop[12] = TextDrawCreate(488.1989, 173.6654, "ld_spac:white"); // range 1 bt "<<"
	TextDrawTextSize(td_tshop[12], 15.0000, 14.0000);
	TextDrawAlignment(td_tshop[12], 1);
	TextDrawColor(td_tshop[12], color_box);
	TextDrawBackgroundColor(td_tshop[12], 255);
	TextDrawFont(td_tshop[12], 4);
	TextDrawSetProportional(td_tshop[12], 0);
	TextDrawSetShadow(td_tshop[12], 0);

	td_tshop[13] = TextDrawCreate(504.1990, 173.6654, "ld_spac:white"); // range 1 bt "car model"
	TextDrawTextSize(td_tshop[13], 80.3498, 14.0000);
	TextDrawAlignment(td_tshop[13], 1);
	TextDrawColor(td_tshop[13], color_box);
	TextDrawBackgroundColor(td_tshop[13], 255);
	TextDrawFont(td_tshop[13], 4);
	TextDrawSetProportional(td_tshop[13], 0);
	TextDrawSetShadow(td_tshop[13], 0);

	td_tshop[14] = TextDrawCreate(495.5320, 176.7247, "<<"); // range 1 tx "<<"
	TextDrawLetterSize(td_tshop[14], 0.1972, 0.9236);
	TextDrawTextSize(td_tshop[14], 15.0000, 14.0000);
	TextDrawAlignment(td_tshop[14], 2);
	TextDrawColor(td_tshop[14], -1768515841);
	TextDrawUseBox(td_tshop[14], 1);
	TextDrawBoxColor(td_tshop[14], 0);
	TextDrawBackgroundColor(td_tshop[14], 255);
	TextDrawFont(td_tshop[14], 1);
	TextDrawSetProportional(td_tshop[14], 1);
	TextDrawSetShadow(td_tshop[14], 0);
	TextDrawSetSelectable(td_tshop[14], true);

	td_tshop[15] = TextDrawCreate(592.8648, 176.7247, ">>"); // range 1 tx ">>"
	TextDrawLetterSize(td_tshop[15], 0.1972, 0.9236);
	TextDrawTextSize(td_tshop[15], 15.0000, 14.0000);
	TextDrawAlignment(td_tshop[15], 2);
	TextDrawColor(td_tshop[15], -1768515841);
	TextDrawUseBox(td_tshop[15], 1);
	TextDrawBoxColor(td_tshop[15], 0);
	TextDrawBackgroundColor(td_tshop[15], 255);
	TextDrawFont(td_tshop[15], 1);
	TextDrawSetProportional(td_tshop[15], 1);
	TextDrawSetShadow(td_tshop[15], 0);
	TextDrawSetSelectable(td_tshop[15], true);

	td_tshop[16] = TextDrawCreate(544.1994, 165.5247, "CHOSE MODEL"); // range 1 tx "chs model"
	TextDrawLetterSize(td_tshop[16], 0.1419, 0.6915);
	TextDrawAlignment(td_tshop[16], 2);
	TextDrawColor(td_tshop[16], color_textdraw);
	TextDrawBackgroundColor(td_tshop[16], 255);
	TextDrawFont(td_tshop[16], 1);
	TextDrawSetProportional(td_tshop[16], 1);
	TextDrawSetShadow(td_tshop[16], 0);

	td_tshop[17] = TextDrawCreate(585.5322, 198.9687, "ld_spac:white"); // range 2 bt ">>"
	TextDrawTextSize(td_tshop[17], 15.0000, 14.0000);
	TextDrawAlignment(td_tshop[17], 1);
	TextDrawColor(td_tshop[17], color_box);
	TextDrawBackgroundColor(td_tshop[17], 255);
	TextDrawFont(td_tshop[17], 4);
	TextDrawSetProportional(td_tshop[17], 0);
	TextDrawSetShadow(td_tshop[17], 0);

	td_tshop[18] = TextDrawCreate(488.1990, 198.9687, "ld_spac:white"); // range 2 bt "<<"
	TextDrawTextSize(td_tshop[18], 15.0000, 14.0000);
	TextDrawAlignment(td_tshop[18], 1);
	TextDrawColor(td_tshop[18], color_box);
	TextDrawBackgroundColor(td_tshop[18], 255);
	TextDrawFont(td_tshop[18], 4);
	TextDrawSetProportional(td_tshop[18], 0);
	TextDrawSetShadow(td_tshop[18], 0);

	td_tshop[19] = TextDrawCreate(504.1990, 198.9687, "ld_spac:white"); // range 2 bt "car color"
	TextDrawTextSize(td_tshop[19], 80.3498, 14.0000);
	TextDrawAlignment(td_tshop[19], 1);
	TextDrawColor(td_tshop[19], color_box);
	TextDrawBackgroundColor(td_tshop[19], 255);
	TextDrawFont(td_tshop[19], 4);
	TextDrawSetProportional(td_tshop[19], 0);
	TextDrawSetShadow(td_tshop[19], 0);

	td_tshop[20] = TextDrawCreate(495.5320, 202.0281, "<<"); // range 2 tx "<<"
	TextDrawLetterSize(td_tshop[20], 0.1972, 0.9236);
	TextDrawTextSize(td_tshop[20], 15.0000, 14.0000);
	TextDrawAlignment(td_tshop[20], 2);
	TextDrawColor(td_tshop[20], -1768515841);
	TextDrawUseBox(td_tshop[20], 1);
	TextDrawBoxColor(td_tshop[20], 0);
	TextDrawBackgroundColor(td_tshop[20], 255);
	TextDrawFont(td_tshop[20], 1);
	TextDrawSetProportional(td_tshop[20], 1);
	TextDrawSetShadow(td_tshop[20], 0);
	TextDrawSetSelectable(td_tshop[20], true);

	td_tshop[21] = TextDrawCreate(592.8648, 202.0281, ">>"); // range 2 tx ">>"
	TextDrawLetterSize(td_tshop[21], 0.1972, 0.9236);
	TextDrawTextSize(td_tshop[21], 15.0000, 14.0000);
	TextDrawAlignment(td_tshop[21], 2);
	TextDrawColor(td_tshop[21], -1768515841);
	TextDrawUseBox(td_tshop[21], 1);
	TextDrawBoxColor(td_tshop[21], 0);
	TextDrawBackgroundColor(td_tshop[21], 255);
	TextDrawFont(td_tshop[21], 1);
	TextDrawSetProportional(td_tshop[21], 1);
	TextDrawSetShadow(td_tshop[21], 0);
	TextDrawSetSelectable(td_tshop[21], true);

	td_tshop[22] = TextDrawCreate(544.1994, 190.8280, "CHOSE COLOR"); // range 2 tx "chs color"
	TextDrawLetterSize(td_tshop[22], 0.1419, 0.6915);
	TextDrawAlignment(td_tshop[22], 2);
	TextDrawColor(td_tshop[22], color_textdraw);
	TextDrawBackgroundColor(td_tshop[22], 255);
	TextDrawFont(td_tshop[22], 1);
	TextDrawSetProportional(td_tshop[22], 1);
	TextDrawSetShadow(td_tshop[22], 0);

	td_tshop[23] = TextDrawCreate(594.8322, 287.3240, "ld_beat:chit"); // box - characteristic
	TextDrawTextSize(td_tshop[23], 7.0000, 7.0000);
	TextDrawAlignment(td_tshop[23], 1);
	TextDrawColor(td_tshop[23], color_box);
	TextDrawBackgroundColor(td_tshop[23], 255);
	TextDrawFont(td_tshop[23], 4);
	TextDrawSetProportional(td_tshop[23], 0);
	TextDrawSetShadow(td_tshop[23], 0);

	td_tshop[24] = TextDrawCreate(486.4992, 287.3240, "ld_beat:chit"); // box - characteristic
	TextDrawTextSize(td_tshop[24], 7.0000, 7.0000);
	TextDrawAlignment(td_tshop[24], 1);
	TextDrawColor(td_tshop[24], color_box);
	TextDrawBackgroundColor(td_tshop[24], 255);
	TextDrawFont(td_tshop[24], 4);
	TextDrawSetProportional(td_tshop[24], 0);
	TextDrawSetShadow(td_tshop[24], 0);

	td_tshop[25] = TextDrawCreate(490.1990, 224.2725, "ld_spac:white"); // box - characteristic
	TextDrawTextSize(td_tshop[25], 108.0000, 69.0000);
	TextDrawAlignment(td_tshop[25], 1);
	TextDrawColor(td_tshop[25], color_box);
	TextDrawBackgroundColor(td_tshop[25], 255);
	TextDrawFont(td_tshop[25], 4);
	TextDrawSetProportional(td_tshop[25], 0);
	TextDrawSetShadow(td_tshop[25], 0);

	td_tshop[26] = TextDrawCreate(487.8658, 226.3466, "ld_spac:white"); // box - characteristic
	TextDrawTextSize(td_tshop[26], 113.0000, 64.0000);
	TextDrawAlignment(td_tshop[26], 1);
	TextDrawColor(td_tshop[26], color_box);
	TextDrawBackgroundColor(td_tshop[26], 255);
	TextDrawFont(td_tshop[26], 4);
	TextDrawSetProportional(td_tshop[26], 0);
	TextDrawSetShadow(td_tshop[26], 0);

	td_tshop[27] = TextDrawCreate(544.1994, 215.7167, "CHARACTER CAR"); // text - characteristic
	TextDrawLetterSize(td_tshop[27], 0.1419, 0.6915);
	TextDrawAlignment(td_tshop[27], 2);
	TextDrawColor(td_tshop[27], color_textdraw);
	TextDrawBackgroundColor(td_tshop[27], 255);
	TextDrawFont(td_tshop[27], 1);
	TextDrawSetProportional(td_tshop[27], 1);
	TextDrawSetShadow(td_tshop[27], 0);

	td_tshop[28] = TextDrawCreate(492.4327, 235.4732, "ld_spac:white"); // line 1 bg - "max speed"
	TextDrawTextSize(td_tshop[28], 103.0000, 4.0000);
	TextDrawAlignment(td_tshop[28], 1);
	TextDrawColor(td_tshop[28], color_light_grey);
	TextDrawBackgroundColor(td_tshop[28], 255);
	TextDrawFont(td_tshop[28], 4);
	TextDrawSetProportional(td_tshop[28], 0);
	TextDrawSetShadow(td_tshop[28], 0);

	td_tshop[29] = TextDrawCreate(492.4327, 251.2357, "ld_spac:white"); // line 2 bg - "acceler"
	TextDrawTextSize(td_tshop[29], 103.0000, 4.0000);
	TextDrawAlignment(td_tshop[29], 1);
	TextDrawColor(td_tshop[29], color_light_grey);
	TextDrawBackgroundColor(td_tshop[29], 255);
	TextDrawFont(td_tshop[29], 4);
	TextDrawSetProportional(td_tshop[29], 0);
	TextDrawSetShadow(td_tshop[29], 0);

	td_tshop[30] = TextDrawCreate(492.4327, 267.4132, "ld_spac:white"); // line 3 bg - "braking"
	TextDrawTextSize(td_tshop[30], 103.0000, 4.0000);
	TextDrawAlignment(td_tshop[30], 1);
	TextDrawColor(td_tshop[30], color_light_grey);
	TextDrawBackgroundColor(td_tshop[30], 255);
	TextDrawFont(td_tshop[30], 4);
	TextDrawSetProportional(td_tshop[30], 0);
	TextDrawSetShadow(td_tshop[30], 0);

	td_tshop[31] = TextDrawCreate(492.4327, 283.5914, "ld_spac:white"); // line 4 bg - "clutch"
	TextDrawTextSize(td_tshop[31], 103.0000, 4.0000);
	TextDrawAlignment(td_tshop[31], 1);
	TextDrawColor(td_tshop[31], color_light_grey);
	TextDrawBackgroundColor(td_tshop[31], 255);
	TextDrawFont(td_tshop[31], 4);
	TextDrawSetProportional(td_tshop[31], 0);
	TextDrawSetShadow(td_tshop[31], 0);

	td_tshop[32] = TextDrawCreate(594.8327, 223.0281, "ld_beat:chit"); // box - characteristic
	TextDrawTextSize(td_tshop[32], 7.0000, 7.0000);
	TextDrawAlignment(td_tshop[32], 1);
	TextDrawColor(td_tshop[32], color_box);
	TextDrawBackgroundColor(td_tshop[32], 255);
	TextDrawFont(td_tshop[32], 4);
	TextDrawSetProportional(td_tshop[32], 0);
	TextDrawSetShadow(td_tshop[32], 0);

	td_tshop[33] = TextDrawCreate(486.4995, 223.0281, "ld_beat:chit"); // box - characteristic
	TextDrawTextSize(td_tshop[33], 7.0000, 7.0000);
	TextDrawAlignment(td_tshop[33], 1);
	TextDrawColor(td_tshop[33], color_box);
	TextDrawBackgroundColor(td_tshop[33], 255);
	TextDrawFont(td_tshop[33], 4);
	TextDrawSetProportional(td_tshop[33], 0);
	TextDrawSetShadow(td_tshop[33], 0);

	td_tshop[34] = TextDrawCreate(487.8658, 296.0357, "ld_spac:white"); // range 3 box - "buy"
	TextDrawTextSize(td_tshop[34], 56.0000, 14.0000);
	TextDrawAlignment(td_tshop[34], 1);
	TextDrawColor(td_tshop[34], color_box);
	TextDrawBackgroundColor(td_tshop[34], 255);
	TextDrawFont(td_tshop[34], 4);
	TextDrawSetProportional(td_tshop[34], 0);
	TextDrawSetShadow(td_tshop[34], 0);
	
	td_tshop[35] = TextDrawCreate(515.8654, 298.6799, "MENU"); // range 3 tx - "buy"
	TextDrawLetterSize(td_tshop[35], 0.1972, 0.9236);
	TextDrawTextSize(td_tshop[35], 56.0000, 14.0000);
	TextDrawAlignment(td_tshop[35], 2);
	TextDrawColor(td_tshop[35], -1768515841);
	TextDrawBackgroundColor(td_tshop[35], 255);
	TextDrawFont(td_tshop[35], 1);
	TextDrawSetProportional(td_tshop[35], 1);
	TextDrawSetShadow(td_tshop[35], 0);
	TextDrawSetSelectable(td_tshop[35], true);

	td_tshop[36] = TextDrawCreate(492.1989, 228.5760, "MAX SPEED"); // line 1 tx - "max speed"
	TextDrawLetterSize(td_tshop[36], 0.1419, 0.6915);
	TextDrawAlignment(td_tshop[36], 1);
	TextDrawColor(td_tshop[36], -1768515841);
	TextDrawBackgroundColor(td_tshop[36], 255);
	TextDrawFont(td_tshop[36], 1);
	TextDrawSetProportional(td_tshop[36], 1);
	TextDrawSetShadow(td_tshop[36], 0);

	td_tshop[37] = TextDrawCreate(492.1989, 244.3390, "ACCELER"); // line 2 tx - "acceler"
	TextDrawLetterSize(td_tshop[37], 0.1419, 0.6915);
	TextDrawAlignment(td_tshop[37], 1);
	TextDrawColor(td_tshop[37], -1768515841);
	TextDrawBackgroundColor(td_tshop[37], 255);
	TextDrawFont(td_tshop[37], 1);
	TextDrawSetProportional(td_tshop[37], 1);
	TextDrawSetShadow(td_tshop[37], 0);

	td_tshop[38] = TextDrawCreate(492.1989, 260.5162, "BRAKING"); // line 3 tx - "braking"
	TextDrawLetterSize(td_tshop[38], 0.1419, 0.6915);
	TextDrawAlignment(td_tshop[38], 1);
	TextDrawColor(td_tshop[38], -1768515841);
	TextDrawBackgroundColor(td_tshop[38], 255);
	TextDrawFont(td_tshop[38], 1);
	TextDrawSetProportional(td_tshop[38], 1);
	TextDrawSetShadow(td_tshop[38], 0);

	td_tshop[39] = TextDrawCreate(492.1989, 276.6943, "CLUTCH"); // line 4 tx - "clutch"
	TextDrawLetterSize(td_tshop[39], 0.1419, 0.6915);
	TextDrawAlignment(td_tshop[39], 1);
	TextDrawColor(td_tshop[39], -1768515841);
	TextDrawBackgroundColor(td_tshop[39], 255);
	TextDrawFont(td_tshop[39], 1);
	TextDrawSetProportional(td_tshop[39], 1);
	TextDrawSetShadow(td_tshop[39], 0);

	td_tshop[40] = TextDrawCreate(544.8659, 296.0357, "ld_spac:white"); // range 3 box - "exit"
	TextDrawTextSize(td_tshop[40], 56.0000, 14.0000);
	TextDrawAlignment(td_tshop[40], 1);
	TextDrawColor(td_tshop[40], color_box);
	TextDrawBackgroundColor(td_tshop[40], 255);
	TextDrawFont(td_tshop[40], 4);
	TextDrawSetProportional(td_tshop[40], 0);
	TextDrawSetShadow(td_tshop[40], 0);

	td_tshop[41] = TextDrawCreate(572.5321, 298.6799, "EXIT"); // range 3 tx - "exit"
	TextDrawLetterSize(td_tshop[41], 0.1972, 0.9236);
	TextDrawTextSize(td_tshop[41], 56.0000, 14.0000);
	TextDrawAlignment(td_tshop[41], 2);
	TextDrawColor(td_tshop[41], -1768515841);
	TextDrawBackgroundColor(td_tshop[41], 255);
	TextDrawFont(td_tshop[41], 1);
	TextDrawSetProportional(td_tshop[41], 1);
	TextDrawSetShadow(td_tshop[41], 0);
	TextDrawSetSelectable(td_tshop[41], true);
	
	// training td
	training_td[0] = TextDrawCreate(11.1999, 218.4666, "ld_spac:white"); // 1 Box
	TextDrawTextSize(training_td[0], 120.0000, 40.0000);
	TextDrawAlignment(training_td[0], 1);
	TextDrawColor(training_td[0], color_black_box);
	TextDrawBackgroundColor(training_td[0], 255);
	TextDrawFont(training_td[0], 4);
	TextDrawSetProportional(training_td[0], 0);
	TextDrawSetShadow(training_td[0], 0);

	training_td[1] = TextDrawCreate(11.1332, 209.7555, "ld_spac:white"); // 1 Box
	TextDrawTextSize(training_td[1], 120.0000, 9.5899);
	TextDrawAlignment(training_td[1], 1);
	TextDrawColor(training_td[1], color_textdraw);
	TextDrawBackgroundColor(training_td[1], 255);
	TextDrawFont(training_td[1], 4);
	TextDrawSetProportional(training_td[1], 0);
	TextDrawSetShadow(training_td[1], 0);

	training_td[2] = TextDrawCreate(8.6999, 200.2147, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[2], 15.0000, 18.0000);
	TextDrawAlignment(training_td[2], 1);
	TextDrawColor(training_td[2], color_textdraw);
	TextDrawBackgroundColor(training_td[2], 255);
	TextDrawFont(training_td[2], 4);
	TextDrawSetProportional(training_td[2], 0);
	TextDrawSetShadow(training_td[2], 0);

	training_td[3] = TextDrawCreate(13.1672, 222.9592, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[3], 12.0000, 15.0000);
	TextDrawAlignment(training_td[3], 1);
	TextDrawColor(training_td[3], color_box);
	TextDrawBackgroundColor(training_td[3], 255);
	TextDrawFont(training_td[3], 4);
	TextDrawSetProportional(training_td[3], 0);
	TextDrawSetShadow(training_td[3], 0);

	training_td[4] = TextDrawCreate(54.7342, 222.9591, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[4], 12.0000, 15.0000);
	TextDrawAlignment(training_td[4], 1);
	TextDrawColor(training_td[4], color_box);
	TextDrawBackgroundColor(training_td[4], 255);
	TextDrawFont(training_td[4], 4);
	TextDrawSetProportional(training_td[4], 0);
	TextDrawSetShadow(training_td[4], 0);

	training_td[5] = TextDrawCreate(75.4665, 222.9592, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[5], 12.0000, 15.0000);
	TextDrawAlignment(training_td[5], 1);
	TextDrawColor(training_td[5], color_box);
	TextDrawBackgroundColor(training_td[5], 255);
	TextDrawFont(training_td[5], 4);
	TextDrawSetProportional(training_td[5], 0);
	TextDrawSetShadow(training_td[5], 0);

	training_td[6] = TextDrawCreate(117.0333, 222.9591, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[6], 12.0000, 15.0000);
	TextDrawAlignment(training_td[6], 1);
	TextDrawColor(training_td[6], color_box);
	TextDrawBackgroundColor(training_td[6], 255);
	TextDrawFont(training_td[6], 4);
	TextDrawSetProportional(training_td[6], 0);
	TextDrawSetShadow(training_td[6], 0);

	training_td[7] = TextDrawCreate(67.5999, 226.7037, "VS"); // 1 Box
	TextDrawLetterSize(training_td[7], 0.1688, 0.7745);
	TextDrawAlignment(training_td[7], 1);
	TextDrawColor(training_td[7], -2139062017);
	TextDrawBackgroundColor(training_td[7], 255);
	TextDrawFont(training_td[7], 1);
	TextDrawSetProportional(training_td[7], 1);
	TextDrawSetShadow(training_td[7], 0);

	training_td[8] = TextDrawCreate(14.3332, 253.6857, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(training_td[8], 117.0000, -10.0000);
	TextDrawAlignment(training_td[8], 1);
	TextDrawColor(training_td[8], color_particle);
	TextDrawBackgroundColor(training_td[8], 255);
	TextDrawFont(training_td[8], 4);
	TextDrawSetProportional(training_td[8], 0);
	TextDrawSetShadow(training_td[8], 0);

	training_td[9] = TextDrawCreate(118.6999, 200.2147, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[9], 15.0000, 18.0000);
	TextDrawAlignment(training_td[9], 1);
	TextDrawColor(training_td[9], color_textdraw);
	TextDrawBackgroundColor(training_td[9], 255);
	TextDrawFont(training_td[9], 4);
	TextDrawSetProportional(training_td[9], 0);
	TextDrawSetShadow(training_td[9], 0);

	training_td[10] = TextDrawCreate(16.0665, 203.2184, "ld_spac:white"); // 1 Box
	TextDrawTextSize(training_td[10], 110.0000, 9.0000);
	TextDrawAlignment(training_td[10], 1);
	TextDrawColor(training_td[10], color_textdraw);
	TextDrawBackgroundColor(training_td[10], 255);
	TextDrawFont(training_td[10], 4);
	TextDrawSetProportional(training_td[10], 0);
	TextDrawSetShadow(training_td[10], 0);

	training_td[11] = TextDrawCreate(126.1998, 213.9296, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[11], 6.0000, 10.0000);
	TextDrawAlignment(training_td[11], 1);
	TextDrawColor(training_td[11], color_textdraw);
	TextDrawBackgroundColor(training_td[11], 255);
	TextDrawFont(training_td[11], 4);
	TextDrawSetProportional(training_td[11], 0);
	TextDrawSetShadow(training_td[11], 0);

	training_td[12] = TextDrawCreate(14.3332, 244.8851, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(training_td[12], 117.0000, 9.0000);
	TextDrawAlignment(training_td[12], 1);
	TextDrawColor(training_td[12], 1030548065);
	TextDrawBackgroundColor(training_td[12], 255);
	TextDrawFont(training_td[12], 4);
	TextDrawSetProportional(training_td[12], 0);
	TextDrawSetShadow(training_td[12], 0);

	training_td[13] = TextDrawCreate(13.1672, 241.0603, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[13], 12.0000, 15.0000);
	TextDrawAlignment(training_td[13], 1);
	TextDrawColor(training_td[13], color_textdraw);
	TextDrawBackgroundColor(training_td[13], 255);
	TextDrawFont(training_td[13], 4);
	TextDrawSetProportional(training_td[13], 0);
	TextDrawSetShadow(training_td[13], 0);

	training_td[14] = TextDrawCreate(117.0333, 241.1602, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[14], 12.0000, 15.0000);
	TextDrawAlignment(training_td[14], 1);
	TextDrawColor(training_td[14], color_textdraw);
	TextDrawBackgroundColor(training_td[14], 255);
	TextDrawFont(training_td[14], 4);
	TextDrawSetProportional(training_td[14], 0);
	TextDrawSetShadow(training_td[14], 0);

	training_td[15] = TextDrawCreate(10.1332, 212.9556, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[15], 6.0000, 10.0000);
	TextDrawAlignment(training_td[15], 1);
	TextDrawColor(training_td[15], color_textdraw);
	TextDrawBackgroundColor(training_td[15], 255);
	TextDrawFont(training_td[15], 4);
	TextDrawSetProportional(training_td[15], 0);
	TextDrawSetShadow(training_td[15], 0);

	training_td[16] = TextDrawCreate(20.1332, 206.3186, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[16], 6.0000, 17.0000);
	TextDrawAlignment(training_td[16], 1);
	TextDrawColor(training_td[16], color_textdraw);
	TextDrawBackgroundColor(training_td[16], 255);
	TextDrawFont(training_td[16], 4);
	TextDrawSetProportional(training_td[16], 0);
	TextDrawSetShadow(training_td[16], 0);

	training_td[17] = TextDrawCreate(33.1332, 213.7853, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[17], 6.0000, 8.0000);
	TextDrawAlignment(training_td[17], 1);
	TextDrawColor(training_td[17], color_textdraw);
	TextDrawBackgroundColor(training_td[17], 255);
	TextDrawFont(training_td[17], 4);
	TextDrawSetProportional(training_td[17], 0);
	TextDrawSetShadow(training_td[17], 0);

	training_td[18] = TextDrawCreate(46.7998, 215.0297, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[18], 7.0000, 6.0000);
	TextDrawAlignment(training_td[18], 1);
	TextDrawColor(training_td[18], color_textdraw);
	TextDrawBackgroundColor(training_td[18], 255);
	TextDrawFont(training_td[18], 4);
	TextDrawSetProportional(training_td[18], 0);
	TextDrawSetShadow(training_td[18], 0);

	training_td[19] = TextDrawCreate(113.4665, 215.0298, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[19], 6.0000, 6.0000);
	TextDrawAlignment(training_td[19], 1);
	TextDrawColor(training_td[19], color_textdraw);
	TextDrawBackgroundColor(training_td[19], 255);
	TextDrawFont(training_td[19], 4);
	TextDrawSetProportional(training_td[19], 0);
	TextDrawSetShadow(training_td[19], 0);

	training_td[20] = TextDrawCreate(101.4665, 213.7297, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[20], 6.0000, 9.0000);
	TextDrawAlignment(training_td[20], 1);
	TextDrawColor(training_td[20], color_textdraw);
	TextDrawBackgroundColor(training_td[20], 255);
	TextDrawFont(training_td[20], 4);
	TextDrawSetProportional(training_td[20], 0);
	TextDrawSetShadow(training_td[20], 0);

	training_td[21] = TextDrawCreate(85.9665, 214.2001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[21], 6.0000, 7.0000);
	TextDrawAlignment(training_td[21], 1);
	TextDrawColor(training_td[21], color_textdraw);
	TextDrawBackgroundColor(training_td[21], 255);
	TextDrawFont(training_td[21], 4);
	TextDrawSetProportional(training_td[21], 0);
	TextDrawSetShadow(training_td[21], 0);

	training_td[22] = TextDrawCreate(73.8998, 214.2001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[22], 5.0000, 8.0000);
	TextDrawAlignment(training_td[22], 1);
	TextDrawColor(training_td[22], color_textdraw);
	TextDrawBackgroundColor(training_td[22], 255);
	TextDrawFont(training_td[22], 4);
	TextDrawSetProportional(training_td[22], 0);
	TextDrawSetShadow(training_td[22], 0);

	training_td[23] = TextDrawCreate(58.9665, 213.8001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(training_td[23], 7.0000, 8.0000);
	TextDrawAlignment(training_td[23], 1);
	TextDrawColor(training_td[23], color_textdraw);
	TextDrawBackgroundColor(training_td[23], 255);
	TextDrawFont(training_td[23], 4);
	TextDrawSetProportional(training_td[23], 0);
	TextDrawSetShadow(training_td[23], 0);

	training_td[24] = TextDrawCreate(10.3332, 202.2888, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(training_td[24], 124.0000, 17.0000);
	TextDrawAlignment(training_td[24], 1);
	TextDrawColor(training_td[24], -234);
	TextDrawBackgroundColor(training_td[24], 255);
	TextDrawFont(training_td[24], 4);
	TextDrawSetProportional(training_td[24], 0);
	TextDrawSetShadow(training_td[24], 0);

	training_td[25] = TextDrawCreate(56.2999, 207.0074, "TRAINING"); // 1 Box
	TextDrawLetterSize(training_td[25], 0.2009, 0.8947);
	TextDrawAlignment(training_td[25], 1);
	TextDrawColor(training_td[25], -1);
	TextDrawBackgroundColor(training_td[25], 255);
	TextDrawFont(training_td[25], 1);
	TextDrawSetProportional(training_td[25], 1);
	TextDrawSetShadow(training_td[25], 0);

	training_td[26] = TextDrawCreate(11.1999, 261.9692, "ld_spac:white"); // 2 Box
	TextDrawTextSize(training_td[26], 120.0000, 27.0000);
	TextDrawAlignment(training_td[26], 1);
	TextDrawColor(training_td[26], color_black_box);
	TextDrawBackgroundColor(training_td[26], 255);
	TextDrawFont(training_td[26], 4);
	TextDrawSetProportional(training_td[26], 0);
	TextDrawSetShadow(training_td[26], 0);

	training_td[27] = TextDrawCreate(13.1672, 272.2622, "ld_beat:chit"); // 2 Box
	TextDrawTextSize(training_td[27], 12.0000, 15.0000);
	TextDrawAlignment(training_td[27], 1);
	TextDrawColor(training_td[27], color_textdraw);
	TextDrawBackgroundColor(training_td[27], 255);
	TextDrawFont(training_td[27], 4);
	TextDrawSetProportional(training_td[27], 0);
	TextDrawSetShadow(training_td[27], 0);

	training_td[28] = TextDrawCreate(117.0333, 272.3620, "ld_beat:chit"); // 2 Box
	TextDrawTextSize(training_td[28], 12.0000, 15.0000);
	TextDrawAlignment(training_td[28], 1);
	TextDrawColor(training_td[28], color_textdraw);
	TextDrawBackgroundColor(training_td[28], 255);
	TextDrawFont(training_td[28], 4);
	TextDrawSetProportional(training_td[28], 0);
	TextDrawSetShadow(training_td[28], 0);

	training_td[29] = TextDrawCreate(14.3332, 284.8875, "particle:lamp_shad_64"); // 2 Box
	TextDrawTextSize(training_td[29], 117.0000, -10.0000);
	TextDrawAlignment(training_td[29], 1);
	TextDrawColor(training_td[29], color_particle);
	TextDrawBackgroundColor(training_td[29], 255);
	TextDrawFont(training_td[29], 4);
	TextDrawSetProportional(training_td[29], 0);
	TextDrawSetShadow(training_td[29], 0);

	training_td[30] = TextDrawCreate(14.3332, 276.0870, "particle:lamp_shad_64"); // 2 Box
	TextDrawTextSize(training_td[30], 117.0000, 9.0000);
	TextDrawAlignment(training_td[30], 1);
	TextDrawColor(training_td[30], 1030548065);
	TextDrawBackgroundColor(training_td[30], 255);
	TextDrawFont(training_td[30], 4);
	TextDrawSetProportional(training_td[30], 0);
	TextDrawSetShadow(training_td[30], 0);

	training_td[31] = TextDrawCreate(44.8332, 264.4813, "PERSONAL_STATISTIC~n~"); // 2 Box
	TextDrawLetterSize(training_td[31], 0.1636, 0.7869);
	TextDrawAlignment(training_td[31], 1);
	TextDrawColor(training_td[31], -1);
	TextDrawBackgroundColor(training_td[31], 67);
	TextDrawFont(training_td[31], 1);
	TextDrawSetProportional(training_td[31], 1);
	TextDrawSetShadow(training_td[31], 1);

	training_td[32] = TextDrawCreate(11.1999, 292.1710, "ld_spac:white"); // 3 Box
	TextDrawTextSize(training_td[32], 120.0000, 21.0000);
	TextDrawAlignment(training_td[32], 1);
	TextDrawColor(training_td[32], color_black_box);
	TextDrawBackgroundColor(training_td[32], 255);
	TextDrawFont(training_td[32], 4);
	TextDrawSetProportional(training_td[32], 0);
	TextDrawSetShadow(training_td[32], 0);

	training_td[33] = TextDrawCreate(8.9666, 304.6155, "ld_beat:chit"); // 3 Box
	TextDrawTextSize(training_td[33], 14.0000, 17.0000);
	TextDrawAlignment(training_td[33], 1);
	TextDrawColor(training_td[33], color_black_box);
	TextDrawBackgroundColor(training_td[33], 255);
	TextDrawFont(training_td[33], 4);
	TextDrawSetProportional(training_td[33], 0);
	TextDrawSetShadow(training_td[33], 0);

	training_td[34] = TextDrawCreate(119.6001, 304.6155, "ld_beat:chit"); // 3 Box
	TextDrawTextSize(training_td[34], 14.0000, 17.0000);
	TextDrawAlignment(training_td[34], 1);
	TextDrawColor(training_td[34], color_black_box);
	TextDrawBackgroundColor(training_td[34], 255);
	TextDrawFont(training_td[34], 4);
	TextDrawSetProportional(training_td[34], 0);
	TextDrawSetShadow(training_td[34], 0);

	training_td[35] = TextDrawCreate(16.1999, 307.6518, "ld_spac:white"); // 3 Box
	TextDrawTextSize(training_td[35], 111.0000, 11.0000);
	TextDrawAlignment(training_td[35], 1);
	TextDrawColor(training_td[35], color_black_box);
	TextDrawBackgroundColor(training_td[35], 255);
	TextDrawFont(training_td[35], 4);
	TextDrawSetProportional(training_td[35], 0);
	TextDrawSetShadow(training_td[35], 0);

	training_td[36] = TextDrawCreate(6.6666, 306.7100, "particle:lamp_shad_64"); // 3 Box
	TextDrawTextSize(training_td[36], 132.0000, 12.0000);
	TextDrawAlignment(training_td[36], 1);
	TextDrawColor(training_td[36], color_particle);
	TextDrawBackgroundColor(training_td[36], 255);
	TextDrawFont(training_td[36], 4);
	TextDrawSetProportional(training_td[36], 0);
	TextDrawSetShadow(training_td[36], 0);

	training_td[37] = TextDrawCreate(37.4999, 294.9832, "BEST_PLAYERS_OF_TRAINING"); // 3 Box
	TextDrawLetterSize(training_td[37], 0.1636, 0.7869);
	TextDrawAlignment(training_td[37], 1);
	TextDrawColor(training_td[37], -1);
	TextDrawBackgroundColor(training_td[37], 67);
	TextDrawFont(training_td[37], 1);
	TextDrawSetProportional(training_td[37], 1);
	TextDrawSetShadow(training_td[37], 1);
	
	// family td
	family_td[0] = TextDrawCreate(11.1999, 218.4666, "ld_spac:white"); // 1 Box
	TextDrawTextSize(family_td[0], 120.0000, 40.0000);
	TextDrawAlignment(family_td[0], 1);
	TextDrawColor(family_td[0], color_black_box);
	TextDrawBackgroundColor(family_td[0], 255);
	TextDrawFont(family_td[0], 4);
	TextDrawSetProportional(family_td[0], 0);
	TextDrawSetShadow(family_td[0], 0);

	family_td[1] = TextDrawCreate(11.1332, 209.7555, "ld_spac:white"); // 1 Box
	TextDrawTextSize(family_td[1], 120.0000, 9.5899);
	TextDrawAlignment(family_td[1], 1);
	TextDrawColor(family_td[1], color_textdraw);
	TextDrawBackgroundColor(family_td[1], 255);
	TextDrawFont(family_td[1], 4);
	TextDrawSetProportional(family_td[1], 0);
	TextDrawSetShadow(family_td[1], 0);

	family_td[2] = TextDrawCreate(8.6999, 200.2147, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[2], 15.0000, 18.0000);
	TextDrawAlignment(family_td[2], 1);
	TextDrawColor(family_td[2], color_textdraw);
	TextDrawBackgroundColor(family_td[2], 255);
	TextDrawFont(family_td[2], 4);
	TextDrawSetProportional(family_td[2], 0);
	TextDrawSetShadow(family_td[2], 0);

	family_td[3] = TextDrawCreate(13.1672, 222.9592, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[3], 12.0000, 15.0000);
	TextDrawAlignment(family_td[3], 1);
	TextDrawColor(family_td[3], color_box);
	TextDrawBackgroundColor(family_td[3], 255);
	TextDrawFont(family_td[3], 4);
	TextDrawSetProportional(family_td[3], 0);
	TextDrawSetShadow(family_td[3], 0);

	family_td[4] = TextDrawCreate(54.7342, 222.9591, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[4], 12.0000, 15.0000);
	TextDrawAlignment(family_td[4], 1);
	TextDrawColor(family_td[4], color_box);
	TextDrawBackgroundColor(family_td[4], 255);
	TextDrawFont(family_td[4], 4);
	TextDrawSetProportional(family_td[4], 0);
	TextDrawSetShadow(family_td[4], 0);

	family_td[5] = TextDrawCreate(75.4665, 222.9592, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[5], 12.0000, 15.0000);
	TextDrawAlignment(family_td[5], 1);
	TextDrawColor(family_td[5], color_box);
	TextDrawBackgroundColor(family_td[5], 255);
	TextDrawFont(family_td[5], 4);
	TextDrawSetProportional(family_td[5], 0);
	TextDrawSetShadow(family_td[5], 0);

	family_td[6] = TextDrawCreate(117.0333, 222.9591, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[6], 12.0000, 15.0000);
	TextDrawAlignment(family_td[6], 1);
	TextDrawColor(family_td[6], color_box);
	TextDrawBackgroundColor(family_td[6], 255);
	TextDrawFont(family_td[6], 4);
	TextDrawSetProportional(family_td[6], 0);
	TextDrawSetShadow(family_td[6], 0);

	family_td[7] = TextDrawCreate(67.5999, 226.7037, "VS"); // 1 Box
	TextDrawLetterSize(family_td[7], 0.1688, 0.7745);
	TextDrawAlignment(family_td[7], 1);
	TextDrawColor(family_td[7], -2139062017);
	TextDrawBackgroundColor(family_td[7], 255);
	TextDrawFont(family_td[7], 1);
	TextDrawSetProportional(family_td[7], 1);
	TextDrawSetShadow(family_td[7], 0);

	family_td[8] = TextDrawCreate(14.3332, 253.6857, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(family_td[8], 117.0000, -10.0000);
	TextDrawAlignment(family_td[8], 1);
	TextDrawColor(family_td[8], color_particle);
	TextDrawBackgroundColor(family_td[8], 255);
	TextDrawFont(family_td[8], 4);
	TextDrawSetProportional(family_td[8], 0);
	TextDrawSetShadow(family_td[8], 0);

	family_td[9] = TextDrawCreate(118.6999, 200.2147, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[9], 15.0000, 18.0000);
	TextDrawAlignment(family_td[9], 1);
	TextDrawColor(family_td[9], color_textdraw);
	TextDrawBackgroundColor(family_td[9], 255);
	TextDrawFont(family_td[9], 4);
	TextDrawSetProportional(family_td[9], 0);
	TextDrawSetShadow(family_td[9], 0);

	family_td[10] = TextDrawCreate(16.0665, 203.2184, "ld_spac:white"); // 1 Box
	TextDrawTextSize(family_td[10], 110.0000, 9.0000);
	TextDrawAlignment(family_td[10], 1);
	TextDrawColor(family_td[10], color_textdraw);
	TextDrawBackgroundColor(family_td[10], 255);
	TextDrawFont(family_td[10], 4);
	TextDrawSetProportional(family_td[10], 0);
	TextDrawSetShadow(family_td[10], 0);

	family_td[11] = TextDrawCreate(126.1998, 213.9296, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[11], 6.0000, 10.0000);
	TextDrawAlignment(family_td[11], 1);
	TextDrawColor(family_td[11], color_textdraw);
	TextDrawBackgroundColor(family_td[11], 255);
	TextDrawFont(family_td[11], 4);
	TextDrawSetProportional(family_td[11], 0);
	TextDrawSetShadow(family_td[11], 0);

	family_td[12] = TextDrawCreate(14.3332, 244.8851, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(family_td[12], 117.0000, 9.0000);
	TextDrawAlignment(family_td[12], 1);
	TextDrawColor(family_td[12], 1030548065);
	TextDrawBackgroundColor(family_td[12], 255);
	TextDrawFont(family_td[12], 4);
	TextDrawSetProportional(family_td[12], 0);
	TextDrawSetShadow(family_td[12], 0);

	family_td[13] = TextDrawCreate(13.1672, 241.0603, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[13], 12.0000, 15.0000);
	TextDrawAlignment(family_td[13], 1);
	TextDrawColor(family_td[13], color_textdraw);
	TextDrawBackgroundColor(family_td[13], 255);
	TextDrawFont(family_td[13], 4);
	TextDrawSetProportional(family_td[13], 0);
	TextDrawSetShadow(family_td[13], 0);

	family_td[14] = TextDrawCreate(117.0333, 241.1602, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[14], 12.0000, 15.0000);
	TextDrawAlignment(family_td[14], 1);
	TextDrawColor(family_td[14], color_textdraw);
	TextDrawBackgroundColor(family_td[14], 255);
	TextDrawFont(family_td[14], 4);
	TextDrawSetProportional(family_td[14], 0);
	TextDrawSetShadow(family_td[14], 0);

	family_td[15] = TextDrawCreate(10.1332, 212.9556, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[15], 6.0000, 10.0000);
	TextDrawAlignment(family_td[15], 1);
	TextDrawColor(family_td[15], color_textdraw);
	TextDrawBackgroundColor(family_td[15], 255);
	TextDrawFont(family_td[15], 4);
	TextDrawSetProportional(family_td[15], 0);
	TextDrawSetShadow(family_td[15], 0);

	family_td[16] = TextDrawCreate(20.1332, 206.3186, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[16], 6.0000, 17.0000);
	TextDrawAlignment(family_td[16], 1);
	TextDrawColor(family_td[16], color_textdraw);
	TextDrawBackgroundColor(family_td[16], 255);
	TextDrawFont(family_td[16], 4);
	TextDrawSetProportional(family_td[16], 0);
	TextDrawSetShadow(family_td[16], 0);

	family_td[17] = TextDrawCreate(33.1332, 213.7853, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[17], 6.0000, 8.0000);
	TextDrawAlignment(family_td[17], 1);
	TextDrawColor(family_td[17], color_textdraw);
	TextDrawBackgroundColor(family_td[17], 255);
	TextDrawFont(family_td[17], 4);
	TextDrawSetProportional(family_td[17], 0);
	TextDrawSetShadow(family_td[17], 0);

	family_td[18] = TextDrawCreate(46.7998, 215.0297, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[18], 7.0000, 6.0000);
	TextDrawAlignment(family_td[18], 1);
	TextDrawColor(family_td[18], color_textdraw);
	TextDrawBackgroundColor(family_td[18], 255);
	TextDrawFont(family_td[18], 4);
	TextDrawSetProportional(family_td[18], 0);
	TextDrawSetShadow(family_td[18], 0);

	family_td[19] = TextDrawCreate(113.4665, 215.0298, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[19], 6.0000, 6.0000);
	TextDrawAlignment(family_td[19], 1);
	TextDrawColor(family_td[19], color_textdraw);
	TextDrawBackgroundColor(family_td[19], 255);
	TextDrawFont(family_td[19], 4);
	TextDrawSetProportional(family_td[19], 0);
	TextDrawSetShadow(family_td[19], 0);

	family_td[20] = TextDrawCreate(101.4665, 213.7297, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[20], 6.0000, 9.0000);
	TextDrawAlignment(family_td[20], 1);
	TextDrawColor(family_td[20], color_textdraw);
	TextDrawBackgroundColor(family_td[20], 255);
	TextDrawFont(family_td[20], 4);
	TextDrawSetProportional(family_td[20], 0);
	TextDrawSetShadow(family_td[20], 0);

	family_td[21] = TextDrawCreate(85.9665, 214.2001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[21], 6.0000, 7.0000);
	TextDrawAlignment(family_td[21], 1);
	TextDrawColor(family_td[21], color_textdraw);
	TextDrawBackgroundColor(family_td[21], 255);
	TextDrawFont(family_td[21], 4);
	TextDrawSetProportional(family_td[21], 0);
	TextDrawSetShadow(family_td[21], 0);

	family_td[22] = TextDrawCreate(73.8998, 214.2001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[22], 5.0000, 8.0000);
	TextDrawAlignment(family_td[22], 1);
	TextDrawColor(family_td[22], color_textdraw);
	TextDrawBackgroundColor(family_td[22], 255);
	TextDrawFont(family_td[22], 4);
	TextDrawSetProportional(family_td[22], 0);
	TextDrawSetShadow(family_td[22], 0);

	family_td[23] = TextDrawCreate(58.9665, 213.8001, "ld_beat:chit"); // 1 Box
	TextDrawTextSize(family_td[23], 7.0000, 8.0000);
	TextDrawAlignment(family_td[23], 1);
	TextDrawColor(family_td[23], color_textdraw);
	TextDrawBackgroundColor(family_td[23], 255);
	TextDrawFont(family_td[23], 4);
	TextDrawSetProportional(family_td[23], 0);
	TextDrawSetShadow(family_td[23], 0);

	family_td[24] = TextDrawCreate(10.3332, 202.2888, "particle:lamp_shad_64"); // 1 Box
	TextDrawTextSize(family_td[24], 124.0000, 17.0000);
	TextDrawAlignment(family_td[24], 1);
	TextDrawColor(family_td[24], -234);
	TextDrawBackgroundColor(family_td[24], 255);
	TextDrawFont(family_td[24], 4);
	TextDrawSetProportional(family_td[24], 0);
	TextDrawSetShadow(family_td[24], 0);

	family_td[25] = TextDrawCreate(56.2999, 207.0074, "FAMILY"); // 1 Box
	TextDrawLetterSize(family_td[25], 0.2009, 0.8947);
	TextDrawAlignment(family_td[25], 1);
	TextDrawColor(family_td[25], -1);
	TextDrawBackgroundColor(family_td[25], 255);
	TextDrawFont(family_td[25], 1);
	TextDrawSetProportional(family_td[25], 1);
	TextDrawSetShadow(family_td[25], 0);

	family_td[26] = TextDrawCreate(11.1999, 261.9692, "ld_spac:white"); // 2 Box
	TextDrawTextSize(family_td[26], 120.0000, 27.0000);
	TextDrawAlignment(family_td[26], 1);
	TextDrawColor(family_td[26], color_black_box);
	TextDrawBackgroundColor(family_td[26], 255);
	TextDrawFont(family_td[26], 4);
	TextDrawSetProportional(family_td[26], 0);
	TextDrawSetShadow(family_td[26], 0);

	family_td[27] = TextDrawCreate(13.1672, 272.2622, "ld_beat:chit"); // 2 Box
	TextDrawTextSize(family_td[27], 12.0000, 15.0000);
	TextDrawAlignment(family_td[27], 1);
	TextDrawColor(family_td[27], color_textdraw);
	TextDrawBackgroundColor(family_td[27], 255);
	TextDrawFont(family_td[27], 4);
	TextDrawSetProportional(family_td[27], 0);
	TextDrawSetShadow(family_td[27], 0);

	family_td[28] = TextDrawCreate(117.0333, 272.3620, "ld_beat:chit"); // 2 Box
	TextDrawTextSize(family_td[28], 12.0000, 15.0000);
	TextDrawAlignment(family_td[28], 1);
	TextDrawColor(family_td[28], color_textdraw);
	TextDrawBackgroundColor(family_td[28], 255);
	TextDrawFont(family_td[28], 4);
	TextDrawSetProportional(family_td[28], 0);
	TextDrawSetShadow(family_td[28], 0);

	family_td[29] = TextDrawCreate(14.3332, 284.8875, "particle:lamp_shad_64"); // 2 Box
	TextDrawTextSize(family_td[29], 117.0000, -10.0000);
	TextDrawAlignment(family_td[29], 1);
	TextDrawColor(family_td[29], color_particle);
	TextDrawBackgroundColor(family_td[29], 255);
	TextDrawFont(family_td[29], 4);
	TextDrawSetProportional(family_td[29], 0);
	TextDrawSetShadow(family_td[29], 0);

	family_td[30] = TextDrawCreate(14.3332, 276.0870, "particle:lamp_shad_64"); // 2 Box
	TextDrawTextSize(family_td[30], 117.0000, 9.0000);
	TextDrawAlignment(family_td[30], 1);
	TextDrawColor(family_td[30], 1030548065);
	TextDrawBackgroundColor(family_td[30], 255);
	TextDrawFont(family_td[30], 4);
	TextDrawSetProportional(family_td[30], 0);
	TextDrawSetShadow(family_td[30], 0);

	family_td[31] = TextDrawCreate(44.8332, 264.4813, "PERSONAL_STATISTIC~n~"); // 2 Box
	TextDrawLetterSize(family_td[31], 0.1636, 0.7869);
	TextDrawAlignment(family_td[31], 1);
	TextDrawColor(family_td[31], -1);
	TextDrawBackgroundColor(family_td[31], 67);
	TextDrawFont(family_td[31], 1);
	TextDrawSetProportional(family_td[31], 1);
	TextDrawSetShadow(family_td[31], 1);

	family_td[32] = TextDrawCreate(11.1999, 292.1710, "ld_spac:white"); // 3 Box
	TextDrawTextSize(family_td[32], 120.0000, 21.0000);
	TextDrawAlignment(family_td[32], 1);
	TextDrawColor(family_td[32], color_black_box);
	TextDrawBackgroundColor(family_td[32], 255);
	TextDrawFont(family_td[32], 4);
	TextDrawSetProportional(family_td[32], 0);
	TextDrawSetShadow(family_td[32], 0);

	family_td[33] = TextDrawCreate(8.9666, 304.6155, "ld_beat:chit"); // 3 Box
	TextDrawTextSize(family_td[33], 14.0000, 17.0000);
	TextDrawAlignment(family_td[33], 1);
	TextDrawColor(family_td[33], color_black_box);
	TextDrawBackgroundColor(family_td[33], 255);
	TextDrawFont(family_td[33], 4);
	TextDrawSetProportional(family_td[33], 0);
	TextDrawSetShadow(family_td[33], 0);

	family_td[34] = TextDrawCreate(119.6001, 304.6155, "ld_beat:chit"); // 3 Box
	TextDrawTextSize(family_td[34], 14.0000, 17.0000);
	TextDrawAlignment(family_td[34], 1);
	TextDrawColor(family_td[34], color_black_box);
	TextDrawBackgroundColor(family_td[34], 255);
	TextDrawFont(family_td[34], 4);
	TextDrawSetProportional(family_td[34], 0);
	TextDrawSetShadow(family_td[34], 0);

	family_td[35] = TextDrawCreate(16.1999, 307.6518, "ld_spac:white"); // 3 Box
	TextDrawTextSize(family_td[35], 111.0000, 11.0000);
	TextDrawAlignment(family_td[35], 1);
	TextDrawColor(family_td[35], color_black_box);
	TextDrawBackgroundColor(family_td[35], 255);
	TextDrawFont(family_td[35], 4);
	TextDrawSetProportional(family_td[35], 0);
	TextDrawSetShadow(family_td[35], 0);

	family_td[36] = TextDrawCreate(6.6666, 306.7100, "particle:lamp_shad_64"); // 3 Box
	TextDrawTextSize(family_td[36], 132.0000, 12.0000);
	TextDrawAlignment(family_td[36], 1);
	TextDrawColor(family_td[36], color_particle);
	TextDrawBackgroundColor(family_td[36], 255);
	TextDrawFont(family_td[36], 4);
	TextDrawSetProportional(family_td[36], 0);
	TextDrawSetShadow(family_td[36], 0);

	family_td[37] = TextDrawCreate(37.4999, 294.9832, "BEST_PLAYERS_OF_FAMILY"); // 3 Box
	TextDrawLetterSize(family_td[37], 0.1636, 0.7869);
	TextDrawAlignment(family_td[37], 1);
	TextDrawColor(family_td[37], -1);
	TextDrawBackgroundColor(family_td[37], 67);
	TextDrawFont(family_td[37], 1);
	TextDrawSetProportional(family_td[37], 1);
	TextDrawSetShadow(family_td[37], 1);

	/*
	
		Лаунч
		
	*/
	
	Launch_TD[0] = TextDrawCreate(295.5332, 360.4885, "LAUNCH"); // пусто
	TextDrawLetterSize(Launch_TD[0], 0.1354, 0.7702);
	TextDrawAlignment(Launch_TD[0], 1);
	TextDrawColor(Launch_TD[0], color_textdraw);
	TextDrawBackgroundColor(Launch_TD[0], 255);
	TextDrawFont(Launch_TD[0], 2);
	TextDrawSetProportional(Launch_TD[0], 1);
	TextDrawSetShadow(Launch_TD[0], 0);

	Launch_TD[1] = TextDrawCreate(288.7005, 354.9407, "ld_beat:chit"); // пусто
	TextDrawTextSize(Launch_TD[1], 16.0000, 19.0000);
	TextDrawAlignment(Launch_TD[1], 1);
	TextDrawColor(Launch_TD[1], color_textdraw);
	TextDrawBackgroundColor(Launch_TD[1], 255);
	TextDrawFont(Launch_TD[1], 4);
	TextDrawSetProportional(Launch_TD[1], 0);
	TextDrawSetShadow(Launch_TD[1], 0);

	Launch_TD[2] = TextDrawCreate(369.3056, 354.9407, "ld_beat:chit"); // пусто
	TextDrawTextSize(Launch_TD[2], 16.0000, 19.0000);
	TextDrawAlignment(Launch_TD[2], 1);
	TextDrawColor(Launch_TD[2], color_textdraw);
	TextDrawBackgroundColor(Launch_TD[2], 255);
	TextDrawFont(Launch_TD[2], 4);
	TextDrawSetProportional(Launch_TD[2], 0);
	TextDrawSetShadow(Launch_TD[2], 0);

	Launch_TD[3] = TextDrawCreate(297.7665, 358.2590, "ld_spac:white"); // пусто
	TextDrawTextSize(Launch_TD[3], 79.0000, 12.4996);
	TextDrawAlignment(Launch_TD[3], 1);
	TextDrawColor(Launch_TD[3], color_textdraw);
	TextDrawBackgroundColor(Launch_TD[3], 255);
	TextDrawFont(Launch_TD[3], 4);
	TextDrawSetProportional(Launch_TD[3], 0);
	TextDrawSetShadow(Launch_TD[3], 0);

	Launch_TD[4] = TextDrawCreate(370.0072, 356.4999, "ld_beat:chit"); // пусто
	TextDrawTextSize(Launch_TD[4], 14.0000, 16.0000);
	TextDrawAlignment(Launch_TD[4], 1);
	TextDrawColor(Launch_TD[4], color_box);
	TextDrawBackgroundColor(Launch_TD[4], 255);
	TextDrawFont(Launch_TD[4], 4);
	TextDrawSetProportional(Launch_TD[4], 0);
	TextDrawSetShadow(Launch_TD[4], 0);

	Launch_TD[5] = TextDrawCreate(290.0021, 356.4999, "ld_beat:chit"); // пусто
	TextDrawTextSize(Launch_TD[5], 14.0000, 16.0000);
	TextDrawAlignment(Launch_TD[5], 1);
	TextDrawColor(Launch_TD[5], color_box);
	TextDrawBackgroundColor(Launch_TD[5], 255);
	TextDrawFont(Launch_TD[5], 4);
	TextDrawSetProportional(Launch_TD[5], 0);
	TextDrawSetShadow(Launch_TD[5], 0);

	Launch_TD[6] = TextDrawCreate(297.5664, 359.2036, "ld_spac:white"); // пусто
	TextDrawTextSize(Launch_TD[6], 79.0000, 10.5698);
	TextDrawAlignment(Launch_TD[6], 1);
	TextDrawColor(Launch_TD[6], color_box);
	TextDrawBackgroundColor(Launch_TD[6], 255);
	TextDrawFont(Launch_TD[6], 4);
	TextDrawSetProportional(Launch_TD[6], 0);
	TextDrawSetShadow(Launch_TD[6], 0);

	Launch_TD[7] = TextDrawCreate(320.0332, 361.9924, "ld_spac:white"); // пусто
	TextDrawTextSize(Launch_TD[7], 59.0000, 4.9499);
	TextDrawAlignment(Launch_TD[7], 1);
	TextDrawColor(Launch_TD[7], color_textdraw);
	TextDrawBackgroundColor(Launch_TD[7], 255);
	TextDrawFont(Launch_TD[7], 4);
	TextDrawSetProportional(Launch_TD[7], 0);
	TextDrawSetShadow(Launch_TD[7], 0);

	Launch_TD[8] = TextDrawCreate(320.2998, 362.5220, "ld_spac:white"); // пусто
	TextDrawTextSize(Launch_TD[8], 58.0000, 3.9500);
	TextDrawAlignment(Launch_TD[8], 1);
	TextDrawColor(Launch_TD[8], color_box);
	TextDrawBackgroundColor(Launch_TD[8], 255);
	TextDrawFont(Launch_TD[8], 4);
	TextDrawSetProportional(Launch_TD[8], 0);
	TextDrawSetShadow(Launch_TD[8], 0);
	
	/*
	
		robbery
		
	*/
	
	robbery_td[0] = TextDrawCreate(511.4996, 117.6473, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[0], 20.0000, 25.0000);
	TextDrawAlignment(robbery_td[0], 1);
	TextDrawColor(robbery_td[0], color_textdraw);
	TextDrawBackgroundColor(robbery_td[0], 255);
	TextDrawFont(robbery_td[0], 4);
	TextDrawSetProportional(robbery_td[0], 0);
	TextDrawSetShadow(robbery_td[0], 0);

	robbery_td[1] = TextDrawCreate(606.7332, 296.2329, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[1], 20.2000, 25.0000);
	TextDrawAlignment(robbery_td[1], 1);
	TextDrawColor(robbery_td[1], color_black_box);
	TextDrawBackgroundColor(robbery_td[1], 255);
	TextDrawFont(robbery_td[1], 4);
	TextDrawSetProportional(robbery_td[1], 0);
	TextDrawSetShadow(robbery_td[1], 0);

	robbery_td[2] = TextDrawCreate(521.4995, 121.6660, "ld_spac:white"); // пусто
	TextDrawTextSize(robbery_td[2], 102.0000, 187.0000);
	TextDrawAlignment(robbery_td[2], 1);
	TextDrawColor(robbery_td[2], color_black_box);
	TextDrawBackgroundColor(robbery_td[2], 255);
	TextDrawFont(robbery_td[2], 4);
	TextDrawSetProportional(robbery_td[2], 0);
	TextDrawSetShadow(robbery_td[2], 0);

	robbery_td[3] = TextDrawCreate(514.7661, 131.2071, "ld_spac:white"); // пусто
	TextDrawTextSize(robbery_td[3], 102.0000, 186.0000);
	TextDrawAlignment(robbery_td[3], 1);
	TextDrawColor(robbery_td[3], color_black_box);
	TextDrawBackgroundColor(robbery_td[3], 255);
	TextDrawFont(robbery_td[3], 4);
	TextDrawSetProportional(robbery_td[3], 0);
	TextDrawSetShadow(robbery_td[3], 0);

	robbery_td[4] = TextDrawCreate(511.5331, 119.4774, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[4], 20.0000, 25.0000);
	TextDrawAlignment(robbery_td[4], 1);
	TextDrawColor(robbery_td[4], color_black_box);
	TextDrawBackgroundColor(robbery_td[4], 255);
	TextDrawFont(robbery_td[4], 4);
	TextDrawSetProportional(robbery_td[4], 0);
	TextDrawSetShadow(robbery_td[4], 0);

	robbery_td[5] = TextDrawCreate(520.9998, 121.8143, "ld_spac:white"); // пусто
	TextDrawTextSize(robbery_td[5], 102.5494, 1.6799);
	TextDrawAlignment(robbery_td[5], 1);
	TextDrawColor(robbery_td[5], color_textdraw);
	TextDrawBackgroundColor(robbery_td[5], 255);
	TextDrawFont(robbery_td[5], 4);
	TextDrawSetProportional(robbery_td[5], 0);
	TextDrawSetShadow(robbery_td[5], 0);

	robbery_td[6] = TextDrawCreate(531.3333, 153.4568, "ld_spac:white"); // 2 CTPOKA
	TextDrawTextSize(robbery_td[6], 76.0000, 15.8697);
	TextDrawAlignment(robbery_td[6], 1);
	TextDrawColor(robbery_td[6], color_textdraw);
	TextDrawBackgroundColor(robbery_td[6], 255);
	TextDrawFont(robbery_td[6], 4);
	TextDrawSetProportional(robbery_td[6], 0);
	TextDrawSetShadow(robbery_td[6], 0);

	robbery_td[7] = TextDrawCreate(598.3665, 148.0937, "ld_beat:chit"); // 2 CTPOKA
	TextDrawTextSize(robbery_td[7], 20.0000, 27.0000);
	TextDrawAlignment(robbery_td[7], 1);
	TextDrawColor(robbery_td[7], color_black_box);
	TextDrawBackgroundColor(robbery_td[7], 255);
	TextDrawFont(robbery_td[7], 4);
	TextDrawSetProportional(robbery_td[7], 0);
	TextDrawSetShadow(robbery_td[7], 0);

	robbery_td[8] = TextDrawCreate(519.9998, 147.4936, "ld_beat:chit"); // 2 CTPOKA
	TextDrawTextSize(robbery_td[8], 20.0000, 28.0000);
	TextDrawAlignment(robbery_td[8], 1);
	TextDrawColor(robbery_td[8], color_black_box);
	TextDrawBackgroundColor(robbery_td[8], 255);
	TextDrawFont(robbery_td[8], 4);
	TextDrawSetProportional(robbery_td[8], 0);
	TextDrawSetShadow(robbery_td[8], 0);

	robbery_td[9] = TextDrawCreate(599.6660, 149.3937, "ld_beat:chit"); // 2 CTPOKA
	TextDrawTextSize(robbery_td[9], 20.0000, 24.0000);
	TextDrawAlignment(robbery_td[9], 1);
	TextDrawColor(robbery_td[9], color_textdraw);
	TextDrawBackgroundColor(robbery_td[9], 255);
	TextDrawFont(robbery_td[9], 4);
	TextDrawSetProportional(robbery_td[9], 0);
	TextDrawSetShadow(robbery_td[9], 0);

	robbery_td[10] = TextDrawCreate(518.6997, 149.3937, "ld_beat:chit"); // 2 CTPOKA
	TextDrawTextSize(robbery_td[10], 20.0000, 24.0000);
	TextDrawAlignment(robbery_td[10], 1);
	TextDrawColor(robbery_td[10], color_textdraw);
	TextDrawBackgroundColor(robbery_td[10], 255);
	TextDrawFont(robbery_td[10], 4);
	TextDrawSetProportional(robbery_td[10], 0);
	TextDrawSetShadow(robbery_td[10], 0);

	robbery_td[11] = TextDrawCreate(531.3333, 175.4582, "ld_spac:white"); // 3 CTPOKA
	TextDrawTextSize(robbery_td[11], 76.0000, 15.8697);
	TextDrawAlignment(robbery_td[11], 1);
	TextDrawColor(robbery_td[11], color_textdraw);
	TextDrawBackgroundColor(robbery_td[11], 255);
	TextDrawFont(robbery_td[11], 4);
	TextDrawSetProportional(robbery_td[11], 0);
	TextDrawSetShadow(robbery_td[11], 0);

	robbery_td[12] = TextDrawCreate(598.3665, 170.0950, "ld_beat:chit"); // 3 CTPOKA
	TextDrawTextSize(robbery_td[12], 20.0000, 27.0000);
	TextDrawAlignment(robbery_td[12], 1);
	TextDrawColor(robbery_td[12], color_black_box);
	TextDrawBackgroundColor(robbery_td[12], 255);
	TextDrawFont(robbery_td[12], 4);
	TextDrawSetProportional(robbery_td[12], 0);
	TextDrawSetShadow(robbery_td[12], 0);

	robbery_td[13] = TextDrawCreate(519.9998, 169.4951, "ld_beat:chit"); // 3 CTPOKA
	TextDrawTextSize(robbery_td[13], 20.0000, 28.0000);
	TextDrawAlignment(robbery_td[13], 1);
	TextDrawColor(robbery_td[13], color_black_box);
	TextDrawBackgroundColor(robbery_td[13], 255);
	TextDrawFont(robbery_td[13], 4);
	TextDrawSetProportional(robbery_td[13], 0);
	TextDrawSetShadow(robbery_td[13], 0);

	robbery_td[14] = TextDrawCreate(599.6660, 171.3952, "ld_beat:chit"); // 3 CTPOKA
	TextDrawTextSize(robbery_td[14], 20.0000, 24.0000);
	TextDrawAlignment(robbery_td[14], 1);
	TextDrawColor(robbery_td[14], color_textdraw);
	TextDrawBackgroundColor(robbery_td[14], 255);
	TextDrawFont(robbery_td[14], 4);
	TextDrawSetProportional(robbery_td[14], 0);
	TextDrawSetShadow(robbery_td[14], 0);

	robbery_td[15] = TextDrawCreate(518.6997, 171.3952, "ld_beat:chit"); // 3 CTPOKA
	TextDrawTextSize(robbery_td[15], 20.0000, 24.0000);
	TextDrawAlignment(robbery_td[15], 1);
	TextDrawColor(robbery_td[15], color_textdraw);
	TextDrawBackgroundColor(robbery_td[15], 255);
	TextDrawFont(robbery_td[15], 4);
	TextDrawSetProportional(robbery_td[15], 0);
	TextDrawSetShadow(robbery_td[15], 0);

	robbery_td[16] = TextDrawCreate(531.3333, 197.3594, "ld_spac:white"); // 4 CTPOKA
	TextDrawTextSize(robbery_td[16], 76.0000, 15.8697);
	TextDrawAlignment(robbery_td[16], 1);
	TextDrawColor(robbery_td[16], color_textdraw);
	TextDrawBackgroundColor(robbery_td[16], 255);
	TextDrawFont(robbery_td[16], 4);
	TextDrawSetProportional(robbery_td[16], 0);
	TextDrawSetShadow(robbery_td[16], 0);

	robbery_td[17] = TextDrawCreate(598.3665, 191.9963, "ld_beat:chit"); // 4 CTPOKA
	TextDrawTextSize(robbery_td[17], 20.0000, 27.0000);
	TextDrawAlignment(robbery_td[17], 1);
	TextDrawColor(robbery_td[17], color_black_box);
	TextDrawBackgroundColor(robbery_td[17], 255);
	TextDrawFont(robbery_td[17], 4);
	TextDrawSetProportional(robbery_td[17], 0);
	TextDrawSetShadow(robbery_td[17], 0);

	robbery_td[18] = TextDrawCreate(519.9998, 191.3963, "ld_beat:chit"); // 4 CTPOKA
	TextDrawTextSize(robbery_td[18], 20.0000, 28.0000);
	TextDrawAlignment(robbery_td[18], 1);
	TextDrawColor(robbery_td[18], color_black_box);
	TextDrawBackgroundColor(robbery_td[18], 255);
	TextDrawFont(robbery_td[18], 4);
	TextDrawSetProportional(robbery_td[18], 0);
	TextDrawSetShadow(robbery_td[18], 0);

	robbery_td[19] = TextDrawCreate(599.6660, 193.2964, "ld_beat:chit"); // 4 CTPOKA
	TextDrawTextSize(robbery_td[19], 20.0000, 24.0000);
	TextDrawAlignment(robbery_td[19], 1);
	TextDrawColor(robbery_td[19], color_textdraw);
	TextDrawBackgroundColor(robbery_td[19], 255);
	TextDrawFont(robbery_td[19], 4);
	TextDrawSetProportional(robbery_td[19], 0);
	TextDrawSetShadow(robbery_td[19], 0);

	robbery_td[20] = TextDrawCreate(518.6997, 193.2964, "ld_beat:chit"); // 4 CTPOKA
	TextDrawTextSize(robbery_td[20], 20.0000, 24.0000);
	TextDrawAlignment(robbery_td[20], 1);
	TextDrawColor(robbery_td[20], color_textdraw);
	TextDrawBackgroundColor(robbery_td[20], 255);
	TextDrawFont(robbery_td[20], 4);
	TextDrawSetProportional(robbery_td[20], 0);
	TextDrawSetShadow(robbery_td[20], 0);

	robbery_td[21] = TextDrawCreate(526.7666, 155.0110, "2~N~~n~3~n~~n~4"); // пусто
	TextDrawLetterSize(robbery_td[21], 0.1666, 1.2223);
	TextDrawAlignment(robbery_td[21], 1);
	TextDrawColor(robbery_td[21], color_black_box);
	TextDrawBackgroundColor(robbery_td[21], 255);
	TextDrawFont(robbery_td[21], 2);
	TextDrawSetProportional(robbery_td[21], 1);
	TextDrawSetShadow(robbery_td[21], 0);

	robbery_td[22] = TextDrawCreate(520.0999, 263.0743, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[22], 13.0000, 16.0000);
	TextDrawAlignment(robbery_td[22], 1);
	TextDrawColor(robbery_td[22], color_box);
	TextDrawBackgroundColor(robbery_td[22], 255);
	TextDrawFont(robbery_td[22], 4);
	TextDrawSetProportional(robbery_td[22], 0);
	TextDrawSetShadow(robbery_td[22], 0);

	robbery_td[23] = TextDrawCreate(604.6024, 263.0743, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[23], 13.0000, 16.0000);
	TextDrawAlignment(robbery_td[23], 1);
	TextDrawColor(robbery_td[23], color_box);
	TextDrawBackgroundColor(robbery_td[23], 255);
	TextDrawFont(robbery_td[23], 4);
	TextDrawSetProportional(robbery_td[23], 0);
	TextDrawSetShadow(robbery_td[23], 0);

	robbery_td[24] = TextDrawCreate(520.0999, 223.0717, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[24], 13.0000, 16.0000);
	TextDrawAlignment(robbery_td[24], 1);
	TextDrawColor(robbery_td[24], color_box);
	TextDrawBackgroundColor(robbery_td[24], 255);
	TextDrawFont(robbery_td[24], 4);
	TextDrawSetProportional(robbery_td[24], 0);
	TextDrawSetShadow(robbery_td[24], 0);

	robbery_td[25] = TextDrawCreate(604.6024, 223.0717, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[25], 13.0000, 16.0000);
	TextDrawAlignment(robbery_td[25], 1);
	TextDrawColor(robbery_td[25], color_box);
	TextDrawBackgroundColor(robbery_td[25], 255);
	TextDrawFont(robbery_td[25], 4);
	TextDrawSetProportional(robbery_td[25], 0);
	TextDrawSetShadow(robbery_td[25], 0);

	robbery_td[26] = TextDrawCreate(526.8331, 225.7263, "ld_spac:white"); // пусто
	TextDrawTextSize(robbery_td[26], 84.0000, 50.8300);
	TextDrawAlignment(robbery_td[26], 1);
	TextDrawColor(robbery_td[26], color_box);
	TextDrawBackgroundColor(robbery_td[26], 255);
	TextDrawFont(robbery_td[26], 4);
	TextDrawSetProportional(robbery_td[26], 0);
	TextDrawSetShadow(robbery_td[26], 0);

	robbery_td[27] = TextDrawCreate(522.1665, 231.5337, "ld_spac:white"); // пусто
	TextDrawTextSize(robbery_td[27], 93.2695, 39.0000);
	TextDrawAlignment(robbery_td[27], 1);
	TextDrawColor(robbery_td[27], color_box);
	TextDrawBackgroundColor(robbery_td[27], 255);
	TextDrawFont(robbery_td[27], 4);
	TextDrawSetProportional(robbery_td[27], 0);
	TextDrawSetShadow(robbery_td[27], 0);

	robbery_td[28] = TextDrawCreate(527.0667, 228.1186, "MAP~n~VEHICLE~n~WEAPON~n~EQUIPMENT"); // пусто
	TextDrawLetterSize(robbery_td[28], 0.1756, 1.2308);
	TextDrawAlignment(robbery_td[28], 1);
	TextDrawColor(robbery_td[28], color_textdraw);
	TextDrawBackgroundColor(robbery_td[28], 255);
	TextDrawFont(robbery_td[28], 2);
	TextDrawSetProportional(robbery_td[28], 1);
	TextDrawSetShadow(robbery_td[28], 0);

	robbery_td[29] = TextDrawCreate(603.0028, 228.8370, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[29], 9.0797, 11.0000);
	TextDrawAlignment(robbery_td[29], 1);
	TextDrawColor(robbery_td[29], color_textdraw);
	TextDrawBackgroundColor(robbery_td[29], 255);
	TextDrawFont(robbery_td[29], 4);
	TextDrawSetProportional(robbery_td[29], 0);
	TextDrawSetShadow(robbery_td[29], 0);

	robbery_td[30] = TextDrawCreate(603.0028, 240.0377, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[30], 9.0797, 11.0000);
	TextDrawAlignment(robbery_td[30], 1);
	TextDrawColor(robbery_td[30], color_textdraw);
	TextDrawBackgroundColor(robbery_td[30], 255);
	TextDrawFont(robbery_td[30], 4);
	TextDrawSetProportional(robbery_td[30], 0);
	TextDrawSetShadow(robbery_td[30], 0);

	robbery_td[31] = TextDrawCreate(603.0028, 251.3383, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[31], 9.0797, 11.0000);
	TextDrawAlignment(robbery_td[31], 1);
	TextDrawColor(robbery_td[31], color_textdraw);
	TextDrawBackgroundColor(robbery_td[31], 255);
	TextDrawFont(robbery_td[31], 4);
	TextDrawSetProportional(robbery_td[31], 0);
	TextDrawSetShadow(robbery_td[31], 0);

	robbery_td[32] = TextDrawCreate(603.0028, 262.0390, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[32], 9.0797, 11.0000);
	TextDrawAlignment(robbery_td[32], 1);
	TextDrawColor(robbery_td[32], color_textdraw);
	TextDrawBackgroundColor(robbery_td[32], 255);
	TextDrawFont(robbery_td[32], 4);
	TextDrawSetProportional(robbery_td[32], 0);
	TextDrawSetShadow(robbery_td[32], 0);

	robbery_td[33] = TextDrawCreate(520.0999, 293.1759, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[33], 13.0000, 16.0000);
	TextDrawAlignment(robbery_td[33], 1);
	TextDrawColor(robbery_td[33], color_textdraw);
	TextDrawBackgroundColor(robbery_td[33], 255);
	TextDrawFont(robbery_td[33], 4);
	TextDrawSetProportional(robbery_td[33], 0);
	TextDrawSetShadow(robbery_td[33], 0);

	robbery_td[34] = TextDrawCreate(604.6024, 293.1759, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[34], 13.0000, 16.0000);
	TextDrawAlignment(robbery_td[34], 1);
	TextDrawColor(robbery_td[34], color_textdraw);
	TextDrawBackgroundColor(robbery_td[34], 255);
	TextDrawFont(robbery_td[34], 4);
	TextDrawSetProportional(robbery_td[34], 0);
	TextDrawSetShadow(robbery_td[34], 0);

	robbery_td[35] = TextDrawCreate(520.0999, 284.4754, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[35], 13.0000, 16.0000);
	TextDrawAlignment(robbery_td[35], 1);
	TextDrawColor(robbery_td[35], color_textdraw);
	TextDrawBackgroundColor(robbery_td[35], 255);
	TextDrawFont(robbery_td[35], 4);
	TextDrawSetProportional(robbery_td[35], 0);
	TextDrawSetShadow(robbery_td[35], 0);

	robbery_td[36] = TextDrawCreate(604.6024, 284.4754, "ld_beat:chit"); // пусто
	TextDrawTextSize(robbery_td[36], 13.0000, 16.0000);
	TextDrawAlignment(robbery_td[36], 1);
	TextDrawColor(robbery_td[36], color_textdraw);
	TextDrawBackgroundColor(robbery_td[36], 255);
	TextDrawFont(robbery_td[36], 4);
	TextDrawSetProportional(robbery_td[36], 0);
	TextDrawSetShadow(robbery_td[36], 0);

	robbery_td[37] = TextDrawCreate(527.3331, 287.2257, "ld_spac:white"); // пусто
	TextDrawTextSize(robbery_td[37], 85.1296, 18.9899);
	TextDrawAlignment(robbery_td[37], 1);
	TextDrawColor(robbery_td[37], color_textdraw);
	TextDrawBackgroundColor(robbery_td[37], 255);
	TextDrawFont(robbery_td[37], 4);
	TextDrawSetProportional(robbery_td[37], 0);
	TextDrawSetShadow(robbery_td[37], 0);

	robbery_td[38] = TextDrawCreate(522.3331, 293.0628, "ld_spac:white"); // пусто
	TextDrawTextSize(robbery_td[38], 93.1200, 7.6700);
	TextDrawAlignment(robbery_td[38], 1);
	TextDrawColor(robbery_td[38], color_textdraw);
	TextDrawBackgroundColor(robbery_td[38], 255);
	TextDrawFont(robbery_td[38], 4);
	TextDrawSetProportional(robbery_td[38], 0);
	TextDrawSetShadow(robbery_td[38], 0);

	robbery_td[39] = TextDrawCreate(562.6666, 275.4518, "/"); // пусто
	TextDrawLetterSize(robbery_td[39], 0.7533, 4.3126);
	TextDrawAlignment(robbery_td[39], 1);
	TextDrawColor(robbery_td[39], color_black_box);
	TextDrawBackgroundColor(robbery_td[39], 255);
	TextDrawFont(robbery_td[39], 2);
	TextDrawSetProportional(robbery_td[39], 1);
	TextDrawSetShadow(robbery_td[39], 0);

	robbery_td[40] = TextDrawCreate(531.3333, 130.8553, "ld_spac:white"); // 1 CTPOKA
	TextDrawTextSize(robbery_td[40], 76.0000, 15.8697);
	TextDrawAlignment(robbery_td[40], 1);
	TextDrawColor(robbery_td[40], color_textdraw);
	TextDrawBackgroundColor(robbery_td[40], 255);
	TextDrawFont(robbery_td[40], 4);
	TextDrawSetProportional(robbery_td[40], 0);
	TextDrawSetShadow(robbery_td[40], 0);

	robbery_td[41] = TextDrawCreate(598.3665, 125.4923, "ld_beat:chit"); // 1 CTPOKA
	TextDrawTextSize(robbery_td[41], 20.0000, 27.0000);
	TextDrawAlignment(robbery_td[41], 1);
	TextDrawColor(robbery_td[41], color_black_box);
	TextDrawBackgroundColor(robbery_td[41], 255);
	TextDrawFont(robbery_td[41], 4);
	TextDrawSetProportional(robbery_td[41], 0);
	TextDrawSetShadow(robbery_td[41], 0);

	robbery_td[42] = TextDrawCreate(519.9998, 124.8917, "ld_beat:chit"); // 1 CTPOKA
	TextDrawTextSize(robbery_td[42], 20.0000, 28.0000);
	TextDrawAlignment(robbery_td[42], 1);
	TextDrawColor(robbery_td[42], color_black_box);
	TextDrawBackgroundColor(robbery_td[42], 255);
	TextDrawFont(robbery_td[42], 4);
	TextDrawSetProportional(robbery_td[42], 0);
	TextDrawSetShadow(robbery_td[42], 0);

	robbery_td[43] = TextDrawCreate(599.6660, 126.7919, "ld_beat:chit"); // 1 CTPOKA
	TextDrawTextSize(robbery_td[43], 20.0000, 24.0000);
	TextDrawAlignment(robbery_td[43], 1);
	TextDrawColor(robbery_td[43], color_textdraw);
	TextDrawBackgroundColor(robbery_td[43], 255);
	TextDrawFont(robbery_td[43], 4);
	TextDrawSetProportional(robbery_td[43], 0);
	TextDrawSetShadow(robbery_td[43], 0);

	robbery_td[44] = TextDrawCreate(518.6997, 126.7919, "ld_beat:chit"); // 1 CTPOKA
	TextDrawTextSize(robbery_td[44], 20.0000, 24.0000);
	TextDrawAlignment(robbery_td[44], 1);
	TextDrawColor(robbery_td[44], color_textdraw);
	TextDrawBackgroundColor(robbery_td[44], 255);
	TextDrawFont(robbery_td[44], 4);
	TextDrawSetProportional(robbery_td[44], 0);
	TextDrawSetShadow(robbery_td[44], 0);

	robbery_td[45] = TextDrawCreate(527.7332, 132.4026, "1"); // пусто
	TextDrawLetterSize(robbery_td[45], 0.1826, 1.1976);
	TextDrawAlignment(robbery_td[45], 1);
	TextDrawColor(robbery_td[45], color_black_box);
	TextDrawBackgroundColor(robbery_td[45], 255);
	TextDrawFont(robbery_td[45], 2);
	TextDrawSetProportional(robbery_td[45], 1);
	TextDrawSetShadow(robbery_td[45], 0);