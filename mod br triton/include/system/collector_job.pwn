/*

Нужно добавить данные строки в g_teleport и учеличить его до 36 (или же +4)

new g_teleport[36][E_TELEPORT_STRUCT] = //под новый интерьер
{
	{"Банк\nг.Арзамас", 395.029266,762.869506,12.630935, 0, 2890.355712,2488.004638,1051.004760,353.741363, 1, 1}, // вход в Центральный Банк Арзамас
	{"Выход", 2890.299560,2484.910644,1051.004760, 1, 394.006500,761.715270,12.630935,157.697418, 0, 0}, // выход из Центральный Банк Арзамас
	//
	{"Банк\nг.Лыткарино", -2326.625976,-29.081722,27.384737, 0, 2890.355712,2488.004638,1051.004760,353.741363, 1, 2}, // вход в Центральный Банк Лыткарино
	{"Выход", 2890.299560,2484.910644,1051.004760, 2,-2326.839843,-27.583950,27.384737,357.855255, 0, 0}, // выход из Центральный Банк Лыткарино
	//
	{"Банк\nг.Южный", 2376.805664,-2139.199951,22.088638, 0, 2890.355712,2488.004638,1051.004760,353.741363, 1, 3}, // вход в Центральный Банк Южный
	{"Выход", 2890.299560,2484.910644,1051.004760, 3, 2376.305419,-2140.406738,21.973030,176.052505, 0, 0}, // выход из Центральный Банк Южный
	//
	{"Банк\nпгт.Батырево", 1851.860351,2037.297119,16.518316, 0, 2890.355712,2488.004638,1051.004760,353.741363, 1, 4}, // вход в Центральный Банк Батырево
	{"Выход", 2890.299560,2484.910644,1051.004760, 4, 1851.870361,2039.171875,16.511747,351.717041, 0, 0}, // выход из Центральный Банк Батырево
};


*/


#define COUNT_EXP_FOR_2_RANG    150
#define COUNT_EXP_FOR_3_RANG    300

#define order_c_cash_200     1        
#define order_c_cash_500     2   
#define order_c_cash_1000    3   
#define order_c_packet_200   4   
#define order_c_packet_500   5   
#define order_c_packet_1000  6   

new name_order_type[6][34] =
{
    {"Наличные до 700.000 рублей"},
    {"Наличные до 1.000.000 рублей"},
    {"Наличные до 1.500.000 рублей"},
    {"Пакет акций до 1.800.000 рублей"},
    {"Пакет акций до 2.000.000 рублей"},
    {"Пакет акций до 2.400.000 рублей"}
};

new Float:place_safe_bank[3] = {2930.936523,2525.372802,1051.004638};
new Float:place_bank[4] = {2927.294677,2484.445068,1051.004760};
new sphere_safe_bank;

/*2927.294677,2484.445068,1051.004760,0.942115,100,1 // npc new inter

2930.936523,2525.372802,1051.004638,283.521148,100,1 // seif new inter

1851.512573,2039.888427,16.511747,211.691741,0,0 // metka batika bank

1861.964843,2018.943481,16.511747,185.995559,0,0 // npc batka veh

1860.964599,2008.321655,15.115466,1.317162,0,0 // spawn batka veh

391.651977,783.632019,12.624366,337.065582,0,0 // npc arzamaz veh

396.351043,793.468139,11.240552,159.654357,0,0 // spawn arzamaz veh

393.945953,760.605590,12.624366,145.596084,0,0 // metka arzamaz

2376.792236,-2140.952880,21.972230,13.648014,0,0 // metka uzhni bank

2376.608886,-2127.770263,21.976562,2.937249,0,0 // npc uzhni veh

2388.106201,-2118.204101,21.232568,92.724845,0,0 // spawn uzhni veh

-2336.213378,-57.883251,26.126291,357.671356,0,0 // spawn litka veh

-2316.500000,-47.433452,27.378168,187.828155,0,0 // npc litka veh

-2326.648925,-27.537290,27.384737,0.862980,0,0 // npc litka veh

-2326.782714,-29.080144,27.384737,185.599380,0,0 // pickup litka bank

-2326.574707,-26.699550,27.378168,355.440490,0,0 // metka litka bank

394.877868,762.929565,12.630935,347.608825,0,0 // pickup arzamaz

2376.566894,-2139.199951,22.088638,327.764282,0,0 // pickup uzhni*/



enum struct_player_collector 
{
    bool:job_active,
    rang_collector, 
    exp_rang_collector,
    order_collector, 
    player_partner,
    timer_c,
    second_c,
    fine_driver,
    c_quest_progress_1,
    c_quest_count_1,
    c_quest_progress_2,
    c_quest_count_2,
    c_quest_progress_3,
    c_quest_count_3,
    player_gang_zone_collector
}

new Float:coord_arenda_c[4][4]=
{
    {1861.964843,2018.943481,16.511747,185.995559},//batka
    {391.651977,783.632019,12.624366,337.065582},//arz
    {2376.608886,-2127.770263,21.976562,2.937249},//uzh
    {-2316.500000,-47.433452,27.378168,187.828155}//litka
};

new Float:coord_arenda_spawn[4][4] =
{
    {1860.964599,2008.321655,15.115466,1.317162},
    {396.351043,793.468139,11.240552,159.654357},
    {2388.106201,-2118.204101,21.232568,92.724845},
    {-2336.213378,-57.883251,26.126291,357.671356}
};


new sphere_arenda_collector[4];

new sphere_collector;

#define BR   "{FAD201}"

new player_collector[MAX_PLAYERS][struct_player_collector];

enum struct_orders_collectors
{
    order_type_active,
    orders_type,
    collector_id_driver,
    collector_id_collector,
    progress_order,
    Text3D:order_s_3dtext,
    Text3D:order_e_3dtext,
    order_sphere_start,
    order_sphere_end,
    Float: orders_start_point[3],
    Float: orders_end_point[3],
    place_start,
    place_end,
    collector_vehicle
}

#define TYPE_O_C_NOACTIVE  0
#define TYPE_O_C_ACTIVE    1
#define TYPE_O_C_TAKEN     2

#define MAX_ORDER_COL   30

new name_place_order[5][32] =
{
    {"Банкомат"},
    {"Банк г.Арзамас"},
    {"Банк г.Лыткарино"},
    {"Банк г.Южный"},
    {"Банк пгт.Батырево"}
};


#define World_Bank_Arzamaz  1
#define World_Bank_Litka  2
#define World_Bank_Uzhni  3
#define World_Bank_Batirevo  4

#define Place_Col_1   1      //Банкомат 
#define Place_Col_2   2      //Банк г.Арзамас
#define Place_Col_3   3      //Банк г.Лыткарино
#define Place_Col_4   4      //Банк г.Южный
#define Place_Col_5   5      //Банк пгт.Батырево  

/*
1405.907714,462.846069,13.163024,13.730526,0,0 // atm 1
2408.673339,-1841.696289,22.949813,356.944488,0,0 // atm 2
29.823257,511.317108,13.174163,57.959037,0,0 // atm 3?
-501.804748,1270.387451,20.890625,79.035469,0,0 // atm 5/
2481.007080,-718.345336,12.370574,0.355532,0,0 // atm 6/
-19.817697,2621.752197,10.989245,177.547027,0,0 // atm 7/
-2557.399414,39.671264,27.879764,220.350555,0,0 // atm 8
2419.060546,1397.435913,12.218092,120.040786,0,0 // atm 9
*/

/*-2326.574707,-26.699550,27.378168,355.440490,0,0 // metka litka bank
393.945953,760.605590,12.624366,145.596084,0,0 // metka arzamaz
2376.792236,-2140.952880,21.972230,13.648014,0,0 // metka uzhni bank
1851.512573,2039.888427,16.511747,211.691741,0,0 // metka batika bank*/

new orders_collectors[MAX_ORDER_COL][struct_orders_collectors] =
{
    {TYPE_O_C_NOACTIVE, 1, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {393.945953,760.605590,12.624366}, {1405.907714,462.846069,13.163024}, Place_Col_2, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 1, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2408.673339,-1841.696289,22.949813}, {2376.792236,-2140.952880,21.972230}, Place_Col_1, Place_Col_4, -1},
    {TYPE_O_C_NOACTIVE, 1, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {-2326.574707,-26.699550,27.378168}, {29.823257,511.317108,13.174163}, Place_Col_3, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 1, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {393.945953,760.605590,12.624366}, {-501.804748,1270.387451,20.890625}, Place_Col_2, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 1, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2376.792236,-2140.952880,21.972230}, {-501.804748,1270.387451,20.890625}, Place_Col_4, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 2, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {1851.512573,2039.888427,16.511747}, {2481.007080,-718.345336,12.370574}, Place_Col_5, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 2, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {-19.817697,2621.752197,10.989245}, {1851.512573,2039.888427,16.511747}, Place_Col_1, Place_Col_5, -1},
    {TYPE_O_C_NOACTIVE, 2, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2376.792236,-2140.952880,21.972230}, {-2557.399414,39.671264,27.879764}, Place_Col_4, Place_Col_1,  -1},
    {TYPE_O_C_NOACTIVE, 2, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {1851.512573,2039.888427,16.511747}, {2419.060546,1397.435913,12.218092}, Place_Col_5, Place_Col_1,  -1},
    {TYPE_O_C_NOACTIVE, 2, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {29.823257,511.317108,13.174163}, {393.945953,760.605590,12.624366}, Place_Col_1, Place_Col_2,    -1},
    {TYPE_O_C_NOACTIVE, 3, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {393.945953,760.605590,12.624366}, {1405.907714,462.846069,13.163024}, Place_Col_2, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 3, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2408.673339,-1841.696289,22.949813}, {2376.792236,-2140.952880,21.972230}, Place_Col_1, Place_Col_4, -1},
    {TYPE_O_C_NOACTIVE, 3, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {-2326.574707,-26.699550,27.378168}, {29.823257,511.317108,13.174163}, Place_Col_3, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 3, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {393.945953,760.605590,12.624366}, {-501.804748,1270.387451,20.890625}, Place_Col_2, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 3, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2376.792236,-2140.952880,21.972230}, {-501.804748,1270.387451,20.890625}, Place_Col_4, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 4, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {1851.512573,2039.888427,16.511747}, {2481.007080,-718.345336,12.370574}, Place_Col_5, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 4, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {-19.817697,2621.752197,10.989245}, {1851.512573,2039.888427,16.511747}, Place_Col_1, Place_Col_5, -1},
    {TYPE_O_C_NOACTIVE, 4, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2376.792236,-2140.952880,21.972230}, {-2557.399414,39.671264,27.879764}, Place_Col_4, Place_Col_1,  -1},
    {TYPE_O_C_NOACTIVE, 4, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {1851.512573,2039.888427,16.511747}, {2419.060546,1397.435913,12.218092}, Place_Col_5, Place_Col_1,  -1},
    {TYPE_O_C_NOACTIVE, 4, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {29.823257,511.317108,13.174163}, {393.945953,760.605590,12.624366}, Place_Col_1, Place_Col_2,    -1},
    {TYPE_O_C_NOACTIVE, 5, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {393.945953,760.605590,12.624366}, {1405.907714,462.846069,13.163024}, Place_Col_2, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 5, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2408.673339,-1841.696289,22.949813}, {2376.792236,-2140.952880,21.972230}, Place_Col_1, Place_Col_4, -1},
    {TYPE_O_C_NOACTIVE, 5, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {-2326.574707,-26.699550,27.378168}, {29.823257,511.317108,13.174163}, Place_Col_3, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 5, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {393.945953,760.605590,12.624366}, {-501.804748,1270.387451,20.890625}, Place_Col_2, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 5, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2376.792236,-2140.952880,21.972230}, {-501.804748,1270.387451,20.890625}, Place_Col_4, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 6, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {1851.512573,2039.888427,16.511747}, {2481.007080,-718.345336,12.370574}, Place_Col_5, Place_Col_1, -1},
    {TYPE_O_C_NOACTIVE, 6, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {-19.817697,2621.752197,10.989245}, {1851.512573,2039.888427,16.511747}, Place_Col_1, Place_Col_5, -1},
    {TYPE_O_C_NOACTIVE, 6, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {2376.792236,-2140.952880,21.972230}, {-2557.399414,39.671264,27.879764}, Place_Col_4, Place_Col_1,  -1},
    {TYPE_O_C_NOACTIVE, 6, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {1851.512573,2039.888427,16.511747}, {2419.060546,1397.435913,12.218092}, Place_Col_5, Place_Col_1,  -1},
    {TYPE_O_C_NOACTIVE, 6, -1, -1, 0, Text3D:-1, Text3D:-1, -1, -1, {29.823257,511.317108,13.174163}, {393.945953,760.605590,12.624366}, Place_Col_1, Place_Col_2,    -1}
};



public OnPlayerConnect(playerid)
{
    player_collector[playerid][job_active] = false;
    player_collector[playerid][rang_collector] = 0;
    player_collector[playerid][exp_rang_collector] = 1;
    player_collector[playerid][order_collector] = -1;
    player_collector[playerid][player_partner] = -1;
    player_collector[playerid][timer_c] = -1;
    player_collector[playerid][second_c] = 0;
    player_collector[playerid][fine_driver] = 0;
    player_collector[playerid][c_quest_progress_1] = 0;
    player_collector[playerid][c_quest_count_1] = 0;
    player_collector[playerid][c_quest_progress_2] = 0;
    player_collector[playerid][c_quest_count_2] = 0;
    player_collector[playerid][c_quest_progress_3] = 0;
    player_collector[playerid][c_quest_count_3] = 0;
    player_collector[playerid][player_gang_zone_collector] = -1;

    SetTimerEx("LoadRangCollector", 2500, false, "i", playerid);
    #if defined col_OnPlayerConnect
        return col_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect col_OnPlayerConnect
#if defined col_OnPlayerConnect
    forward col_OnPlayerConnect(playerid);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(player_collector[playerid][order_collector] != -1)
    {
        EndOrderCollector(playerid, player_collector[playerid][player_partner], false);
    }

    #if defined col_OnPlayerDisconnect
        return col_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect col_OnPlayerDisconnect
#if defined col_OnPlayerDisconnect
    forward col_OnPlayerDisconnect(playerid, reason);
#endif


public:LoadRangCollector(playerid)
{
    new database_txt[64], Cache:result;

    mysql_format(mysql, database_txt, sizeof database_txt, "SELECT * FROM accounts WHERE id = %d", GetPlayerAccountID(playerid));
    result = mysql_query(mysql, database_txt);


    if(mysql_errno()) return printf("error collector query: %d - database id", GetPlayerAccountID(playerid));
    else
    {
        if(cache_num_rows())
        {
            player_collector[playerid][exp_rang_collector] = cache_get_field_content_int(0, "exp_collector");

            

            switch(player_collector[playerid][exp_rang_collector])
            {
                case 0..149:    player_collector[playerid][rang_collector] = 1;                    
                case 150..299:  player_collector[playerid][rang_collector] = 2;            
                default:       player_collector[playerid][rang_collector] = 3;      
            }           
        }
        else printf("id = %d | none cache collector", GetPlayerAccountID(playerid));

        if(!player_collector[playerid][exp_rang_collector]) player_collector[playerid][exp_rang_collector] = 1;
    }
        
    cache_delete(result);

    return 1;
}

public OnPlayerEnterCheckpoint(playerid)
{
    if(player_collector[playerid][order_collector] != -1)
    {
        new order = player_collector[playerid][order_collector];
        new partner = player_collector[playerid][player_partner];

        switch(orders_collectors[order][progress_order])
        {
          
            case 1:// игрок взял деньги/акции
            {
                if(!GetPlayerVehicleSeat(playerid))
                {
                    orders_collectors[order][collector_id_driver] = playerid;
                    orders_collectors[order][collector_id_collector] = partner;
                }
                else if(!GetPlayerVehicleSeat(partner))
                {
                    orders_collectors[order][collector_id_driver] = partner;
                    orders_collectors[order][collector_id_collector] = playerid;
                } 
                
                if(orders_collectors[order][place_start] != Place_Col_1)
                {
                    SendClientMessage(orders_collectors[order][collector_id_collector], -1,
                    ""SC" Отправляйтесь в {FAD201}отделение банка{FFFFFF} и возмите денежные средства из {FAD201}хранилища.");
                } 
                else
                {
                    SendClientMessage(orders_collectors[order][collector_id_collector], -1, ""SC" Отправляйтесь к {FAD201}банкомату{FFFFFF} и отнесите ценный груз.");
                }
            }
            case 2:// игрок подъежает к месту завершения заказа
            {
                if(!GetPlayerVehicleSeat(playerid))
                {
                    orders_collectors[order][collector_id_driver] = playerid;
                    orders_collectors[order][collector_id_collector] = partner;
                }
                else if(!GetPlayerVehicleSeat(partner))
                {
                    orders_collectors[order][collector_id_driver] = partner;
                    orders_collectors[order][collector_id_collector] = playerid;
                } 
                if(orders_collectors[order][place_end] != Place_Col_1)
                {
                    SendClientMessage(orders_collectors[order][collector_id_collector], -1,
                    ""SC" Отправляйтесь в {FAD201}отделение банка{FFFFFF} и отнесите денежные средства в {FAD201}хранилище.");
                } 
                else
                {
                    SendClientMessage(orders_collectors[order][collector_id_collector], -1, ""SC" Отправляйтесь к {FAD201}банкомату{FFFFFF} и отнесите ценный груз.");
                }
            }
            default:printf("ERROR COLLECTOR: None Progress Order | id order: %d | id player: %d", order, playerid);
        }

        DisablePlayerCheckpoint(partner);
        DisablePlayerCheckpoint(playerid);
    }
    #if defined col_OnPlayerEnterCheckpoint
        return col_OnPlayerEnterCheckpoint(playerid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerEnterCheckpoint
    #undef OnPlayerEnterCheckpoint
#else
    #define _ALS_OnPlayerEnterCheckpoint
#endif
#define OnPlayerEnterCheckpoint col_OnPlayerEnterCheckpoint
#if defined col_OnPlayerEnterCheckpoint
    forward col_OnPlayerEnterCheckpoint(playerid);
#endif



public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    if(dialogid == 1811)
    {
        if(response)
        {
            switch(listitem)
            {
                case 0:
                {
                    Dialog
                    (
                        playerid, -1, DIALOG_STYLE_MSGBOX,
                        ""BR""SERVER_NAME" {FFFFFF}-> Информация",
                        "{FAD201}Инкассатор{FFFFFF} - сотрудник банка, занимающийся транспортировкой денежных средств и других драгоценностей\n"\
                        "по нуждам банка или его клиентов.\n\n"\
                        "Данная работа - {FAD201}командная{FFFFFF}, работать на ней можно только в паре с напарником.\n"\
                        "Для поиска напарника можно воспользоваться командой "BR"/collist\n\n"\
                        "{FFFFFF}Пара состоит из двух человек:\n"\
                        ""BR"1. {FAD201}Водитель - член команды, арендовавший автомобиль. Он никогда не покидает автомобиль,\n"\
                        "следит за обстановкой.\n"\
                        ""BR"2. {FAD201}Инкассатор - член команды, выполняющий роли пассажира в автомобиле\n"\
                        "и инкассатора без него. Он напрямую взаимодействует с ценным грузом и отвечает за его сохранность.\n\n"\
                        "Данная работа содержит в себе 3 звания:\n"\
                        ""BR"1. {FAD201}Инкассатор 1 класса{FFFFFF} - самый младший класс класс инкассатора, которыйможет взаимодействовать заказами\n"\
                        "с меньшим числом средств и арендовать {FAD201}Газель Инкассатора.\n"\
                        ""BR"2. {FAD201}Инкассатор 2 класса{FFFFFF} - средний класс инкассатора, который может взаимодействовать\n"\
                        "с заказами с минимальным и средним количеством средств, а также арендовать {FAD201}Газель Инкассатора{FFFFFF} или {FAD201}Volkswagen Transporter.\n"\
                        ""BR"3. {FAD201}Инкассатор 3 класса{FFFFFF} - самый высокий класс инкассатора, который может взаимодействовать со всеми заказами,\n"\
                        "а также арендовать {FAD201}Газель Инкассатора, {FAD201}Volkswagen Transporter{FFFFFF} или {FAD201}Mercedes-Benz V-klasse.\n\n"\
                        "Для открытия нового уровня необходимо зарабатывать {FAD201}навык{FFFFFF}, который\n"\
                        "выдается за каждый {FAD201}успешно выполненный заказ.{FFFFFF}.\n\n"\
                        "Ознакомиться с личной карточкой инкассатора можно при помощи "BR"/cmenu",
                        "Назад", ""
                    );
                }
                case 1:
                {
                    if(!player_collector[playerid][job_active])
                    {
                        Dialog
                        (
                            playerid, 1812, DIALOG_STYLE_MSGBOX,
                            ""BR"Виталий - Директор | Работа инкассации",
                            "Здраствуйте, для трудоустройства инкассатором, Вам необходимо:\n\n"\
                            ""BR"1. {FFFFFF}Иметь {FAD201}15 {FFFFFF}игровой уровень.\n"\
                            ""BR"2. {FFFFFF}Иметь {FAD201}лицензию на оружие.\n"\
                            ""BR"3. {FFFFFF}Иметь {FAD201}водительские права.\n"\
                            "{FFFFFF}Если Вы готовы трудоустроиться, нажмите {FAD201}Далее{FFFFFF}.",
                            "Далее", "Закрыть"
                            
                        );
                    }
                    else
                    {
                        EndOrderCollector(playerid, player_collector[playerid][player_partner], false);
                        SendClientMessage(player_collector[playerid][player_partner], -1, ""USC"Ваш напарник уволился с работы.");
                        SetPlayerSkinInit(playerid);
                        ResetPlayerWeapons(playerid);
                    }
                }
                case 2:
                {
                    new text_sql[124], Cache:result;

                    mysql_format(mysql, text_sql, sizeof text_sql, "SELECT * FROM accounts WHERE exp_collector >= '0' ORDER BY exp_collector DESC LIMIT 10");
                    result = mysql_query(mysql, text_sql);

                    if(mysql_errno()) return print("[COLLECTOR_SYSTEM] Error Sql Query: №1");

                    new rows = cache_num_rows();

                    new list[68], dialog[584] = ""BR"##\t"BR"Ник\t{979595}Очки\n";

                    new name[24], exp;

                    for(new i;i < rows;i++)
                    {
                        cache_get_field_content(i, "name", name, mysql, 24);
                        exp = cache_get_field_content_int(i, "exp_collector");

                        format(list, sizeof list, ""BR"#%d\t{FFFFFF}%s\t{979595}%d\n", i+1, name, exp);
                        strcat(dialog, list);
                    }

                    DialogCollector(playerid, -1, DIALOG_STYLE_TABLIST_HEADERS, ""BR""SERVER_NAME" {FFFFFF}| Рейтинг лучших инкассаторов", dialog, "Назад", "Закрыть");

                }
                case 3:
                {
                    if(!player_collector[playerid][job_active])
                     return SendClientMessage(playerid, -1, ""USC"Сначало начните {FAD201}рабочий день.");

                    new dialog[534], quest_1[32], quest_2[32], quest_3[32];

                    switch(player_collector[playerid][c_quest_progress_1])
                    {
                        case 0:format(quest_1, sizeof quest_1, ""BR"Не выполняется");
                        case 1:format(quest_1, sizeof quest_1, "{FAD201}Выполняется");
                        case 2:format(quest_1, sizeof quest_1, "{1EFF00}Выполнено");
                    }

                    switch(player_collector[playerid][c_quest_progress_2])
                    {
                        case 0:format(quest_2, sizeof quest_2, ""BR"Не выполняется");
                        case 1:format(quest_2, sizeof quest_2, "{FAD201}Выполняется");
                        case 2:format(quest_2, sizeof quest_2, "{1EFF00}Выполнено");
                    }

                    switch(player_collector[playerid][c_quest_progress_3])
                    {
                        case 0:format(quest_3, sizeof quest_3, ""BR"Не выполняется");
                        case 1:format(quest_3, sizeof quest_3, "{FAD201}Выполняется");
                        case 2:format(quest_3, sizeof quest_3, "{1EFF00}Выполнено");
                    }

                    format
                    (
                        dialog, sizeof dialog,
                        ""BR"##\t"BR"Наименование\t"BR"Прогресс\t"BR"Статус\n"\
                        ""BR"#1.\t"BR"Вместе веселее\t"BR"%d/2\t%s\n"\
                        ""BR"#2.\t"BR"Достойный инкассатор\t"BR"%d/5\t%s\n"\
                        ""BR"#2.\t"BR"Это высокая позиция\t"BR"%d/10\t%s",
                        player_collector[playerid][c_quest_count_1], quest_1, 
                        player_collector[playerid][c_quest_count_2], quest_2,
                        player_collector[playerid][c_quest_count_3], quest_3
                    );

                    DialogCollector
                    (
                        playerid, 1815, DIALOG_STYLE_TABLIST_HEADERS,
                        ""BR""SERVER_NAME"{FFFFFF}-> Ежедневные задания",
                        dialog,
                        "Далее", "Отмена"
                    );
                }
                case 4:
                {
                    new text[384], exp[124], order[194];

                    switch(player_collector[playerid][rang_collector])
                    {
                        case 1:
                        {
                            format(exp, sizeof exp, "{FAD201}3. {FFFFFF}Необходимое количество навыков для открытия следующего класса: {FAD201}%d/%d{FFFFFF}\n",
                            player_collector[playerid][exp_rang_collector], COUNT_EXP_FOR_2_RANG);

                            format(order, sizeof order, "- %s\n- %s", name_order_type[0], name_order_type[1]);
                        }
                        case 2:
                        {
                            format(exp, sizeof exp, "{FAD201}3. {FFFFFF}Необходимое количество навыков для открытия следующего класса: {FAD201}%d/%d{FFFFFF}\n",
                            player_collector[playerid][exp_rang_collector], COUNT_EXP_FOR_3_RANG);
                            format(order, sizeof order, "- %s\n- %s\n- %s\n- %s", name_order_type[0], name_order_type[1], name_order_type[2], name_order_type[3]);
                        }
                        case 3:
                        {
                            format(exp, sizeof exp, "{FAD201}3. {FFFFFF}Достигнут максимальный уровень инкассатора\n");
                            format(order, sizeof order, "- %s\n- %s\n- %s\n- %s\n- %s\n- %s", name_order_type[0], name_order_type[1], name_order_type[2], name_order_type[3], name_order_type[4], name_order_type[5]);
                        } 
                    }

                    format
                    (
                        text, sizeof text, 
                        "{FAD201}1. {FFFFFF}Занимаемая должность: {FAD201}Инкассатор %d класса{FFFFFF}\n"\
                        "{FAD201}2. {FFFFFF}Текущий навык инкассатора: {FAD201}%d{FFFFFF}\n"\
                        "%s\n"\
                        "{FAD201}4. {FFFFFF}Доступные заказы:\n"\
                        "%s",
                        player_collector[playerid][rang_collector], player_collector[playerid][exp_rang_collector], exp, order
                    );

                    Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, ""BR""SERVER_NAME"{FFFFFF}-> Личная карточка", text, "Назад", "Закрыть");
                }
            }
        }
    }
    if(dialogid == 1810)
    {
        if(response)
        {
            new id = GetPlayerListitemValue(playerid, listitem + 1), text[154];

            if(orders_collectors[id][collector_id_driver] != -1 && orders_collectors[id][collector_id_collector] != -1)
                return SendClientMessage(playerid, -1, ""USC" Данный заказ уже взяли.");

            if(!GetPlayerVehicleID(playerid))
                return SendClientMessage(playerid, -1, ""USC" Вы должны быть в транспорте");

            new id_car = GetPlayerVehicleID(playerid);
            new model = GetVehicleModel(id_car);

            switch(model)
            {
                case 482, 428, 427: model = 0; //бессмыслено
                default:return SendClientMessage(playerid, -1, ""SC" Арендуйте рабочий транспорт. Начальник аренды находиться на задней территории банка");
            }

            switch(orders_collectors[id][orders_type])
            {
                case 3,4:if(player_collector[playerid][rang_collector] == 1) return SendClientMessage(playerid, -1, ""USC"Этот заказ для более высокого класса инкассатора");
                case 5,6:if(player_collector[playerid][rang_collector] <= 2) return SendClientMessage(playerid, -1, ""USC"Этот заказ для более высокого класса инкассатора");
            }

            new partner = player_collector[playerid][player_partner];

            if(!GetPlayerVehicleSeat(playerid))
            {
                orders_collectors[id][collector_id_driver] = playerid;
                orders_collectors[id][collector_id_collector] = partner;
            }
            else if(!GetPlayerVehicleSeat(partner))
            {
                orders_collectors[id][collector_id_driver] = partner;
                orders_collectors[id][collector_id_collector] = playerid;
            }

            player_collector[playerid][order_collector] = id;
            player_collector[partner][order_collector] = id;


            orders_collectors[id][collector_vehicle] = GetPlayerVehicleID(playerid);

            orders_collectors[id][progress_order]++;

            load_order_colllector(id);

            SetPlayerCheckpoint(playerid, orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1], orders_collectors[id][orders_start_point][2], 5.0);
            SetPlayerCheckpoint(partner, orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1], orders_collectors[id][orders_start_point][2], 5.0);
            ShowPlayerGPS(playerid, orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1]);
            ShowPlayerGPS(partner, orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1]);

            // ДОБАВЬ ГАНГЗОНУ (маленькая метка на карте):
            CreateSmallGangZoneForCollector(playerid, orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1]);
            CreateSmallGangZoneForCollector(partner, orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1]);

            format(text, sizeof text, ""SC"Вы успешно взяли заказ {FAD201}№%d{FFFFFF}, отправляйтесь на отмеченнную метку на GPS.", id + 1);
            SendClientMessage(playerid, -1, text);
            SendClientMessage(partner, -1, text);
        }
    }
    if(dialogid == 1812)
    {
        if(response)
        {
            if(GetPVarInt(playerid, "d_c_1"))
            {
                SendClientMessage(playerid, -1, ""SC"Вы начали работу {FAD201}инкассатора{FFFFFF}. Найдите напарника при помощи {FAD201}/colinv [ID]");

                player_collector[playerid][job_active] = true;

                switch(player_collector[playerid][rang_collector])
                {
                    case 1:SetPlayerSkin(playerid, 168);
                    case 2:SetPlayerSkin(playerid, 132);
                    case 3:SetPlayerSkin(playerid, 28);
                }

                GivePlayerWeapon(playerid, 29, 500);
                GivePlayerWeapon(playerid, 24, 500);
                SetPlayerArmour(playerid, 100.0);

                player_collector[playerid][player_partner]  = -1;


                player_collector[playerid][order_collector] = -1;     
                player_collector[playerid][timer_c]         = -1;     
                player_collector[playerid][second_c]        = 0; 

                return 1;
            }

            if(GetPlayerLevel(playerid) < 15)
                return SendClientMessage(playerid, -1, ""USC"Необходимый уровень для устройства на инкассатора - 15 уровень.");

            if(GetPlayerData(playerid, P_WEAPON_LIC) != 1)
                return SendClientMessage(playerid, -1, ""USC"Для устройства на инкассатора нужна лицензия на оружие.");

            if(!GetPlayerData(playerid, P_DRIVING_LIC))
                return SendClientMessage(playerid, -1, ""USC"Для устройства на инкассатора нужны водительские права.");

            Dialog
            (
                playerid, 1812, DIALOG_STYLE_MSGBOX,
                ""BR""SERVER_NAME" {FFFFFF}-> Инкассатор",
                "{FAD201}Инкассатор{FFFFFF} - сотрудник банка, занимающийся транспортировкой денежных средств\n"\
                "и других драгоценностей по нуждам банка или его клиентов\n\n"\
                "Для трудоустройства инкассатором Вам необходимо иметь {FAD201}15 игровой уровень{FFFFFF}\n"\
                "и {FAD201}лицензию на оружие{FFFFFF}. Помните, что инкассация это командная работа:\n"\
                "перед началом работы Вам необходимо найти напарников и принять заказ вместе с ними. \n"\
                "Более подробно с работой Вы сможете ознакомиться в любом из {FAD201}Банков{FFFFFF} или\n"\
                "в {FAD201}списке команд {FFFFFF}(/mn >> Список команд).\n\n"\
                "Если Вы готовы трудоустроиться нажмите - {FAD201}далее.",
                "Далее",
                "Отмена"
            );

            SetPVarInt(playerid, "d_c_1", 1);
        }
        else DeletePVar(playerid, "d_c_1");
    }
    if(dialogid == 1813)
    {
        if(response)
        {
            new text[584];
            switch(listitem)
            {

                case 0:
                {
                          new playertextt[54], exp[124], order[194];

                        switch(player_collector[playerid][rang_collector])
                        {
                            case 1:
                            {
                                format(exp, sizeof exp, "{FAD201}3. {FFFFFF}Необходимое количество навыков для открытия следующего класса: {FAD201}%d/%d{FFFFFF}\n",
                                player_collector[playerid][exp_rang_collector], COUNT_EXP_FOR_2_RANG);

                                format(order, sizeof order, "- %s\n- %s", name_order_type[0], name_order_type[1]);
                            }
                            case 2:
                            {
                                format(exp, sizeof exp, "{FAD201}3. {FFFFFF}Необходимое количество навыков для открытия следующего класса: {FAD201}%d/%d{FFFFFF}\n",
                                player_collector[playerid][exp_rang_collector], COUNT_EXP_FOR_3_RANG);
                                format(order, sizeof order, "- %s\n- %s\n- %s\n- %s", name_order_type[0], name_order_type[1], name_order_type[2], name_order_type[3]);
                            }
                            case 3:
                            {
                                format(exp, sizeof exp, "{FAD201}3. {FFFFFF}Достигнут максимальный уровень инкассатора\n");
                                format(order, sizeof order, "- %s\n- %s\n- %s\n- %s\n- %s\n- %s", name_order_type[0], name_order_type[1], name_order_type[2], name_order_type[3], name_order_type[4], name_order_type[5]);
                            } 
                        }

                        format(playertextt, sizeof playertextt, ""BR""SERVER_NAME"{FFFFFF}-> Личная карточка игрока %s", GetPlayerNameEx(playerid));

                        format
                        (
                            text, sizeof text, 
                            "{FAD201}1. {FFFFFF}Занимаемая должность: {FAD201}Инкассатор %d класса{FFFFFF}\n"\
                            "{FAD201}2. {FFFFFF}Текущий навык инкассатора: {FAD201}%d{FFFFFF}\n"\
                            "%s\n"\
                            "{FAD201}4. {FFFFFF}Доступные заказы:\n"\
                            "%s",
                            player_collector[playerid][rang_collector], player_collector[playerid][exp_rang_collector], exp, order
                        );

                        Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, playertextt, text, "Назад", "Закрыть");         
                }
                case 1:
                {
                    if(player_collector[playerid][order_collector] == -1)
                        return SendClientMessage(playerid, -1, ""USC" У вас нет заказа.");

                    new id = player_collector[playerid][order_collector], distance;

                    distance = DistancePointToPoint(orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1], orders_collectors[id][orders_start_point][2],
                    orders_collectors[id][orders_end_point][0], orders_collectors[id][orders_end_point][1], orders_collectors[id][orders_end_point][2]);

                    format
                    (
                        text, sizeof text,
                        "{FAD201}1. {FFFFFF}Название заказа: {FAD201}%s{FFFFFF}\n"\
                        "{FAD201}2. {FFFFFF}Начальная точка заказа: {FAD201}%s{FFFFFF}\n"\
                        "{FAD201}3. {FFFFFF}Конечная точка заказа: {FAD201}%s{FFFFFF}\n"\
                        "{FAD201}4. {FFFFFF}Расстояние между точками: {FAD201}%d\n"\
                        "{FAD201}4. {FFFFFF}Напарник: {FAD201}%s",
                        name_order_type[orders_collectors[id][orders_type]-1],
                        name_place_order[orders_collectors[id][place_start]-1],
                        name_place_order[orders_collectors[id][place_end]-1],
                        distance, GetPlayerNameEx(player_collector[playerid][player_partner])
                    );
                    Dialog(playerid, -1, DIALOG_STYLE_MSGBOX, ""BR""SERVER_NAME"{FFFFFF}-> Данные о текущем заказе", text, "Назад", "Закрыть");     
                }
            }
        }
    }
    if(dialogid == 1814)
    {
        if(response)
        {
            new vehicle, money, spawn = -1;

            if(player_collector[playerid][player_partner] == -1)
                return SendClientMessage(playerid, -1, ""USC" Сначало найдите напарника.");

            if(player_collector[playerid][rang_collector] < listitem+1) return SendClientMessage(playerid, -1, ""USC" Ваш ранг не позволяет взять этот транспорт.");
        
            for(new i;i < sizeof coord_arenda_c;i++)
            {
                if(!IsPlayerInDynamicArea(playerid, sphere_arenda_collector[i])) continue;
               // spawn = playerid;
            }

            if(spawn == -1) return SendClientMessage(playerid, -1, ""USC" Ошибка! Выберите снова");

            switch(listitem)
            {
                case 0:
                {
                    vehicle = CreateVehicle(427, coord_arenda_spawn[spawn][0], coord_arenda_spawn[spawn][1], coord_arenda_spawn[spawn][2], coord_arenda_spawn[spawn][3], 1, 1, -1);
                    money = 25000;
                }
                case 1:
                {
                    vehicle = CreateVehicle(428, coord_arenda_spawn[spawn][0], coord_arenda_spawn[spawn][1], coord_arenda_spawn[spawn][2], coord_arenda_spawn[spawn][3], 1, 1, -1);
                    money = 25000;
                }
                case 2:
                {
                    vehicle = CreateVehicle(482, coord_arenda_spawn[spawn][0], coord_arenda_spawn[spawn][1], coord_arenda_spawn[spawn][2], coord_arenda_spawn[spawn][3], 1, 1, -1);
                    money = 25000;
                }
            }

            new p = player_collector[playerid][player_partner];

            SetPlayerVirtualWorld(playerid, 0);
            SetPlayerInterior(playerid, 0);
            
            SetPlayerVirtualWorld(p, 0);
            SetPlayerInterior(p, 0);

            GivePlayerMoneyEx(playerid, -money);

            PutPlayerInVehicle(playerid, vehicle, 0);
            PutPlayerInVehicle(p, vehicle, 1);

        }
    }
    if(dialogid == 1815)
    {
        if(response)
        {
            if(GetPVarInt(playerid, "c_q_d_1"))
            {
                if(player_collector[playerid][c_quest_progress_1])
                    return SendClientMessage(playerid, -1, ""USC" Вы уже начинали это задание.");

                SendClientMessage(playerid, -1, ""SC"Вы начали выполнять задание {FAD201}\"Вместе веселеe\"");
                player_collector[playerid][c_quest_progress_1] = 1;
                DeletePVar(playerid, "c_q_d_1");
                CallLocalFunction("OnPlayerEnterDynamicArea", "ii", playerid, sphere_collector);
                return 1;
            }
            else if(GetPVarInt(playerid, "c_q_d_2"))
            {
                if(player_collector[playerid][c_quest_progress_2])
                    return SendClientMessage(playerid, -1, ""USC" Вы уже начинали это задание.");

                SendClientMessage(playerid, -1, ""SC"Вы начали выполнять задание {FAD201}\"Достойный инкассатор\"");
                player_collector[playerid][c_quest_progress_2] = 1;
                DeletePVar(playerid, "c_q_d_2");
                CallLocalFunction("OnPlayerEnterDynamicArea", "ii", playerid, sphere_collector);
                return 1;
            }
            else if(GetPVarInt(playerid, "c_q_d_3"))
            {
                if(player_collector[playerid][c_quest_progress_3])
                    return SendClientMessage(playerid, -1, ""USC" Вы уже начинали это задание.");

                SendClientMessage(playerid, -1, ""SC"Вы начали выполнять задание {FAD201}\"Это высокая позиция\"");
                player_collector[playerid][c_quest_progress_3] = 1;
                DeletePVar(playerid, "c_q_d_3");
                CallLocalFunction("OnPlayerEnterDynamicArea", "ii", playerid, sphere_collector);
                return 1;
            }

            switch(listitem)
            {
                case 0:
                {
                    Dialog
                    (
                        playerid, 1815, DIALOG_STYLE_MSGBOX,
                        ""BR" "SERVER_NAME" {FFFFFF}| Вместе веселее",
                        "Каждый раз, при входе на смену, инкассаторы стремятся найти достойного напарника.\n"\
                        "Мы искренне надеемся, что в нашем отделе этот напарник Вы. Вам необходимо доказать это!\n\n"\
                        "Ваша задача: {FAD201}выполнить разные заказы не менее чем с двумя напарниками.\n"\
                        "{FFFFFF}Награда: {FAD201}5.000 рублей.",
                        "Далее", "Назад"
                    );

                    SetPVarInt(playerid, "c_q_d_1", 1);
                }
                case 1:
                {
                    Dialog
                    (
                        playerid, 1815, DIALOG_STYLE_MSGBOX,
                        ""BR" "SERVER_NAME" {FFFFFF}| Достойный инкассатор",
                        "Инкассатор - это не должность. Это призвание. Каждый инкассатор старается работать\n"\
                        "достойно, отдавая делу всего себя. Вам необходимо доказать, что Вы - один из самых\n"\
                        "достойнейших инкассаторов!\n\n"\
                        "Ваша задача: {FAD201}выполнить не менее 5 заказов за день.\n"\
                        "{FFFFFF}Награда: {FAD201}5.000 рублей.",
                        "Далее", "Назад"
                    );

                    SetPVarInt(playerid, "c_q_d_2", 1);
                }
                case 2:
                {
                    Dialog
                    (
                        playerid, 1815, DIALOG_STYLE_MSGBOX,
                        ""BR" "SERVER_NAME" {FFFFFF}| Это высокая позиция",
                        "Приятно каждый раз находиться на вершине списка, быть лучше и круче остальных.\n"\
                        "Каждый из инкассаторов может стать идеалом в своей сфере, может занять самую высокую позицию.\n"\
                        "Для этого необходимо каждый день усердно работать.\n\n"\
                        "Ваша задача: {FAD201}заработать 10 очков рейтинга за 24 часа\n"\
                        "Напарники могут быть разными.{FFFFFF}Награда: {FAD201}10.000 рублей.",
                        "Далее", "Назад"
                    );

                    SetPVarInt(playerid, "c_q_d_3", 1);
                }
            }
        }
        else
        {
            if(GetPVarInt(playerid, "c_q_d_1")) DeletePVar(playerid, "c_q_d_1");
            if(GetPVarInt(playerid, "c_q_d_2")) DeletePVar(playerid, "c_q_d_2");
            if(GetPVarInt(playerid, "c_q_d_3")) DeletePVar(playerid, "c_q_d_3");
            CallLocalFunction("OnPlayerEnterDynamicArea", "ii", playerid, sphere_collector);
        }
    }
    #if defined col_OnDialogResponse
return col_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
#endif
}
#if defined _ALS_OnDialogResponse
#undef OnDialogResponse
#else
#define _ALS_OnDialogResponse
#endif
#define OnDialogResponse col_OnDialogResponse
#if defined col_OnDialogResponse
forward col_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnGameModeInit()
{
    LoadCollectorJob();
    
    SetTimer("UpdateOrderListCollector", 1000*60, true);
    #if defined col_OnGameModeInit
        return col_OnGameModeInit();
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit col_OnGameModeInit
#if defined col_OnGameModeInit
    forward col_OnGameModeInit();
#endif

public OnPlayerEnterDynamicArea(playerid, areaid)
{
    if(areaid == sphere_collector)
    {
        DialogCollector
        (
            playerid, 1811, DIALOG_STYLE_TABLIST_HEADERS,
            ""BR""SERVER_NAME"{FFFFFF}-> Инкассация",
            ""BR"##\t"BR"Наименование\t{979595}Доступное действие\n"\
            ""BR"#1\t{FFFFFF}Информация\t{979595}нажмите для взаимодействия\n"\
            ""BR"#2\t{FFFFFF}Начать/Закончить рабочий день\t{979595}нажмите для взаимодействия\n"\
            ""BR"#3\t{FFFFFF}Рейтинг лучших инкассаторов\t{979595}нажмите для взаимодействия\n"\
            ""BR"#4\t{FFFFFF}Ежедневные задания инкассаторов\t{979595}нажмите для взаимодействия\n"\
            ""BR"#5\t{FFFFFF}Личная карточка\t{979595}нажмите для взаимодействия",
            "Выбрать", "Отмена"
        );

        return 1;
    }
    if(sphere_arenda_collector[0] <= areaid <= sphere_arenda_collector[3])
    {
        if(player_collector[playerid][player_partner] == -1)
            return SendClientMessage(playerid, -1, ""USC"Сначало найдите напарника. /colinv [ID]");

        if(player_collector[playerid][order_collector] != -1)
            return SendClientMessage(playerid, -1, ""USC"У вас есть активное задание. Аренда транспорта невозможна.");

        DialogCollector
        (
            playerid, 1814, DIALOG_STYLE_TABLIST_HEADERS,
            ""BR""SERVER_NAME"{FFFFFF}-> Инкассация",
            ""BR"##\t"BR"Наименование\t"BR"Стоимость аренды\t{979595}Доступность\n"\
            ""BR"#1.\t{FFFFFF}Газель \"Инкассация\"\t{FFFFFF}25.000 рублей\t{979595}1\n"\
            ""BR"#3.\t{FFFFFF}Volkwagen Multivan T6\t{FFFFFF}25.000 рублей\t{979595}2\n"\
            ""BR"#2.\t{FFFFFF}Mersedes-Benz V-Class\t{FFFFFF}25.000 рублей\t{979595}3",
            "Выбрать", "Отмена"
        );

        return 1;
    }
    if(player_collector[playerid][order_collector] != -1)
    {
        new order = player_collector[playerid][order_collector];

        new partner = player_collector[playerid][player_partner];
                
        if(areaid == orders_collectors[order][order_sphere_start])
        {
            if(orders_collectors[order][progress_order] != 1) return 1;
            if(orders_collectors[order][collector_id_collector] != playerid)
                return SendClientMessage(playerid, -1, ""USC"Водитель {FFFFFF}не может брать {FAD201}денежные средства.");

            if(IsPlayerInAnyVehicle(playerid))
                return SendClientMessage(playerid, -1, ""USC"Выйдите из транспорта чтобы взять{FAD201} денежные средства.");

            SendClientMessage(playerid, -1, ""SC" Вы успешно взяли денежные средства. Отправляйтесь в {FAD201}инкассационный автомобиль.");

            orders_collectors[order][progress_order]++;

            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 1.0, 1, 0, 0, 0, 2000);

            SetPlayerAttachedObject(playerid, 9, 1210, 5, 0.299999,0.099999,0.000000,0.000000,-83.000000,0.000000,1.000000,1.000000,1.000000); 

            if(IsValidDynamicArea(orders_collectors[order][order_sphere_start])) DestroyDynamicArea(orders_collectors[order][order_sphere_start]);
            if(IsValidDynamic3DTextLabel(orders_collectors[order][order_s_3dtext])) DestroyDynamic3DTextLabel(orders_collectors[order][order_s_3dtext]);


            SetPlayerCheckpoint(playerid, orders_collectors[order][orders_end_point][0], orders_collectors[order][orders_end_point][1], orders_collectors[order][orders_end_point][2], 5.0);
            SetPlayerCheckpoint(partner, orders_collectors[order][orders_end_point][0], orders_collectors[order][orders_end_point][1], orders_collectors[order][orders_end_point][2], 5.0);              
            ShowPlayerGPS(playerid, orders_collectors[order][orders_end_point][0], orders_collectors[order][orders_end_point][1]);
            ShowPlayerGPS(partner, orders_collectors[order][orders_end_point][0], orders_collectors[order][orders_end_point][1]); 
            CreateSmallGangZoneForCollector(playerid, orders_collectors[order][orders_end_point][0], orders_collectors[order][orders_end_point][1]);
            CreateSmallGangZoneForCollector(partner, orders_collectors[order][orders_end_point][0], orders_collectors[order][orders_end_point][1]);
           
        }
        if(areaid == orders_collectors[order][order_sphere_end])
        {
            if(orders_collectors[order][progress_order] != 2) return 1;

            if(!IsPlayerInDynamicArea(playerid, orders_collectors[order][order_sphere_end])) return 0;

            if(IsPlayerInAnyVehicle(playerid))
                return SendClientMessage(playerid, -1, ""USC"Выйдите из транспорта чтобы взять{FAD201} денежные средства.");


            ApplyAnimation(playerid, "BOMBER", "BOM_Plant", 1.0, 1, 0, 0, 0, 2000);
            RemovePlayerAttachedObject(playerid, 9);
            SendClientMessage(playerid, -1, ""SC" Заказ успешно выполнен, отправляйтесь к {FAD201}Банку {FFFFFF}для просмотра новых заказов.");
            SendClientMessage(partner, -1, ""SC" Заказ успешно выполнен, отправляйтесь к {FAD201}Банку {FFFFFF}для просмотра новых заказов.");

            new salary;

            switch(orders_collectors[order][orders_type])
            {
                case 1,2:salary = 1500000 + random(250000); 
                case 3,4:salary = 1800000 + random(270000);
                case 5,6:salary = 2000000 + random(310000);
            }

  //          if(g_doubling[DOUBLING_WAGE]) salary = salary * 2;

            new salary_driver = salary - player_collector[orders_collectors[order][collector_id_driver]][fine_driver];

            GivePlayerMoneyEx(orders_collectors[order][collector_id_collector], salary);
            GivePlayerMoneyEx(orders_collectors[order][collector_id_driver], salary);

            new text[248], text_1[18];

            format(text, sizeof text, "Вы получили %d рублей", salary);
            format(text_1, sizeof text_1, "Вы получили %d рублей", salary_driver);

            ShowNotification(orders_collectors[order][collector_id_collector], 2, text, 3, "", "");
            ShowNotification(orders_collectors[order][collector_id_driver], 2, text_1, 3, "", "");

            ShowNotificationMisters(playerid, 1, 6, 0, 0, "Вы успешно доставили груз", "");
            ShowNotificationMisters(partner, 1, 6, 0, 0, "Вы успешно доставили груз", "");
            EndOrderCollector(playerid, partner, true);

            if(player_collector[playerid][c_quest_progress_1] ||player_collector[partner][c_quest_progress_1])
            {
                if(player_collector[playerid][c_quest_progress_1])
                {
                    player_collector[playerid][c_quest_count_1]++;

                    format(text, sizeof text, "Вы выполнили {FAD201}%d{FFFFFF} из {FAD201}2{FFFFFF} для выполнения задания {FAD201}Вместе веселее",
                    player_collector[playerid][c_quest_count_1]);
                    SendClientMessage(playerid, -1, text);
                } 
                if(player_collector[partner][c_quest_progress_1])
                {
                    player_collector[partner][c_quest_count_1]++;

                    format(text, sizeof text, "Вы выполнили {FAD201}%d{FFFFFF} из {FAD201}2{FFFFFF} для выполнения задания {FAD201}Вместе веселее",
                    player_collector[partner][c_quest_count_1]);
                    SendClientMessage(partner, -1, text);
                } 

                if(player_collector[playerid][c_quest_count_1] >= 2 ||player_collector[partner][c_quest_count_1] >= 2)
                {
                    if(player_collector[playerid][c_quest_count_1] >= 2)
                    {
                        player_collector[playerid][c_quest_progress_1] = 2;
                        GivePlayerMoney(playerid, 5000);

                        format(text, sizeof text, "Вы успешно выполнили ежедневное задание {FAD201}Вместе веселее",
                        player_collector[playerid][c_quest_count_1]);
                        SendClientMessage(playerid, -1, text);
                        SendClientMessage(playerid, -1, ""SC" Вам начислено {FAD201}5000{FFFFFF} рублей за выполнение задания.");
                    }
                    if(player_collector[partner][c_quest_count_1] >= 2)
                    {
                        player_collector[partner][c_quest_progress_1] = 2;
                        GivePlayerMoney(partner, 5000);

                        format(text, sizeof text, "Вы успешно выполнили ежедневное задание {FAD201}Вместе веселее",
                        player_collector[partner][c_quest_count_1]);
                        SendClientMessage(partner, -1, text);
                        SendClientMessage(partner, -1, ""SC" Вам начислено {FAD201}5000{FFFFFF} рублей за выполнение задания.");  
                    } 
                }
            }

            if(player_collector[playerid][c_quest_progress_2] ||player_collector[partner][c_quest_progress_2])
            {
                if(player_collector[playerid][c_quest_progress_2])
                {
                    player_collector[playerid][c_quest_count_2]++;

                    format(text, sizeof text, "Вы выполнили {FAD201}%d{FFFFFF} из {FAD201}5{FFFFFF} для выполнения задания {FAD201}Достойный инкассатор",
                    player_collector[playerid][c_quest_count_2]);
                    SendClientMessage(playerid, -1, text);  
                } 
                if(player_collector[partner][c_quest_progress_2])
                {
                    player_collector[partner][c_quest_count_2]++;

                    format(text, sizeof text, "Вы выполнили {FAD201}%d{FFFFFF} из {FAD201}5{FFFFFF} для выполнения задания {FAD201}Достойный инкассатор",
                    player_collector[partner][c_quest_count_2]);
                    SendClientMessage(partner, -1, text);  
                } 

                if(player_collector[playerid][c_quest_count_2] >= 5 ||player_collector[partner][c_quest_count_2] >= 5)
                {
                    if(player_collector[playerid][c_quest_count_2] >= 5)
                    {
                        player_collector[playerid][c_quest_progress_2] = 2;

                        GivePlayerMoney(playerid, 5000);

                        format(text, sizeof text, "Вы успешно выполнили ежедневное задание {FAD201}Достойный инкассатор",
                        player_collector[playerid][c_quest_count_1]);
                        SendClientMessage(playerid, -1, text);
                        SendClientMessage(playerid, -1, ""SC" Вам начислено {FAD201}5000{FFFFFF} рублей за выполнение задания.");
                    }
                    if(player_collector[partner][c_quest_count_2] >= 5)
                    {
                        player_collector[partner][c_quest_progress_2] = 2;

                        GivePlayerMoney(partner, 5000);

                        format(text, sizeof text, "Вы успешно выполнили ежедневное задание {FAD201}Достойный инкассатор",
                        player_collector[partner][c_quest_count_1]);
                        SendClientMessage(partner, -1, text);
                        SendClientMessage(partner, -1, ""SC" Вам начислено {FAD201}5000{FFFFFF} рублей за выполнение задания.");
                    } 
                }
            }

            SendClientMessage(playerid, -1, ""SC"Вам был начислен {FAD201}1 {FFFFFF}опыт инкассатора.");
            SendClientMessage(partner, -1, ""SC"Вам был начислен {FAD201}1 {FFFFFF}опыт инкассатора.");
            player_collector[playerid][exp_rang_collector]++;
            player_collector[partner][exp_rang_collector]++;

            new database_txt[84];

            mysql_format(mysql, database_txt, sizeof database_txt, "UPDATE accounts SET exp_collector=%d WHERE id=%d", player_collector[playerid][exp_rang_collector], GetPlayerAccountID(playerid));
            mysql_query(mysql, database_txt, false);

            mysql_format(mysql, database_txt, sizeof database_txt, "UPDATE accounts SET exp_collector=%d WHERE id=%d", player_collector[partner][exp_rang_collector], GetPlayerAccountID(partner));
            mysql_query(mysql, database_txt, false);

            if(mysql_errno()) return print("[COLLECTOR_SYSTEM] Error Sql Query: №2");


            if(player_collector[playerid][exp_rang_collector] >= 150 && player_collector[playerid][rang_collector] == 1) player_collector[playerid][rang_collector] = 2;
            else if(player_collector[playerid][exp_rang_collector] >= 300 && player_collector[playerid][rang_collector] == 2) player_collector[playerid][rang_collector] = 3;
            
            
            if(player_collector[partner][exp_rang_collector] >= 150 && player_collector[partner][rang_collector] == 1) player_collector[partner][rang_collector] = 2;
            else if(player_collector[partner][exp_rang_collector] >= 300 && player_collector[partner][rang_collector] == 2) player_collector[partner][rang_collector] = 3;

            if(player_collector[playerid][c_quest_progress_3] || player_collector[partner][c_quest_progress_3])
            {
                if(player_collector[playerid][c_quest_progress_3])
                {
                    player_collector[playerid][c_quest_count_3]++;

                    format(text, sizeof text, "Вы выполнили {FAD201}%d{FFFFFF} из {FAD201}10{FFFFFF} для выполнения задания {FAD201}Это высокая позиция",
                    player_collector[playerid][c_quest_count_3]);
                    SendClientMessage(playerid, -1, text);  
                } 
                if(player_collector[partner][c_quest_progress_3])
                {
                    player_collector[partner][c_quest_count_3]++;

                    format(text, sizeof text, "Вы выполнили {FAD201}%d{FFFFFF} из {FAD201}10{FFFFFF} для выполнения задания {FAD201}Это высокая позиция",
                    player_collector[partner][c_quest_count_3]);
                    SendClientMessage(partner, -1, text);    
                } 

                if(player_collector[playerid][c_quest_count_3] >= 5 ||player_collector[partner][c_quest_count_3] >= 5)
                {
                    if(player_collector[playerid][c_quest_count_3] >= 5)
                    {
                        player_collector[playerid][c_quest_progress_3] = 2;

                        GivePlayerMoney(playerid, 10000);

                        format(text, sizeof text, "Вы успешно выполнили ежедневное задание {FAD201}Это высокая позиция",
                        player_collector[playerid][c_quest_count_1]);
                        SendClientMessage(playerid, -1, text);
                        SendClientMessage(playerid, -1, ""SC" Вам начислено {FAD201}10000{FFFFFF} рублей за выполнение задания.");
                    }
                    if(player_collector[partner][c_quest_count_3] >= 5)
                    {
                        player_collector[partner][c_quest_progress_3] = 2;

                        GivePlayerMoney(partner, 10000);

                        format(text, sizeof text, "Вы успешно выполнили ежедневное задание {FAD201}Это высокая позиция",
                        player_collector[partner][c_quest_count_1]);
                        SendClientMessage(partner, -1, text);
                        SendClientMessage(partner, -1, ""SC" Вам начислено {FAD201}10000{FFFFFF} рублей за выполнение задания.");
                    } 
                }
            }            
        }
    }
    #if defined col_OnPlayerEnterDynamicArea
        return col_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
    #else
        return 0;
    #endif
}
   #if defined _ALS_OnPlayerEnterDynamicArea
    #undef OnPlayerEnterDynamicArea
#else
    #define _ALS_OnPlayerEnterDynamicArea
#endif
#define OnPlayerEnterDynamicArea col_OnPlayerEnterDynamicArea
#if defined col_OnPlayerEnterDynamicArea
    forward col_OnPlayerEnterDynamicArea(playerid, STREAMER_TAG_AREA:areaid);
#endif

public OnPlayerExitVehicle(playerid, vehicleid)
{
    if(player_collector[playerid][order_collector] != -1)
    {
        new id = player_collector[playerid][order_collector];

        if(vehicleid == orders_collectors[id][collector_vehicle])
        {  
            if(orders_collectors[id][progress_order] == 2)
            {
                SendClientMessage(playerid, -1, ""SC" У вас есть {FAD201}180 {FFFFFF}секунд чтобы сесть обратно в транспорт.");
                player_collector[playerid][second_c] = 180;
                player_collector[playerid][timer_c] = SetTimerEx("GameTextCollector", 1000, true, "i", playerid);
            } 
            else
            {
                SendClientMessage(playerid, -1, ""SC" У вас есть {FAD201}60 {FFFFFF}секунд чтобы сесть обратно в транспорт.");
                player_collector[playerid][second_c] = 60;
                player_collector[playerid][timer_c] = SetTimerEx("GameTextCollector", 1000, true, "i", playerid);              
            }
        }
    }
    #if defined col_OnPlayerExitVehicle
        return col_OnPlayerExitVehicle(playerid, vehicleid);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerExitVehicle
    #undef OnPlayerExitVehicle
#else
    #define _ALS_OnPlayerExitVehicle
#endif
#define OnPlayerExitVehicle col_OnPlayerExitVehicle
#if defined col_OnPlayerExitVehicle
    forward col_OnPlayerExitVehicle(playerid, vehicleid);
#endif

public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger)
{
    if(IsPlayerLogged(playerid) || IsPlayerConnected(playerid))
    {
        if(player_collector[playerid][order_collector] != -1)
        {
            new id = player_collector[playerid][order_collector];

            if(vehicleid == orders_collectors[id][collector_vehicle])
            {   
                KillTimer(player_collector[playerid][timer_c]);
            }
        }
    }
    #if defined col_OnPlayerEnterVehicle
        return col_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
    #else
        return 1;
    #endif
}
   #if defined _ALS_OnPlayerEnterVehicle
    #undef OnPlayerEnterVehicle
#else
    #define _ALS_OnPlayerEnterVehicle
#endif
#define OnPlayerEnterVehicle col_OnPlayerEnterVehicle
#if defined col_OnPlayerEnterVehicle
    forward col_OnPlayerEnterVehicle(playerid, vehicleid, ispassenger);
#endif

public OnVehicleDamageStatusUpdate(vehicleid, playerid)
{
    if(GetVehicleParam(vehicleid, V_ENGINE) == VEHICLE_PARAM_ON && GetPlayerData(playerid, P_IMPROVEMENTS) < 4)
    {
        if(player_collector[playerid][job_active])
        {
            if(player_collector[playerid][order_collector] != -1)
            {
                new id = player_collector[playerid][order_collector];

                if(orders_collectors[id][collector_vehicle] == vehicleid)
                {
                    SendClientMessage(playerid, -1, ""SC" Вы повредили рабочий транспорт, к Вам будет пременён штраф по окончанию выполнения заказа.");
                    player_collector[playerid][fine_driver] += 300;
                    return 1;
                }
            }
        }
    }
	#if defined col_OnVehicleDamageStatusUp
		return col_OnVehicleDamageStatusUp(vehicleid, playerid);
	#else
	    return 0;
	#endif
}
#if defined _ALS_OnVehicleDamageStatusUp
    #undef OnVehicleDamageStatusUpdate
#else
    #define _ALS_OnVehicleDamageStatusUp
#endif
#if defined col_OnVehicleDamageStatusUp
	forward col_OnVehicleDamageStatusUp(vehicleid, playerid);
#endif
#define	OnVehicleDamageStatusUpdate col_OnVehicleDamageStatusUp

stock LoadCollectorJob()
{
    for(new i;i < 4;i++) CreateDynamicActor(28, place_bank[0], place_bank[1], place_bank[2], place_bank[3], _, _, i+1, 1);

    CreateDynamic3DTextLabel("{FAD201}Начальник службы инкассации\n{FFFFFF}Подойдите для {FAD201}взаимодействия", -1, place_bank[0], place_bank[1], place_bank[2], 10.0);
    sphere_collector = CreateDynamicSphere(place_bank[0], place_bank[1], place_bank[2], 2.0);
    
    for(new i;i < 4;i++)
    {
        CreateActor(28, coord_arenda_c[i][0], coord_arenda_c[i][1], coord_arenda_c[i][2], coord_arenda_c[i][3]);
        CreateDynamic3DTextLabel("{FAD201}Начальник службы автопарка\n{FFFFFF}Подойдите для {FAD201}взаимодействия", -1, coord_arenda_c[i][0], coord_arenda_c[i][1], coord_arenda_c[i][2], 10.0);
        sphere_arenda_collector[i] = CreateDynamicSphere(coord_arenda_c[i][0], coord_arenda_c[i][1], coord_arenda_c[i][2], 2.0);
    }

    for(new i, count[6], type;i < sizeof orders_collectors;i++)
    {
        if(orders_collectors[i][order_type_active] != TYPE_O_C_NOACTIVE) continue;

        type = orders_collectors[i][orders_type] - 1;

        if(count[type] >= 2) continue;

        count[type]++;

        orders_collectors[i][order_type_active] = TYPE_O_C_ACTIVE;
    }
}

CMD:blist(playerid)
{
    if(player_collector[playerid][player_partner] == -1)
        return SendClientMessage(playerid, -1, ""USC"Сначало найдите напарника. (/colinv [id])");

    if(player_collector[playerid][order_collector] != -1)
        return SendClientMessage(playerid, -1, ""USC"Сначало выполните прошлый заказ.");

    new count, dialog[1184] = ""BR"##\t"BR"Тип заказа\t"BR"Расстояние между точками\t"BR"Доступность\n", text[144];

    for(new i, type, distance, class; i < sizeof orders_collectors;i++)
    {
        if(!orders_collectors[i][order_type_active]) continue;

        count++;

        distance = DistancePointToPoint(orders_collectors[i][orders_start_point][0], orders_collectors[i][orders_start_point][1], orders_collectors[i][orders_start_point][2],
        orders_collectors[i][orders_end_point][0], orders_collectors[i][orders_end_point][1], orders_collectors[i][orders_end_point][2]);


        switch(orders_collectors[i][orders_type])
        {
            case 1,2:class = 1;
            case 3,4:class = 2;
            case 5,6:class = 3;
        }

        /*format(text, sizeof text, "");
        valstr(text, distance);
        SendClientMessage(playerid, -1, text);*/

        type = orders_collectors[i][orders_type] - 1;

        format
        (
            text, sizeof text, 
            ""BR"#%d.\t{FFFFFF}%s\t{FFFFFF}%d\t{979595}Инкассатор %d класса\n", 
            count, name_order_type[type], distance, class
        );
        strcat(dialog, text);
        SetPlayerListitemValue(playerid, count, i);
    }

    if(!count) return SendClientMessage(playerid, -1, ""USC" На данный момент заказов нет.");

    DialogCollector(playerid, 1810, DIALOG_STYLE_TABLIST_HEADERS, ""BR"Список заказов", dialog, "Далее", "Назад");

    return 1;
}

CMD:colinv(playerid, params[])
{
    extract params -> new partner;



    if(player_collector[playerid][order_collector] != -1) 
        return ShowNotificationMisters(playerid, 2, 6, 0, 0, "Сначала завершите текущий заказ.", "");

    if(player_collector[playerid][player_partner] != -1)
    {
        player_collector[player_collector[playerid][player_partner]][player_partner] = -1;
        SendClientMessage(player_collector[playerid][player_partner], -1, ""USC" Ваш напарник отказался от вас. Вы больше не напарники.");

        player_collector[playerid][player_partner] = -1;
        ShowNotificationMisters(playerid, 1, 6, 0, 0, "Вы отказались от своего напарника.", "");
        
    }

    if(sscanf(params, "u", params[0]))
    return ShowNotificationMisters(playerid, 2, 6, 0, 0, "Используйте '/colinv' [id игрока].", "");

    if(!IsPlayerLogged(partner) || !IsPlayerConnected(partner)) 
        return ShowNotificationMisters(playerid, 2, 6, 0, 0, "Не игрока с данным ID.", "");

    if(!player_collector[partner][job_active])
        return ShowNotificationMisters(playerid, 2, 6, 0, 0, "Игрок не работает в инкассации.", "");

    if(!player_collector[playerid][job_active])
        return ShowNotificationMisters(playerid, 1, 6, 0, 0, "Вы не искассатор.", "");

    new Float:x, Float:y, Float:z;
    GetPlayerPos(partner, x, y, z);
    new Float:distance = GetPlayerDistanceFromPoint(playerid, x, y, z);

    if(distance >= 7.0) return ShowNotificationMisters(playerid, 2, 6, 0, 0, "Игрок слишком далеко от вас.", "");

    if(player_collector[partner][player_partner] != -1)
        return ShowNotificationMisters(playerid, 2, 6, 0, 0, "У игрока уже есть напарник.", "");

    new text[52];
    format(text, sizeof text, "%s приглашает вас в напарники, /joincoll", GetPlayerNameEx(playerid));

    ShowNotificationMisters(partner, 2, 6, 0, 0, text, "");

    SetPVarInt(partner, "player_partner", playerid);
    return 1;
}

cmd:collist(playerid)
{
    if(!player_collector[playerid][job_active]) return SendClientMessage(playerid, -1, ""USC" Сначало устройтесь на работу инкассатора.");
    
    new list[58], dialog[348], count;

    foreach(new i : Player)
    {
        if(!player_collector[i][job_active]) continue;
        else if(player_collector[i][player_partner] != -1) continue;
        count = true;

        format(list, sizeof list, "Инкассатор %d класса - %s - %d\n", player_collector[i][rang_collector], GetPlayerNameEx(i), 
        GetPlayerPhone(i));
        strcat(dialog, list);
    }

    if(!count) return SendClientMessage(playerid, -1, ""SC" На данный момент свободных инкассаторов нет.");

    Dialog(playerid, -1, DIALOG_STYLE_LIST, ""BR""SERVER_NAME" -> Инкассаторы онлайн", dialog, "Далее", "Назад");

    return 1;
}

cmd:joincoll(playerid)
{
    new partner = GetPVarInt(playerid, "player_partner");
    DeletePVar(playerid, "player_partner");

    player_collector[playerid][player_partner] = partner;
    player_collector[partner][player_partner] = playerid;

    SendClientMessage(partner, -1, ""SC" Игрок согласился. Теперь вы напарники! Садитесь в рабочий транспорт и выполняйте заказы.");
    SendClientMessage(playerid, -1, ""SC" Вы согласились. Теперь вы напарники! Садитесь в рабочий транспорт и выполняйте заказы.");
    SendClientMessage(partner, -1, ""SC" Арендовать транспорт можно в задней частьи территории банка. Чтобы отказаться от напарника введите /colinv");
    SendClientMessage(playerid, -1, ""SC" Арендовать транспорт можно в задней частьи территории банка. Чтобы отказаться от напарника введите /colinv");
    return 1;
}

stock DialogCollector(playerid, dialogid, style, title[], text[], button[], button2[])
{
  if(style == 5)
  {
     ShowPlayerDialog(playerid, 0, DIALOG_STYLE_LIST, "...", "...", "...", ""); 
  }
  ShowPlayerDialog(playerid, dialogid, style, title, text, button, button2);
  return 1;
}

cmd:cmenu(playerid)
{
    
    DialogCollector
    (
        playerid, 1813, DIALOG_STYLE_TABLIST_HEADERS,
        ""BR""SERVER_NAME" {FFFFFF}-> Информация о работе инкассатора",
        ""BR"##\t"BR"Описание\t"BR"Взаимодействие\n"\
        ""BR"#1\t"BR"Личная карточка инкассатора\t"BR"Нажмите для продолжения\n"\
        ""BR"#2\t"BR"Информация о текущем заказе\t"BR"Нажмите для продолжения",
        "Продолжить", "Закрыть"
    );
}

stock DistancePointToPoint(Float: x, Float: y, Float: z, Float: fx, Float:fy, Float: fz) return floatround(floatsqroot(floatpower(fx - x, 2) + floatpower(fy - y, 2) + floatpower(fz - z, 2)));


stock EndOrderCollector(playerid, partner = -1, bool:complete = true)
{
    if(player_collector[playerid][order_collector] != -1)
    {
        new order = player_collector[playerid][order_collector];

        if(!complete)
        {
            if(orders_collectors[order][collector_vehicle] != -1)
            {
                if(IsValidVehicle(orders_collectors[order][collector_vehicle]))
                DestroyVehicle(orders_collectors[order][collector_vehicle]);
            }
        }

        delete_order_collector(order);
    }
    if(player_collector[playerid][player_gang_zone_collector] != -1)
    {
        GangZoneHideForPlayer(playerid, player_collector[playerid][player_gang_zone_collector]);
        GangZoneDestroy(player_collector[playerid][player_gang_zone_collector]);
        player_collector[playerid][player_gang_zone_collector] = -1;
    }
    
    if(partner != -1)
    {
        if(player_collector[partner][player_gang_zone_collector] != -1)
        {
            GangZoneHideForPlayer(partner, player_collector[partner][player_gang_zone_collector]);
            GangZoneDestroy(player_collector[partner][player_gang_zone_collector]);
            player_collector[partner][player_gang_zone_collector] = -1;
        }
    }

    if(!complete)
    {
        player_collector[playerid][job_active]      = false;        
        player_collector[playerid][player_partner]  = -1;
        SetPlayerSkinInit(playerid);

        if(partner != -1)
        {             
            player_collector[partner][job_active]      = false;        
            player_collector[partner][player_partner]  = -1;  
            SetPlayerSkinInit(partner);
        }           
    }

    player_collector[playerid][order_collector] = -1;  
    if(player_collector[playerid][timer_c] != -1) KillTimer(player_collector[playerid][timer_c]);   
    player_collector[playerid][timer_c]         = -1;     
    player_collector[playerid][second_c]        = 0; 

    if(partner != -1)
    {
        if(player_collector[playerid][timer_c] != -1) KillTimer(player_collector[playerid][timer_c]);
        player_collector[partner][order_collector] = -1;                          
        player_collector[partner][timer_c]         = -1;     
        player_collector[partner][second_c]        = 0; 
    }

    return 1;
}

public: GameTextCollector(playerid)
{
    if(player_collector[playerid][second_c] != 0)
    {
        player_collector[playerid][second_c]--;

        new text[56];

        format(text, sizeof text, "~y~%d", player_collector[playerid][second_c]);
        GameTextForPlayer(playerid, text, 900, 3);
    }
    else
    {
        SendClientMessage(playerid, -1, ""USC"Вы не успели сесть в машину. Задание провалено.");
        SendClientMessage(player_collector[playerid][player_partner], -1, ""USC"Партнер не успел сесть в машину. Задание провалено.");
        KillTimer(player_collector[playerid][timer_c]);


        EndOrderCollector(playerid, player_collector[playerid][player_partner], false);
    }
}

public:UpdateOrderListCollector()
{
    new count;

    for(new i;i < MAX_ORDER_COL;i++)
    {
        if(!orders_collectors[i][order_type_active]) continue;

        count++;
    }

    if(count >= 10) return 1;
    else
    {
        for(new i;i < MAX_ORDER_COL;i++)
        {
            if(orders_collectors[i][order_type_active] != TYPE_O_C_NOACTIVE) continue;

            orders_collectors[i][order_type_active] = TYPE_O_C_ACTIVE; 
            break;
        }

        foreach(new i : Player)
        {
            if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
            if(!player_collector[i][job_active]) continue;

            SendClientMessage(i, -1, "{FAD201}| [Диспетчер]: В список заказов добавлен новый заказ: {FAD201}/blist");
        }
    }

    return 1;
}


stock load_order_colllector(id)
{
    new world_s = orders_collectors[id][place_start] - 1;
    new world_e = orders_collectors[id][place_end] - 1;

    if(orders_collectors[id][place_start] == Place_Col_1)
    {
        orders_collectors[id][order_sphere_start] = CreateDynamicSphere(orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1], orders_collectors[id][orders_start_point][2], 
        2.0, 0, 0);

        orders_collectors[id][order_s_3dtext] = CreateDynamic3DTextLabel("{FAD201}Банкомат\n{FFFFFF}Подойдите для взаимодействия", -1, orders_collectors[id][orders_start_point][0], orders_collectors[id][orders_start_point][1], orders_collectors[id][orders_start_point][2], 
        6.0);

    }
    else
    {
        orders_collectors[id][order_sphere_start] = CreateDynamicSphere(place_safe_bank[0], place_safe_bank[1], place_safe_bank[2], 2.0, world_s, 1);

        orders_collectors[id][order_s_3dtext] = CreateDynamic3DTextLabel("{FAD201}Ценный груз\n{FFFFFF}Подойдите для взаимодействия", -1, place_safe_bank[0], place_safe_bank[1], place_safe_bank[2], 
        6.0, _, _, _, world_s, 1);
    } 

    if(orders_collectors[id][place_end] == Place_Col_1)
    {
        orders_collectors[id][order_sphere_end] = CreateDynamicSphere(orders_collectors[id][orders_end_point][0], orders_collectors[id][orders_end_point][1], orders_collectors[id][orders_end_point][2], 
        2.0, 0, 0);

        orders_collectors[id][order_e_3dtext] = CreateDynamic3DTextLabel("{FAD201}Банкомат\n{FFFFFF}Подойдите для взаимодействия", -1, orders_collectors[id][orders_end_point][0], orders_collectors[id][orders_end_point][1], orders_collectors[id][orders_end_point][2], 
        6.0);
    }
    else
    {
        orders_collectors[id][order_sphere_end] = CreateDynamicSphere(place_safe_bank[0], place_safe_bank[1], place_safe_bank[2], 2.0, world_e);

        orders_collectors[id][order_e_3dtext] = CreateDynamic3DTextLabel("{FAD201}Ценный груз\n{FFFFFF}Подойдите для взаимодействия", -1, place_safe_bank[0], place_safe_bank[1], place_safe_bank[2], 
        6.0, _, _, _, world_e, 1);
    } 

    return 1;
}

stock delete_order_collector(id)
{
    orders_collectors[id][order_type_active]      = TYPE_O_C_NOACTIVE;               
    orders_collectors[id][collector_id_driver]    = -1;       
    orders_collectors[id][collector_id_collector] = -1;           
    orders_collectors[id][progress_order]         = 0;   
    orders_collectors[id][collector_vehicle]      = -1;   

    if(IsValidDynamicArea(orders_collectors[id][order_sphere_start]) && IsValidDynamicArea(orders_collectors[id][order_sphere_end]))
    {
        DestroyDynamicArea(orders_collectors[id][order_sphere_start]);
        DestroyDynamicArea(orders_collectors[id][order_sphere_end]);

        orders_collectors[id][order_sphere_end]     = -1;       
        orders_collectors[id][order_sphere_start]   = -1;               
    }

    if(IsValidDynamic3DTextLabel(orders_collectors[id][order_s_3dtext])) DestroyDynamic3DTextLabel(orders_collectors[id][order_s_3dtext]);
    if(IsValidDynamic3DTextLabel(orders_collectors[id][order_e_3dtext])) DestroyDynamic3DTextLabel(orders_collectors[id][order_e_3dtext]);

    orders_collectors[id][order_s_3dtext] = Text3D:-1;
    orders_collectors[id][order_e_3dtext] = Text3D:-1;
}
stock CreateSmallGangZoneForCollector(playerid, Float:x, Float:y)
{
    // Удаляем старую гангзону если есть
    if(player_collector[playerid][player_gang_zone_collector] != -1)
    {
        GangZoneHideForPlayer(playerid, player_collector[playerid][player_gang_zone_collector]);
        GangZoneDestroy(player_collector[playerid][player_gang_zone_collector]);
    }
    
    // Создаем маленькую гангзону (размер 50x50 метров - как метка)
    new Float:size = 25.0; // радиус метки (можно изменить на 15.0 или 35.0)
    
    player_collector[playerid][player_gang_zone_collector] = GangZoneCreate(
        x - size, // минимальный X
        y - size, // минимальный Y
        x + size, // максимальный X
        y + size  // максимальный Y
    );
    
    // Показываем гангзону игроку (желтый цвет с прозрачностью)
    GangZoneShowForPlayer(playerid, player_collector[playerid][player_gang_zone_collector], 0x00FFFFFF );
    GangZoneFlashForPlayer(playerid, player_collector[playerid][player_gang_zone_collector], 0xFF00EAFF); // Фиолетовый цвет для мигания
    //                                                                                       ^^^^^^^^^ 
    //                                                                                       Цвет: желтый полупрозрачный
    
    return 1;
}