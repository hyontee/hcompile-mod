static
	Float: SeatDownX[MAX_SEATDOWN],
	Float: SeatDownY[MAX_SEATDOWN],
	Float: SeatDownZ[MAX_SEATDOWN],
	Float: SeatDownA[MAX_SEATDOWN],
    SeatInterior[MAX_SEATDOWN],
    SeatVW[MAX_SEATDOWN],
	TOTALSEATDOWNS;


 
static Float:Cam_Coordinates[][6] = {
{1958.0890,1173.6450,1148.3369, /* CAM LOCK*/ 1954.9275,1169.3160,1146.4017}
};


\
static Cam_Params[][2] = { // VW | INT
    {0,0}
};
SeatDown_OnGameModeInit()
{
    mysql_tquery(
        dbHandle, "SELECT * FROM `s_seatdowns`", #OnLoadSeatDownData\
    );
    return;
}
stock CamOn(playerid, listitem)
{ 
    SetPlayerPosAC(playerid, Cam_Coordinates[listitem][0],Cam_Coordinates[listitem][1],Cam_Coordinates[listitem][2]+5,Cam_Params[listitem][0],Cam_Params[listitem][1]);

    TogglePlayerControllable(playerid, false); 

    SendClientMessage(playerid, -1, "Нажмите "colserver"'ALT'"colwhi", чтобы выйти из слежки. Используйте: "colserver"/cammenu"colwhi", что бы открыть список камер");

    SetPlayerCameraPos(playerid,Cam_Coordinates[listitem][0],Cam_Coordinates[listitem][1],Cam_Coordinates[listitem][2]);
    SetPlayerCameraLookAt(playerid,Cam_Coordinates[listitem][3],Cam_Coordinates[listitem][4],Cam_Coordinates[listitem][5]);
    for(new i; i < sizeof(CamsTD); i ++) TextDrawShowForPlayer(playerid, CamsTD[i]);
    SetPVarInt(playerid, #LOCKATCAM, true);
}
stock CamMenu(playerid, type = 0)
{
    if (type == 1)
    {
        ClearAnimations(playerid);
        SetPVarInt(playerid, #PlayerAnimation ,0);
        TextDrawHideForPlayer(playerid, InfoAnimDraw);
        SetCameraBehindPlayer(playerid);
        DeletePVar(playerid, #LOCKATCAM);
        
        for(new i; i < sizeof(CamsTD); i ++) TextDrawHideForPlayer(playerid, CamsTD[i]);
        TogglePlayerControllable(playerid, true);

        DeletePVar(playerid,#LOCKATCAM);
    
        SetPlayerPosAC(playerid,892.8330,1580.4083,1087.7120,1,8);
        setFreezePlayerForTime(playerid, 3);

        return true;
    }
    return ShowPlayerDialog(playerid, D_CAM_LIST, DIALOG_STYLE_LIST, "Видеокамеры:", "Камера №1", "Посмотреть", "Закрыть");
}

forward OnLoadSeatDownData();
public OnLoadSeatDownData()
{
    new 
        time = GetTickCount(), 
        rows;
    cache_get_row_count(rows);
    if (!rows) return print("[Загрузка ...] Данные из OnLoadSeatDownData не получены!");
    for(new i = 1; i <= rows; i++)
    {
        cache_get_value_name_float(i-1, "seat_x", SeatDownX[i]);
        cache_get_value_name_float(i-1, "seat_y", SeatDownY[i]);
        cache_get_value_name_float(i-1, "seat_z", SeatDownZ[i]);
        cache_get_value_name_float(i-1, "seat_a", SeatDownA[i]);
        cache_get_value_name_int(i-1, "seat_vw", SeatVW[i]);
        cache_get_value_name_int(i-1, "seat_int", SeatInterior[i]);
        CreateDynamic3DTextLabel(""colwhi"Сесть\n"colmaline"Нажмите: \"ALT\"", COLOR_SERVER, SeatDownX[i], SeatDownY[i], SeatDownZ[i], 0.5, .worldid = SeatVW[i], .interiorid = SeatInterior[i]);
        TOTALSEATDOWNS++;
    }
    printf("[Загрузка ...] Данные из OnLoadSeatDownData получены! Время: %d",GetTickCount() - time);
    return 1;
}

SeatDown_OnPlayerKeyStateChange(playerid, newkeys, oldkeys) 
{
    if (GetPlayerState(playerid) != PLAYER_STATE_ONFOOT) 
		return false;
    if (newkeys & 1024 && !(oldkeys & 1024))
    //if (newkeys == 1024)//ALT
    {
        for(new i = 1; i <= TOTALSEATDOWNS; i++)
        {
            if (IsPlayerInRangeOfPoint(playerid, 0.5, SeatDownX[i], SeatDownY[i], SeatDownZ[i]) 
                && !GetPVarInt(playerid, #PlayerAnimation) 
                && GetPlayerVirtualWorld(playerid) == SeatVW[i] && GetPlayerInterior(playerid) == SeatInterior[i])
            {
               /* if (i == 44 || i == 45)
                {
                    if (!GetPVarInt(playerid, #LOCKATCAM))
                    {
                        CamMenu(playerid);
                    }
                    else return CamMenu(playerid, 1);
                }
                if (pInfo[playerid][pAdmin] != 0)
                {
                    SendMes(playerid,-1, "ID in For: %d | VW %d | INT  %i",i,GetPlayerVirtualWorld(playerid), GetPlayerInterior(playerid)); 
                }*/

				SetPlayerPos(playerid, SeatDownX[i], SeatDownY[i], SeatDownZ[i]);
				SetPlayerFacingAngle(playerid, SeatDownA[i]);

                ApplyAnimation(playerid, "PED", "SEAT_down", 4.1, 0, 0, 0, 1, 0, 1);
                TextDrawShowForPlayer(playerid, InfoAnimDraw);
			    SetPVarInt(playerid, #PlayerAnimation , 1);
            }
        }
    }
    return false;
} 
CMD:addseatdown(playerid)
{
	if (pInfo[playerid][pAdmin] < 7 || !pTemp[playerid][PlayerADostup]) return SendClientMessage(playerid, COLOR_GREY, !""colwarn"[Ошибка]"colwhi" Вам недоступна данная возможность"); 
	GetPlayerPos(playerid, SeatDownX[TOTALSEATDOWNS], SeatDownY[TOTALSEATDOWNS], SeatDownZ[TOTALSEATDOWNS]);
	GetPlayerFacingAngle(playerid, SeatDownA[TOTALSEATDOWNS]);
    SeatVW[TOTALSEATDOWNS] = GetPlayerVirtualWorld(playerid);
    SeatInterior[TOTALSEATDOWNS] = GetPlayerInterior(playerid);
    new 
        query_[256];
	format(query_, sizeof query_, "INSERT INTO `s_seatdowns` (`seat_x`, `seat_y`, `seat_z`, `seat_a`, `seat_vw`, `seat_int`) values ('%f', '%f', '%f', '%f', '%d', '%d')", 
        SeatDownX[TOTALSEATDOWNS], SeatDownY[TOTALSEATDOWNS], SeatDownZ[TOTALSEATDOWNS], SeatDownA[TOTALSEATDOWNS], SeatVW[TOTALSEATDOWNS], SeatInterior[TOTALSEATDOWNS]);
	mysql_tquery(dbHandle, query_, "", "");

	SendMes(playerid, COLOR_SERVER, "Вы успешно создали место посадки #%d", TOTALSEATDOWNS);

	CreateDynamic3DTextLabel(""colwhi"Сесть\n"colmaline"Нажмите: \"ALT\"", COLOR_SERVER, 
        SeatDownX[TOTALSEATDOWNS], 
        SeatDownY[TOTALSEATDOWNS], 
        SeatDownZ[TOTALSEATDOWNS], 0.5, 
        .worldid = SeatVW[TOTALSEATDOWNS], .interiorid = SeatInterior[TOTALSEATDOWNS]
    ); 
	TOTALSEATDOWNS++;
	return 1;
}