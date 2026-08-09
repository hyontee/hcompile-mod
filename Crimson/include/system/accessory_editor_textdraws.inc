#if defined _accessory_editor_textdraws_included
    #endinput
#endif
#define _accessory_editor_textdraws_included

new bool:g_AccessoryEditorTDReady = false;

stock Accessory_CreateEditorTextDraws()
{
    if(g_AccessoryEditorTDReady) return 1;
    acss_fix_TD[0] = TextDrawCreate(35.0000, 18.0000, "ACCESSORY_EDITOR");
    TextDrawLetterSize(acss_fix_TD[0], 0.3000, 1.4000);
    TextDrawTextSize(acss_fix_TD[0], 180.0000, 20.0000);
    TextDrawAlignment(acss_fix_TD[0], 1);
    TextDrawColor(acss_fix_TD[0], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[0], 1);
    TextDrawBoxColor(acss_fix_TD[0], 0x000000AA);
    TextDrawBackgroundColor(acss_fix_TD[0], 255);
    TextDrawFont(acss_fix_TD[0], 2);
    TextDrawSetProportional(acss_fix_TD[0], 1);
    TextDrawSetShadow(acss_fix_TD[0], 0);

    acss_fix_TD[1] = TextDrawCreate(600.0000, 20.0000, "EXIT");
    TextDrawLetterSize(acss_fix_TD[1], 0.3000, 1.5000);
    TextDrawTextSize(acss_fix_TD[1], 635.0000, 18.0000);
    TextDrawAlignment(acss_fix_TD[1], 1);
    TextDrawColor(acss_fix_TD[1], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[1], 1);
    TextDrawBoxColor(acss_fix_TD[1], 0xAA0000AA);
    TextDrawBackgroundColor(acss_fix_TD[1], 255);
    TextDrawFont(acss_fix_TD[1], 2);
    TextDrawSetProportional(acss_fix_TD[1], 1);
    TextDrawSetShadow(acss_fix_TD[1], 0);
    TextDrawSetSelectable(acss_fix_TD[1], true);

    acss_fix_TD[2] = TextDrawCreate(453.0000, 355.0000, "SAVE");
    TextDrawLetterSize(acss_fix_TD[2], 0.3600, 1.8000);
    TextDrawTextSize(acss_fix_TD[2], 585.0000, 32.0000);
    TextDrawAlignment(acss_fix_TD[2], 1);
    TextDrawColor(acss_fix_TD[2], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[2], 1);
    TextDrawBoxColor(acss_fix_TD[2], 0x00AA00AA);
    TextDrawBackgroundColor(acss_fix_TD[2], 255);
    TextDrawFont(acss_fix_TD[2], 2);
    TextDrawSetProportional(acss_fix_TD[2], 1);
    TextDrawSetShadow(acss_fix_TD[2], 0);
    TextDrawSetSelectable(acss_fix_TD[2], true);

    acss_fix_TD[3] = TextDrawCreate(35.0000, 65.0000, "X_POS");
    TextDrawLetterSize(acss_fix_TD[3], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[3], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[3], 1);
    TextDrawColor(acss_fix_TD[3], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[3], 1);
    TextDrawBoxColor(acss_fix_TD[3], 0x000000AA);
    TextDrawBackgroundColor(acss_fix_TD[3], 255);
    TextDrawFont(acss_fix_TD[3], 2);
    TextDrawSetProportional(acss_fix_TD[3], 1);
    TextDrawSetShadow(acss_fix_TD[3], 0);
    TextDrawSetSelectable(acss_fix_TD[3], true);

    acss_fix_TD[4] = TextDrawCreate(35.0000, 110.0000, "Y_POS");
    TextDrawLetterSize(acss_fix_TD[4], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[4], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[4], 1);
    TextDrawColor(acss_fix_TD[4], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[4], 1);
    TextDrawBoxColor(acss_fix_TD[4], 0x000000AA);
    TextDrawBackgroundColor(acss_fix_TD[4], 255);
    TextDrawFont(acss_fix_TD[4], 2);
    TextDrawSetProportional(acss_fix_TD[4], 1);
    TextDrawSetShadow(acss_fix_TD[4], 0);
    TextDrawSetSelectable(acss_fix_TD[4], true);

    acss_fix_TD[5] = TextDrawCreate(35.0000, 155.0000, "Z_POS");
    TextDrawLetterSize(acss_fix_TD[5], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[5], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[5], 1);
    TextDrawColor(acss_fix_TD[5], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[5], 1);
    TextDrawBoxColor(acss_fix_TD[5], 0x000000AA);
    TextDrawBackgroundColor(acss_fix_TD[5], 255);
    TextDrawFont(acss_fix_TD[5], 2);
    TextDrawSetProportional(acss_fix_TD[5], 1);
    TextDrawSetShadow(acss_fix_TD[5], 0);
    TextDrawSetSelectable(acss_fix_TD[5], true);

    acss_fix_TD[6] = TextDrawCreate(35.0000, 200.0000, "SCALE");
    TextDrawLetterSize(acss_fix_TD[6], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[6], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[6], 1);
    TextDrawColor(acss_fix_TD[6], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[6], 1);
    TextDrawBoxColor(acss_fix_TD[6], 0x000000AA);
    TextDrawBackgroundColor(acss_fix_TD[6], 255);
    TextDrawFont(acss_fix_TD[6], 2);
    TextDrawSetProportional(acss_fix_TD[6], 1);
    TextDrawSetShadow(acss_fix_TD[6], 0);
    TextDrawSetSelectable(acss_fix_TD[6], true);

    acss_fix_TD[7] = TextDrawCreate(35.0000, 245.0000, "ROT_X");
    TextDrawLetterSize(acss_fix_TD[7], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[7], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[7], 1);
    TextDrawColor(acss_fix_TD[7], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[7], 1);
    TextDrawBoxColor(acss_fix_TD[7], 0x000000AA);
    TextDrawBackgroundColor(acss_fix_TD[7], 255);
    TextDrawFont(acss_fix_TD[7], 2);
    TextDrawSetProportional(acss_fix_TD[7], 1);
    TextDrawSetShadow(acss_fix_TD[7], 0);
    TextDrawSetSelectable(acss_fix_TD[7], true);

    acss_fix_TD[8] = TextDrawCreate(35.0000, 290.0000, "ROT_Y");
    TextDrawLetterSize(acss_fix_TD[8], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[8], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[8], 1);
    TextDrawColor(acss_fix_TD[8], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[8], 1);
    TextDrawBoxColor(acss_fix_TD[8], 0x000000AA);
    TextDrawBackgroundColor(acss_fix_TD[8], 255);
    TextDrawFont(acss_fix_TD[8], 2);
    TextDrawSetProportional(acss_fix_TD[8], 1);
    TextDrawSetShadow(acss_fix_TD[8], 0);
    TextDrawSetSelectable(acss_fix_TD[8], true);

    acss_fix_TD[9] = TextDrawCreate(35.0000, 335.0000, "ROT_Z");
    TextDrawLetterSize(acss_fix_TD[9], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[9], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[9], 1);
    TextDrawColor(acss_fix_TD[9], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[9], 1);
    TextDrawBoxColor(acss_fix_TD[9], 0x000000AA);
    TextDrawBackgroundColor(acss_fix_TD[9], 255);
    TextDrawFont(acss_fix_TD[9], 2);
    TextDrawSetProportional(acss_fix_TD[9], 1);
    TextDrawSetShadow(acss_fix_TD[9], 0);
    TextDrawSetSelectable(acss_fix_TD[9], true);

    acss_fix_TD[10] = TextDrawCreate(35.0000, 65.0000, "X_POS");
    TextDrawLetterSize(acss_fix_TD[10], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[10], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[10], 1);
    TextDrawColor(acss_fix_TD[10], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[10], 1);
    TextDrawBoxColor(acss_fix_TD[10], 0xFF6600CC);
    TextDrawBackgroundColor(acss_fix_TD[10], 255);
    TextDrawFont(acss_fix_TD[10], 2);
    TextDrawSetProportional(acss_fix_TD[10], 1);
    TextDrawSetShadow(acss_fix_TD[10], 0);

    acss_fix_TD[11] = TextDrawCreate(35.0000, 110.0000, "Y_POS");
    TextDrawLetterSize(acss_fix_TD[11], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[11], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[11], 1);
    TextDrawColor(acss_fix_TD[11], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[11], 1);
    TextDrawBoxColor(acss_fix_TD[11], 0xFF6600CC);
    TextDrawBackgroundColor(acss_fix_TD[11], 255);
    TextDrawFont(acss_fix_TD[11], 2);
    TextDrawSetProportional(acss_fix_TD[11], 1);
    TextDrawSetShadow(acss_fix_TD[11], 0);

    acss_fix_TD[12] = TextDrawCreate(35.0000, 155.0000, "Z_POS");
    TextDrawLetterSize(acss_fix_TD[12], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[12], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[12], 1);
    TextDrawColor(acss_fix_TD[12], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[12], 1);
    TextDrawBoxColor(acss_fix_TD[12], 0xFF6600CC);
    TextDrawBackgroundColor(acss_fix_TD[12], 255);
    TextDrawFont(acss_fix_TD[12], 2);
    TextDrawSetProportional(acss_fix_TD[12], 1);
    TextDrawSetShadow(acss_fix_TD[12], 0);

    acss_fix_TD[13] = TextDrawCreate(35.0000, 200.0000, "SCALE");
    TextDrawLetterSize(acss_fix_TD[13], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[13], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[13], 1);
    TextDrawColor(acss_fix_TD[13], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[13], 1);
    TextDrawBoxColor(acss_fix_TD[13], 0xFF6600CC);
    TextDrawBackgroundColor(acss_fix_TD[13], 255);
    TextDrawFont(acss_fix_TD[13], 2);
    TextDrawSetProportional(acss_fix_TD[13], 1);
    TextDrawSetShadow(acss_fix_TD[13], 0);

    acss_fix_TD[14] = TextDrawCreate(35.0000, 245.0000, "ROT_X");
    TextDrawLetterSize(acss_fix_TD[14], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[14], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[14], 1);
    TextDrawColor(acss_fix_TD[14], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[14], 1);
    TextDrawBoxColor(acss_fix_TD[14], 0xFF6600CC);
    TextDrawBackgroundColor(acss_fix_TD[14], 255);
    TextDrawFont(acss_fix_TD[14], 2);
    TextDrawSetProportional(acss_fix_TD[14], 1);
    TextDrawSetShadow(acss_fix_TD[14], 0);

    acss_fix_TD[15] = TextDrawCreate(35.0000, 290.0000, "ROT_Y");
    TextDrawLetterSize(acss_fix_TD[15], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[15], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[15], 1);
    TextDrawColor(acss_fix_TD[15], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[15], 1);
    TextDrawBoxColor(acss_fix_TD[15], 0xFF6600CC);
    TextDrawBackgroundColor(acss_fix_TD[15], 255);
    TextDrawFont(acss_fix_TD[15], 2);
    TextDrawSetProportional(acss_fix_TD[15], 1);
    TextDrawSetShadow(acss_fix_TD[15], 0);

    acss_fix_TD[16] = TextDrawCreate(35.0000, 335.0000, "ROT_Z");
    TextDrawLetterSize(acss_fix_TD[16], 0.3000, 1.6000);
    TextDrawTextSize(acss_fix_TD[16], 152.0000, 34.0000);
    TextDrawAlignment(acss_fix_TD[16], 1);
    TextDrawColor(acss_fix_TD[16], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[16], 1);
    TextDrawBoxColor(acss_fix_TD[16], 0xFF6600CC);
    TextDrawBackgroundColor(acss_fix_TD[16], 255);
    TextDrawFont(acss_fix_TD[16], 2);
    TextDrawSetProportional(acss_fix_TD[16], 1);
    TextDrawSetShadow(acss_fix_TD[16], 0);

    acss_fix_TD[17] = TextDrawCreate(430.0000, 100.0000, "MOVE_X");
    TextDrawLetterSize(acss_fix_TD[17], 0.3600, 2.0000);
    TextDrawTextSize(acss_fix_TD[17], 610.0000, 170.0000);
    TextDrawAlignment(acss_fix_TD[17], 1);
    TextDrawColor(acss_fix_TD[17], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[17], 1);
    TextDrawBoxColor(acss_fix_TD[17], 0x00000088);
    TextDrawBackgroundColor(acss_fix_TD[17], 255);
    TextDrawFont(acss_fix_TD[17], 2);
    TextDrawSetProportional(acss_fix_TD[17], 1);
    TextDrawSetShadow(acss_fix_TD[17], 0);

    acss_fix_TD[18] = TextDrawCreate(430.0000, 100.0000, "MOVE_Y");
    TextDrawLetterSize(acss_fix_TD[18], 0.3600, 2.0000);
    TextDrawTextSize(acss_fix_TD[18], 610.0000, 170.0000);
    TextDrawAlignment(acss_fix_TD[18], 1);
    TextDrawColor(acss_fix_TD[18], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[18], 1);
    TextDrawBoxColor(acss_fix_TD[18], 0x00000088);
    TextDrawBackgroundColor(acss_fix_TD[18], 255);
    TextDrawFont(acss_fix_TD[18], 2);
    TextDrawSetProportional(acss_fix_TD[18], 1);
    TextDrawSetShadow(acss_fix_TD[18], 0);

    acss_fix_TD[19] = TextDrawCreate(430.0000, 100.0000, "MOVE_Z");
    TextDrawLetterSize(acss_fix_TD[19], 0.3600, 2.0000);
    TextDrawTextSize(acss_fix_TD[19], 610.0000, 170.0000);
    TextDrawAlignment(acss_fix_TD[19], 1);
    TextDrawColor(acss_fix_TD[19], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[19], 1);
    TextDrawBoxColor(acss_fix_TD[19], 0x00000088);
    TextDrawBackgroundColor(acss_fix_TD[19], 255);
    TextDrawFont(acss_fix_TD[19], 2);
    TextDrawSetProportional(acss_fix_TD[19], 1);
    TextDrawSetShadow(acss_fix_TD[19], 0);

    acss_fix_TD[20] = TextDrawCreate(430.0000, 100.0000, "SCALE");
    TextDrawLetterSize(acss_fix_TD[20], 0.3600, 2.0000);
    TextDrawTextSize(acss_fix_TD[20], 610.0000, 170.0000);
    TextDrawAlignment(acss_fix_TD[20], 1);
    TextDrawColor(acss_fix_TD[20], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[20], 1);
    TextDrawBoxColor(acss_fix_TD[20], 0x00000088);
    TextDrawBackgroundColor(acss_fix_TD[20], 255);
    TextDrawFont(acss_fix_TD[20], 2);
    TextDrawSetProportional(acss_fix_TD[20], 1);
    TextDrawSetShadow(acss_fix_TD[20], 0);

    acss_fix_TD[21] = TextDrawCreate(430.0000, 100.0000, "ROT_X");
    TextDrawLetterSize(acss_fix_TD[21], 0.3600, 2.0000);
    TextDrawTextSize(acss_fix_TD[21], 610.0000, 170.0000);
    TextDrawAlignment(acss_fix_TD[21], 1);
    TextDrawColor(acss_fix_TD[21], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[21], 1);
    TextDrawBoxColor(acss_fix_TD[21], 0x00000088);
    TextDrawBackgroundColor(acss_fix_TD[21], 255);
    TextDrawFont(acss_fix_TD[21], 2);
    TextDrawSetProportional(acss_fix_TD[21], 1);
    TextDrawSetShadow(acss_fix_TD[21], 0);

    acss_fix_TD[22] = TextDrawCreate(430.0000, 100.0000, "ROT_Y");
    TextDrawLetterSize(acss_fix_TD[22], 0.3600, 2.0000);
    TextDrawTextSize(acss_fix_TD[22], 610.0000, 170.0000);
    TextDrawAlignment(acss_fix_TD[22], 1);
    TextDrawColor(acss_fix_TD[22], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[22], 1);
    TextDrawBoxColor(acss_fix_TD[22], 0x00000088);
    TextDrawBackgroundColor(acss_fix_TD[22], 255);
    TextDrawFont(acss_fix_TD[22], 2);
    TextDrawSetProportional(acss_fix_TD[22], 1);
    TextDrawSetShadow(acss_fix_TD[22], 0);

    acss_fix_TD[23] = TextDrawCreate(430.0000, 100.0000, "ROT_Z");
    TextDrawLetterSize(acss_fix_TD[23], 0.3600, 2.0000);
    TextDrawTextSize(acss_fix_TD[23], 610.0000, 170.0000);
    TextDrawAlignment(acss_fix_TD[23], 1);
    TextDrawColor(acss_fix_TD[23], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[23], 1);
    TextDrawBoxColor(acss_fix_TD[23], 0x00000088);
    TextDrawBackgroundColor(acss_fix_TD[23], 255);
    TextDrawFont(acss_fix_TD[23], 2);
    TextDrawSetProportional(acss_fix_TD[23], 1);
    TextDrawSetShadow(acss_fix_TD[23], 0);

    acss_fix_TD[24] = TextDrawCreate(475.0000, 180.0000, "+");
    TextDrawLetterSize(acss_fix_TD[24], 0.8000, 3.0000);
    TextDrawTextSize(acss_fix_TD[24], 520.0000, 40.0000);
    TextDrawAlignment(acss_fix_TD[24], 1);
    TextDrawColor(acss_fix_TD[24], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[24], 1);
    TextDrawBoxColor(acss_fix_TD[24], 0x00AA00AA);
    TextDrawBackgroundColor(acss_fix_TD[24], 255);
    TextDrawFont(acss_fix_TD[24], 2);
    TextDrawSetProportional(acss_fix_TD[24], 1);
    TextDrawSetShadow(acss_fix_TD[24], 0);
    TextDrawSetSelectable(acss_fix_TD[24], true);

    acss_fix_TD[25] = TextDrawCreate(548.0000, 180.0000, "-");
    TextDrawLetterSize(acss_fix_TD[25], 0.9000, 3.0000);
    TextDrawTextSize(acss_fix_TD[25], 590.0000, 40.0000);
    TextDrawAlignment(acss_fix_TD[25], 1);
    TextDrawColor(acss_fix_TD[25], 0xFFFFFFFF);
    TextDrawUseBox(acss_fix_TD[25], 1);
    TextDrawBoxColor(acss_fix_TD[25], 0xAA0000AA);
    TextDrawBackgroundColor(acss_fix_TD[25], 255);
    TextDrawFont(acss_fix_TD[25], 2);
    TextDrawSetProportional(acss_fix_TD[25], 1);
    TextDrawSetShadow(acss_fix_TD[25], 0);
    TextDrawSetSelectable(acss_fix_TD[25], true);

    g_AccessoryEditorTDReady = true;
    return 1;
}
