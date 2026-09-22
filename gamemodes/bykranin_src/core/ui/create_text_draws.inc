//>> Файл: bykranin_src/core/ui/create_text_draws.inc  (1043 строк)
//>> Тема: интерфейс: текстдравы, панели, уведомления, меню
//>> Внутри: CreateTextDraws
//>> Файл подключается из gamemodes/bykranin.pwn; порядок include менять нельзя (см. bykranin_src/GUIDE.md).
stock CreateTextDraws()
{
	new playerid;
	enter_speedometr_TD[0] = TextDrawCreate(151.4990, 134.6741, "txd:enter_speedometr"); // generated
	TextDrawTextSize(enter_speedometr_TD[0], 341.0000, 186.0000);
	TextDrawAlignment(enter_speedometr_TD[0], 1);
	TextDrawColor(enter_speedometr_TD[0], -1);
	TextDrawBackgroundColor(enter_speedometr_TD[0], 255);
	TextDrawFont(enter_speedometr_TD[0], 4);
	TextDrawSetProportional(enter_speedometr_TD[0], 0);
	TextDrawSetShadow(enter_speedometr_TD[0], 0);

	enter_speedometr_TD[1] = TextDrawCreate(151.4000, 162.4667, "speedometr_1"); // generated
	TextDrawTextSize(enter_speedometr_TD[1], 169.0000, 155.0000);
	TextDrawAlignment(enter_speedometr_TD[1], 1);
	TextDrawColor(enter_speedometr_TD[1], -1);
	TextDrawBackgroundColor(enter_speedometr_TD[1], 255);
	TextDrawFont(enter_speedometr_TD[1], 4);
	TextDrawSetProportional(enter_speedometr_TD[1], 0);
	TextDrawSetShadow(enter_speedometr_TD[1], 0);
	TextDrawSetSelectable(enter_speedometr_TD[1], true);

	enter_speedometr_TD[2] = TextDrawCreate(322.7023, 161.9689, "speedometr_2"); // generated
	TextDrawTextSize(enter_speedometr_TD[2], 169.0000, 155.0000);
	TextDrawAlignment(enter_speedometr_TD[2], 1);
	TextDrawColor(enter_speedometr_TD[2], -1);
	TextDrawBackgroundColor(enter_speedometr_TD[2], 255);
	TextDrawFont(enter_speedometr_TD[2], 4);
	TextDrawSetProportional(enter_speedometr_TD[2], 0);
	TextDrawSetShadow(enter_speedometr_TD[2], 0);
	TextDrawSetSelectable(enter_speedometr_TD[2], true);

	enter_speedometr_TD[3] = TextDrawCreate(431.3999, 294.8756, "exit"); // generated
	TextDrawTextSize(enter_speedometr_TD[3], 61.0000, 27.0000);
	TextDrawAlignment(enter_speedometr_TD[3], 1);
	TextDrawColor(enter_speedometr_TD[3], -1);
	TextDrawBackgroundColor(enter_speedometr_TD[3], 255);
	TextDrawFont(enter_speedometr_TD[3], 4);
	TextDrawSetProportional(enter_speedometr_TD[3], 0);
	TextDrawSetShadow(enter_speedometr_TD[3], 0);
	TextDrawSetSelectable(enter_speedometr_TD[3], true);
	
	speedometr02_TD[0] = TextDrawCreate(263.3994, 351.1237, "txd:speedometr02"); // generated
	TextDrawTextSize(speedometr02_TD[0], 111.0000, 90.0000);
	TextDrawAlignment(speedometr02_TD[0], 1);
	TextDrawColor(speedometr02_TD[0], -1);
	TextDrawBackgroundColor(speedometr02_TD[0], 255);
	TextDrawFont(speedometr02_TD[0], 4);
	TextDrawSetProportional(speedometr02_TD[0], 0);
	TextDrawSetShadow(speedometr02_TD[0], 0);
	
	speedometr_TD[0] = TextDrawCreate(248.8017, 312.7956, "txd:speedometr"); // generated
	TextDrawTextSize(speedometr_TD[0], 142.0000, 172.0000);
	TextDrawAlignment(speedometr_TD[0], 1);
	TextDrawColor(speedometr_TD[0], -1);
	TextDrawBackgroundColor(speedometr_TD[0], 255);
	TextDrawFont(speedometr_TD[0], 4);
	TextDrawSetProportional(speedometr_TD[0], 0);
	TextDrawSetShadow(speedometr_TD[0], 0);
	
	buy_car_number_TD[0] = TextDrawCreate(-25.3997, -285.5335, "txd:buy_car_number"); // generated
	TextDrawTextSize(buy_car_number_TD[0], 700.0000, 1017.0000);
	TextDrawAlignment(buy_car_number_TD[0], 1);
	TextDrawColor(buy_car_number_TD[0], -1);
	TextDrawBackgroundColor(buy_car_number_TD[0], 255);
	TextDrawFont(buy_car_number_TD[0], 4);
	TextDrawSetProportional(buy_car_number_TD[0], 0);
	TextDrawSetShadow(buy_car_number_TD[0], 0);
	TextDrawSetSelectable(buy_car_number_TD[0], true);

	buy_car_number_TD[1] = TextDrawCreate(383.0000, 172.4221, "txd:flag_RUS"); // generated
	TextDrawTextSize(buy_car_number_TD[1], 91.0000, 117.0000);
	TextDrawAlignment(buy_car_number_TD[1], 1);
	TextDrawColor(buy_car_number_TD[1], -1);
	TextDrawBackgroundColor(buy_car_number_TD[1], 255);
	TextDrawFont(buy_car_number_TD[1], 4);
	TextDrawSetProportional(buy_car_number_TD[1], 0);
	TextDrawSetShadow(buy_car_number_TD[1], 0);

	buy_car_number_TD[2] = TextDrawCreate(195.0001, 372.5289, "buy_number"); // generated
	TextDrawTextSize(buy_car_number_TD[2], 120.0000, 62.0000);
	TextDrawAlignment(buy_car_number_TD[2], 1);
	TextDrawColor(buy_car_number_TD[2], -1);
	TextDrawBackgroundColor(buy_car_number_TD[2], 255);
	TextDrawFont(buy_car_number_TD[2], 4);
	TextDrawSetProportional(buy_car_number_TD[2], 0);
	TextDrawSetShadow(buy_car_number_TD[2], 0);
	TextDrawSetSelectable(buy_car_number_TD[2], true);

	buy_car_number_TD[3] = TextDrawCreate(335.0000, 372.5289, "exit"); // generated
	TextDrawTextSize(buy_car_number_TD[3], 117.0000, 59.0000);
	TextDrawAlignment(buy_car_number_TD[3], 1);
	TextDrawColor(buy_car_number_TD[3], -1);
	TextDrawBackgroundColor(buy_car_number_TD[3], 255);
	TextDrawFont(buy_car_number_TD[3], 4);
	TextDrawSetProportional(buy_car_number_TD[3], 0);
	TextDrawSetShadow(buy_car_number_TD[3], 0);
	TextDrawSetSelectable(buy_car_number_TD[3], true);

	buy_car_number_TD[4] = TextDrawCreate(167.3999, 167.9420, "input_number"); // generated
	TextDrawTextSize(buy_car_number_TD[4], 213.0000, 110.0000);
	TextDrawAlignment(buy_car_number_TD[4], 1);
	TextDrawColor(buy_car_number_TD[4], -1);
	TextDrawBackgroundColor(buy_car_number_TD[4], 255);
	TextDrawFont(buy_car_number_TD[4], 4);
	TextDrawSetProportional(buy_car_number_TD[4], 0);
	TextDrawSetShadow(buy_car_number_TD[4], 0);
	TextDrawSetSelectable(buy_car_number_TD[4], true);

	buy_car_number_TD[5] = TextDrawCreate(381.3999, 167.9420, "enter_flag"); // generated
	TextDrawTextSize(buy_car_number_TD[5], 100.0000, 108.0000);
	TextDrawAlignment(buy_car_number_TD[5], 1);
	TextDrawColor(buy_car_number_TD[5], -1);
	TextDrawBackgroundColor(buy_car_number_TD[5], 255);
	TextDrawFont(buy_car_number_TD[5], 4);
	TextDrawSetProportional(buy_car_number_TD[5], 0);
	TextDrawSetShadow(buy_car_number_TD[5], 0);
	TextDrawSetSelectable(buy_car_number_TD[5], true);

	buy_car_number_TD[6] = TextDrawCreate(1.0000, 93.2753, "enter_flag_ru"); // generated
	TextDrawTextSize(buy_car_number_TD[6], 90.0000, 80.0000);
	TextDrawAlignment(buy_car_number_TD[6], 1);
	TextDrawColor(buy_car_number_TD[6], -1);
	TextDrawBackgroundColor(buy_car_number_TD[6], 255);
	TextDrawFont(buy_car_number_TD[6], 4);
	TextDrawSetProportional(buy_car_number_TD[6], 0);
	TextDrawSetShadow(buy_car_number_TD[6], 0);
	TextDrawSetSelectable(buy_car_number_TD[6], true);

	buy_car_number_TD[7] = TextDrawCreate(1.3997, 173.9154, "enter_flag_kz"); // generated
	TextDrawTextSize(buy_car_number_TD[7], 89.0000, 77.0000);
	TextDrawAlignment(buy_car_number_TD[7], 1);
	TextDrawColor(buy_car_number_TD[7], -1);
	TextDrawBackgroundColor(buy_car_number_TD[7], 255);
	TextDrawFont(buy_car_number_TD[7], 4);
	TextDrawSetProportional(buy_car_number_TD[7], 0);
	TextDrawSetShadow(buy_car_number_TD[7], 0);
	TextDrawSetSelectable(buy_car_number_TD[7], true);

	buy_car_number_TD[8] = TextDrawCreate(3.3998, 253.0621, "enter_flag_by"); // generated
	TextDrawTextSize(buy_car_number_TD[8], 89.0000, 77.0000);
	TextDrawAlignment(buy_car_number_TD[8], 1);
	TextDrawColor(buy_car_number_TD[8], -1);
	TextDrawBackgroundColor(buy_car_number_TD[8], 255);
	TextDrawFont(buy_car_number_TD[8], 4);
	TextDrawSetProportional(buy_car_number_TD[8], 0);
	TextDrawSetShadow(buy_car_number_TD[8], 0);
	TextDrawSetSelectable(buy_car_number_TD[8], true);

	buy_car_number_TD[9] = TextDrawCreate(1.3997, 336.6889, "enter_flag_ua"); // generated
	TextDrawTextSize(buy_car_number_TD[9], 90.0000, 90.0000);
	TextDrawAlignment(buy_car_number_TD[9], 1);
	TextDrawColor(buy_car_number_TD[9], -1);
	TextDrawBackgroundColor(buy_car_number_TD[9], 255);
	TextDrawFont(buy_car_number_TD[9], 4);
	TextDrawSetProportional(buy_car_number_TD[9], 0);
	TextDrawSetShadow(buy_car_number_TD[9], 0);
	TextDrawSetSelectable(buy_car_number_TD[9], true);

	buy_car_number_TD[10] = TextDrawCreate(383.0000, 172.4221, "txd:flag_KZ"); // generated
	TextDrawTextSize(buy_car_number_TD[10], 91.0000, 117.0000);
	TextDrawAlignment(buy_car_number_TD[10], 1);
	TextDrawColor(buy_car_number_TD[10], -1);
	TextDrawBackgroundColor(buy_car_number_TD[10], 255);
	TextDrawFont(buy_car_number_TD[10], 4);
	TextDrawSetProportional(buy_car_number_TD[10], 0);
	TextDrawSetShadow(buy_car_number_TD[10], 0);

	buy_car_number_TD[12] = TextDrawCreate(383.0000, 172.4221, "txd:flag_UA"); // generated
	TextDrawLetterSize(buy_car_number_TD[12], 91.0000, 117.0000);
	TextDrawAlignment(buy_car_number_TD[12], 1);
	TextDrawColor(buy_car_number_TD[12], -1);
	TextDrawBackgroundColor(buy_car_number_TD[12], 255);
	TextDrawFont(buy_car_number_TD[12], 4);
	TextDrawSetProportional(buy_car_number_TD[12], 0);
	TextDrawSetShadow(buy_car_number_TD[12], 0);

	buy_car_number_TD[13] = TextDrawCreate(383.0000, 172.4221, "txd:flag_BY"); // generated
	TextDrawTextSize(buy_car_number_TD[13], 91.0000, 117.0000);
	TextDrawAlignment(buy_car_number_TD[13], 1);
	TextDrawColor(buy_car_number_TD[13], -1);
	TextDrawBackgroundColor(buy_car_number_TD[13], 255);
	TextDrawFont(buy_car_number_TD[13], 4);
	TextDrawSetProportional(buy_car_number_TD[13], 0);
	TextDrawSetShadow(buy_car_number_TD[13], 0);

	buy_car_number_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 214.3997, 197.4667, ""); // generated
	PlayerTextDrawLetterSize(playerid, buy_car_number_PTD[playerid][0], 1.0231, 5.7761);
	PlayerTextDrawAlignment(playerid, buy_car_number_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, buy_car_number_PTD[playerid][0], -1378294017);
	PlayerTextDrawBackgroundColor(playerid, buy_car_number_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, buy_car_number_PTD[playerid][0], 3);
	PlayerTextDrawSetProportional(playerid, buy_car_number_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, buy_car_number_PTD[playerid][0], 0);

	buy_car_number_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 585.2005, 203.9378, ""); // generated
	PlayerTextDrawLetterSize(playerid, buy_car_number_PTD[playerid][1], 0.4338, 2.0878);
	PlayerTextDrawAlignment(playerid, buy_car_number_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, buy_car_number_PTD[playerid][1], 16711935);
	PlayerTextDrawBackgroundColor(playerid, buy_car_number_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, buy_car_number_PTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, buy_car_number_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, buy_car_number_PTD[playerid][1], 0);
	
	shop_clothes_TD[0] = TextDrawCreate(8.6000, 120.1555, "txd:shop_clothes_buy_and_exit"); // generated
	TextDrawTextSize(shop_clothes_TD[0], 184.0000, 225.0000);
	TextDrawAlignment(shop_clothes_TD[0], 1);
	TextDrawColor(shop_clothes_TD[0], -1);
	TextDrawBackgroundColor(shop_clothes_TD[0], 255);
	TextDrawFont(shop_clothes_TD[0], 4);
	TextDrawSetProportional(shop_clothes_TD[0], 0);
	TextDrawSetShadow(shop_clothes_TD[0], 0);

	shop_clothes_TD[1] = TextDrawCreate(372.6001, 358.5910, "next"); // generated
	TextDrawTextSize(shop_clothes_TD[1], 83.0000, 40.0000);
	TextDrawAlignment(shop_clothes_TD[1], 1);
	TextDrawColor(shop_clothes_TD[1], -1);
	TextDrawBackgroundColor(shop_clothes_TD[1], 255);
	TextDrawFont(shop_clothes_TD[1], 4);
	TextDrawSetProportional(shop_clothes_TD[1], 0);
	TextDrawSetShadow(shop_clothes_TD[1], 0);
	TextDrawSetSelectable(shop_clothes_TD[1], true);

	shop_clothes_TD[2] = TextDrawCreate(181.0001, 359.0888, "back"); // generated
	TextDrawTextSize(shop_clothes_TD[2], 84.0000, 40.0000);
	TextDrawAlignment(shop_clothes_TD[2], 1);
	TextDrawColor(shop_clothes_TD[2], -1);
	TextDrawBackgroundColor(shop_clothes_TD[2], 255);
	TextDrawFont(shop_clothes_TD[2], 4);
	TextDrawSetProportional(shop_clothes_TD[2], 0);
	TextDrawSetShadow(shop_clothes_TD[2], 0);
	TextDrawSetSelectable(shop_clothes_TD[2], true);

	shop_clothes_TD[3] = TextDrawCreate(12.2000, 253.0623, "buy"); // generated
	TextDrawTextSize(shop_clothes_TD[3], 79.0000, 37.0000);
	TextDrawAlignment(shop_clothes_TD[3], 1);
	TextDrawColor(shop_clothes_TD[3], -1);
	TextDrawBackgroundColor(shop_clothes_TD[3], 255);
	TextDrawFont(shop_clothes_TD[3], 4);
	TextDrawSetProportional(shop_clothes_TD[3], 0);
	TextDrawSetShadow(shop_clothes_TD[3], 0);
	TextDrawSetSelectable(shop_clothes_TD[3], true);

	shop_clothes_TD[4] = TextDrawCreate(109.7999, 254.0577, "exit"); // generated
	TextDrawTextSize(shop_clothes_TD[4], 78.0000, 34.0000);
	TextDrawAlignment(shop_clothes_TD[4], 1);
	TextDrawColor(shop_clothes_TD[4], -1);
	TextDrawBackgroundColor(shop_clothes_TD[4], 255);
	TextDrawFont(shop_clothes_TD[4], 4);
	TextDrawSetProportional(shop_clothes_TD[4], 0);
	TextDrawSetShadow(shop_clothes_TD[4], 0);
	TextDrawSetSelectable(shop_clothes_TD[4], true);
	
	shop_clothes_TD[5] = TextDrawCreate(168.5998, 182.8753, "txd:shop_clothes_next_and_back"); // generated
	TextDrawTextSize(shop_clothes_TD[5], 301.0000, 394.0000);
	TextDrawAlignment(shop_clothes_TD[5], 1);
	TextDrawColor(shop_clothes_TD[5], -1);
	TextDrawBackgroundColor(shop_clothes_TD[5], 255);
	TextDrawFont(shop_clothes_TD[5], 4);
	TextDrawSetProportional(shop_clothes_TD[5], 0);
	TextDrawSetShadow(shop_clothes_TD[5], 0);


	business_menu_TD[0] = TextDrawCreate(124.2000, -35.6488, "txd:business_menu"); // generated
	TextDrawTextSize(business_menu_TD[0], 392.0000, 514.0000);
	TextDrawAlignment(business_menu_TD[0], 1);
	TextDrawColor(business_menu_TD[0], -1);
	TextDrawBackgroundColor(business_menu_TD[0], 255);
	TextDrawFont(business_menu_TD[0], 4);
	TextDrawSetProportional(business_menu_TD[0], 0);
	TextDrawSetShadow(business_menu_TD[0], 0);

	business_menu_TD[1] = TextDrawCreate(327.3999, 134.5911, "Business_Menu"); // generated
	TextDrawTextSize(business_menu_TD[1], 168.0000, 88.0000);
	TextDrawAlignment(business_menu_TD[1], 1);
	TextDrawColor(business_menu_TD[1], -1);
	TextDrawBackgroundColor(business_menu_TD[1], 255);
	TextDrawFont(business_menu_TD[1], 4);
	TextDrawSetProportional(business_menu_TD[1], 0);
	TextDrawSetShadow(business_menu_TD[1], 0);
	TextDrawSetSelectable(business_menu_TD[1], true);

	business_menu_TD[2] = TextDrawCreate(327.7998, 228.1734, "Business_Finka"); // generated
	TextDrawTextSize(business_menu_TD[2], 168.0000, 88.0000);
	TextDrawAlignment(business_menu_TD[2], 1);
	TextDrawColor(business_menu_TD[2], -1);
	TextDrawBackgroundColor(business_menu_TD[2], 255);
	TextDrawFont(business_menu_TD[2], 4);
	TextDrawSetProportional(business_menu_TD[2], 0);
	TextDrawSetShadow(business_menu_TD[2], 0);
	TextDrawSetSelectable(business_menu_TD[2], true);

	business_menu_TD[3] = TextDrawCreate(439.0000, 328.2268, "Business_menu_exit"); // generated
	TextDrawTextSize(business_menu_TD[3], 66.0000, 30.0000);
	TextDrawAlignment(business_menu_TD[3], 1);
	TextDrawColor(business_menu_TD[3], -1);
	TextDrawBackgroundColor(business_menu_TD[3], 255);
	TextDrawFont(business_menu_TD[3], 4);
	TextDrawSetProportional(business_menu_TD[3], 0);
	TextDrawSetShadow(business_menu_TD[3], 0);
	TextDrawSetSelectable(business_menu_TD[3], true);

	business_menu_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 205.1999, 144.7021, "Business_Name"); // generated
	PlayerTextDrawLetterSize(playerid, business_menu_PTD[playerid][0], 0.2031, 1.2167);
	PlayerTextDrawAlignment(playerid, business_menu_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, business_menu_PTD[playerid][0], -16776961);
	PlayerTextDrawBackgroundColor(playerid, business_menu_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, business_menu_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, business_menu_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, business_menu_PTD[playerid][0], 0);

	business_menu_PTD[playerid][1] = CreatePlayerTextDraw(playerid, 205.1999, 189.5022, "Jackson_Vendetta"); // generated
	PlayerTextDrawLetterSize(playerid, business_menu_PTD[playerid][1], 0.1951, 1.4257);
	PlayerTextDrawAlignment(playerid, business_menu_PTD[playerid][1], 1);
	PlayerTextDrawColor(playerid, business_menu_PTD[playerid][1], -16776961);
	PlayerTextDrawBackgroundColor(playerid, business_menu_PTD[playerid][1], 255);
	PlayerTextDrawFont(playerid, business_menu_PTD[playerid][1], 1);
	PlayerTextDrawSetProportional(playerid, business_menu_PTD[playerid][1], 1);
	PlayerTextDrawSetShadow(playerid, business_menu_PTD[playerid][1], 0);

	business_menu_PTD[playerid][2] = CreatePlayerTextDraw(playerid, 206.4000, 235.2977, "100000000$"); // generated
	PlayerTextDrawLetterSize(playerid, business_menu_PTD[playerid][2], 0.2627, 1.5552);
	PlayerTextDrawAlignment(playerid, business_menu_PTD[playerid][2], 1);
	PlayerTextDrawColor(playerid, business_menu_PTD[playerid][2], 8388863);
	PlayerTextDrawBackgroundColor(playerid, business_menu_PTD[playerid][2], 255);
	PlayerTextDrawFont(playerid, business_menu_PTD[playerid][2], 1);
	PlayerTextDrawSetProportional(playerid, business_menu_PTD[playerid][2], 1);
	PlayerTextDrawSetShadow(playerid, business_menu_PTD[playerid][2], 0);

	business_menu_PTD[playerid][3] = CreatePlayerTextDraw(playerid, 209.1999, 282.5866, "50000$"); // generated
	PlayerTextDrawLetterSize(playerid, business_menu_PTD[playerid][3], 0.2643, 1.4855);
	PlayerTextDrawAlignment(playerid, business_menu_PTD[playerid][3], 1);
	PlayerTextDrawColor(playerid, business_menu_PTD[playerid][3], 8388863);
	PlayerTextDrawBackgroundColor(playerid, business_menu_PTD[playerid][3], 255);
	PlayerTextDrawFont(playerid, business_menu_PTD[playerid][3], 1);
	PlayerTextDrawSetProportional(playerid, business_menu_PTD[playerid][3], 1);
	PlayerTextDrawSetShadow(playerid, business_menu_PTD[playerid][3], 0);

	avtsln_TD[0] = TextDrawCreate(209.1670, 349.4444, "txd:brsalonmain"); // пусто
	TextDrawTextSize(avtsln_TD[0], 226.0000, 57.0000);
	TextDrawAlignment(avtsln_TD[0], 1);
	TextDrawColor(avtsln_TD[0], -1);
	TextDrawBackgroundColor(avtsln_TD[0], 255);
	TextDrawFont(avtsln_TD[0], 4);
	TextDrawSetProportional(avtsln_TD[0], 0);
	TextDrawSetShadow(avtsln_TD[0], 0);

	avtsln_TD[1] = TextDrawCreate(209.1665, 409.5922, "txd:brsalontestdrive"); // Тест-драйв
	TextDrawTextSize(avtsln_TD[1], 74.0000, 26.0000);
	TextDrawAlignment(avtsln_TD[1], 1);
	TextDrawColor(avtsln_TD[1], -1);
	TextDrawBackgroundColor(avtsln_TD[1], 255);
	TextDrawFont(avtsln_TD[1], 4);
	TextDrawSetProportional(avtsln_TD[1], 0);
	TextDrawSetShadow(avtsln_TD[1], 0);
    TextDrawSetSelectable(avtsln_TD[1], true);

	avtsln_TD[2] = TextDrawCreate(285.4164, 409.5922, "txd:brsalonbuy"); // Приобрести
	TextDrawTextSize(avtsln_TD[2], 74.0000, 26.0000);
	TextDrawAlignment(avtsln_TD[2], 1);
	TextDrawColor(avtsln_TD[2], -1);
	TextDrawBackgroundColor(avtsln_TD[2], 255);
	TextDrawFont(avtsln_TD[2], 4);
	TextDrawSetProportional(avtsln_TD[2], 0);
	TextDrawSetShadow(avtsln_TD[2], 0);
    TextDrawSetSelectable(avtsln_TD[2], true);

	avtsln_TD[3] = TextDrawCreate(361.6665, 409.0739, "txd:brsalonclose"); // Выйти
	TextDrawTextSize(avtsln_TD[3], 74.0000, 26.0000);
	TextDrawAlignment(avtsln_TD[3], 1);
	TextDrawColor(avtsln_TD[3], -1);
	TextDrawBackgroundColor(avtsln_TD[3], 255);
	TextDrawFont(avtsln_TD[3], 4);
	TextDrawSetProportional(avtsln_TD[3], 0);
	TextDrawSetShadow(avtsln_TD[3], 0);
    TextDrawSetSelectable(avtsln_TD[3], true);

	avtsln_TD[4] = TextDrawCreate(87.0831, 378.9999, "txd:brsalonleft"); // Назад (влево) / выбор транспорта
	TextDrawTextSize(avtsln_TD[4], 27.0000, 35.0000);
	TextDrawAlignment(avtsln_TD[4], 1);
	TextDrawColor(avtsln_TD[4], -1);
	TextDrawBackgroundColor(avtsln_TD[4], 255);
	TextDrawFont(avtsln_TD[4], 4);
	TextDrawSetProportional(avtsln_TD[4], 0);
	TextDrawSetShadow(avtsln_TD[4], 0);
    TextDrawSetSelectable(avtsln_TD[4], true);

	avtsln_TD[5] = TextDrawCreate(540.8333, 378.9999, "txd:brsalonright"); // пусто
	TextDrawTextSize(avtsln_TD[5], 27.0000, 35.0000);
	TextDrawAlignment(avtsln_TD[5], 1);
	TextDrawColor(avtsln_TD[5], -1);
	TextDrawBackgroundColor(avtsln_TD[5], 255);
	TextDrawFont(avtsln_TD[5], 4);
	TextDrawSetProportional(avtsln_TD[5], 0);
	TextDrawSetShadow(avtsln_TD[5], 0);
    TextDrawSetSelectable(avtsln_TD[5], true);

	avtsln_TD[6] = TextDrawCreate(499.5831, 142.0366, "txd:brsaloninfo"); // пусто
	TextDrawTextSize(avtsln_TD[6], 129.0000, 87.0000);
	TextDrawAlignment(avtsln_TD[6], 1);
	TextDrawColor(avtsln_TD[6], -1);
	TextDrawBackgroundColor(avtsln_TD[6], 255);
	TextDrawFont(avtsln_TD[6], 4);
	TextDrawSetProportional(avtsln_TD[6], 0);
	TextDrawSetShadow(avtsln_TD[6], 0);

	avtsln_TD[7] = TextDrawCreate(499.9999, 233.8144, "txd:brsalonlimit"); // пусто
	TextDrawTextSize(avtsln_TD[7], 129.0000, 25.0000);
	TextDrawAlignment(avtsln_TD[7], 1);
	TextDrawColor(avtsln_TD[7], -1);
	TextDrawBackgroundColor(avtsln_TD[7], 255);
	TextDrawFont(avtsln_TD[7], 4);
	TextDrawSetProportional(avtsln_TD[7], 0);
	TextDrawSetShadow(avtsln_TD[7], 0);

	avtsln_TD[8] = TextDrawCreate(19.1665, 161.2221, "txd:brsaloncastom"); // пусто
	TextDrawTextSize(avtsln_TD[8], 127.0000, 88.0000);
	TextDrawAlignment(avtsln_TD[8], 1);
	TextDrawColor(avtsln_TD[8], -1);
	TextDrawBackgroundColor(avtsln_TD[8], 255);
	TextDrawFont(avtsln_TD[8], 4);
	TextDrawSetProportional(avtsln_TD[8], 0);
	TextDrawSetShadow(avtsln_TD[8], 0);

	avtsln_TD[9] = TextDrawCreate(19.5830, 223.4443, "txd:brsalonback"); //  Назад (влево) / выбор цвета транспорта
	TextDrawTextSize(avtsln_TD[9], 20.0000, 26.0000);
	TextDrawAlignment(avtsln_TD[9], 1);
	TextDrawColor(avtsln_TD[9], -1);
	TextDrawBackgroundColor(avtsln_TD[9], 255);
	TextDrawFont(avtsln_TD[9], 4);
	TextDrawSetProportional(avtsln_TD[9], 0);
	TextDrawSetShadow(avtsln_TD[9], 0);
	TextDrawSetSelectable(avtsln_TD[9], true);

	avtsln_TD[10] = TextDrawCreate(125.4163, 223.4443, "txd:brsalonnext"); // Вперёд (вправо) / выбор цвета транспорта
	TextDrawTextSize(avtsln_TD[10], 20.0000, 26.0000);
	TextDrawAlignment(avtsln_TD[10], 1);
	TextDrawColor(avtsln_TD[10], -1);
	TextDrawBackgroundColor(avtsln_TD[10], 255);
	TextDrawFont(avtsln_TD[10], 4);
	TextDrawSetProportional(avtsln_TD[10], 0);
	TextDrawSetShadow(avtsln_TD[10], 0);
	TextDrawSetSelectable(avtsln_TD[10], true);

	avtsln_TD[11] = TextDrawCreate(19.5830, 192.3332, "txd:brsalonback"); // Назад (влево) / выбор цвета дисков транспорта
	TextDrawTextSize(avtsln_TD[11], 20.0000, 26.0000);
	TextDrawAlignment(avtsln_TD[11], 1);
	TextDrawColor(avtsln_TD[11], -1);
	TextDrawBackgroundColor(avtsln_TD[11], 255);
	TextDrawFont(avtsln_TD[11], 4);
	TextDrawSetProportional(avtsln_TD[11], 0);
	TextDrawSetShadow(avtsln_TD[11], 0);
	TextDrawSetSelectable(avtsln_TD[11], true);

	avtsln_TD[12] = TextDrawCreate(125.4163, 192.3332, "txd:brsalonnext"); // Вперёд (вправо) / выбор цвета дисков транспорта
	TextDrawTextSize(avtsln_TD[12], 20.0000, 26.0000);
	TextDrawAlignment(avtsln_TD[12], 1);
	TextDrawColor(avtsln_TD[12], -1);
	TextDrawBackgroundColor(avtsln_TD[12], 255);
	TextDrawFont(avtsln_TD[12], 4);
	TextDrawSetProportional(avtsln_TD[12], 0);
	TextDrawSetShadow(avtsln_TD[12], 0);
	TextDrawSetSelectable(avtsln_TD[12], true);
	autosalon_color_TD[0] = TextDrawCreate(444.9995, 116.1733, "txd:autosalon_color"); // пусто
	TextDrawTextSize(autosalon_color_TD[0], 189.0000, 238.0000);
	TextDrawAlignment(autosalon_color_TD[0], 1);
	TextDrawColor(autosalon_color_TD[0], -1);
	TextDrawBackgroundColor(autosalon_color_TD[0], 255);
	TextDrawFont(autosalon_color_TD[0], 4);
	TextDrawSetProportional(autosalon_color_TD[0], 0);
	TextDrawSetShadow(autosalon_color_TD[0], 0);

	autosalon_color_TD[1] = TextDrawCreate(464.9999, 201.7911, "color_1"); // пусто
	TextDrawTextSize(autosalon_color_TD[1], 26.0000, 31.0000);
	TextDrawAlignment(autosalon_color_TD[1], 1);
	TextDrawColor(autosalon_color_TD[1], -1);
	TextDrawBackgroundColor(autosalon_color_TD[1], 255);
	TextDrawFont(autosalon_color_TD[1], 4);
	TextDrawSetProportional(autosalon_color_TD[1], 0);
	TextDrawSetShadow(autosalon_color_TD[1], 0);
	TextDrawSetSelectable(autosalon_color_TD[1], true);

	autosalon_color_TD[2] = TextDrawCreate(506.1998, 202.2889, "color_2"); // пусто
	TextDrawTextSize(autosalon_color_TD[2], 26.0000, 31.0000);
	TextDrawAlignment(autosalon_color_TD[2], 1);
	TextDrawColor(autosalon_color_TD[2], -1);
	TextDrawBackgroundColor(autosalon_color_TD[2], 255);
	TextDrawFont(autosalon_color_TD[2], 4);
	TextDrawSetProportional(autosalon_color_TD[2], 0);
	TextDrawSetShadow(autosalon_color_TD[2], 0);
	TextDrawSetSelectable(autosalon_color_TD[2], true);

	autosalon_color_TD[3] = TextDrawCreate(546.5999, 201.7911, "color_3"); // пусто
	TextDrawTextSize(autosalon_color_TD[3], 26.0000, 31.0000);
	TextDrawAlignment(autosalon_color_TD[3], 1);
	TextDrawColor(autosalon_color_TD[3], -1);
	TextDrawBackgroundColor(autosalon_color_TD[3], 255);
	TextDrawFont(autosalon_color_TD[3], 4);
	TextDrawSetProportional(autosalon_color_TD[3], 0);
	TextDrawSetShadow(autosalon_color_TD[3], 0);
	TextDrawSetSelectable(autosalon_color_TD[3], true);

	autosalon_color_TD[4] = TextDrawCreate(587.7998, 202.2889, "color_4"); // пусто
	TextDrawTextSize(autosalon_color_TD[4], 26.0000, 31.0000);
	TextDrawAlignment(autosalon_color_TD[4], 1);
	TextDrawColor(autosalon_color_TD[4], -1);
	TextDrawBackgroundColor(autosalon_color_TD[4], 255);
	TextDrawFont(autosalon_color_TD[4], 4);
	TextDrawSetProportional(autosalon_color_TD[4], 0);
	TextDrawSetShadow(autosalon_color_TD[4], 0);
	TextDrawSetSelectable(autosalon_color_TD[4], true);

	autosalon_color_TD[5] = TextDrawCreate(464.9998, 254.5556, "color_5"); // пусто
	TextDrawTextSize(autosalon_color_TD[5], 26.0000, 31.0000);
	TextDrawAlignment(autosalon_color_TD[5], 1);
	TextDrawColor(autosalon_color_TD[5], -1);
	TextDrawBackgroundColor(autosalon_color_TD[5], 255);
	TextDrawFont(autosalon_color_TD[5], 4);
	TextDrawSetProportional(autosalon_color_TD[5], 0);
	TextDrawSetShadow(autosalon_color_TD[5], 0);
	TextDrawSetSelectable(autosalon_color_TD[5], true);

	autosalon_color_TD[6] = TextDrawCreate(506.1997, 253.0622, "color_6"); // пусто
	TextDrawTextSize(autosalon_color_TD[6], 26.0000, 31.0000);
	TextDrawAlignment(autosalon_color_TD[6], 1);
	TextDrawColor(autosalon_color_TD[6], -1);
	TextDrawBackgroundColor(autosalon_color_TD[6], 255);
	TextDrawFont(autosalon_color_TD[6], 4);
	TextDrawSetProportional(autosalon_color_TD[6], 0);
	TextDrawSetShadow(autosalon_color_TD[6], 0);
	TextDrawSetSelectable(autosalon_color_TD[6], true);

	autosalon_color_TD[7] = TextDrawCreate(546.5999, 252.5645, "color_7"); // пусто
	TextDrawTextSize(autosalon_color_TD[7], 26.0000, 31.0000);
	TextDrawAlignment(autosalon_color_TD[7], 1);
	TextDrawColor(autosalon_color_TD[7], -1);
	TextDrawBackgroundColor(autosalon_color_TD[7], 255);
	TextDrawFont(autosalon_color_TD[7], 4);
	TextDrawSetProportional(autosalon_color_TD[7], 0);
	TextDrawSetShadow(autosalon_color_TD[7], 0);
	TextDrawSetSelectable(autosalon_color_TD[7], true);

	autosalon_color_TD[8] = TextDrawCreate(587.8002, 253.5600, "color_8"); // пусто
	TextDrawTextSize(autosalon_color_TD[8], 26.0000, 31.0000);
	TextDrawAlignment(autosalon_color_TD[8], 1);
	TextDrawColor(autosalon_color_TD[8], -1);
	TextDrawBackgroundColor(autosalon_color_TD[8], 255);
	TextDrawFont(autosalon_color_TD[8], 4);
	TextDrawSetProportional(autosalon_color_TD[8], 0);
	TextDrawSetShadow(autosalon_color_TD[8], 0);
	TextDrawSetSelectable(autosalon_color_TD[8], true);

	autosalon_select_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 297.1998, 399.5642, "BMW_X5"); // generated
	PlayerTextDrawLetterSize(playerid, autosalon_select_PTD[playerid][0], 0.3619, 1.2017);
	PlayerTextDrawAlignment(playerid, autosalon_select_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, autosalon_select_PTD[playerid][0], -2139062017);
	PlayerTextDrawBackgroundColor(playerid, autosalon_select_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, autosalon_select_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, autosalon_select_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, autosalon_select_PTD[playerid][0], 0);

    autosalon_price_TD[0] = TextDrawCreate(13.3999, 119.6577, "txd:autosalon_price"); // пусто
	TextDrawTextSize(autosalon_price_TD[0], 209.0000, 238.0000);
	TextDrawAlignment(autosalon_price_TD[0], 1);
	TextDrawColor(autosalon_price_TD[0], -1);
	TextDrawBackgroundColor(autosalon_price_TD[0], 255);
	TextDrawFont(autosalon_price_TD[0], 4);
	TextDrawSetProportional(autosalon_price_TD[0], 0);
	TextDrawSetShadow(autosalon_price_TD[0], 0);

	autosalon_price_TD[1] = TextDrawCreate(28.9999, 258.5378, "autosalon_buy"); // пусто
	TextDrawTextSize(autosalon_price_TD[1], 80.0000, 34.0000);
	TextDrawAlignment(autosalon_price_TD[1], 1);
	TextDrawColor(autosalon_price_TD[1], -1);
	TextDrawBackgroundColor(autosalon_price_TD[1], 255);
	TextDrawFont(autosalon_price_TD[1], 4);
	TextDrawSetProportional(autosalon_price_TD[1], 0);
	TextDrawSetShadow(autosalon_price_TD[1], 0);
	TextDrawSetSelectable(autosalon_price_TD[1], true);

	autosalon_price_TD[2] = TextDrawCreate(126.5999, 258.5378, "autosalon_exit"); // пусто
	TextDrawTextSize(autosalon_price_TD[2], 80.0000, 34.0000);
	TextDrawAlignment(autosalon_price_TD[2], 1);
	TextDrawColor(autosalon_price_TD[2], -1);
	TextDrawBackgroundColor(autosalon_price_TD[2], 255);
	TextDrawFont(autosalon_price_TD[2], 4);
	TextDrawSetProportional(autosalon_price_TD[2], 0);
	TextDrawSetShadow(autosalon_price_TD[2], 0);
	TextDrawSetSelectable(autosalon_price_TD[2], true);

	autosalon_price_PTD[playerid][0] = CreatePlayerTextDraw(playerid, 89.6000, 214.3911, "25000000_P"); // пусто
	PlayerTextDrawLetterSize(playerid, autosalon_price_PTD[playerid][0], 0.3615, 1.4805);
	PlayerTextDrawTextSize(playerid, autosalon_price_PTD[playerid][0], -20.0000, 0.0000);
	PlayerTextDrawAlignment(playerid, autosalon_price_PTD[playerid][0], 1);
	PlayerTextDrawColor(playerid, autosalon_price_PTD[playerid][0], 8388863);
	PlayerTextDrawBackgroundColor(playerid, autosalon_price_PTD[playerid][0], 255);
	PlayerTextDrawFont(playerid, autosalon_price_PTD[playerid][0], 1);
	PlayerTextDrawSetProportional(playerid, autosalon_price_PTD[playerid][0], 1);
	PlayerTextDrawSetShadow(playerid, autosalon_price_PTD[playerid][0], 0);

    autosalon_select_TD[0] = TextDrawCreate(180.9997, 227.6753, "txd:autosalon_input"); // пусто
	TextDrawTextSize(autosalon_select_TD[0], 278.0000, 338.0000);
	TextDrawAlignment(autosalon_select_TD[0], 1);
	TextDrawColor(autosalon_select_TD[0], -1);
	TextDrawBackgroundColor(autosalon_select_TD[0], 255);
	TextDrawFont(autosalon_select_TD[0], 4);
	TextDrawSetProportional(autosalon_select_TD[0], 0);
	TextDrawSetShadow(autosalon_select_TD[0], 0);

	autosalon_select_TD[1] = TextDrawCreate(192.2000, 370.0401, "input_1"); // пусто
	TextDrawTextSize(autosalon_select_TD[1], 42.0000, 53.0000);
	TextDrawAlignment(autosalon_select_TD[1], 1);
	TextDrawColor(autosalon_select_TD[1], -1);
	TextDrawBackgroundColor(autosalon_select_TD[1], 255);
	TextDrawFont(autosalon_select_TD[1], 4);
	TextDrawSetProportional(autosalon_select_TD[1], 0);
	TextDrawSetShadow(autosalon_select_TD[1], 0);
	TextDrawSetSelectable(autosalon_select_TD[1], true);

	autosalon_select_TD[2] = TextDrawCreate(406.2001, 368.5469, "input_2"); // пусто
	TextDrawTextSize(autosalon_select_TD[2], 42.0000, 53.0000);
	TextDrawAlignment(autosalon_select_TD[2], 1);
	TextDrawColor(autosalon_select_TD[2], -1);
	TextDrawBackgroundColor(autosalon_select_TD[2], 255);
	TextDrawFont(autosalon_select_TD[2], 4);
	TextDrawSetProportional(autosalon_select_TD[2], 0);
	TextDrawSetShadow(autosalon_select_TD[2], 0);
	TextDrawSetSelectable(autosalon_select_TD[2], true);

	gps_on_TD[0] = TextDrawCreate(485.3998, 94.2711, "txd:gps_on"); // generated
	TextDrawTextSize(gps_on_TD[0], 146.0000, 193.0000);
	TextDrawAlignment(gps_on_TD[0], 1);
	TextDrawColor(gps_on_TD[0], -1);
	TextDrawBackgroundColor(gps_on_TD[0], 255);
	TextDrawFont(gps_on_TD[0], 4);
	TextDrawSetProportional(gps_on_TD[0], 0);
	TextDrawSetShadow(gps_on_TD[0], 0);

	stop_anim_TD[0] = TextDrawCreate(263.3999, 347.1419, "txd:stop_anim"); // generated
	TextDrawTextSize(stop_anim_TD[0], 114.0000, 154.0000);
	TextDrawAlignment(stop_anim_TD[0], 1);
	TextDrawColor(stop_anim_TD[0], -1);
	TextDrawBackgroundColor(stop_anim_TD[0], 255);
	TextDrawFont(stop_anim_TD[0], 4);
	TextDrawSetProportional(stop_anim_TD[0], 0);
	TextDrawSetShadow(stop_anim_TD[0], 0);
	TextDrawSetSelectable(stop_anim_TD[0], true);
	
	select_TD[0] = TextDrawCreate(229.575424, 395.499969, "<<");
	TextDrawLetterSize(select_TD[0], 0.449999, 1.600000);
	TextDrawTextSize(select_TD[0], 229.000 + 20, 18.000);
	TextDrawAlignment(select_TD[0], 1);
	TextDrawColor(select_TD[0], -1);
	TextDrawSetShadow(select_TD[0], 0);
	TextDrawSetOutline(select_TD[0], 1);
	TextDrawBackgroundColor(select_TD[0], 51);
	TextDrawFont(select_TD[0], 1);
	TextDrawSetProportional(select_TD[0], 1);
	TextDrawSetSelectable(select_TD[0], true);

	select_TD[1] = TextDrawCreate(407.613922, 395.499969, ">>");
	TextDrawLetterSize(select_TD[1], 0.449999, 1.600000);
	TextDrawTextSize(select_TD[1], 407.000 + 20, 18.000);
	TextDrawAlignment(select_TD[1], 3);
	TextDrawColor(select_TD[1], -1);
	TextDrawSetShadow(select_TD[1], 0);
	TextDrawSetOutline(select_TD[1], 1);
	TextDrawBackgroundColor(select_TD[1], 51);
	TextDrawFont(select_TD[1], 3);
	TextDrawSetProportional(select_TD[1], 1);
	TextDrawSetSelectable(select_TD[1], true);

	select_TD[2] = TextDrawCreate(285.798065, 395.499969, "SELECT");
	TextDrawLetterSize(select_TD[2], 0.449999, 1.600000);
	TextDrawTextSize(select_TD[2], 285.000 + 65, 14.000);
	TextDrawAlignment(select_TD[2], 1);
	TextDrawColor(select_TD[2], -1);
	TextDrawSetShadow(select_TD[2], 0);
	TextDrawSetOutline(select_TD[2], 1);
	TextDrawBackgroundColor(select_TD[2], 51);
	TextDrawFont(select_TD[2], 2);
	TextDrawSetProportional(select_TD[2], 1);
	TextDrawSetSelectable(select_TD[2], true);

	select_TD[3] = TextDrawCreate(585.182983, 159.250045, "EXIT");
	TextDrawLetterSize(select_TD[3], 0.449999, 1.600000);
	TextDrawTextSize(select_TD[3], 585.000 + 30, 14.000);
	TextDrawAlignment(select_TD[3], 1);
	TextDrawColor(select_TD[3], -16776961);
	TextDrawSetShadow(select_TD[3], 0);
	TextDrawSetOutline(select_TD[3], 1);
	TextDrawBackgroundColor(select_TD[3], 51);
	TextDrawFont(select_TD[3], 2);
	TextDrawSetProportional(select_TD[3], 1);
	TextDrawSetSelectable(select_TD[3], true);

	select_TD[4] = TextDrawCreate(630.755493, 158.416656, "usebox");
	TextDrawLetterSize(select_TD[4], 0.000000, 1.498149);
	TextDrawTextSize(select_TD[4], 578.497802, 0.000000);
	TextDrawAlignment(select_TD[4], 1);
	TextDrawColor(select_TD[4], 0);
	TextDrawUseBox(select_TD[4], true);
	TextDrawBoxColor(select_TD[4], 102);
	TextDrawSetShadow(select_TD[4], 0);
	TextDrawSetOutline(select_TD[4], 0);
	TextDrawFont(select_TD[4], 0);

	select_TD[5] = TextDrawCreate(229.701324, 401.083312, "usebox");
	TextDrawLetterSize(select_TD[5], 0.000000, 0.201854);
	TextDrawTextSize(select_TD[5], 406.082000, 0.000000);
	TextDrawAlignment(select_TD[5], 1);
	TextDrawColor(select_TD[5], 0);
	TextDrawUseBox(select_TD[5], true);
	TextDrawBoxColor(select_TD[5], 102);
	TextDrawSetShadow(select_TD[5], 0);
	TextDrawSetOutline(select_TD[5], 0);
	TextDrawFont(select_TD[5], 0);
//

	buy_car_TD[0] = TextDrawCreate(626.000000, 134.406661, "usebox");
	TextDrawLetterSize(buy_car_TD[0], 0.110399, 9.810622);
	TextDrawTextSize(buy_car_TD[0], 442.000000, 0.000000);
	TextDrawAlignment(buy_car_TD[0], 1);
	TextDrawColor(buy_car_TD[0], 0);
	TextDrawUseBox(buy_car_TD[0], true);
	TextDrawBoxColor(buy_car_TD[0], 102);
	TextDrawSetShadow(buy_car_TD[0], 0);
	TextDrawSetOutline(buy_car_TD[0], 0);
	TextDrawFont(buy_car_TD[0], 0);

	buy_car_TD[1] = TextDrawCreate(626.000000, 226.406677, "usebox");
	TextDrawLetterSize(buy_car_TD[1], 0.110399, 6.765620);
	TextDrawTextSize(buy_car_TD[1], 442.000000, 0.000000);
	TextDrawAlignment(buy_car_TD[1], 1);
	TextDrawColor(buy_car_TD[1], 0);
	TextDrawUseBox(buy_car_TD[1], true);
	TextDrawBoxColor(buy_car_TD[1], 102);
	TextDrawSetShadow(buy_car_TD[1], 0);
	TextDrawSetOutline(buy_car_TD[1], 0);
	TextDrawFont(buy_car_TD[1], 0);

	capture_TD[0] = TextDrawCreate(170.444442, 260.842224, "usebox");
	TextDrawLetterSize(capture_TD[0], 0.000000, 4.293703);
	TextDrawTextSize(capture_TD[0], -0.222222, 0.000000);
	TextDrawAlignment(capture_TD[0], 1);
	TextDrawColor(capture_TD[0], 0);
	TextDrawUseBox(capture_TD[0], true);
	TextDrawBoxColor(capture_TD[0], 102);
	TextDrawSetShadow(capture_TD[0], 0);
	TextDrawSetOutline(capture_TD[0], 0);
	TextDrawFont(capture_TD[0], 0);

	capture_TD[1] = TextDrawCreate(3.555550, 260.337829, "_");
	TextDrawLetterSize(capture_TD[1], 0.410000, 1.380977);
	TextDrawAlignment(capture_TD[1], 1);
	TextDrawColor(capture_TD[1], 13369599);
	TextDrawSetShadow(capture_TD[1], 0);
	TextDrawSetOutline(capture_TD[1], 1);
	TextDrawBackgroundColor(capture_TD[1], 255);
	TextDrawFont(capture_TD[1], 1);
	TextDrawSetProportional(capture_TD[1], 1);

	green_zone_TD[0] = TextDrawCreate(4.6000, 187.8533, "txd:green_zone"); // generated
	TextDrawTextSize(green_zone_TD[0], 143.0000, 174.0000);
	TextDrawAlignment(green_zone_TD[0], 1);
	TextDrawColor(green_zone_TD[0], -1);
	TextDrawBackgroundColor(green_zone_TD[0], 255);
	TextDrawFont(green_zone_TD[0], 4);
	TextDrawSetProportional(green_zone_TD[0], 0);
	TextDrawSetShadow(green_zone_TD[0], 0);

	radio_edit_TD = TextDrawCreate(9.838958, 385.000122, "_");
	TextDrawLetterSize(radio_edit_TD, 0.362385, 1.605833);
	TextDrawTextSize(radio_edit_TD, -0.468522, -161.583328);
	TextDrawAlignment(radio_edit_TD, 1);
	TextDrawColor(radio_edit_TD, -1);
	TextDrawSetShadow(radio_edit_TD, 0);
	TextDrawSetOutline(radio_edit_TD, 1);
	TextDrawBackgroundColor(radio_edit_TD, 255);
	TextDrawFont(radio_edit_TD, 1);
	TextDrawSetProportional(radio_edit_TD, 1);

	change_color_TD[0] = TextDrawCreate(434.889099, 332.522338, "usebox");
	TextDrawLetterSize(change_color_TD[0], 0.000000, 9.385062);
	TextDrawTextSize(change_color_TD[0], 207.777801, 0.000000);
	TextDrawAlignment(change_color_TD[0], 1);
	TextDrawColor(change_color_TD[0], 0);
	TextDrawUseBox(change_color_TD[0], true);
	TextDrawBoxColor(change_color_TD[0], 102);
	TextDrawSetShadow(change_color_TD[0], 0);
	TextDrawSetOutline(change_color_TD[0], 0);
	TextDrawFont(change_color_TD[0], 0);

	change_color_TD[1] = TextDrawCreate(434.000000, 333.517761, "usebox");
	TextDrawLetterSize(change_color_TD[1], 0.000000, 1.121358);
	TextDrawTextSize(change_color_TD[1], 208.666671, 0.000000);
	TextDrawAlignment(change_color_TD[1], 1);
	TextDrawColor(change_color_TD[1], 0);
	TextDrawUseBox(change_color_TD[1], true);
	TextDrawBoxColor(change_color_TD[1], 865730389);
	TextDrawSetShadow(change_color_TD[1], 0);
	TextDrawSetOutline(change_color_TD[1], 0);
	TextDrawFont(change_color_TD[1], 0);

	change_color_TD[2] = TextDrawCreate(322.222564, 333.511169, "Перекраска транспорта");
	TextDrawLetterSize(change_color_TD[2], 0.219777, 1.077329);
	TextDrawAlignment(change_color_TD[2], 2);
	TextDrawColor(change_color_TD[2], -1);
	TextDrawSetShadow(change_color_TD[2], 1);
	TextDrawSetOutline(change_color_TD[2], 0);
	TextDrawBackgroundColor(change_color_TD[2], 51);
	TextDrawFont(change_color_TD[2], 2);
	TextDrawSetProportional(change_color_TD[2], 1);

	change_color_TD[3] = TextDrawCreate(321.778656, 402.717987, "usebox");
	TextDrawLetterSize(change_color_TD[3], 0.000000, 1.453209);
	TextDrawTextSize(change_color_TD[3], 208.666885, 0.000000);
	TextDrawAlignment(change_color_TD[3], 1);
	TextDrawColor(change_color_TD[3], 0);
	TextDrawUseBox(change_color_TD[3], true);
	TextDrawBoxColor(change_color_TD[3], 1724658517);
	TextDrawSetShadow(change_color_TD[3], 0);
	TextDrawSetOutline(change_color_TD[3], 0);
	TextDrawBackgroundColor(change_color_TD[3], 1714657791);
	TextDrawFont(change_color_TD[3], 0);
	TextDrawSetSelectable(change_color_TD[3], true);

	change_color_TD[4] = TextDrawCreate(433.889801, 402.722534, "usebox");
	TextDrawLetterSize(change_color_TD[4], 0.000000, 1.453209);
	TextDrawTextSize(change_color_TD[4], 319.333526, 0.000000);
	TextDrawAlignment(change_color_TD[4], 1);
	TextDrawColor(change_color_TD[4], 0);
	TextDrawUseBox(change_color_TD[4], true);
	TextDrawBoxColor(change_color_TD[4], -11193515);
	TextDrawSetShadow(change_color_TD[4], 0);
	TextDrawSetOutline(change_color_TD[4], 0);
	TextDrawFont(change_color_TD[4], 0);
	TextDrawSetSelectable(change_color_TD[4], true);

	change_color_TD[5] = TextDrawCreate(265.110870, 404.222503, "Выбрать");
	TextDrawLetterSize(change_color_TD[5], 0.222444, 1.052441);
	TextDrawAlignment(change_color_TD[5], 2);
	TextDrawColor(change_color_TD[5], -1);
	TextDrawSetShadow(change_color_TD[5], 1);
	TextDrawSetOutline(change_color_TD[5], 0);
	TextDrawBackgroundColor(change_color_TD[5], 51);
	TextDrawFont(change_color_TD[5], 2);
	TextDrawSetProportional(change_color_TD[5], 1);
	

zakaz7_TD[0] = TextDrawCreate(-1.3999, 309.5602, "zakazzahvat:zakaz"); // пусто 
TextDrawTextSize(zakaz7_TD[0], 142.0000, 65.0000); 
TextDrawAlignment(zakaz7_TD[0], 1); 
TextDrawColor(zakaz7_TD[0], -1); 
TextDrawBackgroundColor(zakaz7_TD[0], 255); 
TextDrawFont(zakaz7_TD[0], 4); 
TextDrawSetProportional(zakaz7_TD[0], 0); 
TextDrawSetShadow(zakaz7_TD[0], 0); 
 
zakaz7_TD[1] = TextDrawCreate(117.9999, 334.1066, "0"); // пусто 
TextDrawLetterSize(zakaz7_TD[1], 0.3079, 1.3162); 
TextDrawAlignment(zakaz7_TD[1], 1); 
TextDrawColor(zakaz7_TD[1], -1); 
TextDrawBackgroundColor(zakaz7_TD[1], 255); 
TextDrawFont(zakaz7_TD[1], 1); 
TextDrawSetProportional(zakaz7_TD[1], 1); 
TextDrawSetShadow(zakaz7_TD[1], 0); 
 
zakaz7_TD[2] = TextDrawCreate(84.3999, 350.7601, "0"); // пусто 
TextDrawLetterSize(zakaz7_TD[2], 0.2910, 1.0922); 
TextDrawAlignment(zakaz7_TD[2], 1); 
TextDrawColor(zakaz7_TD[2], -1); 
TextDrawBackgroundColor(zakaz7_TD[2], 255); 
TextDrawFont(zakaz7_TD[2], 1); 
TextDrawSetProportional(zakaz7_TD[2], 1); 
TextDrawSetShadow(zakaz7_TD[2], 0); 
 
zakaz7_TD[3] = TextDrawCreate(73.1998, 350.7601, "9:"); // пусто 
TextDrawLetterSize(zakaz7_TD[3], 0.2910, 1.0922); 
TextDrawAlignment(zakaz7_TD[3], 1); 
TextDrawColor(zakaz7_TD[3], -1); 
TextDrawBackgroundColor(zakaz7_TD[3], 255); 
TextDrawFont(zakaz7_TD[3], 1); 
TextDrawSetProportional(zakaz7_TD[3], 1); 
TextDrawSetShadow(zakaz7_TD[3], 0); 
	zakaz6_TD[0] = TextDrawCreate(-1.3999, 309.5602, "zakazzahvat:zakaz"); // пусто 
TextDrawTextSize(zakaz6_TD[0], 142.0000, 65.0000); 
TextDrawAlignment(zakaz6_TD[0], 1); 
TextDrawColor(zakaz6_TD[0], -1); 
TextDrawBackgroundColor(zakaz6_TD[0], 255); 
TextDrawFont(zakaz6_TD[0], 4); 
TextDrawSetProportional(zakaz6_TD[0], 0); 
TextDrawSetShadow(zakaz6_TD[0], 0); 
 
zakaz6_TD[1] = TextDrawCreate(117.9999, 334.1066, "0"); // пусто 
TextDrawLetterSize(zakaz6_TD[1], 0.3079, 1.3162); 
TextDrawAlignment(zakaz6_TD[1], 1); 
TextDrawColor(zakaz6_TD[1], -1); 
TextDrawBackgroundColor(zakaz6_TD[1], 255); 
TextDrawFont(zakaz6_TD[1], 1); 
TextDrawSetProportional(zakaz6_TD[1], 1); 
TextDrawSetShadow(zakaz6_TD[1], 0); 
 
zakaz6_TD[2] = TextDrawCreate(84.3999, 350.7601, "0"); // пусто 
TextDrawLetterSize(zakaz6_TD[2], 0.2910, 1.0922); 
TextDrawAlignment(zakaz6_TD[2], 1); 
TextDrawColor(zakaz6_TD[2], -1); 
TextDrawBackgroundColor(zakaz6_TD[2], 255); 
TextDrawFont(zakaz6_TD[2], 1); 
TextDrawSetProportional(zakaz6_TD[2], 1); 
TextDrawSetShadow(zakaz6_TD[2], 0); 
 
zakaz6_TD[3] = TextDrawCreate(73.1998, 350.7601, "9:"); // пусто 
TextDrawLetterSize(zakaz6_TD[3], 0.2910, 1.0922); 
TextDrawAlignment(zakaz6_TD[3], 1); 
TextDrawColor(zakaz6_TD[3], -1); 
TextDrawBackgroundColor(zakaz6_TD[3], 255); 
TextDrawFont(zakaz6_TD[3], 1); 
TextDrawSetProportional(zakaz6_TD[3], 1); 
TextDrawSetShadow(zakaz6_TD[3], 0); 
	zakaz5_TD[0] = TextDrawCreate(-1.3999, 309.5602, "zakazzahvat:zakaz"); // пусто 
TextDrawTextSize(zakaz5_TD[0], 142.0000, 65.0000); 
TextDrawAlignment(zakaz5_TD[0], 1); 
TextDrawColor(zakaz5_TD[0], -1); 
TextDrawBackgroundColor(zakaz5_TD[0], 255); 
TextDrawFont(zakaz5_TD[0], 4); 
TextDrawSetProportional(zakaz5_TD[0], 0); 
TextDrawSetShadow(zakaz5_TD[0], 0); 
 
zakaz5_TD[1] = TextDrawCreate(117.9999, 334.1066, "0"); // пусто 
TextDrawLetterSize(zakaz5_TD[1], 0.3079, 1.3162); 
TextDrawAlignment(zakaz5_TD[1], 1); 
TextDrawColor(zakaz5_TD[1], -1); 
TextDrawBackgroundColor(zakaz5_TD[1], 255); 
TextDrawFont(zakaz5_TD[1], 1); 
TextDrawSetProportional(zakaz5_TD[1], 1); 
TextDrawSetShadow(zakaz5_TD[1], 0); 
 
zakaz5_TD[2] = TextDrawCreate(84.3999, 350.7601, "0"); // пусто 
TextDrawLetterSize(zakaz5_TD[2], 0.2910, 1.0922); 
TextDrawAlignment(zakaz5_TD[2], 1); 
TextDrawColor(zakaz5_TD[2], -1); 
TextDrawBackgroundColor(zakaz5_TD[2], 255); 
TextDrawFont(zakaz5_TD[2], 1); 
TextDrawSetProportional(zakaz5_TD[2], 1); 
TextDrawSetShadow(zakaz5_TD[2], 0); 
 
zakaz5_TD[3] = TextDrawCreate(73.1998, 350.7601, "9:"); // пусто 
TextDrawLetterSize(zakaz5_TD[3], 0.2910, 1.0922); 
TextDrawAlignment(zakaz5_TD[3], 1); 
TextDrawColor(zakaz5_TD[3], -1); 
TextDrawBackgroundColor(zakaz5_TD[3], 255); 
TextDrawFont(zakaz5_TD[3], 1); 
TextDrawSetProportional(zakaz5_TD[3], 1); 
TextDrawSetShadow(zakaz5_TD[3], 0); 
	zakaz4_TD[0] = TextDrawCreate(-1.3999, 309.5602, "zakazzahvat:zakaz"); // пусто 
TextDrawTextSize(zakaz4_TD[0], 142.0000, 65.0000); 
TextDrawAlignment(zakaz4_TD[0], 1); 
TextDrawColor(zakaz4_TD[0], -1); 
TextDrawBackgroundColor(zakaz4_TD[0], 255); 
TextDrawFont(zakaz4_TD[0], 4); 
TextDrawSetProportional(zakaz4_TD[0], 0); 
TextDrawSetShadow(zakaz4_TD[0], 0); 
 
zakaz4_TD[1] = TextDrawCreate(117.9999, 334.1066, "0"); // пусто 
TextDrawLetterSize(zakaz4_TD[1], 0.3079, 1.3162); 
TextDrawAlignment(zakaz4_TD[1], 1); 
TextDrawColor(zakaz4_TD[1], -1); 
TextDrawBackgroundColor(zakaz4_TD[1], 255); 
TextDrawFont(zakaz4_TD[1], 1); 
TextDrawSetProportional(zakaz4_TD[1], 1); 
TextDrawSetShadow(zakaz4_TD[1], 0); 
 
zakaz4_TD[2] = TextDrawCreate(84.3999, 350.7601, "0"); // пусто 
TextDrawLetterSize(zakaz4_TD[2], 0.2910, 1.0922); 
TextDrawAlignment(zakaz4_TD[2], 1); 
TextDrawColor(zakaz4_TD[2], -1); 
TextDrawBackgroundColor(zakaz4_TD[2], 255); 
TextDrawFont(zakaz4_TD[2], 1); 
TextDrawSetProportional(zakaz4_TD[2], 1); 
TextDrawSetShadow(zakaz4_TD[2], 0); 
 
zakaz4_TD[3] = TextDrawCreate(73.1998, 350.7601, "9:"); // пусто 
TextDrawLetterSize(zakaz4_TD[3], 0.2910, 1.0922); 
TextDrawAlignment(zakaz4_TD[3], 1); 
TextDrawColor(zakaz4_TD[3], -1); 
TextDrawBackgroundColor(zakaz4_TD[3], 255); 
TextDrawFont(zakaz4_TD[3], 1); 
TextDrawSetProportional(zakaz4_TD[3], 1); 
TextDrawSetShadow(zakaz4_TD[3], 0); 
	// Глобальные текстдравы 
zakaz3_TD[0] = TextDrawCreate(-1.3999, 309.5602, "zakazzahvat:zakaz"); // пусто 
TextDrawTextSize(zakaz3_TD[0], 142.0000, 65.0000); 
TextDrawAlignment(zakaz3_TD[0], 1); 
TextDrawColor(zakaz3_TD[0], -1); 
TextDrawBackgroundColor(zakaz3_TD[0], 255); 
TextDrawFont(zakaz3_TD[0], 4); 
TextDrawSetProportional(zakaz3_TD[0], 0); 
TextDrawSetShadow(zakaz3_TD[0], 0); 
 
zakaz3_TD[1] = TextDrawCreate(117.9999, 334.1066, "0"); // пусто 
TextDrawLetterSize(zakaz3_TD[1], 0.3079, 1.3162); 
TextDrawAlignment(zakaz3_TD[1], 1); 
TextDrawColor(zakaz3_TD[1], -1); 
TextDrawBackgroundColor(zakaz3_TD[1], 255); 
TextDrawFont(zakaz3_TD[1], 1); 
TextDrawSetProportional(zakaz3_TD[1], 1); 
TextDrawSetShadow(zakaz3_TD[1], 0); 
 
zakaz3_TD[2] = TextDrawCreate(84.3999, 350.7601, "0"); // пусто 
TextDrawLetterSize(zakaz3_TD[2], 0.2910, 1.0922); 
TextDrawAlignment(zakaz3_TD[2], 1); 
TextDrawColor(zakaz3_TD[2], -1); 
TextDrawBackgroundColor(zakaz3_TD[2], 255); 
TextDrawFont(zakaz3_TD[2], 1); 
TextDrawSetProportional(zakaz3_TD[2], 1); 
TextDrawSetShadow(zakaz3_TD[2], 0); 
 
zakaz3_TD[3] = TextDrawCreate(73.1998, 350.7601, "9:"); // пусто 
TextDrawLetterSize(zakaz3_TD[3], 0.2910, 1.0922); 
TextDrawAlignment(zakaz3_TD[3], 1); 
TextDrawColor(zakaz3_TD[3], -1); 
TextDrawBackgroundColor(zakaz3_TD[3], 255); 
TextDrawFont(zakaz3_TD[3], 1); 
TextDrawSetProportional(zakaz3_TD[3], 1); 
TextDrawSetShadow(zakaz3_TD[3], 0); 
 //355


	change_color_TD[6] = TextDrawCreate(377.444671, 404.715820, "Отмена");
	TextDrawLetterSize(change_color_TD[6], 0.224666, 1.012619);
	TextDrawAlignment(change_color_TD[6], 2);
	TextDrawColor(change_color_TD[6], -1);
	TextDrawSetShadow(change_color_TD[6], 1);
	TextDrawSetOutline(change_color_TD[6], 0);
	TextDrawBackgroundColor(change_color_TD[6], 51);
	TextDrawFont(change_color_TD[6], 2);
	TextDrawSetProportional(change_color_TD[6], 1);

	print("[TextDraw]: Все текстдравы созданы");
}

