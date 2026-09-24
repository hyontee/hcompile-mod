#if defined _USED_VEH_MARKET_INCLUDED
    #endinput
#endif
#define _USED_VEH_MARKET_INCLUDED

// Единый авторынок. Все личные автомобили и мотоциклы находятся в одном интерьере
// и одном виртуальном мире. Въезд не выставляет транспорт на продажу.

#define UVM_INTERIOR (1)
#define UVM_WORLD (101)

new uvm_enter_area[8];
new uvm_exit_area[8];
new uvm_foot_enter_area = -1;
new uvm_foot_exit_area[2];

new bool:uvm_inside[MAX_PLAYERS];

new Float:uvm_enter_pos[8][3] =
{
    {1970.957031,-546.201171,12.448518},
    {1963.993408,-546.201843,12.448415},
    {1956.899414,-546.201110,12.448528},
    {1949.680175,-546.201416,12.448480},
    {1942.985107,-546.201049,12.448537},
    {1935.941406,-546.203613,12.448143},
    {1992.953613,-546.202819,12.448265},
    {1985.818847,-546.201354,12.448490}
};

new Float:uvm_inside_spawn[2][4] =
{
    {441.655792,1000.270690,1001.0,268.121917},
    {441.001007,962.392883,1001.0,272.226806}
};

new Float:uvm_exit_inside[8][3] =
{
    {554.048034,1082.757690,1001.0},
    {562.782226,1018.124511,1001.0},
    {562.781677,962.899597,1001.0},
    {554.004638,917.241455,1001.0},
    {499.953247,917.398071,1001.0},
    {481.996002,953.842346,1001.0},
    {473.102172,1018.351440,1001.0},
    {481.970123,1082.759277,1001.0}
};

new Float:uvm_exit_outside[8][4] =
{
    {1984.905273,-510.499938,12.452824,10.0},
    {1977.895263,-510.500549,12.452918,10.0},
    {1971.000244,-510.500732,12.452945,10.0},
    {1963.805786,-510.500793,12.452955,10.0},
    {1956.793334,-510.500793,12.452955,10.0},
    {1950.178466,-510.500305,12.452880,10.0},
    {1942.700317,-510.500671,12.452937,10.0},
    {1935.951416,-510.499328,12.452730,10.0}
};

new Float:uvm_foot_inside[2][4] =
{
    {439.188537,982.508117,1001.0,262.025390},
    {561.245300,1001.142578,1001.0,1.617309}
};

new Float:uvm_foot_exit[2][3] =
{
    {437.272247,982.686950,1001.0},
    {562.727172,1001.014343,1001.0}
};

stock UVM_Init()
{
    for(new i = 0; i < 8; i++)
    {
        uvm_enter_area[i] = CreateDynamicSphere(uvm_enter_pos[i][0], uvm_enter_pos[i][1], uvm_enter_pos[i][2] + 0.5, 6.0, 0);
        CreateDynamic3DTextLabel("{FFFF00}Авторынок\n\n{FFFFFF}Нажмите {FF0000}'гудок'{FFFFFF}, находясь в машине", -1, uvm_enter_pos[i][0], uvm_enter_pos[i][1], uvm_enter_pos[i][2] + 1.7, 20.0);

        uvm_exit_area[i] = CreateDynamicSphere(uvm_exit_inside[i][0], uvm_exit_inside[i][1], uvm_exit_inside[i][2], 4.0, UVM_WORLD, UVM_INTERIOR);
        CreateDynamicPickup(19134, 23, uvm_exit_inside[i][0], uvm_exit_inside[i][1], uvm_exit_inside[i][2], UVM_WORLD, UVM_INTERIOR);
        CreateDynamic3DTextLabel("{FFFF00}Выезд\n\n{FFFFFF}Нажмите {FF0000}'гудок'{FFFFFF}, находясь в машине", -1, uvm_exit_inside[i][0], uvm_exit_inside[i][1], uvm_exit_inside[i][2] + 1.7, 20.0, UVM_WORLD, UVM_INTERIOR);
    }

    uvm_foot_enter_area = CreateDynamicSphere(1980.876953,-545.951843,12.500099,2.0,0,0);
    CreateDynamicPickup(19134,23,1980.876953,-545.951843,12.500099,0,0);
    // Лишняя 3D-надпись входа отключена.

    for(new i = 0; i < 2; i++)
    {
        uvm_foot_exit_area[i] = CreateDynamicSphere(uvm_foot_exit[i][0], uvm_foot_exit[i][1], uvm_foot_exit[i][2],1.0,UVM_WORLD,UVM_INTERIOR);
        CreateDynamicPickup(19134,23,uvm_foot_exit[i][0],uvm_foot_exit[i][1],uvm_foot_exit[i][2],UVM_WORLD,UVM_INTERIOR);
    }
    return 1;
}

stock bool:UVM_IsInside(playerid)
{
    return uvm_inside[playerid] && GetPlayerInterior(playerid) == UVM_INTERIOR && GetPlayerVirtualWorld(playerid) == UVM_WORLD;
}

stock UVM_ResetPlayer(playerid)
{
    uvm_inside[playerid] = false;
    return 1;
}

stock UVM_IsInEntrance(playerid)
{
    for(new i = 0; i < 8; i++) if(IsPlayerInDynamicArea(playerid, uvm_enter_area[i])) return 1;
    return 0;
}

stock UVM_IsInExit(playerid)
{
    for(new i = 0; i < 8; i++) if(IsPlayerInDynamicArea(playerid, uvm_exit_area[i])) return 1;
    return 0;
}

stock UVM_Enter(playerid)
{
    new veh = GetPlayerOwnableCar(playerid);
    if(veh == INVALID_VEHICLE_ID || GetPlayerVehicleID(playerid) != veh)
        return SendClientMessage(playerid, 0xCECECEFF, "Въехать на авторынок можно только на своем личном транспорте");

    new r = random(sizeof uvm_inside_spawn);
    SetVehiclePos(veh, uvm_inside_spawn[r][0], uvm_inside_spawn[r][1], uvm_inside_spawn[r][2]);
    SetVehicleZAngle(veh, uvm_inside_spawn[r][3]);
    LinkVehicleToInterior(veh, UVM_INTERIOR);
    SetVehicleVirtualWorld(veh, UVM_WORLD);

    SetPlayerInterior(playerid, UVM_INTERIOR);
    SetPlayerVirtualWorld(playerid, UVM_WORLD);
    PutPlayerInVehicle(playerid, veh, 0);
    SetCameraBehindPlayer(playerid);
    uvm_inside[playerid] = true;

    SendClientMessage(playerid, 0x66CC00FF, "Вы въехали на авторынок. Продажа: /sellmycar [id игрока] [цена]");
    return 1;
}

stock UVM_Exit(playerid)
{
    new veh = GetPlayerOwnableCar(playerid);
    if(veh == INVALID_VEHICLE_ID || GetPlayerVehicleID(playerid) != veh)
        return SendClientMessage(playerid, 0xCECECEFF, "Вы должны находиться за рулем своего личного транспорта");

    new r = random(sizeof uvm_exit_outside);
    SetVehiclePos(veh, uvm_exit_outside[r][0], uvm_exit_outside[r][1], uvm_exit_outside[r][2]);
    SetVehicleZAngle(veh, uvm_exit_outside[r][3]);
    LinkVehicleToInterior(veh, 0);
    SetVehicleVirtualWorld(veh, 0);

    SetPlayerInterior(playerid, 0);
    SetPlayerVirtualWorld(playerid, 0);
    PutPlayerInVehicle(playerid, veh, 0);
    SetCameraBehindPlayer(playerid);
    uvm_inside[playerid] = false;
    return 1;
}

stock UVM_HandleKey(playerid, newkeys, oldkeys)
{
    if(!(newkeys & KEY_CROUCH) || (oldkeys & KEY_CROUCH)) return 0;

    if(UVM_IsInEntrance(playerid))
    {
        if(!IsPlayerInAnyVehicle(playerid)) return 1;
        UVM_Enter(playerid);
        return 1;
    }

    if(UVM_IsInside(playerid) && UVM_IsInExit(playerid))
    {
        if(!IsPlayerInAnyVehicle(playerid)) return 1;
        UVM_Exit(playerid);
        return 1;
    }
    return 0;
}

stock UVM_HandleDynamicArea(playerid, areaid)
{
    if(areaid == uvm_foot_enter_area && !IsPlayerInAnyVehicle(playerid))
    {
        new r = random(sizeof uvm_foot_inside);
        SetPlayerPos(playerid, uvm_foot_inside[r][0],uvm_foot_inside[r][1],uvm_foot_inside[r][2]);
        SetPlayerFacingAngle(playerid,uvm_foot_inside[r][3]);
        SetPlayerInterior(playerid,UVM_INTERIOR);
        SetPlayerVirtualWorld(playerid,UVM_WORLD);
        uvm_inside[playerid] = true;
        return 1;
    }
    for(new i = 0; i < 2; i++)
    {
        if(areaid == uvm_foot_exit_area[i] && !IsPlayerInAnyVehicle(playerid))
        {
            SetPlayerPos(playerid,1980.827392,-550.358337,11.974724);
            SetPlayerFacingAngle(playerid,188.714859);
            SetPlayerInterior(playerid,0);
            SetPlayerVirtualWorld(playerid,0);
            uvm_inside[playerid] = false;
            return 1;
        }
    }
    return 0;
}
