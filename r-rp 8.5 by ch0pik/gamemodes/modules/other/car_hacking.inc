#if defined _car_hacking_included
	#endinput
#endif
#define _car_hacking_included

static const ugon_car_models[][] = {
    "Mercedes-Benz SLS AMG", "BMW M3 G80 CS", "Rolls Royce Spectre", 
    "Lamborghini Revuelto", "BMW M5 G90", "Ferrari SF90 XX", 
    "Rolls-Royce Cullinan Bunker", "Lamborghini Diablo", "Porsche 911 Mansory", 
    "Cadilac Escalade V T1XX", "Bentley Continental", "Mercedes Maybach Vision 6"
};

static const ugon_car_ids[] = {
    15176, 15636, 15686, 15689, 15696, 17432, 15282, 15650, 15682, 17446, 15623, 15679
};

static const ugon_locations[][] = {
    "Арзамасе", "Арзамасе", "Арзамасе", "Арзамасе", 
    "Арзамасе", "Арзамасе", "Арзамасе", "Арзамасе",
    "Эдово", "Эдово", "Эдово", "Эдово", "Эдово",
    "Южном", "Южном", "Южном", "Южном", "Южном", 
    "Южном", "Южном", "Южном", "Южном"
};

static const Float:ugon_loc_coords[][4] = {
    {-133.0474, 537.5903, 11.9068, 171.1486},   // Арзамас
    {-236.8359, 628.0753, 11.8304, 174.5848},   // Арзамас
    {-412.5422, 837.0435, 12.1445, 275.2549},   // Арзамас
    {-264.8642, 926.0187, 11.9326, 348.7742},   // Арзамас
    {81.3554, 784.4107, 11.7676, 335.5842},     // Арзамас
    {308.2598, 503.4165, 11.8186, 249.6818},    // Арзамас
    {549.8985, 453.3880, 11.9152, 246.7175},    // Арзамас
    {772.6535, 539.0516, 13.9084, 339.8927},     // Арзамас
    {-2566.7200, 2896.3855, 37.4703, 358.7303},  // Эдово
    {-2569.6790, 2896.4817, 37.4701, 2.2768},    // Эдово
    {-2458.2534, 3000.8381, 36.2931, 180.6815},  // Эдово
    {-2462.1296, 2987.5132, 36.2929, 179.8322},  // Эдово
    {-1852.4967, 2894.0105, 5.8296, 270.3285},     // Эдово
    {2144.7776, -2000.0474, 18.7963, 156.4813}, // Южный
    {1890.2808, -1965.3269, 31.3730, 151.5281}, // Южный
    {1953.4789, -1987.2394, 31.3784, 328.1513}, // Южный
    {2127.2500, -1821.8477, 18.6523, 178.6890}, // Южный
    {2677.4873, -2133.6177, 21.5968, 269.8415}, // Южный
    {2734.9670, -2085.5671, 21.0078, 2.2429},    // Южный
    {2738.4324, -2086.4517, 21.0120, 1.1632},    // Южный
    {2743.5029, -2086.4912, 21.0153, 3.9280},    // Южный
    {2747.8794, -2086.2205, 21.0136, 357.7662}     // Южный
};

// ---------------------------

forward SetVehicleNumber(vehicleid, typenumber, number[], region[]);
forward SendPacket_Plate(playerid, vehicleid, type, number[], region[]);
forward SetTintingParams(carid, select, color, procent);
forward UpdateTinting(playerid, vehicleid);


new bool:IsPlayerHacking[MAX_PLAYERS];

new bool:HasUgonTask[MAX_PLAYERS];
new PlayerUgonCar[MAX_PLAYERS];
new Float:PlayerUgonPos[MAX_PLAYERS][3];
new PlayerUgonVeh[MAX_PLAYERS];
new PlayerUgonLoc[MAX_PLAYERS] = {-1, ...};
new bool:IsVehicleHacked[MAX_PLAYERS];
new PlayerUgonArea[MAX_PLAYERS];



stock ResetPlayerUgonTask(playerid, bool:destroy_veh = true)
{
    if(destroy_veh && IsValidVehicle(PlayerUgonVeh[playerid]))
    {
        DestroyVehicle(PlayerUgonVeh[playerid]);
    }
    
    HasUgonTask[playerid] = false;
    
    if(IsValidDynamicArea(PlayerUgonArea[playerid])) DestroyDynamicArea(PlayerUgonArea[playerid]);
    PlayerUgonArea[playerid] = CreateDynamicSphere(PlayerUgonPos[playerid][0], PlayerUgonPos[playerid][1], PlayerUgonPos[playerid][2], 4.0, -1, -1);
    IsVehicleHacked[playerid] = false;
    PlayerUgonLoc[playerid] = -1;
    PlayerUgonVeh[playerid] = INVALID_VEHICLE_ID;
    PlayerUgonPos[playerid][0] = 0.0;
    PlayerUgonPos[playerid][1] = 0.0;
    PlayerUgonPos[playerid][2] = 0.0;
    
    
    if(IsValidDynamicArea(PlayerUgonArea[playerid]))
    {
        DestroyDynamicArea(PlayerUgonArea[playerid]);
        PlayerUgonArea[playerid] = -1;
    }
    DisablePlayerCheckpoint(playerid);
    return 1;
}


stock ShowCarHacking(playerid)
{
    IsPlayerHacking[playerid] = true;
    
    new pool[30][3] = {
        "X3", "RI", "T1", "AB", "S3", "7B", "41", "10", "17", "31", "12", " 7", " 2", " 9", " 8",
        "C4", "A0", "5D", "E9", "0F", "BB", "D2", "F7", "2C", "96", "A4", "B8", "CC", "E1", "D5"
    };
    
    new matrix[16][3];
    new used[30], picked = 0;
    while(picked < 16) {
        new idx = random(30);
        if(!used[idx]) {
            format(matrix[picked], 3, "%s", pool[idx]);
            used[idx] = 1;
            picked++;
        }
    }
    
    new matrix_str[64];
    matrix_str[0] = EOS;
    for(new i = 0; i < 16; i++) {
        strcat(matrix_str, matrix[i]);
    }
    
    new params[128];

    format(params, sizeof(params), "[30, \"%s\"]", matrix_str);
    MoralPacket_2(playerid, s_CefInterface, t_CefShow, "Hacking", params);
    
    SendClientMessage(playerid, -1, "{FFCC00}[Подсказка] {FFFFFF}Вы начали взлом авто...");
    return 1;
}

forward CarHack_OnNumbersComplete(playerid);
public CarHack_OnNumbersComplete(playerid)
{
    if(IsPlayerHacking[playerid])
    {
        IsPlayerHacking[playerid] = false;
        IsVehicleHacked[playerid] = true;

        TogglePlayerControllable(playerid, true);
        ApplyAnimation(playerid, "CARRY", "crry_prtial", 4.0, 0, 0, 0, 0, 0); 

        SetVehicleParamsEx(PlayerUgonVeh[playerid], 1, 0, 0, 0, 0, 0, 0); 

        if(random(100) < 20)
        {
            if(GetPlayerData(playerid, P_SUSPECT) < 6)
            {
                AddPlayerData(playerid, P_SUSPECT, +, 1);
                SetPlayerWantedLevel(playerid, GetPlayerData(playerid, P_SUSPECT));
                UpdatePlayerDatabaseInt(playerid, "suspect", GetPlayerData(playerid, P_SUSPECT));
                SendClientMessage(playerid, 0x4466CCFF, "[Угон] Тебя заметили! {FFFFFF}Твой уровень розыска повысился.");
            }
        }
        
        SendClientMessage(playerid, 0x4466CCFF, "[Угон] Автомобиль взломан! {FFFFFF}Машина открыта.");
        SendClientMessage(playerid, -1, "{4466CC}[Угон] {FFFFFF}Незнакомец: Красава! Теперь гони тачку в ангар, который находится в Батырево, я отметил место.");
        
        MoralPacket_1(playerid, s_CefInterface, t_CefHide, "Hacking");
        SetPlayerCheckpoint(playerid, 1762.3357, 2297.1692, 15.9718, 5.0);
    }
    return 1;
}

CMD:ugon(playerid, params[])
{
    if(HasUgonTask[playerid]) return SendClientMessage(playerid, -1, "{FF0000}[Ошибка] {FFFFFF}У вас уже есть заказ на угон!");

    SendClientMessage(playerid, 0x4466CCFF, "* Вы звоните неизвестному номеру...");
    SetTimerEx("OnUgonCallResponse", 2000, false, "i", playerid);
    return 1;
}

forward OnUgonCallResponse(playerid);
public OnUgonCallResponse(playerid)
{
    new loc_idx = -1;
    new start_search = random(sizeof(ugon_loc_coords));
    for(new i = 0; i < sizeof(ugon_loc_coords); i++)
    {
        new check_idx = (start_search + i) % sizeof(ugon_loc_coords);
        new bool:busy = false;
        for(new p = 0; p < MAX_PLAYERS; p++)
        {
            if(IsPlayerConnected(p) && HasUgonTask[p] && PlayerUgonLoc[p] == check_idx)
            {
                busy = true;
                break;
            }
        }
        if(!busy)
        {
            loc_idx = check_idx;
            break;
        }
    }

    if(loc_idx == -1) {
        return SendClientMessage(playerid, -1, "{4466CC}[Угон] {FFFFFF}Незнакомец: Сейчас пока нет свободных тачек в отстойниках. Позвони в другой раз.");
    }

    new car_idx = random(sizeof(ugon_car_ids));

    PlayerUgonCar[playerid] = ugon_car_ids[car_idx];
    PlayerUgonLoc[playerid] = loc_idx;
    PlayerUgonPos[playerid][0] = ugon_loc_coords[loc_idx][0];
    PlayerUgonPos[playerid][1] = ugon_loc_coords[loc_idx][1];
    PlayerUgonPos[playerid][2] = ugon_loc_coords[loc_idx][2];
    HasUgonTask[playerid] = true;

    new string[256];
    format(string, sizeof(string), "{4466CC}[Угон] {FFFFFF}Незнакомец: Слушай. Мне нужен %s.", ugon_car_models[car_idx]);
    SendClientMessage(playerid, -1, string);
    format(string, sizeof(string), "{4466CC}[Угон] {FFFFFF}Незнакомец: Он стоит в %s. Нам нем сейчас стоят левые номера. Скинь их.", ugon_locations[loc_idx]);
    SendClientMessage(playerid, -1, string);

    SetPlayerCheckpoint(playerid, PlayerUgonPos[playerid][0], PlayerUgonPos[playerid][1], PlayerUgonPos[playerid][2], 5.0);

    if(IsValidVehicle(PlayerUgonVeh[playerid])) DestroyVehicle(PlayerUgonVeh[playerid]);
    
    new color1 = random(126);
    new color2 = random(126);
    PlayerUgonVeh[playerid] = CreateVehicle(PlayerUgonCar[playerid], PlayerUgonPos[playerid][0], PlayerUgonPos[playerid][1], PlayerUgonPos[playerid][2], ugon_loc_coords[loc_idx][3], color1, color2, -1);

    new number[12], region[8], letters[] = "ABEKMHOPCTYX";
    new regions[] = {77, 97, 99, 177, 197, 199, 777, 78, 98, 178, 16, 116, 23, 93, 123, 50, 90, 150, 190};
    
    format(number, sizeof(number), "%c%03d%c%c", 
        letters[random(sizeof(letters) - 1)], 
        random(999), 
        letters[random(sizeof(letters) - 1)], 
        letters[random(sizeof(letters) - 1)]);
        
    format(region, sizeof(region), "%d", regions[random(sizeof(regions))]);

    SetVehicleNumber(PlayerUgonVeh[playerid], 1, number, region);
    
    for(new i = 0; i < 3; i++) {
        SetTintingParams(PlayerUgonVeh[playerid], i, 1, 100); 
    }
    
    SendPacket_Plate(playerid, PlayerUgonVeh[playerid], 1, number, region);
    UpdateTinting(playerid, PlayerUgonVeh[playerid]);

    SetVehicleParamsEx(PlayerUgonVeh[playerid], 0, 0, 0, 1, 0, 0, 0); 

    if(IsValidDynamicArea(PlayerUgonArea[playerid])) DestroyDynamicArea(PlayerUgonArea[playerid]);
    PlayerUgonArea[playerid] = CreateDynamicSphere(PlayerUgonPos[playerid][0], PlayerUgonPos[playerid][1], PlayerUgonPos[playerid][2], 4.0, -1, -1);
    IsVehicleHacked[playerid] = false;
    
    return 1;
}


stock CarHacking_OnSecondTimer()
{
    for(new i = 0; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i)) continue;
        if(HasUgonTask[i])
        {
            if(!IsValidVehicle(PlayerUgonVeh[i]))
            {
                if(IsPlayerHacking[i])
                {
                    IsPlayerHacking[i] = false;
                    TogglePlayerControllable(i, true);
                    ClearAnimations(i);
                    MoralPacket_1(i, s_CefInterface, t_CefHide, "Hacking");
                }
                SendClientMessage(i, -1, "{FF0000}[Угон] {FFFFFF}Транспорт пропал! Задание провалено.");
                ResetPlayerUgonTask(i, false);
            }
        }
    }
    return 1;
}
