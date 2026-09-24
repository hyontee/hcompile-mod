// закомментированы give_money и также проверка на то есть ли у игрока нужная сумма или нет
// сосали
/*

	Объяснение почему сделано на отдельных таймерах:
	Потому что нужна ежесекундная проверка на то нажата ли кнопка тушения или нет.
	
	Транспорт загарается из-за того, что не прикручен к античиту.
	
	veh_info [ i ] [ v_player_jack ] = INVALID_PLAYER_ID ; - ДОБАВИТЬ В DESTROYVEHICLE
	
	Сделать присвоение очагу команды, чтоб когда команда потушила работа заканчивалась
	
	не забыть переделать "трахопарком"
	
	Не обнуляется ставка в казино
	Камера не возвращается в положение
	Текстдрав игроков, баг
	Цвет числа в рулетке
	
	1. Работа пожарника.
	2. Огороды.
	3. Свадьбы.
	4. Свалка.
	5. Дуэли.
	6. Паром.
	7. Перевозка заключённых в автобусе.
	8. Нарды.
	9. Остановки.
	10. Автоугон.
	11. Переделка команды /gotome.
	12. Такси предприятиями.
	13. Рулетка.
	14. Дроп оружия.
	15. Граффити.
	16. Семейные ежедневные квесты.
	17. /repairkit & /usecanister.
	18. Дурак.
	19. BlackJack.
	20. Автобусы предприятиями.
	21. СМС-сообщения в оффлайне.
	22. Поезда.
	23. /usedrugs.
	24. /plates.
	25. Светофоры.
	26. Динамичная система квестов.
	27. Квесты для гетто и семей.
	28. Система нужд.
	29. Система квестов №2.
	30. Квесты на 23 февраля.
	31. Работа пилота.
	32. /n через ! в чате.
	33. Бейсджампинг.
	34. Каршеринг.
	35. Киллист.
	
	Квесты:
	Можно ли брать сразу две квестовые линии?
	Если нет, то сделать массив под квестовые линии

*/

#include 									<a_samp>
#include 									<streamer>
#include 								 	<sscanf2>
#include 									<Pawn.CMD>
#include                                    <foreach>
#include                                    <a_mysql>
#include 									<crashdetect>

/*

	Настройки компилятора (резать не нужно)

*/

#define CONVERT_TIME_TO_SECONDS     1
#define CONVERT_TIME_TO_MINUTES     2
#define CONVERT_TIME_TO_HOURS       3
#define CONVERT_TIME_TO_DAYS        4
#define CONVERT_TIME_TO_WEEKS       5 
#define CONVERT_TIME_TO_MONTHS      6
#define CONVERT_TIME_TO_YEARS       7

#pragma warning disable 219
#pragma warning disable 239
#pragma warning disable 214

#if __Pawn >= 0x030A && __PawnBuild >= 2
	#pragma option -d3
#endif

new is_gps_used [ MAX_PLAYERS char ] ;
new Iterator:streamed_players[MAX_PLAYERS]<MAX_PLAYERS-1>;
new Iterator:streamed_vehicles[MAX_PLAYERS]<MAX_VEHICLES-1>;
new global_string [ 2048 ] ;

new texture_object, sql_connection ;

#define GetPlayerListitemValue(%0,%1)       g_player_listitem[%0][%1]
#define SetPlayerListitemValue(%0,%1,%2)    g_player_listitem[%0][%1] = %2

#define ClearPlayerListitemValues(%0)       g_player_listitem[%0] = g_listitem_values

#define GetPlayerUseListitem(%0)        g_player_listitem_use[%0]
#define SetPlayerUseListitem(%0,%1)     g_player_listitem_use[%0] = %1

new g_player_listitem[MAX_PLAYERS][32];
new g_listitem_values[sizeof(g_player_listitem[])] = {0, ...};
new g_player_listitem_use[MAX_PLAYERS] = {-1, ...};

#define ofm_formula(%1)	(%1 * 10) // + 1

#define get_player_use_page(%0,%1) 				player_page_use[%0][%1]
#define set_player_use_page(%0,%1,%2) 			player_page_use[%0][%2] = %1
#define clear_player_use_page(%0)           	player_page_use[%0] = page_values

new player_page_use [ MAX_PLAYERS ] [ 2 ] ;
new page_values [ sizeof ( player_page_use [ ] ) ] = { -1, ... } ;

new page_rows [ MAX_PLAYERS ] ;
new page_count [ MAX_PLAYERS ] ;

new player_graffity_timer [ MAX_PLAYERS ] ;

#undef MAX_PICKUPS
#define MAX_PICKUPS 8096
enum _pickup
{
	pick_id,
	pick_model,
	pick_type,
	pick_item,
	Float:pick_pos [ 3 ]
} ;
new pick_info [ MAX_PICKUPS ] [ _pickup ] ;

new Float: car_position [ 10 ] [ 4 ] =
{
	{ 1909.9573, 696.4063, 11.1916, 180.0000 },
	{ 1913.0619, 696.4372, 11.1916, 180.0000 },
	{ 1916.4044, 696.4492, 11.1916, 180.0000 },
	{ 1919.6874, 696.4201, 11.1916, 180.0000 },
	{ 1922.8303, 696.4085, 11.1916, 180.0000 },
	{ 1926.1490, 696.3386, 11.1916, 180.0000 },
	{ 1929.2825, 696.2863, 11.1916, 180.0000 },
	{ 1932.5745, 696.2017, 11.1916, 180.0000 },
	{ 1935.6703, 696.3676, 11.1916, 180.0000 },
	{ 1938.7197, 696.3108, 11.1916, 180.0000 }
} ;

/*new Float: car_position [ 63 ] [ 4 ] = // позиция для такси
{
    { 1098.2705, -1775.6206, 13.0529, 90.0000 },
	{ 1098.1498, -1772.7042, 13.0529, 90.0000 },
	{ 1098.1077, -1769.7441, 13.0529, 90.0000 },
	{ 1098.0928, -1766.6824, 13.0529, 90.0000 },
	{ 1098.0920, -1763.8402, 13.0529, 90.0000 },
	{ 1097.9648, -1760.7302, 13.0529, 90.0000 },
	{ 1097.9645, -1757.9065, 13.0529, 90.0000 },
	{ 1098.0094, -1754.9648, 13.0529, 90.0000 },
	{ 1083.2350, -1755.0084, 13.0529, 90.0000 },
	{ 1083.3218, -1757.9091, 13.0529, 90.0000 },
	{ 1083.3707, -1760.9049, 13.0529, 90.0000 },
	{ 1083.3696, -1763.7285, 13.0529, 90.0000 },
	{ 1083.3336, -1766.7711, 13.0529, 90.0000 },
	{ 1083.2676, -1769.7517, 13.0529, 90.0000 },
	{ 1083.3020, -1772.6119, 13.0529, 90.0000 },
	{ 1083.4365, -1775.5320, 13.0529, 90.0000 },
	{ 1077.3169, -1775.5192, 13.0529, 90.0000 },
	{ 1073.8726, -1777.5721, 13.0529, 90.0000 },
	{ 1077.2628, -1772.6194, 13.0529, 90.0000 },
	{ 1073.8726, -1777.5721, 13.0529, 90.0000 },
	{ 1077.2628, -1772.6194, 13.0529, 90.0000 },

	{ -2508.2500, 740.5756, 34.7375, 180.4798 },
	{ -2503.9812, 740.6825, 34.7375, 180.4798 },
	{ -2499.5913, 740.6326, 34.7375, 180.4798 },
	{ -2495.2673, 740.6896, 34.7375, 180.4798 },
	{ -2491.0234, 741.1223, 34.7375, 180.4798 },
	{ -2486.3469, 740.9117, 34.7375, 180.4798 },
	{ -2482.2432, 740.8872, 34.7375, 180.4798 },
	{ -2477.5454, 740.9311, 34.7375, 180.4798 },
	{ -2473.2512, 740.9790, 34.7375, 180.4798 },
	{ -2468.8638, 741.0806, 34.7375, 180.4798 },
	{ -2464.5466, 740.8967, 34.7375, 180.4798 },
	{ -2460.4028, 740.9771, 34.7375, 180.4798 },
	{ -2455.8398, 740.7689, 34.7375, 180.4798 },
	{ -2451.3259, 741.1013, 34.7375, 180.4798 },
	{ -2447.2571, 741.0834, 34.7375, 180.4798 },
	{ -2442.6453, 741.3891, 34.7375, 180.4798 },
	{ -2438.3496, 740.9813, 34.7375, 180.4798 },
	{ -2434.1946, 741.2097, 34.7375, 180.4798 },
	{ -2429.4775, 741.3766, 34.7375, 180.4798 },
	{ -2425.3308, 741.3918, 34.7375, 180.4798 },
	{ -2420.9595, 740.8506, 34.7375, 180.4798 },

	{ 2284.4583, 2050.2966, 10.4813, 90.0000 },
	{ 2284.3215, 2046.3678, 10.4813, 90.0000 },
	{ 2284.5425, 2042.4016, 10.4813, 90.0000 },
	{ 2284.6375, 2038.6205, 10.4813, 90.0000 },
	{ 2234.6545, 2050.1558, 10.4813, 90.0000 },
	{ 2234.6521, 2046.2699, 10.4813, 90.0000 },
	{ 2234.6763, 2042.4288, 10.4813, 90.0000 },
	{ 2234.7209, 2038.5858, 10.4813, 90.0000 },
	{ 2246.6262, 2038.7054, 10.4813, 90.0000 },
	{ 2246.6323, 2042.5066, 10.4813, 90.0000 },
	{ 2246.6675, 2046.4076, 10.4813, 90.0000 },
	{ 2246.6816, 2050.3484, 10.4813, 90.0000 },
	{ 2296.3579, 2050.3625, 10.4813, 90.0000 },
	{ 2296.3508, 2046.4680, 10.4813, 90.0000 },
	{ 2296.3787, 2042.6273, 10.4813, 90.0000 },
	{ 2296.4404, 2038.7850, 10.4813, 90.0000 },
	{ 2296.4521, 2034.8041, 10.4813, 90.0000 },
	{ 2284.7283, 2034.8003, 10.4813, 90.0000 },
	{ 2246.4722, 2034.8407, 10.4813, 90.0000 },
	{ 2234.7107, 2034.8389, 10.4813, 90.0000 },
	{ 2242.3948, 2027.8302, 10.4813, 90.0000 }
} ;*/

enum
{
	d_none = 0,
	d_job_fireman = 7000,
	d_taxi_mark,
    d_mchs_accept,
    
    d_bizz_auto_invite, // taxi new
    d_bpanel_settings_taxi, // taxi new
    d_bpanel_settings_level, // taxi new
    
    d_job_railway,

	d_quest_actor,

	d_priest_job,
    
    d_healing_accept,
    d_progress,
    
    d_message,
    d_message_input,
    d_phone,
    d_sms,
    
    d_plates,
    d_plates_change,
    
    d_nards_accept,
    
    d_rentcar_quest,
    d_enter_quest,
    d_family_every_quest,
    
    d_gun_up,
    
    d_roulette_bet,
    
    d_service_taxi,
    d_taxi_panel,
    d_rentcar,
    
    // Taxi
    d_offmembers_list,
    d_offmembers_uninvite,
    d_offmembers_pl_menu,
    d_offmembers_pl_menu1,
    //
    // marriage
    d_prist_reg,
    d_prist,
    d_prist_marriage,
    d_prist_marriage_success,
    d_wedding_invite,
	//
    d_jackcar,

    d_buy_seed,
    d_sell_seed,
    d_player_inv,
    
    d_kiss,

    d_trash,
    
    // Taxi
    d_b_panel,
    d_biz_fixcar,
    d_biz_fixcar1,
    d_bpanel_info,
    d_bpanel_setname,
    d_bpanel_fare,
    d_bpanel_com,
    d_bpanel_deputy,
    d_b_deputy,
    d_biz_model,
    
    d_business_invite,
	//
    d_bus_station
}

stock GetString ( param1 [ ], param2 [ ] )
{
	return !strcmp ( param1, param2, false ) ;
}

/*

	Макросы (резать не нужно)
	
*/

#define get_player_listitem_values(%0,%1) 		player_listitem[%0][%1]
#define set_player_listitem_values(%0,%1,%2) 	player_listitem[%0][%1] = %2
#define clear_player_listitem_values(%0)		player_listitem[%0] = listitem_values

#define MAX_POSITION_PVAR   31

new player_listitem [ MAX_PLAYERS ] [ MAX_POSITION_PVAR ] ;
new listitem_values [ sizeof ( player_listitem [ ] ) ] = { 0, ... } ;

#define get_player_use_listitem(%0) 			player_listitem_use[%0]
#define set_player_use_listitem(%0,%1) 			player_listitem_use[%0] = %1
#define clear_player_use_listitem(%0)           player_listitem_use[%0] = -1

new player_listitem_use [ MAX_PLAYERS ] = { -1, ... } ;

#define show_dialog ShowPlayerDialog
#define set_health	SetPlayerHealth
#define set_armour	SetPlayerArmour

/*

	mainmenu

*/

new mainmenu_page [ MAX_PLAYERS ] ;
new bool: use_mainmenu [ MAX_PLAYERS ] ;
new accesories_page [ MAX_PLAYERS ] ;

new Text: mainmenu_td [ 38 ] ;
new PlayerText: mainmenu_ptd [ MAX_PLAYERS ] [ 4 ] ;

new Text: inventory_td [ 5 ] ;
new PlayerText: inventory_ptd [ MAX_PLAYERS ] [ 12 ] ;

new Text: craft_td [ 21 ] ;
new PlayerText: craft_ptd [ MAX_PLAYERS ] [ 7 ] ;

new Text: trade_td [ 5 ] ;
new PlayerText: trade_ptd [ MAX_PLAYERS ] [ 26 ] ;

new Text: house_td [ 2 ] ;
new PlayerText: house_ptd [ MAX_PLAYERS ] [ 4 ] ;

new Text: car_td [ 4 ] ;
new PlayerText: car_ptd [ MAX_PLAYERS ] [ 12 ] ;

new Text: business_td [ 2 ] ;
new PlayerText: business_ptd [ MAX_PLAYERS ] [ 4 ] ;

/*

	Railway

*/

#define job_railway 100

new Float: railway_position [ 4 ] = { 1746.9343, -1957.8477, 13.5469, 269.7454 } ;

new Float: railway_pick_pos [ 3 ] = { 1757.0399, -1943.8184, 13.5689 } ;
new railway_pickup ;

new bool: railway_start [ MAX_PLAYERS ] ;
new railway_car [ MAX_PLAYERS ] = { INVALID_VEHICLE_ID, ... } ;
new railway_player_station [ MAX_PLAYERS char ] ;

new railway_time = 300 ;

enum _railway
{
	r_name [ 24 ],
	Float: r_pos [ 4 ]
} ;
new railway_station [ 5 ] [ _railway ] =
{
    { "Union Station", { 1739.9369, -1953.9978, 13.5469 } },
	{ "Market Station", { 815.3491, -1366.5409, -1.6705 } },
	{ "San Fierro Station", { -1944.0791, 135.2229, 25.7109 } },
	{ "Sand Station", { 1434.3655, 2632.2629, 10.8203 } },
	{ "Las Venturas Station", { 2864.8020, 1289.2068, 10.8203 } }
} ;

new railway_actor [ 5 ] [ 4 ] ;
new Float: railway_unity_actor [ 5 ] [ 4 ] =
{
	{ 1739.9515, -1949.5209, 14.1172, 177.9967 },
	{ 819.3325, -1360.3557, -0.5078, 135.1360 },
	{ -1938.5734, 135.2303, 26.2813, 89.8535 },
	{ 1433.5331, 2623.2097, 11.3926, 2.2318 },
	{ 2857.2888, 1290.8871, 11.3900, 270.0818 }
} ;

/*

	Familys

*/

#define MAX_FAMILY 500
new Iterator:family_vehicles[MAX_FAMILY]<MAX_VEHICLES-1>;
new bool:have_box [ MAX_PLAYERS ] ;
new pick_family_rent ;
new pick_family_box ;
new pick_family_quest ;

/*

	Gun Drops

*/

#define MAX_DROPS 1000
enum _ya_togo_rot_ebal
{
	g_id,
	Float: g_pos [ 3 ],
	g_gun [ 13 ],
	g_ammo [ 13 ],
	g_object,
	Text3D: g_text,
	g_area,
	g_time
}
new gd_info [ MAX_DROPS ] [ _ya_togo_rot_ebal ] ;

new Iterator:gun_drops<MAX_DROPS-1>;

/*

	Graffity
	
*/

enum _graffity
{
	g_id,
	g_object,
	g_member,
	Float: gr_x [ 6 ],
	g_area,
	g_day,
	Text3D: g_text
} ;
new graf_info [ 100 ] [ _graffity ] ;
new count_graffity = 0 ;

/*

	Casino
	
*/

new PlayerText: roulette_ptd [ MAX_PLAYERS ] [ 36 ] ;
new PlayerText: roulette_players_ptd [ MAX_PLAYERS ] [ 26 ] ;

new roulette_used [ MAX_PLAYERS char ] = { 0, ... },
	roulette_bet [ MAX_PLAYERS ] = { 0, ... },
	roulette_number [ MAX_PLAYERS ] = { -1, ... } ;
	
new bool: krupje_player [ MAX_PLAYERS ] = { false, ... } ;

#define MAX_ROU_TABLE 2
new roulette_players [ MAX_ROU_TABLE ] [ 6 ] ;
new drum_object [ MAX_ROU_TABLE ] ;
new Float: drum_object_pos [ MAX_ROU_TABLE ] [ 6 ] =
{
    { 2114.73535, -1777.48816, 13.39370,   0.00000, 0.00000, 0.00000 },
    { 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 }
} ;
new drum_rotation [ MAX_ROU_TABLE ] = { 0, ... } ;
new drum_time [ MAX_ROU_TABLE ] = { -1, ... } ;
new bool: roulette_started [ MAX_ROU_TABLE ] = { false, ... } ;
new Float: roulette_position [ MAX_ROU_TABLE ] [ 3 ] =
{
	{ 2114.93408, -1778.83813, 13.42039 },
	{ 0.0, 0.0, 0.0 }
} ;

new table_casino ; // 1978
new Float: table_casino_pos [ 6 ] = { 2114.93408, -1778.83813, 13.42039,   0.00000, 0.00000, 0.00000 } ;
new player_casino_object [ MAX_PLAYERS ] ;
new player_casino_position [ MAX_PLAYERS ] ;

new Float: attach_to_casino [ 45 ] [ 6 ] =
{
	{ 0.19863, 0.57270, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.14133, 0.42976, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.10912, 0.43858, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.35061, 0.42951, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.13246, 0.26876, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.11798, 0.27757, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.36842, 0.28639, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.14148, 0.11671, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.10001, 0.10764, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.35045, 0.11646, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.12367, -0.02641, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.12678, -0.01759, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.36827, -0.02666, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.11481, -0.18741, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.13564, -0.17859, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.35925, -0.17870, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.12383, -0.33946, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.12662, -0.33064, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.36728, -0.33979, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.13043, -0.49040, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.12567, -0.48684, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.36632, -0.49599, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.11594, -0.63390, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.12471, -0.64304, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.38081, -0.63948, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.10419, -0.80554, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.12376, -0.79925, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.39002, -0.80195, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.10982, -0.95740, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.13344, -0.95217, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.38040, -0.96660, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.09342, -1.09266, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.14731, -1.09953, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.38805, -1.10639, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ -0.10465, -1.25352, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.13608, -1.26038, -0.19672,   0.00000, 0.00000, 0.00000 },
	{ 0.37682, -1.26725, -0.19672,   0.00000, 0.00000, 0.00000 },
	

	{ -0.11178, -1.41319, -0.19672,   0.00000, 0.00000, 0.00000 }, // линия 12 чисел
	{ 0.12903, -1.40946, -0.19672,   0.00000, 0.00000, 0.00000 }, // линия 12 чисел
	{ 0.36983, -1.40573, -0.19672,   0.00000, 0.00000, 0.00000 }, // линия 12 чисел
	{ -0.41959, 0.22734, -0.19672,   0.00000, 0.00000, 0.00000 }, // блок из 12 чисел
	{ -0.39440, -0.37246, -0.19672,   0.00000, 0.00000, 0.00000 }, // блок из 12 чисел
	{ -0.38408, -0.99237, -0.19672,   0.00000, 0.00000, 0.00000 }, // блок из 12 чисел
	{ -0.61691, -0.26204, -0.19672,   0.00000, 0.00000, 0.00000 }, // красное
	{ -0.62229, -0.56266, -0.19672,   0.00000, 0.00000, 0.00000 } // чёрное
} ;

CMD:test_up ( playerid )
{
	if ( player_casino_object [ playerid ] == INVALID_OBJECT_ID )
	{
	    player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ 0 ] [ 0 ],
																				attach_to_casino [ 0 ] [ 1 ],
																				attach_to_casino [ 0 ] [ 2 ],
																				attach_to_casino [ 0 ] [ 3 ],
																				attach_to_casino [ 0 ] [ 4 ],
																				attach_to_casino [ 0 ] [ 5 ] ) ;
		return 1 ;
	}
	
	if ( player_casino_position [ playerid ] == sizeof attach_to_casino - 1 ) player_casino_position [ playerid ] = 0 ;
	else player_casino_position [ playerid ] ++ ;
	
	DestroyObject ( player_casino_object [ playerid ] ) ;
	player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	
	new _c_casino = player_casino_position [ playerid ] ;
    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ _c_casino ] [ 0 ],
																			attach_to_casino [ _c_casino ] [ 1 ],
																			attach_to_casino [ _c_casino ] [ 2 ],
																			attach_to_casino [ _c_casino ] [ 3 ],
																			attach_to_casino [ _c_casino ] [ 4 ],
																			attach_to_casino [ _c_casino ] [ 5 ] ) ;
	return 1 ;
}

CMD:test_down ( playerid )
{
	if ( player_casino_object [ playerid ] == INVALID_OBJECT_ID )
	{
	    player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ 0 ] [ 0 ],
																				attach_to_casino [ 0 ] [ 1 ],
																				attach_to_casino [ 0 ] [ 2 ],
																				attach_to_casino [ 0 ] [ 3 ],
																				attach_to_casino [ 0 ] [ 4 ],
																				attach_to_casino [ 0 ] [ 5 ] ) ;
        return 1 ;
	}

	if ( player_casino_position [ playerid ] == 0 ) player_casino_position [ playerid ] = sizeof attach_to_casino - 1 ;
	else player_casino_position [ playerid ] -- ;

	DestroyObject ( player_casino_object [ playerid ] ) ;
	player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	
	new _c_casino = player_casino_position [ playerid ] ;
    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ _c_casino ] [ 0 ],
																			attach_to_casino [ _c_casino ] [ 1 ],
																			attach_to_casino [ _c_casino ] [ 2 ],
																			attach_to_casino [ _c_casino ] [ 3 ],
																			attach_to_casino [ _c_casino ] [ 4 ],
																			attach_to_casino [ _c_casino ] [ 5 ] ) ;
	return 1 ;
}

CMD:test_right ( playerid )
{
	if ( player_casino_object [ playerid ] == INVALID_OBJECT_ID )
	{
	    player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ 0 ] [ 0 ],
																				attach_to_casino [ 0 ] [ 1 ],
																				attach_to_casino [ 0 ] [ 2 ],
																				attach_to_casino [ 0 ] [ 3 ],
																				attach_to_casino [ 0 ] [ 4 ],
																				attach_to_casino [ 0 ] [ 5 ] ) ;
        return 1 ;
	}

	if ( player_casino_position [ playerid ] >= 40 ) player_casino_position [ playerid ] = player_casino_position [ playerid ] ;
	else player_casino_position [ playerid ] += 3 ;

	DestroyObject ( player_casino_object [ playerid ] ) ;
	player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	
	new _c_casino = player_casino_position [ playerid ] ;
    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ _c_casino ] [ 0 ],
																			attach_to_casino [ _c_casino ] [ 1 ],
																			attach_to_casino [ _c_casino ] [ 2 ],
																			attach_to_casino [ _c_casino ] [ 3 ],
																			attach_to_casino [ _c_casino ] [ 4 ],
																			attach_to_casino [ _c_casino ] [ 5 ] ) ;
	return 1 ;
}

CMD:test_left ( playerid )
{
	if ( player_casino_object [ playerid ] == INVALID_OBJECT_ID )
	{
	    player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ 0 ] [ 0 ],
																				attach_to_casino [ 0 ] [ 1 ],
																				attach_to_casino [ 0 ] [ 2 ],
																				attach_to_casino [ 0 ] [ 3 ],
																				attach_to_casino [ 0 ] [ 4 ],
																				attach_to_casino [ 0 ] [ 5 ] ) ;
        return 1 ;
	}

	if ( player_casino_position [ playerid ] <= 3 ) player_casino_position [ playerid ] = 0 ;
	else player_casino_position [ playerid ] -= 3 ;

	DestroyObject ( player_casino_object [ playerid ] ) ;
	player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	
	new _c_casino = player_casino_position [ playerid ] ;
    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ _c_casino ] [ 0 ],
																			attach_to_casino [ _c_casino ] [ 1 ],
																			attach_to_casino [ _c_casino ] [ 2 ],
																			attach_to_casino [ _c_casino ] [ 3 ],
																			attach_to_casino [ _c_casino ] [ 4 ],
																			attach_to_casino [ _c_casino ] [ 5 ] ) ;
	return 1 ;
}

/*

	// marriage

*/

new Float: pick_marriage_pos [ 3 ] = { 1228.3868, 2049.3115, 656.6091 } ;
new pick_marriage_id ;

new marriage_area ;
new prist_time = -1 ;
new prist_text_id = 0 ;
new prist_success = 0 ;

new count_marriage = 0 ; // mm edit
new pick_enter_prist [ 2 ] ;

new man_marriage = 61, woman_marriage = 91 ;
new man_marriage_price = 100000, woman_marriage_price = 100000 ;
new ring_price = 150000 ;

new bool: priest_player [ MAX_PLAYERS ] ; // prist
new priest_skin = 104 ; // prist
new Float: priest_pos [ 3 ] = { 0.0, 0.0, 0.0 } ; // prist
new priest_pickup ; // prist

new marriage_start = 0 ;

/*

	// Taxi

*/

#define max_taxi_level 10// Taxi
#define bizz_type_taxi 21// Taxi
#define bizz_type_bus 22// Bus
#define bizz_type_carshering 23 // carsh

#define bizz_type_gas 155

#define job_none 0

#define price_fixcar 150// Taxi, Bus

#define MAX_BUSINESS 200
enum _binfo
{
	b_owner_name [ MAX_PLAYER_NAME ],

	b_deputy [ MAX_PLAYER_NAME ],// Taxi
	b_vehicle_id [ 10 ],// Taxi
	b_taxi_model [ 10 ],// Taxi
	b_taxi_level,// Taxi
	b_taxi_licenses,// Taxi
	b_taxi_fare,// Taxi
	
	b_taxi_auto_invite [ 4 ],
	
	b_money,
	b_cash_today,
	b_name [ 32 ],
	b_cost,
	b_close,
	b_mafia,
	b_type,
	
	Float: b_pos [ 3 ]
}
new b_info [ MAX_BUSINESS ] [ _binfo ] ;

#define PAY_TAXI_BOTS ( ( 400 ) + 200 )// Taxi

new day_weeks, _month_count ;// Taxi, месяц 100 процентов, и дни, если нет расчёта

new Iterator:business_taxi[MAX_BUSINESS]<MAX_VEHICLES-1>;// Taxi
new Float:b_taxi_pos [ MAX_BUSINESS ] [ 10 ] [ 4 ] ;// Taxi

new Float: bizz_invite_pos [ 2 ] [ 3 ] =
{
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 }
} ;
new bizz_invite_pickup [ 2 ] ; // taxi new

// По тз снятие доступно в банке, это и есть пикап для банка
new bank_pickup ;
new Float: bank_pick_pos [ 3 ] = { 0.0, 0.0, 0.0 } ;
//

new player_rentcar [ MAX_PLAYERS ] ;

// Taxi
new taxi_cars [ 3 ] [ 2 ] =
{
	{ 420, 100000 },
	{ 421, 150000 },
	{ 422, 250000 }
} ;

// Bus
new bus_cars [ 2 ] [ 2 ] =
{
	{ 431, 100000 },
	{ 437, 150000 }
} ;

// Carshering
new carsh_cars [ 2 ] [ 2 ] =
{
	{ 560, 100000 },
	{ 411, 150000 }
} ;

new Float: actor_pos [ 5 ] [ 4 ] =
{
	{ 1154.5746,-1734.5669,13.7734,182.1747 },
	{ 1166.7562,-1720.0592,13.9064,319.0572 },
	{ 1169.4845,-1705.4664,13.9325,179.4900 },
	{ 1191.7542,-1705.7802,13.5469,188.3525 },
	{ 1209.7383,-1718.7477,13.5469,1.5258 }
} ;
new bool: actor_pos_toggled [ sizeof actor_pos ] = { false, ... } ;

new Float: go_actor_pos [ 5 ] [ 4 ] =
{
	{ 1189.3434,-1332.4421,13.5612,268.8851 },
	{ 1460.7610,-1239.4540,13.5479,88.3333 },
	{ 1197.3964,-1033.3545,31.9297,181.3281 },
	{ 956.4781,-1106.1519,23.7350,269.2086 },
	{ 911.4337,-1371.5961,13.3966,269.5968 }
} ;

new actor_name [ 5 ] [ MAX_PLAYER_NAME ] =
{
	"Boo_Nigga",
	"Ivan_Petrov",
	"Vasya_Pupkin",
	"Sosat_Lezhat",
	"Vse_Huinya"
} ;
//
/*

	Свалка

*/

#define MAX_TRASH 21
enum _trash
{
	t_id,
	t_object,
	t_price,
	t_condition,
	Float: t_pos [ 3 ],
	Text3D: t_text,
	t_time,
	bool: t_status,
	t_area
}
new trash_info [ MAX_TRASH ] [ _trash ] ;

new trash_name [ 3 ] [ 24 ] =
{
	"Холодильник",
	"Монета",
	"Резиновый член"
} ;

new trash_price [ 3 ] =
{
	5000,
	100000,
	100
} ;

new Float: trash_position [ MAX_TRASH ] [ 3 ] =
{
	{ -1804.2178, -1654.1622, 25.6482 },
	{ -1796.0536, -1646.8807, 30.1310 },
	{ -1791.1213, -1652.5201, 32.9367 },
	{ -1782.6066, -1652.8755, 25.9929 },
	{ -1771.5490, -1645.5588, 26.6377 },
	{ -1774.8591, -1635.6569, 26.3190 },
	{ -1852.9032, -1648.9917, 24.6645 },
	{ -1859.9207, -1645.2551, 24.7043 },
	{ -1864.6029, -1650.3954, 24.8397 },
	{ -1860.0151, -1654.1399, 25.8296 },
	{ -1873.6284, -1654.5243, 21.9439 },
	{ -1863.4100, -1664.4049, 21.8285 },
	{ -1812.5618, -1660.8080, 22.2829 },
	{ -1807.1334, -1642.3650, 23.3717 },
	{ -1798.3162, -1636.3868, 23.5237 },
	{ -1791.0653, -1638.8951, 24.9255 },
	{ -1769.1783, -1633.0977, 23.7809 },
	{ -1767.6959, -1648.6250, 23.9300 },
	{ -1777.9025, -1654.6327, 24.2636 },
	{ -1783.5428, -1654.9935, 25.1602 },
	{ -1790.2212, -1665.4286, 24.5853 }
} ;

new used_area [ MAX_PLAYERS ] ;
#define area_type_trash 1
#define area_type_drops 2
#define area_type_graffity 151
#define area_type_tl 4
#define area_type_quest 5

#define MAX_AREAS 1000
enum _areas
{
	a_id,
	a_type
} ;
new area_dynamic_info [ MAX_AREAS ] [ _areas ] ;

stock create_trash ( )
{
    new _random ;
	do
	{
	    _random = random ( sizeof trash_position ) ;
	}
	while ( trash_info [ _random ] [ t_status ] == true ) ;
	
	new _t_random = random ( 3 ) + 1 ;
	trash_info [ _random ] [ t_condition ] = _t_random ;
	trash_info [ _random ] [ t_object ] = random ( sizeof trash_name ) ;
	
	switch ( trash_info [ _random ] [ t_condition ] )
	{
	    case 1: trash_info [ _random ] [ t_price ] = trash_price [ trash_info [ _random ] [ t_object ] ] - floatround ( trash_price [ trash_info [ _random ] [ t_object ] ] / 50 ) ;
	    case 2: trash_info [ _random ] [ t_price ] = trash_price [ trash_info [ _random ] [ t_object ] ] - floatround ( trash_price [ trash_info [ _random ] [ t_object ] ] / 30 ) ;
        case 3: trash_info [ _random ] [ t_price ] = trash_price [ trash_info [ _random ] [ t_object ] ] ;
	}
	
	trash_info [ _random ] [ t_text ] = CreateDynamic3DTextLabel ( "{FFCC00}Мусор\n\n{FFFFFF}Используйте {FFCC00}ALT{FFFFFF} для взаимодействия", -1, trash_position [ _random ] [ 0 ], trash_position [ _random ] [ 1 ], trash_position [ _random ] [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
    trash_info [ _random ] [ t_status ] = true ;
    
    trash_info [ _random ] [ t_area ] = CreateDynamicSphere ( trash_position [ _random ] [ 0 ], trash_position [ _random ] [ 1 ], trash_position [ _random ] [ 2 ], 3.0, -1, -1, -1 ) ;
    area_dynamic_info [ trash_info [ _random ] [ t_area ] ] [ a_type ] = area_type_trash ;
	return 1 ;
}

stock up_trash ( playerid )
{
    if ( used_area [ playerid ] != -1 )
	{
 		if ( area_dynamic_info [ used_area [ playerid ] ] [ a_type ] == area_type_trash )
   		{
			for ( new i = 0 ; i < MAX_TRASH ; i ++ )
			{
			    if ( ! trash_info [ i ] [ t_status ] ) continue ;

			    if ( IsPlayerInRangeOfPoint ( playerid, 2.0, trash_position [ i ] [ 0 ], trash_position [ i ] [ 1 ], trash_position [ i ] [ 2 ] ) )
			    {
					new dialog_string [ 100 + 24 + 9 ], _t_id = trash_info [ i ] [ t_object ] ;
					format ( dialog_string, sizeof dialog_string, "Вы нашли {99cc00}%s\n{14A3FF}1. {FFFFFF}Продать ({99cc00}%d${FFFFFF})\n{14A3FF}2. {FFFFFF}Выкинуть", trash_name [ _t_id ], trash_info [ i ] [ t_price ] ) ;
			        show_dialog ( playerid, d_trash, DIALOG_STYLE_LIST, "{FFCC00}Находка", dialog_string, "Выбрать", "Назад" ) ;
			        
			        set_player_use_listitem ( playerid, i ) ;

			        trash_info [ i ] [ t_status ] = false ;
			        trash_info [ i ] [ t_time ] = random ( 60 ) + 10 ;

			        DestroyDynamicArea ( trash_info [ i ] [ t_area ] ) ;

			        DestroyDynamic3DTextLabel ( trash_info [ i ] [ t_text ] ) ;

			        ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
			        break ;
			    }
			}
		}
	}
	return 1 ;
}

stock trash_minute_timer ( )
{
    for ( new i = 0 ; i < MAX_TRASH ; i ++ )
	{
	    if ( ! trash_info [ _random ] [ t_status ] ) continue ;
	    
	    trash_info [ i ] [ t_time ] -- ;
	    if ( trash_info [ i ] [ t_time ] == 1 ) create_trash ( ) ;
	}
	return 1 ;
}

/*

	Огороды

*/

/*#define MAX_SEED_INFO 3
enum _seed_info
{
	s_price, // покупка
	s_sell_price, // за штуку
	s_object, // объект, который будет расти
	s_time, // время роста
	s_name [ 24 ],
	s_sell_name [ 24 ]
}
new seed_info [ MAX_SEED_INFO ] [ _seed_info ] =
{
	{ 10, 4, 3409, 150, "Картошка", "картошку" },
	{ 12, 7, 673, 150, "Апельсиновое дерево", "апельсины" },
	{ 20, 11, 715, 150, "Яблочное дерево", "яблоки" }
} ;

new pick_buy_seed, pick_sell_seed ;
new Float: pickups_seed_posoton [ 2 ] [ 3 ] =
{
	{ 0.0, 0.0, 0.0 }, // покупка
	{ 0.0, 0.0, 0.0 } // продажа
} ;

#define MAX_HOUSES 300
#define MAX_SEED 25
enum _hinfo
{
	h_garden,
	h_garden_time [ MAX_SEED ],
	h_garden_result [ MAX_SEED ],
	h_garden_object [ MAX_SEED ],
	Text3D: h_garden_text [ MAX_SEED ],
	h_garden_seed [ MAX_SEED ]
}
new h_info [ MAX_HOUSES ] [ _hinfo ] ;

new Float: houses_garden_position [ MAX_HOUSES ] [ MAX_SEED ] [ 3 ] ;
new Iterator:houses_garden<MAX_HOUSES-1>;*/

/* load_user
		new _seed [ 100 ], _sell_seed [ 100 ] ;
		cache_get_field_content ( 0, "u_seed", _seed, sql_connection, sizeof _seed ) ;
		cache_get_field_content ( 0, "u_seed_sell", _sell_seed, sql_connection, sizeof _sell_seed ) ;

		new _scm_seed [ 15 ] ;
		format ( _scm_seed, sizeof _scm_seed, "p<|>a<i>[%d]", MAX_SEED_INFO ) ;
		sscanf ( _seed, _scm_seed, p_info [ playerid ] [ p_seed ] ) ;
		
		format ( _scm_seed, sizeof _scm_seed, "p<|>a<i>[%d]", MAX_SEED_INFO ) ;
		sscanf ( _seed, _scm_seed, p_info [ playerid ] [ seed_sell ] ) ;
		
		
  CREATE TABLE `houses_garden` (
  `id` int(11) NOT NULL,
  `h_id` int(11) NOT NULL,
  `h_slot` int(11) NOT NULL,
  `h_garden_time` int(11) NOT NULL,
  `h_garden_result` int(11) NOT NULL,
  `h_garden_object` int(11) NOT NULL,
  `h_garden_seed` int(11) NOT NULL,
  `h_pos_x` float NOT NULL,
  `h_pos_y` float NOT NULL,
  `h_pos_z` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `houses_garden`
--

INSERT INTO `houses_garden` (`id`, `h_id`, `h_slot`, `h_garden_time`, `h_garden_result`, `h_garden_object`, `h_garden_seed`, `h_pos_x`, `h_pos_y`, `h_pos_z`) VALUES
(1, 1, 0, 150, 0, 0, 0, 1799.39, -2123.48, 13.5469);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `houses_garden`
--
ALTER TABLE `houses_garden`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `houses_garden`
--
ALTER TABLE `houses_garden`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;
*/

/*

	Светофоры

*/

#define MAX_TRAFFIC_LIGHT 4
enum _tl_num
{
	t_status,
	t_new_status,
	t_time,
	Text3D: t_text,
	t_area
}
new tl_info [ MAX_TRAFFIC_LIGHT ] [ _tl_num ] ;

new radar_time [ MAX_PLAYERS ] ;

new Float: tl_pos [ MAX_TRAFFIC_LIGHT ] [ 3 ] =
{
	{ 2633.2876,1305.1232,10.8203 },
	{ 2620.0933,1304.8209,10.8203 },
	{ 2619.5762,1320.8562,10.8203 },
	{ 2634.7454,1321.0590,10.8203 }
} ;

/*

	Nard's

*/

#define MAX_TABLE 2
enum _backgammon
{
	bg_player [ 2 ],
	bg_cell_player [ 24 ],
	bg_move,
	bg_nard_player [ 30 ],
	bg_nard_slot [ 30 ],
	bg_dice [ 4 ],
	bg_player_dice_count,
	bg_nard_count [ 24 ],
	bg_nard_count_id [ 30 ],
	bg_time,
	bg_time_count
}
new bg_info [ MAX_TABLE ] [ _backgammon ] ;

new bool: bg_used [ MAX_PLAYERS ] ;
new bg_used_nard [ MAX_PLAYERS ] ;
new bg_player_table [ MAX_PLAYERS ] ;
new bool: bg_head_nard [ MAX_PLAYERS ] ;
new bool: bg_change_player [ MAX_TABLE ] = { false, ... } ;

new PlayerText: bg_nard_ptd [ MAX_PLAYERS ] [ 30 ] ;
new PlayerText: bg_ptd [ MAX_PLAYERS ] [ 33 ] ;
new PlayerText: bg_dice_ptd_1 [ MAX_PLAYERS ] [ 6 ] ;
new PlayerText: bg_dice_ptd_2 [ MAX_PLAYERS ] [ 6 ] ;

new Float: nard_position [ 2 ] [ 3 ] =
{
    { 1815.3488, -1901.0328, 13.1035 },
    { 0.0, 0.0, 0.0 }
} ;

new Float: dice_td_pos_1 [ 6 ] [ 6 ] [ 2 ] =
{
	{
	    { 313.0000, 184.1733 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 }
	},
	{
	    { 305.1995, 184.1733 },
	    { 320.9005, 184.1733 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 }
	},
	{
	    { 323.6993, 172.7815 },
	    { 304.4993, 194.4694 },
	    { 314.2005, 183.6205 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 }
	},
	{
	    { 304.0994, 174.7727 },
	    { 304.0994, 193.4739 },
	    { 321.8005, 194.0739 },
	    { 322.2005, 174.3727 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 }
	},
	{
	    { 304.0994, 174.7727 },
	    { 304.0994, 193.4739 },
	    { 321.8005, 194.0739 },
	    { 321.8005, 174.5727 },
	    { 312.7000, 184.4733 },
	    { 0.0, 0.0 }
	},
	{
	    { 304.0994, 174.7727 },
	    { 304.0994, 193.4739 },
	    { 321.8005, 194.0739 },
	    { 321.8005, 174.5727 },
	    { 321.7005, 184.4733 },
	    { 304.4994, 184.4733 }
	}
} ;

new Float: dice_td_pos_2 [ 6 ] [ 6 ] [ 2 ] =
{
	{
	    { 313.1000, 227.2799 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 }
	},
	{
	    { 304.8005, 228.4756 },
	    { 320.7015, 228.4756 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 }
	},
	{
	    { 323.6994, 217.5815 },
	    { 312.8994, 228.0348 },
	    { 304.0994, 238.4882 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 }
	},
	{
	    { 321.8005, 217.8754 },
	    { 321.8005, 237.4766 },
	    { 303.8994, 237.4766 },
	    { 304.1994, 217.8754 },
	    { 0.0, 0.0 },
	    { 0.0, 0.0 }
	},
	{
	    { 304.0994, 217.6754 },
	    { 303.6994, 237.9766 },
	    { 321.0004, 237.9766 },
	    { 321.1004, 217.4754 },
	    { 312.3999, 227.5782 },
	    { 0.0, 0.0 }
	},
	{
	    { 304.0994, 217.6754 },
	    { 303.6994, 237.9766 },
	    { 321.0004, 237.9766 },
	    { 321.1004, 217.4754 },
	    { 321.0005, 227.5782 },
	    { 303.9994, 227.5782 }
	}
} ;

new Float: bg_td_pos [ 24 ] [ 2 ] =
{
	{ 113.0000, 44.9910 },
	{ 111.4000, 71.8711 },
	{ 111.8000, 100.2444 },
	{ 111.7998, 128.1199 },
	{ 111.7998, 155.4976 },
	{ 111.7998, 183.3733 },
	{ 111.7998, 213.7377 },
	{ 112.1997, 241.1154 },
	{ 111.7997, 269.4888 },
	{ 112.1997, 296.3688 },
	{ 112.1997, 324.2443 },
	{ 112.1996, 351.1243 }, // left

	{ 507.7998, 349.6288 },
	{ 508.1997, 322.2532 },
	{ 508.1995, 295.3731 },
	{ 508.9996, 267.9953 },
	{ 508.9996, 240.6177 },
	{ 508.1995, 213.7377 },
	{ 508.5996, 181.8800 },
	{ 508.1994, 155.0000 },
	{ 507.7994, 127.6222 },
	{ 507.7994, 99.7465 },
	{ 507.7994, 72.3688 },
	{ 507.7994, 44.9911 } // right
} ;

/*

	bus station

*/

new Float: bus_interior [ 4 ] = { 1520.1796, 833.9318, 833.2777, 180.2648 } ;
new PlayerText: fare_time_PTD [ MAX_PLAYERS ] [ 2 ] ;
new bool: player_station_area [ MAX_PLAYERS ] ;
new station_area [ 42 ] ;
new player_fare [ MAX_PLAYERS ] ;

new Float: station_position [ 42 ] [ 6 ] =
{
	{ 337.55548, -1762.82288, 5.36216,   0.00000, 0.00000, 177.72015 },
	{ 455.17572, -1492.49915, 31.32972,   0.00000, 0.00000, 17.34000 },
	{ 690.27753, -1412.06152, 13.75422,   0.00000, 0.00000, -89.51998 },
	{ 969.15112, -1111.48267, 24.06232,   0.00000, 0.00000, 0.00000 },
	{ 1189.09326, -1377.95508, 13.71585,   0.00000, 0.00000, 181.37994 },
	{ 1336.59216, -1295.38782, 13.79777,   0.00000, 0.00000, 179.94005 },
	{ 1336.23218, -1127.93164, 23.83032,   0.00000, 0.00000, 176.40010 },
	{ 1187.42957, -1745.42883, 13.68104,   0.00000, 0.00000, 0.06000 },
	{ 1422.44263, -1708.75684, 13.79492,   0.00000, 0.00000, 179.04012 },
	{ 1828.03284, -1903.00037, 13.69145,   0.00000, 0.00000, 0.00000 },
	{ 1815.13794, -1658.06567, 13.75855,   0.00000, 0.00000, 179.46004 },
	{ 2075.43408, -1797.17676, 13.75473,   0.00000, 0.00000, -183.36002 },
	{ 2247.15894, -1738.56018, 13.80571,   0.00000, 0.00000, 269.64026 },
	{ 2394.94043, -1978.65515, 13.75165,   0.00000, 0.00000, -90.06001 },
	{ 2720.49658, -1977.18835, 13.75967,   0.00000, 0.00000, -0.12000 },
	{ 2414.62915, -1530.37842, 24.24727,   0.00000, 0.00000, -90.11999 },
	{ 2743.74170, -1503.01563, 30.61832,   0.00000, 0.00000, 0.00000 },
	{ 2743.93359, -1119.48706, 69.79823,   0.00000, 0.00000, 0.24000 },
	{ 2206.24731, -1135.68506, 25.91158,   0.00000, 0.00000, -108.84001 },
	{ 1860.23486, -1084.54443, 24.02297,   0.00000, 0.00000, -179.51991 },
	{ 728.23120, -516.22162, 16.55013,   0.00000, 0.00000, 0.00000 },
	{ 167.22525, -205.41933, 1.78874,   0.00000, 0.00000, 91.49999 },
	{ -2021.94678, -63.97026, 35.53867,   0.00000, 0.00000, 90.42002 },
	{ -2012.67993, 154.70860, 27.64850,   0.00000, 0.00000, 180.23967 },
	{ -2415.07104, -54.94613, 35.57338,   0.00000, 0.00000, 0.00000 },
	{ -2640.04736, 574.46143, 14.84038,   0.00000, 0.00000, 90.24001 },
	{ -1568.13074, 755.13904, 7.39412,   0.00000, 0.00000, -179.57976 },
	{ -1701.02551, 1326.31165, 7.41808,   0.00000, 0.00000, 45.06000 },
	{ -2607.05640, 1336.33813, 7.25884,   0.00000, 0.00000, 135.35989 },
	{ -2515.36011, 2337.27197, 5.16539,   0.00000, 0.00000, 89.81998 },
	{ -1469.03174, 2677.57251, 56.09540,   0.00000, 0.00000, 89.22001 },
	{ -180.73386, 2678.62476, 62.79164,   0.00000, 0.00000, 0.00000 },
	{ 1024.35583, 1806.83447, 11.07575,   0.00000, 0.00000, -89.82004 },
	{ 1143.11951, 1379.77600, 11.04950,   0.00000, 0.00000, 90.06003 },
	{ 2071.24219, 746.88440, 11.04581,   0.00000, 0.00000, -89.76002 },
	{ 2078.79102, 997.17584, 10.97624,   0.00000, 0.00000, 0.00000 },
	{ 2049.09131, 1729.64575, 11.01286,   0.00000, 0.00000, 153.72029 },
	{ 2449.14307, 1979.60925, 11.02882,   0.00000, 0.00000, 88.91994 },
	{ 2793.93604, 1306.78723, 11.08810,   0.00000, 0.00000, -89.63995 },
	{ 2290.64331, 2419.70850, 11.03452,   0.00000, 0.00000, 89.52000 },
	{ 1720.88501, 2189.09351, 11.04211,   0.00000, 0.00000, -179.58006 },
	{ 1550.99170, 2803.73022, 11.04306,   0.00000, 0.00000, 0.00000 }
} ;

stock Float:get_distance_point_to_point ( Float:x1, Float:y1, Float:z1, Float:x2, Float:y2, Float:z2 )
{
    return VectorSize ( x1 - x2, y1 - y2, z1 - z2 ) ;
}

/*

	Jack Car

*/

#define vehicle_type_jackcar 13

#define JACKCAR_PAYMENT 5000
new Float: pick_jackcar [ 4 ] = { 2452.0862, -1973.2715, 13.5539, 191.3806 } ;

new model_ls_skill [ ] = { 412, 419, 439, 466, 467, 474, 475, 516, 517, 518, 534, 535, 536, 542, 549 } ;
new Float: model_ls_pos [ 16 ] [ 4 ] =
{
	{ 2469.4587, -42.0021, 26.0607, 0.0000 },
	{ 2540.0347, 113.0214, 26.1334, 36.4799 },
	{ 2431.9385, 114.2112, 26.1504, -91.8600 },
	{ 666.6171, -461.3816, 16.0219, 89.7000 },
	{ 649.8320, -497.8318, 16.0219, 1.9200 },
	{ 621.7849, -1271.6520, 16.6461, 7.0200 },
	{ 481.3246, -1532.2532, 19.3478, 18.7800 },
	{ 1223.6650, 195.8425, 19.1526, -115.0200 },
	{ -257.8669, -2220.4766, 28.2770, 115.7400 },
	{ -22.9397, -2523.9536, 36.2692, 29.9400 },
	{ -1544.8890, -2746.8755, 48.1683, -188.5202 },
	{ -2168.9207, -2459.8030, 30.2329, 50.6400 },
	{ -2109.3459, -2253.6838, 30.2555, 50.2199 },
	{ 821.2150, -1004.9337, 27.3895, -51.0000 },
	{ 1411.1334, -2208.6750, 13.1393, -178.7401 },
	{ 2521.7122, -941.5631, 82.6735, -77.3400 }
} ;
new bool: ls_place_toggled [ sizeof model_ls_pos ] = { false, ... } ;

new model_sf_skill [ ] = { 400, 405, 421, 426, 445, 458, 507, 550, 551, 555, 558, 559, 560, 565, 579 } ;
new Float: model_sf_pos [ 11 ] [ 4 ] =
{
    { -1850.8821, -177.0662, 8.9845, -89.6400 },
	{ -2152.3313, 192.9203, 34.8202, 0.0000 },
	{ -2294.3708, 396.1367, 34.7040, 45.6600 },
	{ -2083.3899, 793.0553, 69.2157, 0.0000 },
	{ -2437.4890, 1043.9838, 49.9969, -91.9800 },
	{ -2645.4429, 1338.2039, 6.6446, -86.9400 },
	{ -1997.8794, 1278.9277, 6.8025, -91.2600 },
	{ -2814.8792, -188.8522, 6.7996, 0.0000 },
	{ -2531.7402, -602.2333, 132.2073, -179.9400 },
	{ -2396.0684, -594.3329, 132.2573, 125.3400 },
	{ -1872.7783, -796.0540, 31.6128, 90.4200 }

} ;
new bool: sf_place_toggled [ sizeof model_sf_pos ] = { false, ... } ;

new model_lv_skill [ ] = { 402, 424, 429, 477, 490, 506, 562, 580 } ;
new Float: model_lv_pos [ 14 ] [ 4 ] =
{
    { 1144.8507, 1976.0198, 10.4591, 178.7401 },
	{ 1542.7141, 2258.3208, 10.4148, 181.0198 },
	{ 1623.7616, 2007.4738, 10.4201, -90.3600 },
	{ 2186.5522, 2004.1707, 10.4034, 90.5400 },
	{ 2523.2449, 2006.5997, 10.4490, 0.0000 },
	{ 2588.0483, 2078.1582, 10.4523, 90.7800 },
	{ 2610.2866, 2179.0330, 10.4089, 179.4000 },
	{ 821.2150, -1004.9337, 27.3895, -51.0000 },
	{ 1411.1334, -2208.6750, 13.1393, -178.7401 },
	{ 2521.7122, -941.5631, 82.6735, -77.3400 },
	{ 1752.0625, 722.6357, 10.4194, 0.0000 },
	{ -181.4246, 2720.3574, 62.3064, 0.0000 },
	{ -267.6354, 2754.9146, 62.0185, -108.5400 },
	{ -519.4479, 2617.5491, 53.0460, -90.7801 }
} ;
new bool: lv_place_toggled [ sizeof model_lv_pos ] = { false, ... } ;

new model_premium_skill [ ] = { 411, 415, 429, 451, 480, 494, 495, 541 } ;
new Float: model_premium_pos [ 12 ] [ 4 ] =
{
	{ -587.2247, -1075.8961, 23.1558, -124.3200 },
	{ -569.5085, -1475.7522, 10.2727, 37.1400 },
	{ -1033.6262, -2147.6409, 33.8925, 58.9200 },
	{ -2166.0723, -2268.7922, 30.2475, -217.6799 },
	{ -2481.7688, -184.0850, 25.2656, 142.8000 },
	{ -2089.1538, 60.3254, 34.4598, 107.9400 },
	{ -1956.4321, 584.7004, 34.7372, 180.4200 },
	{ -742.9158, 1563.9749, 26.6611, 46.0800 },
	{ -518.1401, 1974.5366, 60.0709, -86.3400 },
	{ 681.5020, 1946.7673, 5.1941, -179.5199 },
	{ 2133.0886, 2820.8682, 10.4296, 179.8797 },
	{ 2841.9919, 2028.9027, 10.4111, -179.9399 }
} ;
new bool: premium_place_toggled [ sizeof model_premium_pos ] = { false, ... } ;

new vehicle_name [ 212 ] [ 32 ] =
{
	"Landstalker","Bravura","Buffalo","Linerunner","Pereniel","Sentinel","Dumper","Firetruck","Trashmaster","Stretch","Manana","Infernus",
	"Voodoo","Pony","Mule","Cheetah","Ambulance","Leviathan","Moonbeam","Esperanto","Taxi","Washington","Bobcat","Mr Whoopee","BF Injection",
	"Hunter","Premier","Enforcer","Securicar","Banshee","Predator","Bus","Rhino","Barracks","Hotknife","Trailer","Previon","Coach","Cabbie",
	"Stallion","Rumpo","RC Bandit","Romero","Packer","Monster","Admiral","Squalo","Seasparrow","Pizzaboy","Tram","Trailer","Turismo","Speeder",
	"Reefer","Tropic","Flatbed","Yankee","Caddy","Solair","Berkley's RC Van","Skimmer","PCJ-600","Faggio","Freeway","RC Baron","RC Raider",
	"Glendale","Oceanic","Sanchez","Sparrow","Patriot","Quad","Coastguard","Dinghy","Hermes","Sabre","Rustler","ZR3 50","Walton","Regina",
	"Comet","BMX","Burrito","Camper","Marquis","Baggage","Dozer","Maverick","News Chopper","Rancher","FBI Rancher","Virgo","Greenwood",
	"Jetmax","Hotring","Sandking","Blista","Police Maverick","Boxville","Benson","Mesa","RC Goblin","Hotring A","Hotring B",
	"Bloodring Banger","Rancher","Super GT","Elegant","Journey","Bike","Mountain Bike","Beagle","Cropdust","Stunt","Tanker","RoadTrain",
	"Nebula","Majestic","Buccaneer","Shamal","Hydra","FCR-900","NRG-500","HPV1000","Cement Truck","Tow Truck","Fortune","Cadrona","FBI Truck",
	"Willard","Forklift","Tractor","Combine","Feltzer","Remington","Slamvan","Blade","Freight","Streak","Vortex","Vincent","Bullet","Clover",
	"Sadler","Firetruck","Hustler","Intruder","Primo","Cargobob","Tampa","Sunrise","Merit","Utility","Nevada","Yosemite","Windsor","Monster A",
	"Monster B","Uranus","Jester","Sultan","Stratum","Elegy","Raindance","RC Tiger","Flash","Tahoma","Savanna","Bandito","Freight","Trailer",
	"Kart","Mower","Duneride","Sweeper","Broadway","Tornado","AT-400","DFT-30","Huntley","Stafford","BF-400","Newsvan","Tug","Trailer A","Emperor",
	"Wayfarer","Euros","Hotdog","Club","Trailer B","Trailer C","Andromada","Dodo","RC Cam","Launch","Police Car","Police Car",
	"Police Car","Police Ranger","Picador","S.W.A.T.","Alpha","Phoenix","Glendale","Sadler","L Trailer A","L Trailer B",
	"Stair Trailer","Boxville","Farm Plow","U Trailer"
} ;

/*

	SHIP

*/

new PlayerText: ship_time_PTD [ MAX_PLAYERS ] [ 2 ] ;

new start_ship = 180 ; // FSIN
new bool: front_ship = false ;
new Text3D: ship_label [ 2 ] ;
new ship_player_id [ 3 ] ;
new Float: ship_pick_pos [ 2 ] [ 3 ] =
{
	{ 2879.9106, -2170.7336, 3.4386 },
	{ 2324.2783, 553.3986, 7.7813 }
} ;
new Float: ship_in_pos [ 3 ] = { 4979.2622, 965.9862, 10.5356 } ;

new ship_object ;

enum _ship
{
	s_model,
	Float: s_pos [ 6 ]
}

new ship_info [ 3 ] [ _ship ] =
{
	{ 10230, { 2959.53955, -2457.45386, 9.77490,   0.00000, 0.00000, -90.00000 } },
	{ 10230, { 3099.71753, 932.76355, 7.80711,   0.00000, 0.00000, 90.00002 } },
	{ 10230, { 2960.8826, -2246.6653, 9.7749, 0.0000, 0.0000, -90.0000 } }
} ;

new Float: ship_vehicle_pos [ 3 ] [ 4 ] =
{
	{ 4979.2622, 965.9862, 10.5356, 351.8491 },
	{ 4997.2861, 949.8221, 10.5258, 70.6367 },
	{ 5006.3159, 977.6752, 10.5259, 322.9788 }
} ;

new Float: earth_vehicle_pos [ 2 ] [ 3 ] [ 4 ] =
{
	{
	    { 2877.8513, -2155.2913, 3.6207, 82.5930 },
		{ 2865.7761, -2168.2495, 2.6312, 57.4145 },
		{ 2858.5400, -2175.8926, 2.8573, 32.6445 }
	},
	{
	   	{ 2334.6426, 570.8992, 7.3572, 0.1769 },
		{ 2321.0654, 578.8976, 7.4869, 87.8990 },
		{ 2304.6719, 565.9542, 7.4868, 159.1527 }
	}
} ;

#define vehicle_type_fire 12

new seller_id [ MAX_PLAYERS ],
	buyer_id [ MAX_PLAYERS ] ;
	
stock clear_sell_params ( playerid, targetid )
{
    buyer_id [ targetid ] =
    seller_id [ playerid ] = INVALID_PLAYER_ID ;
	return 1 ;
}

enum _p_info
{
	salary,
	job,
	name [ 32 ],
	level,
	drive_lic,
	
	mchs_id,
	fire_timer,
	fire_id,
	fire_icon,
	bool: fire_start,
	fire_cooldown,
	bool: fire_fill,
	fire_skill,
	fire_count,
	
	bool: ship_active,
	ship_car_id,
	ship_in_car,
	seat_id,
	
	c_vehicle,
	c_icon,
	c_pos_toggled,
	jackcar_skill,
	urgent_cooldown,
	c_time,
	
	fare_time,
	station_id,
	
	//seed [ MAX_SEED_INFO ],
	//seed_sell [ MAX_SEED_INFO ],
	
	// marriage
	marriage,
	marriage_name [ MAX_PLAYER_NAME ],
	//
	sex,
	
	jacked,
	wanted,
	
	house,
	
	main_timer,
	id,
	
	business,
	// Taxi
	deputy,
	taxi_cooldown,
	taxi_accept_cooldown,
	bool: taxi_accept [ 3 ],
	bool: taxi_okey,
	taxi_actor,
	taxi_actor_id [ 3 ],
	taxi_actor_name [ 3 ],
	taxi_okey_actor,
	
	day_money,
	week_money,
	month_money,
	all_money,
	taxi_order,
	Float: millage,
	//
	// marriage
	marriage_today,
	wedding,
	marriage_ring,
	//
	day_graffity,
	
	family_everyday_quest [ 2 ],
	family_everyday_progress [ 2 ],
	family_everyday_car,
	
	family,
	back_timer,
	taxi_skill,
	
	number,
	
	money,
	
	p_disease,
	drugs,
	p_disease_cooldown,
	p_drugs_healing,
	send_crack,
	
	family_quest,
	family_progress,
	family_status,
	
	getto_quest,
	getto_progress,
	getto_status,
	
	gettime_cooldown,
	gettime_week_cooldown,
	gettime_month_cooldown,
	
	needs [ 3 ],
	kpz_time, // FSIN
	jail
}
new p_info [ MAX_PLAYERS ] [ _p_info ] ;

new Float: kpz_3d_text_pos [ 3 ] [ 3 ] = // FSIN
{
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 }
} ;

new Text3D:kpz_3d_text [ 3 ] ;// FSIN
new count_player_kpz [ 3 ] ;// FSIN

/*

	Quests
	
*/

enum
{
	family_line = 1,
	getto_line
} ;

enum _qactor
{
	q_name [ 12 ],
	q_type,
	q_skin,
	Float:q_pos [ 4 ]
} ;
new quest_actor [ 2 ] [ _qactor ] =
{
	{ "Дейв", 1, 293, { 1736.7134, -1752.9368, 13.5068, 2.9285 } },
	{ "Луи", 2, 242, { 1731.7627, -1752.8175, 13.5073, 2.9285 } }
} ;

enum _quest
{
	q_name [ 32 ],
	q_text [ 144 ],
	q_rewards [ 24 ]
} ;

enum _quest_rewards
{
	r_exp,
	r_money,
	r_canister,
	r_drugs,
	r_patrons,
	r_guns
} ;

new f_quest_info [ 11 ] [ _quest ] =
{
	{ "Начало", "Вступить в семью.", "2 exp + 5000$" },
	{ "Захватчик", "Принять участие в захвате корабля 30 раз.", "25000$" },
	{ "Добытчик", "Заработать для семьи 2.000 рейтинга.", "45000$" },
	{ "Путь к успеху", "Обменять в семейном обменнике 600 семейных монет.", "60000$" },
	{ "Доверенный", "Принять в семью 60 человек.", "2 exp + 5000$" },
	{ "Семейный тестдрайв", "Сдать в семейный автопарк 2 автомобиля.", "15000$" },
	{ "Вклад в общее дело", "Положить в сейф 5000пт дигла.", "30000$" },
	{ "Геймер", "Принять участие в мероприятии компьютерного клуба 20 раз.", "40000$" },
	{ "Свой механик", "Заправить 50 автомобилей из автопарка семьи.", "30000$" },
	{ "Безумец", "Убить на корабле 50 человек.", "40000$" },
	{ "Грибник", "Собрать 500 грибов.", "3 exp + 35000$" }
} ;

new f_quest_rewards [ 11 ] [ _quest_rewards ] =
{
	{ 2, 5000, 0, 0, 0, 0 },
	{ 0, 25000, 0, 0, 0, 0 },
	{ 0, 45000, 0, 0, 0, 0 },
	{ 0, 60000, 0, 0, 0, 0 },
	{ 2, 5000, 0, 0, 0, 0 },
	{ 0, 15000, 0, 0, 0, 0 },
	{ 0, 30000, 0, 0, 0, 0 },
	{ 0, 40000, 0, 0, 0, 0 },
	{ 0, 30000, 10, 0, 0, 0 },
	{ 0, 40000, 0, 0, 500, 0 },
	{ 3, 35000, 0, 0, 0, 0 }
} ;

new g_quest_info [ 15 ] [ _quest ] =
{
	{ "Свой человек", "Вступить в любую банду.", "3 exp + 5000$" },
	{ "Любитель природы №1", "Купить 500гр семян в притоне.", "50000$" },
	{ "Воровство", "Украсть 30 раз личку с базы военной.", "30000$" },
	{ "Начинающий бизнесмен", "Перегнать 50 автомобилей.", "35000$" },
	{ "Дуэлянт", "Победить в 20 дуэлях.", "25000$" },
	{ "Свой среди чужих", "Добыть 10 раз военную форму.", "40000$" },
	{ "Доверенное лицо", "Выгрузить на склад банды 200.000 материалов.", "65000$" },
	{ "Бесстрашный", "Убить 50 военных на территории армии.", "20000$" },
	{ "Захватчик", "Поучаствовать на 30-ти войнах за территорию.", "40000$" },
	{ "Шальная пуля", "Сделать 100 убийств на каптах.", "50000$" },
	{ "Любитель природы №2", "Посадить 500гр семян.", "5 exp + 20000$" },
	{ "Наркоторговец", "Продать 1000гр наркоты.", "30000$" },
	{ "Вредные привычки", "Прокачать наркозависимость до 7.000 оч.", "55000$" },
	{ "Ограбление", "Ограбить 50 домов.", "35000$" },
	{ "Уличная отметка", "Закрасить 100 граффити.", "3 exp + 45000$" }
} ;

new g_quest_rewards [ 15 ] [ _quest_rewards ] =
{
	{ 3, 5000, 0, 0, 0, 0 },
	{ 0, 50000, 0, 0, 0, 0 },
	{ 0, 30000, 0, 0, 500, 1000 },
	{ 0, 35000, 0, 0, 0, 0 },
	{ 0, 25000, 0, 0, 0, 0 },
	{ 0, 40000, 0, 0, 0, 0 },
	{ 0, 65000, 0, 0, 0, 0 },
	{ 0, 20000, 0, 0, 0, 0 },
	{ 0, 40000, 0, 0, 0, 0 },
	{ 0, 50000, 0, 0, 0, 0 },
	{ 5, 20000, 0, 0, 0, 0 },
	{ 0, 30000, 0, 100, 0, 0 },
	{ 0, 55000, 0, 0, 0, 0 },
	{ 0, 35000, 0, 0, 0, 0 },
	{ 3, 45000, 0, 0, 0, 0 }
} ;

stock give_quest_rewards ( playerid, quest_id, line_type )
{
    if ( family_line == line_type )
    {
		p_info [ playerid ] [ exp ] += g_quest_rewards [ quest_id ] [ r_exp ] ;
		p_info [ playerid ] [ canister ] += g_quest_rewards [ quest_id ] [ r_canister ] ;
		p_info [ playerid ] [ drugs ] += g_quest_rewards [ quest_id ] [ r_drugs ] ;
		p_info [ playerid ] [ crim_guns ] += g_quest_rewards [ quest_id ] [ r_guns ] ;
		p_info [ playerid ] [ crim_ammo ] += g_quest_rewards [ quest_id ] [ r_patrons ] ;
		give_money ( playerid, g_quest_rewards [ quest_id ] [ r_money ] ) ;
	}
	else if ( getto_line == line_type )
    {
		p_info [ playerid ] [ exp ] += g_quest_rewards [ quest_id ] [ r_exp ] ;
		p_info [ playerid ] [ canister ] += g_quest_rewards [ quest_id ] [ r_canister ] ;
		p_info [ playerid ] [ drugs ] += g_quest_rewards [ quest_id ] [ r_drugs ] ;
		p_info [ playerid ] [ crim_guns ] += g_quest_rewards [ quest_id ] [ r_guns ] ;
		p_info [ playerid ] [ crim_ammo ] += g_quest_rewards [ quest_id ] [ r_patrons ] ;
		give_money ( playerid, g_quest_rewards [ quest_id ] [ r_money ] ) ;
    }
	return 1 ;
}

// Как использовать:
// if ( p_info [ playerid ] [ getto_status ] == 1 ) checking_getto_quest_progress ( playerid, p_info [ playerid ] [ getto_quest ], /* сюда число, которое будет прибавлять прогресс */ )

stock checking_quest_progress ( playerid, quest_id, amount_plus, line_type )
{
    if ( family_line == line_type )
	{
		if ( p_info [ playerid ] [ family_quest ] != quest_id ) return 1 ; // Такой вариант проверки или в выдаче сразу проверять на нужный нам квест активен или нет
		if ( p_info [ playerid ] [ family_status ] == 1 )
		{
		    static const _quest_progress [ ] =
			{
				1,
				30,
				2000,
				600,
				60,
				2,
				5000,
				20,
				50,
				50,
				500
			} ;

			p_info [ playerid ] [ family_progress ] += amount_plus ;

			if ( p_info [ playerid ] [ family_progress ] > _quest_progress [ quest_id ] )
			{
				if ( p_info [ playerid ] [ family_quest ] >= sizeof _quest_progress - 1 )
				{
				    SendClientMessage ( playerid, 0xFFCC00FF, !"Вы закончили квестовую линию." ) ;

				    p_info [ playerid ] [ family_quest ] = sizeof _quest_progress ;

				    update_int_sql ( playerid, "u_family_quest", p_info [ playerid ] [ family_quest ] ) ;
				    p_info [ playerid ] [ getto_status ] = 0 ;
					update_int_sql ( playerid, "u_family_status", p_info [ playerid ] [ family_status ] ) ;
					p_info [ playerid ] [ getto_progress ] = 0 ;
					update_int_sql ( playerid, "u_family_progress", p_info [ playerid ] [ family_progress ] ) ;
				}
				else
				{
					new scm_string [ 63 + 32 ] ;
					format ( scm_string, sizeof scm_string, "Задание успешно выполнено. Ваша награда: {FFCC00}%s{FFFFFF}.", f_quest_info [ quest_id + 1 ] [ q_rewards ] ) ;
					SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

					format ( scm_string, sizeof scm_string, "Следующее задание: {FFCC00}%s{FFFFFF}.", f_quest_info [ quest_id + 1 ] [ q_name ] ) ;
					SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

					p_info [ playerid ] [ family_quest ] ++ ;

					update_int_sql ( playerid, "u_family_quest", p_info [ playerid ] [ family_quest ] ) ;
					p_info [ playerid ] [ family_status ] = 1 ;
					update_int_sql ( playerid, "u_family_status", p_info [ playerid ] [ family_status ] ) ;
					p_info [ playerid ] [ family_progress ] = 0 ;
					update_int_sql ( playerid, "u_family_progress", p_info [ playerid ] [ family_progress ] ) ;
				}
			}
		}
	}
	else if ( getto_line == line_type )
	{
		if ( p_info [ playerid ] [ getto_quest ] != quest_id ) return 1 ; // Такой вариант проверки или в выдаче сразу проверять на нужный нам квест активен или нет
		if ( p_info [ playerid ] [ getto_status ] == 1 )
		{
		    static const _quest_progress [ ] =
			{
				1,
				500,
				30,
				50,
				20,
				10,
				200000,
				50,
				30,
				100,
				500,
				1000,
				7000,
				50,
				100
			} ;

			p_info [ playerid ] [ getto_progress ] += amount_plus ;

			if ( p_info [ playerid ] [ getto_progress ] > _quest_progress [ quest_id ] )
			{
				if ( p_info [ playerid ] [ getto_quest ] >= sizeof _quest_progress - 1 )
				{
				    SendClientMessage ( playerid, 0xFFCC00FF, !"Вы закончили квестовую линию." ) ;

				    p_info [ playerid ] [ getto_quest ] = sizeof _quest_progress ;

				    update_int_sql ( playerid, "u_getto_quest", p_info [ playerid ] [ getto_quest ] ) ;
				    p_info [ playerid ] [ getto_status ] = 0 ;
					update_int_sql ( playerid, "u_getto_status", p_info [ playerid ] [ getto_status ] ) ;
					p_info [ playerid ] [ getto_progress ] = 0 ;
					update_int_sql ( playerid, "u_getto_progress", p_info [ playerid ] [ getto_progress ] ) ;
				}
				else
				{
					new scm_string [ 63 + 32 ] ;
					format ( scm_string, sizeof scm_string, "Задание успешно выполнено. Ваша награда: {FFCC00}%s{FFFFFF}.", g_quest_info [ quest_id + 1 ] [ q_rewards ] ) ;
					SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

					format ( scm_string, sizeof scm_string, "Следующее задание: {FFCC00}%s{FFFFFF}.", g_quest_info [ quest_id + 1 ] [ q_name ] ) ;
					SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

					p_info [ playerid ] [ getto_quest ] ++ ;

					update_int_sql ( playerid, "u_getto_quest", p_info [ playerid ] [ getto_quest ] ) ;
					p_info [ playerid ] [ getto_status ] = 1 ;
					update_int_sql ( playerid, "u_getto_status", p_info [ playerid ] [ getto_status ] ) ;
					p_info [ playerid ] [ getto_progress ] = 0 ;
					update_int_sql ( playerid, "u_getto_progress", p_info [ playerid ] [ getto_progress ] ) ;
				}
			}
		}
	}
	return 1 ;
}

CMD:progress ( playerid )
{
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ], _count_id = 1 ;
	if ( p_info [ playerid ] [ getto_quest ] != -1 && p_info [ playerid ] [ getto_quest ] < sizeof g_quest_info )
	{
		format ( line_string, sizeof line_string, "{FFCC00}%d. {FFFFFF}Настоящий гангстер [%d/%d]\n", _count_id, p_info [ playerid ] [ getto_quest ], sizeof g_quest_info ) ;
		strcat ( global_string, line_string ) ;
		
		SetPlayerListitemValue ( playerid, _count_id, getto_line ) ;
		
		_count_id ++ ;
	}
	if ( p_info [ playerid ] [ family_quest ] != -1 && p_info [ playerid ] [ family_quest ] < sizeof f_quest_info )
	{
		format ( line_string, sizeof line_string, "{FFCC00}%d. {FFFFFF}Семейные узы [%d/%d]\n", _count_id, p_info [ playerid ] [ family_quest ], sizeof f_quest_info ) ;
		strcat ( global_string, line_string ) ;
		
		SetPlayerListitemValue ( playerid, _count_id, family_line ) ;
		
		_count_id ++ ;
	}
	show_dialog ( playerid, d_progress, DIALOG_STYLE_LIST, "{FFCC00}Прогресс заданий", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

/*



*/

new is_drug_effect [ MAX_PLAYERS char ] ;

new actor_taxi_time [ MAX_PLAYERS char ] ;
new call_taxi [ MAX_PLAYERS char ] ;

stock clear_taxi_player ( playerid )
{
	p_info [ playerid ] [ taxi_cooldown ] =
	p_info [ playerid ] [ taxi_accept_cooldown ] = 0 ;
	
	p_info [ playerid ] [ taxi_okey ] =
	p_info [ playerid ] [ taxi_accept ] [ 0 ] =
	p_info [ playerid ] [ taxi_accept ] [ 1 ] =
	p_info [ playerid ] [ taxi_accept ] [ 2 ] = false ;
	p_info [ playerid ] [ taxi_okey_actor ] =
	p_info [ playerid ] [ taxi_actor ] = -1 ;
	
	call_taxi { playerid } = 0 ;
	
	actor_taxi_time { playerid } = 0 ;
	return 1 ;
}

enum _p_t_info
{
    pTaxiTurn [ 2 ],
	bool: pTaxiGoing,
	Float: pTaxiStart,
	pTaxiPass,
	taxi_assement,
	Float: p_pos [ 3 ],
	pickup_id,
	
	save_taxi_fare, // taxi 100
	
	p_gun_slot [ 13 ],
	p_gun_ammo [ 13 ],
	
	graffity
}
new p_t_info [ MAX_PLAYERS ] [ _p_t_info ] ;

new teleport_tick [ MAX_PLAYERS ] ;
new Float: last_coords [ MAX_PLAYERS ] [ 4 ] ;

stock give_money ( playerid, amount )
{
	p_info [ playerid ] [ money ] += amount;
	GivePlayerMoney ( playerid, amount ) ;
	update_int_sql ( playerid, "u_money", p_info [ playerid ] [ money ] ) ;

	if ( amount > 0 )
	{
		new t_string [ 46 ] ;
		format ( t_string, sizeof t_string, "~n~~n~~n~~n~~n~~n~~n~~n~~g~ +%d$", amount ) ;
		GameTextForPlayer ( playerid, t_string, 3000, 3 ) ;
	}
	else
	{
	    new t_string [ 46 ] ;
		format ( t_string, sizeof t_string, "~n~~n~~n~~n~~n~~n~~n~~n~~r~ %d$", amount ) ;
		GameTextForPlayer ( playerid, t_string, 3000, 3 ) ;
	}
	return 1 ;
}

//========================================================================================================================================
#include 									"modules/other/m_needs.pwn"
//========================================================================================================================================

new Iterator:logged_players<MAX_PLAYERS-1>;

#define vehicle_type_taxi 15
#define vehicle_type_bus 16
#define vehicle_type_carshering 17

enum _veh
{
	v_id,
	v_vehicle,
	Text3D: fire_car,
	fire_car_litrs,
	
	v_player_jack,
	
	v_type,
	v_owner,
	Float: v_fuel,
	bool: v_locked,
	v_model,
	v_driver,
	v_player_driver,
	Text3D: v_label,
	Float: v_pos [ 4 ],
	v_color [ 2 ],
	Float: v_millage,
	Float: v_now_pos [ 3 ],
	v_cargo,
	
	v_plate [ 12 ]
}
new veh_info [ MAX_VEHICLES ] [ _veh ] ;

new Iterator:player_vehicles[MAX_PLAYERS]<MAX_VEHICLES-1>;

//========================================================================================================================================
#include 									"modules/other/m_fireman.pwn"
//========================================================================================================================================

CMD:plates ( playerid )
{
	if ( Iter_Count(player_vehicles[playerid]) < 2 ) return 1 ;
	
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ], veh_slot ;
	foreach(new veh_id: player_vehicles[playerid])
	{
		format ( line_string, sizeof line_string, "{FFFFFF}%s, Номера: %s\n", vehicle_name [ veh_info [ veh_id - 1 ] [ v_model ] - 400 ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
		strcat ( global_string, line_string ) ;

		SetPlayerListitemValue ( playerid, veh_slot, veh_id ) ;
		veh_slot ++ ;
	}
	show_dialog ( playerid, d_plates, DIALOG_STYLE_LIST, "{FFCC00}Номера", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock show_change_plate ( playerid )
{
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ], veh_slot ;
	foreach(new veh_id: player_vehicles[playerid])
	{
		format ( line_string, sizeof line_string, "{FFFFFF}%s, Номера: %s %s\n", vehicle_name [ veh_info [ veh_id - 1 ] [ v_model ] - 400 ], veh_info [ veh_id - 1 ] [ v_plate ], ( veh_id == get_player_use_listitem ( playerid ) ) ? ( "{828282}* Вы выбрали эти номера" ) : ( "" ) ) ;
		strcat ( global_string, line_string ) ;

		SetPlayerListitemValue ( playerid, veh_slot, veh_id ) ;
		veh_slot ++ ;
	}
	show_dialog ( playerid, d_plates_change, DIALOG_STYLE_LIST, "{FFCC00}Номера", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock _DestroyVehicle ( vehicleid )
{
	if ( IsValidDynamic3DTextLabel ( veh_info [ vehicleid - 1 ] [ v_label ] ) ) DestroyDynamic3DTextLabel ( veh_info [ vehicleid - 1 ] [ v_label ] ) ;
	return DestroyVehicle ( vehicleid ) ;
}
#define DestroyVehicle _DestroyVehicle

stock is_vehicle_occupied ( vehicleid )
{
	foreach(new i: logged_players) if ( IsPlayerInVehicle ( i, vehicleid ) ) return i ;
	return -1 ;
}

CMD:startmarriage ( playerid, params [ ] ) // prist
{
    if ( ! priest_player [ playerid ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не священник." ) ;
    if ( sscanf ( params, "u", params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /startmarriage [ид жениха]" ) ;
    
    if ( ! IsPlayerConnected ( params [ 0 ] ) || playerid == params [ 0 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Неверно указан ID игрока." ) ;
    if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( playerid ) != GetPlayerVirtualWorld ( params [ 0 ] ) )
				return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок слишком далеко." ) ;
    
    if ( p_info [ params [ 0 ] ] [ marriage_today ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок не прошёл процесс регистрации." ) ;
    if ( p_info [ params [ 0 ] ] [ sex ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Начать регистрацию может только жених." ) ;
	if ( ! p_info [ params [ 0 ] ] [ marriage_ring ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У игрока нет колец." ) ;
	if ( GetPlayerSkin ( params [ 0 ] ) != man_marriage ) return SendClientMessage ( playerid, 0xFF6600FF, !"У игрока нет костюма." ) ;

	seller_id [ params [ 0 ] ] = playerid ;

	show_dialog ( params [ 0 ], d_prist_reg, DIALOG_STYLE_MSGBOX, "{FFCC00}Заявка", "{FFFFFF}Вы действительно готовы начать бракосочетание?\n\n\
	                                                                            {828282}Когда процесс начнётся все, кого Вы не успели пригласить\n\
																				{828282}не смогут войти в церковь.\n\
																				{828282}Невеста должна находиться рядом с Вами.", "Принять", "Закрыть" ) ;
	return 1 ;
}

public OnDialogResponse ( playerid, dialogid, response, listitem, inputtext [ ] )
{
    fire_OnDialogResponse ( playerid, dialogid, response, listitem, inputtext ) ;

	switch ( dialogid )
	{
	    case d_bizz_auto_invite: // taxi new
	    {
	        if ( ! response ) return 1 ;
	        
	        new _taxi_id = GetPlayerUseListitem ( playerid ) ;
	        p_info [ playerid ] [ job ] = _taxi_id ;
	        update_int_sql ( playerid, "u_job", p_info [ playerid ] [ job ] ) ;
	        
	        SendClientMessage ( playerid, 0xFFCC00FF, !"Вы трудоустроились в таксопарк! Используйте /tr для общения внутри таксопарка." ) ;
	    }
	    case d_priest_job: // prist
		{
		    if ( ! response ) return 1 ;

			if ( ! priest_player [ playerid ] )
			{
				SendClientMessage ( playerid, 0xFF9945FF, "Вы успешно переоделись." ) ;
				SendClientMessage ( playerid, 0xFF9945FF, "Ваша задача помогать людям бракосочетаться! Используйте /startmarriage." ) ;

				priest_player [ playerid ] = true ;
				
				SetPlayerSkin ( playerid, priest_skin ) ;
			}
			else
			{
				//SetPlayerSkin ( playerid, p_info [ playerid ] [ skin ] ) ;
				//give_money ( playerid, p_info [ playerid ] [ salary ] ) ;

				SendClientMessage ( playerid, 0xFF9945FF, "Вы завершили рабочую смену." ) ;
				
				new __t_string [ 72 ] ;
				format ( __t_string, sizeof ( __t_string ), "Заработано: {99cc00}%d$", p_info [ playerid ] [ salary ] ) ;
				SendClientMessage ( playerid, -1, __t_string ) ;

				p_info [ playerid ] [ salary ] = 0 ;
				
				priest_player [ playerid ] = false ;
			}
		}
		case d_quest_actor:
		{
		    new _quest_line = GetPlayerUseListitem ( playerid ) ;
			if ( _quest_line == getto_line )
			{
			    if ( p_info [ playerid ] [ getto_quest ] == -1 )
				{
					SendClientMessage ( playerid, 0xFFCC00FF, !"Вы успешно взяли задание." ) ;
					p_info [ playerid ] [ getto_quest ] = 0 ;
					update_int_sql ( playerid, "u_getto_quest", p_info [ playerid ] [ getto_quest ] ) ;
				}
			}
			else if ( _quest_line == family_line )
			{
			    if ( p_info [ playerid ] [ family_quest ] == -1 )
				{
					SendClientMessage ( playerid, 0xFFCC00FF, !"Вы успешно взяли задание." ) ;
					p_info [ playerid ] [ family_quest ] = 0 ;
					update_int_sql ( playerid, "u_family_quest", p_info [ playerid ] [ family_quest ] ) ;
				}
			}
		}
	    case d_progress:
	    {
	        if ( ! response ) return 1 ;
	        
	        new _line_id = GetPlayerListitemValue ( playerid, listitem ) ;
	        ClearPlayerListitemValues ( playerid ) ;
	        
	        if ( _line_id == getto_line )
	        {
	            new dialog_string [ 256 ], _quest_id = p_info [ playerid ] [ getto_quest ] ;
	            format ( dialog_string, sizeof dialog_string, "{FFCC00}%s\n{FFFFFF}%s\nПрогресс: {99cc00}%%d\n\nНаграда: {99cc00}%s",
				g_quest_info [ _quest_id ] [ q_name ], g_quest_info [ _quest_id ] [ q_text ], p_info [ playerid ] [ getto_progress ], g_quest_info [ _quest_id ] [ q_rewards ] ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{FFCC00}Настоящий гангстер", dialog_string, "Закрыть", "" ) ;
			}
			else if ( _line_id == family_line )
	        {
	            new dialog_string [ 256 ], _quest_id = p_info [ playerid ] [ family_quest ] ;
	            format ( dialog_string, sizeof dialog_string, "{FFCC00}%s\n{FFFFFF}%s\nПрогресс: {99cc00}%%d\n\nНаграда: {99cc00}%s",
				f_quest_info [ _quest_id ] [ q_name ], f_quest_info [ _quest_id ] [ q_text ], p_info [ playerid ] [ family_progress ], f_quest_info [ _quest_id ] [ q_rewards ] ) ;
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{FFCC00}Семейные узы", dialog_string, "Закрыть", "" ) ;
			}
	    }
	    case d_plates:
	    {
	        if ( ! response ) return ClearPlayerListitemValues ( playerid ) ;
	        
			set_player_use_listitem ( playerid, GetPlayerListitemValue ( playerid, listitem ) ) ;
			ClearPlayerListitemValues ( playerid ) ;
			
			SendClientMessage ( playerid, 0xFFCC00FF, !"Теперь выбирите номера, на которые хотите заменить." ) ;
			
			show_change_plate ( playerid ) ;
	    }
	    case d_plates_change:
	    {
			if ( ! response ) return ClearPlayerListitemValues ( playerid ) ;
			
			new veh_id = GetPlayerListitemValue ( playerid, listitem ) ;
			ClearPlayerListitemValues ( playerid ) ;
			
			if ( get_player_use_listitem ( playerid ) == veh_id )
			{
			    SendClientMessage ( playerid, 0xFF9945FF, "Вы выбрали тот же номерной знак." ) ;
			    show_change_plate ( playerid ) ;
			    return 1 ;
			}
			
			new _scm_save [ 12 ], _first_vehicle = get_player_use_listitem ( playerid ) ;
			format ( _scm_save, sizeof _scm_save, "%s", veh_info [ veh_id - 1 ] [ v_plate ] ) ;
			
			format ( veh_info [ veh_id - 1 ] [ v_plate ], 12, "%s", veh_info [ _first_vehicle - 1 ] [ v_plate ] ) ;
			format ( veh_info [ _first_vehicle - 1 ] [ v_plate ], 12, "%s", _scm_save ) ;

			new sql_string [ 128 ] ;
            format ( sql_string, sizeof sql_string, "UPDATE `users_vehicles` SET `u_veh_plate` = '%s' WHERE `v_id` = '%d' LIMIT 1",
            veh_info [ veh_id - 1 ] [ v_plate ], veh_info [ veh_id - 1 ] [ v_id ] ) ;
            mysql_tquery ( sql_connection, sql_string ) ;
            
            format ( sql_string, sizeof sql_string, "UPDATE `users_vehicles` SET `u_veh_plate` = '%s' WHERE `v_id` = '%d' LIMIT 1",
            veh_info [ _first_vehicle - 1 ] [ v_plate ], veh_info [ _first_vehicle - 1 ] [ v_id ] ) ;
            mysql_tquery ( sql_connection, sql_string ) ;
            
            SetVehicleNumberPlate ( veh_info [ veh_id - 1 ] [ v_vehicle ], veh_info [ veh_id - 1 ] [ v_plate ] ) ;
            SetVehicleNumberPlate ( veh_info [ _first_vehicle - 1 ] [ v_vehicle ], veh_info [ _first_vehicle - 1 ] [ v_plate ] ) ;
            
            SendClientMessage ( playerid, 0xFFCC00FF, !"Вы успешно поменяли номерные знаки на машинах." ) ;
	    }
	    case d_job_railway:
		{
		    if ( ! response ) return 1 ;

			if ( ! railway_start [ playerid ] )
			{
				SendClientMessage ( playerid, 0xFF9945FF, "Вы успешно переоделись." ) ;
				SendClientMessage ( playerid, 0xFF9945FF, "Ваша задача ездить по станциям указаным на карте и подбирать пассажиров!" ) ;

				railway_start [ playerid ] = true ;
				railway_car [ playerid ] = AddStaticVehicleEx ( 538, railway_position [ 0 ], railway_position [ 1 ], railway_position [ 2 ], railway_position [ 3 ], 1, 1, 600 ) ;

				PutPlayerInVehicle ( playerid, railway_car [ playerid ], 0 ) ;

                railway_player_station { playerid } = 0 ;

				is_gps_used { playerid } = 45 ;
				SetPlayerRaceCheckpoint ( playerid, 1, railway_station [ 0 ] [ r_pos ] [ 0 ], railway_station [ 0 ] [ r_pos ] [ 1 ], railway_station [ 0 ] [ r_pos ] [ 2 ] - 1.4, 0.0, 0.0, 0.0, 8.0 ) ;
			}
			else
			{
				//give_money ( playerid, p_info [ playerid ] [ salary ] ) ;
				//SetPlayerSkin ( playerid, p_info [ playerid ] [ skin ] ) ;

				SendClientMessage ( playerid, 0xFF9945FF, "Вы завершили рабочую смену." ) ;

				new __t_string [ 72 ] ;
				format ( __t_string, sizeof ( __t_string ), "Заработано: {99cc00}%d$", p_info [ playerid ] [ salary ] ) ;
				SendClientMessage ( playerid, -1, __t_string ) ;

				p_info [ playerid ] [ salary ] = 0 ;
				
				railway_start [ playerid ] = false ;
			}
		}
	    case d_phone:
	    {
	        if ( ! response ) return 1 ;

	        if ( listitem == 0 )
	        {
	            show_dialog ( playerid, d_sms, DIALOG_STYLE_INPUT, "{FFCC00}СМС", "{FFFFFF}Для отправки СМС сообщения укажите номер телефона и сообщение:\n\n{828282}* Пример: {"#cBL"}'111111, Привет друг'", "Отправить", "Закрыть" ) ;
	        }
	        else if ( listitem == 1 )
	        {
	            new query_string [ 120 + 9 + 9 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users_message` WHERE `u_id` = '%d' OR `from_id` = '%d' ORDER BY `users_message`.`inc_id` DESC LIMIT 10", p_info [ playerid ] [ id ], p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query_string, "callback_message", "i", playerid ) ;
	        }
	    }
	    case d_message_input:
		{
		    if ( ! response )
			{
			    ClearPlayerListitemValues ( playerid ) ;
			    
				new query_string [ 120 + 9 + 9 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users_message` WHERE `u_id` = '%d' OR `from_id` = '%d' ORDER BY `users_message`.`inc_id` DESC LIMIT 10", p_info [ playerid ] [ id ], p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query_string, "callback_message", "i", playerid ) ;
				return 1 ;
			}
			
			if ( strlen ( inputtext ) < 3 || strlen ( inputtext ) > 100 )
	        {
	            show_dialog ( playerid, d_sms, DIALOG_STYLE_INPUT, "{FFCC00}СМС", "{AA3333}* Сообщение не может быть короче 3 и длинее 100 символов\n\n{828282}* Введите текст сообщения:", "Отправить", "Закрыть" ) ;
	            return 1 ;
	        }
	        
	        new list_item = GetPlayerUseListitem ( playerid ) ;

			new query_string [ 62 + 9 ] ;
			mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users_message` WHERE `inc_id` = '%d' LIMIT 1", list_item ) ;
			mysql_tquery ( sql_connection, query_string, "callback_message_insert", "is", playerid, inputtext ) ;
		}
	    case d_message:
		{
			if ( ! response )
			{
			    ClearPlayerListitemValues ( playerid ) ;
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				callcmd::phone ( playerid ) ;
				return 1 ;
			}

			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
			    clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1 ;
				if ( page_id == 0 )
				{
					SendClientMessage ( playerid, 0xFF6600FF, !"Вы находитесь на первой странице сообщений." ) ;

					new query_string [ 120 + 9 + 9 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users_message` WHERE `u_id` = '%d' OR `from_id` = '%d' ORDER BY `users_message`.`inc_id` DESC LIMIT 10", p_info [ playerid ] [ id ], p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, query_string, "callback_message", "i", playerid ) ;
					return 1 ;

				}
				page_count [ playerid ] = page_id ;

				new query_string [ 120 + 9 + 9 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users_message` WHERE `u_id` = '%d' OR `from_id` = '%d' ORDER BY `users_message`.`inc_id` DESC LIMIT 10", p_info [ playerid ] [ id ], p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query_string, "callback_message", "i", playerid ) ;

			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
			    clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1 ;
				if ( ofm_formula ( page_id ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, 0xFF6600FF, !"Вы находитесь на последней странице списка сообщений." ) ;

					new query_string [ 120 + 9 + 9 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users_message` WHERE `u_id` = '%d' OR `from_id` = '%d' ORDER BY `users_message`.`inc_id` DESC LIMIT 10", p_info [ playerid ] [ id ], p_info [ playerid ] [ id ] ) ;
					mysql_tquery ( sql_connection, query_string, "callback_message", "i", playerid ) ;
					return 1 ;
				}

				page_count [ playerid ] = page_id + 2 ;

				new query_string [ 120 + 9 + 9 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users_message` WHERE `u_id` = '%d' OR `from_id` = '%d' ORDER BY `users_message`.`inc_id` DESC LIMIT 10", p_info [ playerid ] [ id ], p_info [ playerid ] [ id ] ) ;
				mysql_tquery ( sql_connection, query_string, "callback_message", "i", playerid ) ;
			}
			else
			{
				new list_item = GetPlayerListitemValue ( playerid, listitem ) ;
				SetPlayerUseListitem ( playerid, list_item ) ;

				new query_string [ 62 + 9 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users_message` WHERE `inc_id` = '%d' LIMIT 1", list_item ) ;
				mysql_tquery ( sql_connection, query_string, "callback_message_info", "i", playerid ) ;
			}
			return 1 ;
		}
	    case d_sms:
	    {
	        if ( ! response ) return callcmd::phone ( playerid ) ;
	        
	        new phone_number, text_message [ 100 ] ;
	        if ( sscanf ( inputtext, "p<,>ds[100]", phone_number, text_message ) )
	        {
	            show_dialog ( playerid, d_sms, DIALOG_STYLE_INPUT, "{FFCC00}СМС", "{FFFFFF}Для отправки СМС сообщения укажите номер телефона и сообщение:\n\n{828282}* Пример: {"#cBL"}'111111, Привет друг'", "Отправить", "Закрыть" ) ;
	            return 1 ;
	        }
	        if ( strlen ( text_message ) < 3 || strlen ( text_message ) > 100 )
	        {
	            show_dialog ( playerid, d_sms, DIALOG_STYLE_INPUT, "{FFCC00}СМС", "{AA3333}* Сообщение не может быть короче 3 и длинее 100 символов\n\n{FFFFFF}Для отправки СМС сообщения укажите номер телефона и сообщение:\n\n{828282}* Пример: {"#cBL"}'111111, Привет друг'", "Отправить", "Закрыть" ) ;
	            return 1 ;
	        }
	        
	        new _p_count = -1, _p_name [ MAX_PLAYER_NAME ] ;

			static const _str [ ] = "SELECT `u_id` FROM `users` WHERE `u_number` = '%d' LIMIT 1" ;
			new query_string [ sizeof _str + 11 + 4 ] ;
			format ( query_string, sizeof ( query_string ), _str, phone_number ) ;
			new Cache:result = mysql_query ( sql_connection, query_string ) ;
			_p_count = cache_num_rows ( ) ;
			if ( _p_count )
			{
				_p_count = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;
				cache_get_field_content ( 0, "u_name", _p_name, sql_connection, MAX_PLAYER_NAME ) ;
			}
			cache_delete ( result ) ;
			
			if ( _p_count == -1 )
	        {
	            show_dialog ( playerid, d_sms, DIALOG_STYLE_INPUT, "{FFCC00}СМС", "{AA3333}* Игрока с таким номером нет\n\n{FFFFFF}Для отправки СМС сообщения укажите номер телефона и сообщение:\n\n{828282}* Пример: {"#cBL"}'111111, Привет друг'", "Отправить", "Закрыть" ) ;
	            return 1 ;
	        }
	        
	        global_string [ 0 ] = EOS ;
	        format ( global_string, sizeof ( global_string ), "INSERT INTO `users_message` (`u_id`,`u_name`,`phone_number`,`text_message`,`from_id`,`from_number`,`from_name`,`text_status`) VALUES ('%d','%s','%d','%s','%d','%d','%s','0')",
			_p_count, _p_name, phone_number, text_message, p_info [ playerid ] [ id ], p_info [ playerid ] [ number ], p_info [ playerid ] [ name ] ) ;
			mysql_tquery ( sql_connection, global_string ) ;
			
			new scm_string [ 128 ] ;
			format ( scm_string, sizeof scm_string, "Вы отправили сообщение на номер {FFFFFF}%d{FFCC00}.", phone_number ) ;
			SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
			
			format ( scm_string, sizeof scm_string, "Текст: {FFFFFF}%s{FFCC00}.", text_message ) ;
			SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
			
			SendClientMessage ( playerid, 0xFFCC00FF, !"Вы можете отслеживать Ваше сообщение в /phone - Диалоги." ) ;
			
			callcmd::phone ( playerid ) ;
	    }
	    case d_nards_accept:
	    {
	        if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок покинул игру." ) ;
			if ( ! response )
			{
				SendClientMessage ( seller_id [ playerid ], 0xFF6600FF, "Игрок отказался вступать в Вашу команду." ) ;
				
				bg_player_table [ playerid ] =
				bg_player_table [ seller_id [ playerid ] ] = -1 ;
				
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			if ( bg_info [ bg_player_table [ playerid ] ] [ bg_player ] [ 0 ] != INVALID_PLAYER_ID )
			{
				SendClientMessage ( seller_id [ playerid ], 0xFF6600FF, "Стол уже занят." ) ;
				SendClientMessage ( playerid, 0xFF6600FF, !"Стол уже занят." ) ;
				
				bg_player_table [ playerid ] =
				bg_player_table [ seller_id [ playerid ] ] = -1 ;
				
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
	    
	        new target_id = seller_id [ playerid ], _table = bg_player_table [ playerid ] ;

			for ( new j = 0 ; j < 24 ; j ++ )
			{
				bg_info [ _table ] [ bg_cell_player ] [ j ] = -1 ;
			 	bg_info [ _table ] [ bg_nard_count ] [ j ] = 0 ;
			}
		  	bg_info [ _table ] [ bg_dice ] [ 0 ] =
		   	bg_info [ _table ] [ bg_dice ] [ 1 ] =
		   	bg_info [ _table ] [ bg_dice ] [ 2 ] =
		   	bg_info [ _table ] [ bg_dice ] [ 3 ] = 0 ;
		   	bg_info [ _table ] [ bg_player_dice_count ] = 0 ;
		   	
		   	new scm_string [ 41 + MAX_PLAYER_NAME ] ;
			format ( scm_string, sizeof scm_string, "%s присоединился к игре в нарды!", p_info [ playerid ] [ name ] ) ;
			SendClientMessage ( target_id, 0xFFCC00FF, scm_string ) ;

			format ( scm_string, sizeof scm_string, "Вы присоединились к игре в нарды с %s!", p_info [ target_id ] [ name ] ) ;
			SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

		   	bg_used [ playerid ] = true ;
			show_ptd_chess ( playerid, true ) ;

			bg_used [ target_id ] = true ;
			show_ptd_chess ( target_id, true ) ;

			bg_info [ _table ] [ bg_player ] [ 0 ] = playerid ;
			bg_info [ _table ] [ bg_move ] = playerid ;
			show_ptd_nards ( 0, _table, true ) ;

			bg_info [ _table ] [ bg_player ] [ 1 ] = target_id ;
			show_ptd_nards ( 1, _table, true ) ;
			
			clear_sell_params ( playerid, target_id ) ;
		}
	    case d_rentcar_quest:
	    {
	        if ( ! response ) return 1 ;
	        
	        SendClientMessage ( playerid, 0xFFCC00FF, !"Теперь следуйте в {FFFFFF}\"порт\"{FFCC00}. Там Вы сможете загрузить оружие." ) ;
	        
	        p_info [ playerid ] [ family_everyday_progress ] [ 1 ] = 2 ;
	        
	       	p_info [ playerid ] [ family_everyday_car ] = CreateVehicle ( 482, 297.5149, -1587.6289, 32.7497, 263.2277, 0, 0, -1 ) ;
			new veh_id = p_info [ playerid ] [ family_everyday_car ] ;
		  	veh_info [ veh_id - 1 ] [ v_model ] = 482 ;
	       	
	       	new engine, lights, alarm, doors, bonnet, boot, objective ;

			veh_info [ veh_id - 1 ] [ v_locked ] = false ;
			GetVehicleParamsEx ( veh_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( veh_id, engine, lights, alarm, false, bonnet, boot, objective ) ;
	        
	        is_gps_used { playerid } = 24 ;
			SetPlayerRaceCheckpoint ( playerid, 1, 2792.1982, -2343.9978, 13.2751 - 1.4, 0.0, 0.0, 0.0, 8.0 ) ;
	    }
	    case d_family_every_quest:
	    {
	        if ( ! response ) return 1 ;

	        if ( listitem == 0 )
	        {
	            if ( p_info [ playerid ] [ family_everyday_quest ] [ 0 ] >= 3 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы выполнили данное задание максимальное количество раз." ) ;

				show_dialog ( playerid, d_enter_quest, DIALOG_STYLE_MSGBOX, "{FFCC00}Задание", "{FFFFFF}Вам необходимо будет заправить одно из т/с Вашей семьи.\n\
																								Оно будет отмечено на карте.\n\n\
																								Вознагрождение: {FFCC00}10 монет.\n\n\
																								{828282}* Вы готовы взять задание?", "Да", "Нет" ) ;

				set_player_use_listitem ( playerid, listitem ) ;
	        }
	        else if ( listitem == 1 )
	        {
	            if ( p_info [ playerid ] [ family_everyday_quest ] [ 1 ] >= 2 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы выполнили данное задание максимальное количество раз." ) ;

				show_dialog ( playerid, d_enter_quest, DIALOG_STYLE_MSGBOX, "{FFCC00}Задание", "{FFFFFF}Вам необходимо будет заняться заказом и доставкой оружия в семейный отель.\n\
																								Для этого Вам понадобится транспорт. Мы отметим на Вашей карте, где можно будет арендовать.\n\n\
																								Вознагрождение: {FFCC00}15 монет.\n\n\
																								{828282}* Вы готовы взять задание?", "Да", "Нет" ) ;

				set_player_use_listitem ( playerid, listitem ) ;
	        }
	    }
	    case d_enter_quest:
	    {
	        if ( ! response ) return family_everyday_show ( playerid ) ;
	        
	        new list_item = get_player_use_listitem ( playerid ) ;
	        
			if ( list_item == 0 )
			{
				new Float: _v_fuel = 60.0, _v_id = -1, bool: _fuel_car = false ;
				foreach(new v: family_vehicles[p_info [ playerid ] [ family ]])
				{
				    if ( ! IsValidVehicle ( v ) ) continue ;
					if ( is_vehicle_occupied ( v ) != -1 ) continue ;
				    if ( veh_info [ v - 1 ] [ v_fuel ] < _v_fuel )
				    {
				        _v_id = v ;
						_fuel_car = true ;
						break ;
				    }
				}
				if ( ! _fuel_car ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент нет транспорта, который можно заправить." ) ;

                p_info [ playerid ] [ family_everyday_car ] = _v_id ;
                
                p_info [ playerid ] [ family_everyday_progress ] [ list_item ] = 1 ;

            	SendClientMessage ( playerid, 0xFFCC00FF, !"Вы взяли задание {FFFFFF}\"Полный бак\"{FFCC00}. У Вас на карте отмечено т/с, которое нужно заправить." ) ;

                is_gps_used { playerid } = 20 ;
				SetPlayerRaceCheckpoint ( playerid, 1, veh_info [ _v_id - 1 ] [ v_now_pos ] [ 0 ], veh_info [ _v_id - 1 ] [ v_now_pos ] [ 1 ],veh_info [ _v_id - 1 ] [ v_now_pos ] [ 2 ] - 1.4, 0.0, 0.0, 0.0, 3.0 ) ;
			}
			else if ( list_item == 1 )
			{
			    p_info [ playerid ] [ family_everyday_progress ] [ list_item ] = 1 ;

            	SendClientMessage ( playerid, 0xFFCC00FF, !"Вы взяли задание {FFFFFF}\"Заказ оружия\"{FFCC00}. У Вас на карте отмечено т/с, которое нужно арендовать." ) ;

                is_gps_used { playerid } = 23 ;
				SetPlayerRaceCheckpoint ( playerid, 1, 295.6985, -1590.8699, 32.5702 - 1.4, 0.0, 0.0, 0.0, 8.0 ) ;
			}
			
			p_info [ playerid ] [ family_everyday_quest ] [ list_item ] ++ ;

            new sql_string [ 128 ] ;
            format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_family_every_quest` = '%d|%d' WHERE `u_id` = '%d' LIMIT 1",
            p_info [ playerid ] [ family_everyday_quest ] [ 0 ], p_info [ playerid ] [ family_everyday_quest ] [ 1 ], p_info [ playerid ] [ id ] ) ;
            mysql_tquery ( sql_connection, sql_string ) ;
		}
	    case d_gun_up:
	    {
	        if ( ! response ) return ClearPlayerListitemValues ( playerid ) ;
	        
	        new _drop_id = get_player_use_listitem ( playerid ) ;
	        clear_player_use_listitem ( playerid ) ;
	        new list_item = GetPlayerListitemValue ( playerid, listitem ) ;
	        ClearPlayerListitemValues ( playerid ) ;
	        
	        new gunname [ 32 ] ;
			GetWeaponName ( gd_info [ _drop_id ] [ g_gun ] [ list_item ], gunname, 32 ) ;
			
			new scm_string [ 31 + 32 + 6 ] ;
			format ( scm_string, sizeof scm_string, "Вы подобрали %s с %d патрон.", gunname, gd_info [ _drop_id ] [ g_ammo ] [ list_item ] ) ;
	        SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

	        give_weapon ( playerid, gd_info [ _drop_id ] [ g_gun ] [ list_item ], gd_info [ _drop_id ] [ g_ammo ] [ list_item ] ) ;
	        gd_info [ _drop_id ] [ g_gun ] [ list_item ] = gd_info [ _drop_id ] [ g_ammo ] [ list_item ] = 0 ;
	        
	        new bool: _gun_id = false ;
			for ( new i = 0 ; i < 13 ; i ++ )
			{
			    if ( gd_info [ _drop_id ] [ g_gun ] [ i ] == 0 ) continue ;

			    _gun_id = true ;
			    break ;
			}
			if ( ! _gun_id )
			{
			    new sql_string [ 59 + 9 ] ;
		        format ( sql_string, sizeof ( sql_string ), "DELETE FROM `player_weapons` WHERE `g_id` = '%d' LIMIT 1", gd_info [ _drop_id ] [ g_id ] ) ;
				mysql_tquery ( sql_connection, sql_string ) ;
				
				Iter_Remove(gun_drops, gd_info [ _drop_id ] [ g_id ]);
				DestroyDynamicObject ( gd_info [ _drop_id ] [ g_object ] ) ;
				DestroyDynamic3DTextLabel ( gd_info [ _drop_id ] [ g_text ] ) ;
			}
	    }
	    case d_roulette_bet:
		{
			if ( !response ) return roulette_number [ playerid ] = -1 ;
			if ( roulette_started [ roulette_used { playerid } - 1 ] == true )return roulette_number [ playerid ] = -1, SendClientMessage ( playerid, 0xFF6600FF, !"Игра уже началась, ожидайте завершения для новой ставки." ) ;

			new money_count = strval ( inputtext ) ;
			if ( money_count < 1000 || money_count > 3000000 )
			{
				new number_name [ 16 ] ;
				switch ( roulette_number [ playerid ] )
				{
					case 0..36:format ( number_name, 16, "%d", roulette_number [ playerid ] ) ;
					case 37:format ( number_name, 16, "1-й столбец" ) ;
					case 38:format ( number_name, 16, "2-й столбец" ) ;
					case 39:format ( number_name, 16, "3-й столбец" ) ;
					case 40:format ( number_name, 16, "1-е 12 чисел" ) ;
					case 41:format ( number_name, 16, "2-е 12 чисел" ) ;
					case 42:format ( number_name, 16, "3-е 12 чисел" ) ;
					case 43:format ( number_name, 16, "красные" ) ;
					case 44:format ( number_name, 16, "чёрные" ) ;
				}
				new dialog_string [ 126 + 16 ] ;
				format ( dialog_string, sizeof dialog_string, "{ffffff}Введите сумму, которую желаете поставить на %s\n\n{AA3333}* Ставка должна быть не менее 1000$ и не более 3.000.000$",
				number_name ) ;
				show_dialog ( playerid, d_roulette_bet, DIALOG_STYLE_INPUT, "{FFCC00}Ставка", dialog_string, "Принять", "Отмена" ) ;
				return 1 ;
			}
			if ( p_info [ playerid ] [ money ] < money_count )
			{
				new number_name [ 16 ] ;
				switch ( roulette_number [ playerid ] )
				{
					case 0..36:format ( number_name, 16, "%d", roulette_number [ playerid ] ) ;
					case 37:format ( number_name, 16, "1-й столбец" ) ;
					case 38:format ( number_name, 16, "2-й столбец" ) ;
					case 39:format ( number_name, 16, "3-й столбец" ) ;
					case 40:format ( number_name, 16, "1-е 12 чисел" ) ;
					case 41:format ( number_name, 16, "2-е 12 чисел" ) ;
					case 42:format ( number_name, 16, "3-е 12 чисел" ) ;
					case 43:format ( number_name, 16, "красные" ) ;
					case 44:format ( number_name, 16, "чёрные" ) ;
				}
				new dialog_string [ 97 + 16 ] ;
				format ( dialog_string, sizeof dialog_string, "{ffffff}Введите сумму, которую желаете поставить на %s\n\n{AA3333}* У Вас недостаточно средств",
				number_name ) ;
				show_dialog ( playerid, d_roulette_bet, DIALOG_STYLE_INPUT, "{FFCC00}Ставка", dialog_string, "Принять", "Отмена" ) ;
				return 1 ;
			}
			roulette_bet [ playerid ] = money_count ;

			new number_name [ 16 ] ;
			switch ( roulette_number [ playerid ] )
				{
					case 0..36:format ( number_name, 16, "%d", roulette_number [ playerid ] ) ;
					case 37:format ( number_name, 16, "1-й столбец" ) ;
					case 38:format ( number_name, 16, "2-й столбец" ) ;
					case 39:format ( number_name, 16, "3-й столбец" ) ;
					case 40:format ( number_name, 16, "1-е 12 чисел" ) ;
					case 41:format ( number_name, 16, "2-е 12 чисел" ) ;
					case 42:format ( number_name, 16, "3-е 12 чисел" ) ;
					case 43:format ( number_name, 16, "красные" ) ;
					case 44:format ( number_name, 16, "чёрные" ) ;
				}

			static const _str [ ] = "Вы успешно поставили {99cc00}%d$ {FFFFFF}на {99cc00}%s" ;
			new scm_string [ sizeof _str + 11 + 16 ] ;
			format ( scm_string, sizeof scm_string, _str, money_count, number_name ) ;
			SendClientMessage ( playerid, -1, scm_string ) ;

			give_money ( playerid, -money_count ) ;
			//insert_money_log ( playerid, INVALID_PLAYER_ID, -money_count, "ставка рулетка" ) ;

			new bet_text [ 16 ] ;

            format ( bet_text, sizeof bet_text, "%d$", roulette_bet [ playerid ] ) ;
			PlayerTextDrawSetString ( playerid, roulette_ptd [ playerid ] [ 11 ], bet_text ) ;
		}
	    case d_prist_reg:// marriage
	    {
	        if ( ! response ) return 1 ;
	        
	        new target_id = -1 ;
	        foreach(new i: streamed_players[playerid])
	        {
	            if ( p_info [ playerid ] [ marriage_today ] != p_info [ i ] [ marriage_today ] ) continue ;
	            if ( priest_player [ i ] ) continue ; // prist
	            
	            target_id = i ;
	            break ;
	        }
	        if ( target_id == -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Невеста не рядом с Вами." ) ;
	        if ( ! IsPlayerInRangeOfPoint ( playerid, 10, p_t_info [ target_id ][ p_pos ] [ 0 ], p_t_info [ target_id ][ p_pos ] [ 1 ], p_t_info [ target_id ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( target_id ) != GetPlayerVirtualWorld ( playerid ) )
	                                 return SendClientMessage ( playerid, 0xFF6600FF, !"Невеста не рядом с Вами." ) ;
	                                 
			if ( GetPlayerSkin ( target_id ) != woman_marriage ) return SendClientMessage ( playerid, 0xFF6600FF, !"У невесты нет свадебного платья." ) ;

            marriage_start = p_info [ playerid ] [ marriage_today ] ;

            foreach(new i: streamed_players[playerid])
	        {
	            if ( p_info [ playerid ] [ marriage_today ] == p_info [ i ] [ marriage_today ] ) continue ;
				if ( p_info [ playerid ] [ marriage_today ] == p_info [ i ] [ wedding ] ) continue ;
				if ( priest_player [ i ] ) continue ; // prist
				
				set_pos ( i, 1720.2524, -1741.1508, 13.5469, 358.0450, 0, 0 ) ;
				SendClientMessage ( i, 0xFF6600FF, "В церкви началась свадебная церимония! Вы в ней не учавствуете." ) ;
	        }

            SendClientMessage ( playerid, 0xFFCC00FF, !"Пастырь: {FFFFFF}Здравствуйте, дети мои." ) ;
            foreach(new i: streamed_players[playerid]) SendClientMessage ( i, 0xFFCC00FF, "Пастырь: {FFFFFF}Здравствуйте, дети мои." ) ;
            
            new scm_string [ 128 ] ;
            format ( scm_string, sizeof scm_string, "Пастырь: {FFFFFF}Сегодня будут скреплены узами брака %s и %s.", p_info [ playerid ] [ name ], p_info [ target_id ] [ name ] ) ;
            SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
            foreach(new i: streamed_players[playerid]) SendClientMessage ( i, 0xFFCC00FF, scm_string ) ;
            
			prist_time = SetTimerEx ( "prist_timer", 3000, true, "iii", playerid, target_id, seller_id [ playerid ] ) ;
			
			set_pos ( playerid, 1227.4520, 2040.6298, 656.6249, 178.3806, 33, 1 ) ;
			set_pos ( target_id, 1227.3651, 2037.8713, 656.6249, 357.6388, 33, 1 ) ;
			set_pos ( seller_id [ playerid ], 1227.3651, 2037.8713, 656.6249, 357.6388, 33, 1 ) ; // prist
			
			TogglePlayerControllable ( playerid, false ) ;
	    	TogglePlayerControllable ( target_id, false ) ;
	    	TogglePlayerControllable ( seller_id [ playerid ], false ) ;
			return 1 ;
	    }
	    case d_prist:
	    {
	        if ( ! response ) return 1 ;
	        
	        if ( listitem == 0 )
	        {
				if ( p_info [ playerid ] [ marriage_today ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже подали заявку." ) ;
				if ( p_info [ playerid ] [ sex ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Подавать заявку может только мужчина." ) ;
				
	            show_dialog ( playerid, d_prist_marriage, DIALOG_STYLE_INPUT, "{FFCC00}Заявка", "{FFFFFF}Вы действительно хотите подать заявку на бракосочетание?\n\n\
	                                                                                        {FFCC00}После подачи заявки Вам нужно будет:\n\
																							{14A3FF}1. {FFFFFF}Приобрести кольца\n\
																							{14A3FF}2. {FFFFFF}Приобрести мужской костюм\n\
																							{14A3FF}3. {FFFFFF}Приобрести женское платье\n\n\
																							{828282}Бракосочетаться Вы сможете в течении всего дня!\n\
																							{828282}Введите ID Вашей полововинки:", "Выбрать", "Закрыть" ) ;
	        }
			else if ( listitem == 1 )
			{
			    if ( ! p_info [ playerid ] [ marriage_today ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не подали заявку." ) ;
			    if ( p_info [ playerid ] [ money ] < ring_price ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас недостаточно средств." ) ;

                give_money ( playerid, -ring_price ) ;

				p_info [ playerid ] [ marriage_ring ] = 1 ;
				SendClientMessage ( playerid, 0xFFCC00FF, !"Вы приобрели кольца, остались костюмы." ) ;
			}
			else if ( listitem == 2 )
			{
			    if ( ! p_info [ playerid ] [ marriage_today ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не подали заявку." ) ;
			    if ( p_info [ playerid ] [ sex ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не мужчина." ) ;
			    if ( p_info [ playerid ] [ money ] < man_marriage_price ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас недостаточно средств." ) ;

                give_money ( playerid, -man_marriage_price ) ;

				SetPlayerSkin ( playerid, man_marriage ) ;
				SendClientMessage ( playerid, 0xFFCC00FF, !"Вы приобрели костюм, можете переходить к церемонии." ) ;
			}
			else if ( listitem == 3 )
			{
			    if ( ! p_info [ playerid ] [ marriage_today ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не подали заявку." ) ;
			    if ( ! p_info [ playerid ] [ sex ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не женщина." ) ;
			    if ( p_info [ playerid ] [ money ] < woman_marriage_price ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас недостаточно средств." ) ;

				give_money ( playerid, -woman_marriage_price ) ;

				SetPlayerSkin ( playerid, woman_marriage ) ;
				SendClientMessage ( playerid, 0xFFCC00FF, !"Вы приобрели платье, можете переходить к церемонии." ) ;
			}
	    }
	    case d_prist_marriage:
	    {
	        if ( ! response ) return show_prist ( playerid ) ;
	        
	        new target_id = strval ( inputtext ) ;
	        if ( ! IsPlayerConnected ( target_id ) )
	        {
	            SendClientMessage ( playerid, 0xFF6600FF, !"Выбранного игрока нет в сети." ) ;
	            show_prist ( playerid ) ;
	            return 1 ;
	        }
	        if ( ! IsPlayerInRangeOfPoint ( playerid, 10, p_t_info [ target_id ][ p_pos ] [ 0 ], p_t_info [ target_id ][ p_pos ] [ 1 ], p_t_info [ target_id ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( target_id ) != GetPlayerVirtualWorld ( playerid ) )
	        {
	            SendClientMessage ( playerid, 0xFF6600FF, !"Игрок слишком далеко." ) ;
	            show_prist ( playerid ) ;
	            return 1 ;
	        }
	        
	        buyer_id [ playerid ] = target_id ;
	        seller_id [ target_id ] = playerid ;

	        new dialog_string [ 48 + MAX_PLAYER_NAME ] ;
			format ( dialog_string, sizeof ( dialog_string  ), "{FFCC00}%s {FFFFFF}предлагает Вам пожениться.",
			p_info [ playerid ] [ name ] ) ;
			show_dialog ( target_id, d_prist_marriage_success, DIALOG_STYLE_MSGBOX, "{FFCC00}Свадьба", dialog_string, "Согласен", "Отказ" ) ;

			format ( dialog_string, sizeof ( dialog_string  ), "Вы предложили {FFCC00}%s {FFFFFF}пожениться.",
			p_info [ target_id ] [ name ] ) ;
			SendClientMessage ( playerid, -1, dialog_string ) ;
	    }
	    case d_prist_marriage_success:
	    {
	        if ( ! response )
			{
			    SendClientMessage ( seller_id [ playerid ], 0xFF6600FF, "Игрок отказался от предложения." ) ;
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			
			new target_id = seller_id [ playerid ] ;

			new _t_string [ 33 + MAX_PLAYER_NAME ] ;
            format ( _t_string, sizeof ( _t_string ), "%s принял(а) Ваше предложение!", p_info [ playerid ] [ name ] ) ;
 			SendClientMessage ( target_id, 0xFFCC00FF, _t_string ) ;

 			format ( _t_string, sizeof ( _t_string ), "Вы приняли предложение %s!", p_info [ target_id ] [ name ] ) ;
 			SendClientMessage ( playerid, 0xFFCC00FF, _t_string ) ;
 			
 			SendClientMessage ( playerid, 0xFFCC00FF, !"Ваша свадьба состоится сегодня, Вам необходимо подготовиться к ней." ) ;
 			SendClientMessage ( playerid, 0xFFCC00FF, !"Используйте команду /invitewedding, чтоб приглашать людей на Вашу свадьбу." ) ;
 			
 			SendClientMessage ( target_id, 0xFFCC00FF, "Ваша свадьба состоится сегодня, Вам необходимо подготовиться к ней." ) ;
 			SendClientMessage ( target_id, 0xFFCC00FF, "Используйте команду /invitewedding, чтоб приглашать людей на Вашу свадьбу." ) ;
 			
 			count_marriage ++ ; // mm edit
 			p_info [ playerid ] [ marriage_today ] = count_marriage ;
	 		update_int_sql ( playerid, "u_marriage_today", p_info [ playerid ] [ marriage_today ] ) ;
	 		p_info [ target_id ] [ marriage_today ] = count_marriage ;
	 		update_int_sql ( target_id, "u_marriage_today", p_info [ target_id ] [ marriage_today ] ) ;
			
			clear_sell_params ( playerid, target_id ) ;
	    }
	    case d_wedding_invite:
	    {
	        if ( ! response )
			{
			    SendClientMessage ( seller_id [ playerid ], 0xFF6600FF, "Игрок отказался от предложения." ) ;
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}

			new target_id = seller_id [ playerid ] ;

			new _t_string [ 33 + MAX_PLAYER_NAME ] ;
            format ( _t_string, sizeof ( _t_string ), "%s принял(а) Ваше предложение!", p_info [ playerid ] [ name ] ) ;
 			SendClientMessage ( target_id, 0xFFCC00FF, _t_string ) ;

 			format ( _t_string, sizeof ( _t_string ), "Вы приняли предложение %s!", p_info [ target_id ] [ name ] ) ;
 			SendClientMessage ( playerid, 0xFFCC00FF, _t_string ) ;

 			p_info [ playerid ] [ wedding ] = p_info [ target_id ] [ marriage_today ] ;

			clear_sell_params ( playerid, target_id ) ;
	    }
	    case d_rentcar:// Taxi
	    {
	        if ( ! response ) return 1 ;
	        
	        player_rentcar [ playerid ] = GetPlayerVehicleID ( playerid ) ;
			if ( veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_type ] == vehicle_type_carshering ) 
			{
				p_t_info [ playerid ] [ pTaxiStart ] = veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_millage ] ;
				return 1 ;
			}
	        SendClientMessage ( playerid, 0xFFCC00FF, !"Вы арендовали транспорт, принимайте заказы. (/gotaxi)" ) ;
	        p_info [ playerid ] [ taxi_cooldown ] = 300 ;
	    }
		case d_taxi_panel:
		{
		    if ( ! response ) return ClearPlayerListitemValues ( playerid ) ;
		    
		    new list_item = GetPlayerListitemValue ( playerid, listitem ) ;
		    ClearPlayerListitemValues ( playerid ) ;
		    
		    if ( list_item >= 1000 )
		    {
		        if ( p_info [ playerid ] [ taxi_okey ] == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже выполняете заказ." ) ;
		    
		        list_item = list_item - 1000 ;
		        p_info [ playerid ] [ taxi_accept ] [ list_item ] = false ;
		        p_info [ playerid ] [ taxi_okey ] = true ;

                new _random = p_info [ playerid ] [ taxi_okey_actor ] = p_info [ playerid ] [ taxi_actor_id ] [ list_item ] ;
				if ( actor_pos_toggled [ _random ] == true )
				{
					SendClientMessage ( playerid, 0xFF6600FF, !"К сожалению, Вы не успели принять заказ. Ожидайте новый заказ." ) ;
					p_info [ playerid ] [ taxi_cooldown ] = 300 ;
					
					p_info [ playerid ] [ taxi_okey ] = false ;
					return 1 ;
				}
		    
		        actor_pos_toggled [ _random ] = true ;
		        p_info [ playerid ] [ taxi_actor ] = CreateActor ( 255, actor_pos [ _random ] [ 0 ], actor_pos [ _random ] [ 1 ], actor_pos [ _random ] [ 2 ], actor_pos [ _random ] [ 3 ] ) ;

			    is_gps_used { playerid } = 16 ;
				SetPlayerRaceCheckpoint ( playerid, 1, actor_pos [ _random ] [ 0 ], actor_pos [ _random ] [ 1 ], actor_pos [ _random ] [ 2 ] - 1.4, 0.0, 0.0, 0.0, 8.0 ) ;
				SendClientMessage ( playerid, 0xFFCC00FF, !"Место, где Вам нужно забрать клиента отмечено на карте." ) ;

				p_info [ playerid ] [ taxi_cooldown ] = 300 ;
				p_info [ playerid ] [ taxi_accept_cooldown ] = 600 ;
				veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_player_driver ] = playerid ;
				
				new scm_string [ 30 + 32 + ( MAX_PLAYER_NAME * 2 ) ] ; // taxi edit 2
				format ( scm_string, sizeof scm_string, "[%s] %s принял(а) заказ %s.", b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_name ], p_info [ playerid ] [ name ], actor_name [ p_info [ playerid ] [ taxi_actor_name ] [ list_item ] ] ) ;
				foreach(new i: logged_players) if ( p_info [ i ] [ job ] == p_info [ playerid ] [ job ] ) SendClientMessage ( i, 0xAA3333FF, scm_string ) ;
				
				p_info [ playerid ] [ taxi_order ] ++ ;
				update_int_sql ( playerid, "u_taxi_order", p_info [ playerid ] [ taxi_order ] ) ;
		        return 1 ;
		    }
		    
		    is_gps_used { playerid } = 1 ;
			SetPlayerRaceCheckpoint ( playerid, 1, p_t_info [ list_item ] [ p_pos ] [ 0 ], p_t_info [ list_item ] [ p_pos ] [ 1 ], p_t_info [ list_item ] [ p_pos ] [ 2 ] - 1.4, 0.0, 0.0, 0.0, 8.0 ) ;
			SendClientMessage ( playerid, 0xFFCC00FF, !"Место, где Вам нужно забрать клиента отмечено на карте." ) ;

			new scm_string [ 30 + 32 + ( MAX_PLAYER_NAME * 2 ) ] ; // taxi edit 2
			format ( scm_string, sizeof scm_string, "[%s] %s принял(а) заказ %s.", b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_name ], p_info [ playerid ] [ name ], p_info [ list_item ] [ name ] ) ;
			foreach(new i: logged_players) if ( p_info [ i ] [ job ] == p_info [ playerid ] [ job ] ) SendClientMessage ( i, 0xAA3333FF, scm_string ) ;
			
			p_info [ playerid ] [ taxi_order ] ++ ;
			update_int_sql ( playerid, "u_taxi_order", p_info [ playerid ] [ taxi_order ] ) ;
			
			call_taxi { list_item } = 0 ;
		}
	    case d_service_taxi:
		{
			//if ( ! p_info [ playerid ] [ number ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У вас нет телефона." ) ;
			//if ( ! p_t_info [ playerid ] [ phone_toggled ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У вас отключен мобильный телефон." ) ;
			//if ( p_t_info [ playerid ] [ phone_id ] != INVALID_PLAYER_ID || is_ether_calling { playerid } != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Закончите текущий разговор." ) ;
			if ( ! response ) return 1 ;
			if ( call_taxi { playerid } == 1 ) return SendClientMessage(playerid, 0xFF6600FF, !"Вы уже вызывали такси." ) ;
			if ( GetPlayerInterior ( playerid ) != 0 ) return SendClientMessage(playerid, 0xFF6600FF, !"Не удалось определить Ваше местоположение. Выйдите из помещения." ) ;
			if ( GetPlayerVirtualWorld ( playerid ) != 0 ) return SendClientMessage(playerid, 0xFF6600FF, !"Не удалось определить Ваше местоположение. Выйдите из помещения." ) ;

			if ( strlen ( inputtext ) < 6 || strlen ( inputtext ) > 20 ) return show_dialog ( playerid, d_service_taxi, DIALOG_STYLE_INPUT, "{FFCC00}Вызвать такси", "{FFFFFF}Опишите место где вы находитесь\n{828282}* Сообщение должно состоять из 6 до 20 символов.", "Принять", "Назад");

			call_taxi { playerid } = 1 ;

            new full = 0 ;
			foreach(new i : logged_players)
			{
			    new vehicle_id = GetPlayerVehicleID ( i ) ;
			    if ( vehicle_id == 0 ) continue ;
			    if ( veh_info [ vehicle_id - 1 ] [ v_type ] == vehicle_type_taxi && veh_info [ vehicle_id - 1 ] [ v_owner ] == p_info [ i ] [ job ] )
				{
				    new scm_string [ 144 ] ;
					format ( scm_string, 144, "* Диспетчер: Вам вызов от %s. Местоположение: %s.", p_info [ playerid ] [ name ], inputtext ) ;
					SendClientMessage(i, 0x14A3FFFF, scm_string ) ;
					format ( scm_string, 144, "* Диспетчер: Расстояние %.1f метр(ов). Введите {FFFFFF}\"/gotaxi\"{14A3FF} чтоб принять вызов.", GetPlayerDistanceFromPoint ( i, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ] ) ) ;
					SendClientMessage(i, 0x14A3FFFF, scm_string ) ;

					full ++ ;
				}
			}
			if ( ! full ) SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент нет таксистов на дежурстве." ) ;
			else SendClientMessage ( playerid, -1, "Ваш запрос был отправлен диспетчеру такси. Ожидайте ответа." ) ;
			return 1 ;
		}
	    case d_taxi_mark:
		{
			new mapmark = GetPVarInt ( playerid, "map_mark" ) ;
			if ( mapmark == 2 )
			{
				if ( ! response ) return show_dialog ( playerid, d_taxi_mark, DIALOG_STYLE_LIST, "{FFCC00}Навигатор таксиста", "{FFCC00}1. {FFFFFF}Установить метку на карте\n{FFCC00}2. {FFFFFF}Установить метку из GPS навигатора\n{828282}Продолжать поездку без навигатора", "Выбрать", "Закрыть" ), DeletePVar ( playerid, "map_mark" ) ;
				new driverid = veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_driver ] ;
				switch ( listitem )
				{
					case 0: SetPlayerRaceCheckpoint ( driverid, 1, 1481.2469, -1743.4403, 13.5469, 0.0, 0.0, 0.0, 2.0 ) ; // Мэрия
					case 1: SetPlayerRaceCheckpoint ( driverid, 1, 1375.9095, -1088.4717, 25.9133, 0.0, 0.0, 0.0, 2.0 ) ; // Банк Los-Santos
					case 2: SetPlayerRaceCheckpoint ( driverid, 1, -2047.2146, -231.3838, 35.4309, 0.0, 0.0, 0.0, 2.0 ) ; // Автошкола
					case 3: SetPlayerRaceCheckpoint ( driverid, 1, 2645.9961, -2428.7090, 13.2651, 0.0, 0.0, 0.0, 2.0 ) ; // Порт
					case 4: SetPlayerRaceCheckpoint ( driverid, 1, 596.7739, 868.2286, -43.0937, 0.0, 0.0, 0.0, 2.0 ) ; // Шахта
					case 5: SetPlayerRaceCheckpoint ( driverid, 1, -50.2125, -282.1606, 5.4297, 0.0, 0.0, 0.0, 2.0 ) ; // Завод
					case 6: SetPlayerRaceCheckpoint ( driverid, 1, 1025.9675, -358.8767, 74.6368, 0.0, 0.0, 0.0, 2.0 ) ; // Лесопилка
				}
				SendClientMessage ( playerid, -1, "{"#cGInfo"}* {FFFFFF}Вы успешно задали метку водителю." ) ;
				DeletePVar ( playerid, "map_mark" ) ;
				is_gps_used { driverid } = 1 ;
			}
			if ( ! response )
			{
				DeletePVar ( playerid, "map_mark" ) ;
				SendClientMessage(playerid, 0xFF6600FF, !"Вы не выбрали способ движения или пункт назначения." ) ;
				return RemovePlayerFromVehicle ( playerid ) ;
			}
			if ( ! mapmark )
			{
				switch ( listitem )
				{
					case 0:
					{
						SetPVarInt ( playerid, "map_mark", 1 ) ;
						SendClientMessage ( playerid, -1, "{14A3FF}* {FFFFFF}Установить метку на карте (ESC - Карта - ПКМ)." ) ;
					}
					case 1:
					{
						SetPVarInt ( playerid, "map_mark", 2 ) ;
						return show_dialog ( playerid, d_taxi_mark, DIALOG_STYLE_LIST, "{FFCC00}Навигатор такси", "{FFCC00}1. {FFFFFF}Мэрия Лос - Сантос\n{FFCC00}2. {FFFFFF}Банк Лос - Сантос\n{FFCC00}3. {FFFFFF}Автошкола\n{FFCC00}4. {FFFFFF}Порт\n{FFCC00}5. {FFFFFF}Шахта\n{FFCC00}6. {FFFFFF}Завод\n{FFCC00}7. {FFFFFF}Лесопилка", "Выбор", "Закрыть" ) ;
					}
				}
			}
			return 1 ;
		}
	    case d_business_invite:
        {
            if ( ! response )
            {
                clear_sell_params ( playerid, seller_id [ playerid ] ) ;
                return 1 ;
            }

			new target_id = seller_id [ playerid ] ;
			
			new _b_id ;
			if ( p_info [ target_id ] [ deputy ] != -1 ) _b_id = p_info [ target_id ] [ deputy ] ;
			else _b_id = p_info [ target_id ] [ business ] ;
			
			p_info [ playerid ] [ job ] = _b_id ;
			update_int_sql ( playerid, "u_job", p_info [ playerid ] [ job ] ) ;

			new _t_string [ 44 + MAX_PLAYER_NAME + 32 ] ;
            format ( _t_string, sizeof ( _t_string ), "Вы приняли на работу %s в предприятие %s!", p_info [ playerid ] [ name ], b_info [ _b_id - 1 ] [ b_name ] ) ;
 			SendClientMessage ( target_id, -1, _t_string ) ;

 			format ( _t_string, sizeof ( _t_string ), "%s принял Вас на работу в предприятие %s!", p_info [ target_id ] [ name ], b_info [ _b_id - 1 ] [ b_name ] ) ;
 			SendClientMessage ( playerid, -1, _t_string ) ;
 			
 			clear_sell_params ( playerid, target_id ) ;
        }
	    case d_b_panel:
	    {
	        if ( ! response ) return 1 ;

	        new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
			
			if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )
			{
		        if ( listitem == 0 )
		        {
			        global_string [ 0 ] = EOS ;
				    new line_string [ 128 ], _cars_count = Iter_Count(business_taxi[_b_id]) ;
					format ( line_string, sizeof line_string, "{FFFFFF}Буксировка всего транспорта\t{99cc00}%d$\n", price_fixcar * _cars_count ) ;
					strcat ( global_string, line_string ) ;

					new veh_point = 0 ;
				    foreach(new vehicleid: business_taxi[_b_id])
				    {
						if ( ! IsValidVehicle ( vehicleid ) ) continue ;

						new scm_driver [ MAX_PLAYER_NAME + 10 ] ;
						if ( veh_info [ vehicleid - 1 ] [ v_driver ] != INVALID_VEHICLE_ID ) format ( scm_driver, sizeof scm_driver, "{828282}%s", p_info [ veh_info [ vehicleid - 1 ] [ v_driver ] ] [ name ] ) ;
						else format ( scm_driver, sizeof scm_driver, "" ) ;

						format ( line_string, sizeof ( line_string ), "{FFFFFF}%d. %s\t{99cc00}%d$ %s\n", veh_point, vehicle_name [ veh_info [ vehicleid - 1 ] [ v_model ] - 400 ], price_fixcar, scm_driver ) ;
						strcat ( global_string, line_string ) ;

						veh_point ++ ;
					}

					if ( _cars_count == 10 ) { }
					else
					{
						format ( line_string, sizeof line_string, "{828282}Покупка транспорта ({FFFFFF}%s за %d${828282})", vehicle_name [ taxi_cars [ 0 ] [ 0 ] - 400 ], taxi_cars [ 0 ] [ 1 ] ) ;
						strcat ( global_string, line_string ) ;
					}
					SetPVarInt ( playerid, "veh_point", veh_point ) ;

					show_dialog ( playerid, d_biz_fixcar, DIALOG_STYLE_TABLIST, "{FFCC00}Управление автопарком", global_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 1 )
				{
				    new dialog_string [ 500 ] ;
					new business_status [ 19 + 1 ] = "{"#cRD"}Закрыт" ;
					if ( ! b_info [ _b_id - 1 ] [ b_close ] ) business_status = "{99cc00}Открыт" ;
					format ( dialog_string, 500,
					"{FFCC00}** %s **{828282}\n\nНа счету бизнеса: {FFFFFF}%d${828282}\nЦена за 1км: {FFFFFF}%d${828282}\nКомиссия трахопарка за заказ: {FFFFFF}%d%%{828282}\nУровень трахопарка: {FFFFFF}%d{828282}\nОсталось поездок до нового уровня: {FFFFFF}%d{828282}\nКонтроль: {FFFFFF}%s{828282}\nСостояние: {FFFFFF}%s{828282}",
					b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_money ], b_info [ _b_id - 1 ] [ b_taxi_fare ], b_info [ _b_id - 1 ] [ b_cost ], b_info [ _b_id - 1 ] [ b_taxi_level ], 100 - b_info [ _b_id - 1 ] [ b_taxi_licenses ] ) ; // taxi 4321 //, f_info [ b_info [ _b_id - 1 ] [ b_mafia ] - 1 ] [ f_name ], business_status ) ;

	                show_dialog ( playerid, d_bpanel_info, DIALOG_STYLE_MSGBOX, "{FFCC00}Информация о бизнесе", dialog_string, "Назад", "Закрыть" ) ;
				}
				else if ( listitem == 2 )
				{
				    new dialog_string [ 125 + 32 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент Ваш трахопарк называется {FFCC00}%s{FFFFFF}.\n\n{828282}* Введите новое название трахопарка:", b_info [ _b_id - 1 ] [ b_name ] ) ;
				    show_dialog ( playerid, d_bpanel_setname, DIALOG_STYLE_INPUT, "{FFCC00}Название", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 3 )
				{
				    new dialog_string [ 122 + 9 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент цена за 1км составляет {FFCC00}%d${FFFFFF}.\n\n{828282}* Введите новую стоимость за 1 км:", b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
				    show_dialog ( playerid, d_bpanel_fare, DIALOG_STYLE_INPUT, "{FFCC00}Стоимость 1км", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 4 )
				{
				    new dialog_string [ 131 + 2 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент комиссия автопарку составляет {FFCC00}%d%%{FFFFFF}.\n\n{828282}* Введите новую комиссию автопарку:", b_info [ _b_id - 1 ] [ b_cost ] ) ;
				    show_dialog ( playerid, d_bpanel_com, DIALOG_STYLE_INPUT, "{FFCC00}Комиссия", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 5 )
				{
					new deputy_string [ 20 + MAX_PLAYER_NAME ] ;
				    if ( GetString ( b_info [ _b_id - 1 ] [ b_deputy ], "none" ) ) format ( deputy_string, sizeof deputy_string, "Не выбран" ) ;
				    else
				    {
				        new _pl_id ;
						sscanf ( b_info [ _b_id - 1 ] [ b_deputy ], "u", _pl_id ) ;

						if ( IsPlayerConnected ( _pl_id ) ) format ( deputy_string, sizeof deputy_string, "%s (В игре)", b_info [ _b_id - 1 ] [ b_deputy ] ) ;
						else  format ( deputy_string, sizeof deputy_string, "%s (Не в игре)", b_info [ _b_id - 1 ] [ b_deputy ] ) ;
				    }

				    new dialog_string [ 142 + sizeof deputy_string ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент Ваш заместитель {FFCC00}%s{FFFFFF}.\n\n{828282}* Введите ID игрока, если хотите назначить нового заместителя:", deputy_string ) ;
				    show_dialog ( playerid, d_bpanel_deputy, DIALOG_STYLE_INPUT, "{FFCC00}Заместитель", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 6 )
				{
				    new _b_id ;
					if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
					else _b_id = p_info [ playerid ] [ business ] ;

				    page_count [ playerid ] = 1 ;

					new query_string [ 52 + 9 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
				}
				else if ( listitem == 7 )
				{
				    new dialog_string [ 256 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFCC00}1. {FFFFFF}Принятие через пикап (%s{FFFFFF})\n\
																	{FFCC00}2. {FFFFFF}Уровень для приёма ({99cc00}%d{FFFFFF})\n\
																	{FFCC00}3. {FFFFFF}Водительские права (%s{FFFFFF})",
					( b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ] ) ? ( "{99cc00}Доступно" ) : ( "{FF6600}Не доступно" ),
					b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 1 ],
					( b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 2 ] ) ? ( "{99cc00}Требуются" ) : ( "{FF6600}Не требуются" ) ) ;
					show_dialog ( playerid, d_bpanel_settings_taxi, DIALOG_STYLE_LIST, "{FFCC00}Параметры", dialog_string, "Выбрать", "Закрыть" ) ;
				}
				else if ( listitem == 8 ) // Продажа
				{
	                if ( p_info [ playerid ] [ deputy ] != -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Данный раздел доступен только владельцу." ) ;
				}
			}
			else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus )// bus
			{
		        if ( listitem == 0 )
		        {
			        global_string [ 0 ] = EOS ;
				    new line_string [ 128 ], _cars_count = Iter_Count(business_taxi[_b_id]) ;
					format ( line_string, sizeof line_string, "{FFFFFF}Буксировка всего транспорта\t{99cc00}%d$\n", price_fixcar * _cars_count ) ;
					strcat ( global_string, line_string ) ;

					new veh_point = 1 ;
				    foreach(new vehicleid: business_taxi[_b_id])
				    {
						if ( ! IsValidVehicle ( vehicleid ) ) continue ;

						new scm_driver [ MAX_PLAYER_NAME + 10 ] ;
						if ( veh_info [ vehicleid - 1 ] [ v_driver ] != INVALID_VEHICLE_ID ) format ( scm_driver, sizeof scm_driver, "{828282}%s", p_info [ veh_info [ vehicleid - 1 ] [ v_driver ] ] [ name ] ) ;
						else format ( scm_driver, sizeof scm_driver, "" ) ;

						format ( line_string, sizeof ( line_string ), "{FFFFFF}%d. %s\t{99cc00}%d$ %s\n", veh_point, vehicle_name [ veh_info [ vehicleid - 1 ] [ v_model ] - 400 ], price_fixcar, scm_driver ) ;
						strcat ( global_string, line_string ) ;

						veh_point ++ ;
					}

					if ( _cars_count == 10 ) { }
					else
					{
						format ( line_string, sizeof line_string, "{828282}Покупка транспорта ({FFFFFF}%s за %d${828282})", vehicle_name [ bus_cars [ 0 ] [ 0 ] - 400 ], taxi_cars [ 0 ] [ 1 ] ) ;
						strcat ( global_string, line_string ) ;
					}
					SetPVarInt ( playerid, "veh_point", veh_point ) ;

					show_dialog ( playerid, d_biz_fixcar, DIALOG_STYLE_TABLIST, "{FFCC00}Управление автопарком", global_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 1 )
				{
				    new dialog_string [ 500 ] ;
					new business_status [ 19 + 1 ] = "{"#cRD"}Закрыт" ;
					if ( ! b_info [ _b_id - 1 ] [ b_close ] ) business_status = "{99cc00}Открыт" ;
					format ( dialog_string, 500,
					"{FFCC00}** %s **{828282}\n\nНа счету бизнеса: {FFFFFF}%d${828282}\nКомиссия парка за заказ: {FFFFFF}%d%%{828282}\nУровень парка: {FFFFFF}%d{828282}\nКонтроль: {FFFFFF}%s{828282}\nСостояние: {FFFFFF}%s{828282}",
					b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_money ], b_info [ _b_id - 1 ] [ b_cost ], b_info [ _b_id - 1 ] [ b_taxi_level ] ) ;//, f_info [ b_info [ _b_id - 1 ] [ b_mafia ] - 1 ] [ f_name ], business_status ) ;

	                show_dialog ( playerid, d_bpanel_info, DIALOG_STYLE_MSGBOX, "{FFCC00}Информация о бизнесе", dialog_string, "Назад", "Закрыть" ) ;
				}
				else if ( listitem == 2 )
				{
				    new dialog_string [ 125 + 32 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент Ваш трахопарк называется {FFCC00}%s{FFFFFF}.\n\n{828282}* Введите новое название трахопарка:", b_info [ _b_id - 1 ] [ b_name ] ) ;
				    show_dialog ( playerid, d_bpanel_setname, DIALOG_STYLE_INPUT, "{FFCC00}Название", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 3 )
				{
				    new dialog_string [ 131 + 2 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент комиссия автопарку составляет {FFCC00}%d%%{FFFFFF}.\n\n{828282}* Введите новую комиссию автопарку:", b_info [ _b_id - 1 ] [ b_cost ] ) ;
				    show_dialog ( playerid, d_bpanel_com, DIALOG_STYLE_INPUT, "{FFCC00}Комиссия", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 4 )
				{
					new deputy_string [ 20 + MAX_PLAYER_NAME ] ;
				    if ( GetString ( b_info [ _b_id - 1 ] [ b_deputy ], "none" ) ) format ( deputy_string, sizeof deputy_string, "Не выбран" ) ;
				    else
				    {
				        new _pl_id ;
						sscanf ( b_info [ _b_id - 1 ] [ b_deputy ], "u", _pl_id ) ;

						if ( IsPlayerConnected ( _pl_id ) ) format ( deputy_string, sizeof deputy_string, "%s (В игре)", b_info [ _b_id - 1 ] [ b_deputy ] ) ;
						else  format ( deputy_string, sizeof deputy_string, "%s (Не в игре)", b_info [ _b_id - 1 ] [ b_deputy ] ) ;
				    }

				    new dialog_string [ 142 + sizeof deputy_string ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент Ваш заместитель {FFCC00}%s{FFFFFF}.\n\n{828282}* Введите ID игрока, если хотите назначить нового заместителя:", deputy_string ) ;
				    show_dialog ( playerid, d_bpanel_deputy, DIALOG_STYLE_INPUT, "{FFCC00}Заместитель", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 5 )
				{
				    new _b_id ;
					if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
					else _b_id = p_info [ playerid ] [ business ] ;

				    page_count [ playerid ] = 1 ;

					new query_string [ 52 + 9 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
				}
				else if ( listitem == 6 )
				{
				    new dialog_string [ 256 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFCC00}1. {FFFFFF}Принятие через пикап (%s{FFFFFF})\n\
																	{FFCC00}2. {FFFFFF}Уровень для приёма ({99cc00}%d{FFFFFF})\n\
																	{FFCC00}3. {FFFFFF}Водительские права (%s{FFFFFF})",
					( b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ] ) ? ( "{99cc00}Доступно" ) : ( "{FF6600}Не доступно" ),
					b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 1 ],
					( b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 2 ] ) ? ( "{99cc00}Требуются" ) : ( "{FF6600}Не требуются" ) ) ;
					show_dialog ( playerid, d_bpanel_settings_taxi, DIALOG_STYLE_LIST, "{FFCC00}Параметры", dialog_string, "Выбрать", "Закрыть" ) ;
				}
				else if ( listitem == 7 ) // Продажа
				{
	                if ( p_info [ playerid ] [ deputy ] != -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Данный раздел доступен только владельцу." ) ;
				}
			}
			else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering )
			{
		        if ( listitem == 0 )
		        {
			        global_string [ 0 ] = EOS ;
				    new line_string [ 128 ], _cars_count = Iter_Count(business_taxi[_b_id]) ;
					format ( line_string, sizeof line_string, "{FFFFFF}Буксировка всего транспорта\t{99cc00}%d$\n", price_fixcar * _cars_count ) ;
					strcat ( global_string, line_string ) ;

					new veh_point = 1 ;
				    foreach(new vehicleid: business_taxi[_b_id])
				    {
						if ( ! IsValidVehicle ( vehicleid ) ) continue ;

						new scm_driver [ MAX_PLAYER_NAME + 10 ] ;
						if ( veh_info [ vehicleid - 1 ] [ v_driver ] != INVALID_VEHICLE_ID ) format ( scm_driver, sizeof scm_driver, "{828282}%s", p_info [ veh_info [ vehicleid - 1 ] [ v_driver ] ] [ name ] ) ;
						else format ( scm_driver, sizeof scm_driver, "" ) ;

						format ( line_string, sizeof ( line_string ), "{FFFFFF}%d. %s\t{99cc00}%d$ %s\n", veh_point, vehicle_name [ veh_info [ vehicleid - 1 ] [ v_model ] - 400 ], price_fixcar, scm_driver ) ;
						strcat ( global_string, line_string ) ;

						veh_point ++ ;
					}

					if ( _cars_count == 10 ) { }
					else
					{
						format ( line_string, sizeof line_string, "{828282}Покупка транспорта ({FFFFFF}%s за %d${828282})", vehicle_name [ carsh_cars [ 0 ] [ 0 ] - 400 ], carsh_cars [ 0 ] [ 1 ] ) ;
						strcat ( global_string, line_string ) ;
					}
					SetPVarInt ( playerid, "veh_point", veh_point ) ;

					show_dialog ( playerid, d_biz_fixcar, DIALOG_STYLE_TABLIST, "{FFCC00}Управление автопарком", global_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 1 )
				{
				    new dialog_string [ 500 ] ;
					new business_status [ 19 + 1 ] = "{"#cRD"}Закрыт" ;
					if ( ! b_info [ _b_id - 1 ] [ b_close ] ) business_status = "{99cc00}Открыт" ;
					format ( dialog_string, 500,
					"{FFCC00}** %s **{828282}\n\nНа счету бизнеса: {FFFFFF}%d${828282}\nСтоимость проезда за 1км: {FFFFFF}%d${828282}\nКонтроль: {FFFFFF}%s{828282}\nСостояние: {FFFFFF}%s{828282}",
					b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_money ], b_info [ _b_id - 1 ] [ b_cost ] ) ;//, f_info [ b_info [ _b_id - 1 ] [ b_mafia ] - 1 ] [ f_name ], business_status ) ;

	                show_dialog ( playerid, d_bpanel_info, DIALOG_STYLE_MSGBOX, "{FFCC00}Информация о бизнесе", dialog_string, "Назад", "Закрыть" ) ;
				}
				else if ( listitem == 2 )
				{
				    new dialog_string [ 125 + 32 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент Ваш автопарк называется {FFCC00}%s{FFFFFF}.\n\n{828282}* Введите новое название трахопарка:", b_info [ _b_id - 1 ] [ b_name ] ) ;
				    show_dialog ( playerid, d_bpanel_setname, DIALOG_STYLE_INPUT, "{FFCC00}Название", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 3 )
				{
				    new dialog_string [ 122 + 9 ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент цена за 1км составляет {FFCC00}%d${FFFFFF}.\n\n{828282}* Введите новую стоимость за 1 км:", b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
				    show_dialog ( playerid, d_bpanel_fare, DIALOG_STYLE_INPUT, "{FFCC00}Стоимость 1км", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 4 )
				{
					new deputy_string [ 20 + MAX_PLAYER_NAME ] ;
				    if ( GetString ( b_info [ _b_id - 1 ] [ b_deputy ], "none" ) ) format ( deputy_string, sizeof deputy_string, "Не выбран" ) ;
				    else
				    {
				        new _pl_id ;
						sscanf ( b_info [ _b_id - 1 ] [ b_deputy ], "u", _pl_id ) ;

						if ( IsPlayerConnected ( _pl_id ) ) format ( deputy_string, sizeof deputy_string, "%s (В игре)", b_info [ _b_id - 1 ] [ b_deputy ] ) ;
						else  format ( deputy_string, sizeof deputy_string, "%s (Не в игре)", b_info [ _b_id - 1 ] [ b_deputy ] ) ;
				    }

				    new dialog_string [ 142 + sizeof deputy_string ] ;
				    format ( dialog_string, sizeof dialog_string, "{FFFFFF}В данный момент Ваш заместитель {FFCC00}%s{FFFFFF}.\n\n{828282}* Введите ID игрока, если хотите назначить нового заместителя:", deputy_string ) ;
				    show_dialog ( playerid, d_bpanel_deputy, DIALOG_STYLE_INPUT, "{FFCC00}Заместитель", dialog_string, "Выбрать", "Назад" ) ;
				}
				else if ( listitem == 5 ) // Продажа
				{
	                if ( p_info [ playerid ] [ deputy ] != -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Данный раздел доступен только владельцу." ) ;
				}
			}
	    }
	    case d_bpanel_settings_taxi: // taxi new
	    {
	        if ( ! response ) return callcmd::bpanel1 ( playerid ) ;
	        
	        new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
	        
	        if ( listitem == 0 )
	        {
	            if ( b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ] ) b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ] = 0 ;
	            else b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ] = 1 ;

	            new scm_string [ 45 + 12 ] ;
	            format ( scm_string, sizeof scm_string, "Вы %s автоматическое устройство на работу.", ( b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ] ) ? ( "включили" ) : ( "отключили" ) ) ;
	            SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
	            
	            new sql_string [ 110 ] ;
	            format ( sql_string, sizeof sql_string, "UPDATE `businesses` SET `b_taxi_auto_invite` = '%d|%d|%d' WHERE `b_id` = '%d' LIMIT 1",
	            b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ], b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 1 ], b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 2 ], _b_id ) ;
				mysql_tquery ( sql_connection, sql_string ) ;
	            
	        	callcmd::bpanel1 ( playerid ) ;
	        }
	        else if ( listitem == 1 )
	        {
	            show_dialog ( playerid, d_bpanel_settings_level, DIALOG_STYLE_INPUT, "{FFCC00}Параметры", "{FFFFFF}Укажите уровень, с которого можно устроиться на работу:", "Выбрать", "Закрыть" ) ;
	        }
	        else if ( listitem == 2 )
	        {
	            if ( b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 2 ] ) b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 2 ] = 0 ;
	            else b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 2 ] = 1 ;

	            new scm_string [ 45 + 12 ] ;
	            format ( scm_string, sizeof scm_string, "Вы %s проверку на водительские права при устройстве.", ( b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ] ) ? ( "включили" ) : ( "отключили" ) ) ;
	            SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
	            
	            new sql_string [ 110 ] ;
	            format ( sql_string, sizeof sql_string, "UPDATE `businesses` SET `b_taxi_auto_invite` = '%d|%d|%d' WHERE `b_id` = '%d' LIMIT 1",
	            b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ], b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 1 ], b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 2 ], _b_id ) ;
				mysql_tquery ( sql_connection, sql_string ) ;
				
	        	callcmd::bpanel1 ( playerid ) ;
	        }
	    }
	    case d_bpanel_settings_level: // taxi new
	    {
			if ( ! response ) return callcmd::bpanel1 ( playerid ) ;
			
			if ( strval ( inputtext ) < 1 || strval ( inputtext ) > 10 )
			{
			    show_dialog ( playerid, d_bpanel_settings_level, DIALOG_STYLE_INPUT, "{FFCC00}Параметры", "{FF6600}* Минимальный уровень 1, а максимальный 10\n\n{FFFFFF}Укажите уровень, с которого можно устроиться на работу:", "Выбрать", "Закрыть" ) ;
			    return 1 ;
			}
			
			new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
			
			b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 1 ] = strval ( inputtext ) ;
			
			new sql_string [ 110 ] ;
	        format ( sql_string, sizeof sql_string, "UPDATE `businesses` SET `b_taxi_auto_invite` = '%d|%d|%d' WHERE `b_id` = '%d' LIMIT 1",
	        b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 0 ], b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 1 ], b_info [ _b_id - 1 ] [ b_taxi_auto_invite ] [ 2 ], _b_id ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
			
			callcmd::bpanel1 ( playerid ) ;
	    }
	    case d_offmembers_list:
		{
			if ( ! response )
			{
				for ( new i = 0 ; i < 10 ; i ++ )
				{
					new pvar_string [ 8 ] ;
					format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i ) ;
					DeletePVar ( playerid, pvar_string ) ;
				}
				page_count [ playerid ] = 0 ;
				page_rows [ playerid ] = 0 ;
				DeletePVar ( playerid, "ofm_listitem" ) ;
				DeletePVar ( playerid, "ofm_type" ) ;
				callcmd::bpanel1 ( playerid ) ;
				return 1 ;
			}

			new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;

			if ( listitem == get_player_use_page ( playerid, 0 ) )
			{
			    clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1 ;
				if ( page_id == 0 )
				{
					SendClientMessage ( playerid, 0xFF6600FF, !"Вы находитесь на первой странице списка членов компании." ) ;
					
					new query_string [ 52 + 9 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
					return 1 ;

				}
				page_count [ playerid ] = page_id ;

				new query_string [ 52 + 9 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
				mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;

			}
			else if ( listitem == get_player_use_page ( playerid, 1 ) )
			{
			    clear_player_use_page ( playerid ) ;
				new page_id = page_count [ playerid ] - 1 ;
				if ( ofm_formula ( page_id ) >= page_rows [ playerid ] )
				{
					SendClientMessage ( playerid, 0xFF6600FF, !"Вы находитесь на последней странице списка членов компании." ) ;
					
					new query_string [ 52 + 9 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
					return 1 ;
				}
				
				page_count [ playerid ] = page_id + 2 ;
				
				new query_string [ 52 + 9 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
				mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
			}
			else
			{
				new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
				format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", listitem ) ;
				GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;
				SetPVarInt ( playerid, "ofm_listitem", listitem ) ;

				show_dialog ( playerid, d_offmembers_pl_menu, DIALOG_STYLE_LIST, pl_name, "Уволить\nСтатистика", "Выбрать", "Назад" ) ;
			}
			return 1 ;
		}
		case d_offmembers_pl_menu:
		{
		    if ( ! response )
		    {
		        new _b_id ;
				if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
				else _b_id = p_info [ playerid ] [ business ] ;
		    
		        new query_string [ 52 + 9 ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
				mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
				return 1 ;
		    }
		    
		    if ( listitem == 0 )
		    {
		        new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
				format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
				GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

				new dialog_string [ 62 + MAX_PLAYER_NAME ] ;
				format ( dialog_string, sizeof dialog_string, "{FFFFFF}Вы действительно хотите уволить {FFCC00}%s{FFFFFF}?", pl_name ) ;
				show_dialog ( playerid, d_offmembers_uninvite, DIALOG_STYLE_MSGBOX, "{FFCC00}Увольнение", dialog_string, "Выбрать", "Назад" ) ;
		    }
		    else if ( listitem == 1 )
		    {
		        new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
				format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
				GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;
				
				new u_id = GetPlayerListitemValue ( playerid, GetPVarInt ( playerid, "ofm_listitem" ) ) ;// edit 123

		        new query_string [ 61 + MAX_PLAYER_NAME ] ;
				mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT * FROM `users` WHERE `u_id` = '%d' LIMIT 1", u_id ) ;// edit 123
				mysql_tquery ( sql_connection, query_string, "callback_offtaxi_info", "i", playerid ) ;
		    }
		}
		case d_offmembers_pl_menu1:
		{
  			new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;

		    new query_string [ 52 + 9 ] ;
			mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
			mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
			return 1 ;
		}
		case d_offmembers_uninvite:
		{
		    new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
			format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
			GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;
		
		    new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
		
		    new u_id = GetPlayerListitemValue ( playerid, GetPVarInt ( playerid, "ofm_listitem" ) ) ;// edit 123
		
		    new _pl_id = -1 ;
			foreach(new i: logged_players) // edit 123
			{
			    if ( p_info [ i ] [ id ] != u_id ) continue ;
			    
			    _pl_id = i ;
			    break ;
			}
			
			if ( _pl_id != -1 )
			{
			   	if ( playerid == _pl_id )
			    {
			      	SendClientMessage ( playerid, 0xFF6600FF, !"Вы не можете применить это действие к себе." ) ;

			        DeletePVar ( playerid, "ofm_listitem" ) ;
			        
					new query_string [ 52 + 9 ] ;
					mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
					mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
				    return 1 ;
			    }

			   	new clf_string [ 3 + 24 ] ;
	    		format ( clf_string, sizeof clf_string, "%d Без уточнения причины", _pl_id ) ;
				callcmd::buninvite ( playerid, clf_string ) ;
				return 1 ;
			}
			else
			{
			    new _sql_string [ 84 + MAX_PLAYER_NAME ] ;
			    format ( _sql_string, sizeof _sql_string, "UPDATE `users` SET `u_deputy` = '-1', `u_job` = '0' WHERE `u_id` = '%d' LIMIT 1", u_id ) ;// edit 123
				mysql_tquery ( sql_connection, _sql_string ) ;

			    new _t_string [ 144 ];
			    format ( _t_string, sizeof ( _t_string ), "Вы уволили {99cc00}%s {FFCC00}с работы в '%s'.", pl_name, b_info [ _b_id - 1 ] [ b_name ] ) ;
			    SendClientMessage ( playerid, 0xFFCC00FF, _t_string ) ;
			}
			
			new query_string [ 52 + 9 ] ;
			mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
			mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;
		}
	    case d_bpanel_deputy:
	    {
	        if ( ! response ) return callcmd::bpanel1 ( playerid ) ;
	        
	        new _value = strval ( inputtext ) ;
	        
	        new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
	        
			if ( ! IsPlayerConnected ( _value ) || _value == playerid )
			{
			    SendClientMessage ( playerid, 0xFF6600FF, !"Игрок не в сети." ) ;
			    callcmd::bpanel1 ( playerid ) ;
			    return 1 ;
			}
			
			if ( p_info [ _value ] [ deputy ] != -1 )
			{
			    SendClientMessage ( playerid, 0xFF6600FF, !"Игрок уже является заместителем." ) ;
			    callcmd::bpanel1 ( playerid ) ;
			    return 1 ;
			}
			
			if ( p_info [ _value ] [ business ] != -1 )
			{
			    SendClientMessage ( playerid, 0xFF6600FF, !"У игрока есть собственный бизнес." ) ;
			    callcmd::bpanel1 ( playerid ) ;
			    return 1 ;
			}
			
			buyer_id [ playerid ] = _value ;
			seller_id [ _value ] = playerid ;

			new dialog_string [ 108 + MAX_PLAYER_NAME + 32 + 1 + 6 ] ;
			format ( dialog_string, sizeof ( dialog_string  ), "{FFCC00}%s {FFFFFF}предлагает Вам стать заместителем в бизнесе {FFCC00}%s{FFFFFF}.",
			p_info [ playerid ] [ name ], b_info [ _b_id - 1 ] [ b_name ] ) ;
			show_dialog ( _value, d_b_deputy, DIALOG_STYLE_MSGBOX, "{FFCC00}Заместитель", dialog_string, "Согласен", "Отказ" ) ;

			format ( dialog_string, sizeof ( dialog_string  ), "Вы предложили {FFCC00}%s {FFFFFF}стать заместителем в бизнесе {FFCC00}%s{FFFFFF}.",
			p_info [ _value ] [ name ], b_info [ _b_id - 1 ] [ b_name ] ) ;
			SendClientMessage ( playerid, -1, dialog_string ) ;
	    }
	    case d_b_deputy:
	    {
	        if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок покинул игру." ) ;
			if ( ! response )
			{
				SendClientMessage ( seller_id [ playerid ], 0xFF6600FF, "Игрок отказался от Вашего предложения." ) ;
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			new target_id = seller_id [ playerid ], _b_id = p_info [ target_id ] [ business ] ;

			new scm_string [ 30 + MAX_PLAYER_NAME ] ;
			format ( scm_string, sizeof scm_string, "%s принял Ваше предложение!", p_info [ playerid ] [ name ] ) ;
			SendClientMessage ( target_id, 0xFFCC00FF, scm_string ) ;

			format ( scm_string, sizeof scm_string, "Вы приняли предложение %s!", p_info [ target_id ] [ name ] ) ;
			SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

			if ( ! GetString ( b_info [ _b_id - 1 ] [ b_deputy ], "none" ) ) // нахуй зама
			{
			    new _pl_id = -1 ;
			    foreach(new i: logged_players)
			    {
			        if ( b_info [ _b_id - 1 ] [ b_deputy ] != p_info [ i ] [ id ] ) continue ;
			        
			        _pl_id = i ;
			        break ;
			    }
			    if ( _pl_id != -1 ) // fix
			    {
			        p_info [ playerid ] [ deputy ] = -1 ;
					update_int_sql ( playerid, "u_deputy", p_info [ playerid ] [ deputy ] ) ;

			        new _sql_string [ 72 + MAX_PLAYER_NAME + 9 ] ;
	        		format ( _sql_string, sizeof _sql_string, "UPDATE `users` SET `u_deputy` = '-1' WHERE `u_name` = '%s' LIMIT 1", b_info [ _b_id - 1 ] [ b_deputy ] ) ;
					mysql_tquery ( sql_connection, _sql_string ) ;
			    }
			}

			format ( b_info [ _b_id - 1 ] [ b_deputy ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
			
			give_owner_job ( playerid, _b_id ) ;
			
			p_info [ playerid ] [ deputy ] = _b_id ;
			update_int_sql ( playerid, "u_deputy", p_info [ playerid ] [ deputy ] ) ;

	        new _sql_string [ 72 + MAX_PLAYER_NAME + 9 ] ;
	        format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_deputy` = '%d' WHERE `b_id` = '%d' LIMIT 1", p_info [ playerid ] [ id ], _b_id ) ; // deputy
			mysql_tquery ( sql_connection, _sql_string ) ;

			clear_sell_params ( playerid, target_id ) ;
	    }
	    case d_bpanel_com:
	    {
	        if ( ! response ) return callcmd::bpanel1 ( playerid ) ;

	        new _value = strval ( inputtext ) ;
	        
	        new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
	        
	        if ( _value < 0 || _value > 45 )
	        {
	            new dialog_string [ 190 + 2 ] ;
			    format ( dialog_string, sizeof dialog_string, "{"#cRD"}* Комиссия не может быть менее 0%% и более 45%%\n\n{FFFFFF}В данный момент комиссия автопарку составляет {FFCC00}%d%%{FFFFFF}.\n\n{828282}* Введите новую комиссию автопарку:", b_info [ _b_id - 1 ] [ b_cost ] ) ;
			    show_dialog ( playerid, d_bpanel_com, DIALOG_STYLE_INPUT, "{FFCC00}Комиссия", dialog_string, "Выбрать", "Назад" ) ;
	            return 1 ;
	        }

	        b_info [ _b_id - 1 ] [ b_cost ] = _value ;

	        new _sql_string [ 70 + 2 + 9 ] ;
	        format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_cost` = '%d' WHERE `b_id` = '%d' LIMIT 1",
			_value, _b_id ) ;
			mysql_tquery ( sql_connection, _sql_string ) ;

	        new scm_string [ 128 ] ;
	        format ( scm_string, sizeof scm_string, "Вы успешно сменили комиссию трахопарку. Новая комиссия: %d%%", _value ) ;
	        SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
	    }
	    case d_bpanel_fare:
	    {
	        if ( ! response ) return callcmd::bpanel1 ( playerid ) ;

	        new _value = strval ( inputtext ) ;
	        
	        new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
	        
	        if ( _value < 1 || _value > 100 )
	        {
	            new dialog_string [ 186 + 9 ] ;
			    format ( dialog_string, sizeof dialog_string, "{"#cRD"}* Цена на проезд не может быть менее 1$ и более 100$\n\n{FFFFFF}В данный момент цена за 1км составляет {FFCC00}%d${FFFFFF}.\n\n{828282}* Введите новую стоимость за 1 км:", b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
			    show_dialog ( playerid, d_bpanel_fare, DIALOG_STYLE_INPUT, "{FFCC00}Стоимость 1км", dialog_string, "Выбрать", "Назад" ) ;
	            return 1 ;
	        }
	        
	        b_info [ _b_id - 1 ] [ b_taxi_fare ] = _value ;

	        new _sql_string [ 75 + 9 + 9 ] ;
	        format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_taxi_fare` = '%d' WHERE `b_id` = '%d' LIMIT 1",
			_value, _b_id ) ;
			mysql_tquery ( sql_connection, _sql_string ) ;

	        new scm_string [ 128 ] ;
	        format ( scm_string, sizeof scm_string, "Вы успешно сменили стоимость за 1 км. Новая стоимость: %d$", _value ) ;
	        SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

	        if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )// bus
	        {
		        foreach(new veh_id: business_taxi[_b_id])
				{
		            if ( ! IsValidVehicle ( veh_id ) ) continue ;

		            DestroyDynamic3DTextLabel ( veh_info [ veh_id - 1 ] [ v_label ] ) ;

		            new mes [ 34 + 32 + 4 ] ;
					format ( mes, sizeof ( mes ), "** %s **\n{828282}%i$ за 1 км", b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
					veh_info [ veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( mes, 0xFFCC00FF, 0.0, 0.0, 1.5, 20.0, INVALID_PLAYER_ID, veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
		        }
			}
	    }
	    case d_bpanel_setname:
	    {
	        if ( ! response ) return callcmd::bpanel1 ( playerid ) ;

	        new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
			
	        if ( strlen ( inputtext ) < 3 || strlen ( inputtext ) > 32 )
	        {
	            new dialog_string [ 190 + 32 ] ;
			    format ( dialog_string, sizeof dialog_string, "{"#cRD"}* Название не может быть менее 3 и более 32 символов!\n\n{FFFFFF}В данный момент Ваш трахопарк называется {FFCC00}%s{FFFFFF}.\n\n{828282}* Введите новое название трахопарка:", b_info [ _b_id - 1 ] [ b_name ] ) ;
			    show_dialog ( playerid, d_bpanel_setname, DIALOG_STYLE_INPUT, "{FFCC00}Название", dialog_string, "Выбрать", "Назад" ) ;
	            return 1 ;
	        }
	        
	        format ( b_info [ _b_id - 1 ] [ b_name ], 32, "%s", inputtext ) ;

	        new _sql_string [ 70 + 32 + 9 ] ;
	        format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_name` = '%s' WHERE `b_id` = '%d' LIMIT 1",
			b_info [ _b_id - 1 ] [ b_name ], _b_id ) ;
			mysql_tquery ( sql_connection, _sql_string ) ;
	        
	        new scm_string [ 128 ] ;
	        format ( scm_string, sizeof scm_string, "Вы успешно сменили название парка. Новое название: %s", b_info [ _b_id - 1 ] [ b_name ] ) ;
	        SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
	        
	        if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )// bus
	        {
		        foreach(new veh_id: business_taxi[_b_id])
				{
		            if ( ! IsValidVehicle ( veh_id ) ) continue ;

		            DestroyDynamic3DTextLabel ( veh_info [ veh_id - 1 ] [ v_label ] ) ;

		            new mes [ 34 + 32 + 4 ] ;
					format ( mes, sizeof ( mes ), "** %s **\n{828282}%i$ за 1 км", b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
					veh_info [ veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( mes, 0xFFCC00FF, 0.0, 0.0, 1.5, 20.0, INVALID_PLAYER_ID, veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
		        }
			}
	    }
	    case d_bpanel_info:
	    {
	        if ( ! response ) return 1 ;

	        callcmd::bpanel1 ( playerid ) ;
	    }
	    case d_biz_fixcar:
	    {
	        if ( ! response ) return callcmd::bpanel1 ( playerid ) ;
	        
	        new _veh_point = GetPVarInt ( playerid, "veh_point" ) ; // fix taxi
	        DeletePVar ( playerid, "veh_point" ) ;
	        
	        new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;
					
	        if ( listitem == _veh_point )
	        {
				
				if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )// bus
				{
				    if ( Iter_Count(business_taxi[_b_id]) >= b_info [ _b_id - 1 ] [ b_taxi_level ] )
		            {
						SendClientMessage ( playerid, 0xFF6600FF, !"У Вас приобретено максимальное количество транспорта." ) ;

						callcmd::bpanel1 ( playerid ) ;
						return 1 ;
					}
				
		            if ( b_info [ _b_id - 1 ] [ b_money ] < taxi_cars [ 0 ] [ 1 ] )
					{
						SendClientMessage ( playerid, 0xFF6600FF, !"В банке бизнеса недостаточно средств." ) ;

						callcmd::bpanel1 ( playerid ) ;
						return 1 ;
					}
				}
				else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus )
				{
				    if ( Iter_Count(business_taxi[_b_id]) >= b_info [ _b_id - 1 ] [ b_taxi_level ] )
		            {
						SendClientMessage ( playerid, 0xFF6600FF, !"У Вас приобретено максимальное количество транспорта." ) ;

						callcmd::bpanel1 ( playerid ) ;
						return 1 ;
					}
				
		            if ( b_info [ _b_id - 1 ] [ b_money ] < bus_cars [ 0 ] [ 1 ] )
					{
						SendClientMessage ( playerid, 0xFF6600FF, !"В банке бизнеса недостаточно средств." ) ;

						callcmd::bpanel1 ( playerid ) ;
						return 1 ;
					}
				}
				else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering )
				{
		            if ( b_info [ _b_id - 1 ] [ b_money ] < carsh_cars [ 0 ] [ 1 ] )
					{
						SendClientMessage ( playerid, 0xFF6600FF, !"В банке бизнеса недостаточно средств." ) ;

						callcmd::bpanel1 ( playerid ) ;
						return 1 ;
					}
				}
				
				new veh_id = GetVehicleID ( ) ;
				for ( new i = 0 ; i < 10 ; i ++ )
				{
				    if ( b_info [ _b_id - 1 ] [ b_taxi_model ] [ i ] != -1 ) continue ;
				    
					veh_info [ veh_id - 1 ] [ v_id ] = b_info [ _b_id - 1 ] [ b_vehicle_id ] [ i ] ;
					
					if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )// bus
					{
						veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_taxi ;
						veh_info [ veh_id - 1 ] [ v_model ] = taxi_cars [ 0 ] [ 0 ] ;
					}
					else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus )
					{
						veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_bus ;
						veh_info [ veh_id - 1 ] [ v_model ] = bus_cars [ 0 ] [ 0 ] ;
					}
					else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering )
					{
						veh_info [ veh_id - 1 ] [ v_type ] = vehicle_type_carshering ;
						veh_info [ veh_id - 1 ] [ v_model ] = carsh_cars [ 0 ] [ 0 ] ;
					}
					
					veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = 6 ;

					veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], b_taxi_pos [ _b_id ] [ i ] [ 0 ],
																											b_taxi_pos [ _b_id ] [ i ] [ 1 ],
																											b_taxi_pos [ _b_id ] [ i ] [ 2 ],
																											b_taxi_pos [ _b_id ] [ i ] [ 3 ], 6, 6, -1 ) ;
					break ;
				}
				
	        	veh_info [ veh_id - 1 ] [ v_owner ] = _b_id ;

				Iter_Add(business_taxi[_b_id], veh_info [ veh_id - 1 ] [ v_vehicle ]);

                new scm_string [ 128 ] ;
                if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )// bus
                {
					new mes [ 34 + 32 + 4 ] ;
					format ( mes, sizeof ( mes ), "** %s **\n{828282}%i$ за 1 км", b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
					veh_info [ veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( mes, 0xFFCC00FF, 0.0, 0.0, 1.5, 20.0, INVALID_PLAYER_ID, veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
					
					format ( scm_string, sizeof scm_string, "Вы успешно приобрели %s за %d$, он находится на парковке Вашего трахопарка.", vehicle_name [ taxi_cars [ 0 ] [ 0 ] - 400 ], taxi_cars [ 0 ] [ 1 ] ) ;
					SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
					
					b_info [ _b_id - 1 ] [ b_money ] -= taxi_cars [ 0 ] [ 1 ] ;
				}
				else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus )
				{
				    format ( scm_string, sizeof scm_string, "Вы успешно приобрели %s за %d$, он находится на парковке Вашего трахопарка.", vehicle_name [ bus_cars [ 0 ] [ 0 ] - 400 ], bus_cars [ 0 ] [ 1 ] ) ;
					SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
					
					b_info [ _b_id - 1 ] [ b_money ] -= bus_cars [ 0 ] [ 1 ] ;
				}
				else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering )
				{
				    format ( scm_string, sizeof scm_string, "Вы успешно приобрели %s за %d$, он находится на парковке Вашего трахопарка.", vehicle_name [ carsh_cars [ 0 ] [ 0 ] - 400 ], carsh_cars [ 0 ] [ 1 ] ) ;
					SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
					
					b_info [ _b_id - 1 ] [ b_money ] -= carsh_cars [ 0 ] [ 1 ] ;
				}

				new _sql_string [ 89 + 6 + 9 ] ;
				format ( _sql_string, sizeof _sql_string, "UPDATE `businesses_taxi` SET `b_taxi_model` = '%d' WHERE `b_vehicle_id` = '%d' LIMIT 1",
				veh_info [ veh_id - 1 ] [ v_model ], veh_info [ veh_id - 1 ] [ v_id ] ) ;
				mysql_tquery ( sql_connection, _sql_string ) ;

				format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_money` = '%d' WHERE `b_id` = '%d' LIMIT 1",
				b_info [ _b_id - 1 ] [ b_money ], _b_id ) ;
				mysql_tquery ( sql_connection, _sql_string ) ;
	            return 1 ;
	        }
	        
	        if ( listitem == 0 )
			{
	        	if ( b_info [ _b_id - 1 ] [ b_money ] < price_fixcar * Iter_Count(business_taxi[_b_id]) )
				{
					SendClientMessage ( playerid, 0xFF6600FF, !"В банке бизнеса недостаточно средств." ) ;

					callcmd::bpanel1 ( playerid ) ;
					return 1 ;
				}
				foreach(new vehicleid: business_taxi[_b_id])
				{
					if ( ! IsValidVehicle ( vehicleid ) ) continue ;
					if ( is_vehicle_occupied ( vehicleid ) != -1 ) continue ;

					SetVehicleToRespawn ( vehicleid ) ;
					veh_info [ vehicleid - 1 ] [ v_fuel ] = 60.0 ;
				}
				SendClientMessage ( playerid, 0xFFCC00FF, !"Весь незанятый транспорт был отбуксирован." ) ;
				callcmd::bpanel1 ( playerid ) ;

				b_info [ _b_id - 1 ] [ b_money ] -= price_fixcar * Iter_Count(business_taxi[_b_id]) ;

				new _sql_string [ 71 + 9 + 9 ] ;
				format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_money` = '%d' WHERE `b_id` = '%d' LIMIT 1",
				b_info [ _b_id - 1 ] [ b_money ], _b_id ) ;
				mysql_tquery ( sql_connection, _sql_string ) ;
				return 1 ;
	        }
	        
	        if ( b_info [ _b_id - 1 ] [ b_money ] < price_fixcar ) return SendClientMessage ( playerid, 0xFF6600FF, !"В банке бизнеса недостаточно средств." ) ;

            global_string [ 0 ] = EOS ;
			new veh_point = 0 ;
			foreach(new vehicleid: business_taxi[_b_id])
			{
				if ( ! IsValidVehicle ( vehicleid ) ) continue ;
				veh_point ++ ;

				if ( listitem == veh_point )
				{
				    if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering ) format ( global_string, 156, " {828282}- {FFFFFF}Отбуксировать\n{828282}- {FFFFFF}Модель автомобиля {828282}({99cc00}%s{828282})\n{828282}- {FFFFFF}Изменить позицию", vehicle_name [ GetVehicleModel ( vehicleid ) - 400 ] ) ;
					else format ( global_string, 156, " {828282}- {FFFFFF}Отбуксировать\n{828282}- {FFFFFF}Модель автомобиля {828282}({99cc00}%s{828282})", vehicle_name [ GetVehicleModel ( vehicleid ) - 400 ] ) ;
					show_dialog ( playerid, d_biz_fixcar1, DIALOG_STYLE_LIST, "{FFCC00}Настройки автомобиля", global_string, "Выбрать", "Назад" ) ;
					
					set_player_use_listitem ( playerid, vehicleid ) ;
					SetPVarInt ( playerid, "veh_point", veh_point ) ;
				    return 1 ;
				}
			}
	    }
	    case d_biz_fixcar1:
		{
		    if ( ! response )return callcmd::bpanel1 ( playerid ) ;
		    switch ( listitem )
		    {
		        case 0:
		        {
		        	new vehicleid = get_player_use_listitem ( playerid ) ;

			    	if ( is_vehicle_occupied ( vehicleid ) != -1) return SendClientMessage ( playerid, 0xFF6600FF, !"Транспорт используется." ) ;
					SetVehicleToRespawn ( vehicleid ) ;
					SendClientMessage ( playerid, 0xFFCC00FF, !"Транспорт отремонтирован и отбуксирован к месту стоянки." ) ;

					new _b_id ;
					if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
					else _b_id = p_info [ playerid ] [ business ] ;

					b_info [ _b_id - 1 ] [ b_money ] -= price_fixcar ;

					new _sql_string [ 71 + 9 + 9 ] ;
					format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_money` = '%d' WHERE `b_id` = '%d' LIMIT 1",
					b_info [ _b_id - 1 ] [ b_money ], _b_id ) ;
					mysql_tquery ( sql_connection, _sql_string ) ;

					callcmd::bpanel1 ( playerid ) ;
		        }
		        case 1:
				{
				    new _b_id ;
					if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
					else _b_id = p_info [ playerid ] [ business ] ;
				
					global_string [ 0 ] = EOS ;
					new line_string [ 128 ] ;
					if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )// bus
					{
						for ( new j = 0 ; j < sizeof taxi_cars ; j ++ )
						{
							format ( line_string, 128, "{828282}- {99cc00}%s{FFFFFF}, Цена: {99cc00}%d$\n", vehicle_name [ taxi_cars [ j ] [ 0 ] - 400 ], taxi_cars [ j ] [ 1 ] ) ;
							strcat(global_string, line_string ) ;
						}
					}
					else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus )
					{
						for ( new j = 0 ; j < sizeof bus_cars ; j ++ )
						{
							format ( line_string, 128, "{828282}- {99cc00}%s{FFFFFF}, Цена: {99cc00}%d$\n", vehicle_name [ bus_cars [ j ] [ 0 ] - 400 ], bus_cars [ j ] [ 1 ] ) ;
							strcat(global_string, line_string ) ;
						}
					}
					else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering )
					{
						for ( new j = 0 ; j < sizeof bus_cars ; j ++ )
						{
							format ( line_string, 128, "{828282}- {99cc00}%s{FFFFFF}, Цена: {99cc00}%d$\n", vehicle_name [ carsh_cars [ j ] [ 0 ] - 400 ], carsh_cars [ j ] [ 1 ] ) ;
							strcat(global_string, line_string ) ;
						}
					}
					show_dialog ( playerid, d_biz_model, DIALOG_STYLE_LIST, "{FFCC00}Модель автомобиля", global_string, "Купить", "Закрыть" ) ;
				}
				case 2:
				{
				    new veh_id = get_player_use_listitem ( playerid ) ;
				    
				    new _b_id ;
					if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
					else _b_id = p_info [ playerid ] [ business ] ;
				
				    GetVehiclePos ( veh_id, veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] ) ;
					GetVehicleZAngle ( veh_id, veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] ) ;

					new new_veh_id = CreateVehicle( veh_info [ veh_id - 1 ] [ v_model ], veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ], 6, 6, -1 ) ;
					Iter_Add ( business_taxi[_b_id], new_veh_id ) ;

					if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi ) veh_info [ new_veh_id - 1 ] [ v_type ] = vehicle_type_taxi ;
					else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus ) veh_info [ new_veh_id - 1 ] [ v_type ] = vehicle_type_bus ;
					else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering ) veh_info [ new_veh_id - 1 ] [ v_type ] = vehicle_type_carshering ;
					
					veh_info [ new_veh_id - 1 ] [ v_id ] = veh_info [ veh_id - 1 ] [ v_id ] ;
					veh_info [ new_veh_id - 1 ] [ v_pos ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] ;
					veh_info [ new_veh_id - 1 ] [ v_pos ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] ;
					veh_info [ new_veh_id - 1 ] [ v_pos ] [ 2 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] ;
					veh_info [ new_veh_id - 1 ] [ v_pos ] [ 3 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] ;

					veh_info [ new_veh_id - 1 ] [ v_model ] = veh_info [ veh_id - 1 ] [ v_model ] ;
					veh_info [ new_veh_id - 1 ] [ v_owner ] = veh_info [ veh_id - 1 ] [ v_owner ] ;
					veh_info [ new_veh_id - 1 ] [ v_color ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] ;
					veh_info [ new_veh_id - 1 ] [ v_color ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] ;

					veh_info [ new_veh_id - 1 ] [ v_locked ] = veh_info [ veh_id - 1 ] [ v_locked ] ;

					veh_info [ new_veh_id - 1 ] [ v_plate ] = veh_info [ veh_id - 1 ] [ v_plate ] ;
					format ( veh_info [ new_veh_id - 1 ] [ v_plate ], 12, "%s", veh_info [ veh_id - 1 ] [ v_plate ] ) ;

					veh_info [ new_veh_id - 1 ] [ v_fuel ] = veh_info [ veh_id - 1 ] [ v_fuel ] ;
					veh_info [ new_veh_id - 1 ] [ v_millage ] = veh_info [ veh_id - 1 ] [ v_millage ] ;

					veh_info [ new_veh_id - 1 ] [ v_vehicle ] = new_veh_id ;

					SetVehicleNumberPlate ( new_veh_id, veh_info [ new_veh_id - 1 ] [ v_plate ] ) ;

					DestroyVehicle ( veh_id ) ;
					Iter_Remove(business_taxi[_b_id], veh_id ) ;
					
					if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )
					{
						new mes [ 34 + 32 + 4 ] ;
						format ( mes, sizeof ( mes ), "** %s **\n{828282}%i$ за 1 км", b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
						veh_info [ new_veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( mes, 0xFFCC00FF, 0.0, 0.0, 1.5, 20.0, INVALID_PLAYER_ID, veh_info [ new_veh_id - 1 ] [ v_vehicle ] ) ;
					}
					
					new query_string [ 138 + ( 4 * 8 ) + 9 ] ;
					format ( query_string, sizeof query_string, "UPDATE `businesses_taxi` SET `b_pos_x` = '%f', `b_pos_y` = '%f', `b_pos_z` = '%f', `b_pos_a` = '%f' WHERE `b_vehicle_id` = '%d' LIMIT 1",
					veh_info [ new_veh_id - 1 ] [ v_model ], veh_info [ new_veh_id - 1 ] [ v_id ] ) ;
					mysql_tquery ( sql_connection, query_string ) ;

					SendClientMessage ( playerid, 0xFFCC00FF, !"Позиция автомобиля изменена." ) ;

					new _sql_string [ 71 + 9 + 9 ] ;
					format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_money` = '%d' WHERE `b_id` = '%d' LIMIT 1",
					b_info [ _b_id - 1 ] [ b_money ], _b_id ) ;
					mysql_tquery ( sql_connection, _sql_string ) ;

					callcmd::bpanel1 ( playerid ) ;
				}
		    }
		}
		case d_biz_model:
		{
		    if ( ! response )
			{
				callcmd::bpanel1 ( playerid ) ;
				return 1 ;
			}

			new _b_id ;
			if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
			else _b_id = p_info [ playerid ] [ business ] ;

			new veh_id = get_player_use_listitem ( playerid ) ;

            if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )
            {
				if ( b_info [ _b_id - 1 ] [ b_money ] < taxi_cars [ 1 ] [ listitem ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"В банке бизнеса недостаточно средств." ) ;

                veh_info [ veh_id - 1 ] [ v_model ] = taxi_cars [ listitem ] [ 0 ] ;
                b_info [ _b_id - 1 ] [ b_money ] -= taxi_cars [ listitem ] [ 1 ] ;
			}
			else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus )
			{
				if ( b_info [ _b_id - 1 ] [ b_money ] < bus_cars [ 1 ] [ listitem ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"В банке бизнеса недостаточно средств." ) ;

                veh_info [ veh_id - 1 ] [ v_model ] = bus_cars [ listitem ] [ 0 ] ;
                b_info [ _b_id - 1 ] [ b_money ] -= bus_cars [ listitem ] [ 1 ] ;
			}
			else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering )
			{
				if ( b_info [ _b_id - 1 ] [ b_money ] < carsh_cars [ 1 ] [ listitem ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"В банке бизнеса недостаточно средств." ) ;

                veh_info [ veh_id - 1 ] [ v_model ] = carsh_cars [ listitem ] [ 0 ] ;
                b_info [ _b_id - 1 ] [ b_money ] -= carsh_cars [ listitem ] [ 1 ] ;
			}
			
			GetVehiclePos ( veh_id, veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] ) ;
			GetVehicleZAngle ( veh_id, veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] ) ;

			new new_veh_id = CreateVehicle( veh_info [ veh_id - 1 ] [ v_model ], veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ], veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ], 6, 6, -1 ) ;
			Iter_Add ( business_taxi[_b_id], new_veh_id ) ;

			if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi ) veh_info [ new_veh_id - 1 ] [ v_type ] = vehicle_type_taxi ;
			else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus ) veh_info [ new_veh_id - 1 ] [ v_type ] = vehicle_type_bus ;
			else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering ) veh_info [ new_veh_id - 1 ] [ v_type ] = vehicle_type_carshering ;
			
			veh_info [ new_veh_id - 1 ] [ v_id ] = veh_info [ veh_id - 1 ] [ v_id ] ;
			veh_info [ new_veh_id - 1 ] [ v_pos ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 0 ] ;
			veh_info [ new_veh_id - 1 ] [ v_pos ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 1 ] ;
			veh_info [ new_veh_id - 1 ] [ v_pos ] [ 2 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 2 ] ;
			veh_info [ new_veh_id - 1 ] [ v_pos ] [ 3 ] = veh_info [ veh_id - 1 ] [ v_pos ] [ 3 ] ;

            veh_info [ new_veh_id - 1 ] [ v_model ] = veh_info [ veh_id - 1 ] [ v_model ] ;
			veh_info [ new_veh_id - 1 ] [ v_owner ] = veh_info [ veh_id - 1 ] [ v_owner ] ;
			veh_info [ new_veh_id - 1 ] [ v_color ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] ;
			veh_info [ new_veh_id - 1 ] [ v_color ] [ 1 ] = veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] ;

			veh_info [ new_veh_id - 1 ] [ v_locked ] = veh_info [ veh_id - 1 ] [ v_locked ] ;

			veh_info [ new_veh_id - 1 ] [ v_plate ] = veh_info [ veh_id - 1 ] [ v_plate ] ;
			format ( veh_info [ new_veh_id - 1 ] [ v_plate ], 12, "%s", veh_info [ veh_id - 1 ] [ v_plate ] ) ;

			veh_info [ new_veh_id - 1 ] [ v_fuel ] = veh_info [ veh_id - 1 ] [ v_fuel ] ;
			veh_info [ new_veh_id - 1 ] [ v_millage ] = veh_info [ veh_id - 1 ] [ v_millage ] ;

			veh_info [ new_veh_id - 1 ] [ v_vehicle ] = new_veh_id ;

			SetVehicleNumberPlate ( new_veh_id, veh_info [ new_veh_id - 1 ] [ v_plate ] ) ;

			DestroyVehicle ( veh_id ) ;
			Iter_Remove(business_taxi[_b_id], veh_id ) ;
			
			if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )
			{
				new mes [ 34 + 32 + 4 ] ;
				format ( mes, sizeof ( mes ), "** %s **\n{828282}%i$ за 1 км", b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
				veh_info [ new_veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( mes, 0xFFCC00FF, 0.0, 0.0, 1.5, 20.0, INVALID_PLAYER_ID, veh_info [ new_veh_id - 1 ] [ v_vehicle ] ) ;
			}
			
		 	new query_string [ 81 + 4 + 9 ] ;
    		format ( query_string, sizeof query_string, "UPDATE `businesses_taxi` SET `b_taxi_model` = '%d' WHERE `b_vehicle_id` = '%d' LIMIT 1",
			veh_info [ new_veh_id - 1 ] [ v_model ], veh_info [ new_veh_id - 1 ] [ v_id ] ) ;
			mysql_tquery ( sql_connection, query_string ) ;

   			SendClientMessage ( playerid, 0xFFCC00FF, !"Модель автомобиля изменена." ) ;

			new _sql_string [ 71 + 9 + 9 ] ;
			format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_money` = '%d' WHERE `b_id` = '%d' LIMIT 1",
			b_info [ _b_id - 1 ] [ b_money ], _b_id ) ;
			mysql_tquery ( sql_connection, _sql_string ) ;

			callcmd::bpanel1 ( playerid ) ;
		}// Taxi
	    case d_trash:
	    {
	        if ( ! response ) return clear_player_use_listitem ( playerid ) ;

            new i = get_player_use_listitem ( playerid ) ;
            if ( listitem == 0 )
            {
                new dialog_string [ 100 + 24 + 9 ], _t_id = trash_info [ i ] [ t_object ] ;
				format ( dialog_string, sizeof dialog_string, "Вы нашли {99cc00}%s\n{14A3FF}1. {FFFFFF}Продать ({99cc00}%d${FFFFFF})\n{14A3FF}2. {FFFFFF}Выкинуть", trash_name [ _t_id ], trash_info [ i ] [ t_price ] ) ;
			    show_dialog ( playerid, d_trash, DIALOG_STYLE_LIST, "{FFCC00}Находка", dialog_string, "Выбрать", "Назад" ) ;
            }
            else if ( listitem == 1 )
            {
                //give_money ( playerid, trash_info [ i ] [ t_price ] ) ;

				new scm_string [ 47 + 32 + 9 ], _t_id = trash_info [ i ] [ t_object ] ;
				format ( scm_string, sizeof scm_string, "Вы продали {FFCC00}%s {FFFFFF}за {99cc00}%d$", trash_name [ _t_id ], trash_info [ i ] [ t_price ] ) ;
				SendClientMessage ( playerid, -1, scm_string ) ;
            }
            else if ( listitem == 2 )
            {
				new scm_string [ 34 + 32 ], _t_id = trash_info [ i ] [ t_object ] ;
				format ( scm_string, sizeof scm_string, "Вы выкинули {FFCC00}%s{FFFFFF}.", trash_name [ _t_id ] ) ;
				SendClientMessage ( playerid, -1, scm_string ) ;
            }
            clear_player_use_listitem ( playerid ) ;
	    }
	    /*case d_buy_seed:
	    {
	        if ( ! response ) return 1 ;

	        //if ( p_info [ playerid ] [ money ] < seed_info [ listitem ] [ s_price ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас недостаточно средств." ) ;

			new scm_string [ 34 + 32 + 4 ] ;
			format ( scm_string, sizeof scm_string, "Вы приобрели %s (1 шт.) за %d$.", seed_info [ listitem ] [ s_name ], seed_info [ listitem ] [ s_price ] ) ;
			SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

			p_info [ playerid ] [ p_seed ] [ listitem ] ++ ;

		    new update_string [ 10 * MAX_SEED_INFO ], sql_string [ sizeof update_string + 65 ] ;
		    for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
		    {
		        if ( i == MAX_SEED_INFO - 1 ) format ( update_string, sizeof update_string, "%s%d", update_string, p_info [ playerid ] [ p_seed ] [ i ] ) ;
				else format ( update_string, sizeof update_string, "%s%d|", update_string, p_info [ playerid ] [ p_seed ] [ i ] ) ;
		    }
		    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_seed` = '%s' WHERE `u_id` = '%d' LIMIT 1", update_string, p_info [ playerid ] [ id ] ) ;
		    mysql_tquery ( sql_connection, sql_string ) ;
		}
	    case d_sell_seed:
		{
		    if ( ! response ) return ClearPlayerListitemValues ( playerid ) ;

		    new list_item = GetPlayerListitemValue ( playerid, listitem ) ;
		    ClearPlayerListitemValues ( playerid ) ;

		    new _price = seed_info [ list_item ] [ s_sell_price ] * p_info [ playerid ] [ seed_sell ] [ list_item ] ;
		    
			new scm_string [ 43 + 32 + 4 + 4 ] ;
			format ( scm_string, sizeof scm_string, "Вы продали %s, в размере %d шт., за %d$.", seed_info [ list_item ] [ s_sell_name ], p_info [ playerid ] [ seed_sell ] [ list_item ], _price ) ;
			SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

			p_info [ playerid ] [ seed_sell ] [ list_item ] = 0 ;

			new update_string [ 10 * MAX_SEED_INFO ], sql_string [ sizeof update_string + 70 ] ;
		    for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
		    {
		        if ( i == MAX_SEED_INFO - 1 ) format ( update_string, sizeof update_string, "%s%d", update_string, p_info [ playerid ] [ seed_sell ] [ i ] ) ;
				else format ( update_string, sizeof update_string, "%s%d|", update_string, p_info [ playerid ] [ seed_sell ] [ i ] ) ;
		    }
		    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_seed_sell` = '%s' WHERE `u_id` = '%d' LIMIT 1", update_string, p_info [ playerid ] [ id ] ) ;
		    mysql_tquery ( sql_connection, sql_string ) ;
		}
		case d_player_inv:
		{
		    if ( ! response ) return ClearPlayerListitemValues ( playerid ) ;
		    
		    if ( p_info [ playerid ] [ house ] == -1 ) return 1 ;
		    if ( h_info [ p_info [ playerid ] [ house ] - 1 ] [ h_garden ] == 0 ) return 1 ;
		    
		    new _h_id = p_info [ playerid ] [ house ] ;
			if ( ! IsPlayerInRangeOfPoint ( playerid, 10.0, h_info [ _h_id - 1 ] [ h_pos ] [ 0 ], h_info [ _h_id - 1 ] [ h_pos ] [ 1 ], h_info [ _h_id - 1 ] [ h_pos ] [ 2 ] ) )
	        {
	            ClearPlayerListitemValues ( playerid ) ;
	            SendClientMessage ( playerid, 0xFF6600FF, !"Вы не рядом со своим домом." ) ;
	            return 1 ;
	        }
		    
		    new list_item = GetPlayerListitemValue ( playerid, listitem ) ;
		    ClearPlayerListitemValues ( playerid ) ;
		    
		    create_seed_position ( playerid, list_item ) ;
		}*/
	    case d_bus_station:
		{
			if ( ! response )
			{
			    p_info [ playerid ] [ station_id ] = 0 ;
			    return 1 ;
			}
			
			//if ( p_info [ playerid ] [ money ] < player_fare [ playerid ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас недостаточно средств для проезда." ) ;

		    p_info [ playerid ] [ fare_time ] = random ( 60 ) + 10 ;
		    SendClientMessage ( playerid, 0xFFCC00FF, !"Автобус приедет в течении минуты, ожидайте!" ) ;
	    }
	    case d_jackcar:
	    {
	        if ( ! response ) return 1 ;
	        if ( p_info [ playerid ] [ c_vehicle ] != INVALID_VEHICLE_ID ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вам уже подобрали т/с." ) ;
			if ( p_info [ playerid ] [ urgent_cooldown ] > 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы недавно пригоняли т/с." ) ;

            if ( p_info [ playerid ] [ jackcar_skill ] < 51 )
            {
                new _random_car = random ( sizeof model_ls_skill ), _random_pos, _m_count = 0 ;
                
                do
                {
                    _random_pos = random ( sizeof model_ls_pos ) ;
                    _m_count ++ ;
                }
                while ( ls_place_toggled [ _random_pos ] == true && _m_count < 10 ) ;
                
                if ( ls_place_toggled [ _random_pos ] == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент, нет заказов на автоугон, обратитесь чуть позже." ) ;
                
				p_info [ playerid ] [ c_vehicle ] = CreateVehicle ( model_ls_skill [ _random_car ], model_ls_pos [ _random_pos ] [ 0 ], model_ls_pos [ _random_pos ] [ 1 ], model_ls_pos [ _random_pos ] [ 2 ], model_ls_pos [ _random_pos ] [ 3 ], random ( 126 ), random ( 126 ), -1 ) ;
                p_info [ playerid ] [ c_icon ] = SetPlayerMapIcon ( playerid, 2, model_ls_pos [ _random_pos ] [ 0 ], model_ls_pos [ _random_pos ] [ 1 ], model_ls_pos [ _random_pos ] [ 2 ], 55, 0, MAPICON_GLOBAL ) ;
                p_info [ playerid ] [ c_pos_toggled ] = _random_pos ;
				ls_place_toggled [ _random_pos ] = true ;
			}
			else if ( p_info [ playerid ] [ jackcar_skill ] > 50 && p_info [ playerid ] [ jackcar_skill ] < 101 )
            {
                new _random_car = random ( sizeof model_sf_skill ), _random_pos, _m_count = 0 ;

                do
                {
                    _random_pos = random ( sizeof model_sf_pos ) ;
                    _m_count ++ ;
                }
                while ( sf_place_toggled [ _random_pos ] == true && _m_count < 10 ) ;
                
                if ( sf_place_toggled [ _random_pos ] == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент, нет заказов на автоугон, обратитесь чуть позже." ) ;

				p_info [ playerid ] [ c_vehicle ] = CreateVehicle ( model_sf_skill [ _random_car ], model_sf_pos [ _random_pos ] [ 0 ], model_sf_pos [ _random_pos ] [ 1 ], model_sf_pos [ _random_pos ] [ 2 ], model_sf_pos [ _random_pos ] [ 3 ], random ( 126 ), random ( 126 ), -1 ) ;
                p_info [ playerid ] [ c_icon ] = SetPlayerMapIcon ( playerid, 2, model_sf_pos [ _random_pos ] [ 0 ], model_sf_pos [ _random_pos ] [ 1 ], model_sf_pos [ _random_pos ] [ 2 ], 55, 0, MAPICON_GLOBAL ) ;
                p_info [ playerid ] [ c_pos_toggled ] = _random_pos ;
				sf_place_toggled [ _random_pos ] = true ;
			}
			else if ( p_info [ playerid ] [ jackcar_skill ] > 100 && p_info [ playerid ] [ jackcar_skill ] < 151 )
            {
                new _random_car = random ( sizeof model_lv_skill ), _random_pos, _m_count = 0 ;

                do
                {
                    _random_pos = random ( sizeof model_lv_pos ) ;
                    _m_count ++ ;
                }
                while ( lv_place_toggled [ _random_pos ] == true && _m_count < 10 ) ;

				if ( lv_place_toggled [ _random_pos ] == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент, нет заказов на автоугон, обратитесь чуть позже." ) ;

				p_info [ playerid ] [ c_vehicle ] = CreateVehicle ( model_lv_skill [ _random_car ], model_lv_pos [ _random_pos ] [ 0 ], model_lv_pos [ _random_pos ] [ 1 ], model_lv_pos [ _random_pos ] [ 2 ], model_lv_pos [ _random_pos ] [ 3 ], random ( 126 ), random ( 126 ), -1 ) ;
                p_info [ playerid ] [ c_icon ] = SetPlayerMapIcon ( playerid, 2, model_lv_pos [ _random_pos ] [ 0 ], model_lv_pos [ _random_pos ] [ 1 ], model_lv_pos [ _random_pos ] [ 2 ], 55, 0, MAPICON_GLOBAL ) ;
                p_info [ playerid ] [ c_pos_toggled ] = _random_pos ;
				lv_place_toggled [ _random_pos ] = true ;
			}
			else
            {
                new _random_car = random ( sizeof model_premium_skill ), _random_pos, _m_count = 0 ;

                do
                {
                    _random_pos = random ( sizeof model_premium_pos ) ;
                    _m_count ++ ;
                }
                while ( premium_place_toggled [ _random_pos ] == true && _m_count < 10 ) ;

				if ( premium_place_toggled [ _random_pos ] == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент, нет заказов на автоугон, обратитесь чуть позже." ) ;

				p_info [ playerid ] [ c_vehicle ] = CreateVehicle ( model_premium_skill [ _random_car ], model_premium_pos [ _random_pos ] [ 0 ], model_premium_pos [ _random_pos ] [ 1 ], model_premium_pos [ _random_pos ] [ 2 ], model_premium_pos [ _random_pos ] [ 3 ], random ( 126 ), random ( 126 ), -1 ) ;
                p_info [ playerid ] [ c_icon ] = SetPlayerMapIcon ( playerid, 2, model_premium_pos [ _random_pos ] [ 0 ], model_premium_pos [ _random_pos ] [ 1 ], model_premium_pos [ _random_pos ] [ 2 ], 55, 0, MAPICON_GLOBAL ) ;
                p_info [ playerid ] [ c_pos_toggled ] = _random_pos ;
				premium_place_toggled [ _random_pos ] = true ;
			}
			
			new vehicle_id = p_info [ playerid ] [ c_vehicle ] ;
			veh_info [ vehicle_id - 1 ] [ v_player_jack ] = playerid ;
			veh_info [ vehicle_id - 1 ] [ v_owner ] = -1 ;
			veh_info [ vehicle_id - 1 ] [ v_type ] = vehicle_type_jackcar ;
			veh_info [ vehicle_id - 1 ] [ v_fuel ] = 60.0 ;

			new engine, lights, alarm, doors, bonnet, boot, objective ;

			veh_info [ vehicle_id - 1 ] [ v_locked ] = true ;
			GetVehicleParamsEx ( vehicle_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
			SetVehicleParamsEx ( vehicle_id, engine, lights, alarm, true, bonnet, boot, objective ) ;
			
			p_info [ playerid ] [ c_time ] = 900 ;
			
			p_info [ playerid ] [ urgent_cooldown ] = 1800 ;

			new scm_string [ 69 + 32 ] ;
			format ( scm_string, sizeof scm_string, "Тебе необходимо угнать %s. Примерное нахождение отмечено на карте.", vehicle_name [ GetVehicleModel ( vehicle_id ) - 400 ] ) ;
			SendClientMessage ( playerid, -1, scm_string ) ;
	    }
		case d_kiss:
		{
			if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок покинул игру." ) ;
			if ( ! response )
			{
				SendClientMessage ( seller_id [ playerid ], 0xFF6600FF, "Игрок отказался от поцелуя." ) ;
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			new target_id = seller_id [ playerid ] ;

			new scm_string [ 48 + MAX_PLAYER_NAME ] ;
			format ( scm_string, sizeof scm_string, "%s принял(а) Ваше предложение!", p_info [ playerid ] [ name ] ) ;
			SendClientMessage ( target_id, 0xFFCC00FF, scm_string ) ;

			format ( scm_string, sizeof scm_string, "Вы приняли предложение %s!", p_info [ target_id ] [ name ] ) ;
			SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

			SetPosInFrontOfPlayer ( target_id, playerid, 1 ) ;

			new Float: angle ;
			GetPlayerFacingAngle ( target_id, angle ) ;
			SetPlayerFacingAngle ( playerid, 180 + angle ) ;

			ApplyAnimation ( target_id, "BD_FIRE", "GRLFRD_KISS_03", 4.0, 0, 0, 0, 0, 0, 1 ) ;
			ApplyAnimation ( playerid, "BD_FIRE", "PLAYA_KISS_03", 4.0, 0,0, 0, 0, 0 ) ;

			clear_sell_params ( playerid, target_id ) ;
		}
		case d_healing_accept:
		{
		    if ( seller_id [ playerid ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок покинул игру." ) ;
			if ( ! response )
			{
				SendClientMessage ( seller_id [ playerid ], 0xFF6600FF, "Игрок отказался проходить лечение." ) ;
				clear_sell_params ( playerid, seller_id [ playerid ] ) ;
				return 1 ;
			}
			new target_id = seller_id [ playerid ] ;

			if ( 5 - p_info [ playerid ] [ p_drugs_healing ] > 0 )
			{
				new scm_string [ 66 + MAX_PLAYER_NAME + 4 ] ;
				format ( scm_string, sizeof scm_string, "%s прошёл курс лечения от наркозависимости. Осталось пройти %d!", p_info [ playerid ] [ name ], 5 - p_info [ playerid ] [ p_drugs_healing ] ) ;
				SendClientMessage ( target_id, 0xFFCC00FF, scm_string ) ;

				format ( scm_string, sizeof scm_string, "Вы прошли курс лечения от наркозависимости. Осталось пройти %d!", p_info [ target_id ] [ name ], 5 - p_info [ playerid ] [ p_drugs_healing ] ) ;
				SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
				
				p_info [ playerid ] [ p_drugs_healing ] ++ ;
				update_int_sql ( playerid, "u_drugs_healing", p_info [ playerid ] [ p_drugs_healing ] ) ;
				
				p_info [ playerid ] [ p_disease_cooldown ] = 60 * 60 ;
				update_int_sql ( playerid, "u_disease_cooldown", p_info [ playerid ] [ p_disease_cooldown ] ) ;
			}
			else
			{
			    new scm_string [ 73 + MAX_PLAYER_NAME ] ;
				format ( scm_string, sizeof scm_string, "%s прошёл курс лечения от наркозависимости. Пациент полностью излечён!", p_info [ playerid ] [ name ] ) ;
				SendClientMessage ( target_id, 0xFFCC00FF, scm_string ) ;

				format ( scm_string, sizeof scm_string, "Вы прошли курс лечения от наркозависимости. Вы излечились!", p_info [ target_id ] [ name ] ) ;
				SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
				
				p_info [ playerid ] [ p_drugs_healing ] = 0 ;
				update_int_sql ( playerid, "u_drugs_healing", p_info [ playerid ] [ p_drugs_healing ] ) ;
				
				p_info [ playerid ] [ p_disease ] = 0 ;
				update_int_sql ( playerid, "u_disease", p_info [ playerid ] [ p_disease ] ) ;
				
				p_info [ playerid ] [ p_disease_cooldown ] = 0 ;
				update_int_sql ( playerid, "u_disease_cooldown", p_info [ playerid ] [ p_disease_cooldown ] ) ;
			}

			clear_sell_params ( playerid, target_id ) ;
		}
	}
	return 1 ;
}

stock get_weapon_slot ( weaponid )
{
	switch ( weaponid )
	{
		case 0,1:return 0 ;
		case 2..9:return 1 ;
		case 22..24:return 2 ;
		case 25..27:return 3 ;
		case 28,29,32:return 4 ;
		case 30,31:return 5 ;
		case 33,34:return 6 ;
		case 35..38:return 7 ;
		case 16..18,39:return 8 ;
		case 41..43:return 9 ;
		case 10..15:return 10 ;
		case 44..46:return 11 ;
		case 40:return 12 ;
	}
	return -1 ;
}

stock give_weapon ( playerid, weaponid, ammo )
{
	new slot = get_weapon_slot ( weaponid ) ;

	p_t_info [ playerid ] [ p_gun_ammo ] [ slot ] += ammo;
	p_t_info [ playerid ] [ p_gun_slot ] [ slot ] = weaponid;
	GivePlayerWeapon ( playerid, weaponid, ammo ) ;
	return 1 ;
}

stock set_player_ammo ( playerid, weaponid, ammo )
{
	new slot = get_weapon_slot ( weaponid ) ;
	p_t_info [ playerid ] [ p_gun_ammo ] [ slot ] = ammo;
	return SetPlayerAmmo ( playerid, weaponid, ammo ) ;
}

public OnPlayerConnect ( playerid )
{
	GetPlayerName ( playerid, p_info [ playerid ] [ name ], MAX_PLAYER_NAME ) ;
	Iter_Add(logged_players, playerid);
	
	player_casino_object [ playerid ] = INVALID_OBJECT_ID ;
	player_casino_position [ playerid ] = 0 ;
	
	player_graffity_timer [ playerid ] = -1 ;
	
	p_info [ playerid ] [ kpz_time ] = 0 ; // FSIN
	
	//clear_player_fool ( playerid ) ;
	
	player_rentcar [ playerid ] = INVALID_VEHICLE_ID ;
	
	p_info [ playerid ] [ send_crack ] = 0 ;
	
	for ( new i = 0 ; i < 13 ; i ++ )
	{
		p_t_info [ playerid ] [ p_gun_slot ] [ i ] = 0 ;
		p_t_info [ playerid ] [ p_gun_ammo ] [ i ] = 0 ;
	}
	
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		bg_dice_ptd_1 [ playerid ] [ i ] = PlayerText:-1 ;
		bg_dice_ptd_2 [ playerid ] [ i ] = PlayerText:-1 ;
	}

    // marriage
	p_info [ playerid ] [ marriage ] = -1 ;
	p_info [ playerid ] [ marriage_today ] =
	p_info [ playerid ] [ wedding ] =
	p_info [ playerid ] [ marriage_ring ] = 0 ;
	priest_player [ playerid ] = false ; // prist
	//
	p_t_info [ playerid ] [ pickup_id ] = -1 ;
	
	p_info [ playerid ] [ back_timer ] = -1 ;
	
	clear_fireman ( playerid ) ;
	
	p_info [ playerid ] [ taxi_order ] =
	p_info [ playerid ] [ day_money ] =
	p_info [ playerid ] [ week_money ] =
	p_info [ playerid ] [ month_money ] =
	p_info [ playerid ] [ all_money ] = 0 ;
	
	page_rows [ playerid ] =
	page_count [ playerid ] = 0 ;
	
	p_t_info  [ playerid ] [ pTaxiGoing ] = false ;
	p_t_info  [ playerid ] [ pTaxiStart ] = 0.0 ;
	p_t_info  [ playerid ] [ pTaxiPass ] =
	p_t_info  [ playerid ] [ pTaxiTurn ] [ 0 ] =
	p_t_info  [ playerid ] [ pTaxiTurn ] [ 1 ] = INVALID_PLAYER_ID ;
	p_info [ playerid ] [ taxi_cooldown ] = 0 ;
	
	clear_player_ship ( playerid ) ;
	clear_player_jackcar ( playerid ) ;
	
	p_info [ playerid ] [ wanted ] =
    p_info [ playerid ] [ jacked ] = 0 ;
    
    p_info [ playerid ] [ station_id ] =
    p_info [ playerid ] [ fare_time ] = 0 ;
    player_station_area [ playerid ] = false ;
    
    // marriage
    p_info [ playerid ] [ marriage ] = -1 ;
    p_info [ playerid ] [ sex ] = 0 ;
    
    used_area [ playerid ] = -1 ;
    
    p_info [ playerid ] [ family ] = 1 ;
    p_info [ playerid ] [ business ] = 1 ;
    // Taxi
    p_info [ playerid ] [ deputy ] = -1 ;
    p_t_info [ playerid ] [ taxi_assement ] = 0 ;
    //
    have_box [ playerid ] = false ;
    p_info [ playerid ] [ family_everyday_car ] = INVALID_VEHICLE_ID ;
    
    bg_player_table [ playerid ] = -1 ;
    p_t_info [ playerid ] [ graffity ] = -1 ; // graffity
    
    clear_taxi_player ( playerid ) ;
	
	p_info [ playerid ] [ main_timer ] = SetTimerEx ( "player_timer", 1000, 1, "i", playerid ) ;
	return 1 ;
}

public OnGameModeInit ( )
{
    //cards_OnGameModeInit ( ) ;
    
    printf ( "%d, %d, %d", GetElapsedTime ( gettime ( ), 1613270035, CONVERT_TIME_TO_DAYS ), GetElapsedTime ( gettime ( ), 1613241235, CONVERT_TIME_TO_DAYS ), GetElapsedTime ( gettime ( ), 1613154835, CONVERT_TIME_TO_DAYS ) ) ;

    AddStaticVehicleEx ( 400, -100, -100, -100, 0, 0, 0, 0 ) ;
    
    needs_OnGameModeInit ( ) ;
    
    for ( new i = 0 ; i < MAX_VEHICLES ; i ++ )
	{
		veh_info [ i ] [ v_driver ] = INVALID_VEHICLE_ID ;
		veh_info [ i ] [ v_player_driver ] = INVALID_PLAYER_ID ;
	}
	
	// Traffic Light
	
	for ( new i = 0 ; i < MAX_TRAFFIC_LIGHT ; i ++ )
	{
	    tl_info [ i ] [ t_status ] = 1 ;
	    tl_info [ i ] [ t_area ] = CreateDynamicSphere ( tl_pos [ i ] [ 0 ], tl_pos [ i ] [ 1 ], tl_pos [ i ] [ 2 ], 5.0, -1, -1, -1 ) ;
    	area_dynamic_info [ tl_info [ i ] [ t_area ] ] [ a_type ] = area_type_tl ;

    	new d_string [ 64 ], _string [ 24 ] ;
    	switch ( tl_info [ i ] [ t_status ] )
    	{
    	    case 1: _string = "{FF6600}Красный", tl_info [ i ] [ t_time ] = 2, tl_info [ i ] [ t_new_status ] = 3 ;
    	    case 2: _string = "{FFCC00}Оранжевый", tl_info [ i ] [ t_time ] = 1, tl_info [ i ] [ t_new_status ] = 3 ;
    	    case 3: _string = "{99cc00}Зелёный", tl_info [ i ] [ t_time ] = 3, tl_info [ i ] [ t_new_status ] = 1 ;
    	}

    	format ( d_string, sizeof d_string, "{FFCC00}Светофор\n\n%s", _string ) ;
    	tl_info [ i ] [ t_text ] = CreateDynamic3DTextLabel ( d_string, -1, tl_pos [ i ] [ 0 ], tl_pos [ i ] [ 1 ], tl_pos [ i ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	}
	
	for ( new i = 0 ; i < sizeof kpz_3d_text_pos ; i ++ ) // FSIN
	{
		kpz_3d_text [ i ] = CreateDynamic3DTextLabel ( "{FFCC00}Статистика\n\n{FFFFFF}Отсиживают срок {99cc00}0 {FFFFFF}человек(а)", -1, kpz_3d_text_pos [ i ] [ 0 ], kpz_3d_text_pos [ i ] [ 1 ], kpz_3d_text_pos [ i ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	}
	
	// Taxi new
	CreateDynamic3DTextLabel ( "{FFCC00}Таксопарк\n\n{FFFFFF}Устройство на работу", -1, bizz_invite_pos [ 0 ] [ 0 ], bizz_invite_pos [ 0 ] [ 1 ], bizz_invite_pos [ 0 ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	bizz_invite_pickup [ 0 ] = CreateDynamicPickup ( 1239, 23, bizz_invite_pos [ 0 ] [ 0 ], bizz_invite_pos [ 0 ] [ 1 ], bizz_invite_pos [ 0 ] [ 2 ], -1, -1 ) ;
	
	CreateDynamic3DTextLabel ( "{FFCC00}Таксопарк\n\n{FFFFFF}Устройство на работу", -1, bizz_invite_pos [ 1 ] [ 0 ], bizz_invite_pos [ 1 ] [ 1 ], bizz_invite_pos [ 1 ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	bizz_invite_pickup [ 1 ] = CreateDynamicPickup ( 1239, 23, bizz_invite_pos [ 1 ] [ 0 ], bizz_invite_pos [ 1 ] [ 1 ], bizz_invite_pos [ 1 ] [ 2 ], -1, -1 ) ;
	
	// Poezda
	
	railway_pickup = CreateDynamicPickup ( 1275, 23, railway_pick_pos [ 0 ], railway_pick_pos [ 1 ], railway_pick_pos [ 2 ], -1, -1 ) ;
	
	for ( new i = 0 ; i < 5 ; i ++ )
   	{
    	for ( new a = 0 ; a < 4 ; a ++ )
    	{
   			railway_actor [ i ] [ a ] = INVALID_ACTOR_ID ;
		}
	}
	
	// Nards
	for ( new i = 0 ; i < 2 ; i ++ )
	{
	    CreateDynamic3DTextLabel ( "{FFCC00}Нарды\n\n{FFFFFF}Используйте {FFCC00}/gonards {FFFFFF}для начала игры", -1, nard_position [ i ] [ 0 ], nard_position [ i ] [ 1 ], nard_position [ i ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	}
	CreateDynamicObject(19474, 1815.34875, -1901.03284, 13.10351,   0.00000, 0.00000, 0.00000);
	
	// Quest
	new actor_text [ 100 ] ;
	for ( new i = 0 ; i < sizeof quest_actor ; i ++ )
	{
		CreateActor ( quest_actor [ i ] [ q_skin ], quest_actor [ i ] [ q_pos ] [ 0 ], quest_actor [ i ] [ q_pos ] [ 1 ], quest_actor [ i ] [ q_pos ] [ 2 ], quest_actor [ i ] [ q_pos ] [ 3 ] ) ;

		format ( actor_text, sizeof actor_text, "{FFCC00}%s\n\n{FFFFFF}Используйте {FFCC00}ALT {FFFFFF}для взаимодействия", quest_actor [ i ] [ q_name ] ) ;
		CreateDynamic3DTextLabel ( actor_text, -1, quest_actor [ i ] [ q_pos ] [ 0 ], quest_actor [ i ] [ q_pos ] [ 1 ], quest_actor [ i ] [ q_pos ] [ 2 ] + 1.0, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;

		new _q_area = CreateDynamicSphere ( quest_actor [ i ] [ q_pos ] [ 0 ], quest_actor [ i ] [ q_pos ] [ 1 ], quest_actor [ i ] [ q_pos ] [ 2 ], 3.0, -1, -1, -1 ) ;
		area_dynamic_info [ _q_area ] [ a_type ] = area_type_quest ;
	}

	// Family
	CreateActor ( 104, 295.6434, -1591.7123, 32.5592, 356.7372 ) ;
	CreateDynamic3DTextLabel ( "{FFCC00}Аренда транспорта", -1, 295.5337, -1591.0203, 32.5620 + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	pick_family_rent = CreateDynamicPickup ( 1239, 23, 295.5337, -1591.0203, 32.5620, -1, -1 ) ;
	
	CreateDynamic3DTextLabel ( "{FFCC00}Ящик с оружием", -1, 2792.1982, -2343.9978, 13.2751 + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	pick_family_box = CreateDynamicPickup ( 1239, 23, 2792.1982, -2343.9978, 13.2751, -1, -1 ) ;
	
	CreateDynamic3DTextLabel ( "{FFCC00}Ежедневные задания", -1, 279.8808, -1587.3201, 33.0179 + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	pick_family_quest = CreateDynamicPickup ( 1239, 23, 279.8808, -1587.3201, 33.0179, -1, -1 ) ;
	CreateActor ( 99, 279.3068, -1588.9388, 33.0119, 342.4732 ) ;
	
	
//==============================================================================
	#include "modules/textdraws/sosiska.pwn"
//==============================================================================
	
	// Дрочилово (Нарды)

	for ( new _table = 0 ; _table < 2 ; _table ++ )
	{
		bg_info [ _table ] [ bg_player ] [ 0 ] =
   		bg_info [ _table ] [ bg_player ] [ 1 ] = INVALID_PLAYER_ID ;
   		bg_info [ _table ] [ bg_time ] = -1 ;
	}
	
	// Рулетка
	
	drum_object [ 0 ] = CreateDynamicObject ( 1979, drum_object_pos [ 0 ] [ 0 ],
	                            drum_object_pos [ 0 ] [ 1 ],
	                            drum_object_pos [ 0 ] [ 2 ],
	                            drum_object_pos [ 0 ] [ 3 ],
	                            drum_object_pos [ 0 ] [ 4 ],
	                            drum_object_pos [ 0 ] [ 5 ] ) ;
	                            
    CreateDynamic3DTextLabel ( "Рулетка\n\n{FFFFFF}Используйте {FFCC00}Y{FFFFFF} для взаимодействия", 0xFFCC00FF, table_casino_pos [ 0 ], table_casino_pos [ 1 ], table_casino_pos [ 2 ] + 0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	                            
	table_casino = CreateObject ( 1978, table_casino_pos [ 0 ],
	                                            table_casino_pos [ 1 ],
	                                            table_casino_pos [ 2 ],
	                                            table_casino_pos [ 3 ],
	                                            table_casino_pos [ 4 ],
	                                            table_casino_pos [ 5 ] ) ;
	                                            
	for ( new i = 0 ; i < MAX_ROU_TABLE ; i ++ )
	{
	    for ( new j = 0 ; j < 6 ; j ++ )
	    {
    		roulette_players [ i ] [ j ] = INVALID_PLAYER_ID ;
		}
	}
	
	new saturday = 1310155200, w = gettime ( ) ;
	while ( w - saturday > 60 * 60 * 24 )
   	{
    	w -= 60 * 60 * 24 ;
    	day_weeks ++ ;
	}
	while ( day_weeks >= 7 ) day_weeks -= 7 ;
    
    sql_connection = mysql_connect("217.182.34.233", "gs15597", "gs15597", "voIPgTqc2V2izcgqh6VmHACFGyHd1adj");
    
    /*new _b_id = 4 ;
    for ( new i = 0 ; i < sizeof car_position ; i ++ )
    {
        if ( i < 21 ) _b_id = 1 ;
        else if ( i > 20 && i < 42 ) _b_id = 2 ;
        else _b_id = 3 ;
		format ( global_string, sizeof ( global_string ), "INSERT INTO `businesses_taxi` (`b_id`,`b_pos_x`,`b_pos_y`,`b_pos_z`,`b_pos_a`) VALUES ('%d','%f','%f','%f','%f')",
		_b_id, car_position [ i ] [ 0 ], car_position [ i ] [ 1 ], car_position [ i ] [ 2 ], car_position [ i ] [ 3 ] ) ;
		mysql_tquery ( sql_connection, global_string ) ;
    }*/
    
    // Taxi
    Iter_Init(business_taxi);
	//
	Iter_Init(family_vehicles);
    
    mapping_OnGameModeInit ( ) ;
    //mysql_tquery ( sql_connection, !"SELECT * FROM `houses_garden`", "houses_garden_loading" ) ;
    SetTimer ( "second_timer", 1000, true ) ;
    SetTimer ( "minute_timer", 1000, true ) ;
    SetTimer ( "create_vehicles", 15000, false ) ; // Таймер для того, чтоб во время теста транспорт загружался после основного
    
    for ( new i = 0 ; i < 10 ; i ++ ) create_trash ( ) ;
    
    /*
    
    pick_buy_seed = CreateDynamicPickup ( 1239, 23, pickups_seed_posoton [ 0 ] [ 0 ], pickups_seed_posoton [ 0 ] [ 1 ], pickups_seed_posoton [ 0 ] [ 2 ], -1, -1 ) ;
    CreateDynamic3DTextLabel ( "{FFCC00}Покупка семян", -1, pickups_seed_posoton [ 0 ] [ 0 ], pickups_seed_posoton [ 0 ] [ 1 ], pickups_seed_posoton [ 0 ] [ 2 ] + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
    
    pick_sell_seed = CreateDynamicPickup ( 1239, 23, pickups_seed_posoton [ 1 ] [ 0 ], pickups_seed_posoton [ 1 ] [ 1 ], pickups_seed_posoton [ 1 ] [ 2 ], -1, -1 ) ;
    CreateDynamic3DTextLabel ( "{FFCC00}Продажа растительности", -1, pickups_seed_posoton [ 1 ] [ 0 ], pickups_seed_posoton [ 1 ] [ 1 ], pickups_seed_posoton [ 1 ] [ 2 ] + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;

    */
    
    //Iter_Add(houses_garden, 1);
	/*
		В houses_loading добавить:
		h_info [ i ] [ h_garden ] = cache_get_field_content_int ( i, "h_garden", sql_connection ) ;
		if ( h_info [ i ] [ h_garden ] ) Iter_Add(houses_garden, h_info [ i ] [ h_id ]);
	
	*/
	return 1 ;
}

// Taxi
forward businesses_taxi_loading ( ) ;
public businesses_taxi_loading ( )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
	    new _car_count = 0 ;
	    for ( new i = 0 ; i < rows ; i ++ )
	    {
	        if ( _car_count == 10 ) _car_count = 0 ;
	        new _b_id = cache_get_field_content_int ( i, "b_id", sql_connection ) ;
	        new _c_type = cache_get_field_content_int ( i, "b_type", sql_connection ) ;// bus
	        
	        b_info [ _b_id - 1 ] [ b_taxi_model ] [ _car_count ] = cache_get_field_content_int ( i, "b_taxi_model", sql_connection ) ;
	        b_info [ _b_id - 1 ] [ b_vehicle_id ] [ _car_count ] = cache_get_field_content_int ( i, "b_vehicle_id", sql_connection ) ;
	        
	        b_taxi_pos [ _b_id ] [ _car_count ] [ 0 ] = cache_get_field_content_float ( i, "b_pos_x", sql_connection ) ;
			b_taxi_pos [ _b_id ] [ _car_count ] [ 1 ] = cache_get_field_content_float ( i, "b_pos_y", sql_connection ) ;
			b_taxi_pos [ _b_id ] [ _car_count ] [ 2 ] = cache_get_field_content_float ( i, "b_pos_z", sql_connection ) ;
			b_taxi_pos [ _b_id ] [ _car_count ] [ 3 ] = cache_get_field_content_float ( i, "b_pos_a", sql_connection ) ;
			
	        if ( b_info [ _b_id - 1 ] [ b_taxi_model ] [ _car_count ] != -1 )
	        {
		        new veh_id = GetVehicleID ( ) ;
		        veh_info [ veh_id - 1 ] [ v_model ] = b_info [ _b_id - 1 ] [ b_taxi_model ] [ _car_count ] ;

		        veh_info [ veh_id - 1 ] [ v_color ] [ 0 ] = veh_info [ veh_id - 1 ] [ v_color ] [ 1 ] = 6 ;
				
				b_info [ _b_id - 1 ] [ b_type ] = bizz_type_carshering ;
				b_info [ _b_id - 1 ] [ b_money ] = 5000000 ;

		        veh_info [ veh_id - 1 ] [ v_type ] = _c_type ; // bus
		        veh_info [ veh_id - 1 ] [ v_owner ] = _b_id ;
		        veh_info [ veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( veh_info [ veh_id - 1 ] [ v_model ], b_taxi_pos [ _b_id ] [ _car_count ] [ 0 ],
																												b_taxi_pos [ _b_id ] [ _car_count ] [ 1 ],
																												b_taxi_pos [ _b_id ] [ _car_count ] [ 2 ],
																												b_taxi_pos [ _b_id ] [ _car_count ] [ 3 ], 6, 6, -1 ) ;
																												
				Iter_Add(business_taxi[_b_id], veh_id);
				
				if ( _c_type == vehicle_type_taxi )// bus
				{
					new mes [ 34 + 32 + 4 ] ;
					format ( mes, sizeof ( mes ), "** %s **\n{828282}%i$ за 1 км", b_info [ _b_id - 1 ] [ b_name ], b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;
					veh_info [ veh_id - 1 ] [ v_label ] = CreateDynamic3DTextLabel ( mes, 0xFFCC00FF, 0.0, 0.0, 1.5, 20.0, INVALID_PLAYER_ID, veh_info [ veh_id - 1 ] [ v_vehicle ] ) ;
				}
			}
			_car_count ++ ;
	    }
	}
	return 1 ;
}

CMD:bpanel1 ( playerid )
{
	if ( p_info [ playerid ] [ business ] == -1 && p_info [ playerid ] [ deputy ] == -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вам недоступна данная команда." ) ;
	
    global_string [ 0 ] = EOS ;
    
    new _b_id ;
	if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
	else _b_id = p_info [ playerid ] [ business ] ;
    
    if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_taxi )
	{
		strcat ( global_string, "{FFCC00}1.{FFFFFF} Управление автопарком\n" ) ;
		strcat ( global_string, "{FFCC00}2.{FFFFFF} Информация\n" ) ;
		strcat ( global_string, "{FFCC00}3.{FFFFFF} Смена названия компании\n" ) ;
		strcat ( global_string, "{FFCC00}4.{FFFFFF} Установить цену за 1км\n" ) ;
		strcat ( global_string, "{FFCC00}5.{FFFFFF} Установить комиссию трахопарку\n" ) ;
		strcat ( global_string, "{FFCC00}6.{FFFFFF} Заместитель\n" ) ;
		strcat ( global_string, "{FFCC00}7.{FFFFFF} Список сотрудников\n" ) ;
		strcat ( global_string, "{FFCC00}8.{FFFFFF} Продать бизнес\n" ) ;

		show_dialog ( playerid, d_b_panel, DIALOG_STYLE_LIST, "{FFCC00}Управление трахопарком", global_string, "Выбрать", "Закрыть" ) ;
	}
	else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_bus )
	{
		strcat ( global_string, "{FFCC00}1.{FFFFFF} Управление автопарком\n" ) ;
		strcat ( global_string, "{FFCC00}2.{FFFFFF} Информация\n" ) ;
		strcat ( global_string, "{FFCC00}3.{FFFFFF} Смена названия компании\n" ) ;
		strcat ( global_string, "{FFCC00}5.{FFFFFF} Установить комиссию парку\n" ) ;
		strcat ( global_string, "{FFCC00}6.{FFFFFF} Заместитель\n" ) ;
		strcat ( global_string, "{FFCC00}7.{FFFFFF} Список сотрудников\n" ) ;
		strcat ( global_string, "{FFCC00}8.{FFFFFF} Продать бизнес\n" ) ;

		show_dialog ( playerid, d_b_panel, DIALOG_STYLE_LIST, "{FFCC00}Управление автобусным парком", global_string, "Выбрать", "Закрыть" ) ;
	}
	else if ( b_info [ _b_id - 1 ] [ b_type ] == bizz_type_carshering )
	{
		strcat ( global_string, "{FFCC00}1.{FFFFFF} Управление автопарком\n" ) ;
		strcat ( global_string, "{FFCC00}2.{FFFFFF} Информация\n" ) ;
		strcat ( global_string, "{FFCC00}3.{FFFFFF} Смена названия компании\n" ) ;
		strcat ( global_string, "{FFCC00}5.{FFFFFF} Установить цену за 1км\n" ) ;
		strcat ( global_string, "{FFCC00}6.{FFFFFF} Заместитель\n" ) ;
		strcat ( global_string, "{FFCC00}8.{FFFFFF} Продать бизнес\n" ) ;

		show_dialog ( playerid, d_b_panel, DIALOG_STYLE_LIST, "{FFCC00}Управление каршерингом", global_string, "Выбрать", "Закрыть" ) ;
	}
	return 1 ;
}
//
/*forward houses_garden_loading ( ) ;
public houses_garden_loading ( )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
	    for ( new i = 0 ; i < rows ; i ++ )
	    {
	        new _h_id = cache_get_field_content_int ( i, "h_id", sql_connection ) ;
	        
	        new _id = cache_get_field_content_int ( i, "h_slot", sql_connection ) ;
	        h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] = cache_get_field_content_int ( i, "h_garden_time", sql_connection ) ;
	        h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] = cache_get_field_content_int ( i, "h_garden_result", sql_connection ) ;
	        h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = cache_get_field_content_int ( i, "h_garden_object", sql_connection ) ;
	        
	        h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] = cache_get_field_content_int ( i, "h_garden_seed", sql_connection ) ;
	        new _h_garden_seed = h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] ;
	        
	        houses_garden_position [ _h_id ] [ _id ] [ 0 ] = cache_get_field_content_float ( i, "h_pos_x", sql_connection ) ;
			houses_garden_position [ _h_id ] [ _id ] [ 1 ] = cache_get_field_content_float ( i, "h_pos_y", sql_connection ) ;
			houses_garden_position [ _h_id ] [ _id ] [ 2 ] = cache_get_field_content_float ( i, "h_pos_z", sql_connection ) ;
			
			new _z_update = h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] * 2 ;
			h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = CreateDynamicObject ( seed_info [ _h_garden_seed ] [ s_object ], houses_garden_position [ _h_id ] [ _id ] [ 0 ],
																							houses_garden_position [ _h_id ] [ _id ] [ 1 ],
																							( houses_garden_position [ _h_id ] [ _id ] [ 2 ] - 12 ) + _z_update,
																							0.0, 0.0, 0.0 ,
																							0, 0 ) ;

            if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] > 1 )
			{
			    new text_label [ 59 + 32 + 4 ] ;
			    format ( text_label, sizeof text_label, "{FFCC00}%s\n\n{FFFFFF}До созревания: {99cc00}%d минут(ы)", seed_info [ _h_garden_seed ] [ s_name ], h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] ) ;
			    h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ] = CreateDynamic3DTextLabel ( text_label, -1, houses_garden_position [ _h_id ] [ _id ] [ 0 ],
																													houses_garden_position [ _h_id ] [ _id ] [ 1 ],
																													houses_garden_position [ _h_id ] [ _id ] [ 2 ] + 0.8, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
			}
			else
			{
			    new text_label [ 67 + 32 ] ;
			    format ( text_label, sizeof text_label, "{FFCC00}%s\n{FFFFFF}Растение созрело!\n\n{99cc00}Используйте ALT", seed_info [ _h_garden_seed ] [ s_name ] ) ;
			    h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ] = CreateDynamic3DTextLabel ( text_label, -1, houses_garden_position [ _h_id ] [ _id ] [ 0 ],
																													houses_garden_position [ _h_id ] [ _id ] [ 1 ],
																													houses_garden_position [ _h_id ] [ _id ] [ 2 ] + 0.8, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;
			}
	    }
	}
	return 1 ;
}*/

public OnPlayerEnterDynamicArea ( playerid, areaid )
{
    used_area [ playerid ] = areaid ;
	if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT )
	{
		/*if ( areaid >= station_area [ 0 ] && areaid <= station_area [ sizeof station_position - 1 ] )
		{
		    player_station_area [ playerid ] = true ;
		}
		else if ( areaid == marriage_area )// marriage
		{
			if ( ! p_info [ playerid ] [ marriage_today ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не прошли процесс регистрации." ) ;
            if ( p_info [ playerid ] [ sex ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Начать регистрацию может только жених." ) ;
			if ( ! p_info [ playerid ] [ marriage_ring ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас нет колец." ) ;
			if ( GetPlayerSkin ( playerid ) != man_marriage ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас нет костюма." ) ;

            show_dialog ( playerid, d_prist_reg, DIALOG_STYLE_MSGBOX, "{FFCC00}Заявка", "{FFFFFF}Вы действительно готовы начать бракосочетание?\n\n\
	                                                                                        {828282}Когда процесс начнётся все, кого Вы не успели пригласить\n\
																							{828282}не смогут войти в церковь.\n\
																							{828282}Невеста должна находиться рядом с Вами.", "Принять", "Закрыть" ) ;
		}*/
		
		switch ( area_dynamic_info [ areaid ] [ a_type ] )// graffity
		{
			case area_type_graffity:
			{
				for ( new i = 0 ; i < count_graffity ; i ++ )
				{
					if ( IsPlayerInRangeOfPoint ( playerid, 3.0, graf_info [ i ] [ gr_x ] [ 0 ], graf_info [ i ] [ gr_x ] [ 1 ], graf_info [ i ] [ gr_x ] [ 2 ] ) )
					{
						if ( p_t_info [ playerid ] [ graffity ] != -1 ) break ;
						//if ( ! gang_player ( playerid ) ) break ;
						//if ( p_info [ playerid ] [ member ] == graf_info [ i ] [ g_member ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"то граффити принадлежит Вашей банде.");
						if ( graf_info [ i ] [ g_day ] == 1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Данное граффити сегодня уже закрашивалось.");
						if ( GetPlayerWeapon ( playerid ) != 41 ) return SendClientMessage ( playerid, 0xFF6600FF, !"У вас нет балончика, приобретите его в магазине 24/7.");
						if ( GetPlayerAmmo ( playerid ) < 500 ) return SendClientMessage ( playerid, 0xFF6600FF, !"У вас не хватает краски в балончике. (1 граффити = 500 ед. балончика)");
                        if ( p_info [ playerid ] [ day_graffity ] >= 10 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы закрасили максимальное количество граффити за сутки.");

					    p_info [ playerid ] [ day_graffity ] ++ ;
					    update_int_sql ( playerid, "u_day_graffity", p_info [ playerid ] [ day_graffity ] ) ;
						
						player_graffity_timer [ playerid ] = SetTimerEx ( "player_shot_timer", 100, true, "ii", playerid, GetPlayerAmmo ( playerid ) ) ;

						p_t_info [ playerid ] [ graffity ] = i ;
						
						SendClientMessage ( playerid, 0xFFCC00FF, !"Начинайте закрашивать граффити.");
						break ;
					}
				}
			}
		}
	}
	else if ( GetPlayerState ( playerid ) == PLAYER_STATE_DRIVER )
	{
	    if ( areaid >= tl_info [ 0 ] [ t_area ] && areaid <= tl_info [ MAX_TRAFFIC_LIGHT - 1 ] [ t_area ] )
		{
		    if ( radar_time [ playerid ] > gettime ( ) ) return 1 ;
		    for ( new i = 0 ; i < MAX_TRAFFIC_LIGHT ; i ++ )
		    {
		        if ( areaid != tl_info [ i ] [ t_area ] ) continue ;
		        if ( tl_info [ i ] [ t_status ] != 1 ) continue ;
		        
		        SendClientMessage ( playerid, 0xFFCC00FF, !"ШТРАФ!!!!!!!!!!!!!!!!!!!!!!" ) ;
		        radar_time [ playerid ] = gettime ( ) + 10 ;
		        break ;
		    }
		}
	}
	return 1 ;
}

forward player_shot_timer ( playerid, start_patrons ) ;
public player_shot_timer ( playerid, start_patrons )// graffity
{
	new newkeys, key_l, key_u ;
	GetPlayerKeys ( playerid, newkeys, key_l, key_u ) ;
	if ( Holding ( KEY_FIRE ) )
	{
		if ( GetPlayerWeapon ( playerid ) == 41 )
		{
            SendClientMessage ( playerid, 0xFFCC00FF, !"ya sobaka ti sobaka" ) ;
			if ( start_patrons - GetPlayerAmmo ( playerid ) < 490 ) return 1 ; // graffity fix

			/*new object ;
			switch ( p_info [ playerid ] [ member ] )
			{
				case 14: object = 18659 ;
		        case 18: object = 18660 ;
		        case 19: object = 18661 ;
		        case 20: object = 18662 ;
		        case 21: object = 18663 ;
		        case 22: object = 18664 ;
			}

			DestroyDynamicObject ( graf_info [ p_t_info [ playerid ] [ graffity ] ] [ g_object ] ) ;
			graf_info [ p_t_info [ playerid ] [ graffity ] ] [ g_object ] = CreateDynamicObject ( object, graf_info[ p_t_info [ playerid ] [ graffity ] ][gr_x][0], graf_info[ p_t_info [ playerid ] [ graffity ] ][gr_x][1], graf_info[ p_t_info [ playerid ] [ graffity ] ][gr_x][2], graf_info[ p_t_info [ playerid ] [ graffity ] ][gr_x][3], graf_info[ p_t_info [ playerid ] [ graffity ] ][gr_x][4], graf_info[ p_t_info [ playerid ] [ graffity ] ][gr_x][5]);
			graf_info [ p_t_info [ playerid ] [ graffity ] ] [ g_member ] = p_info [ playerid ] [ member ] ;
						
			graf_info [ p_t_info [ playerid ] [ graffity ] ] [ g_day ] = 1 ;

			GameTextForPlayer(playerid,"~y~READY", 3000, 3);
			ClearAnimations ( playerid ) ;

			new sql_string [ 84 + 9 + 9 ] ;
			format(sql_string, sizeof sql_string, "UPDATE `grafity` SET `g_member` = '%d', `g_day` = '1' WHERE `g_id` = '%d' LIMIT 1", p_info[playerid][member], graf_info[ p_t_info [ playerid ] [ graffity ] ][g_id]);
			mysql_tquery(sql_connection, sql_string, "", "");
			
			new text_label [ 87 + 8 + 32 ], _g_member = graf_info [ p_t_info [ playerid ] [ graffity ] ] [ g_member ] - 1 ; // graffity fix
	        format ( text_label, sizeof text_label, "Граффити\n{%s}%s\n\n{828282}Используйте {FFFFFF}баллончик{828282} для взаимодействия", f_info [ _g_member ] [ f_chat_color ], f_info [ _g_member ] [ f_name ] ) ;
			UpdateDynamic3DTextLabelText ( graf_info [ p_t_info [ playerid ] [ graffity ] ] [ g_text ], 0xFFCC00FF, text_label ) ;

			p_t_info [ playerid ] [ graffity ] = -1 ;*/
			
			if ( player_graffity_timer [ playerid ] != -1 )
			{
				KillTimer ( player_graffity_timer [ playerid ] ) ;
				player_graffity_timer [ playerid ] = -1 ;
			}
		}
	}
	return 1 ;
}

public OnPlayerLeaveDynamicArea ( playerid, areaid )
{
    used_area [ playerid ] = -1 ;
	if ( areaid >= station_area [ 0 ] && areaid <= station_area [ sizeof station_position - 1 ] )
	{
	    if ( player_station_area [ playerid ] && p_info [ playerid ] [ fare_time ] )
		{
			p_info [ playerid ] [ fare_time ] = 0 ;
			SendClientMessage ( playerid, 0xFF6600FF, !"Вы покинули остановку! Ваш билет на автобус аннулирован." ) ;
		}
	    player_station_area [ playerid ] = false ;
	}
	
	switch ( area_dynamic_info [ areaid ] [ a_type ] )// graffity
	{
		case area_type_graffity:
		{
			if ( player_graffity_timer [ playerid ] != -1 )
			{
				KillTimer ( player_graffity_timer [ playerid ] ) ;
				player_graffity_timer [ playerid ] = -1 ;
			}
			p_t_info [ playerid ] [ graffity ] = -1 ; // graffity
		}
	}
	return 1 ;
}

forward create_vehicles ( ) ;
public create_vehicles ( )
{
	Iter_Init(streamed_players) ;
	Iter_Init(streamed_vehicles) ;
    
    mysql_tquery ( sql_connection, !"SELECT * FROM `businesses_taxi`", "businesses_taxi_loading" ) ;// Taxi
    mysql_tquery ( sql_connection, !"SELECT * FROM `grafity`", "load_graffity" ) ;
    mysql_tquery ( sql_connection, !"SELECT * FROM `player_weapons`", "load_weapons" ) ;
	
	bank_pickup = CreateDynamicPickup ( 1274, 23, bank_pick_pos [ 0 ], bank_pick_pos [ 1 ], bank_pick_pos [ 2 ], 0, 0, -1 ) ;
	CreateDynamic3DTextLabel ( "Управление финансами бизнеса", 0xFFCC00FF, bank_pick_pos [ 0 ], bank_pick_pos [ 1 ], bank_pick_pos [ 2 ] + 0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	
	// Familys
	new _veh_id = GetVehicleID ( ) ;
	veh_info [ _veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( 411, 279.8808, -1587.3201, 33.0179, 0.0, 2, 2, 600 ) ;
	Iter_Add(family_vehicles[1], _veh_id);
	veh_info [ _veh_id - 1 ] [ v_fuel ] = 30.0 ;

	_veh_id = GetVehicleID ( ) ;
	veh_info [ _veh_id - 1 ] [ v_vehicle ] = CreateVehicle ( 411, 279.8808, -1587.3201, 33.0179, 0.0, 2, 2, 600 ) ;
	Iter_Add(family_vehicles[1], _veh_id);
	veh_info [ _veh_id - 1 ] [ v_fuel ] = 20.0 ;
	
	// marriage
	priest_pickup = CreateDynamicPickup ( 1275, 23, priest_pos [ 0 ], priest_pos [ 1 ], priest_pos [ 2 ], 1, 33, -1 ) ;
	CreateDynamic3DTextLabel ( "Священник", 0xFFCC00FF, priest_pos [ 0 ], priest_pos [ 1 ], priest_pos [ 2 ] + 0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	
	pick_marriage_id = CreateDynamicPickup ( 1274, 23, pick_marriage_pos [ 0 ], pick_marriage_pos [ 1 ], pick_marriage_pos [ 2 ], 1, 33, -1 ) ;
	CreateDynamic3DTextLabel ( "Бракосочетание", 0xFFCC00FF, pick_marriage_pos [ 0 ], pick_marriage_pos [ 1 ], pick_marriage_pos [ 2 ] + 0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	
	pick_enter_prist [ 0 ] = CreateDynamicPickup ( 1318, 23, 1720.2524, -1741.1508, 13.5469, 0, 0, -1 ) ;
	pick_enter_prist [ 1 ] = CreateDynamicPickup ( 1318, 23, 1256.6434, 2039.3374, 656.6249, 1, 33, -1 ) ;
	
	CreateDynamic3DTextLabel ( "Регистрация", 0xFFCC00FF, 1225.3834,2039.2190,657.0502 + 0.5, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	marriage_area = CreateDynamicSphere ( 1226.7748,2039.1682,656.6249, 5.0, -1, 33, -1 ) ;

	// station
    
    for ( new i = 0 ; i < sizeof station_position ; i ++ )
    {
        CreateDynamic3DTextLabel ( "{FFCC00}Автобусная остановка\n\n{FFFFFF}Откройте карту и поставьте метку\nрядом с тем местом, куда Вам нужно", -1, station_position [ i ] [ 0 ], station_position [ i ] [ 1 ], station_position [ i ] [ 2 ] + 2.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
  		station_area [ i ] = CreateDynamicSphere ( station_position [ i ] [ 0 ], station_position [ i ] [ 1 ], station_position [ i ] [ 2 ], 5.0, -1, -1, -1 ) ;

        CreateDynamicObject ( 1257, station_position [ i ] [ 0 ], station_position [ i ] [ 1 ], station_position [ i ] [ 2 ], station_position [ i ] [ 3 ], station_position [ i ] [ 4 ], station_position [ i ] [ 5 ] ) ;
	}
	
	// go_bus
	//go_bus_mode_init ( ) ;
	
	// ship
	new scm_string [ 200 ] ;
    format(scm_string, sizeof scm_string, "Посигнальте для переправы\n{FFCC00}Корабль отплывает через %s\n\n{828282}Если Вы планируете переправляться не один,\n{828282}то Ваши компаньоны должны сидеть в Вашей машине", convert_time ( start_ship ) ) ;
	ship_label [ 0 ] = CreateDynamic3DTextLabel ( scm_string, -1, ship_pick_pos [ 0 ] [ 0 ], ship_pick_pos [ 0 ] [ 1 ], ship_pick_pos [ 0 ] [ 2 ] + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	
	format(scm_string, sizeof scm_string, "Посигнальте для переправы\n{FFCC00}Ожидайте корабль\n\n{828282}Если Вы планируете переправляться не один,\n{828282}то Ваши компаньоны должны сидеть в Вашей машине" ) ;
	ship_label [ 1 ] = CreateDynamic3DTextLabel ( scm_string, -1, ship_pick_pos [ 1 ] [ 0 ], ship_pick_pos [ 1 ] [ 1 ], ship_pick_pos [ 1 ] [ 2 ] + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	
	ship_object = CreateDynamicObject ( 10230, ship_info [ 0 ] [ s_pos ] [ 0 ], ship_info [ 0 ] [ s_pos ] [ 1 ], ship_info [ 0 ] [ s_pos ] [ 2 ], ship_info [ 0 ] [ s_pos ] [ 3 ], ship_info [ 0 ] [ s_pos ] [ 4 ], ship_info [ 0 ] [ s_pos ] [ 5 ] ) ;

    clear_ship ( ) ;
    
    // jackcar
    CreateDynamic3DTextLabel ( "{FFCC00}Автоугон\n{FFFFFF}Нажмите {FFCC00}ALT {FFFFFF}для взаимодействия", -1, pick_jackcar [ 0 ], pick_jackcar [ 1 ], pick_jackcar [ 2 ] + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
    
    new actorid = CreateActor ( 47,
								pick_jackcar [ 0 ],
								pick_jackcar [ 1 ],
								pick_jackcar [ 2 ],
								pick_jackcar [ 3 ] ) ;
    
    SetActorVirtualWorld ( actorid, 0 ) ;
    ApplyActorAnimation ( actorid, "DEALER",  "DEALER_IDLE",  4.1,  1,  1,  1,  1,  1 ) ;
    
    for ( new i = 0 ; i < MAX_VEHICLES ; i ++ )
    {
        veh_info [ i ] [ v_player_jack ] = INVALID_PLAYER_ID ;
    }

	// fireman
    fire_OnGameModeInit ( ) ;
	return 1 ;
}

stock convert_time ( seconds )
{
	new time_string [ 12 ],
		minutes = floatround ( seconds / 60 ) ;

	seconds -= minutes * 60 ;

	format ( time_string, sizeof( time_string ), "%02d:%02d", minutes, seconds ) ;
	return time_string;
}

stock GetVehicleID ( )
{
	new veh_id = AddStaticVehicleEx ( 400, -100, -100, -100, 0, 0, 0, 0 ) ;
	DestroyVehicle ( veh_id ) ;
	return veh_id ;
}

public OnPlayerStateChange ( playerid, newstate, oldstate )
{
    switch ( newstate )
	{
	    case PLAYER_STATE_PASSENGER:
		{
			new _v_id = GetPlayerVehicleID ( playerid ) ;
			if ( veh_info [ _v_id - 1 ] [ v_type ] == vehicle_type_taxi && veh_info [ _v_id - 1 ] [ v_driver ] != INVALID_PLAYER_ID )
			{
				new driverid = veh_info [ _v_id - 1 ] [ v_driver ] ;
				if ( p_t_info [ driverid ] [ pTaxiPass ] == INVALID_PLAYER_ID )
				{
					if( p_info [ playerid ] [ money ] < b_info [ p_info [ driverid ] [ job ] - 1 ] [ b_taxi_fare ] )
					{
						SendClientMessage(playerid, 0xFF6600FF, !"У вас не хватает средств для того, чтобы воспользоваться такси.");
						return RemovePlayerFromVehicle(playerid);
					}
					p_t_info [ driverid ] [ pTaxiStart ] = veh_info [ _v_id - 1 ] [ v_millage ] ;
					p_t_info [ driverid ] [ pTaxiPass ] = playerid ;
					p_t_info [ driverid ] [ pTaxiGoing ] = true ;

					show_dialog ( playerid, d_taxi_mark, DIALOG_STYLE_LIST, "{FFCC00}Навигатор таксиста", "{FFCC00}1. {FFFFFF}Установить метку на карте\n{FFCC00}2. {FFFFFF}Установить метку из GPS навигатора\n{828282}Продолжать поездку без навигатора", "Выбрать", "Закрыть" ) ;
				}
				else
				{
					if ( p_t_info [ driverid ] [ pTaxiTurn ] [ 0 ] == INVALID_PLAYER_ID ) p_t_info [ driverid ] [ pTaxiTurn ] [ 0 ] = playerid ;
					else if ( p_t_info [ driverid ] [ pTaxiTurn ] [ 1 ] == INVALID_PLAYER_ID ) p_t_info [ driverid ] [ pTaxiTurn ] [ 1 ] = playerid ;
					else
					{
						if ( ! IsPlayerConnected ( p_t_info [ driverid ] [ pTaxiTurn ] [ 0 ] ) || GetPlayerVehicleID ( p_t_info [ driverid ] [ pTaxiTurn ] [ 0 ] ) != _v_id )
						{
							if ( p_t_info [ driverid ] [ pTaxiTurn ] [ 1 ] != INVALID_PLAYER_ID )
							{
								p_t_info [ driverid ] [ pTaxiTurn ] [ 0 ] = p_t_info [ driverid ] [ pTaxiTurn ] [ 1 ] ;
								p_t_info [ driverid ] [ pTaxiTurn ] [ 1 ] = playerid ;
							}
							else p_t_info [ driverid ] [ pTaxiTurn ] [ 0 ] = playerid ;
						}
						else if ( ! IsPlayerConnected ( p_t_info [ driverid ] [ pTaxiTurn ] [ 1 ] ) || GetPlayerVehicleID ( p_t_info [ driverid ] [ pTaxiTurn ] [ 1 ] ) != _v_id )
						{
							p_t_info [ driverid ] [ pTaxiTurn ] [ 1 ] = playerid ;
						}
						else
						{
							SendClientMessage ( playerid, 0xFF6600FF, !"Сядьте в такси снова, произошла ошибка." ) ;
							RemovePlayerFromVehicle ( playerid ) ;
						}
					}
				}
			}
		}
	    case PLAYER_STATE_DRIVER:
		{
		    new veh_id = GetPlayerVehicleID ( playerid ) ;
		    if ( p_info [ playerid ] [ family_everyday_progress ] [ 0 ] == 1 )
		    {
			    if ( p_info [ playerid ] [ family_everyday_car ] == veh_id )
			    {
					new _fuel_count = random ( 7 ) + 1 ;
					for ( new b = 0 ; b < MAX_BUSINESS ; b ++ )
					{
					    _fuel_count -- ;
		   				if ( _fuel_count > 0 || b_info [ b ] [ b_type ] != bizz_type_gas ) continue ;
					    
					    is_gps_used { playerid } = 21 ;
						SetPlayerRaceCheckpoint ( playerid, 1, b_info [ b ] [ b_pos ] [ 0 ], b_info [ b ] [ b_pos ] [ 1 ], b_info [ b ] [ b_pos ] [ 2 ] - 1.4, 0.0, 0.0, 0.0, 3.0 ) ;

                        SendClientMessage ( playerid, 0xFFCC00FF, !"Мы отметили {FFFFFF}\"заправку\"{FFCC00} на Вашей карте, езжайте туда." ) ;
                        
                        p_info [ playerid ] [ family_everyday_progress ] [ 0 ] = 2 ;
						break ;
					}
			    }
			}
			if ( p_info [ playerid ] [ family_everyday_progress ] [ 1 ] )
		    {
			    if ( p_info [ playerid ] [ family_everyday_car ] != veh_id )
			    {
			        RemovePlayerFromVehicle ( playerid ) ;
					SendClientMessage ( playerid, 0xFF6600FF, !"Это не Ваш квестовый транспорт!" ) ;
			    }
			}
			
			if ( fire_OnPlayerStateChange ( playerid, newstate, oldstate ) ) return 1 ;
			
			if ( veh_info [ veh_id - 1 ] [ v_type ] == vehicle_type_taxi )
			{
			    if ( p_info [ playerid ] [ job ] != veh_info [ veh_id - 1 ] [ v_owner ] )
			    {
					RemovePlayerFromVehicle ( playerid ) ;
					SendClientMessage ( playerid, 0xFF6600FF, !"Вы не работаете таксистом в данной компании!" ) ;
					return 1 ;
				}
				else
				{
				    if ( player_rentcar [ playerid ] == INVALID_VEHICLE_ID ) return show_dialog ( playerid, d_rentcar, DIALOG_STYLE_MSGBOX, "{FFCC00}Аренда транспорта", "{FFFFFF}Вы действительно хотите взять данный транспорт в аренду?\n\n{828282}Так как транспорт пренадлежит компании,\n{828282}в которой Вы работаете, то аренда бесплатная.", "Выбрать", "Закрыть" ) ;
				}
			}
			if ( veh_info [ veh_id - 1 ] [ v_type ] == vehicle_type_carshering )
			{
			    if ( player_rentcar [ playerid ] != INVALID_VEHICLE_ID )
			    {
					RemovePlayerFromVehicle ( playerid ) ;
					SendClientMessage ( playerid, 0xFF6600FF, !"Данный транспорт уже арендуют!" ) ;
					return 1 ;
				}
				else
				{
				    if ( player_rentcar [ playerid ] == INVALID_VEHICLE_ID )
					{
						new dialog_string [ 256 ] ;
						format ( dialog_string, sizeof dialog_string, "{FFFFFF}Вы действительно хотите взять данный транспорт в аренду?\n\n\
																		{828282}Стоимость аренды транспорта за 1км: {99cc00}%d$", b_info [ veh_info [ veh_id - 1 ] [ v_owner ] - 1 ] [ b_taxi_fare ] ) ;
						show_dialog ( playerid, d_rentcar, DIALOG_STYLE_MSGBOX, "{FFCC00}Аренда транспорта", dialog_string, "Выбрать", "Закрыть" ) ;
					}
				}
			}
			if ( veh_info [ veh_id - 1 ] [ v_type ] == vehicle_type_bus )
			{
			    if ( p_info [ playerid ] [ job ] != veh_info [ veh_id - 1 ] [ v_owner ] )
			    {
					RemovePlayerFromVehicle ( playerid ) ;
					SendClientMessage ( playerid, 0xFF6600FF, !"Вы не работаете водителем автобуса в данной компании!" ) ;
					return 1 ;
				}
				else
				{
				    if ( player_rentcar [ playerid ] == INVALID_VEHICLE_ID ) return show_dialog ( playerid, d_rentcar, DIALOG_STYLE_MSGBOX, "{FFCC00}Аренда транспорта", "{FFFFFF}Вы действительно хотите взять данный транспорт в аренду?\n\n{828282}Так как транспорт пренадлежит компании,\n{828282}в которой Вы работаете, то аренда бесплатная.", "Выбрать", "Закрыть" ) ;
				}
			}
		}
	}
	return 1 ;
}

// marriage
stock show_prist ( playerid )
{
    global_string [ 0 ] = EOS ;
	format ( global_string, 386, "{FFCC00}1. {FFFFFF}Подать заявку на бракосочетание\n\
													{FFCC00}2. {FFFFFF}Купить кольца ({99cc00}%d${FFFFFF})\n\
													{FFCC00}3. {FFFFFF}Купить костюм жениха ({99cc00}%d${FFFFFF})\n\
													{FFCC00}4. {FFFFFF}Купить костюм невесты ({99cc00}%d${FFFFFF})", ring_price, man_marriage_price, woman_marriage_price ) ;
	show_dialog ( playerid, d_prist, DIALOG_STYLE_LIST, "{FFCC00}Церковь", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}
//
public OnPlayerPickUpDynamicPickup ( playerid, pickupid )
{
    if ( GetTickCount ( ) - teleport_tick [ playerid ] < 5000 || p_t_info [ playerid ] [ pickup_id ] != -1 ) return 1 ;

	p_t_info [ playerid ] [ pickup_id ] = pickupid ;
	
	teleport_tick [ playerid ] = GetTickCount ( ) ;

	if ( fire_PickUpDynamicPickup ( playerid, pickupid ) ) return 1 ;

	if ( pickupid == railway_pickup )
	{
		if ( p_info [ playerid ] [ job ] != job_railway ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не работаете машинистом!" ) ;
		if ( ! railway_start [ playerid ] )
		{
			show_dialog ( playerid, d_job_railway, DIALOG_STYLE_MSGBOX, "{FFCC00}Раздевалка:",
			"{FFFFFF}Вы действительно хотите начать рабочий день?", "Да", "Нет" ) ;
		}
		else
		{
			show_dialog ( playerid, d_job_railway, DIALOG_STYLE_MSGBOX, "{FFCC00}Раздевалка:",
			"{FFFFFF}Вы действительно хотите закончить рабочий день?", "Да", "Нет" ) ;
		}
		return 1 ;
	}
	else if ( pickupid == bizz_invite_pickup [ 0 ] ) // taxi new
	{
	    if ( ! b_info [ 38 ] [ b_taxi_auto_invite ] [ 0 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент набор сотрудников закрыт!" ) ;
	    if ( p_info [ playerid ] [ level ] < b_info [ 38 ] [ b_taxi_auto_invite ] [ 1 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Устроиться можно с 2ух лет!" ) ;
		if ( b_info [ 38 ] [ b_taxi_auto_invite ] [ 2 ] )
		{
	   		if ( ! p_info [ playerid ] [ drive_lic ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас нет водительских прав!" ) ;
		}
		if ( p_info [ playerid ] [ job ] != job_none ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже устроены на работу! Используйте /quitjob для увольнения." ) ;

		new dialog_string [ 256 ] ;
		format ( dialog_string, sizeof dialog_string, "{FFFFFF}Таксопарк {FFCC00}%s\n\n{FFFFFF}Комиссия такоспарку за поездку: {99cc00}%d${FFFFFF}\nКоличества транспорта в таксопарке: {99cc00}%d{FFFFFF} машин\n\n{828282}Вы готовы устроиться в таксопарк?", b_info [ 38 ] [ b_name ], b_info [ 38 ] [ b_taxi_fare ], b_info [ 38 ] [ b_taxi_level ] ) ;
		show_dialog ( playerid, d_bizz_auto_invite, DIALOG_STYLE_LIST, "{FFCC00}Таксопарк", dialog_string, "Выбрать", "Назад" ) ;
		
		SetPlayerUseListitem ( playerid, 38 ) ;
		return 1 ;
	}
	else if ( pickupid == bizz_invite_pickup [ 1 ] ) // taxi new
	{
	    if ( ! b_info [ 39 ] [ b_taxi_auto_invite ] [ 0 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент набор сотрудников закрыт!" ) ;
	    if ( p_info [ playerid ] [ level ] < b_info [ 39 ] [ b_taxi_auto_invite ] [ 1 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Устроиться можно с 2ух лет!" ) ;
		if ( b_info [ 39 ] [ b_taxi_auto_invite ] [ 2 ] )
		{
	   		if ( ! p_info [ playerid ] [ drive_lic ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас нет водительских прав!" ) ;
		}
	    if ( p_info [ playerid ] [ job ] != job_none ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже устроены на работу! Используйте /quitjob для увольнения." ) ;

		new dialog_string [ 256 ] ;
		format ( dialog_string, sizeof dialog_string, "{FFFFFF}Таксопарк {FFCC00}%s\n\n{FFFFFF}Комиссия такоспарку за поездку: {99cc00}%d${FFFFFF}\nКоличества транспорта в таксопарке: {99cc00}%d{FFFFFF} машин\n\n{828282}Вы готовы устроиться в таксопарк?", b_info [ 39 ] [ b_name ], b_info [ 39 ] [ b_taxi_fare ], b_info [ 39 ] [ b_taxi_level ] ) ;
		show_dialog ( playerid, d_bizz_auto_invite, DIALOG_STYLE_LIST, "{FFCC00}Таксопарк", dialog_string, "Выбрать", "Назад" ) ;
		
		SetPlayerUseListitem ( playerid, 39 ) ;
		return 1 ;
	}
	else if ( pickupid == bank_pickup )// Taxi
	{
	    if ( p_info [ playerid ] [ business ] == -1 ) return 1 ;
	    if ( b_info [ p_info [ playerid ] [ business ] - 1 ] [ b_type ] != bizz_type_taxi ) return 1 ;
	    
	    show_dialog ( playerid, d_none, DIALOG_STYLE_LIST, "{FFCC00}Управление кассой", "{FFCC00}1.{FFFFFF} Пополнить баланс\n{FFCC00}2.{FFFFFF} Снять наличные", "Выбрать", "Назад" ) ;
	    return 1 ;
	}
	else if ( pickupid == pick_marriage_id )// marriage
	{
	    if ( p_info [ playerid ] [ marriage ] != -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас уже есть зарегистрированный брак." ) ;
	    show_prist ( playerid ) ;
		return 1 ;
	}
	else if ( pickupid == priest_pickup ) // prist
	{
	    if ( ! priest_player [ playerid ] )
		{
			show_dialog ( playerid, d_priest_job, DIALOG_STYLE_MSGBOX, "{FFCC00}Раздевалка:",
			"{FFFFFF}Вы действительно хотите начать рабочий день?", "Да", "Нет" ) ;
		}
		else
		{
			show_dialog ( playerid, d_priest_job, DIALOG_STYLE_MSGBOX, "{FFCC00}Раздевалка:",
			"{FFFFFF}Вы действительно хотите закончить рабочий день?", "Да", "Нет" ) ;
		}
		return 1 ;
	}
	else if ( pickupid == pick_enter_prist [ 0 ] )// marriage
	{
	    if ( marriage_start != p_info [ playerid ] [ marriage_today ] &&
	            marriage_start != p_info [ playerid ] [ wedding ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"В церкви проходит бракосочетание! Вы не являетесь участником данного мероприятия." ) ;
	            
	    set_pos ( playerid, 1256.6434, 2039.3374, 656.6249, 87.1484, 33, 1 ) ;
	    return 1 ;
	}
	else if ( pickupid == pick_enter_prist [ 1 ] )// marriage
	{
	    set_pos ( playerid, 1720.2524, -1741.1508, 13.5469, 358.0450, 0, 0 ) ;
	    return 1 ;
	}
	else if ( pickupid == pick_family_rent )
	{
	    if ( p_info [ playerid ] [ family_everyday_progress ] [ 1 ] != 1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не выполняете семейный квест." ) ;

	    show_dialog ( playerid, d_rentcar_quest, DIALOG_STYLE_MSGBOX, "{FFCC00}Задание", "{FFFFFF}Аренда транспорта бесплатная.\n\n\
																						{828282}* Вы готовы взять транспорт в аренду?", "Да", "Нет" ) ;
	    return 1 ;
	}
	else if ( pickupid == pick_family_box )
	{
	    if ( p_info [ playerid ] [ family_everyday_progress ] [ 1 ] != 2 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не выполняете семейный квест." ) ;

        SetPlayerAttachedObject ( playerid, 0, 3013,6,0.0,0.10,-0.2, -110.0,0.0,78.0 ) ;
	    have_box [ playerid ] = true ;

		SendClientMessage ( playerid, -1, "Вы взяли ящик с патронами. Отнесите и положите его в фургон." ) ;
		SendClientMessage ( playerid, -1, "У задних дверей фургона нажмите 'Y' для того, чтобы положить ящик с патронами." ) ;
		ClearAnimations ( playerid ) ;
		ApplyAnimation(playerid,"CARRY","crry_prtial", 4.1, 0, 1, 1, 1, 1 ) ;
	    return 1 ;
	}
	else if ( pickupid == pick_family_quest )
	{
	    if ( p_info [ playerid ] [ family ] == -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не состоите в семье." ) ;

	    family_everyday_show ( playerid ) ;
	    return 1 ;
	}
	/*else if ( pickupid == pick_buy_seed )
	{
	    global_string [ 0 ] = EOS ;
		new line_string [ 55 + 24 + 4 ] ;

		for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
		{
		    format ( line_string, sizeof line_string, "{FFCC00}%s{FFFFFF}, стоимость покупки: {99cc00}%d$\n", seed_info [ i ] [ s_name ], seed_info [ i ] [ s_price ] ) ;
			strcat ( global_string, line_string ) ;
		}
		show_dialog ( playerid, d_buy_seed, DIALOG_STYLE_LIST, "{FFCC00}Покупка семян", global_string, "Выбрать", "Закрыть" ) ;
		return 1 ;
	}
	else if ( pickupid == pick_sell_seed )
	{
        global_string [ 0 ] = EOS ;
		new line_string [ 55 + 24 + 4 ], _id_seed ;

		for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
		{
		    if ( ! p_info [ playerid ] [ seed_sell ] [ i ] ) continue ;

		    format ( line_string, sizeof line_string, "{FFCC00}%s{FFFFFF}, стоимость продажи: {99cc00}%d$\n", seed_info [ i ] [ s_name ], seed_info [ i ] [ s_sell_price ] * p_info [ playerid ] [ seed_sell ] [ i ] ) ;
			strcat ( global_string, line_string ) ;

			SetPlayerListitemValue ( playerid, _id_seed, i ) ;

			_id_seed ++ ;
		}
		show_dialog ( playerid, d_sell_seed, DIALOG_STYLE_LIST, "{FFCC00}Продажа продукции", global_string, "Выбрать", "Закрыть" ) ;
		return 1 ;
	}*/
	return 1 ;
}

stock show_jackcar ( playerid )
{
	new _skill_level, _skill_name [ 16 ], _status_active [ 64 ] ;
	if ( p_info [ playerid ] [ jackcar_skill ] < 51 )
	{
		_skill_level = 50 - p_info [ playerid ] [ jackcar_skill ] ;
		format ( _skill_name, sizeof _skill_name, "1 уровень" ) ;
	}
	else if ( p_info [ playerid ] [ jackcar_skill ] > 50 && p_info [ playerid ] [ jackcar_skill ] < 101 )
	{
		_skill_level = 100 - p_info [ playerid ] [ jackcar_skill ] ;
		format ( _skill_name, sizeof _skill_name, "2 уровень" ) ;
	}
	else if ( p_info [ playerid ] [ jackcar_skill ] > 100 && p_info [ playerid ] [ jackcar_skill ] < 151 )
	{
		_skill_level = 150 - p_info [ playerid ] [ jackcar_skill ] ;
		format ( _skill_name, sizeof _skill_name, "3 уровень" ) ;
	}
	else _skill_level = 0, format ( _skill_name, sizeof _skill_name, "4 уровень" ) ;

	if ( p_info [ playerid ] [ urgent_cooldown ] > 0 ) format ( _status_active, sizeof _status_active, "{828282}Заказ будет доступен через {CC9900}%s", convert_time ( p_info [ playerid ] [ urgent_cooldown ] ) ) ;
	else format ( _status_active, sizeof _status_active, "{828282}Вы {99cc00}можете {828282}взять заказ" ) ;

	global_string [ 0 ] = EOS ;
	format ( global_string, 1024,"\
			{FFCC00}Автоугон\n\n\
			{FFFFFF}Автоугон доступен только бандитам.\n\
			Перед тем, как доверить угон дорогих транспортных средств\n\
			Вас испытают на дешёвках.\n\
			Если Вы покажите себя хорошо, то, в скором времени,\n\
			начнёте получать хорошие заказы.\n\n\
			{FFCC00}Навык\n\n\
			{FFFFFF}Ваш текущий уровень опыта: %d (%s)\n\
			До перехода на следующий уровень: %d\n\
			%s\n\n\
			{828282}Вы готовы взять заказ?", p_info [ playerid ] [ jackcar_skill ], _skill_name, _skill_level, _status_active ) ;
    show_dialog ( playerid, d_jackcar, DIALOG_STYLE_MSGBOX, "{FFCC00}Автоугон", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

public OnPlayerKeyStateChange ( playerid, newkeys, oldkeys )
{
    if ( newkeys == KEY_YES )
    {
        if ( have_box [ playerid ] )
		{
			foreach ( new veh_id: streamed_vehicles[ playerid ])
			{
				if ( veh_info [ veh_id - 1 ] [ v_model ] != 482 && veh_info [ veh_id - 1 ] [ v_model ] != 433 ) continue ;
				new Float:boot_pos [ 3 ] ;
				GetCoordBootVehicle ( veh_id, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ;
				if ( IsPlayerInRangeOfPoint ( playerid, 2.0, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) )
				{
					RemovePlayerAttachedObject ( playerid, 0 ) ;
					ClearAnimations(playerid);
					ApplyAnimation ( playerid,"CARRY","putdwn",4.0,0,1,1,0,0,1 ) ;
					if ( veh_info [ veh_id - 1 ] [ v_cargo ] + 5 > 50 )
					{
						veh_info [ veh_id - 1 ] [ v_cargo ] = 50 ;
						have_box [ playerid ] = false ;
						SendClientMessage ( playerid, 0xFF6600FF, !"Машина уже полностью загружена оружием." ) ;

						is_gps_used { playerid } = 25 ;
						SetPlayerRaceCheckpoint ( playerid, 1, 295.6434, -1591.7123, 32.5592 - 1.4, 0.0, 0.0, 0.0, 8.0 ) ;
						SendClientMessage ( playerid, 0xFFCC00FF, !"Теперь Вам необходимо разгрузить транспорт. Место отмечено на карте." ) ;

						p_info [ playerid ] [ family_everyday_progress ] [ 1 ] = 3 ;
						return 1 ;
					}
					else veh_info [ veh_id - 1 ] [ v_cargo ] += 5 ;

					new t_string [ 102 ] ;
					format ( t_string, sizeof ( t_string ), "Вы положили ящик в машину. Боеприпасов и оружия в машине {FFCC00}%d{FFFFFF}.",
					veh_info [ veh_id - 1 ] [ v_cargo ] ) ;
					SendClientMessage ( playerid, -1, t_string ) ;
					have_box [ playerid ] = false ;
					return 1 ;
				}
			}
		}

    	key_enter_roulette ( playerid ) ;
	}
	
    if ( newkeys == KEY_WALK )
    {
		if ( needs_OnPlayerKeyStateChange ( playerid, newkeys, oldkeys ) ) return 1 ;
		
        if ( used_area [ playerid ] != -1 )
        {
            if ( area_dynamic_info [ used_area [ playerid ] ] [ a_type ] == area_type_quest )
	        {
	            for ( new i = 0 ; i < sizeof quest_actor ; i ++ )
	            {
	                if ( ! IsPlayerInRangeOfPoint ( playerid, 3.00, quest_actor [ i ] [ q_pos ] [ 0 ], quest_actor [ i ] [ q_pos ] [ 1 ], quest_actor [ i ] [ q_pos ] [ 2 ] ) ) continue ;

	                if ( quest_actor [ i ] [ q_type ] == 1 )
	                {
	                    new dialog_string [ 200 ], _quest_id = p_info [ playerid ] [ getto_quest ] ;
	                    format ( dialog_string, sizeof dialog_string, "{FFCC00}%s\n\n{FFFFFF}Задача: %s\n\nНаграда: %s", g_quest_info [ _quest_id ] [ q_name ], g_quest_info [ _quest_id ] [ q_text ], g_quest_info [ _quest_id ] [ q_rewards ] ) ;
	                    show_dialog ( playerid, d_quest_actor, DIALOG_STYLE_MSGBOX, "{FFCC00}Настоящий гангстер", dialog_string, "Принять", "" ) ;
	                    
	                    SetPlayerUseListitem ( playerid, getto_line ) ;
	                    return 1 ;
	                }
	                else if ( quest_actor [ i ] [ q_type ] == 2 )
	                {
	                    new dialog_string [ 200 ], _quest_id = p_info [ playerid ] [ family_quest ] ;
	                    format ( dialog_string, sizeof dialog_string, "{FFCC00}%s\n\n{FFFFFF}Задача: %s\n\nНаграда: %s", f_quest_info [ _quest_id ] [ q_name ], f_quest_info [ _quest_id ] [ q_text ], f_quest_info [ _quest_id ] [ q_rewards ] ) ;
	                    show_dialog ( playerid, d_quest_actor, DIALOG_STYLE_MSGBOX, "{FFCC00}Семейные узы", dialog_string, "Принять", "" ) ;
	                    
	                    SetPlayerUseListitem ( playerid, family_line ) ;
	                    return 1 ;
	                }
	            }
	        }
	        if ( area_dynamic_info [ used_area [ playerid ] ] [ a_type ] == area_type_drops )
	        {
	            foreach(new g: gun_drops)
	            {
					if ( ! IsPlayerInRangeOfPoint ( playerid, 3.00, gd_info [ g ] [ g_pos ] [ 0 ], gd_info [ g ] [ g_pos ] [ 1 ], gd_info [ g ] [ g_pos ] [ 2 ] ) ) continue ;

					global_string [ 0 ] = EOS ;
					new line_string [ 128 ], _gun_id ;
					for ( new i = 0 ; i < 13 ; i ++ )
					{
					    if ( gd_info [ g ] [ g_gun ] [ i ] == 0 ) continue ;

					    SetPlayerListitemValue ( playerid, _gun_id, i ) ;
					    _gun_id ++ ;

					    new gunname [ 32 ] ;
						GetWeaponName ( gd_info [ g ] [ g_gun ] [ i ], gunname, 32 ) ;
					    format ( line_string, sizeof line_string, "%s [%d патрон]\n", gunname, gd_info [ g ] [ g_ammo ] [ i ] ) ;
					    strcat ( global_string, line_string ) ;
					}
					set_player_use_listitem ( playerid, g ) ;
					show_dialog ( playerid, d_gun_up, DIALOG_STYLE_LIST, "{FFCC00}Ящик с оружием", global_string, "Выбрать", "Закрыть" ) ;
					break ;
	            }
	            return 1 ;
	        }
		}
    
        if ( IsPlayerInRangeOfPoint ( playerid, 5.0, pick_jackcar [ 0 ], pick_jackcar [ 1 ], pick_jackcar [ 2 ] ) )
        {
            show_jackcar ( playerid ) ;
        }
        
        up_trash ( playerid ) ;
        
        /*if ( p_info [ playerid ] [ house ] != -1 )
        {
			new _h_id = p_info [ playerid ] [ house ] ;
			//if ( h_info [ _h_id - 1 ] [ h_garden ] && IsPlayerInRangeOfPoint ( playerid, 10.0, h_info [ _h_id - 1 ] [ h_pos ] [ 0 ], h_info [ _h_id - 1 ] [ h_pos ] [ 1 ], h_info [ _h_id - 1 ] [ h_pos ] [ 2 ] ) )
			//{
				for ( new _id = 0 ; _id < MAX_SEED ; _id ++ )
			    {
			        if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] != 1 ) continue ;
			        if ( ! IsPlayerInRangeOfPoint ( playerid, 2.0, houses_garden_position [ _h_id ] [ _id ] [ 0 ],
																	houses_garden_position [ _h_id ] [ _id ] [ 1 ],
																	houses_garden_position [ _h_id ] [ _id ] [ 2 ] ) ) continue ;
																	
			        if ( IsValidDynamicObject ( h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] ) )
					{
				        h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] = 0 ;

				        DestroyDynamicObject ( h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] ) ;
				        DestroyDynamic3DTextLabel ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ] ) ;

				        new _h_seed = h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ], _random = 2 ;
				        
				        new scm_string [ 43 + 32 + 4 + 4 ] ;
						format ( scm_string, sizeof scm_string, "Вы собрали %s, количество собранного урожая %d шт.", seed_info [ _h_seed ] [ s_sell_name ], _random ) ;
						SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
				        
				        p_info [ playerid ] [ seed_sell ] [ _h_seed ] = _random ;

						new update_string [ 10 * MAX_SEED_INFO ], sql_string [ sizeof update_string + 70 ] ;
					   	for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
					    {
				     		if ( i == MAX_SEED_INFO - 1 ) format ( update_string, sizeof update_string, "%s%d", update_string, p_info [ playerid ] [ seed_sell ] [ i ] ) ;
							else format ( update_string, sizeof update_string, "%s%d|", update_string, p_info [ playerid ] [ seed_sell ] [ i ] ) ;
					    }
					    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_seed_sell` = '%s' WHERE `u_id` = '%d' LIMIT 1", update_string, p_info [ playerid ] [ id ] ) ;
					    mysql_tquery ( sql_connection, sql_string ) ;

						format ( sql_string, sizeof sql_string, "DELETE FROM `houses_garden` WHERE `h_id` = '%d' AND `h_slot` = '%d' LIMIT 1", _h_id, _id ) ;
						mysql_tquery ( sql_connection, sql_string, "", "" ) ;

				        ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
				        break ;
					}
			    }
			//}
		}*/
        return 1 ;
    }

    if ( newkeys == KEY_CROUCH )
    {
        new veh_id = GetPlayerVehicleID ( playerid ) ;
        
		if ( fire_OnPlayerKeyStateChange ( playerid, newkeys, oldkeys ) ) return 1 ;

        if ( IsPlayerInRangeOfPoint ( playerid, 30.0, ship_pick_pos [ 0 ] [ 0 ], ship_pick_pos [ 0 ] [ 1 ], ship_pick_pos [ 0 ] [ 2 ] ) )
	    {
	        if ( start_ship < 91 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Регистрация на паром закрыта! Ожидайте пока она начнётся." ) ; // FSIN
	        if ( front_ship == true ) return SendClientMessage ( playerid, 0xFF6600FF, !"Регистрация на паром закрыта! Ожидайте пока она начнётся." ) ;
	        if ( p_info [ playerid ] [ ship_active ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже зарегистрированы." ) ;

	        new _seat_id = 1, bool: _active_position = false ;
	        for ( new c = 0 ; c < 3 ; c ++ )
		    {
		        if ( ship_player_id [ c ] != INVALID_PLAYER_ID ) continue ;

		        ship_player_id [ c ] = playerid ;

		        foreach(new i: logged_players) // streamed_players[_player_id]
				{
				    if ( veh_id != GetPlayerVehicleID ( i ) ) continue ;
				    if ( playerid == i ) continue ;

				    p_info [ i ] [ ship_in_car ] = veh_id ;
				    p_info [ i ] [ ship_active ] = true ;
				    p_info [ i ] [ seat_id ] = _seat_id ;

				    _seat_id ++ ;
				    
				    SendClientMessage ( i, 0xFF9945FF, "Вас зарегистрировали на паром, не покидайте территорию порта." ) ;
				}

		        p_info [ playerid ] [ ship_car_id ] = veh_id ;
		        p_info [ playerid ] [ ship_active ] = true ;
		        p_info [ playerid ] [ seat_id ] = 0 ;
		        
		        SendClientMessage ( playerid, 0xFF9945FF, "Вы зарегистрировались на паром, не покидайте территорию порта." ) ;
		        _active_position = true ;
		        break ;
		    }
		    if ( _active_position == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"На пароме нет свободных мест." ) ;
		    return 1 ;
	    }
		else if ( IsPlayerInRangeOfPoint ( playerid, 30.0, ship_pick_pos [ 1 ] [ 0 ], ship_pick_pos [ 1 ] [ 1 ], ship_pick_pos [ 1 ] [ 2 ] ) )
		{
		    if ( start_ship < 91 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Регистрация на паром закрыта! Ожидайте пока она начнётся." ) ; // FSIN
		    if ( front_ship == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"Регистрация на паром закрыта! Ожидайте пока она начнётся." ) ;
	        if ( p_info [ playerid ] [ ship_active ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже зарегистрированы." ) ;

	        new _seat_id = 1, bool: _active_position = false ;
	        for ( new c = 0 ; c < 3 ; c ++ )
		    {
		        if ( ship_player_id [ c ] != INVALID_PLAYER_ID ) continue ;

		        ship_player_id [ c ] = playerid ;

		        foreach(new i: logged_players) // streamed_players[_player_id]
				{
				    if ( veh_id != GetPlayerVehicleID ( i ) ) continue ;
				    if ( playerid == i ) continue ;

				    p_info [ i ] [ ship_in_car ] = veh_id ;
				    p_info [ i ] [ ship_active ] = true ;
				    p_info [ i ] [ seat_id ] = _seat_id ;

				    _seat_id ++ ;
				    
				    SendClientMessage ( i, 0xFF9945FF, "Вас зарегистрировали на паром, не покидайте территорию порта." ) ;
				}

		        p_info [ playerid ] [ ship_car_id ] = veh_id ;
		        p_info [ playerid ] [ ship_active ] = true ;
		        p_info [ playerid ] [ seat_id ] = 0 ;
		        
		        SendClientMessage ( playerid, 0xFF9945FF, "Вы зарегистрировались на паром, не покидайте территорию порта." ) ;
		        _active_position = true ;
		        break ;
		    }
		    if ( _active_position == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"На пароме нет свободных мест." ) ;
		    return 1 ;
		}
    }
	return 1 ;
}

public OnPlayerDeath ( playerid, killerid, reason )
{
    if ( p_info [ playerid ] [ c_time ] )
	{
	    if ( IsValidVehicle ( p_info [ playerid ] [ c_vehicle ] ) && veh_info [ p_info [ playerid ] [ c_vehicle ] - 1 ] [ v_owner ] == -1 ) DestroyVehicle ( p_info [ playerid ] [ c_vehicle ] ) ;
		if ( p_info [ playerid ] [ c_icon ] != -1 ) RemovePlayerMapIcon ( playerid, p_info [ playerid ] [ c_icon ] ) ;
	}
	
	new bool: vse_ok_Rom = false, bitch_gang = -1 ;
	for ( new i = 0 ; i < 13 ; i ++ )
	{
	    if ( p_t_info [ playerid ] [ p_gun_slot ] [ i ] == 0 ) continue ;
	    
	    new _g_id = -1 ;
		if ( ! vse_ok_Rom )
		{
		    if ( Iter_Count(gun_drops) >= MAX_DROPS - 1 )
		    {
		        new _g_time = 600 ;
		        foreach(new g: gun_drops)
		        {
		            if ( gettime ( ) - gd_info [ g ] [ g_time ] > _g_time )
		            {
		                _g_time = gd_info [ g ] [ g_time ] ;
		                _g_id = g ;
		                break ;
		            }
		        }
		        
		        if ( _g_id != -1 )
		        {
			        new sql_string [ 59 + 9 ] ;
			        format ( sql_string, sizeof ( sql_string ), "DELETE FROM `player_weapons` WHERE `g_id` = '%d' LIMIT 1", gd_info [ _g_id ] [ g_id ] ) ;
					mysql_tquery ( sql_connection, sql_string ) ;

					Iter_Remove(gun_drops, gd_info [ _g_id ] [ g_id ]);
					DestroyDynamicObject ( gd_info [ _g_id ] [ g_object ] ) ;
					DestroyDynamic3DTextLabel ( gd_info [ _g_id ] [ g_text ] ) ;

					vse_ok_Rom = true ;
					bitch_gang = _g_id ;
				}
				else break ;
		    }
			else
			{
				vse_ok_Rom = true ;
				bitch_gang = Iter_Free(gun_drops);
			}
		}
		if ( vse_ok_Rom )
		{
			gd_info [ bitch_gang ] [ g_gun ] [ i ] = p_t_info [ playerid ] [ p_gun_slot ] [ i ] ;
			gd_info [ bitch_gang ] [ g_ammo ] [ i ] = p_t_info [ playerid ] [ p_gun_ammo ] [ i ] ;
		}
	}
	if ( vse_ok_Rom )
	{
	    gd_info [ bitch_gang ] [ g_id ] = bitch_gang ;
	    
	    Iter_Add(gun_drops, gd_info [ bitch_gang ] [ g_id ]);
	    gd_info [ bitch_gang ] [ g_pos ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
	    gd_info [ bitch_gang ] [ g_pos ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
	    gd_info [ bitch_gang ] [ g_pos ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;
	    
	    gd_info [ bitch_gang ] [ g_time ] = gettime ( ) ;
	    
	    gd_info [ bitch_gang ] [ g_area ] = CreateDynamicSphere ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], 3.0, -1, -1, -1 ) ;
	    area_dynamic_info [ gd_info [ bitch_gang ] [ g_area ] ] [ a_type ] = area_type_drops ;
	    
	    gd_info [ bitch_gang ] [ g_text ] = CreateDynamic3DTextLabel ( "{FFCC00}Ящик с оружием\n\n{FFFFFF}Используйте {FFCC00}ALT{FFFFFF} для взаимодействия", -1, p_t_info [ playerid ] [ p_pos ] [ 0 ],
																																		                           p_t_info [ playerid ] [ p_pos ] [ 1 ],
																																		                           p_t_info [ playerid ] [ p_pos ] [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
																																		                                                                
		gd_info [ bitch_gang ] [ g_object ] = CreateDynamicObject ( 3013, p_t_info [ playerid ] [ p_pos ] [ 0 ],
		                                                                p_t_info [ playerid ] [ p_pos ] [ 1 ],
		                                                                p_t_info [ playerid ] [ p_pos ] [ 2 ] - 0.7,
		                                                                0.0, 0.0, 0.0 ) ;
		
		new gun_string [ 100 ], ammo_string [ 100 ] ;
	    for ( new i = 0 ; i < 13 ; i ++ )
	    {
	        if ( i == 12 ) format ( gun_string, sizeof gun_string, "%s%d", gun_string, gd_info [ bitch_gang ] [ g_gun ] [ i ] ) ;
			else format ( gun_string, sizeof gun_string, "%s%d|", gun_string, gd_info [ bitch_gang ] [ g_gun ] [ i ] ) ;
			
			if ( i == 12 ) format ( ammo_string, sizeof ammo_string, "%s%d", ammo_string, gd_info [ bitch_gang ] [ g_ammo ] [ i ] ) ;
			else format ( ammo_string, sizeof ammo_string, "%s%d|", ammo_string, gd_info [ bitch_gang ] [ g_ammo ] [ i ] ) ;
	    }
		
        global_string [ 0 ] = EOS ;
        format ( global_string, sizeof ( global_string ), "INSERT INTO `player_weapons` (`g_id`,`g_time`,`g_pos_x`,`g_pos_y`,`g_pos_z`,`g_gun`,`g_ammo`) VALUES ('%d','%d','%f','%f','%f','%s','%s')",
		gd_info [ bitch_gang ] [ g_id ], gd_info [ bitch_gang ] [ g_time ], gd_info [ bitch_gang ] [ g_pos ] [ 0 ], gd_info [ bitch_gang ] [ g_pos ] [ 1 ], gd_info [ bitch_gang ] [ g_pos ] [ 2 ],
		gun_string, ammo_string ) ;
		mysql_tquery ( sql_connection, global_string ) ;
	}
	reset_player_weapon ( playerid ) ;
	return 1 ;
}

public OnPlayerDisconnect ( playerid, reason )
{
	KillTimer ( p_info [ playerid ] [ main_timer ] ) ;
	
	if ( player_graffity_timer [ playerid ] != -1 ) // graffity
	{
		KillTimer ( player_graffity_timer [ playerid ] ) ;
		player_graffity_timer [ playerid ] = -1 ;
	}
	
	if ( bg_player_table [ playerid ] != -1 )
	{
	    new _table = bg_player_table [ playerid ] ;
		new target_id = bg_info [ _table ] [ bg_player ] [ 0 ], target_id_1 = bg_info [ _table ] [ bg_player ] [ 1 ] ;

		if ( target_id != INVALID_PLAYER_ID )
		{
		    bg_player_table [ target_id ] = -1 ;
		    bg_used [ target_id ] = false ;
			show_ptd_chess ( target_id, false ) ;
			show_ptd_nards ( 0, _table, false ) ;
		}
		if ( target_id_1 != INVALID_PLAYER_ID )
		{
		    bg_player_table [ target_id_1 ] = -1 ;
		    bg_used [ target_id_1 ] = false ;
			show_ptd_chess ( target_id_1, false ) ;
			show_ptd_nards ( 1, _table, false ) ;
		}
	}
	
	if ( railway_car [ playerid ] != INVALID_VEHICLE_ID )
	{
	    DestroyVehicle ( railway_car [ playerid ] ) ;
	    railway_car [ playerid ] = INVALID_VEHICLE_ID ;
	}
	
    fire_OnPlayerDisconnect ( playerid ) ;

	if ( p_info [ playerid ] [ c_time ] )
	{
	    if ( IsValidVehicle ( p_info [ playerid ] [ c_vehicle ] ) && veh_info [ p_info [ playerid ] [ c_vehicle ] - 1 ] [ v_owner ] == -1 ) DestroyVehicle ( p_info [ playerid ] [ c_vehicle ] ) ;
		if ( p_info [ playerid ] [ c_icon ] != -1 ) RemovePlayerMapIcon ( playerid, p_info [ playerid ] [ c_icon ] ) ;
	}
	
	if ( p_info [ playerid ] [ family_everyday_progress ] [ 1 ] )
	{
		if ( p_info [ playerid ] [ family_everyday_car ] != INVALID_VEHICLE_ID )
		{
	    	DestroyVehicle ( p_info [ playerid ] [ family_everyday_car ] ) ;
		}
	}
	
	if ( roulette_used { playerid } )
	{
	    new _table_id = roulette_used { playerid } - 1 ;
		for ( new p = 0 ; p < 6 ; p ++ )
		{
 			if ( roulette_players [ _table_id ] [ p ] != playerid ) continue ;
   			{
		        roulette_used { playerid } = 0 ;
		        roulette_players [ _table_id ] [ p ] = INVALID_PLAYER_ID ;

		        show_roulette_ptd ( playerid, false ) ;
				show_roulette_players ( playerid, _table_id, false ) ;
		   	}
	    }
	}
	
	if ( p_info [ playerid ] [ taxi_accept_cooldown ] > 0 )
    {
		DestroyActor ( p_info [ playerid ] [ taxi_actor ] ) ;
		p_info [ playerid ] [ taxi_cooldown ] = 0 ;
		if ( GetPlayerVehicleID ( playerid ) != 0 ) veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_player_driver ] = INVALID_PLAYER_ID ;
		p_info [ playerid ] [ taxi_okey ] = false ;
  	}
  	if ( p_info [ playerid ] [ taxi_okey_actor ] != -1 )
	{
		actor_pos_toggled [ p_info [ playerid ] [ taxi_okey_actor ] ] = false ; // taxi edit
		p_info [ playerid ] [ taxi_okey_actor ] = -1 ;
	}
	
	/*if ( p_info [ _player_id ] [ ship_active ] )
	{
	    new _veh_id = p_info [ _player_id ] [ ship_car_id ] ;
		if ( _veh_id != INVALID_VEHICLE_ID )
		{
		    if ( veh_info [ _veh_id - 1 ] [ v_type ] != vehicle_type_player )
		    {
		        SetVehicleToRespawn ( _veh_id ) ;
		    }
		}
 	}*/
 	
 	update_int_sql ( playerid, "u_urgent_cooldown", p_info [ playerid ] [ urgent_cooldown ] ) ;
 	
	if ( p_info [ playerid ] [ job ] > 1000 )
	{
		new sql_format [ 256 ] ;
		format ( sql_format, sizeof sql_format, "UPDATE `users` SET `u_day_money` = '%d',\
																	`u_week_money` = '%d',\
																	`u_month_money` = '%d',\
																	`u_all_money` = '%d',\
																	`u_millage` = '%.1f',\
																	`u_taxi_order` = '%d' WHERE `u_id` = '%d' LIMIT 1",
		p_info [ playerid ] [ day_money ], p_info [ playerid ] [ week_money ], p_info [ playerid ] [ month_money ],
		p_info [ playerid ] [ all_money ], p_info [ playerid ] [ millage ], p_info [ playerid ] [ taxi_order ], p_info [ playerid ] [ id ] ) ;
	}
	
	new sql_format [ 77 + 6 + 9 ] ;
	format ( sql_format, sizeof sql_format, "UPDATE `users` SET `u_disease_cooldown` = '%d' WHERE `u_id` = '%d' LIMIT 1",
	p_info [ playerid ] [ p_disease_cooldown ], p_info [ playerid ] [ id ] ) ;

	if ( Iter_Count(streamed_vehicles[ playerid ]) != 0) Iter_Clear(streamed_vehicles[ playerid ]) ;
	Iter_Remove(logged_players, playerid);
	return 1 ;
}

/* 

	Пример вызова: 
	игрок зашёл в игру, если он сидит в тюрьме то делаем так:
	update_kpz_text ( playerid, +1 ) ;
	
	Если игрок отсидел в тюрмье:
	update_kpz_text ( playerid, -1 ) ;
	
*/
stock update_kpz_text ( playerid, _action ) // FSIN
{
	new _kpz_id ;
	switch ( p_info [ playerid ] [ jail ] )
	{
		case 0: count_player_kpz [ 0 ] += _action, _kpz_id = 0 ;
		case 1: count_player_kpz [ 1 ] += _action, _kpz_id = 1 ;
		case 99: count_player_kpz [ 2 ] += _action, _kpz_id = 2 ;
	}
	new d_string [ 78 + 4 ] ;
	format ( d_string, sizeof d_string, "{FFCC00}Статистика\n\n{FFFFFF}Отсиживают срок {99cc00}%d {FFFFFF}человек(а)", count_player_kpz [ _kpz_id ] ) ;
	UpdateDynamic3DTextLabelText ( kpz_3d_text [ _kpz_id ], -1, d_string ) ;
	return 1 ;
}

new Float: fsin_position [ 4 ] = { 0.0, 0.0, 0.0, 0.0 } ; // FSIN

forward player_timer ( playerid ) ;
public player_timer ( playerid )
{
	GetPlayerPos ( playerid, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ] ) ;

	if ( p_info [ playerid ] [ jail ] > 0 ) // FSIN
	{
		if ( p_info [ playerid ] [ jail ] != 99 )
		{
			if ( p_info [ playerid ] [ kpz_time ] > 600 )
			{
				p_info [ playerid ] [ jail ] = 99 ;
				update_int_sql ( playerid, "u_jail", p_info [ playerid ] [ jail ] ) ;
				
				set_pos ( playerid, fsin_position [ 0 ], fsin_position [ 1 ], fsin_position [ 2 ], fsin_position [ 3 ], 0, 0 ) ;
				SendClientMessage ( playerid, 0xFFCC00, !"Вы были автоматически переведены в тюрьму строго режима!" ) ;
				
				p_info [ playerid ] [ kpz_time ] = 0 ;
			}
			else p_info [ playerid ] [ kpz_time ] ++ ;
		}
	}

    if ( p_t_info [ playerid ] [ pickup_id ] != -1 )
	{
	    new _pickup_id = p_t_info [ playerid ] [ pickup_id ] ;
	    if ( GetPlayerDistanceFromPoint ( playerid, pick_info [ _pickup_id ] [ pick_pos ] [ 0 ],
													pick_info [ _pickup_id ] [ pick_pos ] [ 1 ],
													pick_info [ _pickup_id ] [ pick_pos ] [ 2 ] ) > 3 ) p_t_info [ playerid ] [ pickup_id ] = -1 ;
	}
	
	if ( p_info [ playerid ] [ p_disease_cooldown ] > 0 ) p_info [ playerid ] [ p_disease_cooldown ] -- ;
	if ( ! p_info [ playerid ] [ p_drugs_healing ] && p_info [ playerid ] [ p_disease ] >= 1000 )
	{
		if ( p_info [ playerid ] [ p_disease ] >= 1000 && p_info [ playerid ] [ p_disease ] < 2000 )
		{
			if ( ++p_info [ playerid ] [ send_crack ] > 60 * 60 )
			{
				SendClientMessage ( playerid, 0xFF6600FF, !"У Вас началась ломка, употребите наркотик или обратитесь к врачу.");

				p_info [ playerid ] [ send_crack ] = 0 ;
				if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT ) ApplyAnimation ( playerid, "CRACK", "CRCKDETH1", 4.0, 1, 1, 1, 1, 0) ;
			}
		}
		else if ( p_info [ playerid ] [ p_disease ] >= 2000 && p_info [ playerid ] [ p_disease ] < 5000 )
		{
			if ( ++p_info [ playerid ] [ send_crack ] > 60 * 30 )
			{
				SendClientMessage ( playerid, 0xFF6600FF, !"У Вас началась ломка, употребите наркотик или обратитесь к врачу.");

				p_info [ playerid ] [ send_crack ] = 0 ;
				if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT ) ApplyAnimation ( playerid, "CRACK", "CRCKDETH1", 4.0, 1, 1, 1, 1, 0) ;
			}
		}
		else if ( p_info [ playerid ] [ p_disease ] >= 5000 )
		{
			if ( ++p_info [ playerid ] [ send_crack ] > 60 * 10 )
			{
				SendClientMessage ( playerid, 0xFF6600FF, !"У Вас началась ломка, употребите наркотик или обратитесь к врачу.");

				p_info [ playerid ] [ send_crack ] = 0 ;
				if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT ) ApplyAnimation ( playerid, "CRACK", "CRCKDETH1", 4.0, 1, 1, 1, 1, 0) ;
			}
		}
	}

	fire_player_timer ( playerid ) ;
	
	if ( player_rentcar [ playerid ] != INVALID_PLAYER_ID )
	{
		new _b_id = veh_info [ player_rentcar [ playerid ] - 1 ] [ v_owner ] ;
	    new sum = floatround ( ( veh_info [ player_rentcar [ playerid ] - 1 ] [ v_millage ] - p_t_info [ playerid ] [ pTaxiStart ] ) * b_info [ _b_id - 1 ] [ b_cost ] ) ;

		new td_string [ 24 ] ;
		format ( td_string, sizeof ( td_string ), "~w~%d$", sum ) ;
		GameTextForPlayer ( playerid, td_string, 300, 4 ) ;
	}
	
	if ( p_t_info [ playerid ] [ taxi_assement ] > 0 ) p_t_info [ playerid ] [ taxi_assement ] -- ; // Taxi

	if ( p_info [ playerid ] [ taxi_cooldown ] > 0 ) // Taxi
	{
        p_info [ playerid ] [ taxi_cooldown ] -- ;
        if ( p_info [ playerid ] [ taxi_cooldown ] == 1 )
        {
			new _random, _a_count = 0 ;
			do
			{
			    _random = random ( sizeof actor_pos ) ;
			    _a_count ++ ;
			}
			while ( actor_pos_toggled [ _random ] == true && _a_count < 10 ) ;
			
			if ( actor_pos_toggled [ _random ] == false )
			{
			    new bool: free_slot = false ;
			    for ( new i = 0 ; i < 3 ; i ++ )
			    {
					if ( p_info [ playerid ] [ taxi_accept ] [ i ] == true ) continue ;
					SendClientMessage ( playerid, 0xFF9945FF, "Появился заказ, для того, чтобы его принять используйте /gotaxi." ) ;
					p_info [ playerid ] [ taxi_accept ] [ i ] = true ;

					p_info [ playerid ] [ taxi_actor_id ] [ i ] = _random ;
					p_info [ playerid ] [ taxi_actor_name ] [ i ] = random ( sizeof actor_name ) ;
					
					free_slot = true ;
					break ;
				}
				if ( free_slot == false ) p_info [ playerid ] [ taxi_cooldown ] = 300 ;
			}
			else p_info [ playerid ] [ taxi_cooldown ] = 300 ;
        }
	}
	
	if ( p_info [ playerid ] [ taxi_accept_cooldown ] > 0 )
	{
        p_info [ playerid ] [ taxi_accept_cooldown ] -- ;
        
        if ( p_info [ playerid ] [ taxi_accept_cooldown ] == 1 )
        {
			SendClientMessage ( playerid, 0xFF6600FF, !"Вы не успели доставить пассажира. Ожидайте следующий заказ." ) ;
			DestroyActor ( p_info [ playerid ] [ taxi_actor ] ) ;
			p_info [ playerid ] [ taxi_cooldown ] = 300 ;
			p_info [ playerid ] [ taxi_okey ] = false ;
			if ( GetPlayerVehicleID ( playerid ) != 0 ) veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_player_driver ] = INVALID_PLAYER_ID ;
			
			if ( p_info [ playerid ] [ taxi_okey_actor ] != -1 )
			{
				actor_pos_toggled [ p_info [ playerid ] [ taxi_okey_actor ] ] = false ; // taxi edit
				p_info [ playerid ] [ taxi_okey_actor ] = -1 ;
			}
        }
        else if ( p_info [ playerid ] [ taxi_accept_cooldown ] == 690 )
        {
            p_info [ playerid ] [ taxi_accept_cooldown ] = 0 ;
			DestroyActor ( p_info [ playerid ] [ taxi_actor ] ) ;
			p_info [ playerid ] [ taxi_cooldown ] = 300 ;
			p_info [ playerid ] [ taxi_okey ] = false ;
			
			if ( p_info [ playerid ] [ taxi_okey_actor ] != -1 )
			{
				actor_pos_toggled [ p_info [ playerid ] [ taxi_okey_actor ] ] = false ; // taxi edit
				p_info [ playerid ] [ taxi_okey_actor ] = -1 ;
			}
        }
        else if ( p_info [ playerid ] [ taxi_accept_cooldown ] > 1 && p_info [ playerid ] [ taxi_accept_cooldown ] < 600 && is_gps_used { playerid } == 17 )
        {
            actor_taxi_time { playerid } ++ ;
            if ( actor_taxi_time { playerid } == 30 )
            {
                actor_taxi_time { playerid } = 0 ;
                switch ( random ( 4 ) )
                {
                	case 0: SendClientMessage ( playerid, 0xFF9945FF, "Пассажир: {FFFFFF}чего так медленно? Как будто на бутылке сидишь." ) ;
                	case 1: SendClientMessage ( playerid, 0xFF9945FF, "Пассажир: {FFFFFF}ну, на педальку нажми сильнее, а то пока доедем я сдохну." ) ;
                	case 2: SendClientMessage ( playerid, 0xFF9945FF, "Пассажир: {FFFFFF}молодцом, ниггер. Хорошо водишь, прям как по пальмам лазаешь." ) ;
                	case 3: SendClientMessage ( playerid, 0xFF9945FF, "Пассажир: {FFFFFF}ВОН БОМЖАРА, ДАВИИИИИИИИИИИИИИ." ) ;
				}
            }
        
            /*new vehicleid = GetPlayerVehicleID ( playerid ) ;
            if ( vehicleid != 0 )
            {
				new _b_id = p_info [ playerid ] [ job ] ;
	            new sum = floatround ( ( veh_info [ vehicleid - 1 ] [ v_millage ] - p_t_info [ playerid ] [ pTaxiStart ] ) * b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;

				new td_string [ 24 ] ;
				format ( td_string, sizeof ( td_string ), "~w~%d$", sum ) ;
				GameTextForPlayer ( playerid, td_string, 300, 4 ) ;

				if ( sum > 0 )
				{
				    new _b_money = floatround ( ( sum * b_info [ _b_id - 1 ] [ b_cost ] ) / 100 ) ;
				    b_info [ _b_id - 1 ] [ b_money ] += _b_money ;
				    b_info [ _b_id - 1 ] [ b_cash_today ] += _b_money ;
				    
				    p_info [ playerid ] [ day_money ] += sum - _b_money ;
				    p_info [ playerid ] [ week_money ] += sum - _b_money ;
				    p_info [ playerid ] [ month_money ] += sum - _b_money ;
				    p_info [ playerid ] [ all_money ] += sum - _b_money ;
				    
				    p_info [ playerid ] [ millage ] += veh_info [ vehicleid - 1 ] [ v_millage ] - p_t_info [ playerid ] [ pTaxiStart ] ;

					give_money ( playerid, sum - _b_money ) ;
				}
			}*/
        }
	}
	
	if ( p_info [ playerid ] [ fare_time ] > 0 && player_station_area [ playerid ] )
	{
	    p_info [ playerid ] [ fare_time ] -- ;
	    if ( p_info [ playerid ] [ fare_time ] == 1 )
	    {
	        p_info [ playerid ] [ fare_time ] = 90 + floatround ( player_fare [ playerid ] / 100 ) ;
	        player_station_area [ playerid ] = false ;
	        set_pos ( playerid, bus_interior [ 0 ], bus_interior [ 1 ], bus_interior [ 2 ], bus_interior [ 3 ], 33, playerid ) ;
	        
	        td_fare_show ( playerid, true ) ;
	    }
	}
	
	if ( p_info [ playerid ] [ fare_time ] > 0 && ! player_station_area [ playerid ] )
	{
	    p_info [ playerid ] [ fare_time ] -- ;
	    
	    new td_string [ 16 ] ;
	    format ( td_string, sizeof td_string, "%s", convert_time ( p_info [ playerid ] [ fare_time ] ) ) ;
	    PlayerTextDrawSetString ( playerid, fare_time_PTD [ playerid ] [ 1 ], td_string ) ;
	    
	    if ( p_info [ playerid ] [ fare_time ] == 1 )
	    {
	        p_info [ playerid ] [ fare_time ] = 0 ;
	        player_station_area [ playerid ] = false ;
	        
	        td_fare_show ( playerid, false ) ;
	        
			new _state_id = p_info [ playerid ] [ station_id ] ;
	        set_pos ( playerid, station_position [ _state_id ] [ 0 ], station_position [ _state_id ] [ 1 ], station_position [ _state_id ] [ 2 ], station_position [ _state_id ] [ 3 ], 0, 0 ) ;
	    }
	}
	
	/*if ( p_info [ playerid ] [ ship_active ] )
	{
	    if ( ! IsPlayerInRangeOfPoint ( playerid, 30.0, ship_pick_pos [ 0 ] [ 0 ], ship_pick_pos [ 0 ] [ 1 ], ship_pick_pos [ 0 ] [ 2 ] ) &&
			! IsPlayerInRangeOfPoint ( playerid, 30.0, ship_pick_pos [ 1 ] [ 0 ], ship_pick_pos [ 1 ] [ 1 ], ship_pick_pos [ 1 ] [ 2 ] ) &&
			! IsPlayerInRangeOfPoint ( playerid, 30.0, ship_in_pos [ 0 ], ship_in_pos [ 1 ] [ 1 ], ship_in_pos [ 1 ] [ 2 ] ) )
		{
		    SendClientMessage ( playerid, 0xFF6600FF, !"Вы покинули территорию порта! Ваш транспорт не будет переправлен." ) ;
		    clear_player_ship ( playerid ) ;
		    
		    foreach(new i: logged_players) // streamed_players[_player_id]
			{
			    if ( p_info [ playerid ] [ ship_car_id ] != p_info [ i ] [ ship_in_car ] ) continue ;
			    
			    clear_player_ship ( i ) ;
			}
		}
	}*/
	
	if ( p_info [ playerid ] [ ship_active ] && start_ship < 91 ) // FSIN
	{
	    new td_string [ 16 ] ;
	    format ( td_string, sizeof td_string, "%s", convert_time ( start_ship ) ) ;
	    PlayerTextDrawSetString ( playerid, ship_time_PTD [ playerid ] [ 1 ], td_string ) ;
	}
	
	if ( p_info [ playerid ] [ c_time ] > 0 ) p_info [ playerid ] [ c_time ] -- ;
	if ( p_info [ playerid ] [ c_time ] == 1 )
	{
	    if ( IsValidVehicle ( p_info [ playerid ] [ c_vehicle ] ) && veh_info [ p_info [ playerid ] [ c_vehicle ] - 1 ] [ v_owner ] == -1 ) DestroyVehicle ( p_info [ playerid ] [ c_vehicle ] ) ;
  		if ( p_info [ playerid ] [ c_icon ] != -1 ) RemovePlayerMapIcon ( playerid, p_info [ playerid ] [ c_icon ] ) ;
  		
  		SendClientMessage ( playerid, 0xFF6600FF, !"Время вышло! Вы не успели пригнать транспорт." ) ;
  		clear_player_jackcar ( playerid ) ;
	}
	
	if ( p_info [ playerid ] [ jacked ] > 0 ) p_info [ playerid ] [ jacked ] -- ;
	if ( p_info [ playerid ] [ jacked ] == 10 )
	{
	    SendClientMessage ( playerid, 0xFF9945FF, "Ты успешно взломал транспорт! Вези его тому, кто давал тебе задание." ) ;
	    if ( p_info [ playerid ] [ c_icon ] != -1 ) RemovePlayerMapIcon ( playerid, p_info [ playerid ] [ c_icon ] ) ;
	    ClearAnimations ( playerid, 1 ) ;
	    
	    new engine, lights, alarm, doors, bonnet, boot, objective, vehicle_id = p_info [ playerid ] [ c_vehicle ] ;

		veh_info [ vehicle_id - 1 ] [ v_locked ] = false ;
		GetVehicleParamsEx ( vehicle_id, engine, lights, alarm, doors, bonnet, boot, objective ) ;
		SetVehicleParamsEx ( vehicle_id, engine, lights, alarm, false, bonnet, boot, objective ) ;

		is_gps_used { playerid } = 15 ;
		SetPlayerRaceCheckpoint ( playerid, 1, pick_jackcar [ 0 ], pick_jackcar [ 1 ], pick_jackcar [ 2 ] - 1.4, 0.0, 0.0, 0.0, 6.0 ) ;
		
		suspect_player ( playerid, "автоугон", 3 ) ;
	}
	if ( p_info [ playerid ] [ jacked ] == 1 )
	{
	    if ( p_info [ playerid ] [ jackcar_skill ] < 51 ) ls_place_toggled [ p_info [ playerid ] [ c_pos_toggled ] ] = false ;
		else if ( p_info [ playerid ] [ jackcar_skill ] > 50 && p_info [ playerid ] [ jackcar_skill ] < 101 ) sf_place_toggled [ p_info [ playerid ] [ c_pos_toggled ] ] = false ;
		else if ( p_info [ playerid ] [ jackcar_skill ] > 100 && p_info [ playerid ] [ jackcar_skill ] < 151 ) lv_place_toggled [ p_info [ playerid ] [ c_pos_toggled ] ] = false ;
		else premium_place_toggled [ p_info [ playerid ] [ c_pos_toggled ] ] = false ;
	}
	
	if ( p_info [ playerid ] [ urgent_cooldown ] > 0 ) p_info [ playerid ] [ urgent_cooldown ] -- ;
	
	new vehicleid = GetPlayerVehicleID ( playerid ) ;
	if ( vehicleid != 0 )
	{
		if ( veh_info [ vehicleid - 1 ] [ v_type ] == vehicle_type_taxi )
		{
		    if ( veh_info [ vehicleid - 1 ] [ v_owner ] == p_info [ playerid ] [ job ] )
		    {
		        new _b_id = p_info [ playerid ] [ job ] ;
				if ( p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] != INVALID_PLAYER_ID )
				{
					new gig = p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] ;
					if ( ! IsPlayerConnected ( gig ) || GetPlayerVehicleID ( gig ) != vehicleid ) p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] = INVALID_PLAYER_ID ;
				}
				if ( p_t_info [ playerid ] [ pTaxiTurn ] [ 1 ] != INVALID_PLAYER_ID )
				{
					new gig = p_t_info [ playerid ] [ pTaxiTurn ] [ 1 ] ;
					if ( ! IsPlayerConnected ( gig ) || GetPlayerVehicleID ( gig ) != vehicleid ) p_t_info [ playerid ] [ pTaxiTurn ] [ 1 ] = INVALID_PLAYER_ID ;
				}

				new passid = p_t_info [ playerid ] [ pTaxiPass ] ;
				if ( ! IsPlayerConnected ( passid ) || passid == INVALID_PLAYER_ID )
				{
					p_t_info [ playerid ] [ pTaxiGoing ] = false ;
					p_t_info [ playerid ] [ pTaxiPass ] = INVALID_PLAYER_ID ;
					p_t_info [ playerid ] [ pTaxiStart ] = 0.0 ;
				}
				else
				{
					new sum = floatround ( ( veh_info [ vehicleid - 1 ] [ v_millage ] - p_t_info [ playerid ] [ pTaxiStart ] ) * b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ; // Taxi
					if ( IsPlayerConnected ( passid ) && GetPlayerVehicleID ( passid ) == vehicleid )
					{
						new td_string [ 24 ] ;
						format ( td_string, sizeof ( td_string ), "~w~%d$", sum ) ;
						GameTextForPlayer ( playerid, td_string, 300, 4 ) ;
						GameTextForPlayer ( passid, td_string, 300, 4 ) ;

						if( p_info [ passid ] [ money ] < sum )
						{
							SendClientMessage ( passid, 0xFF6600FF, "Недостаточно средств для проезда на такси." ) ;
							if ( p_info [ passid ] [ money ] - sum > -5 && sum > 0)
							{
							    p_info [ playerid ] [ salary ] += sum;
								give_money ( playerid, sum ) ;
								give_money ( passid, -sum ) ;
							}
							p_t_info [ playerid ] [ pTaxiGoing ] = false ;
							p_t_info [ playerid ] [ pTaxiPass ] = INVALID_PLAYER_ID ;
							p_t_info [ playerid ] [ pTaxiStart ] = 0.0 ;
							RemovePlayerFromVehicle ( passid ) ;
							DeletePVar ( passid, "map_mark" ) ;
							passid = INVALID_PLAYER_ID ;
							return 1 ;
						}
					}
					else
					{
						p_t_info [ playerid ] [ pTaxiGoing ] = false ;
						p_t_info [ playerid ] [ pTaxiPass ] = INVALID_PLAYER_ID ;
						p_t_info [ playerid ] [ pTaxiStart ] = 0.0 ;
						DeletePVar ( passid, "map_mark" ) ;
						if ( sum > 0 )
						{
						    new _b_money = floatround ( ( sum * b_info [ _b_id - 1 ] [ b_cost ] ) / 100 ) ; // Taxi
						    b_info [ _b_id - 1 ] [ b_money ] += _b_money ;
						    b_info [ _b_id - 1 ] [ b_cash_today ] += _b_money ;
						    
						    p_info [ playerid ] [ day_money ] += sum - _b_money ; // Taxi
						    p_info [ playerid ] [ week_money ] += sum - _b_money ; // Taxi
						    p_info [ playerid ] [ month_money ] += sum - _b_money ; // Taxi
						    p_info [ playerid ] [ all_money ] += sum - _b_money ; // Taxi
						    
						    p_info [ playerid ] [ millage ] += veh_info [ vehicleid - 1 ] [ v_millage ] - p_t_info [ playerid ] [ pTaxiStart ] ; // Taxi

							give_money ( playerid, sum - _b_money ) ;
							give_money ( passid, -sum ) ;
						}
						passid = INVALID_PLAYER_ID ;
					}
				}
				if ( passid == INVALID_PLAYER_ID && p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] != INVALID_PLAYER_ID )
				{
					passid = p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] ;
					if ( IsPlayerConnected ( passid ) && GetPlayerVehicleID ( passid ) == vehicleid )
					{
						if( p_info [ passid ] [ money ] < b_info [ _b_id - 1 ] [ b_taxi_fare ] )
						{
							SendClientMessage ( passid, 0xFF6600FF, "Недостаточно средств для проезда на такси." ) ;
							return RemovePlayerFromVehicle ( passid ) ;
						}
						p_t_info [ playerid ] [ pTaxiStart ] = veh_info [ vehicleid - 1 ] [ v_millage ] ;
						p_t_info [ playerid ] [ pTaxiPass ] = passid ;
						p_t_info [ playerid ] [ pTaxiGoing ] = true ;
						p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] = INVALID_PLAYER_ID ;

						show_dialog ( passid, d_taxi_mark, DIALOG_STYLE_LIST, "{FFCC00}Навигатор таксиста", "{FFCC00}1. {FFFFFF}Установить метку на карте\n{FFCC00}2. {FFFFFF}Установить метку из GPS навигатора\n{828282}Продолжать поездку без навигатора", "Выбрать", "Закрыть" ) ;

						new scm_string [ 77 + MAX_PLAYER_NAME ] ;
						format( scm_string, sizeof ( scm_string ), "Теперь за проезд будет платить {99cc00}%s{FFFFFF}.", p_info [ passid ] [  name ] ) ;
						SendClientMessage ( playerid, -1, scm_string ) ;
						SendClientMessage ( passid, -1, "Теперь Вы платите за проезд" ) ;
					}
					else p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] = INVALID_PLAYER_ID ;
				}
				if ( p_t_info [ playerid ] [ pTaxiTurn ] [ 1 ] != INVALID_PLAYER_ID && p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] == INVALID_PLAYER_ID ) { p_t_info [ playerid ] [ pTaxiTurn ] [ 0 ] = p_t_info [ playerid ] [ pTaxiTurn ] [ 1 ] ; p_t_info [ playerid ] [ pTaxiTurn ] [ 1 ] = INVALID_PLAYER_ID ; }
			}
		}
	}
	return 1 ;
}

/*CMD:buy_seed ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 55 + 24 + 4 ] ;

	for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
	{
	    format ( line_string, sizeof line_string, "{FFCC00}%s{FFFFFF}, стоимость покупки: {99cc00}%d$\n", seed_info [ i ] [ s_name ], seed_info [ i ] [ s_price ] ) ;
		strcat ( global_string, line_string ) ;
	}
	show_dialog ( playerid, d_buy_seed, DIALOG_STYLE_LIST, "{FFCC00}Покупка семян", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

CMD:sell_seed ( playerid )
{
    global_string [ 0 ] = EOS ;
	new line_string [ 55 + 24 + 4 ], _id_seed ;

	for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
	{
	    if ( ! p_info [ playerid ] [ seed_sell ] [ i ] ) continue ;
	
	    format ( line_string, sizeof line_string, "{FFCC00}%s{FFFFFF}, стоимость продажи: {99cc00}%d$\n", seed_info [ i ] [ s_name ], seed_info [ i ] [ s_sell_price ] * p_info [ playerid ] [ seed_sell ] [ i ] ) ;
		strcat ( global_string, line_string ) ;
		
		SetPlayerListitemValue ( playerid, _id_seed, i ) ;

		_id_seed ++ ;
	}
	show_dialog ( playerid, d_sell_seed, DIALOG_STYLE_LIST, "{FFCC00}Продажа продукции", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

CMD:test_seed ( playerid )
{
	global_string [ 0 ] = EOS ;
	new line_string [ 59 + 24 + 4 ], _id_seed ;
	
	for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
	{
	    if ( ! p_info [ playerid ] [ p_seed ] [ i ] ) continue ;
	    
	    format ( line_string, sizeof line_string, "{FFCC00}%s{FFFFFF}, количество: {99cc00}%d {FFFFFF}шт.\n", seed_info [ i ] [ s_name ], p_info [ playerid ] [ p_seed ] [ i ] ) ;
		strcat ( global_string, line_string ) ;
		
		SetPlayerListitemValue ( playerid, _id_seed, i ) ;

		_id_seed ++ ;
	}
	show_dialog ( playerid, d_player_inv, DIALOG_STYLE_LIST, "{FFCC00}Садовый инвентарь", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock create_seed_position ( playerid, _seed_position )
{
    new _h_id = p_info [ playerid ] [ house ], bool: _free_id ;
    for ( new _id = 0 ; _id < MAX_SEED ; _id ++ )
    {
        if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] > 0 ) continue ;
        
        h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] = seed_info [ _seed_position ] [ s_time ] ;
        h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] = 0 ;
        
        new Float: x, Float: y, Float: z ;
        GetPlayerPos ( playerid, x, y, z ) ;
        
        houses_garden_position [ _h_id ] [ _id ] [ 0 ] = x ;
        houses_garden_position [ _h_id ] [ _id ] [ 1 ] = y ;
        houses_garden_position [ _h_id ] [ _id ] [ 2 ] = z ;
        
        h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] = _seed_position ;
        
        new _z_update = h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] * 2 ;
		h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = CreateDynamicObject ( seed_info [ _seed_position ] [ s_object ], houses_garden_position [ _h_id ] [ _id ] [ 0 ],
																						houses_garden_position [ _h_id ] [ _id ] [ 1 ],
																					 	( houses_garden_position [ _h_id ] [ _id ] [ 2 ] - 12 ) + _z_update,
																						0.0, 0.0, 0.0 ,
																						0, 0 ) ;
																						
        new text_label [ 59 + 32 + 4 ] ;
	    format ( text_label, sizeof text_label, "{FFCC00}%s\n\n{FFFFFF}До созревания: {99cc00}%d минут(ы)", seed_info [ _seed_position ] [ s_name ], h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] ) ;
	    h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ] = CreateDynamic3DTextLabel ( text_label, -1, houses_garden_position [ _h_id ] [ _id ] [ 0 ],
																									houses_garden_position [ _h_id ] [ _id ] [ 1 ],
																									houses_garden_position [ _h_id ] [ _id ] [ 2 ] + 0.8, 5.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 0, 0 ) ;

        global_string [ 0 ] = EOS ;
        format ( global_string, sizeof ( global_string ), "INSERT INTO `houses_garden` (`h_id`,`h_slot`,`h_garden_time`,`h_garden_seed`,`h_pos_x`,`h_pos_y`,`h_pos_z`) VALUES ('%d','%d','%d','%d','%f','%f','%f')",
		_h_id, _id, h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ], _seed_position, houses_garden_position [ _h_id ] [ _id ] [ 0 ], houses_garden_position [ _h_id ] [ _id ] [ 1 ], houses_garden_position [ _h_id ] [ _id ] [ 2 ] ) ;
		mysql_tquery ( sql_connection, global_string ) ;
		
		_free_id = true ;
		break ;
	}
	
	if ( _free_id == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас посажено максимальное количество растений." ) ;
	
	p_info [ playerid ] [ p_seed ] [ _seed_position ] -- ;

    new update_string [ 100 ], sql_string [ 144 ] ;
    for ( new i = 0 ; i < MAX_SEED_INFO ; i ++ )
    {
        if ( i == MAX_SEED_INFO - 1 ) format ( update_string, sizeof update_string, "%s%d", update_string, p_info [ playerid ] [ p_seed ] [ i ] ) ;
		else format ( update_string, sizeof update_string, "%s%d|", update_string, p_info [ playerid ] [ p_seed ] [ i ] ) ;
    }
    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_seed` = '%s' WHERE `u_id` = '%d' LIMIT 1", update_string, p_info [ playerid ] [ id ] ) ;
    mysql_tquery ( sql_connection, sql_string ) ;

    ApplyAnimation ( playerid, "BOMBER", "BOM_Plant", 4.0, 0, 0, 0, 0, 0 ) ;
	return 1 ;
}*/

/*stock save_garden ( )
{
	if ( p_info [ playerid ] [ house ] != -1 )
	{
	    new _h_id = p_info [ playerid ] [ house ] ;
	    if ( h_info [ _h_id - 1 ] [ h_garden ] == 1 )
	    {
	        new sql_string [ 100 ] ;
	        for ( new _id = 0 ; _id < MAX_SEED ; _id ++ )
		    {
		        if ( ! h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] ) continue ;

                format ( sql_string, sizeof sql_string, "UPDATE `houses_garden` SET `h_garden_time` = '%d',\
																					`h_garden_result` = '%d' WHERE `h_id` = '%d' AND `h_slot` = '%d' LIMIT 1",
				h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ], h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ],
				_h_id, _id ) ;
    			mysql_tquery ( sql_connection, sql_string ) ;
			}
	    }
	}
	return 1 ;
}*/

forward minute_timer ( ) ;
public minute_timer ( )
{
	for ( new i = 0 ; i < MAX_TRAFFIC_LIGHT ; i ++ )
	{
	    if ( tl_info [ i ] [ t_time ] > 0 ) tl_info [ i ] [ t_time ] -- ;
	    else
		{
	        if ( tl_info [ i ] [ t_status ] == 1 || tl_info [ i ] [ t_status ] == 3 )
	        {
	            tl_info [ i ] [ t_status ] = 2 ;
				tl_info [ i ] [ t_time ] = 1 ;

	            new d_string [ 64 ], _string [ 24 ] ;
		    	switch ( tl_info [ i ] [ t_status ] )
		    	{
		    	    case 1: _string = "{FF6600}Красный", tl_info [ i ] [ t_time ] = 2 ;
		    	    case 2: _string = "{FFCC00}Оранжевый", tl_info [ i ] [ t_time ] = 1 ;
		    	    case 3: _string = "{99cc00}Зелёный", tl_info [ i ] [ t_time ] = 3 ;
		    	}

		    	format ( d_string, sizeof d_string, "{FFCC00}Светофор\n\n%s", _string ) ;
				UpdateDynamic3DTextLabelText ( tl_info [ i ] [ t_text ], -1, d_string ) ;
	        }
	        else if ( tl_info [ i ] [ t_status ] == 2 )
	        {
	            tl_info [ i ] [ t_status ] = tl_info [ i ] [ t_new_status ] ;
	            if ( tl_info [ i ] [ t_status ] == 3 )
				{
			 		tl_info [ i ] [ t_time ] = 3 ;
			 		tl_info [ i ] [ t_new_status ] = 1 ;
				}
				else if ( tl_info [ i ] [ t_status ] == 1 )
				{
					tl_info [ i ] [ t_time ] = 2 ;
					tl_info [ i ] [ t_new_status ] = 3 ;
				}

	            new d_string [ 64 ], _string [ 24 ] ;
		    	switch ( tl_info [ i ] [ t_status ] )
		    	{
		    	    case 1: _string = "{FF6600}Красный", tl_info [ i ] [ t_time ] = 2 ;
		    	    case 2: _string = "{FFCC00}Оранжевый", tl_info [ i ] [ t_time ] = 1 ;
		    	    case 3: _string = "{99cc00}Зелёный", tl_info [ i ] [ t_time ] = 3 ;
		    	}

		    	format ( d_string, sizeof d_string, "{FFCC00}Светофор\n\n%s", _string ) ;
				UpdateDynamic3DTextLabelText ( tl_info [ i ] [ t_text ], -1, d_string ) ;
	        }
	    }
	}

	/*foreach(new _h_id: houses_garden)
	{
	    for ( new _id = 0 ; _id < MAX_SEED ; _id ++ )
	    {
		    if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] > 1 )
		    {
		        h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] -- ;

                new _h_garden_seed = h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] ;
                
		        new text_label [ 59 + 32 + 4 ] ;
			    format ( text_label, sizeof text_label, "{FFCC00}%s\n\n{FFFFFF}До созревания: {99cc00}%d минут(ы)", seed_info [ _h_garden_seed ] [ s_name ], h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] ) ;
				UpdateDynamic3DTextLabelText ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ], -1, text_label ) ;

				if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 120 || h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 90 ||
					h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 60 || h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 30 )
				{
				
				    if ( h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] < 4 ) h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] ++ ;

				    new _z_update = h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] * 2 ;
				    DestroyDynamicObject ( h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] ) ;
					h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = CreateDynamicObject ( seed_info [ _h_garden_seed ] [ s_object ], houses_garden_position [ _h_id ] [ _id ] [ 0 ],
																									houses_garden_position [ _h_id ] [ _id ] [ 1 ],
																									( houses_garden_position [ _h_id ] [ _id ] [ 2 ] - 12 ) + _z_update,
																									0.0, 0.0, 0.0 ,
																									0, 0 ) ;
				}
				else if ( h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] == 1 )
				{
                    h_info [ _h_id - 1 ] [ h_garden_time ] [ _id ] = 1 ;

                    format ( text_label, sizeof text_label, "{FFCC00}%s\n{FFFFFF}Растение созрело!\n\n{99cc00}Используйте ALT", seed_info [ _h_garden_seed ] [ s_name ] ) ;
					UpdateDynamic3DTextLabelText ( h_info [ _h_id - 1 ] [ h_garden_text ] [ _id ], -1, text_label ) ;

                    h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] ++ ;

                    new _h_garden_seed = h_info [ _h_id - 1 ] [ h_garden_seed ] [ _id ] ;
				    new _z_update = h_info [ _h_id - 1 ] [ h_garden_result ] [ _id ] * 2 ;
				    DestroyDynamicObject ( h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] ) ;
					h_info [ _h_id - 1 ] [ h_garden_object ] [ _id ] = CreateDynamicObject ( seed_info [ _h_garden_seed ] [ s_object ], houses_garden_position [ _h_id ] [ _id ] [ 0 ],
																									houses_garden_position [ _h_id ] [ _id ] [ 1 ],
																									( houses_garden_position [ _h_id ] [ _id ] [ 2 ] - 12 ) + _z_update,
																									0.0, 0.0, 0.0 ,
																									0, 0 ) ;
				}
		    }
		}
	}
	return 1 ;*/
}

CMD:test_poezd ( playerid )
{
	p_info [ playerid ] [ job ] = job_railway ;
	railway_time = 10 ;
	return 1 ;
}

forward second_timer ( ) ;
public second_timer ( )
{
    for ( new veh = 0; veh < MAX_VEHICLES ; veh ++ )
	{
		if ( GetVehicleModel ( veh ) == 0 ) continue ;
		if ( veh_info [ veh - 1 ] [ v_now_pos ] [ 0 ] != 0 && veh_info [ veh - 1 ] [ v_now_pos ] [ 1 ] != 0 && veh_info [ veh - 1 ] [ v_now_pos ] [ 2 ] != 0 && veh_info [ veh - 1 ] [ v_driver ] != INVALID_PLAYER_ID)
		{
			new Float:_distance = GetVehicleDistanceFromPoint ( veh, veh_info [ veh - 1 ] [ v_now_pos ] [ 0 ], veh_info [ veh - 1 ] [ v_now_pos ] [ 1 ], veh_info [ veh - 1 ] [ v_now_pos ] [ 2 ] ) ;
			if ( _distance / 1000 < 5 )	veh_info [ veh - 1 ] [ v_millage ] += _distance / 1000 ;
		}
		GetVehiclePos ( veh, veh_info [ veh - 1 ] [ v_now_pos ] [ 0 ], veh_info [ veh - 1 ] [ v_now_pos ] [ 1 ], veh_info [ veh - 1 ] [ v_now_pos ] [ 2 ] ) ;
	}
	
	new hor,m,s;
	gettime(hor,m,s);
	
	if ( hor == 0 )
	{
	    foreach(new playerid: logged_players)
	    {
	        if ( GetElapsedTime ( gettime ( ), p_info [ playerid ] [ gettime_cooldown ], CONVERT_TIME_TO_DAYS ) > 0 )
			{
			    p_info [ playerid ] [ day_money ] = 0 ;
				update_int_sql ( playerid, "u_day_money", p_info [ playerid ] [ day_money ] ) ;

				p_info [ playerid ] [ gettime_cooldown ] = gettime ( ) ;
				update_int_sql ( playerid, "u_gettime_cooldown", p_info [ playerid ] [ gettime_cooldown ] ) ;
			}
			if ( GetElapsedTime ( gettime ( ), p_info [ playerid ] [ gettime_week_cooldown ], CONVERT_TIME_TO_WEEKS ) > 0 )
			{
			    p_info [ playerid ] [ week_money ] = 0 ;
				update_int_sql ( playerid, "u_week_money", p_info [ playerid ] [ week_money ] ) ;

				p_info [ playerid ] [ gettime_week_cooldown ] = gettime ( ) ;
				update_int_sql ( playerid, "u_gettime_week_cooldown", p_info [ playerid ] [ gettime_week_cooldown ] ) ;
			}
			if ( GetElapsedTime ( gettime ( ), p_info [ playerid ] [ gettime_month_cooldown ], CONVERT_TIME_TO_MONTHS ) > 0 )
			{
			    p_info [ playerid ] [ month_money ] = 0 ;
				update_int_sql ( playerid, "u_month_money", p_info [ playerid ] [ month_money ] ) ;

				p_info [ playerid ] [ gettime_month_cooldown ] = gettime ( ) ;
				update_int_sql ( playerid, "u_gettime_month_cooldown", p_info [ playerid ] [ gettime_month_cooldown ] ) ;
			}
	    }
	}
	
	if ( hor == 4 )
	{
	    foreach(new _drop_id: gun_drops)
	    {
	        if ( gd_info [ _drop_id ] [ g_gun ] == 0 ) continue ;
	        
		    new gun_string [ 100 ], ammo_string [ 100 ] ;
	 		for ( new i = 0 ; i < 13 ; i ++ )
	   		{
	     		if ( i == 12 ) format ( gun_string, sizeof gun_string, "%s%d", gun_string, gd_info [ _drop_id ] [ g_gun ] [ i ] ) ;
				else format ( gun_string, sizeof gun_string, "%s%d|", gun_string, gd_info [ _drop_id ] [ g_gun ] [ i ] ) ;

				if ( i == 12 ) format ( ammo_string, sizeof ammo_string, "%s%d", ammo_string, gd_info [ _drop_id ] [ g_ammo ] [ i ] ) ;
				else format ( ammo_string, sizeof ammo_string, "%s%d|", ammo_string, gd_info [ _drop_id ] [ g_ammo ] [ i ] ) ;
		    }

			new sql_string [ 256 ] ;
		    format ( sql_string, sizeof ( sql_string ), "UPDATE `player_weapons` SET `g_gun` = '%s', `g_ammo` = '%s' WHERE `g_id` = '%d' LIMIT 1",
			gun_string, ammo_string, gd_info [ _drop_id ] [ g_id ] ) ;
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	
	    mysql_tquery ( sql_connection, "UPDATE `grafity` SET `g_day` = '0'" ) ;
	    mysql_tquery ( sql_connection, "UPDATE `users` SET `u_day_money` = '0', `u_marriage_today` = '0', `u_day_graffity` = '0', `u_family_every_quest` = '0|0'" ) ;// marriage
		if ( day_weeks == 1 )
		{
			mysql_tquery ( sql_connection, "UPDATE `users` SET `u_week_money` = '0'" ) ;// Taxi, обнуление дневной прибыли
			
			if ( _month_count < 4 ) _month_count ++ ;
			else
			{
			    _month_count = 0 ;
			    mysql_tquery ( sql_connection, "UPDATE `users` SET `u_month_money` = '0'" ) ; // Taxi, обнуление месячной прибыли
			}
			
			new sql_string [ 81 + 4 ] ;
			format ( sql_string, sizeof sql_string, "UPDATE `server_variables` SET `var_count` = '%d' WHERE `var_id` = '56' LIMIT 1", _month_count ) ; // Taxi, подсейв недель месяца
			mysql_tquery ( sql_connection, sql_string ) ;
		}
	}
	
	if ( railway_time > 0 )
	{
	    railway_time -- ;
	    if ( railway_time == 1 )
	    {
	        for ( new i = 0 ; i < 5 ; i ++ )
	        {
	            for ( new a = 0 ; a < 4 ; a ++ )
	        	{
	        		if ( railway_actor [ i ] [ a ] != INVALID_ACTOR_ID ) continue ;
	        		
	        		railway_actor [ i ] [ a ] = CreateActor ( random ( 300 ) + 1, railway_unity_actor [ i ] [ 0 ] + random ( 4 ) + 4,
																					railway_unity_actor [ i ] [ 1 ] + random ( 4 ) + 4,
																					railway_unity_actor [ i ] [ 2 ],
																					railway_unity_actor [ i ] [ 3 ] ) ;
				}
			}
			railway_time = 300 ;
		}
	}

	if ( start_ship > 0 )
	{
 		start_ship -- ;
 		if ( start_ship > 91 )// FSIN
 		{
 		    new scm_string [ 200 ] ;
			if ( front_ship == false )
			{
			    format ( scm_string, sizeof scm_string, "Посигнальте для переправы\n{FFCC00}Корабль отплывает через %s\n\n{828282}Если Вы планируете переправляться не один,\n{828282}то Ваши компаньоны должны сидеть в Вашей машине", convert_time ( start_ship - 90 ) ) ;
				UpdateDynamic3DTextLabelText ( ship_label [ 0 ], -1, scm_string ) ;

				format ( scm_string, sizeof scm_string, "Посигнальте для переправы\n{FFCC00}Ожидайте корабль\n\n{828282}Если Вы планируете переправляться не один,\n{828282}то Ваши компаньоны должны сидеть в Вашей машине" ) ;
				UpdateDynamic3DTextLabelText ( ship_label [ 1 ], -1, scm_string ) ;
			}
			else
			{
			    format ( scm_string, sizeof scm_string, "Посигнальте для переправы\n{FFCC00}Ожидайте корабль\n\n{828282}Если Вы планируете переправляться не один,\n{828282}то Ваши компаньоны должны сидеть в Вашей машине" ) ;
				UpdateDynamic3DTextLabelText ( ship_label [ 0 ], -1, scm_string ) ;

				format ( scm_string, sizeof scm_string, "Посигнальте для переправы\n{FFCC00}Корабль отплывает через %s\n\n{828282}Если Вы планируете переправляться не один,\n{828282}то Ваши компаньоны должны сидеть в Вашей машине", convert_time ( start_ship - 90 ) ) ;
				UpdateDynamic3DTextLabelText ( ship_label [ 1 ], -1, scm_string ) ;
			}
 		}
   		else if ( start_ship == 91 )// FSIN
	    {
	        new scm_string [ 200 ] ;
		    format ( scm_string, sizeof scm_string, "Посигнальте для переправы\n{FFCC00}Корабль в пути\n\n{828282}Если Вы планируете переправляться не один,\n{828282}то Ваши компаньоны должны сидеть в Вашей машине" ) ;
			UpdateDynamic3DTextLabelText ( ship_label [ 0 ], -1, scm_string ) ;

			format ( scm_string, sizeof scm_string, "Посигнальте для переправы\n{FFCC00}Корабль в пути\n\n{828282}Если Вы планируете переправляться не один,\n{828282}то Ваши компаньоны должны сидеть в Вашей машине" ) ;
			UpdateDynamic3DTextLabelText ( ship_label [ 1 ], -1, scm_string ) ;
			
			if ( front_ship == false )
			{
            	MoveDynamicObject ( ship_object, ship_info [ 2 ] [ s_pos ] [ 0 ], ship_info [ 2 ] [ s_pos ] [ 1 ], ship_info [ 2 ] [ s_pos ] [ 2 ], 20, ship_info [ 2 ] [ s_pos ] [ 3 ], ship_info [ 2 ] [ s_pos ] [ 4 ], ship_info [ 2 ] [ s_pos ] [ 5 ] ) ;
			}
			else
			{
			    MoveDynamicObject ( ship_object, ship_info [ 2 ] [ s_pos ] [ 0 ], ship_info [ 2 ] [ s_pos ] [ 1 ], ship_info [ 2 ] [ s_pos ] [ 2 ], 20, ship_info [ 2 ] [ s_pos ] [ 3 ], ship_info [ 2 ] [ s_pos ] [ 4 ], ship_info [ 2 ] [ s_pos ] [ 5 ] ) ;
			}
	    
			for ( new c = 0 ; c < 3 ; c ++ )
			{
   				if ( ship_player_id [ c ] == INVALID_PLAYER_ID ) continue ;
				    
			    new _player_id = ship_player_id [ c ] ;
			    if ( ! IsPlayerConnected ( _player_id ) )
			    {
			    	ship_player_id [ c ] = INVALID_PLAYER_ID ;
					continue ;
				}
    			if ( ! p_info [ _player_id ] [ ship_active ] )
				{
    				ship_player_id [ c ] = INVALID_PLAYER_ID ;
					continue ;
				}

				new _veh_id = p_info [ _player_id ] [ ship_car_id ] ;
				if ( p_info [ _player_id ] [ ship_car_id ] != INVALID_VEHICLE_ID )
				{
				    SetVehiclePos ( _veh_id, ship_vehicle_pos [ c ] [ 0 ], ship_vehicle_pos [ c ] [ 1 ], ship_vehicle_pos [ c ] [ 2 ] ) ;
				    SetVehicleZAngle ( _veh_id, ship_vehicle_pos [ c ] [ 3 ] ) ;

				    LinkVehicleToInterior ( _veh_id, 0 ) ;
					SetVehicleVirtualWorld ( _veh_id, 1000 ) ;
				}

				foreach(new i: logged_players) // streamed_players[_player_id]
				{
				    if ( _veh_id != p_info [ i ] [ ship_in_car ] ) continue ;
				    if ( _player_id == i ) continue ;
					    
				    SetPlayerInterior ( i, 0 ) ;
				    SetPlayerVirtualWorld ( i, 1000 ) ;
					    
				    PutPlayerInVehicle ( i, _veh_id, p_info [ i ] [ seat_id ] ) ;
				    
				    td_ship_player ( i, true ) ;
				}

                SetPlayerInterior ( _player_id, 0 ) ;
			    SetPlayerVirtualWorld ( _player_id, 1000 ) ;

				PutPlayerInVehicle ( _player_id, _veh_id, p_info [ _player_id ] [ seat_id ] ) ;
			    
			    td_ship_player ( _player_id, true ) ;
		    }
		}
		else if ( start_ship == 1 )
		{
		    if ( front_ship == false ) front_ship = true ;
		    else front_ship = false ;
		    
		    start_ship = 180 ; // FSIN
		    new _ship_type = front_ship ;
		    for ( new c = 0 ; c < 3 ; c ++ )
			{
			    if ( ship_player_id [ c ] == INVALID_PLAYER_ID ) continue ;

			    new _player_id = ship_player_id [ c ] ;
			    if ( ! IsPlayerConnected ( _player_id ) )
			    {
				    ship_player_id [ c ] = INVALID_PLAYER_ID ;
					continue ;
				}
			    if ( ! p_info [ _player_id ] [ ship_active ] )
				{
				    ship_player_id [ c ] = INVALID_PLAYER_ID ;
					continue ;
				}

                new _veh_id = p_info [ _player_id ] [ ship_car_id ] ;
				if ( p_info [ _player_id ] [ ship_car_id ] != INVALID_VEHICLE_ID )
				{
				    SetVehiclePos ( _veh_id, earth_vehicle_pos [ _ship_type ] [ c ] [ 0 ], earth_vehicle_pos [ _ship_type ] [ c ] [ 1 ], earth_vehicle_pos [ _ship_type ] [ c ] [ 2 ] ) ;
				    SetVehicleZAngle ( _veh_id, earth_vehicle_pos [ _ship_type ] [ c ] [ 3 ] ) ;

				    LinkVehicleToInterior ( _veh_id, 0 ) ;
					SetVehicleVirtualWorld ( _veh_id, 0 ) ;
				}

				foreach(new i: logged_players) // streamed_players[_player_id]
				{
				    if ( _veh_id != p_info [ i ] [ ship_in_car ] ) continue ;
				    if ( _player_id == i ) continue ;

                    SetPlayerInterior ( i, 0 ) ;
				    SetPlayerVirtualWorld ( i, 0 ) ;

				    PutPlayerInVehicle ( i, _veh_id, p_info [ i ] [ seat_id ] ) ;

				    clear_player_ship ( i ) ;
				    td_ship_player ( i, false ) ;
				}
				
				SetPlayerInterior ( _player_id, 0 ) ;
			    SetPlayerVirtualWorld ( _player_id, 0 ) ;

				PutPlayerInVehicle ( _player_id, _veh_id, p_info [ _player_id ] [ seat_id ] ) ;
			    
			    clear_player_ship ( _player_id ) ;
				td_ship_player ( _player_id, false ) ;
		    }
			clear_ship ( ) ;
		}
	}
	return 1 ;
}

stock clear_player_ship ( playerid )
{
    p_info [ playerid ] [ seat_id ] = -1 ;
    
    p_info [ playerid ] [ ship_active ] = false ;
    p_info [ playerid ] [ ship_car_id ] =
    p_info [ playerid ] [ ship_in_car ] = INVALID_VEHICLE_ID ;
	return 1 ;
}

CMD:test_ship ( playerid, params [ ] )
{
	if ( sscanf ( params, "d", params [ 0 ] ) ) return 1 ;
	start_ship = params [ 0 ] ;
	return 1 ;
}

stock clear_ship ( )
{
    for ( new c = 0 ; c < 3 ; c ++ )
    {
        ship_player_id [ c ] = INVALID_PLAYER_ID ;
    }
	return 1 ;
}

stock td_ship_player ( playerid, bool: status )
{
	if ( status )
	{
	    ship_time_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 286.0002, 89.6146, "Box"); // пусто
		PlayerTextDrawLetterSize(playerid, ship_time_PTD[playerid][0], 0.0000, 3.3998);
		PlayerTextDrawTextSize(playerid, ship_time_PTD[playerid][0], 354.0000, 0.0000);
		PlayerTextDrawAlignment(playerid, ship_time_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, ship_time_PTD[playerid][0], -1);
		PlayerTextDrawUseBox(playerid, ship_time_PTD[playerid][0], 1);
		PlayerTextDrawBoxColor(playerid, ship_time_PTD[playerid][0], 146);
		PlayerTextDrawBackgroundColor(playerid, ship_time_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, ship_time_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, ship_time_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, ship_time_PTD[playerid][0], 0);

		ship_time_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.6667, 95.4221, "00:00"); // пусто
		PlayerTextDrawLetterSize(playerid, ship_time_PTD[playerid][1], 0.4286, 1.9484);
		PlayerTextDrawAlignment(playerid, ship_time_PTD[playerid][1], 2);
		PlayerTextDrawColor(playerid, ship_time_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, ship_time_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, ship_time_PTD[playerid][1], 1);
		PlayerTextDrawSetProportional(playerid, ship_time_PTD[playerid][1], 1);
		PlayerTextDrawSetShadow(playerid, ship_time_PTD[playerid][1], 0);
		
		for ( new j = 0 ; j < 2 ; j ++ )
		{
			PlayerTextDrawShow ( playerid, ship_time_PTD [ playerid ] [ j ] ) ;
		}
	}
	else
	{
	    for ( new j = 0 ; j < 2 ; j ++ )
		{
			PlayerTextDrawDestroy ( playerid, ship_time_PTD [ playerid ] [ j ] ) ;
			ship_time_PTD [ playerid ] [ j ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

new Float: P [ 4 ] ;
public OnDynamicObjectMoved ( objectid )
{
	if ( ship_object != INVALID_OBJECT_ID )
	{
		GetDynamicObjectPos ( ship_object, P [ 0 ], P [ 1 ], P [ 2 ] ) ;

		if ( P [ 0 ] == ship_info [ 2 ] [ s_pos ] [ 0 ] )
		{
			P [ 3 ] = P [ 0 ] + 1.0 ;
			StopDynamicObject ( ship_object ) ;
		   	MoveDynamicObject ( ship_object, P [ 0 ] + 1.0, P [ 1 ], P [ 2 ], 0.1, 0.0, 0.0, 90.0 ) ;
		}
		
		if ( P [ 3 ] == P [ 0 ] )
		{
		    StopDynamicObject ( ship_object ) ;
			if ( front_ship == false )
			{
	           	MoveDynamicObject ( ship_object, ship_info [ 1 ] [ s_pos ] [ 0 ], ship_info [ 1 ] [ s_pos ] [ 1 ], ship_info [ 1 ] [ s_pos ] [ 2 ], 20, 0.0, 0.0, -90.0 ) ;
			}
			else
			{
			    MoveDynamicObject ( ship_object, ship_info [ 0 ] [ s_pos ] [ 0 ], ship_info [ 0 ] [ s_pos ] [ 1 ], ship_info [ 0 ] [ s_pos ] [ 2 ], 20, 0.0, 0.0, 90.0 ) ;
			}
		}
	}
	return 1 ;
}

CMD:jackcar ( playerid )
{
	if ( p_info [ playerid ] [ wanted ] > 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы находитесь в розыске." ) ;

	new Float:X, Float:Y, Float:Z ;
	new bool:check_vehicle = false ;
	foreach(new veh_id: streamed_vehicles[playerid])
	{
		if ( veh_info [ veh_id - 1 ] [ v_type ] == vehicle_type_jackcar && p_info [ playerid ] [ c_vehicle ] == veh_id )
		{
			GetVehiclePos ( veh_id, X, Y, Z ) ;
			if ( IsPlayerInRangeOfPoint ( playerid, 4.0, X, Y, Z ) )
			{
				check_vehicle = true ;
				break ;
			}
		}
	}
	if ( ! check_vehicle ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не рядом с заказаным транспортом." ) ;
	
	p_info [ playerid ] [ jacked ] = 20 ;
	ApplyAnimation ( playerid, "BD_FIRE", "wash_up", 4.1, 1, 0, 0, 0, 0, 0 ) ;
	return 1 ;
}

stock clear_player_jackcar ( playerid )
{
    p_info [ playerid ] [ c_time ] = 0 ;
    
    p_info [ playerid ] [ c_pos_toggled ] =
    p_info [ playerid ] [ c_icon ] = -1 ;
    
    p_info [ playerid ] [ c_vehicle ] = INVALID_VEHICLE_ID ;
	return 1 ;
}

public OnPlayerEnterRaceCheckpoint ( playerid )
{
    if ( is_gps_used { playerid } == 15 )
	{
	    if ( GetPlayerVehicleID ( playerid ) != p_info [ playerid ] [ c_vehicle ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Ты пригнал не тот транспорт." ) ;

        if ( IsValidVehicle ( p_info [ playerid ] [ c_vehicle ] ) && veh_info [ p_info [ playerid ] [ c_vehicle ] - 1 ] [ v_owner ] == -1 ) DestroyVehicle ( p_info [ playerid ] [ c_vehicle ] ) ;

		new scm_string [ 47 + 9 ], _payment = JACKCAR_PAYMENT ;
		format ( scm_string, sizeof scm_string, "Ты доставил нужный транспорт. Вот твои деньги: %d$.", _payment ) ;
        SendClientMessage ( playerid, 0xFF9945FF, scm_string ) ;
        
        //give_money ( playerid, _payment ) ;
        
        p_info [ playerid ] [ jackcar_skill ] ++ ;
        update_int_sql ( playerid, "u_jackcar_skill", p_info [ playerid ] [ jackcar_skill ] ) ;
        
        clear_player_jackcar ( playerid ) ;

		DisablePlayerRaceCheckpoint ( playerid ) ;
	   	is_gps_used { playerid } = 0 ;
	   	return 1 ;
	}
	else if ( is_gps_used { playerid } == 16 )
	{
	    if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;

        SetActorVirtualWorld ( p_info [ playerid ] [ taxi_actor ], 99 ) ;
        
        if ( p_info [ playerid ] [ taxi_okey_actor ] != -1 )
		{
			actor_pos_toggled [ p_info [ playerid ] [ taxi_okey_actor ] ] = false ; // taxi edit
			p_info [ playerid ] [ taxi_okey_actor ] = -1 ;
		}

		is_gps_used { playerid } = 17 ;
		
		new _random = random ( sizeof go_actor_pos ) ;
		SetPVarInt ( playerid, "go_actor_pos", _random ) ;
		SetPlayerRaceCheckpoint ( playerid, 1, go_actor_pos [ _random ] [ 0 ], go_actor_pos [ _random ] [ 1 ], go_actor_pos [ _random ] [ 2 ] - 1.4, 0.0, 0.0, 0.0, 8.0 ) ;
		SendClientMessage ( playerid, 0xFFCC00FF, !"Пассажир сел, место на навигаторе отмечено." ) ;
		
		p_t_info [ playerid ] [ pTaxiStart ] = veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_millage ] ;
	   	return 1 ;
	}
	else if ( is_gps_used { playerid } == 17 )// Taxi
	{
	    if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;

		new _random = GetPVarInt ( playerid, "go_actor_pos" ) ;
		SetActorPos ( p_info [ playerid ] [ taxi_actor ], go_actor_pos [ _random ] [ 0 ], go_actor_pos [ _random ] [ 1 ], go_actor_pos [ _random ] [ 2 ] ) ;
		SetActorFacingAngle ( p_info [ playerid ] [ taxi_actor ], go_actor_pos [ _random ] [ 3 ] ) ;
        SetActorVirtualWorld ( p_info [ playerid ] [ taxi_actor ], 0 ) ;
        
        p_info [ playerid ] [ taxi_accept_cooldown ] = 700 ;

		DisablePlayerRaceCheckpoint ( playerid ) ;
	   	is_gps_used { playerid } = 0 ;
	   	
	   	new _b_id = p_info [ playerid ] [ job ] ;
	   	new _pay = PAY_TAXI_BOTS ;
	   	new _b_money = floatround ( ( PAY_TAXI_BOTS * b_info [ _b_id - 1 ] [ b_cost ] ) / 100 ), _driver_pay = _pay - _b_money ;
	  	b_info [ _b_id - 1 ] [ b_money ] += _b_money ;
		b_info [ _b_id - 1 ] [ b_cash_today ] += _b_money ;

		p_info [ playerid ] [ day_money ] += _driver_pay ;
  		p_info [ playerid ] [ week_money ] += _driver_pay ;
    	p_info [ playerid ] [ month_money ] += _driver_pay ;
	    p_info [ playerid ] [ all_money ] += _driver_pay ;

		p_info [ playerid ] [ millage ] += veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_millage ] - p_t_info [ playerid ] [ pTaxiStart ] ;

		give_money ( playerid, _driver_pay ) ;

		new scm_string [ 89 + 4 ] ;
		format ( scm_string, sizeof scm_string, "За поездку вы заработали %d$, комиссия таксопарка %d$, чистая прибыль %d$.", _pay, _b_money, _driver_pay ) ;
		SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
	   	
	   	p_info [ playerid ] [ taxi_skill ] ++ ;
     	update_int_sql ( playerid, "u_taxi_skill", p_info [ playerid ] [ taxi_skill ] ) ;
	   	
	  	b_info [ _b_id - 1 ] [ b_taxi_licenses ] ++ ;

		if ( b_info [ _b_id - 1 ] [ b_taxi_licenses ] == 100 && b_info [ _b_id - 1 ] [ b_taxi_level ] != max_taxi_level )
  		{
    		b_info [ _b_id - 1 ] [ b_taxi_level ] ++ ;
    		b_info [ _b_id - 1 ] [ b_taxi_licenses ] = 0 ;

			new _pl_id ;
			sscanf ( b_info [ _b_id - 1 ] [ b_owner_name ], "u", _pl_id ) ;

			if ( IsPlayerConnected ( _pl_id ) )
			{
				format ( scm_string, sizeof scm_string, "У Вашего трахопарка повысился уровень! Теперь Вам доступен автопарк из %d автомобилей.", b_info [ _b_id - 1 ] [ b_taxi_level ] ) ;
				SendClientMessage ( _pl_id, 0xFFCC00FF, scm_string ) ;
			}
	    }

      	new _sql_string [ 80 + 4 + 9 ] ;
	    format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_taxi_licenses` = '%d', `b_taxi_level` = '%d' WHERE `b_id` = '%d' LIMIT 1", b_info [ _b_id - 1 ] [ b_taxi_licenses ], b_info [ _b_id - 1 ] [ b_taxi_level ], _b_id ) ;
		mysql_tquery ( sql_connection, _sql_string ) ;
	   	
		SendClientMessage ( playerid, 0xFFCC00FF, !"Вы успешно доставили пассажира." ) ;
	   	return 1 ;
	}
	else if ( is_gps_used { playerid } == 20 || is_gps_used { playerid } == 21 || is_gps_used { playerid } == 22 )
	{
		DisablePlayerRaceCheckpoint ( playerid ) ;
	   	is_gps_used { playerid } = 0 ;
	   	return 1 ;
	}
	else if ( is_gps_used { playerid } == 23 || is_gps_used { playerid } == 24 || is_gps_used { playerid } == 26 )
	{
		DisablePlayerRaceCheckpoint ( playerid ) ;
	   	is_gps_used { playerid } = 0 ;
	   	return 1 ;
	}
	else if ( is_gps_used { playerid } == 25 )
	{
	    if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;
		if ( GetPlayerVehicleID ( playerid ) != p_info [ playerid ] [ family_everyday_car ] ) return 1 ;
		
		DestroyVehicle ( p_info [ playerid ] [ family_everyday_car ] ) ;
		p_info [ playerid ] [ family_everyday_car ] = INVALID_VEHICLE_ID ;
		
		p_info [ playerid ] [ family_everyday_progress ] = 4 ;
		
		is_gps_used { playerid } = 26 ;
		SetPlayerRaceCheckpoint ( playerid, 1, 279.8808, -1587.3201, 33.0179 - 1.4, 0.0, 0.0, 0.0, 3.0 ) ;
		SendClientMessage ( playerid, 0xFFCC00FF, !"Пора вернуться к боссу и отчитаться." ) ;
	
		DisablePlayerRaceCheckpoint ( playerid ) ;
	   	is_gps_used { playerid } = 0 ;
	   	return 1 ;
	}
	else if ( is_gps_used { playerid } == 45 )
	{
	    if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;
		//if ( GetPlayerVehicleID ( playerid ) != railway_car [ playerid ] ) return 1 ;
		if ( GetVehicleSpeed ( GetPlayerVehicleID ( playerid ) ) > 20 )  return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас слишком высокая скорость." ) ;
	
        SetVehicleSpeed ( GetPlayerVehicleID ( playerid ), 0.0 ) ;

	    if ( railway_player_station { playerid } == 0 )
	    {
			p_info [ playerid ] [ salary ] += 5000 ;
	    }
	
	    if ( railway_player_station { playerid } == sizeof railway_station - 1 ) railway_player_station { playerid } = 0 ;
	    else railway_player_station { playerid } ++ ;
	    
	    new _check_id = railway_player_station { playerid } ;
	    
	    static const _str [ ] = "* Следующая станция %s. Поезд отправляется через 10 секунд!" ;
		new _text_string [ sizeof _str + 32 ] ;
		format ( _text_string, sizeof ( _text_string ), _str, railway_station [ _check_id ] [ r_name ] ) ;
		SendClientMessage ( playerid, 0xB7C956FF, _text_string ) ;

		foreach ( new pl_id:streamed_players[ playerid ])
		{
			if ( ! IsPlayerInRangeOfPoint ( pl_id, 35, p_t_info [ playerid ][ p_pos ] [ 0 ], p_t_info [ playerid ][ p_pos ] [ 1 ], p_t_info [ playerid ][ p_pos ] [ 2 ] ) )continue ;
			SendClientMessage ( pl_id, 0xB7C956FF, _text_string ) ;
		}
		SetTimerEx ( "railway_stop", 10000, false, "i", playerid ) ;
		TogglePlayerControllable ( playerid, false ) ;
	}
	return 1 ;
}

forward railway_stop ( playerid ) ;
public railway_stop ( playerid )
{
    is_gps_used { playerid } = 45 ;
    new _check_id = railway_player_station { playerid } ;
	SetPlayerRaceCheckpoint ( playerid, 1, railway_station [ _check_id ] [ r_pos ] [ 0 ], railway_station [ _check_id ] [ r_pos ] [ 1 ], railway_station [ _check_id ] [ r_pos ] [ 2 ] - 1.4, 0.0, 0.0, 0.0, 8.0 ) ;
    TogglePlayerControllable ( playerid, true ) ;
    
    new _actor_count = 0 ;
    for ( new a = 0 ; a < 4 ; a ++ )
   	{
		if ( railway_actor [ _check_id ] [ a ] == INVALID_ACTOR_ID ) continue ;
	   		
	   	DestroyActor ( railway_actor [ _check_id ] [ a ] ) ;
	   	railway_actor [ _check_id ] [ a ] = INVALID_ACTOR_ID ;
	   	_actor_count ++ ;
	}
	if ( _actor_count )
	{
	    static const _str [ ] = "* Село %d пассажиров. Отправляйтесь на следующую станцию." ;
		new _text_string [ sizeof _str + 4 ] ;
		format ( _text_string, sizeof ( _text_string ), _str, _actor_count ) ;
		SendClientMessage ( playerid, 0xB7C956FF, _text_string ) ;
	}
	return 1 ;
}

stock SetVehicleSpeed ( vehicleid, Float:speed )
{
    new Float:_v_velocity [ 4 ] ;
    GetVehicleZAngle ( vehicleid, _v_velocity [ 0 ] ) ;
    GetVehicleVelocity ( vehicleid, _v_velocity [ 1 ], _v_velocity [ 2 ], _v_velocity [ 3 ] ) ;
    SetVehicleVelocity ( vehicleid, floatsin ( -_v_velocity [ 0 ], degrees ) * ( speed / 99 ), floatcos ( -_v_velocity [ 0 ], degrees ) * ( speed / 99 ), _v_velocity [ 3 ] ) ;
    return true ;
}

stock GetVehicleSpeed ( vehicleid )
{
    new Float:X, Float:Y, Float:Z, Float:_speed ;
    GetVehicleVelocity ( vehicleid, X, Y, Z ) ;
    _speed = ( ( floatsqroot ( ( X * X ) + ( Y * Y ) ) * 10 ) / 1.65 ) * 30 ;
    return floatround ( _speed, floatround_round ) ;
}

public OnVehicleStreamIn(vehicleid, forplayerid)
{
	Iter_Add(streamed_vehicles[forplayerid], vehicleid ) ;
	return 1 ;
}

public OnVehicleStreamOut(vehicleid, forplayerid)
{
	Iter_Remove(streamed_vehicles[forplayerid], vehicleid ) ;
	return 1 ;
}

stock suspect_player ( playerid, reason_suspect [ ], wanted_point )
{
	new scm_string [ 144 ] ;
	if ( p_info [ playerid ] [ wanted ] + wanted_point < 6 ) p_info [ playerid ] [ wanted ] += wanted_point ;
	else p_info [ playerid ] [ wanted ] = 6 ;
	SetPlayerWantedLevel( playerid, p_info [ playerid ] [ wanted ] ) ;

	format ( scm_string, sizeof ( scm_string ), "Вы были объявлены в розыск! Обвинитель Неизвестный. Причина: %s", reason_suspect ) ;
	SendClientMessage ( playerid, 0xAA3333FF, scm_string ) ;
	format ( scm_string, sizeof ( scm_string ), "Ваш текущий уровень розыска: %d", p_info [ playerid ] [ wanted ] ) ;
	SendClientMessage ( playerid, 0xAA3333FF, scm_string ) ;
	/*format ( scm_string, sizeof ( scm_string ), "%s был(а) объявлен(a) в розыск! Обвинитель: Неизвестный | Причина: %s | Уровень розыска: %d",
	p_info [ playerid ] [ name ], reason_suspect, p_info [ playerid ] [ wanted ] ) ;

	foreach(new i: logged_players) if ( cop_player ( i ) || fbi_player ( i ) || army_player ( i ) ) SendClientMessage ( i, 0xFFCC00FF, scm_string ) ;

	update_int_sql ( playerid, "u_wanted", p_info [ playerid ] [ wanted ] ) ;*/
	return true ;
}

public OnVehicleSpawn ( vehicleid )
{
	if ( veh_info [ vehicleid - 1 ] [ v_player_jack ] != INVALID_PLAYER_ID )
	{
	    new playerid = veh_info [ vehicleid - 1 ] [ v_player_jack ] ;
	    if ( p_info [ playerid ] [ c_time ] )
		{
		    if ( IsValidVehicle ( p_info [ playerid ] [ c_vehicle ] ) && veh_info [ p_info [ playerid ] [ c_vehicle ] - 1 ] [ v_owner ] == -1 ) DestroyVehicle ( p_info [ playerid ] [ c_vehicle ] ) ;
			if ( p_info [ playerid ] [ c_icon ] != -1 ) RemovePlayerMapIcon ( playerid, p_info [ playerid ] [ c_icon ] ) ;
			SendClientMessage ( playerid, 0xFF6600FF, !"Задание по автоугону провалено!" ) ;
			clear_player_jackcar ( playerid ) ;
		}
	}
	
	if ( veh_info [ vehicleid - 1 ] [ v_player_driver ] != INVALID_PLAYER_ID )
    {
        new driver_id = veh_info [ vehicleid - 1 ] [ v_player_driver ] ;

        if ( p_info [ driver_id ] [ taxi_accept_cooldown ] > 0 )
	    {
			DestroyActor ( p_info [ driver_id ] [ taxi_actor ] ) ;
			p_info [ driver_id ] [ taxi_cooldown ] = 300 ;
			veh_info [ vehicleid - 1 ] [ v_player_driver ] = INVALID_PLAYER_ID ;
			p_info [ driver_id ] [ taxi_okey ] = false ;
	  	}
	  	if ( p_info [ driver_id ] [ taxi_okey_actor ] != -1 )
		{
			actor_pos_toggled [ p_info [ driver_id ] [ taxi_okey_actor ] ] = false ; // taxi edit
			p_info [ driver_id ] [ taxi_okey_actor ] = -1 ;
		}
    }
    //go_bus_vehicle_spawn ( vehicleid ) ;
	return true ;
}

public OnVehicleDeath ( vehicleid, killerid )
{
    if ( veh_info [ vehicleid - 1 ] [ v_player_driver ] != INVALID_PLAYER_ID )
    {
        new driver_id = veh_info [ vehicleid - 1 ] [ v_player_driver ] ;

        if ( p_info [ driver_id ] [ taxi_accept_cooldown ] > 0 )
	    {
			DestroyActor ( p_info [ driver_id ] [ taxi_actor ] ) ;
			p_info [ driver_id ] [ taxi_cooldown ] = 300 ;
			veh_info [ vehicleid - 1 ] [ v_player_driver ] = INVALID_PLAYER_ID ;
			p_info [ driver_id ] [ taxi_okey ] = false ;
	  	}
	  	if ( p_info [ driver_id ] [ taxi_okey_actor ] != -1 )
		{
			actor_pos_toggled [ p_info [ driver_id ] [ taxi_okey_actor ] ] = false ; // taxi edit
			p_info [ driver_id ] [ taxi_okey_actor ] = -1 ;
		}
    }
	return 1 ;
}

/*new player_cuff [ MAX_PLAYERS ],
	player_tie [ MAX_PLAYERS ],
	target_cuff [ MAX_PLAYERS ],
	target_tie [ MAX_PLAYERS ] ;

stock clear_stoped_params ( playerid, targetid )
{
    player_cuff [ playerid ] =
	player_tie [ playerid ] =
	target_cuff [ targetid ] =
	target_tie [ targetid ] = INVALID_PLAYER_ID ;
	return 1 ;
}

new gotome_player [ MAX_PLAYERS ] = { -1, ... },
	police_gotome [ MAX_PLAYERS ] = { -1, ... },
	Float: cuff_x [ MAX_PLAYERS ], Float: cuff_y [ MAX_PLAYERS ], Float: cuff_z [ MAX_PLAYERS ] ;

CMD:gotome ( playerid, params [ ] )
{
	//if ( ! cop_player ( playerid ) && ! fbi_player ( playerid ) && ! p_info [ playerid ] [ member ] != 9 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Команда доступна только для криминальных и гос. организаций." ) ;
	if ( target_cuff [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы в наручниках." ) ;
	if ( target_tie [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы связаны." ) ;
	if ( police_gotome [ playerid ] != -1 )
	{
		new pl_id = police_gotome [ playerid ] - 1 ;

        police_gotome [ playerid ] =
		gotome_player [ pl_id ] = -1 ;

	    ClearAnimations ( pl_id, true ) ;
		new scm_string [ 19 + MAX_PLAYER_NAME ] ;
		format ( scm_string, sizeof ( scm_string ), "Вы отпустили %s.", p_info [ pl_id ] [ name ] ) ;
		SendClientMessage ( playerid, -1, scm_string ) ;

		cuff_x [ pl_id ] = cuff_y [ pl_id ] = cuff_z [ pl_id ] = 0.0 ;
		return 1 ;
	}

	if ( sscanf ( params, "u", params [ 0 ] ) )return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /gotome [ид/имя]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок не найден." ) ;
	if ( params [ 0 ] == playerid ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не можете потащить самого себя." ) ;

    if ( p_info [ playerid ] [ member ] == 9 && 4 > p_info [ playerid ] [ jail ] > 0 )
    {
		if ( p_info [ params [ 0 ] ] [ jail ] == jail_id_tcp ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок находится в тюрьме." ) ;
	}
	else
	{
	    if ( p_info [ params [ 0 ] ] [ jailed ] > 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок находится в тюрьме." ) ;
		if ( target_cuff [ params [ 0 ] ] == INVALID_PLAYER_ID && target_tie [ params [ 0 ] ] == INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок должен быть в наручниках или связан." ) ;
	}
	if ( IsPlayerInAnyVehicle ( playerid ) || IsPlayerInAnyVehicle ( params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы или Ваша цель находитесь в транспорте." ) ;
    if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( params [ 0 ] ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок слишком далеко." ) ;

    police_gotome [ playerid ] = params [ 0 ] + 1 ;
    gotome_player [ params [ 0 ] ] = playerid ;

	if ( p_info [ playerid ] [ member ] == 9 && 4 > p_info [ playerid ] [ jail ] > 0 )
	{
	    new scm_string [ 66 + MAX_PLAYER_NAME ] ;
		format ( scm_string, sizeof ( scm_string ), "Вы повели %s за собой. Переправьте его в тюрьму особого режима.", p_info [ params [ 0 ] ] [ name ] ) ;
		SendClientMessage ( playerid, -1, scm_string ) ;
		
		set_pos ( params [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 0 ] + 0.5, p_t_info [ playerid ] [ p_pos ] [ 1 ] + 0.5, p_t_info [ playerid ] [ p_pos ] [ 2 ], 0.0, GetPlayerInterior ( playerid ), GetPlayerVirtualWorld ( playerid ) ) ;
		
		p_info [ params [ 0 ] ] [ jail ] = jail_id_tcp ;
		update_int_sql ( playerid, "u_jail", p_info [ params [ 0 ] ] [ jail ] ) ;
	}
	else
	{
	    new scm_string [ 25 + MAX_PLAYER_NAME ] ;
		format ( scm_string, sizeof ( scm_string ), "Вы повели %s за собой.", p_info [ params [ 0 ] ] [ name ] ) ;
		SendClientMessage ( playerid, -1, scm_string ) ;
	}
    return 1 ;
}*/

stock set_pos ( playerid, Float:x, Float:y, Float:z, Float:angle, interior, world )
{
	SetPlayerVirtualWorld ( playerid, world ) ;
	SetPlayerInterior ( playerid, interior ) ;
    SetPlayerPos ( playerid, x, y, z ) ;
	SetPlayerFacingAngle ( playerid, angle ) ;
	return 1 ;
}

stock td_fare_show ( playerid, bool: status )
{
	if ( status )
	{
	    fare_time_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 286.0002, 89.6146, "Box"); // пусто
		PlayerTextDrawLetterSize(playerid, fare_time_PTD[playerid][0], 0.0000, 3.3998);
		PlayerTextDrawTextSize(playerid, fare_time_PTD[playerid][0], 354.0000, 0.0000);
		PlayerTextDrawAlignment(playerid, fare_time_PTD[playerid][0], 1);
		PlayerTextDrawColor(playerid, fare_time_PTD[playerid][0], -1);
		PlayerTextDrawUseBox(playerid, fare_time_PTD[playerid][0], 1);
		PlayerTextDrawBoxColor(playerid, fare_time_PTD[playerid][0], 146);
		PlayerTextDrawBackgroundColor(playerid, fare_time_PTD[playerid][0], 255);
		PlayerTextDrawFont(playerid, fare_time_PTD[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, fare_time_PTD[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, fare_time_PTD[playerid][0], 0);

		fare_time_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 320.6667, 95.4221, "00:00"); // пусто
		PlayerTextDrawLetterSize(playerid, fare_time_PTD[playerid][1], 0.4286, 1.9484);
		PlayerTextDrawAlignment(playerid, fare_time_PTD[playerid][1], 2);
		PlayerTextDrawColor(playerid, fare_time_PTD[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, fare_time_PTD[playerid][1], 255);
		PlayerTextDrawFont(playerid, fare_time_PTD[playerid][1], 1);
		PlayerTextDrawSetProportional(playerid, fare_time_PTD[playerid][1], 1);
		PlayerTextDrawSetShadow(playerid, fare_time_PTD[playerid][1], 0);

		for ( new j = 0 ; j < 2 ; j ++ )
		{
			PlayerTextDrawShow ( playerid, fare_time_PTD [ playerid ] [ j ] ) ;
		}
	}
	else
	{
	    for ( new j = 0 ; j < 2 ; j ++ )
		{
			PlayerTextDrawDestroy ( playerid, fare_time_PTD [ playerid ] [ j ] ) ;
			fare_time_PTD [ playerid ] [ j ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

public OnPlayerClickMap ( playerid, Float:fX, Float:fY, Float:fZ )
{
    if ( GetPVarInt ( playerid, "map_mark" ) )
	{
		new get_taxidriver = veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_driver ] ;
		SetPlayerRaceCheckpoint ( get_taxidriver, 1, fX, fY, fZ, 0.0, 0.0, 0.0, 2.0 ) ;
		is_gps_used { get_taxidriver } = 1 ;

		new scm_string [ 128 ] ;
		format ( scm_string, sizeof scm_string, "{14A3FF}* {FFFFFF}%s установил метку на карте, чтобы снять введите {828282}'/gps'{FFFFFF}.", p_info [ playerid ] [ name ] ) ;
		SendClientMessage ( playerid, -1, scm_string ) ;
		SendClientMessage ( playerid, -1, "Вы установили метку таксисту." ) ;

		DeletePVar ( playerid, "map_mark" ) ;
		return 1 ;
	}

	if ( player_station_area [ playerid ] )
	{
	    new _player_station = -1, _go_station = -1, Float: _near_station [ 3 ] ;
	    _near_station [ 0 ] = fX, _near_station [ 1 ] = fY, _near_station [ 2 ] = fZ ;

	    for ( new i = 0 ; i < sizeof station_position ; i ++ )
	    {
	        if ( IsPlayerInRangeOfPoint ( playerid, 5.0, station_position [ i ] [ 0 ], station_position [ i ] [ 1 ], station_position [ i ] [ 2 ] ) )
	        {
	        	_player_station = i ;
	        	_go_station = i ;
	        	break ;
			}
		}

		for ( new i = 0 ; i < sizeof station_position ; i ++ )
	    {
			new Float: _start_distance = get_distance_point_to_point ( _near_station [ 0 ], _near_station [ 1 ], _near_station [ 2 ], station_position [ _go_station ] [ 0 ], station_position [ _go_station ] [ 1 ], station_position [ _go_station ] [ 2 ] ) ;
			new Float: _distance = get_distance_point_to_point ( _near_station [ 0 ], _near_station [ 1 ], _near_station [ 2 ], station_position [ i ] [ 0 ], station_position [ i ] [ 1 ], station_position [ i ] [ 2 ] ) ;
			if ( _distance < _start_distance )
			{
				_go_station = i ;
				
				player_fare [ playerid ] = floatround ( _distance * 0.8 ) ;
				p_info [ playerid ] [ station_id ] = i ;
			}
	    }
	    if ( p_info [ playerid ] [ station_id ] == _player_station ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже на самой ближайшей остановке!" ) ;

		new dialog_string [ 98 + 9 ] ;
		format ( dialog_string, sizeof dialog_string, "{FFFFFF}Стоимость проезда составит {99cc00}%d${FFFFFF}.\n\n{828282}Вы согласны ожидать автобус?", player_fare [ playerid ] ) ;
	    show_dialog ( playerid, d_bus_station, DIALOG_STYLE_MSGBOX, "{FFCC00}Автобус", dialog_string, "Да", "Нет" ) ;

	}
	return 1 ;
}

/*new Float: bus_jail_position [ 4 ] = { 0.0, 0.0, 0.0 } ;
new Float: unjail_position [ 3 ] = { 0.0, 0.0, 0.0 } ;
new Float: jail_position [ 7 ] [ 3 ] =
{
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 },
	{ 0.0, 0.0, 0.0 }
} ;

CMD:go_bus ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ member ] != 9 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не сотрудник тюрьмы!" ) ;
    if ( GetVehicleModel ( GetPlayerVehicleID ( playerid ) ) != 431 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не в автобусе!" ) ;
    
    new _jail_id, bool: _jail_on = false ;
    for ( new i = 0 ; i < 7 ; i ++ )
    {
        if ( ! IsPlayerInRangeOfPoint ( playerid, 10.0, jail_position [ i ] [ 0 ], jail_position [ i ] [ 1 ], jail_position [ i ] [ 2 ] ) ) continue ;
        
        _jail_on = true ;
        _jail_id = i + 1 ;
    }

	if ( _jail_on == false ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не рядом с местом загрузки заключенных!" ) ;

	if ( sscanf ( params, "u", params [ 0 ] ) )
	{
		SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /go_bus [ид]" ) ;
		SendClientMessage ( playerid, 0xFF6600FF, !"Если Вы укажите ID, то в автобус посадит только одного заключенного." ) ;
		SendClientMessage ( playerid, 0xFF6600FF, !"Если Вы укажите {AA3333}-1{828282}, то в автобус сядут все, находящиеся в тюрьме." ) ;
		return 1 ;
	}
	
	new vehicle_id = GetPlayerVehicleID ( playerid ) ;
	if ( params [ 0 ] == -1 ) // FSIN
	{
	    new _c_jailman = 0 ;
	    foreach(new i: logged_players)
		{
			if ( _c_jailman >= 6 ) break ;
			if ( p_info [ i ] [ jail ] != _jail_id ) continue ;
			set_pos ( i, bus_jail_position [ 0 ], bus_jail_position [ 1 ], bus_jail_position [ 2 ], bus_jail_position [ 3 ], 0, veh_info [ vehicle_id - 1 ] [ v_vehicle ] ) ; // playerid - для того, чтоб все зэки ехали в одном вирт. мире, и чтоб если несколько бусов, то они не пересекались
				
			p_info [ i ] [ jail ] = 99 ;
			update_int_sql ( i, "u_jail", p_info [ i ] [ jail ] ) ;
				
			SendClientMessage ( i, 0xFF9945FF, "Вас конвоируют в тюрьму строго режима!" ) ;
			_c_jailman ++ ;
		}
		if ( _c_jailman ) SendClientMessage ( playerid, 0xFF9945FF, "Вы начали перевозку заключённых!" ) ;
		else SendClientMessage ( playerid, 0xFF6600FF, !"В тюрьме нет заключённых!" ) ;
	}
	else
	{
		if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Такого игрока нет!" ) ;
		if ( ! p_info [ params [ 0 ] ] [ jail ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок не находится в тюрьме!" ) ;
		if ( p_info [ params [ 0 ] ] [ jail ] != _jail_id )
		         return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок находится в другой тюрьме!" ) ;
		         
        set_pos ( params [ 0 ], bus_jail_position [ 0 ], bus_jail_position [ 1 ], bus_jail_position [ 2 ], bus_jail_position [ 3 ], 0, veh_info [ vehicle_id - 1 ] [ v_vehicle ] ) ;
        
        p_info [ params [ 0 ] ] [ jail ] = 99 ;
		update_int_sql ( params [ 0 ], "u_jail", p_info [ params [ 0 ] ] [ jail ] ) ;

		SendClientMessage ( params [ 0 ], 0xFF9945FF, "Вас конвоируют в тюрьму строго режима!" ) ;

		new scm_string [ 26 + MAX_PLAYER_NAME ] ;
		format ( scm_string, sizeof scm_string, "Вы начали перевозку %s!", p_info [ params [ 0 ] ] [ name ] ) ;
		SendClientMessage ( playerid, 0xFF9945FF, scm_string ) ;
	}
	return 1 ;
}

CMD:un_bus ( playerid )
{
    if ( p_info [ playerid ] [ member ] != 9 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не сотрудник тюрьмы!" ) ;
    if ( GetVehicleModel ( GetPlayerVehicleID ( playerid ) ) != 431 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не в автобусе!" ) ;
    if ( ! IsPlayerInRangeOfPoint ( playerid, 10.0, unjail_position [ 0 ], unjail_position [ 1 ], unjail_position [ 2 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не рядом с местом разгрузки заключённых!" ) ;
    
	new bool: _jail_count = 0 ;
	new vehicle_id = GetPlayerVehicleID ( playerid ) ;
    foreach(new i: logged_players)
	{
	    if ( IsPlayerInRangeOfPoint ( i, 20.0, bus_jail_position [ 0 ], bus_jail_position [ 1 ], bus_jail_position [ 2 ] ) && GetPlayerVirtualWorld ( i ) == veh_info [ vehicle_id - 1 ] [ v_vehicle ] )
	    {
	        SpawnPlayer ( i ) ;
	        SendClientMessage ( i, 0xFF9945FF, "Вас доставили в тюрьму! Оставшийся срок Вы будете досиживать тут." ) ;
	        _jail_count ++ ;
	    }
	}
	if ( ! _jail_count ) SendClientMessage ( playerid, 0xFF6600FF, !"В автобусе нет заключённых!" ) ;
	else 
	{
		give_money ( playerid, _jail_count * 500 ) ;
		insert_money_log ( playerid, INVALID_PLAYER_ID, _jail_count * 500, "автозак" ) ;
		SendClientMessage ( playerid, 0xFF9945FF, "Вы успешно доставили заключённых в тюрьму." ) ;
	}
	return 1 ;
}

stock go_bus_mode_init ( )
{
	for ( new i = 0 ; i < 7 ; i ++ )
	{
    	CreateDynamic3DTextLabel ( "Для погрузки заключённых используйте {FFCC00}/go_bus", -1, jail_position [ i ] [ 0 ], jail_position [ i ] [ 1 ], jail_position [ i ] [ 2 ] + 1.3, 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
	}
	return 1 ;
}

stock go_bus_vehicle_spawn ( vehicle_id )
{
	if ( GetVehicleModel ( vehicle_id ) == 431 && veh_info [ vehicle_id - 1 ] [ v_owner ] == 9 )
	{
	    foreach(new i: logged_players)
		{
		    if ( IsPlayerInRangeOfPoint ( i, 20.0, bus_jail_position [ 0 ], bus_jail_position [ 1 ], bus_jail_position [ 2 ] ) && GetPlayerVirtualWorld ( i ) == veh_info [ vehicle_id - 1 ] [ v_vehicle ] )
		    {
		        SpawnPlayer ( i ) ;
		        SendClientMessage ( i, 0xFF9945FF, "Автобус был уничтожен! Вы были доставлены в тюрьму автоматически." ) ;
		    }
		}
	}
	return 1 ;
}*/

stock mapping_OnGameModeInit ( )
{
    texture_object = CreateObject(3078, 1523.568725, 834.275756, 832.293090, 0.000000, 0.000000, 0.000000);
	SetObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	
    texture_object = CreateDynamicObjectEx(14877, 1519.553100, 834.892150, 830.172241, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0x00000000);
	texture_object = CreateDynamicObjectEx(18981, 1519.743286, 830.786376, 831.302307, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18880, "speedcamera1", "metallamppost4", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(18766, 1521.527343, 831.440612, 831.777709, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19357, 1522.640258, 833.984252, 830.817321, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1525.830078, 833.984252, 830.817321, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1521.119384, 835.494384, 830.816345, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1519.269653, 835.494384, 830.817321, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1517.740844, 833.984252, 830.817321, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1525.830078, 832.453979, 830.816345, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1526.057373, 836.400634, 832.067993, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1514.356689, 836.400634, 832.067993, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1528.247070, 831.510803, 832.068969, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1522.640258, 832.084533, 830.817321, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1525.829589, 832.084533, 830.817321, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1526.057373, 829.650878, 832.067993, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1516.077880, 829.650878, 832.067993, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1519.430175, 832.084533, 830.817321, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1516.240356, 832.084533, 830.817321, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1521.684814, 834.349548, 832.897338, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1522.765014, 834.349548, 832.897338, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1523.905517, 834.349548, 832.897338, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1525.054931, 834.349548, 832.897338, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1526.140258, 832.883911, 830.956420, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1528.588256, 833.400573, 832.208007, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1526.454956, 833.029479, 833.017395, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1526.454956, 833.959533, 833.017395, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1526.454956, 832.109558, 833.017395, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1521.684814, 831.649414, 832.897338, 0.000000, -0.000022, 179.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1522.765014, 831.649414, 832.897338, 0.000000, -0.000022, 179.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1523.905517, 831.649414, 832.897338, 0.000000, -0.000022, 179.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1525.054931, 831.649414, 832.897338, 0.000000, -0.000022, 179.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1521.684814, 830.909179, 832.897338, 0.000000, -0.000029, 179.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1522.765014, 830.909179, 832.897338, 0.000000, -0.000029, 179.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1523.905517, 830.909179, 832.897338, 0.000000, -0.000029, 179.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1525.054931, 830.909179, 832.897338, 0.000000, -0.000029, 179.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1518.654663, 834.349548, 832.897338, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(18981, 1519.743286, 831.446533, 835.692565, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16093, "a51_ext", "ws_whitewall2_top", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(2343, 1520.694458, 831.649414, 832.897338, 0.000000, -0.000029, 179.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1520.694458, 830.909179, 832.897338, 0.000000, -0.000037, 179.999771, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1519.704589, 831.649414, 832.897338, 0.000000, -0.000037, 179.999771, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1519.704589, 830.909179, 832.897338, 0.000000, -0.000045, 179.999725, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1518.864135, 831.649414, 832.897338, 0.000000, -0.000045, 179.999725, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1518.864135, 830.909179, 832.897338, 0.000000, -0.000052, 179.999679, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1517.443603, 831.649414, 832.897338, 0.000000, -0.000045, -0.000304, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1517.443603, 830.909179, 832.897338, 0.000000, -0.000052, -0.000365, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1522.639770, 834.914062, 831.256652, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1525.839965, 834.914062, 831.256652, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1525.839965, 830.433837, 831.256652, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1522.649658, 830.433837, 831.256652, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1519.449829, 830.433837, 831.256652, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1516.259765, 830.433837, 831.256652, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1517.749511, 834.914062, 831.256652, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1521.125122, 834.846435, 834.027832, 90.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1519.264404, 835.586669, 834.027832, 90.000000, 0.000000, 720.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1518.613769, 834.926818, 834.027832, 90.000000, 0.000000, 810.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1521.033935, 834.926818, 834.027832, 90.000000, 0.000000, 810.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1522.888183, 834.878784, 832.885375, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1521.657958, 834.878784, 834.084960, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1525.678833, 834.908813, 834.084960, 180.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1524.487792, 834.878784, 832.886352, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1524.838500, 834.908813, 834.084960, 180.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1522.678344, 834.908813, 834.084960, 180.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1523.659057, 834.908813, 834.685241, 270.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1522.888183, 834.878784, 835.255676, 270.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1524.500122, 834.878784, 835.255676, 270.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1523.909545, 835.034606, 834.527648, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 8409, "gnhotel1", "gnhotelwindow01_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1526.365722, 834.926391, 834.027832, 90.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1527.116210, 834.926391, 834.027832, 90.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1527.058227, 832.998535, 832.886352, 90.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1527.069946, 833.394226, 831.256103, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1527.069946, 830.214599, 831.256103, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1527.086181, 834.846618, 834.027832, 90.000000, 0.000000, 720.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1526.454956, 831.169250, 833.017395, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1527.058227, 834.028442, 834.096008, 180.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1527.086181, 831.886962, 834.027832, 90.000000, 0.000000, 720.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1527.086181, 831.137329, 834.027832, 90.000000, 0.000000, 720.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1527.058227, 831.828491, 834.096008, 180.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1527.058227, 832.998535, 835.076538, 90.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1527.119506, 833.674560, 833.957641, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 8409, "gnhotel1", "gnhotelwindow01_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1527.058227, 832.998535, 834.866455, 90.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1527.058227, 832.998535, 834.646301, 90.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1526.365722, 830.416259, 834.027832, 90.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1527.115844, 830.416259, 834.027832, 90.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1524.448730, 830.494567, 832.885375, 89.999992, 314.999969, -45.000057, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1525.678955, 830.494567, 834.084960, 0.000007, 179.999984, 89.999916, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1521.657958, 830.464538, 834.084960, -0.000007, -179.999984, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1522.849121, 830.494567, 832.886352, 89.999992, 314.999969, -45.000057, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1522.498291, 830.464538, 834.084960, -0.000007, -179.999984, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1524.658447, 830.464538, 834.084960, -0.000007, -179.999984, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1523.677734, 830.464538, 834.685241, -89.999992, -314.999969, 135.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1524.448730, 830.494567, 835.255676, -89.999992, 205.528778, 115.528732, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1522.836669, 830.494567, 835.255676, -89.999992, 205.528778, 115.528732, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1523.427246, 830.338806, 834.527648, 0.000007, 0.000000, 179.999877, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 8409, "gnhotel1", "gnhotelwindow01_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1521.735717, 830.416259, 834.027832, 90.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1519.818603, 830.494567, 832.885375, 89.999992, 334.471160, -64.471252, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1521.048828, 830.494567, 834.084960, 0.000014, 179.999984, 89.999893, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1517.027832, 830.464538, 834.084960, -0.000014, -179.999984, -89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1518.218994, 830.494567, 832.886352, 89.999992, 334.471160, -64.471252, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1517.868164, 830.464538, 834.084960, -0.000014, -179.999984, -89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1520.028320, 830.464538, 834.084960, -0.000014, -179.999984, -89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1519.047607, 830.464538, 834.685241, -89.999992, -334.471191, 115.528778, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1519.818603, 830.494567, 835.255676, -89.999992, 193.368515, 103.368446, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1518.206542, 830.494567, 835.255676, -89.999992, 193.368515, 103.368446, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1518.797119, 830.338806, 834.527648, 0.000007, -0.000007, 179.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 8409, "gnhotel1", "gnhotelwindow01_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1517.085693, 830.416259, 834.027832, 90.000000, 0.000000, 630.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1521.098022, 835.078979, 832.904663, 180.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1521.098022, 835.078979, 833.625183, 180.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1519.486816, 835.078979, 832.904663, 0.000000, -179.999984, 90.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1519.486816, 835.078979, 833.625183, 0.000000, -179.999984, 90.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1520.347290, 835.078979, 832.414550, 90.000000, -179.999984, 90.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1520.347290, 835.078979, 831.744445, 90.000000, -179.999984, 90.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1520.347290, 835.078979, 832.074768, 90.000000, -179.999984, 90.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1520.277343, 835.078979, 832.904663, 0.000007, -179.999984, 89.999984, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1520.277343, 835.078979, 833.625183, 0.000007, -179.999984, 89.999984, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1520.347290, 835.078979, 834.614746, 90.000000, -179.999984, 450.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1520.139160, 835.164794, 833.707397, 0.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 8409, "gnhotel1", "gnhotelwindow01_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1516.744384, 834.926818, 834.027832, 90.000000, 0.000000, 990.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1518.487670, 834.878784, 834.084960, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(2343, 1516.934082, 834.349548, 832.897338, 0.000000, 0.000000, 720.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.667724, 834.878784, 834.084960, 180.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1517.847656, 834.879760, 833.124877, 270.000000, 180.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1517.497558, 834.879760, 835.255676, 270.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1515.990356, 835.034606, 834.527648, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 8409, "gnhotel1", "gnhotelwindow01_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1516.057983, 834.211669, 834.027832, 90.000000, -0.499998, -164.999969, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1516.242797, 833.495300, 834.027832, 90.000000, -0.499998, -164.999969, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1516.686157, 831.776977, 834.027832, 90.000000, 0.000000, 720.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1516.699951, 831.733459, 834.027832, 90.000000, -0.499998, -164.999969, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1511.507080, 831.440612, 831.777709, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(1897, 1516.227172, 833.559143, 833.404663, -0.000018, -179.999984, -165.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.227172, 833.559143, 834.115173, -0.000018, -179.999984, -165.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.522583, 832.374633, 834.115173, -0.000011, -179.999984, 14.000068, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.522583, 832.374633, 833.405029, -0.000011, -179.999984, 14.000069, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.266235, 833.527160, 832.224975, 89.999992, -94.355041, -71.644866, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.396606, 832.879516, 834.115173, -0.000011, -179.999984, 14.000069, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.396606, 832.879516, 833.405029, -0.000011, -179.999984, 14.000069, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.265869, 833.526977, 832.925292, 89.999992, -94.355041, -71.644866, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.261108, 833.546447, 832.415222, 89.999992, -94.355041, -71.644866, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(1897, 1516.268676, 833.517578, 835.125061, 89.999992, -94.355041, -71.644866, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18996, "mattextures", "sampblack", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1516.686157, 831.036926, 834.027832, 90.000000, 0.000000, 720.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1519.298461, 833.966552, 835.538024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1519.298461, 833.966552, 835.178100, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1521.158935, 833.966552, 835.178100, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1519.298461, 833.966552, 834.917846, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1524.817993, 833.966552, 835.178100, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1525.608520, 833.966552, 835.178100, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1525.618652, 833.966552, 835.178100, 89.999992, 89.999992, -89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1525.618530, 833.966552, 834.918884, 89.999992, 89.999992, -89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1525.610961, 832.076171, 835.538024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1517.500488, 832.076171, 835.538024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1522.661010, 832.076171, 835.538024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1525.618652, 832.076965, 835.178100, 89.999992, 134.999984, -45.000003, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1525.618652, 832.076843, 834.918884, 89.999992, 134.999984, -45.000003, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1524.877929, 832.076965, 835.178222, 89.999992, 154.471191, -64.471214, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1524.877929, 832.076843, 834.919006, 89.999992, 154.471191, -64.471214, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1519.070678, 832.083862, 830.787719, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 17541, "eastbeach2a_lae2", "lights_64HV", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1516.119873, 833.632202, 834.527648, 180.000000, 90.000000, -75.799980, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 8409, "gnhotel1", "gnhotelwindow01_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1520.268920, 835.124267, 836.417114, 540.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19357, 1520.178710, 836.584655, 835.156616, 540.000000, 90.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1524.280395, 832.083862, 830.787719, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 17541, "eastbeach2a_lae2", "lights_64HV", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1525.830932, 832.083862, 830.787719, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 17541, "eastbeach2a_lae2", "lights_64HV", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1523.659912, 833.994384, 830.787719, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 17541, "eastbeach2a_lae2", "lights_64HV", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1516.749633, 833.994384, 830.787719, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 17541, "eastbeach2a_lae2", "lights_64HV", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1521.158813, 833.966552, 835.538024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1523.390136, 833.966552, 835.538024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1525.610961, 833.966552, 835.538024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1521.158813, 833.966552, 832.898376, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1521.158813, 833.966552, 833.418579, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1521.158813, 833.966552, 834.918884, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1525.619262, 833.966552, 834.918884, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1517.447875, 833.966552, 835.538024, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1521.777221, 829.261047, 835.687805, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19089, 1519.288452, 833.966552, 832.898376, 89.999992, 89.999992, -89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1519.288452, 833.966552, 833.418579, 89.999992, 89.999992, -89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1524.818603, 833.966552, 834.918884, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "Metal3_128", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1524.296752, 836.201049, 835.687805, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(18766, 1522.147583, 829.261047, 835.686828, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(18766, 1520.845458, 836.201049, 835.686828, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(2714, 1517.977905, 831.085266, 835.190124, 270.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2714, 1520.168823, 831.085266, 835.190124, 270.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2714, 1522.409301, 831.085266, 835.190124, 270.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2714, 1524.899780, 831.085266, 835.190124, 270.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2714, 1517.977905, 834.295715, 835.190124, -89.999992, 89.999992, 89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2714, 1520.168823, 834.295715, 835.190124, -89.999992, 89.999992, 89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2714, 1522.409301, 834.295715, 835.190124, -89.999992, 89.999992, 89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(2714, 1524.899780, 834.295715, 835.190124, -89.999992, 89.999992, 89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(18766, 1528.217163, 836.201049, 835.687805, 90.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18757, "vcinteriors", "dt_officflr1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(2714, 1526.380737, 832.825500, 835.190124, 270.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5042, "bombshop_las", "kb_spray_light1", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1519.943237, 832.470764, 835.287902, 180.000000, 90.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ventb128", 0x00000000);
	texture_object = CreateDynamicObjectEx(19866, 1522.453369, 832.470764, 835.288879, 180.000000, 90.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 16640, "a51", "ventb128", 0x00000000);
	texture_object = CreateDynamicObjectEx(3078, 1523.568725, 831.885498, 832.293090, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	texture_object = CreateDynamicObjectEx(3078, 1516.448242, 831.885498, 832.293090, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	texture_object = CreateDynamicObjectEx(3078, 1516.448242, 834.195556, 832.293090, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 19063, "xmasorbs", "sphere", 0x00000000);
	texture_object = CreateDynamicObjectEx(2642, 1526.336181, 830.522277, 834.127868, 0.000000, 0.000000, 540.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 17511, "stadium_lae2", "ticketsnprice_lae2", 0x00000000);
	texture_object = CreateDynamicObjectEx(2684, 1516.818359, 831.118225, 834.047729, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 1229, "signs", "bus_stop64", 0x00000000);
	texture_object = CreateDynamicObjectEx(2684, 1516.818359, 830.778076, 834.047729, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 1229, "signs", "busschedule64", 0x00000000);
	texture_object = CreateDynamicObjectEx(2642, 1526.336181, 834.822509, 834.127868, 0.000000, 0.000000, 720.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 2, 17511, "stadium_lae2", "ticketsnprice_lae2", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	texture_object = CreateDynamicObjectEx(2371, 1520.139648, 836.064331, 832.717956, 90.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	texture_object = CreateDynamicObjectEx(2371, 1515.532592, 832.661071, 833.148315, 90.000000, 0.000000, 105.600006, 300.00, 300.00, { -1 }, { 33 });
	texture_object = CreateDynamicObjectEx(2684, 1516.818359, 831.448486, 834.047729, 0.000000, 0.000000, 90.000000, 300.00, 300.00, { -1 }, { 33 });
	texture_object = CreateDynamicObjectEx(18066, 1520.177001, 835.055969, 834.918151, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	texture_object = CreateDynamicObjectEx(2690, 1521.352905, 834.746215, 834.067810, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	texture_object = CreateDynamicObjectEx(18635, 1521.322998, 830.492187, 834.018371, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	
	
	// Церковь
	texture_object = CreateObject(8661, 1239.596801, 2036.286010, 655.609069, 0.000000, 0.000007, 0.000000);
	SetObjectMaterial(texture_object, 0, 15048, "labigsave", "ah_carp1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3980, 1239.659545, 2000.233398, 661.447143, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, -1, "none", "none", 0xFFBBBBBB);
	SetDynamicObjectMaterial(texture_object, 3, 14748, "sfhsm1", "AH_orncorn", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19445, 1248.568481, 2026.427246, 657.279724, 0.000060, 0.000000, 89.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1248.568481, 2026.424316, 658.545349, 0.000060, 0.000000, 89.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1248.568481, 2026.417236, 659.816467, 0.000060, 0.000000, 89.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1248.568481, 2026.415283, 661.105773, 0.000060, 0.000000, 89.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1248.568481, 2026.413330, 662.395080, 0.000060, 0.000000, 89.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1248.568481, 2026.411376, 664.064575, 0.000060, 0.000000, 89.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1248.568481, 2026.427246, 666.018737, 0.000068, 0.000000, 89.999794, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1238.917724, 2026.427246, 657.279724, 0.000068, 0.000000, 89.999794, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1238.917724, 2026.424316, 658.545349, 0.000068, 0.000000, 89.999794, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1238.917724, 2026.417236, 659.816467, 0.000068, 0.000000, 89.999794, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1238.917724, 2026.413330, 662.395080, 0.000068, 0.000000, 89.999794, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1238.917724, 2026.411376, 664.064575, 0.000068, 0.000000, 89.999794, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1238.917724, 2026.427246, 666.018737, 0.000075, 0.000000, 89.999771, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1229.307006, 2026.427246, 657.279724, 0.000082, 0.000000, 89.999748, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1229.307006, 2026.424316, 658.545349, 0.000082, 0.000000, 89.999748, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1229.307006, 2026.417236, 659.816467, 0.000082, 0.000000, 89.999748, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1229.307006, 2026.413330, 662.395080, 0.000082, 0.000000, 89.999748, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1229.307006, 2026.411376, 664.064575, 0.000082, 0.000000, 89.999748, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1229.307006, 2026.427246, 666.018737, 0.000091, 0.000000, 89.999725, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(8661, 1239.596801, 2056.274902, 655.609069, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 15048, "labigsave", "ah_carp1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3980, 1239.627319, 2078.510742, 661.447143, 0.000007, -0.000029, 179.999694, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, -1, "none", "none", 0xFFBBBBBB);
	SetDynamicObjectMaterial(texture_object, 3, 14748, "sfhsm1", "AH_orncorn", 0xFFBBBBBB);
	SetDynamicObjectMaterial(texture_object, 4, 9931, "churchsfe", "church_sfe3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 1230.718383, 2052.316894, 657.279724, 0.000022, -0.000007, -90.000083, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1230.718383, 2052.319824, 658.545349, 0.000022, -0.000007, -90.000083, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1230.718383, 2052.326904, 659.816467, 0.000022, -0.000007, -90.000083, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1230.718383, 2052.328857, 661.105773, 0.000022, -0.000007, -90.000083, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1230.718383, 2052.330810, 662.395080, 0.000022, -0.000007, -90.000083, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1230.718383, 2052.332763, 664.064575, 0.000022, -0.000007, -90.000083, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1230.718383, 2052.316894, 666.018737, 0.000029, -0.000007, -90.000099, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1240.369140, 2052.316894, 657.279724, 0.000029, -0.000007, -90.000099, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1240.369140, 2052.319824, 658.545349, 0.000029, -0.000007, -90.000099, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1240.369140, 2052.326904, 659.816467, 0.000029, -0.000007, -90.000099, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1240.369140, 2052.330810, 662.395080, 0.000029, -0.000007, -90.000099, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1240.369140, 2052.332763, 664.064575, 0.000029, -0.000007, -90.000099, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1240.369140, 2052.316894, 666.018737, 0.000037, -0.000007, -90.000129, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1249.979858, 2052.316894, 657.279724, 0.000045, -0.000007, -90.000144, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1249.979858, 2052.319824, 658.545349, 0.000045, -0.000007, -90.000144, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1249.979858, 2052.326904, 659.816467, 0.000045, -0.000007, -90.000144, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1249.979858, 2052.330810, 662.395080, 0.000045, -0.000007, -90.000144, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1249.979858, 2052.332763, 664.064575, 0.000045, -0.000007, -90.000144, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe1", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1249.979858, 2052.316894, 666.018737, 0.000052, -0.000007, -90.000175, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe2", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19646, 1230.087768, 2039.380859, 671.735595, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14706, "labig2int2", "HS3_wall2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19646, 1240.067016, 2039.380859, 671.735595, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14706, "labig2int2", "HS3_wall2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19646, 1249.937377, 2039.380859, 671.735595, 0.000000, -179.999984, -0.000029, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14706, "labig2int2", "HS3_wall2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19379, 1258.053955, 2043.771606, 660.758789, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1258.093994, 2034.970947, 660.758789, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1257.192993, 2039.260620, 660.758789, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 1257.189575, 2039.465942, 664.159729, 0.000037, 0.000000, -0.000121, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe5", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1258.050292, 2043.756103, 664.159729, 0.000045, -0.000007, 89.999855, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe5", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1258.090332, 2034.986816, 664.159729, 0.000045, -0.000007, 89.999855, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe5", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1257.189575, 2039.465942, 667.659729, 0.000037, 0.000007, -0.000121, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe5", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1258.050292, 2043.756103, 667.659729, 0.000052, -0.000007, 89.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe5", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1258.090332, 2034.986816, 667.659729, 0.000052, -0.000007, 89.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe5", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19379, 1258.053955, 2043.771606, 671.257995, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe3", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1258.093994, 2034.970947, 671.257995, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9931, "churchsfe", "church_sfe3", 0x00000000);
	texture_object = CreateDynamicObjectEx(14629, 1246.665527, 2054.828613, 668.115722, 0.000000, 0.000052, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 960, "cj_crate_will", "CJ_FLIGHT_CASE", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 896, "underwater", "greyrockbig", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 8419, "vgsbldng1", "cityplansign01_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1222.031005, 2039.036376, 663.733459, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 15048, "labigsave", "ah_posmarskirt", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1221.220581, 2034.976318, 663.733459, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 15048, "labigsave", "ah_posmarskirt", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1221.220581, 2043.756469, 663.733459, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 15048, "labigsave", "ah_posmarskirt", 0x00000000);
	texture_object = CreateDynamicObjectEx(2791, 1221.913208, 2039.253417, 678.611999, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3975, "lanbloke", "lasbevcit2", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 3922, "bistro", "StainedGlass", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1221.220581, 2043.756469, 674.163085, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 15048, "labigsave", "ah_posmarskirt", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1221.220581, 2034.966552, 674.163085, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 15048, "labigsave", "ah_posmarskirt", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 1229.370239, 2034.424560, 668.506652, 0.000007, 2.399998, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10377, "cityhall_sfs", "ws_cityhall3", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19940, 1222.148559, 2039.260864, 660.310180, 89.999992, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar06", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19940, 1222.148559, 2039.260864, 662.250061, 89.999992, 179.999984, -90.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar06", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19940, 1222.158569, 2039.250854, 662.289916, 0.000000, 90.000015, -0.000029, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar06", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(3092, 1222.381103, 2039.281005, 661.615600, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1246.684204, 2039.143066, 675.365112, 0.000000, 0.000052, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1246.670532, 2039.166748, 675.365112, 0.000037, 0.000022, 89.999855, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19646, 1259.897338, 2039.380859, 671.735595, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14706, "labig2int2", "HS3_wall2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19445, 1257.170166, 2039.355957, 657.279724, 0.000052, 0.000000, -0.000167, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1258.050170, 2043.755981, 657.279724, 0.000060, -0.000007, 89.999809, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1258.090209, 2034.975097, 657.279724, 0.000060, -0.000007, 89.999809, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19379, 1253.299316, 2048.501708, 666.609191, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(19379, 1253.299316, 2048.501708, 656.129577, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(19379, 1253.299316, 2030.231079, 666.609191, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(19379, 1253.299316, 2030.231079, 656.129577, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(19379, 1225.997070, 2048.501708, 666.609191, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(19379, 1225.997070, 2048.501708, 656.129577, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	SetDynamicObjectMaterial(texture_object, 1, 10377, "cityhall_sfs", "ws_cityhall2", 0x00000000);
	texture_object = CreateDynamicObjectEx(19379, 1225.997070, 2030.231079, 666.609191, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(19379, 1225.997070, 2030.231079, 656.129577, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(2906, 1222.321777, 2039.645019, 662.342773, 20.899961, 0.000014, -0.000033, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19379, 1257.166625, 2039.511840, 674.648925, 0.000000, 0.000022, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19379, 1258.037109, 2043.751464, 674.648925, 0.000007, 0.000014, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(19379, 1258.037109, 2034.971313, 674.648925, 0.000007, 0.000014, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFCFCFCF);
	texture_object = CreateDynamicObjectEx(2906, 1222.371826, 2038.832031, 662.199523, 3.999984, 360.000000, -179.999984, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(11712, 1222.506713, 2039.255004, 662.079223, 0.000000, -5.399992, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, -1, "none", "none", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19646, 1221.078857, 2039.380859, 671.715637, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 15048, "labigsave", "ah_posmarskirt", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19646, 1258.139648, 2039.380859, 671.715637, 0.000000, 179.999984, -179.999938, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3980, "cityhall_lan", "citywall1", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19445, 1221.240844, 2043.755981, 657.279724, 0.000060, -0.000007, 89.999809, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1221.240844, 2034.995849, 657.279724, 0.000060, -0.000007, 89.999809, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1222.071166, 2039.366821, 657.279724, 0.000052, -0.000014, 179.999786, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14853, "gen_pol_vegas", "mp_cop_panel", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19089, 1246.086303, 2039.153076, 675.311584, 0.000000, -5.099945, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1247.244750, 2039.153076, 675.276428, 0.000000, 4.900051, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1246.660522, 2038.568847, 675.311584, 0.000037, -5.099976, 89.999855, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1246.660522, 2039.727294, 675.276428, 0.000037, 4.900021, 89.999855, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1235.902954, 2039.143066, 675.365112, 0.000000, 0.000060, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1235.889282, 2039.166748, 675.365112, 0.000045, 0.000022, 89.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1235.305053, 2039.153076, 675.311584, 0.000000, -5.099936, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1236.463500, 2039.153076, 675.276428, 0.000000, 4.900059, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1235.879272, 2038.568847, 675.311584, 0.000045, -5.099976, 89.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1235.879272, 2039.727294, 675.276428, 0.000045, 4.900021, 89.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(14629, 1241.853881, 2054.828613, 668.115722, 0.000000, 0.000060, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 960, "cj_crate_will", "CJ_FLIGHT_CASE", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 896, "underwater", "greyrockbig", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 8419, "vgsbldng1", "cityplansign01_256", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1241.872558, 2039.143066, 675.365112, 0.000000, 0.000060, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1241.858886, 2039.166748, 675.365112, 0.000045, 0.000022, 89.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1241.274658, 2039.153076, 675.311584, 0.000000, -5.099936, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1242.433105, 2039.153076, 675.276428, 0.000000, 4.900059, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1241.848876, 2038.568847, 675.311584, 0.000045, -5.099976, 89.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1241.848876, 2039.727294, 675.276428, 0.000045, 4.900021, 89.999832, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1231.091308, 2039.143066, 675.365112, 0.000000, 0.000068, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1231.077636, 2039.166748, 675.365112, 0.000052, 0.000022, 89.999809, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1230.493408, 2039.153076, 675.311584, 0.000000, -5.099929, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1231.651855, 2039.153076, 675.276428, 0.000000, 4.900065, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1231.067626, 2038.568847, 675.311584, 0.000052, -5.099976, 89.999809, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19089, 1231.067626, 2039.727294, 675.276428, 0.000052, 4.900021, 89.999809, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2669, "cj_chris", "Bow_Fence_Metal", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 1238.979858, 2034.424560, 668.506652, 0.000007, 2.399998, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10377, "cityhall_sfs", "ws_cityhall3", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1248.529663, 2034.424560, 668.506652, 0.000007, 2.399998, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10377, "cityhall_sfs", "ws_cityhall3", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19068, 1222.490356, 2039.261474, 662.454833, -34.900016, 38.300056, 0.000004, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0x00000000);
	texture_object = CreateDynamicObjectEx(2791, 1221.913208, 2039.253417, 674.352172, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3975, "lanbloke", "lasbevcit2", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 3922, "bistro", "StainedGlass", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	texture_object = CreateDynamicObjectEx(2791, 1221.913208, 2039.253417, 670.072326, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3975, "lanbloke", "lasbevcit2", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 3922, "bistro", "StainedGlass", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	texture_object = CreateDynamicObjectEx(2791, 1221.903198, 2039.253417, 665.822753, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3975, "lanbloke", "lasbevcit2", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 3922, "bistro", "StainedGlass", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 10101, "2notherbuildsfe", "Bow_church_grass_alt", 0x00000000);
	texture_object = CreateDynamicObjectEx(3980, 1188.442504, 2039.203125, 663.987670, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, -1, "none", "none", 0xFFBBBBBB);
	SetDynamicObjectMaterial(texture_object, 3, 14748, "sfhsm1", "AH_orncorn", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19068, 1222.378540, 2039.197509, 662.345397, -34.900016, -136.499908, 0.000004, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14652, "ab_trukstpa", "wood01", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1225.546630, 2041.152954, 654.198852, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(2789, 1225.546630, 2037.342407, 654.198852, 0.000007, 0.000000, 89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10101, "2notherbuildsfe", "ferry_build14", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1253.102294, 2029.805053, 657.428100, 0.000007, 360.000000, 179.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(3980, 1197.507690, 1971.929931, 661.447143, 0.000007, -0.000029, 269.999694, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, -1, "none", "none", 0xFFBBBBBB);
	SetDynamicObjectMaterial(texture_object, 3, 14748, "sfhsm1", "AH_orncorn", 0xFFBBBBBB);
	SetDynamicObjectMaterial(texture_object, 4, 9931, "churchsfe", "church_sfe3", 0x00000000);
	texture_object = CreateDynamicObjectEx(5779, 1257.096313, 2037.077758, 670.949035, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(5779, 1257.096313, 2042.297973, 670.949035, 0.000000, 0.000007, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(5779, 1257.096313, 2037.077758, 674.118774, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(5779, 1257.096313, 2042.297973, 674.118774, 0.000000, 0.000014, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(2691, 1252.990234, 2029.823608, 657.384643, -0.000007, 0.000000, -90.000015, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1253.102294, 2029.805053, 665.518615, 0.000007, 360.000000, 179.999771, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(2691, 1252.990234, 2029.823608, 665.475158, -0.000014, 0.000000, -89.999992, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14737, "whorewallstuff", "ah_painting1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3980, 1197.517700, 2106.799316, 661.447143, 0.000007, -0.000029, 269.999694, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, -1, "none", "none", 0xFFBBBBBB);
	SetDynamicObjectMaterial(texture_object, 3, 14748, "sfhsm1", "AH_orncorn", 0xFFBBBBBB);
	SetDynamicObjectMaterial(texture_object, 4, 9931, "churchsfe", "church_sfe3", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1236.908691, 2046.307739, 659.655029, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1231.438964, 2046.307739, 659.655029, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1242.039184, 2046.307739, 659.655029, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1248.019287, 2046.307739, 659.655029, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1236.558349, 2032.587768, 659.655029, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(2791, 1253.383178, 2029.857421, 668.339721, 0.000007, 0.000000, -90.000038, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 9259, "presidio01_sfn", "stainwin_law", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(5779, 1253.189941, 2029.775634, 665.448852, -0.000007, -0.000007, -0.000037, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14758, "sfmansion1", "ah_stainglass", 0x00000000);
	texture_object = CreateDynamicObjectEx(5779, 1253.189941, 2029.775634, 657.509033, -0.000007, -0.000007, -0.000037, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14758, "sfmansion1", "ah_stainglass", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1231.088623, 2032.587768, 659.655029, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1253.102294, 2048.805664, 657.428100, 0.000007, 360.000000, 179.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(2791, 1253.383178, 2048.847167, 668.339721, 0.000014, 0.000000, -90.000053, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 19962, "samproadsigns", "materialtext1", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 9259, "presidio01_sfn", "stainwin_law", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 19962, "samproadsigns", "materialtext1", 0x00000000);
	texture_object = CreateDynamicObjectEx(5779, 1253.189941, 2048.765625, 665.448852, -0.000007, -0.000014, -0.000082, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14758, "sfmansion1", "ah_stainglass", 0x00000000);
	texture_object = CreateDynamicObjectEx(5779, 1253.189941, 2048.765625, 657.509033, -0.000007, -0.000014, -0.000082, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14758, "sfmansion1", "ah_stainglass", 0x00000000);
	texture_object = CreateDynamicObjectEx(2691, 1252.990234, 2048.824218, 657.384643, 0.000000, 0.000000, -90.000038, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(19445, 1248.529663, 2044.335937, 668.506652, 0.000007, 2.399991, -90.000038, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10377, "cityhall_sfs", "ws_cityhall3", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1238.920043, 2044.335937, 668.506652, 0.000007, 2.399991, -90.000038, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10377, "cityhall_sfs", "ws_cityhall3", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(19445, 1229.370239, 2044.335937, 668.506652, 0.000007, 2.399991, -90.000038, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10377, "cityhall_sfs", "ws_cityhall3", 0xFFFFFFFF);
	texture_object = CreateDynamicObjectEx(1763, 1229.772338, 2042.760009, 655.458129, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1255.327636, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1251.807128, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1248.317260, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1241.417968, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1244.887695, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1237.997436, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1234.497802, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1231.007812, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1227.506958, 2039.361450, 655.538940, 180.000000, 90.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14383, "burg_1", "carpet4kb", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1229.772338, 2045.010009, 655.458129, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1229.772338, 2035.070922, 655.458129, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1229.772338, 2037.320922, 655.458129, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1233.233276, 2042.760009, 655.458129, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1233.233276, 2045.010009, 655.458129, -0.000007, 0.000000, -89.999977, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1233.233276, 2035.070922, 655.458129, -0.000014, 0.000000, -89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1233.233276, 2037.320922, 655.458129, -0.000014, 0.000000, -89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1235.324096, 2042.760009, 655.458129, -0.000014, 0.000000, -89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1235.324096, 2045.010009, 655.458129, -0.000014, 0.000000, -89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1235.324096, 2035.070922, 655.458129, -0.000022, 0.000000, -89.999931, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1235.324096, 2037.320922, 655.458129, -0.000022, 0.000000, -89.999931, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1244.304077, 2042.760009, 655.458129, -0.000029, 0.000000, -89.999908, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1244.304077, 2045.010009, 655.458129, -0.000029, 0.000000, -89.999908, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1244.304077, 2035.070922, 655.458129, -0.000037, 0.000000, -89.999885, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1244.304077, 2037.320922, 655.458129, -0.000037, 0.000000, -89.999885, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1238.843627, 2042.760009, 655.458129, -0.000022, 0.000000, -89.999931, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1238.843627, 2045.010009, 655.458129, -0.000022, 0.000000, -89.999931, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1238.843627, 2035.070922, 655.458129, -0.000029, 0.000000, -89.999908, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1238.843627, 2037.320922, 655.458129, -0.000029, 0.000000, -89.999908, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1240.934448, 2042.760009, 655.458129, -0.000029, 0.000000, -89.999908, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1240.934448, 2045.010009, 655.458129, -0.000029, 0.000000, -89.999908, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1240.934448, 2035.070922, 655.458129, -0.000037, 0.000000, -89.999885, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1240.934448, 2037.320922, 655.458129, -0.000037, 0.000000, -89.999885, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1246.394897, 2042.760009, 655.458129, -0.000037, 0.000000, -89.999885, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1246.394897, 2045.010009, 655.458129, -0.000037, 0.000000, -89.999885, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1246.394897, 2035.070922, 655.458129, -0.000045, 0.000000, -89.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1246.394897, 2037.320922, 655.458129, -0.000045, 0.000000, -89.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1249.654296, 2042.760009, 655.458129, -0.000037, 0.000000, -89.999885, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1249.654296, 2045.010009, 655.458129, -0.000037, 0.000000, -89.999885, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1249.654296, 2035.070922, 655.458129, -0.000045, 0.000000, -89.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1249.654296, 2037.320922, 655.458129, -0.000045, 0.000000, -89.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1251.745117, 2042.760009, 655.458129, -0.000045, 0.000000, -89.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1251.745117, 2045.010009, 655.458129, -0.000045, 0.000000, -89.999862, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1251.745117, 2035.070922, 655.458129, -0.000052, 0.000000, -89.999839, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(1763, 1251.745117, 2037.320922, 655.458129, -0.000052, 0.000000, -89.999839, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1257.156860, 2039.361450, 657.228881, 360.000000, 360.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 3820, "boxhses_sfsx", "ws_wood_doors2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19358, 1257.156860, 2041.951538, 660.788574, 360.000000, 360.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(19358, 1257.156860, 2036.721191, 660.788574, 360.000000, 360.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(2691, 1257.008911, 2041.979736, 660.745117, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9259, "presidio01_sfn", "stainwin_law", 0x00000000);
	texture_object = CreateDynamicObjectEx(2691, 1257.008911, 2036.739257, 660.745117, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 9259, "presidio01_sfn", "stainwin_law", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1255.287231, 2043.751342, 660.788574, 360.000000, 360.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(2691, 1255.268676, 2043.639282, 660.745117, 0.000000, 0.000000, 360.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1255.268676, 2034.979736, 660.788574, 0.000007, 360.000000, 89.999938, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(2691, 1255.287231, 2035.091796, 660.745117, 0.000007, 0.000000, 179.999877, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14758, "sfmansion1", "ah_stainglass", 0x00000000);
	texture_object = CreateDynamicObjectEx(19358, 1253.102294, 2048.805664, 665.518615, 0.000007, 360.000000, 179.999816, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14420, "dr_gsbits", "mp_apt1_frame2", 0xFFBBBBBB);
	texture_object = CreateDynamicObjectEx(2691, 1252.990234, 2048.824218, 665.475158, -0.000007, 0.000000, -90.000015, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14737, "whorewallstuff", "ah_painting1", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1241.688842, 2032.587768, 659.655029, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1247.668945, 2032.587768, 659.655029, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1223.589355, 2035.947631, 660.035278, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(3439, 1223.589355, 2042.528076, 660.035278, 0.000000, -0.000007, 179.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 18028, "cj_bar2", "GB_nastybar07", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 2098, "cj_int", "CJ_GREEN_WOOD", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 2, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(2446, 1224.552368, 2039.580566, 656.019409, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(2446, 1224.552368, 2038.590576, 656.019409, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(2446, 1224.552368, 2037.619995, 656.018981, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1224.716674, 2035.143554, 659.965087, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 3922, "bistro", "StainedGlass", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1224.716674, 2035.143554, 661.144958, 360.000000, 270.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 9259, "presidio01_sfn", "stainwin_law", 0x00000000);
	texture_object = CreateDynamicObjectEx(2446, 1224.552368, 2040.580810, 656.019409, 0.000014, 0.000000, 89.999954, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 2415, "cj_ff", "CJ_cooker4", 0xFFFFFFFF);
	SetDynamicObjectMaterial(texture_object, 1, 18028, "cj_bar2", "GB_nastybar06", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1224.716674, 2035.143554, 662.334960, 0.000000, 0.000000, 180.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1224.716674, 2043.623901, 659.965087, -0.000007, 0.000000, 0.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 3922, "bistro", "StainedGlass", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1224.716674, 2043.623901, 661.144958, -0.000007, 270.000000, 0.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 9259, "presidio01_sfn", "stainwin_law", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1224.716674, 2043.623901, 662.334960, -0.000007, 0.000000, 0.000007, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1257.029174, 2039.373413, 659.654785, -0.000015, -0.000007, -89.999938, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 3922, "bistro", "StainedGlass", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1257.029174, 2039.373413, 660.704528, -0.000015, 270.000000, -89.999938, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 9259, "presidio01_sfn", "stainwin_law", 0x00000000);
	texture_object = CreateDynamicObjectEx(2641, 1257.029174, 2039.373413, 661.764404, -0.000015, -0.000007, -89.999938, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 14581, "ab_mafiasuitea", "goldPillar", 0x00000000);
	SetDynamicObjectMaterial(texture_object, 1, 5401, "jeffers4_lae", "stainwinLAe", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 1225.150146, 2043.602905, 656.519287, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
	texture_object = CreateDynamicObjectEx(3850, 1225.150146, 2035.004028, 656.519287, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	SetDynamicObjectMaterial(texture_object, 0, 10442, "graveyard_sfs", "ws_graveydfence", 0x00000000);
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	texture_object = CreateDynamicObjectEx(2894, 1224.676147, 2039.108154, 657.071044, 0.000000, 0.000000, 270.000000, 300.00, 300.00, { -1 }, { 33 });
	texture_object = CreateDynamicObjectEx(2868, 1224.591796, 2038.406127, 657.060363, 0.000000, 0.000000, 0.000000, 300.00, 300.00, { -1 }, { 33 });
	return 1 ;
}

#if defined samp
public OnPlayerClickPlayerTextDraw ( playerid, PlayerText:playertextid )
{
    //cards_PlayerTextDraw ( playerid, playertextid ) ;

	if ( roulette_used { playerid } )
	{
	    if ( playertextid == roulette_ptd [ playerid ] [ 12 ] )
	    {
	        if ( roulette_bet [ playerid ] != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Ставка уже сделана." ) ;

			new number_name [ 16 ] ;
			switch ( player_casino_position [ playerid ] )
			{
				case 0..36:format ( number_name, 16, "%d", player_casino_position [ playerid ] ) ;
				case 37:format ( number_name, 16, "1-й столбец" ) ;
				case 38:format ( number_name, 16, "2-й столбец" ) ;
				case 39:format ( number_name, 16, "3-й столбец" ) ;
				case 40:format ( number_name, 16, "1-е 12 чисел" ) ;
				case 41:format ( number_name, 16, "2-е 12 чисел" ) ;
				case 42:format ( number_name, 16, "3-е 12 чисел" ) ;
				case 43:format ( number_name, 16, "красные" ) ;
				case 44:format ( number_name, 16, "чёрные" ) ;
			}

			roulette_number [ playerid ] = player_casino_position [ playerid ] ;

			new dialog_string [ 149 ] ;
			format ( dialog_string, 149, "{ffffff}Введите сумму, которую желаете поставить на %s\n\n{828282}* Ставка должна быть не менее 1000$ и не более 3.000.000$",
			number_name ) ;
			show_dialog ( playerid, d_roulette_bet, 1, "{FFCC00}Ставка", dialog_string, "Принять", "Отмена" ) ;
			return 1 ;
	    }
	    
		else if ( playertextid == roulette_ptd [ playerid ] [ 26 ] )
	    {
	        if ( roulette_bet [ playerid ] != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Ставка уже сделана." ) ;

			callcmd::test_down ( playerid ) ;
			return 1 ;
	    }
	    
	    else if ( playertextid == roulette_ptd [ playerid ] [ 27 ] )
	    {
	        if ( roulette_bet [ playerid ] != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Ставка уже сделана." ) ;

			callcmd::test_left ( playerid ) ;
			return 1 ;
	    }
	    
	    else if ( playertextid == roulette_ptd [ playerid ] [ 28 ] )
	    {
	        if ( roulette_bet [ playerid ] != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Ставка уже сделана." ) ;

			callcmd::test_right ( playerid ) ;
			return 1 ;
	    }
	    
	    else if ( playertextid == roulette_ptd [ playerid ] [ 29 ] )
	    {
	        if ( roulette_bet [ playerid ] != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Ставка уже сделана." ) ;

			callcmd::test_up ( playerid ) ;
			return 1 ;
	    }
	    
	    else if ( playertextid == roulette_ptd [ playerid ] [ 35 ] )
	    {
			new _table_id = roulette_used { playerid } - 1 ;
			for ( new p = 0 ; p < 6 ; p ++ )
			{
	 			if ( roulette_players [ _table_id ] [ p ] != playerid ) continue ;
	   			{
			        roulette_used { playerid } = 0 ;
			        roulette_players [ _table_id ] [ p ] = INVALID_PLAYER_ID ;

			        show_roulette_ptd ( playerid, false ) ;
					show_roulette_players ( playerid, _table_id, false ) ;
			   	}
			   	SetCameraBehindPlayer ( playerid ) ;
		    }
		    
		    if ( roulette_bet [ playerid ] != 0 ) give_money ( playerid, roulette_bet [ playerid ] ) ;
			return 1 ;
	    }
	    return 1 ;
	}

	if ( bg_used [ playerid ] )
	{
	    new _table = bg_player_table [ playerid ] ;
	    if ( bg_info [ _table ] [ bg_move ] != playerid ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не, не твой ход." ) ;

        if ( playertextid == bg_ptd [ playerid ] [ 25 ] )
        {
			if ( bg_info [ _table ] [ bg_time ] != -1 || bg_info [ _table ] [ bg_dice ] [ 0 ] != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Кубики уже брошены." ) ;
            bg_info [ _table ] [ bg_time_count ] = random ( 5 ) + 2 ;
			bg_info [ _table ] [ bg_time ] = SetTimerEx ( "bg_timer", 1000, true, "i", _table ) ;
            return 1 ;
        }
        
        else if ( playertextid == bg_ptd [ playerid ] [ 27 ] )
        {
            new target_id = bg_info [ _table ] [ bg_player ] [ 0 ], target_id_1 = bg_info [ _table ] [ bg_player ] [ 1 ] ;
			
			if ( target_id != INVALID_PLAYER_ID )
			{
			    bg_used [ target_id ] = false ;
				show_ptd_chess ( target_id, false ) ;
				show_ptd_nards ( 0, _table, false ) ;
			}
			if ( target_id_1 != INVALID_PLAYER_ID )
			{
			    bg_used [ target_id_1 ] = false ;
				show_ptd_chess ( target_id_1, false ) ;
				show_ptd_nards ( 1, _table, false ) ;
			}
            return 1 ;
        }
        
        else if ( playertextid == bg_ptd [ playerid ] [ 29 ] )
        {
            callcmd::skip ( playerid ) ;
            return 1 ;
        }

		for ( new n = 0 ; n < 30 ; n ++ )
		{
   			if ( playertextid == bg_nard_ptd [ playerid ] [ n ] )
   			{
   			    if ( bg_info [ _table ] [ bg_nard_player ] [ n ] != playerid ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не, не твоя нарда." ) ;
   			    if ( ( bg_info [ _table ] [ bg_nard_slot ] [ n ] == 0 || bg_info [ _table ] [ bg_nard_slot ] [ n ] == 12 ) && bg_head_nard [ playerid ] )
				   																return SendClientMessage ( playerid, 0xFF6600FF, !"Ты уже брал с головы." ) ;

                if ( bg_info [ _table ] [ bg_nard_count ] [ bg_info [ _table ] [ bg_nard_slot ] [ n ] ] != bg_info [ _table ] [ bg_nard_count_id ] [ n ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Сперва нужно взять вернюю нарду." ) ;
                
                /*

					брал ли игрок с головы

				*/

				if ( bg_info [ _table ] [ bg_nard_slot ] [ n ] == 0 || bg_info [ _table ] [ bg_nard_slot ] [ n ] == 12 ) bg_head_nard [ playerid ] = true ;

		   	    ////////////////////////////////////

		   	    bg_used_nard [ playerid ] = n ;
		   	    SendClientMessage ( playerid, -1, "Вы выбрали нарду, сделайте ход." ) ;
   			    return 1 ;
			}
		}

		if ( bg_used_nard [ playerid ] == -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Ты не выбрал нарду." ) ;
		
		new _move_result_1 = bg_info [ _table ] [ bg_dice ] [ 0 ],
	        _move_result_2 = bg_info [ _table ] [ bg_dice ] [ 1 ],
	        _move_result_3 = bg_info [ _table ] [ bg_dice ] [ 2 ],
	        _move_result_4 = bg_info [ _table ] [ bg_dice ] [ 3 ] ;
		    
	    for ( new j = 0 ; j < 24 ; j ++ )
		{
			if ( playertextid == bg_ptd [ playerid ] [ j ] )
			{
			    if ( bg_info [ _table ] [ bg_cell_player ] [ j ] != -1 && bg_info [ _table ] [ bg_cell_player ] [ j ] != playerid ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не можете ходить на данную позицию, она занята другим игроком." ) ;

				if ( bg_info [ _table ] [ bg_cell_player ] [ j ] == playerid ) // Наш слот
				{
				    new _td_id = bg_used_nard [ playerid ], _slot_nard = bg_info [ _table ] [ bg_nard_slot ] [ _td_id ] ;
					    
				    if ( ( j == 0 || j == 12 ) && bg_info [ _table ] [ bg_nard_count ] [ j ] != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (1)" ) ;
				    if ( j == _slot_nard ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (1)" ) ;
					if ( j > _slot_nard )
					{
					    if ( bg_info [ _table ] [ bg_player ] [ 1 ] == playerid && j > 12 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. Тебе нужно заходить в голову." ) ;
						if ( ! bg_info [ _table ] [ bg_player_dice_count ] )
						{
						    if ( j - _slot_nard != _move_result_1 &&
								j - _slot_nard != _move_result_2 &&
								j - _slot_nard != _move_result_3 &&
								j - _slot_nard != _move_result_4 &&
								j - _slot_nard != _move_result_1 + _move_result_2 + _move_result_3 + _move_result_4 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (2)" ) ;

							bg_info [ _table ] [ bg_player_dice_count ] = j - _slot_nard ;
							bg_used_nard [ playerid ] = -1 ;

							/*

								смена игрока

							*/

							if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_1 + _move_result_2 + _move_result_3 + _move_result_4 )
							{
		    					bg_change_player [ _table ] = true ;
							}
						}
						else if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_1 && ! bg_info [ _table ] [ bg_dice ] [ 2 ] )
						{
						    if ( j - _slot_nard != _move_result_2 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (3)" ) ;
						    bg_info [ _table ] [ bg_player_dice_count ] = _move_result_1 + _move_result_2 ;

						    /*

								смена игрока

							*/


			     			bg_change_player [ _table ] = true ;
						}
						else if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_2 && ! bg_info [ _table ] [ bg_dice ] [ 2 ] )
						{
						    if ( j - _slot_nard != _move_result_1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (4)" ) ;
						    bg_info [ _table ] [ bg_player_dice_count ] = _move_result_1 + _move_result_2 ;

						    /*

								смена игрока

							*/


			     			bg_change_player [ _table ] = true ;
						}
						else if ( bg_info [ _table ] [ bg_dice ] [ 2 ] && bg_info [ _table ] [ bg_dice ] [ 3 ] )
						{
							if ( j - _slot_nard != bg_info [ _table ] [ bg_dice ] [ 0 ] &&
								 j - _slot_nard != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 2 ) - bg_info [ _table ] [ bg_player_dice_count ] &&
								 j - _slot_nard != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 3 ) - bg_info [ _table ] [ bg_player_dice_count ] &&
								 j - _slot_nard != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 4 ) - bg_info [ _table ] [ bg_player_dice_count ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (5)" ) ;

						    bg_info [ _table ] [ bg_player_dice_count ] += j - _slot_nard ;

						    /*

								смена игрока

							*/

							if ( bg_info [ _table ] [ bg_player_dice_count ] == bg_info [ _table ] [ bg_dice ] [ 0 ] * 4 )
							{
				     			bg_change_player [ _table ] = true ;
							}
						}
					}
					else
					{
						new _pidorskiy_result = ( 24 - _slot_nard ) + j ;

						if ( bg_info [ _table ] [ bg_player ] [ 0 ] == playerid ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. Тебе нужно заходить в голову." ) ;
						else if ( _pidorskiy_result > 12 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. Тебе нужно заходить в голову." ) ;

					    if ( ! bg_info [ _table ] [ bg_player_dice_count ] )
						{
						    if ( _pidorskiy_result != _move_result_1 &&
								_pidorskiy_result != _move_result_2 &&
								_pidorskiy_result != _move_result_3 &&
								_pidorskiy_result != _move_result_4 &&
								_pidorskiy_result != _move_result_1 + _move_result_2 + _move_result_3 + _move_result_4 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход." ) ;

                            bg_info [ _table ] [ bg_player_dice_count ] = _pidorskiy_result ;
                            bg_used_nard [ playerid ] = -1 ;

                            /*

								смена игрока

							*/

							if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_1 + _move_result_2 )
							{
			     				bg_change_player [ _table ] = true ;
							}
						}
						else if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_1 )
						{
						    if ( _pidorskiy_result != _move_result_2 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход." ) ;

						    bg_info [ _table ] [ bg_player_dice_count ] = _move_result_1 + _move_result_2 ;

							/*

								смена игрока

							*/


			     			bg_change_player [ _table ] = true ;
						}
						else if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_2 )
						{
						    if ( _pidorskiy_result != _move_result_1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход." ) ;
						    bg_info [ _table ] [ bg_player_dice_count ] = _move_result_1 + _move_result_2 ;

						    /*

								смена игрока

							*/


							bg_change_player [ _table ] = true ;
						}
						else if ( bg_info [ _table ] [ bg_dice ] [ 2 ] && bg_info [ _table ] [ bg_dice ] [ 3 ] )
						{
							if ( _pidorskiy_result != bg_info [ _table ] [ bg_dice ] [ 0 ] &&
								 _pidorskiy_result != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 2 ) - bg_info [ _table ] [ bg_player_dice_count ] &&
								 _pidorskiy_result != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 3 ) - bg_info [ _table ] [ bg_player_dice_count ] &&
								 _pidorskiy_result != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 4 ) - bg_info [ _table ] [ bg_player_dice_count ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (5)" ) ;

						    bg_info [ _table ] [ bg_player_dice_count ] += _pidorskiy_result ;

						    /*

								смена игрока

							*/

							if ( bg_info [ _table ] [ bg_player_dice_count ] == bg_info [ _table ] [ bg_dice ] [ 0 ] * 4 )
							{
				     			bg_change_player [ _table ] = true ;
							}
						}
					}
						
					bg_info [ _table ] [ bg_cell_player ] [ j ] = playerid ;
					    
					//PlayerTextDrawDestroy ( playerid, bg_nard_ptd [ playerid ] [ _td_id ] ) ;
					PlayerTextDrawDestroy ( bg_info [ _table ] [ bg_player ] [ 0 ], bg_nard_ptd [ bg_info [ _table ] [ bg_player ] [ 0 ] ] [ _td_id ] ) ;
					PlayerTextDrawDestroy ( bg_info [ _table ] [ bg_player ] [ 1 ], bg_nard_ptd [ bg_info [ _table ] [ bg_player ] [ 1 ] ] [ _td_id ] ) ;
						
					/*

						минус слот

					*/

					bg_info [ _table ] [ bg_nard_count ] [ _slot_nard ] -- ;
						
					if ( ! bg_info [ _table ] [ bg_nard_count ] [ _slot_nard ] )
					{
					    bg_info [ _table ] [ bg_cell_player ] [ _slot_nard ] = -1 ;
					}
						
					bg_info [ _table ] [ bg_nard_count ] [ j ] ++ ;
					bg_info [ _table ] [ bg_nard_count_id ] [ _td_id ] = bg_info [ _table ] [ bg_nard_count ] [ j ] ;
	                bg_info [ _table ] [ bg_nard_slot ] [ _td_id ] = j ;
						
					/*

						создаём нарду, если уже есть, то в ряд выстраиваем

					*/

            		new _nard_count = 0 ;
				    for ( new q = 0 ; q < bg_info [ _table ] [ bg_nard_count ] [ j ] ; q ++ )
				    {
						if ( q == 0 ) continue ;
						_nard_count += 10 ;
					}

				    for ( new p = 0 ; p < 2 ; p ++ )
					{
					    new player_id = bg_info [ _table ] [ bg_player ] [ p ] ;
					    if ( bg_info [ _table ] [ bg_move ] == bg_info [ _table ] [ bg_player ] [ 0 ] ) bg_nard_ptd [ player_id ] [ _td_id ] = CreatePlayerTextDraw ( player_id, bg_td_pos [ j ] [ 0 ] + _nard_count, bg_td_pos [ j ] [ 1 ], "LD_CHESS:upl" ) ;
						else bg_nard_ptd [ player_id ] [ _td_id ] = CreatePlayerTextDraw ( player_id, bg_td_pos [ j ] [ 0 ] - _nard_count, bg_td_pos [ j ] [ 1 ], "LD_CHESS:up" ) ;
					    PlayerTextDrawTextSize(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 17.0000, 22.0000);
						PlayerTextDrawAlignment(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 1);
						PlayerTextDrawColor(player_id, bg_nard_ptd [ player_id ] [ _td_id ], -1);
						PlayerTextDrawBackgroundColor(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 255);
						PlayerTextDrawFont(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 4);
						PlayerTextDrawSetProportional(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 0);
						PlayerTextDrawSetShadow(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 0);
						PlayerTextDrawSetSelectable(player_id, bg_nard_ptd [ player_id ] [ _td_id ], true);
					}
						
					PlayerTextDrawShow ( bg_info [ _table ] [ bg_player ] [ 0 ], bg_nard_ptd [ bg_info [ _table ] [ bg_player ] [ 0 ] ] [ _td_id ] ) ;
					PlayerTextDrawShow ( bg_info [ _table ] [ bg_player ] [ 1 ], bg_nard_ptd [ bg_info [ _table ] [ bg_player ] [ 1 ] ] [ _td_id ] ) ;
						
					if ( bg_change_player [ _table ] )
					{
					    new scm_string [ 128 ] ;
					    if ( bg_info [ _table ] [ bg_player ] [ 0 ] == playerid )
						{
							bg_info [ _table ] [ bg_move ] = bg_info [ _table ] [ bg_player ] [ 1 ] ;
							
							format ( scm_string, sizeof scm_string, "%s закончил(а) ход. Теперь твоя очередь.", p_info [ playerid ] [ name ] ) ;
							SendClientMessage ( bg_info [ _table ] [ bg_player ] [ 1 ], 0xFFCC00FF, scm_string ) ;
							
							format ( scm_string, sizeof scm_string, "Вы закончили свой ход. Теперь ходит %s.", p_info [ bg_info [ _table ] [ bg_player ] [ 1 ] ] [ name ] ) ;
							SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
						}
						else
						{
							bg_info [ _table ] [ bg_move ] = bg_info [ _table ] [ bg_player ] [ 0 ] ;
							
							format ( scm_string, sizeof scm_string, "%s закончил(а) ход. Теперь твоя очередь.", p_info [ playerid ] [ name ] ) ;
							SendClientMessage ( bg_info [ _table ] [ bg_player ] [ 0 ], 0xFFCC00FF, scm_string ) ;

							format ( scm_string, sizeof scm_string, "Вы закончили свой ход. Теперь ходит %s.", p_info [ bg_info [ _table ] [ bg_player ] [ 0 ] ] [ name ] ) ;
							SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
						}

						bg_info [ _table ] [ bg_player_dice_count ] = 0 ;
						bg_head_nard [ playerid ] = false ;
						bg_used_nard [ playerid ] = -1 ;
						bg_change_player [ _table ] = false ;
						
						bg_info [ _table ] [ bg_dice ] [ 0 ] =
   						bg_info [ _table ] [ bg_dice ] [ 1 ] =
   						bg_info [ _table ] [ bg_dice ] [ 2 ] =
   						bg_info [ _table ] [ bg_dice ] [ 3 ] = 0 ;
					}
	                    
	                break ;
				}
				else if ( bg_info [ _table ] [ bg_cell_player ] [ j ] != playerid ) // Не наш слот, но пустой
				{
				    new _td_id = bg_used_nard [ playerid ], _slot_nard = bg_info [ _table ] [ bg_nard_slot ] [ _td_id ] ;
					    
				    /*

						считаем, верное ли количество сходил игрок

					*/

					if ( ( j == 0 || j == 12 ) && bg_info [ _table ] [ bg_nard_count ] [ j ] != 0 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (1)" ) ;
     				if ( j == _slot_nard ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (1)" ) ;
					if ( j > _slot_nard )
					{
					    if ( bg_info [ _table ] [ bg_player ] [ 1 ] == playerid && j > 12 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. Тебе нужно заходить в голову." ) ;
						if ( ! bg_info [ _table ] [ bg_player_dice_count ] )
						{
						    if ( j - _slot_nard != _move_result_1 &&
								j - _slot_nard != _move_result_2 &&
								j - _slot_nard != _move_result_3 &&
								j - _slot_nard != _move_result_4 &&
								j - _slot_nard != _move_result_1 + _move_result_2 + _move_result_3 + _move_result_4 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (2)" ) ;

							bg_info [ _table ] [ bg_player_dice_count ] = j - _slot_nard ;
							bg_used_nard [ playerid ] = -1 ;

							/*

								смена игрока

							*/

							if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_1 + _move_result_2 + _move_result_3 + _move_result_4 )
							{
		    					bg_change_player [ _table ] = true ;
							}
						}
						else if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_1 && ! bg_info [ _table ] [ bg_dice ] [ 2 ] )
						{
						    if ( j - _slot_nard != _move_result_2 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (3)" ) ;
						    bg_info [ _table ] [ bg_player_dice_count ] = _move_result_1 + _move_result_2 ;

						    /*

								смена игрока

							*/


			     			bg_change_player [ _table ] = true ;
						}
						else if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_2 && ! bg_info [ _table ] [ bg_dice ] [ 2 ] )
						{
						    if ( j - _slot_nard != _move_result_1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (4)" ) ;
						    bg_info [ _table ] [ bg_player_dice_count ] = _move_result_1 + _move_result_2 ;

						    /*

								смена игрока

							*/


			     			bg_change_player [ _table ] = true ;
						}
						else if ( bg_info [ _table ] [ bg_dice ] [ 2 ] && bg_info [ _table ] [ bg_dice ] [ 3 ] )
						{
							if ( j - _slot_nard != bg_info [ _table ] [ bg_dice ] [ 0 ] &&
								 j - _slot_nard != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 2 ) - bg_info [ _table ] [ bg_player_dice_count ] &&
								 j - _slot_nard != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 3 ) - bg_info [ _table ] [ bg_player_dice_count ] &&
								 j - _slot_nard != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 4 ) - bg_info [ _table ] [ bg_player_dice_count ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (5)" ) ;

						    bg_info [ _table ] [ bg_player_dice_count ] += j - _slot_nard ;

						    /*

								смена игрока

							*/

							if ( bg_info [ _table ] [ bg_player_dice_count ] == bg_info [ _table ] [ bg_dice ] [ 0 ] * 4 )
							{
				     			bg_change_player [ _table ] = true ;
							}
						}
					}
					else
					{
						new _pidorskiy_result = ( 24 - _slot_nard ) + j ;

						if ( bg_info [ _table ] [ bg_player ] [ 0 ] == playerid ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. Тебе нужно заходить в голову." ) ;
						else if ( _pidorskiy_result > 12 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. Тебе нужно заходить в голову." ) ;

					    if ( ! bg_info [ _table ] [ bg_player_dice_count ] )
						{
						    if ( _pidorskiy_result != _move_result_1 &&
								_pidorskiy_result != _move_result_2 &&
								_pidorskiy_result != _move_result_3 &&
								_pidorskiy_result != _move_result_4 &&
								_pidorskiy_result != _move_result_1 + _move_result_2 + _move_result_3 + _move_result_4 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход." ) ;

                            bg_info [ _table ] [ bg_player_dice_count ] = _pidorskiy_result ;
                            bg_used_nard [ playerid ] = -1 ;

                            /*

								смена игрока

							*/

							if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_1 + _move_result_2 )
							{
			     				bg_change_player [ _table ] = true ;
							}
						}
						else if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_1 )
						{
						    if ( _pidorskiy_result != _move_result_2 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход." ) ;

						    bg_info [ _table ] [ bg_player_dice_count ] = _move_result_1 + _move_result_2 ;

							/*

								смена игрока

							*/


			     			bg_change_player [ _table ] = true ;
						}
						else if ( bg_info [ _table ] [ bg_player_dice_count ] == _move_result_2 )
						{
						    if ( _pidorskiy_result != _move_result_1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход." ) ;
						    bg_info [ _table ] [ bg_player_dice_count ] = _move_result_1 + _move_result_2 ;

						    /*

								смена игрока

							*/


							bg_change_player [ _table ] = true ;
						}
						else if ( bg_info [ _table ] [ bg_dice ] [ 2 ] && bg_info [ _table ] [ bg_dice ] [ 3 ] )
						{
							if ( _pidorskiy_result != bg_info [ _table ] [ bg_dice ] [ 0 ] &&
								 _pidorskiy_result != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 2 ) - bg_info [ _table ] [ bg_player_dice_count ] &&
								 _pidorskiy_result != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 3 ) - bg_info [ _table ] [ bg_player_dice_count ] &&
								 _pidorskiy_result != ( bg_info [ _table ] [ bg_dice ] [ 0 ] * 4 ) - bg_info [ _table ] [ bg_player_dice_count ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно расчитан ход. (5)" ) ;

						    bg_info [ _table ] [ bg_player_dice_count ] += _pidorskiy_result ;

						    /*

								смена игрока

							*/

							if ( bg_info [ _table ] [ bg_player_dice_count ] == bg_info [ _table ] [ bg_dice ] [ 0 ] * 4 )
							{
				     			bg_change_player [ _table ] = true ;
							}
						}
					}
						
					bg_info [ _table ] [ bg_cell_player ] [ j ] = playerid ;
					    
					//PlayerTextDrawDestroy ( playerid, bg_nard_ptd [ playerid ] [ _td_id ] ) ;
					PlayerTextDrawDestroy ( bg_info [ _table ] [ bg_player ] [ 0 ], bg_nard_ptd [ bg_info [ _table ] [ bg_player ] [ 0 ] ] [ _td_id ] ) ;
					PlayerTextDrawDestroy ( bg_info [ _table ] [ bg_player ] [ 1 ], bg_nard_ptd [ bg_info [ _table ] [ bg_player ] [ 1 ] ] [ _td_id ] ) ;

					/*

						минус слот

					*/
						
					bg_info [ _table ] [ bg_nard_count ] [ _slot_nard ] -- ;
						
					if ( ! bg_info [ _table ] [ bg_nard_count ] [ _slot_nard ] )
					{
					    bg_info [ _table ] [ bg_cell_player ] [ _slot_nard ] = -1 ;
					}
						
					bg_info [ _table ] [ bg_nard_count ] [ j ] ++ ;
					bg_info [ _table ] [ bg_nard_count_id ] [ _td_id ] = bg_info [ _table ] [ bg_nard_count ] [ j ] ;
	                bg_info [ _table ] [ bg_nard_slot ] [ _td_id ] = j ;
						
					/*

						создаём нарду, если уже есть, то в ряд выстраиваем

					*/

				    new _nard_count = 0 ;
				    for ( new q = 0 ; q < bg_info [ _table ] [ bg_nard_count ] [ j ] ; q ++ )
				    {
						if ( q == 0 ) continue ;
						_nard_count += 10 ;
					}

				    for ( new p = 0 ; p < 2 ; p ++ )
					{
					    new player_id = bg_info [ _table ] [ bg_player ] [ p ] ;
					    if ( bg_info [ _table ] [ bg_move ] == bg_info [ _table ] [ bg_player ] [ 0 ] ) bg_nard_ptd [ player_id ] [ _td_id ] = CreatePlayerTextDraw ( player_id, bg_td_pos [ j ] [ 0 ] + _nard_count, bg_td_pos [ j ] [ 1 ], "LD_CHESS:upl" ) ;
						else bg_nard_ptd [ player_id ] [ _td_id ] = CreatePlayerTextDraw ( player_id, bg_td_pos [ j ] [ 0 ] - _nard_count, bg_td_pos [ j ] [ 1 ], "LD_CHESS:up" ) ;
					    PlayerTextDrawTextSize(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 17.0000, 22.0000);
						PlayerTextDrawAlignment(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 1);
						PlayerTextDrawColor(player_id, bg_nard_ptd [ player_id ] [ _td_id ], -1);
						PlayerTextDrawBackgroundColor(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 255);
						PlayerTextDrawFont(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 4);
						PlayerTextDrawSetProportional(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 0);
						PlayerTextDrawSetShadow(player_id, bg_nard_ptd [ player_id ] [ _td_id ], 0);
						PlayerTextDrawSetSelectable(player_id, bg_nard_ptd [ player_id ] [ _td_id ], true);
					}

					PlayerTextDrawShow ( bg_info [ _table ] [ bg_player ] [ 0 ], bg_nard_ptd [ bg_info [ _table ] [ bg_player ] [ 0 ] ] [ _td_id ] ) ;
					PlayerTextDrawShow ( bg_info [ _table ] [ bg_player ] [ 1 ], bg_nard_ptd [ bg_info [ _table ] [ bg_player ] [ 1 ] ] [ _td_id ] ) ;
	                    
	                if ( bg_change_player [ _table ] )
					{
					    new scm_string [ 128 ] ;
					    if ( bg_info [ _table ] [ bg_player ] [ 0 ] == playerid )
						{
							bg_info [ _table ] [ bg_move ] = bg_info [ _table ] [ bg_player ] [ 1 ] ;

							format ( scm_string, sizeof scm_string, "%s закончил(а) ход. Теперь твоя очередь.", p_info [ playerid ] [ name ] ) ;
							SendClientMessage ( bg_info [ _table ] [ bg_player ] [ 1 ], 0xFFCC00FF, scm_string ) ;

							format ( scm_string, sizeof scm_string, "Вы закончили свой ход. Теперь ходит %s.", p_info [ bg_info [ _table ] [ bg_player ] [ 1 ] ] [ name ] ) ;
							SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
						}
						else
						{
							bg_info [ _table ] [ bg_move ] = bg_info [ _table ] [ bg_player ] [ 0 ] ;

							format ( scm_string, sizeof scm_string, "%s закончил(а) ход. Теперь твоя очередь.", p_info [ playerid ] [ name ] ) ;
							SendClientMessage ( bg_info [ _table ] [ bg_player ] [ 0 ], 0xFFCC00FF, scm_string ) ;

							format ( scm_string, sizeof scm_string, "Вы закончили свой ход. Теперь ходит %s.", p_info [ bg_info [ _table ] [ bg_player ] [ 0 ] ] [ name ] ) ;
							SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
						}

						bg_info [ _table ] [ bg_player_dice_count ] = 0 ;
						bg_head_nard [ playerid ] = false ;
						bg_used_nard [ playerid ] = -1 ;
						bg_change_player [ _table ] = false ;
						
						bg_info [ _table ] [ bg_dice ] [ 0 ] =
   						bg_info [ _table ] [ bg_dice ] [ 1 ] =
   						bg_info [ _table ] [ bg_dice ] [ 2 ] =
   						bg_info [ _table ] [ bg_dice ] [ 3 ] = 0 ;
					}
	                break ;
				}
			}
		}
	}
	return 1 ;
}
#endif

CMD:kiss ( playerid, params [ ] )
{
	if ( sscanf ( params, "u", params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /kiss [ид]" ) ;

	if ( ! IsPlayerConnected ( params [ 0 ] ) || playerid == params [ 0 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Неверно указан ID игрока." ) ;

	buyer_id [ playerid ] = params [ 0 ] ;
	seller_id [ params [ 0 ] ] = playerid ;

	new dialog_string [ 50 + MAX_PLAYER_NAME ] ;
	format ( dialog_string, sizeof ( dialog_string  ), "{FFCC00}%s {FFFFFF}предлагает Вам поцеловаться.",
	p_info [ playerid ] [ name ] ) ;
	show_dialog ( params [ 0 ], d_kiss, DIALOG_STYLE_MSGBOX, "{FFCC00}Свадьба", dialog_string, "Согласен", "Отказ" ) ;

	format ( dialog_string, sizeof ( dialog_string  ), "Вы предложили {FFCC00}%s {FFFFFF}поцеловаться.",
	p_info [ params [ 0 ] ] [ name ] ) ;
	SendClientMessage ( playerid, -1, dialog_string ) ;
	return 1 ;
}

SetPosInFrontOfPlayer ( playerid, target_id, Float: distance )
{
	new Float: x, Float: y, Float: z, Float: a ;
	GetPlayerPos ( playerid, x, y, z ) ;
	GetPlayerFacingAngle ( playerid, a ) ;
	x += ( distance * floatsin(-a, degrees) ) ;
	y += ( distance * floatcos(-a, degrees) ) ;
	SetPlayerPos ( target_id, x, y, z ) ;
	SetPlayerFacingAngle ( target_id, a ) ;
}

public OnPlayerEnterVehicle ( playerid, vehicleid, ispassenger)
{
	veh_info [ vehicleid - 1 ] [ v_driver ] = playerid ;
	return 1 ;
}

public OnPlayerExitVehicle ( playerid, vehicleid )// Taxi
{
	if ( player_rentcar [ playerid ] != INVALID_PLAYER_ID )
	{
		new _b_id = veh_info [ vehicleid - 1 ] [ v_owner ] ;
	    new sum = floatround ( ( veh_info [ vehicleid - 1 ] [ v_millage ] - p_t_info [ playerid ] [ pTaxiStart ] ) * b_info [ _b_id - 1 ] [ b_taxi_fare ] ) ;

		new td_string [ 24 ] ;
		format ( td_string, sizeof ( td_string ), "~w~%d$", sum ) ;
		GameTextForPlayer ( playerid, td_string, 300, 4 ) ;
		
		give_money ( playerid, -sum ) ;
	}
	
    if ( veh_info [ vehicleid - 1 ] [ v_type ] == vehicle_type_taxi )
	{
		if ( veh_info [ vehicleid - 1 ] [ v_driver ] != INVALID_PLAYER_ID )
		{
		    new driver_id = veh_info [ vehicleid - 1 ] [ v_driver ] ;
		    if ( veh_info [ vehicleid - 1 ] [ v_owner ] == p_info [ driver_id ] [ job ] && ! p_t_info [ driver_id ] [ taxi_assement ] )
		    {
		        p_t_info [ driver_id ] [ taxi_assement ] = 60 ;
		        p_info [ driver_id ] [ taxi_cooldown ] = 300 ;
		        
		        p_info [ playerid ] [ taxi_skill ] ++ ;
		        update_int_sql ( playerid, "u_taxi_skill", p_info [ playerid ] [ taxi_skill ] ) ;
		        
		        new _b_id = p_info [ driver_id ] [ job ] ;
		        b_info [ _b_id - 1 ] [ b_taxi_licenses ] ++ ;
		        
		        if ( b_info [ _b_id - 1 ] [ b_taxi_licenses ] == 100 && b_info [ _b_id - 1 ] [ b_taxi_level ] != max_taxi_level )
		        {
		            b_info [ _b_id - 1 ] [ b_taxi_level ] ++ ;
		            b_info [ _b_id - 1 ] [ b_taxi_licenses ] = 0 ;
		            
		            new _pl_id ;
					sscanf ( b_info [ _b_id - 1 ] [ b_owner_name ], "u", _pl_id ) ;

					if ( IsPlayerConnected ( _pl_id ) )
					{
					    new scm_string [ 89 + 4 ] ;
						format ( scm_string, sizeof scm_string, "У Вашего трахопарка повысился уровень! Теперь Вам доступен автопарк из %d автомобилей.", b_info [ _b_id - 1 ] [ b_taxi_level ] ) ;
						SendClientMessage ( _pl_id, 0xFFCC00FF, scm_string ) ;
					}
		        }

		        new _sql_string [ 80 + 4 + 9 ] ;
		        format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_taxi_licenses` = '%d', `b_taxi_level` = '%d' WHERE `b_id` = '%d' LIMIT 1", b_info [ _b_id - 1 ] [ b_taxi_licenses ], b_info [ _b_id - 1 ] [ b_taxi_level ], _b_id ) ;
				mysql_tquery ( sql_connection, _sql_string ) ;
		    }
		}
	}
	
	if ( railway_car [ playerid ] != INVALID_VEHICLE_ID )
	{
	    DestroyVehicle ( railway_car [ playerid ] ) ;
	    railway_car [ playerid ] = INVALID_VEHICLE_ID ;
	}

    veh_info [ vehicleid - 1 ] [ v_driver ] = INVALID_VEHICLE_ID ;
	return 1 ;
}

CMD:binvite ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ business ] == -1 && p_info [ playerid ] [ deputy ] == -1 ) return SendClientMessage(playerid, 0xFF6600FF, !"У Вас нет бизнеса или Вы не являетесь менеджером.");

    new _b_id ;
	if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
	else _b_id = p_info [ playerid ] [ business ] ;
			
 	if ( sscanf(params, "ud", params [ 0 ] ) ) return SendClientMessage(playerid, 0xFF6600FF, !"Используйте: /binvite [id/имя]" ) ;

  	if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок не найден." ) ;
	if ( params [ 0 ] == playerid ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не можете применить это к самому себе." ) ;
	if ( p_info [ params [ 0 ] ] [ level ] < 2 )return SendClientMessage(playerid, 0xFF6600FF, !"Принимать можно игроков, которые достигли 2 лвл.");
	if ( p_info [ params [ 0 ] ] [ business ] != -1 )return SendClientMessage(playerid, 0xFF6600FF, !"Игрок является владельцем бизнеса.");
	if ( p_info [ params [ 0 ] ] [ deputy ] != -1 || p_info [ params [ 0 ] ] [ job ] != job_none )return SendClientMessage(playerid, 0xFF6600FF, !"Игрок уже является сотрудником.");
	if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( params [ 0 ] ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок слишком далеко." ) ;

    new _t_string [ 138 ] ;
    format(_t_string,sizeof(_t_string), "Вы предложили {99cc00}%s {FFCC00}работу в %s",p_info [ params [ 0 ] ] [ name ], b_info [ _b_id - 1 ] [ b_name ] ) ;
    SendClientMessage ( playerid, 0xFFCC00FF, _t_string ) ;

    format ( _t_string, sizeof ( _t_string ),"{FFFFFF}%s предлагает Вам работу в %s.\n\n{AA3333}* {828282}Вы согласны устроиться?", p_info [ playerid ] [ name ], b_info [ _b_id - 1 ] [ b_name ] ) ;
    show_dialog ( params [ 0 ], d_business_invite, DIALOG_STYLE_MSGBOX, "{FFCC00}Устройство на работу", _t_string, "Да", "Нет" ) ;

    buyer_id [ playerid ] = params [ 0 ] ;
	seller_id [ params [ 0 ] ] = playerid ;
    return 1 ;
}

CMD:buninvite ( playerid, params [ ] )
{
    if ( p_info [ playerid ] [ business ] == -1 && p_info [ playerid ] [ deputy ] == -1 ) return SendClientMessage(playerid, 0xFF6600FF, !"У Вас нет бизнеса или Вы не являетесь менеджером.");
    if ( sscanf(params, "us[32]", params [ 0 ], params [ 1 ] ) )return SendClientMessage(playerid, 0xFF6600FF, !"Используйте: /buninvite [id] [причина]" ) ;

    new _b_id ;
	if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
	else _b_id = p_info [ playerid ] [ business ] ;

 	if ( ! IsPlayerConnected ( params [ 0 ] ) )
	 	return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок не найден." ) ;
	if ( params [ 0 ] == playerid )
		return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не можете применить это к самому себе." ) ;
	if ( strlen ( params [ 1 ] ) < 3 || strlen ( params [ 1 ] ) > 32 )
		return SendClientMessage ( playerid, 0xFF6600FF, !"Причина должна содержать от 3 до 32 символов." ) ;
		
	if ( p_info [ playerid ] [ deputy ] != -1 )
	{
    	if ( p_info [ params [ 0 ] ] [ business ] == p_info [ playerid ] [ deputy ] )return SendClientMessage(playerid, 0xFF6600FF, !"Игрок является владельцем бизнеса.");
		if ( p_info [ params [ 0 ] ] [ job ] != p_info [ playerid ] [ deputy ] )return SendClientMessage(playerid, 0xFF6600FF, !"Игрок не является сотрудником Вашего предприятия.");
	}
	else if ( p_info [ playerid ] [ business ] != -1 )
	{
		if ( p_info [ params [ 0 ] ] [ job ] != p_info [ playerid ] [ business ] )return SendClientMessage(playerid, 0xFF6600FF, !"Игрок не является сотрудником Вашего предприятия.");

        if ( p_info [ params [ 0 ] ] [ deputy ] != -1 )
		{
		    format ( b_info [ _b_id - 1 ] [ b_deputy ], MAX_PLAYER_NAME, "none" ) ;
		    
			p_info [ params [ 0 ] ] [ deputy ] = -1 ;
			update_int_sql ( params [ 0 ], "u_deputy", p_info [ params [ 0 ] ] [ deputy ] ) ;

	        new _sql_string [ 72 + MAX_PLAYER_NAME + 9 ] ;
	        format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_deputy` = '-1' WHERE `b_id` = '%d' LIMIT 1", _b_id ) ;
			mysql_tquery ( sql_connection, _sql_string ) ;
		}
	}
	
    new _t_string [ 144 ];
    format ( _t_string, sizeof ( _t_string ), "Вы уволили {99cc00}%s {FFCC00}с работы в '%s'.", p_info [ params [ 0 ] ] [ name ], params [ 1 ], b_info [ _b_id - 1 ] [ b_name ] ) ;
    SendClientMessage ( playerid, 0xFFCC00FF, _t_string ) ;

	p_info [ params [ 0 ] ] [ job ] = job_none ;
	update_int_sql ( params [ 0 ], "u_job", p_info [ params [ 0 ] ] [ job ] ) ;
    return 1;
}

forward callback_offtaxi ( playerid ) ;
public callback_offtaxi ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		SendClientMessage ( playerid, 0xFF6600FF, !"Игроки с данными параметрами не найдены." ) ;
		callcmd::bpanel1 ( playerid ) ;
		page_count [ playerid ] = 0 ;
		return 1 ;
	}
	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = rows ;

	global_string [ 0 ] = EOS ;
	new line_string [ MAX_PLAYER_NAME + 128 ],
		pl_ofm_name [ 24 ], pl_ofm_online [ 16 ], row_count ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
		if ( i >= rows ) break ;

		cache_get_field_content ( i, "u_name", pl_ofm_name, sql_connection, 24 ) ;
		new u_id = cache_get_field_content_int ( i, "u_id", sql_connection ) ; // edit 123
		new u_online = cache_get_field_content_int ( i, "u_online", sql_connection ) ; // edit 123
		
		SetPlayerListitemValue ( playerid, i - rows_list * 10, u_id ) ; // edit 123

		new pvar_string [ 8 ] ;
		format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", i - rows_list * 10 ) ;
		SetPVarString ( playerid, pvar_string, pl_ofm_name ) ;

		if ( u_online == 1 ) format ( pl_ofm_online, sizeof pl_ofm_online, "Сейчас играет" ) ; // edit 123
		else format ( pl_ofm_online, sizeof pl_ofm_online, "Не в сети" ) ;

		format ( line_string, sizeof ( line_string ), "%s - %s\n", pl_ofm_name, pl_ofm_online ) ;
		strcat ( global_string, line_string ) ;

		row_count ++ ;
	}

	if ( rows_list > 0 )
	{
		strcat ( global_string, "{FFCC00}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < rows )
	{
		strcat ( global_string, "{FFCC00}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}

	show_dialog ( playerid, d_offmembers_list, DIALOG_STYLE_LIST, "{FFCC00}Члены компании оффлайн", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

forward callback_offtaxi_info ( playerid ) ;
public callback_offtaxi_info ( playerid )
{
	new rows, fields;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		new pl_day_money, pl_week_money, pl_month_money, pl_all_money, Float: pl_milleage, pl_taxi_order ;

        pl_day_money = cache_get_field_content_int ( 0, "u_day_money", sql_connection ) ;
        pl_week_money = cache_get_field_content_int ( 0, "u_week_money", sql_connection ) ;
        pl_month_money = cache_get_field_content_int ( 0, "u_month_money", sql_connection ) ;
        pl_all_money = cache_get_field_content_int ( 0, "u_all_money", sql_connection ) ;
		pl_milleage = cache_get_field_content_float ( 0, "u_millage", sql_connection ) ;
		pl_taxi_order = cache_get_field_content_int ( 0, "u_taxi_order", sql_connection ) ;

		new pvar_string [ 38 ], pl_name [ MAX_PLAYER_NAME ] ;
		format ( pvar_string, sizeof ( pvar_string ), "ofm_%d", GetPVarInt ( playerid, "ofm_listitem" ) ) ;
		GetPVarString ( playerid, pvar_string, pl_name, MAX_PLAYER_NAME ) ;

		new dialog_string [ 286 ] ;
		format ( dialog_string, sizeof ( dialog_string ), "{FFFFFF}Имя: {FFCC00}%s{FFFFFF}\n\
															Проехал км за время работы: {FFCC00}%.1f{FFFFFF}\n\
															Принял заказов за всё время: {FFCC00}%d шт.{FFFFFF}\n\
															Заработал за сегодняшний день: {FFCC00}%d${FFFFFF}\n\
															Заработал за неделю: {FFCC00}%d${FFFFFF}\n\
															Заработал за месяц: {FFCC00}%d${FFFFFF}\n\
															Заработал за всё время: {FFCC00}%d${FFFFFF}",
		pl_name, pl_milleage, pl_taxi_order, pl_day_money, pl_week_money, pl_month_money, pl_all_money ) ;
		show_dialog ( playerid, d_offmembers_pl_menu1, DIALOG_STYLE_MSGBOX, "{FFCC00}Информация об игроке", dialog_string, "Назад", "" ) ;
	}
	if ( ! rows )
	{
	    new _b_id ;
		if ( p_info [ playerid ] [ deputy ] != -1 ) _b_id = p_info [ playerid ] [ deputy ] ;
		else _b_id = p_info [ playerid ] [ business ] ;
	
	    new query_string [ 52 + 9 ] ;
		mysql_format ( sql_connection, query_string, sizeof query_string, "SELECT `u_name` FROM `users` WHERE `u_job` = '%d'", _b_id ) ;
		mysql_tquery ( sql_connection, query_string, "callback_offtaxi", "i", playerid ) ;

	}
	return 1 ;
}

CMD:test_bizz ( playerid, params [ ] )
{
    if ( sscanf ( params, "ud", params [ 0 ], params [ 1 ] ) )return SendClientMessage(playerid, 0xFF6600FF, !"Используйте: /test_bizz [id] [bizz]" ) ;
    p_info [ params [ 0 ] ] [ business ] = params [ 1 ] ;
	give_money ( params [ 0 ], 5000000 ) ;
	give_owner_job ( params [ 0 ], params [ 1 ] ) ;
	return 1 ;
}

stock give_owner_job ( playerid, _b_id ) // привязка работы владельцу бизнеса
{
	p_info [ playerid ] [ job ] = _b_id ;
	update_int_sql ( playerid, "u_job", p_info [ playerid ] [ job ] ) ;
	return 1 ;
}

stock _quit_job ( playerid )
{
	if ( p_info [ playerid ] [ deputy ] != -1 )
	{
		p_info [ playerid ] [ deputy ] = -1 ;
		update_int_sql ( playerid, "u_deputy", p_info [ playerid ] [ deputy ] ) ;

		new _sql_string [ 72 + MAX_PLAYER_NAME + 9 ] ;
	    format ( _sql_string, sizeof _sql_string, "UPDATE `users` SET `u_deputy` = '-1' WHERE `u_name` = '%s' LIMIT 1", b_info [ p_info [ playerid ] [ deputy ] ] [ b_deputy ] ) ;
		mysql_tquery ( sql_connection, _sql_string ) ;
	}
	return 1 ;
}

CMD:gotaxi ( playerid )
{
	if ( GetPlayerVehicleID ( playerid ) == 0 ) return 1 ;
	if ( veh_info [ GetPlayerVehicleID ( playerid ) - 1 ] [ v_type ] != vehicle_type_taxi ) return 1 ;
	
	global_string [ 0 ] = EOS ;
	new line_string [ 100 ], row_count = 0 ;
	for ( new i = 0 ; i < 3 ; i ++ )
	{
		if ( p_info [ playerid ] [ taxi_accept ] [ i ] == true )
		{
		    new _random = p_info [ playerid ] [ taxi_actor_id ] [ i ] ;
		    format ( line_string, sizeof line_string, "%d. %s, дистанция: %.1f\n", row_count + 1, actor_name [ p_info [ playerid ] [ taxi_actor_name ] [ i ] ], get_distance_point_to_point ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], actor_pos [ _random ] [ 0 ], actor_pos [ _random ] [ 1 ], actor_pos [ _random ] [ 2 ] ) ) ;
		    strcat ( global_string, line_string ) ;

		    SetPlayerListitemValue ( playerid, row_count, 1000 + i ) ;

		    row_count ++ ;
		}
	}
	foreach(new i: logged_players)
	{
		if ( row_count > 20 ) break ; // fix123
	    if ( call_taxi { i } != 1 ) continue ;
	    format ( line_string, sizeof line_string, "%d. %s, дистанция: %.1f\n", row_count + 1, p_info [ i ] [ name ], GetPlayerDistanceFromPoint ( i, p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ] ) ) ;
	    strcat ( global_string, line_string ) ;
	    
	    SetPlayerListitemValue ( playerid, row_count, i ) ;

	    row_count ++ ;
	}
	if ( ! row_count ) return SendClientMessage ( playerid, 0xFF6600FF, !"В данный момент нет заказов." ) ;
	show_dialog ( playerid, d_taxi_panel, DIALOG_STYLE_LIST, "{FFCC00}Вызовы", global_string, "Принять", "Назад" ) ;
	return 1 ;
}

CMD:service ( playerid )
{
    show_dialog ( playerid, d_service_taxi, DIALOG_STYLE_INPUT, "{FFCC00}Вызвать такси", "{FFFFFF}Опишите место где вы находитесь\n{828282}* Сообщение должно состоять из 6 до 20 символов.", "Принять", "Назад");
	return 1 ;
}

CMD:test_pizdec ( playerid )
{
    p_info [ playerid ] [ taxi_cooldown ] = 290 ;
	return 1 ;
}

CMD:invitewedding ( playerid, params [ ] )// marriage
{
	if ( ! p_info [ playerid ] [ marriage_today ] ) return SendClientMessage(playerid, 0xFF6600FF, !"У Вас нет заявки на бракосочетание." ) ;
	if ( sscanf ( params, "u", params [ 0 ] ) )return SendClientMessage(playerid, 0xFF6600FF, !"Используйте: /invitewedding [id]" ) ;

    if ( ! IsPlayerConnected ( params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок не найден." ) ;
	if ( params [ 0 ] == playerid ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не можете применить это к самому себе." ) ;
	if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( params [ 0 ] ) != GetPlayerVirtualWorld ( playerid ) )return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок слишком далеко." ) ;

    new _t_string [ 74 + MAX_PLAYER_NAME ] ;
    format ( _t_string, sizeof ( _t_string ), "Вы пригласили {99cc00}%s {FFCC00}на Вашу свадьбу.", p_info [ params [ 0 ] ] [ name ] ) ;
    SendClientMessage ( playerid, 0xFFCC00FF, _t_string ) ;

    format ( _t_string, sizeof ( _t_string ),"{FFFFFF}%s приглашает Вас на свадьбу.\n\n{AA3333}* {828282}Вы согласны?", p_info [ playerid ] [ name ] ) ;
    show_dialog ( params [ 0 ], d_wedding_invite, DIALOG_STYLE_MSGBOX, "{FFCC00}Приглашение", _t_string, "Да", "Нет" ) ;

    buyer_id [ playerid ] = params [ 0 ] ;
	seller_id [ params [ 0 ] ] = playerid ;
	return 1 ;
}

stock _CreateDynamicPickup ( modelid, type, Float:x, Float:y, Float:z, worldid = -1, interiorid = -1, playerid = -1, Float:streamdistance = 200.0 )
{
	new pickupid = CreateDynamicPickup ( modelid, type, x, y, z, worldid, interiorid, playerid, streamdistance ) ;

	pick_info [ pickupid ] [ pick_pos ] [ 0 ] = x ;
	pick_info [ pickupid ] [ pick_pos ] [ 1 ] = y ;
	pick_info [ pickupid ] [ pick_pos ] [ 2 ] = z ;

	return pickupid ;
}
#define CreateDynamicPickup _CreateDynamicPickup

CMD:test_sex ( playerid, params [ ] )
{
    if ( sscanf ( params, "ud", params [ 0 ], params [ 1 ] ) )return SendClientMessage(playerid, 0xFF6600FF, !"Используйте: /test_sex [id] [0-1]" ) ;
    p_info [ params [ 0 ] ] [ sex ] = params [ 1 ] ;
	return 1 ;
}

forward prist_timer ( playerid, target_id, prist_id ) ;// marriage
public prist_timer ( playerid, target_id, prist_id )
{
	if ( ! IsPlayerConnected ( playerid ) ) // fix123
	{
		TogglePlayerControllable ( target_id, true ) ;
		TogglePlayerControllable ( prist_id, true ) ;
			
		KillTimer ( prist_time ) ;
		prist_time = -1 ;
			
		prist_text_id = 0 ;
			
		marriage_start = 0 ;
		SendClientMessage ( target_id, 0xFF6600FF, "Жених покинул игру, свадьба прервана." ) ;
		SendClientMessage ( prist_id, 0xFF6600FF, !"Жених покинул игру, свадьба прервана." ) ;
		return 1 ;
	}
		
	else if ( ! IsPlayerConnected ( target_id ) )
	{
		TogglePlayerControllable ( playerid, true ) ;
		TogglePlayerControllable ( prist_id, true ) ;
			
		KillTimer ( prist_time ) ;
		prist_time = -1 ;
			
		prist_text_id = 0 ;
			
		marriage_start = 0 ;
		SendClientMessage ( playerid, 0xFF6600FF, !"Невеста покинула игру, свадьба прервана." ) ;
		SendClientMessage ( prist_id, 0xFF6600FF, !"Невеста покинула игру, свадьба прервана." ) ;
		return 1 ;
	}
		
	else if ( ! IsPlayerConnected ( prist_id ) )
	{
		TogglePlayerControllable ( playerid, true ) ;
		TogglePlayerControllable ( target_id, true ) ;
			
		KillTimer ( prist_time ) ;
		prist_time = -1 ;
			
		prist_text_id = 0 ;
			
		marriage_start = 0 ;
		SendClientMessage ( playerid, 0xFF6600FF, !"Священник покинул игру, свадьба прервана." ) ;
		SendClientMessage ( target_id, 0xFF6600FF, !"Священник покинула игру, свадьба прервана." ) ;
		return 1 ;
	}

	if ( prist_text_id == 0 )
	{
	    OnPlayerText ( prist_id, "В этот святой день сами ангелы спустились с небес, чтобы благословить этот брак." ) ;

	    prist_text_id ++ ;
	}
	else if ( prist_text_id == 1 )
	{
	    OnPlayerText ( prist_id, "Жених, согласны ли Вы быть в счастье и радости, горе и печали с невестой?" ) ;
	    SendClientMessage ( playerid, 0xFF6600FF, !"Напишите 'Да' в чат в знак согласия." ) ;

	    prist_text_id ++ ;
	}
	else if ( prist_text_id == 2 )
	{
	    if ( ! prist_success ) return 1 ;
	
	    OnPlayerText ( prist_id, "Невеста, согласны ли Вы быть в счастье и радости, горе и печали с женихом?" ) ;
	    SendClientMessage ( target_id, 0xFF6600FF, "Напишите 'Да' в чат в знак согласия." ) ;

        prist_success = 0 ;
	    prist_text_id ++ ;
	}
	else if ( prist_text_id == 3 )
	{
	    if ( ! prist_success ) return 1 ;

        OnPlayerText ( prist_id, "Данной мне властью священными узами брака.." ) ;

        prist_success = 0 ;
	    prist_text_id ++ ;
	}
	else if ( prist_text_id == 4 )
	{
	    OnPlayerText ( prist_id, "Объявляю Вас мужем и женой." ) ;
	    p_info [ prist_id ] [ salary ] += 5000 ;
        
        SetPosInFrontOfPlayer ( target_id, playerid, 1 ) ;

		new Float: angle ;
		GetPlayerFacingAngle ( target_id, angle ) ;
		SetPlayerFacingAngle ( playerid, 180 + angle ) ;

		ApplyAnimation ( target_id, "BD_FIRE", "GRLFRD_KISS_03", 4.0, 0, 0, 0, 0, 0, 1 ) ;
		ApplyAnimation ( playerid, "BD_FIRE", "PLAYA_KISS_03", 4.0, 0,0, 0, 0, 0 ) ;

	    prist_text_id = 0 ;
	    
	    KillTimer ( prist_time ) ;
	    prist_time = -1 ;
	    
	    p_info [ playerid ] [ marriage_today ] =
	    p_info [ target_id ] [ marriage_today ] = 0 ;
	    
	    TogglePlayerControllable ( playerid, true ) ;
	    TogglePlayerControllable ( target_id, true ) ;
	    TogglePlayerControllable ( prist_id, true ) ;
	    
	    new scm_all_string [ 35 + ( MAX_PLAYER_NAME * 2 ) ] ;
		format ( scm_all_string, sizeof scm_all_string, "%s и %s поженились, поздравляем!", p_info [ playerid ] [ name ], p_info [ target_id ] [ name ] ) ;
		SendClientMessageToAll ( 0x14A3FFFF, scm_all_string ) ;

		p_info [ playerid ] [ marriage ] = p_info [ target_id ] [ id ] ;
		p_info [ target_id ] [ marriage ] = p_info [ playerid ] [ id ] ;
		
		format ( p_info [ playerid ] [ marriage_name ], MAX_PLAYER_NAME, "%s", p_info [ target_id ] [ name ] ) ;
		format ( p_info [ target_id ] [ marriage_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
		
		new sql_string [ 144 ] ;
		format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_marriage` = '%d', `u_marriage_name` = '%s' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ marriage ], p_info [ playerid ] [ marriage_name ], p_info [ playerid ] [ id ] ) ;
		mysql_tquery ( sql_connection, sql_string, "", "" ) ;

		format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_marriage` = '%d', `u_marriage_name` = '%s' WHERE `u_id` = '%d' LIMIT 1", p_info [ target_id ] [ marriage ], p_info [ target_id ] [ marriage_name ], p_info [ target_id ] [ id ] ) ;
		mysql_tquery ( sql_connection, sql_string, "", "" ) ;
		
		marriage_start = 0 ;
	}
	return 1 ;
}

public OnPlayerText ( playerid, text [ ] )// marriage
{
	if ( used_area [ playerid ] == marriage_area )
	{
		if ( p_info [ playerid ] [ marriage_today ] )
		{
		    if ( ! p_info [ playerid ] [ sex ] )
			{
				if ( GetString ( text, "Да" ) || GetString ( text, "да" ) ) prist_success = 1 ;
			}
			else if ( p_info [ playerid ] [ sex ] )
			{
				if ( GetString ( text, "Да" ) || GetString ( text, "да" ) ) prist_success = 1 ;
			}
		}
	}
	return 1 ;
}

public OnPlayerStreamIn ( playerid, forplayerid )
{
	Iter_Add(streamed_players[forplayerid], playerid ) ;
	return 1 ;
}

public OnPlayerStreamOut ( playerid, forplayerid )
{
	Iter_Remove(streamed_players[forplayerid], playerid ) ;
	return 1 ;
}

/*

CMD:lock ( playerid )
{
	if ( IsValidVehicle ( GetPlayerVehicleID ( playerid ) ) )
	{
		new veh_id = GetPlayerVehicleID ( playerid ) ;

        if ( p_info [ playerid ] [ marriage ] != -1 )
		{
		    new _pl_id ;
			sscanf ( p_info [ playerid ] [ marriage_name ], "u", _pl_id ) ;
		    if ( IsPlayerConnected ( _pl_id ) )
		    {
		        foreach(new vehicle_id: player_vehicles[_pl_id])
				{
				    if ( vehicle_id != veh_id ) continue ;

					PlayerPlaySound ( playerid, 1145, 0.0, 0.0, 0.0 ) ;

					toggle_locked ( playerid, veh_id ) ;
					return 1 ;
				}
		    }
		}

		if ( ( veh_info [ veh_id - 1 ] [ v_type ] != vehicle_type_player || veh_info [ veh_id - 1 ] [ v_owner ] != p_info [ playerid ] [ id ] ) && p_t_info [ playerid ] [ v_key ] != veh_id )return SendClientMessage ( playerid, col_gray, "{"#cRInfo"}* {"#cGRInfo"}У вас нет ключей от данного транспорта." ) ;
		PlayerPlaySound ( playerid, 1145, 0.0, 0.0, 0.0 ) ;

		toggle_locked ( playerid, veh_id ) ;
		return 1 ;
	}
	else
	{
	    if ( p_info [ playerid ] [ marriage ] != -1 )
		{
		    new _pl_id ;
			sscanf ( p_info [ playerid ] [ marriage_name ], "u", _pl_id ) ;
		    if ( IsPlayerConnected ( _pl_id ) )
		    {
		        foreach(new veh_id: player_vehicles[_pl_id])
				{
					if ( v_boat ( veh_id ) )
					{
						if ( ! IsVehicleInRangeOfPoint ( veh_id, 5.0, pl_pos_x, pl_pos_y, pl_pos_z ) ) continue ;
						PlayerPlaySound ( playerid, 1145, 0.0, 0.0, 0.0 ) ;

						toggle_locked ( playerid, veh_id ) ;
						return 1 ;
					}
					else
					{
						if ( ! IsVehicleInRangeOfPoint ( veh_id, 2.5, pl_pos_x, pl_pos_y, pl_pos_z ) ) continue ;
						PlayerPlaySound ( playerid, 1145, 0.0, 0.0, 0.0 ) ;

						toggle_locked ( playerid, veh_id ) ;
						return 1 ;
					}
				}
		    }
		}
	}
	return 1 ;
}

stock OnPlayerSpawn ( playerid )// marriage
{
    if ( p_info [ playerid ] [ marriage ] != -1 && p_info [ playerid ] [ spawnchange ] == 15 )
	{
	    new _owner_id = p_info [ playerid ] [ marriage ] ;
	    for ( new i = 0 ; i < MAX_HOUSES ; i ++ )
		{
		    if ( h_info [ i ] [ h_owner ] != _owner_id ) continue ;
			new hint = h_info [ i ] [ h_int ] - 1 ;

			set_pos ( playerid, house_int [ hint ] [ hspawn_position ] [ 0 ], house_int [ hint ] [ hspawn_position ] [ 1 ], house_int [ hint ] [ hspawn_position ] [ 2 ], house_int [ hint ] [ hspawn_position ] [ 3 ], house_int [ hint ] [ hint_int ], h_info [ i ] [ h_id ] ) ;
			SetPVarInt ( playerid, "house_id", h_info [ i ] [ h_id ] ) ;
			break ;
		}
		return 1 ;
	}
	return 1 ;
}*/

stock show_roulette_ptd ( playerid, bool: status )
{
	if ( status )
	{
 		roulette_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 531.5999, 187.0554, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][0], 12.0000, 14.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][0], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][0], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][0], 0);

		roulette_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 531.5999, 197.6560, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][1], 12.0000, 14.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][1], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][1], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][1], 0);

		roulette_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 538.4666, 189.4293, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][2], 105.0000, 20.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][2], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][2], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][2], 0);

		roulette_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 536.7998, 189.6999, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX~N~XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX~N~XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); // пусто
		PlayerTextDrawLetterSize(playerid, roulette_ptd[playerid][3], 0.1430, 0.6291);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][3], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][3], 235802155);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][3], 1);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][3], 1);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][3], 0);

		roulette_ptd[playerid][4] = CreatePlayerTextDraw(playerid, 533.3999, 193.5776, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][4], 114.0000, 9.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][4], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][4], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][4], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][4], 0);

		roulette_ptd[playerid][5] = CreatePlayerTextDraw(playerid, 531.4666, 186.2259, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][5], 12.0000, 14.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][5], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][5], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][5], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][5], 0);

		roulette_ptd[playerid][6] = CreatePlayerTextDraw(playerid, 531.4666, 196.8265, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][6], 12.0000, 14.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][6], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][6], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][6], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][6], 0);

		roulette_ptd[playerid][7] = CreatePlayerTextDraw(playerid, 538.3333, 188.5997, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][7], 105.0000, 20.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][7], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][7], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][7], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][7], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][7], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][7], 0);

		roulette_ptd[playerid][8] = CreatePlayerTextDraw(playerid, 565.9995, 172.3592, "particle:lamp_shad_64"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][8], 124.0000, 16.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][8], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][8], -5963727);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][8], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][8], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][8], 0);

		roulette_ptd[playerid][9] = CreatePlayerTextDraw(playerid, 565.9995, 190.1963, "particle:lamp_shad_64"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][9], 124.0000, -17.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][9], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][9], -5963727);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][9], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][9], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][9], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][9], 0);

		roulette_ptd[playerid][10] = CreatePlayerTextDraw(playerid, 634.6666, 194.4073, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][10], 1.0000, 8.1499);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][10], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][10], -1061109505);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][10], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][10], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][10], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][10], 0);

		roulette_ptd[playerid][11] = CreatePlayerTextDraw(playerid, 636.0000, 175.8963, "$0"); // пусто
		PlayerTextDrawLetterSize(playerid, roulette_ptd[playerid][11], 0.1729, 1.0814);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][11], 3);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][11], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][11], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][11], 2);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][11], 1);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][11], 0);

		roulette_ptd[playerid][12] = CreatePlayerTextDraw(playerid, 539.5003, 194.6777, "PRESS_TO_ENTER_BETS.."); // пусто
		PlayerTextDrawLetterSize(playerid, roulette_ptd[playerid][12], 0.1550, 0.7993);
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][12], 650.0000, 10.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][12], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][12], -1061109505);
		PlayerTextDrawUseBox(playerid, roulette_ptd[playerid][12], 1);
		PlayerTextDrawBoxColor(playerid, roulette_ptd[playerid][12], 0);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][12], 59);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][12], 1);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][12], 1);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][12], 1);
		PlayerTextDrawSetSelectable(playerid, roulette_ptd[playerid][12], true);

		roulette_ptd[playerid][13] = CreatePlayerTextDraw(playerid, 21.9999, 154.1401, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][13], 67.0000, 89.4298);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][13], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][13], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][13], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][13], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][13], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][13], 0);

		roulette_ptd[playerid][14] = CreatePlayerTextDraw(playerid, 15.0998, 229.5538, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][14], 13.0000, 17.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][14], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][14], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][14], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][14], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][14], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][14], 0);

		roulette_ptd[playerid][15] = CreatePlayerTextDraw(playerid, 83.0665, 229.5538, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][15], 13.0000, 17.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][15], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][15], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][15], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][15], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][15], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][15], 0);

		roulette_ptd[playerid][16] = CreatePlayerTextDraw(playerid, 21.9999, 153.0402, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][16], 67.0000, 89.4298);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][16], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][16], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][16], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][16], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][16], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][16], 0);

		roulette_ptd[playerid][17] = CreatePlayerTextDraw(playerid, 15.0998, 228.4537, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][17], 13.0000, 17.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][17], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][17], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][17], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][17], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][17], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][17], 0);

		roulette_ptd[playerid][18] = CreatePlayerTextDraw(playerid, 83.0665, 228.4537, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][18], 13.0000, 17.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][18], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][18], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][18], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][18], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][18], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][18], 0);

		roulette_ptd[playerid][19] = CreatePlayerTextDraw(playerid, 15.0998, 150.3513, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][19], 13.0000, 17.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][19], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][19], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][19], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][19], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][19], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][19], 0);

		roulette_ptd[playerid][20] = CreatePlayerTextDraw(playerid, 83.0665, 150.3513, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][20], 13.0000, 17.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][20], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][20], 437918462);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][20], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][20], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][20], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][20], 0);

		roulette_ptd[playerid][21] = CreatePlayerTextDraw(playerid, 17.2665, 158.8365, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][21], 76.5496, 78.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][21], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][21], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][21], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][21], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][21], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][21], 0);

		roulette_ptd[playerid][22] = CreatePlayerTextDraw(playerid, 15.3332, 185.2328, "particle:lamp_shad_64"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][22], 82.0000, 57.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][22], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][22], -5963727);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][22], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][22], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][22], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][22], 0);

		roulette_ptd[playerid][23] = CreatePlayerTextDraw(playerid, 20.3332, 153.0328, "XXXXXXXXXXXXX~n~XXXXXXXXXXXXX~n~XXXXXXXXXXXXX~n~XXXXXXXXXXXXX~n~XXXXXXXXXXXXX~n~XXXXXXXXXXXXX~n~"); // пусто
		PlayerTextDrawLetterSize(playerid, roulette_ptd[playerid][23], 0.2635, 1.6331);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][23], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][23], 235802131);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][23], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][23], 1);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][23], 1);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][23], 0);

		roulette_ptd[playerid][24] = CreatePlayerTextDraw(playerid, 15.0000, 162.8813, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][24], 6.6500, 8.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][24], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][24], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][24], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][24], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][24], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][24], 0);

		roulette_ptd[playerid][25] = CreatePlayerTextDraw(playerid, 91.6666, 229.0370, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][25], 4.0000, 4.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][25], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][25], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][25], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][25], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][25], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][25], 0);

		roulette_ptd[playerid][26] = CreatePlayerTextDraw(playerid, 45.5998, 208.4622, "LD_BEAT:down"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][26], 20.0000, 24.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][26], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][26], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][26], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][26], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][26], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][26], 0);
		PlayerTextDrawSetSelectable(playerid, roulette_ptd[playerid][26], true);

		roulette_ptd[playerid][27] = CreatePlayerTextDraw(playerid, 25.5998, 186.0625, "LD_BEAT:left"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][27], 20.0000, 24.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][27], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][27], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][27], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][27], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][27], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][27], 0);
		PlayerTextDrawSetSelectable(playerid, roulette_ptd[playerid][27], true);

		roulette_ptd[playerid][28] = CreatePlayerTextDraw(playerid, 65.9332, 186.0625, "LD_BEAT:right"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][28], 20.0000, 24.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][28], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][28], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][28], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][28], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][28], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][28], 0);
		PlayerTextDrawSetSelectable(playerid, roulette_ptd[playerid][28], true);

		roulette_ptd[playerid][29] = CreatePlayerTextDraw(playerid, 45.3334, 163.6622, "LD_BEAT:up"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][29], 20.0000, 24.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][29], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][29], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][29], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][29], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][29], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][29], 0);
		PlayerTextDrawSetSelectable(playerid, roulette_ptd[playerid][29], true);

		roulette_ptd[playerid][30] = CreatePlayerTextDraw(playerid, 532.4669, 189.2147, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][30], 4.0000, 4.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][30], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][30], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][30], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][30], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][30], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][30], 0);

		roulette_ptd[playerid][31] = CreatePlayerTextDraw(playerid, 616.4671, 206.6371, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][31], 3.5299, 4.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][31], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][31], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][31], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][31], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][31], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][31], 0);
		
        roulette_ptd[playerid][32] = CreatePlayerTextDraw(playerid, 571.6668, 219.2963, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][32], 40.0000, 16.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][32], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][32], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][32], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][32], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][32], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][32], 0);

		roulette_ptd[playerid][33] = CreatePlayerTextDraw(playerid, 560.3334, 215.2333, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][33], 21.0000, 24.2599);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][33], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][33], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][33], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][33], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][33], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][33], 0);

		roulette_ptd[playerid][34] = CreatePlayerTextDraw(playerid, 600.6668, 215.2185, "LD_BEAT:chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][34], 21.0000, 24.2599);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][34], 1);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][34], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][34], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][34], 4);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][34], 0);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][34], 0);

		roulette_ptd[playerid][35] = CreatePlayerTextDraw(playerid, 591.3333, 221.5111, "CLOSE"); // пусто
		PlayerTextDrawLetterSize(playerid, roulette_ptd[playerid][35], 0.1660, 1.1312);
		PlayerTextDrawTextSize(playerid, roulette_ptd[playerid][35], 10.0000, 50.0000);
		PlayerTextDrawAlignment(playerid, roulette_ptd[playerid][35], 2);
		PlayerTextDrawColor(playerid, roulette_ptd[playerid][35], 437918463);
		PlayerTextDrawUseBox(playerid, roulette_ptd[playerid][35], 1);
		PlayerTextDrawBoxColor(playerid, roulette_ptd[playerid][35], 0);
		PlayerTextDrawBackgroundColor(playerid, roulette_ptd[playerid][35], 255);
		PlayerTextDrawFont(playerid, roulette_ptd[playerid][35], 2);
		PlayerTextDrawSetProportional(playerid, roulette_ptd[playerid][35], 1);
		PlayerTextDrawSetShadow(playerid, roulette_ptd[playerid][35], 0);
		PlayerTextDrawSetSelectable(playerid, roulette_ptd[playerid][35], true);
		
		for ( new j = 0 ; j < 36 ; j ++ )
		{
		    PlayerTextDrawShow ( playerid, roulette_ptd [ playerid ] [ j ] ) ;
		}
		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    for ( new j = 0 ; j < 36 ; j ++ )
		{
			PlayerTextDrawDestroy ( playerid, roulette_ptd [ playerid ] [ j ] ) ;
			roulette_ptd [ playerid ] [ j ] = PlayerText:-1 ;
		}
		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

stock show_roulette_players ( playerid, _table_id, bool: status )
{
	if ( status )
	{
	    roulette_players_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 217.0000, 16.8666, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][0], 203.0000, 29.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][0], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][0], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][0], 0);

		roulette_players_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 209.0000, 30.0491, "LD_Beat:Chit"); // niz
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][1], 15.0000, 19.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][1], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][1], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][1], 0);

		roulette_players_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 412.6000, 30.0491, "LD_Beat:Chit"); // niz
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][2], 15.0000, 19.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][2], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][2], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][2], 0);

		roulette_players_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 217.0000, 16.0368, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][3], 203.0000, 29.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][3], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][3], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][3], 0);

		roulette_players_ptd[playerid][4] = CreatePlayerTextDraw(playerid, 209.0000, 29.2194, "LD_Beat:Chit"); // niz
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][4], 15.0000, 19.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][4], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][4], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][4], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][4], 0);

		roulette_players_ptd[playerid][5] = CreatePlayerTextDraw(playerid, 412.6000, 29.2194, "LD_Beat:Chit"); // niz
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][5], 15.0000, 19.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][5], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][5], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][5], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][5], 0);

		roulette_players_ptd[playerid][6] = CreatePlayerTextDraw(playerid, 209.0000, 12.9181, "LD_Beat:Chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][6], 15.0000, 19.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][6], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][6], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][6], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][6], 0);

		roulette_players_ptd[playerid][7] = CreatePlayerTextDraw(playerid, 412.6000, 12.9181, "LD_Beat:Chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][7], 15.0000, 19.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][7], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][7], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][7], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][7], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][7], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][7], 0);

		roulette_players_ptd[playerid][8] = CreatePlayerTextDraw(playerid, 211.3665, 22.2590, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][8], 213.7801, 16.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][8], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][8], 437918463);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][8], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][8], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][8], 0);

		roulette_players_ptd[playerid][9] = CreatePlayerTextDraw(playerid, 215.1333, 16.3073, "XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX~N~XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX~N~XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"); // пусто
		PlayerTextDrawLetterSize(playerid, roulette_players_ptd[playerid][9], 0.2888, 1.0275);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][9], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][9], 235802134);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][9], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][9], 1);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][9], 1);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][9], 0);

		roulette_players_ptd[playerid][10] = CreatePlayerTextDraw(playerid, 206.9998, 22.1963, "particle:lamp_shad_64"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][10], 221.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][10], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][10], -5963727);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][10], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][10], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][10], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][10], 0);

		roulette_players_ptd[playerid][11] = CreatePlayerTextDraw(playerid, 420.0000, 12.7185, "LD_Beat:Chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][11], 7.0000, 9.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][11], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][11], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][11], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][11], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][11], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][11], 0);

		roulette_players_ptd[playerid][12] = CreatePlayerTextDraw(playerid, 209.5001, 30.9703, "LD_Beat:Chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][12], 4.6897, 6.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][12], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][12], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][12], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][12], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][12], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][12], 0);

		roulette_players_ptd[playerid][13] = CreatePlayerTextDraw(playerid, 350.8333, 43.0000, "LD_Beat:Chit"); // пусто
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][13], 4.0000, 5.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][13], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][13], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][13], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][13], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][13], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][13], 0);

		roulette_players_ptd[playerid][14] = CreatePlayerTextDraw(playerid, 229.6345, 32.0848, "BERNANDO"); // player 1
		PlayerTextDrawLetterSize(playerid, roulette_players_ptd[playerid][14], 0.1404, 0.9983);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][14], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][14], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][14], 40);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][14], 2);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][14], 1);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][14], 1);

		roulette_players_ptd[playerid][15] = CreatePlayerTextDraw(playerid, 220.8338, 31.3850, "LD_OTB2:Ric5"); // player 1
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][15], 9.0000, 12.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][15], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][15], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][15], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][15], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][15], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][15], 0);

		roulette_players_ptd[playerid][16] = CreatePlayerTextDraw(playerid, 229.6009, 19.2255, "BERNANDO"); // player 2
		PlayerTextDrawLetterSize(playerid, roulette_players_ptd[playerid][16], 0.1404, 0.9983);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][16], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][16], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][16], 40);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][16], 2);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][16], 1);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][16], 1);

		roulette_players_ptd[playerid][17] = CreatePlayerTextDraw(playerid, 220.8002, 18.5256, "LD_OTB2:Ric5"); // player 2
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][17], 9.0000, 12.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][17], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][17], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][17], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][17], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][17], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][17], 0);

		roulette_players_ptd[playerid][18] = CreatePlayerTextDraw(playerid, 306.1672, 32.0848, "BERNANDO"); // player 3
		PlayerTextDrawLetterSize(playerid, roulette_players_ptd[playerid][18], 0.1404, 0.9983);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][18], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][18], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][18], 40);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][18], 2);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][18], 1);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][18], 1);

		roulette_players_ptd[playerid][19] = CreatePlayerTextDraw(playerid, 297.3666, 31.3850, "LD_OTB2:Ric5"); // player 3
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][19], 9.0000, 12.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][19], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][19], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][19], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][19], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][19], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][19], 0);

		roulette_players_ptd[playerid][20] = CreatePlayerTextDraw(playerid, 306.1336, 19.2257, "BERNANDO"); // player 4
		PlayerTextDrawLetterSize(playerid, roulette_players_ptd[playerid][20], 0.1404, 0.9983);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][20], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][20], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][20], 40);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][20], 2);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][20], 1);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][20], 1);

		roulette_players_ptd[playerid][21] = CreatePlayerTextDraw(playerid, 297.3330, 18.5256, "LD_OTB2:Ric5"); // player 4
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][21], 9.0000, 12.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][21], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][21], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][21], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][21], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][21], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][21], 0);

		roulette_players_ptd[playerid][22] = CreatePlayerTextDraw(playerid, 383.8338, 31.7702, "BERNANDO"); // player 5
		PlayerTextDrawLetterSize(playerid, roulette_players_ptd[playerid][22], 0.1404, 0.9983);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][22], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][22], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][22], 40);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][22], 2);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][22], 1);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][22], 1);

		roulette_players_ptd[playerid][23] = CreatePlayerTextDraw(playerid, 375.0332, 31.0701, "LD_OTB2:Ric5"); // player 5
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][23], 9.0000, 12.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][23], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][23], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][23], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][23], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][23], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][23], 0);

		roulette_players_ptd[playerid][24] = CreatePlayerTextDraw(playerid, 383.8002, 18.9108, "BERNANDO"); // player 6
		PlayerTextDrawLetterSize(playerid, roulette_players_ptd[playerid][24], 0.1404, 0.9983);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][24], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][24], -1);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][24], 40);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][24], 2);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][24], 1);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][24], 1);

		roulette_players_ptd[playerid][25] = CreatePlayerTextDraw(playerid, 374.9996, 18.2108, "LD_OTB2:Ric5"); // player 6
		PlayerTextDrawTextSize(playerid, roulette_players_ptd[playerid][25], 9.0000, 12.0000);
		PlayerTextDrawAlignment(playerid, roulette_players_ptd[playerid][25], 1);
		PlayerTextDrawColor(playerid, roulette_players_ptd[playerid][25], -5963521);
		PlayerTextDrawBackgroundColor(playerid, roulette_players_ptd[playerid][25], 255);
		PlayerTextDrawFont(playerid, roulette_players_ptd[playerid][25], 4);
		PlayerTextDrawSetProportional(playerid, roulette_players_ptd[playerid][25], 0);
		PlayerTextDrawSetShadow(playerid, roulette_players_ptd[playerid][25], 0);
		
		for ( new j = 0 ; j < 25 ; j ++ )
		{
		    PlayerTextDrawShow ( playerid, roulette_players_ptd [ playerid ] [ j ] ) ;
		}
		
		new td_string [ MAX_PLAYER_NAME + 2 ] ;
		new _rou_players = 0 ;
		for ( new p = 0 ; p < 6 ; p ++ )
		{
            if ( roulette_players [ _table_id ] [ p ] != INVALID_PLAYER_ID )
            {
                new player_id = roulette_players [ _table_id ] [ p ] ;
		   		format ( td_string, sizeof td_string, "%s", p_info [ player_id ] [ name ] ) ;
			}
			else format ( td_string, sizeof td_string, " " ) ;

			for ( new j = 0 ; j < 6 ; j ++ )
			{
			    if ( roulette_players [ _table_id ] [ j ] != INVALID_PLAYER_ID )
			    {
			        new gambler_id = roulette_players [ _table_id ] [ j ] ;
				    PlayerTextDrawSetString ( gambler_id, roulette_players_ptd [ gambler_id ] [ 14 + _rou_players ], td_string ) ;
			    }
			}
			_rou_players += 2 ;
		}
	}
	else
	{
	    for ( new j = 0 ; j < 25 ; j ++ )
		{
			PlayerTextDrawDestroy ( playerid, roulette_players_ptd [ playerid ] [ j ] ) ;
			roulette_players_ptd [ playerid ] [ j ] = PlayerText:-1 ;
		}
		
		new td_string [ MAX_PLAYER_NAME + 2 ] ;
		new _rou_players = 0 ;
		for ( new p = 0 ; p < 6 ; p ++ )
		{
            if ( roulette_players [ _table_id ] [ p ] != INVALID_PLAYER_ID )
            {
                new player_id = roulette_players [ _table_id ] [ p ] ;
		   		format ( td_string, sizeof td_string, "%s", p_info [ player_id ] [ name ] ) ;
			}
			else format ( td_string, sizeof td_string, " " ) ;

			for ( new j = 0 ; j < 6 ; j ++ )
			{
			    if ( roulette_players [ _table_id ] [ j ] != INVALID_PLAYER_ID )
			    {
			        new gambler_id = roulette_players [ _table_id ] [ j ] ;
				    PlayerTextDrawSetString ( gambler_id, roulette_players_ptd [ gambler_id ] [ 14 + _rou_players ], td_string ) ;
			    }
			}
			_rou_players += 2 ;
		}
	}
	return 1 ;
}

CMD:deal ( playerid )
{
	//if ( ! krupje_player [ playerid ] ) return 1 ;
	
	for ( new i = 0 ; i < 2 ; i ++ )
	{
	    if ( ! IsPlayerInRangeOfPoint ( playerid, 5.0, roulette_position [ i ] [ 0 ], roulette_position [ i ] [ 1 ], roulette_position [ i ] [ 2 ] ) ) continue ;
	    if ( roulette_started [ i ] ) continue ;
	    
	    roulette_started [ i ] = true ;
	    drum_time [ i ] = SetTimerEx ( "drum_move", 5, true, "ii", i, i ) ;
	    me_action ( playerid, "крутанул(а) рулетку" ) ;
	    break ;
	}
	return 1 ;
}

stock key_enter_roulette ( playerid )
{
	new bool: _max_players = false ;
    for ( new i = 0 ; i < 2 ; i ++ )
	{
	    if ( ! IsPlayerInRangeOfPoint ( playerid, 5.0, roulette_position [ i ] [ 0 ], roulette_position [ i ] [ 1 ], roulette_position [ i ] [ 2 ] ) ) continue ;

        for ( new j = 0 ; j < 6 ; j ++ )
		{
		    if ( roulette_players [ i ] [ j ] != INVALID_PLAYER_ID ) continue ;

			roulette_players [ i ] [ j ] = playerid ;
			_max_players = true ;
			break ;
		}
		if ( _max_players == false ) return SendClientMessage(playerid, 0xFF6600FF, !"За столом нет свободных мест." ) ;

		roulette_used { playerid } = i + 1 ;

		SetPlayerCameraPos ( playerid, 2114.3870, -1778.7603, 16.9780 ) ;
		SetPlayerCameraLookAt ( playerid, 2115.3835, -1778.7736, 10.4731 ) ;
		
		show_roulette_ptd ( playerid, true ) ;
		show_roulette_players ( playerid, i, true ) ;
		
		player_casino_object [ playerid ] = CreateObject ( 1902, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0 ) ;
	    AttachObjectToObject ( player_casino_object [ playerid ], table_casino, attach_to_casino [ 0 ] [ 0 ],
																				attach_to_casino [ 0 ] [ 1 ],
																				attach_to_casino [ 0 ] [ 2 ],
																				attach_to_casino [ 0 ] [ 3 ],
																				attach_to_casino [ 0 ] [ 4 ],
																				attach_to_casino [ 0 ] [ 5 ] ) ;
		break ;
	}
	return 1 ;
}

#define col_light_purple					0xC2A2DAAA
stock me_action ( playerid, action [ ], Float:distance = 13.0 )
{
	new _t_string [ 128 ] ;
	format ( _t_string, sizeof ( _t_string ), "%s %s", p_info [ playerid ] [ name ], action ) ;
	send_world_message ( playerid, distance, _t_string, col_light_purple, col_light_purple, col_light_purple, false ) ;
	format ( _t_string, sizeof ( _t_string ), "%s", action ) ;
	SetPlayerChatBubble ( playerid, _t_string, col_light_purple, 13, 5000 ) ;
	return 1 ;
}

stock send_world_message ( pointplayerid, Float:max_radius, text[], color1, color2, color3, bool: chat_buble = false )
{
    new Float:distance;
    SendClientMessage ( pointplayerid, color1, text ) ;
    if ( Iter_Count (streamed_players[pointplayerid]) == 0 ) return 1 ;

	new Float:point_x,
		Float:point_y,
		Float:point_z ;
	GetPlayerPos ( pointplayerid, point_x, point_y, point_z ) ;

    foreach ( new i:streamed_players[pointplayerid])
    {
		if ( IsPlayerInRangeOfPoint ( i, max_radius, point_x, point_y, point_z ) && GetPlayerVirtualWorld ( i ) == GetPlayerVirtualWorld ( pointplayerid ) )
        {
            distance = GetPlayerDistanceFromPoint ( i, point_x, point_y, point_z ) ;
            if ( distance >= 0.0 && distance < max_radius / 3 ) SendClientMessage ( i, color1, text ) ;
            if ( distance >= max_radius / 3 && distance < max_radius / 3 * 2 ) SendClientMessage ( i, color2, text ) ;
            if ( distance >= max_radius / 3 * 2 && distance <= max_radius ) SendClientMessage ( i, color3, text) ;
        }
    }
	if ( chat_buble ) SetPlayerChatBubble ( pointplayerid, text, color1, max_radius, 5000 ) ;
	return 1;
}

new win_number ;
forward drum_move ( drumid, roulette_id ) ;
public drum_move ( drumid, roulette_id )
{
    if ( drum_rotation [ drumid ] <= 1000 )
	{
	    new Float:ObjectPosition [ 3 ] ;
		drum_rotation [ drumid ] ++ ;
		GetDynamicObjectPos ( drum_object [ drumid ], ObjectPosition [ 0 ], ObjectPosition [ 1 ], ObjectPosition [ 2 ] ) ;
	 	MoveDynamicObject( drum_object [ drumid ], ObjectPosition [ 0 ], ObjectPosition [ 1 ], ObjectPosition [ 2 ], 0.1, 0, 0, drum_rotation [ drumid ] ) ;

        win_number = random ( 37 ) ;

	 	new	string [ 32 + 4 ] ;
	 	for ( new i = 0 ; i < 6 ; i ++ )
		{
		    if ( roulette_players [ roulette_id ] [ i ] == INVALID_PLAYER_ID ) continue ;
		    
		    new player_id = roulette_players [ roulette_id ] [ i ] ;
			if ( roulette_bet [ player_id ] == 0 ) continue ;
			
			switch ( win_number )
			{
				case 0: 												format ( string, sizeof ( string ), "~n~~n~~n~~n~~n~~n~~n~~n~~g~%d", win_number ) ;
				case 1,3,5,7,9,12,14,16,18,19,21,23,25,27,30,32,34,36: 	format ( string, sizeof ( string ), "~n~~n~~n~~n~~n~~n~~n~~n~~r~%d", win_number ) ;
				case 2,4,6,8,10,11,13,15,17,20,22,24,26,28,29,31,33,35: format ( string, sizeof ( string ), "~n~~n~~n~~n~~n~~n~~n~~n~~w~%d", win_number ) ;
			}
			GameTextForPlayer ( player_id, string, 5000, 6 ) ;
		}
	}
	else
	{
		roulette_started [ roulette_id ] = false ;
		for ( new i = 0 ; i < 6 ; i ++ )
		{
		    if ( roulette_players [ roulette_id ] [ i ] == INVALID_PLAYER_ID ) continue ;

		    new player_id = roulette_players [ roulette_id ] [ i ] ;
			if ( roulette_bet [ player_id ] == 0 ) continue ;
			
			if ( roulette_number [ player_id ] == win_number )
			{
				new win_money = roulette_bet [ i ] * 12 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( player_id, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else if ( roulette_number [ player_id ] == 37 && ( win_number == 1 || win_number == 4 || win_number == 7 || win_number == 10 || win_number == 13 || win_number == 16 || win_number == 19 || win_number == 22 || win_number == 25 || win_number == 28 || win_number == 31 || win_number == 34 ) )
			{
				new win_money = roulette_bet [ player_id ] * 3 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( i, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else if ( roulette_number [ player_id ] == 38 && ( win_number == 2 || win_number == 5 || win_number == 8 || win_number == 11 || win_number == 14 || win_number == 17 || win_number == 20 || win_number == 23 || win_number == 26 || win_number == 29 || win_number == 32 || win_number == 35 ) )
			{
				new win_money = roulette_bet [ player_id ] * 3 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( player_id, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else if ( roulette_number [ player_id ] == 39 && ( win_number == 3 || win_number == 6 || win_number == 9 || win_number == 12 || win_number == 15 || win_number == 18 || win_number == 21 || win_number == 24 || win_number == 27 || win_number == 30 || win_number == 33 || win_number == 36 ) )
			{
				new win_money = roulette_bet [ player_id ] * 3 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( player_id, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else if ( roulette_number [ player_id ] == 40 && 12 >= win_number >= 1 )
			{
				new win_money = roulette_bet [ player_id ] * 3 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( player_id, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else if ( roulette_number [ player_id ] == 41 && 24 >= win_number >= 13 )
			{
				new win_money = roulette_bet [ i ] * 3 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( player_id, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else if ( roulette_number [ player_id ] == 42 && 36 >= win_number >= 25 )
			{
				new win_money = roulette_bet [ player_id ] * 3 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( player_id, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else if ( roulette_number [ player_id ] == 43 && ( win_number == 1 || win_number == 3 || win_number == 5 || win_number == 7 || win_number == 9 || win_number == 12 || win_number == 14 || win_number == 16 || win_number == 18 || win_number == 19 || win_number == 21 || win_number == 23 || win_number == 25 || win_number == 27 || win_number == 30 || win_number == 32 || win_number == 34 || win_number == 36 ) )
			{
				new win_money = roulette_bet [ player_id ] * 2 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( player_id, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else if ( roulette_number [ player_id ] == 44 && ( win_number == 2 || win_number == 4 || win_number == 6 || win_number == 8 || win_number == 10 || win_number == 11 || win_number == 13 || win_number == 15 || win_number == 17 || win_number == 20 || win_number == 22 || win_number == 24 || win_number == 26 || win_number == 28 || win_number == 29 || win_number == 31 || win_number == 33 || win_number == 35 ) )
			{
				new win_money = roulette_bet [ player_id ] * 2 ;
				new scm_string [ 81 + 4 + 9 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. Вы выйграли {99cc00}%d${FFFFFF}.",
				win_number, win_money ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;

				give_money ( i, win_money ) ;
				//insert_money_log ( i, INVALID_PLAYER_ID, win_money, "рулетка выигрыш" ) ;
			}
			else
			{
			    new scm_string [ 72 + 4 ] ;
				format ( scm_string, sizeof scm_string, "Выпало число {99cc00}%d{FFFFFF}. К сожалению, Ваша ставка не сыграла.",
				win_number ) ;
				SendClientMessage ( player_id, -1, scm_string ) ;
			}

			roulette_number [ player_id ] = -1 ;
			roulette_bet [ player_id ] = 0 ;

			new bet_text [ 16 ] ;
			format ( bet_text, sizeof bet_text, "%d$", roulette_bet [ player_id ] ) ;
			PlayerTextDrawSetString ( player_id, roulette_ptd [ player_id ] [ 11 ], bet_text ) ;
		}
		KillTimer ( drum_time [ roulette_id ] ) ;
		drum_time [ roulette_id ] = -1 ;
		drum_rotation [ drumid ] = 0 ;
	}
	return 1 ;
}

forward load_graffity ( ) ; // graffity
public load_graffity ( )
{
	new fields, time = GetTickCount ( ) ;
	cache_get_data ( count_graffity, fields ) ;
	for ( new i = 1 ; i <= count_graffity ; i ++ )
	{
		graf_info [ i ] [ g_id ] = cache_get_row_int ( i - 1, 0, sql_connection ) ;
		graf_info [ i ] [ g_member ] = cache_get_row_int ( i - 1, 1, sql_connection ) ;
		graf_info [ i ] [ gr_x ] [ 0 ] = cache_get_row_float ( i - 1, 2, sql_connection ) ;
		graf_info [ i ] [ gr_x ] [ 1 ] = cache_get_row_float ( i - 1, 3, sql_connection ) ;
		graf_info [ i ] [ gr_x ] [ 2 ] = cache_get_row_float ( i - 1, 4, sql_connection ) ;
		graf_info [ i ] [ gr_x ] [ 3 ] = cache_get_row_float ( i - 1, 5, sql_connection ) ;
		graf_info [ i ] [ gr_x ] [ 4 ] = cache_get_row_float ( i - 1, 6, sql_connection ) ;
		graf_info [ i ] [ gr_x ] [ 5 ] = cache_get_row_float ( i - 1, 7, sql_connection ) ;
		graf_info [ i ] [ g_day ] = cache_get_row_int ( i - 1, 8, sql_connection ) ;

        new object ;
		switch ( graf_info [ i ] [ g_member ] )
		{
			case 14: object = 18659 ;
		    case 18: object = 18660 ;
		    case 19: object = 18661 ;
		    case 20: object = 18662 ;
		    case 21: object = 18663 ;
		    case 22: object = 18664 ;
		}

		graf_info [ i ] [ g_object ] = CreateDynamicObject ( object, graf_info [ i ] [ gr_x ] [ 0 ], graf_info [ i ] [ gr_x ] [ 1 ], graf_info [ i ] [ gr_x ] [ 2 ], graf_info [ i ] [ gr_x ] [ 3 ], graf_info [ i ] [ gr_x ] [ 4 ], graf_info [ i ] [ gr_x ] [ 5 ] ) ;

		//new text_label [ 87 + 8 + 32 ] ;// graffity fix
		//format ( text_label, sizeof text_label, "Граффити\n{%s}%s\n\n{828282}Используйте {FFFFFF}баллончик{828282} для взаимодействия", f_info [ graf_info [ i ] [ g_member ] - 1 ] [ f_chat_color ], f_info [ graf_info [ i ] [ g_member ] - 1 ] [ f_name ] ) ;
		//graf_info [ i ] [ g_text ] = CreateDynamic3DTextLabel ( text_label, 0xFFCC00FF, graf_info [ i ] [ gr_x ] [ 0 ], graf_info [ i ] [ gr_x ] [ 1 ], graf_info [ i ] [ gr_x ] [ 2 ], 15.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;
        graf_info [ i ] [ g_area ] = CreateDynamicSphere ( graf_info [ i ] [ gr_x ] [ 0 ], graf_info [ i ] [ gr_x ] [ 1 ], graf_info [ i ] [ gr_x ] [ 2 ], 5.0, -1, -1, -1 ) ;
		area_dynamic_info [ graf_info [ i ] [ g_area ] ] [ a_type ] = area_type_graffity ;
	}
	printf ( "[SERVER] Загружено %i граффити. (%d ms)", count_graffity, GetTickCount ( ) - time ) ;
	return 1 ;
}

CMD:test_drop ( playerid )
{
    new bool: vse_ok_Rom = false, bitch_gang = -1 ;
	for ( new i = 0 ; i < 13 ; i ++ )
	{
	    if ( p_t_info [ playerid ] [ p_gun_slot ] [ i ] == 0 ) continue ;

	    new _g_id = -1 ;
		if ( ! vse_ok_Rom )
		{
		    if ( Iter_Count(gun_drops) >= MAX_DROPS - 1 )
		    {
		        new _g_time = 600 ;
		        foreach(new g: gun_drops)
		        {
		            if ( gettime ( ) - gd_info [ g ] [ g_time ] > _g_time )
		            {
		                _g_time = gd_info [ g ] [ g_time ] ;
		                _g_id = g ;
		                break ;
		            }
		        }

		        if ( _g_id != -1 )
		        {
			        new sql_string [ 59 + 9 ] ;
			        format ( sql_string, sizeof ( sql_string ), "DELETE FROM `player_weapons` WHERE `g_id` = '%d' LIMIT 1", gd_info [ _g_id ] [ g_id ] ) ;
					mysql_tquery ( sql_connection, sql_string ) ;

					Iter_Remove(gun_drops, gd_info [ _g_id ] [ g_id ]);
					DestroyDynamicObject ( gd_info [ _g_id ] [ g_object ] ) ;
					DestroyDynamic3DTextLabel ( gd_info [ _g_id ] [ g_text ] ) ;

					vse_ok_Rom = true ;
					bitch_gang = _g_id ;
				}
				else break ;
		    }
			else
			{
				vse_ok_Rom = true ;
				bitch_gang = Iter_Free(gun_drops);
			}
		}
		if ( vse_ok_Rom )
		{
			gd_info [ bitch_gang ] [ g_gun ] [ i ] = p_t_info [ playerid ] [ p_gun_slot ] [ i ] ;
			gd_info [ bitch_gang ] [ g_ammo ] [ i ] = p_t_info [ playerid ] [ p_gun_ammo ] [ i ] ;
		}
	}
	if ( vse_ok_Rom )
	{
	    gd_info [ bitch_gang ] [ g_id ] = bitch_gang ;

	    Iter_Add(gun_drops, gd_info [ bitch_gang ] [ g_id ]);
	    gd_info [ bitch_gang ] [ g_pos ] [ 0 ] = p_t_info [ playerid ] [ p_pos ] [ 0 ] ;
	    gd_info [ bitch_gang ] [ g_pos ] [ 1 ] = p_t_info [ playerid ] [ p_pos ] [ 1 ] ;
	    gd_info [ bitch_gang ] [ g_pos ] [ 2 ] = p_t_info [ playerid ] [ p_pos ] [ 2 ] ;

	    gd_info [ bitch_gang ] [ g_time ] = gettime ( ) ;

	    gd_info [ bitch_gang ] [ g_area ] = CreateDynamicSphere ( p_t_info [ playerid ] [ p_pos ] [ 0 ], p_t_info [ playerid ] [ p_pos ] [ 1 ], p_t_info [ playerid ] [ p_pos ] [ 2 ], 3.0, -1, -1, -1 ) ;
	    area_dynamic_info [ gd_info [ bitch_gang ] [ g_area ] ] [ a_type ] = area_type_drops ;

	    gd_info [ bitch_gang ] [ g_text ] = CreateDynamic3DTextLabel ( "{FFCC00}Ящик с оружием\n\n{FFFFFF}Используйте {FFCC00}ALT{FFFFFF} для взаимодействия", -1, p_t_info [ playerid ] [ p_pos ] [ 0 ],
																																		                           p_t_info [ playerid ] [ p_pos ] [ 1 ],
																																		                           p_t_info [ playerid ] [ p_pos ] [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;

		gd_info [ bitch_gang ] [ g_object ] = CreateDynamicObject ( 3013, p_t_info [ playerid ] [ p_pos ] [ 0 ],
		                                                                p_t_info [ playerid ] [ p_pos ] [ 1 ],
		                                                                p_t_info [ playerid ] [ p_pos ] [ 2 ] - 0.7,
		                                                                0.0, 0.0, 0.0 ) ;

		new gun_string [ 100 ], ammo_string [ 100 ] ;
	    for ( new i = 0 ; i < 13 ; i ++ )
	    {
	        if ( i == 12 ) format ( gun_string, sizeof gun_string, "%s%d", gun_string, gd_info [ bitch_gang ] [ g_gun ] [ i ] ) ;
			else format ( gun_string, sizeof gun_string, "%s%d|", gun_string, gd_info [ bitch_gang ] [ g_gun ] [ i ] ) ;

			if ( i == 12 ) format ( ammo_string, sizeof ammo_string, "%s%d", ammo_string, gd_info [ bitch_gang ] [ g_ammo ] [ i ] ) ;
			else format ( ammo_string, sizeof ammo_string, "%s%d|", ammo_string, gd_info [ bitch_gang ] [ g_ammo ] [ i ] ) ;
	    }

        global_string [ 0 ] = EOS ;
        format ( global_string, sizeof ( global_string ), "INSERT INTO `player_weapons` (`g_id`,`g_time`,`g_pos_x`,`g_pos_y`,`g_pos_z`,`g_gun`,`g_ammo`) VALUES ('%d','%d','%f','%f','%f','%s','%s')",
		gd_info [ bitch_gang ] [ g_id ], gd_info [ bitch_gang ] [ g_time ], gd_info [ bitch_gang ] [ g_pos ] [ 0 ], gd_info [ bitch_gang ] [ g_pos ] [ 1 ], gd_info [ bitch_gang ] [ g_pos ] [ 2 ],
		gun_string, ammo_string ) ;
		mysql_tquery ( sql_connection, global_string ) ;
	}
	reset_player_weapon ( playerid ) ;
	return 1 ;
}

stock reset_player_weapon ( playerid )
{
 	for ( new i = 0 ; i < 12 ; i ++ )
    {
        p_t_info [ playerid ] [ p_gun_ammo ] [ i ] = 0 ;
		p_t_info [ playerid ] [ p_gun_slot ] [ i ] = 0 ;
	}
	ResetPlayerWeapons ( playerid ) ;
	return true ;
}

CMD:delete_drop ( playerid )
{
    if ( used_area [ playerid ] != -1 )
    {
    	if ( area_dynamic_info [ used_area [ playerid ] ] [ a_type ] == area_type_drops )
	    {
     		foreach(new g: gun_drops)
	        {
    			if ( ! IsPlayerInRangeOfPoint ( playerid, 3.00, gd_info [ g ] [ g_pos ] [ 0 ], gd_info [ g ] [ g_pos ] [ 1 ], gd_info [ g ] [ g_pos ] [ 2 ] ) ) continue ;

				new sql_string [ 59 + 9 ] ;
		        format ( sql_string, sizeof ( sql_string ), "DELETE FROM `player_weapons` WHERE `g_id` = '%d' LIMIT 1", gd_info [ g ] [ g_id ] ) ;
				mysql_tquery ( sql_connection, sql_string ) ;

				Iter_Remove(gun_drops, gd_info [ g ] [ g_id ]);
				DestroyDynamicObject ( gd_info [ g ] [ g_object ] ) ;
				DestroyDynamic3DTextLabel ( gd_info [ g ] [ g_text ] ) ;
				break ;
	        }
     		return 1 ;
		}
	}
	return 1 ;
}

CMD:gun ( playerid, params [ ] )
{
	if (sscanf ( params, "dd", params [ 0 ], params [ 1 ] ) )return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /gun [оружие] [патроны]" ) ;
	if ( params [ 0 ] < 1 || params [ 0 ] > 46 || params [ 0 ] == 38 )return SendClientMessage ( playerid, 0xFF6600FF, !"Не правильно указан ID оружия." ) ;
	give_weapon ( playerid, params [ 0 ], params [ 1 ] ) ;
	return 1 ;
}

forward load_weapons ( ) ;
public load_weapons ( )
{
    new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( rows )
	{
		for ( new i = 0 ; i < rows ; i ++ )
		{
		    gd_info [ i ] [ g_id ] = cache_get_field_content_int ( i, "g_id", sql_connection ) ;
		    gd_info [ i ] [ g_time ] = cache_get_field_content_int ( i, "g_time", sql_connection ) ;
		    if ( 3 > floatround ( gd_info [ i ] [ g_time ] / 86400 ) )
		    {
		        new sql_string [ 59 + 9 ] ;
		        format ( sql_string, sizeof ( sql_string ), "DELETE FROM `player_weapons` WHERE `g_id` = '%d' LIMIT 1", gd_info [ i ] [ g_id ] ) ;
				mysql_tquery ( sql_connection, sql_string ) ;
				continue ;
		    }
		    Iter_Add(gun_drops, gd_info [ i ] [ g_id ]);

		    gd_info [ i ] [ g_pos ] [ 0 ] = cache_get_field_content_float ( i, "g_pos_x", sql_connection ) ;
		    gd_info [ i ] [ g_pos ] [ 1 ] = cache_get_field_content_float ( i, "g_pos_y", sql_connection ) ;
		    gd_info [ i ] [ g_pos ] [ 2 ] = cache_get_field_content_float ( i, "g_pos_z", sql_connection ) ;
		    
		    gd_info [ i ] [ g_area ] = CreateDynamicSphere ( gd_info [ i ] [ g_pos ] [ 0 ], gd_info [ i ] [ g_pos ] [ 1 ], gd_info [ i ] [ g_pos ] [ 2 ], 3.0, -1, -1, -1 ) ;
			area_dynamic_info [ gd_info [ i ] [ g_area ] ] [ a_type ] = area_type_drops ;

		    gd_info [ i ] [ g_text ] = CreateDynamic3DTextLabel ( "{FFCC00}Ящик с оружием\n\n{FFFFFF}Используйте {FFCC00}ALT{FFFFFF} для взаимодействия", -1, gd_info [ i ] [ g_pos ] [ 0 ], gd_info [ i ] [ g_pos ] [ 1 ], gd_info [ i ] [ g_pos ] [ 2 ], 10.0, INVALID_PLAYER_ID, INVALID_VEHICLE_ID, 1 ) ;

			gd_info [ i ] [ g_object ] = CreateDynamicObject ( 3013, gd_info [ i ] [ g_pos ] [ 0 ],
		 																gd_info [ i ] [ g_pos ] [ 1 ],
				                                                        gd_info [ i ] [ g_pos ] [ 2 ] - 0.7,
				                                                        0.0, 0.0, 0.0 ) ;

		    new _seed [ 100 ], _sell_seed [ 100 ] ;
			cache_get_field_content ( 0, "g_gun", _seed, sql_connection, sizeof _seed ) ;
			cache_get_field_content ( 0, "g_ammo", _sell_seed, sql_connection, sizeof _sell_seed ) ;

			sscanf ( _seed, "p<|>a<i>[12]", gd_info [ i ] [ g_gun ] ) ;
			sscanf ( _sell_seed, "p<|>a<i>[12]", gd_info [ i ] [ g_ammo ] ) ;
		}
	}
	return 1 ;
}

CMD:test_kush ( playerid )
{
    new _table = bg_player_table [ playerid ] ;
    bg_info [ _table ] [ bg_dice ] [ 0 ] =
   	bg_info [ _table ] [ bg_dice ] [ 1 ] =
   	bg_info [ _table ] [ bg_dice ] [ 2 ] =
   	bg_info [ _table ] [ bg_dice ] [ 3 ] = 4 ;
	return 1 ;
}

CMD:skip ( playerid )
{
    new _table = bg_player_table [ playerid ] ;
    if ( bg_info [ _table ] [ bg_player ] [ 1 ] == INVALID_PLAYER_ID ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не можете начать игру один." ) ;
    
    new scm_string [ 128 ] ;
	if ( bg_info [ _table ] [ bg_player ] [ 0 ] == playerid )
	{
		bg_info [ _table ] [ bg_move ] = bg_info [ _table ] [ bg_player ] [ 1 ] ;

		format ( scm_string, sizeof scm_string, "%s пропустил(а) ход. Теперь твоя очередь.", p_info [ playerid ] [ name ] ) ;
		SendClientMessage ( bg_info [ _table ] [ bg_player ] [ 1 ], -1, scm_string ) ;

		format ( scm_string, sizeof scm_string, "Вы закончили свой ход. Теперь ходит %s.", p_info [ bg_info [ _table ] [ bg_player ] [ 1 ] ] [ name ] ) ;
		SendClientMessage ( playerid, -1, scm_string ) ;
	}
	else
	{
		bg_info [ _table ] [ bg_move ] = bg_info [ _table ] [ bg_player ] [ 0 ] ;

		format ( scm_string, sizeof scm_string, "%s пропустил(а) ход. Теперь твоя очередь.", p_info [ playerid ] [ name ] ) ;
		SendClientMessage ( bg_info [ _table ] [ bg_player ] [ 0 ], -1, scm_string ) ;

		format ( scm_string, sizeof scm_string, "Вы закончили свой ход. Теперь ходит %s.", p_info [ bg_info [ _table ] [ bg_player ] [ 0 ] ] [ name ] ) ;
		SendClientMessage ( playerid, -1, scm_string ) ;
	}

	bg_info [ _table ] [ bg_player_dice_count ] = 0 ;
	bg_head_nard [ playerid ] = false ;
	bg_used_nard [ playerid ] = -1 ;
	bg_change_player [ _table ] = false ;
	return 1 ;
}

CMD:change_player ( playerid )
{
    new _table = bg_player_table [ playerid ] ;
    if ( bg_info [ _table ] [ bg_player ] [ 0 ] == playerid ) bg_info [ _table ] [ bg_player ] [ 0 ] = 15, bg_info [ _table ] [ bg_player ] [ 1 ] = playerid ;
    else bg_info [ _table ] [ bg_player ] [ 1 ] = 15, bg_info [ _table ] [ bg_player ] [ 0 ] = playerid ;
	return 1 ;
}

stock show_ptd_nards ( position, _table, bool: status )
{
	if ( status )
	{
	    new _nard_count = 0, playerid = bg_info [ _table ] [ bg_player ] [ position ] ;
	    for ( new i = 0 ; i < 15 ; i ++ )
	    {
		    bg_nard_ptd [ playerid ] [ i ] = CreatePlayerTextDraw(playerid, bg_td_pos [ 0 ] [ 0 ] + _nard_count, bg_td_pos [ 0 ] [ 1 ], "LD_CHESS:upl"); // пусто
			PlayerTextDrawTextSize(playerid, bg_nard_ptd [ playerid ] [ i ], 17.0000, 22.0000);
			PlayerTextDrawAlignment(playerid, bg_nard_ptd [ playerid ] [ i ], 1);
			PlayerTextDrawColor(playerid, bg_nard_ptd [ playerid ] [ i ], -1);
			PlayerTextDrawBackgroundColor(playerid, bg_nard_ptd [ playerid ] [ i ], 255);
			PlayerTextDrawFont(playerid, bg_nard_ptd [ playerid ] [ i ], 4);
			PlayerTextDrawSetProportional(playerid, bg_nard_ptd [ playerid ] [ i ], 0);
			PlayerTextDrawSetShadow(playerid, bg_nard_ptd [ playerid ] [ i ], 0);
			PlayerTextDrawSetSelectable(playerid, bg_nard_ptd [ playerid ] [ i ], true);
			
			PlayerTextDrawShow ( playerid, bg_nard_ptd [ playerid ] [ i ] ) ;
			
			_nard_count += 10 ;
			
			bg_info [ _table ] [ bg_nard_count ] [ 0 ] ++ ;
			bg_info [ _table ] [ bg_nard_count_id ] [ i ] = bg_info [ _table ] [ bg_nard_count ] [ 0 ] ;
			bg_info [ _table ] [ bg_nard_player ] [ i ] = bg_info [ _table ] [ bg_player ] [ 0 ] ;
			bg_info [ _table ] [ bg_nard_slot ] [ i ] = 0 ;
		}
		
		_nard_count = 0 ;
	    for ( new i = 15 ; i < 30 ; i ++ )
	    {
		    bg_nard_ptd [ playerid ] [ i ] = CreatePlayerTextDraw(playerid, bg_td_pos [ 12 ] [ 0 ] - _nard_count, bg_td_pos [ 12 ] [ 1 ], "LD_CHESS:up"); // пусто
			PlayerTextDrawTextSize(playerid, bg_nard_ptd [ playerid ] [ i ], 17.0000, 22.0000);
			PlayerTextDrawAlignment(playerid, bg_nard_ptd [ playerid ] [ i ], 1);
			PlayerTextDrawColor(playerid, bg_nard_ptd [ playerid ] [ i ], -1);
			PlayerTextDrawBackgroundColor(playerid, bg_nard_ptd [ playerid ] [ i ], 255);
			PlayerTextDrawFont(playerid, bg_nard_ptd [ playerid ] [ i ], 4);
			PlayerTextDrawSetProportional(playerid, bg_nard_ptd [ playerid ] [ i ], 0);
			PlayerTextDrawSetShadow(playerid, bg_nard_ptd [ playerid ] [ i ], 0);
			PlayerTextDrawSetSelectable(playerid, bg_nard_ptd [ playerid ] [ i ], true);
			
			PlayerTextDrawShow ( playerid, bg_nard_ptd [ playerid ] [ i ] ) ;

			_nard_count += 10 ;

            bg_info [ _table ] [ bg_nard_count ] [ 12 ] ++ ;
			bg_info [ _table ] [ bg_nard_count_id ] [ i ] = bg_info [ _table ] [ bg_nard_count ] [ 12 ] ;
			bg_info [ _table ] [ bg_nard_player ] [ i ] = bg_info [ _table ] [ bg_player ] [ 1 ] ;
			bg_info [ _table ] [ bg_nard_slot ] [ i ] = 12 ;
		}
		
		bg_used_nard [ playerid ] = -1 ;
	}
	else
	{
	    new playerid = bg_info [ _table ] [ bg_player ] [ position ] ;
	    for ( new i = 0 ; i < 30 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, bg_nard_ptd [ playerid ] [ i ] ) ;
			bg_nard_ptd [ playerid ] [ i ] = PlayerText:-1 ;
		}
		
		for ( new i = 0 ; i < 6 ; i ++ )
		{
		    if ( bg_dice_ptd_1 [ playerid ] [ i ] != PlayerText:-1 )
		    {
				PlayerTextDrawDestroy ( playerid, bg_dice_ptd_1 [ playerid ] [ i ] ) ;
				bg_dice_ptd_1 [ playerid ] [ i ] = PlayerText:-1 ;
			}

			if ( bg_dice_ptd_2 [ playerid ] [ i ] != PlayerText:-1 )
		    {
				PlayerTextDrawDestroy ( playerid, bg_dice_ptd_2 [ playerid ] [ i ] ) ;
				bg_dice_ptd_2 [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		
		bg_info [ _table ] [ bg_player ] [ position ] = INVALID_PLAYER_ID ;
	}
	return 1 ;
}

stock show_ptd_chess ( playerid, bool: status )
{
	if ( status )
	{
		bg_ptd [ playerid ] [ 0 ] = CreatePlayerTextDraw(playerid, 108.9998, 45.9865, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 0 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 0 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 0 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 0 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 0 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 0 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 0 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 0 ], true);

		bg_ptd [ playerid ] [ 1 ] = CreatePlayerTextDraw(playerid, 109.3998, 73.8621, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 1 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 1 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 1 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 1 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 1 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 1 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 1 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 1 ], true);

		bg_ptd [ playerid ] [ 2 ] = CreatePlayerTextDraw(playerid, 109.3998, 101.7377, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 2 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 2 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 2 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 2 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 2 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 2 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 2 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 2 ], true);

		bg_ptd [ playerid ] [ 3 ] = CreatePlayerTextDraw(playerid, 109.3998, 130.1132, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 3 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 3 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 3 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 3 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 3 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 3 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 3 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 3 ], true);

		bg_ptd [ playerid ] [ 4 ] = CreatePlayerTextDraw(playerid, 109.3998, 158.3150, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 4 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 4 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 4 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 4 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 4 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 4 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 4 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 4 ], true);

		bg_ptd [ playerid ] [ 5 ] = CreatePlayerTextDraw(playerid, 109.3998, 183.7016, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 5 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 5 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 5 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 5 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 5 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 5 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 5 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 5 ], true);

		bg_ptd [ playerid ] [ 6 ] = CreatePlayerTextDraw(playerid, 108.9998, 212.5727, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 6 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 6 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 6 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 6 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 6 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 6 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 6 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 6 ], true);

		bg_ptd [ playerid ] [ 7 ] = CreatePlayerTextDraw(playerid, 108.9997, 239.9505, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 7 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 7 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 7 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 7 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 7 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 7 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 7 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 7 ], true);

		bg_ptd [ playerid ] [ 8 ] = CreatePlayerTextDraw(playerid, 108.5997, 268.8216, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 8 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 8 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 8 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 8 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 8 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 8 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 8 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 8 ], true);

		bg_ptd [ playerid ] [ 9 ] = CreatePlayerTextDraw(playerid, 108.5997, 295.7016, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 9 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 9 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 9 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 9 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 9 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 9 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 9 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 9 ], true);

		bg_ptd [ playerid ] [ 10 ] = CreatePlayerTextDraw(playerid, 108.5997, 324.0749, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 10 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 10 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 10 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 10 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 10 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 10 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 10 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 10 ], true);

		bg_ptd [ playerid ] [ 11 ] = CreatePlayerTextDraw(playerid, 109.3997, 350.9549, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 11 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 11 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 11 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 11 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 11 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 11 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 11 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 11 ], true);

		bg_ptd [ playerid ] [ 12 ] = CreatePlayerTextDraw(playerid, 340.1997, 347.9682, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 12 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 12 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 12 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 12 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 12 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 12 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 12 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 12 ], true);

		bg_ptd [ playerid ] [ 13 ] = CreatePlayerTextDraw(playerid, 339.7997, 321.5859, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 13 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 13 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 13 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 13 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 13 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 13 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 13 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 13 ], true);

		bg_ptd [ playerid ] [ 14 ] = CreatePlayerTextDraw(playerid, 340.5997, 293.7104, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 14 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 14 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 14 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 14 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 14 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 14 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 14 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 14 ], true);

		bg_ptd [ playerid ] [ 15 ] = CreatePlayerTextDraw(playerid, 340.5996, 267.8260, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 15 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 15 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 15 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 15 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 15 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 15 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 15 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 15 ], true);

		bg_ptd [ playerid ] [ 16 ] = CreatePlayerTextDraw(playerid, 340.5996, 239.4527, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 16 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 16 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 16 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 16 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 16 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 16 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 16 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 16 ], true);

		bg_ptd [ playerid ] [ 17 ] = CreatePlayerTextDraw(playerid, 340.5996, 213.0705, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 17 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 17 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 17 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 17 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 17 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 17 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 17 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 17 ], true);

		bg_ptd [ playerid ] [ 18 ] = CreatePlayerTextDraw(playerid, 340.5996, 183.7016, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 18 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 18 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 18 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 18 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 18 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 18 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 18 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 18 ], true);

		bg_ptd [ playerid ] [ 19 ] = CreatePlayerTextDraw(playerid, 340.1995, 156.8216, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 19 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 19 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 19 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 19 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 19 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 19 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 19 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 19 ], true);

		bg_ptd [ playerid ] [ 20 ] = CreatePlayerTextDraw(playerid, 340.5996, 128.4483, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 20 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 20 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 20 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 20 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 20 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 20 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 20 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 20 ], true);

		bg_ptd [ playerid ] [ 21 ] = CreatePlayerTextDraw(playerid, 340.9996, 101.5683, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 21 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 21 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 21 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 21 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 21 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 21 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 21 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 21 ], true);

		bg_ptd [ playerid ] [ 22 ] = CreatePlayerTextDraw(playerid, 340.9996, 73.6927, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 22 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 22 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 22 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 22 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 22 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 22 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 22 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 22 ], true);

		bg_ptd [ playerid ] [ 23 ] = CreatePlayerTextDraw(playerid, 340.9996, 46.8127, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 23 ], 188.0000, 23.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 23 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 23 ], -256);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 23 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 23 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 23 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 23 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 23 ], true);
		
		bg_ptd [ playerid ] [ 24 ] = CreatePlayerTextDraw(playerid, 54.0000, 41.0000, "LD_CHESS:upr"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 24 ], 533.0000, 337.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 24 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 24 ], -1);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 24 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 24 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 24 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 24 ], 0);
		
		bg_ptd [ playerid ] [ 25 ] = CreatePlayerTextDraw(playerid, 55.3999, 353.6133, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 25 ], 50.0000, 21.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 25 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 25 ], 184);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 25 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 25 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 25 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 25 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 25 ], true);

		bg_ptd [ playerid ] [ 26 ] = CreatePlayerTextDraw(playerid, 67.4999, 356.0623, "DICE"); // пусто
		PlayerTextDrawLetterSize(playerid, bg_ptd [ playerid ] [ 26 ], 0.4000, 1.6000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 26 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 26 ], -1);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 26 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 26 ], 1);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 26 ], 1);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 26 ], 0);

		bg_ptd [ playerid ] [ 27 ] = CreatePlayerTextDraw(playerid, 534.2001, 44.9911, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 27 ], 50.0000, 21.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 27 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 27 ], 184);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 27 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 27 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 27 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 27 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 27 ], true);

		bg_ptd [ playerid ] [ 28 ] = CreatePlayerTextDraw(playerid, 540.2998, 48.4356, "CLOSE"); // пусто
		PlayerTextDrawLetterSize(playerid, bg_ptd [ playerid ] [ 28 ], 0.4000, 1.6000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 28 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 28 ], -1);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 28 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 28 ], 1);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 28 ], 1);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 28 ], 0);

		bg_ptd [ playerid ] [ 29 ] = CreatePlayerTextDraw(playerid, 534.6003, 354.1111, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 29 ], 50.0000, 21.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 29 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 29 ], 184);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 29 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 29 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 29 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 29 ], 0);
		PlayerTextDrawSetSelectable(playerid, bg_ptd [ playerid ] [ 29 ], true);

		bg_ptd [ playerid ] [ 30 ] = CreatePlayerTextDraw(playerid, 547.1000, 356.5601, "SKIP"); // пусто
		PlayerTextDrawLetterSize(playerid, bg_ptd [ playerid ] [ 30 ], 0.4000, 1.6000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 30 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 30 ], -1);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 30 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 30 ], 1);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 30 ], 1);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 30 ], 0);

		bg_ptd [ playerid ] [ 31 ] = CreatePlayerTextDraw(playerid, 300.6000, 170.9288, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 31 ], 32.0000, 34.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 31 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 31 ], -1);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 31 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 31 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 31 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 31 ], 0);

		bg_ptd [ playerid ] [ 32 ] = CreatePlayerTextDraw(playerid, 300.6000, 214.7314, "LD_SPAC:white"); // пусто
		PlayerTextDrawTextSize(playerid, bg_ptd [ playerid ] [ 32 ], 32.0000, 34.0000);
		PlayerTextDrawAlignment(playerid, bg_ptd [ playerid ] [ 32 ], 1);
		PlayerTextDrawColor(playerid, bg_ptd [ playerid ] [ 32 ], -1);
		PlayerTextDrawBackgroundColor(playerid, bg_ptd [ playerid ] [ 32 ], 255);
		PlayerTextDrawFont(playerid, bg_ptd [ playerid ] [ 32 ], 4);
		PlayerTextDrawSetProportional(playerid, bg_ptd [ playerid ] [ 32 ], 0);
		PlayerTextDrawSetShadow(playerid, bg_ptd [ playerid ] [ 32 ], 0);
		
		for ( new i = 0 ; i < 33 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, bg_ptd [ playerid ] [ i ] ) ;
		}
		
		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    for ( new i = 0 ; i < 33 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, bg_ptd [ playerid ] [ i ] ) ;
			bg_ptd [ playerid ] [ i ] = PlayerText:-1 ;
		}
		
		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

forward bg_timer ( _table ) ;
public bg_timer ( _table )
{
    new _random = random ( 6 ) + 1 ;
    new _random_2 = random ( 6 ) + 1 ;
    
    bg_info [ _table ] [ bg_time_count ] -- ;
    
	for ( new p = 0 ; p < 2 ; p ++ )
	{
	    if ( bg_info [ _table ] [ bg_player ] [ p ] == INVALID_PLAYER_ID ) continue ;
	
		new playerid = bg_info [ _table ] [ bg_player ] [ p ] ;
	    for ( new i = 0 ; i < 6 ; i ++ )
		{
		    if ( bg_dice_ptd_1 [ playerid ] [ i ] != PlayerText:-1 )
		    {
				PlayerTextDrawDestroy ( playerid, bg_dice_ptd_1 [ playerid ] [ i ] ) ;
				bg_dice_ptd_1 [ playerid ] [ i ] = PlayerText:-1 ;
			}

			if ( bg_dice_ptd_2 [ playerid ] [ i ] != PlayerText:-1 )
		    {
				PlayerTextDrawDestroy ( playerid, bg_dice_ptd_2 [ playerid ] [ i ] ) ;
				bg_dice_ptd_2 [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}

		for ( new i = 0 ; i < _random ; i ++ )
		{
		    bg_dice_ptd_1 [ playerid ] [ i ] = CreatePlayerTextDraw(playerid, dice_td_pos_1 [ _random - 1 ] [ i ] [ 0 ], dice_td_pos_1 [ _random - 1 ] [ i ] [ 1 ], "LD_BEAT:chit"); // пусто
			PlayerTextDrawTextSize(playerid, bg_dice_ptd_1 [ playerid ] [ i ], 7.0000, 8.0000);
			PlayerTextDrawAlignment(playerid, bg_dice_ptd_1 [ playerid ] [ i ], 1);
			PlayerTextDrawColor(playerid, bg_dice_ptd_1 [ playerid ] [ i ], 255);
			PlayerTextDrawBackgroundColor(playerid, bg_dice_ptd_1 [ playerid ] [ i ], 255);
			PlayerTextDrawFont(playerid, bg_dice_ptd_1 [ playerid ] [ i ], 4);
			PlayerTextDrawSetProportional(playerid, bg_dice_ptd_1 [ playerid ] [ i ], 0);
			PlayerTextDrawSetShadow(playerid, bg_dice_ptd_1 [ playerid ] [ i ], 0);

			PlayerTextDrawShow ( playerid, bg_dice_ptd_1 [ playerid ] [ i ] ) ;
		}

		for ( new i = 0 ; i < _random_2 ; i ++ )
		{
		    bg_dice_ptd_2 [ playerid ] [ i ] = CreatePlayerTextDraw(playerid, dice_td_pos_2 [ _random_2 - 1 ] [ i ] [ 0 ], dice_td_pos_2 [ _random_2 - 1 ] [ i ] [ 1 ], "LD_BEAT:chit"); // пусто
			PlayerTextDrawTextSize(playerid, bg_dice_ptd_2 [ playerid ] [ i ], 7.0000, 8.0000);
			PlayerTextDrawAlignment(playerid, bg_dice_ptd_2 [ playerid ] [ i ], 1);
			PlayerTextDrawColor(playerid, bg_dice_ptd_2 [ playerid ] [ i ], 255);
			PlayerTextDrawBackgroundColor(playerid, bg_dice_ptd_2 [ playerid ] [ i ], 255);
			PlayerTextDrawFont(playerid, bg_dice_ptd_2 [ playerid ] [ i ], 4);
			PlayerTextDrawSetProportional(playerid, bg_dice_ptd_2 [ playerid ] [ i ], 0);
			PlayerTextDrawSetShadow(playerid, bg_dice_ptd_2 [ playerid ] [ i ], 0);

			PlayerTextDrawShow ( playerid, bg_dice_ptd_2 [ playerid ] [ i ] ) ;
		}
	}
	
	if ( bg_info [ _table ] [ bg_time_count ] == 0 )
    {
        if ( _random == _random_2 )
        {
            bg_info [ _table ] [ bg_dice ] [ 2 ] = _random ;
	    	bg_info [ _table ] [ bg_dice ] [ 3 ] = _random_2 ;
        }

        bg_info [ _table ] [ bg_dice ] [ 0 ] = _random ;
	    bg_info [ _table ] [ bg_dice ] [ 1 ] = _random_2 ;

	    new scm_string [ 24 + 4 + 4 ] ;
	    format ( scm_string, sizeof scm_string, "Выпавшие числа: %d:%d", bg_info [ _table ] [ bg_dice ] [ 0 ], bg_info [ _table ] [ bg_dice ] [ 1 ] ) ;
	    SendClientMessage ( bg_info [ _table ] [ bg_player ] [ 0 ], 0xFFCC00FF, scm_string ) ;
	    SendClientMessage ( bg_info [ _table ] [ bg_player ] [ 1 ], 0xFFCC00FF, scm_string ) ;

	    KillTimer ( bg_info [ _table ] [ bg_time ] ) ;
	    bg_info [ _table ] [ bg_time ] = -1 ;
	    return 1 ;
    }
	return 1 ;
}

CMD:gonards ( playerid, params [ ] )
{
	new bool: _go_table = false ;
	new _table = 0 ;
    for ( new i = 0 ; i < 2 ; i ++ )
	{
	    if ( ! IsPlayerInRangeOfPoint ( playerid, 5.0, nard_position [ i ] [ 0 ], nard_position [ i ] [ 1 ], nard_position [ i ] [ 2 ] ) ) continue ;
		if ( bg_info [ i ] [ bg_player ] [ 0 ] != INVALID_PLAYER_ID ) return SendClientMessage(playerid, 0xFF6600FF, !"За столом уже играют." ) ;
		
		_go_table = true ;
		_table = i ;
		break ;
	}
	if ( ! _go_table ) return 1 ;
	
	if ( sscanf ( params, "u", params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /gonards [ид]" ) ;
	if ( ! IsPlayerConnected ( params [ 0 ] ) || playerid == params [ 0 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Неверно указан ID игрока." ) ;
    if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( playerid ) != GetPlayerVirtualWorld ( params [ 0 ] ) )
				return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок слишком далеко." ) ;
				
	buyer_id [ playerid ] = params [ 0 ] ;
	seller_id [ params [ 0 ] ] = playerid ;
	
	bg_player_table [ playerid ] =
	bg_player_table [ params [ 0 ] ] = _table ;

	new dialog_string [ 53 + MAX_PLAYER_NAME ] ;
	format ( dialog_string, sizeof ( dialog_string  ), "{FFCC00}%s {FFFFFF}предлагает Вам сыграть в нарды.",
	p_info [ playerid ] [ name ] ) ;
	show_dialog ( params [ 0 ], d_nards_accept, DIALOG_STYLE_MSGBOX, "{FFCC00}Нарды", dialog_string, "Согласен", "Отказ" ) ;

	format ( dialog_string, sizeof ( dialog_string  ), "Вы предложили {FFCC00}%s {FFFFFF}сыграть в нарды.",
	p_info [ params [ 0 ] ] [ name ] ) ;
	SendClientMessage ( playerid, -1, dialog_string ) ;
	return 1 ;
}

stock quest_filling ( playerid ) // Сток заправки
{
    if ( p_info [ playerid ] [ family_everyday_progress ] [ 0 ] == 2 )
    {
		if ( p_info [ playerid ] [ family_everyday_car ] == GetPlayerVehicleID ( playerid ) )
  		{
			is_gps_used { playerid } = 22 ;
			SetPlayerRaceCheckpoint ( playerid, 1, 279.8808, -1587.3201, 33.0179 - 1.4, 0.0, 0.0, 0.0, 3.0 ) ;

            SendClientMessage ( playerid, 0xFFCC00FF, !"Вы заправили транспорт, осталось отчитаться беред боссом. Местоположение босса отмечено на карте." ) ;

            p_info [ playerid ] [ family_everyday_progress ] [ 0 ] = 3 ;
	    }
	}
	return 1 ;
}

stock family_everyday_show ( playerid )
{
	if ( p_info [ playerid ] [ family_everyday_progress ] [ 0 ] == 3 )
	{
	    SendClientMessage ( playerid, 0xFFCC00FF, !"Вот твоя награда, сынок." ) ;
	    p_info [ playerid ] [ family_everyday_progress ] [ 0 ] = 0 ;
	    return 1 ;
	}
	else if ( p_info [ playerid ] [ family_everyday_progress ] [ 1 ] == 4 )
	{
	    SendClientMessage ( playerid, 0xFFCC00FF, !"Вот твоя награда, сынок." ) ;
	    p_info [ playerid ] [ family_everyday_progress ] [ 1 ] = 0 ;
	    return 1 ;
	}
	if ( p_info [ playerid ] [ family_everyday_progress ] [ 0 ] || p_info [ playerid ] [ family_everyday_progress ] [ 1 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже выполняете задание." ) ;
	global_string [ 0 ] = EOS ;
	format ( global_string, 512, "{FFCC00}1. {FFFFFF}Полный бак [%d/3]\n{FFCC00}2. {FFFFFF}Заказ оружия [%d/2]", p_info [ playerid ] [ family_everyday_quest ] [ 0 ], p_info [ playerid ] [ family_everyday_quest ] [ 1 ] ) ;
	show_dialog ( playerid, d_family_every_quest, DIALOG_STYLE_LIST, "{FFCC00}Ежедневные задания", global_string, "Выбрать", "Закрыть" ) ;
	return 1 ;
}

stock GetCoordBootVehicle ( vehicleid, & Float:x, & Float:y, & Float:z)
{
    new Float:angle,Float:distance;
    GetVehicleModelInfo ( GetVehicleModel ( vehicleid ), 1, x, distance, z ) ;
    distance = distance/2 + 0.1;
    GetVehiclePos(vehicleid, x, y, z ) ;
    GetVehicleZAngle(vehicleid, angle ) ;
    x += (distance * floatsin(-angle+180, degrees) ) ;
    y += (distance * floatcos(-angle+180, degrees) ) ;
    return 1 ;
}

alias:usecanister1("fuelcar1", "fillcar1");
CMD:usecanister1 ( playerid, params [ ] )
{
	//if ( target_cuff [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы в наручниках." ) ;
	//if ( target_tie [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы связаны." ) ;
	//if ( ! p_info [ playerid ] [ canister ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У вас нет канистры с бензином.");
	if ( p_info [ playerid ] [ back_timer ] != -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже заправляете транспорт.");

    new vehicle_id ;
	new bool: _active_car = false, Float: _range = 0.0 ;
    foreach ( new veh_id: streamed_vehicles[ playerid ])
	{
		new Float:boot_pos [ 3 ] ;
		
		if ( vehicle_back_model ( veh_info [ veh_id - 1 ] [ v_model ] ) ) GetVehiclePos ( veh_id, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ), _range = 4.0 ;
		else GetCoordPetrolVehicle ( veh_id, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ), _range = 1.0 ;

		if ( ! IsPlayerInRangeOfPoint ( playerid, _range, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ) continue ;
		
		vehicle_id = veh_id - 1 ;
		_active_car = true ;
		break ;
	}
	if ( ! _active_car ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы должны быть рядом с топливным баком транспорта.");

	if ( veh_info [ vehicle_id ] [ v_fuel ] > 99 )return SendClientMessage ( playerid, 0xFF6600FF, !"Ваш бак полон.");
	veh_info [ vehicle_id ] [ v_fuel ] += 15 ;
	if ( veh_info [ vehicle_id ] [ v_fuel ] > 100 ) veh_info [ vehicle_id ] [ v_fuel ] = 100 ;

	//p_info [ playerid ] [ canister ] -= 1 ;
	//update_int_sql ( playerid, "u_canister", p_info [ playerid ] [ canister ] ) ;
	
	ApplyAnimation ( playerid, "BD_FIRE", "WASH_UP", 4.0, 0, 0, 0, 0, 0 ) ;
	p_info [ playerid ] [ back_timer ] = SetTimerEx ( "other_timer", 2000, false, "iii", playerid, 1, -1 ) ;
	return 1 ;
}

stock GetCoordPetrolVehicle ( vehicleid, & Float:x, & Float:y, & Float:z)
{
    new Float:X, Float:Y, Float:Z, Float:A;
    GetVehicleModelInfo ( GetVehicleModel ( vehicleid ), VEHICLE_MODEL_INFO_PETROLCAP, X, Y, Z ) ;
    GetVehiclePos ( vehicleid, x, y, z ) ;
    GetVehicleZAngle ( vehicleid, A ) ;
    x += ( Y * floatsin(-A, degrees) ) ;
    y += ( Y * floatcos(-A, degrees) ) ;
    x += ( X * floatsin( (-A + 90.0), degrees) ) ;
    y += ( X * floatcos( (-A + 90.0), degrees) ) ;
    z += Z ;
    return 1 ;
}

alias:repairkit1("repcar1", "repaircar1");
CMD:repairkit1 ( playerid, params [ ] )
{
	//if ( target_cuff [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы в наручниках." ) ;
	//if ( target_tie [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы связаны." ) ;
	//if ( ! p_info [ playerid ] [ repairkit ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У вас нет ремонтного набора.");
	if ( p_info [ playerid ] [ back_timer ] != -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы уже чините транспорт.");

    new vehicle_id ;
	new bool: _active_car = false, Float: _range = 0.0 ;
    foreach ( new veh_id: streamed_vehicles[ playerid ])
	{
		new Float:boot_pos [ 3 ] ;
		
		if ( vehicle_back_model ( veh_info [ veh_id - 1 ] [ v_model ] ) ) GetVehiclePos ( veh_id, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ), _range = 4.0 ;
		else GetCoordHoodVehicle ( veh_id, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ), _range = 1.0 ;
		
		if ( ! IsPlayerInRangeOfPoint ( playerid, _range, boot_pos [ 0 ], boot_pos [ 1 ], boot_pos [ 2 ] ) ) continue ;

		vehicle_id = veh_id ;
		_active_car = true ;
		break ;
	}
	if ( ! _active_car ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы должны быть рядом с капотом транспорта.");
	
	//p_info [ playerid ] [ repairkit ] -= 1 ;
	//update_int_sql ( playerid, "u_repairkit", p_info [ playerid ] [ repairkit ] ) ;
	
	ApplyAnimation ( playerid, "BD_FIRE", "WASH_UP", 4.0, 0, 0, 0, 0, 0 ) ;
	p_info [ playerid ] [ back_timer ] = SetTimerEx ( "other_timer", 2000, false, "iii", playerid, 2, vehicle_id ) ;
	return 1 ;
}

stock GetCoordHoodVehicle ( vehicleid, & Float:x, & Float:y, & Float:z)
{
    new Float:angle,Float:distance;
    GetVehicleModelInfo ( GetVehicleModel ( vehicleid ), VEHICLE_MODEL_INFO_FRONTSEAT, x, distance, z ) ;
    distance = distance + 2.0 ;
    GetVehiclePos(vehicleid, x, y, z ) ;
    GetVehicleZAngle(vehicleid, angle ) ;
    x += (distance * floatsin(-angle+360, degrees) ) ;
    y += (distance * floatcos(-angle+360, degrees) ) ;
    return 1 ;
}

stock vehicle_back_model ( vehicle_model )
{
	switch ( vehicle_model )
	{
	    case 430, 446, 452, 453, 454, 472, 473, 484, 493, 417, 425, 447, 460, 469, 476, 487, 488, 497, 511, 512, 513, 519, 520, 548, 553,
	        563, 577, 592, 593, 581, 522, 461, 521, 523, 463, 468, 471, 586: return 1 ;
	        
		default: return 0 ;
	}
	return 0 ;
}

forward other_timer ( playerid, _type, vehicle_id ) ;
public other_timer ( playerid, _type, vehicle_id )
{
	if ( _type == 1 )
	{
	    SendClientMessage(playerid, 0xFFFFFFFF, "Вы успешно заправили свой транспорт.");
		me_action ( playerid, "заправил(-а) свою машину." ) ;
	}
	else if ( _type == 2 )
	{
	    SendClientMessage(playerid, -1, "Вы успешно починили свой транспорт.");
	    RepairVehicle ( vehicle_id ) ;

		me_action ( playerid, "отремонтировал(-а) свою машину." ) ;
	}

	KillTimer ( p_info [ playerid ] [ back_timer ] ) ;
	p_info [ playerid ] [ back_timer ] = -1 ;
	return 1 ;
}

CMD:tr ( playerid, params [ ] ) // bus
{
	if ( p_info [ playerid ] [ job ] == job_none ) return 1 ;
	if ( b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_type ] != bizz_type_taxi &&
		b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_type ] != bizz_type_bus ) return 1 ;
	
	/*if ( p_info [ playerid ] [ mute ] )
	{
		new scm_string [ 38 ] ;
		format ( scm_string, sizeof ( scm_string ),"У вас бан чата | %d секунд(ы)", p_info [ playerid ] [ mute ] ) ;
		SendClientMessage ( playerid, col_light_red, scm_string ) ;
		return true ;
	}*/
	if ( sscanf ( params, "s[100]", params [ 0 ] ) )return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /tr [текст]" ) ;

	if ( b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_type ] == bizz_type_taxi )
	{
		new rank_name [ 20 ], scm_string [ 144 ] ;
		if ( p_info [ playerid ] [ taxi_skill ] >= 0 && p_info [ playerid ] [ taxi_skill ] <= 199 )	rank_name = "Водила бич класса" ;
		else if ( p_info [ playerid ] [ taxi_skill ] >= 200 && p_info [ playerid ] [ taxi_skill ] <= 399 )rank_name = "Водила дрочила" ;
		else rank_name = "Элитный пидрила" ;

		format ( scm_string, sizeof scm_string, "[%s] %s %s: %s", b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_name ], rank_name, p_info [ playerid ] [ name ], params [ 0 ] ) ;
		foreach(new i: logged_players) if ( p_info [ i ] [ job ] == p_info [ playerid ] [ job ] ) SendClientMessage ( i, 0xAA3333FF, scm_string ) ;

		format(scm_string, sizeof scm_string, "сказал(а) в рацию: {FFFFFF}%s", params [ 0 ]);
		SetPlayerChatBubble(playerid, scm_string, col_light_purple, 13.0, 5000);
	}
	else if ( b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_type ] == bizz_type_bus )
	{
	    new scm_string [ 144 ] ;
		format ( scm_string, sizeof scm_string, "[%s] %s: %s", b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_name ], p_info [ playerid ] [ name ], params [ 0 ] ) ;
		foreach(new i: logged_players) if ( p_info [ i ] [ job ] == p_info [ playerid ] [ job ] ) SendClientMessage ( i, 0xAA3333FF, scm_string ) ;

		format(scm_string, sizeof scm_string, "сказал(а) в рацию: {FFFFFF}%s", params [ 0 ]);
		SetPlayerChatBubble(playerid, scm_string, col_light_purple, 13.0, 5000);
	}
	return 1 ;
}

CMD:phone ( playerid )
{
	show_dialog ( playerid, d_phone, DIALOG_STYLE_LIST, "{FFCC00}Телефон", "{FFCC00}1. {FFFFFF}Отправить СМС\n{FFCC00}2. {FFFFFF}Диалоги", "Выбрать", "Закрыть" ) ;
	return 1 ;
}

forward callback_message ( playerid ) ;
public callback_message ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		SendClientMessage ( playerid, 0xFF6600FF, !"СМС сообщения не найдены." ) ;
		callcmd::phone ( playerid ) ;
		page_count [ playerid ] = 0 ;
		return 1 ;
	}
	new rows_list = page_count [ playerid ] - 1 ;
	page_rows [ playerid ] = rows ;

	global_string [ 0 ] = EOS ;
	new line_string [ MAX_PLAYER_NAME + 128 ],
		u_name [ 24 ], from_name [ 24 ], row_count ;
	for ( new i = rows_list * 10 ; i <  rows_list * 10 + 10 ; i ++ )
	{
		if ( i >= rows ) break ;

		new inc_id = cache_get_field_content_int ( i, "inc_id", sql_connection ) ;
		new text_status = cache_get_field_content_int ( i, "text_status", sql_connection ) ;
		new u_id = cache_get_field_content_int ( i, "u_id", sql_connection ) ;
		cache_get_field_content ( i, "u_name", u_name, sql_connection, 24 ) ;
		cache_get_field_content ( i, "from_name", from_name, sql_connection, 24 ) ;
		
		SetPlayerListitemValue ( playerid, i - rows_list * 10, inc_id ) ;


		if ( u_id == p_info [ playerid ] [ id ] ) format ( line_string, sizeof ( line_string ), "Сообщение от {FFCC00}%s {FFFFFF}(%s)\n", from_name, ( text_status ) ? ( "Прочитано" ) : ( "Не прочитано" ) ) ;
		else format ( line_string, sizeof ( line_string ), "Сообщение к {FFCC00}%s {FFFFFF}(%s)\n", u_name, ( text_status ) ? ( "Прочитано" ) : ( "Не прочитано" ) ) ;
		strcat ( global_string, line_string ) ;

		row_count ++ ;
	}

	if ( rows_list > 0 )
	{
		strcat ( global_string, "{FFCC00}Предыдущая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 0 ) ;
		row_count ++ ;
	}
	if ( ofm_formula ( page_count [ playerid ] ) < rows )
	{
		strcat ( global_string, "{FFCC00}Следующая страница\n" ) ;
		set_player_use_page ( playerid, row_count, 1 ) ;
	}

	show_dialog ( playerid, d_message, DIALOG_STYLE_LIST, "{FFCC00}СМС сообщения", global_string, "Выбрать", "Назад" ) ;
	return 1 ;
}

forward callback_message_info ( playerid ) ;
public callback_message_info ( playerid )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		SendClientMessage ( playerid, 0xFF6600FF, !"СМС сообщения не найдены." ) ;
		callcmd::phone ( playerid ) ;
		page_count [ playerid ] = 0 ;
		ClearPlayerListitemValues ( playerid ) ;
		return 1 ;
	}

	new line_string [ MAX_PLAYER_NAME + 100 + 100 ],
		u_name [ 24 ], from_name [ 24 ], text_message [ 100 ] ;

    new inc_id = cache_get_field_content_int ( 0, "inc_id", sql_connection ) ;
	new u_id = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;
	cache_get_field_content ( 0, "u_name", u_name, sql_connection, 24 ) ;
	cache_get_field_content ( 0, "from_name", from_name, sql_connection, 24 ) ;
	cache_get_field_content ( 0, "text_message", text_message, sql_connection, 100 ) ;

	if ( u_id == p_info [ playerid ] [ id ] )
	{
		format ( line_string, sizeof ( line_string ), "{FFFFFF}Сообщение от {FFCC00}%s{FFFFFF}.\nТекст: {FFCC00}%s{FFFFFF}\n\n{828282}* Если Вы хотите ответить, то введите сообщение:", from_name ) ;
	}
	else
	{
		format ( line_string, sizeof ( line_string ), "{FFFFFF}Сообщение к {FFCC00}%s{FFFFFF}.\nТекст: {FFCC00}%s{FFFFFF}\n\n{828282}* Если Вы хотите ответить, то введите сообщение:", u_name ) ;
	}
	show_dialog ( playerid, d_message_input, DIALOG_STYLE_INPUT, "{FFCC00}СМС сообщения", line_string, "Выбрать", "Назад" ) ;
	
	new sql_string [ 79 + 9 ] ;
 	format ( sql_string, sizeof sql_string, "UPDATE `users_message` SET `text_status` = '1' WHERE `inc_id` = '%d' LIMIT 1", inc_id ) ;
   	mysql_tquery ( sql_connection, sql_string ) ;
	return 1 ;
}

forward callback_message_insert ( playerid, _text [ ] ) ;
public callback_message_insert ( playerid, _text [ ] )
{
	new rows, fields ;
	cache_get_data ( rows, fields ) ;
	if ( ! rows )
	{
		SendClientMessage ( playerid, 0xFF6600FF, !"СМС сообщения не найдены." ) ;
		callcmd::phone ( playerid ) ;
		page_count [ playerid ] = 0 ;
		ClearPlayerListitemValues ( playerid ) ;
		return 1 ;
	}

	new u_name [ 24 ], from_name [ 24 ], text_message [ 100 ] ;

	new u_id = cache_get_field_content_int ( 0, "u_id", sql_connection ) ;
	new from_id = cache_get_field_content_int ( 0, "from_id", sql_connection ) ;
	new phone_number = cache_get_field_content_int ( 0, "phone_number", sql_connection ) ;
	new from_number = cache_get_field_content_int ( 0, "from_number", sql_connection ) ;
	cache_get_field_content ( 0, "u_name", u_name, sql_connection, 24 ) ;
	cache_get_field_content ( 0, "from_name", from_name, sql_connection, 24 ) ;
	cache_get_field_content ( 0, "text_message", text_message, sql_connection, 100 ) ;

	global_string [ 0 ] = EOS ;
 	format ( global_string, sizeof ( global_string ), "INSERT INTO `users_message` (`u_id`,`u_name`,`phone_number`,`text_message`,`from_id`,`from_number`,`from_name`,`text_status`) VALUES ('%d','%s','%d','%s','%d','%d','%s','0')",
	u_id, u_name, phone_number, _text, from_id, from_number, from_name ) ;
	mysql_tquery ( sql_connection, global_string ) ;

	new scm_string [ 128 ] ;
	if ( u_id == p_info [ playerid ] [ id ] )
	{
	    new _pl_id ;
		sscanf ( from_name, "u", _pl_id ) ;
	    if ( IsPlayerConnected ( _pl_id ) ) SendClientMessage ( _pl_id, 0xFFCC00FF, "Вам поступило СМС сообщение. Используйте /phone - Диалоги." ) ;
		format ( scm_string, sizeof scm_string, "Вы отправили сообщение на номер {FFFFFF}%d{FFCC00}.", from_number ) ;
	}
	else
	{
		new _pl_id ;
		sscanf ( u_name, "u", _pl_id ) ;
	    if ( IsPlayerConnected ( _pl_id ) ) SendClientMessage ( _pl_id, 0xFFCC00FF, "Вам поступило СМС сообщение. Используйте /phone - Диалоги." ) ;
		format ( scm_string, sizeof scm_string, "Вы отправили сообщение на номер {FFFFFF}%d{FFCC00}.", phone_number ) ;
	}
	SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

	format ( scm_string, sizeof scm_string, "Текст: {FFFFFF}%s{FFCC00}.", _text ) ;
	SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;

	SendClientMessage ( playerid, 0xFFCC00FF, !"Вы можете отслеживать Ваше сообщение в /phone - Диалоги." ) ;

	callcmd::phone ( playerid ) ;
	return 1 ;
}

CMD:usedrugs ( playerid, params [ ] )
{
    //if ( target_cuff [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы в наручниках." ) ;
	//if ( target_tie [ playerid ] != INVALID_PLAYER_ID )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы связаны." ) ;
	if ( is_drug_effect { playerid } >= 1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы употребляете наркотики слишком часто." ) ;

	if ( p_info [ playerid ] [ p_disease ] < 500 )
	{
		params [ 0 ] = 1 ;
	}
	else if ( p_info [ playerid ] [ p_disease ] > 499 && p_info [ playerid ] [ p_disease ] < 1000 )
	{
		if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /usedrugs [1-2 грамм]" ) ;
	}
	else if ( p_info [ playerid ] [ p_disease ] > 999 && p_info [ playerid ] [ p_disease ] < 2000 )
	{
		if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /usedrugs [1-4 грамм]" ) ;
	}
	else if ( p_info [ playerid ] [ p_disease ] > 1999 && p_info [ playerid ] [ p_disease ] < 5000 )
	{
		if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /usedrugs [1-6 грамм]" ) ;
	}
	else
	{
		if ( sscanf ( params, "d", params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /usedrugs [1-7 грамм]" ) ;
	}

 	if ( p_info [ playerid ] [ drugs ] < params [ 0 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"У Вас не хватает наркотиков." ) ;
	if ( p_info [ playerid ] [ p_disease ] < 700 )
	{
	    SetPlayerTime ( playerid, 17, 0 ) ;
		SetPlayerDrunkLevel ( playerid, 3000 ) ;
		SetPlayerWeather ( playerid, - 68 ) ;
	}
	
	is_drug_effect { playerid } = 60 ;

	p_info [ playerid ] [ drugs ] -= params [ 0 ] ;
	update_int_sql ( playerid, "u_drugs", p_info [ playerid ] [ drugs ] ) ;

    if ( GetPlayerState ( playerid ) == PLAYER_STATE_ONFOOT ) ApplyAnimation ( playerid, "SMOKING", "M_smk_drag", 4.1, 0, 0, 0, 0, 0, 1 ) ;

	new Float:pl_health ;
	GetPlayerHealth ( playerid, pl_health ) ;
	if ( pl_health + ( 25 * params [ 0 ] ) > 100 ) set_health ( playerid, 100 ) ;
	else set_health ( playerid, pl_health + ( 25 * params [ 0 ] ) ) ;

	p_info [ playerid ] [ p_disease ] += 5 ;
	update_int_sql ( playerid, "u_disease", p_info [ playerid ] [ p_disease ] ) ;
	
	p_info [ playerid ] [ send_crack ] = 0 ;
	
	if ( p_info [ playerid ] [ p_drugs_healing ] )
	{
	    p_info [ playerid ] [ p_drugs_healing ] = 0 ;
		update_int_sql ( playerid, "u_drugs_healing", p_info [ playerid ] [ p_drugs_healing ] ) ;
	}

	new scm_string [ 61 + 4 + 4 ] ;
	format ( scm_string, sizeof scm_string, "Вы пополнили здоровье на %d пунктов. Уровень здоровья: %d.", ( 25 * params [ 0 ] ), ( pl_health + ( 25 * params [ 0 ] ) > 100 ) ? ( 100 ) : ( floatround ( pl_health + ( 25 * params [ 0 ] ) ) ) ) ;
	SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
	format ( scm_string, 35, "~y~you have~n~~b~%d~g~ drugs", p_info [ playerid ] [ drugs ] ) ;
	GameTextForPlayer ( playerid, scm_string, 2000, 1 ) ;

	me_action ( playerid, "принимает дозу наркотиков" ) ;
	return 1 ;
}

CMD:drugs_healing ( playerid, params [ ] )
{
	//if ( ! medic_player ( playerid ) ) return 1 ;
	if ( sscanf ( params, "u", params [ 0 ] ) ) return SendClientMessage ( playerid, 0xFF6600FF, !"Используйте: /drugs_healing [id]" ) ;

	if ( ! IsPlayerConnected ( params [ 0 ] ) || playerid == params [ 0 ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Неверно указан ID игрока." ) ;
    if ( ! IsPlayerInRangeOfPoint ( playerid, 5, p_t_info [ params [ 0 ] ][ p_pos ] [ 0 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 1 ], p_t_info [ params [ 0 ] ][ p_pos ] [ 2 ] ) || GetPlayerVirtualWorld ( playerid ) != GetPlayerVirtualWorld ( params [ 0 ] ) )
				return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок слишком далеко." ) ;
				
	if ( ! p_info [ params [ 0 ] ] [ p_disease ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок не зависим." ) ;
	if ( p_info [ params [ 0 ] ] [ p_disease_cooldown ] ) return SendClientMessage ( playerid, 0xFF6600FF, !"Игрок уже проходил сеанс. (Сеанс доступен раз в час)" ) ;

    buyer_id [ playerid ] = params [ 0 ] ;
	seller_id [ params [ 0 ] ] = playerid ;

	new dialog_string [ 77 + MAX_PLAYER_NAME ] ;
	format ( dialog_string, sizeof ( dialog_string  ), "{FFCC00}%s {FFFFFF}предлагает Вам пройти курс лечения от наркозависимости.",
	p_info [ playerid ] [ name ] ) ;
	show_dialog ( params [ 0 ], d_healing_accept, DIALOG_STYLE_MSGBOX, "{FFCC00}Лечение", dialog_string, "Согласен", "Отказ" ) ;

	format ( dialog_string, sizeof ( dialog_string  ), "Вы предложили {FFCC00}%s {FFFFFF}пройти курс лечения от наркозависимости.",
	p_info [ params [ 0 ] ] [ name ] ) ;
	SendClientMessage ( playerid, -1, dialog_string ) ;
	return 1 ;
}

stock accesories_inventory ( playerid, bool: status )
{
	if ( status )
	{
	    //new _page_id = accesories_page [ playerid ] ;
	
		new td_string [ 32 ] ;
		//if ( p_info [ playerid ] [ accessories ] [ _page_id ] == 0 ) format ( td_string, sizeof td_string, " " ) ;
		//else format ( td_string, sizeof td_string, "%s", get_accessorie_name ( p_info [ playerid ] [ accessories ] [ _page_id ] ) ) ;
	    mainmenu_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 305.0000, 75.0000, td_string); // акс 1
		PlayerTextDrawTextSize(playerid, mainmenu_ptd[playerid][0], 25.0000, 30.0000);
		PlayerTextDrawAlignment(playerid, mainmenu_ptd[playerid][0], 1);
		PlayerTextDrawColor(playerid, mainmenu_ptd[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, mainmenu_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, mainmenu_ptd[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, mainmenu_ptd[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, mainmenu_ptd[playerid][0], 0);

        //_page_id ++ ;
		//if ( p_info [ playerid ] [ accessories ] [ _page_id ] == 0 ) format ( td_string, sizeof td_string, " " ) ;
		//else format ( td_string, sizeof td_string, "%s", get_accessorie_name ( p_info [ playerid ] [ accessories ] [ _page_id ] ) ) ;
		mainmenu_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 346.0000, 75.0000, td_string); // акс 2
		PlayerTextDrawTextSize(playerid, mainmenu_ptd[playerid][1], 25.0000, 30.0000);
		PlayerTextDrawAlignment(playerid, mainmenu_ptd[playerid][1], 1);
		PlayerTextDrawColor(playerid, mainmenu_ptd[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, mainmenu_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, mainmenu_ptd[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, mainmenu_ptd[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, mainmenu_ptd[playerid][1], 0);

        //_page_id ++ ;
		//if ( p_info [ playerid ] [ accessories ] [ _page_id ] == 0 ) format ( td_string, sizeof td_string, " " ) ;
		//else format ( td_string, sizeof td_string, "%s", get_accessorie_name ( p_info [ playerid ] [ accessories ] [ _page_id ] ) ) ;
		mainmenu_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 393.0000, 75.0000, td_string); // акс 3
		PlayerTextDrawTextSize(playerid, mainmenu_ptd[playerid][2], 25.0000, 30.0000);
		PlayerTextDrawAlignment(playerid, mainmenu_ptd[playerid][2], 1);
		PlayerTextDrawColor(playerid, mainmenu_ptd[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, mainmenu_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, mainmenu_ptd[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, mainmenu_ptd[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, mainmenu_ptd[playerid][2], 0);

        //_page_id ++ ;
		//if ( p_info [ playerid ] [ accessories ] [ _page_id ] == 0 ) format ( td_string, sizeof td_string, " " ) ;
		//else format ( td_string, sizeof td_string, "%s", get_accessorie_name ( p_info [ playerid ] [ accessories ] [ _page_id ] ) ) ;
		mainmenu_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 437.0000, 75.0000, td_string); // акс 4
		PlayerTextDrawTextSize(playerid, mainmenu_ptd[playerid][3], 25.0000, 30.0000);
		PlayerTextDrawAlignment(playerid, mainmenu_ptd[playerid][3], 1);
		PlayerTextDrawColor(playerid, mainmenu_ptd[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, mainmenu_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, mainmenu_ptd[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, mainmenu_ptd[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, mainmenu_ptd[playerid][3], 0);

		for ( new i = 0 ; i < 4 ; i ++ )
		{
			PlayerTextDrawShow ( playerid, mainmenu_ptd [ playerid ] [ i ] ) ;
		}
	}
	else
	{
	    for ( new i = 0 ; i < 4 ; i ++ )
		{
			PlayerTextDrawDestroy ( playerid, mainmenu_ptd [ playerid ] [ i ] ) ;
			mainmenu_ptd [ playerid ] [ i ] = PlayerText:-1 ;
		}
	}
	return 1 ;
}

public OnPlayerClickTextDraw ( playerid, Text:clickedid )
{
	if ( use_mainmenu [ playerid ] )
	{
	    if ( clickedid == mainmenu_td [ 6 ] )
	    {
	        if ( accesories_page [ playerid ] == 0 ) return 1 ;

            accesories_page [ playerid ] -- ;
            
            accesories_inventory ( playerid, false ) ;
            accesories_inventory ( playerid, true ) ;
	    }
	    else if ( clickedid == mainmenu_td [ 7 ] )
	    {
	        if ( accesories_page [ playerid ] == 4 ) return 1 ;

            accesories_page [ playerid ] ++ ;
            
            accesories_inventory ( playerid, false ) ;
            accesories_inventory ( playerid, true ) ;
	    }
	    else if ( clickedid == mainmenu_td [ 32 ] )
	    {
	        if ( mainmenu_page [ playerid ] == 1 ) return 1 ;
	        
	        hiding_pages ( playerid, mainmenu_page [ playerid ] ) ;
	        
	        mainmenu_page [ playerid ] = 1 ;
	        showing_pages ( playerid, mainmenu_page [ playerid ] ) ;
	    }
	    else if ( clickedid == mainmenu_td [ 33 ] )
	    {
	        if ( mainmenu_page [ playerid ] == 2 ) return 1 ;

	        hiding_pages ( playerid, mainmenu_page [ playerid ] ) ;

	        mainmenu_page [ playerid ] = 2 ;
	        showing_pages ( playerid, mainmenu_page [ playerid ] ) ;
	    }
	    else if ( clickedid == mainmenu_td [ 34 ] )
	    {
	        if ( mainmenu_page [ playerid ] == 3 ) return 1 ;

	        hiding_pages ( playerid, mainmenu_page [ playerid ] ) ;

	        mainmenu_page [ playerid ] = 3 ;
	        showing_pages ( playerid, mainmenu_page [ playerid ] ) ;
	    }
	    else if ( clickedid == mainmenu_td [ 35 ] )
	    {
	        if ( mainmenu_page [ playerid ] == 4 ) return 1 ;

	        hiding_pages ( playerid, mainmenu_page [ playerid ] ) ;

	        mainmenu_page [ playerid ] = 4 ;
	        showing_pages ( playerid, mainmenu_page [ playerid ] ) ;
	    }
	    else if ( clickedid == mainmenu_td [ 36 ] )
	    {
	        if ( mainmenu_page [ playerid ] == 5 ) return 1 ;

	        hiding_pages ( playerid, mainmenu_page [ playerid ] ) ;

	        mainmenu_page [ playerid ] = 5 ;
	        showing_pages ( playerid, mainmenu_page [ playerid ] ) ;
	    }
	    else if ( clickedid == mainmenu_td [ 37 ] )
	    {
	        if ( mainmenu_page [ playerid ] == 6 ) return 1 ;

	        hiding_pages ( playerid, mainmenu_page [ playerid ] ) ;

	        mainmenu_page [ playerid ] = 6 ;
	        showing_pages ( playerid, mainmenu_page [ playerid ] ) ;
	    }
	}
	return 1 ;
}

stock hiding_pages ( playerid, _page_id )
{
	if ( _page_id == 1 ) _inventory_ptd ( playerid, false ) ;
	else if ( _page_id == 2 ) _craft_ptd ( playerid, false ) ;
	else if ( _page_id == 3 ) _trade_ptd ( playerid, false ) ;
	else if ( _page_id == 4 ) _house_ptd ( playerid, false ) ;
	else if ( _page_id == 5 ) _car_ptd ( playerid, false ) ;
	else if ( _page_id == 6 ) _business_ptd ( playerid, false ) ;
	return 1 ;
}

stock showing_pages ( playerid, _page_id )
{
	if ( _page_id == 1 ) _inventory_ptd ( playerid, true ) ;
	else if ( _page_id == 2 ) _craft_ptd ( playerid, true ) ;
	else if ( _page_id == 3 ) _trade_ptd ( playerid, true ) ;
	else if ( _page_id == 4 ) _house_ptd ( playerid, true ) ;
	else if ( _page_id == 5 ) _car_ptd ( playerid, true ) ;
	else if ( _page_id == 6 ) _business_ptd ( playerid, true ) ;
	return 1 ;
}

CMD:mm1 ( playerid )
{
	use_mainmenu [ playerid ] = true ;
	mainmenu_page [ playerid ] = 1 ;
	accesories_page [ playerid ] = 0 ;
	
    _mainmenu_ptd ( playerid, true ) ;
    _inventory_ptd ( playerid, true ) ;
	return 1 ;
}

stock _mainmenu_ptd ( playerid, bool: status )
{
	if ( status )
	{
	    accesories_inventory ( playerid, true ) ;
	
		for ( new i = 0 ; i < 38 ; i ++ )
		{
			TextDrawShowForPlayer ( playerid, mainmenu_td [ i ] ) ;
		}

		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    accesories_inventory ( playerid, false ) ;
	
	    for ( new i = 0 ; i < 38 ; i ++ )
		{
			TextDrawShowForPlayer ( playerid, mainmenu_td [ i ] ) ;
		}

		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

stock _inventory_ptd ( playerid, bool: status )
{
	if ( status )
	{
	    inventory_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 224.0000, 155.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][0], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][0], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][0], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][0], true);

		inventory_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 290.0000, 155.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][1], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][1], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][1], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][1], true);

		inventory_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 352.0000, 155.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][2], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][2], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][2], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][2], true);

		inventory_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 418.0000, 155.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][3], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][3], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][3], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][3], true);

		inventory_ptd[playerid][4] = CreatePlayerTextDraw(playerid, 483.0000, 155.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][4], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][4], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][4], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][4], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][4], true);

		inventory_ptd[playerid][5] = CreatePlayerTextDraw(playerid, 224.0000, 261.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][5], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][5], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][5], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][5], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][5], true);

		inventory_ptd[playerid][6] = CreatePlayerTextDraw(playerid, 290.0000, 261.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][6], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][6], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][6], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][6], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][6], true);

		inventory_ptd[playerid][7] = CreatePlayerTextDraw(playerid, 352.0000, 261.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][7], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][7], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][7], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][7], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][7], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][7], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][7], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][7], true);

		inventory_ptd[playerid][8] = CreatePlayerTextDraw(playerid, 418.0000, 261.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][8], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][8], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][8], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][8], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][8], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][8], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][8], true);

		inventory_ptd[playerid][9] = CreatePlayerTextDraw(playerid, 483.0000, 261.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][9], 58.0000, 73.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][9], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][9], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][9], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][9], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][9], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][9], 0);
		PlayerTextDrawSetSelectable(playerid, inventory_ptd[playerid][9], true);

		inventory_ptd[playerid][10] = CreatePlayerTextDraw(playerid, 237.0000, 171.0000, "LD_SPAC:b_inv_cbackpack_1"); // акс 1
		PlayerTextDrawTextSize(playerid, inventory_ptd[playerid][10], 33.0000, 39.0000);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][10], 1);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][10], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][10], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][10], 4);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][10], 0);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][10], 0);

		inventory_ptd[playerid][11] = CreatePlayerTextDraw(playerid, 255.0000, 236.0000, "HaЯ?aЃЬe~n~?peЪѓe¶a"); // пусто
		PlayerTextDrawLetterSize(playerid, inventory_ptd[playerid][11], 0.2340, 1.0762);
		PlayerTextDrawAlignment(playerid, inventory_ptd[playerid][11], 2);
		PlayerTextDrawColor(playerid, inventory_ptd[playerid][11], -1);
		PlayerTextDrawBackgroundColor(playerid, inventory_ptd[playerid][11], 255);
		PlayerTextDrawFont(playerid, inventory_ptd[playerid][11], 1);
		PlayerTextDrawSetProportional(playerid, inventory_ptd[playerid][11], 1);
		PlayerTextDrawSetShadow(playerid, inventory_ptd[playerid][11], 0);

		for ( new i = 0 ; i < 12 ; i ++ )
		{
			if ( i < 5 ) TextDrawShowForPlayer ( playerid, inventory_td [ i ] ) ;
			PlayerTextDrawShow ( playerid, inventory_ptd [ playerid ] [ i ] ) ;
		}

		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    for ( new i = 0 ; i < 12 ; i ++ )
		{
			if ( i < 5 ) TextDrawHideForPlayer ( playerid, inventory_td [ i ] ) ;
			PlayerTextDrawDestroy ( playerid, inventory_ptd [ playerid ] [ i ] ) ;
			inventory_ptd [ playerid ] [ i ] = PlayerText:-1 ;
		}

		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

stock _craft_ptd ( playerid, bool: status )
{
	if ( status )
	{
	    craft_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 207.0000, 140.0000, "LD_SPAC:gl_ground"); // полоска выбора
		PlayerTextDrawTextSize(playerid, craft_ptd[playerid][0], 101.0000, 39.0000);
		PlayerTextDrawAlignment(playerid, craft_ptd[playerid][0], 1);
		PlayerTextDrawColor(playerid, craft_ptd[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, craft_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, craft_ptd[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, craft_ptd[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, craft_ptd[playerid][0], 0);

		craft_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 207.0000, 178.0000, "LD_SPAC:gl_ground"); // полоска выбора
		PlayerTextDrawTextSize(playerid, craft_ptd[playerid][1], 101.0000, 39.0000);
		PlayerTextDrawAlignment(playerid, craft_ptd[playerid][1], 1);
		PlayerTextDrawColor(playerid, craft_ptd[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, craft_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, craft_ptd[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, craft_ptd[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, craft_ptd[playerid][1], 0);

		craft_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 242.0000, 151.0000, "АoѓЧa"); // пусто
		PlayerTextDrawLetterSize(playerid, craft_ptd[playerid][2], 0.3319, 1.6259);
		PlayerTextDrawAlignment(playerid, craft_ptd[playerid][2], 1);
		PlayerTextDrawColor(playerid, craft_ptd[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, craft_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, craft_ptd[playerid][2], 1);
		PlayerTextDrawSetProportional(playerid, craft_ptd[playerid][2], 1);
		PlayerTextDrawSetShadow(playerid, craft_ptd[playerid][2], 0);

		craft_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 450.0000, 303.0000, "70%"); // пусто
		PlayerTextDrawLetterSize(playerid, craft_ptd[playerid][3], 0.2345, 1.2369);
		PlayerTextDrawAlignment(playerid, craft_ptd[playerid][3], 1);
		PlayerTextDrawColor(playerid, craft_ptd[playerid][3], -1523963137);
		PlayerTextDrawBackgroundColor(playerid, craft_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, craft_ptd[playerid][3], 1);
		PlayerTextDrawSetProportional(playerid, craft_ptd[playerid][3], 1);
		PlayerTextDrawSetShadow(playerid, craft_ptd[playerid][3], 0);

		craft_ptd[playerid][4] = CreatePlayerTextDraw(playerid, 320.0000, 193.0000, "LD_SPAC:b_inv_derevo"); // иконка что нужно
		PlayerTextDrawTextSize(playerid, craft_ptd[playerid][4], 19.0000, 24.0000);
		PlayerTextDrawAlignment(playerid, craft_ptd[playerid][4], 1);
		PlayerTextDrawColor(playerid, craft_ptd[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, craft_ptd[playerid][4], 255);
		PlayerTextDrawFont(playerid, craft_ptd[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, craft_ptd[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, craft_ptd[playerid][4], 0);

		craft_ptd[playerid][5] = CreatePlayerTextDraw(playerid, 330.0000, 232.0000, "0_/_1"); // пусто
		PlayerTextDrawLetterSize(playerid, craft_ptd[playerid][5], 0.1994, 1.0191);
		PlayerTextDrawAlignment(playerid, craft_ptd[playerid][5], 2);
		PlayerTextDrawColor(playerid, craft_ptd[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, craft_ptd[playerid][5], 255);
		PlayerTextDrawFont(playerid, craft_ptd[playerid][5], 1);
		PlayerTextDrawSetProportional(playerid, craft_ptd[playerid][5], 1);
		PlayerTextDrawSetShadow(playerid, craft_ptd[playerid][5], 0);

		craft_ptd[playerid][6] = CreatePlayerTextDraw(playerid, 344.0000, 316.0000, "LD_SPAC:b_inv_derevo"); // иконка итог
		PlayerTextDrawTextSize(playerid, craft_ptd[playerid][6], 23.0000, 31.0000);
		PlayerTextDrawAlignment(playerid, craft_ptd[playerid][6], 1);
		PlayerTextDrawColor(playerid, craft_ptd[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, craft_ptd[playerid][6], 255);
		PlayerTextDrawFont(playerid, craft_ptd[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, craft_ptd[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, craft_ptd[playerid][6], 0);

		for ( new i = 0 ; i < 21 ; i ++ )
		{
			TextDrawShowForPlayer ( playerid, craft_td [ i ] ) ;
			if ( i < 7 ) PlayerTextDrawShow ( playerid, craft_ptd [ playerid ] [ i ] ) ;
		}

		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    for ( new i = 0 ; i < 21 ; i ++ )
		{
		    TextDrawHideForPlayer ( playerid, craft_td [ i ] ) ;
			if ( i < 7 )
			{
				PlayerTextDrawDestroy ( playerid, craft_ptd [ playerid ] [ i ] ) ;
				craft_ptd [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}

		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

stock _trade_ptd ( playerid, bool: status )
{
	if ( status )
	{
     	trade_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 295.0000, 150.0000, "Nick_Name"); // пусто
		PlayerTextDrawLetterSize(playerid, trade_ptd[playerid][0], 0.3325, 1.5325);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][0], 2);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][0], 1);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][0], 1);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][0], 0);

		trade_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 475.0000, 150.0000, "Nick_Name"); // пусто
		PlayerTextDrawLetterSize(playerid, trade_ptd[playerid][1], 0.3325, 1.5325);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][1], 2);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][1], 1);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][1], 1);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][1], 0);

		trade_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 276.0000, 323.0000, "LD_SPAC:gl_no"); // пусто
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][2], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][2], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][2], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][2], true);

		trade_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 451.0000, 323.0000, "LD_SPAC:gl_yes"); // пусто
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][3], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][3], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][3], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][3], true);

		trade_ptd[playerid][4] = CreatePlayerTextDraw(playerid, 229.0000, 204.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][4], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][4], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][4], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][4], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][4], true);

		trade_ptd[playerid][5] = CreatePlayerTextDraw(playerid, 277.0000, 204.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][5], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][5], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][5], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][5], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][5], true);

		trade_ptd[playerid][6] = CreatePlayerTextDraw(playerid, 325.0000, 204.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][6], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][6], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][6], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][6], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][6], true);

		trade_ptd[playerid][7] = CreatePlayerTextDraw(playerid, 229.0000, 264.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][7], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][7], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][7], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][7], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][7], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][7], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][7], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][7], true);

		trade_ptd[playerid][8] = CreatePlayerTextDraw(playerid, 277.0000, 264.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][8], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][8], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][8], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][8], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][8], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][8], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][8], true);

		trade_ptd[playerid][9] = CreatePlayerTextDraw(playerid, 325.0000, 264.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][9], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][9], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][9], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][9], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][9], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][9], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][9], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][9], true);

		trade_ptd[playerid][10] = CreatePlayerTextDraw(playerid, 229.0000, 323.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][10], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][10], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][10], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][10], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][10], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][10], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][10], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][10], true);

		trade_ptd[playerid][11] = CreatePlayerTextDraw(playerid, 325.0000, 323.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][11], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][11], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][11], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][11], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][11], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][11], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][11], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][11], true);

		trade_ptd[playerid][12] = CreatePlayerTextDraw(playerid, 402.0000, 204.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][12], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][12], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][12], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][12], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][12], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][12], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][12], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][12], true);

		trade_ptd[playerid][13] = CreatePlayerTextDraw(playerid, 451.0000, 204.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][13], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][13], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][13], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][13], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][13], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][13], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][13], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][13], true);

		trade_ptd[playerid][14] = CreatePlayerTextDraw(playerid, 498.0000, 204.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][14], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][14], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][14], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][14], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][14], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][14], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][14], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][14], true);

		trade_ptd[playerid][15] = CreatePlayerTextDraw(playerid, 402.0000, 264.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][15], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][15], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][15], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][15], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][15], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][15], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][15], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][15], true);

		trade_ptd[playerid][16] = CreatePlayerTextDraw(playerid, 450.0000, 264.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][16], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][16], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][16], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][16], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][16], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][16], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][16], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][16], true);

		trade_ptd[playerid][17] = CreatePlayerTextDraw(playerid, 498.0000, 264.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][17], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][17], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][17], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][17], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][17], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][17], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][17], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][17], true);

		trade_ptd[playerid][18] = CreatePlayerTextDraw(playerid, 402.0000, 326.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][18], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][18], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][18], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][18], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][18], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][18], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][18], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][18], true);

		trade_ptd[playerid][19] = CreatePlayerTextDraw(playerid, 498.0000, 326.0000, "LD_SPAC:gl_box"); // бокс акс
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][19], 35.0000, 44.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][19], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][19], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][19], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][19], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][19], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][19], 0);
		PlayerTextDrawSetSelectable(playerid, trade_ptd[playerid][19], true);

		trade_ptd[playerid][20] = CreatePlayerTextDraw(playerid, 246.0000, 250.0000, "Hay•ЃЬkЬ_JBL"); // пусто
		PlayerTextDrawLetterSize(playerid, trade_ptd[playerid][20], 0.1474, 0.8377);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][20], 2);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][20], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][20], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][20], 1);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][20], 1);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][20], 0);

		trade_ptd[playerid][21] = CreatePlayerTextDraw(playerid, 233.0000, 208.0000, "LD_SPAC:trade_item"); // пусто
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][21], 26.0000, 36.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][21], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][21], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][21], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][21], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][21], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][21], 0);

		trade_ptd[playerid][22] = CreatePlayerTextDraw(playerid, 286.0000, 212.0000, "LD_SPAC:trade_money"); // пусто
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][22], 18.0000, 27.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][22], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][22], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][22], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][22], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][22], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][22], 0);

		trade_ptd[playerid][23] = CreatePlayerTextDraw(playerid, 333.0000, 212.0000, "LD_SPAC:trade_house"); // пусто
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][23], 18.0000, 27.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][23], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][23], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][23], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][23], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][23], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][23], 0);

		trade_ptd[playerid][24] = CreatePlayerTextDraw(playerid, 235.0000, 268.0000, "LD_SPAC:trade_car"); // пусто
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][24], 23.0000, 36.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][24], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][24], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][24], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][24], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][24], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][24], 0);

		trade_ptd[playerid][25] = CreatePlayerTextDraw(playerid, 286.0000, 275.0000, "LD_SPAC:gl_business"); // пусто
		PlayerTextDrawTextSize(playerid, trade_ptd[playerid][25], 17.0000, 21.0000);
		PlayerTextDrawAlignment(playerid, trade_ptd[playerid][25], 1);
		PlayerTextDrawColor(playerid, trade_ptd[playerid][25], -1);
		PlayerTextDrawBackgroundColor(playerid, trade_ptd[playerid][25], 255);
		PlayerTextDrawFont(playerid, trade_ptd[playerid][25], 4);
		PlayerTextDrawSetProportional(playerid, trade_ptd[playerid][25], 0);
		PlayerTextDrawSetShadow(playerid, trade_ptd[playerid][25], 0);

		for ( new i = 0 ; i < 26 ; i ++ )
		{
			if ( i < 5 ) TextDrawShowForPlayer ( playerid, trade_td [ i ] ) ;
			PlayerTextDrawShow ( playerid, trade_ptd [ playerid ] [ i ] ) ;
		}

		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    for ( new i = 0 ; i < 26 ; i ++ )
		{
			if ( i < 5 ) TextDrawHideForPlayer ( playerid, trade_td [ i ] ) ;

			PlayerTextDrawDestroy ( playerid, trade_ptd [ playerid ] [ i ] ) ;
			trade_ptd [ playerid ] [ i ] = PlayerText:-1 ;
		}

		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

stock _house_ptd ( playerid, bool: status )
{
	if ( status )
	{
     	house_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 270.0000, 197.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, house_ptd[playerid][0], 85.0000, 102.0000);
		PlayerTextDrawAlignment(playerid, house_ptd[playerid][0], 1);
		PlayerTextDrawColor(playerid, house_ptd[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, house_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, house_ptd[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, house_ptd[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, house_ptd[playerid][0], 0);
		PlayerTextDrawSetSelectable(playerid, house_ptd[playerid][0], true);

		house_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 406.0000, 197.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, house_ptd[playerid][1], 85.0000, 102.0000);
		PlayerTextDrawAlignment(playerid, house_ptd[playerid][1], 1);
		PlayerTextDrawColor(playerid, house_ptd[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, house_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, house_ptd[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, house_ptd[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, house_ptd[playerid][1], 0);
		PlayerTextDrawSetSelectable(playerid, house_ptd[playerid][1], true);

		house_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 312.0000, 298.0000, "Гoѓ_27"); // пусто
		PlayerTextDrawLetterSize(playerid, house_ptd[playerid][2], 0.2657, 1.2474);
		PlayerTextDrawAlignment(playerid, house_ptd[playerid][2], 2);
		PlayerTextDrawColor(playerid, house_ptd[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, house_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, house_ptd[playerid][2], 1);
		PlayerTextDrawSetProportional(playerid, house_ptd[playerid][2], 1);
		PlayerTextDrawSetShadow(playerid, house_ptd[playerid][2], 0);

		house_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 449.0000, 298.0000, "O¶cy¶c¶?ye¶"); // пусто
		PlayerTextDrawLetterSize(playerid, house_ptd[playerid][3], 0.2657, 1.2474);
		PlayerTextDrawAlignment(playerid, house_ptd[playerid][3], 2);
		PlayerTextDrawColor(playerid, house_ptd[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, house_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, house_ptd[playerid][3], 1);
		PlayerTextDrawSetProportional(playerid, house_ptd[playerid][3], 1);
		PlayerTextDrawSetShadow(playerid, house_ptd[playerid][3], 0);

		for ( new i = 0 ; i < 4 ; i ++ )
		{
			if ( i < 2 ) TextDrawShowForPlayer ( playerid, house_td [ i ] ) ;
			PlayerTextDrawShow ( playerid, house_ptd [ playerid ] [ i ] ) ;
		}

		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    for ( new i = 0 ; i < 4 ; i ++ )
		{
			if ( i < 2 ) TextDrawHideForPlayer ( playerid, house_td [ i ] ) ;

			PlayerTextDrawDestroy ( playerid, house_ptd [ playerid ] [ i ] ) ;
			house_ptd [ playerid ] [ i ] = PlayerText:-1 ;
		}

		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

stock _car_ptd ( playerid, bool: status )
{
	if ( status )
	{
      	car_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 221.0000, 155.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][0], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][0], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][0], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][0], true);

		car_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 287.0000, 155.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][1], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][1], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][1], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][1], true);

		car_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 352.0000, 155.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][2], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][2], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][2], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][2], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][2], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][2], true);

		car_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 418.0000, 155.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][3], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][3], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][3], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][3], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][3], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][3], true);

		car_ptd[playerid][4] = CreatePlayerTextDraw(playerid, 484.0000, 155.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][4], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][4], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][4], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][4], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][4], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][4], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][4], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][4], true);

		car_ptd[playerid][5] = CreatePlayerTextDraw(playerid, 223.0000, 260.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][5], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][5], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][5], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][5], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][5], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][5], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][5], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][5], true);

		car_ptd[playerid][6] = CreatePlayerTextDraw(playerid, 287.0000, 260.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][6], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][6], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][6], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][6], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][6], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][6], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][6], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][6], true);

		car_ptd[playerid][7] = CreatePlayerTextDraw(playerid, 352.0000, 260.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][7], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][7], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][7], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][7], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][7], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][7], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][7], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][7], true);

		car_ptd[playerid][8] = CreatePlayerTextDraw(playerid, 418.0000, 260.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][8], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][8], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][8], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][8], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][8], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][8], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][8], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][8], true);

		car_ptd[playerid][9] = CreatePlayerTextDraw(playerid, 484.0000, 260.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][9], 61.0000, 74.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][9], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][9], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][9], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][9], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][9], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][9], 0);
		PlayerTextDrawSetSelectable(playerid, car_ptd[playerid][9], true);

		car_ptd[playerid][10] = CreatePlayerTextDraw(playerid, 251.0000, 229.0000, "BMW_M5"); // пусто
		PlayerTextDrawLetterSize(playerid, car_ptd[playerid][10], 0.2316, 1.2525);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][10], 2);
		PlayerTextDrawColor(playerid, car_ptd[playerid][10], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][10], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][10], 1);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][10], 1);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][10], 0);

		car_ptd[playerid][11] = CreatePlayerTextDraw(playerid, 236.0000, 176.0000, "LD_SPAC:global_car"); // пусто
		PlayerTextDrawTextSize(playerid, car_ptd[playerid][11], 31.0000, 37.0000);
		PlayerTextDrawAlignment(playerid, car_ptd[playerid][11], 1);
		PlayerTextDrawColor(playerid, car_ptd[playerid][11], -1);
		PlayerTextDrawBackgroundColor(playerid, car_ptd[playerid][11], 255);
		PlayerTextDrawFont(playerid, car_ptd[playerid][11], 4);
		PlayerTextDrawSetProportional(playerid, car_ptd[playerid][11], 0);
		PlayerTextDrawSetShadow(playerid, car_ptd[playerid][11], 0);

		for ( new i = 0 ; i < 12 ; i ++ )
		{
			if ( i < 4 ) TextDrawShowForPlayer ( playerid, car_td [ i ] ) ;
			PlayerTextDrawShow ( playerid, car_ptd [ playerid ] [ i ] ) ;
		}

		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    for ( new i = 0 ; i < 12 ; i ++ )
		{
			if ( i < 4 ) TextDrawHideForPlayer ( playerid, car_td [ i ] ) ;

			PlayerTextDrawDestroy ( playerid, car_ptd [ playerid ] [ i ] ) ;
			car_ptd [ playerid ] [ i ] = PlayerText:-1 ;
		}

		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

stock _business_ptd ( playerid, bool: status )
{
	if ( status )
	{
       	business_ptd[playerid][0] = CreatePlayerTextDraw(playerid, 270.0000, 197.0000, "LD_SPAC:gl_gray"); // пусто
		PlayerTextDrawTextSize(playerid, business_ptd[playerid][0], 85.0000, 102.0000);
		PlayerTextDrawAlignment(playerid, business_ptd[playerid][0], 1);
		PlayerTextDrawColor(playerid, business_ptd[playerid][0], -1);
		PlayerTextDrawBackgroundColor(playerid, business_ptd[playerid][0], 255);
		PlayerTextDrawFont(playerid, business_ptd[playerid][0], 4);
		PlayerTextDrawSetProportional(playerid, business_ptd[playerid][0], 0);
		PlayerTextDrawSetShadow(playerid, business_ptd[playerid][0], 0);
		PlayerTextDrawSetSelectable(playerid, business_ptd[playerid][0], true);

		business_ptd[playerid][1] = CreatePlayerTextDraw(playerid, 406.0000, 197.0000, "LD_SPAC:gl_red"); // пусто
		PlayerTextDrawTextSize(playerid, business_ptd[playerid][1], 85.0000, 102.0000);
		PlayerTextDrawAlignment(playerid, business_ptd[playerid][1], 1);
		PlayerTextDrawColor(playerid, business_ptd[playerid][1], -1);
		PlayerTextDrawBackgroundColor(playerid, business_ptd[playerid][1], 255);
		PlayerTextDrawFont(playerid, business_ptd[playerid][1], 4);
		PlayerTextDrawSetProportional(playerid, business_ptd[playerid][1], 0);
		PlayerTextDrawSetShadow(playerid, business_ptd[playerid][1], 0);
		PlayerTextDrawSetSelectable(playerid, business_ptd[playerid][1], true);

		business_ptd[playerid][2] = CreatePlayerTextDraw(playerid, 312.0000, 298.0000, "Гoѓ_27"); // пусто
		PlayerTextDrawLetterSize(playerid, business_ptd[playerid][2], 0.2657, 1.2474);
		PlayerTextDrawAlignment(playerid, business_ptd[playerid][2], 2);
		PlayerTextDrawColor(playerid, business_ptd[playerid][2], -1);
		PlayerTextDrawBackgroundColor(playerid, business_ptd[playerid][2], 255);
		PlayerTextDrawFont(playerid, business_ptd[playerid][2], 1);
		PlayerTextDrawSetProportional(playerid, business_ptd[playerid][2], 1);
		PlayerTextDrawSetShadow(playerid, business_ptd[playerid][2], 0);

		business_ptd[playerid][3] = CreatePlayerTextDraw(playerid, 449.0000, 298.0000, "O¶cy¶c¶?ye¶"); // пусто
		PlayerTextDrawLetterSize(playerid, business_ptd[playerid][3], 0.2657, 1.2474);
		PlayerTextDrawAlignment(playerid, business_ptd[playerid][3], 2);
		PlayerTextDrawColor(playerid, business_ptd[playerid][3], -1);
		PlayerTextDrawBackgroundColor(playerid, business_ptd[playerid][3], 255);
		PlayerTextDrawFont(playerid, business_ptd[playerid][3], 1);
		PlayerTextDrawSetProportional(playerid, business_ptd[playerid][3], 1);
		PlayerTextDrawSetShadow(playerid, business_ptd[playerid][3], 0);

		for ( new i = 0 ; i < 4 ; i ++ )
		{
			if ( i < 2 ) TextDrawShowForPlayer ( playerid, business_td [ i ] ) ;
			PlayerTextDrawShow ( playerid, business_ptd [ playerid ] [ i ] ) ;
		}

		SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
	}
	else
	{
	    for ( new i = 0 ; i < 4 ; i ++ )
		{
			if ( i < 2 ) TextDrawHideForPlayer ( playerid, business_td [ i ] ) ;

			PlayerTextDrawDestroy ( playerid, business_ptd [ playerid ] [ i ] ) ;
			business_ptd [ playerid ] [ i ] = PlayerText:-1 ;
		}

		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

/*CMD:route ( playerid ) // bus
{
	if ( p_info [ playerid ] [ job ] == job_none ) return 1 ;
	if ( b_info [ p_info [ playerid ] [ job ] - 1 ] [ b_type ] != bizz_type_bus ) return 1 ;
	if ( player_rentcar [ playerid ] == INVALID_VEHICLE_ID || player_rentcar [ playerid ] != player_vehicle [ playerid ] ) return 1 ;
	if ( veh_info [ player_rentcar [ playerid ] - 1 ] [ v_owner ] != p_info [ playerid ] [ job ] )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не в служебном транспорте!" ) ;
	return 1 ;
}

stock bus_delivery ( playerid )
{
	new _b_id = p_info [ playerid ] [ job ] ;
	new percent = floatround ( ( bus_info [ p_t_info [ playerid ] [ pBusRoute ] ] [ bus_price ] * b_info [ _b_id - 1 ] [ b_cost ] ) / 100 ),
		player_pay = bus_info [ p_t_info [ playerid ] [ pBusRoute ] ] [ bus_price ] - percent  ;
	p_info  [ playerid ] [ salary ] += player_pay ;
	
	b_info [ _b_id - 1 ] [ b_money ] += percent ;
    b_info [ _b_id - 1 ] [ b_cash_today ] += percent ;

   	p_info [ playerid ] [ day_money ] += player_pay ;
  	p_info [ playerid ] [ week_money ] += player_pay ;
   	p_info [ playerid ] [ month_money ] += player_pay ;
    p_info [ playerid ] [ all_money ] += player_pay ;
    
    b_info [ _b_id - 1 ] [ b_taxi_licenses ] ++ ;

	if ( b_info [ _b_id - 1 ] [ b_taxi_licenses ] == 100 && b_info [ _b_id - 1 ] [ b_taxi_level ] != max_taxi_level )
  	{
    	b_info [ _b_id - 1 ] [ b_taxi_level ] ++ ;
    	b_info [ _b_id - 1 ] [ b_taxi_licenses ] = 0 ;

		new _pl_id ;
		sscanf ( b_info [ _b_id - 1 ] [ b_owner_name ], "u", _pl_id ) ;

		if ( IsPlayerConnected ( _pl_id ) )
		{
		    new scm_string [ 96 + 4 ] ;
			format ( scm_string, sizeof scm_string, "У Вашего автобусного парка повысился уровень! Теперь Вам доступен автопарк из %d автомобилей.", b_info [ _b_id - 1 ] [ b_taxi_level ] ) ;
			SendClientMessage ( _pl_id, 0xFFCC00FF, scm_string ) ;
		}
   	}

   	new _sql_string [ 102 + 4 + 4 + 9 ] ;
    format ( _sql_string, sizeof _sql_string, "UPDATE `businesses` SET `b_taxi_licenses` = '%d', `b_taxi_level` = '%d' WHERE `b_id` = '%d' LIMIT 1", b_info [ _b_id - 1 ] [ b_taxi_licenses ], b_info [ _b_id - 1 ] [ b_taxi_level ], _b_id ) ;
	mysql_tquery ( sql_connection, _sql_string ) ;
	return 1 ;
}
*/

/*_deputy = cache_get_field_content_int ( i, "b_deputy", sql_connection ) ;
if ( _deputy != -1 ) format ( b_info [ i ] [ b_deputy ], MAX_PLAYER_NAME, "%s", get_player_name ( _deputy ) ) ;
else format ( b_info [ i ] [ b_deputy ], MAX_PLAYER_NAME, "Неизвестно" ) ;

stock get_player_name ( account_id )
{
	new _name [ MAX_PLAYER_NAME ] ;

	static const _str [ ] = "SELECT `u_name` FROM `users` WHERE `u_id` = '%d' LIMIT 1" ;
	new query_string [ sizeof _str + 24 ] ;
	format ( query_string, sizeof ( query_string ), _str, account_id ) ;
	new Cache:result = mysql_tquery ( sql_connection, query_string ) ;
	cache_get_field_content ( 0, "u_name", _name, sql_connection, MAX_PLAYER_NAME ) ;
	cache_delete ( result ) ;
	return _name ;
}*/

/*CMD:start_fool ( playerid )
{
	fool_table { playerid } = 1 ;
	new _table = fool_table { playerid } ;

	new _p_count = 0 ;
	for ( new i = 0 ; i < 6 ; i ++ )
	{
		_p_count ++ ;
		if ( fool_info [ _table ] [ f_player ] [ i ] != INVALID_PLAYER_ID ) continue ;

		fool_info [ _table ] [ f_player ] [ i ] = playerid ;
		break ;
	}

	if ( _p_count > 1 )
	{
	    page_count [ playerid ] = 1 ;
	    fool_info [ _table ] [ f_trump ] = give_card ( _table ) ;
	    fool_info [ _table ] [ f_team_trump ] = card_team ( fool_info [ _table ] [ f_trump ] ) ;
		fool_info [ _table ] [ f_move_pokriv ] = fool_info [ _table ] [ f_player ] [ 1 ] ;
		fool_info [ _table ] [ f_move ] = fool_info [ _table ] [ f_move_podkinul ] = fool_info [ _table ] [ f_player ] [ 0 ] ;
		for ( new i = 0 ; i < 6 ; i ++ )
		{
			if ( fool_info [ _table ] [ f_player ] [ i ] == INVALID_PLAYER_ID ) continue ;

			fool_used [ fool_info [ _table ] [ f_player ] [ i ] ] = true ;
			show_fool_ptd ( fool_info [ _table ] [ f_player ] [ i ], _table, true ) ;
		}
	}
	return 1 ;
}*/

CMD:power ( playerid )
{
	show_stats ( playerid ) ;
	return 1 ;
}

stock show_stats ( playerid )
{
	new line_string [ 100 ], _marriage [ MAX_PLAYER_NAME ] ;
	
	if ( p_info [ playerid ] [ marriage ] != -1 ) format ( _marriage, sizeof _marriage, "%s", p_info [ playerid ] [ marriage_name ] ) ;
	else format ( _marriage, sizeof _marriage, "Нет" ) ;
	
    format ( line_string, sizeof line_string, "В браке:\t\t\t\t%s\n\n", _marriage ) ;
	strcat ( global_string, line_string ) ;
	
	new rank_name [ 24 ] ;
	if ( p_info [ playerid ] [ taxi_skill ] >= 0 && p_info [ playerid ] [ taxi_skill ] <= 199 )	rank_name = "Водила бич класса (1)" ;
	else if ( p_info [ playerid ] [ taxi_skill ] >= 200 && p_info [ playerid ] [ taxi_skill ] <= 399 )rank_name = "Водила дрочила (2)" ;
	else rank_name = "Элитный пидрила (3)" ;
	
	format ( line_string, sizeof line_string, "Проехал км за время работы:\t\t\t\t%.1f\n", p_info [ playerid ] [ millage ] ) ;
	strcat ( global_string, line_string ) ;
	format ( line_string, sizeof line_string, "Принял заказов за всё время:\t\t\t\t%d\n", p_info [ playerid ] [ taxi_order ] ) ;
	strcat ( global_string, line_string ) ;
	format ( line_string, sizeof line_string, "Заработал за сегодняшний день:\t\t\t\t%d\n", p_info [ playerid ] [ day_money ] ) ;
	strcat ( global_string, line_string ) ;
	format ( line_string, sizeof line_string, "Заработал за неделю:\t\t\t\t%d\n", p_info [ playerid ] [ week_money ] ) ;
	strcat ( global_string, line_string ) ;
	format ( line_string, sizeof line_string, "Заработал за месяц:\t\t\t\t%d\n", p_info [ playerid ] [ month_money ] ) ;
	strcat ( global_string, line_string ) ;
	format ( line_string, sizeof line_string, "Заработал за всё время:\t\t\t\t%d\n", p_info [ playerid ] [ all_money ] ) ;
	strcat ( global_string, line_string ) ;
	format ( line_string, sizeof line_string, "Уровень навыка:\t\t\t\t%s\n", rank_name ) ;
	strcat ( global_string, line_string ) ;
	return 1 ;
}

stock change_name ( playerid )
{
	if ( p_info [ playerid ] [ marriage ] != -1 )
	{
	    new sql_string [ 100 ] ;
    	format ( sql_string, sizeof ( sql_string ), "UPDATE `users` SET `u_marriage_name` = '%s' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ name ], p_info [ playerid ] [ marriage ] ) ;
		mysql_tquery ( sql_connection, sql_string ) ;

		new pl_id ;
		sscanf ( p_info [ playerid ] [ marriage_name ], "u", pl_id ) ;
		if ( IsPlayerConnected ( pl_id ) ) format ( p_info [ pl_id ] [ marriage_name ], MAX_PLAYER_NAME, "%s", p_info [ playerid ] [ name ] ) ;
	}
	return 1 ;
}

CMD:mystats ( playerid )
{
    new rank_name [ 24 ] ;
	if ( p_info [ playerid ] [ taxi_skill ] >= 0 && p_info [ playerid ] [ taxi_skill ] <= 199 )	rank_name = "Водила бич класса (1)" ;
	else if ( p_info [ playerid ] [ taxi_skill ] >= 200 && p_info [ playerid ] [ taxi_skill ] <= 399 )rank_name = "Водила дрочила (2)" ;
	else rank_name = "Элитный пидрила (3)" ;

    global_string [ 0 ] = EOS ;
	format ( global_string, 512, "{FFFFFF}Проехал км за время работы: {FFCC00}%.1f{FFFFFF}\n\
														Принял заказов за всё время: {FFCC00}%d шт.{FFFFFF}\n\
														Заработал за сегодняшний день: {FFCC00}%d${FFFFFF}\n\
														Заработал за неделю: {FFCC00}%d${FFFFFF}\n\
														Заработал за месяц: {FFCC00}%d${FFFFFF}\n\
														Заработал за всё время: {FFCC00}%d${FFFFFF}\n\n\
														Уровень навыка: {FFCC00}%s{FFFFFF}",
	p_info [ playerid ] [ millage ], p_info [ playerid ] [ taxi_order ], p_info [ playerid ] [ day_money ], p_info [ playerid ] [ week_money ],
	p_info [ playerid ] [ month_money ], p_info [ playerid ] [ all_money ], rank_name ) ;
	show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{FFCC00}Информация о работе в такси", global_string, "Закрыть", "" ) ;
	return 1 ;
}

stock load_user ( playerid )
{
    if ( GetElapsedTime ( gettime ( ), p_info [ playerid ] [ gettime_cooldown ], CONVERT_TIME_TO_DAYS ) > 0 )
	{
	    p_info [ playerid ] [ day_money ] = 0 ;
		update_int_sql ( playerid, "u_day_money", p_info [ playerid ] [ day_money ] ) ;
	
		p_info [ playerid ] [ gettime_cooldown ] = gettime ( ) ;
		update_int_sql ( playerid, "u_gettime_cooldown", p_info [ playerid ] [ gettime_cooldown ] ) ;
	}
	if ( GetElapsedTime ( gettime ( ), p_info [ playerid ] [ gettime_week_cooldown ], CONVERT_TIME_TO_WEEKS ) > 0 )
	{
	    p_info [ playerid ] [ week_money ] = 0 ;
		update_int_sql ( playerid, "u_week_money", p_info [ playerid ] [ week_money ] ) ;
	
		p_info [ playerid ] [ gettime_week_cooldown ] = gettime ( ) ;
		update_int_sql ( playerid, "u_gettime_week_cooldown", p_info [ playerid ] [ gettime_week_cooldown ] ) ;
	}
	if ( GetElapsedTime ( gettime ( ), p_info [ playerid ] [ gettime_month_cooldown ], CONVERT_TIME_TO_MONTHS ) > 0 )
	{
	    p_info [ playerid ] [ month_money ] = 0 ;
		update_int_sql ( playerid, "u_month_money", p_info [ playerid ] [ month_money ] ) ;
	
		p_info [ playerid ] [ gettime_month_cooldown ] = gettime ( ) ;
		update_int_sql ( playerid, "u_gettime_month_cooldown", p_info [ playerid ] [ gettime_month_cooldown ] ) ;
	}
	return 1 ;
}

stock GetElapsedTime(time, to_time, type = CONVERT_TIME_TO_HOURS)
{
    new result;

    switch(type)
    {
        case CONVERT_TIME_TO_MINUTES:
        {
            result = ((time - (time % 60)) - (to_time - (to_time % 60))) / 60;
        }
        case CONVERT_TIME_TO_HOURS:
        {
            result = ((time - (time % 3600)) - (to_time - (to_time % 3600))) / 3600;
        }
        case CONVERT_TIME_TO_DAYS:
        {
            result = ((time - (time % 86400)) - (to_time - (to_time % 86400))) / 86400;
        }
        case CONVERT_TIME_TO_WEEKS:
        {
            result = ((time - (time % 604800)) - (to_time - (to_time % 604800))) / 604800;
        }
        case CONVERT_TIME_TO_MONTHS:
        {
            result = ((time - (time % 2629743)) - (to_time - (to_time % 2629743))) / 2629743;
        }
        case CONVERT_TIME_TO_YEARS:
        {
            result = ((time - (time % 31556926)) - (to_time - (to_time % 31556926))) / 31556926;
        }
        default:
            result = -1;
    }
    return result;
}

stock ConvertUnixTime(unix_time, type = CONVERT_TIME_TO_SECONDS)
{
    switch(type)
    {
        case CONVERT_TIME_TO_SECONDS:
        {
            unix_time %= 60;
        }
        case CONVERT_TIME_TO_MINUTES:
        {
            unix_time = (unix_time / 60) % 60;
        }
        case CONVERT_TIME_TO_HOURS:
        {
            unix_time = (unix_time / 3600) % 24;
        }
        case CONVERT_TIME_TO_DAYS:
        {
            unix_time = (unix_time / 86400) % 30;
        }
        case CONVERT_TIME_TO_WEEKS:
        {
            unix_time = (unix_time / 604800) % 7;
        }
        case CONVERT_TIME_TO_MONTHS:
        {
            unix_time = (unix_time / 2629743) % 12;
        }
        case CONVERT_TIME_TO_YEARS:
        {
            unix_time = (unix_time / 31556926) + 1970;
        }
        default:
            unix_time %= 60;
    }
    return unix_time;
}

stock SetElapsedTime(time, to_time, type = CONVERT_TIME_TO_SECONDS)
{
    new result;

    switch(type)
    {
        case CONVERT_TIME_TO_MINUTES:
        {
            result = time + (60 * to_time);
        }
        case CONVERT_TIME_TO_HOURS:
        {
            result = time + (3600 * to_time);
        }
        case CONVERT_TIME_TO_DAYS:
        {
            result = time + (86400 * to_time);
        }
        case CONVERT_TIME_TO_WEEKS:
        {
            result = time + (604800 * to_time);
        }
        case CONVERT_TIME_TO_MONTHS:
        {
            result = time + (2629743 * to_time);
        }
        case CONVERT_TIME_TO_YEARS:
        {
            result = time + (31556926 * to_time);
        }
        default:
            result = -1;
    }
    return result;
}

CMD:divorce ( playerid )
{
	if ( p_info [ playerid ] [ marriage ] == -1 ) return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не состоите в браке." ) ;
	if ( ! IsPlayerInRangeOfPoint ( playerid, 20, pick_marriage_pos [ 0 ], pick_marriage_pos [ 1 ], pick_marriage_pos [ 2 ] ) )return SendClientMessage ( playerid, 0xFF6600FF, !"Вы не в церкви." ) ;
	
	new _pl_id = -1 ;
	foreach(new i: logged_players)
	{
	    if ( p_info [ i ] [ id ] != p_info [ playerid ] [ marriage ] ) continue ;
	    
	    _pl_id = i ;
	    break ;
	}
	
	if ( _pl_id != -1 )
	{
	    p_info [ playerid ] [ marriage ] = -1 ;
	    update_int_sql ( playerid, "u_marriage", p_info [ playerid ] [ marriage ] ) ;

	    p_info [ _pl_id ] [ marriage ] = -1 ;
	    update_int_sql ( _pl_id, "u_marriage", p_info [ _pl_id ] [ marriage ] ) ;
	    
		new scm_string [ 27 + MAX_PLAYER_NAME ] ;
		format ( scm_string, sizeof scm_string, "%s развелся(ась) с Вами.", p_info [ playerid ] [ name ] ) ;
		SendClientMessage ( _pl_id, 0xFFCC00FF, scm_string ) ;
		
		format ( scm_string, sizeof scm_string, "Вы развелись с %s.", p_info [ _pl_id ] [ name ] ) ;
		SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
	}
	else
	{
	    new sql_string [ 69 + 9 ] ;
	    format ( sql_string, sizeof sql_string, "UPDATE `users` SET `u_marriage` = '-1' WHERE `u_id` = '%d' LIMIT 1", p_info [ playerid ] [ marriage ] ) ;
	    mysql_tquery ( sql_connection, sql_string ) ;

	    p_info [ playerid ] [ marriage ] = -1 ;
	    update_int_sql ( playerid, "u_marriage", p_info [ playerid ] [ marriage ] ) ;

	    new scm_string [ 21 + MAX_PLAYER_NAME ] ;
	    format ( scm_string, sizeof scm_string, "Вы развелись с %s.", p_info [ playerid ] [ marriage_name ] ) ;
		SendClientMessage ( playerid, 0xFFCC00FF, scm_string ) ;
	}
	return 1 ;
}

stock update_int_sql ( playerid, _var_name [ ], _const )
{
	return 1 ;
}

/* 

ALTER TABLE `users` ADD `gettime_cooldown` INT(11) NOT NULL DEFAULT '0' AFTER `u_seed_sell`, ADD `gettime_week_cooldown` INT(11) NOT NULL DEFAULT '0' AFTER `gettime_cooldown`, ADD `gettime_month_cooldown` INT(11) NOT NULL DEFAULT '0' AFTER `gettime_week_cooldown`;

*/


/*
	// taxi new
	new dl_string [ 12 ] ;
    cache_get_field_content ( t, "b_taxi_auto_invite", dl_string, sql_connection, 64 ), sscanf ( dl_string, "p<|>ddd",
			b_info [ t ] [ b_taxi_auto_invite ] [ 0 ], b_info [ t ] [ b_taxi_auto_invite ] [ 1 ], b_info [ t ] [ b_taxi_auto_invite ] [ 2 ] ) ;
			
    ALTER TABLE `businesses` ADD `b_taxi_auto_invite` VARCHAR(12) NOT NULL DEFAULT '0|0|0' AFTER `b_max_car`;
	//

    b_info [ i ] [ taxi_skill ] = cache_get_field_content_int ( 0, "u_taxi_skill", sql_connection ) ;
    b_info [ i ] [ b_taxi_licenses ] = cache_get_field_content_int ( i, "b_taxi_licenses", sql_connection ) ;
    b_info [ i ] [ b_taxi_fare ] = cache_get_field_content_int ( i, "b_taxi_fare", sql_connection ) ;
    cache_get_field_content ( i, "b_taxi_deputy", b_info [ i ] [ b_taxi_deputy ], sql_connection, MAX_PLAYER_NAME ) ;

    // marriage
    ALTER TABLE `users` ADD `u_marriage` INT(11) NOT NULL DEFAULT '-1' AFTER `u_seed_sell`, ADD `u_marriage_name` VARCHAR(24) NOT NULL AFTER `u_marriage`;
    ALTER TABLE `users` ADD `u_day_money` INT(11) NOT NULL DEFAULT '0' AFTER `u_seed_sell`, ADD `u_week_money` INT(11) NOT NULL DEFAULT '0' AFTER `u_day_money`, ADD `u_month_money` INT(11) NOT NULL DEFAULT '0' AFTER `u_week_money`, ADD `u_all_money` INT(11) NOT NULL DEFAULT '0' AFTER `u_month_money`, ADD `u_millage` FLOAT NOT NULL DEFAULT '0.0' AFTER `u_all_money`, ADD `u_taxi_order` INT(11) NOT NULL DEFAULT '0' AFTER `u_millage`;
    // Taxi
    
    
    
    ALTER TABLE users ADD u_taxi_skill INT(9) NOT NULL DEFAULT '0' AFTER u_seed_sell;
    p_info [ playerid ] [ taxi_skill ] = cache_get_field_content_int ( 0, "u_taxi_skill", sql_connection ) ;
*/
