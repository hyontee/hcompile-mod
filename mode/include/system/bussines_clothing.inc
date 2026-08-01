new Text:acss_TD[26];
new PlayerText:acss_coords_PTD[MAX_PLAYERS];
new bool:acs_editing[MAX_PLAYERS];

stock CreateEditAccessoryTD()
{
	acss_TD[0] = TextDrawCreate(35.0000, 18.0000, "txd:bracstext");
	TextDrawTextSize(acss_TD[0], 127.0000, 45.0000);
	TextDrawAlignment(acss_TD[0], 1);
	TextDrawColor(acss_TD[0], -1);
	TextDrawBackgroundColor(acss_TD[0], 255);
	TextDrawFont(acss_TD[0], 4);

	acss_TD[1] = TextDrawCreate(600.0000, 0.1, "txd:bracsbtnexit");
	TextDrawTextSize(acss_TD[1], 45.0000, 50.0000);
	TextDrawAlignment(acss_TD[1], 1);
	TextDrawColor(acss_TD[1], -1);
	TextDrawBackgroundColor(acss_TD[1], 255);
	TextDrawFont(acss_TD[1], 4);
	TextDrawSetSelectable(acss_TD[1], true);

	acss_TD[2] = TextDrawCreate(453.0000, 355.0000, "txd:bracssave");
	TextDrawTextSize(acss_TD[2], 130.0000, 40.0000);
	TextDrawAlignment(acss_TD[2], 1);
	TextDrawColor(acss_TD[2], -1);
	TextDrawBackgroundColor(acss_TD[2], 255);
	TextDrawFont(acss_TD[2], 4);
	TextDrawSetSelectable(acss_TD[2], true);

	acss_TD[3] = TextDrawCreate(35.0000, 65.0000, "txd:bracsn1");
	TextDrawTextSize(acss_TD[3], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[3], 1);
	TextDrawColor(acss_TD[3], -1);
	TextDrawBackgroundColor(acss_TD[3], 255);
	TextDrawFont(acss_TD[3], 4);
	TextDrawSetSelectable(acss_TD[3], true);

	acss_TD[4] = TextDrawCreate(35.0000, 110.0000, "txd:bracsn2");
	TextDrawTextSize(acss_TD[4], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[4], 1);
	TextDrawColor(acss_TD[4], -1);
	TextDrawBackgroundColor(acss_TD[4], 255);
	TextDrawFont(acss_TD[4], 4);
	TextDrawSetSelectable(acss_TD[4], true);

	acss_TD[5] = TextDrawCreate(35.0000, 155.0000, "txd:bracsn3");
	TextDrawTextSize(acss_TD[5], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[5], 1);
	TextDrawColor(acss_TD[5], -1);
	TextDrawBackgroundColor(acss_TD[5], 255);
	TextDrawFont(acss_TD[5], 4);
	TextDrawSetSelectable(acss_TD[5], true);

	acss_TD[6] = TextDrawCreate(35.0000, 200.0000, "txd:bracsn4");
	TextDrawTextSize(acss_TD[6], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[6], 1);
	TextDrawColor(acss_TD[6], -1);
	TextDrawBackgroundColor(acss_TD[6], 255);
	TextDrawFont(acss_TD[6], 4);
	TextDrawSetSelectable(acss_TD[6], true);

	acss_TD[7] = TextDrawCreate(35.0000, 245.0000, "txd:bracsn5");
	TextDrawTextSize(acss_TD[7], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[7], 1);
	TextDrawColor(acss_TD[7], -1);
	TextDrawBackgroundColor(acss_TD[7], 255);
	TextDrawFont(acss_TD[7], 4);
	TextDrawSetSelectable(acss_TD[7], true);

	acss_TD[8] = TextDrawCreate(35.0000, 290.0000, "txd:bracsn6");
	TextDrawTextSize(acss_TD[8], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[8], 1);
	TextDrawColor(acss_TD[8], -1);
	TextDrawBackgroundColor(acss_TD[8], 255);
	TextDrawFont(acss_TD[8], 4);
	TextDrawSetSelectable(acss_TD[8], true);

	acss_TD[9] = TextDrawCreate(35.0000, 335.0000, "txd:bracsn7");
	TextDrawTextSize(acss_TD[9], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[9], 1);
	TextDrawColor(acss_TD[9], -1);
	TextDrawBackgroundColor(acss_TD[9], 255);
	TextDrawFont(acss_TD[9], 4);
	TextDrawSetSelectable(acss_TD[9], true);

	acss_TD[10] = TextDrawCreate(35.0000, 65.0000, "txd:bracsa1");
	TextDrawTextSize(acss_TD[10], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[10], 1);
	TextDrawColor(acss_TD[10], -1);
	TextDrawBackgroundColor(acss_TD[10], 255);
	TextDrawFont(acss_TD[10], 4);

	acss_TD[11] = TextDrawCreate(35.0000, 110.0000, "txd:bracsa2");
	TextDrawTextSize(acss_TD[11], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[11], 1);
	TextDrawColor(acss_TD[11], -1);
	TextDrawBackgroundColor(acss_TD[11], 255);
	TextDrawFont(acss_TD[11], 4);

	acss_TD[12] = TextDrawCreate(35.0000, 155.0000, "txd:bracsa3");
	TextDrawTextSize(acss_TD[12], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[12], 1);
	TextDrawColor(acss_TD[12], -1);
	TextDrawBackgroundColor(acss_TD[12], 255);
	TextDrawFont(acss_TD[12], 4);

	acss_TD[13] = TextDrawCreate(35.0000, 200.0000, "txd:bracsa4");
	TextDrawTextSize(acss_TD[13], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[13], 1);
	TextDrawColor(acss_TD[13], -1);
	TextDrawBackgroundColor(acss_TD[13], 255);
	TextDrawFont(acss_TD[13], 4);

	acss_TD[14] = TextDrawCreate(35.0000, 245.0000, "txd:bracsa5");
	TextDrawTextSize(acss_TD[14], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[14], 1);
	TextDrawColor(acss_TD[14], -1);
	TextDrawBackgroundColor(acss_TD[14], 255);
	TextDrawFont(acss_TD[14], 4);

	acss_TD[15] = TextDrawCreate(35.0000, 290.0000, "txd:bracsa6");
	TextDrawTextSize(acss_TD[15], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[15], 1);
	TextDrawColor(acss_TD[15], -1);
	TextDrawBackgroundColor(acss_TD[15], 255);
	TextDrawFont(acss_TD[15], 4);

	acss_TD[16] = TextDrawCreate(35.0000, 335.0000, "txd:bracsa7");
	TextDrawTextSize(acss_TD[16], 117.0000, 42.0000);
	TextDrawAlignment(acss_TD[16], 1);
	TextDrawColor(acss_TD[16], -1);
	TextDrawBackgroundColor(acss_TD[16], 255);
	TextDrawFont(acss_TD[16], 4);

	acss_TD[17] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm1");
	TextDrawTextSize(acss_TD[17], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[17], 1);
	TextDrawColor(acss_TD[17], -1);
	TextDrawBackgroundColor(acss_TD[17], 255);
	TextDrawFont(acss_TD[17], 4);
	TextDrawSetProportional(acss_TD[17], 0);
	TextDrawSetShadow(acss_TD[17], 0);

	acss_TD[18] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm2");
	TextDrawTextSize(acss_TD[18], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[18], 1);
	TextDrawColor(acss_TD[18], -1);
	TextDrawBackgroundColor(acss_TD[18], 255);
	TextDrawFont(acss_TD[18], 4);
	TextDrawSetProportional(acss_TD[18], 0);
	TextDrawSetShadow(acss_TD[18], 0);

	acss_TD[19] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm3");
	TextDrawTextSize(acss_TD[19], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[19], 1);
	TextDrawColor(acss_TD[19], -1);
	TextDrawBackgroundColor(acss_TD[19], 255);
	TextDrawFont(acss_TD[19], 4);
	TextDrawSetProportional(acss_TD[19], 0);
	TextDrawSetShadow(acss_TD[19], 0);

	acss_TD[20] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm4");
	TextDrawTextSize(acss_TD[20], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[20], 1);
	TextDrawColor(acss_TD[20], -1);
	TextDrawBackgroundColor(acss_TD[20], 255);
	TextDrawFont(acss_TD[20], 4);
	TextDrawSetProportional(acss_TD[20], 0);
	TextDrawSetShadow(acss_TD[20], 0);

	acss_TD[21] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm5");
	TextDrawTextSize(acss_TD[21], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[21], 1);
	TextDrawColor(acss_TD[21], -1);
	TextDrawBackgroundColor(acss_TD[21], 255);
	TextDrawFont(acss_TD[21], 4);
	TextDrawSetProportional(acss_TD[21], 0);
	TextDrawSetShadow(acss_TD[21], 0);

	acss_TD[22] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm6");
	TextDrawTextSize(acss_TD[22], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[22], 1);
	TextDrawColor(acss_TD[22], -1);
	TextDrawBackgroundColor(acss_TD[22], 255);
	TextDrawFont(acss_TD[22], 4);
	TextDrawSetProportional(acss_TD[22], 0);
	TextDrawSetShadow(acss_TD[22], 0);

	acss_TD[23] = TextDrawCreate(430.0000, 100.0000, "txd:bracsm7");
	TextDrawTextSize(acss_TD[23], 180.0000, 230.0000);
	TextDrawAlignment(acss_TD[23], 1);
	TextDrawColor(acss_TD[23], -1);
	TextDrawBackgroundColor(acss_TD[23], 255);
	TextDrawFont(acss_TD[23], 4);
	TextDrawSetProportional(acss_TD[23], 0);
	TextDrawSetShadow(acss_TD[23], 0);

	acss_TD[24] = TextDrawCreate(460.0, 205.0, "ld_beat:up"); 
	TextDrawTextSize(acss_TD[24], 45.0, 45.0);
	TextDrawColor(acss_TD[24], 0xFFFFFF00); // Полностью прозрачный цвет
	TextDrawFont(acss_TD[24], 4);
	TextDrawSetSelectable(acss_TD[24], true);

	acss_TD[25] = TextDrawCreate(530.0, 205.0, "ld_beat:up");
	TextDrawTextSize(acss_TD[25], 45.0, 45.0);
	TextDrawColor(acss_TD[25], 0xFFFFFF00); // Полностью прозрачный цвет
	TextDrawFont(acss_TD[25], 4);
	TextDrawSetSelectable(acss_TD[25], true);

	return 1;
}

stock StartAccessoryEdit(playerid, modelid, bone, slot, inv_db_id)
{
    SetPVarInt(playerid, "inv_db_id", inv_db_id);
    SetPVarInt(playerid, "slot", slot);
    SetPVarInt(playerid, "bone", bone);
    SetPVarInt(playerid, "acs_model", modelid);

    new query[128];
    mysql_format(db_handle, query, sizeof(query), "SELECT * FROM `player_accessories` WHERE `inv_id` = %d LIMIT 1", inv_db_id);
    mysql_tquery(db_handle, query, "OnLoadAccessoryEdit", "i", playerid);
	new Node:res = JSON_Object();
    JSON_SetInt(res, "c", 1);
    OnPacketIncoming(playerid, 33, res);
    JSON_Cleanup(res);
    return 1;
}

forward OnLoadAccessoryEdit(playerid);
public OnLoadAccessoryEdit(playerid)
{
    if(cache_num_rows())
    {
        SetPVarFloat(playerid, "edit_x", cache_get_field_content_float(0, "pos_x"));
        SetPVarFloat(playerid, "edit_y", cache_get_field_content_float(0, "pos_y"));
        SetPVarFloat(playerid, "edit_z", cache_get_field_content_float(0, "pos_z"));
        SetPVarFloat(playerid, "edit_rX", cache_get_field_content_float(0, "rot_x"));
        SetPVarFloat(playerid, "edit_rY", cache_get_field_content_float(0, "rot_y"));
        SetPVarFloat(playerid, "edit_rZ", cache_get_field_content_float(0, "rot_z"));
        SetPVarFloat(playerid, "edit_scale", cache_get_field_content_float(0, "scale"));
    }
    else
    {
        SetPVarFloat(playerid, "edit_x", 0.0); SetPVarFloat(playerid, "edit_y", 0.0); SetPVarFloat(playerid, "edit_z", 0.0);
        SetPVarFloat(playerid, "edit_rX", 0.0); SetPVarFloat(playerid, "edit_rY", 0.0); SetPVarFloat(playerid, "edit_rZ", 0.0);
        SetPVarFloat(playerid, "edit_scale", 1.0);
    }

    SetPlayerAttachedObject(playerid, GetPVarInt(playerid, "slot"), GetPVarInt(playerid, "acs_model"), GetPVarInt(playerid, "bone"),
        GetPVarFloat(playerid, "edit_x"), GetPVarFloat(playerid, "edit_y"), GetPVarFloat(playerid, "edit_z"),
        GetPVarFloat(playerid, "edit_rX"), GetPVarFloat(playerid, "edit_rY"), GetPVarFloat(playerid, "edit_rZ"),
        GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"), GetPVarFloat(playerid, "edit_scale"));

    for(new i; i < 11; i++) TextDrawShowForPlayer(playerid, acss_TD[i]);
    TextDrawShowForPlayer(playerid, acss_TD[17]);
    TextDrawShowForPlayer(playerid, acss_TD[24]);
    TextDrawShowForPlayer(playerid, acss_TD[25]);
    SetPVarInt(playerid, "acss_TD_use", 1);
    
    new s[32];
    format(s, sizeof s, "%.4f", GetPVarFloat(playerid, "edit_x"));
    acss_coords_PTD[playerid] = CreatePlayerTextDraw(playerid, 521.3996, 292.8998, s);
    PlayerTextDrawShow(playerid, acss_coords_PTD[playerid]);
    SelectTextDraw(playerid, -1);
    TogglePlayerControllable(playerid, false);
    acs_editing[playerid] = true;
    return 1;
}

stock StopAccessoryEdit(playerid, bool:save)
{
    if(save)
    {
        new query[512];
        mysql_format(db_handle, query, sizeof(query), 
            "INSERT INTO `player_accessories` (uid, inv_id, modelid, bone, pos_x, pos_y, pos_z, rot_x, rot_y, rot_z, scale) \
            VALUES (%d, %d, %d, %d, %f, %f, %f, %f, %f, %f, %f) \
            ON DUPLICATE KEY UPDATE pos_x=%f, pos_y=%f, pos_z=%f, rot_x=%f, rot_y=%f, rot_z=%f, scale=%f",
            Player[playerid][pID], GetPVarInt(playerid, "inv_db_id"), GetPVarInt(playerid, "acs_model"), GetPVarInt(playerid, "bone"),
            GetPVarFloat(playerid, "edit_x"), GetPVarFloat(playerid, "edit_y"), GetPVarFloat(playerid, "edit_z"),
            GetPVarFloat(playerid, "edit_rX"), GetPVarFloat(playerid, "edit_rY"), GetPVarFloat(playerid, "edit_rZ"), GetPVarFloat(playerid, "edit_scale"),
            GetPVarFloat(playerid, "edit_x"), GetPVarFloat(playerid, "edit_y"), GetPVarFloat(playerid, "edit_z"),
            GetPVarFloat(playerid, "edit_rX"), GetPVarFloat(playerid, "edit_rY"), GetPVarFloat(playerid, "edit_rZ"), GetPVarFloat(playerid, "edit_scale"));
        mysql_tquery(db_handle, query);
    }

    for(new i; i < sizeof acss_TD; i++) TextDrawHideForPlayer(playerid, acss_TD[i]);
    if(acss_coords_PTD[playerid] != PlayerText:INVALID_TEXT_DRAW) {
        PlayerTextDrawDestroy(playerid, acss_coords_PTD[playerid]);
        acss_coords_PTD[playerid] = PlayerText:INVALID_TEXT_DRAW;
    }
    
    DeletePVar(playerid, "inv_db_id");
    DeletePVar(playerid, "slot");
    DeletePVar(playerid, "bone");
    DeletePVar(playerid, "acs_model");
    DeletePVar(playerid, "acss_TD_use");
    DeletePVar(playerid, "edit_x"); DeletePVar(playerid, "edit_y"); DeletePVar(playerid, "edit_z");
    DeletePVar(playerid, "edit_rX"); DeletePVar(playerid, "edit_rY"); DeletePVar(playerid, "edit_rZ"); DeletePVar(playerid, "edit_scale");

    CancelSelectTextDraw(playerid);
    TogglePlayerControllable(playerid, true);
    acs_editing[playerid] = false;
    return 1;
}

stock IsAccessoryWorn(playerid, inv_slot) {
    return (PlayerInventory[playerid][inv_slot][invValue] == 1);
}

stock GetAccSlot(itemid) {
    if(itemid == 2) return 0;
    if(itemid == 141) return 1;
    return 5; 
}

stock RemoveAccObject(playerid, inv_id) {
    for(new i = 0; i < 10; i++) {
        if(IsPlayerAttachedObjectSlotUsed(playerid, i)) {
            RemovePlayerAttachedObject(playerid, i);
        }
    }
}