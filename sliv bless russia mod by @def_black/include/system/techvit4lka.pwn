

#include <a_samp>
#include "../include/streamer.inc"
#include <brnotification>
#define DIALOG_TUNING_VIT4LKA 67677
#define DIALOG_NITRO_VIT4LKA 59335
#define DIALOG_POKUPKA_DRIFT 42426
#define DIALOG_POKUPKA_LAUNCH 42427 
new vehicleid;
new money;

#define SCM 											SendClientMessage
// #define SC              "{ffff00}| {ffffff}"
// #define USC             "{ff2400}| {ffffff}"
#define 	DSM		DIALOG_STYLE_MSGBOX
#define 	DSL		DIALOG_STYLE_LIST
#define CN              "{ffff00}| {ffffff}"




public OnGameModeInit()
{
    
    CreateDynamic3DTextLabel("{FFFF00}*ТЕХНИЧЕСКИЙ ЦЕНТР*\n{ffffff}Государственный Бизнес\n  \n{DCDCDC}[ Нажмите 'гудок' чтобы продолжить ]", -1, -419.773406,1004.043273,14.149044, 9.0);
    
    #if defined tech_OnGameModeInit
        return tech_OnGameModeInit();
    #else
        return 0;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit tech_OnGameModeInit
#if defined tech_OnGameModeInit
    forward tech_OnGameModeInit();
#endif




public OnPlayerKeyStateChange(playerid, newkeys, oldkeys)
{
	if(newkeys == KEY_CROUCH)
    {
       if(IsPlayerInRangeOfPoint(playerid, 5.0, -419.773406,1004.043273,12.149044))
       {
          if(!IsPlayerInVehicle(playerid, GetPlayerOwnableCar(playerid))) return SendClientMessage(playerid, -1, ""USC"Вы должны быть за рулем своего автомобиля");
		  new vehicleID = GetPlayerVehicleID(playerid);
		  
          new veh = GetPlayerOwnableCar(playerid);
          SetVehiclePos(veh, 996.368164,999.465759,1001.791540);
                    SetVehicleZAngle(veh, 273.919586);
          SetVehicleVirtualWorld(veh, vehicleID);
          LinkVehicleToInterior(veh, 1);
          SetPlayerInterior(playerid,1);
          
          SetPlayerVirtualWorld(playerid, vehicleID);
 
          SetPlayerCameraPos(playerid, 1001.483154,1002.271240,1000.906738);
	  	          SetPlayerCameraLookAt(playerid, 997.090454,999.934204,1001.398864);
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	SendClientMessage(playerid, -1, "");
	TogglePlayerControllable(playerid, false);
	DialogTexCentrik(playerid);
	

          
          HideHud(playerid);
						TogglePlayerHudElement(playerid, HUD_ELEMENT_CHAT, HUD_ELEMENT_HIDE);
						
		
        }
     }
    #if defined technic_OnPlayerKeyStateChange
        return technic_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerKeyStateChange
    #undef OnPlayerKeyStateChange
#else
    #define _ALS_OnPlayerKeyStateChange
#endif
#define OnPlayerKeyStateChange stage_OnPlayerKeyStateChange
#if defined technic_OnPlayerKeyStateChange
    forward technic_OnPlayerKeyStateChange(playerid, newkeys, oldkeys);
#endif


stock ViezdTex(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
        
    SetPlayerPos(playerid,-413.453979,1026.380371,13.042777);
    SetPlayerVirtualWorld(playerid, 0);
    SetPlayerInterior(playerid,0);
              
    SetVehiclePos(vehicleid, -413.453979,1026.380371,12.042777);
    SetVehicleZAngle(vehicleid, 356.280181);
    SetVehicleVirtualWorld(vehicleid, 0);
    LinkVehicleToInterior(vehicleid,0);
          
    PutPlayerInVehicle(playerid, vehicleid, 0);
          
	SetCameraBehindPlayer(playerid);
	TogglePlayerControllable(playerid, true);
    ShowHud(playerid);
    return 1;
}

stock DialogTexCentrik(playerid)
{
 ShowPlayerDialog(playerid, DIALOG_TUNING_VIT4LKA, DIALOG_STYLE_TABLIST_HEADERS,
    "{CA5757}Технический Центр {FFFFFF}| Тюнинг",
    "№\tТюнинг\tСтоимость\tДействие\n"\
    "{CA5757}1\t{FF9500}Установка «Drift»\t{8EF674}3.000.000\t{DCDCDC}[ приобрести ]\n"\
    "{CA5757}2\t{FF9500}Установка «Nitro»\t{8EF674}от 500.000\t{DCDCDC}[ продолжить ]\n"\
    "{CA5757}3\t{FF9500}Установка «Launch-C»\t{FFFF00}200 (BC)\t{DCDCDC}[ приобрести ]",
    "Продолжить", "Выехать");
    return 1;
}

stock DialogPokupkaDrift(playerid)
{
                                Dialog
								(
									playerid, DIALOG_POKUPKA_DRIFT, DIALOG_STYLE_MSGBOX,
									"{CA5757}Подтверждение покупки {FFFFFF}| Тех. Центр",
									"{FFFFFF}Вы действительно хотите приобрести\n"\
									"данную {FFFF00}модификацию {FFFFFF}для вашего автомобиля?",
									"Да", "Назад"
								);
								return 1;
} 								

stock DialogPokupkaLaunch(playerid)
{
                                Dialog
								(
									playerid, DIALOG_POKUPKA_LAUNCH, DIALOG_STYLE_MSGBOX,
									"{CA5757}Подтверждение покупки {FFFFFF}| Тех. Центр",
									"{FFFFFF}Вы действительно хотите приобрести\n"\
									"данную {FFFF00}модификацию {FFFFFF}для вашего автомобиля?",
									"Да", "Назад"
								);
								return 1;
} 								

stock buydrift(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    SetVehicleDriftForPlayerFix(playerid, vehicleid, 1);

    vInfo[vehicleid][vDrift] = true;
    vInfo[vehicleid][vDriftActive] = true;

         new fmt_text[256],
    idx = GetPVarInt(playerid, "ownablecar_id");
	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET drift_mode='1'  WHERE id='%d' LIMIT 1", idx);
	mysql_query(mysql, fmt_text, false);
	GivePlayerMoneyEx(playerid, -3000000);

    return 1;
}

stock buylaunch(playerid)
{
    new vehicleid = GetPlayerOwnableCar(playerid);
    vInfo[vehicleid][vLaunchControl] = true;
         new fmt_text[256],
    idx = GetPVarInt(playerid, "ownablecar_id");
	mysql_format(mysql, fmt_text, sizeof fmt_text, "UPDATE ownable_cars SET launch_tex='1'  WHERE id='%d' LIMIT 1", idx);
	mysql_query(mysql, fmt_text, false);
	GivePlayerDonateRub(playerid, -200);

    return 1;
}

stock DialogNitro(playerid)
{
 ShowPlayerDialog(playerid, DIALOG_NITRO_VIT4LKA, DIALOG_STYLE_TABLIST_HEADERS,
    "{CA5757}Нитро {FFFFFF}| Технический Центр",
    "№\tУровень\tСтоимость\n"\
    "{CA5757}1\t{FF9500}Нитро «2x»\t{8EF674}500.000\n"\
    "{CA5757}2\t{FF9500}Нитро «5x»\t{8EF674}800.000\n"\
    "{CA5757}3\t{FF9500}Нитро «10x»\t{8EF674}1.300.000",
    "Купить", "Назад");
    return 1;
}    