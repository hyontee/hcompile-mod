
//Êàê ïîäêëþ÷àòü include
//ïîñëå loader_job_unload_cp

#define MAX_AIRDROP     20
#define SCM 											SendClientMessage
// #define SC              "{ffff00}| {ffffff}"
// #define USC             "{ff2400}| {ffffff}"
#define 	DSM		DIALOG_STYLE_MSGBOX
#define 	DSL		DIALOG_STYLE_LIST

new air_pickup[MAX_AIRDROP], air_sphere[MAX_AIRDROP], Text3D:text_in_obj[MAX_AIRDROP];
new player_drop[MAX_PLAYERS] = -1;

#define AIR_STATE_ONLOAD        0
#define AIR_STATE_LOAD          1
#define AIR_STATE_CRASH         2
#define AIR_STATE_OPEN          3


enum STRUCT_AIRDROP {
    Float:AIR_X,
    Float:AIR_Y,
    Float:AIR_Z,
    AIR_STATE,
}

new Float:airdrop[MAX_AIRDROP][STRUCT_AIRDROP] =
{
    {985.435607,561.368896,12.061946,        0},
    {-1155.501220,-1122.719238,14.6342432,   0},
    { 268.546554,-1530.241455,37.381175,     0},
    {3782.038085,-817.789245,36.850200,      0},
    {4212.972930,572.859130,12.156250,       0},
    {-2396.620361,221.031341,26.095102,      0},
    {-2670.541015,1317.826782,7.295213,      0},
    {-2111.578125,1669.372192,30.176200,     0},
    {-2270.628173,2290.606689,49.435626,     0},
    {-1591.960083,2596.730957,39.667503,     0},
    {-752.556457,2497.797119,39.721225,      0},
    {-174.563873,2329.260498,10.700754,      0},
    {1137.621215,2377.898193,14.263135,      0},
    {1076.250732,1806.155029,20.474391,      0},
    {1630.518310,2301.146240,13.208730,      0},
    {1164.484252,2970.006591,2.729508,       0},
    {1919.506347,1440.180908,14.759574,      0},
    {1754.106689,946.158874,15.224995,       0},
    {2724.03271,485.620605,14.214732,        0},
    {1389.194580,-2367.502197,93.222793,     0}
};


public OnGameModeInit()
{
    print("[W_SYSTEM] Ñèñòåìà AIRDROP'à çàãðóæåíà\n Welsi(t.me/welsistudio)");
    SetTimer("TimerDrop", 1000*60, true);
    #if defined air_OnGameModeInit
        return air_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit air_OnGameModeInit
#if defined air_OnGameModeInit
    forward air_OnGameModeInit();
#endif

stock AirDrop()
{
    new string[10], hour, minute;
    gettime(hour, minute);

    print("Airdrop Start");
    
    // Î÷èñòêà ÷àòà è àíîíñ
    for(new i = 0; i < 5; i++) SendClientMessageToAll(-1, "");
    
    SendClientMessageToAll(-1, ""SC" Íà ñåðâåðå ïðîèçîøëî ñîáûòèÿ {FFFF00}AIRDROP {686868}(äëèòñÿ 40 ìèíóò)");
    SendClientMessageToAll(-1, ""SC" Èùèòå íà êàðòå {FFFF00}ÿùèêè {FFFFFF}ñ ïðèçàìè è ëîìàéòå ÷òîáû ïîëó÷èòü ïðèç");
    SendClientMessageToAll(-1, ""SC" ×òîáû óçíàòü èíôîðìàöèþ î {FFFF00}ÿùèêàõ{FFFFFF} èñïîëüçóéòå {FFFF00}/airdrop");
    SendClientMessageToAll(-1, ""SC" ×òîáû ñëîìàòü {FFFF00}ÿùèê{FFFFFF} èñïîëüçóéòå {FFFF00}/crashbox");

    // Ñîçäàíèå ÿùèêîâ
    for(new a; a < MAX_AIRDROP; a++)
    {
        air_pickup[a] = CreateObject(1271, airdrop[a][AIR_X], airdrop[a][AIR_Y], airdrop[a][AIR_Z] - 0.6, 0.0, 0.0, 0.0);
        format(string, sizeof string, "ßùèê [%d]", a);
        text_in_obj[a] = CreateDynamic3DTextLabel(string, 0xFF4800FFF, airdrop[a][AIR_X], airdrop[a][AIR_Y], airdrop[a][AIR_Z], 10.0);
        airdrop[a][AIR_STATE] = AIR_STATE_LOAD;
        air_sphere[a] = CreateDynamicSphere(airdrop[a][AIR_X], airdrop[a][AIR_Y], airdrop[a][AIR_Z], 2.5, 0, 0);
    }

    // Âûäà÷à êîìïåíñàöèè àäìèíèñòðàòîðàì
    foreach(new i : Player)
    {
        if(GetPlayerAdminEx(i) > 0) // Åñëè èãðîê àäìèí
        {
        GivePlayerMoneyEx(i, 500000, "ADMIN: AirDrop Compensation", true, false);
        
        // Âûäà÷à äîíàòíîé âàëþòû (ðóáëè)
        GivePlayerDonateRub(i, 50, "ADMIN: AirDrop Compensation");
        
            
            // Óâåäîìëåíèå
            SendClientMessage(i, 0xFF0000AA, "Âû Àäìèíèñòðàòîð, äëÿ âàñ Air-Drop çàïðåù¸í!");
            SendClientMessage(i, 0x32a44bFF, "Âàì âûäàíà êîìïåíñàöèÿ: 500.000 èãðîâîé âàëþòû è 50 BC");
        }
    }

    print("Âñå AirDrop'û çàãðóæåíû");
    return 1;
}
public: TimerDrop()
{       //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
	new m;

	gettime(_, m, _);

    if(!m) AirDrop();

    if(m == 40) UnAirDrop();
}

public OnPlayerDisconnect(playerid, reason)
{
    if(player_drop[playerid] != -1) DeleteAirDrop(player_drop[playerid]);
    #if defined air_OnPlayerDisconnect
        return air_OnPlayerDisconnect(playerid, reason);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect air_OnPlayerDisconnect
#if defined air_OnPlayerDisconnect
    forward air_OnPlayerDisconnect(playerid, reason);
#endif
       //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
public OnPlayerConnect(playerid)
{
    player_drop[playerid] = -1;
    #if defined air_OnPlayerConnect
        return air_OnPlayerConnect(playerid);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect air_OnPlayerConnect
#if defined air_OnPlayerConnect
    forward air_OnPlayerConnect(playerid);
#endif

       //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(air_sphere[0] <= areaid <= air_sphere[sizeof air_sphere - 1])
    {
       new id_air = IsPlayerInRangeOfAnyAirDrop(playerid);
       if(0 <= player_drop[playerid] <= MAX_AIRDROP)
       {    
            if(airdrop[id_air][AIR_STATE] == AIR_STATE_CRASH)
            {
                new text[284];
                new id = player_drop[playerid], money = random(100000) + 1000000,donate = random(100) + 1,exp = random(10) + 5; 
                format(text, sizeof text,\
                "Âû îòêðûëè ÿùèê[%d]\n\
                Âàì âûïàëî {FFFF00}%d{FFFFFF} ðóáëåé, {FFFF00}%d {FFFFFF}äîíàò-ðóáëåé, {FFFF00}%d {FFFFFF}î÷êîâ îïûòà\n\
                ×òîáû çàáðàòü âñå ïðèçû íàæìèòå {15FF00}\"Çàáðàòü\" \n\
                {FFFFFF}Åñëè âû íàæìåòå {FF0000}\"Íàçàä\"{FFFFFF} ÿùèê ïðîïàäåò",
                id, money, donate, exp
                );    
                SetPVarInt(playerid, "air_money", money);
                SetPVarInt(playerid, "air_donate", donate);
                SetPVarInt(playerid, "air_exp", exp); 

                Dialog(playerid, 2330, DSM, "Èíôîðìàöèÿ î ïðèçàõ â ÿùèêå", text, "Çàáðàòü", "Íàçàä");
            }
       }
       else
       {
               //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
            if(airdrop[id_air][AIR_STATE] == AIR_STATE_LOAD) ShowNewNotification(playerid, 5, 5, 1, 10, "Ââåäèòå /crashbox", "Îê");
            else{
                SCM(playerid, -1, ""USC" ßùèê óæå ñëîìàí äðóãèì èãðîêîì");
            }
       }
    }

    #if defined air_OnPlayerEnterDynamicArea
        return air_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 1;
    #endif
}

#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea air_OnPlayerEnterDynamicArea
#if defined air_OnPlayerEnterDynamicArea
    forward air_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 2330)
    {
        if(response)
        {
            new money = GetPVarInt(playerid, "air_money"), donate = GetPVarInt(playerid, "air_donate"), exp = GetPVarInt(playerid, "air_exp");
            airdrop[player_drop[playerid]][AIR_STATE] = AIR_STATE_OPEN;
            GivePlayerMoneyEx(playerid, money);        //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
            GivePlayerDonateRub(playerid, donate);
            AddPlayerData(playerid, P_EXP, +, exp);
            UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));
            DeleteAirDrop(player_drop[playerid]);

            if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
		    {
		    	SetPlayerData(playerid, P_EXP, 0);
		    	AddPlayerData(playerid, P_LEVEL, +, 1);

		    	SetPlayerLevelInit(playerid);
		    	SCM(playerid, -1, "Ïîçäðàâëÿåì! Âàø óðîâåíü ïîâûøåí");
		    }
            SCM(playerid, 0xFBFF00FF, "Âû çàáðàëè âñå ïðèçû ñ ÿùèêà. Ïîçäðàâëÿåì!");
        }
        else 
        {
            DeleteAirDrop(player_drop[playerid]);
            SCM(playerid, -1, ""USC" Âû îòêàçàëèñü îò ÿùèêà. ßùèê óäàëåí");
        }
    }
    if(dialogid == 2331)
    {
        if(response)
        {
            new id = GetPlayerListitemValue(playerid, listitem);

            EnablePlayerGPS(playerid, 55, airdrop[id][AIR_X], airdrop[id][AIR_Y], airdrop[id][AIR_Z], "Ìåñòîïîëîæåíèå ÿùèêà îòìå÷åíî íà êàðòå!");
        }
    }
    #if defined air_OnDialogResponse
    return air_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse air_OnDialogResponse
#if defined air_OnDialogResponse
forward air_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

stock DeleteAirDrop(id_air)
{
           //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
    foreach(new i:Player)
    {
        if(player_drop{i} != id_air) continue;

        player_drop{i} = -1;
        if(GetPVarInt(i, "air_money"))   DeletePVar(i, "air_money");
        if(GetPVarInt(i, "air_donate"))  DeletePVar(i, "air_donate");
        if(GetPVarInt(i, "air_exp"))     DeletePVar(i, "air_exp");
    }
    if(IsValidPickup(air_pickup[id_air])) DestroyPickup(air_pickup[id_air]);
    if(IsValidDynamic3DTextLabel(text_in_obj[id_air])) DestroyDynamic3DTextLabel(text_in_obj[id_air]);
    if(GetDynamicAreaType(air_sphere[id_air])) DestroyDynamicArea(air_sphere[id_air]);

    return 1;
}
stock DialogTAB45(playerid, dialogid, style, title[], text[], button[], button2[])
{
  if(style == 5)
  {
     ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "...", "...", "...", ""); 
  }
  ShowPlayerDialog(playerid, dialogid, style, title, text, button, button2);
  return 1;//åãîð ññáîíóñ
}

CMD:crashbox(playerid)
{
    // Ïðîâåðêà íà àäìèíà
    if(GetPlayerAdminEx(playerid) > 0)
    {
        SendClientMessage(playerid, 0xFF0000AA, "Âû Àäìèíèñòðàòîð, äëÿ âàñ Air-Drop çàïðåù¸í! Âû ïîëó÷àåòå êîìïåíñàöèþ!");
        return 1;
    }
    
    if(IsPlayerInRangeOfAnyAirDrop(playerid) == -1) return 0;
    new id = IsPlayerInRangeOfAnyAirDrop(playerid);

    ApplyAnimationEx(playerid, "BASEBALL", "Bat_4", 3.1, 1, 1, 1, 0, 0, 0, USE_ANIM_TYPE_NONE - 1);
    StopAnimationAirDrop(playerid);
    return 1;
}

CMD:airdrop(playerid)
{
    // Ïðîâåðêà íà àäìèíà
    if(GetPlayerAdminEx(playerid) > 0)
    {
        SendClientMessage(playerid, 0xFF0000AA, "Âû Àäìèíèñòðàòîð, äëÿ âàñ Air-Drop çàïðåù¸í! Âû ïîëó÷àåòå êîìïåíñàöèþ!");
        return 1;
    }

    new drop, text[185], list[sizeof text * 10 + 50] = "Ïðåäìåò\tÐàññòîÿíèå\n";
    new Float:dist;

    for(new d, count; d < MAX_AIRDROP; d++)
    {
        if(airdrop[d][AIR_STATE] != AIR_STATE_LOAD) continue;

        dist = GetPlayerDistanceFromPoint(playerid, airdrop[d][AIR_X], airdrop[d][AIR_Y], airdrop[d][AIR_Z]);
        format(text, sizeof text, "{FFFFFF}ßùèê [%d]\t{7E7E7E}%.2f \n", d+1, dist);
        strcat(list, text);
        drop++;
        SetPlayerListitemValue(playerid, count ++, d);
    }

    if(!drop) return SCM(playerid, -1, ""USC" Âñå ÿùèêè îòêðûòû / Ñîáûòèå åùå íå íà÷àëîñü");

    DialogTAB45(playerid, 2331, DIALOG_STYLE_LIST, "Èíôîðìàöèÿ î AirDrop'å", list, "Îòìåòèòü", "Çàêðûòü");
    return 1;
}
CMD:start_drop(playerid)
{
           //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
    if(!(GetPlayerAdminEx(playerid) >= 8)) return 0;
    AirDrop();
    return 1;
}
CMD:end_drop(playerid)
{
    if(!(GetPlayerAdminEx(playerid) >= 8)) return 0;

    UnAirDrop();
    return 1;
}

stock UnAirDrop()
{
    print("Airdrop End");
    for(new i = 0; i < 5; i++)
    {
        SendClientMessageToAll(-1, "");
    }
           //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
    SendClientMessageToAll(-1, ""SC" Íà ñåðâåðå çàâåðøåíî ñîáûòèå {FFFF00}AIRDROP");
    SendClientMessageToAll(-1, ""SC" Âñå {FFFF00}ÿùèêè {FFFFFF}ñ ïðèçàìè íà êàðòå áûëè óäàëåíû");
    SendClientMessageToAll(-1, ""SC" Ñëåäóùèé {FFFF00}AIRDROP {FFFFFF}ïðîèçîéäåò â {FFFF00}XX:00");
    for(new d;  d < MAX_AIRDROP;d++)
    {
        DestroyPickup(air_pickup[d]);
        airdrop[d][AIR_STATE] = AIR_STATE_ONLOAD;
        DestroyDynamic3DTextLabel(text_in_obj[d]);
        DestroyDynamicArea(air_sphere[d]);
    }
    return 1;
}
stock IsPlayerInRangeOfAnyAirDrop(playerid)
{
           //Àâòîð: Welsi Òã êàíàë:t.me/welsistudio
    new area = -1;

	for(new idx; idx < MAX_AIRDROP; idx ++)
	{
		if(!IsPlayerInDynamicArea(playerid, air_sphere[idx])) continue;
        area = idx;
	}
	return area;
}
public:StopAnimationAirDrop(playerid)
{
    ClearAnimations(playerid);
    new id = IsPlayerInRangeOfAnyAirDrop(playerid), text[74];
    DestroyPickup(id);
    airdrop[id][AIR_STATE] = AIR_STATE_CRASH;
    format(text, sizeof text, "Ñëîìàííûé ßùèê [%d]\nÓíè÷òîæåí:%s\nÏîäîéäèòå ÷òîáû âçÿòü ïðåäìåòû", id, GetPlayerData(playerid, P_NAME));
    UpdateDynamic3DTextLabelText(text_in_obj[id], 0xFF4800FFF, text);
    player_drop[playerid] = id;
    ClearAnimations(playerid);
    return 1;
}
//telegram author: Welsi Studio
//Àâòîð: Welsi Òã êàíàë:t.me/welsistudio