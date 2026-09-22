//>> Файл: bykranin_src/core/inventory/block.inc  (387 строк)
//>> Тема: инвентарь, предметы, кейсы/награды, аксессуары, багажник
//>> Внутри: CreatePlTDButtonBR, CreateTextDrawButtonBR, EntryAccessoryMarket, SetPriceAccesory, /myacs, LoadAccessory
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
#if 0 // legacy accessory market (moved to include/system/accessory.pwn)
stock CreatePlTDButtonBR(playerid)
{
    button_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 309.4163, 406.8438, "‰EHA:10000000"); // пусто
    PlayerTextDrawLetterSize(playerid, button_PTD[playerid][0], 0.1466, 0.9860);
    PlayerTextDrawTextSize(playerid, button_PTD[playerid][0], 0.0000, -137.0000);
    PlayerTextDrawAlignment(playerid, button_PTD[playerid][0], 2);
    PlayerTextDrawColor(playerid, button_PTD[playerid][0], -2139062017);
    PlayerTextDrawBackgroundColor(playerid, button_PTD[playerid][0], 255);
    PlayerTextDrawFont(playerid, button_PTD[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, button_PTD[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, button_PTD[playerid][0], 0);
    create_player_btn[playerid] = true;
    return 1;
}

stock CreateTextDrawButtonBR()
{
    button_TD[0] = TextDrawCreate(579.1665, 374.5928, "_"); // пусто
    TextDrawLetterSize(button_TD[0], 0.0087, 4.5451);
    TextDrawTextSize(button_TD[0], 615.0000, 0.0000);
    TextDrawAlignment(button_TD[0], 1);
    TextDrawColor(button_TD[0], -1);
    TextDrawUseBox(button_TD[0], 1);
    TextDrawBoxColor(button_TD[0], -1607587841);
    TextDrawBackgroundColor(button_TD[0], 255);
    TextDrawFont(button_TD[0], 1);
    TextDrawSetProportional(button_TD[0], 1);
    TextDrawSetShadow(button_TD[0], 0);

    button_TD[1] = TextDrawCreate(580.8331, 374.5928, "_"); // пусто
    TextDrawLetterSize(button_TD[1], 0.0170, 0.9518);
    TextDrawTextSize(button_TD[1], 614.0000, 0.0000);
    TextDrawAlignment(button_TD[1], 1);
    TextDrawColor(button_TD[1], -1);
    TextDrawUseBox(button_TD[1], 1);
    TextDrawBoxColor(button_TD[1], 255);
    TextDrawBackgroundColor(button_TD[1], 255);
    TextDrawFont(button_TD[1], 1);
    TextDrawSetProportional(button_TD[1], 1);
    TextDrawSetShadow(button_TD[1], 0);

    button_TD[2] = TextDrawCreate(580.4165, 405.7038, "_"); // пусто
    TextDrawLetterSize(button_TD[2], 0.0170, 0.9518);
    TextDrawTextSize(button_TD[2], 614.0000, 0.0000);
    TextDrawAlignment(button_TD[2], 1);
    TextDrawColor(button_TD[2], -1);
    TextDrawUseBox(button_TD[2], 1);
    TextDrawBoxColor(button_TD[2], 255);
    TextDrawBackgroundColor(button_TD[2], 255);
    TextDrawFont(button_TD[2], 1);
    TextDrawSetProportional(button_TD[2], 1);
    TextDrawSetShadow(button_TD[2], 0);

    button_TD[3] = TextDrawCreate(31.6666, 374.5927, "_"); // пусто
    TextDrawLetterSize(button_TD[3], 0.0087, 4.5451);
    TextDrawTextSize(button_TD[3], 68.0000, 0.0000);
    TextDrawAlignment(button_TD[3], 1);
    TextDrawColor(button_TD[3], -1);
    TextDrawUseBox(button_TD[3], 1);
    TextDrawBoxColor(button_TD[3], -1607587841);
    TextDrawBackgroundColor(button_TD[3], 255);
    TextDrawFont(button_TD[3], 1);
    TextDrawSetProportional(button_TD[3], 1);
    TextDrawSetShadow(button_TD[3], 0);

    button_TD[4] = TextDrawCreate(584.9999, 388.0742, ">>>"); // пусто
    TextDrawLetterSize(button_TD[4], 0.4053, 1.5273);
    TextDrawTextSize(button_TD[4], 609.0000, 80.0000);
    TextDrawAlignment(button_TD[4], 1);
    TextDrawColor(button_TD[4], -1);
    TextDrawUseBox(button_TD[4], 1);
    TextDrawBoxColor(button_TD[4], -1607587841);
    TextDrawBackgroundColor(button_TD[4], 255);
    TextDrawFont(button_TD[4], 1);
    TextDrawSetProportional(button_TD[4], 1);
    TextDrawSetShadow(button_TD[4], 0);
    TextDrawSetSelectable(button_TD[4], true);

    button_TD[5] = TextDrawCreate(33.3333, 374.5927, "_"); // пусто
    TextDrawLetterSize(button_TD[5], 0.0170, 0.9518);
    TextDrawTextSize(button_TD[5], 67.0000, 0.0000);
    TextDrawAlignment(button_TD[5], 1);
    TextDrawColor(button_TD[5], -1);
    TextDrawUseBox(button_TD[5], 1);
    TextDrawBoxColor(button_TD[5], 255);
    TextDrawBackgroundColor(button_TD[5], 255);
    TextDrawFont(button_TD[5], 1);
    TextDrawSetProportional(button_TD[5], 1);
    TextDrawSetShadow(button_TD[5], 0);

    button_TD[6] = TextDrawCreate(32.9166, 405.7038, "_"); // пусто
    TextDrawLetterSize(button_TD[6], 0.0170, 0.9518);
    TextDrawTextSize(button_TD[6], 67.0000, 0.0000);
    TextDrawAlignment(button_TD[6], 1);
    TextDrawColor(button_TD[6], -1);
    TextDrawUseBox(button_TD[6], 1);
    TextDrawBoxColor(button_TD[6], 255);
    TextDrawBackgroundColor(button_TD[6], 255);
    TextDrawFont(button_TD[6], 1);
    TextDrawSetProportional(button_TD[6], 1);
    TextDrawSetShadow(button_TD[6], 0);

    button_TD[7] = TextDrawCreate(37.9166, 388.0742, "<<<"); // пусто
    TextDrawLetterSize(button_TD[7], 0.3999, 1.4858);
    TextDrawTextSize(button_TD[7], 64.0000, 80.0000);
    TextDrawAlignment(button_TD[7], 1);
    TextDrawColor(button_TD[7], -1);
    TextDrawUseBox(button_TD[7], 1);
    TextDrawBoxColor(button_TD[7], -1607587841);
    TextDrawBackgroundColor(button_TD[7], 255);
    TextDrawFont(button_TD[7], 1);
    TextDrawSetProportional(button_TD[7], 1);
    TextDrawSetShadow(button_TD[7], 0);
    TextDrawSetSelectable(button_TD[7], true);


    button_TD[8] = TextDrawCreate(257.4165, 378.2438, "_"); // пусто
    TextDrawLetterSize(button_TD[8], 0.0447, 4.2666);
    TextDrawTextSize(button_TD[8], 365.0000, 0.0000);
    TextDrawAlignment(button_TD[8], 1);
    TextDrawColor(button_TD[8], -1);
    TextDrawUseBox(button_TD[8], 1);
    TextDrawBoxColor(button_TD[8], -1607587841);
    TextDrawBackgroundColor(button_TD[8], 255);
    TextDrawFont(button_TD[8], 1);
    TextDrawSetProportional(button_TD[8], 1);
    TextDrawSetShadow(button_TD[8], 0);

    button_TD[9] = TextDrawCreate(259.0829, 380.6067, "_"); // пусто
    TextDrawLetterSize(button_TD[9], 0.0501, 3.8134);
    TextDrawTextSize(button_TD[9], 363.0000, 0.0000);
    TextDrawAlignment(button_TD[9], 1);
    TextDrawColor(button_TD[9], -1);
    TextDrawUseBox(button_TD[9], 1);
    TextDrawBoxColor(button_TD[9], 255);
    TextDrawBackgroundColor(button_TD[9], 255);
    TextDrawFont(button_TD[9], 1);
    TextDrawSetProportional(button_TD[9], 1);
    TextDrawSetShadow(button_TD[9], 0);

    button_TD[10] = TextDrawCreate(258.2500, 388.2810, "_"); // пусто
    TextDrawLetterSize(button_TD[10], 0.0430, 1.8402);
    TextDrawTextSize(button_TD[10], 364.0000, 0.0000);
    TextDrawAlignment(button_TD[10], 1);
    TextDrawColor(button_TD[10], -1);
    TextDrawUseBox(button_TD[10], 1);
    TextDrawBoxColor(button_TD[10], -1607587841);
    TextDrawBackgroundColor(button_TD[10], 255);
    TextDrawFont(button_TD[10], 1);
    TextDrawSetProportional(button_TD[10], 1);
    TextDrawSetShadow(button_TD[10], 0);

    button_TD[11] = TextDrawCreate(321.9993, 391.0805, "‹‘XOѓ"); // пусто
    TextDrawLetterSize(button_TD[11], 0.2726, 1.3414);
    TextDrawTextSize(button_TD[11], 362.0000, 80.0000);
    TextDrawAlignment(button_TD[11], 1);
    TextDrawColor(button_TD[11], -1);
    TextDrawUseBox(button_TD[11], 1);
    TextDrawBoxColor(button_TD[11], 255);
    TextDrawBackgroundColor(button_TD[11], 255);
    TextDrawFont(button_TD[11], 2);
    TextDrawSetProportional(button_TD[11], 1);
    TextDrawSetShadow(button_TD[11], 0);
    TextDrawSetSelectable(button_TD[11], true);

    button_TD[12] = TextDrawCreate(260.1662, 391.0807, "KYЊ…Џ’"); // пусто
    TextDrawLetterSize(button_TD[12], 0.2261, 1.3370);
    TextDrawTextSize(button_TD[12], 296.0000, 80.0000);
    TextDrawAlignment(button_TD[12], 1);
    TextDrawColor(button_TD[12], -1);
    TextDrawUseBox(button_TD[12], 1);
    TextDrawBoxColor(button_TD[12], 255);
    TextDrawBackgroundColor(button_TD[12], 255);
    TextDrawFont(button_TD[12], 2);
    TextDrawSetProportional(button_TD[12], 1);
    TextDrawSetShadow(button_TD[12], 0);
    TextDrawSetSelectable(button_TD[12], true);
    


    return 1;
}
stock EntryAccessoryMarket(playerid)
{
    pl_accessory[playerid] = 0;
    SetPlayerPosEx(playerid, 2896.610839,1496.067871,2499.343750,355.015014, 1, playerid+1);
    HideHud(playerid);
    TogglePlayerControllable(playerid, false);

   // SetPlayerCameraLookAt(playerid, 2899.593261,1499.915283,2499.343750);

    InterpolateCameraPos(playerid, 2901.951660,1498.124877,2499.343750, 2900.450927,1500.220703,2499.363750, 2000, CAMERA_MOVE);
    InterpolateCameraLookAt(playerid, 2903.739257,1499.161499,2499.343750, 2899.104980,1503.386230,2499.562500, 2000, CAMERA_MOVE);

    pl_id_accessory[playerid] = CreatePlayerObject(playerid, accessory[0][ID_ACCESSORY], 2899.104980,1503.386230,2499.062500, 0.0, 0.0, 0.0);
        
    CreatePlTDButtonBR(playerid);

    SetPriceAccesory(playerid, 0);

    SelectTextDraw(playerid, 0xFF5252FF);
    for(new i;i < sizeof button_TD;i++) TextDrawShowForPlayer(playerid, button_TD[i]);
    PlayerTextDrawShow(playerid, button_PTD[playerid][0]);

    new Float:x, Float:y, Float:z, string[124];
    GetPlayerCameraPos(playerid, x, y, z);
    return 1;
}

stock SetPriceAccesory(playerid, acs)
{
    new string[24];
    format(string, sizeof string, "‰EHA:%d", accessory[acs][PRICE_ACCESSORY]);
    PlayerTextDrawSetString(playerid, button_PTD[playerid][0], string);

    return 1;
}


CMD:myacs(playerid)
{
	new fmt_text[640],
	Cache: result,
	id;

    mysql_format(mysql, fmt_text, sizeof fmt_text, "SELECT * FROM accessory_inventory WHERE player_id='%d'", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, fmt_text, true);

    new rows = cache_num_rows(result);

    if(!rows) SendClientMessage(playerid, 0x999999FF, "У Вас нет аксессуаров");
    else
    {	
            new query[78],
                acs, use, acs_use[24];

            format(fmt_text, sizeof fmt_text, "");

            for(new i = 0; i < rows; i ++)
            {
                id = cache_get_field_content_int(i, "id");
                acs = cache_get_field_content_int(i, "acs_id");
                use = cache_get_field_content_int(i, "use");

                if(use > 0) acs_use = "{636363}[используется]";
                else  acs_use = "";

                format
                (
                    query,
                    sizeof query,
                    "{FFFFFF}%d. %s %s\n",
                    i + 1, 
                    accessory[acs][NAME_ACCESSORY], acs_use
                );
                strcat(fmt_text, query);
                SetPlayerListitemValue(playerid, i, id);

                format(query, sizeof query, "acsuse%d", i);
                SetPVarInt(playerid, query, use);
            }

            Dialog
            (
                playerid, 1190, DIALOG_STYLE_LIST,
                "{FFCD00}Выберите акссесуар",
                fmt_text,
                "Выбрать", "Закрыть"
            );
    }

    cache_delete(result);

	return 1;
}
public LoadAccessory(playerid)
{
    new account_id = GetPlayerAccountID(playerid);
    if(account_id <= 0)
        return 0;

    new query[220], rows, Cache:result;

    format(query, sizeof(query),
        "SELECT * FROM accessories_players WHERE player_id = %d AND bone > 0",
        account_id
    );

    result = mysql_query(mysql, query, true);
    rows = cache_num_rows(result);

    printf("[ACS] LoadAccessory: player=%d account_id=%d rows=%d", playerid, account_id, rows);

    if(rows > 0)
    {
        new slot, acs, bone;
        new Float:x, Float:y, Float:z;
        new Float:rX, Float:rY, Float:rZ;
        new Float:scale;

        for(new i = 0; i < rows; i++)
        {
            slot  = cache_get_field_content_int(i, "slot");
            acs   = cache_get_field_content_int(i, "acs_id");
            bone  = cache_get_field_content_int(i, "bone");

            x     = cache_get_field_content_float(i, "x");
            y     = cache_get_field_content_float(i, "y");
            z     = cache_get_field_content_float(i, "z");

            rX    = cache_get_field_content_float(i, "rX");
            rY    = cache_get_field_content_float(i, "rY");
            rZ    = cache_get_field_content_float(i, "rZ");

            scale = cache_get_field_content_float(i, "scale");

            // Полностью пустая строка — просто пропускаем
            if(slot == 0 && acs == 0 && bone == 0 &&
               x == 0.0 && y == 0.0 && z == 0.0 &&
               rX == 0.0 && rY == 0.0 && rZ == 0.0 &&
               scale == 0.0)
            {
                printf("[ACS] skip empty row=%d player=%d", i, playerid);
                continue;
            }

            // Валидируем слот
            if(slot < 1 || slot > 9)
            {
                printf("[ACS] skip row=%d invalid slot=%d", i, slot);
                continue;
            }

            // accessory[0] is valid (model 907), only out-of-range indexes are invalid.
            if(acs < 0 || acs >= sizeof(accessory))
            {
                printf("[ACS] skip row=%d invalid acs=%d", i, acs);
                continue;
            }

            // Если есть MAX_ACCESSORIES — обязательно включи эту проверку
            // if(acs >= MAX_ACCESSORIES)
            // {
            //     printf("[ACS] skip row=%d acs out of range=%d", i, acs);
            //     continue;
            // }

            if(bone <= 0 || bone > 18)
            {
                printf("[ACS] skip row=%d invalid bone=%d", i, bone);
                continue;
            }

            if(accessory[acs][ID_ACCESSORY] <= 0)
            {
                printf("[ACS] skip row=%d invalid model=%d acs=%d", i, accessory[acs][ID_ACCESSORY], acs);
                continue;
            }

            if(scale <= 0.0)
            {
                printf("[ACS] skip row=%d invalid scale=%.4f", i, scale);
                continue;
            }

            SetPlayerAttachedObject(
                playerid,
                slot,
                accessory[acs][ID_ACCESSORY],
                bone,
                x, y, z,
                rX, rY, rZ,
                scale, scale, scale
            );

            printf("[ACS] apply row=%d player=%d slot=%d acs=%d bone=%d x=%.4f y=%.4f z=%.4f rx=%.2f ry=%.2f rz=%.2f scale=%.4f",
                i, playerid, slot, acs, bone, x, y, z, rX, rY, rZ, scale
            );
        }
    }

    cache_delete(result);
    return 1;
}
#endif
