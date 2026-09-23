new pickup_school_exit, pickup_school_enter, pickup_menu_school;

new Float:coord_schl[][3] =
{
	{-2593.408447,79.121925,26.953451}, 	//0
	{-2624.222900,79.872016,27.004087}, 	//1
	{-2649.129150,80.268920,28.185577}, 	//2
	{-2684.257812,68.552200,26.948776}, 	//3
	{-2675.063232,32.557510,26.955087}, 	//4
	{-2657.036376,55.898746,26.953454}, 	//5
	{-2635.847656,37.167087,26.953464}, 	//6
	{-2635.495605,-3.737010,26.952901}, 	//7
	{-2647.028076,-28.913650,26.95289}, 	//8
	{-2666.689941,-50.260658,26.95289}, 	//9
	{-2682.049804,-24.417963,26.94907}, 	//10
	{-2658.508789,1.216217,26.952875}, 	//11
	{-2659.084716,-7.052532,26.952898}, 	//12
	{-2680.534179,-4.668541,26.952228}, 	//13
	{-2673.537353,11.691711,26.952566}, 	//14
	{-2651.226074,13.808450,26.952890}, 	//15
	{-2617.254638,13.945986,26.952898}, 	//16
	{-2584.382324,-1.032060,26.952896}, 	//17
	{-2586.141357,-43.807758,26.95289}, 	//18
	{-2603.484863,-50.674919,26.95289}, 	//19
	{-2627.703369,-42.187068,26.95288}, 	//20
	{-2627.970214,-5.956931,26.952886}, 	//21
	{-2653.480957,19.217487,26.952888}, 	//22
	{-2687.668212,4.162703,26.952230 }, 	//23
	{-2682.927001,-51.778251,26.94927}, 	//24
	{-2646.785156,-56.833854,26.95290}, 	//25
	{-2588.934814,-56.879058,26.95290}, 	//26
	{-2576.078613,-33.327140,26.95504}, 	//27
	{-2574.316894,-6.610868,26.955455}, 	//28
	{-2570.116455,-18.681797,26.95450},	//29
	{-2589.927734,18.731224,26.952899}, 	//30
	{-2613.367675,20.692348,26.952892}, 	//31		
	{-2629.520019,41.861701,26.953468}, 	//32
	{-2622.013183,65.461280,26.956443}, 	//33
	{-2596.214355,68.220497,26.953464},	//34
	{-2574.240722,97.129135,26.955047}, 	//35
	{-2545.423583,98.293479,26.846794}	//36		
};

enum TEST_STRUCT
{
    ts_ordert[184],
    ts_answers[284],
    ts_response,
};

new test_aschool[5][TEST_STRUCT] =
{
    {
        "1. На равнозначном перекрестке вы:",
        "1) Пропускаете того, кто слева.\n\
        2) Пропускаете того, кто справа.\n\
        3) Проезжаете первым.", 
        1 
    },
    {
        "2. Что главнее на перекрестке?",
        "1) Знак \"Главная дорога\".\n\
        2) Светофор.\n\
        3) Регулировщик.",
        2
    },
    {
        "3. Вы должны пропустить пешехода:",
        "1) Только если он уже на проезжей части.\n\
        2) Всегда, как только он ступил на \"зебру\"\n\
        3) Только по сигналу светофора.",
        1
    },
    {
        "4. Вы едете по главной дороге. Справа по второстепенной подъезжает машина. Вы:",
        "1) Пропускаете её (помеха справа).\n\
        2) Едете первым (вы на главной).\n\
        3) Пропускаете, если она быстрее.", 
        1
    },
    {
        "5. Загорелся желтый свет. Ваши действия:",
        "1) Ускориться.\n"\
        "2) Остановиться, если можно сделать это безопасно.\n"\
        "3) Продолжить движение.",
        1
    }
};

public:EndSchoolAuto(playerid)
{
	if(GetPlayerVehicleID(playerid) == GetPVarInt(playerid, "ID_VEH_SCHL")) return 0;
	
	if(GetPVarInt(playerid, "ID_VEH_SCHL")) DestroyVehicle(GetPVarInt(playerid, "ID_VEH_SCHL"));
	SetPlayerData(playerid, P_DRIVING_LIC, 0);
	SetPlayerPosEx(playerid, -2560.726562,37.840160,27.875736,175.589385, 0, 0);
	SCM(playerid, -1, "{ff2400}| {ffffff} Вы провалили экзамен");
	return 1;
}

public OnGameModeInit()
{
  
    CreateDynamicPickup(1318, 23, -605.493591,-308.612762,798.981994, 1);
    CreateDynamicPickup(1318, 23, -606.515686,-291.148193,798.976745, 1);
    
    pickup_school_enter = CreateDynamicSphere(-2561.821777,40.846996,27.879764, 2.0);
    pickup_school_exit = CreateDynamicSphere(-605.493591,-308.612762,798.981994, 1.0);
    pickup_menu_school = CreateDynamicSphere(-606.515686,-291.148193,798.976745, 2.0);
    #if defined as_OnGameModeInit
        return as_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit as_OnGameModeInit
#if defined as_OnGameModeInit
    forward as_OnGameModeInit();
#endif


public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 22220)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    Dialog (
                        playerid, -1, DIALOG_STYLE_MSGBOX, 
                        "Теория",
                        "1. Помеха справа: На равнозначном перекрестке (где нет знаков и светофора) пропускай того, кто справа\n\
                        2. Приоритеты: Регулировщик ? Светофор ? Знаки ? \"Помеха справа\"\n\
                        3. Главное: Пропускай пешеходов на зебре и спецтранспорт с мигалкой и сиреной",
                        "Прочитано", ""
                    );
                }
                case 1:
                {
                    Dialog
                    (
                        playerid, 22210, DIALOG_STYLE_LIST, 
                        test_aschool[0][ts_ordert],
                        test_aschool[0][ts_answers],
                        "Выбрать", "Закончить"
                    );
                    
                    SetPVarInt(playerid, "point_aschool", 1);
                }
            }
        }
    }
            if(dialogid == 22210)
        {
            if(!response)
            {
                DeletePVar(playerid, "point_aschool");
                SendClientMessage(playerid, -1, "Вы закончили тест");
                return 1;
            }

            new point = GetPVarInt(playerid, "point_aschool");

            if(listitem == test_aschool[point-1][ts_response]) point ++;
            else {
                DeletePVar(playerid, "point_aschool");
                SendClientMessage(playerid, -1, "Вы ответили не правильно. Тест закончен");
                return 1;
            }

            if(point == 6){
                new veh_id;
                veh_id = CreateVehicle(411, -2585.802001,32.248634,26.953458,1.187950, 3, 3, false);

                SetPlayerPos(playerid, -2585.802001,32.248634,26.953458);

                SetPlayerInterior(playerid, 0);
                SetPlayerVirtualWorld(playerid, playerid+3);

                SetVehicleVirtualWorld(veh_id, GetPlayerVirtualWorld(playerid));
                SetPVarInt(playerid, "ID_VEH_SCHL", veh_id);

                SetPlayerData(playerid, P_DRIVING_LIC, 1);

                SCM(playerid, -1, "{ffff00}| {ffffff} Вы начали экзамен!");
                SetPVarInt(playerid, "ID_CHECKP", 1);

                SetPlayerRaceCheckpoint(playerid, 0, coord_schl[0][0], coord_schl[0][1], coord_schl[0][2], coord_schl[1][0], coord_schl[1][1], coord_schl[1][2], 5.0);
                PutPlayerInVehicle(playerid, veh_id, 0);
            } 
            else {
                Dialog
                (
                    playerid, 22210, DIALOG_STYLE_LIST, 
                    test_aschool[point-1][ts_ordert],
                    test_aschool[point-1][ts_answers],
                    "Выбрать", "Закончить"
                );
                
                SetPVarInt(playerid, "point_aschool", point);   
            }
        }

    #if defined as_OnDialogResponse
    return as_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse as_OnDialogResponse
#if defined as_OnDialogResponse
forward as_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif


public OnPlayerExitVehicle(playerid, vehicleid)
{
	if(IsPlayerDriver(playerid))
	{
		if(vehicleid == GetPVarInt(playerid, "ID_VEH_SCHL"))
		{
			SetTimerEx("EndSchoolAuto", 30000, false, "i", playerid);
			SendClientMessage(playerid, 0xFF6600FF, "У Вас есть 30 секунд чтобы вернуться в учебный транспорт");
		}
	}
    #if defined as_OnPlayerExitVehicle
        return as_OnPlayerExitVehicle(playerid, vehicleid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerExitVehicle
    #undef OnPlayerExitVehicle
#else
    #define _ALS_OnPlayerExitVehicle
#endif
#define OnPlayerExitVehicle as_OnPlayerExitVehicle
#if defined as_OnPlayerExitVehicle
    forward as_OnPlayerExitVehicle(playerid, vehicleid);
#endif


public OnPlayerDisconnect(playerid, reason)
{
    if(GetPVarInt(playerid, "ID_VEH_SCHL") || GetPVarInt(playerid, "ID_CHECKP")) EndSchoolAuto(playerid);
    #if defined as_OnPlayerDisconnect
        return as_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect as_OnPlayerDisconnect
#if defined as_OnPlayerDisconnect
    forward as_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerEnterRaceCheckpoint(playerid)
{
	if(GetPVarInt(playerid, "ID_CHECKP"))
	{
		if(!IsPlayerDriver(playerid)) return SCM(playerid, -1, "{ffff00}| {ffffff} Вы должны быть в транспорте");

		new id = GetPVarInt(playerid, "ID_CHECKP");

		switch(id)
		{
			case 37:
			{
                new Float:heath;
                GetVehicleHealth(GetPVarInt(playerid, "ID_VEH_SCHL"), heath);
                
                if(heath <= 990.0) {
                    SetPlayerData(playerid, P_DRIVING_LIC, 0);
				    SetPlayerPosEx(playerid, -2560.726562,37.840160,27.875736,175.589385, 0, 0);
                    SendClientMessage(playerid, -1, "На машине нашли повреждения. Экзамен провален");
                    return 1;
                }

				DisablePlayerRaceCheckpoint(playerid);
				if(GetPVarInt(playerid, "ID_VEH_SCHL")) DestroyVehicle(GetPVarInt(playerid, "ID_VEH_SCHL"));
				new query[64];
				DeletePVar(playerid, "ID_CHECKP");
				DeletePVar(playerid, "ID_VEH_SCHL");
				SCM(playerid, -1, "{ff2400}| {ffffff} Вы успешно сдали на права");
				
				format(query, sizeof query, "UPDATE accounts SET driving_lic=%d WHERE id=%d LIMIT 1", GetPlayerData(playerid, P_DRIVING_LIC), GetPlayerAccountID(playerid));
				mysql_query(mysql, query, false);
                SetPlayerData(playerid, P_DRIVING_LIC, 1);
				SetPlayerPosEx(playerid, -2560.726562,37.840160,27.875736,175.589385, 0, 0);
			}
			case 36:
			{
				SetPVarInt(playerid, "ID_CHECKP", id + 1);
				DisablePlayerRaceCheckpoint(playerid);
				SetPlayerRaceCheckpoint(playerid, 1, coord_schl[id][0], coord_schl[id][1], coord_schl[id][2], 0.0, 0.0, 0.0, 5.0);
			}
			default:
			{
				new next_id_p = id + 1;
				DisablePlayerRaceCheckpoint(playerid);
				SetPVarInt(playerid, "ID_CHECKP", id + 1);
				SetPlayerRaceCheckpoint(playerid, 0, coord_schl[id][0], coord_schl[id][1], coord_schl[id][2], coord_schl[next_id_p][0], coord_schl[next_id_p][1],coord_schl[next_id_p][2], 5.0);
			}
		}
	}
	#if defined as_OnPlayerEnterRaceCP
		return as_OnPlayerEnterRaceCP(playerid);
	#else
	    return 1;
	#endif
}
#if defined _ALS_OnPlayerEnterRaceCP
    #undef OnPlayerEnterRaceCheckpoint
#else
    #define _ALS_OnPlayerEnterRaceCP
#endif
#if defined as_OnPlayerEnterRaceCP
	forward as_OnPlayerEnterRaceCP(playerid);
#endif
#define	OnPlayerEnterRaceCheckpoint as_OnPlayerEnterRaceCP

public OnPlayerEnterDynamicArea(playerid, areaid)
{
	if(areaid == pickup_school_enter)
	{
		SetPlayerPosEx(playerid, -603.999694,-309.670043,798.981994,264.666351, 1, 1);
		SCM(playerid, -1, "{ffff00}| {ffffff}Вы зашли в автошколу");
	}
	if(areaid == pickup_school_exit)
	{
		SetPlayerPosEx(playerid, -2560.726562,37.840160,27.875736,175.589385, 0, 0);
		SCM(playerid, -1, "{ffff00}| {ffffff}Вы вышли с автошколы");
	}
	if(areaid == pickup_menu_school)
	{
		if(!(GetPlayerData(playerid, P_DRIVING_LIC) < 1)) return SCM(playerid, -1, "{ff2400}| {ffffff} У вас есть права!");

		Dialog
		(
			playerid, 22220, DIALOG_STYLE_LIST, 
			"Автошкола | Сдача на права",
			"Прочитать теорию\n"\
			"Начать тест",
			"Оплатить", "Назад"
		);
	}

    #if defined as_OnPlayerEnterDynamicArea
        return as_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea as_OnPlayerEnterDynamicArea
#if defined as_OnPlayerEnterDynamicArea
    forward as_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif