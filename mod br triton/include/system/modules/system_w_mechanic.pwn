
#include <a_samp>
#include <streamer>
#include <brnotification>
//        
#if !defined SCM
#define SCM 											SendClientMessage
#endif
#if !defined SC
#define SC              "{ffff00}| {ffffff}"
#endif
#if !defined USC
#define USC             "{ff2400}| {ffffff}"
#endif
#if !defined DSM
#define DSM		DIALOG_STYLE_MSGBOX
#endif
#if !defined DSL
#define DSL		DIALOG_STYLE_LIST
#endif


new vihod_mex, vhod_mex, mex_sphere, sphere_item_mex;
new bool:player_job_active[MAX_PLAYERS char];
new bool:p_load_active[MAX_PLAYERS char];
new item_auto[MAX_PLAYERS char];
new player_veh_id[MAX_PLAYERS char];
new actor_player[MAX_PLAYERS char];
#define MAX_MEX_VEH 200

enum STRUCT_MEX_VEH
{
    ST_PLAYER, // 
    ST_ID_SRV, // id
    ST_ID_VEH, // 
    bool:ST_OIL,
    bool:ST_SP,
    bool:ST_BP,
    bool:ST_SS,
    bool:ST_BAT
};


new model_veh_mex[5] = {412, 492, 500, 503, 516};
new name_item_auto[5][23] = {" ", " ", " ", " ", ""};
new vehicle_mex[MAX_MEX_VEH][STRUCT_MEX_VEH];

stock GetMexAuto(veh_id)
{
    new like = 0;

    if(!vehicle_mex[veh_id][ST_OIL]) like++;
    if(!vehicle_mex[veh_id][ST_SS]) like++;
    if(!vehicle_mex[veh_id][ST_SP]) like++;
    if(!vehicle_mex[veh_id][ST_BP]) like++;
    if(!vehicle_mex[veh_id][ST_BAT]) like++;

    return like;
}

stock DeleteVehicleMex(playerid, actor = 0)
{
    new id_veh = player_veh_id{playerid};

    DestroyVehicle(vehicle_mex[id_veh][ST_ID_SRV]);

    if(actor) DestroyActor(actor_player{playerid});

    vehicle_mex[id_veh][ST_PLAYER] = -1;
    vehicle_mex[id_veh][ST_ID_VEH] = 0;
    vehicle_mex[id_veh][ST_ID_SRV] = -1;
    vehicle_mex[id_veh][ST_OIL] = false;
    vehicle_mex[id_veh][ST_SS]  = false;
    vehicle_mex[id_veh][ST_SP]  = false;
    vehicle_mex[id_veh][ST_BP]  = false;
    vehicle_mex[id_veh][ST_BAT] = false;
    player_veh_id{playerid} = -1;

    return 1;

}

stock NewIdVehMex()
{
    new car;
    for(new i; i < sizeof vehicle_mex; i++)
    {
        if(vehicle_mex[i][ST_PLAYER] != -1) continue;
        car = i;
    }
    return car;
}


public SYS_SYSTEM_W_MECHANIC_OnGameModeInit()
{
    print("[LAIRD_SYSTEM]   \n: Welsi Studio");
    vihod_mex = CreateDynamicSphere(993.221069, 1000.334350, 1501.000000, 0.5);
    vhod_mex = CreateDynamicSphere(1873.612792, -127.811904, 15.695312, 1.0);

    CreateActorEx("", "  ", 206, 994.231079,1004.094543,1501.000000,222.366333, 1, 1);
    mex_sphere = CreateDynamicSphere(994.231079,1004.094543,1501.000000, 2.5);

    sphere_item_mex = CreateDynamicSphere(1004.897766,1000.668457,1501.0, 2.7);
    CreateDynamic3DTextLabel("   ", 0xFFEE00FF3, 1004.897766,1000.668457,1501.0, 5.0);
    CreateDynamic3DTextLabel("  \n[ ]", 0xFFBB00FF3, 1873.612792, -127.811904, 15.695312, 5.0);
    CreateDynamic3DTextLabel("  \n[ ]", 0xFFBB00FF3, 993.221069, 1000.334350, 1501.000000, 5.0);
    #if defined m_OnGameModeInit
        return m_OnGameModeInit();
    #else
        return 0;
    #endif
}
#if defined _ALS_SYS_SYSTEM_W_MECHANIC_OnGameModeInit
    #undef SYS_SYSTEM_W_MECHANIC_OnGameModeInit
#else
    #define _ALS_SYS_SYSTEM_W_MECHANIC_OnGameModeInit
#endif
#define SYS_SYSTEM_W_MECHANIC_OnGameModeInit m_OnGameModeInit
#if defined m_OnGameModeInit
    forward m_OnGameModeInit();
#endif


public SYS_SYSTEM_W_MECHANIC_OnPlayerDisconnect(playerid, reason)
{
    if(p_load_active{playerid}) DeleteVehicleMex(playerid, 1);
	player_job_active{playerid} = false;
    p_load_active{playerid} = false;
    #if defined m_OnPlayerDisconnect
        return m_OnPlayerDisconnect(playerid, reason);
    #else
        return 0;
    #endif
}

#if defined _ALS_SYS_SYSTEM_W_MECHANIC_OnPlayerDisconnect
    #undef SYS_SYSTEM_W_MECHANIC_OnPlayerDisconnect
#else
    #define _ALS_SYS_SYSTEM_W_MECHANIC_OnPlayerDisconnect
#endif
#define SYS_SYSTEM_W_MECHANIC_OnPlayerDisconnect m_OnPlayerDisconnect
#if defined m_OnPlayerDisconnect
    forward m_OnPlayerDisconnect(playerid, reason);
#endif

public SYS_SYSTEM_W_MECHANIC_OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == vhod_mex)
    {
        SetPlayerPosEx(playerid, 994.787597,1000.367431,1501.000000,270.871093, 1, 1);
        SCM(playerid, -1, ""SC"    ");
    }
    if(areaid == vihod_mex)
    {
        SetPlayerPosEx(playerid, 1872.091186,-128.175704,15.695312,116.325195, 0, 0);

        if(player_job_active{playerid})
        {
            player_job_active{playerid} = false;
            p_load_active{playerid} = false;
            if(item_auto{playerid}) DeleteVehicleMex(playerid, 1);
            item_auto{playerid} = -1;
            SetPlayerSkinInit(playerid);
            SCM(playerid, -1,""USC"   ");
        }
    }
    if(areaid == mex_sphere)
    {
        ShowNotification(playerid, 4, "", 7, "/yes_mex", ">>");
    }
    if(areaid == sphere_item_mex)
    {
        //: Welsi  :t.me/welsistudio
        if(item_auto{playerid}) return SCM(playerid, -1, ""USC"     ");
        
        ShowNotification(playerid, 4, "", 7, "/menu_mex", ">>");
    }
    #if defined m_OnPlayerEnterDynamicArea
        return m_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 0;
    #endif
}

#if defined _ALS_SYS_SYSTEM_W_MECHANIC_OnPlayerEnterDynamicArea
    #undef SYS_SYSTEM_W_MECHANIC_OnPlayerEnterDynamicArea
#else
    #define _ALS_SYS_SYSTEM_W_MECHANIC_OnPlayerEnterDynamicArea
#endif
#define SYS_SYSTEM_W_MECHANIC_OnPlayerEnterDynamicArea m_OnPlayerEnterDynamicArea
#if defined m_OnPlayerEnterDynamicArea
    forward m_OnPlayerEnterDynamicArea(playerid, areaid);
#endif
//: Welsi  :t.me/welsistudio

public SYS_SYSTEM_W_MECHANIC_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 1299)
    {
        if(response)
        {
            new text[286];

            switch(listitem)
            {
                case 0:
                {
                    if(p_load_active{playerid}) return SCM(playerid, -1, ""USC"    ");

					if(player_job_active{playerid})
					{
						SCM(playerid, -1, ""SC"   ");
						player_job_active{playerid} = false;
                        SetPlayerSkinInit(playerid);
						SetPlayerVirtualWorld(playerid, 1);
						if(actor_player{playerid} || player_veh_id{playerid}) DeleteVehicleMex(playerid, 1);
					}
                    else
                    {
                        player_job_active{playerid} = true;
                        SCM(playerid, -1, ""SC"     ");
                        SCM(playerid, -1, ""SC" :   \" \"");
                        SetPlayerSkin(playerid, 206);
                        
                        SetPlayerVirtualWorld(playerid, playerid+2);
                        actor_player{playerid} = CreateActorEx("", "  ", 206, 994.231079,1004.094543,1501.000000,222.366333, GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid));
                    }

                    callcmd::yes_mex(playerid);
                }
                case 1:
                {
		    	   if(!player_job_active{playerid}) return SCM(playerid, -1, ""USC"   !");
                   else if(p_load_active{playerid}) return SCM(playerid, -1, ""USC"    ");

                   new id = NewIdVehMex(), veh_id = model_veh_mex[random(5)], R = random(3) + 1, RR = random(5);
                   if(id >= MAX_MEX_VEH) return SCM(playerid, -1, ""USC"     ");

                   new veh = CreateVehicle(veh_id, 996.179199,1000.484130,1501.000000,270.0, random(250), random(250), -1);

    
                    Welsi(playerid, id, veh, veh_id);

		    	    printf("IDm = %d | IDp:%d | Vm:%d | Vs:%d | sO:%d | sSP:%d | sBP:%d | sSS:%d | sBA:%d",\
                    id,
		    	    vehicle_mex[id][ST_PLAYER],
		    	    vehicle_mex[id][ST_ID_VEH],
		    	    vehicle_mex[id][ST_ID_SRV],
		    	    vehicle_mex[id][ST_OIL],
		    	    vehicle_mex[id][ST_SP],
		    	    vehicle_mex[id][ST_BP],
		    	    vehicle_mex[id][ST_SS],
		    	    vehicle_mex[id][ST_BAT]
		    	    ); //: Welsi  :t.me/welsistudio

                    format(text, sizeof (text), ":{FFFB00}\"%s\" {FFFFFF}  ", g_vehicle_info[veh_id - 400][VI_NAME]);
                    SCM(playerid, -1, text);

                    player_veh_id{playerid} = id;
		    	    p_load_active{playerid} = true;
		    	    SetVehicleVirtualWorld(vehicle_mex[id][ST_ID_SRV], GetPlayerVirtualWorld(playerid));
		    	    LinkVehicleToInterior(vehicle_mex[id][ST_ID_SRV], 1);

                    callcmd::yes_mex(playerid);
                }
                case 2:
                {
                    if(!p_load_active{playerid}) return SCM(playerid, -1, ""USC"    !");

                    new id_veh = player_veh_id{playerid};

                    format
                    (
                        text, sizeof text, 
                        "  \n\
                        {FFFFFF} : %s\n\
                        {FFFFFF}  : %s\n\
                        {FFFFFF}  : %s\n\
                        {FFFFFF}  : %s\n\
                        {FFFFFF} : %s",
                        vehicle_mex[id_veh][ST_OIL]  ? ("{FF0000}") : ("{00FF15} "),
                        vehicle_mex[id_veh][ST_SS]  ? ("{FF0000}") : ("{00FF15} "),
                        vehicle_mex[id_veh][ST_SP]  ? ("{FF0000}") : ("{00FF15} "),
                        vehicle_mex[id_veh][ST_BP]  ? ("{FF0000}") : ("{00FF15} "),
                        vehicle_mex[id_veh][ST_BAT]  ? ("{FF0000}") : ("{00FF15} ")
                    );

                    Dialog
                    (
                        playerid, -1, DSM,
                        " |   /",
                        text, 
                        "", ""
                    );
                }
                case 3:
                {
                    //: Welsi  :t.me/welsistudio
                    new id_veh = player_veh_id{playerid}, bool:c_work = false;

					if(GetMexAuto(id_veh) != 5) c_work = true;
					
                    if(c_work)
					{
						SCM(playerid, -1, ""USC"      -   ");
						DeleteVehicleMex(playerid);	
					}
					else
					{
						new money = (random(5000)*2) + 2500 * GetMexAuto(id_veh);

						GivePlayerMoneyEx(playerid, money);
						SCM(playerid, -1, ""SC"    .  ");
						DeleteVehicleMex(playerid);	
					}
                    player_veh_id{playerid} = -1;
                    p_load_active{playerid} = false;

                    callcmd::yes_mex(playerid);
                }

            }
        }
    }
    if(dialogid == 1298)
    {
        if(response)
        {
            //: Welsi  :t.me/welsistudio
            switch(listitem)
            {
                case 0:MexCheckPoint(playerid, 1);
                case 1:MexCheckPoint(playerid, 2);
                case 2:MexCheckPoint(playerid, 3);
                case 3:MexCheckPoint(playerid, 4);
                case 4:MexCheckPoint(playerid, 5);
            }
        }
    }  
    
#if defined spd_OnDialogResponse
return spd_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_SYS_SYSTEM_W_MECHANIC_OnDialogResponse
#undef SYS_SYSTEM_W_MECHANIC_OnDialogResponse
#else
#define _ALS_SYS_SYSTEM_W_MECHANIC_OnDialogResponse
#endif
#define SYS_SYSTEM_W_MECHANIC_OnDialogResponse spd_OnDialogResponse
#if defined spd_OnDialogResponse
forward spd_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

stock MexCheckPoint(playerid, item)
{
    new text[45];

    if(item_auto{playerid}) return SCM(playerid, -1, ""USC"     ");
        
    item_auto{playerid} = item;
    format(text, sizeof text, "  {FFFF00}%s", name_item_auto[item - 1]);
    SCM(playerid, -1, text);
    
    switch(item)
    {
        case 1: SetPlayerCheckpoint(playerid, 999.391723,1000.550903,1501.000000, 1.4);
        case 2: SetPlayerCheckpoint(playerid, 999.391723,1000.550903,1501.000000, 1.4);
        case 3: SetPlayerCheckpoint(playerid, 995.221984,998.613891,1501.000000, 1.0);
        case 4: SetPlayerCheckpoint(playerid, 996.590942,998.667053,1501.000000, 1.4);
        case 5: SetPlayerCheckpoint(playerid, 999.391723,1000.550903,1501.000000, 1.4);
    }
    //: Welsi  :t.me/welsistudio
    SetPVarInt(playerid, "CheckPMex", 1);

    return 1;
}
public SYS_SYSTEM_W_MECHANIC_OnPlayerEnterCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "CheckPMex"))
    {
        new item = item_auto{playerid}, veh_id = player_veh_id{playerid};

        DisablePlayerCheckpoint(playerid);
        ApplyAnimationEx(playerid, "OTB", "betslp_loop", 4.1, 1, 0, 0, 1, 4_000, 0);
        SetTimerEx("UnfreezePlayer", 4010, false, "i", playerid);

        switch(item)
        {
            case 0: SCM(playerid, -1, ""SC" ERROR");
            case 1:
            {
                if(!vehicle_mex[veh_id][ST_OIL]) 
                {
                    SCM(playerid, -1, ""USC"    .     \"\"");
                    item_auto{playerid} = 0;
                }
                else
                {
                    item_auto{playerid} = 0;
                    SCM(playerid, -1, ""SC"  {09FF00}{FFFFFF}  .");
                    vehicle_mex[veh_id][ST_OIL] = false;
                }
            }
            case 2:
            {
                if(!vehicle_mex[veh_id][ST_SP]) 
                {
                    SCM(playerid, -1, ""USC"    .     \"\"");
                    item_auto{playerid} = 0;
                }
                else
                {
                    item_auto{playerid} = 0;
                    SCM(playerid, -1, ""SC"  {09FF00}{FFFFFF}   .");
                    vehicle_mex[veh_id][ST_SP] = false;
                }
            }
            case 3:
            {
                if(!vehicle_mex[veh_id][ST_BP]) 
                {
                    SCM(playerid, -1, ""USC"    .     \"\"");
                    item_auto{playerid} = 0;
                }
                else
                {
                    item_auto{playerid} = 0;
                    SCM(playerid, -1, ""SC"  {09FF00}{FFFFFF}   .");
                    vehicle_mex[veh_id][ST_BP] = false;
                }
            }
            case 4:
            {
                if(!vehicle_mex[veh_id][ST_SS]) 
                {
                    SCM(playerid, -1, ""USC"    .     \"\"");
                    item_auto{playerid} = 0;
                }
                else
                {
                    item_auto{playerid} = 0;
                    SCM(playerid, -1, ""SC"  {09FF00}{FFFFFF}   .");
                    vehicle_mex[veh_id][ST_SS] = false;
                }
                //: Welsi  :t.me/welsistudio
            }
            case 5:
            {
                if(!vehicle_mex[veh_id][ST_BAT]) 
                {
                    SCM(playerid, -1, ""USC"   .     \"\"");
                    item_auto{playerid} = 0;
                }
                else
                {
                    item_auto{playerid} = 0;
                    SCM(playerid, -1, ""SC"  {09FF00}{FFFFFF}  .");
                    vehicle_mex[veh_id][ST_BAT] = false;
                }
            }
            
        }
    }
    #if defined m_OnPlayerEnterCheckpoint
        return m_OnPlayerEnterCheckpoint(playerid);
    #else
        return 0;
    #endif
}
#if defined _ALS_SYS_SYSTEM_W_MECHANIC_OnPlayerEnterCheckpoint
    #undef SYS_SYSTEM_W_MECHANIC_OnPlayerEnterCheckpoint
#else
    #define _ALS_SYS_SYSTEM_W_MECHANIC_OnPlayerEnterCheckpoint
#endif
#define SYS_SYSTEM_W_MECHANIC_OnPlayerEnterCheckpoint m_OnPlayerEnterCheckpoint
#if defined m_OnPlayerEnterCheckpoint
    forward m_OnPlayerEnterCheckpoint(playerid);
#endif

CMD:yes_mex(playerid)
{
    if(!IsPlayerInDynamicArea(playerid, mex_sphere)) return SCM(playerid, -1, ""SC"   ");

    Dialog
    (
        playerid, 1299, DSL, 
        "|  ",
        "1. / \n"\
        "2.   /\n"\
        "3.    /\n"\
        "4.  . ",
        "", ""
    );
    return 1;
    //: Welsi  :t.me/welsistudio
}
CMD:menu_mex(playerid)
{
    if(item_auto{playerid}) return SCM(playerid, -1, ""USC"     ");
    else if(!player_job_active{playerid}) return SCM(playerid, -1, ""USC"  ");
    else if(!p_load_active{playerid}) return SCM(playerid, -1, ""USC"    !");

    Dialog
    (
        playerid, 1298, DSL,
        " |   ",
        ""SC"  \n"\
        ""SC"  \n"\
        ""SC"  \n"\
        ""SC"  \n"\
        ""SC" ",
        "", ""
    );

    return 1;
}
stock Welsi(playerid, id, srv_id, veh_id)
{
    for(new i = -1; i < random(3); i++)
    {
        switch(random(5))
        {
            case 0:vehicle_mex[id][ST_OIL] = true;
            case 1:vehicle_mex[id][ST_BAT] = true;
            case 2:vehicle_mex[id][ST_SS] = true;
            case 3:vehicle_mex[id][ST_SP] = true;
            case 4:vehicle_mex[id][ST_BP] = true;
        }
    }

    vehicle_mex[id][ST_PLAYER] = playerid;
    vehicle_mex[id][ST_ID_VEH] = veh_id;
    vehicle_mex[id][ST_ID_SRV] = srv_id;

    return 1;
}
//: Welsi  :t.me/welsistudio