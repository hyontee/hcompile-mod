#define T_NONE		0
#define	T_MONEY		1 
#define	T_LIC		2
#define	T_VIP		3
#define	T_CAR		4 
#define	T_GUN		5
#define	T_EXP		6
#define	T_DONATE	7
#define	T_SLOT		8 

enum R_STRUCT
{
	R_TYPE,
	R_NAME_TXD[48],
	R_NAME_TEXT[48], 
    R_NAME_PRIZE[48],
	R_COUNT
}

enum WELSI_BLYAT
{ 
    last_player_name[24],
    id_ruletka_prize
};

new last_player_td[3][4] =
{
    {6,5,7,8},
    {11,9,10,12},
    {15,13,14,16}
};
new Text:casesda_TD[10];
new typecase[MAX_PLAYERS];
new Text:invdo_TD[24];
new last_player_ruletka[3][WELSI_BLYAT] =
{
    {"Nick_Name", 0},
    {"Nick_Name", 0},
    {"Nick_Name", 0}
};
 
new ruletka_prize[12][R_STRUCT] =//раставлено в порядке:чем меньше [] тем реже
{
    {T_CAR, "txd:brgiftsuncar", 	"Toyota_Mark_2", "Toyota Mark II",		547},
	{T_CAR, "txd:brgiftsuncar", 	"Ford_Mustang", "Ford Mustang GT",			603},
	{T_DONATE, "txd:brgiftsdonate", 		"до_150_донат-руб.", "до 150 донат-руб", 150},
    {T_MONEY, "txd:brgiftscash", 	"љo_500000_p.", "до 500000 рублей",		500000},
	{T_SLOT, "txd:brgiftsfreeslot", 		"Слот_для_транспорта", 	"Слот для транспорта",	1},
    {T_VIP, "txd:brgiftsgvip", 		"Gold-Vip", "GOLD-VIP на 15 дней",			3},
    {T_LIC, "txd:brgiftslic", 		"ЊaЈka_c_ћњ e®џњ¬Їњ", 	"Пакет с лицензиями",	1},
    {T_MONEY, "txd:brgiftscash", 	"љo_100000_p.",  "до 100000 рублей",	100000},
    {T_GUN, "txd:brgiftsgun", 		"Cћy¤aќ®oe_opy›њe", 	"Случайное оружие",	25},
    {T_EXP, "txd:brgiftsexp", 	"15_EXP",  "15 EXP", 15},
    {T_EXP, "txd:brgiftsexp", 	"3_EXP",  "3 EXP", 3},
    {T_EXP, "txd:brgiftsexp", 	"1_EXP",  "1 EXP", 1}
};

new player_roulette_bronz[MAX_PLAYERS];
new menu_prize_player[MAX_PLAYERS][5];
new ruletka_count[MAX_PLAYERS];
new bool:animation_player[MAX_PLAYERS]; 
new timer_player_ruletka[MAX_PLAYERS];
new Text:welsirltk_TD[35];
new PlayerText:ruletka_PTD[MAX_PLAYERS][5];
new PlayerText:ruletka_PTD_t[MAX_PLAYERS][18];
new td_prize[12][2] = 
{
    {5,6},
    {9,10},
    {11,12},
    {13,14},
    {15,16},
    {17,18},
    {19,20},
    {21,22},
    {23,24},
    {25,26},
    {27,28},
    {29,30}
};

#define T_NONE_1		0
#define	T_MONEY_1		1 
#define	T_LIC_1		2
#define	T_VIP_1		3
#define	T_CAR_1		4 
#define	T_GUN_1		5
#define	T_EXP_1		6
#define	T_DONATE_1	7
#define	T_SLOT_1		8 
#define	T_AKS_1	9
#define	T_MED_1	10
#define	T_VOENN_1	11
enum R_STRUCT_1
{
	R_TYPE_1,
	R_NAME_TXD_1[48],
	R_NAME_TEXT_1[48], 
    R_NAME_PRIZE_1[48],
	R_COUNT_1
}

enum WELSI_BLYAT_1
{ 
    last_player_name_1[24],
    id_ruletka_prize_1
};

new last_player_td_1[3][4] =
{
    {6,5,7,8},
    {11,9,10,12},
    {15,13,14,16}
};

new last_player_ruletka_1[3][WELSI_BLYAT_1] =
{
    {"Nick_Name", 0},
    {"Nick_Name", 0},
    {"Nick_Name", 0}
};
 
new ruletka_prize_1[15][R_STRUCT_1] =//раставлено в порядке:чем меньше [] тем реже
{
    {T_CAR_1, "txd:brgiftsuncar", 	"Volkswagen_Getta", "Volkswagen_Getta",		547},
	{T_CAR_1, "txd:brgiftsuncar", 	"Mercedes-Benz_C63s_AMG", "Mercedes-Benz C63s AMG",			603},
	{T_VIP_1, "txd:brgiftspvip", 		"5_дней.", "Platinum VIP на 5 дней",			3},
     {T_VIP_1, "txd:brgiftsgvip", 		"5_дней.", "Gold VIP на 5 дней",			3},
     {T_VIP_1, "txd:brgiftssvip", 		"5_дней.", "Silver VIP на 5 дней",			3},
	{T_DONATE_1, "txd:brgiftsdonate", "Любое_Оружее.", "Любое оружее.", 150},
    {T_VOENN_1, "txd:brgiftscash", 	"Военный_Билет.", "Военны билет",		500000},
	{T_SLOT_1, "txd:brgiftsfreeslot", 		"Доп._слот_на_авто.", 	"Доп. слот на авто",	1},
   {T_MED_1, "txd:brgiftsmedcard", 		"Мед._карта", "Мед. карта",			3},
    {T_AKS_1, "txd:brgiftsbag", 		"Cумка_Supreme", 	"Cумка Supreme",	1},
    {T_AKS_1, "txd:brgiftsbackpack", 	"Рюкзак_LV.",  "Рюкзак LV",	100000},
    {T_AKS_1, "txd:brgiftscap", 		"Кепка_BlackRussia", 	"Кепка BlackRussia",	25},
    {T_EXP_1, "txd:brgiftsexp", 	"16_EXP",  "16 EXP", 16},
    {T_EXP_1, "txd:brgiftsexp", 	"8_EXP",  "8 EXP", 8},
    {T_EXP_1, "txd:brgiftsexp", 	"4_EXP",  "4 EXP", 4}
};

new player_roulette_bronz_1[MAX_PLAYERS];
new menu_prize_player_1[MAX_PLAYERS][5];
new ruletka_count_1[MAX_PLAYERS];
new bool:animation_player_1[MAX_PLAYERS]; 
new timer_player_ruletka_1[MAX_PLAYERS];
new Text:welsirltk_TD_1[35];
new PlayerText:ruletka_PTD_1[MAX_PLAYERS][5];
new PlayerText:ruletka_PTD_t_1[MAX_PLAYERS][18];












//Рулетка
#define T_NONE_2		0
#define	T_MONEY_2		1 
#define	T_LIC_2		2
#define	T_VIP_2		3
#define	T_CAR_2		4 
#define	T_GUN_2		5
#define	T_EXP_2		6
#define	T_DONATE_2	7
#define	T_SLOT_2		8 

enum R_STRUCT_2
{
	R_TYPE_2,
	R_NAME_TXD_2[48],
	R_NAME_TEXT_2[48], 
    R_NAME_PRIZE_2[48],
	R_COUNT_2
}

enum WELSI_BLYAT_2
{ 
    last_player_name_2[24],
    id_ruletka_prize_2
};

new last_player_td_2[3][4] =
{
    {6,5,7,8},
    {11,9,10,12},
    {15,13,14,16}
};

new last_player_ruletka_2[3][WELSI_BLYAT_2] =
{
    {"Nick_Name", 0},
    {"Nick_Name", 0},
    {"Nick_Name", 0}
};
 
new ruletka_prize_2[12][R_STRUCT_2] =//раставлено в порядке:чем меньше [] тем реже
{
    {T_CAR_2, "txd:brgiftsuncar", 	"Пaзда_Mark_2", "Toyota Mark II",		547},
	{T_CAR_2, "txd:brgiftsuncar", 	"Пaзда_Mark_2", "Ford Mustang GT",			603},
	{T_DONATE_2, "txd:brgiftsdonate", 		"Пaзда_Mark_2-руб.", "до 150 донат-руб", 150},
    {T_MONEY_2, "txd:brgiftscash", 	"љПaзда_Mark_2.", "до 500000 рублей",		500000},
	{T_SLOT_2, "txd:brgiftsfreeslot", 		"Пaзда_Mark_2", 	"Слот для транспорта",	1},
    {T_VIP_2, "txd:brgiftsgvip", 		"Пaзда_Mark_2", "GOLD-VIP на 15 дней",			3},
    {T_LIC_2, "txd:brgiftslic", 		"Пaзда_Mark_2 e®џњ¬Їњ", 	"Пакет с лицензиями",	1},
    {T_MONEY_2, "txd:brgiftscash", 	"љПaзда_Mark_2.",  "до 100000 рублей",	100000},
    {T_GUN_2, "txd:brgiftsgun", 		"CћПaзда_Mark_2¤aќ®oe_opy›њe", 	"Случайное оружие",	25},
    {T_EXP_2, "txd:brgiftsexp", 	"Пaзда_Mark_2",  "15 EXP", 15},
    {T_EXP_2, "txd:brgiftsexp", 	"Пaзда_Mark_2",  "3 EXP", 3},
    {T_EXP_2, "txd:brgiftsexp", 	"Пaзда_Mark_28751",  "1 EXP", 1}
};

new player_roulette_bronz_2[MAX_PLAYERS];
new menu_prize_player_2[MAX_PLAYERS][5];
new ruletka_count_2[MAX_PLAYERS];
new bool:animation_player_2[MAX_PLAYERS]; 
new timer_player_ruletka_2[MAX_PLAYERS];
new Text:welsirltk_TD_2[35];
new PlayerText:ruletka_PTD_2[MAX_PLAYERS][5];
new PlayerText:ruletka_PTD_t_2[MAX_PLAYERS][18];






//Рулетка
#define T_NONE3		0
#define	T_MONEY3	1 
#define	T_LIC3		2
#define	T_VIP3		3
#define	T_CAR3		4 
#define	T_GUN3		5
#define	T_EXP3		6
#define	T_DONATE3	7
#define	T_SLOT3		8 

enum R_STRUCT3
{
	R_TYPE3,
	R_NAME_TXD3[48],
	R_NAME_TEXT3[48], 
    R_NAME_PRIZE3[48],
	R_COUNT3
}

enum WELSI_BLYAT3
{ 
    last_player_name3[24],
    id_ruletka_prize3
};

new last_player_td3[3][4] =
{
    {6,5,7,8},
    {11,9,10,12},
    {15,13,14,16}
};
new last_player_ruletka3[3][WELSI_BLYAT3] =
{
    {"Nick_Name", 0},
    {"Nick_Name", 0},
    {"Nick_Name", 0}
};
 
new ruletka_prize3[26][R_STRUCT3] =//раставлено в порядке:чем меньше [] тем реже
{
{T_CAR3, "txd:brgiftsuncar", 	"ГАЗ_69",  "ГАЗ_69", 500}, //gold
{T_CAR3, "txd:brgiftsuncar", 	"BMW_M5_F90(ППС)",  "BMW_M5_F90(ППС)", 596}, //gold
{T_CAR3, "txd:brgiftsuncar", 	"MERCEDES-BENZ_G63_AMG", "MERCEDES-BENZ_G63_AMG", 2573}, //gold
{T_CAR3, "txd:brgiftsuncar", 	"RAESR_TACHYON_2019",  "RAESR_TACHYON_2019", 2572}, //gold
{T_CAR3, "txd:brgiftsucar", 	"LAMBORGHINI_URUS",  "LAMBORGHINI_URUS", 2551},
{T_CAR3, "txd:brgiftsucar", 		"CADILLAC_ESCALADE_IV", 	"CADILLAC_ESCALADE_IV",	505},
{T_CAR3, "txd:brgiftsucar", 	"MERCEDES-BENZ_CLS63_AMG",  "MERCEDES-BENZ_CLS63_AMG",	2582},
{T_CAR3, "txd:brgiftsuncar", 	"BMW_M5_F90", "BMW_M5_F90",			466},
{T_CAR3, "txd:brgiftsucar", 		"NISSAN_GT-R_R35", "NISSAN_GT-R_R35",			502},
{T_CAR3, "txd:brgiftsucar", 		"TOYOTA_LAND_CRUISER_200", 	"TOYOTA_LAND_CRUISER_200",	2547},
{T_CAR3, "txd:brgiftsucar", 	"MERCEDES-BENZ_GT63S", "MERCEDES-BENZ_GT63S",		402},
{T_CAR3, "txd:brgiftsucar", 		"BMW_M4_F84", "BMW_M4_F84", 558},
{T_CAR3, "txd:brgiftsucar", 	"BMW_M8_F93_GRANCOUPE",  "BMW_M8_F93_GRANCOUPE", 2579},
{T_CAR3, "txd:brgiftsucar", 	"BMW_Z4_M40I",  "BMW_Z4_M40I", 480},
{T_CAR3, "txd:brgiftsucar", 	"CHEVROLET_CAMARO_ZL1",  "CHEVROLET_CAMARO_ZL1", 543},
{T_CAR3, "txd:brgiftsucar", 	"YAMAHA_FZ-10",  "YAMAHA_FZ-10", 523},
{T_CAR3, "txd:brgiftsucar", 	"DUCATI_XDIAVEL_S",  "DUCATI_XDIAVEL_S", 463},
{T_CAR3, "txd:brgiftsucar", 		"MERCEDES-BENZ_A45_AMG", 	"MERCEDES-BENZ_A45_AMG",	565},
{T_CAR3, "txd:brgiftsucar", 	"TOYOTA_SUPRA_A80",  "TOYOTA_SUPRA_A80",	2552},
{T_CAR3, "txd:brgiftsucar", 		"FORD_MUSTANG_GT", 	"FORD_MUSTANG_GT",	603},
{T_CAR3, "txd:brgiftsucar", 		"KIA_K5", "KIA_K5",			2584},
{T_CAR3, "txd:brgiftsucar", 		"TOYOTA_CAMRY_3.5", 	"TOYOTA_CAMRY_3.5",	550},
{T_CAR3, "txd:brgiftsucar", 	"SUBARU_WRX_STI", "SUBARU_WRX_STI",		560},
{T_CAR3, "txd:brgiftsucar", 		"BMW_M5_E60", "BMW_M5_E60", 2567},
{T_CAR3, "txd:brgiftsucar", 	"MITSUBISHI_LANCER_EVO_X", "MITSUBISHI_LANCER_EVO_X",		436},
{T_CAR3, "txd:brgiftsucar", 	"DUCATI_SUPERSPORT_S", "DUCATI_SUPERSPORT_S",		461}
};

new player_roulette_bronz3[MAX_PLAYERS];
new menu_prize_player3[MAX_PLAYERS][5];
new ruletka_count3[MAX_PLAYERS];
new bool:animation_player3[MAX_PLAYERS]; 
new timer_player_ruletka3[MAX_PLAYERS];
new Text:welsirltk_TD3[35];
new PlayerText:ruletka_PTD3[MAX_PLAYERS][5];
new PlayerText:ruletka_PTD_t3[MAX_PLAYERS][18];
new player_roulette_online_minutes[MAX_PLAYERS];
new player_roulette_online_day[MAX_PLAYERS];
new timer_player_roulette_online[MAX_PLAYERS];

#define ROULETTE_ONLINE_REWARD_MINUTES (120)

public OnGameModeInit()
{
 RuletkaMenu();
    LoadPrizeRuletka();
    SetTimer("CreateTablistRoulette", 1500, false);
  RuletkaMenu_1();
    LoadPrizeRuletka_1();
    SetTimer("CreateTablistRoulette_1", 1500, false);
      RuletkaMenu_2();
    LoadPrizeRuletka_2();
    SetTimer("CreateTablistRoulette_2", 1500, false);
     RuletkaMenu3();
    LoadPrizeRuletka3();
    SetTimer("CreateTablistRoulette3", 1500, false);
       #if defined roulette_OnGameModeInit
        return roulette_OnGameModeInit();
    #else
        return 1;
    #endif
}
#if defined _ALS_OnGameModeInit
    #undef OnGameModeInit
#else
    #define _ALS_OnGameModeInit
#endif
#define OnGameModeInit roulette_OnGameModeInit
#if defined roulette_OnGameModeInit
    forward roulette_OnGameModeInit();
#endif

public OnPlayerConnect(playerid)
{
    timer_player_ruletka_1[playerid] = -1;
    timer_player_ruletka[playerid] = -1;
    timer_player_ruletka_2[playerid] = -1;
    timer_player_ruletka3[playerid] = -1;
    timer_player_roulette_online[playerid] = -1;
    player_roulette_online_minutes[playerid] = 0;
    player_roulette_online_day[playerid] = 0;

    SetTimerEx("Roulette_InitPlayerData", 3000, false, "d", playerid);

    #if defined roulette_OnPlayerConnect
        return roulette_OnPlayerConnect(playerid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerConnect
    #undef OnPlayerConnect
#else
    #define _ALS_OnPlayerConnect
#endif
#define OnPlayerConnect roulette_OnPlayerConnect
#if defined roulette_OnPlayerConnect
    forward roulette_OnPlayerConnect(playerid);
#endif

public OnDialogResponse(playerid, dialogid, response, listitem, inputtext[])
{
    	    if(dialogid == 12832)
    {
        if(response)
        {
            if(listitem == 0 || listitem == 1)
            {
                new count_listt3 = GetPVarInt(playerid, "count_list"), query3[94];

                if(!listitem) count_listt3++;
                else if(listitem == 1 && count_listt3 != 1) count_listt3--;


                mysql_format(mysql, query3, sizeof query3, "SELECT * FROM roulette_prize WHERE owner = %d", GetPlayerAccountID(playerid));
                new Cache:cache3 = mysql_query(mysql, query3);

                new list_max3 = count_listt3*10, rows3, prize_id3, id3, list3[52], dialog3[sizeof list3*10+54];

                strcat(dialog3, "Следующая страница\nПредыдущая страница\n");

                rows3 = cache_num_rows();

                if(rows3 >= list_max3) rows3 = list_max3;

                for(new i3 = list_max3 - 10, c3=2;i3 < rows3;i3++, c3++)
                {
                    prize_id3 = cache_get_field_content_int(i3, "prize");
                    id3 = cache_get_field_content_int(i3, "id");

                    format(list3, sizeof list3, "%d. %s\n", i3+1, ruletka_prize3[prize_id3][R_NAME_PRIZE3]);
                    strcat(dialog3, list3);
                    SetPlayerListitemValue(playerid, c3, prize_id3);
                    format(list3, sizeof list3, "rouletteid_%d", c3);
                    SetPVarInt(playerid, list3, id3);
                }

                cache_delete(cache3);
                SetPVarInt(playerid, "count_list", count_listt3);
                Dialog(playerid, 2832, DIALOG_STYLE_LIST, "{FF0000}Призы с рулетки", dialog3, "Далее", "Выйти");
                return 1;
            }

            new id3 = GetPlayerListitemValue(playerid, listitem), text3[134],count3;

            format(text3, sizeof text3, "");

            switch(id3)
            {
                case 0..25:
                {
                    if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
                    return SendClientMessage(playerid, -1, "Выгрузите транспорт");
                    GivePlayerCarRoulette3(playerid, ruletka_prize3[id3][R_COUNT3], 0, 0);

                    format(text3, sizeof text3, "Вы забрали %s с призов. Поздравляем!",  ruletka_prize3[id3][R_NAME_PRIZE3]);
                }
            }

            SendClientMessage(playerid, -1, text3);

            format(text3, sizeof text3, "rouletteid_%d", listitem);
            new id_data3 = GetPVarInt(playerid, text3);
            mysql_format(mysql, text3, sizeof text3, "DELETE FROM roulette_prize WHERE id = %d", id_data3);
            mysql_query(mysql, text3, false);
            if(mysql_errno()) return SendClientMessage(playerid, -1, "Ошибка в запросе.");
        }
    }
 if(dialogid == 21832)
    {
        if(response)
        {
            if(listitem == 0 || listitem == 1)
            {
                new count_listt_2 = GetPVarInt(playerid, "count_list"), query_2[94];

                if(!listitem) count_listt_2++;
                else if(listitem == 1 && count_listt_2 != 1) count_listt_2--;


                mysql_format(mysql, query_2, sizeof query_2, "SELECT * FROM roulette_prize WHERE owner = %d", GetPlayerAccountID(playerid));
                new Cache:cache_2 = mysql_query(mysql, query_2);

                new list_max_2 = count_listt_2*10, rows_2, prize_id_2, id_2, list_2[52], dialog_2[sizeof list_2*10+54];

                strcat(dialog_2, "Следующая страница\nПредыдущая страница\n");

                rows_2 = cache_num_rows();

                if(rows_2 >= list_max_2) rows_2 = list_max_2;

                for(new i_2 = list_max_2 - 10, c_2=2;i_2 < rows_2;i_2++, c_2++)
                {
                    prize_id_2 = cache_get_field_content_int(i_2, "prize");
                    id_2 = cache_get_field_content_int(i_2, "id");

                    format(list_2, sizeof list_2, "%d. %s\n", i_2+1, ruletka_prize_2[prize_id_2][R_NAME_PRIZE_2]);
                    strcat(dialog_2, list_2);
                    SetPlayerListitemValue(playerid, c_2, prize_id_2);
                    format(list_2, sizeof list_2, "rouletteid_%d", c_2);
                    SetPVarInt(playerid, list_2, id_2);
                }

                cache_delete(cache_2);
                SetPVarInt(playerid, "count_list", count_listt_2);
                Dialog(playerid, 2832, DIALOG_STYLE_LIST, "{FF0000}Призы с рулетки", dialog_2, "Далее", "Выйти");
                return 1;
            }

            new id_2 = GetPlayerListitemValue(playerid, listitem), text_2[134],count_2;

            format(text_2, sizeof text_2, "");

            switch(id_2)
            {
                case 0,1:
                {
                    if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
                    return SendClientMessage(playerid, -1, "Выгрузите транспорт");
                    GivePlayerCarRoulette_2(playerid, ruletka_prize_2[id_2][R_COUNT_2], 0, 0);

                    format(text_2, sizeof text_2, "Вы забрали %s с призов. Поздравляем!",  ruletka_prize_2[id_2][R_NAME_PRIZE_2]);
                }
                case 2:
                {
                    count_2 = random(150)+1;

                    GivePlayerDonateRub(playerid, count_2);
                    format(text_2, sizeof text_2, "Вы забрали %d донат-рублей с призов. Поздравляем!", count_2);
                }
                case 3,7:
                {
                    count_2 = random(ruletka_prize_2[id_2][R_COUNT_2])+1;

                    GivePlayerMoneyEx(playerid, count_2);
                    format(text_2, sizeof text_2, "Вы забрали %d рублей с призов. Поздравляем!", count_2);
                }
                case 4:
                {
                    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

                    format(text_2, sizeof text_2, "Вы забрали %s с призов. Поздравляем!", ruletka_prize_2[id_2][R_NAME_PRIZE_2]);
                }
                case 5:
                {
                    new prem_day_2,prem_month_2,prem_year_2,premium_2 = GetPlayerPremium(playerid);
                    if(!premium_2)
                    {
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 2);
                        SetPlayerData(playerid, P_PREMIUM, 3);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 15 * 86400);
                    }
                    else
                    {
                        AddPlayerData(playerid, P_PREMIUM_DATE, +, 15 * 86400);
                    }

                    timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year_2, prem_month_2, prem_day_2);

                    format(text_2, sizeof text_2, "Вы забрали {FFEE00}VIP Gold{FFFFFF} до {F5D000}%02d.%02d.%d с призов. Поздравляем", prem_day_2, prem_month_2, prem_year_2);

                    UpdatePlayerDatabaseInt(playerid, "premium", 3);
                    UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                }
                case 6:
                {
                    SetPlayerData(playerid, P_DRIVING_LIC,	2);
                    SetPlayerData(playerid, P_WEAPON_LIC,	1);

                    UpdatePlayerDatabaseInt(playerid, "driving_lic", 2);
                    UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);

                    format(text_2, sizeof text_2, "Вы забрали %s с призов. Поздравляем!", ruletka_prize_2[id_2][R_NAME_PRIZE_2]);
                }
                case 8:
                {
                    new gun_2[7] = {23,24,25,29,30,31,33};

                    GivePlayerWeapon(playerid, gun_2[random(sizeof gun_2)], 1000);

                    format(text_2, sizeof text_2, "Вы забрали %s с призов. Поздравляем!", ruletka_prize_2[id_2][R_NAME_PRIZE_2]);
                }
                case 9,10,11:
                {
                    AddPlayerData(playerid, P_EXP, +, ruletka_prize_2[id_2][R_COUNT_2]);
				    UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));

                    if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
                    {
                        SetPlayerData(playerid, P_EXP, 0);
                        AddPlayerData(playerid, P_LEVEL, +, 1);

                        SetPlayerLevelInit(playerid);
                        SendClientMessage(playerid, -1, "Поздравляем! Ваш уровень повышен");
                    }

                    format(text_2, sizeof text_2, "Вы забрали %s с призов. Поздравляем!", ruletka_prize_2[id_2][R_NAME_PRIZE_2]);
                }
            }

            SendClientMessage(playerid, -1, text_2);

            format(text_2, sizeof text_2, "rouletteid_%d", listitem);
            new id_data_2 = GetPVarInt(playerid, text_2);
            mysql_format(mysql, text_2, sizeof text_2, "DELETE FROM roulette_prize WHERE id = %d", id_data_2);
            mysql_query(mysql, text_2, false);
            if(mysql_errno()) return SendClientMessage(playerid, -1, "Ошибка в запросе.");
        }
    }


   if(dialogid == 28132)
    {
        if(response)
        {
            if(listitem == 0 || listitem == 1)
            {
                new count_listt = GetPVarInt(playerid, "count_list"), query[94];

                if(!listitem) count_listt++;
                else if(listitem == 1 && count_listt != 1) count_listt--;


                mysql_format(mysql, query, sizeof query, "SELECT * FROM roulette_prize WHERE owner = %d", GetPlayerAccountID(playerid));
                new Cache:cache = mysql_query(mysql, query);

                new list_max = count_listt*10, rows, prize_id, id, list[52], dialog[sizeof list*10+54];

                strcat(dialog, "Следующая страница\nПредыдущая страница\n");

                rows = cache_num_rows();

                if(rows >= list_max) rows = list_max;

                for(new i = list_max - 10, c=2;i < rows;i++, c++)
                {
                    prize_id = cache_get_field_content_int(i, "prize");
                    id = cache_get_field_content_int(i, "id");

                    format(list, sizeof list, "%d. %s\n", i+1, ruletka_prize_1[prize_id][R_NAME_PRIZE_1]);
                    strcat(dialog, list);
                    SetPlayerListitemValue(playerid, c, prize_id);
                    format(list, sizeof list, "rouletteid_%d", c);
                    SetPVarInt(playerid, list, id);
                }

                cache_delete(cache);
                SetPVarInt(playerid, "count_list", count_listt);
                Dialog(playerid, 2832, DIALOG_STYLE_LIST, "{FF0000}Призы с рулетки", dialog, "Далее", "Выйти");
                return 1;
            }

            new id = GetPlayerListitemValue(playerid, listitem), text[134],count;

            format(text, sizeof text, "");

            switch(id)
            {
                case 0,1:
                {
                    if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
                    return SendClientMessage(playerid, -1, "Выгрузите транспорт");
                    GivePlayerCarRoulette_1(playerid, ruletka_prize_1[id][R_COUNT_1], 0, 0);

                    format(text, sizeof text, "Вы забрали %s с призов. Поздравляем!",  ruletka_prize_1[id][R_NAME_PRIZE_1]);
                }
                case 2..4:
                {
					AddPlayerData(playerid, P_PREMIUM_DATE, +, 15 * 86400);


                    format(text, sizeof text, "Вы забрали {FFEE00}VIP{FFFFFF} до {F5D000}%02d.%02d.%d с призов. Поздравляем", 1, 1, 1);

                    UpdatePlayerDatabaseInt(playerid, "premium", 3);
                    UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                }
                case 5:
                {
                                       new gun[7] = {23,24,25,29,30,31,33};

                    GivePlayerWeapon(playerid, gun[random(sizeof gun)], 1000);

                    format(text, sizeof text, "Вы забрали %s с призов. Поздравляем!", ruletka_prize_1[id][R_NAME_PRIZE_1]);
                }
                case 6:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! Военный билет в разработке");
                 }
                case 7:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! Доп слот на авто");
                 }
                 case 8:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! Мед карта");
                 }
                 case 9:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! Сумка суприм");
                 }
                 case 10:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! Рюкзак лв");
                 }
                 case 11:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! Гепочко блек попаша");
                 }
                 case 12:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! ехп 16");
                 }
                 case 13:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! ехп 8");
                 }
                 case 14:
                {

                        SendClientMessage(playerid, -1, "Поздравляем! ехп 4");
                 }
			}



            SendClientMessage(playerid, -1, text);

            format(text, sizeof text, "rouletteid_%d", listitem);
            new id_data = GetPVarInt(playerid, text);
            mysql_format(mysql, text, sizeof text, "DELETE FROM roulette_prize WHERE id = %d", id_data);
            mysql_query(mysql, text, false);
            if(mysql_errno()) return SendClientMessage(playerid, -1, "Ошибка в запросе.");
        }
    }

	if(dialogid == 2832)
    {
        if(response)
        {
            if(listitem == 0 || listitem == 1)
            {
                new count_listt = GetPVarInt(playerid, "count_list"), query[94];

                if(!listitem) count_listt++;
                else if(listitem == 1 && count_listt != 1) count_listt--;


                mysql_format(mysql, query, sizeof query, "SELECT * FROM roulette_prize WHERE owner = %d", GetPlayerAccountID(playerid));
                new Cache:cache = mysql_query(mysql, query);

                new list_max = count_listt*10, rows, prize_id, id, list[52], dialog[sizeof list*10+54];

                strcat(dialog, "Следующая страница\nПредыдущая страница\n");

                rows = cache_num_rows();

                if(rows >= list_max) rows = list_max;

                for(new i = list_max - 10, c=2;i < rows;i++, c++)
                {
                    prize_id = cache_get_field_content_int(i, "prize");
                    id = cache_get_field_content_int(i, "id");

                    format(list, sizeof list, "%d. %s\n", i+1, ruletka_prize[prize_id][R_NAME_PRIZE]);
                    strcat(dialog, list);
                    SetPlayerListitemValue(playerid, c, prize_id);
                    format(list, sizeof list, "rouletteid_%d", c);
                    SetPVarInt(playerid, list, id);
                }

                cache_delete(cache);
                SetPVarInt(playerid, "count_list", count_listt);
                Dialog(playerid, 2832, DIALOG_STYLE_LIST, "{FF0000}Призы с рулетки", dialog, "Далее", "Выйти");
                return 1;
            }

            new id = GetPlayerListitemValue(playerid, listitem), text[134],count;

            format(text, sizeof text, "");

            switch(id)
            {
                case 0,1:
                {
                    if(GetPlayerOwnableCar(playerid) != INVALID_VEHICLE_ID)
                    return SendClientMessage(playerid, -1, "Выгрузите транспорт");
                    GivePlayerCarRoulette(playerid, ruletka_prize[id][R_COUNT], 0, 0);

                    format(text, sizeof text, "Вы забрали %s с призов. Поздравляем!",  ruletka_prize[id][R_NAME_PRIZE]);
                }
                case 2:
                {
                    count = random(150)+1;

                    GivePlayerDonateRub(playerid, count);
                    format(text, sizeof text, "Вы забрали %d донат-рублей с призов. Поздравляем!", count);
                }
                case 3,7:
                {
                    count = random(ruletka_prize[id][R_COUNT])+1;

                    GivePlayerMoneyEx(playerid, count);
                    format(text, sizeof text, "Вы забрали %d рублей с призов. Поздравляем!", count);
                }
                case 4:
                {
                    AddPlayerData(playerid, P_CAR_SLOTS, +, 1);
                    UpdatePlayerDatabaseInt(playerid, "car_slots", GetPlayerData(playerid, P_CAR_SLOTS));

                    format(text, sizeof text, "Вы забрали %s с призов. Поздравляем!", ruletka_prize[id][R_NAME_PRIZE]);
                }
                case 5:
                {
                    new prem_day,prem_month,prem_year,premium = GetPlayerPremium(playerid);
                    if(!premium)
                    {
                        AddPlayerData(playerid, P_CAR_SLOTS, +, 2);
                        SetPlayerData(playerid, P_PREMIUM, 3);
                        SetPlayerData(playerid, P_PREMIUM_DATE, gettime() + 15 * 86400);
                    }
                    else
                    {
                        AddPlayerData(playerid, P_PREMIUM_DATE, +, 15 * 86400);
                    }

                    timestamp_to_date(GetPlayerData(playerid, P_PREMIUM_DATE), prem_year, prem_month, prem_day);

                    format(text, sizeof text, "Вы забрали {FFEE00}VIP Gold{FFFFFF} до {F5D000}%02d.%02d.%d с призов. Поздравляем", prem_day, prem_month, prem_year);

                    UpdatePlayerDatabaseInt(playerid, "premium", 3);
                    UpdatePlayerDatabaseInt(playerid, "premium_date", GetPlayerData(playerid, P_PREMIUM_DATE));
                }
                case 6:
                {
                    SetPlayerData(playerid, P_DRIVING_LIC,	2);
                    SetPlayerData(playerid, P_WEAPON_LIC,	1);

                    UpdatePlayerDatabaseInt(playerid, "driving_lic", 2);
                    UpdatePlayerDatabaseInt(playerid, "weapon_lic", 1);

                    format(text, sizeof text, "Вы забрали %s с призов. Поздравляем!", ruletka_prize[id][R_NAME_PRIZE]);
                }
                case 8:
                {
                    new gun[7] = {23,24,25,29,30,31,33};

                    GivePlayerWeapon(playerid, gun[random(sizeof gun)], 1000);

                    format(text, sizeof text, "Вы забрали %s с призов. Поздравляем!", ruletka_prize[id][R_NAME_PRIZE]);
                }
                case 9,10,11:
                {
                    AddPlayerData(playerid, P_EXP, +, ruletka_prize[id][R_COUNT]);
				    UpdatePlayerDatabaseInt(playerid, "exp", GetPlayerData(playerid, P_EXP));

                    if(GetPlayerExp(playerid) > GetExpToNextLevel(playerid))
                    {
                        SetPlayerData(playerid, P_EXP, 0);
                        AddPlayerData(playerid, P_LEVEL, +, 1);

                        SetPlayerLevelInit(playerid);
                        SendClientMessage(playerid, -1, "Поздравляем! Ваш уровень повышен");
                    }

                    format(text, sizeof text, "Вы забрали %s с призов. Поздравляем!", ruletka_prize[id][R_NAME_PRIZE]);
                }
            }

            SendClientMessage(playerid, -1, text);

            format(text, sizeof text, "rouletteid_%d", listitem);
            new id_data = GetPVarInt(playerid, text);
            mysql_format(mysql, text, sizeof text, "DELETE FROM roulette_prize WHERE id = %d", id_data);
            mysql_query(mysql, text, false);
            if(mysql_errno()) return SendClientMessage(playerid, -1, "Ошибка в запросе.");
        }
    }
        #if defined roulette_OnDialogResponse
        return roulette_OnDialogResponse(playerid, dialogid, response, listitem, inputtext);
    #endif
}
#if defined _ALS_OnDialogResponse
    #undef OnDialogResponse
#else
    #define _ALS_OnDialogResponse
#endif
#define OnDialogResponse roulette_OnDialogResponse
#if defined roulette_OnDialogResponse
    forward roulette_OnDialogResponse(playerid, dialogid, response, listitem, inputtext[]);
#endif

public OnPlayerDisconnect(playerid, reason)
{
    if(timer_player_roulette_online[playerid] != -1)
    {
        KillTimer(timer_player_roulette_online[playerid]);
        timer_player_roulette_online[playerid] = -1;
    }

     player_roulette_bronz_1[playerid] = 0;
    ruletka_count_1[playerid] = 0;
    animation_player_1[playerid] = false;
    timer_player_ruletka_1[playerid] = -1;
  player_roulette_bronz[playerid] = 0;
    ruletka_count[playerid] = 0;
    animation_player[playerid] = false; 
    timer_player_ruletka[playerid] = -1;
     player_roulette_bronz_2[playerid] = 0;
    ruletka_count_2[playerid] = 0;
    animation_player_2[playerid] = false; 
    timer_player_ruletka_2[playerid] = -1;
        player_roulette_bronz3[playerid] = 0;
    ruletka_count3[playerid] = 0;
    animation_player3[playerid] = false; 
    timer_player_ruletka3[playerid] = -1;
    player_roulette_online_minutes[playerid] = 0;
    player_roulette_online_day[playerid] = 0;
	#if defined roulette_OnPlayerDisconnect
        return roulette_OnPlayerDisconnect(playerid, reason);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerDisconnect
    #undef OnPlayerDisconnect
#else
    #define _ALS_OnPlayerDisconnect
#endif
#define OnPlayerDisconnect roulette_OnPlayerDisconnect
#if defined roulette_OnPlayerDisconnect
    forward roulette_OnPlayerDisconnect(playerid, reason);
#endif

public OnPlayerClickTextDraw(playerid, Text:clickedid)
{

if(clickedid == welsirltk_TD3[4])
	{
        if(animation_player3[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");
        if(GetPlayerDonateRub(playerid) >= 50)
        {
            player_roulette_bronz3[playerid]++;
            UpdatePlayerDatabaseInt(playerid, "roulette_auto", player_roulette_bronz3[playerid]);
            SendClientMessage(playerid, -1, "Вы купили авто кейс!");
            GivePlayerDonateRub(playerid, -1000);

            new string3[10];
            format(string3, sizeof string3, "%d", player_roulette_bronz3[playerid]);
            PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][17], string3);
        }
        else SendClientMessage(playerid, -1, "Авто кейс стоит 1000 донат-рублей.");
	}
	if(clickedid == welsirltk_TD3[31])
	{ 
        UpdateLastPlayerRuletka3(playerid);
	}
	if(clickedid == welsirltk_TD3[33])
	{
        if(player_roulette_bronz3[playerid])
        {
            if(timer_player_ruletka3[playerid] == -1)
            {
                if(animation_player3[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");
                player_roulette_bronz3[playerid]--;
                UpdatePlayerDatabaseInt(playerid, "roulette_auto", player_roulette_bronz3[playerid]);

                new string3[10];
                format(string3, sizeof string3, "%d", player_roulette_bronz3[playerid]);
                PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][17], string3);

                animation_player3[playerid] = true;
                timer_player_ruletka3[playerid] = SetTimerEx("RunRuletka3", 500, true, "d", playerid);
            }
        }
        else SendClientMessage(playerid, -1, "У вас нет авто кейса.");
	}
	if(clickedid == welsirltk_TD3[32])
	{
		if(animation_player3[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");

		TogglePlayerControllable(playerid, true);
		ShowHud(playerid);
		for(new t3;t3 < sizeof welsirltk_TD3;t3++)
		{
			TextDrawHideForPlayer(playerid, welsirltk_TD3[t3]);
		}

        PlayerTextDrawHide(playerid, ruletka_PTD_t3[playerid][17]);

		for(new t3;t3 < 5;t3++)
		{
			PlayerTextDrawHide(playerid, ruletka_PTD3[playerid][t3]);
			PlayerTextDrawHide(playerid, ruletka_PTD_t3[playerid][t3]);
			menu_prize_player3[playerid][t3] = -1;
		}

        for(new i3; i3 < 3;i3++)
        {
            PlayerTextDrawHide(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][0]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][1]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][2]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][3]]);
        }

        CancelSelectTextDraw(playerid);
	}
if(clickedid == welsirltk_TD_2[4])
	{
        if(animation_player_2[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");
        if(GetPlayerDonateRub(playerid) >= 50)
        {
            player_roulette_bronz_2[playerid]++;
            UpdatePlayerDatabaseInt(playerid, "roulette_gold", player_roulette_bronz_2[playerid]);
            SendClientMessage(playerid, -1, "Вы купили бронзовую рулетку");
            GivePlayerDonateRub(playerid, -50);

            new string_2[10];
            format(string_2, sizeof string_2, "%d", player_roulette_bronz_2[playerid]);
            PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][17], string_2);
        }
        else SendClientMessage(playerid, -1, "Бронзовая рулетка стоит 50 донат-рублей.");
	}
	if(clickedid == welsirltk_TD_2[31])
	{ 
        UpdateLastPlayerRuletka_2(playerid);
	}
	if(clickedid == welsirltk_TD_2[33])
	{
        if(player_roulette_bronz_2[playerid])
        {
            if(timer_player_ruletka_2[playerid] == -1)
            {
                if(animation_player_2[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");
                player_roulette_bronz_2[playerid]--;
                UpdatePlayerDatabaseInt(playerid, "roulette_gold", player_roulette_bronz_2[playerid]);

                new string_2[10];
                format(string_2, sizeof string_2, "%d", player_roulette_bronz_2[playerid]);
                PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][17], string_2);

                animation_player_2[playerid] = true;
                timer_player_ruletka_2[playerid] = SetTimerEx("RunRuletka_2", 500, true, "d", playerid);
            }
        }
        else SendClientMessage(playerid, -1, "У вас нет бронзовых рулеток.");
	}
	if(clickedid == welsirltk_TD_2[32])
	{
		if(animation_player_2[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");

		TogglePlayerControllable(playerid, true);
		ShowHud(playerid);
		for(new t_2;t_2 < sizeof welsirltk_TD_2;t_2++)
		{
			TextDrawHideForPlayer(playerid, welsirltk_TD_2[t_2]);
		}

        PlayerTextDrawHide(playerid, ruletka_PTD_t_2[playerid][17]);

		for(new t_2;t_2 < 5;t_2++)
		{
			PlayerTextDrawHide(playerid, ruletka_PTD_2[playerid][t_2]);
			PlayerTextDrawHide(playerid, ruletka_PTD_t_2[playerid][t_2]);
			menu_prize_player_2[playerid][t_2] = -1;
		}

        for(new i_2; i_2 < 3;i_2++)
        {
            PlayerTextDrawHide(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][0]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][1]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][2]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][3]]);
        }

        CancelSelectTextDraw(playerid);
	}


if(clickedid == welsirltk_TD_1[4])
	{
        if(animation_player_1[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");
        if(GetPlayerDonateRub(playerid) >= 250)
        {
            player_roulette_bronz_1[playerid]++;
            UpdatePlayerDatabaseInt(playerid, "roulette_silver", player_roulette_bronz_1[playerid]);
            SendClientMessage(playerid, -1, "Вы купили серебреную рулетку");
            GivePlayerDonateRub(playerid, -250);

            new string[10];
            format(string, sizeof string, "%d", player_roulette_bronz_1[playerid]);
            PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][17], string);
        }
        else SendClientMessage(playerid, -1, "серебреная рулетка стоит 250 донат-рублей.");
	}
	if(clickedid == welsirltk_TD_1[31])
	{ 
        UpdateLastPlayerRuletka_1(playerid);
	}
	if(clickedid == welsirltk_TD_1[33])
	{
        if(player_roulette_bronz_1[playerid])
        {
            if(timer_player_ruletka_1[playerid] == -1)
            {
                if(animation_player_1[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");
                player_roulette_bronz_1[playerid]--;
                UpdatePlayerDatabaseInt(playerid, "roulette_silver", player_roulette_bronz_1[playerid]);

                new string[10];
                format(string, sizeof string, "%d", player_roulette_bronz_1[playerid]);
                PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][17], string);

                animation_player_1[playerid] = true;
                timer_player_ruletka_1[playerid] = SetTimerEx("RunRuletka_1", 500, true, "d", playerid);
            }
        }
        else SendClientMessage(playerid, -1, "У вас нет серебреных рулеток.");
	}
	if(clickedid == welsirltk_TD_1[32])
	{
		if(animation_player_1[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");

		TogglePlayerControllable(playerid, true);
		ShowHud(playerid);
		for(new t;t < sizeof welsirltk_TD_1;t++)
		{
			TextDrawHideForPlayer(playerid, welsirltk_TD_1[t]);
		}

        PlayerTextDrawHide(playerid, ruletka_PTD_t_1[playerid][17]);

		for(new t;t < 5;t++)
		{
			PlayerTextDrawHide(playerid, ruletka_PTD_1[playerid][t]);
			PlayerTextDrawHide(playerid, ruletka_PTD_t_1[playerid][t]);
			menu_prize_player_1[playerid][t] = -1;
		}

        for(new i; i < 3;i++)
        {
            PlayerTextDrawHide(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][0]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][1]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][2]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][3]]);
        }

        CancelSelectTextDraw(playerid);
	}
if(clickedid == welsirltk_TD[4])
	{
        if(animation_player[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");
        if(GetPlayerDonateRub(playerid) >= 50)
        {
            player_roulette_bronz[playerid]++;
            UpdatePlayerDatabaseInt(playerid, "roulette_bronz", player_roulette_bronz[playerid]);
            SendClientMessage(playerid, -1, "Вы купили бронзовую рулетку");
            GivePlayerDonateRub(playerid, -50);

            new string[10];
            format(string, sizeof string, "%d", player_roulette_bronz[playerid]);
            PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][17], string);
        }
        else SendClientMessage(playerid, -1, "Бронзовая рулетка стоит 50 донат-рублей.");
	}
	if(clickedid == welsirltk_TD[31])
	{ 
        UpdateLastPlayerRuletka(playerid);
	}
	if(clickedid == welsirltk_TD[33])
	{
        if(player_roulette_bronz[playerid])
        {
            if(timer_player_ruletka[playerid] == -1)
            {
                if(animation_player[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");
                player_roulette_bronz[playerid]--;
                UpdatePlayerDatabaseInt(playerid, "roulette_bronz", player_roulette_bronz[playerid]);

                new string[10];
                format(string, sizeof string, "%d", player_roulette_bronz[playerid]);
                PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][17], string);

                animation_player[playerid] = true;
                timer_player_ruletka[playerid] = SetTimerEx("RunRuletka", 500, true, "d", playerid);
            }
        }
        else SendClientMessage(playerid, -1, "У вас нет бронзовых рулеток.");
	}
	if(clickedid == welsirltk_TD[32])
	{
		if(animation_player[playerid]) return SCM(playerid, -1, ""USC"Подождите окончания анимации.");

		TogglePlayerControllable(playerid, true);
		ShowHud(playerid);
		for(new t;t < sizeof welsirltk_TD;t++)
		{
			TextDrawHideForPlayer(playerid, welsirltk_TD[t]);
		}

        PlayerTextDrawHide(playerid, ruletka_PTD_t[playerid][17]);

		for(new t;t < 5;t++)
		{
			PlayerTextDrawHide(playerid, ruletka_PTD[playerid][t]);
			PlayerTextDrawHide(playerid, ruletka_PTD_t[playerid][t]);
			menu_prize_player[playerid][t] = -1;
		}

        for(new i; i < 3;i++)
        {
            PlayerTextDrawHide(playerid, ruletka_PTD_t[playerid][last_player_td[i][0]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t[playerid][last_player_td[i][1]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t[playerid][last_player_td[i][2]]);
            PlayerTextDrawHide(playerid, ruletka_PTD_t[playerid][last_player_td[i][3]]);
        }

        CancelSelectTextDraw(playerid);
	}

	if(clickedid == casesda_TD[3])
    {
     TextDrawHideForPlayer(playerid, casesda_TD[1]);
	TextDrawHideForPlayer(playerid, casesda_TD[2]);
	TextDrawHideForPlayer(playerid, casesda_TD[9]);
	TextDrawShowForPlayer(playerid, casesda_TD[0]);

	TextDrawHideForPlayer(playerid, casesda_TD[7]);
	TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
	TextDrawShowForPlayer(playerid, casesda_TD[7]);

  	TextDrawHideForPlayer(playerid, casesda_TD[6]);
	TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
	TextDrawShowForPlayer(playerid, casesda_TD[6]);

    TextDrawHideForPlayer(playerid, casesda_TD[5]);
	TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
	TextDrawShowForPlayer(playerid, casesda_TD[5]);

	TextDrawHideForPlayer(playerid, casesda_TD[3]);
	TextDrawSetString(casesda_TD[3], "pizda:brgiftsuinfo");
	TextDrawShowForPlayer(playerid, casesda_TD[3]);

	TextDrawHideForPlayer(playerid, casesda_TD[8]);
	TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
	TextDrawShowForPlayer(playerid, casesda_TD[8]);
    }
    if(clickedid == casesda_TD[4])
    {
	TogglePlayerControllable(playerid, true);
 		for(new i; i < sizeof casesda_TD;i++)
		{
			TextDrawHideForPlayer(playerid, casesda_TD[i]);
		}
		TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
		TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
			TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
			TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
    typecase[playerid] = 0;
    }
    if(clickedid == casesda_TD[5])
    {
    typecase[playerid] = 1;
    TextDrawShowForPlayer(playerid, casesda_TD[1]);
	TextDrawShowForPlayer(playerid, casesda_TD[2]);
	TextDrawShowForPlayer(playerid, casesda_TD[9]);
	TextDrawHideForPlayer(playerid, casesda_TD[0]);

	TextDrawHideForPlayer(playerid, casesda_TD[7]);
	TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
	TextDrawShowForPlayer(playerid, casesda_TD[7]);

  	TextDrawHideForPlayer(playerid, casesda_TD[6]);
	TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
	TextDrawShowForPlayer(playerid, casesda_TD[6]);

    TextDrawHideForPlayer(playerid, casesda_TD[5]);
	TextDrawSetString(casesda_TD[5], "pizda:brgiftsubronza");
	TextDrawShowForPlayer(playerid, casesda_TD[5]);

	TextDrawHideForPlayer(playerid, casesda_TD[3]);
	TextDrawSetString(casesda_TD[3], "pizda:brgiftsnuinfo");
	TextDrawShowForPlayer(playerid, casesda_TD[3]);

	TextDrawHideForPlayer(playerid, casesda_TD[8]);
	TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
	TextDrawShowForPlayer(playerid, casesda_TD[8]);

	TextDrawHideForPlayer(playerid, casesda_TD[2]);
	TextDrawSetString(casesda_TD[2], "75_P.");
	TextDrawShowForPlayer(playerid, casesda_TD[2]);

    }
    if(clickedid == casesda_TD[6])
    {
    TextDrawShowForPlayer(playerid, casesda_TD[1]);
	TextDrawShowForPlayer(playerid, casesda_TD[2]);
	TextDrawShowForPlayer(playerid, casesda_TD[9]);
 	TextDrawHideForPlayer(playerid, casesda_TD[0]);

   	TextDrawHideForPlayer(playerid, casesda_TD[7]);
	TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
	TextDrawShowForPlayer(playerid, casesda_TD[7]);

  	TextDrawHideForPlayer(playerid, casesda_TD[6]);
	TextDrawSetString(casesda_TD[6], "pizda:brgiftsusilver");
	TextDrawShowForPlayer(playerid, casesda_TD[6]);

    TextDrawHideForPlayer(playerid, casesda_TD[5]);
	TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
	TextDrawShowForPlayer(playerid, casesda_TD[5]);

	TextDrawHideForPlayer(playerid, casesda_TD[3]);
	TextDrawSetString(casesda_TD[3], "pizda:brgiftsnuinfo");
	TextDrawShowForPlayer(playerid, casesda_TD[3]);

	TextDrawHideForPlayer(playerid, casesda_TD[8]);
	TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
	TextDrawShowForPlayer(playerid, casesda_TD[8]);

	TextDrawHideForPlayer(playerid, casesda_TD[2]);
	TextDrawSetString(casesda_TD[2], "250_P.");
	TextDrawShowForPlayer(playerid, casesda_TD[2]);

    typecase[playerid] = 2;
    }
    if(clickedid == casesda_TD[7])
    {
    TextDrawShowForPlayer(playerid, casesda_TD[1]);
	TextDrawShowForPlayer(playerid, casesda_TD[2]);
	TextDrawShowForPlayer(playerid, casesda_TD[9]);
 	TextDrawHideForPlayer(playerid, casesda_TD[0]);
   	TextDrawHideForPlayer(playerid, casesda_TD[7]);
	TextDrawSetString(casesda_TD[7], "pizda:brgiftsugold");
	TextDrawShowForPlayer(playerid, casesda_TD[7]);

  	TextDrawHideForPlayer(playerid, casesda_TD[6]);
	TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
	TextDrawShowForPlayer(playerid, casesda_TD[6]);

    TextDrawHideForPlayer(playerid, casesda_TD[5]);
	TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
	TextDrawShowForPlayer(playerid, casesda_TD[5]);

	TextDrawHideForPlayer(playerid, casesda_TD[3]);
	TextDrawSetString(casesda_TD[3], "pizda:brgiftsnuinfo");
	TextDrawShowForPlayer(playerid, casesda_TD[3]);

	TextDrawHideForPlayer(playerid, casesda_TD[8]);
	TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
	TextDrawShowForPlayer(playerid, casesda_TD[8]);

	TextDrawHideForPlayer(playerid, casesda_TD[2]);
	TextDrawSetString(casesda_TD[2], "500_P.");
	TextDrawShowForPlayer(playerid, casesda_TD[2]);

    typecase[playerid] = 3;
    }
    if(clickedid == casesda_TD[8])
    {
    TextDrawShowForPlayer(playerid, casesda_TD[1]);
	TextDrawShowForPlayer(playerid, casesda_TD[2]);
	TextDrawShowForPlayer(playerid, casesda_TD[9]);
 	TextDrawHideForPlayer(playerid, casesda_TD[0]);
   	TextDrawHideForPlayer(playerid, casesda_TD[7]);
	TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
	TextDrawShowForPlayer(playerid, casesda_TD[7]);

  	TextDrawHideForPlayer(playerid, casesda_TD[6]);
	TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
	TextDrawShowForPlayer(playerid, casesda_TD[6]);

    TextDrawHideForPlayer(playerid, casesda_TD[5]);
	TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
	TextDrawShowForPlayer(playerid, casesda_TD[5]);

	TextDrawHideForPlayer(playerid, casesda_TD[3]);
	TextDrawSetString(casesda_TD[3], "pizda:brgiftsnuinfo");
	TextDrawShowForPlayer(playerid, casesda_TD[3]);

	TextDrawHideForPlayer(playerid, casesda_TD[2]);
	TextDrawSetString(casesda_TD[2], "1000_P.");
	TextDrawShowForPlayer(playerid, casesda_TD[2]);

	TextDrawHideForPlayer(playerid, casesda_TD[8]);
	TextDrawSetString(casesda_TD[8], "pizda:brgiftsuautocase");
	TextDrawShowForPlayer(playerid, casesda_TD[8]);
    typecase[playerid] = 4 ;
    }
        if(clickedid == casesda_TD[9])
    {
	if(typecase[playerid] == 1)
	{
 		for(new i; i < sizeof casesda_TD;i++)
		{
			TextDrawHideForPlayer(playerid, casesda_TD[i]);
		}
		TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
		TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
			TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
			TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
    typecase[playerid] = 0;
	callcmd::openroulette(playerid, "");
	}
	else if(typecase[playerid] == 2)
	{
 		for(new i; i < sizeof casesda_TD;i++)
		{
			TextDrawHideForPlayer(playerid, casesda_TD[i]);
		}
		TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
		TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
			TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
			TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
    typecase[playerid] = 0;
	callcmd::openroulette_1(playerid, "");
	}
		else if(typecase[playerid] == 3)
	{
 		for(new i; i < sizeof casesda_TD;i++)
		{
			TextDrawHideForPlayer(playerid, casesda_TD[i]);
		}
		TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
		TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
			TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
			TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
    typecase[playerid] = 0;
	callcmd::openroulette_2(playerid, "");
	}
			else if(typecase[playerid] == 4)
	{
 		for(new i; i < sizeof casesda_TD;i++)
		{
			TextDrawHideForPlayer(playerid, casesda_TD[i]);
		}
		TextDrawSetString(casesda_TD[7], "pizda:brgiftsnugold");
		TextDrawSetString(casesda_TD[8], "pizda:brgiftsnuautocase");
			TextDrawSetString(casesda_TD[6], "pizda:brgiftsnusilver");
			TextDrawSetString(casesda_TD[5], "pizda:brgiftsnubronza");
    typecase[playerid] = 0;
	callcmd::openroulette3(playerid, "");
	}//roulette_1 openroulette_2 	callcmd::openroulette3(playerid, "");
    }
	#if defined roulette_OnPlayerClickTextDraw
        return roulette_OnPlayerClickTextDraw(playerid, clickedid);
    #else
        return 1;
    #endif
}
#if defined _ALS_OnPlayerClickTextDraw
    #undef OnPlayerClickTextDraw
#else
    #define _ALS_OnPlayerClickTextDraw
#endif
#define OnPlayerClickTextDraw roulette_OnPlayerClickTextDraw
#if defined roulette_OnPlayerClickTextDraw
    forward roulette_OnPlayerClickTextDraw(playerid, Text:clickedid);
#endif


stock addcarplayer(playerid, modelid, color_1, color_2, pos_x, pos_y, pos_z, angle)
{
new query[127];
new
   Cache: result;
 format
 (
  query, sizeof query,
  "INSERT INTO ownable_cars \
  (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
  VALUES \
  ('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
  GetPlayerAccountID(playerid),
  modelid,
  color_1,
  color_2,
  pos_x,
  pos_y,
  pos_z,
  angle,
  0
 );
 result = mysql_query(mysql, query, true);

 //SetOwnableCarData(idx, OC_SQL_ID, cache_insert_id());

 cache_delete(result);
}
stock addacs(playerid, modelid, x, y, z, rx, rz, ry, scale, slot, bone)
{
new
   Cache: result;
new query[127];
 format
 (
  query, sizeof query,
  "INSERT INTO accessories \
  (id,slot,modelid,bone,x,y,z,rX,rY,rZ,scale) \
  VALUES \
  ('%d','%d','%d','%d','%f','%f','%f','%d','%d','%d','%d')",
  GetPlayerAccountID(playerid),
  slot,
  modelid,
  bone,
  x,
  y,
  z,
  rx,
  rz,
  ry,
  scale
 );
 result = mysql_query(mysql, query, true);

 cache_delete(result);
}
stock randomexp(playerid)
{
    switch (random(6))
    {
        case 0:
        {
            new sqlMediumQuery[256],exp = 2;
            g_player[playerid][P_EXP] += exp;
            mysql_format(
    mysql, sqlMediumQuery, sizeof(sqlMediumQuery),
    "SELECT exp FROM `accounts` WHERE `exp` = '%d'",
    g_player[playerid][P_EXP]
);
        }
               case 1:
        {
            new sqlMediumQuery[256],exp = 10;
g_player[playerid][P_EXP] += exp;
            mysql_format(
    mysql, sqlMediumQuery, sizeof(sqlMediumQuery),
    "SELECT exp FROM `accounts` WHERE `exp` = '%d'",
    g_player[playerid][P_EXP]
);
        }
               case 2:
        {
            new sqlMediumQuery[256],exp = 7;
            g_player[playerid][P_EXP] += exp;
            mysql_format(
    mysql, sqlMediumQuery, sizeof(sqlMediumQuery),
    "SELECT exp FROM `accounts` WHERE `exp` = '%d'",
    g_player[playerid][P_EXP]
);
        }
               case 3:
        {
            new sqlMediumQuery[256],exp = 5;
            g_player[playerid][P_EXP] += exp;
            mysql_format(
    mysql, sqlMediumQuery, sizeof(sqlMediumQuery),
    "SELECT exp FROM `accounts` WHERE `exp` = '%d'",
    g_player[playerid][P_EXP]
);
        }
               case 4:
        {
            new sqlMediumQuery[256],exp = 8;
            g_player[playerid][P_EXP] += exp;
            mysql_format(
    mysql, sqlMediumQuery, sizeof(sqlMediumQuery),
    "SELECT exp FROM `accounts` WHERE `exp` = '%d'",
    g_player[playerid][P_EXP]
);
        }
                       case 5:
        {
            new sqlMediumQuery[127],exp = 9;
g_player[playerid][P_EXP] += exp;
            mysql_format(
    mysql, sqlMediumQuery, sizeof(sqlMediumQuery),
    "SELECT exp FROM `accounts` WHERE `exp` = '%d'",
    g_player[playerid][P_EXP]
);
        }

    }
    return 1;
}
stock randommoney(playerid)
{
    switch (random(6))
    {
        case 0:
        {
            GivePlayerMoneyEx(playerid, 60000);
        }
               case 1:
        {
            GivePlayerMoneyEx(playerid, 70000);
        }
               case 2:
        {
                GivePlayerMoneyEx(playerid, 80000);
        }
               case 3:
        {
                GivePlayerMoneyEx(playerid, 30000);
        }
               case 4:
        {
                GivePlayerMoneyEx(playerid, 100000);
        }
                       case 5:
        {
            GivePlayerMoneyEx(playerid, 50000);
        }

    }
    return 1;
}
stock givedonate(playerid, donate)
{
    new sqlMediumQuery[127];
g_player[playerid][P_DONATE] += donate;
mysql_format(
    mysql, sqlMediumQuery, sizeof(sqlMediumQuery),
    "SELECT donate FROM `accounts` WHERE `donate` = '%d'",
    g_player[playerid][P_DONATE]
);
}

CMD:giveautocase(playerid, params[])
{
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Недостаточно прав администратора.");

    new targetid, case_type, amount;
    if(sscanf(params, "udd", targetid, case_type, amount))
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Используйте: /giveautocase [playerid] [type] [count], где type: 1-Бронза, 2-Серебро, 3-Золото, 4-Авто.");

    if(!IsPlayerConnected(targetid) || !IsPlayerLogged(targetid))
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Игрок не найден или не авторизован.");

    if(amount < 1)
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Количество должно быть больше 0.");

    new case_name[64];
    switch(case_type)
    {
        case 1:
        {
            LoadRuletka(targetid);
            player_roulette_bronz[targetid] += amount;
            UpdatePlayerDatabaseInt(targetid, "roulette_bronz", player_roulette_bronz[targetid]);
            format(case_name, sizeof case_name, "бронзовый кейс");
        }
        case 2:
        {
            LoadRuletka_1(targetid);
            player_roulette_bronz_1[targetid] += amount;
            UpdatePlayerDatabaseInt(targetid, "roulette_silver", player_roulette_bronz_1[targetid]);
            format(case_name, sizeof case_name, "серебряный кейс");
        }
        case 3:
        {
            LoadRuletka_2(targetid);
            player_roulette_bronz_2[targetid] += amount;
            UpdatePlayerDatabaseInt(targetid, "roulette_gold", player_roulette_bronz_2[targetid]);
            format(case_name, sizeof case_name, "золотой кейс");
        }
        case 4:
        {
            LoadRuletka3(targetid);
            player_roulette_bronz3[targetid] += amount;
            UpdatePlayerDatabaseInt(targetid, "roulette_auto", player_roulette_bronz3[targetid]);
            format(case_name, sizeof case_name, "автокейс");
        }
        default:
        {
            return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Неизвестный тип кейса. Используйте 1, 2, 3 или 4.");
        }
    }

    new string[144];
    format(string, sizeof string, "{66cc00}| {ffffff}Вы выдали %d шт. (%s) игроку %s[%d].", amount, case_name, GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, -1, string);

    format(string, sizeof string, "{66cc00}| {ffffff}Администратор %s выдал вам %d шт. (%s).", GetPlayerNameEx(playerid), amount, case_name);
    SendClientMessage(targetid, -1, string);
    return 1;
}

CMD:giverandomautocase(playerid)
{
    if(GetPlayerAdminEx(playerid) < 6) return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}Недостаточно прав администратора.");

    new online_players[MAX_PLAYERS], online_count;
    for(new i; i < MAX_PLAYERS; i++)
    {
        if(!IsPlayerConnected(i) || !IsPlayerLogged(i)) continue;
        online_players[online_count++] = i;
    }

    if(!online_count)
        return SendClientMessage(playerid, -1, "{ff2400}| {ffffff}На сервере нет доступных игроков.");

    new targetid = online_players[random(online_count)];

    LoadRuletka3(targetid);
    player_roulette_bronz3[targetid]++;
    UpdatePlayerDatabaseInt(targetid, "roulette_auto", player_roulette_bronz3[targetid]);

    new string[144];
    format(string, sizeof string, "{66cc00}| {ffffff}Случайный игрок %s[%d] получил 1 автокейс.", GetPlayerNameEx(targetid), targetid);
    SendClientMessage(playerid, -1, string);

    format(string, sizeof string, "{66cc00}| {ffffff}Администратор %s выдал вам 1 автокейс.", GetPlayerNameEx(playerid));
    SendClientMessage(targetid, -1, string);
    return 1;
}

cmd:cases(playerid)
{
for(new i; i < sizeof casesda_TD;i++)
{
TextDrawShowForPlayer(playerid, casesda_TD[i]);
TextDrawHideForPlayer(playerid, casesda_TD[1]);
TextDrawHideForPlayer(playerid, casesda_TD[2]);
TextDrawHideForPlayer(playerid, casesda_TD[9]);
}
TextDrawHideForPlayer(playerid, casesda_TD[3]);
TextDrawSetString(casesda_TD[3], "pizda:brgiftsuinfo");
TextDrawShowForPlayer(playerid, casesda_TD[3]);
SelectTextDraw(playerid, 0x009900FF);
}
CMD:openroulette(playerid)
{
	TogglePlayerControllable(playerid, false);
	HideHud(playerid);
	RuletkaPlayer(playerid);
    SelectTextDraw(playerid, -1);
	for(new i;i < 20;i++) SendClientMessage(playerid, -1, "");

	for(new t;t < sizeof welsirltk_TD;t++)
	{
		TextDrawShowForPlayer(playerid, welsirltk_TD[t]);
	}

	for(new t,welsi;t < 5;t++, welsi = random(12))
	{
		PlayerTextDrawSetString(playerid, ruletka_PTD[playerid][t], ruletka_prize[welsi][R_NAME_TXD]);
		PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][t], ruletka_prize[welsi][R_NAME_TEXT]);
		PlayerTextDrawShow(playerid, ruletka_PTD[playerid][t]);
		PlayerTextDrawShow(playerid, ruletka_PTD_t[playerid][t]);
		menu_prize_player[playerid][t] = welsi;
	}

    UpdateLastPlayerRuletka(playerid);

    for(new i; i < 3;i++)
    {
        PlayerTextDrawShow(playerid, ruletka_PTD_t[playerid][last_player_td[i][0]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t[playerid][last_player_td[i][1]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t[playerid][last_player_td[i][2]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t[playerid][last_player_td[i][3]]);
    }

    new string[10];
    format(string, sizeof string, "%d", player_roulette_bronz[playerid]);
    PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][17], string);

    PlayerTextDrawShow(playerid, ruletka_PTD_t[playerid][17]);
    return 1;
}
stock RuletkaMenu()
{
    welsirltk_TD[0] = TextDrawCreate(3.6665, 208.3332, "txd:brgiftsdownpanel"); // пусто
    TextDrawTextSize(welsirltk_TD[0], 624.0000, 209.0000);
    TextDrawAlignment(welsirltk_TD[0], 1);
    TextDrawColor(welsirltk_TD[0], -1);
    TextDrawBackgroundColor(welsirltk_TD[0], 255);
    TextDrawFont(welsirltk_TD[0], 4);
    TextDrawSetProportional(welsirltk_TD[0], 0);
    TextDrawSetShadow(welsirltk_TD[0], 0);

    welsirltk_TD[1] = TextDrawCreate(47.2378, 11.6280, "txd:brgiftsbgspin"); // пусто
    TextDrawTextSize(welsirltk_TD[1], 530.0000, 49.0000);
    TextDrawAlignment(welsirltk_TD[1], 1);
    TextDrawColor(welsirltk_TD[1], -1);
    TextDrawBackgroundColor(welsirltk_TD[1], 255);
    TextDrawFont(welsirltk_TD[1], 4);
    TextDrawSetProportional(welsirltk_TD[1], 0);
    TextDrawSetShadow(welsirltk_TD[1], 0);
    TextDrawSetSelectable(welsirltk_TD[1], true);

    welsirltk_TD[2] = TextDrawCreate(255.0950, 167.3733, "txd:brgiftsdostupno"); // пусто
    TextDrawTextSize(welsirltk_TD[2], 87.0000, 27.0000);
    TextDrawAlignment(welsirltk_TD[2], 1);
    TextDrawColor(welsirltk_TD[2], -1);
    TextDrawBackgroundColor(welsirltk_TD[2], 255);
    TextDrawFont(welsirltk_TD[2], 4);
    TextDrawSetProportional(welsirltk_TD[2], 0);
    TextDrawSetShadow(welsirltk_TD[2], 0);

    welsirltk_TD[4] = TextDrawCreate(114.1427, 66.2651, "txd:brgiftsbuycase"); // пусто
    TextDrawTextSize(welsirltk_TD[4], 105.0000, 70.0000);
    TextDrawAlignment(welsirltk_TD[4], 1);
    TextDrawColor(welsirltk_TD[4], -1);
    TextDrawBackgroundColor(welsirltk_TD[4], 255);
    TextDrawFont(welsirltk_TD[4], 4);
    TextDrawSetProportional(welsirltk_TD[4], 0);
    TextDrawSetShadow(welsirltk_TD[4], 0);
    TextDrawSetSelectable(welsirltk_TD[4], true);

    welsirltk_TD[5] = TextDrawCreate(553.9045, 366.4369, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[5], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[5], 1);
    TextDrawColor(welsirltk_TD[5], -1);
    TextDrawBackgroundColor(welsirltk_TD[5], 255);
    TextDrawFont(welsirltk_TD[5], 4);
    TextDrawSetProportional(welsirltk_TD[5], 0);
    TextDrawSetShadow(welsirltk_TD[5], 0);

    welsirltk_TD[6] = TextDrawCreate(586.6188, 399.6828, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[6], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[6], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[6], 2);
    TextDrawColor(welsirltk_TD[6], -1);
    TextDrawBackgroundColor(welsirltk_TD[6], 255);
    TextDrawFont(welsirltk_TD[6], 1);
    TextDrawSetProportional(welsirltk_TD[6], 1);
    TextDrawSetShadow(welsirltk_TD[6], 0);

    welsirltk_TD[7] = TextDrawCreate(196.6666, 288.5704, "txd:brgiftbronzatext"); // пусто
    TextDrawTextSize(welsirltk_TD[7], 171.0000, 202.0000);
    TextDrawAlignment(welsirltk_TD[7], 1);
    TextDrawColor(welsirltk_TD[7], -1);
    TextDrawBackgroundColor(welsirltk_TD[7], 255);
    TextDrawFont(welsirltk_TD[7], 4);
    TextDrawSetProportional(welsirltk_TD[7], 0);
    TextDrawSetShadow(welsirltk_TD[7], 0);

    welsirltk_TD[8] = TextDrawCreate(239.3332, 219.0370, "БРОНЗОВЫЙ"); // пусто
    TextDrawLetterSize(welsirltk_TD[8], 0.3193, 1.7368);
    TextDrawTextSize(welsirltk_TD[8], -6.0000, 0.0000);
    TextDrawAlignment(welsirltk_TD[8], 1);
    TextDrawColor(welsirltk_TD[8], -1);
    TextDrawBackgroundColor(welsirltk_TD[8], 255);
    TextDrawFont(welsirltk_TD[8], 2);
    TextDrawSetProportional(welsirltk_TD[8], 1);
    TextDrawSetShadow(welsirltk_TD[8], 0);

    welsirltk_TD[9] = TextDrawCreate(399.5713, 366.8517, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[9], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[9], 1);
    TextDrawColor(welsirltk_TD[9], -1); 
    TextDrawBackgroundColor(welsirltk_TD[9], 255);
    TextDrawFont(welsirltk_TD[9], 4);
    TextDrawSetProportional(welsirltk_TD[9], 0);
    TextDrawSetShadow(welsirltk_TD[9], 0);

    welsirltk_TD[10] = TextDrawCreate(433.2857, 400.5124, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[10], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[10], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[10], 2);
    TextDrawColor(welsirltk_TD[10], -1);
    TextDrawBackgroundColor(welsirltk_TD[10], 255);
    TextDrawFont(welsirltk_TD[10], 1);
    TextDrawSetProportional(welsirltk_TD[10], 1);
    TextDrawSetShadow(welsirltk_TD[10], 0);

    welsirltk_TD[11] = TextDrawCreate(476.2379, 366.4370, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[11], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[11], 1);
    TextDrawColor(welsirltk_TD[11], -1);
    TextDrawBackgroundColor(welsirltk_TD[11], 255);
    TextDrawFont(welsirltk_TD[11], 4);
    TextDrawSetProportional(welsirltk_TD[11], 0);
    TextDrawSetShadow(welsirltk_TD[11], 0);
 
    welsirltk_TD[12] = TextDrawCreate(509.6188, 400.5125, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[12], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[12], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[12], 2);
    TextDrawColor(welsirltk_TD[12], -1);
    TextDrawBackgroundColor(welsirltk_TD[12], 255);
    TextDrawFont(welsirltk_TD[12], 1);
    TextDrawSetProportional(welsirltk_TD[12], 1);
    TextDrawSetShadow(welsirltk_TD[12], 0);

    welsirltk_TD[13] = TextDrawCreate(551.9046, 213.7850, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[13], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[13], 1); 
    TextDrawColor(welsirltk_TD[13], -1);
    TextDrawBackgroundColor(welsirltk_TD[13], 255);
    TextDrawFont(welsirltk_TD[13], 4);
    TextDrawSetProportional(welsirltk_TD[13], 0);
    TextDrawSetShadow(welsirltk_TD[13], 0);

    welsirltk_TD[14] = TextDrawCreate(585.9521, 247.4457, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[14], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[14], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[14], 2);
    TextDrawColor(welsirltk_TD[14], -1);
    TextDrawBackgroundColor(welsirltk_TD[14], 255);
    TextDrawFont(welsirltk_TD[14], 1);
    TextDrawSetProportional(welsirltk_TD[14], 1);
    TextDrawSetShadow(welsirltk_TD[14], 0);

    welsirltk_TD[15] = TextDrawCreate(399.2380, 214.1998, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[15], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[15], 1);
    TextDrawColor(welsirltk_TD[15], -1);
    TextDrawBackgroundColor(welsirltk_TD[15], 255);
    TextDrawFont(welsirltk_TD[15], 4);
    TextDrawSetProportional(welsirltk_TD[15], 0);
    TextDrawSetShadow(welsirltk_TD[15], 0);

    welsirltk_TD[16] = TextDrawCreate(432.9524, 247.8605, "љo_100000_p."); // пусто
     
    TextDrawLetterSize(welsirltk_TD[16], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[16], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[16], 2);
    TextDrawColor(welsirltk_TD[16], -1);
    TextDrawBackgroundColor(welsirltk_TD[16], 255);
    TextDrawFont(welsirltk_TD[16], 1);
    TextDrawSetProportional(welsirltk_TD[16], 1);
    TextDrawSetShadow(welsirltk_TD[16], 0);

    welsirltk_TD[17] = TextDrawCreate(475.9046, 213.7850, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[17], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[17], 1);
    TextDrawColor(welsirltk_TD[17], -1);
    TextDrawBackgroundColor(welsirltk_TD[17], 255);
    TextDrawFont(welsirltk_TD[17], 4);
    TextDrawSetProportional(welsirltk_TD[17], 0);
    TextDrawSetShadow(welsirltk_TD[17], 0);

    welsirltk_TD[34] = TextDrawCreate(580.9998, 2.0888, ""); // пусто
    welsirltk_TD[18] = TextDrawCreate(509.2855, 247.8606, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[18], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[18], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[18], 2);
    TextDrawColor(welsirltk_TD[18], -1);
    TextDrawBackgroundColor(welsirltk_TD[18], 255);
    TextDrawFont(welsirltk_TD[18], 1);
    TextDrawSetProportional(welsirltk_TD[18], 1);
    TextDrawSetShadow(welsirltk_TD[18], 0);

    welsirltk_TD[19] = TextDrawCreate(551.5712, 264.8072, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[19], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[19], 1); 
    TextDrawColor(welsirltk_TD[19], -1);
    TextDrawBackgroundColor(welsirltk_TD[19], 255);
    TextDrawFont(welsirltk_TD[19], 4);
    TextDrawSetProportional(welsirltk_TD[19], 0);
    TextDrawSetShadow(welsirltk_TD[19], 0);

    welsirltk_TD[20] = TextDrawCreate(585.6187, 298.4679, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[20], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[20], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[20], 2);
    TextDrawColor(welsirltk_TD[20], -1);
    TextDrawBackgroundColor(welsirltk_TD[20], 255);
    TextDrawFont(welsirltk_TD[20], 1); 
    TextDrawSetProportional(welsirltk_TD[20], 1);
    TextDrawSetShadow(welsirltk_TD[20], 0);

    TextDrawLetterSize(welsirltk_TD[34], 0.1480, 0.8740);
    TextDrawTextSize(welsirltk_TD[34], -101.0000, 0.0000);
    TextDrawAlignment(welsirltk_TD[34], 1);
    TextDrawColor(welsirltk_TD[34], -81);
    TextDrawBackgroundColor(welsirltk_TD[34], 255);
    TextDrawFont(welsirltk_TD[34], 1);
    TextDrawSetProportional(welsirltk_TD[34], 1);
    TextDrawSetShadow(welsirltk_TD[34], 0);

    welsirltk_TD[21] = TextDrawCreate(398.9046, 265.2220, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[21], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[21], 1);
    TextDrawColor(welsirltk_TD[21], -1);
    TextDrawBackgroundColor(welsirltk_TD[21], 255);
    TextDrawFont(welsirltk_TD[21], 4);
    TextDrawSetProportional(welsirltk_TD[21], 0);
    TextDrawSetShadow(welsirltk_TD[21], 0);

    welsirltk_TD[22] = TextDrawCreate(432.6191, 298.8827, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[22], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[22], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[22], 2);
    TextDrawColor(welsirltk_TD[22], -1);
    TextDrawBackgroundColor(welsirltk_TD[22], 255);
    TextDrawFont(welsirltk_TD[22], 1);
    TextDrawSetProportional(welsirltk_TD[22], 1);
    TextDrawSetShadow(welsirltk_TD[22], 0);

    welsirltk_TD[23] = TextDrawCreate(475.5713, 264.8073, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[23], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[23], 1);
    TextDrawColor(welsirltk_TD[23], -1);
    TextDrawBackgroundColor(welsirltk_TD[23], 255);
    TextDrawFont(welsirltk_TD[23], 4);
    TextDrawSetProportional(welsirltk_TD[23], 0);
    TextDrawSetShadow(welsirltk_TD[23], 0);

    welsirltk_TD[24] = TextDrawCreate(508.9522, 298.8828, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[24], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[24], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[24], 2);
    TextDrawColor(welsirltk_TD[24], -1);  
    TextDrawBackgroundColor(welsirltk_TD[24], 255);
    TextDrawFont(welsirltk_TD[24], 1);
    TextDrawSetProportional(welsirltk_TD[24], 1);
    TextDrawSetShadow(welsirltk_TD[24], 0);

    welsirltk_TD[25] = TextDrawCreate(552.2379, 315.4146, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[25], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[25], 1);
    TextDrawColor(welsirltk_TD[25], -1);
    TextDrawBackgroundColor(welsirltk_TD[25], 255);
    TextDrawFont(welsirltk_TD[25], 4);
    TextDrawSetProportional(welsirltk_TD[25], 0);
    TextDrawSetShadow(welsirltk_TD[25], 0);

    welsirltk_TD[26] = TextDrawCreate(586.2855, 349.0754, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[26], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[26], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[26], 2);
    TextDrawColor(welsirltk_TD[26], -1);
    TextDrawBackgroundColor(welsirltk_TD[26], 255);
    TextDrawFont(welsirltk_TD[26], 1);
    TextDrawSetProportional(welsirltk_TD[26], 1);
    TextDrawSetShadow(welsirltk_TD[26], 0);

    welsirltk_TD[27] = TextDrawCreate(399.5713, 315.8294, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[27], 70.0000, 44.0000); 
    TextDrawAlignment(welsirltk_TD[27], 1);
    TextDrawColor(welsirltk_TD[27], -1);
    TextDrawBackgroundColor(welsirltk_TD[27], 255);
    TextDrawFont(welsirltk_TD[27], 4);
    TextDrawSetProportional(welsirltk_TD[27], 0);
    TextDrawSetShadow(welsirltk_TD[27], 0);

    welsirltk_TD[28] = TextDrawCreate(433.2857, 349.4902, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[28], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[28], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[28], 2);
    TextDrawColor(welsirltk_TD[28], -1);
    TextDrawBackgroundColor(welsirltk_TD[28], 255);
    TextDrawFont(welsirltk_TD[28], 1);
    TextDrawSetProportional(welsirltk_TD[28], 1);
    TextDrawSetShadow(welsirltk_TD[28], 0); 

    welsirltk_TD[29] = TextDrawCreate(476.2379, 315.4147, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD[29], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD[29], 1);
    TextDrawColor(welsirltk_TD[29], -1);
    TextDrawBackgroundColor(welsirltk_TD[29], 255);
    TextDrawFont(welsirltk_TD[29], 4);
    TextDrawSetProportional(welsirltk_TD[29], 0);
    TextDrawSetShadow(welsirltk_TD[29], 0);

    welsirltk_TD[30] = TextDrawCreate(509.6188, 349.4902, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD[30], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD[30], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD[30], 2);
    TextDrawColor(welsirltk_TD[30], -1);
    TextDrawBackgroundColor(welsirltk_TD[30], 255); 
    TextDrawFont(welsirltk_TD[30], 1);
    TextDrawSetProportional(welsirltk_TD[30], 1);
    TextDrawSetShadow(welsirltk_TD[30], 0);

    welsirltk_TD[31] = TextDrawCreate(27.5713, 143.9302, "txd:brgiftsupdate"); // пусто
    TextDrawTextSize(welsirltk_TD[31], 126.0000, 74.0000);
    TextDrawAlignment(welsirltk_TD[31], 1);
    TextDrawColor(welsirltk_TD[31], -1);
    TextDrawBackgroundColor(welsirltk_TD[31], 255);
    TextDrawFont(welsirltk_TD[31], 4);
    TextDrawSetProportional(welsirltk_TD[31], 0);
    TextDrawSetShadow(welsirltk_TD[31], 0);
    TextDrawSetSelectable(welsirltk_TD[31], true);

    welsirltk_TD[32] = TextDrawCreate(528.2379, 159.6932, "ruletka:brgiftsexit"); // пусто
    TextDrawTextSize(welsirltk_TD[32], 91.0000, 56.0000);
    TextDrawAlignment(welsirltk_TD[32], 1);
    TextDrawColor(welsirltk_TD[32], -1);
    TextDrawBackgroundColor(welsirltk_TD[32], 255); 
    TextDrawFont(welsirltk_TD[32], 4);
    TextDrawSetProportional(welsirltk_TD[32], 0);
    TextDrawSetShadow(welsirltk_TD[32], 0);
    TextDrawSetSelectable(welsirltk_TD[32], true);

    welsirltk_TD[33] = TextDrawCreate(259.6665, 68.3864, "ruletka:brgiftsspin"); // пусто
    TextDrawTextSize(welsirltk_TD[33], 110.0000, 66.0000);
    TextDrawAlignment(welsirltk_TD[33], 1);
    TextDrawColor(welsirltk_TD[33], -1);
    TextDrawBackgroundColor(welsirltk_TD[33], 255);
    TextDrawFont(welsirltk_TD[33], 4);
    TextDrawSetProportional(welsirltk_TD[33], 0);
    TextDrawSetShadow(welsirltk_TD[33], 0);
    TextDrawSetSelectable(welsirltk_TD[33], true);
}

stock RuletkaPlayer(playerid) 
{
	ruletka_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 430.2377, 13.7539, "txd:brgiftslic"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD[playerid][0], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD[playerid][0], 0);

	ruletka_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 352.6664, 13.7340, "txd:brgiftsuncar"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD[playerid][1], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD[playerid][1], 1); 
	PlayerTextDrawColor(playerid, ruletka_PTD[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD[playerid][1], 0);

	ruletka_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 276.3807, 14.9784, "txd:brgiftsgvip"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD[playerid][2], 70.0000, 44.0000); 
	PlayerTextDrawAlignment(playerid, ruletka_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD[playerid][2], 0);

	ruletka_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 123.9045, 14.6739, "txd:brgiftscash"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD[playerid][4], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD[playerid][4], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD[playerid][4], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD[playerid][4], 4); 
	PlayerTextDrawSetProportional(playerid, ruletka_PTD[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD[playerid][4], 0);

	ruletka_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 200.4284, 15.0650, "txd:brgiftsgun"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD[playerid][3], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD[playerid][3], -1); 
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD[playerid][3], 0);

	ruletka_PTD_t[playerid][1] = CreatePlayerTextDraw(playerid, 389.3807, 44.9925, "BMW_M5_F90"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][1] , 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][1] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][1] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][1] , -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][1] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][1] , 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][1] , 1); 
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][1] , 0);

	ruletka_PTD_t[playerid][2]  = CreatePlayerTextDraw(playerid, 311.8570, 46.6399, "Gold-Vip"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][2] , 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][2] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][2] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][2] , -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][2] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][2] , 1); 
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][2] , 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][2] , 0);

	ruletka_PTD_t[playerid][3]  = CreatePlayerTextDraw(playerid, 235.2379, 47.0784, "Случайное оружие"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][3] , 0.1946, 0.7720); 
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][3] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][3] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][3] , -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][3] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][3] , 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][3] , 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][3] , 0); 

	ruletka_PTD_t[playerid][4]  = CreatePlayerTextDraw(playerid, 157.2856, 48.3346, "до 100000 р."); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][4] , 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][4] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][4] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][4] , -1); 
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][4] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][4] , 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][4] , 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][4] , 0);

	ruletka_PTD_t[playerid][0]  = CreatePlayerTextDraw(playerid, 466.8570, 45.8340, "Пакет с лицензиями"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][0] , 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][0] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][0] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][0] , -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][0] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][0] , 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][0] , 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][0] , 0);

    ruletka_PTD_t[playerid][5] = CreatePlayerTextDraw(playerid, 11.6664, 358.4451, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][5], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][5], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][5], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][5], 0);

    ruletka_PTD_t[playerid][6] = CreatePlayerTextDraw(playerid, 99.6666, 361.7334, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][6], 0.2506, 1.2391);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][6], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][6], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][6], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][6], 0);

    ruletka_PTD_t[playerid][7] = CreatePlayerTextDraw(playerid, 47.7141, 388.8739, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][7], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][7], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][7], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][7], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][7], 0);

    ruletka_PTD_t[playerid][8] = CreatePlayerTextDraw(playerid, 86.9999, 376.6668, "ЂPOH€O‹‘† KE†C"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][8], 0.1793, 1.0897);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][8], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][8], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][8], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][8], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][8], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][8], 0);

    ruletka_PTD_t[playerid][9] = CreatePlayerTextDraw(playerid, 10.9998, 305.7636, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][9], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][9], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][9], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][9], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][9], 0);

    ruletka_PTD_t[playerid][10] = CreatePlayerTextDraw(playerid, 47.3807, 336.1924, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][10], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][10], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][10], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][10], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][10], 0);

    ruletka_PTD_t[playerid][11] = CreatePlayerTextDraw(playerid, 99.6666, 308.2222, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][11], 0.2526, 1.2640);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][11], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][11], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][11], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][11], 0);

    ruletka_PTD_t[playerid][12] = CreatePlayerTextDraw(playerid, 86.9999, 323.1556, "ЂPOH€O‹‘† KE†C"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][12], 0.1813, 1.1146);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][12], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][12], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][12], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][12], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][12], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][12], 0);

    ruletka_PTD_t[playerid][13] = CreatePlayerTextDraw(playerid,11.3331, 253.0822, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][13], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][13], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][13], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][13], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][13], 0);

    ruletka_PTD_t[playerid][14] = CreatePlayerTextDraw(playerid,47.7141, 283.5110, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][14], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][14], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][14], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][14], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][14], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][14], 0);

    ruletka_PTD_t[playerid][15] = CreatePlayerTextDraw(playerid,99.6666, 256.3703, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][15], 0.2526, 1.2640);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][15], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][15], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][15], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][15], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][15], 0);
 
    ruletka_PTD_t[playerid][16] = CreatePlayerTextDraw(playerid,86.9999, 271.3037, "ЂPOH€O‹‘† KE†C"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][16], 0.1813, 1.1146);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t[playerid][16], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][16], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][16], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][16], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][16], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][16], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][16], 0);


    ruletka_PTD_t[playerid][17] = CreatePlayerTextDraw(playerid, 317.3334, 173.8222, "4"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t[playerid][17], 0.2939, 1.3386);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t[playerid][17], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t[playerid][17], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t[playerid][17], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t[playerid][17], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t[playerid][17], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t[playerid][17], 0);
}

public:RunRuletka(playerid)
{
	animation_player[playerid] = true;

	if(ruletka_count[playerid])
	{
		new text[135];
 
		if(ruletka_count[playerid] == 15)
		{
			format(text, sizeof text, "Поздравляем! Вам выпал %s{FFFF00}.{FFFFFF} Чтобы забрать приз {FFFF00}/roulette", ruletka_prize[menu_prize_player[playerid][2]][R_NAME_PRIZE]);
			SendClientMessage(playerid, -1, text);
            GivePrizeRoulette(playerid, menu_prize_player[playerid][2]);

			animation_player[playerid] = false;
			KillTimer(timer_player_ruletka[playerid]);
			timer_player_ruletka[playerid] = -1;
			ruletka_count[playerid]=0;

            format(last_player_ruletka[0][last_player_name], 24, last_player_ruletka[1][last_player_name]);
            last_player_ruletka[0][id_ruletka_prize] = last_player_ruletka[1][id_ruletka_prize];
            format(last_player_ruletka[1][last_player_name], 24, last_player_ruletka[2][last_player_name]);
            last_player_ruletka[1][id_ruletka_prize] = last_player_ruletka[2][id_ruletka_prize];
            format(last_player_ruletka[2][last_player_name], 24, GetPlayerNameEx(playerid));
            last_player_ruletka[2][id_ruletka_prize] = menu_prize_player[playerid][2];

			return 1;
		}
		else
		{
			ruletka_count[playerid]++;

			new o = 5;
			while(o > 1)
			{
				o--;
				PlayerTextDrawSetString(playerid, ruletka_PTD[playerid][o], ruletka_prize[menu_prize_player[playerid][o-1]][R_NAME_TXD]);
				PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][o], ruletka_prize[menu_prize_player[playerid][o-1]][R_NAME_TEXT]);
				menu_prize_player[playerid][o] = menu_prize_player[playerid][o-1];
 
			}

            new array[] = {2,2,8,8,8,8,8,8,8,8,16,18};
			menu_prize_player[playerid][0] = random2(array);
			PlayerTextDrawSetString(playerid, ruletka_PTD[playerid][0], ruletka_prize[menu_prize_player[playerid][0]][R_NAME_TXD]);
			PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][0], ruletka_prize[menu_prize_player[playerid][0]][R_NAME_TEXT]);
		}
	}
	else
	{
		ruletka_count[playerid]=1;
	}
 
	return 1;
}

stock UpdateLastPlayerRuletka(playerid)
{
    for(new i; i < 3;i++)
    {
        PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][last_player_td[i][0]], last_player_ruletka[i][last_player_name]);
        PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][last_player_td[i][1]], ruletka_prize[last_player_ruletka[i][id_ruletka_prize]][R_NAME_TXD]);
        PlayerTextDrawSetString(playerid, ruletka_PTD_t[playerid][last_player_td[i][2]], ruletka_prize[last_player_ruletka[i][id_ruletka_prize]][R_NAME_TEXT]);
    } 

    return 1;
}
 
random2(array[], size_w = sizeof(array))
 {
	if(size_w < 1) return -1;
	new sum = 0, result = 0;

	for(new i = size_w - 1; i > -1; i--)
	{
		sum += array[i];
		 if(random(sum) < array[i])
		  {
			result = i;
		  } 
	}
		    return result;
}

stock GivePrizeRoulette(playerid, prize_id)
{
    new query[94]; 
    mysql_format(mysql, query, sizeof query, "INSERT INTO roulette_prize (owner, prize) VALUES (%d,%d)", GetPlayerAccountID(playerid), prize_id);
    mysql_query(mysql, query, false);

    if(mysql_errno()) SendClientMessage(playerid, -1, "Ошибка в запросе."); 

    return 1;
}

stock GetRouletteCurrentDateKey()
{
    new year, month, day;
    getdate(year, month, day);
    return year * 10000 + month * 100 + day;
}

public Roulette_InitPlayerData(playerid)
{
    if(!IsPlayerConnected(playerid)) return 1;

    if(!IsPlayerLogged(playerid))
    {
        SetTimerEx("Roulette_InitPlayerData", 3000, false, "d", playerid);
        return 1;
    }

    LoadRuletka(playerid);
    LoadRuletka_1(playerid);
    LoadRuletka_2(playerid);
    LoadRuletka3(playerid);

    if(timer_player_roulette_online[playerid] == -1)
    {
        timer_player_roulette_online[playerid] = SetTimerEx("Roulette_ProcessOnlineReward", 60000, true, "d", playerid);
    }
    return 1;
}

public Roulette_ProcessOnlineReward(playerid)
{
    if(!IsPlayerConnected(playerid) || !IsPlayerLogged(playerid))
    {
        if(timer_player_roulette_online[playerid] != -1)
        {
            KillTimer(timer_player_roulette_online[playerid]);
            timer_player_roulette_online[playerid] = -1;
        }
        return 1;
    }

    new current_day = GetRouletteCurrentDateKey();
    if(player_roulette_online_day[playerid] != current_day)
    {
        player_roulette_online_day[playerid] = current_day;
        player_roulette_online_minutes[playerid] = 0;
        UpdatePlayerDatabaseInt(playerid, "roulette_online_day", player_roulette_online_day[playerid]);
        UpdatePlayerDatabaseInt(playerid, "roulette_online_minutes", player_roulette_online_minutes[playerid]);
    }

    if(player_roulette_online_minutes[playerid] >= ROULETTE_ONLINE_REWARD_MINUTES)
        return 1;

    player_roulette_online_minutes[playerid]++;

    if(player_roulette_online_minutes[playerid] == ROULETTE_ONLINE_REWARD_MINUTES)
    {
        player_roulette_bronz[playerid]++;

        UpdatePlayerDatabaseInt(playerid, "roulette_bronz", player_roulette_bronz[playerid]);

        new string[96];
        format(string, sizeof string, "{66cc00}| {ffffff}Вы получили 1 бронзовый кейс за 2 часа игры сегодня.");
        SendClientMessage(playerid, -1, string);
    }

    UpdatePlayerDatabaseInt(playerid, "roulette_online_day", player_roulette_online_day[playerid]);
    UpdatePlayerDatabaseInt(playerid, "roulette_online_minutes", player_roulette_online_minutes[playerid]);
    return 1;
}

public: CreateTablistRoulette()
{ 
    new Cache:cache = mysql_query(mysql, "SELECT * FROM roulette_prize", true); 

    if(mysql_errno())
    {
        mysql_query(mysql, "CREATE TABLE .`roulette_prize` ( `id` INT NOT NULL AUTO_INCREMENT , `owner` INT NOT NULL , `prize` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB", false);

        if(mysql_errno()) printf("%d error create tablist roulette_prize", mysql_errno());
    }


    cache_delete(cache);

    cache = mysql_query(mysql, "SELECT * FROM accounts WHERE roulette_bronz", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `roulette_bronz` INT NOT NULL DEFAULT '0' AFTER `money`", false);

        if(mysql_errno()) printf("%d error alter roulette_bronz", mysql_errno());
    }
 
    cache_delete(cache);

    cache = mysql_query(mysql, "SELECT * FROM accounts WHERE roulette_online_minutes", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `roulette_online_minutes` INT NOT NULL DEFAULT '0' AFTER `roulette_bronz`", false);

        if(mysql_errno()) printf("%d error alter roulette_online_minutes", mysql_errno());
    }

    cache_delete(cache);

    cache = mysql_query(mysql, "SELECT * FROM accounts WHERE roulette_online_day", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `roulette_online_day` INT NOT NULL DEFAULT '0' AFTER `roulette_online_minutes`", false);

        if(mysql_errno()) printf("%d error alter roulette_online_day", mysql_errno());
    }

    cache_delete(cache);

    return 1;
}

stock GivePlayerCarRoulette(playerid, modelid, color_1, color_2) 
{
		new to_player = playerid;
		new Float:POS[3];
		GetPlayerPos(to_player, POS[0],POS[1],POS[2]);
		new Float: pos_x = POS[0];
		new Float: pos_y = POS[1];
		new Float: pos_z = POS[2];
		new Float: angle = 356.7986;
		new query[220],
			Cache: result,
			idx;

		idx = GetFreeOwnableCarID();
		SetOwnableCarData(idx, OC_OWNER_ID, 	GetPlayerAccountID(to_player));
		SetOwnableCarData(idx, OC_MODEL_ID, 	modelid);
		SetOwnableCarData(idx, OC_COLOR_1, 		color_1);
		SetOwnableCarData(idx, OC_COLOR_2, 		color_2);
		SetOwnableCarData(idx, OC_POS_X, 		pos_x);
		SetOwnableCarData(idx, OC_POS_Y, 		pos_y);
		SetOwnableCarData(idx, OC_POS_Z, 		pos_z);
		SetOwnableCarData(idx, OC_ANGLE, 		angle);
		strmid(g_ownable_car[idx][OC_NUMBER], "--------", 0, 8, 8);
		SetOwnableCarData(idx, OC_ALARM, 		false);
		SetOwnableCarData(idx, OC_KEY_IN, 		true);
		SetOwnableCarData(idx, OC_CREATE, 		gettime());
		/*new idt = GetFreeOwnableCarID();*/
		format(g_ownable_car[idx][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));
		//SetVehicleRuNumberPlate(vehicleid, g_ownable_car[idt][OC_NUMBER], "52");

		// ----------------------------------------------------------------------------------------
 
		new vehicleid = CreateVehicle
		(
			GetOwnableCarData(idx, OC_MODEL_ID),
			GetOwnableCarData(idx, OC_POS_X),
			GetOwnableCarData(idx, OC_POS_Y),
			GetOwnableCarData(idx, OC_POS_Z),
			GetOwnableCarData(idx, OC_ANGLE),
			GetOwnableCarData(idx, OC_COLOR_1),
			GetOwnableCarData(idx, OC_COLOR_2),
			-1,
			0,
			VEHICLE_ACTION_TYPE_OWNABLE_CAR,
			idx
		);
		if(vehicleid != INVALID_VEHICLE_ID)
		{
			ApplyOwnableCarPlate(vehicleid, idx);
			SetVehicleParam(vehicleid, V_LOCK, false);

			SetVehicleData(vehicleid, V_MILEAGE, 0.0);
		}

		SetPlayerData(to_player, P_OWNABLE_CAR, vehicleid);
 
		format
		(
			query, sizeof query,
			"INSERT INTO ownable_cars \
			(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
			VALUES \
			('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
			GetPlayerAccountID(to_player),
			modelid,
			color_1,
			color_2,
			pos_x,
			pos_y,
			pos_z,
			angle,
			gettime()
		);
		result = mysql_query(mysql, query, true);
		SetOwnableCarData(idx, OC_SQL_ID, cache_insert_id());
		cache_delete(result);
}

CMD:roulette(playerid) 
{
    new query[94];
    mysql_format(mysql, query, sizeof query, "SELECT * FROM roulette_prize WHERE owner = %d", GetPlayerAccountID(playerid));
    new Cache:cache = mysql_query(mysql, query);

    if(!cache_num_rows()) return SendClientMessage(playerid, -1, "У вас нет призов с рулетки.");

    new rows, prize_id,id, list[52], dialog[sizeof list*10+54];

    strcat(dialog, "Следующая страница\nПредыдущая страница\n");

    rows = cache_num_rows();

    if(rows >= 10) rows = 10;

    for(new i,c=2;i < rows;i++,c++) 
    {
        prize_id = cache_get_field_content_int(i, "prize");
        id = cache_get_field_content_int(i, "id");

        format(list, sizeof list, "%d. %s\n", i+1, ruletka_prize[prize_id][R_NAME_PRIZE]);
        strcat(dialog, list);
        SetPlayerListitemValue(playerid, c, prize_id);
        format(list, sizeof list, "rouletteid_%d", c);
        SetPVarInt(playerid, list, id);
    }

    SetPVarInt(playerid, "count_list", 1);
    Dialog(playerid, 2832, DIALOG_STYLE_LIST, "{FF0000}Призы с рулетки", dialog, "Далее", "Выйти");
    return 1;
} 

public:LoadRuletka(playerid)
{
    new text[124];
    mysql_format(mysql, text, sizeof text, "SELECT roulette_bronz, roulette_online_minutes, roulette_online_day FROM accounts WHERE id=%d", GetPlayerAccountID(playerid));
    new Cache:cache = mysql_query(mysql, text, true);
    if(mysql_errno()) SendClientMessage(playerid, -1, "Ошибка в запросе.");

    player_roulette_bronz[playerid] = cache_get_row_int(0, 0);
    player_roulette_online_minutes[playerid] = cache_get_row_int(0, 1);
    player_roulette_online_day[playerid] = cache_get_row_int(0, 2);
    cache_delete(cache);
    return 1;
} 
 
 
//ы
 
 
 
 
 
 
 
 
 
 
 
 
 
stock LoadPrizeRuletka()
{//?????: https://t.me/welsistudio (Welsi Studio)
    for(new i;i <12;i++)
    {
        TextDrawSetString(welsirltk_TD[td_prize[i][0]], ruletka_prize[i][R_NAME_TXD]);
        TextDrawSetString(welsirltk_TD[td_prize[i][1]], ruletka_prize[i][R_NAME_TEXT]);
    }
    return 1;
}
CMD:openroulette_1(playerid)
{
	TogglePlayerControllable(playerid, false);
	HideHud(playerid);
	RuletkaPlayer_1(playerid);
    SelectTextDraw(playerid, -1);
	for(new i;i < 20;i++) SendClientMessage(playerid, -1, "");

	for(new t;t < sizeof welsirltk_TD_1;t++)
	{
		TextDrawShowForPlayer(playerid, welsirltk_TD_1[t]);
	}

	for(new t,welsi;t < 5;t++, welsi = random(12))
	{
		PlayerTextDrawSetString(playerid, ruletka_PTD_1[playerid][t], ruletka_prize_1[welsi][R_NAME_TXD_1]);
		PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][t], ruletka_prize_1[welsi][R_NAME_TEXT_1]);
		PlayerTextDrawShow(playerid, ruletka_PTD_1[playerid][t]);
		PlayerTextDrawShow(playerid, ruletka_PTD_t_1[playerid][t]);
		menu_prize_player_1[playerid][t] = welsi;
	}

    UpdateLastPlayerRuletka_1(playerid);

    for(new i; i < 3;i++)
    {
        PlayerTextDrawShow(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][0]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][1]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][2]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][3]]);
    }

    new string[10];
    format(string, sizeof string, "%d", player_roulette_bronz_1[playerid]);
    PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][17], string);

    PlayerTextDrawShow(playerid, ruletka_PTD_t_1[playerid][17]);
    return 1;
}
stock RuletkaMenu_1()
{
    welsirltk_TD_1[0] = TextDrawCreate(3.6665, 208.3332, "txd:brgiftsdownpanel"); // ?????
    TextDrawTextSize(welsirltk_TD_1[0], 624.0000, 209.0000);
    TextDrawAlignment(welsirltk_TD_1[0], 1);
    TextDrawColor(welsirltk_TD_1[0], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[0], 255);
    TextDrawFont(welsirltk_TD_1[0], 4);
    TextDrawSetProportional(welsirltk_TD_1[0], 0);
    TextDrawSetShadow(welsirltk_TD_1[0], 0);

    welsirltk_TD_1[1] = TextDrawCreate(47.2378, 11.6280, "txd:brgiftsbgspin"); // ?????
    TextDrawTextSize(welsirltk_TD_1[1], 530.0000, 49.0000);
    TextDrawAlignment(welsirltk_TD_1[1], 1);
    TextDrawColor(welsirltk_TD_1[1], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[1], 255);
    TextDrawFont(welsirltk_TD_1[1], 4);
    TextDrawSetProportional(welsirltk_TD_1[1], 0);
    TextDrawSetShadow(welsirltk_TD_1[1], 0);
    TextDrawSetSelectable(welsirltk_TD_1[1], true);

    welsirltk_TD_1[2] = TextDrawCreate(255.0950, 167.3733, "txd:brgiftsdostupno"); // ?????
    TextDrawTextSize(welsirltk_TD_1[2], 87.0000, 27.0000);
    TextDrawAlignment(welsirltk_TD_1[2], 1);
    TextDrawColor(welsirltk_TD_1[2], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[2], 255);
    TextDrawFont(welsirltk_TD_1[2], 4);
    TextDrawSetProportional(welsirltk_TD_1[2], 0);
    TextDrawSetShadow(welsirltk_TD_1[2], 0);

    welsirltk_TD_1[4] = TextDrawCreate(114.1427, 66.2651, "txd:brgiftsbuycase"); // ?????
    TextDrawTextSize(welsirltk_TD_1[4], 105.0000, 70.0000);
    TextDrawAlignment(welsirltk_TD_1[4], 1);
    TextDrawColor(welsirltk_TD_1[4], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[4], 255);
    TextDrawFont(welsirltk_TD_1[4], 4);
    TextDrawSetProportional(welsirltk_TD_1[4], 0);
    TextDrawSetShadow(welsirltk_TD_1[4], 0);
    TextDrawSetSelectable(welsirltk_TD_1[4], true);

    welsirltk_TD_1[5] = TextDrawCreate(553.9045, 366.4369, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[5], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[5], 1);
    TextDrawColor(welsirltk_TD_1[5], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[5], 255);
    TextDrawFont(welsirltk_TD_1[5], 4);
    TextDrawSetProportional(welsirltk_TD_1[5], 0);
    TextDrawSetShadow(welsirltk_TD_1[5], 0);

    welsirltk_TD_1[6] = TextDrawCreate(586.6188, 399.6828, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[6], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[6], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[6], 2);
    TextDrawColor(welsirltk_TD_1[6], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[6], 255);
    TextDrawFont(welsirltk_TD_1[6], 1);
    TextDrawSetProportional(welsirltk_TD_1[6], 1);
    TextDrawSetShadow(welsirltk_TD_1[6], 0);

    welsirltk_TD_1[7] = TextDrawCreate(196.6666, 288.5704, "txd:brgiftsilvertext"); // ?????
    TextDrawTextSize(welsirltk_TD_1[7], 171.0000, 202.0000);
    TextDrawAlignment(welsirltk_TD_1[7], 1);
    TextDrawColor(welsirltk_TD_1[7], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[7], 255);
    TextDrawFont(welsirltk_TD_1[7], 4);
    TextDrawSetProportional(welsirltk_TD_1[7], 0);
    TextDrawSetShadow(welsirltk_TD_1[7], 0);

    welsirltk_TD_1[8] = TextDrawCreate(239.3332, 219.0370, "СЕРЕБРЯНЫЙ"); // ?????
    TextDrawLetterSize(welsirltk_TD_1[8], 0.3193, 1.7368);
    TextDrawTextSize(welsirltk_TD_1[8], -6.0000, 0.0000);
    TextDrawAlignment(welsirltk_TD_1[8], 1);
    TextDrawColor(welsirltk_TD_1[8], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[8], 255);
    TextDrawFont(welsirltk_TD_1[8], 2);
    TextDrawSetProportional(welsirltk_TD_1[8], 1);
    TextDrawSetShadow(welsirltk_TD_1[8], 0);

    welsirltk_TD_1[9] = TextDrawCreate(399.5713, 366.8517, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[9], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[9], 1);
    TextDrawColor(welsirltk_TD_1[9], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[9], 255);
    TextDrawFont(welsirltk_TD_1[9], 4);
    TextDrawSetProportional(welsirltk_TD_1[9], 0);
    TextDrawSetShadow(welsirltk_TD_1[9], 0);

    welsirltk_TD_1[10] = TextDrawCreate(433.2857, 400.5124, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[10], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[10], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[10], 2);
    TextDrawColor(welsirltk_TD_1[10], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[10], 255);
    TextDrawFont(welsirltk_TD_1[10], 1);
    TextDrawSetProportional(welsirltk_TD_1[10], 1);
    TextDrawSetShadow(welsirltk_TD_1[10], 0);

    welsirltk_TD_1[11] = TextDrawCreate(476.2379, 366.4370, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[11], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[11], 1);
    TextDrawColor(welsirltk_TD_1[11], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[11], 255);
    TextDrawFont(welsirltk_TD_1[11], 4);
    TextDrawSetProportional(welsirltk_TD_1[11], 0);
    TextDrawSetShadow(welsirltk_TD_1[11], 0);

    welsirltk_TD_1[12] = TextDrawCreate(509.6188, 400.5125, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[12], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[12], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[12], 2);
    TextDrawColor(welsirltk_TD_1[12], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[12], 255);
    TextDrawFont(welsirltk_TD_1[12], 1);
    TextDrawSetProportional(welsirltk_TD_1[12], 1);
    TextDrawSetShadow(welsirltk_TD_1[12], 0);

    welsirltk_TD_1[13] = TextDrawCreate(551.9046, 213.7850, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[13], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[13], 1);
    TextDrawColor(welsirltk_TD_1[13], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[13], 255);
    TextDrawFont(welsirltk_TD_1[13], 4);
    TextDrawSetProportional(welsirltk_TD_1[13], 0);
    TextDrawSetShadow(welsirltk_TD_1[13], 0);

    welsirltk_TD_1[14] = TextDrawCreate(585.9521, 247.4457, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[14], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[14], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[14], 2);
    TextDrawColor(welsirltk_TD_1[14], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[14], 255);
    TextDrawFont(welsirltk_TD_1[14], 1);
    TextDrawSetProportional(welsirltk_TD_1[14], 1);
    TextDrawSetShadow(welsirltk_TD_1[14], 0);

    welsirltk_TD_1[15] = TextDrawCreate(399.2380, 214.1998, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[15], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[15], 1);
    TextDrawColor(welsirltk_TD_1[15], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[15], 255);
    TextDrawFont(welsirltk_TD_1[15], 4);
    TextDrawSetProportional(welsirltk_TD_1[15], 0);
    TextDrawSetShadow(welsirltk_TD_1[15], 0);

    welsirltk_TD_1[16] = TextDrawCreate(432.9524, 247.8605, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[16], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[16], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[16], 2);
    TextDrawColor(welsirltk_TD_1[16], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[16], 255);
    TextDrawFont(welsirltk_TD_1[16], 1);
    TextDrawSetProportional(welsirltk_TD_1[16], 1);
    TextDrawSetShadow(welsirltk_TD_1[16], 0);

    welsirltk_TD_1[17] = TextDrawCreate(475.9046, 213.7850, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[17], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[17], 1);
    TextDrawColor(welsirltk_TD_1[17], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[17], 255);
    TextDrawFont(welsirltk_TD_1[17], 4);
    TextDrawSetProportional(welsirltk_TD_1[17], 0);
    TextDrawSetShadow(welsirltk_TD_1[17], 0);

    welsirltk_TD_1[18] = TextDrawCreate(509.2855, 247.8606, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[18], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[18], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[18], 2);
    TextDrawColor(welsirltk_TD_1[18], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[18], 255);
    TextDrawFont(welsirltk_TD_1[18], 1);
    TextDrawSetProportional(welsirltk_TD_1[18], 1);
    TextDrawSetShadow(welsirltk_TD_1[18], 0);

    welsirltk_TD_1[19] = TextDrawCreate(551.5712, 264.8072, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[19], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[19], 1);
    TextDrawColor(welsirltk_TD_1[19], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[19], 255);
    TextDrawFont(welsirltk_TD_1[19], 4);
    TextDrawSetProportional(welsirltk_TD_1[19], 0);
    TextDrawSetShadow(welsirltk_TD_1[19], 0);

    welsirltk_TD_1[20] = TextDrawCreate(585.6187, 298.4679, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[20], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[20], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[20], 2);
    TextDrawColor(welsirltk_TD_1[20], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[20], 255);
    TextDrawFont(welsirltk_TD_1[20], 1);
    TextDrawSetProportional(welsirltk_TD_1[20], 1);
    TextDrawSetShadow(welsirltk_TD_1[20], 0);

    welsirltk_TD_1[21] = TextDrawCreate(398.9046, 265.2220, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[21], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[21], 1);
    TextDrawColor(welsirltk_TD_1[21], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[21], 255);
    TextDrawFont(welsirltk_TD_1[21], 4);
    TextDrawSetProportional(welsirltk_TD_1[21], 0);
    TextDrawSetShadow(welsirltk_TD_1[21], 0);

    welsirltk_TD_1[22] = TextDrawCreate(432.6191, 298.8827, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[22], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[22], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[22], 2);
    TextDrawColor(welsirltk_TD_1[22], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[22], 255);
    TextDrawFont(welsirltk_TD_1[22], 1);
    TextDrawSetProportional(welsirltk_TD_1[22], 1);
    TextDrawSetShadow(welsirltk_TD_1[22], 0);

    welsirltk_TD_1[23] = TextDrawCreate(475.5713, 264.8073, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[23], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[23], 1);
    TextDrawColor(welsirltk_TD_1[23], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[23], 255);
    TextDrawFont(welsirltk_TD_1[23], 4);
    TextDrawSetProportional(welsirltk_TD_1[23], 0);
    TextDrawSetShadow(welsirltk_TD_1[23], 0);

    welsirltk_TD_1[24] = TextDrawCreate(508.9522, 298.8828, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[24], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[24], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[24], 2);
    TextDrawColor(welsirltk_TD_1[24], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[24], 255);
    TextDrawFont(welsirltk_TD_1[24], 1);
    TextDrawSetProportional(welsirltk_TD_1[24], 1);
    TextDrawSetShadow(welsirltk_TD_1[24], 0);

    welsirltk_TD_1[25] = TextDrawCreate(552.2379, 315.4146, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[25], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[25], 1);
    TextDrawColor(welsirltk_TD_1[25], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[25], 255);
    TextDrawFont(welsirltk_TD_1[25], 4);
    TextDrawSetProportional(welsirltk_TD_1[25], 0);
    TextDrawSetShadow(welsirltk_TD_1[25], 0);

    welsirltk_TD_1[26] = TextDrawCreate(586.2855, 349.0754, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[26], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[26], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[26], 2);
    TextDrawColor(welsirltk_TD_1[26], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[26], 255);
    TextDrawFont(welsirltk_TD_1[26], 1);
    TextDrawSetProportional(welsirltk_TD_1[26], 1);
    TextDrawSetShadow(welsirltk_TD_1[26], 0);

    welsirltk_TD_1[27] = TextDrawCreate(399.5713, 315.8294, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[27], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[27], 1);
    TextDrawColor(welsirltk_TD_1[27], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[27], 255);
    TextDrawFont(welsirltk_TD_1[27], 4);
    TextDrawSetProportional(welsirltk_TD_1[27], 0);
    TextDrawSetShadow(welsirltk_TD_1[27], 0);

    welsirltk_TD_1[28] = TextDrawCreate(433.2857, 349.4902, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[28], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[28], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[28], 2);
    TextDrawColor(welsirltk_TD_1[28], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[28], 255);
    TextDrawFont(welsirltk_TD_1[28], 1);
    TextDrawSetProportional(welsirltk_TD_1[28], 1);
    TextDrawSetShadow(welsirltk_TD_1[28], 0);

    welsirltk_TD_1[29] = TextDrawCreate(476.2379, 315.4147, "txd:brgiftscash"); // ?????
    TextDrawTextSize(welsirltk_TD_1[29], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_1[29], 1);
    TextDrawColor(welsirltk_TD_1[29], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[29], 255);
    TextDrawFont(welsirltk_TD_1[29], 4);
    TextDrawSetProportional(welsirltk_TD_1[29], 0);
    TextDrawSetShadow(welsirltk_TD_1[29], 0);

    welsirltk_TD_1[30] = TextDrawCreate(509.6188, 349.4902, "?o_100000_p."); // ?????
    TextDrawLetterSize(welsirltk_TD_1[30], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_1[30], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_1[30], 2);
    TextDrawColor(welsirltk_TD_1[30], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[30], 255);
    TextDrawFont(welsirltk_TD_1[30], 1);
    TextDrawSetProportional(welsirltk_TD_1[30], 1);
    TextDrawSetShadow(welsirltk_TD_1[30], 0);

    welsirltk_TD_1[31] = TextDrawCreate(27.5713, 143.9302, "txd:brgiftsupdate"); // ?????
    TextDrawTextSize(welsirltk_TD_1[31], 126.0000, 74.0000);
    TextDrawAlignment(welsirltk_TD_1[31], 1);
    TextDrawColor(welsirltk_TD_1[31], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[31], 255);
    TextDrawFont(welsirltk_TD_1[31], 4);
    TextDrawSetProportional(welsirltk_TD_1[31], 0);
    TextDrawSetShadow(welsirltk_TD_1[31], 0);
    TextDrawSetSelectable(welsirltk_TD_1[31], true);

    welsirltk_TD_1[32] = TextDrawCreate(528.2379, 159.6932, "ruletka:brgiftsexit"); // ?????
    TextDrawTextSize(welsirltk_TD_1[32], 91.0000, 56.0000);
    TextDrawAlignment(welsirltk_TD_1[32], 1);
    TextDrawColor(welsirltk_TD_1[32], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[32], 255);
    TextDrawFont(welsirltk_TD_1[32], 4);
    TextDrawSetProportional(welsirltk_TD_1[32], 0);
    TextDrawSetShadow(welsirltk_TD_1[32], 0);
    TextDrawSetSelectable(welsirltk_TD_1[32], true);

    welsirltk_TD_1[33] = TextDrawCreate(259.6665, 68.3864, "ruletka:brgiftsspin"); // ?????
    TextDrawTextSize(welsirltk_TD_1[33], 110.0000, 66.0000);
    TextDrawAlignment(welsirltk_TD_1[33], 1);
    TextDrawColor(welsirltk_TD_1[33], -1);
    TextDrawBackgroundColor(welsirltk_TD_1[33], 255);
    TextDrawFont(welsirltk_TD_1[33], 4);
    TextDrawSetProportional(welsirltk_TD_1[33], 0);
    TextDrawSetShadow(welsirltk_TD_1[33], 0);
    TextDrawSetSelectable(welsirltk_TD_1[33], true);

    welsirltk_TD_1[34] = TextDrawCreate(580.9998, 2.0888, ""); // ?????
    TextDrawLetterSize(welsirltk_TD_1[34], 0.1480, 0.8740);
    TextDrawTextSize(welsirltk_TD_1[34], -101.0000, 0.0000);
    TextDrawAlignment(welsirltk_TD_1[34], 1);
    TextDrawColor(welsirltk_TD_1[34], -81);
    TextDrawBackgroundColor(welsirltk_TD_1[34], 255);
    TextDrawFont(welsirltk_TD_1[34], 1);
    TextDrawSetProportional(welsirltk_TD_1[34], 1);
    TextDrawSetShadow(welsirltk_TD_1[34], 0);
}
stock RuletkaPlayer_1(playerid)
{
    ruletka_PTD_1[playerid][0] = CreatePlayerTextDraw(playerid, 430.2377, 13.7539, "txd:brgiftslic");
    PlayerTextDrawTextSize(playerid, ruletka_PTD_1[playerid][0], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_1[playerid][0], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_1[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_1[playerid][0], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_1[playerid][0], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_1[playerid][0], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_1[playerid][0], 0);

    ruletka_PTD_1[playerid][1] = CreatePlayerTextDraw(playerid, 352.6664, 13.7340, "txd:brgiftsuncar");
    PlayerTextDrawTextSize(playerid, ruletka_PTD_1[playerid][1], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_1[playerid][1], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_1[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_1[playerid][1], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_1[playerid][1], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_1[playerid][1], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_1[playerid][1], 0);

    ruletka_PTD_1[playerid][2] = CreatePlayerTextDraw(playerid, 276.3807, 14.9784, "txd:brgiftsgvip");
    PlayerTextDrawTextSize(playerid, ruletka_PTD_1[playerid][2], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_1[playerid][2], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_1[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_1[playerid][2], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_1[playerid][2], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_1[playerid][2], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_1[playerid][2], 0);

    ruletka_PTD_1[playerid][3] = CreatePlayerTextDraw(playerid, 200.4284, 15.0650, "txd:brgiftsgun");
    PlayerTextDrawTextSize(playerid, ruletka_PTD_1[playerid][3], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_1[playerid][3], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_1[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_1[playerid][3], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_1[playerid][3], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_1[playerid][3], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_1[playerid][3], 0);

    ruletka_PTD_1[playerid][4] = CreatePlayerTextDraw(playerid, 123.9045, 14.6739, "txd:brgiftscash");
    PlayerTextDrawTextSize(playerid, ruletka_PTD_1[playerid][4], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_1[playerid][4], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_1[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_1[playerid][4], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_1[playerid][4], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_1[playerid][4], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_1[playerid][4], 0);

    ruletka_PTD_t_1[playerid][0] = CreatePlayerTextDraw(playerid, 466.8570, 45.8340, "????? ? ??????????");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][0], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][0], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][0], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][0], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][0], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][0], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][0], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][0], 0);

    ruletka_PTD_t_1[playerid][1] = CreatePlayerTextDraw(playerid, 389.3807, 44.9925, "BMW_M5_F90");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][1], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][1], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][1], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][1], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][1], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][1], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][1], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][1], 0);

    ruletka_PTD_t_1[playerid][2] = CreatePlayerTextDraw(playerid, 311.8570, 46.6399, "Gold-Vip");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][2], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][2], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][2], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][2], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][2], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][2], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][2], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][2], 0);

    ruletka_PTD_t_1[playerid][3] = CreatePlayerTextDraw(playerid, 235.2379, 47.0784, "????????? ??????");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][3], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][3], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][3], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][3], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][3], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][3], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][3], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][3], 0);

    ruletka_PTD_t_1[playerid][4] = CreatePlayerTextDraw(playerid, 157.2856, 48.3346, "?? 100000 ?.");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][4], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][4], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][4], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][4], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][4], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][4], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][4], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][4], 0);

    ruletka_PTD_t_1[playerid][5] = CreatePlayerTextDraw(playerid, 11.6664, 358.4451, "txd:brgiftsuncar");
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][5], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][5], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][5], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][5], 0);

    ruletka_PTD_t_1[playerid][6] = CreatePlayerTextDraw(playerid, 99.6666, 361.7334, "Welsi_Developer");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][6], 0.2506, 1.2391);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][6], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][6], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][6], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][6], 0);

    ruletka_PTD_t_1[playerid][7] = CreatePlayerTextDraw(playerid, 47.7141, 388.8739, "BMW_M5_F90");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][7], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][7], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][7], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][7], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][7], 0);

    ruletka_PTD_t_1[playerid][8] = CreatePlayerTextDraw(playerid, 86.9999, 376.6668, "?POHЂO‹‘† KE†C");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][8], 0.1793, 1.0897);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][8], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][8], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][8], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][8], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][8], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][8], 0);

    ruletka_PTD_t_1[playerid][9] = CreatePlayerTextDraw(playerid, 10.9998, 305.7636, "txd:brgiftsuncar");
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][9], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][9], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][9], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][9], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][9], 0);

    ruletka_PTD_t_1[playerid][10] = CreatePlayerTextDraw(playerid, 47.3807, 336.1924, "BMW_M5_F90");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][10], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][10], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][10], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][10], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][10], 0);

    ruletka_PTD_t_1[playerid][11] = CreatePlayerTextDraw(playerid, 99.6666, 308.2222, "Welsi_Developer");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][11], 0.2526, 1.2640);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][11], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][11], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][11], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][11], 0);

    ruletka_PTD_t_1[playerid][12] = CreatePlayerTextDraw(playerid, 86.9999, 323.1556, "?POHЂO‹‘† KE†C");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][12], 0.1813, 1.1146);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][12], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][12], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][12], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][12], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][12], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][12], 0);

    ruletka_PTD_t_1[playerid][13] = CreatePlayerTextDraw(playerid, 11.3331, 253.0822, "txd:brgiftsuncar");
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][13], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][13], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][13], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][13], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][13], 0);

    ruletka_PTD_t_1[playerid][14] = CreatePlayerTextDraw(playerid, 47.7141, 283.5110, "BMW_M5_F90");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][14], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][14], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][14], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][14], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][14], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][14], 0);

    ruletka_PTD_t_1[playerid][15] = CreatePlayerTextDraw(playerid, 99.6666, 256.3703, "Welsi_Developer");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][15], 0.2526, 1.2640);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][15], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][15], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][15], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][15], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][15], 0);

    ruletka_PTD_t_1[playerid][16] = CreatePlayerTextDraw(playerid, 86.9999, 271.3037, "?POHЂO‹‘† KE†C");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][16], 0.1813, 1.1146);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_1[playerid][16], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][16], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][16], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][16], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][16], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][16], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][16], 0);

    ruletka_PTD_t_1[playerid][17] = CreatePlayerTextDraw(playerid, 317.3334, 173.8222, "4");
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_1[playerid][17], 0.2939, 1.3386);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_1[playerid][17], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_1[playerid][17], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_1[playerid][17], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_1[playerid][17], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_1[playerid][17], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_1[playerid][17], 0);
}
new td_prize_1[12][2] =
{
    {5,6},
    {9,10},
    {11,12},
    {13,14},
    {15,16},
    {17,18},
    {19,20},
    {21,22},
    {23,24},
    {25,26},
    {27,28},
    {29,30}
};

stock LoadPrizeRuletka_1()
{
    for(new i;i <12;i++)
    {
        TextDrawSetString(welsirltk_TD_1[td_prize_1[i][0]], ruletka_prize_1[i][R_NAME_TXD_1]);
        TextDrawSetString(welsirltk_TD_1[td_prize_1[i][1]], ruletka_prize_1[i][R_NAME_TEXT_1]);
    }
    return 1;
}
public RunRuletka_1(playerid)
{
    animation_player_1[playerid] = true;

    if(ruletka_count_1[playerid])
    {
        new text[135];

        if(ruletka_count_1[playerid] == 15)
        {
            format(text, sizeof text, "Поздравляем! Вам выпал %s{FFFF00}.{FFFFFF} Чтобы забрать приз {FFFF00}/roulette", ruletka_prize_1[menu_prize_player_1[playerid][2]][R_NAME_PRIZE_1]);
            SendClientMessage(playerid, -1, text);
            GivePrizeRoulette_1(playerid, menu_prize_player_1[playerid][2]);

            animation_player_1[playerid] = false;
            KillTimer(timer_player_ruletka_1[playerid]);
            timer_player_ruletka_1[playerid] = -1;
            ruletka_count_1[playerid]=0;

            format(last_player_ruletka_1[0][last_player_name_1], 24, last_player_ruletka_1[1][last_player_name_1]);
            last_player_ruletka_1[0][id_ruletka_prize_1] = last_player_ruletka_1[1][id_ruletka_prize_1];
            format(last_player_ruletka_1[1][last_player_name_1], 24, last_player_ruletka_1[2][last_player_name_1]);
            last_player_ruletka_1[1][id_ruletka_prize_1] = last_player_ruletka_1[2][id_ruletka_prize_1];
            format(last_player_ruletka_1[2][last_player_name_1], 24, GetPlayerNameEx(playerid));
            last_player_ruletka_1[2][id_ruletka_prize_1] = menu_prize_player_1[playerid][2];

            return 1;
        }
        else
        {
            ruletka_count_1[playerid]++;

            new o = 5;
            while(o > 1)
            {
                o--;
                PlayerTextDrawSetString(playerid, ruletka_PTD_1[playerid][o], ruletka_prize_1[menu_prize_player_1[playerid][o-1]][R_NAME_TXD_1]);
                PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][o], ruletka_prize_1[menu_prize_player_1[playerid][o-1]][R_NAME_TEXT_1]);
                menu_prize_player_1[playerid][o] = menu_prize_player_1[playerid][o-1];
            }

            new array[] = {2,2,8,8,8,8,8,8,8,8,16,18};
            menu_prize_player_1[playerid][0] = random2_1(array);
            PlayerTextDrawSetString(playerid, ruletka_PTD_1[playerid][0], ruletka_prize_1[menu_prize_player_1[playerid][0]][R_NAME_TXD_1]);
            PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][0], ruletka_prize_1[menu_prize_player_1[playerid][0]][R_NAME_TEXT_1]);
        }
    }
    else
    {
        ruletka_count_1[playerid]=1;
    }
    return 1;
}

stock UpdateLastPlayerRuletka_1(playerid)
{
    for(new i; i < 3;i++)
    {
        PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][0]], last_player_ruletka_1[i][last_player_name_1]);
        PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][1]], ruletka_prize_1[last_player_ruletka_1[i][id_ruletka_prize_1]][R_NAME_TXD_1]);
        PlayerTextDrawSetString(playerid, ruletka_PTD_t_1[playerid][last_player_td_1[i][2]], ruletka_prize_1[last_player_ruletka_1[i][id_ruletka_prize_1]][R_NAME_TEXT_1]);
    }
    return 1;
}

random2_1(array[], size_w = sizeof(array))
{
    if(size_w < 1) return -1;
    new sum = 0, result = 0;

    for(new i = size_w - 1; i > -1; i--)
    {
        sum += array[i];
        if(random(sum) < array[i])
        {
            result = i;
        }
    }
    return result;
}

stock GivePrizeRoulette_1(playerid, prize_id)
{
    new query[94];
    mysql_format(mysql, query, sizeof query, "INSERT INTO roulette_prize (owner, prize) VALUES (%d,%d)", GetPlayerAccountID(playerid), prize_id);
    mysql_query(mysql, query, false);

    if(mysql_errno()) SendClientMessage(playerid, -1, "Ошибка в запросе.");
    return 1;
}

public CreateTablistRoulette_1()
{
    new Cache:cache = mysql_query(mysql, "SELECT * FROM roulette_prize", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "CREATE TABLE .`roulette_prize` ( `id` INT NOT NULL AUTO_INCREMENT , `owner` INT NOT NULL , `prize` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB", false);

        if(mysql_errno()) printf("%d error create tablist roulette_prize", mysql_errno());
    }

    cache_delete(cache);

    cache = mysql_query(mysql, "SELECT * FROM accounts WHERE roulette_silver", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `roulette_silver` INT NOT NULL DEFAULT '0' AFTER `money`", false);

        if(mysql_errno()) printf("%d error alter roulette_silver", mysql_errno());
    }

    cache_delete(cache);
    return 1;
}

stock GivePlayerCarRoulette_1(playerid, modelid, color_1, color_2)
{
    new to_player = playerid;
    new Float:POS[3];
    GetPlayerPos(to_player, POS[0],POS[1],POS[2]);
    new Float: pos_x = POS[0];
    new Float: pos_y = POS[1];
    new Float: pos_z = POS[2];
    new Float: angle = 356.7986;
    new query[220],
        Cache: result,
        idx;

    idx = GetFreeOwnableCarID();
    SetOwnableCarData(idx, OC_OWNER_ID,    GetPlayerAccountID(to_player));
    SetOwnableCarData(idx, OC_MODEL_ID,    modelid);
    SetOwnableCarData(idx, OC_COLOR_1,        color_1);
    SetOwnableCarData(idx, OC_COLOR_2,        color_2);
    SetOwnableCarData(idx, OC_POS_X,        pos_x);
    SetOwnableCarData(idx, OC_POS_Y,        pos_y);
    SetOwnableCarData(idx, OC_POS_Z,        pos_z);
    SetOwnableCarData(idx, OC_ANGLE,        angle);
    strmid(g_ownable_car[idx][OC_NUMBER], "--------", 0, 8, 8);
    SetOwnableCarData(idx, OC_ALARM,        false);
    SetOwnableCarData(idx, OC_KEY_IN,        true);
    SetOwnableCarData(idx, OC_CREATE,        gettime());
    format(g_ownable_car[idx][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));

    new vehicleid = CreateVehicle
    (
        GetOwnableCarData(idx, OC_MODEL_ID),
        GetOwnableCarData(idx, OC_POS_X),
        GetOwnableCarData(idx, OC_POS_Y),
        GetOwnableCarData(idx, OC_POS_Z),
        GetOwnableCarData(idx, OC_ANGLE),
        GetOwnableCarData(idx, OC_COLOR_1),
        GetOwnableCarData(idx, OC_COLOR_2),
        -1,
        0,
        VEHICLE_ACTION_TYPE_OWNABLE_CAR,
        idx
    );

    if(vehicleid != INVALID_VEHICLE_ID)
    {
        ApplyOwnableCarPlate(vehicleid, idx);
        SetVehicleParam(vehicleid, V_LOCK, false);
        SetVehicleData(vehicleid, V_MILEAGE, 0.0);
    }

    SetPlayerData(to_player, P_OWNABLE_CAR, vehicleid);

    format
    (
        query, sizeof query,
        "INSERT INTO ownable_cars \
        (owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
        VALUES \
        ('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
        GetPlayerAccountID(to_player),
        modelid,
        color_1,
        color_2,
        pos_x,
        pos_y,
        pos_z,
        angle,
        gettime()
    );
    result = mysql_query(mysql, query, true);
    SetOwnableCarData(idx, OC_SQL_ID, cache_insert_id());
    cache_delete(result);
}

CMD:roulette_1(playerid)
{
    new query[94];
    mysql_format(mysql, query, sizeof query, "SELECT * FROM roulette_prize WHERE owner = %d", GetPlayerAccountID(playerid));
    new Cache:cache = mysql_query(mysql, query);

    if(!cache_num_rows()) return SendClientMessage(playerid, -1, "У вас нет призов с рулетки.");

    new rows, prize_id,id, list[52], dialog[sizeof list*10+54];

    strcat(dialog, "Следующая страница\nПредыдущая страница\n");

    rows = cache_num_rows();

    if(rows >= 10) rows = 10;

    for(new i,c=2;i < rows;i++,c++)
    {
        prize_id = cache_get_field_content_int(i, "prize");
        id = cache_get_field_content_int(i, "id");

        format(list, sizeof list, "%d. %s\n", i+1, ruletka_prize_1[prize_id][R_NAME_PRIZE_1]);
        strcat(dialog, list);
        SetPlayerListitemValue(playerid, c, prize_id);
        format(list, sizeof list, "rouletteid_%d", c);
        SetPVarInt(playerid, list, id);
    }

    SetPVarInt(playerid, "count_list", 1);
    Dialog(playerid, 28132, DIALOG_STYLE_LIST, "{FF0000}Призы с рулетки", dialog, "Далее", "Выйти");
    return 1;
}

public LoadRuletka_1(playerid)
{
    new text[124];
    mysql_format(mysql, text, sizeof text, "SELECT roulette_silver FROM accounts WHERE id=%d", GetPlayerAccountID(playerid));
    new Cache:cache = mysql_query(mysql, text, true);
    if(mysql_errno()) SendClientMessage(playerid, -1, "Ошибка в запросе.");

    player_roulette_bronz_1[playerid] = cache_get_row_int(0, 0);
    cache_delete(cache);
    return 1;
}
CMD:openroulette_2(playerid)
{
	TogglePlayerControllable(playerid, false);
	HideHud(playerid);
	RuletkaPlayer_2(playerid);
    SelectTextDraw(playerid, -1);
	for(new i_2;i_2 < 20;i_2++) SendClientMessage(playerid, -1, "");

	for(new t_2;t_2 < sizeof welsirltk_TD_2;t_2++)
	{
		TextDrawShowForPlayer(playerid, welsirltk_TD_2[t_2]);
	}

	for(new t_2,welsi_2;t_2 < 5;t_2++, welsi_2 = random(12))
	{
		PlayerTextDrawSetString(playerid, ruletka_PTD_2[playerid][t_2], ruletka_prize_2[welsi_2][R_NAME_TXD_2]);
		PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][t_2], ruletka_prize_2[welsi_2][R_NAME_TEXT_2]);
		PlayerTextDrawShow(playerid, ruletka_PTD_2[playerid][t_2]);
		PlayerTextDrawShow(playerid, ruletka_PTD_t_2[playerid][t_2]);
		menu_prize_player_2[playerid][t_2] = welsi_2;
	}

    UpdateLastPlayerRuletka_2(playerid);

    for(new i_2; i_2 < 3;i_2++)
    {
        PlayerTextDrawShow(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][0]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][1]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][2]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][3]]);
    }

    new string_2[10];
    format(string_2, sizeof string_2, "%d", player_roulette_bronz_2[playerid]);
    PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][17], string_2);

    PlayerTextDrawShow(playerid, ruletka_PTD_t_2[playerid][17]);
    return 1;
}
stock RuletkaMenu_2()
{
    welsirltk_TD_2[0] = TextDrawCreate(3.6665, 208.3332, "txd:brgiftsdownpanel"); // пусто
    TextDrawTextSize(welsirltk_TD_2[0], 624.0000, 209.0000);
    TextDrawAlignment(welsirltk_TD_2[0], 1);
    TextDrawColor(welsirltk_TD_2[0], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[0], 255);
    TextDrawFont(welsirltk_TD_2[0], 4);
    TextDrawSetProportional(welsirltk_TD_2[0], 0);
    TextDrawSetShadow(welsirltk_TD_2[0], 0);

    welsirltk_TD_2[1] = TextDrawCreate(47.2378, 11.6280, "txd:brgiftsbgspin"); // пусто
    TextDrawTextSize(welsirltk_TD_2[1], 530.0000, 49.0000);
    TextDrawAlignment(welsirltk_TD_2[1], 1);
    TextDrawColor(welsirltk_TD_2[1], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[1], 255);
    TextDrawFont(welsirltk_TD_2[1], 4);
    TextDrawSetProportional(welsirltk_TD_2[1], 0);
    TextDrawSetShadow(welsirltk_TD_2[1], 0);
    TextDrawSetSelectable(welsirltk_TD_2[1], true);

    welsirltk_TD_2[2] = TextDrawCreate(255.0950, 167.3733, "txd:brgiftsdostupno"); // пусто
    TextDrawTextSize(welsirltk_TD_2[2], 87.0000, 27.0000);
    TextDrawAlignment(welsirltk_TD_2[2], 1);
    TextDrawColor(welsirltk_TD_2[2], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[2], 255);
    TextDrawFont(welsirltk_TD_2[2], 4);
    TextDrawSetProportional(welsirltk_TD_2[2], 0);
    TextDrawSetShadow(welsirltk_TD_2[2], 0);

    welsirltk_TD_2[4] = TextDrawCreate(114.1427, 66.2651, "txd:brgiftsbuycase"); // пусто
    TextDrawTextSize(welsirltk_TD_2[4], 105.0000, 70.0000);
    TextDrawAlignment(welsirltk_TD_2[4], 1);
    TextDrawColor(welsirltk_TD_2[4], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[4], 255);
    TextDrawFont(welsirltk_TD_2[4], 4);
    TextDrawSetProportional(welsirltk_TD_2[4], 0);
    TextDrawSetShadow(welsirltk_TD_2[4], 0);
    TextDrawSetSelectable(welsirltk_TD_2[4], true);

    welsirltk_TD_2[5] = TextDrawCreate(553.9045, 366.4369, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[5], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[5], 1);
    TextDrawColor(welsirltk_TD_2[5], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[5], 255);
    TextDrawFont(welsirltk_TD_2[5], 4);
    TextDrawSetProportional(welsirltk_TD_2[5], 0);
    TextDrawSetShadow(welsirltk_TD_2[5], 0);

    welsirltk_TD_2[6] = TextDrawCreate(586.6188, 399.6828, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[6], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[6], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[6], 2);
    TextDrawColor(welsirltk_TD_2[6], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[6], 255);
    TextDrawFont(welsirltk_TD_2[6], 1);
    TextDrawSetProportional(welsirltk_TD_2[6], 1);
    TextDrawSetShadow(welsirltk_TD_2[6], 0);

    welsirltk_TD_2[7] = TextDrawCreate(196.6666, 288.5704, "txd:brgiftbronzatext"); // пусто
    TextDrawTextSize(welsirltk_TD_2[7], 171.0000, 202.0000);
    TextDrawAlignment(welsirltk_TD_2[7], 1);
    TextDrawColor(welsirltk_TD_2[7], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[7], 255);
    TextDrawFont(welsirltk_TD_2[7], 4);
    TextDrawSetProportional(welsirltk_TD_2[7], 0);
    TextDrawSetShadow(welsirltk_TD_2[7], 0);

    welsirltk_TD_2[8] = TextDrawCreate(239.3332, 219.0370, "ЗОЛОТОЙ"); // пусто
    TextDrawLetterSize(welsirltk_TD_2[8], 0.3193, 1.7368);
    TextDrawTextSize(welsirltk_TD_2[8], -6.0000, 0.0000);
    TextDrawAlignment(welsirltk_TD_2[8], 1);
    TextDrawColor(welsirltk_TD_2[8], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[8], 255);
    TextDrawFont(welsirltk_TD_2[8], 2);
    TextDrawSetProportional(welsirltk_TD_2[8], 1);
    TextDrawSetShadow(welsirltk_TD_2[8], 0);

    welsirltk_TD_2[9] = TextDrawCreate(399.5713, 366.8517, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[9], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[9], 1);
    TextDrawColor(welsirltk_TD_2[9], -1); 
    TextDrawBackgroundColor(welsirltk_TD_2[9], 255);
    TextDrawFont(welsirltk_TD_2[9], 4);
    TextDrawSetProportional(welsirltk_TD_2[9], 0);
    TextDrawSetShadow(welsirltk_TD_2[9], 0);

    welsirltk_TD_2[10] = TextDrawCreate(433.2857, 400.5124, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[10], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[10], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[10], 2);
    TextDrawColor(welsirltk_TD_2[10], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[10], 255);
    TextDrawFont(welsirltk_TD_2[10], 1);
    TextDrawSetProportional(welsirltk_TD_2[10], 1);
    TextDrawSetShadow(welsirltk_TD_2[10], 0);

    welsirltk_TD_2[11] = TextDrawCreate(476.2379, 366.4370, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[11], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[11], 1);
    TextDrawColor(welsirltk_TD_2[11], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[11], 255);
    TextDrawFont(welsirltk_TD_2[11], 4);
    TextDrawSetProportional(welsirltk_TD_2[11], 0);
    TextDrawSetShadow(welsirltk_TD_2[11], 0);
 
    welsirltk_TD_2[12] = TextDrawCreate(509.6188, 400.5125, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[12], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[12], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[12], 2);
    TextDrawColor(welsirltk_TD_2[12], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[12], 255);
    TextDrawFont(welsirltk_TD_2[12], 1);
    TextDrawSetProportional(welsirltk_TD_2[12], 1);
    TextDrawSetShadow(welsirltk_TD_2[12], 0);

    welsirltk_TD_2[13] = TextDrawCreate(551.9046, 213.7850, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[13], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[13], 1); 
    TextDrawColor(welsirltk_TD_2[13], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[13], 255);
    TextDrawFont(welsirltk_TD_2[13], 4);
    TextDrawSetProportional(welsirltk_TD_2[13], 0);
    TextDrawSetShadow(welsirltk_TD_2[13], 0);

    welsirltk_TD_2[14] = TextDrawCreate(585.9521, 247.4457, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[14], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[14], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[14], 2);
    TextDrawColor(welsirltk_TD_2[14], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[14], 255);
    TextDrawFont(welsirltk_TD_2[14], 1);
    TextDrawSetProportional(welsirltk_TD_2[14], 1);
    TextDrawSetShadow(welsirltk_TD_2[14], 0);

    welsirltk_TD_2[15] = TextDrawCreate(399.2380, 214.1998, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[15], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[15], 1);
    TextDrawColor(welsirltk_TD_2[15], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[15], 255);
    TextDrawFont(welsirltk_TD_2[15], 4);
    TextDrawSetProportional(welsirltk_TD_2[15], 0);
    TextDrawSetShadow(welsirltk_TD_2[15], 0);


       welsirltk_TD_2[16] = TextDrawCreate(432.9524, 247.8605, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[16], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[16], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[16], 2);
    TextDrawColor(welsirltk_TD_2[16], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[16], 255);
    TextDrawFont(welsirltk_TD_2[16], 1);
    TextDrawSetProportional(welsirltk_TD_2[16], 1);
    TextDrawSetShadow(welsirltk_TD_2[16], 0);

    welsirltk_TD_2[17] = TextDrawCreate(475.9046, 213.7850, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[17], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[17], 1);
    TextDrawColor(welsirltk_TD_2[17], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[17], 255);
    TextDrawFont(welsirltk_TD_2[17], 4);
    TextDrawSetProportional(welsirltk_TD_2[17], 0);
    TextDrawSetShadow(welsirltk_TD_2[17], 0);

    welsirltk_TD_2[18] = TextDrawCreate(509.2855, 247.8606, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[18], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[18], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[18], 2);
    TextDrawColor(welsirltk_TD_2[18], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[18], 255);
    TextDrawFont(welsirltk_TD_2[18], 1);
    TextDrawSetProportional(welsirltk_TD_2[18], 1);
    TextDrawSetShadow(welsirltk_TD_2[18], 0);

    welsirltk_TD_2[19] = TextDrawCreate(551.5712, 264.8072, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[19], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[19], 1); 
    TextDrawColor(welsirltk_TD_2[19], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[19], 255);
    TextDrawFont(welsirltk_TD_2[19], 4);
    TextDrawSetProportional(welsirltk_TD_2[19], 0);
    TextDrawSetShadow(welsirltk_TD_2[19], 0);

    welsirltk_TD_2[20] = TextDrawCreate(585.6187, 298.4679, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[20], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[20], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[20], 2);
    TextDrawColor(welsirltk_TD_2[20], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[20], 255);
    TextDrawFont(welsirltk_TD_2[20], 1); 
    TextDrawSetProportional(welsirltk_TD_2[20], 1);
    TextDrawSetShadow(welsirltk_TD_2[20], 0);

    TextDrawLetterSize(welsirltk_TD_2[34], 0.1480, 0.8740);
    TextDrawTextSize(welsirltk_TD_2[34], -101.0000, 0.0000);
    TextDrawAlignment(welsirltk_TD_2[34], 1);
    TextDrawColor(welsirltk_TD_2[34], -81);
    TextDrawBackgroundColor(welsirltk_TD_2[34], 255);
    TextDrawFont(welsirltk_TD_2[34], 1);
    TextDrawSetProportional(welsirltk_TD_2[34], 1);
    TextDrawSetShadow(welsirltk_TD_2[34], 0);

    welsirltk_TD_2[21] = TextDrawCreate(398.9046, 265.2220, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[21], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[21], 1);
    TextDrawColor(welsirltk_TD_2[21], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[21], 255);
    TextDrawFont(welsirltk_TD_2[21], 4);
    TextDrawSetProportional(welsirltk_TD_2[21], 0);
    TextDrawSetShadow(welsirltk_TD_2[21], 0);

    welsirltk_TD_2[22] = TextDrawCreate(432.6191, 298.8827, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[22], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[22], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[22], 2);
    TextDrawColor(welsirltk_TD_2[22], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[22], 255);
    TextDrawFont(welsirltk_TD_2[22], 1);
    TextDrawSetProportional(welsirltk_TD_2[22], 1);
    TextDrawSetShadow(welsirltk_TD_2[22], 0);

    welsirltk_TD_2[23] = TextDrawCreate(475.5713, 264.8073, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[23], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[23], 1);
    TextDrawColor(welsirltk_TD_2[23], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[23], 255);
    TextDrawFont(welsirltk_TD_2[23], 4);
    TextDrawSetProportional(welsirltk_TD_2[23], 0);
    TextDrawSetShadow(welsirltk_TD_2[23], 0);

    welsirltk_TD_2[24] = TextDrawCreate(508.9522, 298.8828, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[24], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[24], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[24], 2);
    TextDrawColor(welsirltk_TD_2[24], -1);  
    TextDrawBackgroundColor(welsirltk_TD_2[24], 255);
    TextDrawFont(welsirltk_TD_2[24], 1);
    TextDrawSetProportional(welsirltk_TD_2[24], 1);
    TextDrawSetShadow(welsirltk_TD_2[24], 0);

    welsirltk_TD_2[25] = TextDrawCreate(552.2379, 315.4146, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[25], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[25], 1);
    TextDrawColor(welsirltk_TD_2[25], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[25], 255);
    TextDrawFont(welsirltk_TD_2[25], 4);
    TextDrawSetProportional(welsirltk_TD_2[25], 0);
    TextDrawSetShadow(welsirltk_TD_2[25], 0);

    welsirltk_TD_2[26] = TextDrawCreate(586.2855, 349.0754, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[26], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[26], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[26], 2);
    TextDrawColor(welsirltk_TD_2[26], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[26], 255);
    TextDrawFont(welsirltk_TD_2[26], 1);
    TextDrawSetProportional(welsirltk_TD_2[26], 1);
    TextDrawSetShadow(welsirltk_TD_2[26], 0);

    welsirltk_TD_2[27] = TextDrawCreate(399.5713, 315.8294, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[27], 70.0000, 44.0000); 
    TextDrawAlignment(welsirltk_TD_2[27], 1);
    TextDrawColor(welsirltk_TD_2[27], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[27], 255);
    TextDrawFont(welsirltk_TD_2[27], 4);
    TextDrawSetProportional(welsirltk_TD_2[27], 0);
    TextDrawSetShadow(welsirltk_TD_2[27], 0);

    welsirltk_TD_2[28] = TextDrawCreate(433.2857, 349.4902, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[28], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[28], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[28], 2);
    TextDrawColor(welsirltk_TD_2[28], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[28], 255);
    TextDrawFont(welsirltk_TD_2[28], 1);
    TextDrawSetProportional(welsirltk_TD_2[28], 1);
    TextDrawSetShadow(welsirltk_TD_2[28], 0); 

    welsirltk_TD_2[29] = TextDrawCreate(476.2379, 315.4147, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD_2[29], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD_2[29], 1);
    TextDrawColor(welsirltk_TD_2[29], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[29], 255);
    TextDrawFont(welsirltk_TD_2[29], 4);
    TextDrawSetProportional(welsirltk_TD_2[29], 0);
    TextDrawSetShadow(welsirltk_TD_2[29], 0);

    welsirltk_TD_2[30] = TextDrawCreate(509.6188, 349.4902, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD_2[30], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD_2[30], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD_2[30], 2);
    TextDrawColor(welsirltk_TD_2[30], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[30], 255); 
    TextDrawFont(welsirltk_TD_2[30], 1);
    TextDrawSetProportional(welsirltk_TD_2[30], 1);
    TextDrawSetShadow(welsirltk_TD_2[30], 0);

    welsirltk_TD_2[31] = TextDrawCreate(27.5713, 143.9302, "txd:brgiftsupdate"); // пусто
    TextDrawTextSize(welsirltk_TD_2[31], 126.0000, 74.0000);
    TextDrawAlignment(welsirltk_TD_2[31], 1);
    TextDrawColor(welsirltk_TD_2[31], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[31], 255);
    TextDrawFont(welsirltk_TD_2[31], 4);
    TextDrawSetProportional(welsirltk_TD_2[31], 0);
    TextDrawSetShadow(welsirltk_TD_2[31], 0);
    TextDrawSetSelectable(welsirltk_TD_2[31], true);

    welsirltk_TD_2[32] = TextDrawCreate(528.2379, 159.6932, "ruletka:brgiftsexit"); // пусто
    TextDrawTextSize(welsirltk_TD_2[32], 91.0000, 56.0000);
    TextDrawAlignment(welsirltk_TD_2[32], 1);
    TextDrawColor(welsirltk_TD_2[32], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[32], 255); 
    TextDrawFont(welsirltk_TD_2[32], 4);
    TextDrawSetProportional(welsirltk_TD_2[32], 0);
    TextDrawSetShadow(welsirltk_TD_2[32], 0);
    TextDrawSetSelectable(welsirltk_TD_2[32], true);

    welsirltk_TD_2[33] = TextDrawCreate(259.6665, 68.3864, "ruletka:brgiftsspin"); // пусто
    TextDrawTextSize(welsirltk_TD_2[33], 110.0000, 66.0000);
    TextDrawAlignment(welsirltk_TD_2[33], 1);
    TextDrawColor(welsirltk_TD_2[33], -1);
    TextDrawBackgroundColor(welsirltk_TD_2[33], 255);
    TextDrawFont(welsirltk_TD_2[33], 4);
    TextDrawSetProportional(welsirltk_TD_2[33], 0);
    TextDrawSetShadow(welsirltk_TD_2[33], 0);
    TextDrawSetSelectable(welsirltk_TD_2[33], true);
}
stock RuletkaPlayer_2(playerid) 
{
	ruletka_PTD_2[playerid][0] = CreatePlayerTextDraw(playerid, 430.2377, 13.7539, "txd:brgiftslic"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD_2[playerid][0], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_2[playerid][0], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD_2[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_2[playerid][0], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_2[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_2[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_2[playerid][0], 0);

	ruletka_PTD_2[playerid][1] = CreatePlayerTextDraw(playerid, 352.6664, 13.7340, "txd:brgiftsuncar"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD_2[playerid][1], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_2[playerid][1], 1); 
	PlayerTextDrawColor(playerid, ruletka_PTD_2[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_2[playerid][1], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_2[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_2[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_2[playerid][1], 0);

	ruletka_PTD_2[playerid][2] = CreatePlayerTextDraw(playerid, 276.3807, 14.9784, "txd:brgiftsgvip"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD_2[playerid][2], 70.0000, 44.0000); 
	PlayerTextDrawAlignment(playerid, ruletka_PTD_2[playerid][2], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD_2[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_2[playerid][2], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_2[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_2[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_2[playerid][2], 0);

	ruletka_PTD_2[playerid][4] = CreatePlayerTextDraw(playerid, 123.9045, 14.6739, "txd:brgiftscash"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD_2[playerid][4], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_2[playerid][4], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD_2[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_2[playerid][4], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_2[playerid][4], 4); 
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_2[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_2[playerid][4], 0);

	ruletka_PTD_2[playerid][3] = CreatePlayerTextDraw(playerid, 200.4284, 15.0650, "txd:brgiftsgun"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD_2[playerid][3], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_2[playerid][3], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD_2[playerid][3], -1); 
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_2[playerid][3], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_2[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_2[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_2[playerid][3], 0);

	ruletka_PTD_t_2[playerid][1] = CreatePlayerTextDraw(playerid, 389.3807, 44.9925, "BMW_M5_F90"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][1], 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][1], 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][1], 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][1], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][1], 0);

	ruletka_PTD_t_2[playerid][2] = CreatePlayerTextDraw(playerid, 311.8570, 46.6399, "Gold-Vip"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][2], 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][2], 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][2], 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][2], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][2], 0);

	ruletka_PTD_t_2[playerid][3] = CreatePlayerTextDraw(playerid, 235.2379, 47.0784, "Случайное оружие"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][3], 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][3], 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][3], 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][3], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][3], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][3], 0);

	ruletka_PTD_t_2[playerid][4] = CreatePlayerTextDraw(playerid, 157.2856, 48.3346, "до 100000 р."); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][4], 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][4], 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][4], 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][4], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][4], 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][4], 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][4], 0);

	ruletka_PTD_t_2[playerid][0] = CreatePlayerTextDraw(playerid, 466.8570, 45.8340, "Пакет с лицензиями"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][0], 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][0], 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][0], 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][0], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][0], 0);

    ruletka_PTD_t_2[playerid][5] = CreatePlayerTextDraw(playerid, 11.6664, 358.4451, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][5], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][5], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][5], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][5], 0);

    ruletka_PTD_t_2[playerid][6] = CreatePlayerTextDraw(playerid, 99.6666, 361.7334, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][6], 0.2506, 1.2391);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][6], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][6], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][6], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][6], 0);

    ruletka_PTD_t_2[playerid][7] = CreatePlayerTextDraw(playerid, 47.7141, 388.8739, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][7], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][7], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][7], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][7], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][7], 0);

    ruletka_PTD_t_2[playerid][8] = CreatePlayerTextDraw(playerid, 86.9999, 376.6668, "ЗОЛОТОЙ КЕЙС"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][8], 0.1793, 1.0897);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][8], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][8], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][8], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][8], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][8], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][8], 0);

    ruletka_PTD_t_2[playerid][9] = CreatePlayerTextDraw(playerid, 10.9998, 305.7636, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][9], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][9], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][9], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][9], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][9], 0);

    ruletka_PTD_t_2[playerid][10] = CreatePlayerTextDraw(playerid, 47.3807, 336.1924, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][10], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][10], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][10], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][10], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][10], 0);

    ruletka_PTD_t_2[playerid][11] = CreatePlayerTextDraw(playerid, 99.6666, 308.2222, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][11], 0.2526, 1.2640);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][11], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][11], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][11], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][11], 0);

    ruletka_PTD_t_2[playerid][12] = CreatePlayerTextDraw(playerid, 86.9999, 323.1556, "ЗОЛОТОЙ КЕЙС"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][12], 0.1813, 1.1146);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][12], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][12], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][12], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][12], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][12], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][12], 0);

    ruletka_PTD_t_2[playerid][13] = CreatePlayerTextDraw(playerid,11.3331, 253.0822, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][13], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][13], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][13], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][13], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][13], 0);

    ruletka_PTD_t_2[playerid][14] = CreatePlayerTextDraw(playerid,47.7141, 283.5110, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][14], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][14], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][14], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][14], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][14], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][14], 0);

    ruletka_PTD_t_2[playerid][15] = CreatePlayerTextDraw(playerid,99.6666, 256.3703, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][15], 0.2526, 1.2640);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][15], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][15], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][15], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][15], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][15], 0);

    ruletka_PTD_t_2[playerid][16] = CreatePlayerTextDraw(playerid,86.9999, 271.3037, "ЗОЛОТОЙ КЕЙС"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][16], 0.1813, 1.1146);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t_2[playerid][16], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][16], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][16], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][16], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][16], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][16], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][16], 0);

    ruletka_PTD_t_2[playerid][17] = CreatePlayerTextDraw(playerid, 317.3334, 173.8222, "4"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t_2[playerid][17], 0.2939, 1.3386);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t_2[playerid][17], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t_2[playerid][17], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t_2[playerid][17], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t_2[playerid][17], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t_2[playerid][17], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t_2[playerid][17], 0);
}

new td_prize_2[12][2] = 
{
    {5,6},
    {9,10},
    {11,12},
    {13,14},
    {15,16},
    {17,18},
    {19,20},
    {21,22},
    {23,24},
    {25,26},
    {27,28},
    {29,30}
};

stock LoadPrizeRuletka_2()
{ 
    for(new i_2;i_2 <12;i_2++)
    {
        TextDrawSetString(welsirltk_TD_2[td_prize_2[i_2][0]], ruletka_prize_2[i_2][R_NAME_TXD_2]);
        TextDrawSetString(welsirltk_TD_2[td_prize_2[i_2][1]], ruletka_prize_2[i_2][R_NAME_TEXT_2]);
    }
    return 1;
}
public:RunRuletka_2(playerid)
{
	animation_player_2[playerid] = true;

	if(ruletka_count_2[playerid])
	{
		new text_2[135];
 
		if(ruletka_count_2[playerid] == 15)
		{
			format(text_2, sizeof text_2, "Поздравляем! Вам выпал %s{FFFF00}.{FFFFFF} Чтобы забрать приз {FFFF00}/roulette", ruletka_prize_2[menu_prize_player_2[playerid][2]][R_NAME_PRIZE_2]);
			SendClientMessage(playerid, -1, text_2);
            GivePrizeRoulette_2(playerid, menu_prize_player_2[playerid][2]);

			animation_player_2[playerid] = false;
			KillTimer(timer_player_ruletka_2[playerid]);
			timer_player_ruletka_2[playerid] = -1;
			ruletka_count_2[playerid]=0;

            format(last_player_ruletka_2[0][last_player_name_2], 24, last_player_ruletka_2[1][last_player_name_2]);
            last_player_ruletka_2[0][id_ruletka_prize_2] = last_player_ruletka_2[1][id_ruletka_prize_2];
            format(last_player_ruletka_2[1][last_player_name_2], 24, last_player_ruletka_2[2][last_player_name_2]);
            last_player_ruletka_2[1][id_ruletka_prize_2] = last_player_ruletka_2[2][id_ruletka_prize_2];
            format(last_player_ruletka_2[2][last_player_name_2], 24, GetPlayerNameEx(playerid));
            last_player_ruletka_2[2][id_ruletka_prize_2] = menu_prize_player_2[playerid][2];

			return 1;
		}
		else
		{
			ruletka_count_2[playerid]++;

			new o_2 = 5;
			while(o_2 > 1)
			{
				o_2--;
				PlayerTextDrawSetString(playerid, ruletka_PTD_2[playerid][o_2], ruletka_prize_2[menu_prize_player_2[playerid][o_2-1]][R_NAME_TXD_2]);
				PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][o_2], ruletka_prize_2[menu_prize_player_2[playerid][o_2-1]][R_NAME_TEXT_2]);
				menu_prize_player_2[playerid][o_2] = menu_prize_player_2[playerid][o_2-1];
 
			}

            new array_2[] = {2,2,8,8,8,8,8,8,8,8,16,18};
			menu_prize_player_2[playerid][0] = random2_2(array_2);
			PlayerTextDrawSetString(playerid, ruletka_PTD_2[playerid][0], ruletka_prize_2[menu_prize_player_2[playerid][0]][R_NAME_TXD_2]);
			PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][0], ruletka_prize_2[menu_prize_player_2[playerid][0]][R_NAME_TEXT_2]);
		}
	}
	else
	{
		ruletka_count_2[playerid]=1;
	}
 
	return 1;
}

stock UpdateLastPlayerRuletka_2(playerid)
{
    for(new i_2; i_2 < 3;i_2++)
    {
        PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][0]], last_player_ruletka_2[i_2][last_player_name_2]);
        PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][1]], ruletka_prize_2[last_player_ruletka_2[i_2][id_ruletka_prize_2]][R_NAME_TXD_2]);
        PlayerTextDrawSetString(playerid, ruletka_PTD_t_2[playerid][last_player_td_2[i_2][2]], ruletka_prize_2[last_player_ruletka_2[i_2][id_ruletka_prize_2]][R_NAME_TEXT_2]);
    } 

    return 1;
}
 
random2_2(array_2[], size_w_2 = sizeof(array_2))
 {
	if(size_w_2 < 1) return -1;
	new sum_2 = 0, result_2 = 0;

	for(new i_2 = size_w_2 - 1; i_2 > -1; i_2--)
	{
		sum_2 += array_2[i_2];
		 if(random(sum_2) < array_2[i_2])
		  {
			result_2 = i_2;
		  } 
	}
		    return result_2;
}

stock GivePrizeRoulette_2(playerid, prize_id_2)
{
    new query_2[94]; 
    mysql_format(mysql, query_2, sizeof query_2, "INSERT INTO roulette_prize (owner, prize) VALUES (%d,%d)", GetPlayerAccountID(playerid), prize_id_2);
    mysql_query(mysql, query_2, false);

    if(mysql_errno()) SendClientMessage(playerid, -1, "Ошибка в запросе."); 

    return 1;
}
public: CreateTablistRoulette_2()
{ 
    new Cache:cache_2 = mysql_query(mysql, "SELECT * FROM roulette_prize", true); 

    if(mysql_errno())
    {
        mysql_query(mysql, "CREATE TABLE .`roulette_prize` ( `id` INT NOT NULL AUTO_INCREMENT , `owner` INT NOT NULL , `prize` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB", false);

        if(mysql_errno()) printf("%d error create tablist roulette_prize", mysql_errno());
    }

    cache_delete(cache_2);

    cache_2 = mysql_query(mysql, "SELECT * FROM accounts WHERE roulette_gold", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `roulette_gold` INT NOT NULL DEFAULT '0' AFTER `money`", false);

        if(mysql_errno()) printf("%d error alter roulette_gold", mysql_errno());
    }
 
    cache_delete(cache_2);

    return 1;
}

stock GivePlayerCarRoulette_2(playerid, modelid_2, color_1_2, color_2_2) 
{
		new to_player_2 = playerid;
		new Float:POS_2[3];
		GetPlayerPos(to_player_2, POS_2[0],POS_2[1],POS_2[2]);
		new Float: pos_x_2 = POS_2[0];
		new Float: pos_y_2 = POS_2[1];
		new Float: pos_z_2 = POS_2[2];
		new Float: angle_2 = 356.7986;
		new query_2[220],
			Cache: result_2,
			idx_2;

		idx_2 = GetFreeOwnableCarID();
		SetOwnableCarData(idx_2, OC_OWNER_ID, 	GetPlayerAccountID(to_player_2));
		SetOwnableCarData(idx_2, OC_MODEL_ID, 	modelid_2);
		SetOwnableCarData(idx_2, OC_COLOR_1, 		color_1_2);
		SetOwnableCarData(idx_2, OC_COLOR_2, 		color_2_2);
		SetOwnableCarData(idx_2, OC_POS_X, 		pos_x_2);
		SetOwnableCarData(idx_2, OC_POS_Y, 		pos_y_2);
		SetOwnableCarData(idx_2, OC_POS_Z, 		pos_z_2);
		SetOwnableCarData(idx_2, OC_ANGLE, 		angle_2);
		strmid(g_ownable_car[idx_2][OC_NUMBER], "--------", 0, 8, 8);
		SetOwnableCarData(idx_2, OC_ALARM, 		false);
		SetOwnableCarData(idx_2, OC_KEY_IN, 		true);
		SetOwnableCarData(idx_2, OC_CREATE, 		gettime());
		/*new idt_2 = GetFreeOwnableCarID();*/
		format(g_ownable_car[idx_2][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));
		//SetVehicleRuNumberPlate(vehicleid, g_ownable_car[idt_2][OC_NUMBER], "52");

		// ----------------------------------------------------------------------------------------
 
		new vehicleid_2 = CreateVehicle
		(
			GetOwnableCarData(idx_2, OC_MODEL_ID),
			GetOwnableCarData(idx_2, OC_POS_X),
			GetOwnableCarData(idx_2, OC_POS_Y),
			GetOwnableCarData(idx_2, OC_POS_Z),
			GetOwnableCarData(idx_2, OC_ANGLE),
			GetOwnableCarData(idx_2, OC_COLOR_1),
			GetOwnableCarData(idx_2, OC_COLOR_2),
			-1,
			0,
			VEHICLE_ACTION_TYPE_OWNABLE_CAR,
			idx_2
		);
		if(vehicleid_2 != INVALID_VEHICLE_ID)
		{
			ApplyOwnableCarPlate(vehicleid_2, idx_2);
			SetVehicleParam(vehicleid_2, V_LOCK, false);

			SetVehicleData(vehicleid_2, V_MILEAGE, 0.0);
		}

		SetPlayerData(to_player_2, P_OWNABLE_CAR, vehicleid_2);
 
		format
		(
			query_2, sizeof query_2,
			"INSERT INTO ownable_cars \
			(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
			VALUES \
			('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
			GetPlayerAccountID(to_player_2),
			modelid_2,
			color_1_2,
			color_2_2,
			pos_x_2,
			pos_y_2,
			pos_z_2,
			angle_2,
			gettime()
		);
		result_2 = mysql_query(mysql, query_2, true);
		SetOwnableCarData(idx_2, OC_SQL_ID, cache_insert_id());
		cache_delete(result_2);
}

CMD:roulette_2(playerid) 
{
    new query_2[94];
    mysql_format(mysql, query_2, sizeof query_2, "SELECT * FROM roulette_prize WHERE owner = %d", GetPlayerAccountID(playerid));
    new Cache:cache_2 = mysql_query(mysql, query_2);

    if(!cache_num_rows()) return SendClientMessage(playerid, -1, "У вас нет призов с рулетки.");

    new rows_2, prize_id_2,id_2, list_2[52], dialog_2[sizeof list_2*10+54];

    strcat(dialog_2, "Следующая страница\nПредыдущая страница\n");

    rows_2 = cache_num_rows();

    if(rows_2 >= 10) rows_2 = 10;

    for(new i_2,c_2=2;i_2 < rows_2;i_2++,c_2++) 
    {
        prize_id_2 = cache_get_field_content_int(i_2, "prize");
        id_2 = cache_get_field_content_int(i_2, "id");

        format(list_2, sizeof list_2, "%d. %s\n", i_2+1, ruletka_prize_2[prize_id_2][R_NAME_PRIZE_2]);
        strcat(dialog_2, list_2);
        SetPlayerListitemValue(playerid, c_2, prize_id_2);
        format(list_2, sizeof list_2, "rouletteid_%d", c_2);
        SetPVarInt(playerid, list_2, id_2);
    }

    SetPVarInt(playerid, "count_list", 1);
    Dialog(playerid, 21832, DIALOG_STYLE_LIST, "{FF0000}Призы с рулетки", dialog_2, "Далее", "Выйти");
    return 1;
} 

public:LoadRuletka_2(playerid)
{
    new text_2[124];
    mysql_format(mysql, text_2, sizeof text_2, "SELECT roulette_gold FROM accounts WHERE id=%d", GetPlayerAccountID(playerid));
    new Cache:cache_2 = mysql_query(mysql, text_2, true);
    if(mysql_errno()) SendClientMessage(playerid, -1, "Ошибка в запросе.");

    player_roulette_bronz_2[playerid] = cache_get_row_int(0, 0);
    cache_delete(cache_2);
    return 1;
}
CMD:openroulette3(playerid)
{
	TogglePlayerControllable(playerid, false);
	HideHud(playerid);
	RuletkaPlayer3(playerid);
    SelectTextDraw(playerid, -1);
	for(new i3;i3 < 20;i3++) SendClientMessage(playerid, -1, "");

	for(new t3;t3 < sizeof welsirltk_TD3;t3++)
	{
		TextDrawShowForPlayer(playerid, welsirltk_TD3[t3]);
	}

	for(new t3,welsi3;t3 < 5;t3++, welsi3 = random(12))
	{
		PlayerTextDrawSetString(playerid, ruletka_PTD3[playerid][t3], ruletka_prize3[welsi3][R_NAME_TXD3]);
		PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][t3], ruletka_prize3[welsi3][R_NAME_TEXT3]);
		PlayerTextDrawShow(playerid, ruletka_PTD3[playerid][t3]);
		PlayerTextDrawShow(playerid, ruletka_PTD_t3[playerid][t3]);
		menu_prize_player3[playerid][t3] = welsi3;
	}

    UpdateLastPlayerRuletka3(playerid);

    for(new i3; i3 < 3;i3++)
    {
        PlayerTextDrawShow(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][0]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][1]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][2]]);
        PlayerTextDrawShow(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][3]]);
    }

    new string3[10];
    format(string3, sizeof string3, "%d", player_roulette_bronz3[playerid]);
    PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][17], string3);

    PlayerTextDrawShow(playerid, ruletka_PTD_t3[playerid][17]);
    return 1;
}
stock RuletkaMenu3()
{
    welsirltk_TD3[0] = TextDrawCreate(3.6665, 208.3332, "txd:brgiftsdownpanel"); // пусто
    TextDrawTextSize(welsirltk_TD3[0], 624.0000, 209.0000);
    TextDrawAlignment(welsirltk_TD3[0], 1);
    TextDrawColor(welsirltk_TD3[0], -1);
    TextDrawBackgroundColor(welsirltk_TD3[0], 255);
    TextDrawFont(welsirltk_TD3[0], 4);
    TextDrawSetProportional(welsirltk_TD3[0], 0);
    TextDrawSetShadow(welsirltk_TD3[0], 0);

    welsirltk_TD3[1] = TextDrawCreate(47.2378, 11.6280, "txd:brgiftsbgspin"); // пусто
    TextDrawTextSize(welsirltk_TD3[1], 530.0000, 49.0000);
    TextDrawAlignment(welsirltk_TD3[1], 1);
    TextDrawColor(welsirltk_TD3[1], -1);
    TextDrawBackgroundColor(welsirltk_TD3[1], 255);
    TextDrawFont(welsirltk_TD3[1], 4);
    TextDrawSetProportional(welsirltk_TD3[1], 0);
    TextDrawSetShadow(welsirltk_TD3[1], 0);
    TextDrawSetSelectable(welsirltk_TD3[1], true);

    welsirltk_TD3[2] = TextDrawCreate(255.0950, 167.3733, "txd:brgiftsdostupno"); // пусто
    TextDrawTextSize(welsirltk_TD3[2], 87.0000, 27.0000);
    TextDrawAlignment(welsirltk_TD3[2], 1);
    TextDrawColor(welsirltk_TD3[2], -1);
    TextDrawBackgroundColor(welsirltk_TD3[2], 255);
    TextDrawFont(welsirltk_TD3[2], 4);
    TextDrawSetProportional(welsirltk_TD3[2], 0);
    TextDrawSetShadow(welsirltk_TD3[2], 0);

    welsirltk_TD3[4] = TextDrawCreate(114.1427, 66.2651, "txd:brgiftsbuycase"); // пусто
    TextDrawTextSize(welsirltk_TD3[4], 105.0000, 70.0000);
    TextDrawAlignment(welsirltk_TD3[4], 1);
    TextDrawColor(welsirltk_TD3[4], -1);
    TextDrawBackgroundColor(welsirltk_TD3[4], 255);
    TextDrawFont(welsirltk_TD3[4], 4);
    TextDrawSetProportional(welsirltk_TD3[4], 0);
    TextDrawSetShadow(welsirltk_TD3[4], 0);
    TextDrawSetSelectable(welsirltk_TD3[4], true);

    welsirltk_TD3[5] = TextDrawCreate(553.9045, 366.4369, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[5], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[5], 1);
    TextDrawColor(welsirltk_TD3[5], -1);
    TextDrawBackgroundColor(welsirltk_TD3[5], 255);
    TextDrawFont(welsirltk_TD3[5], 4);
    TextDrawSetProportional(welsirltk_TD3[5], 0);
    TextDrawSetShadow(welsirltk_TD3[5], 0);

    welsirltk_TD3[6] = TextDrawCreate(586.6188, 399.6828, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[6], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[6], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[6], 2);
    TextDrawColor(welsirltk_TD3[6], -1);
    TextDrawBackgroundColor(welsirltk_TD3[6], 255);
    TextDrawFont(welsirltk_TD3[6], 1);
    TextDrawSetProportional(welsirltk_TD3[6], 1);
    TextDrawSetShadow(welsirltk_TD3[6], 0);

    welsirltk_TD3[7] = TextDrawCreate(196.6666, 288.5704, "txd:brgiftbronzatext"); // пусто
    TextDrawTextSize(welsirltk_TD3[7], 171.0000, 202.0000);
    TextDrawAlignment(welsirltk_TD3[7], 1);
    TextDrawColor(welsirltk_TD3[7], -1);
    TextDrawBackgroundColor(welsirltk_TD3[7], 255);
    TextDrawFont(welsirltk_TD3[7], 4);
    TextDrawSetProportional(welsirltk_TD3[7], 0);
    TextDrawSetShadow(welsirltk_TD3[7], 0);

    welsirltk_TD3[8] = TextDrawCreate(239.3332, 219.0370, "АВТОКЕЙС"); // пусто
    TextDrawLetterSize(welsirltk_TD3[8], 0.3193, 1.7368);
    TextDrawTextSize(welsirltk_TD3[8], -6.0000, 0.0000);
    TextDrawAlignment(welsirltk_TD3[8], 1);
    TextDrawColor(welsirltk_TD3[8], -1);
    TextDrawBackgroundColor(welsirltk_TD3[8], 255);
    TextDrawFont(welsirltk_TD3[8], 2);
    TextDrawSetProportional(welsirltk_TD3[8], 1);
    TextDrawSetShadow(welsirltk_TD3[8], 0);

    welsirltk_TD3[9] = TextDrawCreate(399.5713, 366.8517, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[9], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[9], 1);
    TextDrawColor(welsirltk_TD3[9], -1); 
    TextDrawBackgroundColor(welsirltk_TD3[9], 255);
    TextDrawFont(welsirltk_TD3[9], 4);
    TextDrawSetProportional(welsirltk_TD3[9], 0);
    TextDrawSetShadow(welsirltk_TD3[9], 0);

    welsirltk_TD3[10] = TextDrawCreate(433.2857, 400.5124, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[10], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[10], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[10], 2);
    TextDrawColor(welsirltk_TD3[10], -1);
    TextDrawBackgroundColor(welsirltk_TD3[10], 255);
    TextDrawFont(welsirltk_TD3[10], 1);
    TextDrawSetProportional(welsirltk_TD3[10], 1);
    TextDrawSetShadow(welsirltk_TD3[10], 0);

    welsirltk_TD3[11] = TextDrawCreate(476.2379, 366.4370, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[11], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[11], 1);
    TextDrawColor(welsirltk_TD3[11], -1);
    TextDrawBackgroundColor(welsirltk_TD3[11], 255);
    TextDrawFont(welsirltk_TD3[11], 4);
    TextDrawSetProportional(welsirltk_TD3[11], 0);
    TextDrawSetShadow(welsirltk_TD3[11], 0);
 
    welsirltk_TD3[12] = TextDrawCreate(509.6188, 400.5125, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[12], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[12], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[12], 2);
    TextDrawColor(welsirltk_TD3[12], -1);
    TextDrawBackgroundColor(welsirltk_TD3[12], 255);
    TextDrawFont(welsirltk_TD3[12], 1);
    TextDrawSetProportional(welsirltk_TD3[12], 1);
    TextDrawSetShadow(welsirltk_TD3[12], 0);

    welsirltk_TD3[13] = TextDrawCreate(551.9046, 213.7850, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[13], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[13], 1); 
    TextDrawColor(welsirltk_TD3[13], -1);
    TextDrawBackgroundColor(welsirltk_TD3[13], 255);
    TextDrawFont(welsirltk_TD3[13], 4);
    TextDrawSetProportional(welsirltk_TD3[13], 0);
    TextDrawSetShadow(welsirltk_TD3[13], 0);

    welsirltk_TD3[14] = TextDrawCreate(585.9521, 247.4457, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[14], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[14], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[14], 2);
    TextDrawColor(welsirltk_TD3[14], -1);
    TextDrawBackgroundColor(welsirltk_TD3[14], 255);
    TextDrawFont(welsirltk_TD3[14], 1);
    TextDrawSetProportional(welsirltk_TD3[14], 1);
    TextDrawSetShadow(welsirltk_TD3[14], 0);

    welsirltk_TD3[15] = TextDrawCreate(399.2380, 214.1998, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[15], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[15], 1);
    TextDrawColor(welsirltk_TD3[15], -1);
    TextDrawBackgroundColor(welsirltk_TD3[15], 255);
    TextDrawFont(welsirltk_TD3[15], 4);
    TextDrawSetProportional(welsirltk_TD3[15], 0);
    TextDrawSetShadow(welsirltk_TD3[15], 0);

    welsirltk_TD3[16] = TextDrawCreate(432.9524, 247.8605, "љo_100000_p."); // пусто
     
    TextDrawLetterSize(welsirltk_TD3[16], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[16], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[16], 2);
    TextDrawColor(welsirltk_TD3[16], -1);
    TextDrawBackgroundColor(welsirltk_TD3[16], 255);
    TextDrawFont(welsirltk_TD3[16], 1);
    TextDrawSetProportional(welsirltk_TD3[16], 1);
    TextDrawSetShadow(welsirltk_TD3[16], 0);

    welsirltk_TD3[17] = TextDrawCreate(475.9046, 213.7850, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[17], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[17], 1);
    TextDrawColor(welsirltk_TD3[17], -1);
    TextDrawBackgroundColor(welsirltk_TD3[17], 255);
    TextDrawFont(welsirltk_TD3[17], 4);
    TextDrawSetProportional(welsirltk_TD3[17], 0);
    TextDrawSetShadow(welsirltk_TD3[17], 0);

    welsirltk_TD3[18] = TextDrawCreate(509.2855, 247.8606, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[18], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[18], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[18], 2);
  welsirltk_TD3[18] = TextDrawCreate(509.2855, 247.8606, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[18], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[18], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[18], 2);
    TextDrawColor(welsirltk_TD3[18], -1);
    TextDrawBackgroundColor(welsirltk_TD3[18], 255);
    TextDrawFont(welsirltk_TD3[18], 1);
    TextDrawSetProportional(welsirltk_TD3[18], 1);
    TextDrawSetShadow(welsirltk_TD3[18], 0);

    welsirltk_TD3[19] = TextDrawCreate(551.5712, 264.8072, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[19], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[19], 1); 
    TextDrawColor(welsirltk_TD3[19], -1);
    TextDrawBackgroundColor(welsirltk_TD3[19], 255);
    TextDrawFont(welsirltk_TD3[19], 4);
    TextDrawSetProportional(welsirltk_TD3[19], 0);
    TextDrawSetShadow(welsirltk_TD3[19], 0);

    welsirltk_TD3[20] = TextDrawCreate(585.6187, 298.4679, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[20], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[20], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[20], 2);
    TextDrawColor(welsirltk_TD3[20], -1);
    TextDrawBackgroundColor(welsirltk_TD3[20], 255);
    TextDrawFont(welsirltk_TD3[20], 1); 
    TextDrawSetProportional(welsirltk_TD3[20], 1);
    TextDrawSetShadow(welsirltk_TD3[20], 0);

    TextDrawLetterSize(welsirltk_TD3[34], 0.1480, 0.8740);
    TextDrawTextSize(welsirltk_TD3[34], -101.0000, 0.0000);
    TextDrawAlignment(welsirltk_TD3[34], 1);
    TextDrawColor(welsirltk_TD3[34], -81);
    TextDrawBackgroundColor(welsirltk_TD3[34], 255);
    TextDrawFont(welsirltk_TD3[34], 1);
    TextDrawSetProportional(welsirltk_TD3[34], 1);
    TextDrawSetShadow(welsirltk_TD3[34], 0);

    welsirltk_TD3[21] = TextDrawCreate(398.9046, 265.2220, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[21], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[21], 1);
    TextDrawColor(welsirltk_TD3[21], -1);
    TextDrawBackgroundColor(welsirltk_TD3[21], 255);
    TextDrawFont(welsirltk_TD3[21], 4);
    TextDrawSetProportional(welsirltk_TD3[21], 0);
    TextDrawSetShadow(welsirltk_TD3[21], 0);

    welsirltk_TD3[22] = TextDrawCreate(432.6191, 298.8827, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[22], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[22], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[22], 2);
    TextDrawColor(welsirltk_TD3[22], -1);
    TextDrawBackgroundColor(welsirltk_TD3[22], 255);
    TextDrawFont(welsirltk_TD3[22], 1);
    TextDrawSetProportional(welsirltk_TD3[22], 1);
    TextDrawSetShadow(welsirltk_TD3[22], 0);

    welsirltk_TD3[23] = TextDrawCreate(475.5713, 264.8073, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[23], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[23], 1);
    TextDrawColor(welsirltk_TD3[23], -1);
    TextDrawBackgroundColor(welsirltk_TD3[23], 255);
    TextDrawFont(welsirltk_TD3[23], 4);
    TextDrawSetProportional(welsirltk_TD3[23], 0);
    TextDrawSetShadow(welsirltk_TD3[23], 0);

    welsirltk_TD3[24] = TextDrawCreate(508.9522, 298.8828, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[24], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[24], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[24], 2);
    TextDrawColor(welsirltk_TD3[24], -1);  
    TextDrawBackgroundColor(welsirltk_TD3[24], 255);
    TextDrawFont(welsirltk_TD3[24], 1);
    TextDrawSetProportional(welsirltk_TD3[24], 1);
    TextDrawSetShadow(welsirltk_TD3[24], 0);

    welsirltk_TD3[25] = TextDrawCreate(552.2379, 315.4146, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[25], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[25], 1);
    TextDrawColor(welsirltk_TD3[25], -1);
    TextDrawBackgroundColor(welsirltk_TD3[25], 255);
    TextDrawFont(welsirltk_TD3[25], 4);
    TextDrawSetProportional(welsirltk_TD3[25], 0);
    TextDrawSetShadow(welsirltk_TD3[25], 0);

    welsirltk_TD3[26] = TextDrawCreate(586.2855, 349.0754, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[26], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[26], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[26], 2);
    TextDrawColor(welsirltk_TD3[26], -1);
    TextDrawBackgroundColor(welsirltk_TD3[26], 255);
    TextDrawFont(welsirltk_TD3[26], 1);
    TextDrawSetProportional(welsirltk_TD3[26], 1);
    TextDrawSetShadow(welsirltk_TD3[26], 0);

    welsirltk_TD3[27] = TextDrawCreate(399.5713, 315.8294, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[27], 70.0000, 44.0000); 
    TextDrawAlignment(welsirltk_TD3[27], 1);
    TextDrawColor(welsirltk_TD3[27], -1);
    TextDrawBackgroundColor(welsirltk_TD3[27], 255);
    TextDrawFont(welsirltk_TD3[27], 4);
    TextDrawSetProportional(welsirltk_TD3[27], 0);
    TextDrawSetShadow(welsirltk_TD3[27], 0);

    welsirltk_TD3[28] = TextDrawCreate(433.2857, 349.4902, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[28], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[28], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[28], 2);
    TextDrawColor(welsirltk_TD3[28], -1);
    TextDrawBackgroundColor(welsirltk_TD3[28], 255);
    TextDrawFont(welsirltk_TD3[28], 1);
    TextDrawSetProportional(welsirltk_TD3[28], 1);
    TextDrawSetShadow(welsirltk_TD3[28], 0); 

    welsirltk_TD3[29] = TextDrawCreate(476.2379, 315.4147, "txd:brgiftscash"); // пусто
    TextDrawTextSize(welsirltk_TD3[29], 70.0000, 44.0000);
    TextDrawAlignment(welsirltk_TD3[29], 1);
    TextDrawColor(welsirltk_TD3[29], -1);
    TextDrawBackgroundColor(welsirltk_TD3[29], 255);
    TextDrawFont(welsirltk_TD3[29], 4);
    TextDrawSetProportional(welsirltk_TD3[29], 0);
    TextDrawSetShadow(welsirltk_TD3[29], 0);

    welsirltk_TD3[30] = TextDrawCreate(509.6188, 349.4902, "љo_100000_p."); // пусто
    TextDrawLetterSize(welsirltk_TD3[30], 0.1946, 0.7720);
    TextDrawTextSize(welsirltk_TD3[30], 0.0000, -24.0000);
    TextDrawAlignment(welsirltk_TD3[30], 2);
    TextDrawColor(welsirltk_TD3[30], -1);
    TextDrawBackgroundColor(welsirltk_TD3[30], 255); 
    TextDrawFont(welsirltk_TD3[30], 1);
    TextDrawSetProportional(welsirltk_TD3[30], 1);
    TextDrawSetShadow(welsirltk_TD3[30], 0);

    welsirltk_TD3[31] = TextDrawCreate(27.5713, 143.9302, "txd:brgiftsupdate"); // пусто
    TextDrawTextSize(welsirltk_TD3[31], 126.0000, 74.0000);
    TextDrawAlignment(welsirltk_TD3[31], 1);
    TextDrawColor(welsirltk_TD3[31], -1);
    TextDrawBackgroundColor(welsirltk_TD3[31], 255);
    TextDrawFont(welsirltk_TD3[31], 4);
    TextDrawSetProportional(welsirltk_TD3[31], 0);
    TextDrawSetShadow(welsirltk_TD3[31], 0);
    TextDrawSetSelectable(welsirltk_TD3[31], true);

    welsirltk_TD3[32] = TextDrawCreate(528.2379, 159.6932, "ruletka:brgiftsexit"); // пусто
    TextDrawTextSize(welsirltk_TD3[32], 91.0000, 56.0000);
    TextDrawAlignment(welsirltk_TD3[32], 1);
    TextDrawColor(welsirltk_TD3[32], -1);
    TextDrawBackgroundColor(welsirltk_TD3[32], 255); 
    TextDrawFont(welsirltk_TD3[32], 4);
    TextDrawSetProportional(welsirltk_TD3[32], 0);
    TextDrawSetShadow(welsirltk_TD3[32], 0);
    TextDrawSetSelectable(welsirltk_TD3[32], true);

    welsirltk_TD3[33] = TextDrawCreate(259.6665, 68.3864, "ruletka:brgiftsspin"); // пусто
    TextDrawTextSize(welsirltk_TD3[33], 110.0000, 66.0000);
    TextDrawAlignment(welsirltk_TD3[33], 1);
    TextDrawColor(welsirltk_TD3[33], -1);
    TextDrawBackgroundColor(welsirltk_TD3[33], 255);
    TextDrawFont(welsirltk_TD3[33], 4);
    TextDrawSetProportional(welsirltk_TD3[33], 0);
    TextDrawSetShadow(welsirltk_TD3[33], 0);
    TextDrawSetSelectable(welsirltk_TD3[33], true);

    casesda_TD[0] = TextDrawCreate(188.0000, 96.0962, "pizda:brgiftsinfo"); // ?????
TextDrawTextSize(casesda_TD[0], 278.0000, 213.0000);
TextDrawAlignment(casesda_TD[0], 1);
TextDrawColor(casesda_TD[0], -1);
TextDrawBackgroundColor(casesda_TD[0], 255);
TextDrawFont(casesda_TD[0], 4);
TextDrawSetProportional(casesda_TD[0], 0);
TextDrawSetShadow(casesda_TD[0], 0);


casesda_TD[1] = TextDrawCreate(188.0000, 96.0962, "pizda:brgiftsbronza"); // ?????
TextDrawTextSize(casesda_TD[1], 309.0000, 257.0000);
TextDrawAlignment(casesda_TD[1], 1);
TextDrawColor(casesda_TD[1], -1);
TextDrawBackgroundColor(casesda_TD[1], 255);
TextDrawFont(casesda_TD[1], 4);
TextDrawSetProportional(casesda_TD[1], 0);
TextDrawSetShadow(casesda_TD[1], 0);

casesda_TD[2] = TextDrawCreate(287.0000, 329.3778, "1000_P"); // ?????
TextDrawLetterSize(casesda_TD[2], 0.4233, 1.4880);
TextDrawAlignment(casesda_TD[2], 1);
TextDrawColor(casesda_TD[2], -1);
TextDrawBackgroundColor(casesda_TD[2], 255);
TextDrawFont(casesda_TD[2], 1);
TextDrawSetProportional(casesda_TD[2], 1);
TextDrawSetShadow(casesda_TD[2], 0);

casesda_TD[3] = TextDrawCreate(180.3332, 121.8147, ""); // ?????
TextDrawTextSize(casesda_TD[3], 87.0000, 57.0000);
TextDrawAlignment(casesda_TD[3], 1);
TextDrawColor(casesda_TD[3], -1);
TextDrawBackgroundColor(casesda_TD[3], 255);
TextDrawFont(casesda_TD[3], 4);
TextDrawSetProportional(casesda_TD[3], 0);
TextDrawSetShadow(casesda_TD[3], 0);
TextDrawSetSelectable(casesda_TD[3], true);

casesda_TD[4] = TextDrawCreate(383.3332, 84.0666, "pizda:brgiftsexit"); // ?????
TextDrawTextSize(casesda_TD[4], 93.0000, 49.0000);
TextDrawAlignment(casesda_TD[4], 1);
TextDrawColor(casesda_TD[4], -1);
TextDrawBackgroundColor(casesda_TD[4], 255);
TextDrawFont(casesda_TD[4], 4);
TextDrawSetProportional(casesda_TD[4], 0);
TextDrawSetShadow(casesda_TD[4], 0);
TextDrawSetSelectable(casesda_TD[4], true);

casesda_TD[5] = TextDrawCreate(180.9999, 156.6592, "pizda:brgiftsnubronza"); // ?????
TextDrawTextSize(casesda_TD[5], 87.0000, 57.0000);
TextDrawAlignment(casesda_TD[5], 1);
TextDrawColor(casesda_TD[5], -1);
TextDrawBackgroundColor(casesda_TD[5], 255);
TextDrawFont(casesda_TD[5], 4);
TextDrawSetProportional(casesda_TD[5], 0);
TextDrawSetShadow(casesda_TD[5], 0);
TextDrawSetSelectable(casesda_TD[5], true);

casesda_TD[6] = TextDrawCreate(181.3332, 191.5037, "pizda:brgiftsnusilver"); // ?????
TextDrawTextSize(casesda_TD[6], 87.0000, 57.0000);
TextDrawAlignment(casesda_TD[6], 1);
TextDrawColor(casesda_TD[6], -1);
TextDrawBackgroundColor(casesda_TD[6], 255);
TextDrawFont(casesda_TD[6], 4);
TextDrawSetProportional(casesda_TD[6], 0);
TextDrawSetShadow(casesda_TD[6], 0);
TextDrawSetSelectable(casesda_TD[6], true);

casesda_TD[7] = TextDrawCreate(181.3332, 226.3481, "pizda:brgiftsnugold"); // ?????
TextDrawTextSize(casesda_TD[7], 87.0000, 57.0000);
TextDrawAlignment(casesda_TD[7], 1);
TextDrawColor(casesda_TD[7], -1);
TextDrawBackgroundColor(casesda_TD[7], 255);
TextDrawFont(casesda_TD[7], 4);
TextDrawSetProportional(casesda_TD[7], 0);
TextDrawSetShadow(casesda_TD[7], 0);
TextDrawSetSelectable(casesda_TD[7], true);

casesda_TD[8] = TextDrawCreate(181.3332, 262.0223, "pizda:brgiftsnuautocase"); // ?????
TextDrawTextSize(casesda_TD[8], 87.0000, 57.0000);
TextDrawAlignment(casesda_TD[8], 1);
TextDrawColor(casesda_TD[8], -1);
TextDrawBackgroundColor(casesda_TD[8], 255);
TextDrawFont(casesda_TD[8], 4);
TextDrawSetProportional(casesda_TD[8], 0);
TextDrawSetShadow(casesda_TD[8], 0);
TextDrawSetSelectable(casesda_TD[8], true);

casesda_TD[9] = TextDrawCreate(392.0000, 311.8000, "pizda:brgiftsopen"); // ?????
TextDrawTextSize(casesda_TD[9], 75.0000, 50.0000);
TextDrawAlignment(casesda_TD[9], 1);
TextDrawColor(casesda_TD[9], -1);
TextDrawBackgroundColor(casesda_TD[9], 255);
TextDrawFont(casesda_TD[9], 4);
TextDrawSetProportional(casesda_TD[9], 0);
TextDrawSetShadow(casesda_TD[9], 0);
TextDrawSetSelectable(casesda_TD[9], true);

invdo_TD[0] = TextDrawCreate(93.8000, 134.8397, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[0], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[0], 1);
TextDrawColor(invdo_TD[0], -1);
TextDrawFont(invdo_TD[0], 5);
TextDrawSetProportional(invdo_TD[0], 0);
TextDrawSetShadow(invdo_TD[0], 0);
TextDrawSetSelectable(invdo_TD[0], true);
TextDrawSetPreviewModel(invdo_TD[0], 0);
TextDrawSetPreviewRot(invdo_TD[0], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[1] = TextDrawCreate(94.5998, 184.8663, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[1], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[1], 1);
TextDrawColor(invdo_TD[1], -1);
TextDrawFont(invdo_TD[1], 5);
TextDrawSetProportional(invdo_TD[1], 0);
TextDrawSetShadow(invdo_TD[1], 0);
TextDrawSetSelectable(invdo_TD[1], true);
TextDrawSetPreviewModel(invdo_TD[1], 0);
TextDrawSetPreviewRot(invdo_TD[1], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[2] = TextDrawCreate(92.1998, 235.6398, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[2], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[2], 1);
TextDrawColor(invdo_TD[2], -1);
TextDrawFont(invdo_TD[2], 5);
TextDrawSetProportional(invdo_TD[2], 0);
TextDrawSetShadow(invdo_TD[2], 0);
TextDrawSetSelectable(invdo_TD[2], true);
TextDrawSetPreviewModel(invdo_TD[2], 0);
TextDrawSetPreviewRot(invdo_TD[2], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[3] = TextDrawCreate(176.9998, 87.7996, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[3], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[3], 1);
TextDrawColor(invdo_TD[3], -1);
TextDrawFont(invdo_TD[3], 5);
TextDrawSetProportional(invdo_TD[3], 0);
TextDrawSetShadow(invdo_TD[3], 0);
TextDrawSetSelectable(invdo_TD[3], true);
TextDrawSetPreviewModel(invdo_TD[3], 0);
TextDrawSetPreviewRot(invdo_TD[3], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[4] = TextDrawCreate(175.3999, 137.0796, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[4], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[4], 1);
TextDrawColor(invdo_TD[4], -1);
TextDrawFont(invdo_TD[4], 5);
TextDrawSetProportional(invdo_TD[4], 0);
TextDrawSetShadow(invdo_TD[4], 0);
TextDrawSetSelectable(invdo_TD[4], true);
TextDrawSetPreviewModel(invdo_TD[4], 0);
TextDrawSetPreviewRot(invdo_TD[4], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[5] = TextDrawCreate(172.9998, 187.1062, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[5], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[5], 1);
TextDrawColor(invdo_TD[5], -1);
TextDrawFont(invdo_TD[5], 5);
TextDrawSetProportional(invdo_TD[5], 0);
TextDrawSetShadow(invdo_TD[5], 0);
TextDrawSetSelectable(invdo_TD[5], true);
TextDrawSetPreviewModel(invdo_TD[5], 0);
TextDrawSetPreviewRot(invdo_TD[5], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[6] = TextDrawCreate(172.1999, 234.8930, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[6], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[6], 1);
TextDrawColor(invdo_TD[6], -1);
TextDrawFont(invdo_TD[6], 5);
TextDrawSetProportional(invdo_TD[6], 0);
TextDrawSetShadow(invdo_TD[6], 0);
TextDrawSetSelectable(invdo_TD[6], true);
TextDrawSetPreviewModel(invdo_TD[6], 0);
TextDrawSetPreviewRot(invdo_TD[6], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[7] = TextDrawCreate(93.8000, 87.0531, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[7], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[7], 1);
TextDrawColor(invdo_TD[7], -1);
TextDrawFont(invdo_TD[7], 5);
TextDrawSetProportional(invdo_TD[7], 0);
TextDrawSetShadow(invdo_TD[7], 0);
TextDrawSetSelectable(invdo_TD[7], true);
TextDrawSetPreviewModel(invdo_TD[7], 0);
TextDrawSetPreviewRot(invdo_TD[7], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[8] = TextDrawCreate(257.7999, 92.2798, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[8], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[8], 1);
TextDrawColor(invdo_TD[8], -1);
TextDrawFont(invdo_TD[8], 5);
TextDrawSetProportional(invdo_TD[8], 0);
TextDrawSetShadow(invdo_TD[8], 0);
TextDrawSetSelectable(invdo_TD[8], true);
TextDrawSetPreviewModel(invdo_TD[8], 0);
TextDrawSetPreviewRot(invdo_TD[8], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[9] = TextDrawCreate(256.1998, 235.6398, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[9], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[9], 1);
TextDrawColor(invdo_TD[9], -1);
TextDrawFont(invdo_TD[9], 5);
TextDrawSetProportional(invdo_TD[9], 0);
TextDrawSetShadow(invdo_TD[9], 0);
TextDrawSetSelectable(invdo_TD[9], true);
TextDrawSetPreviewModel(invdo_TD[9], 0);
TextDrawSetPreviewRot(invdo_TD[9], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[10] = TextDrawCreate(318.6000, 92.2798, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[10], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[10], 1);
TextDrawColor(invdo_TD[10], -1);
TextDrawFont(invdo_TD[10], 5);
TextDrawSetProportional(invdo_TD[10], 0);
TextDrawSetShadow(invdo_TD[10], 0);
TextDrawSetSelectable(invdo_TD[10], true);
TextDrawSetPreviewModel(invdo_TD[10], 0);
TextDrawSetPreviewRot(invdo_TD[10], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[11] = TextDrawCreate(381.7998, 92.2798, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[11], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[11], 1);
TextDrawColor(invdo_TD[11], -1);
TextDrawFont(invdo_TD[11], 5);
TextDrawSetProportional(invdo_TD[11], 0);
TextDrawSetShadow(invdo_TD[11], 0);
TextDrawSetSelectable(invdo_TD[11], true);
TextDrawSetPreviewModel(invdo_TD[11], 0);
TextDrawSetPreviewRot(invdo_TD[11], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[12] = TextDrawCreate(442.5999, 91.5330, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[12], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[12], 1);
TextDrawColor(invdo_TD[12], -1);
TextDrawFont(invdo_TD[12], 5);
TextDrawSetProportional(invdo_TD[12], 0);
TextDrawSetShadow(invdo_TD[12], 0);
TextDrawSetSelectable(invdo_TD[12], true);
TextDrawSetPreviewModel(invdo_TD[12], 0);
TextDrawSetPreviewRot(invdo_TD[12], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[13] = TextDrawCreate(256.1998, 140.8130, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[13], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[13], 1);
TextDrawColor(invdo_TD[13], -1);
TextDrawFont(invdo_TD[13], 5);
TextDrawSetProportional(invdo_TD[13], 0);
TextDrawSetShadow(invdo_TD[13], 0);
TextDrawSetSelectable(invdo_TD[13], true);
TextDrawSetPreviewModel(invdo_TD[13], 0);
TextDrawSetPreviewRot(invdo_TD[13], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[14] = TextDrawCreate(318.5997, 139.3197, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[14], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[14], 1);
TextDrawColor(invdo_TD[14], -1);
TextDrawFont(invdo_TD[14], 5);
TextDrawSetProportional(invdo_TD[14], 0);
TextDrawSetShadow(invdo_TD[14], 0);
TextDrawSetSelectable(invdo_TD[14], true);
TextDrawSetPreviewModel(invdo_TD[14], 0);
TextDrawSetPreviewRot(invdo_TD[14], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[15] = TextDrawCreate(380.9997, 140.0664, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[15], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[15], 1);
TextDrawColor(invdo_TD[15], -1);
TextDrawFont(invdo_TD[15], 5);
TextDrawSetProportional(invdo_TD[15], 0);
TextDrawSetShadow(invdo_TD[15], 0);
TextDrawSetSelectable(invdo_TD[15], true);
TextDrawSetPreviewModel(invdo_TD[15], 0);
TextDrawSetPreviewRot(invdo_TD[15], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[16] = TextDrawCreate(440.9997, 140.0664, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[16], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[16], 1);
TextDrawColor(invdo_TD[16], -1);
TextDrawFont(invdo_TD[16], 5);
TextDrawSetProportional(invdo_TD[16], 0);
TextDrawSetShadow(invdo_TD[16], 0);
TextDrawSetSelectable(invdo_TD[16], true);
TextDrawSetPreviewModel(invdo_TD[16], 0);
TextDrawSetPreviewRot(invdo_TD[16], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[17] = TextDrawCreate(258.5997, 189.3464, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[17], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[17], 1);
TextDrawColor(invdo_TD[17], -1);
TextDrawFont(invdo_TD[17], 5);
TextDrawSetProportional(invdo_TD[17], 0);
TextDrawSetShadow(invdo_TD[17], 0);
TextDrawSetSelectable(invdo_TD[17], true);
TextDrawSetPreviewModel(invdo_TD[17], 0);
TextDrawSetPreviewRot(invdo_TD[17], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[18] = TextDrawCreate(319.3996, 189.3464, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[18], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[18], 1);
TextDrawColor(invdo_TD[18], -1);
TextDrawFont(invdo_TD[18], 5);
TextDrawSetProportional(invdo_TD[18], 0);
TextDrawSetShadow(invdo_TD[18], 0);
TextDrawSetSelectable(invdo_TD[18], true);
TextDrawSetPreviewModel(invdo_TD[18], 0);
TextDrawSetPreviewRot(invdo_TD[18], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[19] = TextDrawCreate(380.1995, 188.5997, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[19], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[19], 1);
TextDrawColor(invdo_TD[19], -1);
TextDrawFont(invdo_TD[19], 5);
TextDrawSetProportional(invdo_TD[19], 0);
TextDrawSetShadow(invdo_TD[19], 0);
TextDrawSetSelectable(invdo_TD[19], true);
TextDrawSetPreviewModel(invdo_TD[19], 0);
TextDrawSetPreviewRot(invdo_TD[19], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[20] = TextDrawCreate(441.7997, 185.6130, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[20], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[20], 1);
TextDrawColor(invdo_TD[20], -1);
TextDrawFont(invdo_TD[20], 5);
TextDrawSetProportional(invdo_TD[20], 0);
TextDrawSetShadow(invdo_TD[20], 0);
TextDrawSetSelectable(invdo_TD[20], true);
TextDrawSetPreviewModel(invdo_TD[20], 0);
TextDrawSetPreviewRot(invdo_TD[20], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[21] = TextDrawCreate(318.6000, 235.6398, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[21], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[21], 1);
TextDrawColor(invdo_TD[21], -1);
TextDrawFont(invdo_TD[21], 5);
TextDrawSetProportional(invdo_TD[21], 0);
TextDrawSetShadow(invdo_TD[21], 0);
TextDrawSetSelectable(invdo_TD[21], true);
TextDrawSetPreviewModel(invdo_TD[21], 0);
TextDrawSetPreviewRot(invdo_TD[21], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[22] = TextDrawCreate(378.5999, 235.6398, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[22], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[22], 1);
TextDrawColor(invdo_TD[22], -1);
TextDrawFont(invdo_TD[22], 5);
TextDrawSetProportional(invdo_TD[22], 0);
TextDrawSetShadow(invdo_TD[22], 0);
TextDrawSetSelectable(invdo_TD[22], true);
TextDrawSetPreviewModel(invdo_TD[22], 0);
TextDrawSetPreviewRot(invdo_TD[22], 0.0000, 0.0000, 0.0000, 1.0000);

invdo_TD[23] = TextDrawCreate(441.7998, 233.3997, "brinv:brinvslot"); // ?????
TextDrawTextSize(invdo_TD[23], 83.0000, 42.0000);
TextDrawAlignment(invdo_TD[23], 1);
TextDrawColor(invdo_TD[23], -1);
TextDrawFont(invdo_TD[23], 5);
TextDrawSetProportional(invdo_TD[23], 0);
TextDrawSetShadow(invdo_TD[23], 0);
TextDrawSetSelectable(invdo_TD[23], true);
TextDrawSetPreviewModel(invdo_TD[23], 0);
TextDrawSetPreviewRot(invdo_TD[23], 0.0000, 0.0000, 0.0000, 1.0000);


}
stock RuletkaPlayer3(playerid) 
{
	ruletka_PTD3[playerid][0] = CreatePlayerTextDraw(playerid, 430.2377, 13.7539, "txd:brgiftslic"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD3[playerid][0], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD3[playerid][0], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD3[playerid][0], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD3[playerid][0], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD3[playerid][0], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD3[playerid][0], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD3[playerid][0], 0);

	ruletka_PTD3[playerid][1] = CreatePlayerTextDraw(playerid, 352.6664, 13.7340, "txd:brgiftsuncar"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD3[playerid][1], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD3[playerid][1], 1); 
	PlayerTextDrawColor(playerid, ruletka_PTD3[playerid][1], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD3[playerid][1], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD3[playerid][1], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD3[playerid][1], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD3[playerid][1], 0);

	ruletka_PTD3[playerid][2] = CreatePlayerTextDraw(playerid, 276.3807, 14.9784, "txd:brgiftsgvip"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD3[playerid][2], 70.0000, 44.0000); 
	PlayerTextDrawAlignment(playerid, ruletka_PTD3[playerid][2], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD3[playerid][2], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD3[playerid][2], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD3[playerid][2], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD3[playerid][2], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD3[playerid][2], 0);

	ruletka_PTD3[playerid][4] = CreatePlayerTextDraw(playerid, 123.9045, 14.6739, "txd:brgiftscash"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD3[playerid][4], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD3[playerid][4], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD3[playerid][4], -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD3[playerid][4], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD3[playerid][4], 4); 
	PlayerTextDrawSetProportional(playerid, ruletka_PTD3[playerid][4], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD3[playerid][4], 0);

	ruletka_PTD3[playerid][3] = CreatePlayerTextDraw(playerid, 200.4284, 15.0650, "txd:brgiftsgun"); // пусто
	PlayerTextDrawTextSize(playerid, ruletka_PTD3[playerid][3], 70.0000, 44.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD3[playerid][3], 1);
	PlayerTextDrawColor(playerid, ruletka_PTD3[playerid][3], -1); 
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD3[playerid][3], 255);
	PlayerTextDrawFont(playerid, ruletka_PTD3[playerid][3], 4);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD3[playerid][3], 0);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD3[playerid][3], 0);

	ruletka_PTD_t3[playerid][1] = CreatePlayerTextDraw(playerid, 389.3807, 44.9925, "BMW_M5_F90"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][1] , 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][1] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][1] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][1] , -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][1] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][1] , 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][1] , 1); 
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][1] , 0);

	ruletka_PTD_t3[playerid][2]  = CreatePlayerTextDraw(playerid, 311.8570, 46.6399, "Gold-Vip"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][2] , 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][2] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][2] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][2] , -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][2] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][2] , 1); 
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][2] , 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][2] , 0);

	ruletka_PTD_t3[playerid][3]  = CreatePlayerTextDraw(playerid, 235.2379, 47.0784, "Случайное оружие"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][3] , 0.1946, 0.7720); 
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][3] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][3] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][3] , -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][3] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][3] , 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][3] , 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][3] , 0); 

	ruletka_PTD_t3[playerid][4]  = CreatePlayerTextDraw(playerid, 157.2856, 48.3346, "до 100000 р."); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][4] , 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][4] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][4] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][4] , -1); 
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][4] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][4] , 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][4] , 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][4] , 0);

	ruletka_PTD_t3[playerid][0]  = CreatePlayerTextDraw(playerid, 466.8570, 45.8340, "Пакет с лицензиями"); // пусто
	PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][0] , 0.1946, 0.7720);
	PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][0] , 0.0000, -24.0000);
	PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][0] , 2);
	PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][0] , -1);
	PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][0] , 255);
	PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][0] , 1);
	PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][0] , 1);
	PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][0] , 0);

    ruletka_PTD_t3[playerid][5] = CreatePlayerTextDraw(playerid, 11.6664, 358.4451, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][5], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][5], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][5], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][5], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][5], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][5], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][5], 0);

    ruletka_PTD_t3[playerid][6] = CreatePlayerTextDraw(playerid, 99.6666, 361.7334, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][6], 0.2506, 1.2391);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][6], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][6], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][6], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][6], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][6], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][6], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][6], 0);

    ruletka_PTD_t3[playerid][7] = CreatePlayerTextDraw(playerid, 47.7141, 388.8739, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][7], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][7], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][7], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][7], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][7], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][7], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][7], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][7], 0);

    ruletka_PTD_t3[playerid][8] = CreatePlayerTextDraw(playerid, 86.9999, 376.6668, "АВТОКЕЙС"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][8], 0.1793, 1.0897);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][8], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][8], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][8], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][8], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][8], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][8], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][8], 0);

    ruletka_PTD_t3[playerid][9] = CreatePlayerTextDraw(playerid, 10.9998, 305.7636, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][9], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][9], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][9], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][9], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][9], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][9], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][9], 0);

    ruletka_PTD_t3[playerid][10] = CreatePlayerTextDraw(playerid, 47.3807, 336.1924, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][10], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][10], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][10], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][10], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][10], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][10], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][10], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][10], 0);

    ruletka_PTD_t3[playerid][11] = CreatePlayerTextDraw(playerid, 99.6666, 308.2222, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][11], 0.2526, 1.2640);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][11], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][11], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][11], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][11], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][11], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][11], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][11], 0);

    ruletka_PTD_t3[playerid][12] = CreatePlayerTextDraw(playerid, 86.9999, 323.1556, "АВТОКЕЙС"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][12], 0.1813, 1.1146);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][12], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][12], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][12], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][12], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][12], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][12], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][12], 0);

   ruletka_PTD_t3[playerid][13] = CreatePlayerTextDraw(playerid,11.3331, 253.0822, "txd:brgiftsuncar"); // пусто
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][13], 70.0000, 44.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][13], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][13], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][13], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][13], 4);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][13], 0);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][13], 0);

    ruletka_PTD_t3[playerid][14] = CreatePlayerTextDraw(playerid,47.7141, 283.5110, "BMW_M5_F90"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][14], 0.1946, 0.7720);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][14], 0.0000, -24.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][14], 2);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][14], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][14], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][14], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][14], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][14], 0);

    ruletka_PTD_t3[playerid][15] = CreatePlayerTextDraw(playerid,99.6666, 256.3703, "Welsi_Developer"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][15], 0.2526, 1.2640);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][15], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][15], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][15], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][15], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][15], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][15], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][15], 0);
 
    ruletka_PTD_t3[playerid][16] = CreatePlayerTextDraw(playerid,86.9999, 271.3037, "АВТОКЕЙС"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][16], 0.1813, 1.1146);
    PlayerTextDrawTextSize(playerid, ruletka_PTD_t3[playerid][16], -9.0000, 0.0000);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][16], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][16], -86);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][16], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][16], 2);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][16], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][16], 0);

    ruletka_PTD_t3[playerid][17] = CreatePlayerTextDraw(playerid, 317.3334, 173.8222, "4"); // пусто
    PlayerTextDrawLetterSize(playerid, ruletka_PTD_t3[playerid][17], 0.2939, 1.3386);
    PlayerTextDrawAlignment(playerid, ruletka_PTD_t3[playerid][17], 1);
    PlayerTextDrawColor(playerid, ruletka_PTD_t3[playerid][17], -1);
    PlayerTextDrawBackgroundColor(playerid, ruletka_PTD_t3[playerid][17], 255);
    PlayerTextDrawFont(playerid, ruletka_PTD_t3[playerid][17], 1);
    PlayerTextDrawSetProportional(playerid, ruletka_PTD_t3[playerid][17], 1);
    PlayerTextDrawSetShadow(playerid, ruletka_PTD_t3[playerid][17], 0);
}

new td_prize3[12][2] = 
{
    {5,6},
    {9,10},
    {11,12},
    {13,14},
    {15,16},
    {17,18},
    {19,20},
    {21,22},
    {23,24},
    {25,26},
    {27,28},
    {29,30}
};

stock LoadPrizeRuletka3()
{ 
    for(new i3;i3 <12;i3++)
    {
        TextDrawSetString(welsirltk_TD3[td_prize3[i3][0]], ruletka_prize3[i3][R_NAME_TXD3]);
        TextDrawSetString(welsirltk_TD3[td_prize3[i3][1]], ruletka_prize3[i3][R_NAME_TEXT3]);
    }
    return 1;
}


public:RunRuletka3(playerid)
{
	animation_player3[playerid] = true;

	if(ruletka_count3[playerid])
	{
		new text3[135];
 
		if(ruletka_count3[playerid] == 15)
		{
			format(text3, sizeof text3, "Поздравляем! Вам выпал %s{FFFF00}.{FFFFFF} Чтобы забрать приз {FFFF00}/roulette3", ruletka_prize3[menu_prize_player3[playerid][2]][R_NAME_PRIZE3]);
			SendClientMessage(playerid, -1, text3);
            GivePrizeRoulette3(playerid, menu_prize_player3[playerid][2]);

			animation_player3[playerid] = false;
			KillTimer(timer_player_ruletka3[playerid]);
			timer_player_ruletka3[playerid] = -1;
			ruletka_count3[playerid]=0;

            format(last_player_ruletka3[0][last_player_name3], 24, last_player_ruletka3[1][last_player_name3]);
            last_player_ruletka3[0][id_ruletka_prize3] = last_player_ruletka3[1][id_ruletka_prize3];
            format(last_player_ruletka3[1][last_player_name3], 24, last_player_ruletka3[2][last_player_name3]);
            last_player_ruletka3[1][id_ruletka_prize3] = last_player_ruletka3[2][id_ruletka_prize3];
            format(last_player_ruletka3[2][last_player_name3], 24, GetPlayerNameEx(playerid));
            last_player_ruletka3[2][id_ruletka_prize3] = menu_prize_player3[playerid][2];

			return 1;
		}
		else
		{
			ruletka_count3[playerid]++;

			new o3 = 5;
			while(o3 > 1)
			{
				o3--;
				PlayerTextDrawSetString(playerid, ruletka_PTD3[playerid][o3], ruletka_prize3[menu_prize_player3[playerid][o3-1]][R_NAME_TXD3]);
				PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][o3], ruletka_prize3[menu_prize_player3[playerid][o3-1]][R_NAME_TEXT3]);
				menu_prize_player3[playerid][o3] = menu_prize_player3[playerid][o3-1];
 
			}

            new array3[] = {2,2,8,8,8,8,8,8,8,8,16,18};
			menu_prize_player3[playerid][0] = random23(array3);
			PlayerTextDrawSetString(playerid, ruletka_PTD3[playerid][0], ruletka_prize3[menu_prize_player3[playerid][0]][R_NAME_TXD3]);
			PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][0], ruletka_prize3[menu_prize_player3[playerid][0]][R_NAME_TEXT3]);
		}
	}
	else
	{
		ruletka_count3[playerid]=1;
	}
 
	return 1;
}

stock UpdateLastPlayerRuletka3(playerid)
{
    for(new i3; i3 < 3;i3++)
    {
        PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][0]], last_player_ruletka3[i3][last_player_name3]);
        PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][1]], ruletka_prize3[last_player_ruletka3[i3][id_ruletka_prize3]][R_NAME_TXD3]);
        PlayerTextDrawSetString(playerid, ruletka_PTD_t3[playerid][last_player_td3[i3][2]], ruletka_prize3[last_player_ruletka3[i3][id_ruletka_prize3]][R_NAME_TEXT3]);
    } 

    return 1;
}
 
random23(array3[], size_w3 = sizeof(array3))
 {
	if(size_w3 < 1) return -1;
	new sum3 = 0, result3 = 0;

	for(new i3 = size_w3 - 1; i3 > -1; i3--)
	{
		sum3 += array3[i3];
		 if(random(sum3) < array3[i3])
		  {
			result3 = i3;
		  } 
	}
		    return result3;
}

stock GivePrizeRoulette3(playerid, prize_id3)
{
    new query3[94]; 
    mysql_format(mysql, query3, sizeof query3, "INSERT INTO roulette_prize (owner, prize) VALUES (%d,%d)", GetPlayerAccountID(playerid), prize_id3);
    mysql_query(mysql, query3, false);

    if(mysql_errno()) SendClientMessage(playerid, -1, "Ошибка в запросе."); 

    return 1;
}

public: CreateTablistRoulette3()
{ 
    new Cache:cache3 = mysql_query(mysql, "SELECT * FROM roulette_prize", true); 

    if(mysql_errno())
    {
        mysql_query(mysql, "CREATE TABLE .`roulette_prize` ( `id` INT NOT NULL AUTO_INCREMENT , `owner` INT NOT NULL , `prize` INT NOT NULL , PRIMARY KEY (`id`)) ENGINE = InnoDB", false);

        if(mysql_errno()) printf("%d error create tablist roulette_prize", mysql_errno());
    }


    cache_delete(cache3);

    cache3 = mysql_query(mysql, "SELECT * FROM accounts WHERE roulette_auto", true);

    if(mysql_errno())
    {
        mysql_query(mysql, "ALTER TABLE `accounts` ADD `roulette_auto` INT NOT NULL DEFAULT '0' AFTER `money`", false);

        if(mysql_errno()) printf("%d error alter roulette_auto", mysql_errno());
    }
 
    cache_delete(cache3);

    return 1;
}

stock GivePlayerCarRoulette3(playerid, modelid3, color_13, color_23) 
{
		new to_player3 = playerid;
		new Float:POS3[3];
		GetPlayerPos(to_player3, POS3[0],POS3[1],POS3[2]);
		new Float: pos_x3 = POS3[0];
		new Float: pos_y3 = POS3[1];
		new Float: pos_z3 = POS3[2];
		new Float: angle3 = 356.7986;
		new query3[220],
			Cache: result3,
			idx3;

		idx3 = GetFreeOwnableCarID();
		SetOwnableCarData(idx3, OC_OWNER_ID, 	GetPlayerAccountID(to_player3));
		SetOwnableCarData(idx3, OC_MODEL_ID, 	modelid3);
		SetOwnableCarData(idx3, OC_COLOR_1, 		color_13);
		SetOwnableCarData(idx3, OC_COLOR_2, 		color_23);
		SetOwnableCarData(idx3, OC_POS_X, 		pos_x3);
		SetOwnableCarData(idx3, OC_POS_Y, 		pos_y3);
		SetOwnableCarData(idx3, OC_POS_Z, 		pos_z3);
		SetOwnableCarData(idx3, OC_ANGLE, 		angle3);
		strmid(g_ownable_car[idx3][OC_NUMBER], "--------", 0, 8, 8);
		SetOwnableCarData(idx3, OC_ALARM, 		false);
		SetOwnableCarData(idx3, OC_KEY_IN, 		true);
		SetOwnableCarData(idx3, OC_CREATE, 		gettime());
		/*new idt3 = GetFreeOwnableCarID();*/
		format(g_ownable_car[idx3][OC_OWNER_NAME], 21, GetPlayerNameEx(playerid));
		//SetVehicleRuNumberPlate(vehicleid, g_ownable_car[idt3][OC_NUMBER], "52");

		// ----------------------------------------------------------------------------------------
 
		new vehicleid3 = CreateVehicle
		(
			GetOwnableCarData(idx3, OC_MODEL_ID),
			GetOwnableCarData(idx3, OC_POS_X),
			GetOwnableCarData(idx3, OC_POS_Y),
			GetOwnableCarData(idx3, OC_POS_Z),
			GetOwnableCarData(idx3, OC_ANGLE),
			GetOwnableCarData(idx3, OC_COLOR_1),
			GetOwnableCarData(idx3, OC_COLOR_2),
			-1,
			0,
			VEHICLE_ACTION_TYPE_OWNABLE_CAR,
			idx3
		);
		if(vehicleid3 != INVALID_VEHICLE_ID)
		{
			ApplyOwnableCarPlate(vehicleid3, idx3);
			SetVehicleParam(vehicleid3, V_LOCK, false);

			SetVehicleData(vehicleid3, V_MILEAGE, 0.0);
		}

		SetPlayerData(to_player3, P_OWNABLE_CAR, vehicleid3);
 
		format
		(
			query3, sizeof query3,
			"INSERT INTO ownable_cars \
			(owner_id,model_id,color_1,color_2,pos_x,pos_y,pos_z,angle,create_time) \
			VALUES \
			('%d','%d','%d','%d','%f','%f','%f','%f','%d')",
			GetPlayerAccountID(to_player3),
			modelid3,
			color_13,
			color_23,
			pos_x3,
			pos_y3,
			pos_z3,
			angle3,
			gettime()
		);
		result3 = mysql_query(mysql, query3, true);
		SetOwnableCarData(idx3, OC_SQL_ID, cache_insert_id());
		cache_delete(result3);
}

CMD:roulette3(playerid) 
{
    new query3[94];
    mysql_format(mysql, query3, sizeof query3, "SELECT * FROM roulette_prize WHERE owner = %d", GetPlayerAccountID(playerid));
    new Cache:cache3 = mysql_query(mysql, query3);

    if(!cache_num_rows()) return SendClientMessage(playerid, -1, "У вас нет призов с рулетки.");

    new rows3, prize_id3,id3, list3[52], dialog3[sizeof list3*10+54];

    strcat(dialog3, "Следующая страница\nПредыдущая страница\n");

    rows3 = cache_num_rows();

    if(rows3 >= 10) rows3 = 10;

    for(new i3,c3=2;i3 < rows3;i3++,c3++) 
    {
        prize_id3 = cache_get_field_content_int(i3, "prize");
        id3 = cache_get_field_content_int(i3, "id");

        format(list3, sizeof list3, "%d. %s\n", i3+1, ruletka_prize3[prize_id3][R_NAME_PRIZE3]);
        strcat(dialog3, list3);
        SetPlayerListitemValue(playerid, c3, prize_id3);
        format(list3, sizeof list3, "rouletteid_%d", c3);
        SetPVarInt(playerid, list3, id3);
    }

    SetPVarInt(playerid, "count_list", 1);
    Dialog(playerid, 12832, DIALOG_STYLE_LIST, "{FF0000}Призы с рулетки", dialog3, "Далее", "Выйти");
    return 1;
} 

public:LoadRuletka3(playerid)
{
    new text3[124];
    mysql_format(mysql, text3, sizeof text3, "SELECT roulette_auto FROM accounts WHERE id=%d", GetPlayerAccountID(playerid));
    new Cache:cache3 = mysql_query(mysql, text3, true);
    if(mysql_errno()) SendClientMessage(playerid, -1, "Ошибка в запросе.");

    player_roulette_bronz3[playerid] = cache_get_row_int(0, 0);
    cache_delete(cache3);
    return 1;
}
