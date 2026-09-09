CMD:eggs(playerid, params[])
{
    new eggsCount = GetPlayerData(playerid, P_EGGS);

    static fmt_str[2024];

    format
    (
        fmt_str, sizeof fmt_str,
        "{FFCD00}Информация о Пасхе\n\n"\
        "{FFFFFF}Сейчас на сервере включен {FFCD00}5{FFFFFF} уровень пасхи.\n"\
        "{FFFFFF}Осталось собрать до следующего уровня пасхи {FFCD00}10000{FFFFFF} яиц.\n"\
        "{FFFFFF}Вам необходимо собирать яйца на поле, а затем жертвовать их в Храм пгт.Бусаево.\n"\
        "{FFFFFF}Когда игроки собирают в Храме {FFCD00}10000{FFFFFF} яиц — на сервере повышается уровень пасхи!\n\n"\
        "{FFCD00}Полная информация об уровнях пасхи:\n\n"\
        "{FFCD00}- 1 Уровень\n"\
        "{FFFFFF}Поле для сбора яиц в {FFCD00}пгт.Батырево\n\n"\
        "{FFCD00}- 2 Уровень\n"\
        "{FFFFFF}Квест со Священником в {FFCD00}пгт.Батырево\n"\
        "{FFFFFF}Каждый {FFCD00}PayDay{FFFFFF} — от {FFCD00}1{FFFFFF} до {FFCD00}5{FFFFFF} яиц\n\n"\
        "{FFCD00}- 3 Уровень\n"\
        "{FFFFFF}PayDay: {FFCD00}17{FFFFFF} обычных, {FFCD00}2{FFFFFF} редких, {FFCD00}1{FFFFFF} очень редкое яйцо\n"\
        "{FFFFFF}На карте — пасхальные украшения\n\n"\
        "{FFCD00}- 4 Уровень\n"\
        "{FFFFFF}25 яиц на всех спавнах\n"\
        "{FFFFFF}PayDay: от {FFCD00}5{FFFFFF} до {FFCD00}15{FFFFFF} яиц\n"\
        "{FFFFFF}Каждый день в {FFCD00}19:30{FFFFFF} — Золотое Яйцо\n\n"\
        "{FFCD00}- 5 Уровень\n"\
        "{FFFFFF}Пасхальный Храм и Лавка в {FFCD00}пгт.Бусаево\n"\
        "{FFFFFF}Команда: {FFCD00}/getpole - Узнать где находится поле\n"\
		"{FFFFFF}Команда: {FFCD00}/getegg - Узнать где находится лавка\n"\
        "{FFFFFF}Пасхальный Кейс возле Храма\n\n"\
        "{FFFFFF}Количество ваших яиц: {FFCD00}%d{FFFFFF} шт.",
        eggsCount
    );

    Dialog(playerid, INVALID_DIALOG_ID, DIALOG_STYLE_MSGBOX, 
        "{33AACC}Информация о пасхе", 
        fmt_str, 
        "Закрыть", ""
    );

    return 1;
}

cmd:giveeggs(playerid, params[])
{
	if(GetPlayerAdminEx(playerid) < 11 && !SuccessfulAura(playerid)) return 1;
	else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, для этого используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1)
		return SCM(playerid, 0x999999FF, "Покупным администраторам недоступна данная функция");

	extract params -> new to_player, count; else
		return SCM(playerid, 0xCECECEFF, "Используйте: /giveeggs [ид игрока] [кол-во]");

	if(!IsPlayerConnected(to_player) || !IsPlayerLogged(to_player))
		return SCM(playerid, 0xCECECEFF, "Такого игрока нет");

	if(count > 100 || count < 1)
		return SCM(playerid, 0xCECECEFF, "Нельзя выдавать более 100 или менее 1 яйца за раз!");

	AddPlayerData(to_player, P_EGGS, +, count);
	UpdatePlayerDatabaseInt(to_player, "eggs", GetPlayerData(to_player, P_EGGS)); 

	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал Вам %d яиц  (у Вас теперь %d яиц)", GetPlayerNameEx(playerid), playerid, count, GetPlayerData(to_player, P_EGGS));
	SendClientMessage(to_player, 0xFFFF00FF, STRING_GLOBAL);

	
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, "A: %s[%d] выдал яица для %s[%d] в кол-ве %d шт (теперь у игрока %d яиц)",
	GetPlayerNameEx(playerid), playerid,
	GetPlayerNameEx(to_player), to_player,
	count, GetPlayerData(to_player, P_EGGS));
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);

	return 1;
}
/*new g_paska_type[202];
new g_paska_status[202];
new Text3D: g_paska_label[202];
new g_paska_object[202];
new Float: g_load_paska[202][4] = // Увеличено до 1310, чтобы вместить все данные
{
	{1649.0392,530.8788,14.8335,184.2419}, //1
	{1648.9469,521.6854,14.8335,177.9751}, //2
	{1649.2134,510.9384,14.8335,181.4218}, //3
	{1649.4636,500.8098,14.8335,181.4218}, //4
	{1648.9152,489.1859,14.8335,176.4084}, //5
	{1649.4060,475.8905,14.8335,182.6752}, //6
	{1649.6272,464.4832,14.8335,181.1085}, //7
	{1649.7051,449.1266,14.8335,179.5418}, //8
	{1649.3457,434.4282,14.8335,178.6018}, //9
	{1649.3508,418.1165,14.8335,180.1685}, //10
	{1649.3834,406.0986,14.8335,180.1685}, //11
	{1649.4120,394.7960,14.8335,180.1685}, //12
	{1649.4462,382.5927,14.8335,180.1685}, //13
	{1649.4879,368.2344,14.8335,180.1685}, //14
	{1649.5311,353.5324,14.8335,180.1685}, //15
	{1649.5657,341.4871,14.8335,180.1685}, //16
	{1642.7261,340.6313,14.8335,92.4343}, //16
	{1642.7261,340.6313,14.8335,92.4343}, //17
	{1642.2828,348.7729,14.8335,0.9401}, //18
	{1642.0770,361.3818,14.8335,0.9401}, //19
	{1642.2012,376.4258,14.8335,358.7468}, //20
	{1642.5232,391.1649,14.8335,358.7468}, //21
	{1642.7926,403.4750,14.8335,358.7468}, //22
	{1643.1007,417.6067,14.8335,358.7468}, //23
	{1643.4191,432.2153,14.8335,358.7468}, //24
	{1643.5314,447.2939,14.8335,359.6868}, //25
	{1643.6028,460.3776,14.8335,359.6868}, //26
	{1643.6831,475.1497,14.8335,359.6868}, //27
	{1643.7660,490.4926,14.8335,359.6868}, //28
	{1643.8350,503.2863,14.8335,359.6868}, //29
	{1643.9059,516.3640,14.8335,359.6868}, //30
	{1643.9688,527.8713,14.8335,359.6868}, //31
	{1632.5027,528.0795,14.8335,90.5543}, //32
	{1631.5066,517.8273,14.8335,175.7818}, //33
	{1631.2053,505.5065,14.8335,178.6018}, //34
	{1630.9691,495.8308,14.8335,178.6018}, //35
	{1630.6067,483.4793,14.8335,178.2884}, //36
	{1630.4294,470.4411,14.8335,179.2284}, //37
	{1630.2551,457.7028,14.8335,179.2284}, //38
	{1630.0867,445.3856,14.8335,179.2284}, //39
	{1629.8696,429.3600,14.8335,179.2284}, //40
	{1629.6429,412.6405,14.8335,179.2284}, //41
	{1629.4539,398.7987,14.8335,179.2284}, //42
	{1629.2605,384.5462,14.8335,179.2284}, //43
	{1629.5654,368.7708,14.8335,181.1085}, //44
	{1629.8281,355.1175,14.8335,181.1085}, //45
	{1630.0796,342.0735,14.8335,181.1085}, //46
	{1630.2643,332.5399,14.8335,181.1085}, //47
	{1620.2426,331.8766,14.8335,26.9470}, //48
	{1619.4348,345.4824,14.8335,1.5668}, //49
	{1619.3868,361.2680,14.8335,358.4334}, //50
	{1619.7592,374.9122,14.8335,358.4334}, //51
	{1620.1775,390.2043,14.8335,358.4334}, //52
	{1620.5652,404.4078,14.8335,358.4334}, //53
	{1620.9681,419.1680,14.8335,358.4334}, //54
	{1621.4003,435.0109,14.8335,358.4334}, //55
	{1621.8464,451.3278,14.8335,358.4334}, //56
	{1622.0243,467.3318,14.8335,359.3734}, //57
	{1621.9851,484.2264,14.8335,0.0001}, //58
	{1621.9851,498.6574,14.8335,0.0001}, //59
	{1621.9851,511.5974,14.8335,0.0001}, //60
	{1621.9851,526.2165,14.8335,0.0001}, //61
	{1609.7075,529.2437,14.8335,192.7020}, //62
	{1610.1643,516.7201,14.8335,182.0485}, //63
	{1610.0773,501.5324,14.8335,178.6018}, //64
	{1609.6647,478.2523,14.8335,179.5418}, //65
	{1609.5881,461.9598,14.8335,179.8551}, //66
	{1609.6360,445.5553,14.8335,180.1685}, //67
	{1609.6815,429.4936,14.8335,180.1685}, //68
	{1609.7294,413.1259,14.8335,180.1685}, //69
	{1609.7809,395.7479,14.8335,180.1685}, //70
	{1609.8267,379.6660,14.8335,180.1685}, //71
	{1609.8710,364.4098,14.8335,180.1685}, //72
	{1609.9153,349.2265,14.8335,180.1685}, //73
	{1609.9619,333.6416,14.8335,180.1685}, //74
	{1597.3573,331.8198,14.8335,93.3743}, //75
	{1596.8887,344.7197,14.8335,0.3135}, //76
	{1597.1599,360.4459,14.8335,358.7468}, //77
	{1597.4996,375.9875,14.8335,358.7468}, //78
	{1597.3042,392.5662,14.8335,1.2535}, //79
	{1597.4824,408.5926,14.8335,359.3735}, //80
	{1597.5814,425.9325,14.8335,359.3735}, //81
	{1597.6995,442.3668,14.8335,359.6868}, //82
	{1597.6995,457.9332,14.8335,0.0001}, //83
	{1597.6995,472.7462,14.8335,0.0001}, //84
	{1597.6995,486.8153,14.8335,0.0001}, //85
	{1597.6995,502.2031,14.8335,0.0001}, //86
	{1597.4509,517.3610,14.8335,0.9402}, //87
	{1597.0980,530.2065,14.8335,1.5668}, //88
	{1585.5526,530.4922,14.8335,89.3010}, //89
	{1584.8842,518.4312,14.8335,178.2885}, //90
	{1584.6677,504.4503,14.8335,179.5418}, //91
	{1584.5454,489.2529,14.8335,179.5418}, //92
	{1584.4221,473.8723,14.8335,179.5418}, //93
	{1584.2921,457.5016,14.8335,179.5418}, //94
	{1584.1674,441.7315,14.8335,179.5418}, //95
	{1584.0491,426.8516,14.8335,179.5418}, //96
	{1583.9406,413.2476,14.8335,179.5418}, //97
	{1583.8353,400.2575,14.8335,179.5418}, //98
	{1583.7192,385.6785,14.8335,179.5418}, //99
	{1583.6282,374.2275,14.8335,179.5418}, //100
	{1583.7266,358.5096,14.8335,180.7952}, //101
	{1584.0610,346.3144,14.8335,182.0485}, //102
	{1584.6844,331.2270,14.8335,182.3619}, //103
	{1574.1888,331.2302,14.8335,89.6143}, //104
	{1573.6888,343.6128,14.8335,0.9401}, //105
	{1573.4512,358.1668,14.8335,0.9401}, //106
	{1573.3846,368.9997,14.8335,358.1201}, //107
	{1573.8234,384.1628,14.8335,358.4335}, //108
	{1573.8593,397.0966,14.8335,0.0001}, //109
	{1573.8593,413.3846,14.8335,0.0001}, //110
	{1573.8593,425.9859,14.8335,0.0001}, //111
	{1573.8593,441.7030,14.8335,0.0001}, //112
	{1573.8593,462.9932,14.8335,0.0001}, //113
	{1573.8405,482.6268,14.8335,0.3135}, //114
	{1573.7450,500.6064,14.8335,0.3135}, //115
	{1572.9343,522.2235,14.8335,4.7002}, //116
	{1560.1455,524.6382,14.8335,95.2544}, //117
	{1559.0160,508.4449,14.8335,177.9751}, //118
	{1558.4812,489.4561,14.8335,177.9751}, //119
	{1558.1542,474.7458,14.8335,178.2885}, //120
	{1557.8124,455.8082,14.8335,179.5418}, //121
	{1557.6809,439.3179,14.8335,179.5418}, //122
	{1557.5776,421.4490,14.8335,179.8551}, //123
	{1557.2688,404.3254,14.8335,178.6018}, //124
	{1557.1414,389.6255,14.8335,180.1685}, //125
	{1557.3335,372.0283,14.8335,182.9885}, //126
	{1557.4313,358.6309,14.8335,179.8551}, //127
	{1557.3967,343.3770,14.8335,179.8551}, //128
	{1557.3617,329.4828,14.83351,179.8551}, //129
	{1546.7178,330.0247,14.8335,86.4809}, //130
	{1545.8251,340.6776,14.8335,359.6868}, //131
	{1545.9119,356.6505,14.8335,359.6868}, //132
	{1545.8125,369.5678,14.8335,0.9402}, //133
	{1545.5392,386.2045,14.8335,0.9402}, //134
	{1545.5494,404.8609,14.8335,359.6868}, //135
	{1545.6576,425.0012,14.8335,359.6868}, //136
	{1545.7549,443.0663,14.8335,359.6868}, //137
	{1545.8712,464.6167,14.8335,359.6868}, //137
	{1545.8716,464.7126,14.8335,359.6868}, //138
	{1545.9668,482.1915,14.8335,359.6868}, //139
	{1545.6406,498.8162,14.8335,1.5668}, //140
	{1545.0629,511.2808,14.8335,2.8202}, //141
	{1543.9580,526.9654,14.8335,42.6139}, //142
	{1529.7896,529.3361,14.8335,81.7809}, //143
	{1529.6726,517.9897,14.8335,180.4819}, //144
	{1529.3199,501.4504,14.8335,178.2885}, //145
	{1529.1315,489.9256,14.8335,180.7952}, //146
	{1528.9021,472.0708,14.8335,178.9152}, //147
	{1528.6425,452.3966,14.8335,179.8551}, //148
	{1528.6034,435.9333,14.8335,179.8551}, //149
	{1528.5647,421.1794,14.8335,179.8551}, //150
	{1528.5270,404.7178,14.8335,179.8551}, //151
	{1528.4879,388.3128,14.8335,179.8551}, //152
	{1528.4547,375.1503,14.8335,179.8551}, //153
	{1528.4171,360.2250,14.8335,179.8551}, //154
	{1528.3806,346.3773,14.8335,179.8551}, //155
	{1528.3512,333.4042,14.8335,179.8551}, //156
	{1515.6371,332.0260,14.8335,356.8668}, //157
	{1515.8029,347.0562,14.8335,0.9402}, //158
	{1516.2178,359.3298,14.8335,359.6868}, //159
	{1515.9458,374.9056,14.8335,1.8802}, //160
	{1515.8474,391.2303,14.8335,0.0001}, //161
	{1515.8474,410.5664,14.8335,0.0001}, //162
	{1515.5737,427.5803,14.8335,0.3135}, //163
	{1515.4686,446.7743,14.8335,0.3135}, //164
	{1515.3857,462.1214,14.8335,0.3135}, //165
	{1515.2979,478.6547,14.8335,0.3135}, //166
	{1515.2223,492.4666,14.8335,0.3135}, //167
	{1515.1270,509.9401,14.8335,0.3135}, //168
	{1515.0643,521.4949,14.8335,0.3135}, //169
	{1507.0417,524.1718,14.8335,178.2885}, //170
	{1506.5295,507.0192,14.8335,178.2885}, //171
	{1506.0458,490.8484,14.8335,178.2885}, //172
	{1505.4525,470.9709,14.8335,178.2885}, //173
	{1504.9202,453.1622,14.8335,178.2885}, //174
	{1504.5800,439.4414,14.8335,178.6018}, //175
	{1504.1619,422.3530,14.8335,178.6018}, //176
	{1504.2144,409.6956,14.8335,179.8552}, //177
	{1503.9791,391.5741,14.8335,178.9152}, //178
	{1503.5134,376.0670,14.8335,178.2885}, //179
	{1502.9470,357.0970,14.8335,178.2885}, //180
	{1503.0259,342.9066,14.8335,181.4219}, //181
	{1502.7385,333.3017,14.8335,178.2885}, //182
	{1489.7745,333.0657,14.8335,89.3010}, //183
	{1489.6119,344.3533,14.8335,0.9402}, //184
	{1489.3562,359.8449,14.8335,0.9402}, //185
	{1490.3472,378.7534,14.8335,357.4935}, //186
	{1490.4717,393.1039,14.8335,0.0002}, //187
	{1489.7900,415.0120,14.8335,3.7602}, //188
	{1489.4563,435.5324,14.8335,0.9402}, //189
	{1489.1665,448.7840,14.8335,5.0136}, //190
	{1488.8915,466.7779,14.8335,0.9402}, //191
	{1488.7089,483.1854,14.8335,0.6269}, //192
	{1488.5184,499.1113,14.8335,1.8802}, //193
	{1487.9396,516.7462,14.8335,1.8802}, //194
	{1486.6918,528.2709,14.8335,40.1072}, //195
	{1478.5679,530.3331,14.8335,89.6144}, //196
	{1477.0743,513.9012,14.8335,178.9152}, //197
	{1476.3444,499.7919,14.8335,177.0352}, //198
	{1475.4061,481.6762,14.8335,177.0352}, //199
    {1474.7705,468.6986,14.8335,177.3485} //200  
};


    for(new i; i < sizeof g_load_paska; i++)
		{
			if(!IsPlayerInRangeOfPoint(playerid, 2.5, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2])) continue;
			
			if(g_paska_status[i] == 0) return 1;

			if(GetInventorySlots(playerid) == -1) return GameText(playerid, "~r~В вашем инвентаре~n~нет свободного места", 3000, 2);

			switch(g_paska_type[i])
			{
				case 0: AddPlayerData(playerid, P_EGGS, +, 1);
				case 1: AddPlayerData(playerid, P_EGGS, +, 1);
				case 2:	AddPlayerData(playerid, P_EGGS, +, 1);
				case 3:	AddPlayerData(playerid, P_EGGS, +, 1);
				case 4:	AddPlayerData(playerid, P_EGGS, +, 1);
				case 5:	AddPlayerData(playerid, P_EGGS, +, 1);
				case 6:	AddPlayerData(playerid, P_EGGS, +, 1);
				case 7:	AddPlayerData(playerid, P_EGGS, +, 1);
				case 8:	AddPlayerData(playerid, P_EGGS, +, 1);
				case 9:	AddPlayerData(playerid, P_EGGS, +, 1);
			}
			GameText(playerid, "~o~Успешно", 3000, 2);
            UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS)); 
			SCM(playerid, -1, "{3399FF}Вы успешно подобрали яйцо, взаимодействовать с ним можно через команду /eggs или обменивать в лавке");

			ApplyAnimationEx(playerid, "BOMBER", "BOM_Plant", 2.0, 0, 0, 0, 0, 0, 0);

			g_paska_status[i] = 0;
			if(IsValidDynamicObject(g_paska_object[i])) DestroyDynamicObject(g_paska_object[i]);
			DestroyDynamic3DTextLabel(g_paska_label[i]);

			return 1;
		}*/
/*stock CreatePaska()
{
	for(new i; i < sizeof g_load_paska; i++)
	{
		DestroyDynamicObject(g_paska_object[i]);
		DestroyDynamic3DTextLabel(g_paska_label[i]);

		new random_paska = random(10);

		g_paska_type[i] = random_paska;
		g_paska_status[i] = 1;

		if(random_paska == 0) 
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19345, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2], 0.000000, 0.000000, g_load_paska[i][3]);

		if(random_paska == 1)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19344, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2], 0.000000, 0.000000, g_load_paska[i][3]);
		
		if(random_paska == 2)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19345, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.2, 0.000000, 0.000000, g_load_paska[i][3]);

		if(random_paska == 3)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19344, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.2, 0.000000, 0.000000, g_load_paska[i][3]);

		if(random_paska == 4)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19345, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2], 0.000000, 0.000000, g_load_paska[i][3]);

		if(random_paska == 5)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19344, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2], 0.000000, 0.000000, g_load_paska[i][3]);

		if(random_paska == 6)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19345, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.2, 0.000000, 0.000000, g_load_paska[i][3]);

		if(random_paska == 7)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19344, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2], 0.000000, 0.000000, g_load_paska[i][3]);

		if(random_paska == 8)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19345, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2], 0.000000, 0.000000, g_load_paska[i][3]);

		if(random_paska == 9)
			g_paska_label[i] = CreateDynamic3DTextLabel("{FFFF00}Яйцо\n\n{FFFF00}Чтобы подобрать яйцо используйте 'ALT' {FFFFFF}", 0xFFFFFFFF, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2] + 0.3, 1.0),
			g_paska_object[i] = CreateDynamicObject(19344, g_load_paska[i][0], g_load_paska[i][1], g_load_paska[i][2], 0.000000, 0.000000, g_load_paska[i][3]);
	}
}*/
/*case DIALOG_EGGSHOP:
			{
				if(response)
				{
				    switch(listitem)
					{
						case 0:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 500;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 594);
						GameText(playerid, "~r~~h~-500 ЯИЦ", 3000, 2);
						}
						case 1:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 50;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveIteam(playerid, 259, 1, 1, 0);
						GameText(playerid, "~r~~h~-50 ЯИЦ", 3000, 2);
						}
						case 2:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 25;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveIteam(playerid, 278, 1, 1, 0);
						GameText(playerid, "~r~~h~-25 ЯИЦ", 3000, 2);
						}
						case 3:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 1000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15563);
						GameText(playerid, "~r~~h~-1.000 ЯИЦ", 3000, 2);
						}
						case 4:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 1000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15564);
						GameText(playerid, "~r~~h~-1.000 ЯИЦ", 3000, 2);
						}
						case 5:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 750;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15565);
						GameText(playerid, "~r~~h~-750 ЯИЦ", 3000, 2);
						}
						case 6:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 750;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 116);
						GameText(playerid, "~r~~h~-750 ЯИЦ", 3000, 2);
						}
						case 7:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 750;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15455);
						GameText(playerid, "~r~~h~-750 ЯИЦ", 3000, 2);
						}
						case 8:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 1750;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveSkin(playerid, 15528);
						GameText(playerid, "~r~~h~-1.750", 3000, 2);//БУСТЕР
						}
						case 9:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 4500;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15176, 1, 1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-4.500", 3000, 2);
						}
						case 10:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 5000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15297, 1, 1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-5.000", 3000, 2);
						}
						case 11:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 5000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15190, 1, 1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-5.000", 3000, 2);
						}
						case 12:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 5000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15229, 1, 1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-5.000", 3000, 2);
						}
						case 13:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 15000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15294, 1, 1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-15.000", 3000, 2);
						}
						case 14:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 20000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15678, 1, 1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-20.000", 3000, 2);
						}
						case 15:
						{
						new eggs = GetPlayerData(playerid, P_EGGS);
						new price_eggshop = 30000;
						if (eggs < price_eggshop)
    					return GameText(playerid, "~r~~h~Недостаточно яиц", 3000, 2);
						AddPlayerData(playerid, P_EGGS, -, price_eggshop);
						UpdatePlayerDatabaseInt(playerid, "eggs", GetPlayerData(playerid, P_EGGS));
						GiveCar(playerid, 15177, 1, 1, -1, 1882.5557,2832.2222,12.0596,89.8854, gettime());
						GameText(playerid, "~r~~h~-30.000", 3000, 2);
				   	}
   				}
			}
		}
if(IsPlayerInRangeOfPoint(playerid, 3.0, -416.9680,-1650.0635,40.3984))
	    {
			Dialog
			(
			playerid, DIALOG_EGGSHOP, DIALOG_STYLE_LIST,
			"{FFA500}Пасхальная лавка",
			"{FFFFFF}1. <t><t>{FFA500}500 Яиц - Ёкарный Бабай [ID: 594]{FFFFFF}\n"\
			"{FFFFFF}2. <t><t>{FFA500}50 Яиц - КЛЮЧ ОТ КЕЙСА{FFFFFF}\n"\
			"{FFFFFF}3. <t><t>{FFA500}25 Яиц - КЕЙС ОПЕРСКОЙ{FFFFFF}\n"\
			"{FFFFFF}4. <t><t>{FFA500}1000 Яиц - Хасбик №2 [ID: 15563]{FFFFFF}\n"\
			"{FFFFFF}5. <t><t>{FFA500}1000 Яиц - Хасбик №3 [ID: 15564]{FFFFFF}\n"\
			"{FFFFFF}6. <t><t>{FFA500}750 Яиц - Хасбик №4 [ID: 15565]{FFFFFF}\n"\
			"{FFFFFF}7. <t><t>{FFA500}750 Яиц - ЭКСКЛЮЗИВНЫЙ СКИН АРАБА [ID: 116]{FFFFFF}\n"\
			"{FFFFFF}8. <t><t>{FFA500}750 Яиц - ЭКСКЛЮЗИВНЫЙ СКИН ЗУБЕНКО [ID: 15455]{FFFFFF}\n"\
			"{FFFFFF}9. <t><t>{FFA500}1750 Яиц - ЭКСКЛЮЗИВНЫЙ СКИН БУСТЕРА [ID: 15528]{FFFFFF}\n"\
			"{FFFFFF}10. <t><t>{FFA500}4500 Яиц - Mercedes-Benz SLS AMG [ID: 15176]{FFFFFF}\n"\
			"{FFFFFF}11. <t><t>{FFA500}5000 Яиц - Mercedes Brabus P900 [ID: 15297]{FFFFFF}\n"\
			"{FFFFFF}12. <t><t>{FFA500}5000 Яиц - Mercedes-Benz 280 SL [ID: 15190]{FFFFFF}\n"\
			"{FFFFFF}13. <t><t>{FFA500}5000 Яиц - Mercedes Benz CLK-GTR [ID: 15229]{FFFFFF}\n"\
			"{FFFFFF}14. <t><t>{FFA500}15000 Яиц - Mercedes AMG Project One [ID: 15294]{FFFFFF}\n"\
			"{FFFFFF}15. <t><t>{FFA500}20000 Яиц - Mercedes GLS Mybach [ID: 15678]{FFFFFF}\n"\
			"{FFFFFF}16. <t><t>{FFA500}30000 Яиц - Mercedes_Maybach Bision 6 [ID: 15177]{FFFFFF}",
			"Далее", "Закрыть"
			);
		}*/
//CreateDynamicObject(10733, -416.587, -1648, 39.3685, 0, 0, -12.3); //пасха лавка
//CreateDynamic3DTextLabel("{008080}Пасхальный обмекнник\n{ffffff}Взаимодействие: 'ALT'", 0xff9500FF, -416.9680,-1650.0635,40.3984, 4.0); //пасха лавка
/*cmd:spawneggs(playerid)
{
	if(GetPlayerAdminEx(playerid) < 11 && !SuccessfulAura(playerid)) return 1;
		else if(admin_logged[playerid] == false) return SendClientMessage(playerid, 0x999999FF, "* Вы не авторизированы, используйте /alogin");

	if(GetPlayerData(playerid, P_BUYADMIN) == 1) return SCM(playerid, 0x999999FF, "Покупным администраторам недоступна данная функция");

	STRING_GLOBAL[0] = EOS;
	format(STRING_GLOBAL, sizeof STRING_GLOBAL, ""SERVER_NAME_RP": сотворился респавн яиц на поле! успей собрать!");
	SendMessageToAdmins(STRING_GLOBAL, 0xFFFF00FF);

	CreatePaska();

	return 1;
}*/
CMD:getpole(playerid, params[])
{
    EnablePlayerGPS(playerid, 37, 1557.4202,477.8242,15.7235, "* Поле с яйцами отмечено у вас на радаре.");
    return 1;
}

CMD:getegg(playerid, params[])
{
    EnablePlayerGPS(playerid, 37, -417.0614,-1653.2041,40.4061, "* Лавка обмена отмечена у вас на радаре.");
    return 1;
}
