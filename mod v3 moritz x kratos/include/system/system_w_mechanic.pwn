// ================================================================
//  РАБОТА АВТОСБОРЩИК
//  Версия: 2.0
// ================================================================

#include <a_samp>
#include "../include/streamer.inc"
#include <brnotification>

// ================================================================
//  ОПРЕДЕЛЕНИЯ (ДОБАВЛЕНЫ)
// ================================================================

#define SCM                     SendClientMessage
#define SC                      "{fad201}| {ffffff}"
#define USC                     "{ff2400}| {ffffff}"
#define DSM                     DIALOG_STYLE_MSGBOX
#define DSL                     DIALOG_STYLE_LIST

// ================================================================
//  ПЕРЕМЕННЫЕ
// ================================================================

new vihod_sb, vhod_sb, sb_sphere, sphere_item_sb;
new bool:player_job_active_sb[MAX_PLAYERS char];
new bool:p_load_active_sb[MAX_PLAYERS char];
new item_sb[MAX_PLAYERS char];
new player_veh_id_sb[MAX_PLAYERS char];
new actor_player_sb[MAX_PLAYERS];
new Text3D:actor_label_sb[MAX_PLAYERS];

#define MAX_SB_VEH 200
#define SB_BASE_WORLD 5000

enum STRUCT_SB_VEH
{
    ST_PLAYER_SB,
    ST_ID_SRV_SB,
    ST_ID_VEH_SB,
    bool:ST_ENGINE,
    bool:ST_TRANSMISSION,
    bool:ST_BODY,
    bool:ST_WHEELS,
    bool:ST_ELECTRONICS,
    bool:ST_INTERIOR
}

new model_veh_sb[10] = {412, 492, 500, 503, 516, 415, 2582, 2569, 666, 667};
new name_item_sb[6][23] = {"Двигатель", "Коробка передач", "Кузов", "Колеса", "Электроника", "Салон"};
new vehicle_sb[MAX_SB_VEH][STRUCT_SB_VEH];

// ================================================================
//  ФУНКЦИЯ ПОЛУЧЕНИЯ МИРА
// ================================================================

stock GetPlayerWorld_SB(playerid)
{
    return SB_BASE_WORLD + playerid;
}

// ================================================================
//  ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
// ================================================================

stock GetSbAuto(veh_id)
{
    new like = 0;
    if(!vehicle_sb[veh_id][ST_ENGINE]) like++;
    if(!vehicle_sb[veh_id][ST_TRANSMISSION]) like++;
    if(!vehicle_sb[veh_id][ST_BODY]) like++;
    if(!vehicle_sb[veh_id][ST_WHEELS]) like++;
    if(!vehicle_sb[veh_id][ST_ELECTRONICS]) like++;
    if(!vehicle_sb[veh_id][ST_INTERIOR]) like++;
    return like;
}

stock DeleteVehicleSb(playerid, actor = 0)
{
    new id_veh = player_veh_id_sb{playerid};

    if(id_veh >= 0 && id_veh < MAX_SB_VEH && vehicle_sb[id_veh][ST_ID_SRV_SB] != -1)
    {
        DestroyVehicle(vehicle_sb[id_veh][ST_ID_SRV_SB]);
    }

    if(actor && actor_player_sb[playerid] != INVALID_ACTOR_ID)
    {
        DestroyActor(actor_player_sb[playerid]);
        actor_player_sb[playerid] = INVALID_ACTOR_ID;
        
        if(actor_label_sb[playerid] != Text3D:INVALID_3DTEXT_ID)
        {
            Delete3DTextLabel(actor_label_sb[playerid]);
            actor_label_sb[playerid] = Text3D:INVALID_3DTEXT_ID;
        }
    }

    if(id_veh >= 0 && id_veh < MAX_SB_VEH)
    {
        vehicle_sb[id_veh][ST_PLAYER_SB] = -1;
        vehicle_sb[id_veh][ST_ID_VEH_SB] = 0;
        vehicle_sb[id_veh][ST_ID_SRV_SB] = -1;
        vehicle_sb[id_veh][ST_ENGINE] = false;
        vehicle_sb[id_veh][ST_TRANSMISSION] = false;
        vehicle_sb[id_veh][ST_BODY] = false;
        vehicle_sb[id_veh][ST_WHEELS] = false;
        vehicle_sb[id_veh][ST_ELECTRONICS] = false;
        vehicle_sb[id_veh][ST_INTERIOR] = false;
    }

    player_veh_id_sb{playerid} = -1;
    return 1;
}

stock NewIdVehSb()
{
    for(new i = 0; i < MAX_SB_VEH; i++)
    {
        if(vehicle_sb[i][ST_PLAYER_SB] == -1) return i;
    }
    return -1;
}

// ================================================================
//  ИНИЦИАЛИЗАЦИЯ
// ================================================================

public OnGameModeInit()
{
    print("[KIRILL_SYSTEM] Work AvtoSborshik loaded");
    
    vihod_sb = CreateDynamicSphere(993.221069, 1000.334350, 1501.000000, 0.5);
    vhod_sb = CreateDynamicSphere(1873.612792, -127.811904, 15.695312, 1.0);

    sb_sphere = CreateDynamicSphere(994.231079, 1004.094543, 1501.000000, 2.5);

    sphere_item_sb = CreateDynamicSphere(1004.897766, 1000.668457, 1501.0, 2.7);
    CreateDynamic3DTextLabel("Podoydi chtoby vzat detal", 0xFFEE00FF, 1004.897766,1000.668457,1501.0, 5.0);
    CreateDynamic3DTextLabel("Vhod v ceh avtozavoda [Work AvtoSborshik]", 0xFFBB00FF, 1873.612792, -127.811904, 15.695312, 5.0);
    CreateDynamic3DTextLabel("Vyhod iz ceha avtozavoda [Work AvtoSborshik]", 0xFFBB00FF, 993.221069, 1000.334350, 1501.000000, 5.0);
    
    CreateDynamicSphere(999.391723, 1000.550903, 1501.000000, 1.4);
    CreateDynamicSphere(995.221984, 998.613891, 1501.000000, 1.0);
    CreateDynamicSphere(996.590942, 998.667053, 1501.000000, 1.4);
    CreateDynamicSphere(997.500000, 999.500000, 1501.000000, 1.4);
    CreateDynamicSphere(998.500000, 1001.500000, 1501.000000, 1.4);
    CreateDynamicSphere(1000.000000, 1002.000000, 1501.000000, 1.4);

    for(new i = 0; i < MAX_SB_VEH; i++)
    {
        vehicle_sb[i][ST_PLAYER_SB] = -1;
        vehicle_sb[i][ST_ID_SRV_SB] = -1;
        vehicle_sb[i][ST_ID_VEH_SB] = 0;
        vehicle_sb[i][ST_ENGINE] = true;
        vehicle_sb[i][ST_TRANSMISSION] = true;
        vehicle_sb[i][ST_BODY] = true;
        vehicle_sb[i][ST_WHEELS] = true;
        vehicle_sb[i][ST_ELECTRONICS] = true;
        vehicle_sb[i][ST_INTERIOR] = true;
    }
    
    #if defined m_OnGameModeInit
        return m_OnGameModeInit();
    #else
        return 0;
    #endif
}

#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit m_OnGameModeInit
#if defined m_OnGameModeInit
    forward m_OnGameModeInit();
#endif

// ================================================================
//  ВХОД ИГРОКА
// ================================================================

public OnPlayerConnect(playerid)
{
    player_job_active_sb{playerid} = false;
    p_load_active_sb{playerid} = false;
    item_sb{playerid} = 0;
    player_veh_id_sb{playerid} = -1;
    actor_player_sb[playerid] = INVALID_ACTOR_ID;
    actor_label_sb[playerid] = Text3D:INVALID_3DTEXT_ID;
    
    #if defined m_OnPlayerConnect
        return m_OnPlayerConnect(playerid);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect m_OnPlayerConnect
#if defined m_OnPlayerConnect
    forward m_OnPlayerConnect(playerid);
#endif

// ================================================================
//  ВЫХОД ИГРОКА
// ================================================================

public OnPlayerDisconnect(playerid, reason)
{
    if(p_load_active_sb{playerid}) DeleteVehicleSb(playerid, 1);
    player_job_active_sb{playerid} = false;
    p_load_active_sb{playerid} = false;
    
    if(actor_player_sb[playerid] != INVALID_ACTOR_ID)
    {
        DestroyActor(actor_player_sb[playerid]);
        actor_player_sb[playerid] = INVALID_ACTOR_ID;
    }
    
    if(actor_label_sb[playerid] != Text3D:INVALID_3DTEXT_ID)
    {
        Delete3DTextLabel(actor_label_sb[playerid]);
        actor_label_sb[playerid] = Text3D:INVALID_3DTEXT_ID;
    }
    
    #if defined m_OnPlayerDisconnect
        return m_OnPlayerDisconnect(playerid, reason);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect m_OnPlayerDisconnect
#if defined m_OnPlayerDisconnect
    forward m_OnPlayerDisconnect(playerid, reason);
#endif

// ================================================================
//  ВХОД В ЗОНЫ
// ================================================================

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == vhod_sb)
    {
        new world = GetPlayerWorld_SB(playerid);
        SetPlayerPosEx(playerid, 994.787597, 1000.367431, 1501.000000, 270.871093, 1, world);
        SCM(playerid, -1, ""SC" Vy zashli v ceh avtozavoda");
    }
    
    if(areaid == vihod_sb)
    {
        SetPlayerPosEx(playerid, 1872.091186, -128.175704, 15.695312, 116.325195, 0, 0);

        if(player_job_active_sb{playerid})
        {
            player_job_active_sb{playerid} = false;
            p_load_active_sb{playerid} = false;
            if(item_sb{playerid}) DeleteVehicleSb(playerid, 1);
            item_sb{playerid} = 0;
            SetPlayerSkinInit(playerid);
            SCM(playerid, -1,""USC" Vy zakonchili smenu");
        }
    }
    
    if(areaid == sb_sphere)
    {
        callcmd::yes_sb(playerid);
    }
    
    if(areaid == sphere_item_sb)
    {
        if(item_sb{playerid}) return SCM(playerid, -1, ""USC" U vas uzhe est detal");
        callcmd::menu_sb(playerid);
    }
    
    #if defined m_OnPlayerEnterDynamicArea
        return m_OnPlayerEnterDynamicArea(playerid, areaid);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea m_OnPlayerEnterDynamicArea
#if defined m_OnPlayerEnterDynamicArea
    forward m_OnPlayerEnterDynamicArea(playerid, areaid);
#endif

// ================================================================
//  ДИАЛОГИ
// ================================================================

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
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
                    if(p_load_active_sb{playerid}) return SCM(playerid, -1, ""USC" Snachala zakonchite sborku");

                    if(player_job_active_sb{playerid})
                    {
                        SCM(playerid, -1, ""SC" Vy zakonchili smenu");
                        player_job_active_sb{playerid} = false;
                        SetPlayerSkinInit(playerid);
                        SetPlayerVirtualWorld(playerid, 0);
                        
                        if(actor_player_sb[playerid] != INVALID_ACTOR_ID)
                        {
                            DestroyActor(actor_player_sb[playerid]);
                            actor_player_sb[playerid] = INVALID_ACTOR_ID;
                        }
                        
                        if(actor_label_sb[playerid] != Text3D:INVALID_3DTEXT_ID)
                        {
                            Delete3DTextLabel(actor_label_sb[playerid]);
                            actor_label_sb[playerid] = Text3D:INVALID_3DTEXT_ID;
                        }
                        
                        if(player_veh_id_sb{playerid} != -1) DeleteVehicleSb(playerid, 0);
                    }
                    else
                    {
                        player_job_active_sb{playerid} = true;
                        SCM(playerid, -1, ""SC" Vy nachali smenu na avtozavode");
                        SCM(playerid, -1, ""SC" Teper vyberite \"Vzyat avto na sborku\"");
                        SetPlayerSkin(playerid, 206);
                        
                        new world = GetPlayerWorld_SB(playerid);
                        SetPlayerVirtualWorld(playerid, world);
                        
                        // Создаем актера
                        if(actor_player_sb[playerid] != INVALID_ACTOR_ID)
                        {
                            DestroyActor(actor_player_sb[playerid]);
                        }
                        
                        actor_player_sb[playerid] = CreateActor(206, 994.231079, 1004.094543, 1501.000000, 222.366333);
                        SetActorVirtualWorld(actor_player_sb[playerid], world);
                        SetActorInvulnerable(actor_player_sb[playerid], true);
                        
                        if(actor_label_sb[playerid] != Text3D:INVALID_3DTEXT_ID)
                        {
                            Delete3DTextLabel(actor_label_sb[playerid]);
                        }
                        
                        actor_label_sb[playerid] = Create3DTextLabel("Mehanik\nPodoydi dlya vzaimodeystviya", 0x00FF00FF, 
                            994.231079, 1004.094543, 1501.000000 + 1.5, 10.0, world, 1);
                    }

                    callcmd::yes_sb(playerid);
                }
                case 1:
                {
                    if(!player_job_active_sb{playerid}) return SCM(playerid, -1, ""USC" Snachala nachnite smenu!");
                    if(p_load_active_sb{playerid}) return SCM(playerid, -1, ""USC" Snachala zakonchite sborku");

                    new id = NewIdVehSb();
                    if(id == -1) return SCM(playerid, -1, ""USC" Vse mesta zanyaty!");

                    new veh_id = model_veh_sb[random(10)];
                    new veh = CreateVehicle(veh_id, 996.179199, 1000.484130, 1501.000000, 270.0, random(250), random(250), -1);

                    new world = GetPlayerWorld_SB(playerid);
                    WelsiSb(playerid, id, veh, veh_id);

                    format(text, sizeof (text), "Avtomobil ozhidaet sborki");
                    SCM(playerid, -1, text);

                    player_veh_id_sb{playerid} = id;
                    p_load_active_sb{playerid} = true;
                    SetVehicleVirtualWorld(vehicle_sb[id][ST_ID_SRV_SB], world);
                    LinkVehicleToInterior(vehicle_sb[id][ST_ID_SRV_SB], 1);

                    callcmd::yes_sb(playerid);
                }
                case 2:
                {
                    if(!p_load_active_sb{playerid}) return SCM(playerid, -1, ""USC" Snachala nachnite sborku!");

                    new id_veh = player_veh_id_sb{playerid};

                    format
                    (
                        text, sizeof text, 
                        "Informaciya ob avtomobile\n\
                        {FFFFFF}Dvigatel: %s\n\
                        {FFFFFF}Korobka peredach: %s\n\
                        {FFFFFF}Kuzov: %s\n\
                        {FFFFFF}Kolesa: %s\n\
                        {FFFFFF}Elektronika: %s\n\
                        {FFFFFF}Salon: %s",
                        vehicle_sb[id_veh][ST_ENGINE]  ? ("{FF0000}Trebuyetsya") : ("{00FF15}Ustanovlen"),
                        vehicle_sb[id_veh][ST_TRANSMISSION]  ? ("{FF0000}Trebuyetsya") : ("{00FF15}Ustanovlena"),
                        vehicle_sb[id_veh][ST_BODY]  ? ("{FF0000}Trebuyetsya") : ("{00FF15}Ustanovlen"),
                        vehicle_sb[id_veh][ST_WHEELS]  ? ("{FF0000}Trebuyutsya") : ("{00FF15}Ustanovleny"),
                        vehicle_sb[id_veh][ST_ELECTRONICS]  ? ("{FF0000}Trebuyetsya") : ("{00FF15}Ustanovlena"),
                        vehicle_sb[id_veh][ST_INTERIOR]  ? ("{FF0000}Trebuyetsya") : ("{00FF15}Ustanovlen")
                    );

                    Dialog
                    (
                        playerid, -1, DSM,
                        "Informaciya ob avtomobile",
                        text, 
                        "Vyyty", ""
                    );
                }
                case 3:
                {
                    new id_veh = player_veh_id_sb{playerid}, bool:c_work = false;

                    if(GetSbAuto(id_veh) != 6) c_work = true;
                    
                    if(c_work)
                    {
                        SCM(playerid, -1, ""USC" Avtomobil sobran ne polnostyu! Oplata ne poluchena");
                        DeleteVehicleSb(playerid);    
                    }
                    else
                    {
                        new money = (random(50000)*2) + 2500 * GetSbAuto(id_veh);
                        GivePlayerMoneyEx(playerid, money);
                        SCM(playerid, -1, ""SC" Vy uspeshno sobrali avtomobil! Zarabotali {00FF00}%d$", money);
                        DeleteVehicleSb(playerid);    
                    }
                    player_veh_id_sb{playerid} = -1;
                    p_load_active_sb{playerid} = false;

                    callcmd::yes_sb(playerid);
                }
            }
        }
    }
    
    if(dialogid == 1298)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0: SbCheckPoint(playerid, 1);
                case 1: SbCheckPoint(playerid, 2);
                case 2: SbCheckPoint(playerid, 3);
                case 3: SbCheckPoint(playerid, 4);
                case 4: SbCheckPoint(playerid, 5);
                case 5: SbCheckPoint(playerid, 6);
            }
        }
    }  
    
    #if defined spd_OnDialogResponse
        return spd_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #endif
    return 0;
}

#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse spd_OnDialogResponse
#if defined spd_OnDialogResponse
    forward spd_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

// ================================================================
//  ЧЕКПОИНТЫ
// ================================================================

stock SbCheckPoint(playerid, item)
{
    new text[45];

    if(item_sb{playerid}) return SCM(playerid, -1, ""USC" U vas uzhe est detal");
        
    item_sb{playerid} = item;
    format(text, sizeof text, "Vy vzyali {FFFF00}%s", name_item_sb[item - 1]);
    SCM(playerid, -1, text);
    
    switch(item)
    {
        case 1: SetPlayerCheckpoint(playerid, 999.391723,1000.550903,1501.000000, 1.4);
        case 2: SetPlayerCheckpoint(playerid, 995.221984,998.613891,1501.000000, 1.0);
        case 3: SetPlayerCheckpoint(playerid, 996.590942,998.667053,1501.000000, 1.4);
        case 4: SetPlayerCheckpoint(playerid, 997.500000,999.500000,1501.000000, 1.4);
        case 5: SetPlayerCheckpoint(playerid, 998.500000,1001.500000,1501.000000, 1.4);
        case 6: SetPlayerCheckpoint(playerid, 1000.000000,1002.000000,1501.000000, 1.4);
    }
    
    SetPVarInt(playerid, "CheckPSb", 1);

    return 1;
}

forward Sb_UnfreezePlayer(playerid);
public Sb_UnfreezePlayer(playerid)
{
    TogglePlayerControllable(playerid, 1);
    ClearAnimations(playerid);
    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(GetPVarInt(playerid, "CheckPSb"))
    {
        new item = item_sb{playerid}, veh_id = player_veh_id_sb{playerid};

        DisablePlayerCheckpoint(playerid);
        ApplyAnimation(playerid, "OTB", "betslp_loop", 4.1, 1, 0, 0, 1, 0);
        TogglePlayerControllable(playerid, 0);
        SetTimerEx("Sb_UnfreezePlayer", 3000, false, "i", playerid);

        switch(item)
        {
            case 0: SCM(playerid, -1, ""SC" ERROR");
            case 1:
            {
                if(!vehicle_sb[veh_id][ST_ENGINE]) 
                {
                    SCM(playerid, -1, ""USC" Dvigatel uzhe ustanovlen");
                    item_sb{playerid} = 0;
                }
                else
                {
                    item_sb{playerid} = 0;
                    SCM(playerid, -1, ""SC" Vy ustanovili dvigatel.");
                    vehicle_sb[veh_id][ST_ENGINE] = false;
                }
            }
            case 2:
            {
                if(!vehicle_sb[veh_id][ST_TRANSMISSION]) 
                {
                    SCM(playerid, -1, ""USC" Korobka peredach uzhe ustanovlena");
                    item_sb{playerid} = 0;
                }
                else
                {
                    item_sb{playerid} = 0;
                    SCM(playerid, -1, ""SC" Vy ustanovili korobku peredach.");
                    vehicle_sb[veh_id][ST_TRANSMISSION] = false;
                }
            }
            case 3:
            {
                if(!vehicle_sb[veh_id][ST_BODY]) 
                {
                    SCM(playerid, -1, ""USC" Kuzov uzhe ustanovlen");
                    item_sb{playerid} = 0;
                }
                else
                {
                    item_sb{playerid} = 0;
                    SCM(playerid, -1, ""SC" Vy ustanovili kuzov.");
                    vehicle_sb[veh_id][ST_BODY] = false;
                }
            }
            case 4:
            {
                if(!vehicle_sb[veh_id][ST_WHEELS]) 
                {
                    SCM(playerid, -1, ""USC" Kolesa uzhe ustanovleny");
                    item_sb{playerid} = 0;
                }
                else
                {
                    item_sb{playerid} = 0;
                    SCM(playerid, -1, ""SC" Vy ustanovili kolesa.");
                    vehicle_sb[veh_id][ST_WHEELS] = false;
                }
            }
            case 5:
            {
                if(!vehicle_sb[veh_id][ST_ELECTRONICS]) 
                {
                    SCM(playerid, -1, ""USC" Elektronika uzhe ustanovlena");
                    item_sb{playerid} = 0;
                }
                else
                {
                    item_sb{playerid} = 0;
                    SCM(playerid, -1, ""SC" Vy ustanovili elektroniku.");
                    vehicle_sb[veh_id][ST_ELECTRONICS] = false;
                }
            }
            case 6:
            {
                if(!vehicle_sb[veh_id][ST_INTERIOR]) 
                {
                    SCM(playerid, -1, ""USC" Salon uzhe ustanovlen");
                    item_sb{playerid} = 0;
                }
                else
                {
                    item_sb{playerid} = 0;
                    SCM(playerid, -1, ""SC" Vy ustanovili salon.");
                    vehicle_sb[veh_id][ST_INTERIOR] = false;
                }
            }
        }
        DeletePVar(playerid, "CheckPSb");
    }
    
    #if defined m_OnPlayerEnterCheckpoint
        return m_OnPlayerEnterCheckpoint(playerid);
    #else
        return 0;
    #endif
}

#if defined _ALS_OnPlayerEnterCheckpoint
    #undef OnPlayerEnterCheckpoint
#else
    #define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint m_OnPlayerEnterCheckpoint
#if defined m_OnPlayerEnterCheckpoint
    forward m_OnPlayerEnterCheckpoint(playerid);
#endif

// ================================================================
//  КОМАНДЫ
// ================================================================

CMD:yes_sb(playerid)
{
    if(!IsPlayerInDynamicArea(playerid, sb_sphere)) return SCM(playerid, -1, ""SC" Vy slishkom daleko");

    Dialog
    (
        playerid, 1299, DSL, 
        "AVTOZAVOD | Menu",
        "1. Nachat/zakonchit smenu\n"\
        "2. Vzyat avto na sborku\n"\
        "3. Informaciya ob avtomobile\n"\
        "4. Zavershit sborku",
        "Dalee", "Nazad"
    );
    return 1;
}

CMD:menu_sb(playerid)
{
    if(item_sb{playerid}) return SCM(playerid, -1, ""USC" U vas uzhe est detal");
    if(!player_job_active_sb{playerid}) return SCM(playerid, -1, ""USC" Nachnite smenu");
    if(!p_load_active_sb{playerid}) return SCM(playerid, -1, ""USC" Snachala vozmit avto na sborku");

    Dialog
    (
        playerid, 1298, DSL,
        "Detali dlya sborki",
        ""SC" Dvigatel\n"\
        ""SC" Korobka peredach\n"\
        ""SC" Kuzov\n"\
        ""SC" Kolesa\n"\
        ""SC" Elektronika\n"\
        ""SC" Salon",
        "Vzyat", "Vyyty"
    );

    return 1;
}

// ================================================================
//  ФУНКЦИЯ РАНДОМА
// ================================================================

stock WelsiSb(playerid, id, srv_id, veh_id)
{
    for(new i = -1; i < random(3); i++)
    {
        switch(random(6))
        {
            case 0: vehicle_sb[id][ST_ENGINE] = true;
            case 1: vehicle_sb[id][ST_TRANSMISSION] = true;
            case 2: vehicle_sb[id][ST_BODY] = true;
            case 3: vehicle_sb[id][ST_WHEELS] = true;
            case 4: vehicle_sb[id][ST_ELECTRONICS] = true;
            case 5: vehicle_sb[id][ST_INTERIOR] = true;
        }
    }

    // Убеждаемся что все детали требуют установки
    if(!vehicle_sb[id][ST_ENGINE]) vehicle_sb[id][ST_ENGINE] = true;
    if(!vehicle_sb[id][ST_TRANSMISSION]) vehicle_sb[id][ST_TRANSMISSION] = true;
    if(!vehicle_sb[id][ST_BODY]) vehicle_sb[id][ST_BODY] = true;
    if(!vehicle_sb[id][ST_WHEELS]) vehicle_sb[id][ST_WHEELS] = true;
    if(!vehicle_sb[id][ST_ELECTRONICS]) vehicle_sb[id][ST_ELECTRONICS] = true;
    if(!vehicle_sb[id][ST_INTERIOR]) vehicle_sb[id][ST_INTERIOR] = true;

    vehicle_sb[id][ST_PLAYER_SB] = playerid;
    vehicle_sb[id][ST_ID_VEH_SB] = veh_id;
    vehicle_sb[id][ST_ID_SRV_SB] = srv_id;

    return 1;
}