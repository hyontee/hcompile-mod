#define START_OBJECT_1  35 // (     00:XX)
#define START_OBJECT_2  40 //  (     00:XX)
#define START_OBJECT_3  45 //  (     00:XX)

new object_duration[5] = {300, 600, 900, 300, 300}; //second

new Float:coord_area_f_obj[5][4] =
{
    {910.033874,1902.940673,878.857238,1928.133544},//xmax,ymax,xmin,ymin
    {2323.993896,-272.032928,2291.157470,-240.167694},
    {-565.758972,-1971.165283,-612.426330,-2057.928710},
    {247.395721,-1518.309814,219.366928,-1497.108764},
    {2684.796630,559.033142,2664.952636,578.705078}
};

new Float:text_3d_capt[5][3] =
{
    {886.062377,1920.454956,24.079668},
    {2323.703613,-264.093597,1.561422},
    {-570.480468,-1972.626953,41.199874},
    {237.258758,-1508.003417,35.468399},
    {2676.136474,569.995239,15.730620}
};

new name_object[5][35] =
{
    {"   1"},
    {" "},
    {" "},
    {"   2"},
    {"   3"}
};

new Text:fam_TD[5][9];
new PlayerText:fam_PTD[MAX_PLAYERS][5];
new bool:fam_PTD_loaded[MAX_PLAYERS];

//new bool:player_TD_fam_exp[MAX_PLAYERS];
new bool:show_panel_capt[MAX_PLAYERS];

new CAPTURE_AREA[5] = -1, CAPTURE_GANG_ZONE[5] = -1, CAPTURE_SECOND[5] = 0, bool:CAPTURE_STATUS[5], CAPTURE_TIMER[5] = -1, Text3D:CAPTURE_3DTEXT[5];
new CAPTURE_FAMILY_EXP[MAX_FAM][5], CAPTURE_LEADER[5][2]; // 0 - id, 1 - exp

new CAPTURE_PLAYER_EXP[MAX_PLAYERS];
new stringcapture[8];

//family cont

new FAM_CONT_AREA[2] = -1, FAM_CONT_GANG_ZONE[2] = -1, FAM_CONT_BOX[2], FAM_CONT_SECOND[2] = 0, bool:FAM_CONT_STATUS[2], FAM_CONT_TIMER[2] = -1, Text3D:FAM_CONT_3DTEXT[2], 
FAM_CONT_PICKUP[2], FAM_CONT_AREA_P[2], FAM_CONT_OBJECT[2];

new FAM_CONT_VEHICLE[MAX_PLAYERS], FAM_CONT_DELIVERY;

new Float:coord_fam_cont[2][4] =
{
    {2065.620849,1366.642456,2001.571777,1410.343261},
    {513.669067,-2324.174560,400.018676,-2446.855957}
};

new Float:coord_puckup_cont[2][3] =
{
    {2019.277465,1397.384521,26.273437},
    {454.554718,-2388.093750,34.930751}
};

new Float:coord_obj_cont[2][3] =
{
    {2016.786865,1397.302490,26.15625},
    {452.989440,-2388.076660,34.813564}
};

public SYS_FAMILY_ADDITION_OnGameModeInit()
{
    TextDrawFamilyWar();

    Create3DTextLabel(": {FF0000}", -1, 2323.082275,-248.499404,1.991280, 25.0, 0);
    FAM_CONT_DELIVERY = CreateDynamicSphere(2323.082275,-248.499404,1.991280, 5.0, 0, 0);
    CAPTURE_3DTEXT[0] = Create3DTextLabel("{FFF000}   1\n{FFFFFF}   ", -1, text_3d_capt[0][0], text_3d_capt[0][1], text_3d_capt[0][2]+1.0, 10.0, 0, 1);
    CAPTURE_3DTEXT[3] = Create3DTextLabel("{FFF000}   2\n{FFFFFF}   ", -1, text_3d_capt[3][0], text_3d_capt[3][1], text_3d_capt[3][2]+1.0, 10.0, 0, 1);
    CAPTURE_3DTEXT[4] = Create3DTextLabel("{FFF000}   3\n{FFFFFF}   ", -1, text_3d_capt[4][0], text_3d_capt[4][1], text_3d_capt[4][2]+1.0, 10.0, 0, 1);
    CAPTURE_3DTEXT[1] = Create3DTextLabel("{FFF000} \n{FFFFFF}   ", -1, text_3d_capt[1][0], text_3d_capt[1][1], text_3d_capt[1][2]+1.0, 10.0, 0, 1);
    CAPTURE_3DTEXT[2] = Create3DTextLabel("{FFF000} \n{FFFFFF}   ", -1, text_3d_capt[2][0], text_3d_capt[2][1], text_3d_capt[2][2]+1.0, 10.0, 0, 1);
    SetTimer("FamilyTimer", 60*1000, true);

    #if defined capt_OnGameModeInit
        return capt_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_SYS_FAMILY_ADDITION_OnGameModeInit
    #undef SYS_FAMILY_ADDITION_OnGameModeInit
#else
    #define _ALS_SYS_FAMILY_ADDITION_OnGameModeInit
#endif
#define SYS_FAMILY_ADDITION_OnGameModeInit capt_OnGameModeInit
#if defined capt_OnGameModeInit
    forward capt_OnGameModeInit();
#endif

public SYS_FAMILY_ADDITION_OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == CAPTURE_AREA[0] || areaid == CAPTURE_AREA[1] || areaid == CAPTURE_AREA[2] || areaid == CAPTURE_AREA[3] || areaid == CAPTURE_AREA[4])
    {
        if(areaid != -1 && GetPlayerIdFamily(playerid) != -1 && !show_panel_capt[playerid]) ShowFamilyCaptPanel(playerid, GetPlayerCaptArea(playerid));
    } 
    if(areaid == FAM_CONT_AREA[0] || areaid == FAM_CONT_AREA[1]) if(GetPlayerIdFamily(playerid) != -1) return SendClientMessage(playerid, -1, ""c_f"      ,        .");
    if(areaid == FAM_CONT_AREA_P[0] || areaid == FAM_CONT_AREA_P[1])
    {
        if(GetPlayerIdFamily(playerid) == -1) return 1;

        new number = -1;
        if(FAM_CONT_AREA_P[0] == areaid) number = 0;
        else number = 1;

        if(FAM_CONT_BOX[number])
        {
            if(GetPVarInt(playerid, "box_in_hard")) return SendClientMessage(playerid, -1, ""c_f_r"      .");

            ApplyAnimation(playerid, "CARRY", "liftup", 4.0, 0, 0, 0, 0, 0, 0);
            SetTimerEx("SetPlayerBoxInHard", 1000, false, "ii", playerid, number);
        }
        else SendClientMessage(playerid, -1, ""c_f_r"   .");
    }
    if(IsPlayerInDynamicArea(playerid, FAM_CONT_AREA[0]) || IsPlayerInDynamicArea(playerid, FAM_CONT_AREA[1]) && GetPlayerIdFamily(playerid) != -1)
    {
        new idx = -1;

        foreach(new i : Vehicle)
        {
            if(GetVehicleData(i, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_FAMILY_CAR) continue;
            else if(GetCarFamily(GetVehicleData(i, V_ACTION_ID), V_F_AREA_CONT) != areaid) continue;

            idx = GetVehicleData(i, V_ACTION_ID);

            if(GetCarFamily(idx, V_F_COUNT_BOX) < 50)
            {
                if(!GetPVarInt(playerid, "box_in_hard")) return SendClientMessage(playerid, -1, ""c_f_r"     .");

                DeletePVar(playerid, "box_in_hard");
                ApplyAnimation(playerid, "CARRY", "putdwn", 4.0, 0, 0, 0, 0, 0, 0);
                RemovePlayerAttachedObject(playerid, 2);

                AddCarFamily(idx, V_F_COUNT_BOX, +, 1);
                format(f_string144, sizeof f_string144, " : {FF0000}%d", GetCarFamily(idx, V_F_COUNT_BOX));
                UpdateDynamic3DTextLabelText(GetCarFamily(idx, V_F_TEXT_CONT), -1, f_string144);
                
                if(GetCarFamily(idx, V_F_COUNT_BOX) != 50) SendClientMessage(playerid, -1, ""c_f"    ,      .");
                else SendClientMessage(playerid, -1, ""c_f"    ,     ");
            }
            else SendClientMessage(playerid, -1, ""c_f_r"   ."); 
        }
    }
    #if defined capt_OnPlayerEnterDynamicArea
        return capt_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_SYS_FAMILY_ADDITION_OnPlayerEnterDynamicArea
    #undef SYS_FAMILY_ADDITION_OnPlayerEnterDynamicArea
#else
    #define _ALS_SYS_FAMILY_ADDITION_OnPlayerEnterDynamicArea
#endif
    #define SYS_FAMILY_ADDITION_OnPlayerEnterDynamicArea capt_OnPlayerEnterDynamicArea
    #if defined capt_OnPlayerEnterDynamicArea
        forward capt_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public SYS_FAMILY_ADDITION_OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
    if(newkeys == KEY_CROUCH)
    {
        HandleFamilyCrouch(playerid);
    }
    if(newkeys == KEY_FIRE)
    {
        if(GetPVarInt(playerid, "box_in_hard"))
        {
            RemovePlayerAttachedObject(playerid, 2);
            DeletePVar(playerid, "box_in_hard");
            SendClientMessage(playerid, -1, ""c_f_r"  ,     .");
        }
    }
    #if defined name_SYS_FAMILY_ADDITION_OnPlayerKeyStateChange
        return name_SYS_FAMILY_ADDITION_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
}
   #if defined _ALS_SYS_FAMILY_ADDITION_OnPlayerKeyStateChange
    #undef SYS_FAMILY_ADDITION_OnPlayerKeyStateChange
#else
    #define _ALS_SYS_FAMILY_ADDITION_OnPlayerKeyStateChange
#endif
#define SYS_FAMILY_ADDITION_OnPlayerKeyStateChange name_SYS_FAMILY_ADDITION_OnPlayerKeyStateChange
#if defined name_SYS_FAMILY_ADDITION_OnPlayerKeyStateChange
    forward name_SYS_FAMILY_ADDITION_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif

stock GetPlayerCaptArea(playerid)
{
    for(new i;i < sizeof(CAPTURE_AREA);i++) if(IsPlayerInDynamicArea(playerid, CAPTURE_AREA[i])) return i;
    return -1;
}

stock TextDrawExpFamily(playerid)
{
    if(fam_PTD_loaded[playerid]) return 1;

    for(new i;i < 5;i++)
    {
        fam_PTD[playerid][i] = CreatePlayerTextDraw(playerid, 99.3332, 252.6367, "0");
        PlayerTextDrawLetterSize(playerid, fam_PTD[playerid][i], 0.1799, 1.4961);
        PlayerTextDrawAlignment(playerid, fam_PTD[playerid][i], 2);
        PlayerTextDrawColor(playerid, fam_PTD[playerid][i], -1);
        PlayerTextDrawBackgroundColor(playerid, fam_PTD[playerid][i], 255);
        PlayerTextDrawFont(playerid, fam_PTD[playerid][i], 2);
        PlayerTextDrawSetProportional(playerid, fam_PTD[playerid][i], 1);
        PlayerTextDrawSetShadow(playerid, fam_PTD[playerid][i], 0);
    }

    fam_PTD_loaded[playerid] = true;
    return 1;
}

stock UpdatePlayerFamilyCaptureText(playerid, type)
{
    if(!fam_PTD_loaded[playerid]) return 1;

    new family_id = GetPlayerIdFamily(playerid);
    if(family_id == -1) return 1;

    format(stringcapture, sizeof stringcapture, "%d", CAPTURE_FAMILY_EXP[family_id][type]);
    PlayerTextDrawSetString(playerid, fam_PTD[playerid][type], stringcapture);
    return 1;
}

stock RefreshCapturePanels(type, family_id = -1)
{
    foreach(new i : Player)
    {
        if(!show_panel_capt[i]) continue;
        if(GetPlayerCaptArea(i) != type) continue;

        new player_family_id = GetPlayerIdFamily(i);
        if(player_family_id == -1) continue;
        if(family_id != -1 && player_family_id != family_id) continue;

        UpdatePlayerFamilyCaptureText(i, type);
    }
    return 1;
}

public SYS_FAMILY_ADDITION_OnPlayerLeaveDynamicArea(playerid, areaid)
{
    if(areaid == CAPTURE_AREA[0] || areaid == CAPTURE_AREA[1] || areaid == CAPTURE_AREA[2] || areaid == CAPTURE_AREA[3] || areaid == CAPTURE_AREA[4]) 
    {
        new type_capt, f = GetPlayerIdFamily(playerid);

        if(areaid == CAPTURE_AREA[0])  type_capt = 0;
        else if(areaid == CAPTURE_AREA[1]) type_capt = 1;
        else if(areaid == CAPTURE_AREA[2]) type_capt = 2;
        else if(areaid == CAPTURE_AREA[3]) type_capt = 3;
        else if(areaid == CAPTURE_AREA[4]) type_capt = 4;

        if(f == -1 || !CAPTURE_STATUS[type_capt]) return 0;
        HideFamilyCaptPanel(playerid, type_capt);

        new exp_new = CAPTURE_FAMILY_EXP[f][type_capt]-CAPTURE_PLAYER_EXP[playerid];

        if(exp_new >= 0) 
        {
            CAPTURE_FAMILY_EXP[f][type_capt] -= CAPTURE_PLAYER_EXP[playerid]; 
            if(CAPTURE_LEADER[type_capt][0] == f)   CAPTURE_LEADER[type_capt][1] -= CAPTURE_PLAYER_EXP[playerid];
        }

        new string[164];
        format(string, sizeof string, " %s[%d]      %d ", GetPlayerNameEx(playerid), playerid, CAPTURE_PLAYER_EXP[playerid]);
        SendFamilyMessage(f, string);

        CAPTURE_PLAYER_EXP[playerid] = 0;

        UpdateExpFamily(f, type_capt);
        RefreshCapturePanels(type_capt, f);
    }
    #if defined capt_OnPlayerLeaveDynamicArea
        return capt_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_SYS_FAMILY_ADDITION_OnPlayerLeaveDynamicArea
    #undef SYS_FAMILY_ADDITION_OnPlayerLeaveDynamicArea
#else
    #define _ALS_SYS_FAMILY_ADDITION_OnPlayerLeaveDynamicArea
#endif
#define SYS_FAMILY_ADDITION_OnPlayerLeaveDynamicArea capt_OnPlayerLeaveDynamicArea
#if defined capt_OnPlayerLeaveDynamicArea
    forward capt_OnPlayerLeaveDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

stock StartFCapture(type_capt)
{
    if(CAPTURE_STATUS[type_capt]) return printf("CAPTURE: %d already started", type_capt);

    new string[265], welsi, e[3] = {0, 3, 4};
    if(type_capt) 
    {
        welsi = 1;
        e[0] = type_capt;
    }
    else welsi = 3;

    for(new i;i < welsi;i++)
    {
        CAPTURE_STATUS[e[i]] = true;
        CAPTURE_LEADER[e[i]][0] = -1;
        CAPTURE_LEADER[e[i]][1] = 0;
        CAPTURE_SECOND[e[i]] = object_duration[e[i]];
        CAPTURE_TIMER[e[i]] = SetTimerEx("CaptureUpd", 1000, true, "i", e[i]);
        CAPTURE_GANG_ZONE[e[i]] = GangZoneCreate(coord_area_f_obj[e[i]][0], coord_area_f_obj[e[i]][1], coord_area_f_obj[e[i]][2], coord_area_f_obj[e[i]][3]);
        CAPTURE_AREA[e[i]] = CreateDynamicRectangle(coord_area_f_obj[e[i]][0], coord_area_f_obj[e[i]][1], coord_area_f_obj[e[i]][2], coord_area_f_obj[e[i]][3], 
        0, 0);

        for(new w; w < MAX_FAM;w++) CAPTURE_FAMILY_EXP[w][e[i]] = 0;

        format(string, sizeof string, "{FFFF00}%s\n{FFFFFF}   ", name_object[e[i]]);
        Update3DTextLabelText(CAPTURE_3DTEXT[e[i]], -1, string);

        foreach(new w : Player)
        {
            if(GetPlayerIdFamily(w) == -1) continue;
            GangZoneShowForPlayer(w, CAPTURE_GANG_ZONE[e[i]], 0xFF0000FF0);
            GangZoneFlashForPlayer(w, CAPTURE_GANG_ZONE[e[i]], 0xFFFF00FF);
        }

        format(string, sizeof string, "{FFFF00}|{FFFFFF}    {FFFF00}%s{FFFFFF},       ", name_object[e[i]]);

        foreach(new w : Player)
        {
            if(GetPlayerIdFamily(w) == -1) continue;
            SendClientMessage(w, -1, string);
        }
    }
    

    return 1;
}

public SYS_FAMILY_ADDITION_OnPlayerDisconnect(playerid, reason)
{
    new capt = GetPlayerCaptArea(playerid);

    if(GetPlayerIdFamily(playerid) != -1)
    {
        if(CAPTURE_PLAYER_EXP[playerid] != 0)
        {
            new f = GetPlayerIdFamily(playerid), string[124];
            
            if(capt != -1)
            {

                new exp = CAPTURE_FAMILY_EXP[f][capt]-CAPTURE_PLAYER_EXP[playerid];

                if(exp >= 0)
                {
                    CAPTURE_FAMILY_EXP[f][capt] -= CAPTURE_PLAYER_EXP[playerid];
                    if(CAPTURE_LEADER[capt][0] == GetPlayerIdFamily(playerid))   CAPTURE_LEADER[capt][1] -= CAPTURE_PLAYER_EXP[playerid];
                } 
                //author system : welsi
                RefreshCapturePanels(capt, f);
            }
            else for(new i;i<sizeof CAPTURE_STATUS;i++) UpdateExpFamily(f, i);

            format(string, sizeof string, " %s[%d]      %d ", GetPlayerNameEx(playerid), playerid, CAPTURE_PLAYER_EXP[playerid]);
            SendFamilyMessage(f, string);
        }
    }
    CAPTURE_PLAYER_EXP[playerid] = 0;
    show_panel_capt[playerid] = false;
    if(fam_PTD_loaded[playerid])
    {
        for(new i; i < 5; i++) PlayerTextDrawDestroy(playerid, fam_PTD[playerid][i]);
        fam_PTD_loaded[playerid] = false;
    }
    //if(GetPlayerIdFamily(playerid) != -1 && FAM_CONT_VEHICLE[playerid] != -1) return UnLoadFamilyCar(GetCarFamily(FAM_CONT_VEHICLE[playerid], CAR_F_database));
    //player_TD_fam_exp[playerid] = false;
    #if defined capt_OnPlayerDisconnect
        return capt_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_FAMILY_ADDITION_OnPlayerDisconnect
    #undef SYS_FAMILY_ADDITION_OnPlayerDisconnect
#else
    #define _ALS_SYS_FAMILY_ADDITION_OnPlayerDisconnect
#endif
#define SYS_FAMILY_ADDITION_OnPlayerDisconnect capt_OnPlayerDisconnect
#if defined capt_OnPlayerDisconnect
    forward capt_OnPlayerDisconnect(playerid, reason);
#endif

public: FamilyTimer()
{ 
    new minute, hours;

    gettime(hours, minute);

    switch(minute)
    {
        case 0:
        {
            if(!hours)
            {
                new year, month, day;

                getdate(year, month, day);
                
                if(GetDayOfWeek(year, month, day) == 4)
                {
                    mysql_format(mysql, f_string144, sizeof f_string144, "SELECT * FROM family WHERE reputation >= '0' ORDER BY reputation DESC");
                    new Cache:result = mysql_query(mysql, f_string144);

                    new rows = cache_num_rows(), id;

                    if(rows > 3) rows = 3;

                    for(new i; i < rows;i++)
                    {
                        id = cache_get_field_content_int(i, "id");

                        switch(i)
                        {
                            case 0:
                            {
                                mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE family SET slot_veh = slot_veh + 2 WHERE id = %d", id);
                                mysql_query(mysql, f_string144, false);

                                mysql_format(mysql, f_string184, sizeof f_string184, "INSERT INTO family_ad (family, ad_text, create_id, create_name, time) VALUES ('%d', '       ', -1, '', '%d')", id,\
                                gettime()+10800);
                                mysql_query(mysql, f_string184, false);

                                mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE accounts SET money = money + 90000, rub = rub + 40 WHERE family_id = %d", id);
                                mysql_query(mysql, f_string144, false);
                            }
                            case 1:
                            {
                                mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE family SET slot_veh = slot_veh + 1 WHERE id = %d", id);

                                mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE accounts SET money = money + 60000, rub = rub + 30 WHERE family_id = %d", id);
                                mysql_query(mysql, f_string144, false);

                                mysql_format(mysql, f_string184, sizeof f_string184, "INSERT INTO family_ad (family, ad_text, create_id, create_name, time) VALUES ('%d', '       ', -1, '', '%d')", id,\
                                gettime()+10800);
                                mysql_query(mysql, f_string184, false);
                            }
                            case 2:
                            {
                                mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE accounts SET money = money + 30000, rub = rub + 20 WHERE family_id = %d", id);
                                mysql_query(mysql, f_string144, false);

                                mysql_format(mysql, f_string144, sizeof f_string144, "UPDATE accounts SET rub = rub + 20 WHERE family_id = %d", id);
                                mysql_query(mysql, f_string144, false);

                                mysql_format(mysql, f_string184, sizeof f_string184, "INSERT INTO family_ad (family, ad_text, create_id, create_name, time) VALUES ('%d', '       ', -1, '', '%d')", id,\
                                gettime()+10800);
                                mysql_query(mysql, f_string184, false);

                            }
                        }
                    }

                    for(new i; i < MAX_FAM; i++) SetFamily(i, family_reputation, 0);

                    mysql_query(mysql, "UPDATE family SET reputation = 0", false);

                    cache_delete(result);
                }
            }
        }
        case START_OBJECT_1:StartFCapture(0);
        case START_OBJECT_2:StartFCapture(1);
        case START_OBJECT_3:StartFCapture(2);
        default:
        {
            if(!FAM_CONT_STATUS[0] && !FAM_CONT_STATUS[1])
            {
                switch(minute)
                {
                    case 0..59:
                    {
                        new r = random(40);

                        if(r <= 10) return 1;

                        StartFCont(1);
                    }
                }
            }
        }
    }
    return 1;
}

/*public OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart)
{
    if(damagedid != INVALID_PLAYER_ID)
    {
        for(new i; i < sizeof CAPTURE_STATUS;i++)
        {
            if(!CAPTURE_STATUS[i]) continue;
            else if(!IsPlayerInDynamicArea(playerid, CAPTURE_AREA[i]) || !IsPlayerInDynamicArea(damagedid, CAPTURE_AREA[i])) continue;

            SendClientMessage(playerid, -1, ""c_f_r"      .  !");
            
            new Float:heath;

            GetPlayerHealth(damagedid, heath);
            SetPlayerHealth(damagedid, heath+amount);

            break;
        }
    }
	#if defined capt_OnPlayerGiveDamage
		return capt_OnPlayerGiveDamage(playerid, damagedid, amount, weaponid, bodypart);
	#else
	    return 0;
	#endif
}
#if defined _ALS_OnPlayerGiveDamage
    #undef OnPlayerGiveDamage
#else
    #define _ALS_OnPlayerGiveDamage
#endif
#if defined capt_OnPlayerGiveDamage
	forward capt_OnPlayerGiveDamage(playerid, damagedid, Float:amount, weaponid, bodypart);
#endif
#define	OnPlayerGiveDamage capt_OnPlayerGiveDamage*/

public SYS_FAMILY_ADDITION_OnPlayerSpawn(playerid)
{
    if(GetPlayerIdFamily(playerid) != -1)
    {
        for(new i;i < sizeof(CAPTURE_STATUS);i++)
        {
            if(!CAPTURE_STATUS[i]) continue;
            GangZoneShowForPlayer(playerid, CAPTURE_GANG_ZONE[i], 0xFF0000FF0);
            GangZoneFlashForPlayer(playerid, CAPTURE_GANG_ZONE[i], 0xFFFF00FF);
        }
        
        for(new i;i < sizeof(FAM_CONT_STATUS);i++)
        {
            if(!FAM_CONT_STATUS[i]) continue;
            GangZoneShowForPlayer(playerid, FAM_CONT_GANG_ZONE[i], 0xFF0000FF0);
            GangZoneFlashForPlayer(playerid, FAM_CONT_GANG_ZONE[i], 0xFFFF00FF);
        }
    }
    CAPTURE_PLAYER_EXP [playerid] = 0;
    show_panel_capt[playerid] = false;

    #if defined capt_OnPlayerSpawn
        return capt_OnPlayerSpawn(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_SYS_FAMILY_ADDITION_OnPlayerSpawn
    #undef SYS_FAMILY_ADDITION_OnPlayerSpawn
#else
    #define _ALS_SYS_FAMILY_ADDITION_OnPlayerSpawn
#endif
#define SYS_FAMILY_ADDITION_OnPlayerSpawn capt_OnPlayerSpawn
#if defined capt_OnPlayerSpawn
    forward capt_OnPlayerSpawn(playerid);
#endif

public SYS_FAMILY_ADDITION_OnPlayerDeath(playerid, killerid, reason)
{
    if(GetPlayerIdFamily(playerid) != -1 && CAPTURE_STATUS[0] || CAPTURE_STATUS[1] || CAPTURE_STATUS[2])
    {
        if(CAPTURE_PLAYER_EXP[playerid] != 0)
        {
            new capt = GetPlayerCaptArea(playerid);

            new string[124];

            if(killerid != INVALID_PLAYER_ID)
            {
                new f = GetPlayerIdFamily(killerid);
                format(string, sizeof string, " %s[%d]     %d ", GetPlayerNameEx(killerid), killerid, CAPTURE_PLAYER_EXP[playerid]);
                SendFamilyMessage(f, string);

                CAPTURE_FAMILY_EXP[f][capt] += CAPTURE_PLAYER_EXP[playerid];
                CAPTURE_PLAYER_EXP[killerid] += CAPTURE_PLAYER_EXP[playerid];
            }

            format(string, sizeof string, " %s[%d]       %d ", GetPlayerNameEx(playerid), playerid, CAPTURE_PLAYER_EXP[playerid]);
            SendFamilyMessage(GetPlayerIdFamily(playerid), string);
            if(CAPTURE_FAMILY_EXP[GetPlayerIdFamily(playerid)][capt]-CAPTURE_PLAYER_EXP[playerid] >= 0)
            {
                CAPTURE_FAMILY_EXP[GetPlayerIdFamily(playerid)][capt] -= CAPTURE_PLAYER_EXP[playerid];
                if(CAPTURE_LEADER[capt][0] == GetPlayerIdFamily(playerid))   CAPTURE_LEADER[capt][1] -= CAPTURE_PLAYER_EXP[playerid];
            } 
            CAPTURE_PLAYER_EXP[playerid] = 0;

            //author system : welsi
        }
    }
    #if defined capt_OnPlayerDeath
return capt_OnPlayerDeath(playerid, killerid, reason);
#endif
}
#if defined _ALS_SYS_FAMILY_ADDITION_OnPlayerDeath
#undef SYS_FAMILY_ADDITION_OnPlayerDeath
#else
#define _ALS_SYS_FAMILY_ADDITION_OnPlayerDeath
#endif
#define SYS_FAMILY_ADDITION_OnPlayerDeath capt_OnPlayerDeath
#if defined capt_OnPlayerDeath
forward capt_OnPlayerDeath(playerid, killerid, reason);
#endif


stock ShowFamilyCaptPanel(playerid, t)
{
    show_panel_capt[playerid] = true;

    TextDrawExpFamily(playerid);
    UpdatePlayerFamilyCaptureText(playerid, t);

    for(new i; i < 9;i++) TextDrawShowForPlayer(playerid, fam_TD[t][i]);
    PlayerTextDrawShow(playerid, fam_PTD[playerid][t]);
    //if(!player_TD_fam_exp[playerid]) CreateTextDrawExpFamily(playerid);
    return 1;
}

stock HideFamilyCaptPanel(playerid, t)
{
    show_panel_capt[playerid] = false;

    for(new i; i < 9;i++) TextDrawHideForPlayer(playerid, fam_TD[t][i]);
    if(fam_PTD_loaded[playerid]) PlayerTextDrawHide(playerid, fam_PTD[playerid][t]);
    return 1;
}

cmd:endfevent(playerid, params[])
{
    if(CAPTURE_STATUS[0]) EndFCapture(0);
    if(CAPTURE_STATUS[1]) EndFCapture(1);
    if(CAPTURE_STATUS[2]) EndFCapture(2);

    return 1;
}

stock EndFCapture(type)
{
    KillTimer(CAPTURE_TIMER[type]);
    CAPTURE_TIMER[type] = -1;

    foreach(new i : Player)
    {
        if(GetPlayerIdFamily(i) == -1) continue;
        else if(!IsPlayerInDynamicArea(i, CAPTURE_AREA[type])) continue;
        HideFamilyCaptPanel(i, type);
        CAPTURE_PLAYER_EXP[i] = 0;
    }

    new string[245], f = CAPTURE_LEADER[type][0];

    if(f != -1 || CAPTURE_LEADER[type][1] != 0) 
    {
        format(string, sizeof string, " ,    %s,  %d",
        GetFamily(f, family_name), CAPTURE_LEADER[type][1]);
        
        AddFamily(f, family_reputation, +, CAPTURE_LEADER[type][1]);
        AddFamily(f, family_zaxvati, +, 1);
        UpdateColumnFamilyInt(GetFamily(f, family_database), "reputation", GetFamily(f, family_reputation));
        UpdateColumnFamilyInt(GetFamily(f, family_database), "zaxvati", GetFamily(f, family_zaxvati));

        for(new i; i < MAX_FAM;i++)
        {
            if(GetFamily(i, family_database) == -1) continue;
 
            SendFamilyMessage(i, string);
        }

        format(string, sizeof string, "{FFFF00}%s\n{FFFFFF}   \n%s", name_object[type], GetFamily(f, family_name));
        Update3DTextLabelText(CAPTURE_3DTEXT[type], -1, string);

    }

    DestroyDynamicArea(CAPTURE_AREA[type]);
    CAPTURE_AREA[type] = -1;

    GangZoneDestroy(CAPTURE_GANG_ZONE[type]);
    CAPTURE_GANG_ZONE[type] = -1;

    CAPTURE_SECOND[type] = 0;
    CAPTURE_STATUS[type] = false;
    
    for(new i; i < MAX_FAM;i++) CAPTURE_FAMILY_EXP[i][type] = 0;

    CAPTURE_LEADER[type][0] = -1;
    CAPTURE_LEADER[type][1] = 0;
    return 1;
}

new f_c_leader_id, f_c_leader_exp;
public:CaptureUpd(type)
{
    if(!CAPTURE_SECOND[type]) return EndFCapture(type);

    CAPTURE_SECOND[type]--;
    format(stringcapture, sizeof stringcapture, "%d:%02d", ConvertUnixTime(CAPTURE_SECOND[type], CONVERT_TIME_TO_MINUTES), ConvertUnixTime(CAPTURE_SECOND[type], CONVERT_TIME_TO_SECONDS));
    TextDrawSetString(fam_TD[type][8], stringcapture);


    foreach(new i : Player)
    {
        if(GetPlayerIdFamily(i) == -1 && show_panel_capt[i]) HideFamilyCaptPanel(i, type);
        else if(GetPlayerIdFamily(i) == -1) continue;
        else if(!IsPlayerInDynamicArea(i, CAPTURE_AREA[type])) continue;
        else if(IsPlayerAFK(i)) continue;


        CAPTURE_PLAYER_EXP[i]++;
        CAPTURE_FAMILY_EXP[GetPlayerIdFamily(i)][type]++;
    }

    f_c_leader_id = CAPTURE_LEADER[type][0], f_c_leader_exp = CAPTURE_LEADER[type][1]; 
    for(new i; i < MAX_FAM;i++)
    {
        if(f_c_leader_id == i) { if(CAPTURE_FAMILY_EXP[i][type] < f_c_leader_exp) UpdateExpFamily(i, type); } 

        if(CAPTURE_FAMILY_EXP[i][type] <= f_c_leader_exp) continue;

        CAPTURE_LEADER[type][0] = i;
        CAPTURE_LEADER[type][1] = CAPTURE_FAMILY_EXP[i][type];
    }

    format(stringcapture, sizeof stringcapture, "%d", CAPTURE_LEADER[type][1]);
    TextDrawSetString(fam_TD[type][4], stringcapture); 
    RefreshCapturePanels(type);

    return 1;
}

stock TextDrawFamilyWar()
{   
    for(new i; i < sizeof(fam_TD); i++)
    {
        //  
        fam_TD[i][0] = TextDrawCreate(6.3333, 248.3333, "LD_SPAC:white");
        TextDrawTextSize(fam_TD[i][0], 107.0000, 59.0000);
        TextDrawAlignment(fam_TD[i][0], 1);
        TextDrawColor(fam_TD[i][0], -1523897601);
        TextDrawFont(fam_TD[i][0], 4);
        TextDrawSetShadow(fam_TD[i][0], 0);

        //  
        fam_TD[i][1] = TextDrawCreate(6.3333, 249.5777, "LD_SPAC:white");
        TextDrawTextSize(fam_TD[i][1], 107.0000, 36.0000);
        TextDrawAlignment(fam_TD[i][1], 1);
        TextDrawColor(fam_TD[i][1], 370545919);
        TextDrawFont(fam_TD[i][1], 4);
        TextDrawSetShadow(fam_TD[i][1], 0);

        // :   
        new str1[] = "  :";
        utf8_to_cp1251(str1);
        fam_TD[i][2] = TextDrawCreate(10.3332, 252.2221, str1);
        TextDrawLetterSize(fam_TD[i][2], 0.1699, 1.4879);
        TextDrawAlignment(fam_TD[i][2], 1);
        TextDrawColor(fam_TD[i][2], -1);
        TextDrawFont(fam_TD[i][2], 2);
        TextDrawSetProportional(fam_TD[i][2], 1);
        TextDrawSetShadow(fam_TD[i][2], 0);

        // :  
        new str2[] = " :";
        utf8_to_cp1251(str2);
        fam_TD[i][3] = TextDrawCreate(10.3332, 266.7406, str2);
        TextDrawLetterSize(fam_TD[i][3], 0.1699, 1.4879);
        TextDrawAlignment(fam_TD[i][3], 1);
        TextDrawColor(fam_TD[i][3], -1);
        TextDrawFont(fam_TD[i][3], 2);
        TextDrawSetProportional(fam_TD[i][3], 1);
        TextDrawSetShadow(fam_TD[i][3], 0);

        //   
        fam_TD[i][4] = TextDrawCreate(99.6667, 267.1553, "0");
        TextDrawLetterSize(fam_TD[i][4], 0.2022, 1.4920);
        TextDrawAlignment(fam_TD[i][4], 2);
        TextDrawColor(fam_TD[i][4], -1);
        TextDrawFont(fam_TD[i][4], 2);
        TextDrawSetProportional(fam_TD[i][4], 1);
        TextDrawSetShadow(fam_TD[i][4], 0);

        //   1
        fam_TD[i][5] = TextDrawCreate(6.3333, 295.2074, "LD_SPAC:white");
        TextDrawTextSize(fam_TD[i][5], 107.0000, 5.0000);
        TextDrawAlignment(fam_TD[i][5], 1);
        TextDrawColor(fam_TD[i][5], 370545919);
        TextDrawFont(fam_TD[i][5], 4);
        TextDrawSetShadow(fam_TD[i][5], 0);

        //   2
        fam_TD[i][6] = TextDrawCreate(6.3333, 301.0148, "LD_SPAC:white");
        TextDrawTextSize(fam_TD[i][6], 107.0000, 6.0000);
        TextDrawAlignment(fam_TD[i][6], 1);
        TextDrawColor(fam_TD[i][6], 370545919);
        TextDrawFont(fam_TD[i][6], 4);
        TextDrawSetShadow(fam_TD[i][6], 0);

        // : :
        new str3[] = ":";
        utf8_to_cp1251(str3);
        fam_TD[i][7] = TextDrawCreate(40.6666, 284.9925, str3);
        TextDrawLetterSize(fam_TD[i][7], 0.2253, 1.0524);
        TextDrawAlignment(fam_TD[i][7], 1);
        TextDrawColor(fam_TD[i][7], -1);
        TextDrawFont(fam_TD[i][7], 1);
        TextDrawSetProportional(fam_TD[i][7], 1);
        TextDrawSetShadow(fam_TD[i][7], 0);

        //  ( 12:34)
        fam_TD[i][8] = TextDrawCreate(67.6666, 284.9925, "12:34");
        TextDrawLetterSize(fam_TD[i][8], 0.2253, 1.0524);
        TextDrawAlignment(fam_TD[i][8], 1);
        TextDrawColor(fam_TD[i][8], -1);
        TextDrawFont(fam_TD[i][8], 1);
        TextDrawSetProportional(fam_TD[i][8], 1);
        TextDrawSetShadow(fam_TD[i][8], 0);
    }
}


cmd:startfevent(playerid, params[])
{
    extract params -> new t;

    if(!t) return SendClientMessage(playerid, -1, "1 -  / 2 -   / 3 -   / 4 -  ");


    if(1 <= t <= 3)
    {
       if(CAPTURE_STATUS[t-1]) return SendClientMessage(playerid, -1, "   .");
       StartFCapture(t-1); 
    } 
    else if(t == 4)
    {
        if(FAM_CONT_STATUS[0] || FAM_CONT_STATUS[1]) return SendClientMessage(playerid, -1, "   .");
        StartFCont(0);
    }
    return 1;
}

stock UpdateExpFamily(f, t)
{
    new player_all_exp;

    foreach(new i : Player)
    {
        if(GetPlayerIdFamily(i) != f) continue;
        else if(!IsPlayerInDynamicArea(i, CAPTURE_AREA[t])) continue;

        player_all_exp += CAPTURE_PLAYER_EXP[i];
    }

    if(CAPTURE_FAMILY_EXP[f][t] != player_all_exp) CAPTURE_FAMILY_EXP[f][t] = player_all_exp;

    if(f == CAPTURE_LEADER[t][0]) CAPTURE_LEADER[t][1] = CAPTURE_FAMILY_EXP[f][t];

    return 1;
}
cmd:tpw(playerid, params[])
{
    if(!params[0]) SetPlayerPos(playerid, 452.989440,-2388.076660,34.813564);
    else SetPlayerPos(playerid, 2016.786865,1397.302490,26.15625);

    return 1;
}

stock StartFCont(type_capt)
{
    if(FAM_CONT_STATUS[type_capt]) return printf("CONT: %d already started", type_capt);

    new string[265], welsi = 2; //genius

    for(new i;i < welsi;i++)
    {
        FAM_CONT_STATUS[i] = true;
        FAM_CONT_BOX[i] = 350;
        FAM_CONT_SECOND[i] = 1500;
        FAM_CONT_GANG_ZONE[i] = GangZoneCreate(coord_fam_cont[i][0], coord_fam_cont[i][1], coord_fam_cont[i][2], coord_fam_cont[i][3]);
        FAM_CONT_AREA[i] = CreateDynamicRectangle(coord_fam_cont[i][0], coord_fam_cont[i][1], coord_fam_cont[i][2], coord_fam_cont[i][3], 
        0, 0);
        FAM_CONT_OBJECT[i] = CreateObject(934, coord_obj_cont[i][0], coord_obj_cont[i][1], coord_obj_cont[i][2]+1.0, 0.0, 0.0, 0.0);

        FAM_CONT_PICKUP[i] = CreateDynamicPickup(19135, 23, coord_puckup_cont[i][0], coord_puckup_cont[i][1], coord_puckup_cont[i][2], 0, 0);
        FAM_CONT_AREA_P[i] = CreateDynamicSphere(coord_puckup_cont[i][0], coord_puckup_cont[i][1], coord_puckup_cont[i][2], 1.5, 0, 0);
        FAM_CONT_3DTEXT[i] = Create3DTextLabel(" \n  : 25 \n    .", -1, 
        coord_puckup_cont[i][0], coord_puckup_cont[i][1], coord_puckup_cont[i][2], 20.0, 0);

        foreach(new w : Player)
        {
            if(GetPlayerIdFamily(w) == -1) continue;
            GangZoneShowForPlayer(w, FAM_CONT_GANG_ZONE[i], 0xFF0000FF0);
            GangZoneFlashForPlayer(w, FAM_CONT_GANG_ZONE[i], 0xFFFF00FF);
        }

        format(string, sizeof string, "{FFFF00}|{FFFFFF}    {FFFF00} {FFFFFF},       ");

        FAM_CONT_TIMER[i] = SetTimerEx("ContUpd", 1000, true, "i", i);
    }
    
    foreach(new w : Player)
    {
        if(GetPlayerIdFamily(w) == -1) continue;
        SendClientMessage(w, -1, string);
    }

    return 1;
}

new string_count[98];
public:ContUpd(i)
{
    if(!FAM_CONT_SECOND[i]) return EndFCont();
    FAM_CONT_SECOND[i]--;

    format(string_count, sizeof string_count, " \n  : %d \n    .", ConvertUnixTime(FAM_CONT_SECOND[i], CONVERT_TIME_TO_MINUTES));
    Update3DTextLabelText(FAM_CONT_3DTEXT[i], -1, string_count);
    return 1;
}

stock EndFCont()
{
    for(new i;i < 2;i++)
    {
        KillTimer(FAM_CONT_TIMER[i]);
        FAM_CONT_TIMER[i] = -1;

        FAM_CONT_STATUS[i] = false;

        DestroyObject(FAM_CONT_OBJECT[i]);
        FAM_CONT_OBJECT[i] = -1; 

        DestroyDynamicArea(FAM_CONT_AREA[i]);
        FAM_CONT_AREA[i] = -1;

        DestroyDynamicArea(FAM_CONT_AREA_P[i]);
        FAM_CONT_AREA_P[i] = -1;

        GangZoneDestroy(FAM_CONT_GANG_ZONE[i]);
        FAM_CONT_GANG_ZONE[i] = -1;

        FAM_CONT_BOX[i] = 0;

        FAM_CONT_SECOND[i] = 0;

        Delete3DTextLabel(FAM_CONT_3DTEXT[i]);
        FAM_CONT_3DTEXT[i] = Text3D:-1;

        DestroyDynamicPickup(FAM_CONT_PICKUP[i]);
        FAM_CONT_PICKUP[i] = -1;
    }
    return 1;
}


cmd:loadfamily(playerid)
{
    if(GetPlayerIdFamily(playerid) == -1) return 0;

    if(!IsPlayerInDynamicArea(playerid, FAM_CONT_AREA[0]) && !IsPlayerInDynamicArea(playerid, FAM_CONT_AREA[1]))
        return SendClientMessage(playerid, -1, ""c_f_g"    .");

    new vehicleid = GetPlayerVehicleID(playerid), action = GetVehicleData(vehicleid, V_ACTION_ID);

    if(vehicleid == INVALID_VEHICLE_ID || GetCarFamily(action, CAR_F_database) == -1 || GetCarFamily(action, OW_F_server) != GetPlayerIdFamily(playerid)) 
        return SendClientMessage(playerid, -1, ""c_f_r"     .");

    FAM_CONT_VEHICLE[playerid] = action;

    new Float:x, Float:y, Float:z, string[74];
    GetCoordBootFamilyVehicle(vehicleid, x, y, z);

    format(string, sizeof string, " : {FF0000}%d", GetCarFamily(action, V_F_COUNT_BOX));

    SetCarFamily(action, V_F_AREA_CONT, CreateDynamicSphere(x,y,z,1.5, 0, 0));
    SetCarFamily(action, V_F_TEXT_CONT, CreateDynamic3DTextLabel(string, -1, x, y, z, 7.0));
    SetCarFamily(action, V_F_STATUS_CONT, true);

    RemovePlayerFromVehicle(playerid);
    SendClientMessage(playerid, -1, ""c_f_g" .");
     
    return 1;
}

public SYS_FAMILY_ADDITION_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(GetVehicleData(vehicleid, V_ACTION_TYPE) == VEHICLE_ACTION_TYPE_FAMILY_CAR)
    {
        new id = GetVehicleData(vehicleid, V_ACTION_ID);

        if(GetCarFamily(id, V_F_STATUS_CONT))
        {
            SendClientMessage(playerid, -1, ""c_f_r"      ( )");
            CreateDynamicMapIcon(2323.082275,-248.499404,1.991280, 6, 0, 0, 0, playerid, -1);
            SetCarFamily(id, V_F_STATUS_CONT, false);

            RemovePlayerAttachedObject(playerid, 2);

            FAM_CONT_VEHICLE[playerid] = -1;

            if(IsValidDynamicArea(GetCarFamily(id, V_F_AREA_CONT))) DestroyDynamicArea(GetCarFamily(id, V_F_AREA_CONT));
            DestroyDynamic3DTextLabel(GetCarFamily(id, V_F_TEXT_CONT));
            SetCarFamily(id, V_F_STATUS_CONT, false);
        } 
    }
    #if defined cont_OnPlayerEnterVehicle
        return cont_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    #else
        return 1;
    #endif
}
   #if defined _ALS_SYS_FAMILY_ADDITION_OnPlayerEnterVehicle
    #undef SYS_FAMILY_ADDITION_OnPlayerEnterVehicle
#else
    #define _ALS_SYS_FAMILY_ADDITION_OnPlayerEnterVehicle
#endif
#define SYS_FAMILY_ADDITION_OnPlayerEnterVehicle cont_OnPlayerEnterVehicle
#if defined cont_OnPlayerEnterVehicle
    forward cont_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif

stock GetCoordBootFamilyVehicle(vehicleid, &Float:x, &Float:y, &Float:z)
{
    new Float:angle,Float:distance;
    GetVehicleModelInfo(GetVehicleModel(vehicleid), 1, x, distance, z);
    distance = distance/2 + 0.1;
        GetVehiclePos(vehicleid, x, y, z);
    GetVehicleZAngle(vehicleid, angle);
    x += (distance * floatsin(-angle+180, degrees));
    y += (distance * floatcos(-angle+180, degrees));
    return 1;
}

public:SetPlayerBoxInHard(playerid, number)
{
    SetPlayerAttachedObject(playerid, 2, 2969, 1, 0.121241, 0.433916, -0.038068, 359.338867, 91.670600, 179.788787, 1.000000, 1.000000, 1.000000);
    FAM_CONT_BOX[number]--;
    SendClientMessage(playerid, -1, ""c_f"  ,     .");
    SetPVarInt(playerid, "box_in_hard", 1);
    ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.1, 1, 1, 1, 1, 1, 0);

    return 1;
}
// Stock   KEY_CROUCH
stock HandleFamilyCrouch(playerid)
{
    if(GetPlayerIdFamily(playerid) == -1 || !IsPlayerInDynamicArea(playerid, FAM_CONT_DELIVERY)) return 0;

    new vehicleid = GetPlayerVehicleID(playerid);

    if(vehicleid == INVALID_VEHICLE_ID || GetVehicleData(vehicleid, V_ACTION_TYPE) != VEHICLE_ACTION_TYPE_FAMILY_CAR) return 0;

    new action = GetVehicleData(vehicleid, V_ACTION_ID), f = GetCarFamily(action, OW_F_server);

    if(f != GetPlayerIdFamily(playerid)) return 0;

    if(GetCarFamily(action, V_F_COUNT_BOX) == 0) return SendClientMessage(playerid, -1, ""c_f_r"      ");

    new money = GetCarFamily(action, V_F_COUNT_BOX) * 100;

    AddFamily(f, family_reputation, +, GetCarFamily(action, V_F_COUNT_BOX));
    AddFamily(f, family_money, +, money);
    UpdateColumnFamilyInt(GetFamily(f, family_database), "money", GetFamily(f, family_money));
    UpdateColumnFamilyInt(GetFamily(f, family_database), "reputation", GetFamily(f, family_reputation));

    format(f_string144, sizeof f_string144, "%s[%d]     ,   %d .,  %d ", 
        GetPlayerNameEx(playerid), playerid, GetCarFamily(action, V_F_COUNT_BOX), money);
    SendFamilyMessage(f, f_string144);
    SetCarFamily(action, V_F_COUNT_BOX, 0);

    return 1;
}
