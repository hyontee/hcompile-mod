/*

	18631 - знак вопроса для пустого крафта

*/

#define ofm_formula_craft(%1)	(%1 * 15) // + 1
#define ofm_formula_custom_craft(%1)	(%1 * 9)

new PlayerText: craft_buttons_PTD [ MAX_PLAYERS ] [ 16 ] ;
new PlayerText: craft_inv_PTD [ MAX_PLAYERS ] [ 15 ] ;
new PlayerText: craft_items_PTD [ MAX_PLAYERS ] [ 10 ] ;
new PlayerText: craft_crafting_PTD [ MAX_PLAYERS ] [ 2 ] ;
new Text: craft_background_TD [ 26 ] ;

#define MAX_CRAFT 81
enum _craft
{
	c_name [ 32 ],
	c_item,
	c_give_item,
	c_composition [ 5 ],
	c_quantity [ 5 ],
	c_price,
	c_chance,
	c_color,
	c_type
} ;

enum
{
	CRAFT_NO_RENDER = -1,
	CRAFT_RENDER_OBJECT = 0,
	CRAFT_RENDER_CAR = 1,
	CRAFT_RENDER_SKIN = 2
} ;

new player_count_craft [ MAX_PLAYERS char ] ;
new player_craft_time [ MAX_PLAYERS char ] ;
new bool: used_craft [ MAX_PLAYERS ] ;

new craft_info [ MAX_CRAFT ] [ _craft ] =
{
	{ "Ежедневный кейс", 19624, 3, { 905, 19941, 1463, 2684, 18631 }, { 3, 10, 25, 3, 0 }, 500_000, 5, -1, CRAFT_RENDER_OBJECT },
	{ "Семейный кейс", 19624, 48, { 905, 19941, 1463, 2684, 18631 }, { 40, 40, 40, 40, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_OBJECT },
	{ "Горный велосипед", 481, 1083, { 905, 19941, 1080, 2684, 18631 }, { 100, 100, 5, 100, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_CAR },
	{ "Mercedes-Benz GT63S", 546, 546, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 1_000_000, 15, -2147483393, CRAFT_RENDER_CAR },
	{ "Mercedes-Benz G63", 543, 543, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 1_000_000, 15, -2147483393, CRAFT_RENDER_CAR },
	{ "Bugatti", 411, 411, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 100_000_000, 15, 41215, CRAFT_RENDER_CAR },
	{ "Крылья Купидона", 8130, 255, { 905, 19941, 1463, 2684, 18631 }, { 500, 1000, 100, 100, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Sims", 8271, 255, { 905, 19941, 1463, 2684, 18631 }, { 100, 1000, 10, 10, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Одежда #302", 302, skin_cross + 302, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 50_000_000, 20, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #304", 304, skin_cross + 304, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 50_000_000, 20, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #294", 294, skin_cross + 294, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 50_000_000, 20, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #43", 43, skin_cross + 43, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 50_000_000, 20, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #10", 10, skin_cross + 10, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 50_000_000, 20, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #139", 139, skin_cross + 139, { 1463, 2684, 18631, 18631, 18631 }, { 5000, 5000, 0, 0, 0 }, 50_000_000, 20, 8388863, CRAFT_RENDER_SKIN },
	{ "Mercedes-Benz W124", 3240, 3240, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 10_000_000, 25, 41215, CRAFT_RENDER_CAR },
	{ "Nissan Skyline R34", 3238, 3238, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 10_000_000, 25, 41215, CRAFT_RENDER_CAR },
	{ "Jaguar F-Type", 555, 555, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 10_000_000, 25, 41215, CRAFT_RENDER_CAR },
	{ "Acura NSX", 3231, 3231, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 10_000_000, 25, 41215, CRAFT_RENDER_CAR },
	{ "Бронежилет (1 уровень)", 1242, 1242, { 905, 2684, 18631, 18631, 18631 }, { 30, 30, 0, 0, 0 }, 100_000, 80, -1, CRAFT_RENDER_OBJECT },
	{ "Бронежилет (2 уровень)", 1242, 1243, { 905, 19941, 2684, 18631, 18631 }, { 30, 10, 30, 0, 0 }, 100_000, 60, 8388863, CRAFT_RENDER_OBJECT },
	{ "Бронежилет (3 уровень)", 1242, 1244, { 905, 19941, 2684, 1463, 18631 }, { 30, 15, 30, 30, 0 }, 100_000, 40, 41215, CRAFT_RENDER_OBJECT },
	{ "Бронежилет (3 уровень)", 1242, 1244, { 1242, 1243, 18631, 18631, 18631 }, { 4, 2, 0, 0, 0 }, 100_000, 40, 41215, CRAFT_RENDER_OBJECT },
	{ "Porsche Cayman", 3289, 3289, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 50_000_000, 15, 41215, CRAFT_RENDER_CAR },
	{ "Jaguar F-Pace S", 3292, 3292, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 50_000_000, 15, 41215, CRAFT_RENDER_CAR },
	{ "Улучшенный верстак", 19624, 19624, { 905, 19941, 1463, 2684, 18631 }, { 40, 40, 40, 40, 0 }, 10_000_000, 40, 41215, CRAFT_RENDER_OBJECT },
	{ "BMW 850i", 3294, 3294, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 50_000_000, 5, 41215, CRAFT_RENDER_CAR },
	{ "Ferrari 458", 3295, 3295, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 50_000_000, 5, 41215, CRAFT_RENDER_CAR },
	{ "GMC Vandura", 482, 482, { 1080, 1018, 1038, 1140, 1165 }, { 10, 7, 9, 8, 8 }, 50_000_000, 5, 41215, CRAFT_RENDER_CAR },
	{ "Lada Niva", 474, 474, { 1080, 1018, 1038, 1140, 1165 }, { 6, 3, 5, 4, 4 }, 3_000_000, 5, 41215, CRAFT_RENDER_CAR },
	
	{ "Алмазный меч", 12635, 255, { 905, 19941, 1463, 2684, 18631 }, { 100, 1000, 10, 10, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Золотой меч", 12636, 255, { 905, 19941, 1463, 2684, 18631 }, { 100, 1000, 10, 10, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Алмазная кирка", 12637, 255, { 905, 19941, 1463, 2684, 18631 }, { 100, 1000, 10, 10, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Золотая кирка", 12638, 255, { 905, 19941, 1463, 2684, 18631 }, { 100, 1000, 10, 10, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	
	{ "Mitsubishi Lancer X", 3305, 3305, { 1080, 1018, 1038, 1140, 1165 }, { 10, 7, 9, 8, 8 }, 50_000_000, 5, 41215, CRAFT_RENDER_CAR },
	{ "Одежда #4512", 4512, skin_cross + 4512, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4513", 4513, skin_cross + 4513, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	
	{ "Одежда #4535", 4535, skin_cross + 4535, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4536", 4536, skin_cross + 4536, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4537", 4537, skin_cross + 4537, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4538", 4538, skin_cross + 4538, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4539", 4539, skin_cross + 4539, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4540", 4540, skin_cross + 4540, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4541", 4541, skin_cross + 4541, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4542", 4542, skin_cross + 4542, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4543", 4543, skin_cross + 4543, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 50_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	
	{ "Одежда #4545", 4545, skin_cross + 4545, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4547", 4547, skin_cross + 4547, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4574", 4574, skin_cross + 4574, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	
	{ "GAZ 2410", 3320, 3320, { 1080, 1018, 1038, 1140, 1165 }, { 10, 7, 9, 8, 8 }, 50_000_000, 5, 8388863, CRAFT_RENDER_CAR },
	{ "Lamborghini LM002", 3330, 3330, { 1080, 1018, 1038, 1140, 1165 }, { 10, 7, 9, 8, 8 }, 50_000_000, 5, 8388863, CRAFT_RENDER_CAR },
	{ "Ключ от тюрьмы", 11746, 11746, { 19773, 905, 18631, 18631, 18631 }, { 4, 15, 0, 0, 0 }, 100_000, 40, 41215, CRAFT_RENDER_OBJECT },
	
	{ "Рюкзак NoKitty", 11903, 255, { 905, 19941, 1463, 2684, 18631 }, { 100, 1000, 10, 10, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Маска Blood Monkey", 11908, 255, { 905, 19941, 1463, 2684, 18631 }, { 100, 1000, 10, 10, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Одежда #4592", 4592, skin_cross + 4592, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4594", 4594, skin_cross + 4594, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	
	{ "Одежда #4603", 4603, skin_cross + 4603, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4604", 4604, skin_cross + 4604, { 1463, 2684, 19941, 18631, 18631 }, { 5000, 5000, 250, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Ford Focus RS", 3335, 3335, { 1080, 1018, 1038, 1140, 1165 }, { 10, 7, 9, 8, 8 }, 50_000_000, 5, 8388863, CRAFT_RENDER_CAR },
	
	{ "Одежда #4659", 4659, skin_cross + 4659, { 1463, 2684, 19941, 18631, 18631 }, { 10000, 10000, 500, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4661", 4661, skin_cross + 4661, { 1463, 2684, 19941, 18631, 18631 }, { 10000, 10000, 500, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4662", 4662, skin_cross + 4662, { 1463, 2684, 19941, 18631, 18631 }, { 10000, 10000, 500, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	
	{ "Щупальца", 8129, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Лук Купидона", 8131, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Панцырь", 8142, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	
	{ "Банан Храмова", 8295, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Футболка Храмова", 8296, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Огонёчек", 8297, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	
	{ "Бронзовая рулетка", 11744, 45, { 905, 19941, 1080, 1018, 1038 }, { 50, 500, 1, 1, 1 }, 500_000, 25, -1, CRAFT_RENDER_OBJECT },
	{ "Серебряная рулетка", 11744, 55, { 905, 19941, 1080, 1018, 1038 }, { 75, 1000, 5, 5, 5 }, 500_000, 15, -1, CRAFT_RENDER_OBJECT },
	{ "Золотая рулетка", 11744, 125, { 905, 19941, 1080, 1018, 1038 }, { 150, 1500, 10, 10, 10 }, 500_000, 5, -1, CRAFT_RENDER_OBJECT },
	
	{ "Одежда #4700", 4700, skin_cross + 4700, { 1463, 2684, 19941, 18631, 18631 }, { 10000, 10000, 500, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4701", 4701, skin_cross + 4701, { 1463, 2684, 19941, 18631, 18631 }, { 10000, 10000, 500, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4702", 4702, skin_cross + 4702, { 1463, 2684, 19941, 18631, 18631 }, { 10000, 10000, 500, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	{ "Одежда #4703", 4703, skin_cross + 4703, { 1463, 2684, 19941, 18631, 18631 }, { 10000, 10000, 500, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	
	{ "Jet Acs", 5061, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Одежда #4732", 4732, skin_cross + 4732, { 1463, 2684, 19941, 18631, 18631 }, { 10000, 10000, 500, 0, 0 }, 100_000_000, 5, 8388863, CRAFT_RENDER_SKIN },
	
	{ "Шлем Рика", 5100, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Рюкзак Рика", 5104, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Голова Рика", 5105, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Броня Рика #2", 5109, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT },
	{ "Брат Руслана", 5087, 255, { 905, 19941, 1463, 2684, 18631 }, { 200, 2000, 20, 20, 0 }, 50_000_000, 5, 41215, CRAFT_RENDER_OBJECT }
} ;

#include 										<custom/crafts>

stock craft_OnPlayerClickTextDraw ( playerid, Text:clickedid )
{
	if ( used_craft [ playerid ] == true )
	{
		if ( !( _:clickedid ^ 0xFFFF ) )
		{
			SelectTextDraw ( playerid, 0xB0C4DEFF ) ;
			return 1 ;
		}
	}
	return 0 ;
}

stock craft_ClickPlayerTextDraw ( playerid, PlayerText:playertextid )
{
	if ( used_craft [ playerid ] == true )
	{
		if ( playertextid == craft_buttons_PTD [ playerid ] [ 14 ] )
		{
			new _craft_id = get_player_use_listitem ( playerid ) ;
			if ( _craft_id < 0 || craft_info [ _craft_id ] [ c_item ] == 18631 ) return 1 ;
				
			new header_string [ 64 ] ;
			format ( header_string, sizeof header_string, "{"#cBHD"}Крафт {"#cWH"}%s", craft_info [ _craft_id ] [ c_name ] ) ;
				
			global_string [ 0 ] = EOS ;
			new line_string [ 100 ], _c_count = 0 ;
				
			strcat ( global_string, "{"#cWH"}Требования для крафта предмета:\n\n" ) ;
				
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				if ( craft_info [ _craft_id ] [ c_composition ] [ i ] == 18631 ) continue ;

				_c_count ++ ;

				format ( line_string, sizeof line_string, "{"#cBL"}%d. {"#cLY"}%s (%d шт.) {"#cWH"}- достать можно %s.\n", _c_count, 
				item_name ( craft_info [ _craft_id ] [ c_composition ] [ i ] ), item_description ( craft_info [ _craft_id ] [ c_composition ] [ i ] ) ) ;
				strcat ( global_string, line_string ) ;
			}
				
			format ( line_string, sizeof line_string, "\n{"#cWH"}Стоимость крафта составит: {"#cGN"}%d"valute_title_"\n", craft_info [ _craft_id ] [ c_price ] ) ;
			strcat ( global_string, line_string ) ;
				
			new _h_id = GetPVarInt ( playerid, "house_id" ) ;
			if ( _h_id > 0 )
			{
				format ( line_string, sizeof line_string, "{"#cWH"}Шанс успеха крафта составит: {"#cGN"}%d%%\n", craft_info [ _craft_id ] [ c_chance ] + h_info [ _h_id - 1 ] [ h_upgrade_craft ] ) ;
				strcat ( global_string, line_string ) ;
			}
			else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 )
			{
				_h_id = GetPVarInt ( playerid, "cellar_id" ) ;
				format ( line_string, sizeof line_string, "{"#cWH"}Шанс успеха крафта составит: {"#cGN"}%d%%\n", craft_info [ _craft_id ] [ c_chance ] + cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ) ;
				strcat ( global_string, line_string ) ;
			}
			else
			{
				format ( line_string, sizeof line_string, "{"#cWH"}Шанс успеха крафта составит: {"#cGN"}%d%%\n", craft_info [ _craft_id ] [ c_chance ] ) ;
				strcat ( global_string, line_string ) ;
			}
			
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, header_string, global_string, "Закрыть", "" ) ;
			return 1 ;
		}
		if ( playertextid == craft_buttons_PTD [ playerid ] [ 14 ] )
		{
			if ( ofm_formula_craft ( page_count [ playerid ] ) >= sizeof craft_info ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на последней странице!" ) ;
			show_craft_inv ( playerid, false ) ;
				
			page_count [ playerid ] += 1 ;
			show_craft_inv ( playerid, true ) ;
				
			new td_string [ 16 ] ;
			format ( td_string, sizeof td_string, "%d/%d", page_count [ playerid ], floatround ( sizeof craft_info / 15 ) ) ;
			PlayerTextDrawSetString ( playerid, craft_buttons_PTD [ playerid ] [ 15 ], td_string ) ;
			return 1 ;
		}
		else if ( playertextid == craft_buttons_PTD [ playerid ] [ 13 ] )
		{
			if ( page_count [ playerid ] <= 1 ) return SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}Вы находитесь на первой странице!" ) ;
			show_craft_inv ( playerid, false ) ;
			
			page_count [ playerid ] -= 1 ;
			show_craft_inv ( playerid, true ) ;
			
			new td_string [ 16 ] ;
			format ( td_string, sizeof td_string, "%d/%d", page_count [ playerid ], floatround ( sizeof craft_info / 15 ) ) ;
			PlayerTextDrawSetString ( playerid, craft_buttons_PTD [ playerid ] [ 15 ], td_string ) ;
			return 1 ;
		}
		else if ( playertextid == craft_buttons_PTD [ playerid ] [ 4 ] )
		{
			craft_ptd_status ( playerid, false ) ;
			return 1 ;
		}
		else if ( playertextid == craft_buttons_PTD [ playerid ] [ 3 ] )
		{
			new _craft_id = get_player_use_listitem ( playerid ) ;
			if ( p_info [ playerid ] [ money ] < craft_info [ _craft_id ] [ c_price ] * player_count_craft { playerid } )
			{
				SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно денежных средств!" ) ;
				
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Успех", "{"#cRInfo"}* {"#cGRDialog"}У Вас недостаточно денежных средств!", "Закрыть", "" ) ;
				return 1 ;
			}
				
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				if ( craft_info [ _craft_id ] [ c_composition ] [ i ] == 18631 ) continue ;

				new _i_count = get_player_item_prise ( playerid, craft_info [ _craft_id ] [ c_composition ] [ i ] ) ;
				if ( _i_count < craft_info [ _craft_id ] [ c_quantity ] [ i ] )
				{
					SendClientMessage ( playerid, col_gray, !"{"#cRInfo"}* {"#cGRInfo"}У Вас недостаточно ингредиентов!" ) ;
				
					show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Крафт", "{"#cRInfo"}* {"#cGRDialog"}У Вас недостаточно ингредиентов!", "Закрыть", "" ) ;
					return 1 ;
				}
			}
			
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				if ( craft_info [ _craft_id ] [ c_composition ] [ i ] == 18631 ) continue ;
				
				clear_player_item_prise ( playerid, craft_info [ _craft_id ] [ c_composition ] [ i ], craft_info [ _craft_id ] [ c_quantity ] [ i ] ) ;
			}
			
			show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Успех", "{"#cGInfo"}* {"#cWH"}Вы начали крафтить. Ожидайте!", "Закрыть", "" ) ;
			SendClientMessage ( playerid, col_white, !"{"#cGInfo"}* {"#cWH"}Вы начали крафтить. Ожидайте!" ) ;
			job_timer [ playerid ] = SetTimerEx ( "craft_timer", 1000, false, "ii", playerid, player_count_craft { playerid } ) ;
			player_craft_time { playerid } = 20 ;
			
			craft_ptd_status ( playerid, false ) ;
			toggle_controlable ( playerid, false ) ;
			used_craft [ playerid ] = true ;
			
			ApplyAnimation ( playerid, "CAR_CHAT", "CAR_Sc4_BL", 4.0, 1, 1, 1, 1, 5800, 0 ) ;
			return 1 ;
		}
		
		if ( playertextid >= craft_inv_PTD [ playerid ] [ 0 ] && playertextid <= craft_inv_PTD [ playerid ] [ 14 ] )
		{
			new j ; 
			new rows_list = page_count [ playerid ] - 1 ; 
			
			j = _:playertextid - _:craft_inv_PTD [ playerid ] [ 0 ] ;
			if ( j + rows_list * 15 >= MAX_CRAFT ) return 1 ;
			if ( craft_info [ j + rows_list * 15 ] [ c_item ] == 18631 ) return 1 ;
				
			set_player_use_listitem ( playerid, j + rows_list * 15 ) ;
				
			new td_string [ 24 ], _chance = craft_info [ j + rows_list * 15 ] [ c_chance ] ;
			new _h_id = GetPVarInt ( playerid, "house_id" ) ;
			if ( _h_id > 0 ) _chance += h_info [ _h_id - 1 ] [ h_upgrade_craft ] ;
			else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 ) _chance += cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ;

			if ( p_info [ playerid ] [ crime_plus ] ) _chance += 10 ;
			
			format ( td_string, sizeof td_string, "SUCCESS_CHANCE:_%d%%", _chance ) ;
			PlayerTextDrawSetString ( playerid, craft_buttons_PTD [ playerid ] [ 0 ], td_string ) ;
					
			format ( td_string, sizeof td_string, "NEED_MONEY:_%d$", craft_info [ j + rows_list * 15 ] [ c_price ] ) ;
			PlayerTextDrawSetString ( playerid, craft_buttons_PTD [ playerid ] [ 1 ], td_string ) ;
			
			show_craft_items ( playerid, false ) ;
			show_craft_items ( playerid, true ) ;

			show_craft_crafting ( playerid, false ) ;
			show_craft_crafting ( playerid, true ) ;
			return 1 ;
		}
	}
	return 0 ;
}

callback: craft_timer ( playerid, _count )
{
	if ( player_craft_time { playerid } == 1 )
	{
		if ( player_count_craft { playerid } > 1 )
		{
			player_count_craft { playerid } -- ;
			player_craft_time { playerid } = 20 ;
			
			job_timer [ playerid ] = SetTimerEx ( "craft_timer", 1000, false, "ii", playerid, _count ) ;
		}
		else
		{
			KillTimer ( job_timer [ playerid ] ) ;
			job_timer [ playerid ] = -1 ;
			
			if ( player_device { playerid } == 2 ) { }
			else
			{
				toggle_controlable ( playerid, true ) ;
				craft_ptd_status ( playerid, true ) ;
			}
		}
		
		new _craft_id = get_player_use_listitem ( playerid ), _price = craft_info [ _craft_id ] [ c_price ], _chance_bonus = 0, _h_id = -1 ;
		give_money ( playerid, -_price ) ;
        insert_money_log ( playerid, INVALID_PLAYER_ID, -_price, "крафт" ) ;
		
		if ( GetPVarInt ( playerid, "house_id" ) > 0 ) 
		{
			_h_id = GetPVarInt ( playerid, "house_id" ) ;
			_chance_bonus = h_info [ _h_id - 1 ] [ h_upgrade_craft ] ;
		}
		else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 ) 
		{
			_h_id = GetPVarInt ( playerid, "cellar_id" ) ;
			_chance_bonus = cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ;
		}
		
		if ( p_info [ playerid ] [ crime_plus ] ) _chance_bonus += 10 ;
		
		if ( player_device { playerid } == 2 )
		{
			new scm_string [ 87 + 32 ], _item = craft_info [ _craft_id ] [ c_give_item ] ;
			if ( random ( 100 ) <= craft_info [ _craft_id ] [ c_chance ] + _chance_bonus )
			{
				if ( _count > 0 && player_count_craft { playerid } < 1 ) updateCraft ( playerid, 2, 0, 0, _craft_id, craft_info [ _craft_id ] [ c_name ] ) ;
				else updateCraft ( playerid, 6, 0, 0, 0, "" ) ;
			
				format ( scm_string, sizeof scm_string, "%s скрафтил %s.", p_info [ playerid ] [ name ], craft_info [ _craft_id ] [ c_name ] ) ;
				
				WriteLogs ( playerid, -1, TYPE_LOG_CRAFT, scm_string ) ;
				
				if ( _item == 19624 )
				{
					if ( GetPVarInt ( playerid, "house_id" ) > 0 )
					{
						h_info [ _h_id - 1 ] [ h_upgrade_craft ] = 10 ;
					
						new sql_string [ 74 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `houses` SET `h_upgrade_craft` = '10' WHERE `h_id` = '%d' LIMIT 1", h_info [ _h_id - 1 ] [ h_id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
					else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 )
					{
						cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] = 10 ;
					
						new sql_string [ 78 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `cellars` SET `cl_upgrade_craft` = '10' WHERE `cl_id` = '%d' LIMIT 1", cellar_info [ _h_id - 1 ] [ cl_id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
				}
				else
				{
					if ( _item == 255 ) _item = craft_info [ _craft_id ] [ c_item ] ;
					give_player_item_prise ( playerid, _item, 1, -1 ) ;
					
					scm_string [ 0 ] = EOS ;
					format ( scm_string, sizeof scm_string, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
					SendClientMessage ( playerid, col_yellow, scm_string ) ;
				}
			}
			else
			{
				updateCraft ( playerid, 0, 0, 0, 0, "" ) ;
				
				format ( scm_string, sizeof scm_string, "%s неудачная попытка крафта %s.", p_info [ playerid ] [ name ], craft_info [ _craft_id ] [ c_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_CRAFT, scm_string ) ;
			}
		}
		else
		{
			new scm_string [ 87 + 32 ], _item = craft_info [ _craft_id ] [ c_give_item ] ;
			if ( random ( 100 ) <= craft_info [ _craft_id ] [ c_chance ] + _chance_bonus )
			{
				format ( scm_string, sizeof scm_string, "{"#cGInfo"}* {"#cWH"}Вы скрафтили %s. Поздравляем!", craft_info [ _craft_id ] [ c_name ] ) ;
				SendClientMessage ( playerid, col_white, scm_string ) ;
				
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Успех", scm_string, "Закрыть", "" ) ;
			
				format ( scm_string, sizeof scm_string, "%s скрафтил %s.", p_info [ playerid ] [ name ], craft_info [ _craft_id ] [ c_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_CRAFT, scm_string ) ;
				
				if ( craft_info [ _craft_id ] [ c_give_item ] == 19624 )
				{
					if ( GetPVarInt ( playerid, "house_id" ) > 0 )
					{
						h_info [ _h_id - 1 ] [ h_upgrade_craft ] = 10 ;
					
						new sql_string [ 74 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `houses` SET `h_upgrade_craft` = '10' WHERE `h_id` = '%d' LIMIT 1", h_info [ _h_id - 1 ] [ h_id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
					else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 )
					{
						cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] = 10 ;
					
						new sql_string [ 78 + 9 ] ;
						format ( sql_string, sizeof sql_string, "UPDATE `cellars` SET `cl_upgrade_craft` = '10' WHERE `cl_id` = '%d' LIMIT 1", cellar_info [ _h_id - 1 ] [ cl_id ] ) ;
						mysql_tquery ( sql_connection, sql_string ) ;
					}
				}
				else if ( craft_info [ _craft_id ] [ c_give_item ] == 255 ) give_player_item ( playerid, craft_info [ _craft_id ] [ c_item ] ) ;
				else
				{
					if ( _item == 255 ) _item = craft_info [ _craft_id ] [ c_item ] ;
					give_player_item_prise ( playerid, _item, 1, -1 ) ;
						
					scm_string [ 0 ] = EOS ;
					format ( scm_string, sizeof scm_string, "* Вам был добавлен предмет '%s'. Откройте инвентарь, используйте /mm или радиальное меню.", item_name ( _item ) ) ;
					SendClientMessage ( playerid, col_yellow, scm_string ) ;
				}
			}
			else
			{
				ClearAnimations ( playerid ) ;
				
				format ( scm_string, sizeof scm_string, "{"#cRInfo"}* {"#cGRInfo"}У Вас не получилось скрафтить %s. Можете попробовать снова!", craft_info [ _craft_id ] [ c_name ] ) ;
				SendClientMessage ( playerid, col_gray, scm_string ) ;
				
				show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Неудачная попытка", scm_string, "Закрыть", "" ) ;

				format ( scm_string, sizeof scm_string, "%s неудачная попытка крафта %s.", p_info [ playerid ] [ name ], craft_info [ _craft_id ] [ c_name ] ) ;
				WriteLogs ( playerid, -1, TYPE_LOG_CRAFT, scm_string ) ;
			}
		}
	}
	else
	{
		player_craft_time { playerid } -- ;

		if ( player_device { playerid } == 2 )
		{
			updateCraft ( playerid, 1, 20, ( 20 - player_craft_time { playerid } ), 0, "" ) ;
		}
		else
		{
			new td_string [ 64 ] ;
			format ( td_string, sizeof td_string, "~n~~n~~n~~n~~n~~n~~n~~n~~g~CRAFTING: ~w~%d sec", player_craft_time { playerid } ) ;
			GameTextForPlayer(playerid, td_string, 3000, 3);
		}
		
		job_timer [ playerid ] = SetTimerEx ( "craft_timer", 1000, false, "ii", playerid, _count ) ;
	}
	return 1 ;
}

stock craft_OnPlayerDisconnect ( playerid )
{
	if ( used_craft [ playerid ] == true )
	{
		craft_ptd_status ( playerid, false ) ;
		if ( job_timer [ playerid ] != -1 )
		{
			KillTimer ( job_timer [ playerid ] ) ;
			job_timer [ playerid ] = -1 ;
		}
	}
	return 1 ;
}

stock craft_ptd_status ( playerid, bool: status )
{
	if ( status )
	{
		toggle_controlable ( playerid, false ) ;
		
		used_craft [ playerid ] = true ;
		page_count [ playerid ] = 1 ;
		player_count_craft { playerid } = 1 ;
		set_player_use_listitem ( playerid, 0 ) ;
		
		show_craft_buttons ( playerid, true ) ;
		show_craft_inv ( playerid, true ) ;
		show_craft_items ( playerid, true ) ;
		show_craft_crafting ( playerid, true ) ;
		
		if ( player_device { playerid } == 2 )
		{
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, false ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, false ) ;
		}	
		else if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 26 ; i ++ )
			{
				TextDrawShowForPlayer ( playerid, craft_background_TD [ i ] ) ;
			}
		}
		
		SelectTextDraw(playerid, 0xB0C4DEFF ) ;
	}
	else
	{
		toggle_controlable ( playerid, true ) ;
	
		used_craft [ playerid ] = false ;
		page_count [ playerid ] = 0 ;
		
		show_craft_buttons ( playerid, false ) ;
		show_craft_inv ( playerid, false ) ;
		show_craft_items ( playerid, false ) ;
		show_craft_crafting ( playerid, false ) ;
		
		if ( player_device { playerid } == 2 )
		{
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_CHAT, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_WIDGETS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_BUTTONS, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_HUD, true ) ;
			TogglePlayerHudElement ( playerid, HUD_ELEMENT_KILL_LIST, true ) ;
		}	
		else if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 26 ; i ++ )
			{
				TextDrawHideForPlayer ( playerid, craft_background_TD [ i ] ) ;
			}
		}
		
		CancelSelectTextDraw ( playerid ) ;
	}
	return 1 ;
}

stock show_craft_buttons ( playerid, bool: status )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			new _chance_bonus = 0, _h_id = -1 ;
			if ( GetPVarInt ( playerid, "house_id" ) > 0 ) 
			{
				_h_id = GetPVarInt ( playerid, "house_id" ) ;
				_chance_bonus = h_info [ _h_id - 1 ] [ h_upgrade_craft ] ;
			}
			else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 ) 
			{
				_h_id = GetPVarInt ( playerid, "cellar_id" ) ;
				_chance_bonus = cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ;
			}
			
			if ( p_info [ playerid ] [ crime_plus ] ) _chance_bonus += 10 ;
			
			new td_string [ 24 ] ;
			format ( td_string, sizeof td_string, "SUCCESS_CHANCE:_%d%%", craft_info [ 0 ] [ c_chance ] + _chance_bonus ) ;
			craft_buttons_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 258.3333, 346.5851, td_string); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][0], 0.1843, 1.1519);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][0], 2);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][0], -1061109505);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][0], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][0], 2);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][0], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][0], 0);

			format ( td_string, sizeof td_string, "NEED_MONEY:_%d$", craft_info [ 0 ] [ c_price ] ) ;
			craft_buttons_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 258.3333, 337.3550, td_string); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][1], 0.1439, 0.9775);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][1], 2);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][1], -2139062017);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][1], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][1], 2);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][1], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][1], 0);

			craft_buttons_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 296.6664, 139.9181, "INFO"); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][2], 0.1859, 0.9901);
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][2], 10.0000, 63.0000);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][2], 2);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][2], 235802367);
			PlayerTextDrawUseBox(playerid, craft_buttons_PTD[playerid][2], 1);
			PlayerTextDrawBoxColor(playerid, craft_buttons_PTD[playerid][2], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][2], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][2], 2);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][2], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][2], 0);
			PlayerTextDrawSetSelectable(playerid, craft_buttons_PTD[playerid][2], true);

			craft_buttons_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 296.7662, 155.0657, "CRAFT"); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][3], 0.1835, 0.9901);
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][3], 10.0000, 62.7597);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][3], 2);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][3], 235802367);
			PlayerTextDrawUseBox(playerid, craft_buttons_PTD[playerid][3], 1);
			PlayerTextDrawBoxColor(playerid, craft_buttons_PTD[playerid][3], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][3], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][3], 2);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][3], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][3], 0);
			PlayerTextDrawSetSelectable(playerid, craft_buttons_PTD[playerid][3], true);

			craft_buttons_PTD[playerid][4] = CreatePlayerTextDraw(playerid, 296.6664, 169.9071, "EXIT"); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][4], 0.1859, 0.9901);
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][4], 10.0000, 63.0000);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][4], 2);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][4], 235802367);
			PlayerTextDrawUseBox(playerid, craft_buttons_PTD[playerid][4], 1);
			PlayerTextDrawBoxColor(playerid, craft_buttons_PTD[playerid][4], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][4], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][4], 2);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][4], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][4], 0);
			PlayerTextDrawSetSelectable(playerid, craft_buttons_PTD[playerid][4], true);

			craft_buttons_PTD[playerid][5] = CreatePlayerTextDraw(playerid, 262.7998, 135.6551, "ld_beat:chit"); // пусто
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][5], 6.0000, 7.3997);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][5], 1);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][5], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][5], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][5], 4);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][5], 0);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][5], 0);

			craft_buttons_PTD[playerid][6] = CreatePlayerTextDraw(playerid, 324.4666, 175.9259, "ld_beat:chit"); // пусто
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][6], 6.0000, 7.3997);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][6], 1);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][6], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][6], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][6], 4);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][6], 0);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][6], 0);

			craft_buttons_PTD[playerid][7] = CreatePlayerTextDraw(playerid, 265.9999, 136.7996, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][7], 63.3297, 3.0000);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][7], 1);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][7], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][7], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][7], 4);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][7], 0);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][7], 0);

			craft_buttons_PTD[playerid][8] = CreatePlayerTextDraw(playerid, 263.9996, 178.7147, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][8], 63.0000, 3.0799);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][8], 1);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][8], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][8], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][8], 4);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][8], 0);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][8], 0);

			craft_buttons_PTD[playerid][9] = CreatePlayerTextDraw(playerid, 421.3330, 75.9253, "O"); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][9], 0.4442, 2.3092);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][9], 1);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][9], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][9], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][9], 2);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][9], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][9], 0);

			craft_buttons_PTD[playerid][10] = CreatePlayerTextDraw(playerid, 447.3334, 75.9253, "O"); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][10], 0.4442, 2.3092);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][10], 1);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][10], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][10], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][10], 2);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][10], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][10], 0);

			craft_buttons_PTD[playerid][11] = CreatePlayerTextDraw(playerid, 423.2330, 81.9924, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][11], 34.0000, 11.5396);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][11], 1);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][11], -5963521);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][11], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][11], 4);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][11], 0);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][11], 0);

			craft_buttons_PTD[playerid][12] = CreatePlayerTextDraw(playerid, 436.6665, 98.7406, "/"); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][12], 0.5623, -2.0794);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][12], 1);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][12], 235802367);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][12], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][12], 1);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][12], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][12], 0);

			craft_buttons_PTD[playerid][13] = CreatePlayerTextDraw(playerid, 430.6665, 82.7776, "<<"); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][13], 0.1474, 1.1059);
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][13], 10.0000, 17.0000);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][13], 2);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][13], 235802367);
			PlayerTextDrawUseBox(playerid, craft_buttons_PTD[playerid][13], 1);
			PlayerTextDrawBoxColor(playerid, craft_buttons_PTD[playerid][13], 0);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][13], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][13], 1);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][13], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][13], 0);
			PlayerTextDrawSetSelectable(playerid, craft_buttons_PTD[playerid][13], true);

			craft_buttons_PTD[playerid][14] = CreatePlayerTextDraw(playerid, 450.3666, 82.7776, ">>"); // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][14], 0.1474, 1.1059);
			PlayerTextDrawTextSize(playerid, craft_buttons_PTD[playerid][14], 10.0000, 17.0000);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][14], 2);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][14], 235802367);
			PlayerTextDrawUseBox(playerid, craft_buttons_PTD[playerid][14], 1);
			PlayerTextDrawBoxColor(playerid, craft_buttons_PTD[playerid][14], 0);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][14], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][14], 1);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][14], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][14], 0);
			PlayerTextDrawSetSelectable(playerid, craft_buttons_PTD[playerid][14], true);

			format ( td_string, sizeof td_string, "%d/%d", page_count [ playerid ], floatround ( sizeof craft_info / 15 ) ) ;
			craft_buttons_PTD[playerid][15] = CreatePlayerTextDraw(playerid, 419.0000, 82.5625, td_string ) ; // пусто
			PlayerTextDrawLetterSize(playerid, craft_buttons_PTD[playerid][15], 0.1729, 1.0317);
			PlayerTextDrawAlignment(playerid, craft_buttons_PTD[playerid][15], 3);
			PlayerTextDrawColor(playerid, craft_buttons_PTD[playerid][15], -1);
			PlayerTextDrawBackgroundColor(playerid, craft_buttons_PTD[playerid][15], 255);
			PlayerTextDrawFont(playerid, craft_buttons_PTD[playerid][15], 2);
			PlayerTextDrawSetProportional(playerid, craft_buttons_PTD[playerid][15], 1);
			PlayerTextDrawSetShadow(playerid, craft_buttons_PTD[playerid][15], 0);
			
			for ( new i = 0 ; i < 16 ; i ++ )
			{
				PlayerTextDrawShow ( playerid, craft_buttons_PTD [ playerid ] [ i ] ) ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			new _chance_bonus = 0, _h_id = -1 ;
			if ( GetPVarInt ( playerid, "house_id" ) > 0 ) 
			{
				_h_id = GetPVarInt ( playerid, "house_id" ) ;
				_chance_bonus = h_info [ _h_id - 1 ] [ h_upgrade_craft ] ;
			}
			else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 ) 
			{
				_h_id = GetPVarInt ( playerid, "cellar_id" ) ;
				_chance_bonus = cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ;
			}
			
			if ( p_info [ playerid ] [ crime_plus ] ) _chance_bonus += 10 ;
			
			new _str [ 48 ] ;
			format ( _str, sizeof _str, "верстак (+%d%)", _chance_bonus ) ;
			CraftShow ( playerid, _str ) ;
			
			static const _str_name [ 3 ] [ 12 ] =
			{
				"Предметы",
				"Транспорт",
				"Одежда"
			} ;
			
			new BitStream:bitstream = BS_New();
			BS_WriteValue(bitstream, PR_UINT8, PACKET_CUSTOMRPC);
			BS_WriteValue(bitstream, PR_UINT32, RPC_CRAFT);
			
			BS_WriteValue(bitstream, PR_INT8, 3);

			BS_WriteValue(bitstream, PR_UINT8, 3);
			for ( new i = 0 ; i < 3 ; i ++ )
			{
				BS_WriteValue(bitstream, PR_UINT8, strlen ( _str_name [ i ] ) ) ;
				BS_WriteValue(bitstream, PR_STRING, _str_name [ i ] ) ;
			}
			
			PR_SendPacket(bitstream, playerid);

			BS_Delete(bitstream);
			
			CraftMainAddItem ( playerid, 0 ) ;
			show_packet_craft ( playerid, 2, 0 ) ;
		}
	}
	else
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 16 ; i ++ )
			{
				PlayerTextDrawDestroy ( playerid, craft_buttons_PTD [ playerid ] [ i ] ) ;
				craft_buttons_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	return 1 ;
}

stock show_craft_inv ( playerid, bool: status )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			static const Float: td_position [ 15 ] [ 2 ] =
			{
				{ 353.9342, 113.2033 },
				{ 390.0679, 113.2033 },
				{ 426.3348, 113.2033 },
				{ 353.9342, 155.0997 },
				{ 390.0679, 155.0997 },
				{ 426.3348, 155.0997 },
				{ 354.2677, 198.2404 },
				{ 390.4013, 198.2404 },
				{ 426.6682, 198.2404 },
				{ 354.2677, 241.2628 },
				{ 390.4013, 241.2628 },
				{ 426.6682, 241.2628 },
				{ 354.2677, 284.4039 },
				{ 390.4013, 284.4039 },
				{ 426.6683, 284.4039 }
			} ;
			
			new _craft_id, _item, _check_hash = player_checking_hash [ playerid ] ;
			for ( new i = 0 ; i < 15 ; i ++ )
			{
				_craft_id = ( ( page_count [ playerid ] - 1 ) * 15 ) + i ;
				if ( _craft_id >= MAX_CRAFT ) _item = 18631 ;
				else 
				{
					_item = craft_info [ _craft_id ] [ c_item ] ;
					if ( ( _item >= 3294 && _item <= 3297 ) && _check_hash < 30 )
					{
						for ( new q = 0 ; q < MAX_VEH_MODELS_REPLACE ; q ++ )
						{
							if ( _item != veh_replace_model [ q ] [ 0 ] ) continue ;

							_item = veh_replace_model [ q ] [ 1 ] ;
							break ;
						}
					}
					else if ( ( _item >= 312 && _item <= 320 || _item >= 4500 && _item <= 4507 ) && _check_hash < 39 )
					{
						for ( new q = 0 ; q < MAX_SKIN_MODELS_REPLACE ; q ++ )
						{
							if ( _item != skin_replace_model [ q ] [ 0 ] ) continue ;

							_item = skin_replace_model [ q ] [ 1 ] ;
							break ;
						}
					}
					else if ( ( _item >= 12635 && _item <= 12672 ) && _check_hash < 39 )
					{
						_item = 18631 ;
					}
				}
			
				craft_inv_PTD [ playerid ] [ i ] = CreatePlayerTextDraw(playerid, td_position [ i ] [ 0 ], td_position [ i ] [ 1 ], "");
				PlayerTextDrawTextSize(playerid, craft_inv_PTD [ playerid ] [ i ], 32.0000, 38.0000);
				PlayerTextDrawAlignment(playerid, craft_inv_PTD [ playerid ] [ i ], 1);
				PlayerTextDrawColor(playerid, craft_inv_PTD [ playerid ] [ i ], -1);
				PlayerTextDrawBackgroundColor(playerid, craft_inv_PTD [ playerid ] [ i ], 505290495);
				PlayerTextDrawFont(playerid, craft_inv_PTD [ playerid ] [ i ], 5);
				PlayerTextDrawSetProportional(playerid, craft_inv_PTD [ playerid ] [ i ], 0);
				PlayerTextDrawSetShadow(playerid, craft_inv_PTD [ playerid ] [ i ], 0);
				PlayerTextDrawSetSelectable(playerid, craft_inv_PTD [ playerid ] [ i ], true);
				PlayerTextDrawSetPreviewModel ( playerid, craft_inv_PTD [ playerid ] [ i ], _item ) ;
				PlayerTextDrawSetPreviewRot(playerid, craft_inv_PTD [ playerid ] [ i ], 0.0000, 0.0000, 0.0000, 1.0000);
			}

			for ( new i = 0 ; i < 15 ; i ++ )
			{
				PlayerTextDrawShow ( playerid, craft_inv_PTD [ playerid ] [ i ] ) ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	else
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 15 ; i ++ )
			{
				PlayerTextDrawDestroy ( playerid, craft_inv_PTD [ playerid ] [ i ] ) ;
				craft_inv_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	return 1 ;
}

stock show_craft_items ( playerid, bool: status )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			static const Float: td_position_text [ 5 ] [ 2 ] =
			{
				{ 196.3332, 289.9703 },
				{ 225.3350, 289.9703 },
				{ 255.5350, 289.9703 },
				{ 285.5350, 289.9703 },
				{ 314.8684, 289.5555 }
			} ;
			
			static const Float: td_position_item [ 5 ] [ 2 ] =
			{
				{ 181.6683, 254.1219 },
				{ 211.3347, 254.1219 },
				{ 241.0682, 254.1219 },
				{ 270.9013, 254.1219 },
				{ 300.7348, 254.1219 }
			} ;
			
			new td_string [ 24 ] ;
			new _craft_id = get_player_use_listitem ( playerid ) ;
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				format ( td_string, sizeof td_string, "%d/%d", craft_info [ _craft_id ] [ c_quantity ] [ i ] ) ;
				craft_items_PTD [ playerid ] [ i ] = CreatePlayerTextDraw(playerid, td_position_text [ i ] [ 0 ], td_position_text [ i ] [ 1 ], td_string ) ; // пусто
				PlayerTextDrawLetterSize(playerid, craft_items_PTD [ playerid ] [ i ], 0.1221, 0.8033);
				PlayerTextDrawAlignment(playerid, craft_items_PTD [ playerid ] [ i ], 2);
				PlayerTextDrawColor(playerid, craft_items_PTD [ playerid ] [ i ], -2139062017);
				PlayerTextDrawBackgroundColor(playerid, craft_items_PTD [ playerid ] [ i ], 255);
				PlayerTextDrawFont(playerid, craft_items_PTD [ playerid ] [ i ], 2);
				PlayerTextDrawSetProportional(playerid, craft_items_PTD [ playerid ] [ i ], 1);
				PlayerTextDrawSetShadow(playerid, craft_items_PTD [ playerid ] [ i ], 0);
				
				craft_items_PTD [ playerid ] [ 5 + i ] = CreatePlayerTextDraw(playerid, td_position_item [ i ] [ 0 ], td_position_item [ i ] [ 1 ], "" ) ; // item
				PlayerTextDrawTextSize(playerid, craft_items_PTD [ playerid ] [ 5 + i ], 28.0000, 34.0000);
				PlayerTextDrawAlignment(playerid, craft_items_PTD [ playerid ] [ 5 + i ], 1);
				PlayerTextDrawColor(playerid, craft_items_PTD [ playerid ] [ 5 + i ], -1);
				PlayerTextDrawBackgroundColor(playerid, craft_items_PTD [ playerid ] [ 5 + i ], 505290495);
				PlayerTextDrawFont(playerid, craft_items_PTD [ playerid ] [ 5 + i ], 5);
				PlayerTextDrawSetProportional(playerid, craft_items_PTD [ playerid ] [ 5 + i ], 0);
				PlayerTextDrawSetShadow(playerid, craft_items_PTD [ playerid ] [ 5 + i ], 0);
				PlayerTextDrawSetPreviewModel(playerid, craft_items_PTD [ playerid ] [ 5 + i ], craft_info [ _craft_id ] [ c_composition ] [ i ] ) ;
				PlayerTextDrawSetPreviewRot(playerid, craft_items_PTD [ playerid ] [ 5 + i ], 0.0000, 0.0000, 0.0000, 1.0000);
			}
			
			for ( new i = 0 ; i < 10 ; i ++ )
			{
				PlayerTextDrawShow ( playerid, craft_items_PTD [ playerid ] [ i ] ) ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	else
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 10 ; i ++ )
			{
				PlayerTextDrawDestroy ( playerid, craft_items_PTD [ playerid ] [ i ] ) ;
				craft_items_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	return 1 ;
}

stock show_craft_crafting ( playerid, bool: status )
{
	if ( status )
	{
		if ( player_device { playerid } != 2 )
		{
			craft_crafting_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 182.7335, 117.6666, "ld_spac:white"); // пусто
			PlayerTextDrawTextSize(playerid, craft_crafting_PTD[playerid][0], 73.0000, 86.0000);
			PlayerTextDrawAlignment(playerid, craft_crafting_PTD[playerid][0], 1);
			PlayerTextDrawColor(playerid, craft_crafting_PTD[playerid][0], 168430335);
			PlayerTextDrawBackgroundColor(playerid, craft_crafting_PTD[playerid][0], 255);
			PlayerTextDrawFont(playerid, craft_crafting_PTD[playerid][0], 4);
			PlayerTextDrawSetProportional(playerid, craft_crafting_PTD[playerid][0], 0);
			PlayerTextDrawSetShadow(playerid, craft_crafting_PTD[playerid][0], 0);

			new _craft_id = get_player_use_listitem ( playerid ) ;
			
			new _item = craft_info [ _craft_id ] [ c_item ], _check_hash = player_checking_hash [ playerid ] ;
			if ( ( _item >= 3294 && _item <= 3297 ) && _check_hash < 30 )
			{
				for ( new i = 0 ; i < MAX_VEH_MODELS_REPLACE ; i ++ )
				{
					if ( _item != veh_replace_model [ i ] [ 0 ] ) continue ;

					_item = veh_replace_model [ i ] [ 1 ] ;
					break ;
				}
			}
			else if ( ( _item >= 312 && _item <= 320 || _item >= 4500 && _item <= 4507 ) && _check_hash < 39 )
			{
				for ( new i = 0 ; i < MAX_SKIN_MODELS_REPLACE ; i ++ )
				{
					if ( _item != skin_replace_model [ i ] [ 0 ] ) continue ;

					_item = skin_replace_model [ i ] [ 1 ] ;
					break ;
				}
			}
			else if ( ( _item >= 12635 && _item <= 12672 ) && _check_hash < 39 )
			{
				_item = 18631 ;
			}
			
			craft_crafting_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 178.6665, 112.2740, ""); // пусто
			PlayerTextDrawTextSize(playerid, craft_crafting_PTD[playerid][1], 90.0000, 90.0000);
			PlayerTextDrawAlignment(playerid, craft_crafting_PTD[playerid][1], 1);
			PlayerTextDrawColor(playerid, craft_crafting_PTD[playerid][1], -1);
			PlayerTextDrawFont(playerid, craft_crafting_PTD[playerid][1], 5);
			PlayerTextDrawSetProportional(playerid, craft_crafting_PTD[playerid][1], 0);
			PlayerTextDrawSetShadow(playerid, craft_crafting_PTD[playerid][1], 0);
			PlayerTextDrawSetPreviewModel(playerid, craft_crafting_PTD[playerid][1], _item ) ;
			PlayerTextDrawSetPreviewRot(playerid, craft_crafting_PTD[playerid][1], -20.0000, 0.0000, -35.0000, 1.0000);
			PlayerTextDrawSetPreviewVehCol(playerid, craft_crafting_PTD[playerid][1], 1, 1);
			PlayerTextDrawBackgroundColor(playerid, craft_crafting_PTD[playerid][1], 0x00000000);
		
			for ( new i = 0 ; i < 2 ; i ++ )
			{
				PlayerTextDrawShow ( playerid, craft_crafting_PTD [ playerid ] [ i ] ) ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	else
	{
		if ( player_device { playerid } != 2 )
		{
			for ( new i = 0 ; i < 2 ; i ++ )
			{
				PlayerTextDrawDestroy ( playerid, craft_crafting_PTD [ playerid ] [ i ] ) ;
				craft_crafting_PTD [ playerid ] [ i ] = PlayerText:-1 ;
			}
		}
		else if ( player_device { playerid } == 2 )
		{
			
		}
	}
	return 1 ;
}

stock craft_OnGameModeInit ( )
{
	craft_background_TD[0] = TextDrawCreate(172.6665, 220.5404, "ld_spac:white"); // пусто
	TextDrawTextSize(craft_background_TD[0], 161.0000, 135.0000);
	TextDrawAlignment(craft_background_TD[0], 1);
	TextDrawColor(craft_background_TD[0], 235802367);
	TextDrawBackgroundColor(craft_background_TD[0], 255);
	TextDrawFont(craft_background_TD[0], 4);
	TextDrawSetProportional(craft_background_TD[0], 0);
	TextDrawSetShadow(craft_background_TD[0], 0);

	craft_background_TD[1] = TextDrawCreate(169.6665, 343.2260, "ld_beat:chit"); // пусто
	TextDrawTextSize(craft_background_TD[1], 19.0000, 24.0000);
	TextDrawAlignment(craft_background_TD[1], 1);
	TextDrawColor(craft_background_TD[1], 235802367);
	TextDrawBackgroundColor(craft_background_TD[1], 255);
	TextDrawFont(craft_background_TD[1], 4);
	TextDrawSetProportional(craft_background_TD[1], 0);
	TextDrawSetShadow(craft_background_TD[1], 0);

	craft_background_TD[2] = TextDrawCreate(324.5321, 216.6775, "ld_beat:chit"); // пусто
	TextDrawTextSize(craft_background_TD[2], 19.0000, 24.0000);
	TextDrawAlignment(craft_background_TD[2], 1);
	TextDrawColor(craft_background_TD[2], 235802367);
	TextDrawBackgroundColor(craft_background_TD[2], 255);
	TextDrawFont(craft_background_TD[2], 4);
	TextDrawSetProportional(craft_background_TD[2], 0);
	TextDrawSetShadow(craft_background_TD[2], 0);

	craft_background_TD[3] = TextDrawCreate(178.9996, 229.3995, "ld_spac:white"); // пусто
	TextDrawTextSize(craft_background_TD[3], 161.2597, 134.0000);
	TextDrawAlignment(craft_background_TD[3], 1);
	TextDrawColor(craft_background_TD[3], 235802367);
	TextDrawBackgroundColor(craft_background_TD[3], 255);
	TextDrawFont(craft_background_TD[3], 4);
	TextDrawSetProportional(craft_background_TD[3], 0);
	TextDrawSetShadow(craft_background_TD[3], 0);

	craft_background_TD[4] = TextDrawCreate(188.1997, 227.0330, ".."); // пусто
	TextDrawLetterSize(craft_background_TD[4], 0.2205, 1.1229);
	TextDrawAlignment(craft_background_TD[4], 1);
	TextDrawColor(craft_background_TD[4], -5963521);
	TextDrawBackgroundColor(craft_background_TD[4], 255);
	TextDrawFont(craft_background_TD[4], 1);
	TextDrawSetProportional(craft_background_TD[4], 1);
	TextDrawSetShadow(craft_background_TD[4], 0);

	craft_background_TD[5] = TextDrawCreate(188.1997, 229.2332, ".."); // пусто
	TextDrawLetterSize(craft_background_TD[5], 0.2205, 1.1229);
	TextDrawAlignment(craft_background_TD[5], 1);
	TextDrawColor(craft_background_TD[5], -5963521);
	TextDrawBackgroundColor(craft_background_TD[5], 255);
	TextDrawFont(craft_background_TD[5], 1);
	TextDrawSetProportional(craft_background_TD[5], 1);
	TextDrawSetShadow(craft_background_TD[5], 0);

	craft_background_TD[6] = TextDrawCreate(161.8999, 240.5516, ""); // пусто
	TextDrawTextSize(craft_background_TD[6], 39.0000, -19.0000);
	TextDrawAlignment(craft_background_TD[6], 1);
	TextDrawColor(craft_background_TD[6], -5963521);
	TextDrawFont(craft_background_TD[6], 5);
	TextDrawSetProportional(craft_background_TD[6], 0);
	TextDrawSetShadow(craft_background_TD[6], 0);
	TextDrawSetPreviewModel(craft_background_TD[6], 3090);
	TextDrawSetPreviewRot(craft_background_TD[6], 0.0000, 0.0000, 0.0000, 1.0000);
	TextDrawBackgroundColor(craft_background_TD[6], 0x00000000);

	craft_background_TD[7] = TextDrawCreate(181.5661, 216.0218, "O"); // пусто
	TextDrawLetterSize(craft_background_TD[7], 0.7013, 3.9063);
	TextDrawAlignment(craft_background_TD[7], 1);
	TextDrawColor(craft_background_TD[7], -5963521);
	TextDrawBackgroundColor(craft_background_TD[7], 255);
	TextDrawFont(craft_background_TD[7], 2);
	TextDrawSetProportional(craft_background_TD[7], 1);
	TextDrawSetShadow(craft_background_TD[7], 0);

	craft_background_TD[8] = TextDrawCreate(202.3332, 83.5923, "CRAFT_MENU"); // пусто
	TextDrawLetterSize(craft_background_TD[8], 0.1527, 0.9487);
	TextDrawAlignment(craft_background_TD[8], 1);
	TextDrawColor(craft_background_TD[8], -1);
	TextDrawBackgroundColor(craft_background_TD[8], 255);
	TextDrawFont(craft_background_TD[8], 2);
	TextDrawSetProportional(craft_background_TD[8], 1);
	TextDrawSetShadow(craft_background_TD[8], 0);

	craft_background_TD[9] = TextDrawCreate(202.3332, 230.9776, "CRAFT_ITEMS"); // пусто
	TextDrawLetterSize(craft_background_TD[9], 0.1527, 0.9487);
	TextDrawAlignment(craft_background_TD[9], 1);
	TextDrawColor(craft_background_TD[9], -1);
	TextDrawBackgroundColor(craft_background_TD[9], 255);
	TextDrawFont(craft_background_TD[9], 2);
	TextDrawSetProportional(craft_background_TD[9], 1);
	TextDrawSetShadow(craft_background_TD[9], 0);

	craft_background_TD[10] = TextDrawCreate(172.6665, 72.0363, "ld_spac:white"); // пусто
	TextDrawTextSize(craft_background_TD[10], 161.0000, 135.0000);
	TextDrawAlignment(craft_background_TD[10], 1);
	TextDrawColor(craft_background_TD[10], 235802367);
	TextDrawBackgroundColor(craft_background_TD[10], 255);
	TextDrawFont(craft_background_TD[10], 4);
	TextDrawSetProportional(craft_background_TD[10], 0);
	TextDrawSetShadow(craft_background_TD[10], 0);

	craft_background_TD[11] = TextDrawCreate(169.6665, 194.7221, "ld_beat:chit"); // пусто
	TextDrawTextSize(craft_background_TD[11], 19.0000, 24.0000);
	TextDrawAlignment(craft_background_TD[11], 1);
	TextDrawColor(craft_background_TD[11], 235802367);
	TextDrawBackgroundColor(craft_background_TD[11], 255);
	TextDrawFont(craft_background_TD[11], 4);
	TextDrawSetProportional(craft_background_TD[11], 0);
	TextDrawSetShadow(craft_background_TD[11], 0);

	craft_background_TD[12] = TextDrawCreate(324.5321, 68.1740, "ld_beat:chit"); // пусто
	TextDrawTextSize(craft_background_TD[12], 19.0000, 24.0000);
	TextDrawAlignment(craft_background_TD[12], 1);
	TextDrawColor(craft_background_TD[12], 235802367);
	TextDrawBackgroundColor(craft_background_TD[12], 255);
	TextDrawFont(craft_background_TD[12], 4);
	TextDrawSetProportional(craft_background_TD[12], 0);
	TextDrawSetShadow(craft_background_TD[12], 0);

	craft_background_TD[13] = TextDrawCreate(178.9996, 80.8955, "ld_spac:white"); // пусто
	TextDrawTextSize(craft_background_TD[13], 161.2597, 134.0000);
	TextDrawAlignment(craft_background_TD[13], 1);
	TextDrawColor(craft_background_TD[13], 235802367);
	TextDrawBackgroundColor(craft_background_TD[13], 255);
	TextDrawFont(craft_background_TD[13], 4);
	TextDrawSetProportional(craft_background_TD[13], 0);
	TextDrawSetShadow(craft_background_TD[13], 0);

	craft_background_TD[14] = TextDrawCreate(188.1997, 79.4291, ".."); // пусто
	TextDrawLetterSize(craft_background_TD[14], 0.2205, 1.1229);
	TextDrawAlignment(craft_background_TD[14], 1);
	TextDrawColor(craft_background_TD[14], -5963521);
	TextDrawBackgroundColor(craft_background_TD[14], 255);
	TextDrawFont(craft_background_TD[14], 1);
	TextDrawSetProportional(craft_background_TD[14], 1);
	TextDrawSetShadow(craft_background_TD[14], 0);

	craft_background_TD[15] = TextDrawCreate(188.1997, 81.6287, ".."); // пусто
	TextDrawLetterSize(craft_background_TD[15], 0.2205, 1.1229);
	TextDrawAlignment(craft_background_TD[15], 1);
	TextDrawColor(craft_background_TD[15], -5963521);
	TextDrawBackgroundColor(craft_background_TD[15], 255);
	TextDrawFont(craft_background_TD[15], 1);
	TextDrawSetProportional(craft_background_TD[15], 1);
	TextDrawSetShadow(craft_background_TD[15], 0);

	craft_background_TD[16] = TextDrawCreate(161.8999, 92.9468, ""); // пусто
	TextDrawTextSize(craft_background_TD[16], 39.0000, -19.0000);
	TextDrawAlignment(craft_background_TD[16], 1);
	TextDrawColor(craft_background_TD[16], -5963521);
	TextDrawFont(craft_background_TD[16], 5);
	TextDrawSetProportional(craft_background_TD[16], 0);
	TextDrawSetShadow(craft_background_TD[16], 0);
	TextDrawSetPreviewModel(craft_background_TD[16], 3090);
	TextDrawSetPreviewRot(craft_background_TD[16], 0.0000, 0.0000, 0.0000, 1.0000);
	TextDrawBackgroundColor(craft_background_TD[16], 0x00000000);

	craft_background_TD[17] = TextDrawCreate(181.3329, 68.3625, "O"); // пусто
	TextDrawLetterSize(craft_background_TD[17], 0.7013, 3.9063);
	TextDrawAlignment(craft_background_TD[17], 1);
	TextDrawColor(craft_background_TD[17], -5963521);
	TextDrawBackgroundColor(craft_background_TD[17], 255);
	TextDrawFont(craft_background_TD[17], 2);
	TextDrawSetProportional(craft_background_TD[17], 1);
	TextDrawSetShadow(craft_background_TD[17], 0);

	craft_background_TD[18] = TextDrawCreate(345.6007, 72.0363, "ld_spac:white"); // пусто
	TextDrawTextSize(craft_background_TD[18], 114.0000, 283.0000);
	TextDrawAlignment(craft_background_TD[18], 1);
	TextDrawColor(craft_background_TD[18], 235802367);
	TextDrawBackgroundColor(craft_background_TD[18], 255);
	TextDrawFont(craft_background_TD[18], 4);
	TextDrawSetProportional(craft_background_TD[18], 0);
	TextDrawSetShadow(craft_background_TD[18], 0);

	craft_background_TD[19] = TextDrawCreate(342.6329, 343.4963, "ld_beat:chit"); // пусто
	TextDrawTextSize(craft_background_TD[19], 19.0000, 24.0000);
	TextDrawAlignment(craft_background_TD[19], 1);
	TextDrawColor(craft_background_TD[19], 235802367);
	TextDrawBackgroundColor(craft_background_TD[19], 255);
	TextDrawFont(craft_background_TD[19], 4);
	TextDrawSetProportional(craft_background_TD[19], 0);
	TextDrawSetShadow(craft_background_TD[19], 0);

	craft_background_TD[20] = TextDrawCreate(450.6329, 68.2593, "ld_beat:chit"); // пусто
	TextDrawTextSize(craft_background_TD[20], 19.0000, 24.0000);
	TextDrawAlignment(craft_background_TD[20], 1);
	TextDrawColor(craft_background_TD[20], 235802367);
	TextDrawBackgroundColor(craft_background_TD[20], 255);
	TextDrawFont(craft_background_TD[20], 4);
	TextDrawSetProportional(craft_background_TD[20], 0);
	TextDrawSetShadow(craft_background_TD[20], 0);

	craft_background_TD[21] = TextDrawCreate(352.5003, 79.5034, "ld_spac:white"); // пусто
	TextDrawTextSize(craft_background_TD[21], 114.0000, 283.9497);
	TextDrawAlignment(craft_background_TD[21], 1);
	TextDrawColor(craft_background_TD[21], 235802367);
	TextDrawBackgroundColor(craft_background_TD[21], 255);
	TextDrawFont(craft_background_TD[21], 4);
	TextDrawSetProportional(craft_background_TD[21], 0);
	TextDrawSetShadow(craft_background_TD[21], 0);

	craft_background_TD[22] = TextDrawCreate(360.8659, 78.9440, ".."); // пусто
	TextDrawLetterSize(craft_background_TD[22], 0.2205, 1.1229);
	TextDrawAlignment(craft_background_TD[22], 1);
	TextDrawColor(craft_background_TD[22], -5963521);
	TextDrawBackgroundColor(craft_background_TD[22], 255);
	TextDrawFont(craft_background_TD[22], 1);
	TextDrawSetProportional(craft_background_TD[22], 1);
	TextDrawSetShadow(craft_background_TD[22], 0);

	craft_background_TD[23] = TextDrawCreate(360.8659, 81.1443, ".."); // пусто
	TextDrawLetterSize(craft_background_TD[23], 0.2205, 1.1229);
	TextDrawAlignment(craft_background_TD[23], 1);
	TextDrawColor(craft_background_TD[23], -5963521);
	TextDrawBackgroundColor(craft_background_TD[23], 255);
	TextDrawFont(craft_background_TD[23], 1);
	TextDrawSetProportional(craft_background_TD[23], 1);
	TextDrawSetShadow(craft_background_TD[23], 0);

	craft_background_TD[24] = TextDrawCreate(334.5663, 92.4626, ""); // пусто
	TextDrawTextSize(craft_background_TD[24], 39.0000, -19.0000);
	TextDrawAlignment(craft_background_TD[24], 1);
	TextDrawColor(craft_background_TD[24], -5963521);
	TextDrawFont(craft_background_TD[24], 5);
	TextDrawSetProportional(craft_background_TD[24], 0);
	TextDrawSetShadow(craft_background_TD[24], 0);
	TextDrawSetPreviewModel(craft_background_TD[24], 3090);
	TextDrawSetPreviewRot(craft_background_TD[24], 0.0000, 0.0000, 0.0000, 1.0000);
	TextDrawBackgroundColor(craft_background_TD[24], 0x00000000);

	craft_background_TD[25] = TextDrawCreate(353.9992, 67.8767, "O"); // пусто
	TextDrawLetterSize(craft_background_TD[25], 0.7013, 3.9063);
	TextDrawAlignment(craft_background_TD[25], 1);
	TextDrawColor(craft_background_TD[25], -5963521);
	TextDrawBackgroundColor(craft_background_TD[25], 255);
	TextDrawFont(craft_background_TD[25], 2);
	TextDrawSetProportional(craft_background_TD[25], 1);
	TextDrawSetShadow(craft_background_TD[25], 0);
	return 1 ;
}

stock show_packet_craft ( playerid, _param1, _param2 )
{
	if ( _param1 == 0 )
	{
		if ( _param2 == 0 )
		{
			if ( job_timer [ playerid ] != -1 )
			{
				send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
			
			CraftHide ( playerid ) ;
			craft_ptd_status ( playerid, false ) ;
		}
	}
	else if ( _param1 == 1 )
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		craftClearItem ( playerid, 0 ) ;
		CraftMainAddItem ( playerid, _param2 ) ;
	}
	else if ( _param1 == 2 )
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
		
		new _chance_bonus = 0, _str [ 12 ], _h_id, bool: status = false ;
		if ( GetPVarInt ( playerid, "house_id" ) > 0 ) 
		{
			_h_id = GetPVarInt ( playerid, "house_id" ) ;
			_chance_bonus = h_info [ _h_id - 1 ] [ h_upgrade_craft ] ;
		}
		else if ( GetPVarInt ( playerid, "cellar_id" ) > 0 ) 
		{
			_h_id = GetPVarInt ( playerid, "cellar_id" ) ;
			_chance_bonus = cellar_info [ _h_id - 1 ] [ cl_upgrade_craft ] ;
		}
		if ( p_info [ playerid ] [ crime_plus ] ) _chance_bonus += 10 ;
		
		format ( _str, sizeof _str, "%d ", craft_info [ _param2 ] [ c_chance ] + _chance_bonus ) ;
		updateCraftBlocked ( playerid, 0, true, "ШАНС УСПЕХА", _str ) ;
		format ( _str, sizeof _str, "%s ", GetPlayerCashValueToSmile ( craft_info [ _param2 ] [ c_price ] ) ) ;
		updateCraftBlocked ( playerid, 1, true, "СТОИМОСТЬ", _str ) ;
		updateCraftBlocked ( playerid, 2, false, "", "" ) ;
		
		player_count_craft { playerid } = 1 ;
		updateCraftCount ( playerid, "1" ) ;
		craftClearItem ( playerid, 1 ) ;
		
		new _item, _i_count, _c_qua ;
		for ( new i = 0 ; i < 5 ; i ++ )
		{
			_item = craft_info [ _param2 ] [ c_composition ] [ i ] ;
			if ( _item == 18631 ) continue ;

			_i_count = get_player_item_prise ( playerid, _item ) ;
			_c_qua = craft_info [ _param2 ] [ c_quantity ] [ i ] ;
			format ( _str, sizeof _str, "%d/%d", _i_count, _c_qua ) ;
			
			if ( _i_count >= _c_qua ) rvResItem ( playerid, _item, _str, "#ff33AA33" ) ;
			else rvResItem ( playerid, _item, _str, "#ffAA3333" ), status = true ;
		}
		
		if ( status ) updateCraft ( playerid, 4, 0, 0, 0, "" ) ;
		else updateCraft ( playerid, 3, 0, 0, 0, "" ) ;
		
		set_player_use_listitem ( playerid, _param2 ) ;
	}
	else if ( _param1 == 3 )
	{
		if ( job_timer [ playerid ] != -1 )
		{
			send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
			return 1 ;
		}
			
		if ( _param2 == 1 )
		{
			if ( player_count_craft { playerid } > 1 )
			{
				player_count_craft { playerid } -- ;
				
				new _str [ 12 ] ;
				format ( _str, sizeof _str, "%d", player_count_craft { playerid } ) ;
				updateCraftCount ( playerid, _str ) ;
			}
		}
		else if ( _param2 == 2 )
		{
			player_count_craft { playerid } += 1 ;
			
			new _craft_id = get_player_use_listitem ( playerid ) ;
			if ( p_info [ playerid ] [ money ] < craft_info [ _craft_id ] [ c_price ] * player_count_craft { playerid } )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно денежных средств!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				player_count_craft { playerid } -= 1 ;
				return 1 ;
			}
			
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				if ( craft_info [ _craft_id ] [ c_composition ] [ i ] == 18631 ) continue ;

				new _i_count = get_player_item_prise ( playerid, craft_info [ _craft_id ] [ c_composition ] [ i ] ) ;
				if ( _i_count < craft_info [ _craft_id ] [ c_quantity ] [ i ] * player_count_craft { playerid } )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно ингредиентов!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					player_count_craft { playerid } -= 1 ;
					return 1 ;
				}
			}
			
			craftClearItem ( playerid, 1 ) ;
			
			new _item, _i_count, _c_qua, _str [ 24 ], bool: status = false ;
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				_item = craft_info [ _param2 ] [ c_composition ] [ i ] ;
				if ( _item == 18631 ) continue ;

				_i_count = get_player_item_prise ( playerid, _item ) ;
				_c_qua = craft_info [ _param2 ] [ c_quantity ] [ i ] * player_count_craft { playerid } ;
				format ( _str, sizeof _str, "%d/%d", _i_count, _c_qua ) ;
				
				if ( _i_count >= _c_qua ) rvResItem ( playerid, _item, _str, "#ff33AA33" ) ;
				else rvResItem ( playerid, _item, _str, "#ffAA3333" ), status = true ;
			}
			
			if ( status ) updateCraft ( playerid, 4, 0, 0, 0, "" ) ;
			else updateCraft ( playerid, 3, 0, 0, 0, "" ) ;
	
			format ( _str, sizeof _str, "%d", player_count_craft { playerid } ) ;
			updateCraftCount ( playerid, _str ) ;
		}
	}
	else if ( _param1 == 4 )
	{
		if ( _param2 == 1 )
		{
			if ( job_timer [ playerid ] != -1 )
			{
				send_check_cinfo ( playerid, "Вы уже изготавливаете предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
		
			new _craft_id = get_player_use_listitem ( playerid ) ;
			if ( p_info [ playerid ] [ money ] < craft_info [ _craft_id ] [ c_price ] * player_count_craft { playerid } )
			{
				send_check_cinfo ( playerid, "У Вас недостаточно денежных средств!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
				return 1 ;
			}
					
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				if ( craft_info [ _craft_id ] [ c_composition ] [ i ] == 18631 ) continue ;

				new _i_count = get_player_item_prise ( playerid, craft_info [ _craft_id ] [ c_composition ] [ i ] ) ;
				if ( _i_count < craft_info [ _craft_id ] [ c_quantity ] [ i ] * player_count_craft { playerid } )
				{
					send_check_cinfo ( playerid, "У Вас недостаточно ингредиентов!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
					return 1 ;
				}
			}
				
			for ( new i = 0 ; i < 5 ; i ++ )
			{
				if ( craft_info [ _craft_id ] [ c_composition ] [ i ] == 18631 ) continue ;
				
				clear_player_item_prise ( playerid, craft_info [ _craft_id ] [ c_composition ] [ i ], craft_info [ _craft_id ] [ c_quantity ] [ i ] * player_count_craft { playerid } ) ;
			}
			
			send_check_cinfo ( playerid, "Вы начали крафтить. Ожидайте!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_SUCESS, "", "" ) ;
			job_timer [ playerid ] = SetTimerEx ( "craft_timer", 1000, false, "ii", playerid, player_count_craft { playerid } ) ;
			player_craft_time { playerid } = 20 ;
			
			used_craft [ playerid ] = true ;

			ApplyAnimation ( playerid, "CAR_CHAT", "CAR_Sc4_BL", 4.0, 1, 1, 1, 1, 5800, 0 ) ;
		}
		else if ( _param2 == 2 )
		{
			send_check_cinfo ( playerid, "Вы не можете изготовить предмет!", 0, 300, CINFO_OTHER_ID, CINFO_TYPE_AREA, PICTURE_INFO_ERROR, "", "" ) ;
		}
	}
	else if ( _param1 == 5 )
	{
		KillTimer ( job_timer [ playerid ] ) ;
		job_timer [ playerid ] = -1 ;
		
		show_packet_craft ( playerid, 2, 0 ) ;
	}
	else if ( _param1 == 6 )
	{
		show_packet_craft ( playerid, 2, 0 ) ;
	}
	else if ( _param1 == 10 )
	{
		global_string [ 0 ] = EOS ;
		format ( global_string, 512, "\
			{"#cWH"}Название: {"#cOR"}%s\n\n\
			{"#cWH"}%s", 
		item_name ( _param2 ), item_description ( _param2 ) ) ;
		show_dialog ( playerid, d_none, DIALOG_STYLE_MSGBOX, "{"#cBHD"}Информация", global_string, "Принять", "" ) ;
	}
	return 1 ;
}

CMD:testc ( playerid )
{
	if ( admin_info [ playerid ] [ admin ] < 8 ) return 1 ;
	
	show_craft_buttons ( playerid, true ) ;
	return 1 ;
}